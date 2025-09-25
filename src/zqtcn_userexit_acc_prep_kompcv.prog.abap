*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_ACC_PREP_KOMPCV (Include)
*               Called from "USEREXIT_ACCOUNT_PREP_KOMPCV (RV60AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move additional
*                      fields into the communication table which is used
*                      for account allocation: KOMPCV for item fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/27/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903817
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e156 TYPE zdevid   VALUE 'E156',  " Development ID
    lc_ser_num_1_e156 TYPE zsno     VALUE '001'.   " Serial Number

  DATA:
    lv_actv_flag_e156 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e156
      im_ser_num     = lc_ser_num_1_e156
    IMPORTING
      ex_active_flag = lv_actv_flag_e156.

  IF lv_actv_flag_e156 EQ abap_true.
    INCLUDE zqtcn_rev_acc_det_itm IF FOUND.
  ENDIF.
