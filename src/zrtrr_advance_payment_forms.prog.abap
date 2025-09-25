*&---------------------------------------------------------------------*
*&  Include           ZRTRR_ADVANCE_PAYMENT_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialize .
  REFRESH : i_output, i_cds, i_msg_type, s_vbtyp, i_cds_tmp.
  CLEAR : st_output, st_cds, st_msg_type.
  s_vbtyp-sign = c_i.
  s_vbtyp-option = c_eq.
  s_vbtyp-low = c_m.
  APPEND s_vbtyp.
  s_vbtyp-low = c_n.
  APPEND s_vbtyp.
  s_vbtyp-low = c_u.
  APPEND s_vbtyp.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_selection .
*--* Validate Proforma number on selection screen
  IF s_prof[] IS NOT INITIAL.
    SELECT SINGLE vbeln FROM vbrk INTO v_vbeln
                         WHERE vbeln IN s_prof.
    IF sy-subrc NE 0.
      MESSAGE text-003 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
    REFRESH s_vbtyp.
  ENDIF.
*--*Validate Invoice
  IF s_inv[] IS NOT INITIAL.
    SELECT SINGLE vbeln FROM vbrk INTO v_vbeln
                        WHERE vbeln IN s_inv.
    IF sy-subrc NE 0.
      MESSAGE text-003 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
*--*Validate Contract
  IF s_con[] IS NOT INITIAL.
    SELECT SINGLE vbeln FROM vbak INTO v_contract
                        WHERE vbeln IN s_con.
    IF sy-subrc NE 0.
      MESSAGE text-003 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
*--* Validate Sales Org
  IF s_vkorg[] IS NOT INITIAL.
    SELECT SINGLE vkorg FROM tvko INTO v_vkorg
                        WHERE vkorg IN s_vkorg.
    IF sy-subrc NE 0.
      MESSAGE text-004 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
*--* Validate Sales Office
  IF s_vkbur[] IS NOT INITIAL.
    SELECT SINGLE vkbur FROM tvbur INTO v_vkbur
                        WHERE vkbur IN s_vkbur.
    IF sy-subrc NE 0.
      MESSAGE text-034 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
*--* Validate Payer
  IF s_kunrg[] IS NOT INITIAL.
    SELECT SINGLE kunnr FROM kna1 INTO v_kunrg
                        WHERE kunnr IN s_kunrg.
    IF sy-subrc NE 0.
      MESSAGE text-005 TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  SELECT  a~proforma                         "Proforma
          a~proforma_item
          a~proforma_create_date             "Proforma create date
          a~payer                            "Payer
          a~payer_name                       "Payer name
          a~sales_org                        "Sales org
          a~po_number                        "PO number
          a~po_date                          "PO date
          a~accounting_clerk                 "Collector No
          a~clear_name                       "Collector name
          a~contract                         "Contract
          a~contract_item                    "Contract Item
          a~salesrep_name                    "Sales rep
          a~total_due_amount                 "Due amount
          a~proforma_currency                "Currency
          a~last_send_date                   "Last send date
          a~message_type                     "Output Message Type
          a~pay_value                        "Pay Value
          a~payment_date                     "Payment date
          a~payment_term_key                 "Payment terms
          a~no_of_days                       "No of days
          a~proforma_status                  "Proforma Status
          a~message_date                     "Message date
          a~message_time                     "Message Time
          b~vbelv
          b~posnv
          b~vbeln                            "Invoice
          b~posnn                            "Invoice Item
          b~vbtyp_n
          b~vbtyp_v
          b~stufe
          b~fksto
          b~erdat  FROM zcds_proforma AS a INNER JOIN zcds_prof001 AS b
                          ON a~contract = b~vbelv
                          AND a~contract_item = b~posnv
                        INTO TABLE i_cds
                        WHERE a~proforma IN s_prof
                         AND  a~payer IN s_kunrg
                         AND  a~proforma_create_date IN s_erdat
                         AND  a~sales_org IN s_vkorg
                         AND  a~sales_office IN s_vkbur
                         AND  a~po_number IN s_po
                         AND  a~contract IN s_con
                         AND  b~vbeln IN s_inv
                         AND  b~vbtyp_n IN s_vbtyp.
  IF sy-subrc EQ 0.
    i_cds_tmp[] = i_cds[].
*--*Chcek the input selection and Keep the data as per Input
*--*Deleting duplicate invoces when it contains multiple items
    SORT i_cds BY proforma vbeln.
    DELETE ADJACENT DUPLICATES FROM i_cds COMPARING proforma vbeln.
*--*Radio button to select Proforma with Invoice
    IF rb_wt_in IS NOT INITIAL..
      DELETE i_cds WHERE vbtyp_n EQ c_u.
