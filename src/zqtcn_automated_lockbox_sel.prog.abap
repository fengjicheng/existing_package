*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_AUTOMATED_LOCKBOX_E097
* REPORT DESCRIPTION:    Include for selection screen
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         31/07/2017
* OBJECT ID:             E097(CR# 436)
* TRANSPORT NUMBER(S):   ED2K907624(W)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_AUTOMATED_LOCKBOX_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS:
  s_augdt  FOR v_augdt OBLIGATORY,
  s_umskz  FOR v_umskz OBLIGATORY,
  s_bukrs  FOR v_bukrs OBLIGATORY,
  s_blart  FOR v_blart OBLIGATORY,
  s_fkart  FOR v_fkart OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.
