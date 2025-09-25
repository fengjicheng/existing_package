*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_UPDATE_FROM_FILE_F01
*&---------------------------------------------------------------------*
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_BP_UPDATE_FROM_FILE                      *
*& PROGRAM DESCRIPTION:   BP Partner Tax numbers update after fetching   *
*&                        tax numbers from Application server path       *
*& CHANGE DESCRIPTION  : Replacing tab delimiter with comma(,) and date  *
*&                       format in MM/DD/YYYY                            *
*& DEVELOPER:             MRAJKUMAR                                      *
*& CREATION DATE:         27/09/2021                                     *
*& OBJECT ID:                                                            *
*& TRANSPORT NUMBER(S):    ED2K924622                                    *
*&-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_READ_APPLSERVPATH_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_READ_APPLSERVPATH_DETAILS.
  CONSTANTS:lc_cust TYPE c VALUE 'C'.
*  OPEN DATASET v_filename FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  OPEN DATASET v_filename FOR INPUT IN TEXT MODE ENCODING DEFAULT IGNORING CONVERSION ERRORS.
    IF sy-subrc = 0.
      DO.
        READ DATASET v_filename INTO lv_data.
        IF sy-subrc IS INITIAL.
*          SPLIT lv_data AT '|'  INTO :
          REPLACE ALL OCCURRENCES OF c_crlf IN lv_data WITH space. "Added by GKAMMILI on 29/09/2021 ED2K924634
          SPLIT lv_data AT c_comma  INTO :
                        wa_data-kunnr
                        wa_data-certdate
                        wa_data-cerreason
                        wa_data-expirdate
                        wa_data-taxid
                        wa_data-name1
                        wa_data-state.
          APPEND wa_data TO i_taxdata.
          CLEAR wa_data.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
      MESSAGE e256(zqtc_r2) WITH p_file.
    ENDIF.
  CLOSE DATASET v_filename.
*--BOC by GKAMMILI on 29/09/2021 ED2K924634
  IF i_taxdata[] IS NOT INITIAL.
    DELETE i_taxdata INDEX 1.
  ENDIF.
*--EOC by GKAMMILI on 29/09/2021 ED2K924634
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_TAX_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_BP_TAX_UPDATE .
"From Application server path, after getting whole data, checking for only
"Business partner by checking length of customer numbers.
  LOOP AT i_taxdata
    INTO DATA(wa_taxdata).
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT         = wa_taxdata-kunnr
     IMPORTING
       OUTPUT        = wa_taxdata-kunnr.
    IF sy-subrc IS INITIAL.
"* Do Nothing
    ENDIF.
*    DESCRIBE FIELD wa_taxdata-kunnr LENGTH DATA(lv_length) IN CHARACTER MODE.
    DATA(lv_length) = strlen( wa_taxdata-kunnr ).
    IF lv_length EQ c_ten.
      wa_process-kunnr     = wa_taxdata-kunnr.
      wa_process-certdate  = wa_taxdata-certdate.
      wa_process-cerreason = wa_taxdata-cerreason.
      wa_process-expirdate = wa_taxdata-expirdate.
      wa_process-taxid     = wa_taxdata-taxid.
      wa_process-name1     = wa_taxdata-name1.
      wa_process-state     = wa_taxdata-state.
*      APPEND wa_taxdata TO i_taxprocess.
*      CLEAR wa_taxdata.
      APPEND wa_process TO i_taxprocess.
      CLEAR: wa_taxdata, wa_process.
    ENDIF.
    CLEAR lv_length.
  ENDLOOP.
"Validating Business Partners from BUT000 table.
  IF i_taxprocess IS NOT INITIAL.
    SELECT partner,  "#EC CI_NO_TRANSFORM
           name_first,
           name_last,
           xdele    "MRAJKUMAR 30/09/2021 ED2K924657
      INTO TABLE @DATA(lt_partners)   "#EC CI_NO_TRANSFORM
      FROM BUT000
       FOR ALL ENTRIES IN @i_taxprocess
     WHERE partner EQ @i_taxprocess-kunnr.
    IF  sy-subrc     IS INITIAL
    AND i_taxprocess IS NOT INITIAL.
