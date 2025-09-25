*----------------------------------------------------------------------*
* PROGRAM NAME: ZCAR_DOWNLOAD_AL11_TO_LOCAL
* PROGRAM DESCRIPTION: This report used to download AL11 files to desktop
* DEVELOPER:           Nageswara
* CREATION DATE:       01/07/2020
* OBJECT ID:           Utility
* TRANSPORT NUMBER(S): ED2K917205
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K917401
* REFERENCE NO: ERPM - 10869
* DEVELOPER: Aslam
* DATE: 01/28/2020
* DESCRIPTION: Error Log File download issue
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K918057
* REFERENCE NO: OTCM-45542
* DEVELOPER: TDIMANTHA
* DATE: 03/31/2022
* DESCRIPTION:File Download for Media Issue Cockpit(R115)
*----------------------------------------------------------------------*
REPORT zcar_download_al11_to_local MESSAGE-ID zqtc_r2..
*----------------------------------------------------------------------*
* INCLUDES
*----------------------------------------------------------------------*
* Data declaration
INCLUDE zcar_downld_al11_to_local_top.

* Selection screen
INCLUDE zcar_downld_al11_to_local_scr.

* Perform for routines
INCLUDE zcar_downld_al11_to_local_f01.

* Include for ZCA_AL11_DOWNLOAD t-code logic
INCLUDE zcar_downld_al11_to_local_f02 IF FOUND.

* Include for ZQTC_INV_ERR_LOG t-code logic
INCLUDE zcar_downld_al11_to_local_f03 IF FOUND.
* BOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
* Include for ZQTC_MI_CP_DOWNLOAD t-code logic
INCLUDE zcar_downld_al11_to_local_f04 IF FOUND.
* EOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022

* Initialization
INITIALIZATION.
* BOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
*  IF sy-tcode EQ c_gnrl_tcode.    " For t-code ZCA_AL11_DOWNLOAD
*    PERFORM f_set_title_al11     " Set title
*    IN PROGRAM zcar_download_al11_to_local IF FOUND.
*  ELSEIF sy-tcode EQ c_err_tcode. " For t-code ZQTC_INV_ERR_LOG
*    PERFORM f_set_title_err       " Set title
*    IN PROGRAM zcar_download_al11_to_local IF FOUND.
*  ENDIF.
* EOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
* BOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
  CASE sy-tcode.
    WHEN c_gnrl_tcode.    " For t-code ZCA_AL11_DOWNLOAD
      PERFORM f_set_title_al11     " Set title
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
    WHEN c_err_tcode.     " For t-code ZQTC_INV_ERR_LOG
      PERFORM f_set_title_err       " Set title
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
    WHEN c_mi_cp_tcode.   " For t-code ZQTC_MI_CP_DOWNLOAD
      PERFORM f_set_title_mi_cp     " Set title
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
  ENDCASE.
* EOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022

* Based on t-code display the radio buttons
AT SELECTION-SCREEN OUTPUT.
* BOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
*  IF sy-tcode EQ c_gnrl_tcode.    " For t-code ZCA_AL11_DOWNLOAD
* EOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
* BOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
  IF sy-tcode EQ c_gnrl_tcode OR sy-tcode EQ c_mi_cp_tcode.    " For t-code ZCA_AL11_DOWNLOAD / ZQTC_MI_CP_DOWNLOAD
* EOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
    PERFORM f_hide_radio_buttons  " Hide the five radio buttons
    IN PROGRAM zcar_download_al11_to_local IF FOUND.
  ELSEIF sy-tcode EQ c_err_tcode. " For t-code ZQTC_INV_ERR_LOG
    PERFORM f_clear_file_paths    " Clear the file path fields when radio button is changed
    IN PROGRAM zcar_download_al11_to_local IF FOUND.
  ENDIF.

* F4 Help for input file path
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_as_fn.
  PERFORM f_get_inputfile.

* F4 Help for output file path
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_cl_fn.
  PERFORM f_get_outputfile.

START-OF-SELECTION.
  " Download the file.
  PERFORM f_download_file.
