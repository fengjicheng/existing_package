*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_MAT_MASS_UPLD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_WLS_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         03/04/2020
*& OBJECT ID:             C113
*& TRANSPORT NUMBER(S):   ED2K917656
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM f_handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
  "on_single_click
ENDCLASS.

FORM f_get_filename CHANGING fp_filename.
  IF sy-batch = space.
    CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
      CHANGING
        file_name     = fp_filename
      EXCEPTIONS
        mask_too_long = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file TABLES fp_file_data.
  DATA:li_type       TYPE truxs_t_text_data,
       lst_file_data TYPE ity_file.
  FREE:fp_file_data.
  IF sy-batch = space.
*--foreground file fetching into internal table
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = fp_file_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
*--Background file fetching into internal table
    FREE: fp_file_data,
          lst_file_data.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO lst_file_data.
        IF sy-subrc = 0.
          APPEND lst_file_data TO fp_file_data.
          CLEAR lst_file_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_file.
    ENDIF.
  ENDIF.
  IF fp_file_data[] IS NOT INITIAL.
    FREE:i_file_temp,
         i_rows.
    i_file_temp[] =  fp_file_data[].
    SORT i_file_temp BY bismt.
    LOOP AT i_file_temp ASSIGNING FIELD-SYMBOL(<lfs_file_temp>).
      CONDENSE <lfs_file_temp>-bismt.
    ENDLOOP.
    SORT i_file_temp BY bismt.
    DELETE ADJACENT DUPLICATES FROM i_file_temp COMPARING bismt.
    IF i_file_temp IS NOT INITIAL.
      SELECT matnr
             vpsta
             mtart
             bismt
             matkl
         FROM mara
         INTO TABLE i_mara
         FOR ALL ENTRIES IN i_file_temp
         WHERE bismt = i_file_temp-bismt.
      IF sy-subrc = 0.
        SORT i_mara BY bismt.
      ENDIF.
      FREE:i_file_temp.
    ENDIF.
  ENDIF.
  i_rows = lines( fp_file_data[] ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data.
  DATA: lr_events TYPE REF TO cl_salv_events_table.

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
      lr_column ?= lr_columns->get_column( 'MATNR' ).
      lr_column ?= lr_columns->get_column( 'IND_SECT' ).
      lr_column ?= lr_columns->get_column( 'MTART' ).
      lr_column ?= lr_columns->get_column( 'BUKRS' ).
      lr_column ?= lr_columns->get_column( 'WERKS' ).
      lr_column ?= lr_columns->get_column( 'VKORG' ).
      lr_column ?= lr_columns->get_column( 'VTWEG' ).
      lr_column ?= lr_columns->get_column( 'MAKTX' ).
      lr_column ?= lr_columns->get_column( 'LANGU' ).
      lr_column->set_short_text( 'Lang' ).
      lr_column->set_medium_text( 'Language' ).
      lr_column->set_long_text( 'Language' ).
      lr_column ?= lr_columns->get_column( 'MEINS' ).
      lr_column->set_short_text( 'Units' ).
      lr_column->set_medium_text( 'Units' ).
      lr_column->set_long_text( 'Units' ).
      lr_column ?= lr_columns->get_column( 'MATKL' ).
      lr_column ?= lr_columns->get_column( 'BISMT' ).
      lr_column ?= lr_columns->get_column( 'EXTWG' ).
      lr_column ?= lr_columns->get_column( 'SPART' ).
      lr_column ?= lr_columns->get_column( 'MSTAE' ).
      lr_column ?= lr_columns->get_column( 'MSTDE' ).
      lr_column ?= lr_columns->get_column( 'ITEM_CAT' ).
      lr_column ?= lr_columns->get_column( 'BRGEW' ).
      lr_column->set_short_text( 'Gross Wt' ).
      lr_column->set_medium_text( 'Gross Wt' ).
      lr_column->set_long_text( 'Gross Weight' ).
      lr_column ?= lr_columns->get_column( 'NTGEW' ).
      lr_column->set_short_text( 'Net Wt' ).
      lr_column->set_medium_text( 'Net Wt' ).
      lr_column->set_long_text( 'Net Weight' ).
      lr_column ?= lr_columns->get_column( 'GEWEI' ).
      lr_column->set_short_text( 'Wt. Unit' ).
      lr_column->set_medium_text( 'Wt. Unit' ).
      lr_column->set_long_text( 'Weight Unit' ).
      lr_column ?= lr_columns->get_column( 'VRKME' ).
      lr_column->set_short_text( 'Sal.Unit' ).
      lr_column->set_medium_text( 'Sale Unit' ).
      lr_column->set_long_text( 'Sale Unit' ).
      lr_column ?= lr_columns->get_column( 'UMREN' ).
      lr_column->set_short_text( 'Denomint' ).
      lr_column->set_medium_text( 'Denominator' ).
      lr_column->set_long_text( 'Denominator' ).
      lr_column ?= lr_columns->get_column( 'UMREZ' ).
      lr_column->set_short_text( 'Numerator' ).
      lr_column->set_medium_text( 'Numerator' ).
      lr_column->set_long_text( 'Numerator' ).
      lr_column ?= lr_columns->get_column( 'DWERK' ).
      lr_column ?= lr_columns->get_column( 'TAXKM' ).
      lr_column->set_short_text( 'Tax clas.' ).
      lr_column->set_medium_text( 'Tax classification' ).
      lr_column->set_long_text( 'Tax classification' ).
      lr_column ?= lr_columns->get_column( 'AUMNG' ).
      lr_column->set_short_text( 'Min.Ord' ).
      lr_column->set_medium_text( 'Min. Order' ).
      lr_column->set_long_text( 'Min. Order' ).
      lr_column ?= lr_columns->get_column( 'MVGR2' ).
      lr_column ?= lr_columns->get_column( 'MTPOS' ).
      lr_column ?= lr_columns->get_column( 'MTVFP' ).
      lr_column ?= lr_columns->get_column( 'TRAGR' ).
      lr_column ?= lr_columns->get_column( 'LADGR' ).
      lr_column ?= lr_columns->get_column( 'PRCTR' ).
      lr_column ?= lr_columns->get_column( 'MINBE' ).
      lr_column->set_short_text( 'Reord.Pnt' ).
      lr_column->set_medium_text( 'Reorder Point' ).
      lr_column->set_long_text( 'Reorder Point' ).
      lr_column ?= lr_columns->get_column( 'DISLS' ).
      lr_column->set_short_text( 'Lot Size' ).
      lr_column->set_medium_text( 'Lot Size' ).
      lr_column->set_long_text( 'Lot Size' ).
      lr_column ?= lr_columns->get_column( 'MABST' ).
      lr_column->set_short_text( 'Max.Stock' ).
      lr_column->set_medium_text( 'Max.Stock' ).
      lr_column->set_long_text( 'Max.Stock' ).
      lr_column ?= lr_columns->get_column( 'EKGRP' ).
      lr_column ?= lr_columns->get_column( 'DISMM' ).
      lr_column ?= lr_columns->get_column( 'DISPO' ).
      lr_column ?= lr_columns->get_column( 'BESKZ' ).
      lr_column ?= lr_columns->get_column( 'DZEIT' ).
      lr_column->set_short_text( 'Inh. Prd' ).
      lr_column->set_medium_text( 'Inhouse Prd' ).
      lr_column->set_long_text( 'Inhouse Prd' ).
      lr_column ?= lr_columns->get_column( 'PLIFZ' ).
      lr_column->set_short_text( 'Plan. Del.' ).
      lr_column->set_medium_text( 'Planned Del.' ).
      lr_column->set_long_text( 'Planned Del.' ).
      lr_column ?= lr_columns->get_column( 'BKLAS' ).
      lr_column ?= lr_columns->get_column( 'VPRSV' ).
      lr_column ?= lr_columns->get_column( 'PEINH' ).
      lr_column->set_short_text( 'Pr.Unit' ).
      lr_column->set_medium_text( 'Price Unit' ).
      lr_column->set_long_text( 'Price Unit' ).
      lr_column ?= lr_columns->get_column( 'STPRS' ).
      lr_column->set_short_text( 'Std.price' ).
      lr_column->set_medium_text( 'Standard price' ).
      lr_column->set_long_text( 'Standard price' ).
      lr_column ?= lr_columns->get_column( 'VERPR' ).
      lr_column->set_short_text( 'Avg.price' ).
      lr_column->set_medium_text( 'Mov.Avg.price' ).
      lr_column->set_long_text( 'Mov.Avg.price' ).
      lr_column ?= lr_columns->get_column( 'TEXT' ).
      lr_column->set_short_text( 'S.Text' ).
      lr_column->set_medium_text( 'Sale Text' ).
      lr_column->set_long_text( 'Sale Text' ).
      lr_column ?= lr_columns->get_column( 'TYPE' ).
      lr_column ?= lr_columns->get_column( 'MESSAGE' ).
      lr_column->set_short_text( 'Message' ).
      lr_column->set_medium_text( 'Message' ).
      lr_column->set_long_text( 'Message' ).
    ##NO_HANDLER    CATCH cx_salv_not_found.
  ENDTRY.
  IF sy-batch = space.
    lr_events = ir_table->get_event( ).
    CREATE OBJECT ir_events.
    SET HANDLER ir_events->on_user_command FOR lr_events.
    PERFORM f_set_top_of_page CHANGING ir_table.
  ENDIF.
  ir_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
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
  IF r_mat IS NOT INITIAL.
    lo_head = 'WLS - Material Master Create/Change Report'(003).
  ELSEIF r_clf IS NOT INITIAL.
    lo_head = 'WLS - Material Classification Mass Report'(081).
  ENDIF.
  CONDENSE i_rows.
  CONDENSE gv_total_proc.
  CONDENSE gv_error.
  CONDENSE gv_success.

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

  lo_label = lo_flow->create_label( text = 'Total Records:'(004)
                                    tooltip = 'Total Records:'(004) ).

  lo_text = lo_flow->create_text( text = i_rows
                                  tooltip = i_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '(006)
                                    tooltip = 'Processed : '(006) ).

  lo_text = lo_flow->create_text( text = gv_total_proc
                                  tooltip = gv_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'(007)
                                    tooltip = 'Success:'(007) ).

  lo_text = lo_flow->create_text( text = gv_success
                                  tooltip = gv_success ).
*
*
  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'(008)
                                    tooltip =  'Errors:'(008) ).

  lo_text = lo_flow->create_text( text = gv_error
                                  tooltip = gv_error ).
