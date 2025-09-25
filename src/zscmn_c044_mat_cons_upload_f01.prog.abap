*----------------------------------------------------------------------*
* PROGRAM NAME: ZSCMN_C044_MAT_CONS_UPLOAD_F01
* PROGRAM DESCRIPTION: Load 3 years of consumption history for active materials
* DEVELOPER: Shivani Upadhyaya/Cheenangshuk Das
* CREATION DATE:   2016-07-18
* OBJECT ID: C044
* TRANSPORT NUMBER(S):ED2K902573
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&  Include           ZSCMI_C044_MAT_CONS_UPLOAD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_SYST_CPROG  text
*      -->FP_C_FIELD  text
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog " ABAP System Field: Calling Program
fp_c_field    TYPE dynfnam                                     " Field name
CHANGING fp_p_file     TYPE localfile.                         " Local file for upload/download

  CALL FUNCTION 'F4_FILENAME' "for search help in presentation server.
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_p_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_application  CHANGING fp_p_file TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_clear_all .
  CLEAR: i_upload_file,
         i_amerrdat_f.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server USING    fp_p_file        TYPE localfile " Local file for upload/download
CHANGING fp_i_upload_file TYPE tty_upload_file.
*--------------------------------------------------------------------*
*  Local Internal table
*--------------------------------------------------------------------*
  DATA:li_data_tab    TYPE tty_upload_char,
*--------------------------------------------------------------------*
*  Local Work-Area
*--------------------------------------------------------------------*
       lst_data_tab   TYPE ty_upload_char,
       lst_upload_txt TYPE ty_upload_file,
       lv_p_file      TYPE string.

  CLEAR lv_p_file.
  lv_p_file = fp_p_file.

  CLEAR li_data_tab.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_p_file
      has_field_separator     = abap_true
    TABLES
      data_tab                = li_data_tab
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16.
  IF sy-subrc IS INITIAL.
    CLEAR lst_data_tab.
    LOOP AT li_data_tab INTO lst_data_tab.
*
      CLEAR lst_upload_txt.
      lst_upload_txt-perkz  =  lst_data_tab-perkz.
*
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = lst_data_tab-matnr
        IMPORTING
          output       = lst_upload_txt-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc <> 0.
*         No actions
      ENDIF. " IF sy-subrc <> 0

      lst_upload_txt-werks  =  lst_data_tab-werks.
      lst_upload_txt-ertag  =  lst_data_tab-ertag.
      WRITE lst_data_tab-vbwrt TO lst_upload_txt-vbwrt.
      WRITE lst_data_tab-kovbw TO lst_upload_txt-kovbw.
      lst_upload_txt-kzexi  =  lst_data_tab-kzexi.
      lst_upload_txt-antei  =  lst_data_tab-antei.
*
      APPEND lst_upload_txt TO fp_i_upload_file.
      CLEAR  lst_upload_txt.
    ENDLOOP. " LOOP AT li_data_tab INTO lst_data_tab
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_app_server  USING    fp_p_file         TYPE localfile " Local file for upload/download
CHANGING fp_i_upload_file  TYPE tty_upload_file.
*--------------------------------------------------------------------*
*  Local Work-area
*--------------------------------------------------------------------*
  DATA: lst_string    TYPE string,
        lst_string2   TYPE string,
        lst_uploadtxt TYPE ty_upload_char,
        lst_upload    TYPE ty_upload_file,
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
        lv_file       TYPE localfile. " Local file for upload/download

  CLEAR lv_file.
  lv_file = fp_p_file.

*--------------------------------------------------------------------*
* Open Dataset
*--------------------------------------------------------------------*
  OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc EQ 0.
    DO.
      CLEAR: lst_string,
             lst_uploadtxt.
