*----------------------------------------------------------------------*
***INCLUDE ZQTCR_SEND_AC_NOTIFCATION_RF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GRADE_RANGE_RESTRICT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_grade_range_restrict .
  DATA: lw_selopt   TYPE sscr_ass,
        lw_opt_list TYPE sscr_opt_list,
        lt_restrict TYPE sscr_restrict.

  CLEAR lw_opt_list.
  lw_opt_list-name          = c_eq.
  lw_opt_list-options-eq    = c_x.
  APPEND lw_opt_list TO lt_restrict-opt_list_tab.

  CLEAR lw_selopt.
  lw_selopt-kind            = c_s.
  lw_selopt-name            = c_so_grade.
  lw_selopt-sg_main         = c_i.
  lw_selopt-sg_addy         = c_blank.
  lw_selopt-op_main         = c_eq.
  lw_selopt-op_addy         = c_eq.
  APPEND lw_selopt  TO lt_restrict-ass_tab.
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lt_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAILTY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_p_mailty .
  TYPES : BEGIN OF lty_value,
            name(12),
          END OF lty_value.
  DATA : lt_value_tab  TYPE TABLE OF lty_value,
         lw_value      TYPE lty_value,
         lt_field_tab  TYPE TABLE OF dfies,
         lw_field      TYPE dfies,
         lt_return_tab TYPE TABLE OF ddshretval,
         lw_return     TYPE ddshretval.
  CLEAR : lw_value, lw_field, lw_return.
  REFRESH : lt_value_tab,
            lt_field_tab,
            lt_return_tab.

  SELECT devid, param1, param2, srno, low
  FROM zcaconstant
  INTO TABLE @DATA(lt_zcaconstant)
  WHERE devid    EQ @c_devid
    AND activate EQ @c_x.
  IF sy-subrc EQ 0.
    lw_field-fieldname = c_field.
    lw_field-tabname = c_table.
    APPEND lw_field TO lt_field_tab.
    SORT lt_zcaconstant BY low ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_zcaconstant COMPARING low.
    LOOP AT lt_zcaconstant INTO DATA(lw_zcaconstant).
      lw_value-name = lw_zcaconstant-low.
      APPEND lw_value TO lt_value_tab.
      CLEAR : lw_value, lw_zcaconstant.
    ENDLOOP.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lw_field-fieldname
      TABLES
        value_tab       = lt_value_tab
        field_tab       = lt_field_tab
        return_tab      = lt_return_tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc = 0.
      READ TABLE lt_return_tab INTO lw_return INDEX 1.
      p_mailty = lw_return-fieldval.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_LOGIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing_logic .
  DATA lo_notif TYPE REF TO lcl_send_ac_notif. " Report Object reference
  CREATE OBJECT lo_notif.
  lo_notif->meth_get_data( ).
  lo_notif->meth_generate_output( ).
ENDFORM.
