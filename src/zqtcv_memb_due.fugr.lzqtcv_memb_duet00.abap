*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_MEMB_DUE..................................*
TABLES: ZQTCV_MEMB_DUE, *ZQTCV_MEMB_DUE. "view work areas
CONTROLS: TCTRL_ZQTCV_MEMB_DUE
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_MEMB_DUE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_MEMB_DUE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_MEMB_DUE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_MEMB_DUE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_MEMB_DUE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_MEMB_DUE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_MEMB_DUE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_MEMB_DUE_TOTAL.

*.........table declarations:.................................*
TABLES: TWEW                           .
TABLES: TWEWT                          .
TABLES: ZQTC_MEMB_DUE                  .
