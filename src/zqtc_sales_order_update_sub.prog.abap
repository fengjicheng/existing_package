*&---------------------------------------------------------------------*
*&  Include           ZQTC_SALES_ORDER_UPDATE_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA_FROM_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_data_from_excel .
  DATA : i_raw_data       TYPE                   truxs_t_text_data,
         lv_filename      TYPE rlgrap-filename,
         li_intern        TYPE kcde_intern,
         lst_intern       TYPE kcde_intern_struc,
         lst_intern_dummy TYPE kcde_intern_struc,
         lv_index         TYPE i.
*  FIELD-SYMBOLS:  TYPE any.

**Get input data into internal table
  lv_filename  = p_file.
*Read the CSV file data to an internal table
  CALL FUNCTION 'KCD_CSV_FILE_TO_INTERN_CONVERT'
    EXPORTING
      i_filename      = lv_filename
      i_separator     = c_separator
    TABLES
      e_intern        = li_intern
    EXCEPTIONS
      upload_csv      = 1
      upload_filetype = 2
      OTHERS          = 3.
  LOOP AT li_intern INTO lst_intern.
    lst_intern_dummy = lst_intern.
    IF lst_intern_dummy-value(1) EQ text-sqt.
      lst_intern_dummy-value(1) = space.
      SHIFT lst_intern_dummy-value LEFT DELETING LEADING space.
    ENDIF. " IF lst_excel_dummy-value(1) EQ text-sqt
    AT NEW col.
      CASE lst_intern_dummy-col.
        WHEN 1.
          IF NOT st_excel_file IS INITIAL.
            APPEND st_excel_file TO i_excel_file.
            CLEAR st_excel_file.
          ENDIF. " IF NOT lst_final IS INITIA
          st_excel_file-leg_ref = lst_intern_dummy-value(12).
        WHEN 10.
          st_excel_file-leg_mq_no = lst_intern_dummy-value(32).
          IF NOT st_excel_file IS INITIAL.
            APPEND st_excel_file TO i_excel_file.
            CLEAR st_excel_file.
          ENDIF. " IF NOT lst_final IS INITIA
      ENDCASE.
    ENDAT.
  ENDLOOP.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-035. "File upload is completed
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_UPDATE_WITH_NEW_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bapi_update_with_new_value USING    fp_recon
                                           p_ind
                                           p_user
                                           p_job
                                  CHANGING fp_i_excel_file TYPE tt_excel_file
                                           fp_mail  TYPE tt_mail.
  TYPES : BEGIN OF ty_vbeln,
            vbeln TYPE vbeln, " Sales Document Numnber
          END OF ty_vbeln.
  DATA: header       TYPE bapisdhead1,                   " Communication Fields: Sales and Distribution Document Header
        header_inx   TYPE bapisdhead1x,                  " Checkbox Fields for Sales and Distribution Document Header
        item_inx_tab TYPE STANDARD TABLE OF bapisditemx, " Communication Fields: Sales and Distribution Document Item
        item_inx     TYPE bapisditemx,                   " Communication Fields: Sales and Distribution Document Item
        return_tab   TYPE STANDARD TABLE OF bapiret2,    " Return Parameter
        lst_return   TYPE bapiret2,    " Return Parameter
        li_vbeln     TYPE STANDARD TABLE OF ty_vbeln,
        lst_vbeln    TYPE ty_vbeln,
        lv_vbeln     TYPE vbak-vbeln,
        lv_lines     TYPE i,
        lv_ind       TYPE char20,
        lv_ind_tmp   TYPE char20,
        lv_index     TYPE sy-tabix.
  REFRESH:i_excel_file.
  i_excel_file[] = fp_i_excel_file[].

  p_mail[] = fp_mail[].
  p_recon  = fp_recon.
  IF sy-batch NE c_x.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = text-007. "Subscription order is updating with new value
  ENDIF.
  DESCRIBE TABLE i_excel_file LINES lv_lines.
  SORT li_vbeln BY vbeln.
  CLEAR :lv_index,lv_ind,lv_ind_tmp.
  IF lv_lines > p_recon.
    lv_ind = lv_ind_tmp = p_recon.
