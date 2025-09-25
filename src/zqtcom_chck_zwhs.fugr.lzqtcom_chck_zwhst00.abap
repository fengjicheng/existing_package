*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCOM_CHCK_ZWHS................................*
DATA:  BEGIN OF STATUS_ZQTCOM_CHCK_ZWHS              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTCOM_CHCK_ZWHS              .
CONTROLS: TCTRL_ZQTCOM_CHCK_ZWHS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTCOM_CHCK_ZWHS              .
TABLES: *ZQTCOM_TXT_ZWHS               .
TABLES: ZQTCOM_CHCK_ZWHS               .
TABLES: ZQTCOM_TXT_ZWHS                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
