*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_RENEWAL_NOTICE_TOP
* REPORT DESCRIPTION:    Include for top declaration
* DEVELOPER:             Srabanti Bose (SRBOSE)
* CREATION DATE:         11-Jan-2017
* OBJECT ID:             F035
* TRANSPORT NUMBER(S):   ED2K904080
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904800
* REFERENCE NO:  ED2K905714
* DEVELOPER: Monalisa Dutta
* DATE:  04/24/2017
* DESCRIPTION: Addition of E098 FM to send multiple attachment in an email
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907387
* REFERENCE NO: ERP-5131
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-11-29
* DESCRIPTION:
* Use Cust Cond Grp 2 in stead of Cust Cond Grp 1
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-6302
* REFERENCE NO: ED2K912457
* DEVELOPER:    Sayantan Das (SAYANDAS)
* DATE:         28-JUN-2018
* DESCRIPTION:  Implement Direct Debit Mandate Logic (for F044)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-7730
* REFERENCE NO: ED2K913576
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO  :  ERPM-8994
* REFERENCE NO :  ED2K917342
* DEVELOPER    :  Lahiru Wathudura (LWATHUDURA)
* DATE         :  01/22/2020
* DESCRIPTION  :  Add Buyer and Seller tax Numbers
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913787
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40086
* REFERENCE NO: ED2K924584
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
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_RENEWAL_NOTIF_TOP
*&---------------------------------------------------------------------*

TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        vbap,     " Sales Document: Item Data
        toa_dara. " SAP ArchiveLink structure of a DARA line

**************************************************************
*                     TYPE DECLARATION                       *
**************************************************************
*******Global Structure Declaration for vbak
TYPES: BEGIN OF ty_vbak,
         vbeln    TYPE  vbeln,    "sales AND distribution document NUMBER
         angdt    TYPE  angdt_v,  "Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,    "SD document category
         auart    TYPE auart,     "SD document type
         waerk    TYPE  waerk,    "SD Document Currency
         knumv    TYPE  knumv,    "Number of the document condition
         kvgr1    TYPE  kvgr1,    "Customer Group   " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
         vkbur    TYPE  vkbur,    "Sales Office "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913787
         bukrs_vf TYPE  bukrs_vf, "Company code to be billed
       END OF ty_vbak,

********Global Structure Declaration for vbap
       BEGIN OF ty_vbap,
         vbeln  TYPE  vbeln_va, "Sales Document
         posnr  TYPE  posnr_va, "Sales Document Item
         matnr  TYPE  matnr,    "Material Number
*         arktx  TYPE  arktx,    "Short text for sales order item
         uepos  TYPE  posnr,  "Higher-level item in bill of material structures
         kwmeng TYPE  kwmeng, "Cumulative Order Quantity in Sales Units
         kzwi1  TYPE  kzwi1,  "Subtotal 1 from pricing procedure for condition
         kzwi2  TYPE  kzwi2,  "Subtotal 2 from pricing procedure for condition
         kzwi3  TYPE  kzwi3,  " Subtotal 3 from pricing procedure for condition
         kzwi4  TYPE  kzwi4,  "Subtotal 4 from pricing procedure for condition
         kzwi5  TYPE  kzwi5,  "Subtotal 5 from pricing procedure for condition
         kzwi6  TYPE  kzwi6,  "Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
         mvgr4  TYPE  mvgr4,  "Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
         " BOC: CR#7730 KKRAVURI20181012  ED2K913576
         mvgr5  TYPE  mvgr5,  " Material group 5
         " EOC: CR#7730 KKRAVURI20181012  ED2K913576
       END OF ty_vbap,
       tt_vbap TYPE TABLE OF ty_vbap INITIAL SIZE 0,
********Global Structure Declaration for vbpa
       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln, "Sales and Distribution Document Number
         posnr TYPE posnr, "Item number of the SD document
         parvw TYPE parvw, "Partner Function
         kunnr TYPE kunnr, "Customer Number
         adrnr TYPE adrnr, "Address
         land1 TYPE land1, "Country Key
       END OF ty_vbpa,


