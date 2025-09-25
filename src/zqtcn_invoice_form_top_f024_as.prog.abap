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
* REVISION NO:  ERP-7178 (CR)
* REFERENCE NO: ED2K911548
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         21/03/2018
* DESCRIPTION:  Display Exchange Rates if Document Currency and Local
*               Currency are different
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  F024 - CR#6802
* REFERENCE NO: ED2K912204/ED2K912369
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE:         20/06/2018
* DESCRIPTION:  Inclusion of Proforma Invoice Form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  F024 - CR#6842
* REFERENCE NO: ED2K912846
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE:         01/08/2018
* DESCRIPTION:  Inclusion of ZMBR changes in Invoice Form
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
* REVISION NO:  ERP-7543 and 7459
* REFERENCE NO: ED2K913375
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/18/2018
* DESCRIPTION: Customer is tax exempt - 7459
*              Add Indian Tax text    - 7543
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR# 7431 & 7189
* REFERENCE NO: ED2K913769
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         05-November-2018
* DESCRIPTION:  Changes for Remittance Coupon
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  RITM0081486
* REFERENCE NO: ED1K908963
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         11/14/2018
* DESCRIPTION:  Logic change to get tax from VBRK for ZSCS
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  DM1897
* REFERENCE NO:  ED2K915832
* DEVELOPER   :  Nageswar (NPOLINA)
* DATE        :  05/Aug/2019
* DESCRIPTION :  Email ID logic to trigger ZF2 Invoice to specific or Bill to
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
         vbeln TYPE vbeln_vf,        " Billing Document
         fkart TYPE fkart,           " Billing Type
         vbtyp TYPE vbtyp,           " SD document category
         waerk TYPE waerk,           " SD Document Currency
         vkorg TYPE vkorg,           " Sales Organization
         knumv TYPE knumv,           " Number of the document condition
         fkdat TYPE fkdat,           " Billing date for billing index and printout " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         rfbsk TYPE rfbsk,           " Status for transfer to accounting  CR#6802 KKR20180626  ED2K912204/ED2K912369
         zterm TYPE dzterm,          " Terms of Payment Key
         zlsch TYPE schzw_bseg,      " Payment Method
         land1 TYPE land1,           " Country Key
         bukrs TYPE bukrs,           " Company Code
         netwr TYPE netwr,           " Net Value in Document Currency
         mwsbk TYPE mwsbp,           " Tax amount in document currency  " (++) NPALLA: 14-May-2018: RITM0081486 : ED1K908963
         erdat TYPE erdat,           " Date on Which Record Was Created  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         kunrg TYPE kunrg,           " Payer
         kunag TYPE kunag,           " Sold-to party
         zuonr TYPE ordnr_v,         " Assignment number
         rplnr TYPE rplnr,           " Number of payment card plan type
* Begin by AMOHAMMED on 10/15/2020 ERPM- 20007
         sfakn TYPE	sfakn,           " Cancelled billing document number
* End by AMOHAMMED on 10/15/2020 ERPM- 20007
       END OF ty_vbrk,
       tt_vbrk TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0,

       BEGIN OF ty_vbap,
         vbeln       TYPE vbeln,     " Sales and Distribution Document Number
         posnr       TYPE posnr,     " Item number of the SD document
         pstyv       TYPE pstyv,     " Sales document item category "ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         cluster_typ TYPE matnr_ku,  " Material Number Used by Customer
         vgbel       TYPE vgbel,     " Document number of the reference document
         vgpos       TYPE vgpos,     " Item number of the reference item
         zzdealtyp   TYPE zzdealtyp, " PQ Deal type
         zzsubtyp    TYPE zsubtyp,   " PQ Deal type
*        Begin of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
         matnr       TYPE matnr,     " Material Number
* Begin of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         zzconstart  TYPE zconstart, " Content Start Date Override
         zzconend    TYPE zconend,   " Content End Date Override
* End of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         zzlicstart	 TYPE zlicstart, " License Start Date Override
         zzlicend	   TYPE zlicend,   " License End Date Override
*        End   of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
       END OF ty_vbap,
       tt_vbap TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,

***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
       BEGIN OF ty_stxl,
         tdname TYPE tdobname, "Name
       END OF ty_stxl,
       tt_std_text TYPE STANDARD TABLE OF ty_stxl INITIAL SIZE 0,
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
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

