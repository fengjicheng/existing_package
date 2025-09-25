*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCN_CONSOLIDATED_NOTICE_TOP
* PROGRAM DESCRIPTION:Consolidated Renewal Notice
* DEVELOPER:          SAYANDAS (Sayantan Das)
* CREATION DATE:      08-MAY-2018
* OBJECT ID:          F043
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913401
* REFERENCE NO: ERP-7747
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         19-SEP-2018
* DESCRIPTION:  Additional Direct Debit Form is included
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-7730
* REFERENCE NO: ED2K913582
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-47818
* REFERENCE NO: ED1K913605
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         10/21/2021
* DESCRIPTION:   Indian Agent Processing
* 1) Change email address to indiaagent@wiley.com (Top Left Box on the Form)
* 2) Credit Card Option removed.
* 3) Change Wire Transfer Details as shown as below.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913793
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40064
* REFERENCE NO: ED2K924586
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         09/17/2021
* DESCRIPTION:
* 1) if Material group4 (VBRP- MVGR4= BK- eBooks, JU-eJournal, BU-eBundle
*    then print the media type as Digital
* 2) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue then print the media type as Print
* 3) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue, BK- eBooks, JU-eJournal, BU-eBundle then print
*    the media type as Print & digital.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONSOLIDATED_NOTICE_TOP
*&---------------------------------------------------------------------*
TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        toa_dara. " SAP ArchiveLink structure of a DARA line

* Type declaration
TYPES: BEGIN OF ty_order,
         vbeln TYPE vbeln_va, " Sales Document
       END OF  ty_order.

TYPES: BEGIN OF ty_vbak,
         vbeln    TYPE  vbeln,    "sales AND distribution document NUMBER
         angdt    TYPE  angdt_v,  "Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,    "SD document category
         auart    TYPE  auart,    "SD document type
         waerk    TYPE  waerk,    "SD Document Currency
*         Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         vkorg    TYPE vkorg, "Sales Org
*         End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         knumv    TYPE  knumv,    "Number of the document condition
         kunnr    TYPE  kunnr,    " Customer Number
         kvgr1    TYPE  kvgr1,    " Customer Group 1 " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
         vkbur    TYPE  vkbur,    "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913787
         bukrs_vf TYPE  bukrs_vf, "Company code to be billed
       END OF ty_vbak,

       BEGIN OF ty_vbap,
         vbeln  TYPE  vbeln_va, "Sales Document
         posnr  TYPE  posnr_va, "Sales Document Item
         matnr  TYPE  matnr,    "Material Number
         arktx  TYPE  arktx,    "Short text for sales order item
         uepos  TYPE  uepos,    "  Higher-level item in bill of material structures
         kwmeng TYPE  kwmeng,   "Cumulative Order Quantity in Sales Units
         kzwi1  TYPE  kzwi1,    "Subtotal 1 from pricing procedure for condition
         kzwi2  TYPE  kzwi2,    "Subtotal 2 from pricing procedure for condition
         kzwi3  TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
         kzwi4  TYPE  kzwi4,    "Subtotal 4 from pricing procedure for condition
         kzwi5  TYPE  kzwi5,    "Subtotal 5 from pricing procedure for condition
         kzwi6  TYPE  kzwi6,    "Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
         mvgr4  TYPE  mvgr4,    "Material Group 4
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
         " BOC: CR#7730 KKRAVURI20181012  ED2K913582
         mvgr5  TYPE  mvgr5,  " Material group 5
         " EOC: CR#7730 KKRAVURI20181012  ED2K913582
       END OF ty_vbap,

********Global Structure Declaration for vbpa
       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln, "Sales and Distribution Document Number
         posnr TYPE posnr, "Item number of the SD document
         parvw TYPE parvw, "Partner Function
         kunnr TYPE kunnr, "Customer Number
         adrnr TYPE adrnr, "Address
         land1 TYPE land1, "Country Key
       END OF ty_vbpa,

*** Global structure for Combination
       BEGIN OF ty_combination,
         ship_to TYPE kunnr, " Customer Number
         bill_to TYPE kunnr, " Customer Number
         vkorg   TYPE vkorg, " Sales Organization
         waerk   TYPE waerk, " SD Document Currency
       END OF   ty_combination,

