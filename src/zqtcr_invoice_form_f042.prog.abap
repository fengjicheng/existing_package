*&---------------------------------------------------------------------*
*& Report  ZQTCR_INVOICE_FORM_F042
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_INVOICE_FORM_F024
* PROGRAM DESCRIPTION: This driver program implemented for invoice form
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 03/04/2017
* OBJECT ID: F042
* TRANSPORT NUMBER(S): ED2K904986
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2319
* REFERENCE NO:ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 25-May-2017
* DESCRIPTION: Incorporating the changes of defect #2319. If payment
*              method is credit card pay (ZLSCH=1), then payment term
*              will not populate
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2276
* REFERENCE NO: ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 05-June-2017
* DESCRIPTION: Change field type of prepaid amount
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2516
* REFERENCE NO: ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 05-June-2017
* DESCRIPTION: Change logic for credit memo. Decide invoice type based
*              on document category.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 6712
* REFERENCE NO: ED2K911002
* DEVELOPER: Writtick Roy (WROY)
* DATE: 22-Feb-2018
* DESCRIPTION: Remove Output Suppression Logic from Driver Program; this
*              will now be controlled through Condition Table / Record
*              Preview will not generate any Email
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: CR_618
* REFERENCE NO:  ED2K908908
* DEVELOPER:   SRBOSE
* DATE:  10-Oct-2017
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911645
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7462
* REFERENCE NO: ED2K913350
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/14/2018
* DESCRIPTION:  If bill-to is Australian customer from 1001 sales org
*               and order has specified Australian titles, need to print
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7480
* REFERENCE NO: ED1K909721
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         02/21/2019
* DESCRIPTION:  Volume/Issue/Cover Month/Cover Year needed on CSS forms.
*               If it Media type is Digital(DI) - Need to print
*               Cover Month/Cover Year/Contract start date/Contract End Date
*               and if it Media type is Print(PH)- Cover Month/Cover Year/Volume/Issue.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-4390
* REFERENCE NO: ED2K918642
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/22/2020
* DESCRIPTION:  Single issue journal invoicing to reduce the manual
*               effort for offline order processing
*----------------------------------------------------------------------*
REPORT zqtcr_invoice_form_f042 NO STANDARD PAGE HEADING.


INCLUDE zqtcn_invoice_form_top_f042. " Include ZQTCN_INVOICE_FORM_TOP_F042

INCLUDE zqtcn_invoice_form_sub_f042. " Include ZQTCN_INVOICE_FORM_SUB_F042

* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911645
*FORM f_entry_adobe_form  USING  v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911645
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
                                v_ent_scn    TYPE c.       " Ent_screen of type Character
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
* Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*                               v_ent_screen TYPE c.       " Ent_screen of type Character
* End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

* data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation

  v_ent_retco = 0.
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
  v_ent_screen = v_ent_scn.
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
  IF nast-aende EQ space.
* Implement all the processing logic
    PERFORM f_processing_inv_form.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911645
* v_ent_retco = 0.
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911645
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
  fp_v_ent_retco = v_ent_retco.
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645

ENDFORM.
