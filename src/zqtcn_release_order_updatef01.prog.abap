*&---------------------------------------------------------------------*
*&  Include           ZQTCR_RELEASE_ORDER_UPDATEF01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_RELEASE_ORDER_UPDATE                             *
* PROGRAM DESCRIPTION: This program will update the Reject Reason      *
*                      for release orders of Credit Memo for which     *
*                      reason for rejection is updated                 *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 04/05/2021                                          *
* OBJECT ID      : E267                                                *
* TRANSPORT NUMBER(S): ED2K923233                                      *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_REJECTED_CREDITMEMOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_rejected_creditmemos .
  "Fetching Entries from Constant Table
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low
    FROM zcaconstant
    INTO TABLE @DATA(lt_constant)
   WHERE devid    EQ @gc_devid
     AND activate EQ @abap_true.

  IF  sy-subrc    IS INITIAL
  AND lt_constant IS NOT INITIAL.
    CLEAR: gv_auart,
           gv_pstyv,
           gv_augru,
           gv_vkuesch,
           gv_vkuegru,
           gv_rel_ord_typ,
           gv_bwart.
    FREE: gr_auart,
          gr_pstyv,
          gr_augru,
          gr_rel_ord_typ,
          gr_bwart.

    LOOP AT lt_constant
      INTO DATA(wa_constant).
      CASE: wa_constant-param1.
        WHEN: gc_auart.
          gv_auart-sign   = gc_i.
          gv_auart-option = gc_eq.
          gv_auart-low    = wa_constant-low.
          APPEND gv_auart TO gr_auart.
          CLEAR gv_auart.
        WHEN: gc_pstyv.
          gv_pstyv-sign   = gc_i.
          gv_pstyv-option = gc_eq.
          gv_pstyv-low    = wa_constant-low.
          APPEND gv_pstyv TO gr_pstyv.
          CLEAR gv_pstyv.
        WHEN: gc_abgru.
          gv_abgru = wa_constant-low.
        WHEN: gc_augru.
          gv_augru-sign   = gc_i.
          gv_augru-option = gc_eq.
          gv_augru-low    = wa_constant-low.
          APPEND gv_augru TO gr_augru.
          CLEAR gv_augru.
        WHEN: gc_rel_ord_typ.
          gv_rel_ord_typ-sign   = gc_i.
          gv_rel_ord_typ-option = gc_eq.
          gv_rel_ord_typ-low    = wa_constant-low.
          APPEND gv_rel_ord_typ TO gr_rel_ord_typ.
          CLEAR gv_rel_ord_typ.
        WHEN: gc_bwart.
          gv_bwart-sign   = gc_i.
          gv_bwart-option = gc_eq.
          gv_bwart-low    = wa_constant-low.
          APPEND gv_bwart TO gr_bwart.
          CLEAR gv_bwart.
        WHEN: gc_vkuesch.
          gv_vkuesch =  wa_constant-low.
        WHEN: gc_vkuegru.
          gv_vkuegru =  wa_constant-low.
        WHEN: gc_bdclogic.
          gv_bdclogic =  wa_constant-low.
        WHEN: OTHERS.
          "Do Nothing.
      ENDCASE.
    ENDLOOP.
  ENDIF.
  "Fetching credit memo requests for which Rejec Release updated
  FREE i_orders.
  SELECT vbeln,                                    "#EC CI_NO_TRANSFORM
         posnr,
         auart,
         contract_id,
         contract_item,
         release_order,
         rel_ord_item,
         rel_ord_typ,
         aedat,
         pstyv,
         abgru,
         augru
    FROM zqtc_cds_e267
    INTO TABLE @i_orders
   WHERE vbeln IN @s_vbeln
     AND auart IN @gr_auart
     AND rel_ord_typ IN @gr_rel_ord_typ
     AND pstyv IN @gr_pstyv
     AND augru IN @gr_augru
     AND ( erdat IN @s_date OR aedat IN @s_date ).

  IF  sy-subrc  IS INITIAL
  AND i_orders IS NOT INITIAL.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RELEASE_ORDERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_release_orders .
  IF i_orders IS NOT INITIAL.
    "Before proceeding for Canellation of Release order or Contract need to check
    "the entry present in table ZRAR_FULFILL_QTY, even if one release order not
    "present then all the release orders and contract should not cancelled.
    FREE: i_orders2,
          i_display.
    SELECT vbeln,
           posnr,
           bwart
      FROM zrar_fulfill_qty
      INTO TABLE @DATA(li_reclass)
       FOR ALL ENTRIES IN @i_orders
     WHERE ( vbeln EQ @i_orders-release_order
        OR vbeln EQ @i_orders-contract_id )
       AND bwart IN @gr_bwart.
    APPEND LINES OF i_orders TO i_orders2.
    LOOP AT i_orders
      ASSIGNING FIELD-SYMBOL(<fs_orders>).
      READ TABLE li_reclass
        ASSIGNING FIELD-SYMBOL(<fs_reclass>)
        WITH KEY vbeln = <fs_orders>-release_order.
      IF sy-subrc IS NOT INITIAL.
        READ TABLE i_orders2
          ASSIGNING FIELD-SYMBOL(<fs_orders2>)
          WITH KEY contract_id = <fs_orders>-contract_id.
        IF sy-subrc IS INITIAL.
          LOOP AT i_orders2
            ASSIGNING <fs_orders2>
            FROM sy-tabix.
            IF <fs_orders2>-contract_id NE <fs_orders>-contract_id.
              EXIT.
            ELSEIF <fs_orders2>-contract_id EQ <fs_orders>-contract_id.
              MOVE: <fs_orders2>-contract_id     TO gv_display-contract,
                    <fs_orders2>-release_order   TO gv_display-vbeln,
                    gc_error                     TO gv_display-status,
                    text-004                     TO gv_display-message.
              APPEND gv_display TO i_display.
              CLEAR gv_display.
            ENDIF.
          ENDLOOP.
        ENDIF.
        DELETE i_orders WHERE contract_id = <fs_orders>-contract_id.
      ENDIF.
    ENDLOOP.
    SORT i_display
      BY contract vbeln.
    DELETE ADJACENT DUPLICATES FROM i_display
      COMPARING contract vbeln.
    IF i_display IS NOT INITIAL.
      SELECT vbeln,
             posnr
        FROM vbap
        INTO TABLE @DATA(li_items)
         FOR ALL ENTRIES IN @i_display
       WHERE vbeln EQ @i_display-vbeln.
      IF sy-subrc IS INITIAL.
        LOOP AT li_items
          ASSIGNING FIELD-SYMBOL(<fs_items>).
          READ TABLE i_display
           ASSIGNING FIELD-SYMBOL(<fs_display>)
           WITH KEY vbeln = <fs_items>-vbeln.
          IF sy-subrc IS INITIAL.
            <fs_display>-posnr = <fs_items>-posnr.
          ELSEIF sy-subrc IS NOT INITIAL.
            <fs_display>-posnr = <fs_items>-posnr.
            APPEND <fs_display> TO i_display.
            UNASSIGN <fs_display>.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
    IF i_orders IS NOT INITIAL.
