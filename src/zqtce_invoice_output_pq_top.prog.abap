*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_INVOICE_OUTPUT_PQ_TOP
* PROGRAM DESCRIPTION: Invoice list output for large orders from PQ
* DEVELOPER: Himanshu Patel (HIPATEL)
* CREATION DATE:   12/20/2017
* OBJECT ID: E170
* TRANSPORT NUMBER(S): ED2K910001
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
TABLES: vbrk,                     "Billing Document: Header Data
        vbak.                     "Sales Document: Header Data

****Copied from Invoice Driver Program

*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVOICE_FORM_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_INVOICE_FORM_F024
* PROGRAM DESCRIPTION: This include is implemented for global data
*                      declaration
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
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
* Table define
TABLES : tnapr,    " Processing programs for output
         nast,     " Message Status
         toa_dara. "Added by MODUTTA

**********************************************************************
*                        TYPE DECLARATION                            *
**********************************************************************

* VBRK structure
TYPES: BEGIN OF ty_vbrk,
         bstnk_vf TYPE bstkd,     " Purchase Order Number
         vbeln    TYPE vbeln_vf, " Billing Document
         fkart    TYPE fkart,    " Billing Type
         vbtyp    TYPE vbtyp,    " SD document category
         waerk    TYPE waerk,    " SD Document Currency
         vkorg    TYPE vkorg,    " Sales Organization
         knumv    TYPE knumv,    " Number of the document condition
*         fkdat TYPE fkdat,      " Billing date for billing index and printout " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         zterm    TYPE dzterm,     " Terms of Payment Key
         zlsch    TYPE schzw_bseg, " Payment Method
         land1    TYPE land1,      " Country Key
         bukrs    TYPE bukrs,      " Company Code
         netwr    TYPE netwr,      " Net Value in Document Currency
         erdat    TYPE erdat,      " Date on Which Record Was Created  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         kunrg    TYPE kunrg,      " Payer
         kunag    TYPE kunag,      " Sold-to party
         zuonr    TYPE ordnr_v,    " Assignment number
         rplnr    TYPE rplnr,      " Number of payment card plan type
       END OF ty_vbrk,
       tt_vbrk TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0,
       BEGIN OF ty_vbrk_01,
         vbeln TYPE vbeln_vf, " Billing Document
         fkart TYPE fkart,    " Billing Type
         vbtyp TYPE vbtyp,    " SD document category
         waerk TYPE waerk,    " SD Document Currency
         vkorg TYPE vkorg,    " Sales Organization
         knumv TYPE knumv,    " Number of the document condition
*         fkdat TYPE fkdat,      " Billing date for billing index and printout " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         zterm TYPE dzterm,     " Terms of Payment Key
         zlsch TYPE schzw_bseg, " Payment Method
         land1 TYPE land1,      " Country Key
         bukrs TYPE bukrs,      " Company Code
         netwr TYPE netwr,      " Net Value in Document Currency
         erdat TYPE erdat,      " Date on Which Record Was Created  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         kunrg TYPE kunrg,      " Payer
         kunag TYPE kunag,      " Sold-to party
         zuonr TYPE ordnr_v,    " Assignment number
         rplnr TYPE rplnr,      " Number of payment card plan type
       END OF ty_vbrk_01,
       tt_vbrk_01 TYPE STANDARD TABLE OF ty_vbrk_01 INITIAL SIZE 0,
*      ADRC structure
       BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum, " Address number
         title      TYPE ad_title,   " Form-of-Address Key
         name1      TYPE ad_name1,   " Name 1
* BOC by LKODWANI on 21-Jul-2016 TR#ED2K906301
         deflt_comm	TYPE ad_comm,
* EOC by LKODWANI on 21-Jul-2016 TR#ED2K906301
       END OF ty_adrc,
       tt_adrc TYPE STANDARD TABLE OF ty_adrc INITIAL SIZE 0,

*      Type declaration of doc category
       BEGIN OF ty_billtype,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
* Begin of change: PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
*         low   TYPE fkart,
*         high  TYPE fkart,
         low  TYPE vbtyp, " SD document category
         high TYPE vbtyp, " SD document category
* End of change: PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
       END OF ty_billtype,
       tt_billtype TYPE STANDARD TABLE OF ty_billtype INITIAL SIZE 0,

