CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM f_handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
  "on_single_click
ENDCLASS.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
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
*      -->P_I_FILE_DATA  text
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
         v_rows.
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
  v_rows = lines( fp_file_data[] ).
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

  IF sy-batch = space.        "To be updated.
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
      lr_column ?= lr_columns->get_column( 'VVIS_LIGHTS' ).
      lr_column ?= lr_columns->get_column( 'MATNR' ).
      lr_column ?= lr_columns->get_column( 'IND_SECT' ).
      lr_column ?= lr_columns->get_column( 'MTART' ).
      lr_column ?= lr_columns->get_column( 'BUKRS' ).
      lr_column ?= lr_columns->get_column( 'WERKS' ).
      lr_column ?= lr_columns->get_column( 'LGORT' ).
      lr_column ?= lr_columns->get_column( 'VKORG' ).
      lr_column ?= lr_columns->get_column( 'VTWEG' ).
      lr_column ?= lr_columns->get_column( 'IDENTCODE' ).
      lr_column ?= lr_columns->get_column( 'XMAINIDCODE' ).
      lr_column ?= lr_columns->get_column( 'MAKTX' ).
      lr_column ?= lr_columns->get_column( 'ISMARTIST' ).
      lr_column ?= lr_columns->get_column( 'ISMTITLE' ).
      lr_column ?= lr_columns->get_column( 'ISMSUBTITLE1' ).
      lr_column ?= lr_columns->get_column( 'ISMSUBTITLE2' ).
      lr_column ?= lr_columns->get_column( 'TDNAME' ).
      lr_column ?= lr_columns->get_column( 'LANGU' ).
      lr_column->set_short_text( 'Lang' ).
      lr_column->set_medium_text( 'Language' ).
      lr_column->set_long_text( 'Language' ).
      lr_column ?= lr_columns->get_column( 'ISMPUBLTYPE' ).
      lr_column ?= lr_columns->get_column( 'ISMMEDIATYPE' ).
      lr_column ?= lr_columns->get_column( 'ISMPUBLDATE' ).
      lr_column ?= lr_columns->get_column( 'MSTAE' ).
      lr_column ?= lr_columns->get_column( 'ISMCOPYNR' ).
      lr_column ?= lr_columns->get_column( 'BRGEW' ).
      lr_column->set_short_text( 'Gross Wt' ).
      lr_column->set_medium_text( 'Gross Wt' ).
      lr_column->set_long_text( 'Gross Weight' ).
      lr_column ?= lr_columns->get_column( 'GEWEI' ).
      lr_column->set_short_text( 'Wt. Unit' ).
      lr_column->set_medium_text( 'Wt. Unit' ).
      lr_column->set_long_text( 'Weight Unit' ).
      lr_column ?= lr_columns->get_column( 'EAN11' ).
      lr_column ?= lr_columns->get_column( 'ISMIMPRINT' ).
      lr_column ?= lr_columns->get_column( 'BISMT' ).
      lr_column ?= lr_columns->get_column( 'MATKL' ).
      lr_column ?= lr_columns->get_column( 'MEINS' ).
      lr_column->set_short_text( 'Units' ).
      lr_column->set_medium_text( 'Units' ).
      lr_column->set_long_text( 'Units' ).
      lr_column ?= lr_columns->get_column( 'SPART' ).
      lr_column ?= lr_columns->get_column( 'ISMDESIGN' ).
      lr_column ?= lr_columns->get_column( 'ISMNUMTYP1' ).
      lr_column ?= lr_columns->get_column( 'ISMNUMTYP2' ).
      lr_column ?= lr_columns->get_column( 'ISMEXTENT' ).
      lr_column ?= lr_columns->get_column( 'VMSTE' ).
      lr_column ?= lr_columns->get_column( 'ALAND' ).
      lr_column ?= lr_columns->get_column( 'TATYP' ).
      lr_column ?= lr_columns->get_column( 'DWERK' ).
      lr_column ?= lr_columns->get_column( 'TAXKM' ).
      lr_column->set_short_text( 'Tax clas.' ).
      lr_column->set_medium_text( 'Tax classification' ).
      lr_column->set_long_text( 'Tax classification' ).
      lr_column ?= lr_columns->get_column( 'KONDM' ).
      lr_column ?= lr_columns->get_column( 'MTPOS' ).
      lr_column ?= lr_columns->get_column( 'MVGR1' ).
      lr_column ?= lr_columns->get_column( 'MVGR4' ).
      lr_column ?= lr_columns->get_column( 'MTVFP' ).
      lr_column ?= lr_columns->get_column( 'TRAGR' ).
      lr_column ?= lr_columns->get_column( 'LADGR' ).
      lr_column ?= lr_columns->get_column( 'PRCTR' ).
      lr_column ?= lr_columns->get_column( 'HERKL' ).
      lr_column ?= lr_columns->get_column( 'DISMM' ).
      lr_column ?= lr_columns->get_column( 'BESKZ' ).
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
      lr_column ?= lr_columns->get_column( 'DOCNUM' ).
