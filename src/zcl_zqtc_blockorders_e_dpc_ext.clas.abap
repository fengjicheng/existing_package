class ZCL_ZQTC_BLOCKORDERS_E_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_BLOCKORDERS_E_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods BBHEADERSET_GET_ENTITYSET
    redefinition .
  methods BILLINGBLOCKSET_GET_ENTITYSET
    redefinition .
  methods CONTRACTTYPESET_GET_ENTITYSET
    redefinition .
  methods CREATEDBYSET_GET_ENTITYSET
    redefinition .
  methods DELREASONSET_GET_ENTITYSET
    redefinition .
  methods DUNNINGPROCEDURE_GET_ENTITYSET
    redefinition .
  methods DUNNINGREPORTCHA_GET_ENTITYSET
    redefinition .
  methods DUNNINGREPORTSET_GET_ENTITYSET
    redefinition .
  methods MATERIALSET_GET_ENTITYSET
    redefinition .
  methods ORDERDATA_V23SET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
  methods REPORTAUTHSET_GET_ENTITYSET
    redefinition .
  methods SALESGROUPSET_GET_ENTITYSET
    redefinition .
  methods SALESOFFICESET_GET_ENTITYSET
    redefinition .
  methods SDDOCSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods SORG45SET_GET_ENTITYSET
    redefinition .
  methods TIMESET_GET_ENTITYSET
    redefinition .
  methods V23CONSTSET_GET_ENTITYSET
    redefinition .
  methods VA45CONSTSET_GET_ENTITYSET
    redefinition .
  methods VA45_ALLITEMSSET_GET_ENTITYSET
    redefinition .
  methods VA45_REJECTITEMS_GET_ENTITYSET
    redefinition .
  methods VA45_SUMSET_GET_ENTITYSET
    redefinition .
  methods ZCACONSTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_BLOCKORDERS_E_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
*-----------------------------------------------------------------------------------
*METHOD NAME        : /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
*METHOD DESCRIPTION : Creating Devliery Blcoking for selected Sales Documents
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*
    DATA: lst_bapisdh1x TYPE bapisdh1x.
    DATA: lst_bapisdh1 TYPE bapisdh1,
          lv_vbeln     TYPE vbeln.
    DATA:lt_return TYPE TABLE OF bapiret2.
    DATA:lt_return2 TYPE TABLE OF bapiret2.
    DATA:lt_so TYPE edm_vbeln_range_tt.
    DATA:lst_so TYPE edm_vbeln_range.

    DATA: lt_item   TYPE TABLE OF   bapisditm,
          lt_itemx  TYPE TABLE OF  bapisditmx,
          lst_itemx TYPE   bapisditmx,
          lst_item  TYPE   bapisditm.
    DATA : BEGIN OF  li_orders.
             INCLUDE TYPE zcl_zqtc_blockorders_e_mpc=>ts_conheader.
             DATA: conitemset TYPE zcl_zqtc_blockorders_e_mpc=>tt_conitem,
           END OF li_orders.


    DATA:  lv_cnt     TYPE i.
    DATA : lst_orders    LIKE  li_orders,
           lst_orders2   LIKE  li_orders,
           lv_lifsk      TYPE lifsk,
           lv_entity_set TYPE /iwbep/mgw_tech_name,
           lst_itm_msg   TYPE zcl_zqtc_blockorders_e_mpc=>ts_conitem.

    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).

* Import Input
    io_data_provider->read_entry_data( IMPORTING es_data  = lst_orders ).

    CASE lv_entity_set.
      WHEN 'ConHeaderSet'.
        LOOP AT  lst_orders-conitemset  ASSIGNING FIELD-SYMBOL(<lst_input>).

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_input>-vbeln
            IMPORTING
              output = lv_vbeln.
          CLEAR:lst_so.
          lst_so-low = lv_vbeln.
          lst_so-sign = 'I'.
          lst_so-option = 'EQ'.

          APPEND lst_so TO lt_so.
          CLEAR lv_vbeln.
        ENDLOOP.

        IF lt_so[] IS NOT INITIAL.
          SELECT vbeln FROM vbak INTO TABLE @DATA(lt_vbak)
            WHERE vbeln IN @lt_so.
        ENDIF.
*---Looping the ITEM level contracts
        LOOP AT lt_vbak INTO DATA(lst_vbak).
*          BAPI Header
          lst_bapisdh1-dlv_block = lst_orders-del_reason.  "Delivery Reason
          lst_bapisdh1x-dlv_block = abap_true.
          lst_bapisdh1x-updateflag = 'U'.

          CLEAR:lv_vbeln.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbak-vbeln
            IMPORTING
              output = lv_vbeln.


*          AT END OF vbeln.
            FREE:lt_return[].
            CALL FUNCTION 'BAPI_SALESORDER_CHANGE'    "Update the delivery reason for existing Contarct
              EXPORTING
                salesdocument    = lv_vbeln
                order_header_in  = lst_bapisdh1
                order_header_inx = lst_bapisdh1x
              TABLES
*                order_item_in    = lt_item
*                order_item_inx   = lt_itemx
                return           = lt_return.
*----Checking the return messages
            READ TABLE lt_return INTO DATA(lst_return) WITH  KEY type = 'E'.
            IF sy-subrc = 0.
              CLEAR:lv_cnt.
              LOOP AT lt_return INTO lst_return WHERE type = 'E'.
                lv_cnt = lv_cnt + 1.
                lst_itm_msg-type = 'Error'(001).
                CASE lv_cnt.
                  WHEN 1.
                    lst_itm_msg-msg1 = lst_return-message.
                  WHEN 2.
                    lst_itm_msg-msg2 = lst_return-message_v1.
                  WHEN 3.
                    lst_itm_msg-msg3 = lst_return-message_v2.
                  WHEN 4.
                  WHEN OTHERS.
                ENDCASE.
              ENDLOOP.

            ELSE.
              READ TABLE lt_return INTO lst_return WITH  KEY type = 'A'.
              IF sy-subrc = 0.
                CLEAR:lv_cnt.
                LOOP AT lt_return INTO lst_return WHERE type = 'E'.
                  lv_cnt = lv_cnt + 1.
                  lst_itm_msg-type = 'Error'(001).

                  CASE lv_cnt.
                    WHEN 1.
                      lst_itm_msg-msg1 = lst_return-message.
                    WHEN 2.
                      lst_itm_msg-msg2 = lst_return-message_v1.
                    WHEN 3.
                      lst_itm_msg-msg3 = lst_return-message_v2.
                    WHEN 4.
                    WHEN OTHERS.
                  ENDCASE.
                ENDLOOP.
              ELSE.
*--commiting delivery reason
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                  EXPORTING
                    wait = abap_true.
                LOOP AT lst_orders-conitemset ASSIGNING FIELD-SYMBOL(<lst_input1>) WHERE vbeln = lv_vbeln.
                  <lst_input1>-type = 'Success'(002).
                  <lst_input1>-msg1 = 'Contract blocked Successfully'(003).
                  <lst_input1>-vbeln = lv_vbeln.
                  SELECT SINGLE vbeln FROM vbuv INTO @DATA(lv_vbeln_in)
                    WHERE vbeln = @lv_vbeln.
                  IF sy-subrc EQ 0.
                    <lst_input1>-msg2 = 'Contract is Incomplete'(004) .
                  ENDIF.

                  SELECT SINGLE faksk FROM vbak INTO @DATA(lv_faksk)
                    WHERE vbeln = @lv_vbeln.
                  IF sy-subrc EQ 0 AND lv_faksk IS NOT INITIAL.
                    <lst_input1>-msg3 = 'Contract has Blocked'(005) .
                  ENDIF.
                ENDLOOP.
              ENDIF.
            ENDIF.


            IF lst_itm_msg-type = 'Error'(001).
              LOOP AT lst_orders-conitemset ASSIGNING <lst_input1> WHERE vbeln = lv_vbeln.
                <lst_input1>-type = 'Error'(001).
                <lst_input1>-msg1 = lst_return-message.
                <lst_input1>-msg2 = lst_return-message_v1.
                <lst_input1>-msg3 = lst_return-message_v2.
              ENDLOOP.
            ENDIF.
            CLEAR:lst_itm_msg,lst_return.
*          ENDAT.
          CLEAR:lst_itm_msg,lst_return.
        ENDLOOP.

*---return the update to front application
        copy_data_to_ref(
          EXPORTING
              is_data = lst_orders
          CHANGING
              cr_data = er_deep_entity ).
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD bbheaderset_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: BBHEADERSET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*

    DATA: lst_entity TYPE zcl_zqtc_blockorders_e_mpc=>ts_bbheader.
*-----------------Search help entries for Billing Block----------------*
    SELECT faksp, vtext FROM tvfst INTO TABLE @DATA(li_tvfst) WHERE spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      LOOP AT li_tvfst INTO DATA(lst_tvfst).
        lst_entity-faksk = lst_tvfst-faksp.
        lst_entity-fakskt = lst_tvfst-vtext.
        APPEND lst_entity TO et_entityset.
        CLEAR: lst_entity, lst_tvfst.
      ENDLOOP.
      SORT et_entityset BY faksk.
    ENDIF.
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
          lr_vkorg   TYPE sd_vkorg_ranges,
          lst_vkorg  TYPE sdsls_vkorg_range,
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

* Get all authorized Sales Orgs
*    CALL FUNCTION 'ZQTC_AUTH_SALESORG'
*      EXPORTING
*        im_uname = sy-uname
*      TABLES
*        et_vkorg = lr_vkorg.

    CASE iv_entity_set_name.
      WHEN 'BillingBlockSet'.
* Red Inputs from UI5 Front end
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
* Fetch all Billing Block Orders as per inputs
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
*             AND vbak~vkorg IN lr_vkorg.
          IF sy-subrc EQ 0.
            DATA(li_ord2) = it_orders[].
            SORT li_ord2 BY kunnr.
            DELETE ADJACENT DUPLICATES FROM li_ord2 COMPARING kunnr.
* Fetch BP Blocks for respective Sales Area
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
* Get Order Type Descriptions
      SELECT auart,bezei FROM tvakt INTO TABLE @DATA(lt_tvak)
        FOR ALL ENTRIES IN @it_orders
        WHERE auart = @it_orders-auart
        AND spras = @sy-langu.

      IF sy-subrc EQ 0.
        SORT lt_tvak BY auart.
      ENDIF.
* Get BP Block descriptions
      SELECT faksp,vtext FROM tvfst
        INTO TABLE @DATA(li_tvfs)
        WHERE spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_tvfs BY faksp.

      ENDIF.

    ENDIF.

    SORT it_orders[] BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM  it_orders COMPARING vbeln .
* Get Host and Port for Hyperlink
    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

* Fill final table
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


  METHOD contracttypeset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: CONTRACTTYPESET_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*



    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA:lv_auart TYPE auart.

    DATA:it_orderstyp TYPE zcl_zqtc_blockorders_e_mpc=>tt_contracttype.
    DATA:wa_orderstyp TYPE zcl_zqtc_blockorders_e_mpc=>ts_contracttype.
    DATA  : wa_key_tab TYPE  /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO wa_key_tab INDEX 1.


    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Auart'.     "Sales Document Type
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
    IF lv_auart = 'Key2'.

* Fetch constant entries
      SELECT * FROM zcaconstant INTO TABLE @DATA(li_auart)
        WHERE devid = 'E266'
          AND param1 = 'AUART'
          AND param2 = 'ZQTC_VA45'
          AND activate = @abap_true.
      IF li_auart[] IS NOT INITIAL.
        SELECT * FROM tvakt
        INTO CORRESPONDING FIELDS OF TABLE it_orderstyp
          FOR ALL ENTRIES IN li_auart
           WHERE  spras = sy-langu
            AND auart eq li_auart-low+0(4).

        SORT it_orderstyp[] BY auart bezei.
        LOOP AT  it_orderstyp INTO wa_orderstyp.


          APPEND wa_orderstyp TO et_entityset.
          CLEAR:wa_orderstyp.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD createdbyset_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: CREATEDBYSET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*
    DATA: lst_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_createdby.
*-----------------Search help entries for User Name----------------*
    SELECT  us~bname, us~persnumber, ad~name_first, ad~name_last
             INTO TABLE @DATA(li_uname)
            FROM usr21 AS us INNER JOIN adrp AS ad
            ON ad~persnumber = us~persnumber.
    IF sy-subrc = 0.
      DELETE ADJACENT DUPLICATES FROM li_uname COMPARING persnumber.
      IF li_uname IS NOT INITIAL.
        LOOP AT li_uname INTO DATA(lst_uname).
          lst_entity-ernam = lst_uname-bname.
          CONCATENATE lst_uname-name_first lst_uname-name_last INTO lst_entity-uname
          SEPARATED BY ' '.
          APPEND lst_entity TO et_entityset.
          CLEAR: lst_entity, lst_uname.
        ENDLOOP.
        SORT et_entityset BY ernam.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD delreasonset_get_entityset.
*-----------------------------------------------------------------------------------
*METHOD NAME        : DELREASONSET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report -Delivery Reasons possible values F4
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*
    SELECT lifsp
           vtext
      FROM tvlst
      INTO CORRESPONDING FIELDS OF TABLE  et_entityset
      WHERE spras = sy-langu.


  ENDMETHOD.


  method DUNNINGPROCEDURE_GET_ENTITYSET.
    DATA: lw_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_dunningprocedure.
    CLEAR lw_entity.
    SELECT mahna,
           textm
      FROM t047t
      INTO TABLE @DATA(lt_mahna)
     WHERE spras EQ @sy-langu.
    IF  sy-subrc IS INITIAL
    AND lt_mahna IS NOT INITIAL.
      LOOP AT lt_mahna
        ASSIGNING FIELD-SYMBOL(<fs_mahna>).
        lw_entity-mahna = <fs_mahna>-mahna.
        lw_entity-textm = <fs_mahna>-textm.
        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.
      ENDLOOP.
    ENDIF.

  endmethod.


  METHOD dunningreportcha_get_entityset.

