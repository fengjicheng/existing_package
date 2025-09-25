*----------------------------------------------------------------------*
* PROGRAM NAME: FZQTC_SUMMARYREPORT_EXTEND_ONN (Summary report PBO module)
* PROGRAM DESCRIPTION: Entrire Logic of Summary report PBO Module
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:
*
* Transport NO: ED2K916608
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/28/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

MODULE status_2000 OUTPUT.
  SET PF-STATUS 'STATUS2000'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE create_grid_data OUTPUT.

  PERFORM fill_data_to_grid.            " Filling itab data to ALV

ENDMODULE.

FORM fill_data_to_grid.

  DATA : lv_fieldname  TYPE char10,
         lv_fieldnr(2) TYPE n,
         lv_count      TYPE i.

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
  IF sy-subrc = 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  " Prepare Itab fields
  DO 39 TIMES.          " 32 changes as a 39 with ED2K916403
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
*** Begin of adding with ED2K916608 ***
  PERFORM f_format_ouput_numbers. " Format output numbers
*** End of adding with ED2K916608 ***

  CALL METHOD v_summary_alv_grid->set_table_for_first_display
    EXPORTING
      is_variant                    = st_variant
      i_save                        = v_save
      is_layout                     = st_layout
    CHANGING
      it_fieldcatalog               = i_fieldcatalog
      it_outtab                     = i_summary_data
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

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
  <gfs_summary_data>-field01 = text-068.        "'Month'.
  <gfs_summary_data>-field02 = text-054.        " 'Subs Copies (SAP)'.
  <gfs_summary_data>-field04 = text-055.        "'Society Offline Member - Main Labels (JFDS)'.
  <gfs_summary_data>-field06 = text-056.        "'Society Offline Member - Back Labels (JFDS)'.
  <gfs_summary_data>-field08 = text-057.        "'Conference Copies'.
  <gfs_summary_data>-field10 = text-058.        "'Author copies - Main Labels (SAP)'.
  <gfs_summary_data>-field12 = text-059.        "'Author copies - Back Labels (SAP)'.
  <gfs_summary_data>-field14 = text-060.        "'Bulk orders(including EMLOs)'.
  <gfs_summary_data>-field16 = text-061.        "'Bulk orders(including EBLOs)'.
  <gfs_summary_data>-field18 = text-062.        "'Back Labels (SAP)'.
*** Begin of Changes with ED2K916403 ***
  <gfs_summary_data>-field20 = text-090.        "'Receipt Qty(JRR)'.   " Description Changes with ED2K916608
  <gfs_summary_data>-field22 = text-063.        "'Total Sales (Main Labels)'.
  <gfs_summary_data>-field24 = text-064.        "'PO/Print Run Quantity (SAP)'.
*** Begin of Changes with ED2K916608 ***
  CONCATENATE text-069 p_year '&' v_previousyear ')' INTO <gfs_summary_data>-field26 SEPARATED BY space.     " 'PO (Print Run) Year on Year Difference
  v_headername = <gfs_summary_data>-field26.    " Assign Header name to global varible to pass to excel file header
  <gfs_summary_data>-field27 = text-097.        "'Printer dispatch (SAP PO qty-receipt from JFDS) Issue Level'.
  <gfs_summary_data>-field29 = text-091.        "'Total Print Run (C&E plus PO)'.
  <gfs_summary_data>-field31 = text-092.        "'Difference (PO minus Despatched)'.
  <gfs_summary_data>-field33 = text-093.        "'Difference (PO minus Despatched) %'.
  <gfs_summary_data>-field35 = ''.
  <gfs_summary_data>-field36 = text-067.        "'SOH'.
*** End of Changes with ED2K916608 ***
*** End of Changes with ED2K916403 ***

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
*** Begin of Changes with ED2K916403 ***
  <gfs_summary_data>-field20 = v_previousyear.
  <gfs_summary_data>-field21 = p_year.
  <gfs_summary_data>-field22 = v_previousyear.
  <gfs_summary_data>-field23 = p_year.
  <gfs_summary_data>-field24 = v_previousyear.
  <gfs_summary_data>-field25 = p_year.