*      lr_column ?= lr_columns->get_column( 'VVIS_LIGHTS' ).
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

*    PERFORM f_handle_user_command USING e_salv_function.

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
    lo_head = 'QTC - IS-Media Products Create/Change Report'(003).
  ELSEIF r_clf IS NOT INITIAL.
    lo_head = 'QTC - IS-Media Products Classification Mass Report'(081).
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

  lo_grid1 = lo_grid->create_grid( row = 2
                                  column = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row = 2
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Total Records:'(004)
                                    tooltip = 'Total Records:'(004) ).

  lo_text = lo_flow->create_text( text = v_rows
                                  tooltip = v_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '(006)
                                    tooltip = 'Processed : '(006) ).

  lo_text = lo_flow->create_text( text = v_total_proc
                                  tooltip = v_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'(007)
                                    tooltip = 'Success:'(007) ).

  lo_text = lo_flow->create_text( text = v_success
                                  tooltip = v_success ).

  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'(008)
                                    tooltip =  'Errors:'(008) ).

  lo_text = lo_flow->create_text( text = v_error
                                  tooltip = v_error ).
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
FORM f_handle_user_command USING  fp_ucomm TYPE salv_de_function.
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
*        ELSEIF r_clf IS NOT INITIAL.
*          LOOP AT i_file_temp_clf ASSIGNING FIELD-SYMBOL(<lfs_file_data_clf>).
*            PERFORM f_create_material_clsf USING <lfs_file_data_clf>.
*          ENDLOOP.
*          PERFORM f_clf_error_success_log.
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
*      -->P_<LFS_FILE_DATA>  text
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
*&      Form  F_ERROR_SUCCESS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec INTO DATA(lst_record).
        CONCATENATE lst_record-matnr
                    lst_record-ind_sect
                    lst_record-mtart
                    lst_record-bukrs
                    lst_record-werks
                    lst_record-lgort
                    lst_record-vkorg
                    lst_record-vtweg
                    lst_record-identcode
                    lst_record-xmainidcode
                    lst_record-maktx
                    lst_record-ismartist
                    lst_record-ismtitle
                    lst_record-ismsubtitle1
                    lst_record-ismsubtitle2
                    lst_record-tdname
                    lst_record-langu
                    lst_record-ismpubltype
                    lst_record-ismmediatype
                    lst_record-ismpubldate
                    lst_record-mstae
                    lst_record-ismcopynr
                    lst_record-brgew
                    lst_record-gewei
                    lst_record-ean11
                    lst_record-ismimprint
                    lst_record-bismt
                    lst_record-matkl
                    lst_record-meins
                    lst_record-spart
                    lst_record-ismdesign
                    lst_record-ismnumtyp1
                    lst_record-ismnumtyp2
