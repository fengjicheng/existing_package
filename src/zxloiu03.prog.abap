*&---------------------------------------------------------------------*
*&  Include           ZXLOIU03
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXLOIU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION : Include for doc type/order typefiltering in Outbound IDOC for stock info
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 05/27/2020
* OBJECT ID           : I0382
* TRANSPORT NUMBER(S) : ED2K918150
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_i0382 TYPE zdevid VALUE 'I0382', "Constant value for WRICEF
  lc_snum            TYPE zsno   VALUE '001',   "Serial Number
  lc_vkey_i0382      TYPE zvar_key    VALUE 'FILTER'.     " Variable Key
DATA:
  lv_flag_i0382 TYPE zactive_flag. " Active / Inactive flag

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0382  " Constant value for WRICEF
    im_ser_num     = lc_snum            " Serial Number (001)
    im_var_key     = lc_vkey_i0382      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_flag_i0382.     " Active / Inactive flag

IF lv_flag_i0382 = abap_true.

  INCLUDE zqtcn_wls_stock_out_i0382 IF FOUND.

ENDIF.
