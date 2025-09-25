*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_SUB (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-29655
* REFERENCE NO: ED2K915695
* DEVELOPER: Siva Guda (SGUDA)
* DATE: 12-21-2020
* DESCRIPTION: Auto rejection on release order
* 1) Add order type as VBAK-AUART in Excel file.
* 2) Change Mail Body
* 3) Add reason for rejection for subsequent documents.
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
    lc_pstyv     TYPE rvari_vnam VALUE 'PSTYV',         " Sales document item category " ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    lc_pstyv_srp TYPE rvari_vnam VALUE 'PSTYV_SRP'.     " Sales Document item category " ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
*break sguda.
*  REFRESH:s_type[],s_pro[],s_c_date[], s_date[],s_mail[].

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
          s_type-sign   = lc_i.
          s_type-option = lc_eq.
          s_type-low    = lst_const_v-low.
          APPEND s_type.

        WHEN lc_canc_pro.  " CAncellation Procedure
* Populate the default Cancellation Procedures
          s_pro-sign   = lc_i.
          s_pro-option = lc_eq.
          s_pro-low    = lst_const_v-low.
          APPEND s_pro.
        WHEN lc_email.  " Email
* Populate the default Email ID's
          s_mail-sign   = lc_i.
          s_mail-option = lc_eq.
          s_mail-low    = lst_const_v-low.
          APPEND s_mail.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
* Populate Sales document item category
        WHEN lc_pstyv.
          s_it_cat-sign   = lc_i.
          s_it_cat-option = lc_eq.
          s_it_cat-low    = lst_const_v-low.
          APPEND s_it_cat.
        WHEN lc_pstyv_srp.
          s_it_srp-sign   = lc_i.
          s_it_srp-option = lc_eq.
          s_it_srp-low    = lst_const_v-low.
          APPEND s_it_srp.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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

  SELECT * FROM zqtc_cds_e186
         INTO TABLE gi_vbap
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
         WHERE vkorg IN s_vkorg
         AND   vtweg IN s_vtweg
*         AND   spart IN s_spart
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
         AND   vbeln   IN s_vbeln
         AND   auart   IN s_type
         AND   erdat   IN s_date
         AND   matnr   IN s_matnr
         AND   vkuesch IN s_pro
         AND   vwundat IN s_c_date.
  IF sy-subrc = 0.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    gi_vbap_rel_order[] = gi_vbap[].
    SORT gi_vbap_rel_order BY vbelnorder posnrorder.
    DELETE gi_vbap_rel_order WHERE xorder_created NE c_x.
    DELETE ADJACENT DUPLICATES FROM gi_vbap_rel_order COMPARING vbelnorder posnrorder.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    SORT gi_vbap BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM gi_vbap COMPARING vbeln posnr.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    IF gi_vbap_rel_order[] IS NOT INITIAL.
      SELECT vbeln
             vbelp
         FROM ekkn
         INTO TABLE i_ekkn
         FOR ALL ENTRIES IN gi_vbap_rel_order
         WHERE vbeln = gi_vbap_rel_order-vbelnorder
         AND   vbelp = gi_vbap_rel_order-posnrorder.
      IF sy-subrc EQ 0.
        SORT i_ekkn BY vbeln vbelp.
      ELSE.
        CLEAR i_ekkn[].
      ENDIF.
      SELECT vbeln
             posnr
             lfsta
          FROM vbup
          INTO TABLE i_vbup
          FOR ALL ENTRIES IN gi_vbap_rel_order
          WHERE vbeln = gi_vbap_rel_order-vbelnorder
          AND   posnr = gi_vbap_rel_order-posnrorder.
      IF sy-subrc EQ 0.
        SORT i_vbup BY vbeln posnr.
      ELSE.
        CLEAR i_vbup[].
      ENDIF.
      SELECT vbeln
             posnr
             pstyv
        FROM vbap
        INTO TABLE i_item_catg
        FOR ALL ENTRIES IN gi_vbap_rel_order
        WHERE vbeln = gi_vbap_rel_order-vbelnorder
        AND   posnr = gi_vbap_rel_order-posnrorder.
      IF sy-subrc EQ 0.
        SORT i_item_catg BY vbeln posnr.
      ELSE.
        CLEAR i_item_catg[].
      ENDIF.
    ENDIF.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
  CONCATENATE lc_job_name c_underscore s_vkorg-low c_underscore sy-uzeit c_underscore sy-datum  INTO lv_job_name.
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
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
    SUBMIT zqtcr_auto_res_rej_batch_new
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
                               WITH s_vkorg = s_vkorg[]
                               WITH s_vtweg = s_vtweg[]
                               WITH s_spart = s_spart[]
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
                               WITH s_vbeln  = s_vbeln[]
                               WITH s_type   = s_type[]
                               WITH s_date   = s_date[]
                               WITH s_matnr  = s_matnr[]
                               WITH s_pro    = s_pro[]
                               WITH s_c_date = s_c_date[]
                               WITH s_mail   = s_mail[]
                               WITH p_job    = p_job
                               WITH p_test = p_test
                               WITH s_it_srp = s_it_srp[]  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                               WITH s_it_cat = s_it_cat[]  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
