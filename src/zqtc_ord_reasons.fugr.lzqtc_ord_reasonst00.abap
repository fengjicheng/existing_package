*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_ORD_REASONS................................*
DATA:  BEGIN OF STATUS_ZQTC_ORD_REASONS              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_ORD_REASONS              .
CONTROLS: TCTRL_ZQTC_ORD_REASONS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_ORD_REASONS              .
TABLES: ZQTC_ORD_REASONS               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
