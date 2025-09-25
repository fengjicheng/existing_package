*&---------------------------------------------------------------------*
*& Report  ZTEST_48
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztest_48.
*TYPES:BEGIN OF ty_testq,
*        matnr TYPE matnr,
*      END OF ty_testq.
*
*
*DATA:i_matnr1 TYPE STANDARD TABLE OF ty_testq.
*SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE i_matnr1 UP TO 10 ROWS.
*WRITE : 'DISPLAY TEST'.

*CLASS cl_lc DEFINITION .
*  PUBLIC SECTION.
*    METHODS: get_data.
*ENDCLASS.
*
*CLASS cl_lc IMPLEMENTATION.
*  METHOD get_data.
*    WRITE: 'DIsplay'.
*  ENDMETHOD.
*ENDCLASS.
*
*DATA:obj TYPE REF TO cl_lc.
*START-OF-SELECTION.
*create OBJECT obj.
*call METHOD obj->get_data.

PARAMETERS x TYPE i.
CLASS lc_cl DEFINITION.
  PUBLIC SECTION.
    METHODS:constructor IMPORTING a TYPE i.
    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS lc_cl IMPLEMENTATION.

  METHOD constructor.

    WRITE:/ 'THIS IS INSTANCE CONSTRUCTOR' COLOR 7.
    WRITE:/ 'CONSTRUCTOR VALUE:',a.
  ENDMETHOD.
  METHOD class_constructor.
    WRITE:/ 'THIS IS STATIC CONSTRUCTOR' COLOR 5.
  ENDMETHOD.
ENDCLASS.
*
DATA :obj TYPE REF TO lc_cl.
*
START-OF-SELECTION.
  CREATE OBJECT obj
  exporting
     a = x.
