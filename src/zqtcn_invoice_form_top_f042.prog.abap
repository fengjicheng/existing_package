*&---------------------------------------------------------------------*
*&  Include            ZQTCN_INVOICE_FORM_TOP_F042
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
* REVISION NO: DEFECT 2516
* REFERENCE NO: ED2K906208
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 05-June-2017
* DESCRIPTION: Change logic for credit memo. Decide invoice type based
*              on document category. Change logic for PO Number
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
* REVISION NO:  ERP-7178 (CR)
* REFERENCE NO: ED2K911550
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         21/03/2018
* DESCRIPTION:  Display Exchange Rates if Document Currency and Local
*               Currency are different
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7462
* REFERENCE NO: ED2K913350
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/14/2018
* DESCRIPTION:  If bill-to is Australian customer from 1001 sales org
*               and order has specified Australian titles, need to print
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7543 & 7459
* REFERENCE NO: ED2K913365
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/18/2018
* DESCRIPTION:  business partner, identification, tax numbers.
*               If category = IN0 (India), print the statement below
*               with the respective #.
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
* DESCRIPTION:  Changes for Member ship type,if material group5 is IN
*AND Customer type is summary invoice or detail invoice
*----------------------------------------------------------------------*
* REVISION NO:  ED2K919951
* REFERENCE NO: ERPM-16179/ERPM-20007
* DEVELOPER:    Siva Guda (SGUDA) / Lahiru Wathudura(LWATHUDURA)
* DATE:         10/16/2020
* DESCRIPTION: Multiple Po number display and new output for cancelled
*              invoice and cancelled credit memo
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-45440
* REFERENCE NO:  ED2K923401
* DEVELOPER   :  SGUDA
* DATE        :  12/MAY/2021
* DESCRIPTION :  Need Invoice outputs for 1002508249 for FY21
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-4948
* REFERENCE NO:  ED2K923935/ED2K923958
* DEVELOPER   :  RAJKUMAR MADAVOINA(MRAJKUMAR)
* DATE        :  17/JUNE/2021
* DESCRIPTION :  Print TAX INVOICE instead of Receipt for BillToCountry/
*                ShipToCountry Equal to India.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  FMM-2242/OTCM-40083
* REFERENCE NO:  ED2K924189
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  20/JULY/2021
* DESCRIPTION :  Brexit Related Changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-4948
* REFERENCE NO:  ED2K924466
* DEVELOPER   :  RAJKUMAR MADAVOINA(MRAJKUMAR)
* DATE        :  2/SEPT/2021
* DESCRIPTION :  Print different Signature Text for Credit Memo Requests
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40086
* REFERENCE NO: ED2K924580
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         09/15/2021
* DESCRIPTION:
* 1) if Material group4 (VBRP- MVGR4= BK- eBooks, JU-eJournal, BU-eBundle
*    then print the media type as Digital
* 2) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue then print the media type as Print
* 3) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue, BK- eBooks, JU-eJournal, BU-eBundle then print
*    the media type as Print & digital.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42834 INC0333245
* REFERENCE NO:  ED2K924649
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  30/SEP/2021
* DESCRIPTION :  Exchange rate rounding causing JPY amount on invoice to be incorrect
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-52516
* REFERENCE NO:  ED2K924824
* DEVELOPER   :  Murali (mimmadiset)
* DATE        :  09/OCT/2021
* DESCRIPTION : Adding the change for J&J Ed project
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913791
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-54509
* REFERENCE NO:  ED2K925058,ED2K925180
* DEVELOPER   :  Murali (mimmadiset)
* DATE        :  24/Nov/2021
* DESCRIPTION : Adding the change for EJournalPress project for output type ZMAI
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-54290,54796,54719
* REFERENCE NO:  ED2K925511
* DEVELOPER   :  Murali (mimmadiset)
* DATE        :  1/11/2022
* DESCRIPTION : 1.J&J Flat rate invoice changes
*2.Logo for j&j output type
*3.Email body change for j&j output type
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-61258
* REFERENCE NO:  ED2K927184
* DEVELOPER   :  Murali (mimmadiset)
* DATE        :  05/06/2022
* DESCRIPTION : Invoice description from VBRP in Oable project

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
         sfakn TYPE sfakn,      " Original document number
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
         vkgrp      TYPE vkgrp,      " Sales Group  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
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
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
         mvgr4      TYPE mvgr4,
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
         mvgr5      TYPE mvgr5, "CR#6376 - SKKAIRAMKO - 01/24/2019
         vkorg_auft TYPE vkorg_auft, " Sales Org "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
         abrbg      TYPE abrbg, "settlement period "++mimmadiset OTCM-54509 ED2K925058
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
         vbelv   TYPE vbeln_von,           " Preceding sales and distribution document
         posnv   TYPE posnr_von,           " Preceding item of an SD document
         vbeln   TYPE vbeln_nach,          " Subsequent sales and distribution document
         posnn   TYPE posnr_nach,          " Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,  "Document category of subsequent document
         vbtyp_v TYPE vbtyp_v, " Document category of preceding SD document
         stufe   TYPE stufe_vbfa,          " Level of the document flow record  " SGUDA on 03/15/2021 for OTCM-39738/INC0352240 with ED2K922842
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
         fplnr TYPE fplnr,     " Billing plan number / invoicing plan number "ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
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
* Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
       BEGIN OF ty_fplt,
         fplnr TYPE	fplnr,  " Billing plan number / invoicing plan number
         fpltr TYPE fpltr,  " Item for billing plan/invoice plan/payment cards
         fkdat TYPE bfdat,  " Settlement date for deadline
         fkarv TYPE fkara,  " Proposed billing type for an order-related billing document
         nfdat TYPE nfdat,  " Settlement date for deadline
         afdat TYPE fkdat,  " Billing date for billing index and printout
       END OF ty_fplt,

       tt_fplt TYPE STANDARD TABLE OF ty_fplt,
