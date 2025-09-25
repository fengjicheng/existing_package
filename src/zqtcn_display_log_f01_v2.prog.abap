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
    ELSEIF screen-group1 = c_inp.
*      screen-active = 0.
*      screen-input = 0.

    ELSEIF screen-group1 = 'TRF' AND p_rfit IS NOT INITIAL .
      screen-input = 0.
      screen-active = 0.
      screen-invisible = 1.
    ELSEIF screen-group1 = 'TRF' AND p_rfit IS  INITIAL.
      screen-input = 1.
      screen-active = 1.
      screen-intensified = 0.
    ENDIF.
    IF screen-name = 'P_EDS1' AND p_ed1 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF  screen-name = 'P_EDS1' AND p_ed1 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_ESS1' AND p_es1 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_ESS1' AND p_es1 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_EDS2' AND p_ed2 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_EDS2' AND p_ed2 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_EQS1' AND p_eq1 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_EQS1' AND p_eq1 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_EQS2' AND p_eq2 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_EQS2' AND p_eq2 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_EQS3' AND p_eq3 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_EQS3' AND p_eq3 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_EPS1' AND p_ep1 IS NOT INITIAL.
      screen-input = 1.
      screen-active = 1.
    ELSEIF screen-name = 'P_EPS1' AND p_ep1 IS  INITIAL.
      screen-input = 0.
      screen-active = 0.
    ELSEIF screen-name = 'P_ED1' AND p_rfit IS NOT INITIAL AND sy-ucomm = 'RFIT'..
      screen-input = 0.
      screen-active = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
  IF p_rfit IS NOT INITIAL AND sy-ucomm = 'RFIT'.
    CLEAR:p_ed1,p_ed2,p_eq1,p_eq2,p_eq3,p_ep1,p_es1.
  ELSEIF p_rfit IS INITIAL AND sy-ucomm = 'RFIT'.
    p_ed1 = abap_true.
    p_ed2 = abap_true.
    p_eq1 = abap_true.
    p_eq2 = abap_true.
    p_ep1 = abap_true.
  ENDIF.
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
        lr_events    TYPE REF TO cl_salv_events_table,
        lv_key       TYPE salv_s_layout_key.

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
       lv_es1     TYPE lvc_fname VALUE 'ES1',
       lv_prj     TYPE lvc_fname VALUE 'PROJECT',
       lv_text    TYPE scrtext_m VALUE 'Project',
       lv_stext   TYPE scrtext_s VALUE 'Project',
       lv_ltext   TYPE scrtext_l VALUE 'Project',
       lv_msg     TYPE lvc_fname VALUE 'ZMESSAGE'.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = i_final.
    ##NO_HANDLER    CATCH cx_salv_msg .
  ENDTRY.
  gr_table->set_screen_status(
      pfstatus      =  'ZSALV_STANDARD'
      report        =  sy-repid
*       it_excluding_fcode       = lt_excluding_fcode
      set_functions = gr_table->c_functions_all ).


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
      li_column ?= li_columns->get_column( lv_prj ).
      li_column->set_short_text( lv_stext ).
      li_column->set_long_text( lv_ltext ).
      li_column->set_medium_text( lv_text ).
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
*  OBJ_NAME
  TRY.
      li_column ?= li_columns->get_column( 'OBJ_NAME' ).
      li_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      li_column ?= li_columns->get_column( lv_msg ).
      li_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  lr_functions = gr_table->get_functions( ).

  lr_events = gr_table->get_event( ).
  lr_functions->set_all( abap_true ).

  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.
  SET HANDLER gr_events->on_link_click FOR lr_events.
  gr_layout =  gr_table->get_layout( ).
  lv_key-report = sy-repid.
  gr_layout->set_key( lv_key ).
  gr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).

  gr_table->display( ).
ENDFORM.

FORM f_handle_user_command USING e_salv_function.
  DATA: li_rows  TYPE salv_t_row,
        lc_excel TYPE syst_ucomm VALUE 'EXCEL'.

  CASE sy-ucomm.
    WHEN lc_excel.
*----Excel Download
*      BOC by NPOLINA on 12/13/2021.
*      PERFORM f_excel_download.
      PERFORM f_excel_copy_download.
*      EOC by NPOLINA on 12/13/2021.
*---Refresh the internal table
    WHEN 'REFRESH'.
      FREE:i_final.
      PERFORM get_data_log.
      IF p_ed1 IS NOT INITIAL.  ""Calling ED1 system RFC fm to get the TR status.
        PERFORM call_rfc_tr.
      ENDIF.
      IF i_final IS NOT INITIAL.
        REFRESH:gt_obsel[].
        SORT i_final BY trkorr as4user project pgmid object obj_name.
        DELETE ADJACENT DUPLICATES FROM i_final COMPARING trkorr as4user project pgmid object obj_name.
        gr_table->refresh( ).
      ENDIF.
*----Other Object opening
    WHEN'OTH_OBJ'.
      DATA:g_fcode TYPE char70.
      break vdpataball.
      g_fcode = 'WB_OTHER_OBJECT'.
      PERFORM fcode_process(saplwb_initial_tool) CHANGING g_fcode.
