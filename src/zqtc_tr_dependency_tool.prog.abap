*&---------------------------------------------------------------------*
*& Report  ZQTC_TR_DEPENDENCY_TOOL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZQTC_TR_DEPENDENCY_TOOL NO STANDARD PAGE HEADING
  LINE-SIZE 256
  LINE-COUNT 65.


*----------------------------------------------------------------------*
* Date              : 09/09/2014
* Author            : SAPYard
* Title             : Validates Transport Dependency
*----------------------------------------------------------------------*
* Category          : Utility
* Run Frequency     : On Demand
* Development Class : Custom
* Company           : SAPYard.com
*----------------------------------------------------------------------*
* Transport Sequence Validator - This tool is used for checking the
* sequence of the Transports which are supposed to be imported to
* SAP Production System.
* It checks if a transports has already been moved & should not be imported
* It checks for dependent Transports which should be moved ahead of
* the transport you are planning to import to Production and Show error
*----------------------------------------------------------------------*
* Change History
* ---------------------------------------------------------------------*
* Author        Date        Request#    Description
* ------------  --------    ----------  ---------------------------------
* SAPYard       09/09/2014  SY20110423  New Tool created
*----------------------------------------------------------------------*
*REPORT zsy_t_guard_dependency_valid

*--------------------------------------------------------------------*
* TABLES
*--------------------------------------------------------------------*
TABLES:
  e070v, e071, vrsd, v_username, dd02l.
*  zimportcheckdate, zbt_impchk_hiobj.

*--------------------------------------------------------------------*
* Selection Screen
*--------------------------------------------------------------------*
* Block for file path selection
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s00.
SELECT-OPTIONS:
  s_trkorr FOR e070v-trkorr NO INTERVALS.   " Transports to be Checked
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s01.
* Provide the name of your Systems. If you do not have Staging, give a random name
* And do not use the Staging radio button below
PARAMETERS: p_prd LIKE e070v-tarsystem OBLIGATORY DEFAULT 'PRD',   " VALUE 'PRD',
            p_qal LIKE e070v-tarsystem OBLIGATORY DEFAULT 'QAL',   " VALUE 'QAL',
            p_stg LIKE e070v-tarsystem OBLIGATORY DEFAULT 'STG'.   " VALUE 'STG',
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s02.
SELECTION-SCREEN COMMENT /1(50) sel_com1.
* Choose the Sytems to be compared with
PARAMETER:
  rb_prd  RADIOBUTTON GROUP rb1 DEFAULT 'X',  " Production
  rb_qal  RADIOBUTTON GROUP rb1,              " Quality
  rb_stg  RADIOBUTTON GROUP rb1.              " Staging (Pre-Production)
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s03.
* Select what you want to check
PARAMETER:
  cb_cvm  AS CHECKBOX DEFAULT 'X',
  cb_disp  AS CHECKBOX DEFAULT 'X',
  cb_tab  AS CHECKBOX DEFAULT 'X',
  cb_task  AS CHECKBOX DEFAULT ' ',
  cb_uc    AS CHECKBOX DEFAULT 'X',
* Check if Debug is there
  cb_deb AS CHECKBOX DEFAULT ' '.
SELECTION-SCREEN END OF BLOCK b4.

*--------------------------------------------------------------------*
* Constants
*--------------------------------------------------------------------*
CONSTANTS:
  c_condition_yes             TYPE c VALUE 'Y',
  c_condition_no              TYPE c VALUE 'N',
  c_color_normal              TYPE i VALUE 2,
  c_color_customizing         TYPE i VALUE 3,
  c_color_client001           TYPE i VALUE 5,
  c_color_error               TYPE i VALUE 6,
  c_color_warning             TYPE i VALUE 7,
  c_hide_type_trkorr          TYPE c VALUE '1',
  c_hide_type_msg             TYPE c VALUE '2',
  c_quefs                     LIKE rlgrap-filename
        VALUE '/usr/sap/trans/buffer/',
  c_cofiles_path              LIKE rlgrap-filename
        VALUE '/usr/sap/trans/cofiles/',
  c_data_path                 LIKE rlgrap-filename
        VALUE '/usr/sap/trans/data/',
  c_dnt_string                LIKE rlgrap-filename
        VALUE '.DO.NOT.TRANSPORT',
  c_support_pack_name         TYPE char16
        VALUE 'SUPPORT PACK',
  c_refresh_name              TYPE char16
        VALUE 'REFRESH',
  c_authchk_name              TYPE char16
        VALUE 'AUTH CHECK',

  c_authchk_objtype_is_source TYPE subc  VALUE '1',
  c_debug_vrsd                TYPE c VALUE 'N'.

*--------------------------------------------------------------------*
* TYPES, Data and Global Variables
*--------------------------------------------------------------------*
TYPES: BEGIN OF i_transport_type,
         trkorr           LIKE e070v-trkorr,
         as4date          LIKE e070v-as4date,
         as4time          LIKE e070v-as4time,
         as4user          LIKE e070v-as4user,
         as4text          LIKE e070v-as4text,
         trfunction       LIKE e070v-trfunction,
         tarsystem        LIKE e070v-tarsystem,
         client           LIKE e070v-client,
         name_text        LIKE adrp-name_text,
* Non-dependant flags (not related to other transports)
         e070v_exists     TYPE c,
         task_exists      TYPE c,
         object_exists    TYPE c,
         buffer_exists    TYPE c,          " unix buffer
         cofile_exists    TYPE c,
         datafile_exists  TYPE c,
         do_not_transport TYPE c,
         in_production    TYPE c,
         imported         TYPE c,
         selected         TYPE c,
* Dependant flags (related to other transports)
         eligible         TYPE c,    " eligible for transport
         exclude          TYPE c,    " only display if debug is on
         optional         TYPE c,    " latest unselected transports
       END OF i_transport_type.
DATA: i_transport TYPE TABLE OF i_transport_type,
      i_thistory  TYPE TABLE OF i_transport_type.

TYPES: BEGIN OF i_task_type,
         strkorr   LIKE e070v-strkorr,
         trkorr    LIKE e070v-trkorr,
         as4date   LIKE e070v-as4date,
         as4time   LIKE e070v-as4time,
         as4user   LIKE e070v-as4user,
         as4text   LIKE e070v-as4text,
         name_text LIKE adrp-name_text,
       END OF i_task_type.
DATA: i_task             TYPE TABLE OF i_task_type.

