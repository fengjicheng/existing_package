*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SEND_AC_NOTIF_R095_RF02
*&---------------------------------------------------------------------*
    CLASS lcl_send_ac_notif IMPLEMENTATION.
      METHOD meth_get_data.
        DATA : lw_nast       TYPE nast,
               lv_no_records TYPE c.
        CONSTANTS : lc_p(2) TYPE c VALUE '&1'. " Text symbol dynamic parameter
        SELECT vbeln, vposn, vdemdat
            FROM veda
            INTO TABLE @DATA(lt_veda)
            WHERE vdemdat EQ @p_cedat.
        IF sy-subrc EQ 0.
* Contract end date, Partner from Item Item level
          SELECT vbeln, posnr, pstyv, uepos, mvgr3
            FROM vbap
            INTO TABLE @DATA(lt_vbap)
            FOR ALL ENTRIES IN @lt_veda
            WHERE vbeln EQ @lt_veda-vbeln
              AND posnr EQ @lt_veda-vposn
              AND pstyv EQ @p_itmcat
              AND abgru EQ @space
              AND mvgr3 IN @so_grade.
          IF sy-subrc EQ 0.
            " Delete non Higher-level items
            DELETE lt_vbap WHERE uepos IS NOT INITIAL.
            " If grades are available and remainder is selected remove the graded records
            IF p_mailty EQ c_rem.
              DELETE lt_vbap WHERE mvgr3 IS NOT INITIAL.
            ENDIF.
            IF lt_vbap IS NOT INITIAL.
              SELECT vbeln, posnr, parvw, kunnr
                FROM vbpa
                INTO TABLE @DATA(lt_vbpa_item_level)
                FOR ALL ENTRIES IN @lt_vbap
                WHERE vbeln EQ @lt_vbap-vbeln
                  AND parvw EQ @c_sh.
              IF sy-subrc EQ 0.
                SORT lt_vbap BY vbeln posnr.
                SORT lt_vbpa_item_level BY vbeln posnr.
                DATA : lt_vbpa LIKE lt_vbpa_item_level,
                       lw_vbpa LIKE LINE OF lt_vbpa.
                LOOP AT lt_vbap INTO DATA(lw_vbap).
                  READ TABLE lt_vbpa_item_level INTO DATA(lw_vbpa1) WITH KEY vbeln = lw_vbap-vbeln
                                                                            posnr = lw_vbap-posnr
                                                                            BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lw_vbpa = lw_vbpa1.
                    CLEAR lw_vbpa1.
                  ELSE.
                    READ TABLE lt_vbpa_item_level INTO DATA(lw_vbpa2) WITH KEY vbeln = lw_vbap-vbeln
                                                                               posnr = space
                                                                               BINARY SEARCH.
                    IF sy-subrc EQ 0.
                      lw_vbpa-vbeln = lw_vbap-vbeln.
                      lw_vbpa-posnr = lw_vbap-posnr.
                      lw_vbpa-parvw = lw_vbpa2-parvw.
                      lw_vbpa-kunnr = lw_vbpa2-kunnr.
                      CLEAR lw_vbpa2.
                    ENDIF.
                  ENDIF.
                  APPEND lw_vbpa TO lt_vbpa.
                  CLEAR : lw_vbap, lw_vbpa.
                ENDLOOP.
              ENDIF.
            ENDIF.
          ENDIF.
          IF lt_vbpa IS NOT INITIAL.
*       Set NAST Entries
            SORT lt_vbpa BY vbeln posnr.
            CLEAR lw_nast.
            LOOP AT lt_vbpa INTO lw_vbpa.
              lw_nast-mandt = sy-mandt.
              lw_nast-kappl = c_kappl.
              CONCATENATE lw_vbpa-vbeln lw_vbpa-posnr INTO lw_nast-objky.
              lw_nast-kschl = p_optyp.
              lw_nast-spras = sy-langu.
              lw_nast-parnr = lw_vbpa-kunnr.
              lw_nast-parvw = lw_vbpa-parvw.
              lw_nast-erdat = sy-datum.
              lw_nast-eruhr = sy-uzeit.
              lw_nast-nacha = c_nacha.
              lw_nast-anzal = c_anzal.
              lw_nast-vsztp = c_vsztp.
              lw_nast-manue = c_x.
              lw_nast-usnam = sy-uname.
              lw_nast-ldest = c_ldest.
              lw_nast-pfld1 = p_mailty.
              SHIFT p_days LEFT DELETING LEADING '0'.
              lw_nast-pfld2 = p_days.
