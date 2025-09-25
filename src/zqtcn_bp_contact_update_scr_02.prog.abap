**----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_UPDATE_SCR                       *
* PROGRAM DESCRIPTION:   Program to update the Address details in Business
*                        partners from file
* DEVELOPER:             KJAGANA
* CREATION DATE:         02/13/2019
* OBJECT ID:             C105
* TRANSPORT NUMBER(S):   ED2K914456
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_UPDATE_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS: p_infl LIKE rlgrap-filename OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.
