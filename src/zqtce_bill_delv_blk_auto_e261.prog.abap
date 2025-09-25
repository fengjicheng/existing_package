*&---------------------------------------------------------------------*
*& Report  ZQTCE_BILL_DELV_BLK_AUTO_E261
*&
*&---------------------------------------------------------------------*
*& PROGRAM NAME: ZQTCE_BILL_DELV_BLK_AUTO_E261
*& PROGRAM DESCRIPTION: As a CSR, I need the system to automatically
*&                      release DG billing and delivery blocks on
*&                      existing orders/subs when the DG block is
*&                      removed from the customer in order to service
*&                      our customer quicker
*& DEVELOPER: AMOHAMMED
*& CREATION DATE: 11/24/2020
*& OBJECT ID: E261
*& TRANSPORT NUMBER(S): ED2K920450
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:
*& REFERENCE NO:
*& DEVELOPER:
*& DATE:
*& DESCRIPTION:
*&---------------------------------------------------------------------*
REPORT zqtce_bill_delv_blk_auto_e261.
*&----------------------------INCLUDES---------------------------------*
INCLUDE zqtcn_bil_del_blk_ato_e261_top.
*INCLUDE zqtce_bill_delv_blk_auto_top. " Top Include
INCLUDE zqtcn_bil_del_blk_ato_e261_sel.
*INCLUDE zqtce_bill_delv_blk_auto_sel. " Selection screen elements
INCLUDE zqtcn_bil_del_blk_ato_e261_f01.
*INCLUDE zqtce_bill_delv_blk_auto_f01. " Include for Subroutines
*&-------------------------INITIALIZATION------------------------------*
INITIALIZATION.
  " Initialize global variables and selection screen elements
  PERFORM f_initialization.
*&----------------------AT SELECTION-SCREEN----------------------------*
AT SELECTION-SCREEN.
  " Validate selection screen variables
  PERFORM f_selection_validation.
*&-----------------------START-OF-SELECTION----------------------------*
START-OF-SELECTION.
  " Fetch required data and Remove Billing and Delivery blocks
  PERFORM f_get_data_remove_blocks.
*&------------------------END-OF-SELECTION-----------------------------*
END-OF-SELECTION.
  " Build the field catalog for ALV output
  PERFORM f_build_fcat.
  " Display ALV output
  PERFORM f_display_data.