*                    lst_record-ismextent
                    lst_record-vmsta
                    lst_record-aland
                    lst_record-tatyp
                    lst_record-dwerk
                    lst_record-taxkm
                    lst_record-kondm
                    lst_record-mtpos
                    lst_record-mvgr1
                    lst_record-mvgr4
                    lst_record-mtvfp
                    lst_record-tragr
                    lst_record-ladgr
                    lst_record-prctr
*                    lst_record-archy Lev
                    lst_record-herkl
                    lst_record-dismm
                    lst_record-beskz
                    lst_record-bklas
                    lst_record-vprsv
                    lst_record-peinh
                    lst_record-stprs
                    lst_record-verpr
                    lst_record-docnum
*                    lst_record-fin_message_alv
                    lst_record-vvis_lights
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
                    lst_record-lgort
                    lst_record-vkorg
                    lst_record-vtweg
                    lst_record-identcode
                    lst_record-xmainidcode
                    lst_record-maktx
                    lst_record-ismartist
                    lst_record-ismtitle
                    lst_record-ismsubtitle1
                    lst_record-ismsubtitle2
                    lst_record-tdname
                    lst_record-langu
                    lst_record-ismpubltype
                    lst_record-ismmediatype
                    lst_record-ismpubldate
                    lst_record-mstae
                    lst_record-ismcopynr
                    lst_record-brgew
                    lst_record-gewei
                    lst_record-ean11
                    lst_record-ismimprint
                    lst_record-bismt
                    lst_record-matkl
                    lst_record-meins
                    lst_record-spart
                    lst_record-ismdesign
                    lst_record-ismnumtyp1
                    lst_record-ismnumtyp2
*                    lst_record-ismextent
                    lst_record-vmsta
                    lst_record-aland
                    lst_record-tatyp
                    lst_record-dwerk
                    lst_record-taxkm
                    lst_record-kondm
                    lst_record-mtpos
                    lst_record-mvgr1
                    lst_record-mvgr4
                    lst_record-mtvfp
                    lst_record-tragr
                    lst_record-ladgr
                    lst_record-prctr
*                    lst_record-archy Lev
                    lst_record-herkl
                    lst_record-dismm
                    lst_record-beskz
                    lst_record-bklas
                    lst_record-vprsv
                    lst_record-peinh
                    lst_record-stprs
                    lst_record-verpr
                    lst_record-docnum
*                    lst_record-fin_message_alv
                    lst_record-vvis_lights
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
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_1077   text
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
*&      Form  F_SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
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
    CONCATENATE v_file_path 'IS_Media_QTC_'(014) sy-datum sy-uzeit INTO lv_file.
  ELSEIF r_clf IS NOT INITIAL.
    CONCATENATE v_file_path 'Mat_Clsf_QTC_'(080) sy-datum sy-uzeit INTO lv_file.
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
  CONCATENATE 'ZQTCR_QTC_IS_MED_CR_' sy-datum sy-uzeit INTO lv_jobname.
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
      SUBMIT zqtcr_is_media_c117 WITH SELECTION-TABLE li_params
                      VIA JOB lv_jobname NUMBER lv_number "Job number
                      AND RETURN.
    ELSE.
      SUBMIT zqtcr_is_media_c117 WITH SELECTION-TABLE li_params.
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
*&---------------------------------------------------------------------*
*&      Form  F_HEAD_NAMES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
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
*&      Form  F_MATERIAL_CREATE_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_FILE_DATA  text
*----------------------------------------------------------------------*
FORM f_material_create_new  USING fp_file_data.

* Process records from File
  PERFORM f_process_file_records USING  "<i_file_datas>
                                        "li_fld_list.
                                        fp_file_data.
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
    FREE:v_success,
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
*&      Form  F_PROCESS_FILE_RECORDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<I_file_dataS>  text
*      -->P_LI_FLD_LIST  text
*----------------------------------------------------------------------*
FORM f_process_file_records  USING  "fp_file_data TYPE ANY TABLE
                                    "fp_li_fld_list TYPE ddfields.
                                    fp_file_data.

  DATA: lr_key_fields           TYPE REF TO data, "  class
        lv_index_st             TYPE i,           " Index_st of type Integers
        lv_index_en             TYPE i,           " Index_en of type Integers
        lv_segnum               TYPE edi_segnum,  " Number of SAP segment
        lv_hlevel               TYPE edi_hlevel,  " Hierarchy level
