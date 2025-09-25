class ZCL_ZQTCO_INCOMPLETE_O_DPC_EXT definition
  public
  inheriting from ZCL_ZQTCO_INCOMPLETE_O_DPC
  create public .

public section.
protected section.

  methods ALLITEMSSET_GET_ENTITYSET
    redefinition .
  methods INCOMPDASHBOARDS_GET_ENTITYSET
    redefinition .
  methods INCOMPHEADERSET_GET_ENTITYSET
    redefinition .
  methods INCOMPITEMSET_GET_ENTITYSET
    redefinition .
  methods INCOMPLETEORDERS_GET_ENTITYSET
    redefinition .
  methods INCOMPLOGSET_GET_ENTITYSET
    redefinition .
  methods MATERIALGROUP5SE_GET_ENTITYSET
    redefinition .
  methods MATERIALSET_GET_ENTITYSET
    redefinition .
  methods ORDERTYPESET_GET_ENTITYSET
    redefinition .
  methods PAYMENTTERMSET_GET_ENTITYSET
    redefinition .
  methods POTYPESET_GET_ENTITYSET
    redefinition .
  methods PRICEGROUPSET_GET_ENTITYSET
    redefinition .
  methods SALESGROUPSET_GET_ENTITYSET
    redefinition .
  methods SALESORGSET_GET_ENTITYSET
    redefinition .
  methods SMODELSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods ZCACONSTSET_GET_ENTITYSET
    redefinition .
  methods IORDERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTCO_INCOMPLETE_O_DPC_EXT IMPLEMENTATION.


  METHOD allitemsset_get_entityset.


    DATA:lv_vbeln(10) TYPE c,
         lr_vbeln     TYPE tms_t_vbeln_range,
         lr_vbeln2    TYPE tms_t_vbeln_range,
         lst_vbeln    TYPE tms_s_vbeln_range,
         lv_var(1)    TYPE c,
         lr_var       TYPE /iwbep/t_cod_select_options,
         lr_var22     TYPE /iwbep/t_cod_select_options,
         lst_var      TYPE /iwbep/s_cod_select_option,
         lv_host      TYPE string,
         lv_port      TYPE string,
         lw_entity    TYPE zcl_zqtco_incomplete_o_mpc=>ts_allitems,
         lv_name      TYPE thead-tdname,
         lt_text      TYPE TABLE OF tline,
         lw_text      TYPE tline,
         lw_sum       TYPE wrbtr,
         lv_mwsbp     TYPE c LENGTH 15.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    CONSTANTS: lv_id   TYPE thead-tdid VALUE '0004',
               lv_lang TYPE thead-tdspras VALUE 'E',
               lv_obj  TYPE thead-tdobject VALUE 'VBBK',
               lc_c    TYPE vbtyp VALUE 'C',
               lc_g    TYPE vbtyp VALUE 'G',
               lc_va02 TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
               lc_va42 TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'VBELN'.
            lv_vbeln = <ls_filter_opt>-low.
            IF lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
              lst_vbeln-sign = 'I'.
              lst_vbeln-option = 'EQ'.
              lst_vbeln-low = lv_vbeln.
              APPEND lst_vbeln TO lr_vbeln.
              CLEAR:lst_vbeln.
            ENDIF.
          WHEN 'VBELN'.
           lv_var = <ls_filter_opt>-low.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    cl_http_server=>if_http_server~get_location(
       IMPORTING host = lv_host
              port = lv_port ).

    IF lr_vbeln IS NOT INITIAL.

      SELECT v~vbeln, v~posnr, v~matnr,v~abgru, v~zmeng, v~zzsubtyp,v~mvgr5,
             v~zzvyp, v~mwsbp,v~netwr, v~erdat, v~ernam,v~waerk,
             va~bstnk, va~auart,va~vkorg, va~vkbur, va~augru,va~bsark, va~faksk, va~lifsk, va~kunnr,
             ve~vposn, ve~vkuesch,ve~vkuegru, ve~vbedkue, ve~vbegdat, ve~venddat,
             vb~fkdat, vb~kdkg2, vb~konda, vb~zterm, vb~zlsch,
             vu~uvwas, vu~gbstk, vu~cmgst,
             kn~name1, kn~adrnr
             INTO TABLE @DATA(lt_vbap) FROM vbap AS v
             INNER JOIN vbak AS va ON  va~vbeln = v~vbeln
             INNER JOIN veda AS ve ON  ve~vbeln = v~vbeln "AND ve~vposn = v~posnr
             INNER JOIN vbkd AS vb ON  vb~vbeln = v~vbeln "AND vb~posnr = v~posnr
             INNER JOIN vbuk AS vu ON vu~vbeln = v~vbeln
             INNER JOIN kna1 AS kn
             ON kn~kunnr = va~kunnr
             WHERE v~vbeln IN @lr_vbeln.

      IF sy-subrc = 0.
        SORT lt_vbap BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM lt_vbap COMPARING vbeln posnr.
      ENDIF.

      SELECT SINGLE vbtyp FROM vbak INTO  @DATA(lv_vbtyp)
             WHERE vbeln IN @lr_vbeln.
      IF sy-subrc NE 0.
        CLEAR:lv_vbtyp.
      ENDIF.

      IF lt_vbap IS NOT INITIAL.
        SELECT matnr, spras, maktx
               FROM makt
               INTO TABLE @DATA(lt_makt)
               FOR ALL ENTRIES IN @lt_vbap
               WHERE matnr EQ @lt_vbap-matnr
               AND   spras EQ @sy-langu.

        IF sy-subrc = 0.
          SORT lt_makt BY matnr.
        ENDIF.

        SELECT faksp, vtext FROM tvfst
        INTO TABLE @DATA(lt_tvfst)
        FOR ALL ENTRIES IN @lt_vbap
        WHERE faksp EQ @lt_vbap-faksk AND spras EQ @sy-langu.

        IF sy-subrc EQ 0.
          SORT lt_tvfst BY faksp.
        ENDIF.

        SELECT lifsp, vtext FROM tvlst
          INTO TABLE @DATA(lt_tvlst)
          FOR ALL ENTRIES IN @lt_vbap
          WHERE lifsp EQ @lt_vbap-lifsk AND spras EQ @sy-langu.

        IF sy-subrc EQ 0.
          SORT lt_tvlst BY lifsp.
        ENDIF.

        SELECT  addrnumber, name1, street, city1,
                region, post_code1, country
                FROM adrc
                INTO TABLE @DATA(lt_adrc)
                FOR ALL ENTRIES IN @lt_vbap
                WHERE addrnumber EQ @lt_vbap-adrnr.

        IF sy-subrc = 0.
        ENDIF.

        SELECT   addrnumber, smtp_addr
                 FROM adr6
                 INTO TABLE @DATA(lt_adr6)
                 FOR ALL ENTRIES IN @lt_vbap
                 WHERE addrnumber EQ @lt_vbap-adrnr.
        IF sy-subrc EQ 0.
        ENDIF.

        SELECT vp~vbeln, vp~posnr, vp~parvw, vp~kunnr, vp~adrnr,
               ad~date_from, ad~nation, ad~addrnumber, ad~name1, ad~street,
               ad~city1, ad~region, ad~post_code1, ad~country,
               a6~persnumber,a6~consnumber, a6~smtp_addr
               INTO TABLE @DATA(lt_vbpa)
               FROM vbpa AS vp
               INNER JOIN adrc AS ad ON ad~addrnumber = vp~adrnr
               INNER JOIN adr6 AS a6 ON a6~addrnumber = vp~adrnr
               FOR ALL ENTRIES IN @lt_vbap
               WHERE ( vp~vbeln EQ @lt_vbap-vbeln AND
               vp~posnr NE '000000' AND vp~parvw EQ 'WE' ).
        IF sy-subrc EQ 0.
          SORT lt_vbpa BY vbeln posnr.
          DELETE ADJACENT DUPLICATES FROM lt_vbpa COMPARING vbeln posnr.
        ENDIF.
      ENDIF.

      LOOP AT lt_vbap INTO DATA(lw_vbap).
        lw_entity-name = lw_vbap-name1.
        MOVE-CORRESPONDING lw_vbap TO lw_entity.

        lv_name = lw_vbap-vbeln.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = lv_id
            language                = lv_lang
            name                    = lv_name
            object                  = lv_obj
          TABLES
            lines                   = lt_text
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          LOOP AT lt_text INTO lw_text.
            lw_entity-csinternalnote =  lw_text-tdline.
          ENDLOOP.
        ENDIF.

        READ TABLE lt_makt INTO DATA(lw_makt) WITH KEY matnr = lw_vbap-matnr.
        IF sy-subrc EQ 0.
          lw_entity-maktx = lw_makt-maktx.
        ENDIF.

        READ TABLE lt_tvfst INTO DATA(lw_tvfst) WITH KEY faksp = lw_vbap-faksk.
        IF sy-subrc EQ 0.
          lw_entity-fakskt = lw_tvfst-vtext.
        ENDIF.

        READ TABLE lt_tvlst INTO DATA(lw_tvlst) WITH KEY lifsp = lw_vbap-lifsk.
        IF sy-subrc EQ 0.
          lw_entity-lifskt = lw_tvlst-vtext.
        ENDIF.

        READ TABLE lt_adrc INTO DATA(lw_adrc) WITH KEY addrnumber = lw_vbap-adrnr.
        IF sy-subrc EQ 0.

          lw_entity-sopaddrs  =  lw_adrc-addrnumber.
          lw_entity-sopstreet =  lw_adrc-street.
          lw_entity-sopcity   =  lw_adrc-city1.
          lw_entity-sopstate  =  lw_adrc-region.
          lw_entity-soppostal  = lw_adrc-post_code1.
          lw_entity-sopcountry = lw_adrc-country.
        ENDIF.
        READ TABLE lt_adr6 INTO DATA(lw_adr6) WITH KEY addrnumber = lw_vbap-adrnr.
        IF sy-subrc EQ 0.
          lw_entity-sopemail = lw_adr6-smtp_addr.
        ENDIF.

        READ TABLE lt_vbpa INTO DATA(lw_vbpa) WITH KEY vbeln = lw_vbap-vbeln.
        IF sy-subrc EQ 0.
          lw_entity-shpbp  = lw_vbpa-kunnr.
          lw_entity-shpname = lw_vbpa-name1.
          lw_entity-shpstreet   = lw_vbpa-street.
          lw_entity-shpcity   = lw_vbpa-city1.
          lw_entity-shpstate   = lw_vbpa-region.
          lw_entity-shppostal   = lw_vbpa-post_code1.
          lw_entity-shpcountry   = lw_vbpa-country.
          lw_entity-shpemail   = lw_vbpa-smtp_addr.
        ENDIF.

        CASE lv_vbtyp.
          WHEN 'C'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lw_vbap-vbeln INTO lw_entity-linkref.
          WHEN 'G'.
            CONCATENATE 'http://' lv_host ':' lv_port lc_va42 lw_vbap-vbeln INTO lw_entity-linkref.
          WHEN 'OTHERS'.
        ENDCASE.

        APPEND lw_entity TO et_entityset.
        CLEAR lw_entity.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


METHOD incompdashboards_get_entityset.

  FIELD-SYMBOLS:
    <ls_filter>     LIKE LINE OF it_filter_select_options,
    <ls_filter_opt> TYPE /iwbep/s_cod_select_option.


  DATA: lst_smodel TYPE /iwbep/s_cod_select_option,
        lir_smodel TYPE /iwbep/t_cod_select_options,
        lst_waerk  TYPE  /iwbep/s_cod_select_option,
        lir_waerk  TYPE /iwbep/t_cod_select_options,
        lst_auart  TYPE tds_rg_auart,
        lir_auart  TYPE STANDARD TABLE OF tds_rg_auart,
        lst_vkorg  TYPE range_vkorg,
        lir_vkorg  TYPE STANDARD TABLE OF range_vkorg,
        lst_bsark  TYPE tds_rg_bsark,
        lir_bsark  TYPE STANDARD TABLE OF tds_rg_bsark,
        lst_kunnr  TYPE kun_range,
        lir_kunnr  TYPE STANDARD TABLE OF kun_range,
        lst_kunwe  TYPE kun_range,
        lir_kunwe  TYPE STANDARD TABLE OF kun_range,
        lst_matnr  TYPE mat_range,
        lir_matnr  TYPE STANDARD TABLE OF mat_range,
        lst_vbeln  TYPE range_vbeln,
        lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
        lst_erdat  TYPE tds_rg_erdat,
        lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
        lst_fkdat  TYPE range_fkdat,
        lir_fkdat  TYPE STANDARD TABLE OF range_fkdat,
        lst_pstat  TYPE /iwbep/s_cod_select_option,
        lir_pstat  TYPE /iwbep/t_cod_select_options,
        lst_zterm  TYPE /iwbep/s_cod_select_option,
        lir_zterm  TYPE /iwbep/t_cod_select_options,
        lst_konda  TYPE /iwbep/s_cod_select_option,
        lir_konda  TYPE /iwbep/t_cod_select_options,
        lst_mvgr5  TYPE /iwbep/s_cod_select_option,
        lir_mvgr5  TYPE /iwbep/t_cod_select_options.

  DATA: lv_smodel TYPE c LENGTH 20,
        lv_vkorg  TYPE vkorg,
        lv_erdat2 TYPE sy-datum,
        lw_entity TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompdashboard.

  CONSTANTS: lc_devid TYPE c LENGTH 12 VALUE 'R144'.

  DATA: li_vkbur TYPE /iwbep/t_cod_select_options,
        li_konda TYPE /iwbep/t_cod_select_options,
        li_mvgr5 TYPE /iwbep/t_cod_select_options,
        li_kdkg2 TYPE /iwbep/t_cod_select_options.
