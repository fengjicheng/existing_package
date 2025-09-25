class ZCL_SRA018_SO_CHANGE_FIORI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SO_USR_TO_CUSTOMER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SRA018_SO_CHANGE_FIORI IMPLEMENTATION.


  method IF_SO_USR_TO_CUSTOMER~GET_CUSTOMERS_FROM_USR.
    SELECT * FROM knvp INTO TABLE @et_customers  UP TO 100 ROWS WHERE vkorg = '1001'
                                                                AND  vtweg = '00'
                                                                AND spart = '00'
                                                                AND parvw = 'AG'
                                                               AND kunnr BETWEEN 1000015520 AND 1000015600 .

  endmethod.
ENDCLASS.