*      FREE:bdcdata.
*      PERFORM bdc_dynpro      USING 'SAPMSSY0' '0120'.
*      PERFORM bdc_field       USING 'BDC_OKCODE'
*                                    '=OKAY'.
*      PERFORM bdc_dynpro      USING 'SAPLWB_INITIAL_TOOL' '0100'.
*      PERFORM bdc_field       USING 'BDC_OKCODE'
*                                    '=WB_OTHER_OBJECT'.
*      PERFORM bdc_dynpro      USING 'SAPLSEWB_CONTROL' '0400'.
*      PERFORM bdc_field       USING 'BDC_CURSOR'
*                                    'G_0400_DATA-SELECTED_OBJECT-OBJ_NAME'.
*      PERFORM bdc_field       USING 'BDC_OKCODE'
*                                    '=DISPEDIT'.
*      PERFORM bdc_field       USING 'G_0400_DATA-USE_QUICKSEARCH'
*                                    'X'.
*      PERFORM bdc_field       USING 'G_0400_DATA-SELECTED_OBJECT-OBJ_NAME'
*                                    ' '.
*      REFRESH messtab.
*      CALL TRANSACTION 'SPROXY' USING bdcdata
*                       MODE   'A'
*                       UPDATE  'A'
*                       MESSAGES INTO messtab.
**    CALL TRANSACTION 'ZTESTTT'.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF fval <> nodata.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.
FORM  show_cell_info  USING i_row    TYPE i
                          i_column TYPE lvc_fname.

  DATA:lst_row     TYPE char128,
       lv_dir_type TYPE tstrf01-dirtype  VALUE 'T',
       lt_note     TYPE TABLE OF txw_note,
       lt_note1    TYPE TABLE OF txw_note,
       ls_note     TYPE txw_note,
       lv_str      TYPE string,
       lv_txtmsg   TYPE text255,
       lv_msg_text TYPE string.

  WRITE       i_row TO lst_row LEFT-JUSTIFIED.

  READ TABLE i_final INTO DATA(lst_final) INDEX i_row."lst_row.
  IF sy-subrc = 0.
    CASE i_column.
      WHEN c_object.
        IF lst_final-object = 'TABL'
          OR lst_final-object = 'TABU'
          OR lst_final-object = 'VDAT'
          OR lst_final-object = 'CDAT'
          OR lst_final-object = 'VDAT'
          OR lst_final-object = 'DTEL'
          OR lst_final-object = 'VDAT'
          OR lst_final-object = 'TDAT'.
          SET PARAMETER ID 'DTB' FIELD lst_final-obj_name.
          CALL TRANSACTION 'SE11' AND SKIP FIRST SCREEN.
        ELSEIF lst_final-object = 'CLAS'.
          SET PARAMETER ID 'CLASS' FIELD lst_final-obj_name.
          CALL TRANSACTION 'SE24' AND SKIP FIRST SCREEN.
        ELSEIF lst_final-object = 'REPS'
          OR lst_final-object = 'XPRA'
          OR lst_final-object = 'PROG'
          OR lst_final-object = 'REPT'.
          SET PARAMETER ID 'RID' FIELD lst_final-obj_name.
          CALL TRANSACTION 'SE38' AND SKIP FIRST SCREEN.
        ELSEIF lst_final-object = 'SPRX'.
*          SET PARAMETER ID 'DTYP' FIELD lst_final-obj_name.
*          CALL TRANSACTION 'SE11' AND SKIP FIRST SCREEN.
        ELSEIF lst_final-object = 'TABL'.
        ELSEIF lst_final-object = 'TABL'.
        ELSEIF lst_final-object = 'TABL'.
        ENDIF.
      WHEN c_trkorr.
*--DIsplay TR LOG Overview screen with Tree Report
        IF lst_final-trstatus = 'R'.
          CALL FUNCTION 'TR_LOG_OVERVIEW_REQUEST_REMOTE'
            EXPORTING
              iv_trkorr  = lst_final-trkorr
              iv_dirtype = lv_dir_type.
        ELSE.
          CALL FUNCTION 'TR_PRESENT_REQUEST'
            EXPORTING
              iv_trkorr = lst_final-trkorr.
        ENDIF.
      WHEN c_msg.
        REFRESH:lt_note[].
        DATA: li_log_handle     TYPE bal_t_logh,  " Application Log: Log Handle Table
              v_log_handle      TYPE balloghndl, " Application Log: Log Handle.
              lflg_exit         TYPE xchar,     " Exit Flag
              lv_msg_log_handle TYPE balmsghndl,  " Application Log: Message handle
              lst_msg           TYPE bal_s_msg,   " Application Log: Message Data
              lv_ans            TYPE char1,
              li_log_numbers    TYPE bal_t_lgnm.
        CLEAR:v_log_handle,li_log_handle[],lv_str,lv_ans.

        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar       = text-p17
            text_question  = text-p16
            text_button_1  = text-p18
            text_button_2  = text-p19
          IMPORTING
            answer         = lv_ans
          EXCEPTIONS
            text_not_found = 1
            OTHERS         = 2.
        IF sy-subrc = 0 AND lv_ans NE 'A'.
          v_log_handle = lst_final-zmessage.
          IF v_log_handle IS NOT INITIAL.
            APPEND v_log_handle TO li_log_handle.

            CALL FUNCTION 'BAL_DB_LOAD'
              EXPORTING
                i_t_log_handle     = li_log_handle
              EXCEPTIONS
                no_logs_specified  = 1
                log_not_found      = 2
                log_already_loaded = 3
                OTHERS             = 4.
            IF sy-subrc <> 0.
              MESSAGE i000(00) WITH 'Enter a Valid Log Handle'.
              EXIT.
            ENDIF.
            CLEAR:lv_msg_log_handle.
            REFRESH:lt_note1.
            CONCATENATE 'Previous Log Number#'v_log_handle INTO ls_note-line SEPARATED BY space.
            APPEND ls_note TO lt_note1.
            CLEAR:ls_note.
            WHILE lflg_exit IS INITIAL.
              CLEAR:lst_msg.
              lv_msg_log_handle-log_handle = v_log_handle.
              lv_msg_log_handle-msgnumber  = lv_msg_log_handle-msgnumber + 1 .

              CALL FUNCTION 'BAL_LOG_MSG_READ'
                EXPORTING
                  i_s_msg_handle = lv_msg_log_handle
                IMPORTING
                  e_s_msg        = lst_msg
                EXCEPTIONS
                  log_not_found  = 1
                  msg_not_found  = 2
                  OTHERS         = 3.
              IF sy-subrc <> 0.
                lflg_exit = abap_true.
              ELSEIF sy-subrc = 0.
                CLEAR:lv_msg_text.
                CONCATENATE lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4
                            INTO lv_msg_text.
                ls_note-line = lv_msg_text.
                IF lv_msg_text CS 'Previous Log Number'.
                  APPEND ls_note TO lt_note1.
                ELSE.
                  APPEND ls_note TO lt_note.
                ENDIF.
                CLEAR:ls_note.
              ENDIF.
            ENDWHILE.
          ENDIF.
          IF lv_ans =  1.
            APPEND LINES OF lt_note1 TO lt_note.
            CALL FUNCTION 'TXW_TEXTNOTE_EDIT'
              EXPORTING
                edit_mode = space
              TABLES
                t_txwnote = lt_note.
          ELSEIF lv_ans = 2.