*  Fetch sales document and item number from VBAP table
      SELECT vbeln,                                "#EC CI_NO_TRANSFORM
             posnr,  " Sales Document Item
             matnr  " Material number
        FROM vbap   " Sales Document: Item Data
        INTO TABLE @DATA(li_vbap)
         FOR ALL ENTRIES IN @i_orders
        WHERE  vbeln EQ @i_orders-release_order.
*           OR   vbeln EQ @i_orders-contract_id ).   " Contract Excluded from Cancellation Process

      IF  sy-subrc IS INITIAL
      AND li_vbap  IS NOT INITIAL.

        LOOP AT li_vbap INTO DATA(lv_vbap).
          IF gv_bdclogic IS INITIAL.
*           Populate value in order Item
            gv_bapisditm-itm_number = lv_vbap-posnr.
            gv_bapisditm-reason_rej = gv_abgru.
            APPEND gv_bapisditm TO i_bapisditm.
            CLEAR gv_bapisditm.
*           Populate value in order Item Index
            gv_bapisditmx-updateflag = gc_update.
            gv_bapisditmx-itm_number = lv_vbap-posnr.
            gv_bapisditmx-reason_rej = abap_true.
            APPEND gv_bapisditmx TO i_bapisditmx.
            CLEAR gv_bapisditmx.
            CREATE DATA gv_sales_contract_in.
            gv_sales_contract_in->itm_number = lv_vbap-posnr. " Iteme number
            gv_sales_contract_in->canc_proc = gv_vkuesch. " Cancellation Procedure
            gv_sales_contract_in->canc_r_dat = sy-datum. " Contract end date
            gv_sales_contract_in->r_canc_dat = sy-datum.
            gv_sales_contract_in->cancdocdat = sy-datum.
            gv_sales_contract_in->cancreason = gv_vkuegru.
            APPEND gv_sales_contract_in->* TO i_sales_contract_in.
            CLEAR gv_sales_contract_in->*.

            CREATE DATA gv_sales_contract_inx.
            gv_sales_contract_inx->itm_number =  lv_vbap-posnr. " Iteme number
            gv_sales_contract_inx->updateflag = gc_update.
            gv_sales_contract_inx->canc_proc = abap_true. " Cancellation Procedure
            gv_sales_contract_inx->canc_r_dat = abap_true. " Contract end date
            gv_sales_contract_inx->r_canc_dat = abap_true.
            gv_sales_contract_inx->cancdocdat = abap_true.
            gv_sales_contract_inx->cancreason = abap_true.
            APPEND gv_sales_contract_inx->* TO i_sales_contract_inx.
            CLEAR gv_sales_contract_inx->*.
            gv_view-item = 'X'.
            FREE: gv_order,
                  i_item_all.
            APPEND lv_vbap-vbeln TO gv_order.
