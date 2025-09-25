*&---------------------------------------------------------------------*
*& Report  ZQTCR_ICOMP_INV_FORM_F051
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ICOMP_INV_FORM_F051
* PROGRAM DESCRIPTION: This driver program copied from F042 ( driver program and layout)
* to tigger the TBT for intercompany invoice.
* DEVELOPER: Nagireddy Modugu
* CREATION DATE: 07/23/2019
* OBJECT ID: F051
* TRANSPORT NUMBER(S):  ED2K915790
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

REPORT zqtcr_icomp_inv_form_f051 NO STANDARD PAGE HEADING.


INCLUDE zqtcn_icomp_inv_form_top_f051.


INCLUDE zqtcn_icomp_inv_form_sub_f051.

FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements

                                v_ent_scn    TYPE c.       " Ent_screen of type Character

*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

* data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation

  v_ent_retco = 0.
  v_ent_screen = v_ent_scn.
  IF nast-aende EQ space.
* Implement all the processing logic
    PERFORM f_processing_inv_form.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space

  fp_v_ent_retco = v_ent_retco.


ENDFORM.
