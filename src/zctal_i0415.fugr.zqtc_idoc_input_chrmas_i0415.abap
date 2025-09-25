FUNCTION ZQTC_IDOC_INPUT_CHRMAS_I0415.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWF_PARAM-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWF_PARAM-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"--------------------------------------------------------------------


* stay with local update processing even if COMMIT is processed  1854522
  SET HANDLER cl_transaction=>after_commit.                   "  1854522

  CALL FUNCTION 'CLCN_ALE_FLG' EXPORTING command = 'SET'.     "  1895782

  IF NOT gf_new_processing IS INITIAL.
    PERFORM idoc_input_chrmas
        TABLES
          idoc_contrl
          idoc_data
          idoc_status
          return_variables
          serialization_info
        USING
          input_method
          mass_processing
        CHANGING
          workflow_result
          application_variable
          in_update_task
          call_transaction_done.
    EXIT.
  ENDIF.


  DATA:
    external_log_no LIKE balhdri-extnumber,    "buffer for log. no.
    f_error(1)      TYPE c.                    "error flag


*........ get representation of decimalpoint ..........................*

  PERFORM chk_decimalpoint USING decimalpoint
                                 dateformat.

*....... switch flag for maintaining via API ...........................

  CALL FUNCTION 'CTMV_SET_STATUS_ALE'
    EXCEPTIONS
      OTHERS = 0.

*........ get the reference to the BADI instance  .....................*
  GET BADI lr_badi_idoc_processing.

*........ get IDs of documents from IDOC_CONTRL .......................*
  LOOP AT idoc_contrl.

*   Check that the IDoc contains the correct BASIC type         v 901627
    IF idoc_contrl-idoctp NS c_mestyp.
      RAISE wrong_function_called.
    ENDIF.                                                  "^ 901627

*    BUSINESS TRANSACTION EVENT (header / data)             "note0388207
    CALL FUNCTION 'OPEN_FI_PERFORM_CHR00200_E'             "note0388207
         EXPORTING                                         "note0388207
             idoc_header       = idoc_contrl               "note0388207
             flg_append_status = 'X'                       "note0388207
         TABLES                                            "note0388207
             idoc_data         = idoc_data                 "note0388207
             idoc_status       = idoc_status               "note0388207
         EXCEPTIONS                                        "note0388207
             OTHERS       = 1.                             "note0388207
    IF sy-subrc = 1.                                       "note0388207
      CONTINUE.                                           "note0388207
    ENDIF.                                                 "note0388207

*........ init of internal structures .................................*

    PERFORM init_tables.
    in_update_task  = c_mark.
    g_mestype       = idoc_contrl-idoctp.

*........ switch on logging ...........................................*

    external_log_no = idoc_contrl-docnum.
    CALL FUNCTION 'CALO_INIT_API'
      EXPORTING
        external_log_no          = external_log_no
        flag_collect_msg_on      = c_mark
      EXCEPTIONS
        log_object_not_found     = 1
        log_sub_object_not_found = 2
        OTHERS                   = 3.
    IF NOT sy-subrc IS INITIAL.
      CLEAR sy-subrc.
    ENDIF.

*........ get IDocs to change a characteristic ........................*

    LOOP AT idoc_data
      WHERE docnum EQ idoc_contrl-docnum.

*........ fill tables with IDoc data ..................................*

      PERFORM fill_tables USING idoc_data
                                f_error.

*........ Call Enhancement to read new idoc segments

      CALL BADI lr_badi_idoc_processing->get_idoc_data
        EXPORTING
          is_idocdata = idoc_data
        CHANGING
          cv_error    = f_error.

*........ don't continue if error occured .............................*

      IF f_error EQ c_mark.
        EXIT.
      ENDIF.

    ENDLOOP.    " at idoc_data

*........ save characteristic .........................................*

    IF sy-subrc EQ 0 AND
       f_error IS INITIAL.

*........ save the correct order of the values .........................

      PERFORM fix_order_of_values.
      PERFORM save_characteristic USING e1datem-aennr
                                        e1datem-key_date
                                        idoc_status.
      idoc_status-docnum = idoc_contrl-docnum.
      APPEND idoc_status.
    ELSE.

      CALL FUNCTION 'CALO_MSG_APPEND_DB_LOG'
        IMPORTING
          lognumber               = idoc_status-appl_log
        EXCEPTIONS
          log_object_not_found    = 01
          log_subobject_not_found = 02
          log_internal_error      = 03.
      IF NOT sy-subrc IS INITIAL.
        CLEAR sy-subrc.
      ENDIF.

*....... IDoc not o. k. ...............................................*

      idoc_status-status = c_idoc_nok.
      idoc_status-msgid  = 'C1'.
      idoc_status-msgty  = 'E'.
      idoc_status-msgno  = '149'.
      idoc_status-docnum = idoc_contrl-docnum.
      APPEND idoc_status.

    ENDIF.

*....... Return IDOC-status to workflow ...............................*

    IF idoc_status-status EQ c_idoc_ok.
      return_variables-wf_param  = 'Processed_IDOCs'.

*....... status of workflow ...........................................*

      workflow_result = '0'.
    ELSE.
      return_variables-wf_param  = 'Error_IDOCs'.

*....... status of workflow ...........................................*

      workflow_result = '99999'.
    ENDIF.
    return_variables-doc_number = idoc_contrl-docnum.
    APPEND return_variables.

  ENDLOOP.   " at IDOC_CONTRL

  CALL FUNCTION 'CLCN_ALE_FLG' EXPORTING command = 'CLEAR'.   "  1895782

  SET HANDLER cl_transaction=>after_commit ACTIVATION ' '.    "  1854522

ENDFUNCTION.
