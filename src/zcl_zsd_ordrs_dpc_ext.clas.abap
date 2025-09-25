class ZCL_ZSD_ORDRS_DPC_EXT definition
  public
  inheriting from ZCL_ZSD_ORDRS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods BILLINGBLOCKSET_GET_ENTITY
    redefinition .
  methods BILLINGBLOCKSET_GET_ENTITYSET
    redefinition .
  methods BILLINGBLOCKSET_UPDATE_ENTITY
    redefinition .
  methods CREDITSET_GET_ENTITY
    redefinition .
  methods CREDITSET_GET_ENTITYSET
    redefinition .
  methods CREDITSET_UPDATE_ENTITY
    redefinition .
  methods DELIVERYBLOCKSET_GET_ENTITY
    redefinition .
  methods DELIVERYBLOCKSET_GET_ENTITYSET
    redefinition .
  methods DELIVERYBLOCKSET_UPDATE_ENTITY
    redefinition .
  methods DELVHEADSET_GET_ENTITY
    redefinition .
  methods DELVHEADSET_GET_ENTITYSET
    redefinition .
  methods DELVITEMSET_GET_ENTITYSET
    redefinition .
  methods DSOSET_GET_ENTITYSET
    redefinition .
*  methods INCITEMSET_GET_ENTITYSET
*    redefinition .
  methods INCOMPLETESET_GET_ENTITYSET
    redefinition .
  methods INCTYPESET_GET_ENTITYSET
    redefinition .
  methods ITEMBILLSET_GET_ENTITYSET
    redefinition .
  methods ITEMCREDITSET_GET_ENTITYSET
    redefinition .
  methods ITEMDELVSET_GET_ENTITYSET
    redefinition .
  methods ITEMINCSET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods TIMESET_GET_ENTITYSET
    redefinition .
  methods USERACCESSSET_GET_ENTITY
    redefinition .
  methods USERACCESSSET_GET_ENTITYSET
    redefinition .
  methods USERIDSET_GET_ENTITY
    redefinition .
  methods USERIDSET_GET_ENTITYSET
    redefinition .
  methods ZSD_ORDRSSET_GET_ENTITYSET
    redefinition .
  methods ZCACONSTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSD_ORDRS_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: lst_bapisdh1x TYPE bapisdh1x.
    DATA: lst_bapisdh1 TYPE bapisdh1,
          lv_vbeln     TYPE vbeln.
    DATA:lt_return TYPE TABLE OF bapiret2.
    DATA:lt_return2 TYPE TABLE OF bapiret2.


    DATA : BEGIN OF  li_orders.
             INCLUDE TYPE zcl_zsd_ordrs_mpc=>ts_delvhead.
             DATA: np_vbeln TYPE zcl_zsd_ordrs_mpc=>tt_delvitem,
           END OF li_orders.


    DATA:        lv_cnt     TYPE i.
    DATA : lst_orders    LIKE  li_orders,
          lst_orders2    LIKE  li_orders,
           lv_entity_set TYPE /iwbep/mgw_tech_name.

    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).

* Import Input
    io_data_provider->read_entry_data( IMPORTING es_data  = lst_orders ).

    CASE lv_entity_set.
      WHEN 'DelvHeadSet'.
        LOOP AT  lst_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<lst_input>).
* BAPI Header
          lst_bapisdh1-dlv_block = abap_false.
          lst_bapisdh1x-dlv_block = abap_true.
          lst_bapisdh1x-updateflag = 'U'.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_input>-vbeln
            IMPORTING
              output = lv_vbeln.

          FREE:lt_return[].
          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = lv_vbeln
              order_header_in  = lst_bapisdh1
              order_header_inx = lst_bapisdh1x
            TABLES
              return           = lt_return.

          CLEAR:lv_cnt.
          LOOP AT lt_return INTO DATA(lst_return) WHERE type = 'E' OR type = 'A'.
            lv_cnt = lv_cnt + 1.
            CASE lv_cnt.
              WHEN 1.
                <lst_input>-msgty = 'Error'.
                <lst_input>-msg1 = lst_return-message.
                lst_orders-message = <lst_input>-msg1.
              WHEN 2.
                <lst_input>-msg2 = lst_return-message_v1.
              WHEN 3.
                <lst_input>-msg3 = lst_return-message_v2.
              WHEN 4.
                <lst_input>-msg4 = lst_return-message_v3.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.


          IF <lst_input>-msgty IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
             EXPORTING
               WAIT          = abap_true.
*             IMPORTING
*               RETURN        =            .

            <lst_input>-msgty = 'Success'.
            <lst_input>-msg1 = 'Delivery block released Successfully;'.


            SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_in)
              WHERE vbeln = @lv_vbeln.
            IF sy-subrc EQ 0.
              <lst_input>-msg2 = 'Order is Incomplete' .

            ENDIF.

            SELECT SINGLE faksk FROM vbak INTO @DATA(lv_faksk)
              WHERE vbeln = @lv_vbeln.
            IF sy-subrc EQ 0 AND lv_faksk IS NOT INITIAL.
              <lst_input>-msg3 = 'Order has Billing Block' .
            ENDIF.

          ENDIF.
*          IF lt_return IS NOT INITIAL.
*            me->mo_context->get_message_container( )->add_messages_from_bapi(
*                       EXPORTING it_bapi_messages = lt_return ).
*
*            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*              EXPORTING
*                message_container = me->mo_context->get_message_container( ).
*
*          ENDIF.

*        append <lst_input> to lst_orders-np_vbeln.
*        append <lst_input> to lst_orders2-np_vbeln.
*        append <lst_input> to lst_orders2-np_vbeln.
        ENDLOOP.
*lst_orders-np_vbeln = lst_orders2-np_vbeln.
        copy_data_to_ref(
          EXPORTING
              is_data = lst_orders
          CHANGING
              cr_data = er_deep_entity ).


      WHEN 'BillHeadSet'.
        LOOP AT  lst_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<lst_binput>).
* BAPI Header
          CLEAR:lst_bapisdh1,
                lst_bapisdh1x.
          lst_bapisdh1-bill_block = abap_false.
          lst_bapisdh1x-bill_block = abap_true.
          lst_bapisdh1x-updateflag = 'U'.
          CLEAR:lv_vbeln.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_binput>-vbeln
            IMPORTING
              output = lv_vbeln.

          FREE:lt_return[].
          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = lv_vbeln
              order_header_in  = lst_bapisdh1
              order_header_inx = lst_bapisdh1x
            TABLES
              return           = lt_return.

          CLEAR:lv_cnt.
          LOOP AT lt_return INTO DATA(lst_breturn) WHERE type = 'E' OR type = 'A'.
            lv_cnt = lv_cnt + 1.
            CASE lv_cnt.
              WHEN 1.
                <lst_binput>-msgty = 'Error'.
                <lst_binput>-msg1 = lst_breturn-message.
                lst_orders-message = <lst_binput>-msg1.
              WHEN 2.
                <lst_binput>-msg2 = lst_breturn-message_v1.
              WHEN 3.
                <lst_binput>-msg3 = lst_breturn-message_v2.
              WHEN 4.
                <lst_input>-msg4 = lst_breturn-message_v3.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.


          IF <lst_binput>-msgty IS INITIAL.
*            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*             EXPORTING
*               WAIT          =
*             IMPORTING
*               RETURN        =
            .

            <lst_binput>-msgty = 'Success'.
            <lst_binput>-msg1 = 'Billing block released Successfully.'.


            SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_inb)
              WHERE vbeln = @lv_vbeln.
            IF sy-subrc EQ 0.
              <lst_binput>-msg2 = 'Order Incomplete' .

            ENDIF.

            SELECT SINGLE lifsk FROM vbak INTO @DATA(lv_lifsk)
              WHERE vbeln = @lv_vbeln.
            IF sy-subrc EQ 0 AND lv_lifsk IS NOT INITIAL.
              <lst_binput>-msg3 = 'Order has Delivery Block.' .
            ENDIF.

          ENDIF.
