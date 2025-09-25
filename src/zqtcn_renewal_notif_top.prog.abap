*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_RENEWAL_NOTIF_F037
* REPORT DESCRIPTION:    Include for top declaration
* DEVELOPER:             Srabanti Bose (SRBOSE)
* CREATION DATE:         15-Dec-2016
* OBJECT ID:             F037
* TRANSPORT NUMBER(S):   ED2K903748
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904140
* REFERENCE NO:  ED2K904140
* DEVELOPER: Monalisa Dutta
* DATE:  04/25/2017
* DESCRIPTION: Adding the E098 F's to send multiple attachments
* in email
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-6302
* REFERENCE NO: ED2K912434
* DEVELOPER:    Sayantan Das (SAYANDAS)
* DATE:         28-JUN-2018
* DESCRIPTION:  Implement Direct Debit Mandate Logic (for F044)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-7756
* REFERENCE NO: ED2K913487
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         27-SEP-2018
* DESCRIPTION:  Change Body mail if VBAP-MVGR5 = 'DI'
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913658
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         24-OCTOBER-2018
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
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0397921
* REFERENCE NO: ED1K913501 / ED1K913503 / ED1K913633
* DEVELOPER:    GADEELA ARJUN (ARGADEELA)
* DATE:         05-OCTOBER-2021
* DESCRIPTION:  Fixed the issue of Society logo image on renewal pixilated and blurry
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913789
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
* REFERENCE NO: ED2K924578
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
        komk,     " Communication Header for Pricing
        vbap,     " Sales Document: Item Data
        rv61a,    " Input/Output Fields for SAPMV61A
        toa_dara. " SAP ArchiveLink structure of a DARA line
**************************************************************
*                     TYPE DECLARATION                       *
**************************************************************
*******Global Structure Declaration for vbak
TYPES: BEGIN OF ty_vbak,
         vbeln    TYPE  vbeln,    "sales AND distribution document NUMBER
         angdt    TYPE  angdt_v,  "Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,    "SD document category
         auart    TYPE  auart,    "SD document type
         waerk    TYPE  waerk,    "SD Document Currency
         knumv    TYPE  knumv,    "Number of the document condition
         kvgr1    TYPE  kvgr1,    "Customer group 1  "ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919415
         vkbur    TYPE  vkbur,    "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913787
         bukrs_vf TYPE  bukrs_vf, "Company code to be billed
       END OF ty_vbak,

********Global Structure Declaration for vbap
       BEGIN OF ty_vbap,
         vbeln  TYPE  vbeln_va, "Sales Document
         posnr  TYPE  posnr_va, "Sales Document Item
         matnr  TYPE  matnr,    "Material Number
         arktx  TYPE  arktx,    "Short text for sales order item
         uepos  TYPE uepos,     "  Higher-level item in bill of material structures
         kwmeng TYPE  kwmeng,   "Cumulative Order Quantity in Sales Units
         kzwi1  TYPE  kzwi1,    "Subtotal 1 from pricing procedure for condition
         kzwi2  TYPE  kzwi2,    "Subtotal 2 from pricing procedure for condition
         kzwi3  TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
         kzwi4  TYPE  kzwi4,    "Subtotal 4 from pricing procedure for condition
         kzwi5  TYPE  kzwi5,    "Subtotal 5 from pricing procedure for condition
         kzwi6  TYPE  kzwi6,    "Subtotal 6 from pricing procedure for condition
         mvgr4  TYPE  mvgr4,    "Material group 4 "OTCM-40086:SGUDA:15-SEP-2021:ED2K924578
         mvgr5  TYPE  mvgr5,
       END OF ty_vbap,
       tt_vbap TYPE TABLE OF ty_vbap INITIAL SIZE 0,
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
         vbeln       TYPE vbeln, "Sales and Distribution Document Number
         posnr       TYPE posnr, "Item number of the SD document
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
         zlsch       TYPE schzw_bseg, " Payment Method
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
         bstkd       TYPE bstkd, "Customer purchase order number
* Begin of change: PBANDLAPAL: 06-SEP-2017: ERP-4086 : ED2K908397
         ihrez       TYPE ihrez, "Subscription Reference
