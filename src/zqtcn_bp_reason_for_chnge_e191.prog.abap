*&---------------------------------------------------------------------*
*&  Include  ZQTCN_BP_REASON_FOR_CHNGE_E191
*&---------------------------------------------------------------------*
  TYPE-POOLS: slis.

  TYPES: BEGIN OF ty_itab,
           text(20),
           cc_sa(10),
           identifier(4),
           chk(1),
         END OF ty_itab.

  DATA:li_ch_text   TYPE catsxt_longtext_itab,      "table to store pop up text
       lst_selfield TYPE slis_selfield,
       lst_fieldcat TYPE slis_fieldcat_alv,
       li_fieldcat  TYPE slis_t_fieldcat_alv,
       lst_layout   TYPE slis_layout_alv,
       li_itab      TYPE TABLE OF ty_itab,
       lv_partner   TYPE bu_partner,
       lv_end_line  TYPE sy-tabix,
       lst_header   TYPE thead,                     "Header for text updation
       lv_tdid      TYPE char4,
       lst_lines    TYPE tline,                     "work area for text lines
       lv_insert    TYPE c,                         "Insert flag
       lv_function  TYPE c,                         "Function: Insert
       lv_date(10)  TYPE c,
       lv_time(8)   TYPE c,
       li_lines     TYPE TABLE OF tline,            "Text lines
       li_sa_data   TYPE cvis_sales_area_info_t,
       li_cc_data   TYPE cvis_cc_info_overview_t,
       li_but000    TYPE TABLE OF but000.

  CONSTANTS: lc_title    TYPE sytitle VALUE 'Reason for Change', "title text
             lc_asterisk TYPE c       VALUE '*',                  "Asterisk(*)
             lc_colon    TYPE c       VALUE ':',                 "Colon(:)
             lc_tdobject TYPE char4  VALUE 'KNA1'.                "Text Object

*Calling FM to have a popup that will allow user to provide reason for change
  CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
    EXPORTING
      im_title        = lc_title
      im_start_column = 25
      im_start_row    = 6
    CHANGING
      ch_text         = li_ch_text.
  "If reason for change is provided
  IF li_ch_text IS NOT INITIAL.
*    lv_partner = cvi_bdt_adapter=>get_current_bp( ).

    CALL FUNCTION 'BUPA_GENERAL_CALLBACK'
      TABLES
        et_but000_new = li_but000.

    lv_partner =  li_but000[ 1 ]-partner.

    IF lv_partner IS NOT INITIAL.
** General Data
      APPEND INITIAL LINE TO li_itab ASSIGNING FIELD-SYMBOL(<lfs_itab>).
      IF <lfs_itab> IS ASSIGNED.
        <lfs_itab>-text = 'General Data'.
        UNASSIGN <lfs_itab>.
      ENDIF.

** Company Code Data
*      SELECT kunnr, bukrs INTO TABLE @DATA(li_cc_data)
*             FROM knb1
*             WHERE kunnr EQ @lv_partner.
*      IF sy-subrc IS INITIAL.
*        SORT li_cc_data[] BY bukrs.
*        LOOP AT li_cc_data INTO DATA(lst_cc_data).
*          APPEND INITIAL LINE TO li_itab ASSIGNING <lfs_itab>.
*          IF <lfs_itab> IS ASSIGNED.
**            <lfs_itab>-text = |Company Code Data| & |-| & |{ lst_cc_data-bukrs }|.
*            <lfs_itab>-text = 'Company Code Data'.
*            <lfs_itab>-cc_sa = lst_cc_data-bukrs.
*            UNASSIGN <lfs_itab>.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.

*      li_cc_data = cvi_bdt_adapter=>get_company_codes( ).
      IMPORT li_cc_data TO li_cc_data FROM MEMORY ID 'BP_BUKRS'.
      FREE MEMORY ID 'BP_BUKRS'.

      SORT li_cc_data[] BY company_code.
      LOOP AT li_cc_data INTO DATA(lst_cc_data).
        DATA(lv_tabix) = sy-tabix.
        APPEND INITIAL LINE TO li_itab ASSIGNING <lfs_itab>.
        IF <lfs_itab> IS ASSIGNED.
          <lfs_itab>-text = 'Company Code'.
          <lfs_itab>-cc_sa = lst_cc_data-company_code.
          <lfs_itab>-identifier = |CC| & |{ lv_tabix }|.
          UNASSIGN <lfs_itab>.
        ENDIF.
      ENDLOOP.