********Global Structure Declaration for vbfa
       BEGIN OF ty_vbfa,
         vbelv   TYPE vbeln_von,  "Preceding sales and distribution document
         posnv   TYPE posnr_von,  "Preceding item of an SD document
         vbeln   TYPE vbeln_nach, "Subsequent sales and distribution document
         posnn   TYPE posnr_nach, "Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,    "Document category of subsequent document
         vbtyp_v TYPE vbtyp_v,    "Document category of preceding SD document
       END OF ty_vbfa,

********Global Structure Declaration for vbkd
       BEGIN OF ty_vbkd,
         vbeln TYPE vbeln,   "Sales and Distribution Document Number
         posnr TYPE posnr,   "Item number of the SD document
         zterm TYPE  dzterm, "Terms of Payment Key
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
         zlsch TYPE schzw_bseg, " Payment Method
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
         bstkd TYPE bstkd, "Customer purchase order number
         ihrez TYPE ihrez, "Reference
* Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*        kdkg1 TYPE kdkg1,   "Customer group
         kdkg2 TYPE kdkg2, "Customer group
* End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
       END OF ty_vbkd,

*      MARA Structure
       BEGIN OF ty_mara,
         matnr           TYPE matnr, " Material Number
         mtart           TYPE mtart, " Material Type
         volum           TYPE volum, " Volume
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         ismmediatype    TYPE ismmediatype, " Media Type
         ismnrinyear     TYPE ismnrimjahr,  " Issue Number (in Year Number)
         ismyearnr       TYPE ismjahrgang,  " Media issue year number
       END OF ty_mara,
       tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,

       BEGIN OF ty_mara_vol,
         matnr       TYPE matnr,            " Material Number
         ismnrinyear TYPE ismnrimjahr,      " Issue Number (in Year Number)
         ismcopynr   TYPE ismheftnummer,    " Copy Number
       END OF ty_mara_vol,
       tt_mara_vol TYPE TABLE OF ty_mara_vol INITIAL SIZE 0,

********Global Structure Declaration for konv
       BEGIN OF ty_konv,
         knumv TYPE knumv,  "NUMBER OF the document CONDITION
         kposn TYPE kposn,  "CONDITION item NUMBER
         stunr TYPE stunr,  "STEP NUMBER
         zaehk TYPE dzaehk, "CONDITION counter
         kappl TYPE kappl,  "CHAR 2 0 Application
         kawrt TYPE kawrt,  "CONDITION BASE VALUE
         kbetr TYPE kbetr,  "Rate (condition amount or percentage)
         kwert TYPE kwert,  "CONDITION VALUE
         kinak TYPE kinak,  "CONDITION IS INACTIVE
         koaid TYPE koaid,  "CONDITION CLASS
       END OF ty_konv,
******Global Structure for ZQTC_RENWL_PLAN
       BEGIN OF ty_renwl_plan,
         vbeln      TYPE  vbeln_va,     "Sales Document
         posnr      TYPE posnr_va,      "Sales Document Item
         activity   TYPE zactivity_sub, "E095: Activity
         eadat      TYPE  eadat,        "Activity Date
         renwl_prof TYPE zrenwl_prof,   "Renewal Profile
         promo_code TYPE  zpromo,       "Promo code
         act_status TYPE zact_status,   "Activity Status
         ren_status TYPE zren_status,   "Renewal Status
       END OF ty_renwl_plan,
       BEGIN OF ty_veda_qt,
         vbeln   TYPE  vbeln_va,        " Sales Document
         vposn   TYPE  posnr_va,        " Sales Document Item
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         vlaufk  TYPE vlauk_veda, " Validity period category of contract
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vedat_veda, " Date on which cancellation request was received
       END OF ty_veda_qt,

