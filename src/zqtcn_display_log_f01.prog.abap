*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DISPLAY_LOG_F01
*&---------------------------------------------------------------------*

FORM f_dynamic_screen.
  LOOP AT SCREEN.
    IF screen-group1 = 'PAT'.
      IF p_mail IS  NOT INITIAL.
        screen-input = 1.
        screen-invisible = 0.
        screen-active = 1.
      ELSE.
        screen-active = 0.
        screen-input = 0.
        screen-invisible = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
FORM f_status CHANGING lst_systems TYPE ctslg_system
                       lv_status   TYPE icon_d
                       lv_date     TYPE as4date
                       lv_time     TYPE as4time.
  CLEAR:lv_status.

  DESCRIBE TABLE lst_systems-steps LINES DATA(lv_lines). " Total Number of Lines in the SYSTEMS-STEPS
  READ TABLE lst_systems-steps INTO DATA(lst_action) INDEX lv_lines.
  IF sy-subrc = 0 AND lst_action-stepid = c_genrat.          "G  Generation of ABAPs and Screens
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_version . "V  Version Management: Set I Flags at Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_export .   " Export
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_y. "Conversion Program Call for Matchcode Generation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_o. "Conversion Program Call in Background (SE14 TBATG)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_a. "Activation of ABAP Dictionary objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_x. "Export Application-Defined Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_d. "Import Application-Defined Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_r. "Perform Actions after Activation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_b. "Activation with TACOB
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_n. "Conversion with TBATG (Upgrade or Transport)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_q. "Perform Actions Before Activation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_u. "Evaluation of Conversion Logs
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_s. "Distributor (Compare Program for Inactive Nametabs)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_j. "Activation of Dictionary Obj. with Inact. Nametab w/o Conv.
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_m. "Activation of ENQU/D, MCOB/ID/OF/OD
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_f. "Create Versions After Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_w. "Create Backup Versions before Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_p. "Activation of Nametab Entries
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_ext_t. "External Deployment Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_t. "Check Deploy Status
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_c. "HANA deployment for HOTA, HOTO, and HOTP objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_7. "Execute method (follow-up actions)

    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.
  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_i. "Set I Flags at Import

    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.
  ENDIF.
ENDFORM.

FORM f_action_status CHANGING fp_action TYPE ctslg_step
                              fp_status TYPE icon_d
                              fp_date   TYPE as4date
                              fp_time   TYPE as4time.
  IF fp_action-rc = c_zero OR fp_action-rc = c_four.
    fp_status = c_green.
    fp_date = fp_action-actions[ 1 ]-date.
    fp_time = fp_action-actions[ 1 ]-time.
  ELSEIF fp_action-rc = space .
    fp_status = space.
  ELSE.
    fp_status = c_red.
    fp_date = fp_action-actions[ 1 ]-date.
    fp_time = fp_action-actions[ 1 ]-time.
  ENDIF.

