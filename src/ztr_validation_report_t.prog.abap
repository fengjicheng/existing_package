*&---------------------------------------------------------------------*
*&  Include           ZTR_VALIDATION_REPORT_T
*&---------------------------------------------------------------------*
TYPES: BEGIN OF g_outtab ,
         light(4)   TYPE c,
         obj_type   TYPE syscomp-obj_type,
         obj_name   TYPE syscomp-obj_name,
         sub_type   TYPE syscomp-sub_type,
         sub_name   TYPE syscomp-sub_name,
         pgmid      TYPE syscomp-pgmid,
         sys1       TYPE syscomp-sys1,
         sys2       TYPE syscomp-sys2,
         objaction  TYPE syscomp-objaction,
         diagnosis  TYPE syscomp-diagnosis,
         diff       TYPE syscomp-diff,
         comp_user  TYPE syscomp-comp_user,
         comp_datum TYPE syscomp-comp_datum,
         comp_time  TYPE syscomp-comp_time,
         notice     TYPE  syscomp-notice,
         color_line(4) TYPE c,
         tcolor TYPE slis_t_specialcol_alv,    "cell
*it_diff TYPE abapprog  ,
       END OF g_outtab,
       BEGIN OF gty_final,
         light(4)   TYPE c,
         obj_type   TYPE syscomp-obj_type,
         obj_name   TYPE syscomp-obj_name,
         sub_type   TYPE syscomp-sub_type,
         sub_name   TYPE syscomp-sub_name,
         pgmid      TYPE syscomp-pgmid,
*         sys1       TYPE syscomp-sys1,
*         sys2       TYPE syscomp-sys2,
         objaction  TYPE syscomp-objaction,
*         diagnosis  TYPE syscomp-diagnosis,
*         diff       TYPE syscomp-diff,
         comp_user  TYPE syscomp-comp_user,
         comp_datum TYPE syscomp-comp_datum,
         comp_time  TYPE syscomp-comp_time,
        END OF gty_final.

DATA:     lv_targetsystem TYPE tmscsys-sysnam.
CONSTANTS:
*& must be used.
  gc_objects_equal     TYPE i VALUE 0,
  gc_objects_not_equal TYPE i VALUE 1,
  gc_noversion1        TYPE i VALUE 2,
  gc_noversion2        TYPE i VALUE 3,
  gc_noversion12       TYPE i VALUE 4,
  gc_objects_unknown   TYPE i VALUE 10, " obj/comp. routi.unknow
  gc_objects_exception TYPE i VALUE 11, "  exception
  gc_obj_db_click      TYPE i VALUE 12, "
*& maybe used.
  gc_versionunread1    TYPE i VALUE 5,
  gc_versionunread2    TYPE i VALUE 6,
  gc_versionunread12   TYPE i VALUE 7,
  gc_rfc_error         TYPE i VALUE 8,
  gc_internal_error    TYPE i VALUE 9.


*& constants for  display .
CONSTANTS: gc_light_green  TYPE c VALUE '3',
           gc_light_yellow TYPE c VALUE '2',
           gc_light_red    TYPE c VALUE '1'.
DATA:  lv_num_main2(10) TYPE c,
       lv_num_time(10)  TYPE c,
       lv_complangs     TYPE c,
       lv_show_nonvers  TYPE c,
       lv_show_docus    TYPE c.
DATA:  is_comp_saved(1) TYPE c,
       lv_text(50)      TYPE c,
       lv_answer        TYPE c.
DATA: gt_outtab TYPE TABLE OF g_outtab,
      gs_outtab TYPE g_outtab . " itab for display
DATA: gv_num_total   TYPE i,
      gv_num_unequal TYPE i,
      gv_num_unkown  TYPE i.

DATA: gv_num_total_c(8)   TYPE c,
      gv_num_unequal_c(8) TYPE c,
      gv_num_unkown_c(8)  TYPE c.

DATA: gv_rfcdest TYPE rfcdes-rfcdest,
      gt_e070v   TYPE STANDARD TABLE OF e070v,
      gs_e070v   TYPE e070v,
      gs_e071    TYPE e071.


CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column.

ENDCLASS.                    "lcl_handle_events DEFINITION

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_link_click.
    DATA: lo_alv  TYPE REF TO cl_salv_table,
          lo_sort TYPE REF TO cl_salv_sorts.

*... §3 Functions
    DATA: lr_functions        TYPE REF TO cl_salv_functions_list,
          lr_display_settings TYPE REF TO cl_salv_display_settings,
          lo_aggrs            TYPE REF TO cl_salv_aggregations.

    lo_aggrs = lo_alv->get_aggregations( ).

    lr_functions = lo_alv->get_functions( ).
    lr_display_settings = lo_alv->get_display_settings( ).