*--Set Top of List
  fp_co_alv->set_top_of_list( lo_grid ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_SALV_FUNCTION  text
*----------------------------------------------------------------------*
FORM f_handle_user_command  USING  fp_ucomm TYPE salv_de_function.
  DATA: li_rows   TYPE salv_t_row.
  DATA: lst_const TYPE zcaconstant.
  DATA: lst_columns TYPE REF TO cl_salv_columns.
  IF r_mat IS NOT INITIAL.
    DESCRIBE TABLE i_file_data LINES DATA(lv_no_of_records).
  ELSEIF r_clf IS NOT INITIAL.
    DESCRIBE TABLE i_file_temp_clf LINES lv_no_of_records.
  ENDIF.
  FREE: i_const.
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
        IF r_mat IS NOT INITIAL.
          LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lfs_file_data>).
            PERFORM f_create_material USING <lfs_file_data>.
          ENDLOOP.
          PERFORM f_error_success_log.
        ELSEIF r_clf IS NOT INITIAL.
          LOOP AT i_file_temp_clf ASSIGNING FIELD-SYMBOL(<lfs_file_data_clf>).
            PERFORM f_create_material_clsf USING <lfs_file_data_clf>.
          ENDLOOP.
          PERFORM f_clf_error_success_log.
        ENDIF.
        lst_columns = ir_table->get_columns( ).
        lst_columns->set_optimize( c_true ).
        PERFORM f_set_top_of_page CHANGING ir_table.
        ir_table->refresh( ).
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_FILE_DATA>  text
*----------------------------------------------------------------------*
FORM f_create_material  USING  fp_file_data TYPE ity_file.

  READ TABLE i_mara INTO DATA(lst_mara) WITH KEY bismt = fp_file_data-bismt.
  IF sy-subrc NE 0.
    IF fp_file_data-bismt IS NOT INITIAL.
      IF fp_file_data-maktx IS NOT INITIAL.
