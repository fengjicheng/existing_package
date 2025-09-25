class ZCL_ZQTC_BB_ORDERS_V23_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_BB_ORDERS_V23_DPC
  create public .

public section.
protected section.

  methods BBHEADERSET_GET_ENTITYSET
    redefinition .
  methods CREATEDBYSET_GET_ENTITYSET
    redefinition .
  methods ORDERDATASET_GET_ENTITYSET
    redefinition .
  methods SALESORGSET_GET_ENTITYSET
    redefinition .
  methods SDDOCSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods ITEMSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_BB_ORDERS_V23_DPC_EXT IMPLEMENTATION.


  METHOD bbheaderset_get_entityset.

    DATA: lw_entity TYPE zcl_zqtc_bb_orders_v23_mpc=>ts_bbheader.

    SELECT faksp, vtext FROM tvfst INTO TABLE @DATA(li_tvfst) WHERE spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      LOOP AT li_tvfst INTO DATA(lst_tvfst).
        lw_entity-faksk = lst_tvfst-faksp.
        lw_entity-fakskt = lst_tvfst-vtext.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_entity, lst_tvfst.
      ENDLOOP.
      SORT et_entityset BY faksk.
    ENDIF.

  ENDMETHOD.


  METHOD createdbyset_get_entityset.
    SELECT  bname FROM usr21 INTO TABLE et_entityset.
    IF sy-subrc = 0.
      SORT et_entityset BY ernam.
    ENDIF.
  ENDMETHOD.


  METHOD itemsset_get_entityset.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lir_vbeln TYPE TABLE OF range_vbeln,
          lst_vbeln TYPE range_vbeln,
          lw_entity TYPE zcl_zqtc_bb_orders_v23_mpc=>ts_items.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'VBELN'. "Sales Org
            lst_vbeln-sign = <ls_filter_opt>-sign.
            lst_vbeln-option = <ls_filter_opt>-option.
            lst_vbeln-low = <ls_filter_opt>-low.
            lst_vbeln-high = <ls_filter_opt>-high.
            APPEND lst_vbeln TO lir_vbeln.
            CLEAR: lst_vbeln.
          WHEN OTHERS.
            " Do nothing.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_vbeln IS NOT INITIAL.
      SELECT vbeln, posnr FROM vbap INTO TABLE @DATA(li_vbap) WHERE vbeln IN @lir_vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbap BY vbeln posnr.
        LOOP AT li_vbap INTO DATA(lst_vbap).
          lw_entity-vbeln = lst_vbap-vbeln.
          lw_entity-posnr = lst_vbap-posnr.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lst_vbap.
        ENDLOOP.
      ENDIF.
    ENDIF.
