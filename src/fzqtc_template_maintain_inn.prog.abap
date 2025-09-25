*&---------------------------------------------------------------------*
*&  Include           FZQTC_TEMPLATE_MAINTAIN_INN
* PROGRAM DESCRIPTION: File layout Maintain PAI Program
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

MODULE user_command_2000 INPUT.

  CASE ok_code.                              " Back
    WHEN 'BCK'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.                             " Exit
      LEAVE PROGRAM.
    WHEN 'CLOSE'.                            " Close
      LEAVE PROGRAM.
    WHEN 'DISPLAY'.
      PERFORM f_display_output_data.         " Display data based on screen selection
    WHEN 'SAVE'.
      PERFORM f_save_data.                   " Save data
    WHEN 'RAD'.
      PERFORM f_dynamic_screen_output.       " dynamic screen output based on radio button selection
  ENDCASE.
  CLEAR ok_code.

ENDMODULE.

FORM f_display_output_data .

  " remove unwanted space from the sreen fields
  CONDENSE st_control_data-program_name.
  CONDENSE st_control_data-template_name.
  CONDENSE st_control_data-version.

  IF rb_viewdata = abap_true.       " Check view data radio button is active for report view
    IF st_control_data-program_name IS INITIAL OR st_control_data-template_name IS INITIAL.  " Check program name or template is null
      IF st_control_data-program_name IS INITIAL AND st_control_data-template_name IS NOT INITIAL.                 " program name is null
        SELECT program_name,template_name,version,active,upload_location,erdat,ernam,erzet,aedat,aenam,cputm,wricef_id,comments,file_type
          FROM zca_templates
          INTO TABLE @i_template_data
          WHERE template_name = @st_control_data-template_name.
      ELSEIF st_control_data-program_name IS NOT INITIAL AND st_control_data-template_name IS INITIAL.
        SELECT program_name,template_name,version,active,upload_location,erdat,ernam,erzet,aedat,aenam,cputm,wricef_id,comments,file_type
          FROM zca_templates
          INTO TABLE @i_template_data
          WHERE program_name = @st_control_data-program_name.
      ELSEIF st_control_data-program_name IS INITIAL AND st_control_data-template_name IS INITIAL.
        SELECT program_name,template_name,version,active,upload_location,erdat,ernam,erzet,aedat,aenam,cputm,wricef_id,comments,file_type
          FROM zca_templates
          INTO TABLE @i_template_data.
      ENDIF.
      IF i_template_data IS NOT INITIAL.    " check output table is null
        SORT i_template_data BY program_name template_name version.
        PERFORM f_display_report_data.      " prepare report output
        CALL SCREEN 2003.
      ELSE.
        MESSAGE i013(zfilupload).
      ENDIF.
    ELSE.
      PERFORM get_data.         " get data based on screen fields for report output
      IF i_template_data IS NOT INITIAL.    " check output table is null
        PERFORM f_display_report_data.      " prepare report output
        CALL SCREEN 2003.
      ELSE.
        MESSAGE i013(zfilupload).
      ENDIF.
    ENDIF.
  ELSE.               " update record
    IF st_control_data-program_name IS INITIAL OR st_control_data-template_name IS INITIAL OR st_control_data-version IS INITIAL. " check screen fields are null
      IF st_control_data-program_name IS INITIAL.                 " program name is null
        MESSAGE s018(zfilupload) DISPLAY LIKE c_msgty_e.
      ELSEIF st_control_data-template_name IS INITIAL.            " Template name is null
        MESSAGE s019(zfilupload) DISPLAY LIKE c_msgty_e.
      ELSEIF st_control_data-version IS INITIAL.                  " Version is null
        MESSAGE s020(zfilupload) DISPLAY LIKE c_msgty_e.
      ENDIF.
    ELSE.                                                         " Screen fields are not null
      PERFORM f_get_updated_data.             " get updated data from DB
      IF st_control_data IS NOT INITIAL.
        SELECT program_name template_name version active                        " select data for get record count
           FROM zca_templates
          INTO TABLE i_recordcount
          WHERE program_name = st_control_data-program_name AND
          template_name = st_control_data-template_name.
        IF sy-subrc IS INITIAL.
          DESCRIBE TABLE i_recordcount LINES v_recordcount.                     " get Itab record count
        ENDIF.
      ELSE.
        MESSAGE s021(zfilupload) DISPLAY LIKE c_msgty_e..
      ENDIF.
      " Values not found based on screen field input
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_save_data .

  IF st_control_data-program_name IS INITIAL OR st_control_data-template_name IS INITIAL OR st_control_data-version IS INITIAL. " check screen fields are null
    IF st_control_data-program_name IS INITIAL.                 " program name is null
      MESSAGE s018(zfilupload) DISPLAY LIKE c_msgty_e.
    ELSEIF st_control_data-template_name IS INITIAL.            " Template name is null
      MESSAGE s019(zfilupload) DISPLAY LIKE c_msgty_e.
    ELSEIF st_control_data-version IS INITIAL.                  " Version is null
      MESSAGE s020(zfilupload) DISPLAY LIKE c_msgty_e.
    ENDIF.
  ELSE.
    IF ( st_control_data_dupliacate-wricef_id = st_control_data-wricef_id ) AND ( st_control_data_dupliacate-comments = st_control_data-comments )
                        AND ( st_control_data_dupliacate-active = st_control_data-active ) .    " check same data going to update
      MESSAGE s023(zfilupload) DISPLAY LIKE c_msgty_e.
    ELSE.
      IF st_control_data_dupliacate-active NE st_control_data-active.     " Check Active/deactive changes going to made
        IF st_control_data-active = abap_true.                            " deactivated version going to be active
          IF st_active_data-program_name IS INITIAL.                      " Check is there any active versions exist if No
            PERFORM f_update_db USING st_control_data-program_name        " Update DB with latest changes
                                      st_control_data-template_name
                                      st_control_data-version
                                      st_control_data-active
                                      st_control_data-wricef_id
                                      st_control_data-comments.
          ELSE.
            IF  v_recordcount GT 1.                                                            " Active version already in the DB
              CALL SCREEN 2002            " Call Confirmation & information screen and
                STARTING AT 60 10
                ENDING AT   105 13.
            ELSE.                             " less than 1 then update existing record
              PERFORM f_update_db USING st_control_data-program_name        " Update DB with latest changes
                                        st_control_data-template_name
                                        st_control_data-version
                                        st_control_data-active
                                        st_control_data-wricef_id
                                        st_control_data-comments.
            ENDIF.
          ENDIF.
        ELSE.                                                             " active version going to dectivate
          IF st_active_data-program_name IS INITIAL.                      " Check is there any active versions exist if No
            PERFORM f_update_db USING st_control_data-program_name        " Update DB with latest changes
                                      st_control_data-template_name
                                      st_control_data-version
                                      st_control_data-active
                                      st_control_data-wricef_id
                                      st_control_data-comments.                                                              " active version going to be deactive
          ELSE.
            IF  v_recordcount GT 1.           " record count more than 1 then move to version selection
              CALL SCREEN 2001
                  STARTING AT 60 10
                  ENDING AT   105 13.
            ELSE.                             " less than 1 then update existing record
              PERFORM f_update_db USING st_control_data-program_name        " Update DB with latest changes
                                        st_control_data-template_name
                                        st_control_data-version
                                        st_control_data-active
                                        st_control_data-wricef_id
                                        st_control_data-comments.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        PERFORM f_update_db USING st_control_data-program_name             " Update DB with latest changes
                          st_control_data-template_name
                          st_control_data-version
                          st_control_data-active
                          st_control_data-wricef_id
                          st_control_data-comments.
      ENDIF.
    ENDIF.
  ENDIF.

  PERFORM f_get_updated_data.

