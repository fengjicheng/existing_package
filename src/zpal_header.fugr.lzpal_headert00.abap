*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPAL_HEADER.....................................*
DATA:  BEGIN OF STATUS_ZPAL_HEADER                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPAL_HEADER                   .
CONTROLS: TCTRL_ZPAL_HEADER
            TYPE TABLEVIEW USING SCREEN '9003'.
*.........table declarations:.................................*
TABLES: *ZPAL_HEADER                   .
TABLES: ZPAL_HEADER                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