ENDFORM.
FORM f_display.
  DATA: li_columns   TYPE REF TO cl_salv_columns_table,
        li_column    TYPE REF TO cl_salv_column_table,
        lr_functions TYPE REF TO cl_salv_functions,
        lr_events    TYPE REF TO cl_salv_events_table.

  DATA:lv_trkorr  TYPE lvc_fname VALUE 'TRKORR',
       lv_trtype  TYPE lvc_fname VALUE 'TRTYPE',
       lv_as4user TYPE lvc_fname VALUE 'AS4USER',
       lv_as4text TYPE lvc_fname VALUE 'AS4TEXT',
       lv_ed1date TYPE lvc_fname VALUE 'ED1DATE',
       lv_ed2date TYPE lvc_fname VALUE 'ED2DATE',
       lv_eq1date TYPE lvc_fname VALUE 'EQ1DATE',
       lv_eq2date TYPE lvc_fname VALUE 'EQ2DATE',
       lv_ep1date TYPE lvc_fname VALUE 'EP1DATE',
       lv_es1date TYPE lvc_fname VALUE 'ES1DATE',
       lv_eq3date TYPE lvc_fname VALUE 'EQ3DATE',
       lv_ed1time TYPE lvc_fname VALUE 'ED1TIME',
       lv_ed2time TYPE lvc_fname VALUE 'ED2TIME',
       lv_eq1time TYPE lvc_fname VALUE 'EQ1TIME',
       lv_eq2time TYPE lvc_fname VALUE 'EQ2TIME',
       lv_eq3time TYPE lvc_fname VALUE 'EQ3TIME',
       lv_ep1time TYPE lvc_fname VALUE 'EP1TIME',
       lv_es1time TYPE lvc_fname VALUE 'ES1TIME',
       lv_ed1     TYPE lvc_fname VALUE 'ED1',
       lv_ed2     TYPE lvc_fname VALUE 'ED2',
       lv_eq1     TYPE lvc_fname VALUE 'EQ1',
       lv_eq2     TYPE lvc_fname VALUE 'EQ2',
       lv_eq3     TYPE lvc_fname VALUE 'EQ3',
       lv_ep1     TYPE lvc_fname VALUE 'EP1',
       lv_es1     TYPE lvc_fname VALUE 'ES1'.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = i_final.
    ##NO_HANDLER    CATCH cx_salv_msg .
  ENDTRY.
  gr_table->set_screen_status(
      pfstatus      =  'SALV_STANDARD'
      report        =  sy-repid
      set_functions = gr_table->c_functions_all ).

  lr_functions = gr_table->get_functions( ).
  lr_functions->set_all( abap_true ).
  li_columns = gr_table->get_columns( ).
  li_columns->set_optimize( abap_true ).


  TRY.
      li_columns = gr_table->get_columns( ).
    CATCH cx_salv_msg .
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( lv_trkorr ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( lv_trtype ).
      li_column->set_short_text( text-023 ).
      li_column->set_medium_text( text-024 ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( lv_as4user ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      li_column ?= li_columns->get_column( lv_as4text ).
    CATCH cx_salv_not_found.
  ENDTRY.

  IF  p_ed1 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_ed1 ).
        li_column->set_medium_text( text-001 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ed1date ).
        li_column->set_medium_text( text-011 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ed1time ).
        li_column->set_medium_text( text-010 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_ed1 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ed1date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ed1time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_ed2 = abap_true .
    TRY.
        li_column ?= li_columns->get_column( lv_ed2 ).
        li_column->set_medium_text( text-002 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ed2date ).
        li_column->set_medium_text( text-008 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ed2time ).
        li_column->set_medium_text( text-009 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_ed2 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ed2date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ed2time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_eq1 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_eq1 ).
        li_column->set_medium_text( text-003 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq1date ).
        li_column->set_medium_text( text-012 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq1time ).
        li_column->set_medium_text( text-013 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_eq1 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq1date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq1time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_eq2 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_eq2 ).
        li_column->set_medium_text( text-004 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq2date ).
        li_column->set_medium_text( text-014 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq2time ).
        li_column->set_medium_text( text-015 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_eq2 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq2date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq2time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_eq3 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_eq3 ).
        li_column->set_medium_text( text-005 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq3date ).
        li_column->set_medium_text( text-016 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_eq3time ).
        li_column->set_medium_text( text-017 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_eq3 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq3date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_eq3time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_ep1 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_ep1 ).
        li_column->set_medium_text( text-006 ).
        IF p_ep1 <> abap_true.
          li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        ENDIF.
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ep1date ).
        li_column->set_medium_text( text-018 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_ep1time ).
        li_column->set_medium_text( text-019 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_ep1 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ep1date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_ep1time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.
  IF p_es1 = abap_true.
    TRY.
        li_column ?= li_columns->get_column( lv_es1 ).
        li_column->set_medium_text( text-022 ).
      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_es1date ).
        li_column->set_medium_text( text-020 ).

      CATCH cx_salv_not_found.
    ENDTRY.
    TRY.
        li_column ?= li_columns->get_column( lv_es1time ).
        li_column->set_medium_text( text-021 ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ELSE.
    TRY.
        li_column ?= li_columns->get_column( lv_es1 ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_es1date ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
        li_column ?= li_columns->get_column( lv_es1time ).
        li_column->set_visible( value  = if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDIF.


  TRY.
      li_column ?= li_columns->get_column( lv_trkorr ).
      li_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  lr_events = gr_table->get_event( ).
  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.
  SET HANDLER gr_events->on_link_click FOR lr_events.
  gr_table->display( ).
ENDFORM.

FORM f_handle_user_command USING e_salv_function.
  DATA: li_rows  TYPE salv_t_row,
        lc_excel TYPE syst_ucomm VALUE 'EXCEL'.

  CASE sy-ucomm.
    WHEN lc_excel.
*----Excel Download
      PERFORM f_excel_download.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
FORM  show_cell_info  USING i_row    TYPE i
                          i_column TYPE lvc_fname.

  DATA:lst_row     TYPE char128,
       lv_dir_type TYPE tstrf01-dirtype  VALUE 'T'.

  WRITE i_row TO lst_row LEFT-JUSTIFIED.

  REPLACE ALL OCCURENCES OF ',' IN lst_row  WITH ''.

  READ TABLE i_final INTO DATA(lst_final) INDEX lst_row.
  IF sy-subrc = 0.
*--DIsplay TR LOG Overview screen with Tree Report
    CALL FUNCTION 'TR_LOG_OVERVIEW_REQUEST_REMOTE'
      EXPORTING
        iv_trkorr  = lst_final-trkorr
        iv_dirtype = lv_dir_type.
  ENDIF.
ENDFORM.

FORM f_build_mail.
  DATA:
    lv_count           TYPE syindex,                                     " Loop Index
    lst_attachment     TYPE solisti1,                                    " SAPoffice: Single List with Column Length 255
    li_mailrecipients  TYPE STANDARD TABLE OF somlreci1 INITIAL SIZE 0,  " SAPoffice: Structure of the API Recipient List
    li_mailtxt         TYPE STANDARD TABLE OF soli INITIAL SIZE 0,       " SAPoffice: line, length 255
    li_packing_list    TYPE STANDARD TABLE OF sopcklsti1 INITIAL SIZE 0, " SAPoffice: Description of Imported Object Components
    li_doc_data        TYPE STANDARD TABLE OF sodocchgi1 INITIAL SIZE 0, " Data of an object which can be changed
    lst_doc_data       TYPE sodocchgi1,                                  " Data of an object which can be changed
    lst_mailrecipients TYPE somlreci1.                                   " SAPoffice: Structure of the API Recipient List
  DATA:
    li_objhead      TYPE TABLE OF solisti1,  " Internal Table to hold data in single line format
    li_objtxt       TYPE TABLE OF solisti1,  " Internal Table to hold data in single line format
    lst_objtxt      TYPE solisti1,   " Structure to hold data in single line format
    lst_output_soli TYPE soli,       " Structure to hold Output Details in delimited format
    lst_objpack     TYPE sopcklsti1, " Structure to hold Imported Object Components
    lst_objhead     TYPE solisti1,   " Structure to hold data in single line format
    lst_str         TYPE string,
    lst_url         TYPE string,   " URL for the Runbook - Interface Error Guide
    lv_tzone        TYPE char10,
    lst_final       TYPE ty_final,
    lv_lines        TYPE sy-tabix,  "To hold number of records
    lv_msg_lines    TYPE sy-tabix,  "To hold number of records
    lv_sent_all(1)  TYPE c,
    lv_send_email   TYPE abap_bool VALUE abap_false, " Flag for email sending in case error IDoc exists
    lv_col_cnt      TYPE i, " Flag for column count to be displayed
    lv_intid        TYPE syst-slset,         " Interface ID from Selection Screen Variant
    lv_param1       TYPE rvari_vnam VALUE 'RUN_BOOK',
    lv_xls          TYPE so_obj_tp  VALUE 'XLS',
    lv_htm          TYPE so_obj_tp  VALUE 'HTM',
    lv_rec_u        TYPE so_escape  VALUE 'U'.
  DATA: i_objbin  LIKE solix OCCURS 10 WITH HEADER LINE,
        lv_string TYPE string,
        mailto    TYPE ad_smtpadr.
  FIELD-SYMBOLS <lfs_any_t> TYPE any.


  LOOP AT s_email.
    lst_mailrecipients-rec_type = lv_rec_u .
    lst_mailrecipients-receiver  = s_email-low.
    APPEND lst_mailrecipients TO li_mailrecipients.
    CLEAR:lst_mailrecipients.
  ENDLOOP.


  IF s_email[] IS NOT INITIAL.

    CONCATENATE sy-sysid
                    ':'
                    text-028
                    '-'
                    sy-datum
                    sy-uzeit
                    sy-zonlo
               INTO lst_str
               SEPARATED BY space.
    CLEAR  lst_doc_data.

    lst_doc_data-obj_name   = text-029.
    lst_doc_data-obj_descr  = lst_str.
    lst_doc_data-obj_langu  = sy-langu.

    lst_objtxt-line = '<body>'(047).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(045) text-041 '</p>'(046)
                      INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<p style="font-family:arial;font-size:90%;">'(045)
                text-042
                '</p>'(046)
                INTO lst_objtxt-line SEPARATED BY space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.


    lst_objtxt-line = text-043.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR  lst_objtxt.

    lst_objtxt-line = text-044.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR  lst_objtxt.

    lst_objtxt-line = space.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.
*---Body of the EMAIL
    lst_objtxt-line =   '<font color = "BLACK" style="font-family:arial;font-size:95%;">Sincerely,<br/>'(048).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line =   '<font color = "BLACK" style="font-family:arial;font-size:95%;">WILEY SAP Support Team.<br />'(049).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    CONCATENATE '<br><b><i><font color = "BLACK" style="font-family:arial;font-size:100%;">'(050)
                'Note: This email is system generated hence do not reply to this mail.</br></b><i>'(051)
                INTO lst_objtxt-line.
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    lst_objtxt-line = '</body>'(065).
    APPEND lst_objtxt TO li_objtxt.
    CLEAR lst_objtxt.

    DESCRIBE TABLE li_objtxt LINES lv_msg_lines.
    READ TABLE li_objtxt INTO lst_objtxt INDEX lv_msg_lines.
    lst_doc_data-doc_size = ( lv_msg_lines - 1 ) * 255 + strlen( lst_objtxt ).

    lst_objpack-head_start = 1.
    lst_objpack-head_num   = 0.
    lst_objpack-body_start = 1.
    lst_objpack-body_num   = lv_msg_lines.
    lst_objpack-doc_type   = lv_htm.     "Body must be displayed in HTM format
    APPEND lst_objpack TO li_packing_list.
    CLEAR lst_objpack.

    PERFORM f_excel_attachment_rep.

    LOOP AT i_xml_table INTO st_xml.
      CLEAR i_objbin.
      i_objbin-line = st_xml-data.
      APPEND i_objbin.
    ENDLOOP.

    DESCRIBE TABLE i_objbin LINES lv_count.

    lst_objpack-transf_bin  = abap_true.
    lst_objpack-head_start  = 1.
    lst_objpack-head_num    = 0.
    lst_objpack-body_start  = 1.
    lst_objpack-body_num    = lv_count.
    lst_objpack-doc_type    = lv_rec_u ."'XLSX'.  "Type XLS
    lst_objpack-obj_name    = 'data'(031).
    lst_objpack-obj_descr   = 'Transport Log'(030).
    lst_objpack-doc_size    = lv_count * 255. " Total Number of lines * 225

    APPEND lst_objpack TO li_packing_list.
    CLEAR lst_objpack.
*--Sending the Email with Attchment
    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = lst_doc_data
        put_in_outbox              = abap_true
        commit_work                = abap_true
      TABLES
        packing_list               = li_packing_list
        object_header              = li_objhead
        contents_hex               = i_objbin
        contents_txt               = li_objtxt
        receivers                  = li_mailrecipients
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.

    IF sy-subrc = 0.
      cl_os_transaction_end_notifier=>raise_commit_requested( ).
      CALL FUNCTION 'DB_COMMIT'.
      cl_os_transaction_end_notifier=>raise_commit_finished( ).
      MESSAGE text-032 TYPE c_inf.
    ENDIF.
  ENDIF.
ENDFORM.
FORM  f_excel_attachment_rep.

  DATA: lst_fcat    TYPE lvc_s_fcat,
        lv_temp_str TYPE string.

  ##NO_TEXT CONSTANTS:lc_workbook     TYPE string VALUE 'Workbook',
            lc_xmlns        TYPE string VALUE 'xmlns',
            lc_value        TYPE string VALUE 'urn:schemas-microsoft-com:office:spreadsheet',
            lc_excel        TYPE string VALUE 'urn:schemas-microsoft-com:office:excel',
            lc_ss           TYPE string VALUE 'ss',
            lc_x            TYPE string VALUE 'x',
            lc_doc_p        TYPE string VALUE 'DocumentProperties',
            lc_bc_rdwd      TYPE string VALUE 'BC_RDWD',
            lc_author       TYPE string VALUE 'Author',
            lc_styles       TYPE string VALUE 'Styles',
            lc_style        TYPE string VALUE 'Style',
            lc_id           TYPE string VALUE 'ID',
            lc_header       TYPE string VALUE 'Header',
            lc_font         TYPE string VALUE 'Font',
            lc_bold         TYPE string VALUE 'Bold',
            lc_color        TYPE string VALUE 'Color',
            lc_pattern      TYPE string VALUE 'Pattern',
            lc_vertical     TYPE string VALUE 'Vertical',
            lc_wraptext     TYPE string VALUE 'WrapText',
            lc_position     TYPE string VALUE 'Position',
            lc_linestyle    TYPE string VALUE 'LineStyle',
            lc_weight       TYPE string VALUE 'Weight',
            lc_92d050       TYPE string VALUE '#92D050',
            lc_solid        TYPE string VALUE 'Solid',
            lc_center       TYPE string VALUE 'Center',
            lc_bottom       TYPE string VALUE 'Bottom',
            lc_one          TYPE string VALUE '1',
            lc_continuous   TYPE string VALUE 'Continuous',
            lc_left         TYPE string VALUE 'Left',
            lc_right        TYPE string VALUE 'Right',
            lc_top          TYPE string VALUE 'Top',
            lc_border       TYPE string VALUE 'Border',
            lc_borders      TYPE string VALUE 'Borders',
            lc_ffff33       TYPE string VALUE '#FFFF33',
            lc_report       TYPE string VALUE 'Report',
            lc_name         TYPE string VALUE 'Name',
            lc_full_columns TYPE string VALUE 'FullColumns',
            lc_full_rows    TYPE string VALUE 'FullRows',
            lc_width        TYPE string VALUE 'Width',
            lc_column       TYPE string VALUE 'Column',
            lc_row          TYPE string VALUE 'Row',
            lc_autofit_hght TYPE string VALUE 'AutoFitHeight',
            lc_styleid      TYPE string VALUE 'StyleID',
            lc_type         TYPE string VALUE 'Type',
            lc_string       TYPE string VALUE 'String',
            lc_interior     TYPE string VALUE 'Interior',
            lc_alignment    TYPE string VALUE 'Alignment',
            lc_data         TYPE string VALUE 'Data',
            lc_lastrow      TYPE string VALUE 'LastRow',
            lc_worksheet    TYPE string VALUE 'Worksheet',
            lc_table        TYPE string VALUE 'Table',
            lc_90           TYPE string VALUE '90',
            lc_55           TYPE string VALUE '55',
            lc_50           TYPE string VALUE '50',
            lc_70           TYPE string VALUE '70',
            lc_35           TYPE string VALUE '35',
            lc_60           TYPE string VALUE '60',
            lc_40           TYPE string VALUE '40',
            lc_cell         TYPE string VALUE 'Cell'.


* Creating a ixml Factory
  obj_ixml  = cl_ixml=>create( ).

* Creating the DOM Object Model for Excel file
  obj_document = obj_ixml->create_document( ).

* Create Root Node Excel 'Workbook'
  obj_element_root  = obj_document->create_simple_element( name = lc_workbook  parent = obj_document ).
  obj_element_root->set_attribute( name = lc_xmlns  value =  lc_value ).
  obj_ns_attribute = obj_document->create_namespace_decl( name = lc_ss  prefix = lc_xmlns  uri = lc_value  ).
  obj_element_root->set_attribute_node( obj_ns_attribute ).
  obj_ns_attribute = obj_document->create_namespace_decl( name = lc_x  prefix = lc_xmlns  uri = lc_excel ).
  obj_element_root->set_attribute_node( obj_ns_attribute ).

* Create node for document properties.
  obj_element_pro = obj_document->create_simple_element( name = lc_doc_p  parent = obj_element_root ).
  v_value = lc_bc_rdwd.

* Excel file author
  obj_document->create_simple_element( name = lc_author  value = v_value parent = obj_element_pro  ).

* Excel Styles
  obj_styles = obj_document->create_simple_element( name = lc_styles   parent = obj_element_root  ).

* Style, alignment, font and border setting for Header
  obj_style  = obj_document->create_simple_element( name = lc_style   parent = obj_styles  ).
  obj_style->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_header ).
  obj_format  = obj_document->create_simple_element( name = lc_font  parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_bold  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_interior parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_color  prefix = lc_ss value = lc_92d050 ).
  obj_format->set_attribute_ns( name = lc_pattern prefix = lc_ss  value = lc_solid ).
  obj_format  = obj_document->create_simple_element( name = lc_alignment parent = obj_style  ).
  obj_format->set_attribute_ns( name = lc_vertical  prefix = lc_ss  value = lc_center ).
  obj_format->set_attribute_ns( name = lc_wraptext  prefix = lc_ss  value = lc_one ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Style for Data in Excel file
  obj_style1  = obj_document->create_simple_element( name = lc_style parent = obj_styles  ).
  obj_style1->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_data ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style1 ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Style, for LastRow
  obj_style2  = obj_document->create_simple_element( name = lc_style parent = obj_styles  ).
  obj_style2->set_attribute_ns( name = lc_id  prefix = lc_ss  value = lc_lastrow ).
  obj_format  = obj_document->create_simple_element( name = lc_font  parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_bold  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_interior parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_color  prefix = lc_ss  value = lc_ffff33 ).
  obj_format->set_attribute_ns( name = lc_pattern prefix = lc_ss  value = lc_solid ).
  obj_format  = obj_document->create_simple_element( name = lc_alignment parent = obj_style2  ).
  obj_format->set_attribute_ns( name = lc_vertical  prefix = lc_ss  value = lc_center ).
  obj_format->set_attribute_ns( name = lc_wraptext  prefix = lc_ss  value = lc_one ).
  obj_border  = obj_document->create_simple_element( name = lc_borders parent = obj_style2 ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_bottom ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_left ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_top ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).
  obj_format  = obj_document->create_simple_element( name = lc_border parent = obj_border  ).
  obj_format->set_attribute_ns( name = lc_position  prefix = lc_ss  value = lc_right ).
  obj_format->set_attribute_ns( name = lc_linestyle  prefix = lc_ss  value = lc_continuous ).
  obj_format->set_attribute_ns( name = lc_weight  prefix = lc_ss  value = lc_one ).

* Excel Worksheet1 Data.
  obj_worksheet = obj_document->create_simple_element( name = lc_worksheet parent = obj_element_root ).

* Worksheet Name
  obj_worksheet->set_attribute_ns( name = lc_name  prefix = lc_ss  value = lc_report ).

* Table
  obj_table = obj_document->create_simple_element( name = lc_table  parent = obj_worksheet ).
  obj_table->set_attribute_ns( name = lc_full_columns  prefix = lc_x  value = lc_one ).
  obj_table->set_attribute_ns( name = lc_full_rows     prefix = lc_x  value = lc_one ).

* Excel Column Formatting
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " TR
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_90 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " Tr Type
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_70 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " Text
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " User
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1 Date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_35 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_60 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ed2 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_60 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_40 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq2 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_55 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " ep1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " eq3 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1 date
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).
  obj_column = obj_document->create_simple_element( name = lc_column parent = obj_table ).  " es1 time
  obj_column->set_attribute_ns( name = lc_width  prefix = lc_ss  value = lc_50 ).

* Column Headers Row logic
  obj_row = obj_document->create_simple_element( name = lc_row  parent = obj_table ).
  obj_row->set_attribute_ns( name = lc_autofit_hght  prefix = lc_ss value = lc_one ).
*---------------TRANSPORT No----------------
  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-036.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-025.
  obj_data = obj_document->create_simple_element( name = lc_data  value =  v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-037.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
  obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
  v_value = text-038.
  obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
  obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  IF p_ed1 = abap_true.
    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-001.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-011.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-010.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
  IF p_ed2 = abap_true.
    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-002.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-008.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-009.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
  IF p_eq1 = abap_true.
    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-003.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-012.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-013.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
  IF p_eq2 = abap_true.
    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-004.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-014.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-015.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
  IF p_ep1 = abap_true.
    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-006.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-018.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-019.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

  ENDIF.
  IF p_eq3 = abap_true.

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-005.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-016.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-017.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
  IF p_es1 = abap_true.

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-022.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-020.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_header ).
    v_value = text-021.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss value = lc_string ).
  ENDIF.
*----Pass the values to Excel cell
  LOOP AT i_final INTO DATA(lst_final).
    obj_row = obj_document->create_simple_element( name = lc_row  parent = obj_table ).

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-trkorr.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-trtype.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-as4text.
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).          " Data
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).                              " Cell format

    obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
    obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
    v_value = lst_final-as4user .
    obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
    obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    IF p_ed1 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-ed1 = c_green.
        v_value = text-039.
      ELSEIF lst_final-ed1 = c_red.
        v_value = text-040.
      ELSEIF lst_final-ed1 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ed1date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ed1time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_ed2 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-ed2 = c_green.
        v_value = text-039.
      ELSEIF lst_final-ed2 = c_red.
        v_value = text-040.
      ELSEIF lst_final-ed2 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ed2date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ed2time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_eq1 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-eq1 = c_green.
        v_value = text-039.
      ELSEIF lst_final-eq1 = c_red.
        v_value = text-040.
      ELSEIF lst_final-eq1 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq1date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq1time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_eq2 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-eq2 = c_green.
        v_value = text-039.
      ELSEIF lst_final-eq2 = c_red.
        v_value = text-040.
      ELSEIF lst_final-eq2 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq2date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq2time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_ep1 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-ep1 = c_green.
        v_value = text-039.
      ELSEIF lst_final-ep1 = c_red.
        v_value = text-040.
      ELSEIF lst_final-ep1 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ep1date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-ep1time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_eq3 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq3.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-eq3 = c_green.
        v_value = text-039.
      ELSEIF lst_final-eq3 = c_red.
        v_value = text-040.
      ELSEIF lst_final-eq3 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-eq3time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
    IF p_es1 = abap_true.
      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      IF lst_final-es1 = c_green.
        v_value = text-039.
      ELSEIF lst_final-es1 = c_red.
        v_value = text-040.
      ELSEIF lst_final-es1 = space.
        v_value = space.
      ENDIF.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-es1date.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).

      obj_cell = obj_document->create_simple_element( name = lc_cell  parent = obj_row ).
      obj_cell->set_attribute_ns( name = lc_styleid  prefix = lc_ss  value = lc_data ).
      v_value = lst_final-es1time.
      obj_data = obj_document->create_simple_element( name = lc_data  value = v_value  parent = obj_cell ).
      obj_data->set_attribute_ns( name = lc_type  prefix = lc_ss  value = lc_string ).
    ENDIF.
  ENDLOOP.

