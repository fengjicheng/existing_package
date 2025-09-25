 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_UPDATE_SALE_ORDER
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Program to update  sales order
*&                        Rep value
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627
*&----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Fixed the issue to not update salesord when
*                         item value is blank
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         05/02/2019
*& OBJECT ID:             INC0241755
*& TRANSPORT NUMBER(S):   ED2K914867
*&*----------------------------------------------------------------------*
 REPORT zqtcr_update_sale_order  NO STANDARD PAGE HEADING
                                  LINE-SIZE 132
                                  LINE-COUNT 65
                                  MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
 INCLUDE zqtcn_update_sale_order_top IF FOUND." IncludeZQTCN_UPDATE_SALE_ORDER_TOP

*Include for Selection Screen
 INCLUDE zqtcn_update_sale_order_sel IF FOUND."Include QTCN_UPDATE_SALE_ORDER_SEL

*Include for Subroutines
 INCLUDE zqtcn_update_sale_order_f01 IF FOUND."Include ZQTCN_UPDATE_SALE_ORDER_F01


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
* Update Sales Order details with reference to Sales Document
   PERFORM f_update_sales_order.

*&--------------------------------------------------------------------*
*&  END OF SELECTION EVENT:                                           *
*&--------------------------------------------------------------------*
 END-OF-SELECTION.
* Prepare the ALV Report:
   PERFORM f_display_records_alv.
