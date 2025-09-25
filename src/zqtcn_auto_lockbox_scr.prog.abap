*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_LOCKBOX_RENEWAL
* PROGRAM DESCRIPTION: Include Programfor the Selection Screen
* DEVELOPER: Shivangi Priya
* CREATION DATE: 11/14/2016
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K903276
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: CR#384
* REFERENCE NO: ED2K905720
* DEVELOPER: Paramita Bose
* DATE: 15-05-2017
* DESCRIPTION: Incorporating changes in selection screen to meet require-
*              -ment of CR#384
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
*&  Include           ZQTCE_AUTO_LOCKBOX_SCR
*&---------------------------------------------------------------------*
*** Seelection screen ***
SELECTION-SCREEN:BEGIN OF BLOCK b1.
* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*PARAMETERS:     p_bukrs TYPE bukrs OBLIGATORY.
SELECT-OPTIONS: s_bukrs FOR v_bukrs.
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
SELECT-OPTIONS: s_date FOR v_budat DEFAULT sy-datum.
* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
SELECT-OPTIONS: s_blart FOR v_blart.  " Document Type
SELECT-OPTIONS: s_bschl FOR v_bschl DEFAULT 15.  " Posting Key
SELECT-OPTIONS: s_xref1 FOR v_xref1.  " Reference Key1
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
SELECTION-SCREEN END OF BLOCK b1.