* Begin of: CR#6802 KKR20180620  ED2K912204/ED2K912369
*      Type declaration for Sales Organization
       BEGIN OF ty_sorg,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE vkorg,      " Sales Org. Low
         high TYPE vkorg,      " Sales Org. High
       END OF ty_sorg,
       tt_sorg TYPE STANDARD TABLE OF ty_sorg INITIAL SIZE 0,
       BEGIN OF ty_sales_office,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE vkbur,      " Sales Office. Low
         high TYPE vkbur,      " Sales Office. High
       END OF ty_sales_office,
       tt_sales_office TYPE STANDARD TABLE OF ty_sales_office INITIAL SIZE 0,
       BEGIN OF ty_po_type,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE bsark,      " PO Type. Low
         high TYPE bsark,      " PO Type. High
       END OF ty_po_type,
       tt_po_type TYPE STANDARD TABLE OF ty_po_type INITIAL SIZE 0,
       BEGIN OF ty_vbap_pinv,
         vbeln TYPE	vbeln_va,  " Sales Document
         posnr TYPE	posnr_va,  " Sales Document Item
         matnr TYPE	matnr,     " Material Number
         netwr TYPE netwr_ap,  " Net value of the order item in document currency
         kzwi1 TYPE	kzwi1,     " Subtotal 1 from pricing procedure for condition
         kzwi2 TYPE	kzwi2,     " Subtotal 2 from pricing procedure for condition
         kzwi5 TYPE	kzwi5,     " Subtotal 5 from pricing procedure for condition
         kzwi6 TYPE	kzwi6,     " Subtotal 6 from pricing procedure for condition
         cmpre TYPE cmpre,     " Item credit price
       END OF ty_vbap_pinv,
       tt_vbap_pinv TYPE STANDARD TABLE OF ty_vbap_pinv INITIAL SIZE 0,
* End of: CR#6802 KKR20180620  ED2K912204/ED2K912369
* Begin of: CR#6842 KKR20180731  ED2K912846
       BEGIN OF ty_kna1_zmbr,
         kunnr TYPE kunnr,    " Customer Number
         name1 TYPE name1_gp, " Name 1
         name2 TYPE name2_gp, " Name 2
         ort01 TYPE ort01_gp, " City
         pstlz TYPE pstlz,    " Postal Code
         stras TYPE stras_gp, " House number and street
       END OF ty_kna1_zmbr,
       tt_kna1_zmbr TYPE STANDARD TABLE OF ty_kna1_zmbr INITIAL SIZE 0,
       BEGIN OF ty_vbap_zmbr,
         kunnr      TYPE kunnr,    " Customer Number "ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         prod_group TYPE zprod_group,      " Product Group "ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         vbeln      TYPE  vbeln_va, " Sales Document
         posnr      TYPE  posnr_va, " Sales Document Item
         auart      TYPE auart,    " Sales Document Type
         matnr      TYPE  matnr,    " Material Number
         arktx      TYPE arktx,    " Short text for sales order item
         pstyv      TYPE pstyv,    " Sales document item category
         parvw      TYPE parvw,    " Partner Function
*         kunnr TYPE kunnr,    " Customer Number "ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
         uepos      TYPE uepos,    " Higher-level item in bill of material structures
         netwr      TYPE netwr_ap, " Net value of the order item in document currency
         kzwi1      TYPE  kzwi1,    " Subtotal 1 from pricing procedure for condition
         kzwi2      TYPE  kzwi2,    " Subtotal 2 from pricing procedure for condition
         kzwi3      TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
         kzwi5      TYPE  kzwi5,    " Subtotal 5 from pricing procedure for condition
         kzwi6      TYPE  kzwi6,    " Subtotal 6 from pricing procedure for condition
         cmpre      TYPE cmpre,    " Item credit price
       END OF ty_vbap_zmbr,
       tt_vbap_zmbr TYPE STANDARD TABLE OF ty_vbap_zmbr INITIAL SIZE 0,
       BEGIN OF ty_vbap_zmbr_f,
         prod_group   TYPE zprod_group,      " Product Group
         matnr        TYPE matnr,    " Material Number
         kunnr        TYPE kunnr,     " Customer Number
         vbeln        TYPE vbeln_va, " Sales Document
         posnr        TYPE posnr_va, " Sales Document Item
         auart        TYPE auart,     " Sales Document Type
         prod_group_d TYPE desc40,
         ismpubltype  TYPE ismpubltype,
         ismmediatype TYPE ismmediatype,
         arktx        TYPE arktx,    " Short text for sales order item
         pstyv        TYPE pstyv,    " Sales document item category
         parvw        TYPE parvw,    " Partner Function
         uepos        TYPE uepos,    " Higher-level item in bill of material structures
         netwr        TYPE netwr_ap, " Net value of the order item in document currency
         kzwi1        TYPE  kzwi1,    " Subtotal 1 from pricing procedure for condition
         kzwi2        TYPE  kzwi2,    " Subtotal 2 from pricing procedure for condition
         kzwi3        TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
         kzwi5        TYPE  kzwi5,    " Subtotal 5 from pricing procedure for condition
         kzwi6        TYPE  kzwi6,    " Subtotal 6 from pricing procedure for condition
         cmpre        TYPE cmpre,    " Item credit price
       END OF ty_vbap_zmbr_f,
       tt_vbap_zmbr_f TYPE STANDARD TABLE OF ty_vbap_zmbr_f INITIAL SIZE 0,
