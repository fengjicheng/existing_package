class ZCL_ZQTCO_INCOMPLETEOR_DPC_EXT definition
  public
  inheriting from ZCL_ZQTCO_INCOMPLETEOR_DPC
  create public .

public section.
protected section.

  methods DASHBOARDSET_GET_ENTITYSET
    redefinition .
  methods FREIGHTFORWARDER_GET_ENTITYSET
    redefinition .
  methods HEADERSET_GET_ENTITYSET
    redefinition .
  methods INCOMPLOGSET_GET_ENTITYSET
    redefinition .
  methods IORDERSET_GET_ENTITYSET
    redefinition .
  methods ITEMSSET_GET_ENTITYSET
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
  methods SHIPTOPARTYADDRE_GET_ENTITYSET
    redefinition .
  methods SHIPTOSET_GET_ENTITYSET
    redefinition .
  methods SMODELSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOPARTYADDRE_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods ZCACONSTSET_GET_ENTITYSET
    redefinition .
  methods SOCIETYPARTNERSE_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTCO_INCOMPLETEOR_DPC_EXT IMPLEMENTATION.


  METHOD dashboardset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*


    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    TYPES: BEGIN OF lty_vbeln,
             vbeln TYPE vbeln,
           END OF lty_vbeln.

    TYPES: BEGIN OF ty_vbak,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
             vkbur TYPE vkbur,
             konda TYPE konda,
             mvgr5 TYPE mvgr5,
             kdkg2 TYPE kdkg2,
             tbnam TYPE tbnam_vb,
             fdnam TYPE fdnam_vb,
             vkorg TYPE vkorg,
             auart TYPE auart,
             erdat TYPE erdat,
             kunnr TYPE kunnr,
             bsark TYPE bsark,
             etenr TYPE etenr,
             tdid  TYPE tdid,
             matnr TYPE matnr,
             netwr TYPE netwr_ap,
             waerk TYPE waerk,
             zterm TYPE dzterm,
             fkdat TYPE fkdat,
             lifnr TYPE lifnr,
             kunwe TYPE kunnr,
             parvw TYPE parvw,
           END OF ty_vbak.

    TYPES: BEGIN OF ty_vbap2,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
             mvgr5 TYPE mvgr5,
             kdkg2 TYPE kdkg2,
             konda TYPE konda,
             netwr TYPE netwr,
             waerk TYPE waerk,
             matnr TYPE matnr,
             zterm TYPE dzterm,
             fkdat TYPE fkdat,
             lifnr TYPE lifnr,
             kunwe TYPE kunnr,
             parvw TYPE parvw,
           END OF ty_vbap2.

    DATA: li_vbapvbkd  TYPE TABLE OF ty_vbap2,
          lst_vbapvbkd TYPE ty_vbap2.

    DATA: li_vbeln   TYPE STANDARD TABLE OF lty_vbeln,
          lst_vbeln1 TYPE lty_vbeln,
          li_vbak    TYPE STANDARD TABLE OF ty_vbak,
          lst_vbak   TYPE ty_vbak.

    DATA: lv_input         TYPE string,
          lt_filter_string TYPE TABLE OF string,
          lt_sptint        TYPE TABLE OF string,
          lt_key_value     TYPE /iwbep/t_mgw_name_value_pair,
          lv_name          TYPE string,
          lv_opt           TYPE string,
          lv_value         TYPE string,
          lv_sprint        TYPE string,
          lv_csdate        TYPE c LENGTH 10,
          lv_cedate        TYPE c LENGTH 10,
          lv_bsdate        TYPE c LENGTH 10,
          lv_bedate        TYPE c LENGTH 10,
          lv_var1          TYPE string,
          lv_var2          TYPE string.

    DATA: lst_smodel TYPE /iwbep/s_cod_select_option,
          lir_smodel TYPE /iwbep/t_cod_select_options,
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
          lst_kunza  TYPE kun_range,
          lir_kunza  TYPE STANDARD TABLE OF kun_range,
          lst_kunsp  TYPE kun_range,
          lir_kunsp  TYPE STANDARD TABLE OF kun_range,
          lst_matnr  TYPE mat_range,
          lir_matnr  TYPE STANDARD TABLE OF mat_range,
          lst_vbeln  TYPE range_vbeln,
          lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
          lst_erdat  TYPE tds_rg_erdat,
          lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
          lst_fkdat  TYPE tds_rg_erdat,
          lir_fkdat  TYPE STANDARD TABLE OF tds_rg_erdat,
          lst_pstat  TYPE /iwbep/s_cod_select_option,
          lir_pstat  TYPE /iwbep/t_cod_select_options,
          lst_zterm  TYPE /iwbep/s_cod_select_option,
          lir_zterm  TYPE /iwbep/t_cod_select_options,
          lst_konda  TYPE /iwbep/s_cod_select_option,
          lir_konda  TYPE /iwbep/t_cod_select_options,
          lst_mvgr5  TYPE /iwbep/s_cod_select_option,
          lir_mvgr5  TYPE /iwbep/t_cod_select_options.

    DATA: lv_smodel  TYPE c LENGTH 20,
          lv_vkorg   TYPE vkorg,
          lv_amdesc  TYPE char20,
          lv_cssdesc TYPE char20,
          lv_tbtdesc TYPE char20,
          lv_socdesc TYPE char20,
          lv_rundays TYPE i,
          lv_sflag   TYPE flag,
          lv_erdat2  TYPE sy-datum,
          lw_entity  TYPE zcl_zqtco_incompleteor_mpc=>ts_dashboard.

    CONSTANTS: lc_eq     TYPE char2 VALUE 'EQ',
               lc_ge     TYPE char2 VALUE 'GE',
               lc_le     TYPE char2 VALUE 'LE',
               lc_bt     TYPE char2 VALUE 'BT',
               lc_i      TYPE char1 VALUE 'I',
               lc_ag     TYPE parvw VALUE 'AG',
               lc_sp     TYPE parvw VALUE 'SP',
               lc_posnr  TYPE posnr VALUE '000000',
               lc_we     TYPE parvw VALUE 'WE',
               lc_za     TYPE parvw VALUE 'ZA',
               lc_devid  TYPE c LENGTH 12 VALUE 'R144',
               lc_vkbur  TYPE  rvari_vnam     VALUE 'VKBUR',
               lc_konda  TYPE  rvari_vnam     VALUE 'KONDA',
               lc_mvgr5  TYPE  rvari_vnam     VALUE 'MVGR5',
               lc_kdkg2  TYPE  rvari_vnam     VALUE 'KDKG2',
               lc_vkorg  TYPE  rvari_vnam     VALUE 'VKORG',
               lc_model  TYPE  rvari_vnam     VALUE 'MODEL',
               lc_auart  TYPE  rvari_vnam     VALUE 'AUART',
               lc_pstat  TYPE  rvari_vnam     VALUE 'PSTAT',
               lc_zterm  TYPE  rvari_vnam     VALUE 'ZTERM',
               lc_bsark  TYPE  rvari_vnam     VALUE 'BSARK',
               lc_kunnr  TYPE  rvari_vnam     VALUE 'KUNNR',
               lc_kunwe  TYPE  rvari_vnam     VALUE 'KUNWE',
               lc_kunsp  TYPE  rvari_vnam     VALUE 'KUNSP',
               lc_kunza  TYPE  rvari_vnam     VALUE 'KUNZA',
               lc_matnr  TYPE  rvari_vnam     VALUE 'MATNR',
               lc_vbeln  TYPE  rvari_vnam     VALUE 'VBELN',
               lc_erdat  TYPE  rvari_vnam     VALUE 'ERDAT',
               lc_fkdat  TYPE  rvari_vnam     VALUE 'FKDAT',
               lc_days   TYPE  rvari_vnam     VALUE 'RUNDAYS',
               lc_am     TYPE c LENGTH 20 VALUE 'AM',
               lc_css    TYPE c LENGTH 20 VALUE 'CSS',
               lc_tbt    TYPE c LENGTH 20 VALUE 'TBT',
               lc_soc    TYPE c LENGTH 20 VALUE 'SOC',
               lc_others TYPE c LENGTH 20 VALUE 'OTHERS',
               lc_a      TYPE c VALUE 'A',
               lc_b      TYPE c VALUE 'B',
               lc_c      TYPE c VALUE 'C',
               lc_m      TYPE c VALUE 'M',
               lc_u      TYPE c VALUE 'U',
               lc_g      TYPE c VALUE 'G',
               lc_n      TYPE c VALUE 'N',
               lc_p      TYPE c VALUE 'P',
               lc_x      TYPE c VALUE 'X',
               lc_paid   TYPE c LENGTH 20 VALUE 'Paid',
               lc_unpaid TYPE c LENGTH 20 VALUE 'Not Paid'.

    DATA: lr_vkbur  TYPE /iwbep/t_cod_select_options,
          lr_konda  TYPE /iwbep/t_cod_select_options,
          lr_mvgr5  TYPE /iwbep/t_cod_select_options,
          lr_kdkg2  TYPE /iwbep/t_cod_select_options,
          lr_vkorg  TYPE STANDARD TABLE OF range_vkorg,
          lt_vkbur  TYPE /iwbep/t_cod_select_options,
          lt_vkburc TYPE /iwbep/t_cod_select_options,
          lt_vkburt TYPE /iwbep/t_cod_select_options,
          lt_vkburs TYPE /iwbep/t_cod_select_options,
          lt_konda  TYPE /iwbep/t_cod_select_options,
          lt_kondas TYPE /iwbep/t_cod_select_options,
          lt_mvgr5  TYPE /iwbep/t_cod_select_options,
          lt_mvgr5s TYPE /iwbep/t_cod_select_options,
          lt_kdkg2  TYPE /iwbep/t_cod_select_options.


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
             desc  TYPE char20,
             count TYPE i,
           END OF ty_sum.

    DATA: li_tab    TYPE TABLE OF ty_sum,
          li_tabref TYPE TABLE OF ty_sum,
          lst_tab   TYPE ty_sum,
          lv_pstat  TYPE c,
          lv_sdate  TYPE sy-datum,
          lv_edate  TYPE sy-datum.

*------------ Filters for selection criteria -------------*
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.
* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' le ' IN lv_input WITH ' LE '.
      REPLACE ALL OCCURRENCES OF ' ge ' IN lv_input WITH ' GE '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING FIELD-SYMBOL(<fs_key_value>).
        CONDENSE ls_filter_string.
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_opt lv_value.
        IF lv_value NE 'null'.
          DATA(lv_length) = strlen( lv_value ).
          FREE:lv_length,lv_sprint,lt_sptint.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          CASE lv_name.
            WHEN lc_model. "Sales/Business Model
              LOOP AT lt_sptint INTO DATA(lst_sprint).
                lst_smodel-sign = lc_i.
                lst_smodel-option = lv_opt.
                lst_smodel-low = lst_sprint.
                APPEND lst_smodel TO lir_smodel.
                CLEAR: lst_smodel, lst_sprint.
              ENDLOOP.
            WHEN lc_auart. "Order Type
              LOOP AT lt_sptint INTO lst_sprint.
                lst_auart-sign = lc_i.
                lst_auart-option = lv_opt.
                lst_auart-low = lst_sprint.
                APPEND lst_auart TO lir_auart.
                CLEAR: lst_auart, lst_sprint.
              ENDLOOP.
            WHEN lc_vkorg. "Sales Org
              LOOP AT lt_sptint INTO lst_sprint.
                lst_vkorg-sign = lc_i.
                lst_vkorg-option = lv_opt.
                lst_vkorg-low = lst_sprint.
                APPEND lst_vkorg TO lir_vkorg.
                CLEAR: lst_vkorg, lst_sprint.
              ENDLOOP.
            WHEN lc_pstat. "Payment Status
              lv_pstat = lv_sprint.
            WHEN lc_zterm. "Payment terms
              LOOP AT lt_sptint INTO lst_sprint.
                lst_zterm-sign = lc_i.
                lst_zterm-option = lv_opt.
                lst_zterm-low = lst_sprint.
                APPEND lst_zterm TO lir_zterm.
                CLEAR: lst_zterm, lst_sprint.
              ENDLOOP.
            WHEN lc_bsark. "Po Type
              LOOP AT lt_sptint INTO lst_sprint.
                lst_bsark-sign = lc_i.
                lst_bsark-option = lv_opt.
                lst_bsark-low = lst_sprint.
                APPEND lst_bsark TO lir_bsark.
                CLEAR: lst_bsark, lst_sprint.
              ENDLOOP.
            WHEN lc_konda. "Price group
              LOOP AT lt_sptint INTO lst_sprint.
                lst_konda-sign = lc_i.
                lst_konda-option = lv_opt.
                lst_konda-low = lst_sprint.
                APPEND lst_konda TO lir_konda.
                CLEAR: lst_konda, lst_sprint.
              ENDLOOP.
            WHEN lc_kunnr. "Soldto BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunnr-sign = lc_i.
                lst_kunnr-option = lv_opt.
                lst_kunnr-kunnr_low = lst_sprint.
                APPEND lst_kunnr TO lir_kunnr.
                CLEAR: lst_kunnr, lst_sprint.
              ENDLOOP.
            WHEN lc_kunwe. "Shipto BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunwe-sign = lc_i.
                lst_kunwe-option = lv_opt.
                lst_kunwe-kunnr_low = lst_sprint.
                APPEND lst_kunwe TO lir_kunwe.
                CLEAR: lst_kunwe, lst_sprint.
              ENDLOOP.
            WHEN lc_kunsp. "Freight Forwarder BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunsp-sign = lc_i.
                lst_kunsp-option = lv_opt.
                lst_kunsp-kunnr_low = lst_sprint.
                APPEND lst_kunsp TO lir_kunsp.
                CLEAR: lst_kunsp, lst_sprint.
              ENDLOOP.
            WHEN lc_kunza. "Society BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunza-sign = lc_i.
                lst_kunza-option = lv_opt.
                lst_kunza-kunnr_low = lst_sprint.
                APPEND lst_kunza TO lir_kunza.
                CLEAR: lst_kunza, lst_sprint.
              ENDLOOP.
            WHEN lc_matnr. "Material
              LOOP AT lt_sptint INTO lst_sprint.
                lst_matnr-sign = lc_i.
                lst_matnr-option = lv_opt.
                lst_matnr-matnr_low = lst_sprint.
                APPEND lst_matnr TO lir_matnr.
                CLEAR: lst_matnr, lst_sprint.
              ENDLOOP.
            WHEN lc_mvgr5. "Material Group5
              LOOP AT lt_sptint INTO lst_sprint.
                lst_mvgr5-sign = lc_i.
                lst_mvgr5-option = lv_opt.
                lst_mvgr5-low = lst_sprint.
                APPEND lst_mvgr5 TO lir_mvgr5.
                CLEAR: lst_mvgr5, lst_sprint.
              ENDLOOP.
            WHEN lc_vbeln. "Order
              LOOP AT lt_sptint INTO lst_sprint.
                lst_vbeln-sign = lc_i.
                lst_vbeln-option = lv_opt.
                lst_vbeln-low = lst_sprint.
                APPEND lst_vbeln TO lir_vbeln.
                CLEAR: lst_vbeln, lst_sprint.
              ENDLOOP.
            WHEN lc_erdat. "Created Date
              CLEAR:lv_length, lv_sprint, lv_csdate, lv_cedate, lv_var1, lv_var2.
              lv_length = strlen( lv_value ).
              lv_length  = lv_length - 2.
              lv_sprint = lv_value+1(lv_length).
              SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
              CONDENSE lv_sprint NO-GAPS.
              CONCATENATE lv_var1+6(4)
                          lv_var1+3(2)
                          lv_var1+0(2)
                          INTO lv_csdate.
              CONCATENATE lv_var2+6(4)
                          lv_var2+3(2)
                          lv_var2+0(2)
                          INTO lv_cedate.
              lst_erdat-low = lv_csdate.
              lst_erdat-sign = lc_i.
              lst_erdat-option = lc_bt.
              lst_erdat-high = lv_cedate.
              APPEND lst_erdat TO lir_erdat.
              CLEAR lst_erdat.
            WHEN lc_fkdat. "Billing Date
              CLEAR:lv_length, lv_sprint, lv_bsdate, lv_bedate, lv_var1, lv_var2.
              lv_length = strlen( lv_value ).
              lv_length  = lv_length - 2.
              lv_sprint = lv_value+1(lv_length).
              SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
              CONDENSE lv_sprint NO-GAPS.
              CONCATENATE lv_var1+6(4)
                          lv_var1+3(2)
                          lv_var1+0(2)
                          INTO lv_bsdate.
              CONCATENATE lv_var2+6(4)
                          lv_var2+3(2)
                          lv_var2+0(2)
                          INTO lv_bedate.
              lst_fkdat-low = lv_bsdate.
              lst_fkdat-sign = lc_i.
              lst_fkdat-option = lc_bt.
              lst_fkdat-high = lv_bedate.
              APPEND lst_fkdat TO lir_fkdat.
              CLEAR lst_fkdat.
              CLEAR: lst_sprint.
          ENDCASE.
        ENDIF.
      ENDLOOP.
    ENDIF.
*------------------- Fetch Constant Table data ----------------------*
    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
           WHERE devid = @lc_devid AND activate = @abap_true.

    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
      CASE <lfs_const>-param2.
        WHEN lc_am.
          IF <lfs_const>-param1 = lc_vkbur.
            APPEND INITIAL LINE TO lt_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur>).
            <lst_vkbur>-sign = <lfs_const>-sign.
            <lst_vkbur>-option = <lfs_const>-opti.
            <lst_vkbur>-low =  <lfs_const>-low.
            <lst_vkbur>-high = <lfs_const>-high.
          ENDIF.
        WHEN lc_css.
          IF <lfs_const>-param1 = lc_vkbur.
            APPEND INITIAL LINE TO lt_vkburc ASSIGNING <lst_vkbur>.
            <lst_vkbur>-sign = <lfs_const>-sign.
            <lst_vkbur>-option = <lfs_const>-opti.
            <lst_vkbur>-low =  <lfs_const>-low.
            <lst_vkbur>-high = <lfs_const>-high.
          ENDIF.
        WHEN lc_tbt.
          IF <lfs_const>-param1 = lc_vkbur.
            APPEND INITIAL LINE TO lt_vkburt ASSIGNING <lst_vkbur>.
            <lst_vkbur>-sign = <lfs_const>-sign.
            <lst_vkbur>-option = <lfs_const>-opti.
            <lst_vkbur>-low =  <lfs_const>-low.
            <lst_vkbur>-high = <lfs_const>-high.
          ELSEIF <lfs_const>-param1 = lc_konda.
            APPEND INITIAL LINE TO lt_konda ASSIGNING FIELD-SYMBOL(<lst_konda>).
            <lst_konda>-sign = <lfs_const>-sign.
            <lst_konda>-option = <lfs_const>-opti.
            <lst_konda>-low =  <lfs_const>-low.
            <lst_konda>-high = <lfs_const>-high.
          ELSEIF <lfs_const>-param1 = lc_mvgr5.
            APPEND INITIAL LINE TO lt_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5>) .
            <lst_mvgr5>-sign = <lfs_const>-sign.
            <lst_mvgr5>-option = <lfs_const>-opti.
            <lst_mvgr5>-low =  <lfs_const>-low.
            <lst_mvgr5>-high = <lfs_const>-high.
          ENDIF.
        WHEN lc_soc.
          IF <lfs_const>-param1 = lc_vkbur.
            APPEND INITIAL LINE TO lt_vkburs ASSIGNING <lst_vkbur>.
            <lst_vkbur>-sign = <lfs_const>-sign.
            <lst_vkbur>-option = <lfs_const>-opti.
            <lst_vkbur>-low =  <lfs_const>-low.
            <lst_vkbur>-high = <lfs_const>-high.
          ELSEIF <lfs_const>-param1 = lc_konda.
            APPEND INITIAL LINE TO lt_kondas ASSIGNING <lst_konda>.
            <lst_konda>-sign = <lfs_const>-sign.
            <lst_konda>-option = <lfs_const>-opti.
            <lst_konda>-low =  <lfs_const>-low.
            <lst_konda>-high = <lfs_const>-high.
          ELSEIF <lfs_const>-param1 = lc_mvgr5.
            APPEND INITIAL LINE TO lt_mvgr5s ASSIGNING <lst_mvgr5>.
            <lst_mvgr5>-sign = <lfs_const>-sign.
            <lst_mvgr5>-option = <lfs_const>-opti.
            <lst_mvgr5>-low =  <lfs_const>-low.
            <lst_mvgr5>-high = <lfs_const>-high.
          ENDIF.
      ENDCASE.