*--------------------------------------------------------------------*
*  Read Dataset
*--------------------------------------------------------------------*
      READ DATASET lv_file INTO lst_string.
      IF sy-subrc NE 0.
        EXIT.
      ELSE. " ELSE -> IF sy-subrc NE 0
        CLEAR lst_uploadtxt.
        SPLIT lst_string AT c_con_tab2 INTO lst_string2 lst_uploadtxt.
        SPLIT lst_string AT c_con_tab INTO  lst_uploadtxt-perkz " Perkz of type CHAR1
                         lst_uploadtxt-matnr                    " Matnr of type CHAR18
                         lst_uploadtxt-werks                    " Werks of type CHAR4
        lst_uploadtxt-ertag                                     " First day of the period to which the values refer
        lst_uploadtxt-vbwrt                                     " Consumption value
        lst_uploadtxt-kovbw                                     " Corrected consumption value
        lst_uploadtxt-kzexi                                     " Checkbox
        lst_uploadtxt-antei.                                    " Ratio of the corrected value to the original value (CV:OV).

        CLEAR lst_upload.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            input        = lst_uploadtxt-matnr
          IMPORTING
            output       = lst_upload-matnr
          EXCEPTIONS
            length_error = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
*         No actions
        ENDIF. " IF sy-subrc <> 0
        lst_upload-perkz =   lst_uploadtxt-perkz.
        lst_upload-werks  =  lst_uploadtxt-werks.
        lst_upload-ertag  =  lst_uploadtxt-ertag.
        WRITE lst_uploadtxt-vbwrt TO lst_upload-vbwrt.
        WRITE lst_uploadtxt-kovbw TO lst_upload-kovbw.
        lst_upload-kzexi  =  lst_uploadtxt-kzexi.

        WRITE lst_uploadtxt-antei TO lst_upload-antei.

        REPLACE ALL OCCURRENCES OF c_con_tab IN lst_upload-antei WITH space.
        APPEND lst_upload TO fp_i_upload_file.
        CLEAR  lst_upload.
      ENDIF. " IF sy-subrc NE 0
    ENDDO.
*--------------------------------------------------------------------*
*  Close Dataset
*--------------------------------------------------------------------*
    CLOSE DATASET lv_file.

  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_MVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_upload_mver  USING    fp_i_upload_file TYPE tty_upload_file
                    CHANGING fp_i_amerrdat_f  TYPE tty_merrdat.

*--------------------------------------------------------------------*
*  Local Internal table
*--------------------------------------------------------------------*
  DATA: li_amveg_ueb  TYPE tty_amveg,
        li_amveu_ueb  TYPE tty_amveu, " Data Transfer: Unplanned Consumption Incl. Administration

*--------------------------------------------------------------------*
*  Local variable
*--------------------------------------------------------------------*
        lv_sperrmodus LIKE tvgvi-spera, " Type of block (shared, exclusive)
        lv_max_errors LIKE t130s-anzum. " Maximum number of incorrect material master records

  CLEAR :lv_sperrmodus,
         lv_max_errors,
         li_amveg_ueb,
         li_amveu_ueb,
         fp_i_amerrdat_f.


  PERFORM f_populate_amveg USING    fp_i_upload_file
                           CHANGING li_amveg_ueb.

  CALL FUNCTION 'MVER_MAINTAIN_DARK'
    EXPORTING
      sperrmodus      = lv_sperrmodus
      max_errors      = lv_max_errors
    TABLES
      amveg_ueb       = li_amveg_ueb
      amveu_ueb       = li_amveu_ueb
      amerrdat_f      = fp_i_amerrdat_f
    EXCEPTIONS
      update_error    = 1
      internal_error  = 2
      too_many_errors = 3.
  IF sy-subrc IS INITIAL.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_AMVEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_I_UPLOAD_FILE  text
