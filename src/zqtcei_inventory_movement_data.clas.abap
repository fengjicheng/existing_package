class ZQTCEI_INVENTORY_MOVEMENT_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_GOODSMOVEMENT .
protected section.
private section.
ENDCLASS.



CLASS ZQTCEI_INVENTORY_MOVEMENT_DATA IMPLEMENTATION.


  METHOD if_ex_le_shp_goodsmovement~change_input_header_and_items.
    break sisireddy.
  ENDMETHOD.
ENDCLASS.
