*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SETPFSTATUS_E335 (Check whether enhanmcent is active or not)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/25/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*

DATA : lv_var_key_e335   TYPE zvar_key,                      " Variable key(T-code)
       lv_actv_flag_e335 TYPE zactive_flag.                  " Active / Inactive Flag

CONSTANTS : lc_wricef_id_e335 TYPE zdevid VALUE 'E335',      " WRICEF ID
            lc_ser_num_e335   TYPE zsno   VALUE '001'.       " Serial No

lv_var_key_e335 = sy-tcode.                                  " T-code

CALL FUNCTION 'ZCA_ENH_CONTROL'                              " Function Module for Enhancement status check
  EXPORTING
    im_wricef_id   = lc_wricef_id_e335
    im_ser_num     = lc_ser_num_e335
    im_var_key     = lv_var_key_e335
  IMPORTING
    ex_active_flag = lv_actv_flag_e335.

IF lv_actv_flag_e335 EQ abap_true.                           " Check Enhancement active flag
  INCLUDE zqtc_setpfstatus_sub_e335 IF FOUND.                " Subroutine for Set custom app. toolbar button
ENDIF.