* End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
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
          posnr TYPE posnr,         " Item Number           " NPOLINA ED1K909026  INC0216814
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
          venddat TYPE vndat_veda,          " Contract End Date "ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
        END OF ty_veda,

        BEGIN OF ty_vbap,
          vbeln    TYPE vbeln_va,              " Sales Document
          posnr    TYPE posnr_va,              " Sales Document Item
*** Boc 10/08/2021 mimmadiset OTCM-52516  ED2K924824
          kdmat    TYPE matnr_ku,
***Eoc 10/08/2021 mimmadiset OTCM-52516  ED2K924824
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
          mvgr4    TYPE mvgr4,                 " Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
          mvgr5    TYPE mvgr5,                 " Material group 5
* Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
          zzcovryr TYPE vbap-zzcovryr,         " Cover Year
          zzcovrmt TYPE vbap-zzcovrmt,         " Cover Month
* End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
        END OF ty_vbap,
*       * BOC: CR#6376 KJAGANA20181122  ED2K913919
        BEGIN OF ty_tvkgg,
          kdkgr TYPE kdkgr,
          vtext TYPE char255,
        END OF ty_tvkgg,

        tt_vbap_ch TYPE STANDARD TABLE OF ty_vbap,
*        * EOC: CR#6376 KJAGANA20181122  ED2K913919
*       * BOC: CR#6376 KJAGANA20181227   ED2K914107
        BEGIN OF ty_soc_item,
          description TYPE char255,
          quantity    TYPE fkimg,
          amount      TYPE kzwi1,
          discount    TYPE kzwi5,
          tax         TYPE kzwi6,
          total       TYPE kzwi5,
          item        TYPE posnr_vf,
        END OF   ty_soc_item,
*       * EOC: CR#6376 KJAGANA20182712  ED2K914107
        BEGIN OF ty_society,
          society      TYPE zzpartner2,     " Business Partner 2 or Society number
          society_name TYPE zzsociety_name, " Society Name
        END OF ty_society,
*--BOC : CR#6376 SKKAIRAMKO - 1/24/2019
        BEGIN OF ty_final_soc,
          description TYPE char255,
          cust_group  TYPE kdkg2,
          tax_percent TYPE char10,
          quantity    TYPE fkimg,
          unit_price  TYPE char20,
          amount      TYPE kzwi1,
          discount    TYPE kzwi5,
          tax         TYPE kzwi6,
          total       TYPE kzwi5,
        END OF ty_final_soc,


        tt_final_soc TYPE STANDARD TABLE OF ty_final_soc.

*--EOC: CR#6376 SKKAIRAMKO - 1/24/2019

**********************************************************************
*                        DATA DECLARATION                            *
**********************************************************************
* Data declaration
DATA : i_vbrp                   TYPE tt_vbrp,      " IT for VBRP
       i_vbpa                   TYPE tt_vbpa,      " IT for VBPA
       i_vbfa                   TYPE tt_vbfa,      " IT for VBFA
       i_jksesched              TYPE tt_jksesched, " IT for VBFA
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
       i_tax_id                 TYPE tt_tax_id, " TAX IDs
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908529
       i_txtmodule              TYPE tsftext,          " IT for text module
       i_konv                   TYPE tt_konv,          " IT for condition table
       i_adrc                   TYPE tt_adrc,          " IT for ADRC
       i_jptidcdassign          TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
       i_mara                   TYPE tt_mara,          " IT for MARA
       i_mara_lvl2              TYPE tt_mara,          " IT for MARA
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       i_makt                   TYPE tt_makt, " Material Descriptions
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       i_emailid                TYPE tt_emailid,
       i_vbkd                   TYPE tt_vbkd,                    " IT for VBKD
       i_content_hex            TYPE solix_tab,                  " Content table
       i_content_hex_t          TYPE solix_tab,                  " Content table
       i_final_css              TYPE ztqtc_item_detail_css_f042, " CSS Final table
       i_final_tbt              TYPE ztqtc_item_detail_tbt_f042, " TBT final table
       i_final_soc              TYPE ztqtc_item_detail_soc_f042, " Society final table
       i_fplt                   TYPE tt_fplt, "ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
*--*Begin of change Prabhu CR#6376 ED2K914917
       i_final_summery          TYPE  ztqtc_item_detail_soc_f042, " Society detailed final table
*--*End of change Prabhu CR#6376 ED2K914917
       r_inv                    TYPE tt_billtype,                " Billing type range table of invoice
       r_crd                    TYPE tt_billtype,                " Billing type range table of credit memo
       r_dbt                    TYPE tt_billtype,                " Billing type range table of debit memo
       r_country                TYPE tt_country,                 " Country
       i_output                 TYPE ztqtc_output_supp_retrieval,   " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      r_bstzd_email        TYPE tt_bstzd,
