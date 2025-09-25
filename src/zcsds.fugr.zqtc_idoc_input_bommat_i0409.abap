FUNCTION zqtc_idoc_input_bommat_i0409 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWF_PARAM-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWF_PARAM-APPL_VAR
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZIDOC_INPUT_BOMMAT_I0409 (Function Module)
* PROGRAM DESCRIPTION : This FM is used to create Product master
*                       along with classification data and BOM Creation/Deletion/updating
* DEVELOPER           : Sivareddy Guda (SGUDA)
* CREATION DATE       : 07/01/2021
* OBJECT ID           : PBOM development
* TRANSPORT NUMBER(S) : ED2K923790
*---------------------------------------------------------------------*
*Decleration Local Variables
*----------------------------------------------------------------------*
*- Clear Internal tables and work areas
  CLEAR : li_mat_unit[],li_mat_unitx[],li_mat_des[],
          li_mat_text[],li_taxclas[],lt_extension[],
          lt_extensionx[],li_return[].
* initialize
  workflow_result     = c_success.
  in_update_task  = c_x.
  CLEAR: idoc_err_nr,gt_idoc_data[],li_stpo.
* Check for header- and item-identification method
* (GUID or 'classical'), set g_flg_ident_by_guid.
  PERFORM check_guid_ident_inbound TABLES idoc_contrl.
  DESCRIBE TABLE idoc_contrl LINES nr_entries.
  IF nr_entries <> 1.
    IF nr_entries = 0.
      idoc_err_nr = 4.
    ELSE.
      idoc_err_nr = 2.
    ENDIF.
  ELSE.
    READ TABLE idoc_contrl INDEX 1.
*    BUSINESS TRANSACTION EVENT (header / data)
    CALL FUNCTION 'OPEN_FI_PERFORM_CS000145_E'
      EXPORTING
        idoc_header       = idoc_contrl
        flg_append_status = c_x
      TABLES
        idoc_data         = idoc_data
        idoc_status       = idoc_status
      EXCEPTIONS
        OTHERS            = 1.
    IF sy-subrc = 1.
      EXIT.
    ENDIF.
*    check idoc type
    IF idoc_contrl-idoctp NS 'BOMMAT'.
      RAISE wrong_function_called.
    ENDIF.
*    BUSINESS TRANSACTION EVENT for control header
*    ATTENTION : use of customer RFC will cause a 'commit work'
    CALL FUNCTION 'OPEN_FI_PERFORM_CS000150_E'
      TABLES
        serialization_info = serialization_info
      CHANGING
        idoc_control       = idoc_contrl
      EXCEPTIONS
        idoc_error         = 1.

    IF sy-subrc = 1.
      idoc_err_nr = 1.
    ENDIF.
    CLEAR : gt_class_data[],gt_class_data[],gt_basic_text[],
            gt_ism_data[],gt_header_text[],gt_org_data[],gt_tax_classification[].
*    move and convert data from idoc to application internal tables
    PERFORM idoc_to_bom_itabs TABLES idoc_data
                                     idoc_contrl.
*    find correct plant allocated
    PERFORM f_get_plant_data.
  ENDIF.
* Get ZCACONSTANT Entries
  PERFORM f_get_constant_entries.
* Update/Create Product Master Data
*- Convert to internal format
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = gs_header_data-matnr
    IMPORTING
      output = gs_header_data-matnr.
* Create/Change Multi Journal and Multi Media along with classification data
  PERFORM f_create_change_product.
* Checking Product Material is created or not
  IF lv_flag_success = abap_true.
    PERFORM f_material_unlock.
* if it is created update classification data for created product material
    PERFORM f_create_classification.
  ELSE.
* Implement suitable code
  ENDIF.
  IF lst_mastb-matnr IS NOT INITIAL AND idoc_err_nr IS INITIAL.
    PERFORM f_material_unlock.
    PERFORM f_get_bom_data.
  ELSE.
* Implement suitable code
  ENDIF.
  IF idoc_err_nr IS INITIAL.
    MOVE-CORRESPONDING idoc_contrl TO gs_edidc.
    PERFORM f_build_bom_create_data.
    CLEAR: gt_tstp3[],lt_bom_original[],lt_bom_original_tmp[].
    " Does Have BOM entries and Should be multi Journal Product.
    IF li_stpo[] IS NOT INITIAL AND gs_header_data-mtart IN r_multi_journal.
      PERFORM f_build_modify_bom_data.
      SORT lt_bom_original_tmp BY posnr idnrk.
      DELETE ADJACENT DUPLICATES FROM lt_bom_original_tmp COMPARING posnr idnrk.
      " BOM Entries have modified data
      IF lt_bom_original_tmp[] IS NOT INITIAL.
        PERFORM f_api.
        PERFORM f_bom_open.
        PERFORM f_update_bom_data.
        MOVE-CORRESPONDING lst_idoc_stat TO idoc_status.
        APPEND idoc_status.
        PERFORM f_bom_close.
        CALL FUNCTION 'WSTA_POST_T415B'
          EXPORTING
            matnr = mastb-matnr
            stlan = mastb-stlan
            stlal = '01'.
      ELSE.
      ENDIF. " BOM Entries have modified data
    ELSE.

    ENDIF. " Does Have BOM entries and Should be multi Journal Product.
    PERFORM f_api.
    PERFORM f_unlock_all.
    PERFORM f_material_unlock.
    IF stzub-vbkz = c_bom_insert AND li_stpo[] IS INITIAL.
      PERFORM f_create_bom.
      IF sy-subrc NE 0 OR NOT flg_lock_err IS INITIAL .     "note598927
        bom_error = c_true.
        idoc_status-status = c_idoc_stat_input_error.
        idoc_status-docnum = idoc_contrl-docnum.
        idoc_status-msgty = c_error.
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '002'.    "Error -> check Application-Log
        APPEND idoc_status.
        return_variables-doc_number = idoc_contrl-docnum.
        return_variables-wf_param   = c_retv_error_idocs.
        APPEND return_variables.
        workflow_result = c_data_error.
