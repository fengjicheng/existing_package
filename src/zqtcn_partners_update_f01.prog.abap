*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PARTNERS_UPDATE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       Subroutine to get file from presentation server
*----------------------------------------------------------------------*
*      -->FP_SYST_CPROG  system field
*      -->FP_C_FIELD  field name
*      <--FP_P_FILE local file
*----------------------------------------------------------------------*
FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog "ABAP System Field: Calling Program
                                 fp_c_field    TYPE dynfnam    " Field name
                        CHANGING fp_p_file     TYPE localfile. " Local file for upload/download
  "Local file for upload/download

* To get the file from presentation server when radio button Presentation
* Server is selected
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_p_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_APPLICATION
*&---------------------------------------------------------------------*
*      Subroutine to get file from application
*----------------------------------------------------------------------*
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_application  CHANGING fp_p_file TYPE localfile. " Local file for upload/download
*  To get the file from application server when radio button Application
*  Server is selected
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    MESSAGE e002(zqtc_r2). "File does not exist
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       Subroutine to validate the file path
*----------------------------------------------------------------------*
*      -->FP_P_FILE  file path
*----------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile. " Local file for upload/download
*  Local data declaration
  DATA: lv_file   TYPE string,    " File name
        lv_result TYPE abap_bool. " flag

  CLEAR lv_file.
  lv_file = fp_p_file.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*  Error message : unable to check file 'E'
    MESSAGE e001(zqtc_r2). " Unable to check file
  ELSE. " ELSE -> IF sy-subrc <> 0
    IF lv_result EQ abap_false.
*   Error message :File does not exits 'E'
      MESSAGE e002(zqtc_r2). " 'File does not exits.
    ENDIF. " IF lv_result EQ abap_false
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       Subroutine to read file from presentation server
*----------------------------------------------------------------------*
*      -->FP_V_PS_FILE_PATH  File Path
*      <--FP_I_UPLOAD_FILE   file details
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server  USING    fp_p_file TYPE localfile " Local file for upload/download
                                  CHANGING fp_i_upload_file TYPE tt_upload_file.

*   Local data declaration
  DATA:
    lst_upload_file TYPE ty_upload_file,                   " file data
    lv_file         TYPE localfile,                        "file path
    li_exceldata    TYPE STANDARD TABLE OF alsmex_tabline. " Rows for Table with Excel Data

  lv_file = fp_p_file.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_file
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 500
      i_end_row               = 99999
    TABLES
      intern                  = li_exceldata
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc EQ 0.
    LOOP AT li_exceldata INTO DATA(lst_data_tab).
      IF ( cb_hdr IS NOT INITIAL
         AND lst_data_tab-row GE 2 )
         OR
         ( cb_hdr IS INITIAL AND lst_data_tab-row GE 1 ).
        CASE lst_data_tab-col.
          WHEN 1.
            lst_upload_file-order = lst_data_tab-value.
          WHEN 2.
            lst_upload_file-part_func = lst_data_tab-value.
          WHEN 3.
            lst_upload_file-cust_no = lst_data_tab-value.
          WHEN OTHERS.
 "Do Nothing
        ENDCASE.
        AT END OF row.
          APPEND lst_upload_file TO fp_i_upload_file.
          CLEAR: lst_upload_file,lst_data_tab.
        ENDAT.
      ENDIF. " IF ( cb_hdr IS NOT INITIAL
    ENDLOOP. " LOOP AT li_exceldata INTO DATA(lst_data_tab)

    DELETE fp_i_upload_file WHERE order IS INITIAL.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE_APP_SERVER
