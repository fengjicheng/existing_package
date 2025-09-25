*&---------------------------------------------------------------------*
*&  Include           ZTR_VALIDATION_REPORT_FRM
*&---------------------------------------------------------------------*

FORM  rfc_validation.
  FREE:gv_rfcdest.
  SELECT SINGLE rfcdest FROM rfcdes
                       INTO gv_rfcdest
                       WHERE rfctype = '3'
  AND  rfcdest IN s_dest .
  IF sy-subrc <> 0.
    MESSAGE 'Please check the RFC Destination Name' TYPE  'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TR_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM tr_validation .
  SELECT *
      FROM e070v
      INTO TABLE gt_e070v
      WHERE trkorr IN s_req
      AND trstatus IN s_stat
      AND as4user IN s_user
      AND  as4date IN s_date
    AND as4text IN s_des.
  IF sy-subrc NE 0.
    MESSAGE 'There are no Transport Requests available for selected criteria' TYPE 'E'.
  ENDIF.
ENDFORM.

FORM display_salv.
 DATA lw_final TYPE gty_final.
  LOOP AT gt_outtab INTO DATA(lw_outtab).
    MOVE-CORRESPONDING lw_outtab TO lw_final.
    APPEND lw_final TO t_final.
  ENDLOOP.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = t_final ).
    CATCH cx_salv_msg.                                  "#EC NO_HANDLER
  ENDTRY.
ENDFORM.
*  lo_alv->display( ).

FORM set_top_of_page CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string,                              "#EC NEEDED
         lv_rows  TYPE char05.


  lo_head = 'Transaport Management Tool'.

  CREATE OBJECT lo_grid.
*  *--Header of Top of Page **
  lo_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lo_head
                                      tooltip = lo_head ).

  lo_grid1 = lo_grid->create_grid( row = 2
                                  column = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row =  2 "3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'User:'
                                    tooltip = 'User:' ).

  lo_text = lo_flow->create_text( text = sy-uname
                                  tooltip = sy-uname ).

*--Second row
  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'System:'
                                    tooltip = 'System:' ).

  lo_text = lo_flow->create_text( text = sy-sysid
                                  tooltip = sy-sysid ).


  lo_flow = lo_grid1->create_flow( row = 4 column = 1 ). "2 ).
  lo_label = lo_flow->create_label( text =  'Client:'
                                    tooltip =  'Client:' ).

  lo_text = lo_flow->create_text( text = sy-mandt
                                  tooltip = sy-mandt ).

  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).

  lo_label = lo_flow->create_label( text = 'Date:'
                                    tooltip = 'Date:' ).

  lo_text = lo_flow->create_text( text = sy-datum
                                  tooltip = sy-datum ).


  lo_flow = lo_grid1->create_flow( row = 6 column = 1 )."4 column = 2 ).

  lo_label = lo_flow->create_label( text = 'Time:'
                                    tooltip = 'Time:' ).

  lo_text = lo_flow->create_text( text = sy-uzeit
                                  tooltip = sy-uzeit ).
*--Set Top of List
  co_alv->set_top_of_list( lo_grid ).
ENDFORM.

FORM display CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA:" lo_alv  TYPE REF TO cl_salv_table,
        lo_sort TYPE REF TO cl_salv_sorts.

*... §3 Functions
  DATA: lr_functions        TYPE REF TO cl_salv_functions_list,
        lr_display_settings TYPE REF TO cl_salv_display_settings,
        lo_aggrs            TYPE REF TO cl_salv_aggregations.

  lo_aggrs = lo_alv->get_aggregations( ).

  lr_functions = lo_alv->get_functions( ).
  lr_display_settings = lo_alv->get_display_settings( ).

*... §3.1 activate ALV generic Functions
  lr_functions->set_all( abap_true ).

  lr_display_settings->set_striped_pattern( abap_true ).

