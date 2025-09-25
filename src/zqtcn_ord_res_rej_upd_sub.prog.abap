*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_SUB (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-43362 / OTCM-29655                                            *
* DEVELOPER   : Prabhu (PTUFARAM)                          *
* DATE        : 03/25/2021                               *
* DESCRIPTION : Adding sales org and Item category exclusion
*              OTCM-43362 is replaced with OTCM-29655
*----------------------------------------------------------------------*
* REVISION NO : ED2K926559
* REFERENCE NO: EAM-1661
* DEVELOPER   : Vishnu (VCHITTIBAL)
* DATE        : 06/04/2022
* OBJECT ID   : E505
* DESCRIPTION : Adding new functionality to update reason for rejection
*               for Back orders
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORD_RES_REJ_UPD_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SEL_DYNAMICS
*----------------------------------------------------------------------*
FORM f_sel_dynamics .
* Define the object to be passed to the RESTRICTION parameter
  DATA: lst_restrict TYPE sscr_restrict,
        lst_optlist  TYPE sscr_opt_list,
        lst_ass      TYPE sscr_ass.

* Local Constants Declaration
  CONSTANTS: lc_name    TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lc_flag    TYPE flag       VALUE 'X',          " General Flag
             lc_kind    TYPE rsscr_kind VALUE 'S',          " ABAP: Type of selection
             lc_sg_main TYPE raldb_sign VALUE 'I',          " SIGN field in creation of SELECT-OPTIONS tables
             lc_sg_addy TYPE raldb_sign VALUE space,        " SIGN field in creation of SELECT-OPTIONS tables
             lc_op_main TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
             lv_mail    TYPE char6      VALUE 'S_MAIL'.     " For mail selection screen field
  CLEAR: lst_optlist , lst_ass.

  lst_optlist-name       = lc_name.
  lst_optlist-options-eq = lc_flag.
  APPEND lst_optlist TO lst_restrict-opt_list_tab.

  lst_ass-kind    = lc_kind.
  lst_ass-name    = lv_mail."'S_MAIL'.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lst_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.               " F_SEL_DYNAMICS
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*----------------------------------------------------------------------*
FORM f_initialization .
  REFRESH:gi_vbap,
          li_mail,
          i_message,
          i_attach_success,
          i_attach_error,
          i_packing_list,
          i_receivers,
          i_attachment.
  CLEAR:  st_imessage,
          g_job_name,
          s_date.
ENDFORM.               " F_INITIALIZATION
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS
*----------------------------------------------------------------------*
FORM f_screen_dynamics.
* Type Declaration
  TYPES:
    BEGIN OF ty_zcaconstant,
      devid    TYPE zdevid,                                       "Development ID
      param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
      param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
      srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
      sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
      opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
      low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
      high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
      activate TYPE zconstactive,                                 "Activation indicator for constant
    END OF ty_zcaconstant.

* Local Variables Declaration
  DATA:
    li_const_v  TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0,
    lst_const_v TYPE ty_zcaconstant,
    lv_days     TYPE i.       " Days

* Local Constants Declarations
  CONSTANTS:
    lc_id_e186   TYPE zdevid     VALUE 'E186',          " Development ID
    lc_from_date TYPE rvari_vnam VALUE 'DOC_FROM_DATE', " ABAP: Name of Variant Variable
    lc_auart     TYPE rvari_vnam VALUE 'AUART',         " ABAP: Name of Variant Variable
    lc_email     TYPE rvari_vnam VALUE 'EMAIL',         " ABAP: Name of Variant Variable
    lc_canc_pro  TYPE rvari_vnam VALUE 'CANC_PROC',     " ABAP: Name of Variant Variable
    lc_i         TYPE char1      VALUE 'I',             " For Sign
    lc_eq        TYPE char2      VALUE 'EQ',            " For Option
    lc_le        TYPE char2      VALUE 'LE',            " For option
    lc_pstyv     TYPE rvari_vnam VALUE 'PSTYV'.
  "REFRESH:s_type[],s_pro[],s_c_date[], s_date[],s_mail[].

* Fetch the constants
  SELECT devid                                                  "Development ID
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "ABAP: Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                    "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant                                            "Wiley Application Constant Table
    INTO TABLE li_const_v
    WHERE devid    EQ lc_id_e186
     AND  activate EQ abap_true.
  IF sy-subrc EQ 0.
    LOOP AT li_const_v INTO lst_const_v.
      CASE lst_const_v-param1.
        WHEN lc_from_date. " 'DOC_FROM_DATE'.
          MOVE lst_const_v-low TO lv_days.
          s_date-sign   = lc_i.
          s_date-option = c_opti_bt.  "'BT'.
          s_date-low    = sy-datum - lv_days.
          s_date-high   = sy-datum.
          APPEND s_date.

        WHEN lc_auart.     " AUART
* populate the default order types
          s_type-sign   = lst_const_v-sign.
          s_type-option = lst_const_v-opti.
          s_type-low    = lst_const_v-low.
          APPEND s_type.

        WHEN lc_canc_pro.  " CAncellation Procedure
* Populate the default Cancellation Procedures
          s_pro-sign   = lst_const_v-sign.
          s_pro-option = lst_const_v-opti.
          s_pro-low    = lst_const_v-low.
          APPEND s_pro.
        WHEN lc_email.  " Email
* Populate the default Email ID's
          s_mail-sign   = lst_const_v-sign.
          s_mail-option = lst_const_v-opti.
          s_mail-low    = lst_const_v-low.
          APPEND s_mail.
        WHEN lc_pstyv.
          s_it_cat-sign   = lst_const_v-sign.
          s_it_cat-option = lst_const_v-opti.
          s_it_cat-low    = lst_const_v-low.
          APPEND s_it_cat.
        WHEN OTHERS.
      ENDCASE.
      CLEAR: lst_const_v.
    ENDLOOP.
  ENDIF.

* Date Range for Cancellation Date
  s_c_date-sign   = lc_i.
  s_c_date-option = lc_le.
  s_c_date-low    = sy-datum.
  APPEND s_c_date.
ENDFORM.               " F_SCREEN_DYNAMICS
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*----------------------------------------------------------------------*
FORM f_get_data.
*--*BOC OTCM-29655 Prabhu ED2K922320 3/08/2021
  IF p_excl IS INITIAL.
    SELECT * FROM zqtc_cds_e186
           INTO TABLE gi_vbap
           WHERE vkorg IN s_vkorg
           AND   vbeln   IN s_vbeln
           AND   auart   IN s_type
           AND   erdat   IN s_date
           AND   matnr   IN s_matnr
           AND   vkuesch IN s_pro
           AND   vwundat IN s_c_date.
  ELSE.
    "Consider Exlcusion Entries Of Sales documents
    SELECT * FROM zqtc_cds_e186
           INTO TABLE gi_vbap
           WHERE vkorg IN s_vkorg
           AND   vbeln  IN s_vbeln
           AND   auart   IN s_type
           AND   pstyv   IN s_it_cat
           AND   erdat   IN s_date
           AND   matnr   IN s_matnr
           AND   vkuesch IN s_pro
           AND   vwundat IN s_c_date.
  ENDIF.
*--*EOC OTCM-29655 Prabhu ED2K922320 3/08/2021
  IF sy-subrc = 0.
    SORT gi_vbap BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM gi_vbap COMPARING vbeln posnr.
  ELSE.
* No Data for the given selection
    MESSAGE i000 WITH text-002 DISPLAY LIKE c_e. "No Data available for the Selection Criteria.
    RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BATCH_JOB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM batch_job .
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status
* Local constant declaration
  CONSTANTS: lc_job_name   TYPE btcjob VALUE 'ZAUTO_REJ_RES'. " Background job name
  CLEAR lv_job_name.
  CONCATENATE lc_job_name c_underscore sy-uzeit c_underscore sy-datum  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-008. "Processing the schedule in batch job
**Check if pre. Job name and job count is present
**then set the check pre. status to X else blank.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
*     sdlstrtdt        = sy-datum
*     sdlstrttm        = sy-uzeit
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    g_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcr_auto_res_rej_batch_e186
*--*BOC OTCM-29655 Prabhu ED2K922320 3/08/2021
                               WITH s_vkorg = s_vkorg[]
*--*EOC OTCM-29655 Prabhu ED2K922320 3/08/2021
                               WITH s_vbeln  = s_vbeln[]
                               WITH s_type   = s_type[]
                               WITH s_date   = s_date[]
                               WITH s_matnr  = s_matnr[]
                               WITH s_pro    = s_pro[]
                               WITH s_c_date = s_c_date[]
                               WITH s_mail   = s_mail[]
*--*BOC OTCM-29655 Prabhu ED2K922320 3/08/2021
                               WITH s_it_cat = s_it_cat[]
                               WITH p_excl = p_excl
*--*EOC OTCM-29655 Prabhu ED2K922320 3/08/2021
                               WITH p_job    = p_job
                               USER 'QTC_BATCH01'
                               VIA JOB lv_job_name NUMBER lv_job_number
                               AND RETURN.
** close the background job for successor jobs
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

** if job is closed sucessfully, pass the job name and job count
** as previous job name and count for next job.
    IF sy-subrc EQ 0.
      PERFORM f_display_message USING lv_job_name.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      MESSAGE e000(zrtr_r1b) WITH text-027. " & & & & "Job could not be created
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_UPDATE_WITH_NEW_VALUE
*----------------------------------------------------------------------*
FORM f_bapi_update_with_new_value   TABLES  fp_vkorg STRUCTURE  edm_vkorg_range
                                            fp_item_catg STRUCTURE rjh_pstyv_rng
                                    USING fp_vbeln TYPE tt_sel_opt "##NEEDED.
                                          fp_type  TYPE tt_sel_opt"##NEEDED.
                                          fp_date  TYPE tt_sel_opt"##NEEDED.
                                          fp_matnr TYPE tt_sel_opt "##NEEDED.
                                          fp_pro   TYPE tt_sel_opt "##NEEDED.
                                          fp_c_date  TYPE tt_sel_opt"##NEEDED.
                                          fp_mail   "TYPE tt_sel_opt "##NEEDED.
                                          fp_job   "##NEEDED.
                                           fp_excl TYPE c
                                 CHANGING p_i_mail TYPE tt_sel_opt
                                          lv_lines TYPE i.
*--*BOC OTCM-29655 Prabhu ED2K922320 3/08/2021
  s_vkorg[] = fp_vkorg[].
  s_it_cat[]      = fp_item_catg[].
  p_excl   = fp_excl.
*--*EOC OTCM-29655 Prabhu ED2K922320 3/08/2021
  li_mail[]       = p_i_mail[].
  p_job           = fp_job.
  s_vbeln[]       = fp_vbeln[].
  s_type[]        = fp_type[].
  s_date[]        = fp_date[].
  s_matnr[]       = fp_matnr[].
  s_pro[]         = fp_pro[].
  s_c_date[]      = fp_c_date[].


* Get the data from the CDS view
  PERFORM f_get_data.
  IF gi_vbap[] IS NOT INITIAL.
    PERFORM f_update_rescd_via_bapi USING gi_vbap.
  ENDIF.
  PERFORM f_send_log_email CHANGING lv_lines.
ENDFORM.
*====================================================================*
**FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
**  SET PF-STATUS 'ZQTC_SUBS_ALV'.
**ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*      To send the email to the selected recepients
*----------------------------------------------------------------------*
FORM f_send_log_email CHANGING lv_lines TYPE i..
*-  Populate table with details to be entered into .xls file
  PERFORM build_batch_log_data .
*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage =      text-009. "Dear User,
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage =      text-010. "The job for applying “Reason for Rejection” to cancelled contracts is complete.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

* Populate the body based on the data available
  IF gi_vbap IS NOT INITIAL.

    st_imessage = text-011. "Attached are the success and failure records in the excel/tab delimited file.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.

    CONCATENATE 'JOB NAME:' p_job INTO st_imessage SEPARATED BY space.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
  ELSE.
* Populate a different body as there is no data available
    st_imessage =    text-012. "No data found for the given selection criteria.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
  ENDIF.
  st_imessage = text-013. "** Please do not reply to this email, as we are unable to respond from this address
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Send file by email as .xls speadsheet
  PERFORM send_csv_xls_log CHANGING lv_lines.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*      To send the excel attachment via email
*----------------------------------------------------------------------*
FORM send_csv_xls_log CHANGING lv_lines TYPE i.
  DATA: lst_xdocdata             LIKE sodocchgi1,
        lv_file_name             TYPE char100,
        lv_lines_success(15)     TYPE n,
        lv_lines_success_tmp(15) TYPE c,
        lv_lines_error(15)       TYPE n,
        lv_lines_error_tmp(15)   TYPE c,
        lst_usr21                TYPE usr21,
        lst_adr6                 TYPE adr6,
        lv_p_mail                LIKE LINE OF s_mail,
        lv_total                 TYPE n.

* Fill the document data.
  lst_xdocdata-doc_size = 1.
  g_job_name = p_job.

  DESCRIBE TABLE i_attach_total   LINES lv_total.
  lv_lines = lv_total.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach_total INDEX lv_total.
  lst_xdocdata-doc_size =
     ( lv_total - 1 ) * 255 + strlen( i_attach_total ).

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt.
  IF sy-sysid  = c_ep1.  " EP1
    lst_xdocdata-obj_descr = text-014. "Automate Reason for Rejection Job Update
  ELSE.
    lst_xdocdata-obj_descr = text-014 && ` ` && ':' && ` ` && sy-sysid. "Automate Reason for Rejection Job Update
  ENDIF.

  CLEAR i_attachment.
  REFRESH i_attachment.
  i_attachment[] = i_attach_total[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw. " RAW
  APPEND i_packing_list.

  IF gi_vbap IS NOT INITIAL.
    CLEAR: lv_lines_success,lv_lines_success_tmp.
    DESCRIBE TABLE i_attach_success LINES lv_lines_success.
    lv_lines_success_tmp = lv_lines_success - 1.
    CONDENSE lv_lines_success_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_success_tmp GE 1.
*- Create attachment notification
      i_packing_list-transf_bin = c_x.
      i_packing_list-head_start = 1.
      i_packing_list-head_num   = 1.
      i_packing_list-body_start = 1.

      CLEAR lv_file_name.
      CONCATENATE text-004 sy-datum sy-uzeit INTO i_packing_list-obj_descr SEPARATED BY c_underscore. "Success
      i_packing_list-doc_type   =  c_xls.
      i_packing_list-obj_name   =  text-004.
      i_packing_list-body_num   =  lv_lines_success.
      i_packing_list-doc_size   =  lv_lines_success * 255.
      APPEND i_packing_list.
    ENDIF.
    CLEAR : lv_lines_error,lv_lines_error_tmp.
    DESCRIBE TABLE i_attach_error LINES lv_lines_error.
    lv_lines_error_tmp = lv_lines_error - 1.
    CONDENSE lv_lines_error_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_error_tmp  GE 1.
*- Create attachment notification
      i_packing_list-transf_bin = c_x.
      i_packing_list-head_start = 1.
      i_packing_list-head_num   = 1.
      i_packing_list-body_start = lv_lines_success + 1.

      CLEAR lv_file_name.
      CONCATENATE text-005 sy-datum sy-uzeit INTO i_packing_list-obj_descr SEPARATED BY c_underscore. "Error
      i_packing_list-doc_type   =  c_xls. " 'XLS'.
      i_packing_list-obj_name   =  text-005.
      i_packing_list-body_num   =  lv_lines_error.
      i_packing_list-doc_size   =  lv_lines_error * 255.
      APPEND i_packing_list.
    ENDIF.
  ENDIF.
  IF li_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT li_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver   = lv_p_mail-low.
      i_receivers-rec_type   = c_u.
      i_receivers-com_type   = c_int. " INT
      i_receivers-notif_del  = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ELSE.
    CLEAR : lst_usr21,lst_adr6.
    SELECT SINGLE * FROM usr21 INTO lst_usr21 WHERE bname = sy-uname.
    IF lst_usr21 IS NOT INITIAL.
      SELECT SINGLE * FROM adr6 INTO lst_adr6 WHERE addrnumber = lst_usr21-addrnumber
                                              AND   persnumber = lst_usr21-persnumber.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.
    REFRESH i_receivers.
    i_receivers-receiver   = lst_adr6-smtp_addr.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int." INT.
    i_receivers-notif_del  = c_x.
    i_receivers-notif_ndel = c_x.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
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
  IF sy-subrc NE 0.
    MESSAGE text-033 TYPE c_i."Error in sending Email
  ELSE.
    MESSAGE text-034 TYPE c_s. "Email sent with Success log file
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_JOB_NAME  text
*----------------------------------------------------------------------*
FORM f_display_message  USING    p_lv_job_name.
  TYPE-POOLS : slis.
  TYPES : BEGIN OF ty_tab,
            job(32) TYPE c,
            user    TYPE sy-uname,
            date    TYPE sy-datum,
            time    TYPE sy-uzeit,
          END OF ty_tab.
  DATA : li_tab     TYPE STANDARD TABLE OF ty_tab,
         lst_tab    TYPE ty_tab,
         li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = c_x.
  lst_layout-zebra = c_x.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'JOB'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = text-015. "JOB Name
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'USER'.
  lst_fcat-tabname        = 'LI_TAB'.
  lst_fcat-seltext_m      = text-016. "User Name
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname   = 'DATE'.
  lst_fcat-tabname  = 'LI_TAB'.
  lst_fcat-seltext_m      = text-017. "Scheduled Date
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname    = 'TIME'.
  lst_fcat-tabname      = 'LI_TAB'.
  lst_fcat-seltext_m    = text-006. "Scheduled Time
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_tab-job  = p_lv_job_name.
  lst_tab-user = sy-uname.
  lst_tab-date = sy-datum.
  lst_tab-time = sy-uzeit.
  APPEND lst_tab TO li_tab.
  CLEAR lst_tab.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-007
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = li_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    " Nothing to do here
  ENDIF.
  REFRESH : li_fcat,
            li_tab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_BATCH_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_batch_log_data .
  DATA lv_res_text(100) TYPE c.
*- For Final Records
  SORT gi_output BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM gi_output COMPARING vbeln posnr.
  IF gi_output[] IS NOT INITIAL.
    SELECT * FROM tvagt INTO TABLE li_tvagt
                        FOR ALL ENTRIES IN gi_output
                        WHERE spras = sy-langu
                        AND   abgru = gi_output-vkuegru.
    SORT li_tvagt  BY spras abgru.
  ENDIF.
  LOOP AT gi_output INTO DATA(lst_output) WHERE type = c_s.
*- For Final Records
    IF i_attach_success[] IS INITIAL.
      CONCATENATE text-018 text-019 text-020 text-021
          INTO i_attach_success SEPARATED BY con_tab. "c_separator."con_tab.
      CONCATENATE con_cret i_attach_success INTO i_attach_success.
      APPEND i_attach_success.
      CONCATENATE text-018 text-019 text-020 text-021
          INTO i_attach_total SEPARATED BY con_tab."c_separator."con_tab.
      CONCATENATE con_cret i_attach_total INTO i_attach_total.
      APPEND i_attach_total.
    ENDIF.
    READ TABLE li_tvagt INTO DATA(lst_tvagt) WITH KEY spras = sy-langu
                                                      abgru = lst_output-vkuegru
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR lv_res_text.
      CONCATENATE lst_output-vkuegru lst_tvagt-bezei INTO lv_res_text SEPARATED BY space.
    ENDIF.
    CONCATENATE  lst_output-vbeln        lst_output-posnr
                 lv_res_text             lv_res_text
             INTO i_attach_success SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_success  INTO i_attach_success.
    APPEND  i_attach_success.

    CONCATENATE  lst_output-vbeln        lst_output-posnr
                 lv_res_text             lv_res_text
             INTO i_attach_total SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_total  INTO i_attach_total.
    APPEND  i_attach_total.

  ENDLOOP.

  LOOP AT gi_output INTO DATA(lstt_output) WHERE type = c_e.

*- For Final Records
** If the error table is already not populated
    IF i_attach_error[] IS INITIAL.
      CONCATENATE text-018 text-019 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO i_attach_error SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_error INTO i_attach_error.
      APPEND  i_attach_error.
      CONCATENATE text-018 text-019 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO i_attach_total SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_total INTO i_attach_total.
      APPEND  i_attach_total.
    ENDIF.

    READ TABLE li_tvagt INTO DATA(lst_tvagt_t) WITH KEY spras = sy-langu
                                                      abgru = lst_output-vkuegru
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR lv_res_text.
      CONCATENATE lst_output-vkuegru lst_tvagt_t-bezei INTO lv_res_text SEPARATED BY space.
    ENDIF.
    CONCATENATE  lstt_output-vbeln          lstt_output-posnr
                 lv_res_text                lstt_output-vkuesch
                 lstt_output-veindat        lstt_output-vwundat
                 lstt_output-id             lstt_output-message
             INTO i_attach_error SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_error  INTO i_attach_error.
    APPEND  i_attach_error.
    CONCATENATE  lstt_output-vbeln        lstt_output-posnr
                 lv_res_text                lstt_output-vkuesch
                 lstt_output-veindat        lstt_output-vwundat
                 lstt_output-id        lstt_output-message
             INTO i_attach_total SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_total  INTO i_attach_total.
    APPEND  i_attach_total.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RESCD_VIA_BAPI
*----------------------------------------------------------------------*
FORM f_update_rescd_via_bapi  USING fp_li_vbap   TYPE tt_cds_e186.

  DATA: lst_vbap    TYPE zqtc_cds_e186,
        lv_vbeln    TYPE vbeln,
        lst_output  TYPE ty_output,
        lst_return  TYPE bapiret2,
        lst_att_err TYPE so_text255,
        lst_text    TYPE so_text255.

  CLEAR: i_attach_error,lst_text.
  REFRESH:i_attach_error[], i_attach_success[],i_attach_total[].
  LOOP AT fp_li_vbap INTO lst_vbap.

* If VBAP-ABGRU exists and if VBAP-ABGRU <> VEDA-VKUEGRU, then log the item into error excel.
    IF lst_vbap-abgru IS NOT INITIAL AND lst_vbap-abgru <> lst_vbap-vkuegru OR lst_vbap-vkuegru IS INITIAL.

      CONCATENATE text-018 text-019 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO lst_att_err SEPARATED BY c_separator.

      CONCATENATE con_cret lst_att_err INTO i_attach_error.
      APPEND lst_att_err TO i_attach_error.
      IF lst_vbap-vkuegru IS INITIAL.
        lst_text = text-028. "Maintian Reason for cancel. in Contact Tab
      ELSE.
        lst_text  = text-003.
      ENDIF.
      CONCATENATE  lst_vbap-vbeln
                   lst_vbap-posnr
                   lst_vbap-vkuesch
                   lst_vbap-vkuegru
                   lst_vbap-veindat
                   lst_vbap-vwundat
                   ''
                   lst_text "Mismatch in reason codes at Sales A and Contract data
               INTO lst_att_err SEPARATED BY c_separator.
      CONCATENATE con_cret lst_att_err  INTO i_attach_error.
      APPEND lst_att_err TO i_attach_error.
      CLEAR lst_att_err.

      CONTINUE. " Ignore this line item and proceed to the next item
    ENDIF.

    lv_vbeln = lst_vbap-vbeln.
*   Populate value in order Item
    lst_bapisditm-itm_number = lst_vbap-posnr.
    lst_bapisditm-reason_rej = lst_vbap-vkuegru.
    APPEND lst_bapisditm TO li_bapisditm.
    CLEAR lst_bapisditm.

*   Populate value in order Item Index
    lst_bapisditmx-updateflag = c_u.
    lst_bapisditmx-itm_number = lst_vbap-posnr.
    lst_bapisditmx-reason_rej = abap_true.
    APPEND lst_bapisditmx TO li_bapisditmx.
    CLEAR lst_bapisditmx.

*   Populate value in order header
    lst_bapisdh1x-updateflag = c_u.

    AT END OF vbeln.
*     Update rejection reason for credit memo request when rejected
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lv_vbeln
          order_header_inx = lst_bapisdh1x
        TABLES
          return           = li_return
          order_item_in    = li_bapisditm
          order_item_inx   = li_bapisditmx.

      IF NOT li_return IS INITIAL.
        READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_e.
        IF sy-subrc = 0.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_a.
          IF sy-subrc = 0.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .
          ENDIF.
        ENDIF.
        REFRESH:li_return_tmp[].
        li_return_tmp[]  =  li_return[].
        SORT li_return_tmp BY type.
        DELETE li_return_tmp WHERE type NE c_e.
        CLEAR lst_return.
        IF li_return_tmp[] IS NOT INITIAL.
          LOOP AT li_return INTO lst_return WHERE type = c_e.
            READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln.
            IF sy-subrc = 0.
              lst_output-vbeln      = lst_vbap-vbeln.    " Sales Document Number
              lst_output-posnr      = lst_vbap-posnr.    " Line Item Number
              lst_output-auart      = lst_vbap-auart.    " Sales Document Type
              lst_output-vkuegru    = lst_vbap-vkuegru.  " Reason for Cancellation of Contract
              lst_output-vkuesch    = lst_vbap-vkuesch.  " Assignment cancellation procedure/cancellation rule
              lst_output-veindat    = lst_vbap-veindat.  " Date on which cancellation request was received
              lst_output-vwundat    = lst_vbap-vwundat.  " Requested cancellation date
              lst_output-id         = lst_return-id.
              lst_output-type       = lst_return-type.
              lst_output-number     = lst_return-number.
              lst_output-message    = lst_return-message.
              lst_output-message_v1 = lst_return-message_v1.
              lst_output-message_v2 = lst_return-message_v2.
              lst_output-message_v3 = lst_return-message_v3.
              lst_output-message_v4 = lst_return-message_v4.
              APPEND lst_output TO gi_output.
              CLEAR: lst_return,
                     lst_output,
                     lst_vbap.
            ENDIF.
          ENDLOOP.
        ELSE.
          LOOP AT li_return INTO lst_return WHERE type = c_s.
            READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln
                                                         posnr = lst_return-message_v2.
            IF sy-subrc = 0.
              lst_output-vbeln      = lst_vbap-vbeln.    " Sales Document Number
              lst_output-posnr      = lst_vbap-posnr.    " Line Item Number
              lst_output-auart      = lst_vbap-auart.    " Sales Document Type
              lst_output-vkuegru    = lst_vbap-vkuegru.  " Reason for Cancellation of Contract
              lst_output-vkuesch    = lst_vbap-vkuesch.  " Assignment cancellation procedure/cancellation rule
              lst_output-veindat    = lst_vbap-veindat.  " Date on which cancellation request was received
              lst_output-vwundat    = lst_vbap-vwundat.  " Requested cancellation date
              lst_output-id         = lst_return-id.
              lst_output-type       = lst_return-type.
              lst_output-number     = lst_return-number.
              lst_output-message_v1 = lst_return-message_v1.
              lst_output-message_v2 = lst_return-message_v2.
              lst_output-message_v3 = lst_return-message_v3.
              lst_output-message_v4 = lst_return-message_v4.
              APPEND lst_output TO gi_output.
            ENDIF.
*          ENDIF.
            CLEAR: lst_return,
                   lst_output,
                   lst_vbap.
          ENDLOOP.  " LOOP AT li_return INTO lst_return.
        ENDIF.
      ENDIF. " IF NOT li_return IS INITIAL
      CLEAR: li_bapisditm,
             li_bapisditmx,
             lst_bapisdh1x,
             li_return,
             lv_vbeln.
    ENDAT.  " AT END OF vbeln.
  ENDLOOP. " LOOP AT f_li_vbap INTO lst_vbap.
ENDFORM.               " F_UPDATE_RESCD_VIA_BAPI
*&---------------------------------------------------------------------*
*&      Form  F_VAL_DOCTYPE
*----------------------------------------------------------------------*
FORM f_val_doctype .
  SELECT auart
     INTO TABLE @DATA(lt_auart)
     FROM tvak
     WHERE auart IN @s_type.
  IF sy-subrc NE 0.
    MESSAGE e000 WITH 'Please Enter a Valid Document Type'(006).
  ENDIF.


ENDFORM.
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_OUTPUT
*&---------------------------------------------------------------------*
FORM f_screen_output.
  CONSTANTS: lc_m1 TYPE char2    VALUE 'M1',       "Modif ID M1
             lc_m2 TYPE char2    VALUE 'M2'.       "Modif ID M2
  IF rb_1 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = lc_m2.
        screen-input = screen-output = screen-active = '0'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSEIF rb_2 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = lc_m1.
        screen-input = screen-output = screen-active = '0'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION_APL
*&---------------------------------------------------------------------*
FORM f_initialization_apl.
  REFRESH: i_vbap_apl,
           li_mail,
           i_message,
           i_attach_total,
           i_packing_list,
           i_receivers,
           i_attachment,
           i_output_apl.
  CLEAR:  st_imessage.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS_APL
*&---------------------------------------------------------------------*
FORM f_screen_dynamics_apl.

* Local Variables Declaration
  DATA: lv_days     TYPE i.       " Days

* Local Constants Declarations
  CONSTANTS:
    lc_id_e505   TYPE zdevid     VALUE 'E505',          " Development ID
    lc_from_date TYPE rvari_vnam VALUE 'DOC_FROM_DATE', " ABAP: Name of Variant Variable
    lc_auart     TYPE rvari_vnam VALUE 'AUART',         " ABAP: Name of Variant Variable
    lc_email     TYPE rvari_vnam VALUE 'EMAIL',         " ABAP: Name of Variant Variable
    lc_vkorg     TYPE rvari_vnam VALUE 'VKORG',         " ABAP: Name of Variant Variable
    lc_abgru     TYPE rvari_vnam VALUE 'ABGRU',         " ABAP: Name of Variant Variable
    lc_i         TYPE char1      VALUE 'I',             " For Sign
    lc_eq        TYPE char2      VALUE 'EQ',            " For Option
    lc_le        TYPE char2      VALUE 'LE'.            " For option

* Fetch the constants
  SELECT devid                                                  "Development ID
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "ABAP: Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                    "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant                                            "Wiley Application Constant Table
    INTO TABLE i_const_apl
    WHERE devid    EQ lc_id_e505
     AND  activate EQ abap_true.
  IF sy-subrc EQ 0.
    LOOP AT i_const_apl INTO DATA(lst_const_apl).
      CASE lst_const_apl-param1.
        WHEN lc_vkorg.     " VKORG
* populate the default sales organization
          s_sorg-sign   = lst_const_apl-sign.
          s_sorg-option = lst_const_apl-opti.
          s_sorg-low    = lst_const_apl-low.
          APPEND s_sorg.

        WHEN lc_auart.     " AUART
* populate the default order types
          s_auart-sign   = lst_const_apl-sign.
          s_auart-option = lst_const_apl-opti.
          s_auart-low    = lst_const_apl-low.
          APPEND s_auart.

        WHEN lc_from_date. " 'DOC_FROM_DATE'.
          MOVE lst_const_apl-low TO lv_days.
          s_erdat-sign   = lc_i.
          s_erdat-option = lst_const_apl-opti.
          s_erdat-low    = sy-datum - lv_days.
          APPEND s_erdat.

        WHEN lc_email.  " Email
* Populate the default Email ID's
          s_email-sign   = lst_const_apl-sign.
          s_email-option = lst_const_apl-opti.
          s_email-low    = lst_const_apl-low.
          APPEND s_email.

        WHEN lc_abgru.  " ABGRU
* Populate the default Reason for rejection.
          p_abgru = lst_const_apl-low.
        WHEN OTHERS.
      ENDCASE.
      CLEAR: lst_const_apl.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BATCH_JOB_APL
*&---------------------------------------------------------------------*
FORM f_batch_job_apl .
  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status
* Local constant declaration
  CONSTANTS: lc_job_name_apl   TYPE btcjob VALUE 'ZAUTO_REJ_RES_APL'. " Background job name
  CLEAR lv_job_name.
  CONCATENATE lc_job_name_apl c_underscore sy-uzeit c_underscore sy-datum  INTO lv_job_name.

  lv_user = sy-uname.
**Check if pre. Job name and job count is present
**then set the check pre. status to X else blank.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
*     sdlstrtdt        = sy-datum
*     sdlstrttm        = sy-uzeit
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    g_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcr_auto_res_rej_batch_e505
                               WITH s_sorg   = s_sorg[]
                               WITH s_auart  = s_auart[]
                               WITH s_doc    = s_doc[]
                               WITH s_sld_to = s_sld_to[]
                               WITH s_shp_to = s_shp_to[]
                               WITH s_matnr  = s_matnr[]
                               WITH s_erdat  = s_erdat[]
                               WITH p_abgru  = p_abgru
                               WITH s_email  = s_email[]
                               WITH p_job    = p_job
                               USER 'QTC_BATCH01'
                               VIA JOB lv_job_name NUMBER lv_job_number
                               AND RETURN.
** close the background job for successor jobs
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

** if job is closed sucessfully, pass the job name and job count
** as previous job name and count for next job.
    IF sy-subrc EQ 0.
      PERFORM f_display_message USING lv_job_name.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      MESSAGE e000(zrtr_r1b) WITH text-027. " & & & & "Job could not be created
    ENDIF. " IF sy-subrc EQ 0
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_UPDATE_NEW_VALUE_APl
*----------------------------------------------------------------------*
FORM f_bapi_update_new_value_apl   TABLES fp_vkorg STRUCTURE  edm_vkorg_range
                                    USING fp_vbeln TYPE tt_sel_opt "##NEEDED.
                                          fp_type  TYPE tt_sel_opt"##NEEDED.
                                          fp_date  TYPE tt_sel_opt"##NEEDED.
                                          fp_matnr TYPE tt_sel_opt "##NEEDED.
                                          fp_sld_to TYPE tt_sel_opt "##NEEDED.
                                          fp_shp_to TYPE tt_sel_opt "##NEEDED.
                                          fp_abgru "##NEEDED.
                                          fp_mail  "##NEEDED.
                                          fp_job   "##NEEDED.
                                 CHANGING p_i_mail TYPE tt_sel_opt
                                          lv_lines TYPE i.

  s_sorg[]        = fp_vkorg[].
  li_mail[]       = p_i_mail[].
  p_job           = fp_job.
  s_doc[]         = fp_vbeln[].
  s_auart[]       = fp_type[].
  s_erdat[]       = fp_date[].
  s_mat[]         = fp_matnr[].
  s_sld_to[]      = fp_sld_to[].
  s_shp_to[]      = fp_shp_to[].
  p_abgru         = fp_abgru.

* Get the data from the CDS view
  PERFORM f_get_data_apl.
  IF i_vbap_apl[] IS NOT INITIAL.
    PERFORM f_update_rescd_via_bapi_apl USING i_vbap_apl.
  ENDIF.
  IF sy-batch EQ abap_true.
    PERFORM f_send_log_email_apl CHANGING lv_lines.
  ELSE.
    IF i_output_apl[] IS INITIAL.
* No Data for the given selection
      MESSAGE i000 WITH text-002 DISPLAY LIKE c_e. "No Data available for the Selection Criteria.
      LEAVE LIST-PROCESSING.
      RETURN.
    ELSE.
      PERFORM f_display_output.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_APL
*&---------------------------------------------------------------------*
FORM f_get_data_apl .
  TYPES:BEGIN OF ty_vbpa,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          parvw TYPE parvw,
          kunnr TYPE kunnr,
        END OF ty_vbpa.

  DATA:li_vbap TYPE TABLE OF zqtc_cds_e505,
       li_vbpa TYPE TABLE OF ty_vbpa.
  CONSTANTS:lc_we TYPE parvw VALUE 'WE'. " Ship to Party

** Fetch the data from CDS View
  SELECT mandt,
         vbeln,
         posnr,
         erdat,
         auart,
         vkorg,
         kunnr,
         matnr,
         abgru,
         wmeng,
         bmeng FROM zqtc_cds_e505
            INTO TABLE @li_vbap
            WHERE vkorg   IN @s_sorg
            AND   vbeln   IN @s_doc
            AND   auart   IN @s_auart
            AND   kunnr   IN @s_sld_to
            AND   erdat   IN @s_erdat
            AND   matnr   IN @s_mat.
  IF sy-subrc = 0.
    SORT li_vbap BY vbeln posnr.
** If Ship to party is given in the input then filter the Sales orders based on Ship to party
    IF s_shp_to[] IS INITIAL.
      i_vbap_apl[] = li_vbap[].
    ELSE.
      SELECT vbeln,
             posnr,
             parvw,
             kunnr FROM vbpa INTO TABLE @li_vbpa FOR ALL ENTRIES IN @li_vbap
             WHERE vbeln EQ @li_vbap-vbeln AND
                   parvw EQ @lc_we AND
                   kunnr IN @s_shp_to.
      IF sy-subrc IS INITIAL.
        SORT li_vbpa BY vbeln.
      ENDIF.
      LOOP AT li_vbap INTO DATA(ls_vbap).
        READ TABLE li_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = ls_vbap-vbeln BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          APPEND ls_vbap TO i_vbap_apl.
          CLEAR ls_vbap.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  IF i_vbap_apl[] IS INITIAL.
* No Data for the given selection
    MESSAGE i000 WITH text-002 DISPLAY LIKE c_e. "No Data available for the Selection Criteria.
    LEAVE LIST-PROCESSING.
    RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RESCD_VIA_BAPI_APL
*&---------------------------------------------------------------------*
FORM f_update_rescd_via_bapi_apl  USING fp_li_vbap TYPE tt_cds_e505.
  DATA: lv_vbeln       TYPE vbeln,
        lst_output_apl TYPE ty_output_apl,
        lst_return     TYPE bapiret2.

  CONSTANTS:lc_fail(4)    TYPE c VALUE 'Fail',
            lc_success(7) TYPE c VALUE 'Success'.
  SORT fp_li_vbap[] BY vbeln.
  LOOP AT fp_li_vbap INTO DATA(lst_vbap).
** Check if order quantity and confirmed quantity both are same, If yes then skip that sales order for processing
    IF lst_vbap-wmeng EQ lst_vbap-bmeng.
      CONTINUE.
    ENDIF.
    lv_vbeln = lst_vbap-vbeln.
*   Populate value in order Item
    lst_bapisditm-itm_number = lst_vbap-posnr.
    lst_bapisditm-reason_rej = p_abgru.
    APPEND lst_bapisditm TO li_bapisditm.
    CLEAR lst_bapisditm.

*   Populate value in order Item Index
    lst_bapisditmx-updateflag = c_u.
    lst_bapisditmx-itm_number = lst_vbap-posnr.
    lst_bapisditmx-reason_rej = abap_true.
    APPEND lst_bapisditmx TO li_bapisditmx.
    CLEAR lst_bapisditmx.

*   Populate value in order header
    lst_bapisdh1x-updateflag = c_u.

    AT END OF vbeln.
*     Update rejection reason for credit memo request when rejected
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lv_vbeln
          order_header_inx = lst_bapisdh1x
        TABLES
          return           = li_return
          order_item_in    = li_bapisditm
          order_item_inx   = li_bapisditmx.

      IF NOT li_return[] IS INITIAL.
        READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_e.
        IF sy-subrc = 0.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_a.
          IF sy-subrc = 0.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .
          ENDIF.
        ENDIF.
        REFRESH:li_return_tmp[].
        li_return_tmp[]  =  li_return[].
        SORT li_return_tmp BY type.
        DELETE li_return_tmp WHERE type NE c_e.
        CLEAR lst_return.
        IF li_return_tmp[] IS NOT INITIAL.
          LOOP AT li_return INTO lst_return WHERE type = c_e.
            READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln.
            IF sy-subrc = 0.
              lst_output_apl-vbeln      = lst_vbap-vbeln.    " Sales Document Number
              lst_output_apl-posnr      = lst_vbap-posnr.    " Line Item Number
              lst_output_apl-wmeng      = lst_vbap-wmeng.    " Order Quantity
              lst_output_apl-bmeng      = lst_vbap-bmeng.    " Confirmed Quantity
              lst_output_apl-bo_quant   = lst_vbap-wmeng - lst_vbap-bmeng.    " Back order Quantity
              lst_output_apl-abgru      = p_abgru.           " Reason for Rejection
              lst_output_apl-id         = lst_return-id.
              lst_output_apl-type       = lst_return-type.
              lst_output_apl-number     = lst_return-number.
              lst_output_apl-message    = lst_return-message.
              lst_output_apl-message_v1 = lst_return-message_v1.
              lst_output_apl-message_v2 = lst_return-message_v2.
              lst_output_apl-message_v3 = lst_return-message_v3.
              lst_output_apl-message_v4 = lst_return-message_v4.
              lst_output_apl-status     = lc_fail.               "Fail
              APPEND lst_output_apl TO i_output_apl.
              CLEAR: lst_return,
                     lst_output_apl,
                     lst_vbap.
            ENDIF.
          ENDLOOP.
        ELSE.
          LOOP AT li_return INTO lst_return WHERE type = c_s.
            READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln
                                                         posnr = lst_return-message_v2.
            IF sy-subrc = 0.
              lst_output_apl-vbeln      = lst_vbap-vbeln.    " Sales Document Number
              lst_output_apl-posnr      = lst_vbap-posnr.    " Line Item Number
              lst_output_apl-wmeng      = lst_vbap-wmeng.    " Order Quantity
              lst_output_apl-bmeng      = lst_vbap-bmeng.    " Confirmed Quantity
              lst_output_apl-bo_quant   = lst_vbap-wmeng - lst_vbap-bmeng.    " Back order Quantity
              lst_output_apl-abgru      = p_abgru.           " Reason for Rejection
              lst_output_apl-id         = lst_return-id.
              lst_output_apl-type       = lst_return-type.
              lst_output_apl-number     = lst_return-number.
              lst_output_apl-message    = text-054.          " Reason for Rejection updated for the Sales order
              lst_output_apl-message_v1 = lst_return-message_v1.
              lst_output_apl-message_v2 = lst_return-message_v2.
              lst_output_apl-message_v3 = lst_return-message_v3.
              lst_output_apl-message_v4 = lst_return-message_v4.
              lst_output_apl-status     = lc_success.            "Success
              APPEND lst_output_apl TO i_output_apl.
            ENDIF.
            CLEAR: lst_return,
                   lst_output_apl,
                   lst_vbap.
          ENDLOOP.  " LOOP AT li_return INTO lst_return.
        ENDIF.
      ENDIF. " IF NOT li_return IS INITIAL
      CLEAR: li_bapisditm[],
             li_bapisditmx[],
             lst_bapisdh1x,
             li_return[],
             lv_vbeln.
    ENDAT.  " AT END OF vbeln.
  ENDLOOP. " LOOP AT f_li_vbap INTO lst_vbap.
  IF i_output_apl[] IS NOT INITIAL.
    SORT i_output_apl BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM i_output_apl COMPARING vbeln posnr.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MANDATORY_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mandatory_check .

  IF s_sorg[] IS INITIAL.
    MESSAGE i000 WITH text-042 DISPLAY LIKE c_e. "Mandatory field Sales Organization is missing.
    LEAVE LIST-PROCESSING.
  ELSEIF s_auart[] IS INITIAL.
    MESSAGE i000 WITH text-043 DISPLAY LIKE c_e. "Mandatory field Sales Document type is missing.
    LEAVE LIST-PROCESSING.
  ELSEIF s_sld_to[] IS INITIAL.
    MESSAGE i000 WITH text-044 DISPLAY LIKE c_e. "Mandatory field Sold to Party is missing.
    LEAVE LIST-PROCESSING.
  ELSEIF p_abgru IS INITIAL.
    MESSAGE i000 WITH text-058 DISPLAY LIKE c_e. "Mandatory field Reason for rejection is missing.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL_APL
*&---------------------------------------------------------------------*
FORM f_send_log_email_apl  CHANGING lv_lines TYPE i.
*-  Populate table with details to be entered into .xls file
  PERFORM build_batch_log_data_apl.
*- Populate message body text
  CLEAR i_message.   REFRESH i_message.
  st_imessage =      text-009. "Dear User,
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

  st_imessage =      text-055. "Please find attached the list of orders with the cancellation status due to stock availability.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

* Populate the body based on the data available
  IF i_vbap_apl IS NOT INITIAL.

    st_imessage = text-011. "Attached are the success and failure records in the excel/tab delimited file.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.

    CONCATENATE 'JOB NAME:' p_job INTO st_imessage SEPARATED BY space.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
  ELSE.
* Populate a different body as there is no data available
    st_imessage =    text-012. "No data found for the given selection criteria.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
    APPEND st_imessage TO i_message.
    CLEAR st_imessage.
  ENDIF.
  st_imessage = text-013. "** Please do not reply to this email, as we are unable to respond from this address
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.
  APPEND st_imessage TO i_message.
  CLEAR st_imessage.

*- Send file by email as .xls speadsheet
  PERFORM send_csv_xls_log_apl CHANGING lv_lines.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_BATCH_LOG_DATA_APL
*&---------------------------------------------------------------------*
FORM build_batch_log_data_apl.
  DATA :lv_res_text(100) TYPE c,
        lv_wmeng(15)     TYPE c,
        lv_bmeng(15)     TYPE c,
        lv_bo_quant(15)  TYPE c.
*- For Final Records
  SORT i_output_apl BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM i_output_apl COMPARING vbeln posnr.

  LOOP AT i_output_apl INTO DATA(lst_output_apl).
*- For Final Records
    IF i_attach_total[] IS INITIAL.
      CONCATENATE text-045 text-046 text-047 text-048
                  text-049 text-050 text-051 text-052
          INTO i_attach_total SEPARATED BY con_tab."c_separator."con_tab.
      CONCATENATE con_cret i_attach_total INTO i_attach_total.
      APPEND i_attach_total.
    ENDIF.
** Moving quantities to local character varaibles for concatenation
    MOVE :lst_output_apl-wmeng TO lv_wmeng,
          lst_output_apl-bmeng TO lv_bmeng,
          lst_output_apl-bo_quant TO lv_bo_quant.

    CONCATENATE  lst_output_apl-vbeln lst_output_apl-posnr lv_wmeng              lv_bmeng
                 lv_bo_quant          lst_output_apl-abgru lst_output_apl-status lst_output_apl-message
             INTO i_attach_total SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_total  INTO i_attach_total.
    APPEND  i_attach_total.
    CLEAR: lv_wmeng,lv_bmeng,lv_bo_quant.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_FOREGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_foreground.
* Type Declaration
  TYPES : BEGIN OF ty_mail,
            sign TYPE  tvarv_sign,                      " ABAP: ID: I/E (include/exclude values)
            opti TYPE  tvarv_opti,                      " ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE  salv_de_selopt_low,              " Lower Value of Selection Condition
            high TYPE  salv_de_selopt_high,             " Upper Value of Selection Condition
          END OF ty_mail.
  DATA : li_mail   TYPE STANDARD TABLE OF ty_mail,
         li_vbeln  TYPE STANDARD TABLE OF ty_mail,
         li_type   TYPE STANDARD TABLE OF ty_mail,
         li_date   TYPE STANDARD TABLE OF ty_mail,
         li_matnr  TYPE STANDARD TABLE OF ty_mail,
         li_sld_to TYPE STANDARD TABLE OF ty_mail,
         li_shp_to TYPE STANDARD TABLE OF ty_mail,
         lv_lines  TYPE i.

  li_mail[]   = s_email[].
  li_vbeln[]  = s_doc[].
  li_type[]   = s_auart[].
  li_date[]   = s_erdat[].
  li_matnr[]  = s_mat[].
  li_sld_to[] = s_sld_to[].
  li_shp_to[] = s_shp_to[].
  PERFORM f_bapi_update_new_value_apl TABLES s_sorg[]
                                      USING  li_vbeln[]
                                             li_type[]
                                             li_date[]
                                             li_matnr[]
                                             li_sld_to[]
                                             li_shp_to[]
                                             p_abgru
                                             s_email
                                             p_job
                                    CHANGING li_mail
                                             lv_lines.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
FORM f_display_output .
  TYPE-POOLS : slis.

  DATA : li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = c_x.
  lst_layout-zebra = c_x.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'VBELN'.
  lst_fcat-tabname        = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m      = text-045. "Sales Document
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname      = 'POSNR'.
  lst_fcat-tabname        = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m      = text-046. "Item
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname   = 'WMENG'.
  lst_fcat-tabname     = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m   = text-047.  "Order Quantity
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'BMENG'.
  lst_fcat-tabname      = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m    = text-048. "Confirmed Quantity
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'BO_QUANT'.
  lst_fcat-tabname      = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m    = text-049. "Backorder Quantity
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'ABGRU'.
  lst_fcat-tabname      = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m    = text-050. "Reason for Rejection
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'STATUS'.
  lst_fcat-tabname      = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m    = text-051. "Status
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'MESSAGE'.
  lst_fcat-tabname      = 'I_OUTPUT_APL'.
  lst_fcat-seltext_m    = text-052. "Notes
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-053 "Backorder Cancellation Result
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = i_output_apl
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    " Nothing to do here
  ENDIF.
  REFRESH : li_fcat,
            i_output_apl.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_CSV_XLS_LOG_APL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_LINES  text
*----------------------------------------------------------------------*
FORM send_csv_xls_log_apl  CHANGING lv_lines TYPE i.
  DATA: lst_xdocdata       LIKE sodocchgi1,
        lv_file_name       TYPE char100,
        lv_lines_total(15) TYPE n,
        lv_lines_tmp(15)   TYPE c,
        lv_p_mail          LIKE LINE OF s_mail,
        lv_total           TYPE n.

* Fill the document data.
  lst_xdocdata-doc_size = 1.
  g_job_name = p_job.

  DESCRIBE TABLE i_attach_total   LINES lv_total.
  lv_lines = lv_total.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach_total INDEX lv_total.
  lst_xdocdata-doc_size =
     ( lv_total - 1 ) * 255 + strlen( i_attach_total ).

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt.
  IF sy-sysid  = c_ep1.  " EP1
    lst_xdocdata-obj_descr = text-014. "Automate Reason for Rejection Job Update
  ELSE.
    lst_xdocdata-obj_descr = text-014 && ` ` && ':' && ` ` && sy-sysid. "Automate Reason for Rejection Job Update
  ENDIF.

  CLEAR i_attachment.
  REFRESH i_attachment.
  i_attachment[] = i_attach_total[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw. " RAW
  APPEND i_packing_list.

  IF i_vbap_apl IS NOT INITIAL.
    CLEAR: lv_lines_total,lv_lines_tmp.
    DESCRIBE TABLE i_attach_total LINES lv_lines_total.
    lv_lines_tmp = lv_lines_total - 1.
    CONDENSE lv_lines_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_tmp GE 1.
*- Create attachment notification
      i_packing_list-transf_bin = c_x.
      i_packing_list-head_start = 1.
      i_packing_list-head_num   = 1.
      i_packing_list-body_start = 1.

      CLEAR lv_file_name.
      CONCATENATE text-056 sy-datum sy-uzeit INTO i_packing_list-obj_descr SEPARATED BY c_underscore. "Backorder
      i_packing_list-doc_type   =  c_xls.
      i_packing_list-obj_name   =  text-004.
      i_packing_list-body_num   =  lv_lines_total.
      i_packing_list-doc_size   =  lv_lines_total * 255.
      APPEND i_packing_list.
    ENDIF.
  ENDIF.


  IF li_mail[] IS NOT INITIAL.
    CLEAR lv_p_mail.
    LOOP AT li_mail INTO lv_p_mail.
      CLEAR i_receivers.
      i_receivers-receiver   = lv_p_mail-low.
      i_receivers-rec_type   = c_u.
      i_receivers-com_type   = c_int. " INT
      i_receivers-notif_del  = c_x.
      i_receivers-notif_ndel = c_x.
      APPEND i_receivers.
      CLEAR lv_p_mail.
    ENDLOOP.
  ELSE.
    SELECT SINGLE addrnumber,
                  persnumber FROM usr21 INTO @DATA(lst_usr21) WHERE bname = @sy-uname.
    IF sy-subrc IS INITIAL.
      IF lst_usr21 IS NOT INITIAL.
        SELECT SINGLE addrnumber,
                      smtp_addr FROM adr6 INTO @DATA(lst_adr6) WHERE addrnumber = @lst_usr21-addrnumber "#EC CI_ALL_FIELDS_NEEDED
                                                               AND   persnumber = @lst_usr21-persnumber.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_adr6.
        ENDIF.
      ENDIF.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.
    REFRESH i_receivers.
    i_receivers-receiver   = lst_adr6-smtp_addr.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int." INT.
    i_receivers-notif_del  = c_x.
    i_receivers-notif_ndel = c_x.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = c_x
      commit_work                = c_x
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
  IF sy-subrc NE 0.
    MESSAGE text-033 TYPE c_i."Error in sending Email
  ELSE.
    MESSAGE text-034 TYPE c_s. "Email sent with Success log file
  ENDIF.
ENDFORM.
*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022
