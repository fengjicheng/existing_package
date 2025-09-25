*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_EMAIL_NOTIF_F057_F
*&---------------------------------------------------------------------*


FORM f_processing.

*-- Free Tables
  PERFORM f_int_free.
*---Perform to populate sales data from NAST table
  PERFORM f_get_nast_data    USING     nast
                             CHANGING  st_vbco3.
*--get the data basic data
  PERFORM f_get_data.
*---get the constants data
  PERFORM f_get_constants CHANGING i_constant.
*---Final internal table
  PERFORM f_table_body.
*---Email triggering
  PERFORM f_email_output.
  v_output_typ = nast-kschl.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ALL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .

  FREE:i_vbak.
  SELECT vbeln
         auart
         vkorg
         vtweg
         spart
    FROM vbak
    INTO TABLE i_vbak
    WHERE vbeln =  st_vbco3-vbeln.
  IF sy-subrc = 0 AND i_vbak IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
           arktx
           pstyv
           uepos
           vkaus
      FROM vbap
      INTO TABLE i_vbap
      FOR ALL ENTRIES IN i_vbak
      WHERE vbeln = i_vbak-vbeln.

    SELECT vbeln
           vposn
           vbegdat
           venddat
      FROM veda
      INTO TABLE i_veda
      FOR ALL ENTRIES IN i_vbak
      WHERE vbeln = i_vbak-vbeln.

  ENDIF.
  IF st_vbco3-kunde IS NOT INITIAL.
    FREE:st_kna1.
    SELECT SINGLE kunnr
                  name1
                  adrnr
      FROM kna1
      INTO st_kna1
      WHERE kunnr = st_vbco3-kunde.
    IF st_kna1-adrnr IS NOT INITIAL.
      FREE:iv_send.
*----get email id from adr6 table
      SELECT SINGLE smtp_addr "E-Mail Address
        FROM adr6      "E-Mail Addresses (Business Address Services)
        INTO iv_send
        WHERE addrnumber = st_kna1-adrnr.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants CHANGING fp_i_constant TYPE tt_constant.
  DATA: lst_output_typ TYPE LINE OF fkk_rt_kschl,
        lst_vkorg_f057 TYPE LINE OF tdt_rg_vkorg,
        lst_vtweg_f057 TYPE LINE OF tdt_rg_vtweg,
        lst_spart_f057 TYPE LINE OF tdt_rg_spart,
        lst_auart_f057 TYPE LINE OF tdt_rg_auart,
        lst_tdnam_f057 TYPE ty_text_name.

  FREE: i_constant,lst_output_typ,lst_vkorg_f057,
        lst_vtweg_f057,lst_spart_f057,lst_auart_f057 .
*---Constant table entries for F057
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         srno        " ABAP: Current selection number
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
     FROM zcaconstant
     INTO TABLE fp_i_constant
     WHERE devid = c_devid
       AND activate = abap_true.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
  ENDIF.
  LOOP AT fp_i_constant INTO DATA(lst_constants).
    CASE lst_constants-param1.
      WHEN c_output_typ.
*---Order Output Type
        lst_output_typ-sign   = lst_constants-sign.
        lst_output_typ-option = lst_constants-opti.
        lst_output_typ-low    = lst_constants-low.
        lst_output_typ-high   = lst_constants-high.
        APPEND lst_output_typ TO r_output_typ.
        CLEAR lst_output_typ.
      WHEN c_auart.
*----Order type
        lst_auart_f057-sign   = lst_constants-sign.
        lst_auart_f057-option = lst_constants-opti.
        lst_auart_f057-low    = lst_constants-low.
        lst_auart_f057-high   = lst_constants-high.
        APPEND lst_auart_f057 TO r_auart_f057.
        CLEAR lst_auart_f057.
      WHEN c_vkorg.
*----Sale Org
        lst_vkorg_f057-sign   = lst_constants-sign.
        lst_vkorg_f057-option = lst_constants-opti.
        lst_vkorg_f057-low    = lst_constants-low.
        lst_vkorg_f057-high   = lst_constants-high.
        APPEND lst_vkorg_f057 TO r_vkorg_f057.
        CLEAR lst_vkorg_f057.
      WHEN c_vtweg.
