*----------------------------------------------------------------------*
***INCLUDE LZRTR_TRANSPORT_GROUPO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'TDR_FULL'.
  SET TITLEBAR 'TR TOOL POPUP'.

  IF o_editor_container IS INITIAL.
    CREATE OBJECT o_editor_container
      EXPORTING
        container_name              = 'TEXTEDITOR'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    CREATE OBJECT o_text_editor
      EXPORTING
        parent                     = o_editor_container
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_position          = i_line_length
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*----hide the toolbar and as well as status bar for the text editor control.
    CALL METHOD o_text_editor->set_toolbar_mode
      EXPORTING
        toolbar_mode = cl_gui_textedit=>false.

    CALL METHOD o_text_editor->set_statusbar_mode
      EXPORTING
        statusbar_mode = cl_gui_textedit=>false.

    CALL METHOD o_text_editor->set_textstream
      EXPORTING
        text                   = i_message
      EXCEPTIONS
        error_cntl_call_method = 1
        not_supported_by_gui   = 2
        OTHERS                 = 3.
  ENDIF.
ENDMODULE.
MODULE user_command_0100.

  CASE sy-ucomm.
    WHEN 'OK'.
*---If you are selected OK button then passing return value zero
*--- other wise passing return value 4.
      CALL METHOD o_text_editor->get_textstream
        EXPORTING
          only_when_modified     = cl_gui_textedit=>true
        IMPORTING
          text                   = i_text
        EXCEPTIONS
          error_cntl_call_method = 1
          not_supported_by_gui   = 2
          OTHERS                 = 3.

      CALL METHOD cl_gui_cfw=>flush
        EXCEPTIONS
          cntl_system_error = 1
          cntl_error        = 2
          OTHERS            = 3.
      IF NOT o_text_editor IS INITIAL.
        CALL METHOD o_text_editor->free.
      ENDIF.
      IF o_editor_container IS NOT INITIAL.
        CALL METHOD o_editor_container->free.
      ENDIF.
      i_return = abap_true.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      i_return = abap_false.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0110  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'ZCA_TR_LOG-DEPENDENCY_CR'.
      IF zca_tr_log-cr_check = abap_true.
        screen-input = '1'.
        screen-invisible = '0'.
      ELSE.
        screen-input = '0'.
        screen-invisible = '1'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0120  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0120 OUTPUT.
  LOOP AT SCREEN.
     IF screen-name = 'ZCA_TR_LOG-INCIDENT_NO'.
      IF zca_tr_log-incident_check = abap_true.
        screen-input = '1'.
        screen-invisible = '0'.
      ELSE.
        screen-input = '0'.
        screen-invisible = '1'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0130 OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'ZCA_TR_LOG-OTHERS_DES'.
      IF zca_tr_log-others_chk = abap_true.
        screen-input = '1'.
        screen-invisible = '0'.
      ELSE.
        screen-input = '0'.
        screen-invisible = '1'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
