*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAR_RES_UPD_C120_F01
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MARKET_REST_UPD_C120
*&*--------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MARKET_REST_UPD_C120
*& PROGRAM DESCRIPTION:   Market Restriction Conversion Form Routines
*& DEVELOPER:             SVISHWANAT
*& CREATION DATE:         03/28/2022
*& OBJECT ID:             C120 / EAM-8340
*& TRANSPORT NUMBER(S):   ED2K926336.
*&---------------------------------------------------------------------*

FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog " ABAP System Field: Calling Program
                                 fp_c_field    TYPE dynfnam    " Field name
                        CHANGING fp_filename     TYPE localfile. " Local file for upload/download

  CALL FUNCTION 'F4_FILENAME' "for search help in presentation server.
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_filename.

ENDFORM.

FORM f_f4_application  CHANGING fp_filename TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
    IMPORTING
      serverfile       = fp_filename
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc EQ 0.
* suitable error handling will done later
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text  Get Data from file to Internal Table
*----------------------------------------------------------------------*
FORM f_get_data_from_file_create.
  DATA: li_type          TYPE truxs_t_text_data,
        lst_file_data    TYPE ity_file,
        li_file_tmp      TYPE STANDARD TABLE OF ity_data,
        li_file_tmp_data TYPE STANDARD TABLE OF ity_data,
        lst_data         TYPE ity_data,
        lv_to_date       TYPE d VALUE '99991231'.
  DATA: lv_data  TYPE string,
        lc_crlf  TYPE c VALUE cl_bcs_convert=>gc_crlf,
        lc_comma TYPE char1    VALUE ','.
  FIELD-SYMBOLS :<lst_file_data> TYPE ity_file.
  REFRESH:i_file_data.

  IF sy-batch = space AND
     r_pre IS NOT INITIAL.
*--foreground file fetching into internal table
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = i_file_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSEIF sy-batch <> space OR
          r_appl IS NOT INITIAL.
*--Background file fetching into internal table
    REFRESH: i_file_data.
    CLEAR: lst_file_data.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT IGNORING CONVERSION ERRORS.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO lv_data.
        IF sy-subrc = 0.
          REPLACE ALL OCCURRENCES OF lc_crlf IN lv_data WITH space.
          SPLIT lv_data AT lc_comma  INTO lst_file_data-kschl
                                         lst_file_data-matnr
                                         lst_file_data-land1
                                         lst_file_data-fromdate
                                         lst_file_data-todate.
          APPEND lst_file_data TO i_file_data.
          CLEAR lst_file_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_file.
    ENDIF.
  ENDIF.

  IF i_file_data[] IS NOT INITIAL.
*--Validating file data with Database
    LOOP AT i_file_data ASSIGNING <lst_file_data>.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_file_data>-matnr
        IMPORTING
          output = <lst_file_data>-matnr.
      lst_data-kschl    = <lst_file_data>-kschl.
      lst_data-matnr    = <lst_file_data>-matnr.
      lst_data-land1    = <lst_file_data>-land1.
      lst_data-todate   = <lst_file_data>-todate.
      lst_data-fromdate =  <lst_file_data>-fromdate.

      TRANSLATE lst_data-land1 TO UPPER CASE.
      APPEND  lst_data TO li_file_tmp_data.
      CLEAR  lst_file_data.

    ENDLOOP.
    i_file_tot[] = li_file_tmp_data[].
    DATA(lv_to_date_user_format) = |{ lv_to_date DATE = USER }|.

*Get Dest. Ctry/Material
    li_file_tmp = li_file_tmp_data.
    SORT  li_file_tmp BY matnr land1 todate.
    DELETE ADJACENT DUPLICATES FROM li_file_tmp COMPARING  matnr land1 todate.
    IF li_file_tmp IS NOT INITIAL.
      SELECT * FROM kotg501
        INTO TABLE i_kotg501
        FOR ALL ENTRIES IN li_file_tmp
        WHERE kappl = p_kappl
          AND kschl = p_kschl
          AND land1 = li_file_tmp-land1
          AND matnr = li_file_tmp-matnr
          AND datbi = li_file_tmp-todate.
      IF sy-subrc EQ 0.
        SORT i_kotg501 BY  kappl kschl
                           land1 matnr datbi.
      ENDIF.
    ENDIF.

*Get Matrerial
    REFRESH li_file_tmp.
    li_file_tmp = li_file_tmp_data.
    SORT  li_file_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_file_tmp COMPARING  matnr .
    IF li_file_tmp IS NOT INITIAL.
      SELECT matnr FROM mara
        INTO TABLE i_mara
        FOR ALL ENTRIES IN li_file_tmp
        WHERE  matnr = li_file_tmp-matnr.
      IF sy-subrc EQ 0.
        SORT i_mara BY matnr.
      ENDIF.
    ENDIF.