*      Type declaration for country
       BEGIN OF ty_country,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE vkorg,      " Country Key
         high TYPE vkorg,      " Country Key
       END OF ty_country,
       tt_country TYPE STANDARD TABLE OF ty_country INITIAL SIZE 0,

*      VBRP Structure
       BEGIN OF ty_vbrp,
         vbeln TYPE vbeln_vf, " Billing Document
         posnr TYPE posnr_vf, " Billing item
*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR:  ED2K907362
         uepos TYPE uepos, " Higher-level item in bill of material structures
*End of change by SRBOSE on 07-Aug-2017 CR_463 #TR:  ED2K907362
         vbelv TYPE vbelv,      " Originating document
         posnv TYPE posnv,      " Originating item
         aubel TYPE vbeln_va,   " Sales Document
         aupos TYPE posnr_va,   " Sales Document Item
         matnr TYPE matnr,      " Material Number
         arktx TYPE arktx,      " Short text for sales order item
         pstyv TYPE pstyv,      " Sales document item category
         vkbur TYPE vkbur,      " Sales Office
         kzwi1 TYPE kzwi1,      " Subtotal 1 from pricing procedure for condition
         kzwi2 TYPE kzwi2,      " Subtotal 2 from pricing procedure for condition
         kzwi3 TYPE kzwi3,      " Subtotal 3 from pricing procedure for condition
         kzwi5 TYPE kzwi5,      " Subtotal 5 from pricing procedure for condition
         kzwi6 TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
         aland TYPE aland,      " Departure country (country from which the goods are sent)
         lland TYPE lland_auft, " Country of destination of sales order
*        Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
         kowrr TYPE kowrr, " Statistical values
         fareg TYPE fareg, " Rule in billing plan/invoice plan
*        End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
       END OF ty_vbrp,
       tt_vbrp TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,

*      VBPA Structure
       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln, " Sales and Distribution Document Number
         posnr TYPE posnr, " Item number of the SD document
         parvw TYPE parvw, " Partner Function
         kunnr TYPE kunnr, " Customer Number
         adrnr TYPE adrnr, " Address
         land1 TYPE land1, " Country Key
       END OF ty_vbpa,
       tt_vbpa TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,

*      VBFA Structure
       BEGIN OF ty_vbfa,
         vbelv TYPE vbeln_von,  " Preceding sales and distribution document
         posnv TYPE posnr_von,  " Preceding item of an SD document
         vbeln TYPE vbeln_nach, " Subsequent sales and distribution document
         posnn TYPE posnr_nach, " Subsequent item of an SD document
       END OF ty_vbfa,
       tt_vbfa TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,

*      JPTIDCDASSIGN Structure
       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,         " Material Number
         idcodetype TYPE ismidcodetype, " Type of Identification Code
         identcode  TYPE ismidentcode,  " Identification Code
       END OF ty_jptidcdassign,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,

*      MARA Structure
       BEGIN OF ty_mara,
         matnr        TYPE matnr, " Material Number
         bismt        TYPE bismt, " Old material number
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
         mtart        TYPE mtart, " Material Type
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
*Begin of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
         ismmediatype TYPE ismmediatype,
         ismsubtitle1 TYPE ismsubtitle1, "Subtitle 1
         ismsubtitle2 TYPE ismsubtitle2, "Subtitle 2
         ismsubtitle3 TYPE ismsubtitle3, "Subtitle 3
         ismyearnr    TYPE ismjahrgang,  "Media issue year number
*End of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
       END OF ty_mara,
       tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,

*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
       BEGIN OF ty_makt,
         matnr TYPE matnr, " Material Number
         spras TYPE spras, " Language Key
         maktx TYPE maktx, " Material Description (Short Text)
       END OF ty_makt,
       tt_makt TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554

