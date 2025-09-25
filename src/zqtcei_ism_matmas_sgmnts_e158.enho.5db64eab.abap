"Name: \PR:SAPLMV01\EX:MASTERIDOC_CREATE_MATMAS_09\EI
ENHANCEMENT 0 ZQTCEI_ISM_MATMAS_SGMNTS_E158.
      CONSTANTS:
         lc_wricef_id_e158 TYPE zdevid   VALUE 'E158',  " Development ID
         lc_ser_num_2_e158 TYPE zsno     VALUE '002'.   " Serial Number

       DATA:
         lv_var_key_e158   TYPE zvar_key,               " Variable Key
         lv_actv_flag_e158 TYPE zactive_flag.           " Active / Inactive Flag

       CLEAR: lv_actv_flag_e158.
       lv_var_key_e158 = message_type.                  " Message Type

*       To check enhancement is active or not
        CALL FUNCTION 'ZCA_ENH_CONTROL'
          EXPORTING
            im_wricef_id   = lc_wricef_id_e158
            im_ser_num     = lc_ser_num_2_e158
            im_var_key     = lv_var_key_e158
          IMPORTING
            ex_active_flag = lv_actv_flag_e158.
        IF lv_actv_flag_e158 EQ abap_true.
          INCLUDE zqtcei_ism_matmas_sgmnt_e158_1 IF FOUND.
        ENDIF.
ENDENHANCEMENT.