*  ELSEIF lv_lines > 1000.

  ELSE.
    lv_ind = lv_ind_tmp = '100'.
  ENDIF.
  CONDENSE: lv_ind_tmp,lv_ind.
  DELETE fp_i_excel_file WHERE leg_ref = space.
  IF fp_i_excel_file[] IS NOT INITIAL.
    SELECT vbeln posnr ihrez FROM vbkd
                             INTO TABLE i_vbkd
                             FOR ALL ENTRIES IN fp_i_excel_file
                             WHERE ihrez = fp_i_excel_file-leg_ref.
    IF i_vbkd[] IS NOT INITIAL.
      SELECT vbeln erdat bname FROM vbak
                         INTO TABLE i_vbak
                         FOR ALL ENTRIES IN i_vbkd
                         WHERE vbeln = i_vbkd-vbeln.
    ENDIF.
  ENDIF.
  SORT i_vbkd BY ihrez.
  SORT i_vbak BY vbeln.
  LOOP AT fp_i_excel_file INTO st_excel_file.
    lv_index = sy-tabix.
    IF sy-batch = c_x.
      IF lv_index EQ lv_ind.
        MESSAGE i000(zqtc_r2) WITH lv_ind text-008 lv_lines  text-009. "Processsed Successfully
        lv_ind = lv_ind + lv_ind_tmp.
        CONDENSE lv_ind.
      ENDIF.
    ENDIF.
    IF p_ind = c_x.
      CLEAR :st_vbkd , st_vbak.
      READ TABLE i_vbkd INTO st_vbkd WITH KEY ihrez = st_excel_file-leg_ref
                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE i_vbak INTO st_vbak WITH KEY vbeln = st_vbkd-vbeln
                                       BINARY SEARCH.
        IF sy-subrc EQ 0 AND ( st_vbak-bname NE st_excel_file-leg_mq_no OR st_vbak-bname = space ).
          lv_vbeln = st_vbak-vbeln.
          header-name = st_excel_file-leg_mq_no.
          header_inx-updateflag = c_u.
          header_inx-name = c_x.

          CALL FUNCTION 'BAPI_SALESDOCUMENT_CHANGE'
            EXPORTING
              salesdocument    = lv_vbeln
              order_header_in  = header
              order_header_inx = header_inx
*             SIMULATION       = ' '
            TABLES
              return           = return_tab
              item_inx         = item_inx_tab.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = c_x.
          CLEAR lst_return.
          READ TABLE return_tab INTO lst_return WITH KEY type = c_e.
          IF sy-subrc EQ 0.
            st_alv_disp_file-leg_ref = st_excel_file-leg_ref.
            st_alv_disp_file-leg_mq_no = st_excel_file-leg_mq_no.
            st_alv_disp_file-sap_cont_no = st_vbak-vbeln.
            st_alv_disp_file-sap_mq_no = st_vbak-bname.
            st_alv_disp_file-status = text-013.
            st_alv_disp_file-status_message = lst_return-message."text-014. "Given Legacy MQ No & SAP MQ no both are same
            APPEND st_alv_disp_file TO i_alv_disp_file.
            APPEND st_alv_disp_file TO i_alv_disp_file_m.
            CLEAR: st_alv_disp_file,st_excel_file.
          ELSE.
            READ TABLE return_tab INTO lst_return WITH KEY type = c_s.
            st_alv_disp_file-leg_ref = st_excel_file-leg_ref.
            st_alv_disp_file-leg_mq_no = st_excel_file-leg_mq_no.
            st_alv_disp_file-sap_cont_no = st_vbak-vbeln.
            st_alv_disp_file-sap_mq_no = st_vbak-bname.
            st_alv_disp_file-status = text-010. "Success
            CONCATENATE     text-012 lv_vbeln text-011 "Updated with
                            st_excel_file-leg_mq_no INTO st_alv_disp_file-status_message
                            SEPARATED BY space.
            APPEND st_alv_disp_file TO i_alv_disp_file.
            APPEND st_alv_disp_file TO i_alv_disp_file_m.
            CLEAR: st_alv_disp_file,st_excel_file.
          ENDIF.
        ELSE.
          st_alv_disp_file-leg_ref = st_excel_file-leg_ref.
          st_alv_disp_file-leg_mq_no = st_excel_file-leg_mq_no.
          st_alv_disp_file-sap_cont_no = st_vbak-vbeln.
          st_alv_disp_file-sap_mq_no = st_vbak-bname.
          st_alv_disp_file-status = text-013.
          st_alv_disp_file-status_message = text-014.
          APPEND st_alv_disp_file TO i_alv_disp_file.
          APPEND st_alv_disp_file TO i_alv_disp_file_m.
          CLEAR: st_alv_disp_file,st_excel_file.
        ENDIF.
      ELSE.
        st_alv_disp_file-leg_ref = st_excel_file-leg_ref.
        st_alv_disp_file-leg_mq_no = st_excel_file-leg_mq_no.
        st_alv_disp_file-status = text-013.
        st_alv_disp_file-status_message = text-015. "Given Legacy Ref No does not exists in SAP
        APPEND st_alv_disp_file TO i_alv_disp_file.
        APPEND st_alv_disp_file TO i_alv_disp_file_m.
        CLEAR: st_alv_disp_file,st_excel_file.
      ENDIF.
    ELSE.
      CLEAR :st_vbkd , st_vbak.
      READ TABLE i_vbkd INTO st_vbkd WITH KEY ihrez = st_excel_file-leg_ref
                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE i_vbak INTO st_vbak WITH KEY vbeln = st_vbkd-vbeln
                               BINARY SEARCH.
        IF sy-subrc EQ 0.
          st_alv_disp_file-sap_cont_no = st_vbak-vbeln.
          st_alv_disp_file-sap_mq_no = st_vbak-bname.
        ENDIF.
      ENDIF.
      st_alv_disp_file-leg_ref = st_excel_file-leg_ref.
      st_alv_disp_file-leg_mq_no = st_excel_file-leg_mq_no.
      st_alv_disp_file-status_message  =  text-016. "Select Update Indicator check box to update Legacy MQ Number
      APPEND st_alv_disp_file TO i_alv_disp_file.
      APPEND st_alv_disp_file TO i_alv_disp_file_m.
      CLEAR: st_alv_disp_file,st_excel_file.
    ENDIF.
    CLEAR st_excel_file.
  ENDLOOP.
  IF i_alv_disp_file[] IS NOT INITIAL.
    PERFORM f_alv_report.
  ENDIF.
  IF sy-batch EQ c_x.
    g_job_name = p_job.
