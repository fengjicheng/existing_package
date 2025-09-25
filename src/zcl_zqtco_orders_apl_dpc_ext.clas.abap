class ZCL_ZQTCO_ORDERS_APL_DPC_EXT definition
  public
  inheriting from ZCL_ZQTCO_ORDERS_APL_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods APLCONSTENTRIESS_GET_ENTITYSET
    redefinition .
  methods ITEMSET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods SHIPTOSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTCO_ORDERS_APL_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA : wa_parameter TYPE /iwbep/s_mgw_name_value_pair.

    DATA : itab       TYPE zcl_zqtco_orders_apl_mpc=>tt_item.
    DATA: lst_entity    TYPE zcl_zqtco_orders_apl_mpc=>ts_item.

    READ  TABLE  it_parameter INTO wa_parameter INDEX 1.

    CASE  iv_action_name.

      WHEN  'SOCREATE'.

        IF er_data IS INITIAL.
          DO 10 TIMES.
            lst_entity-line = sy-index * 10.
            APPEND lst_entity TO itab.
          ENDDO.
        ENDIF.

        copy_data_to_ref( EXPORTING  is_data  = itab
                                 CHANGING  cr_data    = er_data  ).

    ENDCASE.
  ENDMETHOD.


  METHOD aplconstentriess_get_entityset.

    DATA: lst_entity TYPE zcl_zqtco_orders_apl_mpc=>ts_aplconstentries.

    CONSTANTS: lc_devid TYPE zdevid VALUE 'EUNI'.

    SELECT devid, param1, param2, srno, sign, opti, low, high
           FROM zcaconstant
           INTO TABLE @et_entityset
           WHERE devid = @lc_devid AND
                 activate = @abap_true.
    IF sy-subrc EQ 0.
      SORT et_entityset BY param1.
    ENDIF.

  ENDMETHOD.


  METHOD itemset_get_entityset.

    DATA: lst_entity    TYPE zcl_zqtco_orders_apl_mpc=>ts_item.

    DATA: lst_line      TYPE /iwbep/s_cod_select_option,
          lir_line      TYPE /iwbep/t_cod_select_options,
          lst_product   TYPE mat_range,
          lir_product   TYPE TABLE OF mat_range,
          lst_quantity  TYPE /iwbep/s_cod_select_option,
          lir_quantity  TYPE /iwbep/t_cod_select_options,
          lst_uom       TYPE /iwbep/s_cod_select_option,
          lir_uom       TYPE /iwbep/t_cod_select_options,
          lst_condtyp   TYPE /iwbep/s_cod_select_option,
          lir_condtyp   TYPE /iwbep/t_cod_select_options,
          lst_netpr     TYPE /iwbep/s_cod_select_option,
          lir_netpr     TYPE /iwbep/t_cod_select_options,
          lst_curr      TYPE /iwbep/s_cod_select_option,
          lir_curr     TYPE /iwbep/t_cod_select_options,
          lst_disc      TYPE /iwbep/s_cod_select_option,
          lir_disc      TYPE /iwbep/t_cod_select_options,
          lst_discpr    TYPE /iwbep/s_cod_select_option,
          lir_discpr    TYPE /iwbep/t_cod_select_options.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>) .
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Line'.
            lst_line-sign = <ls_filter_opt>-sign.
            lst_line-option = <ls_filter_opt>-option.
            lst_line-low = <ls_filter_opt>-low.
            lst_line-high = <ls_filter_opt>-high.
            APPEND lst_line TO lir_line.
            CLEAR: lst_line.
          WHEN 'Product'.
            lst_product-sign = <ls_filter_opt>-sign.
            lst_product-option = <ls_filter_opt>-option.
            lst_product-matnr_low = <ls_filter_opt>-low.
            lst_product-matnr_high = <ls_filter_opt>-high.
            APPEND lst_product TO lir_product.
            CLEAR: lst_product.
          WHEN 'Quantity'.
            lst_quantity-sign = <ls_filter_opt>-sign.
            lst_quantity-option = <ls_filter_opt>-option.
            lst_quantity-low = <ls_filter_opt>-low.
            lst_quantity-high = <ls_filter_opt>-high.
            APPEND lst_quantity TO lir_quantity.
            CLEAR: lst_quantity.
          WHEN 'Uom'.
            lst_uom-sign = <ls_filter_opt>-sign.
            lst_uom-option = <ls_filter_opt>-option.
            lst_uom-low = <ls_filter_opt>-low.
            lst_uom-high = <ls_filter_opt>-high.
            APPEND lst_uom TO lir_uom.
            CLEAR: lst_uom.
          WHEN 'CondType'.
            lst_condtyp-sign = <ls_filter_opt>-sign.
            lst_condtyp-option = <ls_filter_opt>-option.
            lst_condtyp-low = <ls_filter_opt>-low.
            lst_condtyp-high = <ls_filter_opt>-high.
            APPEND lst_condtyp TO lir_condtyp.
            CLEAR: lst_condtyp.
          WHEN 'NetPrice'.
            lst_netpr-sign = <ls_filter_opt>-sign.
            lst_netpr-option = <ls_filter_opt>-option.
            lst_netpr-low = <ls_filter_opt>-low.
            lst_netpr-high = <ls_filter_opt>-high.
            APPEND lst_netpr TO lir_netpr.
            CLEAR: lst_netpr.
          WHEN 'Currency'.
            lst_curr-sign = <ls_filter_opt>-sign.
            lst_curr-option = <ls_filter_opt>-option.
            lst_curr-low = <ls_filter_opt>-low.
            lst_curr-high = <ls_filter_opt>-high.
            APPEND lst_curr TO lir_curr.
            CLEAR: lst_curr.
          WHEN 'Discount'.
            lst_disc-sign = <ls_filter_opt>-sign.
            lst_disc-option = <ls_filter_opt>-option.
            lst_disc-low = <ls_filter_opt>-low.
            lst_disc-high = <ls_filter_opt>-high.
            APPEND lst_disc TO lir_disc.
            CLEAR: lst_disc.
          WHEN 'DiscountPrice'.
            lst_discpr-sign = <ls_filter_opt>-sign.
            lst_discpr-option = <ls_filter_opt>-option.
            lst_discpr-low = <ls_filter_opt>-low.
            lst_discpr-high = <ls_filter_opt>-high.
            APPEND lst_discpr TO lir_discpr.
            CLEAR: lst_discpr.
          WHEN OTHERS.
            "Do nothing.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.


    LOOP AT lir_line INTO lst_line.
      DATA(lv_posnr) = lst_line-high.
      lst_entity-line = lst_line-high.
      READ TABLE lir_product INTO lst_product WITH KEY matnr_low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-product = lst_product-matnr_high.
      ENDIF.
      READ TABLE lir_quantity INTO lst_quantity WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-quantity = lst_quantity-high.
      ENDIF.
      READ TABLE lir_uom INTO lst_uom WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-uom = lst_uom-high.
      ENDIF.
      READ TABLE lir_condtyp INTO lst_condtyp WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-cond_type = lst_condtyp-high.
      ENDIF.
      READ TABLE lir_netpr INTO lst_netpr WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-net_price = lst_quantity-high.
      ENDIF.
      READ TABLE lir_curr INTO lst_curr WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
        lst_entity-currency = lst_quantity-high.
      ENDIF.
      READ TABLE lir_disc INTO lst_disc WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
