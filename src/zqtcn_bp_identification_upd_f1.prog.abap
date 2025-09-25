*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_BP_IDENTIFICATION_UPD_F1 (Include Program)      *
*REVISION NO :  ED2K919818                                            *
*REFERENCE NO:  OTCM-29968                                            *
*DEVELOPER  :   Lahiru Wathudura (LWATHUDURA)                         *
*WRICEF ID  :   E344                                                      *
*DATE       :  02/03/2021                                             *
*DESCRIPTION:  BP Identification creation                             *
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_BP_IDENTIFICATION_UPD_F1 (Include Program)      *
*REVISION NO :  ED2K923715                                            *
*REFERENCE NO:  OTCM-46084                                            *
*DEVELOPER  :   Rajkumar Madavoina(MRAJKUMAR)                         *
*WRICEF ID  :   E344                                                  *
*DATE       :  15/06/2021                                             *
*DESCRIPTION:  SFDC ID update in ZQTC_EXT_IDENT                       *
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_get_filename  CHANGING fp_filename.
  IF sy-batch = space.
    CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
      CHANGING
        file_name     = fp_filename
      EXCEPTIONS
        mask_too_long = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FROM_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_FILE_DATA  text
*----------------------------------------------------------------------*
FORM f_get_data_from_file  TABLES   p_file_data.
  DATA:li_type       TYPE truxs_t_text_data,
       lst_file_data TYPE ity_file.
  FREE:p_file_data.
  IF sy-batch = space.
*--foreground file fetching into internal table

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = p_file_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
*--Background file fetching into internal table
  ENDIF.
  IF p_file IS INITIAL.
    MESSAGE 'File path is missing'(002) TYPE c_e.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA: lv_counter       TYPE sycucol VALUE 1, " Counter of type Integers
        lst_final        TYPE ity_output,
        lst_layout       TYPE slis_layout_alv,
        lv_date          TYPE sy-datum,
        lv_invalid_email TYPE char01.

  FREE: i_fcat_out,lst_final,i_final.
  PERFORM f_buildcat USING:
             lv_counter 'BP'           'Business Partner'(003),
             lv_counter 'ID_CATEGORY'  'BP ID Category'(004),
             lv_counter 'ID_NUMBER'    'Identification Number'(005),
* BOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
             lv_counter 'EMAIL'        'E-Mail Address'(014),
             lv_counter 'VALID_F'      'Valid from Date'(015),
             lv_counter 'VALID_T'      'Valid to Date'(016),
* EOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
             lv_counter 'TYPE'         'Message Type'(006),
             lv_counter 'MESSAGE'      'Message Description'(007),
"BOC of MRAJKUMAR OTCM-46084
             lv_counter 'LOG'          'Custom Table Log'(100).