*------------If Sales/Business Model is not provided/ blank------------*
      IF lir_smodel IS INITIAL.
        IF <lfs_const>-param1 = lc_vkbur.
          APPEND INITIAL LINE TO lr_vkbur ASSIGNING <lst_vkbur_i>.
          <lst_vkbur_i>-sign   = <lfs_const>-sign.
          <lst_vkbur_i>-option = <lfs_const>-opti.
          <lst_vkbur_i>-low    = <lfs_const>-low.
          <lst_vkbur_i>-high   = <lfs_const>-high.
        ENDIF.
        IF lir_konda IS INITIAL AND <lfs_const>-param1 = lc_konda.
          APPEND INITIAL LINE TO lr_konda ASSIGNING <lst_konda_i>.
          <lst_konda_i>-sign   = <lfs_const>-sign.
          <lst_konda_i>-option = <lfs_const>-opti.
          <lst_konda_i>-low    = <lfs_const>-low.
          <lst_konda_i>-high   = <lfs_const>-high.
        ENDIF.
        IF lir_mvgr5 IS INITIAL AND <lfs_const>-param1 = lc_mvgr5.
          APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING <lst_mvgr5_i>.
          <lst_mvgr5_i>-sign   = <lfs_const>-sign.
          <lst_mvgr5_i>-option = <lfs_const>-opti.
          <lst_mvgr5_i>-low    = <lfs_const>-low.
          <lst_mvgr5_i>-high   = <lfs_const>-high.
        ENDIF.
*-------If Sales/Business Model is provided-------*
      ELSEIF lir_smodel IS NOT INITIAL.
        LOOP AT lir_smodel INTO lst_smodel.
          IF <lfs_const>-param2 = lst_smodel-low.
            IF <lfs_const>-param1 = lc_vkbur.
              APPEND INITIAL LINE TO lr_vkbur ASSIGNING <lst_vkbur_i>.
              <lst_vkbur_i>-sign   = <lfs_const>-sign.
              <lst_vkbur_i>-option = <lfs_const>-opti.
              <lst_vkbur_i>-low    = <lfs_const>-low.
              <lst_vkbur_i>-high   = <lfs_const>-high.
            ENDIF.
            IF <lfs_const>-param1 = lc_konda.
              APPEND INITIAL LINE TO lr_konda ASSIGNING <lst_konda_i>.
              <lst_konda_i>-sign   = <lfs_const>-sign.
              <lst_konda_i>-option = <lfs_const>-opti.
              <lst_konda_i>-low    = <lfs_const>-low.
              <lst_konda_i>-high   = <lfs_const>-high.
            ENDIF.
            IF  <lfs_const>-param1 = lc_mvgr5.
              APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING <lst_mvgr5_i>.
              <lst_mvgr5_i>-sign   = <lfs_const>-sign.
              <lst_mvgr5_i>-option = <lfs_const>-opti.
              <lst_mvgr5_i>-low    = <lfs_const>-low.
              <lst_mvgr5_i>-high   = <lfs_const>-high.
            ENDIF.
          ENDIF.
          CLEAR:lst_smodel.
        ENDLOOP.
      ENDIF.
*---------Get default date range---------*
      IF lir_erdat IS INITIAL AND <lfs_const>-param1 = lc_days.
        CONDENSE <lfs_const>-low NO-GAPS.
        lv_rundays = <lfs_const>-low.
        lv_sdate = sy-datum - lv_rundays.
        lv_edate = sy-datum.
      ELSEIF lir_erdat IS NOT INITIAL.
        lv_sdate = lv_csdate.
        lv_edate = lv_cedate.
      ENDIF.

*---------Get Sales org if not provided---------*
      IF lir_vkorg IS INITIAL AND <lfs_const>-param1 = lc_vkorg .
        APPEND INITIAL LINE TO lr_vkorg ASSIGNING <lst_vkorg_i>.
        <lst_vkorg_i>-sign   = <lfs_const>-sign.
        <lst_vkorg_i>-option = <lfs_const>-opti.
        <lst_vkorg_i>-low    = <lfs_const>-low.
        <lst_vkorg_i>-high   = <lfs_const>-high.
      ENDIF.
*---------Get desc for Sales Model-------------*
      CASE <lfs_const>-low.
        WHEN lc_am.
          lv_amdesc = <lfs_const>-high.
        WHEN lc_css.
          lv_cssdesc = <lfs_const>-high.
        WHEN lc_tbt.
          lv_tbtdesc = <lfs_const>-high.
        WHEN lc_soc.
          lv_socdesc = <lfs_const>-high.
      ENDCASE.
      CLEAR: <lfs_const>.
    ENDLOOP.

    FREE:lir_erdat.
    lst_erdat-sign = lc_i.
    lst_erdat-option = lc_bt.
    lst_erdat-low = lv_sdate.
    lst_erdat-high = lv_edate.
    APPEND lst_erdat TO lir_erdat.
    CLEAR lst_erdat.

*------If Front-end filter is initial then will pass entries from constant table----*
    IF lir_vkorg IS INITIAL.
      lir_vkorg = lr_vkorg.
    ENDIF.

    IF lir_konda IS INITIAL.
      DATA(lv_kondaf) = abap_false.
      lir_konda = lr_konda.
    ELSE.
      lv_kondaf = abap_true.
      FREE:lr_konda .
    ENDIF.
    IF lir_mvgr5 IS INITIAL.
      DATA(lv_mvgr5f) = abap_false.
      lir_mvgr5 = lr_mvgr5.
    ELSE.
      lv_mvgr5f = abap_true.
      FREE lr_mvgr5.
    ENDIF.

*------------------Fetch Incomplete Orders--------------------------*
    SELECT v~vbeln, vb~posnr, v~vkbur, vb~tbnam, vb~fdnam, v~vkorg", v~waerk
            ,v~auart,v~erdat, v~kunnr, v~bsark,vb~etenr, vb~tdid
           INTO TABLE @DATA(li_vbuvvbak)
           FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
           WHERE ( v~vkbur IN @lr_vkbur ) AND ( v~bsark IN @lir_bsark )
           AND ( v~kunnr IN @lir_kunnr ) AND ( v~vbeln IN @lir_vbeln )
           AND v~auart IN @lir_auart AND ( v~vkorg IN @lir_vkorg )
           AND v~erdat IN @lir_erdat.
    IF sy-subrc EQ 0.
      SORT li_vbuvvbak BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_vbuvvbak COMPARING vbeln posnr.

      IF li_vbuvvbak IS NOT INITIAL.
        SELECT vp~vbeln, vp~posnr, vp~mvgr5, vk~kdkg2, vk~konda, vp~netwr, vp~waerk, vp~matnr,
          vk~zterm, vk~fkdat, vpa~lifnr, vpa~kunnr AS kunwe, vpa~parvw
          INTO TABLE @DATA(li_vbap)
          FROM vbap AS vp INNER JOIN vbkd AS vk ON vp~vbeln = vk~vbeln AND vp~posnr = vk~posnr
          INNER JOIN vbpa AS vpa ON vpa~vbeln = vk~vbeln
          FOR ALL ENTRIES IN @li_vbuvvbak
          WHERE vp~vbeln EQ @li_vbuvvbak-vbeln AND vp~posnr EQ @li_vbuvvbak-posnr AND
          vk~zterm IN @lir_zterm AND vp~matnr IN @lir_matnr." AND vk~fkdat IN @lir_fkdat.

        IF sy-subrc EQ 0.

          SORT li_vbap BY vbeln posnr.

        ENDIF.
        LOOP AT li_vbuvvbak INTO DATA(lst_vbuvvbak).
          READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbuvvbak-vbeln posnr = lst_vbuvvbak-posnr BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_vbak-mvgr5 = lst_vbap-mvgr5.
            lst_vbak-kdkg2 = lst_vbap-kdkg2.
            lst_vbak-konda = lst_vbap-konda.
            lst_vbak-netwr = lst_vbap-netwr.
            lst_vbak-waerk = lst_vbap-waerk.
            lst_vbak-matnr = lst_vbap-matnr.
            lst_vbak-zterm = lst_vbap-zterm.
            lst_vbak-fkdat = lst_vbap-fkdat.
            lst_vbak-lifnr = lst_vbap-lifnr.
            lst_vbak-kunwe = lst_vbap-kunwe.
            lst_vbak-parvw = lst_vbap-parvw.
          ENDIF.
          lst_vbak-vbeln = lst_vbuvvbak-vbeln.
          lst_vbak-posnr = lst_vbuvvbak-posnr.
          lst_vbak-vkbur = lst_vbuvvbak-vkbur.
          lst_vbak-tbnam = lst_vbuvvbak-tbnam.
          lst_vbak-fdnam = lst_vbuvvbak-fdnam.
          lst_vbak-vkorg = lst_vbuvvbak-vkorg.
          lst_vbak-auart = lst_vbuvvbak-auart.
          lst_vbak-erdat = lst_vbuvvbak-erdat.
          lst_vbak-kunnr = lst_vbuvvbak-kunnr.
          lst_vbak-bsark = lst_vbuvvbak-bsark.
          lst_vbak-etenr = lst_vbuvvbak-etenr.
          lst_vbak-tdid  = lst_vbuvvbak-tdid.
          APPEND lst_vbak TO li_vbak.
          CLEAR: lst_vbak, lst_vbap, lst_vbuvvbak.
        ENDLOOP.

*--------Fetch data based on Billing date filter -------*
        IF lir_fkdat IS NOT INITIAL.
          DELETE li_vbak WHERE fkdat NOT IN lir_fkdat.
        ENDIF.
*--------If Header data is Incomplete then it will consider Item data-----*
        DATA(li_waerk) = li_vbak.
        SORT li_waerk BY vbeln.

        IF li_waerk IS NOT INITIAL.
***************************************************
* VBAP2 SPLIT
          SELECT vbeln, posnr, mvgr5,   netwr, waerk, matnr
           INTO TABLE @DATA(li_vbapnew)
           FROM vbap
           FOR ALL ENTRIES IN @li_waerk
           WHERE vbeln EQ @li_waerk-vbeln.
          IF sy-subrc EQ 0.
            SORT li_vbapnew BY vbeln posnr.
          ENDIF.

          SELECT vbeln, posnr,  kdkg2, konda,
           zterm, fkdat
           INTO TABLE @DATA(li_vbkdnew)
           FROM vbkd
           FOR ALL ENTRIES IN @li_waerk
           WHERE vbeln EQ @li_waerk-vbeln.
          IF sy-subrc EQ 0.
            SORT li_vbkdnew BY vbeln posnr.
          ENDIF.

*-------- Get partner details -------*
          SELECT vbeln, posnr, parvw, kunnr, lifnr
          INTO TABLE @DATA(li_vbpax)
          FROM vbpa
          FOR ALL ENTRIES IN @li_vbak
          WHERE vbeln EQ @li_vbak-vbeln.
          IF sy-subrc EQ 0.
            SORT li_vbpax BY vbeln parvw.
            DATA(li_vbpanew) = li_vbpax.
            SORT li_vbpanew BY vbeln posnr parvw.
          ENDIF.

          CLEAR:lst_vbapvbkd.
          FREE:li_vbapvbkd[].
          LOOP AT li_vbapnew INTO DATA(lst_vb1).
            MOVE-CORRESPONDING lst_vb1 TO lst_vbapvbkd.

            READ TABLE li_vbpanew INTO DATA(lst_vbpanew) WITH KEY vbeln = lst_vb1-vbeln
                                                               posnr = lst_vb1-posnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_vbapvbkd-kunwe = lst_vbpanew-kunnr.
              lst_vbapvbkd-lifnr = lst_vbpanew-lifnr.
              lst_vbapvbkd-parvw = lst_vbpanew-parvw.
            ENDIF.

            READ TABLE li_vbkdnew INTO DATA(lst_vbkdnew) WITH KEY vbeln = lst_vb1-vbeln
                                                               posnr = lst_vb1-posnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_vbapvbkd-konda = lst_vbkdnew-konda.
              lst_vbapvbkd-kdkg2 = lst_vbkdnew-kdkg2.
              lst_vbapvbkd-zterm = lst_vbkdnew-zterm.
              lst_vbapvbkd-fkdat = lst_vbkdnew-fkdat.
            ENDIF.


            APPEND lst_vbapvbkd TO li_vbapvbkd.
            CLEAR:lst_vbapvbkd,lst_vb1,lst_vbpanew,lst_vbkdnew.
          ENDLOOP.

          IF li_vbapvbkd[] IS NOT INITIAL.
            DATA(li_vbap2) = li_vbapvbkd[].
            SORT li_vbap2 BY vbeln posnr.
          ENDIF.
****************************************************
*          SELECT vp~vbeln, vp~posnr, vp~mvgr5, vk~kdkg2, vk~konda, vp~netwr, vp~waerk, vp~matnr,
*          vk~zterm, vk~fkdat, vpa~lifnr, vpa~kunnr AS kunwe, vpa~parvw ",va~erdat
*          INTO TABLE @DATA(li_vbap2)
*          FROM vbap AS vp  INNER JOIN vbkd AS vk ON vp~vbeln = vk~vbeln
*          INNER JOIN vbpa AS vpa ON vpa~vbeln = vk~vbeln
*          FOR ALL ENTRIES IN @li_waerk
*          WHERE vp~vbeln EQ @li_waerk-vbeln.
*          IF sy-subrc EQ 0.
*            SORT li_vbap2 BY vbeln posnr.
*          ENDIF.
*
**-------- Get partner details -------*
*          SELECT vbeln, posnr, parvw, kunnr, lifnr
*          INTO TABLE @DATA(li_vbpax)
*          FROM vbpa
*          FOR ALL ENTRIES IN @li_vbak
*          WHERE vbeln EQ @li_vbak-vbeln.
*          IF sy-subrc EQ 0.
*            SORT li_vbpax BY vbeln parvw.
*          ENDIF.
**************************************************************
*-------- Get address details -------*
          SELECT vpa~vbeln, vpa~posnr, vpa~parvw, vpa~kunnr, vpa~adrnr, vpa~lifnr,
           ad~addrnumber,ad~date_from,ad~nation, ad~street,ad~name1,
          ad~city1, ad~region, ad~post_code1, ad~country
          INTO TABLE @DATA(li_vbpa)
          FROM vbpa AS vpa
          INNER JOIN adrc AS ad ON ad~addrnumber = vpa~adrnr
          FOR ALL ENTRIES IN @li_vbak
          WHERE vpa~vbeln EQ @li_vbak-vbeln.
          IF sy-subrc EQ 0.
            SORT li_vbpa BY vbeln posnr parvw.
            DATA(li_vbappa) = li_vbap.
            SORT li_vbappa BY vbeln parvw.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.
*------------------------  Applying BP filters ----------------------*
    IF li_vbak IS NOT INITIAL.
      DATA(li_vbak2) = li_vbak.
      DATA(li_vbakkp) = li_vbak.
      SORT li_vbak2 BY vbeln.
      DELETE ADJACENT DUPLICATES FROM li_vbak2 COMPARING vbeln .
      SORT li_vbakkp BY vbeln parvw.

      DATA:lv_part(1) TYPE c.
      DATA:lv_mat(1) TYPE c.
      DATA:lv_zterm(1) TYPE c.
      SORT:lir_kunnr BY kunnr_low.
      SORT:lir_kunwe BY kunnr_low.
      SORT:lir_kunza BY kunnr_low.
      SORT:lir_kunsp BY kunnr_low.

      LOOP AT li_vbak2 ASSIGNING FIELD-SYMBOL(<lst_vbak2>).
        lv_part = abap_true.
        IF lir_kunnr IS NOT INITIAL.    " If Filter on Sold to BP
          READ TABLE li_vbpax INTO DATA(lst_vkpp) WITH KEY vbeln = <lst_vbak2>-vbeln
                                                           parvw = lc_ag
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunnr TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpp-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.
        ENDIF.

        IF lir_kunwe IS NOT INITIAL.    " If Filter on Ship to BP
          CLEAR:lst_vkpp.
          READ TABLE li_vbpax INTO lst_vkpp WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_we
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunwe TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpp-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

        IF lir_kunza IS NOT INITIAL.    " If Filter on Society BP
          CLEAR:lst_vkpp.
          READ TABLE li_vbpax INTO lst_vkpp WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_za
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunza TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpp-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

        IF lir_kunsp IS NOT INITIAL.    " If Filter on Freight Forwarder BP
          CLEAR:lst_vkpp.
          READ TABLE li_vbpax INTO lst_vkpp WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_sp
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunsp TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpp-lifnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

*----------- Validations on Input filter Material, Payment Terms -------*

        LOOP AT li_vbap2 INTO DATA(lst_vbapf) WHERE vbeln = <lst_vbak2>-vbeln.
          IF lir_matnr IS NOT INITIAL.
            IF lst_vbapf-matnr IN lir_matnr.
              lv_mat = abap_false.
              EXIT.
            ELSE.
              lv_mat = abap_true.
            ENDIF.
          ENDIF.
          IF lir_zterm IS NOT INITIAL.
            IF lst_vbapf-zterm IN lir_zterm.
              lv_zterm = abap_false.
              EXIT.
            ELSE.
              lv_zterm = abap_true.
            ENDIF.
          ENDIF.
          CLEAR:lst_vbapf.
        ENDLOOP.

        IF lv_mat IS NOT INITIAL.
          <lst_vbak2>-vbeln = abap_true.
          CLEAR:lv_mat.
        ENDIF.

        IF lv_zterm IS NOT INITIAL.
          <lst_vbak2>-vbeln = abap_true.
          CLEAR:lv_zterm.
        ENDIF.

      ENDLOOP.


      DELETE li_vbak2 WHERE vbeln = abap_true.
      SORT li_vbak BY vbeln posnr vkbur mvgr5 kdkg2 konda tbnam fdnam.
      SORT li_vbak2 BY vbeln .
      DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING vbeln  posnr .
      SORT li_vbak BY vbeln  posnr vkbur mvgr5 kdkg2 konda tbnam fdnam.

