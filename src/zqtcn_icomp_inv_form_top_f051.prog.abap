*&---------------------------------------------------------------------*
*& Report  ZQTCN_ICOMP_INV_FORM_TOP_F051
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ICOMP_INV_FORM_F051
* PROGRAM DESCRIPTION: This driver program copied from F042 to tigger the TBT for intercompany invoice.
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

TABLES : tnapr,    " Processing programs for output
         nast,     " Message Status
         toa_dara. "Added by MODUTTA

**********************************************************************
*                        TYPE DECLARATION                            *
**********************************************************************

* VBRK structure
TYPES: BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_vf,   " Billing Document
         fkart TYPE fkart,      " Billing Type
         vbtyp TYPE vbtyp,      " SD document category   " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
         waerk TYPE waerk,      " SD Document Currency
         vkorg TYPE vkorg,      " Sales Organization
         knumv TYPE knumv,      " Number of the document condition
         fkdat TYPE fkdat,      " Billing date for billing index and printout
         zterm TYPE dzterm,     " Terms of Payment Key
         zlsch TYPE schzw_bseg, " Payment Method
         land1 TYPE land1,      " Country Key
         bukrs TYPE bukrs,      " Company Code
         netwr TYPE netwr,      " Net Value in Document Currency
         erdat TYPE erdat,      " Date on Which Record Was Created
         kunrg TYPE kunrg,      " Payer
         kunag TYPE kunag,      " Sold-to party
         zuonr TYPE ordnr_v,    " Assignment number
         rplnr TYPE rplnr,      " Number of payment card plan type
       END OF ty_vbrk,
       tt_vbrk TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0,

*      ADRC structure
       BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum, " Address number
         title      TYPE ad_title,   " Form-of-Address Key
         name1      TYPE ad_name1,   " Name 1
       END OF ty_adrc,
       tt_adrc TYPE STANDARD TABLE OF ty_adrc INITIAL SIZE 0,

*      Item text structure
       BEGIN OF ty_item_text,
         tdspras  TYPE spras,    " Language Key
         tdobject TYPE tdobject, " Texts: Application Object
         tdid     TYPE tdid,     " Text ID
         tdtext   TYPE tdtext,   " Short Text
       END OF ty_item_text,
       tt_item_text TYPE STANDARD TABLE OF ty_item_text INITIAL SIZE 0,

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


*      VBRP Structure
       BEGIN OF ty_vbrp,
         vbeln      TYPE vbeln_vf, " Billing Document
         posnr      TYPE posnr_vf, " Billing item
*Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
         uepos      TYPE uepos, " Higher-level item in bill of material structures
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
         fkimg      TYPE fkimg, " Actual Invoiced Quantity
*Begin of change by SRBOSE on 02-Aug-2017 CR_374 #TR: ED2K907591
         meins      TYPE meins, " Base Unit of Measure
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
         vgbel      TYPE vgbel,  "Document number of the reference document
         vgpos      TYPE vgpos,  "Item number of the reference item
         aubel      TYPE vbeln_va,   " Sales Document
         aupos      TYPE posnr_va,   " Sales Document Item
         matnr      TYPE matnr,      " Material Number
         arktx      TYPE arktx,      " Short text for sales order item
         pstyv      TYPE pstyv,      " Sales document item category
         werks      TYPE werks_d,    " Plant "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
         vkbur      TYPE vkbur,      " Sales Office
         kzwi1      TYPE kzwi1,      " Subtotal 1 from pricing procedure for condition
         kzwi2      TYPE kzwi2,      " Subtotal 2 from pricing procedure for condition
         kzwi3      TYPE kzwi3,      " Subtotal 3 from pricing procedure for condition
         kzwi4      TYPE kzwi4,      " Subtotal 4 from pricing procedure for condition
         kzwi5      TYPE kzwi5,      " Subtotal 5 from pricing procedure for condition
         kzwi6      TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
         kvgr1      TYPE kvgr1,      " Customer group 1
         aland      TYPE aland,      " Departure country (country from which the goods are sent)
         lland      TYPE lland_auft, " Country of destination of sales order