*      <--P_LI_AMVEG_UEB  text
*----------------------------------------------------------------------*
FORM f_populate_amveg  USING    fp_i_upload_file TYPE tty_upload_file
                       CHANGING fp_i_amveg_ueb   TYPE tty_amveg.

  DATA:lst_upload_file TYPE ty_upload_file,
       lst_amveg_ueb   TYPE mveg_ueb, " Data Transfer: Consumption Incl. Administration
       lv_ertag        TYPE datum.    " Date

  CLEAR lst_upload_file.
  LOOP AT fp_i_upload_file INTO lst_upload_file.

    PERFORM f_convert_period USING lst_upload_file-perkz
                                   lst_upload_file-ertag
                             CHANGING lv_ertag.

    lst_amveg_ueb-matnr =  lst_upload_file-matnr. " Material Number
    lst_amveg_ueb-werks =  lst_upload_file-werks. " Plant
    IF lv_ertag IS NOT INITIAL.
      lst_amveg_ueb-ertag =  lv_ertag. " First day of the period to which the values refer
    ENDIF. " IF lv_ertag IS NOT INITIAL
    lst_amveg_ueb-vbwrt =  lst_upload_file-vbwrt. " Consumption value
    lst_amveg_ueb-kovbw =  lst_upload_file-kovbw. " Corrected consumption value
    lst_amveg_ueb-kzexi =  lst_upload_file-kzexi. " Checkbox
    lst_amveg_ueb-antei =  lst_upload_file-antei. " Ratio of the corrected value to the original value (CV:OV)

    APPEND lst_amveg_ueb TO fp_i_amveg_ueb.
    CLEAR  lst_amveg_ueb.

  ENDLOOP. " LOOP AT fp_i_upload_file INTO lst_upload_file

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PERIOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_UPLOAD_FILE_PERKZ  text
*      -->P_LST_UPLOAD_FILE_ERTAG  text
*      <--P_LV_ERTAG  text
*----------------------------------------------------------------------*
FORM f_convert_period  USING    fp_perkz     TYPE perkz " Period Indicator
                                fp_ertag     TYPE datum          " Date
                       CHANGING fp_lv_ertag  TYPE datum.         " Date
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
  DATA: lv_week(6)  TYPE n. " Week(6) of type Numeric Text Fields
*--------------------------------------------------------------------*
*  Local Constants
*--------------------------------------------------------------------*
  CONSTANTS: lc_perkz_w TYPE perkz  VALUE 'W',  " Period Indicator
             lc_perkz_m TYPE perkz  VALUE 'M',  " Period Indicator
             lc_01      TYPE char02 VALUE '01'. " 01 of type CHAR02

  IF fp_perkz = lc_perkz_w. "'W'.

    CALL FUNCTION 'DATE_GET_WEEK'
      EXPORTING
        date         = fp_ertag
      IMPORTING
        week         = lv_week
      EXCEPTIONS
        date_invalid = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
*      No Actions
    ELSE. " ELSE -> IF sy-subrc <> 0

      CLEAR fp_lv_ertag.
      CALL FUNCTION 'WEEK_GET_FIRST_DAY'
        EXPORTING
          week         = lv_week
        IMPORTING
          date         = fp_lv_ertag
        EXCEPTIONS
          week_invalid = 1
          OTHERS       = 2.
    ENDIF. " IF sy-subrc <> 0

  ELSEIF fp_perkz = lc_perkz_m. "'M'.
    CLEAR fp_lv_ertag.

    CONCATENATE fp_ertag+0(6)
                lc_01
                INTO fp_lv_ertag.

    CONDENSE fp_lv_ertag NO-GAPS.

  ENDIF. " IF fp_perkz = lc_perkz_w
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile. " Local file for upload/download
  DATA: lv_file   TYPE string,
        lv_result TYPE abap_bool.

  CLEAR lv_file.
  lv_file = fp_p_file.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*  Error message : unable to check file 'E'
    MESSAGE e001(zqtc_r2). " Unable to check file
  ELSE. " ELSE -> IF sy-subrc <> 0
    IF lv_result EQ abap_false.
