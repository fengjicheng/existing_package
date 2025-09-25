class ZCL_IM_QTCEI_GOODSMOVEMENT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_GOODSMOVEMENT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCEI_GOODSMOVEMENT IMPLEMENTATION.


  method IF_EX_LE_SHP_GOODSMOVEMENT~CHANGE_INPUT_HEADER_AND_ITEMS.
   BREAK SISIREDDY.
  endmethod.
ENDCLASS.