"Selecting Tax classification details for Business PArtner from KNVI table
      SELECT kunnr,  " #EC CI_NO_TRANSFORM
             aland,
             tatyp,
             taxkd
        FROM knvi
        INTO TABLE @DATA(lt_knvi)
         FOR ALL ENTRIES IN @lt_partners  "#EC CI_NO_TRANSFORM
       WHERE kunnr EQ @lt_partners-partner.
      IF sy-subrc IS INITIAL.
        SORT lt_knvi
          BY kunnr.
      ENDIF.
    ENDIF.
  ENDIF.
"*SELECT * is needed to provide all values to FM for update.
  IF lt_partners IS NOT INITIAL.
    SELECT  *  "#EC CI_SUBRC "#EC CI_NO_TRANSFORM
      FROM kna1
      INTO TABLE @DATA(lt_kna1)
       FOR ALL ENTRIES IN @lt_partners "#EC CI_NO_TRANSFORM
      WHERE kunnr EQ @lt_partners-partner.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDIF.
"From valid Business partners,finding the Tax classification details
  CLEAR wa_taxdata.
  FREE i_updatestatus.
"Processing all the partners from file
  LOOP AT i_taxdata
    INTO wa_taxdata.
"Reading only BP Partners which found from BUT000 table.
    READ TABLE lt_partners
      INTO DATA(lv_partners)
      WITH KEY partner = wa_taxdata-kunnr
               xdele   = space."MRAJKUMAR 30/09/2021 ED2K924657
    IF  sy-subrc      IS INITIAL
    AND lv_partners   IS NOT INITIAL.
"Reading BP Partners Certification date and expire date.
      READ TABLE i_taxprocess
        INTO DATA(lv_taxprocess)
        WITH KEY kunnr = lv_partners-partner.
      IF  sy-subrc      IS INITIAL
      AND lv_taxprocess IS NOT INITIAL.
"If the upload date is between Certificate Date and Certificate Expire Date then
" Update Tax classification value as 0.
        DATA(lv_certfdate)  = lv_taxprocess-certdate.
        DATA(lv_expiredate) = lv_taxprocess-expirdate.
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
*        REPLACE ALL OCCURRENCES OF '-' IN lv_certfdate WITH space.
        DATA: lv_date  TYPE char2,
              lv_month TYPE char2,
              lv_year  TYPE char4.
*BEGIN OF CHANGE MRAJKUMAR  ED2K924927 28/10/2021
* Changed date format from MM/DD/YYYY to YYYY-MM-DD
*        SPLIT lv_certfdate AT '/' INTO:
*                                   lv_month
*                                   lv_date
*                                   lv_year.
        SPLIT lv_certfdate AT '-' INTO:
                                   lv_year
                                   lv_month
                                   lv_date.
*END OF CHANGE MRAJKUMAR ED2K924927 28/10/2021
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT        = lv_date
         IMPORTING
           OUTPUT        = lv_date.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT        = lv_month
         IMPORTING
           OUTPUT        = lv_month.
        CLEAR lv_certfdate.
        CONCATENATE lv_year
                    lv_month
                    lv_date
                INTO lv_certfdate.
        CLEAR: lv_year,
               lv_month,
               lv_date.
        CONDENSE lv_certfdate.
*        REPLACE ALL OCCURRENCES OF '-' IN lv_expiredate WITH space.
*BEGIN OF CHANGE MRAJKUMAR  ED2K924927 28/10/2021
* Changed date format from MM/DD/YYYY to YYYY-MM-DD
*        SPLIT lv_expiredate AT '/' INTO:
*                                   lv_month
*                                   lv_date
*                                   lv_year.
        SPLIT lv_expiredate AT '-' INTO:
                                   lv_year
                                   lv_month
                                   lv_date.
