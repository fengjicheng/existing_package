*----------------------------------------------------------------------*
* PROGRAM NAME:ZXM08U23
* PROGRAM DESCRIPTION: Include program for User Exit to change determine
*                      Tax code and Tax jurisdiction code for Invoice
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
* PROGRAM NAME:ZXM08U23
* PROGRAM DESCRIPTION: Include program for User Exit to change determine
*                      Tax code code and Tax jurisdiction for Invoice
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
*Constant Declaration
CONSTANTS: lc_wricefid_i0353 TYPE zdevid VALUE 'I0353', " Constant value for WRICEF (I0353)
           lc_wricefid_i0379 TYPE zdevid VALUE 'I0379', " Constant value for WRICEF (I0379)
           lc_ser_num_002    TYPE zsno   VALUE '002'.   " Serial Number (001)

* Data Declaration
DATA : lv_active_stat TYPE zactive_flag, " Active / Inactive flag
       lv_varkey      TYPE zvar_key,     " Variable Key
       lv_mescod      TYPE edi_mescod.   " Logical Message Variant


CALL FUNCTION 'ZQTC_GET_MESCOD_IPS_I0353'
  IMPORTING
    ex_mescod = lv_mescod.

lv_varkey = lv_mescod.

*
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0353
    im_ser_num     = lc_ser_num_002
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_get_txcod_txjcd IF FOUND.

ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true
***** BOC ED2K917673-MIMMADISE-logic for WLS interface changes
CALL FUNCTION 'ZQTC_GET_MESCOD_IPS_I0379'
  IMPORTING
    ex_mescod = lv_mescod.

lv_varkey = lv_mescod.

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0379
    im_ser_num     = lc_ser_num_002
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_txcod_i0379_002 IF FOUND.

ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true
***** EOC-ED2K917673-MIMMADISETlogic for WLS interface changes
