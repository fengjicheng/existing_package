*&---------------------------------------------------------------------*
*&  Include      ZQTCN_INVOICE_FORM_SUB_F042
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_INVOICE_FORM_F042
* PROGRAM DESCRIPTION: This include is implemented for global data
*                      declaration
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 03/04/2017
* OBJECT ID: F042
* TRANSPORT NUMBER(S): ED2K904986
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2319
* REFERENCE NO: ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 25-May-2017
* DESCRIPTION: Incorporating the changes of defect #2319. If payment
*              method is credit card pay (ZLSCH=1), then payment term
*              will not populate and if total due is 0, then also term
*              should not be populated.
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
*              on document category. Add logic for PO Number.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2285
* REFERENCE NO: ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 06-June-2017
* DESCRIPTION: Change logic for email id fetching. Email id should be
*              lied within validity date. Also check BP related values.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 3069
* REFERENCE NO: ED2K907145
* DEVELOPER: Writtick Roy (WROY)
* DATE: 06-July-2017
* DESCRIPTION: Use explicit 'commit work' if not in update task
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2977
* REFERENCE NO: ED2K907194
* DEVELOPER: Writtick Roy (WROY)
* DATE: 10-July-2017
* DESCRIPTION: Get Address Details from transaction data (Order)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 5055
* REFERENCE NO: ED2K909977
* DEVELOPER: Writtick Roy (WROY)
* DATE: 13-December-2017
* DESCRIPTION: Consider Company Code Country as the "Country of Origin"
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 6595
* REFERENCE NO: ED2K910861
* DEVELOPER: Writtick Roy (WROY)
* DATE: 12-Feb-2018
* DESCRIPTION: Consider multiple Pre-paid amounts for CC Payments
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 6663
* REFERENCE NO: ED2K910930
* DEVELOPER: Writtick Roy (WROY)
* DATE: 15-Feb-2018
* DESCRIPTION: Fix logic for Prepaid Amount (in case of multiple Auth)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 6660
* REFERENCE NO: ED2K910930
* DEVELOPER: Writtick Roy (WROY)
* DATE: 15-Feb-2018
* DESCRIPTION: Populate "Net Value" as the taxable amount, if Tax entry
*              is not available in KOMV table
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
* REVISION NO:  ERP-7017
* REFERENCE NO: ED2K911317
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         13/03/2018
* DESCRIPTION:  Exchange Rates should only be displayed if Currencies
* are different
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7178 (CR)
* REFERENCE NO: ED2K911550
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         21/03/2018
* DESCRIPTION:  Display Exchange Rates if Document Currency and Local
*               Currency are different
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7143
* REFERENCE NO: ED2K911550
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         23/03/2018
* DESCRIPTION:  Invoice Date should be Billing Date (not Creation Date)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911645
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7332
* REFERENCE NO: ED2K911720
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         02-Apr-2018
* DESCRIPTION:  Billtrust Amount (SAP format --> External format)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0194261
* REFERENCE NO: ED1K907222
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         11-May-2018
* DESCRIPTION:  Activating print option from print preview
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0194372
* REFERENCE NO: ED1K907337
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         17-May-2018
* DESCRIPTION:  Tax box missing for invoices related to ZCOP orders
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0196380
* REFERENCE NO: ED1K907491
* DEVELOPER:    Monalisa Dutta(MODUTTA)
* DATE:         24-May-2018
* DESCRIPTION:  Invoice for Single Issues description not displaying
*               correctly
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7507 (CR)
* REFERENCE NO: ED1K907763
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         20-June-2018
* DESCRIPTION:  Remove anything that is ISSN, E-ISSN or Print ISSN label in the form
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0200387 & INC0201954
* REFERENCE NO: ED1K907931
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         11-July-2018
* DESCRIPTION:  GB Seller VAT number getting duplicates in output forms
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912425
* REFERENCE NO: ERP-6458
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         20-Aug-2018
* DESCRIPTION:  Implement logic for retrieving Supplement Docs
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-7730
* REFERENCE NO: ED2K913596
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         15-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR# 7431 & 7189
* REFERENCE NO: ED2K913809
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         09-November-2018
* DESCRIPTION:  Changes for Remittance Coupon
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR# 6376
* REFERENCE NO: ED2K913918
* DEVELOPER:    Kiran jagana(kjagana)
* DATE:         27-November-2018
* DESCRIPTION:  Changes for Member ship type, if material group5 is IN
* and Customer type is summary invoice or detail invoice
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0216814,INC0218384
* REFERENCE NO: ED1K909026
* DEVELOPER:    Nageswara Rao Polina (NPOLINA)/
*               Rajasekhar.T (RBTIRUMALA
* DATE:         04/12/2018
* DESCRIPTION:  INC0218384: To populate Fiscal Year based on contract
*               Start Date compare with VBRP-VGBEL and VBRP-VGPOS
*               INC0216814:To  display no of issues based on Item and
*               Material instead of only material to avoid data mismatch
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0230447
* REFERENCE NO: ED1K909573
* DEVELOPER:    Rajasekhar.T (RBTIRUMALA)
* DATE:         02/19/2019
* DESCRIPTION:  Incorrect totals in Shipping Fee
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR# 6376
* REFERENCE NO: ED2K914840
* DEVELOPER:    Prabhu(ptufaram)
* DATE:         22-April-2019
* DESCRIPTION:  Combine Summery and detailed output when customer attribute6
*               is assigned to 001 for the Society layout(ZSOC) output.
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
* REVISION NO:  CR- 7841
* REFERENCE NO: ED1K910147
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         30-Apr-2019
* DESCRIPTION:  Replace the 'Year' in item section with 'Contract start date'
*               and 'Contract End Date'.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR - 7282
* REFERENCE NO: ED1K910185
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         20-May-2019
* DESCRIPTION:  F042 Post Go Live Changes
* 1) For Society invoices, credits, and receipts we need to state
*    Society name and have logo.
* 2) Need to change text: "Multi Year Subs:" to "Subscription Term:"
* 3) For offline and indirect society billing docs (material group OF or IN),
*    we need to include the membership type (condition group 2) on the form
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  DM - 1932
* REFERENCE NO: ED2K915669
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09-July-2019
* DESCRIPTION:  Correction to Invoice/Credits structure - price missing
*  The Requirement of this CR is to show / populate “Unit Price” in the
*  outbound Billing Documents Invoices – ZF2, Credit Memo’s – ZCR & Proforma Invoices – ZF5.
*· New column to be added in the current output layout with description “Unit Price”.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  DM - 1886
* REFERENCE NO: ED2K915669
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         10-July-2019
* DESCRIPTION:  Need to diaply like 'Tax Invoice' for ZF2 and 'Tax Credit' for
*               ZCR, if billing country is 1001 and ship to is Inida.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-1380
* REFERENCE NO: ED2K916628
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         29-OCT-2019
* DESCRIPTION:  Invoices(ZF2) and Credit Memo)ZCR) output Forms Currency
*               is converted to local currency of the Bill-To, this need
*               to be suppressed.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-1459
* REFERENCE NO: ED2K916657
* DEVELOPER: Siva Guda
* DATE: 01-Nov-2019
* DESCRIPTION: Remove Prepaid amount for Credit Memp's
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-2048
* REFERENCE NO: ED2K917207
* DEVELOPER: Siva Guda
* DATE: 07-Jan-2020
* DESCRIPTION: Add settlement start and end dates, if billing document type is
*              'ZIBP' and changes should be applicable to ZSOC output along with
*              summary layout.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-1380
* REFERENCE NO:ED2K917952
* DEVELOPER: Siva Guda
* DATE: 04-09-2020
* DESCRIPTION: Currency Conversion to be removed from Invoices & Credit Memo Forms
* for Certain Countries like( China, India and South Korea )
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-15474
* REFERENCE NO:ED2K917952
* DEVELOPER: Siva Guda
* DATE: 04-09-2020
* DESCRIPTION: The current conversion exchange rate on an invoice is
* incorrectly populating. the SAP Function Module CONVERT_TO_LOCAL_CURRENCY
* is not providing the correct stored value in some scenarios which is
* to be used for currency conversion
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-4390
* REFERENCE NO: ED2K918642
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/22/2020
* DESCRIPTION:  Single issue journal invoicing to reduce the manual
*               effort for offline order processing
*               JPY amount not to allow decimal points in amounts.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-2232
* REFERENCE NO: ED2K918761
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/29/2020
* DESCRIPTION:  Reflect Fright forwarder on billing documents where Ship-to currently resides.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-24393
* REFERENCE NO: ED2K919427
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/09/2020
* DESCRIPTION:  DD Mandate Enhancement for VCH Renewals and Firm Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-24413
* REFERENCE NO: ED2K919502
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/14/2020
* DESCRIPTION: Direct Debit Receipt Creation and Billing Doc Suppression
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_INV_FORM
*&---------------------------------------------------------------------*
*   Subroutine to implement all the processing logic
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing_inv_form.

* Clear data
  PERFORM f_get_clear.

* Subroutine to populate wiley logo
  PERFORM f_populate_logo_wiley CHANGING v_xstring.

* Perform to populate billing data from NAST table
  PERFORM f_get_bill_data    USING nast
                          CHANGING st_vbco3
                                   v_output_typ
                                   v_proc_status.


* Subroutine to fetch constant values
  PERFORM f_get_constant_values  CHANGING r_inv
                                          r_crd
                                          r_dbt
                                          v_outputyp_css
                                          v_outputyp_tbt
                                          v_outputyp_soc
                                          r_country
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
                                          i_tax_id
                                          r_mtart_med_issue
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
                                          v_country_key
                                          r_aust_text   " ERP-7462:SGUDA:14-SEP-2018:ED2K913350
                                          r_sales_org_text " ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                                          r_cinv
                                          r_ccrd.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

* Subroutine to populate society logo
  IF v_output_typ = v_outputyp_soc. "(++ BY SRBOSE CR_666)
    PERFORM f_populate_logo_society    USING st_vbco3
                                    CHANGING v_society_logo
                                             v_society_text.
  ENDIF. " IF v_output_typ = v_outputyp_soc

* Retrieve Billing Document data
  PERFORM f_get_vbrk_value    USING st_vbco3
                           CHANGING st_vbrk
                                    i_tax_data.


* Retrieve Item data of Billing Document
  PERFORM f_get_vbrp_value    USING st_vbrk
                           CHANGING i_vbrp.

* Retrieve Sales Document Flow.
  PERFORM f_get_vbfa    USING st_vbrk
                              i_vbrp
                     CHANGING i_vbfa
                              i_jksesched.

* Retrieve Sales Document: Partner data
  PERFORM f_get_vbpa_value  USING st_vbrk
                           CHANGING i_vbpa.
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
* Subroutine to populate society logo
  IF v_output_typ = v_outputyp_soc. "(++ BY SRBOSE CR_666)
    PERFORM f_populate_logo_society    USING st_vbco3
                                    CHANGING v_society_logo
                                             v_society_text.
  ENDIF. " IF v_output_typ = v_outputyp_soc
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
* Retrieve Purchase Order Number
  PERFORM f_get_vbkd    USING i_vbfa
                     CHANGING i_vbkd.
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
  PERFORM f_get_fplt    USING i_vbkd
                     CHANGING i_fplt.
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207

* Retrieve Customer VAT
  PERFORM f_get_kna1    USING st_vbrk
                     CHANGING st_kna1.

* Populate header data
  PERFORM f_populate_detail_inv_header  USING st_vbrk
                                              i_vbpa
                                              i_vbrp
                                              i_vbfa
                                              i_vbkd
                                              st_kna1
                                              v_country_key
                                     CHANGING st_header.

  SET COUNTRY st_header-bill_country.

* Retrieve material data from MARA table.
  PERFORM f_get_mara_value USING i_vbrp
                                 i_vbfa
                                 i_jksesched
                        CHANGING i_mara
                                 i_mara_lvl2
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                 i_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                 v_subscription_typ.

* Retrieve ID codes of material
  PERFORM f_get_jptidcdassign    USING i_vbrp
                              CHANGING i_jptidcdassign.

* Subroutine to get address
  PERFORM f_get_emailid_val USING st_header
                         CHANGING i_emailid.

* Retrieve prepaid amount
  PERFORM f_get_prepaid_amount    USING st_vbrk
                               CHANGING v_prepaid_amount
                                        v_paid_amt.

***  Commented by MODUTTA on 13/11/2017 for JIRA# 5069
** Fetch texts for layout
*  PERFORM f_fetch_title_text   USING st_vbrk
*                                     r_country
*                            CHANGING st_header
*                                     v_accmngd_title
*                                     v_invoice_title  "(++SRBOSE CR_618)
*                                     v_reprint
*                                     v_tax
*                                     v_remit_to
*                                     v_footer
*                                     v_bank_detail
*                                     v_crdt_card_det
*                                     v_payment_detail
*                                     v_cust_service_det
*                                     v_totaldue
*                                     v_subtotal
*                                     v_prepaidamt
*                                     v_vat
*                                     v_shipping
*                                     v_payment_detail_inv.

***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
  PERFORM f_get_t005_data CHANGING v_waers
                                   v_ind.
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
  PERFORM f_get_stxh_data USING    st_header
                          CHANGING i_std_text.
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
  CLEAR :v_aust_text,v_ind_text,v_tax_expt.
  PERFORM f_get_texts USING st_vbrk
                            i_vbrp
                            i_vbpa  "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
                      CHANGING v_aust_text
                               v_ind_text  "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
                               v_tax_expt. "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
  PERFORM f_get_gst USING st_header.
* End of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
  IF v_output_typ EQ v_outputyp_css.
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*    AND  v_bstzd_flag IS NOT INITIAL. "++Change by MODUTTA
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
    PERFORM f_populate_layout_css.

  ELSEIF v_output_typ EQ v_outputyp_tbt.
    PERFORM f_populate_layout_tbt.

  ELSEIF v_output_typ EQ v_outputyp_soc.
    PERFORM f_populate_layout_society.

  ENDIF. " IF v_output_typ EQ v_outputyp_css

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LOGO_WILEY
*&---------------------------------------------------------------------*
* Subroutine to print wiley logo
*----------------------------------------------------------------------*
*      <--P_V_XSTRING  text
*----------------------------------------------------------------------*
FORM f_populate_logo_wiley  CHANGING fp_v_xstring TYPE xstring..

* Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON',         " Graphic type
              lc_za        TYPE vbpa-parvw VALUE 'ZA'. "ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292

* To Get a BDS Graphic in BMP Format
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object    " GRAPHICS
      p_name         = lc_logo_name " ZJWILEY_LOGO
      p_id           = lc_id        " BMAP
      p_btype        = lc_btype     " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc NE 0.
    CLEAR fp_v_xstring.
  ENDIF. " IF sy-subrc NE 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BILL_DATA
*&---------------------------------------------------------------------*
*  Subroutine to get data from NAST table
*----------------------------------------------------------------------*
*      -->FP_NAST
*      <--FP_ST_VBCO3
*      <--FP_V_PROC_STATUS
*----------------------------------------------------------------------*
FORM f_get_bill_data  USING    fp_nast           TYPE nast      " Message Status
                      CHANGING fp_st_vbco3       TYPE vbco3     " Sales Doc.Access Methods: Key Fields: Document Printing
                               fp_v_outputtyp    TYPE sna_kschl " Message type
                               fp_v_proc_status  TYPE na_vstat. " Processing status of message

  CLEAR fp_st_vbco3.
* Populate sales data in local structure.
  fp_st_vbco3-mandt = sy-mandt. " Client
  fp_st_vbco3-spras = fp_nast-spras. " Language Key
  fp_st_vbco3-vbeln = fp_nast-objky+0(10). " Sales and Distribution Document Number
  fp_st_vbco3-posnr = fp_nast-objky+10(6). " Item number of the SD document
  fp_v_proc_status  = fp_nast-vstat.
  fp_v_outputtyp    = fp_nast-kschl. " output type

  TABLES: vbrp, " Billing Document: Item Data
          mara. " General Material Data

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LOGO_SOCIETY
*&---------------------------------------------------------------------*
* Subroutine to print society logo
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3  text
*      <--FP_V_SOCIETY_LOGO  text
*------------------------------------------------------ ----------------*
FORM f_populate_logo_society  USING    fp_st_vbco3       TYPE vbco3     " Sales Doc.Access Methods: Key Fields: Document Printing
                              CHANGING fp_v_society_logo TYPE xstring
                                       fp_v_society_text TYPE string.    "name1_gp. " Name 1

********Local constant declaration
  CONSTANTS : lc_invoice TYPE char10     VALUE 'INVOICE',  " Order of type CHAR10
              lc_object  TYPE tdobjectgr VALUE 'GRAPHICS', " SAPscript Graphics Management: Application object
              lc_id      TYPE tdidgr     VALUE 'BMAP',     " SAPscript Graphics Management: ID
              lc_btype   TYPE tdbtype    VALUE 'BCOL',     " Graphic type
              lc_za      TYPE vbpa-parvw VALUE 'ZA'. "ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292

********Local Data declaration
  DATA: lv_society_logo TYPE char100,  "variable of society logo
        lv_logo_name    TYPE tdobname. " Name
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
  DATA(li_vbpa_tmp) = i_vbpa.
  DELETE li_vbpa_tmp WHERE parvw NE lc_za.
  DELETE li_vbpa_tmp WHERE vbeln NE fp_st_vbco3-vbeln.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
* Function module to get society logo name and text
  CALL FUNCTION 'ZQTC_GET_FORM_LOGO_NAME'
    EXPORTING
      im_doc_no                     = fp_st_vbco3-vbeln
      im_doc_type                   = lc_invoice
    IMPORTING
      ex_logo_name                  = lv_society_logo
*     Begin of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911344
*     ex_sold_to_name               = fp_v_society_text
*     End   of DEL:ERP-6862:WROY:14-Mar-2018:ED2K911344
    EXCEPTIONS
      non_society_customers         = 1
      non_society_materials         = 2
      invalid_document_number       = 3
      invalid_document_type         = 4
      material_group_not_maintained = 5
      OTHERS                        = 6.

  IF sy-subrc EQ 0.
    lv_logo_name = lv_society_logo.
  ENDIF. " IF sy-subrc EQ 0
*** BOC BY SAYANDAS
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
*  IF lv_society_logo IS INITIAL.
*    CLEAR fp_v_society_text.
*  ENDIF. " IF lv_society_logo IS INITIAL
  IF li_vbpa_tmp[] IS NOT INITIAL.
    SELECT addrnumber,
           name1,
           name2,
           name3,
           name4
       FROM adrc
       INTO TABLE @DATA(li_adrc_name)
       FOR ALL ENTRIES IN @li_vbpa_tmp
       WHERE addrnumber = @li_vbpa_tmp-adrnr.
    IF li_adrc_name[] IS NOT INITIAL.
      READ TABLE li_adrc_name INTO DATA(lst_adrc_name) INDEX 1.
      IF sy-subrc EQ 0.
        CONCATENATE lst_adrc_name-name1 lst_adrc_name-name2 lst_adrc_name-name3 lst_adrc_name-name4
         INTO fp_v_society_text SEPARATED BY space.
      ENDIF.
    ENDIF.
  ENDIF.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
*** EOC BY SAYANDAS
******To Get a BDS Graphic in BMP Format (Using a Cache)
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object         " GRAPHICS
      p_name         = lv_logo_name
      p_id           = lc_id             " BMAP
      p_btype        = lc_btype          " BMON
    RECEIVING
      p_bmp          = fp_v_society_logo " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRK_VALUE
*&---------------------------------------------------------------------*
* Subroutine to fetch billing document Header data
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3
*      <--FP_I_VBRK   Billing Document: Header Data
*----------------------------------------------------------------------*
FORM f_get_vbrk_value  USING    fp_st_vbco3 TYPE vbco3 "
                       CHANGING fp_st_vbrk  TYPE ty_vbrk
                                fp_i_tax_data TYPE tt_tax_data.
  .

* Local constant declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.
* Retrieve billing document data from VBRK table
  SELECT SINGLE
         vbeln " Billing Document
         fkart " Billing Type
         vbtyp " SD document category
         waerk " SD Document Currency
         vkorg " Sales Organization
         knumv " Number of the document condition
         fkdat " Billing date for billing index and printout
         zterm " Terms of Payment Key
         zlsch " Payment Method
         land1 " Country of Destination
         bukrs " Company Code
         netwr " Net Value in Document Currency
         erdat " Date on Which Record Was Created
         kunrg " Payer
         kunag " Sold-to party
         zuonr " Assignment number
         rplnr " Number of payment card plan type
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
         sfakn " Cancelled billing document number
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
    INTO fp_st_vbrk
    FROM vbrk  " Billing Document: Header Data
    WHERE vbeln EQ fp_st_vbco3-vbeln.
  IF sy-subrc EQ 0.
*Begin of change by SRBOSE on 08-Aug-2017 CR_408 #TR: ED2K907591
    SELECT document,
           doc_line_number,
           buyer_reg,
           seller_reg,     " Seller VAT Registration Number
           invoice_desc    " Invoice Description
      FROM /idt/d_tax_data " Tax Data
      INTO TABLE @fp_i_tax_data
      WHERE company_code = @fp_st_vbrk-bukrs
      AND   fiscal_year = @lc_gjahr
      AND   document_type = @lc_doc_type
      AND   document = @fp_st_vbrk-vbeln.
    IF sy-subrc EQ 0.
      DATA(li_tax_data) = fp_i_tax_data.
      SORT li_tax_data BY document doc_line_number.
      DELETE li_tax_data WHERE buyer_reg IS INITIAL.
      DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING document doc_line_number.
      DATA(lv_lines) = lines( li_tax_data ).
*      IF lv_lines = 1.
      LOOP AT li_tax_data INTO DATA(lst_tax_data).
        IF lv_lines = 1.
          st_header-buyer_reg = lst_tax_data-buyer_reg.
        ENDIF. " IF lv_lines = 1
        IF lst_tax_data-invoice_desc CS v_inv_desc
          AND v_invoice_desc IS INITIAL.
          v_invoice_desc = lst_tax_data-invoice_desc.
        ENDIF. " IF lst_tax_data-invoice_desc CS v_inv_desc
      ENDLOOP. " LOOP AT li_tax_data INTO DATA(lst_tax_data)
*      ENDIF. " IF lv_lines = 1
    ENDIF. " IF sy-subrc EQ 0
*END of change by MODUTTA on 08-Aug-2017 CR_408 #TR: ED2K907591
*   Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
*   Fetch Company Code Details
    SELECT SINGLE land1 "Country Key
*                 Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                  waers "Currency Key
*                 End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
      FROM t001 " Company Codes
*     Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
      INTO ( st_header-comp_code_country,
             v_local_curr )
*     End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
*     Begin of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
*     INTO st_header-comp_code_country
*     End   of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
     WHERE bukrs EQ fp_st_vbrk-bukrs.
    IF sy-subrc NE 0.
      CLEAR: st_header-comp_code_country.
*     Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
      CLEAR: v_local_curr.
*     End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
    ENDIF. " IF sy-subrc NE 0
*   End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBPA_VALUE
*&---------------------------------------------------------------------*
* Subroutine to Fetch all Sales document related to partner
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      <--FP_I_VBPA  text
*----------------------------------------------------------------------*
FORM f_get_vbpa_value  USING    fp_st_vbrk TYPE ty_vbrk
                       CHANGING fp_i_vbpa  TYPE tt_vbpa.
  CONSTANTS: lc_za TYPE parvw VALUE 'ZA'. " Partner Function

  IF i_vbap IS NOT INITIAL.
    READ TABLE i_vbap INTO DATA(lst_vbap) INDEX 1.
    IF sy-subrc EQ 0.
      DATA(lv_vbeln) = lst_vbap-vbeln.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_vbap IS NOT INITIAL

* Retrieve data from VBPA table
  SELECT vbeln   " Sales and Distribution Document Number
         posnr   " Item number of the SD document
         parvw   " Partner Function
         kunnr   " Customer Number
         adrnr   " Address
         country " Country Key
*        land1 " Country Key
    INTO TABLE fp_i_vbpa
    FROM vbpa INNER JOIN adrc " Sales Document: Partner
      ON vbpa~adrnr EQ adrc~addrnumber
    WHERE ( vbeln EQ fp_st_vbrk-vbeln
          OR  vbeln EQ lv_vbeln ).
  IF sy-subrc EQ 0.
    SORT fp_i_vbpa BY vbeln posnr parvw.

*   Begin of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
    DATA(li_vbpa) = fp_i_vbpa[].
    SORT li_vbpa BY parvw kunnr.
    DELETE li_vbpa WHERE parvw NE lc_za.
    DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING parvw kunnr.
*   End   of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
    SELECT society,
           society_name    " Society Name
     FROM zqtc_jgc_society " I0222: Journal Group Code to Society Mapping
     INTO TABLE @i_society
*    Begin of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
     FOR ALL ENTRIES IN @li_vbpa
     WHERE society EQ @li_vbpa-kunnr.
*    End   of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
*    Begin of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
*    WHERE society = @v_kunnr.
*    End   of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
    IF sy-subrc EQ 0.
      SORT i_society BY society.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRP_VALUE
*&---------------------------------------------------------------------*
* Fetch Item data for billing document
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      <--FP_I_VBRP  text
*      <--FP_V_SALES_OFC  text
*----------------------------------------------------------------------*
FORM f_get_vbrp_value  USING    fp_st_vbrk     TYPE ty_vbrk
                       CHANGING fp_i_vbrp      TYPE tt_vbrp.

* Fetch Item data from VBRP table.
  SELECT  vbeln " Billing Document
          posnr " Billing item
*Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
          uepos
*End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
          fkimg " Actual Invoiced Quantity
*Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
          meins " Base Unit of Measure
*End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
          vgbel
          vgpos
          aubel      " Sales Document
          aupos      " Sales Document Item
          matnr      " Material Number
          arktx      " Short text for sales order item
          pstyv      " Sales document item category
          werks      " Plant    "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
          vkgrp      " Sales Group "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
          vkbur      " Sales Office
          kzwi1      " Subtotal 1 from pricing procedure for condition
          kzwi2      " Subtotal 2 from pricing procedure for condition
          kzwi3      " Subtotal 3 from pricing procedure for condition
          kzwi4      " Subtotal 4 from pricing procedure for condition
          kzwi5      " Subtotal 5 from pricing procedure for condition
          kzwi6      " Subtotal 6 from pricing procedure for condition
          kvgr1      " Customer group 1er group 1
          aland      " Departure country (country from which the goods are sent)
          lland_auft " Country of destination of sales order
*         Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
          kowrr " Statistical values
          fareg " Rule in billing plan/invoice plan
*         Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
           kdkg2 " Customer condition group 2
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
*         Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
          netwr " Net value of the billing item in document currency
*         End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
          mvgr5 "CR#6376 - SKKAIRAMKO - 1/24/2019
          vkorg_auft " Sales Org    "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
    INTO TABLE fp_i_vbrp
    FROM vbrp " Billing Document: Item Data
    WHERE vbeln EQ fp_st_vbrk-vbeln.
  IF  sy-subrc EQ 0.
*   SORT fp_i_vbrp BY vbeln posnr.
    SORT fp_i_vbrp BY aubel aupos.


**** BOC BY SRBOSE on 19-Jan-2018 #CR_XXX #TR: ED2K910373
    DATA(li_vbrp) = fp_i_vbrp[].
*   SORT li_vbrp BY aubel aupos.
    SORT li_vbrp BY vgbel vgpos.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING vgbel vgpos.
    SELECT vbeln,
           posnr,
           mvgr5, " Material group 5
* Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
           zzcovryr,  "Cover Year
           zzcovrmt  "Cover Month
* End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
      FROM vbap  " Sales Document: Item Data
      INTO TABLE @i_vbap
      FOR ALL ENTRIES IN @li_vbrp
      WHERE vbeln = @li_vbrp-vgbel
      AND posnr = @li_vbrp-vgpos.
    IF sy-subrc IS INITIAL.
*     Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
      SORT i_vbap BY vbeln posnr.
*     End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
*     Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*     DATA(li_vbap) = i_vbap[].
*     SORT li_vbap BY vbeln mvgr5.
*
*     READ TABLE li_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = fp_st_vbrk-vbeln
*                                             BINARY SEARCH.
*     IF sy-subrc IS INITIAL.
*       LOOP AT li_vbap INTO DATA(lst_vbap).
*         IF lst_vbap-vbeln = lst_vbrp-vgbel
*          AND lst_vbap-mvgr5 IN r_mvgr5_in.
*           v_society = abap_true.
*         ENDIF. " IF lst_vbap-vbeln = lst_vbrp-vgbel
*       ENDLOOP. " LOOP AT li_vbap INTO DATA(lst_vbap)
*     ENDIF. " IF sy-subrc IS INITIAL
*     End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
    ENDIF. " IF sy-subrc IS INITIAL
**** EOC BY SRBOSE on 19-Jan-2018 #CR_XXX #TR: ED2K910373
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA_VALUE
*&---------------------------------------------------------------------*
* Retrieve values from MARA table
*----------------------------------------------------------------------*
*      -->FP_I_VBRP  text
*      <--FP_I_MARA  text
*----------------------------------------------------------------------*
FORM f_get_mara_value  USING    fp_i_vbrp TYPE tt_vbrp
                                fp_i_vbfa TYPE tt_vbfa
                                fp_i_jksesched TYPE tt_jksesched
                       CHANGING fp_i_mara TYPE tt_mara
                                fp_i_mara_lvl2 TYPE tt_mara
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                fp_i_makt TYPE tt_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                fp_v_subscription_typ TYPE char100 " V_subscription_typ of type CHAR100
                                .

* Data declaration:
  DATA : lv_name            TYPE thead-tdname, " Name
         lv_flag_di         TYPE char1,        " Flag_di of type CHAR1
         lv_flag_ph         TYPE char1,        " Flag_ph of type CHAR1
*** BOC BY SAYANDAS on 05-JAN-2018 for CR-XXX
         lv_name_issn       TYPE thead-tdname, " Name
         lv_vol_des         TYPE char255,      " Vol_des of type CHAR255
         lv_issue_des       TYPE char255,      " Issue_des of type CHAR255
         lst_jptidcdassign1 TYPE ty_jptidcdassign,
         lv_identcode_zjcd  TYPE char20,       " Identcode of type CHAR20
         lst_iss_vol2       TYPE ty_iss_vol2,
         lv_line            TYPE i.            " Row Index of Internal Tables

*** EOC BY SAYANDAS on 05-JAN-2018 for CR-XXX

* Constant Declaration
  CONSTANTS : lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
              lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
              lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
              lc_hier2      TYPE ismhierarchlvl VALUE '2', " Hierarchy Level (Media Product Family, Product or Issue)
              lc_hier3      TYPE ismhierarchlvl VALUE '3'. " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX

* Fetch old material number from MARA table
  IF fp_i_vbrp[] IS NOT INITIAL.
    DATA(li_vbrp) = fp_i_vbrp[].
    SORT  li_vbrp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING matnr.

*** BOC BY MODUTTA on 31-JAN-2018 for CR-XXX
    DATA(li_vbfa_temp) = fp_i_vbfa[].

*** Fetch Data from VEDA
    SELECT vbeln,
           vposn,
           vlaufk,
           vbegdat, " Contract start date
           venddat  " Contract End Date "ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
      FROM veda    " Contract Data
      INTO TABLE @i_veda
      FOR ALL ENTRIES IN @li_vbfa_temp
      WHERE vbeln = @li_vbfa_temp-vbelv.
    IF sy-subrc = 0.
      SORT i_veda BY vbeln vposn.

* Begin of Change DEL:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
* Begin of Change INC0203148:23/07/2018:RBTIRUMALA:ED1K908023
*      DELETE i_veda WHERE vposn = '0'.
* End of Change INC0203148:23/07/2018:RBTIRUMALA:ED1K908023
* End of Change DEL:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026

      READ TABLE i_veda INTO DATA(lst_veda) INDEX 1.
      DATA(lv_year1) = lst_veda-vbegdat+0(4).
      v_start_year = lv_year1.
      DATA(li_veda_tmp) = i_veda[].
      SORT li_veda_tmp BY vlaufk.
      DELETE ADJACENT DUPLICATES FROM li_veda_tmp COMPARING vlaufk.
      SELECT spras  " Language Key
             vlaufk " Validity period category of contract
             bezei  " Description
        FROM tvlzt  " Validity Period Category: Texts
        INTO TABLE i_tvlzt
        FOR ALL ENTRIES IN li_veda_tmp
        WHERE spras = st_header-language
          AND vlaufk = li_veda_tmp-vlaufk.
      IF sy-subrc EQ 0.
        CLEAR li_veda_tmp[].
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc = 0
*** EOC BY MODUTTA on 31-JAN-2018 for CR-XXX


*  Fetch media values from MARA
    SELECT matnr " Material Number
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
           mtart " Material Type
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
           volum " Volume
*BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
           ismhierarchlevl
*EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
           ismmediatype " Media Type
           ismnrinyear  " Issue Number (in Year Number)
           ismcopynr    " Copy Number of Media Issue  (++SRBOSE CR_618 TR: ED2K908908)
           ismyearnr    " Media issue year number
      FROM mara         " General Material Data
      INTO TABLE fp_i_mara
      FOR ALL ENTRIES IN li_vbrp
      WHERE matnr EQ li_vbrp-matnr.
    IF sy-subrc EQ 0.
      SORT fp_i_mara BY matnr.
      LOOP AT fp_i_mara INTO DATA(lst_mara).
        IF lst_mara-ismmediatype EQ 'DI'.
          lv_flag_di = abap_true.
        ELSEIF lst_mara-ismmediatype EQ 'PH'.
          lv_flag_ph = abap_true.
        ENDIF. " IF lst_mara-ismmediatype EQ 'DI'
      ENDLOOP. " LOOP AT fp_i_mara INTO DATA(lst_mara)

      CLEAR lv_name.
      IF lv_flag_di EQ abap_true
        AND lv_flag_ph EQ abap_true.
        lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING fp_v_subscription_typ.

      ELSEIF lv_flag_di EQ abap_true
        AND lv_flag_ph EQ abap_false.
        lv_name = lc_digt_subsc.
*       Subroutine to get subscription type text (Digital subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING fp_v_subscription_typ.

      ELSEIF lv_flag_di EQ abap_false
        AND lv_flag_ph EQ abap_true.
        lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING fp_v_subscription_typ.

      ENDIF. " IF lv_flag_di EQ abap_true

*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
*     Material Descriptions
      SELECT matnr "Material Number
             spras "Language Key
             maktx "Material Description (Short Text)
        FROM makt  " Material Descriptions
        INTO TABLE fp_i_makt
        FOR ALL ENTRIES IN fp_i_mara
        WHERE matnr EQ fp_i_mara-matnr.
      IF sy-subrc EQ 0.
        SORT fp_i_makt BY matnr spras.
      ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
    ENDIF. " IF sy-subrc EQ 0

**        BOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
    IF fp_i_jksesched[] IS NOT INITIAL.
      SORT fp_i_jksesched BY vbeln posnr issue.
      SELECT matnr,
             ismpubldate,
             ismcopynr,  " Copy Number of Media Issue
             ismnrinyear " Issue Number (in Year Number)
        FROM mara        " General Material Data
        INTO TABLE @DATA(li_med_issue)
         FOR ALL ENTRIES IN @fp_i_jksesched
       WHERE matnr EQ @fp_i_jksesched-issue.
      IF sy-subrc EQ 0.
        SORT li_med_issue BY matnr.

        LOOP AT fp_i_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>).
          AT NEW posnr.
*           Material
            lst_iss_vol2-matnr = <lst_jksesched>-product.
* Begin of Change ADD:INC0216814:04/12/2018:NPOLINA:ED1K909026
*           Item
            lst_iss_vol2-posnr = <lst_jksesched>-posnr.
* End of Change ADD:INC0216814:04/12/2018:NPOLINA:ED1K909026
            READ TABLE li_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>)
                 WITH KEY matnr = <lst_jksesched>-issue
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
*             Start Volume
              lst_iss_vol2-stvol = <lst_med_issue>-ismcopynr.

*             Start Issue
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = <lst_med_issue>-ismnrinyear
                IMPORTING
                  output = lst_iss_vol2-stiss.
            ENDIF. " IF sy-subrc EQ 0
          ENDAT.
*         Count Number of Issue
          lst_iss_vol2-noi = lst_iss_vol2-noi + 1.
          AT END OF posnr.
            APPEND lst_iss_vol2 TO i_iss_vol2.
            CLEAR: lst_iss_vol2.
          ENDAT.
        ENDLOOP. " LOOP AT fp_i_jksesched ASSIGNING FIELD-SYMBOL(<lst_jksesched>)
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF fp_i_jksesched[] IS NOT INITIAL
**       EOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
  ENDIF. " IF fp_i_vbrp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBFA
*&---------------------------------------------------------------------*
*  Subroutine for Retrieve Sales Document Flow
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  Billing Document: Header Data
*      -->FP_I_VBRP   Billing Document: Item Data
*      <--FP_I_VBFA   Sales Document Flow
*----------------------------------------------------------------------*
FORM f_get_vbfa  USING    fp_st_vbrk TYPE ty_vbrk
                          fp_i_vbrp  TYPE tt_vbrp
                 CHANGING fp_i_vbfa  TYPE tt_vbfa
                          fp_i_jksesched  TYPE tt_jksesched.

* Fetch Sales Document Flow from VBFA table
  SELECT vbelv " Preceding sales and distribution document
         posnv " Preceding item of an SD document
         vbeln " Subsequent sales and distribution document
         posnn " Subsequent item of an SD document
    FROM vbfa  " Sales Document Flow
    INTO TABLE fp_i_vbfa
    FOR ALL ENTRIES IN fp_i_vbrp
    WHERE vbeln EQ fp_st_vbrk-vbeln
      AND posnn EQ fp_i_vbrp-posnr.
  IF sy-subrc EQ 0.
    DATA(li_vbfa) = fp_i_vbfa[].
    SORT li_vbfa BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_vbfa COMPARING vbeln.
*Begin of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*    Fetch from VBAK Table
    SELECT bstzd, " Purchase order number supplement
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
           auart, " Sales Document Type
           kunnr,
           kvgr1  " Customer group 1     (++SRBOSE #CR_XXX)
*      INTO TABLE @DATA(li_bstzd)
      INTO TABLE @DATA(li_vbak)
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
      FROM vbak " Sales Document: Header Data
      FOR ALL ENTRIES IN @li_vbfa
      WHERE vbeln = @li_vbfa-vbelv.
*      AND   bstzd <> @space.
    IF sy-subrc EQ 0.
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
      READ TABLE li_vbak INTO DATA(lst_vbak) INDEX 1.
      IF sy-subrc EQ 0.
        v_auart = lst_vbak-auart.
        v_auart_tmp = lst_vbak-auart. "ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*  BOC by SRBOSE on 19-Jan-2018 #TR: ED2K910373
        v_psb   = lst_vbak-kvgr1.
        v_kunnr = lst_vbak-kunnr.
*  BOC by SRBOSE on 19-Jan-2018 #TR: ED2K910373
*       Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*       IF lst_vbak-bstzd IN r_bstzd_email.
*         v_bstzd_flag = abap_true.
*       ELSEIF lst_vbak-bstzd IN r_bstzd_no_email.
*         CLEAR v_bstzd_flag.
*       ENDIF. " IF lst_vbak-bstzd <> space
*       End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
      ENDIF. " IF sy-subrc EQ 0
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
    ENDIF. " IF sy-subrc EQ 0
*End of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*Begin of change by NPALLA on 07-May-2019 INC0242103 #TR:ED1K910085
** BOC MMUKHERJEE CR#XXX
*    SELECT  vbeln    " Sales and Distribution Document Number
*            posnr    " Item number of the SD document
*            issue    " Media Issue
*            product  " Media Product
*            sequence " IS-M: Sequence
*      FROM jksesched " IS-M: Media Schedule Lines
*      INTO TABLE fp_i_jksesched
*      FOR ALL ENTRIES IN fp_i_vbfa
*      WHERE vbeln = fp_i_vbfa-vbelv
*        AND posnr = fp_i_vbfa-posnv.
*    IF sy-subrc EQ 0.
*      SORT fp_i_jksesched BY vbeln posnr.
*    ENDIF. " IF sy-subrc EQ 0
** EOC MMUKHERJEE CR#XXX
    SELECT  vbeln    " Sales and Distribution Document Number
            posnr    " Item number of the SD document
            issue    " Media Issue
            product  " Media Product
            sequence " IS-M: Sequence
      FROM jksesched " IS-M: Media Schedule Lines
      INTO TABLE fp_i_jksesched
      FOR ALL ENTRIES IN fp_i_vbrp
      WHERE vbeln = fp_i_vbrp-vgbel
        AND posnr = fp_i_vbrp-vgpos.
    IF sy-subrc EQ 0.
      SORT fp_i_jksesched BY vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
*End of change by NPALLA on 07-May-2019 INC0242103 #TR:ED1K910085

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBKD
*&---------------------------------------------------------------------*
* Subroutine to fetch Purchase Order Number
*----------------------------------------------------------------------*
*      -->FP_I_VBFA  text
*      <--FP_I_VBKD  text
*----------------------------------------------------------------------*
FORM f_get_vbkd  USING    fp_i_vbfa TYPE tt_vbfa
                 CHANGING fp_i_vbkd TYPE tt_vbkd.

* Retrieve PO Number from VBKD table
  SELECT vbeln " Sales and Distribution Document Number
         posnr "
         fplnr " Billing plan number / invoicing plan number "ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
         bstkd " Customer purchase order number
         ihrez " Your Reference
*    * BOC: CR#6376 KJAGANA20181122  ED2K913919
         kdkg2 "Condition group2
*    * EOC: CR#6376 KJAGANA20181122  ED2K913919
    INTO TABLE fp_i_vbkd
    FROM vbkd  " Sales Document: Business Data
    FOR ALL ENTRIES IN fp_i_vbfa
    WHERE vbeln EQ fp_i_vbfa-vbelv
* Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909227
*     AND posnr EQ fp_i_vbfa-posnv.
      AND ( posnr EQ fp_i_vbfa-posnv
       OR   posnr EQ '000000' ).
* End   of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909227
  IF sy-subrc EQ 0.
    SORT fp_i_vbkd BY vbeln posnr.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KNA1
*&---------------------------------------------------------------------*
*  Retrieve customer VAT
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      <--FP_I_KNA1  text
*      <--FP_V_TRIG_ATTR  text
*----------------------------------------------------------------------*
FORM f_get_kna1  USING    fp_st_vbrk     TYPE ty_vbrk
                 CHANGING fp_st_kna1     TYPE ty_kna1.

* Retrieve Customer VAT from KNA1 table
  SELECT SINGLE kunnr " Customer Number
         spras        " Language Key
         stceg        " VAT Registration Number
*    * BOC: CR#6376 KJAGANA20181123  ED2K913919
         katr6        "Invoice type(Detail or Summary)
*    * EOC: CR#6376 KJAGANA20181123  ED2K913919
    FROM kna1         " General Data in Customer Master
    INTO fp_st_kna1
    WHERE kunnr EQ fp_st_vbrk-kunrg.
  IF sy-subrc EQ 0.
  ENDIF. " IF sy-subrc EQ 0
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
* •	BP language is

  SELECT SINGLE kunnr, " Customer Number
         spras,        " Language Key
         stceg,        " VAT Registration Number
         katr6        "Invoice type(Detail or Summary)
    FROM kna1         " General Data in Customer Master
    INTO @DATA(lstp_st_kna1)
    WHERE kunnr EQ @fp_st_vbrk-kunag.
  IF sy-subrc EQ 0.
  ENDIF. " IF sy-subrc EQ 0
  v_langu_f044      = lstp_st_kna1-spras.
* End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_INV_HEADER
*&---------------------------------------------------------------------*
*  Populate Header data
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      -->FP_I_VBPA  text
*      -->FP_I_VBRP  text
*      -->FP_I_VBFA  text
*      -->FP_I_VBKD  text
*      -->FP_I_KNA1  text
*      <--FP_ST_HEADER  text
*----------------------------------------------------------------------*
FORM f_populate_detail_inv_header  USING    fp_st_vbrk     TYPE ty_vbrk
                                            fp_i_vbpa      TYPE tt_vbpa
                                            fp_i_vbrp      TYPE tt_vbrp
                                            fp_i_vbfa      TYPE tt_vbfa
                                            fp_i_vbkd      TYPE tt_vbkd
                                            fp_st_kna1     TYPE ty_kna1
                                            fp_v_country_key TYPE land1                    " Country Key
                                   CHANGING fp_st_header   TYPE zstqtc_header_detail_f042. " Structure for Header detail of invoice form
* Data declaration
  DATA : li_vbrp       TYPE tt_vbrp, " IT for VBRP  " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
* Begin of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908908
*        lv_pay_term TYPE char30.  " Description of terms of payment
         lv_pay_term   TYPE char50, " Description of terms of payment
* End   of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908908
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
         lst_vbrk      TYPE vbrk, "Sales Document
         lst_vbak      TYPE vbak,
         lt_vbpa_ff    TYPE vbpa_tab,       " Frighet Forwarder
         lv_ff_flag(1) TYPE c,
         lv_multiple   TYPE c.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
* Constant Declaration
  CONSTANTS : lc_payer TYPE parvw VALUE 'RG', " Partner Function
              lc_bp    TYPE parvw VALUE 'RE'. " Partner Function


  DATA(li_vbpa) = fp_i_vbpa[].
  SORT li_vbpa BY vbeln parvw.

* Populate Header detail
  fp_st_header-invoice_number = fp_st_vbrk-vbeln. " Invoice Number
* Begin of DEL:WROY:ERP-7143:23-Mar-2018:ED2K911550
* fp_st_header-inv_date       = fp_st_vbrk-erdat. " Invoice Date
* End   of DEL:WROY:ERP-7143:23-Mar-2018:ED2K911550
* Begin of ADD:WROY:ERP-7143:23-Mar-2018:ED2K911550
  fp_st_header-inv_date       = fp_st_vbrk-fkdat. " Invoice Date
* End   of ADD:WROY:ERP-7143:23-Mar-2018:ED2K911550
  fp_st_header-comp_code      = fp_st_vbrk-bukrs. " Company code
  fp_st_header-bill_type      = fp_st_vbrk-fkart. " Billing Type
  fp_st_header-doc_currency   = fp_st_vbrk-waerk. " Document Currency
  fp_st_header-language       = fp_st_kna1-spras. " Language
  fp_st_header-cust_vat       = fp_st_kna1-stceg. " Customer VAT
  READ TABLE fp_i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = fp_st_vbrk-vbeln
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_vbak-vbeln = lst_vbrp-aubel.  "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
* Begin of Change: PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*    READ TABLE fp_i_vbfa INTO DATA(lst_vbfa) WITH KEY vbeln = fp_st_vbrk-vbeln
*                                                      posnv = lst_vbrp-posnr
*                                                      BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbfa-vbelv
*                                                        posnr = lst_vbfa-posnv
*                                               BINARY SEARCH.
    READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                      posnr = lst_vbrp-aupos
                                                   BINARY SEARCH.
* End of Change: PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*   Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909227
    IF sy-subrc NE 0.
      READ TABLE fp_i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbrp-aubel
                                                  posnr = '000000'
                                                  BINARY SEARCH.
    ENDIF. " IF sy-subrc NE 0
*   End   of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909227
    IF sy-subrc EQ 0.
      fp_st_header-po_number = lst_vbkd-bstkd. " Purchase Order Number
    ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                  parvw = lc_bp
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-bill_country     = lst_vbpa-land1. " Payer country key
    fp_st_header-bill_cust_number = lst_vbpa-kunnr. " Payer customer number
    fp_st_header-bill_addr_number = lst_vbpa-adrnr. " Payer address number
    v_kunnr_f044           = lst_vbpa-kunnr.
    v_adrnr_f044           = lst_vbpa-adrnr.
  ENDIF. " IF sy-subrc EQ 0

  fp_st_header-bill_trust = fp_v_country_key. " Payer country key

***BOC by MODUTTA on 22/01/2018 for CR_TBD
  DATA(li_vbpa_temp) = fp_i_vbpa[].
  DELETE li_vbpa_temp WHERE parvw NE c_we.
***BOC by on 06/06/2019 for INC0242665 - ED1K910264
* Retain only entries relevant to the Invoice.
  DELETE li_vbpa_temp WHERE vbeln NE fp_st_vbrk-vbeln.
***EOC by on 06/06/2019 for INC0242665 - ED1K910264
  DELETE ADJACENT DUPLICATES FROM li_vbpa_temp COMPARING adrnr.
  DATA(lv_count_vbpa) = lines( li_vbpa_temp ).
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
  lst_vbrk-vbeln = fp_st_vbrk-vbeln.
  CALL FUNCTION 'ZQTC_FF_DETERMINE'
    EXPORTING
      im_vbak          = lst_vbak
      im_vbrk          = lst_vbrk
*     IM_VBAP          =
*     im_flag          = space
    IMPORTING
      ex_ff_flag       = lv_ff_flag
    CHANGING
      ch_vbpa          = lt_vbpa_ff
      ch_multiple_ship = lv_multiple.
  IF lt_vbpa_ff[] IS NOT INITIAL.
    DATA(li_vbpa_temp_ff) = lt_vbpa_ff[].
    DELETE li_vbpa_temp_ff WHERE parvw NE c_sp.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_temp_ff COMPARING adrnr.
    DATA(lv_count_vbpa_ff) = lines( li_vbpa_temp_ff ).
    IF  lv_count_vbpa_ff > 1.
      fp_st_header-multiple_shipto = abap_true.
    ELSE.
      CLEAR fp_st_header-multiple_shipto.
      READ TABLE li_vbpa_temp_ff INTO DATA(lst_fright_forwarder)  INDEX 1.
      fp_st_header-ship_country     = lst_fright_forwarder-land1. " Contact country key
      fp_st_header-ship_cust_number = lst_fright_forwarder-lifnr. " Contact customer number
      fp_st_header-ship_addr_number = lst_fright_forwarder-adrnr. " Contact address number
    ENDIF. " IF lv_count_vbpa > 1
  ENDIF.
  IF lv_multiple IS NOT INITIAL.
    fp_st_header-multiple_shipto = abap_true.
  ENDIF.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
  IF  ( lv_count_vbpa > 1
         AND fp_st_header-multiple_shipto IS INITIAL ). "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
    fp_st_header-multiple_shipto = abap_true.
  ENDIF. " IF lv_count_vbpa > 1
***EOC by MODUTTA on 22/01/2018 for CR_TBD
  IF  ( fp_st_header-multiple_shipto IS INITIAL "Added by MODUTTA on 18/03/2018
                                 AND fp_st_header-ship_addr_number IS INITIAL ). "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K918761
    READ TABLE li_vbpa INTO DATA(lst_vbpa1) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                     parvw = c_we
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_st_header-ship_country     = lst_vbpa1-land1. " Contact country key
      fp_st_header-ship_cust_number = lst_vbpa1-kunnr. " Contact customer number
      fp_st_header-ship_addr_number = lst_vbpa1-adrnr. " Contact address number

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_st_header-multiple_shipto IS INITIAL

  READ TABLE li_vbpa INTO DATA(lst_vbpa2) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                    parvw = lc_payer
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-acc_number = lst_vbpa2-kunnr. " Account Number
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
    fp_st_header-payee_country = lst_vbpa2-land1. " Payee Country
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
  ENDIF. " IF sy-subrc EQ 0

* Fetch payment term description
* BOC BY SRBOSE #CR_XXX ON 19-Jan-2018: TRED2K910373
* Begin of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908908
  SELECT SINGLE vtext " Description of terms of payment
       INTO lv_pay_term
   FROM tvzbt         " Customers: Terms of Payment Texts
*  SELECT SINGLE text1 " Own Explanation of Term of Payment
*       INTO lv_pay_term
*   FROM t052u         " Own Explanations for Terms of Payment
* End   of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908908
* EOC BY SRBOSE #CR_XXX ON 19-Jan-2018: TRED2K910373
   WHERE spras EQ st_header-language
     AND zterm EQ fp_st_vbrk-zterm.
  IF sy-subrc EQ 0.
    fp_st_header-terms  = lv_pay_term. " Payment terms
  ENDIF. " IF sy-subrc EQ 0

* Begin of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
*  IF fp_st_vbrk-fkart IN r_crd.  " (--) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
  IF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
    CLEAR fp_st_header-terms.
    fp_st_header-credit_flag = abap_true.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* End of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208

* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  IF fp_st_vbrk-vbtyp IN r_cinv. " Cancelled invoiced display same as credit memo
    CLEAR fp_st_header-terms.
    fp_st_header-credit_flag = abap_true.
  ENDIF.

  IF fp_st_vbrk-vbtyp IN r_cinv OR fp_st_vbrk-vbtyp IN r_ccrd.  " Cancelled invoice and Cancelled credit memo
    " Original document number need to add with enhancing the structure header for both credit memo cancellation & invoice cancellation
  ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

  v_credit_memo = fp_st_vbrk-vbtyp. "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_VALUES
*&---------------------------------------------------------------------*
*  Retrieve constant values from table
*----------------------------------------------------------------------*
*      <--FP_V_CSS  text
*      <--FP_V_NON_EAL  text
*      <--FP_R_INV  text
*      <--FP_R_CRD  text
*      <--FP_R_DBT  text
*----------------------------------------------------------------------*
FORM f_get_constant_values  CHANGING fp_r_inv           TYPE tt_billtype " Billing Type
                                     fp_r_crd           TYPE tt_billtype " Billing Type
                                     fp_r_dbt           TYPE tt_billtype " Billing Type
                                     fp_v_outputyp_css  TYPE sna_kschl   " Message type
                                     fp_v_outputyp_tbt  TYPE sna_kschl   " Message type
                                     fp_v_outputyp_soc  TYPE sna_kschl   " Message type
                                     fp_r_country       TYPE tt_country  " Country
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
                                     fp_i_tax_id        TYPE tt_tax_id           " Tax IDs
                                     fp_r_mtart_med_issue TYPE fip_t_mtart_range " Material Types: Media Issues
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
                                     fp_v_country_key   TYPE land1 " Country Key
                                     fp_r_aust_text     TYPE tt_aust_text   " ERP-7462:SGUDA:14-SEP-2018:ED2K913350
                                     fp_r_sales_org_text   TYPE tt_sales_org_text   " ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                                     fp_r_cinv          TYPE tt_billtype " canceled invoice
                                     fp_r_ccrd          TYPE tt_billtype. " Canceled credit memo
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

* Constant Declaration
  CONSTANTS : lc_bill_type_inv      TYPE rvari_vnam VALUE 'BILL_TYPE_INV', " ABAP: Name of Variant Variable
              lc_bill_type_zcr      TYPE rvari_vnam VALUE 'BILL_TYPE_ZCR', " ABAP: Name of Variant Variable
              lc_bill_type_zdr      TYPE rvari_vnam VALUE 'BILL_TYPE_ZDR', " ABAP: Name of Variant Variable
              lc_css_type           TYPE rvari_vnam VALUE 'CSS_TYPE',      " CSS output type
              lc_soc_type           TYPE rvari_vnam VALUE 'SOCIETY',       " Society output type
              lc_tbt_type           TYPE rvari_vnam VALUE 'TBT',           " TBT output type
              lc_country            TYPE rvari_vnam VALUE 'COUNTRY',       " Country Code
              lc_country_title      TYPE rvari_vnam VALUE 'COUNTRY_TITLE', " Country name
              lc_devid              TYPE zdevid VALUE 'F042',              " Development ID
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
              lc_tax_id             TYPE rvari_vnam VALUE 'TAX_ID',          " TAX IDs
              lc_mtart_med_iss      TYPE rvari_vnam VALUE 'MTART_MED_ISSUE', " Material Type: Media Issue
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
              lc_country_uk         TYPE rvari_vnam VALUE 'COUNTRY_UK',    " Country Code ++ srbose
              lc_faz                TYPE rvari_vnam VALUE 'BILL_TYPE_FAZ', " ABAP: Name of Variant Variable
              lc_vkorg              TYPE rvari_vnam VALUE 'VKORG',         " ABAP: Name of Variant Variable
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
              lc_inv_desc           TYPE rvari_vnam VALUE 'INVOICE_DESC', " ABAP: Name of Variant Variable

* ***BOC by SRBOSE for CR#666 on 18/10/2017
              lc_sub_typ_di         TYPE rvari_vnam VALUE 'SUB_TYPE_DI', " ABAP: Name of Variant Variable
              lc_sub_typ_ph         TYPE rvari_vnam VALUE 'SUB_TYPE_PH', " ABAP: Name of Variant Variable
              lc_sub_typ_mm         TYPE rvari_vnam VALUE 'SUB_TYPE_MM', " ABAP: Name of Variant Variable
              lc_sub_typ_se         TYPE rvari_vnam VALUE 'SUB_TYPE_SE', " ABAP: Name of Variant Variable
* ***EOC by SRBOSE for CR#666 on 18/10/2017
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
              lc_idcodetype_1       TYPE rvari_vnam VALUE 'IDCODETYPE_1', " ABAP: Name of Variant Variable
              lc_idcodetype_2       TYPE rvari_vnam VALUE 'IDCODETYPE_2', " ABAP: Name of Variant Variable
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
* BOC by SRBOSE on 19-JAN-2018 #TR: ED2K910373 for CR_XXX
              lc_kvgr1              TYPE rvari_vnam VALUE 'KVGR1', " ABAP: Name of Variant Variable
* EOC by SRBOSE on 19-JAN-2018 #TR: ED2K910373 for CR_XXX
*             Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*             lc_mvgr5_in       TYPE rvari_vnam VALUE 'MVGR5_INDIRECT', " ABAP: Name of Variant Variable
*             End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
              lc_mvgr5_ma           TYPE rvari_vnam VALUE 'MVGR5_MANAGED', " ABAP: Name of Variant Variable
              lc_mvgr5_scc          TYPE rvari_vnam VALUE 'MVGR5_SCC_IN',  " ABAP: Name of Variant Variable
              lc_mvgr5_scm          TYPE rvari_vnam VALUE 'MVGR5_SCM_DI',  " ABAP: Name of Variant Variable
*             Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
              lc_sanctioned_c       TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*             End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
*             Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*             lc_bstzd_email    TYPE rvari_vnam VALUE 'BSTZD_EMAIL',
*             lc_bstzd_no_email TYPE rvari_vnam VALUE 'BSTZD_NO_EMAIL'.
*             End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*       Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
              lc_aust_text          TYPE rvari_vnam VALUE 'AUSTRALIA_PLANT', " ABAP: Name of Variant Variable
              lc_sales_org_text     TYPE rvari_vnam VALUE 'SALES_ORG', " ABAP: Name of Variant Variable
*       End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
              lc_mat_grp5           TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
*   Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
              lc_digital_product    TYPE rvari_vnam VALUE 'DIGITAL_PRODUCT',
              lc_print_product      TYPE rvari_vnam VALUE 'PRINT_PRODUCT',
*   End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
              lc_payee_country      TYPE rvari_vnam VALUE 'PAYEE_COUNTRY',
              lc_vkorg_3310         TYPE rvari_vnam VALUE 'VKORG_3310',
              lc_vkorg_5501         TYPE rvari_vnam VALUE 'VKORG_5501',
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*              lc_billing_type_zf2 TYPE rvari_vnam VALUE 'BILLING_TYPE_ZF2',
*              lc_billing_type_zcr TYPE rvari_vnam VALUE 'BILLING_TYPE_ZCR',
*              lc_shipping_country TYPE rvari_vnam VALUE 'SHIP_CUST_LAND1',
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*** BOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
              lc_bill_doc_type      TYPE rvari_vnam VALUE 'BILLING_DOC_TYPE',
*** EOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
              lc_bill_doc_type_zibp TYPE rvari_vnam VALUE 'BILL_TYPE_ZIBP',
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
* Begin of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
              lc_gst_no             TYPE rvari_vnam VALUE 'GST_NO',
* End of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
              lc_bill_doc_type_curr TYPE rvari_vnam VALUE 'BILL_DOC_TYPE',
              lc_currency_country   TYPE rvari_vnam VALUE 'CURRENCY_COUNTRY',
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
*- Begin of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
              lc_document_type      TYPE rvari_vnam VALUE 'DOCUMENT_TYPE',
              lc_document_catg      TYPE rvari_vnam VALUE 'DOCUMENT_CATG',
              lc_material_group     TYPE rvari_vnam VALUE 'MATERIAL_GROUP',
*- End of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*-  Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
              lc_vkorg_dd           TYPE rvari_vnam VALUE 'VKORG_DD',
              lc_zlsch_dd           TYPE rvari_vnam VALUE 'ZLSCH_DD',
              lc_kvgr1_dd           TYPE rvari_vnam VALUE 'KVGR1_DD',
              lc_frm_dd             TYPE rvari_vnam VALUE 'FRM_DD',
*-  End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*- Begin of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
              lc_doc_type           TYPE rvari_vnam VALUE 'DOC_TYPE',
              lc_pay_mth            TYPE rvari_vnam VALUE 'PAY_MATHOD',
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
              lc_bill_type_zs1      TYPE rvari_vnam VALUE 'BILL_TYPE_ZS1',
              lc_bill_type_zs2      TYPE rvari_vnam VALUE 'BILL_TYPE_ZS2'.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *


*- End of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
  DATA: lst_country            TYPE ty_country,  " WA for country
        lst_inv                TYPE ty_billtype, " WA for invoice
        lst_crd                TYPE ty_billtype, " WA for credit memo
        lst_dbt                TYPE ty_billtype, " WA for debit memo
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
        lst_idcodetype         TYPE rjksd_idcodetype_range,
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
        lst_bill_doc_type      LIKE LINE OF r_bill_doc_type, " CR#7431&7189 KKRAVURI20181120  ED2K913896
        lst_bill_doc_type_zibp LIKE LINE OF r_bill_doc_type_zibp. "ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207

* Fetch values from constant table
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/...)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @DATA(li_constant)
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @lc_devid
      AND activate EQ @abap_true.

  IF sy-subrc EQ 0.

    SORT li_constant BY devid param1.

*   Loop through constant table to retrieve constant values
    LOOP AT li_constant INTO DATA(lst_constant).
      IF lst_constant-param1 EQ  lc_css_type.
        fp_v_outputyp_css = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_css_type
      IF lst_constant-param1 EQ  lc_soc_type.
        fp_v_outputyp_soc = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_soc_type
      IF lst_constant-param1 EQ  lc_tbt_type.
        fp_v_outputyp_tbt = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_tbt_type
      IF lst_constant-param1 EQ lc_bill_type_inv.
        lst_inv-sign = lst_constant-sign.
        lst_inv-opti = lst_constant-opti.
        lst_inv-low  = lst_constant-low.
        APPEND lst_inv TO fp_r_inv.
        CLEAR lst_inv.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_inv
      IF lst_constant-param1 EQ lc_bill_type_zcr.
        lst_crd-sign = lst_constant-sign.
        lst_crd-opti = lst_constant-opti.
        lst_crd-low  = lst_constant-low.
        APPEND lst_crd TO fp_r_crd.
        CLEAR lst_crd.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_zcr
      IF lst_constant-param1 EQ lc_bill_type_zdr.
        lst_dbt-sign = lst_constant-sign.
        lst_dbt-opti = lst_constant-opti.
        lst_dbt-low  = lst_constant-low.
        APPEND lst_dbt TO fp_r_dbt.
        CLEAR lst_dbt.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_zdr
      IF lst_constant-param1 EQ lc_country.
        fp_v_country_key = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_country
      IF lst_constant-param1 EQ lc_country_title.
        lst_country-sign  = lst_constant-sign.
        lst_country-opti  = lst_constant-opti.
        lst_country-low   = lst_constant-low.
        APPEND lst_country TO fp_r_country.
        CLEAR lst_country.
      ENDIF. " IF lst_constant-param1 EQ lc_country_title
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
      IF lst_constant-param1 EQ lc_faz.
        v_faz = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_faz
      IF lst_constant-param1 EQ lc_vkorg.
        v_vkorg = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_vkorg
      IF lst_constant-param1 EQ lc_country_uk.
        v_country_uk = lst_constant-low+0(3).
      ENDIF. " IF lst_constant-param1 EQ lc_country_uk
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
      IF lst_constant-param1 EQ lc_tax_id. " TAX IDs
        APPEND INITIAL LINE TO fp_i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>).
        <lst_tax_id>-land1 = lst_constant-param2.
        <lst_tax_id>-stceg = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_tax_id
      IF lst_constant-param1 EQ lc_mtart_med_iss. " Material Types: Media Issues
        APPEND INITIAL LINE TO fp_r_mtart_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
        <lst_med_issue>-sign   = lst_constant-sign.
        <lst_med_issue>-option = lst_constant-opti.
        <lst_med_issue>-low    = lst_constant-low.
        <lst_med_issue>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mtart_med_iss
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
      IF lst_constant-param1 EQ lc_inv_desc.
        v_inv_desc = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_inv_desc
***     BOC by SRBOSE on 18/10/2017 for CR# 666
      IF lst_constant-param1 EQ lc_sub_typ_di.
        v_sub_type_di = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_di
      IF lst_constant-param1 EQ lc_sub_typ_ph.
        v_sub_type_ph = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_ph
      IF lst_constant-param1 EQ lc_sub_typ_mm.
        v_sub_type_mm = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_mm
      IF lst_constant-param1 EQ lc_sub_typ_se.
        v_sub_type_se = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_se
***     EOC by SRBOSE on 18/10/2017 for CR# 666
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
      IF lst_constant-param1 EQ lc_idcodetype_1.
        v_idcodetype_1 = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_idcodetype_1
      IF lst_constant-param1 EQ lc_idcodetype_2.
        v_idcodetype_2 = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_idcodetype_2
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
      IF lst_constant-param1 EQ lc_kvgr1.
        v_kvgr1 = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_kvgr1
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
* BOC by MODUTTA on 31-JAN-2018 for CR_XXX
      IF lst_constant-param1 EQ lc_mvgr5_ma.
        APPEND INITIAL LINE TO r_mvgr5_ma ASSIGNING FIELD-SYMBOL(<lst_mvgr5_ma>).
        <lst_mvgr5_ma>-sign   = lst_constant-sign.
        <lst_mvgr5_ma>-opti   = lst_constant-opti.
        <lst_mvgr5_ma>-low    = lst_constant-low.
        <lst_mvgr5_ma>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_ma
*     Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*     IF lst_constant-param1 EQ lc_mvgr5_in.
*       APPEND INITIAL LINE TO r_mvgr5_in ASSIGNING FIELD-SYMBOL(<lst_mvgr5_in>).
*       <lst_mvgr5_in>-sign   = lst_constant-sign.
*       <lst_mvgr5_in>-opti   = lst_constant-opti.
*       <lst_mvgr5_in>-low    = lst_constant-low.
*       <lst_mvgr5_in>-high   = lst_constant-high.
*     ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_in
*     IF lst_constant-param1 EQ lc_bstzd_email.
*       APPEND INITIAL LINE TO r_bstzd_email ASSIGNING FIELD-SYMBOL(<lst_bstzd_email>).
*       <lst_bstzd_email>-sign   = lst_constant-sign.
*       <lst_bstzd_email>-opti   = lst_constant-opti.
*       <lst_bstzd_email>-low    = lst_constant-low.
*       <lst_bstzd_email>-high   = lst_constant-high.
*     ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_in
*     IF lst_constant-param1 EQ lc_bstzd_no_email.
*       APPEND INITIAL LINE TO r_bstzd_no_email ASSIGNING FIELD-SYMBOL(<lst_bstzd_no_email>).
*       <lst_bstzd_no_email>-sign   = lst_constant-sign.
*       <lst_bstzd_no_email>-opti   = lst_constant-opti.
*       <lst_bstzd_no_email>-low    = lst_constant-low.
*       <lst_bstzd_no_email>-high   = lst_constant-high.
*     ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_in
*     End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
* EOC by MODUTTA on 31-JAN-2018 for CR_XXX
      IF lst_constant-param1 EQ lc_mvgr5_scc.
        APPEND INITIAL LINE TO r_mvgr5_scc ASSIGNING FIELD-SYMBOL(<lst_mvgr5_scc>).
        <lst_mvgr5_scc>-sign   = lst_constant-sign.
        <lst_mvgr5_scc>-opti   = lst_constant-opti.
        <lst_mvgr5_scc>-low    = lst_constant-low.
        <lst_mvgr5_scc>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_scc
      IF lst_constant-param1 EQ lc_mvgr5_scm.
        APPEND INITIAL LINE TO r_mvgr5_scm ASSIGNING FIELD-SYMBOL(<lst_mvgr5_scm>).
        <lst_mvgr5_scm>-sign   = lst_constant-sign.
        <lst_mvgr5_scm>-opti   = lst_constant-opti.
        <lst_mvgr5_scm>-low    = lst_constant-low.
        <lst_mvgr5_scm>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mvgr5_scm
*     Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      IF lst_constant-param1 EQ lc_sanctioned_c.
        APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
        <lst_sanc_country>-sign   = lst_constant-sign.
        <lst_sanc_country>-option = lst_constant-opti.
        <lst_sanc_country>-low    = lst_constant-low.
        <lst_sanc_country>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_sanctioned_c
*     End of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
*     Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
      IF lst_constant-param1 EQ lc_aust_text. " ABAP: Name of Variant Variable
        APPEND INITIAL LINE TO r_aust_text ASSIGNING FIELD-SYMBOL(<lst_aust_text>).
        <lst_aust_text>-sign   = lst_constant-sign.
        <lst_aust_text>-opti   = lst_constant-opti.
        <lst_aust_text>-low    = lst_constant-low.
        <lst_aust_text>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_aust_text
      IF lst_constant-param1 EQ lc_sales_org_text.
        APPEND INITIAL LINE TO r_sales_org_text ASSIGNING FIELD-SYMBOL(<lst_sales_org_text>).
        <lst_sales_org_text>-sign   = lst_constant-sign.
        <lst_sales_org_text>-opti   = lst_constant-opti.
        <lst_sales_org_text>-low    = lst_constant-low.
        <lst_sales_org_text>-high   = lst_constant-high.
      ENDIF.
*    End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
      IF lst_constant-param1 EQ lc_mat_grp5.
        APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
        <lst_mat_grp5>-sign   = lst_constant-sign.
        <lst_mat_grp5>-option = lst_constant-opti.
        <lst_mat_grp5>-low    = lst_constant-low.
        <lst_mat_grp5>-high   = lst_constant-high.
      ENDIF.
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
*   Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
      IF lst_constant-param1 EQ lc_digital_product.
        APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lst_digital_product>).
        <lst_digital_product>-sign   = lst_constant-sign.
        <lst_digital_product>-option = lst_constant-opti.
        <lst_digital_product>-low    = lst_constant-low.
        <lst_digital_product>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_print_product.
        APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lst_print_product>).
        <lst_print_product>-sign   = lst_constant-sign.
        <lst_print_product>-option = lst_constant-opti.
        <lst_print_product>-low    = lst_constant-low.
        <lst_print_product>-high   = lst_constant-high.
      ENDIF.
*   End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
      IF lst_constant-param1 EQ lc_payee_country.
        APPEND INITIAL LINE TO r_payee_countries ASSIGNING FIELD-SYMBOL(<lst_payee_countries>).
        <lst_payee_countries>-sign   = lst_constant-sign.
        <lst_payee_countries>-option = lst_constant-opti.
        <lst_payee_countries>-low    = lst_constant-low.
        <lst_payee_countries>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_vkorg_3310.
        APPEND INITIAL LINE TO r_vkorg_3310 ASSIGNING FIELD-SYMBOL(<lst_vkorg_3310>).
        <lst_vkorg_3310>-sign   = lst_constant-sign.
        <lst_vkorg_3310>-option = lst_constant-opti.
        <lst_vkorg_3310>-low    = lst_constant-low.
        <lst_vkorg_3310>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_vkorg_5501.
        APPEND INITIAL LINE TO r_vkorg_5501 ASSIGNING FIELD-SYMBOL(<lst_vkorg_5501>).
        <lst_vkorg_5501>-sign   = lst_constant-sign.
        <lst_vkorg_5501>-option = lst_constant-opti.
        <lst_vkorg_5501>-low    = lst_constant-low.
        <lst_vkorg_5501>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
*** BOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
      IF lst_constant-param1 EQ lc_bill_doc_type.
        lst_bill_doc_type-sign   = lst_constant-sign.
        lst_bill_doc_type-option = lst_constant-opti.
        lst_bill_doc_type-low    = lst_constant-low.
        APPEND lst_bill_doc_type TO r_bill_doc_type.
        CLEAR lst_bill_doc_type.
      ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
      IF lst_constant-param1 EQ lc_bill_doc_type_zibp.
        lst_bill_doc_type_zibp-sign   = lst_constant-sign.
        lst_bill_doc_type_zibp-option = lst_constant-opti.
        lst_bill_doc_type_zibp-low    = lst_constant-low.
        APPEND lst_bill_doc_type_zibp TO r_bill_doc_type_zibp.
        CLEAR lst_bill_doc_type_zibp.
      ENDIF.
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
* Begin of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
      IF lst_constant-param1 EQ lc_gst_no.
        APPEND INITIAL LINE TO r_gst_no  ASSIGNING FIELD-SYMBOL(<lst_gst_no>).
        <lst_gst_no>-sign   = lst_constant-sign.
        <lst_gst_no>-option = lst_constant-opti.
        <lst_gst_no>-low    = lst_constant-low.
        <lst_gst_no>-high   = lst_constant-high.
      ENDIF.
* End of ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*      IF lst_constant-param1 EQ lc_billing_type_zf2.
*        APPEND INITIAL LINE TO r_billing_type_zf2 ASSIGNING FIELD-SYMBOL(<lst_billing_type_zf2>).
*        <lst_billing_type_zf2>-sign   = lst_constant-sign.
*        <lst_billing_type_zf2>-option = lst_constant-opti.
*        <lst_billing_type_zf2>-low    = lst_constant-low.
*        <lst_billing_type_zf2>-high   = lst_constant-high.
*      ENDIF.
*      IF lst_constant-param1 EQ lc_billing_type_zcr.
*        APPEND INITIAL LINE TO r_billing_type_zcr ASSIGNING FIELD-SYMBOL(<lst_billing_type_zcr>).
*        <lst_billing_type_zcr>-sign   = lst_constant-sign.
*        <lst_billing_type_zcr>-option = lst_constant-opti.
*        <lst_billing_type_zcr>-low    = lst_constant-low.
*        <lst_billing_type_zcr>-high   = lst_constant-high.
*      ENDIF.
*      IF lst_constant-param1 EQ lc_shipping_country.
*        APPEND INITIAL LINE TO r_ship_to_country ASSIGNING FIELD-SYMBOL(<lst_ship_to_country>).
*        <lst_ship_to_country>-sign   = lst_constant-sign.
*        <lst_ship_to_country>-option = lst_constant-opti.
*        <lst_ship_to_country>-low    = lst_constant-low.
*        <lst_ship_to_country>-high   = lst_constant-high.
*      ENDIF.
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
      IF lst_constant-param1 EQ lc_bill_doc_type_curr.
        APPEND INITIAL LINE TO r_currency_country ASSIGNING FIELD-SYMBOL(<lst_currency_country>).
        <lst_currency_country>-sign   = lst_constant-sign.
        <lst_currency_country>-option = lst_constant-opti.
        <lst_currency_country>-low    = lst_constant-low.
        <lst_currency_country>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_currency_country.
        APPEND INITIAL LINE TO r_bill_doc_type_curr ASSIGNING FIELD-SYMBOL(<lst_bill_doc_type_curr>).
        <lst_bill_doc_type_curr>-sign   = lst_constant-sign.
        <lst_bill_doc_type_curr>-option = lst_constant-opti.
        <lst_bill_doc_type_curr>-low    = lst_constant-low.
        <lst_bill_doc_type_curr>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
*- Begin of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
      IF lst_constant-param1 EQ lc_document_type.
        APPEND INITIAL LINE TO r_document_type ASSIGNING FIELD-SYMBOL(<lst_document_type>).
        <lst_document_type>-sign   = lst_constant-sign.
        <lst_document_type>-option = lst_constant-opti.
        <lst_document_type>-low    = lst_constant-low.
        <lst_document_type>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_document_catg.
        APPEND INITIAL LINE TO r_document_catg ASSIGNING FIELD-SYMBOL(<lst_document_catg>).
        <lst_document_catg>-sign   = lst_constant-sign.
        <lst_document_catg>-option = lst_constant-opti.
        <lst_document_catg>-low    = lst_constant-low.
        <lst_document_catg>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_material_group.
        APPEND INITIAL LINE TO r_material_group ASSIGNING FIELD-SYMBOL(<lst_material_group>).
        <lst_material_group>-sign   = lst_constant-sign.
        <lst_material_group>-option = lst_constant-opti.
        <lst_material_group>-low    = lst_constant-low.
        <lst_material_group>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
      IF lst_constant-param1 EQ lc_vkorg_dd.
        APPEND INITIAL LINE TO r_vkorg_f044 ASSIGNING FIELD-SYMBOL(<lst_vkorg_f044>).
        <lst_vkorg_f044>-sign   = lst_constant-sign.
        <lst_vkorg_f044>-option = lst_constant-opti.
        <lst_vkorg_f044>-low    = lst_constant-low.
        <lst_vkorg_f044>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_zlsch_dd.
        APPEND INITIAL LINE TO r_zlsch_f044 ASSIGNING FIELD-SYMBOL(<lst_zlsch_f044>).
        <lst_zlsch_f044>-sign   = lst_constant-sign.
        <lst_zlsch_f044>-option = lst_constant-opti.
        <lst_zlsch_f044>-low    = lst_constant-low.
        <lst_zlsch_f044>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_kvgr1_dd.
        APPEND INITIAL LINE TO r_kvgr1_f044 ASSIGNING FIELD-SYMBOL(<lst_kvgr1_f044>).
        <lst_kvgr1_f044>-sign   = lst_constant-sign.
        <lst_kvgr1_f044>-option = lst_constant-opti.
        <lst_kvgr1_f044>-low    = lst_constant-low.
        <lst_kvgr1_f044>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_frm_dd.
        APPEND INITIAL LINE TO r_frm_f044 ASSIGNING FIELD-SYMBOL(<lst_frm_f044>).
        <lst_frm_f044>-sign   = lst_constant-sign.
        <lst_frm_f044>-option = lst_constant-opti.
        <lst_frm_f044>-low    = lst_constant-low.
        <lst_frm_f044>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*- Begin of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
      IF lst_constant-param1 EQ lc_doc_type.
        APPEND INITIAL LINE TO r_doc_type ASSIGNING FIELD-SYMBOL(<lst_doc_type>).
        <lst_doc_type>-sign   = lst_constant-sign.
        <lst_doc_type>-option = lst_constant-opti.
        <lst_doc_type>-low    = lst_constant-low.
        <lst_doc_type>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_pay_mth.
        APPEND INITIAL LINE TO r_pay_method ASSIGNING FIELD-SYMBOL(<lst_pay_method>).
        <lst_pay_method>-sign   = lst_constant-sign.
        <lst_pay_method>-option = lst_constant-opti.
        <lst_pay_method>-low    = lst_constant-low.
        <lst_pay_method>-high   = lst_constant-high.
      ENDIF.
*- End of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF lst_constant-param1 EQ lc_bill_type_zs1.     " Cancelled invoice
        APPEND INITIAL LINE TO fp_r_cinv ASSIGNING FIELD-SYMBOL(<lfs_cinv>).
        <lfs_cinv>-sign   = lst_constant-sign.
        <lfs_cinv>-opti = lst_constant-opti.
        <lfs_cinv>-low    = lst_constant-low.
        <lfs_cinv>-high   = lst_constant-high.
      ENDIF.

      IF lst_constant-param1 EQ lc_bill_type_zs2.   " Credit memo cancellation
        APPEND INITIAL LINE TO fp_r_ccrd ASSIGNING FIELD-SYMBOL(<lfs_ccrd>).
        <lfs_ccrd>-sign   = lst_constant-sign.
        <lfs_ccrd>-opti = lst_constant-opti.
        <lfs_ccrd>-low    = lst_constant-low.
        <lfs_ccrd>-high   = lst_constant-high.
      ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      CLEAR lst_constant.
    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc EQ 0

*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
  SORT fp_i_tax_id BY land1.
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAILID_VAL
*&---------------------------------------------------------------------*
*  Fetch Email ID
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER     Header structure
*      <--FP_V_EMAILADDRS  Email Adress
*----------------------------------------------------------------------*
FORM f_get_emailid_val  USING    fp_st_header    TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                        CHANGING fp_i_emailid    TYPE tt_emailid.               " E-Mail Address

* Data Declaration
  DATA : li_email                TYPE STANDARD TABLE OF ty_email INITIAL SIZE 0,
         lst_email               TYPE ty_email,
         lv_current_date         TYPE ad_valfrom, " Communication Data: Valid From (YYYYMMDDHHMMSS)
         lst_emailid             TYPE ty_emailid,
         lv_cust_number          TYPE char10,     " Cust_number of type CHAR10
         lv_person_number_billto TYPE ad_persnum, " Person number
         lv_add_billto           TYPE char1,      " Add_billto of type CHAR1
         lv_person_number_shipto TYPE ad_persnum, " Person number
         lv_add_shipto           TYPE char1.      " Add_shipto of type CHAR1

* Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
  CONSTANTS : lc_timstmp  TYPE char6      VALUE '000000',         " Timstmp of type CHAR6
              lc_validfrm TYPE ad_valfrom VALUE '19000101000000', " Communication Data: Valid From (YYYYMMDDHHMMSS)
              lc_validto  TYPE ad_valto   VALUE '99991231235959'. " Communication Data: Valid To (YYYYMMDDHHMMSS)

* End of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208

* Begin of DEL:ERP-2977:WROY:10-JUL-2017:ED2K907194
* Begin of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
*  CLEAR lv_cust_number.
*  lv_cust_number = fp_st_header-bill_cust_number.
** Subroutine to get bill to party address number
*  PERFORM f_get_address USING   lv_cust_number
*                       CHANGING lv_person_number_billto
*                                lv_add_billto
*                                st_but020.
*
*  fp_st_header-addr_number_billto   = st_but020-addrnumber.
*  fp_st_header-person_number_billto = lv_person_number_billto.
*  fp_st_header-add_billto           = lv_add_billto.
*
*
*  CLEAR lv_cust_number.
*  lv_cust_number =  fp_st_header-ship_cust_number.
** Subroutine to get ship to party address number
*  PERFORM f_get_address USING   lv_cust_number
*                       CHANGING lv_person_number_shipto
*                                lv_add_shipto
*                                st_but020.
*
*  fp_st_header-addr_number_shipto   = st_but020-addrnumber.
*  fp_st_header-person_number_shipto = lv_person_number_shipto.
*  fp_st_header-add_shipto           = lv_add_shipto.
*
** End of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
*
** Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
*  IF fp_st_header-addr_number_billto IS NOT INITIAL
*    AND fp_st_header-add_billto = 2.
*
** Fetch email ID from ADR6.
*    SELECT addrnumber " Address number
*           persnumber " Person number
*           smtp_addr  " E-Mail Address
*           valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
*           valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
*      FROM adr6       " E-Mail Addresses (Business Address Services)
*      INTO TABLE li_email
*          WHERE addrnumber EQ fp_st_header-addr_number_billto
*           AND persnumber  EQ fp_st_header-person_number_billto.
*    IF sy-subrc EQ 0.
*      SORT li_email BY addrnumber.
*    ENDIF. " IF sy-subrc EQ 0
*
*  ELSEIF fp_st_header-addr_number_billto IS NOT INITIAL
*    AND fp_st_header-add_billto = 1.
*
** Fetch email ID from ADR6.
*    SELECT addrnumber " Address number
*           persnumber " Person number
*           smtp_addr  " E-Mail Address
*           valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
*           valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
*      FROM adr6       " E-Mail Addresses (Business Address Services)
*          INTO TABLE li_email
*          WHERE addrnumber EQ fp_st_header-addr_number_billto.
*
*    IF sy-subrc EQ 0.
*      SORT li_email BY addrnumber.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF fp_st_header-addr_number_billto IS NOT INITIAL
* End   of DEL:ERP-2977:WROY:10-JUL-2017:ED2K907194
* Begin of ADD:ERP-2977:WROY:10-JUL-2017:ED2K907194
  IF fp_st_header-bill_addr_number IS NOT INITIAL.
*******BOC by MODUTTA on 14/09/2017 for JIRA# ERP-4206
    SELECT deflt_comm " Communication Method (Key) (Business Address Services)
      FROM adrc       " Addresses (Business Address Services)
      INTO @v_comm_method
      UP TO 1 ROWS
      WHERE  addrnumber EQ @fp_st_header-bill_addr_number.
    ENDSELECT.
    IF sy-subrc IS NOT INITIAL.
*   No Action
    ENDIF. " IF sy-subrc IS NOT INITIAL
*******EOC by MODUTTA on 14/09/2017 for JIRA# ERP-4206

*   Fetch email ID from ADR6.
    SELECT addrnumber " Address number
           persnumber " Person number
           smtp_addr  " E-Mail Address
           valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
           valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
      FROM adr6       " E-Mail Addresses (Business Address Services)
      INTO TABLE li_email
     WHERE addrnumber EQ fp_st_header-bill_addr_number.

    IF sy-subrc EQ 0.
      SORT li_email BY addrnumber.
    ENDIF. " IF sy-subrc EQ 0

    fp_st_header-addr_number_billto = fp_st_header-bill_addr_number.
    fp_st_header-add_billto         = 1.

    IF fp_st_header-ship_addr_number IS NOT INITIAL.
      fp_st_header-addr_number_shipto = fp_st_header-ship_addr_number.
      fp_st_header-add_shipto         = 1.
    ENDIF. " IF fp_st_header-ship_addr_number IS NOT INITIAL
* End   of ADD:ERP-2977:WROY:10-JUL-2017:ED2K907194

    IF li_email IS NOT INITIAL
      AND v_comm_method NE c_comm_method. "Added by MODUTTA since we are checking communication method first and then populating email
      lst_email-valid_from = lc_validfrm.
      MODIFY li_email FROM lst_email TRANSPORTING valid_from
       WHERE valid_from IS INITIAL.

      lst_email-valid_to   = lc_validto.
      MODIFY li_email FROM lst_email TRANSPORTING valid_to
       WHERE valid_to IS INITIAL.

      CONCATENATE sy-datum
                  lc_timstmp
             INTO lv_current_date.
      DELETE li_email WHERE valid_from GT lv_current_date
                         OR valid_to   LT lv_current_date.

* Get email address in table
      LOOP AT li_email INTO lst_email.
        lst_emailid-smtp_addr = lst_email-smtp_addr.
        APPEND lst_emailid TO fp_i_emailid.
        CLEAR lst_emailid.
      ENDLOOP. " LOOP AT li_email INTO lst_email
    ENDIF. " IF li_email IS NOT INITIAL
  ENDIF. " IF fp_st_header-bill_addr_number IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ITEM_TEXT_NAME
*&---------------------------------------------------------------------*
*  Item text hEading detail
*----------------------------------------------------------------------*
*      <--FP_I_ITEM_TEXT  Item level Text
*----------------------------------------------------------------------*
FORM f_get_item_text_name  CHANGING fp_i_item_text TYPE tt_item_text.

* Retrieve item text detail
  SELECT tdspras  " Language Key
         tdobject " Texts: Application Object
         tdid     " Text ID
         tdtext   " Short Text
    FROM ttxit    " Texts for Text IDs
    INTO TABLE fp_i_item_text
    WHERE tdspras  EQ st_header-language
      AND tdobject EQ c_obj_vbbp.
  IF sy-subrc EQ 0.
    SORT fp_i_item_text BY tdspras tdobject tdid.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_CSS_ITEM
*&---------------------------------------------------------------------*
*  Populate item table for CSS
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  Header data
*      -->FP_I_VBRP   Billing Item data
*      -->FP_I_ITEM_TEXT  Item text
*      -->FP_I_VBKD
*      <--FP_I_FINAL_CSS  Final table
*----------------------------------------------------------------------*
FORM f_populate_css_item  USING    fp_st_vbrk           TYPE ty_vbrk
                                   fp_i_vbrp            TYPE tt_vbrp
                                   fp_i_item_text       TYPE tt_item_text
                          CHANGING fp_i_final_css       TYPE ztqtc_item_detail_css_f042
                                   fp_i_subtotal        TYPE ztqtc_subtotal_f042
                                   fp_v_paid_amt        TYPE autwr. " Payment cards: Authorized amount

* Data declaration
  DATA : lv_text_id        TYPE tdid,                        " Text ID
         lv_fees           TYPE kzwi1,                       " Subtotal 1 from pricing procedure for condition
         lv_disc           TYPE kzwi5,                       " Subtotal 5 from pricing procedure for condition
         lv_tax            TYPE kzwi6,                       " Subtotal 6 from pricing procedure for condition
         lv_total          TYPE kzwi5,                       " Subtotal 5 from pricing procedure for condition
         lv_total_val      TYPE kzwi6,                       " Subtotal 6 from pricing procedure for condition
         lv_shipping       TYPE kzwi4,                       " Subtotal 4 from pricing procedure for condition
         lv_due            TYPE kzwi2,                       " Subtotal 2 from pricing procedure for condition
         lst_item_text     TYPE ty_item_text,                " Item Text
         lst_final_css     TYPE zstqtc_item_detail_css_f042, " Structure for CSS Item table
         lv_doc_line       TYPE /idt/doc_line_number,        " Document Line Number
         lv_buyer_reg      TYPE char255,                     " Buyer_reg of type CHAR255
*        Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
         lv_sub_ref_id     TYPE char255, " Sub Ref ID
*        End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
*    BOC BY SRBOSE on 12-OCT-2017 CR_618: TR: ED2K908908
         lv_year           TYPE char30, " Year
*         lv_year           TYPE char10,       " Year
*         lv_volum          TYPE char10,       " Volume
         lv_volum          TYPE char30, " Volume
         lv_vol            TYPE char8,  " Volume
*         lv_issue          TYPE char10,       " Issue
         lv_issue          TYPE char30,       " Issue
         lv_name           TYPE thead-tdname, " Name
         lv_name_issn      TYPE thead-tdname, " Name
         lv_identcode      TYPE char20,       " Identcode of type CHAR20
         lv_flag_di        TYPE char1,        " Flag_di of type CHAR1
         lv_flag_ph        TYPE char1,        " Flag_ph of type CHAR1
         lv_flag_se        TYPE char1,        " Flag_ph of type CHAR1
*         lv_pnt_issn       TYPE char10,       " Print ISSN
         lv_pnt_issn       TYPE char30, " Print ISSN
*    BOC BY SRBOSE on 12-OCT-2017 CR_618: TR: ED2K908908
         lv_vol_des        TYPE char255, " Vol_des of type CHAR255
         lv_issue_des      TYPE char255, " Issue_des of type CHAR255
         lv_identcode_zjcd TYPE char20,  " Identcode_zjcd of type CHAR20
         lst_jptidcdassign TYPE ty_jptidcdassign.

*  BOC BY SRBOSE #408
  DATA : li_lines           TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text            TYPE string,
         lv_ind             TYPE xegld,                   " Indicator: European Union Member?
         lst_line           TYPE tline,                   " SAPscript: Text Lines
         lst_lines          TYPE tline,                   " SAPscript: Text Lines
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         li_vbrp            TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
         lv_taxable_amt     TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_tax_amount      TYPE p DECIMALS 3,            " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                   " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                   " Rate (condition amount or percentage)
         lv_kbetr_char      TYPE char15,                  " Kbetr_char of type CHAR15
         lv_text_tax        TYPE string,
         lst_tax_item_final TYPE zstqtc_tax_item_f042,    " Structure for tax components
         lv_text_name       TYPE string, " ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
         lv_date            TYPE char10, " ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
*  EOC BY SRBOSE #408
         lv_bom_hdr_flg     TYPE xfeld. "Added by MODUTTA on 05/17/18 for INC0194372
* Constant Declaration
  CONSTANTS: lc_colon   TYPE char1 VALUE ':', " Colon of type CHAR1
             lc_first   TYPE char1 VALUE '(', " First of type CHAR1
             lc_percent TYPE char1 VALUE '%', " Percent of type CHAR1
             lc_second  TYPE char1 VALUE ')'. " Second of type CHAR1
*  BOC BY SRBOSE #408
  CONSTANTS:lc_undscr      TYPE char1      VALUE '_',     " Undscr of type CHAR1
            lc_vat         TYPE char3      VALUE 'VAT',   " Vat of type CHAR3
            lc_tax         TYPE char3      VALUE 'TAX',   " Tax of type CHAR3
            lc_gst         TYPE char3      VALUE 'GST',   " Gst of type CHAR3
            lc_class       TYPE char5      VALUE 'ZQTC_', " Class of type CHAR5
            lc_devid       TYPE char5      VALUE '_F024', " Devid of type CHAR5
*    BOC BY SRBOSE on 12-OCT-2017 CR_618: TR: ED2K908908
            lc_year        TYPE thead-tdname VALUE 'ZQTC_YEAR_F024',                  " Name
            lc_volume      TYPE thead-tdname VALUE 'ZQTC_VOLUME_F042',                " Name
            lc_pntissn     TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',            " Name
            lc_digissn     TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',          " Name
            lc_combissn    TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042',         " Name
            lc_issue       TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',                 " Name
            lc_digt_subsc  TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc  TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc  TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
*           Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
            lc_sub_ref_id  TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*           End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
            lc_shipping    TYPE tdobname VALUE 'ZQTC_F024_SHIPPING', " Name
            lc_digital     TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',  " Name
            lc_print       TYPE tdobname VALUE 'ZQTC_F024_PRINT',    " Name
            lc_mixed       TYPE tdobname VALUE 'ZQTC_F024_MIXED',    " Name
            lc_text_id     TYPE tdid     VALUE 'ST',                 " Text ID
            lc_tax_text    TYPE tdobname VALUE 'ZQTC_TAX_F024',      " Name
*    EOC BY SRBOSE on 12-OCT-2017 CR_618: TR: ED2K908908
            lc_comma       TYPE char1 VALUE ',', " Comma of type CHAR1
            lc_hyphen      TYPE char1 VALUE '-', " Hyphen of type CHAR1
*  Start of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
            lc_cover_year  TYPE thead-tdname VALUE 'ZQTC_F042_COVER_YEAR', " Name
            lc_cover_month TYPE thead-tdname VALUE 'ZQTC_F042_COVER_MONTH', " Name
            lc_end_date    TYPE thead-tdname VALUE 'ZQTC_F042_CNT_END_DATE', " Name
            lc_strt_date   TYPE thead-tdname VALUE 'ZQTC_F042_CNT_STRT_DATE', " Name
            lc_f042_issue  TYPE thead-tdname VALUE 'ZQTC_F042_ISSUE', " Name
            lc_f042_volume TYPE thead-tdname VALUE 'ZQTC_F042_VOLUME', " Name
            lc_st          TYPE thead-tdid     VALUE 'ST',                     "Text ID of text to be read
            lc_object      TYPE thead-tdobject VALUE 'TEXT'.                   "Object of text to be read
* End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721

  li_vbrp     = fp_i_vbrp.
  DATA(li_tax_data) = i_tax_data.
** Begin of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
*  SORT li_tax_data BY document doc_line_number.
  SORT li_tax_data BY seller_reg.
** End of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.
  SORT li_tax_data BY document doc_line_number. "INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.
*---------Cust VAT---------------------------------------------------*
  DATA(li_tax_temp) = i_tax_data.
  DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
  SORT li_tax_temp BY buyer_reg.
  DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
  DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
  IF lv_tax_line EQ 1.
    READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
    IF sy-subrc EQ 0.
      st_header-buyer_reg = lst_tax_temp-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_tax_line EQ 1
*--------------------------------------------------------------------*

*  Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD

***BOC by SRBOSE on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
*      AND   kposn = fp_st_vbap-posnr.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kawrt IS INITIAL.  "Commented by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
***EOC by SRBOSE on 17/10/2017 for CR#666

  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp).
    DATA(lv_tabix_space) = sy-tabix.
**    BOC by SRBOSE on 17/10/2017 for CR# 666
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                                 BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.


      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.


      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
    ENDIF. " IF sy-subrc EQ 0

***For BOM component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      lv_bom_hdr_flg = abap_true. "Added by MODUTTA on 05/17/18 for INC0194372
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0
***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
*    IF lst_tax_item-taxable_amt IS NOT INITIAL."Commented by MODUTTA on 05/17/18 for INC0194372
    IF lv_bom_hdr_flg IS INITIAL. "Added by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lv_bom_hdr_flg IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
    CLEAR: lv_bom_hdr_flg. "Added by MODUTTA on 05/17/18 for INC0194372
***EOC by MODUTTA for CR_743

    IF lst_vbrp-uepos IS INITIAL. "BOM header or Non BOM but no BOM components
      IF lv_tabix_space GT 1.
        CLEAR: lst_final_css.
        APPEND lst_final_css TO fp_i_final_css.
      ENDIF. " IF lv_tabix_space GT 1

      CONCATENATE st_vbrk-vbeln lst_vbrp-posnr INTO v_txt_name.

*****************BOC by MODUTTA for ERP-4272 on 26/09/2017************
*     Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
*    lst_final_css-quantity = lst_vbrp-fkimg.
      WRITE lst_vbrp-fkimg TO lst_final_css-quantity UNIT lst_vbrp-meins.
      CONDENSE lst_final_css-quantity.
*     End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
*    Begin of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
*  Unit Price calucalation
      CLEAR v_unit_price.
*  Unit Price = Net Value / Billed Quantity
      v_unit_price = lst_vbrp-kzwi1 / lst_vbrp-fkimg.
      WRITE v_unit_price TO lst_final_css-unit_price UNIT st_header-doc_currency.
      CONDENSE lst_final_css-unit_price.
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        CONCATENATE '-' lst_final_css-unit_price INTO lst_final_css-unit_price.
      ENDIF.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.  " Cancelled invoice
        CONCATENATE '-' lst_final_css-unit_price INTO lst_final_css-unit_price.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ENDIF.
*    End of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
**********************************************************************
**************************Amount**************************************
      SET COUNTRY st_header-bill_country.
      lv_fees = lst_vbrp-kzwi1.
      lv_disc = lst_vbrp-kzwi5.
      IF lv_fees LT 0.
        WRITE lv_fees TO lst_final_css-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-amount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_css-amount.
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_fees TO lst_final_css-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-amount.
        CONCATENATE '-' lst_final_css-amount INTO lst_final_css-amount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.
        WRITE lv_fees TO lst_final_css-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-amount.
        CONCATENATE '-' lst_final_css-amount INTO lst_final_css-amount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
        WRITE lv_fees TO lst_final_css-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-amount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_fees LT 0
        WRITE lv_fees TO lst_final_css-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-amount.
      ENDIF. " IF lv_fees LT 0
**********************************************************************
*****************************DISCOUNT*********************************
*     Begin of DEL:ERP-7021:WROY:14-Mar-2018:ED2K911344
*     IF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*     End   of DEL:ERP-7021:WROY:14-Mar-2018:ED2K911344
      IF lv_disc LT 0.
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_disc = lv_disc * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.
          lv_disc = lv_disc * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_disc TO lst_final_css-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-discount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_css-discount.
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_disc TO lst_final_css-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-discount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.
        WRITE lv_disc TO lst_final_css-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-discount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
        WRITE lv_disc TO lst_final_css-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-discount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_disc LT 0
        WRITE lv_disc TO lst_final_css-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-discount.
      ENDIF. " IF lv_disc LT 0
*     Begin of DEL:ERP-7021:WROY:14-Mar-2018:ED2K911344
*     ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
*     End   of DEL:ERP-7021:WROY:14-Mar-2018:ED2K911344
**********************************************************************
********************************TAX***********************************
      IF lst_final_css-tax IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF lv_tax LT 0.
          WRITE lv_tax TO lst_final_css-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-tax.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final_css-tax.
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
          WRITE lv_tax TO lst_final_css-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-tax.
          CONCATENATE '-' lst_final_css-tax INTO lst_final_css-tax.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.
          WRITE lv_tax TO lst_final_css-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-tax.
          CONCATENATE '-' lst_final_css-tax INTO lst_final_css-tax.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
          WRITE lv_tax TO lst_final_css-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-tax.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF lv_tax LT 0
          WRITE lv_tax TO lst_final_css-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-tax.
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF lst_final_css-tax IS INITIAL
**********************************************************************
********************************TOTAL***********************************
      lv_total_val = lst_vbrp-kzwi3 + lv_tax + lv_total_val.
      IF lv_total_val LT 0.
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_total = lv_total * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.
          lv_total = lv_total * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_total_val TO lst_final_css-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_css-total.
      ELSEIF lv_total_val GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_total_val TO lst_final_css-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-total.
        CONCATENATE '-' lst_final_css-total INTO lst_final_css-total.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_total_val GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.
        WRITE lv_total_val TO lst_final_css-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-total.
        CONCATENATE '-' lst_final_css-total INTO lst_final_css-total.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
        WRITE lv_total_val TO lst_final_css-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-total.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_total_val LT 0
        WRITE lv_total_val TO lst_final_css-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_css-total.
      ENDIF. " IF lv_total_val LT 0


      lv_shipping = lv_shipping + lst_vbrp-kzwi4.
**BOC BY SRBOSE
      IF  lst_vbrp-kzwi4 IS NOT INITIAL.

        IF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
          WRITE lst_vbrp-kzwi4 TO lst_final_css-amount CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-amount.
*        CONCATENATE lc_first lst_final_css-amount lc_second INTO lst_final_css-amount.
          CONCATENATE '-' lst_final_css-amount INTO lst_final_css-amount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF fp_st_vbrk-vbtyp IN r_cinv.
          WRITE lst_vbrp-kzwi4 TO lst_final_css-amount CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-amount.
          CONCATENATE '-' lst_final_css-amount INTO lst_final_css-amount.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
          WRITE lst_vbrp-kzwi4 TO lst_final_css-amount CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-amount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
          WRITE lst_vbrp-kzwi4 TO lst_final_css-amount CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-amount.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

        DATA: lv_total_shipping TYPE kzwi6. " Subtotal 6 from pricing procedure for condition
* Begin of ADD:INC0230447:RBTIRUMALA:02/19/2019:ED1K909573
        CLEAR lv_total_shipping.
* End of ADD:INC0230447:RBTIRUMALA:02/19/2019:ED1K909573
        lv_total_shipping = lv_total_shipping + lv_tax + lst_vbrp-kzwi4.
        IF fp_st_vbrk-vbtyp IN r_crd.
*          WRITE lst_vbrp-kzwi4 TO lst_final_css-total.
          WRITE lv_total_shipping TO lst_final_css-total CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-total.
*        CONCATENATE lc_first lst_final_css-total lc_second INTO lst_final_css-total.
          CONCATENATE '-' lst_final_css-total INTO lst_final_css-total.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF  fp_st_vbrk-vbtyp IN r_cinv.
          WRITE lv_total_shipping TO lst_final_css-total CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-total.
          CONCATENATE '-' lst_final_css-total INTO lst_final_css-total.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
          WRITE lv_total_shipping TO lst_final_css-total CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-total.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
*          WRITE lst_vbrp-kzwi4 TO lst_final_css-total.
          WRITE lv_total_shipping TO lst_final_css-total CURRENCY st_header-doc_currency.
          CONDENSE lst_final_css-total.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
*      lst_final_css-desc_advertiser = lst_vbrp-arktx.
*      APPEND lst_final_css TO fp_i_final_css.
*      CLEAR: lst_final_css.
      ENDIF. " IF lst_vbrp-kzwi4 IS NOT INITIAL
**EOC BY SRBOSE.
*************EOC by SRBOSE on 08/08/2017 for CR# 408****************

****************EOC by MODUTTA for ERP-4272 on 26/09/2017***********

*************************DESCRIPTION**********************************
*--------------------------------------------------------------------*
*Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
*    IF lst_vbrp-uepos IS INITIAL.
*Ene of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591

*Begin of change by SRBOSE on 12-Oct-2017 CR_618 #TR: ED2K908908
*     *      lst_final_css-desc_advertiser = lst_vbrp-arktx.
*      APPEND lst_final_css TO fp_i_final_css.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
      CLEAR:lst_jptidcdassign.
      READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                    idcodetype = v_idcodetype_2
                                                                    BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_identcode_zjcd = lst_jptidcdassign-identcode.
        CONCATENATE lv_identcode_zjcd lst_vbrp-arktx INTO lst_final_css-desc_advertiser SEPARATED BY lc_hyphen.
        CONDENSE lst_final_css-desc_advertiser.
      ELSE. " ELSE -> IF sy-subrc IS INITIAL
        lst_final_css-desc_advertiser = lst_vbrp-arktx.
      ENDIF. " IF sy-subrc IS INITIAL
      APPEND lst_final_css TO fp_i_final_css.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX


      CLEAR lst_final_css.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR: lv_flag_di,
               lv_flag_ph,
               lv_flag_se.
        IF lst_mara-ismmediatype EQ 'DI'.
          lv_flag_di = abap_true.
        ELSEIF lst_mara-ismmediatype EQ 'PH'.
          lv_flag_ph = abap_true.
        ELSEIF lst_mara-ismmediatype   EQ 'SE'.
          lv_flag_se = abap_true.
        ENDIF. " IF lst_mara-ismmediatype EQ 'DI'
* Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
*- Checking Mediatype i.e Digital / Print Media
        IF lst_mara-mtart IN r_digital_product OR lst_mara-mtart IN r_print_product.
*- Get Cover Year and Cover Month
          READ TABLE i_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbrp-vgbel
                                                         posnr = lst_vbrp-vgpos
                                                BINARY SEARCH.
          IF sy-subrc EQ 0.
*- For Cover Month
            SHIFT lst_vbap-zzcovrmt LEFT DELETING LEADING c_0.
            IF lst_vbap-zzcovrmt IS NOT INITIAL.

              CLEAR lv_text_name.
              PERFORM get_new_texts USING lc_st
                                          lc_object
                                          lc_cover_month
                          CHANGING lv_text_name.
              CONCATENATE lv_text_name lst_vbap-zzcovrmt   INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
              APPEND lst_final_css TO fp_i_final_css.
            ENDIF.
*- Cover Year
            SHIFT lst_vbap-zzcovryr LEFT DELETING LEADING c_0.
            IF lst_vbap-zzcovryr IS NOT INITIAL.
              CLEAR lv_text_name.
              PERFORM get_new_texts USING lc_st
                                          lc_object
                                          lc_cover_year
                          CHANGING lv_text_name.
              CONCATENATE lv_text_name lst_vbap-zzcovryr INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
              APPEND lst_final_css TO fp_i_final_css.
            ENDIF.
*- If it is Media type Digital, need to print contract start date and Contract end date
            IF lst_mara-mtart IN r_digital_product.
*- Get Contract Start date and end date
              READ TABLE i_veda INTO DATA(lstt_veda) WITH KEY vbeln = lst_vbrp-vgbel
                                                              vposn = lst_vbrp-vgpos
                                                     BINARY SEARCH.
              IF sy-subrc EQ 0.
*- Contract Start Date
                CLEAR: lv_text_name,lv_date.
                PERFORM get_new_texts USING lc_st
                                            lc_object
                                            lc_strt_date
                            CHANGING lv_text_name.
                CONCATENATE lstt_veda-vbegdat+4(2) lc_hyphen lstt_veda-vbegdat+6(2) lc_hyphen lstt_veda-vbegdat+0(4) INTO lv_date.
                CONCATENATE lv_text_name lv_date INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                APPEND lst_final_css TO fp_i_final_css.
*- Contract End Date
                CLEAR: lv_text_name,lv_date.
                PERFORM get_new_texts USING lc_st
                                            lc_object
                                            lc_end_date
                            CHANGING lv_text_name.
                CONCATENATE lstt_veda-venddat+4(2) lc_hyphen lstt_veda-venddat+6(2) lc_hyphen lstt_veda-venddat+0(4) INTO lv_date.
                CONCATENATE lv_text_name lv_date  INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                APPEND lst_final_css TO fp_i_final_css.
              ELSE.
                "Looks like Order doesn't have item information in VEDA
                "Fetch the start and end dates from header
                CLEAR : lstt_veda.
                READ TABLE i_veda INTO lstt_veda WITH KEY vbeln = lst_vbrp-vgbel
                                                          vposn = c_posnr
                                                       BINARY SEARCH.
                IF sy-subrc EQ 0.
*- Contract Start Date
                  CLEAR: lv_text_name,lv_date.
                  PERFORM get_new_texts USING lc_st
                                              lc_object
                                              lc_strt_date
                              CHANGING lv_text_name.
                  CONCATENATE lstt_veda-vbegdat+4(2) lc_hyphen lstt_veda-vbegdat+6(2) lc_hyphen lstt_veda-vbegdat+0(4) INTO lv_date.
                  CONCATENATE lv_text_name lv_date INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                  APPEND lst_final_css TO fp_i_final_css.
*- Contract End Date
                  CLEAR: lv_text_name,lv_date.
                  PERFORM get_new_texts USING lc_st
                                              lc_object
                                              lc_end_date
                              CHANGING lv_text_name.
                  CONCATENATE lstt_veda-venddat+4(2) lc_hyphen lstt_veda-venddat+6(2) lc_hyphen lstt_veda-venddat+0(4) INTO lv_date.
                  CONCATENATE lv_text_name lv_date  INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                  APPEND lst_final_css TO fp_i_final_css.
                ELSE.
                  "Investigate the reason for missing information
                ENDIF. "End of reading header VEDA
              ENDIF."End of reading item VEDA
*- If it is print media, need to print issue and Volume
            ELSEIF lst_mara-mtart IN r_print_product.
              SHIFT lst_mara-ismcopynr LEFT DELETING LEADING c_0.
              IF lst_mara-ismcopynr NE space.
*- For Volume
                CLEAR lv_text_name.
                PERFORM get_new_texts USING lc_st
                                            lc_object
                                            lc_f042_volume
                            CHANGING lv_text_name.
                CONCATENATE lv_text_name lst_mara-ismcopynr INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                APPEND lst_final_css TO fp_i_final_css.
              ENDIF.
*- For Issue
              SHIFT lst_mara-ismnrinyear LEFT DELETING LEADING c_0.
              IF lst_mara-ismnrinyear NE space.
                CLEAR lv_text_name.
                PERFORM get_new_texts USING lc_st
                                            lc_object
                                            lc_f042_issue
                            CHANGING lv_text_name.
                CONCATENATE lv_text_name lst_mara-ismnrinyear INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
                APPEND lst_final_css TO fp_i_final_css.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
* End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
        CLEAR : lv_name,
                lv_name_issn,
                lv_pnt_issn,
                v_subscription_typ.
        IF lv_flag_di EQ abap_true.
          lv_name = lc_digt_subsc.
*       Subroutine to get subscription type text (Digital subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_digissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX

        ELSEIF lv_flag_ph EQ abap_true.
          lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_pntissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX

        ELSEIF lv_flag_se EQ abap_true.
*            Do Nothing


        ELSE. " ELSE -> IF lv_flag_di EQ abap_true
          lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_combissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX


        ENDIF. " IF lv_flag_di EQ abap_true
        CLEAR: lst_final_css.
        lst_final_css-desc_advertiser = v_subscription_typ.
        APPEND lst_final_css TO fp_i_final_css.
      ENDIF. " IF sy-subrc EQ 0

* CSS Item Type Description
      lv_text_id = '0053'. " Put text id for CSS position text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_css_item_type SEPARATED BY lc_colon.
        CLEAR lst_final_css.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*End of change by SRBOSE on 12-Oct-2017 CR_618 #TR: ED2K908908

* Advertiser text
      lv_text_id = '0016'. " Put text id for adverviser text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.


*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.
      ENDIF. " IF sy-subrc EQ 0

*--------------------------------------------------------------------*
* Article level description text
      lv_text_id = '0017'. " Put text id for article level description text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_art_lvl_desc SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_art_lvl_desc.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
         lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
* *--------------------------------------------------------------------*
* Author information text
      lv_text_id = '0018'. " Put text id for author information text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_author_info SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_author_info.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Brand text
      lv_text_id = '0019'. " Put text id for brand text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_brand SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_brand.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
         lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*

* Business stream text
      lv_text_id = '0020'. " Put text id for business stream text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_busn_stream SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_busn_stream.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.
      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
*Begin Of Change By SRBOSE on 02-Aug-2017: #TR: ED2K907591: CR_506
* CSS Extra
      lv_text_id = '0060'.

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-css_extra SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-css_extra.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
           lst_final_css,
           lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
*End Of Change By SRBOSE on 02-Aug-2017: #TR: ED2K907591: CR_506

* Circulation text
      lv_text_id = '0021'. " Put text id for circulation text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_circulation SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_circulation.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.
      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Color text
      lv_text_id = '0022'. " Put text id for color text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_color SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_color.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Descipline text
      lv_text_id = '0024'. " Put text id for descipline text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_discipline SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_discipline.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
         lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Headline text
      lv_text_id = '0025'. " Put text id for headline text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_headline SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_headline.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Page extend text
      lv_text_id = '0028'. " Put text id for page extend text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_page_extent SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_page_extent.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*


* Paid position text
      lv_text_id = '0029'. " Put text id for paid position text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_paid_position SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_paid_position.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.
      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Service period text
      lv_text_id = '0030'. " Put text id for service period text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_serv_period SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_serv_period.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
            lst_final_css,
            lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Size text
      lv_text_id = '0031'. " Put text id for size text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_size SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_size.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
            lst_final_css,
            lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Sponsor text
      lv_text_id = '0032'. " Put text id for sponsor text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_sponsor SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_sponsor.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* With/without Cover
      lv_text_id = '0034'. " Put text id for with/without Cover text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_cover SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_cover.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* EAL Number
      lv_text_id = '0012'. " Put text id for EAL Number text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_eal_number SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_eal_number.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Cluster Description
      lv_text_id = '0043'. " Put text id for Cluster Description text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_cluster SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_cluster.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Article code
      lv_text_id = '0050'. " Put text id for Article code text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_article_code SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_article_code.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* CSS position
      lv_text_id = '0051'. " Put text id for CSS position text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_css_position SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_css_position.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* Type of Advertisement
      lv_text_id = '0052'. " Put text id for CSS position text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_type_adv SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_type_adv.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
              lst_final_css,
              lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
** CSS Item Type Description
*    lv_text_id = '0053'. " Put text id for CSS position text
*
** Subroutine to get item text
*    PERFORM f_get_item_text_line USING v_txt_name
*                                       lv_text_id
*                              CHANGING v_text_line.
*
**   Read table to get title of the item text
*    READ TABLE fp_i_item_text INTO lst_item_text
*                                 WITH KEY tdspras = st_header-language
*                                          tdobject = c_obj_vbbp
*                                          tdid = lv_text_id
*                                 BINARY SEARCH.
*
*    IF sy-subrc EQ 0
*      AND v_text_line IS NOT INITIAL.
*      CONDENSE lst_item_text-tdtext .
**     If item text exists, then only put the title in the final table.
**      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_css_item_type SEPARATED BY lc_colon.
*      CLEAR lst_final_css.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_advertiser.
*      APPEND lst_final_css TO fp_i_final_css.
*      CLEAR : v_text_line,
*        lst_final_css,
*        lv_text_id.
*
*    ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
******Begin Of Change By SRBOSE on 10-Oct-2017: TR: ED2K908908 #CR:618
** Price Override Reason
*    lv_text_id = '0054'. " Put text id for CSS position text
*
** Subroutine to get item text
*    PERFORM f_get_item_text_line USING v_txt_name
*                                       lv_text_id
*                              CHANGING v_text_line.
*
**   Read table to get title of the item text
*    READ TABLE fp_i_item_text INTO lst_item_text
*                                 WITH KEY tdspras = st_header-language
*                                          tdobject = c_obj_vbbp
*                                          tdid = lv_text_id
*                                 BINARY SEARCH.
*
*    IF sy-subrc EQ 0
*      AND v_text_line IS NOT INITIAL.
*      CONDENSE lst_item_text-tdtext .
**     If item text exists, then only put the title in the final table.
**      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_price_ovr_resn SEPARATED BY lc_colon.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*      CONDENSE lst_final_css-desc_advertiser.
*      APPEND lst_final_css TO fp_i_final_css.
*      CLEAR : v_text_line,
*        lst_final_css,
*        lv_text_id.
*
*    ENDIF. " IF sy-subrc EQ 0
******End Of Change By SRBOSE on 10-Oct-2017: TR: ED2K908908 #CR:618
*--------------------------------------------------------------------*
* Promotion Description
      lv_text_id = '0055'. " Put text id for Promotion Description text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_promotion SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* CSS Language
      lv_text_id = '0056'. " Put text id for CSS Language text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_css_language SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc EQ 0
*--------------------------------------------------------------------*
* CSS Sponsoring Company
      lv_text_id = '0057'. " Put text id for CSS Sponsoring Company text

* Subroutine to get item text
      PERFORM f_get_item_text_line USING v_txt_name
                                         lv_text_id
                                CHANGING v_text_line.

*   Read table to get title of the item text
      READ TABLE fp_i_item_text INTO lst_item_text
                                   WITH KEY tdspras = st_header-language
                                            tdobject = c_obj_vbbp
                                            tdid = lv_text_id
                                   BINARY SEARCH.

      IF sy-subrc EQ 0
        AND v_text_line IS NOT INITIAL.
        CONDENSE lst_item_text-tdtext .
*     If item text exists, then only put the title in the final table.
*      CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_css_sponsr_comp SEPARATED BY lc_colon.
        CONCATENATE lst_item_text-tdtext  v_text_line INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.
      ENDIF. " IF sy-subrc EQ 0

      READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                      BINARY SEARCH.
      IF sy-subrc IS INITIAL
        AND lst_vbkd-ihrez IS NOT INITIAL.
*            lst_final_tbt-sub_ref = lst_vbkd-ihrez.
        lst_final_css-desc_advertiser = lst_vbkd-ihrez.
*       Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        CLEAR: lv_sub_ref_id.
        PERFORM f_read_sub_type USING    lc_sub_ref_id
                                         lc_text_id
                                CHANGING lv_sub_ref_id.
        IF lv_sub_ref_id IS NOT INITIAL.
          CONCATENATE lv_sub_ref_id
                      lst_final_css-desc_advertiser
                 INTO lst_final_css-desc_advertiser
            SEPARATED BY space.
        ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*       End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        APPEND lst_final_css TO fp_i_final_css.
        CLEAR : v_text_line,
          lst_final_css,
          lv_text_id.

      ENDIF. " IF sy-subrc IS INITIAL

**Begin of change by SRBOSE on 12-Oct-2017 CR_618 #TR: ED2K908908
*      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
*                                                        BINARY SEARCH.
*      IF sy-subrc IS INITIAL.
*
******* VOLUME
*        lv_name = lc_volume.
*        CLEAR: lst_final_css.
*        PERFORM f_get_text_val USING lv_name
*                                     st_header
*                            CHANGING lv_volum.
*
**      IF lst_mara-volum NE 0.
*        IF lst_mara-ismcopynr IS NOT INITIAL.
**        lv_vol = lst_mara-volum.
*          lv_vol = lst_mara-ismcopynr.
**          CONCATENATE lv_volum lv_vol INTO lst_final_tbt-volume SEPARATED BY space.
*
** BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
**          CONCATENATE lv_volum lv_vol INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*          CONCATENATE lv_volum lv_vol INTO lv_vol_des SEPARATED BY lc_colon.
**          CONDENSE lst_final_css-desc_advertiser.
*          CONDENSE lv_vol_des.
**          APPEND lst_final_css TO fp_i_final_css.
** EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
*        ENDIF. " IF lst_mara-ismcopynr IS NOT INITIAL
*
****** ISSUE
*        lv_name = lc_issue.
*        CLEAR: lst_final_css.
*        PERFORM f_get_text_val USING lv_name
*                                     st_header
*                            CHANGING lv_issue.
*
*        IF lst_mara-ismnrinyear IS NOT INITIAL.
**          CONCATENATE lv_issue lst_mara-ismnrinyear INTO lst_final_tbt-issue SEPARATED BY space.
** BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
**          CONCATENATE lv_issue lst_mara-ismnrinyear INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
*          CONCATENATE lv_issue lst_mara-ismnrinyear INTO lv_issue_des SEPARATED BY lc_colon.
**          CONDENSE lst_final_tbt-issue.
**          CONDENSE lst_final_css-desc_advertiser.
*          CONDENSE lv_issue_des.
*          CONCATENATE lv_vol_des lv_issue_des INTO lst_final_css-desc_advertiser SEPARATED BY lc_comma.
** EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
*          APPEND lst_final_css-desc_advertiser TO fp_i_final_css.
*        ENDIF. " IF lst_mara-ismnrinyear IS NOT INITIAL
*      ENDIF. " IF sy-subrc IS INITIAL
*
***** Year
*      lv_name = lc_year.
*      CLEAR: lst_final_css.
*      PERFORM f_get_text_val USING lv_name
*                                   st_header
*                          CHANGING lv_year.
*
*      IF lst_mara-ismyearnr IS NOT INITIAL.
**          CONCATENATE lv_year lst_mara-ismyearnr INTO lst_final_tbt-issue_year SEPARATED BY space.
*        CONCATENATE lv_year lst_mara-ismyearnr INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
**          CONDENSE lst_final_tbt-issue_year.
*        CONDENSE lst_final_css-desc_advertiser.
*        APPEND lst_final_css TO fp_i_final_css.
*      ENDIF. " IF lst_mara-ismyearnr IS NOT INITIAL
*
****ISSN
*      CLEAR: lst_final_css.
*      READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
*                                                                idcodetype = v_idcodetype_1 "(++ BOC by SRBOSE for CR_XXX)
*                                                                 BINARY SEARCH.
*      IF sy-subrc EQ 0.
*
**        lv_name = lc_pntissn.
**
**        PERFORM f_get_text_val USING lv_name
**                                     st_header
**                            CHANGING lv_pnt_issn.
**
*        IF lst_jptidcdassign-identcode IS NOT INITIAL.
*          lv_identcode = lst_jptidcdassign-identcode.
**            CONCATENATE lv_pnt_issn lst_jptidcdassign-identcode INTO lst_final_tbt-print_issn SEPARATED BY space.
*          CONCATENATE lv_pnt_issn lst_jptidcdassign-identcode INTO lst_final_css-desc_advertiser SEPARATED BY lc_colon.
**            CONDENSE lst_final_tbt-print_issn.
*          CONDENSE lst_final_css-desc_advertiser.
*          APPEND lst_final_css TO fp_i_final_css.
*        ENDIF. " IF lst_jptidcdassign-identcode IS NOT INITIAL
*      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbrp-uepos IS INITIAL
*End of change by SRBOSE on 12-Oct-2017 CR_618 #TR: ED2K908908
*--------------------------------------------------------------------*
************************************************************************

*     Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
*    IF lst_final_css-quantity IS INITIAL.
*      CLEAR: lst_final_css-quantity.
*    ENDIF. " IF lst_final_css-quantity IS INITIAL
*      End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591

*************BOC by SRBOSE on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
*   lv_doc_line = lst_vbrp-posnr+2(4).
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
*** BOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
      IF v_seller_reg IS INITIAL.
        v_seller_reg = lst_tax_data-seller_reg.
      ELSE.
        CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma.
      ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
*      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commented per CR#7431&7189 KKRAVURI20181109
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
*     Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
*     IF lst_vbrp-aland EQ lst_vbrp-lland.
*     End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
*     Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
      IF st_header-comp_code_country EQ lst_vbrp-lland.
*     End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma. " ADD: CR#7431&7189 KKRAVURI20181109  ED2K913809
*            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commented per CR#7431&7189 KKRAVURI20181109
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
*   Buyer Reg
*      CONCATENATE lst_tax_data-buyer_reg lv_buyer_reg INTO lv_buyer_reg SEPARATED BY space.
    ENDIF. " IF sy-subrc EQ 0

    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.
*    lv_shipping = lv_shipping + lst_vbrp-kzwi4.
    lv_due = lv_due + lst_vbrp-kzwi2.

*BOC by MODUTTA on 08/08/2017 fo CR#408
    IF st_header-buyer_reg IS INITIAL.
      READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
      IF sy-subrc EQ 0
        AND lst_tax_data-buyer_reg IS NOT INITIAL.
        CLEAR lst_final_css.
*  lst_final_tbt-mat_desc = lv_buyer_reg.
*        lst_final_css-desc_issue = lst_tax_data-buyer_reg.
        lst_final_css-desc_advertiser = lst_tax_data-buyer_reg.
*        CONCATENATE lv_text lst_final_css-desc_issue INTO lst_final_css-desc_issue SEPARATED BY space.
*        CONCATENATE lv_text lst_final_css-desc_advertiser INTO lst_final_css-desc_advertiser SEPARATED BY space.
        CONDENSE lst_final_css-desc_advertiser.
        APPEND lst_final_css TO fp_i_final_css.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_header-buyer_reg IS INITIAL

    CLEAR : lst_final_css,
            lv_fees,
            lv_disc,
            lv_tax,
            lv_total,
            lv_total_val.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)

*EOC by MODUTTA on 08/08/2017 fo CR#408
* SubTotal Amount
  IF v_seller_reg IS NOT INITIAL.
*    BOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
*    CONCATENATE lv_text v_seller_reg INTO v_seller_reg SEPARATED BY lc_colon.
*    EOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
    CONDENSE v_seller_reg.
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
* Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* ELSEIF st_header-bill_country EQ st_header-ship_country.
* End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
* End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
  ENDIF. " IF v_seller_reg IS NOT INITIAL
  IF  lv_shipping IS NOT INITIAL.
    v_subtotal_val = st_vbrk-netwr - lv_shipping.
  ELSE. " ELSE -> IF lv_shipping IS NOT INITIAL
    v_subtotal_val = st_vbrk-netwr.
  ENDIF. " IF lv_shipping IS NOT INITIAL

* Shipping Amount
  v_shipping_val = lv_shipping.

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_vbrk-zlsch EQ 'J'.
    fp_v_paid_amt = v_subtotal_val + v_sales_tax.
*    WRITE fp_v_paid_amt TO fp_v_prepaid_amount.  " (--) PBOSE: 05-June-2017: DEFECT 2276: ED2K906208
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

* IF fp_st_vbrk-fkart IN r_crd    " (--) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*  IF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
* Total due amount
*    v_totaldue_val = ( v_subtotal_val + v_sales_tax + v_shipping_val ) + fp_v_paid_amt.
*  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
* Begin of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
*  total due amount witthout prepaid amount
  IF v_credit_memo = c_o.
    v_totaldue_val = v_subtotal_val + v_sales_tax + v_shipping_val.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSEIF v_credit_memo IN r_cinv.   " cancelled invoice
    v_totaldue_val = v_subtotal_val + v_sales_tax + v_shipping_val.
  ELSEIF v_credit_memo IN r_ccrd.   " cancelled credit memo
    v_totaldue_val = ( v_subtotal_val + v_sales_tax + v_shipping_val ) - fp_v_paid_amt.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSE.
* End of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
* Total due amount with Prepaid amount
    v_totaldue_val = ( v_subtotal_val + v_sales_tax + v_shipping_val ) - fp_v_paid_amt.
*  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
  ENDIF. "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657

***BOC by SRBOSE for CR#666 on 18/10/2017
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by SRBOSE for CR#666 on 18/10/2017
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ITEM_TEXT_LINE
*&---------------------------------------------------------------------*
* Subroutine to get item text lines
*----------------------------------------------------------------------*
*      -->FP_V_TXT_NAME   Text name
*      <--FP_V_TEXT_LINE  Item text value
*----------------------------------------------------------------------*
FORM f_get_item_text_line  USING    fp_v_txt_name  TYPE tdobname " Name
                                    fp_text_id     TYPE tdid     " Text ID
                           CHANGING fp_v_text_line TYPE char100. " V_text_line of type CHAR100

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : lv_text,
          fp_v_text_line.

*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_text_id
      language                = st_header-language
      name                    = fp_v_txt_name
      object                  = c_obj_vbbp
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
*    Commented by MODUTTA: if the texts are maintained with space in next lines then its giving ##
    DATA(lv_lines) = lines( li_lines ).
    READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX lv_lines.
    IF sy-subrc EQ 0.
      IF <lst_lines>-tdline IS INITIAL.
        CLEAR <lst_lines>-tdformat.
        DELETE li_lines WHERE tdformat IS INITIAL
                        AND   tdline IS INITIAL.
      ENDIF. " IF <lst_lines>-tdline IS INITIAL
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_lines
        IMPORTING
          ev_text_string = lv_text.
      IF sy-subrc EQ 0.
        fp_v_text_line = lv_text.
        CONDENSE fp_v_text_line.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
*  End of comment by MODUTTA

*    LOOP AT li_lines INTO DATA(lst_lines).
*      IF lst_lines-tdline IS NOT INITIAL.
*        CONCATENATE lst_lines-tdline fp_v_text_line INTO fp_v_text_line.
*      ENDIF.
*    ENDLOOP.
    CONDENSE fp_v_text_line.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_CSS_LAYOUT
*&---------------------------------------------------------------------*
* Subroutine to populate CSS layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout USING fp_v_formname TYPE fpname. " Name of Form Object

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lv_upd_tsk          TYPE i.                           "Added by MODUTTA

  lst_sfpoutputparams-preview = abap_true.
************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true. "comment by MODUTTA on 11-May-2018 for INC0194261
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf  = abap_true.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = nast-ldest.
  lst_sfpoutputparams-copies    = nast-anzal.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = nast-tdarmod.
  lst_sfpoutputparams-reqimm    = nast-dimme.
  lst_sfpoutputparams-reqdel    = nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
  lst_sfpdocparams-langu     = nast-spras.


* Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb              = sy-msgid
        msg_nr                 = sy-msgno
        msg_ty                 = sy-msgty
        msg_v1                 = sy-msgv1
        msg_v2                 = sy-msgv2
        msg_v3                 = sy-msgv3
        msg_v4                 = sy-msgv4
      EXCEPTIONS
        message_type_not_valid = 1
        no_sy_message          = 2
        OTHERS                 = 3.
    IF sy-subrc NE 0.
*     Nothing to do
    ENDIF. " IF sy-subrc NE 0
    v_ent_retco = 900.
    RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = fp_v_formname "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        LEAVE LIST-PROCESSING.
    ENDTRY.
    IF fp_v_formname EQ c_css_form.
* Call function module to generate CSS detail

      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000093'
        EXPORTING
          /1bcdwb/docparams       = lst_sfpdocparams
          im_header               = st_header
          im_item_css             = i_final_css
          im_xstring              = v_xstring
          im_footer               = v_footer
          im_remit_to             = v_remit_to
          im_v_tax                = v_tax
          im_v_accmngd_title      = v_accmngd_title
          im_v_bank_detail        = v_bank_detail
          im_v_crdt_card_det      = v_crdt_card_det
          im_v_payment_detail     = v_payment_detail
          im_cust_service_det     = v_cust_service_det
          im_v_totaldue           = v_totaldue
          im_v_subtotal           = v_subtotal
          im_v_vat                = v_vat
          im_v_prepaidamt         = v_prepaidamt
          im_v_shipping           = v_shipping
          im_v_subtotal_val       = v_subtotal_val
          im_v_sales_tax          = v_sales_tax
          im_v_totaldue_val       = v_totaldue_val
          im_v_prepaid_amount     = v_paid_amt
          im_v_shipping_val       = v_shipping_val
          vbrp                    = vbrp
          im_society_logo         = v_society_logo
          im_item_tbt             = i_final_tbt
          mara                    = mara
          im_v_society_text       = v_society_text
          im_item_society         = i_final_soc
          im_v_reprint            = v_reprint
          im_v_title              = v_title
          im_v_seller_reg         = v_seller_reg
          im_v_credit_text        = v_credit_text
          im_subtotal_table       = i_subtotal
          im_country_uk           = v_country_uk
          im_v_invoice_desc       = v_invoice_desc
          im_v_payment_detail_inv = v_payment_detail_inv
          im_tax_item             = i_tax_item
          im_text_item            = i_text_item
          im_terms_cond           = v_terms_cond
          im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
          im_v_ind_text           = v_ind_text
          im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
          im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          im_v_receipt_flag       = v_receipt_flag
          im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          im_v_credit_memo        = v_credit_memo "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
        IMPORTING
          /1bcdwb/formoutput      = st_formoutput
        EXCEPTIONS
          usage_error             = 1
          system_error            = 2
          internal_error          = 3
          OTHERS                  = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*         Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
          v_ent_retco = 900.
          RETURN.
*         End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0

    ELSEIF fp_v_formname EQ c_tbt_form.

      CALL FUNCTION lv_funcname " '/1BCDWB/SM00000094'
        EXPORTING
          /1bcdwb/docparams       = lst_sfpdocparams
          im_header               = st_header
          im_item_css             = i_final_css
          im_xstring              = v_xstring
          im_footer               = v_footer
          im_remit_to             = v_remit_to
          im_v_tax                = v_tax
          im_v_accmngd_title      = v_accmngd_title
          im_v_bank_detail        = v_bank_detail
          im_v_crdt_card_det      = v_crdt_card_det
          im_v_payment_detail     = v_payment_detail
          im_cust_service_det     = v_cust_service_det
          im_v_totaldue           = v_totaldue
          im_v_subtotal           = v_subtotal
          im_v_vat                = v_vat
          im_v_prepaidamt         = v_prepaidamt
          im_v_shipping           = v_shipping
          im_v_subtotal_val       = v_subtotal_val
          im_v_sales_tax          = v_sales_tax
          im_v_totaldue_val       = v_totaldue_val
          im_v_prepaid_amount     = v_paid_amt
          im_v_shipping_val       = v_shipping_val
          vbrp                    = vbrp
          im_society_logo         = v_society_logo
          im_item_tbt             = i_final_tbt
          mara                    = mara
          im_v_society_text       = v_society_text
          im_item_society         = i_final_soc
          im_v_reprint            = v_reprint
          im_v_title              = v_title
          im_v_seller_reg         = v_seller_reg
          im_v_credit_text        = v_credit_text
          im_subtotal_table       = i_subtotal
          im_country_uk           = v_country_uk
          im_v_invoice_desc       = v_invoice_desc
          im_v_payment_detail_inv = v_payment_detail_inv
          im_tax_item             = i_tax_item
          im_text_item            = i_text_item
          im_terms_cond           = v_terms_cond
          im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
          im_v_ind_text           = v_ind_text
          im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
          im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          im_v_receipt_flag       = v_receipt_flag
          im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          im_v_credit_memo        = v_credit_memo "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
        IMPORTING
          /1bcdwb/formoutput      = st_formoutput
        EXCEPTIONS
          usage_error             = 1
          system_error            = 2
          internal_error          = 3
          OTHERS                  = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*         Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
          v_ent_retco = 900.
          RETURN.
*         End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0

    ELSEIF fp_v_formname EQ c_soc_form OR fp_v_formname EQ c_soc_comb_form.
**--*Begin of change Prabhu CR#6376 ED2K914840
      IF fp_v_formname EQ c_soc_comb_form..  "Call the new form to print Summery and detail together
        CALL FUNCTION lv_funcname
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_item_css             = i_final_css
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_shipping           = v_shipping
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt
            im_v_shipping_val       = v_shipping_val
            vbrp                    = vbrp
            im_society_logo         = v_society_logo
            im_item_tbt             = i_final_tbt
            mara                    = mara
            im_v_society_text       = v_society_text
            im_item_society         = i_final_soc
            im_item_summery         = i_final_summery
            im_v_reprint            = v_reprint
            im_v_title              = v_title
            im_v_seller_reg         = v_seller_reg
            im_v_credit_text        = v_credit_text
            im_subtotal_table       = i_subtotal
            im_country_uk           = v_country_uk
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_terms_cond           = v_terms_cond
            im_v_aust_text          = v_aust_text
            im_v_ind_text           = v_ind_text
            im_v_tax_expt           = v_tax_expt
            im_exc_tab              = i_exc_tab
            im_v_receipt_flag       = v_receipt_flag
            im_v_barcode            = v_barcode
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.
      ELSE.
        CALL FUNCTION lv_funcname " '/1BCDWB/SM00000095'
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_item_css             = i_final_css
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_shipping           = v_shipping
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt
            im_v_shipping_val       = v_shipping_val
            vbrp                    = vbrp
            im_society_logo         = v_society_logo
            im_item_tbt             = i_final_tbt
            mara                    = mara
            im_v_society_text       = v_society_text
            im_item_society         = i_final_soc
            im_v_reprint            = v_reprint
            im_v_title              = v_title
            im_v_seller_reg         = v_seller_reg
            im_v_credit_text        = v_credit_text
            im_subtotal_table       = i_subtotal
            im_country_uk           = v_country_uk
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_terms_cond           = v_terms_cond
            im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
            im_v_ind_text           = v_ind_text
            im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
            im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
            im_v_receipt_flag       = v_receipt_flag
            im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
            im_v_credit_memo        = v_credit_memo "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.
      ENDIF.
**--*End of change Prabhu CR#6376 ED2K914840
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*         Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
          v_ent_retco = 900.
          RETURN.
*         End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0

    ENDIF. " IF fp_v_formname EQ c_css_form
  ENDIF. " IF sy-subrc <> 0
*******BOC by MODUTTA on 25/09/2017 for saving the form in app server if communication method is 'LET'***
  IF v_comm_method = c_comm_method
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
 AND v_ent_screen  IS INITIAL.
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
    PERFORM f_save_pdf_applictn_server.
  ENDIF. " IF v_comm_method = c_comm_method
******************EOC by MODUTTA**********************************************************

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
*  post form processing
* Begin of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909763
  IF lst_sfpoutputparams-arcmode <> '1' AND "Uncomment by MODUTTA on 02/04/2018 ERP-7340
     v_ent_screen  IS INITIAL.
*  IF lst_sfpoutputparams-arcmode <> '1' AND        "Comment by MODUTTA on 02/04/2018 ERP-7340
*     nast-nacha NE '1' AND           "Print output "Comment by MODUTTA on 02/04/2018 ERP-7340
*     v_comm_method NE c_comm_method. "Letter       "Comment by MODUTTA on 02/04/2018 ERP-7340
* End   of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909763
    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = 'PDF' "  class
        document                 = st_formoutput-pdf
      TABLES
        arc_i_tab                = lst_sfpdocparams-daratab
      EXCEPTIONS
        error_archiv             = 1
        error_communicationtable = 2
        error_connectiontable    = 3
        error_kernel             = 4
        error_parameter          = 5
        error_format             = 6
        OTHERS                   = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              RAISING system_error.
    ELSE. " ELSE -> IF sy-subrc <> 0
*     Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
*     COMMINT only if the subroutine is not called in update task
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1' AND
************EOC by MODUTTA on 18.07.2017 for print & archive****************************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_TITLE_TEXT
*&---------------------------------------------------------------------*
*  Populate title text
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      <--FP_ST_HEADER  text
*      <--FP_V_ACCMNGD_TITLE  text
*      <--FP_V_TAX  text
*      <--FP_V_REMIT_TO  text
*      <--FP_V_FOOTER  text
*      <--FP_V_COUNTRY_KEY  text
*      <--FP_V_BANK_DETAIL  text
*      <--FP_V_CRDT_CARD_DET  text
*      <--FP_V_PAYMENT_DETAIL  text
*      <--FP_V_CUST_SERVICE_DET  text
*      <--FP_V_TOTALDUE  text
*      <--FP_V_SUBTOTAL  text
*      <--FP_V_PREPAIDAMT  text
*      <--FP_V_VAT  text
*      <--FP_V_SHIPPING  text
*----------------------------------------------------------------------*
FORM f_fetch_title_text  USING    fp_st_vbrk                TYPE ty_vbrk
                                  fp_r_country             TYPE tt_country
                         CHANGING fp_st_header              TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                                  fp_v_accmngd_title        TYPE char255                   " V_accmngd_title of type CHAR255
                                  fp_v_invoice_title        TYPE char255                   " V_accmngd_title of type CHAR255
                                  fp_v_reprint              TYPE char255                   " Reprint
                                  fp_v_tax                  TYPE thead-tdname              " Name
                                  fp_v_remit_to             TYPE thead-tdname              " Name
                                  fp_v_footer               TYPE thead-tdname              " Name
                                  fp_v_bank_detail          TYPE thead-tdname              " Bank Detail
                                  fp_v_crdt_card_det        TYPE thead-tdname              " Bank Detail
                                  fp_v_payment_detail       TYPE thead-tdname              " Bank Detail
                                  fp_v_cust_service_det     TYPE thead-tdname              " Bank Detail
                                  fp_v_totaldue             TYPE char140                   " V_totaldue of type CHAR140
                                  fp_v_subtotal             TYPE char140                   " V_subtotal of type CHAR140
                                  fp_v_prepaidamt           TYPE char140                   " V_prepaidamt of type CHAR140
                                  fp_v_vat                  TYPE char140                   " V_vat of type CHAR140
                                  fp_v_shipping             TYPE char140                   " V_shipping of type CHAR140
                                  fp_v_payment_detail_inv   TYPE thead-tdname.             " Name

* Data declaration
  DATA : li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text   TYPE string,
         lv_ind    TYPE xegld,                   " Indicator: European Union Member?
         lst_line  TYPE tline,                   " SAPscript: Text Lines
         lst_lines TYPE tline.                   " SAPscript: Text Lines

* Constant Declaration
  CONSTANTS : lc_css_remit_to     TYPE char30     VALUE 'ZQTC_F042_CSS_REMIT_TO_',      " Remit_to of type CHAR20
              lc_remit_to         TYPE char20     VALUE 'ZQTC_REMIT_TO',                " Remit_to of type CHAR20
              lc_xxx              TYPE char3      VALUE 'XXX',                          " Xxx of type CHAR3
              lc_credit_card      TYPE char30     VALUE 'ZQTC_F042_CREDIT_CARD',        " Credit_card of type CHAR30
              lc_credit_card_fax  TYPE char30     VALUE 'ZQTC_F042_CREDIT_CARD_FAX',        " Credit_card of type CHAR30
              lc_tbt_agency_crd1  TYPE char30     VALUE 'ZQTC_CREDIT_CARD_AGENCY',      " Tbt_agency_crd1 of type CHAR30
              lc_css_crd_card_det TYPE char30     VALUE 'ZQTC_F042_CSS_CREDIT_CARD_',   " Crd_card_det of type CHAR22
              lc_css_paymnt_det   TYPE char30     VALUE 'ZQTC_F042_CSS_PAYMNT_DET_',    " Paymnt_det of type CHAR20
              lc_css_cust_service TYPE char30     VALUE 'ZQTC_F042_CSS_CUST_SERV_',     " Cust_service of type CHAR20
              lc_cust_service     TYPE char20     VALUE 'ZQTC_F042_CUST_SERV_',         " Cust_service of type CHAR20
              lc_css_bank_det     TYPE char30     VALUE 'ZQTC_F042_CSS_BANK_DET_',      " Bank details
              lc_css_footer       TYPE char30     VALUE 'ZQTC_F042_CSS_FOOTER_',        " Footer of type CHAR20
              lc_footer           TYPE char16     VALUE 'ZQTC_FOOTER_',                 " Footer of type CHAR20
              lc_tbt_remit_to     TYPE char30     VALUE 'ZQTC_F042_TBT_REMIT_TO_',      " Remit_to of type CHAR20
              lc_tbt_crd_card_det TYPE char30     VALUE 'ZQTC_F042_TBT_CREDIT_CARD_',   " Crd_card_det of type CHAR22
              lc_tbt_terms        TYPE char30     VALUE 'ZQTC_F042_TBT_TERMS_',         " Crd_card_det of type CHAR22
              lc_css_terms        TYPE char30     VALUE 'ZQTC_F042_CSS_TERMS_',         " Crd_card_det of type CHAR22
              lc_scc_terms        TYPE char30     VALUE 'ZQTC_F042_SCC_TERMS_',         " Crd_card_det of type CHAR22
              lc_scm_terms        TYPE char30     VALUE 'ZQTC_F042_SCM_TERMS_',         " Crd_card_det of type CHAR22
              lc_tbt_agency       TYPE char30     VALUE 'ZQTC_F042_TBT_CRDT_AGENCY_',   " Crd_card_det of type CHAR22
              lc_tbt_agency_crd   TYPE char30     VALUE 'ZQTC_F042_TBT_CREDIT_AGENCY_', " Crd_card_det of type CHAR22
*              lc_tbt_agency_crd1   TYPE char30     VALUE 'ZQTC_CREDIT_CARD_AGENCY_', " Crd_card_det of type CHAR22
              lc_tbt_agency1      TYPE char30     VALUE 'ZQTC_F042_CUST_AGENCY_',    " Crd_card_det of type CHAR22
              lc_tbt_paymnt_det   TYPE char30     VALUE 'ZQTC_F042_TBT_PAYMNT_DET_', " Paymnt_det of type CHAR20
              lc_tbt_cust_service TYPE char30     VALUE 'ZQTC_F042_TBT_CUST_SERV_',  " Cust_service of type CHAR20
              lc_tbt_bank_det     TYPE char30     VALUE 'ZQTC_F042_TBT_BANK_DET_',   " Bank details
              lc_tbt_footer       TYPE char30     VALUE 'ZQTC_F042_TBT_FOOTER_',     " Footer of type CHAR20
*              lc_soc_remit_to     TYPE char30     VALUE 'ZQTC_F042_SOC_REMIT_TO_',    " Remit_to of type CHAR20
              lc_soc_remit_to     TYPE char30     VALUE 'ZQTC_F027_REMIT_TO_', " Remit_to of type CHAR20
*              lc_soc_crd_card_det TYPE char30     VALUE 'ZQTC_F042_SOC_CREDIT_CARD_', " Crd_card_det of type CHAR22
              lc_scc_crd_card_det TYPE char30     VALUE 'ZQTC_F042_SCC_CREDIT_CARD_', " Crd_card_det of type CHAR22
              lc_scm_crd_card_det TYPE char30     VALUE 'ZQTC_F042_SCM_CREDIT_CARD_', " Crd_card_det of type CHAR22
*              lc_soc_crd_card_det TYPE char30     VALUE 'ZQTC_F027_PAYMENT_', " Crd_card_det of type CHAR22
*              lc_soc_paymnt_det   TYPE char30     VALUE 'ZQTC_F042_SOC_PAYMNT_DET_',  " Paymnt_det of type CHAR20
              lc_scc_paymnt_det   TYPE char30     VALUE 'ZQTC_F042_SCC_PAYMNT_DET_', " Paymnt_det of type CHAR20
              lc_scm_paymnt_det   TYPE char30     VALUE 'ZQTC_F042_SCM_PAYMNT_DET_', " Paymnt_det of type CHAR20
*              lc_soc_paymnt_det   TYPE char30     VALUE 'ZQTC_F027_CREDIT_',  " Paymnt_det of type CHAR20
*              lc_soc_paymnt_det   TYPE char30     VALUE 'ZQTC_F027_PAYMENT_',  " Paymnt_det of type CHAR20
              lc_soc_cust_service TYPE char30     VALUE 'ZQTC_F042_SOC_CUST_SERV_', " Cust_service of type CHAR20
*              lc_soc_cust_service TYPE char30     VALUE 'ZQTC_F027_CUST_SERVICE_',   " Cust_service of type CHAR20
*              lc_soc_bank_det     TYPE char30     VALUE 'ZQTC_F042_SOC_BANK_DET_',    " Bank details
              lc_soc_bank_det     TYPE char30     VALUE 'ZQTC_F042_BANK_DET_', " Bank details
*              lc_soc_footer       TYPE char30     VALUE 'ZQTC_F042_SOC_FOOTER_',      " Footer of type CHAR20
              lc_soc_footer       TYPE char30     VALUE 'ZQTC_F027_FOOTER_',          " Footer of type CHAR20
              lc_undscr           TYPE char1      VALUE '_',                          " Undscr of type CHAR1
              lc_scc              TYPE char3      VALUE 'SCC',                        " Scc of type CHAR3
              lc_scm              TYPE char3      VALUE 'SCM',                        " Scm of type CHAR3
              lc_css              TYPE char3      VALUE 'CSS',                        " Scm of type CHAR3
              lc_tbt              TYPE char3      VALUE 'TBT',                        " Scm of type CHAR3
              lc_vat              TYPE char3      VALUE 'VAT',                        " Vat of type CHAR3
              lc_tax              TYPE char3      VALUE 'TAX',                        " Tax of type CHAR3
              lc_gst              TYPE char3      VALUE 'GST',                        " Gst of type CHAR3
              lc_class            TYPE char5      VALUE 'ZQTC_',                      " Class of type CHAR5
              lc_devid            TYPE char5      VALUE '_F024',                      " Devid of type CHAR5
              lc_name             TYPE thead-tdname VALUE 'ZQTC_CREDIT_CARD_PAYMENT', " Name
              lc_st               TYPE thead-tdid     VALUE 'ST',                     "Text ID of text to be read
              lc_object           TYPE thead-tdobject VALUE 'TEXT'.                   "Object of text to be read

***********************************************************************************
* Subroutine to populate title text
  PERFORM f_populate_title_text USING fp_st_header
                                      fp_st_vbrk
                             CHANGING fp_v_accmngd_title
                                      fp_v_invoice_title
                                      fp_v_reprint.

*******************************************************************************
* Retrieve all the standard text names

  IF v_output_typ EQ v_outputyp_css.
* Fetch Remit to text
    CONCATENATE lc_css_remit_to
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_remit_to.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
    READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = fp_v_remit_to
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
    OR st_header-bill_country IN r_sanc_countries.
*   End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      CLEAR : fp_v_remit_to.
      CONCATENATE lc_remit_to
                  lc_undscr
                  lc_xxx
                  INTO fp_v_remit_to.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

* Populate Bank Details
    CONCATENATE lc_css_bank_det
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_bank_detail.
*   Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
    IF fp_v_remit_to CS lc_xxx OR
       st_header-bill_country IN r_sanc_countries.
      CLEAR: fp_v_bank_detail.
    ENDIF. " IF fp_v_remit_to CS lc_xxx OR
*   End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788

* Populate Customer Service details
    CONCATENATE lc_css_cust_service
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_cust_service_det.
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
*    IF st_header-comp_code IN r_vkorg_3310  AND st_header-payee_country IN r_payee_countries.
*      CLEAR fp_v_cust_service_det.
*      fp_v_cust_service_det = c_tbt_cust_serv.
*    ELSEIF  st_header-comp_code IN r_vkorg_5501 AND v_output_typ = lc_ztbt.
*      CLEAR fp_v_cust_service_det.
*      fp_v_cust_service_det = c_tbt_cust_serv.
*    ENDIF.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_service_det
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : fp_v_cust_service_det.
      CONCATENATE lc_cust_service
                  fp_st_vbrk-bukrs
                  lc_undscr
                  lc_css
                  lc_undscr
                  lc_xxx
                  INTO fp_v_cust_service_det.
      CONDENSE fp_v_cust_service_det NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

******BOC by SRBOSE for CR# 558 on 08/08/2017***********************
*    IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL.
*      CLEAR: li_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          id                      = lc_st
*          language                = st_header-language
*          name                    = lc_name
*          object                  = lc_object
*        TABLES
*          lines                   = li_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc EQ 0.
*        CLEAR lst_lines.
*        READ TABLE li_lines INTO lst_lines INDEX 1.
*        IF sy-subrc IS INITIAL.
*          REPLACE '&V_CREDIT&' WITH v_ccnum INTO lst_lines-tdline.
*          v_credit_text = lst_lines-tdline.
*        ENDIF. " IF sy-subrc IS INITIAL
*      ENDIF. " IF sy-subrc EQ 0
*    ELSEIF fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF v_paid_amt GT 0
*******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
** Populate Credit card detail
*      CONCATENATE lc_css_crd_card_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO fp_v_crdt_card_det.
*CLEAR: fp_v_crdt_card_det.
*    ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL
*
*    IF v_invoice_desc IS INITIAL. "Added by MODUTTA on 22/09/2017
** Populate Payment detail
*
*      CONCATENATE lc_css_paymnt_det
*                fp_st_vbrk-bukrs
*                lc_undscr
*                fp_st_vbrk-waerk
*           INTO fp_v_payment_detail.
*
*      CONCATENATE lc_css_crd_card_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO fp_v_crdt_card_det.
*    ELSE. " ELSE -> IF v_invoice_desc IS INITIAL
** Populate Payment detail
*
*      CONCATENATE lc_css_paymnt_det
*                 fp_st_vbrk-bukrs
*                 lc_undscr
*                 fp_st_vbrk-waerk
*            INTO fp_v_payment_detail_inv.
*
*      CONCATENATE lc_css_crd_card_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO v_crdt_card_det_inv.
*    ENDIF. " IF v_invoice_desc IS INITIAL
**      ENDIF. " IF v_invoice_desc IS INITIAL

    IF v_invoice_desc IS NOT INITIAL. "Added by SRBOSE on 27/10/2017
      CONCATENATE v_invoice_desc v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .


      CONCATENATE lc_css_paymnt_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
             INTO fp_v_payment_detail.
      CLEAR li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = fp_v_payment_detail
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          CLEAR lv_text.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF v_invoice_desc IS NOT INITIAL
* Populate Payment detail
      CONCATENATE lc_css_paymnt_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
             INTO fp_v_payment_detail.
      CLEAR li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = fp_v_payment_detail
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE lv_text v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF v_invoice_desc IS NOT INITIAL
*  ******BOC by SRBOSE for CR# 558 on 08/31/2017***********************
    IF ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_cinv AND v_ccnum IS NOT INITIAL )
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_ccrd AND v_ccnum IS NOT INITIAL ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      CLEAR: li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = lc_name
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX 1.
        IF sy-subrc IS INITIAL.
          REPLACE '&V_CREDIT&' WITH v_ccnum INTO <lst_lines>-tdline.
        ENDIF. " IF sy-subrc IS INITIAL
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ELSEIF ( fp_st_vbrk-vbtyp NOT IN r_crd )   " ELSE -> IF v_paid_amt GT 0
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_cinv )
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_ccrd ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF v_totaldue_val > 0. "Added by MODUTTA on 13/11/2017 dor JIRA# 5069
******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
* Populate Credit card detail
        CONCATENATE lc_css_crd_card_det
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
               INTO fp_v_crdt_card_det.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
        READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_crdt_card_det
                                                              BINARY SEARCH.
        IF sy-subrc NE 0
*       Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
        OR st_header-bill_country IN r_sanc_countries.
*       End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
          CLEAR : fp_v_crdt_card_det.
          CONCATENATE lc_credit_card
                      lc_undscr
                      lc_xxx
                      INTO fp_v_crdt_card_det.
        ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
*** BOC: Below READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
*        CLEAR: li_lines.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            id                      = lc_st
*            language                = st_header-language
*            name                    = fp_v_crdt_card_det
*            object                  = lc_object
*          TABLES
*            lines                   = li_lines
*          EXCEPTIONS
*            id                      = 1
*            language                = 2
*            name                    = 3
*            not_found               = 4
*            object                  = 5
*            reference_check         = 6
*            wrong_access_to_archive = 7
*            OTHERS                  = 8.
*        IF sy-subrc EQ 0.
*          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*            EXPORTING
*              it_tline       = li_lines
*            IMPORTING
*              ev_text_string = lv_text.
*          IF sy-subrc EQ 0.
*            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF. " IF sy-subrc EQ 0
*** EOC: Above READ_TEXT FM Call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
      ENDIF. " IF v_totaldue_val > 0

******BOC BY SRBOSE ON 07-MAY-2018
    ELSEIF ( fp_st_vbrk-vbtyp IN r_crd AND v_totaldue_val LE 0 )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                OR ( fp_st_vbrk-vbtyp IN r_cinv AND v_totaldue_val LE 0 )
                OR ( fp_st_vbrk-vbtyp IN r_ccrd AND v_totaldue_val LE 0 ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

      CONCATENATE lc_css_terms
          fp_st_vbrk-bukrs
          lc_undscr
          fp_st_vbrk-waerk
     INTO v_terms.

      CLEAR: li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = v_terms
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
******EOC BY SRBOSE ON 07-MAY-2018
    ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL

* Fetch Footer text
    CONCATENATE lc_css_footer
                fp_st_vbrk-bukrs
           INTO fp_v_footer.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_footer
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : fp_v_footer.
      CONCATENATE lc_footer
                  fp_st_vbrk-bukrs
                  lc_undscr
                  lc_css
                  INTO fp_v_footer.
      CONDENSE fp_v_footer NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

  ELSEIF v_output_typ EQ v_outputyp_tbt.
    v_scenario_tbt = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
* Fetch Remit to text
    CONCATENATE lc_tbt_remit_to
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_remit_to.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_remit_to
                                                          BINARY SEARCH.
    IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
    OR st_header-bill_country IN r_sanc_countries.
*   End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      CLEAR : fp_v_remit_to.
      CONCATENATE lc_remit_to
                  lc_undscr
                  lc_xxx
                  INTO fp_v_remit_to.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

* Populate Bank Details
    CONCATENATE lc_tbt_bank_det
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_bank_detail.
*   Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
    IF fp_v_remit_to CS lc_xxx OR
       st_header-bill_country IN r_sanc_countries.
      CLEAR: fp_v_bank_detail.
    ENDIF. " IF fp_v_remit_to CS lc_xxx OR
*   End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788

**** BOC by SRBOSE on 15-JAN-2018 #CR_TBD #TR:  ED2K910373
    IF v_kvgr1 EQ v_psb.
      DATA(lv_cust_serv) = lc_tbt_agency.
    ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
      lv_cust_serv = lc_tbt_cust_service.
    ENDIF. " IF v_kvgr1 EQ v_psb
**** EOC by SRBOSE on 15-JAN-2018 #CR_TBD #TR:  ED2K910373

* Populate Customer Service details
    CONCATENATE lv_cust_serv
                fp_st_vbrk-bukrs
                lc_undscr
                fp_st_vbrk-waerk
           INTO fp_v_cust_service_det.
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
    IF st_header-comp_code IN r_vkorg_3310  AND st_header-payee_country IN r_payee_countries.
      CLEAR fp_v_cust_service_det.
      fp_v_cust_service_det = c_tbt_cust_serv_3310.
    ELSEIF  st_header-comp_code IN r_vkorg_5501.
      CLEAR fp_v_cust_service_det.
      fp_v_cust_service_det = c_tbt_cust_serv_5501.
    ENDIF.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_service_det
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      IF v_kvgr1 EQ v_psb.
        DATA(lv_cust_serv1) = lc_tbt_agency1.
      ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
        lv_cust_serv1 = lc_cust_service.
      ENDIF. " IF v_kvgr1 EQ v_psb

      CLEAR : fp_v_cust_service_det.
      CONCATENATE lv_cust_serv1
                  fp_st_vbrk-bukrs
                  lc_undscr
                  lc_tbt
                  lc_undscr
                  lc_xxx
                  INTO fp_v_cust_service_det.
      CONDENSE fp_v_cust_service_det NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

********BOC by SRBOSE for CR# 558 on 08/08/2017***********************
*    IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL.
*      CLEAR: li_lines.
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          id                      = lc_st
*          language                = st_header-language
*          name                    = lc_name
*          object                  = lc_object
*        TABLES
*          lines                   = li_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc EQ 0.
*        CLEAR lst_lines.
*        READ TABLE li_lines INTO lst_lines INDEX 1.
*        IF sy-subrc IS INITIAL.
*          REPLACE '&V_CREDIT&' WITH v_ccnum INTO lst_lines-tdline.
*          v_credit_text = lst_lines-tdline.
*        ENDIF. " IF sy-subrc IS INITIAL
*      ENDIF. " IF sy-subrc EQ 0
*    ELSEIF fp_st_vbrk-vbtyp NOT IN r_crd. " ELSE -> IF v_paid_amt GT 0
*******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
** Populate Credit card detail
*      CONCATENATE lc_tbt_crd_card_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO fp_v_crdt_card_det.
*    ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL
*
*    IF v_invoice_desc IS INITIAL.
** Populate Payment detail
*      CONCATENATE lc_tbt_paymnt_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO fp_v_payment_detail.
*    ELSE. " ELSE -> IF v_invoice_desc IS INITIAL
** Populate Payment detail
*      CONCATENATE lc_tbt_paymnt_det
*                  fp_st_vbrk-bukrs
*                  lc_undscr
*                  fp_st_vbrk-waerk
*             INTO fp_v_payment_detail_inv.
*    ENDIF. " IF v_invoice_desc IS INITIAL

    IF v_invoice_desc IS NOT INITIAL. "Added by MODUTTA on 27/10/2017
      CONCATENATE v_invoice_desc v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .


      CONCATENATE lc_tbt_paymnt_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
             INTO fp_v_payment_detail.
      CLEAR li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = fp_v_payment_detail
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          CLEAR lv_text.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF v_invoice_desc IS NOT INITIAL
* Populate Payment detail
      CONCATENATE lc_tbt_paymnt_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
             INTO fp_v_payment_detail.
      CLEAR li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = fp_v_payment_detail
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE lv_text v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF v_invoice_desc IS NOT INITIAL
*  ******BOC by SRBOSE for CR# 558 on 08/31/2017***********************
    IF ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_cinv AND v_ccnum IS NOT INITIAL )
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_ccrd AND v_ccnum IS NOT INITIAL ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      CLEAR: li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = lc_name
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        READ TABLE li_lines ASSIGNING <lst_lines> INDEX 1.
        IF sy-subrc IS INITIAL.
          REPLACE '&V_CREDIT&' WITH v_ccnum INTO <lst_lines>-tdline.
        ENDIF. " IF sy-subrc IS INITIAL
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ELSEIF ( fp_st_vbrk-vbtyp NOT IN r_crd ) " ELSE -> IF v_paid_amt GT 0
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_cinv )
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_ccrd ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF v_totaldue_val > 0. "Added by MODUTTA on 13/11/2017 dor JIRA# 5069
******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
* Populate Credit card detail

        IF v_kvgr1 EQ v_psb.
          DATA(lv_credit) = lc_tbt_agency_crd.
        ELSE. " ELSE -> IF v_kvgr1 EQ v_psb
          lv_credit = lc_tbt_crd_card_det.
        ENDIF. " IF v_kvgr1 EQ v_psb

        CONCATENATE lv_credit
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
               INTO fp_v_crdt_card_det.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
        READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_crdt_card_det
                                                              BINARY SEARCH.
        IF sy-subrc NE 0
*       Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
        OR st_header-bill_country IN r_sanc_countries.
*       End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
          CLEAR : fp_v_crdt_card_det.
          CONCATENATE lc_credit_card
                      lc_undscr
                      lc_xxx
                      INTO fp_v_crdt_card_det.
        ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
*** BOC: Below READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
*        CLEAR: li_lines.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            id                      = lc_st
*            language                = st_header-language
*            name                    = fp_v_crdt_card_det
*            object                  = lc_object
*          TABLES
*            lines                   = li_lines
*          EXCEPTIONS
*            id                      = 1
*            language                = 2
*            name                    = 3
*            not_found               = 4
*            object                  = 5
*            reference_check         = 6
*            wrong_access_to_archive = 7
*            OTHERS                  = 8.
*        IF sy-subrc EQ 0.
*          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*            EXPORTING
*              it_tline       = li_lines
*            IMPORTING
*              ev_text_string = lv_text.
*          IF sy-subrc EQ 0.
*            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
*          ENDIF. " IF sy-subrc EQ 0
*        ENDIF. " IF sy-subrc EQ 0
*** EOC: Above READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
      ENDIF. " IF v_totaldue_val > 0

******BOC BY SRBOSE ON 07-MAY-2018
    ELSEIF ( fp_st_vbrk-vbtyp IN r_crd AND v_totaldue_val LE 0 )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                OR ( fp_st_vbrk-vbtyp IN r_cinv AND v_totaldue_val LE 0 )
                OR ( fp_st_vbrk-vbtyp IN r_ccrd AND v_totaldue_val LE 0 ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

      CONCATENATE lc_tbt_terms
          fp_st_vbrk-bukrs
          lc_undscr
          fp_st_vbrk-waerk
     INTO v_terms.

      CLEAR: li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = v_terms
          object                  = lc_object
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_text.
        IF sy-subrc EQ 0.
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
******EOC BY SRBOSE ON 07-MAY-2018
    ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL


* Fetch Footer text
    CONCATENATE lc_tbt_footer
                fp_st_vbrk-bukrs
           INTO fp_v_footer.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
    READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_footer
                                                          BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR : fp_v_footer.
      CONCATENATE lc_footer
                  fp_st_vbrk-bukrs
                  lc_undscr
                  lc_tbt
                  INTO fp_v_footer.
      CONDENSE fp_v_footer NO-GAPS.
    ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

  ELSEIF v_output_typ EQ v_outputyp_soc.
    IF v_scc IS NOT INITIAL.
* Fetch Remit to text
      CONCATENATE lc_soc_remit_to
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scc
             INTO fp_v_remit_to.
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_remit_to
                                                            BINARY SEARCH.
      IF sy-subrc NE 0
*     Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      OR st_header-bill_country IN r_sanc_countries.
*     End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
        CLEAR : fp_v_remit_to.
        CONCATENATE lc_remit_to
                    lc_undscr
                    lc_xxx
                    INTO fp_v_remit_to.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

* Populate Bank Details
      CONCATENATE lc_soc_bank_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scc
             INTO fp_v_bank_detail.
*     Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      IF fp_v_remit_to CS lc_xxx OR
         st_header-bill_country IN r_sanc_countries.
        CLEAR: fp_v_bank_detail.
      ENDIF. " IF fp_v_remit_to CS lc_xxx OR
*     End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788

* Populate Customer Service details
      CONCATENATE lc_soc_cust_service
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scc
             INTO fp_v_cust_service_det.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_service_det
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : fp_v_cust_service_det.
        CONCATENATE lc_cust_service
                    fp_st_vbrk-bukrs
                    lc_undscr
                    lc_scc
                    lc_undscr
                    lc_xxx
                    INTO fp_v_cust_service_det.
        CONDENSE fp_v_cust_service_det NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
******BOC by SRBOSE for CR# 558 on 08/08/2017**********************
      IF v_invoice_desc IS NOT INITIAL. "Added by MODUTTA on 27/10/2017
        CONCATENATE v_invoice_desc v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .

        CONCATENATE lc_scc_paymnt_det
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
*                    lc_undscr
*                    lc_scc
               INTO fp_v_payment_detail.
        CLEAR li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = fp_v_payment_detail
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
            CLEAR lv_text.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF v_invoice_desc IS NOT INITIAL
* Populate Payment detail
        CONCATENATE lc_scc_paymnt_det
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
*                    lc_undscr
*                    lc_scc
               INTO fp_v_payment_detail.
        CLEAR li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = fp_v_payment_detail
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE lv_text v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF v_invoice_desc IS NOT INITIAL
*  ******BOC by SRBOSE for CR# 558 on 08/31/2017***********************
      IF ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_cinv AND v_ccnum IS NOT INITIAL )
             OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_ccrd AND v_ccnum IS NOT INITIAL ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        CLEAR: li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = lc_name
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          READ TABLE li_lines ASSIGNING <lst_lines> INDEX 1.
          IF sy-subrc IS INITIAL.
            REPLACE '&V_CREDIT&' WITH v_ccnum INTO <lst_lines>-tdline.
          ENDIF. " IF sy-subrc IS INITIAL
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ELSEIF ( fp_st_vbrk-vbtyp NOT IN r_crd ) " ELSE -> IF v_paid_amt GT 0
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_cinv )
                   OR  ( fp_st_vbrk-vbtyp NOT IN r_ccrd ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF v_totaldue_val > 0. "Added by MODUTTA on 13/11/2017 dor JIRA# 5069
******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
* Populate Credit card detail
          CONCATENATE lc_scc_crd_card_det
                      fp_st_vbrk-bukrs
                      lc_undscr
                      fp_st_vbrk-waerk
*                      lc_undscr
*                      lc_scc
                 INTO fp_v_crdt_card_det.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
          READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_crdt_card_det
                                                                BINARY SEARCH.
          IF sy-subrc NE 0
*         Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
          OR st_header-bill_country IN r_sanc_countries.
*         End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
            CLEAR : fp_v_crdt_card_det.
            CONCATENATE lc_credit_card
                        lc_undscr
                        lc_xxx
                        INTO fp_v_crdt_card_det.
          ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
*** BOC: Below READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
*          CLEAR: li_lines.
*          CALL FUNCTION 'READ_TEXT'
*            EXPORTING
*              id                      = lc_st
*              language                = st_header-language
*              name                    = fp_v_crdt_card_det
*              object                  = lc_object
*            TABLES
*              lines                   = li_lines
*            EXCEPTIONS
*              id                      = 1
*              language                = 2
*              name                    = 3
*              not_found               = 4
*              object                  = 5
*              reference_check         = 6
*              wrong_access_to_archive = 7
*              OTHERS                  = 8.
*          IF sy-subrc EQ 0.
*            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*              EXPORTING
*                it_tline       = li_lines
*              IMPORTING
*                ev_text_string = lv_text.
*            IF sy-subrc EQ 0.
*              CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
*            ENDIF. " IF sy-subrc EQ 0
*          ENDIF. " IF sy-subrc EQ 0
*** BOC: Above READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
        ENDIF. " IF v_totaldue_val > 0
******boc by srbose on 07-may-2018
      ELSEIF ( fp_st_vbrk-vbtyp IN r_crd AND v_totaldue_val LE 0 )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
                OR ( fp_st_vbrk-vbtyp IN r_cinv AND v_totaldue_val LE 0 )
                OR ( fp_st_vbrk-vbtyp IN r_ccrd AND v_totaldue_val LE 0 ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

        CONCATENATE lc_scc_terms
            fp_st_vbrk-bukrs
            lc_undscr
            fp_st_vbrk-waerk
       INTO v_terms.

        CLEAR: li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = v_terms
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
******EOC BY SRBOSE ON 07-MAY-2018
      ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL

* Fetch Footer text
      CONCATENATE lc_soc_footer
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scc
             INTO fp_v_footer.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_footer
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : fp_v_footer.
        CONCATENATE lc_footer
                    fp_st_vbrk-bukrs
                    lc_undscr
                    lc_scc
                    INTO fp_v_footer.
        CONDENSE fp_v_footer NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

    ELSEIF v_scm IS NOT INITIAL.
* fetch remit to text
      CONCATENATE lc_soc_remit_to
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scm
             INTO fp_v_remit_to.

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_remit_to
                                                            BINARY SEARCH.
      IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
    OR st_header-bill_country IN r_sanc_countries.
*   End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
        CLEAR : fp_v_remit_to.
        CONCATENATE lc_remit_to
                    lc_undscr
                    lc_xxx
                    INTO fp_v_remit_to.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

* Populate Bank Details
      CONCATENATE lc_soc_bank_det
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scm
             INTO fp_v_bank_detail.
*     Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
      IF fp_v_remit_to CS lc_xxx OR
         st_header-bill_country IN r_sanc_countries.
        CLEAR: fp_v_bank_detail.
      ENDIF. " IF fp_v_remit_to CS lc_xxx OR
*     End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788

* Populate Customer Service details
      CONCATENATE lc_soc_cust_service
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scm
             INTO fp_v_cust_service_det.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_service_det
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : fp_v_cust_service_det.
        CONCATENATE lc_cust_service
                    fp_st_vbrk-bukrs
                    lc_undscr
                    lc_scm
                    lc_undscr
                    lc_xxx
                    INTO fp_v_cust_service_det.
        CONDENSE fp_v_cust_service_det NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

******BOC by SRBOSE for CR# 558 on 08/08/2017**********************
      IF v_invoice_desc IS NOT INITIAL. "Added by MODUTTA on 27/10/2017
        CONCATENATE v_invoice_desc v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .

        CONCATENATE lc_scm_paymnt_det
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
*                    lc_undscr
*                    lc_scm
               INTO fp_v_payment_detail.
        CLEAR li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = fp_v_payment_detail
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
            CLEAR lv_text.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF v_invoice_desc IS NOT INITIAL
* Populate Payment detail
        CONCATENATE lc_scm_paymnt_det
                    fp_st_vbrk-bukrs
                    lc_undscr
                    fp_st_vbrk-waerk
*                    lc_undscr
*                    lc_scm
               INTO fp_v_payment_detail.
        CLEAR li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = fp_v_payment_detail
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE lv_text v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF v_invoice_desc IS NOT INITIAL

*  ******BOC by SRBOSE for CR# 558 on 08/31/2017***********************
      IF ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_cinv AND v_ccnum IS NOT INITIAL )
        OR ( v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_ccrd AND v_ccnum IS NOT INITIAL ) .
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        CLEAR: li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = st_header-language
            name                    = lc_name
            object                  = lc_object
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          READ TABLE li_lines ASSIGNING <lst_lines> INDEX 1.
          IF sy-subrc IS INITIAL.
            REPLACE '&V_CREDIT&' WITH v_ccnum INTO <lst_lines>-tdline.
          ENDIF. " IF sy-subrc IS INITIAL
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_text.
          IF sy-subrc EQ 0.
            CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ELSEIF ( fp_st_vbrk-vbtyp NOT IN r_crd ) " ELSE -> IF v_paid_amt GT 0
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        OR ( fp_st_vbrk-vbtyp NOT IN r_cinv )
        OR ( fp_st_vbrk-vbtyp NOT IN r_ccrd ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF v_totaldue_val > 0. "Added by MODUTTA on 13/11/2017 dor JIRA# 5069
******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
* Populate Credit card detail
          CONCATENATE lc_scm_crd_card_det
                      fp_st_vbrk-bukrs
                      lc_undscr
                      fp_st_vbrk-waerk
*                      lc_undscr
*                      lc_scm
                 INTO fp_v_crdt_card_det.
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
          READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_crdt_card_det
                                                                BINARY SEARCH.
          IF sy-subrc NE 0
*         Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
          OR st_header-bill_country IN r_sanc_countries.
*         End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
            CLEAR : fp_v_crdt_card_det.
            CONCATENATE lc_credit_card
                        lc_undscr
                        lc_xxx
                        INTO fp_v_crdt_card_det.
          ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
*** BOC: Below READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
*          CLEAR: li_lines.
*          CALL FUNCTION 'READ_TEXT'
*            EXPORTING
*              id                      = lc_st
*              language                = st_header-language
*              name                    = fp_v_crdt_card_det
*              object                  = lc_object
*            TABLES
*              lines                   = li_lines
*            EXCEPTIONS
*              id                      = 1
*              language                = 2
*              name                    = 3
*              not_found               = 4
*              object                  = 5
*              reference_check         = 6
*              wrong_access_to_archive = 7
*              OTHERS                  = 8.
*          IF sy-subrc EQ 0.
*            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*              EXPORTING
*                it_tline       = li_lines
*              IMPORTING
*                ev_text_string = lv_text.
*            IF sy-subrc EQ 0.
*              CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
*            ENDIF. " IF sy-subrc EQ 0
*          ENDIF. " IF sy-subrc EQ 0
*** EOC: Above READ_TEXT FM call is COMMENTED as aprt of: CR#7431&7189  KKRAVURI
        ENDIF. " IF v_totaldue_val > 0
******BOC BY SRBOSE ON 07-MAY-2018
        IF ( fp_st_vbrk-vbtyp IN r_crd AND v_totaldue_val LE 0 )
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
          OR ( fp_st_vbrk-vbtyp IN r_cinv AND v_totaldue_val LE 0 )
          OR ( fp_st_vbrk-vbtyp IN r_ccrd AND v_totaldue_val LE 0 ).
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

          CONCATENATE lc_scm_terms
              fp_st_vbrk-bukrs
              lc_undscr
              fp_st_vbrk-waerk
         INTO v_terms.

          CLEAR: li_lines.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = lc_st
              language                = st_header-language
              name                    = v_terms
              object                  = lc_object
            TABLES
              lines                   = li_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc EQ 0.
            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
              EXPORTING
                it_tline       = li_lines
              IMPORTING
                ev_text_string = lv_text.
            IF sy-subrc EQ 0.
              CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd AND v_totaldue_val LE 0
******EOC BY SRBOSE ON 07-MAY-2018
      ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL

* Fetch Footer text
      CONCATENATE lc_soc_footer
                  fp_st_vbrk-bukrs
                  lc_undscr
                  fp_st_vbrk-waerk
                  lc_undscr
                  lc_scm
             INTO fp_v_footer.

***BOC SRBOSE on 15-Mar-2018 for ERP_6599 TR ED2K911376
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_footer
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR : fp_v_footer.
        CONCATENATE lc_footer
                    fp_st_vbrk-bukrs
                    lc_undscr
                    lc_scm
                    INTO fp_v_footer.
        CONDENSE fp_v_footer NO-GAPS.
      ENDIF. " IF sy-subrc NE 0
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

    ENDIF. " IF v_scc IS NOT INITIAL
  ENDIF. " IF v_output_typ EQ v_outputyp_css
**********************************************************************
**********************************************************************
* Retrieve European member indicator from T005 table
  SELECT SINGLE xegld " Indicator: European Union Member?
           INTO v_ind
           FROM t005  " Countries
           WHERE land1 = st_header-bill_country.
*             AND spras = st_header-language.

* Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO fp_v_tax.

*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO fp_v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO fp_v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
********************************************************************************************************************************************
* Populate order header text
  PERFORM f_populate_header_text USING    fp_st_header.

**********************************************************************
  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = fp_st_header-language
      name                    = fp_v_tax
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_v_vat = lv_text. "ERPM-2190
*      CONCATENATE lv_text fp_st_header-doc_currency INTO fp_v_vat SEPARATED BY space. '"ERPM-2190
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

**********************************************************************
* Retrieve text module values and add with document currency value

  CLEAR : i_txtmodule,
          lst_line.
* Fetch sub-total text from text module
  PERFORM f_get_text      USING c_subtotal
                                fp_st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
*    CONCATENATE lst_line-tdline fp_st_header-doc_currency INTO fp_v_subtotal SEPARATED BY space. "Commeneted by NRMODUGU ERPM-2190
    MOVE lst_line-tdline TO fp_v_subtotal.
    CONDENSE fp_v_subtotal.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line


  CLEAR : i_txtmodule,
          lst_line.
* Fetch Total due text from text module
  PERFORM f_get_text      USING c_totaldue
                                fp_st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
    "    CONCATENATE lst_line-tdline fp_st_header-doc_currency INTO fp_v_totaldue SEPARATED BY space. " Commeneted by NRMODUGU ERPM-2190
    MOVE lst_line-tdline TO fp_v_totaldue .  " Added by NRMODUGU ERPM-2190
    CONDENSE fp_v_totaldue.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line

  CLEAR : i_txtmodule,
          lst_line.
* Fetch prepaid amount text from text module
  PERFORM f_get_text      USING c_prepaidamt
                                fp_st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
    "    CONCATENATE lst_line-tdline fp_st_header-doc_currency INTO fp_v_prepaidamt SEPARATED BY space. "Commeneted by NRMODUGU ERPM-2190
    MOVE lst_line-tdline TO fp_v_prepaidamt. "Added by NRMODUGU ERPM-2190
    CONDENSE fp_v_prepaidamt.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line

  CLEAR : i_txtmodule,
          lst_line.
* Fetch Shipping text from text module
  PERFORM f_get_text      USING c_shipping
                                fp_st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
*    CONCATENATE lst_line-tdline fp_st_header-doc_currency INTO fp_v_shipping SEPARATED BY space. ""Commeneted by NRMODUGU ERPM-2190
    MOVE lst_line-tdline TO fp_v_shipping.
    CONDENSE fp_v_shipping.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line

**********************************************************************
* Commented out as address should come as standard functionality
** Populate country name if bill to country and ship to country same
*  IF st_header-bill_country EQ st_header-ship_country.
*
**   Retrieve Bill to country name(text)
*    SELECT SINGLE landx " Country Name
*           FROM   t005t " Country Names
*           INTO fp_v_country_key
*           WHERE spras = fp_st_header-language
*             AND land1 = fp_st_header-bill_country.
*    IF sy-subrc NE 0.
*      CLEAR fp_v_country_key .
*    ENDIF. " IF sy-subrc NE 0
*  ENDIF. " IF st_header-bill_country EQ st_header-ship_country
***********************************************************************

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_TITLE_TEXT
*&---------------------------------------------------------------------*
* Subroutine to populate text for layout heading
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER           Header Detail
*      -->FP_ST_VBRK             VBRK straucture
*      <--FP_FP_V_ACCMNGD_TITLE  Title text
*----------------------------------------------------------------------*
FORM f_populate_title_text  USING    fp_st_header          TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                                     fp_st_vbrk            TYPE ty_vbrk
                            CHANGING fp_v_accmngd_title    TYPE char255                   " V_accmngd_title of type CHAR255
                                     fp_v_invoice_title    TYPE char255                   "(++SRBOSE CR_618)
                                     fp_v_reprint          TYPE char255.                  " V_reprint of type CHAR255

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.

  IF fp_st_vbrk-vkorg NOT IN r_country. "Added by MODUTTA for JIRA# 4713 on 31/10/2017
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
    IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz.
      PERFORM f_read_text    USING c_name_vkorg
                           CHANGING v_title.

    ENDIF. " IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
  ENDIF. " IF fp_st_vbrk-vkorg NOT IN r_country
* Begin of ADD:ERP-7462:SGUDA:17-SEP-2018:ED2K913365
  IF v_title IS INITIAL AND v_aust_text IS NOT INITIAL.
    PERFORM f_read_text    USING c_tax_invoice
                         CHANGING v_title.
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*  ELSEIF v_title IS INITIAL.
*    IF fp_st_vbrk-vkorg EQ v_vkorg AND fp_st_header-ship_country IN r_ship_to_country.
*      IF fp_st_vbrk-fkart IN r_billing_type_zf2.
*        PERFORM f_read_text    USING c_tax_invoice
*                             CHANGING v_title.
*      ELSEIF fp_st_vbrk-fkart IN r_billing_type_zcr.
*        PERFORM f_read_text    USING c_tax_credit
*                             CHANGING v_title.
*      ENDIF.
*    ENDIF.
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
  ENDIF.
* End of ADD:ERP-7462:SGUDA:17-SEP-2018:ED2K913365
*  IF fp_st_vbrk-fkart IN r_inv.  " (--) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
  IF fp_st_vbrk-vbtyp IN r_inv. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208

* If company code Australia or Singapore, then populate tax invoice as title
    IF fp_st_header-comp_code  IN r_country.

      IF fp_st_header-bill_country EQ fp_st_header-ship_country.

        PERFORM f_read_text    USING c_name_tax_inv
                            CHANGING fp_v_accmngd_title.

      ELSE. " ELSE -> IF fp_st_header-bill_country EQ fp_st_header-ship_country
*   Fetch title text for invoice

        PERFORM f_read_text    USING c_name_inv
                            CHANGING fp_v_accmngd_title.

      ENDIF. " IF fp_st_header-bill_country EQ fp_st_header-ship_country

    ELSE. " ELSE -> IF fp_st_header-comp_code IN r_country
*   Fetch title text for invoice
      PERFORM f_read_text    USING c_name_inv
                          CHANGING fp_v_accmngd_title.

    ENDIF. " IF fp_st_header-comp_code IN r_country

*     *Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
*    IF fp_st_vbrk-fkart EQ v_faz.
*      PERFORM f_read_text    USING "c_name_faz (-- SRBOSE on 10-Oct-2017 for CR_618: TR: ED2K908908)
*                                    c_name_inv "(++SRBOSE on 10-Oct-2017 for CR_618: TR: ED2K908908)
*                           CHANGING fp_v_accmngd_title.
*    ENDIF. " IF fp_st_vbrk-fkart EQ v_faz "" Commented by SRBOSE for CR_666
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591

*  ELSEIF fp_st_vbrk-fkart IN r_crd.  " (--) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
  ELSEIF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*   If company code Australia or Singapore, then populate tax credit as title
    IF fp_st_header-comp_code IN r_country.

      IF fp_st_header-bill_country EQ fp_st_header-ship_country.
        PERFORM f_read_text    USING c_name_tax_crd
                            CHANGING fp_v_accmngd_title.
      ELSE. " ELSE -> IF fp_st_header-bill_country EQ fp_st_header-ship_country
*   Fetch title text for credit memo
        PERFORM f_read_text    USING c_name_crd
                            CHANGING fp_v_accmngd_title.
      ENDIF. " IF fp_st_header-bill_country EQ fp_st_header-ship_country

    ELSE. " ELSE -> IF fp_st_header-comp_code IN r_country
*   Fetch title text for invoice
      PERFORM f_read_text    USING c_name_crd
                          CHANGING fp_v_accmngd_title.
    ENDIF. " IF fp_st_header-comp_code IN r_country

*  ELSEIF fp_st_vbrk-fkart IN r_dbt.   " (--) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
  ELSEIF fp_st_vbrk-vbtyp IN r_dbt. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208

    PERFORM f_read_text    USING c_name_dbt
                        CHANGING fp_v_accmngd_title.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_inv


* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  IF fp_st_vbrk-vbtyp IN r_cinv.
    PERFORM f_read_text USING c_name_tax_crd    "Tax Credit" when Invoice is cancelled
                        CHANGING fp_v_accmngd_title.
  ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.
    PERFORM f_read_text USING c_name_tax_inv    "Tax INvoice" when Credit memo is cancelled
                      CHANGING fp_v_accmngd_title.
  ENDIF.

  IF st_vbrk-vbtyp IN r_cinv OR st_vbrk-vbtyp IN r_ccrd.  " Display the original document againt the canceled document
    PERFORM f_read_text    USING c_org_doc
                           CHANGING v_org_doc.
  ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

  IF v_proc_status EQ '1'.

    PERFORM f_read_text    USING c_name_reprnt
                        CHANGING fp_v_reprint.

  ENDIF. " IF v_proc_status EQ '1'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_TEXT
*&---------------------------------------------------------------------*
* Subroutine for Read text
*----------------------------------------------------------------------*
*      -->FP_C_NAME_TAX_INV  text
*      <--FP_FP_V_ACCMNGD_TITLE  text
*----------------------------------------------------------------------*
FORM f_read_text  USING    fp_c_name   TYPE thead-tdname " Name
                  CHANGING fp_v_value  TYPE char255.     " V_accmngd_title of type CHAR255

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_c_name
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      fp_v_value = lv_text.
      CONDENSE fp_v_value.
    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT
*&---------------------------------------------------------------------*
*  Get text values from
*----------------------------------------------------------------------*
*      -->FP_C_TOTALDUE   Smart Forms: Form Name
*      -->FP_ST_HEADER    Structure for Header detail of invoice form
*      <--FP_I_TXTMODULE  Text module store table
*----------------------------------------------------------------------*
FORM f_get_text  USING    fp_c_textname     TYPE tdsfname                  " Smart Forms: Form Name
                          fp_st_header      TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                 CHANGING fp_i_txtmodule    TYPE tsftext.

  DATA : lst_langu TYPE ssfrlang. " Language Key

  lst_langu-langu1 = fp_st_header-language.

* Function Module to fetch text value
  CALL FUNCTION 'SSFRT_READ_TEXTMODULE' "
    EXPORTING
      i_textmodule       = fp_c_textname  " tdsfname
      i_languages        = lst_langu      " ssfrlang
    IMPORTING
      o_text             = fp_i_txtmodule " tsftext
    EXCEPTIONS
      error              = 1                   "
      language_not_found = 2.      "
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_HEADER_TEXT
*&---------------------------------------------------------------------*
*  Populate header text
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER    Header Structure
*      <--FP_FP_ST_HEADER Header Text
*----------------------------------------------------------------------*
FORM f_populate_header_text  USING    fp_st_header  TYPE zstqtc_header_detail_f042. " Structure for Header detail of invoice form

* Constant declaration
  CONSTANTS : lc_object TYPE tdobject VALUE 'VBBK',               " Texts: Application Object
              lc_text   TYPE tdobject VALUE 'TEXT',               " Texts: Application Object
              lc_id     TYPE tdid     VALUE '0007',               " Text ID
              lc_name   TYPE tdobname VALUE 'ZQTC_F042_COMMENTS', " Name
              lc_st     TYPE tdid     VALUE 'ST'.                 " Text ID

* Data declaration
  DATA : li_lines       TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
         li_lines_cmt   TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
         lv_text        TYPE string,
         lv_text_cmt    TYPE string,
         lv_wrdwrp      TYPE char300,                 " Wrdwrp of type CHAR300
         lv_name        TYPE tdobname,                " Name
         lv_first_text  TYPE char100,                 " First_text of type Character
         lv_second_text TYPE char100,                 " Second_text of type Character
         lv_third_text  TYPE char100,                 " Third_text of type Character
         lst_tax_item   TYPE zstqtc_tax_item_f042.    " Structure for tax components

* Get Text name
  lv_name = fp_st_header-invoice_number.

  CLEAR : li_lines,
          li_lines_cmt,
          lv_text_cmt,
          lv_text.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = fp_st_header-language
      name                    = lc_name
      object                  = lc_text
    TABLES
      lines                   = li_lines_cmt
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF sy-subrc EQ 0.
*   Get the Text value into string
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines_cmt
      IMPORTING
        ev_text_string = lv_text_cmt.
    CONDENSE lv_text_cmt.
  ENDIF. " IF sy-subrc EQ 0

* Use FM to retrieve header text value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_id
      language                = fp_st_header-language
      name                    = lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF sy-subrc EQ 0.
*   Get the Text value into string
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.

    IF sy-subrc EQ 0.
      lv_wrdwrp = lv_text.
*     Divide the text value in 100 words
      CALL FUNCTION 'RKD_WORD_WRAP'
        EXPORTING
          textline            = lv_wrdwrp
          delimiter           = space
          outputlen           = 100
        IMPORTING
          out_line1           = lv_first_text
          out_line2           = lv_second_text
          out_line3           = lv_third_text
        EXCEPTIONS
          outputlen_too_large = 1
          OTHERS              = 2.
      IF sy-subrc EQ 0.
***        BOC by SRBOSE on 18/10/2017 for CR# 666
*        fp_st_header-first_text_line  = lv_first_text. " First line of 100 words
*        fp_st_header-second_text_line = lv_second_text. " Second line of 100 words
*        fp_st_header-third_text_line  = lv_third_text. " Third line of 100 words
        IF lv_first_text IS NOT INITIAL.
*          lst_tax_item-media_type = lv_first_text.
          CONCATENATE lv_text_cmt lv_first_text INTO lst_tax_item-media_type.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_first_text IS NOT INITIAL

        IF lv_second_text IS NOT INITIAL.
          lst_tax_item-media_type = lv_second_text.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_second_text IS NOT INITIAL

        IF lv_third_text IS NOT INITIAL.
          lst_tax_item-media_type = lv_third_text.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_third_text IS NOT INITIAL
***        EOC by SRBOSE on 18/10/2017 for CR# 666
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_CSS
*&---------------------------------------------------------------------*
* Subroutine to populate CSS layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_css.

  DATA: li_output TYPE ztqtc_output_supp_retrieval.
* Retrieve Item text name
  PERFORM f_get_item_text_name CHANGING i_item_text.

* Populate final item table for CSS
  PERFORM f_populate_css_item   USING  st_vbrk
                                       i_vbrp
                                       i_item_text
                              CHANGING i_final_css
                                       i_subtotal
                                       v_paid_amt.
****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch texts for layout
  PERFORM f_fetch_title_text   USING st_vbrk
                                     r_country
                            CHANGING st_header
                                     v_accmngd_title
                                     v_invoice_title "(++SRBOSE CR_618)
                                     v_reprint
                                     v_tax
                                     v_remit_to
                                     v_footer
                                     v_bank_detail
                                     v_crdt_card_det
                                     v_payment_detail
                                     v_cust_service_det
                                     v_totaldue
                                     v_subtotal
                                     v_prepaidamt
                                     v_vat
                                     v_shipping
                                     v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069

**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD

* For total due amount less than equal 0, title will be receipt
  IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
*     Subroutine to fetch text value of receipt
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227

* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
    v_receipt_flag = abap_true.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
*   Always dispaly 0 as total due for less than equal 0 amount
    CLEAR: v_totaldue_val, st_header-terms.
*    CLEAR : v_payment_detail, v_crdt_card_det.
    CLEAR v_crdt_card_det.
  ENDIF. " IF v_totaldue_val LE 0

*** BOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
  IF r_bill_doc_type[] IS NOT INITIAL AND
     st_vbrk-fkart IN r_bill_doc_type.
    v_receipt_flag = abap_true.
  ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181120  ED2K913896

* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
* Fetch barcode
* Below IF condition is added to fix the INC0258568 issue
  IF v_receipt_flag <> abap_true.  " ADD:INC0258568:KKRAVURI:18-Sep-2019
    PERFORM f_populate_barcode.
  ENDIF.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809

***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
  PERFORM f_populate_exc_tab.
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
  IF st_header-bill_type IN r_currency_country  AND st_header-bill_country IN r_bill_doc_type_curr.
    CLEAR i_exc_tab[].
  ENDIF.
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
* Subroutine to populate layout.
  v_formname = c_css_form.

  PERFORM f_populate_layout USING v_formname.

* If email id is maintained, then send PDF as attachment to the mail address
  IF i_emailid[] IS NOT INITIAL
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
 AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
    PERFORM f_send_mail_attach USING v_formname.
  ENDIF. " IF i_emailid[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH
*&---------------------------------------------------------------------*
* Subroutine for mail attachment
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_mail_attach USING  fp_v_formname TYPE fpname. " Name of Form Object.

* Local data declaration
  DATA: li_output           TYPE ztqtc_output_supp_retrieval,
        lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_form_name        TYPE syst_msgv,       " Name of Form Object "Added by MODUTTA
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_msgnr_165 TYPE sy-msgno VALUE '165',     " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',     " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2', " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.       " ABAP System Field: Message Type

  IF v_ent_retco IS NOT INITIAL.
    RETURN.
  ENDIF. " IF v_ent_retco IS NOT INITIAL
  IF st_formoutput-pdf IS INITIAL.
    lst_sfpoutputparams-getpdf = abap_true.
    lst_sfpoutputparams-nodialog = abap_true.
    lst_sfpoutputparams-preview = abap_false.

    lv_form_name = fp_v_formname. "Added by MODUTTA to fix dump

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_sfpoutputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc IS NOT INITIAL.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = sy-msgid
          msg_nr                 = sy-msgno
          msg_ty                 = sy-msgty
          msg_v1                 = sy-msgv1
          msg_v2                 = sy-msgv2
          msg_v3                 = sy-msgv3
          msg_v4                 = sy-msgv4
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.
      IF sy-subrc NE 0.
*     Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_ent_retco = 900.
      RETURN.
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = fp_v_formname
            IMPORTING
              e_funcname = lv_funcname.

        CATCH cx_fp_api_usage INTO lr_err_usg.
          lr_text = lr_err_usg->get_text( ).
        CATCH cx_fp_api_repository INTO lr_err_rep.
          lr_text = lr_err_rep->get_text( ).
        CATCH cx_fp_api_internal INTO lr_err_int.
          lr_text = lr_err_int->get_text( ).
          IF lr_text IS NOT INITIAL.
            CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
              EXPORTING
                msg_arbgb              = lc_msgid
                msg_nr                 = lc_msgnr_166
                msg_ty                 = lc_err
              EXCEPTIONS
                message_type_not_valid = 1
                no_sy_message          = 2
                OTHERS                 = 3.
            .
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF lr_text IS NOT INITIAL
      ENDTRY.
**********************************************************************
      IF fp_v_formname EQ c_css_form.
* Call function module to generate CSS detail
        CALL FUNCTION lv_funcname                " /1BCDWB/SM00000093'
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_item_css             = i_final_css
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_shipping           = v_shipping
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
            im_v_shipping_val       = v_shipping_val
            im_society_logo         = v_society_logo
            im_v_society_text       = v_society_text
            im_v_reprint            = v_reprint
            im_v_seller_reg         = v_seller_reg
            im_v_credit_text        = v_credit_text
            im_country_uk           = v_country_uk
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_terms_text           = i_terms_text
*         Begin of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_terms_cond           = v_terms_cond
*         End   of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
            im_v_ind_text           = v_ind_text
            im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
            im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
            im_v_receipt_flag       = v_receipt_flag
            im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.

      ELSEIF fp_v_formname EQ c_tbt_form.
* Call function module to generate TBT detail
        CALL FUNCTION lv_funcname                " /1BCDWB/SM00000094'
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
            im_society_logo         = v_society_logo
            im_item_tbt             = i_final_tbt
            im_v_society_text       = v_society_text
            im_v_reprint            = v_reprint
            im_v_seller_reg         = v_seller_reg
            im_v_credit_text        = v_credit_text
            im_country_uk           = v_country_uk
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_terms_text           = i_terms_text
*         Begin of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_terms_cond           = v_terms_cond
*         End   of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
            im_v_ind_text           = v_ind_text
            im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
            im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
            im_v_receipt_flag       = v_receipt_flag
            im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.

      ELSEIF fp_v_formname EQ c_soc_form.
* Call function module to generate Society detail
        CALL FUNCTION lv_funcname                " /1BCDWB/SM00000095'
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt " v_prepaid_amount
            im_society_logo         = v_society_logo
            im_v_society_text       = v_society_text
            im_item_society         = i_final_soc
            im_v_reprint            = v_reprint
            im_v_seller_reg         = v_seller_reg
            im_v_credit_text        = v_credit_text
            im_country_uk           = v_country_uk
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_terms_text           = i_terms_text
*         Begin of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_terms_cond           = v_terms_cond
*         End   of ADD:ERP-5115:WROY:14-Nov-2017:ED2K909460
            im_v_aust_text          = v_aust_text "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD erp-7543 & 7459 sguda 18-sep-2018 ed2k913375
            im_v_ind_text           = v_ind_text
            im_v_tax_expt           = v_tax_expt
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
            im_exc_tab              = i_exc_tab
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
            im_v_receipt_flag       = v_receipt_flag
            im_v_barcode            = v_barcode
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.
      ENDIF. " IF fp_v_formname EQ c_css_form
**********************************************************************
      IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*       Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*         Nothing to do
          ENDIF. " IF sy-subrc NE 0
          v_ent_retco = 900.
          RETURN.
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF. " IF st_formoutput-pdf IS INITIAL
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
  IF st_formoutput-pdf IS INITIAL.
*   Message: Error occurred generating PDF file
    MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb              = sy-msgid
        msg_nr                 = sy-msgno
        msg_ty                 = sy-msgty
        msg_v1                 = sy-msgv1
        msg_v2                 = sy-msgv2
        msg_v3                 = sy-msgv3
        msg_v4                 = sy-msgv4
      EXCEPTIONS
        message_type_not_valid = 1
        no_sy_message          = 2
        OTHERS                 = 3.
    IF sy-subrc NE 0.
*     Nothing to do
    ENDIF. " IF sy-subrc NE 0
    v_ent_retco = 900.
    RETURN.
  ENDIF. " IF st_formoutput-pdf IS INITIAL
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.

* Subroutine to send mail attachment
  PERFORM f_mail_attachment.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_TBT
*&---------------------------------------------------------------------*
* Subroutine to populate TBT layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_tbt.
  DATA: li_output TYPE ztqtc_output_supp_retrieval.
* Populate final item table for TBT
  PERFORM f_populate_tbt_item   USING  st_vbrk
                                       i_vbrp
                                       i_jptidcdassign
                                       i_mara
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                       i_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                              CHANGING i_final_tbt
                                       i_subtotal
                                       v_paid_amt.

****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch texts for layout
  PERFORM f_fetch_title_text   USING st_vbrk
                                     r_country
                            CHANGING st_header
                                     v_accmngd_title
                                     v_invoice_title "(++SRBOSE CR_618)
                                     v_reprint
                                     v_tax
                                     v_remit_to
                                     v_footer
                                     v_bank_detail
                                     v_crdt_card_det
                                     v_payment_detail
                                     v_cust_service_det
                                     v_totaldue
                                     v_subtotal
                                     v_prepaidamt
                                     v_vat
                                     v_shipping
                                     v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069
**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD
*- Begin of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
  IF  ( st_vbrk-vbtyp IN r_doc_type AND st_vbrk-zlsch IN r_pay_method ) AND v_receipt_flag IS INITIAL.
    PERFORM get_accounting_doc_clear.
    IF st_bseg[] IS NOT INITIAL.
      v_receipt_flag = abap_true.
      PERFORM f_read_text    USING c_name_receipt
                  CHANGING v_accmngd_title.
    ELSE.
      CLEAR v_totaldue_val.
      v_totaldue_val = v_subtotal_val + v_sales_tax.
      CLEAR v_paid_amt.
    ENDIF.
  ELSE.
*- End of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
* For total due amount less than equal 0, title will be receipt
    IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
      IF st_header-credit_flag IS INITIAL AND
         st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
*     Subroutine to fetch text value of receipt
        PERFORM f_read_text    USING c_name_receipt
                            CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
      ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
      v_receipt_flag = abap_true.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
*   Always dispaly 0 as total due for less than equal 0 amount
      CLEAR: v_totaldue_val, st_header-terms.
*    CLEAR : v_payment_detail, v_crdt_card_det.
      CLEAR v_crdt_card_det.
    ENDIF. " IF v_totaldue_val LE 0
  ENDIF. "ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
*** BOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
  IF r_bill_doc_type[] IS NOT INITIAL AND
     st_vbrk-fkart IN r_bill_doc_type.
    v_receipt_flag = abap_true.
  ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181120  ED2K913896

* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
* Fetch barcode
* Below IF condition is added to fix the INC0258568 issue
  IF v_receipt_flag <> abap_true.  " ADD:INC0258568:KKRAVURI:18-Sep-2019
    PERFORM f_populate_barcode.
  ENDIF.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809

***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
  PERFORM f_populate_exc_tab.
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
  IF st_header-bill_type IN r_currency_country  AND st_header-bill_country IN r_bill_doc_type_curr.
    CLEAR i_exc_tab[].
  ENDIF.
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952

* Subroutine to populate layout.
  v_formname = c_tbt_form.
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
  IF  ( v_formname = c_tbt_form ) OR ( v_formname = c_soc_form ).
    CLEAR i_output[].
    PERFORM f_call_fm_output_supp USING i_input
                                  CHANGING i_output.
  ENDIF.
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
  PERFORM f_populate_layout USING v_formname.
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* Begin of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425

*  PERFORM f_call_fm_output_supp USING i_input
*                           CHANGING li_output.
* End   of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* If email id is maintained, then send PDF as attachment to the mail address
  IF i_emailid[] IS NOT INITIAL
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
 AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
    PERFORM f_send_mail_attach USING v_formname.
  ENDIF. " IF i_emailid[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_TBT_ITEM
*&---------------------------------------------------------------------*
*  Populate final item table for TBT
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      -->FP_I_VBRP  text
*      -->FP_I_MARA  text
*      -->FP_I_JPTIDCDASSIGN  text
*      <--FP_I_FINAL_TBT  text
*----------------------------------------------------------------------*
FORM f_populate_tbt_item  USING    fp_st_vbrk           TYPE ty_vbrk
                                   fp_i_vbrp            TYPE tt_vbrp
                                   fp_i_jptidcdassign   TYPE tt_jptidcdassign
                                   fp_i_mara            TYPE tt_mara
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                                   fp_i_makt            TYPE tt_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                          CHANGING fp_i_final_tbt       TYPE ztqtc_item_detail_tbt_f042
                                   fp_i_subtotal        TYPE ztqtc_subtotal_f042
                                   fp_v_paid_amt        TYPE autwr. " Payment cards: Authorized amount

* Data declaration
  DATA : lv_fees            TYPE kzwi1,                       " Subtotal 1 from pricing procedure for condition
         lv_disc            TYPE kzwi5,                       " Subtotal 5 from pricing procedure for condition
         lv_tax             TYPE kzwi6,                       " Subtotal 6 from pricing procedure for condition
         lv_total           TYPE kzwi5,                       " Subtotal 5 from pricing procedure for condition
         lv_total_val       TYPE kzwi6,                       " Subtotal 6 from pricing procedure for condition
         lv_due             TYPE kzwi2,                       " Subtotal 2 from pricing procedure for condition
         lv_year            TYPE char30,                      " Year
         lv_volum           TYPE char30,                      " Volume
         lv_vol             TYPE char8,                       " Volume
         lv_flag_di         TYPE char1,                       " Flag_di of type CHAR1
         lv_flag_ph         TYPE char1,                       " Flag_ph of type CHAR1
         lv_issue           TYPE char30,                      " Issue
         lv_name            TYPE thead-tdname,                " Name
         lv_name_issn       TYPE thead-tdname,                " Name
         lv_identcode       TYPE char20,                      " Identcode of type CHAR20
         lv_identcode_zjcd  TYPE char20,                      " Identcode of type CHAR20
         lv_pnt_issn        TYPE char30,                      " Print ISSN
         lst_final_tbt      TYPE zstqtc_item_detail_tbt_f042, " Structure for CSS Item table
         lv_taxable_amt     TYPE kzwi1,                       " Subtotal 1 from pricing procedure for condition
         lv_tax_amount      TYPE p DECIMALS 3,                " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                       " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                       " Rate (condition amount or percentage)
         lst_tax_item_final TYPE zstqtc_tax_item_f042.        " Structure for tax components

* Constant Declaration
  CONSTANTS: lc_year         TYPE thead-tdname VALUE 'ZQTC_YEAR_F024',                  " Name
             lc_volume       TYPE thead-tdname VALUE 'ZQTC_VOLUME_F042',                " Name
             lc_stvolume     TYPE thead-tdname VALUE 'ZQTC_STARTVOLUME_F042',           " Name
             lc_stissue      TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',            " Name
             lc_mlsubs       TYPE thead-tdname VALUE 'ZQTC_MSUBS_F042',                 " Name
             lc_pntissn      TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',            " Name
             lc_digissn      TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',          " Name
             lc_combissn     TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042',         " Name
             lc_eissn        TYPE thead-tdname VALUE 'ZQTC_EISSN_F042',                 " Name
             lc_issue        TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',                 " Name
             lc_digt_subsc   TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
             lc_prnt_subsc   TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
             lc_comb_subsc   TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
*            Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
             lc_sub_ref_id   TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*            End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
             lc_shipping     TYPE tdobname VALUE 'ZQTC_F024_SHIPPING', " Name
             lc_text_id      TYPE tdid     VALUE 'ST',                 " Text ID
             lc_digital      TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',  " Name
             lc_print        TYPE tdobname VALUE 'ZQTC_F024_PRINT',    " Name
             lc_mixed        TYPE tdobname VALUE 'ZQTC_F024_MIXED',    " Name
             lc_first        TYPE char1 VALUE '(',                     " First of type CHAR1
             lc_second       TYPE char1 VALUE ')',                     " Second of type CHAR1
*** BOC BY NPALLA on 11-JUNE-2019 for CR-7282 - ED1K910333
             lc_000000       TYPE posnr_va VALUE '000000',             " Initial Item No. (VEDA Header)
*** EOC BY NPALLA on 11-JUNE-2019 for CR-7282 - ED1K910333
*** BOC BY MMUKHERJEE on 22-JAN-2018 for CR-XXX
             lc_idcodetype_1 TYPE rvari_vnam VALUE 'IDCODETYPE_1', " ABAP: Name of Variant Variable
             lc_idcodetype_2 TYPE rvari_vnam VALUE 'IDCODETYPE_2', " ABAP: Name of Variant Variable
             lc_kvgr1        TYPE rvari_vnam VALUE 'KVGR1'.        " ABAP: Name of Variant Variable
*** EOC BY SAYANDAS on 22-JAN-2018 for CR-XXX

*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
  DATA: li_tkomvd     TYPE STANDARD TABLE OF komvd, " Price Determination Communication-Cond.Record for Printing
        lst_komk      TYPE komk,                    " Communication Header for Pricing
*       Begin of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
        lv_kbetr_desc TYPE p DECIMALS 3, " Rate (condition amount or percentage)
*       End   of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
        lv_kbetr_char TYPE char15,               " Kbetr_char of type CHAR15
        lst_komp      TYPE komp,                 " Communication Item for Pricing
        li_vbrp       TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
        lv_doc_line   TYPE /idt/doc_line_number, "(++)SRBOSE on 08/08/2017 for CR#408
        lv_buyer_reg  TYPE char255.              "(++)SRBOSE on 08/08/2017 for CR#408
  DATA : li_lines          TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text           TYPE string,
         lv_ind            TYPE xegld,                   " Indicator: European Union Member?
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         lv_mat_text       TYPE string,
         lv_tdname         TYPE thead-tdname, " Name
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
*Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
         lv_sub_ref_id     TYPE char255, " Sub Ref ID
*End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
         lst_line          TYPE tline,                       " SAPscript: Text Lines
         lv_posnr          TYPE posnr,                       " Subtotal 2 from pricing procedure for condition
         lst_lines         TYPE tline,                       " SAPscript: Text Lines
         lst_subtotal      LIKE LINE OF i_subtotal,
         lv_text_id        TYPE tdid,                        " Text ID
         lst_tax_item      TYPE ty_tax_item,
         li_tax_item       TYPE tt_tax_item,
         lst_final_space   TYPE zstqtc_item_detail_tbt_f042, " Structure for Item table.
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
         lst_input         TYPE zstqtc_supplement_ret_input, " Input Paramter for E098 Supplement retrieval
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
         lst_jptidcdassign TYPE ty_jptidcdassign,
         lv_issue_desc     TYPE tdline, " Text Line
         lv_text_tax       TYPE string,
         lv_mlsub          TYPE char30, " Mlsub of type CHAR30
*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bhf            TYPE char1, " Bhf of type CHAR1
         lv_lcf            TYPE char1, " Lcf of type CHAR1
         li_vbrp_tmp1      TYPE tt_vbrp,
         li_vbrp_tmp2      TYPE tt_vbrp,
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bom_hdr_flg    TYPE xfeld. "Added by MODUTTA on 05/17/18 for INC0194372

*  Constant Declaration
  CONSTANTS:lc_undscr   TYPE char1      VALUE '_',           " Undscr of type CHAR1
            lc_vat      TYPE char3      VALUE 'VAT',         " Vat of type CHAR3
            lc_tax      TYPE char3      VALUE 'TAX',         " Tax of type CHAR3
            lc_gst      TYPE char3      VALUE 'GST',         " Gst of type CHAR3
            lc_class    TYPE char5      VALUE 'ZQTC_',       " Class of type CHAR5
            lc_devid    TYPE char5      VALUE '_F024',       " Devid of type CHAR5
            lc_colon    TYPE char1      VALUE ':',           " Colon of type CHAR1
            lc_minus    TYPE char1      VALUE '-',           " Colon of type CHAR1
            lc_comma    TYPE char1      VALUE ',',           " Comma of type CHAR1
            lc_percent  TYPE char1      VALUE '%',           " Percentage of type CHAR1
            lc_hyphen   TYPE char1      VALUE '-',           " Hyphen of type CHAR1
            lc_tax_text TYPE tdobname VALUE 'ZQTC_TAX_F024'. " Name

  IF i_iss_vol2 IS NOT INITIAL.
* Begin of Change DEL:INC0216814:04/12/2018:NPOLINA:ED1K909026
*    SORT i_iss_vol2 BY matnr.
* End of Change DEL:INC0216814:04/12/2018:NPOLINA:ED1K909026
* Begin of Change DEL:INC0216814:04/12/2018:NPOLINA:ED1K909026
    SORT i_iss_vol2 BY posnr matnr.
* End of Change DEL:INC0216814:04/12/2018:NPOLINA:ED1K909026
  ENDIF. " IF i_iss_vol2 IS NOT INITIAL

  lst_komk-belnr = fp_st_vbrk-vbeln.
  lst_komk-knumv = fp_st_vbrk-knumv.

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
  li_vbrp_tmp1[] = fp_i_vbrp[].
  li_vbrp_tmp2[] = fp_i_vbrp[].
  SORT li_vbrp_tmp2 BY posnr DESCENDING.
  DELETE li_vbrp_tmp2 WHERE uepos IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp2 COMPARING uepos.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description

  li_vbrp = fp_i_vbrp.
  DELETE li_vbrp WHERE uepos IS INITIAL.

  DATA(li_tax_data) = i_tax_data.
** Begin of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
*  SORT li_tax_data BY document doc_line_number.
  SORT li_tax_data BY seller_reg.
** End of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.
  SORT li_tax_data BY document doc_line_number. "INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

*---------Cust VAT---------------------------------------------------*
  DATA(li_tax_temp) = i_tax_data.
  DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
  SORT li_tax_temp BY buyer_reg.
  DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
  DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
  IF lv_tax_line EQ 1.
    READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
    IF sy-subrc EQ 0.
      st_header-buyer_reg = lst_tax_temp-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_tax_line EQ 1
*--------------------------------------------------------------------*
* Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD


***BOC by SRBOSE on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kawrt IS INITIAL. "Commented by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
***EOC by SRBOSE on 17/10/2017 for CR#666
*End of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp).

    DATA(lv_tabix_space) = sy-tabix.
    READ TABLE fp_i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
    ENDIF. " IF sy-subrc EQ 0

***For BOM component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      lv_bom_hdr_flg = abap_true. "Added by MODUTTA on 05/17/18 for INC0194372
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
*    IF lst_tax_item-taxable_amt IS NOT INITIAL."Commented by MODUTTA on 05/17/18 for INC0194372
    IF lv_bom_hdr_flg IS INITIAL. "Added by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lv_bom_hdr_flg IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
    CLEAR: lv_bom_hdr_flg. "Added by MODUTTA on 05/17/18 for INC0194372
***EOC by MODUTTA for CR_743

    IF lst_vbrp-uepos IS INITIAL.
      IF lv_tabix_space GT 1.
        APPEND lst_final_space TO fp_i_final_tbt.
      ENDIF. " IF lv_tabix_space GT 1
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

    IF lst_mara-mtart IN r_mtart_med_issue. "Media Issues
      READ TABLE fp_i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>)
           WITH KEY matnr = lst_vbrp-matnr
                    spras = st_header-language "Customer Language
           BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE fp_i_makt ASSIGNING <lst_makt>
             WITH KEY matnr = lst_vbrp-matnr
                      spras = c_deflt_langu "Default Language
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
*          lst_final_tbt-subs_type = <lst_makt>-maktx. "Material Description
        CLEAR:lst_jptidcdassign.
        READ TABLE fp_i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                      idcodetype = v_idcodetype_2
                                                                      BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          lv_identcode_zjcd = lst_jptidcdassign-identcode.
          CONCATENATE lv_identcode_zjcd <lst_makt>-maktx INTO lst_final_tbt-subs_type SEPARATED BY lc_hyphen.
          CONDENSE lst_final_tbt-subs_type.
        ELSE. " ELSE -> IF sy-subrc IS INITIAL
          lst_final_tbt-subs_type = <lst_makt>-maktx. "Material Description
        ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
      ENDIF. " IF sy-subrc EQ 0
    ELSE. " ELSE -> IF lst_mara-mtart IN r_mtart_med_issue
*         Fetch Material Basic Text
      CLEAR: li_lines,
             lv_mat_text.
      lv_tdname = lst_mara-matnr.
*         Using Customer Language
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = c_id_grun          "Text ID: GRUN
          language                = st_header-language "Language Key
          name                    = lv_tdname          "Text Name: Material Number
          object                  = c_obj_mat          "Text Object: MATERIAL
        TABLES
          lines                   = li_lines           "Text Lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc NE 0.
*           Using Default Language (English)
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = c_id_grun     "Text ID: GRUN
            language                = c_deflt_langu "Language Key
            name                    = lv_tdname     "Text Name: Material Number
            object                  = c_obj_mat     "Text Object: MATERIAL
          TABLES
            lines                   = li_lines      "Text Lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        DELETE li_lines WHERE tdline IS INITIAL.
*           Convert ITF text into a string
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = li_lines
          IMPORTING
            ev_text_string = lv_mat_text.
        IF sy-subrc EQ 0.
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
*            lst_final_tbt-subs_type = lv_mat_text. "Material Basic Text
          READ TABLE fp_i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                        idcodetype = v_idcodetype_2
                                                                        BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lv_identcode_zjcd = lst_jptidcdassign-identcode.
            CONCATENATE lv_identcode_zjcd lv_mat_text INTO lst_final_tbt-subs_type SEPARATED BY lc_hyphen.
            CONDENSE lst_final_tbt-subs_type.
          ELSE. " ELSE -> IF sy-subrc IS INITIAL
            lst_final_tbt-subs_type = lv_mat_text. "Material Basic Text
          ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_mara-mtart IN r_mtart_med_issue
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529

    SET COUNTRY st_header-bill_country.

    IF lst_vbrp-uepos IS INITIAL.
      WRITE lst_vbrp-fkimg TO lst_final_tbt-quantity UNIT lst_vbrp-meins.
* Begin of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
*  Unit Price calucalation
      CLEAR v_unit_price.
*  Unit Price = Net Value / Billed Quantity
      v_unit_price = lst_vbrp-kzwi1 / lst_vbrp-fkimg.
      WRITE v_unit_price TO lst_final_tbt-unit_price UNIT st_header-doc_currency.
      CONDENSE lst_final_tbt-unit_price.
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        CONCATENATE '-' lst_final_tbt-unit_price INTO lst_final_tbt-unit_price.
      ENDIF.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.
        CONCATENATE '-' lst_final_tbt-unit_price INTO lst_final_tbt-unit_price.
      ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
* End of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
      lv_fees = lst_vbrp-kzwi1.
      lv_disc = lst_vbrp-kzwi5.
      IF lv_fees LT 0.
        WRITE lv_fees TO lst_final_tbt-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-amount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_tbt-amount.
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_fees TO lst_final_tbt-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-amount.
        CONCATENATE lc_minus lst_final_tbt-amount INTO lst_final_tbt-amount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_cinv. " Cancelled invoice
        WRITE lv_fees TO lst_final_tbt-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-amount.
        CONCATENATE lc_minus lst_final_tbt-amount INTO lst_final_tbt-amount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd. " Credit memo cancellation
        WRITE lv_fees TO lst_final_tbt-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-amount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_fees LT 0
        WRITE lv_fees TO lst_final_tbt-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-amount.
      ENDIF. " IF lv_fees LT 0
**********************************************************************
*****************************DISCOUNT*********************************
*   Begin of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
      IF lv_disc LT 0.
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_disc = lv_disc * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.
          lv_disc = lv_disc * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_disc TO lst_final_tbt-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-discount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_tbt-discount.
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_disc TO lst_final_tbt-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-discount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp  IN r_cinv. " Cancelled invoice
        WRITE lv_disc TO lst_final_tbt-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-discount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                  " cancelled credit memo
        WRITE lv_disc TO lst_final_tbt-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-discount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_disc LT 0
        WRITE lv_disc TO lst_final_tbt-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-discount.
      ENDIF. " IF lv_disc LT 0

*******      Tax Amount
      IF lst_final_tbt-tax IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF lv_tax LT 0.
          WRITE lv_tax TO lst_final_tbt-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_tbt-tax.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final_tbt-tax.
          CONDENSE lst_final_tbt-tax.
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
          WRITE lv_tax TO lst_final_tbt-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_tbt-tax.
          CONCATENATE lc_minus lst_final_tbt-tax INTO lst_final_tbt-tax.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp  IN r_cinv.    " Cancelled invoice
          WRITE lv_tax TO lst_final_tbt-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_tbt-tax.
          CONCATENATE lc_minus lst_final_tbt-tax INTO lst_final_tbt-tax.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                  " Cancelled credit memo
          WRITE lv_tax TO lst_final_tbt-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_tbt-tax.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF lv_tax LT 0
          WRITE lv_tax TO lst_final_tbt-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_tbt-tax.
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF lst_final_tbt-tax IS INITIAL

****** Total
      lv_total = lst_vbrp-kzwi3 + lv_tax + lv_total.
      IF lv_total LT 0.
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_total = lv_total * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.
          lv_total = lv_total * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_total TO lst_final_tbt-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_tbt-total.
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_crd. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_total TO lst_final_tbt-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-total.
        CONCATENATE lc_minus lst_final_tbt-total INTO lst_final_tbt-total.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.      " Cancelled invoice
        WRITE lv_total TO lst_final_tbt-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-total.
        CONCATENATE lc_minus lst_final_tbt-total INTO lst_final_tbt-total.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                  "  Cancelled credit memo
        WRITE lv_total TO lst_final_tbt-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-total.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_total LT 0
        WRITE lv_total TO lst_final_tbt-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_tbt-total.
      ENDIF. " IF lv_total LT 0


*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
*     Begin of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
*     lst_input-product_no = lst_vbrp-matnr.
*     IF lst_vbrp-kdkg2 IS NOT INITIAL.
*       lst_input-cust_grp = lst_vbrp-kdkg2.
*     ENDIF. " IF lst_vbrp-kdkg2 IS NOT INITIAL
*     APPEND lst_input TO i_input.
*     CLEAR: lst_input.
*     End   of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
*    ENDIF. " IF lst_vbrp-uepos IS INITIAL
* *     *Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
      IF lst_final_tbt-quantity IS INITIAL.
        CLEAR: lst_final_tbt-quantity.
      ENDIF. " IF lst_final_tbt-quantity IS INITIAL
*      End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
    ENDIF. " IF lst_vbrp-uepos IS INITIAL
*************BOC by SRBOSE on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
*** BOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
      IF v_seller_reg IS INITIAL.
        v_seller_reg = lst_tax_data-seller_reg.
      ELSE.
        CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma.
      ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
*      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commented per CR#7431&7189 KKRAVURI20181109
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
*     Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
*     IF lst_vbrp-aland EQ lst_vbrp-lland.
*     End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
*     Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
      IF st_header-comp_code_country EQ lst_vbrp-lland.
*     End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma. " ADD: CR#7431&7189 KKRAVURI20181109  ED2K913809
*            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commented per CR#7431&7189 KKRAVURI20181109
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
    ENDIF. " IF sy-subrc EQ 0
*************EOC by SRBOSE on 08/08/2017 for CR# 408****************
    IF lst_final_tbt IS NOT INITIAL.
      APPEND lst_final_tbt TO fp_i_final_tbt.
    ENDIF. " IF lst_final_tbt IS NOT INITIAL

    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.
    lv_due = lv_due + lst_vbrp-kzwi2.

    CLEAR lst_final_tbt.
    READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR: lv_flag_di,
              lv_flag_ph.
      IF lst_mara-ismmediatype EQ 'DI'.
        lv_flag_di = abap_true.
      ELSEIF lst_mara-ismmediatype EQ 'PH'.
        lv_flag_ph = abap_true.
      ENDIF. " IF lst_mara-ismmediatype EQ 'DI'

      CLEAR : lv_name,
              lv_name_issn,
              lv_pnt_issn,
              v_subscription_typ.
      IF lv_flag_di EQ abap_true.
        lv_name = lc_digt_subsc.
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_digissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

      ELSEIF lv_flag_ph EQ abap_true.
        lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_pntissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX


      ELSE. " ELSE -> IF lv_flag_di EQ abap_true
        lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_combissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

      ENDIF. " IF lv_flag_di EQ abap_true
      CLEAR lst_final_tbt.
      IF lst_vbrp-uepos IS INITIAL. "Added by MODUTTA on 07/03/18
        lst_final_tbt-subs_type = v_subscription_typ.
        APPEND lst_final_tbt TO fp_i_final_tbt.
      ENDIF. " IF lst_vbrp-uepos IS INITIAL
    ENDIF. " IF sy-subrc EQ 0

*** BOC by MODUTTA on 01/02/2018 for CR#_XXX
** Total of Issues, Start Volume, Start Issue
    IF lst_vbrp-uepos IS INITIAL.
*Multi-Year Subs
*      lv_name = lc_mlsubs. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
      lv_name = c_sub_term. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
      CLEAR: lst_final_tbt.
      PERFORM f_get_text_val USING lv_name
                                   st_header
                          CHANGING lv_mlsub.
      READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_vbrp-aubel
                                                     vposn = lst_vbrp-aupos
                                                     BINARY SEARCH.
*** BOC BY NPALLA on 11-JUNE-2019 for CR-7282 - ED1K910333
      IF sy-subrc NE 0.
        READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbrp-aubel
                                                 vposn = lc_000000
                                                 BINARY SEARCH.
      ENDIF. " IF sy-subrc EQ 0
*** EOC BY NPALLA on 11-JUNE-2019 for CR-7282 - ED1K910333
      IF sy-subrc EQ 0.
        READ TABLE i_tvlzt INTO DATA(lst_tvlzt) WITH KEY spras = st_header-language
                                                         vlaufk = lst_veda-vlaufk
                                                         BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lst_tvlzt-bezei IS NOT INITIAL.
          CONCATENATE lv_mlsub lst_tvlzt-bezei INTO lst_final_tbt-subs_type SEPARATED BY lc_colon.
          APPEND lst_final_tbt TO fp_i_final_tbt.
          CLEAR lst_final_tbt.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
    READ TABLE li_vbrp_tmp1  WITH KEY uepos = lst_vbrp-posnr TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_bhf = abap_true.
    ENDIF. " IF sy-subrc = 0
    IF lv_bhf IS INITIAL.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
***Year
*      lv_name = lc_year. "CR-7841:SGUDA:30-Apr-2019:ED1K910147
      lv_name = c_cntr_start. ""CR-7841:SGUDA:30-Apr-2019:ED1K910147
      CLEAR: lst_final_tbt.
      PERFORM f_get_text_val USING lv_name
                                   st_header
                          CHANGING lv_year.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
      lv_name = c_cntr_end.
      PERFORM f_get_text_val USING lv_name
                                   st_header
                          CHANGING v_cntr_end.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
* Begin of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
      CLEAR :v_start_year1.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
*      READ TABLE i_veda ASSIGNING FIELD-SYMBOL(<lfs_veda>) WITH KEY vbeln = lst_vbrp-vgbel
*                                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.
      READ TABLE i_veda INTO DATA(ls_veda) WITH KEY vbeln = lst_vbrp-vgbel
                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.

*      IF sy-subrc EQ 0.
*        v_start_year1 = <lfs_veda>-vbegdat+0(4).
*      ENDIF.
      IF ls_veda-vbegdat IS INITIAL.
        READ TABLE i_veda INTO ls_veda WITH KEY vbeln = lst_vbrp-vgbel
                                                vposn = c_posnr BINARY SEARCH.

      ENDIF.

*      IF v_start_year1 IS NOT INITIAL.
*        CONCATENATE lv_year v_start_year1 INTO lst_final_tbt-subs_type SEPARATED BY lc_colon.
** End of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
*        CONDENSE lst_final_tbt-subs_type.
*        APPEND lst_final_tbt-subs_type TO fp_i_final_tbt.
*        CLEAR lst_final_tbt-subs_type.
*      ENDIF. " IF v_start_year IS NOT INITIAL
      IF ls_veda-vbegdat IS NOT INITIAL.
        CLEAR : v_year_2,v_cntr_month,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
        CONCATENATE lv_year lc_colon INTO v_year_2.
        CONDENSE v_year_2.
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = ls_veda-vbegdat
          IMPORTING
            day                           = v_day
            month                         = v_month
            year                          = v_year2
            stext                         = v_stext
            ltext                         = v_ltext
*           userdate                      =
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
        CONDENSE v_cntr.
        CONCATENATE v_year_2 v_cntr INTO lst_final_tbt-subs_type.
        CONDENSE lst_final_tbt-subs_type.
        APPEND lst_final_tbt-subs_type TO fp_i_final_tbt.
        CLEAR lst_final_tbt-subs_type.
      ENDIF.
      IF ls_veda-venddat IS NOT INITIAL..
        CLEAR : v_year_2,v_cntr_month,v_cntr,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
        CONCATENATE v_cntr_end lc_colon INTO v_year_2.
        CONDENSE v_year_2.
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = ls_veda-venddat
          IMPORTING
            day                           = v_day
            month                         = v_month
            year                          = v_year2
            stext                         = v_stext
            ltext                         = v_ltext
*           userdate                      =
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
        CONDENSE v_cntr.
        CONCATENATE v_year_2 v_cntr INTO lst_final_tbt-subs_type.
        CONDENSE lst_final_tbt-subs_type.
        APPEND lst_final_tbt-subs_type TO fp_i_final_tbt.
        CLEAR lst_final_tbt-subs_type.
      ENDIF.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
      IF lst_mara-ismhierarchlevl EQ '2'.
* SOC by NPOLINA ED1K909026  INC0216814
*        READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara-matnr.
        READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY posnr = lst_vbrp-posnr
                                                                 matnr = lst_mara-matnr BINARY SEARCH.
* EOC by NPOLINA ED1K909026  INC0216814

        IF sy-subrc EQ 0.
          DATA(lst_issue_vol) = lst_issue_vol2.
        ENDIF. " IF sy-subrc EQ 0
      ELSEIF lst_mara-ismhierarchlevl EQ '3'.
        lst_issue_vol-stvol = lst_mara-ismcopynr.
**        BOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
*        lst_issue_vol-noi = lst_mara-ismnrinyear.
*        lst_issue_vol-stiss = '1'.
        lst_issue_vol-noi = '1'.
        lst_issue_vol-stiss = lst_mara-ismnrinyear.
**        EOC by MODUTTA:INC0196380:24-May-2018:TR# ED1K907491
      ENDIF. " IF lst_mara-ismhierarchlevl EQ '2'

***Start Volume
      IF lst_issue_vol IS NOT INITIAL.
*         Start Volume
        lv_name = lc_volume.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_volum.

        IF lst_issue_vol-stvol IS NOT INITIAL.
          CONCATENATE lv_volum lst_issue_vol-stvol INTO lv_issue_desc SEPARATED BY space.
          IF lst_final_tbt-subs_type IS NOT INITIAL.
            CONCATENATE lst_final_tbt-subs_type lc_comma lv_issue_desc INTO lst_final_tbt-subs_type.
          ELSE. " ELSE -> IF lst_final_tbt-subs_type IS NOT INITIAL
            lst_final_tbt-subs_type = lv_issue_desc.
          ENDIF. " IF lst_final_tbt-subs_type IS NOT INITIAL
          CONDENSE lst_final_tbt-subs_type.
        ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

* Total Issues
        lv_name = lc_issue.
        CLEAR: lv_issue,lv_issue_desc.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_issue.
        IF lst_issue_vol-noi IS NOT INITIAL.
          MOVE lst_issue_vol-noi TO lv_vol.
          CONCATENATE lv_vol lv_issue INTO lv_issue_desc SEPARATED BY space.
          IF lst_final_tbt-subs_type IS NOT INITIAL.
            CONCATENATE lst_final_tbt-subs_type lc_comma lv_issue_desc INTO lst_final_tbt-subs_type.
          ELSE. " ELSE -> IF lst_final_tbt-subs_type IS NOT INITIAL
            lst_final_tbt-subs_type = lv_issue_desc.
          ENDIF. " IF lst_final_tbt-subs_type IS NOT INITIAL
          CONDENSE lst_final_tbt-subs_type.
        ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL
      ENDIF. " IF lst_issue_vol IS NOT INITIAL

      IF lst_final_tbt IS NOT INITIAL.
        CONDENSE lst_final_tbt-subs_type.
        APPEND lst_final_tbt TO fp_i_final_tbt.
        CLEAR lst_final_tbt.
      ENDIF. " IF lst_final_tbt IS NOT INITIAL

*****Start Issue Number
      IF lst_issue_vol IS NOT INITIAL.
        lv_name = lc_stissue.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_issue.

        IF lst_issue_vol-stiss IS NOT INITIAL.
          CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_final_tbt-subs_type SEPARATED BY space.
          CONDENSE lst_final_tbt-subs_type.
          APPEND lst_final_tbt TO fp_i_final_tbt.
          CLEAR lst_final_tbt.
        ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
      ENDIF. " IF lst_issue_vol IS NOT INITIAL

***ISSN
      CLEAR: lst_final_tbt.
      READ TABLE fp_i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                    idcodetype = v_idcodetype_1 "(++ BOC by SRBOSE for CR_XXX)
                                                                 BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF lst_jptidcdassign-identcode IS NOT INITIAL.
          lv_identcode = lst_jptidcdassign-identcode.
*** Begin of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
*          CONCATENATE lv_pnt_issn lst_jptidcdassign-identcode INTO lst_final_tbt-subs_type SEPARATED BY lc_colon.
          lst_final_tbt-subs_type = lst_jptidcdassign-identcode.
*** End of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
          CONDENSE lst_final_tbt-subs_type.
          APPEND lst_final_tbt TO fp_i_final_tbt.
        ENDIF. " IF lst_jptidcdassign-identcode IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_bhf IS INITIAL

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
    READ TABLE li_vbrp_tmp2 WITH KEY posnr = lst_vbrp-posnr TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_lcf = abap_true.
    ENDIF. " IF sy-subrc = 0
    IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL ).
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
* Begin of Change by SRBOSE on 28-Jul-2017 #TR:ED2K907591
      CLEAR: lst_final_tbt.
      READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                      BINARY SEARCH.
      IF sy-subrc IS INITIAL.
*            lst_final_tbt-sub_ref = lst_vbkd-ihrez.
        lst_final_tbt-subs_type = lst_vbkd-ihrez.
*       Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        CLEAR: lv_sub_ref_id.
        PERFORM f_read_sub_type USING    lc_sub_ref_id
                                         lc_text_id
                                CHANGING lv_sub_ref_id.
        IF lv_sub_ref_id IS NOT INITIAL.
          CONCATENATE lv_sub_ref_id
                      lst_final_tbt-subs_type
                 INTO lst_final_tbt-subs_type
            SEPARATED BY space.
        ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*       End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        APPEND lst_final_tbt TO fp_i_final_tbt.
      ENDIF. " IF sy-subrc IS INITIAL
*    ENDIF. " IF lst_vbrp-uepos IS INITIAL
      CLEAR lst_final_tbt.
      IF st_header-buyer_reg IS INITIAL.
        READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                            doc_line_number = lv_doc_line
                                                            BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_final_tbt-subs_type = lst_tax_data-buyer_reg. "Added by  MODITTA
          IF lst_final_tbt-subs_type IS NOT INITIAL.
            CONCATENATE lv_text lst_final_tbt-subs_type INTO lst_final_tbt-subs_type SEPARATED BY space.
            CONDENSE lst_final_tbt-subs_type.
          ENDIF. " IF lst_final_tbt-subs_type IS NOT INITIAL
          APPEND lst_final_tbt TO fp_i_final_tbt.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-buyer_reg IS INITIAL
    ENDIF. " IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )

* BOC by Lahiru on 10/09/2020 for ERPM-16179 with ED2K919804
    DATA : lv_count TYPE i.

    IF i_vbkd IS NOT INITIAL.
      DATA(li_tmp_vbkd) = i_vbkd[].
      SORT li_tmp_vbkd BY bstkd.
      DELETE ADJACENT DUPLICATES FROM li_tmp_vbkd COMPARING bstkd.  " delete same PO number record from the Itab

      DESCRIBE TABLE li_tmp_vbkd LINES lv_count.          " counting no of records to identify the whether it's having multiple PO number or not
      IF lv_count GT 1.
        " Header Po area should be display the "Multiple PO's" text
        " Using read text FM get the text value and assign to Header PO variable
        CLEAR : lst_vbkd.
        READ TABLE i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbrp-aubel
                                                 posnr = lst_vbrp-aupos BINARY SEARCH.
        IF sy-subrc = 0.
          lst_final_tbt-subs_type = lst_vbkd-bstkd.
          APPEND lst_final_tbt TO fp_i_final_tbt.
        ENDIF.
      ENDIF.
    ENDIF.
* EOC by Lahiru on 10/09/2020 for ERPM-16179 with ED2K919804


**EOC by MODUTTA on 08/08/2017 fo CR#408
    CLEAR : lst_final_tbt,
             lv_fees,
             lv_disc,
             lv_tax,
             lv_total,
             lv_total_val,
             lst_issue_vol,
             lv_bhf,
             lv_lcf,
             lst_issue_vol2.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)

***BOC SRBOSE
  IF i_subtotal IS INITIAL.
    lst_subtotal-desc         = lv_text.
    lst_subtotal-vat_tax_val  = v_sales_tax.
    APPEND lst_subtotal TO i_subtotal.
  ENDIF. " IF i_subtotal IS INITIAL
***EOC SRBOSE

*  BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
    CONDENSE v_seller_reg.
* Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
* End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
  ENDIF. " IF v_seller_reg IS NOT INITIAL
* EOC by SRBOSE
* SubTotal Amount
  v_subtotal_val = st_vbrk-netwr.

*Begin of change by SRBOSE on 02-Aug-2017 Defect_3428 #TR:ED2K907591
  IF st_vbrk-zlsch EQ 'J' OR st_vbrk-zlsch EQ 'U'.
*End of change by SRBOSE on 02-Aug-2017 Defect_3428 #TR:ED2K907591
    fp_v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J' OR st_vbrk-zlsch EQ 'U'
* Begin of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
* Total due amount Without Prepaid amount
  IF v_credit_memo = c_o.
    v_totaldue_val = v_subtotal_val + v_sales_tax.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSEIF v_credit_memo IN r_cinv.   " cancelled invoice
    v_totaldue_val = v_subtotal_val + v_sales_tax.
  ELSEIF v_credit_memo IN r_ccrd.   " cancelled credit memo
    v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSE.
* End of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
* Total due amount With Prepaid amount
    v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.
  ENDIF. "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657


* BOC by SRBOSE cr_666
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-tax_amount.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SUBSCRPTION_TYPE
*&---------------------------------------------------------------------*
* Subroutine to populate subscription type
*----------------------------------------------------------------------*
*      -->FP_LV_NAME  text
*      -->FP_ST_HEADER  text
*      <--FP_V_SUBSCRIPTION_TYP  text
*----------------------------------------------------------------------*
FORM f_get_subscrption_type  USING    fp_lv_name             TYPE thead-tdname
                                      fp_st_header           TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                             CHANGING fp_v_subscription_typ  TYPE char100.                  " V_subscription_typ of type CHAR100

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_lv_name
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_v_subscription_typ = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_SOCIETY
*&---------------------------------------------------------------------*
*  Subroutine to populate society layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_society.
  DATA: li_output TYPE ztqtc_output_supp_retrieval.

*--BOC: SKKAIRAMKO - CR#6376 1/24/2019 - ED1K909372

  DATA: li_final_soc TYPE tt_final_soc,
        lst_item_soc TYPE zstqtc_item_detail_soc_f042.
*--*Get Material group5 of first Item
  READ TABLE i_vbrp INTO DATA(lst_vbrp) INDEX 1.
*--Check if sold-to customer is maintained as summary or detailed
  IF st_kna1-katr6  EQ c_001 AND lst_vbrp-mvgr5 = c_in AND st_vbrk-vbtyp = c_doc_cat. "Summary Inv + Detailed.
    CLEAR : i_final_summery.
    flg_summary = abap_true. "Summary Flag
*
** Populate final item table for summary Invoice
    PERFORM f_populate_soc_item_summmary   USING st_vbrk
                                                i_vbrp
                                       CHANGING li_final_soc
                                                i_subtotal
                                                v_paid_amt.

    IF li_final_soc IS NOT INITIAL.
*
*
**-- To delete extra line space from table
      DELETE ADJACENT DUPLICATES FROM li_final_soc COMPARING description.


      LOOP AT li_final_soc INTO DATA(lst_final_soc).

        lst_item_soc-description = lst_final_soc-description.

        IF lst_final_soc-cust_group IS NOT INITIAL.

          WRITE lst_final_soc-quantity  TO lst_item_soc-quantity UNIT 'EA'.
*
          WRITE lst_final_soc-unit_price    TO lst_item_soc-unit_price  RIGHT-JUSTIFIED.
          PERFORM f_put_sign_in_front CHANGING lst_item_soc-unit_price.

          WRITE lst_final_soc-amount    TO lst_item_soc-amount  RIGHT-JUSTIFIED.
          PERFORM f_put_sign_in_front CHANGING lst_item_soc-amount.

          WRITE lst_final_soc-discount  TO lst_item_soc-discount RIGHT-JUSTIFIED.
          PERFORM f_put_sign_in_front CHANGING lst_item_soc-discount.

          WRITE lst_final_soc-tax       TO lst_item_soc-tax      RIGHT-JUSTIFIED.
          PERFORM f_put_sign_in_front CHANGING lst_item_soc-tax.

          WRITE lst_final_soc-total     TO lst_item_soc-total    RIGHT-JUSTIFIED.
          PERFORM f_put_sign_in_front CHANGING lst_item_soc-total.

        ENDIF.
        APPEND lst_item_soc TO i_final_summery.
        CLEAR lst_item_soc.
      ENDLOOP.
    ENDIF.
*--*Begin of change Prabhu CR#6376 ED2K914917
    PERFORM f_populate_soc_item   USING st_vbrk
                                        i_vbrp
                               CHANGING i_final_soc
                                        i_subtotal
                                        v_paid_amt.
*--*End of change Prabhu CR#6376 ED2K914917
  ELSE. " AS-IS process

* Populate final item table for TBT
    PERFORM f_populate_soc_item   USING st_vbrk
                                        i_vbrp
                               CHANGING i_final_soc
                                        i_subtotal
                                        v_paid_amt.
  ENDIF.  "++ SKKAIRAMKO CR#6376

****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch texts for layout
  PERFORM f_fetch_title_text   USING st_vbrk
                                     r_country
                            CHANGING st_header
                                     v_accmngd_title
                                     v_invoice_title "(++SRBOSE CR_618)
                                     v_reprint
                                     v_tax
                                     v_remit_to
                                     v_footer
                                     v_bank_detail
                                     v_crdt_card_det
                                     v_payment_detail
                                     v_cust_service_det
                                     v_totaldue
                                     v_subtotal
                                     v_prepaidamt
                                     v_vat
                                     v_shipping
                                     v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069
**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD
*- Begin of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
  IF ( st_vbrk-vbtyp IN r_doc_type AND st_vbrk-zlsch IN r_pay_method ) AND v_receipt_flag IS INITIAL.
    PERFORM get_accounting_doc_clear.
    IF st_bseg[] IS NOT INITIAL.
      v_receipt_flag = abap_true.
      PERFORM f_read_text    USING c_name_receipt
                  CHANGING v_accmngd_title.
    ELSE.
      CLEAR v_totaldue_val.
      v_totaldue_val = v_subtotal_val + v_sales_tax.
      CLEAR v_paid_amt.
    ENDIF.
  ELSE.
*- End of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
* For total due amount less than equal 0, title will be receipt
    IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
      IF st_header-credit_flag IS INITIAL AND
         st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
*     Subroutine to fetch text value of receipt
        PERFORM f_read_text    USING c_name_receipt
                            CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
      ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227

* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
      v_receipt_flag = abap_true.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
*   Always dispaly 0 as total due for less than equal 0 amount
      CLEAR: v_totaldue_val, st_header-terms.
*    CLEAR : v_payment_detail, v_crdt_card_det.
      CLEAR v_crdt_card_det.
    ENDIF. " IF v_totaldue_val LE 0
  ENDIF.  "ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502

*** BOC: CR#7431&7189 KKRAVURI20181120  ED2K913896
  IF r_bill_doc_type[] IS NOT INITIAL AND
     st_vbrk-fkart IN r_bill_doc_type.
    v_receipt_flag = abap_true.
  ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181120  ED2K913896

* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
* Fetch barcode
* Below IF condition is added to fix the INC0258568 issue
  IF v_receipt_flag <> abap_true.  " ADD:INC0258568:KKRAVURI:18-Sep-2019
    PERFORM f_populate_barcode.
  ENDIF.
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809

***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
  PERFORM f_populate_exc_tab.
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
  IF st_header-bill_type IN r_currency_country  AND st_header-bill_country IN r_bill_doc_type_curr.
    CLEAR i_exc_tab[].
  ENDIF.
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
* Subroutine to populate layout.
  v_formname = c_soc_form.
*--*Begin of change Prabhu CR#6376 ED2K914840
  IF st_kna1-katr6  EQ c_001 AND lst_vbrp-mvgr5 = c_in AND st_vbrk-vbtyp = c_doc_cat.
    v_formname = c_soc_comb_form.
  ENDIF.
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
  IF  ( v_formname = c_tbt_form ) OR ( v_formname = c_soc_form ) OR ( v_formname = c_soc_comb_form ).
    CLEAR i_output[].
    PERFORM f_call_fm_output_supp USING i_input
                                  CHANGING i_output.
  ENDIF.
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*--*End of change Prabhu CR#6376 ED2K914840
  PERFORM f_populate_layout USING v_formname.
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* Begin of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
* End   of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* If email id is maintained, then send PDF as attachment to the mail address
*  IF v_society IS NOT INITIAL. "(++ BOC BY SRBOSE ON 19-JAN-2018 #CR_XXX #TR: ED2K910373)
* Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
* IF v_society IS INITIAL. "(++) MODUTTA on 15/02/18 for issue in QA
* End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
  IF i_emailid[] IS NOT INITIAL
* Begin of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
 AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:22-Feb-2018:ED2K911002
    PERFORM f_send_mail_attach USING v_formname.
  ENDIF. " IF i_emailid[] IS NOT INITIAL
* Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
* ENDIF. " IF v_society IS INITIAL
* End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_SOC_ITEM
*&---------------------------------------------------------------------*
* Populate society final item table
*----------------------------------------------------------------------*
*      -->FP_I_VBRP  text
*      <--PP_I_FINAL_SOC  text
*----------------------------------------------------------------------*
FORM f_populate_soc_item  USING    fp_st_vbrk           TYPE ty_vbrk
                                   fp_i_vbrp            TYPE tt_vbrp
                          CHANGING fp_i_final_soc       TYPE ztqtc_item_detail_soc_f042
                                   fp_i_subtotal        TYPE ztqtc_subtotal_f042
                                   fp_v_paid_amt        TYPE autwr. " Payment cards: Authorized amount

* Data declaration
  DATA : lv_fees           TYPE kzwi1, " Subtotal 1 from pricing procedure for condition
         lv_disc           TYPE kzwi5, " Subtotal 5 from pricing procedure for condition
         lv_tax            TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
         lv_total          TYPE kzwi5, " Subtotal 5 from pricing procedure for condition
         lv_total_val      TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
         lv_due            TYPE kzwi2, " Subtotal 2 from pricing procedure for condition
         lv_posnr          TYPE posnr, " Subtotal 2 from pricing procedure for condition
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         lv_mat_text       TYPE string,
         lv_tdname         TYPE thead-tdname, " Name
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         lst_final_soc     TYPE zstqtc_item_detail_soc_f042, " Structure for CSS Item table
         lst_jptidcdassign TYPE ty_jptidcdassign.

* Constant Declaration
  CONSTANTS: lc_first  TYPE char1 VALUE '(', " First of type CHAR1
             lc_second TYPE char1 VALUE ')'. " Second of type CHAR1

*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
  DATA:                                         "li_tkomv      TYPE STANDARD TABLE OF komv,  " Pricing Communications-Condition Record
    li_tkomvd      TYPE STANDARD TABLE OF komvd, " Price Determination Communication-Cond.Record for Printing
    lst_komk       TYPE komk,                    " Communication Header for Pricing
*       Begin of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
*       lv_kbetr_desc TYPE kbetr,                   " Rate (condition amount or percentage)
    lv_kbetr_desc  TYPE p DECIMALS 3, " Rate (condition amount or percentage)
*       End   of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
    lv_kbetr_char  TYPE char15,               " Kbetr_char of type CHAR15
    lst_komp       TYPE komp,                 " Communication Item for Pricing
    li_vbrp        TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
    lv_doc_line    TYPE /idt/doc_line_number, " Document Line Number
*   Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
    lv_sub_ref_id  TYPE char255, " Sub Ref ID
*   End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
*   Begin of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
*    lv_pnt_issn   TYPE char10, " Print ISSN
    lv_pnt_issn    TYPE char30, " Print ISSN
    lv_membership  TYPE char30, " Print ISSN
*   End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
    lv_buyer_reg   TYPE char255, " Buyer_reg of type CHAR255
*    * BOC: CR#6376 KJAGANA20181122  ED2K913919
    lv_flag_mg     TYPE char1,  "flag to check for material gr5
    lv_flag_inv    TYPE char1,  "flag to check for invoice type
    lv_member_type TYPE char255, "Member type text
    lv_desc        TYPE char255. "Condition group desc
* EOC: CR#6376 KJAGANA20181122  ED2K913919
  DATA : li_lines           TYPE STANDARD TABLE OF tline,     "Lines of text read
         lv_text            TYPE string,
         lv_ind             TYPE xegld,                       " Indicator: European Union Member?
         lst_line           TYPE tline,                       " SAPscript: Text Lines
         lst_lines          TYPE tline,                       " SAPscript: Text Lines
         lv_tax_bom         TYPE char20,                      " Tax_bom of type CHAR20
         lv_flag_di         TYPE char1,                       " Flag_di of type CHAR1
         lv_flag_ph         TYPE char1,                       " Flag_ph of type CHAR1
         lv_name            TYPE thead-tdname,                " Name
         lv_name_issn       TYPE thead-tdname,                " Name
         lv_name_membership TYPE thead-tdname,                " Name
         lv_volum           TYPE char30,                      " Volume
         lv_year            TYPE char30,                      " Year
         lv_issue           TYPE char30,                      " Issue
         lv_memb_type       TYPE char30,                      " Issue
         lv_mlsub           TYPE char30,                      " Issue
         lv_vol             TYPE char8,                       " Volume
         lv_vol_des         TYPE char255,                     " Vol_des of type CHAR255
         lv_issue_des       TYPE char255,                     " Issue_des of type CHAR255
         lv_text_id         TYPE tdid,                        " Text ID
         lv_tax_amount      TYPE p DECIMALS 3,                " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                       " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                       " Rate (condition amount or percentage)
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         lst_tax_item_final TYPE zstqtc_tax_item_f042,        " Structure for tax components
         lst_final_space    TYPE zstqtc_item_detail_soc_f042, " Structure for society form
         lst_input          TYPE zstqtc_supplement_ret_input, " Input Paramter for E098 Supplement retrieval
         lst_subtotal       LIKE LINE OF i_subtotal,
         lv_vol_year        TYPE char255,                     " Vol_des of type CHAR255.
         lv_flag            TYPE char1,                       " Flag of type CHAR1
         lv_text_tax        TYPE string,
*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bhf             TYPE char1, " Bhf of type CHAR1
         lv_lcf             TYPE char1, " Lcf of type CHAR1
         li_vbrp_tmp1       TYPE tt_vbrp,
         li_vbrp_tmp2       TYPE tt_vbrp,
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bom_hdr_flg     TYPE xfeld, "Added by MODUTTA on 05/17/18 for INC0194372
         lv_year1           TYPE char4.  "  NPOLINA INC0218384  ED1K909026 Change for Society Year

  CONSTANTS:lc_undscr     TYPE char1        VALUE '_',   " Undscr of type CHAR1
            lc_vat        TYPE char3        VALUE 'VAT', " Vat of type CHAR3
            lc_tax        TYPE char3        VALUE 'TAX', " Tax of type CHAR3
            lc_gst        TYPE char3        VALUE 'GST', " Gst of type CHAR3
*           Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            lc_parvw_za   TYPE parvw        VALUE 'ZA',     " Partner Function
            lc_parvw_ag   TYPE parvw        VALUE 'AG',     " Partner Function
            lc_posnr_h    TYPE posnr        VALUE '000000', " Item number of the SD document
*           End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            lc_class      TYPE char5        VALUE 'ZQTC_',                           " Class of type CHAR5
            lc_devid      TYPE char5        VALUE '_F024',                           " Devid of type CHAR5
            lc_year       TYPE thead-tdname VALUE 'ZQTC_YEAR_F024',                  " Name
            lc_volume     TYPE thead-tdname VALUE 'ZQTC_VOLUME_F042',                " Name
            lc_issue      TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',                 " Name
            lc_stvolume   TYPE thead-tdname VALUE 'ZQTC_STARTVOLUME_F042',           " Name
            lc_stissue    TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',            " Name
            lc_mlsubs     TYPE thead-tdname VALUE 'ZQTC_MSUBS_F042',                 " Name
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
*           Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
            lc_sub_ref_id TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*           End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
*           Begin of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
            lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042', " Name
*           End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
            lc_shipping   TYPE tdobname     VALUE 'ZQTC_F024_SHIPPING',      " Name
            lc_text_id    TYPE tdid         VALUE 'ST',                      " Text ID
            lc_digital    TYPE tdobname     VALUE 'ZQTC_F024_DIGITAL',       " Name
            lc_print      TYPE tdobname     VALUE 'ZQTC_F024_PRINT',         " Name
            lc_mixed      TYPE tdobname     VALUE 'ZQTC_F024_MIXED',         " Name
            lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
            lc_membership TYPE thead-tdname VALUE 'ZQTC_MEMBERSHIP_F042',    " Name
            lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042', " Name
            lc_za         TYPE parvw        VALUE 'ZA',                      " Partner Function
            lc_comma      TYPE char1        VALUE ',',                       " Comma of type CHAR1
            lc_colon      TYPE char1        VALUE ':',                       " Colon of type CHAR1
            lc_minus      TYPE char1        VALUE '-',                       " Colon of type CHAR1
            lc_hyphen     TYPE char1        VALUE '-',                       " Colon of type CHAR1
            lc_tax_text   TYPE tdobname VALUE 'ZQTC_TAX_F024'.               " Name

*  Constant Declaration
  CONSTANTS: lc_percent TYPE char1 VALUE '%'. " Percentage of type CHAR1

  IF i_iss_vol2 IS NOT INITIAL.
* SOC by NPOLINA ED1K909026  INC0216814
*    SORT i_iss_vol2 BY matnr.
    SORT i_iss_vol2 BY posnr matnr.
* EOC by NPOLINA ED1K909026  INC0216814
  ENDIF. " IF i_iss_vol2 IS NOT INITIAL


*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
  li_vbrp_tmp1[] = fp_i_vbrp[].
  li_vbrp_tmp2[] = fp_i_vbrp[].
  SORT li_vbrp_tmp2 BY posnr DESCENDING.
  DELETE li_vbrp_tmp2 WHERE uepos IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp2 COMPARING uepos.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description

  lst_komk-belnr = fp_st_vbrk-vbeln.
  lst_komk-knumv = fp_st_vbrk-knumv.
* BOC by SRBOSE
  DATA(li_tax_data) = i_tax_data.
** Begin of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
*  SORT li_tax_data BY document doc_line_number.
  SORT li_tax_data BY seller_reg.
** End of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.
  SORT li_tax_data BY document doc_line_number. "INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.
*---------Cust VAT---------------------------------------------------*
  DATA(li_tax_temp) = i_tax_data.
  DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
  SORT li_tax_temp BY buyer_reg.
  DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
  DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
  IF lv_tax_line EQ 1.
    READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
    IF sy-subrc EQ 0.
      st_header-buyer_reg = lst_tax_temp-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_tax_line EQ 1
*--------------------------------------------------------------------*
* EOC by SRBOSE
  li_vbrp = fp_i_vbrp.
  DELETE li_vbrp WHERE uepos IS INITIAL.
* Fetch VAT/TAX/GST based on condition
  IF v_ind EQ abap_true.
    CONCATENATE lc_class
                lc_vat
                lc_devid
           INTO v_tax.

  ELSEIF st_header-bill_country EQ 'US'.
    CONCATENATE lc_class
                lc_tax
                lc_devid
           INTO v_tax.
  ELSE. " ELSE -> IF v_ind EQ abap_true
    CONCATENATE lc_class
                lc_gst
                lc_devid
           INTO v_tax.

  ENDIF. " IF v_ind EQ abap_true
  CLEAR: li_lines,
         lv_text.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD


* BOC by SRBOSE on 31-JAN-2018 #TR: ED2K910115 for CR_XXX
* Get Membership Text
  lv_name_membership = lc_membership.
  PERFORM f_get_text_val USING lv_name_membership
                               st_header
                      CHANGING lv_membership.
* EOC by SRBOSE on 31-JAN-2018 #TR: ED2K910115 for CR_XXX


***BOC by SRBOSE on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kawrt IS INITIAL. "Commented by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
*End of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
  IF i_vbkd[] IS NOT INITIAL.
    SELECT  spras,
            kdkgr,
            vtext
            FROM tvkggt
            INTO TABLE @DATA(li_tvkgg)
            FOR ALL ENTRIES IN @i_vbkd
            WHERE spras EQ @st_header-language
            AND   kdkgr EQ @i_vbkd-kdkg2.
    IF sy-subrc EQ 0.
      SORT li_tvkgg BY spras kdkgr.
    ENDIF.
  ENDIF.
*- End of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp).
    DATA(lv_tabix_space)  = sy-tabix.
*    IF lst_vbrp-uepos EQ '000000'.
    DATA(lv_prev_tabix)  = sy-tabix.
*      lst_final_soc-item = lv_posnr = lst_vbrp-posnr.
*   Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
    IF lst_vbrp-uepos IS INITIAL. "BOM Components should not be considered
      APPEND INITIAL LINE TO i_input ASSIGNING FIELD-SYMBOL(<lst_input>).
      <lst_input>-product_no = lst_vbrp-matnr.
      IF lst_vbrp-kdkg2 IS NOT INITIAL.
        <lst_input>-cust_grp = lst_vbrp-kdkg2.
      ENDIF. " IF lst_vbrp-kdkg2 IS NOT INITIAL
      READ TABLE i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
           WITH KEY vbeln = lst_vbrp-vbeln
                    posnr = lst_vbrp-posnr
                    parvw = lc_parvw_za
           BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbrp-vbeln
                      posnr = lc_posnr_h
                      parvw = lc_parvw_za
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbrp-vbeln
                      posnr = lc_posnr_h
                      parvw = lc_parvw_ag
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        <lst_input>-society = <lst_vbpa>-kunnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbrp-uepos IS INITIAL
*   End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                                BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
    ENDIF. " IF sy-subrc EQ 0

***For BOM component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      lv_bom_hdr_flg = abap_true. "Added by MODUTTA on 05/17/18 for INC0194372
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
*    IF lst_tax_item-taxable_amt IS NOT INITIAL."Commented by MODUTTA on 05/17/18 for INC0194372
    IF lv_bom_hdr_flg IS INITIAL. "Added by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lv_bom_hdr_flg IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
    CLEAR: lv_bom_hdr_flg. "Added by MODUTTA on 05/17/18 for INC0194372
***      EOC by MODUTTA on 31/01/2018 for CR_XXX

    IF lst_vbrp-uepos IS INITIAL.
      IF lv_tabix_space GT 1.
        APPEND lst_final_space TO fp_i_final_soc.
      ENDIF. " IF lv_tabix_space GT 1
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

***      BOC by MODUTTA on 31/01/2018 for CR_XXX
    READ TABLE i_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbrp-aubel
                                                   posnr = lst_vbrp-aupos
                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      READ TABLE i_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_vbap-vbeln
                                                        posnr = lst_vbap-posnr
                                                        parvw = lc_za
                                                        BINARY SEARCH.
*       Begin of ADD:CR744:WROY:05-Feb-2018:ED2K911175
      IF sy-subrc NE 0.
        READ TABLE i_vbpa INTO lst_vbpa     WITH KEY vbeln = lst_vbap-vbeln
                                                        posnr = '000000'
                                                        parvw = lc_za
                                                        BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
*       End   of ADD:CR744:WROY:05-Feb-2018:ED2K911175
      IF sy-subrc EQ 0.
        IF lst_vbap-mvgr5 IN r_mvgr5_scc.
          v_scc = abap_true.
          v_scenario_scc = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
        ELSEIF lst_vbap-mvgr5 IN r_mvgr5_scm.
          v_scm = abap_true.
          v_scenario_scm = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
        ENDIF. " IF lst_vbap-mvgr5 IN r_mvgr5_scc
        IF lst_vbap-mvgr5 IN r_mvgr5_ma.
          v_mem_text = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*         Begin of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
          READ TABLE i_society INTO DATA(lst_society) WITH KEY society = lst_vbpa-kunnr
               BINARY SEARCH.
*         End   of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
*         Begin of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
*         READ TABLE i_society INTO DATA(lst_society) WITH KEY society = v_kunnr.
*         End   of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
* SOC by NPOLINA     INC0218384     ED1K909026 Change for Society Year
            READ TABLE i_veda ASSIGNING FIELD-SYMBOL(<lfs_veday>) WITH KEY vbeln = lst_vbrp-vgbel
                                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.
            IF sy-subrc EQ 0.
              CLEAR :lv_year1.
              lv_year1 = <lfs_veday>-vbegdat+0(4).
            ENDIF.

*           CONCATENATE lst_society-society_name lv_membership v_start_year INTO lst_final_soc-description SEPARATED BY space
            CONCATENATE lst_society-society_name lv_membership lv_year1 INTO lst_final_soc-description SEPARATED BY space.
            CLEAR :lv_year1.
* EOC by NPOLINA     INC0218384     ED1K909026 Change for Society Year
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_vbap-mvgr5 IN r_mvgr5_ma
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
*      ELSE. " ELSE -> IF sy-subrc EQ 0
    IF lv_flag IS INITIAL.
***      EOC by MODUTTA on 31/01/2018 for CR_XXX
      IF lst_mara-mtart IN r_mtart_med_issue. "Media Issues
        READ TABLE i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>)
             WITH KEY matnr = lst_vbrp-matnr
                      spras = st_header-language "Customer Language
             BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE i_makt ASSIGNING <lst_makt>
               WITH KEY matnr = lst_vbrp-matnr
                        spras = c_deflt_langu "Default Language
               BINARY SEARCH.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
* BOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
*          lst_final_soc-description = <lst_makt>-maktx. "Material Description
          CLEAR:lst_jptidcdassign.
          READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                        idcodetype = v_idcodetype_2
                                                                        BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            CONCATENATE lst_jptidcdassign-identcode <lst_makt>-maktx INTO lst_final_soc-description SEPARATED BY lc_hyphen.
            CONDENSE lst_final_soc-description.
          ELSE. " ELSE -> IF sy-subrc IS INITIAL
            lst_final_soc-description = <lst_makt>-maktx.
          ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX

        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF lst_mara-mtart IN r_mtart_med_issue
*         Fetch Material Basic Text
        CLEAR: li_lines,
               lv_mat_text.
        lv_tdname = lst_mara-matnr.
*         Using Customer Language
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = c_id_grun          "Text ID: GRUN
            language                = st_header-language "Language Key
            name                    = lv_tdname          "Text Name: Material Number
            object                  = c_obj_mat          "Text Object: MATERIAL
          TABLES
            lines                   = li_lines           "Text Lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc NE 0.
*           Using Default Language (English)
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = c_id_grun     "Text ID: GRUN
              language                = c_deflt_langu "Language Key
              name                    = lv_tdname     "Text Name: Material Number
              object                  = c_obj_mat     "Text Object: MATERIAL
            TABLES
              lines                   = li_lines      "Text Lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
          DELETE li_lines WHERE tdline IS INITIAL.
*           Convert ITF text into a string
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_mat_text.
          IF sy-subrc EQ 0.
* BOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
**            lst_final_soc-description = lv_mat_text. "Material Basic Text
            CLEAR:lst_jptidcdassign.
            READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                          idcodetype = v_idcodetype_2
                                                                          BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              CONCATENATE lst_jptidcdassign-identcode lv_mat_text INTO lst_final_soc-description SEPARATED BY lc_hyphen.
              CONDENSE lst_final_soc-description.
            ELSE. " ELSE -> IF sy-subrc IS INITIAL
              lst_final_soc-description = lv_mat_text. "Material Basic Text
            ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_mara-mtart IN r_mtart_med_issue
    ENDIF. " IF lv_flag IS INITIAL

    SET COUNTRY st_header-bill_country.

    IF lst_vbrp-uepos IS INITIAL. "added by MODUTTA on 08/03/18
      WRITE lst_vbrp-fkimg TO lst_final_soc-quantity UNIT lst_vbrp-meins.
      lv_fees = lst_vbrp-kzwi1.
      lv_disc = lst_vbrp-kzwi5.
* Begin of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
*  Unit Price calucalation
      CLEAR v_unit_price.
*  Unit Price = Net Value / Billed Quantity
      v_unit_price = lst_vbrp-kzwi1 / lst_vbrp-fkimg.
*     Begin of Change:INC0296815:NPALLA:18-JUNE-2020:ED1K911925
*      WRITE v_unit_price TO lst_final_soc-unit_price UNIT st_header-doc_currency.
      WRITE v_unit_price TO lst_final_soc-unit_price CURRENCY st_header-doc_currency.
*     End of Change:INC0296815:NPALLA:18-JUNE-2020:ED1K911925
      CONDENSE lst_final_soc-unit_price.
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        CONCATENATE '-' lst_final_soc-unit_price INTO lst_final_soc-unit_price.
      ENDIF.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.      " cancelled invoice
        CONCATENATE '-' lst_final_soc-unit_price INTO lst_final_soc-unit_price.
      ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
* End of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
      IF lv_fees LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-amount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_soc-amount.
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-amount.
        CONCATENATE lc_minus lst_final_soc-amount INTO lst_final_soc-amount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_cinv. " Cancelled invoice
        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-amount.
        CONCATENATE lc_minus lst_final_soc-amount INTO lst_final_soc-amount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd. " Credit memo cancellation
        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-amount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_fees LT 0
        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-amount.
      ENDIF. " IF lv_fees LT 0

      IF lv_disc LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_disc = lv_disc * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.    " cancelled invoice
          lv_disc = lv_disc * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-discount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_soc-discount.
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-discount.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.   " Cancelled invoice
        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-discount.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                    " Credit memo cancellation
        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-discount.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_disc LT 0
        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-discount.
      ENDIF. " IF lv_disc LT 0

*******      Tax Amount
      IF lst_final_soc-tax IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF lv_tax LT 0.
          WRITE lv_tax TO lst_final_soc-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_soc-tax.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final_soc-tax.
          CONDENSE lst_final_soc-tax.
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
          WRITE lv_tax TO lst_final_soc-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_soc-tax.
          CONCATENATE lc_minus lst_final_soc-tax INTO lst_final_soc-tax.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp  IN r_cinv.       " Cancelled invoice
          WRITE lv_tax TO lst_final_soc-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_soc-tax.
          CONCATENATE lc_minus lst_final_soc-tax INTO lst_final_soc-tax.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                        " Credit memo cancellation
          WRITE lv_tax         TO lst_final_soc-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_soc-tax.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF lv_tax LT 0
          WRITE lv_tax         TO lst_final_soc-tax CURRENCY st_header-doc_currency.
          CONDENSE lst_final_soc-tax.
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF lst_final_soc-tax IS INITIAL


*********Total
      lv_total = lst_vbrp-kzwi3 + lv_tax + lv_total.
      IF lv_total LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_total = lv_total * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.      " Cancelled invoice
          lv_total = lv_total * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final_soc-total.
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-total.
        CONCATENATE lc_minus lst_final_soc-total INTO lst_final_soc-total.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.    " cancelled invoice
        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-total.
        CONCATENATE lc_minus lst_final_soc-total INTO lst_final_soc-total.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                    " credit memo cancellation
        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-total.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_total LT 0
        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
        CONDENSE lst_final_soc-total.
      ENDIF. " IF lv_total LT 0

*     *Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
      IF lst_final_soc-quantity IS INITIAL.
        CLEAR: lst_final_soc-quantity.
      ENDIF. " IF lst_final_soc-quantity IS INITIAL
*      End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

*     *************BOC by SRBOSE on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
*   lv_doc_line = lst_vbrp-posnr+2(4).
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
*** BOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
      IF v_seller_reg IS INITIAL.
        v_seller_reg = lst_tax_data-seller_reg.
      ELSEIF  v_seller_reg NE lst_tax_data-seller_reg.
        CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma.
      ENDIF.
*** EOC: CR#7431&7189 KKRAVURI20181109  ED2K913809
*      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commeted per CR#7431&7189 KKRAVURI20181109
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
      IF st_header-comp_code_country EQ lst_vbrp-lland.
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma. " ADD: CR#7431&7189 KKRAVURI20181109  ED2K913809
*            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space. " Commeted per CR#7431&7189 KKRAVURI20181109
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
    ENDIF. " IF sy-subrc EQ 0
    IF lst_final_soc IS NOT INITIAL. " ELSE -> IF lst_final_soc-descript
      APPEND lst_final_soc TO fp_i_final_soc.
    ENDIF. " IF lst_final_soc IS NOT INITIAL
*   Tax
    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.
    lv_due = lv_due + lst_vbrp-kzwi2.

    CLEAR lst_final_soc.
    READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR: lv_flag_di,
              lv_flag_ph.
      IF lst_mara-ismmediatype EQ 'DI'.
        lv_flag_di = abap_true.
      ELSEIF lst_mara-ismmediatype EQ 'PH'.
        lv_flag_ph = abap_true.
      ENDIF. " IF lst_mara-ismmediatype EQ 'DI'

      CLEAR : lv_name,
              lv_name_issn,
              lv_pnt_issn,
              v_subscription_typ.
      IF lv_flag_di EQ abap_true.
        lv_name = lc_digt_subsc.
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_digissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

      ELSEIF lv_flag_ph EQ abap_true.
        lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_pntissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX


      ELSE. " ELSE -> IF lv_flag_di EQ abap_true
        lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
        PERFORM f_get_subscrption_type USING lv_name
                                             st_header
                                    CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
        lv_name_issn = lc_combissn.
        PERFORM f_get_text_val USING lv_name_issn
                                     st_header
                            CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

      ENDIF. " IF lv_flag_di EQ abap_true

      CLEAR lst_final_soc.
      IF lst_vbrp-uepos IS INITIAL. "Added by MODUTTA on 07/03/18
        lst_final_soc-description = v_subscription_typ.
        APPEND lst_final_soc TO fp_i_final_soc.
      ENDIF. " IF lst_vbrp-uepos IS INITIAL
    ENDIF. " IF sy-subrc EQ 0

*** BOC by MODUTTA on 01/02/2018 for CR#_XXX
    IF lst_vbrp-uepos IS INITIAL.
** Total of Issues, Start Volume, Start Issue
*Multi-Year Subs
*- Begin of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
      IF  ( v_auart_tmp NOT IN r_document_type OR lst_vbrp-pstyv NOT IN r_document_catg OR lst_vbrp-mvgr5 NOT IN r_material_group ).
*- End of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*      lv_name = lc_mlsubs. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
        lv_name = c_sub_term. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
        CLEAR: lst_final_soc.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_mlsub.
        READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_vbrp-aubel
                                                       vposn = lst_vbrp-aupos
                                                       BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE i_tvlzt INTO DATA(lst_tvlzt) WITH KEY spras = st_header-language
                                                           vlaufk = lst_veda-vlaufk
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0
            AND lst_tvlzt-bezei IS NOT INITIAL.
            CONCATENATE lv_mlsub lst_tvlzt-bezei INTO lst_final_soc-description SEPARATED BY lc_colon.
            APPEND lst_final_soc TO fp_i_final_soc.
            CLEAR lst_final_soc.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_vbrp-uepos IS INITIAL
    ENDIF. "ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
    READ TABLE li_vbrp_tmp1  WITH KEY uepos = lst_vbrp-posnr TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_bhf = abap_true.
    ENDIF. " IF sy-subrc = 0
    IF lv_bhf IS INITIAL.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description

*     Total of issues
      IF lst_mara-ismhierarchlevl EQ '2'.
* SOC by NPOLINA ED1K909026  INC0216814
*        READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara-matnr.
        READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY posnr = lst_vbrp-posnr
                                                                 matnr = lst_mara-matnr BINARY SEARCH.
* EOC by NPOLINA ED1K909026  INC0216814
        IF sy-subrc EQ 0.
          DATA(lst_issue_vol) = lst_issue_vol2.
        ENDIF. " IF sy-subrc EQ 0
      ELSEIF lst_mara-ismhierarchlevl EQ '3'.
        lst_issue_vol-stvol = lst_mara-ismcopynr.
        lst_issue_vol-noi = '1'.
        lst_issue_vol-stiss = lst_mara-ismnrinyear.
      ENDIF. " IF lst_mara-ismhierarchlevl EQ '2'

***Year
*      lv_name = lc_year. "CR-7841:SGUDA:30-Apr-2019:ED1K910147
      lv_name = c_cntr_start. ""CR-7841:SGUDA:30-Apr-2019:ED1K910147
      CLEAR lst_final_soc.
      PERFORM f_get_text_val USING lv_name
                                   st_header
                          CHANGING lv_year.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
      lv_name = c_cntr_end.
      PERFORM f_get_text_val USING lv_name
                                   st_header
                          CHANGING v_cntr_end.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
* Begin of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026

*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
*      READ TABLE i_veda ASSIGNING FIELD-SYMBOL(<lfs_veda>) WITH KEY vbeln = lst_vbrp-vgbel
*                                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.
      READ TABLE i_veda INTO DATA(ls_veda) WITH KEY vbeln = lst_vbrp-vgbel
                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        CLEAR :v_start_year1.
*        v_start_year1 = <lfs_veda>-vbegdat+0(4).
*      ENDIF.
      IF ls_veda-vbegdat IS INITIAL.
        READ TABLE i_veda INTO ls_veda WITH KEY vbeln = lst_vbrp-vgbel
                                                vposn = c_posnr BINARY SEARCH.

      ENDIF.
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
      IF fp_st_vbrk-fkart IN r_bill_doc_type_zibp.
        READ TABLE i_vbkd INTO DATA(lst_vbkd_tmp) WITH KEY vbeln = lst_vbrp-vgbel
                                                       posnr = lst_vbrp-vgpos BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE i_fplt INTO DATA(lst_fplt) WITH KEY fplnr = lst_vbkd_tmp-fplnr
                                                         afdat = fp_st_vbrk-fkdat.
          IF sy-subrc EQ 0.
            ls_veda-vbegdat = lst_fplt-nfdat.
            ls_veda-venddat = lst_fplt-fkdat.
          ENDIF.
        ENDIF.
      ENDIF.
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207

*      IF v_start_year1 IS NOT INITIAL.
*        CONCATENATE lv_year v_start_year1 INTO lst_final_soc-description SEPARATED BY lc_colon.
** End of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
*        CONDENSE lst_final_soc-description.
*        APPEND lst_final_soc-description TO fp_i_final_soc.
*        CLEAR lst_final_soc.
*      ENDIF. " IF v_start_year IS NOT INITIAL
*- Begin of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
      IF  ( v_auart_tmp NOT IN r_document_type OR lst_vbrp-pstyv NOT IN r_document_catg OR lst_vbrp-mvgr5 NOT IN r_material_group ).
*- End of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
        IF ls_veda-vbegdat IS NOT INITIAL.
          CLEAR : v_year_2,v_cntr_month,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
          CONCATENATE lv_year lc_colon INTO v_year_2.
          CONDENSE v_year_2.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = ls_veda-vbegdat
            IMPORTING
              day                           = v_day
              month                         = v_month
              year                          = v_year2
              stext                         = v_stext
              ltext                         = v_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
          CONDENSE v_cntr.
          CONCATENATE v_year_2 v_cntr INTO lst_final_soc-description.
          CONDENSE lst_final_soc-description.
          APPEND lst_final_soc-description TO fp_i_final_soc.
          CLEAR lst_final_soc.
        ENDIF.
        IF ls_veda-venddat IS NOT INITIAL..
          CLEAR : v_year_2,v_cntr_month,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
          CONCATENATE v_cntr_end lc_colon INTO v_year_2.
          CONDENSE v_year_2.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = ls_veda-venddat
            IMPORTING
              day                           = v_day
              month                         = v_month
              year                          = v_year2
              stext                         = v_stext
              ltext                         = v_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
          CONDENSE v_cntr.
          CONCATENATE v_year_2 v_cntr INTO lst_final_soc-description.
          CONDENSE lst_final_soc-description.
          APPEND lst_final_soc-description TO fp_i_final_soc.
          CLEAR lst_final_soc.
        ENDIF.
      ENDIF. "ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
*     Start Volume
      IF lst_issue_vol IS NOT INITIAL.
        lv_name = lc_volume.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_volum.

        IF lst_issue_vol-stvol IS NOT INITIAL.
          CONCATENATE lv_volum lst_issue_vol-stvol INTO lv_issue_des SEPARATED BY space.
          IF lst_final_soc-description  IS NOT INITIAL.
            CONCATENATE lst_final_soc-description lc_comma lv_issue_des INTO lst_final_soc-description.
          ELSE. " ELSE -> IF lst_final_soc-description IS NOT INITIAL
            lst_final_soc-description = lv_issue_des.
          ENDIF. " IF lst_final_soc-description IS NOT INITIAL
          CONDENSE lst_final_soc-description.
        ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

*       Total Issue
        lv_name = lc_issue.
        CLEAR: lv_issue, lv_issue_des.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_issue.
        IF lst_issue_vol-noi IS NOT INITIAL.
          MOVE lst_issue_vol-noi TO lv_vol.
          CONCATENATE lv_vol lv_issue INTO lv_issue_des SEPARATED BY space.
          IF lst_final_soc-description  IS NOT INITIAL.
            CONCATENATE lst_final_soc-description lc_comma lv_issue_des INTO lst_final_soc-description.
          ELSE. " ELSE -> IF lst_final_soc-description IS NOT INITIAL
            lst_final_soc-description = lv_issue_des.
          ENDIF. " IF lst_final_soc-description IS NOT INITIAL
          CONDENSE lst_final_soc-description.
        ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL
      ENDIF. " IF lst_issue_vol IS NOT INITIAL

      IF lst_final_soc-description IS NOT INITIAL.
        CONDENSE lst_final_soc.
        APPEND lst_final_soc TO fp_i_final_soc.
        CLEAR lst_final_soc.
      ENDIF. " IF lst_final_soc-description IS NOT INITIAL

**Start Issue
      IF lst_issue_vol IS NOT INITIAL.
        lv_name = lc_stissue.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_issue.

        IF lst_issue_vol-stiss IS NOT INITIAL.
          CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_final_soc-description SEPARATED BY space.
          CONDENSE lst_final_soc-description.
          APPEND lst_final_soc TO fp_i_final_soc.
          CLEAR lst_final_soc.
        ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
      ENDIF. " IF lst_issue_vol IS NOT INITIAL

****ISSN
      CLEAR: lst_final_soc.
      READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                 idcodetype = v_idcodetype_1 "(++ BOC by SRBOSE for CR_XXX)
                                                                 BINARY SEARCH.
      IF sy-subrc EQ 0 AND
         lst_jptidcdassign-identcode IS NOT INITIAL.
*        lv_name = lc_pntissn.
*        PERFORM f_get_text_val USING lv_name
*                                     st_header
*                            CHANGING lv_pnt_issn.
*** Begin of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
*        CONCATENATE lv_pnt_issn
*                    lst_jptidcdassign-identcode
*               INTO lst_final_soc-description
*          SEPARATED BY lc_colon.
        lst_final_soc-description = lst_jptidcdassign-identcode.
*** End of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
        CONDENSE lst_final_soc-description.
        APPEND lst_final_soc TO fp_i_final_soc.

      ENDIF. " IF sy-subrc EQ 0 AND
    ENDIF. " IF lv_bhf IS INITIAL
*     End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
    READ TABLE li_vbrp_tmp2 WITH KEY posnr = lst_vbrp-posnr TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_lcf = abap_true.
    ENDIF. " IF sy-subrc = 0
*--Commented on 2/26/19 --- CR#6376
*    * BOC: CR#6376 KJAGANA20181122  ED2K913919 "Prabhu 6376
*get the member ship type and its description based on material group5,
*and customer type either summary invoice or detail invoice.
*    PERFORM get_membership_type USING c_membership_type "get_membership_type_detail USING c_membership_type
*                                      lc_text_id
*                                      i_vbkd
*                                      lst_vbrp
*                                      st_kna1
*                                CHANGING "lv_flag_mg
*                                         "lv_flag_inv
*                                         lv_member_type
*                                         lv_desc.
**    * EOC: CR#6376 KJAGANA20181122  ED2K913919
*--Commented on 2/26/19 --- CR#6376
    IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL ).
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
***************** BOC by MODUTTA on 14/09/2017 for ERP 4400*********************
      CLEAR: lst_final_soc.
      READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                     BINARY SEARCH.

      IF sy-subrc IS INITIAL.
**--Commented on 2/26/19 --- CR#6376
** BOC: CR#6376 KJAGANA20181123  ED2K913919
** Pass the member ship type value to final internal table.
*        IF lv_flag_mg EQ c_x AND lv_flag_inv EQ c_x. "Prabhu CR 6376
*        lst_final_soc-description = lv_desc."lst_vbkd-kdkg2.
*        IF lv_member_type IS NOT INITIAL.
*          CONCATENATE lv_member_type
*                      lst_final_soc-description
*                 INTO lst_final_soc-description
*            SEPARATED BY space.
*        ENDIF."IF lv_member_type IS NOT INITIAL.
*        APPEND lst_final_soc TO fp_i_final_soc.
*        ENDIF."IF lv_flag_mg EQ c_x AND lv_flag_inv EQ c_x.
** EOC: CR#6376 KJAGANA20181123  ED2K913919

        lst_final_soc-description = lst_vbkd-ihrez.
*       Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        CLEAR lv_sub_ref_id.
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
        READ TABLE i_vbap INTO DATA(lsi_vbap) WITH KEY vbeln = lst_vbrp-aubel
                                                       posnr = lst_vbrp-aupos
                                                       BINARY SEARCH.
        IF sy-subrc = 0.
          IF r_mat_grp5[] IS NOT INITIAL AND
             lsi_vbap-mvgr5 IN r_mat_grp5.
            PERFORM f_read_sub_type  USING c_membership_number
                                           lc_text_id
                                  CHANGING lv_sub_ref_id.
          ENDIF.
          CLEAR lsi_vbap.
        ENDIF.
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
        " Below IF Condition is added as part of CR#7730 changes. KKRAVURI20181015  ED2K913596
        " Before CR#7730 changes, no IF lv_sub_ref_id IS INITIAL condition
        IF lv_sub_ref_id IS INITIAL.
          PERFORM f_read_sub_type USING    lc_sub_ref_id
                                           lc_text_id
                                  CHANGING lv_sub_ref_id.
        ENDIF. " lv_sub_ref_id IS INITIAL
        IF lv_sub_ref_id IS NOT INITIAL.
          CONCATENATE lv_sub_ref_id
                      lst_final_soc-description
                 INTO lst_final_soc-description
            SEPARATED BY space.
        ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*       End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
        APPEND lst_final_soc TO fp_i_final_soc.
*        ENDIF."IF lv_flag_mg EQ c_x AND lv_flag_inv EQ c_x.
      ENDIF. " IF sy-subrc IS INITIAL
***************** EOC by MODUTTA on 14/09/2017 for ERP 4400*********************
*- Begin of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
      READ TABLE i_vbap INTO DATA(lsii_vbap) WITH KEY vbeln = lst_vbrp-aubel
                                                     posnr = lst_vbrp-aupos
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0 AND ( lsii_vbap-mvgr5 = c_in OR lsii_vbap-mvgr5 = c_of ).
        CLEAR : v_society_logo, v_society_text.
        READ TABLE i_vbkd INTO DATA(lst1_vbkd) WITH KEY vbeln = lsii_vbap-vbeln
                                                       posnr = lsii_vbap-posnr
                                                       BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE li_tvkgg INTO DATA(lst_tvkgg) WITH KEY spras = st_header-language
                                                            kdkgr = lst1_vbkd-kdkg2
                                                            BINARY SEARCH.
          IF sy-subrc EQ 0.
            CLEAR: lv_name,lv_memb_type.
            lv_name = c_mem_type.
            PERFORM f_get_text_val USING lv_name
                                         st_header
                                CHANGING lv_memb_type.
            IF lv_memb_type IS NOT INITIAL.
              CONDENSE lst_tvkgg-vtext.  "CR-7282:nrmodugu : 28-May-2019 ED1K910234
              CONCATENATE lv_memb_type  lst_tvkgg-vtext INTO  lst_final_soc-description SEPARATED BY space.
              APPEND lst_final_soc TO fp_i_final_soc.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*- END of ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
**BOC by MODUTTA on 08/08/2017 for CR# 408
      IF st_header-buyer_reg IS INITIAL.
        READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                             doc_line_number = lv_doc_line
                                                             BINARY SEARCH.
        IF sy-subrc EQ 0.
          CLEAR lst_final_soc.
          lst_final_soc-description = lst_tax_data-buyer_reg.
          IF lst_final_soc-description IS NOT INITIAL.
            CONCATENATE lv_text lst_final_soc-description INTO lst_final_soc-description SEPARATED BY space.
            CONDENSE lst_final_soc-description.
          ENDIF. " IF lst_final_soc-description IS NOT INITIAL
          APPEND lst_final_soc TO fp_i_final_soc.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-buyer_reg IS INITIAL
**EOC by MODUTTA on 08/08/2017 for CR# 408
    ENDIF. " IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )

    CLEAR : lst_final_soc,
            lv_fees,
            lv_disc,
            lv_tax,
            lst_issue_vol,
            lst_issue_vol2,
            lv_total,
            lv_bhf,
            lv_lcf,
            lv_total_val.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)

***BOC SRBOSE
  IF i_subtotal IS INITIAL.
    lst_subtotal-desc         = lv_text.
    lst_subtotal-vat_tax_val  = v_sales_tax.
    APPEND lst_subtotal TO i_subtotal.
  ENDIF. " IF i_subtotal IS INITIAL
***EOC SRBOSE

*  BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
*    BOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
*    CONCATENATE lv_text v_seller_reg INTO v_seller_reg SEPARATED BY lc_colon.
*    EOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
    CONDENSE v_seller_reg.
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
* Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* ELSEIF st_header-bill_country EQ st_header-ship_country.
* End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
* End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
  ENDIF. " IF v_seller_reg IS NOT INITIAL
*    EOC by SRBOSE.
* Subtotal
  v_subtotal_val = st_vbrk-netwr. " SubTotal Amount

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_vbrk-zlsch EQ 'J'
    OR st_vbrk-zlsch EQ 'U'. "ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502.
    fp_v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'
* Begin of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
* Total due amount Without Prepaid amount
  IF v_credit_memo = c_o.
    v_totaldue_val = v_subtotal_val + v_sales_tax.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSEIF v_credit_memo IN r_cinv.   " cancelled invoice
    v_totaldue_val = v_subtotal_val + v_sales_tax.
  ELSEIF v_credit_memo IN r_ccrd.   " cancelled credit memo
    v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
  ELSE.
* End of change ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
* Total due amount with Prepaid Amount
    v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.
  ENDIF. "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657

  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_header-doc_currency.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_TO_BINARY
*&---------------------------------------------------------------------*
FORM f_convert_pdf_to_binary.
******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = st_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*  Attach PDF in mail body
*----------------------------------------------------------------------*
FORM f_mail_attachment.

* Data declaration
  DATA : lr_sender  TYPE REF TO if_sender_bcs VALUE IS INITIAL, " Interface of Sender Object in BCS
         lv_sub     TYPE char30,                                " Sub of type CHAR15
         lv_subject TYPE so_obj_des,                            " Short description of contents
         li_lines   TYPE STANDARD TABLE OF tline,               " SAPscript: Text Lines
*        Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
         lv_xstring TYPE xstring,
         li_output  TYPE ztqtc_output_supp_retrieval,
         li_hex_cnt TYPE solix_tab, " Content table
*        End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
         t_hex      TYPE solix_tab,
         lst_lines  TYPE tline, " SAPscript: Text Lines
*        Begin of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907145
         lv_upd_tsk TYPE i, " Upd_tsk of type Integers
*        End   of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907145
*        Begin of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
         lv_title   TYPE char255. " Title of type CHAR255
*        End of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208

* Constant Declaration
  CONSTANTS : lc_raw  TYPE so_obj_tp      VALUE 'RAW',                        " Code for document class
              lc_pdf  TYPE so_obj_tp      VALUE 'PDF',                        " Code for document class
              lc_i    TYPE bapi_mtype     VALUE 'I',                          " Message type: S Success, E Error, W Warning, I Info, A Abort
              lc_name TYPE thead-tdname   VALUE 'ZQTC_EMAILBODY_OUTPUT_F024'. " Name

  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service

  DATA lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL. " Business Communication Service
* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL. " Interface of Recipient Object in BCS

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_name
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lst_message_body-line = lst_lines-tdline.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0

* Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
*  lv_sub = 'Wiley Invoice'.

* If total due is 0, then email tilte will be Wiley Receipt
* Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227
*  IF v_totaldue_val LE 0.
*    PERFORM f_read_text    USING c_wiley_rec
*                        CHANGING lv_title.
*    lv_sub = lv_title.
** For credit memo, the email tilte will be Wiley Credit
*  ELSEIF st_vbrk-vbtyp IN r_crd.
*    PERFORM f_read_text    USING c_wiley_crd
*                        CHANGING lv_title.
*    lv_sub = lv_title.
** For debit memo, the email tilte will be Wiley Debit
*  ELSEIF st_vbrk-vbtyp IN r_dbt.
*    PERFORM f_read_text    USING c_wiley_dbt
*                        CHANGING lv_title.
*    lv_sub = lv_title.
***Begin of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
*  ELSEIF st_vbrk-fkart EQ v_faz.
*    PERFORM f_read_text    USING "c_wiley_pro
*                                  c_wiley_inv
*                CHANGING lv_title.
*    lv_sub = lv_title.
** End of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
** For invoice, the email tilte will be Wiley Invoice
*  ELSEIF st_vbrk-vbtyp IN r_inv.
*    PERFORM f_read_text    USING c_wiley_inv
*                        CHANGING lv_title.
*    lv_sub = lv_title.
*  ENDIF. " IF v_totaldue_val LE 0
  lv_sub = v_accmngd_title.
* Begin of ADD:ERP-5271:WROY:22-Nov-2017:ED2K909551
  CONCATENATE 'Wiley'(s01) lv_sub INTO lv_sub SEPARATED BY space.
* End   of ADD:ERP-5271:WROY:22-Nov-2017:ED2K909551
* End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909227

  CONCATENATE lv_sub st_header-invoice_number INTO lv_subject SEPARATED BY space.

  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw " RAW
        i_text = li_message_body
        i_hex = t_hex
      i_subject = lv_subject ).
    CATCH cx_document_bcs.
    CATCH cx_send_req_bcs.
  ENDTRY.
  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions


  IF i_emailid[] IS NOT INITIAL.
    TRY.
        lr_document->add_attachment(
        EXPORTING
        i_attachment_type = lc_pdf "PDF
        i_attachment_subject = lv_subject
        i_att_content_hex = i_content_hex ).
      CATCH cx_document_bcs INTO lx_document_bcs.
    ENDTRY.

* Add attachment
    TRY.
        CALL METHOD lr_send_request->set_document( lr_document ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

*   Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
    IF i_input IS NOT INITIAL.
*     Call FM to get the list of PDF attachments for the particular material
*     and attachment name ending with KDKG1
      CALL FUNCTION 'ZQTC_OUTPUT_SUPP_RETRIEVAL'
        EXPORTING
          im_input  = i_input
          im_auart  = v_auart
        IMPORTING
          ex_output = li_output.
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
      IF i_output[] IS NOT INITIAL.
        LOOP AT i_output INTO DATA(lst_output_t).
          APPEND lst_output_t TO li_output.
          CLEAR lst_output_t.
        ENDLOOP.
      ENDIF.
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
      LOOP AT li_output ASSIGNING FIELD-SYMBOL(<lst_output>).
        CLEAR: li_hex_cnt.
        lv_xstring = <lst_output>-pdf_stream.
*       Convert PDF to Binary
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer     = lv_xstring
          TABLES
            binary_tab = li_hex_cnt.
        IF li_hex_cnt IS NOT INITIAL.
          TRY.
              lr_document->add_attachment(
              EXPORTING
              i_attachment_type = lc_pdf "PDF
              i_attachment_subject = <lst_output>-attachment_name+0(50)
              i_att_content_hex = li_hex_cnt ).
            CATCH cx_document_bcs INTO lx_document_bcs.
          ENDTRY.
        ENDIF. " IF li_hex_cnt IS NOT INITIAL
      ENDLOOP. " LOOP AT li_output ASSIGNING FIELD-SYMBOL(<lst_output>)
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
    ELSEIF i_output IS NOT INITIAL.
      LOOP AT i_output ASSIGNING FIELD-SYMBOL(<lst_output1>).
        CLEAR: li_hex_cnt.
        lv_xstring = <lst_output1>-pdf_stream.
*       Convert PDF to Binary
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer     = lv_xstring
          TABLES
            binary_tab = li_hex_cnt.
        IF li_hex_cnt IS NOT INITIAL.
          TRY.
              lr_document->add_attachment(
              EXPORTING
              i_attachment_type = lc_pdf "PDF
              i_attachment_subject = <lst_output1>-attachment_name+0(50)
              i_att_content_hex = li_hex_cnt ).
            CATCH cx_document_bcs INTO lx_document_bcs.
          ENDTRY.
        ENDIF. " IF li_hex_cnt IS NOT INITIAL
      ENDLOOP. " LOOP AT li_output ASSIGNING FIELD-SYMBOL(<lst_output>)
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
    ENDIF. " IF i_input IS NOT INITIAL
*   End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425

    TRY.
* Pass the document to send request
        lr_send_request->set_document( lr_document ).

* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).

      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
* Create recipient
        LOOP AT i_emailid INTO DATA(lst_emailid).
          lr_recipient = cl_cam_address_bcs=>create_internet_address( lst_emailid-smtp_addr ).
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        ENDLOOP. " LOOP AT i_emailid INTO DATA(lst_emailid)
      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
* Send email
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.
*   Begin of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907145
*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0
*   End   of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907145
  ENDIF. " IF i_emailid[] IS NOT INITIAL
  CLEAR:i_output[]. "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PREPAID_AMOUNT
*&---------------------------------------------------------------------*
*  Calculate Prepaid/Advance amount
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK           Header billing document
*      <--FP_V_PREPAID_AMOUNT  Prepaid amont
*      <--FP_V_PAID_AMT        Prepaid Amount
*----------------------------------------------------------------------*
FORM f_get_prepaid_amount  USING    fp_st_vbrk           TYPE ty_vbrk
                           CHANGING fp_v_prepaid_amount  TYPE char20 " V_prepaid_amount of type CHAR20
                                    fp_v_paid_amt        TYPE autwr. " Payment cards: Authorized amount

* Constant declaration
  CONSTANTS : lc_zpay  TYPE kschl VALUE 'ZPAY', " Condition Type
* Begin of ADD:ERP-6663:WROY:15-Feb-2018:ED2K910930
              lc_bs_c  TYPE fksaf VALUE 'C', " Billing status for the billing plan/invoice plan date
* End   of ADD:ERP-6663:WROY:15-Feb-2018:ED2K910930
* Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
              lc_stats TYPE kowrr VALUE 'Y',  " No cumulation - Values can be used statistically
              lc_dpmnt TYPE char2 VALUE '45', " Down payment in milestone billing on percentage / value basis
              lc_dcinv TYPE vbtyp VALUE 'M',  " Document Category: Invoice
              lc_bcdpr TYPE fktyp VALUE 'P',  " Billing Category: Down payment request
* End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
              lc_comma TYPE char01 VALUE ','. " Comma of type CHAR01

* Data Declaration
  DATA : lv_kwert TYPE kwert. " Condition value

* Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
  DELETE i_vbrp WHERE kowrr EQ lc_stats
                  AND fareg CA lc_dpmnt.
  IF sy-subrc EQ 0.
    SELECT f~vbelv,	  "Preceding sales and distribution document
           f~posnv,	  "Preceding item of an SD document
           f~vbeln,	  "Subsequent sales and distribution document
           f~posnn,	  "Subsequent item of an SD document
           f~vbtyp_n, "Document category of subsequent document
           f~fktyp,   "Billing category
           p~netwr,   "Net value of the billing item in document currency
           p~mwsbp    "Tax amount in document currency
      FROM vbfa AS f
     INNER JOIN vbrp AS p
        ON p~vbeln EQ f~vbeln
       AND p~posnr EQ f~posnn
      INTO TABLE @DATA(li_dwn_pmnt)
       FOR ALL ENTRIES IN @i_vbrp
     WHERE f~vbelv   EQ @i_vbrp-aubel
       AND f~posnv   EQ @i_vbrp-aupos
       AND f~vbtyp_n EQ @lc_dcinv
       AND f~fktyp   EQ @lc_bcdpr.
    IF sy-subrc EQ 0.
      LOOP AT li_dwn_pmnt ASSIGNING FIELD-SYMBOL(<lst_dwn_pmnt>).
        fp_v_paid_amt = fp_v_paid_amt +
                        <lst_dwn_pmnt>-netwr +
                        <lst_dwn_pmnt>-mwsbp.
      ENDLOOP. " LOOP AT li_dwn_pmnt ASSIGNING FIELD-SYMBOL(<lst_dwn_pmnt>)
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164

  IF i_vbrp IS NOT INITIAL.
    DATA(li_vbrp) = i_vbrp.
    SORT li_vbrp BY aubel.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING aubel.
  ENDIF. " IF i_vbrp IS NOT INITIAL

  IF fp_st_vbrk-zlsch EQ '2'.
* Retrieve condition amount
    SELECT knumv " Number of the document condition
           kposn " Condition item number
           stunr " Step number
           zaehk " Condition counter
           kschl " Condition type
           kwert " Condition value
      FROM konv  " Conditions (Transaction Data)
      INTO TABLE i_konv
      WHERE knumv EQ fp_st_vbrk-knumv
        AND kschl EQ lc_zpay.

    IF sy-subrc EQ 0.
      LOOP AT i_konv INTO DATA(lst_konv).
        lv_kwert = lst_konv-kwert + lv_kwert.
      ENDLOOP. " LOOP AT i_konv INTO DATA(lst_konv)

      fp_v_paid_amt = lv_kwert.
    ENDIF. " IF sy-subrc EQ 0

  ELSEIF fp_st_vbrk-zlsch EQ '1'.
*    SELECT SINGLE autwr " Payment cards: Authorized amount
*        INTO @DATA(lv_autwr)
*      FROM fpltc        " Payment cards: Transaction data - SD
*      WHERE fplnr EQ @fp_st_vbrk-rplnr.
******BOC by MODUTTA for CR# 558 on 08/08/2017***********************

    SELECT fplnr, "++SRBOSE Cr_558: TR# ED2K908301
           vbeln  " Sales and Distribution Document Number
      INTO TABLE @DATA(li_fpla)
      FROM fpla   " Billing Plan
      FOR ALL ENTRIES IN @li_vbrp
      WHERE vbeln = @li_vbrp-aubel.
    IF sy-subrc IS INITIAL.
*     Begin of DEL:ERP-6663:WROY:15-Feb-2018:ED2K910930
*     SELECT fplnr,
*            fpltr,
*            ccnum,
*            autwr " Payment cards: Authorized amount
*       INTO TABLE @i_fpltc
*       FROM fpltc " Payment cards: Transaction data - SD
*       FOR ALL ENTRIES IN @li_fpla
**     WHERE fplnr = @fp_st_vbrk-rplnr.
*       WHERE fplnr = @li_fpla-fplnr.
*     Begin of DEL:ERP-6663:WROY:15-Feb-2018:ED2K910930
*     Begin of ADD:ERP-6663:WROY:15-Feb-2018:ED2K910930
      SELECT fpltc~fplnr,
             fpltc~fpltr,
             fpltc~ccnum,
             fpltc~autwr " Payment cards: Authorized amount
        INTO TABLE @i_fpltc
        FROM fpltc       " Payment cards: Transaction data - SD
  INNER JOIN fplt        " Billing Plan: Dates
          ON fplt~fplnr EQ fpltc~fplnr
         AND fplt~fpltr EQ fpltc~fpltr
        FOR ALL ENTRIES IN @li_fpla
        WHERE fpltc~fplnr = @li_fpla-fplnr
          AND fplt~fksaf  = @lc_bs_c.
*     End   of ADD:ERP-6663:WROY:15-Feb-2018:ED2K910930
      IF sy-subrc IS INITIAL.
        DATA(li_fpltc) = i_fpltc.
        SORT li_fpltc BY ccnum.
        DELETE ADJACENT DUPLICATES FROM li_fpltc COMPARING ccnum.
        LOOP AT i_fpltc INTO DATA(lst_fpltc).
          IF lst_fpltc-autwr IS NOT INITIAL.
*           Begin of DEL:ERP-6595:WROY:12-Feb-2018:ED2K910861
*           AND fp_v_paid_amt IS INITIAL.
*           fp_v_paid_amt =  lst_fpltc-autwr.
*           End   of DEL:ERP-6595:WROY:12-Feb-2018:ED2K910861
*           Begin of ADD:ERP-6595:WROY:12-Feb-2018:ED2K910861
            fp_v_paid_amt = fp_v_paid_amt + lst_fpltc-autwr.
*           End   of ADD:ERP-6595:WROY:12-Feb-2018:ED2K910861
          ENDIF. " IF lst_fpltc-autwr IS NOT INITIAL
          READ TABLE li_fpltc INTO DATA(lst_fpltc1) WITH KEY fplnr = lst_fpltc-fplnr
                                                             fpltr = lst_fpltc-fpltr
                                                              BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF lst_fpltc1-ccnum IS NOT INITIAL.
              DATA(lv_length) = strlen( lst_fpltc1-ccnum ).
              lv_length = lv_length - 4.
              IF lv_length GE 4.
                IF v_ccnum IS INITIAL.
                  CONCATENATE lst_fpltc1-ccnum+lv_length(4) v_ccnum INTO v_ccnum.
                ELSE. " ELSE -> IF v_ccnum IS INITIAL
                  CONCATENATE lst_fpltc1-ccnum+lv_length(4) v_ccnum INTO v_ccnum SEPARATED BY lc_comma.
                ENDIF. " IF v_ccnum IS INITIAL
              ENDIF. " IF lv_length GE 4
            ENDIF. " IF lst_fpltc1-ccnum IS NOT INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
        ENDLOOP. " LOOP AT i_fpltc INTO DATA(lst_fpltc)
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc IS INITIAL
******EOC by MODUTTA for CR# 558 on 08/08/2017***********************
* Begin of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208
    IF v_output_typ EQ v_outputyp_soc.
      CLEAR st_header-terms.
    ENDIF. " IF v_output_typ EQ v_outputyp_soc
* End of change: PBOSE: 25-May-2017: DEFECT 2319: ED2K906208

  ELSE. " ELSE -> IF fp_st_vbrk-zlsch EQ '2'
    CONDENSE fp_v_prepaid_amount.
  ENDIF. " IF fp_st_vbrk-zlsch EQ '2'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*  Subroutine to clear all the global variables
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_clear.

* Refresh global variable
*  CLEAR : v_xstring,
*          st_vbrk,
*          i_vbrp,
*          i_vbpa,
*          st_vbco3,
*          v_output_typ,
*          v_proc_status,
*          v_outputyp_css,
*          v_outputyp_tbt,
*          v_outputyp_soc,
*          r_inv,
*          r_crd,
*          r_dbt,
*          r_country,
*          i_jptidcdassign,
*          i_mara,
*          i_vbfa,
*          i_vbkd,
*          st_kna1,
*          st_header,
*          i_adrc,
*          i_emailid,
*          v_accmngd_title,
*          v_tax,
*          v_remit_to,
*          v_footer,
*          v_country_key,
*          v_bank_detail,
*          v_crdt_card_det,
*          v_payment_detail,
*          v_cust_service_det,
*          v_totaldue,
*          v_subtotal,
*          v_prepaidamt,
*          v_shipping_val,
*          v_vat,
*          v_prepaid_amount,
*          v_paid_amt,
*          i_final_css,
*          i_final_tbt,
*          i_final_soc.


  CLEAR :  i_vbrp             ,
           i_vbpa             ,
           i_vbfa             ,
           i_veda,
           i_vbap,
           i_txtmodule        ,
           i_konv             ,
           i_adrc             ,
           i_jptidcdassign    ,
           i_mara             ,
           i_emailid          ,
           i_vbkd             ,
           i_content_hex      ,
           i_final_css        ,
           i_final_tbt        ,
           i_final_soc        ,
           r_inv              ,
           r_crd              ,
           r_dbt              ,
           r_country          ,
           st_header_text     ,
           st_header          ,
           st_kna1            ,
           st_item            ,
           i_item_text        ,
           i_tax_item         ,
           st_formoutput      ,
           st_vbrk            ,
           st_vbco3           ,
           st_but000          ,
           st_but020          ,
*          Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
           i_input            ,
           v_auart            ,
*          End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
           v_xstring          ,
           v_accmngd_title    ,
           v_reprint          ,
           v_remit_to         ,
           v_footer           ,
           v_tax              ,
           v_bank_detail      ,
           v_formname         ,
           v_country_key      ,
           v_society_text     ,
           v_totaldue         ,
           v_subtotal         ,
           v_vat              ,
           v_shipping         ,
           v_proc_status      ,
           v_society_logo     ,
           v_bill_cntry       ,
           v_txt_name         ,
           v_output_typ       ,
           v_outputyp_css     ,
           v_outputyp_tbt     ,
           v_outputyp_soc     ,
           v_crdt_card_det    ,
           v_prepaidamt       ,
           v_text_line        ,
           v_payment_detail   ,
           v_subscription_typ ,
           v_prepaid_amount   ,
           v_cust_service_det ,
           v_subtotal_val     ,
           v_sales_tax        ,
           v_totaldue_val     ,
           v_shipping_val     ,
           v_paid_amt         ,
           v_ent_retco        ,
           v_faz              ,
           v_vkorg            ,
           v_title            ,
*          Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*          v_ent_screen       ,
*          v_bstzd_flag       ,
*          End   of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
           v_seller_reg       ,
           i_tax_data         ,
           v_ind              ,
           i_fpltc            ,
           v_credit_text      ,
           i_credit           ,
           v_ccnum            ,
           i_terms_text       ,
           i_text_item        ,
           v_terms_cond       ,
           v_idcodetype_2     ,
           v_idcodetype_1     ,
           v_invoice_desc     ,
           i_exc_tab,
*           st_iss_vol2        ,
           i_iss_vol2         ,
*           st_iss_vol3        ,
           i_iss_vol3         ,
           r_mat_grp5,          " ADD: CR#7730 KKRAVURI20181015
           v_receipt_flag,      " ADD: CR#7431&7189  KKRAVURI  ED2K913809
           v_barcode,           " ADD: CR#7431&7189  KKRAVURI  ED2K913809
           r_bill_doc_type[],   " ADD: CR#7431&7189  KKRAVURI  ED2K913896
           r_doc_type[],        "ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502
           r_pay_method[].      "ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919502

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT_VAL
*&---------------------------------------------------------------------*
* Get standard text values
*----------------------------------------------------------------------*
*      -->P_LV_NAME  text
*      -->P_ST_HEADER  text
*      <--P_LV_YEAR  text
*----------------------------------------------------------------------*
FORM f_get_text_val  USING    fp_lv_name   TYPE thead-tdname              " Name
                              fp_st_header TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                     CHANGING fp_lv_value  TYPE char30.                   " Lv_value of type CHAR10

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_lv_name
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_lv_value = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_JPTIDCDASSIGN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBRP  text
*      <--P_I_JPTIDCDASSIGN  text
*----------------------------------------------------------------------*
FORM f_get_jptidcdassign  USING    fp_i_vbrp          TYPE tt_vbrp
                          CHANGING fp_i_jptidcdassign TYPE tt_jptidcdassign.

* Constant Declaration
  CONSTANTS : lc_journal TYPE ismidcodetype VALUE 'ZSSN'. " Type of Identification Code

  IF fp_i_vbrp[] IS NOT INITIAL.
    DATA(li_vbrp) = fp_i_vbrp[].
    SORT li_vbrp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING matnr.
* Fetch ID codes of material from JPTIDCDASSIGN table
    SELECT matnr         " Material Number
           idcodetype    " Type of Identification Code
           identcode     " Identification Code
      FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
      INTO TABLE fp_i_jptidcdassign
      FOR ALL ENTRIES IN li_vbrp
      WHERE matnr      EQ li_vbrp-matnr
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
*        AND idcodetype EQ lc_journal.
        AND ( idcodetype EQ v_idcodetype_1
            OR idcodetype EQ v_idcodetype_2 ).
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
    IF sy-subrc EQ 0.
      SORT fp_i_jptidcdassign BY matnr.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_vbrp.
  ENDIF. " IF fp_i_vbrp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ADDRESS
*&---------------------------------------------------------------------*
*  Get Address number related BP
*----------------------------------------------------------------------*
*      -->FP_LV_CUST_NUMBER
*      <--FP_PERSON_NUMBER_BILLTO
*      <--FP_ADD_BILLTO
*      <--FP_ST_BUT020_BILLTO
*----------------------------------------------------------------------*
FORM f_get_address  USING    fp_lv_cust_number   TYPE char10     " Get_address using fp_lv of type CHAR10
                    CHANGING fp_v_person_number  TYPE ad_persnum " Person number
                             fp_v_addr_type      TYPE char1      " V_add_billto of type CHAR1
                             fp_st_but020        TYPE ty_but020.

* Fetch values from BUT000 table
  SELECT SINGLE partner    " Business Partner Number
                type       " Business partner category
                persnumber " Person number
    FROM but000            " BP: General data I
    INTO st_but000
    WHERE partner EQ fp_lv_cust_number.

  IF sy-subrc EQ 0.
* Fetch address number from BUT020 table
    SELECT SINGLE partner    " Business Partner Number
                  addrnumber " Address number
      INTO fp_st_but020
      FROM but020            " BP: Addresses
      WHERE partner EQ st_but000-partner.
    IF sy-subrc EQ 0.
*
      IF st_but000-type EQ 1.
        CLEAR: fp_v_addr_type,
               fp_v_person_number.
        fp_v_addr_type = 2.
        fp_v_person_number = st_but000-persnumber.
      ELSEIF st_but000-type EQ 2.
        CLEAR: fp_v_addr_type,
               fp_v_person_number.
        fp_v_addr_type = 1.
        fp_v_person_number = st_but000-persnumber.
      ENDIF. " IF st_but000-type EQ 1
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_PDF_APPLICTN_SERVER
*&---------------------------------------------------------------------*
*       Save the PDF in application server
*----------------------------------------------------------------------*
FORM f_save_pdf_applictn_server .
  CONSTANTS : lc_iden          TYPE char10 VALUE 'VF', " Iden of type CHAR10
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
              lc_bus_prcs_bill TYPE zbus_prcocess VALUE 'B', " Business Process - Billing
              lc_prnt_vend_qi  TYPE zprint_vendor VALUE 'Q', " Third Party System (Print Vendor) - QuickIssue
              lc_prnt_vend_bt  TYPE zprint_vendor VALUE 'B', " Third Party System (Print Vendor) - BillTrust
*             Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
              lc_supp_doc      TYPE char2         VALUE 'SL',  " Rn of type CHAR2
              lc_sap_doc       TYPE char3         VALUE 'SAP'. " Sap of type CHAR3
*             End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425

  DATA: li_output       TYPE ztqtc_output_supp_retrieval.

  DATA: lst_output  TYPE zstqtc_output_supp_retrieval, " Output structure for E098-Output Supplement Retrieval
*       Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
        lst_pdf_rec TYPE fpformoutput. " Form Output (PDF, PDL)
*       End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583

  DATA: lv_filename     TYPE localfile, " BCOM: Text That Is to Be Converted into MIME
*       Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
        lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region, " Print Region
        lv_country_sort TYPE zcountry_sort, " Country Sorting Key
        lv_file_loc     TYPE file_no,       " Application Server File Path
*       End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583
*       Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
        lv_file_ident   TYPE char10, " Id of type CHAR10
        lv_sl_count     TYPE numc4,  " Count of type Integers
*       End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
*       Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911720
        lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
*       End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911720
        lv_amount       TYPE char24. " Amount of type CHAR24

* Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
  IF i_input IS NOT INITIAL.
*   Call FM to get the list of PDF attachments for the particular material
*   and attachment name ending with KDKG1
    CALL FUNCTION 'ZQTC_OUTPUT_SUPP_RETRIEVAL'
      EXPORTING
        im_input  = i_input
        im_auart  = v_auart
      IMPORTING
        ex_output = li_output.
  ENDIF. " IF i_input IS NOT INITIAL
* End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
  CLEAR lst_output.
  lst_output-attachment_name = 'SAP Invoice'(002).
  lst_output-pdf_stream = st_formoutput-pdf.
  INSERT lst_output INTO li_output INDEX 1.
*- Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
  IF i_output[] IS NOT INITIAL.
    LOOP AT i_output INTO DATA(lst_output_tt).
      APPEND lst_output_tt TO li_output.
      CLEAR lst_output_tt.
    ENDLOOP.
  ENDIF.
*- End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
* Determine Print Vendor
  CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
    EXPORTING
      im_bus_prcocess     = lc_bus_prcs_bill       " Business Process (Billing)
      im_country          = st_header-bill_country " Bill-to Party Country
      im_output_type      = v_output_typ           " Output Type
    IMPORTING
      ex_print_vendor     = lv_print_vendor        " Third Party System (Print Vendor)
      ex_print_region     = lv_print_region        " Print Region
      ex_country_sort     = lv_country_sort        " Country Sorting Key
      ex_file_loc         = lv_file_loc            " Application Server File Path
    EXCEPTIONS
      exc_invalid_bus_prc = 1
      exc_no_entry_found  = 2
      OTHERS              = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_print_vendor.
  ENDIF. " IF sy-subrc NE 0

* Trigger different logic based on Third Party System (Print Vendor)
  CASE lv_print_vendor.
    WHEN lc_prnt_vend_qi. " Third Party System (Print Vendor) - QuickIssue
      CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
        EXPORTING
          im_outputs           = li_output                  " PDF Contents
          im_bus_prcocess      = lc_bus_prcs_bill           " Business Process (Renewal)
          im_print_region      = lv_print_region            " Print Region
          im_country_sort      = lv_country_sort            " Country Sorting Key
          im_file_loc          = lv_file_loc                " Application Server File Path
          im_country           = st_header-bill_country     " Bill-to Party Country
          im_customer          = st_header-bill_cust_number " Bill-to Party Customer
          im_doc_number        = st_header-invoice_number   " SD Document Number (Invoice)
        EXCEPTIONS
          exc_missing_dir_path = 1
          exc_err_opening_file = 2
          OTHERS               = 3.
      IF sy-subrc NE 0.
*       Update Processing Log
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb = syst-msgid
            msg_nr    = syst-msgno
            msg_ty    = syst-msgty
            msg_v1    = syst-msgv1
            msg_v2    = syst-msgv2
          EXCEPTIONS
            OTHERS    = 0.
        IF sy-subrc EQ 0.
          v_ent_retco = 900.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc NE 0

    WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583
*     Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
      CLEAR: lv_file_ident,
             lv_sl_count.
      LOOP AT li_output INTO lst_output.
*     End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
*       Begin of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911720
*       MOVE v_totaldue_val TO lv_amount.
*       End   of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911720
*       Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911720
        lv_bapi_amount = v_totaldue_val.
*       Converts a currency amount from SAP format to External format
        CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
          EXPORTING
            currency    = st_header-doc_currency " Currency
            sap_amount  = lv_bapi_amount         " SAP format
          IMPORTING
            bapi_amount = lv_bapi_amount.        " External format
        MOVE lv_bapi_amount TO lv_amount.
*       End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911720
        CONDENSE lv_amount.

*       Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
        IF lv_file_ident IS NOT INITIAL.
          lv_sl_count = lv_sl_count + 1.
          CONCATENATE lc_supp_doc
                      lv_sl_count
                 INTO lv_file_ident.
        ELSE. " ELSE -> IF lv_file_ident IS NOT INITIAL
          lv_file_ident = lc_sap_doc.
        ENDIF. " IF lv_file_ident IS NOT INITIAL
        lst_pdf_rec-pdf = lst_output-pdf_stream.
*       End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425

        CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
          EXPORTING
*           Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            im_fpformoutput    = lst_pdf_rec
*           End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
*           Begin of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
*           im_fpformoutput    = st_formoutput
*           End   of DEL:ERP-6458:WROY:20-AUG-2018:ED2K912425
            im_customer        = st_header-acc_number
            im_invoice         = st_header-invoice_number
            im_amount          = lv_amount
            im_currency        = st_header-doc_currency
            im_date            = st_header-inv_date
            im_form_identifier = lc_iden
            im_ccode           = st_header-comp_code
*           Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
            im_file_loc        = lv_file_loc
*           End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583
*           Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            im_file_identifier = lv_file_ident
*           End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
          IMPORTING
            ex_file_name       = lv_filename.

        IF lv_filename IS NOT INITIAL.
*       no Action
        ENDIF. " IF lv_filename IS NOT INITIAL
*     Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
      ENDLOOP. " LOOP AT li_output INTO lst_output
*     End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911583
    WHEN OTHERS.
*     Nothing to Do
  ENDCASE.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911583
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_SUB_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_TXT_NAME  text
*      -->P_LV_TEXT_ID  text
*      <--P_V_TXT_LINE  text
*----------------------------------------------------------------------*
FORM f_read_sub_type  USING  fp_v_txt_name   TYPE tdobname " Name
                             fp_text_id   TYPE tdid        " Text ID
                    CHANGING fp_v_txt_line TYPE char255.   " V_text_line of type CHAR100

  CONSTANTS: lc_object TYPE tdobject VALUE 'TEXT'. " Texts: Application Object

*   Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : lv_text,
          fp_v_txt_line.

*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_text_id
      language                = st_header-language
      name                    = fp_v_txt_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      fp_v_txt_line = lv_text.
      CONDENSE fp_v_txt_line.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_FM_OUTPUT_SUPP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MATNR  text
*      -->P_LI_KDKG  text
*      <--P_LI_OUTPUT  text
*----------------------------------------------------------------------*
FORM f_call_fm_output_supp  USING    fp_i_input TYPE ztqtc_supplement_ret_input
                            CHANGING fp_li_output TYPE ztqtc_output_supp_retrieval.

  TYPES : BEGIN OF lty_constant,
            sign TYPE	tvarv_sign,	                                                                                                                                                                                      "ABAP: ID: I/E (include/exclude values)
            opti TYPE	tvarv_opti,	                                                                                                                                                                                       "ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE  salv_de_selopt_low, "Lower Value of Selection Condition
            high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          END OF lty_constant.

  DATA : li_constant TYPE STANDARD TABLE OF lty_constant,
         lv_subject  TYPE so_obj_des,                   " Short description of contents
         lst_output  TYPE zstqtc_output_supp_retrieval. " Output structure for E098-Output Supplement Retrieval

  CONSTANTS: lc_devid    TYPE zdevid         VALUE 'E098',  " Development ID
             lc_kschl    TYPE rvari_vnam     VALUE 'KSCHL', " ABAP: Name of Variant Variable
             lc_nacha_01 TYPE na_nacha       VALUE '1'.     " Message transmission medium (Print).

*** Populate Title
  CONCATENATE v_accmngd_title st_header-invoice_number INTO lv_subject SEPARATED BY space.

*** Fetch data from ZCACONSTANT
  SELECT sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_constant
    WHERE devid EQ lc_devid
    AND param1 EQ lc_kschl.
  IF sy-subrc IS INITIAL.
    SORT li_constant BY low.
  ENDIF. " IF sy-subrc IS INITIAL
  READ TABLE i_vbrp INTO DATA(lstt_vbrp) INDEX 1.
  IF st_vbrk-vkorg IN r_vkorg_f044
    AND st_vbrk-zlsch NOT IN r_zlsch_f044
    AND lstt_vbrp-kvgr1 NOT IN r_kvgr1_f044
    AND  lstt_vbrp-vkgrp IN r_frm_f044.

    v_vkorg_f044  = st_vbrk-vkorg.
    v_waerk_f044  = st_vbrk-waerk.
    v_ihrez_f044  = st_vbrk-vbeln.

    IF v_scenario_tbt = abap_true.
      v_scenario_f044 = 'TBT'.
    ELSEIF v_scenario_scc = abap_true.
      v_scenario_f044 = 'SCC'.
    ELSEIF v_scenario_scm = abap_true.
      v_scenario_f044 = 'SCM'.
    ENDIF. " IF v_scenario_tbt = abap_true

    CALL FUNCTION 'ZQTC_DIR_DEBIT_MANDT_F044'
      EXPORTING
        im_vkorg      = v_vkorg_f044
*       IM_ZLSCH      =
        im_waerk      = v_waerk_f044
        im_scenario   = v_scenario_f044
        im_ihrez      = v_ihrez_f044
        im_adrnr      = v_adrnr_f044
        im_kunnr      = v_kunnr_f044
        im_langu      = v_langu_f044
        im_xstring    = v_xstring
        im_mem_text   = v_mem_text
      IMPORTING
        ex_formoutput = st_formoutput_f044.
  ENDIF. " IF v_vkorg_f044 IN r_vkorg_f044
  IF st_formoutput_f044-pdf IS NOT INITIAL.
    CLEAR lst_output.
    lst_output-attachment_name = 'Direct Debit Mandate'.
    lst_output-pdf_stream = st_formoutput_f044-pdf.
    IF fp_li_output IS INITIAL.
      INSERT lst_output INTO fp_li_output INDEX 1.
    ELSE. " ELSE -> IF fp_li_output IS INITIAL
      INSERT lst_output INTO fp_li_output INDEX 2.
    ENDIF. " IF fp_li_output IS INITIAL
  ENDIF. " IF st_formoutput_f044-pdf IS NOT INITIAL
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_T005_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_WAERS  text
*      <--P_V_IND  text
*----------------------------------------------------------------------*
FORM f_get_t005_data  CHANGING fp_v_waers TYPE waers_005 " Country currency
                               fp_v_ind TYPE xegld.      " Indicator: European Union Member?

* Retrieve local currency from T005 table
  SELECT SINGLE xegld,
              waers " Country currency
         INTO @DATA(lst_t005)
         FROM t005  " Countries
         WHERE land1 = @st_header-bill_country.

  IF sy-subrc EQ 0.
    fp_v_ind = lst_t005-xegld.
    fp_v_waers = lst_t005-waers.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_EXC_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_exc_tab.

  DATA: lv_exc_rate TYPE ukurs_curr,       "kzwi6,            " Exchange rate
        lv_loc_amt  TYPE ukm_credit_limit. " Credit Limit
* Begin of ADD:SGUDA:ERPM-15474:9-APR-2020:ED2K917952
  CLEAR v_ref_curr.
  " Fetch Reference Currency of the Exchange Rate
  SELECT SINGLE bwaer FROM tcurv INTO v_ref_curr
                      WHERE kurst = c_excrate_typ_m.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.
* End of ADD:SGUDA:ERPM-15474:9-APR-2020:ED2K917952
* Begin of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911317
  IF st_header-doc_currency NE v_waers.
* End   of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911317
    IF v_subtotal_val IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_subtotal_val
* Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                                      v_waers
* End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_subtotal_val IS NOT INITIAL

    IF v_sales_tax IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_sales_tax
* Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                                      v_waers
* End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_sales_tax IS NOT INITIAL


    IF v_shipping_val  IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_shipping_val
* Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                                      v_waers
* End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_shipping_val IS NOT INITIAL
* Begin of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911317
  ENDIF. " IF st_header-doc_currency NE v_waers
* End   of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911317

* Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
  IF st_header-doc_currency NE v_local_curr AND
     v_waers                NE v_local_curr.
    IF v_subtotal_val IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_subtotal_val
                                      v_local_curr
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_subtotal_val IS NOT INITIAL

    IF v_sales_tax IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_sales_tax
                                      v_local_curr
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_sales_tax IS NOT INITIAL


    IF v_shipping_val  IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_shipping_val
                                      v_local_curr
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_shipping_val IS NOT INITIAL
  ENDIF. " IF st_header-doc_currency NE v_local_curr AND
* End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXC_RATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_SUBTOTAL_VAL  text
*      <--P_LV_EXC_RATE  text
*      <--P_LV_LOC_AMT  text
*----------------------------------------------------------------------*
FORM f_get_exc_rate  USING    fp_lv_forgn_amt TYPE any
* Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                              fp_v_waers      TYPE waers " Currency Key
* End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
                     CHANGING fp_lv_exc_rate TYPE ukurs_curr       "kzwi6            " Subtotal 6 from pricing procedure for condition
                              fp_lv_loc_amt TYPE ukm_credit_limit. " Credit Limit

  DATA:lst_exc_tab    TYPE ztqtc_exchange_tab_invoice, " Exchange Rate table structure for invoice forms
*- Begin of ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952
       lst_exch_rate  TYPE bapi1093_0,  " Struc: Exchange Rate
       lst_return_msg TYPE bapiret1.    " Struc: Return Msg

  IF st_header-doc_currency = v_ref_curr.
    CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
      EXPORTING
        rate_type  = c_excrate_typ_m        " Exchange Rate type
        from_curr  = st_header-doc_currency " Document Currency
        to_currncy = fp_v_waers             " Payer/Company Code Currency
        date       = st_vbrk-fkdat          " Billing Date
      IMPORTING
        exch_rate  = lst_exch_rate
        return     = lst_return_msg.
    IF sy-subrc = 0.
      fp_lv_exc_rate = lst_exch_rate-exch_rate.
      fp_lv_loc_amt = fp_lv_forgn_amt * fp_lv_exc_rate.
      CLEAR lst_exch_rate.
    ELSE.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ENDIF.
  ELSE.
*- End of ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952
*         Translate foreign currency amount to local currency
    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING
        date             = st_vbrk-fkdat          "Currency translation date
        foreign_amount   = fp_lv_forgn_amt        "Amount in foreign currency
        foreign_currency = st_header-doc_currency "Currency key for foreign currency
*     Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
        local_currency   = fp_v_waers "Currency key for local currency
*     End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
*     Begin of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
*       local_currency   = v_waers                "Currency key for local currency
*     End   of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
      IMPORTING
        exchange_rate    = fp_lv_exc_rate "Exchange rate
        local_amount     = fp_lv_loc_amt  "Amount in local currency
      EXCEPTIONS
        no_rate_found    = 1
        overflow         = 2
        no_factors_found = 3
        no_spread_found  = 4
        derived_2_times  = 5
        OTHERS           = 6.
    IF sy-subrc NE 0.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ELSE. " ELSE -> IF sy-subrc NE 0
    ENDIF. " IF sy-subrc NE 0  "ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952
  ENDIF.  "ERPM-15474 "ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952
*            Amount
  IF fp_lv_exc_rate LT 0.
    fp_lv_exc_rate = 1 / ( -1 * fp_lv_exc_rate ).
  ENDIF. " IF fp_lv_exc_rate LT 0
  WRITE fp_lv_forgn_amt TO lst_exc_tab-amount CURRENCY st_header-doc_currency.
  CONDENSE lst_exc_tab-amount.
  CONCATENATE lst_exc_tab-amount '@' INTO lst_exc_tab-amount.

*            Exchange rate
*   Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
  WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate.
*   End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   Begin of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate CURRENCY v_waers. "st_header-doc_currency.
*   End   of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
  CONDENSE lst_exc_tab-exc_rate.
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-exc_rate.

*            Local Currency
*   Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
  lst_exc_tab-loc_curr = fp_v_waers.
*   End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   Begin of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   lst_exc_tab-loc_curr = v_waers.
*   End   of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
  CONCATENATE lst_exc_tab-loc_curr '=' INTO lst_exc_tab-loc_curr.

*            Converted Amount
*   Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
  WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY fp_v_waers.
*   End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   Begin of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
*   WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY v_waers.
*   End   of DEL:WROY:ERP-7178:21-Mar-2018:ED2K911550
  CONDENSE lst_exc_tab-conv_amt.

  APPEND lst_exc_tab TO i_exc_tab.
  CLEAR: lst_exc_tab,
         fp_lv_exc_rate,
         fp_lv_loc_amt.
*  ENDIF. "ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_stxh_data USING    fp_st_header  TYPE zstqtc_header_detail_f042 " Structure for Header detail of invoice form
                     CHANGING fp_i_std_text TYPE tt_std_text.

*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char10,   " Low of type CHAR2
           high   TYPE char10,   " High of type CHAR2
         END OF lty_range.

***Local Variable Declaration
  DATA: lst_range TYPE lty_range,
        lir_range TYPE STANDARD TABLE OF lty_range.

***Local constant declaration
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F042*',     " R of type CHAR10
             lc_scc    TYPE char20         VALUE 'ZQTC*F027*SCC*', " Scc of type CHAR20
             lc_scm    TYPE char20         VALUE 'ZQTC*F027*SCM*', " Scm of type CHAR20
             lc_sign   TYPE ddsign         VALUE 'I',              " Type of SIGN component in row type of a Ranges type
             lc_option TYPE ddoption       VALUE 'CP'.             " Type of OPTION component in row type of a Ranges type

***Populate local range table
  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_r.
  APPEND lst_range TO lir_range.

  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_scc.
  APPEND lst_range TO lir_range.

  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_scm.
  APPEND lst_range TO lir_range.

*** Fetch data from STXH table
  SELECT
  tdname      " Name
    FROM stxh " STXD SAPscript text file header
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st
    AND tdspras = fp_st_header-language.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBRK  text
*      -->P_I_VBRP  text
*      <--P_V_AUST_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_texts  USING    fpp_st_vbrk
                           fpp_i_vbrp TYPE tt_vbrp
                           fpp_i_vbpa  TYPE tt_vbpa "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
                  CHANGING p_v_aust_text
                           p_v_ind_text  "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
                           p_v_tax_expt. "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
  CONSTANTS: lc_object    TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st        TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
             lc_x         TYPE char1            VALUE 'X',
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
             lc_0         TYPE knvi-taxkd       VALUE '0',
             lc_in0       TYPE bptaxtype        VALUE 'IN0',
             lc_00        TYPE char2            VALUE '00',
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
             lc_name      TYPE thead-tdname     VALUE 'ZQTC_BILL_TO_AUSTRALIAN_F024',
             lc_au        TYPE kna1-land1       VALUE 'AU',  "ADD:RITM0074219:SGUDA:10-SEP-2018:ED1K908673
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
             lc_tax_expt  TYPE thead-tdname     VALUE 'ZQTC_CUSTOMER_TAX_EXEMPT_F024',
             lc_india_tax TYPE thead-tdname     VALUE 'ZQTC_INDIA_TAX_TEXT_F024'.
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375

* Data declaration
  DATA : li_lines         TYPE STANDARD TABLE OF tline, "Lines of text read
         li_dfkkbptaxnum  TYPE TABLE OF dfkkbptaxnum, "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
         li_knvi          TYPE TABLE OF knvi,      "ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
         lst_vbrp         TYPE tt_vbrp,
         lt_valid_tax_ind TYPE cvis_cust_tax_ind_t,
         lv_sales_area    TYPE cvis_sales_area.

  REFRESH:lst_vbrp,li_lines,li_dfkkbptaxnum,li_knvi,lt_valid_tax_ind.
  CLEAR lv_sales_area.
  lst_vbrp[] = fpp_i_vbrp[].

  SORT lst_vbrp BY werks vkorg_auft.
  DELETE ADJACENT DUPLICATES FROM lst_vbrp COMPARING werks vkorg_auft.
  DELETE lst_vbrp WHERE vkorg_auft NOT IN r_sales_org_text.
  DELETE lst_vbrp WHERE werks NOT IN r_aust_text.

  IF lst_vbrp[] IS NOT INITIAL
                AND st_header-bill_country = lc_au.  "ADD:RITM0074219:SGUDA:10-SEP-2018:ED1K90867
* Retrieve Tax/VAT values and add with document currency value
    PERFORM get_new_texts USING lc_st
                                lc_object
                                lc_name
                          CHANGING p_v_aust_text.
  ENDIF.
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
  SELECT * FROM dfkkbptaxnum
           INTO TABLE li_dfkkbptaxnum
           WHERE partner = st_header-bill_cust_number "li_i_vbpa-kunnr
           AND   taxtype = lc_in0.
  IF li_dfkkbptaxnum[] IS NOT INITIAL.
    READ TABLE li_dfkkbptaxnum INTO DATA(lst_dfkkbptaxnum) INDEX 1.
    IF lst_dfkkbptaxnum IS NOT INITIAL.
      v_gst_no = lst_dfkkbptaxnum-taxnum.
    ENDIF.
    PERFORM get_new_texts USING lc_st
                                lc_object
                                lc_india_tax
                          CHANGING p_v_ind_text.

  ENDIF.
  SELECT * FROM knvi
           INTO TABLE li_knvi
           WHERE kunnr = st_header-bill_cust_number "li_i_vbpa-kunnr
           AND   taxkd = lc_0.
  IF li_knvi[] IS NOT INITIAL.
    lv_sales_area-sales_org = st_header-comp_code.
    lv_sales_area-dist_channel = lc_00.
    lv_sales_area-division = lc_00.
    lt_valid_tax_ind = cvi_default_values_classic=>get_default_cust_tax_inds( lv_sales_area ).
    LOOP AT li_knvi INTO DATA(lst_knvi).
      "KNVI entry valid for current sales org?
      READ TABLE lt_valid_tax_ind TRANSPORTING NO FIELDS
        WITH KEY aland = lst_knvi-aland tatyp = lst_knvi-tatyp.
      IF sy-subrc <> 0.
        DELETE TABLE li_knvi FROM lst_knvi.
        CONTINUE.
      ENDIF.
    ENDLOOP.
    IF li_knvi[] IS NOT INITIAL.
      PERFORM get_new_texts USING lc_st
                                  lc_object
                                  lc_tax_expt
                            CHANGING p_v_tax_expt.
    ENDIF.
  ENDIF.
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_NEW_TEXTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_ST  text
*      -->P_LC_OBJECT  text
*      <--P_P_V_IND_TEXT  text
*----------------------------------------------------------------------*
FORM get_new_texts  USING    p_lc_st
                             p_lc_object
                             p_lc_india_tax
                    CHANGING p_p_v_ind_text.
  DATA : li_lines   TYPE STANDARD TABLE OF tline, "Lines of text read
         li_lines_d TYPE STANDARD TABLE OF tline. "Lines of text read
  CONSTANTS :lc_india_tax TYPE thead-tdname  VALUE 'ZQTC_INDIA_TAX_TEXT_F024'.
  REFRESH:li_lines,li_lines_d.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = p_lc_st
      language                = st_header-language "nast-spras
      name                    = p_lc_india_tax
      object                  = p_lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    IF p_lc_india_tax = lc_india_tax.
      LOOP AT li_lines INTO DATA(lst_p_lines).
        REPLACE ALL OCCURRENCES OF '&V_GST_NO&' IN lst_p_lines-tdline WITH v_gst_no.
        APPEND lst_p_lines TO li_lines_d.
        CLEAR lst_p_lines.
      ENDLOOP.
      IF li_lines_d[] IS NOT INITIAL.
        REFRESH:li_lines.
        li_lines[] = li_lines_d[].
      ENDIF.
    ENDIF.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = p_p_v_ind_text.
    IF sy-subrc EQ 0.
      CONDENSE p_p_v_ind_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BARCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_barcode.

  DATA: lv_amount   TYPE char11,  " Amount of type CHAR18
*        lv_amount   TYPE char18, " Amount of type CHAR18
        lv_order    TYPE char16,  " Invoice of type CHAR10
        lv_inv_chk  TYPE char1,   " Inv_chk of type CHAR1
        lv_amnt_chk TYPE char1,   " Amnt_chk of type CHAR1
        lv_bar      TYPE char100, " Bar of type CHAR30
        lv_msg_txt  TYPE bapi_msg,
        lv_bar_chk  TYPE char1.   " Bar_chk of type CHAR1

* Order Number
  MOVE st_header-invoice_number TO lv_order.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_order
    IMPORTING
      output = lv_order.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_order
*    IMPORTING
*      check_digit = lv_inv_chk.

  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_order
    IMPORTING
      check_digit = lv_inv_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
*  WRITE st_final-total_due TO lv_amount CURRENCY st_final-currency.
  IF v_totaldue_val GT 0.
    WRITE v_totaldue_val TO lv_amount CURRENCY st_header-doc_currency.
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387

    REPLACE ALL OCCURRENCES OF '.' IN lv_amount WITH space.
*** BOC BY SAYANDAS
    REPLACE ALL OCCURRENCES OF ',' IN lv_amount WITH space.
*** EOC BY SAYANDAS
    CONDENSE lv_amount.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_amount
      IMPORTING
        output = lv_amount.

*  MOVE st_calc-total_due TO lv_amount.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_amount
*      IMPORTING
*        check_digit = lv_amnt_chk.
    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_amount
      IMPORTING
        check_digit = lv_amnt_chk.
*  End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    CONCATENATE lv_order
              lv_inv_chk
              lv_amount
              lv_amnt_chk
              INTO lv_bar.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_bar
*      IMPORTING
*        check_digit = lv_bar_chk.

    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_bar
      IMPORTING
        check_digit = lv_bar_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    CONCATENATE lv_order
                lv_inv_chk
                lv_amount
                lv_amnt_chk
                lv_bar_chk
                INTO v_barcode
                SEPARATED BY space.
* BOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387
* If total value is negative then we are raising a message
  ELSE. " ELSE -> IF v_total GT 0
    MESSAGE e239(zqtc_r2) INTO lv_msg_txt. "Total Amount can't be negative
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = syst-msgid
        msg_nr    = syst-msgno
        msg_ty    = syst-msgty
        msg_v1    = syst-msgv1
        msg_v2    = syst-msgv2
      EXCEPTIONS
        OTHERS    = 0.
    IF sy-subrc EQ 0.
      v_ent_retco = 900.
      RETURN.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_total GT 0
* EOI by PBANDLAPAL on 28-Nov-2017 for ERP-5237: ED2K907387

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_MEMBERSHIP_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_MEMBERSHIP_TYPE  text
*      -->P_LC_TEXT_ID  text
*      -->P_I_VBKD  text
*      -->P_LST_VBRP  text
*      -->P_ST_KNA1  text
*      <--P_LV_MEMBERSHIP_TYPE  text
*      <--P_LV_MEMBERSHIP_DESC  text
*----------------------------------------------------------------------*
FORM get_membership_type  USING    fp_c_membership_type
                                   fp_lc_text_id
                                   fp_i_vbkd TYPE tt_vbkd
                                   fp_i_vbrp TYPE ty_vbrp
                                   fp_st_kna1
                          CHANGING fp_lv_membership_type
                                   fp_lv_membership_desc.
  CONSTANTS: lc_object TYPE tdobject VALUE 'TEXT'. " Texts: Application Object
*
*   Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : fp_lv_membership_type,   fp_lv_membership_desc.


*Get the description for condition group2 value
  READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = fp_i_vbrp-aubel
                                                 posnr = fp_i_vbrp-aupos
                                                      BINARY SEARCH.
  IF sy-subrc EQ 0.
    SELECT SINGLE kdkgr
                 vtext
            FROM tvkggt
           INTO st_tvkgg
*--*BOC PRABHU CR6376_INC0258402 ED2K915996
           WHERE spras EQ st_header-language
            AND  kdkgr EQ lst_vbkd-kdkg2.
*--*EOC PRABHU CR6376_INC0258402 ED2K915996
    fp_lv_membership_desc = st_tvkgg-vtext.
  ENDIF.
*  ENDIF.
  CLEAR : lv_text,
          fp_lv_membership_type.
*get the standard text value.
*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_lc_text_id
      language                = st_header-language
      name                    = fp_c_membership_type
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      fp_lv_membership_type = lv_text.
      CONDENSE fp_lv_membership_type.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_SPACE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LST_FINAL_SOC  text
*----------------------------------------------------------------------*
FORM f_update_space  CHANGING fp_lst_final_soc TYPE ty_final_soc.

  fp_lst_final_soc-quantity     = space.
  fp_lst_final_soc-amount       = space.
  fp_lst_final_soc-discount     = space.
  fp_lst_final_soc-tax          = space.
  fp_lst_final_soc-total        = space.
  fp_lst_final_soc-cust_group    = space.
  fp_lst_final_soc-tax_percent  = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_MEMBERSHIP_TYPE_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_MEMBERSHIP_TYPE  text
*      -->P_LC_TEXT_ID  text
*      -->P_I_VBKD  text
*      -->P_LST_VBRP  text
*      -->P_ST_KNA1  text
*      <--P_LV_FLAG_MG  text
*      <--P_LV_FLAG_INV  text
*      <--P_LV_MEMBER_TYPE  text
*      <--P_LV_DESC  text
*----------------------------------------------------------------------*
*FORM get_membership_type_detail  USING    fp_c_membership_type
*                                          fp_lc_text_id
*                                          fp_i_vbkd TYPE tt_vbkd
*                                          fp_i_vbrp TYPE ty_vbrp
*                                          fp_ist_kna1 TYPE ty_kna1
*                                 CHANGING fp_lv_flag_mg
*                                          fp_lv_flag_inv
*                                          fp_lv_member_type
*                                          fp_lv_desc.
*  CONSTANTS: lc_object TYPE tdobject VALUE 'TEXT'. " Texts: Application Object
*
**   Data declaration
*  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
*         lv_text  TYPE string.
*
*  CLEAR : fp_lv_flag_mg,
*          fp_lv_flag_inv,
*          fp_lv_desc.
**check whether material group5 have 'IN'(Indirect).
*  READ TABLE i_vbap INTO DATA(ist_vbap) WITH KEY vbeln = fp_i_vbrp-vgbel
*                                                 posnr = fp_i_vbrp-posnr.
*  IF sy-subrc EQ 0.
*    IF ist_vbap-mvgr5 EQ c_in.
*      fp_lv_flag_mg = c_x.
*    ENDIF.
*  ENDIF.
**check whether customer type whether summary invoice or
**detail invoice.
*  IF  fp_ist_kna1-katr6 EQ c_003.
*    fp_lv_flag_inv = c_x.
*  ENDIF.
**Get the description for condition group2 value
*  READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = fp_i_vbrp-aubel
*                                                     posnr = fp_i_vbrp-aupos
*                                                      BINARY SEARCH.
*  IF sy-subrc EQ 0.
*    SELECT SINGLE kdkgr vtext FROM tvkggt
*           INTO st_tvkgg
*           WHERE kdkgr EQ lst_vbkd-kdkg2.
*    fp_lv_desc = st_tvkgg-vtext.
*  ENDIF.
**  ENDIF.
*  CLEAR : lv_text,
*          fp_lv_member_type.
**get the standard text value.
**   Fetch title text for invoice
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
*      id                      = fp_lc_text_id
*      language                = st_header-language
*      name                    = fp_c_membership_type
*      object                  = lc_object
*    TABLES
*      lines                   = li_lines
*    EXCEPTIONS
*      id                      = 1
*      language                = 2
*      name                    = 3
*      not_found               = 4
*      object                  = 5
*      reference_check         = 6
*      wrong_access_to_archive = 7
*      OTHERS                  = 8.
*  IF sy-subrc EQ 0.
*    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
*      EXPORTING
*        it_tline       = li_lines
*      IMPORTING
*        ev_text_string = lv_text.
*    IF sy-subrc EQ 0.
*      fp_lv_member_type = lv_text.
*      CONDENSE fp_lv_member_type.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF sy-subrc EQ 0
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PUT_SIGN_IN_FRONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LST_ITEM_SOC_QUANTITY  text
*----------------------------------------------------------------------*
FORM f_put_sign_in_front  CHANGING fp_value.

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = fp_value.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_SOC_ITEM_SUMMMARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBRK  text
*      -->P_I_VBRP  text
*      <--P_LI_FINAL_SOC  text
*      <--P_I_SUBTOTAL  text
*      <--P_V_PAID_AMT  text
*----------------------------------------------------------------------*
FORM f_populate_soc_item_summmary  USING    fp_st_vbrk  TYPE ty_vbrk
                                   fp_i_vbrp            TYPE tt_vbrp
                          CHANGING fp_i_final_soc       TYPE tt_final_soc
                                   fp_i_subtotal        TYPE ztqtc_subtotal_f042
                                   fp_v_paid_amt        TYPE autwr. " Payment cards: Authorized amount
* Data declaration
  DATA : lv_fees           TYPE kzwi1, " Subtotal 1 from pricing procedure for condition
         lv_disc           TYPE kzwi5, " Subtotal 5 from pricing procedure for condition
         lv_tax            TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
         lv_total          TYPE kzwi5, " Subtotal 5 from pricing procedure for condition
         lv_total_val      TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
         lv_due            TYPE kzwi2, " Subtotal 2 from pricing procedure for condition
         lv_posnr          TYPE posnr, " Subtotal 2 from pricing procedure for condition
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         lv_mat_text       TYPE string,
         lv_tdname         TYPE thead-tdname, " Name
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         lst_final_soc     TYPE ty_final_soc, " Structure for CSS Item table
         lst_jptidcdassign TYPE ty_jptidcdassign.

* Constant Declaration
  CONSTANTS: lc_first  TYPE char1 VALUE '(', " First of type CHAR1
             lc_second TYPE char1 VALUE ')'. " Second of type CHAR1

*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
  DATA:                                         "li_tkomv      TYPE STANDARD TABLE OF komv,  " Pricing Communications-Condition Record
    li_tkomvd      TYPE STANDARD TABLE OF komvd, " Price Determination Communication-Cond.Record for Printing
    lst_komk       TYPE komk,                    " Communication Header for Pricing
*       Begin of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
*       lv_kbetr_desc TYPE kbetr,                   " Rate (condition amount or percentage)
    lv_kbetr_desc  TYPE p DECIMALS 3, " Rate (condition amount or percentage)
*       End   of CHANGE:ERP-4607:WROY:21-SEP-2017:ED2K908577
    lv_kbetr_char  TYPE char15,               " Kbetr_char of type CHAR15
    lst_komp       TYPE komp,                 " Communication Item for Pricing
    li_vbrp        TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
    lv_doc_line    TYPE /idt/doc_line_number, " Document Line Number
*   Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
    lv_sub_ref_id  TYPE char255, " Sub Ref ID
*   End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
*   Begin of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
*    lv_pnt_issn   TYPE char10, " Print ISSN
    lv_pnt_issn    TYPE char30, " Print ISSN
    lv_membership  TYPE char30, " Print ISSN
*   End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
    lv_buyer_reg   TYPE char255, " Buyer_reg of type CHAR255
**    * BOC: CR#6376 KJAGANA20181122  ED2K913919
    lv_flag_mg     TYPE char1,  "flag to check for material gr5
    lv_flag_inv    TYPE char1,  "flag to check for invoice type
    lv_member_type TYPE char255, "Member type text
    lv_desc        TYPE char255. "Condition group desc
** EOC: CR#6376 KJAGANA20181122  ED2K913919
  DATA : li_lines           TYPE STANDARD TABLE OF tline,     "Lines of text read
         lv_text            TYPE string,
         lv_ind             TYPE xegld,                       " Indicator: European Union Member?
         lst_line           TYPE tline,                       " SAPscript: Text Lines
         lst_lines          TYPE tline,                       " SAPscript: Text Lines
         lv_tax_bom         TYPE char20,                      " Tax_bom of type CHAR20
         lv_flag_di         TYPE char1,                       " Flag_di of type CHAR1
         lv_flag_ph         TYPE char1,                       " Flag_ph of type CHAR1
         lv_name            TYPE thead-tdname,                " Name
         lv_name_issn       TYPE thead-tdname,                " Name
         lv_name_membership TYPE thead-tdname,                " Name
         lv_volum           TYPE char30,                      " Volume
         lv_year            TYPE char30,                      " Year
         lv_issue           TYPE char30,                      " Issue
         lv_mlsub           TYPE char30,                      " Issue
         lv_vol             TYPE char8,                       " Volume
         lv_vol_des         TYPE char255,                     " Vol_des of type CHAR255
         lv_issue_des       TYPE char255,                     " Issue_des of type CHAR255
         lv_text_id         TYPE tdid,                        " Text ID
         lv_tax_amount      TYPE p DECIMALS 3,                " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                       " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                       " Rate (condition amount or percentage)
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         lst_tax_item_final TYPE zstqtc_tax_item_f042,        " Structure for tax components
*         lst_final_space    TYPE zstqtc_item_detail_soc_f042, " Structure for society form
         lst_final_space    TYPE  ty_final_soc,
         lst_input          TYPE zstqtc_supplement_ret_input, " Input Paramter for E098 Supplement retrieval
         lst_subtotal       LIKE LINE OF i_subtotal,
         lv_vol_year        TYPE char255,                     " Vol_des of type CHAR255.
         lv_flag            TYPE char1,                       " Flag of type CHAR1
         lv_text_tax        TYPE string,
*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bhf             TYPE char1, " Bhf of type CHAR1
         lv_lcf             TYPE char1, " Lcf of type CHAR1
         li_vbrp_tmp1       TYPE tt_vbrp,
         li_vbrp_tmp2       TYPE tt_vbrp,
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
         lv_bom_hdr_flg     TYPE xfeld, "Added by MODUTTA on 05/17/18 for INC0194372
         lv_year1           TYPE char4,  "  NPOLINA INC0218384  ED1K909026 Change for Society Year
*-- BOC CR#6376 SKKAIRAMKO 1/24/2019
         flg_indirect       TYPE char01,  "Indirect Flag
         lv_membership_type TYPE char255, "Membership type text
         lv_membership_desc TYPE char255, "Condition group desc
         flg_skip_details   TYPE c.
*-- EOC CR#6376 SKKAIRAMKO 1/24/2019

  CONSTANTS:lc_undscr     TYPE char1        VALUE '_',   " Undscr of type CHAR1
            lc_vat        TYPE char3        VALUE 'VAT', " Vat of type CHAR3
            lc_tax        TYPE char3        VALUE 'TAX', " Tax of type CHAR3
            lc_gst        TYPE char3        VALUE 'GST', " Gst of type CHAR3
*           Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            lc_parvw_za   TYPE parvw        VALUE 'ZA',     " Partner Function
            lc_parvw_ag   TYPE parvw        VALUE 'AG',     " Partner Function
            lc_posnr_h    TYPE posnr        VALUE '000000', " Item number of the SD document
*           End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
            lc_class      TYPE char5        VALUE 'ZQTC_',                           " Class of type CHAR5
            lc_devid      TYPE char5        VALUE '_F024',                           " Devid of type CHAR5
            lc_year       TYPE thead-tdname VALUE 'ZQTC_YEAR_F024',                  " Name
            lc_volume     TYPE thead-tdname VALUE 'ZQTC_VOLUME_F042',                " Name
            lc_issue      TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',                 " Name
            lc_stvolume   TYPE thead-tdname VALUE 'ZQTC_STARTVOLUME_F042',           " Name
            lc_stissue    TYPE thead-tdname VALUE 'ZQTC_SATRTISSUE_F042',            " Name
            lc_mlsubs     TYPE thead-tdname VALUE 'ZQTC_MSUBS_F042',                 " Name
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
*           Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
            lc_sub_ref_id TYPE thead-tdname VALUE 'ZQTC_F042_SUB_REF_ID', " Name
*           End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
*           Begin of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
            lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042', " Name
*           End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402
            lc_shipping   TYPE tdobname     VALUE 'ZQTC_F024_SHIPPING',      " Name
            lc_text_id    TYPE tdid         VALUE 'ST',                      " Text ID
            lc_digital    TYPE tdobname     VALUE 'ZQTC_F024_DIGITAL',       " Name
            lc_print      TYPE tdobname     VALUE 'ZQTC_F024_PRINT',         " Name
            lc_mixed      TYPE tdobname     VALUE 'ZQTC_F024_MIXED',         " Name
            lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
            lc_membership TYPE thead-tdname VALUE 'ZQTC_MEMBERSHIP_F042',    " Name
            lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042', " Name
            lc_za         TYPE parvw        VALUE 'ZA',                      " Partner Function
            lc_comma      TYPE char1        VALUE ',',                       " Comma of type CHAR1
            lc_colon      TYPE char1        VALUE ':',                       " Colon of type CHAR1
            lc_minus      TYPE char1        VALUE '-',                       " Colon of type CHAR1
            lc_hyphen     TYPE char1        VALUE '-',                       " Colon of type CHAR1
            lc_tax_text   TYPE tdobname VALUE 'ZQTC_TAX_F024'.               " Name

*  Constant Declaration
  CONSTANTS: lc_percent TYPE char1 VALUE '%'. " Percentage of type CHAR1

  IF i_iss_vol2 IS NOT INITIAL.
* SOC by NPOLINA ED1K909026  INC0216814
*    SORT i_iss_vol2 BY matnr.
    SORT i_iss_vol2 BY posnr matnr.
* EOC by NPOLINA ED1K909026  INC0216814
  ENDIF. " IF i_iss_vol2 IS NOT INITIAL


*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
  li_vbrp_tmp1[] = fp_i_vbrp[].
  li_vbrp_tmp2[] = fp_i_vbrp[].
  SORT li_vbrp_tmp2 BY posnr DESCENDING.
  DELETE li_vbrp_tmp2 WHERE uepos IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp2 COMPARING uepos.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description

  lst_komk-belnr = fp_st_vbrk-vbeln.
  lst_komk-knumv = fp_st_vbrk-knumv.
* BOC by SRBOSE
  DATA(li_tax_data) = i_tax_data.
** Begin of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
*  SORT li_tax_data BY document doc_line_number.
  SORT li_tax_data BY seller_reg.
** End of ADD:INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.
  SORT li_tax_data BY document doc_line_number. "INC0200387 & INC0201954:SGUDA:11-July-2018:ED1K907931

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.
*---------Cust VAT---------------------------------------------------*
  DATA(li_tax_temp) = i_tax_data.
  DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
  SORT li_tax_temp BY buyer_reg.
  DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
  DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
  IF lv_tax_line EQ 1.
    READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
    IF sy-subrc EQ 0.
      st_header-buyer_reg = lst_tax_temp-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_tax_line EQ 1
*--------------------------------------------------------------------*
* EOC by SRBOSE
  li_vbrp = fp_i_vbrp.
  DELETE li_vbrp WHERE uepos IS INITIAL.
* Fetch VAT/TAX/GST based on condition
  IF v_ind EQ abap_true.
    CONCATENATE lc_class
                lc_vat
                lc_devid
           INTO v_tax.

  ELSEIF st_header-bill_country EQ 'US'.
    CONCATENATE lc_class
                lc_tax
                lc_devid
           INTO v_tax.
  ELSE. " ELSE -> IF v_ind EQ abap_true
    CONCATENATE lc_class
                lc_gst
                lc_devid
           INTO v_tax.

  ENDIF. " IF v_ind EQ abap_true
  CLEAR: li_lines,
         lv_text.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD


* BOC by SRBOSE on 31-JAN-2018 #TR: ED2K910115 for CR_XXX
* Get Membership Text
  lv_name_membership = lc_membership.
  PERFORM f_get_text_val USING lv_name_membership
                               st_header
                      CHANGING lv_membership.
* EOC by SRBOSE on 31-JAN-2018 #TR: ED2K910115 for CR_XXX


***BOC by SRBOSE on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kawrt IS INITIAL. "Commented by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
*End of change by SRBOSE on 07-Aug-2017 CR_374 #TR: ED2K907591
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp).
    DATA(lv_tabix_space)  = sy-tabix.
*    IF lst_vbrp-uepos EQ '000000'.
    DATA(lv_prev_tabix)  = sy-tabix.
*      lst_final_soc-item = lv_posnr = lst_vbrp-posnr.

*--BOC: CR#6376 - SKKAIRAMKO - 1/24/2019
*-- update flag Indirect based on Material group 5
    IF lst_vbrp-mvgr5 = c_in.  "Material Group - Indirect
      flg_indirect = abap_true.
    ELSE.
      CLEAR flg_indirect.
    ENDIF.
*--EOC: CR#6376 - SKKAIRAMKO - 1/24/2019
*   Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
    IF lst_vbrp-uepos IS INITIAL. "BOM Components should not be considered
      APPEND INITIAL LINE TO i_input ASSIGNING FIELD-SYMBOL(<lst_input>).
      <lst_input>-product_no = lst_vbrp-matnr.
      IF lst_vbrp-kdkg2 IS NOT INITIAL.
        <lst_input>-cust_grp = lst_vbrp-kdkg2.
      ENDIF. " IF lst_vbrp-kdkg2 IS NOT INITIAL
      READ TABLE i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
           WITH KEY vbeln = lst_vbrp-vbeln
                    posnr = lst_vbrp-posnr
                    parvw = lc_parvw_za
           BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbrp-vbeln
                      posnr = lc_posnr_h
                      parvw = lc_parvw_za
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbrp-vbeln
                      posnr = lc_posnr_h
                      parvw = lc_parvw_ag
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        <lst_input>-society = <lst_vbpa>-kunnr.
      ENDIF. " IF sy-subrc EQ 0

*--BOC : CR#6376 - SKKAIRAMKO

      READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                               posnr = lst_vbrp-aupos.
      IF sy-subrc EQ 0.
        lst_final_soc-cust_group = lst_vbkd-kdkg2. "CR#6376 - SKKAIRAMKO - 1/24/2019
      ENDIF.


*--EOC : CR#6376 - SKKAIRAMKO

    ENDIF. " IF lst_vbrp-uepos IS INITIAL
*   End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K912425
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                                BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_txt_line.
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
    ENDIF. " IF sy-subrc EQ 0

***For BOM component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      lv_bom_hdr_flg = abap_true. "Added by MODUTTA on 05/17/18 for INC0194372
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911368
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911368
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

*--BOC: CR#6376 - SKKAIRAMKO - 1/24/2019
    IF lst_vbrp-uepos IS INITIAL.
      WRITE lv_tax_amount TO lst_final_soc-tax_percent.
      CONDENSE lst_final_soc-tax_percent.
    ENDIF.
*--EOC: CR#6376 - SKKAIRAMKO - 1/24/2019

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
*    IF lst_tax_item-taxable_amt IS NOT INITIAL."Commented by MODUTTA on 05/17/18 for INC0194372
    IF lv_bom_hdr_flg IS INITIAL. "Added by MODUTTA on 05/17/18 for INC0194372
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lv_bom_hdr_flg IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
    CLEAR: lv_bom_hdr_flg. "Added by MODUTTA on 05/17/18 for INC0194372
***      EOC by MODUTTA on 31/01/2018 for CR_XXX

    IF lst_vbrp-uepos IS INITIAL.
      IF lv_tabix_space GT 1.
        APPEND lst_final_space TO fp_i_final_soc.
      ENDIF. " IF lv_tabix_space GT 1
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

***      BOC by MODUTTA on 31/01/2018 for CR_XXX
    READ TABLE i_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbrp-aubel
                                                   posnr = lst_vbrp-aupos
                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      READ TABLE i_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_vbap-vbeln
                                                        posnr = lst_vbap-posnr
                                                        parvw = lc_za
                                                        BINARY SEARCH.
*       Begin of ADD:CR744:WROY:05-Feb-2018:ED2K911175
      IF sy-subrc NE 0.
        READ TABLE i_vbpa INTO lst_vbpa     WITH KEY vbeln = lst_vbap-vbeln
                                                        posnr = '000000'
                                                        parvw = lc_za
                                                        BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
*       End   of ADD:CR744:WROY:05-Feb-2018:ED2K911175
      IF sy-subrc EQ 0.
        IF lst_vbap-mvgr5 IN r_mvgr5_scc.
          v_scc = abap_true.
          v_scenario_scc = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
        ELSEIF lst_vbap-mvgr5 IN r_mvgr5_scm.
          v_scm = abap_true.
          v_scenario_scm = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
        ENDIF. " IF lst_vbap-mvgr5 IN r_mvgr5_scc
        IF lst_vbap-mvgr5 IN r_mvgr5_ma.
          v_mem_text = abap_true.  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*         Begin of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
          READ TABLE i_society INTO DATA(lst_society) WITH KEY society = lst_vbpa-kunnr
               BINARY SEARCH.
*         End   of ADD:ERP-7124:WROY:16-Mar-2018:ED2K911376
*         Begin of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
*         READ TABLE i_society INTO DATA(lst_society) WITH KEY society = v_kunnr.
*         End   of DEL:ERP-7124:WROY:16-Mar-2018:ED2K911376
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
* SOC by NPOLINA     INC0218384     ED1K909026 Change for Society Year
            READ TABLE i_veda ASSIGNING FIELD-SYMBOL(<lfs_veday>) WITH KEY vbeln = lst_vbrp-vgbel
                                                                    vposn = lst_vbrp-vgpos BINARY SEARCH.
            IF sy-subrc EQ 0.
              CLEAR :lv_year1.
              lv_year1 = <lfs_veday>-vbegdat+0(4).
            ENDIF.

*           CONCATENATE lst_society-society_name lv_membership v_start_year INTO lst_final_soc-description SEPARATED BY space
            CONCATENATE lst_society-society_name lv_membership lv_year1 INTO lst_final_soc-description SEPARATED BY space.
            CLEAR :lv_year1.
* EOC by NPOLINA     INC0218384     ED1K909026 Change for Society Year
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_vbap-mvgr5 IN r_mvgr5_ma
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
*      ELSE. " ELSE -> IF sy-subrc EQ 0
    IF lv_flag IS INITIAL.
***      EOC by MODUTTA on 31/01/2018 for CR_XXX
      IF lst_mara-mtart IN r_mtart_med_issue. "Media Issues
        READ TABLE i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>)
             WITH KEY matnr = lst_vbrp-matnr
                      spras = st_header-language "Customer Language
             BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE i_makt ASSIGNING <lst_makt>
               WITH KEY matnr = lst_vbrp-matnr
                        spras = c_deflt_langu "Default Language
               BINARY SEARCH.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
* BOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
*          lst_final_soc-description = <lst_makt>-maktx. "Material Description
          CLEAR:lst_jptidcdassign.
          READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                        idcodetype = v_idcodetype_2
                                                                        BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            CONCATENATE lst_jptidcdassign-identcode <lst_makt>-maktx INTO lst_final_soc-description SEPARATED BY lc_hyphen.
            CONDENSE lst_final_soc-description.
          ELSE. " ELSE -> IF sy-subrc IS INITIAL
            lst_final_soc-description = <lst_makt>-maktx.
          ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX

        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF lst_mara-mtart IN r_mtart_med_issue
*         Fetch Material Basic Text
        CLEAR: li_lines,
               lv_mat_text.
        lv_tdname = lst_mara-matnr.
*         Using Customer Language
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = c_id_grun          "Text ID: GRUN
            language                = st_header-language "Language Key
            name                    = lv_tdname          "Text Name: Material Number
            object                  = c_obj_mat          "Text Object: MATERIAL
          TABLES
            lines                   = li_lines           "Text Lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc NE 0.
*           Using Default Language (English)
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = c_id_grun     "Text ID: GRUN
              language                = c_deflt_langu "Language Key
              name                    = lv_tdname     "Text Name: Material Number
              object                  = c_obj_mat     "Text Object: MATERIAL
            TABLES
              lines                   = li_lines      "Text Lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
          DELETE li_lines WHERE tdline IS INITIAL.
*           Convert ITF text into a string
          CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
            EXPORTING
              it_tline       = li_lines
            IMPORTING
              ev_text_string = lv_mat_text.
          IF sy-subrc EQ 0.
* BOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
**            lst_final_soc-description = lv_mat_text. "Material Basic Text
            CLEAR:lst_jptidcdassign.
            READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                          idcodetype = v_idcodetype_2
                                                                          BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              CONCATENATE lst_jptidcdassign-identcode lv_mat_text INTO lst_final_soc-description SEPARATED BY lc_hyphen.
              CONDENSE lst_final_soc-description.
            ELSE. " ELSE -> IF sy-subrc IS INITIAL
              lst_final_soc-description = lv_mat_text. "Material Basic Text
            ENDIF. " IF sy-subrc IS INITIAL
* EOC by SRBOSE on 9-JAN-2018 #TR: ED2K910115 for CR_XXX
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_mara-mtart IN r_mtart_med_issue
    ENDIF. " IF lv_flag IS INITIAL

    SET COUNTRY st_header-bill_country.

    IF lst_vbrp-uepos IS INITIAL. "added by MODUTTA on 08/03/18
*      WRITE lst_vbrp-fkimg TO lst_final_soc-quantity UNIT lst_vbrp-meins.
      MOVE lst_vbrp-fkimg  TO lst_final_soc-quantity.
      lv_fees = lst_vbrp-kzwi1.
      lv_disc = lst_vbrp-kzwi5.
*    Begin of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
*  Unit Price calucalation
      CLEAR v_unit_price.
*  Unit Price = Net Value / Billed Quantity
      v_unit_price = lst_vbrp-kzwi1 / lst_vbrp-fkimg.
*     Begin of Change:INC0296815:NPALLA:18-JUNE-2020:ED1K911925
*      WRITE v_unit_price TO lst_final_soc-unit_price UNIT st_header-doc_currency.
      WRITE v_unit_price TO lst_final_soc-unit_price CURRENCY st_header-doc_currency.
*     End of Change:INC0296815:NPALLA:18-JUNE-2020:ED1K911925
      CONDENSE lst_final_soc-unit_price.
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
        CONCATENATE '-' lst_final_soc-unit_price INTO lst_final_soc-unit_price.
      ENDIF.
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      IF lst_vbrp-kzwi1 GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.    " cancelled invoice
        CONCATENATE '-' lst_final_soc-unit_price INTO lst_final_soc-unit_price.
      ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
*    End of ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
      IF lv_fees LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-amount.
*        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*          CHANGING
*            value = lst_final_soc-amount.
        lst_final_soc-amount = lv_fees.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019

*        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.

*        CONDENSE lst_final_soc-amount.
*        CONCATENATE lc_minus lst_final_soc-amount INTO lst_final_soc-amount.


        lst_final_soc-amount = ( -1 ) * lv_fees.
*
*         CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*          CHANGING
*            value = lst_final_soc-amount.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_fees GT 0 AND fp_st_vbrk-vbtyp IN r_cinv. " Cancelled invoice
        lst_final_soc-amount = ( -1 ) * lv_fees.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                  " Credit meme cancellation
        lst_final_soc-amount = lv_fees.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_fees LT 0

*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_fees TO lst_final_soc-amount CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-amount.
*
        lst_final_soc-amount = lv_fees.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019

      ENDIF. " IF lv_fees LT 0


      IF lv_disc LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_disc = lv_disc * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.      " Cancelled invoice
          lv_disc = lv_disc * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-discount.
*
        lst_final_soc-discount = lv_disc.

*        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*          CHANGING
*            value = lst_final_soc-discount.

*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-discount.

        lst_final_soc-discount = lv_disc.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_disc GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.   " Cancelled invoice
        lst_final_soc-discount = lv_disc.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                    " Credit memo cancellation
        lst_final_soc-discount = lv_disc.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *

      ELSE. " ELSE -> IF lv_disc LT 0
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_disc TO lst_final_soc-discount CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-discount.

        lst_final_soc-discount = lv_disc.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
      ENDIF. " IF lv_disc LT 0

*******      Tax Amount
      IF lst_final_soc-tax IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF lv_tax LT 0.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*          WRITE lv_tax TO lst_final_soc-tax CURRENCY st_header-doc_currency.
*          CONDENSE lst_final_soc-tax.

          lst_final_soc-tax = lv_tax.

*          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*            CHANGING
*              value = lst_final_soc-tax.
*          CONDENSE lst_final_soc-tax.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*          WRITE lv_tax TO lst_final_soc-tax CURRENCY st_header-doc_currency.
*          CONDENSE lst_final_soc-tax.
*          CONCATENATE lc_minus lst_final_soc-tax INTO lst_final_soc-tax.
*
          lst_final_soc-tax =  ( -1 ) * lv_tax.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSEIF lv_tax GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.    " Cancelled invoice
          lst_final_soc-tax =  ( -1 ) * lv_tax.
        ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                    " Credit memo cancellation
          lst_final_soc-tax = lv_tax.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        ELSE. " ELSE -> IF lv_tax LT 0
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*          WRITE lv_tax         TO lst_final_soc-tax CURRENCY st_header-doc_currency.
*          CONDENSE lst_final_soc-tax.
          lst_final_soc-tax = lv_tax.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF lst_final_soc-tax IS INITIAL


*********Total
      lv_total = lst_vbrp-kzwi3 + lv_tax + lv_total.
      IF lv_total LT 0. " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        IF fp_st_vbrk-vbtyp IN r_crd.
          lv_total = lv_total * -1.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
        IF fp_st_vbrk-vbtyp IN r_cinv.    " Cancelled invoice
          lv_total = lv_total * -1.
        ENDIF.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-total.

        lst_final_soc-total = lv_total.

*        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*          CHANGING
*            value = lst_final_soc-total.
*
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_crd.
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-total.
*        CONCATENATE lc_minus lst_final_soc-total INTO lst_final_soc-total.
*
        lst_final_soc-total = ( - 1 ) * lv_total.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSEIF lv_total GT 0 AND fp_st_vbrk-vbtyp IN r_cinv.    " cancelled invoice
        lst_final_soc-total = ( - 1 ) * lv_total.
      ELSEIF fp_st_vbrk-vbtyp IN r_ccrd.                      " Credit memo cancellation
        lst_final_soc-total = lv_total.
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919804 *
      ELSE. " ELSE -> IF lv_total LT 0
*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*        WRITE lv_total TO lst_final_soc-total CURRENCY st_header-doc_currency.
*        CONDENSE lst_final_soc-total.

        lst_final_soc-total = lv_total.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019
      ENDIF. " IF lv_total LT 0

*     *Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
      IF lst_final_soc-quantity IS INITIAL.
        CLEAR: lst_final_soc-quantity.
      ENDIF. " IF lst_final_soc-quantity IS INITIAL
*      End of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

*     *************BOC by SRBOSE on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
*   lv_doc_line = lst_vbrp-posnr+2(4).
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
      IF st_header-comp_code_country EQ lst_vbrp-lland.
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space.
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
    ENDIF. " IF sy-subrc EQ 0

*--BOC : CR#6376 - SKKAIRAMKO - 1/24/2019
*
*    IF lst_final_soc IS NOT INITIAL. " ELSE -> IF lst_final_soc-description+0(3) EQ lv_text
*      APPEND lst_final_soc TO fp_i_final_soc.
*    ENDIF. " IF lst_final_soc IS NOT INITIAL

    IF lst_final_soc IS NOT INITIAL.

      DESCRIBE TABLE fp_i_final_soc LINES DATA(lv_before).

      IF flg_indirect EQ abap_true.  "If material group is Indirect
        COLLECT lst_final_soc INTO fp_i_final_soc.
      ELSE.
        APPEND lst_final_soc TO fp_i_final_soc.
      ENDIF.

*--Here we are checking the lines collected ,then we are not processing with details.
      DESCRIBE TABLE fp_i_final_soc LINES DATA(lv_after).
      IF lv_tabix_space GT 1.
        IF lv_before EQ lv_after.
          flg_skip_details = abap_true.
        ENDIF.
      ENDIF.

    ENDIF.
*--EOC : CR#6376 - SKKAIRAMKO - 1/24/2019


*   Tax
*    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.
    lv_due = lv_due + lst_vbrp-kzwi2.

    IF flg_skip_details NE abap_true. "CR#6376 - SKKAIRAMKO - 1/24/2019

      CLEAR lst_final_soc.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR: lv_flag_di,
                lv_flag_ph.
        IF lst_mara-ismmediatype EQ 'DI'.
          lv_flag_di = abap_true.
        ELSEIF lst_mara-ismmediatype EQ 'PH'.
          lv_flag_ph = abap_true.
        ENDIF. " IF lst_mara-ismmediatype EQ 'DI'

        CLEAR : lv_name,
                lv_name_issn,
                lv_pnt_issn,
                v_subscription_typ.
        IF lv_flag_di EQ abap_true.
          lv_name = lc_digt_subsc.
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_digissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

        ELSEIF lv_flag_ph EQ abap_true.
          lv_name = lc_prnt_subsc.
*       Subroutine to get subscription type text (Print subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_pntissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX


        ELSE. " ELSE -> IF lv_flag_di EQ abap_true
          lv_name = lc_comb_subsc.
*       Subroutine to get subscription type text (Combined subscription)
          PERFORM f_get_subscrption_type USING lv_name
                                               st_header
                                      CHANGING v_subscription_typ.

* BOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX
          lv_name_issn = lc_combissn.
          PERFORM f_get_text_val USING lv_name_issn
                                       st_header
                              CHANGING lv_pnt_issn.
* EOC by SRBOSE on 5-JAN-2018 #TR: ED2K910115 for CR_XXX

        ENDIF. " IF lv_flag_di EQ abap_true

        CLEAR lst_final_soc.
        IF lst_vbrp-uepos IS INITIAL. "Added by MODUTTA on 07/03/18
          lst_final_soc-description = v_subscription_typ.

          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019

          APPEND lst_final_soc TO fp_i_final_soc.
        ENDIF. " IF lst_vbrp-uepos IS INITIAL
      ENDIF. " IF sy-subrc EQ 0

*** BOC by MODUTTA on 01/02/2018 for CR#_XXX
      IF lst_vbrp-uepos IS INITIAL.
** Total of Issues, Start Volume, Start Issue
*Multi-Year Subs
*      lv_name = lc_mlsubs. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
        lv_name = c_sub_term. " ADD:ERP-7282:SGUDA:06-JUN-2019:ED1K910292
        CLEAR: lst_final_soc.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_mlsub.
        READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_vbrp-aubel
                                                       vposn = lst_vbrp-aupos
                                                       BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE i_tvlzt INTO DATA(lst_tvlzt) WITH KEY spras = st_header-language
                                                           vlaufk = lst_veda-vlaufk
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0
            AND lst_tvlzt-bezei IS NOT INITIAL.
            CONCATENATE lv_mlsub lst_tvlzt-bezei INTO lst_final_soc-description SEPARATED BY lc_colon.
            PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
            APPEND lst_final_soc TO fp_i_final_soc.
            CLEAR lst_final_soc.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_vbrp-uepos IS INITIAL

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
      READ TABLE li_vbrp_tmp1  WITH KEY uepos = lst_vbrp-posnr TRANSPORTING NO FIELDS.
*INC0213315 RBTIRUMALA
      IF sy-subrc = 0.
        lv_bhf = abap_true.
      ENDIF. " IF sy-subrc = 0
*INC0213315 RBTIRUMALA
      IF lv_bhf IS INITIAL.
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description

*     Total of issues
        IF lst_mara-ismhierarchlevl EQ '2'.
* SOC by NPOLINA ED1K909026  INC0216814
*        READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara-matnr.
          READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY posnr = lst_vbrp-posnr
                                                                   matnr = lst_mara-matnr BINARY SEARCH.
* EOC by NPOLINA ED1K909026  INC0216814
          IF sy-subrc EQ 0.
            DATA(lst_issue_vol) = lst_issue_vol2.
          ENDIF. " IF sy-subrc EQ 0
        ELSEIF lst_mara-ismhierarchlevl EQ '3'.
          lst_issue_vol-stvol = lst_mara-ismcopynr.
          lst_issue_vol-noi = '1'.
          lst_issue_vol-stiss = lst_mara-ismnrinyear.
        ENDIF. " IF lst_mara-ismhierarchlevl EQ '2'

***Year
*      lv_name = lc_year. "CR-7841:SGUDA:30-Apr-2019:ED1K910147
        lv_name = c_cntr_start. ""CR-7841:SGUDA:30-Apr-2019:ED1K910147
        CLEAR: lst_final_soc.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING lv_year.
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
        lv_name = c_cntr_end.
        PERFORM f_get_text_val USING lv_name
                                     st_header
                            CHANGING v_cntr_end.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910147
* Begin of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
*- Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
*        READ TABLE i_veda ASSIGNING FIELD-SYMBOL(<lfs_veda>) WITH KEY vbeln = lst_vbrp-vgbel
*                                                                      vposn = lst_vbrp-vgpos BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          CLEAR :v_start_year1.
*          v_start_year1 = <lfs_veda>-vbegdat+0(4).
*        ENDIF.
*
*        IF v_start_year1 IS NOT INITIAL.
*          CONCATENATE lv_year v_start_year1 INTO lst_final_soc-description." SEPARATED BY lc_colon.
** End of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
*          CONDENSE lst_final_soc-description.
*          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
*          APPEND lst_final_soc-description TO fp_i_final_soc.
*          CLEAR lst_final_soc.
*        ENDIF. " IF v_start_year IS NOT INITIAL
        READ TABLE i_veda INTO DATA(ls_veda) WITH KEY vbeln = lst_vbrp-vgbel
                                                      vposn = lst_vbrp-vgpos BINARY SEARCH.

        IF ls_veda-vbegdat IS INITIAL.
          READ TABLE i_veda INTO ls_veda WITH KEY vbeln = lst_vbrp-vgbel
                                                  vposn = c_posnr BINARY SEARCH.

        ENDIF.
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
        IF fp_st_vbrk-fkart IN r_bill_doc_type_zibp.
          READ TABLE i_vbkd INTO DATA(lst_vbkd_tmp) WITH KEY vbeln = lst_vbrp-vgbel
                                                         posnr = lst_vbrp-vgpos BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE i_fplt INTO DATA(lst_fplt) WITH KEY fplnr = lst_vbkd_tmp-fplnr
                                                           afdat = fp_st_vbrk-fkdat.
            IF sy-subrc EQ 0.
              ls_veda-vbegdat = lst_fplt-nfdat.
              ls_veda-venddat = lst_fplt-fkdat.
            ENDIF.
          ENDIF.
        ENDIF.
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
        IF ls_veda-vbegdat IS NOT INITIAL.
          CLEAR : v_year_2,v_cntr_month,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
          CONCATENATE lv_year lc_colon INTO v_year_2.
          CONDENSE v_year_2.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = ls_veda-vbegdat
            IMPORTING
              day                           = v_day
              month                         = v_month
              year                          = v_year2
              stext                         = v_stext
              ltext                         = v_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
          CONDENSE v_cntr.
          CONCATENATE v_year_2 v_cntr INTO lst_final_soc-description.
          CONDENSE lst_final_soc-description.
          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
          APPEND lst_final_soc-description TO fp_i_final_soc.
          CLEAR lst_final_soc-description.
        ENDIF.
        IF ls_veda-venddat IS NOT INITIAL..
          CLEAR : v_year_2,v_cntr_month,v_cntr,v_cntr,v_day,v_month,v_year2,v_stext,v_ltext.
          CONCATENATE v_cntr_end lc_colon INTO v_year_2.
          CONDENSE v_year_2.
          CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
            EXPORTING
              idate                         = ls_veda-venddat
            IMPORTING
              day                           = v_day
              month                         = v_month
              year                          = v_year2
              stext                         = v_stext
              ltext                         = v_ltext
*             userdate                      =
            EXCEPTIONS
              input_date_is_initial         = 1
              text_for_month_not_maintained = 2
              OTHERS                        = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          CONCATENATE v_day v_stext v_year2 INTO  v_cntr SEPARATED BY lc_minus.
          CONDENSE v_cntr.
          CONCATENATE v_year_2 v_cntr INTO lst_final_soc-description.
          CONDENSE lst_final_soc-description.
          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
          APPEND lst_final_soc-description TO fp_i_final_soc.
          CLEAR lst_final_soc-description.
        ENDIF.
*- End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910085
*         Start Volume
        IF lst_issue_vol IS NOT INITIAL.
          lv_name = lc_volume.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_volum.

          IF lst_issue_vol-stvol IS NOT INITIAL.
            CONCATENATE lv_volum lst_issue_vol-stvol INTO lv_issue_des SEPARATED BY space.
            IF lst_final_soc-description  IS NOT INITIAL.
              CONCATENATE lst_final_soc-description lc_comma lv_issue_des INTO lst_final_soc-description.
            ELSE. " ELSE -> IF lst_final_soc-description IS NOT INITIAL
              lst_final_soc-description = lv_issue_des.
            ENDIF. " IF lst_final_soc-description IS NOT INITIAL
            CONDENSE lst_final_soc-description.
          ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

*          Total Issue
          lv_name = lc_issue.
          CLEAR: lv_issue,lv_issue_des.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_issue.
          IF lst_issue_vol-noi IS NOT INITIAL.
            MOVE lst_issue_vol-noi TO lv_vol.
            CONCATENATE lv_vol lv_issue INTO lv_issue_des SEPARATED BY space.
            IF lst_final_soc-description  IS NOT INITIAL.
              CONCATENATE lst_final_soc-description lc_comma lv_issue_des INTO lst_final_soc-description.
            ELSE. " ELSE -> IF lst_final_soc-description IS NOT INITIAL
              lst_final_soc-description = lv_issue_des.
            ENDIF. " IF lst_final_soc-description IS NOT INITIAL
            CONDENSE lst_final_soc-description.
          ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL
        ENDIF. " IF lst_issue_vol IS NOT INITIAL

        IF lst_final_soc-description IS NOT INITIAL.
*        CONDENSE lst_final_soc.
          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
          APPEND lst_final_soc TO fp_i_final_soc.
          CLEAR lst_final_soc.
        ENDIF. " IF lst_final_soc-description IS NOT INITIAL

**Start Issue
        IF lst_issue_vol IS NOT INITIAL.
          lv_name = lc_stissue.
          PERFORM f_get_text_val USING lv_name
                                       st_header
                              CHANGING lv_issue.

          IF lst_issue_vol-stiss IS NOT INITIAL.
            CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_final_soc-description SEPARATED BY space.
            CONDENSE lst_final_soc-description.
            PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
            APPEND lst_final_soc TO fp_i_final_soc.
            CLEAR lst_final_soc.
          ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
        ENDIF. " IF lst_issue_vol IS NOT INITIAL

****ISSN
        CLEAR: lst_final_soc.
        READ TABLE i_jptidcdassign INTO lst_jptidcdassign WITH KEY matnr = lst_vbrp-matnr
                                                                   idcodetype = v_idcodetype_1 "(++ BOC by SRBOSE for CR_XXX)
                                                                   BINARY SEARCH.
        IF sy-subrc EQ 0 AND
           lst_jptidcdassign-identcode IS NOT INITIAL.
*        lv_name = lc_pntissn.
*        PERFORM f_get_text_val USING lv_name
*                                     st_header
*                            CHANGING lv_pnt_issn.
*** Begin of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
*        CONCATENATE lv_pnt_issn
*                    lst_jptidcdassign-identcode
*               INTO lst_final_soc-description
*          SEPARATED BY lc_colon.
          lst_final_soc-description = lst_jptidcdassign-identcode.
*** End of ADD:CR#7507:SGUDA:20-June-2018:ED1K907763
          CONDENSE lst_final_soc-description.
          PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
          APPEND lst_final_soc TO fp_i_final_soc.
        ENDIF. " IF sy-subrc EQ 0 AND
      ENDIF. " IF lv_bhf IS INITIAL
*     End   of ADD:ERP-5108:WROY:14-Nov-2017:ED2K909402

*** BOC BY SRBOSE on 07-MAR-2018 for BOM description
      READ TABLE li_vbrp_tmp2 WITH KEY posnr = lst_vbrp-posnr TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_lcf = abap_true.
      ENDIF. " IF sy-subrc = 0
**    * BOC: CR#6376 KJAGANA20181122  ED2K913919
*get the member ship type and its description based on material group5,
*and customer type either summary invoice or detail invoice.

**    * EOC: CR#6376 KJAGANA20181122  ED2K913919
      IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL ).
*** EOC BY SRBOSE on 07-MAR-2018 for BOM description
***************** BOC by MODUTTA on 14/09/2017 for ERP 4400*********************
        CLEAR: lst_final_soc.
        CLEAR lst_vbkd.
        READ TABLE i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbrp-aubel
                                                       posnr = lst_vbrp-aupos
                                                        BINARY SEARCH.
        IF sy-subrc IS INITIAL.
**      * BOC: CR#6376 KJAGANA20181123  ED2K913919
**Pass the member ship type value to final internal table.
*        IF lv_flag_mg EQ c_x AND lv_flag_inv EQ c_x.
**        IF lst_vbkd-kdkg2 EQ c_05 OR lst_vbkd-kdkg2 EQ c_08.
*           lst_final_soc-description = lv_desc."lst_vbkd-kdkg2.
*           IF lv_member_type IS NOT INITIAL.
*          CONCATENATE lv_member_type
*                      lst_final_soc-description
*                 INTO lst_final_soc-description
*            SEPARATED BY space.
*          ENDIF."IF lv_member_type IS NOT INITIAL.
*        APPEND lst_final_soc TO fp_i_final_soc.
**        ENDIF." IF lst_vbkd-kdkg2 EQ c_05 OR lst_vbkd-kdkg2 EQ c_08.
*        ELSE.
**       * EOC: CR#6376 KJAGANA20181123  ED2K913919
          lst_final_soc-description = lst_vbkd-ihrez.
*       Begin of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
          CLEAR: lv_sub_ref_id.
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
          READ TABLE i_vbap INTO DATA(lsi_vbap) WITH KEY vbeln = lst_vbrp-aubel
                                                         posnr = lst_vbrp-aupos
                                                         BINARY SEARCH.
          IF sy-subrc = 0.
            IF r_mat_grp5[] IS NOT INITIAL AND
               lsi_vbap-mvgr5 IN r_mat_grp5.
              PERFORM f_read_sub_type  USING c_membership_number
                                             lc_text_id
                                    CHANGING lv_sub_ref_id.
            ENDIF.
            CLEAR lsi_vbap.
          ENDIF.
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
          " Below IF Condition is added as part of CR#7730 changes. KKRAVURI20181015  ED2K913596
          " Before CR#7730 changes, no IF lv_sub_ref_id IS INITIAL condition
          IF lv_sub_ref_id IS INITIAL.                       "  CR#7730
            PERFORM f_read_sub_type USING    lc_sub_ref_id
                                             lc_text_id
                                    CHANGING lv_sub_ref_id.
          ENDIF. " lv_sub_ref_id IS INITIAL                CR#7730
*--BOC: CR#6376 SKKAIRAMKO - 01/24/2019
*--Sub ref has to be shown only detailed invoice only
          IF flg_indirect NE abap_true. "CR#6376 SKKAIRAMKO 1/24/2019
            IF lv_sub_ref_id IS NOT INITIAL.
              CONCATENATE lv_sub_ref_id
                          lst_final_soc-description
                     INTO lst_final_soc-description
                SEPARATED BY space.
            ENDIF. " IF lv_sub_ref_id IS NOT INITIAL
*       End   of CHANGE:CR#663:WROY:24-Oct-2017:ED2K908908
            PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
            APPEND lst_final_soc TO fp_i_final_soc.
*        ENDIF."IF lv_flag_mg EQ c_x AND lv_flag_inv EQ c_x.
          ENDIF.
*--Membership type

*          IF flg_indirect EQ abap_true. "Indirect Material grop only "Prabhu CR 6376
          PERFORM get_membership_type USING c_mem_type "c_membership_type
                                            lc_text_id
                                            i_vbkd
                                            lst_vbrp
                                            st_kna1
                                  CHANGING lv_membership_type
                                           lv_membership_desc.

          IF lv_membership_type IS NOT INITIAL.

            lst_final_soc-description = lv_membership_desc.

            CONCATENATE lv_membership_type
                        lst_final_soc-description
                       INTO lst_final_soc-description
            SEPARATED BY space.
            PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
            APPEND lst_final_soc TO fp_i_final_soc.
          ENDIF.
*          ENDIF.


*--EOC: CR#6576 SKKAIRAMKO - 01/24/2019
        ENDIF. " CR#6376 SKKAIRAMKO 1/24/2019
***************** EOC by MODUTTA on 14/09/2017 for ERP 4400*********************
**BOC by MODUTTA on 08/08/2017 for CR# 408
        IF st_header-buyer_reg IS INITIAL.
          READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                               doc_line_number = lv_doc_line
                                                               BINARY SEARCH.
          IF sy-subrc EQ 0.
            CLEAR lst_final_soc.
            lst_final_soc-description = lst_tax_data-buyer_reg.
            IF lst_final_soc-description IS NOT INITIAL.
              CONCATENATE lv_text lst_final_soc-description INTO lst_final_soc-description SEPARATED BY space.
              CONDENSE lst_final_soc-description.
            ENDIF. " IF lst_final_soc-description IS NOT INITIAL
            PERFORM f_update_space CHANGING lst_final_soc.  "#CR6376 SKKAIRAMKO 1/24/2019
            APPEND lst_final_soc TO fp_i_final_soc.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF st_header-buyer_reg IS INITIAL
**EOC by MODUTTA on 08/08/2017 for CR# 408
      ENDIF. " IF ( lst_vbrp-uepos IS INITIAL AND lv_bhf IS INITIAL ) OR ( lv_lcf IS NOT INITIAL )

    ENDIF.

    CLEAR : lst_final_soc,
            lv_fees,
            lv_disc,
            lv_tax,
            lst_issue_vol,
            lst_issue_vol2,
            lv_total,
            lv_bhf,
            lv_lcf,
            lv_total_val,
            flg_skip_details.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)

***BOC SRBOSE
  IF i_subtotal IS INITIAL.
    lst_subtotal-desc         = lv_text.
    lst_subtotal-vat_tax_val  = v_sales_tax.
    APPEND lst_subtotal TO i_subtotal.
  ENDIF. " IF i_subtotal IS INITIAL
***EOC SRBOSE

*  BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
*    BOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
*    CONCATENATE lv_text v_seller_reg INTO v_seller_reg SEPARATED BY lc_colon.
*    EOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908454
    CONDENSE v_seller_reg.
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
* Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* ELSEIF st_header-bill_country EQ st_header-ship_country.
* End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909977
* Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
* End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909977
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
  ENDIF. " IF v_seller_reg IS NOT INITIAL
*    EOC by SRBOSE.
* Subtotal
  v_subtotal_val = st_vbrk-netwr. " SubTotal Amount

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_vbrk-zlsch EQ 'J'.
    fp_v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.

*--*Begin of  change CR 6376 Prabhu ED2K914917
*  LOOP AT li_tax_item INTO lst_tax_item.
*    lst_tax_item_final-media_type = lst_tax_item-media_type.
*    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
*    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
*    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_header-doc_currency.
*    CONDENSE lst_tax_item_final-taxabl_amt.
*    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
*    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_header-doc_currency.
*    CONDENSE lst_tax_item_final-tax_amount.
**    IF lst_tax_item-tax_amount IS NOT INITIAL.
*    APPEND lst_tax_item_final TO i_tax_item.
*    CLEAR lst_tax_item_final.
**    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
*  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item

*--------------------------------------------------------------------*
*--*End of  change CR 6376 Prabhu ED2K914917

ENDFORM.
*}   INSERT
*&---------------------------------------------------------------------*
*&      Form  GET_MEMBERSHIP_TYPE_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_MEMBERSHIP_TYPE  text
*      -->P_LC_TEXT_ID  text
*      -->P_I_VBKD  text
*      -->P_LST_VBRP  text
*      -->P_ST_KNA1  text
*      <--P_LV_FLAG_MG  text
*      <--P_LV_FLAG_INV  text
*      <--P_LV_MEMBER_TYPE  text
*      <--P_LV_DESC  text
*----------------------------------------------------------------------*
FORM get_membership_type_detail  USING    fp_c_membership_type
                                          fp_lc_text_id
                                          fp_i_vbkd TYPE tt_vbkd
                                          fp_i_vbrp TYPE ty_vbrp
                                          fp_ist_kna1 TYPE ty_kna1
                                 CHANGING fp_lv_flag_mg
                                          fp_lv_flag_inv
                                          fp_lv_member_type
                                          fp_lv_desc.
  CONSTANTS: lc_object TYPE tdobject VALUE 'TEXT'. " Texts: Application Object

*   Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : fp_lv_flag_mg,
          fp_lv_flag_inv,
          fp_lv_desc.
*check whether material group5 have 'IN'(Indirect).
  READ TABLE i_vbap INTO DATA(ist_vbap) WITH KEY vbeln = fp_i_vbrp-vgbel
                                                 posnr = fp_i_vbrp-posnr.
  IF sy-subrc EQ 0.
    IF ist_vbap-mvgr5 EQ c_in.
      fp_lv_flag_mg = c_x.
    ENDIF.
  ENDIF.
*check whether customer type whether summary invoice or
*detail invoice.
  IF  fp_ist_kna1-katr6 EQ c_003.
    fp_lv_flag_inv = c_x.
  ENDIF.
*Get the description for condition group2 value
  READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = fp_i_vbrp-aubel
                                                     posnr = fp_i_vbrp-aupos
                                                      BINARY SEARCH.
  IF sy-subrc EQ 0.
    SELECT SINGLE kdkgr vtext FROM tvkggt
           INTO st_tvkgg
*--*BOC PRABHU CR6376_INC0258402 ED2K915996
           WHERE spras EQ st_header-language
            AND  kdkgr EQ lst_vbkd-kdkg2.
*--*EOC PRABHU CR6376_INC0258402 ED2K915996
    fp_lv_desc = st_tvkgg-vtext.
  ENDIF.
*  ENDIF.
  CLEAR : lv_text,
          fp_lv_member_type.
*get the standard text value.
*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_lc_text_id
      language                = st_header-language
      name                    = fp_c_membership_type
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      fp_lv_member_type = lv_text.
      CONDENSE fp_lv_member_type.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FPLT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBKD  text
*      <--P_I_FPLT  text
*----------------------------------------------------------------------*
FORM f_get_fplt  USING    p_i_vbkd TYPE tt_vbkd
                 CHANGING p_i_fplt TYPE tt_fplt.
* Retrieve PO Number from VBKD table
  SELECT fplnr   " Billing plan number / invoicing plan number
         fpltr   " Item for billing plan/invoice plan/payment cards
         fkdat   " Settlement date for deadline
         fkarv   " Proposed billing type for an order-related billing document
         nfdat   " Settlement date for deadline
         afdat   " Billing date for billing index and printout
    INTO TABLE p_i_fplt
    FROM fplt    " Billing Plan: Dates
    FOR ALL ENTRIES IN p_i_vbkd
    WHERE fplnr EQ p_i_vbkd-fplnr.

  IF sy-subrc EQ 0.
    SORT p_i_fplt BY fplnr afdat.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_GST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_HEADER  text
*----------------------------------------------------------------------*
FORM f_get_gst  USING    p_st_header.
  DATA:lii_dfkkbptaxnum  TYPE TABLE OF dfkkbptaxnum.

  SELECT * FROM dfkkbptaxnum
           INTO TABLE lii_dfkkbptaxnum
           WHERE partner = st_header-bill_cust_number "li_i_vbpa-kunnr
           AND   taxtype IN r_gst_no. "lc_sg0.
  IF lii_dfkkbptaxnum[] IS NOT INITIAL.
    READ TABLE lii_dfkkbptaxnum INTO DATA(lstt_dfkkbptaxnum) INDEX 1.
    IF lstt_dfkkbptaxnum-taxnum IS NOT INITIAL.
      st_header-buyer_reg = lstt_dfkkbptaxnum-taxnum.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ACCOUNTING_DOC_CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_accounting_doc_clear.
  DATA: lv_gjahr TYPE ftis_gjahr,
        lst_bkpf TYPE TABLE OF bkpf,
        lst_bseg TYPE TABLE OF bseg.
  CALL FUNCTION 'FTI_FISCAL_YEAR_MONTH_GET'
    EXPORTING
      i_bukrs = st_vbrk-bukrs
      i_budat = st_vbrk-erdat
*     I_DZTERM       = FTIS_DATUM-INITIAL
*     I_GJAHR = FTIS_GJAHR-INITIAL
    IMPORTING
      e_gjahr = lv_gjahr.
*   E_MONAT        =
  IF lv_gjahr IS NOT INITIAL.
    CALL FUNCTION 'FI_DOCUMENT_READ'
      EXPORTING
*       I_AWTYP     =
*       I_AWREF     =
*       I_AWORG     = ' '
*       I_AWSYS     = ' '
*       I_XNBKL     = ' '
        i_bukrs     = st_vbrk-bukrs
        i_belnr     = st_vbrk-vbeln
        i_gjahr     = lv_gjahr
*       I_BSTAT     = ' '
*       I_XBLNR     = ' '
*       I_BUDAT     =
*       I_BLART     = ' '
*       I_AUTH_RFC  = ' '
* IMPORTING
*       E_AWTYP     =
*       E_AWREF     =
*       E_AWORG     =
*       E_AWSYS     =
      TABLES
*       T_ABUZ      =
*       T_ACCHD     =
*       T_ACCIT     =
*       T_ACCCR     =
        t_bkpf      = lst_bkpf
        t_bseg      = lst_bseg
      EXCEPTIONS
        wrong_input = 1
        not_found   = 2
        OTHERS      = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSEIF lst_bseg[] IS NOT INITIAL.
      READ TABLE lst_bseg INTO DATA(lstt_bseg) INDEX 1.
      IF lstt_bseg-augbl IS NOT INITIAL.
        st_bseg[] = lst_bseg[].
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
