*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_CREATE_SALES_ORDER_SEL
* PROGRAM DESCRIPTION: Creating sales order with reference to billing document,
* This Report has been called from report ZQTCE_SALES_REP_CHG in background mode.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCE_CREATE_SALES_ORDER_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS : s_input FOR v_input.
SELECTION-SCREEN END OF BLOCK b1.
