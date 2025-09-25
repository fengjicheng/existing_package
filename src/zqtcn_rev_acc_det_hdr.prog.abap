*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_REV_ACC_DET_HDR (Include)
*               Called from "USEREXIT_ACCOUNT_PREP_KOMKCV (RV60AFZZ)"
* PROGRAM DESCRIPTION: Additional Field for Revenue Account
*                      Determination (Header fields)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/27/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K905004
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913780
* REFERENCE NO:  CR-7660
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  11/05/2018
* DESCRIPTION: Offline Account determination
*----------------------------------------------------------------------*
DATA:
  lv_str_vbak TYPE char30 VALUE '(SAPFV45P)VBAK'.

DATA:
  lst_mat_det TYPE mara,                                        "General Material Data
  lst_ord_hdr TYPE vbak.                                        "Sales Document: Header Data

FIELD-SYMBOLS:
  <lst_ord_h> TYPE vbak.                                        "Sales Document: Header Data

IF vbrp-aubel IS INITIAL.
* Sales Document: Header Data
  ASSIGN (lv_str_vbak) TO <lst_ord_h>.
  IF sy-subrc EQ 0.
    lst_ord_hdr = <lst_ord_h>.
  ENDIF.
ELSE.
* Fetch Sales Document: Header Data
  CALL FUNCTION 'SD_VBAK_SINGLE_READ'
    EXPORTING
      i_vbeln          = vbrp-aubel                             "Sales Document
    IMPORTING
      e_vbak           = lst_ord_hdr                            "Sales Document: Header Data
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    CLEAR: lst_ord_hdr.
  ENDIF.
ENDIF.

IF lst_ord_hdr IS NOT INITIAL.
  komkcv-zzauart = lst_ord_hdr-auart.                           "Sales Document Type
ENDIF.
*BOC <HIPATEL> <CR-7660> <ED2K913780> <11/05/2018>
  TYPES : BEGIN OF lty_constants,
            devid  TYPE zdevid,                                        "Devid
            param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
            srno   TYPE tvarv_numb,                                   "Current selection number
            sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
          END OF lty_constants.

 STATICS:
    li_constants  TYPE STANDARD TABLE OF lty_constants.            "Itab for constants

 DATA: lv_auart    TYPE auart,      "Document type
       lv_contract TYPE VBELN_VON.  "Contract

 CONSTANTS: "lc_wricef_id_e156 TYPE zdevid VALUE 'E156',    " Constant value for WRICEF (E156)
           lc_ordtyp1  TYPE rvari_vnam   VALUE 'ZZAUART',   " Constant Value Parameter1
           lc_ordtyp2  TYPE rvari_vnam   VALUE 'ZZAUART1',  " Constant Value Parameter1
           lc_g        TYPE VBTYP_V      VALUE 'G'.         " Document category

  IF li_constants IS INITIAL.
* Get Cnonstant values
    SELECT devid,                                                  "Devid
           param1,                                                  "ABAP: Name of Variant Variable
           param2,                                                  "ABAP: Name of Variant Variable
           srno,                                                    "Current selection number
           sign,                                                    "ABAP: ID: I/E (include/exclude values)
           opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
           low,                                                     "Lower Value of Selection Condition
           high                                                     "Upper Value of Selection Condition
      FROM zcaconstant
      INTO TABLE @li_constants
     WHERE devid    EQ @lc_wricef_id_e156                           "Development ID
       AND activate EQ @abap_true.                                  "Only active record
    IF sy-subrc = 0.
      SORT li_constants by param1 low.
    ENDIF.
  ENDIF.

*Get Contract type
  READ TABLE li_constants INTO data(lst_constants) with key param1 = lc_ordtyp1
                                                             low   = komkcv-zzauart
                                                             BINARY SEARCH.
IF sy-subrc = 0.
*Get Source Contract
  clear lv_contract.
  SELECT SINGLE vbelv INTO lv_contract
    FROM vbfa
    WHERE vbeln eq lst_ord_hdr-vbeln
      AND vbtyp_V eq lc_g.   "Contract Type
  IF sy-subrc = 0.
    clear lv_auart.
    SELECT SINGLE auart INTO lv_auart
      FROM vbak
      WHERE vbeln eq lv_contract.
    IF sy-subrc = 0.
*Check Source Contract Type
      CLEAR lst_constants.
      READ TABLE li_constants INTO lst_constants with key param1 = lc_ordtyp2
                                                           low   = lv_auart
                                                           BINARY SEARCH.
      IF sy-subrc = 0.
        komkcv-zzauart1 = lv_auart.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
*EOC <HIPATEL> <CR-7660> <ED2K913780> <11/05/2018>
