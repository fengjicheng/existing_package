*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZJIRA_SPRINT_DET................................*
DATA:  BEGIN OF STATUS_ZJIRA_SPRINT_DET              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZJIRA_SPRINT_DET              .
CONTROLS: TCTRL_ZJIRA_SPRINT_DET
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZJIRA_SPRINT_DET              .
TABLES: ZJIRA_SPRINT_DET               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