* End of change: PBANDLAPAL: 06-SEP-2017: ERP-4086 : ED2K908397
* Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*        kdkg1 TYPE kdkg1,                                           "Condition group 1
         kdkg2       TYPE kdkg2, "Condition group 2
* End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
         member_type TYPE vtext,        "Description
       END OF ty_vbkd,

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

*      MARA Structure
       BEGIN OF ty_mara,
         matnr           TYPE matnr, " Material Number
         mtart           TYPE mtart, " Material Type
         volum           TYPE volum, " Volume
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
* Begin of CHANGE:ERP-7756:SGUDA:27-SEP-2018:ED2K913487
         ismtitle        TYPE ismtitle,   " Title
* End of CHANGE:ERP-7756:SGUDA:27-SEP-2018:ED2K913487
         ismmediatype    TYPE ismmediatype,  " Media Type
         ismnrinyear     TYPE ismnrimjahr,   " Issue Number (in Year Number)
         ismyearnr       TYPE ismjahrgang,   " Media issue year number
         ismcopynr       TYPE ismheftnummer, " Copy Number of Media Issue " Copy Number of Media Issue
       END OF ty_mara,
       tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,

       BEGIN OF ty_mara_vol,
         matnr       TYPE matnr,             " Material Number
         ismnrinyear TYPE ismnrimjahr,       " Issue Number (in Year Number)
         ismcopynr   TYPE ismheftnummer,     " Copy Number
       END OF ty_mara_vol,
       tt_mara_vol TYPE TABLE OF ty_mara_vol INITIAL SIZE 0,

       BEGIN OF ty_veda_qt,
         vbeln   TYPE  vbeln_va,             " Sales Document
         vposn   TYPE  posnr_va,             " Sales Document Item
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
         vlaufk  TYPE vlauk_veda, " Validity period category of contract
*** EOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vedat_veda, " Date on which cancellation request was received
       END OF ty_veda_qt,
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
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
*** EOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
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

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
       BEGIN OF ty_zlsch_f044,
         sign   TYPE sign,       " Debit/Credit Sign (+/-)
         option TYPE opti,       " Option for ranking structure
         low    TYPE schzw_bseg, " Payment Method
         high   TYPE schzw_bseg, " Payment Method
       END OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

*       BEGIN OF ty_tax_dtls,
*         ismmediatype TYPE char255,      " Media Type
** BOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
**         kbetr        TYPE p DECIMALS 3, " Kbetr of type Packed Number
*         kbetr        TYPE char16,
** EOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
*         kzwi6        TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
*       END OF ty_tax_dtls,

       BEGIN OF ty_tax_dtls,
*        Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911272
         ismmediatype   TYPE ismmediatype,
*        End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911272
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
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
       END OF ty_tax_data,

       tt_tax_data TYPE STANDARD TABLE OF ty_tax_data,

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

       tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,

       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,                        " Material Number
         idcodetype TYPE ismidcodetype,                " Type of Identification Code
         identcode  TYPE ismidentcode,                 " Identification Code
       END OF ty_jptidcdassign,

       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
* End of change of CR#744 by MODUTTA on 08-MAR-2018:ED2K911241

***Begin of Change: MODUTTA on 15-Mar-2018: ERP_6599
       BEGIN OF ty_stxh,
         tdname TYPE tdobname, "Name
       END OF ty_stxh,

       tt_std_text TYPE STANDARD TABLE OF ty_stxh,
***End of Change: MODUTTA on 15-Mar-2018: ERP_6599

       BEGIN OF ty_society,
         society      TYPE zzpartner2,     " Business Partner 2 or Society number
         society_name TYPE zzsociety_name, " Society Name
       END OF ty_society,
       tt_society TYPE STANDARD TABLE OF ty_society INITIAL SIZE 0,

       BEGIN OF ty_mvgr5,
         sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE mvgr5,
         high TYPE mvgr5,
       END OF ty_mvgr5,
       tt_mvgr5 TYPE STANDARD TABLE OF ty_mvgr5 INITIAL SIZE 0.

DATA: r_mtart_multi_bom        TYPE fip_t_mtart_range,
      r_mtart_combo_bom        TYPE fip_t_mtart_range,
      r_idcodetype             TYPE rjksd_idcodetype_range_tab,
      v_idcodetype_1           TYPE ismidcodetype, " Type of Identification Code
      v_idcodetype_2           TYPE ismidcodetype, " Type of Identification Code
