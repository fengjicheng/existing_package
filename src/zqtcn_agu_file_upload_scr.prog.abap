*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_AGU_FILE_UPLOAD
* PROGRAM DESCRIPTION: This report used to Upload AGU file to AL11
* DEVELOPER:           GKAMMILI
* CREATION DATE:       10/22/2019
* OBJECT ID:           I0368
* TRANSPORT NUMBER(S):ED2K916513
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include          ZQTCR_AGU_FILE_UPLOAD_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-b01.
PARAMETERS: p_cl_fn   TYPE rlgrap-filename OBLIGATORY,
            p_as_fn   TYPE rlgrap-filename,
            p_as_nm   TYPE rlgrap-filename OBLIGATORY,
            p_over    TYPE c AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.
