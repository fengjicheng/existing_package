*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_FEED_PRC_DISC_I0225_TOP (Global Data Decl)
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       04/12/2017
* OBJECT ID:           I0225
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 490
* DEVELOPER: Writtick Roy
* DATE:  05/25/2017
* DESCRIPTION: 1. Update calculation logic for Librarian XLSX file to
* reflect list and net price (after ZSD1 discount/surcharge applied).
*              2. List Price should come from specific Condition table
* (A911 or A913) depending on Relationship Category from ZSD1
*              3. Populate 2 additional IDOC fields for Soceity Number
* and Relationship Category
*              4. Retrieve Material Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 523
* DEVELOPER: Writtick Roy
* DATE:  06/22/2017
* DESCRIPTION: 1. Add All ISSNs in the XML / IDOC data (Print ISSN,
* Online ISSN, Print+Online ISSN)
*              2. Add Indicator for Multi-Journal Products
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908, ED2K907257
* REFERENCE NO:  CR# 565
* DEVELOPER: Writtick Roy
* DATE:  07/08/2017
* DESCRIPTION: 1. Additional Exclusion Criteria - "Pricing Only" and
* "Pricing and Products".
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907749
* REFERENCE NO:  CR# 627
* DEVELOPER: Writtick Roy
* DATE:  08/04/2017
* DESCRIPTION: 1. Populated Print and Online ISSNs for Multi-Media BOMs
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908487
* REFERENCE NO:  CR#652
* DEVELOPER: Writtick Roy
* DATE:  09/13/2017
* DESCRIPTION: 1. Introduce new Condition Table A974 (it will have
* similar functionality as with A913, but Customer Group will be
* defaulted to 01-Individual)
*              2. For records from A974, List Price will not be
* displayed; only Net Price (after Discounts) will be considered
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912264
* REFERENCE NO: ERP-6792
* DEVELOPER: Writtick Roy
* DATE:  06/11/2018
* DESCRIPTION: Membership Dues Table: Replace External Material Group
*              with Material Number
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912278
* REFERENCE NO:  CR#6341
* DEVELOPER: Rahul Tripathi
* DATE:  06/14/2018
* DESCRIPTION: Net Price for Multiyear  discount cond type ZMYS
*              "CR6341 RTR20180414 ED2K912278
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912466
* REFERENCE NO:  ERP-6324
* DEVELOPER: Writtick Roy
* DATE:  06/28/2018
* DESCRIPTION: Librarian File - Include Components of Multi-Journal BOM
*              even when the Price is not maintained for the Component
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K908211 /  ED2K912991
* REFERENCE NO: INC0207303
* DEVELOPER:    Himanshu Patel
* DATE:         08/16/2018
* DESCRIPTION:  JPS - XML - File: Society Name appears truncated.
*               All title fields should be used to populate BP Title.
*               NAME2 field added with NAME1, NAME3 for Society Name.
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
  marc,                                                         "Plant Data for Material
  komk,                                                         "Communication Header for Pricing
  komv,                                                         "Pricing Communications-Condition Record
  adr6.                                                         "E-Mail Addresses (Business Address Services)

