*&---------------------------------------------------------------------*
*&  Include           ZRARR_SUBSCR_CODE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED1K912234 / ED2K920165
* REFERENCE NO: INC0315954
* DEVELOPER: Bharani
* DATE:  10/07/2020
* DESCRIPTION: Token -Re-class Program optimization
*----------------------------------------------------------------------*

FORM handle_user_command USING i_ucomm TYPE salv_de_function.

  CASE i_ucomm.
    WHEN 'RECLASS'.
      PERFORM do_reclass.
    WHEN 'REFRESH'.
      PERFORM do_refresh.
    WHEN 'ARCHIVE'.
      PERFORM do_archive.
    WHEN 'DELETE'.
      PERFORM do_delete.
  ENDCASE.

ENDFORM.

FORM select_data.

  TYPES: BEGIN OF lty_ts_doc_id,
           vbeln_r TYPE vbeln_va,
           posnr_r TYPE posnr_va,
           vbeln_o TYPE vbeln_va,
           posnr_o TYPE posnr_va,
         END OF lty_ts_doc_id.

  DATA: lv_srcdoc_id       TYPE farr_rai_srcid,
        lt_srcdoc          TYPE STANDARD TABLE OF lty_ts_doc_id,
        lt_origdoc         TYPE STANDARD TABLE OF lty_ts_doc_id,
        lt_reclass_posting TYPE STANDARD TABLE OF lty_ts_doc_id.

  CLEAR: lt_output.

  SELECT pob~zz_vbeln,
         pob~zz_posnr,
         pob~zz_matnr,
         pob~prctr,
         pob~alloc_amt,
         pob~alloc_amt_curk,
         pob~quantity,
         pob~pob_id,
         pob~validate_result,
         pob~company_code,
         map_f~srcdoc_id,
         flf~reported_qty,
         rec~run_date,
         rec~status,
         rec~recon_key
  INTO TABLE @DATA(lt_rar_flf)
  FROM farr_d_pob AS pob
    INNER JOIN farr_d_fulfillmt AS flf
      ON pob~pob_id = flf~pob_id
    INNER JOIN farr_d_mapping_f AS map_f
      ON flf~group_guid = map_f~fulfillment_guid
    INNER JOIN farr_d_recon_key AS rec
      ON rec~recon_key = flf~recon_key AND
         rec~contract_id = pob~contract_id
  WHERE pob~pob_type IN @so_ptype AND "= 'WL-TOKEN' AND
        pob~zz_vbeln IN @so_vbeln AND
        rec~gjahr = @p_gjahr AND
        rec~poper = @p_poper.

  IF sy-subrc = 0.
    " Select plant and profit center data for ZTROs
    lt_srcdoc = VALUE #( FOR a IN lt_rar_flf ( vbeln_r = a-srcdoc_id+14(10) posnr_r = a-srcdoc_id+24(6) ) ).
    SORT lt_srcdoc.
    DELETE ADJACENT DUPLICATES FROM lt_srcdoc COMPARING ALL FIELDS.
    IF lt_srcdoc IS NOT INITIAL.
      SELECT vbeln, posnr, matnr, werks, prctr
        FROM vbap
        FOR ALL ENTRIES IN @lt_srcdoc
        WHERE vbeln = @lt_srcdoc-vbeln_r AND
              posnr = @lt_srcdoc-posnr_r
        INTO TABLE @DATA(lt_rel_data).
    ENDIF.

    " Select plant data for the original sales order
    lt_origdoc = VALUE #( FOR a IN lt_rar_flf ( vbeln_o = a-zz_vbeln posnr_o = a-zz_posnr ) ).
    SORT lt_origdoc.
    DELETE ADJACENT DUPLICATES FROM lt_origdoc COMPARING ALL FIELDS.
    IF lt_origdoc IS NOT INITIAL.
      SELECT vbeln, posnr, pstyv, werks
        FROM vbap
        FOR ALL ENTRIES IN @lt_origdoc
        WHERE vbeln = @lt_origdoc-vbeln_o AND
              posnr = @lt_origdoc-posnr_o
        INTO TABLE @DATA(lt_orig_data).
    ENDIF.

    " Select company code for ZTRO plant
    SELECT werks, vkorg FROM t001w INTO TABLE @DATA(lt_t001w).

    " Determine whether Reclass postings have been made
    lt_reclass_posting = VALUE #( FOR a IN lt_rar_flf ( vbeln_o = a-zz_vbeln posnr_o = a-zz_posnr
                                                        vbeln_r = a-srcdoc_id+14(10) posnr_r = a-srcdoc_id+24(6) ) ).
    SORT lt_reclass_posting.
    DELETE ADJACENT DUPLICATES FROM lt_reclass_posting COMPARING ALL FIELDS.
    IF lt_reclass_posting IS NOT INITIAL.
      " Determine whether Reclass postings have been made
      SELECT contract_id,
             contract_line,
             release_id,
             release_line,
             accounting_doc,
             reclass_date
        FROM zrar_reclass_his
        FOR ALL ENTRIES IN @lt_reclass_posting
        WHERE contract_id = @lt_reclass_posting-vbeln_o AND
              contract_line = @lt_reclass_posting-posnr_o AND
              release_id = @lt_reclass_posting-vbeln_r AND
              release_line = @lt_reclass_posting-posnr_r
         INTO TABLE @DATA(lt_history).
    ENDIF.

    LOOP AT lt_rar_flf INTO DATA(ls_flf).

