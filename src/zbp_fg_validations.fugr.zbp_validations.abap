FUNCTION zbp_validations.
*------------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZBP_VALIDATIONS
*                       called via BDT event: DCHCK
* DESCRIPTION: BP Validations
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 07/04/2018
* OBJECT ID: E165
* TRANSPORT NUMBER(s):
*------------------------------------------------------------------------*

* Trigger Standard BDT Event DCHCK FM: Checks Before Saving (Cross-View)
* Item: 100000
  CALL FUNCTION 'BUP_BUPA_EVENT_DCHCK'.


ENDFUNCTION.
