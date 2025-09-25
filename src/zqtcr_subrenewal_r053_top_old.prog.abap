*&---------------------------------------------------------------------*
*&  Include           ZQTCR_SUBRENEWAL_R053_TOP
*&---------------------------------------------------------------------*
*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SUBRENEWAL_R053_top
* PROGRAM DESCRIPTION: Renewals Subscription
* DEVELOPER: Mounika Nallapaneni
* CREATION DATE:   2017-06-02
* OBJECT ID: R053
* TRANSPORT NUMBER(S): ED2K906467
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908710
* REFERENCE NO:  ERP 4700
* DEVELOPER: Anirban Saha
* DATE:  2017-09-28
* DESCRIPTION: Taking out the communication method field from report
*-------------------------------------------------------------------
* REVISION NO: ED2K909489
* REFERENCE NO:  ERP-5530
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-12-14
* DESCRIPTION: To improve the performance of the program and as part
*              of this made the dates as mandatory parameters.
*-------------------------------------------------------------------
* REVISION NO: ED2K913224
* REFERENCE NO:  ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-28
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO: ED2K913419
* REFERENCE NO:  ERP-7727
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-09-21
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO: ED1K909215/ED1K909474
* REFERENCE NO:  RITM0080792
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2018-12-26 / 2019-01-31
* DESCRIPTION: Added new fields in Report O/P
*-------------------------------------------------------------------
* REVISION NO:   ED2K915473
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field AUGRU-Order Reason in
*                Selection Screen and Report O/P
* Imp Notes:     The is a change done to the CDS view
*                ZQTC_SALES_001 and captured in Transport
*                ED2K915477 which need to be moved simultaneously
*-------------------------------------------------------------------
* REVISION NO:   ED2K915605
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field Order Reason Description
*                and corrected existing code for Order reason
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:   ED2K920475
* REFERENCE NO:  OTCM-25936
* DEVELOPER:     Prabhu (PTUFARAM)
* DATE:          11/25/2020
* DESCRIPTION:   1.Added new fields Media Start Issue
*                Media End Issue.
*                2.Issue sent, Issue Duw logic has been changed
* Imp Notes:     Performance Improvement
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------

DATA: v_salesdocu TYPE   vbak-vbeln, " Sales Document
      v_doctyp    TYPE   tvak-auart, " Sales Document Type
      v_kunnr     TYPE   kunnr,      " Customer Number
*      Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      v_land1     TYPE   vbpa-land1, " Customer Country
      v_waerk     TYPE   vbak-waerk, " SD Document Currency
      v_ihrez     TYPE   vbkd-ihrez, " Your Reference
      v_konda     TYPE   vbkd-konda, " Price group (customer)
      v_betdt     TYPE   betdt,      " Payment Date
*      End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      v_matnum    TYPE   matnr, " Material Number
      v_ponum     TYPE   bstkd, " Customer purchase order number
      v_partne    TYPE   kunnr, " Customer Number
*       v_parvw     TYPE   parvw,      " Partner function
      v_vbegdat   TYPE   vbdat_veda, " Contract start date
      v_venddat   TYPE   vndat_veda, " Contract end date
      v_vkorg     TYPE   vkorg,      " Sales Organization
      v_vkbur     TYPE   vbak-vkbur. " Sales Office

TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              " Development ID
         param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         activate TYPE zconstactive,        " Activation indicator for constant
       END OF ty_constant,

       BEGIN OF ty_vbak,
         vbeln    TYPE vbeln_va,            " Sales Document
         auart    TYPE  auart,              " Sales Document Type
         waerk    TYPE  waerk,              " SD Document Currency
         vkorg    TYPE  vkorg,              " Sales Organization
         vkbur    TYPE  vkbur,              " Sales Office
         kunnr    TYPE  kunag,              " Sold-to party
         erdat    TYPE  erdat,              " Date on Which Record Was Created
         lifsk    TYPE  lifsk,              " Delivery Block
         faksk    TYPE  faksk,              " Billing block
         posnr    TYPE  posnr_va,           " Sales Document Item
         matnr    TYPE  matnr,              " Material Number
         arktx    TYPE arktx,               " Material Description
         netwr    TYPE  netwr_ap,           " Net value of the order item in document currency
         zzsubtyp TYPE  zsubtyp,            " Subscription Type
         zmeng    TYPE  dzmeng,             " Target quantity
         zieme    TYPE  dzieme,             " Target qty UoM
         mvgr1    TYPE  mvgr1,              " Material group 1
         mvgr2    TYPE  mvgr2,              " Material group 2
         mvgr3    TYPE  mvgr3,              " Material group 3
         mvgr4    TYPE  mvgr4,              " Material group 4
         mvgr5    TYPE  mvgr5,              " Material group 5
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
         vposn    TYPE posnr_va,   " Sales Document Item
         vbegdat  TYPE vbdat_veda, " Contract start date
         venddat  TYPE vndat_veda, " Contract end date
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         bukrs_vf TYPE bukrs_vf, " Company code to be billed
         vgbel    TYPE xref1,    " Document number of the reference document
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         zzlicgrp TYPE zlicgrp,    " License Group
         mwsbp    TYPE mwsbp,      " Tax amount in document currency
         werks    TYPE werks_d,    " Plant
         vtweg    TYPE vtweg,      " Distribution Channel
         spart    TYPE spart,      " Division
         vkuegru  TYPE vkgru_veda, " Reason for Cancellation of Contract
         uepos    TYPE uepos,      " Higher-level item in bill of material structures
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
         augru    TYPE augru,      " Order reason (reason for the business transaction)
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
       END OF ty_vbak,

       BEGIN OF ty_vbkd,
         vbeln   TYPE   vbeln, " Sales Document
         posnr   TYPE   posnr, " Sales Document Item
         konda   TYPE   konda, " Price group (customer)
         bstkd   TYPE   bstkd, " Customer purchase order number
         bsark   TYPE   bsark, " Customer purchase order type
         ihrez   TYPE   ihrez, " Your Reference
         kdkg1   TYPE   kdkg1, " Customer condition group 1
         kdkg2   TYPE   kdkg2, " Customer condition group 2
         kdkg3   TYPE   kdkg3, " Customer condition group 3
         kdkg4   TYPE   kdkg4, " Customer condition group 4
         kdkg5   TYPE   kdkg5, " Customer condition group 5
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         kdgrp   TYPE   kdgrp, " Customer group
         pltyp   TYPE   pltyp, " Price list type
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*        Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
         ihrez_e TYPE ihrez_e, " Ship-to party character
*        End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
       END OF ty_vbkd,

       BEGIN OF ty_zqtc_renwl_plan,
         vbeln       TYPE   vbeln_va,      " Sales Document
         posnr       TYPE   posnr_va,      " Sales Document Item
         activity    TYPE   zactivity_sub, " E095: Activity
         eadat       TYPE   eadat,         " Activity Date
         act_statu   TYPE   zact_status,   " Activity Status
         ren_sstatus TYPE   zren_status,   " Renewal Status
       END OF ty_zqtc_renwl_plan,

       BEGIN OF ty_mara,
         matnr        TYPE matnr,          " Material Number
         extwg        TYPE extwg,          " External Material Group
         ismtitle     TYPE ismtitle,       " Title
         ismmediatype TYPE ismmediatype,
       END OF ty_mara,

       BEGIN OF ty_zqtct_activity,
         activity   TYPE    zactivity_sub, " E095: Activity
         spras      TYPE    spras,         " Language Key
         activity_d TYPE    desc40,        " Description
       END OF ty_zqtct_activity,
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*       BEGIN OF ty_veda,
*         vbeln   TYPE   vbeln_va,           " Sales Document
*         vposn   TYPE   posnr_va,           " Sales Document Item
*         vbegdat TYPE   vbdat_veda,         " Contract start date
*         venddat TYPE   vndat_veda,         " Contract end date
*       END OF ty_veda,
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln, " Sales and Distribution Document Number
         posnr TYPE posnr, " Item number of the SD document
         parvw TYPE parvw, " Partner Function
         kunnr TYPE kunnr, " Customer Number
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         lifnr TYPE lifnr, " Account Number of Vendor or Creditor
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         adrnr TYPE adrnr, " Address
       END OF ty_vbpa,