FORM f_bapi_update_with_new_value  TABLES  fp_vkorg STRUCTURE  edm_vkorg_range "##NEEDED.
                                           fp_vtweg STRUCTURE  edm_vtweg_range "##NEEDED.,
                                           fp_spart STRUCTURE edm_spart_range
                                   USING  fp_test TYPE c
                                          fp_vbeln TYPE tt_sel_opt "##NEEDED.
                                          fp_type  TYPE tt_sel_opt"##NEEDED.
                                          fp_date  TYPE tt_sel_opt"##NEEDED.
                                          fp_matnr TYPE tt_sel_opt "##NEEDED.
                                          fp_pro   TYPE tt_sel_opt "##NEEDED.
                                          fp_c_date  TYPE tt_sel_opt"##NEEDED.
                                          fp_mail   "TYPE tt_sel_opt "##NEEDED.
                                          fp_job   "##NEEDED.
                                          fp_item_catg TYPE tt_sel_opt "##NEEDED.  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                                          fp_item_srp  TYPE tt_sel_opt "##NEEDED.  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                                 CHANGING p_i_mail TYPE tt_sel_opt
                                          lv_lines TYPE i.
  p_test = fp_test.
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
  s_vkorg[] = fp_vkorg[].
  s_vtweg[] = fp_vtweg[].
  s_spart[] = fp_spart[].
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
  li_mail[]       = p_i_mail[].
  p_job           = fp_job.
  s_vbeln[]       = fp_vbeln[].
  s_type[]        = fp_type[].
  s_date[]        = fp_date[].
  s_matnr[]       = fp_matnr[].
  s_pro[]         = fp_pro[].
  s_c_date[]      = fp_c_date[].
  s_it_cat[]      = fp_item_catg[].  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  s_it_srp[]      = fp_item_srp[].   "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
*   st_imessage =    text-012. "No data found for the given selection criteria. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    st_imessage =    text-029. "There were no valid contracts/Release orders found for the selection criteria. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
  CLEAR lv_lines.
  DESCRIBE TABLE i_attach_total   LINES lv_total.
  DATA(lv_lines_tmp) = lv_total.
  lv_lines = lv_lines_tmp - 1.
  DESCRIBE TABLE i_attach_error  LINES DATA(lv_line_err).
  READ TABLE i_attach_error INDEX lv_line_err.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach_total INDEX lv_total.
  lst_xdocdata-doc_size =
      ( ( lv_total - 1 ) * 255 + strlen( i_attach_total ) ) + ( ( lv_line_err - 1 ) * 255 + strlen( i_attach_error ) ).

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
*  IF lv_flag_order = c_x.
  SORT gi_output BY vbeln posnr vbelnorder posnrorder type.
  DELETE ADJACENT DUPLICATES FROM gi_output COMPARING vbeln posnr vbelnorder posnrorder.
