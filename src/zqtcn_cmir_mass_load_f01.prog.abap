*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CMIR_MASS_LOAD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CMIR_MASS_LOAD_F001
*&---------------------------------------------------------------------*
*&*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_CMIR_MASS_LOAD
* PROGRAM DESCRIPTION:   Program to Maintain Customer-Material Info
*                        from file
* DEVELOPER:             VDPATABALL
* CREATION DATE:         02/14/2019
* OBJECT ID:             C107
* TRANSPORT NUMBER(S):   ED2K914467
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FORM f_get_filename CHANGING p_filename.

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_filename
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


FORM f_get_data_from_file.
  DATA: lst_cm_data TYPE ty_cm_details.
  DATA:li_type TYPE truxs_t_text_data.
  FREE:i_data.
  IF sy-batch = space.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = c_true
        i_tab_raw_data       = li_type
        i_filename           = p_infl
      TABLES
        i_tab_converted_data = i_cm_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SORT i_cm_data BY kunnr vkorg vtweg matnr.

  ELSE.

    CLEAR: i_cm_data,lst_cm_data.
    OPEN DATASET p_infl FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_infl INTO lst_cm_data.
        IF sy-subrc = 0.
          APPEND lst_cm_data TO i_cm_data.
          CLEAR lst_cm_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
      SORT i_cm_data BY kunnr vkorg vtweg matnr.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_infl.
    ENDIF.
  ENDIF.


  FREE:i_knmt_exist.

  LOOP AT i_cm_data ASSIGNING FIELD-SYMBOL(<lst_cm_data>).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = <lst_cm_data>-matnr
      IMPORTING
        output       = <lst_cm_data>-matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
  ENDLOOP.


  IF i_cm_data IS NOT INITIAL.
    SELECT vkorg
           vtweg
           kunnr
           matnr ##TOO_MANY_ITAB_FIELDS
      INTO CORRESPONDING FIELDS OF TABLE i_knmt_exist
      FROM knmt
      FOR ALL ENTRIES IN i_cm_data
      WHERE vkorg = i_cm_data-vkorg
        AND vtweg = i_cm_data-vtweg
        AND kunnr = i_cm_data-kunnr
        AND matnr = i_cm_data-matnr.
    IF sy-subrc = 0.
      SORT: i_knmt_exist BY kunnr vkorg vtweg matnr,
            i_cm_data    BY kunnr vkorg vtweg matnr.
    ENDIF.

    SELECT kunnr
      FROM kna1
      INTO TABLE i_kna1
      FOR ALL ENTRIES IN i_cm_data
      WHERE kunnr EQ i_cm_data-kunnr.

      IF sy-subrc EQ 0.
        SORT i_kna1 BY kunnr.
      ENDIF.


    SELECT matnr
       FROM mara
      INTO TABLE i_mara
      FOR ALL ENTRIES IN i_cm_data
      WHERE matnr EQ i_cm_data-matnr.

  ENDIF.

ENDFORM.

FORM f_create_cm USING lst_cm_data TYPE ty_cm_details.
  DATA:li_xknmt   TYPE STANDARD TABLE OF vknmt,
       li_yknmt   TYPE STANDARD TABLE OF vknmt,
       li_catalog TYPE STANDARD TABLE OF tcatalog,
##NEEDED       lst_exist   TYPE ty_cm_details,
         lst_yknmt   TYPE vknmt,
         lst_knmt    TYPE vknmt,
 lv_success TYPE string,
            lv_error   TYPE string.
  CONSTANTS:lc_update TYPE char1 VALUE 'U',
            lc_insert TYPE char1 VALUE 'I'.


  FREE:li_xknmt,li_yknmt,li_catalog,lst_yknmt,lst_knmt,lst_exist.
  CLEAR lst_knmt.

