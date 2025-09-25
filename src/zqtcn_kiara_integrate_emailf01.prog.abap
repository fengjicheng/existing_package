*&---------------------------------------------------------------------*
*&  Include           ZQTCR_KIARA_INTEGRATE_EMAILF01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_KIARA_INTEGRATE_EMAIL                            *
* PROGRAM DESCRIPTION: This program will trigger an Email when update  *
*                      from KIARA to Acceptance Date in Sales          *
*                      document fails                                  *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 06/05/2021                                          *
* OBJECT ID      :                                                     *
* TRANSPORT NUMBER(S): ED2K923295                                      *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_APPLICATION_DB_LOGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_application_db_logs .
* Local Declarations
  DATA:lr_msgno  TYPE TABLE OF ssc_s_rg_msgno,
       lst_msgno TYPE ssc_s_rg_msgno,
       li_mess_t TYPE STANDARD TABLE OF balm.
  CONSTANTS:lc_000 TYPE char5 VALUE '000'.
  "Fetching Entries from Constant Table
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low
    FROM zcaconstant
    INTO TABLE @DATA(lt_constant)
   WHERE devid    EQ @gc_devid
   AND   activate EQ @abap_true.

  IF  sy-subrc    IS INITIAL
                  AND lt_constant IS NOT INITIAL.

    CLEAR: gv_number1,
           gv_number2.

    FREE i_receivers.

    LOOP AT lt_constant
      INTO DATA(lst_constant).

      CASE: lst_constant-param1.

        WHEN: gc_msgno.
          lst_msgno-sign    = lst_constant-sign.
          lst_msgno-option  = lst_constant-opti.
          lst_msgno-low     = lst_constant-low.
          APPEND lst_msgno TO lr_msgno.
          CLEAR lst_msgno.

        WHEN: gc_email.

          i_receivers-receiver = lst_constant-low.
          i_receivers-rec_type = gc_u.

          APPEND i_receivers.

        WHEN: OTHERS.
          "Do Nothing.

      ENDCASE.

    ENDLOOP.

  ENDIF.


  FREE: i_header_data,
        i_messages.

  CLEAR: gv_numberof_logs,
         gv_external_num.

  MOVE s_exter-low TO gv_external_num.

  MOVE: s_date-low  TO gv_fromdate,
        s_date-high TO gv_todate.

  " FM Call: Read Logs from DB
  CALL FUNCTION 'APPL_LOG_READ_DB'    ##FM_SUBRC_OK
    EXPORTING
      object          = gc_object
      subobject       = gc_subobj
      external_number = gv_external_num
      date_from       = gv_fromdate
      date_to         = gv_todate
    IMPORTING
      number_of_logs  = gv_numberof_logs
    TABLES
      header_data     = i_header_data
      messages        = i_messages.
  IF  sy-subrc <> 0.
"Implement Suitable errro Handling
  ENDIF.

   IF i_header_data  IS NOT INITIAL.

    CLEAR st_final.
    SORT i_messages BY lognumber msgid msgnumber msgv4.
    LOOP AT i_header_data
      INTO DATA(wa_header_data).
      li_mess_t[] = i_messages[].
      DELETE li_mess_t WHERE lognumber NE wa_header_data-lognumber
                       OR    msgv4     NOT IN lr_msgno.
      LOOP AT li_mess_t INTO DATA(lst_mess)."#EC CI_NESTED
        MOVE: lst_mess-lognumber TO st_final-lognumber,
              lst_mess-msgid     TO st_final-msgid,
              lst_mess-msgv4     TO st_final-msgv4,
              lst_mess-msgv1     TO st_final-msgv1,
              lst_mess-msgv2     TO st_final-msgv2,
              lst_mess-msgv3     TO st_final-msgv3.
        APPEND st_final TO i_final.
        CLEAR st_final.
      ENDLOOP.
      READ TABLE i_messages
           INTO lst_mess
           WITH KEY lognumber     = wa_header_data-lognumber
                    msgid         = gc_qtcr2
                    msgnumber     = gc_number3
                    msgv4         = lc_000
                    BINARY SEARCH.
      IF  sy-subrc     IS INITIAL.
        MOVE: lst_mess-lognumber TO st_final-lognumber,
              lst_mess-msgid     TO st_final-msgid,
              lst_mess-msgv4     TO st_final-msgv4,
              lst_mess-msgv1     TO st_final-msgv1,
              lst_mess-msgv2     TO st_final-msgv2,
              lst_mess-msgv3     TO st_final-msgv3,
              lst_mess-msgv1+gc_0(gc_10)  TO st_final-vbeln,
              lst_mess-msgv1+gc_13(gc_6)  TO st_final-posnr.
        APPEND st_final TO i_final.
        CLEAR st_final.
      ENDIF.

    ENDLOOP.

   ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TRIGGER_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_trigger_email .

  "Mail Content.
  IF s_exter IS NOT INITIAL.

    CONCATENATE text-002
                text-003
           INTO gv_message
       SEPARATED BY space.

    APPEND gv_message TO i_message.

  ELSEIF s_exter IS INITIAL.

    CONCATENATE text-013
                text-003
           INTO gv_message
       SEPARATED BY space.

    APPEND gv_message TO i_message.

  ENDIF.

  CLEAR gv_message.
  APPEND gv_message TO i_message.

  " Mail Contents
  gv_message = text-004.
  APPEND gv_message TO i_message.

  CLEAR gv_message.
  APPEND gv_message TO i_message.

  IF s_exter IS NOT INITIAL.
    LOOP AT i_final INTO st_final.
      IF sy-tabix = '1'.
        CONCATENATE text-007
                    st_final-lognumber
                    INTO  gv_message
                    SEPARATED BY ':'.
        APPEND gv_message TO i_message.
        CLEAR gv_message.

        CONCATENATE text-009
                    st_final-msgv4
                    INTO  gv_message
                    SEPARATED BY ':'.
        APPEND gv_message TO i_message.
        CLEAR gv_message.
        gv_message  = text-010.
        APPEND gv_message TO i_message.
        CLEAR gv_message.
      ENDIF.
      CLEAR gv_messagev1v2.
      CONCATENATE st_final-msgv1
                  st_final-msgv2
                  st_final-msgv3
                  INTO gv_message.
      APPEND gv_message TO i_message.
      CLEAR gv_message.
      IF st_final-vbeln IS NOT INITIAL.
        MOVE: st_final-vbeln TO gv_vbeln,
              st_final-posnr TO gv_posnr.
      ENDIF.

    ENDLOOP.

  ELSEIF s_exter IS INITIAL.
    "Preaparing the Excel Attachment for the Display.
