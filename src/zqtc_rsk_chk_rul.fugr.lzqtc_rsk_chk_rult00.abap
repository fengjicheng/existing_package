*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_RSK_CHK_RUL................................*
DATA:  BEGIN OF STATUS_ZQTC_RSK_CHK_RUL              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_RSK_CHK_RUL              .
CONTROLS: TCTRL_ZQTC_RSK_CHK_RUL
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_RSK_CHK_RUL              .
TABLES: ZQTC_RSK_CHK_RUL               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
