class ZCL_ZCA_TRLOG_ANALYTIC_DPC_EXT definition
  public
  inheriting from ZCL_ZCA_TRLOG_ANALYTIC_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods CHQVALUESET_GET_ENTITYSET
    redefinition .
  methods CRTRACKERSET_CREATE_ENTITY
    redefinition .
  methods CRTRACKERSET_UPDATE_ENTITY
    redefinition .
  methods EPICOWNERSET_GET_ENTITYSET
    redefinition .
  methods EPICVALUESET_GET_ENTITYSET
    redefinition .
  methods OWNERSET_GET_ENTITYSET
    redefinition .
  methods SPRINT1SET_GET_ENTITYSET
    redefinition .
  methods SPRINT2SET_GET_ENTITYSET
    redefinition .
  methods SPRINTVALUESET_GET_ENTITYSET
    redefinition .
  methods TRLOGSET_GET_ENTITYSET
    redefinition .
  methods TRREQSET_GET_ENTITYSET
    redefinition .
  methods TRSET_GET_ENTITYSET
    redefinition .
  methods CRTRACKERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZCA_TRLOG_ANALYTIC_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: BEGIN OF li_deepstr,
            include TYPE zcl_zca_trlog_analytic_mpc=>ts_header.
    DATA:np_on_sprint TYPE zcl_zca_trlog_analytic_mpc=>tt_items,
         END OF li_deepstr.

    DATA:lst_deepstr LIKE li_deepstr,
         lst_header  TYPE zca_sprint1,
         li_items    TYPE STANDARD TABLE OF zca_sprint2.


    io_data_provider->read_entry_data( IMPORTING es_data = lst_deepstr ).

    lst_header-chgreq     = lst_deepstr-include-chgreq.
    lst_header-sprint     = lst_deepstr-include-sprint.
    lst_header-owner      = lst_deepstr-include-owner.
    lst_header-counter    = lst_deepstr-include-counter.
    lst_header-deploy_dat = lst_deepstr-include-deploy_dat.

    LOOP AT lst_deepstr-np_on_sprint INTO DATA(lst_lineitems).
      APPEND lst_lineitems TO li_items.
    ENDLOOP.

    IF lst_header IS NOT INITIAL.
      MODIFY zca_sprint1 FROM lst_header.

      IF li_items IS NOT INITIAL.
        DELETE li_items WHERE sprint IS INITIAL.
        MODIFY zca_sprint2 FROM TABLE li_items.
      ENDIF.
    ELSE.
      MESSAGE 'No data Updated' TYPE 'I'.
    ENDIF.








  ENDMETHOD.


  METHOD chqvalueset_get_entityset.
