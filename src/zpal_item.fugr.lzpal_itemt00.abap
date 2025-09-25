*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPAL_ITEM.......................................*
DATA:  BEGIN OF STATUS_ZPAL_ITEM                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPAL_ITEM                     .
CONTROLS: TCTRL_ZPAL_ITEM
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZPAL_ITEM                     .
TABLES: ZPAL_ITEM                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