DATA : flg_error.
CLEAR flg_error.
  SORT i_knmt_exist BY kunnr vkorg vtweg matnr.

 READ TABLE i_knmt_exist INTO lst_exist WITH KEY kunnr = lst_cm_data-kunnr
                                                  vkorg = lst_cm_data-vkorg
                                                  vtweg = lst_cm_data-vtweg
                                                  matnr = lst_cm_data-matnr BINARY SEARCH.
  IF sy-subrc = 0.

    lst_cm_data-message = 'Entry for Customer & Material already exists'(011).
    flg_error = abap_true.

  ELSE.

*--Check customer
    READ TABLE i_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_cm_data-kunnr.
    IF sy-subrc <> 0.
      CONCATENATE 'Customer :'(022)
                  lst_cm_data-kunnr
                  'doesnt Exists in KNA1'(023)
                  INTO  lst_cm_data-message
                  SEPARATED BY space.

      flg_error = abap_true.

      ELSE.

*--Check Material
        READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_cm_data-matnr.
        IF sy-subrc <> 0.
               CONCATENATE 'Material :'(024)
                           lst_cm_data-matnr
                           'doesnt exists in MARA'(025)
                           INTO  lst_cm_data-message
                           SEPARATED BY space.
               flg_error = abap_true.

        ENDIF.
    ENDIF.
 ENDIF.

 IF lst_cm_data-vkorg IS INITIAL.
  lst_cm_data-message = 'Sales org is Empty'(021).
  flg_error = abap_true.
  ELSEIF lst_cm_data-vtweg IS INITIAL.
    lst_cm_data-message = 'Distribution Channel is Empty'(022).
    flg_error = abap_true.
 ENDIF.


  IF flg_error EQ abap_false.

    lst_knmt-kunnr = lst_cm_data-kunnr.
    lst_knmt-vtweg = lst_cm_data-vtweg.
    lst_knmt-vkorg = lst_cm_data-vkorg.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lst_cm_data-matnr
      IMPORTING
        output       = lst_knmt-matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    lst_knmt-updkz = lc_insert. "I'
    APPEND lst_knmt TO li_xknmt.


    CALL FUNCTION 'RV_CUSTOMER_MATERIAL_UPDATE'
      TABLES
        xknmt_tab    = li_xknmt
        yknmt_tab    = li_yknmt
        tcatalog_tab = li_catalog.
    ##FM_SUBRC_OK
   IF sy-subrc = 0.
      COMMIT WORK.
      lst_cm_data-message = 'Successfully Created'(004).
      APPEND lst_cm_data TO i_sucess_rec.

    ELSE.
      CONCATENATE lst_knmt-vkorg
                  lst_knmt-vtweg
                  lst_knmt-kunnr
                  lst_knmt-matnr
                  'Creation failed'(003)
        INTO lst_cm_data-message SEPARATED BY space.
      APPEND lst_cm_data TO i_error_rec.
      SHIFT lst_cm_data-message  LEFT DELETING LEADING space.
    ENDIF.


  ELSE.  "If error flag updated

  APPEND lst_cm_data TO i_error_rec.


ENDIF.

ENDFORM.

FORM f_handle_user_command USING i_ucomm TYPE salv_de_function.


  DATA: li_rows   TYPE salv_t_row.
  DATA: lst_const TYPE zcaconstant.
  DATA: lst_columns TYPE REF TO cl_salv_columns.
  CONSTANTS:lc_e TYPE char1 VALUE 'E'.


  CALL METHOD gr_selections->get_selected_rows
    RECEIVING
      value = li_rows.
  IF li_rows IS NOT INITIAL.

    DESCRIBE TABLE li_rows LINES DATA(lv_no_of_records).
    FREE: i_const.
    SELECT *
       FROM zcaconstant
       INTO TABLE i_const
       WHERE devid = c_devid
      AND activate = c_x.

    IF sy-subrc EQ 0.
      SORT i_const BY param1.
    ENDIF.

    CLEAR lst_const .
    READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param1.

    IF lv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.

      IF lv_no_of_records > lst_const-low.
        CLEAR lst_const .
        READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param2.
        IF sy-subrc = 0.
          PERFORM f_submit_program_in_background USING lst_const-low.
        ENDIF.

      ELSE.
        LOOP AT li_rows INTO DATA(lst_rows).
          READ TABLE i_cm_data ASSIGNING FIELD-SYMBOL(<fs_cm_data>) INDEX lst_rows.
          IF <fs_cm_data>  IS  ASSIGNED.
            PERFORM f_create_cm USING <fs_cm_data>.
          ENDIF.
        ENDLOOP.
        PERFORM f_error_success_log.
        lst_columns = gr_table->get_columns( ).
        lst_columns->set_optimize( c_true ).
        PERFORM f_set_top_of_page CHANGING gr_table.
        gr_table->refresh( ).
      ENDIF.
    ENDIF.
  ELSE.
    MESSAGE text-010 TYPE lc_e.
  ENDIF.