TYPES:
  BEGIN OF ty_constant,
    param1      TYPE rvari_vnam,                                "ABAP: Name of variant variable
    param2      TYPE rvari_vnam,                                "ABAP: Name of variant variable
    serial_numb TYPE tvarv_numb,                                "ABAP: Current selection number
    sign        TYPE tvarv_sign,                                "ABAP: ID: I/E (include/exclude values)
    opti        TYPE tvarv_opti,                                "ABAP: Selection option (EQ/BT/CP/...)
    low         TYPE salv_de_selopt_low,                        "Lower Value of Selection Condition
    high        TYPE salv_de_selopt_high,                       "Upper Value of Selection Condition
  END OF ty_constant,
  tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,

  BEGIN OF ty_list_prc,
    kappl     TYPE kappl,                                       "Application
    kschl     TYPE kscha,                                       "Condition type
    pltyp     TYPE pltyp,                                       "Price list type
    kdgrp     TYPE kdgrp,                                       "Customer group
    matnr     TYPE matnr,                                       "Material Number
    extwg     TYPE extwg,                                       "External Material Group
    mtart     TYPE mtart,                                       "Material Type
    mstae     TYPE mstae,                                       "Cross-Plant Material Status
    title     TYPE ismtitle,                                    "Title
    mediatype	TYPE ismmediatype,                                "Media Type
    maktx     TYPE maktx,                                       "Material Description (Short Text)
    kfrst     TYPE kfrst,                                       "Release status
    datbi     TYPE kodatbi,                                     "Validity end date of the condition record
    datab     TYPE kodatab,                                     "Validity start date of the condition record
    knumh     TYPE knumh,                                       "Condition record number
    kopos     TYPE kopos,                                       "Sequential number of the condition
    kbetr     TYPE kbetr_kond,                                  "Rate (condition amount or percentage) where no scale exists
    konwa     TYPE konwa,                                       "Rate unit (currency or percentage)
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   knuma_ag  TYPE knuma_ag,                                    "Sales deal
*   End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
    publtype  TYPE ismpubltype,                                 "Publication Type
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    kosrt     TYPE kosrt,                                       "Search term for conditions
    kotab     TYPE kotab,                                       "Condition table
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
    soc_numbr TYPE zzpartner2,                                  "Business Partner 2 or Society number
    reltyp_sn TYPE wrf_free_char,                               "Rel Category and Society number
    level     TYPE i,                                           "Online Only(1)/Online + Print Only(2)/Print Only(3)
    issn_lvl  TYPE i,                                           "Print Only(1)/Online Only(2)/Online + Print Only(3)
*   Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
    excld_prc TYPE flag,                                        "Exclude Pricing
    price_nm  TYPE flag,                                        "Price Not Maintained
*   End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
  END OF ty_list_prc,
  tt_list_prc TYPE STANDARD TABLE OF ty_list_prc INITIAL SIZE 0,

  BEGIN OF ty_1d_scale,
    knumh     TYPE knumh,                                       "Condition record number
    kopos     TYPE kopos,                                       "Sequential number of the condition
    line_scal TYPE klfn1,                                       "Current number of the line scale
    kstbm     TYPE kstbm,                                       "Condition scale quantity
    kbetr     TYPE kbetr,                                       "Rate (condition amount or percentage)
  END OF ty_1d_scale,
  tt_1d_scale TYPE STANDARD TABLE OF ty_1d_scale INITIAL SIZE 0,

  BEGIN OF ty_idcdasgn,
    matnr	    TYPE matnr,                                       "Material Number
    idcodetyp TYPE ismidcodetype,                               "Type of Identification Code
    identcode	TYPE ismidentcode,                                "Identification Code
  END OF ty_idcdasgn,
  tt_idcdasgn TYPE STANDARD TABLE OF ty_idcdasgn INITIAL SIZE 0,

* Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
  BEGIN OF ty_mult_med,
    matnr     TYPE matnr,                                       "Material Number
    extwg     TYPE extwg,                                       "External Material Group
    mediatype TYPE ismmediatype,                                "Media Type
    idcodetyp TYPE ismidcodetype,                               "Type of Identification Code
    identcode TYPE ismidentcode,                                "Identification Code
    issn_lvl  TYPE i,                                           "Print Only(1)/Online Only(2)/Online + Print Only(3)
  END OF ty_mult_med,
  tt_mult_med TYPE STANDARD TABLE OF ty_mult_med INITIAL SIZE 0,