*          li_vkorg TYPE /iwbep/t_cod_select_options.

  FIELD-SYMBOLS: <lst_vkbur_i> TYPE /iwbep/s_cod_select_option,
                 <lst_mvgr5_i> TYPE /iwbep/s_cod_select_option,
                 <lst_kdkg2_i> TYPE /iwbep/s_cod_select_option,
                 <lst_konda_i> TYPE /iwbep/s_cod_select_option,
                 <lst_vkorg_i> TYPE range_vkorg.

  TYPES: BEGIN OF ty_sum,
           vbeln TYPE c LENGTH 10,
           netwr TYPE netwr,
           waerk TYPE waerk,
           model TYPE char20,
    col1 type c length 5,
    col2 type c length 5,
           count TYPE i,
         END OF ty_sum.

  DATA: li_tab  TYPE TABLE OF ty_sum,
        lst_tab TYPE ty_sum.

*------------ Filters for slection criteria -------------*
  LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
    LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
      CASE <ls_filter>-property.
        WHEN 'SMODEL'.                    "Sales Model
          lv_smodel = <ls_filter_opt>-low.
          lst_smodel-sign = <ls_filter_opt>-sign.
          lst_smodel-option = <ls_filter_opt>-option.
          lst_smodel-low = lv_smodel.
          lst_smodel-high = <ls_filter_opt>-high.
          APPEND lst_smodel TO lir_smodel.
        WHEN 'AUART'.                   "Order Type
          lst_auart-sign = <ls_filter_opt>-sign.
          lst_auart-option = <ls_filter_opt>-option.
          lst_auart-low = <ls_filter_opt>-low.
          lst_auart-high = <ls_filter_opt>-high.
          APPEND lst_auart TO lir_auart.
        WHEN 'VKORG'.                   "Sales Org
          lv_vkorg = <ls_filter_opt>-low.
          lst_vkorg-sign = <ls_filter_opt>-sign.
          lst_vkorg-option = <ls_filter_opt>-option.
          lst_vkorg-low = <ls_filter_opt>-low.
          lst_vkorg-high = <ls_filter_opt>-high.
          APPEND lst_vkorg TO lir_vkorg.
        WHEN 'PSTAT'.                  "Payment Status
          lst_pstat-sign = <ls_filter_opt>-sign.
          lst_pstat-option = <ls_filter_opt>-option.
          lst_pstat-low = <ls_filter_opt>-low.
          lst_pstat-high = <ls_filter_opt>-high.
          APPEND lst_pstat TO lir_pstat.
        WHEN 'ZTERM'.                 "Payment Term
          lst_zterm-sign = <ls_filter_opt>-sign.
          lst_zterm-option = <ls_filter_opt>-option.
          lst_zterm-low = <ls_filter_opt>-low.
          lst_zterm-high = <ls_filter_opt>-high.
          APPEND lst_zterm TO lir_zterm.
        WHEN 'BSARK'.                "PO type
          lst_bsark-sign = <ls_filter_opt>-sign.
          lst_bsark-option = <ls_filter_opt>-option.
          lst_bsark-low = <ls_filter_opt>-low.
          lst_bsark-high = <ls_filter_opt>-high.
          APPEND lst_bsark TO lir_bsark.
        WHEN 'KONDA'.               "Price Group
          lst_konda-sign = <ls_filter_opt>-sign.
          lst_konda-option = <ls_filter_opt>-option.
          lst_konda-low = <ls_filter_opt>-low.
          lst_konda-high = <ls_filter_opt>-high.
          APPEND lst_konda TO lir_konda.
        WHEN 'KUNNR'.              "Soldto party
          lst_kunnr-sign = <ls_filter_opt>-sign.
          lst_kunnr-option = <ls_filter_opt>-option.
          lst_kunnr-kunnr_low = <ls_filter_opt>-low.
          lst_kunnr-kunnr_high = <ls_filter_opt>-high.
          APPEND lst_kunnr TO lir_kunnr.
        WHEN 'KUNWE'.             "Shipto Party
          lst_kunwe-sign = <ls_filter_opt>-sign.
          lst_kunwe-option = <ls_filter_opt>-option.
          lst_kunwe-kunnr_low = <ls_filter_opt>-low.
          lst_kunwe-kunnr_high = <ls_filter_opt>-high.
          APPEND lst_kunwe TO lir_kunwe.
        WHEN 'MATNR'.             "Material Number
          lst_matnr-sign = <ls_filter_opt>-sign.
          lst_matnr-option = <ls_filter_opt>-option.
          lst_matnr-matnr_low = <ls_filter_opt>-low.
          lst_matnr-matnr_high = <ls_filter_opt>-high.
          APPEND lst_matnr TO lir_matnr.
        WHEN 'MVGR5'.             "Material Group5
          lst_mvgr5-sign = <ls_filter_opt>-sign.
          lst_mvgr5-option = <ls_filter_opt>-option.
          lst_mvgr5-low = <ls_filter_opt>-low.
          lst_mvgr5-high = <ls_filter_opt>-high.
          APPEND lst_mvgr5 TO lir_mvgr5.
        WHEN 'VBELN'.             "Sales Document
          lst_vbeln-sign = <ls_filter_opt>-sign.
          lst_vbeln-option = <ls_filter_opt>-option.
          lst_vbeln-low = <ls_filter_opt>-low.
          lst_vbeln-high = <ls_filter_opt>-high.
          APPEND lst_vbeln TO lir_vbeln.
*          WHEN 'ERDAT'.
*            lst_erdat-sign = <ls_filter_opt>-sign.
*            lst_erdat-option = <ls_filter_opt>-option.
*            lst_erdat-low = <ls_filter_opt>-low.
*            lst_erdat-high = <ls_filter_opt>-high.
*            APPEND lst_erdat TO lir_erdat.
*          WHEN 'FKDAT'.
*            lst_fkdat-sign = <ls_filter_opt>-sign.
*            lst_fkdat-option = <ls_filter_opt>-option.
*            lst_fkdat-low = <ls_filter_opt>-low.
*            lst_fkdat-high = <ls_filter_opt>-high.
*            APPEND lst_fkdat TO lir_fkdat.
        WHEN OTHERS.
          "Do nothing
      ENDCASE.
    ENDLOOP.
  ENDLOOP.
*------ Fetch Constant Table entries --------*
  SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
         WHERE devid = @lc_devid.

  LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
    IF lv_smodel IS NOT INITIAL."
      IF <lw_const>-param2 = lv_smodel."
        IF <lw_const>-param1 = 'VKBUR'.
          APPEND INITIAL LINE TO li_vkbur ASSIGNING <lst_vkbur_i>.
          <lst_vkbur_i>-sign   = <lw_const>-sign.
          <lst_vkbur_i>-option = <lw_const>-opti.
          <lst_vkbur_i>-low    = <lw_const>-low.
          <lst_vkbur_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KONDA'.
          APPEND INITIAL LINE TO li_konda ASSIGNING <lst_konda_i>.
          <lst_konda_i>-sign   = <lw_const>-sign.
          <lst_konda_i>-option = <lw_const>-opti.
          <lst_konda_i>-low    = <lw_const>-low.
          <lst_konda_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'MVGR5'.
          APPEND INITIAL LINE TO li_mvgr5 ASSIGNING <lst_mvgr5_i>.
          <lst_mvgr5_i>-sign   = <lw_const>-sign.
          <lst_mvgr5_i>-option = <lw_const>-opti.
          <lst_mvgr5_i>-low    = <lw_const>-low.
          <lst_mvgr5_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KDKG2'.
          APPEND INITIAL LINE TO li_kdkg2 ASSIGNING <lst_kdkg2_i>.
          <lst_kdkg2_i>-sign   = <lw_const>-sign.
          <lst_kdkg2_i>-option = <lw_const>-opti.
          <lst_kdkg2_i>-low    = <lw_const>-low.
          <lst_kdkg2_i>-high   = <lw_const>-high.
        ENDIF.
      ENDIF.

    ELSEIF lv_smodel IS INITIAL.

      IF <lw_const>-param1 = 'VKBUR'.
        APPEND INITIAL LINE TO li_vkbur ASSIGNING <lst_vkbur_i>.
        <lst_vkbur_i>-sign   = <lw_const>-sign.
        <lst_vkbur_i>-option = <lw_const>-opti.
        <lst_vkbur_i>-low    = <lw_const>-low.
        <lst_vkbur_i>-high   = <lw_const>-high.
      ENDIF.

      IF <lw_const>-param1 = 'KONDA'.
        APPEND INITIAL LINE TO li_konda ASSIGNING <lst_konda_i>.
        <lst_konda_i>-sign   = <lw_const>-sign.
        <lst_konda_i>-option = <lw_const>-opti.
        <lst_konda_i>-low    = <lw_const>-low.
        <lst_konda_i>-high   = <lw_const>-high.
      ENDIF.

      IF <lw_const>-param1 = 'MVGR5'.
        APPEND INITIAL LINE TO li_mvgr5 ASSIGNING <lst_mvgr5_i>.
        <lst_mvgr5_i>-sign   = <lw_const>-sign.
        <lst_mvgr5_i>-option = <lw_const>-opti.
        <lst_mvgr5_i>-low    = <lw_const>-low.
        <lst_mvgr5_i>-high   = <lw_const>-high.
      ENDIF.

      IF <lw_const>-param1 = 'KDKG2'.
        APPEND INITIAL LINE TO li_kdkg2 ASSIGNING <lst_kdkg2_i>.
        <lst_kdkg2_i>-sign   = <lw_const>-sign.
        <lst_kdkg2_i>-option = <lw_const>-opti.
        <lst_kdkg2_i>-low    = <lw_const>-low.
        <lst_kdkg2_i>-high   = <lw_const>-high.
      ENDIF.

    ENDIF.
    IF lv_vkorg IS INITIAL AND <lw_const>-param1 = 'VKORG' .
      APPEND INITIAL LINE TO lir_vkorg ASSIGNING <lst_vkorg_i>.
      <lst_vkorg_i>-sign   = <lw_const>-sign.
      <lst_vkorg_i>-option = <lw_const>-opti.
      <lst_vkorg_i>-low    = <lw_const>-low.
      <lst_vkorg_i>-high   = <lw_const>-high.
    ENDIF.



  ENDLOOP.

*---------- Fetch incomplete orders -------------*
  lv_erdat2 = sy-datum - 300.
  SELECT v~vbeln, v~vkorg, v~vkbur, v~auart,v~erdat,
      vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid
      ,vp~netwr, vp~waerk, vp~mvgr5
      ,vk~kdkg2, vk~konda
     INTO TABLE @DATA(lt_vbak)
     FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
     INNER JOIN vbap AS vp ON  vp~vbeln = vb~vbeln AND vp~posnr = vb~posnr
     INNER JOIN vbkd AS vk ON  vk~vbeln = vb~vbeln and vk~posnr = vb~posnr
     WHERE vb~vbeln IN @lir_vbeln and v~vkorg IN @lir_vkorg
       AND ( v~vkbur IN @li_vkbur "OR v~vkorg IN @lir_vkorg
        OR  vp~mvgr5 IN @li_mvgr5 OR vk~kdkg2 IN @li_kdkg2 OR vk~konda IN @li_konda )
     AND ( v~erdat GE @lv_erdat2 AND v~erdat LE @sy-datum  ).

  IF sy-subrc EQ 0.
    DELETE lt_vbak WHERE waerk IS INITIAL.
    SORT lt_vbak BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln posnr.