*BEGIN OF CHANGE MRAJKUMAR  ED2K924927 28/10/2021
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT        = lv_date
         IMPORTING
           OUTPUT        = lv_date.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT        = lv_month
         IMPORTING
           OUTPUT        = lv_month.
        CLEAR:  lv_expiredate.
        CONCATENATE lv_year
                    lv_month
                    lv_date
                INTO lv_expiredate.
        CLEAR: lv_year,
               lv_month,
               lv_date.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
        CONDENSE lv_expiredate.
        FREE i_updateknvi.
        IF sy-datum BETWEEN lv_certfdate AND lv_expiredate.
          LOOP AT lt_knvi "#EC CI_NESTED
            INTO DATA(lv_knvi)
            WHERE kunnr EQ lv_taxprocess-kunnr.
            wa_updateknvi-kunnr = lv_knvi-kunnr.
            wa_updateknvi-aland  = lv_knvi-aland.
            wa_updateknvi-tatyp  = lv_knvi-tatyp.
            wa_updateknvi-taxkd  = '0'.
            APPEND wa_updateknvi TO i_updateknvi.
            CLEAR wa_updateknvi.
          ENDLOOP.
        ELSEIF NOT sy-datum BETWEEN lv_certfdate AND lv_expiredate.
  "If the upload date is not between Certificate Date and Certificate Expire Date then
  " Update Tax classification value as 0.
          LOOP AT lt_knvi "#EC CI_NESTED
            INTO lv_knvi
            WHERE kunnr EQ lv_taxprocess-kunnr.
            wa_updateknvi-kunnr = lv_knvi-kunnr.
            wa_updateknvi-aland  = lv_knvi-aland.
            wa_updateknvi-tatyp  = lv_knvi-tatyp.
            wa_updateknvi-taxkd  = '1'.
            APPEND wa_updateknvi TO i_updateknvi.
            CLEAR wa_updateknvi.
          ENDLOOP.
        ENDIF.
  "Read KNA1 data to provide data to FM.
        READ TABLE lt_kna1
          INTO DATA(lv_kna1)
          WITH KEY kunnr = lv_taxprocess-kunnr.
        IF  sy-subrc IS INITIAL
        AND lv_kna1  IS NOT INITIAL.
          APPEND LINES OF i_updateknvi TO i_updateknvi_temp.
          CALL FUNCTION 'SD_CUSTOMER_MAINTAIN_ALL'
           EXPORTING
             I_KNA1                              = lv_kna1
           TABLES
             T_XKNVI                              = i_updateknvi
           EXCEPTIONS
             CLIENT_ERROR                        = 1
             KNA1_INCOMPLETE                     = 2
             KNB1_INCOMPLETE                     = 3
             KNB5_INCOMPLETE                     = 4
             KNVV_INCOMPLETE                     = 5
             KUNNR_NOT_UNIQUE                    = 6
             SALES_AREA_NOT_UNIQUE               = 7
             SALES_AREA_NOT_VALID                = 8
             INSERT_UPDATE_CONFLICT              = 9
             NUMBER_ASSIGNMENT_ERROR             = 10
             NUMBER_NOT_IN_RANGE                 = 11
             NUMBER_RANGE_NOT_EXTERN             = 12
             NUMBER_RANGE_NOT_INTERN             = 13
             ACCOUNT_GROUP_NOT_VALID             = 14
             PARNR_INVALID                       = 15
             BANK_ADDRESS_INVALID                = 16
             TAX_DATA_NOT_VALID                  = 17
             NO_AUTHORITY                        = 18
             COMPANY_CODE_NOT_UNIQUE             = 19
             DUNNING_DATA_NOT_VALID              = 20
             KNB1_REFERENCE_INVALID              = 21
             CAM_ERROR                           = 22
             OTHERS                              = 23
                    .
          IF SY-SUBRC <> 0.
