*&----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_SALES_REP_UPDATE
*& PROGRAM DESCRIPTION:   Program to update original sales order
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627,ED2K914867
*&----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E199_SALES_REP_UPD_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-005.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln,                       "Document Number
                s_vkorg FOR v_vkorg ,                         " Sales Organization
                s_kunnr FOR v_kunnr,                          " Customer Number
                s_auart FOR v_auart,                          " Sales doctype
                s_erdat FOR v_erdat.                          "Creationdate
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003 .
PARAMETERS :p_srep1 TYPE persno OBLIGATORY MATCHCODE OBJECT prem, " Standard Selections for HR Master Data Reporting
            p_srep2 TYPE persno MATCHCODE OBJECT prem.    " Standard Selections for HR Master Data Reporting
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
