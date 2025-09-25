class ZCL_ZQTCO_BLOCKORDERS__DPC_EXT definition
  public
  inheriting from ZCL_ZQTCO_BLOCKORDERS__DPC
  create public .

public section.
protected section.

  methods BILLINGBLOCKSET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods TIMESET_GET_ENTITYSET
    redefinition .
  methods ZCACONSTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTCO_BLOCKORDERS__DPC_EXT IMPLEMENTATION.


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

* Get Orders Billing status
            SELECT vbeln,fksak FROM vbuk
              INTO TABLE @DATA(li_vbuk)
              FOR ALL ENTRIES IN @it_orders
              WHERE vbeln = @it_orders-vbeln
                AND ( fksak EQ 'A' OR fksak EQ 'B').
            IF sy-subrc EQ 0.
              SORT li_vbuk[] BY vbeln.
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

      READ TABLE li_vbuk INTO DATA(lst_vbuk) WITH KEY vbeln = wa_orders-vbeln BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR:wa_orders.
        CONTINUE.
      ENDIF.

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


  METHOD soldtoset_get_entityset.

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

    CONSTANTS: lc_cp TYPE char2 VALUE 'CP',
               lc_i  TYPE char1 VALUE 'I'.



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

  ENDMETHOD.


  METHOD timeset_get_entityset.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
               lc_time  TYPE rvari_vnam VALUE 'TIME'.

    SELECT
         low
         FROM zcaconstant
         INTO TABLE et_entityset
         WHERE devid  = lc_devid
           AND param1 = lc_time.
  ENDMETHOD.


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
ENDCLASS.
