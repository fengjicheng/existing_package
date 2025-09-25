*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_USAGE_MGR4.................................*
DATA:  BEGIN OF STATUS_ZQTC_USAGE_MGR4               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_USAGE_MGR4               .
CONTROLS: TCTRL_ZQTC_USAGE_MGR4
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_USAGE_MGR4               .
TABLES: ZQTC_USAGE_MGR4                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
