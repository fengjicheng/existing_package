FUNCTION zqtc_cvic_bupa_pbo_cvic91.
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Set the defalts values for Distribution Channel and division
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* Local Data
  DATA:
    lv_actv_e191  TYPE zactive_flag .

* Local constants
  CONSTANTS:
    lc_devid_e191   TYPE zdevid  VALUE 'E191',    " Development ID: E191
    lc_sno_e191_001 TYPE zsno    VALUE '001'.     " Serial Number: 001
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e191                " Development ID: E191
      im_ser_num     = lc_sno_e191_001              " Serial Number: 001
    IMPORTING
      ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
  IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
    INCLUDE zqtcn_cvic_pbo_cvic91_e191 IF FOUND.
  ENDIF.

* Trigger Standard Function Call of PBO
  CALL FUNCTION 'CVIC_BUPA_PBO_CVIC91'.




ENDFUNCTION.