"EOC of MRAJKUMAR OTCM-46084


  " fectch BP ID categories
  SELECT category,scheme_id
    FROM tb039 INTO TABLE @DATA(li_tb039)
    FOR ALL ENTRIES IN @i_file_data
    WHERE category = @i_file_data-id_category.
  IF sy-subrc IS INITIAL.
    SORT li_tb039 BY category.
  ENDIF.

  LOOP AT i_file_data INTO DATA(lst_file_data).

    IF lst_file_data-bp IS NOT INITIAL.                         " check BP is not blank in the file
      lst_final-bp  = lst_file_data-bp.
    ELSE.                                                       " Find the bp based on email address
      IF lst_file_data-email IS NOT INITIAL.                    " Check email address is blank
        PERFORM f_validate_email USING lst_file_data-email      " Check whether email address is correct
                                 CHANGING lv_invalid_email.
        IF lv_invalid_email IS INITIAL.                         " Found correct email address
          PERFORM f_search_bp USING lst_file_data-email
                              CHANGING lst_file_data-bp
                                       lst_final-message
                                       lst_final-type.
          lst_final-bp      = lst_file_data-bp.
        ELSE.                                                   " found wrong email address.
          lst_final-type    = c_e.
          lst_final-message = 'Invalid Email address'(018).
        ENDIF.
      ELSE.                                                     " without email Bp couldn't find
        lst_final-type    = c_e.
        lst_final-message = 'BP number not found'(019).
      ENDIF.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_final-bp
      IMPORTING
        output = lst_final-bp.
    IF lst_file_data-id_category IS NOT INITIAL.
      " Validate the BP ID category with master data
      READ TABLE li_tb039 ASSIGNING FIELD-SYMBOL(<lfs_tb039>) WITH KEY category = lst_file_data-id_category BINARY SEARCH.
      IF sy-subrc = 0.
        lst_final-id_category = lst_file_data-id_category.
      ELSE.
        lst_final-type    = c_e.
        lst_final-message = 'BP Identification Category is empty'(023).
      ENDIF.
    ELSE.
      lst_final-type    = c_e.
      lst_final-message = 'BP Identification Category is empty'(021).
    ENDIF.

    IF r_pre IS NOT INITIAL OR r_pro IS NOT INITIAL.
      " continue with blank value due to prefix and suffix
    ELSE.
      IF lst_file_data-id_number IS NOT INITIAL.
        lst_final-id_number   = lst_file_data-id_number.
      ELSE.
        lst_final-type    = c_e.
        lst_final-message = 'Identification Number is empty'(022).
      ENDIF.
    ENDIF.
    lst_final-email       = lst_file_data-email.
    lst_final-valid_f     = lst_file_data-valid_f.
    lst_final-valid_t     = lst_file_data-valid_t.

    APPEND lst_final TO i_final.
    CLEAR lst_final.
  ENDLOOP.

  IF i_final IS NOT INITIAL.

    lst_layout-box_fieldname = 'SEL'.
    lst_layout-colwidth_optimize = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'F_SET_PF_STATUS'
        i_callback_user_command  = 'F_USER_COMMAND'
        is_layout                = lst_layout
        it_fieldcat              = i_fcat_out
      TABLES
        t_outtab                 = i_final
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
  ELSE.
    MESSAGE e000 WITH 'No data found'(008).
  ENDIF.

ENDFORM.

FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position  7
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132
  DATA: lst_fcat_out    TYPE slis_fieldcat_alv.
  CONSTANTS:lc_tabname  TYPE tabname   VALUE 'I_FINAL'. " Table Name

  CLEAR lst_fcat_out.
  lst_fcat_out-col_pos      = fp_col + 1.
  lst_fcat_out-lowercase    = abap_true.
  lst_fcat_out-fieldname    = fp_fld.
  lst_fcat_out-tabname      = lc_tabname.
  lst_fcat_out-seltext_m    = fp_title.

  APPEND lst_fcat_out TO i_fcat_out.
  CLEAR lst_fcat_out.

ENDFORM.

FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_user_command USING fp_ucomm        TYPE sy-ucomm       " ABAP System Field: PAI-Triggering Function Code 9
                          fp_st_selfields TYPE slis_selfield. " ABAP System Field: PAI-Triggering Function Code
  CASE fp_ucomm.
    WHEN 'UPDA'.

      PERFORM f_create_bp_identification.

  ENDCASE.
  fp_st_selfields-refresh = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_BP_IDENTIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_bp_identification .
  DATA:lst_inst_id   TYPE bapibus1006_identification,
       lst_inst_idx  TYPE bapibus1006_identification_x,
       li_return     TYPE STANDARD TABLE OF  bapiret2,
       li_but0id_new TYPE STANDARD TABLE OF  vbut0id,
       lst_but0id_t  TYPE vbut0id,
       li_but0id_old TYPE STANDARD TABLE OF  vbut0id.
"BOC of MRAJKUMAR OTCM-46084
  DATA: lst_zqtc_ext_ident TYPE zqtc_ext_ident,
        lst_log_handle     TYPE balloghndl,
        lst_msg            TYPE bal_s_msg,
        lst_number         TYPE zqtc_ext_ident-idnumber.
