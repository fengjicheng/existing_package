*----------------------------------------------------------------------*
* PROGRAM NAME: ZXF06U02 (User-exit - Called from EXIT_SAPLIEDI_002)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate additional Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/29/2017
* OBJECT ID: E163
* TRANSPORT NUMBER(S):  ED2K906862
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e163 TYPE zdevid VALUE 'E163',       "Constant value for WRICEF (E163)
    lc_ser_num_e163   TYPE zsno   VALUE '001'.        "Serial Number (001)

  DATA:
    lv_actv_flag_e163 TYPE zactive_flag.              "Active / Inactive flag

*   Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e163              "Constant value for WRICEF (E163)
      im_ser_num     = lc_ser_num_e163                "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e163.             "Active / Inactive flag

  IF lv_actv_flag_e163 = abap_true.
    INCLUDE zqtcn_ic_invoice_fields_03 IF FOUND.
  ENDIF. "IF lv_actv_flag_E163 = abap_true
