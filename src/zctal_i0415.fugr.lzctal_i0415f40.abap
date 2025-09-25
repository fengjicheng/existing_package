*----------------------------------------------------------------------*
***INCLUDE LCTALF40 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_TEXTS
*&---------------------------------------------------------------------*
*       save longtexts for characteristic and values
*----------------------------------------------------------------------*
*  -->  CHARACT                    characteristic name
*  -->  CHANGE_NUMBER              change number
*  -->  KEY_DATE                   key date
*----------------------------------------------------------------------*
FORM SAVE_TEXTS using VALUE(CHARACT)       TYPE ATNAM
                      VALUE(CHANGE_NUMBER) TYPE AENNR
                      VALUE(KEY_DATE)      LIKE SY-DATUM.

  data:
    L_LANGU_ISO like E1TEXTL-LANGUAGE_ISO, "language ISO
    L_SPRAS     type SPRAS,                "language ID
    L_TEXT      type tline occurs 30 with header line,
    L_VALUE     type atwrt.                "value


*--- text are not available with CHRMAS01 and CHRMAS02
  CHECK G_MESTYPE NE 'CHRMAS01' AND
        G_MESTYPE NE 'CHRMAS02'.


* Begin of 1353898
* Delete text assigned to the characteristic
  CALL FUNCTION 'CTMV_TEXT_DELETE'
    EXPORTING
      CHARACT                 = CHARACT
      KEY_DATE                = KEY_DATE
      CHANGE_NUMBER           = CHANGE_NUMBER
      LANGUAGE                = L_SPRAS
    EXCEPTIONS
      ERROR                   = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
    "Errors can be ignored
  ENDIF.

* Delete text assigned to values
  CALL FUNCTION 'CTMV_TEXT_DELETE'
    EXPORTING
      CHARACT                 = CHARACT
      KEY_DATE                = KEY_DATE
      CHANGE_NUMBER           = CHANGE_NUMBER
      LANGUAGE                = L_SPRAS
      ALL_VALUE_TEXTS         = 'X'
    EXCEPTIONS
      ERROR                   = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
    "Errors can be ignored
  ENDIF.
* End of 1353898


*--- save long texts for characteristic
  clear:
    L_LANGU_ISO,
    L_SPRAS.
  Loop at T_E1TEXTL
    where charact eq charact.

    if L_LANGU_ISO ne T_E1TEXTL-LANGUAGE_ISO.
      if not L_SPRAS is initial.
        CALL FUNCTION 'CTMV_TEXT_CHARACT_SET'
             EXPORTING
                  CHARACT       = CHARACT
                  KEY_DATE      = KEY_DATE
                  CHANGE_NUMBER = CHANGE_NUMBER
                  LANGUAGE      = L_SPRAS
             TABLES
                  TEXT          = L_TEXT
             EXCEPTIONS
                  OTHERS        = 0.
        clear l_text[].
      endif.
      CALL FUNCTION 'LANGUAGE_CODE_ISO_TO_SAP'
        EXPORTING
          ISO_CODE        = T_E1TEXTL-LANGUAGE_ISO
        IMPORTING
          SAP_CODE        = l_spras
        EXCEPTIONS
          NOT_FOUND       = 1
          OTHERS          = 2.
      IF SY-SUBRC <> 0.
        l_spras = T_E1TEXTL-LANGUAGE_ISO.
      ENDIF.
      L_LANGU_ISO = T_E1TEXTL-LANGUAGE_ISO.

    endif.

    move-corresponding T_E1TEXTL to l_text.
    append l_text.

  Endloop.                             " at T_E1TEXTL.

  read table L_text index 1.
  if sy-subrc is initial.
    CALL FUNCTION 'CTMV_TEXT_CHARACT_SET'
         EXPORTING
              CHARACT       = CHARACT
              KEY_DATE      = KEY_DATE
              CHANGE_NUMBER = CHANGE_NUMBER
              LANGUAGE      = L_SPRAS
         TABLES
              TEXT          = L_TEXT
         EXCEPTIONS
              OTHERS        = 0.
     clear l_text[].
  endif.

*--- save long texts for values

  clear:
    L_LANGU_ISO,
    L_SPRAS,
    L_VALUE.

  loop at T_E1TXTL1
    where charact eq charact.
    if L_LANGU_ISO ne T_E1TXTL1-LANGUAGE_ISO or
       L_VALUE ne T_E1TXTL1-VALUE.
      if not L_SPRAS is initial.
        CALL FUNCTION 'CTMV_TEXT_VALUE_SET'
             EXPORTING
                  CHARACT         = CHARACT
                  VALUE           = L_VALUE
                  KEY_DATE        = KEY_DATE
                  CHANGE_NUMBER   = CHANGE_NUMBER
                  LANGUAGE        = L_SPRAS
             TABLES
                  TEXT            = L_TEXT
             EXCEPTIONS
                  OTHERS          = 0.
        clear l_text[].
      endif. "  not L_SPRAS is initial
      L_LANGU_ISO = T_E1TXTL1-LANGUAGE_ISO.
      CALL FUNCTION 'LANGUAGE_CODE_ISO_TO_SAP'
        EXPORTING
          ISO_CODE        = T_E1TXTL1-LANGUAGE_ISO
        IMPORTING
          SAP_CODE        = l_spras
        EXCEPTIONS
          NOT_FOUND       = 1
          OTHERS          = 2.
      IF SY-SUBRC <> 0.
        l_spras = T_E1TXTL1-LANGUAGE_ISO.
      ENDIF.
      L_VALUE     = T_E1TXTL1-VALUE.
    endif. "  L_LANGU_ISO ne T_E1TXTL1-LANGUAGE_ISO or ...

    move-corresponding T_E1TXTL1 to l_text.
    append l_text.

  endloop. "  at T_E1TXT1

  read table L_text index 1.
  if sy-subrc is initial.
    CALL FUNCTION 'CTMV_TEXT_VALUE_SET'
         EXPORTING
              CHARACT         = CHARACT
              VALUE           = L_VALUE
              KEY_DATE        = KEY_DATE
              CHANGE_NUMBER   = CHANGE_NUMBER
              LANGUAGE        = L_SPRAS
         TABLES
              TEXT            = L_TEXT
         EXCEPTIONS
              OTHERS          = 0.
    clear l_text[].
  endif.

  CALL FUNCTION 'CAMA_CHARACT_SAVE'
    EXPORTING
      COMM_WAIT       = 'X'
    EXCEPTIONS
      WARNING         = 1
      ERROR           = 2
      OTHERS          = 3.
  IF SY-SUBRC <> 0.
    clear sy-subrc.
  ENDIF.


ENDFORM.                               " SAVE_TEXTS
