**----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_UPDATE_F001                  *
* PROGRAM DESCRIPTION:   Program to update the Address details in Business
*                        partners from file
* DEVELOPER:             KJAGANA
* CREATION DATE:         02/13/2019
* OBJECT ID:             C105
* TRANSPORT NUMBER(S):   ED2K914456
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO         : ED2K918391
* REFERENCE NO        : ERPM-11885/C105
* DEVELOPER           : VDPATABALL
* DATE                : 06/05/2020
* DESCRIPTION         : Multiple E-mail IDs to BP contact Update
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_UPDATE_F001
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_INFL  text
*----------------------------------------------------------------------*
FORM f_get_filename  CHANGING p_filename.

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_filename " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_from_file .

  DATA: lst_bp_data TYPE ty_bp_details,
        li_type     TYPE truxs_t_text_data.
*get the no. of records and file path from constant table
*based on DEV ID 'C105'.
  SELECT *
    FROM zcaconstant
    INTO TABLE i_const
    WHERE devid = c_devid
   AND activate = abap_true.

  IF sy-batch = space.

*Uploading the file data into internal table
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_infl
      TABLES
        i_tab_converted_data = i_bp_data[]
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc NE  0.
      MESSAGE ID sy-msgid
              TYPE sy-msgty
              NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


*    i_bp_data_p[] = i_bp_data[].
*get the BP Number from ID Number.
    PERFORM f_get_bp_from_idnumber.
  ELSE.
*process data in the back ground.
    CLEAR i_bp_data.
    OPEN DATASET p_infl FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
      DO.
        READ DATASET p_infl INTO lst_bp_data.
        IF sy-subrc = 0.
          APPEND lst_bp_data TO i_bp_data.
          CLEAR lst_bp_data .
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
      DESCRIBE TABLE i_bp_data LINES gv_no_of_records.
      DESCRIBE TABLE i_bp_data LINES gv_records.
*   *get the bp number from id number.
      PERFORM f_get_bp_from_idnumber.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_infl.
    ENDIF.
    CLOSE DATASET p_infl.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUBMIT_PROGRAM_IN_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_CONST_LOW  text
*----------------------------------------------------------------------*
FORM f_submit_program_in_background  USING p_file TYPE char80.

  DATA: lv_jobname  TYPE btcjob,
        lv_number   TYPE tbtcjob-jobcount,      "Job number
        li_params   TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params  TYPE rsparamsl_255,         "Selection table parameter
        lst_bp_data TYPE ty_bp_details,
        lv_file     TYPE string.

  CONCATENATE p_file 'BP' sy-datum sy-uzeit INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.
  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT i_bp_data INTO lst_bp_data.
      TRANSFER lst_bp_data TO lv_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.


  lst_params-selname = 'P_INFL'.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = c_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = c_sign_i.       "I-in
  lst_params-option  = c_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.  "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CONCATENATE 'ZBP_CONTACT_UPD_' sy-datum '_' sy-uzeit INTO lv_jobname.
  CONDENSE lv_jobname NO-GAPS.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.

    SUBMIT zqtcr_bp_contact_update WITH SELECTION-TABLE li_params
                    VIA JOB lv_jobname NUMBER lv_number "Job number
                    AND RETURN.
    IF sy-subrc = 0.
*       Closing the Job
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobcount             = lv_number   "Job number
          jobname              = lv_jobname  "Job name
          strtimmed            = abap_true   "Start immediately
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.
  ENDIF.
  MESSAGE i255(zqtc_r2) WITH lv_jobname.
  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BP_UPDATE_ADDRESS_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bp_update_address_details USING lst_bp_data TYPE ty_bp_details.
  DATA : lst_alv_disp TYPE ty_alv_disp,
         lst_alv_log  TYPE ty_alv_disp,
         lst_alv_slog TYPE ty_alv_disp,
         lv_msg       TYPE string,
         lv_msg_typ   TYPE string,
         lv_mode      TYPE char1 VALUE 'N',
         lv_upd       TYPE char1 VALUE 'S',
         lv_tcode     TYPE char4 VALUE 'VAP1'.

  REFRESH : i_bdcdata,i_bdcmsg.
  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '0036'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                'USE_ZAV'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM f_bdc_field       USING 'RF02D-KUNNR'
                                lst_bp_data-partner.
  PERFORM f_bdc_field       USING 'USE_ZAV'
                                'X'.

  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '1361'.
  IF p_land IS INITIAL.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=ADRD'.
  ELSE.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=$INT'.
  ENDIF.
  PERFORM f_bdc_field       USING 'KNVK-PAFKT'
                                lst_bp_data-function.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                'SZA5_D0700-SMTP_ADDR'.
  PERFORM f_bdc_field       USING 'ADDR3_DATA-NAME_LAST'
                                lst_bp_data-lastname.
  PERFORM f_bdc_field       USING 'ADDR3_DATA-NAME_FIRST'
                                lst_bp_data-firstname.
  PERFORM f_bdc_field       USING 'ADDR3_DATA-LANGU_P'
                                lst_bp_data-langu.

  PERFORM f_bdc_field       USING 'SZA5_D0700-SMTP_ADDR'
                                lst_bp_data-e_mail.
  IF p_land IS INITIAL.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
    PERFORM f_bdc_dynpro      USING 'SAPLSZA1' '0201'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADDR1_DATA-COUNTRY'.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=CONT'.
    PERFORM f_bdc_field       USING 'ADDR1_DATA-COUNTRY'
                                    lst_bp_data-country.
    PERFORM f_bdc_field       USING 'ADDR1_DATA-LANGU'
                                    lst_bp_data-langu.

    PERFORM f_bdc_field       USING 'ADDR1_DATA-NAME2'
                                    lst_bp_data-lastname.
    PERFORM f_bdc_field       USING 'ADDR1_DATA-NAME1'
                                    lst_bp_data-firstname.
    PERFORM f_bdc_field       USING 'ADDR1_DATA-COUNTRY'
                                    lst_bp_data-country.
    PERFORM f_bdc_field       USING 'ADDR1_DATA-LANGU'
                                    lst_bp_data-langu.

    PERFORM f_bdc_dynpro      USING 'SAPMF02D' '1361'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                  'KNVK-PAVIP'.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                   '=$INT'.
  ENDIF.

  IF  lst_bp_data-e_mail1 IS NOT INITIAL.

    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.

    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=NEWL'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail.      "Email 1
  ELSE.
    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=CONT'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail.
    DATA(lv_flag) = abap_true.
  ENDIF.



  IF lst_bp_data-e_mail2 IS NOT INITIAL.

    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.

    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=NEWL'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail1.  "Email 2
  ELSE.
    IF lv_flag = abap_false.

      PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
      PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                      'ADSMTP-SMTP_ADDR(01)'.
      PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                      '=CONT'.
      PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                      lst_bp_data-e_mail1.
    ENDIF.
    lv_flag = abap_true.
  ENDIF.


  IF lst_bp_data-e_mail3 IS NOT INITIAL.
    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.

    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=NEWL'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail2.     "Email 3
  ELSE.
    IF lv_flag = abap_false.
      PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
      PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                      'ADSMTP-SMTP_ADDR(01)'.
      PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                      '=CONT'.
      PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                      lst_bp_data-e_mail2.
    ENDIF.
    lv_flag = abap_true.
  ENDIF.


  IF lst_bp_data-e_mail4 IS NOT INITIAL.
    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.

    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=NEWL'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail3.   "Email 4
  ELSE.
    IF lv_flag = abap_false.
      PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
      PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                      'ADSMTP-SMTP_ADDR(01)'.
      PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                      '=CONT'.
      PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                      lst_bp_data-e_mail3.
    ENDIF.
    lv_flag = abap_true.
  ENDIF.
  IF lst_bp_data-e_mail4 IS NOT INITIAL.

    PERFORM f_bdc_dynpro      USING 'SAPLSZA6' '0600'.
    PERFORM f_bdc_field       USING 'BDC_CURSOR'
                                    'ADSMTP-SMTP_ADDR(01)'.
    PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                    '=CONT'.
    PERFORM f_bdc_field       USING 'ADSMTP-SMTP_ADDR(01)'
                                    lst_bp_data-e_mail4.    "Email 5
  ENDIF.

