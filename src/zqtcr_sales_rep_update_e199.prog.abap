 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_SALES_REP_UPDATE
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_SALES_REP_UPDATE
*& PROGRAM DESCRIPTION:   Program to update original sales order
*&
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627
*&----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Fixed the issue to not update salesord when
*                         item value is blank
*&                        Rep value
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         05/02/2019
*& OBJECT ID:             INC0241755
*& TRANSPORT NUMBER(S):   ED2K914867
*&*----------------------------------------------------------------------*
 REPORT zqtcr_sales_rep_update NO STANDARD PAGE HEADING
                            LINE-SIZE 132
                            LINE-COUNT 65
                            MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
 INCLUDE zqtcn_e199_sales_rep_upd_top IF FOUND. " Include ZQTCN_E199_SALES_REP_UPD_TOP

*Include for Selection Screen
 INCLUDE zqtcn_e199_sales_rep_upd_sel IF FOUND. " Include ZQTCN_E199_SALES_REP_UPD_SEL

*Include for Subroutines
 INCLUDE zqtcn_e199_sales_rep_upd_f01 IF FOUND. " Include ZQTCN_E199_SALES_REP_UP_F01
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
 INITIALIZATION.


* Clear all variables.
   PERFORM f_clear_all.
* Get constant value from ZCACONSTANT Table.
   PERFORM f_get_constants.
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN
*----------------------------------------------------------------------*
 AT SELECTION-SCREEN .
   PERFORM f_validate_sales_rep.
 AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_auart-low.
*Restriction of document types on selection screen.
   PERFORM f_restrict.
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
 START-OF-SELECTION.
* Get the Sales details from vbak vbap and vbpa
   PERFORM f_get_data_det.
*Get the data from PA0002
   PERFORM f_get_data_pa0002.
*Populate  into final internal table to process further.
   PERFORM f_populate_final.
*&--------------------------------------------------------------------*
*&  END OF SELECTION EVENT:                                           *
*&--------------------------------------------------------------------*
 END-OF-SELECTION.
* Prepare the ALV Report:
   PERFORM f_display_records_alv.