* Creating a Stream Factory for XML
  obj_streamfactory = obj_ixml->create_stream_factory( ).

* Connect Internal XML Table to Stream Factory for Excel data
  obj_ostream = obj_streamfactory->create_ostream_itable( table = i_xml_table ).

* Rendering the Document
  obj_renderer = obj_ixml->create_renderer( ostream  = obj_ostream  document = obj_document ).
  obj_renderer->render( ).

* Saving the XML Document
  obj_ostream->get_num_written_raw( ).
ENDFORM.
FORM f_excel_download.

  DATA :   lv_fname  TYPE string, "FILE NAME
           lv_fname2 TYPE string, "FILE NAME
           lv_path   TYPE string, "FILE PATH
           lv_fpath  TYPE string. "FULL FILE PATH.
  DATA:lv_count TYPE i VALUE '1'.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog ##SUBRC_OK ##NO_TEXT
    EXPORTING
      default_extension = 'XLS'
      window_title      = 'Save dailog'
    CHANGING
      filename          = lv_fname
      path              = lv_path
      fullpath          = lv_fpath. ##SUBRC_OK ##NO_TEXT
  IF sy-subrc <> 0.                          ##SUBRC_OK ##NO_TEXT
    MESSAGE text-034 TYPE c_e.
  ELSE.
    IF lv_fpath IS NOT INITIAL.
