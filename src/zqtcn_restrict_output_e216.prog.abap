*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTCN_RESTRICT_OUTPUT_E216
* PROGRAM DESCRIPTION: output requirement routine to check if the order line item is on HOLD status,
* then restrict in generating the ZLOC – Letter of Completion output type.
* DEVELOPER: MURALI
* CREATION DATE:   2019-10-29
* OBJECT ID: E216
* TRANSPORT NUMBER(S):ED2K916601
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_constant,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF ty_constant.
TYPES:BEGIN OF ty_jest_buf.
        INCLUDE STRUCTURE jest_upd.
        TYPES:mod,
        inact_old LIKE jest-inact.
TYPES END OF: ty_jest_buf.
DATA:
  lv_fname_xvbak TYPE char40 VALUE '(SAPMV45A)VBAK',            "Sales Document: Header Data (New)
  lv_hold        TYPE flag,                                     "Flag: Hold status
  lv_fname_xvbap TYPE char40 VALUE '(SAPMV45A)XVBAP[]',         "Sales Document: Item Data
  lv_fname_xvbkd TYPE char40 VALUE '(SAPMV45A)XVBKD[]',         "Sales Document: Contract Data
  lv_fname_xjest TYPE char40 VALUE '(SAPLBSVA)JEST_BUF[]'.      "Read Jest run time.

FIELD-SYMBOLS:
  <lst_xord_hdr> TYPE vbak,                                     "Sales Document: Header Data (New))
  <li_ord_lines> TYPE va_vbapvb_t,                              "Sales Document: Item Data
  <li_jest_upd>  TYPE ANY TABLE,                                 "JEST Runtime table data
  <li_vbkd>      TYPE table.                                      "VBKD data

DATA:
  lt_xvbkd       TYPE STANDARD TABLE OF vbkd,
  lst_x_ordr_hdr TYPE vbak,                                     "Sales Document: Header Data (New)
  li_con         TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
  lir_ordtyp1    TYPE fip_t_auart_range,                        "Saels doc order type
  lir_prof       TYPE rnrangestsma_tt,                          "Range table for Status Profiles
  lir_user       TYPE tdt_rg_estat,                             "Range table for Object status
  lir_cat        TYPE rjksd_pstyv_range_tab,                    "Range table for Item Category
  lv_objnr       TYPE j_objnr,                                   "Object number
  lv_vbeln       TYPE vbeln,                                     "Sales doc number
  li_jest_upd1   TYPE STANDARD TABLE OF ty_jest_buf,              "JEST_BUF values
  lv_posnr       TYPE posnr.                                    "item

*-- Constants
CONSTANTS:
  lc_id_e216 TYPE zdevid     VALUE 'E216',                     "Development ID
  lc_vb      TYPE rvari_vnam VALUE 'VB',
  lc_va02    TYPE tcode      VALUE 'VA02',
  lc_cat     TYPE rvari_vnam VALUE 'PSTYV',                    "ABAP: Name of Variant Variable
  lc_ordt    TYPE rvari_vnam VALUE 'AUART',                    "ABAP: Name of Variant Variable
  lc_estat   TYPE rvari_vnam VALUE 'ESTAT'.

SELECT devid                                                  "Development ID
       param1	                                                "ABAP: Name of Variant Variable
       param2	                                                "ABAP: Name of Variant Variable
       srno	                                                  "ABAP: Current selection number
       sign	                                                  "ABAP: ID: I/E (include/exclude values)
       opti	                                                  "ABAP: Selection option (EQ/BT/CP/...)
       low                                                    "Lower Value of Selection Condition
       high	                                                  "Upper Value of Selection Condition
       activate                                               "Activation indicator for constant
  FROM zcaconstant                                            "Wiley Application Constant Table
  INTO TABLE li_con
 WHERE devid    EQ lc_id_e216
   AND activate EQ abap_true.
IF sy-subrc EQ 0.
  LOOP AT li_con ASSIGNING FIELD-SYMBOL(<lst_const1>).
    CASE <lst_const1>-param1.
      WHEN lc_ordt.
*          Get the Order Types from Constant Table
        APPEND INITIAL LINE TO lir_ordtyp1 ASSIGNING FIELD-SYMBOL(<lst_ortype>).
        <lst_ortype>-sign   = <lst_const1>-sign.
        <lst_ortype>-option = <lst_const1>-opti.
        <lst_ortype>-low    = <lst_const1>-low.
        <lst_ortype>-high   = <lst_const1>-high.
      WHEN lc_cat.
