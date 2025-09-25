*----------------------------------------------------------------------*
***INCLUDE LZVQTC_JGC_SOCF01.
*----------------------------------------------------------------------*
FORM f_populate_fields_save.

  FIELD-SYMBOLS:
    <lv_field> TYPE any.                                        "Field Value

  CONSTANTS:
    lc_f_aenam TYPE viewfield  VALUE 'AENAM',                   "Name of Person Who Changed Object
    lc_f_aedat TYPE viewfield  VALUE 'AEDAT',                   "Changed On
    lc_f_aezet TYPE viewfield  VALUE 'AEZET'.                   "Time last change was made

  LOOP AT total ASSIGNING FIELD-SYMBOL(<lst_total>).
    IF <action> = neuer_eintrag OR                              "Create New Entry (N)
       <action> = aendern.                                      "Change Entry (U)
*     Name of Person Who Changed Object
      ASSIGN COMPONENT lc_f_aenam OF STRUCTURE <lst_total> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uname.                                  "Name of Current User
      ENDIF.
*     Changed On
      ASSIGN COMPONENT lc_f_aedat OF STRUCTURE <lst_total> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-datum.                                  "Current Date of Application Server
      ENDIF.
*     Time last change was made
      ASSIGN COMPONENT lc_f_aezet OF STRUCTURE <lst_total> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uzeit.                                  "Current Time of Application Server
      ENDIF.

      READ TABLE extract ASSIGNING FIELD-SYMBOL(<lst_extract>)
           WITH KEY <vim_xtotal_key>.
      IF sy-subrc EQ 0.
        <lst_extract> = <lst_total>.
      ENDIF.
    ENDIF.
  ENDLOOP.

  sy-subrc = 0.

ENDFORM.
