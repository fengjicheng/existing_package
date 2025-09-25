*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_FEED_PRC_DISC_I0336_TOP (Global Data Decl)
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Anirban Saha
* CREATION DATE:       05/01/2017
* OBJECT ID:           I0336
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910805
* REFERENCE NO: ERP-6215/6217
* DEVELOPER: WRITTICK ROY
* DATE:  02/09/2018
* DESCRIPTION: Populate Title and Description from Basic Data Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910805
* REFERENCE NO: ERP-6557
* DEVELOPER: WRITTICK ROY
* DATE:  02/09/2018
* DESCRIPTION: For CSV file, include Description within Quotes, so that
*             "Commas" within Description should not be treated as
*             field separator
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908349/ED2K913279
* REFERENCE NO:  SCTASK0036922
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  09/03/2018
* DESCRIPTION:The country codes are truncated
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922066
* REFERENCE NO:  OTCM-25238
* DEVELOPER: NPOLINA
* DATE:  19/02/2021
* DESCRIPTION: Rolling title controlled by specific period
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
TABLES:
  mara,                                                         "General Material Data
  komk,                                                         "Communication Header for Pricing
  komv,                                                         "Pricing Communications-Condition Record
  adr6.                                                         "E-Mail Addresses (Business Address Services)

DATA : r_cl_gui_alv_grid         TYPE REF TO cl_gui_alv_grid,
       r_cl_gui_custom_container TYPE REF TO cl_gui_custom_container,
       v_layout                  TYPE lvc_s_layo,
       v_text                    TYPE smp_dyntxt,
       i_fieldcat                TYPE lvc_t_fcat,
       w_fieldcat                LIKE LINE OF i_fieldcat,
       ok_code                   TYPE sy-ucomm.

TYPES:

  BEGIN OF ty_final,
    kappl        TYPE kappl,                                       "Application
    kschl        TYPE kscha,                                       "Condition type
    pltyp        TYPE pltyp,                                       "Price list type
    pltyd        TYPE text20,                                      "Price list type description
    kdgrp        TYPE kdgrp,                                       "Customer group
    matnr        TYPE matnr,                                       "Material Number
    datbi        TYPE kodatbi,                                     "Validity end date of the condition record
    datab        TYPE kodatab,                                     "Validity start date of the condition record
    knumh        TYPE knumh,                                       "Condition record number
    mstae        TYPE mstae,                                       "Cross-Plant Material Status
    mtart        TYPE mtart,                                       "Material Type
    extwg        TYPE extwg,                                       "External Material Group
*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    title        TYPE string,                                      "Title
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   title        TYPE text200,                                     "Title
*   End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    mediatype	   TYPE ismmediatype,                                "Media Type
    ismcopynr    TYPE ismheftnummer,                               "Volume from / to (Copy no)
    ismsubtitle3 TYPE ismsubtitle3,                                "SUBTITLE 3
    ismpubldate  TYPE ismpubldate,                                 "Publication Date
