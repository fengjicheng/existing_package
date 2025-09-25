*&---------------------------------------------------------------------*
*&  Include  ZQTC_SALES_ORD_CHG_NEW_FLD_SUB
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA_FROM_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_data_from_excel.                            "##CALLED.
  DATA : i_raw_data  TYPE                   truxs_t_text_data,
         lv_filename TYPE string.
*Get input data into internal table
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = c_x
      i_tab_raw_data       = i_raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = i_excel_file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc NE 0.
    MESSAGE text-121 TYPE c_i.
    LEAVE LIST-PROCESSING.
  ENDIF.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-020.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PLACE_FILE_IN_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_place_file_in_app.
* Local data declarations
  DATA: lv_ftfront         TYPE rcgfiletr-ftfront,
        lv_ftappl          TYPE rcgfiletr-ftappl, "string, "sapb-sappfad, " rcgfiletr-ftappl,
        lv_flg_overwrite   LIKE rcgfiletr-iefow,
        lv_ftftype         LIKE rcgfiletr-ftftype,
        lv_flg_continue    TYPE boolean,
        lv_flg_open_error  TYPE boolean,
        lv_os_message(100) TYPE c,
        lv_text1(40)       TYPE c,
        lv_text2(40)       TYPE c,
        lv_data            TYPE string,
        lv_flag            TYPE char1,                                          " Flag of type CHAR1
        lv_tab             TYPE c VALUE cl_abap_char_utilities=>horizontal_tab, " Tab of type Character
        lv_path            TYPE filepath-pathintern VALUE 'Z_ORD_UPDATE_WITH_NEW_IN',
        lv_filename        TYPE string.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-003.

  CONCATENATE c_ord_upd_new sy-uname sy-datum sy-uzeit INTO lv_filename SEPARATED BY c_underscore.
  CONCATENATE lv_filename c_extn INTO lv_filename.
  PERFORM f_get_file_path USING lv_path lv_filename.
  g_path_fname =  v_path_fname."lv_filename.
  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
  LOOP AT i_excel_file INTO st_excel_file.
    CONCATENATE st_excel_file-ind st_excel_file-so st_excel_file-item st_excel_file-lyear
                st_excel_file-dtype st_excel_file-ctype
           INTO lv_data
      SEPARATED BY lv_tab.
    TRANSFER lv_data TO v_path_fname.
    CLEAR lv_data.
  ENDLOOP.
  CLOSE DATASET v_path_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BATCH_JOB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM batch_job.
* Local data declarations
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status

* Local constant declaration
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'ORD_UPD_NEW_FLD'. " Background job name

  CONCATENATE lc_job_name c_underscore sy-datum c_underscore
                sy-uzeit
              INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-004.
