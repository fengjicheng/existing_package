**----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_UPDATE_TOP                   *
* PROGRAM DESCRIPTION:   Program to update the Address details in Business
*                        partners from file
* DEVELOPER:             KJAGANA
* CREATION DATE:         02/13/2019
* OBJECT ID:             C105
* TRANSPORT NUMBER(S):   ED2K914456
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO         : ED2K918391
* REFERENCE NO        : ERPM-11885/C105
* DEVELOPER           : VDPATABALL
* DATE                : 06/05/2020
* DESCRIPTION         : Multiple E-mail IDs to BP contact Update
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_UPDATE_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS : slis.
TYPES: BEGIN OF ty_bp_details,
         source    TYPE  zresource,    "Source Field
         partner   TYPE  bu_partner, "Business Partner
         idtype    TYPE  bu_id_type,  "Identication category
         idnum     TYPE  bu_id_number, "Identification Number
         function  TYPE  pafkt,      "Function
         lastname  TYPE  knvk-name1, "Last Name,
         firstname TYPE  knvk-namev, "First Name,
         langu     TYPE  spras,      "Language
         country   TYPE  land1,      "Country
         e_mail    TYPE  ad_smtpadr,  "SMTP
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
         e_mail1   TYPE ad_smtpadr,
         e_mail2   TYPE ad_smtpadr,
         e_mail3   TYPE ad_smtpadr,
         e_mail4   TYPE ad_smtpadr,
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
         flag      TYPE char1,
       END OF ty_bp_details,

       BEGIN OF ty_alv_disp,
         source  TYPE  zresource,
         kunnr   TYPE kunnr,
         idtype  TYPE  bu_id_type,  "Identication category
         idnum   TYPE  bu_id_number, "Identification Number
         namev   TYPE namev_vp, "first name
         name1   TYPE name1_gp, "Last Name
         pafkt   TYPE pafkt, "Function.
*         prsnr TYPE ad_persnum, "Person number
         mail    TYPE ad_smtpadr, "Mail id.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
         e_mail1   TYPE ad_smtpadr,
         e_mail2   TYPE ad_smtpadr,
         e_mail3   TYPE ad_smtpadr,
         e_mail4   TYPE ad_smtpadr,
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
         msgtyp  TYPE char10, "string,
         msg     TYPE char255, "string,
       END OF ty_alv_disp,
       BEGIN OF ty_check_bp,
         kunnr TYPE kunnr,
         namev TYPE namev_vp, "first name
         name1 TYPE name1_gp, "Last Name
         pafkt TYPE pafkt, "Function.
         prsnr TYPE ad_persnum, "Person number
       END OF ty_check_bp,
       BEGIN OF ty_idnum,
         partner TYPE  bu_partner, "Business Partner
         type    TYPE  bu_id_type,
         idnum   TYPE  bu_id_number, "Identification Number
       END OF ty_idnum,
       BEGIN OF ty_adr6,
         pernr TYPE ad_persnum,
         mail  TYPE ad_smtpadr,
       END OF ty_adr6,
       BEGIN OF ty_mail,
         kunnr TYPE kunnr,
         namev TYPE namev_vp, "first name
         name1 TYPE name1_gp, "Last Name
         pafkt TYPE pafkt, "Function.
         prsnr TYPE ad_persnum, "Person number
         mail  TYPE ad_smtpadr, "Mail id.
       END OF ty_mail.

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
      ir_selections TYPE REF TO cl_salv_selections,
      ir_table_alv  TYPE REF TO cl_salv_table.

DATA:
  i_check       TYPE STANDARD TABLE OF ty_check_bp,
  i_adr6        TYPE STANDARD TABLE OF ty_adr6,
  i_bp_data     TYPE STANDARD TABLE OF ty_bp_details,
  i_bp_data_t   TYPE STANDARD TABLE OF ty_bp_details,
  i_bp_data_tmp TYPE STANDARD TABLE OF ty_bp_details,
  i_bp_data_cnt TYPE STANDARD TABLE OF ty_bp_details,
*  i_bp_data_gbl TYPE STANDARD TABLE OF ty_bp_details,
  i_alv_disp    TYPE STANDARD TABLE OF ty_alv_disp,
  i_alv_log     TYPE STANDARD TABLE OF ty_alv_disp, "Error log
  i_alv_slog    TYPE STANDARD TABLE OF ty_alv_disp, "Succeess log
  i_rows        TYPE salv_t_row,
  i_const       TYPE TABLE OF zcaconstant,
  i_bdcdata     TYPE TABLE OF bdcdata , "BDCDATA
  i_bdcmsg      TYPE TABLE OF bdcmsgcoll. "BDC message table

DATA :
  gv_check         TYPE char1,
  gv_total_proc    TYPE char05,
  gv_success       TYPE char05,
  gv_lines         TYPE char05,
  gv_error         TYPE char05,
  gv_records       TYPE char05,
  gv_no_of_records TYPE i.

CONSTANTS:

  c_s           TYPE flag VALUE 'S',
  c_w           TYPE flag VALUE 'W',
  c_e           TYPE flag VALUE 'E',
  c_true        TYPE sap_bool VALUE 'X',
  c_devid       TYPE zdevid     VALUE 'C105',
  c_param1      TYPE rvari_vnam VALUE 'NO_OF_RECORDS',
  c_param2      TYPE rvari_vnam VALUE 'FILE_PATH',
  c_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
  c_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
  c_option_eq   TYPE tvarv_opti VALUE 'EQ'. "ABAP: Selection option (EQ/BT/CP/...).