*--*Radio button to select Profroma without Invoice
    ELSEIF rb_wo_in IS NOT INITIAL.
      LOOP AT i_cds INTO st_cds.
*--*below check is to make sure invoice document is alive
        IF st_cds-vbtyp_n = c_m AND st_cds-fksto IS INITIAL.
          DELETE i_cds WHERE  contract = st_cds-contract.
        ENDIF.
      ENDLOOP.
      SORT i_cds BY proforma.
      DELETE ADJACENT DUPLICATES FROM i_cds COMPARING proforma.
*--* Radiobutton for all
    ELSE.
      LOOP AT i_cds INTO st_cds.
        IF st_cds-vbtyp_n = c_m OR st_cds-vbtyp_n = c_n.
          DELETE i_cds WHERE  contract = st_cds-contract AND vbtyp_n = c_u.
        ENDIF.
      ENDLOOP.
    ENDIF.
    i_msg_type[] = i_cds[].
*--*Sort Itab to get lastest Invoice
    SORT i_cds BY proforma ASCENDING erdat DESCENDING.
*--*To get the count of reminders sent
    SORT i_msg_type BY proforma message_date message_time.
*--*Get unique records from first CDS view
    DELETE ADJACENT DUPLICATES FROM i_msg_type COMPARING proforma message_date message_time.
*--*Keep the records where reminder has been sent
    DELETE i_msg_type WHERE message_type IS INITIAL.
  ELSE.
    MESSAGE text-003 TYPE c_i.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_output .
  DATA : lv_count TYPE i,
         lst_cds  TYPE ty_cds.

*--* Build Final Itab
  LOOP AT i_cds INTO st_cds.
    IF st_cds-vbtyp_n = c_n.
      CONTINUE.
    ENDIF.
    IF st_cds-vbtyp_n = c_m OR st_cds-vbtyp_n = c_u.
      st_output-proforma =  st_cds-proforma.
      st_output-payer  = st_cds-payer.
      st_output-payer_name  = st_cds-payer_name.
      st_output-salesrep_name =  st_cds-salesrep_name.
      st_output-contract = st_cds-contract.
      st_output-accounting_clerk = st_cds-accounting_clerk.
      st_output-clear_name  = st_cds-clear_name.
      st_output-proforma_create_date  = st_cds-proforma_create_date.
      st_output-total_due_amount  = st_cds-total_due_amount.
      st_output-pay_value  =  st_cds-pay_value.
      st_output-proforma_currency = st_cds-proforma_currency.
      st_output-last_send_date  = st_cds-last_send_date.
      st_output-payment_term_key = st_cds-payment_term_key.
      st_output-no_of_days =  st_cds-no_of_days.
*--*Due date = Proforma created date in addition to no of days
      st_output-due_date  =  st_cds-proforma_create_date + st_cds-no_of_days.
      st_output-payment_date = st_cds-payment_date.
      st_output-invoice = st_cds-vbeln.
      st_output-sales_org = st_cds-sales_org.
      st_output-po_number = st_cds-po_number.
      st_output-po_date  = st_cds-po_date.
      IF st_cds-proforma_status = c_e.
        st_output-proforma_status = c_yes.
      ELSE.
        st_output-proforma_status = c_no.
      ENDIF.
      IF st_cds-fksto = c_x.
        st_output-fksto = c_yes.
      ELSE.
        st_output-fksto = c_no.
      ENDIF.
      IF rb_wo_in IS NOT INITIAL OR st_cds-vbtyp_n = c_u.
        CLEAR : st_output-payment_doc,st_output-invoice, st_output-fksto.
      ENDIF.
      CLEAR : lv_count.
**Get the number of message types from I_MSG_TYPE and count as reminders
      LOOP AT i_msg_type INTO st_msg_type WHERE proforma = st_output-proforma.
        ADD 1 TO lv_count.
      ENDLOOP.
      st_output-no_of_reminders = lv_count.
      APPEND st_output TO i_output.
      CLEAR st_output.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fcat .
  DATA : lv_col TYPE i VALUE 1.
*--*Build field catalog with FIELD NAME,Field description,Column position and hotspot
  PERFORM f_fcat USING 'PROFORMA' text-006 lv_col c_x.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAYER' text-007 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAYER_NAME' text-008 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'SALESREP_NAME' text-009 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'CONTRACT' text-010 lv_col c_x.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PROFORMA_STATUS' text-029 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'FKSTO' text-033 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'ACCOUNTING_CLERK' text-011 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'CLEAR_NAME' text-012 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PROFORMA_CREATE_DATE' text-013 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'TOTAL_DUE_AMOUNT' text-014 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PROFORMA_CURRENCY' text-015 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'LAST_SEND_DATE' text-017 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAYMENT_TERM_KEY' text-018 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'NO_OF_DAYS' text-019 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'DUE_DATE' text-020 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAY_VALUE' text-021 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAYMENT_DATE' text-022 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PAYMENT_DOC' text-023 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'INVOICE' text-024 lv_col c_x.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'SALES_ORG' text-025 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PO_NUMBER' text-026 lv_col ' '.
  ADD 1 TO lv_col.
  PERFORM f_fcat USING 'PO_DATE' text-027 lv_col ' '.
  ADD 1 TO lv_col.
