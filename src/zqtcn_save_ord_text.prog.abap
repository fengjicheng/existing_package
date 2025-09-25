*&---------------------------------------------------------------------*
*&  Include  ZQTCN_SAVE_ORD_TEXT
*&---------------------------------------------------------------------*
DATA:lv_tdname  TYPE thead-tdname,
     li_lines   TYPE STANDARD TABLE OF tline,
     lst_header TYPE thead.

IF t180-aktyp = 'V' AND xvbak-vbeln NE vbak-vbeln.
  CALL FUNCTION 'SD_GET_TEXTNAME'
    EXPORTING
      fi_object = 'VBBK'
      fi_vbeln  = vbak-vbeln
      fi_posnr  = '000000'
    IMPORTING
      fe_tdname = lv_tdname.

  IF sy-subrc IS INITIAL.
    CALL FUNCTION 'DELETE_TEXT_FROM_CATALOG'
      EXPORTING
        object    = 'VBBK'
        name      = lv_tdname
        id        = '0009'
        language  = sy-langu
        local_cat = ' '
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = '0009'
          language                = sy-langu
          name                    = lv_tdname
          object                  = 'VBBK'
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
      IF sy-subrc IS INITIAL.

        lst_header-tdid = '0009'.
        lst_header-tdspras = sy-langu.
        lst_header-tdobject = 'VBBK'.
        lst_header-tdname = lv_tdname.

        CALL FUNCTION 'SAVE_TEXT'
          EXPORTING
            header   = lst_header
          TABLES
            lines    = li_lines
          EXCEPTIONS
            id       = 1
            language = 2
            name     = 3
            object   = 4
            OTHERS   = 5.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
