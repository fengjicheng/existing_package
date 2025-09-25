*&---------------------------------------------------------------------*
*& Report  ZTEST_49
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztest_49.


INCLUDE ztest_37.

SELECT matnr FROM mara INTO TABLE i_matnr  UP TO 10 ROWS.
**SELECT matnr FROM mara INTO T.ABLE i_matnr  UP TO 20 ROWS.
SELECT matnr FROM mara INTO TABLE i_matnr  UP TO 20 ROWS.