* End of: CR#6842 KKR20180731  ED2K912846
*      VBRP Structure
       BEGIN OF ty_vbrp,
         vbeln      TYPE vbeln_vf, " Billing Document
         posnr      TYPE posnr_vf, " Billing item
*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR:  ED2K907362
         uepos      TYPE uepos, " Higher-level item in bill of material structures
*End of change by SRBOSE on 07-Aug-2017 CR_463 #TR:  ED2K907362
         fkimg      TYPE fkimg,      " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
         vrkme      TYPE vrkme,      " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
         vbelv      TYPE vbelv,      " Originating document
         posnv      TYPE posnv,      " Originating item
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
         kzwi5      TYPE kzwi5,      " Subtotal 5 from pricing procedure for condition
         kzwi6      TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
         aland      TYPE aland,      " Departure country (country from which the goods are sent)
         lland      TYPE lland_auft, " Country of destination of sales order
*        Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
         kowrr      TYPE kowrr,    " Statistical values
         fareg      TYPE fareg,    " Rule in billing plan/invoice plan
         netwr      TYPE netwr_fp, " Net value of the billing item in document currency
*        End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
         vkorg_auft TYPE vkorg_auft, " Sales Org "ERP-7462:SGUDA:14-SEP-2018:ED2K913350
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
         ismpubltype  TYPE ismpubltype, "Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
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
*        Begin of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
         kdkg5 TYPE kdkg5,     " Customer condition group 5
*        End   of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
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
         venddat TYPE vndat_veda,                      " Contract end date
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

*       BOC by MODUTTA on 22/01/2018 for CR#TBD
       BEGIN OF ty_tax_item,
         subs_type      TYPE ismmediatype,
         media_type     TYPE char255,
         tax_percentage TYPE char16, " Percentage of type CHAR16
         tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
         taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
       END OF ty_tax_item,
       tt_tax_item TYPE STANDARD TABLE OF ty_tax_item,
*       EOC by MODUTTA on 22/01/2018 for CR#TBD
       tt_fpltc    TYPE STANDARD TABLE OF ty_fpltc,
       tt_tax_data TYPE STANDARD TABLE OF ty_tax_data,

       BEGIN OF ty_email_id,
         sign   TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         option TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE ad_smtpadr, " SD document category
         high   TYPE ad_smtpadr, " SD document category
       END OF ty_email_id,
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591

