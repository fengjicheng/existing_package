*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCC_CREATE_QUOTATION_C064
* PROGRAM DESCRIPTION: Get the data from input pipe dilimited file,
* Create quotation for the subs order present in input feed file and
* update table ZQTC_RENWL_PLAN.
* All the selection screen parameters has been declared here.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2017-07-03
* DER NUMBER: C064/CR_344
* TRANSPORT NUMBER(S): ED2K907090
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREATE_QUOTATN_C064_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002 .
PARAMETERS: rb_pre  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm, "radiobutton for Presentation server
            rb_appl RADIOBUTTON GROUP rb1 DEFAULT 'X'.         "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS: p_file TYPE localfile MODIF ID fl1. " Local file for upload/download
PARAMETERS: cb_hdr AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4.
SELECT-OPTIONS : s_activ FOR v_active NO INTERVALS NO-EXTENSION DEFAULT 'CQ'. " E095: Activity

PARAMETERS : p_qtype TYPE vbak-auart DEFAULT 'ZSQT',
             p_test  TYPE char1 AS CHECKBOX. " Test of type CHAR1
*         p_activ TYPE zqtc_activity-activity DEFAULT 'CQ' , " E095: Activity

SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN END OF BLOCK b1.