*          IF lt_return IS NOT INITIAL.
*            me->mo_context->get_message_container( )->add_messages_from_bapi(
*                       EXPORTING it_bapi_messages = lt_return ).
*
*            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*              EXPORTING
*                message_container = me->mo_context->get_message_container( ).
*
*          ENDIF.

        ENDLOOP.

        copy_data_to_ref(
          EXPORTING
              is_data = lst_orders
          CHANGING
              cr_data = er_deep_entity ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD billingblockset_get_entity.
*    DATA:lv_vbeln TYPE vbeln.
*    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
*    IF sy-subrc EQ 0.
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = lst_key-value
*        IMPORTING
*          output = lv_vbeln.
*
*      SELECT SINGLE vbeln  FROM vbap INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = lv_vbeln.
*    ENDIF.
  ENDMETHOD.


  METHOD billingblockset_get_entityset.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_faksk   TYPE char02,
*          lv_lifsk   TYPE char02,
          lv_overall TYPE char02,
          lv_credit  TYPE char02,
          lv_incompl TYPE char02,
          lv_vbeln   TYPE vbeln,
          lv_auart   TYPE auart,
          lv_stdate  TYPE erdat,
          lv_endate  TYPE erdat,
          lt_date    TYPE date_t_range,
          ls_date    TYPE date_range,
          lv_posnr   TYPE posnr,

          lr_kunnr   TYPE range_kunnr_tab,
          lst_kunnr  TYPE range_kunnr_wa,

          lv_kunnr   TYPE kunnr.

    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_billingblock.
    DATA:it_orders2 TYPE zcl_zsd_ordrs_mpc=>tt_billingblock.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_billingblock.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.

    DATA:lr_vbeln  TYPE edm_vbeln_range_tt,
         lst_vbeln TYPE edm_vbeln_range,
         lr_auart  TYPE tms_t_auart_range,
         lst_auart TYPE tms_s_auart_range.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc1_bp   TYPE sy-tcode VALUE 'BP',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN=',
              lc_bp    TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=BP%20BUS_JOEL_MAIN-CHANGE_NUMBER='.

      DATA lv_uname TYPE sy-uname.

    lv_uname = sy-uname.

    DATA:lr_vkorg TYPE sd_vkorg_ranges.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.
    .


    CASE iv_entity_set_name.
      WHEN 'BillingBlockSet'.

        LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
          LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
            CASE <ls_filter>-property.
              WHEN 'Faksk'.
                lv_faksk = <ls_filter_opt>-low.
              WHEN 'Vbeln'.
                lv_vbeln = <ls_filter_opt>-low.
                IF lv_vbeln NE 0 AND lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
                  lst_vbeln-sign = 'I'.
                  lst_vbeln-option = 'EQ'.

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lv_vbeln
                    IMPORTING
                      output = lv_vbeln.

                  lst_vbeln-low = lv_vbeln.
                  APPEND lst_vbeln TO lr_vbeln.
                ENDIF.
              WHEN 'Posnr'.
                lv_posnr = <ls_filter_opt>-low.
              WHEN 'Kunnr'.
                lv_kunnr = <ls_filter_opt>-low.
                IF lv_kunnr NE 0 AND lv_kunnr NE 'null' AND lv_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lv_kunnr
                    IMPORTING
                      output = lv_kunnr.

                  lst_kunnr-sign = 'I'.
                  lst_kunnr-option = 'EQ'.
                  lst_kunnr-low = lv_kunnr.
                  APPEND lst_kunnr TO lr_kunnr.
                ENDIF.
              WHEN 'Auart'.
                lv_auart = <ls_filter_opt>-low.
                IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
                  lst_auart-sign = 'I'.
                  lst_auart-option = 'EQ'.
                  lst_auart-low = lv_auart.
                  APPEND lst_auart TO lr_auart.
                ENDIF.
              WHEN 'Stdate'.
                IF <ls_filter_opt>-low IS NOT INITIAL.
                  lv_stdate = <ls_filter_opt>-low+0(4) &&
                  <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
                ENDIF.
              WHEN 'Endate'.
                IF <ls_filter_opt>-low IS NOT INITIAL.
                  lv_endate = <ls_filter_opt>-low+0(4) &&
                  <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
                ENDIF.
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

        IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
          ls_date-low = lv_stdate.
          ls_date-high = lv_endate.
          ls_date-option = 'BT'.
          ls_date-sign = 'I'.
          APPEND ls_date TO lt_date.
        ENDIF.

        IF  lv_faksk ='RE' .
          REFRESH:lr_vbeln[].

        ENDIF.


        IF it_orders[] IS INITIAL.
* Fetch all records

          SELECT vbak~vbeln vbak~erdat vbak~kunnr vbak~vkorg vbak~vtweg vbak~spart
                 vbak~auart vbak~faksk vbak~vkbur vbak~vbtyp
                 vbak~erzet vbak~ernam vbak~netwr vbak~waerk
                 vbap~posnr vbap~matnr   kna1~name1 "FETCHING DATA WITH INNER JOIN ON VBELN
                    INTO CORRESPONDING FIELDS OF TABLE it_orders
                 FROM vbak
                 INNER JOIN vbap ON
                 vbak~vbeln = vbap~vbeln
                 INNER JOIN kna1 ON
                 vbak~kunnr = kna1~kunnr
            WHERE
*            ( faksk NE space ) AND
             vbak~vbeln IN lr_vbeln
             AND vbak~auart IN lr_auart
             AND vbak~kunnr IN lr_kunnr
             AND vbak~erdat IN lt_date
             AND vbak~vkorg IN lr_vkorg.
          IF sy-subrc EQ 0.
            DATA(li_ord2) = it_orders[].
            SORT li_ord2 BY kunnr.
            DELETE ADJACENT DUPLICATES FROM li_ord2 COMPARING kunnr.
            SELECT kunnr,vkorg,vtweg,spart,faksd
              FROM knvv INTO TABLE  @DATA(li_knvv)
              FOR ALL ENTRIES IN @li_ord2[]
              WHERE kunnr = @li_ord2-kunnr
                AND faksd NE @space.
            IF sy-subrc EQ 0.
              SORT li_knvv BY kunnr vkorg vtweg spart.
            ENDIF.
          ENDIF.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.

      SELECT faksp,vtext FROM tvfst
        INTO TABLE @DATA(li_tvfs)
        WHERE spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_tvfs BY faksp.

      ENDIF.

    ENDIF.

    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

    LOOP AT  it_orders INTO wa_orders.

      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart = wa_orders-auart BINARY SEARCH.
      IF sy-subrc EQ 0.
        wa_orders-ordtyp = wa_orders-auart && '-' && ls_tvak-bezei.
      ENDIF.


      CASE wa_orders-vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.

      CONCATENATE 'http://' lv_host ':' lv_port lc_bp wa_orders-kunnr INTO wa_orders-bplink.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      READ TABLE li_tvfs INTO DATA(ls_tvfs) WITH KEY faksp = wa_orders-faksk BINARY SEARCH.
      IF sy-subrc EQ 0.
        wa_orders-faksk = wa_orders-faksk && '-' && ls_tvfs-vtext.
      ENDIF.

      READ TABLE li_knvv INTO DATA(lst_knvv) WITH KEY kunnr = wa_orders-kunnr vkorg = wa_orders-vkorg
                               vtweg = wa_orders-vtweg spart = wa_orders-spart BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR:ls_tvfs.
        READ TABLE li_tvfs INTO ls_tvfs WITH KEY faksp = lst_knvv-faksd BINARY SEARCH.
        IF sy-subrc EQ 0.
          wa_orders-faksd = lst_knvv-faksd && '-' && ls_tvfs-vtext.
        ENDIF.
      ENDIF.

      wa_orders-prodh = wa_orders-erdat+0(6).
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
    DELETE et_entityset WHERE faksk IS INITIAL AND faksd IS INITIAL.

  ENDMETHOD.


  METHOD billingblockset_update_entity.
    DATA: ls_message           TYPE          scx_t100key.
    DATA:lv_vbeln TYPE vbeln,
         lv_posnr TYPE posnr,
         lv_msgty TYPE msgty,
         lst_ret  TYPE bapiret2,
         lv_msg   TYPE msgv1.

    DATA: lo_message_container TYPE REF TO /iwbep/if_message_container.

    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_billingblock.
    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
*    IF sy-subrc EQ 0.
*      wa_orders-message = lst_key-value.
*      wa_orders-vbeln = lst_key-value.
*      er_entity = wa_orders.
*
*      lv_vbeln = wa_orders-vbeln.
*      CALL FUNCTION 'ZQTC_RELEASE_BLOCK'
*        EXPORTING
*          im_vbeln = lv_vbeln
*          im_posnr = lv_posnr
**         IM_LIFSK =
*          im_faksk = 'X'
**         IM_CMGST =
*        CHANGING
*          msgty    = lv_msgty
*          message  = lv_msg.
*
*      lst_ret-message = lv_msg.
*
*      CALL METHOD me->/iwbep/if_mgw_conv_srv_runtime~get_message_container
*        RECEIVING
*          ro_message_container = lo_message_container.
*
*      IF  lv_msgty = 'S'.
*        lv_msg = 'Billing Block Released'.
*        SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_in)
*          WHERE vbeln = @lv_vbeln.
*        IF sy-subrc EQ 0.
*          CONCATENATE lv_msg 'but Order is Incomplete ' INTO lv_msg SEPARATED BY space.
*
*        ENDIF.
*
*        SELECT SINGLE lifsk FROM vbak INTO @DATA(lv_lifsk)
*          WHERE vbeln = @lv_vbeln.
*        IF sy-subrc EQ 0 AND lv_lifsk IS NOT INITIAL.
*          IF lv_vbeln_in IS NOT INITIAL.
*            CONCATENATE lv_msg 'and has Delivery Block ' INTO lv_msg SEPARATED BY space.
**            CONCATENATE lv_msg 'and has Delivery Block ' INTO lv_msg SEPARATED BY space.
*          ELSE.
*            CONCATENATE lv_msg 'but Order has Delivery Block' INTO lv_msg SEPARATED BY space.
*          ENDIF.
*          CLEAR:lv_lifsk.
*        ENDIF.
*
*
*      ENDIF.
*
*      lst_ret-message = lv_msg.
*      CALL METHOD lo_message_container->add_message_from_bapi(
*        EXPORTING
*          is_bapi_message           = lst_ret
*          iv_entity_type            = iv_entity_set_name
**         it_key_tab                = VALUE /iwbep/t_mgw_name_value_pair( ( name = 'KEY1' value = er_entity-key1 ) )
*          iv_add_to_response_header = abap_true
*          iv_message_target         = CONV string( lst_ret-message ) ).
*
*
*    ENDIF.

  ENDMETHOD.


  METHOD creditset_get_entity.
