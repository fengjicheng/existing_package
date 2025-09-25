class ZCL_SDPRCLST_IMPL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_PIQ_SDPRICELIST .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SDPRCLST_IMPL IMPLEMENTATION.


  method IF_BADI_PIQ_SDPRICELIST~GET_CUSTOMER_DATA.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~GET_MATERIAL_DATA.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~IS_MAPPING_OF_OUTPUT_COL_ACT.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~MAP_OUTPUT_COLUMNS.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~PREPARE_PRICING.
    INCLUDE zqtcn_memberprice_calc.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~PROCESS_CUSTOMER_EMAIL.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~PROCESS_RESULT.
* Include to pupulate Society Member info
    INCLUDE zqtcn_memberprice_vnln_op.
  endmethod.


  method IF_BADI_PIQ_SDPRICELIST~PROVIDE_EMAIL_TEXT_NAME.
  endmethod.
ENDCLASS.