* Start Excel
      CREATE OBJECT v_excel 'EXCEL.APPLICATION'.
      SET PROPERTY OF  v_excel  'Visible' = 0.

      CALL METHOD OF v_excel 'Workbooks' = v_map1.
* add a new workbook
      CALL METHOD OF v_map1 'Add' = v_map.

      CALL METHOD OF v_excel 'Columns' = v_column.
      CALL METHOD OF v_column 'Autofit'.
* output column headings to active Excel sheet
      PERFORM: f_fill_cell USING 1 1 1 text-063 1 8,
               f_fill_cell USING 1 2 1 text-023 1 8,
               f_fill_cell USING 1 3 1 text-064 1 8,
               f_fill_cell USING 1 4 1 text-038 1 8.

      IF p_ed1 = abap_true.
        PERFORM: f_fill_cell USING 1 5 1 text-001 1 8,
                 f_fill_cell USING 1 6 1 text-011 1 8,
                 f_fill_cell USING 1 7 1 text-010 1 8.
      ENDIF.
      IF p_ed2 = abap_true.
        PERFORM: f_fill_cell USING 1 8 1 text-002 1 8,
                 f_fill_cell USING 1 9 1 text-008 1 8,
                 f_fill_cell USING 1 10 1 text-009 1 8.
      ENDIF.
      IF p_eq1 = abap_true.
        PERFORM: f_fill_cell USING 1 11 1 text-003 1 8,
                 f_fill_cell USING 1 12 1 text-012 1 8,
                 f_fill_cell USING 1 13 1 text-013 1 8.
      ENDIF.
      IF p_eq2 = abap_true.
        PERFORM: f_fill_cell USING 1 14 1 text-004 1 8,
                 f_fill_cell USING 1 15 1 text-014 1 8,
                 f_fill_cell USING 1 16 1 text-015 1 8.
      ENDIF.
      IF p_ep1 = abap_true.
        PERFORM:  f_fill_cell USING 1 17 1 text-006 1 8,
                  f_fill_cell USING 1 18 1 text-018 1 8,
                  f_fill_cell USING 1 19 1 text-019 1 8.
      ENDIF.
      IF p_eq3 = abap_true.
        PERFORM:  f_fill_cell USING 1 20 1 text-005 1 8,
                  f_fill_cell USING 1 21 1 text-016 1 8,
                  f_fill_cell USING 1 22 1 text-017 1 8.
      ENDIF.
      IF p_es1 = abap_true.
        PERFORM:  f_fill_cell USING 1 23 1 text-022 1 8,
                  f_fill_cell USING 1 24 1 text-020 1 8,
                  f_fill_cell USING 1 25 1 text-021 1 8.
      ENDIF.