*** Begin of Changes with ED2K916608 ***
  CONCATENATE p_year text-071 v_previousyear INTO <gfs_summary_data>-field26 SEPARATED BY space. " 'Vs'  " Change v_previousyear VS p_year to p_year VS v_previousyear
  <gfs_summary_data>-field27 = v_previousyear.
  <gfs_summary_data>-field28 = p_year.
  <gfs_summary_data>-field29 = v_previousyear.
  <gfs_summary_data>-field30 = p_year.
  <gfs_summary_data>-field31 = v_previousyear.
  <gfs_summary_data>-field32 = p_year.
  <gfs_summary_data>-field33 = v_previousyear.
  <gfs_summary_data>-field34 = p_year.
  CONCATENATE v_previousyear text-072 INTO <gfs_summary_data>-field36 SEPARATED BY space.        " 'Previous year(Initial Stock)'
  CONCATENATE p_year text-072 INTO <gfs_summary_data>-field37 SEPARATED BY space.                " 'Current (Initial Stock)'
  CONCATENATE v_previousyear text-073 p_year ')' INTO <gfs_summary_data>-field38 SEPARATED BY space.  " '((WHS till date SAP)'
  CONCATENATE p_year text-073 p_year ')' INTO <gfs_summary_data>-field39 SEPARATED BY space.      " '((WHS till date SAP)'
*** End of Changes with ED2K916608 ***
*** End of Changes with ED2K916403 ***

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
  DO 39 TIMES.        " 32 changes as a 39 with ED2K916403
    lv_index = lv_index + 1.
    PERFORM f_set_cell_style USING '' lv_index st_style-style.
  ENDDO.

ENDFORM.

FORM f_cell_colouring .

  DATA lv_index TYPE i.

  st_style-style     =  alv_style_font_bold + alv_style_color_total.

  CLEAR lv_index.
  lv_index = 1.
  DO 39 TIMES.          " 32 changes as a 39 with ED2K916403
    lv_index = lv_index + 1.
    PERFORM f_set_cell_style USING 2 lv_index st_style-style.
    PERFORM f_set_cell_style USING 15 lv_index st_style-style.
  ENDDO.

ENDFORM.

FORM f_output_data.

*** Note : Replace JDR,BIOS,POSum,Intial SOH,SOH detail with Sumarized Sorted table with ED2K916403

  FIELD-SYMBOLS : <lfs_subs_total>         TYPE ty_sales_total,
                  <lfs_author_copies_main> TYPE ty_sales_total,
                  <lfs_author_copies_back> TYPE ty_sales_total,
                  <lfs_bulk_orders_main>   TYPE ty_sales_total,
                  <lfs_bulk_orders_back>   TYPE ty_sales_total,
                  <lfs_back_orders>        TYPE ty_sales_total,
                  <lfs_jdrsum>             TYPE ty_jdr_total,           " Changed with ED2K916403
                  <lfs_biossum>            TYPE ty_bios_total,          " Changed with ED2K916403
                  <lfs_posum>              TYPE ty_po_total,            " Changed with ED2K916403
                  <lfs_isohsm>             TYPE ty_isoh_total,          " Changed with ED2K916403
                  <lfs_sohsum>             TYPE ty_soh_total,           " Changed with ED2K916403
                  <lfs_nbposumary>         TYPE ty_nbposum,
                  <lfs_jrrsum>             TYPE ty_jrr_total,           " Changed with ED2K916403
                  <lfs_podispatchsum>      TYPE ty_pdis_total.          " Changed with ED2K916608

  DATA : lv_month(2)  TYPE n,
         lv_loopcount TYPE i.

  DATA : lv_totalqty2  TYPE char16,
         lv_totalqty3  TYPE char16,
         lv_totalqty4  TYPE char16,
         lv_totalqty5  TYPE char16,
         lv_totalqty6  TYPE char16,
         lv_totalqty7  TYPE char16,
         lv_totalqty8  TYPE char16,
         lv_totalqty9  TYPE char16,
         lv_totalqty10 TYPE char16,
         lv_totalqty11 TYPE char16,
         lv_totalqty12 TYPE char16,
         lv_totalqty13 TYPE char16,
         lv_totalqty14 TYPE char16,
         lv_totalqty15 TYPE char16,
         lv_totalqty16 TYPE char16,
         lv_totalqty17 TYPE char16,
         lv_totalqty18 TYPE char16,
         lv_totalqty19 TYPE char16,
         lv_totalqty20 TYPE char16,
         lv_totalqty21 TYPE char16,
         lv_totalqty22 TYPE char16,
         lv_totalqty23 TYPE char16,
         lv_totalqty24 TYPE char16,
         lv_totalqty25 TYPE char16,
         lv_totalqty26 TYPE char16,
         lv_totalqty27 TYPE char16,
         lv_totalqty28 TYPE char16,
         lv_totalqty29 TYPE char16,
         lv_totalqty30 TYPE char16,
         lv_totalqty31 TYPE char16,
         lv_totalqty32 TYPE char16,
