*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TEMPLATE_UPLOAD_SUB
* PROGRAM DESCRIPTION: File layout Upload subroutine
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*
FORM f_getprogram_name CHANGING fp_prname.

  DATA : li_program TYPE STANDARD TABLE OF ty_proname.

  CONSTANTS : lc_program_type TYPE trdir-subc      VALUE '1',
              lc_name         TYPE dfies-fieldname VALUE 'NAME',
              lc_value_org    TYPE ddbool_d        VALUE 'S',
              lc_prname       TYPE trdir-name      VALUE 'Z%'.

  REFRESH : li_program[] , i_return[].

  SELECT name FROM trdir                  " Select program name from SAP standard table
    INTO TABLE li_program
    WHERE subc = lc_program_type  AND
      name LIKE lc_prname.

  IF sy-subrc EQ 0.
    SORT li_program BY name.                " Sort Itab
    DELETE ADJACENT DUPLICATES FROM li_program COMPARING name.        " delete duplicates from Itab

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_name           " reference field
        value_org       = lc_value_org      " organize value
        dynprofield     = 'P_PRNAME'
        display         = 'F'
      TABLES
        value_tab       = li_program        " data itab
        return_tab      = i_return          " return tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.                                   " Check return table values
      READ TABLE i_return INTO st_return INDEX 1.                 " Read first record of the return table
      IF sy-subrc EQ 0.
        fp_prname = st_return-fieldval.
      ENDIF.
    ENDIF.
  ELSE.                                                         " return is null
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
    WHERE program_name EQ p_prname AND
          active EQ abap_true.

  IF sy-subrc EQ 0.

    SORT li_zca_templates BY template_name.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_templates COMPARING template_name.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_template_name          " reference field
        value_org       = lc_value_org              " organize value
      TABLES
        value_tab       = li_zca_templates          " Data itab
        return_tab      = i_return                  " return table
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.                       " Check itab is initial
      READ TABLE i_return INTO st_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_tmname = st_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_getwricef_id CHANGING fp_wricef.

  DATA : li_zca_templates TYPE STANDARD TABLE OF ty_wricefid.

  CONSTANTS : lc_wricef_id TYPE dfies-fieldname VALUE 'WRICEF_ID',
              lc_value_org TYPE ddbool_d        VALUE 'S'.

  REFRESH : li_zca_templates[] , i_return[].

  SELECT wricef_id FROM zca_templates       " Select WRICEF ID
    INTO TABLE li_zca_templates
    WHERE active EQ abap_true.

  IF sy-subrc EQ 0.

    SORT li_zca_templates BY wricef_id.                                       " Sort the DS according to the templete name
    DELETE ADJACENT DUPLICATES FROM li_zca_templates COMPARING wricef_id.     " Delete duplicates

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lc_wricef_id                " reference field
        value_org       = lc_value_org                " Organize value
      TABLES
        value_tab       = li_zca_templates            " Data Itab
        return_tab      = i_return                    " retun itab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF i_return IS NOT INITIAL.                         " Check Itab is initial
      READ TABLE i_return INTO st_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_wricef = st_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_update_record USING fp_activeflag
                           fp_fname
                           fp_xstr_content
                           fp_wricef
                           fp_comme
                           fp_version.

  "Update file into table
  UPDATE zca_templates SET version = fp_version
                           active  = fp_activeflag
                           upload_location = fp_fname
                           file_content = fp_xstr_content
                           aedat = sy-datum
                           aenam = sy-uname
                           cputm = sy-uzeit
                           wricef_id = fp_wricef
                           comments = fp_comme
                           WHERE program_name = p_prname AND
                                 template_name = p_tmname.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'         " transaction commit
      EXPORTING
        wait = abap_true.
    MESSAGE s002(zfilupload).
  ELSE.
    ROLLBACK WORK.                                  "transaction rollback
    MESSAGE s003(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

ENDFORM.

FORM f_insert_record  USING fp_prname
                            fp_tmname
                            fp_activeflag
                            fp_fname
                            fp_xstr_content
                            fp_wricef
                            fp_comme
                            fp_initial_version.

  DATA : lst_record_insert TYPE zca_templates.            " data declaration for record insert

** Assign screen data to table structure
  lst_record_insert-program_name = fp_prname.
  lst_record_insert-template_name = fp_tmname.
  lst_record_insert-version = fp_initial_version.
  lst_record_insert-active = fp_activeflag.
  lst_record_insert-upload_location = fp_fname.
  lst_record_insert-file_content = fp_xstr_content.
  lst_record_insert-erdat = sy-datum.
  lst_record_insert-ernam = sy-uname.
  lst_record_insert-erzet = sy-uzeit.
  lst_record_insert-wricef_id = fp_wricef.
  lst_record_insert-comments = fp_comme.
  lst_record_insert-file_type = v_extension.

  INSERT zca_templates FROM lst_record_insert.              " Insert data to custom layout maintain table

  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'                 " transaction commit
      EXPORTING
        wait = abap_true.
    MESSAGE s002(zfilupload).
  ELSE.
    ROLLBACK WORK.                                          " transaction rollback
    MESSAGE s003(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

ENDFORM.

FORM f_check_existing_version CHANGING fp_temversion
                                       fp_xstr_content_exist.

  DATA : li_version_data TYPE STANDARD TABLE OF zca_templates.

  REFRESH li_version_data[].

  SELECT * FROM zca_templates
    INTO TABLE li_version_data
    WHERE program_name = p_prname    AND
          template_name = p_tmname.
  IF sy-subrc IS INITIAL.
    SORT li_version_data BY version DESCENDING.                                           " Sort DSC to capture latese version
    READ TABLE li_version_data ASSIGNING FIELD-SYMBOL(<lfs_version_data>) INDEX 1.        " Read Updated veesion from the Itab
    IF sy-subrc = 0.
      fp_temversion = <lfs_version_data>-version.
      fp_xstr_content_exist = <lfs_version_data>-file_content.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_get_comment CHANGING fp_comme.

  DATA: li_text TYPE catsxt_longtext_itab.

  CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'         " Enter long comment
    EXPORTING
      im_title        = text-003
      im_start_column = 10
      im_start_row    = 10
    CHANGING
      ch_text         = li_text.

  IF li_text IS NOT INITIAL.
    LOOP AT li_text ASSIGNING FIELD-SYMBOL(<lfs_text>).
      CONCATENATE fp_comme <lfs_text> INTO fp_comme.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_inactive_record USING fp_prname
                             fp_tmname
                             fp_preversion.

  " Update DB table
  UPDATE zca_templates SET active = abap_false
                           aedat = sy-datum
                           aenam = sy-uname
                           cputm = sy-uzeit
                           WHERE program_name = fp_prname       AND
                                 template_name  = fp_tmname     AND
                                 version = fp_preversion.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s007(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

ENDFORM.

FORM f_process_data .

  DATA : lv_zca_templates TYPE zca_templates,         " Data declaration for template exist validation
         lv_curversion    TYPE zca_templates-version,
         lv_preversion    TYPE zca_templates-version.

  CONSTANTS : lv_initial_version TYPE zca_templates-version VALUE '1'.

  CLEAR : lv_zca_templates , v_popup_return.

  SELECT SINGLE * FROM zca_templates                                  " Select template details based on selection screen input
    INTO lv_zca_templates
    WHERE program_name = p_prname    AND
          template_name = p_tmname.

  IF sy-subrc NE 0.                                                   " Program & Template Name combination not found
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = text-004
        text_question         = text-010
        text_button_1         = text-006
        text_button_2         = text-007
        default_button        = text-008
        display_cancel_button = space
      IMPORTING
        answer                = v_popup_return                        " to hold the FM's return value
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    IF v_popup_return EQ text-009.                                    " Action is EQ yes
      PERFORM f_insert_record USING p_prname                          " Insert New record with Program name & template name
                                    p_tmname
                                    cb_activ
                                    p_fname
                                    v_xstr_content
                                    p_wricef
                                    p_comme
                                    lv_initial_version.
    ELSE.                                   " Action is EQ to No
      MESSAGE s005(zfilupload).
      EXIT.
    ENDIF.
  ELSE.
    PERFORM f_check_existing_version CHANGING lv_curversion           " Check existing version for further DB update
                                              v_xstr_content_exist.

    lv_preversion = lv_curversion .                                   " assign current version to previous version
    lv_curversion = lv_curversion + 1.                                " Increased file version

    IF v_xstr_content_exist = v_xstr_content.                         " Check updated version and currently updating templates are same
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-004
          text_question         = text-005
          text_button_1         = text-006
          text_button_2         = text-007
          default_button        = text-008
          display_cancel_button = space
        IMPORTING
          answer                = v_popup_return                      " to hold the FM's return value
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      IF v_popup_return EQ text-009.                                  " Action is EQ yes
        PERFORM f_inactive_record USING p_prname                      " Inactive Existing record
                                        p_tmname
                                        lv_preversion.

        PERFORM f_insert_record USING p_prname                        " Insert new file version
                                      p_tmname
                                      cb_activ
                                      p_fname
                                      v_xstr_content
                                      p_wricef
                                      p_comme
                                      lv_curversion.
      ELSE.                                                           " Action is EQ to No
        MESSAGE s012(zfilupload).
        EXIT.
      ENDIF.
    ELSE.                                                             " Existing file content not eq to uploading file layout content
      PERFORM f_inactive_record USING p_prname                        " Inactive Existing active record
                                      p_tmname
                                      lv_preversion.

      PERFORM f_insert_record USING p_prname                          " Insert new file version
                                    p_tmname
                                    cb_activ
                                    p_fname
                                    v_xstr_content
                                    p_wricef
                                    p_comme
                                    lv_curversion.
    ENDIF.

  ENDIF.

ENDFORM.

FORM f_prepare_file_content .

  DATA : lv_filename   TYPE string,
         lv_preversion TYPE zca_templates-version,
         lv_activeflag TYPE char1.

  CLEAR : lv_filename , v_xstr_content , v_len.
  REFRESH i_content[].

  lv_filename = p_fname.                  " File path assign to local variable

  PERFORM get_file_extension USING lv_filename          " get file extension using the full file path
                             CHANGING v_extension.

  " Upload file from presentation server to SAP
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = lv_filename
      filetype                = 'BIN'
    IMPORTING
      filelength              = v_len
    CHANGING
      data_tab                = i_content
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  "Convert binary itab to xstring
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = v_len
*     FIRST_LINE   = 0
*     LAST_LINE    = 0
    IMPORTING
      buffer       = v_xstr_content
    TABLES
      binary_tab   = i_content
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
    MESSAGE s008(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

ENDFORM.

FORM get_file_extension  USING    fp_filename       " Full file path
                         CHANGING fp_extension TYPE char10.     " File extension

  DATA : lv_filename TYPE char50.

  CLEAR : lv_filename , v_extension.

  CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'      " Get file name
    EXPORTING
      full_name     = fp_filename
    IMPORTING
      stripped_name = lv_filename
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE s025(zfilupload) DISPLAY LIKE c_errtype.
  ELSE.
    CONDENSE lv_filename.                                   " Remove unwanted space
    CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'                " Get file extension from file name
      EXPORTING
        filename  = lv_filename
      IMPORTING
        extension = fp_extension.
    TRANSLATE fp_extension TO LOWER CASE.
  ENDIF.

ENDFORM.
