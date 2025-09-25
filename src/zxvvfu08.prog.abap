*&---------------------------------------------------------------------*
*&  Include           ZXVVFU08
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVVFU08 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Copy controls from Billing to Accounting
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/28/2017
* OBJECT ID: E144
* TRANSPORT NUMBER(S): ED2K906990
*----------------------------------------------------------------------*

*** Enhancement Stub Code for E144------------>>>>>>>>
  CONSTANTS:
    lc_wricef_id_e144 TYPE zdevid VALUE 'E144', "Constant value for WRICEF (I0230)
    lc_ser_num_e144_2 TYPE zsno   VALUE '002'.  "Serial Number (001)

  DATA:
    lv_actv_flag_e144 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e144
      im_ser_num     = lc_ser_num_e144_2
    IMPORTING
      ex_active_flag = lv_actv_flag_e144.

  IF lv_actv_flag_e144 = abap_true.

    INCLUDE zrtrn_order_det_e144 IF FOUND.

  ENDIF. " IF lv_actv_flag_e144 = abap_true
