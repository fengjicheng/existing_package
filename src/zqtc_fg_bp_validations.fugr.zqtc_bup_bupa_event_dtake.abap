FUNCTION zqtc_bup_bupa_event_dtake.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*--------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_BUP_BUPA_EVENT_DTAKE
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 01-04-2019
* OBJECT ID: E191
* TRANSPORT NUMBER(S): ED2K914845
*--------------------------------------------------------------------*

* Trigger Standard BDT Event 'DTAKE' FM (Hold Data (in Local Memory))
* Item: 100000
  CALL FUNCTION 'BUP_BUPA_EVENT_DTAKE'.

* Local Data
  DATA:
    lv_actv_e191  TYPE zactive_flag.

* Local constants
  CONSTANTS:
    lc_devid_e191   TYPE zdevid         VALUE 'E191',        " Development ID: E191
    lv_varkey_e191  TYPE zvar_key       VALUE 'FI_CUSTOMER',
    lc_sno_e191_002 TYPE zsno           VALUE '002'.         " Serial Number: 001


* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e191                " Development ID: E191
      im_ser_num     = lc_sno_e191_002              " Serial Number: 001
      im_var_key     = lv_varkey_e191
    IMPORTING
      ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
  IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
    INCLUDE zqtcn_bupa_event_dtake_lh_e191 IF FOUND.
  ENDIF. " IF lv_actv_e191 EQ abap_true.



ENDFUNCTION.