*    DATA:lv_vbeln TYPE vbeln.
*    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
*    IF sy-subrc EQ 0.
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = lst_key-value
*        IMPORTING
*          output = lv_vbeln.
*
*      SELECT SINGLE vbeln  FROM vbap INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = lv_vbeln.
*    ENDIF.
  ENDMETHOD.


  METHOD creditset_get_entityset.
    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA:
      lv_cmgst   TYPE char02,
      lv_overall TYPE char02,
      lv_credit  TYPE char02,
      lv_incompl TYPE char02,
      lv_vbeln   TYPE vbeln,
      lv_posnr   TYPE posnr,
      lv_stdate  TYPE erdat,
      lv_endate  TYPE erdat,
      lv_auart   TYPE auart.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_credit.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_credit.
    DATA:wa_orders2 TYPE zcl_zsd_ordrs_mpc=>ts_credit.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA:lr_vbeln  TYPE edm_vbeln_range_tt,
         lst_vbeln TYPE edm_vbeln_range,
         lr_auart  TYPE tms_t_auart_range,
         lst_auart TYPE tms_s_auart_range.
    DATA :lv_host TYPE string.
    DATA :lv_port TYPE string,
          lt_date TYPE date_t_range,
          ls_date TYPE date_range.
    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc1_vkm3 TYPE sy-tcode VALUE 'VKM3',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN=',
              lc_vkm3  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VKM3%20VBELN-LOW='.

    DATA lv_uname TYPE sy-uname.

    lv_uname = sy-uname.

    DATA:lr_vkorg TYPE sd_vkorg_ranges.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    CASE iv_entity_set_name.
      WHEN 'CreditSet'.

        LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
          LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
            CASE <ls_filter>-property.
              WHEN 'Cmgst'.
                lv_cmgst = <ls_filter_opt>-low.
              WHEN 'Vbeln'.
                lv_vbeln = <ls_filter_opt>-low.
                IF lv_vbeln NE 0 AND lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
                  lst_vbeln-sign = 'I'.
                  lst_vbeln-option = 'EQ'.
                  lst_vbeln-low = lv_vbeln.
                  APPEND lst_vbeln TO lr_vbeln.
                ENDIF.
              WHEN 'Posnr'.
                lv_posnr = <ls_filter_opt>-low.
              WHEN 'Auart'.
                lv_auart = <ls_filter_opt>-low.
                IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
                  lst_auart-sign = 'I'.
                  lst_auart-option = 'EQ'.
                  lst_auart-low = lv_auart.
                  APPEND lst_auart TO lr_auart.
                ENDIF.
              WHEN 'Stdate'.
                lv_stdate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
              WHEN 'Endate'.
                lv_endate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

        IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
          ls_date-low = lv_stdate.
          ls_date-high = lv_endate.
          ls_date-option = 'BT'.
          ls_date-sign = 'I'.
          APPEND ls_date TO lt_date.
        ENDIF.


        IF lv_vbeln IS NOT INITIAL AND lv_cmgst IS NOT  INITIAL .

*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lv_vbeln
*            IMPORTING
*              output = lv_vbeln.
*
*
*          UPDATE vbuk SET cmgst = ''
*               WHERE vbeln = lv_vbeln.
**          IF  lv_posnr IS NOT INITIAL.
**            UPDATE vbuk SET cmgst = ''
**              WHERE vbeln = lv_vbeln AND posnr = lv_posnr.
**          ENDIF.
*          COMMIT WORK.
        ENDIF.


        IF  lv_cmgst ='RE' .
          REFRESH:lr_vbeln[].
        ENDIF.

        IF it_orders[] IS INITIAL.
* Fetch all records
          SELECT * FROM zsd_ordrs
        INTO CORRESPONDING FIELDS OF TABLE it_orders
         WHERE  ( cmgst = 'B' OR cmgst = 'C' )
            AND vbeln IN lr_vbeln
            AND auart IN lr_auart
            AND erdat IN lt_date
            AND vkorg in lr_vkorg.
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.
    ENDIF.

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

    SORT it_orders[] BY vbeln posnr.


    IF it_orders[] IS NOT INITIAL.
*      SELECT vbeln, vbtyp FROM vbak INTO TABLE @DATA(li_vbak)
*     FOR ALL ENTRIES IN @it_orders
*     WHERE vbeln = @it_orders-vbeln.
*      IF sy-subrc EQ 0.
*        SORT li_vbak BY vbeln.
*      ENDIF.

    ENDIF.

    LOOP AT  it_orders INTO wa_orders.

*     wa_orders2-vbeln = wa_orders-vbeln.

*      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart = wa_orders-auart BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        wa_orders-ordtyp = ls_tvak-bezei.
*      ENDIF.
*
*      READ TABLE li_vbak INTO DATA(ls_vbak) WITH KEY vbeln = wa_orders-vbeln BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        wa_orders-ordtyp = ls_tvak-bezei.
*      ENDIF.

*      CASE ls_vbak-vbtyp.
*        WHEN 'A'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'B'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'C'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'G'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.
*
*        WHEN 'K'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'L'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'OTHERS'.
*
*      ENDCASE.

      CONCATENATE 'http://' lv_host ':' lv_port lc_vkm3 wa_orders-vbeln INTO wa_orders-linkref .

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      wa_orders-prodh = wa_orders-erdat+0(6).


*      APPEND wa_orders TO et_entityset.
      COLLECT wa_orders INTO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .
  ENDMETHOD.


  METHOD creditset_update_entity.
    DATA: ls_message           TYPE          scx_t100key.
    DATA:lv_vbeln TYPE vbeln,
         lv_posnr TYPE posnr,
         lv_msgty TYPE msgty,
         lst_ret  TYPE bapiret2,
         lv_msg   TYPE msgv1.

    DATA: lo_message_container TYPE REF TO /iwbep/if_message_container.

    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_credit.
    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
    IF sy-subrc EQ 0.
      wa_orders-message = lst_key-value.
      wa_orders-vbeln = lst_key-value.
      er_entity = wa_orders.

      lv_vbeln = wa_orders-vbeln.
*      CALL FUNCTION 'ZQTC_RELEASE_BLOCK'
*        EXPORTING
*          im_vbeln = lv_vbeln
*          im_posnr = lv_posnr
*          IM_CMGST = 'X'
*        CHANGING
*          msgty    = lv_msgty
*          message  = lv_msg.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_vbeln
        IMPORTING
          output = lv_vbeln.


