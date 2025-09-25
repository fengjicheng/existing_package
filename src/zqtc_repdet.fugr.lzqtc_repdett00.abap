*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVQTC_REPDET....................................*
TABLES: ZVQTC_REPDET, *ZVQTC_REPDET. "view work areas
CONTROLS: TCTRL_ZVQTC_REPDET
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVQTC_REPDET. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVQTC_REPDET.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVQTC_REPDET_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVQTC_REPDET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVQTC_REPDET_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVQTC_REPDET_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVQTC_REPDET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVQTC_REPDET_TOTAL.

*.........table declarations:.................................*
TABLES: ZQTC_REPDET                    .
