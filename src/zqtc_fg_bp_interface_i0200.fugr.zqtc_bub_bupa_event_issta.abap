*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_BUB_BUPA_EVENT_ISSTA (Initialization Event)
* PROGRAM DESCRIPTION: Populate Default values of Valid From/To Dates
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 19-JUL-2018
* OBJECT ID: E179 (ERP-6695)
* TRANSPORT NUMBER(S): ED2K912430
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_bub_bupa_event_issta.
  DATA:
    lv_valid_from_date TYPE char70 VALUE '(SAPLBUPA_DIALOG_JOEL)LCL_SCREEN_1210=>GV_VALID_FROM_DATE', "Valid From Date (ABAP Stack)
    lv_valid_to_date   TYPE char70 VALUE '(SAPLBUPA_DIALOG_JOEL)LCL_SCREEN_1210=>GV_VALID_TO_DATE',   "Valid To Date (ABAP Stack)
    lv_default_date    TYPE datum.                                                                    "Default Date

  FIELD-SYMBOLS:
    <lv_valid_frm_dat> TYPE char10, "Valid From Date (ABAP Stack)
    <lv_valid_to_dat>  TYPE char10. "Valid To Date (ABAP Stack)

* Valid From Date
  ASSIGN (lv_valid_from_date) TO <lv_valid_frm_dat>.
  IF sy-subrc EQ 0 AND
     <lv_valid_frm_dat> IS INITIAL.
    lv_default_date = sy-datum.
    lv_default_date+4(4) = '0101'.                                                                    "Start of the Calendar Year
    WRITE lv_default_date TO <lv_valid_frm_dat>.
  ENDIF. " IF sy-subrc EQ 0 AND

* Valid To Date
  ASSIGN (lv_valid_to_date) TO <lv_valid_to_dat>.
  IF sy-subrc EQ 0 AND
     <lv_valid_to_dat> IS INITIAL.
    WRITE cl_bus_time=>gc_end_of_days TO <lv_valid_to_dat>.                                           "Fixed Value: 99991231
  ENDIF. " IF sy-subrc EQ 0 AND

ENDFUNCTION.