** Check if pre. Job name and job count is present
** then set the check pre. status to X else blank.

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
    p_job = lv_job_name.
    SUBMIT zqtc_sales_ord_chg_new_fld_bth
                               WITH p_file = g_path_fname
                               WITH p_mail IN  p_mail
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
      MESSAGE e000(zrtr_r1b) WITH text-022. " & & & &
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_UPDATE_WITH_NEW_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bapi_update_with_new_value USING    fp_user
                                           fp_job
                                  CHANGING fp_i_excel_file TYPE tt_excel_file
                                           fp_mail TYPE tt_mail.
  DATA: lv_document    TYPE bapivbeln-vbeln,
        ltab_return    TYPE TABLE OF bapiret2,
        i_bapi_ext     TYPE STANDARD TABLE OF bapiparex, "Itab to hold BAPI extension
        i_bapi_ext_x   TYPE STANDARD TABLE OF bapiparex, "Itab to hold BAPI extension
        st_bapi_ext    TYPE bapiparex,      "structure to hold BAPI extension
        lst_tmp_excel  LIKE LINE OF i_excel_file,
        lst_bapisdhd1  TYPE bapisdhd1,
        lst_bapisdhd1x TYPE bapisdhd1x,
        li_bapisditm   TYPE STANDARD TABLE OF bapisditm,
        lst_bapisditm  TYPE bapisditm,
        li_bapisditmx  TYPE STANDARD TABLE OF bapisditmx,
        lst_bapisditmx TYPE bapisditmx,
        st_return      TYPE bapiret2,      "structure to hold return
        lst_bape_vbak  TYPE bape_vbak,  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbap  TYPE bape_vbap,  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbapx TYPE bape_vbapx, " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbakx TYPE bape_vbakx, " BAPI Interface for Customer Enhancements to Tab
        li_item        TYPE STANDARD TABLE OF bapisditm,
        li_itemx       TYPE STANDARD TABLE OF bapisditmx,
        lst_item       TYPE bapisditm,
        lst_itemx      TYPE bapisditmx,
        lv_path_err    TYPE filepath-pathintern VALUE 'Z_ORD_UPDATE_WITH_NEW_ERR',
        lv_path_prc    TYPE filepath-pathintern VALUE 'Z_ORD_UPDATE_WITH_NEW_PRC',
        lv_data        TYPE string,
        lv_tab         TYPE c VALUE cl_abap_char_utilities=>horizontal_tab. " Tab of type Character

  CONSTANTS: lc_bape_vbak  TYPE char9  VALUE 'BAPE_VBAK',  " Bape_vbak of type CHAR9
             lc_bape_vbap  TYPE char9  VALUE 'BAPE_VBAP',  " Bape_vbak of type CHAR9
             lc_posnr      TYPE posnr  VALUE '000000',     " Item number of the SD document
             lc_bape_vbakx TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
             lc_bape_vbapx TYPE char10 VALUE 'BAPE_VBAPX'. " Bape_vbak of type CHAR9

  i_mail[]         = fp_mail[].
  g_job            = fp_job.
  g_user           = fp_user.
  i_excel_file[]   = fp_i_excel_file[].
  i_excel_file_t[] = i_excel_file[].
  SORT i_excel_file_t BY so.
  DELETE ADJACENT DUPLICATES FROM i_excel_file_t COMPARING so.
  SORT i_excel_file BY so item.
  IF i_excel_file[] IS NOT INITIAL.
    SELECT vbeln, posnr, matnr FROM vbap
                               INTO TABLE @i_vbap
                               FOR ALL ENTRIES IN @i_excel_file
                               WHERE vbeln = @i_excel_file-so AND
                                     posnr = @i_excel_file-item.
  ENDIF.
  SORT i_vbap BY vbeln posnr.
  LOOP AT i_excel_file_t INTO lst_tmp_excel.
