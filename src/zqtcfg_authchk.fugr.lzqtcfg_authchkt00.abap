*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCT_AUTH_CHECK................................*
DATA:  BEGIN OF STATUS_ZQTCT_AUTH_CHECK              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTCT_AUTH_CHECK              .
CONTROLS: TCTRL_ZQTCT_AUTH_CHECK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTCT_AUTH_CHECK              .
TABLES: ZQTCT_AUTH_CHECK               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
