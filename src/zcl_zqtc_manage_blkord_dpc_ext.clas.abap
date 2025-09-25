class ZCL_ZQTC_MANAGE_BLKORD_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_MANAGE_BLKORD_DPC
  create public .

public section.
protected section.

  methods BILLINGBLOCKSET_GET_ENTITYSET
    redefinition .
  methods CREDITSET_GET_ENTITYSET
    redefinition .
  methods DELIVERYBLOCKSET_GET_ENTITYSET
    redefinition .
  methods DELVITEMSET_GET_ENTITYSET
    redefinition .
  methods INCOMPLETESET_GET_ENTITYSET
    redefinition .
  methods INCTYPESET_GET_ENTITYSET
    redefinition .
  methods ZSD_ORDRSSET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_MANAGE_BLKORD_DPC_EXT IMPLEMENTATION.


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
             AND vbak~erdat IN lt_date.
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
*          SELECT * FROM zsd_ordrs
*        INTO CORRESPONDING FIELDS OF TABLE it_orders
*         WHERE  ( cmgst = 'B' OR cmgst = 'C' )
*            AND vbeln IN lr_vbeln
*            AND auart IN lr_auart
*            AND erdat IN lt_date.
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
*      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
*        FOR ALL ENTRIES IN @it_orders
*        WHERE auart = @it_orders-auart
*        AND spras = @sy-langu.
*
*      IF sy-subrc EQ 0.
*        SORT lt_tvak BY auart.
*      ENDIF.
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


  method DELIVERYBLOCKSET_GET_ENTITYSET.

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
                      input         = lv_kunnr
                   IMPORTING
                     OUTPUT        = lv_kunnr                            .

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
*          SELECT * FROM zsd_ordrs
*        INTO CORRESPONDING FIELDS OF TABLE it_orders
*         WHERE  ( lifsk NE abap_false )
*            AND vbeln IN lr_vbeln
*            AND auart IN lr_auart
*            AND kunnr IN lr_kunnr
*            AND erdat GE lv_stdate AND erdat LE lv_endate.

        ENDIF.

      WHEN OTHERS.
    ENDCASE.

    SORT it_orders[] BY erdat.
    IF it_orders[] IS NOT INITIAL.
*      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
*        FOR ALL ENTRIES IN @it_orders
*        WHERE auart = @it_orders-auart
*        AND spras = @sy-langu.

*      IF sy-subrc EQ 0.
*        SORT lt_tvak BY auart.
*      ENDIF.
    ENDIF.

    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .

    LOOP AT  it_orders INTO wa_orders.
*      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart =
*      wa_orders-auart BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        wa_orders-ordtyp = ls_tvak-bezei.
*      ENDIF.

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


  method INCOMPLETESET_GET_ENTITYSET.

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
*    SELECT v~vbeln,
*           v~posnr,
*           v~etenr,v~parvw,v~tbnam,v~fdnam,v~fehgr,v~statg,
*           k~kunnr,k~auart,k~erdat ,k~waerk,k~vkorg ,k~vtweg, k~spart,k~vbtyp,
*           k~bsark  INTO TABLE @DATA(li_final)
*    FROM vbuv AS v INNER JOIN vbak AS k
*    ON v~vbeln = k~vbeln
*    WHERE  k~vbeln IN @lir_vbeln
*      AND k~auart IN @lir_auart
*      and v~fdnam in @lir_fdnam.

*    IF li_final[] IS NOT INITIAL.
*      SORT li_final[] BY vbeln posnr.
*      SELECT vbeln , posnr, matnr,netwr ,zmeng,meins
*        FROM vbap
*        INTO TABLE @DATA(li_vbap)
*        FOR ALL ENTRIES IN @li_final
*        WHERE vbeln = @li_final-vbeln
*          AND posnr = @li_final-posnr
*          AND erdat IN @lt_date.
*
*      IF sy-subrc EQ 0.
*        SORT li_vbap BY vbeln posnr.
*      ENDIF.
*    ENDIF.
*    ENDIF.

*    LOOP AT  li_final INTO DATA(lst_orders).

*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*        EXPORTING
*          input  = lst_orders-vbeln
*        IMPORTING
*          output = wa_orders-vbeln.
*
*      wa_orders-posnr = lst_orders-posnr .
*      wa_orders-vkorg = lst_orders-vkorg .
*      wa_orders-vtweg = lst_orders-vtweg .
*      wa_orders-spart = lst_orders-spart .
*      wa_orders-auart = lst_orders-auart .
*      wa_orders-waerk = lst_orders-waerk .
*      wa_orders-fehgr = lst_orders-fehgr .
*      wa_orders-statg = lst_orders-statg .
*      wa_orders-kunnr = lst_orders-kunnr .
*      wa_orders-stdate = lst_orders-erdat .
*      wa_orders-bsark = lst_orders-bsark .
*      wa_orders-erdat = lst_orders-erdat .
*
*      CASE lst_orders-vbtyp.
*        WHEN 'A'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'B'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'C'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'G'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 wa_orders-vbeln INTO wa_orders-linkref.
*
*          CONCATENATE wa_orders-linkref ';~OKCODE=/00' INTO wa_orders-linkref.
*        WHEN 'K'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'L'.
*          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 wa_orders-vbeln INTO wa_orders-linkref.
*        WHEN 'OTHERS'.
*
*      ENDCASE.

*      READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_orders-vbeln
*                                                      posnr = lst_orders-posnr BINARY SEARCH.
*      IF sy-subrc EQ 0.
*
*        wa_orders-netwr = lst_vbap-netwr .
*        wa_orders-meins = lst_vbap-meins .
*        wa_orders-zmeng = lst_vbap-zmeng .
*
*
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*          EXPORTING
*            input  = lst_vbap-matnr
*          IMPORTING
*            output = wa_orders-matnr.
*
*        APPEND wa_orders TO et_entityset.
*      ENDIF.



*      CLEAR:wa_orders.
*    ENDLOOP.
*    SORT et_entityset BY vbeln posnr.
*    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING vbeln .

  endmethod.


  method INCTYPESET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->INCTYPESET_GET_ENTITYSET
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


  method ORDERTYPESET_GET_ENTITYSET.
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


  method ZSD_ORDRSSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZSD_ORDRSSET_GET_ENTITYSET
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