* 2nd Row output column Excel sheet
      LOOP AT i_final INTO DATA(lst_final).
        lv_count = lv_count + 1.

        PERFORM: f_fill_cell USING lv_count 1 0 lst_final-trkorr 1 8,
                 f_fill_cell USING lv_count 2 0 lst_final-trtype 1 8,
        f_fill_cell USING lv_count 3 0 lst_final-as4text 1 8,
        f_fill_cell USING lv_count 4 0 lst_final-as4user 1 8.
        IF p_ed1 = abap_true.
          IF lst_final-ed1 = c_green.
            v_value = text-039.
          ELSEIF lst_final-ed1 = c_red.
            v_value = text-040.
          ELSEIF lst_final-ed1 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 5 0 v_value 1 8,
                  f_fill_cell USING lv_count 6 0 lst_final-ed1date 1 8,
                  f_fill_cell USING lv_count 7 0 lst_final-ed1time 1 8.
        ENDIF.
        IF p_ed2 = abap_true.
          IF lst_final-ed2 = c_green.
            v_value = text-039.
          ELSEIF lst_final-ed2 = c_red.
            v_value = text-040.
          ELSEIF lst_final-ed2 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 8 0 v_value 1 8,
                  f_fill_cell USING lv_count 9 0 lst_final-ed2date 1 8,
                  f_fill_cell USING lv_count 10 0 lst_final-ed2time 1 8.
        ENDIF.
        IF p_eq1 = abap_true.
          IF lst_final-eq1 = c_green.
            v_value = text-039.
          ELSEIF lst_final-eq1 = c_red.
            v_value = text-040.
          ELSEIF lst_final-eq1 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 11 0 v_value 1 8,
                  f_fill_cell USING lv_count 12 0 lst_final-eq1date 1 8,
                  f_fill_cell USING lv_count 13 0 lst_final-eq1time 1 8.
        ENDIF.
        IF p_eq2 = abap_true.
          IF lst_final-eq2 = c_green.
            v_value = text-039.
          ELSEIF lst_final-eq2 = c_red.
            v_value = text-040.
          ELSEIF lst_final-eq2 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 14 0 v_value 1 8,
                  f_fill_cell USING lv_count 15 0 lst_final-eq2date 1 8,
                  f_fill_cell USING lv_count 16 0 lst_final-eq2time 1 8.
        ENDIF.
        IF p_ep1 = abap_true.
          IF lst_final-ep1 = c_green.
            v_value = text-039.
          ELSEIF lst_final-ep1 = c_red.
            v_value = text-040.
          ELSEIF lst_final-ep1 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 17 0 v_value 1 8,
                  f_fill_cell USING lv_count 18 0 lst_final-ep1date 1 8,
                  f_fill_cell USING lv_count 19 0 lst_final-ep1time 1 8.
        ENDIF.
        IF p_eq3 = abap_true.
          IF lst_final-eq3 = c_green.
            v_value = text-039.
          ELSEIF lst_final-eq3 = c_red.
            v_value = text-040.
          ELSEIF lst_final-eq3 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 20 0 v_value 1 8,
                  f_fill_cell USING lv_count 21 0 lst_final-eq3date 1 8,
                  f_fill_cell USING lv_count 22 0 lst_final-eq3time 1 8.
        ENDIF.
        IF p_es1 = abap_true.
          IF lst_final-es1 = c_green.
            v_value = text-039.
          ELSEIF lst_final-es1 = c_red.
            v_value = text-040.
          ELSEIF lst_final-es1 = space.
            v_value = space.
          ENDIF.
          PERFORM:f_fill_cell USING lv_count 23 0 v_value 1 8,
                  f_fill_cell USING lv_count 24 0 lst_final-es1date 1 8,
                  f_fill_cell USING lv_count 25 0 lst_final-es1time 1 8.
        ENDIF.
      ENDLOOP.
      CALL METHOD OF v_excel 'Worksheets' = v_map1.

