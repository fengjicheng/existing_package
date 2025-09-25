*&---------------------------------------------------------------------*
*& Report  ZQTCC_TEMPLATE_DOWNLOAD
* PROGRAM DESCRIPTION: File layout Download program
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*
REPORT zqtcc_template_download NO STANDARD PAGE HEADING
                                  MESSAGE-ID zfilupload.

INCLUDE zqtcn_template_download_top IF FOUND.        " Define global data

INCLUDE zqtcn_template_download_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_template_download_sub IF FOUND.        " Subroutines.


* Select Program Name
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_prname.
  PERFORM f_getprogram_name CHANGING p_prname.

* Select Template name based on program name
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_tmname.
  IF p_prname IS NOT INITIAL.
    PERFORM f_gettemplate_name CHANGING p_tmname.
  ELSE.
    MESSAGE s000(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

* Select version number based on program name and template name
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_versio.
  IF p_prname IS NOT INITIAL AND p_tmname IS NOT INITIAL.
    PERFORM f_get_version CHANGING p_versio.
  ELSE.
    MESSAGE s006(zfilupload) DISPLAY LIKE c_errtype.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fpath.
  CLEAR : v_fullpath.
  v_fullpath = p_fpath.
  v_window_title = text-002.                                  " Window title
  CALL METHOD cl_gui_frontend_services=>file_save_dialog      " Open the save file dialog
    EXPORTING
      window_title              = v_window_title
    CHANGING
      filename                  = v_filename
      path                      = v_path
      fullpath                  = v_fullpath
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      OTHERS                    = 5.
  IF sy-subrc <> 0.
    MESSAGE s026(zfilupload) DISPLAY LIKE c_errtype.
  ELSE.
    PERFORM f_get_file_content CHANGING v_xstr_content
                                        v_fullpath.         " get file content
    p_fpath = v_fullpath.                                 " Assign with the file extension for selection screen
  ENDIF.

START-OF-SELECTION.
  PERFORM f_download_file USING v_xstr_content.               " Download file content
