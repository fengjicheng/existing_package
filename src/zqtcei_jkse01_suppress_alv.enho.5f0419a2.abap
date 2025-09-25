"Name: \PR:SAPMJKSE01\FO:SEND_MAINTENANCE_TAB_TO_DYNP\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_JKSE01_SUPPRESS_ALV.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_JKSE01_SUPPRESS_ALV (Implicit Enhancement)
* PROGRAM DESCRIPTION: Some of the Subroutines of JKSE01 is being called
*                      Custom Program which is being executed in B/G.
*                      During B/G execution, the standard logic tries to
*                      display ALV, that results in ABAP Dump.
*                      Solution: If the corresponding Variable for ALV
*                      is not yet instantiated, skip later steps
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02-JUN-2017
* OBJECT ID: C075 (ERP-2572)
* TRANSPORT NUMBER(S): ED2K906452
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_c075 TYPE zdevid   VALUE 'C075',  " Development ID
    lc_ser_num_1_c075 TYPE zsno     VALUE '001'.   " Serial Number

  DATA:
    lv_actv_flag_c075 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_c075
      im_ser_num     = lc_ser_num_1_c075
    IMPORTING
      ex_active_flag = lv_actv_flag_c075.

  IF lv_actv_flag_c075 EQ abap_true.
    INCLUDE zqtcn_jkse01_suppress_alv IF FOUND.
  ENDIF.
ENDENHANCEMENT.
