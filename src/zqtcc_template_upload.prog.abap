*---------------------------------------------------------------------*
* Report  ZQTCC_TEMPLATE_UPLOAD
* PROGRAM DESCRIPTION: File layout upload program
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E255
* TRANSPORT NUMBER(S):  ED2K916954
*---------------------------------------------------------------------*
REPORT zqtcc_template_upload NO STANDARD PAGE HEADING
                                  MESSAGE-ID zfilupload.


INCLUDE zqtcn_template_upload_top IF FOUND.        " Define global data

INCLUDE zqtcn_template_upload_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_template_upload_sub IF FOUND.        " Subroutines.


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

* Select WRICEF ID
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_wricef.
  PERFORM f_getwricef_id CHANGING p_wricef.

* Select file path
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = sy-repid
      dynpro_number = sy-dynnr
    IMPORTING
      file_name     = p_fname.

* Comments adding using the popup window
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_comme.
  PERFORM f_get_comment CHANGING p_comme.

START-OF-SELECTION.
  PERFORM f_prepare_file_content.     " Prepare file content
  PERFORM f_process_data.             " Process data upto DB update
