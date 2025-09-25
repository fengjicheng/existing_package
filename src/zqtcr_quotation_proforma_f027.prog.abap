*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_QUOTATION_PROFORMA_F027
* REPORT DESCRIPTION:    Driver Program for quotation proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Alankruta Patnaik (APATNAIK)
* CREATION DATE:         01-FEB-2017
* OBJECT ID:             F027
* TRANSPORT NUMBER(S):   ED2K904328
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906216
* REFERENCE NO: ERP-2575
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: Modify the process to display Messages
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: JIRA# ERP-3357
* REFERENCE NO:ED2K906560
* DEVELOPER: Monalisa Dutta
* DATE: 21-July-2017
* DESCRIPTION: Commit work for sending email
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907523
* REFERENCE NO: F027(CR-473)
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2017-07-26
* DESCRIPTION:
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911672
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913797
* REFERENCE NO: ERP-7189 and 7431
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  11/07/2018
* DESCRIPTION: Need to replace MOD10 function module with MOD11
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-17190
* REFERENCE NO: ED2K918549
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         17-June-2020
* DESCRIPTION:  Single Issue Quote
* 1) If document type is ZSIQ then do not display the “Contract Start Date”,
*   “Contract End Date” and “Subscription Term” labels on the output
*	2) Remove the word ‘Start’ from “Start Issue” when document type is ZSIQ
* 3) The statement “Subscriptions will be entered upon receipt of payment.”
*    Should be changed to “Order will be entered upon receipt of payment”
*    when document type is ZSIQ
* 4) German translation for same is - Bestellung wird nach Zahlungseingang bearbeitet
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_QUOTATION_PROFORMA_F027
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_quotation_proforma_f027 NO STANDARD PAGE HEADING
                                     MESSAGE-ID zqtc_r2 .
**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_quot_pro_top. " Include ZQTCN_QUOT_PRO_TOP

*********Subroutine for this report
INCLUDE zqtcn_quot_pro_f00. " Include ZQTCN_QUOT_PRO_F00

************************************************************************
*                   Form Routine                                       *
************************************************************************
*** Form routine where all the processings would be done
FORM f_entry_adobe_form USING fp_v_retcode  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                              fp_v_ent_screen TYPE c.       " Ent_screen of type Character

*--------------------------------------------------------------------*
* Local Data Declaration
*--------------------------------------------------------------------*
  DATA: lv_xdruvo TYPE c, " Xdruvo of type Character
        lv_xfz    TYPE c. " Xfz of type Character

*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck


* Begin of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216
  fp_v_retcode = 0.
* End   of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216
  v_ent_screen = fp_v_ent_screen.
  IF nast-aende EQ space.
*********Perform where all the processing can be done
    PERFORM f_processing.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
* Begin of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216
* v_ent_retco = 0.
* Begin of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911672
* fp_v_retcode = 0.
* End   of DEL:ERP-6960:WROY:25-Mar-2018:ED2K911672
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
  fp_v_retcode = v_retcode.
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911672
* End   of CHANGE:ERP-2575:WROY:05-JUN-2017:ED2K906216

ENDFORM.
