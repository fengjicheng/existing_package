class ZCL_BADI_QUOTATION_FIORI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_ODATA_MY_QUOTATION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BADI_QUOTATION_FIORI IMPLEMENTATION.


  METHOD if_badi_odata_my_quotation~preprocess_customer_param.
    "IF cv_parvw IS NOT INITIAL.
    cv_pernr = 123456.
    " cv_parvw = is_app_customizing-parvw.

    ct_rg_vkorg = VALUE #( ( sign = 'I' option = 'EQ' low = '1001' ) ).
    ct_rg_vtweg = VALUE #( ( sign = 'I' option = 'EQ' low = '00' ) ).
    ct_rg_spart = VALUE #( ( sign = 'I' option = 'EQ' low = '00' ) ).
    ct_rg_vkbur = VALUE #( ( sign = 'I' option = 'EQ' low = '0080' ) ).
    ct_rg_kunnr = VALUE #( ( sign = 'I' option = 'EQ' low = '1000016533' ) ).
    "ENDIF.
  ENDMETHOD.
ENDCLASS.