*  FIELD-SYMBOLS:
*    <ls_filter>     LIKE LINE OF it_filter_select_options,
*    <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
*
*  DATA: lir_vbeln TYPE /iwbep/t_cod_select_options,
*        lst_vbeln TYPE /iwbep/s_cod_select_option,
*        lw_entity TYPE zcl_zqtc_blockorders_e_mpc=>ts_items_v23.
*
*  LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
*    LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
*      CASE <ls_filter>-property.
*        WHEN 'VBELN'.    "Sales Document
*          lst_vbeln-sign = <ls_filter_opt>-sign.
*          lst_vbeln-option = <ls_filter_opt>-option.
*          lst_vbeln-low = <ls_filter_opt>-low.
*          lst_vbeln-high = <ls_filter_opt>-high.
*          APPEND lst_vbeln TO lir_vbeln.
*          CLEAR lst_vbeln.
*        WHEN OTHERS.
*          "Do nothing.
*      ENDCASE.
*    ENDLOOP.
*  ENDLOOP.
*
*  IF lir_vbeln IS NOT INITIAL.
**----------------------------Fetch all items-------------------------------*
*    SELECT v~vbeln, v~posnr, v~mvgr5, v~abgru, vk~vbtyp
*           INTO TABLE @DATA(li_vbap) FROM vbap AS v
*           INNER JOIN vbak AS vk ON vk~vbeln = v~vbeln
*           WHERE v~vbeln IN @lir_vbeln.
*    IF sy-subrc EQ 0.
*      SORT li_vbap BY vbeln posnr.
*      DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING vbeln posnr.
*    ENDIF.
*
*    IF li_vbap IS NOT INITIAL.
*
*      SELECT vbeln, vposn, vkuegru
*               INTO TABLE @DATA(li_veda)
*               FROM veda
*               FOR ALL ENTRIES IN @li_vbap
*               WHERE vbeln = @li_vbap-vbeln.
*      IF sy-subrc = 0.
*        SORT li_veda BY vbeln vposn.
*      ENDIF.
*
*      LOOP AT li_vbap INTO DATA(lw_vbap).
*        READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lw_vbap-vbeln posnr = lw_vbap-posnr..
*        IF sy-subrc EQ 0.
*          lw_entity-vbeln = lst_vbap-vbeln.
*          lw_entity-mvgr5 = lst_vbap-mvgr5.
*          IF lst_vbap-vbtyp = 'C'.
*            lw_entity-vkuegru = lst_vbap-abgru.
*          ELSEIF lst_vbap-vbtyp = 'G'.
*            READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.
*            IF sy-subrc = 0.
*              lw_entity-vkuegru = lst_veda-vkuegru.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*        APPEND lw_entity TO et_entityset.
*        CLEAR:lw_vbap,lst_vbap,lst_veda.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
  ENDMETHOD.


METHOD orderdataset_get_entityset.

  FIELD-SYMBOLS:
    <ls_filter>     LIKE LINE OF it_filter_select_options,
    <ls_filter_opt> TYPE /iwbep/s_cod_select_option.


  DATA: lir_vkorg TYPE STANDARD TABLE OF range_vkorg,
        lst_vkorg TYPE range_vkorg,
        lir_erdat TYPE STANDARD TABLE OF tds_rg_erdat,
        lst_erdat TYPE tds_rg_erdat.

  CONSTANTS: lc_devid TYPE zdevid VALUE 'ZBBV23'.

  DATA: lv_rundays TYPE i,
        lv_low     TYPE sy-datum.

*---------Filters to have selection criteria -------*
  LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
    LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
      CASE <ls_filter>-property.
        WHEN 'VKORG'. "Sales Org
          lst_vkorg-sign = <ls_filter_opt>-sign.
          lst_vkorg-option = <ls_filter_opt>-option.
          lst_vkorg-low = <ls_filter_opt>-low.
          lst_vkorg-high = <ls_filter_opt>-high.
          APPEND lst_vkorg TO lir_vkorg.
          CLEAR: lst_vkorg.
        WHEN 'ERDAT'. "Created Date.
          lst_erdat-sign = <ls_filter_opt>-sign.
          lst_erdat-option = <ls_filter_opt>-option.
          lst_erdat-low = <ls_filter_opt>-low.
          lst_erdat-high = <ls_filter_opt>-high.
          APPEND lst_erdat TO lir_erdat.
          CLEAR: lst_erdat.
        WHEN OTHERS.
          " Do nothing.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  TYPES: BEGIN OF ty_header,
           col1  TYPE vbeln_va,
           col2  TYPE string,
           col3  TYPE string,
           col4  TYPE string,
           col5  TYPE string,
           col6  TYPE string,
           col7  TYPE string,
           col8  TYPE string,
           col9  TYPE string,
           col10 TYPE string,
           col11 TYPE string,
           col12 TYPE string,
           col13 TYPE string,
           col14 TYPE string,
           col15 TYPE string,
         END OF ty_header.

  DATA: lt_data      TYPE STANDARD TABLE OF ty_header,
        lw_data      TYPE ty_header,
        lt_selection TYPE TABLE OF rsparams,
        lw_selection LIKE LINE OF  lt_selection,
        lw_entity    TYPE zcl_zqtc_bb_orders_v23_mpc=>ts_orderdata.