*-----------------------------------------------------------------------------------
*METHOD NAME        : DUNNINGREPORTCHA_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report - Bar chart view with No .of Invoice count
*                     Based on the month and year
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*
    TYPES:BEGIN OF ty_count,
            date  TYPE char6,
            count TYPE char6,
            vbeln TYPE vbeln,
            xref1 TYPE char10,
          END OF ty_count.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
    DATA: lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          lst_entity   TYPE zcl_zqtc_blockorders_e_mpc=>ts_dunningreport.
    DATA: lr_mahna     TYPE RANGE OF mahna,
          lst_mahna    LIKE LINE OF lr_mahna,
          lv_auart     TYPE auart,
          lr_kunnr     TYPE range_kunnr_tab,
          lst_kunnr    TYPE range_kunnr_wa,
          lr_date      TYPE date_t_range,
          lst_date     TYPE date_range,
          lr_vkgrp     TYPE RANGE OF vkgrp,
          lst_vkgrp    LIKE LINE OF lr_vkgrp,
          lr_mahns     TYPE RANGE OF mahns_d,
          lr_mahns_inv TYPE RANGE OF mahns_d,
          lst_mahns    LIKE LINE OF lr_mahns,
          lr_parvw     TYPE RANGE OF parvw,
          lr_auart     TYPE tms_t_auart_range,
          lst_auart    TYPE tms_s_auart_range,
          lr_vkbur     TYPE edm_vkbur_range_tt,
          lst_vkbur    TYPE edm_vkbur_range,
          lv_stdate    TYPE erdat,
          lv_endate    TYPE erdat,
          lst_parvw    LIKE LINE OF lr_parvw,
          lst_matnr    TYPE curto_matnr_range,
          lr_matnr     TYPE STANDARD TABLE OF curto_matnr_range,
          lv_kunnr     TYPE kunnr,
          lr_xref2     TYPE RANGE OF xref2,
          lst_xref2    LIKE LINE OF lr_xref2,
          lv_flag      TYPE char4.

    DATA:li_count  TYPE STANDARD TABLE OF ty_count,
         lst_count TYPE ty_count.

    DATA: lv_count TYPE char6,
          lv_vbeln TYPE vbeln,
          lv_date  TYPE char6.
    DATA :lv_host TYPE string.
    DATA :lv_port  TYPE string.
    DATA: gc_devid   TYPE zdevid      VALUE 'E266',
          gc_mahns   TYPE c LENGTH 5 VALUE 'MAHNS',
          gc_parvw   TYPE c LENGTH 5 VALUE 'PARVW',
          lc_i       TYPE char1    VALUE 'I',
          lc_eq      TYPE char2    VALUE 'EQ',
          lc_bt      TYPE char2    VALUE 'BT',
          lc_vbtyp_g TYPE char1    VALUE 'G',
          lc_vbtyp_m TYPE char1    VALUE 'M'.

    "Select Options
    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Matnr'.
            IF <ls_filter_opt>-low NE 'null'.
              lst_matnr-sign   = lc_i.
              lst_matnr-option = lc_eq.
              lst_matnr-low    = <ls_filter_opt>-low.
              CONDENSE :lst_matnr-low.
              CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                EXPORTING
                  input  = lst_matnr-low
                IMPORTING
                  output = lst_matnr-low.
              APPEND lst_matnr TO lr_matnr.
              CLEAR lst_matnr.
            ENDIF.
          WHEN 'Mahns'.
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahns-sign   = lc_i.
              lst_mahns-option = lc_eq.
              IF <ls_filter_opt>-low = '>'.
                lst_mahns-option = 'GT'.
                lst_mahns-low = '5'.
              ELSE.
                lst_mahns-low = <ls_filter_opt>-low.
              ENDIF.
              APPEND lst_mahns TO lr_mahns.
              CLEAR:lst_mahns.
            ENDIF.
          WHEN 'Mahna'.
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahna-sign   = lc_i.
              lst_mahna-option = lc_eq.
              lst_mahna-low = <ls_filter_opt>-low.
              APPEND lst_mahna TO lr_mahna.
              CLEAR:lst_mahna.
            ENDIF.

          WHEN 'Kunnr'.
            lv_kunnr = <ls_filter_opt>-low.
            IF lv_kunnr NE 0 AND lv_kunnr NE 'null' AND lv_kunnr IS NOT INITIAL.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lv_kunnr
                IMPORTING
                  output = lv_kunnr.

              lst_kunnr-sign   = lc_i.
              lst_kunnr-option = lc_eq.
              lst_kunnr-low = lv_kunnr.
              APPEND lst_kunnr TO lr_kunnr.
            ENDIF.
          WHEN 'Auart'.
            lv_auart = <ls_filter_opt>-low.
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign   = lc_i.
              lst_auart-option = lc_eq.
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
          WHEN 'Vkbur'. "Sales Office
            CLEAR:lst_vkbur.
            IF  <ls_filter_opt>-low NE 'null' AND <ls_filter_opt>-low IS NOT INITIAL.
              lst_vkbur-sign = lc_i.
              lst_vkbur-option = lc_eq.
              lst_vkbur-low = <ls_filter_opt>-low.
              APPEND lst_vkbur TO lr_vkbur.
            ENDIF.
          WHEN 'Mahns1'. "Invoice Dunning Level
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahns-sign   = lc_i.
              lst_mahns-option = lc_eq.
              IF <ls_filter_opt>-low = '>'.
                lst_mahns-option = 'GT'.
                lst_mahns-low = '5'.
              ELSE.
                lst_mahns-low = <ls_filter_opt>-low.
              ENDIF.
              APPEND lst_mahns TO lr_mahns_inv.
              CLEAR:lst_mahns.
            ENDIF.
          WHEN 'Vkgrp'. "Sales Group
            CLEAR:lst_vkgrp.
            IF  <ls_filter_opt>-low NE 'null' AND <ls_filter_opt>-low IS NOT INITIAL.
              lst_vkgrp-sign = lc_i.
              lst_vkgrp-option = lc_eq.
              lst_vkgrp-low = <ls_filter_opt>-low.
              APPEND lst_vkgrp TO lr_vkgrp.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.


    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      lst_date-low = lv_stdate.
      lst_date-high = lv_endate.
      lst_date-option = lc_bt.
      lst_date-sign = lc_i.
      APPEND lst_date TO lr_date.
    ENDIF.

    "Fetch SoldToBPIDs from
    SELECT kunnr,
           bukrs,
           mahna,
           mahns
      FROM knb5
      INTO TABLE @DATA(li_knb5)
     WHERE mahna IN @lr_mahna
      AND kunnr IN @lr_kunnr
       AND mahns IN @lr_mahns.
    IF li_knb5 IS NOT INITIAL.
      " Fetch sold to BP id other details from BSID for above fetched
      " entries
      SELECT b~bukrs,
             a~kunnr,
             b~kunag,
             b~gjahr,
             a~augbl,
             a~belnr,
             b~vbeln,
             b~xblnr,
             a~wrbtr,
             a~waers,
             b~zlsch,
             b~erdat
        FROM bsid AS a
        INNER JOIN vbrk AS b
          ON  b~vbeln EQ a~belnr
          AND b~kunrg EQ a~kunnr
        INTO TABLE @DATA(li_final)
         FOR ALL ENTRIES IN @li_knb5
       WHERE a~kunnr EQ @li_knb5-kunnr
         AND a~augbl EQ @space
         AND b~erdat IN @lr_date
         AND a~manst IN @lr_mahns_inv
         AND b~vbtyp = @lc_vbtyp_m
         AND b~fksto = @abap_false.
      IF  li_final IS NOT INITIAL.
        "Fetch some other details from VBRP table for all entries of BSID
        SELECT vbrp~vbeln,
               vbrp~posnr,
               vbrp~netwr,
               vbrp~kzwi6,
               vbrp~matnr,
               vbrp~matkl,
               vbrp~pstyv,
               vbrp~vkgrp,
               vbrp~kdgrp_auft,
               vbrp~vgbel,
               vbrp~vgpos,
               vbak~auart
           INTO TABLE @DATA(li_vbrp)
          FROM vbrp
          INNER JOIN vbak ON vbak~vbeln = vbrp~vgbel
           FOR ALL ENTRIES IN @li_final
         WHERE vbrp~vbeln EQ @li_final-belnr
           AND vbrp~vkgrp IN @lr_vkgrp
           AND vbrp~matnr IN @lr_matnr
           AND vbak~auart IN @lr_auart
           AND vbak~vbtyp = @lc_vbtyp_g
           AND vbak~vkbur IN @lr_vkbur.
        IF  sy-subrc IS INITIAL.
          SORT li_vbrp  BY vbeln.
        ENDIF.
      ENDIF.
    ENDIF.


*---Looping theDunning internal table and get the invoice count based on invoice
    SORT li_final BY erdat.
    LOOP AT li_final INTO DATA(lst_final).
      lst_count-vbeln = lst_final-vbeln.
      lst_count-date = lst_final-erdat+0(6).
      lst_count-count = 1.
      READ TABLE li_vbrp INTO DATA(lst_vbrp)  WITH KEY vbeln = lst_final-vbeln BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT li_vbrp  INTO lst_vbrp FROM lv_tabix.
          IF lst_vbrp-vbeln NE lst_final-vbeln.
            EXIT.
          ENDIF.
          lst_count-xref1  = lst_vbrp-vgbel.
          lv_count = lv_count + 1.
          APPEND lst_count TO li_count.
        ENDLOOP.
        CLEAR lst_entity.
      ENDIF.
    ENDLOOP.
*--getting the invoice count based on month and year
    SORT li_count BY date.
    LOOP AT li_count INTO lst_count.
      lst_entity-date = lst_count-date.
      lst_entity-xref1 = lst_count-xref1.
      lst_entity-vbeln = lst_count-vbeln.
      AT END OF vbeln.
        lst_entity-count = lst_count-count + lst_entity-count.
      ENDAT.
      AT END OF date.
        CONDENSE:lst_entity-count.
        APPEND lst_entity TO  et_entityset.
        CLEAR:lst_entity.
      ENDAT.
    ENDLOOP.


  ENDMETHOD.


  METHOD dunningreportset_get_entityset.
*-----------------------------------------------------------------------------------
*METHOD NAME        : DUNNINGREPORTSET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*
    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
    DATA: lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          lst_entity   TYPE zcl_zqtc_blockorders_e_mpc=>ts_dunningreport.
    DATA: lr_mahna     TYPE RANGE OF mahna,
          lst_mahna    LIKE LINE OF lr_mahna,
          lv_auart     TYPE auart,
          lr_kunnr     TYPE range_kunnr_tab,
          lr_vkbur     TYPE edm_vkbur_range_tt,
          lst_vkbur    TYPE edm_vkbur_range,
          lst_kunnr    TYPE range_kunnr_wa,
          lr_date      TYPE date_t_range,
          lst_date     TYPE date_range,
          lr_vkgrp     TYPE RANGE OF vkgrp,
          lst_vkgrp    LIKE LINE OF lr_vkgrp,
          lr_mahns     TYPE RANGE OF mahns_d,
          lr_mahns_inv TYPE RANGE OF mahns_d,
          lst_mahns    LIKE LINE OF lr_mahns,
          lr_parvw     TYPE RANGE OF parvw,
          lr_auart     TYPE tms_t_auart_range,
          lst_auart    TYPE tms_s_auart_range,
          lv_stdate    TYPE erdat,
          lv_endate    TYPE erdat,
          lst_parvw    LIKE LINE OF lr_parvw,
          lst_matnr    TYPE curto_matnr_range,
          lr_matnr     TYPE STANDARD TABLE OF curto_matnr_range,
          lv_kunnr     TYPE kunnr,
          lr_xref2     TYPE RANGE OF xref2,
          lst_xref2    LIKE LINE OF lr_xref2,
          lv_flag      TYPE char4.
    DATA: gc_devid   TYPE zdevid      VALUE 'E266',
          gc_mahns   TYPE c LENGTH 5  VALUE 'MAHNS',
          gc_parvw   TYPE c LENGTH 5  VALUE 'PARVW',
          lc_header  TYPE posnr       VALUE '000000',
          lc_i       TYPE char1       VALUE 'I',
          lc_vbtyp_g TYPE char1       VALUE 'G',
          lc_vbtyp_m TYPE char1       VALUE 'M',
          lc_eq      TYPE char2       VALUE 'EQ',
          lc_bt      TYPE char2       VALUE 'BT',
          lc_land    TYPE char2       VALUE 'GB',
          gc_xref2   TYPE c LENGTH 9 VALUE 'SALESTYPE',
          lc_va43    TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN=',
          lc_vf03    TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VF03%20VBRK-VBELN=',
          lc_sold    TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=BP%20BUS_JOEL_MAIN-CHANGE_NUMBER=',
          lc_ship    TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=BP%20BUS_JOEL_MAIN-CHANGE_NUMBER='.
    DATA: lv_count TYPE i,
          lv_vbeln TYPE vbeln.
    DATA :lv_host TYPE string.
    DATA :lv_port    TYPE string,
          lv_netdate TYPE  bseg-zfbdt.

    "Select Options
    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'Matnr'.  "Matreial
            IF <ls_filter_opt>-low NE 'null'.
              lst_matnr-sign   = lc_i.
              lst_matnr-option = lc_eq.
              lst_matnr-low    = <ls_filter_opt>-low.
              CONDENSE:lst_matnr-low.
              CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                EXPORTING
                  input  = lst_matnr-low
                IMPORTING
                  output = lst_matnr-low.
              APPEND lst_matnr TO lr_matnr.
              CLEAR lst_matnr.
            ENDIF.
          WHEN 'Mahns'. "Customer Dunning Level
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahns-sign   = lc_i.
              lst_mahns-option = lc_eq.
              IF <ls_filter_opt>-low = '>'.
                lst_mahns-option = 'GT'.
                lst_mahns-low = '5'.
              ELSE.
                lst_mahns-low = <ls_filter_opt>-low.
              ENDIF.
              APPEND lst_mahns TO lr_mahns.
              CLEAR:lst_mahns.
            ENDIF.
          WHEN 'Mahna'.  "Dunning Process
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahna-sign   = lc_i.
              lst_mahna-option = lc_eq.
              lst_mahna-low = <ls_filter_opt>-low.
              APPEND lst_mahna TO lr_mahna.
              CLEAR:lst_mahna.
            ENDIF.

          WHEN 'Kunnr'. "Customer
            lv_kunnr = <ls_filter_opt>-low.
            IF lv_kunnr NE 0 AND lv_kunnr NE 'null' AND lv_kunnr IS NOT INITIAL.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lv_kunnr
                IMPORTING
                  output = lv_kunnr.

              lst_kunnr-sign   = lc_i.
              lst_kunnr-option = lc_eq.
              lst_kunnr-low = lv_kunnr.
              APPEND lst_kunnr TO lr_kunnr.
            ENDIF.
          WHEN 'Auart'. "Sales Order Type
            lv_auart = <ls_filter_opt>-low.
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = lc_i.
              lst_auart-option = lc_eq.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart.
            ENDIF.
          WHEN 'Stdate'.   "Start Date
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'. "EndDate
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Vkbur'. "Sales Office
            CLEAR:lst_vkbur.
            IF  <ls_filter_opt>-low NE 'null' AND <ls_filter_opt>-low IS NOT INITIAL.
              lst_vkbur-sign = lc_i.
              lst_vkbur-option = lc_eq.
              lst_vkbur-low = <ls_filter_opt>-low.
              APPEND lst_vkbur TO lr_vkbur.
            ENDIF.
          WHEN 'Mahns1'. "Invoice Dunning Level
            IF <ls_filter_opt>-low NE 'null'.
              lst_mahns-sign   = lc_i.
              lst_mahns-option = lc_eq.
              IF <ls_filter_opt>-low = '>'.
                lst_mahns-option = 'GT'.
                lst_mahns-low = '5'.
              ELSE.
                lst_mahns-low = <ls_filter_opt>-low.
              ENDIF.
              APPEND lst_mahns TO lr_mahns_inv.
              CLEAR:lst_mahns.
            ENDIF.
          WHEN 'Vkgrp'. "Sales Group
            CLEAR:lst_vkgrp.
            IF  <ls_filter_opt>-low NE 'null' AND <ls_filter_opt>-low IS NOT INITIAL.
              lst_vkgrp-sign = lc_i.
              lst_vkgrp-option = lc_eq.
              lst_vkgrp-low = <ls_filter_opt>-low.
              APPEND lst_vkgrp TO lr_vkgrp.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

*---Preparing Date Range table
    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      lst_date-low = lv_stdate.
      lst_date-high = lv_endate.
      lst_date-option = lc_bt.
      lst_date-sign = lc_i.
      APPEND lst_date TO lr_date.
    ENDIF.

    "Fetch SoldToBPIDs from
    SELECT kunnr,
           bukrs,
           mahna,
           mahns
      FROM knb5
      INTO TABLE @DATA(li_knb5)
     WHERE mahna IN @lr_mahna
       AND mahns IN @lr_mahns
       AND kunnr IN @lr_kunnr.
    IF li_knb5 IS NOT INITIAL.
      " Fetch sold to BP id other details from BSID for above fetched
      " entries
      SELECT b~bukrs,
             a~kunnr,
             b~kunag,
             b~gjahr,
             a~augbl,
             a~belnr,
             b~vbeln,
             b~xblnr,
             a~wrbtr,
             a~waers,
             b~zlsch,
             b~erdat,
             b~zterm
        FROM bsid AS a
        INNER JOIN vbrk AS b
          ON  b~vbeln EQ a~belnr
          AND b~kunrg EQ a~kunnr
        INTO TABLE @DATA(li_final)
         FOR ALL ENTRIES IN @li_knb5
       WHERE a~kunnr EQ @li_knb5-kunnr
         AND a~augbl EQ @space
         AND a~manst IN @lr_mahns_inv
         AND b~erdat IN @lr_date
         AND b~vbtyp = @lc_vbtyp_m
         AND b~fksto = @abap_false.
      IF  li_final IS NOT INITIAL.
        "Fetch some other details from VBRP table for all entries of BSID
        SELECT vbrp~vbeln,
               vbrp~posnr,
               vbrp~netwr,
               vbrp~kzwi6,
               vbrp~matnr,
               vbrp~matkl,
               vbrp~pstyv,
               vbrp~vkgrp,
               vbrp~kdgrp_auft,
               vbrp~vgbel,
               vbrp~vgpos,
               vbrp~vgtyp,
               vbak~auart,
               vbak~lifsk,
               vbak~vkbur,
               vbkd~bsark
           INTO TABLE @DATA(li_vbrp)
          FROM vbrp
          INNER JOIN vbak ON vbak~vbeln = vbrp~vgbel
          INNER JOIN vbkd ON vbkd~vbeln = vbrp~vgbel
           FOR ALL ENTRIES IN @li_final
         WHERE vbrp~vbeln EQ @li_final-belnr
           AND vbrp~vkgrp IN @lr_vkgrp
           AND vbrp~matnr IN @lr_matnr
           AND vbak~auart IN @lr_auart
           AND vbak~vbtyp = @lc_vbtyp_g
           AND vbak~vkbur IN @lr_vkbur
.
        IF  sy-subrc IS INITIAL AND li_vbrp IS NOT INITIAL.
          SORT li_vbrp  BY vbeln.
