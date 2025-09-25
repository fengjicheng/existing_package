FUNCTION zqtc_bp_custom_fields_zvic01_o.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_BP_CUSTOM_FIELDSF01 (Sub-routines)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
  DATA:
    li_knvv TYPE STANDARD TABLE OF knvv INITIAL SIZE 0.

* step 1: receive data from xo
  IF cvi_bdt_adapter=>get_current_sales_area( ) IS INITIAL.
    CLEAR: knvv.
  ELSE.
    cvi_bdt_adapter=>data_pbo_with_sales_area(
     EXPORTING
       i_table_name = c_tab_knvv
     IMPORTING
       e_data_table = li_knvv[]
   ).
    IF li_knvv[] IS INITIAL.
      CLEAR: knvv.
    ELSE.
      READ TABLE li_knvv INTO knvv INDEX 1.
      IF sy-subrc NE 0.
        CLEAR: knvv.
      ENDIF.
    ENDIF.
  ENDIF.

  IF cvi_bdt_adapter=>get_activity( ) EQ cvi_bdt_adapter=>activity_display.
    v_activity = c_display.
  ENDIF.

  v_cntrl_bp = abap_true.

ENDFUNCTION.