* End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749

  BEGIN OF ty_issue_sq,
    med_prod  TYPE ismrefmdprod,                                "Higher-Level Media Product
    ismyearnr TYPE ismjahrgang,                                 "Media issue year number
    copynr    TYPE ismheftnummer,                               "Copy Number of Media Issue
    nrinyear  TYPE ismnrimjahr,                                 "Issue Number (in Year Number)
    mpg_lfdnr TYPE mpg_lfdnr,                                   "Sequence number of media issue within issue sequence
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   volume    TYPE ismheftnummer,                               "Volume
*   End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    volume    TYPE string,                                      "Volume
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    issues    TYPE ismnrimjahr,                                 "Issues
  END OF ty_issue_sq,
  tt_issue_sq TYPE STANDARD TABLE OF ty_issue_sq INITIAL SIZE 0,

  BEGIN OF ty_char_dtl,
    objek     TYPE objnum,                                      "Key of object to be classified
    atinn     TYPE atinn,                                       "Internal characteristic
    atzhl     TYPE wzaehl,                                      "Characteristic value counter
    mafid     TYPE klmaf,                                       "Indicator: Object/Class
    klart     TYPE klassenart,                                  "Class Type
    int_count TYPE adzhl,                                       "Internal counter for archiving objects via engin. chg. mgmt
    atwrt     TYPE atwrt,                                       "Characteristic Value
  END OF ty_char_dtl,
  tt_char_dtl TYPE STANDARD TABLE OF ty_char_dtl INITIAL SIZE 0,

  BEGIN OF ty_mat_plnt,
    matnr     TYPE matnr,                                       "Material Number
    mat_plant TYPE werks_d,                                     "Plant
    herkl     TYPE herkl,                                       "Country of origin of the material
  END OF ty_mat_plnt,
  tt_mat_plnt TYPE STANDARD TABLE OF ty_mat_plnt INITIAL SIZE 0,

  BEGIN OF ty_soc_name,
    kunnr  	  TYPE kunnr,                                       "Customer Number
    name1     TYPE name1_gp,                                    "Name 1
    name2     TYPE name2_gp,                                    "Name 2      "+ <HIPATEL> <INC0207303> <ED1K908211>
    name3     TYPE name3_gp,                                    "Name 3
    name_text TYPE swfelemnam,      "bu_name1tx,                "Full Name   "+ <HIPATEL> <INC0207303> <ED1K908211>
  END OF ty_soc_name,
  tt_soc_name TYPE STANDARD TABLE OF ty_soc_name INITIAL SIZE 0,

  BEGIN OF ty_rel_catg,
    reltyp    TYPE bu_reltyp,                                   "Business Partner Relationship Category
    role_defn TYPE bu_xrf,                                      "Business partner role definition instead of BP relationship
    rtitl     TYPE bu_rtitl,                                    "Title of Object Part
  END OF ty_rel_catg,
  tt_rel_catg TYPE STANDARD TABLE OF ty_rel_catg INITIAL SIZE 0,

  BEGIN OF ty_bom_detl,
    idnrk     TYPE idnrk,                                       "BOM component
    stlnr     TYPE stnum,                                       "Bill of material
    matnr_hdr	TYPE matnr,                                       "Material Number
    extwg     TYPE extwg,                                       "External Material Group
    mtart     TYPE mtart,                                       "Material Type
    extwg_cmp TYPE extwg,                                       "External Material Group (Component)
  END OF ty_bom_detl,
  tt_bom_detl TYPE STANDARD TABLE OF ty_bom_detl INITIAL SIZE 0
            WITH NON-UNIQUE SORTED KEY extwg COMPONENTS extwg_cmp extwg,

  BEGIN OF ty_memb_due,
    extwg TYPE extwg,                                           "External Material Group
  END OF ty_memb_due,
  tt_memb_due TYPE STANDARD TABLE OF ty_memb_due INITIAL SIZE 0,

  BEGIN OF ty_discount,
    kappl     TYPE kappl,                                       "Application
    kschl     TYPE kscha,                                       "Condition type
    kdgrp     TYPE kdgrp,                                       "Customer group
