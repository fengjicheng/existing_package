*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVQTC_JGC_SOC...................................*
TABLES: ZVQTC_JGC_SOC, *ZVQTC_JGC_SOC. "view work areas
CONTROLS: TCTRL_ZVQTC_JGC_SOC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVQTC_JGC_SOC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVQTC_JGC_SOC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVQTC_JGC_SOC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVQTC_JGC_SOC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVQTC_JGC_SOC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVQTC_JGC_SOC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVQTC_JGC_SOC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVQTC_JGC_SOC_TOTAL.

*.........table declarations:.................................*
TABLES: TBZ9                           .
TABLES: TBZ9A                          .
TABLES: ZQTC_JGC_SOCIETY               .