*        Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
         kowrr      TYPE kowrr, " Statistical values
         fareg      TYPE fareg, " Rule in billing plan/invoice plan
*        End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K909164
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
         kdkg2      TYPE kdkg2, " Customer condition group 2
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
*        Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
         netwr      TYPE netwr_fp,    " Net value of the billing item in document currency
*        End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
         vkorg_auft TYPE vkorg_auft, " Sales Org "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       END OF ty_vbrp,
       tt_vbrp TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,

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

*
       BEGIN OF ty_country,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
*         low  TYPE land1,      " Country Key
         low  TYPE vkorg, " Country Key
*         high TYPE land1,      " Country Key
         high TYPE vkorg, " Country Key
       END OF ty_country,
       tt_country TYPE STANDARD TABLE OF ty_country INITIAL SIZE 0,

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
         vbelv TYPE vbeln_von,           " Preceding sales and distribution document
         posnv TYPE posnr_von,           " Preceding item of an SD document
         vbeln TYPE vbeln_nach,          " Subsequent sales and distribution document
         posnn TYPE posnr_nach,          " Subsequent item of an SD document
       END OF ty_vbfa,
       tt_vbfa TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,

       BEGIN OF ty_jksesched,
         vbeln    TYPE vbeln,            " Sales and Distribution Document Number
         posnr    TYPE posnr,            " Item number of the SD document
         issue    TYPE ismmatnr_issue,   " Media Issue
         product  TYPE ismmatnr_product, " Media Product
         sequence	TYPE jmsequence,
       END OF ty_jksesched,
       tt_jksesched TYPE STANDARD TABLE OF ty_jksesched INITIAL SIZE 0,

*      Type declaration of Billtype
       BEGIN OF ty_billtype,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
* Begin of Change: PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
         low  TYPE vbtyp, " SD document category
         high TYPE vbtyp, " SD document category
*         low  TYPE fkart,      " Billing Type
*         high TYPE fkart,      " Billing Type
* End of Change: PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
       END OF ty_billtype,
       tt_billtype TYPE STANDARD TABLE OF ty_billtype INITIAL SIZE 0,

       BEGIN OF ty_mvgr5,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE mvgr5,
         high TYPE mvgr5,
       END OF ty_mvgr5,
       tt_mvgr5 TYPE STANDARD TABLE OF ty_mvgr5 INITIAL SIZE 0,

***Begin of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
       BEGIN OF ty_mvgr5_scc,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE mvgr5,
         high TYPE mvgr5,
       END OF ty_mvgr5_scc,
       tt_mvgr5_scc TYPE STANDARD TABLE OF ty_mvgr5_scc INITIAL SIZE 0,

       BEGIN OF ty_mvgr5_scm,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE mvgr5,
         high TYPE mvgr5,
       END OF ty_mvgr5_scm,
       tt_mvgr5_scm TYPE STANDARD TABLE OF ty_mvgr5_scm INITIAL SIZE 0,
***End of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051

       BEGIN OF ty_bstzd,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE  bstzd,
         high TYPE bstzd,
       END OF ty_bstzd,
       tt_bstzd TYPE STANDARD TABLE OF ty_bstzd INITIAL SIZE 0,

*      JPTIDCDASSIGN Structure
       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,         " Material Number
         idcodetype TYPE ismidcodetype, " Type of Identification Code
         identcode  TYPE ismidentcode,  " Identification Code
       END OF ty_jptidcdassign,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,

*      MARA Structure
       BEGIN OF ty_mara,
         matnr           TYPE matnr, " Material Number
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         mtart           TYPE mtart, " Material Type
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
         volum           TYPE volum, " Volume
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
         ismmediatype    TYPE ismmediatype,  " Media Type
         ismnrinyear     TYPE ismnrimjahr,   " Issue Number (in Year Number)
         ismcopynr       TYPE ismheftnummer, " Copy Number of Media Issue (++SRBOSE CR_618 TR:ED2K908908)
         ismyearnr       TYPE ismjahrgang,   " Media issue year number
       END OF ty_mara,
       tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,