*       Implement suitable error handling here
          ELSEIF sy-subrc IS INITIAL.
            APPEND LINES OF i_updateknvi_temp TO i_updateknvi.
            FREE i_updateknvi_temp.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
             EXPORTING
               WAIT          = c_x.
  "Status Update for each entry into table i_updatestatus.
            wa_updatestatus-kunnr       = lv_taxprocess-kunnr.
            wa_updatestatus-certdate    = lv_taxprocess-certdate.
            wa_updatestatus-cerreason   = lv_taxprocess-cerreason.
            wa_updatestatus-expirdate   = lv_taxprocess-expirdate.
            wa_updatestatus-taxid       = lv_taxprocess-taxid.
            wa_updatestatus-name1       = lv_taxprocess-name1.
            wa_updatestatus-state       = lv_taxprocess-state.
            wa_updatestatus-status      = text-032.
            READ TABLE lt_knvi
              INTO DATA(lwa_updateknvi)
              WITH KEY kunnr = lv_taxprocess-kunnr.
            IF  sy-subrc       IS INITIAL
            AND lwa_updateknvi IS NOT INITIAL.
              CLEAR lwa_updateknvi.
              LOOP AT lt_knvi  "#EC CI_NESTED
                INTO lwa_updateknvi
                WHERE kunnr = lv_taxprocess-kunnr.
                READ TABLE i_updateknvi
                  INTO DATA(lwa_checkknvi)
                  WITH KEY kunnr = lwa_updateknvi-kunnr
                           aland = lwa_updateknvi-aland
                           tatyp = lwa_updateknvi-tatyp
                           taxkd = lwa_updateknvi-taxkd.
                IF  sy-subrc IS INITIAL
                AND lwa_checkknvi IS NOT INITIAL.
                  CONCATENATE lwa_updateknvi-kunnr
                              lwa_updateknvi-aland
                              lwa_updateknvi-tatyp
                              lwa_updateknvi-taxkd
                              text-024
                       INTO DATA(lv_taxdetails) SEPARATED BY '-'.
                  CONCATENATE lv_updatestatus
                              lv_taxdetails
                              text-026
                       INTO DATA(lv_updatestatus).
                ELSEIF sy-subrc IS NOT INITIAL
                AND    lwa_checkknvi IS INITIAL.
                  CONCATENATE lwa_updateknvi-kunnr
                              lwa_updateknvi-aland
                              lwa_updateknvi-tatyp
                              lwa_updateknvi-taxkd
                              text-025
                       INTO lv_taxdetails SEPARATED BY '-'.
                  CONCATENATE lv_updatestatus
                              lv_taxdetails
                              text-026
                       INTO lv_updatestatus.
                ENDIF.
              ENDLOOP.
              wa_updatestatus-details = lv_updatestatus.
            ELSEIF sy-subrc       IS NOT INITIAL
            AND    lwa_updateknvi IS INITIAL.
              wa_updatestatus-status  = text-027.
              wa_updatestatus-details = text-028.
            ENDIF.
            APPEND wa_updatestatus TO i_updatestatus.
            CLEAR: wa_updatestatus,lwa_updateknvi,lv_taxdetails,lv_updatestatus.
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR lv_taxprocess.
    ELSEIF sy-subrc      IS NOT INITIAL.
*    AND    lv_partners   IS INITIAL."MRAJKUMAR 30/09/2021 ED2K924657
"Status Update for each entry into table i_updatestatus.
      wa_updatestatus-kunnr       = wa_taxdata-kunnr.
      wa_updatestatus-certdate    = wa_taxdata-certdate.
      wa_updatestatus-cerreason   = wa_taxdata-cerreason.
      wa_updatestatus-expirdate   = wa_taxdata-expirdate.
      wa_updatestatus-taxid       = wa_taxdata-taxid.
      wa_updatestatus-name1       = wa_taxdata-name1.
      wa_updatestatus-state       = wa_taxdata-state.
      wa_updatestatus-status      = text-027.
" BEGIN OF CHANGE MRAJKUMAR 30/09/2021 ED2K924657
      CLEAR lv_partners.
      READ TABLE lt_partners
        INTO lv_partners
        WITH KEY partner = wa_taxdata-kunnr
                 xdele   = 'X'.
      IF  sy-subrc IS INITIAL
      AND lv_partners-xdele IS NOT INITIAL.
        wa_updatestatus-details     = text-033.
      ELSEIF sy-subrc IS NOT INITIAL
      AND lv_partners IS INITIAL.
        wa_updatestatus-details     = text-029.
      ENDIF.
" END OF CHANGE MRAJKUMAR 30/09/2021 ED2K924657
      APPEND wa_updatestatus TO i_updatestatus.
      CLEAR wa_updatestatus.
    ENDIF.
    CLEAR lv_partners.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_BP_TAX__NUMBERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_DISPLAY_BP_TAX__NUMBERS .
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gv_alv
        CHANGING
          t_table      = i_finaldisplay.

    CATCH cx_salv_msg .
  ENDTRY.
  "To hide the column while in display
  gv_func = gv_alv->get_functions( ).

  DATA(ls_cols) = gv_alv->get_columns( ).

  ls_cols->set_optimize( 'X' ).

  TRY.
      DATA(ls_col1) = ls_cols->get_column( 'KUNNR' ).
      DATA(ls_col2) = ls_cols->get_column( 'CERTDATE' ).
      DATA(ls_col3) = ls_cols->get_column( 'CERREASON' ).
      DATA(ls_col4) = ls_cols->get_column( 'EXPIRDATE' ).
      DATA(ls_col5) = ls_cols->get_column( 'TAXID' ).
      DATA(ls_col6) = ls_cols->get_column( 'NAME1' ).
      DATA(ls_col7) = ls_cols->get_column( 'STATE' ).
      DATA(ls_col8) = ls_cols->get_column( 'STATUS' ).
      DATA(ls_col9) = ls_cols->get_column( 'DETAILS' ).
    CATCH cx_salv_not_found.
  ENDTRY.
