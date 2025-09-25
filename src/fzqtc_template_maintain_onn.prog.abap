*&---------------------------------------------------------------------*
* Include FZQTC_TEMPLATE_MAINTAIN_ONN
* PROGRAM DESCRIPTION: File layout maintain PBO program
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

MODULE status_2000 OUTPUT.

  SET PF-STATUS 'STATUS2000'.         " GUI staus for Screen 2000(Main Screen)
  SET TITLEBAR  'MAINTAIN_TITLE'.     " Title bar for screen 2000

  PERFORM f_dynamic_screen_output.    " Main Screen fields dynamic output based on radio button selection

ENDMODULE.

MODULE value_program_name INPUT.

  DATA : li_zca_programs TYPE STANDARD TABLE OF ty_proname.

  CONSTANTS : lc_name        TYPE dfies-fieldname VALUE 'PROGRAM_NAME',
              lc_value_org   TYPE ddbool_d       VALUE 'S',
              lc_dynprofield TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-PROGRAM_NAME'.

  REFRESH : li_zca_programs[] , i_return[].

  SELECT program_name FROM zca_templates         " Select template name
    INTO TABLE li_zca_programs.

  IF sy-subrc IS INITIAL.

    SORT li_zca_programs BY program_name.
    DELETE ADJACENT DUPLICATES FROM li_zca_programs COMPARING program_name.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_name           "'PROGRAM_NAME'   " reference field
        dynpprog        = sy-repid                            " system program name
        dynpnr          = sy-dynnr                            " current screen
        dynprofield     = lc_dynprofield    "'ST_CONTROL_DATA-PROGRAM_NAME'
        value_org       = lc_value_org      "'S'              " organized value
      TABLES
        value_tab       = li_zca_programs                     " Itab data for programs
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.

MODULE value_template_name INPUT.

  DATA : li_zca_templates TYPE STANDARD TABLE OF ty_tempname.

  CONSTANTS : lc_tname        TYPE dfies-fieldname VALUE 'TEMPLATE_NAME',
              lc_tvalue_org   TYPE ddbool_d        VALUE 'S',
              lc_tdynprofield TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-TEMPLATE_NAME'.

  REFRESH : li_zca_templates[] , i_return[] .

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid         " Current prgram name
      dynumb               = sy-dynnr         " current screen number
      translate_to_upper   = space            " disable the values convert to CAPS
    TABLES
      dynpfields           = i_dynpro_values    " screen fields values
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE i_dynpro_values ASSIGNING <gfs_dynpro_values> INDEX 1.     " Read first screen field value
  IF sy-subrc = 0.
    v_name = <gfs_dynpro_values>-fieldvalue.
  ENDIF.

  SELECT template_name FROM zca_templates         " Select template name
    INTO TABLE li_zca_templates
    WHERE program_name = v_name.

  IF sy-subrc IS INITIAL.

    SORT li_zca_templates BY template_name.
    DELETE ADJACENT DUPLICATES FROM li_zca_templates COMPARING template_name.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_tname           "'Template Name'
        dynpprog        = sy-repid           " current program name
        dynpnr          = sy-dynnr           " current screen
        dynprofield     = lc_tdynprofield    "'ST_CONTROL_DATA-TEMPLATE_NAME' " screen field name
        value_org       = lc_tvalue_org      "'S'                             " organized value
      TABLES
        value_tab       = li_zca_templates      " Itab data for templates
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.

MODULE set_field_names OUTPUT.

  REFRESH i_dynpro_values[].        " Clear Screen fields
  CONSTANTS : lc_field_1 TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-PROGRAM_NAME',   " program name
              lc_field_2 TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-TEMPLATE_NAME',  " template name
              lc_field_3 TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-VERSION'.        " version name

  APPEND INITIAL LINE TO i_dynpro_values ASSIGNING <gfs_dynpro_values>.   " Append 1st fields(Program Name)
  <gfs_dynpro_values>-fieldname = lc_field_1.

  APPEND INITIAL LINE TO i_dynpro_values ASSIGNING <gfs_dynpro_values>.  " Append 2nd fields(Template Name)
  <gfs_dynpro_values>-fieldname = lc_field_2.

  APPEND INITIAL LINE TO i_dynpro_values ASSIGNING <gfs_dynpro_values>.  " Append 3nd fields(Version Name)
  <gfs_dynpro_values>-fieldname = lc_field_3.

ENDMODULE.