*---------------Get status for orders which are paid/unpaid----------------*
      CHECK li_vbak IS NOT INITIAL.

      IF li_vbak IS NOT INITIAL.
        SELECT vbelv, vbtyp_n FROM vbfa INTO TABLE @DATA(li_vbfa) FOR ALL ENTRIES IN @li_vbak
                   WHERE vbelv EQ @li_vbak-vbeln.

        IF sy-subrc EQ 0.
          DELETE li_vbfa WHERE vbtyp_n NE lc_m.
          SORT li_vbfa BY vbelv.
        ENDIF.

      ENDIF.
*---------------------To categorize and count the orders ---------*
      IF li_vbak IS NOT INITIAL.
        SORT lir_konda BY low.
        SORT lir_mvgr5 BY low.
        SORT li_vbak2 BY vbeln.
        LOOP AT li_vbak INTO DATA(lw_vbak).

          IF lv_pstat EQ lc_u .
*----------- Check Order  Unpaid ----------*
            READ TABLE li_vbfa INTO DATA(lw_vbfa) WITH KEY vbelv = lw_vbak-vbeln BINARY SEARCH.
            IF sy-subrc EQ 0.
              CLEAR:lw_vbfa,lw_vbak.
              CONTINUE.
            ENDIF.
          ELSEIF lv_pstat EQ lc_p.
*------------ Check Order Paid ----------*
            CLEAR:lw_vbfa.
            READ TABLE li_vbfa INTO lw_vbfa WITH KEY vbelv = lw_vbak-vbeln BINARY SEARCH.
            IF sy-subrc NE 0.
              CLEAR:lw_vbfa,lw_vbak.
              CONTINUE.
            ENDIF.
          ENDIF.

          CLEAR:lv_part.
          READ TABLE li_vbak2 INTO DATA(lst_vkp) WITH KEY vbeln = lw_vbak-vbeln BINARY SEARCH.
          IF sy-subrc NE 0.
            CONTINUE.
          ENDIF.
*------------- If only Header data is Incomplete, then consider item data------*
          IF lw_vbak-waerk IS INITIAL.  "If only Header data is Incomplete

            LOOP AT li_vbap2 INTO DATA(lst_vbap2) WHERE vbeln = lw_vbak-vbeln.
              CLEAR lst_tab.
              IF lw_vbak-vkbur IN lt_vkbur.  "For AM
                lst_tab-model = lc_am.
                lst_tab-desc = lv_amdesc.
                IF lv_mvgr5f IS NOT INITIAL.
                  IF lir_mvgr5 IS NOT INITIAL.
                    IF lst_vbap2-mvgr5 IN lir_mvgr5.
                    ELSE.
                      CLEAR:lst_tab-model.
                    ENDIF.
                  ENDIF.
                ENDIF.
                IF lv_kondaf IS NOT INITIAL.
                  IF lir_konda IS NOT INITIAL.
                    IF lst_vbap2-konda IN lir_konda.
                    ELSE.
                      CLEAR:lst_tab-model.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ELSEIF lw_vbak-vkbur IN lt_vkburc. "For CSS
                lst_tab-model = lc_css.
                lst_tab-desc = lv_cssdesc.
                IF lv_mvgr5f IS NOT INITIAL.
                  IF lir_mvgr5 IS NOT INITIAL.
                    IF lst_vbap2-mvgr5 IN lir_mvgr5.
                    ELSE.
                      CLEAR:lst_tab-model.
                    ENDIF.
                  ENDIF.
                ENDIF.

                IF lv_kondaf IS NOT INITIAL.
                  IF lir_konda IS NOT INITIAL.
                    IF lst_vbap2-konda IN lir_konda.
                    ELSE.
                      CLEAR:lst_tab-model.
                    ENDIF.
                  ENDIF.
                ENDIF.

              ELSEIF lw_vbak-vkbur IN lt_vkburt.
                IF  ( lst_vbap2-konda IN lt_konda ) AND ( lst_vbap2-mvgr5 IN lt_mvgr5 ).
                  lst_tab-model = lc_tbt.  "For TBT
                  lst_tab-desc = lv_tbtdesc.
                ENDIF.
                IF ( lst_vbap2-konda IN lt_kondas ) AND ( lst_vbap2-mvgr5 IN lt_mvgr5s )
                  AND ( lst_vbap2-kdkg2 IS NOT INITIAL ).
                  lst_tab-model = lc_soc.  "For SOC
                  lst_tab-desc = lv_socdesc.
                ENDIF.

                IF lir_mvgr5 IS NOT INITIAL.
                  IF lst_vbap2-mvgr5 IN lir_mvgr5.
                  ELSE.
                    CLEAR:lst_tab-model.
                  ENDIF.
                ENDIF.

                IF lir_konda IS NOT INITIAL.
                  IF lst_vbap2-konda IN lir_konda.
                  ELSE.
                    CLEAR:lst_tab-model.
                  ENDIF.
                ENDIF.

              ENDIF.
              IF lst_tab-model IS NOT INITIAL.
                lst_tab-waerk = lst_vbap2-waerk.
                CLEAR:lst_vbap2.
                EXIT.
              ENDIF.
              CLEAR: lst_vbap2.
            ENDLOOP.

            IF lst_tab-model IS  INITIAL.
              lst_tab-model = lc_others. "For others
              CLEAR:lst_vbap2.
              CONTINUE.
            ENDIF.

          ELSE.  " If both Header and Item or only Item is incomplete
            CLEAR lst_tab.

            IF lw_vbak-vkbur IN lt_vkbur.  "For AM
              LOOP AT li_vbap2 INTO lst_vbap2 WHERE vbeln = lw_vbak-vbeln.
                lst_tab-model = lc_am.
                lst_tab-desc = lv_amdesc.
                lst_tab-waerk = lw_vbak-waerk.
                lv_part = abap_false.

                IF lv_mvgr5f IS NOT INITIAL.
                  IF lir_mvgr5 IS NOT INITIAL.
                    IF lst_vbap2-mvgr5 IN lir_mvgr5.
                    ELSE.
                      CLEAR:lst_tab-model.
                      lv_part = abap_true.
                    ENDIF.
                  ENDIF.
                ENDIF.
                IF lv_kondaf IS NOT INITIAL.
                  IF lir_konda IS NOT INITIAL.
                    IF lst_vbap2-konda IN lir_konda.
                    ELSE.
                      CLEAR:lst_tab-model.
                      lv_part = abap_true.
                    ENDIF.
                  ENDIF.
                ENDIF.
                IF lst_tab-model IS NOT INITIAL.
                  lv_part = abap_false.
                  CLEAR:lst_vbap2.
                  EXIT.
                ENDIF.
              ENDLOOP.

            ELSEIF lw_vbak-vkbur IN lt_vkburc. "For CSS
              LOOP AT li_vbap2 INTO lst_vbap2 WHERE vbeln = lw_vbak-vbeln.
                lst_tab-model = lc_css.
                lst_tab-desc = lv_cssdesc.
                lst_tab-waerk = lw_vbak-waerk.
                lv_part = abap_false.
                IF lv_mvgr5f IS NOT INITIAL.
                  IF lir_mvgr5 IS NOT INITIAL.
                    IF lst_vbap2-mvgr5 IN lir_mvgr5.
                    ELSE.
                      CLEAR:lst_tab-model.
                      lv_part = abap_true.
                    ENDIF.
                  ENDIF.
                ENDIF.

                IF lv_kondaf IS NOT INITIAL.
                  IF lir_konda IS NOT INITIAL.
                    IF lst_vbap2-konda IN lir_konda.
                    ELSE.
                      CLEAR:lst_tab-model.
                      lv_part = abap_true.
                    ENDIF.
                  ENDIF.
                ENDIF.
                IF lst_tab-model IS NOT INITIAL.
                  lv_part = abap_false.
                  CLEAR:lst_vbap2.
                  EXIT.
                ENDIF.
              ENDLOOP.
            ELSEIF lw_vbak-vkbur IN lt_vkburt.

              CLEAR:lst_vbap2.
              LOOP AT li_vbap2 INTO lst_vbap2 WHERE vbeln = lw_vbak-vbeln.
                IF lir_mvgr5 IS NOT INITIAL. "If Filter on Material Group5
                  CLEAR: lst_mvgr5.
                  READ TABLE lir_mvgr5 INTO lst_mvgr5 WITH KEY low = lst_vbap2-mvgr5 BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CLEAR:lst_vbap2.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF lir_konda IS NOT INITIAL. "If Filter on Price Group
                  CLEAR: lst_konda.
                  READ TABLE lir_konda INTO lst_konda WITH KEY  low = lst_vbap2-konda BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CLEAR:lst_vbap2.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF  ( lst_vbap2-konda IN lt_konda ) AND ( lst_vbap2-mvgr5 IN lt_mvgr5 ).
                  lst_tab-model = lc_tbt.  "For TBT
                  lst_tab-desc = lv_tbtdesc.
                  lst_tab-waerk = lst_vbap2-waerk.
                  lv_part = abap_false.
                  CLEAR:lst_vbap2.
                  EXIT.
                ENDIF.

                IF ( lst_vbap2-konda IN lt_kondas ) AND ( lst_vbap2-mvgr5 IN lt_mvgr5s )
                   AND  lst_vbap2-kdkg2 IS NOT INITIAL.
                  lst_tab-model = lc_soc.  "For SOC
                  lst_tab-desc = lv_socdesc.
                  lst_tab-waerk = lst_vbap2-waerk.
                  lv_part = abap_false.
                  CLEAR:lst_vbap2.
                  EXIT.
                ENDIF.

                IF lv_smodel IS INITIAL.
                  lv_part =  abap_true.
                ELSE.
                  lv_part = abap_false.
                  lw_vbak-waerk = lst_vbap2-waerk.
                  CLEAR:lst_vbap2.
                  EXIT.
                ENDIF.
                CLEAR:lst_vbap2.
              ENDLOOP.
              IF  ( lw_vbak-konda IN lt_konda ) AND ( lw_vbak-mvgr5 IN lt_mvgr5 ).
                lst_tab-model = lc_tbt.  "For TBT
                lst_tab-desc = lv_tbtdesc.
                lst_tab-waerk = lw_vbak-waerk.
              ENDIF.
              IF ( lw_vbak-konda IN lt_kondas ) AND ( lw_vbak-mvgr5 IN lt_mvgr5s )
                AND ( lw_vbak-kdkg2 IS NOT INITIAL ).
                lst_tab-model = lc_soc.  "For SOC
                lst_tab-desc = lv_socdesc.
                lst_tab-waerk = lw_vbak-waerk.
              ENDIF.
              IF lst_tab-model IS INITIAL.
                lst_tab-model = lc_others. "For others
                CONTINUE.
              ELSE.
                " Do nothing
              ENDIF.

            ELSE.
              lst_tab-model = lc_others.
              CONTINUE.
            ENDIF.
          ENDIF.

          IF lst_tab-model NE lc_am AND lst_tab-model NE lc_css. " Check for TBT and Society

          ELSEIF  ( lst_tab-model EQ lc_am OR lst_tab-model EQ lc_css ). "Check for AM and CSS

          ENDIF.

          AT END OF vbeln.
            lst_tab-count = 1.
          ENDAT.
          lst_tab-netwr = lw_vbak-netwr.
          SORT li_vbeln BY vbeln.
          READ TABLE li_vbeln TRANSPORTING NO FIELDS WITH KEY vbeln = lw_vbak-vbeln BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lst_tab-count = 0.
          ELSE.
            IF lv_part IS INITIAL.
              lst_tab-count = 1.
            ELSE.
              lst_tab-count = 0.
            ENDIF.
          ENDIF.
          COLLECT lst_tab INTO li_tab.
          lst_tab-vbeln = lw_vbak-vbeln.
          APPEND lst_tab TO li_tabref.
          lst_vbeln1 = lw_vbak-vbeln.
          APPEND lst_vbeln1 TO li_vbeln.
          CLEAR: lv_sflag, lst_tab,lst_vbeln1,lw_vbak.
        ENDLOOP.
        DELETE li_tab WHERE model EQ lc_others.

*----------Get Model based on Sales Model Filter---------*
        IF lir_smodel IS NOT INITIAL.
          DELETE li_tab WHERE model NOT IN lir_smodel.
        ENDIF.

*---------Appending data to final entityset---------*
        LOOP AT li_tab INTO lst_tab.
          lw_entity-model = lst_tab-model.
          lw_entity-waerk = lst_tab-waerk.
          lw_entity-netwr = lst_tab-netwr.
          lw_entity-moddesc = lst_tab-desc.
          lw_entity-count = lst_tab-count.

          APPEND lw_entity TO et_entityset.
          CLEAR :lw_entity,lst_tab.
        ENDLOOP.

        SORT et_entityset BY model waerk.
      ENDIF.
    ENDIF.
*------ Remove model which does not corresponds to Sales Model ------*
    DELETE et_entityset WHERE model IS INITIAL.

    DELETE et_entityset WHERE count LT 1.
    REFRESH: lr_vkorg, lr_konda, lr_mvgr5.
  ENDMETHOD.


  METHOD freightforwarder_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_freightforwarder.

    CONSTANTS: lc_sp TYPE parvw VALUE 'SP'.

*-------------Fetch freight forwarder BP search help entries-------------*
    SELECT DISTINCT v~vbeln, vp~parvw, vp~lifnr, l~name1, l~name2
            INTO TABLE @DATA(li_lfa1)
            FROM vbuv AS v
            INNER JOIN vbpa AS vp ON vp~vbeln = v~vbeln
            INNER JOIN lfa1 AS l ON l~lifnr = vp~lifnr
            WHERE vp~parvw EQ @lc_sp.

    IF sy-subrc EQ 0.
      SORT li_lfa1 BY lifnr.
      DELETE ADJACENT DUPLICATES FROM li_lfa1 COMPARING lifnr.
      IF li_lfa1 IS NOT INITIAL.
        LOOP AT li_lfa1 INTO DATA(lw_lfa1).
          lw_entity-kunsp = lw_lfa1-lifnr.
          lw_entity-name1 = lw_lfa1-name1.
          lw_entity-name2 = lw_lfa1-name2.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lw_lfa1.
        ENDLOOP.
        SORT et_entityset BY kunsp.
      ENDIF.
    ENDIF.

  ENDMETHOD.


METHOD headerset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

  FIELD-SYMBOLS:
    <ls_filter>     LIKE LINE OF it_filter_select_options,
    <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

  TYPES: BEGIN OF ty_sum,
           vbeln TYPE c LENGTH 60,
           mwsbp TYPE mwsbp,
           netwr TYPE netwr,
         END OF ty_sum.

  TYPES: BEGIN OF ty_vbak,
           vbeln    TYPE vbeln,
           posnr    TYPE posnr,
           vkbur    TYPE vkbur,
           konda    TYPE konda,
           mvgr5    TYPE mvgr5,
           kdkg2    TYPE kdkg2,
           tbnam    TYPE tbnam_vb,
           fdnam    TYPE fdnam_vb,
           vkorg    TYPE vkorg,
           auart    TYPE auart,
           erdat    TYPE erdat,
           kunnr    TYPE kunnr,
           bsark    TYPE bsark,
           etenr    TYPE etenr,
           tdid     TYPE tdid,
           matnr    TYPE matnr,
           netwr    TYPE netwr_ap,
           waerk    TYPE waerk,
           zterm    TYPE dzterm,
           fkdat    TYPE fkdat,
           lifnr    TYPE lifnr,
           kunwe    TYPE kunnr,
           parvw    TYPE parvw,
           vbtyp    TYPE string,
           zzvyp    TYPE string,
           zzsubtyp TYPE string,
           nvalue   TYPE string,
           tax      TYPE string,
           zmeng    TYPE string,
           zlsch    TYPE string,
           ernam    TYPE string,
           augru    TYPE string,
           bstnk    TYPE string,
           lifsk    TYPE lifsp,
           faksk    TYPE faksp,
         END OF ty_vbak.

  TYPES: BEGIN OF lty_vbap2,
           vbeln    TYPE vbeln,
           posnr    TYPE posnr,
           mvgr5    TYPE mvgr5,
           kdkg2    TYPE kdkg2,
           konda    TYPE konda,
           nvalue   TYPE netwr,
           zzvyp    TYPE zvyp,
           zzsubtyp TYPE  zsubtyp,
           zmeng    TYPE dzmeng,
           tax      TYPE mwsbp,
           waerk    TYPE waerk,
           matnr    TYPE matnr,
           zterm    TYPE dzterm,
           fkdat    TYPE fkdat,
           zlsch    TYPE schzw_bseg,
         END OF lty_vbap2.

  DATA: li_vbapnew  TYPE TABLE OF lty_vbap2,
        lst_vbapnew TYPE lty_vbap2.

  DATA: li_vbak  TYPE STANDARD TABLE OF ty_vbak,
        lst_vbak TYPE ty_vbak.

  DATA: lv_input         TYPE string,
        lt_filter_string TYPE TABLE OF string,
        lt_sptint        TYPE TABLE OF string,
        lt_key_value     TYPE /iwbep/t_mgw_name_value_pair,
        lv_name          TYPE string,
        lv_opt           TYPE string,
        lv_value         TYPE string,
        lv_sprint        TYPE string,
        lv_csdate        TYPE c LENGTH 10,
        lv_cedate        TYPE c LENGTH 10,
        lv_bsdate        TYPE c LENGTH 10,
        lv_bedate        TYPE c LENGTH 10,
        lv_var1          TYPE string,
        lv_var2          TYPE string,
        lv_erdat2        TYPE  sy-datum.

  DATA: lst_smodel TYPE /iwbep/s_cod_select_option,
        lir_smodel TYPE /iwbep/t_cod_select_options,
        lst_waerk  TYPE  /iwbep/s_cod_select_option,
        lir_waerk  TYPE /iwbep/t_cod_select_options,
        lst_fdnam  TYPE  /iwbep/s_cod_select_option,
        lir_fdnam  TYPE /iwbep/t_cod_select_options,
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
        lst_kunza  TYPE kun_range,
        lir_kunza  TYPE STANDARD TABLE OF kun_range,
        lst_kunsp  TYPE kun_range,
        lir_kunsp  TYPE STANDARD TABLE OF kun_range,
        lst_matnr  TYPE mat_range,
        lir_matnr  TYPE STANDARD TABLE OF mat_range,
        lst_vbeln  TYPE range_vbeln,
        lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
        lst_erdat  TYPE tds_rg_erdat,
        lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
        lst_fkdat  TYPE tds_rg_erdat,
        lir_fkdat  TYPE STANDARD TABLE OF tds_rg_erdat,
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
        lv_rundays  TYPE i,
        lv_pstat    TYPE c,
        lw_entity   TYPE zcl_zqtco_incompleteor_mpc=>ts_header.

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

  CONSTANTS: lc_devid  TYPE c LENGTH 12 VALUE 'R144',
             lc_vkbur  TYPE  rvari_vnam     VALUE 'VKBUR',
             lc_konda  TYPE  rvari_vnam     VALUE 'KONDA',
             lc_mvgr5  TYPE  rvari_vnam     VALUE 'MVGR5',
             lc_kdkg2  TYPE  rvari_vnam     VALUE 'KDKG2',
             lc_vkorg  TYPE  rvari_vnam     VALUE 'VKORG',
             lc_model  TYPE  rvari_vnam     VALUE 'MODEL',
             lc_waerk  TYPE  rvari_vnam     VALUE 'WAERK',
             lc_fdnam  TYPE  rvari_vnam     VALUE 'FDNAM',
             lc_auart  TYPE  rvari_vnam     VALUE 'AUART',
             lc_pstat  TYPE  rvari_vnam     VALUE 'PSTAT',
             lc_zterm  TYPE  rvari_vnam     VALUE 'ZTERM',
             lc_bsark  TYPE  rvari_vnam     VALUE 'BSARK',
             lc_kunnr  TYPE  rvari_vnam     VALUE 'KUNNR',
             lc_kunwe  TYPE  rvari_vnam     VALUE 'KUNWE',
             lc_kunsp  TYPE  rvari_vnam     VALUE 'KUNSP',
             lc_kunza  TYPE  rvari_vnam     VALUE 'KUNZA',
             lc_matnr  TYPE  rvari_vnam     VALUE 'MATNR',
             lc_vbeln  TYPE  rvari_vnam     VALUE 'VBELN',
             lc_erdat  TYPE  rvari_vnam     VALUE 'ERDAT',
             lc_fkdat  TYPE  rvari_vnam     VALUE 'FKDAT',
             lc_days   TYPE  rvari_vnam     VALUE 'RUNDAYS',
             lc_am     TYPE c LENGTH 20 VALUE 'AM',
             lc_css    TYPE c LENGTH 20 VALUE 'CSS',
             lc_tbt    TYPE c LENGTH 20 VALUE 'TBT',
             lc_soc    TYPE c LENGTH 20 VALUE 'SOC',
             lc_a      TYPE c VALUE 'A',
             lc_b      TYPE c VALUE 'B',
             lc_c      TYPE c VALUE 'C',
             lc_m      TYPE c VALUE 'M',
             lc_u      TYPE c VALUE 'U',
             lc_g      TYPE c VALUE 'G',
             lc_n      TYPE c VALUE 'N',
             lc_p      TYPE c VALUE 'P',
             lc_k      TYPE c VALUE 'K',
             lc_l      TYPE c VALUE 'L',
             lc_paid   TYPE c LENGTH 20 VALUE 'Paid',
             lc_unpaid TYPE c LENGTH 20 VALUE 'Not Paid'.

  DATA: lr_vkbur TYPE /iwbep/t_cod_select_options,
        lr_konda TYPE /iwbep/t_cod_select_options,
        lr_mvgr5 TYPE /iwbep/t_cod_select_options,
        lr_kdkg2 TYPE /iwbep/t_cod_select_options,
        lr_vkorg TYPE TABLE OF range_vkorg.

  CONSTANTS: lc_eq       TYPE char2 VALUE 'EQ',
             lc_ge       TYPE char2 VALUE 'GE',
             lc_le       TYPE char2 VALUE 'LE',
             lc_bt       TYPE char2 VALUE 'BT',
             lc_i        TYPE char1 VALUE 'I',
             lc_tdid     TYPE tdid VALUE '0004',
             lc_tdobject TYPE tdobject VALUE 'VBBK',
             lc_posnr    TYPE posnr VALUE '000000',
             lc_ag       TYPE parvw VALUE 'AG',
             lc_we       TYPE parvw VALUE 'WE',
             lc_za       TYPE parvw VALUE 'ZA',
             lc_sp       TYPE parvw VALUE 'SP',
             lc_condgrp  TYPE kdkg2 VALUE '02',
             lc_va02     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
             lc_va42     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN=',
             lc_va12     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
             lc_va22     TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN='.

  DATA: lt_sum TYPE TABLE OF ty_sum,
        lw_sum TYPE ty_sum.

  cl_http_server=>if_http_server~get_location(
     IMPORTING host = lv_host
            port = lv_port ).