*      UPDATE vbuk SET cmgst = ''
*           WHERE vbeln = lv_vbeln.
*      IF sy-subrc EQ 0.
*        COMMIT WORK.
*        lv_msg = 'Credit Block Released'.
*        lst_ret-message = lv_msg.
*
*        CALL METHOD me->/iwbep/if_mgw_conv_srv_runtime~get_message_container
*          RECEIVING
*            ro_message_container = lo_message_container.
*
*        IF  lv_msgty = 'S'.
*          lv_msg = 'Credit Block Released'.
*
*        ENDIF.
*      ELSE.
*        lv_msg = 'Failed to release Credit Block '.
*      ENDIF.

*      lst_ret-message = lv_msg.
*      CALL METHOD lo_message_container->add_message_from_bapi(
*        EXPORTING
*          is_bapi_message           = lst_ret
*          iv_entity_type            = iv_entity_set_name
**         it_key_tab                = VALUE /iwbep/t_mgw_name_value_pair( ( name = 'KEY1' value = er_entity-key1 ) )
*          iv_add_to_response_header = abap_true
*          iv_message_target         = CONV string( lst_ret-message ) ).

    ENDIF.
  ENDMETHOD.


  METHOD deliveryblockset_get_entity.
    DATA:lv_vbeln TYPE vbeln.
    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_key-value
        IMPORTING
          output = lv_vbeln.
      SELECT SINGLE vbeln  FROM vbap INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = lv_vbeln.
    ENDIF.
  ENDMETHOD.


  METHOD deliveryblockset_get_entityset.
    DATA :lv_host TYPE string.
    DATA :lv_port TYPE string.


    DATA:lr_vbeln  TYPE edm_vbeln_range_tt,
         lst_vbeln TYPE edm_vbeln_range,
         lr_auart  TYPE tms_t_auart_range,
         lr_kunnr  TYPE range_kunnr_tab,
         lst_kunnr TYPE range_kunnr_wa,
         lst_auart TYPE tms_s_auart_range.


    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.


    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_faksk   TYPE char02,
          lv_lifsk   TYPE char02,
          lv_overall TYPE char02,
          lv_credit  TYPE char02,
          lv_incompl TYPE char02,
          lv_vbeln   TYPE vbeln,
          lv_kunnr   TYPE kunnr,
          lv_auart   TYPE auart,
          lv_posnr   TYPE posnr,
          lv_msgty   TYPE msgty,
          lv_stdate  TYPE erdat,
          lv_endate  TYPE erdat,
          lv_msg     TYPE msgv1.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_deliveryblock.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_deliveryblock.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA lv_uname TYPE sy-uname.

    lv_uname = sy-uname.

    DATA:lr_vkorg TYPE sd_vkorg_ranges.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

    CASE iv_entity_set_name.
      WHEN 'DeliveryBlockSet'.

        LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
          LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
            CASE <ls_filter>-property.
              WHEN 'Lifsk'.
                lv_lifsk = <ls_filter_opt>-low.
              WHEN 'Vbeln'.
                lv_vbeln = <ls_filter_opt>-low.
                IF lv_vbeln NE 0 AND lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
                  lst_vbeln-sign = 'I'.
                  lst_vbeln-option = 'EQ'.
                  lst_vbeln-low = lv_vbeln.
                  APPEND lst_vbeln TO lr_vbeln.
                ENDIF.
              WHEN 'Kunnr'.
                lv_kunnr = <ls_filter_opt>-low.
                IF lv_kunnr NE 0 AND lv_kunnr NE 'null' AND lv_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lv_kunnr
                    IMPORTING
                      output = lv_kunnr.

                  lst_kunnr-sign = 'I'.
                  lst_kunnr-option = 'EQ'.
                  lst_kunnr-low = lv_kunnr.
                  APPEND lst_kunnr TO lr_kunnr.
                ENDIF.
              WHEN 'Posnr'.
                lv_posnr = <ls_filter_opt>-low.
              WHEN 'Auart'.
                lv_auart = <ls_filter_opt>-low.
                IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
                  lst_auart-sign = 'I'.
                  lst_auart-option = 'EQ'.
                  lst_auart-low = lv_auart.
                  APPEND lst_auart TO lr_auart.
                ENDIF.
              WHEN 'Stdate'.
                lv_stdate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
              WHEN 'Endate'.
                lv_endate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

        IF lv_lifsk EQ 'RE'.
* Clear Order Filter when Order selected for release block
          REFRESH:lr_vbeln[].
        ENDIF.

        IF it_orders[] IS INITIAL.
* Fetch all delivery block records
          SELECT * FROM zsd_ordrs
        INTO CORRESPONDING FIELDS OF TABLE it_orders
         WHERE  ( lifsk NE abap_false )
            AND vbeln IN lr_vbeln
            AND auart IN lr_auart
            AND kunnr IN lr_kunnr
            AND erdat GE lv_stdate AND erdat LE lv_endate
            AND vkorg IN lr_vkorg.

        ENDIF.

      WHEN OTHERS.
    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.
    ENDIF.

    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .

    LOOP AT  it_orders INTO wa_orders.
      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart =
      wa_orders-auart BINARY SEARCH.
      IF sy-subrc EQ 0.
        wa_orders-ordtyp = ls_tvak-bezei.
      ENDIF.

      wa_orders-prodh = wa_orders-erdat+0(6).

      CASE wa_orders-vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12
          wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22
          wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02
          wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42
          wa_orders-vbeln INTO wa_orders-linkref.

        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02
          wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02
          wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.

      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
  ENDMETHOD.


  METHOD deliveryblockset_update_entity.
    DATA: ls_message           TYPE          scx_t100key.
    DATA:lv_vbeln TYPE vbeln,
         lv_posnr TYPE posnr,
         lv_msgty TYPE msgty,
         lst_ret  TYPE bapiret2,
         lv_msg   TYPE msgv1.

    DATA: lo_message_container TYPE REF TO /iwbep/if_message_container.

    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_deliveryblock.
    READ TABLE it_key_tab INTO DATA(lst_key) INDEX 1.
*    IF sy-subrc EQ 0.
*      wa_orders-message = lst_key-value.
*      wa_orders-vbeln = lst_key-value.
*      er_entity = wa_orders.
*
*      lv_vbeln = wa_orders-vbeln.
*      CALL FUNCTION 'ZQTC_RELEASE_BLOCK'
*        EXPORTING
*          im_vbeln = lv_vbeln
*          im_posnr = lv_posnr
*          IM_LIFSK = 'X'
**         IM_FAKSK =
**         IM_CMGST =
*        CHANGING
*          msgty    = lv_msgty
*          message  = lv_msg.
*
*      lst_ret-message = lv_msg.
*
*      CALL METHOD me->/iwbep/if_mgw_conv_srv_runtime~get_message_container
*        RECEIVING
*          ro_message_container = lo_message_container.
*
*      IF  lv_msgty = 'S'.
*        lv_msg = 'Delivery Block Released'.
*        SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_in)
*          WHERE vbeln = @lv_vbeln.
*        IF sy-subrc EQ 0.
*          CONCATENATE lv_msg 'but Order is Incomplete ' INTO lv_msg SEPARATED BY space.
*
*        ENDIF.
*
*        SELECT SINGLE faksk FROM vbak INTO @DATA(lv_faksk)
*          WHERE vbeln = @lv_vbeln.
*        IF sy-subrc EQ 0 AND lv_faksk IS NOT INITIAL.
*          IF lv_vbeln_in IS NOT INITIAL.
*            CONCATENATE lv_msg 'and has Billing Block ' INTO lv_msg SEPARATED BY space.
*          ELSE.
*            CONCATENATE lv_msg 'but Order has Billing Block' INTO lv_msg SEPARATED BY space.
*          ENDIF.
*          CLEAR:lv_faksk.
*        ENDIF.
*
*
*      ENDIF.
*
*      lst_ret-message = lv_msg.
*      CALL METHOD lo_message_container->add_message_from_bapi(
*        EXPORTING
*          is_bapi_message           = lst_ret
*          iv_entity_type            = iv_entity_set_name
**         it_key_tab                = VALUE /iwbep/t_mgw_name_value_pair( ( name = 'KEY1' value = er_entity-key1 ) )
*          iv_add_to_response_header = abap_true
*          iv_message_target         = CONV string( lst_ret-message ) ).
*
*
*    ENDIF.
  ENDMETHOD.


  method DELVHEADSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->DELVHEADSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  method DELVHEADSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->DELVHEADSET_GET_ENTITYSET
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


  method DELVITEMSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->DELVITEMSET_GET_ENTITYSET
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


  METHOD dsoset_get_entityset.

    DATA :lv_host TYPE string.
    DATA :lv_port TYPE string.


    DATA:lr_vbeln  TYPE edm_vbeln_range_tt,
         lst_vbeln TYPE edm_vbeln_range,
         lr_auart  TYPE tms_t_auart_range,
         lst_auart TYPE tms_s_auart_range,
         lt_date   TYPE date_t_range,
         ls_date   TYPE date_range.


    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE
'/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.


    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_faksk   TYPE char02,
          lv_lifsk   TYPE char02,
          lv_overall TYPE char02,
          lv_credit  TYPE char02,
          lv_incompl TYPE char02,
          lv_vbeln   TYPE vbeln,
          lv_auart   TYPE auart,
          lv_posnr   TYPE posnr,
          lv_msgty   TYPE msgty,
          lv_stdate  TYPE erdat,
          lv_endate  TYPE erdat,
          lv_msg     TYPE msgv1.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_dso.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_dso.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.


    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

    CASE iv_entity_set_name.
      WHEN 'DeliveryBlockSet'.

        LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
          LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
            CASE <ls_filter>-property.
              WHEN 'Lifsk'.
                lv_lifsk = <ls_filter_opt>-low.
              WHEN 'Vbeln'.
                lv_vbeln = <ls_filter_opt>-low.
                IF lv_vbeln NE 0 AND lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
                  lst_vbeln-sign = 'I'.
                  lst_vbeln-option = 'EQ'.
                  lst_vbeln-low = lv_vbeln.
                  APPEND lst_vbeln TO lr_vbeln.
                ENDIF.
              WHEN 'Posnr'.
                lv_posnr = <ls_filter_opt>-low.
              WHEN 'Auart'.
                lv_auart = <ls_filter_opt>-low.
                IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
                  lst_auart-sign = 'I'.
                  lst_auart-option = 'EQ'.
                  lst_auart-low = lv_auart.
                  APPEND lst_auart TO lr_auart.
                ENDIF.
              WHEN 'Stdate'.
                lv_stdate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
              WHEN 'Endate'.
                lv_endate = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

      WHEN OTHERS.
    ENDCASE.

    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      ls_date-low = lv_stdate.
      ls_date-high = lv_endate.
      ls_date-option = 'BT'.
      ls_date-sign = 'I'.
      APPEND ls_date TO lt_date.
    ENDIF.

*        IF lv_lifsk EQ 'RE'.
** Clear Order Filter when Order selected for release block
*          REFRESH:lr_vbeln[].
*        ENDIF.

    IF it_orders[] IS INITIAL.
* Fetch all delivery block records
      SELECT  kunnr  FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE it_orders
     WHERE lifsk NE abap_false
        AND vbeln IN lr_vbeln
        AND auart IN lr_auart
        AND erdat IN lt_date .
    ENDIF.



    SORT it_orders[] BY vbeln kunnr.
    IF it_orders[] IS NOT INITIAL.
      SELECT kunnr,name1 FROM kna1 INTO TABLE @DATA(lt_kna1)
        FOR ALL ENTRIES IN @it_orders
        WHERE kunnr = @it_orders-kunnr.

      IF sy-subrc EQ 0.
        SORT lt_kna1 BY kunnr.
      ENDIF.
    ENDIF.

    SORT it_orders[] BY kunnr .
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING kunnr .

    LOOP AT  it_orders INTO wa_orders.
      READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr =    wa_orders-kunnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        wa_orders-name1 = ls_kna1-name1.
      ENDIF.
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.

  ENDMETHOD.


  METHOD incompleteset_get_entityset.
    TYPES:BEGIN OF ty_fdnam,
            sign(1)   TYPE c,
            option(2) TYPE c,
            low       TYPE fdnam_vb,
            high      TYPE fdnam_vb,
          END OF ty_fdnam.
    DATA:lst_fdnam TYPE ty_fdnam.
    DATA:lir_fdnam TYPE TABLE OF ty_fdnam.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_incomplete.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_incomplete.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair,
            lir_vbeln  TYPE STANDARD TABLE OF edm_vbeln_range,
            lir_auart  TYPE  fip_t_auart_range,
            lst_auart  TYPE  fip_s_auart_range,
            lst_vbeln  TYPE edm_vbeln_range.
    DATA :     lv_host TYPE string.
    DATA :lv_port   TYPE string,
          lv_vbeln  TYPE vbeln_va,
          lv_auart  TYPE auart,
          lv_stdate TYPE erdat,
          lv_endate TYPE erdat,
          lt_date   TYPE date_t_range,
          ls_date   TYPE date_range.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.
    CONSTANTS: lc_eq TYPE char2 VALUE 'EQ',
               lc_i  TYPE char1 VALUE 'I'.


    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA:lt_char128  TYPE TABLE OF char128,
         lst_char128 TYPE REF TO char128.

    DATA lv_uname TYPE sy-uname.

    lv_uname = sy-uname.

    DATA:lr_vkorg TYPE sd_vkorg_ranges.
    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
      EXPORTING
        im_uname = lv_uname
      TABLES
        et_vkorg = lr_vkorg.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.
            lv_vbeln = <ls_filter_opt>-low.
            lst_vbeln-low = <ls_filter_opt>-low.
            IF lst_vbeln-low NE 'null'.
              lst_vbeln-sign    = lc_i.
              lst_vbeln-option  = lc_eq.
              APPEND lst_vbeln TO lir_vbeln.
            ENDIF.
          WHEN 'Auart'.
            lv_auart = <ls_filter_opt>-low.
            IF lv_auart NE 'null'.
              lst_auart-sign    = lc_i.
              lst_auart-option  = lc_eq.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lir_auart.
            ENDIF.

          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Fdnam'.
            IF <ls_filter_opt>-low IS NOT INITIAL AND <ls_filter_opt>-low NE 'null'.
              CLEAR:lst_fdnam.
              lst_fdnam-sign    = lc_i.
              lst_fdnam-option  = lc_eq.
              lst_fdnam-low = <ls_filter_opt>-low.
              APPEND lst_fdnam TO lir_fdnam.



            ENDIF.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
*    cl_http_server=>if_http_server~get_location(
*       IMPORTING host = lv_host
*              port = lv_port ).
* href="http://es1app01.wiley.com:8000/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN={Vbeln};DYNP_OKCODE="
*create URL
*    CONCATENATE 'http://' lv_host ':' lv_port lc_va42 INTO wa_orders-linkref.

    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      ls_date-low = lv_stdate.
      ls_date-high = lv_endate.
      ls_date-option = 'BT'.
      ls_date-sign = 'I'.
      APPEND ls_date TO lt_date.
    ENDIF.

** Fetch all records
    SELECT v~vbeln,
           v~posnr,
           v~etenr,v~parvw,v~tbnam,v~fdnam,v~fehgr,v~statg,
           k~kunnr,k~auart,k~erdat ,k~waerk,k~vkorg ,k~vtweg, k~spart,k~vbtyp,
           k~bsark  INTO TABLE @DATA(li_final)
    FROM vbuv AS v INNER JOIN vbak AS k
    ON v~vbeln = k~vbeln
    WHERE  k~vbeln IN @lir_vbeln
      AND k~auart IN @lir_auart
      and v~fdnam in @lir_fdnam
      and k~vkorg in @lr_vkorg.

    IF li_final[] IS NOT INITIAL.
      SORT li_final[] BY vbeln posnr.
      SELECT vbeln , posnr, matnr,netwr ,zmeng,meins
        FROM vbap
        INTO TABLE @DATA(li_vbap)
        FOR ALL ENTRIES IN @li_final
        WHERE vbeln = @li_final-vbeln
          AND posnr = @li_final-posnr
          AND erdat IN @lt_date.

      IF sy-subrc EQ 0.
        SORT li_vbap BY vbeln posnr.
      ENDIF.
    ENDIF.


    LOOP AT  li_final INTO DATA(lst_orders).

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      wa_orders-posnr = lst_orders-posnr .
      wa_orders-vkorg = lst_orders-vkorg .
      wa_orders-vtweg = lst_orders-vtweg .
      wa_orders-spart = lst_orders-spart .
      wa_orders-auart = lst_orders-auart .
      wa_orders-waerk = lst_orders-waerk .
      wa_orders-fehgr = lst_orders-fehgr .
      wa_orders-statg = lst_orders-statg .
      wa_orders-kunnr = lst_orders-kunnr .
      wa_orders-stdate = lst_orders-erdat .
      wa_orders-bsark = lst_orders-bsark .
      wa_orders-erdat = lst_orders-erdat .

      CASE lst_orders-vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.

      READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_orders-vbeln
                                                      posnr = lst_orders-posnr BINARY SEARCH.
      IF sy-subrc EQ 0.

        wa_orders-netwr = lst_vbap-netwr .
        wa_orders-meins = lst_vbap-meins .
        wa_orders-zmeng = lst_vbap-zmeng .


        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lst_vbap-matnr
          IMPORTING
            output = wa_orders-matnr.

        APPEND wa_orders TO et_entityset.
      ENDIF.



      CLEAR:wa_orders.
    ENDLOOP.
    SORT et_entityset BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING vbeln .
  ENDMETHOD.


  METHOD inctypeset_get_entityset.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_inctype.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_inctype.
    DATA:lv_label TYPE  string.

    SELECT DISTINCT tbnam,fdnam INTO TABLE @DATA(li_vbuv) FROM vbuv.

