*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_BP_ORDER_UPLD (Main Program)
* PROGRAM DESCRIPTION: To upload BP and subscription orders
* DEVELOPER: Nageswara(NPOLINA)
* CREATION DATE:   02/Dec/2019
* OBJECT ID: E225
* TRANSPORT NUMBER(S):ED2K916854
*----------------------------------------------------------------------*
* REVISION NO:                                                         *
* REFERENCE NO:                                                        *
* DEVELOPER:                                                           *
* DATE:                                                                *
* DESCRIPTION:                                                         *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_ORD_UPLD_SEL
*&---------------------------------------------------------------------*

* SELECTION SCREEN-----------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(31) comm5.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.

SELECTION-SCREEN COMMENT  1(31) comm1.

SELECTION-SCREEN PUSHBUTTON (17) pb_down USER-COMMAND fc01.
SKIP 2.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(31) comm2.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(31) comm3.
PARAMETERS: rb_tbt RADIOBUTTON GROUP grp1 USER-COMMAND tbt .
SELECTION-SCREEN COMMENT  36(4) text-c01  FOR FIELD rb_tbt.
PARAMETERS: rb_ftp RADIOBUTTON GROUP grp1  .
SELECTION-SCREEN COMMENT  44(5) text-c02  FOR FIELD rb_ftp.
PARAMETERS: rb_soc RADIOBUTTON GROUP grp1  .
SELECTION-SCREEN COMMENT  52(7) text-c03  FOR FIELD rb_soc.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(31) comm4.
SELECTION-SCREEN END OF LINE.
PARAMETERS: p_file   TYPE rlgrap-filename .   " Local file for upload
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  33(60) comm6.
SELECTION-SCREEN END OF LINE.
PARAMETERS: p_a_file TYPE localfile       NO-DISPLAY,
            p_job    TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid TYPE syuname         NO-DISPLAY,
            p_v_oid  TYPE numc10          NO-DISPLAY,
            p_l_file   TYPE rlgrap-filename NO-DISPLAY,
            p_auart   TYPE auart NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.