**  PERFORM f_bdc_dynpro      USING 'SAPLSZA1' '0201'.
**  PERFORM f_bdc_field       USING 'BDC_CURSOR'
**                                'SZA1_D0100-TITLE_MEDI'.
**
**  PERFORM f_bdc_field       USING 'BDC_OKCODE'
**                                '=CONT'.
**  PERFORM f_bdc_field       USING 'ADDR1_DATA-COUNTRY'
**                                 lst_bp_data-country.
**  PERFORM f_bdc_field       USING 'ADDR1_DATA-LANGU'
**                                lst_bp_data-langu.
*---End of Commented VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update


  PERFORM f_bdc_dynpro      USING 'SAPMF02D' '1361'.
  PERFORM f_bdc_field       USING 'BDC_CURSOR'
                              'KNVK-PAVIP'.
  PERFORM f_bdc_field       USING 'BDC_OKCODE'
                                '=UPDA'.
*---Begin of Commented VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
**  PERFORM f_bdc_field       USING 'KNVK-PAFKT'
**                                  lst_bp_data-function.
**  PERFORM f_bdc_field       USING 'BDC_CURSOR'
**                                'SZA5_D0700-SMTP_ADDR'.
**  PERFORM f_bdc_field       USING 'ADDR3_DATA-NAME_LAST'
**                                lst_bp_data-lastname.
**  PERFORM f_bdc_field       USING 'ADDR3_DATA-NAME_FIRST'
**                                lst_bp_data-firstname.
**  PERFORM f_bdc_field       USING 'ADDR3_DATA-LANGU_P'
**                                lst_bp_data-langu.
**  PERFORM f_bdc_field       USING 'SZA5_D0700-SMTP_ADDR'
**                                lst_bp_data-e_mail.
*---End of Commented VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update

  CALL TRANSACTION lv_tcode USING i_bdcdata "call transaction
                            MODE lv_mode "N-no screen mode, A-all screen mode, E-error screen mode
                            UPDATE lv_upd "A-assynchronous, S-synchronous
                            MESSAGES INTO  i_bdcmsg. "messages



  LOOP AT i_bdcmsg INTO DATA(lst_bdcmsg).
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = lst_bdcmsg-msgid
        lang      = 'EN'
        no        = lst_bdcmsg-msgnr
        v1        = lst_bdcmsg-msgv1
        v2        = lst_bdcmsg-msgv2
        v3        = lst_bdcmsg-msgv3
        v4        = lst_bdcmsg-msgv4
      IMPORTING
        msg       = lv_msg
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lst_bdcmsg-msgtyp EQ c_s.
      lv_msg_typ = text-002."success
      APPEND lst_bp_data TO i_bp_data_t.
    ELSEIF lst_bdcmsg-msgtyp EQ c_w.
      lv_msg_typ = text-003."waring
    ELSEIF lst_bdcmsg-msgtyp EQ c_e.
      lv_msg_typ = text-004."error
    ENDIF.
*    *ALV log
    lst_alv_disp-source = lst_bp_data-source.
    lst_alv_disp-kunnr = lst_bp_data-partner.
    lst_alv_disp-idtype = lst_bp_data-idtype.
    lst_alv_disp-idnum = lst_bp_data-idnum.
    lst_alv_disp-namev = lst_bp_data-firstname.
    lst_alv_disp-name1 = lst_bp_data-lastname.
    lst_alv_disp-pafkt = lst_bp_data-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
    lst_alv_disp-mail  = lst_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
    lst_alv_disp-e_mail1  = lst_bp_data-e_mail1.
    lst_alv_disp-e_mail2  = lst_bp_data-e_mail2.
    lst_alv_disp-e_mail3  = lst_bp_data-e_mail3.
    lst_alv_disp-e_mail4  = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
    lst_alv_disp-msgtyp = lv_msg_typ.
    lst_alv_disp-msg  = lv_msg.
    APPEND lst_alv_disp TO i_alv_disp.
    CLEAR lst_alv_disp.
    "error log for application server.
    IF lst_bdcmsg-msgtyp EQ c_e.
      lst_alv_log-source = lst_bp_data-source.
      lst_alv_log-kunnr = lst_bp_data-partner.
      lst_alv_log-idtype = lst_bp_data-idtype.
      lst_alv_log-idnum = lst_bp_data-idnum.
      lst_alv_log-namev = lst_bp_data-firstname.
      lst_alv_log-name1 = lst_bp_data-lastname.
      lst_alv_log-pafkt = lst_bp_data-function.
*      lst_alv_log-prsnr = lst_bp_data-prsnr.
      lst_alv_log-mail  = lst_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_log-e_mail1  = lst_bp_data-e_mail1.
      lst_alv_log-e_mail2  = lst_bp_data-e_mail2.
      lst_alv_log-e_mail3  = lst_bp_data-e_mail3.
      lst_alv_log-e_mail4  = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_log-msgtyp = lv_msg_typ.
      lst_alv_log-msg  = lv_msg.
      APPEND lst_alv_log TO i_alv_log.
      CLEAR lst_alv_log.
      "success log for application server.
    ELSEIF  lst_bdcmsg-msgtyp EQ c_s.
      lst_alv_slog-source = lst_bp_data-source.
      lst_alv_slog-kunnr = lst_bp_data-partner.
      lst_alv_slog-idtype = lst_bp_data-idtype.
      lst_alv_slog-idnum = lst_bp_data-idnum.
      lst_alv_slog-namev = lst_bp_data-firstname.
      lst_alv_slog-name1 = lst_bp_data-lastname.
      lst_alv_slog-pafkt = lst_bp_data-function.