*---------------------To categorize and count the orders ---------*
    LOOP AT lt_vbak INTO DATA(lw_vbak).
      CLEAR lst_tab.
      if lw_vbak-waerk eq 'USD'.
        lst_tab-col1 = lw_vbak-waerk.
      elseif lw_vbak-waerk eq 'EUR'.
        lst_tab-col2 = lw_vbak-waerk.
      endif.
      IF lw_vbak-vkbur = '0050'.
        lst_tab-model = 'AM'.

      ELSEIF lw_vbak-vkbur = '0030'.
        lst_tab-model = 'CSS'.

      ELSEIF lw_vbak-vkbur = '0080'.
        IF ( lw_vbak-konda EQ '02' OR lw_vbak-konda EQ '03' OR lw_vbak-konda EQ '04' )
        AND ( lw_vbak-mvgr5 EQ 'WP' OR lw_vbak-mvgr5 EQ 'MA' OR lw_vbak-mvgr5 EQ 'DI' OR
              lw_vbak-mvgr5 EQ 'SO').
          lst_tab-model = 'TBT'.

        ELSEIF  lw_vbak-konda EQ '02'
        AND ( lw_vbak-mvgr5 EQ 'OF' OR lw_vbak-mvgr5 EQ 'MA' OR lw_vbak-mvgr5 EQ 'DI' OR
              lw_vbak-mvgr5 EQ 'SO' OR lw_vbak-mvgr5 EQ 'IN')
        AND ( lw_vbak-kdkg2 EQ '02' ).
          lst_tab-model = 'SOC'.
        ELSE.
          lst_tab-model = 'OTHERS'.
        ENDIF.

      ELSE.
        lst_tab-model = 'OTHERS'.

      ENDIF.
      AT END OF vbeln.
        lst_tab-count = 1.
      ENDAT.
      lst_tab-netwr = lw_vbak-netwr.
      lst_tab-waerk = lw_vbak-waerk.
      COLLECT lst_tab INTO li_tab.

    ENDLOOP.



    LOOP AT li_tab INTO lst_tab.

          lw_entity-model = lst_tab-model.
          lw_entity-waerk = lst_tab-waerk.
          lw_entity-netwr = lst_tab-netwr.
          lw_entity-col1 = lst_tab-col1.
          lw_entity-col2 = lst_tab-col2.
          lw_entity-count = lst_tab-count.

      APPEND lw_entity TO et_entityset.
      CLEAR :lw_entity,lst_tab.

    ENDLOOP.


  ENDIF.

ENDMETHOD.


 METHOD incompheaderset_get_entityset.

   FIELD-SYMBOLS:
     <ls_filter>     LIKE LINE OF it_filter_select_options,
     <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

   TYPES: BEGIN OF ty_sum,
            vbeln TYPE c LENGTH 60,
            mwsbp TYPE mwsbp,
            netwr TYPE netwr,
          END OF ty_sum.

   DATA: lst_smodel TYPE /iwbep/s_cod_select_option,
         lir_smodel TYPE /iwbep/t_cod_select_options,
         lst_waerk  TYPE  /iwbep/s_cod_select_option,
         lir_waerk  TYPE /iwbep/t_cod_select_options,
         lst_auart  TYPE tds_rg_auart,
         lir_auart  TYPE STANDARD TABLE OF tds_rg_auart,
         lst_vkorg  TYPE range_vkorg,
         lir_vkorg  TYPE STANDARD TABLE OF range_vkorg,
         lst_bsark  TYPE tds_rg_bsark,
         lir_bsark  TYPE STANDARD TABLE OF tds_rg_bsark,
         lst_kunnr  TYPE kun_range,
         lir_kunnr  TYPE STANDARD TABLE OF kun_range,
         lst_kunwe  TYPE kun_range,
         lir_kunwe  TYPE STANDARD TABLE OF kun_range,
         lst_matnr  TYPE mat_range,
         lir_matnr  TYPE STANDARD TABLE OF mat_range,
         lst_vbeln  TYPE range_vbeln,
         lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
         lst_erdat  TYPE tds_rg_erdat,
         lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
         lst_fkdat  TYPE range_fkdat,
         lir_fkdat  TYPE STANDARD TABLE OF range_fkdat,
         lst_pstat  TYPE /iwbep/s_cod_select_option,
         lir_pstat  TYPE /iwbep/t_cod_select_options,
         lst_zterm  TYPE /iwbep/s_cod_select_option,
         lir_zterm  TYPE /iwbep/t_cod_select_options,
         lst_konda  TYPE /iwbep/s_cod_select_option,
         lir_konda  TYPE /iwbep/t_cod_select_options,
         lst_mvgr5  TYPE /iwbep/s_cod_select_option,
         lir_mvgr5  TYPE /iwbep/t_cod_select_options.

   DATA: lv_smodel   TYPE c LENGTH 10,
         lv_vkorg    TYPE c LENGTH 4,
         lv_erdat2   TYPE sy-datum,
         lv_tdspras  TYPE spras,
         lt_csinote  TYPE TABLE OF tline,
         lv_vbeln_rt TYPE c LENGTH 70,
         lw_mwsbp_c  TYPE c LENGTH 20,
         lw_tax      TYPE dmbtr,
         lw_netwr_c  TYPE c LENGTH 20,
         lw_nvalue   TYPE dmbtr,
         lv_vbtyp    TYPE vbtyp,
         lv_host     TYPE string,
         lv_port     TYPE string,
         lw_entity   TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompheader.

   DATA: li_vkorg  TYPE /iwbep/t_cod_select_options,
         li_vkbur  TYPE /iwbep/t_cod_select_options,
         li_vkburc TYPE /iwbep/t_cod_select_options,
         li_vkburt TYPE /iwbep/t_cod_select_options,
         li_vkburs TYPE /iwbep/t_cod_select_options,
         li_konda  TYPE /iwbep/t_cod_select_options,
         li_kondas TYPE /iwbep/t_cod_select_options,
         li_mvgr5  TYPE /iwbep/t_cod_select_options,
         li_mvgr5s TYPE /iwbep/t_cod_select_options,
         li_kdkg2  TYPE /iwbep/t_cod_select_options.

   CONSTANTS: lc_devid TYPE c LENGTH 10 VALUE 'R144'.

   DATA: lr_vkbur TYPE /iwbep/t_cod_select_options,
         lr_konda TYPE /iwbep/t_cod_select_options,
         lr_mvgr5 TYPE /iwbep/t_cod_select_options,
         lr_kdkg2 TYPE /iwbep/t_cod_select_options.


   CONSTANTS: lc_tdid     TYPE tdid VALUE '0004',
              lc_tdobject TYPE tdobject VALUE 'VBBK',
              lc_posnr    TYPE posnr VALUE '000000',
              lc_we       TYPE parvw VALUE 'WE',
              lc_va02     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
              lc_va42     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.

   DATA: lt_sum TYPE TABLE OF ty_sum,
         lw_sum TYPE ty_sum.

   cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
             port = lv_port ).

*-----------Filters for selection criteria-----------*
   LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
     LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
       CASE <ls_filter>-property.
         WHEN 'SMODEL'.
           lv_smodel = <ls_filter_opt>-low.
           IF lv_smodel NE 'OTHERS'.
             lst_smodel-sign = <ls_filter_opt>-sign.
             lst_smodel-option = <ls_filter_opt>-option.
             lst_smodel-low = lv_smodel.
             lst_smodel-high = <ls_filter_opt>-high.
             APPEND lst_smodel TO lir_smodel.
           ENDIF.
         WHEN 'WAERK'.
           lst_waerk-sign = <ls_filter_opt>-sign.
           lst_waerk-option = <ls_filter_opt>-option.
           lst_waerk-low = <ls_filter_opt>-low.
           lst_waerk-high = <ls_filter_opt>-high.
           APPEND lst_waerk TO lir_waerk.
         WHEN 'AUART'.
           lst_auart-sign = <ls_filter_opt>-sign.
           lst_auart-option = <ls_filter_opt>-option.
           lst_auart-low = <ls_filter_opt>-low.
           lst_auart-high = <ls_filter_opt>-high.
           APPEND lst_auart TO lir_auart.
         WHEN 'VKORG'.
           lst_vkorg-sign = <ls_filter_opt>-sign.
           lst_vkorg-option = <ls_filter_opt>-option.
           lst_vkorg-low = <ls_filter_opt>-low.
           lst_vkorg-high = <ls_filter_opt>-high.
           APPEND lst_vkorg TO lir_vkorg.
         WHEN 'PSTAT'.
           lst_pstat-sign = <ls_filter_opt>-sign.
           lst_pstat-option = <ls_filter_opt>-option.
           lst_pstat-low = <ls_filter_opt>-low.
           lst_pstat-high = <ls_filter_opt>-high.
           APPEND lst_pstat TO lir_pstat.
         WHEN 'ZTERM'.
           lst_zterm-sign = <ls_filter_opt>-sign.
           lst_zterm-option = <ls_filter_opt>-option.
           lst_zterm-low = <ls_filter_opt>-low.
           lst_zterm-high = <ls_filter_opt>-high.
           APPEND lst_zterm TO lir_zterm.
         WHEN 'BSARK'.
           lst_bsark-sign = <ls_filter_opt>-sign.
           lst_bsark-option = <ls_filter_opt>-option.
           lst_bsark-low = <ls_filter_opt>-low.
           lst_bsark-high = <ls_filter_opt>-high.
           APPEND lst_bsark TO lir_bsark.
         WHEN 'KONDA'.
           lst_konda-sign = <ls_filter_opt>-sign.
           lst_konda-option = <ls_filter_opt>-option.
           lst_konda-low = <ls_filter_opt>-low.
           lst_konda-high = <ls_filter_opt>-high.
           APPEND lst_konda TO lir_konda.
         WHEN 'KUNNR'.
           lst_kunnr-sign = <ls_filter_opt>-sign.
           lst_kunnr-option = <ls_filter_opt>-option.
           lst_kunnr-kunnr_low = <ls_filter_opt>-low.
           lst_kunnr-kunnr_high = <ls_filter_opt>-high.
           APPEND lst_kunnr TO lir_kunnr.
         WHEN 'KUNWE'.
           lst_kunwe-sign = <ls_filter_opt>-sign.
           lst_kunwe-option = <ls_filter_opt>-option.
           lst_kunwe-kunnr_low = <ls_filter_opt>-low.
           lst_kunwe-kunnr_high = <ls_filter_opt>-high.
           APPEND lst_kunwe TO lir_kunwe.
*         WHEN 'SOCIETY'.
*           lst_kunwe-sign = <ls_filter_opt>-sign.
*           lst_kunwe-option = <ls_filter_opt>-option.
*           lst_kunwe-kunnr_low = <ls_filter_opt>-low.
*           lst_kunwe-kunnr_high = <ls_filter_opt>-high.
*           APPEND lst_kunwe TO lir_kunwe.
*         WHEN 'LIFNR'.
*           lst_kunwe-sign = <ls_filter_opt>-sign.
*           lst_kunwe-option = <ls_filter_opt>-option.
*           lst_kunwe-kunnr_low = <ls_filter_opt>-low.
*           lst_kunwe-kunnr_high = <ls_filter_opt>-high.
*           APPEND lst_kunwe TO lir_kunwe.
         WHEN 'MATNR'.
           lst_matnr-sign = <ls_filter_opt>-sign.
           lst_matnr-option = <ls_filter_opt>-option.
           lst_matnr-matnr_low = <ls_filter_opt>-low.
           lst_matnr-matnr_high = <ls_filter_opt>-high.
           APPEND lst_matnr TO lir_matnr.
         WHEN 'MVGR5'.
           lst_mvgr5-sign = <ls_filter_opt>-sign.
           lst_mvgr5-option = <ls_filter_opt>-option.
           lst_mvgr5-low = <ls_filter_opt>-low.
           lst_mvgr5-high = <ls_filter_opt>-high.
           APPEND lst_mvgr5 TO lir_mvgr5.
         WHEN 'VBELN'.
           lst_vbeln-sign = <ls_filter_opt>-sign.
           lst_vbeln-option = <ls_filter_opt>-option.
           lst_vbeln-low = <ls_filter_opt>-low.
           lst_vbeln-high = <ls_filter_opt>-high.
           APPEND lst_vbeln TO lir_vbeln.
*          WHEN 'ERDAT'.
*            lst_erdat-sign = <ls_filter_opt>-sign.
*            lst_erdat-option = <ls_filter_opt>-option.
*            lst_erdat-low = <ls_filter_opt>-low.
*            lst_erdat-high = <ls_filter_opt>-high.
*            APPEND lst_erdat TO lir_erdat.
*          WHEN 'FKDAT'.
*            lst_fkdat-sign = <ls_filter_opt>-sign.
*            lst_fkdat-option = <ls_filter_opt>-option.
*            lst_fkdat-low = <ls_filter_opt>-low.
*            lst_fkdat-high = <ls_filter_opt>-high.
*            APPEND lst_fkdat TO lir_fkdat.
*            WHEN 'OTHERS'.
*              "Do nothing
       ENDCASE.
     ENDLOOP.
   ENDLOOP.

*------------------- Fetch constant table entries --------------*
   SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
          WHERE devid = @lc_devid.

     LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
     IF <lw_const>-param2 = lv_smodel.
        IF <lw_const>-param1 = 'VKBUR'.
          APPEND INITIAL LINE TO lr_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
          <lst_vkbur_i>-sign   = <lw_const>-sign.
          <lst_vkbur_i>-option = <lw_const>-opti.
          <lst_vkbur_i>-low    = <lw_const>-low.
          <lst_vkbur_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KONDA'.
          APPEND INITIAL LINE TO lr_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
          <lst_konda_i>-sign   = <lw_const>-sign.
          <lst_konda_i>-option = <lw_const>-opti.
          <lst_konda_i>-low    = <lw_const>-low.
          <lst_konda_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'MVGR5'.
          APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
          <lst_mvgr5_i>-sign   = <lw_const>-sign.
          <lst_mvgr5_i>-option = <lw_const>-opti.
          <lst_mvgr5_i>-low    = <lw_const>-low.
          <lst_mvgr5_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KDKG2'.
          APPEND INITIAL LINE TO lr_kdkg2 ASSIGNING FIELD-SYMBOL(<lst_kdkg2_i>).
          <lst_kdkg2_i>-sign   = <lw_const>-sign.
          <lst_kdkg2_i>-option = <lw_const>-opti.
          <lst_kdkg2_i>-low    = <lw_const>-low.
          <lst_kdkg2_i>-high   = <lw_const>-high.
        ENDIF.
      ENDIF.

      IF lv_vkorg IS INITIAL AND <lw_const>-param1 = 'VKORG' .
        APPEND INITIAL LINE TO li_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
        <lst_vkorg_i>-sign   = <lw_const>-sign.
        <lst_vkorg_i>-option = <lw_const>-opti.
        <lst_vkorg_i>-low    = <lw_const>-low.
        <lst_vkorg_i>-high   = <lw_const>-high.
      ENDIF.
    ENDLOOP.


