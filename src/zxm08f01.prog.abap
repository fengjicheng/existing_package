*----------------------------------------------------------------------*
***INCLUDE ZXM08F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_LOG_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_create .
  DATA: li_log TYPE bal_s_log. " Application Log: Log header data

* define some header data of this log
  li_log-extnumber  = sy-datum.
  li_log-object     = 'ZPTP'.
  li_log-subobject  = 'ZPOINV'.
  li_log-aldate     = sy-datum.
  li_log-altime     = sy-uzeit.
  li_log-aluser     = sy-uname.
  li_log-alprog     = sy-repid.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = li_log
    IMPORTING
      e_log_handle            = gv_log_handle
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
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_maintain USING fp_key   TYPE sapb-sapobjid            " SAP ArchiveLink: Object ID (object identifier)..
                          fp_error TYPE i.

  DATA : lv_msg  TYPE bal_s_msg, " Application Log: Message Data
         lv_fval TYPE int4.      " Natural Number
  CLEAR lv_msg.
  lv_msg-msgty     = 'E'.
  lv_msg-msgid     = 'ZPTP_R1'.
  lv_msg-msgno     = '000'.

  CASE fp_error.
    WHEN 1.
      MOVE text-001 TO lv_msg-msgv3.
    WHEN 2.
      MOVE text-002 TO lv_msg-msgv3.
    WHEN 3.
      MOVE text-003 TO lv_msg-msgv3.
    WHEN 4.
      MOVE text-004 TO lv_msg-msgv3.
    WHEN 5.
      MOVE text-005 TO lv_msg-msgv3.
    WHEN 6.
      MOVE text-006 TO lv_msg-msgv3.
    WHEN 7.
      MOVE text-007 TO lv_msg-msgv3.
    WHEN 8.
      MOVE text-008 TO lv_msg-msgv3.
    WHEN OTHERS.
      MOVE text-009 TO lv_msg-msgv3.
  ENDCASE.
  CONCATENATE text-010 lv_msg-msgv3 INTO lv_msg-msgv3.

  CALL FUNCTION 'FORMAT_MESSAGE'
    EXPORTING
      id        = 'ZPTP_R1'
      lang      = 'EN'
      no        = '029'
    IMPORTING
      msg       = lv_msg-msgv1
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CONCATENATE text-011 fp_key+0(10) fp_key+10
      INTO lv_msg-msgv2 SEPARATED BY space.
  CONCATENATE lv_msg-msgv2 '.' INTO lv_msg-msgv2.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = gv_log_handle
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
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_save .
  "Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.

  ENDIF. " IF sy-subrc <> 0
ENDFORM. " F_LOG_SAVE
*&---------------------------------------------------------------------*
*&      Form  F_SEND_INFO_TO_SAP_INBOX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_info_to_sap_inbox USING fp_key   TYPE sapb-sapobjid            " SAP ArchiveLink: Object ID (object identifier)..
                                    fp_error TYPE i.

  DATA : lv_msg  TYPE bal_s_msg, " Application Log: Message Data
         lv_fval TYPE int4.      " Natural Number

  DATA: objcont  LIKE solisti1 OCCURS 5 WITH HEADER LINE.
  DATA: reclist  LIKE somlreci1 OCCURS 5 WITH HEADER LINE.
  DATA: doc_chng LIKE sodocchgi1.
  DATA: entries  LIKE sy-tabix.
  DATA: name(15),
        lv_no_show TYPE c,
        lv_lines   TYPE i.

  DATA: relat_tab    TYPE TABLE OF tree_struc,
        ls_relat_tab TYPE          tree_struc,
        ls_objid     TYPE          objid,
        ls_edp21     TYPE          edp21.

  CONSTANTS:
    lc_sndprn TYPE edipsndprn VALUE 'TIBCO',      "Partner Number of Sender
    lc_sndprt TYPE edipsndprt VALUE 'LS',         "Partner Type of Sender
    lc_mestyp TYPE edipmestyp VALUE 'INVOIC',     "Message Type
    lc_mescod TYPE edipmescod VALUE 'Z1',         "Message code
    lc_mesfct TYPE edipmesfct VALUE 'IPS',        "Message function
    lc_evcode TYPE edipevcode VALUE 'ZQTC_INVL'.  "Inbound Process Code

  CLEAR: lv_no_show, lv_lines, lv_msg.

  lv_msg-msgty     = 'E'.
  lv_msg-msgid     = 'ZPTP_R1'.
  lv_msg-msgno     = '000'.

  CASE fp_error.
    WHEN 1.
      MOVE text-001 TO lv_msg-msgv3.
    WHEN 2.
      MOVE text-002 TO lv_msg-msgv3.
    WHEN 3.
      MOVE text-003 TO lv_msg-msgv3.
    WHEN 4.
      MOVE text-004 TO lv_msg-msgv3.
    WHEN 5.
      MOVE text-005 TO lv_msg-msgv3.
    WHEN 6.
      MOVE text-006 TO lv_msg-msgv3.
    WHEN 7.
      MOVE text-007 TO lv_msg-msgv3.
    WHEN 8.
      MOVE text-008 TO lv_msg-msgv3.
    WHEN OTHERS.
      MOVE text-009 TO lv_msg-msgv3.
  ENDCASE.
  CONCATENATE text-010 lv_msg-msgv3 INTO lv_msg-msgv3.


  SELECT SINGLE *
    FROM edp21
    INTO ls_edp21
    WHERE sndprn = lc_sndprn
      AND sndprt = lc_sndprt
      AND mestyp = lc_mestyp
      AND mescod = lc_mescod
      AND mesfct = lc_mesfct
      AND evcode = lc_evcode.
  IF sy-subrc = 0.
    IF ls_edp21-usrtyp EQ 'S'.
      MOVE ls_edp21-usrkey TO ls_objid.
      CALL FUNCTION 'RH_OM_GET_HOLDER_OF_POSITION'
        EXPORTING
          plvar           = '01'
          otype           = 'S'
          objid           = ls_objid