*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       BEGIN OF ty_makt,
         matnr TYPE matnr, " Material Number
         spras TYPE spras, " Language Key
         maktx TYPE maktx, " Material Description (Short Text)
       END OF ty_makt,
       tt_makt TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529

*      VBKD structure
       BEGIN OF ty_vbkd,
         vbeln TYPE vbeln_von, " Preceding sales and distribution document
         posnr TYPE posnr,     " Item number of the SD document
         bstkd TYPE bstkd,     " Customer purchase order number
         ihrez TYPE ihrez,     " Your Reference
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
         kdkg2 TYPE kdkg2, " Customer condition group 2
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
       END OF ty_vbkd,
       tt_vbkd TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,

*     Header text structure
       BEGIN OF ty_header_text,
         first_text  TYPE char100, " Text of type CHAR100
         second_text TYPE char100, " Text of type CHAR100
         third_text  TYPE char100, " Text of type CHAR100
       END OF ty_header_text,

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

*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
       tt_tax_id TYPE STANDARD TABLE OF ty_tax_id INITIAL SIZE 0,
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529

*Begin of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*   VBAK Structure
       BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va, "  Sales Document
         bstzd TYPE bstzd,    " Purchase order number supplement
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
         auart TYPE auart, " Sales Document Type
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
       END OF ty_vbak,

       BEGIN OF ty_tax_data,                           " ++ change by SRBOSE on 08-Aug-2017 CR_408 #TR:ED2K907591
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         invoice_desc    TYPE /idt/invoice_desc,       " Invoice Description
       END OF ty_tax_data,

       tt_tax_data TYPE STANDARD TABLE OF ty_tax_data, " ++ change by SRBOSE on 08-Aug-2017 CR_408 #TR:ED2K907591
*End of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591

*Begin of change by MODUTTA on 08-Aug-2017 CR_438 #TR:ED2K907591
       BEGIN OF ty_fpltc,
         fplnr TYPE	fplnr,
         fpltr TYPE  fpltr, " Item for billing plan/invoice plan/payment cards
         ccnum TYPE ccnum,  " Payment cards: Card number
         autwr TYPE autwr,  " Payment cards: Authorized amount
       END OF ty_fpltc,
*     Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       BEGIN OF ty_aust_text,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE werks_d,    " Plant. Low
         high TYPE werks_d,    " Plant. High
       END OF ty_aust_text,
       tt_aust_text TYPE STANDARD TABLE OF ty_aust_text INITIAL SIZE 0,
       BEGIN OF ty_sales_org_text,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE vkorg_auft, " Sales Org. Low
         high TYPE vkorg_auft, " Sales Org. High
       END OF ty_sales_org_text,
       tt_sales_org_text TYPE STANDARD TABLE OF ty_sales_org_text INITIAL SIZE 0,
*     End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       BEGIN OF ty_fpla,    "++ SRBOSE CR_558 TR# ED2K908301
         fplnr TYPE	fplnr,  " Billing plan number / invoicing plan number
         vbeln TYPE	vbeln,  "	Sales and Distribution Document Number
       END OF ty_fpla,

       tt_fpltc TYPE STANDARD TABLE OF ty_fpltc,
*       BOC by SRBOSE on 17/10/2017 for CR#666
       BEGIN OF ty_tax_item,
*        Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
         subs_type      TYPE ismmediatype,
*        End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911317
         media_type     TYPE char255,
         tax_percentage TYPE char16, " Percentage of type CHAR16
         taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
         tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
       END OF ty_tax_item,

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
       BEGIN OF ty_stxl,
         tdname TYPE tdobname,  "Name
       END OF ty_stxl,
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376

       tt_tax_item TYPE STANDARD TABLE OF ty_tax_item,
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
       tt_std_text TYPE STANDARD TABLE OF ty_stxl.
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
*       EOC by SRBOSE on 17/10/2017 for CR#666
DATA : i_subtotal TYPE ztqtc_subtotal_f042,
*End of change by MODUTTA on 08-Aug-2017 CR_438 #TR:ED2K907591
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
       i_input    TYPE ztqtc_supplement_ret_input. " Customer Attribute for Condition Groups