*-----------Filters for selection criteria-----------*
  IF iv_filter_string IS NOT INITIAL.
    lv_input = iv_filter_string.
* *— get rid of )( & ‘ and make AND’s uppercase
    REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
    REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
    REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
    REPLACE ALL OCCURRENCES OF ' le ' IN lv_input WITH ' LE '.
    REPLACE ALL OCCURRENCES OF ' ge ' IN lv_input WITH ' GE '.
    REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
    REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
    SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

    LOOP AT lt_filter_string INTO DATA(ls_filter_string).
      APPEND INITIAL LINE TO lt_key_value ASSIGNING FIELD-SYMBOL(<fs_key_value>).
      CONDENSE ls_filter_string.
      SPLIT ls_filter_string AT ' ' INTO lv_name lv_opt lv_value.
      IF lv_value NE 'null'.
        DATA(lv_length) = strlen( lv_value ).
        FREE:lv_length,lv_sprint,lt_sptint.
        lv_length = strlen( lv_value ).
        lv_length  = lv_length - 2.
        lv_sprint = lv_value+1(lv_length).
        SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
        CASE lv_name.
          WHEN lc_model. "Sales/Business Model
            lv_smodel = lv_sprint.
            LOOP AT lt_sptint INTO DATA(lst_sprint).
              lst_smodel-sign = lc_i.
              lst_smodel-option = lv_opt.
              lst_smodel-low = lst_sprint.
              APPEND lst_smodel TO lir_smodel.
              CLEAR: lst_smodel, lst_sprint.
            ENDLOOP.
          WHEN lc_waerk. "Currency
            LOOP AT lt_sptint INTO lst_sprint.
              lst_waerk-sign = lc_i.
              lst_waerk-option = lv_opt.
              lst_waerk-low = lst_sprint.
              APPEND lst_waerk TO lir_waerk.
              CLEAR: lst_waerk, lst_sprint.
            ENDLOOP.
          WHEN lc_fdnam. "IncompletionLog
            LOOP AT lt_sptint INTO lst_sprint.
              lst_fdnam-sign = lc_i.
              lst_fdnam-option = lv_opt.
              lst_fdnam-low = lst_sprint.
              APPEND lst_fdnam TO lir_fdnam.
              CLEAR: lst_fdnam, lst_sprint.
            ENDLOOP.
          WHEN lc_auart. "Order Type
            LOOP AT lt_sptint INTO lst_sprint.
              lst_auart-sign = lc_i.
              lst_auart-option = lv_opt.
              lst_auart-low = lst_sprint.
              APPEND lst_auart TO lir_auart.
              CLEAR: lst_auart, lst_sprint.
            ENDLOOP.
          WHEN lc_vkorg. "Sales Org
            LOOP AT lt_sptint INTO lst_sprint.
              lst_vkorg-sign = lc_i.
              lst_vkorg-option = lv_opt.
              lst_vkorg-low = lst_sprint.
              APPEND lst_vkorg TO lir_vkorg.
              CLEAR: lst_vkorg, lst_sprint.
            ENDLOOP.
          WHEN lc_pstat. "Payment Status
            lv_pstat = lv_sprint.
          WHEN lc_zterm. "Payment terms
            LOOP AT lt_sptint INTO lst_sprint.
              lst_zterm-sign = lc_i.
              lst_zterm-option = lv_opt.
              lst_zterm-low = lst_sprint.
              APPEND lst_zterm TO lir_zterm.
              CLEAR: lst_zterm, lst_sprint.
            ENDLOOP.
          WHEN lc_bsark. "Po Type
            LOOP AT lt_sptint INTO lst_sprint.
              lst_bsark-sign = lc_i.
              lst_bsark-option = lv_opt.
              lst_bsark-low = lst_sprint.
              APPEND lst_bsark TO lir_bsark.
              CLEAR: lst_bsark, lst_sprint.
            ENDLOOP.
          WHEN lc_konda. "Price group
            LOOP AT lt_sptint INTO lst_sprint.
              lst_konda-sign = lc_i.
              lst_konda-option = lv_opt.
              lst_konda-low = lst_sprint.
              APPEND lst_konda TO lir_konda.
              CLEAR: lst_konda, lst_sprint.
            ENDLOOP.
          WHEN lc_kunnr. "Soldto BP
            LOOP AT lt_sptint INTO lst_sprint.
              lst_kunnr-sign = lc_i.
              lst_kunnr-option = lv_opt.
              lst_kunnr-kunnr_low = lst_sprint.
              APPEND lst_kunnr TO lir_kunnr.
              CLEAR: lst_kunnr, lst_sprint.
            ENDLOOP.
          WHEN lc_kunwe. "Shipto BP
            LOOP AT lt_sptint INTO lst_sprint.
              lst_kunwe-sign = lc_i.
              lst_kunwe-option = lv_opt.
              lst_kunwe-kunnr_low = lst_sprint.
              APPEND lst_kunwe TO lir_kunwe.
              CLEAR: lst_kunwe, lst_sprint.
            ENDLOOP.
          WHEN lc_kunsp. "Freight Forwarder BP
            LOOP AT lt_sptint INTO lst_sprint.
              lst_kunsp-sign = lc_i.
              lst_kunsp-option = lv_opt.
              lst_kunsp-kunnr_low = lst_sprint.
              APPEND lst_kunsp TO lir_kunsp.
              CLEAR: lst_kunsp, lst_sprint.
            ENDLOOP.
          WHEN lc_kunza. "Society BP
            LOOP AT lt_sptint INTO lst_sprint.
              lst_kunza-sign = lc_i.
              lst_kunza-option = lv_opt.
              lst_kunza-kunnr_low = lst_sprint.
              APPEND lst_kunza TO lir_kunza.
              CLEAR: lst_kunza, lst_sprint.
            ENDLOOP.
          WHEN lc_matnr. "Material
            LOOP AT lt_sptint INTO lst_sprint.
              lst_matnr-sign = lc_i.
              lst_matnr-option = lv_opt.
              lst_matnr-matnr_low = lst_sprint.
              APPEND lst_matnr TO lir_matnr.
              CLEAR: lst_matnr, lst_sprint.
            ENDLOOP.
          WHEN lc_mvgr5. "Material Group5
            LOOP AT lt_sptint INTO lst_sprint.
              lst_mvgr5-sign = lc_i.
              lst_mvgr5-option = lv_opt.
              lst_mvgr5-low = lst_sprint.
              APPEND lst_mvgr5 TO lir_mvgr5.
              CLEAR: lst_mvgr5, lst_sprint.
            ENDLOOP.
          WHEN lc_vbeln. "Order
            LOOP AT lt_sptint INTO lst_sprint.
              lst_vbeln-sign = lc_i.
              lst_vbeln-option = lv_opt.
              lst_vbeln-low = lst_sprint.
              APPEND lst_vbeln TO lir_vbeln.
              CLEAR: lst_vbeln, lst_sprint.
            ENDLOOP.
          WHEN lc_erdat. "Created Date
            CLEAR:lv_length, lv_sprint, lv_csdate, lv_cedate, lv_var1, lv_var2.
            lv_length = strlen( lv_value ).
            lv_length  = lv_length - 2.
            lv_sprint = lv_value+1(lv_length).
            SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
            CONDENSE lv_sprint NO-GAPS.
            CONCATENATE lv_var1+6(4)
                        lv_var1+3(2)
                        lv_var1+0(2)
                        INTO lv_csdate.
            CONCATENATE lv_var2+6(4)
                        lv_var2+3(2)
                        lv_var2+0(2)
                        INTO lv_cedate.
            lst_erdat-low = lv_csdate.
            lst_erdat-sign = lc_i.
            lst_erdat-option = lc_bt.
            lst_erdat-high = lv_cedate.
            APPEND lst_erdat TO lir_erdat.
            CLEAR lst_erdat.
          WHEN lc_fkdat. "Billing Date
            CLEAR:lv_length, lv_sprint, lv_bsdate, lv_bedate, lv_var1, lv_var2.
            lv_length = strlen( lv_value ).
            lv_length  = lv_length - 2.
            lv_sprint = lv_value+1(lv_length).
            SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
            CONDENSE lv_sprint NO-GAPS.
            CONCATENATE lv_var1+6(4)
                        lv_var1+3(2)
                        lv_var1+0(2)
                        INTO lv_bsdate.
            CONCATENATE lv_var2+6(4)
                        lv_var2+3(2)
                        lv_var2+0(2)
                        INTO lv_bedate.
            lst_fkdat-low = lv_bsdate.
            lst_fkdat-sign = lc_i.
            lst_fkdat-option = lc_bt.
            lst_fkdat-high = lv_bedate.
            APPEND lst_fkdat TO lir_fkdat.
            CLEAR lst_fkdat.
            CLEAR: lst_sprint.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDIF.
*------------------- Fetch constant table entries --------------*
  IF lir_smodel IS NOT INITIAL AND lir_waerk IS NOT INITIAL.

    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
           WHERE devid = @lc_devid AND activate = @abap_true.

*------------------- Fetch model based data --------------*
    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).
      CLEAR:lst_smodel.
      LOOP AT lir_smodel INTO lst_smodel.
        IF <lw_const>-param2 = lst_smodel-low.
          IF <lw_const>-param1 = lc_vkbur.
            APPEND INITIAL LINE TO lr_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
            <lst_vkbur_i>-sign   = <lw_const>-sign.
            <lst_vkbur_i>-option = <lw_const>-opti.
            <lst_vkbur_i>-low    = <lw_const>-low.
            <lst_vkbur_i>-high   = <lw_const>-high.
          ENDIF.

          IF <lw_const>-param1 = lc_konda.
            APPEND INITIAL LINE TO lr_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
            <lst_konda_i>-sign   = <lw_const>-sign.
            <lst_konda_i>-option = <lw_const>-opti.
            <lst_konda_i>-low    = <lw_const>-low.
            <lst_konda_i>-high   = <lw_const>-high.
          ENDIF.

          IF  <lw_const>-param1 = lc_mvgr5.
            APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
            <lst_mvgr5_i>-sign   = <lw_const>-sign.
            <lst_mvgr5_i>-option = <lw_const>-opti.
            <lst_mvgr5_i>-low    = <lw_const>-low.
            <lst_mvgr5_i>-high   = <lw_const>-high.
          ENDIF.
        ENDIF.
        CLEAR: lst_smodel.
      ENDLOOP.
*-----------get date range from constant table if created date filter not provided------*
      IF lir_erdat IS INITIAL AND <lw_const>-param1 = lc_days.
        CONDENSE <lw_const>-low NO-GAPS.
        lv_rundays = <lw_const>-low.
      ENDIF.

      IF  lir_vkorg IS INITIAL AND <lw_const>-param1 = lc_vkorg.
        APPEND INITIAL LINE TO lr_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
        <lst_vkorg_i>-sign   = <lw_const>-sign.
        <lst_vkorg_i>-option = <lw_const>-opti.
        <lst_vkorg_i>-low    = <lw_const>-low.
        <lst_vkorg_i>-high   = <lw_const>-high.
      ENDIF.
      CLEAR: <lw_const>.
    ENDLOOP.

*------If Front-end filter is initial then will pass entries from constant table----*
    IF lir_vkorg IS INITIAL.
      lir_vkorg = lr_vkorg.
    ENDIF.
    IF lir_konda IS INITIAL.
      lir_konda = lr_konda.
    ENDIF.
    IF lir_mvgr5 IS INITIAL.
      lir_mvgr5 = lr_mvgr5.
    ENDIF.

*-----------------Fetch Incomplete Order Header data-------------------------------*
    IF lv_smodel = lc_soc.  " If Model is Society
      SELECT v~vbeln, vb~posnr, v~vkbur, vb~tbnam, vb~fdnam, v~vkorg, v~vbtyp, v~waerk
              , v~auart, v~erdat, v~ernam, v~bstnk, v~kunnr, v~augru, v~bsark,
              v~faksk, v~lifsk, vb~etenr, vb~tdid
             INTO TABLE @DATA(li_vbuvvbak)
             FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
             WHERE ( v~vkbur IN @lr_vkbur ) AND ( v~bsark IN @lir_bsark )
             AND ( v~kunnr IN @lir_kunnr ) AND ( v~vbeln IN @lir_vbeln )
             AND v~auart IN @lir_auart AND ( v~vkorg IN @lir_vkorg )
             AND v~erdat IN @lir_erdat AND ( v~waerk IN @lir_waerk ) .
      IF sy-subrc EQ 0.
        SORT li_vbuvvbak BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM li_vbuvvbak COMPARING vbeln posnr.
        IF li_vbuvvbak IS NOT INITIAL.
          SELECT vp~vbeln, vp~posnr, vp~mvgr5, vk~kdkg2, vk~konda, vp~netwr AS nvalue, vp~zzvyp,
            vp~zzsubtyp, vp~zmeng, vp~mwsbp AS tax,  vp~waerk, vp~matnr,
            vk~zterm, vk~fkdat, vk~zlsch
            INTO TABLE @DATA(li_vbap)
            FROM vbap AS vp INNER JOIN vbkd AS vk ON vp~vbeln = vk~vbeln "AND vp~posnr = vk~posnr
            FOR ALL ENTRIES IN @li_vbuvvbak
            WHERE vp~vbeln EQ @li_vbuvvbak-vbeln AND vp~posnr EQ @li_vbuvvbak-posnr AND
            vk~zterm IN @lir_zterm AND vp~matnr IN @lir_matnr "AND vk~fkdat IN @lir_fkdat
            AND vp~waerk IN @lir_waerk AND ( vk~kdkg2 NE ' ' ).
          IF sy-subrc EQ 0.
            SORT li_vbap BY vbeln posnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.  "If Model is TBT/AM/CSS
      SELECT v~vbeln, vb~posnr, v~vkbur, vb~tbnam, vb~fdnam, v~vkorg, v~vbtyp, v~waerk
        , v~auart, v~erdat, v~ernam, v~bstnk, v~kunnr, v~augru, v~bsark,
        v~faksk, v~lifsk, vb~etenr, vb~tdid
       INTO TABLE @li_vbuvvbak
       FROM vbak AS v INNER JOIN vbuv AS vb ON  v~vbeln = vb~vbeln
       WHERE ( v~vkbur IN @lr_vkbur ) AND ( v~bsark IN @lir_bsark )
       AND ( v~kunnr IN @lir_kunnr ) AND ( v~vbeln IN @lir_vbeln )
       AND v~auart IN @lir_auart AND ( v~vkorg IN @lir_vkorg )
       AND v~erdat IN @lir_erdat AND ( v~waerk IN @lir_waerk ).
      IF sy-subrc EQ 0.
        SORT li_vbuvvbak BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM li_vbuvvbak COMPARING vbeln posnr.
        IF li_vbuvvbak IS NOT INITIAL.
          SELECT vp~vbeln, vp~posnr, vp~mvgr5, vk~kdkg2, vk~konda, vp~netwr AS nvalue, vp~zzvyp,
            vp~zzsubtyp, vp~zmeng, vp~mwsbp AS tax,  vp~waerk, vp~matnr,
            vk~zterm, vk~fkdat, vk~zlsch
            INTO TABLE @li_vbap
            FROM vbap AS vp INNER JOIN vbkd AS vk ON vp~vbeln = vk~vbeln "AND vp~posnr = vk~posnr
            FOR ALL ENTRIES IN @li_vbuvvbak
            WHERE vp~vbeln EQ @li_vbuvvbak-vbeln AND vp~posnr EQ @li_vbuvvbak-posnr AND
            vk~zterm IN @lir_zterm AND vp~matnr IN @lir_matnr "AND vk~fkdat IN @lir_fkdat
            AND vp~waerk IN @lir_waerk.
          IF sy-subrc EQ 0.
            SORT li_vbap BY vbeln posnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*---------------- Consolidating data into li_vbak -------------*
    IF li_vbuvvbak IS NOT INITIAL.
      LOOP AT li_vbuvvbak INTO DATA(lst_vbuvvbak).
        READ TABLE li_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_vbuvvbak-vbeln
              posnr = lst_vbuvvbak-posnr BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_vbak-mvgr5 = lst_vbap-mvgr5.
          lst_vbak-kdkg2 = lst_vbap-kdkg2.
          lst_vbak-konda = lst_vbap-konda.
          lst_vbak-nvalue = lst_vbap-nvalue.
          lst_vbak-waerk = lst_vbap-waerk.
          lst_vbak-matnr = lst_vbap-matnr.
          lst_vbak-zterm = lst_vbap-zterm.
          lst_vbak-fkdat = lst_vbap-fkdat.
          lst_vbak-tax = lst_vbap-tax.
          lst_vbak-zzsubtyp = lst_vbap-zzsubtyp.
          lst_vbak-zzvyp = lst_vbap-zzvyp.
          lst_vbak-zlsch = lst_vbap-zlsch.
        ENDIF.
        lst_vbak-vbeln = lst_vbuvvbak-vbeln.
        lst_vbak-posnr = lst_vbuvvbak-posnr.
        lst_vbak-vkbur = lst_vbuvvbak-vkbur.
        lst_vbak-tbnam = lst_vbuvvbak-tbnam.
        lst_vbak-fdnam = lst_vbuvvbak-fdnam.
        lst_vbak-vkorg = lst_vbuvvbak-vkorg.
        lst_vbak-auart = lst_vbuvvbak-auart.
        lst_vbak-erdat = lst_vbuvvbak-erdat.
        lst_vbak-kunnr = lst_vbuvvbak-kunnr.
        lst_vbak-bsark = lst_vbuvvbak-bsark.
        lst_vbak-etenr = lst_vbuvvbak-etenr.
        lst_vbak-tdid  = lst_vbuvvbak-tdid.
        lst_vbak-faksk = lst_vbuvvbak-faksk.
        lst_vbak-lifsk = lst_vbuvvbak-lifsk.
        lst_vbak-vbtyp = lst_vbuvvbak-vbtyp.
        lst_vbak-bstnk  = lst_vbuvvbak-bstnk.
        lst_vbak-ernam = lst_vbuvvbak-ernam.
        lst_vbak-augru = lst_vbuvvbak-augru.
        APPEND lst_vbak TO li_vbak.
        CLEAR: lst_vbak, lst_vbap, lst_vbuvvbak.
      ENDLOOP.