*        lst_key_fld_err         TYPE ty_status,   " Key Field Error
        li_idoc_data            TYPE edidd_tt,
        lv_lines                TYPE i,           " Lines of type Integers
        lv_lst_key_field        TYPE fieldname,   " Field Name
        lst_seg_e1maram         TYPE e1maram,
        lst_seg_e1idcdassignism TYPE e1idcdassignism,
        lst_seg_e1maraism       TYPE e1maraism,
        lst_seg_e1maktm         TYPE e1maktm,
        lst_seg_e1mtxhm         TYPE e1mtxhm,
        lst_seg_e1mvkem         TYPE e1mvkem,
        lst_seg_e1marcm         TYPE e1marcm,
        lst_seg_e1mardm         TYPE e1mardm,
        lst_seg_e1mlanm         TYPE e1mlanm,
        lst_seg_e1mbewm         TYPE e1mbewm,
        v_err_flag              TYPE boolean.

*  FIELD-SYMBOLS <i_cond_rcs> TYPE STANDARD TABLE.

  lv_segnum = 0.
  lv_hlevel = 0.

  LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<lst_file_data>).
    lv_index_st = lv_index_en = sy-tabix.
    CLEAR:  li_idoc_data.

*Pre validation
    CLEAR v_err_flag.
    PERFORM f_pre_validations CHANGING <lst_file_data>
                                       v_err_flag.
    IF v_err_flag IS NOT INITIAL.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1maram.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>).
    <lst_idoc_data>-segnam = 'E1MARAM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1maram.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1idcdassignism.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1IDCDASSIGNISM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1idcdassignism.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1maraism.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MARAISM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1maraism.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1maktm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MAKTM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1maktm.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1mtxhm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MTXHM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1mtxhm.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1mvkem.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MVKEM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1mvkem.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1marcm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MARCM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1marcm.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1mardm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MARDM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1mardm.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1mlanm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MLANM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1mlanm.
    UNASSIGN : <lst_idoc_data>.

    MOVE-CORRESPONDING <lst_file_data> TO lst_seg_e1mbewm.
    APPEND INITIAL LINE TO li_idoc_data ASSIGNING <lst_idoc_data>.
    <lst_idoc_data>-segnam = 'E1MBEWM'.
    lv_segnum = lv_segnum + 1.
    lv_hlevel = lv_hlevel + 1.
    <lst_idoc_data>-segnum = lv_segnum.
    <lst_idoc_data>-hlevel = lv_hlevel.
    <lst_idoc_data>-sdata =  lst_seg_e1mbewm.
    UNASSIGN : <lst_idoc_data>.

*    LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fst_cond_rcs>).
*      APPEND <fst_cond_rcs> TO <i_cond_rcs>.
*    ENDLOOP.

    PERFORM f_create_save_idoc  USING li_idoc_data
                                      lv_index_st
                                      lv_index_en
                              CHANGING i_file_data.
*                              CHANGING <i_cond_rcs>.


  ENDLOOP. " LOOP AT fp_file_data ASSIGNING FIELD-SYMBOL(<lst_file_data>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PRE_VALIDATIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_<LFS_FILE_DATA>  text