* Note, normally the object trkorr is the owning task,
* But here we are using the owning transport.
TYPES: BEGIN OF i_object_type,
         trkorr              LIKE e070v-trkorr,
         pgmid               LIKE e071-pgmid,
         object              LIKE e071-object,
         obj_name            LIKE e071-obj_name,
         first_vers_eligible LIKE vrsd-versno,
         is_index            TYPE c,
         is_table            TYPE c,
         is_tran             TYPE c,
         is_high_impact      TYPE c,
         possible_table      TYPE c,
         version_exists      TYPE c,
         auth_check_ok       TYPE c,
         uc_check_ok         TYPE c,
       END OF i_object_type.
DATA: i_object             TYPE TABLE OF i_object_type.

TYPES: BEGIN OF i_version_type,
         objtype          LIKE vrsd-objtype,
         objname          LIKE vrsd-objname,
         versno           LIKE vrsd-versno,
         korrnum          LIKE vrsd-korrnum,
         datum            LIKE vrsd-datum,
         zeit             LIKE vrsd-zeit,
         author           LIKE vrsd-author,
         name_text        LIKE adrp-name_text,
* Non-dependant flags (not related to other transports)
         buffer_exists    TYPE c,
         cofile_exists    TYPE c,
         datafile_exists  TYPE c,
         do_not_transport TYPE c,
         imported         TYPE c,
         selected         TYPE c,
* Dependant flags (related to other transports)
         eligible         TYPE c,
         exclude          TYPE c,
         optional         TYPE c,
       END OF i_version_type.
DATA: i_version             TYPE TABLE OF i_version_type.

TYPES: BEGIN OF i_name_type,
         bname     LIKE v_username-bname,
         name_text LIKE v_username-name_text,
       END OF i_name_type.
DATA:  i_name              TYPE TABLE OF i_name_type.

TYPES: BEGIN OF i_msg_type,
         type     TYPE i,
         trkorr   LIKE e070v-trkorr,
         objtype  LIKE vrsd-objtype,
         objname  LIKE vrsd-objname,
         msg_text TYPE char80,
       END OF i_msg_type.
DATA:  i_msg              TYPE TABLE OF i_msg_type.

TYPES:  BEGIN OF l_flag_type,
          exclude_or_eligible TYPE c,
          imported            TYPE c,
          selected            TYPE c,
          optional            TYPE c,
          this_transport      TYPE c,
          cofile_exists       TYPE c,
          datafile_exists     TYPE c,
          do_not_transport    TYPE c,
        END OF l_flag_type.

TYPES:  BEGIN OF g_hide_info,
          type   TYPE c,
          trkorr LIKE e070-trkorr,
          msgno  TYPE char3,
        END OF g_hide_info.

DATA:
  g_queue_name            LIKE rlgrap-filename,
  g_queue_name_prod       LIKE rlgrap-filename,
  gt_cofile_lines         TYPE tr_cofilines,
  gf_debug                TYPE c VALUE c_condition_no,
  gf_debug_extended_vrsd  TYPE c VALUE c_condition_no,
  gf_show_tables          TYPE c VALUE c_condition_no,
  gf_vrsd_check           TYPE c VALUE c_condition_no,
  gf_vrsd_show            TYPE c VALUE c_condition_no,
  gf_task_check           TYPE c VALUE c_condition_no,
  g_target                TYPE sysysid,
  g_current_color         TYPE i,
  g_transport_cutoff_date
                         LIKE e070v-as4date VALUE '20020601',
  g_refresh_date          LIKE e070v-as4date VALUE '20030703',
  g_authchk_date          LIKE e070v-as4date VALUE '99991231',
  g_hide_info             TYPE g_hide_info.

*--------------------------------------------------------------------*
* Ranges
*--------------------------------------------------------------------*
RANGES:
  s_object FOR vrsd-objname,
  s_objtyp FOR vrsd-objtype,
  unix_buffer FOR e070v-trkorr.

*--------------------------------------------------------------------*
* INITIALIZATION
*--------------------------------------------------------------------*
INITIALIZATION.
  sel_com1 = 'Select the target system'.
  PERFORM initialize.

*--------------------------------------------------------------------*
* AT SELECTION-SCREEN.
*--------------------------------------------------------------------*
AT SELECTION-SCREEN ON
    RADIOBUTTON GROUP rb1.
  IF     rb_stg = 'X'.
    g_target = p_stg.
  ELSEIF     rb_qal = 'X'.
    g_target = p_qal.
  ELSE.
    g_target = p_prd.
  ENDIF.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Read and Set Global Variables
  PERFORM read_screen_and_set.

* Set Normal Colour
  PERFORM set_color USING c_color_normal.

* Write some default output
  PERFORM write_default.

* get sid buffer
  PERFORM get_sid_buffer.

*--------------------------------------------------------------------*
* END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.

* Load the Transports
  PERFORM load_transports_selected.

* Depends on transport list fully processed
* Checks Versions
  PERFORM load_version_data.

* Massage the Seleted Transports
  PERFORM process_selected_transports.

*---------------------------------------------------------------------*
AT LINE-SELECTION.
  CASE syst-ucomm.
    WHEN 'PICK'.
      CASE g_hide_info-type.
        WHEN c_hide_type_trkorr.
          PERFORM display_transport_log USING g_hide_info-trkorr.
        WHEN c_hide_type_msg.
          PERFORM display_msg USING g_hide_info-msgno.
      ENDCASE.
  ENDCASE.


************************************************************************
************************************************************************
* Phase 1A - This phase loads the transport data into internal tables.
* Only transport, task and object data are loaded at this phase.
* Version data is loaded later, after all the selected transports have
* been processed.
************************************************************************
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  load_transports_selected
*&---------------------------------------------------------------------*
FORM load_transports_selected.
  DATA:
    wa_e070v        LIKE e070v,
    l_objects_exist TYPE c,
    wa_transport    TYPE i_transport_type,
    wa_thistory     TYPE i_transport_type,
    l_message       TYPE char120.
  LOOP AT s_trkorr.
    LOOP AT i_transport TRANSPORTING NO FIELDS
          WHERE trkorr EQ s_trkorr-low.
      CONCATENATE s_trkorr-low
                'is selected twice.'
                'Second selection is being skipped.'
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
    ENDLOOP.
    CHECK sy-subrc NE 0.