*Get Country
    REFRESH li_file_tmp.
    li_file_tmp = li_file_tmp_data.
    SORT  li_file_tmp BY land1.
    DELETE ADJACENT DUPLICATES FROM li_file_tmp COMPARING  land1 .
    IF li_file_tmp IS NOT INITIAL.
      SELECT land1 FROM t005
        INTO TABLE i_t005
        FOR ALL ENTRIES IN li_file_tmp
        WHERE  land1 = li_file_tmp-land1.
      IF sy-subrc EQ 0.
        SORT i_t005 BY land1.
      ENDIF.
    ENDIF.

*Get Condition Type
    REFRESH li_file_tmp.
    li_file_tmp = li_file_tmp_data.
    SORT  li_file_tmp BY kschl.
    DELETE ADJACENT DUPLICATES FROM li_file_tmp COMPARING  kschl .
    IF li_file_tmp IS NOT INITIAL.
      SELECT kschl FROM t685
        INTO TABLE i_t685
        FOR ALL ENTRIES IN li_file_tmp
        WHERE  kschl = li_file_tmp-kschl.
      IF sy-subrc EQ 0.
        SORT i_t685 BY kschl.
      ENDIF.
    ENDIF.
    CLEAR:v_rows.
    v_rows = lines( i_file_data[] ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text  Display Foreground processed Records as Output
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_disp_data_create_del.
  DATA: lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = ir_table
        CHANGING
          t_table      = i_file_data.
    ##NO_HANDLER    CATCH cx_salv_msg .
  ENDTRY.

  IF sy-batch = space.
    ir_table->set_screen_status(
        pfstatus      =  'ZSALV_STANDARD'
        report        =  sy-repid
        set_functions = ir_table->c_functions_all ).
  ENDIF.
  lr_columns = ir_table->get_columns( ).
  lr_columns->set_optimize( abap_true ).

  ir_selections = ir_table->get_selections( ).

  ir_selections->set_selection_mode( ir_selections->multiple ).

  TRY.
      lr_column ?= lr_columns->get_column( 'KSCHL' ).
      lr_column ?= lr_columns->get_column( 'MATNR' ).
      lr_column ?= lr_columns->get_column( 'LAND1' ).
      lr_column ?= lr_columns->get_column( 'TODATE' ).
      lr_column->set_short_text( text-036 ).
      lr_column ?= lr_columns->get_column( 'FROMDATE' ).
      lr_column->set_short_text( text-037 ).
      lr_column ?= lr_columns->get_column( 'TYPE' ).
      lr_column ?= lr_columns->get_column( 'MESSAGE' ).
      lr_column->set_short_text( text-038 ).
      lr_column->set_medium_text( text-038 ).
      lr_column->set_long_text( text-038 ).
    ##NO_HANDLER    CATCH cx_salv_not_found.
  ENDTRY.

  IF sy-batch = space.
    DATA: lst_const TYPE zcaconstant.
    DATA: lst_columns TYPE REF TO cl_salv_columns.
    DESCRIBE TABLE i_file_data LINES DATA(lv_no_of_records).
    REFRESH: i_const.
    SELECT *
       FROM zcaconstant
       INTO TABLE i_const
       WHERE devid    = c_devid
         AND activate = abap_true.
    IF sy-subrc EQ 0.
      SORT i_const BY param1.
    ENDIF.

    CLEAR lst_const .
    READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param1.
    IF sy-subrc = 0.
      IF lv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.
        IF lv_no_of_records > lst_const-low.
*--get the application layer path dynamically
          PERFORM f_get_file_path USING v_path_in '*'.
          REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*---File data submitted to background and created the batch job in SM37
          PERFORM f_submit_program_in_background.

        ELSE.
          IF r_create IS NOT INITIAL.     "For create
            PERFORM f_mat_rest_create.
          ELSEIF r_dele IS NOT INITIAL.   "For Delete
            PERFORM f_mat_rest_delete.
          ENDIF.

*Error and Success file creation with error and success records.
          PERFORM f_error_success_log.
          lst_columns = ir_table->get_columns( ).
          lst_columns->set_optimize( c_true ).
          PERFORM f_set_top_of_page CHANGING ir_table.
          ir_table->refresh( ).
        ENDIF.
      ENDIF.
    ENDIF.
    PERFORM f_set_top_of_page CHANGING ir_table.
  ENDIF.
  ir_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text  Display Title of output
*----------------------------------------------------------------------*
*      <--P_IR_TABLE  text
*----------------------------------------------------------------------*
FORM f_set_top_of_page  CHANGING fp_co_alv TYPE REF TO cl_salv_table.

  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string.
  IF r_create IS NOT INITIAL.
    lo_head = 'Material Restrcited Product Creation'(002).
  ELSEIF r_dele IS NOT INITIAL.
    lo_head = 'Material Restrcited Product Deletion'(014).
  ENDIF.
  CONDENSE v_rows.
  CONDENSE v_total_proc.
  CONDENSE v_error.
  CONDENSE v_success.

  CREATE OBJECT lo_grid.

  lo_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lo_head
                                      tooltip = lo_head ).

  lo_grid1 = lo_grid->create_grid( row    = 2
                                  column  = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row = 2
                             column    = 1 ).

  lo_label = lo_flow->create_label( text    = 'Total Records:'(004)
                                    tooltip = 'Total Records:'(004) ).

  lo_text = lo_flow->create_text( text    = v_rows
                                  tooltip = v_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column    = 1 ).

  lo_label = lo_flow->create_label( text    = 'Processed : '(006)
                                    tooltip = 'Processed : '(006) ).

  lo_text = lo_flow->create_text( text    = v_total_proc
                                  tooltip = v_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column    = 1 ).

  lo_label = lo_flow->create_label( text    = 'Success:'(007)
                                    tooltip = 'Success:'(007) ).

  lo_text = lo_flow->create_text( text    = v_success
                                  tooltip = v_success ).
