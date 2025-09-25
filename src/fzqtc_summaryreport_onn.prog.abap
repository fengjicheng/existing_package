*&---------------------------------------------------------------------*
*&  Include           FZQTC_SUMMARYREPORT_ONN
*&---------------------------------------------------------------------*

MODULE status_2000 OUTPUT.
  SET PF-STATUS 'STATUS2000'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE create_grid_data OUTPUT.

  PERFORM fill_data_to_grid.            " Filling itab data to ALV

ENDMODULE.

FORM fill_data_to_grid.

  DATA : lv_fieldname(10),
         lv_fieldnr(2)    TYPE n,
         lv_count         TYPE i.

  CREATE OBJECT v_summary_alv_grid
    EXPORTING
      i_parent = cl_gui_custom_container=>screen0.

  " Layout properties
  st_layout-stylefname = 'CELL'.
  st_layout-no_headers = 'X'.
  st_layout-cwidth_opt = ' '.
  st_layout-no_toolbar = 'X'.

  REFRESH i_fieldcatalog.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_internal_tabname     = 'I_SUMMARY_DATA'
    CHANGING
      ct_fieldcat            = i_fieldcatalog
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  DO 32 TIMES.
    CLEAR st_cat.
    lv_fieldnr = sy-index.
    st_cat-col_pos = sy-index.
    CONCATENATE 'FIELD' lv_fieldnr INTO lv_fieldname.
    st_cat-fieldname = lv_fieldname.
    st_cat-tabname   = '1'.
    st_cat-datatype  = 'CHAR'.
    st_cat-inttype   = 'C'.
    st_cat-intlen    = 50.
    IF sy-index > 1.
      st_cat-outputlen    = 10.
    ELSE.
      st_cat-outputlen    = 10.
      st_cat-key        = 'X'.
      st_cat-fix_column = 'X'.
    ENDIF.
    st_cat-reptext   = lv_fieldname.
    st_cat-scrtext_l = lv_fieldname.
    st_cat-scrtext_m = lv_fieldname.
    st_cat-scrtext_s = lv_fieldname.
    st_cat-scrtext_l = lv_fieldname.
    APPEND st_cat TO i_fieldcatalog.
  ENDDO.

  PERFORM f_report_headers.     " Report Headers
  PERFORM f_output_data.        " Assign data to report output

  CALL METHOD v_summary_alv_grid->set_table_for_first_display     " Display ALV output
    EXPORTING
      is_variant      = st_variant
      i_save          = v_save
      is_layout       = st_layout
    CHANGING
      it_fieldcatalog = i_fieldcatalog
      it_outtab       = i_summary_data.

  " Output grid format
  PERFORM f_output_grid_format.         " Output grid format


  "" Copy 2nd row related data to specific data.
  REFRESH i_year.
  READ TABLE i_summary_data ASSIGNING <gfs_summary_data> INDEX 2.
  IF sy-subrc EQ 0.
    st_year = <gfs_summary_data>.
    APPEND st_year TO i_year.
  ENDIF.

  " Get lineitem detail from 3rd line
  CLEAR lv_count.
  LOOP AT i_summary_data ASSIGNING <gfs_summary_data>.
    lv_count = lv_count + 1.
    IF lv_count = 3.
      EXIT.
    ELSE.
      DELETE i_summary_data INDEX sy-tabix.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_report_headers.

  APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
  <gfs_summary_data>-field01 = 'Month'.
  <gfs_summary_data>-field02 = 'Subscription Total (Sales)'.
  <gfs_summary_data>-field04 = 'Offline Society members total (JDR) (From JDR Feed into SAP)'.
  <gfs_summary_data>-field06 = 'BIOS members total  (from JDR feed into SAP)'.
  <gfs_summary_data>-field08 = 'Conferences & exhibitions total (From PO)'.
  <gfs_summary_data>-field10 = 'Author copies (Main Lables) (Includes Subs and Sales Orders)'.
  <gfs_summary_data>-field12 = 'Author copies (Back Orders) (Includes Subs and Sales Orders)'.
  <gfs_summary_data>-field14 = 'Bulk orders (Main Lables Sales Orders) (EMLOs)'.
  <gfs_summary_data>-field16 = 'Bulk orders (Back Orders Sales) (EBLOs)'.
  <gfs_summary_data>-field18 = 'Back orders (Sales Data)'.
  <gfs_summary_data>-field20 = 'Total Sales (Main Lables)'.
  <gfs_summary_data>-field22 = 'PO (Print Run) Quantity'.
  <gfs_summary_data>-field24 = 'Total (Purchase Qty – Sales Qty)'.
  <gfs_summary_data>-field26 = 'Year on Year Difference (Sales & Purchase)'.
  CONCATENATE 'PO (Print Run) Year on Year Difference (' p_year '&' v_previousyear ')' INTO <gfs_summary_data>-field27 SEPARATED BY space.
  v_headername = <gfs_summary_data>-field27.      " Assign Header name to global varible to pass to excel file header
  <gfs_summary_data>-field28 = ''.
  <gfs_summary_data>-field29 = 'SOH'.

  APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
  <gfs_summary_data>-field02 = v_previousyear.
  <gfs_summary_data>-field03 = p_year.
  <gfs_summary_data>-field04 = v_previousyear.
  <gfs_summary_data>-field05 = p_year.
  <gfs_summary_data>-field06 = v_previousyear.
  <gfs_summary_data>-field07 = p_year.
  <gfs_summary_data>-field08 = v_previousyear.
  <gfs_summary_data>-field09 = p_year.
  <gfs_summary_data>-field10 = v_previousyear.
  <gfs_summary_data>-field11 = p_year.
  <gfs_summary_data>-field12 = v_previousyear.
  <gfs_summary_data>-field13 = p_year.
  <gfs_summary_data>-field14 = v_previousyear.
  <gfs_summary_data>-field15 = p_year.
  <gfs_summary_data>-field16 = v_previousyear.
  <gfs_summary_data>-field17 = p_year.
  <gfs_summary_data>-field18 = v_previousyear.
  <gfs_summary_data>-field19 = p_year.
  <gfs_summary_data>-field20 = v_previousyear.
  <gfs_summary_data>-field21 = p_year.
  <gfs_summary_data>-field22 = v_previousyear.
  <gfs_summary_data>-field23 = p_year.
  <gfs_summary_data>-field24 = v_previousyear.
  <gfs_summary_data>-field25 = p_year.
  <gfs_summary_data>-field26 = 'Units'.
  CONCATENATE v_previousyear 'Vs' p_year INTO <gfs_summary_data>-field27 SEPARATED BY space.
  CONCATENATE v_previousyear '(Initial Stock)' INTO <gfs_summary_data>-field29 SEPARATED BY space.
  CONCATENATE p_year '(Initial Stock)' INTO <gfs_summary_data>-field30 SEPARATED BY space.
  CONCATENATE v_previousyear '(as of 1st May' p_year ')' INTO <gfs_summary_data>-field31 SEPARATED BY space.
  CONCATENATE p_year '(as of 1st May' p_year ')' INTO <gfs_summary_data>-field32 SEPARATED BY space.

