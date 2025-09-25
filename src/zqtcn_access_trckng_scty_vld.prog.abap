*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ACCESS_TRCKNG_SCTY_VLD (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(MV45AFZZ)"
* PROGRAM DESCRIPTION: This enhancement will capture the online access code
* recognized by ALM in the created subscription which will be determined by
* the society and the product in the subscription.
* DEVELOPER:            Writtick Roy(WROY)
* CREATION DATE:        28-AUG-2017
* OBJECT ID:            E152 - CR#642
* TRANSPORT NUMBER(S):  ED2K908174
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*======================================================================*
* Local Types Declaration
*======================================================================*
TYPES : BEGIN OF lty_subscrptn,
          posnr TYPE posnr_va,               " Sales Document Item
          kunnr TYPE kunnr,                  " Partner Function
          matnr TYPE bu_id_number,           " Material Number
        END OF lty_subscrptn.

*======================================================================*
* Local workarea,Internal table and variable declaration
*======================================================================*
DATA:
  lst_subscrptn TYPE lty_subscrptn,
  lv_part_za    TYPE parvw, " Partner Function
  lv_part_sh    TYPE parvw, " Partner Function
  li_acs_mech   TYPE ztqtc_access_mech,
  li_constnt    TYPE zcat_constants. "Internal table for Constant Table

*======================================================================*
* Local Constants declaration
*======================================================================*
CONSTANTS:
  lc_devid_e152 TYPE zdevid       VALUE 'E152',        " Development ID
  lc_param_part TYPE rvari_vnam   VALUE 'PARTNER',     " Partner Function
  lc_param1     TYPE rvari_vnam   VALUE '001',         " Partner Function
  lc_param2     TYPE rvari_vnam   VALUE '002'.         " Partner Function

*======================================================================*
* Fetching values from ZCACONSTANT table. Retrieving the Partner Function
* values from the table and assigning it to a local variable.
*======================================================================*
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e152
  IMPORTING
    ex_constants = li_constnt.

LOOP AT li_constnt INTO DATA(lst_constnt).
  CASE lst_constnt-param2.
    WHEN lc_param1.
      lv_part_za = lst_constnt-low.
    WHEN lc_param2.
      lv_part_sh = lst_constnt-low.
  ENDCASE.
  CLEAR lst_constnt.
ENDLOOP. " LOOP AT li_constnt INTO DATA(lst_constnt)

*========================================================================*
* Fetching the values of Material Number , Customer Number with respect to
* partner function for each Subscription Order for every Item Number
*========================================================================*
lst_subscrptn-matnr = vbap-matnr.                          "Material Number

READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_xvbpa_part>)
     WITH KEY posnr = vbap-posnr
              parvw = lv_part_za.
IF sy-subrc IS INITIAL.
  lst_subscrptn-kunnr = <lst_xvbpa_part>-kunnr.            "Customer Number (Soceity Partner)
ELSE. " ELSE -> IF sy-subrc IS INITIAL
* Conversion of Partner Function 'SH' to 'WE'
  CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
    EXPORTING
      input  = lv_part_sh
    IMPORTING
      output = lv_part_sh.

  READ TABLE xvbpa ASSIGNING <lst_xvbpa_part>
       WITH KEY posnr = vbap-posnr
                parvw = lv_part_sh.
  IF sy-subrc IS INITIAL.
    lst_subscrptn-kunnr = <lst_xvbpa_part>-kunnr.           "Customer Number (Ship-to Party)
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    READ TABLE xvbpa ASSIGNING <lst_xvbpa_part>
         WITH KEY posnr = posnr_low
                  parvw = lv_part_sh.
    IF sy-subrc IS INITIAL.
      lst_subscrptn-kunnr = <lst_xvbpa_part>-kunnr.         "Customer Number (Ship-to Party)
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc IS INITIAL

* Assigning the values into a temporary Internal Table and using this
* temporary table in the next Select.
IF lst_subscrptn IS NOT INITIAL.
  CALL FUNCTION 'ZQTC_ACCESS_TRCKNG_SCTY'
    EXPORTING
      im_matnr       = lst_subscrptn-matnr
      im_kunnr       = lst_subscrptn-kunnr
    IMPORTING
      ex_access_mech = li_acs_mech.
  READ TABLE li_acs_mech TRANSPORTING NO FIELDS
       WITH KEY access_mech = vbap-zzaccess_mech.
* BINARY SEARCH is not being used, since the Internal table will have
* very limited number of entries (less than 10)
  IF sy-subrc NE 0.
*   Message: Invalid Access Mechanism!
    MESSAGE e235(zqtc_r2).
  ENDIF.
ENDIF. " IF li_subscrptn IS NOT INITIAL