*     BOC by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
       BEGIN OF ty_pub_typ,
         publication_type TYPE ismpubltype,
         prod_group       TYPE zprod_group, " Product Group
         prod_group_d     TYPE desc40,      " Description
       END OF ty_pub_typ,
       tt_pub_typ TYPE STANDARD TABLE OF ty_pub_typ INITIAL SIZE 0,

       BEGIN OF ty_vbrp_final,
         prod_group  TYPE zprod_group,      " Product Group
         cluster_typ TYPE matnr_ku,         " Material Number Used by Customer
         ismpubltype TYPE ismpubltype,      " Publication Type
         vbeln       TYPE vbeln_vf,         " Billing Document
         posnr       TYPE posnr_vf,         " Billing item
         uepos       TYPE uepos,            " Higher-level item in bill of material structures
         fkimg       TYPE fkimg,            " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
         vrkme       TYPE vrkme,            " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
         vbelv       TYPE vbelv,            " Originating document
         posnv       TYPE posnv,            " Originating item
         aubel       TYPE vbeln_va,         " Sales Document
         aupos       TYPE posnr_va,         " Sales Document Item
         matnr       TYPE matnr,            " Material Number
         arktx       TYPE arktx,            " Short text for sales order item
         pstyv       TYPE pstyv,            " Sales document item category
         vkbur       TYPE vkbur,            " Sales Office
         kzwi1       TYPE kzwi1,            " Subtotal 1 from pricing procedure for condition
         kzwi2       TYPE kzwi2,            " Subtotal 2 from pricing procedure for condition
         kzwi3       TYPE kzwi3,            " Subtotal 3 from pricing procedure for condition
         kzwi5       TYPE kzwi5,            " Subtotal 5 from pricing procedure for condition
         kzwi6       TYPE kzwi6,            " Subtotal 6 from pricing procedure for condition
         aland       TYPE aland,            " Departure country (country from which the goods are sent)
         lland       TYPE lland_auft,       " Country of destination of sales order
         kowrr       TYPE kowrr,            " Statistical values
         fareg       TYPE fareg,            " Rule in billing plan/invoice plan
         netwr       TYPE netwr_fp,         " Net value of the billing item in document currency
       END OF ty_vbrp_final,
       tt_vbrp_final TYPE STANDARD TABLE OF ty_vbrp_final INITIAL SIZE 0,
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
       BEGIN OF ty_prod_categ,
         sign   TYPE ddsign,                " Type of SIGN component in row type of a Ranges type
         option TYPE ddoption,              " Type of OPTION component in row type of a Ranges type
         low    TYPE zprod_group,           " Product Group
         high   TYPE zprod_group,           " Product Group
       END OF ty_prod_categ,
       tt_prod_categ TYPE STANDARD TABLE OF ty_prod_categ INITIAL SIZE 0,
*     EOC by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187

* SOC by NPOLINA ERP7771 ED2K913544 ED2K914014
       BEGIN OF ty_op_type,
         sign   TYPE ddsign,                " Type of SIGN component in row type of a Ranges type
         option TYPE ddoption,              " Type of OPTION component in row type of a Ranges type
         low    TYPE sna_kschl,             " Output type
         high   TYPE sna_kschl,             " Output type
       END OF ty_op_type,
       tt_op_type TYPE STANDARD TABLE OF ty_op_type INITIAL SIZE 0,

       BEGIN OF ty_bill_type,
         sign   TYPE ddsign,                " Type of SIGN component in row type of a Ranges type
         option TYPE ddoption,              " Type of OPTION component in row type of a Ranges type
         low    TYPE fkart,                 " Output type
         high   TYPE fkart,                 " Output type
       END OF ty_bill_type,
       tt_bill_type TYPE STANDARD TABLE OF ty_bill_type INITIAL SIZE 0.

* EOC by NPOLINA ERP7771 ED2K913544 ED2K914014
**********************************************************************
*                        DATA DECLARATION                            *
**********************************************************************
* Data declaration
DATA :
  i_vbrp                  TYPE tt_vbrp,       " IT for VBRP
  i_vbap                  TYPE tt_vbap,
  i_vbrp_final            TYPE tt_vbrp_final, " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
  i_vbpa                  TYPE tt_vbpa,       " IT for VBPA
  i_vbpa_con              TYPE tt_vbpa,       " IT for VBPA
  i_vbfa                  TYPE tt_vbfa,       " IT for VBFA
  i_pub_typ               TYPE tt_pub_typ,    " Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
  i_tax_id                TYPE tt_tax_id, " TAX IDs
  i_makt                  TYPE tt_makt,   " Material Descriptions
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  i_std_text              TYPE tt_std_text,
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  i_konv                  TYPE tt_konv,          " IT for condition table
  i_txtmodule             TYPE tsftext,          " IT for text module
  i_adrc                  TYPE tt_adrc,          " IT for ADRC
  i_jptidcdassign         TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
  i_mara                  TYPE tt_mara,          " IT for MARA
  i_vbkd                  TYPE tt_vbkd,          " IT for VBKD
  r_country               TYPE tt_country,       " Country key
  r_inv                   TYPE tt_billtype,      " Billing type range table for invoice
  r_crd                   TYPE tt_billtype,      " Billing type range table for Credit Memo
  r_dbt                   TYPE tt_billtype,      " Billing type range table for Debit Memo
  r_pub_typ               TYPE tt_prod_categ,    "Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
  r_prod_categ            TYPE tt_prod_categ,    "Added by MODUTTA on 06-Jun-18 for CR# 6145 TR#: ED2K912187
