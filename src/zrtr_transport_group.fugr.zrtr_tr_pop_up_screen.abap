FUNCTION zrtr_tr_pop_up_screen.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TRKORR) TYPE  TRKORR
*"     VALUE(SUB_TASK) TYPE  TRKORR
*"  EXPORTING
*"     VALUE(MESSAGE) TYPE  BALLOGHNDL
*"     VALUE(DEPENDENCY_TR) TYPE  ZDEPENDENCY_TR
*"     VALUE(DEPENDENCY_CR) TYPE  ZDEPENDENCY_CR
*"     VALUE(CR_CHECK) TYPE  ZCR_CHECK
*"     VALUE(INCIDENT_CHECK) TYPE  ZINCIDENT_CHECK
*"     VALUE(INCIDENT_NO) TYPE  ZINCIDENT_NO
*"     VALUE(RETURN) TYPE  CHAR1
*"----------------------------------------------------------------------
  DATA: lst_task_rel TYPE zca_tr_log,
        lst_task_ibm TYPE /ibmaccel/ctslog,
        lv_message   TYPE string.
  DATA : lst_log         TYPE bal_s_log,          " Application Log: Log header data
         lst_log_numbers TYPE bal_s_lgnm,
         li_log_handle   TYPE bal_t_logh,         " Application Log: Log Handle Table
         lst_object      TYPE bal_s_obj,
         g_s_log_filter  TYPE bal_s_lfil,
         g_t_log_handle  TYPE bal_t_logh,
         li_log_numbers  TYPE bal_t_lgnm,
         lv_msg_handle   TYPE  balmsghndl,
         lv_txtmsg       TYPE text255.
  DATA: lv_length  TYPE i,
        lv_length1 TYPE i, " Length of type Integers
        lv_length2 TYPE i, " Length of type Integers
        lv_length3 TYPE i, " Length of type Integers
        lv_length4 TYPE i. " Length of type Integers
  DATA: lt_stream_lines  TYPE  string_table,
        lst_stream_lines TYPE string,
        lst_msg          TYPE bal_s_msg,   " Application Log: Message Data
        ls_note          TYPE txw_note,
        lv_flag_exit     TYPE xchar,     " Exit Flag
        lt_text2         TYPE STANDARD TABLE OF tline.
  CONSTANTS:lc_object TYPE balobj_d  VALUE 'ZCA',   " Application Log: Object Name (Application Code)
            lc_subobj TYPE balsubobj VALUE 'ZCA_TR'.

  FREE:message,
       dependency_tr,
       dependency_cr,
       cr_check,
       incident_check,
       incident_no,
       return,
       zca_tr_log,
       i_text,
       i_message,
       i_line_length,
       o_editor_container,
       o_text_editor.
  IF trkorr IS NOT INITIAL.
*----passing Main Task and Sub task number to Screen pop-up level
    zca_tr_log-zrequest = trkorr.
    e070-trkorr         = sub_task.
*---Validate the TR and SUB Tr is existing or not
    SELECT SINGLE *
      FROM zca_tr_log
      INTO  @DATA(lst_exist_tr)
      WHERE zrequest = @trkorr.
    IF sy-subrc NE 0.
      FREE:lst_exist_tr.
    ELSE.
      zca_tr_log-dependency_tr  = lst_exist_tr-dependency_tr.
      zca_tr_log-dependency_cr  = lst_exist_tr-dependency_cr.
      zca_tr_log-cr_check       = lst_exist_tr-cr_check.
      zca_tr_log-incident_check = lst_exist_tr-incident_check.
      zca_tr_log-incident_no    = lst_exist_tr-incident_no.
      zca_tr_log-retrofit_check = lst_exist_tr-retrofit_check.
      zca_tr_log-others_chk     = lst_exist_tr-others_chk.
      zca_tr_log-others_des     = lst_exist_tr-others_des.
      zca_tr_log-erpm_number    = lst_exist_tr-erpm_number.
      zca_tr_log-ricef_id       = lst_exist_tr-ricef_id.
      FREE:li_log_handle,v_log_handle.
      v_log_handle = lst_exist_tr-log_num.
      APPEND v_log_handle TO li_log_handle.

      CALL FUNCTION 'BAL_DB_LOAD'
        EXPORTING
          i_t_log_handle     = li_log_handle
        EXCEPTIONS
          no_logs_specified  = 1
          log_not_found      = 2
          log_already_loaded = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
      ENDIF.
      WHILE lv_flag_exit IS INITIAL.
        CLEAR:lst_msg.
        lv_msg_handle-log_handle = v_log_handle.
        lv_msg_handle-msgnumber  = lv_msg_handle-msgnumber + 1 .
        CALL FUNCTION 'BAL_LOG_MSG_READ'
          EXPORTING
            i_s_msg_handle = lv_msg_handle
          IMPORTING
            e_s_msg        = lst_msg
          EXCEPTIONS
            log_not_found  = 1
            msg_not_found  = 2
            OTHERS         = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
          lv_flag_exit = abap_true.
        ELSEIF sy-subrc = 0.
          CONCATENATE  i_message lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4
                      INTO i_message.
        ENDIF.
      ENDWHILE.
    ENDIF.