*    SELECT * INTO TABLE @DATA(li_vbuv2) FROM vbuv.


    LOOP AT li_vbuv INTO DATA(lst_vbuv).
      CLEAR:lv_label.

      CALL FUNCTION 'DDIF_FIELDLABEL_GET'
        EXPORTING
          tabname        = lst_vbuv-tbnam
          fieldname      = lst_vbuv-fdnam
          langu          = sy-langu
        IMPORTING
          label          = lv_label
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.

      wa_orders-descr = lv_label .
      wa_orders-fdnam = lst_vbuv-fdnam.
      wa_orders-tbnam = lst_vbuv-tbnam.
      APPEND wa_orders TO et_entityset.
      CLEAR wa_orders.
    ENDLOOP.
    SORT et_entityset BY descr.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING descr.
  ENDMETHOD.


  METHOD itembillset_get_entityset.


    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_itembill.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_itembill.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string,
          lv_vbeln TYPE vbeln_va,
          lv_prodh TYPE auart.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.



    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.



    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.
            lv_vbeln = <ls_filter_opt>-low.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_vbeln
              IMPORTING
                output = lv_vbeln.


*          WHEN 'Auart'.
*            lv_prodh = <ls_filter_opt>-low.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).


* Fetch specific Order
    IF  ( lv_vbeln IS  NOT INITIAL AND lv_vbeln NE 'null' ) .

      SELECT *
        FROM vbap
        INTO TABLE @DATA(li_vbap)
        WHERE vbeln = @lv_vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbap BY vbeln posnr.

        SELECT SINGLE vbtyp FROM vbak INTO  @DATA(lv_vbtyp)
          WHERE vbeln = @lv_vbeln.
        IF sy-subrc NE 0.
          CLEAR:lv_vbtyp.
        ENDIF.
      ENDIF.

    ENDIF.


    LOOP AT  li_vbap INTO DATA(lst_orders).

      MOVE-CORRESPONDING lst_orders TO wa_orders.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      CASE lv_vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.



      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
    SORT et_entityset BY vbeln posnr.


  ENDMETHOD.


  method ITEMCREDITSET_GET_ENTITYSET.


    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_itemcredit.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_itemcredit.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string,
          lv_vbeln TYPE vbeln_va,
          lv_prodh TYPE auart.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.



    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.



    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.
            lv_vbeln = <ls_filter_opt>-low.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_vbeln
              IMPORTING
                output = lv_vbeln.


*          WHEN 'Auart'.
*            lv_prodh = <ls_filter_opt>-low.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).


* Fetch specific Order
    IF  ( lv_vbeln IS  NOT INITIAL AND lv_vbeln NE 'null' ) .

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input         = lv_vbeln
       IMPORTING
         OUTPUT        = lv_vbeln.                .


      SELECT *
        FROM vbap
        INTO TABLE @DATA(li_vbap)
        WHERE vbeln = @lv_vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbap BY vbeln posnr.

        SELECT SINGLE vbtyp FROM vbak INTO  @DATA(lv_vbtyp)
          WHERE vbeln = @lv_vbeln.
        IF sy-subrc NE 0.
          CLEAR:lv_vbtyp.
        ENDIF.
      ENDIF.

    ENDIF.


    LOOP AT  li_vbap INTO DATA(lst_orders).

      MOVE-CORRESPONDING lst_orders TO wa_orders.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      CASE lv_vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.



      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
    SORT et_entityset BY vbeln posnr.


  ENDMETHOD.


  METHOD itemdelvset_get_entityset.



    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_itemdelv.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_itemdelv.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string,
          lv_vbeln TYPE vbeln_va,
          lv_prodh TYPE auart.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.



    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.



    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.
            lv_vbeln = <ls_filter_opt>-low.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_vbeln
              IMPORTING
                output = lv_vbeln.


*          WHEN 'Auart'.
*            lv_prodh = <ls_filter_opt>-low.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).


* Fetch specific Order
    IF  ( lv_vbeln IS  NOT INITIAL AND lv_vbeln NE 'null' ) .

      SELECT *
        FROM vbap
        INTO TABLE @DATA(li_vbap)
        WHERE vbeln = @lv_vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbap BY vbeln posnr.

        SELECT SINGLE vbtyp FROM vbak INTO  @DATA(lv_vbtyp)
          WHERE vbeln = @lv_vbeln.
        IF sy-subrc NE 0.
          CLEAR:lv_vbtyp.
        ENDIF.
      ENDIF.

    ENDIF.


    LOOP AT  li_vbap INTO DATA(lst_orders).

      MOVE-CORRESPONDING lst_orders TO wa_orders.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

      CASE lv_vbtyp.
        WHEN 'A'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'B'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'C'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'G'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
        WHEN 'K'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'L'.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
        WHEN 'OTHERS'.

      ENDCASE.



      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
    SORT et_entityset BY vbeln posnr.



  ENDMETHOD.


  METHOD itemincset_get_entityset.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_iteminc.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_iteminc.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string,
          lv_vbeln TYPE vbeln_va,
          lv_label TYPE  string,
          lv_prodh TYPE auart.

    CONSTANTS:lc1_va02 TYPE sy-tcode VALUE 'VA02',
              lc1_va12 TYPE sy-tcode VALUE 'VA12',
              lc1_va22 TYPE sy-tcode VALUE 'VA22',
              lc1_va42 TYPE sy-tcode VALUE 'VA42',
              lc_a     TYPE vbtyp VALUE 'A',
              lc_b     TYPE vbtyp VALUE 'B',
              lc_c     TYPE vbtyp VALUE 'C',
              lc_g     TYPE vbtyp VALUE 'G',
              lc_k     TYPE vbtyp VALUE 'K',
              lc_l     TYPE vbtyp VALUE 'L',
              lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
              lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
              lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.



    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.



    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.
            lv_vbeln = <ls_filter_opt>-low.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_vbeln
              IMPORTING
                output = lv_vbeln.

          WHEN 'Prodh'.
            lv_prodh = <ls_filter_opt>-low.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).


* Fetch specific Order
    IF  ( lv_vbeln IS  NOT INITIAL AND lv_vbeln NE 'null' ) .
* Display all items
      IF lv_prodh IS INITIAL  OR lv_prodh = 'null'.
        SELECT *
          FROM vbap
          INTO TABLE @DATA(li_vbap)
          WHERE vbeln = @lv_vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbap BY vbeln posnr.

          SELECT SINGLE vbtyp FROM vbak INTO  @DATA(lv_vbtyp)
            WHERE vbeln = @lv_vbeln.
          IF sy-subrc NE 0.
            CLEAR:lv_vbtyp.
          ENDIF.
        ENDIF.
      ELSEIF lv_prodh = 'INCL'.
* Display only incomplete/missing info
        SELECT vbeln,
             posnr,
             tbnam,
             fdnam
        FROM vbuv
        INTO TABLE @DATA(li_vbuv)
       WHERE vbeln eq @lv_vbeln.
        IF sy-subrc EQ 0.
          SELECT SINGLE vbtyp FROM vbak INTO  @lv_vbtyp
            WHERE vbeln = @lv_vbeln.
          IF sy-subrc NE 0.
            CLEAR:lv_vbtyp.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDIF.


    IF lv_prodh IS INITIAL OR lv_prodh = 'null'.
      LOOP AT  li_vbap INTO DATA(lst_orders).

        MOVE-CORRESPONDING lst_orders TO wa_orders.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lst_orders-vbeln
          IMPORTING
            output = wa_orders-vbeln.

        CASE lv_vbtyp.
          WHEN 'A'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
          WHEN 'B'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
          WHEN 'C'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
          WHEN 'G'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.