**************************************************
  ls_col1->set_long_text('CUSTOMER NUMBER').
  ls_col1->set_medium_text('CUSTOMER NUMBER').
  ls_col1->set_short_text('CUST NUM').
*************************************************
*************************************************
  ls_col2->set_long_text('CERTIFICATE EFFCTIVE DATE').
  ls_col2->set_medium_text('CERTI EFE DATE').
  ls_col2->set_short_text('EFE DATE').
*************************************************
*************************************************
  ls_col3->set_long_text('CERTIFICATE EXEMPT REASON').
  ls_col3->set_medium_text('CERTI EXEMPT REASON').
  ls_col3->set_short_text('REASON').
*************************************************
*************************************************
  ls_col4->set_long_text('CERTIFICATE EXPIRATION DATE').
  ls_col4->set_medium_text('CERTI EXP DATE').
  ls_col4->set_short_text('EXP DATE').
*************************************************
*************************************************
  ls_col5->set_long_text('CERTIFICATE: Certificate/ Tax ID Number').
  ls_col5->set_medium_text('Tax ID Number').
  ls_col5->set_short_text('TAX ID').
*************************************************
*************************************************
  ls_col6->set_long_text('CUSTOMER NAME').
  ls_col6->set_medium_text('CUSTOMER NAME').
  ls_col6->set_short_text('CUSTNAME').
***********************************************
*************************************************
  ls_col7->set_long_text('Certificate Issuer State').
  ls_col7->set_medium_text('Issuer State').
  ls_col7->set_short_text('State').
*************************************************
*************************************************
  ls_col8->set_long_text('Tax Update Status').
  ls_col8->set_medium_text('Tax Update Status').
  ls_col8->set_short_text('Status').
*************************************************
*************************************************
  ls_col9->set_long_text('Tax Update Details').
  ls_col9->set_medium_text('Tax Update Details').
  ls_col9->set_short_text('Details').
*************************************************
*************************************************
"To display the toolbar
  CALL METHOD gv_func->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  gv_alv->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TRANSFER_FILES_APPL_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_TRANSFER_FILES_APPL_PATH .
  IF i_updatestatus IS NOT INITIAL.
    CLEAR gv_filename.
    CONCATENATE text-019
                sy-datum
                sy-uzeit
                text-020
           INTO gv_filename.
    CONDENSE gv_filename NO-GAPS.
    CLEAR :gv_filepath.
*  --*Read file path from transaction FILE
    CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
      EXPORTING
        client                     = sy-mandt
        logical_path               = v_path_prc
        operating_system           = sy-opsys
        file_name                  = gv_filename
        eleminate_blanks           = c_x
      IMPORTING
        file_name_with_path        = gv_filepath
      EXCEPTIONS
        path_not_found             = 1
        missing_parameter          = 2
        operating_system_not_found = 3
        file_system_not_found      = 4
        OTHERS                     = 5.
    IF sy-subrc <> 0.
      MESSAGE s001 DISPLAY LIKE c_e.
      LEAVE LIST-PROCESSING.
    ENDIF.
    OPEN DATASET gv_filepath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc IS INITIAL.
        CONCATENATE
                    text-006
                    text-008
                    text-009
                    text-010
                    text-011
                    text-007
                    text-012
                    text-013
                    text-014
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
*           INTO DATA(lv_taxdata) SEPARATED BY c_pipe.
           INTO DATA(lv_taxdata) SEPARATED BY c_comma.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           TRANSFER lv_taxdata TO gv_filepath.
        LOOP AT i_updatestatus
          INTO wa_updatestatus.
          CONCATENATE wa_updatestatus-kunnr
                      wa_updatestatus-certdate
                      wa_updatestatus-cerreason
                      wa_updatestatus-expirdate
                      wa_updatestatus-taxid
                      wa_updatestatus-name1
                      wa_updatestatus-state
                      wa_updatestatus-status
                      wa_updatestatus-details
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
*                INTO lv_taxdata SEPARATED BY c_pipe.
                INTO lv_taxdata SEPARATED BY c_comma.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
             TRANSFER lv_taxdata TO gv_filepath.
        ENDLOOP.
      ENDIF.
    CLOSE DATASET gv_filepath.
  ENDIF.
  FREE:ls_file_name , ls_dir_name,ls_file_path,ev_long_file_path.
  ls_dir_name  = v_dir.
  ls_file_name = v_deletefile.
  CALL FUNCTION 'EPS_DELETE_FILE'
    EXPORTING
      file_name              = ls_file_name
      dir_name               = ls_dir_name
    IMPORTING
      file_path              = ls_file_path
      ev_long_file_path      = ev_long_file_path
    EXCEPTIONS
      invalid_eps_subdir     = 1
      sapgparam_failed       = 2
      build_directory_failed = 3
      no_authorization       = 4
      build_path_failed      = 5
      delete_failed          = 6
      OTHERS                 = 7.
  IF sy-subrc <> 0.
    MESSAGE text-043 TYPE c_e.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE1  text