*--------Fetch data from constant table --------*

  SELECT param1, param2, srno, sign, opti, low, high
        FROM zcaconstant
        INTO TABLE @DATA(lt_const) WHERE devid = @lc_devid
        AND param2 = 'V23'
        AND activate = @abap_true.

  IF sy-subrc EQ 0.
    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
      CASE <lfs_const>-param1.
        WHEN 'VKORG'.
          IF lir_vkorg IS INITIAL.
            APPEND INITIAL LINE TO lir_vkorg ASSIGNING FIELD-SYMBOL(<lfs_vkorg_i>).
            <lfs_vkorg_i>-sign = <lfs_const>-sign.
            <lfs_vkorg_i>-option = <lfs_const>-opti.
            <lfs_vkorg_i>-low = <lfs_const>-low.
            <lfs_vkorg_i>-high = <lfs_const>-high.
          ENDIF.
        WHEN 'DAYS2'.
          IF lir_erdat IS INITIAL.
            CONDENSE <lfs_const>-low NO-GAPS.
            lv_rundays = <lfs_const>-low.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDIF.

*------passing default selection criteria-------*
Loop at lir_vkorg into lst_vkorg.
  lw_selection-selname = 'VKORG'.
  lw_selection-kind    = 'P'.
  lw_selection-sign    = 'I'.
  lw_selection-option  = 'EQ'.
  lw_selection-low     = lst_vkorg-low.
  APPEND lw_selection TO lt_selection.
  CLEAR: lw_selection, lst_vkorg.
EndLoop.

  lw_selection-selname = 'ERNAM'.
  lw_selection-kind    = 'S'.
  lw_selection-sign    = 'I'.
  lw_selection-option  = 'BT'.
  lw_selection-low     = sy-uname.
  APPEND lw_selection TO lt_selection.
  CLEAR lw_selection.

  lv_low = sy-datum - lv_rundays.

  lw_selection-selname = 'ERDAT'.
  lw_selection-kind    = 'S'.
  lw_selection-sign    = 'I'.
  lw_selection-option  = 'BT'.
  lw_selection-low     = lv_low.
  lw_selection-high     = sy-datum.
  APPEND lw_selection TO lt_selection.
  CLEAR lw_selection.

*--------display variant "01STANDARD" is used----------*

*    lw_selection-selname = 'P_VARI'.
*    lw_selection-kind    = 'P'.
*    lw_selection-sign    = 'I'.
*    lw_selection-option  = 'EQ'.
*    lw_selection-low     = '01STANDARD'.
*    APPEND lw_selection TO lt_selection.
*    CLEAR lw_selection.

  SUBMIT sdfakspe
         WITH SELECTION-TABLE lt_selection
         EXPORTING LIST TO MEMORY AND RETURN.

  DATA:list TYPE STANDARD TABLE OF abaplist.


  DATA: txtlines TYPE TABLE OF char2048.

  CALL FUNCTION 'LIST_FROM_MEMORY'
    TABLES
      listobject = list
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.

  IF sy-subrc EQ 0.

    CALL FUNCTION 'LIST_TO_ASCI'
      EXPORTING
        list_index         = -1
      TABLES
        listasci           = txtlines        "lt_out
        listobject         = list
      EXCEPTIONS
        empty_list         = 1
        list_index_invalid = 2
        OTHERS             = 3.

    LOOP AT txtlines INTO DATA(ls_text).
      ls_text+0(1) = ''.
      IF sy-tabix > 8.
        CONDENSE ls_text.
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
        lw_data-col14.
