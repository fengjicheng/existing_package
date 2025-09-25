FUNCTION zqtc_bp_custom_fields_zvic01_i.
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
    li_knvv        TYPE STANDARD TABLE OF knvv INITIAL SIZE 0.

  DATA:
    lst_sales_area TYPE cvis_sales_area.

  FIELD-SYMBOLS:
    <lst_knvv>     TYPE knvv.

  CHECK cvi_bdt_adapter=>is_direct_input_active( ) = abap_false.
  CHECK cvi_bdt_adapter=>get_current_sales_area( ) IS NOT INITIAL.
* step 1: update xo memory from dypro structure
  cvi_bdt_adapter=>get_current_bp_sales_data(
    EXPORTING
      i_table_name = c_tab_knvv
    IMPORTING
      e_data_table = li_knvv[]
  ).

  IF knvv IS NOT INITIAL.
    IF li_knvv[] IS INITIAL.
      APPEND INITIAL LINE TO li_knvv ASSIGNING <lst_knvv>.
      MOVE-CORRESPONDING knvv TO <lst_knvv>.

      lst_sales_area = cvi_bdt_adapter=>get_current_sales_area( ).
      <lst_knvv>-kunnr = cvi_bdt_adapter=>get_current_customer( ).
      <lst_knvv>-vkorg = lst_sales_area-sales_org.
      <lst_knvv>-vtweg = lst_sales_area-dist_channel.
      <lst_knvv>-spart = lst_sales_area-division.
    ELSE.
      READ TABLE li_knvv ASSIGNING <lst_knvv> INDEX 1.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING knvv TO <lst_knvv>.
      ENDIF.
    ENDIF.
  ENDIF.

  cvi_bdt_adapter=>data_pai_with_sales_area(
    i_table_name = c_tab_knvv
    i_data_new   = li_knvv[]
    i_validate   = abap_false
  ).

  CLEAR: knvv,
         v_cntrl_bp.

ENDFUNCTION.
