*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_TAXCAL.....................................*
DATA:  BEGIN OF STATUS_ZQTC_TAXCAL                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_TAXCAL                   .
CONTROLS: TCTRL_ZQTC_TAXCAL
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZQTC_TAXCAL                   .
TABLES: ZQTC_TAXCAL                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
