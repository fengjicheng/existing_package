*&---------------------------------------------------------------------*
*&  Include           ZQTC_PART_PROFILE_CR_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_TEMPLATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_file_template .
  IF r1 = abap_true.
    lv_table = 'EDPP1'.
  ELSEIF r2 = abap_true.
    lv_table = 'EDP13'.
  ELSEIF r3 = abap_true.
    lv_table = 'EDP21'.
  ELSEIF r4 = abap_true.
    lv_table = 'EDP12'.
  ENDIF.

  IF sy-ucomm ='FC01'.
* Start Excel
    CREATE OBJECT v_excel 'EXCEL.APPLICATION'.
    SET PROPERTY OF  v_excel  'Visible' = 1.

* get list of workbooks, initially empty
    CALL METHOD OF v_excel 'Workbooks' = v_mapl.
* add a new workbook
    CALL METHOD OF v_mapl 'Add' = v_map.

    CALL METHOD OF v_excel 'Columns' = v_column.
    CALL METHOD OF v_column 'Autofit'.


    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        tabname        = lv_table   " Table name
*       FIELDNAME      = ' '
        langu          = sy-langu
      TABLES
        dfies_tab      = lt_fields
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
* tell user what is going on
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = '90'
        text       = 'Downloading...'
      EXCEPTIONS
        OTHERS     = 1.
    LOOP AT lt_fields INTO DATA(ls_field).
      DATA(lv_tabix) = sy-tabix.
* output column headings to active Excel sheet
      PERFORM: f_fill_cell USING 1 lv_tabix 1 ls_field-fieldtext.
    ENDLOOP.
    CALL METHOD OF v_excel 'Worksheets' = v_mapl.

    FREE OBJECT v_excel.
  ENDIF.
ENDFORM.
FORM f_fill_cell USING fp_i fp_j fp_bold fp_val.
  DATA: lv_interior TYPE ole2_object,
        lv_borders  TYPE ole2_object.

  CALL METHOD OF v_excel 'Cells' = v_zl EXPORTING #1 = fp_i #2 = fp_j.

  SET PROPERTY OF v_zl 'Value' = fp_val .

  GET PROPERTY OF v_zl 'Font' = v_f.
  SET PROPERTY OF v_zl 'ColumnWidth' = 20.

  SET PROPERTY OF v_f 'Bold' = 1 .

  SET PROPERTY OF v_f 'COLORINDEX' = 1 .

  GET PROPERTY OF v_zl 'Interior' = lv_interior .

  SET PROPERTY OF lv_interior 'ColorIndex' = 15.
  SET PROPERTY OF v_zl 'WrapText' = 1.
