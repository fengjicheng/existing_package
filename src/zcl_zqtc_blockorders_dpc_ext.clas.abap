class ZCL_ZQTC_BLOCKORDERS_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_BLOCKORDERS_DPC
  create public .

public section.
protected section.

  methods BILLINGSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_BLOCKORDERS_DPC_EXT IMPLEMENTATION.


  METHOD billingset_get_entityset.
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
          lr_kunnr   TYPE range_kunnr_tab,
          lst_kunnr  TYPE range_kunnr_wa,
          lst_auart  TYPE tms_s_auart_range,
          lv_kunnr  type kunnr.


    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string.

    DATA:it_orders TYPE zcl_zqtc_blockorders_mpc=>tt_billing.
    DATA:wa_orders TYPE zcl_zqtc_blockorders_mpc=>ts_billing.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.

    DATA:lr_vbeln  TYPE edm_vbeln_range_tt,
         lst_vbeln TYPE edm_vbeln_range,
         lr_auart  TYPE tms_t_auart_range.
*,
*
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
                  lst_vbeln-low = lv_vbeln.
                  APPEND lst_vbeln TO lr_vbeln.
                ENDIF.
              WHEN 'Posnr'.
*                lv_posnr = <ls_filter_opt>-low.

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

          SELECT vbak~vbeln vbak~erdat
                 vbak~erzet vbak~ernam
                 vbap~posnr vbap~matnr    "FETCHING DATA WITH INNER JOIN ON VBELN
                    INTO CORRESPONDING FIELDS OF TABLE it_orders
                 FROM vbak
                 INNER JOIN vbap ON
                 vbak~vbeln = vbap~vbeln
            WHERE  ( faksk NE space )
            AND vbak~vbeln IN lr_vbeln
             AND vbak~auart IN lr_auart
             and vbak~kunnr in lr_kunnr
             AND vbak~erdat IN lt_date.

        ENDIF.

      WHEN OTHERS.

    ENDCASE.
*
    SORT it_orders[] .
    IF it_orders[] IS NOT INITIAL.
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.
    ENDIF.
*
    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).
*
    IF it_orders[] IS NOT INITIAL.

      SELECT vbeln, vbtyp FROM vbak
        INTO TABLE @DATA(li_vbak)
       FOR ALL ENTRIES IN @it_orders
       WHERE vbeln = @it_orders-vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbak BY vbeln.
      ENDIF.

    ENDIF.
*
    LOOP AT  it_orders INTO wa_orders.
*
      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart = wa_orders-auart BINARY SEARCH.
      IF sy-subrc EQ 0.
*        wa_orders-ordtyp = ls_tvak-bezei.
      ENDIF.

      READ TABLE li_vbak INTO DATA(ls_vbak) WITH KEY vbeln = wa_orders-vbeln BINARY SEARCH.
      IF sy-subrc EQ 0.
*        wa_orders-ordtyp = ls_tvak-bezei.
      ENDIF.
*
      CASE ls_vbak-vbtyp.
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
*
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-vbeln
        IMPORTING
          output = wa_orders-vbeln.

*      wa_orders-prodh = wa_orders-erdat+0(6).
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
