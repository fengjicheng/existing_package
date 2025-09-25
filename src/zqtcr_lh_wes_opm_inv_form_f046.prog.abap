*&---------------------------------------------------------------------*
*& Report  ZQTCR_LH_WES_OPM_INV_FORM_F046
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_LH_WES_OPM_INV_FORM_F046
* PROGRAM DESCRIPTION: This driver program implemented for OPM invoice form
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 02/26/2018
* OBJECT ID: F046.01
* TRANSPORT NUMBER(S): ED2K914566
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_lh_wes_opm_inv_form_f046  NO STANDARD PAGE HEADING.

INCLUDE zqtcn_lh_wes_opm_inv_form_top IF FOUND.

"Include for Selection Screen
INCLUDE zqtcn_lh_wes_opm_inv_form_scr IF FOUND.

INCLUDE zqtcn_lh_wes_opm_inv_form_f01 IF FOUND.

FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                                 v_ent_scn      TYPE c.       " Ent_screen of type Character
*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

* data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation

  v_ent_retco = 0.
  v_ent_screen = v_ent_scn.
  IF nast-aende EQ space.
* determine print data
    PERFORM f_set_print_data_to_read.
* select print data
    PERFORM f_get_data.
* Implement all the processing logic
    PERFORM f_processing_inv_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.
ENDFORM.