*            REFRESH:lt_note[].
            CALL FUNCTION 'TXW_TEXTNOTE_EDIT'
              EXPORTING
                edit_mode = abap_true
              TABLES
                t_txwnote = lt_note.
            IF lt_note[] IS NOT INITIAL.
              APPEND LINES OF lt_note1 TO lt_note.
              DATA:ls_log    TYPE bal_s_log.
*                   ls_update TYPE zca_tr_log.
              CONSTANTS:c_obj  TYPE char3 VALUE 'ZCA',
                        c_sobj TYPE char6 VALUE  'ZCA_TR'.
*              CLEAR:v_log_handle,ls_log,ls_update.
              ls_log-extnumber = lst_final-trkorr.
              ls_log-object    = c_obj.
              ls_log-subobject = c_sobj.
              ls_log-aldate    = sy-datum.
              ls_log-altime    = sy-uzeit.
              ls_log-aluser    = sy-uname.
              ls_log-alprog    = sy-repid.
              CALL FUNCTION 'BAL_LOG_CREATE'
                EXPORTING
                  i_s_log                 = ls_log
                IMPORTING
                  e_log_handle            = v_log_handle
                EXCEPTIONS
                  log_header_inconsistent = 1
                  OTHERS                  = 2.
              IF sy-subrc = 0.
                REFRESH:li_log_handle.
                APPEND v_log_handle TO li_log_handle.
                LOOP AT lt_note INTO ls_note.
                  CLEAR:lv_txtmsg.
                  lv_txtmsg = ls_note-line.
                  CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
                    EXPORTING
                      i_log_handle     = v_log_handle
                      i_msgty          = 'S'
                      i_probclass      = ''
                      i_text           = lv_txtmsg
                    EXCEPTIONS
                      log_not_found    = 1
                      msg_inconsistent = 2
                      log_is_full      = 3
                      OTHERS           = 4.
                  IF sy-subrc <> 0.
                    MESSAGE i000(00) WITH 'Error while Updating Message'.
                    EXIT.
                  ENDIF.
                ENDLOOP.
* save logs in the database
                CALL FUNCTION 'BAL_DB_SAVE'
                  EXPORTING
                    i_save_all       = abap_true
                    i_t_log_handle   = li_log_handle     " Application Log: Log Handle
                  IMPORTING
                    e_new_lognumbers = li_log_numbers
                  EXCEPTIONS
                    log_not_found    = 1
                    save_not_allowed = 2
                    numbering_error  = 3
                    OTHERS           = 4.
                IF sy-subrc NE 0.
                ELSEIF sy-subrc = 0.
*                  ls_update-zrequest         = lst_final-trkorr.
*                  ls_update-log_num         = v_log_handle.
*                  ls_update-zmessage          = li_log_numbers[ 1 ]-lognumber.
*                  ls_update-zdate            = sy-datum.
*                  ls_update-ztime            = sy-uzeit.
*                  ls_update-zuname           = sy-uname.
*                  ls_update-dependency_tr    = lst_final-dependency_tr.
*                  ls_update-dependency_cr    = lst_final-dependency_cr.
*                  ls_update-cr_check         = lst_final-cr_check.
*                  ls_update-incident_check   = lst_final-incident_check.
*                  ls_update-incident_no      = lst_final-incident_no.
*                  ls_update-retrofit_check   = lst_final-retrofit_check.
*                  MODIFY zca_tr_log FROM ls_update.
*                  IF sy-subrc = 0.
*                    COMMIT WORK.
*                  ENDIF.
                ENDIF.
              ENDIF.