*      " Select plant and profit center data for ZTROs
      TRY.

          DATA(ls_rel_data) = lt_rel_data[ vbeln = ls_flf-srcdoc_id+14(10) posnr = ls_flf-srcdoc_id+24(6) ].

          " No need to continue if the materials are the same, means the token has expired and has been burnt
          IF ls_flf-zz_matnr = ls_rel_data-matnr.  "lv_mat_rel.
            CONTINUE.
          ENDIF.

          " Move data to output
          INSERT INITIAL LINE INTO TABLE lt_output ASSIGNING FIELD-SYMBOL(<fs_output>).

          <fs_output>-bukrs_ord = ls_flf-company_code.
          <fs_output>-vbeln_ord = ls_flf-zz_vbeln.
          <fs_output>-posnr_ord = ls_flf-zz_posnr.
          <fs_output>-mat_ord = ls_flf-zz_matnr.
          <fs_output>-vbeln_rel = ls_flf-srcdoc_id+14(10).
          <fs_output>-posnr_rel = ls_flf-srcdoc_id+24(6).
          <fs_output>-prctr_ord = ls_flf-prctr.
          <fs_output>-alloc_rar = ls_flf-alloc_amt.
          <fs_output>-alloc_cur = ls_flf-alloc_amt_curk.
          <fs_output>-status_pob_c = ls_flf-status.
          <fs_output>-kwmeng_rel = ls_flf-reported_qty.
          <fs_output>-kwmeng_rar = ls_flf-quantity.
          <fs_output>-recon_key = ls_flf-recon_key.
          <fs_output>-pob_id = ls_flf-pob_id.

          " Calculate reclass amount
          <fs_output>-reclas_amt = ls_flf-alloc_amt / ls_flf-quantity * ls_flf-reported_qty.
          <fs_output>-reclas_cur = ls_flf-alloc_amt_curk.

          " Select plant and profit center data for ZTROs
          <fs_output>-werks_rel = ls_rel_data-werks.
          <fs_output>-prctr_rel = ls_rel_data-prctr.
          <fs_output>-mat_rel = ls_rel_data-matnr.

          " Select plant data for the original sales order
          TRY.
              <fs_output>-pstyv_ord = lt_orig_data[ vbeln = <fs_output>-vbeln_ord posnr = <fs_output>-posnr_ord ]-pstyv.
              <fs_output>-werks_ord = lt_orig_data[ vbeln = <fs_output>-vbeln_ord posnr = <fs_output>-posnr_ord ]-werks.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

          " Select company code for ZTRO plant
          TRY.
              <fs_output>-bukrs_rel = lt_t001w[ werks = <fs_output>-werks_rel ]-vkorg.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

          <fs_output>-status_gl = SWITCH #( ls_flf-status WHEN 'C' THEN 'Posted to GL'
                                                          ELSE 'Not yet posted' ).

          <fs_output>-status_pob = SWITCH #( ls_flf-validate_result WHEN 'S' THEN 'Success'
                                                                    ELSE 'Error' ).

          " Determine whether Reclass postings have been made

          TRY.

              DATA(ls_history) = lt_history[ contract_id = <fs_output>-vbeln_ord contract_line = <fs_output>-posnr_ord
                                             release_id = <fs_output>-vbeln_rel release_line = <fs_output>-posnr_rel ].
              IF ls_history-accounting_doc IS INITIAL OR sy-subrc NE 0.
                <fs_output>-status_rec = 'Not yet reclassed'.
                <fs_output>-status_gl_c = 'N'.
              ELSE.
                <fs_output>-status_rec = 'Reclassed'.
                <fs_output>-created_rel = ls_history-reclass_date.
                <fs_output>-status_gl_c = 'R'.
              ENDIF.
            CATCH cx_sy_itab_line_not_found.
              <fs_output>-status_rec = 'Not yet reclassed'.
              <fs_output>-status_gl_c = 'N'.
          ENDTRY.
          UNASSIGN <fs_output>.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

    ENDLOOP.

    IF p_zero EQ abap_false.
      DELETE lt_output WHERE reclas_amt EQ 0.
    ENDIF.

    " In case report is executed in background - remove already reclassed records
    IF p_disp EQ abap_false.
      DELETE lt_output WHERE status_gl_c = 'R'.
    ENDIF.

  ENDIF.

