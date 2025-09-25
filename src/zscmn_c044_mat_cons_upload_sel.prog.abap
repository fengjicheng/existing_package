*----------------------------------------------------------------------*
* PROGRAM NAME: ZSCMN_C044_MAT_CONS_UPLOAD_SEL
* PROGRAM DESCRIPTION: Load 3 years of consumption history for active
*  materials
* DEVELOPER: Shivani Upadhyaya/Cheenangshuk Das
* CREATION DATE:   2016-07-18
* OBJECT ID: C044
* TRANSPORT NUMBER(S):ED2K902573
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSCMI_C044_MAT_CONS_UPLOAD_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002 .
PARAMETERS: rb_pre  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm, "radiobutton for Presentation server
            rb_appl RADIOBUTTON GROUP rb1 DEFAULT 'X'.         "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b2.
SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS: p_file TYPE localfile MODIF ID fl1. " Local file for upload/download
PARAMETERS: cb_hdr AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
