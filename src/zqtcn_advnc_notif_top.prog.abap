*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_ADVNC_NOTIF_TOP(Include Program)
* REPORT DESCRIPTION:    Include for Global declarations
* DEVELOPER:             Aratrika Banerjee (ARABANERJE)
* CREATION DATE:         26-Dec-2016
* OBJECT ID:             F032
* TRANSPORT NUMBER(S):   ED2K903799
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908563
* REFERENCE NO: ERP-3402
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  09/11/2017
* DESCRIPTION: Material description should be taken from READ_TEXT for the
*              digital and print materials. Adjusted the code to display
*              country in the bill to address when company code country
*              and bill to customer country are different.
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
* REVISION NO:  ED2K913178
* REFERENCE NO: ERP-7119
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  09/12/2018
* DESCRIPTION: Need to make the following change on text change on the form.
*              Add in Subscription Term (as we have on F037)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913666
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         24-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K914490
* REFERENCE NO:  CR7873
* DEVELOPER: PRABHU
* DATE:  2019-02-18
* DESCRIPTION:When Payment method gets updated to 'U' OR 'V' of ZREW,
* default billing plan date to 5th or 20th of the month from 10 days of modified date*
*-------------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K919534
* REFERENCE NO: OTCM-26071
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE:  17/09/2020 (DD/MM/YYYY)
* DESCRIPTION: Greman Translation Changes
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K924582
* REFERENCE NO: OTCM-40086
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         15/09/2021 (DD/MM/YYYY)
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
*&  Include           ZQTCN_ADVNC_NOTIF_TOP
*&---------------------------------------------------------------------*
TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        vbap,     " Sales Document: Item Data
        toa_dara. "Added by MODUTTA

* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K910441
CONSTANTS:
* BOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
* BOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*  c_tax_tm          TYPE tdsfname VALUE 'ZQTC_TAXES_F037', " Text Module for Tax
  c_tax_tm          TYPE tdsfname VALUE 'ZQTC_TAXES_F032',
* EOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
  c_char_perc       TYPE char1    VALUE '%',               " Character %
  c_char_equal      TYPE char1    VALUE '=',               " Character =
  c_msgtyp_err      TYPE syst_msgty VALUE 'E',             " Error Message
* BOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*  c_sub_total_tm    TYPE tdsfname VALUE 'ZQTC_NET_AMT',    " Text Module for Sub-Total
*  c_total_amt_tm    TYPE tdsfname VALUE 'ZQTC_TOT_AMT',    " Text Module for Total Amount
  c_sub_total_tm    TYPE tdsfname VALUE 'ZQTC_NET_AMT_F032',
  c_total_amt_tm    TYPE tdsfname VALUE 'ZQTC_TOT_AMT_F032',
* EOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
* EOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
  c_initial_amt     TYPE char4    VALUE '0.00', " Initial_amt of type CHAR4
  c_initial_prc     TYPE char5    VALUE '0.000', " Initial_prc of type CHAR5
  c_txtid_grun      TYPE tdid VALUE 'GRUN',        " Text ID
  c_semicoln_char   TYPE char1 VALUE ':',          " Semicoln_char of type CHAR1
  c_attachtyp_pdf   TYPE saedoktyp    VALUE 'PDF', " Document Class for Attachment
* c_attachtyp_pdf   TYPE so_obj_tp    VALUE 'PDF',               " Document Class for Attachment
  c_mediatyp_dgtl   TYPE ismmediatype VALUE 'DI',                " Media Type
  c_mediatyp_prnt   TYPE ismmediatype VALUE 'PH',                " Media Type
  c_mediatyp_comb   TYPE ismmediatype VALUE 'MM',                " Media Type
  c_screen_webdyn   TYPE char1 VALUE 'W',                        " Screen Web Dynpro
  c_print_tax_tm    TYPE tdsfname VALUE 'ZQTC_PRINT_TAX_F037',   " Smart Forms: Form Name
  c_digital_tax_tm  TYPE tdsfname VALUE 'ZQTC_DIGITAL_TAX_F037', " Smart Forms: Form Name
* BOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
  c_char_attherate  TYPE char1    VALUE '@', " Character @
* EOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
  c_txtobj_material TYPE tdobject VALUE 'MATERIAL'. " Text Objecy
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045