"EOC of MRAJKUMAR OTCM-46084
  DATA(li_output_t) = i_final.
  SORT li_output_t BY sel.
  DELETE li_output_t WHERE sel = abap_false.
* BOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
  SORT li_output_t BY type.
  DELETE li_output_t WHERE type = c_e.
* EOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
"BOC of MRAJKUMAR OTCM-46084
  PERFORM f_create_log.
"EOC of MRAJKUMAR OTCM-46084
  IF li_output_t IS NOT INITIAL.
    SELECT a~partner,            " Business Partner Number
           a~type,               " Business partner category
           a~idnumber,           " Identification Number
           a~entry_date,
           a~valid_date_from,
           a~valid_date_to,
           a~country,
           a~region
           FROM but0id     AS a " BP: ID Numbers
           INNER JOIN kna1 AS b
           ON ( a~partner EQ b~kunnr )
           INTO TABLE @DATA(li_but0id)
           FOR ALL ENTRIES IN @li_output_t
           WHERE partner EQ @li_output_t-bp
             AND type    EQ @li_output_t-id_category.
    IF sy-subrc IS INITIAL.
      SORT li_but0id BY partner type idnumber.
    ENDIF. " IF sy-subrc IS INITIAL
"BOC of MRAJKUMAR OTCM-46084
    SELECT client,  "#EC CI_SUBRC
           partner,
           type,
           idnumber,
           ext_idnumber
      FROM zqtc_ext_ident
      INTO TABLE @DATA(lt_zqtc_ext_ident)
       FOR ALL ENTRIES IN @i_final
     WHERE partner  EQ @i_final-bp
       AND type     EQ @i_final-id_category.

    IF sy-subrc IS NOT INITIAL.
"Implement Suitable error Handling
    ENDIF.

    SORT lt_zqtc_ext_ident
      BY partner
         type
         idnumber.
"EOC of MRAJKUMAR OTCM-46084
    FREE:li_output_t,lst_but0id_t.

    IF r_cid = abap_false.
      LOOP AT i_final ASSIGNING FIELD-SYMBOL(<fs_final>) WHERE sel = abap_true AND
                                                               type = space.
"BOC of MRAJKUMAR OTCM-46084
        lv_fval = text-024.
        PERFORM f_log_maintain  USING lv_fval lc_i.
*       - Updating the application log with inputs
        CONCATENATE text-025 <fs_final>-bp INTO lv_fval.
        PERFORM f_log_maintain  USING lv_fval lc_i.
        CLEAR lv_fval.
        CONCATENATE text-026 <fs_final>-id_number INTO lv_fval.
        PERFORM f_log_maintain  USING lv_fval lc_i.
        CLEAR lv_fval.
        CONCATENATE text-027 <fs_final>-id_number INTO lv_fval.
        PERFORM f_log_maintain  USING lv_fval lc_i.
        CLEAR lv_fval.
        CONCATENATE text-028 sy-uname INTO lv_fval.
        PERFORM f_log_maintain  USING lv_fval lc_i.
        CLEAR lv_fval.
        CONCATENATE text-029 sy-datum INTO lv_fval.
        PERFORM f_log_maintain  USING lv_fval lc_i.
        CLEAR lv_fval.
"EOC of MRAJKUMAR OTCM-46084
        READ TABLE li_but0id INTO DATA(lst_but0id) WITH KEY partner = <fs_final>-bp
                                                            type    = <fs_final>-id_category
                                                            idnumber = <fs_final>-id_number
                                                            BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE li_but0id INTO lst_but0id WITH KEY partner = <fs_final>-bp
                                                        type    = <fs_final>-id_category.
          IF sy-subrc = 0.
            MOVE-CORRESPONDING lst_but0id TO lst_but0id_t.
            APPEND lst_but0id_t TO li_but0id_old.
            IF r_pre  IS NOT INITIAL.
              CONCATENATE p_pre
                          lst_but0id_t-idnumber
                          INTO lst_but0id_t-idnumber.
              <fs_final>-id_number = lst_but0id_t-idnumber.
              APPEND lst_but0id_t TO li_but0id_new.
