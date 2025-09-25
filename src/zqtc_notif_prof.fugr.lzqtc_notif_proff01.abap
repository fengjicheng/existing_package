*----------------------------------------------------------------------*
***INCLUDE LZQTC_NOTIF_PROFF01.
*----------------------------------------------------------------------*
FORM f_populate_fields_save.

  DATA : lv_knuma TYPE knuma.

  FIELD-SYMBOLS:
    <lv_field> TYPE any.                                        "Field Value

  CONSTANTS:
    lc_f_aenam        TYPE viewfield VALUE 'AENAM',                   "Name of Person Who Changed Object
    lc_f_aedat        TYPE viewfield VALUE 'AEDAT',                   "Changed On
    lc_f_aezet        TYPE viewfield VALUE 'AEZET',                   "Time last change was made
    lc_f_notif_prof   TYPE viewfield VALUE 'NOTIF_PROF',              "Notification profile
    lc_f_notif_prof_d TYPE viewfield VALUE 'NOTIF_PROF_D',            "Notification profile description
    lc_f_promo_code   TYPE viewfield VALUE 'PROMO_CODE',              "Promo code
    lc_b              TYPE abtyp     VALUE 'B',                       "Category of the rebate agreement
    lc_notif_rem      TYPE viewfield VALUE 'NOTIF_REM',               "notification reminder
    lc_notif_remd     TYPE viewfield VALUE 'REM_IN_DAYS'.               "notification reminder

  LOOP AT total.
    IF <action> = neuer_eintrag OR                              "Create New Entry (N)
       <action> = aendern.                                      "Change Entry (U)
*     Name of Person Who Changed Object
      ASSIGN COMPONENT lc_f_aenam OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uname.                                  "Name of Current User
      ENDIF.
*     Changed On
      ASSIGN COMPONENT lc_f_aedat OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-datum.                                  "Current Dais lankte of Application Server
      ENDIF.
*     Time last change was made
      ASSIGN COMPONENT lc_f_aezet OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = sy-uzeit.                                  "Current Time of Application Server
      ENDIF.
*     Check if Notification Profile is blank.
      ASSIGN COMPONENT lc_f_notif_prof OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc = 0.
        IF <lv_field> IS INITIAL.
          vim_abort_saving = 'X'.
          MESSAGE i000(zqtc_r2) WITH 'Notification profile can not be blank'.
        ENDIF.
      ENDIF.
*     Check if Notification Description is blank.
      ASSIGN COMPONENT lc_f_notif_prof_d OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc = 0.
        IF <lv_field> IS INITIAL.
          vim_abort_saving = 'X'.
          MESSAGE i000(zqtc_r2) WITH 'Notification profile description can not be blank'.
        ENDIF.
      ENDIF.
*Check if notification reminder field is blank
      ASSIGN COMPONENT lc_notif_rem OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc = 0.
        IF <lv_field> IS INITIAL.
          vim_abort_saving = 'X'.
          MESSAGE i000(zqtc_r2) WITH 'Notification/Reminder can not be blank'.
        ENDIF.
      ENDIF.
*Check if Notification Reminder (in Days) field is blank
      ASSIGN COMPONENT lc_notif_remd OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc = 0.
        IF <lv_field> IS INITIAL.
          vim_abort_saving = 'X'.
          MESSAGE i000(zqtc_r2) WITH 'Notification Reminder (in Days) can not be blank'.
        ENDIF.
      ENDIF.



*     Check if Promo code does exist.
      ASSIGN COMPONENT lc_f_promo_code OF STRUCTURE <vim_total_struc> TO <lv_field>.
      IF sy-subrc = 0.
        IF <lv_field> IS NOT INITIAL.
          SELECT SINGLE knuma FROM kona INTO lv_knuma WHERE knuma = <lv_field> AND abtyp = lc_b.
          IF sy-subrc NE 0.
            vim_abort_saving = 'X'.
            MESSAGE i000(zqtc_r2) WITH 'Promo code' <lv_field> 'does not exist'.
          ENDIF.
        ENDIF.
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
