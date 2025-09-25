*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_BP_RULES...................................*
DATA:  BEGIN OF STATUS_ZQTC_BP_RULES                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_BP_RULES                 .
CONTROLS: TCTRL_ZQTC_BP_RULES
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZQTC_BP_RULES                 .
TABLES: ZQTC_BP_RULES                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