*      <--P_V_ERR_FLAG  text
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SAVE_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_IDOC_DATA  text
*      -->P_LV_INDEX_ST  text
*      -->P_LV_INDEX_EN  text
*      <--P_FP_FILE_DATA  text
*----------------------------------------------------------------------*
FORM f_create_save_idoc  USING    fp_li_idoc_data TYPE edidd_tt
                                  fp_lv_index_st  TYPE i               " Lv_index_st of type Integers
                                  fp_lv_index_en  TYPE i               " Lv_index_en of type Integers
                      CHANGING fp_file_data.                        " IDoc number

  TYPES : BEGIN OF lty_edids,
            docnum TYPE edi_docnum,               " IDoc number
            logdat TYPE edi_logdat,               " Date of status information
            logtim TYPE edi_logtim,               " Time of status information
            countr TYPE edi_countr,               " IDoc status counter
            status TYPE edi_status,               " Status of IDoc
            stapa1 TYPE	edi_stapa1,
            stapa2 TYPE	edi_stapa2,
            stapa3 TYPE edi_stapa3,               " Parameter 3
            stapa4 TYPE	edi_stapa4,
            stamid TYPE	edi_stamid,
            stamno TYPE	edi_stamno,
          END OF lty_edids.

  DATA: lst_edi_sttngs TYPE edi_glo,    "Global IDoc Administration Settings
        lst_status     TYPE ty_status,
        lst_ediadmin   TYPE swhactor,   "Rule Resolution Result
        lst_ib_process TYPE tede2,      " EDI process types (inbound)
        lv_sybrc       TYPE syst_subrc. " ABAP System Field: Return Code of ABAP Statements

  DATA : li_idoc_contrl TYPE edidc_tt,
         li_edids       TYPE STANDARD TABLE OF lty_edids INITIAL SIZE 0.

  CONSTANTS : lc_51        TYPE edi_status VALUE '51',   " Status of IDoc
              lc_53        TYPE edi_status VALUE '53',   " Status of IDoc
              lc_msgno_114 TYPE symsgno    VALUE '114'.     " Message Type

* Control Record For Inbound IDOC
  PERFORM f_control_data.

* Find out whether ALE is existing in the system
  CALL FUNCTION 'IDOC_READ_GLOBAL'
    IMPORTING
      global_data    = lst_edi_sttngs "Global IDoc Administration Settings
    EXCEPTIONS
      internal_error = 1
      OTHERS         = 2.
  IF sy-subrc EQ 0.
    lst_ediadmin = lst_edi_sttngs-no_appl. "Rule Resolution Result
  ENDIF. " IF sy-subrc EQ 0

* Create and Save IDOC in DB
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error      = abap_true       "Flag: Error handling yes/no
      pi_return_data_flag     = abap_false      "Return of initialized data records
    IMPORTING
      pe_idoc_number          = st_edidc-docnum "IDOC Number
      pe_state_of_processing  = lv_sybrc
      pe_inbound_process_data = lst_ib_process  "EDI process types (inbound)
    TABLES
      t_data_records          = fp_li_idoc_data "IDOC Data Records
    CHANGING
      pc_control_record       = st_edidc        "IDOC Control Record
    EXCEPTIONS
      idoc_not_saved          = 1
      OTHERS                  = 2.
  IF sy-subrc EQ 0.
    COMMIT WORK.
    SET PARAMETER ID 'DCN' FIELD st_edidc-docnum. "IDOC Number
    APPEND st_edidc TO li_idoc_contrl. "IDOC Control Record

