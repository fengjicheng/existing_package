class ZCL_ZQTC_BP_SERACH_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_BP_SERACH_DPC
  create public .

public section.
protected section.

  methods IMPORTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_BP_SERACH_DPC_EXT IMPLEMENTATION.


  METHOD importset_get_entityset.
*    DATA:lv_email        TYPE bapibus1006_comm-e_mail,
*         li_searchresult TYPE STANDARD TABLE OF  bapibus1006_bp_addr,
*         li_return       TYPE STANDARD TABLE OF  bapiret2.
*
*    LOOP AT et_entityset INTO DATA(lst_entityset).
*      lv_email = lst_entityset-e_mail.
*      CALL FUNCTION 'BAPI_BUPA_SEARCH_2'
*        EXPORTING
**         TELEPHONE    =
*          email        = lv_email
**         URL          =
**         ADDRESSDATA  =
**         CENTRALDATA  =
**         BUSINESSPARTNERROLECATEGORY       =
**         ALL_BUSINESSPARTNERROLES          =
**         BUSINESSPARTNERROLE               =
**         COUNTRY_FOR_TELEPHONE             =
**         FAX_DATA     =
**         VALID_DATE   =
**         OTHERS       =
**         IV_REQ_MASK  = 'X'
*        TABLES
*          searchresult = TT_EXPORT
*          return       = li_return.
*    ENDLOOP.



**TRY.
*CALL METHOD SUPER->IMPORTSET_GET_ENTITYSET
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



  ENDMETHOD.
ENDCLASS.
