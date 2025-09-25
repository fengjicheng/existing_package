*----------------------------------------------------------------------*
* PROGRAM NAME:        ZXV60AU01
* PROGRAM DESCRIPTION: VF04 Item Control for Proforma ZF5
* DEVELOPER:           Siva Guda
* CREATION DATE:       08/12/2018
* OBJECT ID:           E174
* TRANSPORT NUMBER(S): ED2K913013
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e174 TYPE zdevid VALUE 'E174', "Constant value for WRICEF (I0230)
    lc_ser_num_e174   TYPE zsno   VALUE '005'.   "Serial Number (001)

  DATA:
    lv_var_key_e174   TYPE zvar_key,     "Variable Key
    lv_actv_flag_e174 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e174  "Constant value for WRICEF (C030)
      im_ser_num     = lc_ser_num_e174  "Serial Number (003)
      im_var_key     = lv_var_key_e174    "Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e174. "Active / Inactive flag

  IF lv_actv_flag_e174 = abap_true.
      INCLUDE ZQTCN_ENHANCE_VF04_HEADER IF FOUND.
  ENDIF. " IF lv_actv_flag_e174 = abap_true