*** Global structure for Combination Vbeln
       BEGIN OF ty_comb_final,
         kschl   TYPE sna_kschl, " Message type
         nacha   TYPE na_nacha,  " Message transmission medium
         ship_to TYPE kunnr,     " Customer Number
         bill_to TYPE kunnr,     " Customer Number
         vkorg   TYPE vkorg,     " Sales Organization
         waerk   TYPE waerk,     " SD Document Currency
         vbeln   TYPE  vbeln_va, "Sales Document
         hl_itm  TYPE  uepos,    "  Higher-level item in bill of material structures
         posnr   TYPE  posnr_va, "Sales Document Item
         matnr   TYPE  matnr,    "Material Number
         kdkg2   TYPE  kdkg2,    " Customer condition group 2
         arktx   TYPE  arktx,    "Short text for sales order item
         uepos   TYPE  uepos,    "  Higher-level item in bill of material structures
         kwmeng  TYPE  kwmeng,   "Cumulative Order Quantity in Sales Units
         kzwi1   TYPE  kzwi1,    "Subtotal 1 from pricing procedure for condition
         kzwi2   TYPE  kzwi2,    "Subtotal 2 from pricing procedure for condition
         kzwi3   TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
         kzwi4   TYPE  kzwi4,    "Subtotal 4 from pricing procedure for condition
         kzwi5   TYPE  kzwi5,    "Subtotal 5 from pricing procedure for condition
         kzwi6   TYPE  kzwi6,    "Subtotal 6 from pricing procedure for condition
         knumv   TYPE  knumv,    " Number of the document condition
       END OF   ty_comb_final,

*       Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
       BEGIN OF ty_zlsch_f044,
         sign   TYPE sign,       " Debit/Credit Sign (+/-)
         option TYPE opti,       " Option for ranking structure
         low    TYPE schzw_bseg, " Payment Method
         high   TYPE schzw_bseg, " Payment Method
       END OF ty_zlsch_f044,
*       End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401

*** Global Structure for Constant Table
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

*      MARA Structure
       BEGIN OF ty_mara,
         matnr           TYPE matnr,          " Material Number
         mtart           TYPE mtart,          " Material Type
         volum           TYPE volum,          " Volume
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
         ismmediatype    TYPE ismmediatype,   " Media Type
         ismnrinyear     TYPE ismnrimjahr,    " Issue Number (in Year Number)
         ismyearnr       TYPE ismjahrgang,    " Media issue year number
         ismcopynr       TYPE ismheftnummer,  " Copy Number of Media Issue " Copy Number of Media Issue
       END OF ty_mara,

* JPTIDCDASSIGN Structure
       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,         " Material Number
         idcodetype TYPE ismidcodetype, " Type of Identification Code
         identcode  TYPE ismidentcode,  " Identification Code
       END OF ty_jptidcdassign,

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
         vbeln TYPE vbeln, "Sales and Distribution Document Number
         posnr TYPE posnr, "Item number of the SD document
         bstkd TYPE bstkd, "Customer purchase order number
         ihrez TYPE ihrez, "Subscription Reference
         kdkg2 TYPE kdkg2, "Condition group 2
*         Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         zlsch TYPE schzw_bseg, "Payment Method
*         End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
         bsark TYPE bsark, "Customer purchase order type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
       END OF ty_vbkd,

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

*** Global Structure for Renewal Plan
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

*** Global Structure for Tax Data
       BEGIN OF ty_tax_data,
         document        TYPE  /idt/doc_number,        " Document Number
         doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
         buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
         seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
       END OF ty_tax_data,

*** Global Structure for STXH
       BEGIN OF ty_stxh,
         tdname  TYPE tdobname, "Name
         tdspras TYPE spras,    " Language Key
       END OF ty_stxh,