*      Email ID structure
       BEGIN OF ty_email,
         addrnumber TYPE ad_addrnum, " Address number
         persnumber TYPE ad_persnum, " Person number
         smtp_addr  TYPE ad_smtpadr, " E-Mail Address
         valid_from TYPE ad_valfrom, " Communication Data: Valid From (YYYYMMDDHHMMSS)
         valid_to   TYPE ad_valto,   " Communication Data: Valid To (YYYYMMDDHHMMSS)
       END OF ty_email,
       tt_email TYPE STANDARD TABLE OF ty_email INITIAL SIZE 0,

       BEGIN OF ty_emailid,
         smtp_addr TYPE ad_smtpadr,  " E-Mail Address
       END OF ty_emailid,
       tt_emailid TYPE STANDARD TABLE OF ty_emailid INITIAL SIZE 0,

*      VBKD structure
       BEGIN OF ty_vbkd,
         vbeln TYPE vbeln_von, " Preceding sales and distribution document
         posnr TYPE posnr,     " Item number of the SD document
         bstkd TYPE bstkd,     " Customer purchase order number
         ihrez TYPE ihrez,     " Your Reference
       END OF ty_vbkd,
       tt_vbkd TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,

*     Header text structure
       BEGIN OF ty_header_text,
         first_text  TYPE char100, " Text of type CHAR100
         second_text TYPE char100, " Text of type CHAR100
         third_text  TYPE char100, " Text of type CHAR100
       END OF ty_header_text,

*      Condition(KONV) strucure
       BEGIN OF ty_konv,
         knumv TYPE knumv,  " Number of the document condition
         kposn TYPE kposn,  " Condition item number
         stunr TYPE stunr,  " Step number
         zaehk TYPE dzaehk, " Condition counter
         kschl TYPE kscha,  " Condition type
         kwert TYPE kwert,  " Condition value
       END OF ty_konv,
       tt_konv TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,

* Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
* Type declaration fot BUT000
       BEGIN OF ty_but000,
         partner    TYPE bu_partner, " Business Partner Number
         type       TYPE bu_type,    " Business partner category
         persnumber TYPE ad_persnum, " Person number
       END OF ty_but000,

* Type Declaration for BUT020
       BEGIN OF ty_but020,
         partner    TYPE bu_partner, " Business Partner Number
         addrnumber TYPE ad_addrnum, " Address number
       END OF ty_but020,
* End of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208

*      KNA1 Structure
       BEGIN OF ty_kna1,
         kunnr TYPE kunnr, " Customer Number
         spras TYPE spras, " Language Key
         stceg TYPE stceg, " VAT Registration Number
         katr6 TYPE katr6, " Attribute 6
       END OF ty_kna1,
       tt_kna1 TYPE STANDARD TABLE OF ty_kna1 INITIAL SIZE 0,

*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
       tt_tax_id TYPE STANDARD TABLE OF ty_tax_id INITIAL SIZE 0,
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554

*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
*       Veda Structure
       BEGIN OF ty_veda,
         vbeln   TYPE vbeln_va,                        "  Sales Document
         vposn   TYPE  posnr_va,                       " Sales Document Item
         vbegdat TYPE vbdat_veda,                      "  Contract start date
       END OF ty_veda,
       tt_veda TYPE STANDARD TABLE OF ty_veda INITIAL SIZE 0,

       BEGIN OF ty_tax_data,
         document        TYPE /idt/doc_number,         " Document Number
         doc_line_number TYPE /idt/doc_line_number,    " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         invoice_desc    TYPE /idt/invoice_desc,       " Invoice Description
       END OF ty_tax_data,

       BEGIN OF ty_fpltc,
         fplnr TYPE	fplnr,
         fpltr TYPE  fpltr,                            " Item for billing plan/invoice plan/payment cards
         ccnum TYPE ccnum,                             " Payment cards: Card number
         autwr TYPE autwr,                             " Payment cards: Authorized amount
       END OF ty_fpltc,

       BEGIN OF ty_fpla,                               "++ SRBOSE CR_558 TR# ED2K908301
         fplnr TYPE	fplnr,                             " Billing plan number / invoicing plan number
         vbeln TYPE vbeln,                             "  Sales and Distribution Document Number
       END OF ty_fpla,

       BEGIN OF ty_tax_item,
         subs_type      TYPE ismmediatype,
         tax_percentage TYPE char16, " Percentage of type CHAR16
         taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
         tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
         media_type     TYPE char255,
       END OF ty_tax_item,
       tt_tax_item TYPE STANDARD TABLE OF ty_tax_item,
       tt_fpltc    TYPE STANDARD TABLE OF ty_fpltc,
       tt_tax_data TYPE STANDARD TABLE OF ty_tax_data,

       BEGIN OF ty_dwn_pmnt,
         vbelv   TYPE vbeln_von,    "Preceding sales and distribution document
         posnv   TYPE posnr_von,    "Preceding item of an SD document
         vbeln   TYPE vbeln_nach,	          "Subsequent sales and distribution document
         posnn   TYPE posnr_nach,	          "Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,      "Document category of subsequent document
         fktyp   TYPE fktyp,        "Billing category
         netwr   TYPE netwr_fp,     "Net value of the billing item in document currency
         mwsbp   TYPE mwsbp,
       END OF ty_dwn_pmnt,
       tt_dwn_pmnt TYPE STANDARD TABLE OF ty_dwn_pmnt.
