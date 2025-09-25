*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_MAT_MASS_UPLD_SCR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_WLS_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         03/04/2020
*& OBJECT ID:             C113
*& TRANSPORT NUMBER(S):   ED2K917656
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-071.
SELECTION-SCREEN: BEGIN OF BLOCK  b2 WITH FRAME TITLE text-001.
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY DEFAULT 'Test.XLS'.
SELECTION-SCREEN: END OF BLOCK b2.
SELECTION-SCREEN: BEGIN OF BLOCK  b3 WITH FRAME TITLE text-072.
  PARAMETERS:r_mat RADIOBUTTON GROUP abc USER-COMMAND ucm DEFAULT 'X',
             r_clf RADIOBUTTON GROUP abc.

SELECTION-SCREEN: END OF BLOCK b3.
SELECTION-SCREEN: END OF BLOCK b1.