*--Get new material number based on the material type
        CALL FUNCTION 'MATERIAL_NUMBER_GET_NEXT'
          EXPORTING
            materialart          = fp_file_data-mtart
          IMPORTING
            materialnr           = fp_file_data-matnr
          EXCEPTIONS
            no_internal_interval = 1
            type_not_found       = 2
            OTHERS               = 3.
        IF sy-subrc = 0.
          PERFORM f_material_create_new USING fp_file_data.
        ENDIF.
      ELSE.
*--Material description blank
        fp_file_data-type    = c_e.
        fp_file_data-message = 'Material Description is blank'(045).
        APPEND fp_file_data TO i_error_rec.
      ENDIF.
    ELSE.
*--Old Material Number blank
      fp_file_data-type    = c_e.
      fp_file_data-message = 'Old Material is blank'(066).
      APPEND fp_file_data TO i_error_rec.
    ENDIF.
  ELSE.
*---Change Materials
    IF fp_file_data-bismt IS NOT INITIAL.
      IF fp_file_data-maktx IS NOT INITIAL.
        fp_file_data-matnr      = lst_mara-matnr. "fp_file_data-matnr.
        fp_file_data-mtart      = lst_mara-mtart. "fp_file_data-mtart.
        PERFORM f_material_create_new USING fp_file_data.
      ELSE.
*--Material description blank
        fp_file_data-type    = c_e.
        fp_file_data-message = 'Material Description is blank'(045).
        APPEND fp_file_data TO i_error_rec.
      ENDIF.
    ELSE.
