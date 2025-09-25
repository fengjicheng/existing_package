*----------------------------------------------------------------------*
***INCLUDE LZSCM_JKSD13O01.
*----------------------------------------------------------------------*
*"----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 21-AUG-2020
* DESCRIPTION: SLG Logs Maintenance for User Comments in LITHO Report
*----------------------------------------------------------------------*
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K921719
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 11-FEB-2021
* DESCRIPTION: Aditional fields for Digital/Litho
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.

  SET PF-STATUS 'GUI_9001'.
  SET TITLEBAR 'TITLE_9001'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.


  CASE ok_code.

    WHEN 'CX_SAVE'.
      PERFORM f_maintain_log USING gv_matnr gv_plant.
      LEAVE TO SCREEN 0.

    WHEN 'CX_CANC'.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      LEAVE TO SCREEN 0.

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_MAINTAIN_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  gv_matnr  text
*  -->  gv_plant  text
*----------------------------------------------------------------------*
FORM f_maintain_log USING fp_matnr fp_plant.

  " Local Data
  DATA: lst_log         TYPE bal_s_log,    " Application Log: Log header data
        lv_log_handle   TYPE balloghndl,   " Application Log: Log Handle
        li_log_handle   TYPE bal_t_logh,   " Application Log: Log Handle Table
        li_log_numbers  TYPE bal_t_lgnm,
        lv_msg_txt      TYPE text255,
        lv_exp_date     TYPE aldate_del,   " Log Expiry date
        lst_log_numbers TYPE bal_s_lgnm.   " Application Log: Newly assigned LOGNUMBER

  "  Local Constants declaration
  CONSTANTS:
    lc_730    TYPE numc3      VALUE '730',
    lc_devid  TYPE zdevid     VALUE 'R096',        " Development ID
    lc_param1 TYPE rvari_vnam VALUE 'EXPIRY_DAYS'. " Parameter-1


  " Fetch SLG Logs Expiry days from ZCACONSTANT table
  SELECT SINGLE low FROM zcaconstant INTO @DATA(lv_exp_days)
         WHERE devid    = @lc_devid AND
               param1   = @lc_param1 AND
               activate = @abap_true.
  IF sy-subrc = 0.
    gv_exp_days = lv_exp_days.
  ENDIF.

  " Log Expiry date
  IF gv_exp_days IS INITIAL.
    gv_exp_days = lc_730.                  " Default Log Expiry days to 730 (2 Years)
  ENDIF.
  lv_exp_date = sy-datum + gv_exp_days.    " Logs Expiry Date: 730 days

  " Log Parameters
  lst_log-extnumber  = |{ fp_matnr }{ fp_plant }|.
  lst_log-object     = c_object.
  lst_log-subobject  = c_subobj.
  lst_log-aldate     = sy-datum.
  lst_log-altime     = sy-uzeit.
  lst_log-aluser     = sy-uname.
  lst_log-alprog     = sy-repid.
  lst_log-aldate_del = lv_exp_date.
  lst_log-del_before = abap_true.
  lst_log-params-altext = fp_plant.

  " Check for Comments
  IF jksdmaterialstatus-reprint_reason IS NOT INITIAL OR
     jksdmaterialstatus-remarks IS NOT INITIAL OR
     jksdmaterialstatus-om_instructions IS NOT INITIAL.
    " FM Call: Create Application Log
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = lst_log
      IMPORTING
        e_log_handle            = lv_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc = 0.
      APPEND lv_log_handle TO li_log_handle.
    ENDIF. " IF sy-subrc <> 0

    " Adding Log Messages
    IF jksdmaterialstatus-reprint_reason IS NOT INITIAL.
      lv_msg_txt = |Reprint Reason: { jksdmaterialstatus-reprint_reason }|.
      PERFORM f_add_msg USING lv_log_handle fp_plant lv_msg_txt.
    ENDIF.
    IF jksdmaterialstatus-remarks IS NOT INITIAL.
      lv_msg_txt = |Remarks: { jksdmaterialstatus-remarks }|.
      PERFORM f_add_msg USING lv_log_handle fp_plant lv_msg_txt.
    ENDIF.
    IF jksdmaterialstatus-om_instructions IS NOT INITIAL.
      lv_msg_txt = |OM Instructions: { jksdmaterialstatus-om_instructions }|.
      PERFORM f_add_msg USING lv_log_handle fp_plant lv_msg_txt.
    ENDIF.

    " FM Call: Save Application log
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = li_log_handle
      IMPORTING
        e_new_lognumbers = li_log_numbers
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.
    IF sy-subrc = 0.
      IF li_log_numbers[] IS NOT INITIAL.
        gv_lognumber = li_log_numbers[ 1 ]-lognumber.
      ENDIF.
      " Clear the Log from Buffer
      CALL FUNCTION 'BAL_LOG_REFRESH'
        EXPORTING
          i_log_handle  = lv_log_handle
        EXCEPTIONS
          log_not_found = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
        " Nothing to do
      ENDIF.
    ENDIF.

  ENDIF. " IF jksdmaterialstatus-reprint_reason IS NOT INITIAL OR


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MSG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  fp_log_handle  text
*  -->  fp_msg_txt     text
*----------------------------------------------------------------------*
FORM f_add_msg USING fp_log_handle fp_plant fp_msg_txt.

  DATA:
    lst_msg    TYPE bal_s_msg,
    lv_msg_len TYPE int4.

  lst_msg-msgty    = c_msgtyp_i.
  lst_msg-msgid    = c_msgid_zqtc.
  lst_msg-msgno    = c_msgno_000.
  lst_msg-params-altext = fp_plant.

  lv_msg_len = strlen( fp_msg_txt ).

  IF lv_msg_len LE 50.
    lst_msg-msgv1 = fp_msg_txt.
  ELSEIF lv_msg_len GT 50 AND lv_msg_len LE 100.
    lv_msg_len = lv_msg_len - 50.
    lst_msg-msgv1 = fp_msg_txt+0(50).
    lst_msg-msgv2 = fp_msg_txt+50(lv_msg_len).
  ELSEIF lv_msg_len GT 100 AND lv_msg_len LE 150.
    lv_msg_len = lv_msg_len - 100.
    lst_msg-msgv1 = fp_msg_txt+0(50).
    lst_msg-msgv2 = fp_msg_txt+50(50).
    lst_msg-msgv3 = fp_msg_txt+100(lv_msg_len).
  ELSEIF lv_msg_len GT 150.
    IF lv_msg_len GT 200.
      lv_msg_len = 200 - 150.
    ELSE.
      lv_msg_len = lv_msg_len - 150.
    ENDIF.
    lst_msg-msgv1 = fp_msg_txt+0(50).
    lst_msg-msgv2 = fp_msg_txt+50(50).
    lst_msg-msgv3 = fp_msg_txt+100(50).
    lst_msg-msgv4 = fp_msg_txt+150(lv_msg_len).
  ENDIF. " IF lv_msg_len LE 50

  " FM Call: Add Messages to Application log
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle  = fp_log_handle
      i_s_msg       = lst_msg
    EXCEPTIONS
      log_not_found = 0
      OTHERS        = 1.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.


