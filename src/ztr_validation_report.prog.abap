*&---------------------------------------------------------------------*
*& Report  ZTR_VALIDATION_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztr_validation_report.

INCLUDE ztr_validation_report_t.
INCLUDE ztr_validation_report_sel.
INCLUDE ztr_validation_report_frm.

INITIALIZATION.
* The association table
  DATA : sscr_ass_tab TYPE sscr_ass.
* Define the object to be passed to the RESTRICTION parameter
  DATA restrict TYPE sscr_restrict.

* Auxiliary objects for filling RESTRICT
  DATA opt_list TYPE sscr_opt_list.

* JUST_EQ: Only EQ allowed
  CLEAR opt_list.
  MOVE 'JUST_EQ' TO opt_list-name.
  MOVE 'X' TO opt_list-options-eq.
  APPEND opt_list TO restrict-opt_list_tab.

* KIND = 'S': Applies to SELECT-OPTION
  CLEAR sscr_ass_tab.
  MOVE: 'S'        TO sscr_ass_tab-kind,
        'S_EMAIL'  TO sscr_ass_tab-name,
        'I'        TO sscr_ass_tab-sg_main,
*        'N'        TO SSCR_ASS_TAB-SG_ADDY,
        'JUST_EQ'  TO sscr_ass_tab-op_main.
  APPEND sscr_ass_tab TO restrict-ass_tab.
  CLEAR sscr_ass_tab.
  MOVE: 'S'        TO sscr_ass_tab-kind,
        'S_REQ'  TO sscr_ass_tab-name,
        'I'        TO sscr_ass_tab-sg_main,
*        'N'        TO SSCR_ASS_TAB-SG_ADDY,
        'JUST_EQ'  TO sscr_ass_tab-op_main.
  APPEND sscr_ass_tab TO restrict-ass_tab.
  CLEAR sscr_ass_tab.
  MOVE: 'S'        TO sscr_ass_tab-kind,
        'S_STAT'  TO sscr_ass_tab-name,
        'I'        TO sscr_ass_tab-sg_main,
*        'N'        TO SSCR_ASS_TAB-SG_ADDY,
        'JUST_EQ'  TO sscr_ass_tab-op_main.
  APPEND sscr_ass_tab TO restrict-ass_tab.
  CLEAR sscr_ass_tab.
  MOVE: 'S'        TO sscr_ass_tab-kind,
        'S_USER'  TO sscr_ass_tab-name,
        'I'        TO sscr_ass_tab-sg_main,
*        'N'        TO SSCR_ASS_TAB-SG_ADDY,
        'JUST_EQ'  TO sscr_ass_tab-op_main.
  APPEND sscr_ass_tab TO restrict-ass_tab.
  CLEAR sscr_ass_tab.
  MOVE: 'S'        TO sscr_ass_tab-kind,
        'S_DES'  TO sscr_ass_tab-name,
        'I'        TO sscr_ass_tab-sg_main,
*        'N'        TO SSCR_ASS_TAB-SG_ADDY,
        'JUST_EQ'  TO sscr_ass_tab-op_main.
  APPEND sscr_ass_tab TO restrict-ass_tab.
* Call function module
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction                = restrict
*     DB                         = ' '
    EXCEPTIONS
      too_late                   = 1
      repeated                   = 2
      not_during_submit          = 3
      db_call_after_report_call  = 4
      selopt_without_options     = 5
      selopt_without_signs       = 6
      invalid_sign               = 7
      report_call_after_db_error = 8
      empty_option_list          = 9
      invalid_kind               = 10
      repeated_kind_a            = 11
      OTHERS                     = 12.

* Exception handling
  CASE sy-subrc.
    WHEN 1.
      RAISE too_late.
    WHEN 2.
      RAISE repeated.
    WHEN 3.
      RAISE not_during_submit.
    WHEN 4.
      RAISE db_call_after_report_call.
    WHEN 5.
      RAISE selopt_without_options.
    WHEN 6.
      RAISE selopt_without_signs.
    WHEN 7.
      RAISE invalid_sign.
    WHEN 8.
      RAISE report_call_after_db_error.
    WHEN 9.
      RAISE empty_option_list.
    WHEN 10.
      RAISE invalid_kind.
    WHEN 11.
      RAISE repeated_kind_a.
    WHEN OTHERS.
  ENDCASE.

AT SELECTION-SCREEN.
  IF sy-ucomm NE '%003' AND  sy-ucomm NE '%004' AND
     sy-ucomm NE '%005' AND sy-ucomm NE '%006'  AND
     sy-ucomm NE '%007' AND sy-ucomm NE '%010'  AND s_dest-low IS INITIAL.
    MESSAGE 'Please Enter The RFC Destination' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.

  PERFORM rfc_validation.

  PERFORM tr_validation.

  PERFORM comp_objects.

*  IF sy-batch NE 'X'.
  PERFORM display_salv.

  IF NOT gt_outtab IS INITIAL.
  PERFORM fill_email_body.
  ENDIF.

  IF i_message IS NOT INITIAL.
*- Send Retrofit details by email
    PERFORM send_email.
  ENDIF.
* Set the top of page
  PERFORM set_top_of_page CHANGING lo_alv.
* Display ALV.
  PERFORM display CHANGING lo_alv.