*--Old Material Number blank
      fp_file_data-type    = c_e.
      fp_file_data-message = 'Old Material is blank'(066).
      APPEND fp_file_data TO i_error_rec.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_material_create .
  DATA:lv_sel TYPE string.

  IF sy-batch <> space.
    CONCATENATE 'Batch Job Triggered by'(010)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE c_s.
  ENDIF.

  LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lfs_file_data>).
    PERFORM f_create_material USING <lfs_file_data>.
  ENDLOOP.

  IF sy-batch <> space.
    FREE:gv_success,
         gv_error,
          lv_sel.
    DESCRIBE TABLE i_error_rec  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec LINES gv_success .
    DESCRIBE TABLE i_file_data  LINES lv_sel.
    gv_total_proc = gv_error + gv_success.
    CONCATENATE 'Total selected records to be processed: '(011) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(012) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE c_s.
    MESSAGE lv_error TYPE c_s.
    PERFORM f_error_success_log.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background."  USING p_file TYPE string.
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  CONSTANTS: lc_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_p_file      TYPE rsscr_name VALUE 'P_FILE',
             lc_r_mat       TYPE rsscr_name VALUE 'R_MAT',
             lc_r_clf       TYPE rsscr_name VALUE 'R_CLF'.

  DATA: lv_file TYPE string,
        lv_bjob TYPE char1.
  IF r_mat IS NOT INITIAL.
    CONCATENATE v_file_path 'Material_WLS_'(014) sy-datum sy-uzeit INTO lv_file.
  ELSEIF r_clf IS NOT INITIAL.
    CONCATENATE v_file_path 'Mat_Clsf_WLS_'(080) sy-datum sy-uzeit INTO lv_file.
  ENDIF.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    IF r_mat IS NOT INITIAL.
      LOOP AT i_file_data INTO DATA(fp_file_data).
        TRANSFER fp_file_data TO lv_file.
      ENDLOOP.
    ELSEIF r_clf IS NOT INITIAL.
      LOOP AT i_file_data_clf INTO DATA(fp_file_data_clf).
        TRANSFER fp_file_data_clf TO lv_file.
      ENDLOOP.
    ENDIF.
  ENDIF.
  CLOSE DATASET lv_file.


  CLEAR:fp_file_data,
        lst_params.
  lst_params-selname = lc_p_file.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_r_mat.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = r_mat.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  lst_params-selname = lc_r_clf.
  lst_params-kind    = lc_parameter_p.
  lst_params-sign    = lc_sign_i.
  lst_params-option  = lc_option_eq.
  lst_params-low     = r_clf.
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE 'ZQTCR_WLS_MAT_CR_' sy-datum sy-uzeit INTO lv_jobname.
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
      SUBMIT zqtcr_wls_material_mass_upld WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_wls_material_mass_upld WITH SELECTION-TABLE li_params.
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
    DESCRIBE TABLE i_error_rec  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec LINES gv_success .
    gv_total_proc = gv_error + gv_success.
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
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec INTO DATA(lst_record).
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-bukrs
                    lst_record-werks
                    lst_record-vkorg
                    lst_record-vtweg
                    lst_record-maktx
                    lst_record-langu
                    lst_record-meins
                    lst_record-matkl
                    lst_record-bismt
                    lst_record-extwg
                    lst_record-spart
                    lst_record-mstae
                    lst_record-mstde
                    lst_record-item_cat
                    lst_record-brgew
                    lst_record-ntgew
                    lst_record-gewei
                    lst_record-vrkme
                    lst_record-umren
                    lst_record-umrez
                    lst_record-dwerk
                    lst_record-taxkm
                    lst_record-aumng
                    lst_record-mvgr2
                    lst_record-mtpos
                    lst_record-mtvfp
                    lst_record-tragr
                    lst_record-ladgr
                    lst_record-prctr
                    lst_record-minbe
                    lst_record-disls
                    lst_record-mabst
                    lst_record-ekgrp
                    lst_record-dismm
                    lst_record-dispo
                    lst_record-beskz
                    lst_record-dzeit
                    lst_record-plifz
                    lst_record-bklas
                    lst_record-vprsv
                    lst_record-peinh
                    lst_record-stprs
                    lst_record-verpr
                    lst_record-text
                    lst_record-provg
                    lst_record-sernp
                    lst_record-sfcpf
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

    FREE:lv_value1,
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
      TRANSFER i_head TO lv_file_e.

      CLEAR lst_record.
      LOOP AT i_error_rec  INTO lst_record.
        CONCATENATE lst_record-matnr
                  lst_record-ind_sect
                  lst_record-mtart
                  lst_record-bukrs
                  lst_record-werks
                  lst_record-vkorg
                  lst_record-vtweg
                  lst_record-maktx
                  lst_record-langu
                  lst_record-meins
                  lst_record-matkl
                  lst_record-bismt
                  lst_record-extwg
                  lst_record-spart
                  lst_record-mstae
                  lst_record-mstde
                  lst_record-item_cat
                  lst_record-brgew
                  lst_record-ntgew
                  lst_record-gewei
                  lst_record-vrkme
                  lst_record-umren
                  lst_record-umrez
                  lst_record-dwerk
                  lst_record-taxkm
                  lst_record-aumng
                  lst_record-mvgr2
                  lst_record-mtpos
                  lst_record-mtvfp
                  lst_record-tragr
                  lst_record-ladgr
                  lst_record-prctr
                  lst_record-minbe
                  lst_record-disls
                  lst_record-mabst
                  lst_record-ekgrp
                  lst_record-dismm
                  lst_record-dispo
                  lst_record-beskz
                  lst_record-dzeit
                  lst_record-plifz
                  lst_record-bklas
                  lst_record-vprsv
                  lst_record-peinh
                  lst_record-stprs
                  lst_record-verpr
                  lst_record-text
                  lst_record-provg
                  lst_record-sernp
                  lst_record-sfcpf
                  lst_record-type
                  lst_record-message
                  INTO lv_value1
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
*       text
*----------------------------------------------------------------------*
*      -->P_LV_HEAD  text
*----------------------------------------------------------------------*
FORM f_head_names.
  FREE:i_head.

  CONCATENATE 'Material'(015)
             'Industry Sector'(002)
             'Material Type'(016)
             'Company Code'(036)
             'Plant'(005)
             'sale Org.'(017)
             'Distribution'(018)
             'Material Des.'(019)
             'Laguage'(046)
             'Base Unit'(020)
             'Mat. Group'(021)
             'Old Material'(022)
             'External Mat Group'(047)
             'Division'(023)
             'Cross Plant Mat'(048)
             'Cross_plant Mat Dt'(049)
             'Item cat. group'(025)
             'Gross Weight'(050)
             'Net Weight'(051)
             'Weight Unit'(052)
             'Sale Unit'(053)
             'Denominator'(068)
             'Numerator'(069)
             'Del. Plant'(026)
             'Tax Classif.'(027)
             'Min. Order'(054)
             'Material Group2'(055)
             'Item cat. group'(025)
             'Material Group4'(065)
             'Availability Check'(029)
             'Transportation Group'(030)
             'Loading Group'(031)
             'Profit Center'(032)
             'Reorder Point'(056)
             'Lot Size'(067)
             'Max. Stock'(057)
             'Purchase Group'(037)
             'MRP Type'(039)
             'MRP Controller'(058)
             'Procurement Type'(040)
             'In House Prod'(059)
             'Planned Del Time'(060)
             'Valuation Class'(041)
             'Price Control'(063)
             'Price Unit'(042)
             'Standard Price'(043)
             'Moving Avg Price'(070)
             'Sale Text'(064)
             'Commission group'
             'Serial Number Profile'
             'Production Scheduling Profile'
             'Msg Type'(033)
             'Message'(035)
     INTO i_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING   fp_v_path
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
*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_CREATE_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_FILE_DATA  text
*      -->P_TYPE  text
*      -->P_ITY_FILE  text
*----------------------------------------------------------------------*
FORM f_material_create_new  USING   fp_file_data TYPE ity_file.
  DATA:lst_header         TYPE bapimathead,
       lst_clientdata     TYPE bapi_mara,
       lst_clientdatax    TYPE bapi_marax,
       lst_plantdata      TYPE bapi_marc,
       lst_plantdatax     TYPE bapi_marcx,
       lst_valuationdata  TYPE bapi_mbew,
       lst_valuationdatax TYPE bapi_mbewx,
       lst_saledata       TYPE bapi_mvke,
       lst_saledatax      TYPE bapi_mvkex,
       lst_mat_des        TYPE bapi_makt,
       lst_mat_text       TYPE bapi_mltx,
       lst_taxclas        TYPE bapi_mlan,
       lst_uom            TYPE bapi_marm,
       lst_uomx           TYPE bapi_marmx,
       lst_return         TYPE bapiret2,
       li_return          TYPE STANDARD TABLE OF bapi_matreturn2,
       li_uom             TYPE STANDARD TABLE OF bapi_marm,
       li_uomx            TYPE STANDARD TABLE OF bapi_marmx,
       li_mat_des         TYPE STANDARD TABLE OF bapi_makt,
       li_mat_text        TYPE STANDARD TABLE OF bapi_mltx,
       li_taxclas         TYPE STANDARD TABLE OF bapi_mlan,
       lv_meins           TYPE lrmei.

  CONSTANTS: lc_object   TYPE tdobject VALUE 'MVKE',
             lc_id       TYPE tdid     VALUE '0001',
             lc_country  TYPE aland    VALUE 'US',
             lc_tax_type TYPE	tatyp    VALUE 'ZITD'.
  FREE:lst_header,
       lst_clientdata,
       lst_clientdatax,
       lst_plantdata,
       lv_meins,
       lst_plantdatax,
       lst_valuationdata,
       lst_valuationdatax,
       lst_saledata,
       lst_saledatax,
       lst_mat_des,
       li_mat_des,
       li_return,
       li_mat_text,
       lst_mat_text,
       li_uom,
       li_uomx,
       lst_uom,
       lst_uomx,
       lst_taxclas,
       li_taxclas.
