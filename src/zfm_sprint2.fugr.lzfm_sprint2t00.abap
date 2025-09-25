*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCA_SPRINT2.....................................*
DATA:  BEGIN OF STATUS_ZCA_SPRINT2                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCA_SPRINT2                   .
CONTROLS: TCTRL_ZCA_SPRINT2
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCA_SPRINT2                   .
TABLES: ZCA_SPRINT2                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
