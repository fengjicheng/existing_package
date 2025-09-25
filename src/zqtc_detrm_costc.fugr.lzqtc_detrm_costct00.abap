*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_DET_COSTC.................................*
TABLES: ZQTCV_DET_COSTC, *ZQTCV_DET_COSTC. "view work areas
CONTROLS: TCTRL_ZQTCV_DET_COSTC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_DET_COSTC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_DET_COSTC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_DET_COSTC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_DET_COSTC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_DET_COSTC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_DET_COSTC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_DET_COSTC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_DET_COSTC_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTC_DETRM_COSTC               .
