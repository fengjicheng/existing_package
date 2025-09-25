*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_PRNT_GOLIVE................................*
DATA:  BEGIN OF STATUS_ZQTC_PRNT_GOLIVE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_PRNT_GOLIVE              .
CONTROLS: TCTRL_ZQTC_PRNT_GOLIVE
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZQTC_PRNT_GOLIVE              .
TABLES: ZQTC_PRNT_GOLIVE               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
