*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_PAY_KEY_TYP................................*
DATA:  BEGIN OF STATUS_ZQTC_PAY_KEY_TYP              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_PAY_KEY_TYP              .
CONTROLS: TCTRL_ZQTC_PAY_KEY_TYP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_PAY_KEY_TYP              .
TABLES: ZQTC_PAY_KEY_TYP               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
