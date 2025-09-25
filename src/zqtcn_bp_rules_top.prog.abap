*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_RULES_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF gty_final,                           " Final structure
          field_name TYPE fieldname,                  " Field Name
          rule_type  TYPE as4text,                    " Rule Type
          status     TYPE flag,                       " Status
        END OF gty_final.
DATA : gt_bp_rules TYPE TABLE OF zqtc_bp_rules,       " Internal table
       gw_bp_rules TYPE zqtc_bp_rules,                " Work Area
       gt_final    TYPE TABLE OF gty_final,           " Final Internal table
       gw_final    TYPE gty_final,                    " Work Area
       gv_saved    TYPE char1.                        " Record saved indicator
*--ALV Grid
DATA : o_custom_container TYPE REF TO cl_gui_custom_container,  " Custom Container
       o_container        TYPE scrfname VALUE 'MY_CONTAINER',   " Object of Customer ontainer
       o_grid             TYPE REF TO cl_gui_alv_grid,          " Object of ALV grid
       gt_fieldcat        TYPE lvc_t_fcat,                      " Field catalog Internal Table
       gw_fieldcat        TYPE lvc_s_fcat,                      " Field catalog Work Area
       gw_layout          TYPE lvc_s_layo.                      " Layout Work Area

CONSTANTS : c_i TYPE char1 VALUE 'I',                           " Informative
            c_s TYPE char1 VALUE 'S',                           " Success
            c_x TYPE char1 VALUE 'X',                           " Enable
            c_e TYPE char1 VALUE 'E'.                           " Error

* Module Pool
DATA : rb_disp       TYPE char1 VALUE 'X',                " Display Radio Button
       rb_main       TYPE char1,                          " Maintain Radio Buton
       p_source      TYPE tpm_source_name,                " Input field for Source
       gv_button(20).                                " Button Text
*----------------------------------------------------------------------*
* CLASS lcl_bp_rules DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_bp_rules DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      meth_get_data,                                            " Method to read data
      meth_generate_output.                                     " Method to display output
ENDCLASS. " lcl_bp_rules DEFINITION
