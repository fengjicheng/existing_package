*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PRICING_COMPLETE_SET (Function Module)
* PROGRAM DESCRIPTION: Global Attributes during Complete Pricing (Set)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAR-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911494
*----------------------------------------------------------------------*
FUNCTION zqtc_pricing_complete_set.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_TKOMP) TYPE  VA_KOMP_T
*"----------------------------------------------------------------------

  i_tkomp[] = im_tkomp[].                        "Communication Item for Pricing

ENDFUNCTION.