*     Begin of DEL:CR#6341 RTR20180414 ED2K912278
*    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
*    soc_numbr TYPE zzpartner2,
*     END of DEL:CR#6341 RTR20180414 ED2K912278
    extwg     TYPE extwg,                                       "External Material Group
    kfrst     TYPE kfrst,                                       "Release status
    datbi     TYPE kodatbi,                                     "Validity end date of the condition record
    datab     TYPE kodatab,                                     "Validity start date of the condition record
    knumh     TYPE knumh,                                       "Condition record number
    kopos     TYPE kopos,                                       "Sequential number of the condition
    kbetr     TYPE kbetr_kond,                                  "Rate (condition amount or percentage) where no scale exists
    konwa     TYPE konwa,                                       "Rate unit (currency or percentage)
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   knuma_ag  TYPE knuma_ag,                                    "Sales deal
*   End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    kosrt     TYPE kosrt,                                       "Search term for conditions
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
*  Begin of DEL:CR#6341 RTR20180414 ED2K912278
*    matnr     TYPE matnr,
*  END of DEL:CR#6341 RTR20180414 ED2K912278                                          "Material Number
*   Begin of ADD:CR#6341 RTR20180414 ED2K912278
    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
    soc_numbr TYPE zzpartner2,
*   Begin of ADD:CR#6341 RTR20180414 ED2K912278
    matnr     TYPE matnr,                                       "Material Number
*   Begin of ADD:CR#6341 RTR20180414 ED2K912278
    laufk     TYPE vlauk_veda,                                  "Validity period category of contract
*   End   of ADD:CR#6341 RTR20180414 ED2K912278
    reltyp_sn TYPE wrf_free_char,                               "Rel Category and Society number
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    kotab     TYPE kotab,                                       "Condition table
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    "Business Partner 2 or Society number
  END OF ty_discount,
  tt_discount TYPE STANDARD TABLE OF ty_discount INITIAL SIZE 0,

  BEGIN OF ty_rep_lout,
    alpha_sep TYPE char1,                                       "Alphabetical letter separator
    extwg     TYPE extwg,                                       "External Material Group
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    np_ind    TYPE flag,                                        "Flag: Net Price
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    member    TYPE flag,                                        "Flag: Membership
    ipm_ind   TYPE flag,                                        "Institutional(1)/Personal(2)/Member(3)
    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
    soc_numbr TYPE zzpartner2,                                  "Business Partner 2 or Society number
    line_scal TYPE klfn1,                                       "Current number of the line scale
*    Begin of ADD:CR#6341 RTR20180414 ED2K912278
    vlaufk    TYPE vlauk_veda,
*    END of ADD:CR#6341 RTR20180414 ED2K912278
    level     TYPE i,                                           "Online Only(1)/Online + Print Only(2)/Print Only(3)
    pltyp     TYPE pltyp,                                       "Price list type
    matnr     TYPE matnr,                                       "Material Number
    kdgrp     TYPE kdgrp,                                       "Customer group
    mstae     TYPE mstae,                                       "Cross-Plant Material Status
    mtart     TYPE mtart,                                       "Material Type
    bom_info  TYPE char1,                                       "BOM Info - (Header) / (C)omponent / (N)o
    title     TYPE ismtitle,                                    "Title
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   maktx     TYPE maktx,                                       "Material Description (Short Text)
*   End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    maktx     TYPE text150,                                     "Material Description
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    mediatype	TYPE ismmediatype,                                "Media Type
    knuma_ag  TYPE knuma_ag,                                    "Price Type
    kstbm     TYPE kstbm,                                       "Condition scale quantity
    konwa     TYPE konwa,                                       "Rate unit (currency or percentage)
    list_prc  TYPE kbetr,                                       "List Price
    net_prc_a TYPE kbetr,                                       "NET Price for Agent Discount
    net_prc_d TYPE kbetr,                                       "NET Price Agent Discount and DDP
    net_prc_s TYPE kbetr,                                       "NET Price for Standard Discount
    datbi     TYPE kodatbi,                                     "Validity end date of the condition record
    datab     TYPE kodatab,                                     "Validity start date of the condition record
    identcode	TYPE ismidentcode,                                "Identification Code
    soc_name  TYPE swfelemnam,                  "bu_name1tx,    "Society Name   "+ <HIPATEL> <INC0207303> <ED1K908211>
    rlc_text  TYPE bu_rtitl,                                    "Relationship Category: Text
    publtype  TYPE ismpubltype,                                 "Publication Type
    reltyp_sn TYPE wrf_free_char,                               "Rel Category and Society number
    hdr_comp  TYPE char100,                                     "BOM Header / Components
    memb_due  TYPE char1,                                       "Indicator: Membership Due
    excld_prc TYPE flag,                                        "Exclude Pricing