*** Begin of Change for ED2K916403 ***
         lv_totalqty33 TYPE char16,
         lv_totalqty34 TYPE char16,
         lv_totalqty35 TYPE char16,
         lv_totalqty36 TYPE char16,
         lv_totalqty37 TYPE char16,
         lv_totalqty38 TYPE char16,
         lv_totalqty39 TYPE char16.

  DATA : lv_percentage TYPE p DECIMALS 2.
*** End of Change for ED2K916403 ***


  lv_month = 0.
  lv_loopcount = 0.
  WHILE lv_loopcount =< 13.    " For year + total line
    lv_loopcount = lv_loopcount + 1.
    lv_month = lv_month + 1.
    CASE lv_month.
      WHEN 01.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-074." 'January'.
      WHEN 02.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-075."'February'.
      WHEN 03.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-076."'March'.
      WHEN 04.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-077."'April'.
      WHEN 05.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-078."'May'.
      WHEN 06.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-079."'June'.
      WHEN 07.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-080."'July'.
      WHEN 08.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-081."'August'.
      WHEN 09.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-082."'September'.
      WHEN 10.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-083."'October'.
      WHEN 11.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-084."'November'.
      WHEN 12.
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field01 = text-085."'December'.
      WHEN 13.        " Total qty Line to final output
        APPEND INITIAL LINE TO i_summary_data ASSIGNING <gfs_summary_data>.
        <gfs_summary_data>-field02 =  lv_totalqty2.
        <gfs_summary_data>-field03 = lv_totalqty3.
        <gfs_summary_data>-field04 = lv_totalqty4.
        <gfs_summary_data>-field05 = lv_totalqty5.
        <gfs_summary_data>-field06 = lv_totalqty6.
        <gfs_summary_data>-field07 = lv_totalqty7.
        <gfs_summary_data>-field08 = lv_totalqty8.
        <gfs_summary_data>-field09 = lv_totalqty9.
        <gfs_summary_data>-field10 = lv_totalqty10.
        <gfs_summary_data>-field11 = lv_totalqty11.
        <gfs_summary_data>-field12 = lv_totalqty12.
        <gfs_summary_data>-field13 = lv_totalqty13.
        <gfs_summary_data>-field14 = lv_totalqty14.
        <gfs_summary_data>-field15 = lv_totalqty15.
        <gfs_summary_data>-field16 = lv_totalqty16.
        <gfs_summary_data>-field17 = lv_totalqty17.
        <gfs_summary_data>-field18 = lv_totalqty18.
        <gfs_summary_data>-field19 = lv_totalqty19.
        <gfs_summary_data>-field20 = lv_totalqty20.
        <gfs_summary_data>-field21 = lv_totalqty21.
        <gfs_summary_data>-field22 = lv_totalqty22.
        <gfs_summary_data>-field23 = lv_totalqty23.
        <gfs_summary_data>-field24 = lv_totalqty24.
        <gfs_summary_data>-field25 = lv_totalqty25.
        <gfs_summary_data>-field26 = lv_totalqty26.
        <gfs_summary_data>-field27 = lv_totalqty27.
*** Begin of Changes with  ED2K916403 ***
        <gfs_summary_data>-field28 = lv_totalqty28.
        <gfs_summary_data>-field29 = lv_totalqty29.
        <gfs_summary_data>-field30 = lv_totalqty30.
        <gfs_summary_data>-field31 = lv_totalqty31.
        <gfs_summary_data>-field32 = lv_totalqty32.
        <gfs_summary_data>-field33 = lv_totalqty33.
        <gfs_summary_data>-field34 = lv_totalqty34.
        <gfs_summary_data>-field35 = ''.
        CONDENSE <gfs_summary_data>-field35 NO-GAPS.
        <gfs_summary_data>-field36 = lv_totalqty36.
        <gfs_summary_data>-field37 = lv_totalqty37.
        <gfs_summary_data>-field38 = lv_totalqty38.
        <gfs_summary_data>-field39 = lv_totalqty39.