*   LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lst_const>).
*     CASE <lst_const>-param2.
*       WHEN 'AM'.
*         IF <lst_const>-param1 = 'VKBUR'.
*           APPEND INITIAL LINE TO li_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur>).
*           <lst_vkbur>-sign = <lst_const>-sign.
*           <lst_vkbur>-option = <lst_const>-opti.
*           <lst_vkbur>-low =  <lst_const>-low.
*           <lst_vkbur>-high = <lst_const>-high.
*         ENDIF.
*       WHEN 'CSS'.
*         IF <lst_const>-param1 = 'VKBUR'.
*           APPEND INITIAL LINE TO li_vkburc ASSIGNING <lst_vkbur>.
*           <lst_vkbur>-sign = <lst_const>-sign.
*           <lst_vkbur>-option = <lst_const>-opti.
*           <lst_vkbur>-low =  <lst_const>-low.
*           <lst_vkbur>-high = <lst_const>-high.
*         ENDIF.
*       WHEN 'TBT'.
*         IF <lst_const>-param1 = 'VKBUR'.
*           APPEND INITIAL LINE TO li_vkburt ASSIGNING <lst_vkbur>.
*           <lst_vkbur>-sign = <lst_const>-sign.
*           <lst_vkbur>-option = <lst_const>-opti.
*           <lst_vkbur>-low =  <lst_const>-low.
*           <lst_vkbur>-high = <lst_const>-high.
*         ELSEIF <lst_const>-param1 = 'KONDA'.
*           APPEND INITIAL LINE TO li_konda ASSIGNING FIELD-SYMBOL(<lst_konda>).
*           <lst_konda>-sign = <lst_const>-sign.
*           <lst_konda>-option = <lst_const>-opti.
*           <lst_konda>-low =  <lst_const>-low.
*           <lst_konda>-high = <lst_const>-high.
*         ELSEIF <lst_const>-param1 = 'MVGR5'.
*           APPEND INITIAL LINE TO li_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5>) .
*           <lst_mvgr5>-sign = <lst_const>-sign.
*           <lst_mvgr5>-option = <lst_const>-opti.
*           <lst_mvgr5>-low =  <lst_const>-low.
*           <lst_mvgr5>-high = <lst_const>-high.
*         ENDIF.
*       WHEN 'SOC'.
*         IF <lst_const>-param1 = 'VKBUR'.
*           APPEND INITIAL LINE TO li_vkburs ASSIGNING <lst_vkbur>.
*           <lst_vkbur>-sign = <lst_const>-sign.
*           <lst_vkbur>-option = <lst_const>-opti.
*           <lst_vkbur>-low =  <lst_const>-low.
*           <lst_vkbur>-high = <lst_const>-high.
*         ELSEIF <lst_const>-param1 = 'KONDA'.
*           APPEND INITIAL LINE TO li_kondas ASSIGNING <lst_konda>.
*           <lst_konda>-sign = <lst_const>-sign.
*           <lst_konda>-option = <lst_const>-opti.
*           <lst_konda>-low =  <lst_const>-low.
*           <lst_konda>-high = <lst_const>-high.
*         ELSEIF <lst_const>-param1 = 'MVGR5'.
*           APPEND INITIAL LINE TO li_mvgr5s ASSIGNING <lst_mvgr5>.
*           <lst_mvgr5>-sign = <lst_const>-sign.
*           <lst_mvgr5>-option = <lst_const>-opti.
*           <lst_mvgr5>-low =  <lst_const>-low.
*           <lst_mvgr5>-high = <lst_const>-high.
*         ELSEIF <lst_const>-param1 = 'KDKG2'.
*           APPEND INITIAL LINE TO li_kdkg2 ASSIGNING FIELD-SYMBOL(<lst_kdkg2>).
*           <lst_kdkg2>-sign = <lst_const>-sign.
*           <lst_kdkg2>-option = <lst_const>-opti.
*           <lst_kdkg2>-low =  <lst_const>-low.
*           <lst_kdkg2>-high = <lst_const>-high.
*         ENDIF.
*     ENDCASE.
*
*     IF lv_vkorg IS INITIAL AND <lst_const>-param1 = 'VKORG' .
*       APPEND INITIAL LINE TO li_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
*       <lst_vkorg_i>-sign   = <lst_const>-sign.
*       <lst_vkorg_i>-option = <lst_const>-opti.
*       <lst_vkorg_i>-low    = <lst_const>-low.
*       <lst_vkorg_i>-high   = <lst_const>-high.
*     ENDIF.
*   ENDLOOP.

*   LOOP AT lir_smodel INTO DATA(lw_smodel).
*     IF lw_smodel-low = 'AM'.
*       lr_vkbur = li_vkbur.
*     ELSEIF lw_smodel-low EQ 'CSS'.
*       lr_vkbur = li_vkburc.
*     ELSEIF lw_smodel-low EQ 'TBT'.
*       lr_vkbur = li_vkburt.
*       lr_konda = li_konda.
*       lr_mvgr5 = li_mvgr5.
*     ELSEIF lw_smodel-low EQ 'SOC'.
*       lr_vkbur = li_vkburs.
*       lr_konda = li_kondas.
*       lr_mvgr5 = li_mvgr5s.
*       lr_kdkg2 = li_kdkg2.
*     ENDIF.
*   ENDLOOP.



*------------------- Fetch incomplete orders data --------------*
   lv_erdat2 = sy-datum - 300.
   SELECT v~vbeln, v~vkorg, v~vkbur, v~vbtyp, v~auart,v~erdat,
          v~ernam, v~bstnk, v~kunnr, v~augru, v~bsark, v~faksk, v~lifsk,
          vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid,
          p~netwr AS nvalue, p~waerk, p~mvgr5, p~zzvyp, p~zzsubtyp,
          p~zmeng, p~mwsbp AS tax, p~matnr,
          d~konda, d~kdkg2, d~zterm, d~zlsch,
          k~name1, k~adrnr,
*          a~addrnumber, am~smtp_addr, a~street,
*          a~city1, a~region, a~post_code1, a~country,
          vk~gbstk, vp~gbsta
     INTO TABLE @DATA(lt_vbak)
     FROM vbak AS v
     INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
     INNER JOIN vbap AS p ON p~vbeln = v~vbeln AND p~posnr = vb~posnr
     INNER JOIN vbkd AS d ON d~vbeln = v~vbeln AND d~posnr = vb~posnr
     INNER JOIN kna1 AS k ON k~kunnr = v~kunnr
*     INNER JOIN adrc AS a ON a~addrnumber = k~adrnr
*     INNER JOIN adr6 AS am ON am~addrnumber = k~adrnr
*     INNER JOIN tvfst AS f ON f~faksp = v~faksk AND f~spras = @sy-langu
*     INNER JOIN tvlst AS l ON l~lifsp = v~lifsk AND l~spras = @sy-langu
     INNER JOIN vbuk AS vk ON vk~vbeln = v~vbeln
     INNER JOIN vbup AS vp ON vp~vbeln = v~vbeln AND vp~posnr = vb~posnr
     WHERE v~vkorg IN @li_vkorg AND v~vkbur IN @lr_vkbur
        AND p~mvgr5 IN @lr_mvgr5 AND p~waerk IN @lir_waerk
        AND d~konda IN @lr_konda AND d~kdkg2 IN @lr_kdkg2
        AND vb~vbeln IN @lir_vbeln AND v~kunnr IN @lir_kunnr
        AND v~auart IN @lir_auart AND v~vkorg IN @lir_vkorg
        AND d~zterm IN @lir_zterm AND p~matnr IN @lir_matnr
        AND v~bsark IN @lir_bsark
        AND  ( v~erdat LE @sy-datum AND v~erdat GE @lv_erdat2 ).

   IF sy-subrc EQ 0.

       SORT lt_vbak BY vbeln posnr.
       DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln posnr.


      LOOP AT lt_vbak INTO DATA(lw_vbak).
        lw_sum-vbeln = lw_vbak-vbeln.
        lw_sum-netwr = lw_vbak-nvalue.
        lw_sum-mwsbp = lw_vbak-tax.
        COLLECT lw_sum INTO lt_sum.
        CLEAR: lw_vbak.
      ENDLOOP.

     IF sy-subrc EQ 0.
       sort lt_vbak by vbeln.
       DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln.
     ENDIF.


     SELECT lifsp, vtext FROM tvlst
        INTO TABLE @DATA(lt_tvlst)
        FOR ALL ENTRIES IN @lt_vbak
        WHERE lifsp EQ @lt_vbak-lifsk AND spras EQ @sy-langu.
     IF sy-subrc EQ 0.
       Sort lt_tvlst by lifsp.
     ENDIF.

     SELECT faksp, vtext FROM tvfst
       INTO TABLE @DATA(lt_tvfst)
       FOR ALL ENTRIES IN @lt_vbak
       WHERE faksp EQ @lt_vbak-faksk AND spras EQ @sy-langu.
     IF sy-subrc EQ 0.
       Sort lt_tvfst by faksp.
     ENDIF.

     SELECT vpa~vbeln, vpa~posnr, vpa~parvw, vpa~kunnr, vpa~adrnr,
            ad~addrnumber, ad~street, am~smtp_addr,
            ad~city1, ad~region, ad~post_code1, ad~country
            INTO TABLE @DATA(lt_vbpa)
            FROM vbpa AS vpa
            INNER JOIN adrc AS ad ON ad~addrnumber = vpa~adrnr
            INNER JOIN adr6 AS am ON am~addrnumber = vpa~adrnr
            FOR ALL ENTRIES IN @lt_vbak
            WHERE vbeln EQ @lt_vbak-vbeln AND
            posnr EQ @lc_posnr AND parvw EQ @lc_we.
     IF sy-subrc EQ 0.
       Sort lt_vbpa by vbeln posnr.
       Delete ADJACENT DUPLICATES FROM lt_vbpa COMPARING vbeln posnr.
     ENDIF.



     LOOP AT lt_vbak INTO lw_vbak.
       MOVE-CORRESPONDING lw_vbak TO lw_entity.
       lw_entity-vbeln = lw_vbak-vbeln.
       lw_entity-smodel = lv_smodel.
       lw_entity-name = lw_vbak-name1.
       lw_entity-gbstk = lw_vbak-gbstk.
       lw_entity-gbsta = lw_vbak-gbsta.
*       lw_entity-agaddr = lw_vbak-addrnumber.
*       lw_entity-agemail = lw_vbak-smtp_addr.
*       lw_entity-agstreet = lw_vbak-street.
*       lw_entity-agcity   = lw_vbak-city1.
*       lw_entity-agstate  = lw_vbak-region.
*       lw_entity-agpostal = lw_vbak-post_code1.
*       lw_entity-agcountry = lw_vbak-country.
       lv_tdspras = sy-langu.
       lv_vbeln_rt = lw_vbak-vbeln.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = lc_tdid
           language                = lv_tdspras
           name                    = lv_vbeln_rt
           object                  = lc_tdobject
         TABLES
           lines                   = lt_csinote
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc EQ 0.
         LOOP AT lt_csinote INTO DATA(lw_csinote).
           lw_entity-vbbk0004 =  lw_csinote-tdline.
         ENDLOOP.
       ENDIF.
       lv_vbtyp  = lw_vbak-vbtyp.
       CASE lv_vbtyp.
         WHEN 'C'.
           CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lw_vbak-vbeln INTO lw_entity-link.
         WHEN 'G'.
           CONCATENATE 'http://' lv_host ':' lv_port lc_va42 lw_vbak-vbeln INTO lw_entity-link.
         WHEN OTHERS.
           " Do nothing.
       ENDCASE.

       READ TABLE lt_sum INTO lw_sum WITH KEY vbeln = lw_vbak-vbeln.
       IF sy-subrc EQ 0.
         lw_entity-netwr = lw_sum-netwr.
         lw_entity-mwsbp = lw_sum-mwsbp.
       ENDIF.
       READ TABLE lt_tvfst INTO DATA(lw_tvfst) WITH KEY faksp = lw_vbak-faksk.
       IF sy-subrc EQ 0.
         lw_entity-fakskt = lw_tvfst-vtext.
       ENDIF.
       READ TABLE lt_tvlst INTO DATA(lw_tvlst) WITH KEY lifsp = lw_vbak-lifsk.
       IF sy-subrc EQ 0.
         lw_entity-lifskt = lw_tvlst-vtext.
       ENDIF.
       READ TABLE lt_vbpa INTO DATA(lw_vbpa) WITH KEY vbeln = lw_vbak-vbeln.
       IF sy-subrc EQ 0.
         lw_entity-webp   = lw_vbpa-kunnr.
         lw_entity-weemail = lw_vbpa-smtp_addr.
         lw_entity-westreet = lw_vbpa-street.
         lw_entity-wecity   = lw_vbpa-city1.
         lw_entity-westate  = lw_vbpa-region.
         lw_entity-wepostal = lw_vbpa-post_code1.
         lw_entity-wecountry = lw_vbpa-country.
       ENDIF.
       APPEND lw_entity TO et_entityset.
       CLEAR: lw_entity, lw_vbak.

     ENDLOOP.

   ENDIF.

 ENDMETHOD.


 METHOD incompitemset_get_entityset.


   DATA:lv_vbeln(10) TYPE c,
        lr_vbeln     TYPE tms_t_vbeln_range,
        lr_vbeln2    TYPE tms_t_vbeln_range,
        lst_vbeln    TYPE tms_s_vbeln_range,
        lv_flag(1)   TYPE c,
        lw_entity    TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompitem,
        lv_label     TYPE  string.


   FIELD-SYMBOLS:
     <ls_filter>     LIKE LINE OF it_filter_select_options,
     <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

   LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
     LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
       CASE <ls_filter>-property.
         WHEN 'VBELN'.