*left

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '1'.

  SET PROPERTY OF lv_borders 'LineStyle' = '1'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '2'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '3'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '4'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  IF r1 = abap_true.
    lv_table = 'EDPP1'.
  ELSEIF r2 = abap_true.
    lv_table = 'EDP13'.
  ELSEIF r3 = abap_true.
    lv_table = 'EDP21'.
  ELSEIF r4 = abap_true.
    lv_table = 'EDP12'.
  ENDIF.
  PERFORM f_convert_new_excel USING p_file.    "File path
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file.
* Popup for file path

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file " File Path
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
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_NEW_ORD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_convert_new_excel  USING fp_p_file.
  DATA :    li_excel  TYPE STANDARD TABLE OF zqtc_alsmex_tabline " Rows for Table with Excel Data
                                    INITIAL SIZE 0,                  " Rows for Table with Excel Data
            lv_ole    TYPE char1,
            w_tabname TYPE w_tabname,
            w_dref    TYPE REF TO data,
            t_newline TYPE REF TO data,
            lv_int    TYPE i,
            w_grid    TYPE REF TO cl_gui_alv_grid,
            lt_fldcat TYPE slis_t_fieldcat_alv,
            wa_cat    LIKE LINE OF lt_fldcat.

  w_tabname = lv_table.

  CREATE DATA w_dref TYPE TABLE OF (w_tabname).

  ASSIGN w_dref->* TO <t_itab>. "Internal table

  CREATE DATA t_newline LIKE LINE OF <t_itab>.

  ASSIGN t_newline->* TO <fs_wa>. "Work area.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = lv_table   " Table name
      langu          = sy-langu
    TABLES
      dfies_tab      = lt_fields
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  DESCRIBE TABLE lt_fields LINES DATA(lv_colum).
  WHILE lv_ole IS INITIAL.
    CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 2       " File contains header
        i_end_col               = lv_colum "Colum cound dynamically
        i_end_row               = 65000
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc EQ 0.
      IF li_excel[] IS NOT INITIAL.
        LOOP AT li_excel INTO DATA(lst_excel).
          DATA(lst_excel_dummy) = lst_excel.
          AT NEW col.
            lv_int =  lst_excel_dummy-col.
            READ TABLE lt_fields INTO DATA(ls_fld) INDEX lv_int.
            IF sy-subrc = 0.
              ASSIGN COMPONENT ls_fld-fieldname OF STRUCTURE <fs_wa> TO <fs_fld>.
              IF sy-subrc = 0.
                IF ls_fld-convexit IS NOT INITIAL." Conversion exit
                  <fs_fld> = lst_excel_dummy-value.
                  PERFORM f_conv_exit_alpha CHANGING ls_fld-convexit <fs_fld>.
                ENDIF.
                <fs_fld> = lst_excel_dummy-value.
              ENDIF.
            ENDIF.
          ENDAT.
          AT END OF row.
            APPEND <fs_wa> TO <t_itab>.
            CLEAR:<fs_wa>,lv_int.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
      ENDIF. " IF li_excel[] IS NOT INITIAL
      lv_ole = abap_true.
    ELSE.
      MESSAGE 'Input file could not read' TYPE 'E'.
    ENDIF. " IF sy-subrc EQ 0
  ENDWHILE.
  IF p_test IS INITIAL AND <t_itab> IS NOT INITIAL.
    TRY.
        INSERT (lv_table) FROM TABLE <t_itab>.
      CATCH cx_sy_open_sql_db.
        ROLLBACK WORK.
        MESSAGE 'Duplicate Insert due to same key' TYPE 'E'.
        EXIT.
    ENDTRY.
    IF sy-subrc = 0.
      COMMIT WORK.
      PERFORM f_generate_tr_opt_1.  "Creating new TR and adding entries
      MESSAGE 'File Uploaded Succesfully...' TYPE 'S'.
    ELSE.
      ROLLBACK WORK.                                          " Transaction rollback
      MESSAGE 'Error in data saving....' TYPE 'E'.
    ENDIF.
  ENDIF.
  DO lv_colum TIMES.
    READ TABLE lt_fields INTO ls_fld INDEX sy-index.
    IF sy-subrc = 0.
      lv_int = ls_fld-leng.
      wa_cat-fieldname = ls_fld-fieldname.
      wa_cat-seltext_l = ls_fld-fieldtext.
      wa_cat-outputlen = lv_int.
      APPEND wa_cat TO lt_fldcat.
      CLEAR:wa_cat.
    ENDIF.
  ENDDO.
  IF lt_fldcat[] IS NOT INITIAL.
* Call ABAP List Viewer (ALV)
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        it_fieldcat = lt_fldcat
      TABLES
        t_outtab    = <t_itab>.
  ENDIF.
