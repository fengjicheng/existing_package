*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_CLASSIFI_UPLD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MAT_CLASSIFI_MASS_UPLD
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MAT_CLASSIFI_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Classication Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/20/2019
*& OBJECT ID:             C110.2
*& TRANSPORT NUMBER(S):   ED2K916178
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
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file .
  DATA:li_type       TYPE truxs_t_text_data,
       lst_file_data TYPE ity_file.
  FREE:i_file_data.
  IF sy-batch = space.
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

  ELSE.
    FREE: i_file_data,lst_file_data,i_rows.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO lst_file_data.
        IF sy-subrc = 0.
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
    FREE:i_file_temp,i_mara,i_rows.
    i_file_temp[] =  i_file_data[].
    SORT i_file_temp BY bismt klart class.
    DELETE ADJACENT DUPLICATES FROM i_file_temp COMPARING bismt klart class.
    DELETE i_file_temp WHERE klart = ''.
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
      LOOP AT i_file_temp ASSIGNING FIELD-SYMBOL(<fs_file_temp>).
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
        FOR ALL ENTRIES IN i_file_temp
        WHERE matnr = i_file_temp-bismt.

      LOOP AT i_file_temp ASSIGNING <fs_file_temp>.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <fs_file_temp>-bismt
          IMPORTING
            output = <fs_file_temp>-bismt.
      ENDLOOP.
    ENDIF.
  ENDIF.
*---check the constant table
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = c_devid  "Development ID
    IMPORTING
      ex_constants = i_constants. "Constant Values

  IF  i_constants IS NOT INITIAL.
    LOOP AT i_constants INTO DATA(lst_constants).
      IF lst_constants-param1 = 'ATNAM'.
        CLEAR st_atnam.
        st_atnam-sign   = 'I'.
        st_atnam-option = 'EQ'.
        st_atnam-low    = lst_constants-low.
        APPEND st_atnam TO i_atnam.
      ENDIF.
    ENDLOOP.
  ENDIF.
  i_rows = lines( i_file_temp ) .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
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
FORM f_set_top_of_page  CHANGING co_alv TYPE REF TO cl_salv_table.

  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string.                              "#EC NEEDED

  lo_head = 'Material Classification Create Report'(002).
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

  lo_label = lo_flow->create_label( text = 'Total Records:'(003)
                                    tooltip = 'Total Records:'(003) ).

  lo_text = lo_flow->create_text( text = i_rows
                                  tooltip = i_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '(004)
                                    tooltip = 'Processed : '(004) ).

  lo_text = lo_flow->create_text( text = gv_total_proc
                                  tooltip = gv_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'(005)
                                    tooltip = 'Success:'(005) ).

  lo_text = lo_flow->create_text( text = gv_success
                                  tooltip = gv_success ).

  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'(006)
                                    tooltip =  'Errors:'(006) ).

  lo_text = lo_flow->create_text( text = gv_error
                                  tooltip = gv_error ).
*--Set Top of List


  co_alv->set_top_of_list( lo_grid ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_SALV_FUNCTION  text
*----------------------------------------------------------------------*
FORM f_handle_user_command  USING  i_ucomm TYPE salv_de_function..
  DATA: li_rows   TYPE salv_t_row.
  DATA: lst_const TYPE zcaconstant.
  DATA: lst_columns TYPE REF TO cl_salv_columns.

  FREE:i_bismt.
  LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fs_file_data>) .
    IF <fs_file_data>  IS  ASSIGNED.
      IF <fs_file_data>-bismt IS NOT INITIAL.
        i_bismt = <fs_file_data>-bismt.
      ELSE.
        <fs_file_data>-bismt =  i_bismt.
      ENDIF.
    ENDIF.
  ENDLOOP.
  FREE:i_bismt.
  FREE: i_const.
  SELECT *
     FROM zcaconstant
     INTO TABLE i_const
     WHERE devid = c_devid
    AND activate = c_x.
  IF sy-subrc EQ 0.
    SORT i_const BY param1.
  ENDIF.
  DESCRIBE TABLE i_file_temp LINES DATA(lv_no_of_records).
  CLEAR lst_const .
  READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param1.

  IF lv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.
    IF lv_no_of_records > lst_const-low.
