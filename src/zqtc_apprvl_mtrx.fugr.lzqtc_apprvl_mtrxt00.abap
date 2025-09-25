*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZQTCV_APPR_MTRX.................................*
TABLES: ZQTCV_APPR_MTRX, *ZQTCV_APPR_MTRX. "view work areas
CONTROLS: TCTRL_ZQTCV_APPR_MTRX
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZQTCV_APPR_MTRX. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZQTCV_APPR_MTRX.
* Table for entries selected to show on screen
DATA: BEGIN OF ZQTCV_APPR_MTRX_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_APPR_MTRX.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_APPR_MTRX_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZQTCV_APPR_MTRX_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZQTCV_APPR_MTRX.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZQTCV_APPR_MTRX_TOTAL.

*...processing: ZQTC_APPRVL_MTRX................................*
DATA:  BEGIN OF STATUS_ZQTC_APPRVL_MTRX              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZQTC_APPRVL_MTRX              .
CONTROLS: TCTRL_ZQTC_APPRVL_MTRX
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZQTC_APPRVL_MTRX              .
TABLES: ZQTC_APPRVL_MTRX               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