*              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
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
*    lst_final       TYPE ty_final,
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
    lst_objpack-doc_type    = lv_xls  .  "Type XLS
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
      v_value = lst_final-eq3date.
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

  DATA : lv_fname  TYPE string, "FILE NAME
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
  IF p_rfit IS NOT INITIAL.
    REFRESH:lt_des[],lt_date[],lt_user[],lt_tr[].
    lt_des[] = lt_rdes[].
    DELETE ADJACENT DUPLICATES FROM lt_des COMPARING ALL FIELDS.
  ENDIF.
  CALL FUNCTION 'ZQTCR_TR_LOG_RFC_V2' DESTINATION c_ed1rfc ""Calling RFC to read the TR log.
    EXPORTING
      p_ed1           = p_ed1
      p_ed2           = p_ed2
      p_eq1           = p_eq1
      p_eq2           = p_eq2
      p_eq3           = p_eq3
      p_ep1           = p_ep1
      p_es1           = p_es1
      p_eds1          = p_eds1
      p_eds2          = p_eds2
      p_eqs1          = p_eqs1
      p_eqs2          = p_eqs2
      p_eqs3          = p_eqs3
      p_eps1          = p_eps1
      p_ess1          = p_ess1
      p_rfit          = p_rfit
    TABLES
      s_trkorr        = lt_tr
      s_des           = lt_des
      s_user          = lt_user
      s_date          = lt_date
      s_inc           = lt_inc
      gt_final        = gt_opt
      gt_obsel        = gt_obsel
      gt_object_texts = gt_object_texts
    EXCEPTIONS
      rfc_error       = 1
      OTHERS          = 2.
  IF gt_opt[] IS NOT INITIAL.
    SORT gt_opt BY pgmid.
    DELETE gt_opt WHERE pgmid = 'CORR'.
*    APPEND LINES OF gt_opt TO i_final.
    DATA(li_final_t) = i_final.
    LOOP AT gt_opt INTO gs_opt.
      READ TABLE li_final_t INTO lst_fin WITH KEY trkorr = gs_opt-trkorr.
      IF sy-subrc NE 0.
        MOVE-CORRESPONDING gs_opt TO lst_fin.
        APPEND lst_fin TO i_final.
      ENDIF.
    ENDLOOP.
    FREE:li_final_t.
  ENDIF.

  IF p_rfit IS NOT INITIAL.
    LOOP AT i_final INTO lst_fin.
      READ TABLE gt_opt INTO gs_opt WITH KEY pgmid = lst_fin-pgmid
                                             object = lst_fin-object.
      IF sy-subrc NE 0.
        lst_opt-trkorr = lst_fin-trkorr.
        lst_opt-as4text = lst_fin-as4text.
        lst_opt-as4user = lst_fin-as4user.
        lst_opt-pgmid = lst_fin-pgmid.
        lst_opt-object = lst_fin-object.
        lst_opt-obj_name = lst_fin-obj_name.
        lst_opt-obj_txt = lst_fin-obj_txt.
        APPEND lst_opt TO  i_opt.
        CLEAR:lst_opt.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialization .

  s_trkorr-sign = c_i.
  s_trkorr-option = c_cp.
  s_trkorr-low = c_eds.
  APPEND s_trkorr.

  p_objtxa = '?'.
  p_objtxb = '?'.
  p_objtxc = '?'.

  gs_list-key = c_o.
  gs_list-text = c_otxt.
  APPEND gs_list TO gt_list.
  CLEAR:gs_list.

  gs_list-key = c_r.
  gs_list-text = c_rtxt.
  APPEND gs_list TO gt_list.
  CLEAR:gs_list.

  gs_list-key = c_i.
  gs_list-text = c_itxt.
  APPEND gs_list TO gt_list.
  CLEAR:gs_list.

  gs_list-key = c_e.
  gs_list-text = c_etxt.
  APPEND gs_list TO gt_list.
  CLEAR:gs_list.

  PERFORM get_list_values USING 'P_EDS1'.
  PERFORM get_list_values USING 'P_EDS2'.
  PERFORM get_list_values USING 'P_EQS1'.
  PERFORM get_list_values USING 'P_EQS2'.
  PERFORM get_list_values USING 'P_EPS1'.
  PERFORM get_list_values USING 'P_EQS3'.
  PERFORM get_list_values USING 'P_ESS1'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SELECTION_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM selection_screen .
  IF p_check1 IS NOT INITIAL AND p_objn1 IS INITIAL.
    MESSAGE text-m01 TYPE 'S' .
    EXIT.
  ELSEIF p_check1 IS NOT INITIAL AND p_objn1 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm1 p_obj1 p_objn1.
  ENDIF.

  IF p_check2 IS NOT INITIAL AND p_objn2 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check2 IS NOT INITIAL AND p_objn2 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm2 p_obj2 p_objn2.
  ENDIF.

  IF p_check3 IS NOT INITIAL AND p_objn3 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check3 IS NOT INITIAL AND p_objn3 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm1 p_obj3 p_objn3.
  ENDIF.

  IF p_check4 IS NOT INITIAL AND p_objn4 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check4 IS NOT INITIAL AND p_objn4 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm4 p_obj4 p_objn4.
  ENDIF.

  IF p_check5 IS NOT INITIAL AND p_objn5 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check5 IS NOT INITIAL AND p_objn5 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm5 p_obj5 p_objn5.
  ENDIF.

  IF p_check6 IS NOT INITIAL AND p_objn6 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check6 IS NOT INITIAL AND p_objn6 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm6 p_obj6 p_objn6.
  ENDIF.

  IF p_check7 IS NOT INITIAL AND p_objn7 IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_check7 IS NOT INITIAL AND p_objn7 IS NOT INITIAL.
    PERFORM objects_validation USING p_pgm7 p_obj7 p_objn7.
  ENDIF.

  IF p_checka IS NOT INITIAL AND p_objna IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_checka IS NOT INITIAL AND p_objna IS NOT INITIAL.
    PERFORM objects_validation USING p_pgmida p_objta p_objna.
  ENDIF.

  IF p_checkb IS NOT INITIAL AND p_objnb IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_checkb IS NOT INITIAL AND p_objnb IS NOT INITIAL.
    PERFORM objects_validation USING p_pgmidb p_objtb p_objnb.
  ENDIF.

  IF p_checkc IS NOT INITIAL AND p_objnc IS INITIAL.
    MESSAGE text-m01 TYPE 'S'.
    EXIT.
  ELSEIF p_checkc IS NOT INITIAL AND p_objnc IS NOT INITIAL.
    PERFORM objects_validation USING p_pgmidc p_objtc p_objnc.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_OBJECT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_OBJECT_TEXTS  text
