*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_VALIDATION_R112 (Include Program)
* PROGRAM DESCRIPTION: Add validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

DATA : lv_actv_flag_r112 TYPE zactive_flag.                         " Active / Inactive Flag

CONSTANTS : lc_wricef_id_r112 TYPE zdevid   VALUE 'R112',           " WRICEF ID
            lc_ser_num_r112   TYPE zsno     VALUE '001',            " Serial No
            lc_var_key_r112   TYPE zvar_key VALUE 'JKSDORDER11'.    " T-code


CALL FUNCTION 'ZCA_ENH_CONTROL'                             " Function Module for Enhancement status check
  EXPORTING
    im_wricef_id   = lc_wricef_id_r112
    im_ser_num     = lc_ser_num_r112
    im_var_key     = lc_var_key_r112
  IMPORTING
    ex_active_flag = lv_actv_flag_r112.

IF lv_actv_flag_r112 EQ abap_true.                         " Check Enhancement active flag
  "INCLUDE zqtcn_validation_sub_r112 IF FOUND.              " Subroutine for Validation
ENDIF.
