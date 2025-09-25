*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHG_ORDER_ITEM_TEXT_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SEL_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_sel_dynamics .
*- Define the object to be passed to the RESTRICTION parameter
  DATA: lst_restrict TYPE sscr_restrict,
        lst_optlist  TYPE sscr_opt_list,
        lst_ass      TYPE sscr_ass.
* Constant Declaration
  CONSTANTS: lc_name    TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lc_flag    TYPE flag VALUE 'X',                " General Flag
             lc_kind    TYPE rsscr_kind VALUE 'S',          " ABAP: Type of selection
*             lc_name1   TYPE blockname VALUE 'S_PO',        " Block name on selection screen
             lc_sg_main TYPE raldb_sign VALUE 'I',          " SIGN field in creation of SELECT-OPTIONS tables
             lc_sg_addy TYPE raldb_sign VALUE space,        " SIGN field in creation of SELECT-OPTIONS tables
             lc_op_main TYPE rsrest_opl VALUE 'OBJECTKEY1'. " Name of an options list for SELECT-OPTIONS restrictions
  CLEAR: lst_optlist , lst_ass.
* Restricting the KURST selection to only EQ.
  lst_optlist-name = lc_name.
  lst_optlist-options-eq = lc_flag.
  APPEND lst_optlist TO lst_restrict-opt_list_tab.

  lst_ass-kind = lc_kind.
  lst_ass-name = 'P_MAIL'.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lst_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization .
  REFRESH:li_vbap,li_tline,li_alv_disp_screen,li_excel_file,
          li_excel_file_tmp,li_mail,li_fcat_out,i_message,
          i_attach, i_attach_success,i_attach_error,
          i_packing_list,i_receivers,i_attachment.
  CLEAR: st_header,st_tline,st_alv_disp_screen,st_excel_file,
         st_fcat_out,st_layout,st_imessage,g_lines,g_path_fname,
         g_path_fname_n,g_job_name.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_dynamics .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file.
* Popup for file path

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.
  IF li_excel_file[] IS NOT INITIAL.
    SELECT vbeln posnr FROM vbap
           INTO TABLE li_vbap
           FOR ALL ENTRIES IN li_excel_file
           WHERE vbeln = li_excel_file-vbeln
           AND   posnr = li_excel_file-posnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_disp .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PLACE_FILE_IN_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_place_file_in_app .
  DATA :   lv_ftfront       TYPE rcgfiletr-ftfront,
           lv_ftappl        TYPE rcgfiletr-ftappl, "string, "sapb-sappfad, " rcgfiletr-ftappl,
           lv_flg_overwrite LIKE rcgfiletr-iefow,
           lv_ftftype       LIKE rcgfiletr-ftftype.
* Local data ----------------------------------------------------------
  DATA: lv_flg_continue    TYPE boolean.
  DATA: lv_flg_open_error  TYPE boolean.
  DATA: lv_os_message(100) TYPE c.
  DATA: lv_text1(40) TYPE c.
  DATA: lv_text2(40) TYPE c.
  DATA: lv_data TYPE string,
        lv_flag TYPE char1,                                          " Flag of type CHAR1
        lv_tab  TYPE c VALUE cl_abap_char_utilities=>horizontal_tab. " Tab of type Character
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Placing the file into application server'(002).
  CLEAR g_path_fname.

  CONCATENATE  p_a_file
              'ZORD_EALUPD'
              c_underscore
              sy-uname
              c_underscore
              sy-datum
              c_underscore
              sy-uzeit
              c_extn
              INTO
             g_path_fname.
  CONDENSE g_path_fname NO-GAPS.
  OPEN DATASET g_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
*    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
  LOOP AT li_excel_file INTO DATA(lst_file).

    CONCATENATE lst_file-vbeln lst_file-posnr   lst_file-eal
           INTO lv_data
      SEPARATED BY lv_tab.
    TRANSFER lv_data TO g_path_fname.
    CLEAR: lv_data.
  ENDLOOP.
  CLOSE DATASET g_path_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BATCH_JOB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM batch_job .
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status
* Local constant declaration
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'ZORD_EALUPD'. " Background job name
  CLEAR lv_job_name.
  CONCATENATE lc_job_name c_underscore sy-uzeit c_underscore sy-datum  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Processing the schedule in batch job'.