ENDFORM.

FORM f_merge_vertically.

  REFRESH i_merge.

  st_merge-col_id    = 1.
  st_merge-outputlen = 2.
  APPEND st_merge TO i_merge.

  CALL METHOD v_summary_alv_grid->meth_set_merge_vert
    EXPORTING
      i_row            = 1
    CHANGING
      ch_tab_col_merge = i_merge.

  st_style-style   = alv_style_font_bold
                   + alv_style_align_center_center
                   + alv_style_color_heading.

  CALL METHOD v_summary_alv_grid->meth_set_cell_style
    EXPORTING
      i_row   = 1
      i_col   = 1
      i_style = st_style-style.

ENDFORM.

FORM f_select_cells USING fp_id
                          fp_len.

  st_merge-col_id    = fp_id.
  st_merge-outputlen = fp_len.
  APPEND st_merge TO i_merge.

ENDFORM.

FORM f_merge_horizontally USING fp_r
                                fp_i_merge.

  CALL METHOD v_summary_alv_grid->meth_set_merge_horiz
    EXPORTING
      i_row            = fp_r
    CHANGING
      ch_tab_col_merge = fp_i_merge.

ENDFORM.

FORM f_set_cell_style USING fp_r
                            fp_c
                            fp_st_style.

  CALL METHOD v_summary_alv_grid->meth_set_cell_style
    EXPORTING
      i_row   = fp_r
      i_col   = fp_c
      i_style = fp_st_style.

ENDFORM.