*&---------------------------------------------------------------------*
*       Save the presentation server file to app server
*----------------------------------------------------------------------*
*      -->FP_I_UPLOAD_FILE  presentation server data
*      <--FP_P_A_FILE  app servier file path
*----------------------------------------------------------------------*
FORM f_save_file_app_server  USING    fp_i_upload_file TYPE tt_upload_file
                             CHANGING fp_p_file TYPE localfile. " Local file for upload/download

  CONSTANTS: lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv'. " Extn of type CHAR4

  CONCATENATE fp_p_file
              lc_slash
              'ZPARTER_UPD'
              lc_underscore
              sy-uname
              lc_underscore
              sy-datum
              lc_underscore
              sy-uzeit
              lc_extn
              INTO
              v_path_fname.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  LOOP AT fp_i_upload_file INTO DATA(lst_upload_file).
    CONCATENATE lst_upload_file-order lst_upload_file-part_func lst_upload_file-cust_no INTO DATA(lv_text) SEPARATED BY ','.
    TRANSFER lv_text TO v_path_fname.
  ENDLOOP. " LOOP AT fp_i_upload_file INTO DATA(lst_upload_file)
  CLOSE DATASET v_path_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BATCH_JOB
*&---------------------------------------------------------------------*
*       Subroutine to process batch job
*----------------------------------------------------------------------*
FORM f_batch_job .
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status
* Local constant declaration
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'ZPARTNR_UPD'. " Background job name
  CLEAR lv_job_name.
  CONCATENATE lc_job_name '_' sy-uzeit '_' sy-datum  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-023. "Processing the schedule in batch job
**Check if pre. Job name and job count is present
**then set the check pre. status to X else blank.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    v_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcr_partner_upload_batch
                               WITH p_a_file = v_path_fname
                               WITH p_mail IN  p_mail
                               WITH p_recon = p_recon
                               WITH p_job = p_job
                               USER p_user
                               VIA JOB lv_job_name NUMBER lv_job_number
                               AND RETURN.
** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.