*      r_bstzd_no_email     TYPE tt_bstzd,
*      r_mvgr5_in           TYPE tt_mvgr5,
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       r_mvgr5_ma               TYPE tt_mvgr5,
       i_tax_item               TYPE zttqtc_tax_item_f042,
       i_text_item              TYPE zttqtc_tax_item_f042,
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       r_aust_text              TYPE tt_aust_text,    " Plant
       r_sales_org_text         TYPE tt_sales_org_text,    " Sales Org
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       r_mtart_med_issue        TYPE fip_t_mtart_range, " Material Types: Media Issues
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
       st_header_text           TYPE ty_header_text,            " Text structure
       st_header                TYPE zstqtc_header_detail_f042, " Header structure
       st_kna1                  TYPE ty_kna1,                   " IT for KNA1
       st_item                  TYPE zstqtc_item_detail_f024,   " Item Structure
       i_item_text              TYPE tt_item_text,              " Item Texts
       st_formoutput            TYPE fpformoutput,              " Form Output (PDF, PDL)
       st_vbrk                  TYPE ty_vbrk,                   " IT for VBRK
       st_vbco3                 TYPE vbco3,                     " Sales Doc.Access Methods: Key Fields: Document Printing
       st_bseg                  TYPE TABLE OF bseg,             " Accounting Document Cleard "ADD:ERPM-24413:SGUDA:14-SEP-2020:ED2K919475
*      Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
       st_but000                TYPE ty_but000, " WA for BUT000
       st_but020                TYPE ty_but020, " WA for BUT020
*      End of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
       i_iss_vol2               TYPE STANDARD TABLE OF ty_iss_vol2 INITIAL SIZE 0,
       i_iss_vol3               TYPE STANDARD TABLE OF ty_iss_vol3 INITIAL SIZE 0,
       i_vbap                   TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
       i_society                TYPE STANDARD TABLE OF ty_society INITIAL SIZE 0,
       v_xstring                TYPE xstring,      " Logo Variable
       v_accmngd_title          TYPE char255,      " Accmngd_title of type CHAR255
       v_invoice_title          TYPE char255,      " (++SRBOSE CR_618)
       v_reprint                TYPE char255,      " Reprint
       v_remit_to               TYPE thead-tdname, " Name
       v_footer                 TYPE thead-tdname, " Name
       v_tax                    TYPE thead-tdname, " Name
       v_bank_detail            TYPE thead-tdname, " Name
       v_formname               TYPE fpname,       " Formname
       v_country_key            TYPE land1,        " Country code
       v_society_text           TYPE string,       " name1_gp,     " Society text
       v_totaldue               TYPE char140,      " Totaldue of type CHAR140
       v_subtotal               TYPE char140,      " Subtotal of type CHAR140
       v_vat                    TYPE char140,      " Vat of type CHAR140
       v_shipping               TYPE char140,      " Shipping of type CHAR140
       v_proc_status            TYPE na_vstat,     " Processing status of message
       v_society_logo           TYPE xstring,      " Logo Variable
       v_bill_cntry             TYPE landx,        " Country Name
       v_txt_name               TYPE tdobname,     " Name
       v_output_typ             TYPE sna_kschl,    " Message type
       v_outputyp_css           TYPE sna_kschl,    " Message type
       v_outputyp_tbt           TYPE sna_kschl,    " Message type
       v_outputyp_soc           TYPE sna_kschl,    " Message type
       v_outputyp_jji           TYPE sna_kschl,    " Message type ++ mimmadiset OTCM-52516 ED2K924824
       v_crdt_card_det          TYPE thead-tdname, " Name
       v_prepaidamt             TYPE char140,      " Subtotal of type CHAR140
       v_text_line              TYPE char100,      " Text_line of type CHAR100
       v_txt_line               TYPE char255,      " Text_line of type CHAR100
       v_subs_type              TYPE char255,      " Text_line of type CHAR100
       v_payment_detail         TYPE thead-tdname, " Name
       v_subscription_typ       TYPE char100,      " Subscription_typ of type CHAR100
       v_prepaid_amount         TYPE char20,       " Prepaid amount
       v_cust_service_det       TYPE thead-tdname, " Name
       v_subtotal_val           TYPE netwr,        " Net Value in Document Currency
       v_sales_tax              TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
       v_totaldue_val           TYPE autwr,        " Total due amount
       v_shipping_val           TYPE kzwi6,        " Shipping amount
       v_paid_amt               TYPE autwr,        " Var to store prepaid amount
       v_ent_retco              LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
       v_faz                    TYPE fkart,   " Billing Type
* Begin of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
       v_start_year1            TYPE char4,         " Start_year of type CHAR4
* End of Change ADD:INC0218384:04/12/2018:RBTIRUMALA:ED1K909026
       v_vkorg                  TYPE vkorg,   " Sales Organization
       v_country_uk             TYPE land1,   " Country Key
       v_title                  TYPE char255, " Title of type CHAR255
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
       v_ent_screen             TYPE c, " Screen of type Character
*Begin of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      v_bstzd_flag         TYPE xfeld, " Checkbox
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       v_psb                    TYPE kvgr1, " Customer group 1
       v_kvgr1                  TYPE kvgr1, " Customer group 1
