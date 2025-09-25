*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MEDIA_SUSPEN_SAVE_I0229
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTCN_MEDIA_SUSPEN_SAVE_I0229
* PROGRAM DESCRIPTION:  Based on the Changes to table JKSEINTERRUPT update
*               SLG1 Logs. Since Variables are not available, capture details
*               in internal tables in pgm ZQTCN_MEDIA_SUSPEN_SPRE_I0229
*               and use them to update SLG1 logs
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* CREATION DATE: 09/30/2021
* OBJECT ID:     I0229
* TRANSPORT NUMBER(S): ED2K924568
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

CONSTANTS: lc_object_01   TYPE balobj_d    VALUE 'ZQTC',   " Application Log: Object Name (Application Code)
           lc_subobj_01   TYPE balsubobj   VALUE 'ZORD_CHG_ALM',
           lc_exp_days_01 TYPE numc3       VALUE '090',      " Expiry days
           lc_symsgv_03   TYPE symsgv      VALUE 'Order/Item JKSEINTERRUPT',
           lc_symsgv_04   TYPE symsgv      VALUE 'Change Log for ALM',
           lc_i0229       TYPE char5       VALUE 'I0229',
           lc_log_days    TYPE char8       VALUE 'LOG_DAYS'.
CONSTANTS: lc_msg_type    TYPE char1       VALUE 'I',
           lc_msg_id      TYPE char8       VALUE 'ZRTR_R1B',
           lc_msg_no      TYPE numc3       VALUE '000'.

DATA: lst_xvbap     TYPE vbapvb.
DATA: lst_bal_msg   TYPE bal_s_msg,  " Application Log: Message Data Structure
      li_bal_msg    TYPE bal_t_msg.  " Application Log: Message Data Table
DATA: lv_1st_var    TYPE char50.     " First Document
DATA: lv_exp_date   TYPE sy-datum.
DATA: lst_log       TYPE bal_s_log.  " Application Log: Log header data
DATA: li_log_handle TYPE bal_t_logh, " Application Log: Log Handle Table
      lv_log_handle TYPE balloghndl. " Application Log: Log Handle
DATA  lv_log_exp_days_c  TYPE zcaconstant-low.
STATICS: lv_log_exp_days TYPE numc3. " Application Log: Retenetion Days

* Populate SLG1 Logs
* If JKSEINTERRUPT table is changed update SLG1 logs for the changed line item(s).
IF i_insert_tab[] IS NOT INITIAL OR
   i_update_tab[] IS NOT INITIAL OR
   i_delete_tab[] IS NOT INITIAL.
* Get Log Retention Period
  IF lv_log_exp_days IS INITIAL.
    SELECT SINGLE low
      INTO lv_log_exp_days_c
      FROM zcaconstant
      WHERE devid  = lc_i0229
        AND param1 = lc_log_days
        AND activate = abap_true.
    IF sy-subrc IS INITIAL.
      MOVE lv_log_exp_days_c TO lv_log_exp_days.
    ELSE.
      lv_log_exp_days = lc_exp_days_01.
    ENDIF.
  ENDIF.

  lv_1st_var = vbak-vbeln.
  CONDENSE: lv_1st_var.
  CONCATENATE lv_1st_var
              sy-datum
              sy-uzeit
         INTO lst_log-extnumber
         SEPARATED BY '/'.

  lst_log-object     = lc_object_01.
  lst_log-subobject  = lc_subobj_01.
  lst_log-aldate     = sy-datum.
  lst_log-altime     = sy-uzeit.
  lst_log-aluser     = sy-uname.
  lst_log-alprog     = sy-repid.
  lv_exp_date        = sy-datum + lv_log_exp_days.
  lst_log-aldate_del = lv_exp_date.
  lst_log-del_before = abap_true.

* Create the log with header data
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log
    IMPORTING
      e_log_handle            = lv_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        RAISE log_header_inconsistent.
      WHEN OTHERS.
        RAISE logging_error.
    ENDCASE.
  ENDIF.
  APPEND lv_log_handle TO li_log_handle.

*
  LOOP AT xvbap INTO lst_xvbap.
*   Check Insert
    READ TABLE i_insert_tab TRANSPORTING NO FIELDS WITH KEY vbeln = lst_xvbap-vbeln
                                                             posnr = lst_xvbap-posnr.
    IF sy-subrc IS INITIAL.
* Messages
      lst_bal_msg-msgty = lc_msg_type.
      lst_bal_msg-msgid = lc_msg_id.
      lst_bal_msg-msgno = lc_msg_no.
      lst_bal_msg-msgv1 = lst_xvbap-vbeln.
      IF lst_xvbap-vbeln IS INITIAL.
        lst_bal_msg-msgv1 = vbak-vbeln.
      ENDIF.
      lst_bal_msg-msgv2 = lst_xvbap-posnr.
      lst_bal_msg-msgv3 = lc_symsgv_03.
      lst_bal_msg-msgv4 = lc_symsgv_04.
      APPEND lst_bal_msg TO li_bal_msg.
      CLEAR: lst_bal_msg.
    ENDIF.
*   Check Update
    READ TABLE i_update_tab TRANSPORTING NO FIELDS WITH KEY vbeln = lst_xvbap-vbeln
                                                             posnr = lst_xvbap-posnr.
    IF sy-subrc IS INITIAL.
* Messages
      lst_bal_msg-msgty = lc_msg_type.
      lst_bal_msg-msgid = lc_msg_id.
      lst_bal_msg-msgno = lc_msg_no.
      lst_bal_msg-msgv1 = lst_xvbap-vbeln.
      IF lst_xvbap-vbeln IS INITIAL.
        lst_bal_msg-msgv1 = vbak-vbeln.
      ENDIF.
      lst_bal_msg-msgv2 = lst_xvbap-posnr.
      lst_bal_msg-msgv3 = lc_symsgv_03.
      lst_bal_msg-msgv4 = lc_symsgv_04.
      APPEND lst_bal_msg TO li_bal_msg.
      CLEAR: lst_bal_msg.
    ENDIF.
*   Check Delete
    READ TABLE i_delete_tab TRANSPORTING NO FIELDS WITH KEY vbeln = lst_xvbap-vbeln
                                                             posnr = lst_xvbap-posnr.
    IF sy-subrc IS INITIAL.
* Messages
      lst_bal_msg-msgty = lc_msg_type.
      lst_bal_msg-msgid = lc_msg_id.
      lst_bal_msg-msgno = lc_msg_no.
      lst_bal_msg-msgv1 = lst_xvbap-vbeln.
      IF lst_xvbap-vbeln IS INITIAL.
        lst_bal_msg-msgv1 = vbak-vbeln.
      ENDIF.
      lst_bal_msg-msgv2 = lst_xvbap-posnr.
      lst_bal_msg-msgv3 = lc_symsgv_03.
      lst_bal_msg-msgv4 = lc_symsgv_04.
      APPEND lst_bal_msg TO li_bal_msg.
      CLEAR: lst_bal_msg.
    ENDIF.

*   Log all relevant the Line Items Messages
    LOOP AT li_bal_msg INTO lst_bal_msg.
      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle  = lv_log_handle
          i_s_msg       = lst_bal_msg
        EXCEPTIONS
          log_not_found = 0
          OTHERS        = 1.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDLOOP.
    CLEAR: li_bal_msg[],
           lst_bal_msg.
*
  ENDLOOP.

* Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = li_log_handle " Application Log: Log Handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDIF.
