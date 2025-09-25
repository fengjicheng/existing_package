*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_05 (Include)
*               Called from "USEREXIT_REFRESH_DOCUMENT(MV45AFZA)"
* PROGRAM DESCRIPTION: Recalculate Price for BOM
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08-AUG-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K905792
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910130
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08-JAN-2018
* DESCRIPTION: Avoid multiple calls for Pricing fields determination
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
CLEAR: st_tvcpa.                            "Sales Documents: Copying Control
* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
CLEAR: i_prt_rel.
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