*      lst_alv_log-prsnr = lst_bp_data-prsnr.
      lst_alv_slog-mail  = lst_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_slog-e_mail1  = lst_bp_data-e_mail1.
      lst_alv_slog-e_mail2  = lst_bp_data-e_mail2.
      lst_alv_slog-e_mail3  = lst_bp_data-e_mail3.
      lst_alv_slog-e_mail4  = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_slog-msgtyp = lv_msg_typ.
      lst_alv_slog-msg  = lv_msg.
      APPEND lst_alv_slog TO i_alv_slog.
      CLEAR :lst_alv_slog.
    ENDIF.
    CLEAR:lst_alv_slog,lst_alv_log,lst_bdcmsg,lv_flag.

  ENDLOOP.
*  DELETE i_alv_slog WHERE msgtyp = text-003.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PROGRAM   text
*      -->DYNPRO   text
*----------------------------------------------------------------------*
FORM f_bdc_dynpro USING program dynpro.
  DATA : lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-program  = program. "program
  lst_bdcdata-dynpro   = dynpro. "screen
  lst_bdcdata-dynbegin = 'X'. "begin
  APPEND lst_bdcdata TO i_bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0569   FNAM
*      -->P_0570   FVAL
*----------------------------------------------------------------------*
FORM f_bdc_field USING fnam fval.
  DATA : lst_bdcdata TYPE bdcdata.
  CLEAR lst_bdcdata.
  lst_bdcdata-fnam = fnam. "field name ex: matnr
  lst_bdcdata-fval = fval. "field value ex: testmat001
  APPEND lst_bdcdata TO i_bdcdata.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA_TO_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data_to_create .
  DATA: lr_events  TYPE REF TO cl_salv_events_table,
        lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

*Preparing ALV TABLE For flat file to show it on output
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = ir_table
        CHANGING
          t_table      = i_bp_data.
    CATCH cx_salv_msg .
  ENDTRY.


  ir_table->set_screen_status(
      pfstatus      =  'ZSALV_TABLE_STANDARD'
      report        =  sy-repid
      set_functions = ir_table->c_functions_all ).

  lr_columns = ir_table->get_columns( ).
  lr_columns->set_optimize( c_true ).

  ir_selections = ir_table->get_selections( ).

  ir_selections->set_selection_mode( ir_selections->multiple ).

  TRY.
      lr_column ?= lr_columns->get_column( 'PARTNER' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'IDTYPE' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'IDNUM' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'FUNCTION' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'LASTNAME' ).##NO_TEXT
      lr_column->set_short_text( text-008 ). ##PUT_2607
      lr_column->set_medium_text( text-008 ).
      lr_column->set_long_text( text-008 ).
    ##NO_HANDLER    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'FIRSTNAME' ).
    ##NO_HANDLER    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'LANGU' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'COUNTRY' ).
    CATCH cx_salv_not_found.
  ENDTRY.
*---Begin of Change and commented VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
**  TRY.
**      lr_column ?= lr_columns->get_column( 'E_MAIL' ).
**    CATCH cx_salv_not_found.
**  ENDTRY.
  lr_column ?= lr_columns->get_column( 'E_MAIL' ).
  lr_column->set_short_text( 'Email ID1' ). ##PUT_2607
  lr_column->set_medium_text( 'Email Address 1' ).
  lr_column->set_long_text( 'Email Address 1' ).

  lr_column ?= lr_columns->get_column( 'E_MAIL1' ).
  lr_column->set_short_text( 'Email ID2' ). ##PUT_2607
  lr_column->set_medium_text( 'Email Address 2' ).
  lr_column->set_long_text( 'Email Address 2' ).

  lr_column ?= lr_columns->get_column( 'E_MAIL2' ).
  lr_column->set_short_text( 'Email ID3' ). ##PUT_2607
  lr_column->set_medium_text( 'Email Address 3' ).
  lr_column->set_long_text( 'Email Address 3' ).

  lr_column ?= lr_columns->get_column( 'E_MAIL3' ).
  lr_column->set_short_text( 'Email ID4' ). ##PUT_2607
  lr_column->set_medium_text( 'Email Address 4' ).
  lr_column->set_long_text( 'Email Address 4' ).

  lr_column ?= lr_columns->get_column( 'E_MAIL4' ).
  lr_column->set_short_text( 'Email ID5' ). ##PUT_2607
  lr_column->set_medium_text( 'Email Address 5' ).
  lr_column->set_long_text( 'Email Address 5' ).
