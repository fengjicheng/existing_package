*&---------------------------------------------------------------------*
*&  Include           ZQTCR_SALES_PARTNER_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SALES_ORDER_UPDATE
* PROGRAM DESCRIPTION: Update Partner Email IDs in Sales Documents
* DEVELOPER: Nageswar (NPOLINA)
* CREATION DATE: 06/25/2018
* OBJECT ID: E208/INC0236477
* TRANSPORT NUMBER(S):  ED2K915303
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS: p_file  TYPE rlgrap-filename . "rlgrap-filename    " Local file for upload
PARAMETERS: p_a_file  TYPE localfile NO-DISPLAY,
            p_job TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid  TYPE syuname  NO-DISPLAY.

SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