*      Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
       BEGIN OF ty_knvv,
         kunnr TYPE kunnr,           " Customer Number
         vkorg TYPE vkorg,           " Sales Organization
         vtweg TYPE vtweg,           " Distribution Channel
         spart TYPE spart,           " Division
         zzfte TYPE zzfte,           " Number of FTE’s
       END OF ty_knvv,

       BEGIN OF ty_but0id,
         partner  TYPE bu_partner,   " Business Partner Number
         type     TYPE bu_id_type,   " Identification Type
         idnumber TYPE bu_id_number, " Identification Number
       END OF ty_but0id,
*      End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

       BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum, " Address number
         date_from  TYPE ad_date_fr, " Valid-from date - in current Release only 00010101 possible
         nation     TYPE ad_nation,  " Version ID for International Addresses
*        Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
*         name1      TYPE ad_name1,   " Name 1
         title      TYPE ad_title,   " Form-of-Address Key
         name1      TYPE ad_name1,   " Name 1
         name2      TYPE ad_name2,   " Name 2
         name3      TYPE ad_name3,   " Name 3
         name4      TYPE ad_name4,   " Name 4
*        End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
         deflt_comm TYPE ad_comm,    " Communication Method
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         city1      TYPE ad_city1,  " City
         post_code1 TYPE ad_pstcd1, " Postal Code
         country    TYPE land1,     " Country Key
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*        Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
         region     TYPE regio,     " Region (State, Province, County)
*        End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
       END OF ty_adrc,

*      Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
       BEGIN OF ty_adr6,
         addrnumber TYPE ad_addrnum,           " Address number
         persnumber TYPE ad_persnum,           " Person number
         date_from  TYPE ad_date_fr,           " Valid-from date - in current Release only 00010101 possible
         consnumber TYPE ad_consnum,           " Sequence Number
         smtp_addr  TYPE ad_smtpadr,           " E-Mail Address
       END OF ty_adr6,

       BEGIN OF ty_soc_acrnym,
         society        TYPE zzpartner2,       " Business Partner 2 or Society number
         society_acrnym TYPE zzsociety_acrnym, " Society Acronym
       END OF ty_soc_acrnym,

       BEGIN OF ty_pay_cards,
         vbeln TYPE vbeln,                     " Sales and Distribution Document Number
         fplnr TYPE fplnr,                     " Billing plan number / invoicing plan number
         fpltr TYPE fpltr,                     " Item for billing plan/invoice plan/payment cards
         ccins TYPE ccins,                     " Payment cards: Card type
         autwr TYPE autwr,                     " Payment cards: Authorized amount
         audat TYPE audat_cc,                  " Payment cards: Authorization date
         vtext TYPE vtext,                     " Description
       END OF ty_pay_cards,

       BEGIN OF ty_pay_quote,
         bukrs TYPE bukrs,                     " Company Code
         belnr TYPE belnr_d,                   " Accounting Document Number
         gjahr TYPE gjahr,                     " Fiscal Year
         buzei TYPE buzei,                     " Number of Line Item Within Accounting Document
         budat TYPE budat,                     " Posting Date in the Document
         blart TYPE blart,                     " Document Type
         xref1 TYPE xref1,                     " Business Partner Reference Key
       END OF ty_pay_quote,

       BEGIN OF ty_pay_inv,
         vbelv   TYPE vbeln_von,               " Preceding sales and distribution document
         posnv   TYPE posnr_von,               " Preceding item of an SD document
         vbeln   TYPE vbeln_nach,              " Subsequent sales and distribution document
         posnn   TYPE posnr_nach,              " Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,                 " Document category of subsequent document
         bukrs   TYPE bukrs,                   " Company Code
         belnr   TYPE belnr_d,                 " Accounting Document Number
         gjahr   TYPE gjahr,                   " Fiscal Year
         buzei   TYPE buzei,                   " Number of Line Item Within Accounting Document
         augdt   TYPE augdt,                   " Clearing Date
       END OF ty_pay_inv,
