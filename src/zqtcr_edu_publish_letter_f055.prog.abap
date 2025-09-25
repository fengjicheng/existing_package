*&---------------------------------------------------------------------*
*& Report  ZQTCR_EDU_PUB_LET_ZLOC_F055
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_EDU_PUB_LET_ZLOC_F055
* PROGRAM DESCRIPTION: This driver program implemented Lettor of Completion Form
*for ZLOC template
* DEVELOPER: Murali (MIMMADISET)
* CREATION DATE: 11/19/2019
* OBJECT ID: F055
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_edu_publish_letter_f055 NO STANDARD PAGE HEADING.

TYPE-POOLS: szadr.
*- Top include
INCLUDE zqtcn_edu_publish_zloc_top.
*INCLUDE zqtcn_edu_publish_let_top.
*- Subroutine
PARAMETERS:p_vbeln TYPE vbak-vbeln,
           p_item  TYPE vbap-posnr,
           p_parvw TYPE vbpa-parvw.

INCLUDE zqtcn_edu_publish_zloc_f01.
*INCLUDE zqtcn_edu_publish_let_f01.

START-OF-SELECTION.

  PERFORM f_processing_letter_form CHANGING v_ent_retco.
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
    PERFORM f_processing_letter_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.
ENDFORM.
