*&---------------------------------------------------------------------*
*&  Include           RJKSDPROTOCOLF02
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS lcl_handler_detail DEFINITION
*---------------------------------------------------------------------*
*       Eventhandler
*---------------------------------------------------------------------*
CLASS lcl_handler_detail DEFINITION.
  PUBLIC SECTION.
    METHODS:
*     Anpassen der Toolbar
      handle_toolbar
                  FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

*     Event Usercommand
      user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.                    "lcl_handler_detail DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handler_detail IMPLEMENTATION
*---------------------------------------------------------------------*
*       Implementierung des Eventhandlers
*---------------------------------------------------------------------*
CLASS lcl_handler_detail IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA: button  TYPE stb_button,
          toolbar TYPE ttb_button.

* nicht benötigte Funtionen aus der Toolbar entfernen
    DELETE e_object->mt_toolbar[] WHERE
      function = cl_gui_alv_grid=>mc_fc_refresh        OR
      function = cl_gui_alv_grid=>mc_fc_loc_append_row OR
      function = cl_gui_alv_grid=>mc_fc_loc_copy       OR
      function = cl_gui_alv_grid=>mc_fc_loc_copy_row   OR
      function = cl_gui_alv_grid=>mc_fc_loc_cut        OR
      function = cl_gui_alv_grid=>mc_fc_loc_insert_row OR
      function = cl_gui_alv_grid=>mc_fc_loc_paste      OR
      function = cl_gui_alv_grid=>mc_fc_info           OR
      function = cl_gui_alv_grid=>mc_fc_graph          OR
      function = cl_gui_alv_grid=>mc_fc_detail         OR
      function = cl_gui_alv_grid=>mc_mb_view           OR
      function = cl_gui_alv_grid=>mc_fc_check          OR
      function = cl_gui_alv_grid=>mc_fc_loc_undo       OR
      function = cl_gui_alv_grid=>mc_fc_loc_delete_row.

    MOVE con_fcode_longtext TO button-function.
    MOVE text-504 TO button-quickinfo.
    button-icon = icon_system_help.
    APPEND button TO toolbar.

    APPEND LINES OF e_object->mt_toolbar[] TO toolbar.
    e_object->mt_toolbar[] = toolbar[].
  ENDMETHOD.                    "handle_toolbar

  METHOD user_command.
    CONSTANTS const_docu_id_msg TYPE dokhl-id VALUE 'NA'.
    DATA: detail       TYPE t_detail,
          row          TYPE i,
          help         TYPE help_info,
          dynpselect   TYPE STANDARD TABLE OF dselc,
          dynpvaluetab TYPE STANDARD TABLE OF dval.

    CASE e_ucomm.
      WHEN con_fcode_longtext.
        CALL METHOD protocol_detail->get_current_cell
          IMPORTING
            e_row = row.
        IF row IS INITIAL.
          MESSAGE i150(jksdcontract).
        ELSE.
          READ TABLE detail_tab INTO detail
            INDEX row.
          CHECK sy-subrc = 0.
          help-call      = 'D'.
          help-spras     = sy-langu.
          help-messageid = detail-msgid.
          help-messagenr = detail-msgno.
          help-title     = text-120.
          help-docuid    = const_docu_id_msg.
          help-msgv1     = detail-msgv1.
          help-msgv2     = detail-msgv2.
          help-msgv3     = detail-msgv3.
          help-msgv4     = detail-msgv4.

          CALL FUNCTION 'HELP_START'
            EXPORTING
              help_infos   = help
            TABLES
              dynpselect   = dynpselect
              dynpvaluetab = dynpvaluetab
            EXCEPTIONS
              OTHERS       = 0.
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "user_command
ENDCLASS.                    "lcl_handler_detail

*---------------------------------------------------------------------*
*       CLASS lcl_handler_overview DEFINITION
*---------------------------------------------------------------------*
*       Eventhandler für überblick Protokolle
*---------------------------------------------------------------------*
CLASS lcl_handler_overview DEFINITION.
  PUBLIC SECTION.
    METHODS:
*     Anpassen der Toolbar
      handle_toolbar
                  FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

      double_click
                  FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row
                  e_column,

      hotspot_click
                  FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id,

*     Event Usercommand
      user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.                    "lcl_handler_overview DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handler_overview IMPLEMENTATION
*---------------------------------------------------------------------*
*       Implementierung des Eventhandlers
*---------------------------------------------------------------------*
CLASS lcl_handler_overview IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA: button  TYPE stb_button,
          toolbar TYPE ttb_button.

