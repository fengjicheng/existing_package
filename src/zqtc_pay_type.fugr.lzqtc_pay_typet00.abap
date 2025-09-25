*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_PAY_TYPE...................................*
DATA:  BEGIN OF STATUS_ZQTC_PAY_TYPE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_PAY_TYPE                 .
CONTROLS: TCTRL_ZQTC_PAY_TYPE
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZQTCT_PAY_TYPE                .
TABLES: *ZQTC_PAY_TYPE                 .
TABLES: ZQTCT_PAY_TYPE                 .
TABLES: ZQTC_PAY_TYPE                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
