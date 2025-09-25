*&---------------------------------------------------------------------*
*& Report  ZQTCR_EDU_PUBLISHING_INV_F049
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_EDU_PUBLISHING_INV_F049
* PROGRAM DESCRIPTION: This driver program implemented for Knweton
*                      (edu publishing) invoice forms
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 06/14/2019
* OBJECT ID: F049
* TRANSPORT NUMBER(S):ED1K910387
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918223
* REFERENCE NO: F061
* DEVELOPER: AMOHAMMED
* DATE:  06/09/2020
* DESCRIPTION: This INCLUDE is implemented for WLS (Wiley Learning Solutions)
*              Invoice form
*----------------------------------------------------------------------*
REPORT zqtcr_wls_inv_f061  NO STANDARD PAGE HEADING.

TYPE-POOLS: szadr.

*- Top include
INCLUDE zqtcn_edu_publish_inv_top.

*- Subroutine
INCLUDE zqtcn_edu_publish_inv_f01.

*- This include is specially created to write the logic related to F061 form
INCLUDE zqtcn_edu_publish_inv_f02. " AMOHAMMED - 06/09/2020 - ED2K918223

*--------------------------------------------------------------------*
* f_entry_adobe_form
*--------------------------------------------------------------------*
FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                                 v_ent_scn      TYPE c.       " Ent_screen of type Character
*- Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

*- Data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation
*--------------------------------------------------------------------*
  v_ent_retco = 0.
  v_ent_screen = v_ent_scn.
  IF nast-aende EQ space.
*- Implement all the processing logic
    PERFORM f_processing_inv_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.
ENDFORM.
