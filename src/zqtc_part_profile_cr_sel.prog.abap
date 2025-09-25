*&---------------------------------------------------------------------*
*&  Include           ZQTC_PART_PROFILE_CR_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS: p_file  TYPE rlgrap-filename. "rlgrap-filename    " Local file for upload
PARAMETERS:p_test TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS:r1 TYPE c RADIOBUTTON GROUP g1,
           r2 TYPE c RADIOBUTTON GROUP g1,
           r3 TYPE c RADIOBUTTON GROUP g1,
           r4 TYPE c RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.
