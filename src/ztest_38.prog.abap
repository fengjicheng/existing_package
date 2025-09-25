*&---------------------------------------------------------------------*
*& Report  ZTEST_38
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztest_38.

INCLUDE ztest_37.
*
SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr UP TO 10 ROWS.
**SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr2 UP TO 10 ROWS.
*
*WRITE : 'DISPLAY TEST'.
WRITE : 'DISPLAY TEST'.
