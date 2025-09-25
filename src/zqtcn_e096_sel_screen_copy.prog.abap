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
                 s_vkorg  FOR v_vkorg.
*                End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
PARAMETERS: p_clear  TYPE char1 AS CHECKBOX,                        " Clear auto renewal plan table
*Begin of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
*            p_status TYPE char1 AS CHECKBOX,                        " Activity status
*End of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
            p_test   TYPE char1 AS CHECKBOX.                        " Test Run
SELECTION-SCREEN END OF BLOCK b1.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
PARAMETERS : p_nor TYPE i DEFAULT '50000'.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
