"Name: \FU:ISM_SE_CHECK_NEW_STATUS_NIP\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_JKSE01_SHIPPING_STATUS.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_JKSE01_SHIPPING_STATUS (Implicit Enhancement)
* PROGRAM DESCRIPTION: Validation based on Media issue to restrict
*                      shipping schedule planning in JKSE01 or JKSE02 Tcodes.
* DEVELOPER: Nikhiesh Palla (NPALLA)
* CREATION DATE:   08-APR-2022
* OBJECT ID: E139 (OTCM-55733)
* TRANSPORT NUMBER(S): ED2K926692
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

  CONSTANTS:
    lc_wricef_id_e139 TYPE zdevid   VALUE 'E139',  " Development ID
    lc_ser_num_2_e139 TYPE zsno     VALUE '002'.   " Serial Number

  DATA:
    lv_actv_flag_e139 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e139
      im_ser_num     = lc_ser_num_2_e139
    IMPORTING
      ex_active_flag = lv_actv_flag_e139.

  IF lv_actv_flag_e139 EQ abap_true.
    INCLUDE zqtcn_jkse01_shipping_status IF FOUND.
  ENDIF.

ENDENHANCEMENT.