*--Calling MMP screen as a pop-up screen
    CALL SCREEN 100 STARTING AT 10 01
                    ENDING AT   100 25.
*---If the return code is zero than we are saving the data to custom tables
*---otherwise we are clearing the data and cancel the releasing process
    FREE:lst_stream_lines,lt_stream_lines.
    IF i_return = abap_true.
      lst_task_rel-zdate         = sy-datum.               "Creation date
      lst_task_rel-ztime         = sy-uzeit.               "Creation Time
      lst_task_rel-zuname        = sy-uname.               "User name
      lst_task_rel-zrequest      = trkorr.                 " Task Number (main)
      CLEAR lv_message.

*--Pass the Mutiple text lines to message variables(msgv1,msgv2,msgv3,msgv4).
*---Max length for the each line 72 char by default
*      IF i_message IS INITIAL AND i_text IS INITIAL.
*        MESSAGE 'Please maintain the free text and it is a mandatory field'(003) TYPE c_msg_typ_e DISPLAY LIKE c_msg_typ_i.
*      ENDIF.
      IF i_message IS NOT INITIAL AND i_text IS NOT INITIAL.
        FREE:lst_exist_tr-log_num, v_log_handle, v_lognumber,lst_exist_tr-zmessage.
      ENDIF.
      IF i_text IS NOT INITIAL.
        CLEAR:lst_stream_lines.
        lst_stream_lines = i_text.
        APPEND lst_stream_lines TO lt_stream_lines.
        CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
          EXPORTING
            stream_lines = lt_stream_lines
            language     = sy-langu
            lf           = 'X'
          TABLES
            itf_text     = lt_text2.

        LOOP AT lt_text2 INTO DATA(lst_txwnote).
          lv_message = lst_txwnote-tdline.
          lv_length = strlen( lv_message ).     " Check the length of the text
          IF lv_length LE 50.
            lv_length1 = lv_length.
          ELSEIF lv_length GT 50 AND lv_length LE 100.
            lv_length1 = 50.
            lv_length2 =  lv_length - 50.
          ELSEIF lv_length GT 100 AND lv_length LE 150.
            lv_length1 = 50.
            lv_length2 = 50.
            lv_length3 =  lv_length - 150.
          ELSEIF lv_length GT 150 AND lv_length LE 200.
            lv_length1 = 50.
            lv_length2 = 50.
            lv_length3 =  50.
            lv_length3 =  lv_length - 200.
          ENDIF.

          FREE:st_bal_msg,i_bal_msg.
          IF lv_length LE 50.
            st_bal_msg-msgv1 = lv_message+0(lv_length1).
          ELSEIF lv_length GT 50 AND lv_length LE 100.
            st_bal_msg-msgv1 = lv_message+0(lv_length1).
            st_bal_msg-msgv2 = lv_message+50(lv_length2).
          ELSEIF lv_length GT 100 AND lv_length LE 150.
            st_bal_msg-msgv1 = lv_message+0(lv_length1).
            st_bal_msg-msgv2 = lv_message+50(lv_length2).
            st_bal_msg-msgv3 = lv_message+100(lv_length3).
          ELSEIF lv_length GT 150 AND lv_length LE 200.
            st_bal_msg-msgv1 = lv_message+0(lv_length1).
            st_bal_msg-msgv2 = lv_message+50(lv_length2).
            st_bal_msg-msgv3 = lv_message+100(lv_length3).
            st_bal_msg-msgv4 = lv_message+150(lv_length4).
          ENDIF. " IF lv_length LE 50
          st_bal_msg-msgty  = c_msg_typ_i.
          st_bal_msg-msgid  = c_zqtc_r2.
          st_bal_msg-msgno  = c_msg_num_0.
          st_bal_msg-probclass = 2.
          APPEND st_bal_msg TO i_bal_msg.

          IF i_bal_msg[] IS NOT INITIAL.
            IF v_log_handle IS INITIAL AND lst_exist_tr-log_num IS INITIAL .
