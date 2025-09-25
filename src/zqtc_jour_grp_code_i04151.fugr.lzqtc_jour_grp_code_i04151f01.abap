*----------------------------------------------------------------------*
***INCLUDE LZQTC_JOUR_GRP_CODE_I04151F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  IDOC_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_IDOC_DOCNUM  text
*      -->P_C_53  text
*      -->P_C_S  text
*      -->P_0104   text
*      -->P_SY_UNAME  text
*      -->P_SY_REPID  text
*      <--P_IDOC_STATUS  text
*----------------------------------------------------------------------*
FORM idoc_status  USING    fp_docnum      TYPE edidd-docnum
                           fp_status_no   TYPE char2
                           fp_msg_type    TYPE char1
                           fp_msg_text    TYPE sy-msgv1
                           fp_uname       TYPE sy-uname
                           fp_repid       TYPE sy-repid
                  CHANGING fp_idoc_status TYPE t_idoc_status.

  DATA : ls_idoc_status TYPE bdidocstat,
         l_log_handle   TYPE balloghndl,
         l_timestamp    TYPE tzntstmps,
         l_str_log      TYPE bal_s_log,
         l_str_balmsg   TYPE bal_s_msg,
         l_msg_logged   TYPE boolean.

  DATA: lv_log_object    LIKE balhdr-object    VALUE 'ZQTC',
        lv_log_subobject LIKE balhdr-subobject VALUE 'V_TWEW'.  " SAPL0WC3

  " status info
  ls_idoc_status-docnum  = fp_docnum     .
  ls_idoc_status-status  = fp_status_no  .
  ls_idoc_status-msgty   = fp_msg_type   .
  ls_idoc_status-msgv1   = fp_msg_text   .
  ls_idoc_status-uname   = fp_uname      .
  ls_idoc_status-repid   = fp_repid      .
  APPEND ls_idoc_status TO fp_idoc_status[] .

  "application log info
  l_str_log-object = lv_log_object.
  l_str_log-subobject = lv_log_subobject.
  l_str_log-aldate_del = sy-datum + 5.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = l_str_log
    IMPORTING
      e_log_handle            = l_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
*        WRITE: ‘type’,sy-msgty, ‘message’,l_str_message-message.
  ELSE.
    MOVE-CORRESPONDING ls_idoc_status TO l_str_balmsg.
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = l_log_handle
        i_s_msg          = l_str_balmsg
      IMPORTING
        e_msg_was_logged = l_msg_logged
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
    ELSE.
      CALL FUNCTION 'BAL_DB_SAVE'
        EXPORTING
          i_save_all       = abap_true
        EXCEPTIONS
          log_not_found    = 1
          save_not_allowed = 2
          numbering_error  = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO l_str_message-message.
      ELSE.
      ENDIF.
    ENDIF.
  ENDIF.

  CLEAR: ls_idoc_status.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LOCK_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_TABNAME  text
*      -->P_C_E  text
*----------------------------------------------------------------------*
FORM lock_table  USING    fp_tabname  TYPE tabname
                          fp_e
                CHANGING  fp_status   TYPE sy-msgv1.
*  * Lock table
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      mode_rstable   = fp_e "Lock Mode - Write Lock
      tabname        = fp_tabname   "Table Name
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc NE 0.
    fp_status = text-t04.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UNLOCK_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_TABNAME  text
*      -->P_C_E  text
*----------------------------------------------------------------------*
FORM unlock_table  USING    fp_tabname TYPE tabname
                            fp_e.
*    Unlock table
  CALL FUNCTION 'DEQUEUE_E_TABLE'
    EXPORTING
      mode_rstable = fp_e                       "Lock Mode - Write Lock
      tabname      = fp_tabname.                         "Table Name
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  IDOC_DATA_OB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_TWEW_EXTWG  text
*      -->P_LST_TWEWT_EWBEZ  text
*      -->P_C_S  text
*      -->P_TEXT_T06  text
*      <--P_LT_IDOC_DATA_OUT[]  text
*----------------------------------------------------------------------*
FORM idoc_data_ob  USING    fp_extwg TYPE  extwg
                            fp_ewbez TYPE  ewbez
                            fp_msg_type TYPE sy-msgty
                            fp_msg_text TYPE sy-msgv1
                            fp_idoc_in  TYPE edidd
                   CHANGING fp_lst_seg_info_ob TYPE ze1dd03l
                            fp_lt_idoc_data_out TYPE idoc_data.

  DATA :
        lst_idoc_data_out TYPE edidd.
  CONSTANTS :
        c_seg_name_ob TYPE edilsegtyp   VALUE 'ZE1DD03L' ,
        c_hlevel_ob   TYPE hlevel       VALUE '02'.

  fp_lst_seg_info_ob-ext_mat_grp = fp_extwg .
  fp_lst_seg_info_ob-ext_mat_grp_txt = fp_ewbez .
  fp_lst_seg_info_ob-ext_msg_type = fp_msg_type .
  fp_lst_seg_info_ob-ext_msg_status = fp_msg_text .

  lst_idoc_data_out-segnum = fp_idoc_in-segnum.
  lst_idoc_data_out-segnam = c_seg_name_ob .
  lst_idoc_data_out-hlevel = c_hlevel_ob . "'02'.
  lst_idoc_data_out-sdata =  fp_lst_seg_info_ob.
  APPEND lst_idoc_data_out TO fp_lt_idoc_data_out[].

ENDFORM.
