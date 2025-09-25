*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION:Inventory Reconcilliation
* The Purpose of this Report is to enable JRR Report(Printer Reconcillia
* tion) and JDR Report (Distributor Reconcilliation).
* This report will provide summarized as well as detailed report
* Inside this include all the slection screen parameters has been defined.
* DEVELOPER: Lucky Kodwani/Mounika Nallapaneni
* CREATION DATE:   2017-03-1
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
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
*&  Include           ZQTCR_INVENT_RECON_SEL
*&---------------------------------------------------------------------*



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
* Media Issue
SELECT-OPTIONS: s_matnr FOR v_matnr. " Material Number
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
* Media Product
SELECT-OPTIONS: s_medprd  FOR v_medprd.
PARAMETERS:     p_publ  TYPE  ismjahrgang . " Media issue year number
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
* Plant
SELECT-OPTIONS: s_plant FOR v_werks.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
SELECT-OPTIONS: s_mattyp  FOR v_mattyp MODIF ID rpr,
                s_matofc  FOR v_matofc MODIF ID rpr,
                s_medcon  FOR v_medpro MODIF ID rpr,
                s_distr   FOR v_distr MODIF ID rpr,
                s_print   FOR v_print MODIF ID jdr.
*                s_mvntyp FOR v_mvnyp.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-s06.
PARAMETERS:rb_prin  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm DEFAULT 'X',
           rb_distr RADIOBUTTON GROUP rb1,
           rb_repro RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b6.
