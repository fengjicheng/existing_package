*&---------------------------------------------------------------------*
*& Report  ZQTCR_RELEASE_ORDER_UPDATE
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_RELEASE_ORDER_UPDATE                             *
* PROGRAM DESCRIPTION: This program will update the Reject Reason      *
*                      for release orders of Credit Memo for which     *
*                      reason for rejection is updated                 *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 04/05/2021                                          *
* OBJECT ID      : E267                                                *
* TRANSPORT NUMBER(S): ED2K923233                                      *
*----------------------------------------------------------------------*
REPORT ZQTCR_RELEASE_ORDER_UPDAT_E267.
*----------------------------------------------------------------------*
* Includes  -----------------------------------------------------*
* ---------------------------------------------------------------------*
INCLUDE zqtcn_release_order_updatetop.
INCLUDE zqtcn_release_order_updatesel.
INCLUDE zqtcn_release_order_updatef01.
*----------------------------------------------------------------------*
* Initialization-*
* ---------------------------------------------------------------------*
*INITIALIZATION.
*--*Initialize global variables and selection screen elements
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN.
* ---------------------------------------------------------------------*
*AT SELECTION-SCREEN.
*--*Validate selection screen variables
*----------------------------------------------------------------------*
* START-OF-SELECTION..
* ---------------------------------------------------------------------*
START-OF-SELECTION.
*--*fetch the credit memos with rejected reasons
  PERFORM f_fetch_rejected_creditmemos.

  PERFORM f_update_release_orders.


*----------------------------------------------------------------------*
* END-OF-SELECTION.
* ---------------------------------------------------------------------*
END-OF-SELECTION.
*--*Display ALV data

   PERFORM f_display_output.