*           lv_vbeln = <ls_filter_opt>-low.
           lv_vbeln = <ls_filter_opt>-low+0(10).
           IF lv_vbeln NE 'null' AND lv_vbeln IS NOT INITIAL.
             lst_vbeln-sign = 'I'.
             lst_vbeln-option = 'EQ'.
             lst_vbeln-low = lv_vbeln.
             APPEND lst_vbeln TO lr_vbeln.
             CLEAR:lst_vbeln.
           ENDIF.
*         WHEN 'FLAG'.
*           lv_flag = <ls_filter_opt>-low.
       ENDCASE.
     ENDLOOP.
   ENDLOOP.

   IF lr_vbeln IS NOT INITIAL.

*     IF lv_flag EQ 'X'.  "A
     SELECT vu~etenr,vu~tdid,vu~parvw,vu~tbnam,vu~fdnam,vu~fehgr,vu~statg,
            v~vbeln,v~posnr, v~matnr,v~abgru, v~zmeng, v~zzsubtyp,v~mvgr5,
            v~zzvyp, v~mwsbp,v~netwr, v~erdat, v~ernam,v~waerk,
            vb~fkdat, vb~kdkg2, vb~konda, vb~zterm, vb~zlsch,
            ve~vposn, ve~vkuesch,ve~vkuegru, ve~vbedkue, ve~vbegdat, ve~venddat
            INTO TABLE @DATA(lt_vbuv) FROM vbuv AS vu
            INNER JOIN vbap AS v ON v~vbeln = vu~vbeln
            INNER JOIN vbkd AS vb ON  vb~vbeln = v~vbeln "AND vb~posnr = v~posnr
            INNER JOIN veda AS ve ON  ve~vbeln = v~vbeln "AND ve~vposn = v~posnr
            WHERE  v~vbeln IN @lr_vbeln.
*     ENDIF.   "A

     IF sy-subrc = 0.
       SORT lt_vbuv BY vbeln posnr.
     ENDIF.

*     LOOP AT lt_vbuv INTO DATA(lw_vbuv).
*       MOVE-CORRESPONDING lw_vbuv TO lw_entity.
*
*       CALL FUNCTION 'DDIF_FIELDLABEL_GET'
*         EXPORTING
*           tabname        = lw_vbuv-tbnam
*           fieldname      = lw_vbuv-fdnam
*           langu          = sy-langu
*         IMPORTING
*           label          = lv_label
*         EXCEPTIONS
*           not_found      = 1
*           internal_error = 2
*           OTHERS         = 3.
*
*       lw_entity-missing = lv_label .
*       APPEND lw_entity TO et_entityset.
*       CLEAR lw_entity.
*     ENDLOOP.
   ENDIF.
 ENDMETHOD.


method INCOMPLETEORDERS_GET_ENTITYSET.

FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_auart  TYPE  c LENGTH 4,
          lv_vkorg  TYPE  c LENGTH 4,
          lv_zterm  TYPE  c LENGTH 4,
          lv_bsark  TYPE  c LENGTH 4,
          lv_konda  TYPE  c LENGTH 4,
          lv_matnr  TYPE  c LENGTH 4,
          lv_mvgr5  TYPE  c LENGTH 3,
          lv_vbeln  TYPE  c LENGTH 10,
          lv_smodel TYPE  c LENGTH 20,
          lv_pstat  TYPE  c LENGTH 10,
          lv_kunnr  TYPE  c LENGTH 10,
          lv_kunwe  TYPE  c LENGTH 10,
          lv_erdat  TYPE  c LENGTH 10,
          lv_erdat2 TYPE  sy-datum,
          lv_fkdat  TYPE  c LENGTH 10,
          lw_sum    TYPE dmbtr,
          lw_netwr  TYPE c LENGTH 20,
          lw_entity TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompleteorders.

    TYPES:BEGIN OF lt_vk,
            vbeln TYPE c LENGTH 10,
            waerk TYPE waerk,
            netwr TYPE netwr,
            model TYPE char20,
            count TYPE i,
          END OF lt_vk.

    DATA: li_tab  TYPE STANDARD TABLE OF lt_vk,
          li_tab1 TYPE STANDARD TABLE OF lt_vk,
          lst_tab TYPE lt_vk,
          w_tab1  TYPE lt_vk,
          lw_count type i.


    DATA: li_vkorg TYPE /iwbep/t_cod_select_options,
          li_vkbur TYPE /iwbep/t_cod_select_options,
          li_vkburc TYPE /iwbep/t_cod_select_options,
          li_vkburt TYPE /iwbep/t_cod_select_options,
          li_vkburs TYPE /iwbep/t_cod_select_options,
          li_konda TYPE /iwbep/t_cod_select_options,
          li_kondas TYPE /iwbep/t_cod_select_options,
          li_mvgr5 TYPE /iwbep/t_cod_select_options,
          li_mvgr5s TYPE /iwbep/t_cod_select_options,
          li_kdkg2 TYPE /iwbep/t_cod_select_options.

    DATA: lst_auart TYPE tds_rg_auart,
          lir_auart TYPE STANDARD TABLE OF tds_rg_auart,
          lst_smodel TYPE /iwbep/s_cod_select_option,
          lir_smodel TYPE /iwbep/t_cod_select_options.


    Data: lir_vkbur TYPE /iwbep/t_cod_select_options,
          lir_konda TYPE /iwbep/t_cod_select_options,
          lir_mvgr5 TYPE /iwbep/t_cod_select_options,
          lir_kdkg2 TYPE /iwbep/t_cod_select_options.


    CONSTANTS: lc_devid TYPE c LENGTH 10 VALUE 'INCOMP'.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'SMODEL'.
            lv_smodel = <ls_filter_opt>-low.
            lst_smodel-sign = <ls_filter_opt>-sign.
            lst_smodel-option = <ls_filter_opt>-option.
            lst_smodel-low = <ls_filter_opt>-low.
            lst_smodel-high = <ls_filter_opt>-high.
*            lv_smodel = <ls_filter_opt>-low.
            Append lst_smodel to lir_smodel.
          WHEN 'AUART'.
*             lv_auart = <ls_filter_opt>-low.
            lst_auart-sign = <ls_filter_opt>-sign.
            lst_auart-option = <ls_filter_opt>-option.
            lst_auart-low = <ls_filter_opt>-low.
            lst_auart-high = <ls_filter_opt>-high.
            APPEND lst_auart TO lir_auart.
          WHEN 'VKORG'.
            lv_vkorg = <ls_filter_opt>-low.

          WHEN 'PSTAT'.
            lv_pstat = <ls_filter_opt>-low.

          WHEN 'ZTERM'.
            lv_zterm = <ls_filter_opt>-low.

          WHEN 'BSARK'.
            lv_bsark = <ls_filter_opt>-low.

          WHEN 'KONDA'.
            lv_konda = <ls_filter_opt>-low.

          WHEN 'KUNNR'.
            lv_kunnr = <ls_filter_opt>-low+0(10).

          WHEN 'KUNWE'.
            lv_kunwe = <ls_filter_opt>-low+0(10).

          WHEN 'MATNR'.
            lv_matnr = <ls_filter_opt>-low+0(18).

          WHEN 'MVGR5'.
            lv_mvgr5 = <ls_filter_opt>-low.

          WHEN 'VBELN'.
            lv_vbeln = <ls_filter_opt>-low+0(10).

          WHEN 'ERDAT'.
            lv_erdat = <ls_filter_opt>-low+0(10).

          WHEN 'FKDAT'.
            lv_fkdat = <ls_filter_opt>-low+0(10).

        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
       WHERE devid = @lc_devid.

   LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lst_const>).
     if lv_smodel is initial.
      Case <lst_const>-param2.
        WHEN 'AM'.
          if <lst_const>-param1 = 'VKBUR'.
          Append initial line to li_vkbur assigning FIELD-SYMBOL(<lst_vkbur>).
           <lst_vkbur>-sign = <lst_const>-sign.
           <lst_vkbur>-option = <lst_const>-opti.
           <lst_vkbur>-low =  <lst_const>-low.
           <lst_vkbur>-high = <lst_const>-high.
           endif.
         WHEN 'CSS'.
           if <lst_const>-param1 = 'VKBUR'.
           Append initial line to li_vkburc assigning <lst_vkbur>.
           <lst_vkbur>-sign = <lst_const>-sign.
           <lst_vkbur>-option = <lst_const>-opti.
           <lst_vkbur>-low =  <lst_const>-low.
           <lst_vkbur>-high = <lst_const>-high.
           endif.
         WHEN 'TBT'.
           if <lst_const>-param1 = 'VKBUR'.
           Append initial line to li_vkburt assigning <lst_vkbur>.
           <lst_vkbur>-sign = <lst_const>-sign.
           <lst_vkbur>-option = <lst_const>-opti.
           <lst_vkbur>-low =  <lst_const>-low.
           <lst_vkbur>-high = <lst_const>-high.
           elseif <lst_const>-param1 = 'KONDA'.
           Append initial line to li_konda assigning FIELD-SYMBOL(<lst_konda>).
           <lst_konda>-sign = <lst_const>-sign.
           <lst_konda>-option = <lst_const>-opti.
           <lst_konda>-low =  <lst_const>-low.
           <lst_konda>-high = <lst_const>-high.
           elseif <lst_const>-param1 = 'MVGR5'.
            Append initial line to li_mvgr5 assigning FIELD-SYMBOL(<lst_mvgr5>) .
           <lst_mvgr5>-sign = <lst_const>-sign.
           <lst_mvgr5>-option = <lst_const>-opti.
           <lst_mvgr5>-low =  <lst_const>-low.
           <lst_mvgr5>-high = <lst_const>-high.
           endif.
         WHEN 'SOC'.
           if <lst_const>-param1 = 'VKBUR'.
           Append initial line to li_vkburs assigning <lst_vkbur>.
           <lst_vkbur>-sign = <lst_const>-sign.
           <lst_vkbur>-option = <lst_const>-opti.
           <lst_vkbur>-low =  <lst_const>-low.
           <lst_vkbur>-high = <lst_const>-high.
           elseif <lst_const>-param1 = 'KONDA'.
           Append initial line to li_kondas assigning <lst_konda>.
           <lst_konda>-sign = <lst_const>-sign.
           <lst_konda>-option = <lst_const>-opti.
           <lst_konda>-low =  <lst_const>-low.
           <lst_konda>-high = <lst_const>-high.
           elseif <lst_const>-param1 = 'MVGR5'.
           Append initial line to li_mvgr5s assigning <lst_mvgr5>.
           <lst_mvgr5>-sign = <lst_const>-sign.
           <lst_mvgr5>-option = <lst_const>-opti.
           <lst_mvgr5>-low =  <lst_const>-low.
           <lst_mvgr5>-high = <lst_const>-high.
           elseif <lst_const>-param1 = 'KDKG2'.
           Append initial line to li_kdkg2 assigning FIELD-SYMBOL(<lst_kdkg2>).
           <lst_kdkg2>-sign = <lst_const>-sign.
           <lst_kdkg2>-option = <lst_const>-opti.
           <lst_kdkg2>-low =  <lst_const>-low.
           <lst_kdkg2>-high = <lst_const>-high.
           endif.
           endcase.
           endif.

           IF lv_vkorg IS INITIAL AND <lst_const>-param1 = 'VKORG' .
        APPEND INITIAL LINE TO li_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
        <lst_vkorg_i>-sign   = <lst_const>-sign.
        <lst_vkorg_i>-option = <lst_const>-opti.
        <lst_vkorg_i>-low    = <lst_const>-low.
        <lst_vkorg_i>-high   = <lst_const>-high.
      ENDIF.
    ENDLOOP.

      if lv_smodel is not initial.
      Loop at lir_smodel into DATA(lw_smodel).
        if lw_smodel-low = 'AM'.
          lir_vkbur = li_vkbur.
        elseif lw_smodel-low eq 'CSS'.
           lir_vkbur = li_vkburc.
        elseif lw_smodel-low eq 'TBT'.
           lir_vkbur = li_vkburt.
           lir_konda = li_konda.
           lir_mvgr5 = li_mvgr5.
        elseif lw_smodel-low eq 'SOC'.
           lir_vkbur = li_vkburs.
           lir_konda = li_kondas.
           lir_mvgr5 = li_mvgr5s.
           lir_kdkg2 = li_kdkg2.
        endif.
      endloop.
      endif.
    lv_erdat2 = sy-datum - 30.
    SELECT v~vbeln, v~vkorg, v~vkbur, v~auart, v~bstnk, v~kunnr, v~augru,
           v~bsark, v~faksk, v~lifsk, v~erdat, v~ernam,  v~vbtyp,
           vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid,
           p~netwr, p~waerk, p~mvgr5, p~zzvyp, p~zmeng, p~mwsbp, p~zzsubtyp,
           d~konda, d~kdkg2, d~zlsch, d~zterm
       INTO TABLE @DATA(lt_vbak)
       FROM vbak AS v INNER JOIN vbuv AS vb
       ON  v~vbeln = vb~vbeln
       INNER JOIN vbap AS p ON
       p~vbeln = v~vbeln
       INNER JOIN vbkd AS d ON
       d~vbeln = v~vbeln
       WHERE v~vkorg IN @li_vkorg and v~auart IN @lir_auart
          AND  ( v~vkbur in @lir_vkbur
         or  p~mvgr5 in @lir_mvgr5
         or  d~konda in @lir_konda
         or d~kdkg2 in @lir_kdkg2 )
         AND  ( v~erdat LE @sy-datum AND v~erdat GE @lv_erdat2 ).

    IF sy-subrc = 0.
      DELETE lt_vbak WHERE waerk IS INITIAL.
      SORT lt_vbak BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln posnr.
    ENDIF.

    lw_count = 0.
    LOOP AT lt_vbak INTO DATA(lw_vbak).
      CLEAR lst_tab.
      IF lw_vbak-vkbur in li_vkbur.
        lst_tab-model = 'AM'.

      ELSEIF lw_vbak-vkbur in li_vkburc.
        lst_tab-model = 'CSS'.

      ELSEIF lw_vbak-vkbur in li_vkburt.
        IF ( lw_vbak-konda in li_konda )
        AND ( lw_vbak-mvgr5 in li_mvgr5 ).
          lst_tab-model = 'TBT'.

        ELSEIF  lw_vbak-konda in li_kondas
        AND ( lw_vbak-mvgr5 in li_mvgr5s )
          AND ( lw_vbak-kdkg2 in li_kdkg2 ).
          lst_tab-model = 'SOC'.

        ELSE.
        lst_tab-model = 'OTHERS'.

        ENDIF.


      ELSE.
        lst_tab-model = 'OTHERS'.

      ENDIF.
      at end of vbeln.
      lst_tab-count = 1.
      endat.
      lst_tab-netwr = lw_vbak-netwr.
      lst_tab-waerk = lw_vbak-waerk.
      COLLECT lst_tab INTO li_tab.
    ENDLOOP.





      LOOP AT li_tab INTO lst_tab.

      lw_entity-waerk = lst_tab-waerk.
      lw_entity-netwr = lst_tab-netwr.
      lw_entity-model = lst_tab-model.
      lw_entity-count = lst_tab-count.

      APPEND lw_entity TO et_entityset.
      CLEAR :lw_entity,lst_tab.

    ENDLOOP.