*      End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224

       BEGIN OF ty_jptmg0,
         med_prod    TYPE ismrefmdprod,  " Material no
         ismpubldate TYPE ismpubldate,   " Publication Date
         ismcopynr   TYPE ismheftnummer, " Copy Number of Media Issue
         ismnrinyear TYPE ismnrimjahr,   " Issue Number (in Year Number)
         ismyearnr   TYPE ismjahrgang,   " Media issue year number
       END   OF ty_jptmg0,

*      Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
       BEGIN OF ty_jksesched,
         vbeln            TYPE vbeln,            " Sales and Distribution Document Number
         posnr            TYPE posnr,            " Item number of the SD document
         issue            TYPE ismmatnr_issue,   " Media Issue
         product          TYPE ismmatnr_product, " Media Product
         sequence         TYPE jmsequence,       " IS-M: Sequence
         xorder_created   TYPE jmorder_created,  " IS-M: Indicator Denoting that Order Was Generated
         shipping_date    TYPE jshipping_date,   " IS-M: Delivery Date
         ismcopynr        TYPE ismheftnummer,    " Copy Number of Media Issue
         ismnrinyear      TYPE ismnrimjahr,      " Issue Number (in Year Number)
         ismyearnr        TYPE ismjahrgang,      " Media issue year number
         ismarrivaldateac TYPE ismanlftagi,      " Actual Goods Arrival Date
       END OF ty_jksesched,
*      End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*--*BOC OTCM-25936 Additional fields PRABHU 11/26/2020
       BEGIN OF ty_jkseflow,
         nip            TYPE guid_16,           "GUID in 'RAW' format
         contract_vbeln	TYPE jvbelncontract,    "Contract Number
         contract_posnr	TYPE jposnrcontract,    "Item Number in Contract
         issue          TYPE ismmatnr_issue,    "Media Issue
         vbelnorder	    TYPE vbeln,             "Sales and Distribution Document Number
         posnrorder	    TYPE posnr,              "Item number of the SD document
       END OF ty_jkseflow,
       BEGIN OF ty_lips,
         vbeln TYPE vbeln_vl,                    "Delivery
         posnr TYPE posnr_vl,                    "Delivery Item
         vgbel TYPE vgbel,                       "Ref.doc
         vgpos TYPE vgpos,                       "Ref.doc Item
       END OF ty_lips,
*--*EOC OTCM-25936 Additional fields PRABHU 11/26/2020
       BEGIN OF ty_final,
         vbeln             TYPE vbeln_va,      " Sales Document
*        Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         erdat             TYPE erdat,         " Date on Which Record Was Created
*        End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         auart             TYPE auart,         " Sales Document Type
         vkorg             TYPE char27,        " Sales Organization
         vkbur             TYPE char27,        " Sales Office
         posnr             TYPE posnr_va,      " Sales Document Item
         subtyp            TYPE zsubtyp,       " Subscription Type
         zzsubtyp          TYPE char20,        " Subscription Type with text
         konda             TYPE char25,        " Price group (customer)
         bstkd             TYPE bstkd,         " Customer purchase order number
         bsark             TYPE char27,        " Customer purchase order type
         ihrez             TYPE ihrez,         " Your Reference
         matnr             TYPE matnr,         " Material Number
         arktx             TYPE arktx,         " Material description
         extwg             TYPE extwg,         " External Material Group
         ismtitle          TYPE ismtitle,      " Title
         ismmediatype      TYPE char20,        " Mediatype
         netwr             TYPE netwr_ak,      " Net value of the order item in document currency
         waerk             TYPE waerk,         " SD Document Currency
         activity          TYPE zactivity_sub, " E095: Activity
         eadat             TYPE eadat,         " Activity Date
         act_statu         TYPE zact_status,   " Activity Status
         ren_sstatus       TYPE char20,        " Renewal Status
         activity_d        TYPE desc40,        " Description
         kunnr_sp          TYPE kunnr,         " Customer Number
         name1_sp          TYPE ad_name1,      " Name 1
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         land1_sp          TYPE land1,      " Country Key
         kunnr_bp          TYPE kunnr,      " Customer Number (Bill-To Party)
         name1_bp          TYPE full_name,  " Name (Bill-To Party)
         addr1_bp          TYPE lines,      " Address Line 1 (Bill-To Party)
         addr2_bp          TYPE lines,      " Address Line 2 (Bill-To Party)
         addr3_bp          TYPE lines,      " Address Line 3 (Bill-To Party)
         addr4_bp          TYPE lines,      " Address Line 4 (Bill-To Party)
         city1_bp          TYPE ad_city1,   " City (Bill-To Party)
         pstlz_bp          TYPE pstlz,      " Postal Code (Bill-To Party)
         land1_bp          TYPE land1,      " Country (Bill-To Party)
         email_bp          TYPE ad_smtpadr, " E-Mail Address (Bill-To Party)
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         kunnr_sh          TYPE kunnr,      " Customer Number
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*        Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
*         name1_sh     TYPE full_name,  " Name (Ship-To Party) "--
         title_sh          TYPE ad_title,   " Form-of-Address Key
         title_txt_sh      TYPE ad_titletx, " Title text
         name1_sh          TYPE ad_name1,   " Name 1
         name2_sh          TYPE ad_name2,   " Name 2
         name3_sh          TYPE ad_name3,   " Name 3
         name4_sh          TYPE ad_name4,   " Name 4
