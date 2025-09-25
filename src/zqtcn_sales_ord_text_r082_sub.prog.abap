*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_ORD_TEXT_R082_SUB
*&---------------------------------------------------------------------*

*--------Forms-----------------------------
FORM f_dynamic_screen.
  LOOP AT SCREEN.
    IF screen-group1 = 'PAT'.
      IF rb_pre IS INITIAL AND rb_appl IS INITIAL.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    IF screen-group1 = 'RB1'.
      IF rb_alv IS INITIAL.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.

FORM f_validation_object.

  SELECT tdobject,
         tdtext
    FROM ttxot
    INTO TABLE @DATA(lt_object)
    WHERE tdspras = @p_lang.
  IF sy-subrc = 0.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TDOBJECT'
        dynpprog        = sy-repid
        dynpnr          = sy-dynnr
        dynprofield     = 'P_OBJECT'
        value_org       = 'S'
      TABLES
        value_tab       = lt_object
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    CASE sy-subrc.
      WHEN 1.
        RAISE parameter_error.
      WHEN 2.
        RAISE no_values_found.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.
ENDFORM.

FORM f_validation_tdid.

  SELECT tdid,
         tdtext
    FROM ttxit
    INTO TABLE @DATA(lt_tdid)
    WHERE tdspras  = @p_lang
      AND tdobject = @p_object.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TDID'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'P_ID'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tdid
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  CASE sy-subrc.
    WHEN 1.
      RAISE parameter_error.
    WHEN 2.
      RAISE no_values_found.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM f_file_path.
  DATA : lv_initial_folder  TYPE string,
         lv_selected_folder TYPE string,
         lv_file            TYPE localfile.

  IF rb_pre = abap_true.
    CALL METHOD cl_gui_frontend_services=>directory_browse
      EXPORTING
        initial_folder       = lv_initial_folder
      CHANGING
        selected_folder      = lv_selected_folder
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      p_file = lv_selected_folder .
    ENDIF.
  ELSEIF rb_appl = abap_true.
    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
      IMPORTING
        serverfile       = lv_file
      EXCEPTIONS
        canceled_by_user = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      p_file = lv_file.
    ENDIF.
  ENDIF.
ENDFORM.

FORM f_get_data.
  DATA:lst_final     TYPE ity_final,
       lst_read_text TYPE tline.
  DATA:  li_header    TYPE thead,
         li_read_text TYPE TABLE OF tline.
  CONSTANTS:lc_vbbk  TYPE tdobject VALUE 'VBBK'.

  SELECT vbeln
    FROM vbak
    INTO TABLE @DATA(lt_vbak)
    WHERE vbeln IN @s_ord
      AND vkorg IN @s_sorg
      AND erdat IN @s_date.
  IF sy-subrc = 0 AND lt_vbak IS NOT INITIAL.
    SELECT vbeln,
           posnr,
           matnr
      FROM vbap
      INTO TABLE @DATA(lt_vbap)
      FOR ALL ENTRIES IN @lt_vbak
      WHERE vbeln = @lt_vbak-vbeln
        AND posnr IN @s_itm.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.

    LOOP AT lt_vbap INTO DATA(lst_vbap).

      FREE:li_read_text,li_header.
      li_header-tdobject = p_object.
      IF p_object = lc_vbbk.
        li_header-tdname = lst_vbap-vbeln.
        CLEAR:lst_vbap-posnr,lst_vbap-matnr.
      ELSE.
        CONCATENATE lst_vbap-vbeln lst_vbap-posnr INTO li_header-tdname.
      ENDIF.
      li_header-tdid    = p_id.
      li_header-tdspras = p_lang.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = li_header-tdid
          language                = li_header-tdspras
          name                    = li_header-tdname
          object                  = li_header-tdobject
        TABLES
          lines                   = li_read_text
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
      ELSE.
        CLEAR:lst_read_text.
        READ TABLE li_read_text INTO lst_read_text INDEX 1.
        IF  sy-subrc = 0.
          CLEAR lst_final.
          lst_final-vbeln  =  lst_vbap-vbeln.
          lst_final-posnr  =  lst_vbap-posnr.
          lst_final-matnr  =  lst_vbap-matnr.
          lst_final-tdline =  lst_read_text-tdline.
          APPEND lst_final TO i_final.
          CLEAR:lst_final,lst_vbap.
        ENDIF.
      ENDIF.
    ENDLOOP.
    SORT i_final BY vbeln posnr matnr tdline.
    DELETE ADJACENT DUPLICATES FROM i_final COMPARING vbeln posnr matnr tdline.
  ENDIF.