ENDFORM.

FORM display_data.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = lr_salv_table
    CHANGING
      t_table        = lt_output
  ).

  lr_events = lr_salv_table->get_event( ).
  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.

  lr_salv_table->set_screen_status(
    pfstatus      = 'SALV_STANDARD'
    report        = sy-repid
    set_functions = lr_salv_table->c_functions_all ).

  lr_functions = lr_salv_table->get_functions( ).
  lr_functions->set_all( ).

  lr_selections = lr_salv_table->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  lr_salv_aggrs = lr_salv_table->get_aggregations( ).

  lr_salv_aggrs->add_aggregation(
    EXPORTING
      columnname         = 'RECLAS_AMT'
      aggregation        = if_salv_c_aggregation=>total
  ).

  lr_salv_sorts = lr_salv_table->get_sorts( ).

  lr_salv_sorts->add_sort(
    EXPORTING
      columnname         = 'MAT_REL'
      subtotal           = if_salv_c_bool_sap=>true
  ).

  lr_salv_cols ?= lr_salv_table->get_columns( ).

  lr_salv_cols->get_column( 'KWMENG_REL' )->set_short_text( 'TKN QTY' ).
  lr_salv_cols->get_column( 'KWMENG_RAR' )->set_short_text( 'QTY RAR' ).
  lr_salv_cols->get_column( 'RECLAS_AMT' )->set_short_text( 'TKN AMT' ).
  lr_salv_cols->get_column( 'STATUS_POB' )->set_short_text( 'RAR status' ).
  lr_salv_cols->get_column( 'STATUS_POB' )->set_medium_text( 'RAR status' ).

  lr_salv_cols->get_column( 'STATUS_GL' )->set_short_text( 'GL status' ).

  lr_salv_cols->get_column( 'STATUS_REC' )->set_short_text( 'Reclass' ).
  lr_salv_cols->get_column( 'STATUS_REC' )->set_medium_text( 'Reclass status' ).

  lr_salv_cols->get_column( 'CREATED_REL' )->set_short_text( 'Date' ).
  lr_salv_cols->get_column( 'CREATED_REL' )->set_medium_text( 'Reclass date' ).

  lr_salv_cols->get_column( 'RECLAS_AMT' )->set_currency_column( 'RECLAS_CUR' ).

  " Hide unnecessary columns
  lr_salv_cols->get_column( 'RECON_KEY' )->set_visible( value = if_salv_c_bool_sap=>false ).
  lr_salv_cols->get_column( 'POB_ID' )->set_visible( value = if_salv_c_bool_sap=>false  ).
  lr_salv_cols->get_column( 'STATUS_POB_C' )->set_visible( value = if_salv_c_bool_sap=>false  ).
  lr_salv_cols->get_column( 'STATUS_GL_C' )->set_visible( value = if_salv_c_bool_sap=>false  ).

  lr_salv_cols->set_optimize( 'X' ).

  lr_salv_cols->get_column( 'STATUS_POB' )->set_optimized( value = if_salv_c_bool_sap=>false ).

  lr_salv_table->display( ).