FORM f_align_cells .

  DATA lv_index TYPE i.

  st_style-style     = alv_style_align_right_center.

  CLEAR lv_index.
  lv_index = 1.
  DO 31 TIMES.
    lv_index = lv_index + 1.
    PERFORM f_set_cell_style USING '' lv_index st_style-style.
  ENDDO.

ENDFORM.

FORM f_cell_colouring .

  DATA lv_index TYPE i.

  st_style-style     =  alv_style_font_bold + alv_style_color_total.

  CLEAR lv_index.
  lv_index = 1.
  DO 31 TIMES.
    lv_index = lv_index + 1.
    PERFORM f_set_cell_style USING 2 lv_index st_style-style.
    PERFORM f_set_cell_style USING 15 lv_index st_style-style.
  ENDDO.

ENDFORM.

FORM f_output_data.

  FIELD-SYMBOLS : <lfs_subs_total>         TYPE ty_sales_total,
                  <lfs_author_copies_main> TYPE ty_sales_total,
                  <lfs_author_copies_back> TYPE ty_sales_total,
                  <lfs_bulk_orders_main>   TYPE ty_sales_total,
                  <lfs_bulk_orders_back>   TYPE ty_sales_total,
                  <lfs_back_orders>        TYPE ty_sales_total,
                  <lfs_jdrsum>             TYPE zcds_jpat_jdrsum,
                  <lfs_biossum>            TYPE zcds_jpat_biossm,
                  <lfs_posum>              TYPE ty_posum,
                  <lfs_isohsm>             TYPE zcds_jpat_isohsm,
                  <lfs_sohsum>             TYPE zcds_jpat_sohsum,
                  <lfs_nbposumary>         TYPE ty_nbposum.

  DATA : lv_month(2) TYPE n.

  DATA : lv_totalqty2(16)  TYPE c,
         lv_totalqty3(16)  TYPE c,
         lv_totalqty4(16)  TYPE c,
         lv_totalqty5(16)  TYPE c,
         lv_totalqty6(16)  TYPE c,
         lv_totalqty7(16)  TYPE c,
         lv_totalqty8(16)  TYPE c,
         lv_totalqty9(16)  TYPE c,
         lv_totalqty10(16) TYPE c,
         lv_totalqty11(16) TYPE c,
         lv_totalqty12(16) TYPE c,
         lv_totalqty13(16) TYPE c,
         lv_totalqty14(16) TYPE c,
         lv_totalqty15(16) TYPE c,
         lv_totalqty16(16) TYPE c,
         lv_totalqty17(16) TYPE c,
         lv_totalqty18(16) TYPE c,
         lv_totalqty19(16) TYPE c,
         lv_totalqty20(16) TYPE c,
         lv_totalqty21(16) TYPE c,
         lv_totalqty22(16) TYPE c,
         lv_totalqty23(16) TYPE c,
         lv_totalqty24(16) TYPE c,
         lv_totalqty25(16) TYPE c,
         lv_totalqty26(16) TYPE c,
         lv_totalqty27(16) TYPE c,
         lv_totalqty28(16) TYPE c,
         lv_totalqty29(16) TYPE c,
         lv_totalqty30(16) TYPE c,
         lv_totalqty31(16) TYPE c,
         lv_totalqty32(16) TYPE c,
         lv_absolute24(16) TYPE c,
         lv_absolute25(16) TYPE c.

  lv_month = 0.
  DO 13 TIMES.    " For year + total line
    lv_month = lv_month + 1.
    FREE : lv_absolute24 , lv_absolute25.
    CASE lv_month.
      WHEN 01.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'January'.
      WHEN 02.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'February'.
      WHEN 03.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'March'.
      WHEN 04.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'April'.
      WHEN 05.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'May'.
      WHEN 06.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'June'.
      WHEN 07.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'July'.
      WHEN 08.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'August'.
      WHEN 09.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'September'.
      WHEN 10.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'October'.
      WHEN 11.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'November'.
      WHEN 12.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = 'December'.
      WHEN 13.        " Total qty Line to final output
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field02 =  lv_totalqty2.
        <gfs_summary_data>-field03  = lv_totalqty3.
        <gfs_summary_data>-field04  = lv_totalqty4.
        <gfs_summary_data>-field05  = lv_totalqty5.
        <gfs_summary_data>-field06  = lv_totalqty6.
        <gfs_summary_data>-field07  = lv_totalqty7.
        <gfs_summary_data>-field08  = lv_totalqty8.
        <gfs_summary_data>-field09  = lv_totalqty9.
        <gfs_summary_data>-field10  = lv_totalqty10.
        <gfs_summary_data>-field11  = lv_totalqty11.
        <gfs_summary_data>-field12  = lv_totalqty12.
        <gfs_summary_data>-field13  = lv_totalqty13.
        <gfs_summary_data>-field14  = lv_totalqty14.
        <gfs_summary_data>-field15  = lv_totalqty15.
        <gfs_summary_data>-field16  = lv_totalqty16.
        <gfs_summary_data>-field17  = lv_totalqty17.
        <gfs_summary_data>-field18  = lv_totalqty18.
        <gfs_summary_data>-field19  = lv_totalqty19.
        <gfs_summary_data>-field20  = lv_totalqty20.
        <gfs_summary_data>-field21  = lv_totalqty21.
        <gfs_summary_data>-field22  = lv_totalqty22.
        <gfs_summary_data>-field23  = lv_totalqty23.
        <gfs_summary_data>-field24  = lv_totalqty24.
        <gfs_summary_data>-field25  = lv_totalqty25.
        <gfs_summary_data>-field26  = lv_totalqty26.
        <gfs_summary_data>-field27  = lv_totalqty27.
        <gfs_summary_data>-field28 = ''.
        CONDENSE <gfs_summary_data>-field28.
        <gfs_summary_data>-field29  = lv_totalqty29.
        <gfs_summary_data>-field30  = lv_totalqty30.
        <gfs_summary_data>-field31  = lv_totalqty31.
        <gfs_summary_data>-field32  = lv_totalqty32.
        EXIT.
    ENDCASE.


    " Subscription Total
    IF is_subs_total IS NOT INITIAL.
      READ TABLE is_subs_total ASSIGNING <lfs_subs_total> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0 .
        WRITE <lfs_subs_total>-target_qty TO <gfs_summary_data>-field02 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_subs_total>.
      ELSE.
        <gfs_summary_data>-field02 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field02.
      lv_totalqty2 = lv_totalqty2 + <gfs_summary_data>-field02.

      READ TABLE is_subs_total  ASSIGNING <lfs_subs_total> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_subs_total>-target_qty TO <gfs_summary_data>-field03 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_subs_total>.
      ELSE.
        <gfs_summary_data>-field03 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field03.
      lv_totalqty3 = lv_totalqty3 + <gfs_summary_data>-field03.
    ELSE.
      <gfs_summary_data>-field02 = 0.
      CONDENSE <gfs_summary_data>-field02.
      lv_totalqty2 = lv_totalqty2 + <gfs_summary_data>-field02.

      <gfs_summary_data>-field03 = 0.
      CONDENSE <gfs_summary_data>-field03.
      lv_totalqty3 = lv_totalqty3 + <gfs_summary_data>-field03.
    ENDIF.


    " JDR QTY
    IF i_view_jdrsum IS NOT INITIAL.
      READ TABLE i_view_jdrsum ASSIGNING <lfs_jdrsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_jdrsum>-jdr_quantity TO <gfs_summary_data>-field04 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_jdrsum>.
      ELSE.
        <gfs_summary_data>-field04 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field04.
      lv_totalqty4 = lv_totalqty4 + <gfs_summary_data>-field04.

      READ TABLE i_view_jdrsum ASSIGNING <lfs_jdrsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_jdrsum>-jdr_quantity TO <gfs_summary_data>-field05 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_jdrsum>.
      ELSE.
        <gfs_summary_data>-field05 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field05.
      lv_totalqty5 = lv_totalqty5 + <gfs_summary_data>-field05.
    ELSE.
      <gfs_summary_data>-field04 = 0.
      CONDENSE <gfs_summary_data>-field04.
      lv_totalqty4 = lv_totalqty4 + <gfs_summary_data>-field04.

      <gfs_summary_data>-field05 = 0.
      CONDENSE <gfs_summary_data>-field05.
      lv_totalqty5 = lv_totalqty5 + <gfs_summary_data>-field05.
    ENDIF.


    " BIOS QTY
    IF i_view_biossum IS NOT INITIAL.
      READ TABLE i_view_biossum ASSIGNING <lfs_biossum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_biossum>-bios_quantity TO <gfs_summary_data>-field06 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_biossum>.
      ELSE.
        <gfs_summary_data>-field06 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field06.
      lv_totalqty6 = lv_totalqty6 + <gfs_summary_data>-field06.

      READ TABLE i_view_biossum ASSIGNING <lfs_biossum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_biossum>-bios_quantity TO <gfs_summary_data>-field07 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_biossum>.
      ELSE.
        <gfs_summary_data>-field07 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field07.
      lv_totalqty7 = lv_totalqty7 + <gfs_summary_data>-field07.
    ELSE.
      <gfs_summary_data>-field06 = 0.
      CONDENSE <gfs_summary_data>-field06.
      lv_totalqty6 = lv_totalqty6 + <gfs_summary_data>-field06.

      <gfs_summary_data>-field07 = 0.
      CONDENSE <gfs_summary_data>-field07.
      lv_totalqty7 = lv_totalqty7 + <gfs_summary_data>-field07.
    ENDIF.


    " Printer QTY
    IF i_view_posum IS NOT INITIAL.
      READ TABLE i_view_posum ASSIGNING <lfs_posum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_posum>-printer_po_conference TO <gfs_summary_data>-field08 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_posum>.
      ELSE.
        <gfs_summary_data>-field08 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field08.
      lv_totalqty8 = lv_totalqty8 + <gfs_summary_data>-field08.

      READ TABLE i_view_posum ASSIGNING <lfs_posum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_posum>-printer_po_conference TO <gfs_summary_data>-field09 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_posum>.
      ELSE.
        <gfs_summary_data>-field09 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field09.
      lv_totalqty9 = lv_totalqty9 + <gfs_summary_data>-field09.
    ELSE.
      <gfs_summary_data>-field08 = 0.
      CONDENSE <gfs_summary_data>-field08.
      lv_totalqty8 = lv_totalqty8 + <gfs_summary_data>-field08.

      <gfs_summary_data>-field09 = 0.
      CONDENSE <gfs_summary_data>-field09.
      lv_totalqty9 = lv_totalqty9 + <gfs_summary_data>-field09.
    ENDIF.


    " Author copies (Main Lables) (Includes Subs and Sales Orders)
    IF is_author_copies_main IS NOT INITIAL.
      READ TABLE is_author_copies_main ASSIGNING <lfs_author_copies_main> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_author_copies_main>-target_qty TO <gfs_summary_data>-field10 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_author_copies_main>.
      ELSE.
        <gfs_summary_data>-field10 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field10.
      lv_totalqty10 = lv_totalqty10 + <gfs_summary_data>-field10.

      READ TABLE is_author_copies_main ASSIGNING <lfs_author_copies_main> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_author_copies_main>-target_qty TO <gfs_summary_data>-field11 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_author_copies_main>.
      ELSE.
        <gfs_summary_data>-field11 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field11.
      lv_totalqty11 = lv_totalqty11 + <gfs_summary_data>-field11.
    ELSE.
      <gfs_summary_data>-field10 = 0.
      CONDENSE <gfs_summary_data>-field10.
      lv_totalqty10 = lv_totalqty10 + <gfs_summary_data>-field10.

      <gfs_summary_data>-field11 = 0.
      CONDENSE <gfs_summary_data>-field11.
      lv_totalqty11 = lv_totalqty11 + <gfs_summary_data>-field11.
    ENDIF.


    " Author copies (Back Orders) (Includes Subs and Sales Orders)
    IF is_author_copies_back IS NOT INITIAL.
      READ TABLE is_author_copies_back  ASSIGNING <lfs_author_copies_back> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_author_copies_back>-target_qty TO <gfs_summary_data>-field12 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_author_copies_back>.
      ELSE.
        <gfs_summary_data>-field12 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field12.
      lv_totalqty12 = lv_totalqty12 + <gfs_summary_data>-field12.

      READ TABLE is_author_copies_back ASSIGNING <lfs_author_copies_back> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_author_copies_back>-target_qty TO <gfs_summary_data>-field13 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_author_copies_back>.
      ELSE.
        <gfs_summary_data>-field13 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field13.
      lv_totalqty13 = lv_totalqty13 + <gfs_summary_data>-field13.
    ELSE.
      <gfs_summary_data>-field12 = 0.
      CONDENSE <gfs_summary_data>-field12.
      lv_totalqty12 = lv_totalqty12 + <gfs_summary_data>-field12.

      <gfs_summary_data>-field13 = 0.
      CONDENSE <gfs_summary_data>-field13.
      lv_totalqty13 = lv_totalqty13 + <gfs_summary_data>-field13.
    ENDIF.


    " Bulk orders (Main Lables Sales Orders) (EMLOs)
    IF is_bulk_orders_main IS NOT INITIAL.
      READ TABLE is_bulk_orders_main ASSIGNING <lfs_bulk_orders_main> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_bulk_orders_main>-target_qty TO <gfs_summary_data>-field14 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_bulk_orders_main>.
      ELSE.
        <gfs_summary_data>-field14 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field14.
      lv_totalqty14 = lv_totalqty14 + <gfs_summary_data>-field14.

      READ TABLE is_bulk_orders_main ASSIGNING <lfs_bulk_orders_main> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_bulk_orders_main>-target_qty TO <gfs_summary_data>-field15 DECIMALS 0 NO-GROUPING.
        UNASSIGN  <lfs_bulk_orders_main>.
      ELSE.
        <gfs_summary_data>-field15 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field15.
      lv_totalqty15 = lv_totalqty15 + <gfs_summary_data>-field15.
    ELSE.
      <gfs_summary_data>-field14 = 0.
      CONDENSE <gfs_summary_data>-field14.
      lv_totalqty14 = lv_totalqty14 + <gfs_summary_data>-field14.

      <gfs_summary_data>-field15 = 0.
      CONDENSE <gfs_summary_data>-field15.
      lv_totalqty15 = lv_totalqty15 + <gfs_summary_data>-field15.
    ENDIF.


    " Bulk orders (Back Orders Sales) (EBLOs)
    IF is_bulk_orders_back IS NOT INITIAL.
      READ TABLE is_bulk_orders_back ASSIGNING <lfs_bulk_orders_back> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_bulk_orders_back>-target_qty TO <gfs_summary_data>-field16 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_bulk_orders_back>.
      ELSE.
        <gfs_summary_data>-field16 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field16.
      lv_totalqty16 = lv_totalqty16 + <gfs_summary_data>-field16.

      READ TABLE is_bulk_orders_back ASSIGNING <lfs_bulk_orders_back> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_bulk_orders_back>-target_qty TO <gfs_summary_data>-field17 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_bulk_orders_back>.
      ELSE.
        <gfs_summary_data>-field17 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field17.
      lv_totalqty17 = lv_totalqty17 + <gfs_summary_data>-field17.
    ELSE.
      <gfs_summary_data>-field16 = 0.
      CONDENSE <gfs_summary_data>-field16.
      lv_totalqty16 = lv_totalqty16 + <gfs_summary_data>-field16.

      <gfs_summary_data>-field17 = 0.
      CONDENSE <gfs_summary_data>-field17.
      lv_totalqty17 = lv_totalqty17 + <gfs_summary_data>-field17.
    ENDIF.


    " Back orders (Sales Data)
    IF is_back_orders IS NOT INITIAL.
      READ TABLE is_back_orders ASSIGNING <lfs_back_orders> WITH KEY act_pub_year = v_previousyear act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_back_orders>-target_qty TO <gfs_summary_data>-field18 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_back_orders>.
      ELSE.
        <gfs_summary_data>-field18 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field18.
      lv_totalqty18 = lv_totalqty18 + <gfs_summary_data>-field18.

      READ TABLE is_back_orders ASSIGNING <lfs_back_orders> WITH KEY act_pub_year = p_year act_pub_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_back_orders>-target_qty TO <gfs_summary_data>-field19 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_back_orders>.
      ELSE.
        <gfs_summary_data>-field19 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field19.
      lv_totalqty19 = lv_totalqty19 + <gfs_summary_data>-field19.
    ELSE.
      <gfs_summary_data>-field18 = 0.
      CONDENSE <gfs_summary_data>-field18.
      lv_totalqty18 = lv_totalqty18 + <gfs_summary_data>-field18.

      <gfs_summary_data>-field19 = 0.
      CONDENSE <gfs_summary_data>-field19.
      lv_totalqty19 = lv_totalqty19 + <gfs_summary_data>-field19.
    ENDIF.


    "Total Sales (Main Lables)
    <gfs_summary_data>-field20 = <gfs_summary_data>-field02 + <gfs_summary_data>-field04 + <gfs_summary_data>-field08 + <gfs_summary_data>-field10
                                 + <gfs_summary_data>-field14.
    CONDENSE <gfs_summary_data>-field20.
    lv_totalqty20 = lv_totalqty20 + <gfs_summary_data>-field20.

    <gfs_summary_data>-field21 = <gfs_summary_data>-field03 + <gfs_summary_data>-field05 + <gfs_summary_data>-field09 + <gfs_summary_data>-field11
                                 + <gfs_summary_data>-field15.
    CONDENSE <gfs_summary_data>-field21.
    lv_totalqty21 = lv_totalqty21 + <gfs_summary_data>-field21.


    " Sum of NB type PO
    IF is_nbposumary IS NOT INITIAL.
      READ TABLE is_nbposumary ASSIGNING <lfs_nbposumary> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_nbposumary>-po_qty TO <gfs_summary_data>-field22 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_nbposumary>.
      ELSE.
        <gfs_summary_data>-field22 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field22.
      lv_totalqty22 = lv_totalqty22 + <gfs_summary_data>-field22.

      READ TABLE is_nbposumary ASSIGNING <lfs_nbposumary> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_nbposumary>-po_qty TO <gfs_summary_data>-field23 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_nbposumary>.
      ELSE.
        <gfs_summary_data>-field23 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field23.
      lv_totalqty23 = lv_totalqty23 + <gfs_summary_data>-field23.
    ELSE.
      <gfs_summary_data>-field22 = 0.
      CONDENSE <gfs_summary_data>-field22.
      lv_totalqty22 = lv_totalqty22 + <gfs_summary_data>-field22.

      <gfs_summary_data>-field23 = 0.
      CONDENSE <gfs_summary_data>-field23.
      lv_totalqty23 = lv_totalqty23 + <gfs_summary_data>-field23.
    ENDIF.


    " Total (Sales - Purchase) --> " Total (Purchase - Sales)
    <gfs_summary_data>-field24 =  <gfs_summary_data>-field22 - ( <gfs_summary_data>-field20 + <gfs_summary_data>-field06 + <gfs_summary_data>-field12
                                  + <gfs_summary_data>-field16 + <gfs_summary_data>-field18 ).
    CONDENSE <gfs_summary_data>-field24.
    lv_totalqty24 = lv_totalqty24 + <gfs_summary_data>-field24.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field24.
    " Check Previous year Total (Purchase - Sales) LT 0 then Converted as a absolute value
    IF <gfs_summary_data>-field24 LT 0.
      lv_absolute24 = <gfs_summary_data>-field24 * -1.
    ELSE.
      lv_absolute24 = <gfs_summary_data>-field24.
    ENDIF.
    CONDENSE lv_absolute24.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty24.

    <gfs_summary_data>-field25 =  <gfs_summary_data>-field23 - ( <gfs_summary_data>-field21 + <gfs_summary_data>-field07 + <gfs_summary_data>-field13
                                  + <gfs_summary_data>-field17 + <gfs_summary_data>-field19 ).
    CONDENSE <gfs_summary_data>-field25.
    lv_totalqty25 = lv_totalqty25 + <gfs_summary_data>-field25.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field25.
    " Check Previous year Total (Purchase - Sales) LT 0 then Converted as a absolute value
    IF <gfs_summary_data>-field25 LT 0.
      lv_absolute25 = <gfs_summary_data>-field25 * -1.
    ELSE.
      lv_absolute25 = <gfs_summary_data>-field25.
    ENDIF.
    CONDENSE lv_absolute25.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty25.


    " Difference
    "<gfs_summary_data>-field26 = <gfs_summary_data>-field25 - <gfs_summary_data>-field24.
    <gfs_summary_data>-field26 = lv_absolute25 - lv_absolute24.
    CONDENSE <gfs_summary_data>-field26.
    lv_totalqty26 = lv_totalqty26 + <gfs_summary_data>-field26.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field26.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty26.


    " PO (Print Run) - Difference
    <gfs_summary_data>-field27 = <gfs_summary_data>-field23 - <gfs_summary_data>-field22.
    CONDENSE <gfs_summary_data>-field27.
    lv_totalqty27 = lv_totalqty27 + <gfs_summary_data>-field27.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field27.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty27.


    <gfs_summary_data>-field28 = ''.
    CONDENSE <gfs_summary_data>-field28.

    " Initial Stock on hand
    IF i_view_isohsm  IS NOT INITIAL.
      READ TABLE i_view_isohsm ASSIGNING <lfs_isohsm> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_isohsm>-inital_soh_quantity TO <gfs_summary_data>-field29 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_isohsm>.
      ELSE.
        <gfs_summary_data>-field29 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field29.
      lv_totalqty29 = lv_totalqty29 + <gfs_summary_data>-field29.

      READ TABLE i_view_isohsm ASSIGNING <lfs_isohsm> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_isohsm>-inital_soh_quantity TO <gfs_summary_data>-field30 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_isohsm>.
      ELSE.
        <gfs_summary_data>-field30 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field30.
      lv_totalqty30 = lv_totalqty30 + <gfs_summary_data>-field30.
    ELSE.
      <gfs_summary_data>-field29 = 0.
      CONDENSE <gfs_summary_data>-field29.
      lv_totalqty29 = lv_totalqty29 + <gfs_summary_data>-field29.

      <gfs_summary_data>-field30 = 0.
      CONDENSE <gfs_summary_data>-field30.
      lv_totalqty30 = lv_totalqty30 + <gfs_summary_data>-field30.
    ENDIF.

    " Stock on hand
    IF  i_view_sohsum IS NOT INITIAL.
      READ TABLE i_view_sohsum ASSIGNING <lfs_sohsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_sohsum>-soh_qty TO <gfs_summary_data>-field31 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_sohsum>.
      ELSE.
        <gfs_summary_data>-field31 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field31.
      lv_totalqty31 = lv_totalqty31 + <gfs_summary_data>-field31.

      READ TABLE i_view_sohsum ASSIGNING <lfs_sohsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_sohsum>-soh_qty TO <gfs_summary_data>-field32 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_sohsum>.
      ELSE.
        <gfs_summary_data>-field32 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field32.
      lv_totalqty32 = lv_totalqty32 + <gfs_summary_data>-field32.
    ELSE.
      <gfs_summary_data>-field31 = 0.
      CONDENSE <gfs_summary_data>-field31.
      lv_totalqty31 = lv_totalqty31 + <gfs_summary_data>-field31.

      <gfs_summary_data>-field32 = 0.
      CONDENSE <gfs_summary_data>-field32.
      lv_totalqty32 = lv_totalqty32 + <gfs_summary_data>-field32.
    ENDIF.

  ENDDO.

