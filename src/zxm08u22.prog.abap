*----------------------------------------------------------------------*
* PROGRAM NAME:ZXM08U22
* PROGRAM DESCRIPTION: Include program for User Exit to determine the
*                      company code and process IDOC data
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
* REVISION HISTORY: Include program for User Exit to determine the
*                  company code and process IDOC data for Z2 variant
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-03-01
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
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
           lc_ser_num_001    TYPE zsno   VALUE '001',   " Serial Number (001)
           lc_wricefid_i0379 TYPE zdevid VALUE 'I0379'. " Constant value for WRICEF (I0379)


* Data Declaration
DATA : lv_active_stat TYPE zactive_flag, " Active / Inactive flag
       lv_varkey      TYPE zvar_key.     " Variable Key

lv_varkey = i_idoc_contrl-mescod.


CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0353
    im_ser_num     = lc_ser_num_001
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_populate_bukrs IF FOUND.

ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true

** BOC MIMMADISET-ED2K917673-2020-03-01
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0379
    im_ser_num     = lc_ser_num_001
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_pop_i0379_001 IF FOUND.
ENDIF." IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true
** EOC MIMMADISET-ED2K917673-2020-03-01