* Is transport in sap transport tables
    SELECT * FROM e070v INTO wa_e070v
           WHERE trkorr = s_trkorr-low.
    ENDSELECT.
    IF sy-subrc NE 0.
      CONCATENATE s_trkorr-low
                'is not a valid transport number and'
                'is being skipped.'
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
      CONTINUE.
    ENDIF.
    IF NOT wa_e070v-strkorr IS INITIAL.
      CONCATENATE s_trkorr-low
                'is a task and is being skipped.'
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
      CONTINUE.
    ENDIF.

    CLEAR: wa_transport.
    wa_transport-selected = c_condition_yes.
    PERFORM load_transport_initialize
          CHANGING wa_transport.
    wa_transport-e070v_exists = c_condition_yes.
    MOVE-CORRESPONDING wa_e070v TO wa_transport.
    PERFORM load_transport_settings
          USING wa_transport.
    PERFORM load_tasks
            USING     wa_transport
            CHANGING  wa_transport-object_exists.
    APPEND wa_transport TO i_transport.
    MOVE-CORRESPONDING wa_transport TO wa_thistory.
    APPEND wa_thistory TO i_thistory.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_transport_initialize
*       also used by versions to initialize history record
*&---------------------------------------------------------------------*
FORM load_transport_initialize
        CHANGING p_transport      TYPE i_transport_type.
  p_transport-e070v_exists = c_condition_no.
  p_transport-imported = c_condition_no.
  p_transport-buffer_exists = c_condition_no.
  p_transport-task_exists = c_condition_no.
  p_transport-object_exists = c_condition_no.
  p_transport-cofile_exists = c_condition_no.
  p_transport-datafile_exists = c_condition_no.
  p_transport-do_not_transport = c_condition_no.
  p_transport-eligible = c_condition_yes.
  p_transport-exclude = c_condition_no.
  p_transport-optional = c_condition_no.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_transport_settings
*               also used by versions to initialize history record
*&---------------------------------------------------------------------*
FORM load_transport_settings
        CHANGING p_transport       TYPE i_transport_type.
  PERFORM get_requestor_name
        USING p_transport-as4user p_transport-name_text.
  IF p_transport-trkorr IN unix_buffer[].
    p_transport-buffer_exists = c_condition_yes.
  ENDIF.
  PERFORM load_transport_files_exists USING p_transport.
  PERFORM get_cofile_data USING p_transport-trkorr.
  READ TABLE gt_cofile_lines TRANSPORTING NO FIELDS
      WITH KEY tarsystem = g_target function = 'I'.
* Is this transport already imported?
  IF sy-subrc EQ 0.
    p_transport-imported = c_condition_yes.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_tasks
*&---------------------------------------------------------------------*
FORM load_tasks
        USING p_transport       TYPE i_transport_type
              p_objects_exist   TYPE c.
  DATA:
    xxtask          LIKE e070v  OCCURS 0,
    wa_xxtask       LIKE e070v,
    l_objects_exist TYPE c,
    wa_task         TYPE i_task_type.
  LOOP AT i_task TRANSPORTING NO FIELDS
        WHERE strkorr = p_transport-trkorr.
  ENDLOOP.
  CHECK sy-subrc NE 0.
  SELECT * FROM e070v INTO TABLE xxtask
  WHERE strkorr = p_transport-trkorr.
* If no match, request has no tasks, use request number
  IF sy-subrc EQ 0.
    p_transport-task_exists = c_condition_yes.
  ELSE.
    p_transport-task_exists = c_condition_no.
    MOVE-CORRESPONDING p_transport TO wa_xxtask.
    wa_xxtask-strkorr = p_transport-trkorr.
    APPEND wa_xxtask TO xxtask.
  ENDIF.

  LOOP AT xxtask INTO wa_xxtask.
    CLEAR: wa_task.
    MOVE-CORRESPONDING wa_xxtask TO wa_task.
    PERFORM get_requestor_name
            USING wa_task-as4user wa_task-name_text.
    l_objects_exist = c_condition_no.
    PERFORM load_objects USING wa_task l_objects_exist.
    IF l_objects_exist = c_condition_yes.
      p_objects_exist = c_condition_yes.
    ENDIF.
    APPEND wa_task TO i_task.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&  Form load_objects
*&---------------------------------------------------------------------*
FORM load_objects
      USING p_task            TYPE i_task_type
            p_object_exists   TYPE c.
  DATA:
    xobj      LIKE e071  OCCURS 0,
    wa_xobj   LIKE e071,
    wa_dd02l  LIKE dd02l,
    wa_object TYPE i_object_type.
  SELECT * FROM e071 INTO TABLE xobj
  WHERE trkorr = p_task-trkorr.
  IF sy-subrc NE 0.
    p_object_exists = c_condition_no.
    EXIT.
  ENDIF.
  p_object_exists = c_condition_yes.
  DELETE xobj WHERE object = 'NOTE' OR object = 'CINS' OR
          object = 'RELE'.
  LOOP AT xobj INTO wa_xobj.
*   Note: verify for objects by tasks owning transport number
    LOOP AT i_object TRANSPORTING NO FIELDS
          WHERE object = wa_xobj-object AND
                obj_name = wa_xobj-obj_name AND
                trkorr = p_task-strkorr.
    ENDLOOP.
    CHECK sy-subrc NE 0.
    CLEAR: wa_object.
    MOVE-CORRESPONDING wa_xobj TO wa_object.
    wa_object-version_exists = c_condition_no.
    wa_object-is_index = c_condition_no.
    wa_object-is_table = c_condition_no.
    wa_object-is_tran = c_condition_no.
    wa_object-possible_table = c_condition_no.
    wa_object-trkorr = p_task-strkorr.
    wa_object-auth_check_ok = c_condition_yes.
    wa_object-uc_check_ok = c_condition_yes.
    PERFORM check_high_impact CHANGING wa_object.
    CASE wa_object-object.
      WHEN 'TRAN'.
        wa_object-is_tran = c_condition_yes.
      WHEN 'INDX'.
        wa_object-is_index = c_condition_yes.
      WHEN 'PROG' OR 'REPS'.
        PERFORM load_pgm_authorization
            USING wa_object-obj_name
            CHANGING wa_object-auth_check_ok wa_object-uc_check_ok.
* Will add more table type detection here.
      WHEN 'TABD' OR 'TABL'.
        SELECT SINGLE * INTO wa_dd02l FROM dd02l
            WHERE tabname = wa_object-obj_name AND
        tabclass = 'TRANSP'.
        IF sy-subrc EQ 0.
          wa_object-is_table = c_condition_yes.
          PERFORM load_table_authorization
              USING wa_object-obj_name
              CHANGING wa_object-auth_check_ok.
        ELSE.
          wa_object-possible_table = c_condition_yes.
        ENDIF.
    ENDCASE.
    APPEND wa_object TO i_object.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form  check_high_impact
