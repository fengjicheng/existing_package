"Name: \PR:SAPLMV01\EX:MASTERIDOC_CREATE_SMD_MATMA_04\EI
ENHANCEMENT 0 ZQTCEI_ISM_MATMAS_SEGMENTS.
    CONSTANTS:
      lc_wricef_id_i0204 TYPE zdevid   VALUE 'I0204', " Development ID
      lc_ser_num_2_i0204 TYPE zsno     VALUE '002'.   " Serial Number

    DATA:
      lv_var_key_i0204   TYPE ZVAR_KEY,               " Variable Key
      lv_actv_flag_i0204 TYPE zactive_flag.           " Active / Inactive Flag

    CLEAR: lv_actv_flag_i0204.
    lv_var_key_i0204 = message_type.                  " Message Type

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_i0204
        im_ser_num     = lc_ser_num_2_i0204
        im_var_key     = lv_var_key_i0204
      IMPORTING
        ex_active_flag = lv_actv_flag_i0204.

    IF lv_actv_flag_i0204 EQ abap_true.
      INCLUDE zqtcn_ism_matmas_segments_03 IF FOUND.
    ENDIF.
ENDENHANCEMENT.
