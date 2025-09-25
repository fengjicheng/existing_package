*&---------------------------------------------------------------------*
*&  Include           FZQTC_SUMMARYREPORT_INN
*&---------------------------------------------------------------------*

MODULE user_command_2000 INPUT.

*   to react on oi_custom_events:
  cl_gui_cfw=>dispatch( ).

  CASE sy-ucomm.
    WHEN 'BCK'.
      SET SCREEN 0.
    WHEN 'DOWNLOAD'.
      PERFORM f_download_summary_data.
      REFRESH i_summary_data[].
  ENDCASE.

ENDMODULE.

FORM f_download_summary_data .

  PERFORM f_convert_summary_data.       " Convert Itab data with deliminator format

  CREATE OBJECT v_excel 'EXCEL.APPLICATION' .
  GET PROPERTY OF v_excel 'Workbooks' = v_wbooklist .
  GET PROPERTY OF v_wbooklist 'Application' = v_application .
  SET PROPERTY OF v_application 'SheetsInNewWorkbook' = 1 .
  CALL METHOD OF v_wbooklist 'Add' = v_wbook .
  GET PROPERTY OF v_application 'ActiveSheet' = v_activesheet .
  SET PROPERTY OF v_activesheet 'NAME' = 'Summary Report'.

** Title of the Report
  CALL METHOD OF v_excel 'Cells' = v_cell1
    EXPORTING
    #1 = 2
    #2 = 5.
  CALL METHOD OF v_excel 'Cells' = v_cell2
    EXPORTING
    #1 = 2
    #2 = 7.
  CALL METHOD OF v_excel 'Range' = v_cells
    EXPORTING
    #1 = v_cell1
    #2 = v_cell2.

  CALL METHOD OF v_cells 'Select' .
  CALL METHOD OF v_cells 'Merge' .

  CALL METHOD OF v_excel 'Cells' = v_cell1
    EXPORTING
    #1 = 2
    #2 = 5.

  SET PROPERTY OF v_cell1 'Value' = 'DashBoard Report' .

  GET PROPERTY OF v_cell1 'Font' = v_f.
  SET PROPERTY OF v_cell1 'ColumnWidth' = 60.
  SET PROPERTY OF v_cell1 'HorizontalAlignment' = -4108.
  SET PROPERTY OF v_cell1 'WrapText' = 1.

  SET PROPERTY OF v_f 'SIZE' = 15 .
  SET PROPERTY OF v_f 'NAME' = 'Calibri' .
  SET PROPERTY OF v_f 'COLORINDEX' = 1 .
  SET PROPERTY OF v_f 'Bold' = 1 .

  " Filling Blank cell
  PERFORM f_fill_blank_cell USING 4 2 ''.

  " Filling Ordertype details.
  PERFORM f_prepare_text_heading USING 4 3 4   'Subscription Total (Sales)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 5 6   'Offline Society members total (JDR) (From JDR Feed into SAP)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 7 8   'BIOS members total  (from JDR feed into SAP)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 9 10  'Conferences & exhibitions total (From PO)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 11 12 'Author copies (Main Lables) (Includes Subs and Sales Orders)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 13 14 'Author copies (Back Orders) (Includes Subs and Sales Orders)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 15 16 'Bulk orders (Main Lables Sales Orders) (EMLOs)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 17 18 'Bulk orders (Back Orders Sales) (EBLOs)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 19 20 'Back orders (Sales Data)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 21 22 'Total Sales (Main Lables)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 23 24 'PO (Print Run) Quantity' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 25 26 'Total (Purchase Qty - Sales Qty)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 27 27 'Year on Year Difference (Sales & Purchase)' 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 28 28  v_headername 20 1 3 1 1 44.
  PERFORM f_prepare_text_heading USING 4 30 33 'SOH' 20 1 3 1 1 44.

  PERFORM f_fill_comparing_year.
*
  IF i_summary_excel[] IS NOT INITIAL.      " Check the summary data is initial.if initial not printing the data(only headers)
    PERFORM f_clipboard_export_summary TABLES i_summary_excel USING 6 2 10 'B' 'AB' 'AD' 'AG' 15.
  ENDIF.

  SET PROPERTY OF v_excel 'Visible' = 1 .
  FREE OBJECT v_excel.

ENDFORM.

FORM f_fill_blank_cell USING fp_i fp_j fp_val.

  CALL METHOD OF v_excel 'Cells' = v_cell1 EXPORTING #1 = fp_i #2 = fp_j.

  SET PROPERTY OF v_cell1 'Value' = fp_val .

  GET PROPERTY OF v_cell1 'Font' = v_f.
  SET PROPERTY OF v_cell1 'ColumnWidth' = 20.

  SET PROPERTY OF v_f 'Bold' = 1 .
  SET PROPERTY OF v_f 'COLORINDEX' = 1 .

  GET PROPERTY OF v_cell1 'Interior' = v_interior .
  SET PROPERTY OF v_interior 'ColorIndex' = 44.
  SET PROPERTY OF v_cell1 'WrapText' = 1.

  CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '1'.
  SET PROPERTY OF v_borders 'LineStyle' = '1'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '2'.
  SET PROPERTY OF v_borders 'LineStyle' = '1'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '3'.
  SET PROPERTY OF v_borders 'LineStyle' = '1'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '4'.
  SET PROPERTY OF v_borders 'LineStyle' = '1'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

