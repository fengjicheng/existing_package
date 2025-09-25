*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_UPD_ACCEPT_DATF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_log.
  DATA : lst_log  TYPE bal_s_log, " Application Log: Log header data
         lv_date  TYPE aldate_del.
  CONSTANTS:lc_s  TYPE char1 VALUE '/'.

  v_days = '90'.
  lv_date = sy-datum + v_days.

* define some header data of this log
  lst_log-extnumber  = sy-datum.
  lst_log-object     = c_object.
  lst_log-subobject  = c_subobj.
  lst_log-aldate     = sy-datum.
  lst_log-altime     = sy-uzeit.
  lst_log-aluser     = sy-uname.
  lst_log-alprog     = sy-repid.
  lst_log-aldate_del = lv_date.
  lst_log-extnumber  = v_exter.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log
    IMPORTING
      e_log_handle            = v_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MAINTAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_FVAL  text
*----------------------------------------------------------------------*
FORM f_log_maintain  USING fp_lv_fval TYPE char200
                           fp_lv_magty TYPE symsgty.
  DATA : lst_msg       TYPE bal_s_msg, " Application Log: Message Data
         lv_fval      TYPE int4.

  lst_msg-msgty     = fp_lv_magty."'I'.
  lst_msg-msgid     = 'ZQTC_R2'.
  lst_msg-msgno     = '000'.

  lv_fval = strlen( fp_lv_fval ).

  IF lv_fval LE 50.
    lst_msg-msgv1 = fp_lv_fval.
  ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
  ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
    lst_msg-msgv3 = fp_lv_fval+100(50).
  ELSE. " ELSE -> IF lv_fval LE 50
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
    lst_msg-msgv3 = fp_lv_fval+100(50).
    lst_msg-msgv4 = fp_lv_fval+150(50).

  ENDIF. " IF lv_fval LE 50
  lst_msg-msgv4 = v_msgno.
  CLEAR v_msgno.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = v_log_handle
      i_s_msg          = lst_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_save .

*Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'    ##FM_SUBRC_OK
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