** Sales Area Data
*      SELECT kunnr, vkorg, vtweg, spart INTO TABLE @DATA(li_sa_data)
*                   FROM knvv
*                   WHERE kunnr EQ @lv_partner.
*      IF sy-subrc IS INITIAL.
*        LOOP AT li_sa_data INTO DATA(lst_sa_data).
*          APPEND INITIAL LINE TO li_itab ASSIGNING <lfs_itab>.
*          IF <lfs_itab> IS ASSIGNED.
**            <lfs_itab>-text = |Sales Area Data| & |-| & |{ lst_sa_data-vkorg }| & |/| & |{ lst_sa_data-vtweg }| & |/| & |{ lst_sa_data-spart }|.
*            <lfs_itab>-text = 'Sales Area'.
*            <lfs_itab>-cc_sa = |{ lst_sa_data-vkorg }| & |/| & |{ lst_sa_data-vtweg }| & |/| & |{ lst_sa_data-spart }|.
*            UNASSIGN <lfs_itab>.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.


*      li_sales_areas = cvi_bdt_adapter=>get_sales_areas( ).
      IMPORT li_sa_data TO li_sa_data FROM MEMORY ID 'BP_VKORG'.
      FREE MEMORY ID 'BP_VKORG'.

      LOOP AT li_sa_data INTO DATA(lst_sa).
        lv_tabix = sy-tabix.
        APPEND INITIAL LINE TO li_itab ASSIGNING <lfs_itab>.
        IF <lfs_itab> IS ASSIGNED.
          <lfs_itab>-text = 'Sales Area'.
          <lfs_itab>-cc_sa = |{ lst_sa-sales_org }| & |/| & |{ lst_sa-dist_channel }| & |/| & |{ lst_sa-division }|.
          <lfs_itab>-identifier = |SA| & |{ lv_tabix }|.
          UNASSIGN <lfs_itab>.
        ENDIF.
      ENDLOOP.

    ENDIF.

    DESCRIBE TABLE li_itab LINES lv_end_line.
    lv_end_line = lv_end_line + 7.

    lst_fieldcat-fieldname = 'TEXT'.
*    lst_fieldcat-seltext_l = 'Data Set'.
    lst_fieldcat-outputlen = 20.
    lst_fieldcat-tabname = 'LI_ITAB'.
    lst_fieldcat-col_pos = 1.
    APPEND lst_fieldcat TO li_fieldcat.
    CLEAR lst_fieldcat.

    lst_fieldcat-fieldname = 'CC_SA'.
    lst_fieldcat-outputlen = 10.
    lst_fieldcat-tabname = 'LI_ITAB'.
    lst_fieldcat-col_pos = 2.
    APPEND lst_fieldcat TO li_fieldcat.
    CLEAR lst_fieldcat.

*    lst_fieldcat-fieldname = 'CHK'.
*    lst_fieldcat-tabname = 'LI_ITAB'.
*    lst_fieldcat-col_pos = 2.
*    lst_fieldcat-seltext_l = 'Select'.
*    lst_fieldcat-input = 'X'.
*    lst_fieldcat-edit = 'X'.
*    lst_fieldcat-checkbox = 'X'.
*    APPEND lst_fieldcat TO li_fieldcat.
*    CLEAR lst_fieldcat.

    CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
      EXPORTING
        i_title                 = 'Select Data Changed Area'
*       i_selection             = 'X'
        i_zebra                 = 'X'
        i_screen_start_column   = 27
        i_screen_start_line     = 6
        i_screen_end_column     = 65
        i_screen_end_line       = lv_end_line
        i_checkbox_fieldname    = 'CHK'
        i_tabname               = 'LI_ITAB'
        i_scroll_to_sel_line    = 'X'
        it_fieldcat             = li_fieldcat
        i_callback_program      = sy-repid
        i_callback_user_command = 'USER_COMMAND'
      IMPORTING
        es_selfield             = lst_selfield
      TABLES
        t_outtab                = li_itab
      EXCEPTIONS
        program_error           = 1.