*     Begin of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
      r_sanc_countries         TYPE temr_country,
*     End   of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      r_vkorg_f044             TYPE TABLE OF range_vkorg, " Range table for VKORG
      r_zlsch_f044             TYPE TABLE OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
* BOC: CR#7730 KKRAVURI20181024  ED2K913658
      r_output_typ             TYPE RANGE OF salv_de_selopt_low,
      r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181024  ED2K913658
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code       TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office    TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency   TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
* Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919415
      r_kvgr1_f044             TYPE RANGE OF salv_de_selopt_low, " Range table for VKORG
* End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919415
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      v_tax_id                 TYPE salv_de_selopt_low,
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924578
      r_print_product          TYPE RANGE OF salv_de_selopt_low,
      r_digital_product        TYPE RANGE OF salv_de_selopt_low,
      li_print_media_product   TYPE TABLE OF ty_vbap,
      li_digital_media_product TYPE TABLE OF ty_vbap,
      lst_digital              TYPE ty_vbap,
      lst_print                TYPE ty_vbap,
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924578
      r_mvgr5_ma               TYPE tt_mvgr5,
      i_std_text               TYPE tt_std_text,
*************EOC by SRBOSE on 09/08/2017 for CR# 408****************
      i_society                TYPE tt_society.
**************************************************************
*                  GLOBAL DATA DECLARATION                   *
**************************************************************
******Global variable declaration
DATA: v_retcode          TYPE sy-subrc, " ABAP System Field: Return Code of ABAP Statements
      v_msg_txt          TYPE string,
      v_mat_desc         TYPE string,
      v_xstring          TYPE xstring,  " Logo Variable
      v_ent_retco        TYPE sy-subrc, " ABAP System Field: Return Code of ABAP Statements
*      v_preview        TYPE char1,                                      " To capture print preview.
      v_send_email       TYPE ad_smtpadr,                               " E-Mail Address
      v_ent_screen       TYPE c,                                        " Screen of type Character
      v_content_hex      TYPE so_raw255,                                " SAPoffice: Binary data, length 255
      v_society_logo     TYPE xstring,                                  " Logo Variable
      i_vbak             TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0, " Internal Table for VBAK
      v_kwert_tax        TYPE kwert,                                    " Variable for TAX
      v_surcharges       TYPE kwert,                                    " Variable for TAX
      v_kwert_total      TYPE kwert,                                    " Variable for Total
*      v_kwert_total1  TYPE char30,                                      " Variable for Total
      v_tax_amt          TYPE char15,       " Variable for Total
      v_footer           TYPE thead-tdname, " SAPscript: Text Header:Name
* Begin of change by SRBOSE: 30-June-2017: #TR:  ED2K906739
      st_vbpa            TYPE ty_vbpa,
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
      v_footer_tbt       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer_scc       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_footer_scm       TYPE thead-tdname, " SAPscript: Text Header:Name
      v_waerk            TYPE waerk,        "Local Variable for currency
      v_bukrs_vf         TYPE bukrs_vf,     "Local variable for company code
      v_kunnr_sp         TYPE kunnr,        " Customer Number
      v_kunnr_za         TYPE kunnr,        " Customer Number
* End of change by SRBOSE: 30-June-2017: #TR:  ED2K906739
      v_kawrt            TYPE kawrt,              " Variable for Surcharge
      v_kzwi6            TYPE kzwi6,              " Subtotal 6 from pricing procedure for condition
      st_address         TYPE zstqtc_add_f037,    " Global structure for address
      st_vbfa            TYPE ty_vbfa,            " Structure for vbfa table
      st_header          TYPE zstqtc_header_f037, " Structure for header Data
      st_vbap            TYPE ty_vbap,            " Structure for VBAP
      st_final           TYPE zstqtc_item_f037,   " Structure for item data
      st_vbco3           TYPE vbco3,              " Sales Doc.Access Methods: Key Fields: Document Printing
      st_formoutput      TYPE fpformoutput,       " Form Output (PDF, PDL)
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
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
      v_kvgr1_f044       TYPE kvgr1,        " Customer group 1  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919415
      st_vbkd            TYPE ty_vbkd, " Local workarea for vbkd table
