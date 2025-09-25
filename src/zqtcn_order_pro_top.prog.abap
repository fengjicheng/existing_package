*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_PRO_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_ORDER_PROFORMA_F501
* REPORT DESCRIPTION:    Driver Program for order proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Jagadeeswara Rao M (JMADAKA)
* CREATION DATE:         02-May-2022
* OBJECT ID:             F501
* TRANSPORT NUMBER(S):   ED2K927138
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*


TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        vbap,     " Sales Document: Item Data
        toa_dara.

********Global Structure Declaration for vbap and vbak
TYPES: BEGIN OF ty_vbap,
         vbeln    TYPE  vbeln,  " Sales and Distribution Document Number
         posnr    TYPE  posnr,  " Item number of the SD document
         matnr    TYPE  matnr,  " Material Number
         arktx    TYPE  arktx,  " Short text for sales order item
         uepos    TYPE uepos,   " Higher-level item in bill of material structures                                                                                      meins  "
         meins    TYPE  meins,  " Base Unit of Measure
         kwmeng   TYPE  kwmeng, " Cumulative Order Quantity in Sales Units
         kzwi1    TYPE  kzwi1,  " Unit Price
         kzwi2    TYPE  kzwi2,  " Amount
         kzwi3    TYPE  kzwi3,    "Subtotal 3 from pricing procedure for condition
         netwr    TYPE  netwr_ak, " Net Value of the Sales Order in Document Currency
         zmeng    TYPE  dzmeng,   " Target quantity in sales units
         kzwi5    TYPE  kzwi5, "Discount
         kzwi6    TYPE  kzwi6, "Tax
         mvgr4    TYPE mvgr4,    " Material Group 5
         mvgr5    TYPE  mvgr5, " Material group 5
         mwsbp    TYPE  mwsbp,   "Tax
         angdt    TYPE  angdt_v, " Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,   " SD document category
         waerk    TYPE  waerk,   " SD Document Currency
         vkbur    TYPE vkbur, " Sales Office
         knumv    TYPE  knumv, " Number of the document condition
         kvgr1    TYPE kvgr1, " Customer group 1
         bukrs_vf TYPE  bukrs_vf, " Company code to be billed
         auart    TYPE  auart,    "Sales Document Type
       END OF ty_vbap,

       BEGIN OF ty_vbpa,
         vbeln    TYPE vbeln,      " Sales and Distribution Document Number
         posnr    TYPE posnr,      "Item number of the SD document
         parvw    TYPE parvw,      "Partner Function
         kunnr    TYPE kunnr,      "Customer Number
         adrnr    TYPE adrnr,      "Address
         land1    TYPE land1,      "Country Key
         vbelv    TYPE vbeln_von,  "Preceding sales and distribution document
         posnv    TYPE posnr_von,  "Preceding item of an SD document
         posnn    TYPE posnr_nach, "Subsequent item of an SD document
         vbtyp_n  TYPE vbtyp_n,    "Document category of subsequent document
         vbtyp_v  TYPE vbtyp_v,    "Document category of preceding SD document
         line_num TYPE posnr,      " Item number of the SD document
         zterm    TYPE dzterm, " Terms of Payment Key
         zlsch    TYPE schzw_bseg, " Payment Method
         bstkd    TYPE bstkd,       " Customer purchase order number
         bsark    TYPE bsark,       "Customer purchase order type
         ihrez    TYPE ihrez,       " Your Reference
       END OF ty_vbpa,              "Customer purchase order number

       BEGIN OF ty_vbak,
         vbeln    TYPE  vbeln,      "sales AND distribution document NUMBER
         angdt    TYPE  angdt_v,    "Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,      "SD document category
         waerk    TYPE  waerk,      "SD Document Currency
         knumv    TYPE  knumv,      "Number of the document condition
         bukrs_vf TYPE  bukrs_vf,   "Company code to be billed
         netwr    TYPE  vbak-netwr, " Net Value of the Sales Order in Document Currency
       END OF ty_vbak,

       BEGIN OF ty_constant,
         devid  TYPE zdevid,                           "Development ID
         param1 TYPE  rvari_vnam,                      "ABAP: Name of Variant Variable
         param2 TYPE  rvari_vnam,                      "ABAP: Name of Variant Variable
         srno   TYPE  tvarv_numb,                      "ABAP: Current selection number
         sign   TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
         opti   TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
       END OF ty_constant,

       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
       END OF ty_tax_data,

       BEGIN OF ty_stxl,
         tdname TYPE tdobname, "Name
       END OF ty_stxl,

       BEGIN OF ty_mara,
         matnr           TYPE matnr, " Material Number
         mtart           TYPE mtart, " Material Type
         volum           TYPE volum, " Volume
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
         ismsubtitle1    TYPE  ismsubtitle1, " Subtitle 1
         ismsubtitle2    TYPE  ismsubtitle2, " Subtitle 2
         ismsubtitle3    TYPE ismsubtitle3,  " Subtitle 3
         ismmediatype    TYPE ismmediatype,  " Media Type
         ismnrinyear     TYPE ismnrimjahr,   " Issue Number (in Year Number)
         ismyearnr       TYPE ismjahrgang,   " Media issue year number
         ismcopynr       TYPE ismheftnummer, " Copy Number of Media Issue
       END OF ty_mara,

       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,              " Material Number
         idcodetype TYPE ismidcodetype,      " Type of Identification Code
         identcode  TYPE ismidentcode,       " Identification Code
       END OF ty_jptidcdassign,
       BEGIN OF ty_makt,
         matnr TYPE matnr,                   " Material Number
         spras TYPE spras,                   " Language Key
         maktx TYPE maktx,                   " Material Description (Short Text)
       END OF ty_makt,

       BEGIN OF ty_tax_item,
         subs_type      TYPE ismmediatype,
         media_type     TYPE char255,
         tax_percentage TYPE char16, " Percentage of type CHAR16
         tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
         taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
       END OF ty_tax_item,

       tt_tax_item TYPE STANDARD TABLE OF ty_tax_item,

       BEGIN OF ty_zlsch_f044,
         sign   TYPE sign,       " Debit/Credit Sign (+/-)
         option TYPE opti,       " Option for ranking structure
         low    TYPE schzw_bseg, " Payment Method
         high   TYPE schzw_bseg, " Payment Method
       END OF ty_zlsch_f044,

       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
       tt_tax_id        TYPE STANDARD TABLE OF ty_tax_id INITIAL SIZE 0,
       tt_makt          TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
       tt_mara          TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
       tt_tax_data      TYPE STANDARD TABLE OF ty_tax_data,
       tt_std_text      TYPE STANDARD TABLE OF ty_stxl INITIAL SIZE 0,
       tt_vbap          TYPE STANDARD TABLE OF  ty_vbap   INITIAL SIZE 0,
       tt_vbpa          TYPE STANDARD TABLE OF  ty_vbpa   INITIAL SIZE 0,
       tt_constant      TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.