ENDFORM.
*BOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
MODULE status_9002 OUTPUT.

  SET PF-STATUS 'GUI_9001'.
  SET TITLEBAR 'TITLE_9001'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.


  CASE ok_code.

    WHEN 'CX_SAVE'.
      PERFORM f_save_adjustment USING gv_matnr gv_plant.
      LEAVE TO SCREEN 0.

    WHEN 'CX_CANC'.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      LEAVE TO SCREEN 0.

  ENDCASE.


ENDMODULE.

FORM f_save_adjustment USING fp_matnr fp_plant.

  " Local Data
  DATA: lst_log         TYPE bal_s_log,    " Application Log: Log header data
        lv_log_handle   TYPE balloghndl,   " Application Log: Log Handle
        li_log_handle   TYPE bal_t_logh,   " Application Log: Log Handle Table
        li_log_numbers  TYPE bal_t_lgnm,
        lv_msg_txt      TYPE text255,
        lv_exp_date     TYPE aldate_del,   " Log Expiry date
        lst_log_numbers TYPE bal_s_lgnm,   " Application Log: Newly assigned LOGNUMBER
        lst_wrklist     TYPE zscm_worklistlog.

*  "  Local Constants declaration
*  CONSTANTS:
*    lc_730    TYPE numc3      VALUE '730',
*    lc_devid  TYPE zdevid     VALUE 'R096',        " Development ID
*    lc_param1 TYPE rvari_vnam VALUE 'EXPIRY_DAYS'. " Parameter-1
*
*
*  " Fetch SLG Logs Expiry days from ZCACONSTANT table
*  SELECT SINGLE low FROM zcaconstant INTO @DATA(lv_exp_days)
*         WHERE devid    = @lc_devid AND
*               param1   = @lc_param1 AND
*               activate = @abap_true.
*  IF sy-subrc = 0.
*    gv_exp_days = lv_exp_days.
*  ENDIF.
*
*  " Log Expiry date
*  IF gv_exp_days IS INITIAL.
*    gv_exp_days = lc_730.                  " Default Log Expiry days to 730 (2 Years)
*  ENDIF.
*  lv_exp_date = sy-datum + gv_exp_days.    " Logs Expiry Date: 730 days

  " Log Parameters
  lst_wrklist-media_product = gv_product.
  lst_wrklist-media_issue   = gv_matnr.
  lst_wrklist-pub_date      = gv_pubdate.
  lst_wrklist-plant_marc    = gv_plant.
  lst_wrklist-om_actual     = gv_omactual.
  lst_wrklist-adjustment    = zscm_worklistlog-adjustment.
  lst_wrklist-last_chg_user = sy-uname.
  lst_wrklist-last_chg_date = sy-datum.

  MODIFY zscm_worklistlog FROM lst_wrklist.
  gv_adjustment = zscm_worklistlog-adjustment.