*
*
  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text    =  'Errors:'(008)
                                    tooltip =  'Errors:'(008) ).

  lo_text = lo_flow->create_text( text = v_error
                                  tooltip = v_error ).
*--Set Top of List
  fp_co_alv->set_top_of_list( lo_grid ).
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_CREATE
*&---------------------------------------------------------------------*
*       Creating material Records
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_market_restrict_mat_cre_del.
  DATA:lv_sel TYPE string.

  IF sy-batch <> space.
    CONCATENATE 'Batch Job Triggered by'(010)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE c_s.
  ENDIF.
  IF r_create IS NOT INITIAL.
*Material Restrcition product creation
    PERFORM f_mat_rest_create.
  ELSEIF r_dele IS NOT INITIAL.
    PERFORM f_mat_rest_delete.
  ENDIF.

  IF sy-batch <> space.
    CLEAR:v_success,
            v_error,
            lv_sel.
    DESCRIBE TABLE i_error_rec  LINES v_error.
    DESCRIBE TABLE i_sucess_rec LINES v_success .
    DESCRIBE TABLE i_file_data  LINES lv_sel.
    v_total_proc = v_error + v_success.
    CONCATENATE 'Total selected records to be processed: '(011) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(012) v_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) v_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE c_s.
    MESSAGE lv_error TYPE c_s.
    PERFORM f_error_success_log.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text  Scheduling a Bakground Job if No. of records greater than Limit.
*----------------------------------------------------------------------*
*      -->P_LST_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background."  USING p_file TYPE string.
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  DATA: lv_file TYPE string,
        lv_bjob TYPE char1.

  DATA: lv_data TYPE string.
  CONSTANTS lc_comma TYPE char1 VALUE ','.

  CONSTANTS: lc_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_p_file      TYPE rsscr_name VALUE 'P_FILE',
             lc_r_create    TYPE rsscr_name VALUE 'R_CREATE',
             lc_r_dele      TYPE rsscr_name VALUE 'R_DELE',
             lc_p_test      TYPE rsscr_name VALUE 'P_TEST',
             lc_p_kappl     TYPE rsscr_name VALUE 'P_KAPPL',
             lc_p_kschl     TYPE rsscr_name VALUE 'P_KSCHL'.

  IF r_create IS NOT INITIAL.
    CONCATENATE v_file_path 'Material_Creation_'(005) sy-datum sy-uzeit INTO lv_file.
  ELSEIF r_dele IS NOT INITIAL.
    CONCATENATE v_file_path 'Material_Deletion_'(006) sy-datum sy-uzeit INTO lv_file.
  ENDIF.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_file_data INTO DATA(lst_file_data).
      CONCATENATE lst_file_data-kschl
                  lst_file_data-matnr
                  lst_file_data-land1
                  lst_file_data-fromdate
                  lst_file_data-todate INTO lv_data SEPARATED BY lc_comma  .
      TRANSFER lv_data TO lv_file.
      CLEAR: lv_data, lst_file_data.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.


  CLEAR:i_file_data,
        lst_params.
  lst_params-selname = lc_p_file.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_r_create.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = r_create.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_r_dele.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = r_dele.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_p_test.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = p_test.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_p_kappl.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = p_kappl.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_p_kschl.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = p_kschl.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE 'ZQTCR_MARKET_RE' sy-datum sy-uzeit INTO lv_jobname.
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
    lv_bjob = abap_true.
    IF lv_bjob = abap_true.
      SUBMIT zqtcr_market_rest_upd_c120 WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_market_rest_upd_c120 WITH SELECTION-TABLE li_params.
    ENDIF.
  ENDIF.

  IF sy-subrc = 0.
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
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  MESSAGE i255(zqtc_r2) WITH lv_jobname.
  LEAVE TO SCREEN 0.