ENDFORM.

FORM prepare_post TABLES lt_data LIKE lt_output.

  DATA: lv_objtype  TYPE awtyp,
        lv_awref    TYPE awkey,
        lv_sysid    TYPE awsys,
        lv_targ_acc TYPE hkont.

  DATA: ls_header      TYPE bapiache09,
        ls_accountgl   TYPE bapiacgl09,
        ls_currencyamt TYPE bapiaccr09,
        ls_extension2  TYPE bapiparex.

  DATA: lt_return      TYPE TABLE OF bapiret2,
        lt_accountgl   TYPE TABLE OF bapiacgl09,
        lt_currencyamt TYPE TABLE OF bapiaccr09,
        lt_extension2  TYPE TABLE OF bapiparex.

  DATA: lv_posnr TYPE posnr_acc,
        lv_aworg TYPE aworg,
        lv_awsys TYPE awsys,
        lv_msg   TYPE bapi_msg.

  DATA: lv_key     TYPE string,
        lv_key_old TYPE string.

  DATA: ls_history TYPE zrar_reclass_his.

  DATA: lt_belnr TYPE TABLE OF rf048_d.

  DATA: lr_reconciliation TYPE REF TO cl_farr_reconciliation.

  CLEAR gt_messages.

  IF lines( lt_data ) GT 0 AND p_disp EQ 'X'.
    WRITE: / lines( lt_output ), 'lines'.
    lt_output_tmp = lt_output.
    CLEAR lt_output.
    INSERT LINES OF lt_data INTO TABLE lt_output.
  ELSEIF p_disp NE 'X'.
    lt_output_tmp = lt_output.
  ENDIF.

  " Fail-safe in case the parameter was not selected on the selection screen
  DELETE lt_output WHERE reclas_amt EQ 0 OR created_rel IS NOT INITIAL.

  SELECT * FROM farr_d_posting
    INTO TABLE @DATA(lt_posting_old)
      FOR ALL ENTRIES IN @lt_output
        WHERE pob_id = @lt_output-pob_id AND recon_key = @lt_output-recon_key AND post_cat = 'RV'.

  DELETE lt_posting_old WHERE shkzg NE 'H'. " Debit entries are not needed

  LOOP AT lt_output INTO DATA(ls_output_tmp).

    ls_output = ls_output_tmp.

    INSERT INITIAL LINE INTO TABLE lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
    <fs_result> = CORRESPONDING #( ls_output_tmp ).

    CLEAR: lv_posnr, lt_acchd, lt_accit, lt_acccr.

    CLEAR: ls_accountgl, lt_accountgl, ls_header, ls_currencyamt, lt_currencyamt.

    READ TABLE lt_posting_old INTO DATA(ls_posting_old) WITH KEY pob_id = ls_output-pob_id recon_key = ls_output-recon_key.

    IF sy-subrc EQ 0.
      " Populate the document type
      TRY.
          ls_header-doc_type = gt_customizing[ param1 = lc_prm_doc_type param2 = ls_output-pstyv_ord ]-low.
        CATCH cx_sy_itab_line_not_found.
          <fs_result>-result = | Missing ZCACONSTANT customizing for DOCUMENT_TYPE parameter for Item Category { ls_output-pstyv_ord } |.
          CONTINUE.
      ENDTRY.

      ls_header-bus_act = 'RFBU'.
      ls_header-comp_code = ls_posting_old-company_code.
* BOC - BTIRUVATHU - INC0315954   - 2020/07/10 - ED1K912234
*      ls_header-doc_date = ls_header-pstng_date = sy-datum.
       ls_header-doc_date = ls_header-pstng_date = p_budat.