*        End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
*        Begin of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
         ihrez_e           TYPE ihrez_e,    " Ship-to party character
*        End of Change:RITM0080792:NPALLA:31-Jan-2019:ED1K909473
         addr1_sh          TYPE lines,      " Address Line 1 (Ship-To Party)
         addr2_sh          TYPE lines,      " Address Line 2 (Ship-To Party)
         addr3_sh          TYPE lines,      " Address Line 3 (Ship-To Party)
         addr4_sh          TYPE lines,      " Address Line 4 (Ship-To Party)
         city1_sh          TYPE ad_city1,   " City (Ship-To Party)
         pstlz_sh          TYPE pstlz,      " Postal Code (Ship-To Party)
*        Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         region_sh         TYPE regio,      " Region
         region_txt_sh     TYPE bezei20,      " Region
*        End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         land1_sh          TYPE land1,      " Country (Ship-To Party)
*        Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         landx_sh          TYPE landx,      " Country Name
*        End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
         email_sh          TYPE ad_smtpadr, " E-Mail Address (Ship-To Party)
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         kunnr             TYPE kunnr,         " Customer Number
         name1             TYPE ad_name1,      " Name 1
         commm             TYPE ad_comm,       " Communication Method
         deflt_comm        TYPE char26,        " Communication Method text
         vbegdat           TYPE vbdat_veda,    " Contract start date
         venddat           TYPE vndat_veda,    " Contract end date
         parvw             TYPE parvw,         " Partner Function
         zmeng             TYPE dzmeng,        " Target quantity
         zieme             TYPE dzieme,        " Target qty UoM
         mvgr1             TYPE char46,        " Material group 1
         mvgr2             TYPE char46,        " Material group 2
         mvgr3             TYPE char46,        " Material group 3
         mvgr4             TYPE char46,        " Material group 4
         mvgr5             TYPE char46,        " Material group 5
         kdkg1             TYPE char25,        " Customer condition group 1
         kdkg2             TYPE char25,        " Customer condition group 2
         kdkg3             TYPE char25,        " Customer condition group 3
         kdkg4             TYPE char25,        " Customer condition group 4
         kdkg5             TYPE char25,        " Customer condition group 5
         volume            TYPE ismheftnummer, " Material volume
*        Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
         volume_yr         TYPE ismjahrgang,      " Material volume year
         soc_acrnym        TYPE zzsociety_acrnym, " Society Acronym
         cc_type           TYPE vtext,            " Credit Card Type
         cc_pay_amt        TYPE autwr,            " Payment amount (By credit card)
         pay_date          TYPE betdt,            " Payment Date
*        End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*        Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         pay_status        TYPE char10,       " Payment Status
         kdgrp             TYPE char25,       " Customer group
         pltyp             TYPE char25,       " Price list type
         zzlicgrp          TYPE zlicgrp,      " License Group
         mwsbp             TYPE mwsbp,        " Tax amount in document currency
         zzfte             TYPE zzfte,        " Number of FTE’s
         canc_resn         TYPE char45,       " Reason for Cancellation of Contract
         issues_sent       TYPE i,            " Issues - Sent
         issues_due        TYPE i,            " Issues - Due
         cmn_cust_id       TYPE bu_id_number, " Common Customer ID
         start_issue       TYPE char20,       " Start Issue
         last_issue        TYPE char20,       " Last Issue
