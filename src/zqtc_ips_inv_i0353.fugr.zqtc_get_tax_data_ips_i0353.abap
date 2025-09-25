FUNCTION zqtc_get_tax_data_ips_i0353.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_TAX_CODE) TYPE  MWSKZ
*"     REFERENCE(EX_TXJCD) TYPE  AD_TXJCD
*"     REFERENCE(EX_VEND_COUNTRY) TYPE  LAND1
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_GET_TAX_DATA_IPS_I0353
* PROGRAM DESCRIPTION: Function module to get tax code and tax jurisdiction
*                      code from global variables
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

  ex_tax_code = v_tax_code.
  ex_txjcd = v_txjcd.
  ex_vend_country = v_vend_country.

ENDFUNCTION.
