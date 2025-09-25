class ZCL_IM_QTCBI_EXT_US_TAXES definition
  public
  final
  create public .

public section.

  interfaces IF_EX_EXTENSION_US_TAXES .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCBI_EXT_US_TAXES IMPLEMENTATION.


  method IF_EX_EXTENSION_US_TAXES~ME_CALCUL_SRV_TAX.
  endmethod.


  method IF_EX_EXTENSION_US_TAXES~ME_TAXCOM_MEPO.
  endmethod.


  method IF_EX_EXTENSION_US_TAXES~MM_DATA_FOR_TAX_SYSTEM.
  endmethod.


  METHOD if_ex_extension_us_taxes~mm_item_tax_modify.

    INCLUDE /idt/badi_liv_ex_us_tax_item.

  ENDMETHOD.


  method IF_EX_EXTENSION_US_TAXES~MS_TAX_DATA_LIMITS.
  endmethod.


  METHOD if_ex_extension_us_taxes~ms_tax_data_services.

    INCLUDE /idt/badi_ses_ex_us_tax.

  ENDMETHOD.


  method IF_EX_EXTENSION_US_TAXES~MS_TRIGGER_PRICING.
  endmethod.
ENDCLASS.
