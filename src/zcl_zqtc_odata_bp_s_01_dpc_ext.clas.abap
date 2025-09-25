class ZCL_ZQTC_ODATA_BP_S_01_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_ODATA_BP_S_01_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods ZBPSEARCHSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_ODATA_BP_S_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918920
* REFERENCE NO: ERPM-22299
* DEVELOPER:  Lahiru Wathudura(LWATHUDURA)
* WRICEF ID : I0387
* DATE: 07/22/2020
* DESCRIPTION:  Extend the BP search functionality considering
*               the Input source as RPA and IF source is RPA avoid the BP Creation
*&---------------------------------------------------------------------*
    DATA : lst_parameter TYPE /iwbep/s_mgw_name_value_pair,
           lst_bpsearch  TYPE zcl_zqtc_odata_bp_s_01_mpc=>ts_zbpsearch,
           li_bp_out     TYPE zcl_zqtc_odata_bp_s_01_mpc=>tt_zbpsearch.

    DATA : lt_inputdata TYPE STANDARD TABLE OF zsqtc_bp_update,     " Itab for FM input table
           li_bp_result TYPE ztqtc_bpsearch.

    FIELD-SYMBOLS : <lfs_parameter> TYPE /iwbep/s_mgw_name_value_pair.

    CONSTANTS : lc_action_rpa TYPE string VALUE 'ZBP_Search_RPA',         " Action Name
                lc_source     TYPE tpm_source_name VALUE 'RPA',           " Source Name
                lc_i0387      TYPE zdevid VALUE 'I0387',                  " WRICEF ID
                lc_firstname  TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'FirstName',
                lc_lastname   TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'LastName',
                lc_address1   TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Address1',
                lc_address2   TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Address2',
                lc_address3   TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Address3',
                lc_city       TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'City',
                lc_postalcode TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'PostalCode',
                lc_state      TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'State',
                lc_country    TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Country',
                lc_email      TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Email',
                lc_tel        TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Telephone'.

    CASE iv_action_name.
      WHEN lc_action_rpa.   " action is equal to ZBP_Search_RPA then call the FM to Search the relevant data
        IF it_parameter IS NOT INITIAL.     " request Parameter table In not null
          " Add new record line for FM passing data table
          APPEND INITIAL LINE TO lt_inputdata ASSIGNING FIELD-SYMBOL(<lfs_inputdata>).
          LOOP AT it_parameter ASSIGNING <lfs_parameter>.
            CASE <lfs_parameter>-name.
              WHEN lc_firstname.                                    " First Name
                <lfs_inputdata>-name_f = <lfs_parameter>-value.
              WHEN lc_lastname.                                     " Last Name
                <lfs_inputdata>-name_l = <lfs_parameter>-value.
              WHEN lc_address1.
                <lfs_inputdata>-street = <lfs_parameter>-value.     " Street
              WHEN lc_address2.                                     "
                "<lfs_inputdata>-name_l = <lfs_parameter>-value.
              WHEN lc_address3.                                     "
                "<lfs_inputdata>-name_l = <lfs_parameter>-value.
              WHEN lc_city.                                         " City
                <lfs_inputdata>-city1 = <lfs_parameter>-value.
              WHEN lc_postalcode.                                   " Postal code
                <lfs_inputdata>-post_code1 = <lfs_parameter>-value.
              WHEN lc_state.                                        " State
                <lfs_inputdata>-region = <lfs_parameter>-value.
              WHEN lc_country.                                      " Country
                <lfs_inputdata>-country = <lfs_parameter>-value.
              WHEN lc_email.                                        " email
                <lfs_inputdata>-smtp_addr = <lfs_parameter>-value.
              WHEN lc_tel.                                          " Telephone
                <lfs_inputdata>-tel_number = <lfs_parameter>-value.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.

          " Call BP Search FM
          CALL FUNCTION 'ZQTC_BP_SEARCH_CREATE_E225'
            EXPORTING
              im_source   = lc_source       " Source name
              im_devid    = lc_i0387        " RPA Interface WRICEFID
            IMPORTING
              ex_bpsearch = li_bp_result     " RPA Source related search result output parameter
            TABLES
              t_file      = lt_inputdata.     " Input data table for Search processing

          " Build Final output table for response
          LOOP AT li_bp_result ASSIGNING FIELD-SYMBOL(<lfs_bpresult>).
            lst_bpsearch-msg_type = <lfs_bpresult>-msg_type.            " Message type
            lst_bpsearch-msg_number = <lfs_bpresult>-msg_number.        " Message Number
            lst_bpsearch-message = <lfs_bpresult>-msg_text.             " Message text
            APPEND lst_bpsearch TO li_bp_out.                           " Append data to the response
            CLEAR lst_bpsearch.
          ENDLOOP.
        ENDIF.
    ENDCASE.

