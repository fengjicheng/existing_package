*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_RP_DETER..................................*
TABLES: ZQTCV_RP_DETER, *ZQTCV_RP_DETER. "view work areas
CONTROLS: TCTRL_ZQTCV_RP_DETER
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_RP_DETER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_RP_DETER.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_RP_DETER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_RP_DETER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_RP_DETER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_RP_DETER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_RP_DETER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_RP_DETER_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTCT_RENWL_PROF               .
TABLES: ZQTC_RENWL_PROF                .
TABLES: ZQTC_RP_DETER                  .
