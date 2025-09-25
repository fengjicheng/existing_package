*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_VARIANT_CONTENTS_CHG_SUB (Include Program)
* PROGRAM DESCRIPTION: Variaant Read and update
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   04/02/2018
* OBJECT ID:  ?
* TRANSPORT NUMBER(S): ED2K911732
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_VARIANT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_variant_data .
*- Get Variant Details  from program and  variant name
  CALL FUNCTION 'RS_VARIANT_CONTENTS'
    EXPORTING
      report               = p_pr_n
      variant              = p_vr_n
    TABLES
      valutab              = lt_rsparams
    EXCEPTIONS
      variant_non_existent = 1
      variant_obsolete     = 2
      OTHERS               = 3.
  IF sy-subrc = 0.
*- Loop proocess for variant data
    LOOP AT lt_rsparams INTO lst_rsparams.
      CASE lst_rsparams-selname.
*- Created on
        WHEN c_credat.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_credat-sign = lst_rsparams-sign .
            lst_credat-option = lst_rsparams-option.
*- Date Converting to internal  format
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                date_external            = lst_rsparams-low
              IMPORTING
                date_internal            = lst_credat-low
              EXCEPTIONS
                date_external_is_invalid = 1
                OTHERS                   = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
*- Date converting to internal format
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                date_external            = lst_rsparams-high
              IMPORTING
                date_internal            = lst_credat-high
              EXCEPTIONS
                date_external_is_invalid = 1
                OTHERS                   = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.
            APPEND lst_credat TO lt_credat. " Credated Date
          ENDIF.
          CLEAR lst_credat.
*-  Created at
        WHEN c_cretim.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_cretim-sign = lst_rsparams-sign .
            lst_cretim-option = lst_rsparams-option.
*- Time converting to internal format
            CALL FUNCTION 'CONVERSION_EXIT_RSTIM_INPUT'
              EXPORTING
                input  = lst_rsparams-low
              IMPORTING
                output = lst_cretim-low.
*- Time converting to internal format
            CALL FUNCTION 'CONVERSION_EXIT_RSTIM_INPUT'
              EXPORTING
                input  = lst_rsparams-high
              IMPORTING
                output = lst_cretim-high.
            APPEND lst_cretim TO lt_cretim. " Created Time
          ENDIF.
          CLEAR lst_cretim.
*- IDoc number
        WHEN c_docnum.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_docnum-sign = lst_rsparams-sign .
            lst_docnum-option = lst_rsparams-option.
            lst_docnum-low = lst_rsparams-low.
            lst_docnum-high = lst_rsparams-high.
            APPEND lst_docnum TO lt_docnum. " IDOC Number
          ENDIF.
          CLEAR lst_docnum.
*- Logical Message Variant
        WHEN c_mescod.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_mescod-sign = lst_rsparams-sign .
            lst_mescod-option = lst_rsparams-option.
            lst_mescod-low = lst_rsparams-low.
            lst_mescod-high = lst_rsparams-high.
            APPEND lst_mescod TO lt_mescod. " Logical Message Variant
          ENDIF.
          CLEAR lst_mescod.
*- Message function
        WHEN c_mesfct.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_mesfct-sign = lst_rsparams-sign .
            lst_mesfct-option = lst_rsparams-option.
            lst_mesfct-low = lst_rsparams-low.
            lst_mesfct-high = lst_rsparams-high.
            APPEND lst_mesfct TO lt_mesfct. " Message function
          ENDIF.
          CLEAR lst_mesfct.
*- Message type
        WHEN c_mestyp.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_mestyp-sign = lst_rsparams-sign .
            lst_mestyp-option = lst_rsparams-option.
            lst_mestyp-low = lst_rsparams-low.
            lst_mestyp-high = lst_rsparams-high.
            APPEND lst_mestyp TO lt_mestyp. " Message Type
          ENDIF.
          CLEAR lst_mestyp.
*- IDoc Status
        WHEN c_status.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_status-sign = lst_rsparams-sign .
            lst_status-option = lst_rsparams-option.
            lst_status-low = lst_rsparams-low.
            lst_status-high = lst_rsparams-high.
            APPEND lst_status TO lt_status. " IDOC Status
          ENDIF.
          CLEAR lst_status.
*- Sender partn.funct.
        WHEN c_sndpfc.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_sndpfc-sign = lst_rsparams-sign .
            lst_sndpfc-option = lst_rsparams-option.
            lst_sndpfc-low = lst_rsparams-low.
            lst_sndpfc-high = lst_rsparams-high.
            APPEND lst_sndpfc TO lt_sndpfc. "Sender partn.funct.
          ENDIF.
          CLEAR lst_sndpfc.
