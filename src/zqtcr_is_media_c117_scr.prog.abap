*&---------------------------------------------------------------------*
*&  Include           ZQTCR_IS_MEDIA_C117_SCR
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_IS_MEDIA_C117
*& PROGRAM DESCRIPTION:   IS-Media Products & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:
*& CREATION DATE:         05/05/2022
*& OBJECT ID:             C117
*& TRANSPORT NUMBER(S):
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
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY DEFAULT 'Test.CSV'.
SELECTION-SCREEN: END OF BLOCK b2.
SELECTION-SCREEN: BEGIN OF BLOCK  b3 WITH FRAME TITLE text-072.
  PARAMETERS:r_mat RADIOBUTTON GROUP abc USER-COMMAND ucm DEFAULT 'X',
             r_clf RADIOBUTTON GROUP abc.

SELECTION-SCREEN: END OF BLOCK b3.
SELECTION-SCREEN: END OF BLOCK b1.
