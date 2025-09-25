*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECON_BIOS
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* For the Adjustment Type – ‘BIOS”, system will refer “Adjustment quantity
* & automatically create the Goods issue for the quantity mentioned
* in custom table ZQTC_INVEN_RECON.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-04-09
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908477
* REFERENCE NO:  CR#590
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  04-Sep-2017
* DESCRIPTION: For Adjustment Type BIOS similar logic to SOH has been
*              implemented. All the necessary code cleaning is done
*              and hence no tags are avaialble. As this was kind of
*              complete new design from scratch.
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVENT_RECON_BIOS
*&
*&---------------------------------------------------------------------*
REPORT ZQTCR_INVENT_RECON_BIOS NO STANDARD PAGE HEADING
                                    LINE-SIZE  132
                                    LINE-COUNT 65
                                    MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_inv_recon_idoc_bios_top. " For top declaration

*Include for Selection Screen
INCLUDE zqtcn_inv_recon_idoc_bios_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_inv_recon_idoc_bios_f01. " For subroutines
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Clear all the variables
  PERFORM f_clear_variables.

*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

** Lock table ZQTC_INVEN_RECON
  PERFORM f_lock_zqtc_inven_recon.

  IF v_lock IS INITIAL.
* Get the Material number from ZQTC_INVEN_RECON
    PERFORM f_get_zqtc_inven_recon CHANGING i_inven_recon.

* Create purchase Order, Goods Receipt and Goods Issue for Offline Quantity
    PERFORM f_create_po_gr_gi      USING i_inven_recon.

* Unlock table ZQTC_INVEN_RECON
    PERFORM f_unlock_zqtc_inven_recon.
  ENDIF. " IF v_lock IS INITIAL
*&--------------------------------------------------------------------*
*&  END OF SELECTION EVENT:                                           *
*&--------------------------------------------------------------------*
END-OF-SELECTION.

* Prepare the ALV Report:
  PERFORM f_display_records_alv.