* Check for CI_ (Changes to Standard Table) and NRIV (Number Range)
* Maintain the high impact in our custom table zhighimpact with
* object, obj_name and text (reason)
*&---------------------------------------------------------------------*
FORM check_high_impact
        CHANGING pwa_object TYPE i_object_type.
  DATA:
    l_reason TYPE char80,
    l_object LIKE pwa_object-obj_name.

  IF pwa_object-object = 'TABD' AND pwa_object-obj_name(3) = 'CI_'.
    l_object = 'CI_'.
  ELSE.
    l_object = pwa_object-obj_name.
  ENDIF.

*--------------------------------------------------------------------*
* Example data in zhighimpact
* Object  ObjectName  Text
* TABD    CI_         Change to Standard Table. High Impact.
* TDAT    NRIV        Double Check Number Range Changes. High Impact
*--------------------------------------------------------------------*
*  SELECT SINGLE text INTO l_reason FROM zhighimpact
*      WHERE object = pwa_object-object AND
*  obj_name = l_object.
*  IF sy-subrc EQ 0.
*    pwa_object-is_high_impact = c_condition_yes.
*  ELSE.
*    pwa_object-is_high_impact = c_condition_no.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_pgm_authorization
*&---------------------------------------------------------------------*
FORM load_pgm_authorization
        USING p_obj_name
        CHANGING p_auth_check_ok p_uc_check_ok.
  DATA:
  wa_trdir        LIKE trdir.
  SELECT SINGLE * INTO wa_trdir FROM trdir
  WHERE name = p_obj_name.
  CHECK sy-subrc EQ 0.
  CHECK wa_trdir-subc EQ c_authchk_objtype_is_source.
  IF wa_trdir-secu IS INITIAL.
    p_auth_check_ok = c_condition_no.
  ENDIF.
  IF wa_trdir-uccheck IS INITIAL.
    p_uc_check_ok = c_condition_no.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_table_authorization
*&---------------------------------------------------------------------*
FORM load_table_authorization
        USING p_obj_name
        CHANGING p_auth_check_ok.
  DATA:
  wa_tddat        LIKE tddat.
  SELECT SINGLE * INTO wa_tddat FROM tddat
  WHERE tabname = p_obj_name.
  CHECK sy-subrc EQ 0.
  IF wa_tddat-cclass IS INITIAL OR wa_tddat-cclass EQ '&NC&'.
    p_auth_check_ok = c_condition_no.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get_cofile_data
*&---------------------------------------------------------------------*
FORM get_cofile_data USING korrnum.

  CHECK NOT korrnum IS INITIAL.
  CALL FUNCTION 'STRF_READ_COFILE'
    EXPORTING
      iv_dirtype    = 'T'
      iv_trkorr     = korrnum
    TABLES
      tt_cofi_lines = gt_cofile_lines
    EXCEPTIONS
      no_info_found = 2.
  IF sy-subrc = 0.
    DELETE gt_cofile_lines
              WHERE function = '<' OR function = '>'.
  ENDIF.
ENDFORM.

************************************************************************
************************************************************************
* This section loads the version data into internal tables
* need the selected transports to all be loaded at this time
************************************************************************
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  load_version_data
*&      load version data after all selected transports retrieved
*&---------------------------------------------------------------------*
FORM load_version_data.
  DATA:
    wa_transport TYPE i_transport_type,
    wa_object    TYPE i_object_type,
    wa_version   TYPE i_version_type,
    wa_thistory  TYPE i_transport_type.
  CHECK gf_vrsd_check EQ c_condition_yes.
  LOOP AT i_transport INTO wa_transport.
    LOOP AT i_object INTO wa_object
            WHERE trkorr = wa_transport-trkorr.
      PERFORM load_version_management
              CHANGING wa_object.
      MODIFY i_object FROM wa_object.
    ENDLOOP.
  ENDLOOP.
* Transfer any restrictions found in versions, back to thistory
  LOOP AT i_thistory INTO wa_thistory.
    IF wa_thistory-eligible EQ c_condition_yes.
      LOOP AT i_version INTO wa_version
            WHERE korrnum EQ wa_thistory-trkorr.
        IF wa_version-eligible EQ c_condition_no.
          wa_thistory-eligible = c_condition_no.
        ENDIF.
        IF wa_version-optional EQ c_condition_no.
          wa_thistory-optional = c_condition_no.
        ENDIF.
        MODIFY i_thistory FROM wa_thistory.
        EXIT.
      ENDLOOP.
    ENDIF.
* Transfer any restrictions in thistory, back to transports
    IF wa_thistory-eligible NE c_condition_yes.
      LOOP AT i_transport INTO wa_transport
            WHERE trkorr EQ wa_thistory-trkorr.
        IF wa_thistory-eligible EQ c_condition_no.
          wa_transport-eligible = c_condition_no.
        ENDIF.
        IF wa_thistory-optional EQ c_condition_no.
          wa_transport-optional = c_condition_no.
        ENDIF.
        MODIFY i_transport FROM wa_transport.
      ENDLOOP.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&  Form load_version_management
*&---------------------------------------------------------------------*
FORM load_version_management
        CHANGING p_object   TYPE i_object_type.
  DATA: xvrsd              LIKE vrsd OCCURS 0,
        wa_vrsd            LIKE vrsd,
        li_version_work    TYPE TABLE OF i_version_type,
        wa_version         TYPE i_version_type,
        w_object           LIKE vrsd-objtype,
        l_highest_imported TYPE i_version_type-versno,
        l_highest_excluded TYPE i_version_type-versno,
        l_lowest_selected  TYPE i_version_type-versno,
        l_highest_selected TYPE i_version_type-versno.
  w_object = p_object-object.
  IF w_object = 'PROG'.
    w_object = 'REPS'.
  ENDIF.
  LOOP AT i_version TRANSPORTING NO FIELDS
        WHERE objtype = w_object AND
          objname = p_object-obj_name.
  ENDLOOP.
  IF sy-subrc EQ 0.
    p_object-version_exists = c_condition_yes.
    EXIT.
  ENDIF.
  SELECT * FROM vrsd INTO TABLE xvrsd
         WHERE objtype = w_object
  AND objname = p_object-obj_name.
* Does version exist, if no, exit
  CHECK sy-subrc EQ 0.

* Perform first pass selection
  p_object-version_exists = c_condition_yes.
  LOOP AT xvrsd INTO wa_vrsd.
