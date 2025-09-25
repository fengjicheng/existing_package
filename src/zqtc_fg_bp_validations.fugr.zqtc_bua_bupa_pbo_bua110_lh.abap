FUNCTION zqtc_bua_bupa_pbo_bua110_lh.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_BUA_BUPA_PBO_BUA110_LH
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 25-03-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914714
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local Data
  DATA:
    lv_actv_e191  TYPE zactive_flag .

* Local constants
  CONSTANTS:
    lc_devid_e191   TYPE zdevid  VALUE 'E191',    " Development ID: E191
    lc_sno_e191_001 TYPE zsno    VALUE '001'.     " Serial Number: 001


* Trigger Standard Function Call of PBO
  CALL FUNCTION 'BUA_BUPA_PBO_BUA110'.

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e191                " Development ID: E191
      im_ser_num     = lc_sno_e191_001              " Serial Number: 001
    IMPORTING
      ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
  IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
    INCLUDE zqtcn_bua_bupa_pbo_bua110_lh IF FOUND.
  ENDIF.


ENDFUNCTION.