* Begin of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
  r_pub_typ_ubcm          TYPE rjksd_publtype_range_tab,
  r_sub_typ_roll          TYPE RANGE OF kdkg5 INITIAL SIZE 0, " Customer condition group 5
* End   of ADD:ERP-6145:WROY:08-AUG-2018:ED2K912958
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
  r_mtart_med_issue       TYPE fip_t_mtart_range, " Material Types: Media Issues
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
  r_idcodetype            TYPE rjksd_idcodetype_range_tab, "material Identification Code
  i_content_hex           TYPE solix_tab,                  " Content table
  i_emailid               TYPE tt_emailid,                 " IT for email ID
  i_final                 TYPE ztqtc_item_detail_f024,     " IT for final table
  i_tax_item              TYPE zttqtc_tax_item_f024,
  i_text_item             TYPE zttqtc_tax_item_f024,
  i_exc_tab               TYPE zttqtc_exchange_tab_invoice,
  st_header_text          TYPE ty_header_text,             " Text structure
  st_kna1                 TYPE ty_kna1,                    " IT for KNA1
  st_header               TYPE zstqtc_header_detail_f024_as,  " Header structure
*      Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
  st_but000               TYPE ty_but000, " WA for BUT000
  st_but020               TYPE ty_but020, " WA for BUT020
*      End of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  v_langu                 TYPE syst_langu, " ABAP System Field: Language Key of Text Environment
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  st_item                 TYPE zstqtc_item_detail_f024, " Item Structure
  st_formoutput           TYPE fpformoutput,            " Form Output (PDF, PDL)
  st_vbrk                 TYPE ty_vbrk,                 " IT for VBRK
  st_vbco3                TYPE vbco3,                   " Sales Doc.Access Methods: Key Fields: Document Printing
  v_xstring               TYPE xstring,                 " Logo Variable
  v_accmngd_title         TYPE char255,                 " Accmngd_title of type CHAR255
  v_reprint               TYPE char255,                 " Reprint    " " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
  v_trig_attr             TYPE katr6,                   " Attribute 6
  v_sales_ofc             TYPE vkbur,                   " Sales Office
  v_country_key           TYPE land1,                   " Country code
  v_remit_to              TYPE thead-tdname,            " Name
  v_footer                TYPE thead-tdname,            " Name
  v_tax                   TYPE thead-tdname,            " Name
  v_bank_detail           TYPE thead-tdname,            " Name
  v_output_typ            TYPE sna_kschl,               " Message type
  v_outputyp_summary      TYPE sna_kschl,               " Message type
  v_outputyp_consor       TYPE sna_kschl,               " Message type
  v_outputyp_detail       TYPE sna_kschl,               " Message type
  v_outputyp_core_summ    TYPE sna_kschl,               " Message type
  v_outputyp_core_det     TYPE sna_kschl,               " Message type
  v_totaldue              TYPE char140,                 " Totaldue of type CHAR140
  v_subtotal              TYPE char140,                 " Subtotal of type CHAR140
  v_prepaidamt            TYPE char140,                 " Subtotal of type CHAR140
  v_vat                   TYPE char140,                 " Vat of type CHAR140
  v_proc_status           TYPE na_vstat,                " Processing status of message
*       v_country_key      TYPE landx,                     " Country Name
  v_crdt_card_det         TYPE thead-tdname, " Name
  v_payment_detail        TYPE thead-tdname, " Name
  v_cust_service_det      TYPE thead-tdname, " Name
  v_subtotal_val          TYPE netwr,        " Net Value in Document Currency
  v_sales_tax             TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
  v_totaldue_val          TYPE autwr,        " Total due amount
  v_prepaid_amount        TYPE char20,       " Prepaid amount
  v_paid_amt              TYPE autwr,        " Var to store prepaid amount
  v_ent_retco             LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
  v_ent_screen            TYPE c,            " Screen of type Character
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
  v_faz                   TYPE fkart,   " Billing Type
  v_vkorg                 TYPE vkorg,   " Sales Organization
  v_country_uk            TYPE land1,   " Country Key
  v_title                 TYPE char255, " Title of type CHAR255
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
  i_veda                  TYPE tt_veda,
  i_tax_data              TYPE tt_tax_data,
  i_terms_text            TYPE tttext,
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
*Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
  v_txt_name              TYPE tdobname, " Name
  v_text_line             TYPE char255,  " Text_line of type CHAR100
  v_subs_type             TYPE char255,
  v_ind                   TYPE xegld,    " Text_line of type CHAR100
  v_year                  TYPE char10,   " Year of type CHAR10
  i_subtotal              TYPE ztqtc_subtotal_f024,
  v_ccnum                 TYPE char9,    "++SRBOSE CR_558 TR# ED2K908298
  v_credit_text           TYPE tdline,   " Text Line
  i_fpltc                 TYPE tt_fpltc,
  v_seller_reg            TYPE tdline,   " Seller VAT Registration Number (++)MODUTTA on 08/08/2017 for CR#408
