"Name: \PR:SAPLV45W\FO:USEREXIT_FIELD_MODIFICATION\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_VALIDATE_CON_TERMINATE.
* Begin of ADD: OTCM-77858 Disable contract start and end dates in VA42POC
CONSTANTS:lc_wricef_id_e386 TYPE zdevid   VALUE 'E386', " Development ID
          lc_ser_num_1_e386 TYPE zsno     VALUE '001'.  " Serial Number
STATICS:lv_actv_flag_e386 TYPE zactive_flag.
CLEAR:lv_actv_flag_e386.
IF lv_actv_flag_e386 IS INITIAL.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e386
      im_ser_num     = lc_ser_num_1_e386
    IMPORTING
      ex_active_flag = lv_actv_flag_e386.
  IF lv_actv_flag_e386 EQ abap_true.
    INCLUDE zqtcn_non_edit_contract_dates.
  ENDIF.
ENDIF.
* End of ADD: OTCM-77858 Disable contract start and end dates in VA42POC

ENDENHANCEMENT.
