*&---------------------------------------------------------------------*
*&  Include           ZQTC_MOVE_FOLDER_IN_AL11_SC01
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_sfile TYPE rlgrap-filename,
             p_tfile TYPE rlgrap-filename,
             p_user  TYPE syst_uname DEFAULT 'BC_RDWD'.
SELECTION-SCREEN END OF BLOCK b1.