*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    maktx        TYPE string,                                      "Material Description (Short Text)
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   maktx        TYPE maktx,                                       "Material Description (Short Text)
*   End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    kopos        TYPE kopos,                                       "Sequential number of the condition
    klfn1        TYPE klfn1,                                       "Current number of the line scale
    konwa        TYPE konwa,                                       "Rate unit (currency or percentage)
    csign        TYPE char1,                                       "Currency Sign
    knuma_ag     TYPE kosrt,                                       "Price type
    kstbm        TYPE kstbm,                                       "Condition scale quantity
    kbetr        TYPE kbetr_kond,                                  "ZLPR
    npadd        TYPE kbetr_kond,                                  "ZLPR - ZAGD
    npapp        TYPE kbetr_kond,                                  "ZLPR - ZDDP
    npadp        TYPE kbetr_kond,                                  "ZLPR - (ZAGD + ZDDP)
    pzagd        TYPE kbetr_kond,                                  "ZAGD %
    pzddp        TYPE kbetr_kond,                                  "ZDDP %
    fzagd        TYPE char1,                                       "Flag for ZAGD Discount
    fzddp        TYPE char1,                                       "Flag for ZDDP Discount
    bom_info     TYPE char1,                                       "BOM Info - (Header) / (C)omponent / (N)o
    hdr_comp     TYPE char250,                                     "BOM Header / Components
    country      TYPE string,   "char200,                          "Countries applicable  *+ <HIPATEL> <SCTASK0036922> <ED1K908349>
    seqmedia     TYPE char1,                                       "Sequence for media type
    seqpltyp     TYPE char1,                                       "Sequesnce for pltyp
    scale        TYPE char1,                                       "Scale
    excld        TYPE char1,                                       "Exclude product and price
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
    alpha_sep    TYPE char1,                                       "Alphabetical letter separator
    maktx_sub    TYPE text150,                                     "Material Description-2
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
* Begin by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
    mat_desc     TYPE string,                                      " BOM Header / Components Description
    excld_prc    TYPE flag,                                        " Exclude Pricing
    price_nm     TYPE flag,                                        " Price Not Maintained
* End by amohammed on 04/09/2020 - ERPM-6882 - ED2K917919
  END   OF ty_final,
  tt_final TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,

  BEGIN OF ty_bom_detl,
    idnrk     TYPE idnrk,                                       "BOM component
    stlnr     TYPE stnum,                                       "Bill of material
    matnr_hdr TYPE matnr,                                       "Material Number
    extwg     TYPE extwg,                                       "External Material Group
    mtart     TYPE mtart,                                       "Material Type
    extwg_cmp TYPE extwg,                                       "External Material Group (Component)
  END OF ty_bom_detl,
  tt_bom_detl TYPE STANDARD TABLE OF ty_bom_detl INITIAL SIZE 0
          WITH NON-UNIQUE SORTED KEY extwg COMPONENTS extwg_cmp extwg,

  BEGIN OF ty_final_csv,
    mtart       TYPE char1,         "Multi journal package
    matnr       TYPE matnr,         "Product code
    packg       TYPE matnr,         "Package
    kbetr       TYPE kbetr_kond,    "Standard price
    npadd       TYPE kbetr_kond,    "Agent price
    pltyp       TYPE text20,         "Price list type
    country     TYPE string,         "char100,   "Countries applicable "*+ <HIPATEL> <SCTASK0036922>
    identcode   TYPE ismidentcode,  "Identification Code ISSN
    landx50     TYPE landx50,       "Imprint