* BOC by PBANDLAPAL on 23-Aug-2017: TR# ED2K907532
      v_tot_issue        TYPE ismnrimjahr, " Issue Number (in Year Number)
      v_mbexp_date       TYPE char15,      " Member Expiry date
      v_volume_iss       TYPE string,
      v_start_issue      TYPE ismnrimjahr, " Issue Number (in Year Number)
      v_digi_tax_init    TYPE char1,       " Digi_tax_init of type CHAR1
      v_print_tax_init   TYPE char1,       " Print_tax_init of type CHAR1
      v_scenario_tbt     TYPE char1,       " TBT Scenario
      v_scenario_scc     TYPE char1,       " Society Scenario(SCC)
      v_scenario_scm     TYPE char1,       " Society Member Scenario(SCM)
      i_mara_vol         TYPE tt_mara_vol,
      i_veda             TYPE TABLE OF ty_veda_qt,
      i_jksenip          TYPE TABLE OF ty_jksenip,
      i_tax_dtls         TYPE TABLE OF ty_tax_dtls,
      i_issue_seq        TYPE tt_issue_sq,
      i_constant         TYPE tt_constant,
* EOC by PBANDLAPAL on 23-Aug-2017: TR# ED2K907532
* BOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
      v_issue_desc       TYPE string,
* EOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
      v_year             TYPE char4, " Year of type CHAR4
      i_tvlzt            TYPE STANDARD TABLE OF ty_tvlzt INITIAL SIZE 0,
      i_iss_vol2         TYPE STANDARD TABLE OF ty_iss_vol2 INITIAL SIZE 0,
      i_iss_vol3         TYPE STANDARD TABLE OF ty_iss_vol3 INITIAL SIZE 0,
*** BOC BY SAYANDAS on 06-FEB-2018 for CR-XXX
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
      i_tax_data         TYPE tt_tax_data,
      i_konv             TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,
      i_final            TYPE zttqtc_item,
      i_final_olr        TYPE zttqtc_item,  "Added by MODUTTA on 04-Jun-2018 for CR# 6301 TR# ED2K912500
      i_final_email      TYPE zttqtc_item,
      v_seller_reg       TYPE tdline,       "/idt/seller_registration,
      v_barcode          TYPE char100,       " Barcode ++CR 439
      v_compname         TYPE thead-tdname, " Name
      i_bom_comp_tax     TYPE zttqtc_item.
*************EOC by SRBOSE on 09/08/2017 for CR# 408****************

* DATA: i_content_hex TYPE STANDARD TABLE OF XSTRING.      "GBT: SOLIX as Table Type
DATA: i_content_hex   TYPE solix_tab,                             "GBT: SOLIX as Table Type
      i_text_tab      TYPE STANDARD TABLE OF soli INITIAL SIZE 0, "GBT: SOLIX as Table Type
*      i_final       TYPE zttqtc_item,
      i_vbap          TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
      i_mara          TYPE tt_mara,
      i_jptidcdassign TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
      i_fieldcat      TYPE slis_t_fieldcat_alv,
      i_tax_tab       TYPE ztqtc_tax_f037.

"Containers
DATA:
  html_viewer    TYPE REF TO cl_gui_html_viewer,      " HTML Control Proxy Class
  main_container TYPE REF TO cl_gui_custom_container. " Container for Custom Controls in the Screen Area
DATA:
  i_header TYPE STANDARD TABLE OF w3head WITH HEADER LINE,   "Header
  i_fields TYPE STANDARD TABLE OF w3fields WITH HEADER LINE, "Fields
  i_html   TYPE STANDARD TABLE OF w3html,                    "Html
  st_headr TYPE w3head,                                      " Field directory for internal table display in HTML
  st_head  TYPE w3head.                                      " Field directory for internal table display in HTML
DATA v_kzwi1 TYPE kzwi1. " Subtotal 1 from pricing procedure for condition

