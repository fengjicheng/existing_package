*&---------------------------------------------------------------------*
*&  Include           ZQTCN_USEREXIT_KOMKBV1_FILL
*&---------------------------------------------------------------------*

  CONSTANTS:
    lc_wricef_id_i0350 TYPE zdevid VALUE 'I0350',   "Constant value for WRICEF (I0350)
    lc_wricef_id_e095  TYPE zdevid VALUE 'E095',    "Constant value for WRICEF (E095)
    lc_wricef_id_f027  TYPE zdevid VALUE 'F027',    "Constant value for WRICEF (F027)
    lc_wricef_id_f057  TYPE zdevid VALUE 'F057',    "Constant value for WRICEF (F057) "+ VDPATABALL F057 11/27/2019
    lc_ser_num_i0350_1 TYPE zsno   VALUE '001',     "Serial Number (001)
    lc_ser_num_e095_1  TYPE zsno   VALUE '001',     "Serial Number (001)
    lc_ser_num_f027_1  TYPE zsno   VALUE '001',     "Serial Number (001)
    lc_ser_num_f057_1  TYPE zsno   VALUE '001'.     "Serial Number (001) "+ VDPATABALL F057 11/27/2019

  DATA:
    lv_actv_flag_i0350 TYPE zactive_flag,           "Active / Inactive flag
    lv_actv_flag_e095  TYPE zactive_flag,           "Active / Inactive flag
    lv_actv_flag_f027  TYPE zactive_flag,           "Active / Inactive flag
    lv_actv_flag_f057  TYPE zactive_flag.           "Active / Inactive flag "+ VDPATABALL F057 11/27/2019

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0350           "Constant value for WRICEF (I0350)
      im_ser_num     = lc_ser_num_i0350_1           "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0350.          "Active / Inactive flag
  IF lv_actv_flag_i0350 = abap_true.
    INCLUDE zrtrn_komkbv1_fill_i0350 IF FOUND.
  ENDIF.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e095            "Constant value for WRICEF (E095)
      im_ser_num     = lc_ser_num_e095_1            "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e095.           "Active / Inactive flag
  IF lv_actv_flag_e095 = abap_true.
    INCLUDE zrtrn_komkbv1_fill_e095 IF FOUND.
  ENDIF.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_f027            "Constant value for WRICEF (F027)
      im_ser_num     = lc_ser_num_f027_1            "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_f027.           "Active / Inactive flag
  IF lv_actv_flag_f027 = abap_true.
    INCLUDE zrtrn_komkbv1_fill_f027 IF FOUND.
  ENDIF.

*----Begin of change VDPATABALL 11/21/2019--- F057  Usage field enhanment
* check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_f057            "Constant value for WRICEF (F027)
      im_ser_num     = lc_ser_num_f057_1            "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_f057.           "Active / Inactive flag
  IF lv_actv_flag_f027 = abap_true.
    INCLUDE zrtrn_komkbv1_fill_f057 IF FOUND.
  ENDIF.
*----end of change vdpataball 11/21/2019--- f057  usage field enhanment