*   Some transports pre-date PRR creation
    CHECK NOT wa_vrsd-datum LT g_transport_cutoff_date.
    IF gf_debug NE c_condition_yes.
*     Blank transport is probably local change but can't matter
      CHECK NOT wa_vrsd-korrnum IS INITIAL.
*             change current version to correct version number
    ENDIF.
*   Skip replaced transports for now **********************************
    CHECK wa_vrsd-loekz NE 'I'.
    IF wa_vrsd-versno = '00000'.
      wa_vrsd-versno = wa_vrsd-lastversno + 1.
    ENDIF.
    CLEAR: wa_version.
    MOVE-CORRESPONDING wa_vrsd TO wa_version.
    PERFORM load_version_analysis
            CHANGING wa_version.
    PERFORM get_requestor_name
            CHANGING wa_version-author wa_version-name_text.
    APPEND wa_version TO li_version_work.
  ENDLOOP.
  SORT li_version_work DESCENDING  BY versno.

* Process entries to find highest version imported,
* lowest selected version
  CLEAR: l_highest_imported, l_lowest_selected.
  LOOP AT li_version_work INTO wa_version.
    IF l_highest_imported IS INITIAL AND
          wa_version-imported EQ c_condition_yes AND
          wa_version-do_not_transport NE c_condition_yes.
      l_highest_imported = wa_version-versno.
    ENDIF.
    IF l_highest_selected IS INITIAL AND
          wa_version-selected EQ c_condition_yes.
      l_highest_selected = wa_version-versno.
    ENDIF.
    IF wa_version-selected EQ c_condition_yes.
      l_lowest_selected = wa_version-versno.
    ENDIF.
  ENDLOOP.

  l_highest_excluded = l_highest_imported.
  IF l_highest_imported GE l_lowest_selected.
    l_highest_excluded = l_lowest_selected - 1.
  ENDIF.

* Process again to exclude uninvolved transports
* Exclude all after first unimported or selected transport
*
  LOOP AT li_version_work INTO wa_version.
    IF wa_version-exclude NE c_condition_yes AND
          wa_version-do_not_transport NE c_condition_yes.
      wa_version-exclude = c_condition_no.
      wa_version-eligible = c_condition_no.
      wa_version-optional = c_condition_no.
      IF wa_version-versno GT l_highest_selected AND
            wa_version-versno GT l_highest_imported.
        wa_version-optional = c_condition_yes.
        wa_version-eligible = c_condition_yes.
      ELSEIF wa_version-versno GT l_highest_imported.
        wa_version-eligible = c_condition_yes.
      ELSEIF wa_version-versno LE l_highest_excluded OR
            wa_version-korrnum IS INITIAL OR
            wa_version-datum LT g_transport_cutoff_date.
        wa_version-exclude = c_condition_yes.
      ENDIF.
    ENDIF.
    APPEND wa_version TO i_version.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_version_analysis
*&---------------------------------------------------------------------*
FORM load_version_analysis USING p_version TYPE i_version_type.
  DATA:
  wa_thistory        TYPE i_transport_type.
* Do we know about this transport already?
  LOOP AT i_thistory INTO wa_thistory
          WHERE trkorr = p_version-korrnum.
  ENDLOOP.
  IF sy-subrc NE 0.
    PERFORM load_version_transport_info
          USING p_version
          CHANGING wa_thistory.
  ENDIF.
  p_version-selected = wa_thistory-selected.
  p_version-imported = wa_thistory-imported.
  p_version-buffer_exists = wa_thistory-buffer_exists.
  p_version-cofile_exists = wa_thistory-cofile_exists.
  p_version-datafile_exists = wa_thistory-datafile_exists.
  p_version-do_not_transport = wa_thistory-do_not_transport.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_version_transport_info
*&---------------------------------------------------------------------*
FORM load_version_transport_info
      USING p_version       TYPE i_version_type
      CHANGING p_thistory   TYPE i_transport_type.
  CLEAR: p_thistory.
  p_thistory-trkorr = p_version-korrnum.
  p_thistory-as4date = p_version-datum.
  p_thistory-as4time = p_version-zeit.
  p_thistory-as4user = p_version-author.
* If we are loading info at this point, it wasn't selected
  p_thistory-selected = c_condition_no.
  PERFORM load_transport_initialize
        CHANGING p_thistory.
  PERFORM load_transport_settings USING p_thistory.
  APPEND p_thistory TO i_thistory.
ENDFORM.

************************************************************************
************************************************************************
* This section reports the data proviously loaded
************************************************************************
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  process_selected_transports
*&---------------------------------------------------------------------*
FORM process_selected_transports.
  TYPES:  BEGIN OF l_flag_typex,
            e070v_exists  TYPE c,
            task_exists   TYPE c,
            object_exists TYPE c,
            buffer_exists TYPE c,
            exclude       TYPE c,
          END OF l_flag_typex.
  DATA:
    l_flagsx     TYPE l_flag_typex,
    l_flags      TYPE l_flag_type,
    wa_transport TYPE i_transport_type,
    l_message    TYPE char120.
  LOOP AT i_transport INTO wa_transport.
*   Is transport in sap transport tables (add code to check for task?)
    IF wa_transport-e070v_exists NE c_condition_yes.
      CONCATENATE wa_transport-trkorr
               'is not an SAP transport, skipping check.'
               INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_error l_message.
      CONTINUE.
    ENDIF.
    CLEAR: l_flagsx, l_flags.
    IF wa_transport-e070v_exists EQ c_condition_yes.
      l_flagsx-e070v_exists = 'E'.
    ENDIF.
    IF wa_transport-task_exists EQ c_condition_yes.
      l_flagsx-task_exists = 'T'.
    ENDIF.
    IF wa_transport-object_exists EQ c_condition_yes.
      l_flagsx-object_exists = 'O'.
    ENDIF.
    IF wa_transport-buffer_exists EQ c_condition_yes.
      l_flagsx-buffer_exists = 'B'.
    ENDIF.
    IF wa_transport-exclude EQ c_condition_yes.
      l_flagsx-exclude = 'X'.
    ENDIF.
    PERFORM process_transport_flags
          USING      wa_transport
          CHANGING   l_flags.
    FORMAT COLOR OFF.
    IF wa_transport-trfunction = 'W'.
      PERFORM set_color USING c_color_customizing.
    ELSEIF wa_transport-client = '001'.
      PERFORM set_color USING c_color_client001.
    ELSE.
      PERFORM set_color USING c_color_normal.
    ENDIF.
    SKIP 1.
    WRITE :/ wa_transport-trkorr,
          21 l_flagsx,
          31 l_flags,
          40 wa_transport-as4date MM/DD/YYYY,
          52 wa_transport-as4time,  62(10) wa_transport-as4user,
          74(30) wa_transport-name_text.
    PERFORM hide_transport USING wa_transport-trkorr.
    WRITE :/5 wa_transport-trfunction, 7 wa_transport-tarsystem,
           12 wa_transport-client, 20 wa_transport-as4text.