**TRY.
*CALL METHOD SUPER->CHQVALUESET_GET_ENTITYSET
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
    SELECT sprint chgreq FROM zca_sprint1 INTO TABLE et_entityset.
    SORT et_entityset BY chgreq.
    delete ADJACENT DUPLICATES FROM et_entityset COMPARING chgreq.
  ENDMETHOD.


  METHOD crtrackerset_create_entity.
    DATA:lst_tracker TYPE zcl_zca_trlog_analytic_mpc=>ts_crtracker.
    FREE:lst_tracker.
    io_data_provider->read_entry_data( IMPORTING es_data = lst_tracker ).
    IF lst_tracker IS NOT INITIAL.
      IF lst_tracker-fs_date IS NOT INITIAL.
        CONCATENATE lst_tracker-fs_date+5(2) '/' "month
                    lst_tracker-fs_date+8(2) '/' "day
                    lst_tracker-fs_date+0(4)     "Year
                    INTO lst_tracker-fs_date.
      ENDIF.
      IF lst_tracker-fut_date IS NOT INITIAL.
        CONCATENATE lst_tracker-fut_date+5(2) '/' "month
                    lst_tracker-fut_date+8(2) '/' "day
                    lst_tracker-fut_date+0(4)     "Year
                    INTO lst_tracker-fut_date.
      ENDIF.
      IF lst_tracker-plan_date IS NOT INITIAL.
        CONCATENATE lst_tracker-plan_date+5(2) '/' "month
                    lst_tracker-plan_date+8(2) '/' "day
                    lst_tracker-plan_date+0(4)     "Year
                    INTO lst_tracker-plan_date.
      ENDIF.
      IF lst_tracker-uat_date IS NOT INITIAL.
        CONCATENATE lst_tracker-uat_date+5(2) '/' "month
                    lst_tracker-uat_date+8(2) '/' "day
                    lst_tracker-uat_date+0(4)     "Year
                    INTO lst_tracker-uat_date.
      ENDIF.
      IF lst_tracker-deploy_dat IS NOT INITIAL.
        CONCATENATE lst_tracker-deploy_dat+5(2) '/' "month
                    lst_tracker-deploy_dat+8(2) '/' "day
                    lst_tracker-deploy_dat+0(4)     "Year
                    INTO lst_tracker-deploy_dat.
      ENDIF.
      IF lst_tracker-actual_date IS NOT INITIAL.
        CONCATENATE lst_tracker-actual_date+5(2) '/' "month
                    lst_tracker-actual_date+8(2) '/' "day
                    lst_tracker-actual_date+0(4)     "Year
                    INTO lst_tracker-actual_date.
      ENDIF.

      MODIFY zca_tracker FROM lst_tracker.
    ENDIF.

  ENDMETHOD.


  METHOD crtrackerset_get_entityset.

    SELECT *
      FROM zca_tracker
      INTO CORRESPONDING FIELDS OF TABLE et_entityset.

  ENDMETHOD.


  method CRTRACKERSET_UPDATE_ENTITY.

  endmethod.


  METHOD epicownerset_get_entityset.
**TRY.
*CALL METHOD SUPER->EPICOWNERSET_GET_ENTITYSET
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
    SELECT owner FROM zca_sprint1 INTO  CORRESPONDING FIELDS OF TABLE et_entityset.
    SORT et_entityset BY owner.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING owner.
  ENDMETHOD.


  method EPICVALUESET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->EPICVALUESET_GET_ENTITYSET
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

     SELECT epic FROM zca_sprint2 INTO TABLE et_entityset.
    SORT et_entityset BY epic.

delete ADJACENT DUPLICATES FROM et_entityset COMPARING epic.


  endmethod.


  METHOD ownerset_get_entityset.
**TRY.
*CALL METHOD SUPER->OWNERSET_GET_ENTITYSET
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


    SELECT * FROM user_addr INTO CORRESPONDING FIELDS OF TABLE et_entityset.

    SORT et_entityset BY name_first.
    DELETE et_entityset WHERE name_first IS INITIAL.
    SORT et_entityset BY bname.
    delete ADJACENT DUPLICATES FROM et_entityset COMPARING bname.



  ENDMETHOD.


  METHOD sprint1set_get_entityset.
    TYPES:BEGIN OF ty_sprint,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE char10,
          END OF ty_sprint.
    DATA: lv_input                  TYPE string,
          lv_name                   TYPE string,
          lv_value                  TYPE string,
          lv_sign                   TYPE string,

          lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
          lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
          ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
          lt_select_options         TYPE /iwbep/t_cod_select_options,
          ls_select_options         TYPE /iwbep/s_cod_select_option,
          ir_date                   TYPE RANGE OF char10, "/hoag/abs_rg_azdat ,
          lst_date                  TYPE /hoag/abs_rg_azdat,
          lst_sprit                 TYPE ty_sprint,
          ir_sprint                 TYPE RANGE OF char10,
          ir_owner                  TYPE RANGE OF char10,
          lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
          ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.
    DATA:lv_sprint TYPE string.
    DATA:lt_filter_string TYPE TABLE OF string,
         lt_sptint        TYPE TABLE OF string.
    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

    FREE:lv_input,
         lv_sprint,
         lt_filter_string,
         lv_value,
         ir_date,
         ir_sprint,
         ir_owner,
         lt_sptint.

    IF   iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

*  * *— build a table of key value pairs based on filter string
      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.
        CONDENSE ls_filter_string.
