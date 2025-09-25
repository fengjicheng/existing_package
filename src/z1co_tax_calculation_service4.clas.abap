class Z1CO_TAX_CALCULATION_SERVICE4 definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CALCULATE_TAX
    importing
      !TAX_CALCULATION_REQUEST type Z1TAX_CALCULATION_REQUEST1
    exporting
      !TAX_CALCULATION_RESPONSE type Z1TAX_CALCULATION_RESPONSE1
    raising
      CX_AI_SYSTEM_FAULT
      Z1CX_TAX_CALCULATION_FAULT .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS Z1CO_TAX_CALCULATION_SERVICE4 IMPLEMENTATION.


  method CALCULATE_TAX.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'TAX_CALCULATION_REQUEST'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of TAX_CALCULATION_REQUEST into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'TAX_CALCULATION_RESPONSE'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of TAX_CALCULATION_RESPONSE into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'CALCULATE_TAX'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'Z1CO_TAX_CALCULATION_SERVICE4'
    logical_port_name   = logical_port_name
  ).

  endmethod.
ENDCLASS.