*---get the contrat start and end dates
          SELECT vbeln,
                 vposn,
                 vbegdat,
                 venddat
            FROM veda
            INTO TABLE @DATA(li_veda)
            FOR ALL ENTRIES IN @li_vbrp
             WHERE vbeln EQ @li_vbrp-vgbel.
          IF sy-subrc = 0.
            SORT li_veda BY vbeln vposn.
          ENDIF.
        ENDIF.

        IF  li_final IS NOT INITIAL.
          "Sold To BP ID Address fields and other address details
          SELECT kunnr,
                 name1,
                 ort01,
                 land1,
                 pstlz,
                 stras
            FROM kna1
            INTO TABLE @DATA(li_kna1)
             FOR ALL ENTRIES IN @li_final
           WHERE kunnr EQ @li_final-kunnr.
          IF  sy-subrc IS INITIAL.
            SORT li_kna1 BY kunnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    "Ship To BPID details from VBPA table.
    IF li_final IS NOT INITIAL.
      SELECT vbeln,
             kunnr,
             posnr,
             lifnr
        FROM vbpa
        INTO TABLE @DATA(li_vbpa)
         FOR ALL ENTRIES IN @li_final
       WHERE vbeln EQ @li_final-vbeln
         AND parvw = 'WE'.
      IF sy-subrc IS INITIAL.
        SORT li_vbpa BY vbeln posnr.
      ENDIF.
    ENDIF.
    "Getting Material Description
    IF li_vbrp IS NOT INITIAL.
      SELECT matnr,
             maktx
        FROM makt
        INTO TABLE @DATA(li_makt)
         FOR ALL ENTRIES IN @li_vbrp
       WHERE matnr EQ @li_vbrp-matnr
        AND spras  EQ @sy-langu.
      IF sy-subrc IS INITIAL.
        SORT li_makt BY matnr.
      ENDIF.
    ENDIF.
*---get the Customer group text
    SELECT * FROM t151t INTO TABLE @DATA(li_t151t) WHERE spras = @sy-langu.
*---get the salesgroup text
    SELECT vkgrp,
           bezei
      FROM tvgrt
      INTO TABLE @DATA(li_salesgroup)
     WHERE spras EQ @sy-langu.
*----Payment Method text
    SELECT zlsch,
           text1
    FROM t042z
    INTO TABLE @DATA(li_t042z)
    WHERE land1 = @lc_land.
*--get delivery block
    SELECT lifsp,
           vtext
     FROM tvlst
     INTO TABLE @DATA(li_tvlst)
     WHERE spras = @sy-langu.
*---get potype text
    SELECT bsark,
             vtext
       FROM t176t
       INTO TABLE @DATA(li_potype)
       WHERE spras = @sy-langu.
*---get sales office text
    SELECT vkbur,
         bezei
    FROM tvkbt
    INTO TABLE @DATA(li_salesoffice)
   WHERE spras EQ @sy-langu.

    SORT : li_t151t BY kdgrp,
           li_salesoffice BY vkbur,
           li_salesgroup BY vkgrp,
           li_t042z      BY zlsch.

* get host and port for hyperlink
    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

*    "Loop final Internal table to get required final fields
    SORT li_final BY erdat.
    LOOP AT li_final INTO DATA(lst_final).
      lst_entity-kunnr = lst_final-kunnr.
      IF lv_vbeln  NE lst_final-vbeln.
        CLEAR lv_vbeln.
        lv_vbeln = lst_final-vbeln.
        lst_entity-count = 1.
      ELSE.
        CLEAR lst_entity-count.
      ENDIF.

*---get the Invoice Due Date
      FREE:lv_netdate.
      CALL FUNCTION 'J_1A_SD_CI_DUEDATE_GET'
        EXPORTING
          iv_vbeln                 = lst_final-vbeln
          iv_zterm                 = lst_final-zterm
        IMPORTING
          ev_netdate               = lv_netdate
        EXCEPTIONS
          fi_document_not_found    = 1
          payment_terms_incomplete = 2
          invoice_not_found        = 3
          OTHERS                   = 4.
      IF sy-subrc <> 0.
      ELSE.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lv_netdate
          IMPORTING
            output = lst_entity-due_date.
      ENDIF.
      lst_entity-days_beyond = sy-datum - lv_netdate. "Days Beyond Terms

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_final-erdat
        IMPORTING
          output = lst_entity-erdat.

      READ TABLE li_kna1  INTO DATA(lst_kna1)  WITH KEY kunnr = lst_entity-kunnr BINARY SEARCH.
      IF  sy-subrc = 0.
        lst_entity-name1 = lst_kna1-name1.      " Name
        lst_entity-ort01 = lst_kna1-ort01.      "City
        lst_entity-land1 = lst_kna1-land1.      "Country
        lst_entity-post_code1 = lst_kna1-pstlz. "Postal Code
        lst_entity-stras = lst_kna1-stras.       "Street
      ENDIF.
      lst_entity-vbeln = lst_final-vbeln.        " Invoice number
      "prabhu
      " lst_entity-invoice_value = lst_final-wrbtr.  "Net value
      lst_entity-currency = lst_final-waers.        "Currency
      READ TABLE li_t042z INTO DATA(lst_t042) WITH KEY zlsch = lst_final-zlsch BINARY SEARCH.
      IF sy-subrc = 0.
        CONCATENATE lst_t042-zlsch lst_t042-text1 INTO
            lst_entity-zlsch SEPARATED BY '-'.     "Payment Method
      ENDIF.

      READ TABLE li_vbrp INTO DATA(lst_vbrp)  WITH KEY vbeln = lst_final-vbeln BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT li_vbrp  INTO lst_vbrp FROM lv_tabix.
          IF lst_vbrp-vbeln NE lst_final-vbeln.
            EXIT.
          ENDIF.
          CLEAR:lst_entity-matnr,
                lst_entity-vgtyp,
                lst_entity-vgtyp,
                lst_entity-vkgrp,
                lst_entity-kdgrp,
                lst_entity-netwr,
                lst_entity-xref1,
                lst_entity-kzwi6,
                lst_entity-con_ed_date,
                lst_entity-con_st_date,
                lst_entity-invoice_value. "Prabhu
          lst_entity-invoice_value = lst_vbrp-netwr.  "net value
          lst_entity-posnr  = lst_vbrp-posnr.     "Line number
          lst_entity-auart  = lst_vbrp-auart.    "Sales Doc Type
          lst_entity-matnr  = lst_vbrp-matnr.    "material
          lst_entity-xref1  = lst_vbrp-vgbel.     "Contarct Number
          lst_entity-date   = lst_final-erdat+0(6). "Date - Montha n Year
          lst_entity-pstyv  = lst_vbrp-pstyv.
          lst_entity-vkbur  = lst_vbrp-vkbur . "Sales Office
          lst_entity-bsark  = lst_vbrp-bsark . "PO type
          READ TABLE li_veda INTO DATA(lst_veda) WITH  KEY vbeln = lst_vbrp-vgbel
                                                           vposn = lst_vbrp-vgpos BINARY SEARCH.
          IF sy-subrc = 0.
            lst_entity-con_ed_date  = lst_veda-venddat.  "Contarct Start date
            lst_entity-con_st_date  = lst_veda-vbegdat.   "Contract enddate
          ELSE.
            READ TABLE li_veda INTO lst_veda WITH  KEY vbeln = lst_vbrp-vgbel
                                                       vposn = lc_header BINARY SEARCH.
            IF sy-subrc = 0.
              lst_entity-con_ed_date  = lst_veda-venddat.  "Contarct enddate
              lst_entity-con_st_date  = lst_veda-vbegdat.   "Contract Start date
            ENDIF.
          ENDIF.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_entity-con_ed_date
            IMPORTING
              output = lst_entity-con_ed_date.

          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_entity-con_st_date
            IMPORTING
              output = lst_entity-con_st_date.

          READ TABLE li_vbpa  INTO DATA(lst_vbpa)   WITH KEY vbeln = lst_vbrp-vbeln
                                                             posnr = lst_vbrp-posnr BINARY SEARCH.
          IF sy-subrc = 0.
            lst_entity-ship_to = lst_vbpa-kunnr.   "Ship to party Number
          ELSE.
            READ TABLE li_vbpa  INTO lst_vbpa   WITH KEY vbeln = lst_vbrp-vbeln BINARY SEARCH.
            IF sy-subrc = 0.
              lst_entity-ship_to = lst_vbpa-kunnr. "Ship to party Number
            ENDIF.
          ENDIF.
          READ TABLE li_makt INTO DATA(lst_makt) WITH KEY matnr = lst_vbrp-matnr BINARY SEARCH.
          IF   sy-subrc IS INITIAL.
            lst_entity-maktx = lst_makt-maktx.   "material description
          ENDIF.
          lst_entity-vgtyp      = lst_vbrp-vgtyp.     "Item Categoryy
          READ TABLE li_salesgroup  INTO DATA(lst_salesgroup) WITH KEY vkgrp = lst_vbrp-vkgrp BINARY SEARCH.
          IF sy-subrc = 0.
            "sales Group
            CONCATENATE lst_vbrp-vkgrp '-' lst_salesgroup-bezei INTO lst_entity-vkgrp SEPARATED BY space. "Sales group
          ENDIF.
          READ TABLE li_t151t  INTO DATA(lst_t151t) WITH KEY kdgrp =  lst_vbrp-kdgrp_auft BINARY SEARCH.
          IF sy-subrc = 0.
            "Customer group
            CONCATENATE lst_vbrp-kdgrp_auft
                        lst_t151t-ktext
                        INTO lst_entity-kdgrp SEPARATED BY '-'.
          ENDIF.
          CONCATENATE 'http://'
                        lv_host ':'
                        lv_port lc_va43 lst_entity-xref1
                        INTO lst_entity-linkref.
          CONCATENATE 'http://'
                      lv_host ':'
                      lv_port lc_vf03 lst_entity-vbeln
                      INTO lst_entity-linkref1.
          CONCATENATE 'http://'
                      lv_host ':'
                      lv_port lc_sold lst_entity-kunnr
                      INTO lst_entity-linkref2.
          CONCATENATE 'http://'
                      lv_host ':'
                      lv_port lc_ship lst_entity-ship_to
                      INTO lst_entity-linkref3.
          READ TABLE li_tvlst INTO DATA(lst_tvlst) WITH KEY lifsp = lst_vbrp-lifsk BINARY SEARCH.
          IF sy-subrc = 0.
            CONCATENATE lst_vbrp-lifsk '-' lst_tvlst-vtext INTO lst_entity-delv_block SEPARATED BY space.
          ENDIF.
          READ TABLE li_salesoffice INTO DATA(lst_salesoffice) WITH KEY vkbur = lst_vbrp-vkbur BINARY SEARCH.
          IF sy-subrc = 0.
            CONCATENATE lst_salesoffice-vkbur '-' lst_salesoffice-bezei INTO lst_entity-vkbur1 SEPARATED BY space.
          ENDIF.
          READ TABLE li_potype INTO DATA(lst_potype) WITH KEY bsark = lst_vbrp-bsark BINARY SEARCH.
          IF sy-subrc = 0 AND lst_potype-vtext IS NOT INITIAL.
            CONCATENATE lst_vbrp-bsark '-' lst_potype-vtext INTO lst_entity-bsark1 SEPARATED BY space.
          ENDIF.
          APPEND lst_entity TO et_entityset.
        ENDLOOP.
        CLEAR lst_entity.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD materialset_get_entityset.
*-----------------------------------------------------------------------------------
*METHOD NAME        : MATERIALSET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report - Material possible values F4
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*
    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_maxrow TYPE bapi_epm_max_rows.

    DATA:lst_matnr TYPE curto_matnr_range,
         lst_maktx TYPE fip_s_maktx_range,
         lir_maktx TYPE fip_t_maktx_range,
         lir_mtart TYPE fip_t_mtart_range,
         lst_mtart TYPE fip_s_mtart_range,
         lv_maktx  TYPE maktx,
         lv_matnr  TYPE matnr,
         lst_final TYPE zcl_zirm_pricing_repor_mpc=>ts_prod,
         lir_matnr TYPE STANDARD TABLE OF curto_matnr_range.

    CONSTANTS: lc_eq    TYPE char2 VALUE 'EQ',
               lc_cp    TYPE char2 VALUE 'CP',
               lc_i     TYPE char1 VALUE 'I',
               "lc_devid TYPE zdevid VALUE 'R126',
               lc_mtart TYPE rvari_vnam  VALUE 'MTART'.


    FREE:lst_final,
         lst_matnr,
         lst_mtart,
         lir_mtart,
         lst_maktx,
         lir_maktx,
         lst_final,
         lir_matnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Maktx '.
            CLEAR lst_matnr.
            lst_maktx-low = <ls_filter_opt>-low.
            IF lst_maktx-low NE 'null'.
              lst_maktx-sign = lc_i.
              lv_matnr  = <ls_filter_opt>-low.
              CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                EXPORTING
                  input  = lv_matnr
                IMPORTING
                  output = lv_matnr.
              lst_maktx-low  = lv_matnr.
              lst_maktx-option = lc_eq.
              APPEND lst_maktx TO lir_matnr.
              lst_maktx-option = lc_cp.
              lst_maktx-sign = lc_i.
              CONCATENATE '*' <ls_filter_opt>-low '*' INTO DATA(lv_value).
              lst_maktx-sign = lc_i.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_matnr.

              lst_maktx-option = lc_cp.
              lst_maktx-sign = lc_i.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
              TRANSLATE lv_value TO UPPER CASE.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_matnr.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
              lv_maktx =  <ls_filter_opt>-low.
              TRANSLATE lv_maktx+0(1) TO UPPER CASE.
              lst_maktx-low = lv_maktx.
              APPEND lst_maktx TO lir_maktx.
              CONCATENATE '*' lv_maktx '*' INTO lv_maktx.
              lst_maktx-low = lv_maktx.
              APPEND lst_maktx TO lir_maktx.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

*----Get the material details
    IF lir_maktx IS NOT INITIAL
      OR lir_matnr IS NOT INITIAL.
      SELECT mara~matnr,
             makt~maktx
        FROM mara
        INNER JOIN makt ON makt~matnr = mara~matnr
        INTO TABLE @DATA(li_code)
        WHERE mara~matnr IN @lir_matnr
          OR makt~maktx IN @lir_maktx
          OR makt~maktg IN @lir_maktx
          AND makt~spras = @sy-langu
          AND mara~mtart IN @lir_mtart.

    ELSE.

      SELECT mara~matnr,
            makt~maktx
       FROM mara
       INNER JOIN makt ON makt~matnr = mara~matnr
       INTO TABLE @li_code
       WHERE mara~matnr IN @lir_matnr
         OR makt~maktx IN @lir_maktx
        AND makt~spras = @sy-langu
         AND mara~mtart IN @lir_mtart.
    ENDIF.

    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.

    IF lv_total > 0.
      LOOP AT li_code INTO DATA(lst_code)  FROM lv_skip TO lv_total.
        lst_final-matnr = lst_code-matnr.
        lst_final-maktx = lst_code-maktx.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ELSE.
      LOOP AT li_code INTO lst_code .
        lst_final-matnr = lst_code-matnr.
        lst_final-maktx = lst_code-maktx.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ENDIF.


    SORT et_entityset BY matnr maktx.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING matnr maktx..
  ENDMETHOD.


  METHOD orderdata_v23set_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: ORDERDATA_V23SET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*
