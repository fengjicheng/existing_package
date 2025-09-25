FUNCTION zqtc_jgc_society_trigger_idoc.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_IDOC_CONTRL) TYPE  EDIDC_TT
*"     VALUE(IM_IDOC_DATA) TYPE  EDIDD_TT
*"     VALUE(IM_JGC_SOCIETY) TYPE  ZTQTC_VARCOND_SOCIETY
*"----------------------------------------------------------------------

  DATA:
    li_idoc_data   TYPE edidd_tt,                          "IDoc Data Records
    li_idoc_contrl TYPE edidc_tt.                          "IDoc Control Records

  DATA:
    lst_edi_sttngs TYPE edi_glo,                           "Global IDoc Administration Settings
    lst_ediadmin   TYPE swhactor,                          "Rule Resolution Result
    lst_ib_process TYPE tede2,                             "EDI process types (inbound)
    lst_d_e1komg   TYPE e1komg,                            "Filter segment with separated condition key
    lst_cntrl_rec  TYPE edidc.                             "Control record (IDoc)

* Find out whether ALE is existing in the system
  CALL FUNCTION 'IDOC_READ_GLOBAL'
    IMPORTING
      global_data    = lst_edi_sttngs                      "Global IDoc Administration Settings
    EXCEPTIONS
      internal_error = 0
      OTHERS         = 0.
  IF sy-subrc EQ 0.
    lst_ediadmin = lst_edi_sttngs-no_appl.                 "Rule Resolution Result
  ENDIF.

  LOOP AT im_jgc_society ASSIGNING FIELD-SYMBOL(<lst_society>).
*   Update Data Record with Society information
    li_idoc_data[] = im_idoc_data[].
    READ TABLE li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_edidd>)
         WITH KEY segnam = c_sgmnt_e1komg.
    IF sy-subrc EQ 0.
      lst_d_e1komg = <lst_edidd>-sdata.
      lst_d_e1komg-varcond = <lst_society>.                "Variant condition = Society Info
      <lst_edidd>-sdata = lst_d_e1komg.
    ENDIF.

    CLEAR: lst_cntrl_rec.
    READ TABLE im_idoc_contrl INTO lst_cntrl_rec INDEX 1.
    IF sy-subrc EQ 0.
      CLEAR: lst_cntrl_rec-docnum.

*     Create and Save IDOC in DB
      CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
        EXPORTING
          pi_do_handle_error      = abap_true              "Flag: Error handling yes/no
          pi_return_data_flag     = abap_false             "Return of initialized data records
        IMPORTING
          pe_idoc_number          = lst_cntrl_rec-docnum   "IDOC Number
          pe_inbound_process_data = lst_ib_process         "EDI process types (inbound)
        TABLES
          t_data_records          = li_idoc_data           "IDOC Data Records
        CHANGING
          pc_control_record       = lst_cntrl_rec          "IDOC Control Record
        EXCEPTIONS
          idoc_not_saved          = 1
          OTHERS                  = 2.
      IF sy-subrc EQ 0.
        COMMIT WORK.

        SET PARAMETER ID 'DCN' FIELD lst_cntrl_rec-docnum. "IDOC Number
        APPEND lst_cntrl_rec TO li_idoc_contrl.            "IDOC Control Record
        CLEAR: lst_cntrl_rec.

*       Start inbound processing for inbound IDoc
        CALL FUNCTION 'IDOC_START_INBOUND'
          EXPORTING
            pi_inbound_process_data       = lst_ib_process "EDI process types (inbound)
            pi_org_unit                   = lst_ediadmin   "Rule Resolution Result
          TABLES
            t_control_records             = li_idoc_contrl "IDOC Control Records
            t_data_records                = li_idoc_data   "IDOC Data Records
          EXCEPTIONS
            invalid_document_number       = 1
            error_before_call_application = 2
            inbound_process_not_possible  = 3
            old_wf_start_failed           = 4
            wf_task_error                 = 5
            serious_inbound_error         = 6
            OTHERS                        = 7.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFUNCTION.