*      *  BAPI to get details of sales order
            CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
              EXPORTING
                i_bapi_view     = gv_view
              TABLES
                sales_documents = gv_order
                order_items_out = i_item_all.
            MOVE-CORRESPONDING i_item_all TO i_bapisditm.
*           Populate value in order header
            gv_bapisdh1x-updateflag = gc_update.
            READ TABLE i_bapisditm ASSIGNING FIELD-SYMBOL(<ls_itm>) INDEX 1.
            IF sy-subrc EQ 0.
              CLEAR:<ls_itm>-wbs_elem.
              <ls_itm>-reason_rej = gv_abgru.
            ENDIF.
            CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
              EXPORTING
                salesdocument      = lv_vbap-vbeln
                order_header_inx   = gv_bapisdh1x
              TABLES
                return             = i_return
                item_in            = i_bapisditm
                item_inx           = i_bapisditmx
                sales_contract_in  = i_sales_contract_in
                sales_contract_inx = i_sales_contract_inx
              EXCEPTIONS
                incov_not_in_item  = 1
                OTHERS             = 2.
            IF sy-subrc <> 0.
*       Implement suitable error handling here
            ENDIF.
            IF  sy-subrc IS INITIAL
            AND i_return IS NOT INITIAL.
              CLEAR gv_contract.
              READ TABLE i_orders
                INTO DATA(lv_orders)
                WITH KEY release_order = lv_vbap-vbeln.
              IF  sy-subrc IS INITIAL
              AND lv_orders IS NOT INITIAL.
                gv_contract = lv_orders-contract_id.
              ELSEIF sy-subrc IS NOT INITIAL.
                gv_contract = lv_vbap-vbeln.
                CLEAR lv_vbap-vbeln.
              ENDIF.
              READ TABLE i_return
                INTO DATA(wa_return)
                WITH KEY  type = gc_e.
              IF sy-subrc IS NOT INITIAL.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                  EXPORTING
                    wait = space.
                CLEAR gv_display.
                MOVE: gv_contract        TO gv_display-contract,
                      lv_vbap-vbeln      TO gv_display-vbeln,
                      lv_vbap-posnr      TO gv_display-posnr,
                      gc_success         TO gv_display-status.
                IF lv_vbap-vbeln IS NOT INITIAL.
                  gv_display-message = text-002.
                ELSEIF lv_vbap-vbeln IS INITIAL.
                  gv_display-message = text-003.
                ENDIF.
                APPEND gv_display TO i_display.
                CLEAR gv_display.
              ELSEIF sy-subrc IS INITIAL.
                MOVE: gv_contract        TO gv_display-contract,
                      lv_vbap-vbeln      TO gv_display-vbeln,
                      lv_vbap-posnr      TO gv_display-posnr,
                      gc_error           TO gv_display-status,
                      wa_return-message  TO gv_display-message.
                IF gv_contract IS NOT INITIAL.
                  gv_display-message = text-002.
                ELSEIF gv_contract IS INITIAL.
                  gv_display-message = text-003.
                ENDIF.
                APPEND gv_display TO i_display.
                CLEAR gv_display.
              ENDIF.

            ENDIF.

            FREE: i_return,
                  i_bapisditm,
                  i_bapisditmx,
                  i_sales_contract_in,
                  i_sales_contract_inx.

          ELSEIF gv_bdclogic IS NOT INITIAL.
            "This BDC logic is for Temperory only. Will use BAPI only to update
            FREE: i_messtab,
                  i_bdcdata.

            CLEAR: gv_bdcdata,
                   gv_messtab,
                   gv_date.

            CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
              EXPORTING
                input  = sy-datum
              IMPORTING
                output = gv_date.

            PERFORM bdc_dynpro      USING 'SAPMV45A' '0102'.
            PERFORM bdc_field       USING 'BDC_CURSOR'
                                          'VBAK-VBELN'.
            PERFORM bdc_field       USING 'BDC_OKCODE'
                                          '/00'.
            PERFORM bdc_field       USING 'VBAK-VBELN'
                                          lv_vbap-vbeln.
            PERFORM bdc_dynpro      USING 'SAPMV45A' '4001'.
            PERFORM bdc_field       USING 'BDC_OKCODE'
                                          '=ITEM'.
            PERFORM bdc_field       USING 'BDC_CURSOR'
                                          'VBAP-POSNR(01)'.
            PERFORM bdc_dynpro      USING 'SAPMV45A' '4003'.
            PERFORM bdc_field       USING 'BDC_OKCODE'
                                          '=T\03'.
            PERFORM bdc_field       USING 'BDC_CURSOR'
                                          'VBAP-ABGRU'.
            PERFORM bdc_field       USING 'VBAP-ABGRU'
                                          gv_abgru.
            PERFORM bdc_dynpro      USING 'SAPLV45W' '4001'.
            PERFORM bdc_field       USING 'BDC_OKCODE'
                                          '=S\BACK'.
            PERFORM bdc_field       USING 'BDC_CURSOR'
                                          'VEDA-VBELKUE'.
            PERFORM bdc_field       USING 'VEDA-VKUESCH'
                                          gv_vkuesch.
            PERFORM bdc_field       USING 'VEDA-VKUEGRU'
                                          gv_vkuegru.
            PERFORM bdc_field       USING 'VEDA-VEINDAT'
                                          gv_date.
            PERFORM bdc_field       USING 'VEDA-VWUNDAT'
                                          gv_date.
            PERFORM bdc_field       USING 'VEDA-VBEDKUE'
                                          gv_date.
            PERFORM bdc_dynpro      USING 'SAPMV45A' '4001'.
            PERFORM bdc_field       USING 'BDC_OKCODE'
                                          '=SICH'.

            CALL TRANSACTION 'VA02' USING i_bdcdata
                                    MODE 'N'
                                    MESSAGES INTO i_messtab.
            FREE: i_bdcdata.
            CLEAR gv_contract.
            READ TABLE i_orders
              INTO lv_orders
              WITH KEY release_order = lv_vbap-vbeln.
            IF  sy-subrc IS INITIAL
            AND lv_orders IS NOT INITIAL.
              gv_contract = lv_orders-contract_id.
            ELSEIF sy-subrc IS NOT INITIAL.
              gv_contract = lv_vbap-vbeln.
              CLEAR lv_vbap-vbeln.
            ENDIF.
            READ TABLE i_messtab
              INTO gv_messtab
              WITH KEY  msgtyp = 'S'
                        msgid  = 'V1'
                        msgnr  = '311'.
            IF sy-subrc IS INITIAL.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = space.
              CLEAR gv_display.
              MOVE: gv_contract        TO gv_display-contract,
                    lv_vbap-vbeln      TO gv_display-vbeln,
                    lv_vbap-posnr      TO gv_display-posnr,
                    gc_success         TO gv_display-status.
              IF lv_vbap-vbeln IS NOT INITIAL.
                gv_display-message = text-002.
              ELSEIF lv_vbap-vbeln IS INITIAL.
                gv_display-message = text-003.
              ENDIF.
              APPEND gv_display TO i_display.
              CLEAR gv_display.
            ELSEIF sy-subrc IS NOT INITIAL.
              CLEAR gv_messtab.
              READ TABLE i_messtab
                INTO gv_messtab
                WITH KEY  msgtyp = gc_e.
              IF sy-subrc IS INITIAL.
                MOVE: gv_contract        TO gv_display-contract,
                      lv_vbap-vbeln      TO gv_display-vbeln,
                      lv_vbap-posnr      TO gv_display-posnr,
                      gc_error           TO gv_display-status,
                      gv_messtab-msgv1   TO gv_display-message.
                APPEND gv_display TO i_display.
                CLEAR gv_display.
              ELSEIF sy-subrc IS NOT INITIAL.
                READ TABLE i_messtab
                  INTO gv_messtab
                  WITH KEY  msgtyp = 'S'.
                IF sy-subrc IS INITIAL.
                  MOVE: gv_contract        TO gv_display-contract,
                        lv_vbap-vbeln      TO gv_display-vbeln,
                        lv_vbap-posnr      TO gv_display-posnr,
                        gc_error           TO gv_display-status,
                        gv_messtab-msgv1   TO gv_display-message.
                  APPEND gv_display TO i_display.
                  CLEAR gv_display.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
