*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CREDIT_LIMIT_REP_R091
* PROGRAM DESCRIPTION: Customer Credit Limits Report.
* DEVELOPER:           Nageswara
* CREATION DATE:       09/03/2019
* OBJECT ID:           R091
* TRANSPORT NUMBER(S): ED2K916008
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREDIT_LIMIT_SCR
*&---------------------------------------------------------------------*
* Selection Screen

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-b01.
SELECT-OPTIONS:s_bukrs FOR st_t001-bukrs OBLIGATORY,
               s_kunnr FOR st_vbak-kunnr,
               s_land1 FOR st_t005-land1.
SELECT-OPTIONS:s_auart FOR st_vbak-auart.
PARAMETERS:
  p_block  TYPE char1 AS LISTBOX VISIBLE LENGTH 7. "ukm_xblocked
SELECT-OPTIONS: s_reject FOR st_vbuk-abstk,
                s_cancel FOR st_tvkg-kuegru.
SELECT-OPTIONS:s_cldate FOR st_veda-vbedkue,
               s_segmnt FOR st_sgmnt-credit_sgmnt .
SELECTION-SCREEN END OF BLOCK b1.
