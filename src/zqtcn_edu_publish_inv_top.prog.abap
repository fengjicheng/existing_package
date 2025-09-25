*&---------------------------------------------------------------------*
*&  Include   ZQTCN_EDU_PUBLISH_INV_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDU_PUBLISH_INV_TOP
* PROGRAM DESCRIPTION: Decleraions
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE: 6/14/2019
* OBJECT ID: F049
* TRANSPORT NUMBER(S): ED1K910387
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-4140
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER: SKKAIRAMKO
* DATE:  10/23/2019
* DESCRIPTION: During Currency Conversion date changed from Billing date to pricing date
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917932
* REFERENCE NO: ERPM-15476
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 08/APR/2020
* DESCRIPTION: The correct exchange rate for compliance and
*              customer service
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918223
* REFERENCE NO: F061
* DEVELOPER: AMOHAMMED
* DATE:  06/09/2020
* DESCRIPTION: This INCLUDE is implemented for WLS (Wiley Learning Solutions)
*              Invoice form
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-45037/OTCM-30892
* REFERENCE NO:  ED2K924068
* DEVELOPER   :  SGUDA
* DATE        :  08/JULY/2021
* DESCRIPTION :  Auto-send email externally with invoices for Standing Orders
* 1) Send BP Email id if Supplementry PO is 'SO'.
* 2) otherwise YBPERRORACK@wiley.com
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913795
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42834 INC0333245
* REFERENCE NO:  ED2K924671
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  30/SEP/2021
* DESCRIPTION :  Exchange rate rounding causing JPY amount on invoice to be incorrect
*----------------------------------------------------------------------*
TABLES: tnapr,    " Processing programs for output
        nast,     " Message Status
        toa_dara. " SAP ArchiveLink structure of a DARA line
*- Fimal table
TYPES: BEGIN OF ty_count,
         maktx(150) TYPE c,     " Material Description
         kdmat      TYPE kdmat, " Customer Material
         vkaus      TYPE vkaus, " Unused - Reserve Length 3
         pstyv      TYPE pstyv, " Sales document item category
         vbeln      TYPE vbeln, " Billing Document Number
         posnr      TYPE posnr, " Billing Document Item
         arktx      TYPE arktx, " Short text for sales order item
         " Old Material Number
         bismt      TYPE bismt, " by AMOHAMMED - 06/09/2020 - ED2K918223
         vkbur      TYPE vkbur, " Sales Office
         spart      TYPE spart, " Division
         vrkme      TYPE char8, " Sales unit
       END OF ty_count,
*- Material Description
       BEGIN OF ty_makt,
         matnr TYPE makt-matnr, " Material Number
         maktx TYPE makt-maktx, " Material Description (Short Text)
       END OF ty_makt,
*- Material item category group
       BEGIN OF ty_mvke,
         matnr TYPE mvke-matnr, " Material Number
         mtpos TYPE mvke-mtpos, " Item category group from material master
       END OF ty_mvke,
