class YCL_YTEST_CHARM_ODATA_DPC_EXT definition
  public
  inheriting from YCL_YTEST_CHARM_ODATA_DPC
  create public .

public section.
protected section.

  methods YTEST_CHARMSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS YCL_YTEST_CHARM_ODATA_DPC_EXT IMPLEMENTATION.


  method YTEST_CHARMSET_GET_ENTITYSET.


SELECT devid
            param1
            param2
            srno
            sign
            opti
            low
            high
            INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET
            FROM zcaconstant
            WHERE devid = 'I0389'
              AND activate = abap_true.
  endmethod.
ENDCLASS.
