*&---------------------------------------------------------------------*
*& Report  ZQTCR_DELIVERYBLOCK_MANUAL
*&
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_MANUAL                             *
* PROGRAM DESCRIPTION: The orders which are Blocked Manually after 3   *
*                     or more dunning letters sent to customers using  *
*                     T-code ZQTC_UNPAID_ORDERS, for these blocked     *
*                     orders, once the customer paid fully system      *
*                     should remove the block automatically without    *
*                     manual intervention                              *
* DEVELOPER      : VDPATABALL                                          *
* CREATION DATE  : 03/10/2022                                          *
* OBJECT ID      : OTCM-57357 / E353                                                    *
* TRANSPORT NUMBER(S):ED2K926054                                       *
*----------------------------------------------------------------------*
REPORT zqtcr_removing_block_e353.

INCLUDE zqtcn_removing_block_e353_top.  "Top Include
INCLUDE zqtcn_removing_block_e353_sel.  "Selection Screen Include
INCLUDE zqtcn_removing_block_e353_frm.  "Form Include

START-OF-SELECTION.
*---Get the data
  PERFORM f_get_block_data.
*---Check Release blocks
  PERFORM f_check_release_block.

END-OF-SELECTION.
*---Display Data output
  PERFORM f_display_output.