*       v_seller_reg       TYPE /idt/seller_registration, " Seller VAT Registration Number (++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
       v_seller_reg             TYPE tdline,      " Seller VAT Registration Number (++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
* BOC by SGUDA on 10/16/2020 for OTCM-14498 with ED2K919951 *
       v_seller_reg_1           TYPE tdline,  "ERPM-14498
       v_seller_reg_2           TYPE tdline,  "ERPM-14498
* EOC by SGUDA on 10/16/2020 for OTCM-14498 with ED2K919951 *
       i_tax_data               TYPE tt_tax_data, "(++)SRBOSE on 08/08/2017 for CR#408: TR:ED2K907591
       v_ind                    TYPE xegld,       "(++)SRBOSE on 08/12/2017 for CR#408: TR:ED2K907591
*End of change by SRBOSE on 08-Aug-2017 CR_438 #TR:ED2K907591
*Begin of change by MODUTTA on 08-Aug-2017 CR_558 #TR:ED2K907591
       i_fpltc                  TYPE tt_fpltc,
       v_credit_text            TYPE tdline, " Text Line
       i_credit                 TYPE zttqtc_credit_f042,
       v_ccnum                  TYPE char9,  " Ccnum of type CHAR9
       v_kunnr                  TYPE kunag,
*End of change by MODUTTA on 08-Aug-2017 CR_558 #TR:ED2K907591
       v_invoice_desc           TYPE /idt/invoice_desc, " Invoice Description
       v_payment_detail_inv     TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_crdt_card_det_inv      TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_terms                  TYPE thead-tdname,      " Desc_flag of type CHAR1
       v_inv_desc               TYPE rvari_vnam,        " ABAP: Name of Variant Variable
       i_terms_text             TYPE tttext,
       v_terms_cond             TYPE string,
       v_comm_method            TYPE ad_comm,           " Communication Method (Key) (Business Address Services)
*BOC BY SRBOSE CR_666 ON 18-Oct-2017
       v_sub_type_di            TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_ph            TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_mm            TYPE rvari_vnam, " ABAP: Name of Variant Variable
       v_sub_type_se            TYPE rvari_vnam, " ABAP: Name of Variant Variable
*EOC BY SRBOSE CR_666 ON 18-Oct-2017
       r_logo_col               TYPE RANGE OF salv_de_selopt_low, " ABAP: Name of Variant Variable "ADD:OTCM-55203:SGUDA:28-FEB-2022:ED2K925904
***Begin of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
       v_scc                    TYPE xfeld, " Scc of type CHAR1
       v_scm                    TYPE xfeld, " Scm of type CHAR1
***End of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
       v_auart                  TYPE auart, " Sales Document Type
*  BOC by SRBOSE on 11-DEC-2017 #TR: ED2K909786
* BOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
       r_idcodetype             TYPE rjksd_idcodetype_range_tab,
       v_idcodetype_1           TYPE ismidcodetype, " Type of Identification Code
       v_idcodetype_2           TYPE ismidcodetype, " Type of Identification Code
*Begin of DEL:ERP-6712:WROY:22-Feb-2018:ED2K911002
*      v_society            TYPE xfeld,         " Material group 5
*End   of DEL:ERP-6712:WROY:22-Feb-2018:ED1K911002
       i_tvlzt                  TYPE TABLE OF ty_tvlzt,
       v_start_year             TYPE char4,         " Start_year of type CHAR4
       i_veda                   TYPE STANDARD TABLE OF ty_veda,
       st_tvlzt                 TYPE ty_tvlzt,
* EOC by SRBOSE on 8-JAN-2018 #TR: ED2K910115 for CR_XXX
***Begin of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
       r_mvgr5_scc              TYPE tt_mvgr5_scc,
       r_mvgr5_scm              TYPE tt_mvgr5_scm,
*      Begin of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
       r_sanc_countries         TYPE temr_country,
*      End   of ADD:ERP-6599:SRBOSE:04-Apr-2018:ED2K911788
***End of Change: SRBOSE on 23-Feb-2018: CR_XXX: TR:ED2K911051
*- Begin of ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
       r_payee_countries        TYPE temr_country,
       r_vkorg_3310             TYPE RANGE OF salv_de_selopt_low,
       r_vkorg_5501             TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
*- Begin of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
       r_currency_country       TYPE RANGE OF salv_de_selopt_low,
       r_bill_doc_type_curr     TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:ERPM-1380:SGUDA:9-APR-2020:ED2K917952
* BOC by SGUDA on 03/15/2021 for OTCM-39738 with ED2K922543
       r_ftp_email              TYPE RANGE OF salv_de_selopt_low,
       r_ftp_po_type            TYPE RANGE OF salv_de_selopt_low,
       r_ftp_output_type        TYPE RANGE OF salv_de_selopt_low,
* EOC by SGUDA on 03/15/2021 for OTCM-39738 with ED2K922543
* Begin of ADD:OTCM-45440:SGUDA:12-MAY-2021:ED2K923401
       r_ftp_bpid               TYPE RANGE OF salv_de_selopt_low,