ENDFORM.

FORM f_error_success_log.
  CONSTANTS:lc_success TYPE string VALUE 'MAT_UPD_SUCCESS_',
            lc_error   TYPE string VALUE 'MAT_UPD_ERROR_'.

  IF sy-batch = space.
    DESCRIBE TABLE i_error_rec  LINES v_error.
    DESCRIBE TABLE i_sucess_rec LINES v_success .
    v_total_proc = v_error + v_success.
  ENDIF.

  IF  i_sucess_rec IS NOT INITIAL.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_prc '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.

*--writing Sucess records to application layer
    CONCATENATE v_file_path lc_success sy-datum sy-uzeit INTO DATA(lv_file).
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.

    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER v_head TO lv_file.
      LOOP AT i_sucess_rec INTO DATA(lst_record).
        CONCATENATE lst_record-kschl
                    lst_record-matnr
                    lst_record-land1
                    lst_record-todate
                    lst_record-fromdate
                    lst_record-type
                    lst_record-message
                    INTO DATA(lv_value1)
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file.
        CLEAR :lst_record.
      ENDLOOP.

      MESSAGE s258(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.

  IF i_error_rec IS  NOT INITIAL.

    CLEAR:lv_value1,
         lst_record.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_err '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.

*--writing error records to application layer
    CONCATENATE v_file_path lc_error sy-datum sy-uzeit INTO DATA(lv_file_e).
    CONDENSE  lv_file_e NO-GAPS.
    CLOSE DATASET lv_file_e.
    OPEN DATASET lv_file_e FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_names.
      TRANSFER v_head TO lv_file_e.

      CLEAR lst_record.
      LOOP AT i_error_rec  INTO lst_record.
        CONCATENATE lst_record-kschl
                    lst_record-matnr
                    lst_record-land1
                    lst_record-todate
                    lst_record-fromdate
                    lst_record-type
                    lst_record-message INTO lv_value1
     SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file_e.
        CLEAR :lst_record.
      ENDLOOP.

      MESSAGE s257(zqtc_r2) WITH lv_file_e.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file_e.
    ENDIF.
    CLOSE DATASET lv_file_e.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HEAD_NAMES
*&---------------------------------------------------------------------*
*       text  Field names
*----------------------------------------------------------------------*
*      -->P_LV_HEAD  text
*----------------------------------------------------------------------*
FORM f_head_names.
  CLEAR :v_head.

  CONCATENATE 'Condition Type'(016)
              'Material'(015)
              'Country'(017)
              'Valid To Date'(018)
              'Valid From Date'(019)
              'Msg Type'(033)
              'Message'(035)
     INTO v_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text  Getting File path in the application server(i.e.,AL11).
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING fp_v_path
                            fp_v_filename.
  CLEAR :v_file_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_v_path
      operating_system           = sy-opsys
      file_name                  = fp_v_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_file_path
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  DATA lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-program  = program.
  lst_bdcdata-dynpro   = dynpro.
  lst_bdcdata-dynbegin = 'X'.
  APPEND lst_bdcdata TO i_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  DATA lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-fnam = fnam.
  lst_bdcdata-fval = fval.
  APPEND lst_bdcdata TO  i_bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAT_REST_CREATE
*&---------------------------------------------------------------------*
*       text  BDC recording for material creation
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mat_rest_create .
  DATA:lst_params     TYPE ctu_params,
       lv_count(2)    TYPE n,
       lv_land_field  TYPE char30,
       lv_matnr_field TYPE char30,
       lv_to_date     TYPE d VALUE '99991231',
       lv_from_date   TYPE  char10,
       lv_matnr       TYPE matnr.
  CONSTANTS: lc_n TYPE char1 VALUE 'N',
             lc_s TYPE char1 VALUE 'S'.

  SORT i_file_data BY kschl.
  lst_params-dismode = lc_n.
  lst_params-defsize = abap_true.
  lst_params-updmode = lc_s.

  DATA(lv_to_date_user_format) = |{ lv_to_date DATE = USER }|.
  WRITE sy-datum TO lv_from_date.

  LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lfs_file_data>).