*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
       BEGIN OF ty_tvlzt,
         spras  TYPE spras,        " Language Key
         vlaufk TYPE vlauk_veda,   " Validity period category of contract
         bezei  TYPE bezei20,      " Description
       END OF ty_tvlzt,

       BEGIN OF ty_iss_vol2,
         matnr TYPE matnr,         " Material Number
         stvol TYPE ismheftnummer, " Copy Number of Media Issue
         stiss TYPE ismnrimjahr,   " Media Issue
         noi   TYPE sytabix,       " Row Index of Internal Tables
       END OF  ty_iss_vol2,

       BEGIN OF ty_iss_vol3,
         matnr TYPE matnr,         " Material Number
         stvol TYPE ismheftnummer, " Copy Number of Media Issue
         stiss TYPE ismnrimjahr,   " Media Issue
         noi   TYPE sytabix,       " Row Index of Internal Tables
       END OF ty_iss_vol3,
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX

       BEGIN OF ty_jksenip,
         product       TYPE ismmatnr_product, "Media Product
         issue         TYPE ismmatnr_issue ,  "Media Issue
         shipping_date TYPE jshipping_date,   "Delivery Date
         status        TYPE jnipstatus,       "Status
       END OF ty_jksenip,
       BEGIN OF ty_cntrct_dat_qt,
         sign   TYPE sign,                    " Debit/Credit Sign (+/-)
         option TYPE option,                  " Option for ranges tables
         low    TYPE  vbdat_veda,             " Contract start date
         high   TYPE  vedat_veda,             " Date on which cancellation request was received
       END OF ty_cntrct_dat_qt,
       BEGIN OF ty_tax_dtls,
*        Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
         ismmediatype   TYPE ismmediatype,
*        End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911241
         media_type     TYPE char255,
         tax_percentage TYPE char16,   " Percentage of type CHAR16
         tax_amount     TYPE kzwi6,    " Subtotal 6 from pricing procedure for condition
         taxable_amt    TYPE kzwi1,    " Subtotal 1 from pricing procedure for condition
       END OF ty_tax_dtls,
       BEGIN OF ty_issue_sq,
         med_prod  TYPE ismrefmdprod,  "Higher-Level Media Product
         ismyearnr TYPE ismjahrgang,   "Media issue year number
         copynr    TYPE ismheftnummer, "Copy Number of Media Issue
         nrinyear  TYPE ismnrimjahr,   "Issue Number (in Year Number)
         mpg_lfdnr TYPE mpg_lfdnr,     "Sequence number of media issue within issue sequence
         volume    TYPE string,        "Volume
         issues    TYPE ismnrimjahr,   "Issues
       END OF ty_issue_sq,
       tt_issue_sq TYPE STANDARD TABLE OF ty_issue_sq INITIAL SIZE 0,
       BEGIN OF ty_body,
         tdline TYPE string,
       END OF ty_body,
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
       END OF ty_tax_data,

       tt_tax_data TYPE STANDARD TABLE OF ty_tax_data,
*************EOC by SRBOSE on 09/08/2017 for CR# 408****************
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
       BEGIN OF ty_zlsch_f044,
         sign   TYPE sign,       " Debit/Credit Sign (+/-)
         option TYPE opti,       " Option for ranking structure
         low    TYPE schzw_bseg, " Payment Method
         high   TYPE schzw_bseg, " Payment Method
       END OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
       BEGIN OF ty_constant,
         devid  TYPE zdevid,              "Development ID
         param1 TYPE  rvari_vnam,         "ABAP: Name of Variant Variable
         param2 TYPE  rvari_vnam,         "ABAP: Name of Variant Variable
         srno   TYPE  tvarv_numb,         "ABAP: Current selection number
         sign   TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
         opti   TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, "Upper Value of Selection Condition
       END OF ty_constant,

       tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,

       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,           " Material Number
         idcodetype TYPE ismidcodetype,   " Type of Identification Code
         identcode  TYPE ismidentcode,    " Identification Code
       END OF ty_jptidcdassign,

       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241

***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR:  ED2K911241
       BEGIN OF ty_stxh,
         tdname TYPE tdobname, "Name
       END OF ty_stxh,

       tt_std_text TYPE STANDARD TABLE OF ty_stxh.
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR:  ED2K911241


DATA: r_mtart_multi_bom        TYPE fip_t_mtart_range,
      r_mtart_combo_bom        TYPE fip_t_mtart_range,
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      r_vkorg_f044             TYPE TABLE OF range_vkorg, " Range table for VKORG
      r_zlsch_f044             TYPE TABLE OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
      r_kvgr1_f044             TYPE RANGE OF  salv_de_selopt_low,  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
