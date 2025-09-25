FUNCTION zqtc_bup_bupa_event_dchck_e165.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"--------------------------------------------------------------------
*------------------------------------------------------------------------*
* FUNCTION MODULE NAME: zqtc_bup_bupa_event_dchck_e165
*                       called via BDT event: DCHCK
* DESCRIPTION: BP Validations
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 07/04/2018
* OBJECT ID: E165 / CR# 6664
* TRANSPORT NUMBER(s): ED2K913317
*------------------------------------------------------------------------*

* Trigger Standard BDT Event DCHCK FM: Checks Before Saving (Cross-View)
* Item: 100000
  CALL FUNCTION 'BUP_BUPA_EVENT_DCHCK'.

* BP Custom Validations
  INCLUDE zqtcn_bp_validations IF FOUND.



ENDFUNCTION.
