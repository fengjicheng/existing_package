FUNCTION zqtc_bp_search_create_e225 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SOURCE) TYPE  TPM_SOURCE_NAME OPTIONAL
*"     VALUE(IM_DEVID) TYPE  ZDEVID DEFAULT 'E225'
*"  EXPORTING
*"     REFERENCE(EX_BPSEARCH) TYPE  ZTQTC_BPSEARCH
*"  TABLES
*"      T_FILE STRUCTURE  ZSQTC_BP_UPDATE OPTIONAL
*"      T_LOG STRUCTURE  ZE225_STAGING OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_BP_SEARCH_CREATE_E225 (FM)
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 12/10/2019
* OBJECT ID:     E225/ERPM-2334
* TRANSPORT NUMBER(S):ED2K916061
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918959
* REFERENCE NO: ERPM-22299
* DEVELOPER:  Lahiru Wathudura(LWATHUDURA)
* WRICEF ID : E225/I0387
* DATE: 07/22/2020
* DESCRIPTION:  Extend the BP search functionality considering
*               the Input source as RPA and IF source is RPA avoid the BP Creation
*&---------------------------------------------------------------------*
  DATA : lv_lines        TYPE i,
         lv_ar_lines     TYPE i,
         lv_bp_stat      TYPE zprcstat,
         lv_err_type     TYPE char2,
         lv_index        TYPE sy-tabix,
         lv_log_updated  TYPE c,
         lv_tabix_search TYPE sy-tabix.
*"----------------------------------------------------------------------
*----- Clear Global variables
*"----------------------------------------------------------------------
  PERFORM f_clear_global_v3.
  v_source = im_source.
  i_file[] = t_file[].
  i_staging[]  = t_log[].
  SORT i_staging BY zuid_upld zoid zitem.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*----- Get BP Rules
*"----------------------------------------------------------------------
  PERFORM f_get_bp_rules.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*----- Get Constants from ZCACONSTANT
*"----------------------------------------------------------------------
  IF st_bp_rules IS NOT INITIAL.
    PERFORM f_get_bp_constants USING im_source
                                     im_devid.
*"----------------------------------------------------------------------
*-----Fecth Custom tables data
*"----------------------------------------------------------------------
    PERFORM f_get_tables_data TABLES i_file.
*"----------------------------------------------------------------------
    LOOP AT i_file INTO st_file.
      lv_index = sy-tabix.
      CLEAR : lv_bp_stat , v_invalid_email.
*"----------------------------------------------------------------------
*-----Variables that needs to be cleared with in loop
*"----------------------------------------------------------------------
      PERFORM f_clear_global_v4.
*"---------------------------------------------------------------------
*--*Skip forwarding agent record
      IF st_file-parvw = c_sp.
        CONTINUE.
      ENDIF.
*"----------------------------------------------------------------------
*-For Society input if file has BP  number extend relationship,
*      further checks not required as file is having BP
*"----------------------------------------------------------------------
*      st_bp_rules-check16_existing_bp_rel = abap_true AND
      IF st_file-customer IS NOT INITIAL.
        v_bp = st_file-customer.
        PERFORM f_file_bp_exist USING st_file v_bp lv_log_updated
                                CHANGING v_error.
        IF v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
          PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
          CONTINUE.
        ENDIF.
      ENDIF.
*"----------------------------------------------------------------------
*-Process starts when BP is initial in input file
*"----------------------------------------------------------------------
      IF st_file-customer IS INITIAL.
*"----------------------------------------------------------------------
*-Process file data address validations
*"----------------------------------------------------------------------
        IF st_bp_rules-check1_file_address = abap_true.
          PERFORM f_file_address_validations CHANGING st_file
                                                     v_error.
*----------------------------------------------------------------------
          IF v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
            PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
            CONTINUE.
          ENDIF.
        ENDIF.
*-----------------------------------------------------------------------
*"----------------------------------------------------------------------
*----Member ID search
*"----------------------------------------------------------------------
        IF st_bp_rules-check2_memberid_ = abap_true.
          PERFORM f_member_id_search USING st_file-id_number
                                     CHANGING v_error.
*----------------------------------------------------------------------
          IF v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
            PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
            CONTINUE.
          ENDIF.
        ENDIF.
