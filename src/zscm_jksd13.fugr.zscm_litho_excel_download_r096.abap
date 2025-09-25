FUNCTION zscm_litho_excel_download_r096.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IN_CHANGE_MODE) TYPE  XFELD DEFAULT ' '
*"     VALUE(IN_ISSUE_TAB) TYPE  ISMMATNR_ISSUETAB
*"----------------------------------------------------------------------
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K919750
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-10-01
* DESCRIPTION: LITHO-Excel Download
*--------------------------------------------------------------------*

* Local Data
  DATA: li_outtab_gf            TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]',
        lv_gv_filter            TYPE string VALUE '(RJKSDWORKLIST)GV_FILT',
        li_litho                TYPE STANDARD TABLE OF ty_litho INITIAL SIZE 0,
        lst_litho               TYPE ty_litho,
        lr_excel_structure      TYPE REF TO data,
        lv_content              TYPE xstring,
        lo_table_row_descriptor TYPE REF TO cl_abap_structdescr,
        lo_source_table_descr   TYPE REF TO cl_abap_tabledescr,
        lv_filename             TYPE bapidocid,
        lv_file_path            TYPE localfile,
        lv_external_num         TYPE balnrext,
        lv_numberof_logs        TYPE syst_tabix,
        li_header_data          TYPE STANDARD TABLE OF balhdr INITIAL SIZE 0,
        li_messages             TYPE STANDARD TABLE OF balm INITIAL SIZE 0,
        lv_fname                TYPE string,
        lv_path                 TYPE string,
        lv_fullpath             TYPE string,
        li_binary_tab           TYPE TABLE OF sdokcntasc,
        lv_length               TYPE i.

  FIELD-SYMBOLS:
    <lfi_outtab>     TYPE lty_rjksdworklist_alv.

  " Get the Selected Filter value
  ASSIGN (lv_gv_filter) TO FIELD-SYMBOL(<lv_gv_filter>).
  IF <lv_gv_filter> IS ASSIGNED AND
     <lv_gv_filter> = c_zl.
    " Get the Selected Media Issue(s)
    ASSIGN (li_outtab_gf) TO <lfi_outtab>.
    IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.
      " Populate Itab: li_litho
      LOOP AT <lfi_outtab> INTO DATA(lst_outtab).
        MOVE-CORRESPONDING lst_outtab TO lst_litho.
        " Getting the Comments (Reprint Reason, Remarks, OM Instructions) from SLG Logs
        IF lst_outtab-view_comments IS NOT INITIAL.
          " External Id
          lv_external_num = |{ lst_outtab-matnr }{ lst_outtab-marc_werks }|.
          " FM Call: Read Logs from DB
          CALL FUNCTION 'APPL_LOG_READ_DB'
            EXPORTING
              object          = c_object
              subobject       = c_subobj
              external_number = lv_external_num
            IMPORTING
              number_of_logs  = lv_numberof_logs
            TABLES
              header_data     = li_header_data
              messages        = li_messages.
          IF li_messages[] IS NOT INITIAL.
            SORT li_messages BY lognumber DESCENDING msgnumber.
            LOOP AT li_messages INTO DATA(lst_msg).
*              MESSAGE ID lst_msg-msgid TYPE lst_msg-msgty NUMBER lst_msg-msgno
*                      INTO DATA(lv_msg_text)
*                      WITH lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4.
              DATA(lv_msg_text) = |{ lst_msg-msgv1 }{ lst_msg-msgv2 }{ lst_msg-msgv3 }{ lst_msg-msgv4 }|.
              FIND FIRST OCCURRENCE OF ':' IN lv_msg_text
                         MATCH OFFSET DATA(lv_off).
              IF sy-subrc = 0.
                IF lv_msg_text(lv_off) = 'Reprint Reason'.
                  lv_off = lv_off + 2.
                  IF lst_litho-reprint_reason IS INITIAL.
                    lst_litho-reprint_reason = lv_msg_text+lv_off.
                  ENDIF.
                ELSEIF lv_msg_text(lv_off) = 'Remarks'.
                  lv_off = lv_off + 2.
                  IF lst_litho-remarks IS INITIAL.
                    lst_litho-remarks = lv_msg_text+lv_off.
                  ENDIF.
                ELSEIF lv_msg_text(lv_off) = 'OM Instructions'.
                  lv_off = lv_off + 2.
                  IF lst_litho-om_instructions IS INITIAL.
                    lst_litho-om_instructions = lv_msg_text+lv_off.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR: lv_msg_text, lst_msg, lv_off.
            ENDLOOP.
          ENDIF.
        ENDIF. " IF lst_outtab-view_comments IS NOT INITIAL.
        APPEND lst_litho TO li_litho.
        CLEAR: lst_outtab, lst_litho, li_messages[], li_header_data[], lv_numberof_logs,
               lv_external_num.
      ENDLOOP.

      " File Dialog
      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING
          window_title      = 'Enter File Name'
