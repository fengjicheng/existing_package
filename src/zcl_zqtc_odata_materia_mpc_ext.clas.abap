class ZCL_ZQTC_ODATA_MATERIA_MPC_EXT definition
  public
  inheriting from ZCL_ZQTC_ODATA_MATERIA_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZQTC_ODATA_MATERIA_MPC_EXT IMPLEMENTATION.


  method DEFINE.
    DATA:lo_action   TYPE REF TO /iwbep/if_mgw_odata_action,
         lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    super->define( ).

    lo_action = model->get_action( iv_action_name = 'ZMAT' ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Material' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Extent' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'ExtentUoM' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Length' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Width' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Thickness' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'DimensionUoM' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Volume' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'VolumeUoM' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'NetWeight' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'GrossWeight' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'WeightUoM' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'WeightofPaper' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Paperwtcommonpart' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

    lo_property = lo_action->get_input_parameter( iv_name = 'LeafWeightUoM' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

  endmethod.
ENDCLASS.