*Update ZCAINTERFACE table
  CLEAR gv_zcainterface.
  MOVE: gc_devid    TO gv_zcainterface-devid,
        gc_runtime  TO gv_zcainterface-param1,
        sy-datum    TO gv_zcainterface-lrdat,
        sy-uzeit    TO gv_zcainterface-lrtime.
  MODIFY zcainterface
    FROM gv_zcainterface.
ENDFORM.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR gv_bdcdata.
  gv_bdcdata-program  = program.
  gv_bdcdata-dynpro   = dynpro.
  gv_bdcdata-dynbegin = 'X'.
  APPEND gv_bdcdata TO i_bdcdata.
  CLEAR gv_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  CLEAR gv_bdcdata.
  gv_bdcdata-fnam = fnam.
  gv_bdcdata-fval = fval.
  APPEND gv_bdcdata TO i_bdcdata.
  CLEAR gv_bdcdata.
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

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gv_alv
        CHANGING
          t_table      = i_display.
    CATCH cx_salv_msg .
  ENDTRY.
  gv_func = gv_alv->get_functions( ).
  DATA(ls_cols) = gv_alv->get_columns( ).
  ls_cols->set_optimize( 'X' ).
  TRY.
      DATA(ls_col1) = ls_cols->get_column( 'CONTRACT' ).
      DATA(ls_col2) = ls_cols->get_column( 'VBELN' ).
      DATA(ls_col3) = ls_cols->get_column( 'POSNR' ).
      DATA(ls_col4) = ls_cols->get_column( 'STATUS' ).
      DATA(ls_col5) = ls_cols->get_column( 'MESSAGE' ).
**************************************************
      ls_col1->set_long_text('CONTRACT NUMBER').
      ls_col1->set_medium_text('CONTRACT NO.').
      ls_col1->set_short_text('CONTRACT').
*************************************************
**************************************************
      ls_col2->set_long_text('RELEASE ORDER').
      ls_col2->set_medium_text('RELEASE ORDER').
      ls_col2->set_short_text('ORDER').
*************************************************
*************************************************
      ls_col3->set_long_text('ITEM NUMBER').
      ls_col3->set_medium_text('ITEM NUMBER ').
      ls_col3->set_short_text('ITEM').
*************************************************
*************************************************
      ls_col4->set_long_text('STATUS OF REJECTION UPDATE').
      ls_col4->set_medium_text('STATUS OF REJECTION').
      ls_col4->set_short_text('STATUS').
*************************************************
*************************************************
      ls_col5->set_long_text('REMARKS').
      ls_col5->set_medium_text('REMARKS ').
      ls_col5->set_short_text('REMARKS').
    CATCH cx_salv_not_found .
  ENDTRY.
************************************************
*************************************************
  "To display the toolbar
  CALL METHOD gv_func->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  gv_alv->display( ).

ENDFORM.