*  EOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
TYPES : BEGIN OF ty_iss_vol2,
          matnr TYPE matnr,         " Material Number
          stvol TYPE ismheftnummer, " Copy Number of Media Issue
          stiss TYPE ismnrimjahr,   " Media Issue
          noi   TYPE sytabix,       " Row Index of Internal Tables
        END OF  ty_iss_vol2.

TYPES : BEGIN OF ty_iss_vol3,
          matnr TYPE matnr,         " Material Number
          stvol TYPE ismheftnummer, " Copy Number of Media Issue
          stiss TYPE ismnrimjahr,   " Media Issue
          noi   TYPE sytabix,       " Row Index of Internal Tables
        END OF ty_iss_vol3.

TYPES : BEGIN OF ty_tvlzt,
          spras	 TYPE spras,      " Language Key
          vlaufk TYPE vlauk_veda, " Validity period category of contract
          bezei	 TYPE bezei20,    " Description
        END OF ty_tvlzt,
        tt_tvlzt TYPE STANDARD TABLE OF ty_tvlzt INITIAL SIZE 0,
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
        BEGIN OF ty_veda,
          vbeln   TYPE vbeln_va,            " Sales Document
          vposn   TYPE posnr_va,            " Sales Document Item
          vlaufk  TYPE vlauk_veda,          " Validity period category of contract
          vbegdat TYPE vbdat_veda,          " Contract start date
        END OF ty_veda,

        BEGIN OF ty_vbap,
          vbeln TYPE vbeln_va,              " Sales Document
          posnr TYPE posnr_va,              " Sales Document Item
          mvgr5 TYPE mvgr5,                 " Material group 5
        END OF ty_vbap,

        BEGIN OF ty_society,
          society      TYPE zzpartner2,     " Business Partner 2 or Society number
          society_name TYPE zzsociety_name, " Society Name
        END OF ty_society.

**********************************************************************
*                        DATA DECLARATION                            *
**********************************************************************
* Data declaration
DATA : i_vbrp               TYPE tt_vbrp,      " IT for VBRP
       i_vbpa               TYPE tt_vbpa,      " IT for VBPA
       i_vbfa               TYPE tt_vbfa,      " IT for VBFA
       i_jksesched          TYPE tt_jksesched, " IT for VBFA
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
       i_tax_id             TYPE tt_tax_id, " TAX IDs
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
       i_txtmodule          TYPE tsftext,          " IT for text module
       i_konv               TYPE tt_konv,          " IT for condition table
       i_adrc               TYPE tt_adrc,          " IT for ADRC
       i_jptidcdassign      TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
       i_mara               TYPE tt_mara,          " IT for MARA
       i_mara_lvl2          TYPE tt_mara,          " IT for MARA
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       i_makt               TYPE tt_makt, " Material Descriptions
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       i_emailid            TYPE tt_emailid,
       i_vbkd               TYPE tt_vbkd,                    " IT for VBKD
       i_content_hex        TYPE solix_tab,                  " Content table
       i_final_css          TYPE ztqtc_item_detail_css_f042, " CSS Final table
       i_final_tbt          TYPE ztqtc_item_detail_tbt_f042, " TBT final table
       i_final_soc          TYPE ztqtc_item_detail_soc_f042, " Society final table
       r_inv                TYPE tt_billtype,                " Billing type range table of invoice
       r_crd                TYPE tt_billtype,                " Billing type range table of credit memo
       r_dbt                TYPE tt_billtype,                " Billing type range table of debit memo
       r_country            TYPE tt_country,                 " Country
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      r_bstzd_email        TYPE tt_bstzd,
*      r_bstzd_no_email     TYPE tt_bstzd,
*      r_mvgr5_in           TYPE tt_mvgr5,
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       r_mvgr5_ma           TYPE tt_mvgr5,
       i_tax_item           TYPE zttqtc_tax_item_f042,
       i_text_item          TYPE zttqtc_tax_item_f042,
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       r_aust_text          TYPE tt_aust_text,    " Plant
       r_sales_org_text     TYPE tt_sales_org_text,    " Sales Org
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       r_mtart_med_issue    TYPE fip_t_mtart_range, " Material Types: Media Issues
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       st_header_text       TYPE ty_header_text,            " Text structure
       st_header            TYPE zstqtc_header_detail_f042, " Header structure
       st_kna1              TYPE ty_kna1,                   " IT for KNA1
       st_item              TYPE zstqtc_item_detail_f024,   " Item Structure
       i_item_text          TYPE tt_item_text,              " Item Texts
       st_formoutput        TYPE fpformoutput,              " Form Output (PDF, PDL)
       st_vbrk              TYPE ty_vbrk,                   " IT for VBRK
       st_vbco3             TYPE vbco3,                     " Sales Doc.Access Methods: Key Fields: Document Printing