*** End of Changes with  ED2K916403 ***
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
    IF is_jdrsum IS NOT INITIAL.
      READ TABLE is_jdrsum ASSIGNING <lfs_jdrsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_jdrsum>-jdr_quantity TO <gfs_summary_data>-field04 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_jdrsum>.
      ELSE.
        <gfs_summary_data>-field04 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field04.
      lv_totalqty4 = lv_totalqty4 + <gfs_summary_data>-field04.

      READ TABLE is_jdrsum ASSIGNING <lfs_jdrsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
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
    IF is_biossum IS NOT INITIAL.
      READ TABLE is_biossum ASSIGNING <lfs_biossum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_biossum>-bios_quantity TO <gfs_summary_data>-field06 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_biossum>.
      ELSE.
        <gfs_summary_data>-field06 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field06.
      lv_totalqty6 = lv_totalqty6 + <gfs_summary_data>-field06.

      READ TABLE is_biossum ASSIGNING <lfs_biossum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
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


    " Conference/Printer QTY
    IF is_posum IS NOT INITIAL.
      READ TABLE is_posum ASSIGNING <lfs_posum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_posum>-printer_po_conference TO <gfs_summary_data>-field08 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_posum>.
      ELSE.
        <gfs_summary_data>-field08 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field08.
      lv_totalqty8 = lv_totalqty8 + <gfs_summary_data>-field08.

      READ TABLE is_posum ASSIGNING <lfs_posum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
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


    " Receipt Qty(JRR)   " Description Change as 'Receipt Qty(JRR)' with ED2K916608
    IF is_jrrsum IS NOT INITIAL.
      READ TABLE is_jrrsum ASSIGNING <lfs_jrrsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_jrrsum>-jrr_quantity TO <gfs_summary_data>-field20 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_jrrsum>.
      ELSE.
        <gfs_summary_data>-field20 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field20.
      lv_totalqty20 = lv_totalqty20 + <gfs_summary_data>-field20.

      READ TABLE is_jrrsum ASSIGNING <lfs_jrrsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_jrrsum>-jrr_quantity TO <gfs_summary_data>-field21 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_jrrsum>.
      ELSE.
        <gfs_summary_data>-field21 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field21.
      lv_totalqty21 = lv_totalqty21 + <gfs_summary_data>-field21.
    ELSE.
      <gfs_summary_data>-field20 = 0.
      CONDENSE <gfs_summary_data>-field20.
      lv_totalqty20 = lv_totalqty20 + <gfs_summary_data>-field20.

      <gfs_summary_data>-field21 = 0.
      CONDENSE <gfs_summary_data>-field21.
      lv_totalqty21 = lv_totalqty21 + <gfs_summary_data>-field21.
    ENDIF.