*--*Below Subroutine is used to send Log as Email
    IF i_alv_disp_file_m[] IS NOT INITIAL.
      REFRESH i_alv_disp_file_t.
      i_alv_disp_file_t[] = i_alv_disp_file[].
      REFRESH:i_alv_disp_file.
      i_alv_disp_file[] = i_alv_disp_file_m[].
      PERFORM f_send_log_email.
    ENDIF.
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
  st_layout-colwidth_optimize = c_x.
  st_layout-zebra = c_x.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      i_callback_top_of_page   = 'TOP-OF-PAGE'
      is_layout                = st_layout
      it_fieldcat              = i_fcat_out
    TABLES
      t_outtab                 = i_alv_disp_file
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
*    MESSAGE e000 WITH text-036.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*-------------------------------------------------------------------*
* Form  TOP-OF-PAGE                                                 *
*-------------------------------------------------------------------*
* ALV Report Header                                                 *
*-------------------------------------------------------------------*
FORM top-of-page.
*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c,
        li_fail       TYPE STANDARD TABLE OF ty_alv_disp_file,
        li_succ       TYPE STANDARD TABLE OF ty_alv_disp_file,
        lv_f(20)      TYPE i,
        lv_s(20)      TYPE i,
        lv_f_c(20)    TYPE c,
        lv_s_c(20)    TYPE c.


  CLEAR : lv_f,lv_s,lv_f_c,lv_s_c.
  REFRESH:li_fail,li_succ.

  li_fail[]  = i_alv_disp_file[].
  li_succ[] = i_alv_disp_file[].
  DELETE li_fail WHERE status = text-013.
  DESCRIBE TABLE li_fail LINES lv_f.
  DELETE li_succ WHERE ( status = text-010 OR status = space ).
  DESCRIBE TABLE li_succ LINES lv_s.

  lv_s_c = lv_s.
  lv_f_c = lv_f.
  CONDENSE lv_s_c.
  CONDENSE lv_f_c.
* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Sales Order Update with MQ Number'(036).
  APPEND wa_header TO t_header.
  CLEAR wa_header.

  wa_header-typ  = 'S'.