*** JMADAKA
* vbrk structure
TYPES: BEGIN OF ty_vbrk,
         vbeln    TYPE vbeln_vf,   " Billing Document
         fkart    TYPE fkart,      " Billing Type
         vbtyp    TYPE vbtyp,      " SD document category   " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
         waerk    TYPE waerk,      " SD Document Currency
         vkorg    TYPE vkorg,      " Sales Organization
         knumv    TYPE knumv,      " Number of the document condition
         fkdat    TYPE fkdat,      " Billing date for billing index and printout
         zterm    TYPE dzterm,     " Terms of Payment Key
         zlsch    TYPE schzw_bseg, " Payment Method
         land1    TYPE land1,      " Country Key
         bukrs    TYPE bukrs,      " Company Code
         netwr    TYPE netwr,      " Net Value in Document Currency
         erdat    TYPE erdat,      " Date on Which Record Was Created
         kunrg    TYPE kunrg,      " Payer
         kunag    TYPE kunag,      " Sold-to party
         zuonr    TYPE ordnr_v,    " Assignment number
         rplnr    TYPE rplnr,      " Number of payment card plan type
         sfakn    TYPE sfakn,      " Original document number
         bstnk_vf TYPE bstkd,
       END OF ty_vbrk,
       tt_vbrk TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0.

*      VBRP Structure
TYPES: BEGIN OF ty_vbrp,
         vbeln      TYPE vbeln_vf, " Billing Document
         posnr      TYPE posnr_vf, " Billing item
         uepos      TYPE uepos, " Higher-level item in bill of material structures
         fkimg      TYPE fkimg, " Actual Invoiced Quantity
         meins      TYPE meins, " Base Unit of Measure
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
         kowrr      TYPE kowrr, " Statistical values
         fareg      TYPE fareg, " Rule in billing plan/invoice plan
         kdkg2      TYPE kdkg2, " Customer condition group 2
         netwr      TYPE netwr_fp,    " Net value of the billing item in document currency
         mvgr4      TYPE mvgr4,
         mvgr5      TYPE mvgr5,
         vkorg_auft TYPE vkorg_auft, " Sales Org
         abrbg      TYPE abrbg, "settlement period
       END OF ty_vbrp,
       tt_vbrp TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0.