*              CLEAR p_pre.  "MRAJKUMAR
            ELSEIF r_pro IS NOT INITIAL.
              CONCATENATE lst_but0id_t-idnumber
                          p_pro
                          INTO lst_but0id_t-idnumber.
              <fs_final>-id_number = lst_but0id_t-idnumber.
              APPEND lst_but0id_t TO li_but0id_new.
*              CLEAR p_pro.  "MRAJKUMAR
            ELSE.
              lst_but0id_t-type     = <fs_final>-id_category.
              lst_but0id_t-idnumber = <fs_final>-id_number.
              APPEND lst_but0id_t TO li_but0id_new.
            ENDIF.

            IF li_but0id_new IS NOT INITIAL.
              PERFORM f_lock_but0id.      " Lock the table but0id during the record update
              INSERT but0id FROM TABLE li_but0id_new."#EC CI_IMUD_NESTED
              IF sy-subrc = 0.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                <fs_final>-type    = c_s.
                <fs_final>-message = 'Updated successfully'(011).
"BOC of MRAJKUMAR OTCM-46084
                READ TABLE lt_zqtc_ext_ident
                  ASSIGNING FIELD-SYMBOL(<fs_zqtc_ext_ident>)
                  WITH KEY partner   =  <fs_final>-bp
                           type      =  <fs_final>-id_category
                           idnumber  =  <fs_final>-id_number
                           BINARY SEARCH.
                IF  sy-subrc IS NOT INITIAL.
                  CLEAR lst_zqtc_ext_ident.
                  lst_zqtc_ext_ident-partner        =  <fs_final>-bp.
                  lst_zqtc_ext_ident-type           =  <fs_final>-id_category.
                  lst_zqtc_ext_ident-idnumber       =  <fs_final>-id_number.
                  lst_zqtc_ext_ident-ext_idnumber   =  <fs_final>-id_number.
                  INSERT zqtc_ext_ident  "#EC CI_IMUD_NESTED
                    FROM lst_zqtc_ext_ident.
                  IF sy-subrc IS INITIAL.
                    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                    lv_fval = text-030.
                    PERFORM f_log_maintain  USING lv_fval lc_i.
                    CLEAR lv_fval.
                  ENDIF.
                ENDIF.
"EOC of MRAJKUMAR OTCM-46084
              ELSE.
                <fs_final>-type    = c_e.
                <fs_final>-message = 'Update failed'(013).
                lv_fval = text-031.
                PERFORM f_log_maintain  USING lv_fval lc_e.
                CLEAR lv_fval.
              ENDIF.
              PERFORM f_unlock_but0id.      " unLock the table but0id once complete the data update
            ENDIF.
            IF li_but0id_old IS NOT INITIAL.
              PERFORM f_lock_but0id.      " Lock the table but0id during the record update
              DELETE but0id FROM TABLE li_but0id_old.  "#EC CI_IMUD_NESTED
              PERFORM f_unlock_but0id.      " unLock the table but0id once complete the data update
"BOC of MRAJKUMAR OTCM-46084
              CLEAR lst_number.
              IF r_id IS NOT INITIAL.
                lst_number = lst_but0id-idnumber.
              ELSE.
                lst_number = <fs_final>-id_number.
              ENDIF.
              READ TABLE lt_zqtc_ext_ident
                ASSIGNING <fs_zqtc_ext_ident>
                WITH KEY partner   =  <fs_final>-bp
                         type      =  <fs_final>-id_category
                         idnumber  =  lst_number
                         BINARY SEARCH.
              IF  sy-subrc IS INITIAL.
                CLEAR lst_zqtc_ext_ident.
                lst_zqtc_ext_ident-partner        =  <fs_final>-bp.
                lst_zqtc_ext_ident-type           =  <fs_final>-id_category.
                lst_zqtc_ext_ident-idnumber       =  lst_but0id-idnumber.
                lst_zqtc_ext_ident-ext_idnumber   =  lst_but0id-idnumber.
                DELETE  zqtc_ext_ident "#EC CI_IMUD_NESTED
                  FROM lst_zqtc_ext_ident.
                IF sy-subrc IS INITIAL.
                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                  lv_fval = text-032.
                  PERFORM f_log_maintain  USING lv_fval lc_i.
                  CLEAR lv_fval.
                ENDIF.
              ENDIF.
