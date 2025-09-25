*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILE_UPLOAD_ORDBP_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_FILE_UPLOAD_ORDBP_SEL(Include Program for Selection Screen)
* PROGRAM DESCRIPTION: Single Upload Process for BP/Order
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   08/13/2018
* OBJECT ID:  I0358
* TRANSPORT NUMBER(S):  ED2K913027
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:   1.0
* Reference No:  ERP7787
* Developer:     Nageswar (NPOLINA)
* Date:          02/18/2019
* Description:   Add Invoice Instructions to Upload
* TRANSPORT NUMBER(S):  ED2K914488
*------------------------------------------------------------------- *
* SELECTION SCREEN-----------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS: p_kunnr TYPE kunnr. " Customer Number
*PARAMETERS: p_file TYPE rlgrap-filename MODIF ID z1. " Local file for upload/download
PARAMETERS: p_file TYPE ibipparms-path MODIF ID z1.
SELECTION-SCREEN: FUNCTION KEY 1.                     "  NPOLINA ERP7787 ED2K914488
SELECTION-SCREEN END OF BLOCK b1.
