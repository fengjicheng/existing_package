*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_PRODUCT_LANG_REP_R089
* PROGRAM DESCRIPTION: This report used to display Product text from
*                      Material Master.
* DEVELOPER:           Nageswara
* CREATION DATE:       08/19/2019
* OBJECT ID:           R089
* TRANSPORT NUMBER(S): ED2K915908
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PROD_LANG_SCR
*&---------------------------------------------------------------------*
* Selection Screen

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-b01.
SELECT-OPTIONS:s_matnr FOR v_matnr,                             " Material
               s_werks FOR v_werks NO INTERVALS OBLIGATORY,     " Plant
               s_erdat FOR v_erdat.                             " Creation date
SELECTION-SCREEN END OF BLOCK b1.