*       Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_name = 'DeployDat'.
          IF ir_date[] IS INITIAL.
            lst_date-sign   = 'I'.
            lst_date-option = 'BT'.
            CONCATENATE  lv_value+6(2)'/' lv_value+9(2) '/' lv_value+1(4) INTO lv_value.
            lst_date-low    = lv_value.
            APPEND lst_date TO  ir_date[].
          ELSE.
            LOOP AT ir_date[] ASSIGNING FIELD-SYMBOL(<fs_date>).
              CONCATENATE  lv_value+6(2)'/' lv_value+9(2) '/' lv_value+1(4) INTO lv_value.
              <fs_date>-high = lv_value.
            ENDLOOP.
          ENDIF.
        ELSEIF lv_name = 'Sprint' .
          FREE:ir_sprint,lt_sptint.

          DATA(lv_length) = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO DATA(lst_sprint).
            lst_sprit-sign = 'I'.
            lst_sprit-option = 'EQ'.
            lst_sprit-low = lst_sprint.
            APPEND lst_sprit TO ir_sprint.
          ENDLOOP.
        ELSEIF lv_name = 'Owner'.
          FREE:lv_length,lv_sprint,lt_sptint,ir_owner.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            lst_sprit-sign = 'I'.
            lst_sprit-option = 'EQ'.
            lst_sprit-low = lst_sprint.
            APPEND lst_sprit TO ir_owner.
          ENDLOOP.
        ENDIF.
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    SELECT *
      FROM zca_sprint1
      INTO TABLE et_entityset
      WHERE deploy_dat IN ir_date[]
        AND sprint IN ir_sprint
        AND owner  IN ir_owner.

  ENDMETHOD.


  METHOD sprint2set_get_entityset.
    TYPES:BEGIN OF ty_sprint,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE char10,
          END OF ty_sprint.
    DATA: lv_input                  TYPE string,
          lv_name                   TYPE string,
          lv_value                  TYPE string,
          lv_sign                   TYPE string,

          lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
          lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
          ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
          lt_select_options         TYPE /iwbep/t_cod_select_options,
          ls_select_options         TYPE /iwbep/s_cod_select_option,
          ir_date                   TYPE RANGE OF char10, "/hoag/abs_rg_azdat ,
          lst_date                  TYPE /hoag/abs_rg_azdat,
          lst_sprit                 TYPE ty_sprint,
          ir_sprint                 TYPE RANGE OF char10,
          ir_chgreq                 TYPE RANGE OF char10,
          ir_erpm                   TYPE RANGE OF char10,
          lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
          ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.
    DATA:lv_sprint TYPE string.
    DATA:lt_filter_string TYPE TABLE OF string,
         lt_sptint        TYPE TABLE OF string.
    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

    FREE:lv_input,
         lv_sprint,
         lt_filter_string,
         lv_value,
         ir_date,
         ir_sprint,
         ir_chgreq,
         lt_sptint.

    IF   iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

*  * *— build a table of key value pairs based on filter string
      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.
        CONDENSE ls_filter_string.
*       Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_name = 'Sprint' .
          FREE:ir_sprint,lt_sptint.
          DATA(lv_length) = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO DATA(lst_sprint).
            lst_sprit-sign = 'I'.
            lst_sprit-option = 'EQ'.
            lst_sprit-low = lst_sprint.
            APPEND lst_sprit TO ir_sprint.
          ENDLOOP.
        ELSEIF lv_name = 'Chgreq'.
          FREE:lv_length,lv_sprint,lt_sptint,ir_chgreq.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            lst_sprit-sign = 'I'.
            lst_sprit-option = 'EQ'.
            lst_sprit-low = lst_sprint.
            APPEND lst_sprit TO ir_chgreq.
          ENDLOOP.
        ELSEIF lv_name = 'Epic'.
          FREE:lv_length,lv_sprint,lt_sptint,ir_chgreq.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            lst_sprit-sign = 'I'.
            lst_sprit-option = 'EQ'.
            lst_sprit-low = lst_sprint.
            APPEND lst_sprit TO ir_erpm.
          ENDLOOP.
        ENDIF.
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    IF   iv_filter_string IS NOT INITIAL.
      SELECT *
           FROM zca_sprint2
           INTO TABLE et_entityset
        WHERE sprint IN ir_sprint
          AND chgreq IN ir_chgreq
          AND epic  IN ir_erpm.
    ENDIF.

  ENDMETHOD.


  METHOD sprintvalueset_get_entityset.