ENDFORM.
FORM f_generate_tr_opt_1 .
  DATA: li_e071     TYPE  tr_objects,
        li_e071k    TYPE  tr_keys,
        lst_e071    TYPE e071,
        lst_e071k   TYPE e071k,
        lv_request  TYPE trkorr,
        lv_position TYPE ddposition,
        lv_int      TYPE i,
        lv_int_s    TYPE i,
        lv_tabkey   TYPE trobj_name.
  REFRESH:li_e071[],li_e071k[].
  " Add header table values
  lst_e071-trkorr   = lv_request.
  lst_e071-as4pos   = 1.
  lst_e071-pgmid    = 'R3TR'.
  lst_e071-object   = 'TABU'.
  lst_e071-obj_name = lv_table.
  lst_e071-objfunc  = 'K'.
  lst_e071-lang     = sy-langu.
  APPEND lst_e071 TO li_e071.
  CLEAR lst_e071.
  " Add key fields for detail table
  DATA(lt_fields_key) = lt_fields[].
  DELETE lt_fields_key WHERE keyflag NE abap_true. "Delete non primary key
  DESCRIBE TABLE lt_fields_key LINES DATA(lv_key_num).
  LOOP AT <t_itab> ASSIGNING FIELD-SYMBOL(<fs_cr>).
    CLEAR:lv_int_s,lv_tabkey.
    lv_position = lv_position + 1.
    DO lv_key_num TIMES.
      DATA(lv_index) = sy-index.
      READ TABLE lt_fields_key INTO DATA(wa_key) INDEX lv_index.
      IF sy-subrc = 0.
        ASSIGN COMPONENT wa_key-fieldname OF STRUCTURE <fs_cr> TO FIELD-SYMBOL(<fs_val>).
        lv_int = wa_key-leng.
        lv_tabkey+lv_int_s(lv_int)    = <fs_val>.
        lv_int_s  = lv_int_s + lv_int.
        IF <fs_val> IS ASSIGNED.
          UNASSIGN <fs_val>.
        ENDIF.
      ENDIF.
    ENDDO.
    lst_e071k-trkorr     = lv_request.
    lst_e071k-pgmid      = 'R3TR'.
    lst_e071k-object     = 'TABU'.
    lst_e071k-objname    = lv_table.
    lst_e071k-as4pos     = lv_position.
    lst_e071k-mastertype = 'TABU'.
    lst_e071k-mastername = lv_table.
    lst_e071k-lang       = sy-langu.
    lst_e071k-tabkey     = lv_tabkey.
    APPEND lst_e071k TO li_e071k.
    CLEAR : lst_e071k , lv_position.
  ENDLOOP.
  IF li_e071k IS NOT INITIAL AND li_e071 IS NOT INITIAL.
    CALL FUNCTION 'TR_REQUEST_CHOICE'
      EXPORTING
        iv_suppress_dialog   = abap_false
        iv_request_types     = 'K'
        it_e071              = li_e071
        it_e071k             = li_e071k
* IMPORTING
*       ES_REQUEST           =
      EXCEPTIONS
        invalid_request      = 1
        invalid_request_type = 2
        user_not_owner       = 3
        no_objects_appended  = 4
        enqueue_error        = 5
        cancelled_by_user    = 6
        recursive_call       = 7
        OTHERS               = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ELSE.
    MESSAGE 'Data not in the processing tables...' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONV_EXIT_ALPHA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LS_FLD_CONVEXIT  text
*      <--P_<FS_FLD>  text
*----------------------------------------------------------------------*
FORM f_conv_exit_alpha  CHANGING fld_convexit TYPE any
                                 f_fldval TYPE any.
  DATA: ex_object_cx_root TYPE REF TO cx_root.
  CONCATENATE 'CONVERSION_EXIT_' fld_convexit '_INPUT' INTO DATA(fld_convexit1).
* Conversion exit ALPHA, external->internal
  TRY.
      CALL FUNCTION fld_convexit1
        EXPORTING
          input  = f_fldval                                                 "External Format
        IMPORTING
          output = f_fldval.
    CATCH cx_root INTO ex_object_cx_root.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_file .
  IF p_file IS NOT INITIAL.

  ENDIF.
ENDFORM.