*---Ditribution Channel
        lst_vtweg_f057-sign   = lst_constants-sign.
        lst_vtweg_f057-option = lst_constants-opti.
        lst_vtweg_f057-low    = lst_constants-low.
        lst_vtweg_f057-high   = lst_constants-high.
        APPEND lst_vtweg_f057 TO r_vtweg_f057.
        CLEAR lst_vtweg_f057.
      WHEN c_spart.
*---Division
        lst_spart_f057-sign   = lst_constants-sign.
        lst_spart_f057-option = lst_constants-opti.
        lst_spart_f057-low    = lst_constants-low.
        lst_spart_f057-high   = lst_constants-high.
        APPEND lst_spart_f057 TO r_spart_f057.
        CLEAR lst_spart_f057.
*---standard text names
      WHEN c_tdname.
        lst_tdnam_f057-sign   = lst_constants-sign.
        lst_tdnam_f057-opti   = lst_constants-opti.
        lst_tdnam_f057-low    = lst_constants-low.
        lst_tdnam_f057-high   = lst_constants-high.
        APPEND lst_tdnam_f057 TO r_tdnam_f057.
    ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TABLE_BODY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_table_body .
  DATA:lt_allocvaluesnum  TYPE STANDARD TABLE OF  bapi1003_alloc_values_num,
       lt_allocvalueschar TYPE STANDARD TABLE OF  bapi1003_alloc_values_char,
       lt_allocvaluescurr TYPE STANDARD TABLE OF  bapi1003_alloc_values_curr,
       lt_return_t        TYPE STANDARD TABLE OF  bapiret2,
       lv_vendorno        TYPE  lifnr,
       lv_objectkey       TYPE bapi1003_key-object,
       lv_objecttable     TYPE bapi1003_key-objecttable,
       lv_classnum        TYPE bapi1003_key-classnum,
       lv_classtype       TYPE bapi1003_key-classtype,
       lv_name            TYPE  thead-tdname,
       lt_lines           TYPE STANDARD TABLE OF  tline.
  CONSTANTS:lc_mara         TYPE bapi1003_key-objecttable VALUE 'MARA',        " Object Table
            lc_classnum     TYPE bapi1003_key-classnum    VALUE 'CHILD_COURSE', "Object Class
            lc_charact_part TYPE atnam                    VALUE 'PARTNER_UNIVERSITY', "Parner university
            lc_credits      TYPE atnam                    VALUE 'CREDITS',            "Credit
            lc_classtyp     TYPE bapi1003_key-classtype   VALUE '001',                "Class Type
            lc_object       TYPE thead-tdobject           VALUE 'MVKE',                "sale Text Object
            lc_id           TYPE thead-tdid               VALUE '0001'.                " Sales Text Id

  FREE:iv_partner,st_output,i_output_tb.
  lv_classnum    = lc_classnum.
  lv_classtype   = lc_classtyp.
  lv_objecttable = lc_mara.
  SORT: i_vbak BY vbeln,
        i_vbap BY vbeln posnr,
        i_veda BY vbeln vposn.
*---Output condition type - ZWEH
  IF nast-kschl EQ c_zweh .
    DELETE i_vbap WHERE uepos IS NOT INITIAL.     " Deleting the sub line items
*---Output condition type - ZWEL
  ELSEIF nast-kschl EQ c_zwel.
    DELETE i_vbap WHERE uepos IS NOT INITIAL AND vkaus IS INITIAL. " Deleting the sub line items and Usage field is blank
  ENDIF.
  SORT:i_vbak BY vbeln,
       i_vbap BY vbeln posnr.
  LOOP AT i_vbak INTO DATA(lst_vbak).
    IF lst_vbak-auart IN r_auart_f057       " Order Type
      AND lst_vbak-vkorg IN r_vkorg_f057    " Sale Org
      AND lst_vbak-spart IN r_spart_f057    " Division
      AND lst_vbak-vtweg IN r_vtweg_f057.   " Distribution

      READ TABLE i_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbak-vbeln.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT i_vbap INTO lst_vbap FROM lv_tabix.
          IF lst_vbap-vbeln <> lst_vbak-vbeln.
            EXIT.
          ELSE.
            FREE:st_output,lv_name,lt_lines.
            CONCATENATE lst_vbap-matnr lst_vbak-vkorg lst_vbak-vtweg INTO lv_name.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = lc_id
                language                = c_language
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
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ELSE.
              LOOP AT lt_lines INTO DATA(lst_lines).
                CONCATENATE lst_lines-tdline st_output-course_name
                INTO st_output-course_name.
              ENDLOOP.
            ENDIF.
            st_output-course_no = lst_vbap-matnr.
            FREE:lt_allocvaluesnum,lt_allocvalueschar,lt_allocvaluescurr,lt_return_t,
               lv_objectkey,lv_vendorno.
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
              EXPORTING
                input  = lst_vbap-matnr
              IMPORTING
                output = lst_vbap-matnr.

            lv_objectkey   = lst_vbap-matnr.

