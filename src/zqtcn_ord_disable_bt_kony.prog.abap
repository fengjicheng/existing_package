*&---------------------------------------------------------------------*
*&  Include  ZQTCN_ORD_DISABLE_BT_KONY
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911531
* REFERENCE NO:  E075
* DEVELOPER:  Agudurkhad
* DATE:  2018-03-25
* DESCRIPTION: Disable update price button for converted Orders
* Change Tag :
* Begin of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
* End   of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
*-----------------------------------------------------------------------*


CONSTANTS:
  lc_wricef_id_e075  TYPE zdevid   VALUE 'E075', " Development ID
  lc_ser_num_10_e075 TYPE zsno     VALUE '010'. " Serial Number

STATICS:
  lv_actv_flag_e075 TYPE zactive_flag. " Active / Inactive Flag


IF lv_actv_flag_e075 IS INITIAL.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e075            "Constant value for WRICEF (E075)
      im_ser_num     = lc_ser_num_10_e075              "Serial Number (010)
    IMPORTING
      ex_active_flag = lv_actv_flag_e075.           "Active / Inactive flag

  IF lv_actv_flag_e075 IS INITIAL.
    lv_actv_flag_e075 = abap_undefined.
  ENDIF.
ENDIF.

IF lv_actv_flag_e075 = abap_true.
  INCLUDE zqtcn_ord_disable_price_button IF FOUND.
ENDIF.