endmethod.


  METHOD incomplogset_get_entityset.

    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_vbeln   TYPE c LENGTH 10,
          lv_smodel  TYPE c LENGTH 20,
          lv_waerk   TYPE c LENGTH 5,
          lv_erdat2  TYPE sy-datum,
          lst_smodel TYPE /iwbep/s_cod_select_option,
          lir_smodel TYPE /iwbep/t_cod_select_options,
          lst_waerk  TYPE  /iwbep/s_cod_select_option,
          lir_waerk  TYPE /iwbep/t_cod_select_options,
          lst_vbeln  TYPE range_vbeln,
          lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
          lw_entity  TYPE zcl_zqtco_incomplete_o_mpc=>ts_incomplog.

    CONSTANTS: lc_devid TYPE c LENGTH 12 VALUE 'R144'.


    DATA: lr_vkbur TYPE /iwbep/t_cod_select_options,
          lr_konda TYPE /iwbep/t_cod_select_options,
          lr_mvgr5 TYPE /iwbep/t_cod_select_options,
          lr_kdkg2 TYPE /iwbep/t_cod_select_options,
          li_vkorg TYPE /iwbep/t_cod_select_options.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
        CASE <ls_filter>-property.
          WHEN 'SMODEL'.
            lv_smodel = <ls_filter_opt>-low.
            IF lv_smodel NE 'OTHERS'.
              lst_smodel-sign = <ls_filter_opt>-sign.
              lst_smodel-option = <ls_filter_opt>-option.
              lst_smodel-low = lv_smodel.
              lst_smodel-high = <ls_filter_opt>-high.
              APPEND lst_smodel TO lir_smodel.
            ENDIF.
          WHEN 'WAERK'.
            lv_waerk = <ls_filter_opt>-low.
            lst_waerk-sign = <ls_filter_opt>-sign.
            lst_waerk-option = <ls_filter_opt>-option.
            lst_waerk-low = <ls_filter_opt>-low.
            lst_waerk-high = <ls_filter_opt>-high.
            APPEND lst_waerk TO lir_waerk.
          WHEN 'VBELN'.
            lst_vbeln-sign = <ls_filter_opt>-sign.
            lst_vbeln-option = <ls_filter_opt>-option.
            lst_vbeln-low = <ls_filter_opt>-low.
            lst_vbeln-high = <ls_filter_opt>-high.
            APPEND lst_vbeln TO lir_vbeln.
          WHEN OTHERS.
            "Do nothing.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.



    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
         WHERE devid = @lc_devid.

    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
      IF <lw_const>-param2 = lv_smodel.
        IF <lw_const>-param1 = 'VKBUR'.
          APPEND INITIAL LINE TO lr_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
          <lst_vkbur_i>-sign   = <lw_const>-sign.
          <lst_vkbur_i>-option = <lw_const>-opti.
          <lst_vkbur_i>-low    = <lw_const>-low.
          <lst_vkbur_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KONDA'.
          APPEND INITIAL LINE TO lr_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
          <lst_konda_i>-sign   = <lw_const>-sign.
          <lst_konda_i>-option = <lw_const>-opti.
          <lst_konda_i>-low    = <lw_const>-low.
          <lst_konda_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'MVGR5'.
          APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
          <lst_mvgr5_i>-sign   = <lw_const>-sign.
          <lst_mvgr5_i>-option = <lw_const>-opti.
          <lst_mvgr5_i>-low    = <lw_const>-low.
          <lst_mvgr5_i>-high   = <lw_const>-high.
        ENDIF.

        IF <lw_const>-param1 = 'KDKG2'.
          APPEND INITIAL LINE TO lr_kdkg2 ASSIGNING FIELD-SYMBOL(<lst_kdkg2_i>).
          <lst_kdkg2_i>-sign   = <lw_const>-sign.
          <lst_kdkg2_i>-option = <lw_const>-opti.
          <lst_kdkg2_i>-low    = <lw_const>-low.
          <lst_kdkg2_i>-high   = <lw_const>-high.
        ENDIF.
      ENDIF.

      IF  <lw_const>-param1 = 'VKORG' . "lv_vkorg IS INITIAL AND
        APPEND INITIAL LINE TO li_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
        <lst_vkorg_i>-sign   = <lw_const>-sign.
        <lst_vkorg_i>-option = <lw_const>-opti.
        <lst_vkorg_i>-low    = <lw_const>-low.
        <lst_vkorg_i>-high   = <lw_const>-high.
      ENDIF.
    ENDLOOP.

*
*    if lir_vbeln is not initial.
    lv_erdat2 = sy-datum - 300.
    SELECT v~vbeln, v~vkorg, v~vkbur, v~auart,v~erdat,
        vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid
        ,vp~netwr, vp~waerk, vp~mvgr5
        ,vk~kdkg2, vk~konda
       INTO TABLE @DATA(lt_vbak)
       FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
       INNER JOIN vbap AS vp ON  vp~vbeln = vb~vbeln AND vp~posnr = vb~posnr
       INNER JOIN vbkd AS vk ON  vk~vbeln = vb~vbeln AND vk~posnr = vb~posnr
       WHERE vb~vbeln IN @lir_vbeln AND v~vkorg IN @li_vkorg AND vp~waerk IN @lir_waerk
         AND  v~vkbur IN @lr_vkbur "OR v~vkorg IN @lir_vkorg
          AND  vp~mvgr5 IN @lr_mvgr5 AND vk~kdkg2 IN @lr_kdkg2 AND vk~konda IN @lr_konda
       AND ( v~erdat GE @lv_erdat2 AND v~erdat LE @sy-datum  ).

    IF sy-subrc EQ 0.
      SORT lt_vbak BY tbnam fdnam.
      DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING tbnam fdnam.
      LOOP AT lt_vbak INTO DATA(lw_vbak).
*        lw_entity-vbeln = lw_vbak-vbeln.
        lw_entity-smodel = lv_smodel.
        lw_entity-waerk = lv_waerk.
        lw_entity-fdnam = lw_vbak-fdnam.
        lw_entity-tbnam = lw_vbak-tbnam.
        APPEND lw_entity TO et_entityset.
        CLEAR: lw_entity.
      ENDLOOP.

    ENDIF.
*endif.
  ENDMETHOD.


  method IORDERSET_GET_ENTITYSET.

    Select DISTINCT vbeln from vbuv into table et_entityset.

  endmethod.


  METHOD materialgroup5se_get_entityset.

    DATA: lt_mat TYPE zcl_zqtco_incomplete_o_mpc=>tt_materialgroup5,
          lw_mat TYPE zcl_zqtco_incomplete_o_mpc=>ts_materialgroup5.

    SELECT mvgr5 bezei
     FROM tvm5t
     INTO CORRESPONDING FIELDS OF TABLE lt_mat
     WHERE spras = sy-langu.

    IF sy-subrc EQ 0.

      LOOP AT lt_mat INTO lw_mat.
        APPEND lw_mat TO et_entityset.
        CLEAR lw_mat.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD materialset_get_entityset.

    DATA: lt_orders TYPE zcl_zqtco_incomplete_o_mpc=>tt_material,
          lw_orders TYPE zcl_zqtco_incomplete_o_mpc=>ts_material.

    SELECT matnr maktx FROM makt
        INTO CORRESPONDING FIELDS OF TABLE lt_orders UP TO 100 rows
           WHERE  spras = sy-langu .

    SORT lt_orders[] BY matnr.
    LOOP AT  lt_orders INTO lw_orders.
      APPEND lw_orders TO et_entityset.
      CLEAR:lw_orders.
    ENDLOOP.

  ENDMETHOD.


  METHOD ordertypeset_get_entityset.

    DATA: it_orders TYPE zcl_zqtco_incomplete_o_mpc=>tt_ordertype,
          wa_orders TYPE zcl_zqtco_incomplete_o_mpc=>ts_ordertype.

*---get the order type
    SELECT auart bezei FROM tvakt
    INTO CORRESPONDING FIELDS OF TABLE it_orders
       WHERE  spras = sy-langu
         AND auart LIKE 'Z%'.

    SORT it_orders[] BY auart bezei.
    LOOP AT  it_orders INTO wa_orders.
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.

  ENDMETHOD.


  method PAYMENTTERMSET_GET_ENTITYSET.

    Select zterm text1 from T052U into table et_entityset where spras = sy-langu.

  endmethod.


  method POTYPESET_GET_ENTITYSET.

Select bsark vtext from t176t into table et_entityset where spras = sy-langu.

  endmethod.


  method PRICEGROUPSET_GET_ENTITYSET.
    Select konda vtext from t188t into table et_entityset where spras eq sy-langu.
  endmethod.


  METHOD salesgroupset_get_entityset.

    DATA: it_orders TYPE zcl_zqtco_incomplete_o_mpc=>tt_salesgroup,
          wa_orders TYPE zcl_zqtco_incomplete_o_mpc=>ts_salesgroup.

    SELECT vkgrp bezei FROM tvgrt
        INTO CORRESPONDING FIELDS OF TABLE it_orders
           WHERE  spras = sy-langu.

    SORT it_orders[] BY vkgrp.
    LOOP AT  it_orders INTO wa_orders.
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.

  ENDMETHOD.


  method SALESORGSET_GET_ENTITYSET.

    DATA: it_orders TYPE zcl_zqtco_incomplete_o_mpc=>tt_salesorg,
          wa_orders TYPE zcl_zqtco_incomplete_o_mpc=>ts_salesorg.

    SELECT vkorg vtext FROM TVKOt
    INTO CORRESPONDING FIELDS OF TABLE it_orders
       WHERE  spras = sy-langu.

    SORT it_orders[] BY vkorg vtext.
    LOOP AT  it_orders INTO wa_orders.
      APPEND wa_orders TO et_entityset.
      CLEAR:wa_orders.
    ENDLOOP.

  endmethod.


  METHOD smodelset_get_entityset.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'INCOMP' .
    CONSTANTS: lc_smodel TYPE zdevid VALUE 'SALESMODEL' .