*** Global Structure for Tax Details
       BEGIN OF ty_tax_dtls,
         ismmediatype   TYPE ismmediatype,
         media_type     TYPE char255,
         tax_percentage TYPE char16,            " Percentage of type CHAR16
         tax_amount     TYPE kzwi6,             " Subtotal 6 from pricing procedure for condition
         taxable_amt    TYPE kzwi1,             " Subtotal 1 from pricing procedure for condition
       END OF ty_tax_dtls,

       BEGIN OF ty_issue_sq,
         med_prod  TYPE ismrefmdprod,           "Higher-Level Media Product
         ismyearnr TYPE ismjahrgang,            "Media issue year number
         copynr    TYPE ismheftnummer,          "Copy Number of Media Issue
         nrinyear  TYPE ismnrimjahr,            "Issue Number (in Year Number)
         mpg_lfdnr TYPE mpg_lfdnr,              "Sequence number of media issue within issue sequence
         volume    TYPE string,                 "Volume
         issues    TYPE ismnrimjahr,            "Issues
       END OF ty_issue_sq,

       BEGIN OF ty_veda_qt,
         vbeln   TYPE  vbeln_va,                " Sales Document
         vposn   TYPE  posnr_va,                " Sales Document Item
         vlaufk  TYPE vlauk_veda,               " Validity period category of contract
         vbegdat TYPE vbdat_veda,               " Contract start date
         venddat TYPE vedat_veda,               " Date on which cancellation request was received
       END OF ty_veda_qt,

       BEGIN OF ty_tvlzt,
         spras  TYPE spras,                     " Language Key
         vlaufk TYPE vlauk_veda,                " Validity period category of contract
         bezei  TYPE bezei20,                   " Description
       END OF ty_tvlzt,

       BEGIN OF ty_iss_vol2,
         matnr TYPE matnr,                      " Material Number
         stvol TYPE ismheftnummer,              " Copy Number of Media Issue
         stiss TYPE ismnrimjahr,                " Media Issue
         noi   TYPE sytabix,                    " Row Index of Internal Tables
       END OF  ty_iss_vol2,

       BEGIN OF ty_iss_vol3,
         matnr TYPE matnr,                      " Material Number
         stvol TYPE ismheftnummer,              " Copy Number of Media Issue
         stiss TYPE ismnrimjahr,                " Media Issue
         noi   TYPE sytabix,                    " Row Index of Internal Tables
       END OF ty_iss_vol3,

       BEGIN OF ty_jksenip,
         product         TYPE ismmatnr_product, "Media Product
         issue           TYPE ismmatnr_issue ,  "Media Issue
         shipping_date   TYPE jshipping_date,   "Delivery Date
         sub_valid_from  TYPE jsub_valid_from,  " IS-M: Subscription Valid From
         sub_valid_until TYPE jsub_valid_until, " IS-M: Subscription Valid To
         status          TYPE jnipstatus,       "Status
       END OF ty_jksenip,

       BEGIN OF ty_cntrct_dat_qt,
         sign   TYPE sign,                      " Debit/Credit Sign (+/-)
         option TYPE option,                    " Option for ranges tables
         low    TYPE  vbdat_veda,               " Contract start date
         high   TYPE  vedat_veda,               " Date on which cancellation request was received
       END OF ty_cntrct_dat_qt,

       BEGIN OF ty_mara_vol,
         matnr       TYPE matnr,                " Material Number
         ismnrinyear TYPE ismnrimjahr,          " Issue Number (in Year Number)
         ismcopynr   TYPE ismheftnummer,        " Copy Number
       END OF ty_mara_vol,

       BEGIN OF ty_kna1,
         kunnr TYPE kunnr,                      " Customer Number
         spras TYPE spras,                      " Language Key
       END OF ty_kna1,

       tt_vbkd TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,

       BEGIN OF ty_output,
         status  TYPE char4,                    " Status of type CHAR4
         kschl   TYPE sna_kschl,                " Message type
         ship_to TYPE kunnr,                    " Customer Number
         bill_to TYPE kunnr,                    " Customer Number
         vkorg   TYPE vkorg,                    " Sales Organization
         waerk   TYPE waerk,                    " SD Document Currency
         vbeln   TYPE vbeln_va,                 "Sales Document
         message TYPE bapi_msg,                 " Message Text
       END OF ty_output,
       tt_output TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0.

* Table type declaration
TYPES: tt_vbap          TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
       tt_kna1          TYPE STANDARD TABLE OF ty_kna1 INITIAL SIZE 0,
       tt_mara          TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
       tt_tax_data      TYPE STANDARD TABLE OF ty_tax_data INITIAL SIZE 0,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
       tt_issue_sq      TYPE STANDARD TABLE OF ty_issue_sq INITIAL SIZE 0,
       tt_std_text      TYPE STANDARD TABLE OF ty_stxh INITIAL SIZE 0,
       tt_constant      TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
       tt_mara_vol      TYPE TABLE OF ty_mara_vol INITIAL SIZE 0,
       tt_vbpa          TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0.