ENDFORM.                    " handle_user_command

FORM f_display_data.

  DATA: lr_events TYPE REF TO cl_salv_events_table.

  DATA: lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = i_cm_data.
    ##NO_HANDLER    CATCH cx_salv_msg .
  ENDTRY.

  IF sy-batch = space.
    gr_table->set_screen_status(
        pfstatus      =  'ZSALV_STANDARD'
        report        =  sy-repid
        set_functions = gr_table->c_functions_all ).

    lr_columns = gr_table->get_columns( ).
    lr_columns->set_optimize( c_true ).

    gr_selections = gr_table->get_selections( ).

    gr_selections->set_selection_mode( gr_selections->multiple ).

    TRY.
        lr_column ?= lr_columns->get_column( 'KUNNR' ).
        lr_column ?= lr_columns->get_column( 'VKORG' ).
        lr_column ?= lr_columns->get_column( 'VTWEG' ).
        lr_column ?= lr_columns->get_column( 'MATNR' ).
      ##NO_HANDLER    CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lr_column ?= lr_columns->get_column( 'MESSAGE' ).
        lr_column->set_short_text( text-002 ).
        lr_column->set_medium_text( text-002 ).
        lr_column->set_long_text( text-002 ).
      ##NO_HANDLER      CATCH cx_salv_not_found.
    ENDTRY.

    lr_events = gr_table->get_event( ).
    CREATE OBJECT gr_events.
    SET HANDLER gr_events->on_user_command FOR lr_events.
    PERFORM f_set_top_of_page CHANGING gr_table.
  ENDIF.
  gr_table->display( ).

ENDFORM.

FORM f_cm_create.
  DATA:lv_sel TYPE string.
  CONSTANTS:lc_s TYPE char1 VALUE 'S'.
  SORT i_cm_data BY kunnr vkorg vtweg matnr.
  IF sy-batch <> space.
    CONCATENATE 'Batch Job Triggered by'(015)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE lc_s.
  ENDIF.

  LOOP AT i_cm_data ASSIGNING FIELD-SYMBOL(<fs_cm_data>).
    PERFORM f_create_cm USING <fs_cm_data>.
  ENDLOOP.

  IF sy-batch <> space.
    FREE:gv_success,gv_error,lv_sel.
    DESCRIBE TABLE i_error_rec  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec LINES gv_success .
    gv_total_proc = gv_error + gv_success.
    DESCRIBE TABLE i_cm_data LINES lv_sel.
    CONCATENATE 'Total selected records to be processed: '(014) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE lc_s.
    CONCATENATE 'successful records:'(012) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE lc_s.
    MESSAGE lv_error TYPE lc_s.
    FREE: i_const.
    SELECT *
       FROM zcaconstant
       INTO TABLE i_const
       WHERE devid = c_devid
      AND activate = c_x.
  ENDIF.

  PERFORM f_error_success_log.
ENDFORM.


