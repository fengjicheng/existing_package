*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_SEQ_NUM_RAN................................*
DATA:  BEGIN OF STATUS_ZQTC_SEQ_NUM_RAN              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_SEQ_NUM_RAN              .
CONTROLS: TCTRL_ZQTC_SEQ_NUM_RAN
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_SEQ_NUM_RAN              .
TABLES: ZQTC_SEQ_NUM_RAN               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