*      Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
       st_but000            TYPE ty_but000, " WA for BUT000
       st_but020            TYPE ty_but020, " WA for BUT020
*      End of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
       i_iss_vol2           TYPE STANDARD TABLE OF ty_iss_vol2 INITIAL SIZE 0,
       i_iss_vol3           TYPE STANDARD TABLE OF ty_iss_vol3 INITIAL SIZE 0,
       i_vbap               TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
       i_society            TYPE STANDARD TABLE OF ty_society INITIAL SIZE 0,
       v_xstring            TYPE xstring,      " Logo Variable
       v_accmngd_title      TYPE char255,      " Accmngd_title of type CHAR255
       v_invoice_title      TYPE char255,      " (++SRBOSE CR_618)
       v_reprint            TYPE char255,      " Reprint
       v_remit_to           TYPE thead-tdname, " Name
       v_footer             TYPE thead-tdname, " Name
       v_tax                TYPE thead-tdname, " Name
       v_bank_detail        TYPE thead-tdname, " Name
       v_formname           TYPE fpname,       " Formname
       v_country_key        TYPE land1,        " Country code
       v_society_text       TYPE name1_gp,     " Society text
       v_totaldue           TYPE char140,      " Totaldue of type CHAR140
       v_subtotal           TYPE char140,      " Subtotal of type CHAR140
       v_vat                TYPE char140,      " Vat of type CHAR140
       v_shipping           TYPE char140,      " Shipping of type CHAR140
       v_proc_status        TYPE na_vstat,     " Processing status of message
       v_society_logo       TYPE xstring,      " Logo Variable
       v_bill_cntry         TYPE landx,        " Country Name
       v_txt_name           TYPE tdobname,     " Name
       v_output_typ         TYPE sna_kschl,    " Message type
       v_outputyp_css       TYPE sna_kschl,    " Message type
       v_outputyp_tbt       TYPE sna_kschl,    " Message type
       v_outputyp_idr       TYPE sna_kschl,    " Message type
       v_outputyp_soc       TYPE sna_kschl,    " Message type
       v_crdt_card_det      TYPE thead-tdname, " Name
       v_prepaidamt         TYPE char140,      " Subtotal of type CHAR140
       v_text_line          TYPE char100,      " Text_line of type CHAR100
       v_txt_line           TYPE char255,      " Text_line of type CHAR100
       v_subs_type          TYPE char255,      " Text_line of type CHAR100
       v_payment_detail     TYPE thead-tdname, " Name
       v_subscription_typ   TYPE char100,      " Subscription_typ of type CHAR100
       v_prepaid_amount     TYPE char20,       " Prepaid amount
       v_cust_service_det   TYPE thead-tdname, " Name
       v_subtotal_val       TYPE netwr,        " Net Value in Document Currency
       v_sales_tax          TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
       v_totaldue_val       TYPE autwr,        " Total due amount
       v_shipping_val       TYPE kzwi6,        " Shipping amount
       v_paid_amt           TYPE autwr,        " Var to store prepaid amount
       v_ent_retco          LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
       v_faz                TYPE fkart,   " Billing Type
       v_vkorg              TYPE vkorg,   " Sales Organization
       v_country_uk         TYPE land1,   " Country Key
       v_title              TYPE char255, " Title of type CHAR255
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
       v_ent_screen         TYPE c, " Screen of type Character