**********************************************************************
*                        DATA DECLARATION                            *
**********************************************************************
* Data declaration
DATA : i_vbrp               TYPE tt_vbrp, " IT for VBRP
       i_vbrp_cal           TYPE tt_vbrp,
       i_vbpa               TYPE tt_vbpa, " IT for VBPA
       i_vbpa_py            TYPE tt_vbpa, " IT for VBPA
       i_vbpa_con           TYPE tt_vbpa, " IT for VBPA
       i_vbfa               TYPE tt_vbfa, " IT for VBFA
       i_tax_id             TYPE tt_tax_id, " TAX IDs
       i_makt               TYPE tt_makt,   " Material Descriptions
       i_konv               TYPE tt_konv,          " IT for condition table
       i_txtmodule          TYPE tsftext,          " IT for text module
       i_adrc               TYPE tt_adrc,          " IT for ADRC
       i_jptidcdassign      TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
       i_mara               TYPE tt_mara,          " IT for MARA
       i_vbkd               TYPE tt_vbkd,          " IT for VBKD
       i_email              TYPE tt_email,
       r_country            TYPE tt_country,       " Country key
       r_inv                TYPE tt_billtype,      " Billing type range table for invoice
       r_crd                TYPE tt_billtype,      " Billing type range table for Credit Memo
       r_dbt                TYPE tt_billtype,      " Billing type range table for Debit Memo
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
       r_mtart_med_issue    TYPE fip_t_mtart_range, " Material Types: Media Issues
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
       r_idcodetype         TYPE rjksd_idcodetype_range_tab, "material Identification Code
       i_content_hex        TYPE solix_tab,                  " Content table
       i_emailid            TYPE tt_emailid,                 " IT for email ID
       i_final              TYPE ztqtc_item_detail_f024,     " IT for final table
       i_tax_item           TYPE zttqtc_tax_item_f024,
       i_text_item          TYPE zttqtc_tax_item_f024,
       i_kna1               TYPE tt_kna1,
       st_emailid           TYPE ty_emailid,
       st_header_text       TYPE ty_header_text,             " Text structure
       st_kna1              TYPE ty_kna1,                    " IT for KNA1
       st_header            TYPE zstqtc_header_detail_f024,  " Header structure
       st_but000            TYPE ty_but000, " WA for BUT000
       st_but020            TYPE ty_but020, " WA for BUT020
       st_item              TYPE zstqtc_item_detail_f024, " Item Structure
       st_formoutput        TYPE fpformoutput,            " Form Output (PDF, PDL)
       st_vbrk              TYPE ty_vbrk_01,              " IT for VBRK
       st_vbco3             TYPE vbco3,                   " Sales Doc.Access Methods: Key Fields: Document Printing
       st_email             TYPE ty_email,
       v_xstring            TYPE xstring,                 " Logo Variable
       v_accmngd_title      TYPE char255,                 " Accmngd_title of type CHAR255
       v_reprint            TYPE char255,                 " Reprint    " " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
       v_trig_attr          TYPE katr6,                   " Attribute 6
       v_sales_ofc          TYPE vkbur,                   " Sales Office
       v_country_key        TYPE land1,                   " Country code
       v_remit_to           TYPE thead-tdname,            " Name
       v_footer             TYPE thead-tdname,            " Name
       v_tax                TYPE thead-tdname,            " Name
       v_bank_detail        TYPE thead-tdname,            " Name
       v_output_typ         TYPE sna_kschl,               " Message type
       v_outputyp_summary   TYPE sna_kschl,               " Message type
       v_outputyp_consor    TYPE sna_kschl,               " Message type
       v_outputyp_detail    TYPE sna_kschl,               " Message type
       v_totaldue           TYPE char140,                 " Totaldue of type CHAR140
       v_subtotal           TYPE char140,                 " Subtotal of type CHAR140
       v_prepaidamt         TYPE char140,                 " Subtotal of type CHAR140
       v_vat                TYPE char140,                 " Vat of type CHAR140
       v_proc_status        TYPE na_vstat,                " Processing status of message