*-- Excel Header
    CONCATENATE text-007
*                text-008
                text-009
                text-010
                text-011
                text-012
           INTO i_attachment SEPARATED BY gc_hortab.

    CONCATENATE gc_crlf i_attachment INTO i_attachment.

    APPEND i_attachment.

    LOOP AT i_final
      INTO  st_final.

*      IF st_final-msgv4 EQ gv_number1.
        CLEAR gv_messagev1v2.
        CONCATENATE st_final-msgv1
                    st_final-msgv2
                    INTO gv_messagev1v2.
        CONCATENATE st_final-lognumber
*                    st_final-msgid
                    st_final-msgv4
                    gv_messagev1v2
                    st_final-vbeln
                    st_final-posnr
               INTO i_attachment
          SEPARATED BY gc_hortab.

      CONCATENATE gc_crlf i_attachment INTO i_attachment.

      APPEND i_attachment.

    ENDLOOP.

  ENDIF.

  APPEND gv_message TO i_message.

  gv_message = text-005.

  APPEND gv_message TO i_message.

  CLEAR gv_message.

  DESCRIBE TABLE i_message LINES gv_lines.

  READ TABLE i_message INTO gv_message INDEX gv_lines.

  gv_docdata-doc_size = ( gv_lines - 1 ) * 255 + strlen( gv_message ).

*   Packing List For the E-mail Body
  gv_packlist-head_start = 1.
  gv_packlist-head_num   = 0.
  gv_packlist-body_start = 1.
  gv_packlist-body_num   = gv_lines.
  gv_packlist-doc_type   = gc_raw.
  APPEND gv_packlist TO i_packing_list.

  IF s_exter IS INITIAL.
*-- Create attachment notification
    gv_packlist-transf_bin = abap_true.
    gv_packlist-head_start = 1.
    gv_packlist-head_num   = 1.
    gv_packlist-body_start = 1.

    DESCRIBE TABLE i_attachment
             LINES gv_packlist-body_num.

    CLEAR gv_file_name.

    CONCATENATE text-006
                sy-datum
                sy-uzeit
           INTO gv_file_name
         SEPARATED BY '_'.

*   Packing List For the E-mail Body
    gv_packlist-obj_descr  =  gv_file_name.
    gv_packlist-obj_name   =  gv_file_name.
    gv_packlist-doc_type   = gc_xls.
    gv_packlist-doc_size   = gv_packlist-body_num * 255.

    APPEND gv_packlist TO i_packing_list.

  ENDIF.


  IF s_exter IS NOT INITIAL.
    "Mail Subject
    IF  gv_vbeln IS INITIAL.

      IF sy-sysid EQ 'EP1'.

        MOVE: text-006 TO gv_docdata-obj_descr.

      ELSEIF sy-sysid NE 'EP1'.

        CONCATENATE sy-sysid
                    text-006
               INTO gv_docdata-obj_descr
           SEPARATED BY '_'.

      ENDIF.


    ELSEIF gv_vbeln IS NOT INITIAL.

      IF sy-sysid EQ 'EP1'.

        CONCATENATE text-006
                    gv_vbeln
               INTO gv_docdata-obj_descr
          SEPARATED BY '_'.

      ELSEIF sy-sysid NE 'EP1'.

        CONCATENATE sy-sysid
                    text-006
                    gv_vbeln
               INTO gv_docdata-obj_descr
          SEPARATED BY '_'.

      ENDIF.

    ENDIF.
"To Trigger an Email
    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = gv_docdata
        put_in_outbox              = abap_true
        commit_work                = abap_true
      TABLES
        packing_list               = i_packing_list
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
    IF sy-subrc <> 0.
"Implement suitable Error Handling
    ELSEIF sy-subrc IS INITIAL.

      MESSAGE text-014 TYPE 'S'.

    ENDIF.

  ELSEIF s_exter IS INITIAL.
    "Mail Subject
      IF sy-sysid EQ 'EP1'.

        MOVE: text-006 TO gv_docdata-obj_descr.

      ELSEIF sy-sysid NE 'EP1'.

        CONCATENATE sy-sysid
                    text-006
               INTO gv_docdata-obj_descr
           SEPARATED BY '_'.

      ENDIF.
"to Trigger an email
    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = gv_docdata
        put_in_outbox              = abap_true
        commit_work                = abap_true
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
    IF sy-subrc <> 0.
"Implement suitable Error Handling
    ELSEIF sy-subrc IS INITIAL.

      MESSAGE text-014 TYPE 'S'.

    ENDIF.

  ENDIF.

ENDFORM.