*----------------------------------------------------------------------*
FORM read_object_table    TABLES pt_object_texts STRUCTURE ko100.
  DATA: lv_lines       TYPE i.

  DESCRIBE TABLE pt_object_texts LINES lv_lines.
  IF lv_lines < 1.
    CALL FUNCTION 'TR_OBJECT_TABLE'
      TABLES
        wt_object_text = pt_object_texts.

    DELETE pt_object_texts WHERE pgmid <> 'R3TR'
                             AND pgmid <> 'R3OB'
                             AND pgmid <> 'LIMU'
                             AND pgmid <> 'CORR'.

    SORT pt_object_texts BY pgmid object.
  ENDIF.

ENDFORM.                               " READ_OBJECT_TABLE
*&---------------------------------------------------------------------*
*&      Form  AT_SELECTION_SCREEN_ON_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0076   text
*----------------------------------------------------------------------*
FORM at_selection_screen_on_field      USING pv_field TYPE c.

  DATA: ls_object_text       LIKE ko100.

  CASE pv_field.
    WHEN 'OBJECTA'.
      CASE p_objta.
        WHEN space.
          CLEAR: p_checka, p_pgmida, p_objtxa, p_objna.
          p_objtxa = '?'.
        WHEN OTHERS.
          READ TABLE gt_object_texts INTO ls_object_text
                                   WITH KEY object = p_objta.
          IF sy-subrc <> 0.
            MESSAGE e870(tk).
          ELSE.
            p_pgmida   = ls_object_text-pgmid.
            p_objtxa = ls_object_text-text.
            p_checka = abap_true.
          ENDIF.
      ENDCASE.

    WHEN 'OBJECTB'.
      CASE p_objtb.
        WHEN space.
          CLEAR: p_checkb, p_pgmidb, p_objtxb, p_objnb.
          p_objtxb = '?'.
        WHEN OTHERS.
          READ TABLE gt_object_texts INTO ls_object_text
                                   WITH KEY object = p_objtb.
          IF sy-subrc <> 0.
            MESSAGE e870(tk).
          ELSE.
            p_pgmidb   = ls_object_text-pgmid.
            p_objtb = ls_object_text-text.
            p_checkb = abap_true.
          ENDIF.
      ENDCASE.

    WHEN 'OBJECTC'.
      CASE p_objtc.
        WHEN space.
          CLEAR: p_checkc, p_pgmidc, p_objtxc, p_objnc.
          p_objtxc = '?'.
        WHEN OTHERS.
          READ TABLE gt_object_texts INTO ls_object_text
                                   WITH KEY object = p_objtc.
          IF sy-subrc <> 0.
            MESSAGE e870(tk).
          ELSE.
            p_pgmidc   = ls_object_text-pgmid.
            p_objtxc = ls_object_text-text.
            p_checkc = abap_true.
          ENDIF.
      ENDCASE.

  ENDCASE.
ENDFORM.                               " AT_SELECTION_SCREEN_ON_FIELD
*&---------------------------------------------------------------------*
*&      Form  OBJECTS_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PGM1  text
*      -->P_P_OBJ1  text
*      -->P_P_OBJN1  text
*----------------------------------------------------------------------*
FORM objects_validation  USING    p_p_pgm1
                                  p_p_obj1
                                  p_p_objn1.
  DATA:lv_msg TYPE string.
  SELECT SINGLE COUNT(*) FROM tadir WHERE obj_name = p_p_objn1.
*     pgmid = p_p_pgm1
*                                    AND   object = p_p_obj1
*                                    AND   obj_name = p_p_objn1.
  IF sy-subrc NE 0.
    CLEAR:lv_msg.
    CONCATENATE text-m02 p_p_objn1 INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg  TYPE 'E' DISPLAY LIKE 'S'.
    EXIT.
  ELSEIF sy-subrc = 0.
    gs_obsel-pgmid = p_p_pgm1.
    gs_obsel-object = p_p_obj1.
    gs_obsel-obj_name = p_p_objn1.
    APPEND gs_obsel TO gt_obsel.
    CLEAR:gs_obsel.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  REFRESH:gt_e070[],gt_e071[].
  IF gt_obsel[] IS NOT INITIAL.
    SELECT * FROM e071 INTO TABLE @gt_e071
             FOR ALL ENTRIES IN @gt_obsel
             WHERE trkorr IN @s_trkorr
             AND pgmid      = @gt_obsel-pgmid
             AND object     = @gt_obsel-object
             AND obj_name   = @gt_obsel-obj_name.
    IF sy-subrc = 0 AND s_des[] IS NOT INITIAL.
      SELECT *
        FROM e07t
        INTO TABLE @DATA(lt_e07t)
      WHERE as4text IN @s_des.
      IF lt_e07t IS NOT INITIAL.
*----User maintain the description then Join the Two table E07t and E070 Table using For ALL Entries
        SELECT *
              FROM e070
              INTO TABLE @gt_e070
              FOR ALL ENTRIES IN @lt_e07t
              WHERE ( trkorr = @lt_e07t-trkorr OR strkorr = @lt_e07t-trkorr )
                AND as4user IN @s_user
                AND as4date IN @s_date.
      ENDIF.
    ELSEIF sy-subrc = 0 AND s_des[] IS INITIAL.
