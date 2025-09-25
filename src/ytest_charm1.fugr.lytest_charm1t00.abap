*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YTEST_CHARM1....................................*
DATA:  BEGIN OF STATUS_YTEST_CHARM1                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_YTEST_CHARM1                  .
CONTROLS: TCTRL_YTEST_CHARM1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *YTEST_CHARM1                  .
TABLES: YTEST_CHARM1                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
