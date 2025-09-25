*&---------------------------------------------------------------------*
*&  Include           ZQTCR_RENEWALS_PLAN_SEL_01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_RENEWALS_PLAN_SEL_01 (Selection Screen)
* PROGRAM DESCRIPTION: Include for Renewal Plan report selection screen
* DEVELOPER: Dinakar T(DTIRUKOOVA)
* CREATION DATE:  2018-03-19
* OBJECT ID:  R066
* TRANSPORT NUMBER(S): ED2K911447
*----------------------------------------------------------------------*

* SELECTION SCREEN-----------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

PARAMETERS : rb_sales   TYPE c RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 DEFAULT 'X' MODIF ID m1.

SELECTION-SCREEN END OF BLOCK b1.
