class ZCL_ZSD_CLAIMS_DPC_EXT definition
  public
  inheriting from ZCL_ZSD_CLAIMS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods CLAIMORDSET_CREATE_ENTITY
    redefinition .
  methods CLAIMORDSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSD_CLAIMS_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: lst_head      TYPE bapisdhd1,
          lst_headx     TYPE bapisdhd1x,
          lt_item       TYPE TABLE OF bapisditm,
          lst_item      TYPE bapisditm,
          lt_itemx      TYPE TABLE OF bapisditmx,
          lst_itemx     TYPE bapisditmx,
          lt_partners   TYPE TABLE OF bapiparnr,
          lst_partner   TYPE bapiparnr,
          lt_return     TYPE TABLE OF bapiret2,
          lst_return    TYPE bapiret2,
          lv_salesdoc   TYPE vbeln_va,
          lv_item       TYPE bapisditm-itm_number,
          lv_entity_set TYPE /iwbep/mgw_tech_name.

    DATA : BEGIN OF  lt_orders.
             INCLUDE TYPE zcl_zsd_claims_mpc=>ts_claimhead.
             DATA:   relord TYPE zcl_zsd_claims_mpc=>tt_claimord,
           END OF lt_orders.

    DATA : wa_orders  LIKE lt_orders.

    DATA : wa_input TYPE zcl_zsd_claims_mpc=>ts_claimord.
    DATA : lt_input TYPE zcl_zsd_claims_mpc=>tt_claimord.

    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).

    io_data_provider->read_entry_data( IMPORTING es_data  = wa_orders ).

    CASE lv_entity_set.
      WHEN 'CLAIMHEADSet'.
        LOOP AT  wa_orders-relord INTO wa_input.

          APPEND wa_input   TO  lt_input.

        ENDLOOP.

        IF lt_input IS NOT INITIAL.

          SELECT vk~vbeln,vk~vkorg ,vk~vtweg,vk~spart,vk~augru,
                vb~posnr,vb~matnr,vb~kwmeng,vb~vgbel,vb~vgpos,
                vp~parvw,vp~kunnr ,vp~posnr AS posnv FROM vbak AS vk
            INNER JOIN vbap AS vb
            ON vb~vbeln = vk~vbeln
            INNER JOIN vbpa AS vp
            ON vp~vbeln = vp~vbeln
                  INTO TABLE @DATA(li_data)
            FOR ALL ENTRIES IN @lt_input
            WHERE vk~vbeln = @lt_input-vgbel.
*        AND vb~posnr = @lt_input-vgpos.
          IF sy-subrc EQ 0.
            READ TABLE li_data INTO DATA(lst_data) INDEX 1.

* Populate Header Info
            CLEAR:lst_head.
            lst_head-doc_type = 'ZCLM'.
            lst_head-sales_org = lst_data-vkorg.
            lst_head-division = lst_data-spart.
            lst_head-distr_chan = lst_data-vtweg.
            lst_head-ref_doc = lst_data-vbeln.
            lst_head-ord_reason = wa_input-augru.
            lst_head-refdoc_cat = 'C'.

* Populate Header update structure
            CLEAR:lst_headx.
            lst_headx-updateflag = 'I'.
            lst_headx-doc_type = abap_true.
            lst_headx-sales_org = abap_true.
            lst_headx-division = abap_true.
            lst_headx-distr_chan = abap_true.
            lst_headx-ref_doc = abap_true.
            lst_headx-refdoc_cat = abap_true.
            lst_head-ord_reason = abap_true.

            FREE:lt_partners[].
            FREE:lt_item[].
            FREE:lt_itemx[].
            CLEAR:lv_item.
            LOOP AT li_data INTO DATA(wa_data).
              lv_item = lv_item + 10.
* Populate Item info
              CLEAR:lst_item.
              lst_item-itm_number = lv_item.
              lst_item-material = wa_data-matnr.
              lst_item-target_qty = wa_data-kwmeng.
              lst_item-ref_doc = wa_data-vgbel.
              lst_item-ref_doc_it = wa_data-vgpos.
              APPEND lst_item TO lt_item.

              CLEAR:lst_itemx.
              lst_itemx-itm_number = lst_item-itm_number.
              lst_itemx-material = abap_true.
              lst_itemx-target_qty = abap_true.
              lst_itemx-ref_doc = abap_true.
              lst_itemx-ref_doc_it = abap_true.
              APPEND lst_itemx TO lt_itemx.

* Populate Partners
              CLEAR:lst_partner.
              lst_partner-partn_numb = wa_data-kunnr.
              lst_partner-partn_role = wa_data-parvw.
              APPEND lst_partner TO lt_partners.

              CLEAR:wa_data.
            ENDLOOP.

            CLEAR:lv_salesdoc.
            FREE:lt_return[].

* Create Claim Order (ZCLM)
            CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
              EXPORTING