*---Get the material classification details
            CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
              EXPORTING
                objectkey       = lv_objectkey
                objecttable     = lv_objecttable
                classnum        = lv_classnum
                classtype       = lv_classtype
              TABLES
                allocvaluesnum  = lt_allocvaluesnum
                allocvalueschar = lt_allocvalueschar
                allocvaluescurr = lt_allocvaluescurr
                return          = lt_return_t.
            IF lt_allocvalueschar IS NOT INITIAL.
              READ TABLE lt_allocvalueschar INTO DATA(lst_allocvalueschar) WITH KEY charact = lc_charact_part.
              IF sy-subrc = 0.
                lv_vendorno     = lst_allocvalueschar-value_char.
                st_output-lifnr = lv_vendorno.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lv_vendorno
                  IMPORTING
                    output = lv_vendorno.
                SELECT SINGLE name1 FROM lfa1 INTO @DATA(lst_name) WHERE lifnr = @lv_vendorno.
                IF sy-subrc = 0.
                  st_output-int_name = lst_name.
                ENDIF.
              ENDIF.
              READ TABLE lt_allocvalueschar INTO lst_allocvalueschar WITH KEY charact = lc_credits.
              IF sy-subrc = 0.
                st_output-credits = lst_allocvalueschar-value_char.
              ENDIF.
            ENDIF.
            READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln =  lst_vbap-vbeln
                                                           vposn = lst_vbap-posnr.
            IF sy-subrc = 0.
              st_output-start_dt = lst_veda-vbegdat.
              st_output-end_dt   = lst_veda-venddat.
            ELSE.
              READ TABLE i_veda INTO lst_veda WITH KEY vbeln = lst_vbap-vbeln
                                                       vposn = '000000'.
              IF sy-subrc = 0.
                st_output-start_dt = lst_veda-vbegdat.
                st_output-end_dt   = lst_veda-venddat.
              ENDIF.
            ENDIF.
            APPEND st_output TO i_output_tb.
            FREE:st_output.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EMAIL_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM  f_email_output .
  DATA:
    lv_htm        TYPE so_obj_tp  VALUE 'HTM',
    li_lines      TYPE STANDARD TABLE OF tline, "Lines of text read
    lv_text       TYPE string,
    lv_subject    TYPE string,
    li_output_tmp TYPE STANDARD TABLE OF ty_output,
    lv_string     TYPE string.

  DATA:ls_text         TYPE so_text255,
       lt_text         TYPE bcsy_text,
       lv_send_request TYPE REF TO cl_bcs,
       lv_sender       TYPE REF TO cl_cam_address_bcs,
       lv_recipient    TYPE REF TO if_recipient_bcs,
       lv_mailid       TYPE ad_smtpadr,
       lt_bin_con      TYPE solix_tab,
       lv_size         TYPE so_obj_len,
       lv_sub          TYPE so_obj_des,
       lv_document     TYPE REF TO cl_document_bcs,
       lv_all          TYPE os_boolean,
       bcs_exception   TYPE REF TO cx_bcs.

  CONSTANTS:lc_e TYPE char1 VALUE 'E',
            lc_s TYPE char1 VALUE 'S'.

  IF i_output_tb IS NOT INITIAL.
    li_output_tmp = i_output_tb.
    SORT:li_output_tmp BY lifnr,
         i_output_tb  BY lifnr.
    DELETE ADJACENT DUPLICATES FROM li_output_tmp COMPARING lifnr.
  ENDIF.
  LOOP AT li_output_tmp INTO DATA(lst_output_tmp).


    IF iv_send IS NOT INITIAL.