*        CONDENSE lw_data-col1.
        APPEND lw_data TO lt_data.
        CLEAR: lw_data, lw_entity.
      ENDIF.
    ENDLOOP.

    DELETE lt_data WHERE col2 IS INITIAL.
    IF lt_data IS NOT INITIAL.

      SELECT vbeln, vbtyp
             INTO TABLE @DATA(li_vbak)
             FROM vbak
              FOR ALL ENTRIES IN @lt_data  WHERE vbeln EQ @lt_data-col1.
      IF sy-subrc = 0.
        SORT li_vbak BY vbeln.
      ENDIF.
      IF li_vbak IS NOT INITIAL.

        SELECT vbeln, vbelv, vbtyp_n
               FROM vbfa
               INTO TABLE @DATA(li_vbfa)
               FOR ALL ENTRIES IN @li_vbak
               WHERE vbelv = @li_vbak-vbeln AND
                     vbtyp_n = 'M'.

        SELECT vbeln, posnr, mvgr5, abgru INTO TABLE @DATA(li_vbap)
               FROM vbap
               FOR ALL ENTRIES IN @li_vbak
               WHERE vbeln = @li_vbak-vbeln.
        IF sy-subrc = 0.
          SORT li_vbap BY vbeln posnr.
        ENDIF.
        SELECT vbeln, posnr, konda, bsark, bstkd
               INTO TABLE @DATA(li_vbkd)
               FROM vbkd
               FOR ALL ENTRIES IN @li_vbak
               WHERE vbeln = @li_vbak-vbeln.
        IF sy-subrc = 0.
          SORT li_vbkd BY vbeln posnr.
        ENDIF.

        SELECT vbeln, vposn, vkuegru, vbegdat
               INTO TABLE @DATA(li_veda)
               FROM veda
               FOR ALL ENTRIES IN @li_vbak
               WHERE vbeln = @li_vbak-vbeln.
        IF sy-subrc = 0.
          SORT li_veda BY vbeln vposn.
        ENDIF.
      ENDIF.

      LOOP AT lt_data INTO lw_data.
        lw_entity-vbeln      = lw_data-col1.
        lw_entity-vbtyp      = lw_data-col2.
        lw_entity-fakskt     = lw_data-col3.
        lw_entity-erdat      = lw_data-col4.
        lw_entity-kunnr      = lw_data-col5.
        lw_entity-ernam      = lw_data-col6.
        lw_entity-name1      = lw_data-col7.
        lw_entity-faksk      = lw_data-col8.
        lw_entity-delstat    = lw_data-col9.
        lw_entity-auart      = lw_data-col10.
        lw_entity-hblck      = lw_data-col11.
        lw_entity-iblck      = lw_data-col12.
        lw_entity-usblck     = lw_data-col13.
        lw_entity-cblck      = lw_data-col14.
        READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lw_entity-vbeln.
        IF sy-subrc = 0.
          lw_entity-bdnum = lst_vbfa-vbeln.
        ENDIF.
        READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lw_entity-vbeln.
        IF sy-subrc = 0.
          lw_entity-mvgr5 = lst_vbap-mvgr5.
        ENDIF.
        READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lw_entity-vbeln.
        IF sy-subrc = 0.
          lw_entity-konda = lst_vbkd-konda.
          lw_entity-bsark = lst_vbkd-bsark.
          lw_entity-bstkd = lst_vbkd-bstkd.
        ENDIF.
        READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = lw_entity-vbeln vposn = '000000'.
        IF sy-subrc = 0.
          lw_entity-vbegdat = lst_veda-vbegdat.
        ENDIF.
        READ TABLE li_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lw_entity-vbeln.
        IF sy-subrc EQ 0.
          IF lst_vbak-vbtyp = 'G'.
            lw_entity-vkuegru = lst_veda-vkuegru.
          ELSEIF lst_vbak-vbtyp = 'C'.
            lw_entity-vkuegru = lst_vbap-abgru.
          ENDIF.
        ENDIF.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_entity, lw_data.
      ENDLOOP.

*---------- field mapping when "01STANDARD" display variant is used --------*

