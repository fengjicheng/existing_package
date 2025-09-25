*----------------------------------------------------------------------*
***INCLUDE LZQTC_UPDATE_EXTERNAL_ID_BPF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_create_log USING fp_v_partner
                  CHANGING  fp_v_log_handdle.

  DATA : li_log  TYPE bal_s_log, " Application Log: Log header data
         lv_date TYPE aldate_del,
         lv_days TYPE salv_de_selopt_low.


  CONSTANTS : c_devid   TYPE zdevid      VALUE 'I0200',
              c_expiry  TYPE rvari_vnam  VALUE 'EXPIRY_DATE',
              c_appl    TYPE expiry_date VALUE 'APPL_LOG',
              c_bal_obj TYPE balobj_d    VALUE 'ZQTC',     "Application Log: Object Name
              c_bal_sub TYPE balsubobj   VALUE 'ZBP_CUST'. "Application Log: Subobject
* Get Expiry date
  SELECT SINGLE low
           INTO lv_days
           FROM zcaconstant
          WHERE devid = c_devid
            AND param1 = c_expiry
            AND param2 = c_appl.
  IF sy-subrc EQ 0.
    lv_date = sy-datum + lv_days.
  ENDIF.

* define some header data of this log
  CONCATENATE 'ZQTC_EXT_IDENT' fp_v_partner
         INTO li_log-extnumber
         SEPARATED BY '_'.

  li_log-object     = c_bal_obj.
  li_log-subobject  = c_bal_sub.
  li_log-aldate     = sy-datum.
  li_log-altime     = sy-uzeit.
  li_log-aluser     = sy-uname.
  li_log-alprog     = sy-repid.
  li_log-aldate_del = lv_date.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = li_log
    IMPORTING
      e_log_handle            = fp_v_log_handdle
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
FORM f_log_maintain  USING fp_lv_msgtyp TYPE bapi_mtype
                           fp_lv_fval TYPE char200
                           fp_gv_log_handle TYPE balloghndl.

  DATA : lv_msg       TYPE bal_s_msg, " Application Log: Message Data
         lv_fval      TYPE int4,      " Natural Number
         lv_mesg(200) TYPE c,
         lv_chars     TYPE i,
         lv_index     TYPE i,
         lv_cnt       TYPE i.

  lv_msg-msgty     = fp_lv_msgtyp.
  lv_msg-msgid     = 'ZQTC_R2'.
  lv_msg-msgno     = '000'.

  lv_fval = strlen( fp_lv_fval ).

  IF lv_fval LE 50.
    lv_msg-msgv1 = fp_lv_fval.
  ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
  ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
    lv_msg-msgv3 = fp_lv_fval+100(50).
  ELSE. " ELSE -> IF lv_fval LE 50
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
    lv_msg-msgv3 = fp_lv_fval+100(50).
    lv_msg-msgv4 = fp_lv_fval+150(50).

  ENDIF. " IF lv_fval LE 50


  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = fp_gv_log_handle
      i_s_msg          = lv_msg
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
*      -->P_GV_LOG_HANDLE  text
*----------------------------------------------------------------------*
FORM f_log_save  USING fp_gv_log_handle TYPE balloghndl.

  DATA li_log_handle TYPE bal_t_logh. "Application Log: Log Handle Table

  CLEAR li_log_handle.

  APPEND fp_gv_log_handle TO li_log_handle.
  CLEAR  fp_gv_log_handle.

*Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = li_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_TITLE  text
*      -->P_LV_VALUE  text
*      -->P_GV_LOG_HANDLE  text
*----------------------------------------------------------------------*
FORM update_message  USING    fp_lv_msgtyp TYPE bapi_mtype
                              fp_lv_title  TYPE zqtc_ext_id_no
                              fp_lv_value  TYPE zqtc_ext_id_no
                              fp_gv_log_handle TYPE balloghndl.

  DATA lv_fval(200) TYPE c.

  CONCATENATE fp_lv_title fp_lv_value
         INTO lv_fval SEPARATED BY space.

  PERFORM f_log_maintain  USING fp_lv_msgtyp
                                lv_fval
                                fp_gv_log_handle.

ENDFORM.
