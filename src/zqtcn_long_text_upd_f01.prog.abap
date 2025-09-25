*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_TEXT_UPDATE_F001
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_INFL  text
*----------------------------------------------------------------------*
FORM f_get_filename  CHANGING p_filename TYPE rlgrap-filename.
* Popup for file path
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_filename " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file .

  DATA: lst_order_data TYPE ty_order_details,
        lst_order      TYPE ty_order_details,
        li_type        TYPE truxs_t_text_data,
        li_excel       TYPE TABLE OF zqtc_alsmex_tabline,
        lv_file        TYPE rlgrap-filename,
        lst_order_sel  TYPE ty_order_sel.

  FIELD-SYMBOLS: <fs_value> TYPE char50.

  REFRESH : i_order_data,i_order_data_main,i_final,i_rows,i_final_suc,i_final_err,i_order_sel.
  CLEAR : gv_total,gv_total_proc,gv_success,gv_error,v_path_fname,
          v_path_fname1,v_e070_path,v_file_path,v_dir.

  IF sy-batch = space.
    lv_file = p_infl.
*Uploading the file data into internal table
    CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = lv_file
        i_begin_col             = 1
        i_begin_row             = 2
        i_end_col               = 10
        i_end_row               = 65000
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid
              TYPE sy-msgty
              NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF li_excel[] IS NOT INITIAL.
      LOOP AT li_excel INTO DATA(lst_excel).
        SHIFT lst_excel-value LEFT DELETING LEADING space.
        CASE lst_excel-col.
          WHEN 1.
            lst_order_data-contract = lst_excel-value.
            CLEAR lst_excel.
          WHEN 2.
            lst_order_data-tdid = lst_excel-value.
            CLEAR lst_excel.
          WHEN 3.
            lst_order_data-tdobject = lst_excel-value.
            CLEAR lst_excel.
          WHEN 4.
            lst_order_data-spras = lst_excel-value.
            CLEAR lst_excel.
          WHEN 5.
            lst_order_data-ltext = lst_excel-value.
            CLEAR lst_excel.
        ENDCASE.
        lst_order = lst_order_data.
        AT END OF row.
          APPEND lst_order TO i_order_data_main.
          CLEAR: lst_order,lst_order_data.
        ENDAT.
        CLEAR: lst_excel.
      ENDLOOP.
    ENDIF.
    IF i_order_data_main IS NOT INITIAL.
      SORT i_order_data_main BY contract.
      DESCRIBE TABLE i_order_data_main LINES gv_total.
    ELSE.
      MESSAGE text-040 TYPE c_e DISPLAY LIKE c_e.
    ENDIF.
  ELSE.
* Read the data from application server file
    CLEAR i_order_sel.
    OPEN DATASET p_infl FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
      DO.
        READ DATASET p_infl INTO lst_order_sel.
        IF sy-subrc = 0.
          APPEND lst_order_sel TO i_order_sel.
          CLEAR lst_order_sel .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_infl.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lst_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background  USING p_file TYPE char80.

  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,      "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.         "Selection table parameter

  DATA: lst_order_data TYPE ty_order_details,
        lv_file     TYPE string,
        lv_msg      TYPE string.
  FIELD-SYMBOLS <fs_order_data> TYPE ty_order_sel.

  CONSTANTS: lc_parameter_p  TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i       TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq    TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_order        TYPE char16 VALUE 'ORDER_LONG_TEXT_', "ABAP: Selection option (EQ/BT/CP/...).
             lc_selname(06)  TYPE c VALUE 'P_INFL', "ABAP: Selection option (EQ/BT/CP/...).
             lc_zupdate_text TYPE char15 VALUE 'ZUPD_ORDER_TXT_'. "ABAP: Selection option (EQ/BT/CP/...).
  CLEAR : v_path_fname,v_e070_path.
  CONCATENATE lc_order sy-datum sy-uzeit INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  v_path_fname =  lv_file.
  v_e070_path  = p_file.
  PERFORM f_get_file_path USING v_path_fname.
  CLEAR lv_file.
  lv_file = v_file_path.
  CLOSE DATASET lv_file.
  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_order_sel ASSIGNING <fs_order_data>.
      IF <fs_order_data>  IS  ASSIGNED AND sy-subrc EQ 0.
        TRANSFER <fs_order_data> TO lv_file.
      ENDIF.
    ENDLOOP.
    UNASSIGN <fs_order_data>.
  ENDIF.
  CLOSE DATASET lv_file.

  lst_params-selname = lc_selname.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.  "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CONCATENATE lc_zupdate_text sy-datum '_' sy-uzeit INTO lv_jobname.
  CONDENSE lv_jobname NO-GAPS.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.

    SUBMIT zqtcr_long_text_update WITH SELECTION-TABLE li_params
                    VIA JOB lv_jobname NUMBER lv_number "Job number
                    AND RETURN.
    IF sy-subrc = 0.