*       v_country_key      TYPE landx,                     " Country Name
       v_crdt_card_det      TYPE thead-tdname, " Name
       v_payment_detail     TYPE thead-tdname, " Name
       v_cust_service_det   TYPE thead-tdname, " Name
       v_subtotal_val       TYPE netwr,        " Net Value in Document Currency
       v_sales_tax          TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
       v_totaldue_val       TYPE autwr,        " Total due amount
       v_prepaid_amount     TYPE char20,       " Prepaid amount
       v_paid_amt           TYPE autwr,        " Var to store prepaid amount
       v_ent_retco          LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
       v_ent_screen         TYPE c,            " Screen of type Character
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
       v_faz                TYPE fkart,   " Billing Type
       v_vkorg              TYPE vkorg,   " Sales Organization
       v_country_uk         TYPE land1,   " Country Key
       v_title              TYPE char255, " Title of type CHAR255
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
       i_veda               TYPE tt_veda,
       i_tax_data           TYPE tt_tax_data,
       i_terms_text         TYPE tttext,
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
*Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
       v_txt_name           TYPE tdobname, " Name
       v_text_line          TYPE char255,  " Text_line of type CHAR100
       v_subs_type          TYPE char255,
       v_ind                TYPE xegld,    " Text_line of type CHAR100
       v_year               TYPE char10,   " Year of type CHAR10
       i_subtotal           TYPE ztqtc_subtotal_f024,
       v_ccnum              TYPE char9,    "++SRBOSE CR_558 TR# ED2K908298
       v_credit_text        TYPE tdline,   " Text Line
       i_fpltc              TYPE tt_fpltc,
       v_seller_reg         TYPE tdline,   " Seller VAT Registration Number (++)MODUTTA on 08/08/2017 for CR#408
       v_inv_desc           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       v_invoice_desc       TYPE /idt/invoice_desc, " Invoice Description
       v_payment_detail_inv TYPE thead-tdname,      " Name
       v_sub_type_di        TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       v_sub_type_ph        TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       v_sub_type_mm        TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       v_sub_type_se        TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       v_terms_cond         TYPE string.

DATA : i_dwn_pmnt           TYPE tt_dwn_pmnt.
**********************************************************************
*                    CONSTANT DECLARATION                            *
**********************************************************************
CONSTANTS :        c_we           TYPE parvw            VALUE 'WE',   " Partner Function
                   c_st           TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
                   c_object       TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                   c_id_grun      TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
                   c_obj_mat      TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
                   c_deflt_langu  TYPE sylangu          VALUE 'E',        " Default Language: English
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                   c_subtotal     TYPE tdsfname         VALUE 'ZQTC_SUBTOTAL_F024',           " Subtotal text
                   c_prepaidamt   TYPE tdsfname         VALUE 'ZQTC_PREPAID_AMOUNT_F024',     " Prepaid Amount text
                   c_totaldue     TYPE tdsfname         VALUE 'ZQTC_TOTAL_DUE_F024',          " Total due Text
                   c_name_inv     TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_F024',     " Name of text to be read
                   c_name_dbt     TYPE thead-tdname     VALUE 'ZQTC_DEBIT_MEMO_NUMBER_F024',  " Name of text to be read
                   c_journal      TYPE thead-tdname     VALUE 'ZQTC_JOURNAL_F024',            " Name of text to be read
                   c_name_reprnt  TYPE thead-tdname     VALUE 'ZQTC_REPRINT_F024',            " Name of text to be read
                   c_name_receipt TYPE thead-tdname     VALUE 'ZQTC_RECEIPT_F024',            " Name
                   c_name_crd     TYPE thead-tdname     VALUE 'ZQTC_CREDIT_MEMO_NUMBER_F024', " Name of text to be read
                   c_name_tax_inv TYPE thead-tdname     VALUE 'ZQTC_TAX_INVOICE_F024',        " Name of text to be read
                   c_name_tax_crd TYPE thead-tdname     VALUE 'ZQTC_TAX_CREDIT_F024',         " Name of text to be read