ENDFORM.

FORM f_update_db  USING fp_control_data-program_name
                        fp_control_data-template_name
                        fp_control_data-version
                        fp_control_data_active
                        fp_control_data_wricef_id
                        fp_control_data_comments.

  " Update DB table
  UPDATE zca_templates SET active = fp_control_data_active
                           aedat = sy-datum
                           aenam = sy-uname
                           cputm = sy-uzeit
                           wricef_id = fp_control_data_wricef_id
                           comments = fp_control_data_comments
                           WHERE program_name = fp_control_data-program_name      AND
                                 template_name  = fp_control_data-template_name   AND
                                 version = fp_control_data-version.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    MESSAGE s016(zfilupload).
  ELSE.
    ROLLBACK WORK.
    MESSAGE s017(zfilupload) DISPLAY LIKE c_msgty_e.
  ENDIF.

ENDFORM.

MODULE user_command_2001 INPUT.

  CASE sy-ucomm.
    WHEN 'OK'.
      PERFORM f_database_update.        " update DB
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN'CAN'.
      st_control_data-version = st_previous_data-version.     " Assign previous screen as a screen value
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.

FORM f_database_update .

  PERFORM f_inactive_record USING st_control_data-program_name          " Incative existing active record
                                  st_control_data-template_name
                                  st_previous_data-version
                                  st_control_data-wricef_id
                                  st_control_data-comments.

  PERFORM f_active_record USING st_control_data-program_name            " Active new record
                                st_control_data-template_name
                                st_control_data-version
                                st_control_data-wricef_id
                                st_control_data-comments.

