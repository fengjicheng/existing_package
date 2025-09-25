*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_CLASSIFI_UPLD_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MAT_CLASSIFI_MASS_UPLD
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MAT_CLASSIFI_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Classication Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/20/2019
*& OBJECT ID:             C110.2
*& TRANSPORT NUMBER(S):   ED2K916178
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
        bismt    TYPE bismt18,
        klart    TYPE klassenart,
        class    TYPE klasse_d,
        charact  TYPE atnam,
        atzhl    TYPE char4,
        atwrt    TYPE atwrt,
        atwtb    TYPE text30,
        matnr    TYPE matnr,
        matkl    TYPE matkl,
        type     TYPE bapi_mtype,
        message  TYPE bapi_msg,
      END OF ity_file,

      BEGIN OF ity_mara,
        matnr TYPE matnr,
        vpsta TYPE vpsta,
        mtart TYPE mtart,
        bismt TYPE bismt18,
        matkl TYPE matkl,
      END OF ity_mara.

DATA: i_file_data      TYPE STANDARD TABLE OF ity_file,
      i_file_temp      TYPE STANDARD TABLE OF ity_file,
      i_sucess_rec     TYPE STANDARD TABLE OF ity_file,
      i_error_rec      TYPE STANDARD TABLE OF ity_file,
      i_char_file_data TYPE STANDARD TABLE OF ity_file,
      i_mara           TYPE STANDARD TABLE OF ity_mara,
      i_head           TYPE string,
      i_bismt          TYPE bismt18,
      i_matnr          TYPE matnr,
      i_rows           TYPE i,
      i_count          TYPE i VALUE '1'.
DATA:i_objectkey          TYPE bapi1003_key-object,
     i_objecttab          TYPE bapi1003_key-objecttable,
     i_classnum           TYPE bapi1003_key-classnum,
     i_classtype          TYPE bapi1003_key-classtype,
     i_status             TYPE bapi1003_key-status VALUE '1',
     i_keydate            TYPE bapi1003_key-keydate,
     st_atnam             TYPE clatnamrange,
     st_allocvalueschar   TYPE bapi1003_alloc_values_char,
     i_atnam              TYPE STANDARD TABLE OF clatnamrange,
     i_allocvaluesnumnew  TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
     i_allocvaluescurrnew TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
     i_allocvalueschar    TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
     i_return             TYPE STANDARD TABLE OF bapiret2.
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
DATA: i_constants   TYPE zcat_constants,
      i_const       TYPE STANDARD TABLE OF zcaconstant,
      gv_total_proc TYPE char05,
      gv_success    TYPE char05,
      gv_error      TYPE char05,
      v_file_path   TYPE string.
DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_C110_2_PRODUCT_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_C110_2_PRODUCT_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_C110_2_PRODUCT_ERR'.
CONSTANTS: c_e      TYPE char1       VALUE 'E',
           c_s      TYPE char1       VALUE 'S',
           c_true   TYPE sap_bool    VALUE 'X',
           c_x      TYPE char1       VALUE 'X',
           c_devid  TYPE zdevid      VALUE 'C110.2',
           c_langu  TYPE char1       VALUE 'E',
           c_param1 TYPE rvari_vnam  VALUE 'NO_OF_RECORDS'.
