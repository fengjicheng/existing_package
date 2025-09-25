class ZCL_ZLW_SALESDATA_DPC_EXT definition
  public
  inheriting from ZCL_ZLW_SALESDATA_DPC
  create public .

public section.
protected section.

  methods SALESHEADERDATAS_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLW_SALESDATA_DPC_EXT IMPLEMENTATION.


  method SALESHEADERDATAS_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->SALESHEADERDATAS_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.
ENDCLASS.