*Pre validation
    CLEAR v_err_flag.
    PERFORM f_pre_validations CHANGING <lfs_file_data>
                                       v_err_flag.
    IF v_err_flag IS NOT INITIAL.
      CONTINUE.
    ENDIF.
    IF p_test = abap_false.
      AT NEW kschl.
        lv_count = 1.
        REFRESH:i_bdcdata.
        PERFORM bdc_dynpro  USING 'SAPMV13G'    '0100'.
        PERFORM bdc_field   USING 'BDC_CURSOR'  'G000-KSCHL'.
        PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
        PERFORM bdc_field   USING 'G000-KSCHL'  <lfs_file_data>-kschl.

        PERFORM bdc_dynpro  USING 'SAPLV14A'    '0100'.
        PERFORM bdc_field   USING 'BDC_CURSOR'  'RV130-SELKZ(01)'.
        PERFORM bdc_field   USING 'BDC_OKCODE'  '=WEIT'.

        PERFORM bdc_dynpro  USING 'SAPMV13G'    '1501'.
        PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
        PERFORM bdc_field   USING 'G000-DATAB'  lv_from_date.
        PERFORM bdc_field   USING 'G000-DATBI'  lv_to_date_user_format.
      ENDAT.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lfs_file_data>-matnr
        IMPORTING
          output = lv_matnr.
      CONCATENATE 'KOMGG-LAND1(' lv_count ')' INTO lv_land_field.
      CONCATENATE 'KOMGG-MATNR(' lv_count ')' INTO lv_matnr_field.

      PERFORM bdc_dynpro  USING 'SAPMV13G'      '1501'.
      PERFORM bdc_field   USING 'BDC_OKCODE'    '/00'.
      PERFORM bdc_field   USING lv_land_field   <lfs_file_data>-land1.
      PERFORM bdc_field   USING lv_matnr_field  lv_matnr.

      lv_count = lv_count + 1.
      IF lv_count > 13.
        lv_count = 02.
        PERFORM bdc_field  USING 'BDC_CURSOR'  lv_matnr_field.
        PERFORM bdc_field  USING 'BDC_OKCODE'  '/00'.
        PERFORM bdc_field  USING 'BDC_OKCODE'  '=P+'.
      ENDIF.

      AT END OF kschl.
        PERFORM bdc_dynpro  USING 'SAPMV13G'   '1501'.
        PERFORM bdc_field   USING 'BDC_OKCODE' '=SICH'.
        IF i_bdcdata IS NOT INITIAL.
          REFRESH i_bdcmsgcoll.
          CALL TRANSACTION 'VB01' USING i_bdcdata
                                  OPTIONS FROM lst_params
                                  MESSAGES INTO i_bdcmsgcoll.
          REFRESH:i_bdcdata.
        ENDIF.
*BDCMSGCOLL handling
        IF i_bdcmsgcoll IS NOT INITIAL.
          PERFORM f_bdcmsgcoll_create USING i_bdcmsgcoll
                                            <lfs_file_data>.
        ENDIF.
      ENDAT.
    ENDIF.
  ENDLOOP.
  IF p_test = abap_false.
    IF i_bdcdata IS NOT INITIAL.
      PERFORM bdc_dynpro      USING 'SAPMV13G'   '1501'.
      PERFORM bdc_field       USING 'BDC_OKCODE' '=SICH'.

      REFRESH i_bdcmsgcoll.
      CALL TRANSACTION 'VB01' USING i_bdcdata OPTIONS FROM lst_params
                                              MESSAGES INTO i_bdcmsgcoll.
      REFRESH:i_bdcdata.

*BDCMSGCOLL handling
      IF i_bdcmsgcoll IS NOT INITIAL.
        PERFORM f_bdcmsgcoll_create USING i_bdcmsgcoll
                                          <lfs_file_data>.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAT_REST_DELETE
*&---------------------------------------------------------------------*
*       text  BDC recording for material Deletion
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mat_rest_delete .
  DATA:lst_params   TYPE ctu_params,
       lv_to_date   TYPE d VALUE '99991231',
       lv_from_date TYPE d,
       lv_matnr     TYPE matnr.

  SORT i_file_data BY kschl.
  lst_params-dismode = 'N'.
  lst_params-defsize = abap_true.
  lst_params-updmode = 'S'.

  DATA(lv_to_date_user_format) = |{ lv_to_date DATE = USER }|.

  LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lfs_file_data>).