*       Closing the Job
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobcount             = lv_number   "Job number
          jobname              = lv_jobname  "Job name
          strtimmed            = abap_true   "Start immediately
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid
              TYPE sy-msgty
            NUMBER sy-msgno
              WITH sy-msgv1
                   sy-msgv2
                   sy-msgv3
                   sy-msgv4.
      ENDIF.
    ENDIF.
  ENDIF.
  LEAVE LIST-PROCESSING.
  CONCATENATE text-008 lv_jobname text-039 INTO lv_msg SEPARATED BY space.
  MESSAGE lv_msg TYPE c_i.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  Order_long_text_update
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_order_long_text_update.
  DATA : lv_msg  TYPE string,
*         lv_file TYPE string,
*         lv_dir  TYPE string,
         lst_order  TYPE ty_order_details.

  LOOP AT i_order_sel INTO DATA(lst_order_sel) WHERE sel EQ c_x.
    MOVE-CORRESPONDING lst_order_sel TO lst_order.
    APPEND lst_order TO i_order_data.
    CLEAR : lst_order,lst_order_sel.
  ENDLOOP.

  DESCRIBE TABLE i_order_data LINES gv_total_proc.
  PERFORM f_validate_data.
  LOOP AT i_order_data INTO DATA(lst_order_data).
    PERFORM f_order_update_text USING lst_order_data.
    CLEAR lst_order_data.
  ENDLOOP.
  IF i_final IS NOT INITIAL.
    PERFORM f_seg_final.
    PERFORM f_err_suc_file.
    PERFORM f_display_data.
    CONCATENATE text-033 gv_total_proc INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE c_s.
    CLEAR lv_msg.
    CONCATENATE text-034 gv_error INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE c_s.
    CLEAR lv_msg.
    CONCATENATE text-035 gv_success INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE c_s.
    CLEAR lv_msg.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA: lr_events  TYPE REF TO cl_salv_events_table,
        lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.
  CONSTANTS lc_zsalv_standard TYPE sypfkey VALUE 'ZSALV_STANDARD'.

  IF i_final IS INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = gr_table
          CHANGING
            t_table      = i_order_data_main.
      CATCH cx_salv_msg .
    ENDTRY.
    gr_table->set_screen_status(
      pfstatus      =  lc_zsalv_standard
      report        =  sy-repid
      set_functions = gr_table->c_functions_all ).
  ELSE.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = gr_table
          CHANGING
            t_table      = i_final.
      CATCH cx_salv_msg .
    ENDTRY.
  ENDIF.

  lr_columns = gr_table->get_columns( ).
  lr_columns->set_optimize( c_true ).

  IF i_final IS INITIAL.
    gr_selections = gr_table->get_selections( ).
    gr_selections->set_selection_mode( gr_selections->multiple ).
  ENDIF.

  TRY.
      lr_column ?= lr_columns->get_column( 'CONTRACT' ).
      lr_column->set_short_text( text-018 ).
      lr_column->set_medium_text( text-012 ).
      lr_column->set_long_text( text-012 ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'TDID' ).
      lr_column->set_short_text( text-019 ).
      lr_column->set_medium_text( text-019 ).
      lr_column->set_long_text( text-019 ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'TDOBJECT' ).
      lr_column->set_short_text( text-031 ).
      lr_column->set_medium_text( text-032 ).
      lr_column->set_long_text( text-032 ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'SPRAS' ).
      lr_column->set_short_text( text-020 ).
      lr_column->set_medium_text( text-020 ).
      lr_column->set_long_text( text-020 ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'LTEXT' ).
      lr_column->set_short_text( text-021 ).
      lr_column->set_medium_text( text-022 ).
      lr_column->set_long_text( text-022 ).
    CATCH cx_salv_not_found.
  ENDTRY.

  IF i_final IS INITIAL.
    IF sy-batch EQ space.
      lr_events = gr_table->get_event( ).
      CREATE OBJECT gr_events.
      SET HANDLER gr_events->on_user_command FOR lr_events.
    ENDIF.
  ELSE.
    TRY.
        lr_column ?= lr_columns->get_column( 'STATUS' ).
        lr_column->set_short_text( text-023 ).
        lr_column->set_medium_text( text-023 ).
        lr_column->set_long_text( text-023 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lr_column ?= lr_columns->get_column( 'MESSAGE' ).
        lr_column->set_short_text( text-024 ).
        lr_column->set_medium_text( text-024 ).
        lr_column->set_long_text( text-024 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    IF sy-batch EQ space.
      PERFORM f_set_top_of_page CHANGING gr_table.
    ENDIF.
  ENDIF.

  gr_table->display( ).
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_SALV_FUNCTION  text
*----------------------------------------------------------------------*
FORM f_handle_user_command  USING    p_e_salv_function TYPE any.

  DATA: lv_no_of_records TYPE i,
        lv_file          TYPE string,
        lst_order_sel       TYPE ty_order_sel.

  CONSTANTS : lc_order   TYPE char16 VALUE 'ORDER_LONG_TEXT_'.

  FIELD-SYMBOLS: <fs_order_data>  TYPE ty_order_sel.

  REFRESH : i_final,i_final_err,i_order_sel,i_order_data.
  CLEAR: gv_total_proc,gv_success,gv_error.
  CLEAR : v_path_fname,v_e070_path.

  CALL METHOD gr_selections->get_selected_rows
    RECEIVING
      value = i_rows.

  DESCRIBE TABLE i_rows LINES lv_no_of_records.

  IF lv_no_of_records IS INITIAL.
    MESSAGE text-030 TYPE c_e.
  ENDIF.
* Move the data to I_order_sel
  LOOP AT i_order_data_main INTO DATA(lst_order).
    MOVE-CORRESPONDING lst_order TO lst_order_sel.
    APPEND lst_order_sel TO i_order_sel.
    CLEAR : lst_order,lst_order_sel.
  ENDLOOP.
* Mark the selected records as "X" in I_order_SEL for background process and
* Move selected rows from input data to I_order_data for Foreground process.
  LOOP AT i_rows INTO DATA(lst_row).
    READ TABLE i_order_sel ASSIGNING <fs_order_data> INDEX lst_row.
    IF <fs_order_data>  IS  ASSIGNED AND sy-subrc EQ 0.
      <fs_order_data>-sel = abap_true.
      APPEND <fs_order_data> TO i_order_data.
    ENDIF.
    CLEAR lst_row.
  ENDLOOP.
  UNASSIGN <fs_order_data>.

  SORT i_order_data BY contract.

  SELECT *
     FROM zcaconstant
     INTO TABLE @i_const
     WHERE devid = @c_devid
    AND activate = @c_x.

  IF sy-subrc EQ 0.
    SORT i_const BY param1.
  ENDIF.

  READ TABLE  i_const INTO DATA(lst_const) WITH KEY param1 = c_param1.

  IF lv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.

    IF lv_no_of_records > lst_const-low.
      CLEAR lst_const .
      READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param2.
      IF sy-subrc = 0.
        PERFORM f_submit_program_in_background USING lst_const-low.
      ENDIF.
    ELSE.
* Logic to place the input file data in the Application sever file path
      READ TABLE  i_const INTO DATA(lst_const1) WITH KEY param1 = c_param2.
      IF sy-subrc EQ 0.
        v_e070_path  =  lst_const1-low.
      ENDIF.

      CONCATENATE lc_order sy-datum sy-uzeit INTO lv_file.
      CONDENSE  lv_file NO-GAPS.
      v_path_fname =  lv_file.
      v_path_fname1 = lv_file.
      PERFORM f_get_file_path USING v_path_fname.
      CLEAR lv_file.
      lv_file = v_file_path.
      v_dir  = v_file_path.
      REPLACE ALL OCCURRENCES OF v_path_fname1 IN v_dir WITH ' '.
      CONDENSE v_dir NO-GAPS.
      CLOSE DATASET lv_file.
      OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc = 0.
        LOOP AT i_order_data_main ASSIGNING FIELD-SYMBOL(<fs_order_data1>).
          IF <fs_order_data1>  IS  ASSIGNED AND sy-subrc EQ 0.
            TRANSFER <fs_order_data1> TO lv_file.
          ENDIF.
        ENDLOOP.
        UNASSIGN <fs_order_data1>.
      ENDIF.
      CLOSE DATASET lv_file.

      DESCRIBE TABLE i_order_data LINES gv_total_proc.
      PERFORM f_validate_data.
      LOOP AT i_order_data INTO DATA(lst_order_data).
        IF sy-subrc EQ 0.
          PERFORM f_order_update_text USING lst_order_data.
        ENDIF.
        CLEAR lst_order_data.
      ENDLOOP.
      IF i_final IS NOT INITIAL.
        PERFORM f_seg_final.
        PERFORM f_err_suc_file.
*        PERFORM f_delete_file.
        PERFORM f_display_data.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lst_ORDER_DATA  text
*----------------------------------------------------------------------*
FORM f_order_update_text  USING  lst_order_data TYPE ty_order_details.

  DATA :lst_final TYPE ty_final,
*        lv_name   TYPE tdobname,
        lv_msg    TYPE string.

  DATA: li_lines   TYPE comt_text_lines_t,
        lst_lines  TYPE tdformat,
        lst_header TYPE thead,
        lst_ltext  TYPE tline,
        li_ltext   TYPE TABLE OF tline.

  CLEAR lv_msg.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lst_order_data-contract
    IMPORTING
      output = lst_order_data-contract.

  lst_header-tdobject     = lst_order_data-tdobject.
  lst_header-tdname       = lst_order_data-contract.
  lst_header-tdid         = lst_order_data-tdid.
  lst_header-tdspras      = lst_order_data-spras.
  lst_header-tdlinesize   = c_tdl.
  lst_header-tdtxtlines   = c_tdtxl.

  lst_ltext-tdformat = c_tdf.

  DATA: lv_text   TYPE string,
        lv_length TYPE i.
  lv_text = lst_order_data-ltext.
  lv_length = strlen( lv_text ).
  REFRESH i_text.

  CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
    EXPORTING
      text        = lv_text
      line_length = '132'
      langu       = sy-langu
    TABLES
      text_tab    = i_text.

  REFRESH li_lines.

  LOOP AT i_text INTO DATA(lst_txt).
    lst_ltext-tdformat  = c_tdf.
    lst_ltext-tdline    = lst_txt-text.
    APPEND lst_ltext TO li_ltext.
    CLEAR : lst_ltext,lst_txt.
  ENDLOOP.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = lst_header-tdid
      language                = lst_header-tdspras
      name                    = lst_header-tdname
      object                  = lst_header-tdobject
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
    CALL FUNCTION 'SAVE_TEXT'
      EXPORTING
        client          = sy-mandt
        header          = lst_header
        insert          = c_x
        savemode_direct = c_x
      TABLES
        lines           = li_ltext
      EXCEPTIONS
        id              = 1
        language        = 2
        name            = 3
        object          = 4
        OTHERS          = 5.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'COMMIT_TEXT'.
      MOVE-CORRESPONDING lst_order_data TO lst_final.
      lst_final-status = text-003.
      lst_final-message = text-006.
    ELSE.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = sy-msgid
          lang      = c_e
          no        = sy-msgno
          v1        = sy-msgv1
          v2        = sy-msgv2
          v3        = sy-msgv3
          v4        = sy-msgv4
        IMPORTING
          msg       = lv_msg
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING lst_order_data TO lst_final.
        lst_final-status = text-002.
        lst_final-message = lv_msg.
      ENDIF.
    ENDIF.
  ELSE.
    CALL FUNCTION 'DELETE_TEXT'
      EXPORTING
        client          = sy-mandt
        id              = lst_header-tdid
        language        = lst_header-tdspras
        name            = lst_header-tdname
        object          = lst_header-tdobject
        savemode_direct = c_x
      EXCEPTIONS
        not_found       = 1
        OTHERS          = 2.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          client          = sy-mandt
          header          = lst_header
          insert          = c_x
          savemode_direct = c_x
        TABLES
          lines           = li_ltext
        EXCEPTIONS
          id              = 1
          language        = 2
          name            = 3
          object          = 4
          OTHERS          = 5.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'COMMIT_TEXT'.
        MOVE-CORRESPONDING lst_order_data TO lst_final.
        lst_final-status = text-003.
        lst_final-message = text-006.
      ELSE.
        CALL FUNCTION 'FORMAT_MESSAGE'
          EXPORTING
            id        = sy-msgid
            lang      = c_e
            no        = sy-msgno
            v1        = sy-msgv1
            v2        = sy-msgv2
            v3        = sy-msgv3
            v4        = sy-msgv4
          IMPORTING
            msg       = lv_msg
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING lst_order_data TO lst_final.
          lst_final-status = text-002.
          lst_final-message = lv_msg.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  APPEND lst_final TO i_final.
  CLEAR : lst_header,lst_final,lv_msg.
  REFRESH : li_ltext,li_lines.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data .

  DATA :lst_final     TYPE ty_final,
        lv_zwnets     TYPE char6 VALUE 'ZWNETS',
        lv_zuslno     TYPE char6 VALUE 'ZUSLNO',
        lv_tabix      TYPE sy-tabix,
        lst_final_suc TYPE ty_order.
  FIELD-SYMBOLS <lfs_order_data> TYPE ty_order_details.

  LOOP AT i_order_data INTO DATA(lst_order_data).
    lv_tabix = sy-tabix.
    IF lst_order_data-contract IS INITIAL OR lst_order_data-tdid IS INITIAL OR lst_order_data-spras IS INITIAL
      OR lst_order_data-tdobject IS INITIAL OR lst_order_data-ltext IS INITIAL.
      MOVE-CORRESPONDING lst_order_data TO lst_final.
      lst_final-status = text-002.
      lst_final-message = text-026.
      APPEND lst_final TO i_final.
      DELETE i_order_data INDEX lv_tabix.
    ELSE.
      APPEND lst_order_data TO i_order_find.
    ENDIF.
    CLEAR : lst_final,lst_order_data.
    CLEAR lv_tabix.
  ENDLOOP.

  IF i_order_data IS NOT INITIAL.
    SELECT vbeln
      FROM vbak
      INTO TABLE @DATA(i_vbak) FOR ALL ENTRIES IN @i_order_data
      WHERE vbeln = @i_order_data-contract.
    IF sy-subrc EQ 0.
      SORT i_vbak BY vbeln.
      LOOP AT i_order_data INTO lst_order_data.
        lv_tabix  = sy-tabix.
        READ TABLE i_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lst_order_data-contract.
        IF sy-subrc NE 0.
          MOVE-CORRESPONDING lst_order_data TO lst_final.
          lst_final-status = text-002.
          lst_final-message = text-025.
          APPEND lst_final TO i_final.
          DELETE i_order_data INDEX lv_tabix.
        ENDIF.
        CLEAR : lst_vbak,lst_final,lv_tabix,lst_order_data.
      ENDLOOP.
    ENDIF.
  ENDIF.
  REFRESH: i_order_find.
*  To find the already successfully processed record
  CLEAR : lst_order_data,lst_final_suc.

  LOOP AT i_order_data INTO lst_order_data.
    lv_tabix = sy-tabix.
    READ TABLE i_final_suc INTO lst_final_suc WITH KEY contract = lst_order_data-contract
                                                       tdid     = lst_order_data-tdid
                                                       tdobject = lst_order_data-tdobject
                                                       spras    = lst_order_data-spras.
*                                                       ltext    = lst_order_data-ltext.

    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_order_data TO lst_final.
      lst_final-status = text-003.
      lst_final-message = text-036.
      APPEND lst_final TO i_final.
      DELETE i_order_data INDEX lv_tabix.
    ENDIF.
    CLEAR: lst_final,lst_order_data,lst_final_suc,lv_tabix.
  ENDLOOP.
  REFRESH i_final_suc.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ERR_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_err_suc_file.
  DATA : lv_msg    TYPE string,
         lv_file   TYPE string,
         lv_head   TYPE string,
         lv_value  TYPE string,
         lst_final TYPE ty_final.
* Creating file in application server with success records
  CLEAR lv_file.
  CLEAR : v_path_fname.

  IF sy-batch NE space.
    SELECT *
   FROM zcaconstant
   INTO TABLE @i_const
   WHERE devid = @c_devid
  AND activate = @c_x.
    IF sy-subrc EQ 0.
      SORT i_const BY param1.
      READ TABLE  i_const INTO DATA(lst_const) WITH KEY param1 = c_param2.
      IF sy-subrc EQ 0.
        v_e070_path  =  lst_const-low.
      ENDIF.
    ENDIF.
  ENDIF.

  IF i_final_err IS NOT INITIAL.
    CONCATENATE c_err_file sy-datum sy-uzeit INTO lv_file.
    CONDENSE  lv_file NO-GAPS.
    v_path_fname =  lv_file.
    PERFORM f_get_file_path USING v_path_fname.
    REPLACE ALL OCCURRENCES OF '/E070/in' IN v_file_path WITH '/E070/err'.
    CLOSE DATASET v_file_path.
    OPEN DATASET v_file_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
* Write header to the file
      CONCATENATE text-018
                  text-019
                  text-032
                  text-020
                  text-021
                  text-023
                  text-024
                  INTO lv_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_head TO v_file_path.

      LOOP AT i_final_err INTO lst_final.
        CONCATENATE  lst_final-contract
                     lst_final-tdid
                     lst_final-tdobject
                     lst_final-spras
*                      lst_final-ltext
                     lst_final-status
                     lst_final-message INTO lv_value SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

        TRANSFER lv_value TO v_file_path.
        CLEAR : lst_final,lv_value.
      ENDLOOP.
      MESSAGE i257(zqtc_r2) WITH v_file_path.
      CLEAR lv_head.
    ENDIF.
    CLOSE DATASET v_file_path.
  ENDIF.

* Creating file in application server with success records
  CLEAR : v_path_fname,lv_file,lst_final.
  IF i_final_suc IS NOT INITIAL.
    CONCATENATE c_suc_file sy-datum sy-uzeit INTO lv_file.
    CONDENSE  lv_file NO-GAPS.
    v_path_fname =  lv_file.
    PERFORM f_get_file_path USING v_path_fname.
    REPLACE ALL OCCURRENCES OF '/E070/in' IN v_file_path WITH '/E070/prc'.
    CLOSE DATASET v_file_path.
    OPEN DATASET v_file_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
* Write header to the file
      CONCATENATE text-018
                  text-019
                  text-032
                  text-020
                  text-021
                  text-023
                  text-024
                  INTO lv_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_head TO v_file_path.

      LOOP AT i_final_suc INTO lst_final.
        CONCATENATE  lst_final-contract
                     lst_final-tdid
                     lst_final-tdobject
                     lst_final-spras
*                       lst_final-ltext
                     lst_final-status
                     lst_final-message INTO lv_value SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

        TRANSFER lv_value TO v_file_path.
        CLEAR : lst_final,v_path_fname.
      ENDLOOP.
      MESSAGE i258(zqtc_r2) WITH v_file_path.
    ENDIF.
    CLOSE DATASET v_file_path.
    CLEAR lv_head.
  ENDIF.

ENDFORM.

FORM f_set_top_of_page CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string.

  CONDENSE gv_total.
  CONDENSE gv_total_proc.
  CONDENSE gv_error.
  CONDENSE gv_success.

  lo_head = 'Order long text update'.

  CREATE OBJECT lo_grid.

  lo_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lo_head
                                      tooltip = lo_head ).

  lo_grid1 = lo_grid->create_grid( row = 2
                                  column = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row = 2
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Total Records:'
                                    tooltip = 'Total Records:' ).

  lo_text = lo_flow->create_text( text = gv_total
                                  tooltip = gv_total ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '
                                    tooltip = 'Processed : ' ).

  lo_text = lo_flow->create_text( text = gv_total_proc
                                  tooltip = gv_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'
                                    tooltip = 'Success:' ).

  lo_text = lo_flow->create_text( text = gv_success
                                  tooltip = gv_success ).
*
*
  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'
                                    tooltip =  'Errors:' ).

  lo_text = lo_flow->create_text( text = gv_error
                                  tooltip = gv_error ).
