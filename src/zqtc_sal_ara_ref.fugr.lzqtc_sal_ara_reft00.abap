*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTC_SAL_ARA_REF................................*
DATA:  BEGIN OF STATUS_ZQTC_SAL_ARA_REF              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_SAL_ARA_REF              .
CONTROLS: TCTRL_ZQTC_SAL_ARA_REF
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: *ZQTC_SAL_ARA_REF              .
TABLES: ZQTC_SAL_ARA_REF               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