*Pre validation
    CLEAR v_err_flag.
    PERFORM f_pre_validations CHANGING <lfs_file_data>
                                       v_err_flag.
    IF v_err_flag IS NOT INITIAL.
      CONTINUE.
    ENDIF.

    IF p_test = abap_false.
      WRITE <lfs_file_data>-fromdate TO lv_from_date.
      DATA(lv_from_date_user_format) = |{ lv_from_date DATE = USER }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lfs_file_data>-matnr
        IMPORTING
          output = lv_matnr.

      PERFORM bdc_dynpro  USING 'SAPMV13G'    '0100'.
      PERFORM bdc_field   USING 'BDC_CURSOR'  'G000-KSCHL'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
      PERFORM bdc_field   USING 'G000-KSCHL'  <lfs_file_data>-kschl.

      PERFORM bdc_dynpro  USING 'SAPLV14A'    '0100'.
      PERFORM bdc_field   USING 'BDC_CURSOR'  'RV130-SELKZ(01)'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=WEIT'.

      PERFORM bdc_dynpro  USING 'RV13G501'    '1000'.
      PERFORM bdc_field   USING 'BDC_CURSOR'  'F001-LOW'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=ONLI'.
      PERFORM bdc_field   USING 'F001-LOW'    <lfs_file_data>-land1.
      PERFORM bdc_field   USING 'F002-LOW'    lv_matnr.
      PERFORM bdc_field   USING 'SEL_DATE'    lv_from_date_user_format.
*Selecting Row
      PERFORM bdc_dynpro  USING 'SAPMV13G'    '1501'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=MARL'.
*CLick on Minus Button to delete
      PERFORM bdc_dynpro  USING 'SAPMV13G'    '1501'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=ENTF'.
*POp up CLick on "yes' button
      PERFORM bdc_dynpro  USING 'SAPLSPO1'    '0300'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=YES'.
*Save button
      PERFORM bdc_dynpro  USING 'SAPMV13G'    '1501'.
      PERFORM bdc_field   USING 'BDC_OKCODE'  '=SICH'.
*CALL TRANSACTION USING VB02.
      IF i_bdcdata IS NOT INITIAL.
        REFRESH i_bdcmsgcoll.
        CALL TRANSACTION 'VB02' USING i_bdcdata OPTIONS FROM lst_params
                                                MESSAGES INTO i_bdcmsgcoll.
      ENDIF.
      REFRESH:i_bdcdata.
*BDCMSGCOLL handling
      IF i_bdcmsgcoll IS NOT INITIAL.
        PERFORM f_bdcmsgcoll USING i_bdcmsgcoll
                                   <lfs_file_data>.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FORMAT_MESSAGE
*&---------------------------------------------------------------------*
*       text  Processing errors after call transaction.
*----------------------------------------------------------------------*
*      -->P_LST_BDCMSGCOLL  text
*      <--P_LV_MSG  text
*----------------------------------------------------------------------*
FORM f_format_message  USING    p_lst_bdcmsgcoll TYPE bdcmsgcoll
                       CHANGING p_lv_msg TYPE char255.

  CALL FUNCTION 'FORMAT_MESSAGE'
    EXPORTING
      id        = p_lst_bdcmsgcoll-msgid
      lang      = sy-langu
      no        = p_lst_bdcmsgcoll-msgnr
      v1        = p_lst_bdcmsgcoll-msgv1
      v2        = p_lst_bdcmsgcoll-msgv2
      v3        = p_lst_bdcmsgcoll-msgv3
      v4        = p_lst_bdcmsgcoll-msgv4
    IMPORTING
      msg       = p_lv_msg
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc EQ 0.
    ##FM_SUBRC_OK.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PRE_VALIDATIONS
*&---------------------------------------------------------------------*
*       text  Validating file data prior to creation.
*----------------------------------------------------------------------*
*      -->P_<LFS_FILE_DATA>  text
*----------------------------------------------------------------------*
FORM f_pre_validations CHANGING lfs_file_data TYPE ity_file
                                v_err_flag    TYPE boolean.
  CONSTANTS:lc_e TYPE bapi_mtype VALUE 'E'.

*Material Blank checking
  IF lfs_file_data-matnr IS  INITIAL.
    lfs_file_data-type     = lc_e.
    lfs_file_data-message  = 'Material is Blank'(025).
    APPEND lfs_file_data TO i_error_rec.
    IF v_err_flag IS INITIAL.
      v_error   = v_error  + 1.
      v_err_flag = abap_true.
      EXIT.
    ENDIF.
  ELSE.
*Material Existnace checking
    READ TABLE i_mara  WITH KEY matnr = lfs_file_data-matnr
                                BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      lfs_file_data-type     = lc_e.
      lfs_file_data-message  = 'Material Does not exists'(024).
      APPEND lfs_file_data TO i_error_rec.
      IF v_err_flag IS INITIAL.
        v_error   = v_error  + 1.
        v_err_flag = abap_true.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