*----------------------------------------------------------------------*
FORM F_F4_FILE_NAME  CHANGING fP_P_FILE1 TYPE rlgrap-filename..

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file1 " File Path
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
*&      Form  F_READ_FROM_EXCEL_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_READ_FROM_EXCEL_FILE .
" Converting Excel data to Internal table
  v_file = p_file1.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = v_file
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 500
      i_end_row               = 99999
    TABLES
      intern                  = i_exceldata
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

   IF  sy-subrc     IS INITIAL
   AND i_exceldata IS NOT INITIAL.
"Tranferring data to internal table as per file columns
     FREE i_data.
     CLEAR wa_Data.
     LOOP AT i_exceldata
       INTO DATA(wa_exceldata).
       CASE wa_exceldata-col. " column number
         WHEN c_col_1. "Customer Number
           wa_data-kunnr = wa_exceldata-value.
         WHEN c_col_2.  "Certififcate effective date
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           IF wa_exceldata-value CA '/'.
             SPLIT wa_exceldata-value AT '/'
                                INTO DATA(lv_excelmonth)
                                     DATA(lv_exceldate)
                                     DATA(lv_excelyear).
             CLEAR wa_exceldata-value.
             CONCATENATE lv_excelyear
                           '-'
                         lv_excelmonth
                           '-'
                         lv_exceldate
                   INTO  wa_exceldata-value.
               CLEAR: lv_excelmonth,
                      lv_exceldate,
                      lv_excelyear.
           ENDIF.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           wa_data-certdate = wa_exceldata-value.
         WHEN c_col_3. " Certificate Exemption reason
           wa_data-cerreason  = wa_exceldata-value.
         WHEN c_col_4. " Certificate Expiration date
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           IF wa_exceldata-value CA '/'.
             CLEAR: lv_excelmonth,
                    lv_exceldate,
                    lv_excelyear.

             SPLIT wa_exceldata-value AT '/'
                                INTO lv_excelmonth
                                     lv_exceldate
                                     lv_excelyear.
             CLEAR wa_exceldata-value.
             CONCATENATE lv_excelyear
                           '-'
                         lv_excelmonth
                           '-'
                         lv_exceldate
                   INTO  wa_exceldata-value.
              CLEAR: lv_excelmonth,
                     lv_exceldate,
                     lv_excelyear.
           ENDIF.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           wa_data-expirdate  = wa_exceldata-value.
         WHEN c_col_5. " Tax ID number
           wa_data-taxid  = wa_exceldata-value.
         WHEN c_col_6. " Customer Name
           wa_data-name1 = wa_exceldata-value.
         WHEN c_col_7. " Certificate issue state
           wa_data-state  = wa_exceldata-value.
         WHEN OTHERS.
*          no actio required.
        ENDCASE.
        AT END OF row.
**Append the entries into Table for further validation & data processing
          APPEND wa_data TO i_data.
          CLEAR wa_data.
        ENDAT.
     ENDLOOP.
   ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_WRITE_DATA_APPL_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_WRITE_DATA_APPL_SERVER  USING fp_path_fname.
  CLEAR gv_filename.
  CONCATENATE text-019
              c_score
              sy-datum
              c_score
              sy-uzeit
              text-020
         INTO gv_filename.
  CONDENSE gv_filename NO-GAPS.
  CLEAR :gv_filepath.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = v_path_in
      operating_system           = sy-opsys
      file_name                  = gv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = gv_filepath
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.
  OPEN DATASET gv_filepath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc IS INITIAL.
*--BOC by GKAMMILI on 29/09/2021 ED2K924634
      CONCATENATE   text-006
                    text-008
                    text-009
                    text-010
                    text-011
                    text-007
                    text-012
                    text-013
                    text-014
           INTO DATA(lv_taxdata1) SEPARATED BY c_comma.
           TRANSFER lv_taxdata1 TO gv_filepath.