**Check if pre. Job name and job count is present
**then set the check pre. status to X else blank.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
*     sdlstrtdt        = sy-datum
*     sdlstrttm        = sy-uzeit
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    g_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcn_chg_ord_item_text_batch
                               WITH p_file =  g_path_fname
                               WITH p_mail IN  p_mail
                               WITH p_lang = p_lang
                               WITH p_object = p_object
                               WITH p_id   = p_id
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
*       pred_jobcount        = v_pre_job_cnt
*       pred_jobname         = v_pre_job_nam
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
      MESSAGE e000(zrtr_r1b) WITH text-024. " & & & & "Job could not be created
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.
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
FORM f_bapi_update_with_new_value  USING    p_p_user
                                            p_p_job
                                            p_p_lang
                                            p_p_object
                                            p_p_id
  CHANGING p_i_excel_file TYPE tt_excel_file
           p_i_mail TYPE tt_mail.
  li_excel_file[] = p_i_excel_file[].
  li_mail[] = p_i_mail[].
  p_mail[] = p_i_mail[].
  p_user = p_p_user.
  p_job  = p_p_job.
  p_lang = p_p_lang.
  p_object = p_p_object.
  p_id   = p_p_id.
  PERFORM f_get_data.
  PERFORM f_sales_ord_text_upd.
  IF  li_alv_disp_screen[] IS NOT INITIAL.
    PERFORM f_alv_report.
    PERFORM f_send_log_email.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SALES_ORD_TEXT_UPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_sales_ord_text_upd.
  DATA : st_read_text  TYPE TABLE OF tline,
         lst_read_text TYPE tline.
  SORT li_vbap BY vbeln posnr.
  LOOP AT li_excel_file INTO st_excel_file.
    st_alv_disp_screen-vbeln = st_excel_file-vbeln.
    st_alv_disp_screen-posnr = st_excel_file-posnr.
    READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = st_excel_file-vbeln
                                                    posnr = st_excel_file-posnr
                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      REFRESH:st_read_text,li_tline.
      CLEAR st_header.
      st_header-tdobject = p_object.
      CONCATENATE lst_vbap-vbeln lst_vbap-posnr INTO st_header-tdname.
      st_header-tdid = p_id.
      st_header-tdspras = p_lang.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = st_header-tdid
          language                = st_header-tdspras
          name                    = st_header-tdname
          object                  = st_header-tdobject
        TABLES
          lines                   = st_read_text
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ  0 AND st_read_text[] IS NOT INITIAL.
        READ TABLE st_read_text INTO lst_read_text INDEX 1.
        st_alv_disp_screen-old_eal = lst_read_text-tdline.
        IF st_alv_disp_screen-old_eal NE st_excel_file-eal.
          CALL FUNCTION 'DELETE_TEXT'
            EXPORTING
              client          = sy-mandt
              id              = st_header-tdid
              language        = st_header-tdspras
              name            = st_header-tdname
              object          = st_header-tdobject
              savemode_direct = c_x
*             TEXTMEMORY_ONLY = ' '
*             LOCAL_CAT       = ' '
            EXCEPTIONS
              not_found       = 1
              OTHERS          = 2.
          IF sy-subrc EQ 0.
            IF st_excel_file-eal IS NOT INITIAL.
              st_tline-tdformat = '*'.
              st_tline-tdline = st_excel_file-eal.
              APPEND st_tline TO li_tline.
              CALL FUNCTION 'SAVE_TEXT'
                EXPORTING
                  header          = st_header
                  insert          = c_x
                  savemode_direct = c_x
                TABLES
                  lines           = li_tline
                EXCEPTIONS
                  id              = 1
                  language        = 2
                  name            = 3
                  object          = 4
                  OTHERS          = 5.
              IF sy-subrc EQ 0.
