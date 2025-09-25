*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECON_SOH
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-03
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVENT_RECON_SOH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_invent_recon_idoc_soh MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_invent_rec_idoc_soh_top IF FOUND.
*INCLUDE zqtcn_invent_recon_soh_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtcn_invent_rec_idoc_soh_sel IF FOUND.
*INCLUDE zqtcn_invent_recon_soh_sel IF FOUND.

*Include for Subroutines
INCLUDE zqtcn_invent_rec_idoc_soh_sub IF FOUND.
*INCLUDE zqtcn_invent_recon_soh_sub IF FOUND.

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate constants from ZCACONSTANT table
  PERFORM f_clear_variables.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  PERFORM f_validate_data USING p_adjtyp.

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
*