* Begin by Aslam on 11/01/2019 - JIRA Ticket:ERPM-5282, TR: ED2K916407
* 2.  Set the VSTAT value to zero and update in NAST.
              lw_nast-vstat = c_anzal.
* End by Aslam on 11/01/2019 - JIRA Ticket:ERPM-5282, TR: ED2K916407
              lw_nast-tcode = c_tcode.
              lw_nast-objtype = c_objtype.
              CALL METHOD meth_nast_entries
                EXPORTING
                  im_nast = lw_nast.
              SELECT SINGLE *
                FROM nast
                INTO @DATA(wa_nast)
               WHERE kappl EQ @lw_nast-kappl
                 AND objky EQ @lw_nast-objky
                 AND kschl EQ @lw_nast-kschl
                 AND spras EQ @lw_nast-spras
                 AND parnr EQ @lw_nast-parnr
                 AND parvw EQ @lw_nast-parvw
                 AND erdat EQ @lw_nast-erdat
                 AND eruhr EQ @lw_nast-eruhr.
              IF sy-subrc EQ 0.
                w_msg-contract_id = lw_nast-objky+0(10).
                w_msg-item        = lw_nast-objky+10(6).
                w_msg-comments = text-016.  " Nast entry creation message with email type
                REPLACE lc_p WITH lw_nast-kschl INTO w_msg-comments.
                APPEND w_msg TO i_msg.
              ELSE.
                w_msg-contract_id = lw_nast-objky+0(10).
                w_msg-item        = lw_nast-objky+10(6).
                w_msg-comments     = text-017.  " Nast entry creation failure message
                REPLACE lc_p WITH lw_nast-kschl INTO w_msg-comments.
                APPEND w_msg TO i_msg.
              ENDIF.
              CLEAR : lw_nast, lw_vbpa, w_msg.
            ENDLOOP.
          ELSE.
            lv_no_records = c_x.
          ENDIF.
        ELSE.
          lv_no_records = c_x.
        ENDIF.
        IF lv_no_records IS NOT INITIAL.
          CLEAR lv_no_records.
          MESSAGE text-018 TYPE c_i.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDMETHOD.
      METHOD meth_nast_entries.
        CALL FUNCTION 'RV_MESSAGE_UPDATE_SINGLE'
          EXPORTING
            msg_nast = im_nast.
      ENDMETHOD.
      METHOD meth_generate_output.
        DATA: lo_alv    TYPE REF TO cl_salv_table, " ALV reference
              lo_cols   TYPE REF TO cl_salv_columns,
              lo_column TYPE REF TO cl_salv_column,
              lo_msg    TYPE REF TO cx_salv_msg,
              lv_string TYPE string.
        CONSTANTS : lc_fieldname TYPE lvc_fname VALUE 'CONTRACT_ID'.
        TRY.
            cl_salv_table=>factory(
              IMPORTING
                r_salv_table = lo_alv
              CHANGING
                t_table      = i_msg ).
          CATCH cx_salv_msg INTO lo_msg.
            lv_string = lo_msg->get_text( ).
            MESSAGE lv_string TYPE c_i.
        ENDTRY.

        " Column heading
        lo_cols = lo_alv->get_columns( ).
        TRY.
            lo_column = lo_cols->get_column( lc_fieldname ).
          CATCH cx_salv_not_found INTO DATA(lo_msg1).
            lv_string = lo_msg1->get_text( ).
            MESSAGE lv_string TYPE c_i.
        ENDTRY.
        lo_column->set_long_text( 'Contract ID'(019) ).
        lo_column->set_medium_text( 'Contract ID'(019)  ).
        IF lo_alv IS NOT INITIAL.
          lo_alv->display( ). " Displaying the ALV
        ENDIF.
      ENDMETHOD.
      METHOD meth_send_mail.
        DATA : lv_sy_date        TYPE char10,                                   " System Date output format
               lv_erdat          TYPE char10,                                   " Order Date output format
* Begin by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
*               lv_arktx          TYPE arktx,                                    " Short text for sales order item
               lv_arktx          TYPE string,                                    " Short text for sales order item
