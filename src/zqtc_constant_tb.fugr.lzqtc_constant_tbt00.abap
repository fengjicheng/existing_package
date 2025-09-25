*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_CONSTANT_TB................................*
DATA:  BEGIN OF STATUS_ZQTC_CONSTANT_TB              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_CONSTANT_TB              .
CONTROLS: TCTRL_ZQTC_CONSTANT_TB
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_CONSTANT_TB              .
TABLES: ZQTC_CONSTANT_TB               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
