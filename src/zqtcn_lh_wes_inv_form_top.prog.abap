*&---------------------------------------------------------------------*
*&  Include           ZQTCN_LH_WES_OPM_INV_FORM_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_LH_WES_INV_FORM_TOP
* PROGRAM DESCRIPTION: This driver program implemented for OPM , SG/AC invoice forms
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 02/26/2018
* OBJECT ID: F046.01
* TRANSPORT NUMBER(S): ED2K914566
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910591
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:SPARIMI
* DATE:  07/15/2019
* DESCRIPTION:OPM UK Invoice and Credit Memo changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917923
* REFERENCE NO: ERPM-15475
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 07/APR/2020
* DESCRIPTION: The correct exchange rate for compliance and
*              customer service
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920368
* REFERENCE NO: OTCM-32214 (F046)
* DEVELOPER:MIMMADISET
* DATE:  11/18/2020
* DESCRIPTION:DA Invoice form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920979
* REFERENCE NO    : OTCM 30816(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 12/23/2020
* DESCRIPTION     : Mthree Invoice,Debit and Credit form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-45037/OTCM-30892
* REFERENCE NO:  ED2K924064
* DEVELOPER   :  SGUDA
* DATE        :  08/JULY/2021
* DESCRIPTION :  Auto-send email externally with invoices for Standing Orders
* 1) Send BP Email id if Supplementry PO is 'SO'.
* 2) otherwise YBPERRORACK@wiley.com
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924206,ED2K924265
* REFERENCE NO    : OTCM-49815(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 07/28/2021
* DESCRIPTION     : Mthree changes for displaying the title based on sales org
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924442
* REFERENCE NO    : OTCM-44643(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 08/31/2021
* DESCRIPTION     : Mthree changes for 3501 sales org to display cancel notes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42834 INC0333245
* REFERENCE NO:  ED2K924665
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  30/SEP/2021
* DESCRIPTION :  Exchange rate rounding causing JPY amount on invoice to be incorrect
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924913
* REFERENCE NO    : OTCM-53499
* DEVELOPER       : mimmadiset
* DATE            : 11/18/2021
* DESCRIPTION     : Mthree title changes for bill type ZHCR
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924913
* REFERENCE NO    : OTCM-44643(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 08/31/2021
* DESCRIPTION     : Mthree changes for 3501 sales org to display cancel notes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925092
* REFERENCE NO    : OTCM-55113
* DEVELOPER       : mimmadiset
* DATE            : 12/03/2021
* DESCRIPTION     : Rush changes for 1030 sales org and output type ZXYI
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925315
* REFERENCE NO    : OTCM-55093
* DEVELOPER       : mimmadiset
* DATE            : 12/20/2021
* DESCRIPTION     : Multiple email-id s functioanlity for all sales org in F046
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925664
* REFERENCE NO    : OTCM-58367
* DEVELOPER       : mimmadiset
* DATE            : 02/01/2022
* DESCRIPTION     : Email logic for Austraila
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925763
* REFERENCE NO    : OTCM-59059
* DEVELOPER       : mimmadiset
* DATE            : 02/11/2022
* DESCRIPTION     : Adding decimal value logic based on the company code.

TABLES: tnapr,    " Processing programs for output
        nast,     " Message Status
        toa_dara. " SAP ArchiveLink structure of a DARA line

*- Fimal table
TYPES: BEGIN OF ty_count,
         maktx TYPE char70,                     " Material Description
         kdmat TYPE kdmat,                      " Customer Material
         vkaus TYPE vkaus,                      " Unused - Reserve Length 3
         pstyv TYPE pstyv,                      " Sales document item category
         vbeln TYPE vbeln,                      " Billing Document Number
         posnr TYPE posnr,                      " Billing Document Item
         arktx TYPE arktx,                      " Short text for sales order item
         vkbur TYPE vkbur,                      " Sales Office
         spart TYPE spart,                      " Division
         matnr TYPE matnr,  "++VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
       END OF ty_count,

*- Material Description
       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,                 " Material Number
         maktx TYPE makt-maktx,                 " Material Description (Short Text)
       END OF ty_makt,
*- Material item category group
       BEGIN OF ty_mvke,
         matnr TYPE mvke-matnr,                 " Material Number
         mtpos TYPE mvke-mtpos,                 " Item category group from material master
       END OF ty_mvke,
*- Customer address
       BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,                 " Customer Number
         adrnr TYPE kna1-adrnr,                 " Address
*--> BOC: SPARIMI - 07/15/19 ED1K910591
         stceg TYPE kna1-stceg,                 "Customer VAT
*--> EOC: SPARIMI - 07/15/19 ED1K910591
       END OF ty_kna1,
       BEGIN OF ty_adrc_part,
         addrnumber TYPE adrc-addrnumber,       " Address number
         name1      TYPE adrc-name1,            " Name 1
         name_co    TYPE adrc-name_co,          " c/o name
         city1      TYPE adrc-city1,            " City
         post_code1 TYPE adrc-post_code1,       " City postal code
         street     TYPE adrc-street,           " Street
         region     TYPE adrc-region,           " Region (State, Province, County)
*--> BOC: SPARIMI - 07/15/19 ED1K910591
         country    TYPE adrc-country,            "Country
*--> EOC: SPARIMI - 07/15/19 ED1K910591
       END OF ty_adrc_part,
       BEGIN OF ty_tvlvt,
         spras TYPE tvlvt-spras,                " Language Key
         abrvw TYPE tvlvt-abrvw,                " Usage Indicator
         bezei TYPE tvlvt-bezei,                " Description
       END OF ty_tvlvt,
       BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs,                 " Company Code
         adrnr TYPE t001-adrnr,                 " Address
*--> BOC: SPARIMI - 07/15/19 ED1K910591
         waers TYPE t001-waers,                 " Currency
         stceg TYPE t001-stceg,                 " Tax ID
*--> BOC: SPARIMI - 07/15/19 ED1K910591
       END OF ty_t001,
       BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber,       " Address number
         city1      TYPE adrc-city1,            " City
         post_code1 TYPE adrc-post_code1,       " City postal code
         street     TYPE adrc-street,           " Street
         house_num1 TYPE adrc-house_num1,       " House Number
         region     TYPE adrc-region,           " Region (State, Province, County)
*--> BOC: SPARIMI - 07/15/19 ED1K910591
         country    TYPE adrc-country,            "Country
*--> EOC: SPARIMI - 07/15/19 ED1K910591
       END OF ty_adrc,
       BEGIN OF ty_t001z,
         bukrs TYPE t001z-bukrs,                " Company Code
         party TYPE t001z-party,                " Parameter type
         paval TYPE t001z-paval,                " Parameter Value
       END OF ty_t001z,
       BEGIN OF ty_vbrk,
         vbeln TYPE vbrk-vbeln,                 " Billing Document
         zterm TYPE vbrk-zterm,                 " Terms of Payment Key
         fkdat TYPE vbrk-fkdat,                 " due date "++skkairamko
         bukrs TYPE vbrk-bukrs,                 " Company code "++mimmadiset ED2K920368
         taxk1 TYPE vbrk-taxk1,                 " Tax classification 1 for customer
         knumv TYPE knumv, "++VDPATABALL
       END OF ty_vbrk,
       BEGIN OF ty_vbpa,
         vbeln TYPE vbpa-vbeln,
         parvw TYPE vbpa-parvw,
         kunnr TYPE vbpa-kunnr,
         pernr TYPE vbpa-pernr,
         adrnr TYPE vbpa-adrnr,
       END OF ty_vbpa,
*--> BOC: SPARIMI - 07/15/19 ED1K910591
       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
       BEGIN OF ty_vbrp,"++mimmadiset:OTCM 30816:12/23/2020:ED2K920979
         vbeln      TYPE vbeln_vf,
         posnr      TYPE posnr_vf,
         vgbel      TYPE vgbel,          "reference document
         vgpos      TYPE vgpos,          "reference item
         lland_auft TYPE lland_auft, "Country of destination of sales order
       END OF ty_vbrp."++mimmadiset:OTCM 30816:12/23/2020:ED2K920979


CONSTANTS: c_bank   TYPE zcaconstant-param1 VALUE 'BANK',
           c_remit  TYPE zcaconstant-param1 VALUE 'REMIT',
           c_logo   TYPE zcaconstant-param1 VALUE 'LOGO',
           c_portal TYPE zcaconstant-param1 VALUE 'PORTAL',
           c_object TYPE tdobjectgr VALUE 'GRAPHICS',
           c_bmap   TYPE tdidgr VALUE 'BMAP',
           c_taxdes TYPE zcaconstant-param1 VALUE 'TAX_DES'.

TYPES: BEGIN OF ty_const,
         devid    TYPE zcaconstant-devid,
         param1   TYPE zcaconstant-param1,
         param2   TYPE zcaconstant-param2,
         srno     TYPE zcaconstant-srno,
         sign     TYPE zcaconstant-sign,
         opti     TYPE zcaconstant-opti,
         low      TYPE zcaconstant-low,
         high     TYPE zcaconstant-high,
         activate TYPE zcaconstant-activate,
       END OF ty_const,
       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         invoice_desc    TYPE /idt/invoice_desc,       " Invoice Description
       END OF ty_tax_data,
**BOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
*       *      Email ID structure
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
       tt_emailid TYPE STANDARD TABLE OF ty_emailid INITIAL SIZE 0.
**EOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
DATA:i_emailid      TYPE tt_emailid,  "++ mimmadiset OTCM-55093 ED2K925315 12/20/2021
     ls_emailid     TYPE ty_emailid,  "++ mimmadiset OTCM-55093 ED2K925315 12/20/2021
     lt_const       TYPE TABLE OF ty_const,
     lst_const      TYPE ty_const,
     i_tax_id       TYPE STANDARD TABLE OF ty_tax_id,
     v_inv_desc     TYPE rvari_vnam,
     i_tax_data     TYPE STANDARD TABLE OF ty_tax_data,
     v_invoice_desc TYPE /idt/invoice_desc. " Invoice Description

*--> EOC: SPARIMI - 07/15/19 ED1K910591
DATA: li_makt                TYPE STANDARD TABLE OF ty_makt ##NEEDED,                   " Material Descriptions
      li_mvke                TYPE STANDARD TABLE OF ty_mvke ##NEEDED,                   " Sales Data for Material
      li_adrc                TYPE STANDARD TABLE OF ty_adrc ##NEEDED,                   " Addresses (Business Address Services)
      li_t001z               TYPE STANDARD TABLE OF ty_t001z ##NEEDED,                  " Additional Specifications for Company Code
      li_vbrk                TYPE STANDARD TABLE OF ty_vbrk ##NEEDED,                   " Billing Document: Header Data
      li_adrc_part           TYPE STANDARD TABLE OF ty_adrc_part ##NEEDED,              " Addresses (Business Address Services)
      li_kna1                TYPE STANDARD TABLE OF ty_kna1 ##NEEDED,                   " General Data in Customer Master
      li_tvlvt               TYPE STANDARD TABLE OF ty_tvlvt ##NEEDED,                  " Release order usage ID: Texts
      li_t001                TYPE STANDARD TABLE OF ty_t001 ##NEEDED,                   " Company Codes
      li_count               TYPE STANDARD TABLE OF ty_count ##NEEDED,                  " Total Counts
      li_bil_invoice         TYPE lbbil_invoice   ##NEEDED,                               " Billing Data: Transfer Structure to Smart Forms
      li_person_mail_id      TYPE TABLE OF p0105,             " HR Master Record: Infotype 0001 (Org. Assignment)
      li_output              TYPE ztqtc_output_supp_retrieval ##NEEDED,                 " Table Type for ZSTQTC_OUTPUT_SUPP_RETRIEVAL
      li_hdr_itm             TYPE zstqtc_lh_opm_hdr_itm_f046 ##NEEDED,                  " Structure for LH/OPM Invoice Header and Item Data
      li_itm_gen             TYPE ztqtc_lh_opm_item_f046 ##NEEDED,                      " Table type for LH/OPM Invoice Item Data
      li_print_data_to_read  TYPE lbbil_print_data_to_read ##NEEDED,                    " Select. of Tables to be Compl. for Printing RD00;SmartForms
      st_address             TYPE zstqtc_add_f037 ##NEEDED,                             " Structure for address node
      li_vbrp                TYPE STANDARD TABLE OF ty_vbrp,                            "item
      st_formoutput          TYPE fpformoutput ##NEEDED,                                " Form Output (PDF, PDL)
      st_hd_adr              TYPE lbbil_hd_adr,                                         " Header Address
      i_content_hex          TYPE solix_tab ##NEEDED,                                   " Content table
      repeat(1)              TYPE c ##NEEDED,                                           " Repeat
      nast_anzal             TYPE nast-anzal ##NEEDED,                                  " Number of outputs (Orig. + Cop.)
      nast_tdarmod           TYPE nast-tdarmod ##NEEDED,                                " Archiving only one time
      v_division             TYPE char30 ##NEEDED,                                      " Sales Org Division
      v_param1               TYPE rvari_vnam,
      v_sales_office         TYPE vkbur,
      st_vbpa                TYPE ty_vbpa,
      v_fkimg                TYPE char20 ##NEEDED,                                      " Billing Qty
      v_fkimg_fr             TYPE char20 ##NEEDED,                                      " Billing Qty
      v_fkimg_bk             TYPE char20 ##NEEDED,                                      " Billing Qty
      lst_itm_gen            TYPE zstqtc_lh_opm_itm_f046 ##NEEDED,                      " Structure for LH/OPM Invoice Item Data
      lst_count              TYPE ty_count ##NEEDED,                                    " Total Counts
      v_kzwi5                TYPE kzwi5 ##NEEDED,                                       " Subtotal 5 from pricing procedure for condition
      v_formname             TYPE fpname ##NEEDED,                                      " Formname.
      v_ent_retco            TYPE sy-subrc ##NEEDED,                                    " ABAP System Field: Return Code of ABAP Statements
      v_ent_screen           TYPE c ##NEEDED,                                           " Screen of type Character
*      v_send_email           TYPE ad_smtpadr ##NEEDED,                                 " E-Mail Address"mimmadiset OTCM-55093 ED2K925315
      v_retcode              TYPE sy-subrc,                                             " Return code
      v_er_name              TYPE char50 ##NEEDED,                                      " E-Mail Address
      v_persn_adrnr          TYPE knvk-prsnr ##NEEDED,                                  " E-Mail Address
      v_output_typ           TYPE sna_kschl ##NEEDED,                                   " Message type
*            g_language            TYPE sy-langu ##NEEDED,                                    " Lang
      v_logo                 TYPE salv_de_selopt_low ##NEEDED,                          " Lower Value of Selection Condition
      v_bmp                  TYPE xstring ##NEEDED,                                     " Bitma
      " BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
      v_ref_curr             TYPE bwaer_curv,                                           " Reference currency for currency translation
      v_to_curr              TYPE tcurr_curr,                                           " To-currency
      v_bill_date            TYPE fkdat,                                                " Billing date
      " EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
*--> BOC: SPARIMI - 07/15/19 ED1K910591
      v_doc_currency         TYPE waers ##NEEDED,
      v_cust_currency        TYPE waers,
      v_loc_currency         TYPE waers,
      v_comp_code_ctry       TYPE land1,
      v_euro_ind             TYPE xegld,
      v_vat                  TYPE stceg,
      v_flg_cr               TYPE c,
      v_seller_reg           TYPE tdline,
*--> EOC: SPARIMI - 07/15/19 ED1K910591
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
      r_sales_team_email     TYPE RANGE OF salv_de_selopt_low,
      r_supplement_po        TYPE RANGE OF salv_de_selopt_low,
      r_supplement_po_output TYPE RANGE OF salv_de_selopt_low,
      li_lines_po            TYPE STANDARD TABLE OF tline, "Lines of text read
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
      r_currency_from        TYPE RANGE OF salv_de_selopt_low,
      r_currency_to          TYPE RANGE OF salv_de_selopt_low.
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
CONSTANTS: c_zopm_form_name       TYPE fpname   VALUE 'ZQTC_FRM_LH_OPM_INVOICE_F046',    " OPM form layout
           c_zsga_form_name       TYPE fpname   VALUE 'ZQTC_FRM_LH_SG_AG_INVOICE_F046',  " SG/AG Form
           c_zdcm_form_name       TYPE fpname   VALUE 'ZQTC_FRM_LH_CRDT_DBT_MEMO_F047',  " Debit/Credi Memo
           c_zm3c_form_name       TYPE fpname   VALUE 'ZQTC_FRM_MTH_INV_CR_DR_F046_2',   "Invoice,Debit/Credi Memo
           c_zopm                 TYPE char4    VALUE 'ZOPM',                            " OPM output
           c_zsga                 TYPE char4    VALUE 'ZSGA',                            " SG/AG output
*          BOC by VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
           c_zcda                 TYPE char4    VALUE 'ZCDA',                             " DA Invoice output
           c_zdam                 TYPE char4    VALUE 'ZDAM',
           c_zscm                 TYPE char4    VALUE 'ZSCM', "ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
**        EOC by VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
**        BOC ++mimmadiset:OTCM 30816:12/23/2020:ED2K920979
           c_zm3c                 TYPE char4    VALUE 'ZM3C',                           "Mthree invoice,Debit/Credit Memo
           c_zxyi                 TYPE char4    VALUE 'ZXYI',                           "Rush changes
           c_zdr                  TYPE char4    VALUE 'ZDR',                             "Mthree debit
           c_zcr                  TYPE char4    VALUE 'ZCR',                             "Mthree credit
           c_zf2                  TYPE char4    VALUE 'ZF2',                             "Invoice
           c_us                   TYPE lland    VALUE 'US',                              "Country US
           c_00                   TYPE spart    VALUE '00',                              " Division
           c_comma                TYPE char1 VALUE ',',
           c_cust                 TYPE char10 VALUE 'CUST_EMAIL',                       "Customer service email
**         EOC ++mimmadiset:OTCM 30816:12/23/2020:ED2K920979
           c_zdcm                 TYPE char4    VALUE 'ZDCM',                            " Debit/Credit Memo output
           c_zprg                 TYPE pstyv    VALUE 'ZPRG',                            " Item Cat
*            c_zffs           TYPE pstyv    VALUE 'ZFFS',                           " Item Cat
           c_zreg                 TYPE pstyv      VALUE 'ZREG',   " ++ERPM-125           " Item Cat
           c_excrate_typ_m        TYPE kurst_curr VALUE 'M',      " ++CR#ERPM-15475        Exchange Rate Type
           c_10                   TYPE spart    VALUE '10',                              " Division
           c_30                   TYPE spart    VALUE '30',                              " Division
           c_40                   TYPE spart    VALUE '40',                              " Division for DAT *BOC by MIMMADISET:ED2K920368:
           c_20                   TYPE spart    VALUE '20',                              " Divisio
           c_100                  TYPE vkbur    VALUE '0100',                            " Sales Office
           c_0                    TYPE char4    VALUE '0.00',                            " Sales Office
           c_cust_mail            TYPE char20   VALUE 'WES@wiley.com',                   " Customer service mail id
           c_cust_mail_20         TYPE char100  VALUE 'info@thesoftwareguild.com ',      " Customer service mail id
*           c_cust_mth       TYPE char30   VALUE 'mthreesupport@wiley.com',         " Mthree customer mail id
           c_re                   TYPE parvw    VALUE 'RE',                              " Partner Function
           c_1                    TYPE na_nacha VALUE '1',                               " Print Function
           c_5                    TYPE na_nacha VALUE '5',                               " Email Function
           c_pdf                  TYPE toadv-doc_type  VALUE 'PDF',                      " for PDF
           c_credit               TYPE vbtyp    VALUE 'O',                               " SD document category
           c_debit                TYPE vbtyp    VALUE 'P',                               " SD document category
           c_tax                  TYPE char3    VALUE 'Tax',                             " Tax text
           c_eq                   TYPE char1    VALUE '=',                               " Equal
           c_at                   TYPE char1    VALUE '@',                               " At the rate
           c_we                   TYPE parvw      VALUE 'WE',                            " Partner Function
           c_er                   TYPE char02     VALUE 'ZM',                            " Employee responsible
           c_z1                   TYPE knvk-pafkt VALUE 'Z1',                            " Contact person function
           c_e                    TYPE char1      VALUE 'E',                             " Error Message
           c_zqtc_r2              TYPE syst-msgid VALUE 'ZQTC_R2',                       " Message ID
           c_msg_no               TYPE syst-msgno VALUE '000',                           " Message Number
           c_x                    TYPE char1    VALUE 'X',                               " for x
           c_w                    TYPE char1    VALUE 'W',                               " for Web
           c_n                    TYPE vbrk-vbtyp VALUE 'N',                             " SD Document category
           c_colen                TYPE char1    VALUE ':',                               " Coolen
           c_under                TYPE char1    VALUE '-',                               " Underscore
           c_vbbk                 TYPE tdobject VALUE 'VBBK',                            " Text object
           c_0007                 TYPE tdid     VALUE '0007',                            " Text id
           c_0001                 TYPE vbrk-zterm VALUE '0001',                          " Terms of payment
           c_105                  TYPE prelp-infty VALUE '0105',                         " Infotype
           c_end                  TYPE prelp-endda VALUE '99991231',                     " End Date
           c_start                TYPE prelp-begda VALUE '18000101',                     " Start Date
           c_0010                 TYPE pa0105-usrty VALUE '0010',                        " Communication Type
           c_devid                TYPE zdevid   VALUE 'F046',
           c_3310                 TYPE bukrs    VALUE '3310',                            " Dev ID
           c_1030                 TYPE bukrs    VALUE '1030',                            " Dev ID
           c_hdr_posnr            TYPE posnr VALUE '00000',                              " Bitmap
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
           c_sales_team_email     TYPE rvari_vnam VALUE 'SALES_TEAM_EMAIL',
           c_supplement_po        TYPE rvari_vnam VALUE 'SUPPLEMENT_PO',
           c_supplement_po_output TYPE rvari_vnam VALUE 'SUPPLEMENT_PO_OUTPUT',
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
* Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924665
           lc_currency_from       TYPE rvari_vnam VALUE 'CURRENCY_FROM',
           lc_currency_to         TYPE rvari_vnam VALUE 'CURRENCY_TO',
* End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924665
           "BOC:OTCM-49815:ED2K924206,ED2K924265:07.28.2021: MIMMADISET
           c_header1              TYPE posnr VALUE '000000',
           c_ag                   TYPE parvw    VALUE 'AG',                              " Partner Function
           c_inv_note             TYPE rvari_vnam VALUE 'INV_NOTE',
           c_cr_note              TYPE rvari_vnam VALUE 'CR_NOTE',
           c_can_note             TYPE rvari_vnam VALUE 'CAN_NOTE', "++BOC OTCM-44643  ED2K924913
           c_ref_inv              TYPE rvari_vnam VALUE 'REF_INV',  "++BOC OTCM-44643  ED2K924913
*           c_tax_code             TYPE rvari_vnam VALUE 'TAX_CODE',
           c_zs1                  TYPE char4    VALUE 'ZS1',   "++BOC OTCM-44643 ED2K924913                        "Invoice
           c_tax_crnote           TYPE rvari_vnam VALUE 'TAX_CRNOTE',
           c_cr_note_zhcr         TYPE rvari_vnam VALUE 'CR_NOTE_ZHCR', "++BOC OTCM-53499 ED2K924913
           c_zhcr                 TYPE char4      VALUE 'ZHCR',   "++BOC OTCM-53499 ED2K924913
           c_cust_srv             TYPE char10 VALUE 'CUST_SRV', "mimmadiset:OTCM-55113:12/06/2021: ED2K925092    "Customer service text
           c_decimal              TYPE char10 VALUE 'DECIMAL',  " mimmadiset ED2K925763 2/11/2022 OTCM_59059
           c_70                   TYPE spart    VALUE '70', "mimmadiset:OTCM-55113:12/06/2021: ED2K925092        " Division
           c_80                   TYPE spart    VALUE '80', "mimmadiset:OTCM-58367:02/01/2022: ED2K925664        " Division
           "EOC:OTCM-49815:ED2K924206,ED2K924265:07.28.2021: MIMMADISET
           " BOC mimmadiset OTCM-55093 ED2K925315 12/20/2021
           c_timstmp              TYPE char6      VALUE '000000',         " Timstmp of type CHAR6
           c_validfrm             TYPE ad_valfrom VALUE '19000101000000', " Communication Data: Valid From (YYYYMMDDHHMMSS)
           c_validto              TYPE ad_valto   VALUE '99991231235959'. " Communication Data: Valid To (YYYYMMDDHHMMSS)
" EOC mimmadiset OTCM-55093 ED2K925315 12/20/2021
