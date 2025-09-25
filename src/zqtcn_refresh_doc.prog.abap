*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_REFRESH_DOC
* PROGRAM DESCRIPTION:Rejection rule for Sales order
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-11-10
* OBJECT ID:E104
* TRANSPORT NUMBER(S)ED2K903001
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
CLEAR: v_lifsk_01, " Block Order for scenario 1
       v_lifsk_02, " Block order for scenario 2
       v_abgru.    " Rejection rule text
CLEAR: i_cdshw,    " change history
** Begin Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
       i_sub_tot,  " Sub-totals
** End Of Change By SRBOSE on 22-Jun-2017 #TR:ED2K906852
       i_kotg001,  " Customer/Material
       i_kotg501.  " Dest. Ctry/Material
