*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_CUST_CR_GRP................................*
DATA:  BEGIN OF STATUS_ZQTC_CUST_CR_GRP              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_CUST_CR_GRP              .
CONTROLS: TCTRL_ZQTC_CUST_CR_GRP
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_CUST_CR_GRP              .
TABLES: ZQTC_CUST_CR_GRP               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