*
    DATA:lst_smodel TYPE zcl_zqtco_incomplete_o_mpc=>ts_smodel.
*----get constant entries

    SELECT  * FROM zcaconstant
      INTO TABLE @DATA(lt_constants)
      WHERE devid = @lc_devid
        AND param1 = @lc_smodel.
    CLEAR:lst_smodel.
    IF sy-subrc EQ 0.
      LOOP AT lt_constants INTO DATA(lst_constants).

        lst_smodel-model = lst_constants-low .
        lst_smodel-mdescr = lst_constants-high.

        APPEND lst_smodel TO et_entityset.
        CLEAR lst_smodel.
      ENDLOOP.
    ENDIF.
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


  METHOD zcaconstset_get_entityset.
*    FIELD-SYMBOLS:
*      <ls_filter>     LIKE LINE OF it_filter_select_options,
*      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
*
*    DATA: lv_auart  TYPE  c LENGTH 4,
*          lv_vkorg  TYPE  c LENGTH 4,
*          lv_zterm  TYPE  c LENGTH 4,
*          lv_bsark  TYPE  c LENGTH 4,
*          lv_konda  TYPE  c LENGTH 4,
*          lv_matnr  TYPE  c LENGTH 4,
*          lv_mvgr5  TYPE  c LENGTH 3,
*          lv_vbeln  TYPE  c LENGTH 10,
*          lv_smodel TYPE  c LENGTH 20,
*          lv_pstat  TYPE  c LENGTH 10,
*          lv_kunnr  TYPE  c LENGTH 10,
*          lv_kunwe  TYPE  c LENGTH 10,
*          lv_erdat  TYPE  c LENGTH 10,
*          lv_erdat2 TYPE  sy-datum,
*          lv_fkdat  TYPE  c LENGTH 10,
*          lw_sum    TYPE dmbtr,
*          lw_netwr  TYPE c LENGTH 20,
*          lw_entity TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompdashboard.
*
*    TYPES:BEGIN OF lt_vk,
*            vbeln TYPE c LENGTH 10,
*            waerk TYPE waerk,
*            netwr TYPE netwr,
*            model TYPE char20,
*            count TYPE i,
*          END OF lt_vk.
*
*    DATA: li_tab  TYPE STANDARD TABLE OF lt_vk,
*          li_tab1 TYPE STANDARD TABLE OF lt_vk,
*          lst_tab TYPE lt_vk,
*          w_tab1  TYPE lt_vk.
*
*    DATA: lw_sum1  TYPE dmbtr,
*          lw_sum2  TYPE dmbtr,
*          lw_sum3  TYPE dmbtr,
*          lw_sum4  TYPE dmbtr,
*          lw_sum5  TYPE dmbtr,
*          lw_sum6  TYPE dmbtr,
*          lw_count TYPE i VALUE 0.
*
*    DATA: li_vkbur TYPE /iwbep/t_cod_select_options,
*          li_konda TYPE /iwbep/t_cod_select_options,
*          li_mvgr5 TYPE /iwbep/t_cod_select_options,
*          li_kdkg2 TYPE /iwbep/t_cod_select_options,
*          li_vkorg TYPE /iwbep/t_cod_select_options.
*
*    DATA: lst_auart TYPE tds_rg_auart,
*          lir_auart TYPE STANDARD TABLE OF tds_rg_auart.
*
*
*    CONSTANTS: lc_devid TYPE c LENGTH 10 VALUE 'INCOMP'.
*
*    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
*      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
*        CASE <ls_filter>-property.
*          WHEN 'SMODEL'.
*            lv_smodel = <ls_filter_opt>-low.
*          WHEN 'AUART'.
**             lv_auart = <ls_filter_opt>-low.
*            lst_auart-sign = <ls_filter_opt>-sign.
*            lst_auart-option = <ls_filter_opt>-option.
*            lst_auart-low = <ls_filter_opt>-low.
*            lst_auart-high = <ls_filter_opt>-high.
*            APPEND lst_auart TO lir_auart.
*          WHEN 'VKORG'.
*            lv_vkorg = <ls_filter_opt>-low.
*
*          WHEN 'PSTAT'.
*            lv_pstat = <ls_filter_opt>-low.
*
*          WHEN 'ZTERM'.
*            lv_zterm = <ls_filter_opt>-low.
*
*          WHEN 'BSARK'.
*            lv_bsark = <ls_filter_opt>-low.
*
*          WHEN 'KONDA'.
*            lv_konda = <ls_filter_opt>-low.
*
*          WHEN 'KUNNR'.
*            lv_kunnr = <ls_filter_opt>-low+0(10).
*
*          WHEN 'KUNWE'.
*            lv_kunwe = <ls_filter_opt>-low+0(10).
*
*          WHEN 'MATNR'.
*            lv_matnr = <ls_filter_opt>-low+0(18).
*
*          WHEN 'MVGR5'.
*            lv_mvgr5 = <ls_filter_opt>-low.
*
*          WHEN 'VBELN'.
*            lv_vbeln = <ls_filter_opt>-low+0(10).
*
*          WHEN 'ERDAT'.
*            lv_erdat = <ls_filter_opt>-low+0(10).
*
*          WHEN 'FKDAT'.
*            lv_fkdat = <ls_filter_opt>-low+0(10).
*
*        ENDCASE.
*      ENDLOOP.
*    ENDLOOP.
*
*    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
*       WHERE devid = @lc_devid.
*
*    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
*      IF <lw_const>-param2 = lv_smodel.
*        IF <lw_const>-param1 = 'VKBUR'.
*          APPEND INITIAL LINE TO li_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
*          <lst_vkbur_i>-sign   = <lw_const>-sign.
*          <lst_vkbur_i>-option = <lw_const>-opti.
*          <lst_vkbur_i>-low    = <lw_const>-low.
*          <lst_vkbur_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'KONDA'.
*          APPEND INITIAL LINE TO li_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
*          <lst_konda_i>-sign   = <lw_const>-sign.
*          <lst_konda_i>-option = <lw_const>-opti.
*          <lst_konda_i>-low    = <lw_const>-low.
*          <lst_konda_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'MVGR5'.
*          APPEND INITIAL LINE TO li_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
*          <lst_mvgr5_i>-sign   = <lw_const>-sign.
*          <lst_mvgr5_i>-option = <lw_const>-opti.
*          <lst_mvgr5_i>-low    = <lw_const>-low.
*          <lst_mvgr5_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'KDKG2'.
*          APPEND INITIAL LINE TO li_kdkg2 ASSIGNING FIELD-SYMBOL(<lst_kdkg2_i>).
*          <lst_kdkg2_i>-sign   = <lw_const>-sign.
*          <lst_kdkg2_i>-option = <lw_const>-opti.
*          <lst_kdkg2_i>-low    = <lw_const>-low.
*          <lst_kdkg2_i>-high   = <lw_const>-high.
*        ENDIF.
*      ENDIF.
*
*      IF lv_vkorg IS INITIAL AND <lw_const>-param1 = 'VKORG' .
*        APPEND INITIAL LINE TO li_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
*        <lst_vkorg_i>-sign   = <lw_const>-sign.
*        <lst_vkorg_i>-option = <lw_const>-opti.
*        <lst_vkorg_i>-low    = <lw_const>-low.
*        <lst_vkorg_i>-high   = <lw_const>-high.
*      ENDIF.
*    ENDLOOP.
*
*    lv_erdat2 = sy-datum - 300.
*    SELECT v~vbeln, v~vkorg, v~vkbur, v~auart,v~erdat,
*        vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid,
*         p~netwr, p~waerk, p~mvgr5, d~konda, d~kdkg2
*       INTO TABLE @DATA(lt_vbak)
*       FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
*       INNER JOIN vbap AS p ON p~vbeln = v~vbeln and p~posnr = vb~posnr
*       INNER JOIN vbkd AS d ON d~vbeln = v~vbeln "and d~posnr = vb~posnr
*       WHERE v~vkorg IN @li_vkorg AND v~vkbur IN @li_vkbur AND v~auart IN @lir_auart
*         AND  ( v~erdat LE @sy-datum AND v~erdat GE @lv_erdat2 ).
*
*    IF sy-subrc = 0.
*      DELETE lt_vbak WHERE waerk IS INITIAL.
*      SORT lt_vbak BY vbeln posnr.
*      DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln posnr.
*    ENDIF.
*
*    lw_count = 0.
*    LOOP AT lt_vbak INTO DATA(lw_vbak).
*      CLEAR lst_tab.
*      IF lw_vbak-vkbur = '0050'.
*        lst_tab-model = 'AM'.
*
*      ELSEIF lw_vbak-vkbur = '0030'.
*        lst_tab-model = 'CSS'.
*
*      ELSEIF lw_vbak-vkbur = '0080'.
*        IF ( lw_vbak-konda EQ '02' OR lw_vbak-konda EQ '03' OR lw_vbak-konda EQ '04' )
*        AND ( lw_vbak-mvgr5 EQ 'WP' OR lw_vbak-mvgr5 EQ 'MA' OR lw_vbak-mvgr5 EQ 'DI' OR
*              lw_vbak-mvgr5 EQ 'SO').
*          lst_tab-model = 'TBT'.
*
*        ELSEIF  lw_vbak-konda EQ '02'
*        AND ( lw_vbak-mvgr5 EQ 'OF' OR lw_vbak-mvgr5 EQ 'MA' OR lw_vbak-mvgr5 EQ 'DI' OR
*              lw_vbak-mvgr5 EQ 'SO' OR lw_vbak-mvgr5 EQ 'IN')
*        AND ( lw_vbak-kdkg2 EQ '02' ).
*          lst_tab-model = 'SOC'.
*        ELSE.
*          lst_tab-model = 'OTHERS'.
*        ENDIF.
*
*      ELSE.
*        lst_tab-model = 'OTHERS'.
*
*      ENDIF.
*      at end of vbeln.
*      lst_tab-count = 1.
*      endat.
*      lst_tab-netwr = lw_vbak-netwr.
*      lst_tab-waerk = lw_vbak-waerk.
*      COLLECT lst_tab INTO li_tab.
*
*    ENDLOOP.
*
*
*
*    LOOP AT li_tab INTO lst_tab.
*
*      lw_entity-waerk = lst_tab-waerk.
*      lw_entity-netwr = lst_tab-netwr.
*      lw_entity-model = lst_tab-model.
*      lw_entity-count = lst_tab-count.
*
*      APPEND lw_entity TO et_entityset.
*      CLEAR :lw_entity,lst_tab.
*
*    ENDLOOP.
*********************************************************************
*********************************************************************

