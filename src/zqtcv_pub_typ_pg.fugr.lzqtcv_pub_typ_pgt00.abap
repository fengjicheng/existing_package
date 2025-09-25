*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_PUB_TYP_PG................................*
TABLES: ZQTCV_PUB_TYP_PG, *ZQTCV_PUB_TYP_PG. "view work areas
CONTROLS: TCTRL_ZQTCV_PUB_TYP_PG
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_PUB_TYP_PG. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_PUB_TYP_PG.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_PUB_TYP_PG_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PUB_TYP_PG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PUB_TYP_PG_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_PUB_TYP_PG_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PUB_TYP_PG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PUB_TYP_PG_TOTAL.

*.........table declarations:.................................*
TABLES: TJPPUBTP                       .
TABLES: TJPPUBTPT                      .
TABLES: ZQTCT_PROD_GROUP               .
TABLES: ZQTC_PROD_GROUP                .
TABLES: ZQTC_PUB_TYP_PG                .