**TRY.
*CALL METHOD SUPER->SPRINTVALUESET_GET_ENTITYSET
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


    SELECT sprint FROM zca_sprint1 INTO TABLE et_entityset.

delete ADJACENT DUPLICATES FROM et_entityset COMPARING sprint.
  ENDMETHOD.


  METHOD trlogset_get_entityset.


    DATA:li_date  TYPE TABLE OF rsdsselopt,
         li_tr    TYPE TABLE OF rsdsselopt,
         lst_tr   TYPE rsdsselopt,
         li_des   TYPE TABLE OF zqtcr_tr_log_des,
         lst_des  TYPE zqtcr_tr_log_des,
         li_user  TYPE TABLE OF rsdsselopt,
         lst_user TYPE rsdsselopt,
         lst_date TYPE rsdsselopt,
         lv_date  TYPE sy-datum.

    FREE:li_date,
         li_tr,
         lst_tr,
         li_des,
         lst_des,
         li_user,
         lst_user,
         lst_date.

**    READ TABLE it_filter_select_options INTO DATA(lst_sel_options) WITH KEY property = 'Trkorr'.
**    IF sy-subrc = 0.
**      LOOP AT lst_sel_options-select_options INTO DATA(lst_transport).
**        lst_tr-sign   = lst_transport-sign.
**        lst_tr-option = lst_transport-option.
**        lst_tr-low    = lst_transport-low.
**        lst_tr-high   = lst_transport-high.
**        APPEND lst_tr TO li_tr.
**        CLEAR:lst_tr.
**      ENDLOOP.
**    ENDIF.
**
**    FREE:lst_sel_options,lst_transport.
**    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'Date'.
**    IF sy-subrc = 0.
**      LOOP AT lst_sel_options-select_options INTO lst_transport.
**        lst_date-sign   = lst_transport-sign.
**        lst_date-option = lst_transport-option.
**        lst_date-low    = lst_transport-low.
**        lst_date-high   = lst_transport-high.
**        APPEND lst_date TO li_date.
**        CLEAR:lst_date.
**      ENDLOOP.
**    ENDIF.
**    FREE:lst_sel_options,lst_transport.
**    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'As4text'.
**    IF sy-subrc = 0.
**      LOOP AT lst_sel_options-select_options INTO lst_transport.
**        lst_des-sign   = lst_transport-sign.
**        lst_des-option = lst_transport-option.
**        IF lst_transport-low CA '*'.
**          lst_des-option = 'CP'.
**        ENDIF.
**        lst_des-low    = lst_transport-low.
**        lst_des-high   = lst_transport-high.
**        APPEND lst_des TO li_des.
**        CLEAR:lst_des.
**      ENDLOOP.
**    ENDIF.
**    FREE:lst_sel_options,lst_transport.
**    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'As4user'.
**    IF sy-subrc = 0.
**      LOOP AT lst_sel_options-select_options INTO lst_transport.
**        lst_user-sign    = lst_transport-sign.
**        lst_user-option  = lst_transport-option.
**        lst_user-low     = lst_transport-low.
**        lst_user-high    = lst_transport-high.
**        APPEND lst_user TO li_user.
**        CLEAR:lst_user.
**      ENDLOOP.
**    ENDIF.
    DATA:p_ed1 TYPE  oax,
         p_ed2 TYPE  oax,
         p_eq1 TYPE  oax,
         p_eq2 TYPE  oax,
         p_eq3 TYPE  oax,
         p_ep1 TYPE  oax,
         p_es1 TYPE  oax.


    TYPES:BEGIN OF ty_sprint,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE char10,
          END OF ty_sprint.
    DATA: lv_input                  TYPE string,
          lv_name                   TYPE string,
          lv_value                  TYPE string,
          lv_sign                   TYPE string,

          lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
          lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
          ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
          lt_select_options         TYPE /iwbep/t_cod_select_options,
          ls_select_options         TYPE /iwbep/s_cod_select_option,
          ir_date                   TYPE RANGE OF char10, "/hoag/abs_rg_azdat ,
