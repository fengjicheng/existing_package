*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECON_REPT
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* The Purpose of this Report is to enable JRR Report(Printer Reconcillia
* tion) and JDR Report (Distributor Reconcilliation).
* This report will provide summarized as well as detailed report
* Printer Reconcilliation: To reconcile & accountability of the Goods
* transfer between distributor & Printer
* Distributor Reconcilliation:  To post the Goods Receipt from printer,
* WH & Offline. Goods Issue to Offline.
* Distribution Centre Stock Recon:  To reconcile the inventory for
* the Media Issue with Distribution Center Stock on hand.
* DEVELOPER: Lucky Kodwani/Mounika Nallapaneni
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K907465
* REFERENCE NO: ERP-3413
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 26-Jul-2017
* DESCRIPTION: Screen Valdiation errors has been corrected.
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVENT_RECON
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_invent_recon  NO STANDARD PAGE HEADING
                           LINE-SIZE 132
                           LINE-COUNT 65
                           MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_invent_recon_rept_top. " Include ZQTCNR_INVENT_RECON_TOP
*INCLUDE zqtcnr_invent_recon_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtcn_invent_recon_rept_sel. " Include ZQTCR_INVENT_RECON_SEL
*INCLUDE zqtcr_invent_recon_sel IF FOUND.

*Include for Subroutines
INCLUDE zqtcn_invent_recon_rept_sub. " Include ZQTCR_INVENT_RECON_SUB
*INCLUDE zqtcr_invent_recon_sub IF FOUND.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                          *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_matnr.
  IF s_matnr[] IS NOT INITIAL.
* Validate Media Issue
    PERFORM f_validate_matnr USING s_matnr[].
  ENDIF. " IF s_matnr[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_medprd.
  IF s_medprd IS NOT INITIAL.
    PERFORM f_validate_matnr USING s_medprd[].
  ENDIF. " IF s_medprd IS NOT INITIAL

AT SELECTION-SCREEN ON p_publ.
  IF p_publ IS NOT INITIAL.
* Validate media issue year
    PERFORM f_validate_publ USING p_publ.
  ENDIF. " IF p_publ IS NOT INITIAL

AT SELECTION-SCREEN ON s_plant.
* Validate plant
  IF s_plant IS NOT INITIAL.
    PERFORM f_validate_plant USING s_plant[].
  ENDIF. " IF s_plant IS NOT INITIAL

AT SELECTION-SCREEN ON s_mattyp.
  IF s_mattyp IS NOT INITIAL.
* Validate material type
    PERFORM f_validate_mattyp USING s_mattyp[].
  ENDIF. " IF s_mattyp IS NOT INITIAL


AT SELECTION-SCREEN ON s_matofc.
  IF s_matofc IS NOT INITIAL.
* Validate material office
    PERFORM  f_validate_matofc USING s_matofc[].
  ENDIF. " IF s_matofc IS NOT INITIAL

AT SELECTION-SCREEN ON s_medcon.
  IF s_medcon IS NOT INITIAL.
* Validate MRP controller
    PERFORM f_validate_medcon USING s_medcon[].
  ENDIF. " IF s_medcon IS NOT INITIAL

AT SELECTION-SCREEN ON s_print.
  IF  s_print IS NOT INITIAL.
* Validate Printer
    PERFORM  f_validate_vend USING s_print[].
  ENDIF. " IF s_print IS NOT INITIAL

AT SELECTION-SCREEN ON s_distr.
  IF  s_distr IS NOT INITIAL.
* Validate Distributor
    PERFORM  f_validate_vend USING s_distr[].
  ENDIF. " IF s_distr IS NOT INITIAL

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  PERFORM f_validate_data.

*----------------------------------------------------------------------*
*                Initialization                               *
*----------------------------------------------------------------------*
INITIALIZATION.
* Clear all global variables
  PERFORM f_clear_global_variables.

*----------------------------------------------------------------------*
*   A t   S e l e c t i o n   S c r e e n   E v e n t s
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_selectn_screen.

*----------------------------------------------------------------------*
*              Start-of-selection                                       *
*----------------------------------------------------------------------*
START-OF-SELECTION.

*Fatch data from ZCACONSTANT TABLE
  PERFORM f_get_zcaconstant.

  IF rb_prin = abap_true
   OR rb_distr = abap_true.
* Fetch data from mara
    PERFORM f_get_mara.

* Fetch data from marc
    PERFORM f_get_marc.

* Fetch data from constant table
    PERFORM f_get_zqtc_inven_recon.

* Fetch data from ekpo
    PERFORM f_get_ekpo.

* Fetch data from ekbe
    PERFORM f_get_ekbe.

* Fetch data from lfa1
    PERFORM f_get_lfa1.

* Fatch Data from EPRD
    PERFORM f_get_eord.

  ELSEIF rb_repro = abap_true.

* Fatch Data from ZQTC_INVEN_RECON
    PERFORM f_get_repro_inven_recon.

  ENDIF. " IF rb_prin = abap_true
*----------------------------------------------------------------------*
*              End-of-selection                                       *
*----------------------------------------------------------------------*
END-OF-SELECTION.

  IF rb_prin = abap_true
    OR rb_distr = abap_true.

    PERFORM f_populate_final.

    IF rb_prin = abap_true .

      PERFORM f_alv_output_jrr.

    ELSEIF rb_distr = abap_true.

      PERFORM f_populate_jdr_final USING    i_mara
                                            i_ekpo
                                            i_ekbe
                                            i_inven_recon
                                            i_final.

      PERFORM f_alv_output_jdr USING i_jdr_summ.

    ENDIF. " IF rb_prin = abap_true

   ELSEIF rb_repro = abap_true.

    PERFORM f_populate_repro.
    PERFORM f_alv_output_repro.

  ENDIF. " IF rb_prin = abap_true