*- Sender partner no.
        WHEN c_sndprn.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_sndprn-sign = lst_rsparams-sign .
            lst_sndprn-option = lst_rsparams-option.
            lst_sndprn-low = lst_rsparams-low.
            lst_sndprn-high = lst_rsparams-high.
            APPEND lst_sndprn TO lt_sndprn. " Sender partner no.
          ENDIF.
          CLEAR lst_sndprn.
*- Sender partner type
        WHEN c_sndprt.
          IF lst_rsparams-low IS NOT INITIAL OR  lst_rsparams-high IS NOT INITIAL.
            lst_sndprt-sign = lst_rsparams-sign .
            lst_sndprt-option = lst_rsparams-option.
            lst_sndprt-low = lst_rsparams-low.
            lst_sndprt-high = lst_rsparams-high.
            APPEND lst_sndprt TO lt_sndprt. " Sender partner type
          ENDIF.
          CLEAR lst_sndprt.
      ENDCASE.
      CLEAR lst_rsparams.
    ENDLOOP.
  ELSE.
    lv_message = 'Failed to read Variant Data'(003).
    PERFORM status_update_fail USING lv_message.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_COUNT_FOR_IDOCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_count_for_idocs .
  DATA : lv_round TYPE edippcksiz. " For Rounf off
*- Clear the variables and interanl table
  CLEAR:lv_idoc_count,lv_round,lv_get_packet_o,lv_get_packet_n,lt_idoc_control_r[].
*- Get IDOC data from EDIDC table
  SELECT * FROM edidc INTO TABLE lt_idoc_control_r
    WHERE status IN lt_status
    AND docnum IN lt_docnum "IDOC Number
    AND mestyp IN lt_mestyp "Message Type
    AND mescod IN lt_mescod "Message Variant
    AND mesfct IN lt_mesfct "Message function
    AND sndprt IN lt_sndprt "Sender partner type
    AND sndprn IN lt_sndprn "Sender partner no.
    AND sndpfc IN lt_sndpfc "Sender partn.funct.
    AND credat IN lt_credat "Created on
    AND cretim IN lt_cretim."Created at
*- Checking  table initial or not
  IF lt_idoc_control_r[] IS NOT INITIAL.
*- Get IDOC Count
    DESCRIBE TABLE lt_idoc_control_r LINES lv_idoc_count.
*- Division with selection screen field of division
    lv_round = lv_idoc_count / p_div.
*- Populate the variablle with Pack. Size
    lv_get_packet_n = lv_round.
  ELSE.
    lv_message = 'No data was found to update Pack.Size'(004).
    PERFORM status_update_fail USING lv_message.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_VARIANT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_variant_data .
  DATA : lv_des   TYPE varid,   "Variant Description
         lv_index TYPE sytabix. "Index value
*- Process the loop for variant data
  LOOP AT lt_rsparams INTO lst_rsparams.
    CASE lst_rsparams-selname.
*- Date
      WHEN c_credat.
*- Date Converting to internal  format
        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_rsparams-low
          IMPORTING
            date_internal            = lst_rsparams-low
          EXCEPTIONS
            date_external_is_invalid = 1
            OTHERS                   = 2.
        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = lst_rsparams-high
          IMPORTING
            date_internal            = lst_rsparams-high
          EXCEPTIONS
            date_external_is_invalid = 1
            OTHERS                   = 2.

        lv_index = sy-tabix.
*- Modifying the table with Pack. Size
        MODIFY lt_rsparams FROM lst_rsparams INDEX lv_index TRANSPORTING low high.
        CLEAR lst_rsparams.
*- Time
      WHEN c_cretim.
*- Time converting to internal format
        CALL FUNCTION 'CONVERSION_EXIT_RSTIM_INPUT'
          EXPORTING
            input  = lst_rsparams-low
          IMPORTING
            output = lst_rsparams-low.
        CALL FUNCTION 'CONVERSION_EXIT_RSTIM_INPUT'
          EXPORTING
            input  = lst_rsparams-high
          IMPORTING
            output = lst_rsparams-high.
        lv_index = sy-tabix.
*- Modifying the table with time with internal format
        MODIFY lt_rsparams FROM lst_rsparams INDEX lv_index TRANSPORTING low high.
        CLEAR lst_rsparams.
