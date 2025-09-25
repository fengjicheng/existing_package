*&---------------------------------------------------------------------*
*&  Include           ZQTCN_USEREXIT_READ_DOCUMENT
*----------------------------------------------------------------------*
* Developer : Randheer (RKUMAR2)
* CHANGE DESCRIPTION : control editing legacy to SAP converted
*                      orders/ contracts in va02 & va42
* DEVELOPER: Randheer Kumar
* CREATION DATE:  May 11th, 2018
* OBJECT ID:  E075, seq#12
* TRANSPORT NUMBER(S): ED2K912332
*----------------------------------------------------------------------*
* Developer : Siva Guda (SGUDA)
* CHANGE DESCRIPTION : To exclude enhancements selectively
* CREATION DATE:  09-10-2018
* OBJECT ID:  E181
* TRANSPORT NUMBER(S):ED2K912979
*----------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
  lc_ser_num_12_e075 TYPE zsno     VALUE '012'.   " Serial Number


DATA:
  lv_actv_flag_e075 TYPE zactive_flag,           " Active / Inactive Flag
  lv_varkey TYPE zvar_key.

lv_varkey = sy-tcode.
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_12_e075
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  "control T180, T185F & T185V values to change the
  INCLUDE zqtcn_chk_convert_order IF FOUND.
ENDIF.

* Begin of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e181             "Constant value for WRICEF (E181)
    im_ser_num     = lc_ser_num_e181_1             "Serial Number (001)
  IMPORTING
    ex_active_flag = lv_actv_flag_e181.            "Active / Inactive flag
IF lv_actv_flag_e181 = abap_true.
  INCLUDE zqtc_enh_exlude_e181_get IF  FOUND.
ENDIF.
* End of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