** if job is closed sucessfully, pass the job name and job count
** as previous job name and count for next job.
    IF sy-subrc EQ 0.
      PERFORM f_display_message USING lv_job_name.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      MESSAGE e000(zrtr_r1b) WITH text-005. " & & & &
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_JOB_NAME  text
*----------------------------------------------------------------------*
FORM f_display_message  USING    fp_lv_job_name.
  TYPE-POOLS : slis.
  TYPES : BEGIN OF ty_tab,
            job  TYPE char32,   " Job of type CHAR32
            user TYPE sy-uname, " ABAP System Field: Name of Current User
            date TYPE sy-datum, " ABAP System Field: Current Date of Application Server
            time TYPE sy-uzeit, " ABAP System Field: Current Time of Application Server
          END OF ty_tab.
  DATA : li_tab     TYPE STANDARD TABLE OF ty_tab,
         lst_tab    TYPE ty_tab,
         li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1. " Val of type Integers

  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'JOB'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = text-005. "JOB Name
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'USER'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = text-006. "User Name.
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'DATE'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = text-007. "Scheduled Date
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'TIME'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = text-008. "Scheduled Time
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_tab-job = fp_lv_job_name.
  lst_tab-user = sy-uname.
  lst_tab-date = sy-datum.
  lst_tab-time = sy-uzeit.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-009
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = li_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  REFRESH : li_fcat,li_tab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_UPDATE_WITH_NEW_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_RECON  text
*      -->P_P_IND  text
*      -->P_P_USER  text
*      -->P_P_JOB  text
*      <--P_I_EXCEL_FILE  text
*      <--P_I_MAIL  text
*----------------------------------------------------------------------*
FORM f_partnr_update_with_new_value  USING  fp_recon TYPE char10   " Partnr_update_with_new_ of type CHAR10
                                            fp_user  TYPE sy-uname " ABAP System Field: Name of Current User
                                            fp_job TYPE btcjob     " Background job name
                                   CHANGING fp_i_excel_file TYPE tt_upload_file
                                            fp_i_mail TYPE tt_mail.

  DATA: lst_header_inx       TYPE bapisdhd1x, " Communication Fields: Sales and Distribution Document Header
        li_return_tab        TYPE bapiret2_t, " Return Parameter
        lst_return           TYPE bapiret2,   " Return Parameter
        li_partners          TYPE jbapiparnrc_tab,
        lst_partners         TYPE bapiparnrc, " Partner changes
        lst_alv_display      TYPE ty_alv_display,
        lst_alv_display_mail TYPE ty_alv_display,
        lv_lines             TYPE i,          " Lines of type Integers
        lv_ind               TYPE char20,     " Ind of type CHAR20
        lv_ind_tmp           TYPE char20,     " Ind_tmp of type CHAR20
        lv_index             TYPE sy-tabix.   " ABAP System Field: Row Index of Internal Tables

  DATA(li_excel_file) = fp_i_excel_file[].
  SORT li_excel_file BY cust_no.
  DELETE ADJACENT DUPLICATES FROM li_excel_file COMPARING cust_no.
  DELETE li_excel_file WHERE cust_no IS INITIAL.

  IF li_excel_file IS NOT INITIAL.
    SELECT kunnr,
           adrnr " Address
      FROM kna1  " General Data in Customer Master
      INTO TABLE @DATA(li_kna1)
      FOR ALL ENTRIES IN @li_excel_file
      WHERE kunnr = @li_excel_file-cust_no.
    IF sy-subrc EQ 0.
      SORT li_kna1 BY kunnr.
    ENDIF. " IF sy-subrc EQ 0

    p_mail[] = fp_i_mail[].
    p_recon  = fp_recon.
    IF sy-batch NE abap_true.
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          text = text-003. "Subscription order is updating with new value
    ENDIF. " IF sy-batch NE abap_true

    DESCRIBE TABLE i_excel_file LINES lv_lines.

    CLEAR :lv_index,lv_ind,lv_ind_tmp.
    IF lv_lines > p_recon.
      lv_ind = lv_ind_tmp = p_recon.
    ELSE. " ELSE -> IF lv_lines > p_recon
      lv_ind = lv_ind_tmp = '100'.
    ENDIF. " IF lv_lines > p_recon
    CONDENSE: lv_ind_tmp,lv_ind.

    LOOP AT fp_i_excel_file INTO DATA(lst_excel_file).
      lv_index = sy-tabix.
      IF sy-batch = abap_true.
        IF lv_index EQ lv_ind.
          MESSAGE i000(zqtc_r2) WITH lv_ind text-010 lv_lines  text-011. "Processsed Successfully
          lv_ind = lv_ind + lv_ind_tmp.
          CONDENSE lv_ind.
        ENDIF. " IF lv_index EQ lv_ind
      ENDIF. " IF sy-batch = abap_true

      READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_excel_file-cust_no
                                                  BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_partners-address = lst_kna1-adrnr.
      ENDIF. " IF sy-subrc EQ 0

      DATA(lv_vbeln) = lst_excel_file-order.
      lst_header_inx-updateflag = 'U'.
      lst_partners-document = lst_excel_file-order.
      lst_partners-itm_number = '000000'.
      lst_partners-updateflag = 'I'.
      lst_partners-partn_role = lst_excel_file-part_func.
      lst_partners-p_numb_new = lst_excel_file-cust_no.
      APPEND lst_partners TO li_partners.

      CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
        EXPORTING
          salesdocument     = lv_vbeln
          order_header_inx  = lst_header_inx
        TABLES
          return            = li_return_tab
          partnerchanges    = li_partners
        EXCEPTIONS
          incov_not_in_item = 1
          OTHERS            = 2.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        CLEAR lst_return.
        READ TABLE li_return_tab INTO lst_return WITH KEY type = 'E'. " Tab into lst of type
        IF sy-subrc EQ 0.
          lst_alv_display-message = lst_return-message.
          lst_alv_display-status = icon_red_light.
          lst_alv_display-cust_no = lst_excel_file-cust_no.
          lst_alv_display-order = lst_excel_file-order.
          lst_alv_display_mail = lst_alv_display.
          lst_alv_display_mail-status = 'Error'.
          APPEND lst_alv_display TO i_alv_display.
          APPEND lst_alv_display_mail TO i_alv_display_mail.
          CLEAR: lst_alv_display,lst_excel_file.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          READ TABLE li_return_tab INTO lst_return WITH KEY type = 'S'. " Tab into lst of type
          lst_alv_display-message = lst_return-message.
          lst_alv_display-status = icon_green_light.
          lst_alv_display-cust_no = lst_excel_file-cust_no.
          lst_alv_display-order = lst_excel_file-order.
          lst_alv_display_mail = lst_alv_display.
          lst_alv_display_mail-status = 'Success'.
          APPEND lst_alv_display TO i_alv_display.
          APPEND lst_alv_display_mail TO i_alv_display_mail.
          CLEAR: lst_alv_display,lst_excel_file.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
      CLEAR: li_partners.
    ENDLOOP. " LOOP AT fp_i_excel_file INTO DATA(lst_excel_file)

    IF i_alv_display[] IS NOT INITIAL.
      PERFORM f_display_alv_report.
    ENDIF. " IF i_alv_display[] IS NOT INITIAL
    IF sy-batch EQ abap_true.
      v_job_name = p_job.