*         Get the Sales document item category from constant table
        APPEND INITIAL LINE TO lir_cat ASSIGNING FIELD-SYMBOL(<ls_cat>).
        <ls_cat>-sign   = <lst_const1>-sign.
        <ls_cat>-option = <lst_const1>-opti.
        <ls_cat>-low    = <lst_const1>-low.
        <ls_cat>-high   = <lst_const1>-high.
      WHEN lc_estat.
*       Get the User Status from constant table
        APPEND INITIAL LINE TO lir_user ASSIGNING FIELD-SYMBOL(<ls_user>).
        <ls_user>-sign   = <lst_const1>-sign.
        <ls_user>-option = <lst_const1>-opti.
        <ls_user>-low    = <lst_const1>-low.
        <ls_user>-high   = <lst_const1>-high.
      WHEN OTHERS.
*           Nothing to do
    ENDCASE.
  ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
ENDIF. " IF sy-subrc EQ 0
* Retrieve Sales Document: Header Data (New)
ASSIGN (lv_fname_xvbak) TO <lst_xord_hdr>.
IF <lst_xord_hdr>-auart IN lir_ordtyp1
AND lir_cat IS NOT INITIAL                     "‘ZACO’
AND msg_objky IS NOT INITIAL.
** output type will trigger at line item and msg_objky field will store order no and item
  lv_vbeln = msg_objky+0(10).
  lv_posnr = msg_objky+10(6).
* Retrieve Sales Document: Item Data
  ASSIGN (lv_fname_xvbap) TO <li_ord_lines>.
  IF sy-subrc EQ 0.
    ASSIGN (lv_fname_xvbkd) TO <li_vbkd>.
    IF sy-subrc = 0.
      lt_xvbkd[] = <li_vbkd>[].
** Consider voucher number items only.
      DELETE lt_xvbkd WHERE bstkd_e IS INITIAL.
      LOOP AT <li_ord_lines> ASSIGNING FIELD-SYMBOL(<lst_ord_line>)
        WHERE vbeln = lv_vbeln AND posnr = lv_posnr AND
        pstyv IN lir_cat AND mvgr3 IS NOT INITIAL."ZACC anf final grade
        READ TABLE lt_xvbkd TRANSPORTING NO FIELDS
        WITH KEY vbeln = <lst_ord_line>-vbeln
                posnr = <lst_ord_line>-posnr.
        IF sy-subrc = 0.
** Objectnumber = ‘VB’ + (10 char order number) + (6 position item number)
          CONCATENATE lc_vb <lst_ord_line>-vbeln <lst_ord_line>-posnr
          INTO lv_objnr.
        ENDIF.
      ENDLOOP.
      IF lv_objnr IS NOT INITIAL.
** Reading the JEST_BUF runtime buffer values to check HOLD is Active or not
** Passing to temporary field symbol internal table
        ASSIGN (lv_fname_xjest) TO <li_jest_upd>.
        IF sy-subrc = 0.
** Passing the JEST_BUF intenal table to li_jest_upd1[]
          li_jest_upd1[] = <li_jest_upd>.
** Read the hold status from JEST
          SELECT SINGLE * FROM jest
                   INTO @DATA(ls_jest)
                   WHERE objnr = @lv_objnr AND stat IN @lir_user.
          IF sy-subrc = 0.
            IF ls_jest-inact = abap_true.
* JEST-INACT field is 'X',ZLOC output should generate for this item invoice created,Cleared the Document
              lv_hold = abap_true.
            ELSEIF ls_jest-inact = space.
**If there is a record found for line item and the JEST-INACT field is Blank, then the order line item status
**is already set to HOLD. ZLOC output should not generate
**Upon saving the order in runtime unchecked the HOLD status flag,ZLOC output should generate.
              READ TABLE li_jest_upd1 TRANSPORTING NO FIELDS
                WITH KEY objnr = ls_jest-objnr stat = ls_jest-stat
                inact = abap_true.
              IF sy-subrc = 0.
                lv_hold = abap_true.
              ENDIF.
            ENDIF.
          ELSE.
***No record found in JEST table and Assuming that contract order is full paied and generating the ZLOC output
            lv_hold = abap_true.
          ENDIF.
        ENDIF."IF sy-subrc = 0.
      ENDIF."IF lv_objnr IS NOT INITIAL.
    ENDIF."IF sy-subrc = 0.
  ENDIF." IF sy-subrc EQ 0.
ENDIF."IF <lst_xord_hdr>-auart IN lir_ordtyp1
**if lv_hold flag is 'X' ZLOC output should generate.
IF lv_hold EQ abap_true.                               "No hold ZLOC output should generate.
  sy-subrc = 0.
ELSE.                                                  "Hold ZLOC output should not generate.
  sy-subrc = 4.
ENDIF.
