*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EXISTING_CUST_UPD_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCC_EXISTING_CUST_UPDATE
* PROGRAM DESCRIPTION:Report for customer update
* DEVELOPER:          WROY(Writtick Roy)
* CREATION DATE:      12/16/2016
* OBJECT ID:          C076
* TRANSPORT NUMBER(S):ED2K903796
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906076
* REFERENCE NO: CR# 471/472
* DEVELOPER: Writtick Roy
* DATE:  2017-05-15
* DESCRIPTION: 1. Address Line Design Change,
*              2. Communication Method Update
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
TABLES:
  kna1,
  but0id.

TYPES:
  BEGIN OF ty_idtyp_rng,
    sign   TYPE ddsign,
    option TYPE ddoption,
    low    TYPE bu_id_type,
    high   TYPE bu_id_type,
  END OF ty_idtyp_rng,

  BEGIN OF ty_ktokd_rng,
    sign   TYPE  ddsign,
    option TYPE  ddoption,
    low    TYPE  ktokd,
    high   TYPE  ktokd,
  END OF ty_ktokd_rng,
  tt_idtyp_rng TYPE STANDARD TABLE OF ty_idtyp_rng INITIAL SIZE 0,
  tt_ktokd_rng TYPE STANDARD TABLE OF ty_ktokd_rng INITIAL SIZE 0,

  BEGIN OF ty_report_op,
    kunnr      TYPE kunnr,                            "Customer Number
    land1      TYPE land1,                            "Country Key
    ktokd      TYPE ktokd,                            "Customer Account Group
    name1      TYPE name1_gp,                         "Name 1
    name2      TYPE name2_gp,                         "Name 2
    sort1      TYPE ad_sort1,                         "Search Term 1
    sort2      TYPE ad_sort2,                         "Search Term 2
* Begin of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
    street     TYPE ad_street,                        "Street
    str_suppl1 TYPE ad_strspp1,                       "Street 2
    str_suppl2 TYPE ad_strspp2,                       "Street 3
    str_suppl3 TYPE ad_strspp3,                       "Street 4
    location   TYPE ad_lctn,                          "Street 5
    remark     TYPE ad_remark1,                       "Address notes
    smtp_addr  TYPE ad_smtpadr,                       "E-Mail Address
    deflt_comm TYPE ad_comm,                          "Communication Method (Key) (Business Address Services)
* End   of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
    jecore     TYPE flag,                             "Flag: ECORE / JCORE Cust
    cc_ext     TYPE flag,                             "Flag: Company Code Extension
    sa_ext     TYPE flag,                             "Flag: Sales Area Extension
    status_txt TYPE string,                           "Status Message
  END OF ty_report_op,
  tt_report_op TYPE STANDARD TABLE OF ty_report_op INITIAL SIZE 0.

DATA: i_report_op TYPE tt_report_op.

DATA: r_alv_cont TYPE REF TO cl_gui_custom_container, "Container for Custom Controls in the Screen Area
      r_dck_cont TYPE REF TO cl_gui_docking_container, "Container for Custom Controls in the Screen Area
      r_alv_grid TYPE REF TO cl_gui_alv_grid,         "ALV List Viewer
      i_fieldcat TYPE lvc_t_fcat,                     "Field Catalog
      i_layout   TYPE lvc_s_layo.                       "Layout

CONSTANTS:
  c_sign_incld TYPE ddsign     VALUE 'I',             "Sign: (I)nclude
  c_opti_ls_eq TYPE ddoption   VALUE 'LE',            "Option: (L)ess or (E)qual
  c_opti_equal TYPE ddoption   VALUE 'EQ',            "Option: (EQ)ual

  c_update     TYPE updkz      VALUE 'U',             "Change Indicator: (U)pdate
  c_insert     TYPE updkz      VALUE 'I',             "Change Indicator: (I)nsert

  c_category_p TYPE bu_type    VALUE '1',             "Business partner category: Person
  c_category_o TYPE bu_type    VALUE '2',             "Business partner category: Organization

  c_acc_grp_1  TYPE akont      VALUE '0001',          "Cust Acc Group: 0001 (Sold-to Party)
  c_recon_acc  TYPE akont      VALUE '0011001100',    "Reconciliation Account in General Ledger
  c_dist_ch_00 TYPE vtweg      VALUE '00',            "Distribution Channel: 00
  c_divsn_00   TYPE vtweg      VALUE '00',            "Division: 00
  c_del_blk_r1 TYPE lifsd_v    VALUE 'R1',            "Delivery Block: R1
  c_bil_blk_r1 TYPE faksd_v    VALUE 'R1',            "Billing Block: R1

* Begin of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
  c_comm_int   TYPE ad_comm    VALUE 'INT',           "Communication Method (Key) (Business Address Services)
  c_comm_let   TYPE ad_comm    VALUE 'LET',           "Communication Method (Key) (Business Address Services)
* End   of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076

  c_idtyp_jc   TYPE bu_id_type VALUE 'ZJCLNO',        "Identification Type: JCORE
  c_idtyp_ec   TYPE bu_id_type VALUE 'ZUSLNO',        "Identification Type: ECORE

  c_semi_colon TYPE char1      VALUE ';',             "Separator: Semi-colon
  c_msgty_w    TYPE symsgty    VALUE 'W',             "Message Type: (W)arning
  c_mod_st     TYPE char4      VALUE '9000',          "Status bar
  c_back       TYPE char4      VALUE 'BACK',          "Back
  c_exit       TYPE char4      VALUE 'EXIT',          "Exit
  c_canc       TYPE char4      VALUE 'CANC',          "Cancel
  c_kunnr      TYPE lvc_fname VALUE 'KUNNR',          "Customer Number
  c_land1      TYPE lvc_fname VALUE 'LAND1',          "Country Key
  c_sort1      TYPE lvc_fname VALUE 'SORT1',          "Sort1
  c_sort2      TYPE lvc_fname VALUE 'SORT2',          "Sort2
  c_jecore     TYPE lvc_fname VALUE 'JECORE',         "JECORE
  c_cc_ext     TYPE lvc_fname VALUE 'CC_EXT',         "Company code text
  c_sa_ext     TYPE lvc_fname VALUE 'SA_EXT',         "Sales Area text
  c_st_txt     TYPE lvc_fname VALUE 'STATUS_TXT',      "Status text
  c_tab        TYPE lvc_tname VALUE 'FP_LI_REPORT_OP',  "Reference Table
  c_16         TYPE lvc_outlen VALUE '16',
  c_05         TYPE lvc_outlen VALUE '05',
  c_20         TYPE lvc_outlen VALUE '20',
  c_02         TYPE lvc_outlen VALUE '02',
  c_01         TYPE lvc_outlen VALUE '01',
  c_50         TYPE lvc_outlen VALUE '50'.
