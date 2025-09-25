*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCT_PROD_GROUP................................*
DATA:  BEGIN OF STATUS_ZQTCT_PROD_GROUP              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTCT_PROD_GROUP              .
CONTROLS: TCTRL_ZQTCT_PROD_GROUP
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZQTCV_PROD_GROUP................................*
TABLES: ZQTCV_PROD_GROUP, *ZQTCV_PROD_GROUP. "view work areas
CONTROLS: TCTRL_ZQTCV_PROD_GROUP
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_PROD_GROUP. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_PROD_GROUP.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_PROD_GROUP_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PROD_GROUP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PROD_GROUP_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_PROD_GROUP_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_PROD_GROUP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_PROD_GROUP_TOTAL.

*.........table declarations:.................................*
TABLES: *ZQTCT_PROD_GROUP              .
TABLES: ZQTCT_PROD_GROUP               .
TABLES: ZQTC_PROD_GROUP                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