*- Customer address
       BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr, " Customer Number
         adrnr TYPE kna1-adrnr, " Address
         stceg TYPE kna1-stceg, " Customer VAT
       END OF ty_kna1,
       BEGIN OF ty_adrc_part,
         addrnumber TYPE adrc-addrnumber, " Address number
         name1      TYPE adrc-name1,      " Name 1
         name_co    TYPE adrc-name_co,    " c/o name
         city1      TYPE adrc-city1,      " City
         post_code1 TYPE adrc-post_code1, " City postal code
         street     TYPE adrc-street,     " Street
         region     TYPE adrc-region,     " Region (State, Province, County)
         country    TYPE adrc-country,    " Country
       END OF ty_adrc_part,
       BEGIN OF ty_tvlvt,
         spras TYPE tvlvt-spras, " Language Key
         abrvw TYPE tvlvt-abrvw, " Usage Indicator
         bezei TYPE tvlvt-bezei, " Description
       END OF ty_tvlvt,
       BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs, " Company Code
         land1 TYPE t001-land1, " Country
         waers TYPE t001-waers, " Currency
         adrnr TYPE t001-adrnr, " Address
       END OF ty_t001,
       BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber, " Address number
         city1      TYPE adrc-city1,      " City
         post_code1 TYPE adrc-post_code1, " City postal code
         street     TYPE adrc-street,     " Street
         house_num1 TYPE adrc-house_num1, " House Number
         region     TYPE adrc-region,     " Region (State, Province, County)
         ctry       TYPE adrc-country,    " Ctry
       END OF ty_adrc,
       BEGIN OF ty_t001z,
         bukrs TYPE t001z-bukrs, " Company Code
         party TYPE t001z-party, " Parameter type
         paval TYPE t001z-paval, " Parameter Value
       END OF ty_t001z,
       BEGIN OF ty_vbrk,
         vbeln TYPE vbrk-vbeln, " Billing Document
         fkart TYPE vbrk-fkart, " Billing type
         " Shipping Conditions
         vsbed TYPE vsbed,      " by AMOHAMMED - 06/09/2020 - ED2K918223
         fkdat TYPE vbrk-fkdat, " Due date
         " Fiscal Year
         gjahr TYPE gjahr,      " by AMOHAMMED - 06/09/2020 - ED2K918223
         zterm TYPE vbrk-zterm, " Terms of Payment Key
         " Company Code
         bukrs TYPE bukrs,      " by AMOHAMMED - 06/09/2020 - ED2K918223
         taxk1 TYPE vbrk-taxk1, " Tax classification 1 for customer
         mwsbk TYPE mwsbp, " by immadiset
       END OF ty_vbrk,
       BEGIN OF ty_vbpa,
         vbeln TYPE vbpa-vbeln,
         parvw TYPE vbpa-parvw,
         kunnr TYPE vbpa-kunnr,
         pernr TYPE vbpa-pernr,
         adrnr TYPE vbpa-adrnr,
       END OF ty_vbpa,
       BEGIN OF ty_const,
         devid    TYPE zdevid,
         param1   TYPE rvari_vnam,
         param2   TYPE rvari_vnam,
         srno     TYPE tvarv_numb,
         sign     TYPE tvarv_sign,
         opti     TYPE tvarv_opti,
         low      TYPE salv_de_selopt_low,
         high     TYPE salv_de_selopt_high,
         activate TYPE zconstactive,
       END OF ty_const,
       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         invoice_desc    TYPE /idt/invoice_desc,       " Invoice Description
       END OF ty_tax_data,
       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
*- Begin of change VDPATABALL ERPM-8210 Knewton Billing Date  31/12/2019
       BEGIN OF ty_vbak,
         " Userid who created the order or contract
         ernam TYPE ernam,   " by AMOHAMMED - 06/09/2020 - ED2K918223
         auart TYPE auart,
         ktext TYPE ktext_v,
       END OF ty_vbak,
*- End of change VDPATABALL    ERPM-8210 Knewton Billing Date 31/12/2019

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
       " Structure for Shipping conditions text
       BEGIN OF ty_tvsbt,
         vsbed TYPE vsbed,     " Shipping Conditions
         vtext TYPE vsbed_bez, " Description of the shipping conditions
       END OF ty_tvsbt,
       " Structure for Accounting document
       BEGIN OF ty_bseg,
         bukrs TYPE bukrs,   " Company Code
         belnr TYPE belnr_d, " Accounting Document Number
         gjahr TYPE gjahr,   " Fiscal Year
         augbl TYPE augbl,   " Document Number of the Clearing Document
         koart TYPE koart,   " Account Type
       END OF ty_bseg,
       " Structure for Old Material number
       BEGIN OF ty_mara,
         matnr TYPE matnr, " Material number
         bismt TYPE bismt, " Old Material number
         meins TYPE meins,  "Base Unit of Measure
       END OF ty_mara,
       "Units of Measure for Material
       BEGIN OF ty_marm,
         matnr TYPE matnr, "Materila number
         meinh TYPE lrmei, "Alternative Unit of Measure for Stockkeeping Unit
         umrez TYPE umrez, "Base Units of Measure
       END OF ty_marm,
       " Structure for e-mail address
       BEGIN OF ty_send_email,
         send_email TYPE ad_smtpadr, " E-Mail Address
       END OF ty_send_email,
       tt_send_email TYPE STANDARD TABLE OF ty_send_email. " Table type for e-mail address
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