*--*BOC OTCM-25936 Additional fields PRABHU 11/26/2020
         media_start_issue TYPE ismmatnr_issue,
         media_last_issue  TYPE ismmatnr_issue,
*--*EOC OTCM-25936 Additional fields PRABHU 11/26/2020
         rep_year          TYPE ajahr_kk,     " Reporting year
         uepos             TYPE uepos,        " Higher-level item in bill of material structures
         bill_doc          TYPE vbeln_vf,     " Billing Document
         frwd_agnt         TYPE lifnr,        " Forwarding Agent
         name1_fa          TYPE full_name,    " Name (Forwarding Agent)
         addr1_fa          TYPE lines,        " Address Line 1 (Forwarding Agent)
         addr2_fa          TYPE lines,        " Address Line 2 (Forwarding Agent)
         addr3_fa          TYPE lines,        " Address Line 3 (Forwarding Agent)
         addr4_fa          TYPE lines,        " Address Line 4 (Forwarding Agent)
         city1_fa          TYPE ad_city1,     " City (Forwarding Agent)
         pstlz_fa          TYPE pstlz,        " Postal Code (Forwarding Agent)
         land1_fa          TYPE land1,        " Country (Forwarding Agent)
*        End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
         lifsk             TYPE char27, " Delivery block
         faksk             TYPE char27, " Billing block
* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
         augru             TYPE augru,  " Order reason (reason for the business transaction)
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473

* BOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
         bezei             TYPE char50, " AUGRU+Description
* EOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
       END OF ty_final.

TYPES: tt_parvw_r TYPE RANGE OF parvw. " Partner Function

DATA: i_vbak            TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0,
      i_vbkd            TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,
      i_zqtc_renwl_plan TYPE STANDARD TABLE OF ty_zqtc_renwl_plan INITIAL SIZE 0,
      i_zqtct_activity  TYPE STANDARD TABLE OF ty_zqtct_activity INITIAL SIZE 0,
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*      i_veda            TYPE STANDARD TABLE OF ty_veda INITIAL SIZE 0,
      i_veda            TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0,
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
      i_vbpa            TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,
      i_vbpa_za         TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,
      i_adrc            TYPE STANDARD TABLE OF ty_adrc INITIAL SIZE 0,
*     Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
      i_adr6            TYPE STANDARD TABLE OF ty_adr6       INITIAL SIZE 0,
      i_soc_acrnym      TYPE STANDARD TABLE OF ty_soc_acrnym INITIAL SIZE 0,
      i_pay_cards       TYPE STANDARD TABLE OF ty_pay_cards  INITIAL SIZE 0,
      i_pay_quote       TYPE STANDARD TABLE OF ty_pay_quote  INITIAL SIZE 0,
      i_pay_inv         TYPE STANDARD TABLE OF ty_pay_inv    INITIAL SIZE 0,
