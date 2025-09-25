*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_JRNL_DSPTCH_SCHDLE
* PROGRAM DESCRIPTION: Journal Dispatch Schedule Report
* DEVELOPER:Shivani Upadhyaya
* CREATION DATE:2017-01-13
* OBJECT ID:I0268
* TRANSPORT NUMBER(S):ED2K904120
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K911988                                           *
* REFERENCE NO:ERP-7445                                             *
* DEVELOPER:   GKINTALI (Geeta Kintali)/ HIPATEL (Himanshu Patel)   *
* DATE:        02-May-2018                                          *
* DESCRIPTION: 1. Date Format check box is added on selection screen*
*                 and accordingly date format is changed in the file*
*                 during its population as DD-MMM-YYYY for both     *
*                 JDSR and WMS files.                               *
*-------------------------------------------------------------------*
*&------------------------------------------------------------------*
*&  Include           ZQTCN_JRNL_DSPTCH_SCHDLE_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s02.
SELECT-OPTIONS: s_matnr FOR mara-matnr. " Material Number
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*PARAMETERS: p_shpdat TYPE numc4.
PARAMETERS: p_shpdat TYPE numc4.
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s01.
* BOC - GKINTALI - ERP-7445 - ED2K911988 - 02.05.2018
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS : rb_jd  TYPE c RADIOBUTTON GROUP but1 DEFAULT 'X' USER-COMMAND ucomm.   "Journal
SELECTION-SCREEN COMMENT 5(18) text-s03 FOR FIELD rb_jd.
SELECTION-SCREEN POSITION 53.
PARAMETERS : cb_date AS CHECKBOX USER-COMMAND flag MODIF ID g1.    "Date Format
SELECTION-SCREEN COMMENT 54(30) text-s04 FOR FIELD cb_date.
SELECTION-SCREEN END OF LINE.
* EOC - GKINTALI - ERP-7445 - ED2K911988 - 02.05.2018
PARAMETERS : rb_wms TYPE c RADIOBUTTON GROUP but1.               "WMS

PARAMETERS : p_file TYPE rlgrap-filename MODIF ID g3 OBLIGATORY. " Local file for upload/download
SELECTION-SCREEN END OF BLOCK b2.