* Begin of ADD:OTCM-45440:SGUDA:12-MAY-2021:ED2K923401
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*       r_billing_type_zf2   TYPE RANGE OF salv_de_selopt_low,
*       r_billing_type_zcr   TYPE RANGE OF salv_de_selopt_low,
*       r_ship_to_country    TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
***Begin of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
       i_exc_tab                TYPE zttqtc_exchange_tab_invoice,
       v_waers                  TYPE waers_005, " Country currency
***End of Change: SRBOSE on 06-Mar-2018: CR_744: TR:ED2K911175
*      Begin of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
       v_local_curr             TYPE hwaer,
*      End   of ADD:WROY:ERP-7178:21-Mar-2018:ED2K911550
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
       v_aust_text              TYPE string,      " Australin text
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
       v_ind_text               TYPE string,      " Indain Tax text
       v_tax_expt               TYPE string,      " Tax Expt
       v_gst_no                 TYPE bptaxnum,    " GST No
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
       i_std_text               TYPE tt_std_text,
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911376
* BOC: CR#7730 KKRAVURI20181015  ED2K913596
       r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181015  ED2K913596
* BOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
       v_receipt_flag           TYPE abap_bool,
       v_barcode                TYPE char100,
       r_bill_doc_type          TYPE RANGE OF salv_de_selopt_low,
       st_tvkgg                 TYPE ty_tvkgg,
*   Begin of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
       r_print_product          TYPE RANGE OF salv_de_selopt_low,
       r_digital_product        TYPE RANGE OF salv_de_selopt_low,
*   End of ADD:ERP-7480:SGUDA:21-Feb-2019:ED1K909721
*   Begin of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
       r_bill_doc_type_zibp     TYPE RANGE OF salv_de_selopt_low,
*   End of ADD:ERPM-2048:SGUDA:07-JAN-2020:ED2K917207
*   Begin of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
       r_document_type          TYPE RANGE OF salv_de_selopt_low,
       r_document_catg          TYPE RANGE OF salv_de_selopt_low,
       r_material_group         TYPE RANGE OF salv_de_selopt_low,
       v_auart_tmp              TYPE auart, " Sales Document Type
*   End of ADD:ERPM-4390:SGUDA:22-June-2020:ED2K918642
       v_ref_curr               TYPE bwaer_curv,                  " Reference currency for currency translation "ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952
       r_gst_no                 TYPE RANGE OF  salv_de_selopt_low, "ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
       v_credit_memo            TYPE char1,  "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916657
       v_year_2                 TYPE char30,                      " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_cntr_end               TYPE char30,                      " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_cntr_month             TYPE char30,                      " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_cntr                   TYPE char30,                      " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_day(2)                 TYPE c,                           " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_month(2)               TYPE c,                           " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_year2(4)               TYPE c,                           " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_stext                  TYPE t247-ktx,                    " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_ltext                  TYPE t247-ltx,                    " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910147
       v_unit_price             TYPE kzwi1,                       " Unit Price "ADD:DM-1932:SGUDA:09-JULY-2019:ED2K915669
       st_output                TYPE zstqtc_output_supp_retrieval, " Output structure for E098-Output Supplement Retrieval
*   Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
       st_formoutput_f044       TYPE fpformoutput, " Form Output (PDF, PDL)
       v_vkorg_f044             TYPE vkorg,        " Sales Organization
       v_zlsch_f044             TYPE schzw_bseg,   " Payment Method
       v_waerk_f044             TYPE waerk,        " SD Document Currency
       v_scenario_f044          TYPE char3,        " Scenario_f044 of type CHAR3
       v_ihrez_f044             TYPE ihrez,        " Your Reference
       v_adrnr_f044             TYPE adrnr,        " Address
       v_kunnr_f044             TYPE kunnr,        " Customer Number
       v_langu_f044             TYPE spras,        " Language Key
       v_xstring_f044           TYPE xstring,
       v_scenario_tbt           TYPE char1,       " TBT Scenario
       v_mem_text               TYPE char1,       " MemberShip Text
       v_scenario_scc           TYPE char1,       " Society Scenario(SCC)
       v_scenario_scm           TYPE char1,       " Society Member Scenario(SCM)
       v_kvgr1_f044             TYPE kvgr1,        " Customer group 1
       r_vkorg_f044             TYPE RANGE OF salv_de_selopt_low, " Range table for VKORG
       r_zlsch_f044             TYPE RANGE OF salv_de_selopt_low,
       r_kvgr1_f044             TYPE RANGE OF salv_de_selopt_low,
       r_frm_f044               TYPE RANGE OF salv_de_selopt_low,
*   End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919427
* Begin of ADD:OTCM-4948:MRAJKUMAR:17-JUNE-2021:ED2K923935
       r_bill_ship_country      TYPE TABLE OF shp_land1_range,
       r_billing_type           TYPE TABLE OF range_fkart,
* Begin of ADD:OTCM-4948:MRAJKUMAR:02-SEPT-2021:ED2K924466
*      v_text_flag             TYPE abap_bool,
       v_taxinvoice_flag        TYPE abap_bool,
       v_signature_text         TYPE char100,