*     End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      i_knvv            TYPE STANDARD TABLE OF ty_knvv       INITIAL SIZE 0,
      i_but0id          TYPE STANDARD TABLE OF ty_but0id     INITIAL SIZE 0,
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      i_mara            TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
      i_final           TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
      i_fcat            TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
      i_constant        TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
      i_tvm1            TYPE STANDARD TABLE OF tvm1t INITIAL SIZE 0,     " Material pricing group 1: Description
      i_tvm2            TYPE STANDARD TABLE OF tvm2t INITIAL SIZE 0,     " Material Pricing Group 2: Description
      i_tvm3            TYPE STANDARD TABLE OF tvm3t INITIAL SIZE 0,     " Material pricing group 3: Description
      i_tvm4            TYPE STANDARD TABLE OF tvm4t INITIAL SIZE 0,     " Material pricing group 4: Description
      i_tvm5            TYPE STANDARD TABLE OF tvm5t INITIAL SIZE 0,     " Material pricing group 5: Description
      i_tvkgg           TYPE STANDARD TABLE OF tvkggt INITIAL SIZE 0,    " Texts for Customer Condition Groups (Customer Master)
      i_tjpmedtpt       TYPE STANDARD TABLE OF tjpmedtpt INITIAL SIZE 0, " Text Table for Media Types
      i_t176t           TYPE STANDARD TABLE OF t176t INITIAL SIZE 0,     " Sales Documents: Customer Order Types: Texts
      i_jptmg0          TYPE STANDARD TABLE OF ty_jptmg0 INITIAL SIZE 0,
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      i_jksesched       TYPE STANDARD TABLE OF ty_jksesched INITIAL SIZE 0, " IS-M: Media Schedule Lines
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*--*BOC OTCM-25936 Additional fields PRABHU 11/26/2020
     i_jkseflow TYPE STANDARD TABLE OF ty_jkseflow,
     i_lips TYPE STANDARD TABLE OF ty_lips,
*--*EOC OTCM-25936 Additional fields PRABHU 11/26/2020
      i_t188t           TYPE STANDARD TABLE OF t188t INITIAL SIZE 0, " Conditions: Groups for Customer Classes: Texts
      i_tvkot           TYPE STANDARD TABLE OF tvkot INITIAL SIZE 0, " Organizational Unit: Sales Organizations: Texts
      i_tvkbt           TYPE STANDARD TABLE OF tvkbt INITIAL SIZE 0, " Organizational Unit: Sales Offices: Texts
      i_tsact           TYPE STANDARD TABLE OF tsact INITIAL SIZE 0, " Communication Method Description (Business Address Services)
      i_tvlst           TYPE STANDARD TABLE OF tvlst INITIAL SIZE 0, " Deliveries: Blocking Reasons/Scope: Texts
      i_tvfst           TYPE STANDARD TABLE OF tvfst INITIAL SIZE 0, " Billing : Blocking Reason Texts
*     Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      i_t151t           TYPE STANDARD TABLE OF t151t INITIAL SIZE 0, " Customers: Customer groups: Texts
      i_t189t           TYPE STANDARD TABLE OF t189t INITIAL SIZE 0, " Conditions: Price List Categories: Texts
      i_tvkgt           TYPE STANDARD TABLE OF tvkgt INITIAL SIZE 0, " Sales Documents: Reasons for Cancellation: Texts
*     End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
      i_subs            TYPE TABLE OF dd07v WITH HEADER LINE. " Generated Table for View

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
DATA:
  st_variant            TYPE disvariant. " Layout (External Use)
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419

CONSTANTS : c_posnr_hd TYPE posnr     VALUE '000000', " Item number of the SD document
            c_sign_i   TYPE s_sign    VALUE 'I',      "Sign: (I)nclude
            c_opti_eq  TYPE s_option  VALUE 'EQ',     "Option: (BET)ween
* BOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
            c_opti_bt  TYPE s_option  VALUE 'BT', "Option: (BET)ween
            c_opti_le  TYPE s_option  VALUE 'LE', "Option: (BET)ween
            c_opti_ge  TYPE s_option  VALUE 'GE', "Option: (BET)ween
* EOI by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
            c_hyphn    TYPE char1     VALUE '-', " Hyphn of type CHAR1
*                 Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
            c_wntch_id TYPE bu_id_type VALUE 'ZWINT'. "Wintouch ID
*                 End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* Begin of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215
DATA: i_tsad3t  TYPE STANDARD TABLE OF tsad3t,
      st_tsad3t TYPE tsad3t,
      i_t005t   TYPE STANDARD TABLE OF t005t   INITIAL SIZE 0,
      i_t005u   TYPE STANDARD TABLE OF t005u,
      st_t005u  TYPE t005u.
* End of Change:RITM0080792:NPALLA:26-DEC-2018:ED1K909215"

* BOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
DATA: i_tvaut  TYPE STANDARD TABLE OF tvaut,  " Sales Documents: Order Reasons: Texts
      st_tvaut TYPE tvaut.
* BOI by AKHADIR on 05-Jul-2019 for DM-1995 TR-ED2K915605
