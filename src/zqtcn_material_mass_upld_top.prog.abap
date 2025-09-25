*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_MASS_UPLD_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/17/2019
*& OBJECT ID:             C110.1
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
TYPES:BEGIN OF ity_file,
        ind_sect TYPE mbrsh,
        mtart    TYPE mtart,
        werks    TYPE werks_d,
        vkorg    TYPE vkorg,
        vtweg    TYPE vtweg,
        maktx    TYPE maktx,
        meins    TYPE char3,
        matkl    TYPE matkl,
        bismt    TYPE bismt18,
        spart    TYPE spart,
        mstae    TYPE mstae,
        item_cat TYPE mtpos_mara,
        dwerk    TYPE dwerk,
        taxkm    TYPE char1,
        mtpos    TYPE mtpos,
        mvgr4    TYPE mvgr4,
        mtvfp    TYPE mtvfp,
        tragr    TYPE tragr,
        ladgr    TYPE ladgr,
        prctr    TYPE prctr,
        text     TYPE char256,
        matnr    TYPE matnr,
        type     TYPE bapi_mtype,
        message  TYPE bapi_msg,
      END OF ity_file,

      BEGIN OF ity_file_p,
        ind_sect TYPE mbrsh,
        mtart    TYPE mtart,
        bukrs    TYPE bukrs,
        werks    TYPE werks_d,
        vkorg    TYPE vkorg,
        vtweg    TYPE vtweg,
        maktx    TYPE maktx,
        meins    TYPE char3,
        matkl    TYPE matkl,
        bismt    TYPE bismt18,
        spart    TYPE spart,
        mstae    TYPE mstae,
        item_cat TYPE mtpos_mara,
        dwerk    TYPE dwerk,
        taxkm    TYPE char1,
        mtpos    TYPE mtpos,
        mvgr4    TYPE mvgr4,
        mtvfp    TYPE mtvfp,
        tragr    TYPE tragr,
        ladgr    TYPE ladgr,
        prctr    TYPE prctr,
        ekgrp    TYPE ekgrp,
        kautb    TYPE kautb,
        dismm    TYPE dismm,
        beskz    TYPE beskz,
        bklas    TYPE bklas,
        vprsv    TYPE vprsv,
        peinh    TYPE char5,
        stprs    TYPE char13,
        text     TYPE char256,
        matnr    TYPE matnr,
        type     TYPE bapi_mtype,
        message  TYPE bapi_msg,
      END OF ity_file_p,

      BEGIN OF ity_mara,
        matnr TYPE matnr,
        mtart TYPE mtart,
        bismt TYPE bismt18,
      END OF ity_mara.

DATA: i_file_data    TYPE STANDARD TABLE OF ity_file,
      i_file_temp    TYPE STANDARD TABLE OF ity_file,
      i_file_data_p  TYPE STANDARD TABLE OF ity_file_p,
      i_sucess_rec   TYPE STANDARD TABLE OF ity_file,
      i_sucess_rec_p TYPE STANDARD TABLE OF ity_file_p,
      i_error_rec    TYPE STANDARD TABLE OF ity_file,
      i_error_rec_p  TYPE STANDARD TABLE OF ity_file_p,
      i_mara         TYPE STANDARD TABLE OF ity_mara,
      i_head         TYPE string,
      i_rows         TYPE char05.
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.


ENDCLASS.

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM f_handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
  "on_single_click
ENDCLASS.

DATA: ir_events     TYPE REF TO lcl_handle_events,
      ir_table      TYPE REF TO cl_salv_table,
      ir_selections TYPE REF TO cl_salv_selections.
DATA: i_const       TYPE STANDARD TABLE OF zcaconstant,
      gv_total_proc TYPE char05,
      gv_success    TYPE char05,
      gv_error      TYPE char05,
      v_file_path   TYPE string.
DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_C110_1_PRODUCT_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_C110_1_PRODUCT_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_C110_1_PRODUCT_ERR'.

CONSTANTS: c_e      TYPE char1       VALUE 'E',
           c_x      TYPE char1       VALUE 'X',
           c_s      TYPE char1       VALUE 'S',
           c_true   TYPE sap_bool    VALUE 'X',
           c_devid  TYPE zdevid      VALUE 'C110.1',
           c_langu  TYPE char1       VALUE 'E',
           c_param1 TYPE rvari_vnam  VALUE 'NO_OF_RECORDS'.