*          //lst_date                  TYPE /hoag/abs_rg_azdat,
          lst_sprit                 TYPE ty_sprint,
          ir_sprint                 TYPE RANGE OF char10,
          ir_chgreq                 TYPE RANGE OF char10,
          ir_erpm                   TYPE RANGE OF char10,
          lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
          ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.
    DATA:lv_sprint TYPE string.
    DATA:lt_filter_string TYPE TABLE OF string,
         lt_sptint        TYPE TABLE OF string.
    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

    FREE:lv_input,
         lv_sprint,
         lt_filter_string,
         lv_value,
         ir_date,
         ir_sprint,
         ir_chgreq,
         lt_sptint.

    IF   iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

*  * *— build a table of key value pairs based on filter string
      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.
        CONDENSE ls_filter_string.
*       Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_name = 'Trkorr' .
          FREE:li_tr,lt_sptint.
          DATA(lv_length) = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO DATA(lst_sprint).
            lst_tr-sign = 'I'.
            lst_tr-option = 'EQ'.
            lst_tr-low = lst_sprint.
            APPEND lst_tr TO li_tr.
          ENDLOOP.

        ELSEIF lv_name = 'Date'.
          IF li_date[] IS INITIAL.
            lst_date-sign   = 'I'.
            lst_date-option = 'BT'.
            CONCATENATE   lv_value+7(4) lv_value+4(2) lv_value+1(2) INTO lv_value.
            lst_date-low    = lv_value.
            APPEND lst_date TO  li_date.
          ELSE.
            LOOP AT li_date[] ASSIGNING FIELD-SYMBOL(<fs_date>).
              CONCATENATE   lv_value+7(4) lv_value+4(2) lv_value+1(2) INTO lv_value.
              <fs_date>-high = lv_value.
            ENDLOOP.
          ENDIF.
        ELSEIF lv_name = 'As4text'.
          FREE:lv_length,lv_sprint,lt_sptint,ir_chgreq,li_des,lst_des.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            lst_des-sign = 'I'.
            lst_des-option = 'CP'.
            CONCATENATE '*' lst_sprint '*' INTO DATA(lv_des).
            lst_des-low = lv_des.
            APPEND lst_des TO li_des.
            CLEAR lst_sprint.
          ENDLOOP.
        ELSEIF lv_name = 'As4user'.
          FREE:lv_length,lv_sprint,lt_sptint,li_user.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            lst_user-sign = 'I'.
            lst_user-option = 'EQ'.
            lst_user-low = lst_sprint.
            APPEND lst_user TO li_user.
          ENDLOOP.
        ELSEIF lv_name = 'Ed1'.
          FREE:lv_length,lv_sprint,lt_sptint.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO lst_sprint.
            IF lst_sprint = 'ED1'.
              p_ed1 = abap_true.
            ENDIF.
            IF lst_sprint = 'ED2'.
              p_ed2 = abap_true.
            ENDIF.
            IF lst_sprint = 'EQ1'.
              p_eq1 = abap_true.
            ENDIF.
            IF lst_sprint = 'EQ2'.
              p_eq2 = abap_true.
            ENDIF.
            IF lst_sprint = 'EP1'.
              p_ep1 = abap_true.
            ENDIF.
            IF lst_sprint = 'ES1'.
              p_es1 = abap_true.
            ENDIF.
            IF lst_sprint = 'EQ3'.
              p_eq3 = abap_true.
            ENDIF.
            DATA(lv_flag) = abap_true.
          ENDLOOP.
        ENDIF.
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

