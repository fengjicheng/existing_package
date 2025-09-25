*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZJIRA_SPRINT....................................*
DATA:  BEGIN OF STATUS_ZJIRA_SPRINT                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZJIRA_SPRINT                  .
CONTROLS: TCTRL_ZJIRA_SPRINT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZJIRA_SPRINT                  .
TABLES: ZJIRA_SPRINT                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