*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
          WHEN 'K'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
          WHEN 'L'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
          WHEN 'OTHERS'.

        ENDCASE.



        APPEND wa_orders TO et_entityset.
        CLEAR:wa_orders.
      ENDLOOP.
      SORT et_entityset BY vbeln posnr.
    ELSEIF lv_prodh = 'INCL'.

      LOOP AT li_vbuv INTO DATA(lst_vbuv).
        CLEAR:lv_label.

    if sy-tabix = 1.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lst_vbuv-vbeln
          IMPORTING
            output = wa_orders-vbeln.
    endif.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lst_vbuv-posnr
          IMPORTING
            output = wa_orders-posnr.

     if lst_vbuv-posnr is INITIAL.
       clear:wa_orders-posnr.
     endif.

        CALL FUNCTION 'DDIF_FIELDLABEL_GET'
          EXPORTING
            tabname        = lst_vbuv-tbnam
            fieldname      = lst_vbuv-fdnam
            langu          = sy-langu
          IMPORTING
            label          = lv_label
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.

        wa_orders-missing = lv_label .
        APPEND wa_orders TO et_entityset.
        CLEAR wa_orders.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD ordertypeset_get_entityset.
    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA:lv_auart TYPE auart.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_ordertype.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_ordertype.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO wa_key_tab INDEX 1.


    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Auart'.
            lv_auart = <ls_filter_opt>-low.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    IF lv_auart IS INITIAL OR lv_auart EQ 'null'.
      lv_auart = 'Z%'.
    ELSE.
      lv_auart = lv_auart && '%'.

    ENDIF.
    SELECT * FROM tvakt
    INTO CORRESPONDING FIELDS OF TABLE it_orders
       WHERE  spras = sy-langu
        AND auart LIKE lv_auart.

    SORT it_orders[] BY auart bezei.
    LOOP AT  it_orders INTO wa_orders.


      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
  ENDMETHOD.


  method SOLDTOSET_GET_ENTITYSET.

  TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zsd_ordrs_mpc=>ts_soldto,
         ls_maxrow TYPE bapi_epm_max_rows.
    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,

         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS: lc_cp      TYPE char2 VALUE 'CP',
               lc_i       TYPE char1 VALUE 'I'.



    FREE:lst_kunnr,
          lst_name,
          lir_name,
*         lst_final,
         lir_kunnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Name1'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_cp.
                lst_name-option = lc_cp.
                lst_kunnr-sign = lc_i.
                lst_name-sign = lc_i.
                CONCATENATE <ls_filter_opt>-low '*' INTO DATA(lv_name).
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                CLEAR lv_name.
                CONCATENATE '*' <ls_filter_opt>-low '*' INTO lv_name.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                DATA(lv_length) = strlen( lv_name ).
                IF lv_length GT 3.
                  lv_length = lv_length - 3.
                  DATA(lv_letter) = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter lv_name+2(lv_length) '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ELSEIF lv_length EQ 3.
                  lv_length = lv_length - 3.
                  lv_letter = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ENDIF.

                TRANSLATE lv_name TO UPPER CASE.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_kunnr IS NOT INITIAL.

      DATA : li_return   TYPE STANDARD TABLE OF bapiret2,
             li_result   TYPE STANDARD TABLE OF bus020_search_result,
             lv_email    TYPE ad_smtpadr,
             lst_address TYPE bupa_addr_search,
             lv_name1    TYPE bu_mcname1,
             lv_name2    TYPE bu_mcname2.
*--*First search Email + First name + Last name +Street
      lv_name1 = lv_name.
      lv_name2 = lv_name.
      CALL FUNCTION 'BUPA_SEARCH_2'
        EXPORTING
          iv_email         = lv_email
          is_address       = lst_address
          iv_mc_name1      = lv_name1
          iv_mc_name2      = lv_name2
          iv_req_mask      = abap_true
        TABLES
          et_search_result = li_result
          et_return        = li_return.

      IF li_result IS NOT  INITIAL.
        SELECT kna1~kunnr,
              kna1~name1,
              kna1~name2
         INTO TABLE @DATA(li_soldto)  UP TO 100 ROWS
         FROM kna1
         INNER JOIN but000 ON but000~partner = kna1~kunnr
         FOR ALL ENTRIES IN @li_result
         WHERE ( kna1~kunnr = @li_result-partner
           OR kna1~name1 IN @lir_name
           OR kna1~name2  IN @lir_name )
           AND but000~bu_group = '0001'
           AND but000~xblck = @abap_false.
      ELSE.
        SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE ( kna1~kunnr IN @lir_kunnr
            OR kna1~name1 IN @lir_name
            OR kna1~name2  IN @lir_name )
            AND but000~bu_group = '0001'
            AND but000~xblck = @abap_false.
      ENDIF.
    ELSE.
      SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE but000~bu_group = '0001'
            AND but000~xblck = @abap_false.
    ENDIF.
    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.

    IF lv_total > 0.
      LOOP AT li_soldto INTO DATA(lst_soldto) FROM lv_skip TO lv_total.

        ls_entity = CORRESPONDING #( lst_soldto ).
        APPEND ls_entity TO et_entityset.

      ENDLOOP.
    ELSE.
      MOVE-CORRESPONDING li_soldto TO et_entityset.
    ENDIF.

  endmethod.


  method TIMESET_GET_ENTITYSET.
       CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
               lc_time  TYPE rvari_vnam VALUE 'TIME'.

    SELECT
         low
         FROM zcaconstant
         INTO TABLE et_entityset
         WHERE devid  = lc_devid
           AND param1 = lc_time.

  endmethod.


  METHOD useraccessset_get_entity.

*    DATA :lv_vkorg TYPE vkorg.
*
*    READ TABLE it_key_tab INTO DATA(lst_key_tab) INDEX 1.
*    IF  sy-subrc = 0 AND lst_key_tab-value IS NOT INITIAL.
*
*      SELECT single *
*        FROM zqtct_auth_check
*        INTO @DATA(lst_access)
*        WHERE vkorg = @lst_key_tab-value+0(4).
*        IF sy-subrc EQ 0.
*          er_entity-vkorg = lst_access-vkorg.
*          er_entity-billing_block = lst_access-billing_block.
*          er_entity-credit_block = lst_access-credit_block.
*          er_entity-delv_block = lst_access-delv_block.
*          er_entity-incomplete_block = lst_access-incomplete_block.
*        ENDIF.
*      ENDIF.

    ENDMETHOD.


  METHOD useraccessset_get_entityset.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_useraccess.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_useraccess.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
    DATA :lv_vkorg TYPE vkorg.
    DATA:lv_uname type sy-uname.
    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Vkorg' OR 'VKORG'.
            lv_vkorg = <ls_filter_opt>-low.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
*    IF  lv_vkorg IS NOT INITIAL.
*      SELECT SINGLE *
*        FROM zqtct_auth_check
*        INTO @DATA(lst_access)
*        WHERE vkorg = @lv_vkorg.
*      IF sy-subrc EQ 0.
*        wa_orders-vkorg = lst_access-vkorg.
*        wa_orders-billing_block = lst_access-billing_block.
*        wa_orders-credit_block = lst_access-credit_block.
*        wa_orders-delv_block = lst_access-delv_block.
*        wa_orders-incomplete_block = lst_access-incomplete_block.
*
*        APPEND wa_orders TO et_entityset.
*        CLEAR wa_orders.
*      ENDIF.
*    ENDIF.

       lv_uname = sy-uname.
* Check Authorization for Billing Block Tab to user
        AUTHORITY-CHECK OBJECT 'ZDUMMY_BB' FOR USER lv_uname
                    ID 'ACTVT' FIELD '01'
                   ID 'ACTVT' FIELD '02' .

        IF  syst-subrc = 0 .
          wa_orders-billing_block = 'X'.
        ENDIF.

* Check Authorization for Delivery Block Tab to user
        AUTHORITY-CHECK OBJECT 'ZDUMMY_DB' FOR USER lv_uname
                    ID 'ACTVT' FIELD '01'
                   ID 'ACTVT' FIELD '02' .

        IF  syst-subrc = 0 .
          wa_orders-delv_block = 'X'.
        ENDIF.


