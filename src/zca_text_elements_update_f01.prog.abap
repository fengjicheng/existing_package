*&---------------------------------------------------------------------*
*&  Include           ZCA_TEXT_ELEMENTS_UPDATE_F01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
***INCLUDE ZCA_TEXT_ELEMENTS_UPDATE_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILENAME
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
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file .
  FIELD-SYMBOLS: <fs_value> TYPE char50.
  DATA: lst_text_data TYPE ty_text_details,
        lst_text      TYPE ty_text,
        lv_file       TYPE rlgrap-filename,
        li_excel      TYPE TABLE OF zqtc_alsmex_tabline.

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
          lst_text_data-tdname = lst_excel-value.
          CLEAR lst_excel.
        WHEN 2.
          lst_text_data-spras = lst_excel-value.
          CLEAR lst_excel.
        WHEN 3.
          lst_text_data-ltext = lst_excel-value.
        WHEN 4.
          lst_text_data-tdformat = lst_excel-value.
      ENDCASE.

      lst_text-text = lst_text_data-ltext.
      lst_text-tdformat = lst_text_data-tdformat.

      AT END OF row.
        IF lst_text IS NOT INITIAL.
          APPEND lst_text TO i_text.
          CLEAR: lst_text.
        ENDIF.
        APPEND lst_text_data TO i_text_data.
        CLEAR lst_text_data.
      ENDAT.
      CLEAR: lst_excel.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TEXT_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_text_update .
  DATA :  lst_header TYPE thead,
          lst_ltext  TYPE tline,
          li_ltext   TYPE TABLE OF tline.


  LOOP AT i_text INTO DATA(lst_txt).
    IF lst_txt-tdformat IS INITIAL.
      lst_ltext-tdformat = space.
    ELSE.
      lst_ltext-tdformat  = lst_txt-tdformat.
    ENDIF.
    lst_ltext-tdline    = lst_txt-text.
    APPEND lst_ltext TO li_ltext.
    CLEAR : lst_ltext,lst_txt.
  ENDLOOP.

  LOOP AT i_text_data INTO DATA(lst_data).

    lst_header-tdobject     = 'TEXT'.
    lst_header-tdname       = lst_data-tdname.
    lst_header-tdid         = 'ST'.
    lst_header-tdspras      = lst_data-spras.
    lst_header-tdlinesize   = '999'.
    lst_header-tdtxtlines   = '5'.
    lst_ltext-tdformat      = '*'.

*    DATA: lv_text   TYPE string,
*          lv_length TYPE i.
*    lv_text = lst_data-ltext.
*    lv_length = strlen( lv_text ).
*    REFRESH i_text.

*    CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
*      EXPORTING
*        text        = lv_text
*        line_length = '132'
*        langu       = sy-langu
*      TABLES
*        text_tab    = i_text.

*    REFRESH li_lines.



    CALL FUNCTION 'DELETE_TEXT'
      EXPORTING
        client          = sy-mandt
        id              = lst_header-tdid
        language        = lst_header-tdspras
        name            = lst_header-tdname
        object          = lst_header-tdobject
        savemode_direct = 'X'
      EXCEPTIONS
        not_found       = 1
        OTHERS          = 2.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          client          = sy-mandt
          header          = lst_header
          insert          = 'X'
          savemode_direct = 'X'
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
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