* Is transport already imported
    IF wa_transport-imported EQ c_condition_yes.
      CONCATENATE wa_transport-trkorr
                'has already been transported'
                'and should not be imported'
                INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_error l_message.
    ENDIF.
* Is transport in unix buffer file
    IF wa_transport-buffer_exists NE c_condition_yes.
      CONCATENATE wa_transport-trkorr
                'is not in the unix import buffer.'
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
* Is transport in unix cofile file
    IF wa_transport-cofile_exists NE c_condition_yes.
      CONCATENATE wa_transport-trkorr
                'does not have a file in' c_cofiles_path
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
* Is transport in unix datafile file
    IF wa_transport-datafile_exists NE c_condition_yes.
      CONCATENATE wa_transport-trkorr
                'does not have a file in' c_data_path
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
* Is transport marked DNT
    IF wa_transport-do_not_transport EQ c_condition_yes.
      CONCATENATE wa_transport-trkorr
                'is marked DO.NOT.TRANSPORT'
                INTO l_message SEPARATED BY space.               .
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
* Is transport older than support pack cutoff date
    IF wa_transport-as4date LT g_transport_cutoff_date.
      CONCATENATE wa_transport-trkorr '-'
            'is too old.  Older than support pack level'
            INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_error l_message.
    ENDIF.

    PERFORM process_tasks USING wa_transport.
    PERFORM process_objects USING wa_transport.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  process_transport_flags
*&---------------------------------------------------------------------*
FORM process_transport_flags
      USING     p_transport       TYPE i_transport_type
      CHANGING  p_flags           TYPE l_flag_type.
  CLEAR: p_flags.
  IF p_transport-eligible EQ c_condition_yes.
    p_flags-exclude_or_eligible = 'E'.
  ENDIF.
  IF p_transport-exclude EQ c_condition_yes.
    p_flags-exclude_or_eligible = 'X'.
  ENDIF.
  IF p_transport-imported EQ c_condition_yes.
    p_flags-imported = 'I'.
  ENDIF.
  IF p_transport-cofile_exists NE c_condition_yes.
    p_flags-cofile_exists = 'C'.
  ENDIF.
  IF p_transport-datafile_exists NE c_condition_yes.
    p_flags-datafile_exists = 'D'.
  ENDIF.
  IF p_transport-do_not_transport EQ c_condition_yes.
    p_flags-do_not_transport = 'N'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  process_tasks
*&---------------------------------------------------------------------*
FORM process_tasks USING p_transport TYPE i_transport_type.
  DATA:
    wa_task   TYPE i_task_type,
    l_message TYPE char120.
  IF p_transport-task_exists NE c_condition_yes
      AND gf_task_check EQ c_condition_yes.
    CONCATENATE p_transport-trkorr 'contains no tasks.'
            INTO l_message SEPARATED BY space.               .
    PERFORM write_error USING c_color_warning l_message.
    EXIT.
  ENDIF.

  LOOP AT i_task INTO wa_task
          WHERE strkorr = p_transport-trkorr.
    WRITE :/5 wa_task-trkorr, 40 wa_task-as4date MM/DD/YYYY,
        52 wa_task-as4time,  62(10) wa_task-as4user,
        74(30) wa_task-name_text.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&  Form process_objects
*&---------------------------------------------------------------------*
FORM process_objects USING p_transport TYPE i_transport_type.
  DATA:
    wa_object TYPE i_object_type,
    l_message TYPE char120.
  CHECK p_transport-object_exists = c_condition_yes.
  LOOP AT i_object INTO wa_object
          WHERE trkorr = p_transport-trkorr.
    WRITE :/9 wa_object-pgmid, 14 wa_object-object,
            19 wa_object-obj_name.
    IF wa_object-auth_check_ok NE c_condition_yes
            AND p_transport-as4date GT g_authchk_date.
      CONCATENATE p_transport-trkorr '-'
            wa_object-object wa_object-obj_name
            'is missing program or table authorization'
            INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_error l_message.
    ENDIF.
    IF wa_object-uc_check_ok NE c_condition_yes
            AND cb_uc IS NOT INITIAL.
      CONCATENATE p_transport-trkorr '-'
            wa_object-object wa_object-obj_name
            'does not have unicode attribute set'
            INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_error l_message.
    ENDIF.
    IF wa_object-is_high_impact EQ c_condition_yes.
      CONCATENATE p_transport-trkorr '-'
            wa_object-object wa_object-obj_name
            'is a high impact object'
            INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_error l_message.
    ENDIF.
    IF wa_object-is_tran EQ c_condition_yes.
      CONCATENATE p_transport-trkorr '-'
            wa_object-object wa_object-obj_name
            'is a tcode change'
            INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
    IF gf_show_tables EQ c_condition_yes.
      IF wa_object-is_index = c_condition_yes.
        CONCATENATE p_transport-trkorr '-'
              wa_object-object wa_object-obj_name
              'is an index change'
              INTO l_message SEPARATED BY space.
        PERFORM write_error USING c_color_warning l_message.
      ENDIF.
      IF wa_object-is_table = c_condition_yes.
        CONCATENATE p_transport-trkorr '-'
              wa_object-object wa_object-obj_name
              'is a table change'
              INTO l_message SEPARATED BY space.
        PERFORM write_error USING c_color_warning l_message.
      ENDIF.
      IF wa_object-possible_table = c_condition_yes AND
            gf_debug = c_condition_yes.
        CONCATENATE p_transport-trkorr '-'
              wa_object-object wa_object-obj_name
              'might be a table change'
              INTO l_message SEPARATED BY space.
        PERFORM write_error USING c_color_warning l_message.
      ENDIF.
    ENDIF.
    IF wa_object-version_exists EQ c_condition_yes.
      PERFORM analyze_version_management
              USING p_transport-trkorr wa_object.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&  Form check_version_management
