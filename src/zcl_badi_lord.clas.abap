class ZCL_BADI_LORD definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_LORD_APPL_ACTIVE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BADI_LORD IMPLEMENTATION.


  METHOD if_badi_lord_appl_active~is_appl_active.
    IF 1 = 2.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
