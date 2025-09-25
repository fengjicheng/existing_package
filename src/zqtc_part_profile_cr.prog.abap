*&---------------------------------------------------------------------*
*& Report  ZQTC_PART_PROFILE_CR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtc_part_profile_cr.

INCLUDE zqtc_part_profile_cr_top IF FOUND.

INCLUDE zqtc_part_profile_cr_sel IF FOUND.

INCLUDE zqtc_part_profile_cr_form IF FOUND.


INITIALIZATION.
  sscrfields-functxt_01 = 'Download Template'(001).
  IF sy-mandt = '130' AND ( sy-sysid = 'ED2' OR
      sy-sysid = 'ED1' OR sy-sysid = 'ES1' ).
  ELSE.
    MESSAGE 'This program should run in 130 only'(002) TYPE 'E'.
    RETURN.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

at SELECTION-SCREEN on p_file.
  PERFORM f_validate_file.

AT SELECTION-SCREEN.
  PERFORM f_get_file_template.

START-OF-SELECTION.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text       = 'Uploading...'
    EXCEPTIONS
      OTHERS     = 1.
  PERFORM f_get_data.
