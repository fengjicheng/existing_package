*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_EXT_C121_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_EXTEND_C121_TOP(INCLUDE)
* PROGRAM DESCRIPTION:   Program to transfer Business partners
*                        from file and this program is copy of
*                        ZRTR_BP_INIT_LOAD_EXTEND
* DEVELOPER:             Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:         04/29/2022
* OBJECT ID:             C121
* TRANSPORT NUMBER(S):   ED2K927116
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_bp_details,
         source_field            TYPE  char20,    "New Field
         category                TYPE  bu_type,
         grouping                TYPE  bu_group,
         partner                 TYPE  bu_partner,
         partner_role            TYPE  char10,     "Dummy  New Field
         bukrs                   TYPE  bukrs,     "Company code data
         vkorg                   TYPE  vkorg,
         vtweg                   TYPE  vtweg,
         spart                   TYPE  spart,
         name_org1               TYPE  char40,   "name of org New Field
         name_org2               TYPE  bu_nameor2,
         firstname               TYPE  bu_namep_f,
         lastname                TYPE  bu_namep_l,
         searchterm1             TYPE  bu_sort1,
         searchterm2             TYPE  bu_sort2,
         city                    TYPE  ad_city1,
         name_co                 TYPE  char40,
         street                  TYPE  ad_street,
         street2                 TYPE  ad_street,
         street3                 TYPE ad_strspp1,
         street4                 TYPE ad_strspp2,
         street5                 TYPE ad_strspp3,
         postl_cod1              TYPE  ad_pstcd1,
         region                  TYPE  regio,               "New Field
         e_mail                  TYPE  ad_smtpadr,          "SMTP
         e_mail2                 TYPE  ad_smtpadr,          "SMTP     "New Field              "+++++++++++++
         telephone               TYPE  ad_tlnmbr,           "Phone
         extension               TYPE  ad_tlxtns,           "Phone
         mob_number              TYPE  ad_tlnmbr,           "Phone
         fax                     TYPE  ad_fxnmbr,           "Fax
         f_extension             TYPE  ad_fxxtns,           "Fax Extension
         country                 TYPE  land1,
         langu                   TYPE  spras,
         comm_type               TYPE  ad_comm,
         identificationcategory  TYPE  bu_id_category,
         identificationnumber    TYPE  bu_id_number,
         entry_date              TYPE  datum,
         idvalidfromdate         TYPE  bu_id_valid_date_from,
         idvalidtodate           TYPE  bu_id_valid_date_to,

         identificationcategory2 TYPE  bu_id_category,
         identificationnumber2   TYPE  bu_id_number,
         entry_date2             TYPE  datum,
         idvalidfromdate2        TYPE  bu_id_valid_date_from,
         idvalidtodate2          TYPE  bu_id_valid_date_to,
         identificationcategory3 TYPE  bu_id_category,
         identificationnumber3   TYPE  bu_id_number,
         entry_date3             TYPE  datum,
         idvalidfromdate3        TYPE  bu_id_valid_date_from,
         idvalidtodate3          TYPE  bu_id_valid_date_to,
         identificationcategory4 TYPE  bu_id_category,
         identificationnumber4   TYPE  bu_id_number,
         entry_date4             TYPE  datum,
         idvalidfromdate4        TYPE  bu_id_valid_date_from,
         idvalidtodate4          TYPE  bu_id_valid_date_to,
         akont                   TYPE  akont,
         zuawa                   TYPE  dzuawa,
         zterm                   TYPE  dzterm,
         busab                   TYPE  busab,
         xausz                   TYPE  xausz,
         xzver                   TYPE  xzver,
         mahna                   TYPE  mahna,
         versg                   TYPE  stgku,
         kalks                   TYPE  kalks,
         kdgrp                   TYPE  kdgrp,
         konda                   TYPE  konda,
         pltyp                   TYPE  pltyp,
         vwerk                   TYPE  dwerk_ext,
         inco1                   TYPE  inco1,
         inco2                   TYPE  inco2,
         lprio                   TYPE  lprio,
         vsbed                   TYPE  vsbed,
         waers                   TYPE  waers_v02d,
         ktgrd                   TYPE  ktgrd,
         s_zterm                 TYPE  dzterm,
         kvgr1                   TYPE  kvgr1,
         kkber                   TYPE  kkber,
         zzfte                   TYPE  zzfte,
         credit_sgmnt            TYPE  char10,
         credit_limit            TYPE  char17,
         limit_rule              TYPE  char10,
         risk_class              TYPE  char3,
         check_rule              TYPE  char10,
         credit_group            TYPE  char4,
         taxkd                   TYPE  char1,
         coll_profile            TYPE  char10,
         coll_segment            TYPE  char10,
         coll_group              TYPE  char10,
         coll_specialist         TYPE  char12,
         sales_off               TYPE  vkbur,
         partner_fn1             TYPE  parvw,
         part_no1                TYPE  ktonr,
         partner_fn2             TYPE  parvw,
         part_no2                TYPE  ktonr,
         partner_fn3             TYPE  parvw,
         part_no3                TYPE  ktonr,
         partner_fn4             TYPE  parvw,
         part_no4                TYPE  ktonr,
         partner_fn5             TYPE  parvw,
         part_no5                TYPE  ktonr,
         ext_id                  TYPE  char20,
         status                  TYPE  char2048,
       END OF ty_bp_details.


TYPES:BEGIN OF ty_input,
        type     TYPE bu_type,
        idnumber(60) TYPE c,
        kvgr2    TYPE  kvgr2,
*        title    TYPE ad_title,
        searchterm1             TYPE  bu_sort1,
        searchterm2             TYPE  bu_sort2,
        name_org1               TYPE  char40,   "name of org New Field
        name_org2               TYPE  bu_nameor2,
        name_co                 TYPE  char40,
        title                   TYPE ad_title,

      END OF ty_input.

TYPES: BEGIN OF ty_msg,
         message TYPE string,
       END OF ty_msg.

DATA: gt_message TYPE STANDARD TABLE OF ty_msg.

DATA: lt_data TYPE STANDARD TABLE OF alsmex_tabline.
DATA: gt_bp_data TYPE STANDARD TABLE OF ty_bp_details.

DATA: gv_success TYPE i.
DATA: gv_errors TYPE i.


CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.


ENDCLASS.

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
  "on_single_click
ENDCLASS.

DATA: gr_events     TYPE REF TO lcl_handle_events,
      gr_table      TYPE REF TO cl_salv_table,
      gr_selections TYPE REF TO cl_salv_selections,
      gt_const      TYPE STANDARD TABLE OF zcainteg_mapping.

CONSTANTS: c_x      TYPE flag VALUE 'X',
           c_true   TYPE sap_bool   VALUE 'X',
           c_devid  TYPE zdevid     VALUE 'C121',
           c_param1 TYPE rvari_vnam VALUE 'NO_OF_RECORDS',
           c_param2 TYPE rvari_vnam VALUE 'FILE_PATH',
           c_e      TYPE char1    VALUE 'E'.        "Error
