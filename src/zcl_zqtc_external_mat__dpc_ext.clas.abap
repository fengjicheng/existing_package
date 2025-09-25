class ZCL_ZQTC_EXTERNAL_MAT__DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_EXTERNAL_MAT__DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY
    redefinition .
protected section.

  methods MAT_GROUPSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_EXTERNAL_MAT__DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD mat_groupset_get_entityset.
    DATA:lv_extwg   TYPE extwg,
         lv_ewbez   TYPE ewbez,
         lst_entity TYPE zcl_zqtc_external_mat__mpc=>ts_mat_group,
         lst_return TYPE bapiret2.
    LOOP     AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Extwg'.  " External Material Group
            lv_extwg = <ls_filter_opt>-low.
            IF lv_extwg EQ 'null'.
              CLEAR lv_extwg.
            ENDIF.
          WHEN 'Ewbez'.  " External Material Group text
            lv_ewbez = <ls_filter_opt>-low.
            IF lv_ewbez EQ 'null'.
              CLEAR lv_ewbez.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lv_extwg IS NOT INITIAL .
      CALL FUNCTION 'ZQTC_IF_CHECK_EXTWG'
        EXPORTING
          im_extwg  = lv_extwg
          im_ewbez  = lv_ewbez
        IMPORTING
          ex_return = lst_return.
      lst_entity-ewbez      = lv_ewbez.
      lst_entity-extwg      = lv_extwg.
      lst_entity-bapi_mtype = lst_return-type.
      lst_entity-bapi_msg   = lst_return-message.
      APPEND lst_entity TO et_entityset.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
