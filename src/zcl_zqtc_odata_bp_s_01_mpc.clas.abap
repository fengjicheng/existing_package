class ZCL_ZQTC_ODATA_BP_S_01_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
    begin of TS_ZBP_SEARCH_RPA,
        BU_NAMEP_F type C length 40,
        BU_NAMEP_L type C length 40,
        AD_STREET type C length 60,
        AD_STRSPP1 type C length 40,
        AD_STRSPP2 type C length 40,
        AD_CITY1 type C length 40,
        AD_PSTCD1 type C length 10,
        REGIO type C length 3,
        LAND1 type C length 3,
        AD_SMTPADR type C length 241,
        AD_TLNMBR1 type C length 30,
    end of TS_ZBP_SEARCH_RPA .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol .
  types:
  begin of TS_ZBPSEARCH,
     MSG_NUMBER type C length 20,
     MESSAGE type C length 220,
     MSG_TYPE type C length 1,
  end of TS_ZBPSEARCH .
  types:
TT_ZBPSEARCH type standard table of TS_ZBPSEARCH .

  constants GC_ZBPSEARCH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZBPSearch' ##NO_TEXT.

  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  constants GC_INCL_NAME type STRING value 'ZCL_ZQTC_ODATA_BP_S_01_MPC====CP' ##NO_TEXT.

  methods DEFINE_ZBPSEARCH
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ACTIONS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZQTC_ODATA_BP_S_01_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZQTC_ODATA_BP_SERACH_RPA_SRV' ).

define_zbpsearch( ).
define_actions( ).
  endmethod.


  method DEFINE_ACTIONS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
lo_action         type ref to /iwbep/if_mgw_odata_action,                 "#EC NEEDED
lo_parameter      type ref to /iwbep/if_mgw_odata_parameter.              "#EC NEEDED

***********************************************************************************************************************************
*   ACTION - ZBP_Search_RPA
***********************************************************************************************************************************

lo_action = model->create_action( 'ZBP_Search_RPA' ).  "#EC NOTEXT
*Set return entity type
lo_action->set_return_entity_type( 'ZBPSearch' ). "#EC NOTEXT
*Set HTTP method GET or POST
lo_action->set_http_method( 'GET' ). "#EC NOTEXT
*Set the action for entity
lo_action->set_action_for( 'ZBPSearch' ).        "#EC NOTEXT
* Set return type multiplicity
lo_action->set_return_multiplicity( 'M' ). "#EC NOTEXT
***********************************************************************************************************************************
* Parameters
***********************************************************************************************************************************

lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'FirstName'    iv_abap_fieldname = 'BU_NAMEP_F' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '035' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'LastName'    iv_abap_fieldname = 'BU_NAMEP_L' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '036' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Address1'    iv_abap_fieldname = 'AD_STREET' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '037' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 60 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Address2'    iv_abap_fieldname = 'AD_STRSPP1' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '038' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Address3'    iv_abap_fieldname = 'AD_STRSPP2' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '039' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'City'    iv_abap_fieldname = 'AD_CITY1' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '040' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'PostalCode'    iv_abap_fieldname = 'AD_PSTCD1' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '041' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'State'    iv_abap_fieldname = 'REGIO' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '042' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Country'    iv_abap_fieldname = 'LAND1' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '043' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Email'    iv_abap_fieldname = 'AD_SMTPADR' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '044' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 241 ). "#EC NOTEXT
lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Telphone'    iv_abap_fieldname = 'AD_TLNMBR1' ). "#EC NOTEXT
lo_parameter->set_label_from_text_element( iv_text_element_symbol = '045' iv_text_element_container = gc_incl_name ). "#EC NOTEXT
lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
lo_parameter->set_maxlength( iv_max_length = 30 ). "#EC NOTEXT
lo_action->bind_input_structure( iv_structure_name  = 'ZCL_ZQTC_ODATA_BP_S_01_MPC=>TS_ZBP_SEARCH_RPA' ). "#EC NOTEXT
  endmethod.


  method DEFINE_ZBPSEARCH.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - ZBPSearch
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'ZBPSearch' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'MsgNumber' iv_abap_fieldname = 'MSG_NUMBER' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '019' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 20 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Message' iv_abap_fieldname = 'MESSAGE' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '020' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 220 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'MsgType' iv_abap_fieldname = 'MSG_TYPE' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '018' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZQTC_ODATA_BP_S_01_MPC=>TS_ZBPSEARCH' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ZBPSearchSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20200727161539'.                  "#EC NOTEXT
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
     ls_text_element TYPE ts_text_element.                                 "#EC NEEDED


clear ls_text_element.
ls_text_element-artifact_name          = 'MsgNumber'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBPSearch'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '019'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Message'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBPSearch'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '020'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'MsgType'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBPSearch'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '018'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.


clear ls_text_element.
ls_text_element-artifact_name          = 'FirstName'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '035'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'LastName'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '036'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Address1'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '037'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Address2'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '038'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Address3'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '039'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'City'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '040'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'PostalCode'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '041'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'State'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '042'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Country'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '043'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Email'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '044'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'Telphone'.                               "#EC NOTEXT
ls_text_element-artifact_type          = 'FIPA'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'FIMP'.                                                "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ZBP_Search_RPA'.                                      "#EC NOTEXT
ls_text_element-text_symbol            = '045'.                            "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
  endmethod.
ENDCLASS.
