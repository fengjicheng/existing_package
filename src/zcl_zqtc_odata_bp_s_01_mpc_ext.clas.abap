class ZCL_ZQTC_ODATA_BP_S_01_MPC_EXT definition
  public
  inheriting from ZCL_ZQTC_ODATA_BP_S_01_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZQTC_ODATA_BP_S_01_MPC_EXT IMPLEMENTATION.


  METHOD define.
    DATA:
      lo_action   TYPE REF TO /iwbep/if_mgw_odata_action,

      lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    super->define( ).

    lo_action = model->get_action( iv_action_name = 'ZBP_Search_RPA' ).

    lo_property = lo_action->get_input_parameter( iv_name = 'City' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'Country' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

    lo_property = lo_action->get_input_parameter( iv_name = 'FirstName' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

    lo_property = lo_action->get_input_parameter( iv_name = 'LastName' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'PostalCode' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

    lo_property = lo_action->get_input_parameter( iv_name = 'State' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

    lo_property = lo_action->get_input_parameter( iv_name = 'Email' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'Address2' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'Address3' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'Address1' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).
*
    lo_property = lo_action->get_input_parameter( iv_name = 'Telphone' ).

    lo_property->set_nullable(

    iv_nullable = abap_true

    ).

  ENDMETHOD.
ENDCLASS.