"EOC of MRAJKUMAR OTCM-46084
            ENDIF.
          ELSE.
            CLEAR lst_but0id_t.
            lst_but0id_t-partner  = <fs_final>-bp.
            lst_but0id_t-type     = <fs_final>-id_category.
            lst_but0id_t-idnumber = <fs_final>-id_number.
            lst_but0id_t-entry_date = sy-datum.
*            lst_but0id_t-valid_date_from = sy-datum.
*            lst_but0id_t-valid_date_to   = '99991231'.

            " check whether valid from date is blank
            IF <fs_final>-valid_f IS NOT INITIAL.
              lst_but0id_t-valid_date_from = <fs_final>-valid_f.
            ELSE.
              lst_but0id_t-valid_date_from = sy-datum.
            ENDIF.
            " check whether valid to date is blank
            IF <fs_final>-valid_f IS NOT INITIAL.
              lst_but0id_t-valid_date_to = <fs_final>-valid_t.
            ELSE.
              lst_but0id_t-valid_date_to   = '99991231'.
            ENDIF.

            IF r_pre  IS NOT INITIAL.
              CONCATENATE p_pre
                          lst_but0id_t-idnumber
                          INTO lst_but0id_t-idnumber.
              <fs_final>-id_number = lst_but0id_t-idnumber.
              APPEND lst_but0id_t TO li_but0id_new.
            ELSEIF r_pro IS NOT INITIAL.
              CONCATENATE lst_but0id_t-idnumber
                          p_pro
                          INTO lst_but0id_t-idnumber.
              <fs_final>-id_number = lst_but0id_t-idnumber.
              APPEND lst_but0id_t TO li_but0id_new.
            ELSE.
              lst_but0id_t-type     = <fs_final>-id_category.
              lst_but0id_t-idnumber = <fs_final>-id_number.
              APPEND lst_but0id_t TO li_but0id_new.
            ENDIF.
            IF li_but0id_new IS NOT INITIAL.
              PERFORM f_lock_but0id.      " Lock the table but0id during the record update
              INSERT but0id FROM TABLE li_but0id_new. "#EC CI_IMUD_NESTED
              IF sy-subrc = 0.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                <fs_final>-type    = c_s.
                <fs_final>-message = 'Updated successfully'(011).
"BOC of MRAJKUMAR OTCM-46084
              READ TABLE lt_zqtc_ext_ident
                ASSIGNING <fs_zqtc_ext_ident>
                WITH KEY partner   =  <fs_final>-bp
                         type      =  <fs_final>-id_category
                         idnumber  =  <fs_final>-id_number
                         BINARY SEARCH.
              IF  sy-subrc IS NOT INITIAL.
                CLEAR lst_zqtc_ext_ident.
                lst_zqtc_ext_ident-partner        =  <fs_final>-bp.
                lst_zqtc_ext_ident-type           =  <fs_final>-id_category.
                lst_zqtc_ext_ident-idnumber       =  <fs_final>-id_number.
                lst_zqtc_ext_ident-ext_idnumber   =  <fs_final>-id_number.
                INSERT zqtc_ext_ident               "#EC CI_IMUD_NESTED
                  FROM lst_zqtc_ext_ident.
                IF sy-subrc IS INITIAL.
                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                  lv_fval = text-033.
                  PERFORM f_log_maintain  USING lv_fval lc_i.
                  CLEAR lv_fval.
                ENDIF.
              ENDIF.