*--*Below Subroutine is used to send Log as Email
      IF i_alv_display_mail[] IS NOT INITIAL.
        CLEAR:i_alv_display[].
        i_alv_display[] = i_alv_display_mail[].
        PERFORM f_send_log_email.
      ENDIF. " IF i_alv_display_mail[] IS NOT INITIAL
    ENDIF. " IF sy-batch EQ abap_true
  ENDIF. " IF li_excel_file IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       Subroutine to display ALV
*----------------------------------------------------------------------*
FORM f_display_alv_report .
  DATA: lst_layout  TYPE slis_layout_alv.

  PERFORM f_build_fcat.
  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat_out
    TABLES
      t_outtab           = i_alv_display
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
*    MESSAGE e000 WITH text-036.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_build_fcat .
  CLEAR: i_fcat_out[].
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat USING:
            lv_counter 'STATUS'      text-012   , "Status
            lv_counter 'ORDER'       text-013,
            lv_counter 'CUST_NO'     text-014,
            lv_counter 'MESSAGE'     text-015   . "Success/Error Msg
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILDCAT
*&---------------------------------------------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  CONSTANTS :           lc_tabname   TYPE tabname   VALUE 'I_ALV_DISPLAY'. " Table Name

  DATA: lst_fcat_out        TYPE slis_fieldcat_alv. " ALV specific tables and structures
  lst_fcat_out-col_pos      = fp_col + 1.
  lst_fcat_out-lowercase    = abap_true.
  lst_fcat_out-fieldname    = fp_fld.
  lst_fcat_out-tabname      = lc_tabname.
  lst_fcat_out-seltext_m    = fp_title.
  APPEND lst_fcat_out TO i_fcat_out.
  CLEAR lst_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       Send log in EMail
*----------------------------------------------------------------------*
FORM f_send_log_email .
  DATA: lv_con_cret TYPE c  VALUE cl_abap_char_utilities=>cr_lf, " Con_cret of type Character
        lst_message TYPE solisti1.                               " SAPoffice: Single List with Column Length 255

  CONCATENATE text-012 text-013 text-014 text-015
  INTO i_attach SEPARATED BY ','.
  CONCATENATE lv_con_cret i_attach INTO i_attach.
  APPEND  i_attach.

  LOOP AT i_alv_display_mail INTO DATA(lst_alv_display).
    CONCATENATE lst_alv_display-status lst_alv_display-order lst_alv_display-cust_no lst_alv_display-message
    INTO i_attach SEPARATED BY ','.
    CONCATENATE lv_con_cret i_attach INTO i_attach.
    APPEND  i_attach.
  ENDLOOP. " LOOP AT i_alv_display INTO DATA(lst_alv_display)