*       Start inbound processing for inbound IDoc
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_ib_process  "EDI process types (inbound)
        pi_org_unit                   = lst_ediadmin    "Rule Resolution Result
      TABLES
        t_control_records             = li_idoc_contrl  "IDOC Control Records
        t_data_records                = fp_li_idoc_data "IDOC Data Records
      EXCEPTIONS
        invalid_document_number       = 1
        error_before_call_application = 2
        inbound_process_not_possible  = 3
        old_wf_start_failed           = 4
        wf_task_error                 = 5
        serious_inbound_error         = 6
        OTHERS                        = 7.
    IF sy-subrc EQ 0.
      SELECT docnum " IDoc number
             logdat " Date of status information
             logtim " Time of status information
            countr  " IDoc status counter
            status  " Status of IDoc
            stapa1  " Parameter 1
            stapa2  " Parameter 2
            stapa3  " Parameter 3
            stapa4  " Parameter 4
            stamid  " Status message ID
            stamno  " Status message number
      FROM edids    " Status Record (IDoc)
      INTO TABLE  li_edids
        WHERE docnum = st_edidc-docnum.
      IF sy-subrc EQ 0.
        SORT li_edids BY status.
        READ TABLE li_edids ASSIGNING FIELD-SYMBOL(<lst_edids>)
          WITH KEY status =  lc_51 BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fp_lst_file_data_51>) FROM fp_lv_index_st TO fp_lv_index_en.
            MOVE-CORRESPONDING st_edidc TO <fp_lst_file_data_51>.
            MESSAGE ID <lst_edids>-stamid
             TYPE    c_msg_type_e
             NUMBER  <lst_edids>-stamno
             INTO    lst_status-fin_message_alv
             WITH   <lst_edids>-stapa1
                    <lst_edids>-stapa2
                    <lst_edids>-stapa3
                    <lst_edids>-stapa4.
            lst_status-vvis_lights       = c_alv_light_1.
            MOVE-CORRESPONDING lst_status TO <fp_lst_file_data_51>.
            CLEAR lst_status.
          ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_li_cond_rcs>) FROM fp_lv_index_st TO fp_lv_index_en
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE li_edids TRANSPORTING NO FIELDS WITH KEY status =  lc_53
                                                              BINARY SEARCH.
          IF sy-subrc EQ 0.
            LOOP AT i_file_data ASSIGNING FIELD-SYMBOL(<fp_lst_file_data_53>) FROM fp_lv_index_st TO fp_lv_index_en.
              MOVE-CORRESPONDING st_edidc TO <fp_lst_file_data_53>.
              MESSAGE ID c_msgid
              TYPE    c_msg_type_i
              NUMBER  lc_msgno_114
              INTO    lst_status-fin_message_alv
              WITH   c_mara.
*              WITH   p_tname. " THIS NEEDS TO BE CLARIFIED.
              lst_status-vvis_lights       = c_alv_light_3.
              MOVE-CORRESPONDING lst_status TO <fp_lst_file_data_53>.
              CLEAR lst_status.
            ENDLOOP. " LOOP AT fp_li_cond_rcs ASSIGNING FIELD-SYMBOL(<fp_li_cond_rcs>) FROM fp_lv_index_st TO fp_lv_index_en
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
    CLEAR st_edidc.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTROL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_control_data .

*LOCAL constant declaration
  CONSTANTS: lc_direct_in TYPE edi_direct VALUE '2',               " Direction for IDoc
             lc_sap       TYPE char3      VALUE 'SAP',             " Sap of type CHAR3
*              lc_partyp_ls TYPE edi_sndprt VALUE 'LS',            " Partner type of sender
             lc_msgtyp    TYPE edi_mestyp   VALUE 'ISM_MATMAS',    " Message Type
             lc_idoctp    TYPE edi_idoctp   VALUE 'ISM_MATMAS03',  " Basic type        " Hierarchy level
             lc_mescod    TYPE edipmescod   VALUE 'Z1',            " Message code
             lc_part_type TYPE edi_sndprt   VALUE 'LS'.

*Populate EDIDC Data
  st_edidc-direct = lc_direct_in. " Direction for IDoc-Outbound(1)
  st_edidc-mestyp = lc_msgtyp.    " Message Type-'ZRTR_CUST_CRDT_STATUS_VCH'
  st_edidc-idoctp = lc_idoctp.
  st_edidc-mescod = lc_mescod.

