*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_02 (Include)
*               Called from "USEREXIT_NEW_PRICING_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: Re-trigger Pricing
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-DEC-2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905792
* REFERENCE NO: ERP-2500
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01-JUN-2017
* DESCRIPTION: Re-trigger Pricing for Usage Indicator
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907778
* REFERENCE NO: CR#615
* DEVELOPER: Writtick Roy (WROY)
* DATE:  07-AUG-2017
* DESCRIPTION: Re-trigger Pricing for Material Pricing Group
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910415
* REFERENCE NO: ERP-5789/ERP-6075
* DEVELOPER: Writtick Roy (WROY)
* DATE:  22-JAN-2018
* DESCRIPTION: Re-trigger Pricing for Item Category
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907497
* REFERENCE NO:  E075 (RITM0028165)
* DEVELOPER: Sayantan Das(SAYANDAS)
* DATE:  2018-05-25
* DESCRIPTION: Re-trigger Pricing when Ship-to Party is changed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907969
* REFERENCE NO:  INC0202391
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-07-13
* DESCRIPTION: Re-trigger Pricing when Quantity is changed
*----------------------------------------------------------------------*
CONSTANTS:
  lc_prc_type_c  TYPE knprs      VALUE 'C'.           " Pricing Type: C

IF vbap-zzpromo NE *vbap-zzpromo.                     " Promo code
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.

IF vbap-vkaus NE *vbap-vkaus.                         " Usage Indicator
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.

* Begin of ADD:CR#615:WROY:07-AUG-2017:ED2K907778
IF vbap-kondm NE *vbap-kondm.                         " Material Pricing Group
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.
* End   of ADD:CR#615:WROY:07-AUG-2017:ED2K907778

* Begin of ADD:ERP-5789/ERP-6075:WROY:22-JAN-2018:ED2K910415
IF vbap-pstyv NE *vbap-pstyv.                         " Item Category
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.
* End   of ADD:ERP-5789/ERP-6075:WROY:22-JAN-2018:ED2K910415

* Begin of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
IF rv02p-weupd EQ abap_true. " Ship-to Party is changed
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.
* End   of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497

* Begin of ADD:INC0202391:WROY:13-JUL-2018:ED1K907969
IF vbap-kwmeng NE *vbap-kwmeng OR                     " Cumulative Order Quantity in Sales Units
   vbap-zmeng  NE *vbap-zmeng.                        " Target quantity in sales units
  new_pricing = lc_prc_type_c.                        " Pricing Type: C
ENDIF.
* End   of ADD:INC0202391:WROY:13-JUL-2018:ED1K907969

IF SY-TCODE = 'VA41' AND VBAK-auart = 'ZJJC' AND VBKD-bstkd IS NOT INITIAL.
  NEW_PRICING = 'B'.
  ENDIF.
