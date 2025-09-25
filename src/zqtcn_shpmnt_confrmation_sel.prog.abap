*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCN_SHPMNT_CONFRMATION_SEL
* PROGRAM DESCRIPTION: Include to decalare selection screen fields
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2016-12-23
* OBJECT ID: I0256
* TRANSPORT NUMBER(S):ED2K903891(W)/ED2K903977(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Nageswara (NPOLINA)
* Date:  2020-01-06
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SHPMNT_CONFRMATION_SEL
*&---------------------------------------------------------------------*
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
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-044.
SELECT-OPTIONS:s_email  FOR st_adr6-smtp_addr NO INTERVALS MODIF ID pat LOWER CASE.
SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN END OF BLOCK b1.
