FUNCTION zqtc_set_tax_data_ips_i0353.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_TAX_CODE) TYPE  MWSKZ OPTIONAL
*"     REFERENCE(IM_TXJCD) TYPE  AD_TXJCD OPTIONAL
*"     REFERENCE(IM_VEND_COUNTRY) TYPE  LAND1 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SET_TAX_DATA_IPS_I0353
* PROGRAM DESCRIPTION: Function module to set tax code and tax jurisdiction
*                      code to global variables
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

  CLEAR : v_tax_code,
          v_txjcd,
          v_vend_country.


  IF im_tax_code IS NOT INITIAL.
    v_tax_code = im_tax_code.
  ENDIF. " IF im_tax_code IS NOT INITIAL
  IF im_txjcd IS NOT INITIAL.
    v_txjcd = im_txjcd.
  ENDIF. " IF im_txjcd IS NOT INITIAL
  IF im_vend_country IS NOT INITIAL.
    v_vend_country = im_vend_country.
  ENDIF. " IF im_vend_country IS NOT INITIAL



ENDFUNCTION.