*---End of Change and comment VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
  TRY.
      lr_column ?= lr_columns->get_column( 'FLAG' ).
      lr_column->set_visible( value = if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found.
  ENDTRY.

  lr_events = ir_table->get_event( ).
  CREATE OBJECT ir_events.
  SET HANDLER ir_events->on_user_command FOR lr_events.
  PERFORM f_set_top_of_page CHANGING ir_table.
  ir_table->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_SALV_FUNCTION  text
*----------------------------------------------------------------------*
FORM f_handle_user_command  USING i_ucomm TYPE salv_de_function.

  DATA:
*        li_rows     TYPE salv_t_row,
    li_column    TYPE salv_t_column,
    lst_cell     TYPE salv_s_cell,
    lst_row      TYPE int4,
    lr_columns   TYPE REF TO cl_salv_columns,
    lst_bp_data  TYPE ty_bp_details,
    lv_row       TYPE  kcd_ex_row_n,
    lst_const    TYPE zcaconstant,
    lst_alv_log  TYPE ty_alv_disp,
    lst_alv_disp TYPE ty_alv_disp.

*        lv_no_of_records TYPE i.
  FIELD-SYMBOLS: <fs_bp_data>  TYPE ty_bp_details.
  FIELD-SYMBOLS: <fs_bp_data1>  TYPE ty_bp_details.
*get the selected rows from output
  CALL METHOD ir_selections->get_selected_rows
    RECEIVING
      value = i_rows.

  DESCRIBE TABLE i_rows LINES gv_no_of_records.

  PERFORM f_clear_global_var.

*  IF sy-subrc EQ 0.
  SORT i_const BY param1.
*  ENDIF.
*  check the entry for number of records maintained in ztable.
  CLEAR lst_const .
  READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param1.

  IF gv_no_of_records IS NOT INITIAL AND lst_const-low IS NOT INITIAL.
*if selected entries are more than the entry maintained in constant table
* run in background ..else in foreground.
    IF gv_no_of_records > lst_const-low.
      CLEAR lst_const .
      READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param2.
      IF sy-subrc = 0.
        LOOP AT i_rows INTO lst_row.
          READ TABLE i_bp_data_cnt ASSIGNING FIELD-SYMBOL(<fs_bp_data_cnt_1>) INDEX lst_row.
          APPEND <fs_bp_data_cnt_1> TO i_bp_data.
        ENDLOOP.
        PERFORM f_submit_program_in_background USING lst_const-low.
      ENDIF.

    ELSE."Foreground

* process the records for bp relationship maintaince and person creation.
      LOOP AT i_rows INTO lst_row.
        READ TABLE i_bp_data_cnt ASSIGNING FIELD-SYMBOL(<fs_bp_data_cnt>) INDEX lst_row.
        IF <fs_bp_data_cnt>  IS  ASSIGNED AND <fs_bp_data_cnt>-partner IS NOT INITIAL AND
          <fs_bp_data_cnt>-flag NE abap_true.
          APPEND <fs_bp_data_cnt> TO i_bp_data.
        ELSEIF <fs_bp_data_cnt>  IS  ASSIGNED  AND <fs_bp_data_cnt>-partner IS INITIAL.
          CONCATENATE text-010 '(' <fs_bp_data_cnt>-idnum ')' INTO DATA(lv_msg) SEPARATED BY space.

          lst_alv_log-source = <fs_bp_data_cnt>-source.
          lst_alv_log-kunnr  = <fs_bp_data_cnt>-partner.
          lst_alv_log-idtype = <fs_bp_data_cnt>-idtype.
          lst_alv_log-idnum  = <fs_bp_data_cnt>-idnum.
          lst_alv_log-namev  = <fs_bp_data_cnt>-firstname.
          lst_alv_log-name1  = <fs_bp_data_cnt>-lastname.
          lst_alv_log-pafkt  = <fs_bp_data_cnt>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
          lst_alv_log-mail   = <fs_bp_data_cnt>-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
          lst_alv_log-e_mail1 = <fs_bp_data_cnt>-e_mail1.
          lst_alv_log-e_mail2 = <fs_bp_data_cnt>-e_mail2.
          lst_alv_log-e_mail3 = <fs_bp_data_cnt>-e_mail3.
          lst_alv_log-e_mail4 = <fs_bp_data_cnt>-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update

          lst_alv_log-msgtyp = text-004.
          lst_alv_log-msg  = lv_msg.
          APPEND lst_alv_log TO i_alv_log.
          CLEAR:lst_alv_log.

          lst_alv_disp-source = <fs_bp_data_cnt>-source.
          lst_alv_disp-kunnr = <fs_bp_data_cnt>-partner.
          lst_alv_disp-idtype = <fs_bp_data_cnt>-idtype.
          lst_alv_disp-idnum = <fs_bp_data_cnt>-idnum.
          lst_alv_disp-namev = <fs_bp_data_cnt>-firstname.
          lst_alv_disp-name1 = <fs_bp_data_cnt>-lastname.
          lst_alv_disp-pafkt = <fs_bp_data_cnt>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
          lst_alv_disp-mail  = <fs_bp_data_cnt>-e_mail.
          lst_alv_disp-msgtyp = text-004.
          lst_alv_disp-msg  = lv_msg.
          APPEND lst_alv_disp TO i_alv_disp.
          CLEAR:lst_alv_disp.
*          MESSAGE e259(zqtc_r2) DISPLAY LIKE 'I'.
          <fs_bp_data_cnt>-flag = abap_true.
        ENDIF.
      ENDLOOP.
*      if mail id already existed,delete those records and process with remaining records.
* if mail id already exist with bp,first name,last name,then through a error
* and skip that record from bdc processing
      PERFORM f_log_message.
      DELETE i_bp_data WHERE flag = abap_true.

      LOOP AT i_bp_data INTO DATA(fs_bp_data).
        READ TABLE i_bp_data_t ASSIGNING <fs_bp_data1> WITH KEY partner = fs_bp_data-partner
                                                              firstname = fs_bp_data-firstname
                                                              lastname = fs_bp_data-lastname
                                                              e_mail = fs_bp_data-e_mail.
        IF sy-subrc NE 0.
          PERFORM f_bp_update_address_details USING fs_bp_data.
        ELSE.

*            CONCATENATE ''  INTO DATA(lv_msg) SEPARATED BY space.

          lst_alv_log-source = fs_bp_data-source.
          lst_alv_log-kunnr = fs_bp_data-partner.
          lst_alv_log-idtype = fs_bp_data-idtype.
          lst_alv_log-idnum = fs_bp_data-idnum.
          lst_alv_log-namev = fs_bp_data-firstname.
          lst_alv_log-name1 = fs_bp_data-lastname.
          lst_alv_log-pafkt = fs_bp_data-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
          lst_alv_log-mail  = fs_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
          lst_alv_log-e_mail1 = fs_bp_data-e_mail1.
          lst_alv_log-e_mail2 = fs_bp_data-e_mail2.
          lst_alv_log-e_mail3 = fs_bp_data-e_mail3.
          lst_alv_log-e_mail4 = fs_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update

          lst_alv_log-msgtyp = text-004.
          lst_alv_log-msg  = 'Email ID already existed for BP'(021)."lv_msg.
          APPEND lst_alv_log TO i_alv_log.
          CLEAR:lst_alv_log.

          lst_alv_disp-source = fs_bp_data-source.
          lst_alv_disp-kunnr = fs_bp_data-partner.
          lst_alv_disp-idtype = fs_bp_data-idtype.
          lst_alv_disp-idnum = fs_bp_data-idnum.
          lst_alv_disp-namev = fs_bp_data-firstname.
          lst_alv_disp-name1 = fs_bp_data-lastname.
          lst_alv_disp-pafkt = fs_bp_data-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
          lst_alv_disp-mail  = fs_bp_data-e_mail.
          lst_alv_disp-msgtyp = text-004.
          lst_alv_disp-msg  = 'Email ID already existed for BP'(021)."lv_msg.
          APPEND lst_alv_disp TO i_alv_disp.
          CLEAR:lst_alv_disp.
        ENDIF.
      ENDLOOP.
*   processs error logs.
      IF i_alv_log IS NOT INITIAL.
        PERFORM f_create_error_log.
      ENDIF.
*   processes successs logs
      IF i_alv_slog IS NOT INITIAL..
        PERFORM f_create_success_log.
      ENDIF.
*      Process all logs.
      IF i_alv_disp IS NOT INITIAL.
        PERFORM f_display_alv_table.
      ENDIF.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BP_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bp_update .
  DATA: lst_bp_data  TYPE ty_bp_details,
        lst_alv_log  TYPE ty_alv_disp,
        lst_alv_disp TYPE ty_alv_disp.

*  * if mail id already exist with bp,first name,last name,then through a error
** and skip that record from bdc processing
  PERFORM f_log_message.
  DELETE i_bp_data WHERE flag = abap_true.
* process the records for bp relationship maintaince and person creation.
  LOOP AT i_bp_data INTO lst_bp_data.
    IF lst_bp_data-partner IS NOT INITIAL AND lst_bp_data-flag NE abap_true.
      READ TABLE i_bp_data_t INTO DATA(ls_bp_data1) WITH KEY partner = lst_bp_data-partner
                                                              firstname = lst_bp_data-firstname
                                                              lastname = lst_bp_data-lastname
                                                              e_mail = lst_bp_data-e_mail.
      IF sy-subrc NE 0.
        PERFORM f_bp_update_address_details USING lst_bp_data.
      ELSE.
*      CONCATENATE text-010 '(' lst_bp_data-idnum ')' INTO DATA(lv_msg) SEPARATED BY space.
        lst_alv_log-source = lst_bp_data-source.
        lst_alv_log-kunnr = lst_bp_data-partner.
        lst_alv_log-idtype = lst_bp_data-idtype.
        lst_alv_log-idnum = lst_bp_data-idnum.
        lst_alv_log-namev = lst_bp_data-firstname.
        lst_alv_log-name1 = lst_bp_data-lastname.
        lst_alv_log-pafkt = lst_bp_data-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
        lst_alv_log-mail  = lst_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-e_mail1 = lst_bp_data-e_mail1.
        lst_alv_log-e_mail2 = lst_bp_data-e_mail2.
        lst_alv_log-e_mail3 = lst_bp_data-e_mail3.
        lst_alv_log-e_mail4 = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-msgtyp = text-004.
        lst_alv_log-msg  = 'Email is already updated for this BP'(021)."lv_msg.
        APPEND lst_alv_log TO i_alv_log.
        CLEAR:lst_alv_log.

        lst_alv_disp-source = lst_bp_data-source.
        lst_alv_disp-kunnr = lst_bp_data-partner.
        lst_alv_disp-idtype = lst_bp_data-idtype.
        lst_alv_disp-idnum = lst_bp_data-idnum.
        lst_alv_disp-namev = lst_bp_data-firstname.
        lst_alv_disp-name1 = lst_bp_data-lastname.
        lst_alv_disp-pafkt = lst_bp_data-function.
        lst_alv_disp-mail  = lst_bp_data-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-e_mail1 = lst_bp_data-e_mail1.
        lst_alv_disp-e_mail2 = lst_bp_data-e_mail2.
        lst_alv_disp-e_mail3 = lst_bp_data-e_mail3.
        lst_alv_disp-e_mail4 = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-msgtyp = text-004.
        lst_alv_disp-msg  = 'Email is already updated for this BP'(021)."lv_msg.
        APPEND lst_alv_disp TO i_alv_disp.
        CLEAR:lst_alv_disp.
      ENDIF.
      CLEAR : lst_bp_data.

    ENDIF.
  ENDLOOP.
*  * if mail id already existed,delete those records and process with remaining records.
*  i_bp_data_prc[] = i_bp_data[].

*  DELETE i_bp_data WHERE source = abap_true.
* *   processs error logs.
  IF i_alv_log IS NOT INITIAL.
    PERFORM f_create_error_log.
  ENDIF.
*   processs success logs.
  IF i_alv_slog IS NOT INITIAL..
    PERFORM f_create_success_log.
  ENDIF.
*  *   processs all logs.
  IF i_alv_disp IS NOT INITIAL.
    DELETE i_alv_disp WHERE msgtyp = 'Warning'.
    PERFORM f_display_alv_table.
  ENDIF.
**count no of  process,error,success and total records to show it alv ouptut
*  PERFORM f_count_records.
*  PERFORM f_set_top_of_page CHANGING ir_table_alv.
*  ir_table_alv->refresh( ).
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_table .

  DATA: lr_events  TYPE REF TO cl_salv_events_table,
        lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.
  DELETE i_alv_disp WHERE msgtyp = text-003.
* Display the report output in ALV
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = ir_table_alv
        CHANGING
          t_table      = i_alv_disp.
    CATCH cx_salv_msg .
  ENDTRY.

  lr_columns = ir_table_alv->get_columns( ).
  lr_columns->set_optimize( c_true ).

  TRY.
      lr_column ?= lr_columns->get_column( 'KUNNR' ).

    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'NAMEV' ).

    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'NAME1' ).

    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'PAFKT' ).

    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'MAIL' ).

    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'MSGTYP' ).
      lr_column->set_short_text( text-009  ). ##TEXT_POOL
      lr_column->set_medium_text( text-006 ). ##TEXT_POOL
      lr_column->set_long_text( text-006 ).##TEXT_POOL
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'MSG' ).
      lr_column->set_short_text( text-007  ). ##TEXT_POOL
      lr_column->set_medium_text( text-007 ). ##TEXT_POOL
      lr_column->set_long_text( text-007  ).##TEXT_POOL
    CATCH cx_salv_not_found.
  ENDTRY.