*  ELSE.
*    SORT gi_output BY vbeln posnr.
*    DELETE ADJACENT DUPLICATES FROM gi_output COMPARING vbeln posnr.
*  ENDIF.

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
      CONCATENATE text-018 text-019 text-036 text-037 text-030 text-020 text-021
          INTO i_attach_success SEPARATED BY con_tab. "c_separator."con_tab.
      CONCATENATE con_cret i_attach_success INTO i_attach_success.
      APPEND i_attach_success.
      CONCATENATE text-018 text-019 text-036 text-037 text-030 text-020 text-021
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
                 lst_output-vbelnorder   lst_output-posnrorder lst_output-auart  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                 lv_res_text             lv_res_text
             INTO i_attach_success SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_success  INTO i_attach_success.
    APPEND  i_attach_success.

    CONCATENATE  lst_output-vbeln        lst_output-posnr
                 lst_output-vbelnorder   lst_output-posnrorder  lst_output-auart  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                 lv_res_text             lv_res_text
             INTO i_attach_total SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_total  INTO i_attach_total.
    APPEND  i_attach_total.

  ENDLOOP.

  LOOP AT gi_output INTO DATA(lstt_output) WHERE type = c_e.

*- For Final Records
** If the error table is already not populated
    IF i_attach_error[] IS INITIAL.
      CONCATENATE text-018 text-019 text-036 text-037 text-030 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO i_attach_error SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_error INTO i_attach_error.
      APPEND  i_attach_error.
      CONCATENATE text-018 text-019 text-036 text-037 text-030 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO i_attach_total SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_total INTO i_attach_total.
      APPEND  i_attach_total.
    ENDIF.

    READ TABLE li_tvagt INTO DATA(lst_tvagt_t) WITH KEY spras = sy-langu
                                                      abgru = lstt_output-vkuegru
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR lv_res_text.
      CONCATENATE lstt_output-vkuegru lst_tvagt_t-bezei INTO lv_res_text SEPARATED BY space.
    ENDIF.
    IF lstt_output-log_text IS NOT INITIAL.
      lstt_output-message = lstt_output-log_text.
    ENDIF.
    CONCATENATE  lstt_output-vbeln          lstt_output-posnr
                 lstt_output-vbelnorder     lstt_output-posnrorder  lstt_output-auart "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                 lv_res_text                lstt_output-vkuesch
                 lstt_output-veindat        lstt_output-vwundat
                 lstt_output-id             lstt_output-message
             INTO i_attach_error SEPARATED BY con_tab."c_separator.
    CONCATENATE con_cret i_attach_error  INTO i_attach_error.
    APPEND  i_attach_error.
    CONCATENATE  lstt_output-vbeln        lstt_output-posnr
                 lstt_output-vbelnorder     lstt_output-posnrorder  lstt_output-auart "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
*  DATA: lv_vbeln    TYPE vbeln.
*        lst_output  TYPE ty_output,
*        lst_return  TYPE bapiret2,
*        lst_att_err TYPE so_text255,
*        lst_text    TYPE so_text255.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  CLEAR: i_attach_error,lst_text.

  REFRESH:i_attach_error[], i_attach_success[],i_attach_total[].
  SORT i_ekkn BY vbeln vbelp. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  SORT i_vbup BY vbeln posnr. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  SORT i_item_catg BY vbeln posnr. "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  LOOP AT fp_li_vbap INTO lst_vbap.

* If VBAP-ABGRU exists and if VBAP-ABGRU <> VEDA-VKUEGRU, then log the item into error excel.
    IF lst_vbap-abgru IS NOT INITIAL AND lst_vbap-abgru <> lst_vbap-vkuegru OR lst_vbap-vkuegru IS INITIAL.

      CONCATENATE text-018 text-019 text-030 text-021 text-022 text-023 text-024
                  text-025 text-026 INTO lst_att_err SEPARATED BY con_tab.

      CONCATENATE con_cret lst_att_err INTO i_attach_error.
      APPEND lst_att_err TO i_attach_error.
      IF lst_vbap-vkuegru IS INITIAL.
        lst_text = text-028. "Maintian Reason for cancel. in Contact Tab
      ELSE.
        lst_text  = text-003.
      ENDIF.
      CONCATENATE  lst_vbap-vbeln
                   lst_vbap-posnr
                   lst_vbap-auart  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
      CLEAR lv_flag_order.
      PERFORM f_bapi_salesorder_chage USING gi_vbap.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    ENDAT.  " AT END OF vbeln.
  ENDLOOP. " LOOP AT f_li_vbap INTO lst_vbap.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