********Global Structure Declaration for VBPA
TYPES :

*  Global Structure Declaration for vbpa
  BEGIN OF ty_vbpa,
    vbeln TYPE vbeln,       "Sales and Distribution Document Number
    posnr TYPE posnr,       "Item number of the SD document
    parvw TYPE parvw,       "Partner Function
    kunnr TYPE kunnr,       " Customer Number
    adrnr TYPE adrnr,       "Address
    land1 TYPE land1,       "Country Key
  END OF ty_vbpa,

  BEGIN OF ty_vbak,
    vbeln    TYPE  vbeln,   " sales AND distribution document NUMBER
    angdt    TYPE  angdt_v, " Quotation/Inquiry is valid from
    auart    TYPE  auart,   " SD document category
    waerk    TYPE  waerk,   " SD Document Currency
* BOC by SRABOSE on 15-Jan-2017 #CR_TBD #TR:  ED2K909616
    vkorg    TYPE  vkorg, " Sales Organization
    vtweg    TYPE  vtweg, "  Distribution Channel
    spart    TYPE  spart, " Division
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
    vkbur    TYPE vkbur,    " sales office
    bsark    TYPE bsark,    " PO Type
* * End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
* BOC by SRABOSE on 15-Jan-2017 #CR_TBD #TR:  ED2K909616
    knumv    TYPE  knumv,    " Number of the document condition
    kunnr    TYPE  kunag,    " Sold-to party
    kvgr1    TYPE  kvgr1,    "Customer group 1
    bukrs_vf TYPE  bukrs_vf, " Company code to be billed
    vgbel    TYPE  vgbel,    " Document number of the reference document
    land1    TYPE  land1_gp, " Country Key
    spras    TYPE  spras,    " Language Key
  END OF ty_vbak,

********Global Structure Declaration for vbfa
  BEGIN OF ty_vbfa,
    vbelv   TYPE vbeln_von,  "Preceding sales and distribution document
    posnv   TYPE posnr_von,  "Preceding item of an SD document
    vbeln   TYPE vbeln_nach, "Subsequent sales and distribution document
    posnn   TYPE posnr_nach, "Subsequent item of an SD document
    vbtyp_n TYPE vbtyp_n,    "Document category of subsequent document
    vbtyp_v TYPE vbtyp_v,    "Document category of preceding SD document
  END OF ty_vbfa,

  BEGIN OF ty_vbap,
    vbeln  TYPE  vbeln_va,   "Sales Document
    posnr  TYPE  posnr_va,   "Sales Document Item
    matnr  TYPE  matnr,      "Material Number
    arktx  TYPE  arktx,      "Short text for sales order item
    uepos  TYPE  uepos,      "Higher-level item
    netwr  TYPE  netwr_ap,   " Net value
    kwmeng TYPE  kwmeng,     "Cumulative Order Quantity in Sales Units
    kzwi1  TYPE  kzwi1,      "Subtotal 1 from pricing procedure for condition
    kzwi2  TYPE  kzwi2,      "Subtotal 2 from pricing procedure for condition
    kzwi4  TYPE  kzwi4,      "Subtotal 4 from pricing procedure for condition
    kzwi5  TYPE  kzwi5,      "Subtotal 5 from pricing procedure for condition
    kzwi6  TYPE  kzwi6,      "Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
    mvgr4  TYPE mvgr4,      "Material Group 4
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
    mvgr5  TYPE  mvgr5, " Material group 5
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
  END OF ty_vbap,
* Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
  tt_vbap TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
* End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265

  BEGIN OF ty_vbkd,
    vbeln TYPE vbeln, " Sales and Distribution Document Number
    posnr TYPE posnr, "Item number of the SD document
    fkdat TYPE fkdat, "Billing Date "ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
    ihrez TYPE ihrez, " Your Reference
*   Begin of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
*   kdkg1 TYPE kdkg1,        " Customer condition group 1
    kdkg2 TYPE kdkg2, " Customer condition group 2
*   End   of CHANGE:ERP-5131:WROY:29-Nov-2017:ED2K907387
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
    zlsch TYPE schzw_bseg,
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
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

***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
  BEGIN OF ty_stxl,
    tdname TYPE tdobname, "Name
  END OF ty_stxl,
  tt_std_text TYPE STANDARD TABLE OF ty_stxl INITIAL SIZE 0,
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265

* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
*      MARA Structure
  BEGIN OF ty_mara,
    matnr           TYPE matnr, " Material Number
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
    volum           TYPE volum,          " Volume
    ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
    ismmediatype    TYPE ismmediatype, " Media Type
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
    ismnrinyear     TYPE ismnrimjahr,   " Issue Number (in Year Number)
    ismyearnr       TYPE ismjahrgang,   " Media issue year number
    ismcopynr       TYPE ismheftnummer, " Copy Number of Media Issue
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
  END OF ty_mara,
  tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
  BEGIN OF ty_jptidcdassign,
    matnr      TYPE matnr,         " Material Number
    idcodetype TYPE ismidcodetype, " Type of Identification Code
    identcode  TYPE ismidentcode,  " Identification Code
  END OF ty_jptidcdassign,

  tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
  BEGIN OF ty_tax_dtls,
* BOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
*    ismmediatype TYPE ismmediatype, " Media Type
*    kbetr        TYPE p DECIMALS 3, " Kbetr of type Packed Number
*    kzwi6        TYPE kzwi6,        " Subtotal 6 from pricing procedure for condition
*   Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    ismmediatype TYPE ismmediatype, " Media Type
*   End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911265
    kbetr        TYPE p DECIMALS 3, " Kbetr of type Packed Number
    netwr        TYPE netwr_ap,     " Price based on kbetr.
    kwert        TYPE kwert,        " Tax Price
* EOC by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
  END OF ty_tax_dtls,
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045

  BEGIN OF ty_veda,
    vbeln   TYPE vbeln_va, " Sales Document
    vposn   TYPE posnr_va, " Sales Document Item
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
    vlaufk  TYPE vlauk_veda, " Validity period category of contract
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
    vbegdat TYPE vbdat_veda, " Contract start date
    vaktsch TYPE vasch_veda, " Action at end of contract " ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
    venddat TYPE vndat_veda, " Contract End date "RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
  END OF ty_veda,

*** BOC BY SAYANDAS
  BEGIN OF ty_arktx,
* BOC by PBANDLAPAL on 11-Sep-2017 for ERP-3402 ED2K908563
*    arktx TYPE arktx, " Short text for sales order item
* As we need to display digital or print we need to use the read text
* hence changed to type string.
    arktx TYPE string,
* EOC by PBANDLAPAL on 11-Sep-2017 for ERP-3402 ED2K908563
  END OF ty_arktx,
*** EOC BY SAYANDAS
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
  BEGIN OF ty_tax_data,
    document        TYPE  /idt/doc_number,        " Document Number
    doc_line_number TYPE  /idt/doc_line_number,   " Document Line Number
    buyer_reg       TYPE /idt/buyer_registration, " Buyer VAT Registration Number
    seller_reg      TYPE /idt/buyer_registration, " Buyer VAT Registration Number
  END OF ty_tax_data,

  tt_tax_data TYPE STANDARD TABLE OF ty_tax_data,
*************EOC by SRBOSE on 09/08/2017 for CR# 408****************
*- Begin of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
  BEGIN OF ty_constant,
    devid    TYPE zdevid,     " Development ID
    param1   TYPE rvari_vnam,    " ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,    " ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,      " ABAP: Current selection number
    sign     TYPE tvarv_sign,      " ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,      " ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,       " Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,      " Upper Value of Selection Condition
    activate TYPE zconstactive,   " Activation indicator for constant
  END OF ty_constant.
*- End of ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
******Global variable declaration
DATA : v_xstring                TYPE xstring,
       v_msg_txt                TYPE string,
       v_retcode                TYPE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
       v_email_shipto           TYPE ad_smtpadr,   " Ship to Email Address
       v_society_logo           TYPE xstring,      " Logo Variable
       v_drct_dbt_logo          TYPE xstring,
       v_flag_cust              TYPE char1,        " Flag_cust of type CHAR1
       v_society_name           TYPE name1_gp,     " Name 1
       v_footer                 TYPE thead-tdname, " SAPscript: Text Header:Name
       v_compname               TYPE thead-tdname, " Name
       st_vbap                  TYPE ty_vbap,
       st_vbco3                 TYPE vbco3,        " Sales Doc.Access Methods: Key Fields: Document Printing
       i_konv                   TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,