*     Begin of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
      r_sanc_countries         TYPE temr_country,
*     End   of ADD:ERP-6599:WROY:03-Apr-2018:ED2K911781
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
      r_output_typ             TYPE RANGE OF salv_de_selopt_low,
      r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      v_tax_id                 TYPE salv_de_selopt_low,
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code       TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office    TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency   TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
      r_print_product          TYPE RANGE OF salv_de_selopt_low,
      r_digital_product        TYPE RANGE OF salv_de_selopt_low,
      li_print_media_product   TYPE TABLE OF ty_vbap,
      li_digital_media_product TYPE TABLE OF ty_vbap,
      lst_digital              TYPE ty_vbap,
      lst_print                TYPE ty_vbap.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924584
********************************************************************
*                         CONSTANTS
********************************************************************
      constants:
        c_st                    TYPE thead-tdid     VALUE 'ST',          "Text ID of text to be read
      c_zero                   TYPE char1 VALUE '0',                    " Zero of type CHAR1
      c_object                 TYPE thead-tdobject VALUE 'TEXT',        "Object of text to be read
      c_sign_i                 TYPE sign VALUE 'I',                     " Debit/Credit Sign (+/-)
      c_vbtyp_g                TYPE vbtyp VALUE 'G',                    " SD document category
      c_option_eq              TYPE option VALUE 'EQ',                  " Option for ranges tables
      c_option_bt              TYPE option VALUE 'BT',                  " Option for ranges tables
      c_stats_04               TYPE jnipstatus VALUE '04',              " IS-M: Status of Shipping Planning
      c_stats_10               TYPE jnipstatus VALUE '10',              " IS-M: Status of Shipping Planning
      c_amount_tm              TYPE tdsfname VALUE 'ZQTC_AMOUNT_F037',  " Smart Forms: Form Name
      c_taxes_tm               TYPE tdsfname VALUE 'ZQTC_TAXES_F035',   " Smart Forms: Form Name
      c_title_tm               TYPE tdsfname VALUE 'ZQTC_TITLE_F037',   " Smart Forms: Form Name
      c_print_tm               TYPE tdsfname VALUE 'ZQTC_PRINT_F037',   " Smart Forms: Form Name
      c_issues_tm              TYPE tdsfname VALUE 'ZQTC_ISSUES_F037',  " Smart Forms: Form Name
      c_digital_tm             TYPE tdsfname VALUE 'ZQTC_DIGITAL_F037', " Smart Forms: Form Name
      c_bill_to_tm             TYPE tdsfname VALUE 'ZQTC_BILL_TO_F035', " Smart Forms: Form Name
      c_ship_to_tm             TYPE tdsfname VALUE 'ZQTC_SHIP_TO_F035', " Smart Forms: Form Name
* BOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
      c_msgtyp_err             TYPE syst_msgty VALUE 'E',              " Error Message
      c_stxt_year              TYPE tdobname VALUE 'ZQTC_YEAR_F035',   " Name
      c_stxt_volume            TYPE tdobname VALUE 'ZQTC_VOLUME_F035', " Name
* EOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
      c_stxt_strt_year         TYPE tdobname VALUE 'ZQTC_F035_CNT_STRT_DATE', "CR-7841:SGUDA:30-Apr-2019:ED1K910099
      c_stxt_end_year          TYPE tdobname VALUE 'ZQTC_F035_CNT_END_DATE',  "CR-7841:SGUDA:30-Apr-2019:ED1K910
* BOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
*  c_initial_prc           TYPE char5    VALUE '0.000',             " Initial Percentage of type CHAR5
*  c_initial_amt           TYPE char4    VALUE '0.00',              " Initial_amt of type CHAR4
      c_initial_amt            TYPE kzwi1    VALUE '0.00', " Subtotal 1 from pricing procedure for condition
      c_initial_prc            TYPE p DECIMALS 3 VALUE '0.000', " Initial_prc of type Packed Number
* EOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
      c_discount_tm            TYPE tdsfname VALUE 'ZQTC_SUB_DISCOUNT_F035',       " Smart Forms: Form Name
      c_quantity_tm            TYPE tdsfname VALUE 'ZQTC_QTY_F037',                " Smart Forms: Form Name
      c_subtotal_tm            TYPE tdsfname VALUE 'ZQTC_SUB_TOTAL_F037',          " Smart Forms: Form Name
      c_subs_ref_tm            TYPE tdsfname VALUE 'ZQTC_SUB_REF_F037',            " Smart Forms: Form Name
      c_char_hyphen            TYPE char1    VALUE '-',                            " Char_hyphen of type CHAR1
      c_total_due_tm           TYPE tdsfname VALUE 'ZQTC_TOTAL_F035',              " Smart Forms: Form Name
      c_renew_now_tm           TYPE tdsfname VALUE 'ZQTC_RENEW_NOW_F037',          " Smart Forms: Form Name
      c_click_here_tm          TYPE tdsfname VALUE 'ZQTC_CLICK_HERE_F037',         " Smart Forms: Form Name
      c_start_issue_tm         TYPE tdsfname VALUE 'ZQTC_START_ISSUE_F037',        " Smart Forms: Form Name
      c_vol_issues_tm          TYPE tdobname VALUE 'ZQTC_F037_VOL_ISSUES',         " Name
      c_subs_total_tm          TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TOTAL_F037', " Smart Forms: Form Name
      c_renewal_num_tm         TYPE tdsfname VALUE 'ZQTC_RENEWAL_NUM_F037',        " Smart Forms: Form Name
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
*** BOC BY SAYANDAS for CR6307 on 03-AUG-2018
*  c_journal_tm            TYPE tdsfname VALUE 'ZQTC_JOURNAL_F035',
      c_journal_tm             TYPE tdsfname VALUE 'ZQTC_JOURNAL1_F035', " Smart Forms: Form Name