*    "Total Sales (Main Lables)
*    <gfs_summary_data>-field22 = <gfs_summary_data>-field02 + <gfs_summary_data>-field04 + <gfs_summary_data>-field08 + <gfs_summary_data>-field10
*                                 + <gfs_summary_data>-field14 + <gfs_summary_data>-field20.
*    CONDENSE <gfs_summary_data>-field22.
*    lv_totalqty22 = lv_totalqty22 + <gfs_summary_data>-field22.
*
*    <gfs_summary_data>-field23 = <gfs_summary_data>-field03 + <gfs_summary_data>-field05 + <gfs_summary_data>-field09 + <gfs_summary_data>-field11
*                                 + <gfs_summary_data>-field15 + <gfs_summary_data>-field21.
*    CONDENSE <gfs_summary_data>-field23.
*    lv_totalqty23 = lv_totalqty23 + <gfs_summary_data>-field23.


    " Sum of NB type PO (PO/Print Run Quantity (SAP))
    IF is_nbposumary IS NOT INITIAL.
      READ TABLE is_nbposumary ASSIGNING <lfs_nbposumary> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_nbposumary>-po_qty TO <gfs_summary_data>-field24 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_nbposumary>.
      ELSE.
        <gfs_summary_data>-field24 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field24.
      lv_totalqty24 = lv_totalqty24 + <gfs_summary_data>-field24.

      READ TABLE is_nbposumary ASSIGNING <lfs_nbposumary> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_nbposumary>-po_qty TO <gfs_summary_data>-field25 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_nbposumary>.
      ELSE.
        <gfs_summary_data>-field25 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field25.
      lv_totalqty25 = lv_totalqty25 + <gfs_summary_data>-field25.
    ELSE.
      <gfs_summary_data>-field24 = 0.
      CONDENSE <gfs_summary_data>-field24.
      lv_totalqty24 = lv_totalqty24 + <gfs_summary_data>-field24.

      <gfs_summary_data>-field25 = 0.
      CONDENSE <gfs_summary_data>-field25.
      lv_totalqty25 = lv_totalqty25 + <gfs_summary_data>-field25.
    ENDIF.


    " PO (Print Run) - Difference
    <gfs_summary_data>-field26 = <gfs_summary_data>-field25 - <gfs_summary_data>-field24.
    CONDENSE <gfs_summary_data>-field26.
    lv_totalqty26 = lv_totalqty26 + <gfs_summary_data>-field26.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field26.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty26.


*** Begin of adding with ED2K916608 ***
    " PO dispatch Qty
    IF is_pdissum IS NOT INITIAL.
      READ TABLE is_pdissum ASSIGNING <lfs_podispatchsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_podispatchsum>-po_dispatch TO <gfs_summary_data>-field27 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_podispatchsum>.
      ELSE.
        <gfs_summary_data>-field27 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field27.
      lv_totalqty27 = lv_totalqty27 + <gfs_summary_data>-field27.

      READ TABLE is_pdissum ASSIGNING <lfs_podispatchsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_podispatchsum>-po_dispatch TO <gfs_summary_data>-field28 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_nbposumary>.
      ELSE.
        <gfs_summary_data>-field28 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field28.
      lv_totalqty28 = lv_totalqty28 + <gfs_summary_data>-field28.
    ELSE.
      <gfs_summary_data>-field27 = 0.
      CONDENSE <gfs_summary_data>-field27.
      lv_totalqty27 = lv_totalqty27 + <gfs_summary_data>-field27.

      <gfs_summary_data>-field28 = 0.
      CONDENSE <gfs_summary_data>-field28.
      lv_totalqty28 = lv_totalqty28 + <gfs_summary_data>-field28.
    ENDIF.
*** End of adding with ED2K916608 ***


    "Total Print Run (C&E plus PO) - Previous year
    <gfs_summary_data>-field29 = <gfs_summary_data>-field08 + <gfs_summary_data>-field24.
    CONDENSE <gfs_summary_data>-field29.
    lv_totalqty29 = lv_totalqty29 + <gfs_summary_data>-field29.

    " Total Print Run (C&E plus PO) - Current year
    <gfs_summary_data>-field30 = <gfs_summary_data>-field09 + <gfs_summary_data>-field25.
    CONDENSE <gfs_summary_data>-field30.
    lv_totalqty30 = lv_totalqty30 + <gfs_summary_data>-field30.


**** Begin of Calculation changes For "Total Sales remove the receipt qty and add printer dispathced quantity"
    "Total Sales (Main Lables)
    <gfs_summary_data>-field22 = <gfs_summary_data>-field02 + <gfs_summary_data>-field04 + <gfs_summary_data>-field08 + <gfs_summary_data>-field10
                                 + <gfs_summary_data>-field14 + <gfs_summary_data>-field27.
    CONDENSE <gfs_summary_data>-field22.
    lv_totalqty22 = lv_totalqty22 + <gfs_summary_data>-field22.

    <gfs_summary_data>-field23 = <gfs_summary_data>-field03 + <gfs_summary_data>-field05 + <gfs_summary_data>-field09 + <gfs_summary_data>-field11
                                 + <gfs_summary_data>-field15 + <gfs_summary_data>-field28.
    CONDENSE <gfs_summary_data>-field23.
    lv_totalqty23 = lv_totalqty23 + <gfs_summary_data>-field23.
