"Name: \PR:SAPFV45K\FO:VBKD_BEARBEITEN_ZTERM\SE:END\EI
ENHANCEMENT 0 ZQTCEI_BOM_DECIMALS_I0354.
 CONSTANTS:
    lc_wricef_id_i0354 TYPE zdevid   VALUE 'I0354',  " Development ID
    lc_ser_num_5_i0354 TYPE zsno     VALUE '001'.   " Serial Number

  DATA:
    lv_actv_flag_i0354 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0354
      im_ser_num     = lc_ser_num_5_i0354
    IMPORTING
      ex_active_flag = lv_actv_flag_i0354.

  IF lv_actv_flag_i0354 EQ abap_true.
    INCLUDE zqtcn_bom_pricing_06_i0354 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