*   Begin of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    maktx       TYPE string,        "Journal
*   End   of ADD:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   Begin of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
*   maktx       TYPE maktx,         "Journal
*   End   of DEL:ERP-6215/6217:WROY:09-Feb-2018:ED2K910805
    datab       TYPE kodatab,       "Package date to
    datbi       TYPE kodatbi,       "Package date from
    ismcopynf   TYPE ismheftnummer, "Volume from
    ismcopynt   TYPE ismheftnummer, "Volume to
    ismnrinyear TYPE ismnrimjahr,   "No of issues
    codis       TYPE herkl,         "Country od dispatch
    prdsc       TYPE char12,         "Payment rate description
    mediatype   TYPE char20,        "Media
    konwa       TYPE konwa,         "Currency
    knumh       TYPE knumh,         "Condition record number
    seqmedia    TYPE char1,         "Sequence for media type
    seqpltyp    TYPE char1,         "Sequesnce for pltyp
    ltype       TYPE char1,         "Type of line  (Normal or ZDDP
    extwg       TYPE extwg,         "Journal grp code
    klfn1       TYPE klfn1,
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
    alpha_sep   TYPE char1,                                       "Alphabetical letter separator
    maktx_sub   TYPE text150,                                     "Material Description-2
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
  END OF ty_final_csv,
  tt_csv TYPE STANDARD TABLE OF ty_final_csv,

  BEGIN OF ty_csv_op,
    mtart       TYPE string,  "Multi journal package
    matnr       TYPE string,  "Product code
    packg       TYPE string,  "Package
    identcode   TYPE string,  "Identification Code ISSN
    landx50     TYPE string,  "Imprint
    maktx       TYPE string,  "Journal
    datab       TYPE string,  "Package date to
    datbi       TYPE string,  "Package date from
    ismcopynf   TYPE string,  "Volume from
    ismcopynt   TYPE string,  "Volume to
    ismnrinyear TYPE string,  "No of issues
    codis       TYPE string,  "Country od dispatch
    prdsc       TYPE string,  "Payment rate description
    mediatype   TYPE string,  "Media
    konwa       TYPE string,  "Currency
    kbetr       TYPE string,  "Standard price
    npadd       TYPE string,  "Agent price
    pltyp       TYPE string,  "Price list type
    country     TYPE string,  "Countries applicable
    knumh       TYPE string,  "Condition record number
    ltype       TYPE string,  "Line type
    extwg       TYPE string,  "JGC
    klfn1       TYPE string,
  END OF ty_csv_op,

  BEGIN OF ty_issn,
    extwg        TYPE extwg,
    ismmediatype TYPE ismmediatype,
    matnr        TYPE matnr,
    idcodetype   TYPE ismidcodetype,
    identcode    TYPE ismidentcode,
  END   OF ty_issn,
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
  BEGIN OF ty_constant,
    param1      TYPE rvari_vnam,                                "ABAP: Name of variant variable
    param2      TYPE rvari_vnam,                                "ABAP: Name of variant variable
    serial_numb TYPE tvarv_numb,                                "ABAP: Current selection number
    sign        TYPE tvarv_sign,                                "ABAP: ID: I/E (include/exclude values)
    opti        TYPE tvarv_opti,                                "ABAP: Selection option (EQ/BT/CP/...)
    low         TYPE salv_de_selopt_low,                        "Lower Value of Selection Condition
    high        TYPE salv_de_selopt_high,                       "Upper Value of Selection Condition
  END OF ty_constant,
  tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>


DATA:
  i_final     TYPE tt_final,
  i_issn      TYPE STANDARD TABLE OF ty_issn,
  i_csv       TYPE tt_csv,
  i_csv_op    TYPE STANDARD TABLE OF ty_csv_op,
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
  i_constants TYPE tt_constant,  "Application Constants
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

  w_final     TYPE ty_final,
  w_issn      TYPE ty_issn.

