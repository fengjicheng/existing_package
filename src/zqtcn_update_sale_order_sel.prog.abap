*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Program to update  sales order
*&                        Rep value
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627
*&----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCE_CREATE_SALES_ORDER_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS : s_input FOR v_input.
SELECTION-SCREEN END OF BLOCK b1.
