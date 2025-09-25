*&---------------------------------------------------------------------*
*&  Include  ZTEST_INCLUDE1
*&---------------------------------------------------------------------*


DATA lv_string TYPE char25.

lv_string = 'Testing text element'(001).

IF sy-subrc = 0.
  " Nothing to do
ENDIF.
