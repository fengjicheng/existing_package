*&---------------------------------------------------------------------*
*& Report  ZQTCR_CLEAR_DIR_R115
* PROGRAM DESCRIPTION: Media Issue Cockpit directory clean-up
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* CREATION DATE:   23rd May, 2022
* OBJECT ID:  R115
* TRANSPORT NUMBER(S): ED2K927371
*&---------------------------------------------------------------------*
REPORT zqtcr_clear_dir_r115.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcr_clear_dir_r115_top.

*Include for Selection Screen
INCLUDE zqtcr_clear_dir_r115_sel.

*Include for Subroutines
INCLUDE zqtcr_clear_dir_r115_sub.

*&---------------------------------------------------------------------*
*&    initialization
*&---------------------------------------------------------------------*
INITIALIZATION.

* Populate the Contract Validity From date
  PERFORM f_get_constant_values.            " Fetch constant values

*&---------------------------------------------------------------------*
*&    start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  IF sy-batch = abap_false.
    PERFORM f_get_dir_list.
    PERFORM f_display_list.
  ENDIF.

  IF sy-batch = abap_true.
    PERFORM f_clear_dir.
  ENDIF.

*&---------------------------------------------------------------------*
*&    end-of-selection.
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  IF sy-batch = abap_true.
    PERFORM f_get_email.
    PERFORM f_send_email.
  ENDIF.
