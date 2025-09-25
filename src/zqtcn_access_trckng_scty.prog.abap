*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ACCESS_TRCKNG_SCTY (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(MV45AFZZ)"
* PROGRAM DESCRIPTION: This enhancement will capture the online access code
* recognized by ALM in the created subscription which will be determined by
* the society and the product in the subscription.
* DEVELOPER:            Aratrika Banerjee(ARABANERJE)
* CREATION DATE:        17-MAR-2017
* OBJECT ID:            E152
* TRANSPORT NUMBER(S):  ED2K904991
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
        END OF lty_subscrptn,

        BEGIN OF lty_but0id,
          partner  TYPE bu_partner,          " Business Partner Number
          type     TYPE bu_id_type,
          idnumber TYPE	bu_id_number,
        END OF lty_but0id,

        BEGIN OF lty_const,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "Parameter1
          param2   TYPE rvari_vnam,          "Parameter2
          srno     TYPE tvarv_numb,          "Serial Number
          sign     TYPE tvarv_sign,          "Sign
          opti     TYPE tvarv_opti,          "Option
          low      TYPE salv_de_selopt_low,  "Low
          high     TYPE salv_de_selopt_high, "High
          activate TYPE zconstactive,        "Active/Inactive Indicator
        END OF lty_const.

*======================================================================*
* Local workarea,Internal table and variable declaration
*======================================================================*
DATA:
  lst_subscrptn TYPE lty_subscrptn,
  lst_but0id    TYPE lty_but0id,
  lv_part_za    TYPE parvw, " Partner Function
  lv_part_sh    TYPE parvw, " Partner Function
* Begin of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
  li_acs_mech   TYPE ztqtc_access_mech,
* End   of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
  li_but0id     TYPE STANDARD TABLE OF lty_but0id INITIAL SIZE 0.
STATICS:
  li_constnt    TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0. "Internal table for Constant Table

*======================================================================*
* Local Constants declaration
*======================================================================*
CONSTANTS:
  lc_devid      TYPE zdevid       VALUE 'E152',        " Development ID
  lc_param_a    TYPE rvari_vnam   VALUE 'ACCESS_MECH', " ABAP: Name of Variant Variable
  lc_param_part TYPE rvari_vnam   VALUE 'PARTNER',     " Partner Function
  lc_param1     TYPE rvari_vnam   VALUE '001',         " Partner Function
  lc_param2     TYPE rvari_vnam   VALUE '002'.         " Partner Function

* Begin of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
IF vbap-zzaccess_mech IS INITIAL.
* End   of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
*======================================================================*
* Fetching values from ZCACONSTANT table. Retrieving the Partner Function
* values from the table and assigning it to a local variable.
*======================================================================*

  IF  li_constnt IS INITIAL.
* Get data from constant table
    SELECT devid                  "Development ID
           param1                 "ABAP: Name of Variant Variable
           param2                 "ABAP: Name of Variant Variable
           srno                   "Current selection number
           sign                   "ABAP: ID: I/E (include/exclude values)
           opti                   "ABAP: Selection option (EQ/BT/CP/...)
           low                    "Lower Value of Selection Condition
           high                   "Upper Value of Selection Condition
           activate               "Activation indicator for constant
      FROM zcaconstant            "Wiley Application Constant Table
      INTO TABLE li_constnt
     WHERE devid    EQ lc_devid
       AND activate EQ abap_true. "Only active record

    IF sy-subrc IS INITIAL.
      SORT li_constnt BY devid param1 param2.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF li_constnt IS INITIAL

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
*   Begin of DEL:CR#642:WROY:23-Aug-2017:ED2K908174
*    SELECT partner   " Business Partner Number
*           type      " Identification Type
*           idnumber  " Identification Number
*      FROM but0id    " BP: ID Numbers
*      INTO TABLE li_but0id
*     WHERE partner  EQ lst_subscrptn-kunnr
*       AND idnumber EQ lst_subscrptn-matnr.
*    IF sy-subrc IS INITIAL.
*      CLEAR: lst_but0id.
*      READ TABLE li_but0id INTO lst_but0id INDEX 1.
*      IF sy-subrc EQ 0.
**========================================================================*
** Assigning the value of Access Mechanism in the Screen field
**========================================================================*
*        READ TABLE li_constnt ASSIGNING FIELD-SYMBOL(<lst_constnt>)
*             WITH KEY devid = lc_devid
*                      param1 = lc_param_a
*                      param2 = lst_but0id-type
*             BINARY SEARCH.
*        IF sy-subrc IS INITIAL.
*          vbap-zzaccess_mech = <lst_constnt>-low.
*        ENDIF. " IF sy-subrc IS INITIAL
*      ENDIF.
*    ENDIF. " IF sy-subrc IS INITIAL
*   End   of DEL:CR#642:WROY:23-Aug-2017:ED2K908174
*   Begin of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
    CALL FUNCTION 'ZQTC_ACCESS_TRCKNG_SCTY'
      EXPORTING
        im_matnr       = lst_subscrptn-matnr
        im_kunnr       = lst_subscrptn-kunnr
      IMPORTING
        ex_access_mech = li_acs_mech.
    READ TABLE li_acs_mech ASSIGNING FIELD-SYMBOL(<lst_acs_mech>) INDEX 1.
    IF sy-subrc EQ 0.
      vbap-zzaccess_mech = <lst_acs_mech>-access_mech.
    ENDIF.
*   End   of ADD:CR#642:WROY:23-Aug-2017:ED2K908174
  ENDIF. " IF li_subscrptn IS NOT INITIAL
ENDIF.
