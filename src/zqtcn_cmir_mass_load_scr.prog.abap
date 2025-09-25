*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CMIR_MASS_LOAD_SCR
*&---------------------------------------------------------------------*
*&*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_CMIR_MASS_LOAD
* PROGRAM DESCRIPTION:   Program to Maintain Customer-Material Info
*                        from file
* DEVELOPER:             VDPATABALL
* CREATION DATE:         02/14/2019
* OBJECT ID:             C107
* TRANSPORT NUMBER(S):   ED2K914467
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-005.
PARAMETERS: p_infl LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK b1.