*... set the columns technical
  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
        lr_column  TYPE REF TO cl_salv_column_table.

  lr_columns = lo_alv->get_columns( ).
  lo_sort    = lo_alv->get_sorts( ).

  lr_column ?= lr_columns->get_column( 'LIGHT' ).
  lr_column->set_short_text( 'Status' ).  "Will cause syntax error if text is too long
  lr_column->set_medium_text( 'Status' ).
  lr_column ?= lr_columns->get_column( 'OBJ_TYPE' ).
  lr_column ?= lr_columns->get_column( 'OBJ_NAME' ).
  lr_column ?= lr_columns->get_column( 'SUB_TYPE' ).
  lr_column ?= lr_columns->get_column( 'SUB_NAME' ).
  lr_column ?= lr_columns->get_column( 'PGMID' ).
  lr_column ?= lr_columns->get_column( 'OBJACTION' ).
  lr_column ?= lr_columns->get_column( 'COMP_USER' ).
  lr_column ?= lr_columns->get_column( 'COMP_DATUM' ).
  lr_column ?= lr_columns->get_column( 'COMP_TIME' ).
  lr_columns->set_optimize( abap_true ).

  lo_alv->display( ).
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SET_GS_OUTTAB_NONVERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_NONVERS  text
*      <--P_GS_OUTTAB  text
*----------------------------------------------------------------------*
FORM set_gs_outtab_nonvers  USING    ps_nonvers TYPE e071
                            CHANGING ps_outtab  TYPE g_outtab.
  DATA: ls_tadir TYPE tadir.

  CALL FUNCTION 'TR_CHECK_TYPE'
    EXPORTING
      wi_e071  = ps_nonvers
    IMPORTING
      we_tadir = ls_tadir.

*& get more field
  SELECT SINGLE * FROM tadir INTO ls_tadir
                             WHERE pgmid  = ls_tadir-pgmid
                             AND   object = ls_tadir-object
  AND obj_name = ls_tadir-obj_name.

  ps_outtab-comp_user =  ls_tadir-author.
  ps_outtab-obj_type  =  ls_tadir-object.
  ps_outtab-obj_name  =  ls_tadir-obj_name.
  ps_outtab-pgmid     =  ps_nonvers-pgmid.
  ps_outtab-sub_type  =  ps_nonvers-object.
  ps_outtab-sub_name  =  ps_nonvers-obj_name.
  ps_outtab-diagnosis =  gc_objects_unknown.
  ps_outtab-comp_datum = sy-datum.
  ps_outtab-comp_time  = sy-uzeit .
  ps_outtab-light      = gc_light_yellow  .
  ps_outtab-objaction  = text-005 . "Vergleichtool nicht verfügbar
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  COMP_OBJECTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM comp_objects .
IF gt_e070v IS NOT INITIAL.

    CALL FUNCTION 'SCTS_COMP_REPOS_GET_PAKET'
      DESTINATION gv_rfcdest
      EXPORTING
        iv_paket  = 'SCTS_COMP_SYS'
      EXCEPTIONS
        no_object = 1
        OTHERS    = 2.
    IF sy-subrc = 1 .
      RAISE packet_not_in_sys2 .
    ELSEIF sy-subrc = 2.
      RAISE no_authority_dest2.
    ENDIF.

*    IF s_req IS INITIAL. " If the user does not fill the TR field
    LOOP AT gt_e070v INTO gs_e070v.
      CALL FUNCTION 'COMP_REPOS_GET_REQOBJ'
        DESTINATION lv_dest1
        EXPORTING
          iv_trkorr = gs_e070v-trkorr
          iv_dest   = lv_dest1
        TABLES
          et_obj    = lt_e071_tem
        EXCEPTIONS
          no_object = 1
          OTHERS    = 2.
      IF sy-subrc <>    0.
        RAISE req_not_in_sys1 .
      ENDIF.
      CLEAR gs_e070v.
    ENDLOOP.

    CALL FUNCTION 'COMP_REPOS_GET_REQOBJ'
      DESTINATION gv_rfcdest
      EXPORTING
        iv_trkorr        = gs_e070v-trkorr
        iv_dest          = gv_rfcdest
      TABLES
        et_obj           = lt_e071_tem2
        et_obj_local     = lt_e071_tem
      EXCEPTIONS
        no_request       = 1
        no_authorization = 2
        OTHERS           = 3.
    IF sy-subrc = 1.
      RAISE req_not_in_sys1.
    ELSEIF sy-subrc = 2.
      RAISE no_authority_dest2.
    ELSEIF sy-subrc = 3.
      RAISE comunication_failure_dest2.
    ENDIF.

    CALL FUNCTION 'SCTS_COMP_REPOS_BULID_INTERSEC'
      IMPORTING
        ev_both12     = sy-dbcnt
      TABLES
        et_obj_1      = lt_e071_tem
        et_obj_2      = lt_e071_tem2
        et_obj_only1  = et_only1
        et_obj_only2  = et_only2
        et_obj_both12 = lt_e071_both.

