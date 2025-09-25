*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_I0255_SPLT................................*
TABLES: ZQTCV_I0255_SPLT, *ZQTCV_I0255_SPLT. "view work areas
CONTROLS: TCTRL_ZQTCV_I0255_SPLT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_I0255_SPLT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_I0255_SPLT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_I0255_SPLT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_I0255_SPLT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_I0255_SPLT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_I0255_SPLT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_I0255_SPLT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_I0255_SPLT_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTC_I0255_SPLIT               .