*---Below internal table create the log message in SLG1
              lst_log-object     = lc_object.      " Object name
              lst_log-extnumber  = trkorr.         " Extension Number(tr)
              lst_log-subobject  = lc_subobj.      "Sub Object Name
              lst_log-aldate     = sy-datum.       "Date
              lst_log-altime     = sy-uzeit.       "Time
              lst_log-aluser     = sy-uname.       "User
              lst_log-alprog     = sy-repid.       "Report
*---create the GUI ID based on the log details (Object, SUB-Object and extnumber)
              CALL FUNCTION 'BAL_LOG_CREATE'
                EXPORTING
                  i_s_log                 = lst_log
                IMPORTING
                  e_log_handle            = v_log_handle
                EXCEPTIONS
                  log_header_inconsistent = 1
                  OTHERS                  = 2.
              IF sy-subrc <> 0.
*              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF. " IF sy-subrc <> 0
            ELSE.
              FREE:li_log_handle.
              APPEND v_log_handle TO li_log_handle.
              CALL FUNCTION 'BAL_DB_LOAD'
                EXPORTING
                  i_t_log_handle     = li_log_handle
                EXCEPTIONS
                  no_logs_specified  = 1
                  log_not_found      = 2
                  log_already_loaded = 3
                  OTHERS             = 4.
            ENDIF.
            IF v_log_handle IS NOT INITIAL.
*---GUI ID cretaed the pass msgv1,msgv2,msgv3,msgv4 to below FM then it will create the text in APpl.log
              CALL FUNCTION 'BAL_LOG_MSG_ADD'
                EXPORTING
                  i_log_handle     = v_log_handle
                  i_s_msg          = st_bal_msg
                EXCEPTIONS
                  log_not_found    = 1
                  msg_inconsistent = 2
                  log_is_full      = 3
                  OTHERS           = 4.
              IF sy-subrc <> 0.
*---Above FM adding messages failed then passing the text to free text FM and this use for existing TR's
                CLEAR lv_txtmsg.
                CONCATENATE st_bal_msg-msgv1
                            st_bal_msg-msgv2
                            st_bal_msg-msgv3
                            st_bal_msg-msgv4
                            INTO lv_txtmsg.
                CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
                  EXPORTING
                    i_log_handle     = v_log_handle
                    i_msgty          = c_msg_typ_i
                    i_probclass      = ''
                    i_text           = lv_txtmsg
                  EXCEPTIONS
                    log_not_found    = 1
                    msg_inconsistent = 2
                    log_is_full      = 3
                    OTHERS           = 4.
              ENDIF.

* save logs in the database
              FREE:li_log_handle.
              APPEND v_log_handle TO li_log_handle.
*---Below FM store the data based on the GUI and generate the og Number.
              CALL FUNCTION 'BAL_DB_SAVE'
                EXPORTING
                  i_save_all       = abap_true
                  i_t_log_handle   = li_log_handle "Application Log: Log Handle
                IMPORTING
                  e_new_lognumbers = li_log_numbers
                EXCEPTIONS
                  log_not_found    = 1
                  save_not_allowed = 2
                  numbering_error  = 3
                  OTHERS           = 4.
              IF sy-subrc <> 0.
*              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
              IF li_log_numbers[] IS NOT INITIAL.
                v_lognumber = li_log_numbers[ 1 ]-lognumber.
                REFRESH li_log_numbers.
              ENDIF. " IF sy-subrc = 0
            ENDIF.
          ENDIF.
        ENDLOOP.
        IF sy-subrc = 0.
          COMMIT WORK.
        ENDIF.

        IF v_lognumber IS INITIAL.
          lst_task_rel-zmessage    =  lst_exist_tr-zmessage.
          v_lognumber              =  lst_exist_tr-zmessage.
        ELSE.
          lst_task_rel-zmessage    =  v_lognumber.
        ENDIF.
        "Mesage field
        IF  v_log_handle IS NOT INITIAL.
          lst_task_rel-log_num     =  v_log_handle.
        ELSE.
          lst_task_rel-log_num     =  lst_exist_tr-log_num.
        ENDIF.
        "Log Number
        message                  =  v_lognumber.     "Message field
        dependency_tr            =  zca_tr_log-dependency_tr.  " Dependence Transport
        lst_task_rel-dependency_tr =  zca_tr_log-dependency_tr.
