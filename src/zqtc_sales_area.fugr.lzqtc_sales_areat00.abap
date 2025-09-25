*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_SALES_AREA.................................*
DATA:  BEGIN OF STATUS_ZQTC_SALES_AREA               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_SALES_AREA               .
CONTROLS: TCTRL_ZQTC_SALES_AREA
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_SALES_AREA               .
TABLES: ZQTC_SALES_AREA                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
