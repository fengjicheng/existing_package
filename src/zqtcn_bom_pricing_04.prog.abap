*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_04 (Include)
*               Called from "USEREXIT_CHECK_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: Recalculate Price for BOM
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08-AUG-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K905792
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
IF tvcpa IS NOT INITIAL.
  st_tvcpa = tvcpa.                         "Sales Documents: Copying Control
ENDIF.
