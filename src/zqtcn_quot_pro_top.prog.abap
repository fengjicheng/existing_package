*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_QUOTATION_PROFORMA_F027
* REPORT DESCRIPTION:    Driver Program for quotation proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Alankruta Patnaik (APATNAIK)
* CREATION DATE:         01-FEB-2017
* OBJECT ID:             F027
* TRANSPORT NUMBER(S):   ED2K904328
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907523
* REFERENCE NO: F027(CR-473)
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2017-07-26
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907523
* REFERENCE NO: F027(CR-473)
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2017-07-26
* DESCRIPTION:
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*-----------------------------------------------------------------------*
*-----------------------------------------------------------------------*
* REVISION NO:  ED2K909938
* REFERENCE NO: ERP-5571
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)/Monalisa Dutta (MODUTTA)
* DATE:  2018-01-11
* DESCRIPTION: Fixed the dump issue while generating ZSQT docs. Also Adjusted
*              the code where ever its needed.
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR-7730
* REFERENCE NO: ED2K913588
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-47818
* REFERENCE NO: ED1K913618
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         10/21/2021
* DESCRIPTION:   Indian Agent Processing
* 1) Change email address to indiaagent@wiley.com (Top Left Box on the Form)
* 2) Credit Card Option removed.
* 3) Change Wire Transfer Details as shown as below.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913785
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
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_QUOT_PRO_TOP
*&---------------------------------------------------------------------*

TABLES: nast,     " Message Status
        tnapr,    " Processing programs for output
        vbap,     " Sales Document: Item Data
        toa_dara. "Added by MODUTTA

********Global Structure Declaration for vbap and vbak
TYPES: BEGIN OF ty_vbap,
         vbeln    TYPE  vbeln,  " Sales and Distribution Document Number
         posnr    TYPE  posnr,  " Item number of the SD document
         matnr    TYPE  matnr,  " Material Number
         arktx    TYPE  arktx,  " Short text for sales order item
         uepos     TYPE uepos,   " Higher-level item in bill of material structures                                                                                      meins  "
         meins    TYPE  meins,  " Base Unit of Measure
         kwmeng   TYPE  kwmeng, " Cumulative Order Quantity in Sales Units
         kzwi1    TYPE  kzwi1,  " Unit Price
         kzwi2    TYPE  kzwi2,  " Amount
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
         kzwi3    TYPE  kzwi3,    "Subtotal 3 from pricing procedure for condition
         netwr    TYPE  netwr_ak, " Net Value of the Sales Order in Document Currency
         zmeng     TYPE  dzmeng,   " Target quantity in sales units
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
         kzwi5    TYPE  kzwi5, "Discount
         kzwi6    TYPE  kzwi6, "Tax
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
         mvgr4    TYPE mvgr4,    " Material Group 5
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
*** BOC BY SAYANDAS on 24-JAN-2018 for CR-XXX
         mvgr5    TYPE  mvgr5, " Material group 5
*** EOC BY SAYANDAS on 24-JAN-2018 for CR-XXX
         mwsbp    TYPE  mwsbp,   "Tax
         angdt    TYPE  angdt_v, " Quotation/Inquiry is valid from
         vbtyp    TYPE  vbtyp,   " SD document category
         waerk    TYPE  waerk,   " SD Document Currency
**BOC- APATNAIK
         vkbur    TYPE vkbur, " Sales Office
**EOC- APATNAIK
         knumv    TYPE  knumv, " Number of the document condition
*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
         kvgr1    TYPE kvgr1, " Customer group 1
*** BOC BY SAYANDAS on 22-JAN-2018 for CR-XXX
         bukrs_vf TYPE  bukrs_vf, " Company code to be billed
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
         auart    TYPE  auart,    "Sales Document Type
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
       END OF ty_vbap,
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
*** EOC for F044 BY SAYANDAS on 26-JUN-2018

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
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
         zterm    TYPE dzterm, " Terms of Payment Key
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
         zlsch    TYPE schzw_bseg, " Payment Method
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
         bstkd    TYPE bstkd,       " Customer purchase order number
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
         bsark    TYPE bsark,       "Customer purchase order type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
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

* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
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

***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
       BEGIN OF ty_stxl,
         tdname TYPE tdobname, "Name
       END OF ty_stxl,
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376

       BEGIN OF ty_mara,
         matnr           TYPE matnr, " Material Number
         mtart           TYPE mtart, " Material Type
         volum           TYPE volum, " Volume
*** BOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
         ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level (Media Product Family, Product or Issue)