*   Error message :File does not exits 'E'
      MESSAGE e002(zqtc_r2). " 'File does not exits.

    ENDIF. " IF lv_result EQ abap_false
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_application  USING    fp_p_file TYPE localfile. " Local file for upload/download


  DATA:    lv_test TYPE orblk,            " Data block for original data
           lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
           l_len   TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables

  lv_file = fp_p_file.
  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
  IF sy-subrc EQ 0.
    CATCH SYSTEM-EXCEPTIONS dataset_read_error = 11
                          OTHERS = 12.
      READ DATASET lv_file INTO lv_test LENGTH l_len. " lst_str.

    ENDCATCH.
    IF sy-subrc EQ 0.
      CLOSE DATASET fp_p_file.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLOSE DATASET fp_p_file.
      MESSAGE e004.
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE e002. "File doesnot exist
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_SUCC_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_AMERRDAT_F  text
*      -->P_I_UPLOAD_FILE  text
*      <--P_I_ALV_DISP  text
*----------------------------------------------------------------------*
FORM f_pop_succ_tab  USING    fp_i_amerrdat_f    TYPE tty_merrdat
                              fp_i_upload_file   TYPE tty_upload_file
                     CHANGING fp_i_download_file TYPE tty_download_file.

  DATA: lst_upload_file   TYPE ty_upload_file,
        lst_download_file TYPE ty_download_file,
        lst_alv_disp      TYPE ty_alv_disp,
        lst_merrdat_f     TYPE merrdat_f, " DI: Structure for Returning Error Messages (Retail)
        lv_message        TYPE string.

  SORT fp_i_amerrdat_f BY matnr werks.

  CLEAR : fp_i_download_file,
          v_total_lines_read,
          v_error_lines,
          v_success_lines.

  v_total_lines_read =  lines(  fp_i_upload_file  ).
  v_error_lines      =  lines(  fp_i_amerrdat_f ).
  v_success_lines    =  v_total_lines_read - v_error_lines.


*  LOOP AT fp_i_upload_file INTO lst_upload_file.
  LOOP AT fp_i_amerrdat_f INTO lst_merrdat_f.
*    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
*      EXPORTING
*        input  = lst_upload_file-matnr
*      IMPORTING
*        output = lst_upload_file-matnr.
*
*    CLEAR lst_merrdat_f .
*    READ TABLE fp_i_amerrdat_f
*    INTO lst_merrdat_f
*    WITH KEY matnr = lst_upload_file-matnr
*             werks = lst_upload_file-werks
*    BINARY SEARCH.
*    READ TABLE fp_i_upload_file INTO lst_upload_file
*         WITH KEY matnr = lst_amerrdat_f-matnr
*                  werks =
*    IF sy-subrc IS INITIAL.
*      lst_download_file-indic  = c_e. " Indic of type CHAR1
*      lst_download_file-perkz  = lst_upload_file-perkz. " Period Indicator
    lst_download_file-matnr  = lst_merrdat_f-matnr. " Material Number
    lst_download_file-werks  = lst_merrdat_f-werks. " Plant
*      lst_download_file-ertag  = lst_upload_file-ertag. " First day of the period to which the values refer
*      lst_download_file-vbwrt  = lst_upload_file-vbwrt. " Consumption value
*      lst_download_file-kovbw  = lst_upload_file-kovbw. " Corrected consumption value
*      lst_download_file-kzexi  = lst_upload_file-kzexi. " Checkbox
*      lst_download_file-antei  = lst_upload_file-antei. " Ratio of the corrected value to the original value (CV:OV)

    MESSAGE ID lst_merrdat_f-msgid
    TYPE       lst_merrdat_f-msgty
    NUMBER     lst_merrdat_f-msgno
    INTO       lst_download_file-message
    WITH       lst_merrdat_f-msgv1
               lst_merrdat_f-msgv2
               lst_merrdat_f-msgv3
               lst_merrdat_f-msgv4.
    APPEND lst_download_file TO fp_i_download_file.
    CLEAR lst_download_file.

*    ENDIF. " IF sy-subrc IS INITIAL
  ENDLOOP. " LOOP AT fp_i_amerrdat_f INTO lst_merrdat_f

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      -->P_I_DOWNLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_write_file_frm_pres_server  USING    fp_p_file           TYPE localfile " Local file for upload/download
                                            fp_i_download_file  TYPE tty_download_file
                                  CHANGING  fp_v_download_chk   TYPE abap_bool.
*--------------------------------------------------------------------*
*  Local Work-Area
*--------------------------------------------------------------------*

  DATA : lst_upload_txt  TYPE ty_upload_file,
         lv_filename     TYPE localfile, " Local file for upload/download
         lv_filepath     TYPE string,
         lv_p_file       TYPE string,
         lv_down_file    TYPE string,
         lst_constant    TYPE ty_constant,
         lv_e_os_message TYPE c.         " E_os_message of type Character

  CONSTANTS : lc_asc        TYPE char10 VALUE 'ASC', " Bin of type CHAR10
              lc_underscore TYPE char1  VALUE '_'.   " Underscore of type CHAR1

  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant INTO lst_constant INDEX 1.
    lv_down_file = lst_constant-low.
  ENDIF. " IF i_constant IS NOT INITIAL

  CLEAR lv_p_file.
  lv_p_file = fp_p_file.