*               SALESDOCUMENTIN  =
                order_header_in  = lst_head
                order_header_inx = lst_headx
*               TESTRUN          =
              IMPORTING
                salesdocument    = lv_salesdoc
              TABLES
                return           = lt_return
                order_items_in   = lt_item
                order_items_inx  = lt_itemx
                order_partners   = lt_partners.

            IF lv_salesdoc IS NOT INITIAL.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ELSE.

            ENDIF.
          ENDIF.     "JOIN Tables
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD claimordset_create_entity.
*    DATA: lst_head    TYPE bapisdhd1,
*          lst_headx   TYPE bapisdhd1x,
*          lt_item     TYPE TABLE OF bapisditm,
*          lst_item    TYPE bapisditm,
*          lt_itemx    TYPE TABLE OF bapisditmx,
*          lst_itemx   TYPE bapisditmx,
*          lt_partners TYPE TABLE OF bapiparnr,
*          lst_partner TYPE bapiparnr,
*          lt_return   TYPE TABLE OF bapiret2,
*          lst_return  TYPE bapiret2,
*          lv_salesdoc TYPE vbeln_va.
*
*    DATA : wa_input TYPE zcl_zsd_claims_mpc=>ts_claimord.
*
*    io_data_provider->read_entry_data( IMPORTING es_data  = wa_input ).
*
*    SELECT vk~vbeln,vk~vkorg ,vk~vtweg,vk~spart,vk~augru,
*          vb~posnr,vb~matnr,vb~kwmeng,
*          vp~parvw,vp~kunnr ,vp~posnr AS posnv FROM vbak AS vk
*      INNER JOIN vbap AS vb
*      ON vb~vbeln = vk~vbeln
*      INNER JOIN vbpa AS vp
*      ON vp~vbeln = vp~vbeln
*            INTO TABLE @DATA(li_data)
*      WHERE vk~vbeln = @wa_input-vgbel
*        AND vb~posnr = @wa_input-vgpos.
*    IF sy-subrc EQ 0.
*
*
*      READ TABLE li_data INTO DATA(lst_data) INDEX 1.
*
** Populate Header Info
*      CLEAR:lst_head.
*      lst_head-doc_type = 'ZCLM'.
*      lst_head-sales_org = lst_data-vkorg.
*      lst_head-division = lst_data-spart.
*      lst_head-distr_chan = lst_data-vtweg.
*      lst_head-ref_doc = lst_data-vbeln.
*      lst_head-ord_reason = wa_input-augru.
*      lst_head-refdoc_cat = 'C'.
*
** Populate Header update structure
*      CLEAR:lst_headx.
*      lst_headx-updateflag = 'I'.
*      lst_headx-doc_type = abap_true.
*      lst_headx-sales_org = abap_true.
*      lst_headx-division = abap_true.
*      lst_headx-distr_chan = abap_true.
*      lst_headx-ref_doc = abap_true.
*      lst_headx-refdoc_cat = abap_true.
*      lst_head-ord_reason = abap_true.
*
** Populate Item info
*      CLEAR:lst_item.
*      FREE:lt_item[].
*      lst_item-itm_number = '000010'.
*      lst_item-material = lst_data-matnr.
*      lst_item-target_qty = lst_data-kwmeng.
*      lst_item-ref_doc = wa_input-vgbel.
*      lst_item-ref_doc_it = wa_input-vgpos.
*      APPEND lst_item TO lt_item.
*
*      CLEAR:lst_itemx.
*      FREE:lt_itemx[].
*      lst_itemx-itm_number = lst_item-itm_number.
*      lst_itemx-material = abap_true.
*      lst_itemx-target_qty = abap_true.
*      lst_itemx-ref_doc = abap_true.
*      lst_itemx-ref_doc_it = abap_true.
*      APPEND lst_itemx TO lt_itemx.
*
** Populate Partners
*      CLEAR:lst_partner.
*      FREE:lt_partners[].
*      lst_partner-partn_numb = lst_data-kunnr.
*      lst_partner-partn_role = lst_data-parvw.
*      APPEND lst_partner TO lt_partners.
*
*      CLEAR:lv_salesdoc.
*      FREE:lt_return[].
*
** Create Claim Order (ZCLM)
*      CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
*        EXPORTING
**         SALESDOCUMENTIN  =
*          order_header_in  = lst_head
*          order_header_inx = lst_headx
**         TESTRUN          =
*        IMPORTING
*          salesdocument    = lv_salesdoc
*        TABLES
*          return           = lt_return
*          order_items_in   = lt_item
*          order_items_inx  = lt_itemx
*          order_partners   = lt_partners.
*
*      IF lv_salesdoc IS NOT INITIAL.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            wait = abap_true.
*      ENDIF.
*    ENDIF.     "JOIN Tables
  ENDMETHOD.


  method CLAIMORDSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->CLAIMORDSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.
ENDCLASS.
