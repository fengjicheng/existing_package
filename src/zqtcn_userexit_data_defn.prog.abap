*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_DATA_DEFN (Include)
*               Called from MV45ATZZ
* PROGRAM DESCRIPTION: This userexit can be used for global data
*                      definitions / declarations
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_USEREXIT_DATA_DEFN
* PROGRAM DESCRIPTION:Data Declaration for Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-11-10
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_USEREXIT_DATA_DEFN
* PROGRAM DESCRIPTION:Data Declaration for Auto Renewal
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-08
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
* BOC by KCHAKRABOR on 08-Jan-2017 TR#ED2K902972 *
* EOC by KCHAKRABOR on 08-Jan-2017 TR#ED2K902972 *
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_MEDIA_SUSPENSION_DECL (Include)
* PROGRAM DESCRIPTION: Capture the Changes to table JKSEINTERRUPT
* DEVELOPER: Nikhilesh Palla (NPALLA)
* CREATION DATE:   09/30/2021
* OBJECT ID: I0229
* TRANSPORT NUMBER(S): ED2K924568
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
*& Exit control check as this this data declaration part
INCLUDE zqtcn_aut_rejct_data_decl IF FOUND. " zqtcn_aut_rejct_data_decl
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
* BOC by KCHAKRABOR on 08-Jan-2017 TR#ED2K902972 *
INCLUDE zqtcn_aut_ren_plan_data_decl IF FOUND.
* EOC by KCHAKRABOR on 08-Jan-2017 TR#ED2K902972 *
* BOC by WROY on 08-AUG-2017 TR#ED2K907469
INCLUDE zqtcn_bom_pricing_data_decl IF FOUND.
* EOC by WROY on 08-AUG-2017 TR#ED2K907469
* BOC by SGUDA on 11 -SEP-2018 TR#ED2K912980
INCLUDE ZQTC_ENH_EXLUDE_E181_TOP IF FOUND.
* EOC by SGUDA on 11 -SEP-2018 TR#ED2K912980
* BOC by NPALLA on 30-SEP-2021 TR#ED2K924568
INCLUDE zqtcn_media_suspen_decl_i0229 IF FOUND.
* EOC by NPALLA on 30-SEP-2021 TR#ED2K924568
