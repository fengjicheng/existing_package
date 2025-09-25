*&---------------------------------------------------------------------*
*&Include  ZQTCN_TEMPLATE_DOWNLOAD_SUB
* PROGRAM DESCRIPTION: File layout download program Subroutine
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

FORM f_getprogram_name CHANGING fp_prname.

  DATA : li_zca_templates TYPE STANDARD TABLE OF ty_proname.

  CONSTANTS : lc_program_name TYPE dfies-fieldname VALUE 'PROGRAM_NAME',
              lc_value_org    TYPE ddbool_d        VALUE 'S'.

  REFRESH : li_zca_templates[] , i_return[].

  SELECT program_name FROM zca_templates
    INTO TABLE li_zca_templates
    WHERE active = abap_true.

  IF sy-subrc EQ 0.

    SORT li_zca_templates BY program_name.
    DELETE ADJACENT DUPLICATES FROM li_zca_templates COMPARING program_name.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_program_name
        value_org       = lc_value_org
      TABLES
        value_tab       = li_zca_templates
        return_tab      = i_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.
      READ TABLE i_return INTO st_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_prname = st_return-fieldval.
      ENDIF.
    ENDIF.
  ELSE.
    MESSAGE s004(zfilupload) DISPLAY LIKE c_errtype.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM f_gettemplate_name CHANGING fp_tmname.

  DATA : li_zca_templates TYPE STANDARD TABLE OF ty_tempname.

  CONSTANTS : lc_template_name TYPE dfies-fieldname VALUE 'TEMPLATE_NAME',
              lc_value_org     TYPE ddbool_d        VALUE 'S'.

  REFRESH : li_zca_templates[] , i_return[].

  SELECT template_name FROM zca_templates         " Select template name
    INTO TABLE li_zca_templates
    WHERE program_name EQ p_prname.

  IF sy-subrc EQ 0.

    SORT li_zca_templates BY template_name.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_templates COMPARING template_name.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_template_name
        value_org       = lc_value_org
      TABLES
        value_tab       = li_zca_templates
        return_tab      = i_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.
      READ TABLE i_return INTO st_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_tmname = st_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_get_version CHANGING fp_versio.

  DATA : li_zca_version TYPE STANDARD TABLE OF ty_version.

  CONSTANTS : lc_wricef_id TYPE dfies-fieldname VALUE 'VERSION',
              lc_value_org TYPE ddbool_d        VALUE 'S'.

  REFRESH : li_zca_version[] , i_return[].

  SELECT version FROM zca_templates         " Select template name
    INTO TABLE li_zca_version
    WHERE program_name EQ p_prname AND
          template_name EQ p_tmname.

  IF sy-subrc EQ 0.

    SORT li_zca_version BY version.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_version COMPARING version.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_wricef_id
        value_org       = lc_value_org
      TABLES
        value_tab       = li_zca_version
        return_tab      = i_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.
      READ TABLE i_return INTO st_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_versio = st_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_get_file_content CHANGING fp_xstr_content
                                 fp_fullpath.

  DATA : lst_filecontent TYPE zca_templates.

  CLEAR : lst_filecontent.

  SELECT SINGLE * FROM zca_templates            " Select file content based on selection screen value
    INTO lst_filecontent
    WHERE program_name = p_prname   AND
          template_name = p_tmname  AND
          version       = p_versio.
  IF sy-subrc IS INITIAL.
    fp_xstr_content = lst_filecontent-file_content.
    TRANSLATE lst_filecontent-file_type TO LOWER CASE.
    CONCATENATE fp_fullpath '.' lst_filecontent-file_type INTO fp_fullpath.
  ENDIF.

ENDFORM.

FORM f_download_file USING fp_xstr_content.

  DATA : lv_filepath TYPE string.

  CLEAR : lv_filepath.

  lv_filepath = p_fpath.       " file path assign to the local variable

  "Convert xstring/rawstring to binary itab
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = fp_xstr_content
    IMPORTING
      output_length = v_len
    TABLES
      binary_tab    = i_content.

  " Download file to presentation server from SAP
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      bin_filesize            = v_len
      filename                = lv_filepath
      filetype                = 'BIN'
    CHANGING
      data_tab                = i_content
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      OTHERS                  = 24.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    MESSAGE s010(zfilupload).
  ENDIF.

ENDFORM.
