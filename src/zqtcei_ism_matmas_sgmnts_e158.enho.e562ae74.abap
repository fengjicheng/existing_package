"Name: \PR:SAPLMV01\EX:MASTERIDOC_CREATE_MATMAS_03\EI
ENHANCEMENT 0 ZQTCEI_ISM_MATMAS_SGMNTS_E158.
       CLEAR: lv_actv_flag_e158.
       lv_var_key_e158 = message_type.                  " Message Type

*      To check enhancement is active or not
       CALL FUNCTION 'ZCA_ENH_CONTROL'
         EXPORTING
           im_wricef_id   = lc_wricef_id_e158
           im_ser_num     = lc_ser_num_2_e158
           im_var_key     = lv_var_key_e158
         IMPORTING
           ex_active_flag = lv_actv_flag_e158.
       IF lv_actv_flag_e158 EQ abap_true.
         INCLUDE zqtcei_ism_matmas_sgmnt_e158_2 IF FOUND.
       ENDIF.
ENDENHANCEMENT.