*** End of calculation changes for "Total Sales remove the receipt qty and add printer dispathced quantity"


    "Difference (PO minus Despatched)
    "Note <gfs_summary_data>-field20 added with ED2K916608
    <gfs_summary_data>-field31 = <gfs_summary_data>-field24 - ( <gfs_summary_data>-field02 + <gfs_summary_data>-field04 + <gfs_summary_data>-field06
                                 + <gfs_summary_data>-field10 + <gfs_summary_data>-field12 + <gfs_summary_data>-field14 + <gfs_summary_data>-field16
                                 + <gfs_summary_data>-field18 + <gfs_summary_data>-field27 ).
    CONDENSE <gfs_summary_data>-field31.
    lv_totalqty31 = lv_totalqty31 + <gfs_summary_data>-field31.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field31.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty31.

    "Current year Difference (PO minus Despatched)
    "Note <gfs_summary_data>-field21 added with ED2K916608
    <gfs_summary_data>-field32 = <gfs_summary_data>-field25 - ( <gfs_summary_data>-field03 + <gfs_summary_data>-field05 + <gfs_summary_data>-field07
                                 + <gfs_summary_data>-field11 + <gfs_summary_data>-field13 + <gfs_summary_data>-field15 + <gfs_summary_data>-field17
                                 + <gfs_summary_data>-field19 + <gfs_summary_data>-field28 ).
    CONDENSE <gfs_summary_data>-field32.
    lv_totalqty32 = lv_totalqty32 + <gfs_summary_data>-field32.
    " (-) sign get front
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = <gfs_summary_data>-field32.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lv_totalqty32.


    "Previous year Difference (PO minus Despatched)%
    IF <gfs_summary_data>-field24 GT 0.   " Check dividing qty = 0
      lv_percentage = ( <gfs_summary_data>-field31 / <gfs_summary_data>-field24 ) * 100.
      IF lv_percentage NE 0.
        WRITE lv_percentage TO <gfs_summary_data>-field33 DECIMALS 2 NO-GROUPING.
      ELSE.
        WRITE lv_percentage TO <gfs_summary_data>-field33 DECIMALS 0 NO-GROUPING.
      ENDIF.
      CONDENSE <gfs_summary_data>-field33.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field33.
    ELSE.
      <gfs_summary_data>-field33 = 0.
      CONDENSE <gfs_summary_data>-field33 NO-GAPS.
    ENDIF.
    CONCATENATE <gfs_summary_data>-field33 '%' INTO <gfs_summary_data>-field33.
    FREE lv_percentage.


    "Current year Difference (PO minus Despatched)%
    IF <gfs_summary_data>-field25 GT 0.
      lv_percentage = ( <gfs_summary_data>-field32 / <gfs_summary_data>-field25 ) * 100.
      IF lv_percentage NE 0.
        WRITE lv_percentage TO <gfs_summary_data>-field34 DECIMALS 2 NO-GROUPING.
      ELSE.
        WRITE lv_percentage TO <gfs_summary_data>-field34 DECIMALS 0 NO-GROUPING.
      ENDIF.
      CONDENSE <gfs_summary_data>-field34.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field34.
    ELSE.
      <gfs_summary_data>-field34 = 0.
      CONDENSE <gfs_summary_data>-field34 NO-GAPS.
    ENDIF.
    CONCATENATE <gfs_summary_data>-field34 '%' INTO <gfs_summary_data>-field34.
    FREE lv_percentage.


    " Initial Stock on hand
    IF is_ishosum  IS NOT INITIAL.
      READ TABLE is_ishosum ASSIGNING <lfs_isohsm> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_isohsm>-inital_soh_quantity TO <gfs_summary_data>-field36 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_isohsm>.
      ELSE.
        <gfs_summary_data>-field36 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field36.
      lv_totalqty36 = lv_totalqty36 + <gfs_summary_data>-field36.

      READ TABLE is_ishosum ASSIGNING <lfs_isohsm> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_isohsm>-inital_soh_quantity TO <gfs_summary_data>-field37 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_isohsm>.
      ELSE.
        <gfs_summary_data>-field37 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field37.
      lv_totalqty37 = lv_totalqty37 + <gfs_summary_data>-field37.
    ELSE.
      <gfs_summary_data>-field36 = 0.
      CONDENSE <gfs_summary_data>-field36.
      lv_totalqty36 = lv_totalqty36 + <gfs_summary_data>-field36.

      <gfs_summary_data>-field37 = 0.
      CONDENSE <gfs_summary_data>-field37.
      lv_totalqty37 = lv_totalqty37 + <gfs_summary_data>-field37.
    ENDIF.

    " Stock on hand
    IF is_shosum IS NOT INITIAL.
      READ TABLE is_shosum ASSIGNING <lfs_sohsum> WITH KEY publication_year = v_previousyear publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_sohsum>-soh_qty TO <gfs_summary_data>-field38 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_sohsum>.
      ELSE.
        <gfs_summary_data>-field38 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field38.
      lv_totalqty38 = lv_totalqty38 + <gfs_summary_data>-field38.

      READ TABLE is_shosum ASSIGNING <lfs_sohsum> WITH KEY publication_year = p_year publication_month = lv_month BINARY SEARCH.
      IF sy-subrc = 0.
        WRITE <lfs_sohsum>-soh_qty TO <gfs_summary_data>-field39 DECIMALS 0 NO-GROUPING.
        UNASSIGN <lfs_sohsum>.
      ELSE.
        <gfs_summary_data>-field39 = 0.
      ENDIF.
      CONDENSE <gfs_summary_data>-field39.
      lv_totalqty39 = lv_totalqty39 + <gfs_summary_data>-field39.
    ELSE.
      <gfs_summary_data>-field38 = 0.
      CONDENSE <gfs_summary_data>-field38.
      lv_totalqty38 = lv_totalqty38 + <gfs_summary_data>-field38.

      <gfs_summary_data>-field39 = 0.
      CONDENSE <gfs_summary_data>-field39.
      lv_totalqty39 = lv_totalqty39 + <gfs_summary_data>-field39.
    ENDIF.
  ENDWHILE.

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
*** Begin of Chnages for ED2K916403 ***
*** Begin of Changes for ED2K916608 ***
  PERFORM f_select_cells USING 26 26.
  PERFORM f_select_cells USING 27 28.
  PERFORM f_select_cells USING 29 30.
  PERFORM f_select_cells USING 31 32.
  PERFORM f_select_cells USING 33 34.
  PERFORM f_select_cells USING 36 39.