**
**    FIELD-SYMBOLS:
**      <ls_filter>     LIKE LINE OF it_filter_select_options,
**      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
**
**    DATA: lir_kunnr  TYPE STANDARD TABLE OF kun_range,
**          lst_kunnr  TYPE kun_range,
**          lir_faksk  TYPE /iwbep/t_cod_select_options,
**          lst_faksk  TYPE /iwbep/s_cod_select_option,
**          lir_vkorg  TYPE STANDARD TABLE OF range_vkorg,
**          lst_vkorg  TYPE range_vkorg,
**          lir_vkbur  TYPE STANDARD TABLE OF tds_rg_vkbur,
**          lst_vkbur  TYPE tds_rg_vkbur,
**          lir_vkgrp  TYPE STANDARD TABLE OF tds_rg_vkgrp,
**          lst_vkgrp  TYPE tds_rg_vkgrp,
**          lir_ernam  TYPE STANDARD TABLE OF tds_rg_ernam,
**          lst_ernam  TYPE tds_rg_ernam,
**          lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
**          lst_erdat  TYPE tds_rg_erdat,
**          lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
**          lst_vbeln  TYPE range_vbeln,
**          lv_selcrit TYPE flag,
**          lv_erdat   TYPE string.
**
**    CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
**               lc_a      TYPE c VALUE 'A',
**               lc_b      TYPE c VALUE 'B',
**               lc_c      TYPE c VALUE 'C',
**               lc_g      TYPE c VALUE 'G',
**               lc_k      TYPE c VALUE 'K',
**               lc_l      TYPE c VALUE 'L',
**               lc_va02     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
**               lc_va42     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN=',
**               lc_va12     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
**               lc_va22     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN='.
**
**
**    DATA: lv_rundays TYPE i,
**          lv_low     TYPE sy-datum,
**          lv_var1    TYPE string,
**          lv_var2    TYPE string,
**          lv_csdate  TYPE c LENGTH 10,
**          lv_cedate  TYPE c LENGTH 10,
**          lv_sdate   TYPE sy-datum,
**          lv_edate   TYPE sy-datum,
**          lv_vbeln   TYPE vbeln,
**          lv_host    type String,
**          lv_port    type String,
**          lv_vbtyp   type vbtyp.
**
***-------------------------- Filters to have selection criteria --------------------------*
**
**    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
**      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
**        CASE <ls_filter>-property.
**          WHEN 'KUNNR'. "Customer
**            lst_kunnr-sign = <ls_filter_opt>-sign.
**            lst_kunnr-option = <ls_filter_opt>-option.
**            lst_kunnr-kunnr_low = <ls_filter_opt>-low.
**            lst_kunnr-kunnr_high = <ls_filter_opt>-high.
**            APPEND lst_kunnr TO lir_kunnr.
**            CLEAR: lst_kunnr.
**          WHEN 'FAKSK'. "Billing block header
**            lst_faksk-sign = <ls_filter_opt>-sign.
**            lst_faksk-option = <ls_filter_opt>-option.
**            lst_faksk-low = <ls_filter_opt>-low.
**            lst_faksk-high = <ls_filter_opt>-high.
**            APPEND lst_faksk TO lir_faksk.
**            CLEAR: lst_faksk.
**          WHEN 'VKORG'. "Sales Org
**            lst_vkorg-sign = <ls_filter_opt>-sign.
**            lst_vkorg-option = <ls_filter_opt>-option.
**            lst_vkorg-low = <ls_filter_opt>-low.
**            lst_vkorg-high = <ls_filter_opt>-high.
**            APPEND lst_vkorg TO lir_vkorg.
**            CLEAR: lst_vkorg.
**          WHEN 'VKBUR'. "Sales Office
**            lst_vkbur-sign = <ls_filter_opt>-sign.
**            lst_vkbur-option = <ls_filter_opt>-option.
**            lst_vkbur-low = <ls_filter_opt>-low.
**            lst_vkbur-high = <ls_filter_opt>-high.
**            APPEND lst_vkbur TO lir_vkbur.
**            CLEAR: lst_vkbur.
**          WHEN 'VKGRP'. "Sales Group
**            lst_vkgrp-sign = <ls_filter_opt>-sign.
**            lst_vkgrp-option = <ls_filter_opt>-option.
**            lst_vkgrp-low = <ls_filter_opt>-low.
**            lst_vkgrp-high = <ls_filter_opt>-high.
**            APPEND lst_vkgrp TO lir_vkgrp.
**            CLEAR: lst_vkgrp.
**          WHEN 'ERNAM'. "Created By.
**            lst_ernam-sign = <ls_filter_opt>-sign.
**            lst_ernam-option = <ls_filter_opt>-option.
**            lst_ernam-low = <ls_filter_opt>-low.
**            lst_ernam-high = <ls_filter_opt>-high.
**            APPEND lst_ernam TO lir_ernam.
**            CLEAR: lst_ernam.
**          WHEN 'ERDAT'. "Created Date.
**            lv_erdat = <ls_filter_opt>-low.
**            SPLIT lv_erdat AT ' , ' INTO lv_var1 lv_var2.
**            CONDENSE lv_var1 NO-GAPS.
**            CONDENSE lv_var2 NO-GAPS.
**            CONCATENATE lv_var1+6(4)
**                        lv_var1+3(2)
**                        lv_var1+0(2)
**                        INTO lv_csdate.
**            CONCATENATE lv_var2+6(4)
**                        lv_var2+3(2)
**                        lv_var2+0(2)
**                        INTO lv_cedate.
**            lst_erdat-sign = <ls_filter_opt>-sign.
**            lst_erdat-option = 'BT'.
**            lst_erdat-low = lv_csdate.
**            lst_erdat-high = lv_cedate.
**            APPEND lst_erdat TO lir_erdat.
**            CLEAR: lst_erdat.
**          WHEN 'VBELN'. "SD doc.
**            lst_vbeln-sign = <ls_filter_opt>-sign.
**            lst_vbeln-option = <ls_filter_opt>-option.
**            lst_vbeln-low = <ls_filter_opt>-low.
**            lst_vbeln-high = <ls_filter_opt>-high.
**            APPEND lst_vbeln TO lir_vbeln.
**            CLEAR: lst_vbeln.
**          WHEN 'SELCRITERIA'. "Selection  Criteria.
**            lv_selcrit = <ls_filter_opt>-low.
**          WHEN OTHERS.
**            " Do nothing.
**        ENDCASE.
**      ENDLOOP.
**    ENDLOOP.
**
**    TYPES: BEGIN OF lty_header,
**             col1  TYPE vbeln_va,
**             col2  TYPE string,
**             col3  TYPE string,
**             col4  TYPE string,
**             col5  TYPE string,
**             col6  TYPE string,
**             col7  TYPE string,
**             col8  TYPE string,
**             col9  TYPE string,
**             col10 TYPE string,
**             col11 TYPE string,
**             col12 TYPE string,
**             col13 TYPE string,
**             col14 TYPE string,
**             col15 TYPE string,
**           END OF lty_header.
**
**    DATA: li_data      TYPE STANDARD TABLE OF lty_header,
**          lst_data      TYPE lty_header,
**          li_selection TYPE TABLE OF rsparams,
**          lst_selection LIKE LINE OF  li_selection,
**          lst_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_orderdata_v23.
**
**
***-------------------------- Fetch data from constant table ---------------------*
**
**    SELECT param1, param2, srno, sign, opti, low, high
**          FROM zcaconstant
**          INTO TABLE @DATA(li_const) WHERE devid = @lc_devid
**          AND param2 = 'V23'
**          AND activate = @abap_true.
**
**    IF sy-subrc EQ 0.
**      LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
**        CASE <lfs_const>-param1.
**          WHEN 'VKORG'. "Sales Org
**            IF lir_vkorg IS INITIAL.
**              APPEND INITIAL LINE TO lir_vkorg ASSIGNING FIELD-SYMBOL(<lfs_vkorg_i>).
**              <lfs_vkorg_i>-sign = <lfs_const>-sign.
**              <lfs_vkorg_i>-option = <lfs_const>-opti.
**              <lfs_vkorg_i>-low = <lfs_const>-low.
**              <lfs_vkorg_i>-high = <lfs_const>-high.
**            ENDIF.
**          WHEN 'DAYS2'. "Created date
**            IF lir_erdat IS INITIAL.
**              CONDENSE <lfs_const>-low NO-GAPS.
**              lv_rundays = <lfs_const>-low.
**              lv_sdate = sy-datum - lv_rundays.
**              lv_edate = sy-datum.
**            ELSEIF lir_erdat IS NOT INITIAL.
**              lv_sdate = lv_csdate.
**              lv_edate = lv_cedate.
**            ENDIF.
**        ENDCASE.
**      ENDLOOP.
**    ENDIF.
***------------------------- Get server info ---------------------------------*
**    cl_http_server=>if_http_server~get_location(
**     IMPORTING host = lv_host
**            port = lv_port ).
***------------------------- Passing default selection criteria ---------------------*
**
**    CLEAR: lst_kunnr, lst_faksk, lst_vkorg, lst_vkbur,
**           lst_vkgrp, lst_ernam, lst_erdat, lst_vbeln.
**
**    LOOP AT lir_kunnr INTO lst_kunnr. "Customer
**      lst_selection-selname = 'KUNNR'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_kunnr-kunnr_low.
**      APPEND lst_selection TO li_selection.
**      CLEAR:lst_selection, lst_kunnr.
**    ENDLOOP.
**
**    LOOP AT lir_faksk INTO lst_faksk. "Billing block header
**      lst_selection-selname = 'FAKSK'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_faksk-low.
**      APPEND lst_selection TO li_selection.
**      CLEAR:lst_selection, lst_faksk.
**    ENDLOOP.
**
**    LOOP AT lir_vkorg INTO lst_vkorg. "Sales Organization
**      lst_selection-selname = 'VKORG'.
**      lst_selection-kind    = 'P'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_vkorg-low.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection, lst_vkorg.
**    ENDLOOP.
**
**    LOOP AT lir_vkbur INTO lst_vkbur. "Sales Office
**      lst_selection-selname = 'VKBUR'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_vkbur-low.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection, lst_vkbur.
**    ENDLOOP.
**
**    LOOP AT lir_vkgrp INTO lst_vkgrp. "Sales Group
**      lst_selection-selname = 'VKGRP'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_vkgrp-low.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection, lst_vkgrp.
**    ENDLOOP.
**
**    IF lir_ernam IS INITIAL.  " Entered by
**      lst_selection-selname = 'ERNAM'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'NE'.
**      CLEAR:lst_selection-low    .
**      APPEND lst_selection TO li_selection.
**      CLEAR lst_selection.
**    ELSEIF lir_ernam IS NOT INITIAL.
**      LOOP AT lir_ernam INTO lst_ernam.
**        lst_selection-selname = 'ERNAM'.
**        lst_selection-kind    = 'S'.
**        lst_selection-sign    = 'I'.
**        lst_selection-option  = 'EQ'.
**        lst_selection-low     = lst_ernam-low.
**        APPEND lst_selection TO li_selection.
**        CLEAR lst_selection.
**      ENDLOOP.
**    ENDIF.
**
**    lst_selection-selname = 'ERDAT'. "Entered On
**    lst_selection-kind    = 'S'.
**    lst_selection-sign    = 'I'.
**    lst_selection-option  = 'BT'.
**    lst_selection-low     = lv_sdate.
**    lst_selection-high     = lv_edate.
**    APPEND lst_selection TO li_selection.
**    CLEAR: lst_selection, lv_sdate, lv_edate.
**
**    LOOP AT lir_vbeln INTO lst_vbeln. "SD document
**      lst_selection-selname = 'VBELN'.
**      lst_selection-kind    = 'S'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = lst_vbeln-low.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection, lst_vbeln.
**    ENDLOOP.
**
**    IF lv_selcrit IS NOT INITIAL. "If Selection Criteria filter is provided
**      lst_selection-selname = 'OPEN_VB'.
**      lst_selection-kind    = 'P'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = abap_true.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection.
**
**      lst_selection-selname = 'ALL_VB'.
**      lst_selection-kind    = 'P'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = abap_false.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection.
**
**    ELSEIF lv_selcrit IS INITIAL. "If Selection Criteria filter is not provided
**      lst_selection-selname = 'OPEN_VB'.
**      lst_selection-kind    = 'P'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = abap_false.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection.
**
**      lst_selection-selname = 'ALL_VB'.
**      lst_selection-kind    = 'P'.
**      lst_selection-sign    = 'I'.
**      lst_selection-option  = 'EQ'.
**      lst_selection-low     = abap_true.
**      APPEND lst_selection TO li_selection.
**      CLEAR: lst_selection.
**
**    ENDIF.
**
**    CLEAR lst_selection.
**
**    lst_selection-selname = 'VBTYP'. "SD document category
**    lst_selection-kind    = 'S'.
**    lst_selection-sign    = 'I'.
**    lst_selection-option  = 'NE'.
**    CLEAR:lst_selection-low     .
**    APPEND lst_selection TO li_selection.
**    CLEAR: lst_selection.
**
***--------------------  Call V23 to pull SD documents blocked for billing ------------------*
**    SUBMIT sdfakspe
**           WITH SELECTION-TABLE li_selection
**           EXPORTING LIST TO MEMORY AND RETURN.
**
**    DATA:list TYPE STANDARD TABLE OF abaplist.
**
**
**    DATA: txtlines TYPE TABLE OF char2048.
**
***------------------------ Get Prepared list from memory -----------------------*
**
**    CALL FUNCTION 'LIST_FROM_MEMORY'
**      TABLES
**        listobject = list
**      EXCEPTIONS
**        not_found  = 1
**        OTHERS     = 2.
**
**    IF sy-subrc EQ 0.
***---------------------- Convert a (Saved) List Object to ASCI -------------------*
**      CALL FUNCTION 'LIST_TO_ASCI'
**        EXPORTING
**          list_index         = -1
**        TABLES
**          listasci           = txtlines        "lt_out
**          listobject         = list
**        EXCEPTIONS
**          empty_list         = 1
**          list_index_invalid = 2
**          OTHERS             = 3.
**
**      IF sy-subrc EQ 0.
***----------------------------- Split the ASCI data -------------------------------*
**        LOOP AT txtlines INTO DATA(ls_text).
**          ls_text+0(1) = ''.
**          IF sy-tabix > 8.
**            CONDENSE ls_text.
**            SPLIT ls_text AT '|' INTO
**            lst_data-col1
**            lst_data-col2
**            lst_data-col3
**            lst_data-col4
**            lst_data-col5
**            lst_data-col6
**            lst_data-col7
**            lst_data-col8
**            lst_data-col9
**            lst_data-col10
**            lst_data-col11
**            lst_data-col12
**            lst_data-col13
**            lst_data-col14.
**
**            CLEAR:lv_vbeln.
**            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**              EXPORTING
**                input  = lst_data-col1
**              IMPORTING
**                output = lv_vbeln.
**            .
**            IF sy-subrc EQ 0.
**              lst_data-col1 = lv_vbeln.
**            ENDIF.
**            APPEND lst_data TO li_data.
**            CLEAR: lst_data, lst_entity.
**          ENDIF.
**        ENDLOOP.
**
**        DELETE li_data WHERE col2 IS INITIAL.
**        SORT li_data BY col1.
**        IF li_data IS NOT INITIAL.
**
***------------------------- Get header level data for the above set of orders ----------------*
**          SELECT vbeln, vbtyp, vkorg, vkbur, vkgrp
**                 INTO TABLE @DATA(li_vbak)
**                 FROM vbak
**                  FOR ALL ENTRIES IN @li_data  WHERE vbeln EQ @li_data-col1.
**          IF sy-subrc = 0.
**            SORT li_vbak BY vbeln.
**          ENDIF.
**          IF li_vbak IS NOT INITIAL.
***----------------------------- Get document flow ------------------------------*
**            SELECT vbeln, vbelv, vbtyp_n
**                   FROM vbfa
**                   INTO TABLE @DATA(li_vbfa)
**                   FOR ALL ENTRIES IN @li_vbak
**                   WHERE vbelv = @li_vbak-vbeln AND
**                         vbtyp_n = 'M'.
**            IF sy-subrc EQ 0.
**              SORT li_vbfa BY vbeln vbelv.
**            ENDIF.
***---------------------------- Get item level data ------------------------------*
**            SELECT vbeln, posnr, mvgr5, abgru INTO TABLE @DATA(li_vbap)
**                   FROM vbap
**                   FOR ALL ENTRIES IN @li_vbak
**                   WHERE vbeln = @li_vbak-vbeln.
**            IF sy-subrc = 0.
**              SORT li_vbap BY vbeln posnr.
**            ENDIF.
***------------------------------ Get business data -------------------------------*
**            SELECT vbeln, posnr, konda, bsark, bstkd
**                   INTO TABLE @DATA(li_vbkd)
**                   FROM vbkd
**                   FOR ALL ENTRIES IN @li_vbak
**                   WHERE vbeln = @li_vbak-vbeln.
**            IF sy-subrc = 0.
**              SORT li_vbkd BY vbeln posnr.
**            ENDIF.
***-------------------------------- Get contract data -------------------------------*
**            SELECT vbeln, vposn, vkuegru, vbegdat
**                   INTO TABLE @DATA(li_veda)
**                   FROM veda
**                   FOR ALL ENTRIES IN @li_vbak
**                   WHERE vbeln = @li_vbak-vbeln.
**            IF sy-subrc = 0.
**              SORT li_veda BY vbeln vposn.
**            ENDIF.
**
**          ENDIF.
***-------------------------------- Append the data to final entityset -----------------*
**          LOOP AT li_vbap INTO DATA(lst_vbap).
**            CLEAR: lst_data.
**            READ TABLE li_data INTO lst_data WITH KEY col1 = lst_vbap-vbeln BINARY SEARCH.
**            IF sy-subrc EQ 0.
**              lst_entity-vbeln      = lst_data-col1.
**              lst_entity-vbtyp      = lst_data-col2.
**              lst_entity-fakskt     = lst_data-col3.
**              lst_entity-erdat      = lst_data-col4.
**              lst_entity-kunnr      = lst_data-col5.
**              lst_entity-ernam      = lst_data-col6.
**              lst_entity-name1      = lst_data-col7.
**              lst_entity-faksk      = lst_data-col8.
**              lst_entity-delstat    = lst_data-col9.
**              lst_entity-auart      = lst_data-col10.
**              lst_entity-hblck      = lst_data-col11.
**              lst_entity-iblck      = lst_data-col12.
**              lst_entity-usblck     = lst_data-col13.
**              lst_entity-cblck      = lst_data-col14.
**            ENDIF.
**            READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lst_vbap-vbeln BINARY SEARCH.
**            IF sy-subrc EQ 0.
**              lst_entity-bdnum = lst_vbfa-vbeln.
**            ENDIF.
**            READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbap-vbeln
**                                                    BINARY SEARCH.
**            IF sy-subrc = 0.
**              lst_entity-konda = lst_vbkd-konda.
**              lst_entity-bsark = lst_vbkd-bsark.
**              lst_entity-bstkd = lst_vbkd-bstkd.
**            ENDIF.
**            READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_vbap-vbeln
**                                                     BINARY SEARCH.
**            IF sy-subrc EQ 0.
**              lst_entity-vbegdat = lst_veda-vbegdat.
**              lst_entity-year = lst_veda-vbegdat+0(4).
**            ENDIF.
**            READ TABLE li_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lst_vbap-vbeln BINARY SEARCH.
**            IF sy-subrc EQ 0.
**              IF lst_vbak-vbtyp = 'G'.
**                lst_entity-vkuegru = lst_veda-vkuegru.
**              ELSEIF lst_vbak-vbtyp = 'C'.
**                lst_entity-vkuegru = lst_vbap-abgru.
**              ENDIF.
**              lst_entity-vkorg = lst_vbak-vkorg.
**              lst_entity-vkbur = lst_vbak-vkbur.
**              lst_entity-vkgrp = lst_vbak-vkgrp.
**            ENDIF.
**            lst_entity-posnr = lst_vbap-posnr.
**            lst_entity-mvgr5 = lst_vbap-mvgr5.
**            lv_vbtyp = lst_vbak-vbtyp.
**            CASE lv_vbtyp.
**            WHEN lc_a.
**              lst_entity-vbtypt = 'Inquiry'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va12 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN lc_b.
**              lst_entity-vbtypt = 'Quotation'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va22 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN lc_c.
**              lst_entity-vbtypt = 'Order'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN lc_g.
**              lst_entity-vbtypt = 'Contract'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va42 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN lc_k.
**              lst_entity-vbtypt = 'Credit Memo Request'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN lc_l.
**              lst_entity-vbtypt = 'Debit Memo Request'.
**              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_vbap-vbeln INTO lst_entity-linkref.
**            WHEN OTHERS.
**              "Do nothing.
**          ENDCASE.
**            APPEND lst_entity TO et_entityset.
**            CLEAR: lst_entity, lst_data, lst_vbap, lst_veda, lst_vbak, lst_vbfa.
**          ENDLOOP.
**
**          SORT et_entityset BY vbeln posnr.
**
**        ENDIF.
**      ENDIF.
**    ENDIF.
***------------------------ Free the Saved list from memory --------------------------*
**
**    CALL FUNCTION 'LIST_FREE_MEMORY'.
**    IF sy-subrc EQ 0.
**    ENDIF.

  ENDMETHOD.


  METHOD ordertypeset_get_entityset.