"EOC of MRAJKUMAR OTCM-46084
              ELSE.
                <fs_final>-type    = c_e.
                <fs_final>-message = 'Update failed'(013).
                lv_fval = text-034.
                PERFORM f_log_maintain  USING lv_fval lc_e.
                CLEAR lv_fval.
              ENDIF.
              PERFORM f_unlock_but0id.      " unLock the table but0id once complete the data update
            ENDIF.
          ENDIF.
          FREE:li_but0id_new,li_but0id_old,lst_but0id,lst_but0id_t.
        ELSE.
          <fs_final>-type    = c_e.
          <fs_final>-message = 'ID Number is already existing'(012).
"BOC of MRAJKUMAR OTCM-46084
          READ TABLE lt_zqtc_ext_ident
            ASSIGNING <fs_zqtc_ext_ident>
            WITH KEY partner   =  <fs_final>-bp
                     type      =  <fs_final>-id_category
                     idnumber  =  <fs_final>-id_number
                     BINARY SEARCH.
          IF  sy-subrc IS NOT INITIAL.
            CLEAR lst_zqtc_ext_ident.
            lst_zqtc_ext_ident-partner        =  <fs_final>-bp.
            lst_zqtc_ext_ident-type           =  <fs_final>-id_category.
            lst_zqtc_ext_ident-idnumber       =  <fs_final>-id_number.
            lst_zqtc_ext_ident-ext_idnumber   =  <fs_final>-id_number.
            INSERT zqtc_ext_ident "#EC CI_IMUD_NESTED
              FROM lst_zqtc_ext_ident.
            IF sy-subrc IS INITIAL.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
              lv_fval = text-033.
              PERFORM f_log_maintain  USING lv_fval lc_i.
              CLEAR lv_fval.
            ENDIF.
          ELSEIF sy-subrc IS INITIAL.
            lv_fval = <fs_final>-message.
            PERFORM f_log_maintain  USING lv_fval lc_e.
            CLEAR lv_fval.
          ENDIF.
        ENDIF.
        CONCATENATE gc_object gc_subobj v_log_handle
               INTO <fs_final>-log
          SEPARATED BY lc_slash.
"EOC of MRAJKUMAR OTCM-46084
      ENDLOOP.

    ELSE.     " Create new BP identification number
      LOOP AT i_final ASSIGNING FIELD-SYMBOL(<fs_final_create>) WHERE sel = abap_true AND
                                                                      type = space.
        READ TABLE li_but0id ASSIGNING FIELD-SYMBOL(<lfs_but0id>) WITH KEY partner = <fs_final_create>-bp
                                                                           type    = <fs_final_create>-id_category
                                                                           idnumber = <fs_final_create>-id_number
                                                                           BINARY SEARCH.
        IF sy-subrc NE 0.
          CLEAR lst_but0id_t.
          lst_but0id_t-partner  = <fs_final_create>-bp.
          lst_but0id_t-type     = <fs_final_create>-id_category.
          lst_but0id_t-idnumber = <fs_final_create>-id_number.
          lst_but0id_t-entry_date = sy-datum.

          " check whether valid from date is blank
          IF <fs_final_create>-valid_f IS NOT INITIAL.
            lst_but0id_t-valid_date_from = <fs_final_create>-valid_f.
          ELSE.
            lst_but0id_t-valid_date_from = sy-datum.
          ENDIF.
          " check whether valid to date is blank
          IF <fs_final_create>-valid_f IS NOT INITIAL.
            lst_but0id_t-valid_date_to = <fs_final_create>-valid_t.
          ELSE.
            lst_but0id_t-valid_date_to   = '99991231'.
          ENDIF.

          APPEND lst_but0id_t TO li_but0id_new.

          IF li_but0id_new IS NOT INITIAL.
            PERFORM f_lock_but0id.      " Lock the table but0id during the record update
            INSERT but0id FROM TABLE li_but0id_new. "#EC CI_IMUD_NESTED
            IF sy-subrc = 0.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
              <fs_final_create>-type    = c_s.
              <fs_final_create>-message = 'Updated successfully'(011).
