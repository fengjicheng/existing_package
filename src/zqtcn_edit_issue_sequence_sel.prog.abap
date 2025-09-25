*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDIT_ISSUE_SEQUENCE_SEL
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS:
  s_mtyp_i FOR mara-mtart          OBLIGATORY,             "Material Type (Media Issue)
  s_st_del FOR mara-mstae          NO INTERVALS,           "Media Issue Status (Active)
  s_iv_typ FOR mara-ismissuetypest NO INTERVALS,           "Std.Issue Var.Type (Exclusion)
  s_shp_st FOR jksenip-status      NO INTERVALS.           "Status of Shipping Planning (Inclusion)

SELECTION-SCREEN SKIP 1.
PARAMETERS:
  p_ts_upd TYPE char1 AS CHECKBOX.                         "Update TimeStamp Even If Error
SELECTION-SCREEN END OF BLOCK b1.