*  wa_header-key = 'Total No.of Success'.
  CONCATENATE 'Total No.of Records Success :' lv_f_c  INTO wa_header-info SEPARATED BY space.   "todays date
  APPEND wa_header TO t_header.
  CLEAR: wa_header.


  wa_header-typ  = 'S'.
  CONCATENATE 'Total No.of Records Error :'  lv_s_c INTO wa_header-info SEPARATED BY space.   "todays date
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
*            i_logo             = 'Z_LOGO'.
ENDFORM.                    "top-of-page

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .

  REFRESH i_fcat_out.
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat USING:
            lv_counter 'LEG_REF'            text-017   , "Legacy Ref No
            lv_counter 'LEG_MQ_NO'          text-018   , "Legacy MQ No
            lv_counter 'SAP_CONT_NO'        text-019   , "SAP Contract No
            lv_counter 'SAP_MQ_NO'          text-020   , "SAP MQ No
            lv_counter 'STATUS'             text-021   , "Status
            lv_counter 'STATUS_MESSAGE'     text-022   . "Success/Error Msg
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
  IF fp_fld = 'SAP_CONT_NO'.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

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
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'ZORD_MQUPD'. " Background job name
  CLEAR lv_job_name.
  CONCATENATE lc_job_name c_underscore sy-uzeit c_underscore sy-datum  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-023. "Processing the schedule in batch job
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
    SUBMIT zqtcr_sales_order_upload_batch
                               WITH p_file =  g_path_fname
                               WITH p_mail IN  p_mail
                               WITH p_ind  = p_ind
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
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_JOB_NAME  text
*----------------------------------------------------------------------*
FORM f_display_message  USING    fp_lv_job_name.
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
  lst_fcat-seltext_m      = text-025."JOB Name
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'USER'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = text-026."User Name.
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'DATE'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = text-027."Scheduled Date
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'TIME'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = text-028. "Scheduled Time
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
      text = text-029. "Placing the file into application server
  CLEAR g_path_fname.
*  TRANSLATE p_a_file TO LOWER CASE.
  CONCATENATE  p_a_file
              'ZORD_MQUPD'
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
  lv_ftfront = p_file."v_p_path.
  lv_ftappl = g_path_fname.
  DATA: i_flg_overwrite   TYPE esp1_boolean,
        l_flg_open_error  TYPE esp1_boolean,
        l_os_message(100) TYPE c.
  CALL FUNCTION 'C13Z_FILE_UPLOAD_ASCII'
    EXPORTING
      i_file_front_end   = lv_ftfront "'C:\Users\sguda\Desktop\Order_upd.txt'
      i_file_appl        = lv_ftappl
      i_file_overwrite   = i_flg_overwrite "ESP1_FALSE
    IMPORTING
      e_flg_open_error   = l_flg_open_error
      e_os_message       = l_os_message
    EXCEPTIONS
      fe_file_not_exists = 1
      fe_file_read_error = 2
      ap_no_authority    = 3
      ap_file_open_error = 4
      ap_file_exists     = 5
      ap_convert_error   = 6
      OTHERS             = 7.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
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
*&      Form  F_SCREEN_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_dynamics .
  IF rb_input = c_x AND rb_file NE c_x.
    LOOP AT SCREEN.
      IF screen-group1 = c_m1.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m4.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m5.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m6.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m3.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m7.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m8.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m9.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m10.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m11.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m12.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m2.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF rb_input NE c_x AND rb_file EQ c_x.
    LOOP AT SCREEN.
      IF screen-group1 = c_m1.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m4.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m5.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m6.
        screen-input = screen-active = screen-output = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m3.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m2.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m7.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = c_m8.
        screen-input = screen-active = screen-output = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PO_DYNAMICS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_po_dynamics .
  text = 'Update Indicator'.
