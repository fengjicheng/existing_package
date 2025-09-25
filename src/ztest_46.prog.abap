*&---------------------------------------------------------------------*
*& Report  ZTEST_46
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztest_46.
INCLUDE ztest_47.
SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr UP TO 10 ROWS.
SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr2 UP TO 10 ROWS.

WRITE : 'DISPLAY TEST'.
WRITE : 'DISPLAY TEST'.
WRITE : 'DISPLAY TEST'.
WRITE : 'DISPLAY TEST'.