*--get the application layer path dynamically
      PERFORM f_get_file_path USING v_path_in '*'.
      REPLACE ALL OCCURRENCES OF '*' IN v_file_path WITH ''.
*---File data submitted to background and created the batch job in SM37
      PERFORM f_submit_program_in_background.
    ELSE.
      LOOP AT i_file_temp ASSIGNING <fs_file_data>.
        PERFORM f_create_material_clsf USING <fs_file_data>.
      ENDLOOP.
      PERFORM f_error_success_log.
      lst_columns = ir_table->get_columns( ).
      lst_columns->set_optimize( c_true ).
      PERFORM f_set_top_of_page CHANGING ir_table.
      ir_table->refresh( ).
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
FORM f_create_material_clsf  USING  lst_file_data TYPE ity_file.
  DATA: li_allocvaluesnum  TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
        li_allocvaluescurr TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
        li_allocvalueschar TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
        li_return          TYPE STANDARD TABLE OF bapiret2,
        lv_class_verf      TYPE char18.
  CONSTANTS: lc_object TYPE tabelle     VALUE 'MARA',
             lc_class  TYPE klassenart  VALUE '001',
             lc_parent TYPE char18      VALUE 'PARENT_COURSE',
             lc_child  TYPE char18      VALUE 'CHILD_COURSE',
             lc_acp    TYPE matkl       VALUE 'ACP',
             lc_acc    TYPE matkl       VALUE 'ACC'.
  CLEAR:lv_class_verf.
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
    IF lst_mara-matkl = lc_acp.
      lv_class_verf = lc_parent.
    ELSEIF lst_mara-matkl = lc_acc.
      lv_class_verf = lc_child.
    ENDIF.
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
      IF lst_file_data-class EQ lv_class_verf.
        i_classtype = lc_class.
        i_keydate   = sy-datum.

        READ TABLE i_file_data INTO DATA(lst_file_temp) WITH KEY bismt = i_bismt.
        IF sy-subrc = 0.
          DATA(lv_tabix) = sy-tabix.
          LOOP AT i_file_data INTO lst_file_temp FROM lv_tabix.
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
              IF i_atnam IS NOT INITIAL .
                IF lst_file_temp-charact IN i_atnam.
                  st_allocvalueschar-charact   = lst_file_temp-charact.
                  SELECT SINGLE matnr FROM mara INTO @DATA(lv_matnr) WHERE bismt = @lst_file_temp-atwrt.
                  IF sy-subrc <> 0.
                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                      EXPORTING
                        input  = lst_file_temp-atwrt
                      IMPORTING
                        output = lst_file_temp-atwrt.
                    SELECT SINGLE matnr FROM mara INTO lv_matnr WHERE matnr = lst_file_temp-atwrt+12(18).
                  ENDIF.
                  st_allocvalueschar-value_char = lv_matnr.
                  IF lst_file_temp-charact IS NOT INITIAL.
                    APPEND st_allocvalueschar TO i_allocvalueschar.
                  ENDIF.
                  CLEAR st_allocvalueschar.
                ELSE.
                  st_allocvalueschar-charact    = lst_file_temp-charact.
                  st_allocvalueschar-value_char = lst_file_temp-atwrt.
                  IF lst_file_temp-charact IS NOT INITIAL.
                    APPEND st_allocvalueschar TO i_allocvalueschar.
                  ENDIF.
                  CLEAR st_allocvalueschar.
                ENDIF.
              ELSE.
                st_allocvalueschar-charact    = lst_file_temp-charact.
                st_allocvalueschar-value_char = lst_file_temp-atwrt.
                IF lst_file_temp-charact IS NOT INITIAL.
                  APPEND st_allocvalueschar TO i_allocvalueschar.
                ENDIF.
                CLEAR st_allocvalueschar.
              ENDIF.
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
            LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fs_file_temp>) WHERE bismt = i_bismt.
              <fs_file_temp>-type    = lst_return-type.
              <fs_file_temp>-message = lst_return-message.
              <fs_file_temp>-matnr = lst_file_data-matnr.
              lst_file_data = <fs_file_temp>.
              APPEND lst_file_data TO i_error_rec.
              CLEAR:lst_file_temp .
            ENDLOOP.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
            READ TABLE i_return INTO lst_return WITH KEY type = c_s.
            IF sy-subrc = 0.
              LOOP AT i_file_data ASSIGNING <fs_file_temp> WHERE bismt = i_bismt.
                <fs_file_temp>-type    = lst_return-type.
                <fs_file_temp>-message = lst_return-message.
                <fs_file_temp>-matnr   = lst_file_data-matnr.
                lst_file_data = <fs_file_temp>.
                APPEND lst_file_data TO i_sucess_rec.
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
        LOOP AT i_file_data ASSIGNING <fs_file_temp> WHERE bismt = i_bismt.
          <fs_file_temp>-type    = c_e.
          CONCATENATE 'Material'(012)
                      lst_file_data-matnr
                      'class is belongs to '(026)
                      lv_class_verf
                      INTO <fs_file_temp>-message SEPARATED BY space.
          <fs_file_temp>-matnr = lst_file_data-matnr.
          lst_file_data = <fs_file_temp>.
          APPEND lst_file_data TO i_error_rec.
          CLEAR:lst_file_temp .
        ENDLOOP.
      ENDIF.
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
    CONCATENATE 'Batch Job Triggered by'(007)
                 sy-uname
                 sy-datum
                 sy-uzeit INTO DATA(lv_bjblog) SEPARATED BY space.
    MESSAGE lv_bjblog TYPE c_s.
  ENDIF.

  FREE:i_constants,st_atnam.
  LOOP AT i_file_temp ASSIGNING FIELD-SYMBOL(<fs_file_data>).
    PERFORM f_create_material_clsf USING <fs_file_data>.
  ENDLOOP.

  IF sy-batch <> space.
    FREE:gv_success,gv_error,lv_sel.
    DESCRIBE TABLE i_error_rec  LINES gv_error.
    DESCRIBE TABLE i_sucess_rec LINES gv_success .
    gv_total_proc = gv_error + gv_success.
    lv_sel = i_rows.
    CONCATENATE 'Total selected records to be processed: '(008) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(009) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(010) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE c_s.
    MESSAGE lv_error TYPE c_s.
  ENDIF.
  PERFORM f_error_success_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ERROR_SUCCESS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background .
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,       "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.          "Selection table parameter

  CONSTANTS: lc_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             lc_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             lc_option_eq   TYPE tvarv_opti VALUE 'EQ', "ABAP: Selection option (EQ/BT/CP/...).
             lc_p_file      TYPE rsscr_name VALUE 'P_FILE'.
  DATA: lv_file TYPE string,
        lv_bjob TYPE char1.

  CONCATENATE v_file_path 'Mat_Clasf'(011) sy-datum sy-uzeit INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_file_data INTO DATA(lst_file_data).
      TRANSFER lst_file_data TO lv_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.


  CLEAR:lst_file_data,lst_params.
  lst_params-selname = lc_p_file.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = lc_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = lc_sign_i.       "I-in
  lst_params-option  = lc_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.        "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CLEAR:lv_jobname.
  CONCATENATE 'ZQTCR_MAT_CLASSIF_' sy-datum sy-uzeit INTO lv_jobname.
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
      SUBMIT zqtcr_mat_classifi_mass_upld WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_mat_classifi_mass_upld WITH SELECTION-TABLE li_params.
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
  CONSTANTS:lc_success TYPE string VALUE 'MAT_CLASS_UPD_SUCCESS_',
            lc_error   TYPE string VALUE 'MAT_CLASS_UPD_ERROR_'.

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
    CONCATENATE v_file_path  lc_success sy-datum sy-uzeit INTO DATA(lv_file).
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
  IF i_error_rec IS  NOT INITIAL.
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
      PERFORM f_head_names .
      TRANSFER i_head TO lv_file_e.
      CLEAR lst_record.
      LOOP AT i_error_rec  INTO lst_record.
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
*&      Form  F_HEAD_NAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_HEAD  text
*----------------------------------------------------------------------*
FORM f_head_names.
  CONCATENATE 'Material'(012)
              'Industry Sector'(013)
              'Material Type'(014)
              'Old Material'(015)
              'Class Type'(016)
              'Class'(017)
              'Characterstics'(018)
              'Sequence'(019)
              'Char. Value'(020)
              'Char. Value Des.'(021)
              'Msg Type'(022)
              'Message'(023)
      INTO i_head SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_0609   text
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
