class ZCL_SRA017_SO_CREATE_FIORI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SRA017_USER_TO_CUSTOMER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SRA017_SO_CREATE_FIORI IMPLEMENTATION.


  METHOD if_sra017_user_to_customer~get_customers_from_user.

    SELECT * FROM knvp INTO TABLE @et_customers  WHERE vkorg = '1001'
                                                                AND  vtweg = '00'
                                                                AND spart = '00'
                                                                AND parvw = 'AG'
                                                               AND kunnr BETWEEN 1000015520 AND 1000015600 .
  ENDMETHOD.
ENDCLASS.