*&---------------------------------------------------------------------*
FORM analyze_version_management
        USING   p_trkorr LIKE e070v-trkorr
                p_object TYPE i_object_type.
  DATA:
    l_flags          TYPE l_flag_type,
    l_object         LIKE vrsd-objtype,
    wa_version       TYPE i_version_type,
    l_selected_found TYPE c,
    l_message        TYPE char120.
  l_object = p_object-object.
  IF l_object = 'PROG'.
    l_object = 'REPS'.
  ENDIF.
  l_selected_found = c_condition_no.
  LOOP AT i_version INTO wa_version
          WHERE objtype = l_object AND
                objname = p_object-obj_name.
    IF p_trkorr EQ wa_version-korrnum.
      l_selected_found = c_condition_yes.
    ENDIF.
    IF gf_debug NE c_condition_yes.
      CHECK wa_version-do_not_transport NE c_condition_yes.
      CHECK wa_version-exclude NE c_condition_yes.
    ENDIF.
    PERFORM analyze_process_flags
          USING      wa_version p_trkorr
          CHANGING   l_selected_found l_flags.
    FORMAT INTENSIFIED OFF.
    WRITE :/13 wa_version-versno, 20 wa_version-korrnum,
            31 l_flags,
            40 wa_version-datum MM/DD/YYYY, 52 wa_version-zeit,
            62(10) wa_version-author, 74(30) wa_version-name_text.
    PERFORM hide_transport USING wa_version-korrnum.
    FORMAT INTENSIFIED ON.
    PERFORM analyse_versions
          USING p_trkorr wa_version l_selected_found.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  check_process_flags
*&---------------------------------------------------------------------*
FORM analyze_process_flags
      USING     p_version       TYPE i_version_type
                p_trkorr        LIKE e070v-trkorr
      CHANGING  p_selected_found TYPE c
                p_flags         TYPE l_flag_type.
  CLEAR: p_flags.
  IF p_version-eligible = c_condition_yes.
    p_flags-exclude_or_eligible = 'E'.
  ENDIF.
  IF p_version-exclude EQ c_condition_yes.
    p_flags-exclude_or_eligible = 'X'.
  ENDIF.
  IF p_version-imported = c_condition_yes.
    p_flags-imported = 'I'.
  ENDIF.
  IF p_version-selected = c_condition_yes.
    p_selected_found = c_condition_yes.
    p_flags-selected = 'S'.
  ENDIF.
  IF p_version-optional = c_condition_yes.
    p_flags-optional = 'O'.
  ENDIF.
  IF p_version-korrnum EQ p_trkorr.
    p_flags-this_transport = 'T'.
  ENDIF.
  IF p_version-cofile_exists NE c_condition_yes.
    p_flags-cofile_exists = 'C'.
  ENDIF.
  IF p_version-datafile_exists NE c_condition_yes.
    p_flags-datafile_exists = 'D'.
  ENDIF.
  IF p_version-do_not_transport EQ c_condition_yes.
    p_flags-do_not_transport = 'N'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  analyse_versions
*&---------------------------------------------------------------------*
FORM analyse_versions
      USING p_trkorr LIKE e070v-trkorr
            p_version TYPE i_version_type
            p_selected_found TYPE c.
  DATA: l_message      TYPE char120.
* No errors for the following
  CHECK p_version-exclude NE c_condition_yes.
  CHECK p_version-do_not_transport NE c_condition_yes.
* Analyze the rest
  CHECK p_version-imported NE c_condition_yes.
  IF p_version-eligible NE c_condition_yes.
    CONCATENATE p_version-korrnum
               'has been replaced by a later transport'
               'and cannot be imported'
               INTO l_message SEPARATED BY space.
    PERFORM write_error USING c_color_error l_message.
  ELSEIF p_version-optional EQ c_condition_yes.
    IF g_target EQ p_prd.
      CONCATENATE p_version-korrnum
                 'is an optional transport that may have been'
                 'overlooked or related to a later change'
                 INTO l_message SEPARATED BY space.
      PERFORM write_error USING c_color_warning l_message.
    ENDIF.
  ELSEIF p_version-selected NE c_condition_yes.
    CONCATENATE p_version-korrnum
                'is a prerequisite transport'
                'that needs to be included'
                INTO l_message SEPARATED BY space.
    PERFORM write_error USING c_color_error l_message.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get_requestor_name
*&---------------------------------------------------------------------*
FORM get_requestor_name USING p_as4user p_name_text.
  DATA:
  wa_name      TYPE i_name_type.
* See if last request was for the same user
  IF p_as4user = wa_name-bname.
    p_name_text = wa_name-name_text.
    EXIT.
  ENDIF.
* See if we already have it in our table, else get new entry
  LOOP AT i_name INTO wa_name WHERE bname = p_as4user.
  ENDLOOP.
  IF sy-subrc NE 0.
    wa_name-bname = p_as4user.
    SELECT SINGLE name_text INTO wa_name-name_text FROM v_username
    WHERE bname = wa_name-bname.
    IF sy-subrc EQ 0.
      APPEND wa_name TO i_name.
    ELSE.
      SELECT SINGLE name_text INTO wa_name-name_text
          FROM v_username CLIENT SPECIFIED
      WHERE bname = wa_name-bname.
      IF sy-subrc EQ 0.
        APPEND wa_name TO i_name.
      ELSE.
        wa_name-name_text = 'NAME NOT FOUND'.
      ENDIF.
    ENDIF.
  ENDIF.
  p_name_text = wa_name-name_text.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  load_transport_files_exists
*&---------------------------------------------------------------------*
FORM load_transport_files_exists
        CHANGING p_transport TYPE i_transport_type.
  DATA:
  l_file_name LIKE rlgrap-filename.

* Check if it appears to be local change object
  IF p_transport-trkorr IS INITIAL.
    p_transport-exclude = c_condition_yes.
    p_transport-do_not_transport = c_condition_yes.
    EXIT.
  ENDIF.

* Check if cofile exists
* Appended with encoding DEFAULT after text mode
  p_transport-cofile_exists = c_condition_no.
  CONCATENATE c_cofiles_path p_transport-trkorr+3(7)
        '.' p_transport-trkorr(3)
        INTO l_file_name.
  OPEN DATASET l_file_name FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    p_transport-cofile_exists = c_condition_yes.
  ENDIF.
  CLOSE DATASET l_file_name.

* Check if date file exists
* Appended with encoding DEFAULT after text mode
  p_transport-datafile_exists = c_condition_no.
  CONCATENATE c_data_path 'R' p_transport-trkorr+4(6)
        '.' p_transport-trkorr(3)
        INTO l_file_name.
  OPEN DATASET l_file_name FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    p_transport-datafile_exists = c_condition_yes.
  ENDIF.
  CLOSE DATASET l_file_name.

