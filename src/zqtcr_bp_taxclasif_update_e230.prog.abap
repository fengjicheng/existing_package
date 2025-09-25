*&-----------------------------------------------------------------------*
*& Report  ZQTCR_BP_UPDATE_FROM_FILE                                     *
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_BP_UPDATE_FROM_FILE                      *
*& PROGRAM DESCRIPTION:   BP Partner Tax numbers update after fetching   *
*&                        tax numbers from Application server path       *
*& DEVELOPER:             MRAJKUMAR                                      *
*& CREATION DATE:         06/09/2021                                     *
*& OBJECT ID:                                                            *
*& TRANSPORT NUMBER(S):   ED2K924262                                     *
*&-----------------------------------------------------------------------*
REPORT ZQTCR_BP_UPDATE_FROM_FILE NO STANDARD
                                 PAGE HEADING MESSAGE-ID zqtc_r2.


INCLUDE ZQTCN_BP_TAXCLASIF_UPDATE_TOP.

INCLUDE ZQTCN_BP_TAXCLASIF_UPDATE_SEL.

INCLUDE ZQTCN_BP_TAXCLASIF_UPDATE_F01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file1.
  PERFORM f_f4_file_name   CHANGING p_file1 . "File Path

START-OF-SELECTION.
  IF  rb_back  IS NOT INITIAL
  AND sy-batch IS INITIAL.
"Schedule the PRogram in Background Job.
    PERFORM f_submit_background.
  ENDIF.
  IF rb_frnt IS NOT INITIAL.
"Read data from Excel file internal table.
    PERFORM f_read_from_excel_file.
"Write the data to Application server.
    PERFORM f_write_data_appl_server USING v_path_fname.
"Schedule the PRogram in Background Job.
    PERFORM f_submit_background.
  ENDIF.
  IF sy-batch IS NOT INITIAL.
*--Get the Application Layer path dynamically
    PERFORM f_get_file_path USING v_path_in p_file.
    REPLACE ALL OCCURRENCES OF p_file IN v_file_path WITH ''.
     CLEAR:v_dir,
           v_file_mask.
      v_dir        = v_file_path.
      v_file_mask  = p_file.
      CALL FUNCTION 'EPS_GET_DIRECTORY_LISTING'
        EXPORTING
          dir_name               = v_dir
          file_mask              = v_file_mask
        TABLES
          dir_list               = i_dir_list
        EXCEPTIONS
          invalid_eps_subdir     = 1
          sapgparam_failed       = 2
          build_directory_failed = 3
          no_authorization       = 4
          read_directory_failed  = 5
          too_many_read_errors   = 6
          empty_directory_list   = 7
          OTHERS                 = 8.
      IF sy-subrc EQ 4.
        MESSAGE text-043 TYPE c_s.
      ELSEIF sy-subrc <> 0 .
        MESSAGE text-041 TYPE c_s.
      ELSEIF sy-subrc  IS INITIAL
      AND   i_dir_list IS NOT INITIAL.
        LOOP AT i_dir_list
          INTO DATA(lst_dir).
          CLEAR v_deletefile.
          v_deletefile = lst_dir-name.
          CONCATENATE v_file_path lst_dir-name INTO v_filename.
        "Fetching the details from Application server path
          PERFORM f_read_applservpath_details.
        " Update the BP Tax numbers of BP
          PERFORM f_bp_tax_update.
        " Transfer files to Application server paths like error, success
          PERFORM f_transfer_files_appl_path.
          IF s_email[] IS NOT INITIAL.
          " Create content to send an email with attachment
            PERFORM f_create_content.
          " Send an email with Attachement.
            PERFORM f_send_email.
          ENDIF.
          APPEND LINES OF i_updatestatus TO i_finaldisplay.
          FREE i_updatestatus.
        ENDLOOP.
      ENDIF.
  ENDIF.
END-OF-SELECTION.
" Display the Updated BP Tax Details
  PERFORM f_display_bp_tax__numbers.