*End of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
  v_inv_desc              TYPE rvari_vnam,        " ABAP: Name of Variant Variable
  v_invoice_desc          TYPE /idt/invoice_desc, " Invoice Description
  v_payment_detail_inv    TYPE thead-tdname,      " Name
  v_sub_type_di           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
  v_sub_type_ph           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
  v_sub_type_mm           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
  v_sub_type_se           TYPE rvari_vnam,        " ABAP: Name of Variant Variable
  v_terms_cond            TYPE string,
***     BOC by MODUTTA on 14/01/2018 for CR# TBD
  v_cond_type             TYPE kschl,
  v_kwert                 TYPE char100,      " Condition value
  v_actv_flag_f024        TYPE zactive_flag, " Active / Inactive Flag
  r_email                 TYPE STANDARD TABLE OF ty_email_id,
*      Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
  r_sanc_countries        TYPE temr_country,
*      End   of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
***     EOC by MODUTTA on 14/01/2018 for CR# TBD
*      Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
  v_local_curr            TYPE hwaer, " Local Currency
*      End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
***BOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137
  v_waers                 TYPE waers_005, " Country currency
***EOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137
  v_ref_curr              TYPE bwaer_curv,                  " Reference currency for currency translation "ADD:ERPM-15473:SGUDA:13-APR-2020:ED2K917966
* Begin of: CR#6802 KKR20180620  ED2K912204/ED2K912369
  r_sorg                  TYPE tt_sorg,         " Sales Org.
  r_sales_office          TYPE tt_sales_office, " Sales Org.
  r_po_type               TYPE tt_po_type,      " Sales Org.
  v_pinv                  TYPE fkart,           " Billing Type (ZF5)
  v_pinv_num              TYPE vbeln_vf,        " Proforma Invoice Number
  i_vbap_pinv             TYPE tt_vbap_pinv,    " Sales Doc. Item Details
* End of: CR#6802 KKR20180620  ED2K912204/ED2K912369
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
  r_aust_text             TYPE tt_aust_text,    " Plant
  r_sales_org_text        TYPE tt_sales_org_text,    " Sales Org
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of: CR#6842 KKR20180730  ED2K912846
  v_zmbr_trig_attr        TYPE katr6,        " Attribute 6 (ED2K912792)
  v_trigger_zmbr          TYPE char1 VALUE abap_true,  " Control Flag for ZMBR Changes
  i_kna1_zmbr             TYPE tt_kna1_zmbr, " IT for KNA1
  i_vbap_zmbr             TYPE tt_vbap_zmbr, " IT for VBAP
* End of: CR#6842 KKR20180730  ED2K912846
* Begin of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
  v_aust_text             TYPE string,      " Australin text
* End of ADD:ERP-7462:SGUDA:14-SEP-2018:ED2K913350
* Begin of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
  v_ind_text              TYPE string,      " Indain Tax text
  v_tax_expt              TYPE string,      " Tax Expt
  v_gst_no                TYPE bptaxnum,    " GST No
* End of ADD:ERP-7543 & 7459:SGUDA:18-SEP-2018:ED2K913375
** SOC by NPOLINA ERP7771 ED2K913544 ED2K914014
*  r_billtype           TYPE tt_bill_type,  " Billing type
*  r_optype             TYPE tt_op_type,    " Output type
** EOC by NPOLINA ERP7771 ED2K913544 ED2K914014
* BOC by NPALLA:RITM0081486:ED1K908963 ED2K914014
  r_optype_tax            TYPE tt_op_type,    " Output type for Tax
* EOC by NPALLA:RITM0081486:ED1K908963 ED2K914014
* BOC: KKRAVURI CR#7431&7189 ED2K913769
  v_receipt_flag          TYPE abap_bool,
  v_barcode               TYPE char100,
  r_bill_doc_type         TYPE RANGE OF salv_de_selopt_low,