*Begin of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      v_bstzd_flag         TYPE xfeld, " Checkbox
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       v_psb                TYPE kvgr1, " Customer group 1
       v_kvgr1              TYPE kvgr1, " Customer group 1
*       v_seller_reg       TYPE /idt/seller_registration, " Seller VAT Registration Number (++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
       v_seller_reg         TYPE tdline,      " Seller VAT Registration Number (++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
       i_tax_data           TYPE tt_tax_data, "(++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
       v_ind                TYPE xegld,       "(++)SRBOSE on 08/12/2017 for CR#408: TR:ED2K907591
*End of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*Begin of change by MODUTTA on 08-Aug-2017 CR_558 #TR:ED2K907591
       i_fpltc              TYPE tt_fpltc,
       v_credit_text        TYPE tdline, " Text Line
       i_credit             TYPE zttqtc_credit_f042,
       v_ccnum              TYPE char9,  " Ccnum of type CHAR9
       v_kunnr              TYPE kunag,
*End of change by MODUTTA on 08-Aug-2017 CR_558 #TR:ED2K907591
       v_invoice_desc       TYPE /idt/invoice_desc, " Invoice Description
       v_payment_detail_inv TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_crdt_card_det_inv  TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_terms              TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_inv_desc           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       i_terms_text         TYPE tttext,
       v_terms_cond         TYPE string,
       v_comm_method        TYPE ad_comm,           " Communication Method (Key) (Business Address Services)
*BOC BY SRBOSE CR_666 ON 18-Oct-2017
       v_sub_type_di        TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_ph        TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_mm        TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_se        TYPE rvari_vnam, " ABAP: Name of Variant Variable
*EOC BY SRBOSE CR_666 ON 18-Oct-2017
***Begin of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
       v_scc                TYPE xfeld, " Scc of type CHAR1
       v_scm                TYPE xfeld, " Scm of type CHAR1
***End of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
       v_auart              TYPE auart, " Sales Document Type
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
       r_idcodetype         TYPE rjksd_idcodetype_range_tab,
       v_idcodetype_1       TYPE ismidcodetype, " Type of Identification Code
       v_idcodetype_2       TYPE ismidcodetype, " Type of Identification Code
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      v_society            TYPE xfeld,         " Material group 5
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       i_tvlzt              TYPE TABLE OF ty_tvlzt,
       v_start_year         TYPE char4,         " Start_year of type CHAR4
       i_veda               TYPE STANDARD TABLE OF ty_veda,
       st_tvlzt             TYPE ty_tvlzt,
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
***Begin of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
       r_mvgr5_scc          TYPE tt_mvgr5_scc,
       r_mvgr5_scm          TYPE tt_mvgr5_scm,
*      Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
       r_sanc_countries     TYPE temr_country,
*      End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
***End of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
       i_exc_tab            TYPE zttqtc_exchange_tab_invoice,
       v_waers              TYPE waers_005, " Country currency
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
*      Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
       v_local_curr         TYPE hwaer,
*      End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       v_aust_text          TYPE string,      " Australin text
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
       v_ind_text           TYPE string,      " Indain Tax text
       v_tax_expt           TYPE string,      " Tax Expt
       v_gst_no             TYPE bptaxnum,    " GST No
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
       i_std_text           TYPE tt_std_text,
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
       r_mat_grp5           TYPE RANGE OF salv_de_selopt_low.
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
**********************************************************************
*                    CONSTANT DECLARATION                            *
**********************************************************************