*---- Header Segment with Control Information
  lst_header-material         = fp_file_data-matnr.
  lst_header-ind_sector       = fp_file_data-ind_sect.
  lst_header-matl_type        = fp_file_data-mtart.
  lst_header-basic_view       = abap_true.
  lst_header-sales_view       = abap_true.
  lst_header-purchase_view    = abap_true.
  lst_header-mrp_view         = abap_true.
  lst_header-account_view     = abap_true.
  lst_header-work_sched_view  = abap_true.

*----Material Data at Client Level
  lst_clientdata-matl_group = fp_file_data-matkl.    "Material Group
  lst_clientdata-base_uom   = fp_file_data-meins.    "UOM
  lst_clientdata-old_mat_no = fp_file_data-bismt.    "Old Material
  lst_clientdata-division   = fp_file_data-spart.    "Division
  lst_clientdata-pur_status = fp_file_data-mstae.    "Cross-Plant Mat. Status
  lst_clientdata-item_cat   = fp_file_data-item_cat. " Item Categ
  lst_clientdata-trans_grp  = fp_file_data-tragr.    "Transportation Grp
  lst_clientdata-pvalidfrom = fp_file_data-mstde.    "Date from which the cross-plant material status is valid
  lst_clientdata-net_weight = fp_file_data-ntgew.    "Net Weight
  lst_clientdata-unit_of_wt = fp_file_data-gewei.    "Weight Unit
  lst_clientdata-extmatlgrp = fp_file_data-extwg.    "External Material Group

  lst_clientdatax-matl_group = abap_true.
  lst_clientdatax-base_uom   = abap_true.
  lst_clientdatax-old_mat_no = abap_true.
  lst_clientdatax-division   = abap_true.
  lst_clientdatax-pur_status = abap_true.
  lst_clientdatax-item_cat   = abap_true.
  lst_clientdatax-trans_grp  = abap_true.
  lst_clientdatax-pvalidfrom = abap_true.
  lst_clientdatax-net_weight = abap_true.
  lst_clientdatax-unit_of_wt = abap_true.
  lst_clientdatax-trans_grp  = abap_true.
  lst_clientdatax-extmatlgrp = abap_true.

*---Material Data at Plant Level
  lst_plantdata-plant      = fp_file_data-werks.   "Plant
  lst_plantdata-availcheck = fp_file_data-mtvfp.   "Availability Check
  lst_plantdata-loadinggrp = fp_file_data-ladgr.   "Loading Group
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = fp_file_data-prctr
    IMPORTING
      output = fp_file_data-prctr.

  lst_plantdata-profit_ctr  = fp_file_data-prctr.  "Profit Centre
  lst_plantdata-reorder_pt  = fp_file_data-minbe.  "Reorder Point
  lst_plantdata-max_stock   = fp_file_data-mabst.  "Maximum stock level
  lst_plantdata-pur_group   = fp_file_data-ekgrp.  "Purchasing Group
  lst_plantdata-mrp_type    = fp_file_data-dismm.  "MRP_TYPE
  lst_plantdata-mrp_ctrler  = fp_file_data-dispo.  "MRP Controller
  lst_plantdata-plnd_delry  = fp_file_data-plifz.  "Planned Delivery Time in Days
  lst_plantdata-proc_type   = fp_file_data-beskz.  "Procurement Type
  lst_plantdata-inhseprodt  = fp_file_data-dzeit.  "In-house production time
  lst_plantdata-lotsizekey  = fp_file_data-disls.  "Lot Size key
  lst_plantdata-prodprof    = fp_file_data-sfcpf.  "Production Scheduling Profile
  lst_plantdata-serno_prof  = fp_file_data-sernp.  "Serial Number Profile

  lst_plantdatax-plant       = fp_file_data-werks.
  lst_plantdatax-availcheck  = abap_true.
  lst_plantdatax-loadinggrp  = abap_true.
  lst_plantdatax-profit_ctr  = abap_true.
  lst_plantdatax-reorder_pt  = abap_true.
  lst_plantdatax-max_stock   = abap_true.
  lst_plantdatax-pur_group   = abap_true.
  lst_plantdatax-mrp_type    = abap_true.
  lst_plantdatax-mrp_ctrler  = abap_true.
  lst_plantdatax-plnd_delry  = abap_true.
  lst_plantdatax-proc_type   = abap_true.
  lst_plantdatax-inhseprodt  = abap_true.
  lst_plantdatax-lotsizekey  = abap_true.
  lst_plantdatax-prodprof    = abap_true.
  lst_plantdatax-serno_prof  = abap_true.

*----Valuation Data (Accounting Info)
  lst_valuationdata-val_class  = fp_file_data-bklas.    "Valuation Class
  lst_valuationdata-val_area   = fp_file_data-bukrs.    "Company Code
  lst_valuationdata-price_ctrl = fp_file_data-vprsv.    "Price Control
  lst_valuationdata-price_unit = fp_file_data-peinh.    "Price Unit
  lst_valuationdata-std_price  = fp_file_data-stprs.    "Standard Price
  lst_valuationdata-moving_pr  = fp_file_data-verpr.    "Moving Avg Price

  lst_valuationdatax-val_area   = fp_file_data-bukrs.
  lst_valuationdatax-val_class  = abap_true.
  lst_valuationdatax-price_ctrl = abap_true.
  lst_valuationdatax-price_unit = abap_true.
  lst_valuationdatax-std_price  = abap_true.
  lst_valuationdatax-moving_pr  = abap_true.

