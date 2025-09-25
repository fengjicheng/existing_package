*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPLD_TABLE_SLS_REP_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPLD_TABLE_SLS_REP_SEL (Selection Screen)
* PROGRAM DESCRIPTION: Maintain Sales Rep PIGS Table Lookup
* DEVELOPER: Mintu Naskar (MNASKAR)
* CREATION DATE:   11/04/2016
* OBJECT ID:  E129
* TRANSPORT NUMBER(S):  ED2K903251
*----------------------------------------------------------------------*
* SELECTION SCREEN-----------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

PARAMETERS: rb_upl  RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 DEFAULT 'X', "Radio button for upload file
            rb_dwnl RADIOBUTTON GROUP rad1.                                "Radio button for download file
*SELECTION-SCREEN SKIP.
*PARAMETER p_intlod TYPE char1 AS CHECKBOX.
SELECTION-SCREEN  BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID z1. "rlgrap-filename    " Local file for upload
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN END OF BLOCK b1.