* EOC - BTIRUVATHU - INC0315954   - 2020/07/10 - ED1K912234

      ls_header-username = sy-uname.
      ls_header-header_txt = 'Reclass to MPM'.

      " Retrieve the original posting document from FI
      SELECT SINGLE contract_id INTO @DATA(lv_contract_id)
        FROM farr_d_pob WHERE pob_id = @ls_output_tmp-pob_id.

      IF sy-subrc EQ 0.

        lr_reconciliation = cl_farr_reconciliation=>get_instance( ).

        lr_reconciliation->set_attributes(
          EXPORTING
            iv_company_code         = ls_output_tmp-bukrs_ord
            iv_accounting_principle = 'GAAP'
            iv_fiscal_year          = CONV #( ls_output_tmp-recon_key+0(4) )
            iv_posting_period       = CONV #( ls_output_tmp-recon_key+4(3) ) ).

        DATA(lr_cntr_range) = VALUE farr_tt_contract_id_range( ( sign = 'I'
                                                                 option = 'EQ'
                                                                 low = lv_contract_id ) ).

        DATA(lr_rekey_range) = VALUE farr_tt_sel_recon_key( ( sign = 'I'
                                                              option = 'EQ'
                                                              low = ls_output_tmp-recon_key ) ).

        DATA(lr_pcat_range) = VALUE farr_tt_post_cat_range( ( sign = 'I'
                                                              option = 'EQ'
                                                              low = 'RV' ) ).

        lr_reconciliation->recon_key_fi_user(
          EXPORTING
            it_sel_belnr       = VALUE farr_tt_sel_belnr( )
            it_sel_recon_key   = lr_rekey_range
            it_sel_post_cat    = lr_pcat_range
            it_sel_contract    = lr_cntr_range
            iv_max_num_results = 999
          IMPORTING
            et_recon_fi_user   = DATA(lt_post_doc) ).

        TRY.

            DATA(lv_origdoc) = lt_post_doc[ 1 ]-belnr_list+0(10).

          CATCH cx_sy_itab_line_not_found.

            " Posting document not returned - do not continue with reclass
            <fs_result>-result = | Accounting Document not found for POB { ls_output_tmp-pob_id } |.
            CONTINUE.

        ENDTRY.

      ENDIF.

      " Populate the Extension 2 table
      CLEAR: ls_extension2, lt_extension2.
      ls_extension2-valuepart1 = lc_wricef_id_e228.
      ls_extension2-valuepart2 = ls_output_tmp-vbeln_rel && ls_output_tmp-posnr_rel.
      INSERT ls_extension2 INTO TABLE lt_extension2.

      " Source (debit) account
      SELECT SINGLE co~pl_account INTO @DATA(lv_src_acc)
        FROM /1ra/0sd014co AS co INNER JOIN farr_d_mapping AS map
          ON co~srcdoc_id = map~srcdoc_id
      WHERE
        map~pob_id = @ls_output-pob_id AND co~condition_type = @ls_posting_old-condition_type.

      IF sy-subrc NE 0.
        <fs_result>-result = | Source account cannot be determined for POB { ls_output-pob_id }, condition { ls_posting_old-condition_type } |.
        CONTINUE.
      ENDIF.

      ls_accountgl-gl_account = lv_src_acc.

      " Populate the target account
      TRY.
          IF ls_output-pstyv_ord EQ 'ZWOA'.
            " Retrieve the subscription type from the release order
            SELECT SINGLE zzsubtyp FROM vbap INTO @DATA(lv_subtyp)
              WHERE vbeln = @ls_output-vbeln_rel AND posnr = @ls_output-posnr_rel.

            IF sy-subrc EQ 0.
              lv_targ_acc = gt_customizing[ param1 = lc_prm_hkont param2 = ls_output-pstyv_ord low = lv_subtyp ]-high.
            ENDIF.

          ELSE.
            lv_targ_acc = gt_customizing[ param1 = lc_prm_hkont param2 = ls_output-pstyv_ord ]-low.
          ENDIF.

        CATCH cx_sy_itab_line_not_found.
          <fs_result>-result = | Missing ZCACONSTANT customizing for HKONT parameter for Item Category { ls_output-pstyv_ord } |.
          CONTINUE.
      ENDTRY.

      ls_accountgl-itemno_acc = 1.
      ls_accountgl-item_text = 'Reclass to MPM'.
      ls_accountgl-cs_trans_t = 'ZRV'.
      ls_accountgl-comp_code = ls_output-bukrs_ord.
      ls_accountgl-profit_ctr = ls_output-prctr_ord.
      ls_accountgl-material = ls_output-mat_ord.

      IF ls_output-bukrs_ord NE ls_output-bukrs_rel.
        CONCATENATE 'TP' ls_output-bukrs_rel INTO ls_accountgl-trade_id.
      ENDIF.

      ls_accountgl-sales_ord = CONV kdauf( ls_output-vbeln_ord ).
      ls_accountgl-s_ord_item = ls_output-posnr_ord.
      INSERT ls_accountgl INTO TABLE lt_accountgl.

      ls_currencyamt-itemno_acc = 1.
      ls_currencyamt-currency = ls_output-reclas_cur.
      ls_currencyamt-amt_doccur = ls_output-reclas_amt.
      INSERT ls_currencyamt INTO TABLE lt_currencyamt.

      " Second line item
      ls_accountgl-itemno_acc = 2.
      ls_accountgl-gl_account = lv_targ_acc.
      ls_accountgl-comp_code = ls_output-bukrs_rel.
      ls_accountgl-profit_ctr = ls_output-prctr_rel.
      ls_accountgl-material = ls_output-mat_rel.

      IF ls_output-bukrs_ord NE ls_output-bukrs_rel.
        CONCATENATE 'TP' ls_output-bukrs_ord INTO ls_accountgl-trade_id.
      ENDIF.

      INSERT ls_accountgl INTO TABLE lt_accountgl.

      ls_currencyamt-itemno_acc = 2.
      ls_currencyamt-currency = ls_output-reclas_cur.
      ls_currencyamt-amt_doccur = ls_output-reclas_amt * -1.
      INSERT ls_currencyamt INTO TABLE lt_currencyamt.

      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          documentheader = ls_header    " Header
        IMPORTING
          obj_type       = lv_objtype    " Reference procedure
          obj_key        = lv_awref    " Reference key
          obj_sys        = lv_sysid    " Logical system of source document
        TABLES
          accountgl      = lt_accountgl   " G/L account item
          currencyamount = lt_currencyamt   " Currency Items
          extension2     = lt_extension2
          return         = lt_return.

      IF line_exists( lt_return[ type = 'E' ] ). " Error occured

        LOOP AT lt_return INTO DATA(ls_return).

          CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
            EXPORTING
              id         = ls_return-id
              number     = ls_return-number
              textformat = 'ASC'
              message_v1 = ls_return-message_v1
              message_v2 = ls_return-message_v2
              message_v3 = ls_return-message_v3
              message_v4 = ls_return-message_v4
            IMPORTING
              message    = lv_msg.

          lv_msg = lv_msg && |Error: { ls_return-id }({ ls_return-number }), { lv_msg } | && '. '.

        ENDLOOP.

        <fs_result>-result = lv_msg.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        CONTINUE.

      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        CALL FUNCTION 'FI_ACCBELNR_GET'
          TABLES
            t_belnr = lt_belnr.

        IF lines( lt_belnr ) GT 0.

          LOOP AT lt_belnr INTO DATA(ls_belnr).
            lv_msg = | Company Code: { ls_belnr-bukrs }, Number: { ls_belnr-belnr_e }  |.
            ls_message = lv_msg.
            APPEND ls_message TO gt_messages.
          ENDLOOP.

          TRY.

              <fs_result>-accdoc_c1 = lt_belnr[ 1 ]-belnr_e.
              <fs_result>-accdoc_c2 = lt_belnr[ 2 ]-belnr_e.

            CATCH cx_sy_itab_line_not_found.

          ENDTRY.

        ELSE.

          <fs_result>-result = | No accounting documents created for this reclass.  |.

        ENDIF.

        CALL FUNCTION 'FI_ACCBELNR_INIT'.

      ENDIF.

      LOOP AT lt_output_tmp INTO DATA(ls_output_h) WHERE vbeln_ord = ls_output-vbeln_ord AND recon_key = ls_output-recon_key
        AND vbeln_rel = ls_output-vbeln_rel AND mat_rel = ls_output-mat_rel.

        " Update history / log table
        CLEAR: ls_history.
        ls_history-contract_id = ls_output_h-vbeln_ord.
        ls_history-release_id = ls_output_h-vbeln_rel.
        ls_history-contract_line = ls_output_h-posnr_ord.
        ls_history-release_line = ls_output_h-posnr_rel.

        TRY.
            ls_history-gjahr = lt_belnr[ 1 ]-gjahr.
            ls_history-accounting_doc = lt_belnr[ 1 ]-belnr_e.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        ls_history-poper = p_poper.
        ls_history-reclass_date = sy-datum.
        ls_history-username = sy-uname.

        INSERT zrar_reclass_his FROM ls_history.
        COMMIT WORK.

      ENDLOOP.

    ELSE.

      <fs_result>-result = | No posting entries found in FARR_D_POSTING. Please run RAR posting job for period { p_poper }/{ p_gjahr } first. |.

    ENDIF.

    lv_key_old = lv_key.

  ENDLOOP.

  PERFORM do_display_log.

ENDFORM.

FORM do_reclass.

  DATA: lv_answer TYPE char1.

  DATA: lt_rows TYPE salv_t_row.
  DATA: lt_data TYPE TABLE OF ty_output.

  lr_selections = lr_salv_table->get_selections( ).
  lt_rows = lr_selections->get_selected_rows( ).

  IF lines( lt_rows ) = 0.

    MESSAGE 'Please select at least one row' TYPE 'I'.

  ELSE.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Warning!'
        text_question         = 'Are you sure you want to reclass selected records?'
        text_button_1         = 'Yes'
        icon_button_1         = 'ICON_CHECKED'
        text_button_2         = 'No'    " Text on the second pushbutton
        icon_button_2         = 'ICON_INCOMPLETE'
        default_button        = '2'    " Cursor position
        display_cancel_button = ' '    " Button for displaying cancel pushbutton
      IMPORTING
        answer                = lv_answer.

    IF lv_answer = '1'.

      LOOP AT lt_rows INTO DATA(ls_row).
        READ TABLE lt_output INDEX ls_row INTO DATA(ls_output).
        IF ls_output-status_gl_c = 'N'.
          INSERT ls_output INTO TABLE lt_data.
        ENDIF.
      ENDLOOP.

      IF lines( lt_data ) GT 0.

        PERFORM prepare_post TABLES lt_data.
        PERFORM do_refresh.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.

FORM do_refresh.
  PERFORM select_data.
  lr_salv_table->refresh( ).
  lr_salv_table->get_columns( )->set_optimize( value = 'X' ).
ENDFORM.

FORM do_display_log.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = lr_salv_table_log
    CHANGING
      t_table        = lt_result
  ).

  lr_salv_table_log->display( ).