* End of ADD:OTCM-4948:MRAJKUMAR:02-SEPT-2021:ED2K924466
* End of ADD:OTCM-4948:MRAJKUMAR:17-JUNE-2021:ED2K923935
* BOC by SGUDA on 10/16/2020 for OTCM-16179 with ED2K919951 *
*       v_po_lines           TYPE char1,   "ERPM-16179
* EOC by SGUDA on 10/16/2020 for OTCM-16179 with ED2K919951 *
*  Begin of ADD:FMM-2242/OTCM-40083:SGUDA:20-JULY-2021:ED2K924189
       r_sales_org_1001         TYPE RANGE OF salv_de_selopt_low,
       r_our_taxid_eu           TYPE RANGE OF salv_de_selopt_low,
       r_bill_to_country_eu     TYPE RANGE OF salv_de_selopt_low,
       r_sales_org_3310         TYPE RANGE OF salv_de_selopt_low,
       r_our_taxid_fr           TYPE RANGE OF salv_de_selopt_low,
       r_bill_to_country_fr     TYPE RANGE OF salv_de_selopt_low,
       st_t005                  TYPE t005,
*  End of ADD:FMM-2242/OTCM-40083:SGUDA:20-JULY-2021:ED2K924189
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
       r_comp_code              TYPE RANGE OF  salv_de_selopt_low,
       r_sales_office           TYPE RANGE OF  salv_de_selopt_low,
       r_docu_currency          TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
       r_print_media_product    TYPE RANGE OF salv_de_selopt_low,
       r_digital_media_product  TYPE RANGE OF salv_de_selopt_low,
       li_print_media_product   TYPE TABLE OF ty_vbap,
       li_digital_media_product TYPE TABLE OF ty_vbap,
       lst_digital              TYPE ty_vbap,
       lst_print                TYPE ty_vbap,
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
       r_currency_from          TYPE RANGE OF salv_de_selopt_low,
       r_currency_to            TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
*- Begin of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919496
       r_doc_type               TYPE RANGE OF salv_de_selopt_low,
       r_pay_method             TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:ERPM-24413:SGUDA:14-SEP-2020: ED2K919496
*** Boc 11/24/2021 mimmadiset OTCM-54509 ED2K925058,ED2K925180
       r_kschl                  TYPE RANGE OF salv_de_selopt_low,
       r_kschl_inv              TYPE RANGE OF salv_de_selopt_low, "++mimmadiset OTCM-61258 05/06/2022 ED2K927184
       r_cust_srv               TYPE RANGE OF salv_de_selopt_low,
*** Eoc 11/24/2021 mimmadiset OTCM-54509 ED2K925058,ED2K925180
*- Begin of ADD:OTCM-48718/OTCM-60474:SGUDA:31-MAR-2022:ED2K926474
       r_ind_sales_office       TYPE RANGE OF salv_de_selopt_low,
       r_ind_po_type            TYPE RANGE OF salv_de_selopt_low,
       r_ind_output             TYPE RANGE OF salv_de_selopt_low,
       v_suppress_credit_card   TYPE char1,
*- End of ADD:OTCM-48718/OTCM-60474:SGUDA:31-MAR-2022:ED2K926474
**BOC OTCM-54796,54719 ED2K925511 MIMMADISET 1/11/2022
       r_kschl_logo             TYPE RANGE OF salv_de_selopt_low,
       r_kschl_body             TYPE RANGE OF salv_de_selopt_low.
**EOC OTCM-54796,54719 ED2K925511 MIMMADISET 1/11/2022
* EOC: CR#7431&7189  KKRAVURI20181109  ED2K913809
*--BOC: by SKKAIRAMKO - 1/24/2019
DATA:                flg_summary TYPE c.

*--EOC: BY SKKAIRAMKO - 1/24/2019

**********************************************************************
*                    CONSTANT DECLARATION                            *
**********************************************************************

CONSTANTS : c_we                  TYPE parvw            VALUE 'WE',   " Partner Function
            c_st                  TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
            c_object              TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
            c_id_grun             TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
            c_obj_mat             TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
            c_deflt_langu         TYPE sylangu          VALUE 'E',        " Default Language: English
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908529
*            c_subtotal           TYPE tdsfname         VALUE 'ZQTC_SUBTOTAL_F024',           " Subtotal text
            c_subtotal            TYPE tdsfname         VALUE 'ZQTC_SUBTOTAL_F042',           " Subtotal text  " added by nrmodugu ERPM-2190
            c_totaldue            TYPE tdsfname         VALUE 'ZQTC_TOTAL_DUE_F024',          " Total due Text
            c_prepaidamt          TYPE tdsfname         VALUE 'ZQTC_PREPAID_AMOUNT_F024',     " Prepaid Amount text
            c_shipping            TYPE tdsfname         VALUE 'ZQTC_SHIPPING_F042',           " Smart Forms: Form Name
            c_obj_vbbp            TYPE tdobject         VALUE 'VBBP',                         " Texts: Application Object
            c_css_form            TYPE fpname           VALUE 'ZQTC_FRM_INV_CSS_F042',        " CSS form layout
            c_tbt_form            TYPE fpname           VALUE 'ZQTC_FRM_INV_TBT_F042',        " TBT form layout
            c_soc_form            TYPE fpname           VALUE 'ZQTC_FRM_INV_SOCIETY_F042',    " Society form layout
*--*Begin of change Prabhu CR#6376 ED2K914917
            c_soc_comb_form       TYPE fpname            VALUE 'ZQTC_FRM_INV_SOCIETY_COMB_F042', "Society form new