* Fetch details from Partner Profile: inbound (technical parameters)
  SELECT sndprn " Partner Number of Sender
         sndprt " Partner Type of Sender
         sndpfc " Partner function of sender
    FROM edp21  " Partner Profile: Inbound
   UP TO 1 ROWS
    INTO ( st_edidc-sndprn,
           st_edidc-sndprt,
           st_edidc-sndpfc )
   WHERE mestyp EQ lc_msgtyp
    AND mescod EQ  lc_mescod.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: st_edidc-sndprn, " Partner Number of Receiver
           st_edidc-sndprt, " Partner Type of Receiver
           st_edidc-sndpfc. " Receiver port
  ENDIF. " IF sy-subrc NE 0

  st_edidc-sndpor = 'ZLSMW'.

  CONCATENATE lc_sap
              sy-sysid
              INTO st_edidc-rcvpor. "
  CONDENSE st_edidc-rcvpor.

  st_edidc-rcvprt = lc_part_type.

* Get receiver information (Current System)
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = st_edidc-rcvprn " Partner Number of Receiver
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_edidc-rcvprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL
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
    FREE: fp_file_data,lst_file_data,V_rows.
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
    FREE:i_file_temp_clf,i_mara,V_rows.
    i_file_temp_clf[] =  fp_file_data[].
*    SORT i_file_temp_clf BY bismt klart class.
    SORT i_file_temp_clf BY klart class.
*    DELETE ADJACENT DUPLICATES FROM i_file_temp_clf COMPARING bismt klart class.
    DELETE ADJACENT DUPLICATES FROM i_file_temp_clf COMPARING klart class.
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
*        WHERE bismt = i_file_temp_clf-bismt.
        WHERE MATNR = i_file_temp_clf-OBJEK.
      IF sy-subrc = 0.
        SORT i_mara BY bismt.
      ENDIF.
      LOOP AT i_file_temp_clf ASSIGNING FIELD-SYMBOL(<fs_file_temp>).
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
*            input  = <fs_file_temp>-bismt
            input  = <fs_file_temp>-OBJEK
          IMPORTING
*            output = <fs_file_temp>-bismt
            output = <fs_file_temp>-OBJEK.
      ENDLOOP.
      SELECT matnr
             vpsta
             mtart
             bismt
             matkl
        FROM mara
        APPENDING TABLE i_mara
        FOR ALL ENTRIES IN i_file_temp_clf
        WHERE matnr = i_file_temp_clf-OBJEK.

      LOOP AT i_file_temp_clf ASSIGNING <fs_file_temp>.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
*            input  = <fs_file_temp>-bismt
            input  = <fs_file_temp>-OBJEK
          IMPORTING
*            output = <fs_file_temp>-bismt
            output = <fs_file_temp>-OBJEK.
      ENDLOOP.
      LOOP AT i_file_data_clf ASSIGNING <fs_file_temp>.
*        READ TABLE i_file_temp_clf INTO DATA(lst_file_temp) WITH KEY bismt = <fs_file_temp>-bismt.
        READ TABLE i_file_temp_clf INTO DATA(lst_file_temp) WITH KEY OBJEK = <fs_file_temp>-OBJEK.
        IF sy-subrc = 0.
*          <fs_file_temp>-bismt = lst_file_temp-bismt.
          <fs_file_temp>-OBJEK = lst_file_temp-OBJEK.
*          DATA(lv_bismt) = lst_file_temp-bismt.
          DATA(lv_OBJEK) = lst_file_temp-OBJEK.
        ELSE.
*          <fs_file_temp>-bismt = lv_bismt.
          <fs_file_temp>-OBJEK = lv_OBJEK.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  V_rows = lines( i_file_temp_clf ) .
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
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'KLART' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'CLASS' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'OBTAB' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'OBJEK' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'MAFID' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'STATU' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'ATNAM' ).
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'ATWRT' ).
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
    FREE:v_success,v_error,lv_sel.
    DESCRIBE TABLE i_error_rec_clf  LINES v_error.
    DESCRIBE TABLE i_sucess_rec_clf LINES v_success .
    v_total_proc = v_error + v_success.
    lv_sel = V_rows.
    CONCATENATE 'Total selected records to be processed: '(011) lv_sel INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE c_s.
    CONCATENATE 'successful records:'(012) v_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(013) v_error INTO DATA(lv_error).
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

  IF lst_file_data-OBJEK IS NOT INITIAL.
    i_MATNR = lst_file_data-OBJEK.
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY MATNR = lst_file_data-OBJEK.
    IF sy-subrc <> 0.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_file_data-OBJEK
        IMPORTING
          output = lst_file_data-OBJEK.
      DATA(lv_flag_conv) = abap_true.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_file_data-OBJEK.
    ENDIF.

    lst_file_data-OBJEK = lst_mara-matnr.
