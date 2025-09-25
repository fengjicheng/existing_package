*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCT_EXCL_RESN.................................*
DATA:  BEGIN OF STATUS_ZQTCT_EXCL_RESN               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTCT_EXCL_RESN               .
CONTROLS: TCTRL_ZQTCT_EXCL_RESN
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZQTCV_EXCL_RESN.................................*
TABLES: ZQTCV_EXCL_RESN, *ZQTCV_EXCL_RESN. "view work areas
CONTROLS: TCTRL_ZQTCV_EXCL_RESN
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZQTCV_EXCL_RESN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_EXCL_RESN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_EXCL_RESN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_EXCL_RESN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_EXCL_RESN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_EXCL_RESN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_EXCL_RESN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_EXCL_RESN_TOTAL.

*.........table declarations:.................................*
TABLES: *ZQTCT_EXCL_RESN               .
TABLES: ZQTCT_EXCL_RESN                .
TABLES: ZQTC_EXCL_RESN                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