*& no 'comm' object.
    DELETE   lt_e071_both  WHERE object = 'COMM' OR  object = 'AVAS'.

    CALL FUNCTION 'RFC_SYSTEM_INFO'
      DESTINATION gv_rfcdest
      IMPORTING
        rfcsi_export          = ls_rfcsi_export
      EXCEPTIONS
        system_failure        = 1
        communication_failure = 2.

    lv_targetsystem = ls_rfcsi_export-rfcsysid.

*& now gt_e071_12_sel contains all objects to be version compared
*& new method shows only objects which are versionable in at least one system

    CALL FUNCTION 'SVRS_MASSCOMPARE_ACT_OBJECTS'
      EXPORTING
        it_e071                = lt_e071_both
        iv_rfcdest_b           = gv_rfcdest
        iv_filter_lang         = 'X'
        iv_delete_lang         = ' '
      IMPORTING
        et_compare_items       = lt_compare_items
        es_rfcsi_a             = ls_rfcsi_a
        es_rfcsi_b             = ls_rfcsi_b
        et_nonversionable_e071 = lt_nonvers
      EXCEPTIONS
        rfc_error              = 1
        not_supported          = 2
        OTHERS                 = 3.

    CASE sy-subrc.
      WHEN 0.
      WHEN 1.
        MESSAGE i008(tsys) WITH lv_dest.
      WHEN OTHERS.
        MESSAGE i015(tsys).
    ENDCASE.

    LOOP AT lt_compare_items INTO ls_compare_item.
      CLEAR: gs_outtab, ls_vrso.
      ev_diagnosis = gc_objects_unknown.

      ls_vrso-objtype = ls_compare_item-fragment.
      ls_vrso-objname = ls_compare_item-fragname.

      IF ls_compare_item-equal EQ 'X'.
        ev_diagnosis = gc_objects_equal.
      ELSE.
        IF ls_compare_item-nonversionable EQ 'X'.
          CONTINUE.
        ELSEIF ls_compare_item-not_readable EQ 'X'. " rfc error, inconsistent, etc.
          ev_diagnosis = gc_objects_exception.
        ELSEIF  ls_compare_item-not_comparable EQ 'X'. " only one version, different languages while filtering.
          IF ls_compare_item-versno_a IS INITIAL AND ls_compare_item-versno_b IS INITIAL.
            ev_diagnosis = gc_noversion12.
          ELSEIF ls_compare_item-versno_a IS NOT INITIAL AND ls_compare_item-versno_b IS INITIAL.
            ev_diagnosis = gc_noversion2.
          ELSEIF ls_compare_item-versno_a IS INITIAL AND ls_compare_item-versno_b IS NOT INITIAL.
            ev_diagnosis = gc_noversion1.
          ELSE.
            ev_diagnosis = gc_objects_exception.
          ENDIF.
        ELSE.
          ev_diagnosis = gc_objects_not_equal.
        ENDIF.
      ENDIF.
      PERFORM set_gs_outtab_sub USING  ls_vrso
                                       ls_compare_item
                                       ev_diagnosis
                                       ev_diff_info
                            CHANGING gs_outtab.
      APPEND  gs_outtab  TO gt_outtab .
    ENDLOOP.

* Add the nonversionable objects into the list, if wanted
    IF lv_show_nonvers = 'X'.
      LOOP AT lt_nonvers INTO ls_nonvers.
        IF lv_show_docus = 'X' OR
         ( ls_nonvers-object NE 'DOCU' AND ls_nonvers-object NE 'DOCV' AND
           ls_nonvers-object NE 'DOCT' AND ls_nonvers-object NE 'DSYS' ).
          PERFORM set_gs_outtab_nonvers USING ls_nonvers
                                        CHANGING gs_outtab.
          APPEND gs_outtab TO gt_outtab.
        ENDIF.
      ENDLOOP.
    ENDIF.

    gv_num_total  = 0.
    gv_num_unequal = 0.
    gv_num_unkown = 0.

    DESCRIBE TABLE  gt_outtab LINES gv_num_total.
    LOOP AT gt_outtab INTO ls_outtab_sts.
      IF ls_outtab_sts-light =  gc_light_red .
        gv_num_unequal = gv_num_unequal + 1 .
      ELSEIF ls_outtab_sts-light = gc_light_yellow .
        gv_num_unkown = gv_num_unkown + 1.
      ELSE.
      ENDIF.
    ENDLOOP.
