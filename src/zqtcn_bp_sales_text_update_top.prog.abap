*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_SALES_TEXT_UPDATE_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS :slis.
TYPES: BEGIN OF ty_bp_details,
         source   TYPE  char20,
         partner  TYPE  bu_partner,  " Business Partner
         vkorg    TYPE  vkorg,       "Sales org
         vtweg    TYPE  vtweg,       "Dist. Channel
         spart    TYPE  spart,       "Division
         type     TYPE bu_id_type, "Identification Type
         idnumber TYPE bu_id_number, "Identification Number
         tdid     TYPE  tdid,        "Text ID
         spras    TYPE  spras,       "Language
         ltext    TYpe  char2048, "ltext,       "Long Text
       END OF ty_bp_details.

TYPES: BEGIN OF ty_bp,
         source   TYPE  char20,
         partner  TYPE  bu_partner,    " Business Partner
         vkorg    TYPE  vkorg,         "Sales org
         vtweg    TYPE  vtweg,         "Dist. Channel
         spart    TYPE  spart,         "Division
         type     TYPE  bu_id_type,   "Identification Type
         idnumber TYPE  bu_id_number, "Identification Number
         tdid     TYPE  tdid,          "Text ID
         spras    TYPE  spras,         "Language
         ltext    TYPE  char2048,         "Long Text
         status   TYPE  char10,        "Status
         message  TYPE  char255,       "Message
       END OF ty_bp,


   BEGIN OF ty_final,
         source   TYPE  char20,
         partner  TYPE  bu_partner,    " Business Partner
         vkorg    TYPE  vkorg,         "Sales org
         vtweg    TYPE  vtweg,         "Dist. Channel
         spart    TYPE  spart,         "Division
         type     TYPE  bu_id_type,   "Identification Type
         idnumber TYPE  bu_id_number, "Identification Number
         tdid     TYPE  tdid,          "Text ID
         spras    TYPE  spras,         "Language
*         ltext    TYPE  char2048,         "Long Text
         status   TYPE  char10,        "Status
         message  TYPE  char255,       "Message
       END OF ty_final.

TYPES : BEGIN OF ty_text,
          text TYPE TDLINE,
        END OF ty_text.

DATA:  i_bp_data   TYPE STANDARD TABLE OF ty_bp_details,
       i_bp_data_main   TYPE STANDARD TABLE OF ty_bp_details,
       i_bp_sel    TYPE STANDARD TABLE OF ty_bp_details,
       i_bp_find   TYPE STANDARD TABLE OF ty_bp_details,
       i_final     TYPE STANDARD TABLE OF ty_final,
       i_final_err TYPE STANDARD TABLE OF ty_final,
       i_final_suc TYPE STANDARD TABLE OF ty_final,
       i_const     TYPE STANDARD TABLE OF zcaconstant,
       i_rows      TYPE salv_t_row,
       i_text      TYPE TABLE OF ty_text.

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

DATA : gv_total      TYPE char10,
       gv_total_proc TYPE char10,
       gv_success    TYPE char10,
       gv_error      TYPE char10.

CONSTANTS: c_true     TYPE sap_bool VALUE 'X',
           c_devid    TYPE zdevid     VALUE 'C105_1',
           c_param1   TYPE rvari_vnam VALUE 'NO_OF_RECORDS',
           c_param2   TYPE rvari_vnam VALUE 'FILE_PATH',
           c_object   TYPE char04     VALUE 'KNVV',
           c_x        TYPE char01     VALUE 'X',
           c_asc      TYPE char10     VALUE 'ASC',
           c_tdf      TYPE char01     VALUE '*',
           c_tdtxl    TYPE TDTXTLINES     VALUE '00020',
           c_tdl      TYPE TDLINESIZE     VALUE '132',
           c_e        TYPE char01     VALUE 'E',
           c_s        TYPE char01     VALUE 'S',
           c_i        TYPE char01     VALUE 'I',
           c_suc      TYPE char07 VALUE 'SUCCESS',
           c_err      TYPE char05 VALUE 'ERROR',
           c_err_file TYPE char19 VALUE 'BP_SALES_TXT_ERROR_',
           c_suc_file TYPE char21 VALUE 'BP_SALES_TXT_SUCCESS_'.
