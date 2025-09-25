*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POSTING_SPLIT_FI_02 (Include Program)
*               Called from BADI method SET_DOCUMENT_TYPE_SUBSEQ
* PROGRAM DESCRIPTION: Implementing logic as per OSS Note # 1670486
*                      Determine No of Inv Items per Split FI Document
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   11/14/2017
* OBJECT ID: E123
* TRANSPORT NUMBER(S): ED2K908950
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909703
* REFERENCE NO: ERP-5063
* DEVELOPER: Writtick Roy
* DATE:  2017-12-04
* DESCRIPTION: Consider 0-Amount Tax Lines as well
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910139
* REFERENCE NO: OSS Message 535635/2017
* DEVELOPER: Writtick Roy
* DATE:  2018-01-05
* DESCRIPTION: Do not consider 0-Amount Tax Lines, since SAP has asked
*              to implement OSS note 2584391
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

DATA:
  li_constant TYPE zcat_constants,                                   "Constant Values
  lr_bus_tran TYPE issr_r_glvor.                                     "Range Table for Business Transaction

DATA:
  lv_lines_ku TYPE i,
  lv_lines_ln TYPE i,
  lv_lines_dc TYPE i.

CONSTANTS:
  lc_prm_noii TYPE rvari_vnam VALUE 'NUMB_OF_INV_ITEMS',             "Parameter: Number Of Invoice Items
  lc_prm_bstr TYPE rvari_vnam VALUE 'BUSINESS_TRAN'.                 "Parameter: Business Transaction

* Get Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = c_wricef_id_e123                                  "Development ID: E123
  IMPORTING
    ex_constants = li_constant.                                      "Constant Values
LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
  CASE <lst_constant>-param1.
    WHEN lc_prm_noii.                                                "Parameter: Number Of Invoice Items
      CASE <lst_constant>-param2.
        WHEN lc_prm_bstr.
          APPEND INITIAL LINE TO lr_bus_tran ASSIGNING FIELD-SYMBOL(<lst_bus_tran>).
          <lst_bus_tran>-sign   = <lst_constant>-sign.
          <lst_bus_tran>-option = <lst_constant>-opti.
          <lst_bus_tran>-low    = <lst_constant>-low.
          <lst_bus_tran>-high   = <lst_constant>-high.
        WHEN OTHERS.
*         Nothing to Do
      ENDCASE.
    WHEN OTHERS.
*     Nothing to Do
  ENDCASE.
ENDLOOP.

IF i_acchd_fi-glvor IN lr_bus_tran.                                  "Business Transaction

  DATA(lt_accit_fi_c) = it_accit_fi[].
  DELETE lt_accit_fi_c WHERE buzid IS NOT INITIAL.                   "Customer Lines

  DATA(lt_accit_fi_t) = it_accit_fi[].                               "Tax Lines
  DELETE lt_accit_fi_t WHERE buzid IS INITIAL.
* Begin of ADD:OSS Msg 535635/2017:WROY:05-Jan-2018:ED2K910139
* Begin of DEL:ERP-5063:WROY:04-Dec-2017:ED2K909703
  DELETE lt_accit_fi_t WHERE kbetr IS INITIAL.
* End   of DEL:ERP-5063:WROY:04-Dec-2017:ED2K909703
* End   of ADD:OSS Msg 535635/2017:WROY:05-Jan-2018:ED2K910139
  SORT lt_accit_fi_t BY vbel2 posn2.

  LOOP AT lt_accit_fi_c ASSIGNING FIELD-SYMBOL(<lst_accit_fi_c>).
    lv_lines_ku = lv_lines_ku + 1.                                   "Customer Line

    lv_lines_ln = 1.                                                 "Customer Line
    READ TABLE lt_accit_fi_t TRANSPORTING NO FIELDS
         WITH KEY vbel2 = <lst_accit_fi_c>-vbel2
                  posn2 = <lst_accit_fi_c>-posn2
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT lt_accit_fi_t ASSIGNING FIELD-SYMBOL(<lst_accit_fi_t>) FROM sy-tabix.
        IF <lst_accit_fi_t>-vbel2 NE <lst_accit_fi_c>-vbel2 OR
           <lst_accit_fi_t>-posn2 NE <lst_accit_fi_c>-posn2.
          EXIT.
        ENDIF.
        lv_lines_ln = lv_lines_ln + 1.                               "Tax Lines
      ENDLOOP.
    ENDIF.

    IF ( lv_lines_dc + lv_lines_ln ) GT 999.
      IF e_number_of_invoice_items IS INITIAL OR
         e_number_of_invoice_items GE lv_lines_ku.
        e_number_of_invoice_items = lv_lines_ku - 1.                 "Number of Invoice Items per Split FI Document
      ENDIF.
      lv_lines_dc = lv_lines_ln.
      lv_lines_ku = 1.
    ELSE.
      lv_lines_dc = lv_lines_dc + lv_lines_ln.
    ENDIF.
  ENDLOOP.
  IF e_number_of_invoice_items IS NOT INITIAL.
*   Standard SAP logic has a bug, where it is considering 1 additional
*   line from the 2nd Document onwards
    e_number_of_invoice_items = e_number_of_invoice_items - 1.       "Number of Invoice Items per Split FI Document
  ENDIF.

ENDIF.