*--EOC by GKAMMILI on 29/09/2021 ED2K924634
      LOOP AT i_data
        INTO wa_Data.
        IF sy-tabix GT 1.
          CONCATENATE wa_data-kunnr
                      wa_data-certdate
                      wa_data-cerreason
                      wa_data-expirdate
                      wa_data-taxid
                      wa_data-name1
                      wa_data-state
* BEGIN OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
*                INTO DATA(lv_taxdata) SEPARATED BY c_pipe.
                INTO DATA(lv_taxdata) SEPARATED BY c_comma.
* END OF CHANGE MRAJKUMAR  ED2K924622 28/09/2021
           TRANSFER lv_taxdata TO gv_filepath.
        ENDIF.
      ENDLOOP.
    ENDIF.
  CLOSE DATASET gv_filepath.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CONTENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_CREATE_CONTENT .
* --------------------------------------------------------------
* convert the text string into UTF-16LE binary data including
* byte-order-mark. Mircosoft Excel prefers these settings
* all this is done by new class cl_bcs_convert (see note 1151257)
  CLEAR gv_String.
  CONCATENATE gv_string
              text-006 c_tab
              text-008 c_tab
              text-009 c_tab
              text-010 c_tab
              text-011 c_tab
              text-007 c_tab
              text-012 c_tab
              text-013 c_tab
              text-014 c_crlf
         INTO gv_string.
  LOOP AT i_updatestatus
    INTO DATA(lwa_updatestatus).
    CONCATENATE gv_string
                lwa_updatestatus-kunnr       c_tab
                lwa_updatestatus-certdate    c_tab
                lwa_updatestatus-cerreason   c_tab
                lwa_updatestatus-expirdate   c_tab
                lwa_updatestatus-taxid       c_tab
                lwa_updatestatus-name1       c_tab
                lwa_updatestatus-state       c_tab
                lwa_updatestatus-status      c_tab
                lwa_updatestatus-details     c_crlf
          INTO  gv_string.

  ENDLOOP.
  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string   = gv_string
          iv_codepage = '4103'  "suitable for MS Excel, leave empty
          iv_add_bom  = 'X'     "for other doc types
        IMPORTING
          et_solix  = binary_content
          ev_size   = size ).
    CATCH cx_bcs.
      MESSAGE e445(so).
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SEND_EMAIL .
*     -------- create persistent send request ------------------------
  TRY.
      v_send_request = cl_bcs=>create_persistent( ).
      CATCH CX_SEND_REQ_BCS.
  ENDTRY.
  DATA: lst_text          TYPE so_text255,
        li_text           TYPE bcsy_text,
        lv_subject        TYPE sood-objdes.
      CLEAR:lst_text.
      lst_text   = 'Hi Tax Team,'(078).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

      lst_text = '<br><br>'(116).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

      lst_text = '<body>'(141).
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
                   text-021
                    '</p>'
                   INTO lst_text SEPARATED BY space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
                          text-022
                          '</p>'
                         INTO lst_text SEPARATED BY space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      lst_text = space.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      lst_text = '<br><br>'(116).
      APPEND lst_text TO li_text.
      CLEAR:lst_text.

*---Body of the EMAIL
      CONCATENATE '<font color = "BLACK" style="font-family:arial;font-size:95%;">'(146) 'Thanks,'(080) '<br/>'(147)
      INTO lst_text.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      CONCATENATE  '<font color = "BLACK" style="font-family:arial;font-size:95%;">'(146) text-023 '<br/>'(147)
      INTO lst_text.
      APPEND lst_text TO li_text.
      CLEAR lst_text.

      lst_text = '</body>'(148).
      APPEND lst_text TO li_text.
      CLEAR lst_text.
      CLEAR lv_subject.
*Email Subject.
      IF sy-sysid EQ 'EP1'.
        CONCATENATE text-015
                    c_score
                    sy-datum
               INTO lv_subject.

      ELSE.
        CONCATENATE sy-sysid
                    c_score
                    text-015
                    c_score
                    sy-datum
               INTO lv_subject.
      ENDIF.
*     -------- create and set document with attachment ---------------
*     create document object from internal table with text
      TRY.
        document = cl_document_bcs=>create_document(  "#EC NOTEXT
          i_type    = 'HTM'                     "#EC NOTEXT
          i_text    = li_text
          i_subject = lv_subject ).
        CATCH cx_document_bcs.
      ENDTRY.