* DATA: lv_input         TYPE string,
*          lt_filter_string TYPE TABLE OF string,
*          lt_sptint        TYPE TABLE OF string,
*          lt_key_value     TYPE /iwbep/t_mgw_name_value_pair,
*          lv_name          TYPE string,
*          lv_opt           TYPE string,
*          lv_value         TYPE string,
*          lv_sprint        TYPE string,
*          lv_sdate         TYPE c LENGTH 10,
*          lv_bdate         TYPE c LENGTH 10,
*          lv_erdat2        TYPE  sy-datum.
*
*    DATA: lst_auart  TYPE tds_rg_auart,
*          lir_auart  TYPE STANDARD TABLE OF tds_rg_auart,
*          lst_vkorg  TYPE range_vkorg,
*          lir_vkorg  TYPE STANDARD TABLE OF range_vkorg,
*          lst_bsark  TYPE tds_rg_bsark,
*          lir_bsark  TYPE STANDARD TABLE OF tds_rg_bsark,
*          lst_kunnr  TYPE kun_range,
*          lir_kunnr  TYPE STANDARD TABLE OF kun_range,
*          lst_kunwe  TYPE kun_range,
*          lir_kunwe  TYPE STANDARD TABLE OF kun_range,
*          lst_matnr  TYPE mat_range,
*          lir_matnr  TYPE STANDARD TABLE OF mat_range,
*          lst_vbeln  TYPE range_vbeln,
*          lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
*          lst_erdat  TYPE tds_rg_erdat,
*          lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
*          lst_fkdat  TYPE range_fkdat,
*          lir_fkdat  TYPE STANDARD TABLE OF range_fkdat,
*          lst_smodel TYPE /iwbep/s_cod_select_option,
*          lir_smodel TYPE /iwbep/t_cod_select_options,
*          lst_pstat  TYPE /iwbep/s_cod_select_option,
*          lir_pstat  TYPE /iwbep/t_cod_select_options,
*          lst_zterm  TYPE /iwbep/s_cod_select_option,
*          lir_zterm  TYPE /iwbep/t_cod_select_options,
*          lst_konda  TYPE /iwbep/s_cod_select_option,
*          lir_konda  TYPE /iwbep/t_cod_select_options,
*          lst_mvgr5  TYPE /iwbep/s_cod_select_option,
*          lir_mvgr5  TYPE /iwbep/t_cod_select_options.
*
*
*    CONSTANTS: lc_eq    TYPE char2 VALUE 'EQ',
*               lc_ge    TYPE char2 VALUE 'GE',
*               lc_le    TYPE char2 VALUE 'LE',
*               lc_bt    TYPE char2 VALUE 'BT',
*               lc_i     TYPE char1 VALUE 'I',
*               lc_devid TYPE c LENGTH 10 VALUE 'E266'.
*
*    DATA: li_vkbur TYPE /iwbep/t_cod_select_options,
*          li_konda TYPE /iwbep/t_cod_select_options,
*          li_mvgr5 TYPE /iwbep/t_cod_select_options,
*          li_kdkg2 TYPE /iwbep/t_cod_select_options.
*
*    TYPES: BEGIN OF ty_out,
*             vbeln TYPE c LENGTH 10,
*             waerk TYPE waerk,
*             netwr TYPE netwr,
*             count TYPE i,
*           END OF ty_out.
*
*    DATA: li_tab    TYPE STANDARD TABLE OF ty_out,
*          lst_tab   TYPE ty_out,
*          lw_entity TYPE zcl_zqtco_incomplete_o_mpc=>ts_incompleteorders.
*
*
*    IF iv_filter_string IS NOT INITIAL.
*      lv_input = iv_filter_string.
** *— get rid of )( & ‘ and make AND’s uppercase
*      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
*      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
*      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
*      REPLACE ALL OCCURRENCES OF ' le ' IN lv_input WITH ' LE '.
*      REPLACE ALL OCCURRENCES OF ' ge ' IN lv_input WITH ' GE '.
*      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
*      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
*      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.
*
*      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
*        APPEND INITIAL LINE TO lt_key_value ASSIGNING FIELD-SYMBOL(<fs_key_value>).
*        CONDENSE ls_filter_string.
*        SPLIT ls_filter_string AT ' ' INTO lv_name lv_opt lv_value.
*        IF lv_value NE 'null'.
*          DATA(lv_length) = strlen( lv_value ).
*          FREE:lv_length,lv_sprint,lt_sptint.
*          lv_length = strlen( lv_value ).
*          lv_length  = lv_length - 2.
*          lv_sprint = lv_value+1(lv_length).
*          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
*          CASE lv_name.
*            WHEN 'SMODEL'. "1
*              LOOP AT lt_sptint INTO DATA(lst_sprint).
*                lst_smodel-sign = lc_i.
*                lst_smodel-option = lv_opt.
*                lst_smodel-low = lst_sprint.
*                APPEND lst_smodel TO lir_smodel.
*                CLEAR lst_smodel.
*              ENDLOOP.
*
*            WHEN 'AUART'. "2
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_auart-sign = lc_i.
*                lst_auart-option = lv_opt.
*                lst_auart-low = lst_sprint.
*                APPEND lst_auart TO lir_auart.
*                CLEAR lst_auart.
*              ENDLOOP.
*
*            WHEN 'VKORG'. "3
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_vkorg-sign = lc_i.
*                lst_vkorg-option = lv_opt.
*                lst_vkorg-low = lst_sprint.
*                APPEND lst_vkorg TO lir_vkorg.
*                CLEAR lst_vkorg.
*              ENDLOOP.
*
*            WHEN 'PSTAT'. "4
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_pstat-sign = lc_i.
*                lst_pstat-option = lv_opt.
*                lst_pstat-low = lst_sprint.
*                APPEND lst_pstat TO lir_pstat.
*                CLEAR lst_pstat.
*              ENDLOOP.
*
*            WHEN 'ZTERM'. "5
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_zterm-sign = lc_i.
*                lst_zterm-option = lv_opt.
*                lst_zterm-low = lst_sprint.
*                APPEND lst_zterm TO lir_zterm.
*                CLEAR lst_zterm.
*              ENDLOOP.
*
*
*            WHEN 'BSARK'. "6
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_bsark-sign = lc_i.
*                lst_bsark-option = lv_opt.
*                lst_bsark-low = lst_sprint.
*                APPEND lst_bsark TO lir_bsark.
*                CLEAR lst_bsark.
*              ENDLOOP.
*
*            WHEN 'KONDA'.
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_konda-sign = lc_i.
*                lst_konda-option = lv_opt.
*                lst_konda-low = lst_sprint.
*                APPEND lst_konda TO lir_konda.
*                CLEAR lst_konda.
*              ENDLOOP.
*
*            WHEN 'KUNNR'. "7
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_kunnr-sign = lc_i.
*                lst_kunnr-option = lv_opt.
*                lst_kunnr-kunnr_low = lst_sprint.
*                APPEND lst_kunnr TO lir_kunnr.
*                CLEAR lst_kunnr.
*              ENDLOOP.
*
*            WHEN 'KUNWE'. "8
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_kunwe-sign = lc_i.
*                lst_kunwe-option = lv_opt.
*                lst_kunwe-kunnr_low = lst_sprint.
*                APPEND lst_kunwe TO lir_kunwe.
*                CLEAR lst_kunwe.
*              ENDLOOP.
*
*            WHEN 'MATNR'. "9
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_matnr-sign = lc_i.
*                lst_matnr-option = lv_opt.
*                lst_matnr-matnr_low = lst_sprint.
*                APPEND lst_bsark TO lir_matnr.
*                CLEAR lst_matnr.
*              ENDLOOP.
*
*            WHEN 'MVGR5'. "10
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_mvgr5-sign = lc_i.
*                lst_mvgr5-option = lv_opt.
*                lst_mvgr5-low = lst_sprint.
*                APPEND lst_mvgr5 TO lir_mvgr5.
*                CLEAR lst_mvgr5.
*              ENDLOOP.
*
*
*            WHEN 'VBELN'. "11
*              LOOP AT lt_sptint INTO lst_sprint.
*                lst_vbeln-sign = lc_i.
*                lst_vbeln-option = lv_opt.
*                lst_vbeln-low = lst_sprint.
*                APPEND lst_vbeln TO lir_vbeln.
*                CLEAR lst_vbeln.
*              ENDLOOP.
*
*            WHEN 'ERDAT'. "12
*              CLEAR : lv_sdate.
*              CONCATENATE lv_value+1(4)
*                          lv_value+6(2)
*                          lv_value+9(2)
*                          INTO lv_sdate.
*              IF lv_opt = lc_ge.
*                lst_erdat-low = lv_sdate.
*                lst_erdat-sign = lc_i.
*                lst_erdat-option = lc_eq.
*                APPEND lst_erdat TO lir_erdat.
*                CLEAR lst_erdat.
*              ELSEIF lv_opt = lc_le.
*                READ TABLE lir_erdat ASSIGNING FIELD-SYMBOL(<fs_cdate>) INDEX 1.
*                IF sy-subrc EQ 0.
*                  <fs_cdate>-high = lv_sdate.
*                  <fs_cdate>-sign = lc_i.
*                  <fs_cdate>-option = lc_bt.
*                ENDIF.
*              ENDIF.
*
*            WHEN 'FKDAT'. "13
*              CLEAR : lv_bdate.
*              CONCATENATE lv_value+1(4)
*                          lv_value+6(2)
*                          lv_value+9(2)
*                          INTO lv_bdate.
*              IF lv_opt = lc_ge.
*                lst_fkdat-low = lv_bdate.
*                lst_fkdat-sign = lc_i.
*                lst_fkdat-option = lc_eq.
*                APPEND lst_fkdat TO lir_fkdat.
*                CLEAR lst_fkdat.
*              ELSEIF lv_opt = lc_le.
*                READ TABLE lir_fkdat ASSIGNING FIELD-SYMBOL(<fs_bdate>) INDEX 1.
*                IF sy-subrc EQ 0.
*                  <fs_bdate>-high = lv_bdate.
*                  <fs_bdate>-sign = lc_i.
*                  <fs_bdate>-option = lc_bt.
*                ENDIF.
*              ENDIF.
*
*          ENDCASE.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
*       WHERE devid = @lc_devid.
*
*    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
*      IF <lw_const>-param2 IN lir_smodel.
*        IF <lw_const>-param1 = 'VKBUR'.
*          APPEND INITIAL LINE TO li_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
*          <lst_vkbur_i>-sign   = <lw_const>-sign.
*          <lst_vkbur_i>-option = <lw_const>-opti.
*          <lst_vkbur_i>-low    = <lw_const>-low.
*          <lst_vkbur_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'KONDA'.
*          APPEND INITIAL LINE TO lir_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
*          <lst_konda_i>-sign   = <lw_const>-sign.
*          <lst_konda_i>-option = <lw_const>-opti.
*          <lst_konda_i>-low    = <lw_const>-low.
*          <lst_konda_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'MVGR5'.
*          APPEND INITIAL LINE TO li_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
*          <lst_mvgr5_i>-sign   = <lw_const>-sign.
*          <lst_mvgr5_i>-option = <lw_const>-opti.
*          <lst_mvgr5_i>-low    = <lw_const>-low.
*          <lst_mvgr5_i>-high   = <lw_const>-high.
*        ENDIF.
*
*        IF <lw_const>-param1 = 'KDKG2'.
*          APPEND INITIAL LINE TO li_kdkg2 ASSIGNING FIELD-SYMBOL(<lst_kdkg2_i>).
*          <lst_kdkg2_i>-sign   = <lw_const>-sign.
*          <lst_kdkg2_i>-option = <lw_const>-opti.
*          <lst_kdkg2_i>-low    = <lw_const>-low.
*          <lst_kdkg2_i>-high   = <lw_const>-high.
*        ENDIF.
*        CLEAR <lw_const>.
*      ENDIF.
*    ENDLOOP.
*
*    IF lir_vkorg IS INITIAL.
*      LOOP AT lt_const ASSIGNING <lw_const>.
*        IF <lw_const>-param1 = 'VKORG' .
*          APPEND INITIAL LINE TO lir_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
*          <lst_vkorg_i>-sign   = <lw_const>-sign.
*          <lst_vkorg_i>-option = <lw_const>-opti.
*          <lst_vkorg_i>-low    = <lw_const>-low.
*          <lst_vkorg_i>-high   = <lw_const>-high.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*    lv_erdat2 = sy-datum - 200.
*
*
*    SELECT v~vbeln, v~netwr, v~waerk, v~vkorg, v~vkbur, v~auart, v~kunnr, v~bsark,
*        vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid
*       INTO TABLE @DATA(lt_vbak)
*       FROM vbak AS v INNER JOIN vbuv AS vb
*       ON  v~vbeln = vb~vbeln
*       WHERE vkorg IN @lir_vkorg AND vkbur IN @li_vkbur AND auart IN @lir_auart
*             AND kunnr IN @lir_kunnr AND bsark IN @lir_bsark
*         AND  ( erdat LE @sy-datum AND erdat GE @lv_erdat2 ).
*
*    IF sy-subrc = 0.
*      DELETE lt_vbak WHERE waerk IS INITIAL.
*      SORT lt_vbak BY vbeln.
*      DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln posnr.
*    ENDIF.
*
*
*    LOOP AT lt_vbak INTO DATA(lw_vbak).
*      CLEAR lst_tab.
*      lst_tab-count = lst_tab-count + 1.
*      lst_tab-netwr = lw_vbak-netwr.
*      lst_tab-waerk = lw_vbak-waerk.
*      COLLECT lst_tab INTO li_tab.
*    ENDLOOP.
*
*    LOOP AT li_tab INTO lst_tab.
*      lw_entity-waerk = lst_tab-waerk.
*      lw_entity-netwr = lst_tab-netwr.
*      lw_entity-count = lst_tab-count.
*      APPEND lw_entity TO et_entityset.
*      CLEAR :lw_entity,lst_tab.
*    ENDLOOP.
*
*  ENDMETHOD.
*
*
**  WHEN 'ERDAT'. "12
**              CLEAR : lv_sdate.
**              CONCATENATE lv_value+1(4)
**                          lv_value+6(2)
**                          lv_value+9(2)
**                          INTO lv_sdate.
**              IF lv_opt = lc_ge.
**                lst_erdat-low = lv_sdate.
**                lst_erdat-sign = lc_i.
**                lst_erdat-option = lc_eq.
**                APPEND lst_erdat TO lir_erdat.
**                CLEAR lst_erdat.
**              ELSEIF lv_opt = lc_le.
**                READ TABLE lir_erdat ASSIGNING FIELD-SYMBOL(<fs_cdate>) INDEX 1.
**                IF sy-subrc EQ 0.
**                  <fs_cdate>-high = lv_sdate.
**                  <fs_cdate>-sign = lc_i.
**                  <fs_cdate>-option = lc_bt.
**                ENDIF.
**              ENDIF.

*    CONSTANTS: lc_devid TYPE zdevid VALUE 'INCOMP' .
*
*    DATA:lst_const TYPE zcl_zqtco_incomplete_o_mpc=>ts_zcaconst.
**----get constant entries
*
*    SELECT SINGLE * FROM zcaconstant
*      INTO @DATA(lst_constants)
*      WHERE devid = @lc_devid.
*
*    IF sy-subrc EQ 0.
*      CLEAR:lst_const.
*      lst_const-devid = lst_constants-devid .
*      lst_const-param1 = lst_constants-param1.
*      lst_const-param2 = lst_constants-param2.
*      lst_const-sign   = lst_constants-sign.
*      lst_const-opti = lst_constants-opti.
*      lst_const-low    = lst_constants-low.
*      APPEND lst_const TO et_entityset.
*      CLEAR lst_const.
*
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
