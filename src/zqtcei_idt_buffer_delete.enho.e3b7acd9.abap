"Name: \PR:SAPMV45A\FO:BELEG_SICHERN\SE:END\EI
ENHANCEMENT 0 ZQTCEI_IDT_BUFFER_DELETE.
* Begin by AMOHAMMED on 09-23-2020 TR# ED2K919626
  CONSTANTS: lc_wricef_id TYPE zdevid VALUE '7147', " Development ID
             lc_ser_num   TYPE zsno   VALUE '001'.  " Serial Number

  DATA: lv_actv_flag    TYPE zactive_flag, " Active / Inactive Flag
        lv_subrc TYPE syst_subrc. " to store current sy-subrc value
  lv_subrc = sy-subrc.
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id
        im_ser_num     = lc_ser_num
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF lv_actv_flag EQ abap_true.
*Begin of changes ERPM-7147 RKUMAR2
*Enhancement added to refresh the buffer of previous session before creating new document
      INCLUDE ZSALES_DELETE_SHUTTLE IF FOUND.
*End of changes ERPM-7147 RKUMAR2
    ENDIF. " IF lv_actv_flag EQ abap_true
    sy-subrc = lv_subrc.
    FREE lv_subrc.
* End by AMOHAMMED on 09-23-2020 TR# ED2K919626
ENDENHANCEMENT.