CONSTANTS :          c_we                TYPE parvw            VALUE 'WE',   " Partner Function
                     c_st                TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
                     c_object            TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                     c_id_grun           TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
                     c_obj_mat           TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
                     c_deflt_langu       TYPE sylangu          VALUE 'E',        " Default Language: English
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
                     c_subtotal          TYPE tdsfname         VALUE 'ZQTC_SUBTOTAL_F024',           " Subtotal text
                     c_totaldue          TYPE tdsfname         VALUE 'ZQTC_TOTAL_DUE_F024',          " Total due Text
                     c_prepaidamt        TYPE tdsfname         VALUE 'ZQTC_PREPAID_AMOUNT_F024',     " Prepaid Amount text
                     c_shipping          TYPE tdsfname         VALUE 'ZQTC_SHIPPING_F042',           " Smart Forms: Form Name
                     c_obj_vbbp          TYPE tdobject         VALUE 'VBBP',                         " Texts: Application Object
                     c_css_form          TYPE fpname           VALUE 'ZQTC_FRM_INV_CSS_F042',        " CSS form layout
                     c_tbt_form          TYPE fpname           VALUE 'ZQTC_FRM_INV_TBT_F042',        " TBT form layout
                     c_idr_form          TYPE fpname           VALUE 'ZQTC_FRM_ICOMP_INV_IDR_F051',        " TBT form layout
                     c_soc_form          TYPE fpname           VALUE 'ZQTC_FRM_INV_SOCIETY_F042',    " Society form layout
                     c_name_inv          TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_F024',     " Invoice Number text
                     c_name_receipt      TYPE thead-tdname     VALUE 'ZQTC_RECEIPT_F024',            " Receipt Text
                     c_name_dbt          TYPE thead-tdname     VALUE 'ZQTC_DEBIT_MEMO_NUMBER_F024',  " Debit memo number text
                     c_journal           TYPE thead-tdname     VALUE 'ZQTC_JOURNAL_F024',            " Journal Text
                     c_name_reprnt       TYPE thead-tdname     VALUE 'ZQTC_REPRINT_F024',            " Reprint Text
                     c_name_crd          TYPE thead-tdname     VALUE 'ZQTC_CREDIT_MEMO_NUMBER_F024', " Credit Memo number Text
                     c_name_tax_inv      TYPE thead-tdname     VALUE 'ZQTC_TAX_INVOICE_F024',        " Tax Invoice Text
                     c_name_tax_crd      TYPE thead-tdname     VALUE 'ZQTC_TAX_CREDIT_F024',         " Tax credit text
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
                     c_name_faz          TYPE thead-tdname     VALUE 'ZQTC_F042_PROFORMA',           " Name
                     c_name_vkorg        TYPE thead-tdname     VALUE 'ZQTC_F042_NOT_VAT',            " Name
                     c_name_inv_faz      TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_FAZ_F024', "(++ SRBOSE CR_618 TR:ED2K908908)
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
                     c_tax_invoice       TYPE thead-tdname VALUE 'ZQTC_F024_TAX_INVOICE_TEXT', "ADD:ERP-7462:SGUDA:17-SEP-2018:ED2K913365
                     c_tax_invoice_idr   TYPE thead-tdname VALUE 'ZQTC_F042_TAX_INVOICE_IDR',
*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
                     c_wiley_inv         TYPE thead-tdname     VALUE 'ZQTC_WILEY_INVOICE_F024', " Name
                     c_wiley_crd         TYPE thead-tdname     VALUE 'ZQTC_WILEY_CREDIT_F024',  " Name
                     c_wiley_dbt         TYPE thead-tdname     VALUE 'ZQTC_WILEY_DEBIT_F024',   " Name
                     c_wiley_rec         TYPE thead-tdname     VALUE 'ZQTC_WILEY_RECEIPT_F024', " Name
*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
                     c_comm_method       TYPE ad_comm VALUE 'LET', " Communication Method (Key) (Business Address Services)
*Begin of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
                     c_wiley_pro         TYPE thead-tdname     VALUE 'ZQTC_WILEY_PROFORMA_F024', " Name
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
* BOC: CR#7730 KKRAVURI20181012  ED2K913596
                     c_membership_number TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX'.  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181012  ED2K913596
