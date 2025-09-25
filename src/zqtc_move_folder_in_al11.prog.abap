*&---------------------------------------------------------------------*
*&Report                 ZQTC_MOVE_FOLDER_IN_AL11
* PROGRAM DESCRIPTION:   Program is used to move folder from one to another in AL11
* DEVELOPER:             SGUDA
* CREATION DATE:         04/16/2019
* OBJECT ID:
* TRANSPORT NUMBER(S):   ED2K914922
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtc_move_folder_in_al11 NO STANDARD PAGE HEADING.
*- Top include
INCLUDE zqtc_move_folder_in_al11_top.
*- Selection-Screen
INCLUDE zqtc_move_folder_in_al11_sc01.
*- Subroutine
INCLUDE zqtc_move_folder_in_al11_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_sfile.
*--Value helo for source file
  PERFORM f_f4_file_path_source.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_tfile.
*--Value helo for target file
  PERFORM f_f4_file_path_target.

START-OF-SELECTION.

*- Move File from one place to another in AL11
  PERFORM f_move_file.
