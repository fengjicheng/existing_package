*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SEND_AC_NOTIF_R095_SCR
*&---------------------------------------------------------------------*
*--------------------------- SELECTION SCREEN--------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_optyp  TYPE na_kschl DEFAULT text-002,  " Output Type
             p_ordty  TYPE auart    DEFAULT text-003,  " Order Type
             p_itmcat TYPE pstyv    DEFAULT text-004.  " Item Category
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-005.
PARAMETERS p_cedat TYPE vddat_veda OBLIGATORY.         " Dismantling date as Contract End Date
SELECTION-SCREEN COMMENT 56(7) text-006.
PARAMETERS p_days(3) TYPE n.                           " Days
SELECTION-SCREEN END OF LINE.
PARAMETERS : p_mailty TYPE salv_de_selopt_low AS LISTBOX VISIBLE LENGTH 20 OBLIGATORY. " Email Type
SELECT-OPTIONS : so_grade FOR vbap-mvgr3 NO INTERVALS. " Grade
SELECTION-SCREEN END OF BLOCK b1.