*Country blank checking
  IF lfs_file_data-land1 IS  INITIAL.
    v_error  = v_error  + 1.
    lfs_file_data-type     = lc_e.
    lfs_file_data-message  = 'Country is Blank'(023).
    APPEND lfs_file_data TO i_error_rec.
    v_err_flag  = abap_true.
    EXIT.
  ELSE.
*Country Existnace checking
    TRANSLATE lfs_file_data-land1 TO UPPER CASE.
    READ TABLE i_t005 WITH KEY land1 = lfs_file_data-land1
                               BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      lfs_file_data-type     = lc_e.
      lfs_file_data-message  = 'Country Does not exists'(022).
      APPEND lfs_file_data TO i_error_rec.
      IF v_err_flag IS INITIAL.
        v_error   = v_error  + 1.
        v_err_flag = abap_true.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

*Condition  blank checking
  IF lfs_file_data-kschl IS  INITIAL.
    lfs_file_data-type     = lc_e.
    lfs_file_data-message  = 'Condition Type is Blank'(027).
    APPEND lfs_file_data TO i_error_rec.
    IF v_err_flag IS INITIAL.
      v_error   = v_error  + 1.
      v_err_flag = abap_true.
      EXIT.
    ENDIF.
  ELSE.
*Condition Type Existnace checking
    READ TABLE i_t685 WITH KEY kschl = lfs_file_data-kschl
   BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      lfs_file_data-type     = lc_e.
      lfs_file_data-message  = 'Condition Type  Does not exists'(026).
      APPEND lfs_file_data TO i_error_rec.
      IF v_err_flag IS INITIAL.
        v_error   = v_error  + 1.
        v_err_flag = abap_true.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

  IF r_dele IS NOT INITIAL.
*Table entry existance checking
    READ TABLE i_kotg501 INTO DATA(lst_kotg501) WITH KEY kappl = p_kappl
                                                         kschl = p_kschl
                                                         land1 = lfs_file_data-land1
                                                         matnr = lfs_file_data-matnr
                                                         datbi = lfs_file_data-todate
                                                         BINARY SEARCH.
    IF sy-subrc NE  0.
      lfs_file_data-type    = lc_e.
      lfs_file_data-message = 'Entry Does not exists in the table KOTG501'(020).
      APPEND lfs_file_data TO i_error_rec.
      IF v_err_flag IS INITIAL.
        v_error   = v_error  + 1.
        v_err_flag = abap_true.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
  IF r_create IS NOT INITIAL.
    CLEAR lst_kotg501 .
*Table entry existance checking
    READ TABLE i_kotg501 INTO lst_kotg501 WITH KEY kappl = p_kappl
                                                   kschl = p_kschl
                                                   land1 = lfs_file_data-land1
                                                   matnr = lfs_file_data-matnr
                                                   datbi = lfs_file_data-todate
                                                   BINARY SEARCH.
    IF sy-subrc EQ  0.
      lfs_file_data-type    = lc_e.
      lfs_file_data-message = 'Entry Already  exists in the table KOTG501'(021).
      APPEND lfs_file_data TO i_error_rec.
      IF v_err_flag IS INITIAL.
        v_error   = v_error  + 1.
        v_err_flag = abap_true.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BDCMSGCOLL
*&---------------------------------------------------------------------*
*       text  To process the messages after call transactio through BDCMSGCOLl
*----------------------------------------------------------------------*
*      -->P_I_BDCMSGCOLL  text
*      -->P_<LFS_FILE_DATA>  text
*----------------------------------------------------------------------*
FORM f_bdcmsgcoll  USING i_bdcmsgcoll  TYPE tyt_bdcmsgcoll
                         lfs_file_data TYPE ity_file .
  CONSTANTS:lc_e TYPE bapi_mtype VALUE 'E',
            lc_a TYPE bapi_mtype VALUE 'A',
            lc_s TYPE bapi_mtype VALUE 'S'.

  DATA :lv_msg TYPE char255.
  READ TABLE i_bdcmsgcoll INTO DATA(lst_bdcmsgcoll) WITH KEY msgtyp = lc_e.
  IF sy-subrc EQ 0.
    PERFORM f_format_message USING    lst_bdcmsgcoll
                             CHANGING lv_msg.