* Save the Excel file
      GET PROPERTY OF v_excel 'ActiveWorkbook' = v_workbook.
      CALL METHOD OF v_workbook 'SAVEAS'
        EXPORTING
          #1 = lv_fpath
          #2 = 1.

      CALL METHOD OF v_workbook 'Close'.

      CALL METHOD OF v_excel 'Quit'.

      FREE OBJECT:v_workbook, v_excel,v_map1,v_column.
      FREE OBJECT:v_excel,
                  v_map1,
                  v_map,
                  v_workbook,
                  v_zl,
                  v_f.
      IF sy-subrc = 0.
        CONCATENATE text-035 lv_fpath INTO DATA(lv_path_m).
        MESSAGE lv_path_m TYPE c_inf.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_fill_cell USING VALUE(fp_i)
                       VALUE(fp_j)
                       VALUE(fp_bold)
                       VALUE(fp_val)
                       VALUE(fp_color)
                       VALUE(fp_bg).

  DATA:lv_interior TYPE ole2_object,
       lv_borders  TYPE ole2_object.
  DATA: lv_rc TYPE sysubrc.

  CALL METHOD OF v_excel 'Cells' = v_zl EXPORTING #1 = fp_i #2 = fp_j.


  SET PROPERTY OF v_zl 'Value' = fp_val .

  GET PROPERTY OF v_zl 'Font' = v_f.
  SET PROPERTY OF v_zl 'ColumnWidth' = 20.
  SET PROPERTY OF v_f 'Bold' = 0 .