* If data file does not exist, check if it has been renamed to DNT
* Appended with encoding DEFAULT after text mode
  p_transport-do_not_transport = c_condition_no.
  IF p_transport-datafile_exists NE c_condition_yes.
    CONCATENATE l_file_name c_dnt_string
        INTO l_file_name.
    OPEN DATASET l_file_name FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      p_transport-do_not_transport = c_condition_yes.
    ENDIF.
    CLOSE DATASET l_file_name.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  initialize
*&---------------------------------------------------------------------*
FORM initialize.
* ZIMPORTCHECKDATE can have two fields like eventname and date
* Example Data below
* EVENTNAME        DATE
* AUTH CHECK       09.22.2012
* REFRESH          09.22.2012
* SUPPORT PACK     03.22.2018

*  DATA:
*  wa_zimportcheckdate    LIKE zimportcheckdate.
*  CLEAR g_hide_info.
*  CLEAR: gf_debug, gf_show_tables.
*  SELECT SINGLE date_value
*        INTO CORRESPONDING FIELDS OF wa_zimportcheckdate
*        FROM zimportcheckdate
*  WHERE date_name EQ c_support_pack_name.
*  IF sy-subrc EQ 0.
*    g_transport_cutoff_date = wa_zimportcheckdate-date_value.
*  ENDIF.
*
*  SELECT SINGLE date_value
*        INTO CORRESPONDING FIELDS OF wa_zimportcheckdate
*        FROM zimportcheckdate
*  WHERE date_name EQ c_refresh_name.
*  IF sy-subrc EQ 0.
*    g_refresh_date = wa_zimportcheckdate-date_value.
*  ENDIF.
*
*  SELECT SINGLE date_value
*        INTO CORRESPONDING FIELDS OF wa_zimportcheckdate
*        FROM zimportcheckdate
*  WHERE date_name EQ c_authchk_name.
*  IF sy-subrc EQ 0.
*    g_authchk_date = wa_zimportcheckdate-date_value.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  get_sid_buffer
*&---------------------------------------------------------------------*
FORM get_sid_buffer.
  DATA: inline(256).
  RANGES:   wa_buffer FOR e070v-trkorr.
  wa_buffer-sign   = 'I'.
  wa_buffer-option = 'EQ'.
  OPEN DATASET g_queue_name FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  CHECK sy-subrc = 0.
  DO.
    READ DATASET g_queue_name INTO inline.
    IF sy-subrc = 0.
      CHECK inline+00(1) NE '#'.
      CHECK inline+65(1) NE '*'.
      wa_buffer-low = inline+3(10).
      APPEND wa_buffer TO unix_buffer.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  IF unix_buffer[] IS INITIAL.
    wa_buffer-low = 'DUMMY'.
    APPEND wa_buffer TO unix_buffer.
  ENDIF.
  CLOSE DATASET g_queue_name.

  IF unix_buffer[] IS INITIAL.
    PERFORM write_error USING c_color_error
         'Import buffer is empty, checks may be incomplete.'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  write_error
*&---------------------------------------------------------------------*
FORM write_error
      USING p_new_color TYPE i
            p_message TYPE char120.
  DATA: l_message LIKE p_message.
  l_message = p_message.
  CONDENSE l_message.
  FORMAT COLOR = p_new_color.
  WRITE: / l_message.
  FORMAT COLOR = g_current_color.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  set_color
*&---------------------------------------------------------------------*
FORM set_color
    USING p_new_color TYPE i.
  g_current_color = p_new_color.
  FORMAT COLOR = g_current_color.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  restore_color
*&---------------------------------------------------------------------*
FORM restore_color.
  FORMAT COLOR = g_current_color.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM hide_transport
*---------------------------------------------------------------------*
FORM hide_transport
      USING p_trkorr LIKE e070-trkorr.
  CLEAR g_hide_info.
  g_hide_info-type = c_hide_type_trkorr.
  g_hide_info-trkorr = p_trkorr.
  HIDE g_hide_info.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM hide_msg
*---------------------------------------------------------------------*
FORM hide_msg
      USING p_msgno TYPE char3.
  CLEAR g_hide_info.
  g_hide_info-type = c_hide_type_msg.
  g_hide_info-trkorr = p_msgno.
  HIDE g_hide_info.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM display_transport_log
*---------------------------------------------------------------------*
FORM display_transport_log
      USING p_trkorr LIKE e070-trkorr.
  CHECK NOT p_trkorr IS INITIAL.
  CALL FUNCTION 'TR_LOG_OVERVIEW_REQUEST'
    EXPORTING
      iv_trkorr = p_trkorr.
  CLEAR p_trkorr.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM display_msg
*---------------------------------------------------------------------*
FORM display_msg
      USING p_msgno TYPE char3.
  CHECK NOT p_msgno IS INITIAL.

  CLEAR p_msgno.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_SCREEN_AND_SET
*&---------------------------------------------------------------------*
*       Set the global variables
*----------------------------------------------------------------------*
FORM read_screen_and_set .
  IF NOT cb_deb IS INITIAL.
    gf_debug = c_condition_yes.
  ENDIF.

  IF NOT cb_tab IS INITIAL.
    gf_show_tables = c_condition_yes.
  ENDIF.

  IF NOT cb_cvm IS INITIAL.
    gf_vrsd_check = c_condition_yes.
  ENDIF.

  IF NOT cb_disp IS INITIAL.
    gf_vrsd_check = c_condition_yes.
    gf_vrsd_show = c_condition_yes.
  ENDIF.

  IF NOT cb_task IS INITIAL.
    gf_task_check = c_condition_yes.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  WRITE_DEFAULT
*&---------------------------------------------------------------------*
*       Write Default Output
*----------------------------------------------------------------------*
FORM write_default .
  CONCATENATE c_quefs g_target INTO g_queue_name.
  WRITE: / 'Using queue name:', g_queue_name.
  CONCATENATE c_quefs p_prd INTO g_queue_name_prod.
  WRITE: / 'Support Pack cutoff date:',
         30   g_transport_cutoff_date,
         / 'Refresh cutoff date:',
         30  g_refresh_date,
         / 'Auth check cutoff date:',
         30  g_authchk_date.

  IF s_trkorr[] IS INITIAL.
    WRITE: / 'No transports selected, ending.'.
    EXIT.
  ENDIF.
ENDFORM.
