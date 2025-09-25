*&---------------------------------------------------------------------*
*&  Include  ZQTCN_USEREXIT_MOVE_FLD_TO_ME
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MOVE_FLD_TO_ME
* PROGRAM DESCRIPTION: Incldue for userEXIT move field to ME REQ
* DEVELOPER: SKKAIRAMKO
* CREATION DATE:   10/30/2019
* OBJECT ID: E222
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*--------------------------------------------------------------------*
* Move Facilitotor to purchase req.
*--------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e222 TYPE zdevid   VALUE 'E222', " Development ID
  lc_ser_num_4_e222 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e222 TYPE zactive_flag.          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e222
    im_ser_num     = lc_ser_num_4_e222
  IMPORTING
    ex_active_flag = lv_actv_flag_e222.
IF lv_actv_flag_e222 EQ abap_true.
  INCLUDE zqtcn_move_field_to_eban IF FOUND.
ENDIF.