*... §3.1 activate ALV generic Functions
    lr_functions->set_all( abap_true ).

    lr_display_settings->set_striped_pattern( abap_true ).

*... set the columns technical
    DATA: lr_columns TYPE REF TO cl_salv_columns_table,
          lr_column  TYPE REF TO cl_salv_column_table.

    lr_columns = lo_alv->get_columns( ).
    lo_sort    = lo_alv->get_sorts( ).

        lr_column ?= lr_columns->get_column( 'LIGHT' ).
        lr_column->set_short_text( 'Status' ).  "Will cause syntax error if text is too long
      lr_column->set_medium_text( 'Status' ).
      lr_column->set_long_text( 'Status' ).

        lr_column ?= lr_columns->get_column( 'OBJ_TYPE' ).
*        lr_column->set_short_text('Desc.').
*        lr_column->set_medium_text('Description').
*        lr_column->set_long_text('Description').
        lr_column ?= lr_columns->get_column( 'OBJ_NAME' ).
        lr_column ?= lr_columns->get_column( 'SUB_TYPE' ).
        lr_column ?= lr_columns->get_column( 'SUB_NAME' ).
        lr_column ?= lr_columns->get_column( 'PGMID' ).
        lr_column ?= lr_columns->get_column( 'OBJACTION' ).
        lr_column ?= lr_columns->get_column( 'COMP_USER' ).
        lr_column ?= lr_columns->get_column( 'COMP_DATUM' ).
        lr_column ?= lr_columns->get_column( 'COMP_TIME' ).
    lr_columns->set_optimize( abap_true ).

    lo_alv->display( ).

  ENDMETHOD.

ENDCLASS.

DATA: gr_events TYPE REF TO lcl_handle_events.


* Email related decalrations

DATA:i_message        TYPE STANDARD TABLE OF solisti1,                  " Itab to hold message for email
     i_attach_success TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_attach_error   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_attach_total   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
     i_packing_list   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,        " Itab to hold packing list for email
     i_receivers      LIKE somlreci1 OCCURS 0 WITH HEADER LINE,         " Itab to hold mail receipents
     i_attachment     LIKE solisti1 OCCURS 0 WITH HEADER LINE,          " Itab to hold attachmnt for email
     st_imessage      TYPE solisti1,                                    " Messages
     g_job_name       TYPE tbtcjob-jobname,                             " Job Name
     g_receiver       TYPE so_recname.                                  "Mail Receivers names


CONSTANTS : c_raw        TYPE char3      VALUE 'RAW',
            c_u          TYPE char1      VALUE 'U',                      " U of Type CHAR1
            c_int        TYPE char3      VALUE 'INT',
            c_x          TYPE char1      VALUE 'X',
            c_i          TYPE char1      VALUE 'I',
            c_s          TYPE char1      VALUE 'S'.


  DATA:  lt_e071_tem  TYPE STANDARD TABLE OF e071,
         lt_e071_tem2 TYPE STANDARD TABLE OF e071,
         lt_e071_tem3 TYPE STANDARD TABLE OF e071,
         lt_e071_both TYPE STANDARD TABLE OF e071,
         et_only1     TYPE STANDARD TABLE OF   e071,
         et_only2     TYPE STANDARD TABLE OF   e071.

  DATA: ev_diagnosis      TYPE i,
        ev_diff_info(120) TYPE c,
        lv_num_main       TYPE  i,
        ls_vrso           TYPE  vrso,
        lt_vrso_tmp       TYPE TABLE OF vrso,
        lt_vrso           TYPE TABLE OF vrso.


  DATA: lt_index      TYPE lvc_t_row,
        ls_index      TYPE lvc_s_row,
        gs_e071_exc   TYPE e071,
        gs_e071_check TYPE e071.

  DATA: gt_e071_12_sel TYPE TABLE OF e071,
        gs_e071_sel    TYPE e071,
        gs_e071_tem    TYPE e071,
        la_e071        TYPE e071.

  DATA : ls_outtab_sts TYPE  g_outtab.
  DATA: lt_compare_items TYPE vrs_compare_item_tab,
        ls_compare_item  LIKE LINE OF lt_compare_items,
        ls_rfcsi_a       TYPE rfcsi,
        ls_rfcsi_b       TYPE rfcsi,
        lt_nonvers       TYPE TABLE OF e071,
        ls_nonvers       TYPE e071.

  DATA : ls_rfcsi_export TYPE  rfcsi.
  DATA: lo_alv   TYPE REF TO cl_salv_table.
  DATA: t_final  TYPE STANDARD TABLE OF gty_final.