*--*End of change Prabhu CR#6376 ED2K914917
            c_name_inv            TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_F024',     " Invoice Number text
            c_name_receipt        TYPE thead-tdname     VALUE 'ZQTC_RECEIPT_F024',            " Receipt Text
            c_name_dbt            TYPE thead-tdname     VALUE 'ZQTC_DEBIT_MEMO_NUMBER_F024',  " Debit memo number text
            c_journal             TYPE thead-tdname     VALUE 'ZQTC_JOURNAL_F024',            " Journal Text
            c_name_reprnt         TYPE thead-tdname     VALUE 'ZQTC_REPRINT_F024',            " Reprint Text
            c_name_crd            TYPE thead-tdname     VALUE 'ZQTC_CREDIT_MEMO_NUMBER_F024', " Credit Memo number Text
            c_name_tax_inv        TYPE thead-tdname     VALUE 'ZQTC_TAX_INVOICE_F024',        " Tax Invoice Text
            c_name_tax_crd        TYPE thead-tdname     VALUE 'ZQTC_TAX_CREDIT_F024',         " Tax credit text
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
            c_name_faz            TYPE thead-tdname     VALUE 'ZQTC_F042_PROFORMA',           " Name
            c_name_vkorg          TYPE thead-tdname     VALUE 'ZQTC_F042_NOT_VAT',            " Name
            c_name_inv_faz        TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_FAZ_F024', "(++ SRBOSE CR_618 TR:ED2K908908)
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907591
            c_tax_invoice         TYPE thead-tdname VALUE 'ZQTC_F024_TAX_INVOICE_TEXT', "ADD:ERP-7462:SGUDA:17-SEP-2018:ED2K913365
*            c_tax_credit         TYPE thead-tdname VALUE 'ZQTC_F042_TAX_CREDIT_TEXT',  "ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
            c_wiley_inv           TYPE thead-tdname     VALUE 'ZQTC_WILEY_INVOICE_F024', " Name
            c_wiley_crd           TYPE thead-tdname     VALUE 'ZQTC_WILEY_CREDIT_F024',  " Name
            c_wiley_dbt           TYPE thead-tdname     VALUE 'ZQTC_WILEY_DEBIT_F024',   " Name
            c_wiley_rec           TYPE thead-tdname     VALUE 'ZQTC_WILEY_RECEIPT_F024', " Name
*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
            c_comm_method         TYPE ad_comm VALUE 'LET', " Communication Method (Key) (Business Address Services)
*Begin of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
            c_wiley_pro           TYPE thead-tdname     VALUE 'ZQTC_WILEY_PROFORMA_F024', " Name
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR: ED2K907591
* BOC: CR#7730 KKRAVURI20181012  ED2K913596
            c_membership_number   TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX',  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181012  ED2K913596
* BOC: CR#6376 KJAGANA20181122  ED2K913919
            c_membership_type     TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_TYPE_F042',  " Standard Text Name
            c_in                  TYPE char2 VALUE 'IN', "Material Group(indirect)
            c_doc_cat             TYPE vbtyp VALUE 'M', "Doc category
            c_x                   TYPE char1 VALUE 'X',
            c_001                 TYPE char3 VALUE '001', "Summary invoice for customer
            c_003                 TYPE char3 VALUE '003', "Detail invoice for customer
            c_05                  TYPE char2 VALUE '05', "Student Member
            c_08                  TYPE char2 VALUE '08',  "Member
* EOC: CR#6376 KJAGANA20181122  ED2K913919
* Begin of ADD:OTCM-4948:MRAJKUMAR:17-JUNE-2021:ED2K923935
            c_billtype            TYPE char26 VALUE 'SIGNATURETEXT_BILLING_TYPE',
            c_country             TYPE char21 VALUE 'SIGNATURETEXT_COUNTRY',
* End of ADD:OTCM-4948:MRAJKUMAR:17-JUNE-2021:ED2K923935
* Begin of ADD:OTCM-4948:MRAJKUMAR:02-SEPT-2021:ED2K924466
            c_creditmemo_text     TYPE char30   VALUE 'ZQTC_CREDIT_TAX_STATEMENT_F024',
            c_signature_text      TYPE char23   VALUE 'ZQTC_TAX_STATEMENT_F024',
            c_creditmemo          TYPE char1    VALUE 'O',
* End of ADD:OTCM-4948:MRAJKUMAR:02-SEPT-2021:ED2K924466
* Begin of ADD:FMM-2242/OTCM-40083:SGUDA:20-JULY-2021:ED2K924189
            c_sales_org_1001      TYPE char20  VALUE 'SALES_ORG_1001',
            c_sales_org_3310      TYPE char20  VALUE 'SALES_ORG_3310',
            c_our_taxid_fr        TYPE char20  VALUE 'OUR_TAXID_FR',
            c_our_taxid_eu        TYPE char20  VALUE 'OUR_TAXID_EU',
            c_bill_to_eu          TYPE char20  VALUE 'BILL_TO_EU',
            c_bill_to_fr          TYPE char20  VALUE 'BILL_TO_FR',
            c_param2_our_taxid    TYPE char20  VALUE 'OUR_TAXID',
