class ZCL_ZQTC_JP28_MPC_EXT definition
  public
  inheriting from ZCL_ZQTC_JP28_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZQTC_JP28_MPC_EXT IMPLEMENTATION.


  method DEFINE.
        DATA:
      lo_action   TYPE REF TO /iwbep/if_mgw_odata_action,

      lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    super->define( ).

    lo_action = model->get_action( iv_action_name = 'ZMaterial_Inputs_Update' ).


        lo_property = lo_action->get_input_parameter( iv_name = 'Weight' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

  endmethod.
ENDCLASS.
