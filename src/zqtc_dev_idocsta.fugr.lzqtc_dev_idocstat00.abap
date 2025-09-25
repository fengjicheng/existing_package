*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_DEV_IDOCSTA................................*
DATA:  BEGIN OF STATUS_ZQTC_DEV_IDOCSTA              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_DEV_IDOCSTA              .
CONTROLS: TCTRL_ZQTC_DEV_IDOCSTA
            TYPE TABLEVIEW USING SCREEN '0099'.
*.........table declarations:.................................*
TABLES: *ZQTC_DEV_IDOCSTA              .
TABLES: ZQTC_DEV_IDOCSTA               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
