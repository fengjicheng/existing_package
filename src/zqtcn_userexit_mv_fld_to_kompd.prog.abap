*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_KOMPD (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMKD(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      substitution.
* DEVELOPER: ANIRBAN SAHA
* CREATION DATE:   09/17/2017
* OBJECT ID: E096 / Defect 3528
* TRANSPORT NUMBER(S):  ED2K907576/ED2K907596
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_e096 TYPE zdevid VALUE 'E096', " Development ID
  lc_ser_num_1_e096 TYPE zsno   VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e096 TYPE zactive_flag .       " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e096
    im_ser_num     = lc_ser_num_1_e096
  IMPORTING
    ex_active_flag = lv_actv_flag_e096.

IF lv_actv_flag_e096 EQ abap_true.
  INCLUDE zqtcn_produc_substitution IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true

* Begin of ADD:E136/ERP-6344:08-June-2018:ED2K912244
CONSTANTS:
  lc_wricef_id_e136 TYPE zdevid VALUE 'E136', " Development ID
  lc_ser_num_2_e136 TYPE zsno   VALUE '002'.  " Serial Number

DATA:
  lv_actv_flag_e136 TYPE zactive_flag .       " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e136
    im_ser_num     = lc_ser_num_2_e136
  IMPORTING
    ex_active_flag = lv_actv_flag_e136.

IF lv_actv_flag_e136 EQ abap_true.
  INCLUDE zqtcn_product_subs_e136_01 IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true
* End   of ADD:E136/ERP-6344:08-June-2018:ED2K912244
