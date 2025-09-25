*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_REL_ORD_ITM (Include)
* [Called from Sales Orders Data Transfer Routine - 906 (RV45C906)]
* PROGRAM DESCRIPTION: Additional fields for Release Ord Item Data
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       12/07/2017
* OBJECT ID:           E141
* TRANSPORT NUMBER(S): ED2K909765
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:  ED1K908130 / ED2K913295
* REFERENCE NO: RITM0036291
* DEVELOPER:    Himanshu Patel (HIPATEL)
* DATE:         08/03/2018
* DESCRIPTION:  Delivery Plant determination for Release Order.
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
vbap-vkaus = cvbap-vkaus.                        "Usage Indicator
*BOC <HIPATEL> <RITM0036291> <ED1K908130> <08/03/2018>
*Delivery Plant determination for Release Order
vbap-werks = lv_werks.                           "Plant (Own or External)
vbap-vstel = lv_vstel.                           "Shipping Point/Receiving Point
*EOC <HIPATEL> <RITM0036291> <ED1K908130> <08/03/2018>
