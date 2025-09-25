*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PRINT_VEND_DETERMINE (Function Module)
* PROGRAM DESCRIPTION: Download PDFs for Quick Issue
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   01/15/2018
* OBJECT ID: I0231
* TRANSPORT NUMBER(S): ED2K910309
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_quick_issue_download.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_OUTPUTS) TYPE  ZTQTC_OUTPUT_SUPP_RETRIEVAL
*"     REFERENCE(IM_BUS_PRCOCESS) TYPE  ZBUS_PRCOCESS
*"     REFERENCE(IM_PRINT_REGION) TYPE  ZPRINT_REGION
*"     REFERENCE(IM_COUNTRY_SORT) TYPE  ZCOUNTRY_SORT
*"     REFERENCE(IM_FILE_LOC) TYPE  FILE_NO
*"     REFERENCE(IM_COUNTRY) TYPE  LAND1
*"     REFERENCE(IM_CUSTOMER) TYPE  KUNNR
*"     REFERENCE(IM_DOC_NUMBER) TYPE  VBELN
*"     REFERENCE(IM_REF_CONTRACT) TYPE  VBELN_VA OPTIONAL
*"  EXCEPTIONS
*"      EXC_MISSING_DIR_PATH
*"      EXC_ERR_OPENING_FILE
*"----------------------------------------------------------------------

  DATA:
    lv_file_name TYPE char128,
    lv_dir_path  TYPE char255,
    lv_file_path TYPE text1000,
    lv_sl_count  TYPE numc4,
    lv_pdf_data  TYPE xstring.

  DATA:
    lo_ex_fl_opn TYPE REF TO cx_root.

  IF i_constants[] IS INITIAL.
*   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = c_devid_0231                             "Development ID: I0231
      IMPORTING
        ex_constants = i_constants.                             "Constant Values
    SORT i_constants BY param1 param2 low.
  ENDIF.

  IF im_file_loc IS NOT INITIAL.
    lv_dir_path = im_file_loc.
  ELSE.
    READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
         WITH KEY param1 = sy-sysid
                  param2 = sy-mandt
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_dir_path = <lst_constant>-low.                         "Directory Path
    ELSE.
*     Message: Directory entry missing
      MESSAGE e003(skwf_sdokerrs) RAISING exc_missing_dir_path.
    ENDIF.
  ENDIF.

  IF im_ref_contract IS NOT INITIAL.
    SELECT renwl_prof
      FROM zqtc_renwl_plan
     UP TO 1 ROWS
      INTO @DATA(lv_renwl_prof)
     WHERE vbeln EQ @im_ref_contract.
    ENDSELECT.
    IF sy-subrc NE 0.
      CLEAR: lv_renwl_prof.
    ENDIF.
  ENDIF.

* Grouping Criteria
  IF lv_renwl_prof IS NOT INITIAL.
*   Token 1 (Business Process) + Token 2 (Print Region) + Token 3 (Renewal Profile)
    CONCATENATE im_bus_prcocess                                 "Business Process
                im_print_region                                 "Print Region
                lv_renwl_prof                                   "Renewal Profile
           INTO lv_file_name
      SEPARATED BY abap_undefined.
  ELSE.
*   Token 1 (Business Process) + Token 2 (Print Region)
    CONCATENATE im_bus_prcocess                                 "Business Process
                im_print_region                                 "Print Region
           INTO lv_file_name
      SEPARATED BY abap_undefined.
  ENDIF.

* The Token 1 can not have any SPACE or UNDERSCORE (TIBCO Restriction)
  REPLACE ALL OCCURRENCES OF c_sep_undscr IN lv_file_name WITH space.
  CONDENSE lv_file_name NO-GAPS.

* Sorting Criteria
* Token 4 (Country Sorting Key) + Token 5 (Country) + Token 6 (Customer Number) + Token 7 (Document Number) + (S)upplement
  CONCATENATE lv_file_name                                      "File Name
              im_country_sort                                   "Country Sorting Key
              im_country                                        "Country Key
              im_customer                                       "Customer Number
              im_doc_number                                     "SD Document Number
              c_supplement                                      "(S)upplement
         INTO lv_file_name
    SEPARATED BY c_sep_undscr.

  LOOP AT im_outputs ASSIGNING FIELD-SYMBOL(<lst_output>).
    CLEAR: lv_file_path,
           lv_pdf_data.
*   Add Supplement Count and File Extension
    CONCATENATE lv_file_name                                    "File Name
                lv_sl_count                                     "Supplement Count
                c_fl_ext_pdf                                    "File Extension (PDF)
           INTO lv_file_path.
*   Build the complete File Path (Directory Path + File Name)
    CONCATENATE lv_dir_path                                     "Directory Path
                lv_file_path                                    "File Name
           INTO lv_file_path                                    "Complete File Path
      SEPARATED BY c_sep_slash.

    lv_pdf_data = <lst_output>-pdf_stream.                      "PDF Datastream
    IF lv_file_path IS NOT INITIAL AND
       lv_pdf_data  IS NOT INITIAL.
*     Open File for writing PDF data
      TRY.
          OPEN DATASET lv_file_path FOR OUTPUT IN BINARY MODE.
          IF sy-subrc NE 0.
            RAISE exc_err_opening_file.
          ENDIF.
        CATCH cx_root INTO lo_ex_fl_opn.
*         Write Exception Text as Message in SY-MSG* Fields
          CALL FUNCTION 'RSAN_MDL_EXCEPTION_TO_SYMSG'
            EXPORTING
              ir_exception = lo_ex_fl_opn
              i_msgty      = c_msgty_err.
          RAISE exc_err_opening_file.
      ENDTRY.

*     Transfer / Write PDF data
      TRANSFER lv_pdf_data TO lv_file_path.
*     Close the File
      CLOSE DATASET lv_file_path.
    ENDIF.

    lv_sl_count = lv_sl_count + 1.                              "Supplement Count
  ENDLOOP.

ENDFUNCTION.