*   nicht benötigte Funtionen aus der Toolbar entfernen
    DELETE e_object->mt_toolbar[] WHERE
      function = cl_gui_alv_grid=>mc_fc_refresh        OR
      function = cl_gui_alv_grid=>mc_fc_loc_append_row OR
      function = cl_gui_alv_grid=>mc_fc_loc_copy       OR
      function = cl_gui_alv_grid=>mc_fc_loc_copy_row   OR
      function = cl_gui_alv_grid=>mc_fc_loc_cut        OR
      function = cl_gui_alv_grid=>mc_fc_loc_insert_row OR
      function = cl_gui_alv_grid=>mc_fc_loc_paste      OR
      function = cl_gui_alv_grid=>mc_fc_info           OR
      function = cl_gui_alv_grid=>mc_fc_graph          OR
      function = cl_gui_alv_grid=>mc_fc_detail         OR
      function = cl_gui_alv_grid=>mc_mb_view           OR
      function = cl_gui_alv_grid=>mc_fc_check          OR
      function = cl_gui_alv_grid=>mc_fc_loc_undo       OR
      function = cl_gui_alv_grid=>mc_fc_loc_delete_row.

    MOVE con_fcode_delete_protocol TO button-function.
    MOVE text-505 TO button-quickinfo.
    button-icon = icon_delete.
    APPEND button TO toolbar.

    APPEND LINES OF e_object->mt_toolbar[] TO toolbar.
    e_object->mt_toolbar[] = toolbar[].
  ENDMETHOD.                    "handle_toolbar

  METHOD user_command.
    DATA: row         TYPE i,
          row_table   TYPE STANDARD TABLE OF i,
          overview    TYPE t_overview,
          rowid       TYPE lvc_s_roid,
          rowid_table TYPE lvc_t_roid,
          xlocked     TYPE xfeld.

    CASE e_ucomm.
      WHEN con_fcode_delete_protocol.
        protocol_overview->get_selected_rows( IMPORTING et_row_no = rowid_table ).
        IF ( rowid_table[] IS NOT INITIAL ).
          LOOP AT rowid_table INTO rowid.
            row = rowid-row_id.
            INSERT row INTO TABLE row_table.
          ENDLOOP.
        ELSE.
          protocol_overview->get_current_cell( IMPORTING e_row = row ).
          IF ( row IS NOT INITIAL ).
            INSERT row INTO TABLE row_table.
          ENDIF.
        ENDIF.
        IF ( row_table IS INITIAL ).
          MESSAGE i162(jksdprotocol).
        ELSE.
          SORT row_table DESCENDING.
          LOOP AT row_table INTO row.
            READ TABLE overview_tab INTO overview INDEX row.
            IF ( overview-readonly IS NOT INITIAL ).
              xlocked = abap_true.
            ELSE.
              INSERT overview INTO TABLE delete_overview_tab.
              DELETE overview_tab WHERE logid = overview-logid.
            ENDIF.
          ENDLOOP.
          IF ( delete_overview_tab[] IS NOT INITIAL ).
            PERFORM refresh_overview_on_screen.
            IF ( detail_tab[] IS NOT INITIAL ).
              CLEAR detail_tab[].
              PERFORM refresh_detail_on_screen.
              PERFORM hide_detail.
            ENDIF.
          ENDIF.
          IF ( xlocked = abap_true ).
            MESSAGE i163(jksdprotocol).
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "user_command

  METHOD double_click.
    DATA overview TYPE t_overview.

    CHECK NOT ( e_column-fieldname = 'COUNT1'  OR
                e_column-fieldname = 'COUNT2'  OR
                e_column-fieldname = 'COUNT3'  OR
                e_column-fieldname = 'COUNT4'  OR
                e_column-fieldname = 'COUNT5'  OR
                e_column-fieldname = 'COUNT6'  OR
                e_column-fieldname = 'COUNT7'  OR
                e_column-fieldname = 'COUNT8'  OR
                e_column-fieldname = 'COUNT9'  OR
                e_column-fieldname = 'COUNT10' OR
                e_column-fieldname = 'COUNT11' OR
                e_column-fieldname = 'COUNT12' OR
                e_column-fieldname = 'COUNT13' OR
                e_column-fieldname = 'COUNT14' OR
                e_column-fieldname = 'COUNT15' OR
                e_column-fieldname = 'COUNT16' OR
                e_column-fieldname = 'COUNT17' OR
                e_column-fieldname = 'COUNT18' OR
                e_column-fieldname = 'COUNT19' OR
                e_column-fieldname = 'COUNT20' ).

    PERFORM get_changed_data.
    READ TABLE overview_tab INTO overview INDEX e_row-index.
    PERFORM show_detail_on_screen USING overview
                                        e_column-fieldname.
  ENDMETHOD.                    "double_click

  METHOD hotspot_click.
    DATA overview TYPE t_overview.

    PERFORM get_changed_data.
    READ TABLE overview_tab INTO overview INDEX e_row_id-index.
    PERFORM show_detail_on_screen USING overview
                                        e_column_id-fieldname.
  ENDMETHOD.                    "double_click
ENDCLASS.                    "lcl_handler_overview IMPLEMENTATION
