*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_COND_GRP4..................................*
DATA:  BEGIN OF STATUS_ZQTC_COND_GRP4                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_COND_GRP4                .
CONTROLS: TCTRL_ZQTC_COND_GRP4
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_COND_GRP4                .
TABLES: ZQTC_COND_GRP4                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
