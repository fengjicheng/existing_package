*&---------------------------------------------------------------------*
*&  Include  ZTEST_37
*&---------------------------------------------------------------------*

TYPES:BEGIN OF ty_test,
        matnr TYPE matnr,
      END OF ty_test.
DATA:i_matnr TYPE STANDARD TABLE OF ty_test.
