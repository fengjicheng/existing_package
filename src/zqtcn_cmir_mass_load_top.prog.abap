*&---------------------------------------------------------------------*
*&  Include          ZQTCN_CMIR_MASS_LOAD_TOP
*&---------------------------------------------------------------------*
*&*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_CMIR_MASS_LOAD
* PROGRAM DESCRIPTION:   Program to Maintain Customer-Material Info
*                        from file
* DEVELOPER:             VDPATABALL
* CREATION DATE:         02/14/2019
* OBJECT ID:             C107
* TRANSPORT NUMBER(S):   ED2K914467
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_cm_details,
         kunnr   TYPE kunnr_v,
         vkorg   TYPE vkorg,
         vtweg   TYPE vtweg,
         matnr   TYPE matnr,
         message TYPE bapi_msg,
       END OF ty_cm_details,

       BEGIN OF ty_kna1,
        kunnr TYPE kunnr,
       END OF ty_kna1,

       BEGIN OF ty_mara,
         matnr TYPE matnr,
       END OF ty_mara.



DATA: i_data TYPE STANDARD TABLE OF alsmex_tabline,
      i_mara TYPE STANDARD TABLE OF ty_mara,
      i_kna1 TYPE STANDARD TABLE OF ty_kna1.

DATA: i_cm_data    TYPE STANDARD TABLE OF ty_cm_details,
      i_knmt_exist TYPE STANDARD TABLE OF ty_cm_details,
      i_sucess_rec TYPE STANDARD TABLE OF ty_cm_details,
      i_error_rec  TYPE STANDARD TABLE OF ty_cm_details.
##CLASS_FINAL
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

DATA: gr_events     TYPE REF TO lcl_handle_events,
      gr_table      TYPE REF TO cl_salv_table,
      gr_selections TYPE REF TO cl_salv_selections.
DATA: i_const       TYPE STANDARD TABLE OF zcaconstant,
      gv_total_proc TYPE char05,
      gv_success    TYPE char05,
      gv_error      TYPE char05.

CONSTANTS: c_x       TYPE flag        VALUE 'X'.
CONSTANTS: c_true   TYPE sap_bool    VALUE 'X',
           c_devid  TYPE zdevid      VALUE 'C105',
           c_param1 TYPE rvari_vnam  VALUE 'NO_OF_RECORDS',
           c_param2 TYPE rvari_vnam  VALUE 'FILE_PATH'.
