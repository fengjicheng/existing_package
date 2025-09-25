*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_RENWL_PLAN................................*
TABLES: ZQTCV_RENWL_PLAN, *ZQTCV_RENWL_PLAN. "view work areas
CONTROLS: TCTRL_ZQTCV_RENWL_PLAN
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_RENWL_PLAN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_RENWL_PLAN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_RENWL_PLAN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_RENWL_PLAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_RENWL_PLAN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_RENWL_PLAN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_RENWL_PLAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_RENWL_PLAN_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTCT_ACTIVITY                 .
TABLES: ZQTCT_EXCL_RESN                .
TABLES: ZQTCT_RENWL_PROF               .
TABLES: ZQTC_ACTIVITY                  .
TABLES: ZQTC_EXCL_RESN                 .
TABLES: ZQTC_RENWL_PLAN                .
TABLES: ZQTC_RENWL_PROF                .