*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
                   c_name_faz     TYPE thead-tdname VALUE 'ZQTC_F024_PROFORMA', " Name
                   c_name_vkorg   TYPE thead-tdname VALUE 'ZQTC_F024_NOT_VAT',  " Name
                   c_posnr_hdr    TYPE posnr        VALUE '000000',             " Item number of the SD document (Header)
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362

*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
                   c_wiley_inv    TYPE thead-tdname     VALUE 'ZQTC_WILEY_INVOICE_F024', " Name
                   c_wiley_crd    TYPE thead-tdname     VALUE 'ZQTC_WILEY_CREDIT_F024',  " Name
                   c_wiley_dbt    TYPE thead-tdname     VALUE 'ZQTC_WILEY_DEBIT_F024',   " Name
                   c_wiley_rec    TYPE thead-tdname     VALUE 'ZQTC_WILEY_RECEIPT_F024', " Name
*           End of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
*Begin of change by SRBOSE on 02-Aug-2017 CR_463 #TR:  ED2K907362
                   c_wiley_pro    TYPE thead-tdname     VALUE 'ZQTC_WILEY_PROFORMA_F024', " Name
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR:  ED2K907362
*Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR:  ED2K907362
                   c_obj_vbbp     TYPE tdobject         VALUE 'VBBP'. " Texts: Application Object

****Copied from Invoice Driver Program





*Invoice Header data
TYPES: BEGIN OF ty_inv_data,
         inv_no   TYPE vbeln_vf,   " Consolidated Invoice
         vbeln    TYPE vbeln_vf,   " Billing Document
         fkart    TYPE fkart,      " Billing Type
         vbtyp    TYPE vbtyp,      " SD document category
         waerk    TYPE waerk,      " SD Document Currency
         vkorg    TYPE vkorg,      " Sales Organization
         knumv    TYPE knumv,      " Number of the document condition
*         fkdat TYPE fkdat,       " Billing date for billing index and printout " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         zterm    TYPE dzterm,     " Terms of Payment Key
         zlsch    TYPE schzw_bseg, " Payment Method
         land1    TYPE land1,      " Country Key
         bukrs    TYPE bukrs,      " Company Code
         netwr    TYPE netwr,      " Net Value in Document Currency
         erdat    TYPE erdat,      " Date on Which Record Was Created  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         kunrg    TYPE kunrg,      " Payer
         kunag    TYPE kunag,      " Sold-to party
         zuonr    TYPE ordnr_v,    " Assignment number
         rplnr    TYPE rplnr,      " Number of payment card plan type
         bstnk_vf TYPE bstkd,     " Purchase Order Number
         vbelv    TYPE vbeln_von,  "Sales Order Number
         kunnr    TYPE kunnr,      "Payer
         vsnmr_v  TYPE vsnmr_v,    "Sales document version number
       END OF ty_inv_data,
       tt_inv_data TYPE STANDARD TABLE OF ty_inv_data,
