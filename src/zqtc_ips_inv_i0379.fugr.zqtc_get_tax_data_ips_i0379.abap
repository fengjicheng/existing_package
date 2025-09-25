FUNCTION zqtc_get_tax_data_ips_i0379.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_TAX_CODE) TYPE  MWSKZ
*"     REFERENCE(EX_TXJCD) TYPE  AD_TXJCD
*"     REFERENCE(EX_VEND_COUNTRY) TYPE  LAND1
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_GET_TAX_DATA_IPS_I0353
* PROGRAM DESCRIPTION: Function module to get tax code and tax jurisdiction
*                      code from global variables
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

  ex_tax_code = v1_tax_code.
  ex_txjcd = v1_txjcd.
  ex_vend_country = v1_vend_country.

ENDFUNCTION.