*-----------------------------------------------------------------------------------
*METHOD NAME        : ORDERTYPESET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report - Order Type possible values F4
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*

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
*---get the order type
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


  METHOD reportauthset_get_entityset.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K927483
* REFERENCE NO: OTCM-44804/45066
* DEVELOPER: VDPATABALL
* DATE: 6/01/2022
* DESCRIPTION: Authorization for Unpaid Order report and App
*----------------------------------------------------------------------*
    DATA:lv_uname TYPE sy-uname.
    DATA:wa_auth TYPE zcl_zqtc_blockorders_e_mpc=>ts_reportauth.

    DATA :
      lv_field1 TYPE ust12-field VALUE 'ZBILL_BLCK',
*      lv_field2 TYPE ust12-field VALUE 'ZVA45_BLCK',
      lv_field3 TYPE ust12-field VALUE 'ZUNPAID_OR'.

    lv_uname  = sy-uname.
*** Check Authorization for Billing Block Tab to user
    AUTHORITY-CHECK OBJECT 'ZBILL_BLCK' FOR USER lv_uname ID 'ZBILL_BLCK' FIELD lv_field1.

    IF  syst-subrc = 0 .
      wa_auth-billing = abap_true.
    ENDIF.


*** Check Authorization for ZQTC_VA45(Contracts) Tab to user
**    AUTHORITY-CHECK OBJECT 'ZVA45_BLCK' FOR USER lv_uname ID 'ZVA45_BLCK' FIELD lv_field2.
**
**    IF  syst-subrc = 0 .
**      wa_auth-va45 = abap_true..
**    ENDIF.

    "Authority check for unapid orders
    AUTHORITY-CHECK OBJECT 'ZUNPAID_OR' FOR USER sy-uname ID 'ZUNPAID_OR' FIELD lv_field3.
    IF sy-subrc EQ 0.
      wa_auth-zunpaidor = abap_true.
    ENDIF.

    APPEND wa_auth TO et_entityset.

  ENDMETHOD.


  method SALESGROUPSET_GET_ENTITYSET.
*-----------------------------------------------------------------------------------
*METHOD NAME        : SALESGROUPSET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report -Sales Group possible values F4
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*

    DATA: lw_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_salesgroup.
    SELECT vkgrp,
           bezei
      FROM tvgrt
      INTO TABLE @DATA(lt_salesgroup)
     WHERE spras EQ @sy-langu.
    IF  sy-subrc      IS INITIAL
    AND lt_salesgroup IS NOT INITIAL.
      LOOP AT lt_salesgroup
        ASSIGNING FIELD-SYMBOL(<fs_salesgroup>).
        lw_entity-vkgrp = <fs_salesgroup>-vkgrp.
        lw_entity-bezei = <fs_salesgroup>-bezei.
        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.
      ENDLOOP.
    ENDIF.
  endmethod.


  METHOD salesofficeset_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: SALESOFFICESET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*

    DATA: lst_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_salesoffice.
*-----------------Search help entries for Sales Office----------------*
    SELECT vkbur,
           bezei
      FROM tvkbt
      INTO TABLE @DATA(li_salesoffice)
     WHERE spras EQ @sy-langu.

    IF  sy-subrc      IS INITIAL
    AND li_salesoffice IS NOT INITIAL.
      LOOP AT li_salesoffice
        ASSIGNING FIELD-SYMBOL(<fs_salesoffice>).
        lst_entity-vkbur = <fs_salesoffice>-vkbur.
        lst_entity-bezei = <fs_salesoffice>-bezei.
        APPEND lst_entity TO et_entityset.
        SORT et_entityset BY vkbur.
        CLEAR lst_entity.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD sddocset_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: V23CONSTSET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*

*---------------Search help Entries for Sales document-----------*
    IF is_paging IS NOT INITIAL.   "importing param only filled when $top $skip are used
      SELECT vbeln
             FROM vbak
             ORDER BY vbeln
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      OFFSET @is_paging-skip UP TO @is_paging-top ROWS.
    ELSE.
      SELECT vbeln FROM vbak
         INTO CORRESPONDING FIELDS OF TABLE et_entityset
         UP TO 100 ROWS.
      IF sy-subrc = 0.
        SORT et_entityset BY vbeln.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD soldtoset_get_entityset.
*-----------------------------------------------------------------------------------
*METHOD NAME        : SOLDTOSET_GET_ENTITYSET
*METHOD DESCRIPTION : Dunning Report -Customer/sold to  possible values F4
*DEVELOPER          : VDPATABALL
*CREATION DATE      : 10/20/2021
*OBJECT ID          : E266
*TRANSPORT NUMBER   : ED2K924803
*-----------------------------------------------------------------------------------
*REVISION HISTORY-----------------------------------
*REVISION NO  :
*DEVELOPER    :
*CHANGE DATE  :
*OBJECT ID    :
*&---------------------------------------------------------------------------------------*

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
               lc_eq TYPE char2 VALUE 'EQ',
               lc_i  TYPE char1 VALUE 'I'.



    FREE:lst_kunnr,
          lst_name,
          lir_name,
         lir_kunnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Name1'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_eq.
                lst_kunnr-sign = lc_i.
                 APPEND lst_kunnr TO lir_kunnr.
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

*---get the customer details
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
           AND but000~bu_group IN ( '0001' , '0002' , '0003' )
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
            AND but000~bu_group IN ( '0001' , '0002' , '0003' )
            AND but000~xblck = @abap_false.
      ENDIF.
    ELSE.
      SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE but000~bu_group IN ( '0001' , '0002' , '0003' )
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


  METHOD sorg45set_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: SORG45SET_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*

    CONSTANTS: lc_devid TYPE zdevid      VALUE 'E266' .
    CONSTANTS: lc_zqtc_va45 TYPE  rvari_vnam     VALUE 'ZQTC_VA45' .
    CONSTANTS: lc_vkorg TYPE  rvari_vnam     VALUE 'VKORG' .

    DATA:lst_tvkot TYPE zcl_zqtc_blockorders_e_mpc=>ts_sorg45.
    DATA:li_tvkot TYPE zcl_zqtc_blockorders_e_mpc=>tt_sorg45.
    DATA:lv_flag(4) TYPE c.
    DATA: lr_vkorg  TYPE sd_vkorg_ranges,
          lst_vkorg TYPE sdsls_vkorg_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'VTEXT'.
            lv_flag = <ls_filter_opt>-low+0(4).

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    IF lv_flag EQ 'Key2' OR lv_flag EQ 'Key4'.
* Fetch user authorized Sales Orgs
      DATA(lv_uname) = sy-uname.
      CALL FUNCTION 'ZQTC_AUTH_SALESORG'
        EXPORTING
          im_uname = lv_uname
        TABLES
          et_vkorg = lr_vkorg.

      IF sy-subrc EQ 0.
        SELECT vkorg vtext FROM tvkot INTO TABLE li_tvkot
        FOR ALL ENTRIES IN lr_vkorg
        WHERE spras = sy-langu
        AND vkorg = lr_vkorg-low.

        IF sy-subrc EQ 0.
          LOOP AT li_tvkot INTO lst_tvkot.

            APPEND lst_tvkot TO et_entityset.
            CLEAR lst_tvkot.
          ENDLOOP.
        ENDIF.
      ENDIF.
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


  METHOD v23constset_get_entityset.
*----------------------------------------------------------------------*
*This entityset is related to V23 Report
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925783
* REFERENCE NO: OTCM-55673
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE: 02/25/2022
* PROGRAM NAME: V23CONSTSET_GET_ENTITYSET
* DESCRIPTION: UI5 V23 Report
*----------------------------------------------------------------------*

**    CONSTANTS: lc_devid TYPE zdevid      VALUE 'E266' .
**    CONSTANTS: lc_days TYPE  rvari_vnam     VALUE 'DAYS2' .
**    CONSTANTS: lc_param2 TYPE  rvari_vnam     VALUE 'V23' .
**    DATA:lst_const TYPE zcl_zqtc_blockorders_e_mpc=>ts_v23const.
**
***----get constant entries---------*
**    SELECT devid, param1, param2, srno, sign, opti, low, high
**       FROM zcaconstant
**      INTO TABLE @DATA(li_constants)
**      WHERE devid = @lc_devid
**        AND param1 = @lc_days
**        AND param2 = @lc_param2
**        AND activate = @abap_true.
**
**    IF sy-subrc EQ 0.
**      SORT li_constants BY param1.
**      CLEAR:lst_const.
**      READ TABLE li_constants INTO DATA(lst_constants) WITH KEY param1 = lc_days BINARY SEARCH.
**      IF sy-subrc EQ 0.
**        lst_const-devid = lst_constants-devid.
**        lst_const-srno = lst_constants-srno.
**        lst_const-param1 = lst_constants-param1.
**        lst_const-param2 = lst_constants-param2.
**        lst_const-sign   = lst_constants-sign.
**        lst_const-opti = lst_constants-opti.
**        lst_const-low    = lst_constants-low.
**        APPEND lst_const TO et_entityset.
**        CLEAR lst_const.
**      ENDIF.
**    ENDIF.
  ENDMETHOD.


  METHOD va45constset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: VA45CONSTSET_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*

    CONSTANTS: lc_devid TYPE zdevid      VALUE 'E266' .
    CONSTANTS: lc_days TYPE  rvari_vnam     VALUE 'DAYS1' .
    CONSTANTS: lc_created TYPE  rvari_vnam     VALUE 'CREATED' .
    CONSTANTS: lc_param2 TYPE  rvari_vnam     VALUE 'ZQTC_VA45' .
    DATA:lst_const TYPE zcl_zsd_ordrs_mpc=>ts_zcaconst.
    DATA:lst_const2 TYPE zcl_zsd_ordrs_mpc=>ts_zcaconst.
    data:lv_date type sy-datum.
*----get constant entries

    SELECT * FROM zcaconstant
      INTO TABLE @DATA(li_constants)
      WHERE devid = @lc_devid
        AND param1 = @lc_days OR param1 = @lc_created
        AND param2 = @lc_param2
        AND activate = @abap_true.
    IF sy-subrc EQ 0.
      SORT li_constants BY param1.
      CLEAR:lst_const,lst_const2.

      READ TABLE li_constants INTO lst_const2 WITH KEY param1 = lc_days BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_const-devid = lst_const2-devid .
        lst_const-param1 = lst_const2-param1.
        lst_const-param2 = lst_const2-param2.
        lst_const-low    = lst_const2-low.

      ENDIF.

      CLEAR lst_const2.
      READ TABLE li_constants INTO lst_const2 WITH KEY param1 = lc_created BINARY SEARCH.

      IF sy-subrc EQ 0.
                CONDENSE :lst_const2-low NO-GAPS.

        lst_const-high    = lst_const2-low.
        CONDENSE :lst_const-low NO-GAPS, lst_const-high NO-GAPS.
        APPEND lst_const TO et_entityset.
        CLEAR lst_const.
      ENDIF.

      CLEAR:lst_const2.CLEAR lst_const.
      READ TABLE li_constants INTO lst_const2 WITH KEY param1 = lc_created BINARY SEARCH.
      IF sy-subrc EQ 0.
        CONDENSE :lst_const2-low NO-GAPS.
        lv_date = sy-datum - lst_const2-low.
        lst_const-devid = lst_const2-devid .
        lst_const-param1 = lst_const2-param1.
        lst_const-param2 = lst_const2-param2.
        lst_const-low    = lv_date.
        lst_const-high    = sy-datum.

        CONDENSE :lst_const-low NO-GAPS,lst_const-high NO-GAPS.
        APPEND lst_const TO et_entityset.
        CLEAR lst_const.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD va45_allitemsset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: VA45_ALLITEMSSET_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*


  DATA : lst_filter TYPE /iwbep/s_mgw_select_option,
         li_vbeln   TYPE /iwbep/t_cod_select_options.

  DATA : lw_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_va45_allitems.

  DATA : lv_host    TYPE string,
         lv_port    TYPE string,
         lw_linkref TYPE string.

  CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

  DATA : lv_uname TYPE sy-uname.
  DATA : lr_vkorg TYPE sd_vkorg_ranges,
         lv_abgru(4)  TYPE c.


  lv_uname = sy-uname.

*Authorization Checks on Sales Org
  CALL FUNCTION 'ZQTC_AUTH_SALESORG'
    EXPORTING
      im_uname = lv_uname
    TABLES
      et_vkorg = lr_vkorg.
  CLEAR lv_abgru.

  LOOP AT it_filter_select_options INTO lst_filter.
    CASE lst_filter-property.
      WHEN 'VBELN'.   "Sales Document
        li_vbeln = lst_filter-select_options.
      WHEN: 'ABGRU'.
      LOOP AT lst_filter-select_options INTO DATA(wa_options).
        lv_abgru = wa_options-low.
      ENDLOOP.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
    CLEAR lst_filter.
  ENDLOOP.


  cl_http_server=>if_http_server~get_location(
    IMPORTING host = lv_host
              port = lv_port ).

