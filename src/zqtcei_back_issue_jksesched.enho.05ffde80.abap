"Name: \PR:SAPMV45A\EX:BELEG_SICHERN_25\EI
ENHANCEMENT 0 ZQTCEI_BACK_ISSUE_JKSESCHED.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_BACK_ISSUE_JKSESCHED
* PROGRAM DESCRIPTION: Duplicate Media Issues Prevention on Renewal
*                      Subscription
* DEVELOPER:           Writtick Roy (WROY)/Srabanti Bose (SRBOSE)
* CREATION DATE:       05/15/2015
* OBJECT ID:           E142
* TRANSPORT NUMBER(S): ED2K905794
*----------------------------------------------------------------------*
*-- Begin of code comment by SKKAIRAMKO - CR#7899 - 4/23/2019
*--This code is void, not used anymore hence commented
*      CONSTANTS:
*        lc_wricef_id_e142 TYPE zdevid   VALUE 'E142',  " Development ID
*        lc_ser_num_1_e142 TYPE zsno     VALUE '1'.     " Serial Number
*
*      DATA:
*        lv_var_key_e142   TYPE ZVAR_KEY,               " Active / Inactive Flag
*        lv_actv_flag_e142 TYPE zactive_flag .          " Active / Inactive Flag
*
*      lv_var_key_e142 = vbak-vbtyp.                    " SD document category (Contract)
**     To check enhancement is active or not
*      CALL FUNCTION 'ZCA_ENH_CONTROL'
*        EXPORTING
*          im_wricef_id   = lc_wricef_id_e142
*          im_ser_num     = lc_ser_num_1_e142
*          im_var_key     = lv_var_key_e142
*        IMPORTING
*          ex_active_flag = lv_actv_flag_e142.
*      IF lv_actv_flag_e142 EQ abap_true.
*        INCLUDE zqtcn_back_issue_jksesched IF FOUND.
*      ENDIF.
*
*-- End of code comment by SKKAIRAMKO - CR#7899 - 4/23/2019
ENDENHANCEMENT.