TYPES:
  ty_it0002          TYPE pa0002,    " HR Master Record: Infotype 0002 (Personal Data)
  ty_it0008          TYPE pa0008,    " HR Master Record: Infotype 0008 (Basic Pay)
  ty_control_par     TYPE ssfctrlop, " Smart Forms: Control structure
  ty_output_options  TYPE ssfcompop, " SAP Smart Forms: Smart Composer (transfer) options
  ty_job_output_info TYPE ssfcrescl, " Smart Forms: Return value at end of form printing
  ty_otf_data        TYPE itcoo,     " OTF Structure
  ty_pdf             TYPE tline.     " SAPscript: Text Lines
DATA:
  wa_it0002          TYPE ty_it0002,
  wa_it0008          TYPE ty_it0008,
  wa_control_par     TYPE ty_control_par,
  wa_output_options  TYPE ty_output_options,
  wa_job_output_info TYPE ty_job_output_info,
  wa_pdf             TYPE ty_pdf.
DATA:
  it_it0002   TYPE STANDARD TABLE OF ty_it0002,
  it_it0008   TYPE STANDARD TABLE OF ty_it0008,
  it_otf_data TYPE STANDARD TABLE OF ty_otf_data,
  it_pdf      TYPE STANDARD TABLE OF ty_pdf,
  it_data     TYPE STANDARD TABLE OF x255. " Field 255 type x (raw) for stream interface
DATA:
  gv_fm_name      TYPE  rs38l_fnam,  " Name of Function Module
  gv_url          TYPE char255,      " Url of type CHAR255
  gv_content      TYPE xstring,
  okcode          TYPE sy-ucomm,     " ABAP System Field: PAI-Triggering Function Code
  gv_bin_filesize TYPE i,            " Bin_filesize of type Integers
  i_credit        TYPE ldps_txt_tab, " Text Line
  i_footer        TYPE ldps_txt_tab, " Text Line
  i_remit         TYPE ldps_txt_tab, " Text Line
  i_values        TYPE ldps_txt_tab, " Text Line
  i_details       TYPE ldps_txt_tab, " Text Line
  i_vbpa          TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,
  i_vbkd          TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0.
DATA: v_email_id TYPE tdline,       " Text Line
      i_email    TYPE ldps_txt_tab. " Text Line

DATA: v_total       TYPE kzwi1,        " Subtotal 1 from pricing procedure for condition
      v_total_c     TYPE char18,       " Total_c of type CHAR18
      v_sub_total   TYPE kzwi1,        " Subtotal 1 from pricing procedure for condition
      v_sub_total_c TYPE char18,       " Sub_total_c of type CHAR18
      v_taxes       TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
      v_taxes_c     TYPE char18,       " Taxes_c of type CHAR18
      v_discount    TYPE kzwi5,        " Subtotal 5 from pricing procedure for condition
      v_discount_c  TYPE char18,       " Discount_c of type CHAR18
      v_tax         TYPE thead-tdname, " Name
      v_ind         TYPE xegld,        " Indicator: European Union Member?
      v_comm_method TYPE ad_comm,      "(++ srbose ON 13-DEC-2017)
      v_start_year  TYPE char4,
* Begin of change by ARGADEELA: 05-Oct-2021: ED1K913501
      v_logo_name   TYPE char100.
* End of change by ARGADEELA: 05-Oct-2021: ED1K913501

CONSTANTS: c_st                    TYPE thead-tdid VALUE 'ST',              " Text ID of text to be read
           c_zero                  TYPE char1 VALUE '0',                    " Zero of type CHAR1
           c_object                TYPE thead-tdobject VALUE 'TEXT',        " Object of text to be read
           c_tax_tm                TYPE tdsfname VALUE 'ZQTC_TAXES_F037',   " Smart Forms: Form Name
           c_title_tm              TYPE tdsfname VALUE 'ZQTC_TITLE_F037',   " Smart Forms: Form Name
           c_print_tm              TYPE tdsfname VALUE 'ZQTC_PRINT_F037',   " Smart Forms: Form Name
           c_sign_i                TYPE sign VALUE 'I',                     " Debit/Credit Sign (+/-)
           c_option_eq             TYPE option VALUE 'EQ',                  " Option for ranges tables
           c_option_bt             TYPE option VALUE 'BT',                  " Option for ranges tables
           c_stats_04              TYPE jnipstatus VALUE '04',              " IS-M: Status of Shipping Planning
           c_stats_10              TYPE jnipstatus VALUE '10',              " IS-M: Status of Shipping Planning
           c_amount_tm             TYPE tdsfname VALUE 'ZQTC_AMOUNT_F037',  " Smart Forms: Form Name
           c_issues_tm             TYPE tdsfname VALUE 'ZQTC_ISSUES_F037',  " Smart Forms: Form Name
           c_taxable_tm            TYPE tdsfname VALUE 'ZQTC_TAXABLE_F037', " Smart Forms: Form Name
           c_bill_to_tm            TYPE tdsfname VALUE 'ZQTC_BILL_TO_F037', " Smart Forms: Form Name
           c_ship_to_tm            TYPE tdsfname VALUE 'ZQTC_SHIP_TO_F037', " Smart Forms: Form Name
           c_digital_tm            TYPE tdsfname VALUE 'ZQTC_DIGITAL_F037', " Smart Forms: Form Name
           c_society_tm            TYPE tdsfname VALUE 'ZQTC_SOCIETY_F037', " Smart Forms: Form Name
* BOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
           c_msgtyp_err            TYPE syst_msgty VALUE 'E',              " ABAP System Field: Message Type
           c_stxt_year             TYPE tdobname VALUE 'ZQTC_YEAR_F035',   " Name
           c_stxt_volume           TYPE tdobname VALUE 'ZQTC_VOLUME_F035', " Name
* EOI by PBANDLAPAL on 23-Feb-2018 for CR#743: ED2K911033
* BOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
*      c_initial_amt           TYPE char4    VALUE '0.00',
*      c_initial_prc           TYPE char5    VALUE '0.000',
           c_initial_amt           TYPE kzwi1    VALUE '0.00', " Subtotal 1 from pricing procedure for condition
           c_initial_prc           TYPE p DECIMALS 3 VALUE '0.000', " Initial_prc of type Packed Number
* EOC by PBANDLAPAL on 25-Jan-2018 for ERP-6188: ED2K910514
           c_char_hyphen           TYPE char1    VALUE '-',                            " Char_hyphen of type CHAR1
           c_discount_tm           TYPE tdsfname VALUE 'ZQTC_DISCOUNT_F037',           " Smart Forms: Form Name
           c_quantity_tm           TYPE tdsfname VALUE 'ZQTC_QTY_F037',                " Smart Forms: Form Name
           c_subtotal_tm           TYPE tdsfname VALUE 'ZQTC_SUB_TOTAL_F037',          " Smart Forms: Form Name
           c_subs_ref_tm           TYPE tdsfname VALUE 'ZQTC_SUB_REF_F037',            " Smart Forms: Form Name
           c_total_due_tm          TYPE tdsfname VALUE 'ZQTC_TOTAL_F035',              " Smart Forms: Form Name
           c_renew_now_tm          TYPE tdsfname VALUE 'ZQTC_RENEW_NOW_F037',          " Smart Forms: Form Name
           c_click_here_tm         TYPE tdsfname VALUE 'ZQTC_CLICK_HERE_F037',         " Smart Forms: Form Name
           c_subs_total_tm         TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TOTAL_F037', " Smart Forms: Form Name
           c_start_issue_tm        TYPE tdsfname VALUE 'ZQTC_START_ISSUE_F037',        " Smart Forms: Form Name
           c_vol_issues_tm         TYPE tdobname VALUE 'ZQTC_F037_VOL_ISSUES',         " Name
           c_discount_hdr_tm       TYPE tdsfname VALUE 'ZQTC_DISCOUNT_HDR_F037',       " Smart Forms: Form Name
           c_renewal_num_tm        TYPE tdsfname VALUE 'ZQTC_RENEWAL_NUM_F037',        " Smart Forms: Form Name
           c_renewal_date_tm       TYPE tdsfname VALUE 'ZQTC_RENEWAL_DATE_F037',       " Smart Forms: Form Name
           c_account_num_tm        TYPE tdsfname VALUE 'ZQTC_ACCOUNT_NUM_F037',        " Smart Forms: Form Name
           c_unit_price_tm         TYPE tdsfname VALUE 'ZQTC_UNIT_PRICE_F037',         " Smart Forms: Form Name
           c_reminder_tm           TYPE tdsfname VALUE 'ZQTC_NOTICE_F037',             " Reminder
           c_char_matdesc          TYPE char20 VALUE '<b>&V_MAT_DESC&</b>',            " Char_matdesc of type CHAR20
           c_prod_desc_tm          TYPE tdsfname VALUE 'ZQTC_PRODUCT_DES_F037',        " Smart Forms: Form Name
           c_txtid_grun            TYPE tdid VALUE 'GRUN',                             " Text ID
           c_txtobj_material       TYPE tdobject VALUE 'MATERIAL',                     " Texts: Application Object
           c_semicoln_char         TYPE char1 VALUE ':',                               " Semicoln_char of type CHAR1
           c_mediatyp_dgtl         TYPE ismmediatype VALUE 'DI',                       " Media Type
           c_mediatyp_prnt         TYPE ismmediatype VALUE 'PH',                       " Media Type
           c_mediatyp_combo        TYPE ismmediatype VALUE 'MM',                       " Media Type
           c_cur_memb_exp_tm       TYPE tdsfname VALUE 'ZQTC_CUR_MEMB_EXP_F037',       " Smart Forms: Form Name
           c_cur_subs_exp_tm       TYPE tdsfname VALUE 'ZQTC_CUR_SUBS_EXP_F037',       " Smart Forms: Form Name
           c_membership_ref_tm     TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_REF_F037',     " Smart Forms: Form Name
           c_membership_type_tm    TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_TYPE_F037',    " Smart Forms: Form Name
           c_membership_digi_tm    TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_DIGI_F037',    " Smart Forms: Form Name
           c_membership_print_tm   TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_PRINT_F037',   " Smart Forms: Form Name
           c_membership_combo_tm   TYPE tdsfname VALUE 'ZQTC_MEMBERSHIP_COMBO_F037',   " Smart Forms: Form Name
           c_subscription_ref_tm   TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_REF_F037',   " Smart Forms: Form Name
           c_subscription_type_tm  TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TYPE_F037',  " Smart Forms: Form Name
           c_subscription_digi_tm  TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_DIGI_F037',  " Smart Forms: Form Name
           c_subscription_print_tm TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_PRINT_F037', " Smart Forms: Form Name
           c_subscription_combo_tm TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_COMBO_F037', " Smart Forms: Form Name
