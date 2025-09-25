*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_PRINT_RUN_REPT_R064
* PROGRAM DESCRIPTION: Print Run Report
* The Purpose of this Report is to show number of current
* open subscriptions, the estimated number of offline subscriptions
* un-renewed quantity of a perticular issue.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PRINT_RUN_REPT_R064_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

SELECT-OPTIONS: s_matnr  FOR v_matnr. " Generated Table for View

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
SELECT-OPTIONS: s_medprd FOR v_medprd.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS:  s_publdt FOR v_ismpubldate,
*Begin of change RKUMAR2 OTCM-16722 remove restrictions for Publication year
*                 s_pubyr  FOR v_pbyear NO INTERVALS NO-EXTENSION. " Media issue year number
                 s_pubyr  FOR v_pbyear. " Media issue year number
*End of change RKUMAR2 OTCM-16722

SELECT-OPTIONS:  s_doctyp FOR v_auart NO INTERVALS DEFAULT 'ZSRO', " Exclude Order Doc Type
                 s_contyp FOR v_auart NO INTERVALS OBLIGATORY.     " Include Contract Doc Type
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
PARAMETERS: p_month TYPE kmonth. " Period to analyze - month
SELECTION-SCREEN END OF BLOCK b4.


SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.

PARAMETERS:     p_mtart	 TYPE mtart DEFAULT 'ZJIP',  " Material Type
                p_itype  TYPE ismidcodetype DEFAULT 'ZJCD',
                p_adjtyp TYPE zadjtyp DEFAULT 'JDR'. " Adjustment Type
SELECT-OPTIONS: s_bwart  FOR v_bwart .

PARAMETERS:     p_wrttp TYPE co_wrttp DEFAULT '10'. " Value Type

SELECTION-SCREEN END OF BLOCK b5.
