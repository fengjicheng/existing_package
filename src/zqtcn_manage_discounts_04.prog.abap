*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_04 (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(RV60AFZZ)"
* PROGRAM DESCRIPTION: Populate Item Category
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   17-JUL-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K907319
*----------------------------------------------------------------------*
IF tkomp-zzpstyv IS INITIAL.
  tkomp-zzpstyv = vbrp-pstyv.       " Sales document item category
ENDIF.
