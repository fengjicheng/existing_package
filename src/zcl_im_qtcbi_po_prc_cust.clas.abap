class ZCL_IM_QTCBI_PO_PRC_CUST definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_PO_PRICING_CUST .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCBI_PO_PRC_CUST IMPLEMENTATION.


  METHOD if_ex_me_po_pricing_cust~process_komk.

    INCLUDE /idt/purchasing_badi_komk.

  ENDMETHOD.


  METHOD if_ex_me_po_pricing_cust~process_komp.

    INCLUDE /idt/purchasing_badi_komp.

  ENDMETHOD.
ENDCLASS.