*Fetch Order Data at Item level
  SELECT vbeln, posnr, matnr,
          matkl, uepos, arktx,
          pstyv,  abgru, netwr,
          waerk, zmeng, vrkme,
          brgew, ntgew, gewei,
          netpr, kpein, kmein,
          mvgr1
        FROM vbap
        INTO TABLE @DATA(lt_vbap)
        WHERE vbeln IN @li_vbeln.

  IF sy-subrc EQ 0.
    SORT lt_vbap BY vbeln.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.
*Fetch Reason for rejection text
    SELECT abgru, bezei
        FROM tvagt
        INTO TABLE @DATA(lt_tvagt)
        FOR ALL ENTRIES IN @lt_vbap
       WHERE spras = @sy-langu
        AND abgru EQ @lt_vbap-abgru.
    IF sy-subrc = 0.
    ENDIF.

* Get Contract Start date and End date
    SELECT vbeln, vposn, vbegdat, venddat
        FROM veda
       INTO TABLE @DATA(lt_veda)
        FOR ALL ENTRIES IN @lt_vbap
        WHERE vbeln EQ @lt_vbap-vbeln AND
         vposn EQ @lt_vbap-posnr AND
         vposn NE '000000'.

    IF sy-subrc = 0.
    ENDIF.
*Fetch business Data
    SELECT vbeln, posnr, konda,kdgrp, bzirk,
        bstkd, bsark, ihrez, ihrez_e
       FROM vbkd
       INTO TABLE @DATA(lt_vbkd)
       FOR ALL ENTRIES IN @lt_vbap
       WHERE vbeln EQ @lt_vbap-vbeln AND
       posnr EQ @lt_vbap-posnr.

    IF sy-subrc = 0.
      SORT lt_vbap BY vbeln posnr.