*   Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
    price_nm  TYPE flag,                                        "Price Not Maintained
*   End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
    issn_lvl  TYPE i,                                           "Print Only(1)/Online Only(2)/Online + Print Only(3)
    objek     TYPE objnum,                                      "Key of object to be classified
* Begin of ADD:CR#6341 RTR20180414 ED2K912278
    bezei     TYPE bezei20,                                     "Discount type and validity text
    bezei1    TYPE bezei20,                                     " Validity text for IDOC
    kschl     TYPE kscha,                                        ""Condition type
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
    maktx_xls TYPE text150,                                     "Material Description-2
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*    vlaufk    TYPE VLAUK_VEDA,
* Begin of ADD:CR#6341 RTR20180414 ED2K912278
  END OF ty_rep_lout,
  tt_rep_lout TYPE STANDARD TABLE OF ty_rep_lout INITIAL SIZE 0,

  BEGIN OF ty_xcel_lib,
    column_01 TYPE string,
    column_02 TYPE string,
    column_03 TYPE string,
    column_04 TYPE string,
    column_05 TYPE string,
    column_06 TYPE string,
    column_07 TYPE string,
  END OF ty_xcel_lib,
  tt_xcel_lib TYPE STANDARD TABLE OF ty_xcel_lib INITIAL SIZE 0,

*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  BEGIN OF ty_xcel_v1,
    column_01 TYPE string,
    column_02 TYPE string,
    column_03 TYPE string,
    column_04 TYPE string,
    column_05 TYPE string,
    column_06 TYPE string,
    column_07 TYPE string,
    media_lvl TYPE i,                                           "SMALL(1)/MEDIUM(2)/LARGE(3)
    print_lvl TYPE i,                                           "Online + Print Only(1)/Online Only(2)/Print Only(3)
  END OF ty_xcel_v1,
  tt_xcel_v1 TYPE STANDARD TABLE OF ty_xcel_v1 INITIAL SIZE 0,
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>

* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
  BEGIN OF ty_mn_rs_wm,
    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
    soc_numbr TYPE zzpartner2,                                  "Business Partner 2 or Society number
  END OF ty_mn_rs_wm,
  tt_mn_rs_wm TYPE STANDARD TABLE OF ty_mn_rs_wm INITIAL SIZE 0,

  BEGIN OF ty_mn_rc_sn,
    matnr     TYPE matnr,                                       "Material Number
    rltyp     TYPE bu_reltyp,                                   "Business Partner Relationship Category
    soc_numbr TYPE zzpartner2,                                  "Business Partner 2 or Society number
  END OF ty_mn_rc_sn,
  tt_mn_rc_sn TYPE STANDARD TABLE OF ty_mn_rc_sn INITIAL SIZE 0,

  BEGIN OF ty_mn_sn_pt,
    matnr     TYPE matnr,                                       "Material Number
    soc_numbr TYPE zzpartner2,                                  "Business Partner 2 or Society number
    price_typ TYPE kosrt,                                       "Price Type
  END OF ty_mn_sn_pt,
  tt_mn_sn_pt TYPE STANDARD TABLE OF ty_mn_sn_pt INITIAL SIZE 0,

  BEGIN OF ty_mn_rltyp,
    matnr     TYPE matnr,                                       "Material Number
    rel_ctgry TYPE bu_reltyp,                                   "Business Partner Relationship Category
  END OF ty_mn_rltyp,
  tt_mn_rltyp TYPE STANDARD TABLE OF ty_mn_rltyp INITIAL SIZE 0,

  BEGIN OF ty_mn_prtyp,
    matnr     TYPE matnr,                                       "Material Number
    price_typ TYPE kosrt,                                       "Price Type
  END OF ty_mn_prtyp,
  tt_mn_prtyp TYPE STANDARD TABLE OF ty_mn_prtyp INITIAL SIZE 0,
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
* Begin of ADD:CR#6341 RTR20180414ED2K912278
  BEGIN OF ty_val_text,
    spras  TYPE spras,
    vlaufk TYPE vlauk_veda,                                  "Validity period category of contract
    bezei	 TYPE  bezei20,                                    "Description
  END OF ty_val_text,
  tt_val_text TYPE STANDARD TABLE OF ty_val_text INITIAL SIZE 0.
