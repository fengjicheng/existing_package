*&---------------------------------------------------------------------*
*&  Include           ZPALLETTEST_SEL
*&---------------------------------------------------------------------*
************************************************************
*                     SELECTION SCREEN                     *
************************************************************
DATA : lv_pallet_no TYPE zpallet_no.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-009.
SELECT-OPTIONS : s_pallet FOR v_pallete.
PARAMETER:rad1 RADIOBUTTON GROUP rad USER-COMMAND frad1 DEFAULT 'X',
          rad2 RADIOBUTTON GROUP rad,
          rad3 RADIOBUTTON GROUP rad .
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN.
  IF s_pallet-low IS INITIAL.
    MESSAGE 'Enter Pallet Number'(012) TYPE 'E'.
  ELSE.
    SELECT SINGLE pallet_no
      FROM zpal_header
      INTO lv_pallet_no
      WHERE pallet_no = s_pallet-low.
    IF sy-subrc <> 0  .
      MESSAGE 'Enter Correct Pallet Number'(013) TYPE 'E'.
    ENDIF.
  ENDIF.
