*---------------------------------------------------------------------*
*PROGRAM NAME :  ZQTCR_MED_ISS_R115_SEL(Include Program)              *
*REVISION NO :   ED2K921929/ED2K922788                                *
*REFERENCE NO:   OTCM-29592                                           *
*DEVELOPER  :    Lahiru Wathudura (LWATHUDURA)                        *
*WRICEF ID  :    R115                                                 *
*DATE       :    02/16/2021                                           *
*DESCRIPTION:    Add Fields to ZSCM_ISSUE _COCKPIT                    *
*---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K925006                                             *
* REFERENCE NO: OTCM-45347                                             *
* DEVELOPER   : Thilina Dimantha (TDIMANTHA)                           *
* DATE        : 11/12/2021                                             *
* DESCRIPTION : Media Issue cockpit Performence improvement
*----------------------------------------------------------------------*
* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
SELECTION-SCREEN BEGIN OF BLOCK b17 WITH FRAME TITLE text-011.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: rb_fgr RADIOBUTTON GROUP grp1 DEFAULT 'X' USER-COMMAND uc1.  " Radio button for Summary report
SELECTION-SCREEN COMMENT 16(15) text-012 FOR FIELD rb_fgr .
PARAMETERS: rb_bgr RADIOBUTTON GROUP grp1 .
SELECTION-SCREEN COMMENT 36(15) text-013 FOR FIELD rb_bgr .
*BOC ED2K925042 22-Nov-2021 TDIMANTHA               " Radio button for detail report
*PARAMETERS: cb_rar AS CHECKBOX." DEFAULT 'X'.
*SELECTION-SCREEN COMMENT 56(15) text-016 FOR FIELD cb_rar .               " RAR Flow
*EOC ED2K925042 22-Nov-2021 TDIMANTHA
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b17.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *

*Block for Media Master Data
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-001.
SELECT-OPTIONS :
             s_prod   FOR jksesched-product,
             s_issu   FOR jksesched-issue,
             s_pbdt   FOR mara-ismpubldate,
             s_indt   FOR mara-isminitshipdate,
             s_dldt   FOR jksenip-shipping_date,
             s_gddt   FOR marc-ismarrivaldateac.
SELECTION-SCREEN END OF BLOCK bl1.

*Block for Organization Data
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-002.
SELECT-OPTIONS:
             s_sorg   FOR vbak-vkorg, " OBLIGATORY,
             s_dist   FOR vbak-vtweg, " DEFAULT '00',
             s_sdiv   FOR vbak-spart, "DEFAULT '00',
             s_soff   FOR vbak-vkbur.
SELECTION-SCREEN END OF BLOCK bl2.

*Block for Document Data
SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE text-003.
SELECT-OPTIONS:
             s_sdoc   FOR vbak-vbeln, " OBLIGATORY,
             s_assg   FOR zcds_mip_004-assignment,
             s_dctp   FOR vbak-auart, " DEFAULT '00',
             s_itcg   FOR vbap-pstyv,
             s_csdt   FOR zcds_mip_005-contract_start_date,
             s_cedt   FOR zcds_mip_005-contract_end_date,
             s_rele   FOR jkseflow-vbelnorder.
"s_vdat   FOR zcds_mi_r115_rpt-contract_start_date.
SELECTION-SCREEN END OF BLOCK bl3.

* Display Unearned Record
SELECTION-SCREEN BEGIN OF BLOCK bl5 WITH FRAME TITLE text-005.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS : c_iamt TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s08 FOR FIELD c_iamt.
PARAMETERS : rbg1  RADIOBUTTON GROUP a1 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rbg1.
PARAMETERS : rbg2  RADIOBUTTON GROUP a1 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rbg2.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bl5.

SELECTION-SCREEN BEGIN OF BLOCK bl4 WITH FRAME TITLE text-004.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_exbb TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s01 FOR FIELD c_exbb.
PARAMETERS : rb1  RADIOBUTTON GROUP g1 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb1.
PARAMETERS : rb2  RADIOBUTTON GROUP g1 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb2.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_exdb TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s02 FOR FIELD c_exdb.
PARAMETERS : rb3  RADIOBUTTON GROUP g2 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb3.
PARAMETERS : rb4  RADIOBUTTON GROUP g2 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb4.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_excb TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s04 FOR FIELD c_excb.
PARAMETERS : rb5  RADIOBUTTON GROUP g3 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb5.
PARAMETERS : rb6  RADIOBUTTON GROUP g3 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb6.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_excc TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s05 FOR FIELD c_excc.
PARAMETERS : rb7  RADIOBUTTON GROUP g4 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb7.
PARAMETERS : rb8  RADIOBUTTON GROUP g4 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb8.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_exro TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s06 FOR FIELD c_exro.
PARAMETERS : rb9  RADIOBUTTON GROUP g5 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb9.
PARAMETERS : rb10  RADIOBUTTON GROUP g5 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb10.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: c_irel TYPE char3 NO-DISPLAY.
SELECTION-SCREEN COMMENT 1(30) text-s07 FOR FIELD c_irel.
PARAMETERS : rb11  RADIOBUTTON GROUP g6 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 38(4) FOR FIELD rb11.
PARAMETERS : rb12  RADIOBUTTON GROUP g6 ."MODIF ID m1.
SELECTION-SCREEN COMMENT 44(2) FOR FIELD rb12.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN END OF BLOCK bl4.

* BOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929 *
SELECTION-SCREEN BEGIN OF BLOCK b16 WITH FRAME TITLE text-006.
PARAMETERS : p_alv_vr TYPE slis_vari," OBLIGATORY, " Layout
* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
             p_userid TYPE sy-uname  NO-DISPLAY. " GUI user
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
SELECTION-SCREEN END OF BLOCK b16.
* EOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929 *