"BOC of MRAJKUMAR OTCM-46084
                CLEAR lst_zqtc_ext_ident.
                lst_zqtc_ext_ident-partner        =  <fs_final_create>-bp.
                lst_zqtc_ext_ident-type           =  <fs_final_create>-id_category.
                lst_zqtc_ext_ident-idnumber       =  <fs_final_create>-id_number.
                lst_zqtc_ext_ident-ext_idnumber   =  <fs_final_create>-id_number.
                INSERT zqtc_ext_ident   "#EC CI_IMUD_NESTED
                  FROM lst_zqtc_ext_ident.
                IF sy-subrc IS INITIAL.
                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                  lv_fval = text-033.
                  PERFORM f_log_maintain  USING lv_fval lc_i.
                  CLEAR lv_fval.
                ENDIF.
"EOC of MRAJKUMAR OTCM-46084
            ELSE.
              <fs_final_create>-type    = c_e.
              <fs_final_create>-message = 'Update failed'(013).
              lv_fval = text-034.
              PERFORM f_log_maintain  USING lv_fval lc_e.
              CLEAR lv_fval.
            ENDIF.
            PERFORM f_unlock_but0id.      " unLock the table but0id once complete the data update
          ENDIF.
        ELSE.
          <fs_final_create>-type    = c_e.
          <fs_final_create>-message = 'ID Number is already existing'(012).
          lv_fval = <fs_final_create>-message.
          PERFORM f_log_maintain  USING lv_fval lc_e.
          CLEAR lv_fval.
"BOC of MRAJKUMAR OTCM-46084
          UNASSIGN <fs_zqtc_ext_ident>.
          READ TABLE lt_zqtc_ext_ident
            ASSIGNING <fs_zqtc_ext_ident>
            WITH KEY partner   =  <fs_final_create>-bp
                     type      =  <fs_final_create>-id_category
                     idnumber  =  <fs_final_create>-id_number
                     BINARY SEARCH.
          IF  sy-subrc IS NOT INITIAL.
            CLEAR lst_zqtc_ext_ident.
            lst_zqtc_ext_ident-partner        =  <fs_final_create>-bp.
            lst_zqtc_ext_ident-type           =  <fs_final_create>-id_category.
            lst_zqtc_ext_ident-idnumber       =  <fs_final_create>-id_number.
            lst_zqtc_ext_ident-ext_idnumber   =  <fs_final_create>-id_number.
            INSERT zqtc_ext_ident    "#EC CI_IMUD_NESTED
              FROM lst_zqtc_ext_ident.
            IF sy-subrc IS INITIAL.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
              lv_fval = text-033.
              PERFORM f_log_maintain  USING lv_fval lc_i.
              CLEAR lv_fval.
            ENDIF.
          ELSEIF sy-subrc IS INITIAL.
            lv_fval = <fs_final_create>-message.
            PERFORM f_log_maintain  USING lv_fval lc_e.
            CLEAR lv_fval.
          ENDIF.
"EOC of MRAJKUMAR OTCM-46084
        ENDIF.
        FREE : li_but0id_new , lst_but0id_t.
        CONCATENATE gc_object gc_subobj v_log_handle
               INTO <fs_final_create>-log
          SEPARATED BY lc_slash.
      ENDLOOP.
    ENDIF. " IF  i_output_t IS NOT INITIAL.
  ENDIF.
* Save the log
  PERFORM f_log_save.
ENDFORM.

