FUNCTION zqtc_ism_bupa_event_dsave.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*--------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ISM_BUPA_EVENT_DSAVE
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 27-03-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914714
*--------------------------------------------------------------------*
* PROGRAM DESCRIPTION:
* DEVELOPER: Sunil Kumar Kairamkonda ( SKKAIRAMKO )
* CREATION DATE: 5-28-2019
* OBJECT ID: INC0245406
* TRANSPORT NUMBER(S):ED1K910232
*--------------------------------------------------------------------*

* Local Data
  DATA:
    lv_actv_e191  TYPE zactive_flag.

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
    INCLUDE zqtcn_bp_crdtcoll_def_lh_e191 IF FOUND.
  ENDIF.


ENDFUNCTION.