*** End of Changes for ED2K916608 ***
*** End of Chnages for ED2K916403 ***

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
*** Begin of Changes for ED2K916403 ***
*** Begin of Changes for ED2K916608 ***
  PERFORM f_set_cell_style USING 1 26 st_style-style.
  PERFORM f_set_cell_style USING 1 27 st_style-style.
  PERFORM f_set_cell_style USING 1 29 st_style-style.
  PERFORM f_set_cell_style USING 1 31 st_style-style.
  PERFORM f_set_cell_style USING 1 33 st_style-style.
  PERFORM f_set_cell_style USING 1 36 st_style-style.
*** End of Changes for ED2K916608 ***
*** End of Changes for ED2K916403 ***

  " Cell Formatting
  PERFORM f_align_cells.
  PERFORM f_cell_colouring.

  v_summary_alv_grid->meth_display( ).

ENDFORM.

FORM f_format_ouput_numbers .

  DATA : lv_tabix TYPE sy-tabix.

  LOOP AT i_summary_data ASSIGNING <gfs_summary_data>.
    IF sy-tabix = 1 OR sy-tabix = 2.        " Skip the thousand separators for 1st two rows
      CONTINUE.
    ENDIF.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field02.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field03.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field04.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field05.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field06.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field07.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field08.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field09.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field10.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field11.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field12.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field13.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field14.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field15.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field16.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field17.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field18.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field19.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field20.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field21.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field22.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field23.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field24.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field25.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field26.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field27.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field28.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field29.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field30.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field31.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field32.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field36.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field37.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field38.
    PERFORM f_convert_char_to_thou_separ CHANGING <gfs_summary_data>-field39.
  ENDLOOP.

ENDFORM.

FORM f_convert_char_to_thou_separ CHANGING fp_field.

  DATA : lv_num  TYPE p.

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      chr             = fp_field
    IMPORTING
      num             = lv_num
    EXCEPTIONS
      convt_no_number = 1
      convt_overflow  = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    WRITE lv_num TO fp_field DECIMALS 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = fp_field.
  ENDIF.

ENDFORM.