*                       Begin of ADD:ERP-6687:WROY:08-Feb-2018:ED2K911234
           c_med_type_digi_tm      TYPE tdsfname VALUE 'ZQTC_MED_TYPE_DIGI_F037',  " Smart Forms: Form Name
           c_med_type_print_tm     TYPE tdsfname VALUE 'ZQTC_MED_TYPE_PRINT_F037', " Smart Forms: Form Name
           c_med_type_combo_tm     TYPE tdsfname VALUE 'ZQTC_MED_TYPE_COMBO_F037', " Smart Forms: Form Name
*                       End   of ADD:ERP-6687:WROY:08-Feb-2018:ED2K911234
           c_sub_email_subj_stxt   TYPE tdobname VALUE 'ZQTC_F037_EMAIL_SUBJ_SUBS', " Email Subject Standard Text
           c_mem_email_subj_stxt   TYPE tdobname VALUE 'ZQTC_F037_EMAIL_SUBJ_MEMB', " Email Subject Standard Text
           c_customer_service_tm   TYPE tdsfname VALUE 'ZQTC_CUS_SERVICE_F037',     " Customer Service Text Includes
           c_renewal_notice_tm     TYPE tdsfname VALUE 'ZQTC_SUB_RENEWAL_F037',     " Renewal Notice
           c_comm_method           TYPE ad_comm VALUE 'LET',                        "(++ by SRBOSE on 13-DEC-2017)
* BOC: CR#7730 KKRAVURI20181024  ED2K913658
           c_membership_number     TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX'.  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181024  ED2K913658

**** Begin of Changes on 01/22/2020 for ERPM-8994 with ED2K917342 ****
DATA : v_buyer_reg      TYPE tdline,       " Buyer VAT Registration Number
       i_tax_data_buyer TYPE tt_tax_data.  " Itab for buyer tax data

DATA : v_your_id TYPE tdline,       " Buyer VAT (Your Tax ID)
       v_our_id  TYPE tdline.       " Seller VAT (our Tax ID)
**** End of Changes on 01/22/2020 for ERPM-8994 with ED2K917342 ****