*      Condition(KONV) strucure
TYPES: BEGIN OF ty_konv,
         knumv TYPE knumv,  " Number of the document condition
         kposn TYPE kposn,  " Condition item number
         stunr TYPE stunr,  " Step number
         zaehk TYPE dzaehk, " Condition counter
         kschl TYPE kscha,  " Condition type
         kwert TYPE kwert,  " Condition value
       END OF ty_konv,
       tt_konv TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0.




DATA: li_bill_to_address TYPE zttqtc_address_line_f501,
      li_ship_to_address TYPE zttqtc_address_line_f501.

DATA : lst_vbrk TYPE ty_vbrk,
       li_vbrp  TYPE tt_vbrp.      " IT for VBRP

DATA: lv_comp_address TYPE thead-tdname,
      lv_credit_card  TYPE thead-tdname.

*** JMADAKA

CONSTANTS: c_st          TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
           c_object      TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
           c_initial_amt TYPE char4    VALUE '0.00', " Initial_amt of type CHAR4
           c_comm_meth   TYPE ad_comm          VALUE 'LET'. " Communication Method (Key) (Business Address Services)

DATA: v_retcode                LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
      v_ent_screen             TYPE c,            " Screen of type Character
      v_xstring                TYPE xstring,      " Logo Variable
      v_msg_txt                TYPE string,
      v_remit_to_uk            TYPE thead-tdname, " SAPscript: Text Header:Name
      v_remit_to_usa           TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer1                TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer2                TYPE thead-tdname, " SAPscript: Text Header:Name
      st_vbco3                 TYPE vbco3,        " Sales Doc.Access Methods: Key Fields: Document Printing
      v_society_logo           TYPE xstring,      " Logo Variable
      v_society_text           TYPE name1_gp, " Society text
      v_scc                    TYPE xfeld,    " Scc of type CHAR1
      v_scm                    TYPE xfeld,    " Scm of type CHAR1
      v_tbt                    TYPE xfeld,    " Tbt of type CHAR1
      v_detach                 TYPE thead-tdname,       " Name
      v_order                  TYPE thead-tdname,       " Name
      v_credit_crd             TYPE thead-tdname,       " Name
      v_credit_crd_email       TYPE thead-tdname,       " Name
      v_payment                TYPE thead-tdname,       " Name
      v_payment_scc            TYPE thead-tdname,       " Name
      v_payment_scm            TYPE thead-tdname,       " Name
      v_cust                   TYPE thead-tdname,       " Name
      v_com_uk                 TYPE thead-tdname,       " Name
      v_com_usa                TYPE thead-tdname,       " Name
      st_address               TYPE zstqtc_add_f027,    " Global structure for address
      st_header                TYPE zstqtc_header_f501, " Structure for header Data
      i_vbpa                   TYPE STANDARD TABLE OF  ty_vbpa    INITIAL SIZE 0,
      i_vbap                   TYPE STANDARD TABLE OF  ty_vbap    INITIAL SIZE 0,
      i_content_hex            TYPE solix_tab,          "GBT: SOLIX as Table Type
      i_sub_final              TYPE zttqtc_sub_item_f027,
      i_final                  TYPE zttqtc_item_f501,
      i_makt                   TYPE tt_makt,            " Material Descriptions
      i_std_text               TYPE tt_std_text,
*      i_email             TYPE ldps_txt_tab,       " Text Line
      i_credit                 TYPE ldps_txt_tab, " Text Line
      st_formoutput            TYPE fpformoutput, " Form Output (PDF, PDL)
      st_calc                  TYPE zstqtc_calc_f501,  " Structure for Calculation
      st_formoutput_f044       TYPE fpformoutput,                   " Form Output (PDF, PDL)
      i_formoutput             TYPE STANDARD TABLE OF fpformoutput, " Form Output (PDF, PDL)
      v_vkorg_f044             TYPE vkorg,                          " Sales Organization
      v_zlsch_f044             TYPE schzw_bseg,                     " Payment Method
      v_waerk_f044             TYPE waerk,                          " SD Document Currency
      v_ihrez_f044             TYPE ihrez,                          " Your Reference
      v_kvgr1_f044             TYPE kvgr1,                          " Customer Group
      i_constant               TYPE tt_constant,
      v_partner_za             TYPE xfeld,                          " Checkbox
      v_remit_to_tbt_uk        TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_credit_tbt_uk          TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_email_tbt_uk           TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_banking1_tbt_uk        TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_cust_serv_tbt_uk       TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_remit_to_scc           TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_credit_scc             TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_email_scc              TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_banking1_scc           TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_cust_serv_scc          TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_remit_to_scm           TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_credit_scm             TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_email_scm              TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_banking1_scm           TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_cust_serv_scm          TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_footer                 TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_footer_tbt             TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_comp_name              TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_footer_scc             TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_footer_scm             TYPE thead-tdname,                   " Name
      v_remit_to_tbt_usa       TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_credit_tbt_usa         TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_email_tbt_usa          TYPE thead-tdname,                   " SAPscript: Text Header:Name
      v_banking1_tbt_usa       TYPE thead-tdname,                   " SAPscript: Text Header:Name                           " SAPscript: Text Header:Name
      v_cust_serv_tbt_usa      TYPE thead-tdname,                   " SAPscript: Text Header:Name
