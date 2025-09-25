*&---------------------------------------------------------------------*
* REVISION NO: ED2K926303
* PROGRAM NAME: ZQTCN_USEREXIT_XKOMV_FULLEN
* REFRENCE NO  : ASOTC-226
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE : 03/25/2022
* OBJECT ID: E354
* DESCRIPTION: Reading the enhancment control and direct to the active enhancments.
*----------------------------------------------------------------------*


DATA: lv_var_key_e354   TYPE zvar_key,                    " Variable Key
      lv_actv_flag_e354 TYPE zactive_flag.                " Active / Inactive Flag

CONSTANTS: lc_wricef_id_e354 TYPE zdevid   VALUE 'E354',  " Development ID
           lc_ser_num_e354_2 TYPE zsno     VALUE '002'.   " Serial Number

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e354
    im_ser_num     = lc_ser_num_e354_2
  IMPORTING
    ex_active_flag = lv_actv_flag_e354.

IF lv_actv_flag_e354 EQ abap_true.
  INCLUDE zqtcn_manual_disc_calc_e354 IF FOUND.
ENDIF.
