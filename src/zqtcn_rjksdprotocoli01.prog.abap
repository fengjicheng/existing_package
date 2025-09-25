*----------------------------------------------------------------------*
***INCLUDE RJKSDPROTOCOLI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       Benutzerinteraktion auf Screen 0100
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE okcode.
    WHEN con_fcode_select.
      PERFORM select_data.
      PERFORM show_data_overview_on_screen.
    WHEN con_fcode_save.
      PERFORM save.
    WHEN con_fcode_refresh.
      PERFORM refresh.
    WHEN con_fcode_back.
      PERFORM cancel.
    WHEN con_fcode_exit.
      PERFORM exit.
    WHEN con_fcode_show_overview.
      PERFORM show_overview.
    WHEN con_fcode_show_detail.
      PERFORM show_detail.
    WHEN con_fcode_hide_overview.
      PERFORM hide_overview.
    WHEN con_fcode_hide_detail.
      PERFORM hide_detail.
  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  exit_command_0100  INPUT
*&---------------------------------------------------------------------*
*       Exitcommands auf dem Screen 0100
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE okcode.
    WHEN con_fcode_cancel.
      PERFORM cancel.
  ENDCASE.
ENDMODULE.                 " exit_command_0100  INPUT