*- Pack. Size
      WHEN c_p_pcksiz.
        lv_get_packet_o = lst_rsparams-low.
        lst_rsparams-low = lv_get_packet_n.
        lv_index = sy-tabix.
*- Modifying the table with Pack. Size
        MODIFY lt_rsparams FROM lst_rsparams INDEX lv_index TRANSPORTING low .
        CLEAR lst_rsparams.
    ENDCASE.
    CLEAR lst_rsparams.
  ENDLOOP.
  CALL FUNCTION 'RS_CHANGE_CREATED_VARIANT'
    EXPORTING
      curr_report               = p_pr_n
      curr_variant              = p_vr_n
      vari_desc                 = lv_des
    TABLES
      vari_contents             = lt_rsparams
    EXCEPTIONS
      illegal_report_or_variant = 1
      illegal_variantname       = 2
      not_authorized            = 3
      not_executed              = 4
      report_not_existent       = 5
      report_not_supplied       = 6
      variant_doesnt_exist      = 7
      variant_locked            = 8
      selections_no_match       = 9
      OTHERS                    = 10.
  IF sy-subrc EQ 0.
    lv_message = 'Variant is updated with new Pack.Size'(005).
    PERFORM status_update_success USING lv_message.
* Implement suitable error handling here
  ELSE.
    lv_message = 'Variant Failed to update with Pack.Size'(006).
    PERFORM status_update_fail USING lv_message.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_RPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_rpt .
  PERFORM build_fcat.
  lv_repid = sy-repid.
  lv_layout-lights_fieldname = 'ICON'.
*Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = lv_repid
      is_layout          = lv_layout
      it_fieldcat        = lt_fieldcat
    TABLES
      t_outtab           = lt_final_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fcat .
  lst_fieldcat-fieldname  = 'REPORT'.
  lst_fieldcat-seltext_m  = 'Program Name'(007).
  lst_fieldcat-outputlen  = 15.
  APPEND lst_fieldcat TO lt_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname  = 'VARIANT'.
  lst_fieldcat-seltext_m  = 'Variant Name'(008).
  lst_fieldcat-outputlen  = 15.
  APPEND lst_fieldcat TO lt_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname  = 'OLD_PACK_SIZE'.
  lst_fieldcat-seltext_m  = 'Old Pack.Size'(009).
  lst_fieldcat-outputlen  = 15.
  APPEND lst_fieldcat TO lt_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname  = 'NEW_PACK_SIZE'.
  lst_fieldcat-seltext_m  = 'New Pack.Size'(010).
  lst_fieldcat-outputlen  = 15.
  APPEND lst_fieldcat TO lt_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname  = 'MESSAGE'.
  lst_fieldcat-seltext_m  = 'Status'(011).
  lst_fieldcat-outputlen  = 50.
  APPEND lst_fieldcat TO lt_fieldcat.
  CLEAR lst_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STATUS_UPDATE_SUCCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM status_update_success USING message TYPE char100.
  lst_final_alv-report =  p_pr_n.
  lst_final_alv-variant = p_vr_n.
  lst_final_alv-message = message.
  lst_final_alv-icon = c_3.
  lst_final_alv-old_pack_size = lv_get_packet_o.
  lst_final_alv-new_pack_size =  lv_get_packet_n.
  APPEND lst_final_alv TO lt_final_alv.
  CLEAR lst_final_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STATUS_UPDATE_FAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM status_update_fail USING message  TYPE char100.
  lst_final_alv-report =  p_pr_n.
  lst_final_alv-variant = p_vr_n.
  lst_final_alv-message = message.
  lst_final_alv-icon = c_1.
  lst_final_alv-old_pack_size = lv_get_packet_o.
  lst_final_alv-new_pack_size =  lv_get_packet_n.
  APPEND lst_final_alv TO lt_final_alv.
  CLEAR lst_final_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data .
  REFRESH:lt_rsparams,lt_docnum,lt_status,lt_mescod,lt_mesfct,
          lt_sndprt,lt_sndprn,lt_sndpfc,lt_credat,lt_cretim,
          lt_mestyp,lt_idoc_control_r,lt_final_alv,lt_fieldcat.
  CLEAR:lst_varid,lst_rsparams,lst_docnum,lst_status,lst_mescod,
        lst_mesfct,lst_sndprt,lst_sndprn,lst_sndpfc,lst_credat,
        lst_cretim,lst_mestyp,lst_idoc_control_r,lv_idoc_count,
        lv_get_packet_n,lv_get_packet_o,lst_final_alv,lst_fieldcat,
        lv_layout,lv_message,lv_repid.
ENDFORM.