*----Sale Data
  lst_saledata-sales_org   = fp_file_data-vkorg.  "Sale Org
  lst_saledata-distr_chan  = fp_file_data-vtweg.  "Distribution Channel
  lst_saledata-delyg_plnt  = fp_file_data-dwerk.  "Delivering Plant
  lst_saledata-item_cat    = fp_file_data-mtpos.  "Item category group from material master
  CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
    EXPORTING
      input          = fp_file_data-vrkme
      language       = sy-langu
    IMPORTING
      output         = lv_meins
    EXCEPTIONS
      unit_not_found = 1
      OTHERS         = 2.
  IF lv_meins IS INITIAL.
    lv_meins = fp_file_data-vrkme.
  ENDIF.
  lst_saledata-sales_unit  = lv_meins.            "Sales unit
  lst_saledata-min_order   = fp_file_data-aumng.  "Minimum order quantity
  lst_saledata-matl_grp_4  = fp_file_data-mvgr4.  "Material Grp 4
  lst_saledata-matl_grp_2  = fp_file_data-mvgr2.  "Material Grp 2
  lst_saledata-comm_group  = fp_file_data-provg.  "Commission group

  lst_saledatax-sales_org  = fp_file_data-vkorg.
  lst_saledatax-distr_chan = fp_file_data-vtweg.
  lst_saledatax-delyg_plnt = abap_true.
  lst_saledatax-item_cat   = abap_true.
  lst_saledatax-sales_unit = abap_true.
  lst_saledatax-min_order  = abap_true.
  lst_saledatax-matl_grp_4 = abap_true.
  lst_saledatax-matl_grp_2 = abap_true.
  lst_saledatax-comm_group = abap_true.
*-----Material Description
  lst_mat_des-langu     = fp_file_data-langu. "Language
  lst_mat_des-matl_desc = fp_file_data-maktx. "Mat Description
  APPEND lst_mat_des TO li_mat_des.

*----Tax Info
  lst_taxclas-depcountry = lc_country.          "Country
  lst_taxclas-tax_type_1 = lc_tax_type.         "Tax category
  lst_taxclas-taxclass_1 = fp_file_data-taxkm. "Tax classification material
  APPEND lst_taxclas TO li_taxclas.

*---Unit of Measure Details
  lst_uom-alt_unit   = fp_file_data-meins.    "Alternative Unit of Measure for Stockkeeping Unit
  lst_uom-gross_wt   = fp_file_data-brgew.    "Gross Weight
  lst_uom-unit_of_wt = fp_file_data-gewei.    "Gross Units
  APPEND lst_uom TO li_uom.
  lst_uomx-alt_unit    = fp_file_data-meins.
  lst_uomx-gross_wt    = abap_true.
  lst_uomx-unit_of_wt  = abap_true.
  APPEND lst_uomx TO li_uomx.

*---Unit of Measure Details
  IF lv_meins IS NOT INITIAL.
    IF fp_file_data-meins NE lv_meins.
      lst_uom-alt_unit   = lv_meins.              "Alternative Unit of Measure for Stockkeeping Unit
      lst_uom-numerator  = fp_file_data-umrez.    "Numerator for conversion to base units of measure
      lst_uom-denominatr = fp_file_data-umren.    "Denominator  for Conversion to Base Units of Measure
      APPEND lst_uom TO li_uom.

      lst_uomx-alt_unit    = lv_meins.
      lst_uomx-numerator   = abap_true.
      lst_uomx-denominatr  = abap_true.
      APPEND lst_uomx TO li_uomx.
    ENDIF.
  ENDIF.
*-----Sale Text Info
  IF fp_file_data-text IS NOT INITIAL .
    lst_mat_text-applobject = lc_object.
    lst_mat_text-text_id    = lc_id.
    lst_mat_text-langu      = c_langu .
    CONCATENATE fp_file_data-matnr
                fp_file_data-vkorg
                fp_file_data-vtweg
                INTO lst_mat_text-text_name.
    lst_mat_text-text_line = fp_file_data-text+0(130).
    APPEND lst_mat_text TO li_mat_text.
    CLEAR lst_mat_text-text_line.
    IF fp_file_data-text+130(126) IS NOT INITIAL .
      lst_mat_text-text_line = fp_file_data-text+130(126).
      APPEND lst_mat_text TO li_mat_text.
      CLEAR lst_mat_text-text_line.
    ENDIF.
  ENDIF.
*---Creating the material master
  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata            = lst_header
      clientdata          = lst_clientdata
      clientdatax         = lst_clientdatax
      plantdata           = lst_plantdata
      plantdatax          = lst_plantdatax
      salesdata           = lst_saledata
      salesdatax          = lst_saledatax
      valuationdata       = lst_valuationdata
      valuationdatax      = lst_valuationdatax
    IMPORTING
      return              = lst_return
    TABLES
      materialdescription = li_mat_des
      unitsofmeasure      = li_uom
      unitsofmeasurex     = li_uomx
      materiallongtext    = li_mat_text
      taxclassifications  = li_taxclas
      returnmessages      = li_return.
  READ TABLE li_return INTO DATA(lst_return1) WITH KEY type = c_e.
  IF sy-subrc = 0.
*--creating error interal table
    CLEAR fp_file_data-matnr.
    fp_file_data-type    = lst_return1-type.
    fp_file_data-message = lst_return1-message.
    APPEND fp_file_data TO i_error_rec.
  ELSE.
    READ TABLE  li_return INTO lst_return1 WITH KEY type = c_s
                                                    number = '800'.
    IF sy-subrc = 0.
*--creating success interal table
      fp_file_data-type    = lst_return1-type.
      fp_file_data-message = lst_return1-message.
      APPEND fp_file_data TO i_sucess_rec.
      EXIT.
    ELSE.
      READ TABLE  li_return INTO lst_return1 WITH KEY type = c_s
                                                      number = '801'.
      IF sy-subrc = 0.