DATA: li_makt                TYPE STANDARD TABLE OF ty_makt ##NEEDED,      " Material Descriptions
      li_mvke                TYPE STANDARD TABLE OF ty_mvke ##NEEDED,      " Sales Data for Material
      li_adrc                TYPE STANDARD TABLE OF ty_adrc ##NEEDED,      " Addresses (Business Address Services)
      li_t001z               TYPE STANDARD TABLE OF ty_t001z ##NEEDED,     " Additional Specifications for Company Code
      li_vbrk                TYPE STANDARD TABLE OF ty_vbrk ##NEEDED,      " Billing Document: Header Data
      li_adrc_part           TYPE STANDARD TABLE OF ty_adrc_part ##NEEDED, " Addresses (Business Address Services)
      li_kna1                TYPE STANDARD TABLE OF ty_kna1 ##NEEDED,      " General Data in Customer Master
      li_tvlvt               TYPE STANDARD TABLE OF ty_tvlvt ##NEEDED,     " Release order usage ID: Texts
      li_t001                TYPE STANDARD TABLE OF ty_t001 ##NEEDED,      " Company Codes
      li_count               TYPE STANDARD TABLE OF ty_count ##NEEDED,     " Total Counts
      li_const               TYPE STANDARD TABLE OF ty_const,
      i_tax_data             TYPE STANDARD TABLE OF ty_tax_data,
      i_tax_id               TYPE STANDARD TABLE OF ty_tax_id,
      li_bil_invoice         TYPE lbbil_invoice ##NEEDED,                  " Billing Data: Transfer Structure to Smart Forms
      li_person_mail_id      TYPE TABLE OF p0105,                          " HR Master Record: Infotype 0001 (Org. Assignment)
      li_output              TYPE ztqtc_output_supp_retrieval ##NEEDED,    " Table Type for ZSTQTC_OUTPUT_SUPP_RETRIEVAL
      li_hdr_itm             TYPE zstqtc_edu_publis_hdr_itm_f049 ##NEEDED, " Structure for LH/OPM Invoice Header and Item Data
      li_itm_gen             TYPE ztqtc_edu_publish_itm_f049 ##NEEDED,     " Table type for LH/OPM Invoice Item Data
      li_print_data_to_read  TYPE lbbil_print_data_to_read ##NEEDED,       " Select. of Tables to be Compl. for Printing RD00;SmartForms
      st_address             TYPE zstqtc_add_f037 ##NEEDED,                " Structure for address node
      st_formoutput          TYPE fpformoutput ##NEEDED,                   " Form Output (PDF, PDL)
      st_hd_adr              TYPE lbbil_hd_adr,                            " Header Address
      i_content_hex          TYPE solix_tab ##NEEDED,                      " Content table
      repeat(1)              TYPE c ##NEEDED,                              " Repeat
      nast_anzal             TYPE nast-anzal ##NEEDED,                     " Number of outputs (Orig. + Cop.)
      nast_tdarmod           TYPE nast-tdarmod ##NEEDED,                   " Archiving only one time
      v_division             TYPE char30 ##NEEDED,                         " Sales Org Division
      v_param1               TYPE rvari_vnam,
      v_sales_office         TYPE vkbur,
      v_price_date           TYPE prsdt,                                   " ++ERPM-4140  SKKAIRAMKO 10/23/2019
      st_vbpa                TYPE ty_vbpa,
      v_fkimg                TYPE char20 ##NEEDED,                         " Billing Qty
      v_fkimg_fr             TYPE char20 ##NEEDED,                         " Billing Qty
      v_fkimg_bk             TYPE char20 ##NEEDED,                         " Billing Qty
      v_inv_desc             TYPE rvari_vnam,
      v_seller_reg           TYPE tdline,
      v_invoice_desc         TYPE /idt/invoice_desc,                       " Invoice Description
      lst_itm_gen            TYPE zstqtc_edu_publish_itm_f049 ##NEEDED,    " Structure for LH/OPM Invoice Item Data
      lst_count              TYPE ty_count ##NEEDED,                       " Total Counts
      st_ktext               TYPE ty_vbak,                                 " ++VDPATABALL ERPM-8210 Knewton Billing Date  31/12/2019
      v_kzwi5                TYPE kzwi5 ##NEEDED,                          " Subtotal 5 from pricing procedure for condition
      v_formname             TYPE fpname ##NEEDED,                         " Formname.
      v_ent_retco            TYPE sy-subrc ##NEEDED,                       " ABAP System Field: Return Code of ABAP Statements
      v_ent_screen           TYPE c ##NEEDED,                              " Screen of type Character
      v_send_email           TYPE ad_smtpadr ##NEEDED,                     " E-Mail Address
      v_retcode              TYPE sy-subrc,                                " Return code
      v_er_name              TYPE char50 ##NEEDED,                         " E-Mail Address
      v_persn_adrnr          TYPE knvk-prsnr ##NEEDED,                     " E-Mail Address
      v_output_typ           TYPE sna_kschl ##NEEDED,                      " Message type
      v_doc_currency         TYPE waers ##NEEDED,
      v_cust_currency        TYPE waers,
      v_loc_currency         TYPE waers,
      v_comp_code_ctry       TYPE land1,
      v_euro_ind             TYPE xegld,
      v_vat                  TYPE stceg,
      v_logo                 TYPE salv_de_selopt_low VALUE 'ZJWILEY_LOGO', " Logo
      v_bmp                  TYPE xstring ##NEEDED,                        " Bitmap
      " BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
      v_ref_curr             TYPE bwaer_curv,                              " Reference currency for currency translation
      v_to_curr              TYPE tcurr_curr,                              " To-currency
      v_bill_date            TYPE fkdat,                                   " Billing date
      " EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
      v_flg_cr               TYPE c,                                       " Credit memo "++SKKAIRAMKO
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
      li_tvsbt               TYPE STANDARD TABLE OF ty_tvsbt,              " Shipping Conditions: Texts
      lst_itm_gen_f061       TYPE zstqtc_wls_publish_itm_f061 ##NEEDED,    " Structure for WLS Invoice Item Data
      li_itm_gen_f061        TYPE ztqtc_wls_publish_itm_f061 ##NEEDED,     " Table type for WLS Invoice Item Data
      li_bseg                TYPE STANDARD TABLE OF ty_bseg,               " Accounting Document Segment
      v_fiscal_yr            TYPE gjahr,                                   " Current Fiscal Year
      li_mara                TYPE STANDARD TABLE OF ty_mara,               " Old Material number internal table
      li_send_email          TYPE TABLE OF ty_send_email,                 " receipent emails
      li_marm                TYPE STANDARD TABLE OF ty_marm,              "Alternative Unit of Measure
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code            TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office         TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency        TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
      r_sales_team_email     TYPE RANGE OF salv_de_selopt_low,
      r_supplement_po        TYPE RANGE OF salv_de_selopt_low,
      r_supplement_po_output TYPE RANGE OF salv_de_selopt_low,
      li_lines_po            TYPE STANDARD TABLE OF tline, "Lines of text read
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
      r_currency_from        TYPE RANGE OF salv_de_selopt_low,
      r_currency_to          TYPE RANGE OF salv_de_selopt_low.
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
CONSTANTS: c_frm_name_f049        TYPE fpname     VALUE 'ZQTC_FRM_EDU_PUBLISH_INV_F049', " Form
           c_zprg                 TYPE pstyv      VALUE 'ZPRG',                          " Item Cat
           c_zreg                 TYPE pstyv      VALUE 'ZREG',                          " ++ERPP-125 Item Cat
           c_excrate_typ_m        TYPE kurst_curr VALUE 'M',                             " ++CR#ERPM-15476 Exchange Rate Type
           c_10                   TYPE spart      VALUE '10',                            " Division
           c_30                   TYPE spart      VALUE '30',                            " Division
           c_20                   TYPE spart      VALUE '20',                            " Divisio
           c_100                  TYPE vkbur      VALUE '0100',                          " Sales Office
           c_0                    TYPE char4      VALUE '0.00',                          " Sales Office
