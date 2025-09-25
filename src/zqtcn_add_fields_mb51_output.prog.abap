*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_ADD_FIELDS_MB51_OUTPUT (Include Program)
* PROGRAM DESCRIPTION: Output fields define in mb51 report
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   10/01/2019
* WRICEF ID: E218
* TRANSPORT NUMBER(S): ED2K916332
* REFERENCE NO: ERPM-835 / ERP-7933
*----------------------------------------------------------------------*
DATA : lv_var_key_e218   TYPE zvar_key,                      " Variable key(T-code)
       lv_actv_flag_e218 TYPE zactive_flag.                  " Active / Inactive Flag

CONSTANTS : lc_wricef_id_e218 TYPE zdevid VALUE 'E218',      " WRICEF ID
            lc_ser_num_e218   TYPE zsno   VALUE '001'.       " Serial No

lv_var_key_e218 = sy-tcode.                                  " T-code

CALL FUNCTION 'ZCA_ENH_CONTROL'                              " Function Module for Enhancement status check
  EXPORTING
    im_wricef_id   = lc_wricef_id_e218
    im_ser_num     = lc_ser_num_e218
    im_var_key     = lv_var_key_e218
  IMPORTING
    ex_active_flag = lv_actv_flag_e218.

IF lv_actv_flag_e218 EQ abap_true.                           " Check Enhancement active flag
  rx 'MARA ISMYEARNR    00+00'.                         " publication year
  rx 'MARA ISMREFMDPROD 00+00'.                         " Media Product
  rx 'MARC ISMANLFTAGI  00+00'.                         " Actual goods arrival date
ENDIF.