* convert to character.
    gv_num_total_c  = gv_num_total .
    gv_num_unequal_c  =   gv_num_unequal .
    gv_num_unkown_c  =  gv_num_unkown .

  ENDIF.
ENDFORM.

**&---------------------------------------------------------------------*
**&      Form  SET_GS_OUTTAB_SUB
**&---------------------------------------------------------------------*
**       text
*----------------------------------------------------------------------*
*      -->P_LS_VRSO  text
*      -->P_LS_COMPARE_ITEM  text
*      -->P_EV_DIAGNOSIS  text
*      -->P_EV_DIFF_INFO  text
*      <--P_GS_OUTTAB  text
*----------------------------------------------------------------------*
FORM set_gs_outtab_sub  USING VALUE(ls_vrso) TYPE vrso
                            VALUE(ls_compare_item) TYPE vrs_compare_item
                            VALUE(ev_diagnosis) TYPE i
                            VALUE(ev_diff_info) TYPE c
                      CHANGING gs_outtab TYPE g_outtab .

  DATA: no_version1(50)   TYPE c,
        no_version2(50)   TYPE c,
        no_version12(50)  TYPE c,
        ls_e071_tmpftadir TYPE e071,
        ls_tadir          TYPE tadir,
        ls_tdevc          TYPE tdevc,
        ls_es_type        TYPE ko100,
        ls_e071           TYPE e071,
        ls_objh           TYPE objh.

*& info about pgmid is lost when object E071 is converted to vrso object
*&  get pgmid  again.
  ls_e071-object =  ls_vrso-objtype.
  CALL FUNCTION 'TR_GET_PGMID_FOR_OBJECT'
    EXPORTING
      iv_object      = ls_e071-object
    IMPORTING
      es_type        = ls_es_type
    EXCEPTIONS
      illegal_object = 1
      OTHERS         = 2.
  gs_outtab-pgmid = ls_es_type-pgmid.

*& get main programm name and responsible person.
  ls_e071_tmpftadir-pgmid = gs_outtab-pgmid .
  ls_e071_tmpftadir-object = ls_vrso-objtype.
  ls_e071_tmpftadir-obj_name = ls_vrso-objname.

*& logical object pgmid = R3TR
  IF ls_vrso-objtype = 'CDAT' OR ls_vrso-objtype = 'TDAT'
     OR  ls_vrso-objtype = 'VDAT'.
    gs_outtab-pgmid =  'R3TR'.
  ENDIF.

*& logical transport object pgmid = R3TR.
  SELECT SINGLE  * FROM objh INTO ls_objh WHERE objectname =
  ls_vrso-objtype.
  IF sy-subrc = 0.
    gs_outtab-pgmid =  'R3TR'.
  ENDIF.

*& reponsible for the package.
  IF ls_compare_item-object IS INITIAL.
    CALL FUNCTION 'TR_CHECK_TYPE'
      EXPORTING
        wi_e071  = ls_e071_tmpftadir
      IMPORTING
        we_tadir = ls_tadir.
  ELSE.
    ls_tadir-pgmid = ls_compare_item-pgmid.
    ls_tadir-object = ls_compare_item-object.
    ls_tadir-obj_name = ls_compare_item-obj_name.
  ENDIF.
*& get more field
  SELECT SINGLE * FROM tadir INTO ls_tadir
                             WHERE pgmid  = ls_tadir-pgmid
                             AND   object = ls_tadir-object
  AND obj_name = ls_tadir-obj_name.

  gs_outtab-comp_user = ls_tadir-author.
  gs_outtab-obj_type  =  ls_tadir-object.
  gs_outtab-obj_name  =  ls_tadir-obj_name .
  gs_outtab-sub_type  =  ls_vrso-objtype .
  gs_outtab-sub_name  =  ls_vrso-objname .
  gs_outtab-sys1      =  sy-sysid.
  gs_outtab-sys2      =  lv_targetsystem .
  gs_outtab-diagnosis = ev_diagnosis .
  gs_outtab-comp_datum =  sy-datum .
  gs_outtab-comp_time = sy-uzeit .
  gs_outtab-notice =   ev_diff_info.

*& ------- light for display ----------
*& version equal
  IF ev_diagnosis =  gc_objects_equal  .
    gs_outtab-light = gc_light_green .
    gs_outtab-objaction = text-002 .  " Gleich