CONSTANTS:
  c_comma          TYPE char1        VALUE ',',                      "Separator: Comma
  c_dot            TYPE char1        VALUE '.',                      "Separator: dot
  c_msgty_i        TYPE symsgty      VALUE 'I',                      "Message Type: (I)nformation
  c_flag_n         TYPE char1        VALUE 'N',                      "Flag: (N)o
  c_flag_c         TYPE char1        VALUE 'C',                      "Flag: BOM (C)onponent
  c_flag_h         TYPE char1        VALUE 'H',                      "Flag: BOM (H)eader
  c_bom_us_sd      TYPE stlan        VALUE '5',                      "BOM Usage: Sales and Distribution
  c_sign_i         TYPE tvarv_sign   VALUE 'I',                      "ID: (I)nclude
  c_opti_eq        TYPE tvarv_opti   VALUE 'EQ',                     "Selection option: (EQ)uals
  c_mt_zsbe        TYPE mtart        VALUE 'ZSBE',                   "Material Type: ZSBE
  c_mt_zwol        TYPE mtart        VALUE 'ZWOL',                   "Material Type: ZWOL
  c_mt_zmjl        TYPE mtart        VALUE 'ZMJL',                   "Material Type: ZMJL
  c_mt_zmmj        TYPE mtart        VALUE 'ZMMJ',                   "Material Type: ZMMJ
  c_ct_zlpr        TYPE mtart        VALUE 'ZLPR',                   "Condition Type: ZLPR
  c_ct_zagd        TYPE mtart        VALUE 'ZAGD',                   "Condition Type: ZAJD
  c_ct_zddp        TYPE mtart        VALUE 'ZDDP',                   "Condition Type: ZDDP
  c_ch_jpsnt       TYPE atnam        VALUE 'JPSNT',                  "Characteristic: New Start Title
  c_ch_jpsmw       TYPE atnam        VALUE 'JPSMW',                  "Characteristic: Merged With
  c_media_ph       TYPE ismmediatype VALUE 'PH',                     "Mediatype: Print
  c_media_p        TYPE char1        VALUE 'P',                      "Mediatype: Print
  c_media_di       TYPE ismmediatype VALUE 'DI',                     "Mediatype: Digital/Electronic
  c_media_d        TYPE char1        VALUE 'D',                      "Mediatype: Digital/Electronic
  c_media_e        TYPE char1        VALUE 'E',                      "Mediatype: Digital/Electronic
  c_media_mm       TYPE ismmediatype VALUE 'MM',                     "Mediatype: Combo
  c_media_c        TYPE char1        VALUE 'C',                      "Mediatype: Combo
  c_slash          TYPE char1        VALUE '/',                      "Separator /
  c_hyphn          TYPE char1        VALUE '-',                      "Separator -
  c_small          TYPE char1        VALUE 'S',                      "Scale : small
  c_medium         TYPE char1        VALUE 'M',                      "Scale : medium
  c_large          TYPE char1        VALUE 'L',                      "Scale : large
  c_small1         TYPE char7        VALUE '(SMALL)',                "Scale : small
  c_medium1        TYPE char8        VALUE '(MEDIUM)',               "Scale : medium
  c_large1         TYPE char7        VALUE '(LARGE)',                "Scale : large
  c_id_c           TYPE char1        VALUE 'C',                      "Identifier C
  c_id_d           TYPE char1        VALUE 'D',                      "Identifier D
  c_seq_1          TYPE char1        VALUE '1',                      "Sequence: 1
  c_seq_2          TYPE char1        VALUE '2',                      "Sequence: 2
  c_seq_3          TYPE char1        VALUE '3',                      "Sequence: 3
  c_seq_4          TYPE char1        VALUE '4',                      "Sequence: 4
  c_pltyp_p1       TYPE pltyp        VALUE 'P1',                     "PLTYP: P1
  c_pltyp_p2       TYPE pltyp        VALUE 'P2',                     "PLTYP: P2
  c_pltyp_p3       TYPE pltyp        VALUE 'P3',                     "PLTYP: P3
  c_pltyp_p4       TYPE pltyp        VALUE 'P4',                     "PLTYP: P4
  c_ddp            TYPE char3        VALUE 'DDP',                    "DDP
  c_elec           TYPE char6        VALUE 'Online',                 "Electronic media
*Begin of Del-Anirban-09.11.2017-ED2K908468-Defect 4392
*  c_print          TYPE char5        VALUE 'PRINT',                  "Print
*End of Del-Anirban-09.11.2017-ED2K908468-Defect 4392
*Begin of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
  c_print          TYPE char5        VALUE 'Print',                  "Print
