"Name: \PR:SAPLFACI\EX:LFACIF10_01\EI
ENHANCEMENT 0 ZQTCEI_TAX_LINE_DETAILS_DP.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_TAX_LINE_DETAILS_DP (Enhancement)
* PROGRAM DESCRIPTION: Populate additional details for Tax Lines
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       08/12/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907915
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
    lc_wricef_id_e164 TYPE zdevid VALUE 'E164',       "Constant value for WRICEF (E164)
    lc_ser_num_e164_4 TYPE zsno   VALUE '004'.        "Serial Number (004)

  DATA:
    lv_actv_flag_e164 TYPE zactive_flag.              "Active / Inactive flag

* Custom Logic
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e164              "Constant value for WRICEF (E164)
      im_ser_num     = lc_ser_num_e164_4              "Serial Number (004)
    IMPORTING
      ex_active_flag = lv_actv_flag_e164.             "Active / Inactive flag
  IF lv_actv_flag_e164 EQ abap_true.
    INCLUDE zrtrn_tax_line_details_dp IF FOUND.
  ENDIF.

ENDENHANCEMENT.