*    IF li_user IS INITIAL
*      AND li_des IS INITIAL
*      AND li_tr IS INITIAL
*      AND li_date IS INITIAL.
*      lst_date-sign   = 'I'.
*      lst_date-option = 'BT'.
*      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
*        EXPORTING
*          i_date = sy-datum
*          i_days = '-15'
*        IMPORTING
*          e_date = lv_date.
*      lst_date-low    =  lv_date .
*      lst_date-high   = sy-datum.
*      APPEND lst_date TO li_date.
*      CLEAR:lst_date.
*      p_ed1 = abap_true.
*      p_eq1 = abap_true.
*      p_ep1 = abap_true.
*      p_es1 = abap_true.
*      p_eq2 = abap_true.
*      p_ed2 = abap_true.
*      p_eq3 = abap_true.
*
*    ENDIF.
    IF  lv_flag = abap_false.
      p_ed1 = abap_true.
      p_eq1 = abap_true.
      p_ep1 = abap_true.
      p_es1 = abap_true.
      p_eq2 = abap_true.
      p_ed2 = abap_true.
      p_eq3 = abap_true.
    ENDIF.

    CALL FUNCTION 'ZQTCR_TR_LOG_RFC_ODATA'
      EXPORTING
        p_ed1    = p_ed1
        p_ed2    = p_ed2
        p_eq1    = p_eq1
        p_eq2    = p_eq2
        p_eq3    = p_eq3
        p_ep1    = p_ep1
        p_es1    = p_es1
      TABLES
        gt_final = et_entityset
        s_trkorr = li_tr
        s_des    = li_des
        s_user   = li_user
        s_date   = li_date.

    CONSTANTS:c_green  TYPE icon_d     VALUE '@08@',   " Green Symbol for Successful to Import
              c_red    TYPE icon_d     VALUE '@0A@',   " Red Symbol for Fail to import
              c_yellow TYPE icon_d     VALUE '@09@'.   " Yellow Symbol for open to import
    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_data>).
      IF <fs_data>-ed1 = c_green .
        <fs_data>-ed1 = 'YES'.
      ELSEIF <fs_data>-ed1 = c_red  .
        <fs_data>-ed1 = 'NO'.
      ELSEIF <fs_data>-ed1 = c_yellow OR <fs_data>-ed1 = space.
        <fs_data>-ed1 = 'BLK'.
      ENDIF.
      IF <fs_data>-ed2 = c_green .
        <fs_data>-ed2 = 'YES'.
      ELSEIF <fs_data>-ed2 = c_red  .
        <fs_data>-ed2 = 'NO'.
      ELSEIF <fs_data>-ed2 = c_yellow OR <fs_data>-ed2 = space.
        <fs_data>-ed2 = 'BLK'.
      ENDIF.
      IF <fs_data>-eq1 = c_green .
        <fs_data>-eq1 = 'YES'.
      ELSEIF <fs_data>-eq1 = c_red  .
        <fs_data>-eq1 = 'NO'.
      ELSEIF <fs_data>-eq1 = c_yellow OR <fs_data>-eq1 = space.
        <fs_data>-eq1 = 'BLK'.
      ENDIF.
      IF <fs_data>-ep1 = c_green .
        <fs_data>-ep1 = 'YES'.
      ELSEIF <fs_data>-ep1 = c_red  .
        <fs_data>-ep1 = 'NO'.
      ELSEIF <fs_data>-ep1 = c_yellow OR <fs_data>-ep1 = space.
        <fs_data>-ep1 = 'BLK'.
      ENDIF.
      IF <fs_data>-eq2 = c_green .
        <fs_data>-eq2 = 'YES'.
      ELSEIF <fs_data>-eq2 = c_red  .
        <fs_data>-eq2 = 'NO'.
      ELSEIF <fs_data>-eq2 = c_yellow OR <fs_data>-eq2 = space.
        <fs_data>-eq2 = 'BLK'.
      ENDIF.
      IF <fs_data>-eq3 = c_green .
        <fs_data>-eq3 = 'YES'.
      ELSEIF <fs_data>-eq3 = c_red  .
        <fs_data>-eq3 = 'NO'.
      ELSEIF <fs_data>-eq3 = c_yellow OR <fs_data>-eq3 = space.
        <fs_data>-eq3 = 'BLK'.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  method TRREQSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->TRREQSET_GET_ENTITYSET
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


  METHOD trset_get_entityset.
    DATA:li_date  TYPE TABLE OF rsdsselopt,
         li_tr    TYPE TABLE OF rsdsselopt,
         lst_tr   TYPE rsdsselopt,
         li_des   TYPE TABLE OF zqtcr_tr_log_des,
         lst_des  TYPE zqtcr_tr_log_des,
         li_user  TYPE TABLE OF rsdsselopt,
         lst_user TYPE rsdsselopt,
         lst_date TYPE rsdsselopt,
         lv_date  TYPE sy-datum.


    FREE:li_date,
         lv_date,
         li_tr,
         lst_tr,
         li_des,
         lst_des,
         li_user,
         lst_user,
         lst_date.