MODULE value_version INPUT.

  DATA : li_zca_version TYPE STANDARD TABLE OF ty_version.

  CONSTANTS : lc_vname        TYPE dfies-fieldname VALUE 'VERSION',
              lc_vevalue_org  TYPE ddbool_d  VALUE 'S',
              lc_vdynprofield TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-VERSION'.

  REFRESH : li_zca_version[] , i_return[].

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid         " Current program name
      dynumb               = sy-dynnr         " current screen
      translate_to_upper   = space            " Disable the value conversion for CAPS
    TABLES
      dynpfields           = i_dynpro_values    " Screen field value
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE i_dynpro_values ASSIGNING <gfs_dynpro_values> INDEX 1.     " read first field value
  IF sy-subrc = 0.
    v_name = <gfs_dynpro_values>-fieldvalue.
  ENDIF.
  READ TABLE i_dynpro_values ASSIGNING <gfs_dynpro_values> INDEX 2.     " read second field value
  IF sy-subrc = 0.
    v_tname = <gfs_dynpro_values>-fieldvalue.
  ENDIF.

  SELECT version FROM zca_templates                                     " Select template name
    INTO TABLE li_zca_version
    WHERE program_name EQ v_name AND
          template_name EQ v_tname.

  IF sy-subrc EQ 0.

    SORT li_zca_version BY version.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_version COMPARING version.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_vname              " reference field
        dynpprog        = sy-repid              " current program
        dynpnr          = sy-dynnr              " current screen
        dynprofield     = lc_vdynprofield       " screen field name
        value_org       = lc_vevalue_org        " organize value
      TABLES
        value_tab       = li_zca_version        " itab data for version
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

  ENDIF.

ENDMODULE.

FORM f_dynamic_screen_output.

  IF rb_viewdata = abap_true.
    LOOP AT SCREEN.
      IF screen-name = 'ST_CONTROL_DATA-VERSION'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'VERSION'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'BX_DETAIL'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_ACTIVE'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-ACTIVE'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_LOCATION'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-UPLOAD_LOCATION'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CDATE'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-ERDAT'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CRBY'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-ERNAM'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CTIME'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-ERZET'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-AEDAT'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CHDATE'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-CPUTM'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CHTIME'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-WRICEF_ID'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_WRICEF'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-COMMENTS'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_COMMENTS'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-AENAM'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_CH'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'ST_CONTROL_DATA-FILE_TYPE'.
        screen-active = 0.
      ENDIF.
      IF screen-name = 'LBL_FILEEX'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

ENDFORM.

MODULE value_version_popup INPUT.

  DATA : li_zca_popversion TYPE STANDARD TABLE OF ty_version.

  CONSTANTS : lc_popvname        TYPE dfies-fieldname VALUE 'VERSION',
              lc_popvevalue_org  TYPE ddbool_d  VALUE 'S',
              lc_popvdynprofield TYPE help_info-dynprofld VALUE 'ST_CONTROL_DATA-VERSION',
              lc_screen          TYPE sy-dynnr VALUE '2000'.

  REFRESH : li_zca_version[] , i_return[].

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = lc_screen
      translate_to_upper   = space
    TABLES
      dynpfields           = i_dynpro_values
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE i_dynpro_values ASSIGNING <gfs_dynpro_values> INDEX 1.
  IF sy-subrc = 0.
    v_name = <gfs_dynpro_values>-fieldvalue.
  ENDIF.
  READ TABLE i_dynpro_values ASSIGNING <gfs_dynpro_values> INDEX 2.
  IF sy-subrc = 0.
    v_tname = <gfs_dynpro_values>-fieldvalue.
  ENDIF.

  SELECT version FROM zca_templates         " Select template name
    INTO TABLE li_zca_popversion
    WHERE program_name EQ v_name AND
          template_name EQ v_tname.

  IF sy-subrc EQ 0.

    SORT li_zca_popversion BY version.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_popversion COMPARING version.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_popvname
        dynpprog        = sy-repid
        dynpnr          = lc_screen
        dynprofield     = lc_popvdynprofield
        value_org       = lc_popvevalue_org
      TABLES
        value_tab       = li_zca_popversion
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

  ENDIF.

ENDMODULE.

MODULE screen_values OUTPUT.

  lbl_version = st_control_data-version.                " version number
  st_previous_data-version = st_control_data-version.   " screen version assign as previous version for once return back to
  " main screen
ENDMODULE.

MODULE screen_values_2002 OUTPUT.

  lbl_t5 = st_active_data-version.
  st_previous_data-version = st_control_data-version.   " screen version assign as previous version for once return back to

ENDMODULE.

MODULE status_2003 OUTPUT.

  SET PF-STATUS 'STATUS2003'.     " GUI status for report output screen
  SET TITLEBAR  'VIEW_DATA'.      " Title bar for report output

ENDMODULE.

MODULE f_create_grid OUTPUT.

  CREATE OBJECT v_cc_reportout                " Create object for PO detail custom container
    EXPORTING
      container_name              = v_con_report
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_cc_reportout IS BOUND.

  CREATE OBJECT v_grid                            " Create object for Grid
    EXPORTING
      i_parent          = v_cc_reportout
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_grid IS BOUND.

  CALL METHOD v_grid->set_table_for_first_display          " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = abap_true            " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_template_data[]    " Final output data
      it_fieldcatalog               = i_fieldcat           " Field catalog
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.