*Invoice Item data
       BEGIN OF ty_inv_itm,
         inv_no TYPE vbeln_vf,  " Consolidated Invoice
         vbeln  TYPE vbeln_vf,   " Billing Document
         posnr  TYPE posnr_vf,   " Billing item
         uepos  TYPE uepos,      " Higher-level item in bill of material structures
         vbelv  TYPE vbelv,      " Originating document
         posnv  TYPE posnv,      " Originating item
         aubel  TYPE vbeln_va,   " Sales Document
         aupos  TYPE posnr_va,   " Sales Document Item
         matnr  TYPE matnr,      " Material Number
         arktx  TYPE arktx,      " Short text for sales order item
         pstyv  TYPE pstyv,      " Sales document item category
         vkbur  TYPE vkbur,      " Sales Office
         kzwi1  TYPE kzwi1,      " Subtotal 1 from pricing procedure for condition
         kzwi2  TYPE kzwi2,      " Subtotal 2 from pricing procedure for condition
         kzwi3  TYPE kzwi3,      " Subtotal 3 from pricing procedure for condition
         kzwi5  TYPE kzwi5,      " Subtotal 5 from pricing procedure for condition
         kzwi6  TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
         aland  TYPE aland,      " Departure country (country from which the goods are sent)
         lland  TYPE lland_auft, " Country of destination of sales order
         kowrr  TYPE kowrr,      " Statistical values
         fareg  TYPE fareg,      " Rule in billing plan/invoice plan
       END OF ty_inv_itm,

       BEGIN OF ty_po_data,
         bstnk_vf TYPE bstkd,     " Purchase Order Number
         kunnr    TYPE kunnr,      "Payer
         vsnmr_v  TYPE vsnmr_v,    "Sales document version number
       END OF ty_po_data,

       BEGIN OF ty_vbak,
         vbeln   TYPE vbeln_va,   "Sales document
         auart   TYPE auart,      "Document Type
         vkbur   TYPE vkbur,      "Sales Office
         bstnk   TYPE bstnk,      "Customer Purchase no
         vsnmr_v TYPE vsnmr_v,    "Split Number
       END OF ty_vbak,
       tt_vbak TYPE STANDARD TABLE OF ty_vbak,

       BEGIN OF ty_pterms,
         spras TYPE spras,
         zterm TYPE dzterm,
         text1 TYPE text1_052,
       END OF ty_pterms,
       tt_pterms TYPE STANDARD TABLE OF ty_pterms,

       BEGIN OF ty_tkomv,
         knumv TYPE knumv, "Number of the document condition
         kposn TYPE kposn, "Condition item number
         stunr TYPE stunr, "Step number
         zaehk TYPE dzaehk, "Condition counter
         kappl TYPE kappl, " Application
         kawrt TYPE kawrt, "Condition base value
         kbetr TYPE kbetr, "Rate (condition amount or percentage)
         kwert TYPE kwert, "Condition value
         kinak TYPE kinak, "Condition is inactive
         koaid TYPE koaid, "Condition class
       END OF ty_tkomv,
       tt_tkomv TYPE STANDARD TABLE OF ty_tkomv,

       BEGIN OF ty_knumv,
         sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE knumv, "
         high   TYPE knumv, "
       END OF ty_knumv,
       tt_knumv TYPE STANDARD TABLE OF ty_knumv.


DATA: i_vbak     TYPE STANDARD TABLE OF ty_vbak,
      st_vbak    TYPE ty_vbak,
      i_vbrk     TYPE tt_vbrk,
      i_inv_hdr  TYPE STANDARD TABLE OF ty_inv_data,
      st_inv_hdr TYPE ty_inv_data,
      i_inv_itm  TYPE STANDARD TABLE OF ty_inv_itm,
      st_inv_itm TYPE ty_inv_itm,
      i_po_data  TYPE STANDARD TABLE OF ty_po_data,
      st_po_data TYPE ty_po_data,
      i_vbak_old TYPE STANDARD TABLE OF ty_vbak,
      i_pterms   TYPE tt_pterms,
      st_pterms  TYPE ty_pterms,
      i_tkomv    TYPE tt_tkomv,
      st_tkomv   TYPE ty_tkomv,
      r_knumv    TYPE tt_knumv.

DATA: v_cur_rundate TYPE sydatum, " Current Run Date to be updated in ZCAINTERFACE
      v_cur_runtime TYPE syuzeit. " Current Run Time to be updated in ZCAINTERFACE

CONSTANTS: c_devid_e170 TYPE zdevid         VALUE 'E170',        "Development ID: E170
           c_msgty_info TYPE symsgty        VALUE 'I',           "Message type
           c_py         TYPE parvw          VALUE 'RG',          "Payer
           c_sign_i     TYPE sign           VALUE 'I',           "Sign for range table
           c_opt_eq     TYPE option         VALUE 'EQ',          "Sign for range table
           c_m          TYPE vbtyp_n        VALUE 'M',           "Document category of subsequent document
           c_c          TYPE vbtyp_v        VALUE 'C'.           "Document category of preceding SD document
