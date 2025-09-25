*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_ITEM_CAT...................................*
DATA:  BEGIN OF STATUS_ZQTC_ITEM_CAT                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_ITEM_CAT                 .
CONTROLS: TCTRL_ZQTC_ITEM_CAT
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_ITEM_CAT                 .
TABLES: ZQTC_ITEM_CAT                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
