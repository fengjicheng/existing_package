*----------------------------------------------------------------------*
* PROGRAM NAME: FZQTC_SUMMARYREPORT_EXTEND_INN (Sumary report PAI module)
* PROGRAM DESCRIPTION: Entrire Logic of Summary report PAI Module
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
* REFERENCE NO:ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/29/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

MODULE user_command_2000 INPUT.

*   to react on oi_custom_events:
  cl_gui_cfw=>dispatch( ).

  CASE sy-ucomm.
    WHEN 'BCK'.
      SET SCREEN 0.
    WHEN 'DOWNLOAD'.
      PERFORM f_download_summary_data.  " Download Summary report to excel
      REFRESH i_summary_data[].
    WHEN 'EMAIL'.
      PERFORM f_email_summary.          " Summary report email
      REFRESH : i_summary_data[] , i_year.
  ENDCASE.

ENDMODULE.

FORM f_download_summary_data .

  DATA : lv_font TYPE string.

  PERFORM f_convert_summary_data.       " Convert Itab data with deliminator format

  lv_font = text-098. " 'Calibri'.                  " Font Style

  CREATE OBJECT v_excel 'EXCEL.APPLICATION' .
  GET PROPERTY OF v_excel 'Workbooks' = v_wbooklist .
  GET PROPERTY OF v_wbooklist 'Application' = v_application .
  SET PROPERTY OF v_application 'SheetsInNewWorkbook' = 1 .
  CALL METHOD OF v_wbooklist 'Add' = v_wbook .
  GET PROPERTY OF v_application 'ActiveSheet' = v_activesheet .
  SET PROPERTY OF v_activesheet 'NAME' = text-052. "'Summary Report'.

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

  SET PROPERTY OF v_cell1 'Value' = text-053. "'DashBoard Report' .

  GET PROPERTY OF v_cell1 'Font' = v_f.
  SET PROPERTY OF v_cell1 'ColumnWidth' = 60.
  SET PROPERTY OF v_cell1 'HorizontalAlignment' = -4108.
  SET PROPERTY OF v_cell1 'WrapText' = 1.

  SET PROPERTY OF v_f 'SIZE' = 15 .
  SET PROPERTY OF v_f 'NAME' = lv_font.
  SET PROPERTY OF v_f 'COLORINDEX' = 1 .
  SET PROPERTY OF v_f 'Bold' = 1 .

  " Filling Blank cell
  PERFORM f_fill_blank_cell USING 4 2 ''.

  " Filling Ordertype details.
  PERFORM f_prepare_text_heading USING 4 3 4    text-054 20 1 3 1 1 44.   " Subs Copies (SAP)
  PERFORM f_prepare_text_heading USING 4 5 6    text-055 20 1 3 1 1 44.   " Society Offline Member - Main Labels (JFDS)
  PERFORM f_prepare_text_heading USING 4 7 8    text-056 20 1 3 1 1 44.   " Society Offline Member - Back Labels (JFDS)
  PERFORM f_prepare_text_heading USING 4 9 10   text-057 20 1 3 1 1 44.   " Conference Copies
  PERFORM f_prepare_text_heading USING 4 11 12  text-058 20 1 3 1 1 44.   " Author copies - Main Labels (SAP)
  PERFORM f_prepare_text_heading USING 4 13 14  text-059 20 1 3 1 1 44.   " Author copies - Back Labels (SAP)
  PERFORM f_prepare_text_heading USING 4 15 16  text-060 20 1 3 1 1 44.   " Bulk orders(including EMLOs)
  PERFORM f_prepare_text_heading USING 4 17 18  text-061 20 1 3 1 1 44.   " Bulk orders(including EBLOs)
  PERFORM f_prepare_text_heading USING 4 19 20  text-062 20 1 3 1 1 44.   " Back Labels (SAP)
*** Begin of changes for ED2K916403 ***
  PERFORM f_prepare_text_heading USING 4 21 22  text-090 20 1 3 1 1 44.   " Receipt Qty(JRR)  Description changes as 'Receipt Qty(JRR)' with ED2K916608
  PERFORM f_prepare_text_heading USING 4 23 24  text-063 20 1 3 1 1 44.   " Total Sales (Main Lables)
  PERFORM f_prepare_text_heading USING 4 25 26  text-064 20 1 3 1 1 44.   " PO (Print Run) Quantity
*** Begin of changes for ED2K916608 ***
  PERFORM f_prepare_text_heading USING 4 27 27  v_headername 20 1 3 1 1 44.   " PO (Print Run) Year on Year Difference
  PERFORM f_prepare_text_heading USING 4 28 29  text-097 20 1 3 1 1 44.   " Printer dispatch (SAP PO qty-receipt from JFDS) Issue Level
  PERFORM f_prepare_text_heading USING 4 30 31  text-091 20 1 3 1 1 44.   " Total Print Run (C&E plus PO)
  PERFORM f_prepare_text_heading USING 4 32 33  text-092 20 1 3 1 1 44.   " Difference (PO minus Despatched)
  PERFORM f_prepare_text_heading USING 4 34 35  text-093 20 1 3 1 1 44.   " Difference (PO minus Despatched) %
  PERFORM f_prepare_text_heading USING 4 37 40  text-067 20 1 3 1 1 44.   " SOH