*    CASE iv_action_name.
*      WHEN  'ZBP_Search_RPA'.
*
*      WHEN OTHERS.
*    ENDCASE.
*
*    lst_bpsearch-msg_type = ' '.
*    lst_bpsearch-msg_number = 'RPA_000'.
*    lst_bpsearch-message = 'Generic message'.
*    APPEND lst_bpsearch TO li_bp_out.
*    CLEAR lst_bpsearch.
***
**    lst_bpsearch-bp = '1000034955'.
*    lst_bpsearch-msg_type = 'S'.
*    lst_bpsearch-msg_number = 'RPA_001'.
*    lst_bpsearch-message = 'BP# 1234567891 identified'.
*    APPEND lst_bpsearch TO li_bp_out.
*    CLEAR lst_bpsearch.
**
**    lst_bpsearch-bp = '1000034955'.
*    lst_bpsearch-msg_number = 'RPA_002'.
*    lst_bpsearch-message = '10010000 Sales Area'.
*    lst_bpsearch-msg_type = 'I'.
*    APPEND lst_bpsearch TO li_bp_out.
*    CLEAR lst_bpsearch.
**
**    lst_bpsearch-msg_type = 'I'.
*    lst_bpsearch-msg_number = 'RPA_002'.
*    lst_bpsearch-message = '31000000 Sales Area'.
*    lst_bpsearch-msg_type = 'I'.
*    APPEND lst_bpsearch TO li_bp_out.
*    CLEAR lst_bpsearch.
*
    " Assign data to the response
    copy_data_to_ref( EXPORTING is_data = li_bp_out
                      CHANGING cr_data = er_data ).
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    iv_action_name          =
**    it_parameter            =
**    io_tech_request_context =
**  IMPORTING
**    er_data                 =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD zbpsearchset_get_entityset.

*TRY.
*CALL METHOD SUPER->ZBPSEARCHSET_GET_ENTITYSET
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
*    io_tech_request_context  =
*  IMPORTING
*    et_entityset             =
*    es_response_context      =
*    .
* CATCH /iwbep/cx_mgw_busi_exception .
* CATCH /iwbep/cx_mgw_tech_exception .
*ENDTRY.

*    DATA : lst_bpsearch TYPE zcl_zqtc_odata_bp_s_01_mpc=>ts_zbpsearch.
*
*    lst_bpsearch-msg_type = 'S'.
*    lst_bpsearch-msg_number = 'RPA_001'.
*    lst_bpsearch-message = 'Call is successful'.
*    APPEND lst_bpsearch TO et_entityset.
*    CLEAR lst_bpsearch.
*
*    lst_bpsearch-bp = '1000034955'.
*    lst_bpsearch-msg_type = 'S'.
*    lst_bpsearch-msg_number = 'RPA_002'.
*    lst_bpsearch-message = 'BP Identified'.
*    APPEND lst_bpsearch TO et_entityset.
*    CLEAR lst_bpsearch.
*
*    lst_bpsearch-bp = '1000034955'.
*    lst_bpsearch-vkorg = '1001'.
*    lst_bpsearch-vtweg = '00'.
*    lst_bpsearch-spart = '00'.
*    lst_bpsearch-msg_type = 'S'.
*    lst_bpsearch-msg_number = 'RPA_003'.
*    lst_bpsearch-message = 'BP Identified with sales area'.
*    APPEND lst_bpsearch TO et_entityset.
*    CLEAR lst_bpsearch.
*
*    lst_bpsearch-msg_type = 'I'.
*    lst_bpsearch-msg_number = 'RPA_004'.
*    lst_bpsearch-message = 'No BP Found in BP Search'.
*    APPEND lst_bpsearch TO et_entityset.
*    CLEAR lst_bpsearch.
  ENDMETHOD.
ENDCLASS.
