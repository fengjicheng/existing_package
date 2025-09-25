*&---------------------------------------------------------------------*
*& Report  ZTEST_36
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztest_36.

INCLUDE ztest_37.
**
SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr UP TO 10 ROWS.
**SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr2 UP TO 10 ROWS.
*
WRITE : 'DISPLAY TEST'.
WRITE : 'DISPLAY TEST'.
*WRITE : 'DISPLAY TEST'.

DATA:lv_lifnr TYPE lifnr,
     lv_date  TYPE angdt_v,
     lv_year  TYPE char4.
SELECT-OPTIONS:s_lifnr FOR lv_lifnr OBLIGATORY,
               s_date  FOR lv_date,
               s_year  FOR lv_year.
