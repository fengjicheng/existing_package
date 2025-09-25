*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SEL_SCREEN_EVENT_R112 (Include Program)
* PROGRAM DESCRIPTION: define additional selection Screen fields & block names
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918376
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

CALL FUNCTION 'ZCA_ENH_CONTROL'                             " Function Module for Enhancement status check
  EXPORTING
    im_wricef_id   = lc_wricef_id_r112
    im_ser_num     = lc_ser_num_r112
    im_var_key     = lc_var_key_r112
  IMPORTING
    ex_active_flag = lv_actv_flag_r112.

IF lv_actv_flag_r112 EQ abap_true.                           " Check Enhancement active flag
  INCLUDE zqtcn_sel_fields_name_r112 IF FOUND.               " Subroutine for additional Selection screen field & block names
ENDIF.