*---Email Subject details
      CLEAR:lv_subject.
      CONCATENATE 'Advancement Courses Welcome and Enrollment Information – '(001)
          lst_output_tmp-int_name
          INTO lv_subject SEPARATED BY space.


      ls_text = '<body>'(002).
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      CONCATENATE 'Dear'(004) st_kna1-name1 INTO DATA(lv_name) SEPARATED BY space.
      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(003) lv_name ',' '</p>'(005)
                   INTO ls_text."ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      ls_text = space.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.
*-------Greeting section -----------------------
      PERFORM read_text   USING c_greetings
                          CHANGING  li_lines
                                    lv_text.
      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(003)
                  lv_text
                  '</p>'(005)
                  INTO ls_text SEPARATED BY space.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(003)
                 'You are enrolled in:'(006)
                  '</p>'(005)
                  INTO ls_text SEPARATED BY space.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.


      ls_text = '<center>'.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

*================== Begin of Table Headings =========================
      ls_text = '<TABLE  width= "100%" border="1" style="font-family:arial;font-size:90%;">'(007).
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

*---Course Name - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                     '<FONT COLOR = "WHITE"> <B>Course Name</B> </FONT>'(009)
                     '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.
*---Course Number - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                  '<FONT COLOR = "WHITE"><B>Course No.</B> </FONT>'(011)
                  '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

*---Institution Name - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                  '<FONT COLOR = "WHITE"><B>Institution Name</B> </FONT>'(012)
                  '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

*---Units - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                  '<FONT COLOR = "WHITE"><B>Units</B> </FONT>'(013)
                  '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.
*---Start Date - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                  '<FONT COLOR = "WHITE"><B>Start Date</B> </FONT>'(014)
                  '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

*---End Date - Column Heading
      CONCATENATE '<td align = "LEFT" BGCOLOR = "DodgerBlue">'(008)
                  '<FONT COLOR = "WHITE"><B>End Date</B> </FONT>'(015)
                  '</td>'(010)  INTO ls_text.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.
*---Filling the Table

      LOOP AT i_output_tb INTO st_output WHERE lifnr = lst_output_tmp-lifnr.
        CONCATENATE '<TR><td align = "LEFT">'(016)
                    '<FONT COLOR = "BLACK">' st_output-course_name '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.
        CONCATENATE '<td align = "LEFT">'(017)
                    '<FONT COLOR = "BLACK">' st_output-course_no '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.

        CONCATENATE '<td align = "LEFT">'(017)
                    '<FONT COLOR = "BLACK">' st_output-int_name '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.
        CONCATENATE '<td align = "LEFT">'(017)
                    '<FONT COLOR = "BLACK">' st_output-credits '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = st_output-start_dt
          IMPORTING
            output = st_output-start_dt.

        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = st_output-end_dt
          IMPORTING
            output = st_output-end_dt.


        CONCATENATE '<td align = "LEFT">'(017)
                    '<FONT COLOR = "BLACK">' st_output-start_dt '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.

        CONCATENATE '<td align = "LEFT">'(017)
                    '<FONT COLOR = "BLACK">' st_output-end_dt '</FONT>'
                    '</td>'(010)  INTO ls_text.
        APPEND ls_text TO lt_text.
        CLEAR:ls_text.
      ENDLOOP.

* Table - Closing Tag
      ls_text = '</TABLE>'.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      ls_text = '</center><br/><br/>'(018).
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      ls_text = space.
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.

      FREE:lv_text,li_lines,v_unversity_text.