* End by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
               lv_vdemdat        TYPE char10,                                   " Order End date Output format
               lv_stud_name      TYPE ad_name1,                                 " Student name
               lv_send_email     TYPE ad_smtpadr,                               " E-Mail Address
               lv_name           TYPE thead-tdname,                             " Standard text name
               lr_document       TYPE REF TO cl_document_bcs  VALUE IS INITIAL, " Wrapper Class for Office Documents
               lc_htm            TYPE so_obj_tp      VALUE 'HTM',               " Code for document class
               lv_subject        TYPE so_obj_des,                               " Short description of contents
               lv_sub            TYPE string,                                   " Subject
               lr_send_request   TYPE REF TO cl_bcs           VALUE IS INITIAL, " Business Communication Service
               lr_sender         TYPE REF TO if_sender_bcs    VALUE IS INITIAL, " Interface of Sender Object in BCS
               lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
               lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
               lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
               lt_soli           TYPE soli_tab.                                 " Mail body table

        CONSTANTS : lc_body    TYPE na_obs030  VALUE 'BODY',                    " Mail body
                    lc_subject TYPE na_obs030  VALUE 'SUBJECT'.                 " Mail subject

* Get initial data
        CALL METHOD meth_init_data
          EXPORTING
            im_nast       = im_nast
          IMPORTING
            ex_sy_date    = lv_sy_date
            ex_erdat      = lv_erdat
            ex_arktx      = lv_arktx
            ex_vdemdat    = lv_vdemdat
            ex_stud_name  = lv_stud_name
            ex_send_email = lv_send_email.
* get Standard texts
        SELECT devid, param1, param2, srno, low, high
          FROM zcaconstant
          INTO TABLE @DATA(lt_zcaconstant)
          WHERE devid    EQ @c_devid
            AND low      EQ @im_nast-pfld1
            AND activate EQ @c_x.
        IF sy-subrc EQ 0.
          LOOP AT lt_zcaconstant INTO DATA(lw_zca).
            lv_name = lw_zca-high.
            CASE lw_zca-param2.
              WHEN lc_body.                           " Prepare mail body
                CALL METHOD meth_get_so10_text
                  EXPORTING
                    im_name      = lv_name
                    im_days      = im_nast-pfld2
                    im_sy_date   = lv_sy_date
                    im_erdat     = lv_erdat
                    im_arktx     = lv_arktx
                    im_vdemdat   = lv_vdemdat
                    im_stud_name = lv_stud_name
                  IMPORTING
                    ex_soli      = lt_soli.
              WHEN lc_subject.                        " Prepare mail subject
                CALL METHOD meth_get_mail_subject
                  EXPORTING
                    im_name    = lv_name
                  IMPORTING
                    ex_subject = lv_sub.
                IF lv_sub IS NOT INITIAL.
                  lv_subject = lv_sub.
                ENDIF.
            ENDCASE.
          ENDLOOP.
        ENDIF.
* Create document
        IF lt_soli IS NOT INITIAL.
          TRY .
              lr_send_request = cl_bcs=>create_persistent( ).
              TRY.
                  DATA lv_msg TYPE string.
                  lr_document = cl_document_bcs=>create_document(
                  i_type = lc_htm
                  i_text = lt_soli
                  i_subject = lv_subject ).
                CATCH cx_static_check INTO DATA(lo_root).
                  lv_msg = lo_root->get_text( ).
                  MESSAGE lv_msg TYPE 'E'.
              ENDTRY.

* Pass the document to send request
              CALL METHOD lr_send_request->set_document( lr_document ).

              CALL METHOD lr_send_request->set_message_subject
                EXPORTING
                  ip_subject = lv_sub.

* Create sender
              lr_sender = cl_sapuser_bcs=>create( sy-uname ).

* Set sender
              lr_send_request->set_sender(
              EXPORTING
              i_sender = lr_sender ).

* Create recipient
              lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_send_email ).

** Set recipient
              lr_send_request->add_recipient(
              EXPORTING
              i_recipient = lr_recipient
              i_express = abap_true ).

* Send email
              lr_send_request->send(
              EXPORTING
              i_with_error_screen = abap_true " 'X'
              RECEIVING
              result = lv_sent_to_all ).

*   Check if the subroutine is called in update task.
              CALL METHOD cl_system_transaction_state=>get_in_update_task
                RECEIVING
                  in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
              IF lv_upd_tsk EQ 0.
                COMMIT WORK.
              ENDIF. " IF lv_upd_tsk EQ 0

              IF lv_upd_tsk EQ 0 OR lv_sent_to_all = abap_true.
                MESSAGE 'Email sent successfully'(010) TYPE c_s . "Email sent successfully
              ENDIF. " IF lv_sent_to_all = abap_true
            CATCH cx_bcs INTO DATA(lo_bcs_exception).
              MESSAGE i865(so) WITH lo_bcs_exception->error_type.
          ENDTRY.
        ENDIF.
      ENDMETHOD.
      METHOD meth_init_data.
        CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'                                " System date output format
          EXPORTING
            date_internal            = sy-datum
          IMPORTING
            date_external            = ex_sy_date
          EXCEPTIONS
            date_internal_is_invalid = 1
            OTHERS                   = 2.
        IF sy-subrc NE 0.
          MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        SELECT SINGLE vbeln, erdat, vkorg, vtweg                                " Fetch Order Date
                 FROM vbak
                 INTO @DATA(lw_vbak)
                 WHERE vbeln = @im_nast-objky+0(10).
        IF sy-subrc EQ 0.
          CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'                              " Order date output format
            EXPORTING
              date_internal            = lw_vbak-erdat
            IMPORTING
              date_external            = ex_erdat
            EXCEPTIONS
              date_internal_is_invalid = 1
              OTHERS                   = 2.
          IF sy-subrc NE 0.
            MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ENDIF.