* EOC: KKRAVURI CR#7431&7189 ED2K913769
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*  r_billing_type_zf2   TYPE RANGE OF salv_de_selopt_low,
*  r_billing_type_zcr   TYPE RANGE OF salv_de_selopt_low,
*  r_ship_to_country    TYPE RANGE OF salv_de_selopt_low.
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
  v_credit_memo(1)        TYPE c,  "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916705
*- Begin of ADD:ERPM-1380:SGUDA:13-APR-2020:ED2K917966
  r_currency_country      TYPE RANGE OF salv_de_selopt_low,
  r_bill_doc_type_curr    TYPE RANGE OF salv_de_selopt_low,
*- End of ADD:ERPM-1380:SGUDA:13-APR-2020:ED2K917966
*- Begin of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
  r_cust_cond_grp         TYPE RANGE OF salv_de_selopt_low,
  r_item_catg             TYPE RANGE OF salv_de_selopt_low,
  r_doc_itm_cust_cond_grp TYPE RANGE OF salv_de_selopt_low,
  r_gst_no                TYPE RANGE OF  salv_de_selopt_low, "ADD:ERPM-10760:SGUDA:05-MAR-2020:ED2K917764
  v_day(2)                TYPE c,                           " Year_2 of type CHAR30
  v_month(2)              TYPE c,                           " Year_2 of type CHAR30
  v_year2(4)              TYPE c,
  v_stext                 TYPE t247-ktx,                    " Year_2 of type CHAR30
  v_ltext                 TYPE t247-ltx,                    " Year_2 of type CHAR30
  v_cntr                  TYPE char30.                      " Year_2 of type CHAR30
*- End of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
**********************************************************************
*                    CONSTANT DECLARATION                            *
**********************************************************************
CONSTANTS : c_we                 TYPE parvw            VALUE 'WE',   " Partner Function
            c_st                 TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
            c_id_cluster         TYPE thead-tdid       VALUE '0043', " Text ID of text to be read
            c_object             TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
            c_object_vbbp        TYPE thead-tdobject   VALUE 'VBBP', " Object of text to be read
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
            c_id_grun            TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
            c_obj_mat            TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
            c_deflt_langu        TYPE sylangu          VALUE 'E',        " Default Language: English
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
            c_subtotal           TYPE tdsfname         VALUE 'ZQTC_SUBTOTAL_F024',           " Subtotal text
            c_prepaidamt         TYPE tdsfname         VALUE 'ZQTC_PREPAID_AMOUNT_F024',     " Prepaid Amount text
            c_totaldue           TYPE tdsfname         VALUE 'ZQTC_TOTAL_DUE_F024',          " Total due Text
            c_name_inv           TYPE thead-tdname     VALUE 'ZQTC_INVOICE_NUMBER_F024',     " Name of text to be read
            c_name_dbt           TYPE thead-tdname     VALUE 'ZQTC_DEBIT_MEMO_NUMBER_F024',  " Name of text to be read
            c_journal            TYPE thead-tdname     VALUE 'ZQTC_JOURNAL_F024',            " Name of text to be read
            c_name_reprnt        TYPE thead-tdname     VALUE 'ZQTC_REPRINT_F024',            " Name of text to be read
            c_name_receipt       TYPE thead-tdname     VALUE 'ZQTC_RECEIPT_F024',            " Name
            c_name_crd           TYPE thead-tdname     VALUE 'ZQTC_CREDIT_MEMO_NUMBER_F024', " Name of text to be read
            c_name_tax_inv       TYPE thead-tdname     VALUE 'ZQTC_TAX_INVOICE_F024',        " Name of text to be read
            c_name_tax_crd       TYPE thead-tdname     VALUE 'ZQTC_TAX_CREDIT_F024',         " Name of text to be read
            c_name_tax_dbt       TYPE thead-tdname     VALUE 'ZQTC_TAX_DEBIT_F024',          " Name of text to be read

*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
            c_name_faz           TYPE thead-tdname VALUE 'ZQTC_F024_PROFORMA', " Name
            c_name_vkorg         TYPE thead-tdname VALUE 'ZQTC_F024_NOT_VAT',  " Name
            c_posnr_hdr          TYPE posnr        VALUE '000000',             " Item number of the SD document (Header)
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
            c_tax_invoice        TYPE thead-tdname VALUE 'ZQTC_F024_TAX_INVOICE_TEXT', "ADD:ERP-7462:SGUDA:17-SEP-2018:ED2K913365