*----------To filter data based on Billing date -------*
      IF lir_fkdat IS NOT INITIAL.
        DELETE li_vbak WHERE fkdat NOT IN lir_fkdat.
      ENDIF.
*------If Front-end filter is initial then will pass entries from constant table----*
      DATA(li_waerk) = li_vbak.
      SORT li_waerk BY vbeln.

      IF li_waerk IS NOT INITIAL.
************
        SELECT vbeln, posnr, mvgr5, netwr AS nvalue, zzvyp,
          zzsubtyp, zmeng, mwsbp AS tax,  waerk, matnr
          INTO TABLE @DATA(li_vbapnew1)
          FROM vbap
          FOR ALL ENTRIES IN @li_waerk
          WHERE vbeln EQ @li_waerk-vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbapnew1 BY vbeln posnr..
        ENDIF.

        SELECT vbeln, posnr, kdkg2, konda,
         zterm, fkdat, zlsch
         INTO TABLE @DATA(li_vbkdnew)
         FROM  vbkd
         FOR ALL ENTRIES IN @li_waerk
         WHERE vbeln EQ @li_waerk-vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbkdnew BY vbeln posnr..
        ENDIF.

        LOOP AT li_vbapnew1 INTO DATA(lst_vbapnew1).
          MOVE-CORRESPONDING lst_vbapnew1 TO lst_vbapnew.
          lst_vbapnew-tax = lst_vbapnew1-tax.
          lst_vbapnew-nvalue = lst_vbapnew1-nvalue.

          READ TABLE li_vbkdnew INTO DATA(lst_vbkdnew) WITH KEY vbeln = lst_vbapnew1-vbeln
                                                           posnr = lst_vbapnew1-posnr BINARY SEARCH.
          IF sy-subrc EQ 0.
            MOVE-CORRESPONDING lst_vbkdnew TO lst_vbapnew.
          ELSE.
            CLEAR:lst_vbkdnew.
            READ TABLE li_vbkdnew INTO lst_vbkdnew WITH KEY vbeln = lst_vbapnew1-vbeln
                                                             posnr = lc_posnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_vbkdnew TO lst_vbapnew.
            ENDIF.
          ENDIF.

          APPEND lst_vbapnew TO li_vbapnew.
          CLEAR:lst_vbapnew,lst_vbkdnew,lst_vbapnew1.
        ENDLOOP.

        IF li_vbapnew[] IS NOT INITIAL.
          SORT li_vbapnew[] BY vbeln posnr.
          DATA(li_vbap2) = li_vbapnew.
          SORT li_vbap2 BY vbeln posnr..
        ENDIF.
*************
*        SELECT vp~vbeln, vp~posnr, vp~mvgr5, vk~kdkg2, vk~konda, vp~netwr AS nvalue, vp~zzvyp,
*          vp~zzsubtyp, vp~zmeng, vp~mwsbp AS tax,  vp~waerk, vp~matnr,
*          vk~zterm, vk~fkdat, vk~zlsch
*          INTO TABLE @DATA(li_vbap2)
*          FROM vbap AS vp INNER JOIN vbkd AS vk ON vp~vbeln = vk~vbeln "AND vp~posnr = vk~posnr
*          FOR ALL ENTRIES IN @li_waerk
*          WHERE vp~vbeln EQ @li_waerk-vbeln.
*        IF sy-subrc EQ 0.
*          SORT li_vbap2 BY vbeln posnr..
*        ENDIF.
      ENDIF.
*------------- For BP filters -------------*
      DATA(li_vbak2) = li_vbak.
      IF li_vbak IS NOT INITIAL.
*------------------ Get Partner details -------------------------*
        SELECT vpa~vbeln, vpa~posnr, vpa~parvw, vpa~kunnr, vpa~adrnr, vpa~lifnr,
               ad~name1, ad~addrnumber, ad~street,
               ad~city1, ad~region, ad~post_code1, ad~country
               INTO TABLE @DATA(li_vbpa)
               FROM vbpa AS vpa
               INNER JOIN adrc AS ad ON ad~addrnumber = vpa~adrnr
               FOR ALL ENTRIES IN @li_vbak
               WHERE vpa~vbeln EQ @li_vbak-vbeln
               AND vpa~posnr EQ @lc_posnr.
        IF sy-subrc EQ 0.
          SORT li_vbpa BY vbeln posnr parvw.
          DATA(li_vbakkp) = li_vbpa.
          SORT li_vbakkp BY vbeln parvw.
        ENDIF.
      ENDIF.


      DELETE ADJACENT DUPLICATES FROM li_vbak2 COMPARING vbeln.


      DATA:lv_part(1) TYPE c.
      DATA:lv_mat(1) TYPE c.
      DATA:lv_zterm(1) TYPE c.
      SORT:lir_kunnr BY kunnr_low.
      SORT:lir_kunwe BY kunnr_low.
      SORT:lir_kunza BY kunnr_low.
      SORT:lir_kunsp BY kunnr_low.

*--------- Validations on BP filters-------------*
      LOOP AT li_vbak2 ASSIGNING FIELD-SYMBOL(<lst_vbak2>).
        lv_part = abap_true.
        IF lir_kunnr IS NOT INITIAL.    " If Filter on Sold to BP
          READ TABLE li_vbakkp INTO DATA(lst_vkpa) WITH KEY vbeln = <lst_vbak2>-vbeln
                                                           parvw = lc_ag
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunnr TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpa-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.
        ENDIF.

        IF lir_kunwe IS NOT INITIAL.    " If Filter on Ship to BP
          CLEAR:lst_vkpa.
          READ TABLE li_vbakkp INTO lst_vkpa WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_we
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunwe TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpa-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

        IF lir_kunza IS NOT INITIAL.    " If Filter on Society BP
          CLEAR:lst_vkpa.
          READ TABLE li_vbakkp INTO lst_vkpa WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_za
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunza TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpa-kunnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

        IF lir_kunsp IS NOT INITIAL.    " If Filter on FF
          CLEAR:lst_vkpa.
          READ TABLE li_vbakkp INTO lst_vkpa WITH KEY vbeln = <lst_vbak2>-vbeln
                                                         parvw = lc_sp
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lir_kunsp TRANSPORTING NO FIELDS WITH KEY kunnr_low = lst_vkpa-lifnr BINARY SEARCH.

            IF sy-subrc NE 0.
              lv_part = abap_false.
              <lst_vbak2>-vbeln = abap_true.
            ENDIF.
          ELSE.
            lv_part = abap_false.
            <lst_vbak2>-vbeln = abap_true.
          ENDIF.

        ENDIF.

*--------- Validations on Input filter Material and Payment terms -------------*
        LOOP AT li_vbap2 INTO DATA(lst_vbapf) WHERE vbeln = <lst_vbak2>-vbeln.

          IF lir_matnr IS NOT INITIAL.
            IF lst_vbapf-matnr IN lir_matnr.
              lv_mat = abap_false.
              EXIT.
            ELSE.
              lv_mat = abap_true.
            ENDIF.
          ENDIF.

          IF lir_zterm IS NOT INITIAL.
            IF lst_vbapf-zterm IN lir_zterm.
              lv_zterm = abap_false.
              EXIT.
            ELSE.
              lv_zterm = abap_true.
            ENDIF.
          ENDIF.

          CLEAR:lst_vbapf.
        ENDLOOP.

        IF lv_mat IS NOT INITIAL.
          <lst_vbak2>-vbeln = abap_true.
          CLEAR:lv_mat.
        ENDIF.

        IF lv_zterm IS NOT INITIAL.
          <lst_vbak2>-vbeln = abap_true.
          CLEAR:lv_zterm.
        ENDIF.

      ENDLOOP.

      DELETE li_vbak2 WHERE vbeln = abap_true.
      SORT li_vbak BY vbeln posnr.
      SORT li_vbak2 BY vbeln .
      DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING vbeln posnr.
*-------------If incompletion log filter is provided -------------*
      IF lir_fdnam IS NOT INITIAL.
        DELETE li_vbak WHERE fdnam NOT IN lir_fdnam.
      ENDIF.
*-------------If payment status filter is provided -------------*
      IF li_vbak IS NOT INITIAL.
        IF  lv_pstat NE lc_a AND lv_pstat NE lc_u.
          SELECT vbelv, vbtyp_n FROM vbfa INTO TABLE @DATA(li_vbfa) FOR ALL ENTRIES IN @li_vbak
                     WHERE vbelv EQ @li_vbak-vbeln.
          IF sy-subrc EQ 0.
            DELETE li_vbfa WHERE vbtyp_n NE lc_m.
            SORT li_vbfa BY vbelv.
          ENDIF.
        ENDIF.
      ENDIF.
*----------------------- Calculate net value and tax value --------------------*
      IF li_vbak IS NOT INITIAL.
        LOOP AT li_vbak INTO DATA(lw_vbak).
          lw_sum-vbeln = lw_vbak-vbeln.
          lw_sum-netwr = lw_vbak-nvalue.
          lw_sum-mwsbp  = lw_vbak-tax.
          COLLECT lw_sum INTO lt_sum.
          CLEAR: lw_vbak.
        ENDLOOP.

        IF sy-subrc EQ 0.
          SORT li_vbak BY vbeln.
        ENDIF.
*-------------------- Get Delivery block description -------------------*
        SELECT lifsp, vtext FROM tvlst
           INTO TABLE @DATA(li_tvlst)
           FOR ALL ENTRIES IN @li_vbak
           WHERE lifsp EQ @li_vbak-lifsk AND spras EQ @sy-langu.
        IF sy-subrc EQ 0.
          SORT li_tvlst BY lifsp.
        ENDIF.
*---------------- Get billing block description -----------------*
        SELECT faksp, vtext FROM tvfst
          INTO TABLE @DATA(li_tvfst)
          FOR ALL ENTRIES IN @li_vbak
          WHERE faksp EQ @li_vbak-faksk AND spras EQ @sy-langu.
        IF sy-subrc EQ 0.
          SORT li_tvfst BY faksp.
        ENDIF.
*-----------------Get Overall status --------------------------*
        SELECT vbeln, gbstk FROM vbuk
         INTO TABLE @DATA(li_vbuk)
         FOR ALL ENTRIES IN @li_vbak
         WHERE vbeln EQ @li_vbak-vbeln.
        IF sy-subrc EQ 0.
          SORT li_vbuk BY vbeln.
          DELETE ADJACENT DUPLICATES FROM li_vbuk COMPARING vbeln.
        ENDIF.
*-----------------Get Address Details --------------------------*
        IF li_vbpa IS NOT INITIAL.
          SORT li_vbpa BY vbeln posnr parvw.
          DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING vbeln posnr parvw.

          SELECT addrnumber, smtp_addr
                 FROM adr6
                INTO TABLE @DATA(li_adr6)
                FOR ALL ENTRIES IN @li_vbpa
                WHERE addrnumber EQ @li_vbpa-adrnr.
          IF sy-subrc EQ 0.
            SORT li_adr6 BY addrnumber.
          ENDIF.
        ENDIF.
        SORT lir_mvgr5 BY low.
        SORT lir_konda BY low.


*-------------Get final data into entityset -------------*
        SORT li_vbak2 BY vbeln.
        CLEAR:lv_part.
        LOOP AT li_vbak INTO lw_vbak.
          CLEAR: lv_part.
*------ Append data based on BP filters ------*
          READ TABLE li_vbak2 INTO DATA(lst_vkp) WITH KEY vbeln = lw_vbak-vbeln BINARY SEARCH.
          IF sy-subrc NE 0.
            CONTINUE.
          ENDIF.
*------ If only header data contains incompletion log, consider item data ------*
          IF lw_vbak-waerk IS INITIAL.
            LOOP AT li_vbap2 INTO DATA(lst_vbap2) WHERE vbeln = lw_vbak-vbeln.
              IF lv_smodel NE lc_am AND lv_smodel NE lc_css.
                IF lir_mvgr5 IS NOT INITIAL. "If Filter on Material Group5
                  CLEAR: lst_mvgr5.
                  READ TABLE lir_mvgr5 INTO lst_mvgr5 WITH KEY low = lst_vbap2-mvgr5 BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF lir_konda IS NOT INITIAL. "If Filter on Price Group
                  CLEAR: lst_konda.
                  READ TABLE lir_konda INTO lst_konda WITH KEY  low = lst_vbap2-konda BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF lv_smodel EQ 'SOC'.
                  IF lst_vbap2-kdkg2 IS INITIAL.
                    lv_part = abap_true.
                    CONTINUE.
                  ELSE.
                    lv_part = abap_false.
                    lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
                    IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                      lw_entity-konda = lst_vbap2-konda.
                    ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                      lw_entity-konda = lw_vbak-konda.
                    ENDIF.
                    IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                      lw_entity-zlsch = lst_vbap2-zlsch.
                    ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                      lw_entity-zlsch = lw_vbak-zlsch.
                    ENDIF.
                    IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                      lw_entity-zterm = lst_vbap2-zterm.
                    ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                      lw_entity-zterm = lw_vbak-zterm.
                    ENDIF.

                    EXIT.
                  ENDIF.
                ELSE.
                  lv_part = abap_false.
                  lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
                  IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                    lw_entity-konda = lst_vbap2-konda.
                  ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                    lw_entity-konda = lw_vbak-konda.
                  ENDIF.
                  IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                    lw_entity-zlsch = lst_vbap2-zlsch.
                  ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                    lw_entity-zlsch = lw_vbak-zlsch.
                  ENDIF.
                  IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                    lw_entity-zterm = lst_vbap2-zterm.
                  ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                    lw_entity-zterm = lw_vbak-zterm.
                  ENDIF.

                  EXIT.
                ENDIF.
              ELSE.
                IF ( lr_mvgr5 IS INITIAL ). "If Filter on Material Group5
                  IF lir_mvgr5 IS NOT INITIAL.
                    CLEAR: lst_mvgr5.
                    READ TABLE lir_mvgr5 INTO lst_mvgr5 WITH KEY low = lst_vbap2-mvgr5 BINARY SEARCH.
                    IF sy-subrc NE 0.
                      CONTINUE.
                    ENDIF.
                  ENDIF.
                ENDIF.
                IF ( lr_konda IS INITIAL ). "If Filter on Price Group
                  IF lir_konda IS NOT INITIAL.
                    CLEAR: lst_konda.
                    READ TABLE lir_konda INTO lst_konda WITH KEY  low = lst_vbap2-konda BINARY SEARCH.
                    IF sy-subrc NE 0.
                      CONTINUE.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.

              lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
              IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                lw_entity-konda = lst_vbap2-konda.
              ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                lw_entity-konda = lw_vbak-konda.
              ENDIF.
              IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                lw_entity-zlsch = lst_vbap2-zlsch.
              ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                lw_entity-zlsch = lw_vbak-zlsch.
              ENDIF.
              IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                lw_entity-zterm = lst_vbap2-zterm.
              ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                lw_entity-zterm = lw_vbak-zterm.
              ENDIF.

            ENDLOOP.
          ELSE.      " WAERK IS NOT INITIAL

            IF lv_smodel NE lc_am AND lv_smodel NE lc_css. "Check for SOC and TBT
              CLEAR:lst_vbap2.
              LOOP AT li_vbap2 INTO lst_vbap2 WHERE vbeln EQ lw_vbak-vbeln.
                IF lir_mvgr5 IS NOT INITIAL. "If Filter on Material Group5
                  CLEAR: lst_mvgr5.
                  READ TABLE lir_mvgr5 INTO lst_mvgr5 WITH KEY low = lst_vbap2-mvgr5 BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF lir_konda IS NOT INITIAL. "If Filter on Price Group
                  CLEAR: lst_konda.
                  READ TABLE lir_konda INTO lst_konda WITH KEY  low = lst_vbap2-konda BINARY SEARCH.
                  IF sy-subrc NE 0.
                    lv_part = abap_true.
                    CONTINUE.
                  ENDIF.
                ENDIF.
                IF lv_smodel EQ 'SOC'.
                  IF lst_vbap2-kdkg2 IS INITIAL.
                    lv_part = abap_true.
                    CONTINUE.
                  ELSE.
                    lv_part = abap_false.
                    lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
                    IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                      lw_entity-konda = lst_vbap2-konda.
                    ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                      lw_entity-konda = lw_vbak-konda.
                    ENDIF.

                    IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                      lw_entity-zlsch = lst_vbap2-zlsch.
                    ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                      lw_entity-zlsch = lw_vbak-zlsch.
                    ENDIF.
                    IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                      lw_entity-zterm = lst_vbap2-zterm.
                    ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                      lw_entity-zterm = lw_vbak-zterm.
                    ENDIF.

                    EXIT.
                  ENDIF.
                ELSE.
                  lv_part = abap_false.
                  lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
                  IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                    lw_entity-konda = lst_vbap2-konda.
                  ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                    lw_entity-konda = lw_vbak-konda.
                  ENDIF.

                  IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                    lw_entity-zlsch = lst_vbap2-zlsch.
                  ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                    lw_entity-zlsch = lw_vbak-zlsch.
                  ENDIF.
                  IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                    lw_entity-zterm = lst_vbap2-zterm.
                  ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                    lw_entity-zterm = lw_vbak-zterm.
                  ENDIF.

                  EXIT.
                ENDIF.
              ENDLOOP.

            ELSEIF ( lv_smodel EQ lc_am OR lv_smodel EQ lc_css ). "Check for AM and CSS
              CLEAR:lst_vbap2.
              LOOP AT li_vbap2 INTO lst_vbap2 WHERE vbeln EQ lw_vbak-vbeln.

                IF ( lr_mvgr5 IS INITIAL ). "If Filter on Material Group5
                  IF lir_mvgr5 IS NOT INITIAL.
                    CLEAR: lst_mvgr5.
                    READ TABLE lir_mvgr5 INTO lst_mvgr5 WITH KEY low = lst_vbap2-mvgr5 BINARY SEARCH.
                    IF sy-subrc NE 0.
                      lv_part = abap_true.
                      CONTINUE.
                    ENDIF.
                  ENDIF.
                ENDIF.

                IF ( lr_konda IS INITIAL ). "If Filter on Price Group
                  IF lir_konda IS NOT INITIAL.
                    CLEAR: lst_konda.
                    READ TABLE lir_konda INTO lst_konda WITH KEY  low = lst_vbap2-konda BINARY SEARCH.
                    IF sy-subrc NE 0.
                      lv_part = abap_true.
                      CONTINUE.
                    ENDIF.
                  ENDIF.
                ENDIF.

                lv_part = abap_false.
                lw_vbak-waerk = lst_vbap2-waerk.