ENDFORM.

FORM f_inactive_record USING fp_prname
                             fp_tmname
                             fp_preversion
                             fp_wricef_id
                             fp_comments.

  " Update DB table
  UPDATE zca_templates SET active = abap_false
                           aedat = sy-datum
                           aenam = sy-uname
                           cputm = sy-uzeit
                           wricef_id = fp_wricef_id
                           comments = fp_comments
                           WHERE program_name = fp_prname       AND
                                 template_name  = fp_tmname     AND
                                 version = fp_preversion.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s007(zfilupload) DISPLAY LIKE c_msgty_e.
  ENDIF.

ENDFORM.

FORM f_active_record  USING fp_program_name
                            fp_template_name
                            fp_version
                            fp_wricef_id
                            fp_comments.

  " Update DB table
  UPDATE zca_templates SET active = abap_true
                           aedat = sy-datum
                           aenam = sy-uname
                           cputm = sy-uzeit
                           wricef_id = fp_wricef_id
                           comments = fp_comments
                           WHERE program_name = fp_program_name     AND
                                 template_name  = fp_template_name  AND
                                 version = fp_version.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    st_control_data-version = st_previous_data-version.
    MESSAGE s016(zfilupload).
  ELSE.
    ROLLBACK WORK.
    MESSAGE s017(zfilupload) DISPLAY LIKE c_msgty_e.
  ENDIF.

ENDFORM.

MODULE user_command_2002 INPUT.

  CASE sy-ucomm.
    WHEN 'OK'.                                " Confirmation for proccess
      PERFORM f_database_update_2002.         " Update DB
      st_control_data-version = st_previous_data-version.     " Assign previous screen as a screen value
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN'CAN'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.

FORM f_database_update_2002 .

  PERFORM f_inactive_record USING st_active_data-program_name          " Incative existing active record
                                  st_active_data-template_name
                                  st_active_data-version
                                  st_active_data-wricef_id
                                  st_active_data-comments.

  PERFORM f_active_record USING st_control_data-program_name            " Active new record
                                st_control_data-template_name
                                st_control_data-version
                                st_control_data-wricef_id
                                st_control_data-comments.

ENDFORM.

MODULE user_command_2003 INPUT.

  CALL METHOD v_cc_reportout->free. " free Custom container

  CASE sy-ucomm.
    WHEN 'BACK'.                        " back
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.                        " Exit
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANCEL'.                      " Cancel
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.

FORM get_data.

  REFRESH : i_template_data[].      " clear itab for report data output
  PERFORM f_fetch_report_data USING st_control_data-program_name        " Fetch data for report output
                                    st_control_data-template_name
                                    CHANGING i_template_data.

ENDFORM.

FORM f_fetch_report_data USING fp_prname
                               fp_tmname
                               CHANGING fp_template_data TYPE tt_template_data.

  SELECT program_name,template_name,version,active,upload_location,erdat,ernam,  " select data for report output
         erzet,aedat,aenam,cputm,wricef_id,comments
    FROM zca_templates
    INTO TABLE @fp_template_data
    WHERE program_name = @fp_prname AND
          template_name = @fp_tmname.
  IF sy-subrc IS INITIAL.
    SORT fp_template_data BY program_name template_name version.      " sort data
  ENDIF.