* Split the file path & file Name
  CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = fp_p_file
    IMPORTING
      stripped_name = lv_filename
      file_path     = lv_filepath
    EXCEPTIONS
      x_error       = 1.
  IF sy-subrc IS INITIAL.
    CLEAR lv_p_file.

    CONCATENATE lv_filepath
                lv_filename
                lc_underscore
                lv_down_file
                INTO
                lv_p_file.
  ENDIF. " IF sy-subrc IS INITIAL

  CONDENSE lv_p_file NO-GAPS.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_p_file
      filetype                = lc_asc
      write_field_separator   = abap_true
    TABLES
      data_tab                = fp_i_download_file
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    fp_v_download_chk = abap_false.
  ELSE. " ELSE -> IF sy-subrc <> 0
    fp_v_download_chk = abap_true.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      -->P_I_DOWNLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_write_file_frm_app_server  USING   fp_p_file          TYPE localfile " Local file for upload/download
                                          fp_i_download_file TYPE tty_download_file
                                 CHANGING fp_v_download_chk  TYPE abap_bool.


*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
  DATA: lv_data           TYPE string,
        lv_filename       TYPE localfile, " Local file for upload/download
        lv_filepath       TYPE string,
        lv_p_file         TYPE string,
        lst_constant      TYPE ty_constant,
        lv_e_os_message   TYPE c,         " E_os_message of type Character
        lst_download_file TYPE ty_download_file,
        lv_down_file      TYPE string.

  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant INTO lst_constant INDEX 1.
    lv_down_file = lst_constant-low.
  ENDIF. " IF i_constant IS NOT INITIAL

  CLEAR lv_p_file .
  lv_p_file  = fp_p_file.

  CLEAR: lv_filename,
         lv_filepath.

** Split the file path & file Name
  CALL FUNCTION 'CH_SPLIT_FILENAME'
    EXPORTING
      complete_filename = lv_p_file
    IMPORTING
      name_with_ext     = lv_filename
      path              = lv_filepath
    EXCEPTIONS
      invalid_drive     = 1
      invalid_path      = 2
      OTHERS            = 3.
  IF sy-subrc = 0.
    CONCATENATE lv_filepath
                lv_down_file
      INTO lv_p_file.
  ENDIF. " IF sy-subrc = 0

  REPLACE ALL OCCURRENCES OF '\' IN lv_p_file WITH '/'.

** Open the Data Set and upload the data into Application Server
  OPEN DATASET lv_p_file  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "
  IF sy-subrc = 0.
    LOOP AT fp_i_download_file INTO lst_download_file. "loop i_data to l_record
*      CONCATENATE lst_download_file-indic
*          lst_download_file-perkz
      CONCATENATE lst_download_file-matnr
         lst_download_file-werks
*          lst_download_file-ertag
*          lst_download_file-vbwrt
*          lst_download_file-kovbw
*          lst_download_file-kzexi
*          lst_download_file-antei
         lst_download_file-message
     INTO lv_data SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      TRANSFER lv_data  TO lv_p_file . "trnasfering data to source file on application server
      CLEAR: lst_download_file. "lst_line,
    ENDLOOP. " LOOP AT fp_i_download_file INTO lst_download_file

    fp_v_download_chk = abap_true.
  ENDIF. " IF sy-subrc = 0

  CLOSE DATASET lv_p_file.
  IF sy-subrc IS NOT INITIAL.
    fp_v_download_chk = abap_false.
  ENDIF. " IF sy-subrc IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tty_constant.

  CONSTANTS: lc_devid_c044  TYPE zdevid VALUE 'C044',          " Development ID
             lc_param1_c044 TYPE rvari_vnam VALUE 'FILE_NAME'. " ABAP: Name of Variant Variable


  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid = lc_devid_c044
    AND param1 = lc_param1_c044.
  IF sy-subrc IS INITIAL.

  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
