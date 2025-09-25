*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_RENEWAL_TBL_UPD_C064_SEL(Selection Screen)
* PROGRAM DESCRIPTION: Update renewal Plan table to update Status
* obtained from E096
* DEVELOPER: Aratrika Banerjee
* CREATION DATE:   2017-04-07
* OBJECT ID : C064
* TRANSPORT NUMBER(S):  ED2K905240
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECTION-SCREEN BEGIN OF BLOCK b2.
PARAMETERS: rb_pre  RADIOBUTTON GROUP rb1 DEFAULT 'X' USER-COMMAND rucomm, "radiobutton for Presentation server
            rb_appl RADIOBUTTON GROUP rb1.                                 "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b2.
SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b3.
PARAMETERS: p_file TYPE localfile MODIF ID fl1. " Local file for upload/download
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
