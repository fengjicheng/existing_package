*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_EDIT_ISSUE_EQUENCE
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
FUNCTION zqtc_issue_sequence_get_flag.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_V_C039_FLAG) TYPE  FLAG
*"----------------------------------------------------------------------

  ex_v_c039_flag = v_c039_flag.                            "Flag: To indicate C039 processing

ENDFUNCTION.