* Implement suitable error handling here
                CALL FUNCTION 'COMMIT_TEXT'.
                st_alv_disp_screen-new_eal = st_excel_file-eal.
                st_alv_disp_screen-status =  'Success'(011).
                st_alv_disp_screen-status_message = 'EAL text is updated successfully'(012).
                APPEND st_alv_disp_screen TO li_alv_disp_screen.
                CLEAR st_alv_disp_screen.
              ELSE.
                st_alv_disp_screen-new_eal = st_excel_file-eal.
                st_alv_disp_screen-status = 'Error'(013).
                st_alv_disp_screen-status_message = 'EAL Text not updated to given sales document and item'(014).
                APPEND st_alv_disp_screen TO li_alv_disp_screen.
                CLEAR st_alv_disp_screen.
              ENDIF.
            ELSE.
              st_alv_disp_screen-status = 'Error'.
              st_alv_disp_screen-status_message = 'EAL text is not existed in excel file'.
              APPEND st_alv_disp_screen TO li_alv_disp_screen.
              CLEAR st_alv_disp_screen.
            ENDIF.
          ENDIF.
        ELSE.
          st_alv_disp_screen-new_eal = st_excel_file-eal.
          st_alv_disp_screen-status =  'Success'.
          st_alv_disp_screen-status_message =  'OLD and NEW EAL numbers are same'.
          APPEND st_alv_disp_screen TO li_alv_disp_screen.
          CLEAR st_alv_disp_screen.
        ENDIF.
      ELSE.
        IF st_excel_file-eal IS NOT INITIAL.
          st_tline-tdformat = '*'.
          st_tline-tdline = st_excel_file-eal.
          APPEND st_tline TO li_tline.
          CALL FUNCTION 'SAVE_TEXT'
            EXPORTING
              header          = st_header
              insert          = c_x
              savemode_direct = c_x
            TABLES
              lines           = li_tline
            EXCEPTIONS
              id              = 1
              language        = 2
              name            = 3
              object          = 4
              OTHERS          = 5.
          IF sy-subrc EQ 0.
* Implement suitable error handling here
            CALL FUNCTION 'COMMIT_TEXT'.
            st_alv_disp_screen-new_eal = st_excel_file-eal.
            st_alv_disp_screen-status =  'Success'.
            st_alv_disp_screen-status_message = 'EAL text is updated successfully'.
            APPEND st_alv_disp_screen TO li_alv_disp_screen.
            CLEAR st_alv_disp_screen.
          ELSE.
            st_alv_disp_screen-new_eal = st_excel_file-eal.
            st_alv_disp_screen-status = 'Error'.
            st_alv_disp_screen-status_message = 'EAL Text not updated to given sales document and item'.
            APPEND st_alv_disp_screen TO li_alv_disp_screen.
            CLEAR st_alv_disp_screen.
          ENDIF.
        ELSE.
          st_alv_disp_screen-status = 'Error'.
          st_alv_disp_screen-status_message = 'EAL text is not existed in excel file'.
          APPEND st_alv_disp_screen TO li_alv_disp_screen.
          CLEAR st_alv_disp_screen.
        ENDIF.
      ENDIF.
    ELSE.
      st_alv_disp_screen-status = 'Error'.
      st_alv_disp_screen-status_message = 'Given Sales document and item does not exists in SAP'.
      APPEND st_alv_disp_screen TO li_alv_disp_screen.
      CLEAR st_alv_disp_screen.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_READ_FROM_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_file_read_from_excel .
  DATA : i_raw_data   TYPE  truxs_t_text_data.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = c_x
      i_tab_raw_data       = i_raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = li_excel_file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc EQ 0.
    li_excel_file_tmp[] = li_excel_file[].
    REFRESH li_excel_file.
    LOOP AT li_excel_file_tmp INTO DATA(lst_excel).
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_excel-vbeln
        IMPORTING
          output = st_excel_file-vbeln.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_excel-posnr
        IMPORTING
          output = st_excel_file-posnr.
      st_excel_file-eal = lst_excel-eal.
      APPEND st_excel_file TO li_excel_file.
      CLEAR:st_excel_file,lst_excel.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_report .
  PERFORM f_build_fcat.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      is_layout                = st_layout
      it_fieldcat              = li_fcat_out
    TABLES
      t_outtab                 = li_alv_disp_screen
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
*    MESSAGE text-091 TYPE c_i.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*&------------------
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .
  REFRESH li_fcat_out.
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat USING:
            lv_counter 'VBELN'            text-005   , "Sales Document
            lv_counter 'POSNR'            text-006   , "Item
            lv_counter 'OLD_EAL'          text-007   , "Old EAL
            lv_counter 'NEW_EAL'          text-008   , "New EAL
            lv_counter 'STATUS'           text-009   , "Status
            lv_counter 'STATUS_MESSAGE'   text-010   . "Success/Error Msg
ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------
*       text
**-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  CONSTANTS :           lc_tabname       TYPE tabname   VALUE 'I_OUTPUT_X'. " Table Name
  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.
  IF fp_fld = 'VBELN'.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  IF fp_fld = 'POSNR'.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  APPEND st_fcat_out TO li_fcat_out.
  CLEAR st_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_log_email .
*-  Populate table with detaisl to be entered into .xls file
  PERFORM build_batch_log_data .
*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage =      'Dear User,'.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage =      'Please find below job details that have been submitted for your upload'.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Populate message body text
  CONCATENATE 'JOB NAME:' p_job INTO st_imessage SEPARATED BY space.