*    IF line_exists( li_itab[ chk = abap_true ] ).
*      lv_tdid = '0005'.
*      "Populate header data for text
*      lst_header-tdid      = lv_tdid.
*      lst_header-tdname    = lv_partner.
*      lst_header-tdspras   = sy-langu.
*      lst_header-tdobject  = lc_tdobject.
*
*      "Calling FM to read the existing text
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = lst_header-tdid
*          language                = lst_header-tdspras
*          name                    = lst_header-tdname
*          object                  = lst_header-tdobject
*        TABLES
*          lines                   = li_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
*      ENDIF.
*
*      IF li_lines[] IS NOT INITIAL.
*        lst_lines-tdformat = lc_asterisk.
*        APPEND lst_lines TO li_lines.
*        CLEAR: lst_lines.
*      ELSE.
*        lv_insert = abap_true.
*      ENDIF.
*
*      "Updating change reason
*      LOOP AT li_ch_text INTO DATA(lst_ch_text).
*        lst_lines-tdformat = lc_asterisk.
*        lst_lines-tdline   = lst_ch_text.
*        APPEND lst_lines TO li_lines.
*        CLEAR: lst_lines.
*      ENDLOOP.
*
*      "Updating User details who is reponsible for the changes made
*      lv_date = |{ sy-datum+6(2) }| & |/| & |{ sy-datum+4(2) }| & |/| & |{ sy-datum+0(4) }| .
*      lv_time = |{ sy-uzeit+0(2) }| & |{ lc_colon }| & |{ sy-uzeit+2(2) }| & |{ lc_colon }| & |{ sy-uzeit+4(2) }| .
*      CONCATENATE sy-uname lc_colon lv_date lv_time INTO DATA(lv_usr_info) SEPARATED BY space.
*      lst_lines-tdformat = lc_asterisk.
*      lst_lines-tdline = lv_usr_info.
*      APPEND lst_lines TO li_lines.
*      CLEAR: lst_lines.
*
*      "Calling FM to save the text
*      CALL FUNCTION 'SAVE_TEXT'
*        EXPORTING
*          client          = sy-mandt
*          header          = lst_header
*          insert          = lv_insert
*          savemode_direct = abap_true
*        IMPORTING
*          function        = lv_function
*          newheader       = lst_header
*        TABLES
*          lines           = li_lines
*        EXCEPTIONS
*          id              = 1
*          language        = 2
*          name            = 3
*          object          = 4
*          OTHERS          = 5.
*      IF sy-subrc = 0.
**              MESSAGE 'Reason for the change was noted' TYPE 'S'.
*      ENDIF. "IF sy-subrc = 0.
*    ENDIF.
  ELSE.
    MESSAGE e276(zqtc_r2).
  ENDIF."IF li_ch_text IS NOT INITIAL.


** Application log
  DATA:li_log         TYPE bal_s_log, " Application Log: Log header data
       lst_log_handle TYPE balloghndl,
       lst_msg        TYPE bal_s_msg, " Application Log: Message Data
       li_log_handle  TYPE bal_t_logh. "Application Log: Log Handle Table

  CONSTANTS:c_bal_obj TYPE balobj_d    VALUE 'ZQTC',     "Application Log: Object Name
            c_bal_sub TYPE balsubobj   VALUE 'ZBP_CUST'. "Application Log: Subobject

  CLEAR li_log-extnumber.

  li_log-object     = c_bal_obj.
  li_log-subobject  = c_bal_sub.
  li_log-aldate     = sy-datum.
  li_log-altime     = sy-uzeit.
  li_log-aluser     = sy-uname.
  li_log-alprog     = sy-repid.

* Define some header data of this log
  li_log-extnumber = lv_partner.
  LOOP AT li_itab INTO DATA(lst_tab) WHERE identifier NE space AND
                                            chk = abap_true.
    CONCATENATE li_log-extnumber lst_tab-identifier
           INTO li_log-extnumber
           SEPARATED BY '/'.
  ENDLOOP.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = li_log
    IMPORTING
      e_log_handle            = lst_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

  LOOP AT li_ch_text INTO DATA(lst_ch_text).
    lst_msg-msgty     = 'I'.
    lst_msg-msgid     = 'ZQTC_R2'.
    lst_msg-msgno     = '000'.
    lst_msg-msgv1 = lst_ch_text+0(50).
    lst_msg-msgv2 = lst_ch_text+50(22).

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = lst_log_handle
        i_s_msg          = lst_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF. " IF sy-subrc <> 0
    CLEAR lst_msg.
  ENDLOOP.

  APPEND lst_log_handle TO li_log_handle.
  CLEAR  lst_log_handle.

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