*        LOOP AT lt_data INTO lw_data.
*          lw_entity-vbeln      = lw_data-col1.
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lw_entity-vbeln
*            IMPORTING
*              output = lw_entity-vbeln.
*          lw_entity-erdat     = lw_data-col2.
*          lw_entity-kunnr      = lw_data-col3.
*          lw_entity-name1      = lw_data-col4.
*          lw_entity-fakskt     = lw_data-col5.
*          lw_entity-hblck      = lw_data-col6.
*          lw_entity-iblck      = lw_data-col7.
*          lw_entity-usblck     = lw_data-col8.
*          lw_entity-cblck      = lw_data-col9.
*          lw_entity-delstat    = lw_data-col10.
*          lw_entity-ernam      = lw_data-col11.
*          lw_entity-auart      = lw_data-col12.
*
*          APPEND lw_entity TO et_entityset.
*          CLEAR: lw_entity, lw_data.
*        ENDLOOP.

      SORT et_entityset BY vbeln.


    ENDIF.
  ENDIF.
  CALL FUNCTION 'LIST_FREE_MEMORY'.

ENDMETHOD.


  METHOD salesorgset_get_entityset.

    DATA: lw_entity TYPE zcl_zqtc_bb_orders_v23_mpc=>ts_salesorg.

    SELECT vkorg, vtext FROM tvkot INTO TABLE @DATA(li_tvkot) WHERE spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      LOOP AT li_tvkot INTO DATA(lst_tvkot).
        lw_entity-vkorg = lst_tvkot-vkorg.
        lw_entity-vtext = lst_tvkot-vtext.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_entity, lst_tvkot.
      ENDLOOP.
      SORT et_entityset BY vkorg.
    ENDIF.

  ENDMETHOD.


  METHOD sddocset_get_entityset.

*    SELECT vbeln FROM vbak INTO TABLE et_entityset.
*    IF sy-subrc EQ 0.
*      SORT et_entityset BY vbeln.
*    ENDIF.

    SELECT vbeln FROM vbak INTO TABLE et_entityset.
    SORT et_entityset BY vbeln.

    CALL METHOD /iwbep/cl_mgw_data_util=>filtering
      EXPORTING
        it_select_options = it_filter_select_options  " table of select options
      CHANGING
        ct_data           = et_entityset.

    CALL METHOD /iwbep/cl_mgw_data_util=>orderby
      EXPORTING
        it_order = it_order  " the sorting order
      CHANGING
        ct_data  = et_entityset.

    CALL METHOD /iwbep/cl_mgw_data_util=>paging
      EXPORTING
        is_paging = is_paging  " paging structure
      CHANGING
        ct_data   = et_entityset.
  ENDMETHOD.


  METHOD soldtoset_get_entityset.
*    DATA: lw_entity TYPE zcl_zqtc_bb_orders_v23_mpc=>ts_soldto.

*    SELECT kunnr, name1 FROM kna1 INTO TABLE @DATA(li_kna1) UP TO 1000 ROWS.
*    IF sy-subrc EQ 0.
*      LOOP AT li_kna1 INTO DATA(lst_kna1).
*        lw_entity-kunnr = lst_kna1-kunnr.
*        lw_entity-name1 = lst_kna1-name1.
*        APPEND lw_entity TO et_entityset.
*        CLEAR: lw_entity, lst_kna1.
*      ENDLOOP.
*      SORT et_entityset BY kunnr.
*    ENDIF.
*********************************************************************
*    SELECT kunnr name1 FROM kna1 INTO CORRESPONDING FIELDS OF TABLE et_entityset.
*    SORT et_entityset BY kunnr.
*
*    CALL METHOD /iwbep/cl_mgw_data_util=>filtering
*      EXPORTING
*        it_select_options = it_filter_select_options  " table of select options
*      CHANGING
*        ct_data           = et_entityset.

*    CALL METHOD /iwbep/cl_mgw_data_util=>paging
*      EXPORTING
*        is_paging = is_paging  " paging structure
*      CHANGING
*        ct_data   = et_entityset.
**********************************************************************
    IF is_paging IS NOT INITIAL.   "importing param only filled when $top $skip are used
      SELECT kunnr,
             name1
             FROM kna1
             ORDER BY kunnr
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      OFFSET @is_paging-skip UP TO @is_paging-top ROWS.
    ELSE.
      SELECT kunnr name1 FROM kna1
         INTO CORRESPONDING FIELDS OF TABLE et_entityset
         UP TO 100 ROWS.
      SORT et_entityset BY kunnr.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
