*&---------------------------------------------------------------------*
*&  Include           ZTR_VALIDATION_REPORT_SEL
*&---------------------------------------------------------------------*

* Include type pool SSCR
TYPE-POOLS SSCR.

DATA: lv_dest   TYPE vers_dest-rfcdest,
      lv_dest1  TYPE vers_dest-rfcdest,
      lv_trkorr TYPE trkorr,
      lv_stat   TYPE trstatus,
      lv_user   TYPE tr_as4user,
      lv_date   TYPE datum,
      lv_des    TYPE as4text,
      lv_email  TYPE ad_smtpadr.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS:s_dest FOR lv_dest NO INTERVALS NO-EXTENSION ." OBLIGATORY.
SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS:s_req  FOR lv_trkorr NO INTERVALS,
               s_stat FOR lv_stat NO INTERVALS,
               s_user FOR lv_user NO INTERVALS,
               s_date FOR lv_date,
               s_des  FOR lv_des NO INTERVALS.
SELECTION-SCREEN: END OF BLOCK b1.
SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE text-008.
SELECT-OPTIONS : s_email FOR lv_email NO INTERVALS.
SELECTION-SCREEN: END OF BLOCK b2.