*--change success interal table
        fp_file_data-type    = lst_return1-type.
        fp_file_data-message = lst_return1-message.
        APPEND fp_file_data TO i_sucess_rec.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CLF_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clf_display_data .
  DATA: lr_events TYPE REF TO cl_salv_events_table.

  DATA: lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = ir_table
        CHANGING
          t_table      = i_file_data_clf.
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
      lr_column ?= lr_columns->get_column( 'IND_SECT' ).
      lr_column ?= lr_columns->get_column( 'MTART' ).
      lr_column ?= lr_columns->get_column( 'BISMT' ).
      lr_column ?= lr_columns->get_column( 'KLART' ).
      lr_column ?= lr_columns->get_column( 'CLASS' ).
      lr_column ?= lr_columns->get_column( 'CHARACT' ).
      lr_column ?= lr_columns->get_column( 'ATZHL' ).
      lr_column ?= lr_columns->get_column( 'ATWRT' ).
      lr_column ?= lr_columns->get_column( 'ATWTB' ).
      lr_column ?= lr_columns->get_column( 'MATNR' ).
      lr_column ?= lr_columns->get_column( 'TYPE' ).
      lr_column ?= lr_columns->get_column( 'MESSAGE' ).
      lr_column->set_short_text( 'Message' ).
      lr_column->set_medium_text( 'Message' ).
      lr_column->set_long_text( 'Message' ).
    ##NO_HANDLER    CATCH cx_salv_not_found.
  ENDTRY.
  IF sy-batch = space.
    lr_events = ir_table->get_event( ).
    CREATE OBJECT ir_events.
    SET HANDLER ir_events->on_user_command FOR lr_events.
    PERFORM f_set_top_of_page CHANGING ir_table.
  ENDIF.
  ir_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MATERIAL_CLF_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_material_clf_create .
  DATA:lv_sel TYPE string.

  IF sy-batch <> space.
    CONCATENATE 'Batch Job Triggered by'(010)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE c_s.
  ENDIF.

*  FREE:i_constants,st_atnam.
  LOOP AT i_file_temp_clf ASSIGNING FIELD-SYMBOL(<fs_file_data>).
    PERFORM f_create_material_clsf USING <fs_file_data>.
  ENDLOOP.

  IF sy-batch <> space.
    FREE:gv_success,gv_error,lv_sel.
    DESCRIBE TABLE i_error_rec_clf  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec_clf LINES gv_success .
    gv_total_proc = gv_error + gv_success.
    lv_sel = i_rows.
    CONCATENATE 'Total selected records to be processed: '(011) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(012) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE c_s.
    MESSAGE lv_error TYPE c_s.
  ENDIF.
  PERFORM f_clf_error_success_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_MATERIAL_CLSF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_FILE_DATA>  text
*----------------------------------------------------------------------*
FORM f_create_material_clsf  USING  lst_file_data TYPE ity_file_clf.
  DATA: li_allocvaluesnum  TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
        li_allocvaluescurr TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
        li_allocvalueschar TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
        li_return          TYPE STANDARD TABLE OF bapiret2.
  CONSTANTS: lc_object TYPE tabelle     VALUE 'MARA',
             lc_class  TYPE klassenart  VALUE '001'.

  IF lst_file_data-bismt IS NOT INITIAL.
    i_bismt = lst_file_data-bismt.
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY bismt = lst_file_data-bismt.
    IF sy-subrc <> 0.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_file_data-bismt
        IMPORTING
          output = lst_file_data-bismt.
      DATA(lv_flag_conv) = abap_true.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_file_data-bismt.
    ENDIF.

    lst_file_data-matnr = lst_mara-matnr.
    lst_file_data-matkl = lst_mara-matkl.

    IF lst_file_data-matnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_file_data-matnr
        IMPORTING
          output = lst_file_data-matnr.

      i_objectkey = lst_file_data-matnr.
      i_objecttab = lc_object.
      i_classnum  = lst_file_data-class.
*----Comparing the material group
      i_classtype = lc_class.
      i_keydate   = sy-datum.

      READ TABLE i_file_data_clf INTO DATA(lst_file_temp) WITH KEY bismt = i_bismt.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT i_file_data_clf INTO lst_file_temp FROM lv_tabix.
          IF lv_flag_conv = abap_true.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_file_temp-bismt
              IMPORTING
                output = lst_file_temp-bismt.
          ENDIF.
          IF lst_file_temp-bismt <> lst_file_data-bismt.
            EXIT.
          ELSE.
            st_allocvalueschar-charact    = lst_file_temp-charact.
            st_allocvalueschar-value_char = lst_file_temp-atwrt.
            IF lst_file_temp-charact IS NOT INITIAL.
              APPEND st_allocvalueschar TO i_allocvalueschar.
            ENDIF.
            CLEAR st_allocvalueschar.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF lst_mara-vpsta CA 'C'.
        CALL FUNCTION 'BAPI_OBJCL_CHANGE'
          EXPORTING
            objectkey          = i_objectkey
            objecttable        = i_objecttab
            classnum           = i_classnum
            classtype          = i_classtype
          TABLES
            allocvaluesnumnew  = i_allocvaluesnumnew
            allocvaluescharnew = i_allocvalueschar
            allocvaluescurrnew = i_allocvaluescurrnew
            return             = i_return.
      ELSE.
        CALL FUNCTION 'BAPI_OBJCL_CREATE'
          EXPORTING
            objectkeynew    = i_objectkey
            objecttablenew  = i_objecttab
            classnumnew     = i_classnum
            classtypenew    = i_classtype
          TABLES
            allocvalueschar = i_allocvalueschar
            return          = i_return.
      ENDIF.
      FREE:lv_flag_conv.
      IF i_return IS NOT INITIAL.
        READ TABLE i_return INTO DATA(lst_return) WITH KEY type = c_e.
        IF sy-subrc = 0.
          LOOP AT i_file_data_clf ASSIGNING FIELD-SYMBOL(<fs_file_temp>) WHERE bismt = i_bismt.
            <fs_file_temp>-type    = lst_return-type.
            <fs_file_temp>-message = lst_return-message.
            <fs_file_temp>-matkl =  lst_file_data-matkl.
            <fs_file_temp>-matnr = lst_file_data-matnr.
            lst_file_data = <fs_file_temp>.
            APPEND lst_file_data TO i_error_rec_clf.
            CLEAR:lst_file_temp .
          ENDLOOP.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
          READ TABLE i_return INTO lst_return WITH KEY type = c_s.
          IF sy-subrc = 0.
            LOOP AT i_file_data_clf ASSIGNING <fs_file_temp> WHERE bismt = i_bismt.
              <fs_file_temp>-type    = lst_return-type.
              <fs_file_temp>-message = lst_return-message.
              <fs_file_temp>-matnr   = lst_file_data-matnr.
              <fs_file_temp>-matkl =  lst_file_data-matkl.
              lst_file_data = <fs_file_temp>.
              APPEND lst_file_data TO i_sucess_rec_clf.
              CLEAR:lst_file_temp .
            ENDLOOP.
          ENDIF.
        ENDIF.
        FREE: i_objectkey,
              i_objecttab,
              i_classnum ,
              i_classtype,
              i_keydate,
              i_return,
              i_char_file_data,
              st_allocvalueschar,
              i_allocvalueschar.
      ENDIF.
    ELSE.