ENDFORM.
FORM f_display_report_data .

  PERFORM f_build_report_fieldcat.        " Build field catalog

ENDFORM.

FORM f_build_report_fieldcat .

  CLEAR : st_fieldcat,i_fieldcat[].   " Clear field catalog structure and itab

  PERFORM f_build_fcat_detail USING : 'PROGRAM_NAME' 'I_TEMPLATE_DATA' text-005 '40' '15',
                                      'TEMPLATE_NAME' 'I_TEMPLATE_DATA' text-006 '50' '15',
                                      'VERSION' 'I_TEMPLATE_DATA' text-007 '4' '7',
                                      'ACTIVE' 'I_TEMPLATE_DATA' text-008 '1' '6',
                                      'UPLOAD_LOCATION' 'I_TEMPLATE_DATA' text-009 '' '20',
                                      'ERNAM' 'I_TEMPLATE_DATA' text-010 '12' '12',
                                      'ERDAT' 'I_TEMPLATE_DATA' text-011 '' '',
                                      'ERZET' 'I_TEMPLATE_DATA' text-012 '' '',
                                      'WRICEF_ID' 'I_TEMPLATE_DATA' text-013 '10' '10',
                                      'COMMENTS' 'I_TEMPLATE_DATA' text-014 '' '20',
                                      'FILE_TYPE' 'I_TEMPLATE_DATA' text-018 '' '13',
                                      'AENAM' 'I_TEMPLATE_DATA' text-015 '12' '12',
                                      'AEDAT' 'I_TEMPLATE_DATA' text-016 '' '',
                                      'CPUTM' 'I_TEMPLATE_DATA' text-017 '' '10'.

ENDFORM.

FORM f_build_fcat_detail USING fp_field TYPE any    " Field Name
                               fp_tab TYPE any      " Itab Name
                               fp_text TYPE any     " Display Text
                               fp_ddout TYPE any    " ALV filtering box length
                               fp_outlen TYPE any.  " Output length in ALV grid

  st_fieldcat-fieldname = fp_field.
  st_fieldcat-tabname   = fp_tab.
  st_fieldcat-coltext   = fp_text.
  st_fieldcat-lowercase  = abap_true.
  st_fieldcat-dd_outlen = fp_ddout.
  st_fieldcat-outputlen = fp_outlen.

  APPEND st_fieldcat TO i_fieldcat.
  CLEAR st_fieldcat.

ENDFORM.

FORM f_get_updated_data.

  " Select values based on screen filds value and assign to screen fields
  SELECT SINGLE active upload_location erdat ernam erzet aedat aenam cputm wricef_id comments file_type
    FROM zca_templates
    INTO ( st_control_data-active , st_control_data-upload_location , st_control_data-erdat , st_control_data-ernam,
            st_control_data-erzet , st_control_data-aedat , st_control_data-aenam , st_control_data-cputm ,
            st_control_data-wricef_id , st_control_data-comments , st_control_data-file_type )
          WHERE program_name EQ st_control_data-program_name   AND
                template_name EQ st_control_data-template_name AND
                version EQ st_control_data-version.
  IF sy-subrc IS INITIAL.                                                 " If value found
    st_control_data_dupliacate-wricef_id = st_control_data-wricef_id.     " Current DB values assign to tempory structure to identify the changes
    st_control_data_dupliacate-comments = st_control_data-comments.
    st_control_data_dupliacate-active = st_control_data-active.

    SELECT SINGLE program_name template_name version active wricef_id comments file_type      " Select the current active version for deactivation purpose
      FROM zca_templates
      INTO (st_active_data-program_name , st_active_data-template_name , st_active_data-version , st_active_data-active,
             st_active_data-wricef_id , st_active_data-comments , st_active_data-file_type )
      WHERE program_name EQ st_control_data-program_name   AND
            template_name EQ st_control_data-template_name AND
            active EQ abap_true.
    IF sy-subrc IS INITIAL.
      " nothing to do
    ENDIF.
  ELSE.                       " no data for current seletion
    MESSAGE i013(zfilupload).
  ENDIF.

ENDFORM.
