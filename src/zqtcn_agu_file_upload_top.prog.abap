*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_AGU_FILE_UPLOAD
* PROGRAM DESCRIPTION: This report used to Upload AGU file to AL11
* DEVELOPER:           GKAMMILI
* CREATION DATE:       10/22/2019
* OBJECT ID:           I0368
* TRANSPORT NUMBER(S): ED2K916513
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include          ZQTCR_AGU_FILE_UPLOAD_TOP
*&---------------------------------------------------------------------*
DATA:i_data     TYPE TABLE OF rcgrepfile,
     st_data    LIKE LINE OF i_data.

DATA:v_filename TYPE string.