* Global Table Declaration
DATA: i_output        TYPE tt_output,
      i_vbap          TYPE tt_vbap,
      i_vbpa          TYPE tt_vbpa,
      i_kna1          TYPE tt_kna1,
      i_vbpa2         TYPE tt_vbpa,
      i_vbkd          TYPE tt_vbkd,
      i_vbeln         TYPE tt_vbeln,                                            " Sales and Distribution Document Number
      i_vbco3         TYPE STANDARD TABLE OF vbco3 INITIAL SIZE 0,              " Sales Doc.Access Methods: Key Fields: Document Printing
      i_address       TYPE STANDARD TABLE OF zstqtc_add_f037 INITIAL SIZE 0,    " Structure for address node
      i_header        TYPE STANDARD TABLE OF zstqtc_header_f043 INITIAL SIZE 0, " Header structure for Consolidated Renewal Notification
      i_order         TYPE STANDARD TABLE OF ty_order INITIAL SIZE 0,
      i_combination   TYPE STANDARD TABLE OF ty_combination INITIAL SIZE 0,
      i_comb_final    TYPE STANDARD TABLE OF ty_comb_final  INITIAL SIZE 0,
      i_konv          TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,
      i_tvlzt         TYPE STANDARD TABLE OF ty_tvlzt INITIAL SIZE 0,
      i_veda          TYPE TABLE OF ty_veda_qt,
      i_input         TYPE ztqtc_supplement_ret_input,
      st_address      TYPE zstqtc_add_f037,                                     " Structure for address node
      st_header       TYPE zstqtc_header_f043,                                  " Header structure for Consolidated Renewal Notification
      st_formoutput   TYPE fpformoutput,                                        " Form Output (PDF, PDL)
      st_vbak         TYPE ty_vbak,                                             " Form Output (PDF, PDL)
      st_vbap         TYPE ty_vbap,
      st_vbkd         TYPE ty_vbkd,
      i_final         TYPE zttqtc_item,
      i_final_email   TYPE zttqtc_item,
      i_tax_data      TYPE tt_tax_data,
      i_issue_seq     TYPE tt_issue_sq,
      i_std_text      TYPE tt_std_text,
      i_constant      TYPE tt_constant,
      i_mara          TYPE tt_mara,
      st_fieldcat     TYPE slis_fieldcat_alv,                                   "Workarea for Fieldcat
      i_fieldcat      TYPE slis_t_fieldcat_alv,                                 "Internal table for Fieldcat
      i_jksenip       TYPE STANDARD TABLE OF ty_jksenip INITIAL SIZE 0,
      i_mara_vol      TYPE tt_mara_vol,
      i_tax_tab       TYPE ztqtc_tax_f037,
      i_jptidcdassign TYPE tt_jptidcdassign,                                    " IT for JPTIDCDASSIGN
      i_vbfa          TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,
      i_bom_comp_tax  TYPE zttqtc_item,
      i_iss_vol2      TYPE STANDARD TABLE OF ty_iss_vol2 INITIAL SIZE 0,
      i_iss_vol3      TYPE STANDARD TABLE OF ty_iss_vol3 INITIAL SIZE 0,
      v_xstring       TYPE xstring.

* Global Data Declaration
DATA: v_screen_display         TYPE char1,         " Screen_display of type CHAR1
      r_mtart_multi_bom        TYPE fip_t_mtart_range,
      r_mtart_combo_bom        TYPE fip_t_mtart_range,
      r_idcodetype             TYPE rjksd_idcodetype_range_tab,
      v_idcodetype_1           TYPE ismidcodetype, " Type of Identification Code
      v_idcodetype_2           TYPE ismidcodetype, " Type of Identification Code
      v_waerk                  TYPE waerk,         " SD Document Currency
      v_compname               TYPE thead-tdname,  " Name
      v_seller_reg             TYPE tdline,        "/idt/seller_registration,
*      v_tax             TYPE thead-tdname,  " Name
      v_mat_desc               TYPE string,
      v_language               TYPE spras,      " Language Key
      v_mbexp_date             TYPE char15,     " Member Expiry date
      v_send_email             TYPE ad_smtpadr, " E-Mail Address
      v_msg_txt                TYPE string,
      v_email_flg              TYPE xfeld,      " Checkbox
      r_sanc_countries         TYPE temr_country,
*     Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
      r_vkorg_f044             TYPE TABLE OF range_vkorg, " Range table for VKORG
      r_zlsch_f044             TYPE TABLE OF ty_zlsch_f044,
*     End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
      r_kvgr1_f044             TYPE RANGE OF salv_de_selopt_low,  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
* BOC: CR#7730 KKRAVURI20181012  ED2K913582
      r_output_typ             TYPE RANGE OF salv_de_selopt_low,
      r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181012  ED2K913582
*- Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
      r_po_type         TYPE RANGE OF salv_de_selopt_low,
      v_po_type         TYPE char1,
*- End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code       TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office    TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency   TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      v_tax_id                 TYPE salv_de_selopt_low,
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
      r_print_product          TYPE RANGE OF salv_de_selopt_low,
      r_digital_product        TYPE RANGE OF salv_de_selopt_low,
      li_print_media_product   TYPE TABLE OF ty_vbap,
      li_digital_media_product TYPE TABLE OF ty_vbap,
      lst_digital              TYPE ty_vbap,
      lst_print                TYPE ty_vbap,
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
      v_total                  TYPE kzwi1,            " Subtotal 1 from pricing procedure for condition
      v_total_c                TYPE char18,           " Total_c of type CHAR18
      v_sub_total              TYPE kzwi1,            " Subtotal 1 from pricing procedure for condition
      v_sub_total_c            TYPE char18,           " Sub_total_c of type CHAR18
      v_taxes                  TYPE kzwi6,            " Subtotal 6 from pricing procedure for condition
      v_taxes_c                TYPE char18,           " Taxes_c of type CHAR18
      v_discount               TYPE kzwi5,            " Subtotal 5 from pricing procedure for condition
      v_discount_c             TYPE char18,           " Discount_c of type CHAR18
      v_tax                    TYPE thead-tdname,     " Name
      v_pos                    TYPE sy-cucol VALUE 0, "Column Position

      v_remit_to_tbt           TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_credit_tbt             TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_email_tbt              TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_banking1_tbt           TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_banking2_tbt           TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_cust_serv_tbt          TYPE thead-tdname,     " SAPscript: Text Header:Name
      v_footer                 TYPE thead-tdname.     " SAPscript: Text Header:Name

*** Global Constant Declaration
CONSTANTS: c_pdf               TYPE char1 VALUE '2',                           " Pdf of type CHAR1
           c_st                TYPE thead-tdid VALUE 'ST',                     " Text ID of text to be read
           c_zero              TYPE char1 VALUE '0',                           " Zero of type CHAR1
           c_msgtyp_err        TYPE syst_msgty VALUE 'E',                      " ABAP System Field: Message Type
           c_object            TYPE thead-tdobject VALUE 'TEXT',               " Object of text to be read.
           c_sign_i            TYPE sign VALUE 'I',                            " Debit/Credit Sign (+/-)
           c_option_eq         TYPE option VALUE 'EQ',                         " Option for ranges tables
           c_option_bt         TYPE option VALUE 'BT',                         " Option for ranges tables
           c_txtid_grun        TYPE tdid VALUE 'GRUN',                         " Text ID
           c_txtobj_material   TYPE tdobject VALUE 'MATERIAL',                 " Texts: Application Object
           c_semicoln_char     TYPE char1 VALUE ':',                           " Semicoln_char of type CHAR1
           c_mediatyp_dgtl     TYPE ismmediatype VALUE 'DI',                   " Media Type
           c_mediatyp_prnt     TYPE ismmediatype VALUE 'PH',                   " Media Type
           c_mediatyp_combo    TYPE ismmediatype VALUE 'MM',                   " Media Type
           c_char_hyphen       TYPE char1    VALUE '-',                        " Char_hyphen of type CHAR1
           c_stats_04          TYPE jnipstatus VALUE '04',                     " IS-M: Status of Shipping Planning
           c_stats_10          TYPE jnipstatus VALUE '10',                     " IS-M: Status of Shipping Planning
           c_tabnam            TYPE slis_tabname VALUE 'I_OUTPUT',
           c_start_issue_tm    TYPE tdsfname VALUE 'ZQTC_START_ISSUE_F037',    " Smart Forms: Form Name
           c_med_type_digi_tm  TYPE tdsfname VALUE 'ZQTC_MED_TYPE_DIGI_F037',  " Smart Forms: Form Name
           c_med_type_print_tm TYPE tdsfname VALUE 'ZQTC_MED_TYPE_PRINT_F037', " Smart Forms: Form Name
           c_med_type_combo_tm TYPE tdsfname VALUE 'ZQTC_MED_TYPE_COMBO_F037', " Smart Forms: Form Name
* BOC: CR#7730 KKRAVURI20181012  ED2K913582
           c_membership_number TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX'. " Standard Text Name
* EOC: CR#7730 KKRAVURI20181012  ED2K913582