*
*    READ TABLE it_filter_select_options INTO DATA(lst_sel_options) WITH KEY property = 'Trkorr'.
*    IF sy-subrc = 0.
*      LOOP AT lst_sel_options-select_options INTO DATA(lst_transport).
*        lst_tr-sign   = lst_transport-sign.
*        lst_tr-option = lst_transport-option.
*        lst_tr-low    = lst_transport-low.
*        lst_tr-high   = lst_transport-high.
*        APPEND lst_tr TO li_tr.
*        CLEAR:lst_tr.
*      ENDLOOP.
*    ENDIF.
*
*    FREE:lst_sel_options,lst_transport.
*    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'Date'.
*    IF sy-subrc = 0.
*      LOOP AT lst_sel_options-select_options INTO lst_transport.
*        lst_date-sign   = lst_transport-sign.
*        lst_date-option = lst_transport-option.
*        lst_date-low    = lst_transport-low.
*        lst_date-high   = lst_transport-high.
*        APPEND lst_date TO li_date.
*        CLEAR:lst_date.
*      ENDLOOP.
*    ENDIF.
*    FREE:lst_sel_options,lst_transport.
*    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'As4text'.
*    IF sy-subrc = 0.
*      LOOP AT lst_sel_options-select_options INTO lst_transport.
*        lst_des-sign   = lst_transport-sign.
*        lst_des-option = lst_transport-option.
*        IF lst_transport-low CA '*'.
*          lst_des-option = 'CP'.
*        ENDIF.
*        lst_des-low    = lst_transport-low.
*        lst_des-high   = lst_transport-high.
*        APPEND lst_des TO li_des.
*        CLEAR:lst_des.
*      ENDLOOP.
*    ENDIF.
*    FREE:lst_sel_options,lst_transport.
*    READ TABLE it_filter_select_options INTO lst_sel_options WITH KEY property = 'As4user'.
*    IF sy-subrc = 0.
*      LOOP AT lst_sel_options-select_options INTO lst_transport.
*        lst_user-sign    = lst_transport-sign.
*        lst_user-option  = lst_transport-option.
*        lst_user-low     = lst_transport-low.
*        lst_user-high    = lst_transport-high.
*        APPEND lst_user TO li_user.
*        CLEAR:lst_user.
*      ENDLOOP.
*    ENDIF.


 DATA:p_ed1 TYPE  oax,
         p_ed2 TYPE  oax,
         p_eq1 TYPE  oax,
         p_eq2 TYPE  oax,
         p_eq3 TYPE  oax,
         p_ep1 TYPE  oax,
         p_es1 TYPE  oax.


    TYPES:BEGIN OF ty_sprint,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE char10,
          END OF ty_sprint.
    DATA: lv_input                  TYPE string,
          lv_name                   TYPE string,
          lv_value                  TYPE string,
          lv_sign                   TYPE string,

          lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
          lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
          ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
          lt_select_options         TYPE /iwbep/t_cod_select_options,
          ls_select_options         TYPE /iwbep/s_cod_select_option,
          ir_date                   TYPE RANGE OF char10, "/hoag/abs_rg_azdat ,