*------- Append Price group, payment method and payment term data --------*
                IF  lst_vbap2-konda IS NOT INITIAL AND lw_entity-konda IS INITIAL.
                  lw_entity-konda = lst_vbap2-konda.
                ELSEIF lw_vbak-konda IS NOT INITIAL AND  lw_entity-konda IS INITIAL.
                  lw_entity-konda = lw_vbak-konda.
                ENDIF.
                IF  lst_vbap2-zlsch IS NOT INITIAL AND lw_entity-zlsch IS INITIAL.
                  lw_entity-zlsch = lst_vbap2-zlsch.
                ELSEIF lw_vbak-zlsch IS NOT INITIAL AND  lw_entity-zlsch IS INITIAL.
                  lw_entity-zlsch = lw_vbak-zlsch.
                ENDIF.
                IF  lst_vbap2-zterm IS NOT INITIAL AND lw_entity-zterm IS INITIAL.
                  lw_entity-zterm = lst_vbap2-zterm.
                ELSEIF lw_vbak-zterm IS NOT INITIAL AND  lw_entity-zterm IS INITIAL.
                  lw_entity-zterm = lw_vbak-zterm.
                ENDIF.

                CLEAR:lst_vbap2.
                EXIT.
              ENDLOOP.

            ENDIF.

          ENDIF.
          IF lv_part IS NOT INITIAL.
            CLEAR:lw_entity,lw_vbak.
            CONTINUE.
          ENDIF.
          lw_entity-vbeln = lw_vbak-vbeln.
          lw_entity-model = lv_smodel.
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
            WHEN lc_a.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va12 lw_vbak-vbeln INTO lw_entity-link.
            WHEN lc_b.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va22 lw_vbak-vbeln INTO lw_entity-link.
            WHEN lc_c.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lw_vbak-vbeln INTO lw_entity-link.
            WHEN lc_g.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va42 lw_vbak-vbeln INTO lw_entity-link.
            WHEN lc_k.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lw_vbak-vbeln INTO lw_entity-link.
            WHEN lc_l.
              CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lw_vbak-vbeln INTO lw_entity-link.
            WHEN OTHERS.
              "Do nothing.
          ENDCASE.
          READ TABLE lt_sum INTO lw_sum WITH KEY vbeln = lw_vbak-vbeln.
          IF sy-subrc EQ 0.
            lw_entity-netwr = lw_sum-netwr.
            lw_entity-mwsbp = lw_sum-mwsbp.
          ENDIF.
          READ TABLE li_vbfa INTO DATA(lw_vbfa) WITH KEY vbelv = lw_vbak-vbeln BINARY SEARCH.
          IF sy-subrc EQ 0.
            lw_entity-pstat = lc_paid.
            CLEAR:lw_vbfa.
          ELSE.
            lw_entity-pstat = lc_unpaid.
            CLEAR:lw_vbfa.
          ENDIF.

          READ TABLE li_tvfst INTO DATA(lw_tvfst) WITH KEY faksp = lw_vbak-faksk.
          IF sy-subrc EQ 0.
            lw_entity-fakskt = lw_tvfst-vtext.
          ENDIF.
          READ TABLE li_tvlst INTO DATA(lw_tvlst) WITH KEY lifsp = lw_vbak-lifsk.
          IF sy-subrc EQ 0.
            lw_entity-lifskt = lw_tvlst-vtext.
          ENDIF.
          READ TABLE li_vbuk INTO DATA(lw_vbuk) WITH KEY vbeln = lw_vbak-vbeln.
          IF sy-subrc EQ 0.
            lw_entity-gbstk = lw_vbuk-gbstk.
          ENDIF.
          READ TABLE li_vbpa INTO DATA(lw_vbpa) WITH KEY vbeln = lw_vbak-vbeln parvw = lc_ag.
          IF sy-subrc EQ 0.
            lw_entity-kunnr   = lw_vbpa-kunnr.
            lw_entity-name   = lw_vbpa-name1.
            lw_entity-agaddr = lw_vbpa-addrnumber.
            lw_entity-agstreet = lw_vbpa-street.
            lw_entity-agcity   = lw_vbpa-city1.
            lw_entity-agstate  = lw_vbpa-region.
            lw_entity-agpostal = lw_vbpa-post_code1.
            lw_entity-agcountry = lw_vbpa-country.
            READ TABLE li_adr6 INTO DATA(lw_adr6) WITH KEY addrnumber = lw_vbpa-addrnumber.
            IF sy-subrc EQ 0.
              lw_entity-agemail = lw_adr6-smtp_addr.
            ENDIF.
          ENDIF.
          READ TABLE li_vbpa INTO lw_vbpa WITH KEY vbeln = lw_vbak-vbeln parvw = lc_we.
          IF sy-subrc EQ 0.
            lw_entity-webp   = lw_vbpa-kunnr.
            lw_entity-wename   = lw_vbpa-name1.
            lw_entity-westreet = lw_vbpa-street.
            lw_entity-wecity   = lw_vbpa-city1.
            lw_entity-westate  = lw_vbpa-region.
            lw_entity-wepostal = lw_vbpa-post_code1.
            lw_entity-wecountry = lw_vbpa-country.
            READ TABLE li_adr6 INTO lw_adr6 WITH KEY addrnumber = lw_vbpa-addrnumber.
            IF sy-subrc EQ 0.
              lw_entity-weemail = lw_adr6-smtp_addr.
            ENDIF.
          ENDIF.
          READ TABLE li_vbpa INTO lw_vbpa WITH KEY vbeln = lw_vbak-vbeln parvw = lc_za.
          IF sy-subrc EQ 0.
            lw_entity-zabp  = lw_vbpa-kunnr.
            lw_entity-zaname = lw_vbpa-name1.
          ENDIF.
          lw_entity-erdat = lw_vbak-erdat.
          lw_entity-bstnk = lw_vbak-bstnk.
          lw_entity-auart = lw_vbak-auart.
          lw_entity-vkorg = lw_vbak-vkorg.
          lw_entity-vkbur = lw_vbak-vkbur.
          lw_entity-augru = lw_vbak-augru.
          lw_entity-waerk = lw_vbak-waerk.
          lw_entity-bsark = lw_vbak-bsark.
          lw_entity-faksk = lw_vbak-faksk.
          lw_entity-lifsk = lw_vbak-lifsk.
          lw_entity-ernam = lw_vbak-ernam.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lw_vbak, lw_csinote, lw_sum, lw_vbfa, lw_tvfst, lw_tvlst,
                 lw_vbuk, lw_vbpa, lw_adr6,lst_vkp.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
*-------  Remove data that does not have currency values ------*
  DELETE et_entityset WHERE waerk IS  INITIAL .

*-------  Remove data that does not correspond to any Business Model  ------*
  DELETE et_entityset WHERE model IS  INITIAL .

*-------  Get data based on Payment Status filter ------*
  IF lv_pstat EQ lc_u.
    DELETE et_entityset WHERE pstat EQ lc_paid.
  ELSEIF lv_pstat EQ lc_p.
    DELETE et_entityset WHERE pstat EQ lc_unpaid.
  ENDIF.

  SORT et_entityset BY vbeln.
  DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING vbeln.

ENDMETHOD.


  METHOD incomplogset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*
    FIELD-SYMBOLS:
      <ls_filter>     LIKE LINE OF it_filter_select_options,
      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

    DATA: lv_vbeln   TYPE c LENGTH 10,
          lv_smodel  TYPE c LENGTH 20,
          lv_waerk   TYPE c LENGTH 5,
          lv_erdat2  TYPE sy-datum,
          lv_label   TYPE string,
          lw_entity  TYPE zcl_zqtco_incompleteor_mpc=>ts_incomplog,
          lv_pstat   TYPE c,
          lc_days    TYPE  rvari_vnam     VALUE 'RUNDAYS',
          lv_rundays TYPE i.

    DATA: lv_input         TYPE string,
          lt_filter_string TYPE TABLE OF string,
          lt_sptint        TYPE TABLE OF string,
          lt_key_value     TYPE /iwbep/t_mgw_name_value_pair,
          lv_name          TYPE string,
          lv_opt           TYPE string,
          lv_value         TYPE string,
          lv_sprint        TYPE string,
          lv_csdate        TYPE c LENGTH 10,
          lv_cedate        TYPE c LENGTH 10,
          lv_bsdate        TYPE c LENGTH 10,
          lv_bedate        TYPE c LENGTH 10,
          lv_var1          TYPE string,
          lv_var2          TYPE string.

    DATA: lst_smodel TYPE /iwbep/s_cod_select_option,
          lir_smodel TYPE /iwbep/t_cod_select_options,
          lst_waerk  TYPE  /iwbep/s_cod_select_option,
          lir_waerk  TYPE /iwbep/t_cod_select_options,
          lst_fdnam  TYPE  /iwbep/s_cod_select_option,
          lir_fdnam  TYPE /iwbep/t_cod_select_options,
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
          lst_kunza  TYPE kun_range,
          lir_kunza  TYPE STANDARD TABLE OF kun_range,
          lst_kunsp  TYPE kun_range,
          lir_kunsp  TYPE STANDARD TABLE OF kun_range,
          lst_matnr  TYPE mat_range,
          lir_matnr  TYPE STANDARD TABLE OF mat_range,
          lst_vbeln  TYPE range_vbeln,
          lir_vbeln  TYPE STANDARD TABLE OF range_vbeln,
          lst_erdat  TYPE tds_rg_erdat,
          lir_erdat  TYPE STANDARD TABLE OF tds_rg_erdat,
          lst_fkdat  TYPE tds_rg_erdat,
          lir_fkdat  TYPE STANDARD TABLE OF tds_rg_erdat,
          lst_pstat  TYPE /iwbep/s_cod_select_option,
          lir_pstat  TYPE /iwbep/t_cod_select_options,
          lst_zterm  TYPE /iwbep/s_cod_select_option,
          lir_zterm  TYPE /iwbep/t_cod_select_options,
          lst_konda  TYPE /iwbep/s_cod_select_option,
          lir_konda  TYPE /iwbep/t_cod_select_options,
          lst_mvgr5  TYPE /iwbep/s_cod_select_option,
          lir_mvgr5  TYPE /iwbep/t_cod_select_options.

    CONSTANTS: lc_devid TYPE c LENGTH 12 VALUE 'R144',
               lc_eq    TYPE char2 VALUE 'EQ',
               lc_ge    TYPE char2 VALUE 'GE',
               lc_le    TYPE char2 VALUE 'LE',
               lc_bt    TYPE char2 VALUE 'BT',
               lc_i     TYPE char1 VALUE 'I',
               lc_soc   TYPE c LENGTH 20 VALUE 'SOC',
               lc_vkbur TYPE  rvari_vnam     VALUE 'VKBUR',
               lc_konda TYPE  rvari_vnam     VALUE 'KONDA',
               lc_mvgr5 TYPE  rvari_vnam     VALUE 'MVGR5',
               lc_kdkg2 TYPE  rvari_vnam     VALUE 'KDKG2',
               lc_vkorg TYPE  rvari_vnam     VALUE 'VKORG',
               lc_model TYPE  rvari_vnam     VALUE 'MODEL',
               lc_auart TYPE  rvari_vnam     VALUE 'AUART',
               lc_pstat TYPE  rvari_vnam     VALUE 'PSTAT',
               lc_zterm TYPE  rvari_vnam     VALUE 'ZTERM',
               lc_bsark TYPE  rvari_vnam     VALUE 'BSARK',
               lc_kunnr TYPE  rvari_vnam     VALUE 'KUNNR',
               lc_kunwe TYPE  rvari_vnam     VALUE 'KUNWE',
               lc_kunsp TYPE  rvari_vnam     VALUE 'KUNSP',
               lc_kunza TYPE  rvari_vnam     VALUE 'KUNZA',
               lc_matnr TYPE  rvari_vnam     VALUE 'MATNR',
               lc_vbeln TYPE  rvari_vnam     VALUE 'VBELN',
               lc_erdat TYPE  rvari_vnam     VALUE 'ERDAT',
               lc_fkdat TYPE  rvari_vnam     VALUE 'FKDAT',
               lc_waerk TYPE  rvari_vnam     VALUE 'WAERK',
               lc_fdnam TYPE  rvari_vnam     VALUE 'FDNAM'.


    DATA: lr_vkbur TYPE /iwbep/t_cod_select_options,
          lr_konda TYPE /iwbep/t_cod_select_options,
          lr_mvgr5 TYPE /iwbep/t_cod_select_options,
          lr_kdkg2 TYPE /iwbep/t_cod_select_options,
          lr_vkorg TYPE TABLE OF range_vkorg.

*----------------Filters to have seletion criteria -------------------*
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.
* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' le ' IN lv_input WITH ' LE '.
      REPLACE ALL OCCURRENCES OF ' ge ' IN lv_input WITH ' GE '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING FIELD-SYMBOL(<fs_key_value>).
        CONDENSE ls_filter_string.
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_opt lv_value.
        IF lv_value NE 'null'.
          DATA(lv_length) = strlen( lv_value ).
          FREE:lv_length,lv_sprint,lt_sptint.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          CASE lv_name.
            WHEN lc_model. "Sales/Business Model
              lv_smodel = lv_sprint.
              LOOP AT lt_sptint INTO DATA(lst_sprint).
                lst_smodel-sign = lc_i.
                lst_smodel-option = lv_opt.
                lst_smodel-low = lst_sprint.
                APPEND lst_smodel TO lir_smodel.
                CLEAR: lst_smodel, lst_sprint.
              ENDLOOP.
            WHEN lc_waerk. "Currency
              LOOP AT lt_sptint INTO lst_sprint.
                lst_waerk-sign = lc_i.
                lst_waerk-option = lv_opt.
                lst_waerk-low = lst_sprint.
                APPEND lst_waerk TO lir_waerk.
                CLEAR: lst_waerk, lst_sprint.
              ENDLOOP.
            WHEN lc_fdnam. "IncompletionLog
              LOOP AT lt_sptint INTO lst_sprint.
                lst_fdnam-sign = lc_i.
                lst_fdnam-option = lv_opt.
                lst_fdnam-low = lst_sprint.
                APPEND lst_fdnam TO lir_fdnam.
                CLEAR: lst_fdnam, lst_sprint.
              ENDLOOP.
            WHEN lc_auart. "Order Type
              LOOP AT lt_sptint INTO lst_sprint.
                lst_auart-sign = lc_i.
                lst_auart-option = lv_opt.
                lst_auart-low = lst_sprint.
                APPEND lst_auart TO lir_auart.
                CLEAR: lst_auart, lst_sprint.
              ENDLOOP.
            WHEN lc_vkorg. "Sales Org
              LOOP AT lt_sptint INTO lst_sprint.
                lst_vkorg-sign = lc_i.
                lst_vkorg-option = lv_opt.
                lst_vkorg-low = lst_sprint.
                APPEND lst_vkorg TO lir_vkorg.
                CLEAR: lst_vkorg, lst_sprint.
              ENDLOOP.
            WHEN lc_pstat. "Payment Status
              lv_pstat = lv_sprint.
            WHEN lc_zterm. "Payment terms
              LOOP AT lt_sptint INTO lst_sprint.
                lst_zterm-sign = lc_i.
                lst_zterm-option = lv_opt.
                lst_zterm-low = lst_sprint.
                APPEND lst_zterm TO lir_zterm.
                CLEAR: lst_zterm, lst_sprint.
              ENDLOOP.
            WHEN lc_bsark. "Po Type
              LOOP AT lt_sptint INTO lst_sprint.
                lst_bsark-sign = lc_i.
                lst_bsark-option = lv_opt.
                lst_bsark-low = lst_sprint.
                APPEND lst_bsark TO lir_bsark.
                CLEAR: lst_bsark, lst_sprint.
              ENDLOOP.
            WHEN lc_konda. "Price group
              LOOP AT lt_sptint INTO lst_sprint.
                lst_konda-sign = lc_i.
                lst_konda-option = lv_opt.
                lst_konda-low = lst_sprint.
                APPEND lst_konda TO lir_konda.
                CLEAR: lst_konda, lst_sprint.
              ENDLOOP.
            WHEN lc_kunnr. "Soldto BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunnr-sign = lc_i.
                lst_kunnr-option = lv_opt.
                lst_kunnr-kunnr_low = lst_sprint.
                APPEND lst_kunnr TO lir_kunnr.
                CLEAR: lst_kunnr, lst_sprint.
              ENDLOOP.
            WHEN lc_kunwe. "Shipto BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunwe-sign = lc_i.
                lst_kunwe-option = lv_opt.
                lst_kunwe-kunnr_low = lst_sprint.
                APPEND lst_kunwe TO lir_kunwe.
                CLEAR: lst_kunwe, lst_sprint.
              ENDLOOP.
            WHEN lc_kunsp. "Freight Forwarder BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunsp-sign = lc_i.
                lst_kunsp-option = lv_opt.
                lst_kunsp-kunnr_low = lst_sprint.
                APPEND lst_kunsp TO lir_kunsp.
                CLEAR: lst_kunsp, lst_sprint.
              ENDLOOP.
            WHEN lc_kunza. "Society BP
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunza-sign = lc_i.
                lst_kunza-option = lv_opt.
                lst_kunza-kunnr_low = lst_sprint.
                APPEND lst_kunza TO lir_kunza.
                CLEAR: lst_kunza, lst_sprint.
              ENDLOOP.
            WHEN lc_matnr. "Material
              LOOP AT lt_sptint INTO lst_sprint.
                lst_matnr-sign = lc_i.
                lst_matnr-option = lv_opt.
                lst_matnr-matnr_low = lst_sprint.
                APPEND lst_matnr TO lir_matnr.
                CLEAR: lst_matnr, lst_sprint.
              ENDLOOP.
            WHEN lc_mvgr5. "Material Group5
              LOOP AT lt_sptint INTO lst_sprint.
                lst_mvgr5-sign = lc_i.
                lst_mvgr5-option = lv_opt.
                lst_mvgr5-low = lst_sprint.
                APPEND lst_mvgr5 TO lir_mvgr5.
                CLEAR: lst_mvgr5, lst_sprint.
              ENDLOOP.
            WHEN lc_vbeln. "Order
              LOOP AT lt_sptint INTO lst_sprint.
                lst_vbeln-sign = lc_i.
                lst_vbeln-option = lv_opt.
                lst_vbeln-low = lst_sprint.
                APPEND lst_vbeln TO lir_vbeln.
                CLEAR: lst_vbeln, lst_sprint.
              ENDLOOP.
            WHEN lc_erdat. "Created Date
              CLEAR:lv_length, lv_sprint, lv_csdate, lv_cedate, lv_var1, lv_var2.
              lv_length = strlen( lv_value ).
              lv_length  = lv_length - 2.
              lv_sprint = lv_value+1(lv_length).
              SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
              CONDENSE lv_sprint NO-GAPS.
              CONCATENATE lv_var1+6(4)
                          lv_var1+3(2)
                          lv_var1+0(2)
                          INTO lv_csdate.
              CONCATENATE lv_var2+6(4)
                          lv_var2+3(2)
                          lv_var2+0(2)
                          INTO lv_cedate.
              lst_erdat-low = lv_csdate.
              lst_erdat-sign = lc_i.
              lst_erdat-option = lc_bt.
              lst_erdat-high = lv_cedate.
              APPEND lst_erdat TO lir_erdat.
              CLEAR lst_erdat.
            WHEN lc_fkdat. "Billing Date
              CLEAR:lv_length, lv_sprint, lv_bsdate, lv_bedate, lv_var1, lv_var2.
              lv_length = strlen( lv_value ).
              lv_length  = lv_length - 2.
              lv_sprint = lv_value+1(lv_length).
              SPLIT lv_sprint AT ' , ' INTO lv_var1 lv_var2.
              CONDENSE lv_sprint NO-GAPS.
              CONCATENATE lv_var1+6(4)
                          lv_var1+3(2)
                          lv_var1+0(2)
                          INTO lv_bsdate.
              CONCATENATE lv_var2+6(4)
                          lv_var2+3(2)
                          lv_var2+0(2)
                          INTO lv_bedate.
              lst_fkdat-low = lv_bsdate.
              lst_fkdat-sign = lc_i.
              lst_fkdat-option = lc_bt.
              lst_fkdat-high = lv_bedate.
              APPEND lst_fkdat TO lir_fkdat.
              CLEAR lst_fkdat.
              CLEAR: lst_sprint.
          ENDCASE.
        ENDIF.
      ENDLOOP.
    ENDIF.
