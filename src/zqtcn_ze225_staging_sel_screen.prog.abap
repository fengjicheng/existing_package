*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_ZE225_STAGING_SEL_SCREEN
* PROGRAM DESCRIPTION:Include for selection screen
* DEVELOPER: GKAMMILI(Gopalakrishna K)
* CREATION DATE:   2019-12-04
* OBJECT ID:
* TRANSPORT NUMBER(S) ED2K916990
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:  ED2K924398 / ED2K927377
* REFERENCE NO: OTCM-47267
* DEVELOPER:    Nikhilesh Palla(NPALLA)
* DATE:         12/17/2021 and 05/24/2022
* DESCRIPTION:  Staging Changes - Add additional filterning by File Type
*               and capture File type in output.
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
* DESCRIPTION:
*-------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ZE225_STAGING_SEL_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS:s_zuid       FOR v_zuid_upld MODIF ID s1,  "++ED2K927377 Modif ID
                 s_zoid       FOR v_zoid,
                 s_zitem      FOR v_zitem,
                 s_zuser      FOR v_zuser.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS:s_zbp        FOR v_zbp       MODIF ID s1,  "++ED2K927377 Modif ID
                 s_vbeln      FOR v_vbeln     MODIF ID s1,  "++ED2K927377 Modif ID
                 s_zstat      FOR v_zprcstat.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
  SELECT-OPTIONS:s_zlogno     FOR v_zlogno    MODIF ID s1,  "++ED2K927377 Modif ID
                 s_zdat       FOR v_zcrtdat   MODIF ID s1,  "++ED2K927377 Modif ID
                 s_ztim       FOR v_zcrttim.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-006.
  PARAMETERS: rb_e225 RADIOBUTTON GROUP rad1 USER-COMMAND ftype MODIF ID m1
                                  DEFAULT 'X'.
  SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-007.
*  PARAMETERS: p_e225 AS CHECKBOX.
  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT  1(4) comm11.
  PARAMETERS: p_1a AS CHECKBOX MODIF ID m2.  "TBT
  SELECTION-SCREEN COMMENT  10(30) text-c11  FOR FIELD p_1a.
  PARAMETERS: p_1b AS CHECKBOX MODIF ID m2.  "FPT
  SELECTION-SCREEN COMMENT  42(30) text-c12  FOR FIELD p_1b.
  PARAMETERS: p_1c AS CHECKBOX MODIF ID m2.  "Society
  SELECTION-SCREEN COMMENT  74(30) text-c13  FOR FIELD p_1c.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b5.

  PARAMETERS: rb_e101 RADIOBUTTON GROUP rad1  MODIF ID m1.

  SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-008.
*  PARAMETERS: p_e101 AS CHECKBOX.
  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT  1(4) comm21.
  PARAMETERS: p_2a AS CHECKBOX MODIF ID m3.  "Create New Subscription Order
  SELECTION-SCREEN COMMENT  10(30) text-c21  FOR FIELD p_2a.
  PARAMETERS: p_2b AS CHECKBOX MODIF ID m3.  "Create Ren Ord with SubrefID
  SELECTION-SCREEN COMMENT  42(30) text-c22  FOR FIELD p_2b.
  PARAMETERS: p_2c AS CHECKBOX MODIF ID m3.  "Modify Existing Subscription Order
  SELECTION-SCREEN COMMENT  75(35) text-c23  FOR FIELD p_2c.
  SELECTION-SCREEN END OF LINE.
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
*  SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT  1(4) comm22.
*  PARAMETERS: p_2d AS CHECKBOX MODIF ID m3.  "Create New Credit Memo
*  SELECTION-SCREEN COMMENT  10(30) text-c24  FOR FIELD p_2d.
*  PARAMETERS: p_2e AS CHECKBOX MODIF ID m3.  "Change Existing Credit Memo
*  SELECTION-SCREEN COMMENT  42(30) text-c25  FOR FIELD p_2e.
*  PARAMETERS: p_2f AS CHECKBOX MODIF ID m3.  "Create New Acquisition DebitMemoReq
*  SELECTION-SCREEN COMMENT  75(35) text-c26  FOR FIELD p_2f.
*  SELECTION-SCREEN END OF LINE.
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT  1(4) comm23.
  PARAMETERS: p_2g AS CHECKBOX MODIF ID m3.  "Create Regular Order
  SELECTION-SCREEN COMMENT  10(30) text-c27  FOR FIELD p_2g.
  PARAMETERS: p_2h AS CHECKBOX MODIF ID m3.  "Modify Regular Order
  SELECTION-SCREEN COMMENT  42(30) text-c28  FOR FIELD p_2h.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK b6.

SELECTION-SCREEN END OF BLOCK b4.