FORM f_validate_email  USING fp_email
                       CHANGING fp_invalid_email.

  DATA : lst_address TYPE sx_address.

  CONSTANTS : lc_type TYPE sx_address-type VALUE 'INT'.

  IF fp_email IS NOT INITIAL.

    lst_address-address = fp_email.
    lst_address-type = lc_type.

    CALL FUNCTION 'SX_INTERNET_ADDRESS_TO_NORMAL'
      EXPORTING
        address_unstruct    = lst_address
        complete_address    = abap_true
      EXCEPTIONS
        error_address_type  = 1
        error_address       = 2
        error_group_address = 3
        OTHERS              = 4.
    IF sy-subrc <> 0.
      fp_invalid_email = abap_true.
    ENDIF.

  ENDIF.

ENDFORM.

FORM f_search_bp  USING    fp_email
                  CHANGING fp_bp
                           fp_message
                           fp_type.

  DATA : li_return        TYPE STANDARD TABLE OF bapiret2,
         li_search_result TYPE STANDARD TABLE OF bus020_search_result,
         lv_email         TYPE ad_smtpadr,
         lv_lines         TYPE i.

  lv_email = fp_email.

  CALL FUNCTION 'BUPA_SEARCH_2'
    EXPORTING
      iv_email         = lv_email
      iv_req_mask      = abap_true
    TABLES
      et_search_result = li_search_result
      et_return        = li_return.

  DESCRIBE TABLE li_search_result LINES lv_lines.
  IF lv_lines = 1.
    READ TABLE li_search_result INTO DATA(lst_search_result) INDEX 1.
    fp_bp = lst_search_result-partner.
  ELSEIF lv_lines GT 1 .
    fp_message = 'Multiple BP numbers found'(020).
    fp_type    = c_e.
  ELSE.
    fp_message = 'BP number not found'(019).
    fp_type    = c_e.
  ENDIF.

ENDFORM.

FORM f_lock_but0id.
  CALL FUNCTION 'ENQUEUE_EZZQTC_LOCKBPID'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM f_unlock_but0id.

  CALL FUNCTION 'DEQUEUE_EZZQTC_LOCKBPID'.
  IF sy-subrc <> 0 .
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_CREATE_LOG .

  DATA : lst_log  TYPE bal_s_log, " Application Log: Log header data
         lv_date  TYPE aldate_del.
  CONSTANTS:lc_s  TYPE char1 VALUE '/'.

  v_days = '730'.
  lv_date = sy-datum + v_days.

* define some header data of this log
  lst_log-extnumber  = sy-datum.
  lst_log-object     = gc_object.
  lst_log-subobject  = gc_subobj.
  lst_log-aldate     = sy-datum.
  lst_log-altime     = sy-uzeit.
  lst_log-aluser     = sy-uname.
  lst_log-alprog     = sy-repid.
  lst_log-aldate_del = lv_date.
  lst_log-extnumber  = v_exter.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log
    IMPORTING
      e_log_handle            = v_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MAINTAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_FVAL  text
*      -->P_LC_I  text
*----------------------------------------------------------------------*
FORM f_log_maintain  USING fp_lv_fval TYPE char200
                           fp_lv_magty TYPE symsgty.
  DATA : lst_msg       TYPE bal_s_msg, " Application Log: Message Data
         lv_fval      TYPE int4.

  lst_msg-msgty     = fp_lv_magty."'I'.
  lst_msg-msgid     = 'ZQTC_R2'.
  lst_msg-msgno     = '000'.

  lv_fval = strlen( fp_lv_fval ).

  IF lv_fval LE 50.
    lst_msg-msgv1 = fp_lv_fval.
  ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
  ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
    lst_msg-msgv3 = fp_lv_fval+100(50).
  ELSE. " ELSE -> IF lv_fval LE 50
    lst_msg-msgv1 = fp_lv_fval+0(50).
    lst_msg-msgv2 = fp_lv_fval+50(50).
    lst_msg-msgv3 = fp_lv_fval+100(50).
    lst_msg-msgv4 = fp_lv_fval+150(50).

  ENDIF. " IF lv_fval LE 50
  lst_msg-msgv4 = v_msgno.
  CLEAR v_msgno.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = v_log_handle
      i_s_msg          = lst_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_LOG_SAVE .
*Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'    ##FM_SUBRC_OK
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
