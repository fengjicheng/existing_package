class ZQTCCL_FARRIC_BADI_ORDER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_FARRIC_ORDER .
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_FARRIC_BADI_ORDER IMPLEMENTATION.


  method IF_FARRIC_ORDER~CLEAR_RELTYPE_FLAG.
    break modutta.
  endmethod.
ENDCLASS.
