*&---------------------------------------------------------------------*
*&  Include           ZXTRKU05
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZXTRKU03
*&---------------------------------------------------------------------*
*this is the code we have to date in include zxtrku03
*--------------------------------------------------------------------------------*
* PROGRAM NAME        : ZZXTRKU05 (Enhancement Implementation)                   *
* PROGRAM DESCRIPTION : Include to update the text Cancellation Reason population*
*                       Inbound IDOC for Outbound delivery from WMS to SAP ECC   *
* DEVELOPER           : Sivarami Isireddy                                        *
* CREATION DATE       : 05/10/2022                                               *
* OBJECT ID           : I0510 / EAM-7074                                         *
* TRANSPORT NUMBER(S) : ED2K926908                                               *
*--------------------------------------------------------------------------------*
*Constants
CONSTANTS:
  lc_wricef_id_i0510 TYPE zdevid       VALUE 'I0510.1',     "Constant value for WRICEF
  lc_snum_i0510      TYPE zsno         VALUE '001',         "Serial Number
  lc_underscore      TYPE char1        VALUE '_'.
DATA:
  lv_flag_i0510 TYPE zactive_flag, " Active / Inactive flag
  lv_vkey_i0510 TYPE zvar_key.
CONCATENATE idoc_control-mestyp idoc_control-mescod
idoc_control-mesfct INTO lv_vkey_i0510 SEPARATED BY lc_underscore.
* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0510 " Constant value for WRICEF
    im_ser_num     = lc_snum_i0510      " Serial Number (001)
    im_var_key     = lv_vkey_i0510      " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_flag_i0510.     " Active / Inactive flag
IF lv_flag_i0510 = abap_true.
  INCLUDE zqtcn_apl_deliv_in_i0510 IF FOUND.
ENDIF.