*& not equal
  ELSEIF ev_diagnosis = gc_objects_not_equal .
    gs_outtab-light = gc_light_red  .
    gs_outtab-objaction =  text-003 . " Ungleich

*& both no version
  ELSEIF  ev_diagnosis = gc_noversion12  .
    gs_outtab-light =  gc_light_yellow .
    CONCATENATE  text-004 sy-sysid lv_targetsystem INTO no_version12
           SEPARATED BY  space.
    gs_outtab-objaction = no_version12. "Keine Version12

*& no version local
  ELSEIF ev_diagnosis =  gc_noversion1 .
    gs_outtab-light =  gc_light_yellow   .
    CONCATENATE  text-004  sy-sysid  INTO no_version1
       SEPARATED BY  space .
    gs_outtab-objaction = no_version1 . "Keine Version L.

*& no version remote
  ELSEIF ev_diagnosis = gc_noversion2 .
    gs_outtab-light =  gc_light_yellow .
    CONCATENATE  text-004 lv_targetsystem  INTO no_version2
       SEPARATED BY  space.
    gs_outtab-objaction = no_version2 . " Keine Version R.

*& object unknown or compare method not available.
  ELSEIF ev_diagnosis = gc_objects_unknown  .
    gs_outtab-light = gc_light_yellow  .
    gs_outtab-objaction =  text-005 . "Vergleichtool nicht verfügbar
*& objecttreated as  exception.
  ELSEIF ev_diagnosis =   gc_objects_exception.
    gs_outtab-light = gc_light_yellow .
    gs_outtab-objaction =  text-006 . "Ausnamen bei Einlesen Objekt'

*& objecttreated as  exception.
  ELSEIF ev_diagnosis =  gc_obj_db_click.
    gs_outtab-light = gc_light_yellow .
    gs_outtab-objaction =  text-007 . "Double click'

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_EMAIL_BODY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_email_body .
* Email logic*******************************************************************
*- Populate message body text
  DELETE gt_outtab WHERE light NE '1'.

    CLEAR i_message.
    REFRESH i_message.
    st_imessage =      text-009. "Dear User,
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.

* Populate the body based on the data available

    st_imessage = text-010. "Please Find the Below TR's which are required to retrofit.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.

    CLEAR : gs_outtab,gs_e071_tem.
    LOOP AT gt_outtab INTO gs_outtab.
      READ TABLE lt_e071_tem2 INTO gs_e071 WITH KEY obj_name = gs_outtab-sub_name.

      IF sy-subrc EQ 0.
        CONCATENATE gs_outtab-obj_name
                    gs_outtab-comp_user
                    gs_e071-trkorr INTO st_imessage SEPARATED BY space.

        APPEND st_imessage TO i_message.
        CLEAR st_imessage.
        CONCATENATE gs_outtab-comp_user '@wiley.com' INTO g_receiver.
        CLEAR i_receivers.
        i_receivers-receiver   = g_receiver.
        i_receivers-rec_type   = c_u.
        i_receivers-com_type   = c_int. " INT
        i_receivers-notif_del  = c_x.
        i_receivers-notif_ndel = c_x.
        APPEND i_receivers.
        CLEAR g_receiver.
      ENDIF.
      CLEAR : gs_outtab,gs_e071.
    ENDLOOP.

    st_imessage = text-011. "** Please do not reply to this email, as we are unable to respond from this address
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_LINES  text
*----------------------------------------------------------------------*
FORM send_email.
  DATA: lst_xdocdata             LIKE sodocchgi1,
        lv_file_name             TYPE char100,
        lst_usr21                TYPE usr21,
        lst_adr6                 TYPE adr6,
        lv_p_mail                LIKE LINE OF s_email,
        lv_total                 TYPE n.

* Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw. " RAW
  APPEND i_packing_list.

  IF s_email IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT s_email INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver   = s_email-low.
      i_receivers-rec_type   = c_u.
      i_receivers-com_type   = c_int. " INT
      i_receivers-notif_del  = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ENDIF.

  DELETE ADJACENT DUPLICATES FROM i_receivers COMPARING receiver.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
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
  IF sy-subrc NE 0.
    MESSAGE text-012 TYPE c_i."Error in sending Email
  ELSE.
    MESSAGE text-013 TYPE c_s. "Email sent with Success log file
  ENDIF.
ENDFORM.
