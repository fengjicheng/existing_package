*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_CLASSIFI_UPLD_SCR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MAT_CLASSIFI_MASS_UPLD
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MAT_CLASSIFI_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Classication Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/20/2019
*& OBJECT ID:             C110.2
*& TRANSPORT NUMBER(S):   ED2K916178
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-001.
PARAMETERS: p_file LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK b1.
