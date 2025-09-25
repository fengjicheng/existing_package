"Name: \PR:SAPLV45W\FO:KUENDIGUNGSTERMIN_PRUEFEN\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_VALIDATE_CON_TERMINATE.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_VALIDATE_CON_TERMINATE(Include)
*               Called from VA01 subscreen 4201 Include LV45WF0K"
* PROGRAM DESCRIPTION: Validate the fields "Date on which cancellation request was received",
*                      "Requested cancellation date" and
*                      "Reason for Cancellation of Contract".
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE:     :  01/16/2019
* OBJECT ID:         :  E186/ERP7515
* TRANSPORT NUMBER(S):  ED2K914194
*----------------------------------------------------------------------*
* Begin of ADD:E186(ERP-7515):PRABHU:09-Jan-2019:ED2K914194
* Local Variable Declaration
  DATA:
    lv_actv_flag_e186 TYPE zactive_flag. "Active / Inactive Flag

* Local Constant Declaration
  CONSTANTS:
    lc_sno_e186_001   TYPE zsno    VALUE '001',   "Serial Number
    lc_wricef_id_e186 TYPE zdevid  VALUE 'E186'. "Development ID

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e186  "Development ID (I0341)
      im_ser_num     = lc_sno_e186_001    "Serial Number (004)
    IMPORTING
      ex_active_flag = lv_actv_flag_e186. "Active / Inactive Flag

  IF lv_actv_flag_e186 EQ abap_true. "Check for Active Flag
    INCLUDE zqtcn_validate_con_termination IF FOUND.
  ENDIF. " IF lv_actv_flag_i0341 EQ abap_true
* End of ADD:E186(ERP-7515):PRABHU:09-Jan-2019:ED2K914194
*$*$-End:   (1)---------------------------------------------------------------------------------$*$*
ENDENHANCEMENT.
