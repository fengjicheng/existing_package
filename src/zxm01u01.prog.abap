*----------------------------------------------------------------------*
* PROGRAM NAME: ZXM01U01 (EXIT_SAPLME59_001)
* PROGRAM DESCRIPTION: Purchase order Enhancement
* DEVELOPER: Writtick Roy
* CREATION DATE:   2017-02-11
* OBJECT ID: E143
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*----------------------------------------------------------------------*

  CONSTANTS:
    lc_wricef_id_e143 TYPE zdevid   VALUE 'E143', " Development ID
    lc_ser_num_1_e143 TYPE zsno     VALUE '001'.  " Serial Number

  DATA:
    lv_actv_flag_e143 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e143
      im_ser_num     = lc_ser_num_1_e143
    IMPORTING
      ex_active_flag = lv_actv_flag_e143.

  IF lv_actv_flag_e143 EQ abap_true.
    INCLUDE zqtcn_group_requisitions IF FOUND.
  ENDIF. " IF lv_actv_flag_e143 EQ abap_true