*--Check the CR flag is active or not.
        IF zca_tr_log-cr_check = abap_true.
          lst_task_rel-dependency_cr =  zca_tr_log-dependency_cr.  "Dependence CR number
          dependency_cr              =  zca_tr_log-dependency_cr.
        ELSE.
          CLEAR:zca_tr_log-dependency_cr,lst_task_rel-dependency_cr,dependency_cr.
        ENDIF.
        lst_task_rel-cr_check      =  zca_tr_log-cr_check.        " CR check flag
        cr_check                   =  zca_tr_log-cr_check.
        lst_task_rel-incident_check = zca_tr_log-incident_check.   "Incident flag
        lst_task_rel-retrofit_check = zca_tr_log-retrofit_check.    " Retrofi flag
        incident_check              = zca_tr_log-incident_check.
*---Check the Incident flag is active or not
        IF zca_tr_log-incident_check = abap_true.
          lst_task_rel-incident_no    =  zca_tr_log-incident_no.    "Incident number
          incident_no                 =  zca_tr_log-incident_no.
        ELSE.
          CLEAR:lst_task_rel-incident_no,zca_tr_log-incident_no,incident_no.
        ENDIF.
*---check for others
        lst_task_rel-others_chk = zca_tr_log-others_chk.
        IF zca_tr_log-others_chk = abap_true.
          lst_task_rel-others_des    =  zca_tr_log-others_des.    "Others Descriptions
        ELSE.
          CLEAR:lst_task_rel-others_des,zca_tr_log-others_des.
        ENDIF.
        lst_task_rel-erpm_number = zca_tr_log-erpm_number.    " ERPM Number
        lst_task_rel-ricef_id    = zca_tr_log-ricef_id.    " ERPM Number
        return = i_return.                                             "return code
        MOVE-CORRESPONDING  lst_task_rel TO lst_task_ibm.
*---Lock the custom table and inserting the entries
        CALL FUNCTION 'ENQUEUE_/IBMACCEL/ECTSLG'
          EXPORTING
            mode_/ibmaccel/ctslog = 'E'
            mandt                 = sy-mandt
            zrequest              = trkorr
          EXCEPTIONS
            foreign_lock          = 1
            system_failure        = 2
            OTHERS                = 3.
        IF sy-subrc = 0.
*---Check that record already exist in custom table for task
          SELECT SINGLE zrequest
            FROM /ibmaccel/ctslog
            INTO @DATA(lst_request)
            WHERE zrequest = @trkorr.
          IF sy-subrc EQ 0 AND  lst_request IS NOT INITIAL.
*---Update the existing record
            UPDATE /ibmaccel/ctslog FROM lst_task_ibm.
          ELSE.
*---Insert record in custom table.
            INSERT /ibmaccel/ctslog FROM lst_task_ibm.
          ENDIF.
*---Release the custom table.
          CALL FUNCTION 'DEQUEUE_/IBMACCEL/ECTSLG'
            EXPORTING
              mode_/ibmaccel/ctslog = 'E'
              mandt                 = sy-mandt
              zrequest              = trkorr.
        ENDIF.
        CALL FUNCTION 'ENQUEUE_EZ_TRLOG'
          EXPORTING
            mode_zca_tr_log = 'E'
            zrequest        = trkorr
          EXCEPTIONS
            foreign_lock    = 1
            system_failure  = 2
            OTHERS          = 3.
        IF sy-subrc = 0.
*---Check that record already exist in custom table for task
          IF sy-subrc EQ 0 .
*---Update/Insert the records
            MODIFY zca_tr_log FROM lst_task_rel.
          ENDIF.
*---Release the custom table.
* Implement suitable error handling here
          CALL FUNCTION 'DEQUEUE_EZ_TRLOG'
            EXPORTING
              mode_zca_tr_log = 'E'
              zrequest        = trkorr.
        ENDIF.
      ENDIF.
*      ELSEIF i_message IS NOT INITIAL AND i_text IS INITIAL.
      return = i_return.
*        MESSAGE text-002 TYPE c_msg_typ_e DISPLAY LIKE c_msg_typ_i.
*        i_return = abap_false.
*      ENDIF.


*----if return code 4 then stop the relasing process
    ELSEIF i_return = abap_false.
      CLEAR:zca_tr_log,
            lst_task_rel,
            message,
            dependency_tr,
            dependency_cr,
            cr_check,
            incident_check,
            incident_no.
      return = i_return.
    ENDIF.
  ENDIF.
  FREE:lst_exist_tr.
ENDFUNCTION.