FORM f_submit_program_in_background USING p_file TYPE char80.
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  CONSTANTS: c_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             c_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             c_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             c_p_infl      TYPE rsscr_name VALUE 'P_INFL'.
  DATA: lv_file TYPE string,
        lv_bjob TYPE char1.

  CONCATENATE p_file text-001 sy-datum sy-uzeit INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_cm_data INTO DATA(lst_cm_data).
      TRANSFER lst_cm_data TO lv_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.


  CLEAR:lst_cm_data,lst_params.
  lst_params-selname = c_p_infl.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = c_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = c_sign_i.       "I-in
  lst_params-option  = c_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE 'ZQTCR_CMIR_MASS' sy-datum sy-uzeit INTO lv_jobname.
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
      SUBMIT zqtcr_cmir_mass_load WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_cmir_mass_load WITH SELECTION-TABLE li_params.
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
  CONSTANTS:lc_success TYPE string VALUE 'CMIR_UPD_SUCCESS_',
            lc_error   TYPE string VALUE 'CMIR_UPD_ERROR_',
            lc_s       TYPE char1 VALUE 'S'.
  DATA:lv_head   TYPE string.
  IF sy-batch = space.
    DESCRIBE TABLE i_error_rec  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec LINES gv_success .
    gv_total_proc = gv_error + gv_success.
  ENDIF.

  IF  i_sucess_rec IS NOT INITIAL.
    READ TABLE  i_const INTO DATA(lst_const) WITH KEY param1 = c_param2.
    IF sy-subrc EQ 0.
      CONCATENATE lst_const-low lc_success sy-datum sy-uzeit INTO DATA(lv_file).
      CONDENSE  lv_file NO-GAPS.
      CLOSE DATASET lv_file.
      OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc = 0.
        CONCATENATE 'Customer'(016)
                    'Sale Org'(017)
                    'Distr.Channel'(018)
                    'Material'(019)
                    'Message'(002)
                   INTO lv_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_head TO lv_file.
        LOOP AT i_sucess_rec INTO DATA(lst_sucess_rec).
          CONCATENATE lst_sucess_rec-kunnr
                      lst_sucess_rec-vkorg
                      lst_sucess_rec-vtweg
                      lst_sucess_rec-matnr
                      lst_sucess_rec-message
                      INTO DATA(lv_value1)
         SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
          TRANSFER lv_value1  TO lv_file.
          CLEAR :lst_sucess_rec.
        ENDLOOP.
        MESSAGE i258(zqtc_r2) WITH lv_file.
      ELSE.
        MESSAGE e256(zqtc_r2) WITH lv_file.
      ENDIF.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.
  IF i_error_rec IS  NOT INITIAL.
    READ TABLE  i_const INTO DATA(lst_const1) WITH KEY param1 = c_param2.
    IF sy-subrc EQ 0.
      CONCATENATE lst_const1-low lc_error sy-datum sy-uzeit INTO DATA(lv_file_e).
      CONDENSE  lv_file NO-GAPS.
      CLOSE DATASET lv_file_e.
      OPEN DATASET lv_file_e FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      CONCATENATE 'Customer'(016)
                    'Sale Org'(017)
                    'Distr.Channel'(018)
                    'Material'(019)
                    'Message'(002)
                   INTO lv_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_head TO lv_file_e.
      IF sy-subrc = 0.
        LOOP AT i_error_rec  INTO DATA(lst_error_rec).
          CONCATENATE lst_error_rec-kunnr
                      lst_error_rec-vkorg
                      lst_error_rec-vtweg
                      lst_error_rec-matnr
                      lst_error_rec-message
                      INTO DATA(lv_value)
         SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
          TRANSFER lv_value  TO lv_file_e.
          CLEAR :lst_error_rec.
        ENDLOOP.
        MESSAGE i257(zqtc_r2) WITH lv_file_e.
      ELSE.
        MESSAGE e256(zqtc_r2) WITH lv_file_e.
      ENDIF.
    ENDIF.
    CLOSE DATASET lv_file_e.
  ENDIF.

ENDFORM.

FORM f_set_top_of_page CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string,
         lv_rows  TYPE char05.                              "#EC NEEDED

  lv_rows = lines( i_cm_data ) .
  CONDENSE lv_rows.
  CONDENSE gv_total_proc.
  CONDENSE gv_error.
  CONDENSE gv_success.

  lo_head = 'Maintain Customer-Material Info Report'(020).

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

  lo_text = lo_flow->create_text( text = lv_rows
                                  tooltip = lv_rows ).

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