*------------------ Get constant table data ---------------------------*
    SELECT * FROM zcaconstant INTO TABLE @DATA(lt_const)
         WHERE devid = @lc_devid and activate = @abap_true.

    LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lw_const>).

      IF lir_smodel IS NOT INITIAL.
        CLEAR: lst_smodel.
        LOOP AT lir_smodel INTO lst_smodel.
          IF <lw_const>-param2 = lst_smodel-low.
            IF <lw_const>-param1 = lc_vkbur.
              APPEND INITIAL LINE TO lr_vkbur ASSIGNING FIELD-SYMBOL(<lst_vkbur_i>).
              <lst_vkbur_i>-sign   = <lw_const>-sign.
              <lst_vkbur_i>-option = <lw_const>-opti.
              <lst_vkbur_i>-low    = <lw_const>-low.
              <lst_vkbur_i>-high   = <lw_const>-high.
            ENDIF.

            IF <lw_const>-param1 = lc_konda.
              APPEND INITIAL LINE TO lr_konda ASSIGNING FIELD-SYMBOL(<lst_konda_i>).
              <lst_konda_i>-sign   = <lw_const>-sign.
              <lst_konda_i>-option = <lw_const>-opti.
              <lst_konda_i>-low    = <lw_const>-low.
              <lst_konda_i>-high   = <lw_const>-high.
            ENDIF.

            IF <lw_const>-param1 = lc_mvgr5.
              APPEND INITIAL LINE TO lr_mvgr5 ASSIGNING FIELD-SYMBOL(<lst_mvgr5_i>).
              <lst_mvgr5_i>-sign   = <lw_const>-sign.
              <lst_mvgr5_i>-option = <lw_const>-opti.
              <lst_mvgr5_i>-low    = <lw_const>-low.
              <lst_mvgr5_i>-high   = <lw_const>-high.
            ENDIF.

          ENDIF.
        ENDLOOP.
      ENDIF.

      IF  lir_vkorg IS INITIAL AND <lw_const>-param1 = lc_vkorg .
        APPEND INITIAL LINE TO lr_vkorg ASSIGNING FIELD-SYMBOL(<lst_vkorg_i>).
        <lst_vkorg_i>-sign   = <lw_const>-sign.
        <lst_vkorg_i>-option = <lw_const>-opti.
        <lst_vkorg_i>-low    = <lw_const>-low.
        <lst_vkorg_i>-high   = <lw_const>-high.
      ENDIF.
    ENDLOOP.

    IF lir_vkorg IS INITIAL.
      lir_vkorg = lr_vkorg.
    ENDIF.
    IF lir_konda IS INITIAL.
      lir_konda = lr_konda.
    ENDIF.
    IF lir_mvgr5 IS INITIAL.
      lir_mvgr5 = lr_mvgr5.
    ENDIF.
*-----------------------Fetch incomplete log data to have them as search help entries-----------------------------*
    IF lv_smodel = lc_soc.
      SELECT v~vbeln, v~vkorg, v~vkbur, v~vbtyp, v~auart,v~erdat,
          v~ernam, v~bstnk, v~kunnr, v~augru, v~bsark, v~faksk, v~lifsk,
          vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid,
          p~netwr AS nvalue, p~waerk, p~mvgr5, p~zzvyp, p~zzsubtyp,
          p~zmeng, p~mwsbp AS tax, p~matnr,
          d~konda, d~kdkg2, d~zterm, d~zlsch, d~fkdat
     INTO TABLE @DATA(li_vbak)
     FROM vbuv AS vb
     INNER JOIN vbak AS v ON  v~vbeln = vb~vbeln
     INNER JOIN vbap AS p ON p~vbeln = vb~vbeln "AND p~posnr = vb~posnr
     INNER JOIN vbkd AS d ON d~vbeln = vb~vbeln "AND d~posnr = vb~posnr
     WHERE ( v~vkbur IN @lr_vkbur AND d~konda IN @lir_konda AND d~kdkg2 NE ' ' )
        AND p~waerk IN @lir_waerk
        AND v~auart IN @lir_auart AND ( v~vkorg IN @lir_vkorg )
        AND d~zterm IN @lir_zterm AND v~bsark IN @lir_bsark
        AND ( v~kunnr IN @lir_kunnr OR v~kunnr IN @lir_kunwe OR v~kunnr IN @lir_kunza )
        AND p~matnr IN @lir_matnr
        AND vb~vbeln IN @lir_vbeln AND v~erdat IN @lir_erdat
        AND d~fkdat IN @lir_fkdat.
    ELSE.
      SELECT v~vbeln, v~vkorg, v~vkbur, v~vbtyp, v~auart,v~erdat,
        v~ernam, v~bstnk, v~kunnr, v~augru, v~bsark, v~faksk, v~lifsk,
        vb~posnr,vb~fdnam, vb~tbnam,vb~etenr,vb~parvw,vb~tdid,
        p~netwr AS nvalue, p~waerk, p~mvgr5, p~zzvyp, p~zzsubtyp,
        p~zmeng, p~mwsbp AS tax, p~matnr,
        d~konda, d~kdkg2, d~zterm, d~zlsch, d~fkdat
   INTO TABLE @li_vbak
   FROM vbuv AS vb
   INNER JOIN vbak AS v ON  v~vbeln = vb~vbeln
   INNER JOIN vbap AS p ON p~vbeln = vb~vbeln "AND p~posnr = vb~posnr
   INNER JOIN vbkd AS d ON d~vbeln = vb~vbeln "AND d~posnr = vb~posnr
   WHERE ( v~vkbur IN @lr_vkbur AND d~konda IN @lir_konda )
      AND p~waerk IN @lir_waerk
      AND v~auart IN @lir_auart AND ( v~vkorg IN @lir_vkorg )
      AND d~zterm IN @lir_zterm AND v~bsark IN @lir_bsark
      AND ( v~kunnr IN @lir_kunnr OR v~kunnr IN @lir_kunwe OR v~kunnr IN @lir_kunza )
      AND p~matnr IN @lir_matnr
      AND vb~vbeln IN @lir_vbeln AND v~erdat IN @lir_erdat
      AND d~fkdat IN @lir_fkdat.
    ENDIF.
    IF sy-subrc EQ 0.
      SORT li_vbak BY tbnam fdnam.
      DELETE ADJACENT DUPLICATES FROM li_vbak COMPARING tbnam fdnam.

      LOOP AT li_vbak INTO DATA(lw_vbak).
        lw_entity-fdnam = lw_vbak-fdnam.
        lw_entity-tbnam = lw_vbak-tbnam.
        CALL FUNCTION 'DDIF_FIELDLABEL_GET'
          EXPORTING
            tabname        = lw_vbak-tbnam
            fieldname      = lw_vbak-fdnam
            langu          = sy-langu
          IMPORTING
            label          = lv_label
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.
        IF sy-subrc = 0.
* Implement suitable error handling here
          lw_entity-desc = lv_label.
        ENDIF.

        APPEND lw_entity TO et_entityset.
        CLEAR: lw_entity, lv_label.
      ENDLOOP.
      SORT et_entityset BY desc.
      DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING desc.
    ENDIF.

  ENDMETHOD.


  METHOD iorderset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*------------- Search help entries for Sales Document --------------------*
    SELECT DISTINCT vbeln FROM vbuv INTO TABLE et_entityset.
    IF sy-subrc EQ 0.
      SORT et_entityset BY vbeln.
    ENDIF.
  ENDMETHOD.


METHOD itemsset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

  FIELD-SYMBOLS:
    <ls_filter>     LIKE LINE OF it_filter_select_options,
    <ls_filter_opt> TYPE /iwbep/s_cod_select_option.

  DATA: lir_vbeln TYPE /iwbep/t_cod_select_options,
        lst_vbeln TYPE /iwbep/s_cod_select_option,
        lv_var(1) TYPE c,
        lv_r(1)   TYPE c,
        lv_label  TYPE string,
        lv_host   TYPE string,
        lv_port   TYPE string,
        lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_items,
        lv_counts TYPE i,
        lv_countp TYPE i.

  DATA: lst_tab   TYPE zcl_zqtco_incompleteor_mpc=>ts_items,
        li_tab    TYPE zcl_zqtco_incompleteor_mpc=>tt_items,
        lst_items TYPE zcl_zqtco_incompleteor_mpc=>ts_items,
        li_items  TYPE zcl_zqtco_incompleteor_mpc=>tt_items.

  TYPES: BEGIN OF ty_issue,
           vbeln          TYPE vbeln,
           posnr          TYPE posnr,
           xorder_created TYPE jmorder_created,
           count          TYPE i,
         END OF ty_issue.

  DATA:li_sent  TYPE STANDARD TABLE OF ty_issue,
       lst_sent TYPE ty_issue,
       li_pend  TYPE STANDARD TABLE OF ty_issue,
       lst_pend TYPE ty_issue.

  CONSTANTS: lc_we    TYPE parvw   VALUE 'WE',
             lc_m     TYPE vbtyp_n VALUE 'M',
             lc_r     TYPE c       VALUE 'R',
             lc_a     TYPE c       VALUE 'A',
             lc_i     TYPE c       VALUE 'I',
             lc_c     TYPE c       VALUE 'C',
             lc_va    TYPE c       VALUE 'A',
             lc_vb    TYPE c       VALUE 'B',
             lc_vc    TYPE c       VALUE 'C',
             lc_vg    TYPE c       VALUE 'G',
             lc_vk    TYPE c       VALUE 'K',
             lc_vl    TYPE c       VALUE 'L',
             lc_var   TYPE c LENGTH 5      VALUE 'VAR',
             lc_ors   TYPE c LENGTH 8      VALUE 'OTHERS',
             lc_paid  TYPE c LENGTH 5      VALUE 'Paid',
             lc_npaid TYPE c LENGTH 10     VALUE 'Not Paid',
             lc_vbeln TYPE  rvari_vnam     VALUE 'VBELN',
             lc_x     TYPE jmorder_created VALUE 'X',
             lc_va02  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA02%20VBAK-VBELN=',
             lc_va12  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA12%20VBAK-VBELN=',
             lc_va22  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA22%20VBAK-VBELN=',
             lc_va42  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA42%20VBAK-VBELN='.

*-----------Filters for selection criteria-----------*
  LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
    LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
      CASE <ls_filter>-property.
        WHEN lc_vbeln.    "Sales Document
          lst_vbeln-sign = <ls_filter_opt>-sign.
          lst_vbeln-option = <ls_filter_opt>-option.
          lst_vbeln-low = <ls_filter_opt>-low.
          lst_vbeln-high = <ls_filter_opt>-high.
          APPEND lst_vbeln TO lir_vbeln.
          CLEAR lst_vbeln.
        WHEN lc_var.
          lv_var = <ls_filter_opt>-low.
          lv_r = <ls_filter_opt>-high.
        WHEN OTHERS.
          "Do nothing.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  cl_http_server=>if_http_server~get_location(
     IMPORTING host = lv_host
            port = lv_port ).

  IF lir_vbeln IS NOT INITIAL.
*----------------------------Fetch all items-------------------------------*
    SELECT v~vbeln, v~posnr, v~abgru, v~matnr, v~zmeng, v~netwr, v~mwsbp,
           v~mvgr5,v~zzvyp,v~zzsubtyp,v~arktx AS maktx ,vk~waerk,
           vb~fkdat,vb~kdkg2,vb~konda, vu~uvwas, vu~cmgst, vp~gbsta
           INTO TABLE @DATA(li_vbap) FROM vbap AS v
           INNER JOIN vbak AS vk ON vk~vbeln = v~vbeln
           INNER JOIN vbkd AS vb ON ( vb~vbeln = v~vbeln AND vb~posnr = v~posnr )
           INNER JOIN vbuk AS vu ON vu~vbeln = v~vbeln
           INNER JOIN vbup AS vp ON ( vp~vbeln = v~vbeln AND vp~posnr = v~posnr )
           WHERE v~vbeln IN @lir_vbeln.
    IF sy-subrc EQ 0.
      SORT li_vbap BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING vbeln posnr.
    ENDIF.
*-----------------------Fetch SD document category---------------*
    SELECT SINGLE vbtyp FROM vbak INTO @DATA(lv_vbtyp)
             WHERE vbeln IN @lir_vbeln.
    IF sy-subrc NE 0.
      CLEAR:lv_vbtyp.
    ENDIF.

    IF li_vbap IS NOT INITIAL.
*--------------------Fetch Contract data---------------------------------*
      SELECT vbeln, vposn, vkuesch, vkuegru, vbedkue, vbegdat, venddat
             FROM veda
             INTO TABLE @DATA(li_veda)
             FOR ALL ENTRIES IN @li_vbap
            WHERE vbeln EQ @li_vbap-vbeln AND vposn EQ @li_vbap-posnr.
      IF sy-subrc EQ 0.
        SORT li_veda BY vbeln vposn.
      ENDIF.
*-------------------Fetch Document category of subsequent document--------------*
      SELECT vbelv, posnv, vbtyp_n FROM vbfa INTO TABLE @DATA(li_vbfa)
             FOR ALL ENTRIES IN @li_vbap
             WHERE vbelv EQ @li_vbap-vbeln AND posnv EQ @li_vbap-posnr
             AND vbtyp_n EQ @lc_m.

      IF sy-subrc EQ 0.
        SORT li_vbfa BY vbelv.
      ENDIF.
*------------------------Get Partner details------------------------*
      SELECT vp~vbeln, vp~posnr, vp~parvw, vp~kunnr, vp~adrnr,
              ad~date_from, ad~nation, ad~addrnumber, ad~name1, ad~street,
              ad~city1, ad~region, ad~post_code1, ad~country,
              a6~persnumber,a6~consnumber, a6~smtp_addr
              INTO TABLE @DATA(li_vbpa)
              FROM vbpa AS vp
              INNER JOIN adrc AS ad ON ad~addrnumber = vp~adrnr
              INNER JOIN adr6 AS a6 ON a6~addrnumber = vp~adrnr
              FOR ALL ENTRIES IN @li_vbap
              WHERE ( vp~vbeln EQ @li_vbap-vbeln AND vp~parvw EQ @lc_we ).
      IF sy-subrc EQ 0.
        SORT li_vbpa BY vbeln posnr.
      ENDIF.
*-------------------------Fetch Issues sent and Issues pending-----------------*
      SELECT vbeln, posnr, xorder_created INTO TABLE @DATA(li_jk) FROM jksesched
         WHERE vbeln IN @lir_vbeln.

      IF sy-subrc EQ 0.
        LOOP AT li_jk INTO DATA(lst_jk).
          IF lst_jk-xorder_created = lc_x.
            lst_sent-vbeln = lst_jk-vbeln.
            lst_sent-posnr = lst_jk-posnr.
            lst_sent-xorder_created = lst_jk-xorder_created.
            lst_sent-count = 1.
            COLLECT lst_sent INTO li_sent.
          ELSEIF lst_jk-xorder_created NE lc_x.
            lst_pend-vbeln = lst_jk-vbeln.
            lst_pend-posnr = lst_jk-posnr.
            lst_pend-xorder_created = lst_jk-xorder_created.
            lst_pend-count = 1.
            COLLECT lst_pend INTO li_pend.
          ENDIF.
          CLEAR: lst_sent, lst_pend, lst_jk.
        ENDLOOP.
      ENDIF.

      LOOP AT li_vbap INTO DATA(lw_vbap).
        MOVE-CORRESPONDING lw_vbap TO lst_tab.
        READ TABLE li_veda INTO DATA(lw_veda) WITH KEY vbeln = lw_vbap-vbeln vposn = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING lw_veda TO lst_tab.
        ENDIF.
        READ TABLE li_vbfa INTO DATA(lw_vbfa) WITH KEY vbelv = lw_vbap-vbeln posnv = lw_vbap-posnr.
        IF sy-subrc EQ 0.
          IF lw_vbfa-vbtyp_n = lc_m.
            lst_tab-pstatus = lc_paid.
          ELSE.
            lst_tab-pstatus = lc_npaid.
          ENDIF.
        ELSE.
          lst_tab-pstatus = lc_npaid.
        ENDIF.
        READ TABLE li_vbpa INTO DATA(lw_vbpa) WITH KEY vbeln = lw_vbap-vbeln.
        IF sy-subrc = 0.
          lst_tab-shpbp       = lw_vbpa-kunnr.
          lst_tab-shpname     = lw_vbpa-name1.
          lst_tab-shpstreet   = lw_vbpa-street.
          lst_tab-shpcity     = lw_vbpa-city1.
          lst_tab-shpstate    = lw_vbpa-region.
          lst_tab-shppostal   = lw_vbpa-post_code1.
          lst_tab-shpcountry  = lw_vbpa-country.
          lst_tab-shpemail    = lw_vbpa-smtp_addr.
        ENDIF.
        APPEND lst_tab TO li_tab.
        CLEAR: lst_tab, lw_vbap, lw_vbpa, lw_vbfa, lw_veda.
      ENDLOOP.
    ENDIF.
