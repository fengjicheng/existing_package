*-------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_NEW_PROJECTMASTER_JANIS
* PROGRAM DESCRIPTION: Create Maintain Media Product Master Records
* This include has been called inside program ZQTCE_NEW_PROJECTMASTER_JANIS,
* Selection screen parameters has declared inside this.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-02-02
* OBJECT ID:E148
* TRANSPORT NUMBER(S):ED2K904337
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PROJECTMASTER_JANIS_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_mtyp_i FOR v_mtart  OBLIGATORY.
PARAMETERS:  p_profl  TYPE profidproj DEFAULT 'Z000001', " Project Profile
             p_xstat  TYPE ps_xstat   DEFAULT 'X',       " Statistical WBS element
             p_plfaz  TYPE ps_plfaz   DEFAULT sy-datum,  " Project planned start date
             p_respno TYPE ps_vernr DEFAULT '00000001',  " Number of the responsible person (project manager)
             p_apppno TYPE ps_astnr DEFAULT '00000001'.  " Applicant number
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE text-002.
PARAMETERS : rb_backg RADIOBUTTON GROUP rb1 USER-COMMAND rucomm DEFAULT 'X', "qm,
             rb_foreg RADIOBUTTON GROUP rb1.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE text-003.
SELECT-OPTIONS: s_issue FOR v_matnr MODIF ID cg1,        " Generated Table for View
                s_prod  FOR v_ismrefmdprod MODIF ID cg1. " MATCHCODE OBJECT .
SELECTION-SCREEN: END OF BLOCK b2.

SELECTION-SCREEN: END OF BLOCK b3.
SELECTION-SCREEN: END OF BLOCK b1.
