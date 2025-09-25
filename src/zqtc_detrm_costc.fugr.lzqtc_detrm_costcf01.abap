*-------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_DETRM_COSTCF01
* PROGRAM DESCRIPTION: Create Maintain Media Product Master Records
* Populating Fields  Name of Person Who Changed Object, Changed On
* and  'Time last change was made' of table ZQTC_DETRM_COSTC
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-02-02
* OBJECT ID:E148
* TRANSPORT NUMBER(S):ED2K904337
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZQTC_DETRM_COSTCF01.
*----------------------------------------------------------------------*
FORM f_populate_fields_save.

  FIELD-SYMBOLS:
    <lv_field> TYPE any.                                        "Field Value

  CONSTANTS:
    lc_f_aenam TYPE viewfield  VALUE 'AENAM',                   "Name of Person Who Changed Object
    lc_f_aedat TYPE viewfield  VALUE 'AEDAT',                   "Changed On
    lc_f_aezet TYPE viewfield  VALUE 'AEZET'.                   "Time last change was made

  LOOP AT total.
    IF <action> = neuer_eintrag OR                              "Create New Entry (N)
       <action> = aendern.                                      "Change Entry (U)
*     Name of Person Who Changed Object
      ASSIGN COMPONENT lc_f_aenam OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uname.                                  "Name of Current User
      ENDIF.
*     Changed On
      ASSIGN COMPONENT lc_f_aedat OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-datum.                                  "Current Date of Application Server
      ENDIF.
*     Time last change was made
      ASSIGN COMPONENT lc_f_aezet OF STRUCTURE total TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uzeit.                                  "Current Time of Application Server
      ENDIF.
      MODIFY total.

      READ TABLE extract WITH KEY <vim_xtotal_key>.
      IF sy-subrc EQ 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDLOOP.

  sy-subrc = 0.

ENDFORM.
