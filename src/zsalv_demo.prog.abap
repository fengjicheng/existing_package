*&---------------------------------------------------------------------*
*& Report  ZSALV_DEMO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zsalv_demo.

TABLES: marc.

DATA: BEGIN OF itab OCCURS 0.
        INCLUDE STRUCTURE marc.
      DATA: END OF itab.

*-- cl_salv_table data
DATA: gr_table     TYPE REF TO cl_salv_table.
DATA: gr_columns   TYPE REF TO cl_salv_columns_table.
DATA: gr_column    TYPE REF TO cl_salv_column_table.
DATA: gr_functions TYPE REF TO cl_salv_functions.
DATA: gr_events    TYPE REF TO cl_salv_events_table.

*-----------------
* class definition
*

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

    METHODS: on_link_click   FOR EVENT link_click OF
                cl_salv_events_table
      IMPORTING row column.
ENDCLASS.                    "lcl_handle_events DEFINITION


DATA: event_handler TYPE REF TO lcl_handle_events.

*---------------------
* class implimentation
*
CLASS lcl_handle_events IMPLEMENTATION.

  METHOD on_link_click.

    READ TABLE itab INTO itab INDEX row.
    CHECK sy-subrc = 0.

    CASE column.
      WHEN 'MATNR'.
        SET PARAMETER ID 'MAT'  FIELD itab-matnr.
        CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

    ENDCASE.


  ENDMETHOD.                    "on_link_click
ENDCLASS.                    "lcl_handle_events IMPLEMENTATION


*----- selection-screen
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_matnr FOR marc-matnr,
                s_werks FOR marc-werks.
SELECTION-SCREEN: END OF BLOCK a1.


*---- start-of-selection
START-OF-SELECTION.

*-- read data into internal table
  PERFORM get_data.

  CHECK itab[] IS NOT INITIAL.

*-- display the table itab with CL_SALV_TABLE

  PERFORM display_output.


END-OF-SELECTION.
*&---------------------------------------------------------------------

*&      Form  GET_DATA
*&---------------------------------------------------------------------

*       text
*----------------------------------------------------------------------

*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------

FORM get_data .


  SELECT * INTO CORRESPONDING FIELDS OF TABLE itab
    FROM marc
*    WHERE matnr IN s_matnr
    WHERE matnr EQ 'JFIRC'
      AND werks IN s_werks.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------

*&      Form  DISPLAY_OUTPUT
*&---------------------------------------------------------------------

*       text
*----------------------------------------------------------------------

*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------

FORM display_output .

  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = gr_table
    CHANGING
      t_table      = itab[].


*-- toolbar funtion
  gr_functions = gr_table->get_functions( ).
  gr_functions->set_all( abap_true ).

*-- column
  gr_columns = gr_table->get_columns( ).

  gr_column ?= gr_columns->get_column( 'MATNR' ).
  gr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

*-- events
  "events
  gr_events = gr_table->get_event( ).
  CREATE OBJECT event_handler.
  SET HANDLER event_handler->on_link_click FOR gr_events.


  gr_table->display( ).



ENDFORM.                    " DISPLAY_OUTPUT
