*&---------------------------------------------------------------------*
*& Report  ZQTCR_LH_WES_OPM_INV_FORM_F046
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_LH_WES_OPM_INV_FORM_F046
* PROGRAM DESCRIPTION: This driver program implemented for OPM , SG/AC invoice forms
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 02/26/2018
* OBJECT ID: F046.01 / F046.02 / F047.01
* TRANSPORT NUMBER(S): ED2K914566
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910591
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:SPARIMI
* DATE:  07/15/2019
* DESCRIPTION:OPM UK Invoice and Credit Memo changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920368
* REFERENCE NO    : OTCM-32214 & OTCM-32330(F046)
* DEVELOPER       : VDPATABALL
* DATE            : 11/23/2020
* DESCRIPTION     : WES DA-Invoice,Debit and Credit form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-31644
* REFERENCE NO:  ED2K92108
* DEVELOPER   :  SGUDA
* DATE        :  03/09/2021
* DESCRIPTION :  Exchange Rates Alignment between Batch and Manual Invoices
*----------------------------------------------------------------------*
REPORT zqtcr_lh_wes_inv_form_f046  NO STANDARD PAGE HEADING.
*- Top include
INCLUDE zqtcn_lh_wes_inv_form_top.
*- Subroutine
INCLUDE zqtcn_lh_wes_inv_form_f01.
**Include for DA Invoice form
*BOC by MIMMADISET:OTCM-32214:18/11/2020:ED2K920368
INCLUDE zqtcn_da_wes_inv_form_f02 IF FOUND.
*--------------------------------------------------------------------*
* f_entry_adobe_form
*--------------------------------------------------------------------*
FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                                 v_ent_scn      TYPE c.       " Ent_screen of type Character
*--Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

* data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation
*--------------------------------------------------------------------*

  v_ent_retco = 0.
  v_ent_screen = v_ent_scn.
  IF nast-aende EQ space.
* Implement all the processing logic
    PERFORM f_processing_inv_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.
ENDFORM.