*** End of changes for ED2K916608 ***
*** End of changes for ED2K916403 ***

  PERFORM f_fill_comparing_year.

  IF i_summary_excel[] IS NOT INITIAL.      " Check the summary data is initial.if initial not printing the data(only headers)
    PERFORM f_clipboard_export_summary TABLES i_summary_excel[] USING 6 2 10 'B' 'AI' 'AK' 'AN' 15.       " Change cell starting/end points with ED2K916403
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

  FIELD-SYMBOLS : <lfs> TYPE c.
  DATA : lv_loopcount TYPE i.

  lv_loopcount = 0.
  LOOP AT i_year INTO st_year.
    v_rowindx = sy-tabix + 4.
    CLEAR v_colindx.
    WHILE lv_loopcount =< 40.   " 32 changes as a 40 columns Fill in the Excel with ED2K916403
      ASSIGN COMPONENT sy-index OF STRUCTURE st_year TO <lfs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      v_colindx = sy-index + 1.
      lv_loopcount = lv_loopcount + 1.
      IF v_colindx NE 36 .        " instead of 29 chnages the Skipping 36 column without any interior with ED2K916403
        CALL METHOD OF
                 v_excel
                 'Cells' = v_cell1
               EXPORTING
                 #1      = v_rowindx
                 #2      = v_colindx.

        SET PROPERTY OF v_cell1 'Value' = <lfs>.

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
    ENDWHILE.
  ENDLOOP.

ENDFORM.

FORM f_convert_summary_data.

  FIELD-SYMBOLS : <lfs_summary> TYPE ty_summary_data.

  REFRESH : i_summary_excel[].
  CLEAR   : stconvertdata_excel.

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
*** Begin of changes for ED2K916403 ***
        <lfs_summary>-field20
        <lfs_summary>-field21
        <lfs_summary>-field22
        <lfs_summary>-field23
        <lfs_summary>-field24
        <lfs_summary>-field25
*** Begin of changes for ED2K916608 ***
        <lfs_summary>-field26
        <lfs_summary>-field27
        <lfs_summary>-field28
        <lfs_summary>-field29
        <lfs_summary>-field30
        <lfs_summary>-field31
        <lfs_summary>-field32
        <lfs_summary>-field33
        <lfs_summary>-field34
        <lfs_summary>-field35
        <lfs_summary>-field36
        <lfs_summary>-field37
        <lfs_summary>-field38
        <lfs_summary>-field39
*** End of changes for ED2K916608 ***
*** End of changes for ED2K916403 ***
      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_summary_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_clipboard_export_summary TABLES fp_coverteddetail_excel
                                USING fp_r         " Row
                                      fp_c         " Column
                                      fp_cw        " Column Width
                                      fp_startcell " Starting cell
                                      fp_endcell   " End cell
                                      fp_sbstartcell   " 2nd block start cell
                                      fp_sbendtcell   " 2nd block start cell
                                      fp_cc.         " total line colour

  FIELD-SYMBOLS : <lfs_convert_excel> TYPE ty_convertdata.

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
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

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

FORM f_email_summary .

  DATA: lv_jobnumber TYPE tbtcjob-jobcount,
        lv_jobname   TYPE tbtcjob-jobname VALUE 'JPAT_SUMMARY_REPORT',
        lv_batchuser TYPE bapibname-bapibname.

  CONSTANTS : lc_batch TYPE rvari_vnam VALUE 'BATCHUSER'.

  FREE : lv_batchuser.
  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant ASSIGNING <gfs_constant> WITH KEY param1 = lc_batch BINARY SEARCH.
    IF sy-subrc = 0.
      lv_batchuser = <gfs_constant>-low.      " Set Sender email address
    ENDIF.
  ENDIF.

  " GUI session user
  v_recname = sy-uname.

  "Export itab data to memory ID and pass to the background job
  EXPORT i_year TO DATABASE indx(co) ID 'YEAR'.
  EXPORT i_summary_data TO DATABASE indx(co) ID 'SDATA'.
  EXPORT v_headername TO DATABASE indx(co) ID 'HEADER'.
  EXPORT v_recname TO DATABASE indx(co) ID 'SNAME'.

  CALL FUNCTION 'JOB_OPEN'        " Open Background job
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_jobnumber
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE e004(zjpat) WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    " Summary report Excel file genaration push down to the Background
    SUBMIT zqtcr_jpat_summary_email_r090 USER lv_batchuser
                                         VIA JOB lv_jobname
                                         NUMBER lv_jobnumber AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'         " Close Background job.
      EXPORTING
        jobcount             = lv_jobnumber
        jobname              = lv_jobname
        strtimmed            = c_x
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        OTHERS               = 9.

    IF sy-subrc = 0.
      "MESSAGE 'Email will be sent to your Inbox' TYPE 'I'.         " Success Messege
      MESSAGE i005(zjpat).
      FREE : lv_jobnumber , lv_jobname.
    ELSE.
      "MESSAGE 'Error In Background job finishing..' TYPE 'E'.
      MESSAGE e004(zjpat).
    ENDIF.

  ENDIF.

ENDFORM.
