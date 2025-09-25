*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_REN_PLAN_DATA_DECL
* PROGRAM DESCRIPTION:Data Declaration for Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-08
* OBJECT ID:E095
* TRANSPORT NUMBER(S)ED2K903783
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906980
* REFERENCE NO:  CR 585
* DEVELOPER: Anirban Saha
* DATE:  2017-06-28
* DESCRIPTION: Considering Material no while determining renewal profile
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909016
* REFERENCE NO: CR 650
* DEVELOPER: Anirban Saha
* DATE:  2017-10-16
* DESCRIPTION: VCH Renewal profile determination
*------------------------------------------------------------------- *
TYPES: BEGIN OF ty_rp_deter,
         kdgrp           TYPE kdgrp,
         konda           TYPE konda,
         pay_type        TYPE zpay_type,
         sold_to_country TYPE land1,
         ship_to_country TYPE land1,
         license_grp     TYPE  zlicense_grp,
         sales_office    TYPE	vkbur,
         subs_type       TYPE zsubs_type,
         kdkg2           TYPE kdkg2,
         mvgr5           TYPE mvgr5,
         bsark           TYPE bsark,
         vkorg           TYPE vkorg,
         werks           TYPE werks_d,
*Begin of Add-Anirban-06.28.2017-ED2K906915-CR 585
         matnr           TYPE matnr,
*End of Add-Anirban-06.28.2017-ED2K906915-CR 585
*Begin of Add-Anirban-10.16.2017-ED2K909016-CR 650
         zzaction        TYPE vasch_veda,
*End of Add-Anirban-10.16.2017-ED2K909016-CR 650
         renwl_prof      TYPE zrenwl_prof,
       END OF ty_rp_deter.
TYPES tt_rp_deter TYPE STANDARD TABLE OF ty_rp_deter
      INITIAL SIZE 0.
DATA: i_rp_deter TYPE tt_rp_deter.