*---If User Not maintain the Description then Fecth fron Table E070
      SELECT *
        FROM e070
        INTO TABLE gt_e070
        FOR ALL ENTRIES IN gt_e071
        WHERE ( trkorr = gt_e071-trkorr OR strkorr = gt_e071-trkorr )
          AND as4user IN s_user
          AND as4date IN s_date.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_LIST_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_EDS  text
*----------------------------------------------------------------------*
FORM get_list_values  USING    p_p_eds.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = p_p_eds
      values          = gt_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_log .
  REFRESH:lt_date[],lt_tr[],lt_des[],lt_user[],lt_inc[],lt_rdes[].
  LOOP AT s_inc.
    lst_inc-sign   = s_inc-sign.
    lst_inc-option = s_inc-option.
    lst_inc-low    = s_inc-low.
    lst_inc-high   = s_inc-high.
    APPEND lst_inc TO lt_inc.
    CLEAR:lst_inc.
  ENDLOOP.


  LOOP AT s_date.
    lst_date-sign   = s_date-sign.
    lst_date-option = s_date-option.
    lst_date-low    = s_date-low.
    lst_date-high   = s_date-high.
    APPEND lst_date TO lt_date.
    CLEAR:lst_date.
  ENDLOOP.

  LOOP AT s_trkorr.
    lst_tr-sign   = s_trkorr-sign.
    lst_tr-option = s_trkorr-option.
    lst_tr-low    = s_trkorr-low.
    lst_tr-high   = s_trkorr-high.
    APPEND lst_tr TO lt_tr.
    CLEAR:lst_tr.
  ENDLOOP.

  LOOP AT s_des.
    lst_des-sign    = s_des-sign.
    lst_des-option  = s_des-option.
    lst_des-low     = s_des-low.
    lst_des-high    = s_des-high.
    APPEND lst_des TO lt_des.
    CLEAR:lst_des.
  ENDLOOP.

  LOOP AT s_user.
    lst_user-sign    = s_user-sign.
    lst_user-option  = s_user-option.
    lst_user-low     = s_user-low.
    lst_user-high    = s_user-high.
    APPEND lst_user TO lt_user.
    CLEAR:lst_user.
  ENDLOOP.

  CALL FUNCTION 'ZQTCR_TR_LOG_RFC_V2'
    EXPORTING
      p_ed1           = p_ed1
      p_ed2           = p_ed2
      p_eq1           = p_eq1
      p_eq2           = p_eq2
      p_eq3           = p_eq3
      p_ep1           = p_ep1
      p_es1           = p_es1
      p_eds1          = p_eds1
      p_eds2          = p_eds2
      p_eqs1          = p_eqs1
      p_eqs2          = p_eqs2
      p_eqs3          = p_eqs3
      p_eps1          = p_eps1
      p_ess1          = p_ess1
      p_rfit          = p_rfit
    TABLES
      s_trkorr        = lt_tr
      s_des           = lt_des
      s_user          = lt_user
      s_date          = lt_date
      s_inc           = lt_inc
      gt_final        = i_final
      gt_obsel        = gt_obsel
      gt_ilog         = gt_ilog
      gt_rdes         = lt_rdes
      gt_object_texts = gt_object_texts.
  IF i_final IS NOT INITIAL.
    SORT i_final BY pgmid.
    DELETE i_final WHERE pgmid = 'CORR'.
    SORT i_final BY trkorr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_RFIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_rfit .
  REFRESH:i_fcat.
  DATA:lst_layout TYPE slis_layout_alv.
  PERFORM fcat USING:'TRKORR'    'Transport Request',
                     'AS4TEXT'   'Transport Description',
                     'AS4USER'   'User ID',
                     'PGMID'     'Program ID',
                     'OBJECT'    'Object ID',
                     'OBJ_NAME'  'Object Name',
                     'OBJ_NAME'  'Object Text'.
  IF i_opt IS NOT INITIAL.
    PERFORM send_email.
    lst_layout-colwidth_optimize = abap_true.
    lst_layout-zebra = abap_true.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        it_fieldcat   = i_fcat
        is_layout     = lst_layout
      TABLES
        t_outtab      = i_opt
      EXCEPTIONS
        program_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_9430   text