*            c_tax_credit        TYPE thead-tdname VALUE 'ZQTC_F042_TAX_CREDIT_TEXT',  "ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*           Begin of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
            c_wiley_inv          TYPE thead-tdname     VALUE 'ZQTC_WILEY_INVOICE_F024', " Name
            c_wiley_crd          TYPE thead-tdname     VALUE 'ZQTC_WILEY_CREDIT_F024',  " Name
            c_wiley_dbt          TYPE thead-tdname     VALUE 'ZQTC_WILEY_DEBIT_F024',   " Name
            c_wiley_rec          TYPE thead-tdname     VALUE 'ZQTC_WILEY_RECEIPT_F024', " Name
*           End of change: PBOSE: 02-June-2017: DEFECT 2477: ED2K906208
*Begin of change by SRBOSE on 02-Aug-2017 CR_463 #TR:  ED2K907362
            c_wiley_pro          TYPE thead-tdname     VALUE 'ZQTC_WILEY_PROFORMA_F024', " Name
*End of change by SRBOSE on 02-Aug-2017 CR_463 #TR:  ED2K907362
*Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR:  ED2K907362
            c_obj_vbbp           TYPE tdobject         VALUE 'VBBP', " Texts: Application Object
***           BOC by MODUTTA for CR# TBD on 11/01/2018
            c_digital            TYPE tdobname VALUE 'DI', " Name
            c_print              TYPE tdobname VALUE 'PH', " Name
            c_mixed              TYPE tdobname VALUE 'MM', " Name
***           EOC by MODUTTA for CR# TBD on 11/01/2018
            c_zmbr               TYPE auart VALUE 'ZMBR', " CR#6842 KKR20180801  ED2K912846
            c_comma              TYPE char1 VALUE ',',    " CR#7431&7189 KKRAVURI20181105  ED2K913769
            c_o                  TYPE vbrk-vbtyp VALUE 'O', "ADD:ERPM-1459:SGUDA:01-Nov-2019:ED2K916705
*- Begin of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
            c_content_start_date TYPE thead-tdname VALUE 'ZQTC_F024_CONTENT_START_DATE',
            c_content_end_date   TYPE thead-tdname VALUE 'ZQTC_F024_CONTENT_END_DATE'.
*- End of ADD:ERPM-1362:SGUDA:02-Dec-2019:ED2K917059
*- Begin of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669
*            lc_billing_type_zf2 TYPE rvari_vnam VALUE 'BILLING_TYPE_ZF2',
*            lc_billing_type_zcr TYPE rvari_vnam VALUE 'BILLING_TYPE_ZCR',
*            lc_shipping_country TYPE rvari_vnam VALUE 'SHIP_CUST_LAND1'.
*- End of ADD:DM-1886:SGUDA:10-JULY-2018:ED2K915669

* SOC by NPOLINA 05-Aug-2019 DM1897 ED2K915832
DATA : i_consts  TYPE TABLE OF zcaconstant.

CONSTANTS:
  c_fkart         TYPE rvari_vnam VALUE 'FKART',    " Invoice type i.e ZF2
  c_bpid          TYPE rvari_vnam VALUE 'BPID',    " Change Email Address to BP
  c_emailid       TYPE rvari_vnam VALUE 'EMAILID',    " Change to Specific Email Address
  c_output        TYPE rvari_vnam VALUE 'OUTPUT',    " Change Email Address to BP
  c_auart         TYPE rvari_vnam VALUE 'AUART',
  c_int           TYPE ad_comm    VALUE 'INT',       " Communication Method
  c_bp            TYPE parvw      VALUE 'RE',       " Communication Method
  c_bsark         TYPE rvari_vnam VALUE 'BSARK',    " Customer purchase order type
  c_specific      TYPE rvari_vnam VALUE 'SPECIFIC',    " Specific Email Address
* EOC by NPOLINA 05-Aug-2019 DM1897 ED2K915832
  c_excrate_typ_m TYPE kurst_curr VALUE 'M'.        "ADD:ERPM-15473:SGUDA:13-APR-2020:ED2K917966    Exchange Rate Type

* Begin by AMOHAMMED on 10/15/2020 ERPM- 20007
* Constants declarations
CONSTANTS : c_org_doc TYPE thead-tdname VALUE  'ZQTC_ORG_DOC_F024'.
* Data declaration
DATA : r_can_inv TYPE tt_billtype,  " Cancelled Invoice 'N'
       r_can_crd TYPE tt_billtype,  " Cancelled Credit Memo 'S'
       v_org_doc TYPE char255.      " Original document of type CHAR255
* End by AMOHAMMED on 10/15/2020 ERPM- 20007