*- For Release Order Processing
  SORT gi_vbap_rel_order BY vbeln posnr.
  LOOP AT i_rel_order INTO lst_rel_order.
    CLEAR lst_vbap.
    LOOP AT gi_vbap_rel_order INTO lst_vbap WHERE vbeln = lst_rel_order-vbeln
                                            AND   xorder_created = c_x. " Checking Released Order exists or not
*- Shipping date is greater than or equal to requested cancellation date for Releae orders
      CLEAR lv_log_text.
      IF lst_vbap-shipping_date GE lst_vbap-vwundat
        AND ( lst_vbap-vbelnorder IS NOT INITIAL AND lst_vbap-posnrorder IS NOT INITIAL ).
*- Get Item Catgory
        READ TABLE i_item_catg INTO DATA(lst_item_catg) WITH KEY vbeln = lst_vbap-vbelnorder
                                                                  posnr = lst_vbap-posnrorder
                                                           BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF  ( lst_item_catg-pstyv NOT IN s_it_cat OR lst_item_catg-pstyv NOT IN s_it_srp ).
            lv_log_text = text-039. "Release order Item Catg is not with ZSRP, ZTAS, ZSRT
            PERFORM f_log_update_for_release_ord.
            CONTINUE.
          ENDIF.
*- For Sales Document Item Catg 'ZSRP'
          IF lst_item_catg-pstyv IN s_it_srp.
            READ TABLE i_vbup INTO DATA(lst_vbup) WITH KEY vbeln = lst_vbap-vbelnorder
                                                            posnr = lst_vbap-posnrorder
                                                    BINARY SEARCH.
            IF sy-subrc EQ 0 AND lst_vbup-lfsta = c_lfsta_a.
              lv_flag_order = abap_true.
            ELSE.
              lv_log_text = text-032. "Release orders Delivery status other than Not yet processed
              PERFORM f_log_update_for_release_ord.
              CONTINUE.
            ENDIF. "ENDIF for Release orders Delivery status other than Not yet processed
          ENDIF. "ENDIF for Sales Document Item Catg 'ZSRP'
*- For Sales Document Item Catg 'ZTAS' or 'ZSRT'
          IF lst_item_catg-pstyv IN s_it_cat.
            READ TABLE i_ekkn INTO DATA(lst_ekkn)  WITH KEY vbeln = lst_vbap-vbelnorder
                                                             vbelp = lst_vbap-posnrorder
                                                     BINARY SEARCH.
            IF sy-subrc NE 0.
              lv_flag_order = abap_true.
            ELSE.
              lv_log_text = text-035.  "Release order processed to PO
              PERFORM f_log_update_for_release_ord.
              CONTINUE.
            ENDIF. " ENDIF for "Release order processed to PO
          ENDIF. " ENDIF for Sales Document Item Catg 'ZTAS' or 'ZSRT'
          IF lv_flag_order = abap_true.
            MOVE-CORRESPONDING lst_vbap TO lst_rel_cds_view.
            APPEND lst_rel_cds_view TO i_rel_cds_view.
            CLEAR: lst_rel_cds_view,lst_vbap.
          ENDIF.
        ELSE.
          lv_log_text = text-038.  "Sales Document Item Catg does not exists.
          PERFORM f_log_update_for_release_ord.
          CONTINUE.
        ENDIF. " ENDIF for Sales Document Item Catg does not exists.
      ELSE.
        lv_log_text = text-031. "Shipping date is less than requested cancellation date for Releae orders
        PERFORM f_log_update_for_release_ord.
        CONTINUE.
      ENDIF. "ENDIF for greater than or equal to requested cancellation date for Releae orders
    ENDLOOP.
  ENDLOOP.
  LOOP AT i_rel_cds_view INTO lst_rel_cds_view.
    lv_vbeln = lst_rel_cds_view-vbelnorder.
*   Populate value in order Item
    lst_bapisditm-itm_number = lst_rel_cds_view-posnrorder.
    lst_bapisditm-reason_rej = lst_rel_cds_view-vkuegru.
    APPEND lst_bapisditm TO li_bapisditm.
    CLEAR lst_bapisditm.

*   Populate value in order Item Index
    lst_bapisditmx-updateflag = c_u.
    lst_bapisditmx-itm_number = lst_rel_cds_view-posnrorder.
    lst_bapisditmx-reason_rej = abap_true.
    APPEND lst_bapisditmx TO li_bapisditmx.
    CLEAR lst_bapisditmx.

