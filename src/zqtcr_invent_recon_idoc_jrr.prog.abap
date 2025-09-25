*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Generate a GR IDOC and update the custom table
*                      ZQTC_INVEN_RECON
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-03-27
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
*& Report  ZQTCR_INVENT_RECON_IDOC_R040
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_invent_recon_idoc_jrr MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_inv_recon_idoc_jrr_top IF FOUND.
* Include for slection screen
INCLUDE zqtcn_inv_recon_idoc_jrr_sel IF FOUND.
*Include for the logic for the report
INCLUDE zqtcn_inv_recon_idoc_jrr_f01 IF FOUND.

*----------------------------------------------------------------------*
*                START-OF_SELECTION                                    *
*----------------------------------------------------------------------*
START-OF-SELECTION.
*Populate posting period
  PERFORM f_populate_posting_period.
*Perform to fetch data from ZQTC_INVEN_RECON, EKPO,EKBE
  PERFORM f_fetch_data.
*----------------------------------------------------------------------*
*                END-OF_SELECTION                                      *
*----------------------------------------------------------------------*
END-OF-SELECTION.

**Lock table
  PERFORM f_lock_table.

* ALV Display
  PERFORM f_alv_display USING i_output.
