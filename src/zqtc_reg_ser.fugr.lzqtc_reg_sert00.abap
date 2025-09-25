*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_REG_SER....................................*
DATA:  BEGIN OF STATUS_ZQTC_REG_SER                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_REG_SER                  .
CONTROLS: TCTRL_ZQTC_REG_SER
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_REG_SER                  .
TABLES: ZQTC_REG_SER                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