*** BOC BY SAYANDAS for CR6307 on 03-AUG-2018
      c_issn_tm                TYPE tdsfname VALUE 'ZQTC_ISSN_F035', " Smart Forms: Form Name
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
      c_renewal_date_tm        TYPE tdsfname VALUE 'ZQTC_RENEWAL_DATE_F037',       " Smart Forms: Form Name
      c_account_num_tm         TYPE tdsfname VALUE 'ZQTC_ACCOUNT_NUM_F037',        " Smart Forms: Form Name
      c_unit_price_tm          TYPE tdsfname VALUE 'ZQTC_UNIT_PRICE_F037',         " Smart Forms: Form Name
      c_reminder_tm            TYPE tdsfname VALUE 'ZQTC_REMAINDER_F035',          " Reminder
      c_prod_desc_tm           TYPE tdsfname VALUE 'ZQTC_PRODUCT_DES_F037',        " Smart Forms: Form Name
      c_char_disc_b            TYPE char20 VALUE '<b>&V_VALUE&</b>',               " Char_disc_b of type CHAR20
      c_char_link_b            TYPE char20 VALUE '<b>&V_LINK&</b>',                " Char_link_b of type CHAR20
      c_txtid_grun             TYPE tdid VALUE 'GRUN',                             " Text ID
      c_screen_webdyn          TYPE char1 VALUE 'W',                               " Webdynpro
      c_txtobj_material        TYPE tdobject VALUE 'MATERIAL',                     " Texts: Application Object
      c_char_matdesc_b         TYPE char25 VALUE '<b>&V_DESCRIPTION&</b>',         " Char_matdesc_b of type CHAR25
      c_semicoln_char          TYPE char1 VALUE ':',                               " Semicoln_char of type CHAR1
      c_mediatyp_dgtl          TYPE ismmediatype VALUE 'DI',                       " Media Type
      c_mediatyp_prnt          TYPE ismmediatype VALUE 'PH',                       " Media Type
      c_attachtyp_pdf          TYPE so_obj_tp    VALUE 'PDF',                      " Document Class for Attachment
      c_mediatyp_combo         TYPE ismmediatype VALUE 'MM',                       " Media Type
      c_cur_memb_exp_tm        TYPE tdsfname VALUE 'ZQTC_CUR_MEMB_EXP_F037',       " Smart Forms: Form Name
      c_cur_subs_exp_tm        TYPE tdsfname VALUE 'ZQTC_CUR_SUBS_EXP_F037',       " Smart Forms: Form Name
      c_membership_ref_tm      TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_REF_F037',     " Smart Forms: Form Name
      c_membership_type_tm     TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_TYPE_F037',    " Smart Forms: Form Name
      c_membership_digi_tm     TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_DIGI_F037',    " Smart Forms: Form Name
      c_membership_print_tm    TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_PRINT_F037',   " Smart Forms: Form Name
      c_membership_combo_tm    TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_COMBO_F037',   " Smart Forms: Form Name
      c_subscription_ref_tm    TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_REF_F037',   " Smart Forms: Form Name
      c_subscription_type_tm   TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TYPE_F037',  " Smart Forms: Form Name
      c_subscription_digi_tm   TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_DIGI_F037',  " Smart Forms: Form Name
      c_subscription_print_tm  TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_PRINT_F037', " Smart Forms: Form Name
      c_subscription_combo_tm  TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_COMBO_F037', " Smart Forms: Form Name
      c_med_type_digi_tm       TYPE tdsfname VALUE 'ZQTC_MED_TYPE_DIGI_F035',      " Smart Forms: Form Name
      c_med_type_print_tm      TYPE tdsfname VALUE 'ZQTC_MED_TYPE_PRINT_F035',     " Smart Forms: Form Name
      c_med_type_combo_tm      TYPE tdsfname VALUE 'ZQTC_MED_TYPE_COMBO_F035',     " Smart Forms: Form Name
      c_sub_email_subj_stxt    TYPE tdobname VALUE 'ZQTC_F035_EMAIL_SUBJ_SUBS',    " Email Subject Standard Text
      c_mem_email_subj_stxt    TYPE tdobname VALUE 'ZQTC_F037_EMAIL_SUBJ_MEMB',    " Email Subject Standard Text
      c_customer_service_tm    TYPE tdsfname VALUE 'ZQTC_CUS_SERVICE_F037',        " Customer Service Text Includes
      c_renewal_notice_tm      TYPE tdsfname VALUE 'ZQTC_RENEWAL_F035',            " Renewal Notice
      c_issues                 TYPE tdsfname VALUE 'ZQTC_ISSUES_F035',             " Smart Forms: Form Name
      c_total_due              TYPE tdsfname VALUE 'ZQTC_TOTAL_F035',              " Smart Forms: Form Name
*** BOC BY SAYANDAS for CR6307 on 03-AUG-2018
*  c_journal_txt           TYPE tdsfname VALUE 'ZQTC_TITLE_F035',             " Smart Forms: Form Name
      c_journal_txt            TYPE tdsfname VALUE 'ZQTC_TITLE1_F035', " Smart Forms: Form Name
*** EOC BY SAYANDAS for CR6307 on 03-AUG-2018
      c_comm_method            TYPE ad_comm VALUE 'LET',                   "(++ SRBOSE ON 13-DEC-2017)
      c_media_type             TYPE tdobname VALUE 'ZQTC_MEDIA_TYPE_F035', " Name
* BOC: CR#7730 KKRAVURI20181012  ED2K913576
      c_membership_number      TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX',  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181012  ED2K913576
      c_comma                  TYPE char1    VALUE ','.   "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