*        lst_entity-discount = lst_quantity-high.
      ENDIF.
      READ TABLE lir_discpr INTO lst_discpr WITH KEY low = lst_line-low.
      IF sy-subrc EQ 0.
*        lst_entity-quantity = lst_quantity-high.
      ENDIF.
      APPEND lst_entity TO et_entityset.
      CLEAR: lst_entity, lst_line, lst_product, lst_quantity, lst_uom,
             lst_condtyp, lst_netpr, lst_curr, lst_disc, lst_discpr.
    ENDLOOP.

    IF et_entityset IS INITIAL.
      lst_entity-line =  10.
      APPEND lst_entity TO et_entityset.
    ELSE.
*      lst_entity-line =  20.
      lst_entity-line =  lv_posnr + 10.
      APPEND lst_entity TO et_entityset.
    ENDIF.

  ENDMETHOD.


  METHOD ordertypeset_get_entityset.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA:lv_auart   TYPE auart,
         li_orders  TYPE zcl_zqtco_orders_apl_mpc=>tt_ordertype,
         lst_orders TYPE zcl_zqtco_orders_apl_mpc=>ts_ordertype,
         wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair,
         lst_auart  TYPE tds_rg_auart,
         lir_auart  TYPE TABLE OF tds_rg_auart.

    CONSTANTS: lc_i     TYPE c     VALUE 'I',
               lc_eq    TYPE char2 VALUE 'EQ',
               lc_auart TYPE rvari_vnam value 'AUART'.


    READ TABLE it_key_tab INTO wa_key_tab INDEX 1.
    IF sy-subrc EQ 0.
      LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
        LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
          CASE <ls_filter>-property.
            WHEN lc_auart.
              lv_auart = <ls_filter_opt>-low.
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    IF lv_auart IS INITIAL.
      lst_auart-sign = lc_i.
      lst_auart-option = lc_eq.
      lst_auart-low = 'ZSTU'.
      APPEND lst_auart TO lir_auart.

      lst_auart-sign = lc_i.
      lst_auart-option = lc_eq.
      lst_auart-low = 'ZUNI'.
      APPEND lst_auart TO lir_auart.
    ENDIF.