*         default_extension = 'XLSX'
          default_file_name = 'LithoReport.xlsx'
        CHANGING
          filename          = lv_fname
          path              = lv_path
          fullpath          = lv_fullpath.

      " File path
      lv_file_path = lv_fullpath.

      " Create data reference for internal table and RTTI class instance to query fields
      GET REFERENCE OF li_litho INTO lr_excel_structure.
*      DATA(lo_itab_services) = cl_salv_itab_services=>create_for_table_ref( lr_excel_structure ).
      lo_source_table_descr ?= cl_abap_tabledescr=>describe_by_data_ref( lr_excel_structure ).
      lo_table_row_descriptor ?= lo_source_table_descr->get_table_line_type( ).
      DATA(li_fields) = lo_table_row_descriptor->get_components( ).
*      DATA(lt_fields) = lo_table_row_descriptor->get_ddic_field_list( p_langu = sy-langu ).

      " Excel instantiate
      DATA(lo_tool_xls) = cl_salv_export_tool_ats_xls=>create_for_excel(
                                                         EXPORTING
                                                           r_data =  lr_excel_structure ).

      " Add columns to sheet
      DATA(lo_config) = lo_tool_xls->configuration( ).
      LOOP AT li_fields ASSIGNING FIELD-SYMBOL(<lfs_field>).
        CASE <lfs_field>-name.
          WHEN 'ISMREFMDPROD'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Media Product'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'MEDPROD_MAKTX'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Media Product Text'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'MATNR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Media Issue'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'MEDISSUE_MAKTX'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Media Issue Text'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'PRINT_METHOD'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Print Method'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ISMYEARNR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Pub Year'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'JOURNAL_CODE'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Acronym'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ISMCOPYNR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Volume'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ISMNRINYEAR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Issue No'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'PO_NUM'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Printer PO#'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'PO_CREATE_DT'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Printer PO Date'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'PRINT_VENDOR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Printer'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'DIST_VENDOR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Distributor'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'DELV_PLANT'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Deliv. Plant'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ISSUE_TYPE'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Issue Type'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'SUB_ACTUAL_PY'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Subs (Actual)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'SUBS_PLAN'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Subs Plan'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'NEW_SUBS'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'New Subs'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'BL_PYEAR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'BL (PY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'BL_PCURR_YR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'BL (CY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ML_PYEAR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'ML (PY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ML_BL_PY'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'ML + BL(PY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ML_CYEAR'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'ML (CY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ML_BL_CY'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'ML + BL(CY)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'BL_BUFFER'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'BL Buffer'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'SUBS_TO_PRINT'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Subs to Print'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OM_PLAN'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OM Plan'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OM_ACTUAL'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OM Actual'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OB_PLAN'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OB Plan'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OB_ACTUAL'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OB Actual'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OM_TO_PRINT'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OM to Print'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'SUB_TOTAL'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Subs total(Subs + OM)'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'C_AND_E'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'C & E'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'AUTHOR_COPIES'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Author'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'EMLO_COPIES'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'EMLO'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ADJUSTMENT'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Adjustment'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'TOTAL_PO_QTY'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Print Run: Total PO Qty'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'MARC_ISMARRIVALDATEAC'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Actual Goods Arrival'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'ESTIMATED_SOH'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Estimated SOH'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'INITIAL_SOH'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'SOH Initial'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'CURRENT_SOH'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'SOH Current'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'REPRINT_QTY'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Reprint Qty'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'REPRINT_PO_NO'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Reprint PO'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'REPRINT_REASON'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Reprint Reason'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'REMARKS'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'Remarks'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).
          WHEN 'OM_INSTRUCTIONS'.
            lo_config->add_column(
              EXPORTING
                header_text   = 'OM Instructions'
                field_name    = CONV string( <lfs_field>-name )
                display_type  = if_salv_bs_model_column=>uie_text_view ).

          WHEN OTHERS.
            " Nothing to do.
        ENDCASE.
      ENDLOOP .

      " Get excel in xstring
      lo_tool_xls->read_result(  IMPORTING content  = lv_content  ).

      " File download
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = lv_content
        IMPORTING
          output_length = lv_length
        TABLES
          binary_tab    = li_binary_tab.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          bin_filesize            = lv_length
          filename                = CONV string( lv_file_path )
          filetype                = 'BIN'
        TABLES
          data_tab                = li_binary_tab
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21
          OTHERS                  = 22.
      IF sy-subrc <> 0.
        " Implement suitable error handling here
      ENDIF.

    ELSEIF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS INITIAL.
      MESSAGE 'Please select atleast one Media Issue for Excel download'(011) TYPE 'I'.
      EXIT.
    ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  ELSE.
    MESSAGE '"Excel Download" is applicable only for LITHO Report'(010) TYPE 'I'.
    EXIT.
  ENDIF.

ENDFUNCTION.