ENDFORM.

FORM f_prepare_text_heading USING fp_r1
                                  fp_c1
                                  fp_c2
                                  fp_val
                                  fp_cw
                                  fp_wt
                                  fp_ha
                                  fp_fb
                                  fp_fc
                                  fp_cc.

  CALL METHOD OF v_excel 'Cells' = v_cell1
    EXPORTING
    #1 = fp_r1
    #2 = fp_c1.
  CALL METHOD OF v_excel 'Cells' = v_cell2
    EXPORTING
    #1 = fp_r1
    #2 = fp_c2.
  CALL METHOD OF v_excel 'Range' = v_cells
    EXPORTING
    #1 = v_cell1
    #2 = v_cell2.

  CALL METHOD OF v_cells 'Select' .
  CALL METHOD OF v_cells 'Merge' .

  CALL METHOD OF v_excel 'Cells' = v_cell1
    EXPORTING
    #1 = fp_r1
    #2 = fp_c1.

  SET PROPERTY OF v_cell1 'Value' = fp_val .

  GET PROPERTY OF v_cell1 'Font' = v_f.
  SET PROPERTY OF v_cell1 'ColumnWidth' = fp_cw.
  SET PROPERTY OF v_cell1 'WrapText' = fp_wt.
  SET PROPERTY OF v_cell1 'HorizontalAlignment' = fp_ha.

  SET PROPERTY OF v_f 'Bold' = fp_fb .
  SET PROPERTY OF v_f 'COLORINDEX' = fp_fc .

  GET PROPERTY OF v_cell1 'Interior' = v_interior .
  SET PROPERTY OF v_interior 'ColorIndex' = fp_cc.

  CALL METHOD OF v_cells 'BORDERS' = v_borders EXPORTING #1 = '1'.
  SET PROPERTY OF v_borders 'LineStyle' = '1'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cells 'BORDERS' = v_borders EXPORTING #1 = '2'.
  SET PROPERTY OF v_borders 'LineStyle' = '3'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cells 'BORDERS' = v_borders EXPORTING #1 = '3'.
  SET PROPERTY OF v_borders 'LineStyle' = '3'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

  CALL METHOD OF v_cells 'BORDERS' = v_borders EXPORTING #1 = '4'.
  SET PROPERTY OF v_borders 'LineStyle' = '3'.
  SET PROPERTY OF v_borders 'WEIGHT' = 3.
  FREE OBJECT v_borders.

ENDFORM.

FORM f_fill_comparing_year .

  LOOP AT i_year INTO st_year.
    v_rowindx = sy-tabix + 4.
    CLEAR v_colindx.
    DO 32 TIMES.
      ASSIGN COMPONENT sy-index OF STRUCTURE st_year TO <gfs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      v_colindx = sy-index + 1.
      IF v_colindx NE 29 .
        CALL METHOD OF
                 v_excel
                 'Cells' = v_cell1
               EXPORTING
                 #1      = v_rowindx
                 #2      = v_colindx.

        SET PROPERTY OF v_cell1 'Value' = <gfs>.

        GET PROPERTY OF v_cell1 'Interior' = v_interior .
        SET PROPERTY OF v_interior 'ColorIndex' = 44.
        SET PROPERTY OF v_cell1 'ColumnWidth' = 10.

        CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '1'.
        SET PROPERTY OF v_borders 'LineStyle' = '1'.
        SET PROPERTY OF v_borders 'WEIGHT' = 3.
        FREE OBJECT v_borders.

        CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '2'.
        SET PROPERTY OF v_borders 'LineStyle' = '1'.
        SET PROPERTY OF v_borders 'WEIGHT' = 3.
        FREE OBJECT v_borders.

        CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '3'.
        SET PROPERTY OF v_borders 'LineStyle' = '1'.
        SET PROPERTY OF v_borders 'WEIGHT' = 3.
        FREE OBJECT v_borders.

        CALL METHOD OF v_cell1 'BORDERS' = v_borders EXPORTING #1 = '4'.
        SET PROPERTY OF v_borders 'LineStyle' = '1'.
        SET PROPERTY OF v_borders 'WEIGHT' = 3.
        FREE OBJECT v_borders.
      ENDIF.

    ENDDO.
  ENDLOOP.

ENDFORM.