*-----------------------------------------------------------------------
*"----------------------------------------------------------------------
*----BP Search
*"----------------------------------------------------------------------
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
        " Check Whether BP is creating or not
        IF st_bp_rules-check18_donot_create_bp = abap_true.
          CASE v_source.
            WHEN c_source_rpa.      " Input source is equal to RPA
              " Validate email address.(Check email address content is included @ symbol)
              PERFORM f_validate_email USING st_file CHANGING v_invalid_email.
              IF v_invalid_email IS NOT INITIAL.      " Email is invalid
                PERFORM f_bp_rpa_source_result USING v_source text-m04 text-021 c_msgty_err v_bp.
                CONTINUE.
              ENDIF.
          ENDCASE.
        ENDIF.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****

        PERFORM f_bp_main_search USING st_file st_bp_rules.
*"---------------------------------------------------------------------
*"----------------------------------------------------------------------
        DESCRIBE TABLE i_search_result LINES lv_lines.
        IF lv_lines = 1.
          READ TABLE i_search_result INTO st_search_result INDEX 1.
          v_bp = st_search_result-partner.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
          lv_bp_stat = c_b4. "Inprogress BP Identified
          PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----BP Sales Role ISM000 check
*"----------------------------------------------------------------------
          IF st_bp_rules-check8_sales_role = abap_true.
            PERFORM f_bp_role_single USING st_search_result-partner.
          ENDIF.
          IF st_create-gen_data IS INITIAL. "BP found with sales extension
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----BP Rules - Sales, Company code and Relationship Extensions
*"----------------------------------------------------------------------
            PERFORM f_bp_rules_comp_sales USING st_bp_rules v_bp st_file
                                                       CHANGING v_error.
*---------------------------------------------------------------------
            IF v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
              PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
              CONTINUE.
            ENDIF.
*"--------------------------------------------------------------------------
          ELSE. "BP Not found with Sales Extension
*--*Create New BP
            PERFORM f_map_creation_flags.
          ENDIF.
        ELSEIF lv_lines GT 1.   "Multiple BP found in BP Search
*"----------------------------------------------------------------------
*-----Multiple BP found and roles(ISM000) Check
*"---------------------------------------------------------------------
          PERFORM f_bp_role_multiple TABLES i_search_result
                                     USING st_file-vkorg
                                           st_file-vtweg
                                           st_file-spart
                                      CHANGING v_error.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
          IF v_error IS NOT INITIAL.
            lv_err_type =  c_block.
            PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
*--*Modify out going table with message type and BP
            PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
            CONTINUE.
          ENDIF.
*"----------------------------------------------------------------------
          DESCRIBE TABLE i_search_result LINES lv_ar_lines.
          IF lv_ar_lines GT 1. "Multiple BP Found,check BP Account Receivables Data
*"----------------------------------------------------------------------
*-----Multiple BP found then AR data check
*"---------------------------------------------------------------------
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
            IF st_bp_rules-check18_donot_create_bp = abap_true.
              PERFORM f_rpa_bp_overall_sales_block TABLES i_search_result.
              LOOP AT i_search_result ASSIGNING FIELD-SYMBOL(<lfs_st_result>).
                lv_tabix_search = sy-tabix.
                READ TABLE i_kna1 INTO st_kna1 WITH KEY kunnr = <lfs_st_result>-partner BINARY SEARCH.
                IF sy-subrc NE 0.
                  " Delete sales block customers from the search result
                  DELETE i_search_result INDEX lv_tabix_search.
                ENDIF.
              ENDLOOP.
            ENDIF.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
            IF st_bp_rules-check6_ardata_chk = abap_true.
              PERFORM f_bp_ardata_check TABLES i_search_result
                                               i_file
                                        USING st_file-vkorg
                                              lv_index
                                        CHANGING v_error v_bp.
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
              IF st_bp_rules-check18_donot_create_bp = abap_true.
                " Validate the search result based on source
                PERFORM f_validate_search_result.
                CONTINUE.
              ENDIF.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
              IF v_error IS NOT INITIAL OR v_bp IS NOT INITIAL.
                CONTINUE.
              ENDIF.
            ENDIF.
