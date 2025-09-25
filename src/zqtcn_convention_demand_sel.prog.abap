*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCN_CONVENTION_DEMAND_SEL
* PROGRAM DESCRIPTION: Include for selection screen
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-03-01
* OBJECT ID: E151
* TRANSPORT NUMBER(S): ED2K904707(W),ED2K904827(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONVENTION_DEMAND_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS:
  s_doc_i  FOR v_bsart,   "Purchasing Document Type
  s_acc_i  FOR v_knttp.   "Account Assignment Type
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002 .
PARAMETERS: rb_pre  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm, "radiobutton for Presentation server
            rb_appl RADIOBUTTON GROUP rb1 DEFAULT 'X'.         "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS: p_file TYPE localfile MODIF ID fl1, " Local file for upload/download
            cb_hdr AS CHECKBOX DEFAULT 'X',
            cb_tst AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
