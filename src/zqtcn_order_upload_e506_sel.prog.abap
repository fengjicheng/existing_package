*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_UPLOAD_E506_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ORDER_UPLOAD_E506_SEL (INCLUDE)
* PROGRAM DESCRIPTION: To upload Mass Sales orders & Credit/Debit Memos
* REFERENCE NO: EAM-1155
* DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:   19/April/2022
* OBJECT ID:    E506
* TRANSPORT NUMBER(S):ED2K926870
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:rb_so_ct RADIOBUTTON GROUP rad1 USER-COMMAND uc1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(60) text-001 FOR FIELD rb_so_ct.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:rb_cd_ct RADIOBUTTON GROUP rad1.
SELECTION-SCREEN COMMENT 3(60) text-002 FOR FIELD rb_cd_ct.
SELECTION-SCREEN END OF LINE.
PARAMETERS: p_file   TYPE rlgrap-filename,
            p_v_oid  TYPE numc10 NO-DISPLAY,
            p_a_file TYPE localfile NO-DISPLAY,
            p_job    TYPE tbtcjob-jobname NO-DISPLAY.
SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
