*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_CTRY_REG...................................*
DATA:  BEGIN OF STATUS_ZQTC_CTRY_REG                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_CTRY_REG                 .
CONTROLS: TCTRL_ZQTC_CTRY_REG
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_CTRY_REG                 .
TABLES: ZQTC_CTRY_REG                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
