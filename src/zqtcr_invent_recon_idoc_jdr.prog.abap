*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECON_JDR
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* Based on the successful upload from JFDS Interface i.e.,
* I0315 to custom table ‘ZQTC_INVEN_RECON’, Automatic goods
* receipt and goods issue will be posted. However before posting
* the Goods receipt, Free of Cost Purchase Order will be created
* using ‘BAPI_PO_CREATE1’ function module.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO:ED2K905979
* REFERENCE NO:  R040(JIRA Defect ERP_2215)
* DEVELOPER: Lucky Kodwani
* DATE:  2017-05-23
* DESCRIPTION: Changes has done inside below tags
* Begin of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
* End of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
*-------------------------------------------------------------------
* Revision No: ED2K910553
* Reference No: ERP-6110
* Developer: Pavan Bandlapalli(PBANDLAPAL)
* Date:  2018-01-30
* Description: 1. Added Account Assignment (p_acctas) and Item category
*              (p_itmcat) fields in the selection screen to populate
*              during PO creation.
*              2. Added logic to get the delivery address number and
*                 cost center which is being used during PO creation.
*              3. Removed the logic for Goods Receipt as per the design
*                 its not needed any more. Also removed GI movement type
*                 from the selection screen(p_mvt_gi).
*------------------------------------------------------------------- *
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVENT_RECON_JDR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_invent_recon_jdr  NO STANDARD PAGE HEADING
                                    LINE-SIZE  132
                                    LINE-COUNT 65
                                    MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_inv_recon_idoc_jdr_top. " For top declaration

*Include for Selection Screen
INCLUDE zqtcn_inv_recon_idoc_jdr_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_inv_recon_idoc_jdr_f01. " For subroutines
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate constants from ZCACONSTANT table
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
