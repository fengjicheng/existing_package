*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_MASS_UPLD_SCR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/17/2019
*& OBJECT ID:             C110.1
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-001.
PARAMETERS: p_file LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_chk AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b1.