*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  lst_message = text-016. "Dear Wiley Customer,Please find Attachmen
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'JOB NAME:' v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  lst_message = text-017. "** Please do not reply to this email, as we are unable to respond from this address
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Send file by email as .xls speadsheet
  PERFORM f_send_csv_xls_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       send csv file via email
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log .
  DATA: lst_xdocdata    LIKE sodocchgi1,                           " Data of an object which can be changed
        lv_xcnt         TYPE i,                                    " Xcnt of type Integers
        lv_file_name    TYPE char100,                              " File_name of type CHAR100
        lst_usr21       TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6        TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        lv_p_mail       LIKE LINE OF p_mail,
        li_packing_list LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE, "Itab to hold packing list for email
        li_receivers    LIKE somlreci1 OCCURS 0 WITH HEADER LINE,  "Itab to hold mail receipents
        li_attachment   LIKE solisti1 OCCURS 0 WITH HEADER LINE,   " SAPoffice: Single List with Column Length 255
        lv_n            TYPE i, " N of type Integers
        lv_desc         TYPE SO_OBJ_DES.

  lv_desc = text-020.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = 'SAPRPT'.
  lst_xdocdata-obj_descr  = lv_desc.
  CLEAR li_attachment[].
  li_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR li_packing_list.
  li_packing_list-transf_bin = space.
  li_packing_list-head_start = 1.
  li_packing_list-head_num = 0.
  li_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES li_packing_list-body_num.
  li_packing_list-doc_type = 'RAW'.
  APPEND li_packing_list.
  IF i_attach[] IS NOT INITIAL.
    lv_n = 1.
*- Create attachment notification
    li_packing_list-transf_bin = abap_true.
    li_packing_list-head_start = 1.
    li_packing_list-head_num   = 1.
    li_packing_list-body_start = lv_n.

    DESCRIBE TABLE i_attach LINES li_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZPARTNR_UPD' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    li_packing_list-doc_type   =  'CSV'.
    li_packing_list-obj_descr  =  lv_file_name. "p_attdescription.
    li_packing_list-obj_name   =  lv_file_name. "'CMR'."p_filename.
    li_packing_list-doc_size   =  li_packing_list-body_num * 255.
    APPEND li_packing_list.
  ENDIF. " IF i_attach[] IS NOT INITIAL

  IF p_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT p_mail INTO lv_p_mail.
      CLEAR li_receivers.
      li_receivers-receiver = lv_p_mail-low.
      li_receivers-rec_type = 'U'.
      li_receivers-com_type = 'INT'. "c_int.
      li_receivers-notif_del = abap_true.
      li_receivers-notif_ndel = abap_true.
      APPEND li_receivers.
      CLEAR lv_p_mail.
    ENDLOOP. " LOOP AT p_mail INTO lv_p_mail
  ELSE. " ELSE -> IF p_mail[] IS NOT INITIAL
    CLEAR : lst_usr21,lst_adr6.
    SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = sy-uname.
    IF lst_usr21 IS NOT INITIAL.
      SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                              AND   persnumber = lst_usr21-persnumber.
    ENDIF. " IF lst_usr21 IS NOT INITIAL
*- Add the recipients email address
    CLEAR li_receivers.
    li_receivers-receiver = lst_adr6-smtp_addr.
    li_receivers-rec_type = 'U'.
    li_receivers-com_type = 'INT'.
    li_receivers-notif_del = abap_true.
    li_receivers-notif_ndel = abap_true.
    APPEND li_receivers.
  ENDIF. " IF p_mail[] IS NOT INITIAL
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_true
      commit_work                = abap_true
    TABLES
      packing_list               = li_packing_list
      contents_bin               = li_attachment
      contents_txt               = i_message
      receivers                  = li_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc NE 0.
    MESSAGE text-018 TYPE 'E'. "Error in sending Email
  ELSE. " ELSE -> IF sy-subrc NE 0
    MESSAGE text-019 TYPE 'S'. "Email sent with Success log file
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