*---material number blank
      lst_file_data-type    = c_e.
      lst_file_data-message = 'Material No is blank'(079).
      APPEND lst_file_data TO i_error_rec_clf.
    ENDIF.
  ELSE.
*---old material number blank
    lst_file_data-type    = c_e.
    lst_file_data-message = 'Old Material is blank'(066).
    APPEND lst_file_data TO i_error_rec_clf.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CLF_ERROR_SUCCESS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clf_error_success_log .
  CONSTANTS:lc_success TYPE string VALUE 'MAT_UPD_SUCCESS_',
            lc_error   TYPE string VALUE 'MAT_UPD_ERROR_'.
  IF sy-batch = space.
    DESCRIBE TABLE i_error_rec_clf  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec_clf LINES gv_success .
    gv_total_proc = gv_error + gv_success.
  ENDIF.

  IF  i_sucess_rec_clf IS NOT INITIAL.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_prc '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing Sucess records to application layer
    CONCATENATE v_file_path  lc_success sy-datum sy-uzeit INTO DATA(lv_file).
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.
    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_clf_names.
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec_clf INTO DATA(lst_record).
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-bismt
                    lst_record-klart
                    lst_record-class
                    lst_record-charact
                    lst_record-atzhl
                    lst_record-atwrt
                    lst_record-atwtb
                    lst_record-type
                    lst_record-message
                    INTO DATA(lv_value1)
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file.
        CLEAR :lst_record.
      ENDLOOP.
      MESSAGE i258(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.
  IF i_error_rec_clf IS  NOT INITIAL.
    FREE:lv_value1.
*--get the application layer path dynamically
    PERFORM f_get_file_path USING v_path_err '*'.
    REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*--writing Sucess records to application layer
    CONCATENATE v_file_path  lc_error sy-datum sy-uzeit INTO DATA(lv_file_e).
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file_e.
    OPEN DATASET lv_file_e FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      PERFORM f_head_clf_names .
      TRANSFER i_head TO lv_file_e.
      CLEAR lst_record.
      LOOP AT i_error_rec_clf  INTO lst_record.
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-bismt
                    lst_record-klart
                    lst_record-class
                    lst_record-charact
                    lst_record-atzhl
                    lst_record-atwrt
                    lst_record-atwtb
                    lst_record-type
                    lst_record-message
                    INTO lv_value1
       SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_value1  TO lv_file_e.
        CLEAR :lst_record.
      ENDLOOP.
      MESSAGE i257(zqtc_r2) WITH lv_file_e.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file_e.
    ENDIF.
    CLOSE DATASET lv_file.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE_CLF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_FILE_DATA_CLF  text
*----------------------------------------------------------------------*
FORM f_get_data_from_file_clf  TABLES fp_file_data.
  DATA:li_type       TYPE truxs_t_text_data,
       lst_file_data TYPE ity_file_clf.
  FREE:fp_file_data.
  IF sy-batch = space.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = fp_file_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.
    FREE: fp_file_data,lst_file_data,i_rows.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO lst_file_data.
        IF sy-subrc = 0.
          APPEND lst_file_data TO fp_file_data.
          CLEAR lst_file_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_file.
    ENDIF.
  ENDIF.
  IF fp_file_data[] IS NOT INITIAL.
    FREE:i_file_temp_clf,i_mara,i_rows.
    i_file_temp_clf[] =  fp_file_data[].
    SORT i_file_temp_clf BY bismt klart class.
    DELETE ADJACENT DUPLICATES FROM i_file_temp_clf COMPARING bismt klart class.
    DELETE i_file_temp_clf WHERE klart = ''.
    IF i_file_temp_clf IS NOT INITIAL.
      SELECT matnr
             vpsta
             mtart
             bismt
             matkl
        FROM mara
        INTO TABLE i_mara
        FOR ALL ENTRIES IN i_file_temp_clf
        WHERE bismt = i_file_temp_clf-bismt.
      IF sy-subrc = 0.
        SORT i_mara BY bismt.
      ENDIF.
      LOOP AT i_file_temp_clf ASSIGNING FIELD-SYMBOL(<fs_file_temp>).
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_file_temp>-bismt
          IMPORTING
            output = <fs_file_temp>-bismt.
      ENDLOOP.
      SELECT matnr
             vpsta
             mtart
             bismt
             matkl
        FROM mara
        APPENDING TABLE i_mara
        FOR ALL ENTRIES IN i_file_temp_clf
        WHERE matnr = i_file_temp_clf-bismt.

      LOOP AT i_file_temp_clf ASSIGNING <fs_file_temp>.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <fs_file_temp>-bismt
          IMPORTING
            output = <fs_file_temp>-bismt.
      ENDLOOP.
      LOOP AT i_file_data_clf ASSIGNING <fs_file_temp>.
        READ TABLE i_file_temp_clf INTO DATA(lst_file_temp) WITH KEY bismt = <fs_file_temp>-bismt.
        IF sy-subrc = 0.
          <fs_file_temp>-bismt = lst_file_temp-bismt.
          DATA(lv_bismt) = lst_file_temp-bismt.
        ELSE.
          <fs_file_temp>-bismt = lv_bismt.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  i_rows = lines( i_file_temp_clf ) .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HEAD_CLF_NAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_head_clf_names .
  FREE:i_head.
  CONCATENATE 'Material'(015)
              'Industry Sector'(002)
              'Material Type'(016)
              'Old Material'(022)
              'Class Type'(073)
              'Class'(074)
              'Characterstics'(075)
              'Sequence'(076)
              'Char. Value'(077)
              'Char. Value Des.'(078)
              'Msg Type'(033)
              'Message'(035)
      INTO i_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
ENDFORM.
