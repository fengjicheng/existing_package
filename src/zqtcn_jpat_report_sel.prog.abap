*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_REPORT_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: rb_sum RADIOBUTTON GROUP grp1 DEFAULT 'X' USER-COMMAND uc1.  " Radio button for Summary report
SELECTION-SCREEN COMMENT 10(15) text-002 FOR FIELD rb_sum.
PARAMETERS: rb_det RADIOBUTTON GROUP grp1.
SELECTION-SCREEN COMMENT 30(15) text-003 FOR FIELD rb_det.               " Radio button for detail report
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN  OF BLOCK b2 WITH FRAME TITLE text-005.

SELECT-OPTIONS : s_matnr FOR zcds_jpat_marcm-media_issue.                " Media Issue

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-004 FOR FIELD p_year .
PARAMETERS     : p_year(4) TYPE n MODIF ID sg1 .                         " Publication Year
SELECTION-SCREEN END OF LINE.
PARAMETERS     : p_month TYPE zmonth MODIF ID sg2.                       " Month
SELECT-OPTIONS :s_auart FOR vbak-auart NO INTERVALS MODIF ID sg1,        " Order type
                s_vkaus FOR vbap-vkaus NO INTERVALS MODIF ID sg1.        " Usage type

SELECTION-SCREEN END OF BLOCK b2.