*           c_cust_mail     TYPE char40     VALUE 'knewtonsupport@wiley.com',      " Customer service mail id
*           c_cust_mail_20 TYPE char100     VALUE 'info@thesoftwareguild.com ',    " Customer service mail id
           c_re                   TYPE parvw      VALUE 'RE',                            " Partner Function
           c_1                    TYPE na_nacha   VALUE '1',                             " Print Function
           c_5                    TYPE na_nacha   VALUE '5',                             " Email Function
           c_pdf                  TYPE toadv-doc_type VALUE 'PDF',                       " for PDF
           c_credit               TYPE vbtyp      VALUE 'O',                             " SD document category
           c_cancel               TYPE vbtyp      VALUE 'N',
           c_debit                TYPE vbtyp      VALUE 'P',                             " SD document category
           c_tax                  TYPE char3      VALUE 'Tax',                           " Tax text
           c_eq                   TYPE char1      VALUE '=',                             " Equal
           c_at                   TYPE char1      VALUE '@',                             " At the rate
           c_we                   TYPE parvw      VALUE 'WE',                            " Partner Function
           c_er                   TYPE char02     VALUE 'ZM',                            " Employee responsible
           c_z1                   TYPE knvk-pafkt VALUE 'Z1',                            " Contact person function
           c_e                    TYPE char1      VALUE 'E',                             " Error Message
           c_zqtc_r2              TYPE syst-msgid VALUE 'ZQTC_R2',                       " Message ID
           c_msg_no               TYPE syst-msgno VALUE '000',                           " Message Number
           c_x                    TYPE char1      VALUE 'X',                             " for x
           c_w                    TYPE char1      VALUE 'W',                             " for Web
           c_n                    TYPE vbrk-vbtyp VALUE 'N',                             " SD Document category
           c_p                    TYPE vbrk-vbtyp VALUE 'P',                             " SD Document category
           c_o                    TYPE vbrk-vbtyp VALUE 'O',                             " SD Document category
           c_colen                TYPE char1      VALUE ':',                             " Coolen
           c_under                TYPE char1      VALUE '-',                             " Underscore
           c_vbbk                 TYPE tdobject   VALUE 'VBBK',                          " Text object
           c_0007                 TYPE tdid       VALUE '0007',                          " Text id
           c_0001                 TYPE vbrk-zterm VALUE '0001',                          " Terms of payment
           c_105                  TYPE prelp-infty VALUE '0105',                         " Infotype
           c_end                  TYPE prelp-endda VALUE '99991231',                     " End Date
           c_start                TYPE prelp-begda VALUE '18000101',                     " Start Date
           c_devid                TYPE zdevid      VALUE 'F049',
           c_hdr_posnr            TYPE posnr       VALUE '00000',
           c_0010                 TYPE pa0105-usrty VALUE '0010',                        " Communication Type
           c_bank                 TYPE zcaconstant-param1 VALUE 'BANK',                  " ++VDPATABAll 12/10/2019 ERPM-8349
           c_portal               TYPE zcaconstant-param1 VALUE 'PORTAL',                " ++VDPATABAll 12/10/2019 ERPM-8349
           c_remit                TYPE zcaconstant-param1 VALUE 'REMIT',                 " ++VDPATABAll 12/10/2019 ERPM-8349
           c_outtyp               TYPE kschl              VALUE 'ZINV',                  " ++VDPATABALL 02/01/2020 ERPM-8210
           c_doctyp               TYPE auart              VALUE 'ZENT',                  " ++VDPATABALL 02/01/2020 ERPM-8210
           c_zsnv                 TYPE kschl              VALUE 'ZSNV',  "OTCM-30892
           c_bank1                TYPE thead-tdname   VALUE 'ZQTC_F049_BANK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
           c_remit1               TYPE thead-tdname   VALUE 'ZQTC_F049_CHECK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
           c_frm_name_f061        TYPE fpname             VALUE 'ZQTC_FRM_WLS_INV_F061',    " Form
           c_outtyp1              TYPE kschl              VALUE 'ZW00',                  " 'ZINV',
           c_d                    TYPE char1              VALUE 'D',                     " Account type : Customers
           c_pstyv                TYPE pstyv              VALUE 'ZFRT',                  " Sales document item category
           c_doc_type             TYPE char1              VALUE 'J',                     " Delivery document
           c_devid_f061           TYPE zdevid             VALUE 'F061',                  " Development ID
           c_ship                 TYPE zcaconstant-param1 VALUE 'SHIP',
           c_cp                   TYPE parvw              VALUE 'AP',                   " Partner Function Contact Person
           c_zpan                 TYPE pstyv              VALUE 'ZPAN',                 "Sales document item category
           c_zckt                 TYPE pstyv              VALUE 'ZCKT',                 "Sales document item category
           c_zkt1                 TYPE pstyv              VALUE 'ZKT1',                 "Sales document item category
           c_zhun                 TYPE kscha              VALUE 'ZHUN',                 "Condition type
           c_zwv                  TYPE fkart              VALUE 'ZWV',                  "Billing type
           c_ea                   TYPE vrkme              VALUE 'EA',                   "Unit of measure
           c_set                  TYPE vrkme              VALUE 'SET',                  "Unit of measure
           c_higherline           TYPE uepos              VALUE '000000',
           c_usd                  TYPE waers              VALUE 'USD',
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
           c_supp_email_body      TYPE rvari_vnam VALUE 'ZQTC_EMAIL_BODY_STANDING_ORD',
           c_sales_team_email     TYPE rvari_vnam VALUE 'SALES_TEAM_EMAIL',
           c_supplement_po        TYPE rvari_vnam VALUE 'SUPPLEMENT_PO',
           c_supplement_po_output TYPE rvari_vnam VALUE 'SUPPLEMENT_PO_OUTPUT',
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
* Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
           lc_currency_from       TYPE rvari_vnam VALUE 'CURRENCY_FROM',
           lc_currency_to         TYPE rvari_vnam VALUE 'CURRENCY_TO'.
* End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
