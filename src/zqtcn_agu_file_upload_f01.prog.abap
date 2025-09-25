*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_AGU_FILE_UPLOAD
* PROGRAM DESCRIPTION: This report used to Upload AGU file to AL11
* DEVELOPER:           GKAMMILI
* CREATION DATE:       10/22/2019
* OBJECT ID:           I0368
* TRANSPORT NUMBER(S):ED2K916513
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_AGU_FILE_UPLOAD_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_OUTPUTFILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_outputfile .
*--Function module for getting the desktop file path
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_cl_fn " File Path
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
*&      Form  F_UPLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_file .

  DATA: lv_len           TYPE i,
        lv_msgv1         TYPE sy-msgv1,
        lv_mlen          TYPE i,
        lv_file_len      TYPE i,
        lv_lines         TYPE i,
        lv_all_lines_len TYPE i,
        lv_diff_len      TYPE i.

*-- open the file on the application server for reading to check if the
*-- file exists on the application serve
  CONCATENATE p_as_fn p_as_nm INTO p_as_fn.
  OPEN DATASET p_as_fn FOR INPUT MESSAGE lv_msgv1
                       IN BINARY MODE.
  IF sy-subrc = 0 AND p_over = space.
    CLOSE DATASET p_as_fn.  " Close dataset
    MESSAGE:'File alredy exits'(005) TYPE 'I'.
    EXIT.
  ELSE.
*-- close dataset
    CLOSE DATASET p_as_fn.
  ENDIF.

  CLEAR lv_msgv1.
*-- Function module for read the data from presentaion server
  v_filename = p_cl_fn.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                      = v_filename
      FILETYPE                      = 'BIN'
    IMPORTING
      FILELENGTH                    = lv_file_len
    TABLES
      DATA_TAB                      = i_data
    EXCEPTIONS
      FILE_OPEN_ERROR               = 1
      FILE_READ_ERROR               = 2
      NO_BATCH                      = 3
      GUI_REFUSE_FILETRANSFER       = 4
      INVALID_TYPE                  = 5
      NO_AUTHORITY                  = 6
      UNKNOWN_ERROR                 = 7
      BAD_DATA_FORMAT               = 8
      HEADER_NOT_ALLOWED            = 9
      SEPARATOR_NOT_ALLOWED         = 10
      HEADER_TOO_LONG               = 11
      UNKNOWN_DP_ERROR              = 12
      ACCESS_DENIED                 = 13
      DP_OUT_OF_MEMORY              = 14
      DISK_FULL                     = 15
      DP_TIMEOUT                    = 16
      OTHERS                        = 17
            .
  IF SY-SUBRC <> 0.
    MESSAGE:'Error when uploading the file'(003) TYPE 'E'.
  ENDIF.
  DESCRIBE TABLE i_data LINES lv_lines.
  lv_mlen = 2550.
*-- Open data set for writing the data to specified file
  OPEN DATASET  p_as_fn FOR OUTPUT IN BINARY MODE MESSAGE lv_msgv1.
  IF sy-subrc <> 0.
    MESSAGE e048(cms) WITH p_as_fn lv_msgv1 .
  ELSE.
    lv_len = lv_mlen.
    LOOP AT i_data INTO st_data.
      IF sy-tabix = lv_lines.
        lv_all_lines_len = lv_mlen * ( lv_lines - 1 ).
        lv_diff_len = lv_file_len - lv_all_lines_len.
        lv_len = lv_diff_len.
      ENDIF.
*-- Transfer data to file
      TRANSFER st_data to p_as_fn LENGTH lv_len.
      IF sy-subrc NE 0.
        MESSAGE:'Error when transfering the data'(004) TYPE 'E'.
      ENDIF.
    ENDLOOP.
*-- Close datset to close the file
    CLOSE DATASET p_as_fn.
    IF sy-subrc = 0.
      MESSAGE 'File uploaded successfully '(002) TYPE 'S'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_VALES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_init_vales.
*-- Preparing file path
  CONCATENATE '/intf/zapp/' sy-sysid '/I0368/in/' INTO p_as_fn.
*-- Making Application server path selection field disable
  LOOP AT SCREEN.
    IF screen-name = 'P_AS_FN'.
      screen-INPUT  = space..
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