*  st_imessage = text-030."Dear Wiley Customer,Please find Attachmen
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage =      'Please find attached status file after job processed successfully'.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage = '** Please do not reply to this email, as we are unable to respond from this address'.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Send file by email as .xls speadsheet
  PERFORM send_csv_xls_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_csv_xls_log .
  DATA: lst_xdocdata LIKE sodocchgi1,
        lv_xcnt      TYPE i,
        lv_file_name TYPE char100,
        lst_usr21    TYPE usr21,
        lst_adr6     TYPE adr6,
        lv_p_mail    LIKE LINE OF p_mail.
  DATA: n TYPE i.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.
  g_job_name = p_job.
*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = c_saprpt."text-106.
  lst_xdocdata-obj_descr = g_job_name."text-032. "Sales Order Update with MQ no Log

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt."text-106.
  lst_xdocdata-obj_descr  = g_job_name."text-032."Sales Order Update with MQ no Log
  CLEAR i_attachment.  REFRESH i_attachment.
  i_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw."c_raw.
  APPEND i_packing_list.

*- Create attachment notification
  i_packing_list-transf_bin = c_x.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 1.
  i_packing_list-body_start = 1.

  DESCRIBE TABLE i_attach LINES i_packing_list-body_num.
*  DESCRIBE TABLE i_contents_hex LINES i_packing_list-body_num.
  CONCATENATE 'ZUPD_EAL' sy-datum sy-uzeit INTO lv_file_name SEPARATED BY '_'.
  i_packing_list-doc_type   =  'XLS'."c_xls."'BIN'."p_format.
  i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
  i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
  i_packing_list-doc_size   =  i_packing_list-body_num * 255.
  APPEND i_packing_list.

  IF p_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT p_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver = lv_p_mail-low.
      i_receivers-rec_type = c_u.
      i_receivers-com_type = c_int."c_int.
      i_receivers-notif_del = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ELSE.
    CLEAR : lst_usr21,lst_adr6.
    SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = sy-uname.
    IF lst_usr21 IS NOT INITIAL.
      SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                              AND   persnumber = lst_usr21-persnumber.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.  REFRESH i_receivers.
    i_receivers-receiver = lst_adr6-smtp_addr.
    i_receivers-rec_type = c_u.
    i_receivers-com_type = c_int."c_int.
    i_receivers-notif_del = c_x.
    i_receivers-notif_ndel = c_x.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_message
      receivers                  = i_receivers
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
    MESSAGE text-033 TYPE c_i."Error in sending Email
  ELSE.
    MESSAGE text-034 TYPE c_s. "Email sent with Success log file
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_JOB_NAME  text
*----------------------------------------------------------------------*
FORM f_display_message  USING    p_lv_job_name.
  TYPE-POOLS : slis.
  TYPES : BEGIN OF ty_tab,
            job(32) TYPE c,
            user    TYPE sy-uname,
            date    TYPE sy-datum,
            time    TYPE sy-uzeit,
          END OF ty_tab.
  DATA : li_tab     TYPE STANDARD TABLE OF ty_tab,
         lst_tab    TYPE ty_tab,
         li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = c_x.
  lst_layout-zebra = c_x.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'JOB'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = 'JOB Name'.
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'USER'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = 'User Name'.
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'DATE'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = 'Scheduled Date'.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'TIME'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = 'Scheduled Time'.
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_tab-job = p_lv_job_name.
  lst_tab-user = sy-uname.
  lst_tab-date = sy-datum.
  lst_tab-time = sy-uzeit.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-075
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
*&      Form  BUILD_BATCH_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_batch_log_data .
  REFRESH:i_attach.
*- For Final Records
  CONCATENATE 'Sales Document' 'Item' 'OLD EAL' 'NEW EAL' 'Status' 'Success/Error Msg'
      INTO i_attach SEPARATED BY c_separator."con_tab.

  CONCATENATE con_cret i_attach INTO i_attach.
  APPEND  i_attach.

  LOOP AT li_alv_disp_screen INTO st_alv_disp_screen.
*- For Final Records
    CONCATENATE  st_alv_disp_screen-vbeln        st_alv_disp_screen-posnr
                 st_alv_disp_screen-old_eal      st_alv_disp_screen-new_eal
                 st_alv_disp_screen-status         st_alv_disp_screen-status_message
             INTO i_attach SEPARATED BY c_separator.
    CONCATENATE con_cret i_attach  INTO i_attach.
    APPEND  i_attach.

  ENDLOOP.
ENDFORM.