**************************************************************
*                  GLOBAL DATA DECLARATION                   *
**************************************************************
******Global variable declaration
DATA: v_retcode          TYPE sy-subrc,                                 " ABAP System Field: Return Code of ABAP Statements
      v_xstring          TYPE xstring,                                  " Logo Variable
      v_member           TYPE char1,                                    " Society and Society Member
      v_subscriber       TYPE char1,                                    " Subscription
      v_society_logo     TYPE xstring,                                  " Logo Variable
      i_vbak             TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0, " Internal Table for VBAK
      i_konv             TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,
      v_renewal_text     TYPE tdline,                                   " Text Line
      v_ind              TYPE xegld,                                    " Indicator: European Union Member
      v_tax              TYPE thead-tdname,                             " Name
      v_link             TYPE char90,                                   " Link of type CHAR90
      v_body             TYPE string,
      v_remit_to         TYPE thead-tdname,                             " SAPscript: Text Header:Name
      v_footer           TYPE thead-tdname,                             " SAPscript: Text Header:Name
      v_value            TYPE char4,                                    " Value of type CHAR4
      v_description      TYPE /bcv/fnd_string,                          " Product Description
      st_address         TYPE zstqtc_add_f035,                          " Global structure for address
      st_vbfa            TYPE ty_vbfa,                                  " Structure for vbfa table
      st_vbap            TYPE ty_vbap,                                  " Structure for VBAP
      st_final           TYPE zstqtc_head_f035,                         " Structure for item data
      st_vbco3           TYPE vbco3,                                    " Sales Doc.Access Methods: Key Fields: Document Printing
      st_formoutput      TYPE fpformoutput,                             " Form Output (PDF, PDL)
      st_vbkd            TYPE ty_vbkd,
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      st_formoutput_f044 TYPE fpformoutput, " Form Output (PDF, PDL)
      v_vkorg_f044       TYPE vkorg,        " Sales Organization
      v_zlsch_f044       TYPE schzw_bseg,   " Payment Method
      v_waerk_f044       TYPE waerk,        " SD Document Currency
      v_scenario_f044    TYPE char3,        " Scenario_f044 of type CHAR3
      v_ihrez_f044       TYPE ihrez,        " Your Reference
      v_adrnr_f044       TYPE adrnr,        " Address
      v_kunnr_f044       TYPE kunnr,        " Customer Number
      v_langu_f044       TYPE spras,        " Language Key
      v_xstring_f044     TYPE xstring,
      v_kvgr1_f044       TYPE kvgr1,        " Customer Group  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919423
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*      st_tvzbt        TYPE ty_tvzbt,
*      st_mara         TYPE ty_mara,
*      i_body          TYPE TABLE OF ty_body INITIAL SIZE 0,
      i_mara             TYPE tt_mara,
      i_vbap             TYPE TABLE OF ty_vbap,
      i_body             TYPE ldps_txt_tab, " Text Line
      i_credit_body      TYPE ldps_txt_tab, " Text Line
      i_terms            TYPE ldps_txt_tab, " Text Line
      i_id_body          TYPE ldps_txt_tab, " Text Line
      i_footer           TYPE ldps_txt_tab, " Text Line
      i_remit            TYPE ldps_txt_tab, " Text Line
      i_details          TYPE ldps_txt_tab, " Text Line
      i_values           TYPE ldps_txt_tab, " Text Line
      i_mara_vol         TYPE tt_mara_vol,
      i_jksenip          TYPE TABLE OF ty_jksenip,
      i_issue_seq        TYPE tt_issue_sq,
      i_content_hex      TYPE solix_tab,    "GBT: SOLIX as Table Type
* Begin of change by SRBOSE: 30-June-2017: #TR:  ED2K907341
      v_remit_to_tbt     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_credit_tbt       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_email_tbt        TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking1_tbt     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking2_tbt     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_cust_serv_tbt    TYPE thead-tdname, " SAPscript: Text Header:Name
      v_remit_to_scc     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_credit_scc       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_email_scc        TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking1_scc     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking2_scc     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_cust_serv_scc    TYPE thead-tdname, " SAPscript: Text Header:Name
      v_remit_to_scm     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_credit_scm       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_email_scm        TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking1_scm     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_banking2_scm     TYPE thead-tdname, " SAPscript: Text Header:Name
      v_cust_serv_scm    TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer_scm       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer_scc       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer_tbt       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_msg_txt          TYPE string,
      v_ent_screen       TYPE c,            " Screen of type Character "Added by MODUTTA
