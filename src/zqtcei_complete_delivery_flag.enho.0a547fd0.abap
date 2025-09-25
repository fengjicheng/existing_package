"Name: \PR:SAPLV50R\EX:LV50RF56_01\EI
ENHANCEMENT 0 ZQTCEI_COMPLETE_DELIVERY_FLAG.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_COMPLETE_DELIVERY_FLAG (Enhancement Impl)
* PROGRAM DESCRIPTION: Ship Order Complete
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/22/2016
* OBJECT ID: E133
* TRANSPORT NUMBER(S): ED2K902982
*----------------------------------------------------------------------*

  CONSTANTS:
    lc_wricef_id_e133 TYPE zdevid VALUE 'E133',            "Constant value for WRICEF (E133)
    lc_ser_num_e133_1 TYPE zsno   VALUE '001'.             "Serial Number (001)

  DATA:
    lv_actv_flag_e133 TYPE zactive_flag.                   "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e133                   "Constant value for WRICEF (E133)
      im_ser_num     = lc_ser_num_e133_1                   "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e133.                  "Active / Inactive flag
  IF lv_actv_flag_e133 = abap_true.
    INCLUDE zrtrn_complete_delivery_flag IF FOUND.
  ENDIF.
ENDENHANCEMENT.
