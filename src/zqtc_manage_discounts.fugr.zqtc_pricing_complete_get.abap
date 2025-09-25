*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PRICING_COMPLETE_GET (Function Module)
* PROGRAM DESCRIPTION: Global Attributes during Complete Pricing (Get)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAR-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911494
*----------------------------------------------------------------------*
FUNCTION zqtc_pricing_complete_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_REFRESH) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_TKOMP) TYPE  VA_KOMP_T
*"----------------------------------------------------------------------

  ex_tkomp[] = i_tkomp[].                        "Communication Item for Pricing

  IF im_refresh IS NOT INITIAL.
    CLEAR: i_tkomp.
  ENDIF.

ENDFUNCTION.