*   Populate value in order header
    lst_bapisdh1x-updateflag = c_u.

    AT END OF vbelnorder.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
      lv_flag_order = abap_true.
      PERFORM f_bapi_salesorder_chage USING gi_vbap.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
    ENDAT.
  ENDLOOP.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
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
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_SALESORDER_CHAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bapi_salesorder_chage USING fp_li_vbap   TYPE tt_cds_e186.
*     Update rejection reason for credit memo request when rejected
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
  DATA : lv_test TYPE bapiflag-bapiflag.
  lv_test = p_test.

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = lv_vbeln
      order_header_inx = lst_bapisdh1x
      simulation       = lv_test
    TABLES
      return           = li_return
      order_item_in    = li_bapisditm
      order_item_inx   = li_bapisditmx.

  IF NOT li_return IS INITIAL  AND p_test IS INITIAL.
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
    READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_e.
    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      READ TABLE li_return TRANSPORTING NO FIELDS WITH KEY type = c_a.
      IF sy-subrc = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
        IF lv_flag_order = abap_false.
          lst_rel_order-vbeln = lv_vbeln.
          APPEND lst_rel_order TO i_rel_order.
          CLEAR lst_rel_order.
        ENDIF.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
      ENDIF.
    ENDIF.
    REFRESH:li_return_tmp[].
    li_return_tmp[]  =  li_return[].
    SORT li_return_tmp BY type.
    DELETE li_return_tmp WHERE type NE c_e.
    CLEAR lst_return.
    IF li_return_tmp[] IS NOT INITIAL.
      LOOP AT li_return INTO lst_return WHERE type = c_e.
        IF lv_flag_order = abap_true.
          READ TABLE gi_vbap_rel_order INTO lst_vbap WITH KEY vbelnorder = lv_vbeln.
        ELSE.
          READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln.
        ENDIF.

        IF sy-subrc = 0.
          lst_output-vbeln      = lst_vbap-vbeln.    " Sales Document Number
          lst_output-posnr      = lst_vbap-posnr.    " Line Item Number
          lst_output-vbelnorder = lst_vbap-vbelnorder.
          lst_output-posnrorder = lst_vbap-posnrorder.
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
        IF lv_flag_order = abap_true.
          READ TABLE gi_vbap_rel_order INTO lst_vbap WITH KEY vbelnorder = lv_vbeln
                                                       posnr = lst_return-message_v2.
          lst_output-vbelnorder = lst_vbap-vbelnorder.
          lst_output-posnrorder = lst_vbap-posnrorder.
        ELSE.
          READ TABLE fp_li_vbap INTO lst_vbap WITH KEY vbeln = lv_vbeln
                                                       posnr = lst_return-message_v2.
        ENDIF.
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
        CLEAR: lst_return,
               lst_output,
               lst_vbap.
      ENDLOOP.
    ENDIF.
  ENDIF. " IF NOT li_return IS INITIAL
  CLEAR: li_bapisditm,
         li_bapisditmx,
         lst_bapisdh1x,
         li_return,
         lv_vbeln.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_UPDATE_FOR_RELEASE_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_update_for_release_ord .
  lst_output-vbeln      = lst_vbap-vbeln.    " Sales Document Number
  lst_output-posnr      = lst_vbap-posnr.    " Line Item Number
  lst_output-vbelnorder = lst_vbap-vbelnorder.    " Release Order
  lst_output-posnrorder = lst_vbap-posnrorder.    " Release Line Item Number
  lst_output-auart      = lst_vbap-auart.    " Sales Document Type
  lst_output-vkuegru    = lst_vbap-vkuegru.  " Reason for Cancellation of Contract
  lst_output-vkuesch    = lst_vbap-vkuesch.  " Assignment cancellation procedure/cancellation rule
  lst_output-veindat    = lst_vbap-veindat.  " Date on which cancellation request was received
  lst_output-vwundat    = lst_vbap-vwundat.  " Requested cancellation date
  lst_output-type       = c_e.
  lst_output-log_text   = lv_log_text.
  APPEND lst_output TO gi_output.
  CLEAR lst_output.
ENDFORM.