*---get the order type
    SELECT * FROM tvakt
    INTO CORRESPONDING FIELDS OF TABLE li_orders
       WHERE  spras = sy-langu
        AND auart IN lir_auart OR auart EQ lv_auart.

    SORT li_orders[] BY auart bezei.
    LOOP AT  li_orders INTO lst_orders.
      APPEND lst_orders TO et_entityset.
      CLEAR:lst_orders.
    ENDLOOP.

    SORT et_entityset BY auart.

  ENDMETHOD.


  METHOD shiptoset_get_entityset.

    DATA: lst_entity TYPE zcl_zqtco_orders_apl_mpc=>ts_shipto,
          lv_kunnr   TYPE kunnr.

    CONSTANTS: lc_kunwe TYPE rvari_vnam VALUE 'KUNWE'.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>) .
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN lc_kunwe.
            lv_kunnr = <ls_filter_opt>-low.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lv_kunnr IS NOT INITIAL.
      SELECT b~partner1, k~name1, k~name2
             INTO TABLE @DATA(li_kna1)
             FROM kna1 AS k INNER JOIN but050 AS b
             ON b~partner1 = k~kunnr
                WHERE b~partner2 EQ @lv_kunnr AND b~reltyp = 'ZIR002'.
      IF sy-subrc EQ 0.
        LOOP AT li_kna1 INTO DATA(lst_kna1).
          lst_entity-kunwe = lst_kna1-partner1.
          lst_entity-name1 = lst_kna1-name1.
          lst_entity-name2 = lst_kna1-name2.
          APPEND lst_entity TO et_entityset.
          CLEAR: lst_entity, lst_kna1.
        ENDLOOP.
        APPEND lst_entity TO et_entityset.
        SORT et_entityset BY kunwe.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD soldtoset_get_entityset.

    DATA: lst_entity TYPE zcl_zqtco_orders_apl_mpc=>ts_soldto,
          lir_kunnr  TYPE TABLE OF kun_range,
          lst_kunnr  TYPE kun_range.

    CONSTANTS: lc_kunnr TYPE rvari_vnam VALUE 'KUNNR'.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN lc_kunnr.
            lst_kunnr-sign = <ls_filter_opt>-sign.
            lst_kunnr-option = <ls_filter_opt>-option.
            lst_kunnr-kunnr_low = <ls_filter_opt>-low.
            lst_kunnr-kunnr_high = <ls_filter_opt>-high.
            APPEND lst_kunnr TO lir_kunnr.
            CLEAR: lst_kunnr.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SELECT k~kunnr, k~name1, k~name2,
           b~reltyp, b~date_from, b~date_to
           INTO TABLE @DATA(li_kna1)
           FROM kna1 AS k INNER JOIN but050 AS b
           ON   k~kunnr = b~partner2
           WHERE b~reltyp = 'ZIR002'
           AND b~date_from LE @sy-datum
           AND b~date_to GE @sy-datum
          AND kunnr IN @lir_kunnr.
    IF sy-subrc EQ 0.
      DELETE ADJACENT DUPLICATES FROM li_kna1 COMPARING kunnr.
      IF li_kna1 IS NOT INITIAL.
        LOOP AT li_kna1 INTO DATA(lst_kna1).
          lst_entity-kunnr = lst_kna1-kunnr.
          lst_entity-name1 = lst_kna1-name1.
          lst_entity-name2 = lst_kna1-name2.
          APPEND lst_entity TO et_entityset.
          CLEAR: lst_kna1, lst_entity.
        ENDLOOP.
        APPEND lst_entity TO et_entityset.
        SORT et_entityset BY kunnr.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
