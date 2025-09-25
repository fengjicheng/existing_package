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
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7507 (CR)
* REFERENCE NO: ED1K907765
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         20-June-2018
* DESCRIPTION:  Remove ‘E-ISSN’ label in the form
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0200491
* REFERENCE NO: ED1K907808
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         26-June-2018
* DESCRIPTION:  If Customer VAT is registred but not getting layout form
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-15473
* REFERENCE NO:ED2K917966
* DEVELOPER: Siva Guda
* DATE: 04-13-2020
* DESCRIPTION: The current conversion exchange rate on an invoice is
* incorrectly populating. the SAP Function Module CONVERT_TO_LOCAL_CURRENCY
* is not providing the correct stored value in some scenarios which is
* to be used for currency conversion
*----------------------------------------------------------------------*
REPORT zqtcr_invoice_form_f024_as NO STANDARD PAGE HEADING.

* TOP Include for global data
INCLUDE zqtcn_invoice_form_top_f024_as. " Include ZQTCN_INVOICE_FORM_TOP

* Subroutine for performs.
INCLUDE zqtcn_invoice_form_sub_f024_as. " Include ZQTCN_INVOICE_FORM_SUB

************************************************************************
*                   Form Routine                                       *
************************************************************************

* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
*FORM f_entry_adobe_form USING  v_ent_retco  LIKE sy-subrc  " ABAP System Field: Return Code of ABAP Statements
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
FORM f_entry_adobe_form USING  fp_v_ent_retco  LIKE sy-subrc  " ABAP System Field: Return Code of ABAP Statements
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
                               v_ent_scrn   TYPE c.        " Screen of type Character
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
* Begin of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
*                              v_ent_screen TYPE c.        " Screen of type Character
* End   of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
* Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1',   " Neudruck
             lc_prntev_chg TYPE c VALUE '2'.   " Änderungsdruck

* Data declaration
  DATA: lv_xdruvo TYPE t166k-druvo.

  CLEAR v_ent_retco.
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  v_ent_screen = v_ent_scrn.
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  IF nast-aende EQ space.
* Implement all the processing logic
  PERFORM f_processing_acc_mngd.
    lv_xdruvo = lc_prntev_new.
  ELSE.
    lv_xdruvo = lc_prntev_chg.
  ENDIF.
* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* v_ent_retco = 0.
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911613
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  fp_v_ent_retco = v_ent_retco.
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
ENDFORM.