*-----------------Display all items----------------------*
    IF lv_var = lc_a OR lv_var IS INITIAL .
      APPEND LINES OF li_tab TO li_items.
*-----------------Display Incomplete Items----------------------*
    ELSEIF lv_var = lc_i.
      SELECT vbeln, posnr, etenr, parvw, tdid, tbnam, fdnam FROM vbuv
             INTO TABLE @DATA(li_vbuv)
             WHERE  vbeln IN @lir_vbeln.

      IF sy-subrc EQ 0.
        SORT li_vbuv BY vbeln posnr.
        LOOP AT li_vbuv INTO DATA(lw_vbuv).
          CLEAR lst_items.
          READ TABLE li_tab INTO lst_tab WITH KEY vbeln = lw_vbuv-vbeln posnr = lw_vbuv-posnr.
          IF sy-subrc EQ 0.
            MOVE lst_tab TO lst_items.
          ENDIF.
          MOVE-CORRESPONDING lw_vbuv TO lst_items.

          CALL FUNCTION 'DDIF_FIELDLABEL_GET'  "Call FM to display the label for missing fields
            EXPORTING
              tabname        = lw_vbuv-tbnam
              fieldname      = lw_vbuv-fdnam
              langu          = sy-langu
            IMPORTING
              label          = lv_label
            EXCEPTIONS
              not_found      = 1
              internal_error = 2
              OTHERS         = 3.
          IF sy-subrc EQ 0.
            lst_items-missing = lv_label.
            CLEAR: lv_label.
          ENDIF.
          APPEND lst_items TO li_items.
          CLEAR: lw_vbuv, lst_tab.
        ENDLOOP.
      ENDIF.
*----------------------Display Open Items--------------*
    ELSEIF lv_var = lc_c.
      SELECT vbeln, posnr FROM vbuv INTO TABLE @li_vbuv
             WHERE vbeln IN @lir_vbeln.
      IF sy-subrc EQ 0.
        SORT li_vbuv BY vbeln posnr.
        LOOP AT li_vbuv INTO DATA(lst_vbuv).
          DELETE li_tab WHERE vbeln EQ lst_vbuv-vbeln AND posnr EQ lst_vbuv-posnr.
          CLEAR lst_vbuv.
        ENDLOOP.
        APPEND LINES OF li_tab TO li_items.
      ELSEIF sy-subrc NE 0.
        APPEND LINES OF li_tab TO li_items.
      ENDIF.
    ENDIF.
*---------------Display cancelled orders-------------------*
    IF lv_r = lc_r.
      DATA(li_final) = li_items.
      REFRESH li_items.
      CLEAR lst_items.
      LOOP AT li_final INTO DATA(lst_final).
        IF lst_final-abgru IS NOT INITIAL.
          MOVE lst_final TO lst_items.
          APPEND lst_items TO li_items.
          CLEAR lst_items.
        ENDIF.
        CLEAR: lst_tab, lst_final, lst_items.
      ENDLOOP.
    ENDIF.

    LOOP AT li_items INTO lst_items.
      MOVE lst_items TO lw_entity.
      CASE lv_vbtyp.
        WHEN lc_va.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va12 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_vb.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va22 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_vc.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_vg.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va42 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_vk.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_vl.
          CONCATENATE 'http://' lv_host ':' lv_port lc_va02 lst_items-vbeln INTO lw_entity-linkref.
        WHEN lc_ors.
          "Do nothing.
      ENDCASE.
      READ TABLE li_sent INTO lst_sent WITH KEY vbeln = lst_items-vbeln posnr = lst_items-posnr.
      IF sy-subrc EQ 0.
        lw_entity-issuessent = lst_sent-count.
      ENDIF.
      READ TABLE li_pend INTO lst_pend WITH KEY vbeln = lst_items-vbeln posnr = lst_items-posnr.
      IF sy-subrc EQ 0.
        lw_entity-issuespend = lst_pend-count.
      ENDIF.
      APPEND lw_entity TO et_entityset.
      CLEAR: lw_entity, lst_items.
    ENDLOOP.

  ENDIF.
ENDMETHOD.


  METHOD materialgroup5se_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: li_mat TYPE zcl_zqtco_incompleteor_mpc=>tt_materialgroup5,
          lw_mat TYPE zcl_zqtco_incompleteor_mpc=>ts_materialgroup5.

*------------Search help entries for Material Group5---------*
    SELECT mvgr5 bezei
     FROM tvm5t
     INTO TABLE li_mat
     WHERE spras = sy-langu.

    IF sy-subrc EQ 0.

      LOOP AT li_mat INTO lw_mat.
        APPEND lw_mat TO et_entityset.
        CLEAR lw_mat.
      ENDLOOP.
      SORT et_entityset BY mvgr5.
    ENDIF.

  ENDMETHOD.


  METHOD materialset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_material.

*---------------Search help entries for Material Number-------------*
    IF sy-subrc IS INITIAL.
      SELECT DISTINCT v~vbeln, vp~matnr, m~maktx INTO TABLE @DATA(li_mat) FROM vbuv AS v
             INNER JOIN vbap AS vp ON vp~vbeln = v~vbeln
             INNER JOIN makt AS m ON ( m~matnr = vp~matnr AND spras = @sy-langu )." UP TO 100 ROWS.
      IF sy-subrc EQ 0.
        SORT li_mat BY matnr.
        DELETE ADJACENT DUPLICATES FROM li_mat COMPARING matnr.
        IF li_mat IS NOT INITIAL.
          LOOP AT li_mat INTO DATA(lw_mat).
            lw_entity-matnr = lw_mat-matnr.
            lw_entity-maktx = lw_mat-maktx.
            APPEND lw_entity TO et_entityset.
            CLEAR: lw_mat, lw_entity.
          ENDLOOP.
          SORT et_entityset BY matnr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD ordertypeset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: li_orders TYPE zcl_zqtco_incompleteor_mpc=>tt_ordertype,
          wa_orders TYPE zcl_zqtco_incompleteor_mpc=>ts_ordertype.

*------------Search help entries for Order Type---------*
    SELECT auart bezei FROM tvakt
    INTO  TABLE li_orders
       WHERE  spras = sy-langu.

    IF sy-subrc EQ 0.
      SORT li_orders[] BY auart bezei.
      LOOP AT  li_orders INTO wa_orders.
        APPEND wa_orders TO et_entityset.
        CLEAR:wa_orders.
      ENDLOOP.
      SORT et_entityset BY auart.
    ENDIF.
  ENDMETHOD.


  METHOD paymenttermset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*------------Search help entries for Payment terms---------*
    SELECT zterm text1 FROM t052u
       INTO CORRESPONDING FIELDS OF TABLE et_entityset
        WHERE spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT et_entityset BY zterm.
    ENDIF.
  ENDMETHOD.


  METHOD potypeset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*------------Search help entries for Purchase Order Type---------*
    SELECT bsark vtext FROM t176t
     INTO CORRESPONDING FIELDS OF TABLE et_entityset
     WHERE spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT et_entityset BY bsark.
    ENDIF.
  ENDMETHOD.


  METHOD pricegroupset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*------------Search help entries for Price Group---------*
    SELECT konda vtext FROM t188t
       INTO CORRESPONDING FIELDS OF TABLE et_entityset
       WHERE spras EQ sy-langu.
    IF sy-subrc EQ 0.
      SORT et_entityset BY konda.
    ENDIF.
  ENDMETHOD.


  METHOD salesgroupset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*    DATA: li_orders TYPE zcl_zqtco_incompleteor_mpc=>tt_salesgroup,
*          wa_orders TYPE zcl_zqtco_incompleteor_mpc=>ts_salesgroup.
*
**------------Search help entries for Sales Group---------*
*    SELECT vkgrp bezei FROM tvgrt
*        INTO TABLE li_orders
*           WHERE  spras = sy-langu.
*    IF sy-subrc EQ 0.
*      SORT li_orders[] BY vkgrp.
*      LOOP AT  li_orders INTO wa_orders.
*        APPEND wa_orders TO et_entityset.
*        CLEAR:wa_orders.
*      ENDLOOP.
*    ENDIF.
  ENDMETHOD.


  METHOD salesorgset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: li_orders TYPE zcl_zqtco_incompleteor_mpc=>tt_salesorg,
          wa_orders TYPE zcl_zqtco_incompleteor_mpc=>ts_salesorg.

*------------Search help entries for Sales Org---------*
    SELECT vkorg vtext FROM tvkot
    INTO TABLE li_orders
       WHERE  spras = sy-langu.
    IF sy-subrc EQ 0.
      SORT li_orders[] BY vkorg vtext.
      LOOP AT  li_orders INTO wa_orders.
        APPEND wa_orders TO et_entityset.
        CLEAR:wa_orders.
      ENDLOOP.
      SORT et_entityset BY vkorg.
    ENDIF.
  ENDMETHOD.


  METHOD shiptopartyaddre_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*    FIELD-SYMBOLS:
*      <ls_filter>     LIKE LINE OF it_filter_select_options,
*      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
*
*    DATA: lst_vbeln TYPE range_vbeln,
*          lir_vbeln TYPE STANDARD TABLE OF range_vbeln,
*          lv_vbeln  TYPE vbeln_va,
*          lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_shiptopartyaddress.
*
*    CONSTANTS: lc_parvw TYPE parvw VALUE 'WE'.
*
*    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
*      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
*        CASE <ls_filter>-property.
*          WHEN 'VBELN'.
*            lv_vbeln = <ls_filter_opt>-low.
*          WHEN OTHERS.
*            "Do nothing.
*        ENDCASE.
*      ENDLOOP.
*    ENDLOOP.
*
*    IF lv_vbeln IS NOT INITIAL.
**---------------------Fetch Ship to Party Address details------------*
*      SELECT v~vbeln, v~parvw, v~kunnr, v~adrnr,
*              ad~name1, ad~addrnumber, ad~street, ad~city1,
*              ad~region, ad~post_code1, ad~country
*           INTO TABLE @DATA(li_vbpa)
*           FROM vbpa AS v
*            INNER JOIN adrc AS ad ON ad~addrnumber = v~adrnr
*           WHERE vbeln EQ @lv_vbeln
*            AND  parvw EQ @lc_parvw.
*
*      IF sy-subrc EQ 0.
*        SELECT addrnumber, smtp_addr FROM adr6
*             INTO TABLE @DATA(li_adr6)
*             FOR ALL ENTRIES IN @li_vbpa
*             WHERE addrnumber EQ @li_vbpa-adrnr.
*        IF sy-subrc EQ 0.
*          SORT li_adr6 BY addrnumber.
*        ENDIF.
*        LOOP AT li_vbpa INTO DATA(lw_vbpa).
*          READ TABLE li_adr6 INTO DATA(lw_adr6) WITH KEY addrnumber = lw_vbpa-adrnr.
*          IF sy-subrc EQ 0.
*            lw_entity-email = lw_adr6-smtp_addr.
*          ENDIF.
*          lw_entity-vbeln = lw_vbpa-vbeln.
*          lw_entity-name = lw_vbpa-name1.
*          lw_entity-street = lw_vbpa-street.
*          lw_entity-city = lw_vbpa-city1.
*          lw_entity-state = lw_vbpa-region.
*          lw_entity-country = lw_vbpa-country.
*          lw_entity-postalcode = lw_vbpa-post_code1.
*          lw_entity-kunnr = lw_vbpa-kunnr.
*          lw_entity-adrnr = lw_vbpa-adrnr.
*          APPEND lw_entity TO et_entityset.
*          CLEAR: lw_entity.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD shiptoset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    DATA: lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_shipto.

    CONSTANTS: lc_we TYPE parvw VALUE 'WE'.

*-----------------Search help entries for Ship to Party-------*
    SELECT DISTINCT v~vbeln, vp~parvw, vp~kunnr, k~name1, k~name2
            INTO TABLE @DATA(li_kna1)
            FROM vbuv AS v
            INNER JOIN vbpa AS vp ON vp~vbeln = v~vbeln
            INNER JOIN kna1 AS k ON k~kunnr = vp~kunnr
            WHERE vp~parvw EQ @lc_we.

    IF sy-subrc EQ 0.
      SORT li_kna1 BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_kna1 COMPARING kunnr.
      IF li_kna1 IS NOT INITIAL.
        LOOP AT li_kna1 INTO DATA(lw_kna1).
          lw_entity-kunwe = lw_kna1-kunnr.
          lw_entity-name1 = lw_kna1-name1.
          lw_entity-name2 = lw_kna1-name2.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lw_kna1.
        ENDLOOP.
        SORT et_entityset BY kunwe.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD smodelset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    CONSTANTS: lc_devid TYPE zdevid VALUE 'R144' .
    CONSTANTS: lc_smodel TYPE zdevid VALUE 'SALESMODEL' .

    DATA:lst_smodel TYPE zcl_zqtco_incompleteor_mpc=>ts_smodel.

*------------Search help entries for Sales/Business Model---------*
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
      SORT et_entityset BY model.
    ENDIF.

  ENDMETHOD.


  METHOD societypartnerse_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*
    DATA: lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_societypartner.

    CONSTANTS: lc_za TYPE parvw VALUE 'ZA'.

*---------Search help entries for Society Partner---------------*
    SELECT DISTINCT v~vbeln, vp~parvw, vp~kunnr, k~name1, k~name2
            INTO TABLE @DATA(li_kna1)
            FROM vbuv AS v
            INNER JOIN vbpa AS vp ON vp~vbeln = v~vbeln
            INNER JOIN kna1 AS k ON k~kunnr = vp~kunnr
            WHERE vp~parvw EQ @lc_za.

    IF sy-subrc EQ 0.
      SORT li_kna1 BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_kna1 COMPARING kunnr.
      IF li_kna1 IS NOT INITIAL.
        LOOP AT li_kna1 INTO DATA(lw_kna1).
          lw_entity-kunza = lw_kna1-kunnr.
          lw_entity-name1 = lw_kna1-name1.
          lw_entity-name2 = lw_kna1-name2.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lw_kna1.
        ENDLOOP.
        SORT et_entityset BY kunza.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD soldtopartyaddre_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

*    FIELD-SYMBOLS:
*      <ls_filter>     LIKE LINE OF it_filter_select_options,
*      <ls_filter_opt> TYPE /iwbep/s_cod_select_option.
*
*    DATA: lst_vbeln TYPE range_vbeln,
*          lir_vbeln TYPE STANDARD TABLE OF range_vbeln,
*          lv_vbeln  TYPE vbeln_va,
*          lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_soldtopartyaddress.
*
*    CONSTANTS: lc_parvw TYPE parvw VALUE 'AG'.
*
*
*    LOOP AT it_filter_select_options ASSIGNING <ls_filter> .
*      LOOP AT <ls_filter>-select_options ASSIGNING  <ls_filter_opt>.
*        CASE <ls_filter>-property.
*          WHEN 'VBELN'.
*            lv_vbeln = <ls_filter_opt>-low.
*          WHEN OTHERS.
*            "Do nothing.
*        ENDCASE.
*      ENDLOOP.
*    ENDLOOP.
*
*    IF lv_vbeln IS NOT INITIAL.
**-----------------Get Sold to Party address details----*
*      SELECT v~vbeln, v~parvw, v~kunnr, v~adrnr,
*              ad~name1, ad~addrnumber, ad~street, ad~city1,
*              ad~region, ad~post_code1, ad~country
*           INTO TABLE @DATA(li_vbpa)
*           FROM vbpa AS v
*            INNER JOIN adrc AS ad ON ad~addrnumber = v~adrnr
*           WHERE vbeln EQ @lv_vbeln
*            AND  parvw EQ @lc_parvw.
*
*      IF sy-subrc EQ 0.
*        SELECT addrnumber, smtp_addr FROM adr6
*             INTO TABLE @DATA(li_adr6)
*             FOR ALL ENTRIES IN @li_vbpa
*             WHERE addrnumber EQ @li_vbpa-adrnr.
*        IF sy-subrc EQ 0.
*          SORT li_adr6 BY addrnumber.
*        ENDIF.
*        LOOP AT li_vbpa INTO DATA(lw_vbpa).
*          READ TABLE li_adr6 INTO DATA(lw_adr6) WITH KEY addrnumber = lw_vbpa-adrnr.
*          IF sy-subrc EQ 0.
*            lw_entity-email = lw_adr6-smtp_addr.
*          ENDIF.
*          lw_entity-vbeln = lw_vbpa-vbeln.
*          lw_entity-name = lw_vbpa-name1.
*          lw_entity-street = lw_vbpa-street.
*          lw_entity-city = lw_vbpa-city1.
*          lw_entity-state = lw_vbpa-region.
*          lw_entity-country = lw_vbpa-country.
*          lw_entity-postalcode = lw_vbpa-post_code1.
*          lw_entity-kunnr = lw_vbpa-kunnr.
*          lw_entity-adrnr = lw_vbpa-adrnr.
*          APPEND lw_entity TO et_entityset.
*          CLEAR: lw_entity.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD soldtoset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*
    DATA: lw_entity TYPE zcl_zqtco_incompleteor_mpc=>ts_soldto.

    CONSTANTS: lc_ag TYPE parvw VALUE 'AG'.

*------------Search help entries for Sold to Party----------*
    SELECT DISTINCT v~vbeln, vp~parvw, vp~kunnr, k~name1, k~name2
            INTO TABLE @DATA(li_kna1)
            FROM vbuv AS v
            INNER JOIN vbpa AS vp ON vp~vbeln = v~vbeln
            INNER JOIN kna1 AS k ON k~kunnr = vp~kunnr
            WHERE vp~parvw EQ @lc_ag.

    IF sy-subrc EQ 0.
      SORT li_kna1 BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_kna1 COMPARING kunnr.
      IF li_kna1 IS NOT INITIAL.
        LOOP AT li_kna1 INTO DATA(lw_kna1).
          lw_entity-kunnr = lw_kna1-kunnr.
          lw_entity-name1 = lw_kna1-name1.
          lw_entity-name2 = lw_kna1-name2.
          APPEND lw_entity TO et_entityset.
          CLEAR: lw_entity, lw_kna1.
        ENDLOOP.
        SORT et_entityset BY kunnr.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zcaconstset_get_entityset.
*----------------------------------------------------------------------*
* REVISION NO: ED2K925456                                             *
* REFERENCE NO: OTCM-25626                                            *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/28/2021                                                    *
* DESCRIPTION: UI5 Incompletion Report
*------------------------------------------------------------------------*

    CONSTANTS: lc_devid TYPE zdevid      VALUE 'R144' .
    CONSTANTS: lc_days TYPE  rvari_vnam     VALUE 'RUNDAYS' .
    DATA:lst_const TYPE zcl_zqtco_incompleteor_mpc=>ts_zcaconst.

*--------------get constant entries-------------*
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