*      v_barcode           TYPE char30,                         " Barcode of type CHAR30
      v_barcode                TYPE char100,                         " Barcode of type CHAR100
      v_seller_reg             TYPE tdline,                         " Seller VAT Registration Number
      i_tax_data               TYPE tt_tax_data,
      i_mara                   TYPE tt_mara,                        " IT for MARA
      i_jptidcdassign          TYPE tt_jptidcdassign,               " IT for JPTIDCDASSIGN
      v_langu                  TYPE syst_langu,                     " ABAP System Field: Language Key of Text Environment
      v_email_id               TYPE tdline,                         " Text Line
      v_tax                    TYPE thead-tdname,                   " Name
      v_text_tax               TYPE string,                         " Name
      v_idcodetype_1           TYPE ismidcodetype, " Type of Identification Code
      v_idcodetype_2           TYPE ismidcodetype, " Type of Identification Code
      v_psb                    TYPE kvgr1,         " Customer group 1
      v_kvgr1                  TYPE kvgr1,         " Customer group 1
      v_mvgr5_scc_in           TYPE mvgr5,         " Material group 5
      v_mvgr5_scc_of           TYPE mvgr5,         " Material group 5
      v_mvgr5_scm_di           TYPE mvgr5,         " Material group 5
      v_mvgr5_scm_ma           TYPE mvgr5,         " Material group 5
      v_mvgr5_tbt              TYPE mvgr5,         " Material group 5
      v_mis_msg                TYPE thead-tdname,  " Name
      v_comm_meth              TYPE ad_comm,       " Communication Method (Key) (Business Address Services)
      r_vkorg_f044             TYPE TABLE OF range_vkorg, " Range table for VKORG
      r_zlsch_f044             TYPE TABLE OF ty_zlsch_f044,
      r_kvgr1_f044             TYPE RANGE OF salv_de_selopt_low,
      r_mtart_med_issue        TYPE fip_t_mtart_range, " Material Types: Media Issues
      r_sanc_countries         TYPE temr_country,
      r_output_typ             TYPE RANGE OF salv_de_selopt_low,
      r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
      v_num                    TYPE p DECIMALS 2, " Num of type Packed Number
      v_output_typ             TYPE sna_kschl,    " Message type
      v_tax_id                 TYPE salv_de_selopt_low,
      i_tax_id                 TYPE tt_tax_id, " TAX IDs
      r_document_type          TYPE RANGE OF salv_de_selopt_low,
      r_po_type                TYPE RANGE OF salv_de_selopt_low,
      v_po_type                TYPE char1,
      r_comp_code              TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office           TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency          TYPE RANGE OF  salv_de_selopt_low,
      r_print_product          TYPE RANGE OF salv_de_selopt_low,
      r_digital_product        TYPE RANGE OF salv_de_selopt_low,
      li_print_media_product   TYPE TABLE OF ty_vbap,
      li_digital_media_product TYPE TABLE OF ty_vbap,
      lst_digital              TYPE ty_vbap,
      lst_print                TYPE ty_vbap.
CONSTANTS: c_comm_method       TYPE ad_comm    VALUE 'LET',             " Communication Method (Key) (Business Address Services)
           c_mtart_med_iss     TYPE rvari_vnam VALUE 'MTART_MED_ISSUE', " Material Type: Media Issue
*                     c_st           TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
*                     c_object       TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
           c_id_grun           TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
           c_obj_mat           TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
           c_deflt_langu       TYPE sylangu    VALUE 'E',              " Default Language: English
           c_membership_number TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX',  " Standard Text Name
           lc_comp_address     TYPE tdobname VALUE 'ZQTC_WILEY_ADDRESS_F501',     "JMADAKA
           lc_credit_card      TYPE tdobname VALUE 'ZQTC_F501_CREDIT_CARD'.        "JMADAKA