FORM f_convert_summary_data.

  FIELD-SYMBOLS : <lfs_summary> TYPE ty_summary_data.

  REFRESH : i_summary_excel[].

  IF i_summary_data IS NOT INITIAL.
    LOOP AT i_summary_data ASSIGNING <lfs_summary>.
      CONCATENATE <lfs_summary>-field01
      <lfs_summary>-field02
        <lfs_summary>-field03
        <lfs_summary>-field04
        <lfs_summary>-field05
        <lfs_summary>-field06
        <lfs_summary>-field07
        <lfs_summary>-field08
        <lfs_summary>-field09
        <lfs_summary>-field10
        <lfs_summary>-field11
        <lfs_summary>-field12
        <lfs_summary>-field13
        <lfs_summary>-field14
        <lfs_summary>-field15
        <lfs_summary>-field16
        <lfs_summary>-field17
        <lfs_summary>-field18
        <lfs_summary>-field19
        <lfs_summary>-field20
        <lfs_summary>-field21
        <lfs_summary>-field22
        <lfs_summary>-field23
        <lfs_summary>-field24
        <lfs_summary>-field25
        <lfs_summary>-field26
        <lfs_summary>-field27
        <lfs_summary>-field28
        <lfs_summary>-field29
        <lfs_summary>-field30
        <lfs_summary>-field31
        <lfs_summary>-field32
      INTO i_summary_excel SEPARATED BY v_deli.
      CONDENSE i_summary_excel.
      APPEND i_summary_excel.
      CLEAR i_summary_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_clipboard_export_summary TABLES fp_coverteddetail_excel TYPE ty_convertdata
                             USING fp_r         " Row
                                   fp_c         " Column
                                   fp_cw        " Column Width
                                   fp_startcell " Starting cell
                                   fp_endcell   " End cell
                                   fp_sbstartcell   " 2nd block start cell
                                   fp_sbendtcell   " 2nd block start cell
                                   fp_cc.         " total line colour

  FIELD-SYMBOLS : <lfs_convert_excel> TYPE tt_convertdata.

  FREE : v_index,v_row,v_first,v_second.
**Copy data in clipboard
  CALL METHOD cl_gui_frontend_services=>clipboard_export
    IMPORTING
      data                 = fp_coverteddetail_excel[]
    CHANGING
      rc                   = v_rc
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

**choose first cell.
  CALL METHOD OF v_excel 'Cells' = v_cell1
  EXPORTING
  #1 = fp_r "Row
  #2 = fp_c. "Column

**choose second cell.
  CALL METHOD OF v_excel 'Cells' = v_cell2
  EXPORTING
  #1 = fp_r "Row
  #2 = fp_c. "Column

**Change width of column.
  SET PROPERTY OF v_cell1 'Columnwidth' = fp_cw.

**Make range from selected cell
  CALL METHOD OF v_excel 'Range' = v_range
  EXPORTING
  #1 = v_cell1
  #2 = v_cell2.

  CALL METHOD OF v_range 'Select'.
** Paste data from clipboard to worksheet.
  CALL METHOD OF v_activesheet 'Paste'.

  v_index = 5.
  LOOP AT fp_coverteddetail_excel ASSIGNING <lfs_convert_excel>.
    v_index = v_index + 1.
    v_row = v_index.
    CONCATENATE fp_startcell v_row INTO v_first.       "Column from where you want to start providing borders.
    CONCATENATE fp_endcell v_row INTO v_second.        "Column up to which you want to provide the borders.

**Make range of selected columns.
    CALL METHOD OF v_excel 'Range' = v_range
    EXPORTING
    #1 = v_first
    #2 = v_second.

    GET PROPERTY OF v_range 'Interior' = v_interior .
    " Set Total line background colour for block one
    IF v_index = 18.
      SET PROPERTY OF v_interior 'ColorIndex' = fp_cc.
    ENDIF.


    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '1'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '2'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '3'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '4'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

***** 2nd block Formatting
    CONCATENATE fp_sbstartcell v_row INTO v_third.       "Column from where 2nd block start providing borders.
    CONCATENATE fp_sbendtcell v_row INTO v_fourth.       "Column up to 2nd block which you want to provide the borders.

**make range of selected columns.
    CALL METHOD OF v_excel 'Range' = v_range
    EXPORTING
    #1 = v_third
    #2 = v_fourth.

    GET PROPERTY OF v_range 'Interior' = v_interior .
    " Set Total line background colour for block two
    IF v_index = 18.
      SET PROPERTY OF v_interior 'ColorIndex' = fp_cc.
    ENDIF.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '1'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '2'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '3'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

    CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '4'.
    SET PROPERTY OF v_borders 'LineStyle' = '1'.
    SET PROPERTY OF v_borders 'WEIGHT' = 3.
    FREE OBJECT v_borders.

  ENDLOOP.

ENDFORM.
