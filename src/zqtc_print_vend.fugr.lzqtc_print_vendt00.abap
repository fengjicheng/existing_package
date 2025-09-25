*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_PRINT_VEND................................*
TABLES: ZQTCV_PRINT_VEND, *ZQTCV_PRINT_VEND. "view work areas
CONTROLS: TCTRL_ZQTCV_PRINT_VEND
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_PRINT_VEND. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_PRINT_VEND.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_PRINT_VEND_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PRINT_VEND.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PRINT_VEND_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_PRINT_VEND_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PRINT_VEND.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PRINT_VEND_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTC_PRINT_VEND                .
