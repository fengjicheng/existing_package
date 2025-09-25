*&---------------------------------------------------------------------*
*&  Include           ZQTCR_CLEAR_DIR_R115_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constant_values .
  SELECT devid,                      "Development ID
         param1,                     "ABAP: Name of Variant Variable
         param2,                    "ABAP: Name of Variant Variable
         srno,                       "Current selection number
         sign,                       "ABAP: ID: I/E (include/exclude values)
         opti,                       "ABAP: Selection option (EQ/BT/CP/...)
         low,                        "Lower Value of Selection Condition
         high,                       "Upper Value of Selection Condition
         activate                   "Activation indicator for constant
         FROM zcaconstant           " Wiley Application Constant Table
         INTO TABLE @i_constant
         WHERE devid    = @c_devid
         AND   activate = @abap_true.       "Only active record
  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_BG_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_bg_process .

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status

  CONSTANTS : lc_job_name   TYPE btcjob VALUE 'MICP_CLEANU_R115'. " Background job name

**** Submit Program
  CLEAR : lv_job_name , lv_job_number , v_receiver.
  CONCATENATE lc_job_name '_' sy-datum '_' sy-uzeit INTO lv_job_name.
  v_receiver = sy-uname.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc = 0.
    SUBMIT zqtcr_clear_dir_r115    WITH s_files IN s_files
                                   WITH p_userid = sy-uname
                                   USER  'BC_RDWD'
                                   VIA JOB lv_job_name
                                   NUMBER lv_job_number AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.
    IF sy-subrc = 0.
      MESSAGE 'A Background job is scheduled and email will be sent after deletion'(007) TYPE 'S'.
    ENDIF. " IF sy-subrc = 0
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_DIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_dir .

  DATA: lv_path      TYPE filepath-pathintern,
        lv_dir       TYPE eps2filnam,
        lv_full_path TYPE eps2filnam.

  CONSTANTS: lc_dummy TYPE string VALUE 'dummy',
             lc_logic TYPE rvari_vnam VALUE 'LOGICAL_PATH'.  " Logical Path

* Logical file path
  READ TABLE i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>) WITH KEY param1 = lc_logic BINARY SEARCH.
  IF <lfs_constant> IS ASSIGNED.
    lv_path = <lfs_constant>-low.
  ENDIF.

*--*Read file path from transaction FILE and create complete file path
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = lc_dummy
      eleminate_blanks           = abap_true
    IMPORTING
      file_name_with_path        = lv_dir
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc EQ 0.
    lv_dir = '/intf/zapp/ED2/R115/in/dummy'.
    REPLACE lc_dummy IN lv_dir WITH ''.
      LOOP AT s_files ASSIGNING FIELD-SYMBOL(<lfs_file>).
        CLEAR lv_full_path.
          CONCATENATE lv_dir <lfs_file>-low INTO lv_full_path.
          DELETE DATASET lv_full_path.
          IF sy-subrc <> 0.
            APPEND INITIAL LINE TO i_errfile ASSIGNING FIELD-SYMBOL(<lfs_errf>).
            <lfs_errf>-file = <lfs_file>-low.
          ELSE.
            v_cleared_count = v_cleared_count + 1.
          ENDIF.
        MESSAGE <lfs_file>-low TYPE 'S'.
      ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email .

  DATA: li_objpack  TYPE STANDARD TABLE OF sopcklsti1,
        lst_objpack TYPE sopcklsti1.

  DATA: li_objhead  TYPE STANDARD TABLE OF solisti1,
        lst_objhead TYPE solisti1.

  DATA: li_objtxt  TYPE STANDARD TABLE OF solisti1,
        lst_objtxt TYPE solisti1.

  DATA: li_reclist  TYPE STANDARD TABLE OF somlreci1,
        lst_reclist TYPE somlreci1.

  DATA: lv_doc_chng  TYPE sodocchgi1.
  DATA: lv_tab_lines TYPE sy-tabix.

  DATA : lv_row_count_bg_max TYPE i.

  DATA: lv_file_name TYPE string,
        lv_ext       TYPE char4,
        lv_mail_sub  TYPE string,
        lv_date      TYPE sy-datum,
        lv_time      TYPE sy-uzeit.

  CONSTANTS : lc_x(1)    TYPE c VALUE 'X',
              lc_addtype TYPE soextreci1-adr_typ VALUE 'INT'.

  lv_date = sy-datum.       " System date
  lv_time = sy-uzeit.       " System time

* Mail Subject
  CONCATENATE 'R115 Clear Directory_'(001) lv_date+4(2) lv_date+6(2) lv_date+0(4) lv_time INTO lv_doc_chng-obj_descr.