*  *count no of  process,error,success and total records to show it alv ouptut
  PERFORM f_count_records.
  PERFORM f_set_top_of_page CHANGING ir_table_alv.

  ir_table_alv->display( ).


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BP_FROM_IDNUMBER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_bp_from_idnumber .
  FIELD-SYMBOLS : <fs_idnum>   TYPE ty_idnum,
                  <fs_bp_data> TYPE ty_bp_details.

  DATA: lv_msg       TYPE string,
        lv_file      TYPE string,
        lv_lines     TYPE i,
        lst_alv_log  TYPE ty_alv_disp,
        lst_alv_disp TYPE ty_alv_disp,
        lst_const    TYPE zcaconstant.

  CONSTANTS : lc_1 TYPE char1 VALUE '1'.

  IF i_bp_data IS NOT INITIAL.
*    SORT  i_bp_data BY idnum.
    i_bp_data_tmp[] = i_bp_data[].
    DELETE i_bp_data_tmp WHERE partner IS NOT INITIAL.
    IF i_bp_data_tmp IS NOT INITIAL.
      SELECT partner,
             type,
             idnumber
        FROM but0id
        INTO TABLE @DATA(it_idnum)
        FOR ALL ENTRIES IN @i_bp_data_tmp
        WHERE type       EQ @i_bp_data_tmp-idtype
        AND   idnumber   EQ @i_bp_data_tmp-idnum.
    ENDIF."i_bp_data_tmp IS NOT INITIAL.
  ENDIF."i_bp_data IS NOT INITIAL.

  DESCRIBE TABLE it_idnum LINES lv_lines.

  LOOP AT it_idnum ASSIGNING <fs_idnum>.
    LOOP AT i_bp_data ASSIGNING <fs_bp_data> WHERE idnum = <fs_idnum>-idnum.
      IF <fs_bp_data> IS ASSIGNED AND <fs_idnum>-partner IS NOT INITIAL.
        <fs_bp_data>-partner = <fs_idnum>-partner.
      ELSE.
        CONCATENATE text-010 '(' <fs_idnum>-idnum ')' INTO lv_msg SEPARATED BY space.
        lst_alv_log-source = <fs_bp_data>-source.
        lst_alv_log-kunnr = <fs_bp_data>-partner.
        lst_alv_log-idtype = <fs_bp_data>-idtype.
        lst_alv_log-idnum = <fs_bp_data>-idnum.
        lst_alv_log-namev = <fs_bp_data>-firstname.
        lst_alv_log-name1 = <fs_bp_data>-lastname.
        lst_alv_log-pafkt = <fs_bp_data>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
        lst_alv_log-mail  = <fs_bp_data>-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-e_mail1 = <fs_bp_data>-e_mail1.
        lst_alv_log-e_mail2 = <fs_bp_data>-e_mail2.
        lst_alv_log-e_mail3 = <fs_bp_data>-e_mail3.
        lst_alv_log-e_mail4 = <fs_bp_data>-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-msgtyp = text-004.
        lst_alv_log-msg  = lv_msg.
        APPEND lst_alv_log TO i_alv_log.
        CLEAR:lst_alv_log.

        lst_alv_disp-source = <fs_bp_data>-source.
        lst_alv_disp-kunnr = <fs_bp_data>-partner.
        lst_alv_disp-idtype = <fs_bp_data>-idtype.
        lst_alv_disp-idnum = <fs_bp_data>-idnum.
        lst_alv_disp-namev = <fs_bp_data>-firstname.
        lst_alv_disp-name1 = <fs_bp_data>-lastname.
        lst_alv_disp-pafkt = <fs_bp_data>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
        lst_alv_disp-mail  = <fs_bp_data>-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-e_mail1 = <fs_bp_data>-e_mail1.
        lst_alv_disp-e_mail2 = <fs_bp_data>-e_mail2.
        lst_alv_disp-e_mail3 = <fs_bp_data>-e_mail3.
        lst_alv_disp-e_mail4 = <fs_bp_data>-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-msgtyp = text-004.
        lst_alv_disp-msg  = lv_msg.
        APPEND lst_alv_disp TO i_alv_disp.
        CLEAR:lst_alv_disp.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