*--------------------------------PRODUCT NAME--------------------------*
* 3. Product name use the sales text, use the logic below.
*    a. Use the READ_TEXT to get the sales text where
*         i.  TEXTNAME = Material + sales office + distribution
*        ii.  Lang = sy-langu
*       iii.  Text id = ‘0001’
*        iv.  Text object = ‘MVKE’.
        CONSTANTS : lc_id     TYPE thead-tdid     VALUE '0001', " Text ID of text to be read
                    lc_object TYPE thead-tdobject VALUE 'MVKE'. " Object of text to be read
        DATA : lv_name  TYPE tdobname,                          " Text Name
               lt_lines TYPE tlinet.                            " Lines of text read
        SELECT SINGLE vbeln, posnr, matnr
                         FROM vbap
                         INTO @DATA(lw_vbap)
                         WHERE vbeln = @im_nast-objky+0(10)
                           AND posnr = @im_nast-objky+10(6).
        IF sy-subrc EQ 0.
          SELECT SINGLE matnr, vkorg, vtweg
                   FROM mvke
                   INTO @DATA(lw_mvke)
                   WHERE matnr EQ @lw_vbap-matnr
                     AND vkorg EQ @lw_vbak-vkorg
                     AND vtweg EQ @lw_vbak-vtweg.
          IF sy-subrc EQ 0.
            CONCATENATE lw_mvke-matnr lw_mvke-vkorg lw_mvke-vtweg INTO lv_name.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                      = lc_id
                language                = c_e
                name                    = lv_name
                object                  = lc_object
              TABLES
                lines                   = lt_lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc EQ 0.

              IF sy-subrc EQ 0.
* Begin by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
*                READ TABLE lt_lines INTO DATA(lw_lines) INDEX 1.
*                ex_arktx = lw_lines-tdline.
                CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
                  EXPORTING
                    it_tline             = lt_lines
                 IMPORTING
                   EV_TEXT_STRING       = ex_arktx.
* End by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        SELECT SINGLE vbeln, vposn, vdemdat                                     " Fetch Order End date
                 FROM veda
                 INTO @DATA(lw_veda)
                 WHERE vbeln = @im_nast-objky+0(10)
                   AND vposn = @im_nast-objky+10(6).
        IF sy-subrc EQ 0.
          CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'                              " Order End date output format
            EXPORTING
              date_internal            = lw_veda-vdemdat
            IMPORTING
              date_external            = ex_vdemdat
            EXCEPTIONS
              date_internal_is_invalid = 1
              OTHERS                   = 2.
          IF sy-subrc NE 0.
            MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ENDIF.
        SELECT SINGLE vbeln, posnr, parvw, kunnr, parnr, adrnr                  " Student address number
                 FROM vbpa
                 INTO @DATA(lw_vbpa_itm)
                 WHERE vbeln = @im_nast-objky+0(10)
                   AND posnr = @im_nast-objky+10(6)
                   AND parvw = @im_nast-parvw.
        IF sy-subrc EQ 0.
          DATA lw_vbpa LIKE lw_vbpa_itm.
          lw_vbpa = lw_vbpa_itm.
        ELSE.
          SELECT SINGLE vbeln, posnr, parvw, kunnr, parnr, adrnr                  " Student address number
                   FROM vbpa
                   INTO @DATA(lw_vbpa_hdr)
                   WHERE vbeln = @im_nast-objky+0(10)
                     AND posnr = @space
                     AND parvw = @im_nast-parvw.
          IF sy-subrc EQ 0.
            lw_vbpa = lw_vbpa_hdr.
          ENDIF.
        ENDIF.
        IF lw_vbpa IS NOT INITIAL.
          SELECT addrnumber, date_from, nation, name1                           " Fetch Student Name
            FROM adrc
            INTO TABLE @DATA(lt_adrc)
            WHERE addrnumber EQ @lw_vbpa-adrnr.
          IF sy-subrc EQ 0.
            SORT lt_adrc BY date_from DESCENDING.
            READ TABLE lt_adrc INTO DATA(lw_adrc) INDEX 1.
            IF sy-subrc EQ 0.
              ex_stud_name = lw_adrc-name1.
            ENDIF.
          ENDIF.
          SELECT addrnumber, persnumber, date_from, consnumber, smtp_addr, valid_to " Fetch Student E-Mail Address
            FROM adr6
            INTO TABLE @DATA(lt_adr6)
            WHERE addrnumber EQ @lw_vbpa-adrnr.
          IF sy-subrc EQ 0.
            SORT lt_adr6 BY valid_to ASCENDING.
            READ TABLE lt_adr6 INTO DATA(lw_adr6) INDEX 1.
            IF sy-subrc EQ 0.
              ex_send_email = lw_adr6-smtp_addr.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDMETHOD.
      METHOD meth_get_so10_text.
        CONSTANTS : lc_st     TYPE thead-tdid     VALUE 'ST',          " Text ID of text to be read
                    lc_object TYPE thead-tdobject VALUE 'TEXT'.        " Object of text to be read
        DATA : lt_lines TYPE tlinet,                                   " Lines of text read
               lw_soli  TYPE soli.                                     " Mail body workarea
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = c_e
            name                    = im_name
            object                  = lc_object
          TABLES
            lines                   = lt_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