* Mail Contents
  lst_objtxt = 'Dear User,'(002).
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  " Mail Contents
  SHIFT v_cleared_count LEFT DELETING LEADING ' '.
  CONCATENATE v_cleared_count 'Files Cleared Successfully'(003) INTO lst_objtxt SEPARATED BY space.
  APPEND lst_objtxt TO li_objtxt.

  IF i_errfile IS NOT INITIAL.
    lst_objtxt = 'Errors occured while deleting below Files'(004).
    APPEND lst_objtxt TO li_objtxt.
  ENDIF.
  LOOP AT i_errfile ASSIGNING FIELD-SYMBOL(<lfs_uf>).
    lst_objtxt = <lfs_uf>-file.
    APPEND lst_objtxt TO li_objtxt.
  ENDLOOP.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  lst_objtxt = 'This is a system genarated email – please do not reply to it.'(005).
  APPEND lst_objtxt TO li_objtxt.


  DESCRIBE TABLE li_objtxt LINES lv_tab_lines.
  READ TABLE li_objtxt INTO lst_objtxt INDEX lv_tab_lines.
  lv_doc_chng-doc_size = ( lv_tab_lines - 1 ) * 255 + strlen( lst_objtxt ).

* Packing List For the E-mail Body
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num   = lv_tab_lines.
  lst_objpack-doc_type   = 'RAW'.
  APPEND lst_objpack TO li_objpack.

  lst_objhead = 'Media_Issue_Cockpit_Report_Clear_Directory'(006).
  APPEND lst_objhead TO li_objhead.

* Target Recipent
  CLEAR lst_reclist.
  lst_reclist-receiver = v_receiver.
  lst_reclist-rec_type = 'U'.
  lst_reclist-express = lc_x.
  lst_reclist-com_type = lc_addtype.
  lst_reclist-notif_del = lc_x.
  lst_reclist-notif_ndel = lc_x.
  APPEND lst_reclist TO li_reclist.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lv_doc_chng
      put_in_outbox              = lc_x
      sender_address             = v_sender
      sender_address_type        = lc_addtype
      commit_work                = lc_x
    TABLES
      packing_list               = li_objpack
      object_header              = li_objhead
      contents_txt               = li_objtxt
      receivers                  = li_reclist
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
    MESSAGE 'Mail Sent' TYPE 'S'.
  ELSE.
    MESSAGE 'Mail did not send' TYPE 'S'.
  ENDIF.

  CLEAR: i_errfile, v_cleared_count.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_email .

  " Data declaration for Receiver Email address and BAPI
  DATA : ls_addr TYPE bapiaddr3.
  DATA : li_return TYPE TABLE OF bapiret2.

  FIELD-SYMBOLS : <lfs_const> TYPE ty_constant.

  CONSTANTS : lc_email   TYPE rvari_vnam VALUE 'E_MAIL'.

  FREE : v_sender , v_receiver.
  " Get Sender email adress
  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant ASSIGNING <lfs_const> WITH KEY param1 = lc_email BINARY SEARCH.
    IF sy-subrc = 0.
      v_sender = <lfs_const>-low.      " Set Sender email address
    ENDIF.
  ENDIF.

  v_recname = p_userid.         " GUI username

  "Get recevier email adress.
  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username = v_recname
    IMPORTING
      address  = ls_addr
    TABLES
      return   = li_return.

  "Check return table values
  IF li_return IS NOT INITIAL.
    SORT li_return BY type.
    READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WITH KEY type = c_errtype BINARY SEARCH..
    IF sy-subrc = 0.
      MESSAGE <lfs_return>-message TYPE c_errtype.
      UNASSIGN <lfs_return>.
    ENDIF.
  ENDIF.

  " Set receiver email address
  v_receiver = ls_addr-e_mail.
  FREE ls_addr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DIR_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_dir_list .

  DATA: lv_path      TYPE filepath-pathintern,
        lv_dir       TYPE eps2filnam,
        lv_full_path TYPE eps2filnam.

  CONSTANTS: lc_dummy TYPE string VALUE 'dummy',
             lc_logic TYPE rvari_vnam VALUE 'LOGICAL_PATH'.  " Logical Path

* Logical file path
  READ TABLE i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>) WITH KEY param1 = lc_logic BINARY SEARCH.
  IF <lfs_constant> IS ASSIGNED.
    lv_path = <lfs_constant>-low.
  ENDIF.

*--*Read file path from transaction FILE and create complete file path
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = lc_dummy
      eleminate_blanks           = abap_true
    IMPORTING
      file_name_with_path        = lv_dir
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc EQ 0.
    lv_dir = '/intf/zapp/ED2/R115/in/dummy'.

    REPLACE lc_dummy IN lv_dir WITH ''.

    CALL FUNCTION 'ZQTCCA_EPS2_GET_DIRECTORY_LIST'
      EXPORTING
        iv_dir_name            = lv_dir
