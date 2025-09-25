*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_AUTO_REJ...................................*
DATA:  BEGIN OF STATUS_ZQTC_AUTO_REJ                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_AUTO_REJ                 .
CONTROLS: TCTRL_ZQTC_AUTO_REJ
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_AUTO_REJ                 .
TABLES: ZQTC_AUTO_REJ                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