*  SET PROPERTY OF v_f 'COLORINDEX' = fp_color .

  GET PROPERTY OF v_zl 'Interior' = lv_interior .

*  SET PROPERTY OF lv_interior 'ColorIndex' = fp_bg."15.
  SET PROPERTY OF v_zl 'WrapText' = 1.
*left

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '1'.

  SET PROPERTY OF lv_borders 'LineStyle' = '1'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '2'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '3'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '4'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_RFC_TR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_rfc_tr .
  DATA:lst_fin TYPE zqtcr_tr_log_opt_str.
  REFRESH:gt_opt.
  CALL FUNCTION 'ZQTCR_TR_LOG_RFC' DESTINATION c_ed1rfc ""Calling RFC to read the TR log.
    TABLES
      s_trkorr = s_trkorr
      s_des    = s_des
      s_user   = s_user
      s_date   = s_date
      gt_final = gt_opt.
  LOOP AT gt_opt ASSIGNING FIELD-SYMBOL(<fs_opt>).
******Checking if the TR is already available in the final Internal table or not.
******If not then appending the record from the rfc fm to final table.
    READ TABLE i_final INTO lst_fin TRANSPORTING NO FIELDS WITH KEY trkorr = <fs_opt>-trkorr.
    IF sy-subrc NE 0.
      lst_fin = <fs_opt>.
      APPEND lst_fin TO i_final.
      CLEAR:lst_fin.
    ENDIF.
  ENDLOOP.
ENDFORM.
