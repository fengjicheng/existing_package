*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_KOMKD (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMKD(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      substitution.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e136 TYPE zdevid VALUE 'E136', " Development ID
  lc_ser_num_1_e136 TYPE zsno   VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e136 TYPE zactive_flag .       " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e136
    im_ser_num     = lc_ser_num_1_e136
  IMPORTING
    ex_active_flag = lv_actv_flag_e136.

IF lv_actv_flag_e136 EQ abap_true.
  INCLUDE zqtcn_userexit_mv_fld_to_items IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true
