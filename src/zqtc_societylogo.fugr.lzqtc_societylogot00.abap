*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_SOCIETYLOGO................................*
DATA:  BEGIN OF STATUS_ZQTC_SOCIETYLOGO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_SOCIETYLOGO              .
CONTROLS: TCTRL_ZQTC_SOCIETYLOGO
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZQTC_SOCIETYLOGO              .
TABLES: ZQTC_SOCIETYLOGO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