*  * PASS DATA INTO TEMP TABLE TO COUNT NO.OF Records and show it on output.
  i_bp_data_cnt[] = i_bp_data[].
*if entry is missing BUTOID Table,through error log.
  LOOP AT i_bp_data ASSIGNING <fs_bp_data>.
    IF <fs_bp_data>-partner IS INITIAL.
      CONCATENATE text-010 '(' <fs_bp_data>-idnum ')' INTO lv_msg SEPARATED BY space.
      lst_alv_log-source = <fs_bp_data>-source.
      lst_alv_log-kunnr = <fs_bp_data>-partner.
      lst_alv_log-idtype = <fs_bp_data>-idtype.
      lst_alv_log-idnum = <fs_bp_data>-idnum.
      lst_alv_log-namev = <fs_bp_data>-firstname.
      lst_alv_log-name1 = <fs_bp_data>-lastname.
      lst_alv_log-pafkt = <fs_bp_data>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
      lst_alv_log-mail  = <fs_bp_data>-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_log-e_mail1 = <fs_bp_data>-e_mail1.
      lst_alv_log-e_mail2 = <fs_bp_data>-e_mail2.
      lst_alv_log-e_mail3 = <fs_bp_data>-e_mail3.
      lst_alv_log-e_mail4 = <fs_bp_data>-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_log-msgtyp = text-004.
      lst_alv_log-msg  = lv_msg.
      APPEND lst_alv_log TO i_alv_log.
      CLEAR:lst_alv_log.

      lst_alv_disp-source = <fs_bp_data>-source.
      lst_alv_disp-kunnr = <fs_bp_data>-partner.
      lst_alv_disp-idtype = <fs_bp_data>-idtype.
      lst_alv_disp-idnum = <fs_bp_data>-idnum.
      lst_alv_disp-namev = <fs_bp_data>-firstname.
      lst_alv_disp-name1 = <fs_bp_data>-lastname.
      lst_alv_disp-pafkt = <fs_bp_data>-function.
*    lst_alv_disp-prsnr = lst_bp_data-prsnr.
      lst_alv_disp-mail  = <fs_bp_data>-e_mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_disp-e_mail1 = <fs_bp_data>-e_mail1.
      lst_alv_disp-e_mail2 = <fs_bp_data>-e_mail2.
      lst_alv_disp-e_mail3 = <fs_bp_data>-e_mail3.
      lst_alv_disp-e_mail4 = <fs_bp_data>-e_mail4.
*---end of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
      lst_alv_disp-msgtyp = text-004.
      lst_alv_disp-msg  = lv_msg.
      APPEND lst_alv_disp TO i_alv_disp.
      CLEAR:lst_alv_disp.
    ENDIF.
  ENDLOOP.
*ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_ERROR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_error_log .
  DATA: lv_msg(1000),
        lv_header    TYPE string,
        lv_file      TYPE string,
        lst_alv_log  TYPE ty_alv_disp,
        lst_const    TYPE zcaconstant.
  CONSTANTS : lc_num TYPE char21 VALUE 'BP_CONTACT_UPD_ERROR__',
              lc_1   TYPE char1 VALUE '1'.

*  lv_msg+0(10) = 'Partner'.
*  lv_msg+10(60) = 'Identification Number'.
*  lv_msg+70(35) = 'First Name'.
*  lv_msg+105(35) = 'Last Name'.
*  lv_msg+140(2) = 'Function'.
*  lv_msg+142(241) = 'Mail'.
*  lv_msg+383(10) = text-009.
*  lv_msg+393(255) = text-007.
*

  CLEAR lst_const .
  READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param2.
  IF sy-subrc EQ 0.
    CONCATENATE lst_const-low lc_num sy-datum sy-uzeit INTO lv_file .
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.
    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.

      CONCATENATE  'Source'(029)
                   'Partner'(022)
                   'Id type'(023)
                   'Id Number'(024)
                   'First Name'(025)
                   'Last Name'(026)
                   'Function'(027)
                   'Mail'(028)
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                   'Mail2'(015)
                   'Mail3'(016)
                   'Mail4'(017)
                   'Mail5'(018)
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                   'Msg Typ'(009)
                   'Message'(007)
            INTO lv_header SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_header TO lv_file.

      LOOP AT i_alv_log INTO lst_alv_log.