*  PERFORM f_fcat USING 'PERFORMA_CANCEL_IND' text-028 lv_col ' '.
*  ADD 1 TO lv_col.

  PERFORM f_fcat USING 'NO_OF_REMINDERS' text-016 lv_col ' '.
  CLEAR : lv_col.
*--* ALV Layout
  st_layo-colwidth_optimize = c_x.
  st_layo-zebra = c_x.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_output .
  DATA:lv_save(1) TYPE c VALUE 'U'.   " Added for User specific and Standard Save ED2K913568
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_STATUS' "Add by SCBEZAWADA
      i_grid_title             = text-030   "Advance Payment report
      i_callback_user_command = text-032   "User command
      is_layout               = st_layo
      it_fieldcat             = i_fcat
      it_sort                 = i_sort
      i_default               = 'X'  "NPOLINA , enabled default setting ED2K913568
      i_save                  = lv_save   "NPOLINA added to allow User specific layout ED2K913568
    TABLES
      t_outtab                = i_output
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc NE 0.
    MESSAGE text-031 TYPE c_i.
    LEAVE LIST-PROCESSING.
  ENDIF.
  REFRESH : i_fcat,i_output.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_selection .
  IF rb_wo_in EQ c_x.
    LOOP AT SCREEN.
      IF screen-group1 = 'M3'.
        screen-input = 0.
        MODIFY SCREEN.
        CLEAR : s_inv[].
      ENDIF.
    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0875   text
*      -->P_TEXT_005  text
*      -->P_LV_COL  text
*----------------------------------------------------------------------*
FORM f_fcat  USING    VALUE(fp_field)
                      fp_text
                      fp_lv_col
                      fp_hotspot.
  CONSTANTS : lc_contract TYPE fieldname VALUE 'CONTRACT',
              lc_payer_name TYPE fieldname VALUE 'PAYER_NAME',
              lc_po_number TYPE fieldname VALUE 'PO_NUMBER'.
  st_fcat-fieldname   = fp_field.
  st_fcat-tabname     = c_table.
  st_fcat-seltext_l   = fp_text.
  st_fcat-col_pos     = fp_lv_col.
  st_fcat-hotspot     = fp_hotspot.

*  IF st_fcat-fieldname = lc_payer_name OR st_fcat-fieldname = lc_po_number.
*  st_fcat-lowercase = c_x.
*  ENDIF.
  APPEND st_fcat TO i_fcat.
  CLEAR  st_fcat.
  st_sort-fieldname = lc_contract.
  st_sort-tabname = c_table.
  st_sort-up = c_x.
  APPEND st_sort TO i_sort.
  CLEAR st_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN c_ic1.
*--*Check field clicked on within ALVgrid report
      READ TABLE i_output INTO st_output WITH KEY contract = rs_selfield-value.
      IF sy-subrc EQ 0.
*--*Set parameter ID for transaction VA03
        SET PARAMETER ID c_ktn FIELD st_output-contract.
*--*Call sales transaction VA03
        CALL TRANSACTION c_va43 AND SKIP FIRST SCREEN.
        SET PARAMETER ID c_ktn FIELD  space.
      ELSE.
        READ TABLE i_output INTO st_output WITH KEY proforma = rs_selfield-value.
        IF sy-subrc EQ 0.
*--*Set parameter ID for transaction VF03
          SET PARAMETER ID c_vf FIELD st_output-proforma.
*--*Call Proforma transaction VF03
          CALL TRANSACTION c_vf03 AND SKIP FIRST SCREEN.
          SET PARAMETER ID c_vf FIELD  space.
        ELSE.
          READ TABLE i_output INTO st_output WITH KEY invoice = rs_selfield-value.
          IF sy-subrc EQ 0.
*--*Set parameter ID for transaction VF03
            SET PARAMETER ID c_vf FIELD st_output-invoice.
*--*Call Invoice transaction VF03
            CALL TRANSACTION c_vf03 AND SKIP FIRST SCREEN.
            SET PARAMETER ID c_vf FIELD  space.
          ENDIF.
        ENDIF.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "user_command
*BOC by SCBEZAWADA
FORM SET_STATUS USING RT TYPE SLIS_T_EXTAB.
 SET PF-STATUS 'ZADV_PF_STATUS'.
ENDFORM.
*EOC by SCBEZAWADA
