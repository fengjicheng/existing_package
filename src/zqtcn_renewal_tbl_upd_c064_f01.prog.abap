*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_RENEWAL_TBL_UPD_C064_F01(Subroutine Declaration)
* PROGRAM DESCRIPTION: Update renewal Plan table to update Status
* obtained from E096
* DEVELOPER: Aratrika Banerjee
* CREATION DATE:   2017-04-07
* OBJECT ID : C064
* TRANSPORT NUMBER(S):  ED2K905240
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909823
* REFERENCE NO: ERP-5614
* DEVELOPER: Writtick Roy (WROY)
* DATE: 2017-12-12
* DESCRIPTION: Add Material Number
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GLOBAL_CLEAR
*&---------------------------------------------------------------------*
*       Clearing all Global variables,tables and work areas
*----------------------------------------------------------------------*

FORM f_global_clear.

  CLEAR : i_upload_file,
          i_output_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       To get the file from Presentation server
*----------------------------------------------------------------------*

FORM f_f4_presentation  USING   fp_syst_cprog TYPE syst_cprog " ABAP System Field: Calling Program
                                fp_c_field TYPE dynfnam       " Field name
                       CHANGING fp_p_file TYPE localfile.     " Local file for upload/download

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
*       FM for search help in application server.
*----------------------------------------------------------------------*

FORM f_f4_application  CHANGING fp_p_file TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc NE 0.
    " No actions needed!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       Validation of Presentation Server file
*----------------------------------------------------------------------*

FORM f_validate_presentation  USING  fp_p_file  TYPE localfile. " Local file for upload/download

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
*       Validation of Application Server File Path
*----------------------------------------------------------------------*

FORM f_validate_application  USING fp_p_file TYPE localfile. " Local file for upload/download

  DATA:    lv_test TYPE orblk,            " Data block for original data
           lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
           lv_len  TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables

  CONSTANTS : lc_11 TYPE numc2 VALUE '11', " Two digit number
              lc_12 TYPE numc2 VALUE '12'. " Two digit number

  lv_file = fp_p_file.
  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
  IF sy-subrc EQ 0.
    CATCH SYSTEM-EXCEPTIONS dataset_read_error = lc_11
                          OTHERS = lc_12.
      READ DATASET lv_file INTO lv_test LENGTH lv_len. " lst_str.

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
*&      Form  F_READ_FILE_FRM_PRES_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server  USING    fp_p_file TYPE localfile " Local file for upload/download
                 CHANGING fp_i_upload_file TYPE tt_upload_file.

*Local type declaration
  TYPES: BEGIN OF lty_data_tab,
           value TYPE string,
         END OF lty_data_tab.

*   Local data declaration
  DATA:
    lst_upload_file TYPE ty_upload_file,
    li_data_tab     TYPE STANDARD TABLE OF lty_data_tab INITIAL SIZE 0,
    lv_file         TYPE string.

  lv_file = fp_p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_file
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
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc = 0.
    LOOP AT li_data_tab INTO DATA(lst_data_tab).

      IF sy-tabix > 1.

        SPLIT lst_data_tab-value AT c_tab INTO lst_upload_file-vbeln
                                         lst_upload_file-posnr
                                         lst_upload_file-activity.

        " Converting the Item Number to a 6-digit item number
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_upload_file-posnr
          IMPORTING
            output = lst_upload_file-posnr.

        APPEND lst_upload_file TO fp_i_upload_file.
        CLEAR:  lst_upload_file.

      ENDIF. " IF sy-tabix > 1

    ENDLOOP. " LOOP AT li_data_tab INTO DATA(lst_data_tab)
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM f_read_file_frm_app_server  USING fp_p_file TYPE localfile " Local file for upload/download
                                 CHANGING fp_i_upload_file  TYPE tt_upload_file.

*Local data declaration
  DATA:         lst_file        TYPE string,
                lst_upload_file TYPE ty_upload_file,
                lv_file         TYPE localfile. " Local file for upload/download

  CLEAR lv_file.
  lv_file = fp_p_file.

  TRY.
*  Open dataset
      OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
      IF sy-subrc EQ 0.
        DO.
          CLEAR lst_file.