ENDFORM.

MODULE user_command_9003 INPUT.


  CASE ok_code.

    WHEN 'CX_SAVE'.
      PERFORM f_save_omactual.
      LEAVE TO SCREEN 0.

    WHEN 'CX_CANC'.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      LEAVE TO SCREEN 0.

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_OMACTUAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_omactual .

" Local Data
  DATA: lst_log         TYPE bal_s_log,    " Application Log: Log header data
        lv_log_handle   TYPE balloghndl,   " Application Log: Log Handle
        li_log_handle   TYPE bal_t_logh,   " Application Log: Log Handle Table
        li_log_numbers  TYPE bal_t_lgnm,
        lv_msg_txt      TYPE text255,
        lv_exp_date     TYPE aldate_del,   " Log Expiry date
        lst_log_numbers TYPE bal_s_lgnm,   " Application Log: Newly assigned LOGNUMBER
        lst_wrklist     TYPE zscm_worklistlog.

  " Log Parameters
  lst_wrklist-media_product = gv_product.
  lst_wrklist-media_issue   = gv_matnr.
  lst_wrklist-pub_date      = gv_pubdate.
  lst_wrklist-plant_marc    = gv_plant.
  lst_wrklist-om_actual     = zscm_worklistlog-om_actual.
  lst_wrklist-adjustment    = gv_adjustment.
  lst_wrklist-last_chg_user = sy-uname.
  lst_wrklist-last_chg_date = sy-datum.

  MODIFY zscm_worklistlog FROM lst_wrklist.
  gv_omactual = zscm_worklistlog-om_actual.

ENDFORM.

MODULE status_9003 OUTPUT.

  SET PF-STATUS 'GUI_9001'.
  SET TITLEBAR 'TITLE_9001'.

ENDMODULE.
*EOI: OTCM-30221(R096) TDIMANTHA 11-FEB-2021  ED2K921719
