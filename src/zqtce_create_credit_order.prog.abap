*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCE_SALES_REP_CHG
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
*& Report  ZQTCE_CREATE_SALES_ORDER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtce_create_credit_order  NO STANDARD PAGE HEADING
                                 LINE-SIZE 132
                                 LINE-COUNT 65
                                 MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE ZQTCN_CREATE_CREDIT_ORDER_TOP.
*INCLUDE zqtcn_create_sales_order_top. " Include ZQTCN_CREATE_SALES_ORDER_TOP

*Include for Selection Screen
INCLUDE ZQTCN_CREATE_CREDIT_ORDER_SEL.
*INCLUDE zqtcn_create_sales_order_sel. " Include ZQTCN_CREATE_SALES_ORDER_SEL

*Include for Subroutines
INCLUDE ZQTCN_CREATE_CREDIT_ORDER_F01.
*INCLUDE zqtcn_create_sales_order_f01. " Include ZQTCN_CREATE_SALES_ORDER_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Clear Variable.
  PERFORM f_clear_all.

* Get constant value from ZCACONSTANT Table.
  PERFORM f_get_constants.
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
* Create Sales Order with reference to billing Document
  PERFORM f_create_sales_order.

*&--------------------------------------------------------------------*
*&  END OF SELECTION EVENT:                                           *
*&--------------------------------------------------------------------*
END-OF-SELECTION.
* Prepare the ALV Report:
  PERFORM f_display_records_alv.
