*----------------------------------------------------------------------*
***INCLUDE ZQTCN_BP_RULES_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save.
  DATA : lv_invalid_input(1),
         lv_data_change(1),
         lv_confirmation(1).
  CLEAR : lv_invalid_input, lv_data_change, lv_confirmation, gv_saved.
* Update the Final internal table with user made changes
  CALL METHOD o_grid->check_changed_data.

  READ TABLE gt_bp_rules INTO gw_bp_rules INDEX 1.
  IF sy-subrc EQ 0.
    LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<gw_final>).
      ASSIGN COMPONENT <gw_final>-field_name OF STRUCTURE gw_bp_rules
      TO FIELD-SYMBOL(<lv_status>).
      IF sy-subrc EQ 0.
        IF <lv_status> NE <gw_final>-status.        " When changes are made
          <lv_status> = <gw_final>-status.
          lv_data_change = c_x.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF lv_data_change IS NOT INITIAL.
      CALL FUNCTION 'POPUP_TO_CONFIRM'          " Display popup dialog
        EXPORTING
          text_question         = 'Please Confirm the changes'(012)
          text_button_1         = 'Yes'(010)
          text_button_2         = 'No'(011)
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_confirmation
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSEIF lv_confirmation EQ '1'.
        " Maintain the change log
        gw_bp_rules-updated_on   = sy-datum.
        gw_bp_rules-updated_time = sy-uzeit.
        gw_bp_rules-updated_by   = sy-uname.
* Modify the data base table ZQTC_BP_RULES
        CALL FUNCTION 'ENQUEUE_EZQTC_BP_RULES'
          EXPORTING
            mode_zqtc_bp_rules = 'E'
            mandt              = sy-mandt
          EXCEPTIONS
            foreign_lock       = 1
            system_failure     = 2
            OTHERS             = 3.
        IF sy-subrc EQ 0.
          MODIFY zqtc_bp_rules FROM gw_bp_rules.
          IF sy-dbcnt EQ 1.
            COMMIT WORK.
            gv_saved = c_x.
            CALL FUNCTION 'DEQUEUE_EZQTC_BP_RULES'
              EXPORTING
                mode_zqtc_bp_rules = 'E'
                mandt              = sy-mandt.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE 'No changes made'(001) TYPE c_e.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  CASE sy-ucomm.
    WHEN 'SAV'.
      PERFORM f_save.                        " Save changes to DB table
      IF gv_saved IS NOT INITIAL.            " When saving is confirmed
        MESSAGE 'Record saved successfully'(009) TYPE c_s.
        PERFORM f_free_container.              " Container Destructor
      ENDIF.
    WHEN 'BAK' OR 'EXT' OR 'CNCL'.
      PERFORM f_free_container.              " Container Destructor
      LEAVE PROGRAM.                         " Exit from Transaction
    WHEN 'RDBT'.
      PERFORM f_free_container.              " Container Destructor
      PERFORM f_modif_screen.                " Modify screen elements
    WHEN 'DISP' OR 'ENT'.
      PERFORM f_free_container.              " Container Destructor
      PERFORM f_display_data.                " Display output
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_MODIF_SCREEN.
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_modif_screen.
  IF rb_disp IS NOT INITIAL.
    gv_button = 'Display'(002).   " Button text as Display
  ELSE.
    gv_button = 'Maintain'(003).  " Button text as Maintain
  ENDIF.
  LOOP AT SCREEN.
    IF screen-name = 'DETAILS'.
*      IF ( rb_disp IS NOT INITIAL OR " When View radio button is choosen
      " When Maintain radio button is choosen fir the first time
      IF o_custom_container IS INITIAL .
        screen-active = 0.        " Hide the Details box
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA o_bp TYPE REF TO lcl_bp_rules. " Object ref of lcl_bp_rules class
  CREATE OBJECT o_bp. " Instance creation
  o_bp->meth_get_data( ).             " Fetch the data
  IF gt_final IS NOT INITIAL.
    o_bp->meth_generate_output( ).    " Display the data
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FREE_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_free_container .
  IF o_custom_container IS NOT INITIAL.
    CALL METHOD o_custom_container->free " Container Destructor
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc EQ 0.
      FREE o_custom_container.           " Release memory
    ENDIF.
  ENDIF.
ENDFORM.
