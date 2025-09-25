*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_INVEN_RECON................................*
DATA:  BEGIN OF STATUS_ZQTC_INVEN_RECON              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_INVEN_RECON              .
CONTROLS: TCTRL_ZQTC_INVEN_RECON
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_INVEN_RECON              .
TABLES: ZQTC_INVEN_RECON               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
