*----------------------------------------------------------------------*
* PROGRAM NAME: FZQTC_DEATILREPORT_EXTEND_INN (Detail Report PAI Module)
* PROGRAM DESCRIPTION: Entrire Logic of detail report PAI module
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

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/20/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

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
*** Begin of changes for ED2K916403 ***
    WHEN 'TAB6'.
      tabcontrol-activetab = 'TAB6'.
    WHEN 'TAB7'.
      tabcontrol-activetab = 'TAB7'.
    WHEN 'TAB8'.
      tabcontrol-activetab = 'TAB8'.
*** End of changes for ED2K916403 ***
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
*** Begin of Changes for ED2K916403 ***
      ELSEIF tabcontrol-activetab = 'TAB6'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_isohdetail_data_to_excel.     " Download Initial SOH Detail
      ELSEIF tabcontrol-activetab = 'TAB7'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_jrrdetail_data_to_excel.      " Download JRR Detail
      ELSEIF tabcontrol-activetab = 'TAB8'.
        PERFORM f_create_excel_object.          " Create excel object
        PERFORM f_prdispatdetail_data_to_excel. " Download Printer Dispatch Detail
*** End of Changes for ED2K916403 ***
      ENDIF.
    WHEN 'DWN_ALL'.
      PERFORM f_create_excel_object.            " Create excel object
*** Begin of Changes for ED2K916403 ***
      PERFORM f_prdispatdetail_data_to_excel.   " Download Printer Dispatch Detail
      PERFORM f_jrrdetail_data_to_excel.        " Download JRR Detail
      PERFORM f_isohdetail_data_to_excel.       " Download Initial SOH Detail
*** End of Changes for ED2K916403 ***
      PERFORM f_sohdetail_data_to_excel.        " Download SOH Detail
      PERFORM f_salesdetail_data_to_excel.      " Download Salesdetail
      PERFORM f_jdrdetail_data_to_excel.        " Download JDRdetail
      PERFORM f_biosdetail_data_to_excel.       " Download BIOSdetail
      PERFORM f_podetail_data_to_excel.         " Download POdetail
      PERFORM f_visble_excel_object.            " Visible excel object
    WHEN 'EMAIL'.
      PERFORM f_email_detail.                  " Detail report email
  ENDCASE.

ENDMODULE.

FORM f_podetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = text-047. " 'Detailed PO Data'.

  PERFORM f_clipboard_export TABLES i_podetail_excel[] USING 2 2 20 1 1 37 1 55 2 15 'B' 'P'.

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
  SET PROPERTY OF v_activesheet 'NAME' = text-048."'Detailed BIOS Data'.

  PERFORM f_clipboard_export TABLES i_biosdetail_excel[] USING 2 2 20 1 1 37 1 55 2 4 'B' 'E'.

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
  SET PROPERTY OF v_activesheet 'NAME' = text-049."'Detailed JDR Data'.

  PERFORM f_clipboard_export TABLES i_jdrdetail_excel[] USING 2 2 20 1 1 37 1 55 2 4 'B' 'E'.      " Number of column header from 3 to 4 & "D" set as "E" with ED2K916403
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
  SET PROPERTY OF v_activesheet 'NAME' = text-050."'Detailed Sales Data'.

  PERFORM f_clipboard_export TABLES i_salesdetail_excel[] USING 2 2 20 1 1 37 1 55 2 21 'B' 'V'.

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
  SET PROPERTY OF v_activesheet 'NAME' = text-051. "'Detailed SOH Data'(Detailed WHS). with ED2K916403

  PERFORM f_clipboard_export TABLES i_sohdetail_excel[] USING 2 2 20 1 1 37 1 55 2 3 'B' 'D'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_clipboard_export TABLES fp_coverteddetail_excel
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

  ENDLOOP.

  " Set Header Format
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

FORM f_email_detail .

  DATA: lv_jobnumber TYPE tbtcjob-jobcount,
        lv_jobname   TYPE tbtcjob-jobname VALUE 'JPAT_DETAIL_REPORT',
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
  EXPORT i_view_podetail TO DATABASE indx(co) ID 'PODATA'.
  EXPORT i_view_biosdetail TO DATABASE indx(co) ID 'BIOS'.
  EXPORT i_view_jdrdetail TO DATABASE indx(co) ID 'JDR'.
  EXPORT i_view_salesdetail TO DATABASE indx(co) ID 'SALES'.
  EXPORT i_view_sohdetail TO DATABASE indx(co) ID 'SOH'.
*** Begin of Changes for ED2K916403 ***
  EXPORT i_view_isohdetail TO DATABASE indx(co) ID 'ISOH'.
  EXPORT i_view_jrrdetail  TO DATABASE indx(co) ID 'JRR'.
  EXPORT i_view_printedis  TO DATABASE indx(co) ID 'PRDISPATCH'.
*** End of Changes for ED2K916403 ***
  EXPORT v_recname TO DATABASE indx(co) ID 'DSNAME'.

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

    " Detail report Excel file genaration push down to the Background
    SUBMIT zqtcr_jpat_detail_email_r090 USER lv_batchuser
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
      MESSAGE e004(zjpat).
    ENDIF.

  ENDIF.

ENDFORM.

*** Begin of Changes ED2K916403 ***
FORM f_isohdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = text-087. "'Initial SOH Data with ED2K916403

  PERFORM f_clipboard_export TABLES i_isohdetail_excel[] USING 2 2 20 1 1 37 1 55 2 3 'B' 'D'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.

FORM f_jrrdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = text-089. "'Detailed JRR Data with ED2K916403

  PERFORM f_clipboard_export TABLES i_jrrdetail_excel[] USING 2 2 20 1 1 37 1 55 2 5 'B' 'F'. " End cell change from D to F with ED2K916608

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.
*** End of Changes ED2K916403 ***

FORM f_prdispatdetail_data_to_excel .

  CALL METHOD OF v_excel 'worksheets' = v_sheets.
  CALL METHOD OF v_sheets 'ADD'.
  GET PROPERTY OF v_excel 'ActiveSheet' = v_activesheet.
  SET PROPERTY OF v_activesheet 'NAME' = text-105. "'printer dispatch Data

  PERFORM f_clipboard_export TABLES i_prnterdis_excel[] USING 2 2 20 1 1 37 1 55 2 5 'B' 'F'.

  CASE ok_code.
    WHEN 'DWN_ALL'.
      " Nothing to do
    WHEN OTHERS.
      PERFORM f_visble_excel_object.
  ENDCASE.

ENDFORM.