* Check Authorization for Incomplete Block Tab to user
        AUTHORITY-CHECK OBJECT 'ZDUMMY_IC' FOR USER lv_uname
                    ID 'ACTVT' FIELD '01'
                   ID 'ACTVT' FIELD '02' .

        IF  syst-subrc = 0 .
          wa_orders-incomplete_block = 'X'.
        ENDIF.


        APPEND wa_orders TO et_entityset.
  ENDMETHOD.


  method USERIDSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->USERIDSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  method USERIDSET_GET_ENTITYSET.
     FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.



    DATA:it_user TYPE zcl_zsd_ordrs_mpc=>tt_userid.
    DATA:wa_user TYPE zcl_zsd_ordrs_mpc=>ts_userid.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.
*
*    READ TABLE it_key_tab INTO wa_key_tab INDEX 1.
*
*
*    SELECT bname FROM usr01
*    INTO CORRESPONDING FIELDS OF TABLE it_user.
**       WHERE  spras = sy-langu.
*
*    SORT it_user[] BY bname.
*    LOOP AT  it_user INTO wa_user.
*
*
*      APPEND wa_user TO et_entityset.
*      CLEAR:wa_user.
*    ENDLOOP.
  endmethod.


  METHOD zcaconstset_get_entityset.
    CONSTANTS: lc_devid TYPE zdevid      VALUE 'E266' .
    CONSTANTS: lc_days TYPE  rvari_vnam     VALUE 'DAYS' .
    DATA:lst_const TYPE zcl_zsd_ordrs_mpc=>ts_zcaconst.
*----get constant entries

    SELECT SINGLE * FROM zcaconstant
      INTO @DATA(lst_constants)
      WHERE devid = @lc_devid
        AND param1 = @lc_days
        AND activate = @abap_true.
    IF sy-subrc EQ 0.
      CLEAR:lst_const.
      lst_const-devid = lst_constants-devid .
      lst_const-param1 = lst_constants-param1.
      lst_const-param2 = lst_constants-param2.
      lst_const-sign   = lst_constants-sign.
      lst_const-opti = lst_constants-opti.
      lst_const-low    = lst_constants-low.
      APPEND lst_const TO et_entityset.
      CLEAR lst_const.

    ENDIF.

  ENDMETHOD.


  method ZSD_ORDRSSET_GET_ENTITYSET.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_faksk   TYPE char02,
          lv_lifsk   TYPE char02,
          lv_rel     TYPE char02,
          lv_overall TYPE char02,
          lv_credit  TYPE char02,
          lv_incompl TYPE char02,
          lv_vbeln   TYPE vbeln,
          lv_type    TYPE char02,
          lv_posnr   TYPE posnr.

    DATA:it_orders TYPE zcl_zsd_ordrs_mpc=>tt_zsd_ordrs.
    DATA:wa_orders TYPE zcl_zsd_ordrs_mpc=>ts_zsd_ordrs.
    DATA:wa_orders2 TYPE zcl_zsd_ordrs_mpc=>ts_zsd_ordrs.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.

    CASE iv_entity_set_name.

      WHEN 'ZSD_ORDRSSet'.

        LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
          LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
            CASE <ls_filter>-property.
              WHEN 'Faksk'.
                lv_faksk = <ls_filter_opt>-low.
              WHEN 'Lifsk'.
                lv_lifsk = <ls_filter_opt>-low.
              WHEN 'Huvall'.
                lv_incompl = <ls_filter_opt>-low.

              WHEN 'Gbsta'.
                lv_overall = <ls_filter_opt>-low.

              WHEN 'Cmgst'.
                lv_credit = <ls_filter_opt>-low.
              WHEN 'Vbeln'.
                lv_vbeln = <ls_filter_opt>-low.
              WHEN 'Posnr'.
                lv_posnr = <ls_filter_opt>-low.
              WHEN 'Blocktype'.
                lv_type = <ls_filter_opt>-low.
                data(lv_typ) = abap_true.
            ENDCASE.
          ENDLOOP.
        ENDLOOP.

IF lv_type IS INITIAL AND lv_typ is INITIAL.
lv_type = 'BB'.
ENDIF.

*        IF lv_vbeln IS NOT INITIAL AND lv_posnr IS NOT INITIAL AND lv_lifsk+0(2) = 'RE'.
*
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lv_vbeln
*            IMPORTING
*              output = lv_vbeln.
*
*          UPDATE vbak SET lifsk = ''
*               WHERE vbeln = lv_vbeln.
*          COMMIT WORK.
*        ENDIF.

*        IF  lv_faksk+0(1) EQ 't'.
        IF  lv_type EQ 'BB'.
          SELECT * FROM zsd_ordrs
          INTO CORRESPONDING FIELDS OF TABLE it_orders
          WHERE  ( faksp NE space OR faksk NE space )
           AND ( ernam = sy-uname   ).
        ENDIF.

        IF lv_lifsk NE 'RE'.
**          IF  lv_lifsk+0(1) EQ 't'.
*          IF  lv_type EQ 'DB'.
*            SELECT * FROM zsd_ordrs
*         APPENDING TABLE it_orders
*            WHERE  ( lifsk NE space  OR abgru NE space )
*           AND ( ernam = sy-uname   ).
*          ENDIF.
        ENDIF.
*          IF  lv_credit+0(1) EQ 't'.
        IF  lv_type EQ 'CB'.
*          SELECT * FROM zsd_ordrs
*       APPENDING TABLE it_orders
*          WHERE   ( cmgst = 'B' OR cmgst = 'C' )
*        AND ( ernam = sy-uname  ).
      ENDIF.


*          IF  lv_incompl+0(1) EQ 't'.
          IF  lv_type EQ 'IO'.
*            SELECT v~vbeln,
*                      v~posnr,
*                      v~etenr,v~parvw,v~tbnam,v~fdnam,v~fehgr,v~statg,
*                      k~kunnr,k~auart,k~waerk,k~vkorg ,k~vtweg, k~spart,k~vbtyp,
*                      k~bstnk INTO TABLE @DATA(li_final)
*               FROM vbuv AS v INNER JOIN vbak AS k
*               ON v~vbeln = k~vbeln
*               WHERE k~ernam = @sy-uname  .
*
*            IF sy-subrc EQ 0.
*              SORT li_final[] BY vbeln posnr.
*              SELECT vbeln , posnr, matnr,netwr ,zmeng,meins
*                FROM vbap
*                INTO TABLE @DATA(li_vbap)
*                FOR ALL ENTRIES IN @li_final
*                WHERE vbeln = @li_final-vbeln
*                  AND posnr = @li_final-posnr.
*
*              IF sy-subrc EQ 0.
*                SORT li_vbap BY vbeln posnr.
*              ENDIF.
*            ENDIF.
          ENDIF.


          IF it_orders[] IS INITIAL OR  ( lv_type EQ 'AL' OR lv_type is INITIAL )..

*            SELECT * FROM zsd_ordrs
*          INTO CORRESPONDING FIELDS OF TABLE it_orders
*           WHERE  ( faksp NE space OR lifsk NE space  OR abgru NE space OR
*              cmgst NE space OR faksk ne space
*              OR gbsta NE space )
*         AND ( ernam = sy-uname   ).

        ENDIF.

      WHEN OTHERS.

*        SELECT * FROM zsd_ordrs
*      INTO CORRESPONDING FIELDS OF TABLE it_orders
*       WHERE  ( faksp NE space OR lifsk NE space  OR abgru NE space OR
*          cmgst NE space
*          OR gbsta NE space )
*         AND ( ernam = sy-uname  ).
    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.
    ENDIF.

    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln posnr.

    LOOP AT  it_orders INTO wa_orders.
      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart = wa_orders-auart BINARY SEARCH.
      IF sy-subrc EQ 0.
        wa_orders-ordtyp = ls_tvak-bezei.
      ENDIF.
      IF wa_orders-faksp IS NOT INITIAL OR wa_orders-faksk IS NOT INITIAL.
        wa_orders-blocktype = 'Billing'.
      ENDIF.

*      IF wa_orders-lifsk IS NOT INITIAL .
*        wa_orders-blocktype = 'Delivery'.
*      ENDIF.
*
*      IF wa_orders-cmgst IS NOT INITIAL .
*        wa_orders-blocktype = 'Credit'.
*      ENDIF.
*
*      IF wa_orders-gbsta IS NOT INITIAL .
*        wa_orders-blocktype = 'Overall'.
*      ENDIF.
*
*      IF wa_orders-huvall IS NOT INITIAL  OR wa_orders-iuvall IS NOT INITIAL.
*        wa_orders-blocktype = 'Incomplete'.
*      ENDIF.

      wa_orders-prodh = wa_orders-erdat+0(6).

      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.

  endmethod.
ENDCLASS.
