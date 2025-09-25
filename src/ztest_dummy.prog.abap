*&---------------------------------------------------------------------*
*& Report  ZTEST_DUMMY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_DUMMY.

INCLUDE ZTEST_37.

select matnr FROM mara Into TABLE i_matnr UP TO 10 ROWS.
*select matnr FROM mara Into TABLE i_matnr UP TO 10 ROWS.
*select matnr FROM mara Into TABLE i_matnr UP TO 10 ROWS.
