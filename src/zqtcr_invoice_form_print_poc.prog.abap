*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVOICE_FORM_F024
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_INVOICE_FORM_F024
* PROGRAM DESCRIPTION: This driver program implemented for invoice form
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 20/03/2017
* OBJECT ID: F024
* TRANSPORT NUMBER(S): ED2K904956
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 1990 / DEFECT 2185
* REFERENCE NO: ED2K905977
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 10-May-2017
* DESCRIPTION: Incorporating changes in date field, Reprint text
*              population and remove negative sign from amount field.
*              Change the mail subject in case of receipt.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2516
* REFERENCE NO: ED2K906421
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 05-June-2017
* DESCRIPTION: Change logic for credit memo. Decide invoice type based
*              on document category.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR_518
* REFERENCE NO: ED2K907360
* DEVELOPER:    SRBOSE
* DATE:         21-July-2017
* DESCRIPTION:  Need to update the item table of the form
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911613
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
REPORT zqtcr_invoice_form_print_poc NO STANDARD PAGE HEADING.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-005.
PARAMETERS:p_vbe TYPE vbrp-vbeln OBLIGATORY.  "Program Name
PARAMETERS:p_mail TYPE AD_SMTPADR OBLIGATORY. "Varaint Name
SELECTION-SCREEN END OF BLOCK b1.
* TOP Include for global data
INCLUDE ZQTCN_INVOICE_FORM_TOP_POC.
*INCLUDE zqtcn_invoice_form_top. " Include ZQTCN_INVOICE_FORM_TOP

* Subroutine for performs.
INCLUDE ZQTCN_INVOICE_FORM_SUB_POC.
START-OF-SELECTION.
PERFORM f_entry_adobe_form.
*INCLUDE zqtcn_invoice_form_sub. " Include ZQTCN_INVOICE_FORM_SUB
* INCLUDE zqtcn_invoice_form_sub_test. "

************************************************************************
*                   Form Routine                                       *
************************************************************************

* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
*FORM f_entry_adobe_form USING  v_ent_retco  LIKE sy-subrc  " ABAP System Field: Return Code of ABAP Statements
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
FORM f_entry_adobe_form." USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
                               "v_ent_scrn   TYPE c. " Screen of type Character
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
* Begin of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
*                              v_ent_screen TYPE c.        " Screen of type Character
* End   of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
* Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', " Neudruck
             lc_prntev_chg TYPE c VALUE '2'. " Änderungsdruck

* Data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation

  CLEAR v_ent_retco.
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
*  v_ent_screen = v_ent_scrn.
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  IF nast-aende EQ space.
* Implement all the processing logic
    PERFORM f_processing_acc_mngd.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* v_ent_retco = 0.
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
*  fp_v_ent_retco = v_ent_retco.
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
ENDFORM.
