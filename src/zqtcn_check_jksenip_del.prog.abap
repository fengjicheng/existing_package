*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CHECK_JKSENIP_DEL
* PROGRAM DESCRIPTION: Edit Issue Sequence
* CLEARing STATIC Internal Table if control is coming from C039 program
* C039 logic is calling the Standard Subroutines within LOOP (for
* different Media Products); since the Int Table is declared as STATICS
* the entries are not getting refreshed for the next Media Product
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/03/2017
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
DATA:
  lv_c039_flag TYPE flag.                                  "Flag: To indicate C039 processing

* Get Flag that indicates C039 processing
CALL FUNCTION 'ZQTC_ISSUE_SEQUENCE_GET_FLAG'
  IMPORTING
    ex_v_c039_flag = lv_c039_flag.
IF lv_c039_flag EQ abap_true.
  CLEAR: jksenip_buf_tab.
ENDIF.
