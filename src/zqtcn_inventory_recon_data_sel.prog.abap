*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INVENTORY_RECON_DATA_SEL (Include Program)
* PROGRAM DESCRIPTION: Inventory Reconciliation Data
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   12/22/2016
* OBJECT ID:  I0315
* TRANSPORT NUMBER(S): ED2K903838
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Gopalakrishna (GKAMMILI)
* Date:  2020-01-13
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: rb_soh  RADIOBUTTON GROUP rb1  MODIF ID mi1 DEFAULT 'X' USER-COMMAND comm1.
PARAMETERS: rb_bios RADIOBUTTON GROUP rb1  MODIF ID mi1.
PARAMETERS: rb_jdr  RADIOBUTTON GROUP rb1  MODIF ID mi1.
PARAMETERS: rb_jrr  RADIOBUTTON GROUP rb1  MODIF ID mi1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-004.
*PARAMETERS: rb_appl RADIOBUTTON DEFAULT 'X' USER-COMMAND comm2." appl server
*PARAMETERS: rb_pres RADIOBUTTON GROUP rb5 MODIF ID mi5. " pres server
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-005.
PARAMETERS: p_drctry TYPE localfile. " Directory Name
PARAMETERS: cb_ih AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.
*--SOC by GKAMMILI ERPM2204 13-Jan-2020 ED2K917189
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-006.
SELECT-OPTIONS:s_email  FOR st_adr6-smtp_addr NO INTERVALS MODIF ID pat LOWER CASE.
SELECTION-SCREEN END OF BLOCK b4.
*--EOC by GKAMMILI ERPM2204 13-Jan-2020 ED2K917189
SELECTION-SCREEN END OF BLOCK b1.
