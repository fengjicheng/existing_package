*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_ORDER_TOKEN................................*
DATA:  BEGIN OF STATUS_ZQTC_ORDER_TOKEN              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_ORDER_TOKEN              .
CONTROLS: TCTRL_ZQTC_ORDER_TOKEN
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_ORDER_TOKEN              .
TABLES: ZQTC_ORDER_TOKEN               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