*                    i_vbap          TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
       i_vbak                   TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0,
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
       li_vbkd                  TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,
* end of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
       li_constant_m            TYPE TABLE OF ty_constant, "ADD:RITM0093866:SGUDA:03-DECEMBER-2018:ED1K909062
       lst_constat_m            TYPE ty_constant,
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
       i_std_text               TYPE tt_std_text,
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
* Begin of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
       i_mara                   TYPE tt_mara,
*                    i_tax_dtls      TYPE TABLE OF ty_tax_dtls,  " Comment by PBANDLAPAL for CR#743
* End of Insert by PBANDLAPAL on 24-OCT-2017 for CR#666: TR# ED2K909045
* BOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
       i_final_amt_tax          TYPE ztqtc_amt_tax_f032, " Final Amount and Tax Details
* EOI by PBANDLAPAL on 05-Feb-2018 for CR#743: ED2K910441
* BOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
       r_mvgr5_scc              TYPE RANGE OF mvgr5, " Range for Mat. Grp5 for society by contract
       r_mvgr5_scm              TYPE RANGE OF mvgr5, " Range for Mat. Grp5 for society by member
* EOI by PBANDLAPAL on 23-Jan-2018: ED2K910441
       st_final                 TYPE zstqtc_final_f032, " Final structure for Advance Notification
       st_address               TYPE zstqtc_addr_f032,  " Structure for address node
       st_formoutput            TYPE fpformoutput,      " Form Output (PDF, PDL)
*                    Added by MODUTTA on 25/04/2017 TR# ED2K905635 for adding E098 FM attachments
       st_vbkd                  TYPE ty_vbkd,
**BOC APATNAIK
       v_waerk                  TYPE waerk,        "Local Variable for currency
       v_cust_serv_tbt          TYPE thead-tdname, " SAPscript: Text Header:Name
       v_cust_serv_scc          TYPE thead-tdname, " SAPscript: Text Header:Name
       v_cust_serv_scm          TYPE thead-tdname, " SAPscript: Text Header:Name
       v_ent_screen             TYPE c,            "Added by MODUTTA
       v_barcode                TYPE char100,       " Barcode ++CR 439
       v_tot                    TYPE  kzwi6,       " Barcode ++CR 439
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
       i_tax_data               TYPE tt_tax_data,
       v_seller_reg             TYPE tdline, " Seller VAT Registration Number
*************BOC by SRBOSE on 09/08/2017 for CR# 408****************
**********,***BOC by ARABANERJE on 16/08/2017 for CR# ****************
       v_country                TYPE land1_gp,     " Country Key
       v_langu                  TYPE spras,        " Language Key
       v_remit_to_tbt           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking1_tbt           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking2_tbt           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_remit_to_scc           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking1_scc           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking2_scc           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_remit_to_scm           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking1_scm           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_banking2_scm           TYPE thead-tdname, " SAPscript: Text Header:Name
       v_footer_scm             TYPE thead-tdname, " SAPscript: Text Header:Name
       v_footer_scc             TYPE thead-tdname, " SAPscript: Text Header:Name
       v_footer_tbt             TYPE thead-tdname, " SAPscript: Text Header:Name
*************EOC by ARABANERJE on 16/08/2017 for CR# ****************
       v_comm_method            TYPE ad_comm, "(++ BY SRBOSE ON 13-DEC-2017 )
*** BOC BY SAYANDAS
*                    v_arktx         TYPE arktx,          " Short text for sales order item
       v_arktx                  TYPE string,
       v_idcodetype_1           TYPE ismidcodetype, " Type of Identification Code
       v_idcodetype_2           TYPE ismidcodetype, " Type of Identification Code
*** EOC BY SAYANDAS
       v_subs_type              TYPE thead-tdname,
       v_email_tbt              TYPE thead-tdname,   " Name
       v_email_scc              TYPE thead-tdname,   " Name
       v_email_scm              TYPE thead-tdname,   " Name
       v_society                TYPE zzsociety_name, " Society Name
* Begin of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
       v_bill_date              TYPE char20,         " Billing Date
       v_text_body              TYPE string,         " Mail Body
