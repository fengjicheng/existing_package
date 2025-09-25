*&---------------------------------------------------------------------*
*& Report  ZQTCR_PAYMENT_BLOCK_AUTOMATION
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_PAYMENT_BLOCK_AUTO_E247*
* PROGRAM DESCRIPTION: This program is used to remove delivery blocks
*                      of Contracts and Orders for cleared accounting
*                      documents
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE: 6/22/2020
* OBJECT ID: E247
* TRANSPORT NUMBER(S): ED2K918595
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtce_payment_block_auto_e247.
*----------------------------------------------------------------------*
* Includes  -----------------------------------------------------*
* ---------------------------------------------------------------------*
INCLUDE zqtce_payment_block_automattop.
INCLUDE zqtce_payment_block_automatsel.
INCLUDE zqtce_payment_block_automatf01.
*----------------------------------------------------------------------*
* Initialization-*
* ---------------------------------------------------------------------*
INITIALIZATION.
*--*Initialize global variables and selection screen elements
  PERFORM f_initialization.
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN.
* ---------------------------------------------------------------------*
AT SELECTION-SCREEN.
*--*Validate selection screen variables
  PERFORM f_selection_validation.
*----------------------------------------------------------------------*
* START-OF-SELECTION..
* ---------------------------------------------------------------------*
START-OF-SELECTION.
*--*Get Interface date
  PERFORM f_get_date.
*--*Fetch required data
  PERFORM f_get_data.
*--*Build final Itab
  PERFORM f_process_data.
*--*Remove delivery blocks
  PERFORM f_remove_block.
*----------------------------------------------------------------------*
* END-OF-SELECTION.
* ---------------------------------------------------------------------*
END-OF-SELECTION.
*--*Build field catalog for ALV
  PERFORM f_build_fcat.
*--*Send Output as an Email
  IF s_email IS NOT INITIAL AND i_final IS NOT INITIAL.
    PERFORM f_send_email.
  ENDIF.
*--*Display ALV data
  PERFORM f_display_data.

*--*Update interface table
  PERFORM f_update_interface.
