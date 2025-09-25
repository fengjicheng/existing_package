*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCA_SPRINT1.....................................*
DATA:  BEGIN OF STATUS_ZCA_SPRINT1                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCA_SPRINT1                   .
CONTROLS: TCTRL_ZCA_SPRINT1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCA_SPRINT1                   .
TABLES: ZCA_SPRINT1                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
