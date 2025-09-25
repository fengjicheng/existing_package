"Name: \PR:RSNAST00\EX:OBJEKT_SPERREN\EI
ENHANCEMENT 0 ZQTCEI_STOP_OUTPUT_PROCESSING.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_STOP_OUTPUT_PROCESSING (Enhancement Impl)
* PROGRAM DESCRIPTION: Stop Processing of Output (RDIV) if RAR Contract
*                      is missing
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       01/09/2018
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K910206
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
    lc_wricef_id_e160 TYPE zdevid VALUE 'E160',    "Constant value for WRICEF (E160)
    lc_ser_num_e160_4 TYPE zsno   VALUE '004'.     "Serial Number (004)

  DATA:
    lv_var_key_e160   TYPE zvar_key,               "Variable Key
    lv_actv_flag_e160 TYPE zactive_flag.           "Active / Inactive flag

* Check if enhancement needs to be triggered
  lv_var_key_e160 = nast-kschl.                    "Variable Key = Message type
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e160           "Constant value for WRICEF (E160)
      im_ser_num     = lc_ser_num_e160_4           "Serial Number (004)
      im_var_key     = lv_var_key_e160             "Variable Key
    IMPORTING
      ex_active_flag = lv_actv_flag_e160.          "Active / Inactive flag
  IF lv_actv_flag_e160 = abap_true.
    INCLUDE zrtrn_stop_output_processing IF FOUND.
  ENDIF.
ENDENHANCEMENT.
