*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DWNLD_INV_DETAILS_E071
* PROGRAM DESCRIPTION: Download invoice details and Credit details in
*                      excel file.
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 10/04/2016
* OBJECT ID: E071
* TRANSPORT NUMBER(S): ED2K903054
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_DWNLD_INV_DETAILS_SCR
*&---------------------------------------------------------------------*
 SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
 SELECT-OPTIONS: s_vbeln FOR v_vbeln.

 SELECTION-SCREEN SKIP.
 SELECTION-SCREEN:BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
 SELECT-OPTIONS: s_fkart FOR v_fkart,
                 s_kunag FOR v_kunag,
                 s_kunrg FOR v_kunrg,
                 s_fkdat FOR v_fkdat.
 SELECTION-SCREEN:END OF BLOCK b2.

 SELECTION-SCREEN:BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
 SELECT-OPTIONS: s_vkorg FOR v_vkorg,
                 s_vtweg FOR v_vtweg.
 SELECTION-SCREEN:END OF BLOCK b3.

 SELECTION-SCREEN:BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
 PARAMETERS: rb_inv RADIOBUTTON GROUP rb USER-COMMAND ucomm DEFAULT 'X',
             rb_crd RADIOBUTTON GROUP rb.
 SELECTION-SCREEN:END OF BLOCK b4.
 SELECTION-SCREEN:END OF BLOCK b1.