ENDFORM.

FORM f_display.
  DATA: li_columns   TYPE REF TO cl_salv_columns_table,
        li_column    TYPE REF TO cl_salv_column_table,
        li_functions TYPE REF TO cl_salv_functions,
        li_table     TYPE REF TO cl_salv_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = li_table
        CHANGING
          t_table      = i_final.
    ##NO_HANDLER    CATCH cx_salv_msg .
  ENDTRY.
  TRY.
      li_columns = li_table->get_columns( ).
    CATCH cx_salv_msg .
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( 'VBELN' ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( 'POSNR' ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( 'MATNR' ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( 'TDLINE' ).
      li_column->set_medium_text( text-003 ).
      li_column->set_long_text( text-003 ).
      li_columns->set_optimize( abap_true ).
    CATCH cx_salv_not_found.
  ENDTRY.

  li_functions = li_table->get_functions( ).
  li_functions->set_all( abap_true ).
  li_table->display( ).

ENDFORM.

FORM f_presentation_layer.
  TYPES: BEGIN OF ty_field,
           name TYPE char10,
         END OF ty_field.

  DATA:li_fieldname  TYPE STANDARD TABLE OF ty_field,
       lst_fieldname TYPE ty_field.
  CONSTANTS:lc_e TYPE char1 VALUE 'E'.

  IF i_final IS NOT INITIAL.
    CLEAR:lst_fieldname.
    lst_fieldname-name = text-008.
    APPEND lst_fieldname TO li_fieldname.
    CLEAR:lst_fieldname.
    lst_fieldname-name = text-009.
    APPEND lst_fieldname TO li_fieldname.
    CLEAR:lst_fieldname.
    lst_fieldname-name = text-010.
    APPEND lst_fieldname TO li_fieldname.
    CLEAR:lst_fieldname.
    lst_fieldname-name = text-003.
    APPEND lst_fieldname TO li_fieldname.
    CLEAR:lst_fieldname.

    CONCATENATE p_file '\' text-011 sy-datum sy-uzeit text-007 INTO  p_file.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = p_file
        filetype              = 'ASC'
        write_field_separator = ','
        codepage              = '4103'
        write_bom             = 'X'
      TABLES
        data_tab              = i_final
        fieldnames            = li_fieldname.
    MESSAGE i258(zqtc_r2) WITH p_file.
  ELSE.
    MESSAGE text-006 TYPE lc_e.
  ENDIF.

ENDFORM.

FORM f_application_layer.
  DATA: lv_file    TYPE string.
  CONSTANTS:lc_e TYPE char1 VALUE 'E'.

  IF i_final IS NOT INITIAL.

    CONCATENATE p_file '/' text-011 sy-datum sy-uzeit text-007 INTO  p_file.


    OPEN DATASET p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    CONCATENATE text-008
                text-009
                text-010
                text-003
                INTO lv_file
                SEPARATED BY ','.

    TRANSFER lv_file TO p_file.
    LOOP AT i_final INTO DATA(lst_final).
      CONCATENATE lst_final-vbeln
                  lst_final-posnr
                  lst_final-matnr
                  lst_final-tdline
                  INTO lv_file
                  SEPARATED BY ','.
      TRANSFER lv_file TO p_file .
      CLEAR lv_file .
      MESSAGE i258(zqtc_r2) WITH p_file.
    ENDLOOP.
    CLOSE DATASET p_file.
  ELSE.
    MESSAGE text-006 TYPE lc_e.
  ENDIF.
ENDFORM.