*        IF sy-tabix EQ lc_1.
*          TRANSFER lv_msg TO lv_file.
*          SKIP.
*        ENDIF."sy-tabix eq lc_1.
*        TRANSFER lst_alv_log TO lv_file.

        CONCATENATE lst_alv_log-source
                    lst_alv_log-kunnr
                    lst_alv_log-idtype
                    lst_alv_log-idnum
                    lst_alv_log-namev
                    lst_alv_log-name1
                    lst_alv_log-pafkt
                    lst_alv_log-mail
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                    lst_alv_log-e_mail1
                    lst_alv_log-e_mail2
                    lst_alv_log-e_mail3
                    lst_alv_log-e_mail4
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                    lst_alv_log-msgtyp
                    lst_alv_log-msg
                    INTO DATA(lv_line) SEPARATED BY  cl_abap_char_utilities=>horizontal_tab.

        TRANSFER lv_line TO lv_file.


        CLEAR :lst_alv_log.
      ENDLOOP.
      MESSAGE i257(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.

  ENDIF."IF sy-subrc eq 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_message .
  DATA : lst_check    TYPE ty_check_bp,
         lst_adr6     TYPE ty_adr6,
         lst_alv_log  TYPE ty_alv_disp,
         lst_alv_disp TYPE ty_alv_disp,
         lst_bp_data  TYPE ty_bp_details,
         lv_msg       TYPE string,
         lv_tabix     TYPE sy-tabix,
         lst_mail     TYPE ty_mail.


  IF i_bp_data IS NOT  INITIAL.
*    SORT i_bp_data BY partner.
    SELECT kunnr,
           namev,
           name1,
           pafkt,
           prsnr
      FROM knvk
      INTO TABLE @DATA(i_check)
      FOR ALL ENTRIES IN @i_bp_data
      WHERE kunnr EQ @i_bp_data-partner
      AND   name1 EQ @i_bp_data-lastname
      AND   namev EQ @i_bp_data-firstname
      AND   pafkt EQ @i_bp_data-function.
  ENDIF.

  IF i_check IS NOT INITIAL .
    SORT i_check BY kunnr.
    SELECT persnumber,
           smtp_addr
      FROM adr6
      INTO TABLE @DATA(i_adr6)
      FOR ALL ENTRIES IN @i_check
      WHERE persnumber EQ @i_check-prsnr.
    IF sy-subrc EQ 0.
      SORT i_adr6 BY persnumber.
    ENDIF.
  ENDIF.

  SORT i_check BY kunnr namev name1.
  LOOP AT i_bp_data INTO lst_bp_data .
    lv_tabix = sy-tabix.
    CLEAR lst_check.
    READ TABLE i_check INTO lst_check WITH KEY kunnr = lst_bp_data-partner
                                               namev = lst_bp_data-firstname
                                               name1 = lst_bp_data-lastname
                                               BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR lst_adr6.
      READ TABLE i_adr6 INTO lst_adr6 WITH KEY persnumber = lst_check-prsnr
                              BINARY SEARCH.
      IF sy-subrc EQ 0 AND lst_adr6-mail EQ lst_bp_data-e_mail.
        CONCATENATE text-012 lst_mail-mail INTO lv_msg SEPARATED BY space.
        lst_alv_log-source = lst_bp_data-source.
        lst_alv_log-kunnr = lst_check-kunnr.
        lst_alv_log-idtype = lst_bp_data-idtype.
        lst_alv_log-idnum = lst_bp_data-idnum.
        lst_alv_log-namev = lst_check-namev.
        lst_alv_log-name1 = lst_check-name1.
        lst_alv_log-pafkt = lst_check-pafkt.
*        lst_alv_log-prsnr = lst_check-prsnr.
        lst_alv_log-mail  = lst_adr6-mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-e_mail1 = lst_bp_data-e_mail1.
        lst_alv_log-e_mail2 = lst_bp_data-e_mail2.
        lst_alv_log-e_mail3 = lst_bp_data-e_mail3.
        lst_alv_log-e_mail4 = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_log-msgtyp = text-004.
        lst_alv_log-msg  =   lv_msg.
        APPEND lst_alv_log TO i_alv_log.
        CLEAR lst_alv_log.
*alv log for foreground
        lst_alv_disp-source = lst_bp_data-source.
        lst_alv_disp-kunnr = lst_check-kunnr.
        lst_alv_disp-idtype = lst_bp_data-idtype.
        lst_alv_disp-idnum = lst_bp_data-idnum.
        lst_alv_disp-namev = lst_check-namev.
        lst_alv_disp-name1 = lst_check-name1.
        lst_alv_disp-pafkt = lst_check-pafkt.
*        lst_alv_disp-prsnr = lst_check-prsnr.
        lst_alv_disp-mail  = lst_adr6-mail.
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-e_mail1  = lst_bp_data-e_mail1.
        lst_alv_disp-e_mail2  = lst_bp_data-e_mail2.
        lst_alv_disp-e_mail3  = lst_bp_data-e_mail3.
        lst_alv_disp-e_mail4  = lst_bp_data-e_mail4.
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
        lst_alv_disp-msgtyp = text-004.
        lst_alv_disp-msg  =   lv_msg.
        APPEND lst_alv_disp TO i_alv_disp.
        CLEAR lst_alv_disp.
*        APPEND lst_mail TO i_mail.

        lst_bp_data-flag = abap_true.
        MODIFY i_bp_data FROM lst_bp_data INDEX lv_tabix TRANSPORTING flag.

      ENDIF.
    ENDIF.
    CLEAR : lst_bp_data,lst_check,lst_adr6.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GR_TABLE  text
*----------------------------------------------------------------------*
FORM f_set_top_of_page CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA : lo_grid  TYPE REF TO cl_salv_form_layout_grid,
         lo_grid1 TYPE REF TO cl_salv_form_layout_grid,
         lo_flow  TYPE REF TO cl_salv_form_layout_flow,
         lo_text  TYPE REF TO cl_salv_form_text,            "#EC NEEDED
         lo_label TYPE REF TO cl_salv_form_label,           "#EC NEEDED
         lo_head  TYPE string,
         lv_rows  TYPE char05.                              "#EC NEEDED

  lv_rows = lines( i_bp_data_cnt ) .
  CONDENSE lv_rows.
  CONDENSE gv_total_proc.
  CONDENSE gv_error.
  CONDENSE gv_success.

  lo_head = 'Create Contact person-Maintain Relationship between Partners'(030).

  CREATE OBJECT lo_grid.

  lo_grid->create_header_information( row     = 1
                                      column  = 1
                                      text    = lo_head
                                      tooltip = lo_head ).

  lo_grid1 = lo_grid->create_grid( row = 2
                                  column = 1
                                  colspan = 2 ).

  lo_flow = lo_grid1->create_flow( row = 2
                             column = 1 ).

*  lo_label = lo_flow->create_label( text = 'Total Records:'
*                                    tooltip = 'Total Records:' ).
*
*  lo_text = lo_flow->create_text( text = lv_rows
*                                  tooltip = lv_rows ).

  lo_flow = lo_grid1->create_flow( row = 3
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Processed : '
                                    tooltip = 'Processed : ' ).

  lo_text = lo_flow->create_text( text = gv_total_proc
                                  tooltip = gv_total_proc ).

  lo_flow = lo_grid1->create_flow( row = 4
                             column = 1 ).

  lo_label = lo_flow->create_label( text = 'Success:'
                                    tooltip = 'Success:' ).

  lo_text = lo_flow->create_text( text = gv_success
                                  tooltip = gv_success ).
*
*
  lo_flow = lo_grid1->create_flow( row = 5 column = 1 ).
  lo_label = lo_flow->create_label( text =  'Errors:'
                                    tooltip =  'Errors:' ).

  lo_text = lo_flow->create_text( text = gv_error
                                  tooltip = gv_error ).
*--Set Top of List


  co_alv->set_top_of_list( lo_grid ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_COUNT_RECORDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_count_records .
  DATA:lv_sel TYPE string.
  CONSTANTS:lc_s TYPE char1 VALUE 'S'.

  DESCRIBE TABLE i_alv_log LINES gv_error.
  DESCRIBE TABLE i_alv_slog LINES gv_success.
  DESCRIBE TABLE i_alv_disp LINES gv_lines.
  CONDENSE:gv_error,gv_success,gv_lines NO-GAPS.
  gv_total_proc = gv_no_of_records .
  IF sy-batch = abap_true.

    CONCATENATE 'Total Records'(014) gv_records INTO lv_sel SEPARATED BY space.
    MESSAGE  lv_sel TYPE lc_s.
    CONCATENATE 'successful records:'(013) gv_success INTO DATA(lv_success).
    CONCATENATE 'Error records:'(020) gv_error INTO DATA(lv_error).
    MESSAGE lv_success TYPE lc_s.
    MESSAGE lv_error TYPE lc_s.
    FREE: i_const.
    SELECT *
       FROM zcaconstant
       INTO TABLE i_const
       WHERE devid = c_devid
      AND activate = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SUCCESS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_success_log .
  DATA: lv_msg(1000) ,
        lv_file      TYPE string,
        lv_header    TYPE string,
        lst_alv_slog TYPE ty_alv_disp,
        lst_const    TYPE zcaconstant.
  CONSTANTS :lc_1 TYPE char1 VALUE '1'.
  DATA: lr_events  TYPE REF TO cl_salv_events_table,
        lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

*Place the success file at appliction server.
  CONSTANTS : lc_num TYPE char25 VALUE 'BP_CONTACT_UPD_SUCCESS_'.
*  CONCATENATE 'Partner' 'First Name' 'Last Name' 'Function' 'Mail'  text-006 text-007 INTO lv_msg SEPARATED BY space.
*  lv_msg+0(10) = 'Partner'.
*  lv_msg+10(60) = 'Identification Number'.
*  lv_msg+70(35) = 'First Name'.
*  lv_msg+105(35) = 'Last Name'.
*  lv_msg+140(2) = 'Function'.
*  lv_msg+142(241) = 'Mail'.
*  lv_msg+383(10) = text-009.
*  lv_msg+393(255) = text-007.
  CLEAR lst_const .
  READ TABLE  i_const INTO lst_const WITH KEY param1 = c_param2.
  IF sy-subrc EQ 0.
    CONCATENATE lst_const-low lc_num sy-datum sy-uzeit INTO lv_file .
    CONDENSE  lv_file NO-GAPS.
    CLOSE DATASET lv_file.
    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.

      CONCATENATE  'Source'(029)
                   'Partner'(022)
                   'Id type'(023)
                   'Id Number'(024)
                   'First Name'(025)
                   'Last Name'(026)
                   'Function'(027)
                   'Mail'(028)
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                    'Mail2'(015)
                    'Mail3'(016)
                    'Mail4'(017)
                    'Mail5'(018)
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                   'Msg Typ'(009)
                   'Message'(007)
            INTO lv_header SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_header  TO lv_file.


      LOOP AT i_alv_slog INTO lst_alv_slog.


*        IF sy-tabix EQ lc_1.
*          TRANSFER lv_msg TO lv_file.
*          SKIP.
*               ENDIF."sy-tabix eq lc_1.


        CONCATENATE lst_alv_slog-source
                    lst_alv_slog-kunnr
                    lst_alv_slog-idtype
                    lst_alv_slog-idnum
                    lst_alv_slog-namev
                    lst_alv_slog-name1
                    lst_alv_slog-pafkt
                    lst_alv_slog-mail
*---Begin of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                    lst_alv_slog-e_mail1
                    lst_alv_slog-e_mail2
                    lst_alv_slog-e_mail3
                    lst_alv_slog-e_mail4
*---End of Change VDPATABALL ERPM-11885/C105 06/05/2020 - multiple Email ID update
                    lst_alv_slog-msgtyp
                    lst_alv_slog-msg
                    INTO DATA(lv_line)
         SEPARATED BY  cl_abap_char_utilities=>horizontal_tab.


*        TRANSFER lst_alv_slog TO lv_file.

        TRANSFER lv_line TO lv_file.

        CLEAR :lst_alv_slog.
      ENDLOOP.
      MESSAGE i258(zqtc_r2) WITH lv_file.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH lv_file.
    ENDIF.
    CLOSE DATASET lv_file.

  ENDIF."IF sy-subrc eq 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_VARIABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_variable .
  REFRESH : i_check,
            i_adr6,
            i_bp_data_tmp,
            i_alv_disp,
            i_alv_log,
            i_alv_slog,
            i_bdcdata,
            i_bp_data_cnt,
            i_bdcmsg.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_VAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_var .
  REFRESH :  i_check,
             i_adr6,
             i_bp_data_tmp,
             i_alv_disp,
             i_alv_log,
             i_alv_slog,
             i_bp_data,
             i_bdcdata,
             i_bdcmsg.
ENDFORM.