*"----------------------------------------------------------------------
*-----Single BP found with AR data
*"---------------------------------------------------------------------
          ELSEIF lv_ar_lines EQ 1."Single BP Found with BP Account-Receivables Data
            READ TABLE i_search_result INTO DATA(lst_search_result_multi) INDEX 1.
            v_bp = lst_search_result_multi-partner.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----BP Rules - Sales, Company code and Relationship Extensions
*"----------------------------------------------------------------------
            PERFORM f_bp_rules_comp_sales USING st_bp_rules v_bp st_file CHANGING v_error.
*-------------------------------------------------------------------------
            IF v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
              PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
              CONTINUE.
            ELSE.
*"----------------------------------------------------------------------
*----Right BP found in ARDATA SLG Log update and Staging table update
*"----------------------------------------------------------------------
              lv_bp_stat = c_b4. "Inprogress BP Identified
              PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
*--*Modify out going table with message type and BP
              PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
              CONTINUE.
            ENDIF.
*"-----------------------------------------------------------------------
          ELSE. "None of the BP is accurate among multiple BP's Found
            PERFORM f_map_creation_flags.
          ENDIF.
        ELSE. "No BP Found in BP Search
*------------------------------------------------------------
*-----BP Company code/sales extension for country IN/AUS check
*"----------------------------------------------------------------------
          IF st_bp_rules-check13_ctry_au = abap_true OR
             st_bp_rules-check12_ctry_in = abap_true.
            PERFORM f_bp_compcode_sales_ind_au_chk USING  v_bp st_file
                                                   CHANGING v_error lv_err_type.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
            IF v_error IS NOT INITIAL.
              PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
*--*Modify out going table with message type and BP
              PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
              CONTINUE.
            ENDIF.
          ENDIF.
*"----------------------------------------------------------------------
*-Society BP mentioned in relationship data is different from Sold To Party
*"----------------------------------------------------------------------
          IF st_bp_rules-check17_file_bp_soldto = abap_true.
            PERFORM f_bp_soldto_check USING st_file
                                      CHANGING v_error lv_err_type lv_bp_stat.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
            IF v_error IS NOT INITIAL.
              PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
*--*Modify out going table with message type and BP
              PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
              CONTINUE.
            ENDIF.
          ENDIF.
*--*---------------------------------------------------------------------------
*-----BP Creation & Extension
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
          PERFORM f_map_creation_flags.
        ENDIF.
      ENDIF. "IF st_file-customer IS INITIAL.
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
      IF st_bp_rules-check18_donot_create_bp = abap_true.
        " Validate the search result based on source
        PERFORM f_validate_search_result.
        CONTINUE.
      ENDIF.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
*"----------------------------------------------------------------------
*-----Map input file data to BP deep structures
*"----------------------------------------------------------------------
      IF st_create IS NOT INITIAL.
        PERFORM f_map_bp_data USING st_file.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
        PERFORM f_get_status_2 CHANGING lv_bp_stat.
        PERFORM f_log_msg_add USING st_file lv_bp_stat v_error lv_err_type.
        PERFORM f_staging_update USING st_file lv_bp_stat v_error.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----Call AGU BP update FM
*"----------------------------------------------------------------------
        PERFORM f_call_bp_create_fm.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
        PERFORM f_update_bapi_return_log CHANGING st_file.
      ENDIF.
*--*Update BP partners
      IF st_create IS INITIAL AND v_bp IS NOT INITIAL AND v_error IS INITIAL.
        lv_log_updated = abap_true.
        PERFORM f_file_bp_exist USING st_file v_bp lv_log_updated
                                 CHANGING v_error.
        CLEAR:lv_log_updated.
      ENDIF.
*--*Modify out going table with message type and BP
      PERFORM f_update_input_file TABLES i_file USING st_file lv_index v_bp v_error.
    ENDLOOP.
    t_file[] = i_file[].
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
    ex_bpsearch[] = i_bp_search_rpa[].
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
  ELSE. "No BP rules maintained
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
    IF st_bp_rules-check18_donot_create_bp = abap_true.
      PERFORM f_validate_search_result.
    ENDIF.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
    PERFORM f_build_error_file.
    t_file[] = i_file[].
  ENDIF.
ENDFUNCTION.