* End of change by SRBOSE: 30-June-2017: #TR:  ED2K907341
* BOC by PBANDLAPAL on 23-Aug-2017: TR# ED2K907532
      i_tax_dtls         TYPE TABLE OF ty_tax_dtls,
      v_send_email       TYPE ad_smtpadr,  " E-Mail Address
      v_tot_issue        TYPE ismnrimjahr, " Issue Number (in Year Number)
      v_mbexp_date       TYPE char15,      " Member Expiry date
      v_volume_iss       TYPE string,
      v_start_issue      TYPE ismnrimjahr, " Issue Number (in Year Number)
      v_digi_tax_init    TYPE char1,       " Digi_tax_init of type CHAR1
      v_print_tax_init   TYPE char1,       " Print_tax_init of type CHAR1
      v_total            TYPE kzwi1,       " Subtotal 1 from pricing procedure for condition
      v_total_c          TYPE char18,      " Total_c of type CHAR18
      v_sub_total        TYPE kzwi1,       " Subtotal 1 from pricing procedure for condition
      v_sub_total_c      TYPE char18,      " Sub_total_c of type CHAR18
      v_taxes            TYPE kzwi6,       " Subtotal 6 from pricing procedure for condition
      v_taxes_c          TYPE char18,      " Taxes_c of type CHAR18
      v_discount         TYPE kzwi5,       " Subtotal 5 from pricing procedure for condition
      v_discount_c       TYPE char18,      " Discount_c of type CHAR18
      v_scenario_tbt     TYPE char1,       " TBT Scenario
      v_scenario_scc     TYPE char1,       " Society Scenario(SCC)
      v_scenario_scm     TYPE char1,       " Society Member Scenario(SCM)
* EOC by PBANDLAPAL on 23-Aug-2017: TR# ED2K907532
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
      i_tax_data         TYPE tt_tax_data,
      v_seller_reg       TYPE tdline,       " Seller VAT Registration Number
      v_barcode          TYPE char100,       "++ Change by SRBOSE for CR_439
      v_logo_name        TYPE tdobname,     " Name
      v_compname         TYPE thead-tdname, " Name
*** BOC BY SAYANDAS for CR6307 on 03-JUL-2018
      v_issn             TYPE ismidentcode, " Identification Code
*** EOC BY SAYANDAS for CR6307 on 03-JUL-2018
*** BOC BY SAYANDAS on 23_Feb-2018 for Volume issue
      v_year             TYPE char12, "char4,  " Year of type CHAR4 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
      v_cntr_end         TYPE char12,   " Year of type CHAR4 "CR-7841:SGUDA:30-Apr-2019:ED1K910099
      v_issue_desc       TYPE tdline, " Text Line
*** EOC BY SAYANDAS on 23_Feb-2018 for Volume issue
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
      v_comm_method      TYPE ad_comm, "(++SRBOSE ON 13-DEC-2017)
      v_matnr_desc       TYPE string,
*** BOC BY SRBOSE on 06-FEB-2018 for CR-XXX
      i_tvlzt            TYPE STANDARD TABLE OF ty_tvlzt INITIAL SIZE 0,
      i_iss_vol2         TYPE STANDARD TABLE OF ty_iss_vol2 INITIAL SIZE 0,
      i_iss_vol3         TYPE STANDARD TABLE OF ty_iss_vol3 INITIAL SIZE 0,
*** EOC BY SRBOSE on 06-FEB-2018 for CR-XXX
      st_lines           TYPE tline. " SAPscript: Text Lines

DATA: i_vbpa    TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,
      i_tax_tab TYPE ztqtc_tax_f035,
      i_arktx   TYPE ztqtc_arktx_f035.

* Begin of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
DATA: i_constant      TYPE tt_constant,
      i_jptidcdassign TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
      v_idcodetype_1  TYPE ismidcodetype,    " Type of Identification Code
      v_idcodetype_2  TYPE ismidcodetype,    " Type of Identification Code
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241
***Begin of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911241
      i_std_text      TYPE tt_std_text.
***End of Change: SRBOSE on 15-Mar-2018: ERP_6599: TR: ED2K911241

**** Begin of Changes on 01/22/2020 for ERPM - 8994 with ED2K917342 ****
DATA : v_buyer_reg      TYPE tdline,       " Buyer VAT Registration Number
       i_tax_data_buyer TYPE tt_tax_data.  " Itab for buyer tax data
**** End of Changes on 01/22/2020 for ERPM - 8994 with ED2K917342 ****
