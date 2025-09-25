*&---------------------------------------------------------------------*
*&  Include           FZQTC_DEATILREPORT_INN
*&---------------------------------------------------------------------*

MODULE user_command_3000 INPUT.

  CASE ok_code.
    WHEN 'BCK'.
      SET SCREEN 0.
    WHEN 'TAB1'.
      tabcontrol-activetab = 'TAB1'.
    WHEN 'TAB2'.
      tabcontrol-activetab = 'TAB2'.
    WHEN 'TAB3'.
      tabcontrol-activetab = 'TAB3'.
    WHEN 'TAB4'.
      tabcontrol-activetab = 'TAB4'.
    WHEN 'TAB5'.
      tabcontrol-activetab = 'TAB5'.
    WHEN 'EXCEL_DWN'.
      IF tabcontrol-activetab = 'TAB1'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_podetail_data_to_excel.       " Download POdetail
      ELSEIF tabcontrol-activetab = 'TAB2'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_biosdetail_data_to_excel.     " Download BIOSdetail
      ELSEIF tabcontrol-activetab = 'TAB3'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_jdrdetail_data_to_excel.      " Download JDRdetail
      ELSEIF tabcontrol-activetab = 'TAB4'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_salesdetail_data_to_excel.    " Download Salesdetail
      ELSEIF tabcontrol-activetab = 'TAB5'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_sohdetail_data_to_excel.      " Download SOH Detail
      ENDIF.
    WHEN 'DWN_ALL'.
      PERFORM f_create_excel_object.            " Create excel object
      PERFORM f_sohdetail_data_to_excel.        " Download SOH Detail
      PERFORM f_salesdetail_data_to_excel.      " Download Salesdetail
      PERFORM f_jdrdetail_data_to_excel.        " Download JDRdetail
      PERFORM f_biosdetail_data_to_excel.       " Download BIOSdetail
      PERFORM f_podetail_data_to_excel.         " Download POdetail
      PERFORM f_visble_excel_object.            " Visible excel object
  ENDCASE.

ENDMODULE.

FORM f_podetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = 'Detailed PO Data'.

  PERFORM f_clipboard_export TABLES i_podetail_excel USING 2 2 20 1 1 37 1 55 2 15 'B' 'P'.

  CASE ok_code.
    WHEN 'DWN_ALL'.     " Check Download all tabs
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_biosdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = 'Detailed BIOS Data'.

  PERFORM f_clipboard_export TABLES i_biosdetail_excel USING 2 2 20 1 1 37 1 55 2 4 'B' 'E'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_jdrdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = 'Detailed JDR Data'.

  PERFORM f_clipboard_export TABLES i_jdrdetail_excel USING 2 2 20 1 1 37 1 55 2 3 'B' 'D'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_salesdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = 'Detailed Sales Data'.

  PERFORM f_clipboard_export TABLES i_salesdetail_excel USING 2 2 20 1 1 37 1 55 2 21 'B' 'V'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_create_excel_object.

  CREATE OBJECT v_excel 'EXCEL.APPLICATION' .
  GET PROPERTY OF v_excel 'Workbooks' = v_wbooklist .
  GET PROPERTY OF v_wbooklist 'Application' = v_application .
  SET PROPERTY OF v_application 'SheetsInNewWorkbook' = 1 .
  CALL METHOD OF v_wbooklist 'Add' = v_wbook .

ENDFORM.

FORM f_visble_excel_object.

  SET PROPERTY OF v_excel 'Visible' = 1 .  " Enable the excel file to view
  FREE OBJECT v_excel.

ENDFORM.

FORM f_sohdetail_data_to_excel.

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = 'Detailed SOH Data'.

  PERFORM f_clipboard_export TABLES i_sohdetail_excel USING 2 2 20 1 1 37 1 55 2 3 'B' 'D'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_clipboard_export TABLES fp_coverteddetail_excel TYPE ty_convertdata
                             USING fp_r       " Row
                                   fp_c       " Column
                                   fp_cw      " Column Width
                                   fp_bold    " Font Bold
                                   fp_fc      " Font Colur
                                   fp_cc      " Cell Colur
                                   fp_wt      " Wrap text
                                   fp_hcc     " Header cell colur
                                   fp_hfc     " Header Font Colur
                                   fp_count   " No of header columns
                                   fp_startcell " Starting cell
                                   fp_endcell.  " End cell

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

  v_index = 1.
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
    SET PROPERTY OF v_interior 'ColorIndex' = fp_cc.

*  CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '1'.
*  SET PROPERTY OF v_borders 'LineStyle' = '1'.
*  SET PROPERTY OF v_borders 'WEIGHT' = 3.
*  FREE OBJECT v_borders.
*
*  CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '2'.
*  SET PROPERTY OF v_borders 'LineStyle' = '1'.
*  SET PROPERTY OF v_borders 'WEIGHT' = 3.
*  FREE OBJECT v_borders.
*
*  CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '3'.
*  SET PROPERTY OF v_borders 'LineStyle' = '1'.
*  SET PROPERTY OF v_borders 'WEIGHT' = 3.
*  FREE OBJECT v_borders.
*
*  CALL METHOD OF v_range 'BORDERS' = v_borders EXPORTING #1 = '4'.
*  SET PROPERTY OF v_borders 'LineStyle' = '1'.
*  SET PROPERTY OF v_borders 'WEIGHT' = 3.
*  FREE OBJECT v_borders.
  ENDLOOP.

  CLEAR v_index.
  v_index = 1.
  DO fp_count TIMES.
    v_index = v_index + 1.
    CALL METHOD OF v_excel 'Cells' = v_cell1 EXPORTING #1 = 2 #2 = v_index.

    GET PROPERTY OF v_cell1 'Font' = v_f.
    SET PROPERTY OF v_cell1 'ColumnWidth' = fp_cw.       " Column Width

    SET PROPERTY OF v_f 'Bold' = fp_bold .               " Font Bold
    SET PROPERTY OF v_f 'COLORINDEX' = fp_hfc .           " Font Colour

    GET PROPERTY OF v_cell1 'Interior' = v_interior .
    SET PROPERTY OF v_interior 'ColorIndex' = fp_hcc.     " Cell colur
    SET PROPERTY OF v_cell1 'WrapText' = fp_wt.           " wrap text
  ENDDO.

ENDFORM.
