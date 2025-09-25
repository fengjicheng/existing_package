*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_E096_SEL_SCREEN
* PROGRAM DESCRIPTION:Include for Data Declaration
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E095
* TRANSPORT NUMBER(S) ED2K903901
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907327
* REFERENCE NO:  ERP 3301
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-25
* DESCRIPTION: Remove status change checkbox from selection screen
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910691
* REFERENCE NO:  ERP 6242
* DEVELOPER: Writtick Roy
* DATE:  2018-02-05
* DESCRIPTION: 1. Make Activity Date as a Range
*              2. Add new Selection Criteria based on Sales Org
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912349
* REFERENCE NO:  ERP-6347
* DEVELOPER: Writtick Roy
* DATE:  2018-06-19
* DESCRIPTION:  Add Exclude and Include Options (Exclusion Reason/Date)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909890
* REFERENCE NO: INC0234283
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  03/27/2019
* DESCRIPTION: Override Currency in Renw. Order
*           -  Currency field added on the selection screen and
*              display for only authorized user
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915200
* REFERENCE NO: DM# 1923
* DEVELOPER: Kiran Kumar Ravuri (KKR)
* DATE:  2019-06-06
* DESCRIPTION: Addition of Check/Un-check functionality
*------------------------------------------------------------------- *
SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS: p_activ TYPE zactivity_sub AS LISTBOX VISIBLE LENGTH 6, " Activity list box
            p_prof  TYPE zrenwl_prof AS LISTBOX VISIBLE LENGTH 10.  " Renewal Profile
SELECT-OPTIONS : s_vbeln FOR v_vblen,                                " Order
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*                Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*                s_eadat  FOR v_eadat DEFAULT sy-datum NO INTERVALS NO-EXTENSION.
*                End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*                Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                 s_eadat  FOR v_eadat DEFAULT sy-datum NO-EXTENSION,
                 s_vkorg  FOR v_vkorg,
*                End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*                Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
                 s_matnr  FOR v_matnr,    " Material Number
                 s_mvgr5  FOR v_mvgr5,    " Material group 5
                 s_kdkg2  FOR v_kdkg2.    " Customer condition group 2
*                End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
PARAMETERS: p_clear TYPE char1 AS CHECKBOX USER-COMMAND clear MODIF ID clr,     " Clear auto renewal plan table
*Begin of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
*            p_status TYPE char1 AS CHECKBOX,                      " Activity status
*End of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
*            p_test  TYPE char1 AS CHECKBOX.   " Commented as part of DM-1923
            p_test  TYPE char1 AS CHECKBOX USER-COMMAND test MODIF ID tes,      " Test Run
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
         p_ex_in TYPE char1 as CHECKBOX USER-COMMAND exin MODIF ID exi.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
*Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
PARAMETERS: p_excld TYPE char1 AS CHECKBOX USER-COMMAND excl MODIF ID exd.      " Only Excluded Items
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
SELECT-OPTIONS: s_excld FOR v_excl_resn MODIF ID exc.              "Exclusion Reason
PARAMETERS:  p_chck  TYPE char1 AS CHECKBOX USER-COMMAND chck MODIF ID chk.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*SELECT-OPTIONS: s_excld FOR v_excl_resn MODIF ID exc.              "Exclusion Reason
*SELECTION-SCREEN SKIP 1.  "- <HIPATEL> <INC0234283> <ED1K909890>
*End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*Begin of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_curr TYPE char1 AS CHECKBOX MODIF ID cur.
SELECTION-SCREEN COMMENT 02(31) text-p01 FOR FIELD p_curr MODIF ID cur.
SELECTION-SCREEN POSITION POS_LOW.
PARAMETERS: p_waers TYPE tcurc-waers MODIF ID cur.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN SKIP 1.
*End of insert <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
*End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
SELECTION-SCREEN END OF BLOCK b1.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
PARAMETERS : p_nor TYPE i DEFAULT '50000'.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
