*&---------------------------------------------------------------------*
*&  Include           ZXTRKU02
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION : Include for segment population Outbound IDOC for delivery
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 05/14/2020
* OBJECT ID           : I0381
* TRANSPORT NUMBER(S) : ED2K918194
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_i0381 TYPE zdevid VALUE 'I0381', "Constant value for WRICEF
  lc_snum            TYPE zsno   VALUE '001',   "Serial Number
  lc_vkey_i0381      TYPE zvar_key    VALUE 'NAME_CO'.     " Variable Key
DATA:
  lv_flag_i0381 TYPE zactive_flag. " Active / Inactive flag

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0381  " Constant value for WRICEF
    im_ser_num     = lc_snum            " Serial Number (001)
    im_var_key     = lc_vkey_i0381      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_flag_i0381.     " Active / Inactive flag

IF lv_flag_i0381 = abap_true.
  INCLUDE zqtcn_wls_deliv_out_i0381 IF FOUND.
ENDIF.
*--------------------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU02 (Enhancement Implementation)                    *
* PROGRAM DESCRIPTION : Include for segment population Outbound IDOC for Outbound*
*                        delivery from SAP ECC to EDC(WMS) using Ouput Tpye ZWMS *
* DEVELOPER           : Sivarami Isireddy                                        *
* CREATION DATE       : 04/12/2022                                               *
* OBJECT ID           : I0508 / EAM-7071                                         *
* TRANSPORT NUMBER(S) : ED2K926343                                               *
*--------------------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_i0508 TYPE zdevid       VALUE 'I0508.1',     "Constant value for WRICEF
  lc_snum_i0508      TYPE zsno         VALUE '001'.         "Serial Number
* lc_vkey_i0508      TYPE zvar_key     VALUE 'DESADVAPLEDC'." Variable Key
DATA:
  lv_flag_i0508 TYPE zactive_flag, " Active / Inactive flag
  lv_vkey_i0508 TYPE zvar_key.
CONCATENATE control_record_out-mestyp control_record_out-mescod
control_record_out-mesfct INTO lv_vkey_i0508.
* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0508 " Constant value for WRICEF
    im_ser_num     = lc_snum_i0508      " Serial Number (001)
    im_var_key     = lv_vkey_i0508      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_flag_i0508.     " Active / Inactive flag
IF lv_flag_i0508 = abap_true.
  INCLUDE zqtcn_apl_deliv_out_i0508 IF FOUND.
ENDIF.
