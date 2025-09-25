*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_REL_CAT...................................*
TABLES: ZQTCV_REL_CAT, *ZQTCV_REL_CAT. "view work areas
CONTROLS: TCTRL_ZQTCV_REL_CAT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_REL_CAT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_REL_CAT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_REL_CAT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_REL_CAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_REL_CAT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_REL_CAT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_REL_CAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_REL_CAT_TOTAL.

*.........table declarations:.................................*
TABLES: TBZ9                           .
TABLES: TBZ9A                          .
TABLES: ZQTC_RELATIONCAT               .
