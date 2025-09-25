*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_LOCKBOX_RENEWAL
* PROGRAM DESCRIPTION: Automated Lockbox Renewals Sub routines
* DEVELOPER: Anirban Saha
* CREATION DATE: 09/05/2017
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K908367
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
SELECT-OPTIONS: s_bukrs FOR v_bukrs.
SELECT-OPTIONS: s_date FOR v_budat NO-DISPLAY.
SELECT-OPTIONS: s_blart FOR v_blart.  " Document Type
SELECT-OPTIONS: s_bschl FOR v_bschl DEFAULT 15.  " Posting Key
SELECT-OPTIONS: s_xref1 FOR v_xref1.  " Reference Key1
SELECTION-SCREEN END OF BLOCK b1.
PARAMETERS: p_purge AS CHECKBOX.