*** EOC BY SAYANDAS on 19-JAN-2018 for CR-XXX
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

*       BOC by MODUTTA on 22/01/2018 for CR#TBD
       BEGIN OF ty_tax_item,
*         Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
         subs_type      TYPE ismmediatype,
*         End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911184
         media_type     TYPE char255,
         tax_percentage TYPE char16, " Percentage of type CHAR16
         tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
         taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
       END OF ty_tax_item,

       tt_tax_item TYPE STANDARD TABLE OF ty_tax_item,

*** BOC for F044 BY SAYANDAS on 26-JUN-2018
       BEGIN OF ty_zlsch_f044,
         sign   TYPE sign,       " Debit/Credit Sign (+/-)
         option TYPE opti,       " Option for ranking structure
         low    TYPE schzw_bseg, " Payment Method
         high   TYPE schzw_bseg, " Payment Method
       END OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*Begin of ADD:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
       BEGIN OF ty_tax_id,
         land1 TYPE land1, " Country Key
         stceg TYPE stceg, " VAT Registration Number
       END OF ty_tax_id,
       tt_tax_id        TYPE STANDARD TABLE OF ty_tax_id INITIAL SIZE 0,
*End   of ADD:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
       tt_makt          TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
       tt_mara          TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
       tt_tax_data      TYPE STANDARD TABLE OF ty_tax_data,
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
       tt_std_text      TYPE STANDARD TABLE OF ty_stxl INITIAL SIZE 0,
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
       tt_vbap          TYPE STANDARD TABLE OF  ty_vbap   INITIAL SIZE 0,
       tt_vbpa          TYPE STANDARD TABLE OF  ty_vbpa   INITIAL SIZE 0,
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
       tt_constant      TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523

CONSTANTS: c_st          TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
           c_object      TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
* BOI: PBANDLAPAL:11-Jan-2018:ERP-5571: ED2K910264
           c_initial_amt TYPE char4    VALUE '0.00', " Initial_amt of type CHAR4
* EOI: PBANDLAPAL:11-Jan-2018:ERP-5571: ED2K910264
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
*** BOC BY SAYANDAS
      v_society_text           TYPE name1_gp, " Society text
      v_scc                    TYPE xfeld,    " Scc of type CHAR1
      v_scm                    TYPE xfeld,    " Scm of type CHAR1
      v_tbt                    TYPE xfeld,    " Tbt of type CHAR1
*** EOC BY SAYANDAS
      v_detach                 TYPE thead-tdname,       " Name
      v_order                  TYPE thead-tdname,       " Name
      v_credit_crd             TYPE thead-tdname,       " Name
      v_credit_crd_email       TYPE thead-tdname,       " Name "CR#7189 and 7431:SGUDA:14-November-2018:ED2K913797
      v_payment                TYPE thead-tdname,       " Name
      v_payment_scc            TYPE thead-tdname,       " Name
      v_payment_scm            TYPE thead-tdname,       " Name
      v_cust                   TYPE thead-tdname,       " Name
      v_com_uk                 TYPE thead-tdname,       " Name
      v_com_usa                TYPE thead-tdname,       " Name
      st_address               TYPE zstqtc_add_f027,    " Global structure for address
      st_header                TYPE zstqtc_header_f027, " Structure for header Data
      i_vbpa                   TYPE STANDARD TABLE OF  ty_vbpa    INITIAL SIZE 0,
      i_vbap                   TYPE STANDARD TABLE OF  ty_vbap    INITIAL SIZE 0,
      i_content_hex            TYPE solix_tab,          "GBT: SOLIX as Table Type
      i_sub_final              TYPE zttqtc_sub_item_f027,
      i_final                  TYPE zttqtc_item_f027,
      i_makt                   TYPE tt_makt,            " Material Descriptions
***BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
      i_std_text               TYPE tt_std_text,
***EOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
*      i_email             TYPE ldps_txt_tab,       " Text Line
      i_credit                 TYPE ldps_txt_tab, " Text Line
      st_formoutput            TYPE fpformoutput, " Form Output (PDF, PDL)
      st_calc                  TYPE zstqtc_calc,  " Structure for Calculation
