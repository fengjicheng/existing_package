*----------------------------------------------------------------------*
***INCLUDE ZCAR_DOWNLD_AL11_TO_LOCAL_F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_HIDE_RADIO_BUTTONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_hide_radio_buttons .
  LOOP AT SCREEN.
    IF screen-group1 EQ 'M1'. " Hide the five radio buttons
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TITLE_AL11
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_title_al11 .
  sy-title = 'Utility to Download Application Server File'(013).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_AL11
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_al11 .
  CONSTANTS : lc_root_dir  TYPE eps2filnam VALUE '/intf'. " Default path
  DATA : lv_dir       TYPE string.
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = lc_root_dir                      " Display default path
    IMPORTING
      serverfile       = p_as_fn                          " Capture the file name
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Canceled by user'(002) TYPE c_i.
      WHEN 2.
        MESSAGE 'Unknown error for Directory path'(003) TYPE c_i.
    ENDCASE.
  ELSE.
    CLEAR v_filename.
    v_filename = p_as_fn+6.                               " Split file name from file path
  ENDIF.
ENDFORM.
