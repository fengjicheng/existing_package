*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_CONTR_SUB..................................*
DATA:  BEGIN OF STATUS_ZQTC_CONTR_SUB                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_CONTR_SUB                .
CONTROLS: TCTRL_ZQTC_CONTR_SUB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_CONTR_SUB                .
TABLES: ZQTC_CONTR_SUB                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