"Based on filter values.
      IF lv_abgru  EQ 'A'
      OR  lv_abgru EQ 'null'.
        "Do Nothing
      ELSEIF lv_abgru EQ 'O'.
        DELETE lt_vbap
          WHERE abgru NE space.
        IF sy-subrc IS INITIAL.
          "Do Nothing.
        ENDIF.
      ELSEIF lv_abgru EQ 'R'.
        DELETE lt_vbap
          WHERE abgru EQ space.
        IF sy-subrc IS INITIAL.
          "Do Nothing
        ENDIF.
      ENDIF.

      LOOP AT lt_vbap INTO DATA(lw_vbap) WHERE vbeln IS NOT INITIAL.

        READ TABLE lt_veda INTO DATA(lw_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.

        IF sy-subrc EQ 0.
          lw_entity-vbegdat = lw_veda-vbegdat.
          lw_entity-venddat = lw_veda-venddat.
        ENDIF.

        READ TABLE lt_vbkd INTO DATA(lw_vbkd) WITH KEY vbeln = lw_vbap-vbeln posnr = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-konda = lw_vbkd-konda.
          lw_entity-kdgrp = lw_vbkd-kdgrp.
          lw_entity-bzirk = lw_vbkd-bzirk.
          lw_entity-bstkd = lw_vbkd-bstkd.
          lw_entity-bsark = lw_vbkd-bsark.
          lw_entity-ihrez = lw_vbkd-ihrez.
          lw_entity-ihreze = lw_vbkd-ihrez_e.
        ENDIF.

        lw_entity-vbeln = lw_vbap-vbeln.
        lw_entity-posnr = lw_vbap-posnr.
        lw_entity-matnr = lw_vbap-matnr.
        lw_entity-matkl = lw_vbap-matkl.
        lw_entity-uepos = lw_vbap-uepos.
        lw_entity-arktx = lw_vbap-arktx.
        lw_entity-pstyv = lw_vbap-pstyv.
        lw_entity-netwr = lw_vbap-netwr.
        lw_entity-waerk = lw_vbap-waerk.
        lw_entity-kwmeng = lw_vbap-zmeng.
        lw_entity-vrkme = lw_vbap-vrkme.
        lw_entity-brgew = lw_vbap-brgew.
        lw_entity-ntgew = lw_vbap-ntgew.
        lw_entity-gewei = lw_vbap-gewei.
        lw_entity-netpr = lw_vbap-netpr.
        lw_entity-kmein = lw_vbap-kmein.
        lw_entity-kpein = lw_vbap-kpein.
        lw_entity-mvgr1 = lw_vbap-mvgr1.
        lw_entity-abgru = lw_vbap-abgru.

        READ TABLE lt_tvagt INTO DATA(lw_tvagt) WITH KEY abgru = lw_vbap-abgru.
        IF sy-subrc EQ 0.
          lw_entity-abgrut = lw_tvagt-bezei.
        ENDIF.

        CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_entity-vbeln INTO lw_linkref.
        lw_entity-link = lw_linkref.

        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.

      ENDLOOP.

    ENDIF.

  ENDIF.

ENDMETHOD.


METHOD va45_rejectitems_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: VA45_REJECTITEMS_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*


  DATA : lst_filter TYPE /iwbep/s_mgw_select_option,
         lv_vbeln   TYPE /iwbep/t_cod_select_options.

  DATA : lw_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_va45_rejectitems.

  DATA : lv_host    TYPE string,
         lv_port    TYPE string,
         lw_linkref TYPE string,
         lv_abgru(4) TYPE c.

  CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

  DATA : lv_uname TYPE sy-uname.
  DATA : lr_vkorg TYPE sd_vkorg_ranges.
  DATA : lt_selection TYPE TABLE OF rsparams,
         lw_selection LIKE LINE OF  lt_selection.

  lv_uname = sy-uname.
*Fetch Authorized Sales Org
  CALL FUNCTION 'ZQTC_AUTH_SALESORG'
    EXPORTING
      im_uname = lv_uname
    TABLES
      et_vkorg = lr_vkorg.
  CLEAR lv_abgru.

  LOOP AT it_filter_select_options INTO lst_filter.
    CASE lst_filter-property.
      WHEN 'VBELN'.       "Sales Document
        lv_vbeln = lst_filter-select_options.
      WHEN: 'ABGRU'.
      LOOP AT lst_filter-select_options INTO DATA(wa_options).
        lv_abgru = wa_options-low.
      ENDLOOP.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
    CLEAR lst_filter.
  ENDLOOP.

  cl_http_server=>if_http_server~get_location(
  IMPORTING host = lv_host
            port = lv_port ).

*  Fetch Item Data
  SELECT vbeln, posnr, matnr,matkl, uepos, arktx,
          pstyv,  abgru, netwr, waerk, zmeng, vrkme,
          brgew, ntgew, gewei,netpr, kpein, kmein,mvgr1
         FROM vbap
         INTO TABLE @DATA(lt_vbap)
         WHERE vbeln IN @lv_vbeln AND
               abgru NE ' '.

  IF sy-subrc EQ 0.
    SORT lt_vbap BY vbeln.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.

*  Fetch Reason for rejection description
    SELECT abgru, bezei
           FROM tvagt
           INTO TABLE @DATA(lt_tvagt)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE spras = @sy-langu AND
                 abgru EQ @lt_vbap-abgru.
    IF sy-subrc = 0.
    ENDIF.

*   Fetch Contract Data
    SELECT vbeln, vposn,  vbegdat, venddat
           FROM veda
           INTO TABLE @DATA(lt_veda)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE vbeln EQ @lt_vbap-vbeln AND
                 vposn EQ @lt_vbap-posnr .
    IF sy-subrc = 0.
    ENDIF.
*  Fetch Business Data
    SELECT vbeln, posnr, konda,kdgrp,
           bzirk, bstkd, bsark, ihrez, ihrez_e
           FROM vbkd
           INTO TABLE @DATA(lt_vbkd)
           FOR ALL ENTRIES IN @lt_vbap
           WHERE vbeln EQ @lt_vbap-vbeln AND
                 posnr EQ @lt_vbap-posnr.
    IF sy-subrc = 0.
      SORT lt_vbap BY vbeln posnr.
      IF lv_abgru  EQ 'A'
      OR  lv_abgru EQ 'null'.
        "Do Nothing
      ELSEIF lv_abgru EQ 'O'.
        DELETE lt_vbap
          WHERE abgru NE space.
        IF sy-subrc IS INITIAL.
          "Do Nothing.
        ENDIF.
      ELSEIF lv_abgru EQ 'R'.
        DELETE lt_vbap
          WHERE abgru EQ space.
        IF sy-subrc IS INITIAL.
          "Do Nothing
        ENDIF.
      ENDIF.

      LOOP AT lt_vbap INTO DATA(lw_vbap) WHERE vbeln IS NOT INITIAL.
        READ TABLE lt_veda INTO DATA(lw_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-vbegdat = lw_veda-vbegdat.
          lw_entity-venddat = lw_veda-venddat.
        ENDIF.
        READ TABLE lt_vbkd INTO DATA(lw_vbkd) WITH KEY vbeln = lw_vbap-vbeln posnr = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          lw_entity-konda  = lw_vbkd-konda.
          lw_entity-kdgrp  = lw_vbkd-kdgrp.
          lw_entity-bzirk  = lw_vbkd-bzirk.
          lw_entity-bstkd  = lw_vbkd-bstkd.
          lw_entity-bsark  = lw_vbkd-bsark.
          lw_entity-ihrez  = lw_vbkd-ihrez.
          lw_entity-ihreze = lw_vbkd-ihrez_e.
        ENDIF.
        lw_entity-vbeln  = lw_vbap-vbeln.
        lw_entity-posnr  = lw_vbap-posnr.
        lw_entity-matnr  = lw_vbap-matnr.
        lw_entity-matkl  = lw_vbap-matkl.
        lw_entity-uepos  = lw_vbap-uepos.
        lw_entity-arktx  = lw_vbap-arktx.
        lw_entity-pstyv  = lw_vbap-pstyv.
        lw_entity-abgru  = lw_vbap-abgru.
        lw_entity-netwr  = lw_vbap-netwr.
        lw_entity-waerk  = lw_vbap-waerk.
        lw_entity-kwmeng = lw_vbap-zmeng.
        lw_entity-vrkme  = lw_vbap-vrkme.
        lw_entity-brgew  = lw_vbap-brgew.
        lw_entity-ntgew  = lw_vbap-ntgew.
        lw_entity-gewei  = lw_vbap-gewei.
        lw_entity-netpr  = lw_vbap-netpr.
        lw_entity-kpein  = lw_vbap-kpein.
        lw_entity-kmein  = lw_vbap-kmein.
        lw_entity-mvgr1  = lw_vbap-mvgr1.

        READ TABLE lt_tvagt INTO DATA(lw_tvagt) WITH KEY abgru = lw_vbap-abgru.
        IF sy-subrc EQ 0.
          lw_entity-abgrut = lw_tvagt-bezei.
        ENDIF.
        CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_entity-vbeln INTO lw_linkref.
        lw_entity-link = lw_linkref.
        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDMETHOD.


  METHOD va45_sumset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924360
* REFERENCE NO:  OTCM-46300
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:21/09/2021
* PROGRAM NAME: VA45_SUMSET_GET_ENTITYSET
* DESCRIPTION: UI5 Contract Analysis Report
*----------------------------------------------------------------------*



    DATA: textlines TYPE TABLE OF string.
    DATA:lv_report(3) TYPE c,
         lv_auart     TYPE auart,
         lv_vkorg     TYPE vkorg,
         lv_vbeln     TYPE vbeln,
         lv_kunnr     TYPE kunnr,
         lr_vbeln     TYPE RANGE OF vbeln,
         lst_vbeln    LIKE LINE OF lr_vbeln,
         lr_kunnr     TYPE RANGE OF kunnr,
         lst_kunnr    LIKE LINE OF lr_kunnr,
         lv_audat     TYPE audat,
         lv_audat2    TYPE audat,
         lr_audat     TYPE RANGE OF audat,
         lst_audat    LIKE LINE OF lr_audat,
         lv_erdat     TYPE erdat,
         lv_erdat2    TYPE erdat,
         lr_erdat     TYPE RANGE OF erdat,
         lst_erdat    LIKE LINE OF lr_erdat,
         lr_auart     TYPE tms_t_auart_range,
         lr_auart2    TYPE tms_t_auart_range,
         lv_stdate    TYPE erdat,
         lv_endate    TYPE erdat,
         lst_auart    TYPE tms_s_auart_range.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA lv_uname TYPE sy-uname.
    DATA:lr_vkorg2 TYPE sd_vkorg_ranges,
         lr_vkorg  TYPE sd_vkorg_ranges,
         lst_vkorg TYPE sdsls_vkorg_range,
         lr_vbtyp  TYPE tdt_rg_vbtyp,
         lst_vbtyp TYPE tds_rg_vbtyp.

    DATA :lv_host    TYPE string,
          lv_port    TYPE string,
          lw_linkref TYPE string.
    CONSTANTS: lc_va43 TYPE string VALUE  '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.

    TYPES: BEGIN OF ts_va45_sum,
             vbeln    TYPE vbeln_va,
             posnr    TYPE posnr_va,
             auart    TYPE c LENGTH 10,
             audat    TYPE c LENGTH 10,
             bstnk    TYPE c LENGTH 20,
             budat    TYPE c LENGTH 10,
             kunnr    TYPE c LENGTH 10,
             name1    TYPE c LENGTH 40,
             quantity TYPE c LENGTH 10,
             zeime    TYPE c LENGTH 10,
             netwr    TYPE c LENGTH 20,
             curr     TYPE c LENGTH 5,
             vkrme    TYPE c LENGTH 10,
             datuv    TYPE c LENGTH 10,
             ernam    TYPE c LENGTH 20,
             vtweg    TYPE c LENGTH 5,
             spart    TYPE c LENGTH 2,
             csdate   TYPE c LENGTH 10,
             cedate   TYPE c LENGTH 10,
             matnr    TYPE c LENGTH 20,
             linkref  TYPE string,
             angdt    TYPE c LENGTH 10,
             bnddt    TYPE c LENGTH 10,
           END OF ts_va45_sum .

    TYPES: BEGIN OF ty_header,
             col1   TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
             col5   TYPE string,
             col6   TYPE string,
             col7   TYPE string,
             col8   TYPE string,
             col9   TYPE string,
             col10  TYPE string,
             col11  TYPE string,
             col12  TYPE string,
             col13  TYPE string,
             col14  TYPE string,
             col15  TYPE string,
             col16  TYPE string,
             col17  TYPE string,
             col18  TYPE string,
             col19  TYPE string,
             col20  TYPE string,
             col21  TYPE string,
             col22  TYPE string,
             col23  TYPE string,
             col24  TYPE string,
             col25  TYPE string,
             col26  TYPE string,
             col27  TYPE string,
             col28  TYPE string,
             col29  TYPE string,
             col30  TYPE string,
             col31  TYPE string,
             col32  TYPE string,
             col33  TYPE string,
             col34  TYPE string,
             col35  TYPE string,
             col36  TYPE string,
             col37  TYPE string,
             col38  TYPE string,
             col39  TYPE string,
             col40  TYPE string,
             col41  TYPE string,
             col42  TYPE string,
             col43  TYPE string,
             col44  TYPE string,
             col45  TYPE string,
             col46  TYPE string,
             col47  TYPE string,
             col48  TYPE string,
             col49  TYPE string,
             col50  TYPE string,
             col51  TYPE string,
             col52  TYPE string,
             col53  TYPE string,
             col54  TYPE string,
             col55  TYPE string,
             col56  TYPE string,
             col57  TYPE string,
             col58  TYPE string,
             col59  TYPE string,
             col60  TYPE string,
             col61  TYPE string,
             col62  TYPE string,
             col63  TYPE string,
             col64  TYPE string,
             col65  TYPE string,
             col66  TYPE string,
             col67  TYPE string,
             col68  TYPE string,
             col69  TYPE string,
             col70  TYPE string,
             col71  TYPE string,
             col72  TYPE string,
             col73  TYPE string,
             col74  TYPE string,
             col75  TYPE string,
             col76  TYPE string,
             col77  TYPE string,
             col78  TYPE string,
             col79  TYPE string,
             col80  TYPE string,
             col81  TYPE string,
             col82  TYPE string,
             col83  TYPE string,
             col84  TYPE string,
             col85  TYPE string,
             col86  TYPE string,
             col87  TYPE string,
             col88  TYPE string,
             col89  TYPE string,
             col90  TYPE string,
             col91  TYPE string,
             col92  TYPE string,
             col93  TYPE string,
             col94  TYPE string,
             col95  TYPE string,
             col96  TYPE string,
             col97  TYPE string,
             col98  TYPE string,
             col99  TYPE string,
             col100 TYPE string,
             col101 TYPE string,
             col102 TYPE string,
             col103 TYPE string,
             col104 TYPE string,
             col105 TYPE string,
             col106 TYPE string,
             col107 TYPE string,
             col108 TYPE string,
             col109 TYPE string,
             col110 TYPE string,
             col111 TYPE string,
             col112 TYPE string,
             col113 TYPE string,
             col114 TYPE string,
             col115 TYPE string,
             col116 TYPE string,
             col117 TYPE string,
             col118 TYPE string,
             col119 TYPE string,
             col120 TYPE string,
             col121	TYPE string,
             col122	TYPE string,
             col123	TYPE string,
             col124	TYPE string,
             col125	TYPE string,
             col126	TYPE string,
             col127	TYPE string,
             col128	TYPE string,
             col129	TYPE string,
             col130	TYPE string,
             col131	TYPE string,
             col132	TYPE string,
             col133	TYPE string,
             col134	TYPE string,
             col135	TYPE string,
             col136	TYPE string,
             col137	TYPE string,
             col138	TYPE string,
             col139	TYPE string,
             col140	TYPE string,
             col141	TYPE string,
             col142	TYPE string,
             col143	TYPE string,
             col144	TYPE string,
             col145	TYPE string,
             col146	TYPE string,
             col147	TYPE string,
             col148	TYPE string,
             col149	TYPE string,
             col150	TYPE string,
             col151	TYPE string,
             col152	TYPE string,
             col153	TYPE string,
             col154	TYPE string,
             col155	TYPE string,
             col156	TYPE string,
             col157	TYPE string,
             col158	TYPE string,
             col159	TYPE string,
             col160	TYPE string,
             col161	TYPE string,
             col162	TYPE string,
             col163	TYPE string,
             col164	TYPE string,
             col165	TYPE string,
             col166	TYPE string,
             col167	TYPE string,
             col168	TYPE string,
             col169	TYPE string,
             col170	TYPE string,
             col171	TYPE string,
             col172	TYPE string,
             col173	TYPE string,
             col174	TYPE string,
             col175	TYPE string,
             col176	TYPE string,
             col177	TYPE string,
             col178	TYPE string,
             col179	TYPE string,
             col180	TYPE string,
             col181	TYPE string,
             col182	TYPE string,
             col183	TYPE string,
             col184	TYPE string,
             col185	TYPE string,
             col186	TYPE string,
             col187	TYPE string,
             col188	TYPE string,
             col189	TYPE string,
             col190	TYPE string,
             col191	TYPE string,
             col192	TYPE string,
             col193	TYPE string,
             col194	TYPE string,
             col195	TYPE string,
             col196	TYPE string,
             col197	TYPE string,
             col198	TYPE string,
             col199	TYPE string,
             col200	TYPE string,
             col201	TYPE string,
             col202	TYPE string,
             col203	TYPE string,
             col204	TYPE string,
             col205	TYPE string,
             col206	TYPE string,
             col207	TYPE string,
             col208	TYPE string,
             col209	TYPE string,
             col210	TYPE string,
             col211	TYPE string,
             col212	TYPE string,
           END OF ty_header.

    DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
          lw_data      TYPE ty_header,
          lt_selection TYPE TABLE OF rsparams,
          lw_selection LIKE LINE OF  lt_selection,
          list         TYPE STANDARD TABLE OF abaplist,
          txtlines     TYPE TABLE OF text4096,
          lt_sumdata   TYPE STANDARD TABLE OF ts_va45_sum,
          lw_sumdata   TYPE ts_va45_sum,
          lv_check     TYPE char1,
          lst_const    TYPE zcl_zsd_ordrs_mpc=>ts_zcaconst,
          lv_low       TYPE sy-datum,
          lv_bnddt     TYPE sy-datum,
          lv_angdt     TYPE sy-datum,
          lv_flag(4)   TYPE c,
          lv_abgru(4)  TYPE c,
          lw_entity    TYPE zcl_zqtc_blockorders_e_mpc=>ts_va45_sum.

    CONSTANTS: lc_devid TYPE zdevid      VALUE 'E266' .
    CONSTANTS: lc_zqtc_va45 TYPE  rvari_vnam     VALUE 'ZQTC_VA45' .
    CONSTANTS: lc_created TYPE  rvari_vnam     VALUE 'CREATED' .
    CLEAR lv_abgru.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'AUART'.        "Sales Document Type
            lv_auart = <ls_filter_opt>-low+0(4).
            IF  lv_auart NE 'null' AND lv_auart IS NOT INITIAL.
              lst_auart-sign = 'I'.
              lst_auart-option = 'EQ'.
              lst_auart-low = lv_auart.
              APPEND lst_auart TO lr_auart.
              CLEAR:lst_auart.
            ENDIF.

          WHEN 'VKORG'.          "Sales Organization
            lv_vkorg = <ls_filter_opt>-low+0(4).
            IF  lv_vkorg NE 'null' AND lv_vkorg IS NOT INITIAL.
              CLEAR:lst_vkorg.
              lst_vkorg-sign =   'I'.
              lst_vkorg-option = 'EQ'.
              lst_vkorg-low = lv_vkorg.
              APPEND lst_vkorg TO lr_vkorg.
              CLEAR:lst_vkorg.
            ENDIF.
          WHEN 'VBELN'.      "Sales Document
            lv_vbeln = <ls_filter_opt>-low+0(10).
            IF  lv_vbeln IS NOT INITIAL.
              CLEAR:lst_vkorg.
              lst_vbeln-sign =   'I'.
              lst_vbeln-option = 'EQ'.
              lst_vbeln-low = lv_vbeln.
              APPEND lst_vbeln TO lr_vbeln.
              CLEAR:lst_vbeln.
            ENDIF.
          WHEN 'KUNNR'.         "Customer Number
            lv_kunnr = <ls_filter_opt>-low+0(10).
            IF  lv_kunnr IS NOT INITIAL.
              CLEAR:lst_kunnr.
              lst_kunnr-sign   = 'I'.
              lst_kunnr-option = 'EQ'.
              lst_kunnr-low = lv_kunnr.
              APPEND lst_kunnr TO lr_kunnr.
              CLEAR:lst_kunnr.
            ENDIF.
          WHEN 'AUDAT'.       "Document Date
            IF <ls_filter_opt>-low IS NOT INITIAL.
              IF lv_audat IS INITIAL .
                lv_audat = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
              ELSE.
                lv_audat2 = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .

              ENDIF.
            ENDIF.
          WHEN 'ERDAT'.      "Created Date
            IF <ls_filter_opt>-low IS NOT INITIAL.
              IF  lv_erdat IS INITIAL.
                lv_erdat = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
              ELSE.
                lv_erdat2 = <ls_filter_opt>-low+0(4) &&
                <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .

              ENDIF.
            ENDIF.
          WHEN 'FLAG'.
            lv_flag = <ls_filter_opt>-low+0(4).
          WHEN 'ANGDT'.         "Valid From
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_angdt = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'BNDDT'.        "Valid To
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_bnddt = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'ABGRU'.        "Reason for Rejection
            lv_abgru = <ls_filter_opt>-low.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    IF lv_flag EQ 'Key2'.
      IF  lv_audat IS NOT INITIAL AND lv_audat2 IS NOT INITIAL.
        CLEAR:lst_audat.
        lst_audat-sign =   'I'.
        lst_audat-option = 'BT'.
        lst_audat-low = lv_audat.
        lst_audat-high = lv_audat2.
        APPEND lst_audat TO lr_audat.
        CLEAR:lst_audat.
      ENDIF.

      IF  lv_erdat IS NOT INITIAL AND lv_erdat2 IS NOT INITIAL.
        CLEAR:lst_erdat.
        lst_erdat-sign =   'I'.
        lst_erdat-option = 'BT'.
        lst_erdat-low = lv_erdat.
        lst_erdat-high = lv_erdat2.
        APPEND lst_erdat TO lr_erdat.
        CLEAR:lst_erdat.
      ENDIF.

      lv_uname = sy-uname.

* Get Constant values FOR DEFAULT execution
      SELECT * FROM zcaconstant
        INTO TABLE @DATA(li_const45)
        WHERE devid = @lc_devid
          AND param2 = @lc_zqtc_va45
          AND activate = @abap_true.

      IF sy-subrc EQ 0.
        LOOP AT li_const45 INTO lst_const.
          CASE lst_const-param1.
            WHEN 'AUART'.       "Sales Document Type
              IF lr_auart[] IS INITIAL.
                CLEAR:lst_auart.
                lst_auart-sign = lst_const-sign.
                lst_auart-option = lst_const-opti.
                lst_auart-low = lst_const-low.
                APPEND lst_auart TO lr_auart2.
                CLEAR:lst_auart.
              ENDIF.
            WHEN 'VKORG'.       "Sales Organization
              IF lr_vkorg[] IS INITIAL.
                CLEAR:lst_vkorg.
                lst_vkorg-sign = lst_const-sign.
                lst_vkorg-option = lst_const-opti.
                lst_vkorg-low = lst_const-low.
                APPEND lst_vkorg TO lr_vkorg2.
                CLEAR:lst_vkorg.
              ENDIF.
            WHEN 'VBTYPN'.
              CLEAR:lst_vbtyp.
              lst_vbtyp-sign = lst_const-sign.
              lst_vbtyp-option = lst_const-opti.
              lst_vbtyp-low = lst_const-low.
              APPEND lst_vbtyp TO lr_vbtyp.
              CLEAR:lst_vbtyp.
            WHEN  'CREATED' .
              DATA(lv_createddays) = lst_const-low..
            WHEN OTHERS.
          ENDCASE .
        ENDLOOP.

      ENDIF.

* Take inputs from front end user selection, if not entred
      IF lr_auart[] IS INITIAL AND lr_auart2[] IS NOT INITIAL.
        FREE:lr_auart[].
        lr_auart[] = lr_auart2[].
        FREE:lr_auart2[].
      ENDIF.

* Take inputs from front end user selection
      IF lr_vkorg[] IS  INITIAL AND lr_vkorg2[] IS NOT INITIAL.
        FREE:lr_vkorg[].
        lr_vkorg[] = lr_vkorg2[].
        FREE:lr_vkorg2[].
      ENDIF.

      CLEAR: lt_selection[].

      lv_low = lv_bnddt - 10.

      "------------------------------------
      "If high value is initial.
      DATA: lv_option TYPE char2.
      CLEAR lv_option.
      IF lv_bnddt IS INITIAL.
        lv_option = 'EQ'.
      ELSEIF lv_bnddt IS NOT INITIAL.
        lv_option = 'BT'.
      ENDIF.
      lw_selection-selname = 'SITEMVAL'.
      lw_selection-kind    = 'S'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = lv_option.
      lw_selection-low     = lv_angdt.
      lw_selection-high     = lv_bnddt.
      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.


* Fill authorized Sales Orgs to submit to report
      LOOP AT lr_vkorg INTO DATA(ls_vkorg) FROM 1 TO 4..
        lw_selection-selname = 'SVKORG' .
        lw_selection-kind    = 'S'.
        lw_selection-sign    = 'I'.
        lw_selection-option  = 'EQ'.
        lw_selection-low     = ls_vkorg-low.
        APPEND lw_selection TO lt_selection.
        CLEAR lw_selection.
      ENDLOOP.

      LOOP AT lr_auart INTO DATA(ls_auart) FROM 1 TO 4.
        lw_selection-selname = 'SAUART'.
        lw_selection-kind    = 'S'.
        lw_selection-sign    = 'I'.
        lw_selection-option  = 'EQ'.
        lw_selection-low     = ls_auart-low.
        APPEND lw_selection TO lt_selection.
        CLEAR lw_selection.
      ENDLOOP.

      LOOP AT lr_vbtyp INTO DATA(ls_vbtyp) FROM 1 TO 3.
        lw_selection-selname = 'S_VBTY_N'.
        lw_selection-kind    = 'S'.
        lw_selection-sign    = 'I'.
        lw_selection-option  = 'EQ'.
        lw_selection-low     = ls_vbtyp-low.
        APPEND lw_selection TO lt_selection.
        CLEAR lw_selection.
      ENDLOOP.
      "Adding documents for selection screeen of submit program
      IF lr_vbeln[] IS NOT INITIAL.
        LOOP AT lr_vbeln INTO lst_vbeln.
          lw_selection-selname = 'SVBELN'.
          lw_selection-kind    = 'S'.
          lw_selection-sign    = 'I'.
          lw_selection-option  = 'EQ'.
          lw_selection-low     = lst_vbeln-low.
          APPEND lw_selection TO lt_selection.
          CLEAR lw_selection.
        ENDLOOP.
      ENDIF.
      "Adding Sold to party for selection screen of submit program
      IF lr_kunnr[] IS NOT INITIAL.
        LOOP AT lr_kunnr INTO lst_kunnr.
          lw_selection-selname = 'SKUNNR'.
          lw_selection-kind    = 'S'.
          lw_selection-sign    = 'I'.
          lw_selection-option  = 'EQ'.
          lw_selection-low     = lst_kunnr-low.
          APPEND lw_selection TO lt_selection.
          CLEAR lw_selection.
        ENDLOOP.
      ENDIF.
      "Adding Document Date for selection screen of submit program
      IF lr_audat[] IS NOT INITIAL.
        LOOP AT lr_audat INTO lst_audat.
          lw_selection-selname = 'SAUDAT'.
          lw_selection-kind    = 'S'.
          lw_selection-sign    = 'I'.
          lw_selection-option  = 'BT'.
          lw_selection-low     = lst_audat-low.
          lw_selection-high     = lst_audat-high.
          APPEND lw_selection TO lt_selection.
          CLEAR lw_selection.
        ENDLOOP.
      ENDIF.

      "Adding create date for selection screen of submit program
      IF lr_erdat[] IS NOT INITIAL.

        LOOP AT lr_erdat INTO lst_erdat.
          lw_selection-selname = 'SERDAT'.
          lw_selection-kind    = 'S'.
          lw_selection-sign    = 'I'.
          lw_selection-option  = 'BT'.
          lw_selection-low     = lst_erdat-low.
          lw_selection-high     = lst_erdat-high.
          APPEND lw_selection TO lt_selection.
          CLEAR lw_selection.
        ENDLOOP.
      ELSE.
        lw_selection-selname = 'SERDAT'.
        lw_selection-kind    = 'S'.
        lw_selection-sign    = 'I'.
        lw_selection-option  = 'BT'.
        lw_selection-low     = lv_angdt.
        lw_selection-high     = lv_bnddt.
        APPEND lw_selection TO lt_selection.
        CLEAR lw_selection.
      ENDIF.

      CLEAR lw_selection.
      lw_selection-selname = 'P_LAYOUT'.
      lw_selection-kind    = 'P'.
      lw_selection-sign    = 'I'.
      lw_selection-option  = 'EQ'.
      lw_selection-low     = '1SAP'.

      APPEND lw_selection TO lt_selection.
      CLEAR lw_selection.
* Call ZQTC_VA45 Program to pull data
      SUBMIT sd_sales_document_va45
             WITH SELECTION-TABLE lt_selection
             EXPORTING LIST TO MEMORY AND RETURN.

      CALL FUNCTION 'LIST_FROM_MEMORY'
        TABLES
          listobject = list
        EXCEPTIONS
          not_found  = 1
          OTHERS     = 2.
*
      IF sy-subrc EQ 0.

        CALL FUNCTION 'LIST_TO_ASCI'
          EXPORTING
            list_index         = -1
*           WITH_LINE_BREAK    = ' '
          TABLES
            listasci           = txtlines        "lt_out
            listobject         = list
          EXCEPTIONS
            empty_list         = 1
            list_index_invalid = 2
            OTHERS             = 3.
*
        LOOP AT txtlines INTO DATA(ls_text).
          ls_text+0(1) = ''.
          IF sy-tabix > 4.
            SPLIT ls_text AT '|' INTO
            lw_data-col1
            lw_data-col2
            lw_data-col3
            lw_data-col4
            lw_data-col5
            lw_data-col6
            lw_data-col7
            lw_data-col8
            lw_data-col9
            lw_data-col10
            lw_data-col11
            lw_data-col12
            lw_data-col13
            lw_data-col14
            lw_data-col15
            lw_data-col16
            lw_data-col17
            lw_data-col18
            lw_data-col19
            lw_data-col20
            lw_data-col21
            lw_data-col22
            lw_data-col23
            lw_data-col24
            lw_data-col25
            lw_data-col26
            lw_data-col27
            lw_data-col28
            lw_data-col29
            lw_data-col30
            lw_data-col31
            lw_data-col32
            lw_data-col33
            lw_data-col34
            lw_data-col35
            lw_data-col36
            lw_data-col37
            lw_data-col38
            lw_data-col39
            lw_data-col40
            lw_data-col41
            lw_data-col42
            lw_data-col43
            lw_data-col44
            lw_data-col45
            lw_data-col46
            lw_data-col47
            lw_data-col48
            lw_data-col49
            lw_data-col50
            lw_data-col51
            lw_data-col52
            lw_data-col53
            lw_data-col54
            lw_data-col55
            lw_data-col56
            lw_data-col57
            lw_data-col58
            lw_data-col59
            lw_data-col60
            lw_data-col61
            lw_data-col62
            lw_data-col63
            lw_data-col64
            lw_data-col65
            lw_data-col66
            lw_data-col67
            lw_data-col68
            lw_data-col69
            lw_data-col70
            lw_data-col71
            lw_data-col72
            lw_data-col73
            lw_data-col74
            lw_data-col75
            lw_data-col76
            lw_data-col77
            lw_data-col78
            lw_data-col79
            lw_data-col80
            lw_data-col81
            lw_data-col82
            lw_data-col83
            lw_data-col84
            lw_data-col85
            lw_data-col86
            lw_data-col87
            lw_data-col88
            lw_data-col89
            lw_data-col90
            lw_data-col91
            lw_data-col92
            lw_data-col93
            lw_data-col94
            lw_data-col95
            lw_data-col96
            lw_data-col97
            lw_data-col98
            lw_data-col99
            lw_data-col100
            lw_data-col101
            lw_data-col102
            lw_data-col103
            lw_data-col104
            lw_data-col105
            lw_data-col106
            lw_data-col107
            lw_data-col108
            lw_data-col109
            lw_data-col110
            lw_data-col111
            lw_data-col112
            lw_data-col113
            lw_data-col114
            lw_data-col115
            lw_data-col116
            lw_data-col117
            lw_data-col118
            lw_data-col119
            lw_data-col120
            lw_data-col121
            lw_data-col122
            lw_data-col123
            lw_data-col124
            lw_data-col125
            lw_data-col126
            lw_data-col127
            lw_data-col128
            lw_data-col129
            lw_data-col130
            lw_data-col131
            lw_data-col132
            lw_data-col133
            lw_data-col134
            lw_data-col135
            lw_data-col136
            lw_data-col137
            lw_data-col138
            lw_data-col139
            lw_data-col140
            lw_data-col141
            lw_data-col142
            lw_data-col143
            lw_data-col144
            lw_data-col145
            lw_data-col146
            lw_data-col147
            lw_data-col148
            lw_data-col149
            lw_data-col150
            lw_data-col151
            lw_data-col152
            lw_data-col153
            lw_data-col154
            lw_data-col155
            lw_data-col156
            lw_data-col157
            lw_data-col158
            lw_data-col159
            lw_data-col160
            lw_data-col161
            lw_data-col162
            lw_data-col163
            lw_data-col164
            lw_data-col165
            lw_data-col166
            lw_data-col167
            lw_data-col168
            lw_data-col169
            lw_data-col170
            lw_data-col171
            lw_data-col172
            lw_data-col173
            lw_data-col174
            lw_data-col175
            lw_data-col176
            lw_data-col177
            lw_data-col178
            lw_data-col179
            lw_data-col180
            lw_data-col181
            lw_data-col182
            lw_data-col183
            lw_data-col184
            lw_data-col185
            lw_data-col186
            lw_data-col187
            lw_data-col188
            lw_data-col189
            lw_data-col190
            lw_data-col191
            lw_data-col192
            lw_data-col193
            lw_data-col194
            lw_data-col195
            lw_data-col196
            lw_data-col197
            lw_data-col198
            lw_data-col199
            lw_data-col200
            lw_data-col201
            lw_data-col202
            lw_data-col203
            lw_data-col204
            lw_data-col205
            lw_data-col206
            lw_data-col207
            lw_data-col208
            lw_data-col209
            lw_data-col210
            lw_data-col211
            lw_data-col212.
            APPEND lw_data TO lt_data.
            CLEAR: lw_data, lw_entity.
          ENDIF.
        ENDLOOP.

        DATA: lw_sum      TYPE dmbtr,
              lw_netwr    TYPE char20,
              lw_quantity TYPE menge_d,
              lw_rejquan  TYPE menge_d,
              lw_rejsum   TYPE dmbtr,
              lw_rejitems TYPE i.

        FREE lt_sumdata.
        CLEAR lw_sumdata.

        cl_http_server=>if_http_server~get_location(
          IMPORTING host = lv_host
                    port = lv_port ).

        LOOP AT lt_data INTO lw_data.
          lw_sumdata-vbeln       = lw_data-col3.   "Object Type
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lw_sumdata-vbeln
            IMPORTING
              output = lw_sumdata-vbeln.
          lw_sumdata-posnr       = lw_data-col5.
          lw_sumdata-auart       = lw_data-col4.   "Object
          lw_sumdata-audat       = lw_data-col2.
          lw_sumdata-bstnk       = lw_data-col1.
          lw_sumdata-kunnr       = lw_data-col10.
          lw_sumdata-quantity    = lw_data-col7.
          lw_sumdata-netwr       = lw_data-col11.
          lw_sumdata-curr        = lw_data-col12.
          lw_sumdata-vkrme       = lw_data-col8.
          lw_sumdata-datuv       = lw_data-col9.
          lw_sumdata-ernam       = lw_data-col13.
          lw_sumdata-vtweg       = lw_data-col14.
          lw_sumdata-csdate      = lw_data-col15.
          lw_sumdata-cedate      = lw_data-col16.
          lw_sumdata-matnr       = lw_data-col6.
          APPEND lw_sumdata TO lt_sumdata.
          CLEAR lw_sumdata.
        ENDLOOP.
        SORT lt_sumdata BY vbeln posnr.


        IF lt_sumdata IS NOT INITIAL.

*  Fetch Customer Data
          SELECT kunnr,name1 FROM kna1 INTO TABLE @DATA(lt_kna1)
                      FOR ALL ENTRIES IN @lt_sumdata
           WHERE kunnr EQ @lt_sumdata-kunnr.

          IF sy-subrc = 0.
            SORT lt_kna1 BY kunnr.
          ENDIF.
          " fetch item data
          SELECT vbeln,
                 posnr,
                 abgru,
                 zmeng,
                 zieme,
                 netwr
            FROM vbap
            INTO TABLE @DATA(lt_vbap)
            FOR ALL ENTRIES IN @lt_sumdata
           WHERE vbeln EQ @lt_sumdata-vbeln
             AND posnr EQ @lt_sumdata-posnr.

          IF  sy-subrc IS INITIAL
          AND lt_vbap  IS NOT INITIAL.
            IF lv_abgru  EQ 'A'
            OR  lv_abgru EQ 'null'.
              "Do Nothing
            ELSEIF lv_abgru EQ 'O'.
              DELETE lt_vbap
                WHERE abgru NE space.
              IF sy-subrc IS INITIAL.
                "Do Nothing.
              ENDIF.
            ELSEIF lv_abgru EQ 'R'.
              DELETE lt_vbap
                WHERE abgru EQ space.
              IF sy-subrc IS INITIAL.
                "Do Nothing
              ENDIF.
            ENDIF.
*    Fetch abgru Description
            SELECT abgru, bezei
               FROM tvagt
               INTO TABLE @DATA(lt_tvagt)
               FOR ALL ENTRIES IN @lt_vbap
              WHERE spras = @sy-langu
               AND abgru EQ @lt_vbap-abgru.
            IF sy-subrc = 0.
              SORT lt_tvagt
                BY abgru bezei.
            ENDIF.
          ENDIF.
          " fetch order data at header
          SELECT vbeln,
                 auart,
                 vkorg,
                 vtweg,
                 vkbur,
                 faksk,
                 erdat,angdt,bnddt,
                 spart
            FROM vbak
            INTO TABLE @DATA(lt_vbak)
             FOR ALL ENTRIES IN @lt_sumdata
           WHERE vbeln EQ @lt_sumdata-vbeln.
          IF sy-subrc IS INITIAL.
            SORT lt_vbak BY vbeln.
            SELECT spras,
                   faksp,
                   vtext
              FROM tvfst
              INTO TABLE @DATA(lt_tvfst)
               FOR ALL ENTRIES IN @lt_vbak
             WHERE spras EQ @sy-langu
               AND faksp EQ @lt_vbak-faksk.
            IF  sy-subrc  IS INITIAL
            AND lt_tvfst  IS NOT INITIAL.
              SORT lt_tvfst BY faksp.
            ENDIF.
          ENDIF.

*     Fetch Shipping Reference from business data
          SELECT vbeln, ihrez_e
            FROM vbkd
            INTO TABLE @DATA(lt_vbkd)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln
            AND posnr EQ @lt_sumdata-posnr.
          IF sy-subrc IS INITIAL.
            SORT lt_vbkd BY vbeln.
          ENDIF.

*     Fetch Shipping Reference from business data
          SELECT vbeln, vbegdat,venddat
            FROM veda
            INTO TABLE @DATA(lt_veda)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln.
*            AND posnr EQ @lt_sumdata-posnr.
          IF sy-subrc IS INITIAL.
            SORT lt_veda BY vbeln.
          ENDIF.

*      Get Overall processing status of document
          SELECT vbeln, gbstk
            FROM vbuk
            INTO TABLE @DATA(lt_vbuk)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln.
          IF sy-subrc IS INITIAL.
            SORT lt_vbuk BY vbeln.
          ENDIF.

*      Fetch Partner Address
          SELECT vbeln, adrnr FROM vbpa
            INTO TABLE @DATA(lt_vbpa)
            FOR ALL ENTRIES IN @lt_sumdata
            WHERE vbeln EQ @lt_sumdata-vbeln.


          IF sy-subrc IS INITIAL.
            SELECT addrnumber, name1 FROM adrc
              INTO TABLE @DATA(lt_adrc)
           FOR ALL ENTRIES IN @lt_vbpa
           WHERE addrnumber EQ @lt_vbpa-adrnr.
            IF sy-subrc IS INITIAL.
            ENDIF.
          ENDIF.

          CLEAR lw_sumdata.
          SORT lt_vbap BY vbeln posnr.
          DELETE lt_sumdata WHERE vbeln IS INITIAL.
          LOOP AT lt_sumdata
            INTO lw_sumdata.
            READ TABLE lt_vbap INTO DATA(lw_vbap)
              WITH KEY vbeln = lw_sumdata-vbeln
                       posnr = lw_sumdata-posnr BINARY SEARCH.
            IF  sy-subrc IS INITIAL.
              lv_check = abap_true.
              IF lw_vbap-abgru IS INITIAL.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-quantity WITH ' '.
                CONDENSE lw_sumdata-quantity.
                ADD lw_sumdata-quantity TO lw_quantity.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-netwr WITH ' '.
                CONDENSE lw_sumdata-netwr.
                ADD lw_sumdata-netwr TO lw_sum.
              ENDIF.

              IF lw_vbap-abgru IS NOT INITIAL.
                lw_entity-abgru = lw_vbap-abgru.
                READ TABLE lt_tvagt INTO DATA(lw_tvagt)
                  WITH KEY abgru = lw_vbap-abgru BINARY SEARCH.
                IF sy-subrc EQ 0.
                  lw_entity-abgrut = lw_tvagt-bezei.
                ENDIF.

                ADD 1 TO lw_rejitems.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-quantity WITH ' '.
                CONDENSE lw_sumdata-quantity.
                ADD lw_sumdata-quantity TO lw_rejquan.
                REPLACE ALL OCCURRENCES OF ',' IN lw_sumdata-netwr WITH ' '.
                CONDENSE lw_sumdata-netwr.
                ADD lw_sumdata-netwr TO lw_rejsum.
              ENDIF.
            ENDIF.
            AT END OF vbeln.
              READ TABLE lt_sumdata
                INTO DATA(lw_sumdata1)
                WITH KEY vbeln = lw_sumdata-vbeln BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                lw_entity-vbeln    = lw_sumdata1-vbeln.
                lw_entity-auart    = lw_sumdata1-auart.
                lw_entity-audat    = lw_sumdata1-audat.
                lw_entity-bstnk    = lw_sumdata1-bstnk.
                lw_entity-budat    = lw_sumdata1-budat.
                lw_entity-kunnr    = lw_sumdata1-kunnr.
                lw_entity-quantity = lw_quantity.
                lw_entity-netwr    = lw_sum.
                lw_entity-curr     = lw_sumdata1-curr.
                lw_entity-posnr    = lw_sumdata1-posnr.
                READ TABLE lt_vbak
                  INTO DATA(lw_vbak)
                  WITH KEY vbeln = lw_sumdata1-vbeln BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  lw_entity-vkorg    = lw_vbak-vkorg.
                  lw_entity-vtweg    = lw_vbak-vtweg.
                  lw_entity-spart    = lw_vbak-spart.
                  lw_entity-vkbur    = lw_vbak-vkbur.
                  lw_entity-faksk    = lw_vbak-faksk.
                  lw_entity-erdat    = lw_vbak-erdat.
                  lw_entity-angdt    = lw_vbak-angdt.
                  lw_entity-bnddt    = lw_vbak-bnddt.
                  READ TABLE lt_tvfst
                     INTO DATA(lw_tvfst)
                     WITH KEY spras = sy-langu
                              faksp = lw_vbak-faksk BINARY SEARCH.
                  IF  sy-subrc  IS INITIAL
                  AND lw_tvfst  IS NOT INITIAL.
                    lw_entity-btext = lw_tvfst-vtext.
                  ENDIF.
                ENDIF.
*                begin of change1
                READ TABLE lt_vbkd
                  INTO DATA(lw_vbkd)
                  WITH KEY vbeln = lw_sumdata1-vbeln BINARY SEARCH.

                IF sy-subrc IS INITIAL.
                  lw_entity-ihreze  = lw_vbkd-ihrez_e.
                ENDIF.
                READ TABLE lt_vbuk
                  INTO DATA(lw_vbuk)
                  WITH KEY vbeln = lw_sumdata1-vbeln BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  lw_entity-gbstk  = lw_vbuk-gbstk.
                  IF lw_entity-gbstk = 'A'.
                    lw_entity-gbstkt = 'Not yet processed'.
                  ELSEIF lw_entity-gbstk = 'B'.
                    lw_entity-gbstkt = 'Partially processed'.
                  ELSEIF lw_entity-gbstk = 'C'.
                    lw_entity-gbstkt = 'Completely processed'.
                  ELSE.
                    lw_entity-gbstkt = 'Not Relevant'.
                  ENDIF.
                ENDIF.
                READ TABLE lt_vbpa
                  INTO DATA(lw_vbpa)
                  WITH KEY vbeln = lw_sumdata1-vbeln BINARY SEARCH.
                lw_entity-adrnr = lw_vbpa-adrnr.
                IF sy-subrc IS INITIAL.
                  READ TABLE lt_adrc
                   INTO DATA(lw_adrc)
                   WITH KEY addrnumber = lw_vbpa-adrnr.
                  IF sy-subrc IS INITIAL.
                    lw_entity-adrcname = lw_adrc-name1.
                  ENDIF.
                ENDIF.

*                 end of change1
                READ TABLE lt_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lw_entity-kunnr BINARY SEARCH.
                IF sy-subrc EQ 0.
                  lw_entity-name1 = lst_kna1-name1.
                ENDIF.
                lw_entity-vkrme    = lw_sumdata1-vkrme.
                lw_entity-datuv    = lw_sumdata1-datuv.
                lw_entity-ernam    = lw_sumdata1-ernam.
                lw_entity-csdate   = lw_sumdata1-csdate.
                lw_entity-cedate   = lw_sumdata1-cedate.
                lw_entity-rejamount  = lw_rejsum.
                lw_entity-rejquan    = lw_rejquan.
                lw_entity-rejitems   = lw_rejitems.
                CONCATENATE 'http://' lv_host ':' lv_port lc_va43 lw_sumdata1-vbeln INTO lw_linkref.
                lw_entity-linkref    = lw_linkref.
*                lw_entity-angdt = lv_low.
*                lw_entity-bnddt = sy-datum.

                READ TABLE lt_veda INTO DATA(lst_veda) WITH KEY vbeln = lw_sumdata1-vbeln BINARY SEARCH.
                IF sy-subrc EQ 0.
                  lw_entity-csdate   = lst_veda-vbegdat.
                  lw_entity-cedate   = lst_veda-venddat.
                ENDIF.
                IF lv_check IS NOT INITIAL.
                  APPEND lw_entity TO et_entityset.
                  CLEAR:lv_check.
                ENDIF.
                CLEAR: lw_entity, lw_sum,lw_quantity, lw_sumdata,lw_rejsum, lw_rejquan,
                       lw_rejitems, lw_linkref.
              ENDIF.
            ENDAT.
*            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CALL FUNCTION 'LIST_FREE_MEMORY'.
    ENDIF.
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