*  TRANSLATE p_a_file TO LOWER CASE.
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
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  IF ( s_vbeln IS NOT INITIAL OR s_erdat IS NOT INITIAL ) AND s_ihrez IS INITIAL.
    SELECT vbeln erdat bname FROM vbak
                       INTO TABLE i_vbak
                       WHERE vbeln IN s_vbeln
                       AND   erdat IN s_erdat.
    IF i_vbak[] IS NOT INITIAL.
      SELECT vbeln posnr ihrez
                       FROM vbkd
                       INTO TABLE i_vbkd
                       FOR ALL ENTRIES IN i_vbak
                       WHERE vbeln = i_vbak-vbeln
                       AND   ihrez IN s_ihrez.
    ENDIF.
  ELSEIF s_ihrez IS NOT INITIAL.
    SELECT vbeln posnr ihrez
                     FROM vbkd
                     INTO TABLE i_vbkd
                     WHERE ihrez IN s_ihrez.
    IF i_vbkd[] IS NOT INITIAL.
      SELECT vbeln erdat bname FROM vbak
                      INTO TABLE i_vbak
                      FOR ALL ENTRIES IN i_vbkd
                      WHERE vbeln = i_vbkd-vbeln
                      AND   erdat IN s_erdat.
    ENDIF.
  ENDIF.
  SORT i_vbkd BY vbeln posnr ihrez.
  DELETE ADJACENT DUPLICATES FROM i_vbkd COMPARING vbeln posnr ihrez.
  DELETE i_vbkd WHERE posnr EQ c_0.
  PERFORM f_build_final_table.
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
  PERFORM f_build_fcat_screen.
  st_layout-colwidth_optimize = c_x.
  st_layout-zebra = c_x.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      is_layout                = st_layout
      it_fieldcat              = i_fcat_out
    TABLES
      t_outtab                 = i_alv_disp_screen
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
*    MESSAGE e000 WITH text-036.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FINAL_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_final_table .
  SORT i_vbkd BY vbeln.
  LOOP AT i_vbak INTO st_vbak.
    st_alv_disp_screen-sap_cont_no = st_vbak-vbeln.
    st_alv_disp_screen-sap_mq_no   = st_vbak-bname.
    READ TABLE i_vbkd INTO st_vbkd WITH KEY vbeln = st_vbak-vbeln
                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_alv_disp_screen-leg_ref    = st_vbkd-ihrez.
    ENDIF.
    APPEND st_alv_disp_screen TO i_alv_disp_screen.
    CLEAR: st_alv_disp_screen,st_vbkd,st_vbak.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat_screen .
  REFRESH i_fcat_out.
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat_screen USING:
            lv_counter 'LEG_REF'            text-017,
            lv_counter 'LEG_MQ_NO'          text-018,
            lv_counter 'SAP_CONT_NO'        text-019,
            lv_counter 'SAP_MQ_NO'          text-020.

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
FORM f_buildcat_screen  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  CONSTANTS :           lc_tabname       TYPE tabname   VALUE 'I_OUTPUT_X'. " Table Name
  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.
  IF fp_fld = 'SAP_CONT_NO'.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  APPEND st_fcat_out TO i_fcat_out.
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
  PERFORM build_csv_log_data .

*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage = text-030."Dear Wiley Customer,Please find Attachmen
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Populate message body text
  CONCATENATE 'JOB NAME:' g_job_name INTO st_imessage SEPARATED BY space.
*  st_imessage = text-030."Dear Wiley Customer,Please find Attachmen
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage = text-031."** Please do not reply to this email, as we are unable to respond from this address
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Send file by email as .xls speadsheet
  PERFORM send_csv_xls_log.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_XLS_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_csv_log_data .
  REFRESH: i_attach_success,i_attach,i_attach_error.
  READ TABLE i_alv_disp_file INTO st_alv_disp_file WITH KEY status = 'Success'(010).
  IF sy-subrc EQ 0.
*- Only Success records
    CONCATENATE text-017 text-018 text-019  text-020
                text-021 text-022
        INTO i_attach_success SEPARATED BY c_separator."con_tab.
*- For Final Records
    CONCATENATE text-017 text-018 text-019  text-020
                text-021 text-022
        INTO i_attach SEPARATED BY c_separator."con_tab.

    CONCATENATE con_cret i_attach_success INTO i_attach_success.
    APPEND  i_attach_success.

    CONCATENATE con_cret i_attach INTO i_attach.
    APPEND  i_attach.

    LOOP AT i_alv_disp_file INTO st_alv_disp_file WHERE status = 'Success'(010).
*- Only Success records
      CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                   st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                   st_alv_disp_file-status         st_alv_disp_file-status_message
               INTO i_attach_success SEPARATED BY c_separator.
      CONCATENATE con_cret i_attach_success  INTO i_attach_success.
      APPEND  i_attach_success.
*- For Final Records
      CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                   st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                   st_alv_disp_file-status         st_alv_disp_file-status_message
               INTO i_attach SEPARATED BY c_separator.
      CONCATENATE con_cret i_attach INTO i_attach.
      APPEND  i_attach.

    ENDLOOP.
  ENDIF.
  CLEAR st_alv_disp_file.
  READ TABLE i_alv_disp_file INTO st_alv_disp_file WITH KEY status = 'Failed'(013).
  IF sy-subrc EQ 0.
*- Only Failed Records
    CONCATENATE text-017 text-018 text-019  text-020
                text-021 text-022
        INTO i_attach_error  SEPARATED BY c_separator."con_tab.

    CONCATENATE con_cret i_attach_error  INTO i_attach_error.
    APPEND  i_attach_error.