*         refresh         =
        TABLES
*         disp_tab        = disp_tab
          relat_tab       = relat_tab
        EXCEPTIONS
          no_active_plvar = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
        MOVE 'X' TO lv_no_show.
        CONCATENATE text-012 ls_objid
                INTO lv_msg-msgv1 SEPARATED BY space.
        lv_msg-msgv2 = text-013.
      ELSE.
        DESCRIBE TABLE relat_tab LINES lv_lines.
        IF lv_lines LE 0.
          MOVE 'X' TO lv_no_show.
          CONCATENATE text-014 ls_objid
                  INTO lv_msg-msgv1 SEPARATED BY space.
        ENDIF.
      ENDIF.
    ELSE.
      IF ls_edp21-usrkey EQ space.
        MOVE 'X' TO lv_no_show.
      ENDIF.
    ENDIF.

    IF lv_no_show EQ 'X'.
    ELSE.
      doc_chng-obj_name = text-015.
      CONCATENATE text-016 fp_key+0(10) fp_key+10
              INTO doc_chng-obj_descr SEPARATED BY space.
      doc_chng-sensitivty = 'P'.

      CONCATENATE text-017
                  fp_key+0(10) fp_key+10
             INTO objcont SEPARATED BY space.
      APPEND objcont.
      CLEAR objcont.
      APPEND objcont.
      CONCATENATE text-018 lv_msg-msgv3
                  INTO objcont SEPARATED BY space.
      APPEND objcont.
      CLEAR objcont.
      APPEND objcont.
      objcont = text-019.
      APPEND objcont.

      DESCRIBE TABLE objcont LINES entries.
      READ TABLE objcont INDEX entries.
      doc_chng-doc_size = ( entries - 1 ) * 255 + strlen( objcont ).
      IF ls_edp21-usrtyp EQ 'S'.
        LOOP AT relat_tab INTO ls_relat_tab.
          CLEAR reclist.
          reclist-receiver = ls_relat_tab-objid.
          reclist-rec_type = 'B'.
          APPEND reclist.
        ENDLOOP.
      ELSE.
        CLEAR reclist.
        reclist-receiver = ls_edp21-usrkey.
        reclist-rec_type = 'B'.
        APPEND reclist.
      ENDIF.

      CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
        EXPORTING
          document_type              = 'RAW'
          document_data              = doc_chng
*         put_in_outbox              = 'X'
        TABLES
          object_content             = objcont
          receivers                  = reclist
        EXCEPTIONS
          too_many_receivers         = 1
          document_not_sent          = 2
          operation_no_authorization = 4
          OTHERS                     = 99.

      CASE sy-subrc.
        WHEN 0.
          lv_msg-msgty = 'S'.
          lv_msg-msgv1 = text-020.
          CLEAR lv_msg-msgv3.
          CALL FUNCTION 'BAL_LOG_MSG_ADD'
            EXPORTING
              i_log_handle     = gv_log_handle
              i_s_msg          = lv_msg
            EXCEPTIONS
              log_not_found    = 1
              msg_inconsistent = 2
              log_is_full      = 3
              OTHERS           = 4.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF. " IF sy-subrc <> 0
        WHEN OTHERS.
          lv_msg-msgv1 = text-021.
          CLEAR lv_msg-msgv3.
          CALL FUNCTION 'BAL_LOG_MSG_ADD'
            EXPORTING
              i_log_handle     = gv_log_handle
              i_s_msg          = lv_msg
            EXCEPTIONS
              log_not_found    = 1
              msg_inconsistent = 2
              log_is_full      = 3
              OTHERS           = 4.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF. " IF sy-subrc <> 0
      ENDCASE.
    ENDIF.
  ELSE.
    MOVE 'X' TO lv_no_show.
    lv_msg-msgv1 = text-021.
    lv_msg-msgv2 = text-022.
    CLEAR lv_msg-msgv3.
  ENDIF.

  IF lv_no_show EQ 'X'.
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = gv_log_handle
        i_s_msg          = lv_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF. " IF sy-subrc <> 0
  ENDIF.

ENDFORM. " F_SEND_INFO_TO_SAP_INBOX