*--*Pass Additional data B(custom fields_ to BAPI
    LOOP AT i_excel_file INTO st_excel_file WHERE so = lst_tmp_excel-so.
      IF st_excel_file-ind = c_h.
        st_alv_disp-ind    = c_h.
        st_alv_disp-so     = st_excel_file-so.
        st_alv_disp-lyear  = st_excel_file-lyear.
        APPEND st_alv_disp TO i_alv_disp.
        CLEAR st_alv_disp.

        lv_document = st_excel_file-so.
        lst_bape_vbak-vbeln      = st_excel_file-so.              " Sales Document
        lst_bape_vbak-zzlicyr    = st_excel_file-lyear.         " Licence Year
        st_bapi_ext-structure    = lc_bape_vbak.                " BAPE_VBAP structure where custom fields are added
        st_bapi_ext-valuepart1   = lst_bape_vbak.
        APPEND st_bapi_ext TO i_bapi_ext.
        CLEAR: st_bapi_ext, lst_bape_vbak.

        lst_bape_vbakx-vbeln   = ' '.
        lst_bape_vbakx-zzlicyr = c_x.                       " Deal type
        st_bapi_ext-structure  = lc_bape_vbakx.              " BAPE_VBAPX structure where custom fields are added
        st_bapi_ext-valuepart1 = lst_bape_vbakx.
        APPEND st_bapi_ext TO i_bapi_ext.
        CLEAR: st_bapi_ext, lst_bape_vbakx.
      ELSEIF st_excel_file-ind = c_i.
        lv_document = st_excel_file-so.
        st_alv_disp-ind   = c_i.
        st_alv_disp-so    = st_excel_file-so.
        st_alv_disp-item  = st_excel_file-item.
        st_alv_disp-dtype = st_excel_file-dtype.
        st_alv_disp-ctype = st_excel_file-ctype.
        APPEND st_alv_disp TO i_alv_disp.
        CLEAR st_alv_disp.

        lst_bape_vbap-vbeln      = st_excel_file-so.
        lst_bape_vbap-posnr      = st_excel_file-item.             " Item number
        lst_bape_vbap-zzdealtyp  = st_excel_file-dtype.        " Deal Type
        lst_bape_vbap-zzclustyp  = st_excel_file-ctype.        " Cluster Type
        st_bapi_ext-structure    = lc_bape_vbap.                 " BAPE_VBAP structure where custom fields are added
        st_bapi_ext-valuepart1   = lst_bape_vbap.
        APPEND st_bapi_ext TO i_bapi_ext.
        CLEAR: st_bapi_ext, lst_bape_vbap.

        lst_bape_vbapx-posnr     = st_excel_file-item.            " Update flag for  Item
        lst_bape_vbapx-zzdealtyp = c_x.                       " Deal type
        lst_bape_vbapx-zzclustyp = c_x.                       " Cluster type
        st_bapi_ext-structure    = lc_bape_vbapx.                " BAPE_VBAPX structure where custom fields are added
        st_bapi_ext-valuepart1   = lst_bape_vbapx.
        APPEND st_bapi_ext TO i_bapi_ext.
        CLEAR: st_bapi_ext, st_vbap, lst_bape_vbapx.
        READ TABLE i_vbap INTO st_vbap WITH KEY vbeln = st_excel_file-so
                                                posnr = st_excel_file-item
                                                BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_item-material = st_vbap-matnr.
        ENDIF.
        lst_item-itm_number = st_excel_file-item.
        APPEND lst_item TO li_item.
        CLEAR lst_item.

        lst_itemx-itm_number = st_excel_file-item.
        lst_itemx-updateflag =  c_u.
        APPEND lst_itemx TO li_itemx.
        CLEAR lst_itemx.
      ENDIF.
    ENDLOOP.

    lst_bapisdhd1x-updateflag = c_u.
    CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
      EXPORTING
        salesdocument     = lv_document
        order_header_in   = lst_bapisdhd1
        order_header_inx  = lst_bapisdhd1x
        business_object   = c_bus2034
      TABLES
        return            = ltab_return
        item_in           = li_item
        item_inx          = li_itemx
        extensionin       = i_bapi_ext
*       extensionex       = i_bapi_ext_x
      EXCEPTIONS
        incov_not_in_item = 1
        OTHERS            = 2.
*----------------------------------------------------------------------*
* Build Log
*----------------------------------------------------------------------*
*--*Read the error message if any
    READ TABLE ltab_return INTO st_return WITH KEY type = c_e.
    IF sy-subrc NE 0.
*--*Read Abort message if any
      READ TABLE ltab_return INTO st_return WITH KEY type = c_a.
    ENDIF.
    IF sy-subrc EQ 0.
*--*If BAPI returns error or abort Rollback Transaction
*--* And build the Idoc status record with status 51
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      st_alv_disp-status = text-005.
      st_alv_disp-status_message = st_return-message.
      MODIFY i_alv_disp FROM st_alv_disp TRANSPORTING status status_message WHERE so = lv_document.
*      APPEND st_alv_disp TO i_alv_disp.
      CLEAR st_alv_disp.
    ELSE.
*--*If BAPI return no error then commit the transaction
*--* and build the Idoc status record with status 53.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = c_x.
      READ TABLE ltab_return INTO st_return WITH KEY type = c_s.
      IF sy-subrc EQ 0.
        st_alv_disp-status = text-006.
        st_alv_disp-status_message = text-007."st_return-message.
        MODIFY i_alv_disp FROM st_alv_disp TRANSPORTING status status_message WHERE so = lv_document.
        CLEAR st_alv_disp..
      ENDIF.
    ENDIF.
    CLEAR: lv_document, lst_bapisdhd1, lst_bapisdhd1x,
           ltab_return[], li_item[], li_itemx[], i_bapi_ext[].
  ENDLOOP.
  IF sy-batch = c_x.
    IF i_alv_disp[] IS NOT INITIAL.
      PERFORM f_disp_alv.
      PERFORM f_send_log_email.
*--*Send file to AL11
      CLEAR:  lv_filename,v_path_fname.
      CONCATENATE c_ord_upd_new sy-uname sy-datum sy-uzeit INTO lv_filename SEPARATED BY c_underscore.
      CONCATENATE lv_filename c_extn INTO lv_filename.
*&---------------------------------------------------------------------*
*  Below subroutines is used to place the log file in Application server
*  Error file goes to error path and succes file goes to processed path
*----------------------------------------------------------------------*
      READ TABLE i_alv_disp INTO st_alv_disp WITH KEY status = text-005.
      IF sy-subrc EQ 0.
        PERFORM f_get_file_path USING lv_path_err lv_filename.
      ELSE.
        PERFORM f_get_file_path USING lv_path_prc lv_filename.
      ENDIF.
      OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
      IF sy-subrc NE 0.
        MESSAGE s100 DISPLAY LIKE c_e.
        LEAVE LIST-PROCESSING.
      ENDIF.
      CLEAR st_alv_disp.
      LOOP AT i_alv_disp INTO st_alv_disp.
        CONCATENATE   st_alv_disp-ind
                      st_alv_disp-so
                      st_alv_disp-lyear
                      st_alv_disp-dtype
                      st_alv_disp-ctype
                      st_alv_disp-status
                      st_alv_disp-status_message
                    INTO lv_data
          SEPARATED BY con_tab.
        TRANSFER lv_data TO v_path_fname.
        CLEAR: lv_data.
      ENDLOOP.
      CLOSE DATASET v_path_fname.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING p_p_file.
* Popup for file path
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_file " File Path
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
*&      Form  F_DISP_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_disp_alv .
  PERFORM f_build_fcat.
  st_layout-colwidth_optimize = c_x.
  st_layout-zebra = c_x.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      is_layout                = st_layout
      it_fieldcat              = i_fcat_out
    TABLES
      t_outtab                 = i_alv_disp
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
*    MESSAGE e000 WITH text-036.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.                ##CALLED.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
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
            lv_counter 'IND'                text-008,
            lv_counter 'SO'                 text-009,
            lv_counter 'ITEM'               text-001,
            lv_counter 'LYEAR'              text-011,
            lv_counter 'DTYPE'              text-012,
            lv_counter 'CTYPE'              text-013,
            lv_counter 'STATUS'             text-014,
            lv_counter 'STATUS_MESSAGE'     text-015   .
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
  CONSTANTS: lc_tabname       TYPE tabname   VALUE 'I_OUTPUT_X'. " Table Name
  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.
  IF fp_fld = 'SO'.
    st_fcat_out-no_zero      = abap_true.
  ENDIF.
  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

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
  lst_fcat-fieldname   = 'JOB'.
  lst_fcat-tabname     = 'LI_TAB'.
  lst_fcat-seltext_m   = text-016."text-070.
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'USER'.
  lst_fcat-tabname     = 'LI_TAB'.
  lst_fcat-seltext_m   = text-017."text-071.
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'DATE'.
  lst_fcat-tabname     = 'LI_TAB'.
  lst_fcat-seltext_m   = text-018."text-072.
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'TIME'.
  lst_fcat-tabname     = 'LI_TAB'.
  lst_fcat-seltext_m   = text-019."text-073.
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_tab-job  = fp_lv_job_name.
  lst_tab-user = sy-uname.
  lst_tab-date = sy-datum.
  lst_tab-time = sy-uzeit.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      it_fieldcat              = li_fcat
      is_layout                = lst_layout
    TABLES
      t_outtab                 = li_tab
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  REFRESH : li_fcat,li_tab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING    fp_lv_path               ##CALLED
                               fp_lv_filename.
  CLEAR : v_path_fname.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_lv_path
      operating_system           = sy-opsys
      file_name                  = fp_lv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
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
  PERFORM build_xls_log_data .

*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage = text-030."Dear Wiley Customer,Please find Attachmen
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Populate message body text
  CONCATENATE 'JOB NAME:' g_job INTO st_imessage SEPARATED BY space.
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
  PERFORM send_xls_log_to_mail.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_XLS_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_xls_log_data .
  REFRESH i_attach.
  CONCATENATE text-008 text-009 text-010  text-011
              text-012 text-013 text-014 text-015
      INTO i_attach SEPARATED BY con_tab.

  CONCATENATE con_cret i_attach INTO i_attach.
  APPEND  i_attach.

  LOOP AT i_alv_disp INTO st_alv_disp.
    CONCATENATE  st_alv_disp-ind        st_alv_disp-so
                 st_alv_disp-item    st_alv_disp-lyear
                 st_alv_disp-dtype         st_alv_disp-ctype
                 st_alv_disp-status   st_alv_disp-status_message
             INTO i_attach SEPARATED BY con_tab.
    CONCATENATE con_cret i_attach  INTO i_attach.
    APPEND  i_attach.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_XLS_LOG_TO_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_xls_log_to_mail .
  DATA: lst_xdocdata LIKE sodocchgi1,
        lv_xcnt      TYPE i,
        lv_file_name TYPE char100,
        lst_usr21    TYPE usr21,
        lst_adr6     TYPE adr6,
        lv_p_mail    LIKE LINE OF p_mail.

*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = c_saprpt."text-106.
  lst_xdocdata-obj_descr = g_job."g_job_name."text-032. "Sales Order Update with MQ no Log

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach INDEX lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( i_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt."text-106.
  lst_xdocdata-obj_descr  = g_job."g_job_name."text-032."Sales Order Update with MQ no Log
  CLEAR i_attachment.  REFRESH i_attachment.
  i_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type   = c_raw."c_raw.
  APPEND i_packing_list.

*- Create attachment notification
  i_packing_list-transf_bin = c_x.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 1.
  i_packing_list-body_start = 1.

  DESCRIBE TABLE i_attachment LINES i_packing_list-body_num.
  CLEAR lv_file_name .
  CONCATENATE 'ZORD_UPD_NEW_FIELDS' sy-uname sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
  CONCATENATE lv_file_name 'XLS' INTO lv_file_name.
  i_packing_list-doc_type   =  'XLS'.
  i_packing_list-obj_descr  =  lv_file_name."p_attdescription.
  i_packing_list-obj_name   =  lv_file_name."'CMR'."p_filename.
  i_packing_list-doc_size   =  i_packing_list-body_num * 255.
  APPEND i_packing_list.


  IF i_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT i_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver   = lv_p_mail-low.
      i_receivers-rec_type   = c_u.
      i_receivers-com_type   = c_int."c_int.
      i_receivers-notif_del  = c_x.
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
    i_receivers-receiver   = lst_adr6-smtp_addr.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int."c_int.
    i_receivers-notif_del  = c_x.
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
*&      Form  F_DYNAMIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic .
*  Display mode only for filepath
  LOOP AT SCREEN.
    IF screen-name = c_file. "'P_A_FILE'.
      screen-input = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  CONCATENATE c_inf sy-sysid c_c102 INTO p_a_file.
  .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialization.
  REFRESH:i_excel_file,i_excel_file_t,i_txt_file,i_alv_disp,i_fcat_out,
          i_vbap,i_mail,i_message,i_attach,i_packing_list,i_receivers,
          i_attachment.
  CLEAR  :st_excel_file,st_alv_disp,st_fcat_out,st_layout,st_txt_file,
          st_bapi_header,st_vbap,st_imessage,gv_lines,g_path_fname,
          v_path_fname,lv_filename,g_user,g_job.
ENDFORM.