*- For Final records
    CONCATENATE text-017 text-018 text-019  text-020
                text-021 text-022
        INTO i_attach  SEPARATED BY c_separator."con_tab.

    CONCATENATE con_cret i_attach  INTO i_attach.
    APPEND  i_attach.

    CLEAR st_alv_disp_file.
    LOOP AT i_alv_disp_file INTO st_alv_disp_file WHERE ( status = 'Failed'(013) OR status = space ).
*- Only Failed Records
      CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                   st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                   st_alv_disp_file-status         st_alv_disp_file-status_message
               INTO i_attach_error SEPARATED BY c_separator.
      CONCATENATE con_cret i_attach_error  INTO i_attach_error.
      APPEND  i_attach_error.
*- For Final records
      CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                   st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                   st_alv_disp_file-status         st_alv_disp_file-status_message
               INTO i_attach SEPARATED BY c_separator.
      CONCATENATE con_cret i_attach  INTO i_attach.
      APPEND  i_attach.
    ENDLOOP.
  ELSE.
    READ TABLE i_alv_disp_file INTO st_alv_disp_file WITH KEY status = space.
    IF sy-subrc EQ 0.
*- Only Failed Records
      CONCATENATE text-017 text-018 text-019  text-020
                  text-021 text-022
          INTO i_attach_error  SEPARATED BY c_separator."con_tab.

      CONCATENATE con_cret i_attach_error  INTO i_attach_error.
      APPEND  i_attach_error.
*- For Final records
      CONCATENATE text-017 text-018 text-019  text-020
                  text-021 text-022
          INTO i_attach  SEPARATED BY c_separator."con_tab.

      CONCATENATE con_cret i_attach  INTO i_attach.
      APPEND  i_attach.

      CLEAR st_alv_disp_file.
      LOOP AT i_alv_disp_file INTO st_alv_disp_file WHERE ( status = space OR status = 'Failed'(013) ).
*- Only Failed Records
        CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                     st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                     st_alv_disp_file-status         st_alv_disp_file-status_message
                 INTO i_attach_error SEPARATED BY c_separator.
        CONCATENATE con_cret i_attach_error  INTO i_attach_error.
        APPEND  i_attach_error.
*- For Final records
        CONCATENATE  st_alv_disp_file-leg_ref        st_alv_disp_file-leg_mq_no
                     st_alv_disp_file-sap_cont_no    st_alv_disp_file-sap_mq_no
                     st_alv_disp_file-status         st_alv_disp_file-status_message
                 INTO i_attach SEPARATED BY c_separator.
        CONCATENATE con_cret i_attach  INTO i_attach.
        APPEND  i_attach.
      ENDLOOP.
    ENDIF.
  ENDIF.
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
  IF i_attach_success[] IS NOT INITIAL.
    n = 1.
*- Create attachment notification
    i_packing_list-transf_bin = c_x.
    i_packing_list-head_start = 1.
    i_packing_list-head_num   = 1.
    i_packing_list-body_start = n.

    DESCRIBE TABLE i_attach_success LINES i_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZORD_MQUPD' 'Success' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    i_packing_list-doc_type   =  c_csv.
    i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
    i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
    i_packing_list-doc_size   =  i_packing_list-body_num * 255.
    APPEND i_packing_list.
  ENDIF.
  IF i_attach_error[] IS NOT INITIAL.

    n = n + i_packing_list-body_num.
*- Create attachment notification
    i_packing_list-transf_bin = c_x.
    i_packing_list-head_start = 1.
    i_packing_list-head_num   = 1.
    i_packing_list-body_start = n.

    CLEAR lv_file_name.
    DESCRIBE TABLE i_attach_error LINES i_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZORD_MQUPD' 'Error' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    i_packing_list-doc_type   =  c_csv.
    i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
    i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
    i_packing_list-doc_size   =  i_packing_list-body_num * 255.
    APPEND i_packing_list.
  ENDIF.
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
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization .
*--*Refresh and clear all global variables
  REFRESH : i_excel_file,i_txt_file,i_alv_disp_file,i_alv_disp_screen,
            i_fcat_out,i_vbak,i_vbkd,i_message,i_attach_success,i_attach_error,i_packing_list,
            i_receivers,i_attachment,i_alv_disp_file_m.

  CLEAR :   st_excel_file,st_alv_disp_file,st_alv_disp_screen,st_fcat_out,
            st_layout,st_txt_file,st_vbak,st_vbkd, st_imessage, gv_lines,
            g_path_fname.
ENDFORM.
