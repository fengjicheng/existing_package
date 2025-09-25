*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_ACTIVITY...................................*
DATA:  BEGIN OF STATUS_ZQTC_ACTIVITY                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_ACTIVITY                 .
CONTROLS: TCTRL_ZQTC_ACTIVITY
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTCT_ACTIVITY                .
TABLES: *ZQTC_ACTIVITY                 .
TABLES: ZQTCT_ACTIVITY                 .
TABLES: ZQTC_ACTIVITY                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