*       FILE_MASK              = ' '
*     IMPORTING
*       DIR_NAME               =
*       FILE_COUNTER           =
*       ERROR_COUNTER          =
      TABLES
        dir_list               = i_files
      EXCEPTIONS
        invalid_eps_subdir     = 1
        sapgparam_failed       = 2
        build_directory_failed = 3
        no_authorization       = 4
        read_directory_failed  = 5
        too_many_read_errors   = 6
        empty_directory_list   = 7
        OTHERS                 = 8.
    IF sy-subrc <> 0.
    ENDIF.
    CLEAR: i_alv_output.
    LOOP AT i_files ASSIGNING FIELD-SYMBOL(<lfs_file>).
      APPEND INITIAL LINE TO i_alv_output ASSIGNING FIELD-SYMBOL(<lfs_alv>).
      <lfs_alv>-name = <lfs_file>-name.
      <lfs_alv>-size = <lfs_file>-size.
      <lfs_alv>-mtim = <lfs_file>-mtim.
      <lfs_alv>-owner = <lfs_file>-owner.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_list .

  CLEAR:w_fieldcat,i_fieldcat[].

  PERFORM f_prepare_fcat USING:
            'SEL'   'I_ALV_OUTPUT' text-f05 '1' '1' 'X' 'X' 'X',   "Select
            'NAME'  'I_ALV_OUTPUT' text-f01 '18' '18' '' '' '',    "File Name
            'SIZE'  'I_ALV_OUTPUT' text-f02 '18' '18' '' '' '',    "File Size
            'MTIM'  'I_ALV_OUTPUT' text-f03 '10' '10' '' '' '',    "Time
            'OWNER' 'I_ALV_OUTPUT' text-f04 '6' '6' '' '' ''.      "Owner

  PERFORM f_prepare_layout.

  DATA:
  v_program TYPE sy-repid.
  v_program = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = v_program
      is_layout                = w_layout
      i_callback_user_command  = 'F_HANDLE_USER_COMMAND' "To handle user command
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      it_fieldcat              = i_fieldcat
      i_save                   = 'A'
      is_variant               = st_variant
    TABLES
      t_outtab                 = i_alv_output
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Program Error while display File list'(e01) TYPE 'E'.
      WHEN 2.
        MESSAGE 'Error while display File list'(e02) TYPE 'E'.
    ENDCASE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepare_fcat USING fp_field TYPE any
                            fp_tab   TYPE any
                            fp_text  TYPE any
                            fp_ddout TYPE any
                            fp_outlen TYPE any
                            fp_input TYPE c
                            fp_edit TYPE c
                            fp_checkbox TYPE c.

  w_fieldcat-fieldname      = fp_field.
  w_fieldcat-tabname        = fp_tab.
  w_fieldcat-seltext_l      = fp_text.
  w_fieldcat-lowercase      = abap_true.
  w_fieldcat-ddic_outputlen = fp_ddout.
  w_fieldcat-outputlen      = fp_outlen.
  w_fieldcat-input      = fp_input.
  w_fieldcat-edit = fp_edit.
  w_fieldcat-checkbox      = fp_checkbox.

  APPEND w_fieldcat TO i_fieldcat.
  CLEAR w_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepare_layout .
  w_layout-colwidth_optimize = 'X'.
  w_layout-zebra             = 'X'.
  w_layout-box_fieldname = 'SEL'.
  w_layout-box_tabname = 'I_ALV_OUTPUT'.
ENDFORM.


FORM f_handle_user_command USING r_ucomm     LIKE sy-ucomm
                                 rs_selfield TYPE slis_selfield.
  DATA: lo_grid TYPE REF TO cl_gui_alv_grid.

  IF lo_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = lo_grid.
  ENDIF.

  CASE r_ucomm.
    WHEN '&SEALL'.
      LOOP AT i_alv_output ASSIGNING FIELD-SYMBOL(<lfs_op>).
        <lfs_op>-sel = 'X'.
      ENDLOOP.
      CALL METHOD lo_grid->refresh_table_display.
    WHEN '&DEALL'.
      LOOP AT i_alv_output ASSIGNING <lfs_op>.
        <lfs_op>-sel = ' '.
      ENDLOOP.
      CALL METHOD lo_grid->refresh_table_display.
    WHEN '&PROCESS'.
      CALL METHOD lo_grid->check_changed_data.
      CLEAR: s_files.
      LOOP AT i_alv_output ASSIGNING <lfs_op> WHERE sel = 'X'.
        APPEND INITIAL LINE TO s_files ASSIGNING FIELD-SYMBOL(<lfs_fname>).
        <lfs_fname>-sign = 'I'.
        <lfs_fname>-option = 'EQ'.
        <lfs_fname>-low = <lfs_op>-name.
      ENDLOOP.
      PERFORM f_create_bg_process.
    WHEN '&REFR'.
      PERFORM f_get_dir_list.
      CALL METHOD lo_grid->refresh_table_display.
  ENDCASE.

ENDFORM.

FORM f_set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZPF_STATUS_R115'.
ENDFORM. "Set_pf_status
