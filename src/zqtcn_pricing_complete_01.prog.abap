*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_PRICING_COMPLETE_01 (Include)
* PROGRAM DESCRIPTION: Store Global Attributes during Complete Pricing
*                      [Internal Table TKOMP will be needed for the
*                      logic BOM Price Allocation (specifically when
*                      Promo Code is applied)]
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAR-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911494
*----------------------------------------------------------------------*
* Populate Global Attributes during Complete Pricing
CALL FUNCTION 'ZQTC_PRICING_COMPLETE_SET'
  EXPORTING
    im_tkomp = tkomp[].                     "Communication Item for Pricing