* Begin of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
      st_formoutput_f044       TYPE fpformoutput,                   " Form Output (PDF, PDL)
      i_formoutput             TYPE STANDARD TABLE OF fpformoutput, " Form Output (PDF, PDL)
      v_vkorg_f044             TYPE vkorg,                          " Sales Organization
      v_zlsch_f044             TYPE schzw_bseg,                     " Payment Method
      v_waerk_f044             TYPE waerk,                          " SD Document Currency
      v_ihrez_f044             TYPE ihrez,                          " Your Reference
      v_kvgr1_f044             TYPE kvgr1,                          " Customer Group  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
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
*      v_barcode           TYPE char30,                         " Barcode of type CHAR30 ""ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
      v_barcode                TYPE char100,                         " Barcode of type CHAR100 ""ERP-7189 and 7431:SGUDA:07-NOV-2018:ED2K913797
      v_seller_reg             TYPE tdline,                         " Seller VAT Registration Number (++)MODUTTA on 08/08/2017 for CR#408
      i_tax_data               TYPE tt_tax_data,
      i_mara                   TYPE tt_mara,                        " IT for MARA
      i_jptidcdassign          TYPE tt_jptidcdassign,               " IT for JPTIDCDASSIGN
      v_langu                  TYPE syst_langu,                     " ABAP System Field: Language Key of Text Environment
      v_email_id               TYPE tdline,                         " Text Line
      v_tax                    TYPE thead-tdname,                   " Name
      v_text_tax               TYPE string,                         " Name
*** BOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
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
*** EOC BY SAYANDAS on 08-JAN-2018 for CR-XXX
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
      r_vkorg_f044             TYPE TABLE OF range_vkorg, " Range table for VKORG
      r_zlsch_f044             TYPE TABLE OF ty_zlsch_f044,
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*   Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
      r_kvgr1_f044             TYPE RANGE OF salv_de_selopt_low,
*   End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
      r_mtart_med_issue        TYPE fip_t_mtart_range, " Material Types: Media Issues
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
* End of CHANGE:CR#473:LKODWANI:26-Jul-2017:ED2K907523
*** BOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
      r_sanc_countries         TYPE temr_country,
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
      r_output_typ             TYPE RANGE OF salv_de_selopt_low,
      r_mat_grp5               TYPE RANGE OF salv_de_selopt_low,
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
      v_num                    TYPE p DECIMALS 2, " Num of type Packed Number
      v_output_typ             TYPE sna_kschl,    " Message type
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      v_tax_id                 TYPE salv_de_selopt_low,
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
      i_tax_id                 TYPE tt_tax_id, " TAX IDs
*- End of ADD:CR#7189 and 7431:SGUDA:11-June-2019:ED2K915237
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
      r_document_type          TYPE RANGE OF salv_de_selopt_low,
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
      r_po_type           TYPE RANGE OF salv_de_selopt_low,
      v_po_type           TYPE char1,
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
      r_comp_code         TYPE RANGE OF  salv_de_selopt_low,
      r_sales_office      TYPE RANGE OF  salv_de_selopt_low,
      r_docu_currency     TYPE RANGE OF  salv_de_selopt_low,
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
      r_print_product          TYPE RANGE OF salv_de_selopt_low,
      r_digital_product        TYPE RANGE OF salv_de_selopt_low,
      li_print_media_product   TYPE TABLE OF ty_vbap,
      li_digital_media_product TYPE TABLE OF ty_vbap,
      lst_digital              TYPE ty_vbap,
      lst_print                TYPE ty_vbap.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
* Begin of CHANGE:JIRA#4591:MMUKHERJEE:22-Sep-2017: ED2K908539
CONSTANTS: c_comm_method       TYPE ad_comm    VALUE 'LET',             " Communication Method (Key) (Business Address Services)
           c_mtart_med_iss     TYPE rvari_vnam VALUE 'MTART_MED_ISSUE', " Material Type: Media Issue
****BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
*                     c_st           TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
*                     c_object       TYPE thead-tdobject   VALUE 'TEXT', " Object of text to be read
****BOC SAYANDAS on 15-Mar-2018 for ERP_6599 TR ED2K911376
           c_id_grun           TYPE thead-tdid       VALUE 'GRUN',     " Text ID of text to be read
           c_obj_mat           TYPE thead-tdobject   VALUE 'MATERIAL', " Object of text to be read
           c_deflt_langu       TYPE sylangu    VALUE 'E',              " Default Language: English
* END of CHANGE:JIRA#4591:MMUKHERJEE:22-Sep-2017: ED2K908539
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
           c_membership_number TYPE tdobname VALUE 'ZQTC_MEMBERSHIP_NUMBER_F0XX',  " Standard Text Name
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
           c_zsqt              TYPE nast-kschl VALUE 'ZSQT',  " Output type "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
           c_zsqs              TYPE nast-kschl VALUE 'ZSQS'.  " Output type "ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
