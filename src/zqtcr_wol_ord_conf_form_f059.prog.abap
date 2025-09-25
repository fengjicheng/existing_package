*&---------------------------------------------------------------------*
*& Report  ZQTCR_WOL_ORD_CONF_FORM_F059
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_WOL_ORD_CONF_FORM_F059
* PROGRAM DESCRIPTION: This driver program is implemented for WOL
*                      Order Confirmation Email Form
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 17/03/2020
* OBJECT ID: F059
* TRANSPORT NUMBER(S): ED2K917812
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <........>
* REFERENCE NO: <........>
* DEVELOPER: <........>
* DATE: <........>
* DESCRIPTION: <........>
*----------------------------------------------------------------------*
REPORT zqtcr_wol_ord_conf_form_f059 NO STANDARD PAGE HEADING.

*- Top include
INCLUDE zqtcn_wol_ord_conf_form_top.

*- Subroutine
INCLUDE zqtcn_wol_ord_conf_form_f01.

*--------------------------------------------------------------------*
* f_entry_adobe_form
*--------------------------------------------------------------------*
FORM f_entry_adobe_f059  USING fp_v_ent_retco TYPE syst_subrc  " ABAP System Field: Return Code of ABAP Statements
                               fp_v_ent_scn   TYPE c.          " Ent_screen of type Character
* Local Constant Declaration
  CONSTANTS:
    lc_prntev_new TYPE c VALUE '1', " Reprint
    lc_prntev_chg TYPE c VALUE '2'. " Change

* Data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation

*--------------------------------------------------------------------*

  v_ent_retco = 0.
  v_ent_screen = fp_v_ent_scn.
  IF nast-aende EQ space.
    " Implement all the processing logic
    PERFORM f_processing_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.

ENDFORM.