*      -->P_9431   text
*----------------------------------------------------------------------*
FORM fcat  USING    p_9430
                    p_9431.
  lst_fcat-fieldname = p_9430.
  lst_fcat-seltext_m = p_9431.
  APPEND lst_fcat TO i_fcat.
  CLEAR:lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_email .
  TYPES: BEGIN OF ty_email,
           bname      TYPE usr21-bname,
           persnumber TYPE usr21-persnumber,
           addrnumber TYPE usr21-addrnumber,
           smtp_addr  TYPE adr6-smtp_addr,
           smtp_srch  TYPE adr6-smtp_srch,
         END OF ty_email.

  CONSTANTS:gc_tab  TYPE c VALUE cl_bcs_convert=>gc_tab,
            gc_crlf TYPE c VALUE cl_bcs_convert=>gc_crlf.

  DATA:lt_sopt   TYPE TABLE OF ty_opt,
       lst_sopt  TYPE ty_opt,
       lt_email  TYPE TABLE OF ty_email,
       lst_email TYPE ty_email,
       lv_string TYPE string.

  lt_sopt[] = i_opt[].
  SORT lt_sopt BY as4user.
  DELETE ADJACENT DUPLICATES FROM lt_sopt COMPARING as4user.
  IF lt_sopt IS NOT INITIAL.
    SELECT a~bname
           a~persnumber
           a~addrnumber
           b~smtp_addr
           b~smtp_srch
           INTO TABLE lt_email
           FROM usr21 AS a INNER JOIN adr6 AS b ON a~addrnumber = b~addrnumber AND
                                                   a~persnumber = b~persnumber
           FOR ALL ENTRIES IN lt_sopt
           WHERE bname = lt_sopt-as4user.
  ENDIF.
  DATA:ls_text         TYPE so_text255,
       lt_text         TYPE bcsy_text,
       lv_send_request TYPE REF TO cl_bcs,
       lv_sender       TYPE REF TO cl_cam_address_bcs,
       lv_recipient    TYPE REF TO if_recipient_bcs,
       lv_mailid       TYPE ad_smtpadr,
       lt_bin_con      TYPE solix_tab,
       lv_size         TYPE so_obj_len,
       lv_sub          TYPE so_obj_des,
       lv_attnam       TYPE sood-objdes,
       lv_document     TYPE REF TO cl_document_bcs,
       lv_all          TYPE os_boolean,
       bcs_exception   TYPE REF TO cx_bcs,
       lv_xls          TYPE so_obj_tp  VALUE 'XLS',
       lv_htm          TYPE so_obj_tp  VALUE 'HTM'.


  CLEAR:ls_text,lv_string,lv_size,lv_sub,lv_attnam,lv_document,lv_all.
  REFRESH:lt_text,lt_bin_con.
  LOOP AT lt_sopt INTO lst_sopt.
    CLEAR:lv_string.
    CONCATENATE 'Object ID'      gc_tab
                'Object Name'    gc_tab
                'Object Text'    gc_tab
                'TR Description' gc_crlf INTO lv_string.
    LOOP AT i_opt INTO lst_opt WHERE as4user = lst_sopt-as4user.
      CONCATENATE lv_string lst_opt-object   gc_tab
                            lst_opt-obj_name gc_tab
                            lst_opt-obj_txt  gc_tab
                            lst_opt-as4text  gc_crlf INTO lv_string.

    ENDLOOP.
    CHECK lv_string IS NOT INITIAL.
    READ TABLE lt_email INTO lst_email WITH KEY bname = lst_sopt-as4user.
    CHECK sy-subrc = 0.
    CLEAR:ls_text.
    REFRESH:lt_text.
    CONCATENATE 'Dear'(068) lst_sopt-as4user INTO ls_text SEPARATED BY space.
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    ls_text = '<br><br>'(069).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    ls_text = 'Please find the attached sheet with pending objects need to be Retrofit in the ED2 system'(070).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    ls_text = '<br><br>'(069).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    ls_text = 'Thanks!'(071).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.


    ls_text = '<br><br>'(069).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    ls_text = 'Wiley Technical Team'(072).
    APPEND ls_text TO lt_text.
    CLEAR:ls_text.

    TRY.
        lv_send_request = cl_bcs=>create_persistent( ).
        CLEAR:lv_sender.

        CALL METHOD cl_cam_address_bcs=>create_internet_address
          EXPORTING
            i_address_string = 'no-reply@wiley.com'
            i_address_name   = 'SAP Technical Team'
          RECEIVING
            result           = lv_sender.

        CALL METHOD lv_send_request->set_sender
          EXPORTING
            i_sender = lv_sender.

        lv_mailid = lst_email-smtp_addr.
        CLEAR:lv_recipient,lt_bin_con..
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
            MESSAGE 'Error when transfering document contents'(073) TYPE c_e.
        ENDTRY.
        lv_sub = 'Objects Need to be Retrofit in ED2'(074).
        lv_document = cl_document_bcs=>create_document(
          i_type    = lv_htm
          i_text    = lt_text
          i_subject =  lv_sub ) .

        lv_attnam = 'Pending Retrofit Objects.'(075).

        lv_document->add_attachment(
          i_attachment_type    = lv_xls
          i_attachment_subject = lv_attnam
          i_attachment_size    = lv_size
          i_att_content_hex    = lt_bin_con ).

        lv_send_request->set_document( lv_document ).


        lv_all = lv_send_request->send( i_with_error_screen = 'X' ).

        COMMIT WORK.

        IF  lv_all IS INITIAL.
          MESSAGE 'document not sent'(076) TYPE c_e.
        ELSE.
          MESSAGE 'document sent sucessfully'(077) TYPE c_s.
        ENDIF.

      CATCH cx_bcs INTO bcs_exception.
        FREE : lv_document,lv_send_request,lv_recipient.
    ENDTRY.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISABLE_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM disable_screen .
  LOOP AT SCREEN.
    IF screen-group1 = 'TRF' AND p_rfit IS NOT INITIAL .
      screen-input = 0.
      screen-active = 0.
      screen-invisible = 1.
    ELSEIF screen-group1 = 'TRF' AND p_rfit IS  INITIAL.
      screen-input = 1.
      screen-active = 1.
      screen-intensified = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
