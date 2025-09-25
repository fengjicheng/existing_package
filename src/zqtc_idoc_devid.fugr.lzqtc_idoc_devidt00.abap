*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_IDOC_DEVID.................................*
DATA:  BEGIN OF STATUS_ZQTC_IDOC_DEVID               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_IDOC_DEVID               .
CONTROLS: TCTRL_ZQTC_IDOC_DEVID
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZQTC_IDOC_DEVID               .
TABLES: ZQTC_IDOC_DEVID                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
