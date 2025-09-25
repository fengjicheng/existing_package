*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_ADD_FIELDS_MB51_FIELDCAT (Include Program)
* PROGRAM DESCRIPTION: Build field catalog for newly adding fields in MB51
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
  INCLUDE zqtcn_mb51_fieldcat_sub IF FOUND.              " Subroutine for Fields catalog properties
ENDIF.