*         EXIT.   "-> next MAST entry
      ELSE.
*         Stückliste verbucht : nun Retailinfo nachlegen
*         Absprung für Leergutstücklisten (Retail)
        IF retail_flg = c_marked.
          CALL FUNCTION 'WSTA_POST_T415B'
            EXPORTING
              matnr = mastb-matnr
              stlan = mastb-stlan
              stlal = '01'.
        ENDIF.
        idoc_status-msgno = '030'.            "BOM created
        idoc_status-status = c_idoc_stat_is_posted.
        idoc_status-docnum = idoc_contrl-docnum.
        idoc_status-msgty = c_succ.
        idoc_status-msgid = c_mcbom.
        idoc_status-msgv1 = api_mbom-matnr.
        l_str_message-type  = c_succ.
        l_str_message-id   = c_mcbom.
        l_str_message-number     = '030'.
        l_str_message-message_v1 = api_mbom-matnr.
        APPEND l_str_message TO l_tab_messages.
        CLEAR: l_str_message,idoc_err_nr.
        APPEND idoc_status.
        bom_error = abap_true.
      ENDIF.
    ELSE.
      idoc_status-msgno = '557'.
      idoc_status-status = c_idoc_stat_is_posted.
      idoc_status-docnum = idoc_contrl-docnum.
      idoc_status-msgty = c_succ.
      idoc_status-msgid = c_mcbom.
      idoc_status-msgv1 = api_mbom-matnr.
      l_str_message-type  = c_succ.
      l_str_message-id   = c_mcbom.
      l_str_message-number     = '557'.
      l_str_message-message_v1 = api_mbom-matnr.
      APPEND l_str_message TO l_tab_messages.
      CLEAR: l_str_message,idoc_err_nr.
      APPEND idoc_status.
      bom_error = abap_true.
    ENDIF.  "create
*      set IDoc status OK
    IF bom_error   IS INITIAL.
      idoc_status-status = c_idoc_stat_is_posted.
      idoc_status-docnum = idoc_contrl-docnum.
      idoc_status-msgty = c_succ.
      idoc_status-msgid = c_mc29.
      idoc_status-msgv1 = api_mbom-matnr.
      IF NOT api_warning IS INITIAL.
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '003'.      "BOM processed with warnings
      ENDIF.
      APPEND idoc_status.
      return_variables-wf_param   = c_retv_processed_idocs.
      return_variables-doc_number = idoc_contrl-docnum.
      return_variables-wf_param   = c_retv_appl_objects.
*        internal object-id (STLNR) unknown, so we use the external name
      CONCATENATE api_mbom-matnr api_mbom-werks api_mbom-stlan
                  INTO return_variables-doc_number.
      APPEND return_variables.
      in_update_task = c_true.
    ELSE.
* Implement suitable code
    ENDIF.
  ELSE.
* Implement suitable code
  ENDIF.
  IF idoc_err_nr <> 0.
    idoc_status-status = c_idoc_stat_input_error.
    idoc_status-docnum = idoc_contrl-docnum.
    idoc_status-msgty = c_e.
    CASE idoc_err_nr.
      WHEN 1.
*        Fehler in der kundenspezifischen IDOC-Verarbeitung
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '015'.
      WHEN 2.
*        Es kann nur jeweils ein IDOC verbucht werden
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '016'.
      WHEN 3.
*        Es kann nur jeweils eine Stückliste verbucht werden
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '017'.
      WHEN 4.
*        Error -> No IDOC available
        idoc_status-msgid = 'B1'.
        idoc_status-msgno = '282'.
      WHEN 5.
*       IDoc contains a structured article with full products -> cannot be posted
        idoc_status-msgid = c_mcbom.
        idoc_status-msgno = '052'.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 6.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 6.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 7.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 7.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 8.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 8.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 9.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 9.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 10.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 10.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
      WHEN 11.
        READ TABLE lt_idoc_status INTO lst_idoc_status WITH KEY err_nr = 11.
        idoc_status-msgid = lst_idoc_status-msgid.
        idoc_status-msgno = lst_idoc_status-msgno.
        idoc_status-msgv1 = gv_matnr_err.
    ENDCASE.
    PERFORM appl_log_write_single_message
    USING 'E' idoc_status-msgid
          idoc_status-msgno
          gv_matnr_err
          akt_uname
          ' ' ' '.
* status set by distribution unity
    IF idoc_err_nr <> 11.
      APPEND idoc_status.
    ENDIF.
    return_variables-doc_number = idoc_contrl-docnum.
    return_variables-wf_param   = c_retv_error_idocs.
    APPEND return_variables.
    workflow_result = c_data_error.
*    ENDCASE.
  ENDIF.
* Create Service log and Upate the respective message.
  PERFORM f_slg_create.
* BUSINESS TRANSACTION EVENT for return variables
* ATTENTION : use of customer RFC will cause a 'commit work'
  CALL FUNCTION 'OPEN_FI_PERFORM_CS000180_E'
    EXPORTING
      idoc_control       = idoc_contrl
    TABLES
      idoc_status        = idoc_status
      return_variables   = return_variables
      serialization_info = serialization_info
    CHANGING
      workflow_result    = workflow_result.


ENDFUNCTION.
