*----------------------------------------------------------------------*
* PROGRAM NAME: ZCAR_DOWNLOAD_AL11_FILE
* PROGRAM DESCRIPTION: This report used to download AL11 file to desktop
* DEVELOPER:           Nageswara
* CREATION DATE:       08/23/2019
* OBJECT ID:           Utility
* TRANSPORT NUMBER(S): ED2K915945
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K916039
* REFERENCE NO: Defect -1620
* DEVELOPER: Prabhu
* DATE: 09/04/2019
* DESCRIPTION:File data is not getting downloaded completely
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K918057
* REFERENCE NO: OTCM-45542
* DEVELOPER: TDIMANTHA
* DATE: 03/31/2022
* DESCRIPTION:File Download for Media Issue Cockpit(R115)
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZCAN_DOWNLOADFILE_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_download_file .
  DATA: ls_data      TYPE string,
        lt_data      TYPE STANDARD TABLE OF ty_datablock,
        lv_block_len TYPE i,
        lv_subrc     TYPE sy-subrc,
        lv_len       TYPE i,
        lv_msgv1     LIKE sy-msgv1.
*--*BOC Prabhu TR#ED2K916039 9/4/2019 Defect ERPM-1620
*    "Open the file on application server
*  OPEN DATASET p_as_fn FOR INPUT IN BINARY MODE MESSAGE lv_msgv1.
*  IF sy-subrc <> 0.
*    MESSAGE e048(cms) WITH p_as_fn lv_msgv1 RAISING file_read_error.
*    EXIT.
*  ELSE.
*    FREE: lt_data.
*    WHILE v_flag IS INITIAL.
*      CLEAR ls_data.
*      CLEAR lv_block_len.
*      READ DATASET p_as_fn INTO ls_data LENGTH lv_len.
*      IF sy-subrc EQ 0.
*        APPEND ls_data TO lt_data.
*      ELSE.
*        v_flag = abap_true.
*      ENDIF.
*    ENDWHILE.
  DATA:
    lv_buffer  TYPE xstring,
    lv_content TYPE xstring,
    lv_mlen    TYPE i,
    lv_alen    TYPE i.

  OPEN DATASET p_as_fn FOR INPUT IN BINARY MODE MESSAGE lv_msgv1.
  IF sy-subrc <> 0.
    MESSAGE e048(cms) WITH p_as_fn lv_msgv1 RAISING file_read_error.
    EXIT.
  ELSE.
    lv_mlen = 1024.
    lv_alen = 9999.
    WHILE lv_alen <> 0.
      READ DATASET p_as_fn INTO lv_buffer MAXIMUM LENGTH lv_mlen ACTUAL LENGTH lv_alen.
      IF sy-subrc = 0.
        CONCATENATE lv_content lv_buffer INTO lv_content IN BYTE MODE.
      ENDIF.
    ENDWHILE.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = lv_content
      TABLES
        binary_tab = lt_data.
    CLEAR : lv_content, lv_buffer.
*--* EOC Prabhu TR#ED2K916039 Defect ERPM-1620
* File download to desktop
    v_filename = p_cl_fn.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
*       bin_filesize         = lv_package_len
        filename             = v_filename
        filetype             = 'BIN'
*       append               = lv_append
        show_transfer_status = abap_false
      TABLES
        data_tab             = lt_data.

    "End of file
    IF lv_subrc <> 0.
      EXIT.
    ENDIF.
    "Close the file on application server
    CLOSE DATASET p_as_fn.
    MESSAGE 'File downloaded successfully'(001) TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_OUTPUTFILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_outputfile .
  DATA : lv_filename  TYPE string,
         lv_extension TYPE string,
         lt_filetable TYPE filetable,
         lv_rc        TYPE i.
  CLEAR : lv_filename, lv_extension, lv_rc.
  REFRESH lt_filetable.
  SPLIT v_filename AT '.' INTO lv_filename lv_extension.    " Split the filename and extension
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      default_extension       = lv_extension             " default extension
      default_filename        = lv_filename              " Display default file namein F4 help
    CHANGING
      file_table              = lt_filetable             " Capture the destination path
      rc                      = lv_rc                    " Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc EQ 0.
    READ TABLE lt_filetable INTO DATA(lst_filetable) INDEX 1.
    IF sy-subrc EQ 0.
      p_cl_fn = lst_filetable-filename.                  " Display the destination path on selection screen input field
    ENDIF.
  ELSE.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'file open dialog failed'(015) TYPE c_i.
      WHEN 2.
        MESSAGE 'control error'(016) TYPE c_i.
      WHEN 3.
        MESSAGE 'error no gui'(017) TYPE c_i.
      WHEN 4.
        MESSAGE 'not supported by gui'(018) TYPE c_i.
      WHEN 5.
        MESSAGE 'Unknown error for Directory path'(003) TYPE c_i.
    ENDCASE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_INPUTFILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_inputfile .
*  BOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
*  IF sy-tcode EQ c_gnrl_tcode.    " For t-code ZCA_AL11_DOWNLOAD
*    PERFORM f_f4_al11             " F4 help for file name on '/intf' folder of application server
*    IN PROGRAM zcar_download_al11_to_local IF FOUND.
*  ELSEIF sy-tcode EQ c_err_tcode. " For t-code ZQTC_INV_ERR_LOG.
*    PERFORM f_f4_err              " F4 help for file name on application server based on radio button choosen
*    IN PROGRAM zcar_download_al11_to_local IF FOUND.
*  ENDIF.
*  EOC ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
*  BOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
  CASE sy-tcode.
    WHEN c_gnrl_tcode.    " For t-code ZCA_AL11_DOWNLOAD
      PERFORM f_f4_al11             " F4 help for file name on '/intf' folder of application server
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
    WHEN c_err_tcode.     " For t-code ZQTC_INV_ERR_LOG
      PERFORM f_f4_err              " F4 help for file name on application server based on radio button choosen
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
    WHEN c_mi_cp_tcode.   " For t-code ZQTC_MI_CP_DOWNLOAD
      PERFORM f_f4_micp             " F4 help for Media Issue Cockpit file name
      IN PROGRAM zcar_download_al11_to_local IF FOUND.
  ENDCASE.
*  EOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
ENDFORM.
