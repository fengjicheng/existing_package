*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_LIKP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_LIKP(MV50AFZ1)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the delivery header workaerea LIKP.
*                      This form is called, when a header is created
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/18/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MV_FLDS_VBAK_LIKP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This include can be used to move some fields
*                      into the delivery document workaerea LIKP.
* DEVELOPER: Aratrika Banerjee(ARABANERJE)
* CREATION DATE:   10/17/2016
* OBJECT ID: E124
* TRANSPORT NUMBER(S):  ED2K903037
*----------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e124 TYPE zdevid   VALUE 'E124',  " Development ID
  lc_ser_num_1_e124 TYPE zsno     VALUE '001'.   " Serial Number

DATA:
  lv_actv_flag_e124 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e124
    im_ser_num     = lc_ser_num_1_e124
  IMPORTING
    ex_active_flag = lv_actv_flag_e124.

IF lv_actv_flag_e124 EQ abap_true.
  INCLUDE zqtcn_mv_flds_vbak_likp IF FOUND. " Include ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP
ENDIF. " IF lv_actv_flag EQ abap_true