* End of ADD:ERP-7119:SGUDA:12-SEP-2018:ED2K913178
* BOC: CR#7730 KKRAVURI20181024  ED2K913666
       r_output_typ             TYPE RANGE OF salv_de_selopt_low,
       r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181024  ED2K913666
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
       r_tax_id                 TYPE salv_de_selopt_low,
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
       li_veda                  TYPE TABLE OF ty_veda,
       lst_veda                 TYPE ty_veda,             " Local workarea for VEDA table
       lst_zqtc_renwl_plan      TYPE zqtc_renwl_plan,
       v_date                   TYPE sy-datum,
       v_flag                   TYPE char1,
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
       v_disp_time              TYPE na_vsztp,         " Disp Time
       v_process_time           TYPE na_uhrvr,         " Processing time
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
       r_auart                  TYPE fip_t_auart_range,
       r_zlsch                  TYPE trty_zlsch_range,
       r_bsark                  TYPE tdt_rg_bsark,
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
       r_print_product          TYPE RANGE OF salv_de_selopt_low,
       r_digital_product        TYPE RANGE OF salv_de_selopt_low,
       li_print_media_product   TYPE TABLE OF ty_vbap,
       li_digital_media_product TYPE TABLE OF ty_vbap,
       lst_digital              TYPE ty_vbap,
       lst_print                TYPE ty_vbap.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924582
DATA: i_content_hex   TYPE solix_tab, "GBT: SOLIX as Table Type
      i_vbpa          TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY parvw COMPONENTS vbeln parvw,
*** BOC BY SAYANDAS
      i_arktx         TYPE ztqtc_arktx,      " Short text for sales order item
      i_vbap          TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
      i_jptidcdassign TYPE tt_jptidcdassign, " IT for JPTIDCDASSIGN
*** EOC BY SAYANDAS
      st_vbpa         TYPE ty_vbpa.

CONSTANTS: c_comm_method       TYPE ad_comm VALUE 'LET', "(++ BY SRBOSE ON 13-DEC-2017)
***BOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
           c_st                TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
           c_object            TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
***EOC SAYANDAS on 19-Mar-2018 for ERP_6599 TR  ED2K911265
*** BOC BY SAYANDAS on 12-MAR-2018 for CR-744
* BOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*           c_journal_txt       TYPE tdsfname VALUE 'ZQTC_TITLE_F035',             " Smart Forms: Form Name
*           c_stissue_txt       TYPE tdsfname VALUE 'ZQTC_START_ISSUE_F037',       " Smart Forms: Form Name
*           c_subtype_txt       TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TYPE_F037', " Smart Forms: Form Name
*           c_subref_txt        TYPE tdsfname VALUE 'ZQTC_SUB_REF_F037',           " Smart Forms: Form Name
           c_journal_txt       TYPE tdsfname VALUE 'ZQTC_TITLE_F032',              " Smart Forms: Form Name
           c_stissue_txt       TYPE tdsfname VALUE 'ZQTC_START_ISSUE_F032',        " Smart Forms: Form Name
           c_subtype_txt       TYPE tdsfname VALUE 'ZQTC_SUBSCRIPTION_TYPE_F032',  " Smart Forms: Form Name
           c_subref_txt        TYPE tdsfname VALUE 'ZQTC_SUB_REF_F032',            " Smart Forms: Form Name
* EOC by TDIMANTHA on 18-Sept-2020 for OTCM-26071: ED2K919534
*** EOC BY SAYANDAS on 12-MAR-2018 for CR-744
* BOC: CR#7730 KKRAVURI20181024  ED2K913666
           c_membership_number TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX',  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181024  ED2K913666
           c_renewal_year      TYPE rvari_vnam VALUE 'RENWAL_YEAR', " Renewal Year
           c_auart             TYPE auart      VALUE 'ZREW',
           c_devid             TYPE zdevid     VALUE 'F032',
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803
*   Begin of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
           c_cs                TYPE zactivity_sub VALUE 'CS',
           c_0                 TYPE posnr  VALUE '000000',
           c_001               TYPE vasch_veda VALUE '0001'.
*   End of ADD:ERPM-21151:SGUDA:10-AUG-2020:ED2K919110
DATA : r_sanc_countries  TYPE temr_country.
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911803

*DATA v_knvv TYPE .
DATA: v_kvgr1 TYPE kvgr1, " Customer group 1
      v_psb   TYPE kvgr1. " Customer group 1