*    lst_file_data-matkl = lst_mara-matkl.

    IF lst_file_data-OBJEK IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_file_data-OBJEK
        IMPORTING
          output = lst_file_data-OBJEK.

      i_objectkey = lst_file_data-OBJEK.
      i_objecttab = lc_object.
      i_classnum  = lst_file_data-class.
*----Comparing the material group
      i_classtype = lc_class.
      i_keydate   = sy-datum.

      READ TABLE i_file_data_clf INTO DATA(lst_file_temp) WITH KEY OBJEK = i_MATNR.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT i_file_data_clf INTO lst_file_temp FROM lv_tabix.
          IF lv_flag_conv = abap_true.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_file_temp-OBJEK
              IMPORTING
                output = lst_file_temp-OBJEK.
          ENDIF.
          IF lst_file_temp-OBJEK <> lst_file_data-OBJEK.
            EXIT.
          ELSE.
*            st_allocvalueschar-charact    = lst_file_temp-charact.
            st_allocvalueschar-value_char = lst_file_temp-atwrt.
*            IF lst_file_temp-charact IS NOT INITIAL.
*              APPEND st_allocvalueschar TO i_allocvalueschar.
*            ENDIF.
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
          LOOP AT i_file_data_clf ASSIGNING FIELD-SYMBOL(<fs_file_temp>) WHERE OBJEK = i_MATNR.
            <fs_file_temp>-type    = lst_return-type.
            <fs_file_temp>-message = lst_return-message.
*            <fs_file_temp>-matkl =  lst_file_data-matkl.
            <fs_file_temp>-OBJEK = lst_file_data-OBJEK.
            lst_file_data = <fs_file_temp>.
            APPEND lst_file_data TO i_error_rec_clf.
            CLEAR:lst_file_temp .
          ENDLOOP.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
          READ TABLE i_return INTO lst_return WITH KEY type = c_s.
          IF sy-subrc = 0.
            LOOP AT i_file_data_clf ASSIGNING <fs_file_temp> WHERE OBJEK = i_MATNR.
              <fs_file_temp>-type    = lst_return-type.
              <fs_file_temp>-message = lst_return-message.
              <fs_file_temp>-OBJEK   = lst_file_data-OBJEK.
*              <fs_file_temp>-matkl =  lst_file_data-matkl.
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
    DESCRIBE TABLE i_error_rec_clf  LINES v_error.
    DESCRIBE TABLE i_sucess_rec_clf LINES V_success .
    V_total_proc = V_error + V_success.
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
*      PERFORM f_head_clf_names.       "tO BE EDITED
      TRANSFER i_head TO lv_file.
      LOOP AT i_sucess_rec_clf INTO DATA(lst_record).
        CONCATENATE lst_record-klart
                    lst_record-class
                    lst_record-obtab
                    lst_record-objek
                    lst_record-mafid
                    lst_record-statu
                    lst_record-atnam
                    lst_record-atwrt
*                    lst_record-atwtb
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
*      PERFORM f_head_clf_names .  TO BE EDITED
      TRANSFER i_head TO lv_file_e.
      CLEAR lst_record.
      LOOP AT i_error_rec_clf  INTO lst_record.
        CONCATENATE lst_record-klart
                    lst_record-class
                    lst_record-obtab
                    lst_record-objek
                    lst_record-mafid
                    lst_record-statu
                    lst_record-atnam
                    lst_record-atwrt
*                    lst_record-atwtb
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