* BOC by NPOLINA on 12/13/2021.
FORM f_excel_copy_download.

  TYPES: BEGIN OF ty_tab,
           fieldname(30) TYPE c,
         END OF ty_tab.

  TYPES: BEGIN OF ty_final,
           trkorr   TYPE trkorr,
           trtype   TYPE c LENGTH 10,
           as4text  TYPE as4text,
           as4user  TYPE tr_as4user,
           ed1      TYPE icon_d,
           ed1_date TYPE as4date,
           ed1_time TYPE as4time,
           ed2      TYPE icon_d,
           ed2_date TYPE as4date,
           ed2_time TYPE as4time,
           eq1      TYPE icon_d,
           eq1_date TYPE as4date,
           eq1_time TYPE as4time,
           eq2      TYPE icon_d,
           eq2_date TYPE as4date,
           eq2_time TYPE as4time,
           ep1      TYPE icon_d,
           ep1_date TYPE as4date,
           ep1_time TYPE as4time,
           eq3      TYPE icon_d,
           eq3_date TYPE as4date,
           eq3_time TYPE as4time,
           es1      TYPE icon_d,
           es1_date TYPE as4date,
           es1_time TYPE as4time,
         END OF ty_final.

  DATA: lt_fin  TYPE STANDARD TABLE OF ty_final,
        lw_fin  TYPE ty_final,
        i_field TYPE STANDARD TABLE OF ty_tab WITH HEADER LINE.

  DATA : lv_fname  TYPE string, "FILE NAME
         lv_fname2 TYPE string, "FILE NAME
         lv_path   TYPE string, "FILE PATH
         lv_fpath  TYPE string. "FULL FILE PATH.

  DATA:lv_count TYPE i VALUE '1'.

  LOOP AT i_final INTO DATA(lw_final).
    MOVE-CORRESPONDING lw_final TO lw_fin.

    IF p_ed1 = abap_true.
      IF lw_final-ed1 = c_green.
        lw_fin-ed1 = text-039.
      ELSEIF lw_final-ed1 = c_red.
        lw_fin-ed1 = text-040.
      ELSEIF lw_final-ed1 = space.
        lw_fin-ed1 = space.
      ENDIF.
      lw_fin-ed1_date = lw_final-ed1date.
      lw_fin-ed1_time = lw_final-ed1time.
    ENDIF.

    IF p_ed2 = abap_true.
      IF lw_final-ed2 = c_green.
        lw_fin-ed2 = text-039.
      ELSEIF lw_final-ed2 = c_red.
        lw_fin-ed2 = text-040.
      ELSEIF lw_final-ed2 = space.
        lw_fin-ed2 = space.
      ENDIF.
      lw_fin-ed2_date = lw_final-ed2date.
      lw_fin-ed2_time = lw_final-ed2time.
    ENDIF.

    IF p_eq1 = abap_true.
      IF lw_final-eq1 = c_green.
        lw_fin-eq1 = text-039.
      ELSEIF lw_final-eq1 = c_red.
        lw_fin-eq1 = text-040.
      ELSEIF lw_final-eq1 = space.
        lw_fin-eq1 = space.
      ENDIF.
      lw_fin-eq1_date = lw_final-eq1date.
      lw_fin-eq1_time = lw_final-eq1time.
    ENDIF.

    IF p_eq2 = abap_true.
      IF lw_final-eq2 = c_green.
        lw_fin-eq2 = text-039.
      ELSEIF lw_final-eq2 = c_red.
        lw_fin-eq2 = text-040.
      ELSEIF lw_final-eq2 = space.
        lw_fin-eq2 = space.
      ENDIF.
      lw_fin-eq2_date = lw_final-eq2date.
      lw_fin-eq2_time = lw_final-eq2time.
    ENDIF.

    IF p_ep1 = abap_true.
      IF lw_final-ep1 = c_green.
        lw_fin-ep1 = text-039.
      ELSEIF lw_final-ep1 = c_red.
        lw_fin-ep1 = text-040.
      ELSEIF lw_final-ep1 = space.
        lw_fin-ep1 = space.
      ENDIF.
      lw_fin-ep1_date = lw_final-ep1date.
      lw_fin-ep1_time = lw_final-ep1time.
    ENDIF.

    IF p_eq3 = abap_true.
      IF lw_final-eq3 = c_green.
        lw_fin-eq3 = text-039.
      ELSEIF lw_final-eq3 = c_red.
        lw_fin-eq3 = text-040.
      ELSEIF lw_final-eq3 = space.
        lw_fin-eq3 = space.
      ENDIF.
      lw_fin-eq3_date = lw_final-eq3date.
      lw_fin-eq3_time = lw_final-eq3time.
    ENDIF.

     IF p_es1 = abap_true.
      IF lw_final-es1 = c_green.
        lw_fin-es1 = text-039.
      ELSEIF lw_final-es1 = c_red.
        lw_fin-es1 = text-040.
      ELSEIF lw_final-es1 = space.
        lw_fin-es1 = space.
      ENDIF.
      lw_fin-es1_date = lw_final-es1date.
      lw_fin-es1_time = lw_final-es1time.
    ENDIF.

    APPEND lw_fin TO lt_fin.
    CLEAR lw_fin.
  ENDLOOP.

  REFRESH:i_field.
  CLEAR:i_field.
  i_field-fieldname = 'Transport Number'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'Transport Type'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'TR Description'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'TR Owner'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED1'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED1-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED1-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED2'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED2-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ED2-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ1'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ1-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ1-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ2'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ2-Date'.
  APPEND i_field.
  CLEAR i_field.
  i_field-fieldname = 'EQ2-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EP1'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EP1-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EP1-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ3'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ3-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'EQ3-Time'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ES1'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ES1-Date'.
  APPEND i_field.
  CLEAR i_field.

  i_field-fieldname = 'ES1-Time'.
  APPEND i_field.
  CLEAR i_field.

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
      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          filename              = lv_fpath
          filetype              = 'ASC'
          write_field_separator = 'X'
        TABLES
          data_tab              = lt_fin
          fieldnames            = i_field.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*EOC by NPOLINA on 12/13/2021.