*          //lst_date                  TYPE /hoag/abs_rg_azdat,
          lst_sprit                 TYPE ty_sprint,
          ir_sprint                 TYPE RANGE OF char10,
          ir_chgreq                 TYPE RANGE OF char10,
          ir_erpm                   TYPE RANGE OF char10,
          lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
          ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.
    DATA:lv_sprint TYPE string.
    DATA:lt_filter_string TYPE TABLE OF string,
         lt_sptint        TYPE TABLE OF string.
    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

    FREE:lv_input,
         lv_sprint,
         lt_filter_string,
         lv_value,
         ir_date,
         ir_sprint,
         ir_chgreq,
         lt_sptint.

    IF   iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

*  * *— build a table of key value pairs based on filter string
      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.
        CONDENSE ls_filter_string.
*       Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_name = 'Date'.
          IF li_date[] IS INITIAL.
            lst_date-sign   = 'I'.
            lst_date-option = 'BT'.
            CONCATENATE   lv_value+7(4) lv_value+4(2) lv_value+1(2) INTO lv_value.
            lst_date-low    = lv_value.
            APPEND lst_date TO  li_date.
          ELSE.
            LOOP AT li_date[] ASSIGNING FIELD-SYMBOL(<fs_date>).
              CONCATENATE   lv_value+7(4) lv_value+4(2) lv_value+1(2) INTO lv_value.
              <fs_date>-high = lv_value.
            ENDLOOP.
          ENDIF.
        ENDIF.
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.
*
*    IF    li_date[] IS INITIAL
*      AND li_des[]  IS INITIAL
*      AND li_user[] IS INITIAL
*      AND li_tr[]   IS INITIAL.
*      lst_date-sign   = 'I'.
*      lst_date-option = 'BT'.
*      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
*        EXPORTING
*          i_date = sy-datum
*          i_days = '-30'
*        IMPORTING
*          e_date = lv_date.
*      lst_date-low    =  lv_date .
*      lst_date-high   = sy-datum.
*      APPEND lst_date TO li_date.
*      CLEAR:lst_date.
*    ENDIF.


    CALL FUNCTION 'ZQTCR_TR_LOG_RFC_ANALYSTIC'
      EXPORTING
        p_ed1        = 'X'
        p_ed2        = 'X'
        p_eq1        = 'X'
        p_eq2        = 'X'
        p_eq3        = 'X'
        p_ep1        = 'X'
        p_es1        = 'X'
      TABLES
        gt_final_cnt = et_entityset
        s_trkorr     = li_tr
        s_des        = li_des
        s_user       = li_user
        s_date       = li_date.

    IF et_entityset IS NOT INITIAL.
      LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_data>).
        IF <fs_data>-date IS NOT INITIAL.
          CONCATENATE <fs_data>-date+4(2) '/'
                      <fs_data>-date+6(2) '/'
                      <fs_data>-date+0(4) INTO <fs_data>-date.
        ENDIF.

        IF <fs_data>-ed1_tot_cnt IS INITIAL.
          <fs_data>-ed1_tot_cnt = '0'.
        ENDIF.
        IF <fs_data>-ep1_tot_cnt IS INITIAL.
          <fs_data>-ep1_tot_cnt = '0'.
        ENDIF.
        IF <fs_data>-ed2_tot_cnt IS INITIAL.
          <fs_data>-ed2_tot_cnt = '0'.
        ENDIF.
        IF <fs_data>-eq1_tot_cnt IS INITIAL.
          <fs_data>-eq1_tot_cnt = '0'.
        ENDIF.
        IF <fs_data>-eq2_tot_cnt IS INITIAL.
          <fs_data>-eq2_tot_cnt = '0'.
        ENDIF.
        <fs_data>-eq2_tot_cnt = <fs_data>-eq2_tot_cnt + <fs_data>-eq1_tot_cnt.
        <fs_data>-ed2_tot_cnt = <fs_data>-ed2_tot_cnt + <fs_data>-ed1_tot_cnt.

      ENDLOOP.
      SORT et_entityset BY date.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