*End of Add-Anirban-09.11.2017-ED2K908468-Defect 4392
  c_pne            TYPE char14       VALUE 'Print & Online',         "P+E
  c_m_typ_j        TYPE edi_mestyp   VALUE 'ZPDM_PRICE_FEED_ONIX',   "Message Type
  c_i_typ_j        TYPE edi_idoctp   VALUE 'ZPDMB_ONIX_FEED01',      "Basic type
  c_dir_out        TYPE edi_direct   VALUE '1',                      "Direction for IDoc (Outbound)
  c_sys_sap        TYPE char3        VALUE 'SAP',                    "Sap of type CHAR3
  c_p_typ_l        TYPE edi_sndprt   VALUE 'LS',                     "Partner Type: Logical Syatem (LS)
  c_seg_hdr        TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_HEADER',         "Segment type: Z1PDM_ONIX_HEADER
  c_subs_prod      TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_SUBS_PRODUCT',   "Segment type: Z1PDM_ONIX_SUBS_PRODUCT
  c_subs_prod_id   TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_SUBS_PROD_ID',   "Segment type: Z1PDM_ONIX_SUBS_PROD_ID
  c_serial_version TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_SERIAL_VERSION', "Segment type: Z1PDM_ONIX_SERIAL_VERSION
  c_version_scope  TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_VERSION_SCOPE',  "Segment type: Z1PDM_ONIX_VERSION_SCOPE
  c_catalog_price  TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_CATALOG_PRICE',  "Segment type: Z1PDM_ONIX_CATALOG_PRICE
  c_price_qualf    TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_PRICE_QUALF',    "Segment type: Z1PDM_ONIX_PRICE_QUALF
  c_total_price    TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_TOTAL_PRICE',    "Segment type: Z1PDM_ONIX_TOTAL_PRICE
  c_trailer        TYPE edilsegtyp   VALUE 'Z1PDM_ONIX_TRAILER',        "Segment type: Z1PDM_ONIX_TRAILER
*BOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
  c_zlps           TYPE kschl        VALUE 'ZLPS',                      "Condition Type: ZLPS
*EOC <HIPATEL> <CR-6335> <ED2K912198> <05/31/2018>
*BOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>
  c_dev_i0336      TYPE zdevid       VALUE 'I0336',                    "Development ID
*EOC <HIPATEL> <INC0215495> <ED1K908742> <10/15/2018>

* Begin by amohammed on 04/10/2020 - ERPM-6882 - ED2K917919
  c_appl_sls       TYPE kappl        VALUE 'V',                            " Application (Sales/Distribution)
  c_curr_usd       TYPE waers        VALUE 'USD',                          " Currency (USD)
  c_inst_rate      TYPE knuma_ag     VALUE 'F',                            " Sales deal: Institutional
  c_jan_one        TYPE i            VALUE '01',                     " 1st jan
  c_dec            TYPE i            VALUE '12',                     " December
  c_month_end      TYPE i            VALUE '31'.                     " End of the Month
* End by amohammed on 04/10/2020 - ERPM-6882 - ED2K917919
* Begin by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
TYPES : BEGIN OF ty_issue,
          med_prod     TYPE ismrefmdprod,
          mpg_lfdnr    TYPE mpg_lfdnr,
          ismcopynr    TYPE ismheftnummer,
          ismnrinyear  TYPE ismnrimjahr,
          ismyearnr    TYPE ismjahrgang,
          extwg        TYPE extwg,
          ismmediatype TYPE ismmediatype,
        END   OF ty_issue,
        BEGIN OF ty_final_bom,
          stlnr        TYPE stnum,
          idnrk        TYPE idnrk,
          extwg        TYPE extwg,
          ismmediatype TYPE ismmediatype,
          sequence     TYPE char1,
          matnr        TYPE matnr,
          mtart        TYPE mtart,
          mat_extwg    TYPE extwg,
          media        TYPE ismmediatype,
          sequence1    TYPE char1,
          ismpubltype  TYPE ismpubltype,
          priceex      TYPE c,
        END   OF ty_final_bom,
        tt_issue TYPE STANDARD TABLE OF ty_issue INITIAL SIZE 0.
* End by amohammed on 04/22/2020 - ERPM-6882 - ED2K917919
 DATA:
         v_low_month(2)  TYPE c,       " NPOLINA 19/02/2021 ED2K922066 OTCM-25238
         v_high_month(2) TYPE c.       " NPOLINA 19/02/2021 ED2K922066 OTCM-25238