* END of ADD:CR#6341 RTR20180414 ED2K912278
DATA:
  i_constants TYPE tt_constant,                                 "Application Constants
  i_bom_detls TYPE tt_bom_detl,                                 "BOM Details
* Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
  i_multi_med TYPE tt_mult_med,                                 "Details of Multi-Media BOMs
* End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
  i_rep_lout  TYPE tt_rep_lout.                                 "Report Layout

DATA:
  v_bt_txt    TYPE char30.                                      "Button Text


CONSTANTS:
  c_dev_i0225 TYPE zdevid       VALUE 'I0225',                  "Development ID
  c_param_rcd TYPE rvari_vnam   VALUE 'REL_CATG_DESC',          "Name of Variant Variable
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  c_param_cnt TYPE rvari_vnam   VALUE 'COND_TABLE',             "Name of Variant Variable
  c_wt_relat  TYPE kotab        VALUE 'WT_RELAT',               "Condition table (A911)
  c_wo_relat  TYPE kotab        VALUE 'WO_RELAT',               "Condition table (A913)
* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
  c_wo_no_lp  TYPE kotab        VALUE 'WO_NO_LP',               "Condition table (A974)

  c_kdgrp_ind TYPE kdgrp        VALUE '01',                     "Customer Group: Individual
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487

  c_tdobj_mat TYPE tdobject     VALUE 'MATERIAL',               "Texts: Application Object
  c_tdid_grun TYPE tdid         VALUE 'GRUN',                   "Text ID
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

  c_f_slash   TYPE char1        VALUE '/',                      "Separator: Forward Slash
  c_comma     TYPE char1        VALUE ',',                      "Separator: Comma
  c_colon     TYPE char1        VALUE ':',                      "Separator: Colon
  c_period    TYPE char1        VALUE '.',                      "Separator: Period
  c_ampersand TYPE char1        VALUE '&',                      "Separator: Ampersand
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  c_hyphen    TYPE char1        VALUE '-',                      "Separator: Hyphen
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

  c_flg_srt_1 TYPE char1        VALUE '1',                      "Flag for Sorting: 1
  c_flg_srt_2 TYPE char1        VALUE '2',                      "Flag for Sorting: 2
  c_flg_srt_3 TYPE char1        VALUE '3',                      "Flag for Sorting: 2

  c_msgty_i   TYPE symsgty      VALUE 'I',                      "Message Type: (I)nformation

  c_flag_y    TYPE char1        VALUE 'Y',                      "Flag: (Y)es
  c_flag_n    TYPE char1        VALUE 'N',                      "Flag: (N)o
  c_flag_c    TYPE char1        VALUE 'C',                      "Flag: BOM (C)onponent
  c_flag_h    TYPE char1        VALUE 'H',                      "Flag: BOM (H)eader

  c_inst_rate TYPE knuma_ag     VALUE 'F',                      "Sales deal: Institutional
  c_pers_rate TYPE knuma_ag     VALUE 'P',                      "Sales deal: Personal
  c_memb_rate TYPE knuma_ag     VALUE 'M',                      "Sales deal: Member

  c_bom_us_sd TYPE stlan        VALUE '5',                      "BOM Usage: Sales and Distribution

  c_sign_i    TYPE tvarv_sign   VALUE 'I',                      "ID: (I)nclude
  c_opti_eq   TYPE tvarv_opti   VALUE 'EQ',                     "Selection option: (EQ)uals

  c_mt_zsbe   TYPE mtart        VALUE 'ZSBE',                   "Material Type: ZSBE
  c_mt_zwol   TYPE mtart        VALUE 'ZWOL',                   "Material Type: ZWOL
  c_mt_zmjl   TYPE mtart        VALUE 'ZMJL',                   "Material Type: ZMJL
  c_mt_zmmj   TYPE mtart        VALUE 'ZMMJ',                   "Material Type: ZMMJ

  c_ct_zlpr   TYPE mtart        VALUE 'ZLPR',                   "Condition Type: ZLPR
  c_ct_zsd1   TYPE mtart        VALUE 'ZSD1',                   "Condition Type: ZSD1
  c_ct_zajd   TYPE mtart        VALUE 'ZAJD',                   "Condition Type: ZAJD
  c_ct_zddp   TYPE mtart        VALUE 'ZDDP',                   "Condition Type: ZDDP

  c_ch_jpsnt  TYPE atnam        VALUE 'JPSNT',                  "Characteristic: New Start Title
  c_ch_jpsmw  TYPE atnam        VALUE 'JPSMW',                  "Characteristic: Merged With

* Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
  c_appl_sls  TYPE kappl        VALUE 'V',                      "Application (Sales/Distribution)
  c_curr_usd  TYPE waers        VALUE 'USD',                    "Currency (USD)
* End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466

  c_m_typ_j   TYPE edi_mestyp   VALUE 'ZPDM_PRICE_FEED_JPS',    "Message Type
  c_i_typ_j   TYPE edi_idoctp   VALUE 'ZPDMB_PRICE_FEED01',     "Basic type
  c_dir_out   TYPE edi_direct   VALUE '1',                      "Direction for IDoc (Outbound)
  c_sys_sap   TYPE char3        VALUE 'SAP',                    "Sap of type CHAR3
  c_p_typ_l   TYPE edi_sndprt   VALUE 'LS',                     "Partner Type: Logical Syatem (LS)
  c_seg_hdr   TYPE edilsegtyp   VALUE 'Z1PDM_JPS_HDR',          "Segment type: Z1PDM_JPS_HDR
  c_seg_jrn   TYPE edilsegtyp   VALUE 'Z1PDM_JOURNAL',          "Segment type: Z1PDM_JOURNAL
  c_seg_clh   TYPE edilsegtyp   VALUE 'Z1PDM_COLHEAD',          "Segment type: Z1PDM_COLHEAD
  c_seg_prc   TYPE edilsegtyp   VALUE 'Z1PDM_PRICE',            "Segment type: Z1PDM_PRICE
** Begin of ADD:CR#6341 RTR20180414 ED2K912278
  c_zmys      TYPE kschl        VALUE 'ZMYS',
  c_a950(4)   TYPE c            VALUE 'A950',
  c_a951(4)   TYPE c            VALUE 'A951',
  c_a937(4)   TYPE c            VALUE 'A937',
  c_a923(4)   TYPE c            VALUE 'A923',
  c_ct_zmys   TYPE mtart        VALUE 'ZMYS',                   "Condition Type: ZMYS
** END of ADD:CR#6341 RTR20180414 ED2K912278
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  c_param_alp TYPE rvari_vnam   VALUE 'ALPHA_SEPARATOR',
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
* Begin by amohammed on 04/13/2020 - ERPM-6898 -  ED2K917960
  c_jan_one   TYPE i            VALUE '01',                     " 1st jan
  c_dec       TYPE i            VALUE '12',                     " December
  c_month_end TYPE i            VALUE '31'.                     " End of the Month
* End by amohammed on 04/13/2020 - ERPM-6898 -  ED2K917960