*--Set Top of List
  co_alv->set_top_of_list( lo_grid ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEG_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_seg_final .
*Segrigting success and error records
  LOOP AT i_final INTO DATA(lst_final).
    IF lst_final-status EQ c_err.
      APPEND lst_final TO i_final_err.
    ENDIF.
    IF lst_final-status EQ c_suc.
      APPEND lst_final TO i_final_suc.
    ENDIF.
    CLEAR lst_final.
  ENDLOOP.
  DESCRIBE TABLE i_final_suc LINES gv_success.
  DESCRIBE TABLE i_final_err LINES gv_error.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_FNAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING fp_lv_filename.
  DATA : lv_path         TYPE filepath-pathintern .
  DATA:lv_path_fname TYPE string.
  CLEAR : lv_path_fname,v_file_path,lv_path.
  lv_path = v_e070_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = fp_lv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001(zqtc_r2) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
    v_file_path = lv_path_fname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM f_delete_file .
*
*  DATA : lv_file TYPE epsfilnam,
*         lv_dir  TYPE epsdirnam.
*
*  lv_file = v_path_fname1.
*  lv_dir  = v_dir.
*
*  CALL FUNCTION 'EPS_DELETE_FILE'
*    EXPORTING
*      file_name              = lv_file
**     IV_LONG_FILE_NAME      =
*      dir_name               = lv_dir
**     IV_LONG_DIR_NAME       =
** IMPORTING
**     FILE_PATH              =
**     EV_LONG_FILE_PATH      =
*    EXCEPTIONS
*      invalid_eps_subdir     = 1
*      sapgparam_failed       = 2
*      build_directory_failed = 3
*      no_authorization       = 4
*      build_path_failed      = 5
*      delete_failed          = 6
*      OTHERS                 = 7.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*    IF sy-subrc EQ 4.
*      MESSAGE text-041  TYPE c_i DISPLAY LIKE c_i.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.