* End of ADD:FMM-2242/OTCM-40083:SGUDA:20-JULY-2021:ED2K924189
            c_di                  TYPE mara-ismmediatype VALUE 'DI',
            c_ph                  TYPE mara-ismmediatype VALUE 'PH',
            c_o                   TYPE vbrk-vbtyp VALUE 'O',
            c_0                   TYPE char1 VALUE '0',
            c_comma               TYPE char1 VALUE ',',    " CR#7431&7189 KKRAVURI20181109  ED2K913809
            c_posnr               TYPE posnr VALUE '000000',     " Item number of the SD document "CR-7841:SGUDA:30-Apr-2019:ED1K910147
            c_cntr_start          TYPE thead-tdname VALUE 'ZQTC_F042_CNT_STRT_DATE',  " Contract Start Date "CR-7841:SGUDA:30-Apr-2019:ED1K910147
            c_cntr_end            TYPE thead-tdname VALUE 'ZQTC_F042_CNT_END_DATE',   " Contract End Date "CR-7841:SGUDA:30-Apr-2019:ED1K910147
            c_sub_term            TYPE thead-tdname VALUE 'ZQTC_SUB_TERM_F042',       " Name  "ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
            c_of                  TYPE vbap-mvgr5 VALUE 'OF',              "ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
            c_mem_type            TYPE tdobname     VALUE 'ZQTC_F042_MEM_TYPE', "ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
            c_tbt_cust_serv_5501  TYPE thead-tdname VALUE 'ZQTC_F042_TBT_CUST_SERV_5501_XXX', "ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
            c_tbt_cust_serv_3310  TYPE thead-tdname VALUE 'ZQTC_F042_TBT_CUST_SERV_3310_XXX', "ADD:ERP-7282:SGUDA:20-MAY-2019:ED1K910185
            c_excrate_typ_m       TYPE kurst_curr VALUE 'M',        "ADD:ERPM-15474:SGUDA:9-APR-2020:ED2K917952     Exchange Rate Type
            c_sp                  TYPE vbpa-parvw VALUE 'SP',  " Forwrding Agent " ADD:ERPM-2232:SGUDA:26-June-2020:EED2K918761
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
            c_comp_code           TYPE rvari_vnam VALUE 'COMPANY_CODE',
            c_docu_currency       TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
            c_sales_office        TYPE rvari_vnam VALUE 'SALES_OFFICE',
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
            c_india_po_sales_text TYPE rvari_vnam VALUE 'ZQTC_F042_TBT_0050_0161'. "ADD:OTCM-48718/OTCM-60474:SGUDA:31-MAR-2022:ED2K926474
* BOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919951 *
DATA : r_cinv        TYPE tt_billtype,
       r_ccrd        TYPE tt_billtype,
       i_month_names TYPE ftps_web_month_t. " Month name and short text ++mimmadiset OTCM-54509 ED2K925058

CONSTANTS : c_org_doc          TYPE thead-tdname     VALUE  'ZQTC_ORIGINAL_DOCUMENT_F042',
            c_can_inv          TYPE thead-tdname     VALUE  'ZQTC_CREDIT_NOTE_F042',
            c_can_crd_note     TYPE thead-tdname     VALUE  'ZQTC_TAX_INVOICE_F042',
            c_minus            TYPE char01           VALUE  '-',
*** Boc 10/08/2021 mimmadiset OTCM-52516 ED2K924824
            c_jji_cust_service TYPE char30     VALUE 'ZQTC_F042_JJI_CUST_SERV',     " Cust_service
* *** Boc 11/24/2021 mimmadiset OTCM-54509 ED2K925058,ED2K925180
            c_mai_output       TYPE sna_kschl  VALUE 'ZMAI',                    " Message type
            c_mai_cust_service TYPE char30     VALUE 'ZQTC_F042_CUST_SERV_',     " Cust_service
**BOC OTCM-54719 ED2K925511 MIMMADISET 1/11/2022
            c_ma_sub           TYPE thead-tdname     VALUE 'ZQTC_EMAILSUB_OUTPUT_F042_', " Subject
            c_cr               TYPE char5            VALUE '_CR',
            c_inv              TYPE char5            VALUE '_INV',
            c_ma_body          TYPE thead-tdname     VALUE 'ZQTC_EMAILBODY_OUTPUT_F042_'. " Email body
**EOC OTCM-54719 ED2K925511 MIMMADISET 1/11/2022
*** Eoc 11/24/2021 mimmadiset OTCM-54509 ED2K925058,ED2K925180
*BOC by RBRAHMADI on 10/22/2021 for  OTCM-52516 with ED2K924901
*            c_jji_crd_card_det TYPE char30     VALUE 'ZQTC_F042_JJI_CREDIT_CARD'.   " Crd_card_det of type CHAR22
*EOC by RBRAHMADI on 10/22/2021 for  OTCM-52516 with ED2K924901
*** Eoc 10/08/2021 mimmadiset OTCM-52516 ED2K924824
* EOC by Lahiru on 10/16/2020 for OTCM-20007 with ED2K919951 *
* BOC by Lahiru on 10/16/2020 for OTCM-16179 with ED2K919951 *
*            c_multiple_po  TYPE thead-tdname     VALUE  'ZQTC_MULTIPLE_PO',
*            c_po_number    TYPE thead-tdname     VALUE  'ZQTC_PO_NUMBER'.
*
*DATA :      v_po_text       TYPE char255.
* EOC by Lahiru on 10/16/2020 for OTCM-16179 with ED2K919951 *