* prepare email body
        IF sy-subrc EQ 0.
          REFRESH ex_soli[].
          CLEAR lw_soli.
          lw_soli = '<html><head></head><body>'.
          APPEND lw_soli TO ex_soli.
          LOOP AT lt_lines INTO DATA(lw_lines).
            REPLACE ALL OCCURRENCES OF '&p_days&' IN lw_lines-tdline WITH im_days.
            REPLACE ALL OCCURRENCES OF '&lw_vbap-arktx&' IN lw_lines-tdline WITH im_arktx.
            REPLACE ALL OCCURRENCES OF '&lw_vbak-erdat&' IN lw_lines-tdline WITH im_erdat.
            REPLACE ALL OCCURRENCES OF '&lw_veda-vdemdat&' IN lw_lines-tdline WITH im_vdemdat.
            REPLACE ALL OCCURRENCES OF '&lv_stud_name&' IN lw_lines-tdline WITH im_stud_name.
            REPLACE ALL OCCURRENCES OF '&sy-datum&' IN lw_lines-tdline WITH im_sy_date.
            REPLACE 'https://www.advancementcourses.com/help/'(012) IN lw_lines-tdline WITH
            '<a href="https://www.advancementcourses.com/help/">https://www.advancementcourses.com/help/</a>'.
            REPLACE 'https://advancementcourses.learninghouse.com/'(013) IN lw_lines-tdline WITH
            '<a href="https://advancementcourses.learninghouse.com/">https://advancementcourses.learninghouse.com/</a>'.
            REPLACE 'support@advancementcourses.com'(014) IN lw_lines-tdline WITH
            '<a href="mailto:support@advancementcourses.com">support@advancementcourses.com</a>'.
            REPLACE '/ advancementcourses.com' IN lw_lines-tdline WITH
            '<a href="https://www.advancementcourses.com">/ advancementcourses.com</a>'.
            CLEAR lw_soli.
            lw_soli = lw_lines-tdline.
            IF lw_lines-tdformat EQ '/' OR lw_lines-tdformat EQ '*' OR lw_lines-tdformat EQ '/='.
              CONCATENATE '<br>' lw_soli INTO lw_soli.
            ENDIF.
            APPEND lw_soli TO ex_soli.
          ENDLOOP.
          CLEAR lw_soli.
          lw_soli = '</body></html>'.
          APPEND lw_soli TO ex_soli.
        ENDIF.
      ENDMETHOD.
      METHOD meth_get_mail_subject.
        CONSTANTS : lc_st     TYPE thead-tdid     VALUE 'ST',          " Text ID of text to be read
                    lc_object TYPE thead-tdobject VALUE 'TEXT'.        " Object of text to be read
        DATA : lt_lines TYPE tlinet.                                   " Lines of text read

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_st
            language                = c_e
            name                    = im_name
            object                  = lc_object
          TABLES
            lines                   = lt_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
* prepare email body
        IF sy-subrc EQ 0.
          READ TABLE lt_lines INTO DATA(lw_lines) INDEX 1.
          IF sy-subrc EQ 0.
            ex_subject = lw_lines-tdline.
          ENDIF.
        ENDIF.
      ENDMETHOD.
    ENDCLASS.
