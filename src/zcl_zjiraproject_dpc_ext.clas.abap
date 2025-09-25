class ZCL_ZJIRAPROJECT_DPC_EXT definition
  public
  inheriting from ZCL_ZJIRAPROJECT_DPC
  create public .

public section.
protected section.

  methods JIRASET_GET_ENTITYSET
    redefinition .
  methods JIRADETAILSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZJIRAPROJECT_DPC_EXT IMPLEMENTATION.


  method JIRADETAILSSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->JIRADETAILSSET_GET_ENTITYSET
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
*DATA : ls_jira type zcl_zjiraproject_mpc=>ts_jiradetails,
     Data lt_jira_det TYPE zcl_zjiraproject_mpc=>tt_jiradetails.

    select * from zjira_sprint_det into CORRESPONDING FIELDS OF TABLE lt_jira_det where (iv_filter_string).

      APPEND LINES OF lt_jira_det TO et_entityset.

  endmethod.


  method JIRASET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->JIRASET_GET_ENTITYSET
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
*    DATA : ls_jira type zcl_zjiraproject_mpc=>ts_jira,
     DATA lt_jira TYPE zcl_zjiraproject_mpc=>tt_jira.

    select * from zjira_sprint into CORRESPONDING FIELDS OF TABLE lt_jira where (iv_filter_string).
     APPEND LINES OF lt_jira to et_entityset.







  endmethod.
ENDCLASS.
