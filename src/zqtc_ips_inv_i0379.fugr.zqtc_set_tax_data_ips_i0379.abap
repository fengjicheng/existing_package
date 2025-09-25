FUNCTION zqtc_set_tax_data_ips_i0379.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_TAX_CODE) TYPE  MWSKZ OPTIONAL
*"     REFERENCE(IM_TXJCD) TYPE  AD_TXJCD OPTIONAL
*"     REFERENCE(IM_VEND_COUNTRY) TYPE  LAND1 OPTIONAL
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTC_SET_TAX_DATA_IPS_I0379
* PROGRAM DESCRIPTION: Function module to set tax code and tax jurisdiction
*                      code to global variables
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

  CLEAR : v1_tax_code,
          v1_txjcd,
          v1_vend_country.


  IF im_tax_code IS NOT INITIAL.
    v1_tax_code = im_tax_code.
  ENDIF. " IF im_tax_code IS NOT INITIAL
  IF im_txjcd IS NOT INITIAL.
    v1_txjcd = im_txjcd.
  ENDIF. " IF im_txjcd IS NOT INITIAL
  IF im_vend_country IS NOT INITIAL.
    v1_vend_country = im_vend_country.
  ENDIF. " IF im_vend_country IS NOT INITIAL



ENDFUNCTION.