**-------Important section -----------------------
      READ TABLE r_tdnam_f057 INTO DATA(lst_tdnam) WITH KEY low = lst_output_tmp-lifnr. " check the vendor text
      IF sy-subrc = 0.
        v_unversity_text = lst_tdnam-high.     "Standard text name
        FREE:lv_text,li_lines.
        PERFORM read_text   USING v_unversity_text
                            CHANGING  li_lines
                                      lv_text.

        LOOP AT li_lines INTO DATA(lst_lines).
          ls_text =  lst_lines-tdline.
          APPEND ls_text TO lt_text.
          CLEAR:ls_text.
        ENDLOOP.
      ENDIF.

      ls_text = '</body>'(019).
      APPEND ls_text TO lt_text.
      CLEAR:ls_text.


      TRY.
          lv_send_request = cl_bcs=>create_persistent( ).
          CLEAR:lv_sender.

          CALL METHOD cl_cam_address_bcs=>create_internet_address
            EXPORTING
              i_address_string = 'no-reply@wiley.com'(028)
              i_address_name   = 'The Advancement Courses Team'(027)
            RECEIVING
              result           = lv_sender.

          CALL METHOD lv_send_request->set_sender
            EXPORTING
              i_sender = lv_sender.
          lv_mailid = iv_send.
          CLEAR:lv_recipient,lt_bin_con.
          lv_recipient = cl_cam_address_bcs=>create_internet_address( lv_mailid ).
          CALL METHOD lv_send_request->add_recipient
            EXPORTING
              i_recipient  = lv_recipient
              i_express    = abap_true
              i_copy       = ' '
              i_blind_copy = ' '.
          TRY.
              cl_bcs_convert=>string_to_solix(
                EXPORTING
                  iv_string   = lv_string
                  iv_codepage = '4103'
                  iv_add_bom  = abap_true
                IMPORTING
                  et_solix  = lt_bin_con
                  ev_size   = lv_size ).
            CATCH cx_bcs.
              MESSAGE 'Error when transfering document contents'(023) TYPE lc_e.
          ENDTRY.
          lv_sub = lv_subject.
          lv_document = cl_document_bcs=>create_document(
            i_type    = lv_htm
            i_text    = lt_text
            i_subject = lv_sub ) .

          CALL METHOD lv_send_request->set_message_subject
            EXPORTING
              ip_subject = lv_subject.

          lv_send_request->set_document( lv_document ).

          lv_all = lv_send_request->send( i_with_error_screen = 'X' ).

          COMMIT WORK.

          IF  lv_all IS INITIAL.
            MESSAGE 'Welcome E-mail not sent'(024) TYPE lc_e.
          ELSE.
            MESSAGE 'Welcome E-mail sent sucessfully'(025) TYPE lc_s.
          ENDIF.
        CATCH cx_bcs INTO bcs_exception.
          FREE : lv_document,lv_send_request,lv_recipient.
      ENDTRY.

      FREE : lv_document,lv_send_request,lv_recipient,lt_text,lt_bin_con,lv_size,lv_sender,lv_all.
    ELSE.
      MESSAGE 'Mail ID not found'(026) TYPE lc_e.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM read_text  USING    fp_name      TYPE tdobname " Name
                CHANGING fp_lines     TYPE tttext
                         fp_text      TYPE string.

  DATA:  li_lines     TYPE STANDARD TABLE OF tline. "Lines of text read


  CLEAR: fp_text,
         li_lines.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = c_language
      name                    = fp_name
      object                  = c_object
    TABLES
      lines                   = fp_lines "li_lines
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
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = fp_lines "li_lines
      IMPORTING
        ev_text_string = fp_text.
    IF sy-subrc EQ 0.
      CONDENSE fp_text.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_NAST_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_NAST  text
*      <--P_ST_VBCO3  text
*----------------------------------------------------------------------*
FORM f_get_nast_data  USING    fp_nast     TYPE nast   " Message Status
                      CHANGING fp_st_vbco3 TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing

  fp_st_vbco3-mandt = sy-mandt.
  fp_st_vbco3-spras = fp_nast-spras.
  fp_st_vbco3-vbeln = fp_nast-objky+0(10).
  fp_st_vbco3-posnr = fp_nast-objky+10(6).
  fp_st_vbco3-kunde = fp_nast-parnr.
  fp_st_vbco3-parvw = fp_nast-parvw.
  v_langu = fp_nast-spras.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INT_FREE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_int_free .
  FREE:i_vbak,
       i_vbap,
       i_veda,
       i_constant,
       i_output_tb,
       st_output,
       iv_partner,
       st_vbco3,
       v_output_typ,
       r_output_typ,
       r_vkorg_f057,
       r_vtweg_f057,
       r_spart_f057,
       r_auart_f057,
       v_unversity_text,
       v_langu.
ENDFORM.
