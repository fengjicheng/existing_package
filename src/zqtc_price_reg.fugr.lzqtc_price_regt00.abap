*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_PRICE_REG..................................*
DATA:  BEGIN OF STATUS_ZQTC_PRICE_REG                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_PRICE_REG                .
CONTROLS: TCTRL_ZQTC_PRICE_REG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_PRICE_REG                .
TABLES: ZQTC_PRICE_REG                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