ENDFORM.

FORM f_output_grid_format .

  "" Vertical Merge
  REFRESH i_merge.
  PERFORM f_merge_vertically.

  "" Horizontal merge (1st header line)
  CLEAR i_merge.
  PERFORM f_select_cells USING 2 3.
  PERFORM f_select_cells USING 4 5.
  PERFORM f_select_cells USING 6 7.
  PERFORM f_select_cells USING 8 9.
  PERFORM f_select_cells USING 10 11.
  PERFORM f_select_cells USING 12 13.
  PERFORM f_select_cells USING 14 15.
  PERFORM f_select_cells USING 16 17.
  PERFORM f_select_cells USING 18 19.
  PERFORM f_select_cells USING 20 21.
  PERFORM f_select_cells USING 22 23.
  PERFORM f_select_cells USING 24 25.
  PERFORM f_select_cells USING 26 26.
  PERFORM f_select_cells USING 27 27.
  PERFORM f_select_cells USING 29 32.

  PERFORM f_merge_horizontally USING 1 i_merge. " Merge 1st row

  " Set Cell styles
  st_style-style = alv_style_font_bold + alv_style_align_center_center + alv_style_color_heading.

  PERFORM f_set_cell_style USING 1 2  st_style-style.
  PERFORM f_set_cell_style USING 1 4  st_style-style.
  PERFORM f_set_cell_style USING 1 6  st_style-style.
  PERFORM f_set_cell_style USING 1 8  st_style-style.
  PERFORM f_set_cell_style USING 1 10 st_style-style.
  PERFORM f_set_cell_style USING 1 12 st_style-style.
  PERFORM f_set_cell_style USING 1 14 st_style-style.
  PERFORM f_set_cell_style USING 1 16 st_style-style.
  PERFORM f_set_cell_style USING 1 18 st_style-style.
  PERFORM f_set_cell_style USING 1 20 st_style-style.
  PERFORM f_set_cell_style USING 1 22 st_style-style.
  PERFORM f_set_cell_style USING 1 24 st_style-style.
  PERFORM f_set_cell_style USING 1 26 st_style-style.
  PERFORM f_set_cell_style USING 1 27 st_style-style.
  PERFORM f_set_cell_style USING 1 29 st_style-style.

  " Cell Formatting
  PERFORM f_align_cells.
  PERFORM f_cell_colouring.

  v_summary_alv_grid->meth_display( ).

ENDFORM.