*     add the spread sheet as attachment to document object
      TRY.
          document->add_attachment(                 "#EC NOTEXT
        i_attachment_type    = 'xls'               "#EC NOTEXT
        i_attachment_subject = lv_subject         "#EC NOTEXT
        i_attachment_size    = size
        i_att_content_hex    = binary_content ).
        CATCH cx_document_bcs.
      ENDTRY.
*     add document object to send request
      TRY.
        v_send_request->set_document( document ).
        CATCH CX_SEND_REQ_BCS.
      ENDTRY.
**Set recipient
      DESCRIBE TABLE s_email LINES DATA(lv_times).
      DO lv_times TIMES.
        READ TABLE s_email INDEX sy-index.
        IF sy-subrc = 0.
          TRY.
              v_recipient = cl_cam_address_bcs=>create_internet_address( s_email-low ). "Here Recipient is email input s_email
*    *Catch exception here
            CATCH cx_address_bcs INTO cx_bcs_exception.
              v_msg_text = cx_bcs_exception->get_text( ).
              MESSAGE v_msg_text TYPE c_i.
          ENDTRY.

          TRY.
              v_send_request->add_recipient(
              EXPORTING
              i_recipient = v_recipient
              i_express = c_x ).
*    *Catch exception here
            CATCH cx_send_req_bcs INTO cx_bcs_exception.
              v_msg_text = cx_bcs_exception->get_text( ).
              MESSAGE v_msg_text TYPE c_i.
          ENDTRY.
        ENDIF."if sy-subrc = 0.
      ENDDO.

      TRY.
          CALL METHOD v_send_request->set_send_immediately
            EXPORTING
              i_send_immediately = abap_false. "here selection screen input p_send
*    *Catch exception here
        CATCH cx_send_req_bcs INTO cx_bcs_exception.
          v_msg_text = cx_bcs_exception->get_text( ).
          MESSAGE v_msg_text TYPE c_i.
      ENDTRY.

      TRY.
*    * Send email
          v_send_request->send(
          EXPORTING
          i_with_error_screen = c_x ).
          COMMIT WORK.
          IF sy-subrc = 0. "mail sent successfully
            WRITE :/ text-016.
            LOOP AT s_email.
              WRITE:/ text-017,
                       s_email-low+0(50).
            ENDLOOP.
          ENDIF.
*    *catch exception here
        CATCH cx_send_req_bcs INTO cx_bcs_exception.
          v_msg_text = cx_bcs_exception->get_text( ).
          MESSAGE v_msg_text TYPE c_i.
      ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_BACKGROUND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SUBMIT_BACKGROUND .
  IF s_email IS NOT INITIAL.
   LOOP AT s_email.
      gst_params-selname = c_sfile.  "Seletion screen field name of the corresponding program.
      gst_params-kind    = c_s.       "P-Parameter,S-Select-options
      gst_params-sign    = c_i.       "I-in
      gst_params-option  = c_eq.    "EQ,BT,CP
      gst_params-low     =  s_email-low.        "Selection Option Low,Parameter value
      APPEND gst_params TO gi_params.
      CLEAR gst_params.
    ENDLOOP.
  ENDIF.
  CLEAR gst_params.
  CONCATENATE text-018 sy-datum sy-uzeit INTO gv_jobname.
  CONDENSE gv_jobname NO-GAPS.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = gv_jobname
    IMPORTING
      jobcount         = gv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc IS INITIAL.
    SUBMIT ZQTCR_BP_TAXCLASIF_UPDATE_E230 WITH SELECTION-TABLE gi_params
                                      USER  gv_user  "'QTC_BATCH01'
                                      VIA JOB gv_jobname NUMBER gv_number
                                      AND RETURN.
    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobcount             = gv_number   "Job number
          jobname              = gv_jobname  "Job name
          strtimmed            = abap_true   "Start immediately
          sdlstrtdt            = sy-datum
          sdlstrttm            = sy-uzeit
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
    ENDIF.
    MESSAGE i261(zqtc_r2) WITH gv_jobname.
    LEAVE TO SCREEN 0.
  ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PATH_IN  text
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM F_GET_FILE_PATH  USING    fp_v_path
                               fp_v_filename.
  CLEAR :v_file_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = fp_v_path
      operating_system           = sy-opsys
      file_name                  = fp_v_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = v_file_path
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