*  Read Dataset
          READ DATASET lv_file INTO lst_file.
          IF sy-subrc NE 0.
            EXIT.
          ELSE. " ELSE -> IF sy-subrc NE 0
            IF sy-tabix > 1.
              CLEAR lst_upload_file.
              SPLIT lst_file AT c_tab INTO lst_upload_file-vbeln
                                   lst_upload_file-posnr
                                   lst_upload_file-activity.

              " Converting the Item Number to a 6-digit item number
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lst_upload_file-posnr
                IMPORTING
                  output = lst_upload_file-posnr.

              APPEND lst_upload_file TO fp_i_upload_file.
              CLEAR  lst_upload_file.
            ENDIF. " IF sy-tabix > 1
          ENDIF. " IF sy-subrc NE 0

        ENDDO.
        CLOSE DATASET lv_file.

      ENDIF. " IF sy-subrc EQ 0
    CATCH cx_sy_file_open.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_TABLE
*&---------------------------------------------------------------------*
*       Subrouine to update table
*----------------------------------------------------------------------*

FORM f_update_table  USING    fp_i_upload_file TYPE tt_upload_file.

  MOVE-CORRESPONDING fp_i_upload_file TO i_output_file.

  SORT i_output_file BY vbeln posnr activity.

  IF sy-subrc IS INITIAL.

    SELECT vbeln,            " Sales Document
      posnr,                 " Sales Document Item
      activity,              " Activity
*     Begin of ADD:ERP-5614:WROY:12-Dec-2017:ED2K909823
      matnr,                 " Material Number
*     End   of ADD:ERP-5614:WROY:12-Dec-2017:ED2K909823
      eadat,                 " Activity Date
      renwl_prof,            " Renewal Profile
      promo_code,            " Promo code
      act_status,            " Activity Status
      ren_status             " Renewal Status
        FROM zqtc_renwl_plan " E095: Renewal Plan Table
        INTO TABLE @DATA(li_renwl_plan)
        FOR ALL ENTRIES IN @i_output_file
        WHERE vbeln = @i_output_file-vbeln
        AND posnr = @i_output_file-posnr
        AND activity = @i_output_file-activity.

    IF sy-subrc IS INITIAL.
      SORT li_renwl_plan BY vbeln posnr activity.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL

  LOOP AT i_output_file ASSIGNING FIELD-SYMBOL(<lst_output_file>).

    "Client
    <lst_output_file>-mandt = sy-mandt.
    READ TABLE li_renwl_plan INTO DATA(lst_renwl_plan) WITH KEY vbeln = <lst_output_file>-vbeln
                                                                posnr = <lst_output_file>-posnr
                                                                activity = <lst_output_file>-activity
                                                                BINARY SEARCH.

    IF sy-subrc IS INITIAL.
*     Begin of ADD:ERP-5614:WROY:12-Dec-2017:ED2K909823
      " Material Number
      <lst_output_file>-matnr = lst_renwl_plan-matnr.
*     End   of ADD:ERP-5614:WROY:12-Dec-2017:ED2K909823
      " Activity Date
      <lst_output_file>-eadat = lst_renwl_plan-eadat.
      " Renewal Profile
      <lst_output_file>-renwl_prof = lst_renwl_plan-renwl_prof.
      " Promo code
      <lst_output_file>-promo_code = lst_renwl_plan-promo_code.
      " Renewal Status
      <lst_output_file>-ren_status = lst_renwl_plan-ren_status.
    ENDIF. " IF sy-subrc IS INITIAL

    "Activity Status
    <lst_output_file>-act_status = abap_true.
    "Name of Person Who Changed Object
    <lst_output_file>-aenam = sy-uname.
    "Changed On
    <lst_output_file>-aedat = sy-datum.
    "Time last change was made
    <lst_output_file>-aezet = sy-uzeit.

  ENDLOOP. " LOOP AT i_output_file ASSIGNING FIELD-SYMBOL(<lst_output_file>)

  IF NOT i_output_file IS INITIAL.

    " Locking the Database table
    CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
      EXPORTING
        mode_zqtc_renwl_plan = abap_true
        mandt                = sy-mandt
      EXCEPTIONS
        foreign_lock         = 1
        system_failure       = 2
        OTHERS               = 3.
    IF sy-subrc <> 0.
* No Need to throw error message
    ELSE. " ELSE -> IF sy-subrc <> 0

      " Updating the database table from the internal table created.
      UPDATE zqtc_renwl_plan FROM TABLE i_output_file .

      MESSAGE s036(zqtc_r2) WITH sy-dbcnt. " & records updated successfully to the database table

      IF sy-dbcnt NE 0.

        COMMIT WORK AND WAIT.

      ELSE. " ELSE -> IF sy-dbcnt NE 0

        ROLLBACK WORK.

      ENDIF. " IF sy-dbcnt NE 0

*     Unlocking the Database table
      CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
        EXPORTING
          mode_zqtc_renwl_plan = abap_true
          mandt                = sy-mandt.

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF NOT i_output_file IS INITIAL

ENDFORM.