ENDFORM.

FORM do_archive.

  SELECT * FROM  zrar_reclass_his INTO TABLE @DATA(lt_history)
    WHERE gjahr = @p_gjahr AND poper = @p_poper.

  cl_salv_table=>factory(
  IMPORTING
    r_salv_table   = lr_salv_table_h
  CHANGING
    t_table        = lt_history
).

  lr_events = lr_salv_table_h->get_event( ).
  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.

  lr_salv_table_h->set_screen_status(
    pfstatus      = 'SALV_ARCHIVE'
    report        = sy-repid
    set_functions = lr_salv_table->c_functions_all ).

  lr_salv_sorts = lr_salv_table_h->get_sorts( ).

  lr_salv_sorts->add_sort(
    EXPORTING
      columnname         = 'RECLASS_DATE'
  ).

  lr_salv_cols ?= lr_salv_table_h->get_columns( ).
  lr_salv_cols->set_optimize( 'X' ).
  lr_salv_table_h->display( ).

ENDFORM.

FORM do_delete.

  DATA: lv_answer TYPE char1.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = 'Warning!'
      text_question         = 'Do you want to delete reclass log records?'
      text_button_1         = 'Yes'
      icon_button_1         = 'ICON_CHECKED'
      text_button_2         = 'No'    " Text on the second pushbutton
      icon_button_2         = 'ICON_INCOMPLETE'
      default_button        = '2'    " Cursor position
      display_cancel_button = ' '    " Button for displaying cancel pushbutton
    IMPORTING
      answer                = lv_answer.
  IF lv_answer EQ '1'.
    DELETE FROM zrar_reclass_his WHERE gjahr = @p_gjahr AND poper = @p_poper.
    COMMIT WORK.
  ENDIF.
  lr_salv_table_h->refresh( ).
  PERFORM do_refresh.

ENDFORM.

FORM retrieve_customizing.

  SELECT * FROM zcaconstant
    INTO TABLE gt_customizing
      WHERE devid = lc_wricef_id_e228 AND activate = 'X'.

ENDFORM.
