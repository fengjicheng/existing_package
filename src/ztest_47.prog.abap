*&---------------------------------------------------------------------*
*&  Include  ZTEST_47
*&---------------------------------------------------------------------*

TYPES:BEGIN OF ty_test,
        matnr TYPE matnr,
      END OF ty_test.

TYPES:BEGIN OF ty_testq,
        matnr TYPE matnr,
      END OF ty_testq.


DATA:i_matnr TYPE STANDARD TABLE OF ty_test.
DATA:i_matnr1 TYPE STANDARD TABLE OF ty_testq.
DATA:i_matnr2 TYPE STANDARD TABLE OF ty_testq.