* Implement suitable error handling here
    v_error  = v_error  + 1.
    lfs_file_data-type    = lst_bdcmsgcoll-msgtyp.
    lfs_file_data-message = lv_msg.
    APPEND lfs_file_data TO i_error_rec.
  ELSE.
    CLEAR lst_bdcmsgcoll.
    READ TABLE  i_bdcmsgcoll INTO lst_bdcmsgcoll WITH KEY msgtyp = lc_a.
    IF sy-subrc EQ 0.
      PERFORM f_format_message USING    lst_bdcmsgcoll
                               CHANGING lv_msg.
* Implement suitable error handling here
      v_error  = v_error  + 1.
      lfs_file_data-type    = lst_bdcmsgcoll-msgtyp.
      lfs_file_data-message = lv_msg.
      APPEND lfs_file_data TO i_error_rec..
    ELSE.
      CLEAR lst_bdcmsgcoll.
      READ TABLE  i_bdcmsgcoll INTO lst_bdcmsgcoll WITH KEY msgtyp = lc_s.
      IF sy-subrc EQ 0.
        PERFORM f_format_message USING    lst_bdcmsgcoll
                                 CHANGING lv_msg.
* Implement suitable error handling here
        v_success = v_success + 1.
        lfs_file_data-type    = lst_bdcmsgcoll-msgtyp.
        lfs_file_data-message = lv_msg.
        APPEND lfs_file_data TO   i_sucess_rec.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BDCMSGCOLL_CREATE
*&---------------------------------------------------------------------*
*       text Processing Messages after call transaction.
*----------------------------------------------------------------------*
FORM f_bdcmsgcoll_create USING i_bdcmsgcoll TYPE tyt_bdcmsgcoll
                               lfs_file_data TYPE ity_file .
  CONSTANTS:lc_e TYPE bapi_mtype VALUE 'E',
            lc_a TYPE bapi_mtype VALUE 'A',
            lc_s TYPE bapi_mtype VALUE 'S'.

  DATA :lv_msg TYPE char255.
  READ TABLE  i_bdcmsgcoll INTO DATA(lst_bdcmsgcoll) WITH KEY msgtyp = lc_e.
  IF sy-subrc EQ 0.
    PERFORM f_format_message USING    lst_bdcmsgcoll
                             CHANGING lv_msg.

* Implement suitable error handling here
    LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
      READ TABLE i_error_rec WITH KEY kschl = <lfs_data>-kschl
                                      matnr = <lfs_data>-matnr
                                      land1 = <lfs_data>-land1
                                   fromdate = <lfs_data>-fromdate
                                     todate = <lfs_data>-todate
                                    TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0.
        v_error = v_error + 1.
        <lfs_data>-type     = lst_bdcmsgcoll-msgtyp.
        <lfs_data>-message  = lv_msg.
        APPEND <lfs_data> TO i_error_rec.
      ENDIF.
    ENDLOOP.
  ELSE.
    CLEAR lst_bdcmsgcoll.
    READ TABLE  i_bdcmsgcoll INTO lst_bdcmsgcoll WITH KEY msgtyp = lc_a.
    IF sy-subrc EQ 0.
      PERFORM f_format_message USING    lst_bdcmsgcoll
                               CHANGING lv_msg.
* Implement suitable error handling here
      LOOP AT i_file_data ASSIGNING <lfs_data>.
        READ TABLE i_error_rec WITH KEY kschl = <lfs_data>-kschl
                                        matnr = <lfs_data>-matnr
                                        land1 = <lfs_data>-land1
                                     fromdate = <lfs_data>-fromdate
                                       todate = <lfs_data>-todate
                                      TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          v_error = v_error + 1.

          <lfs_data>-type     = lst_bdcmsgcoll-msgtyp.
          <lfs_data>-message  = lv_msg.
          APPEND <lfs_data> TO i_error_rec.
        ENDIF.
      ENDLOOP.
    ELSE.
      CLEAR lst_bdcmsgcoll.
      READ TABLE  i_bdcmsgcoll INTO lst_bdcmsgcoll WITH KEY msgtyp = lc_s.
      IF sy-subrc EQ 0.
        PERFORM f_format_message USING    lst_bdcmsgcoll
                                 CHANGING lv_msg.
* Implement suitable error handling here
        LOOP AT i_file_data ASSIGNING <lfs_data>.
          READ TABLE i_error_rec WITH KEY kschl = <lfs_data>-kschl
                                         	matnr = <lfs_data>-matnr
                                          land1 = <lfs_data>-land1
                                       fromdate = <lfs_data>-fromdate
                                         todate = <lfs_data>-todate
                                         TRANSPORTING NO FIELDS.
          IF sy-subrc NE 0.
            v_success = v_success + 1.
            <lfs_data>-type     = lst_bdcmsgcoll-msgtyp.
            <lfs_data>-message  = lv_msg.
            APPEND <lfs_data> TO i_sucess_rec.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
