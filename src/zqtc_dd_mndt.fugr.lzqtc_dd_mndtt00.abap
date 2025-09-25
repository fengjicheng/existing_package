*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_DD_MNDT....................................*
DATA:  BEGIN OF STATUS_ZQTC_DD_MNDT                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_DD_MNDT                  .
CONTROLS: TCTRL_ZQTC_DD_MNDT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_DD_MNDT                  .
TABLES: ZQTC_DD_MNDT                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
