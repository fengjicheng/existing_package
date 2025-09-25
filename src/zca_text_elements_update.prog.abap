*&---------------------------------------------------------------------*
*& Report  ZCA_TEXT_ELEMENTS_UPDATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zca_text_elements_update.
"Include for the Declarations
INCLUDE zca_text_elements_update_top IF FOUND.

"Include for Selection Screen
INCLUDE zca_text_elements_update_scr IF FOUND.

"Include for the Subroutines.
INCLUDE zca_text_elements_update_f01.

***************************************************************
*         Seletion-Screen Block                               *
***************************************************************
*To get the file from presentation server.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_infl.

  PERFORM f_get_filename CHANGING p_infl.

***************************************************************
*         START-OF-SELECTION                                  *
***************************************************************
START-OF-SELECTION.
*put the file data into internal table to process further.
  PERFORM f_get_data_from_file.

END-OF-SELECTION.
  PERFORM f_text_update.
