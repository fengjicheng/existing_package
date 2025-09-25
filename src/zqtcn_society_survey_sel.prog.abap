*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SOCIETY_SURVEY_R043
* PROGRAM DESCRIPTION: Society Survey options Report
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-04-26
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K904138
*-------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918013
* REFERENCE NO: ERPM-14689
* WRICEF ID: R043
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE: 04/17/2020
* DESCRIPTION: Single date selection extend to the Date range
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SOCIETY_SURVEY_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS : s_bp   FOR but000-partner  OBLIGATORY, "society BP number
                 s_rel  FOR tbz9-reltyp               , "Relationship Category
                 s_sub  FOR vbak-auart      OBLIGATORY, "Subscription type
                 s_doc  FOR vbak-vbtyp      OBLIGATORY. "Document Category

* Begin of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
*PARAMETERS: p_date TYPE erdat DEFAULT sy-datum. "Date
SELECT-OPTIONS : s_erdat FOR vbak-erdat." DEFAULT sy-datum. " Date
* End of changes by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689 *
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
SELECT-OPTIONS s_po FOR vbak-bsark. "Purchase order type
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-006.
PARAMETERS: rb_dis  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm DEFAULT 'X',
            rb_save RADIOBUTTON GROUP rb1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-004.
PARAMETERS: rb_app RADIOBUTTON GROUP rad1 USER-COMMAND rucomm MODIF ID cg1 DEFAULT 'X',  "Radio button for Application server
            rb_prs RADIOBUTTON GROUP rad1 MODIF ID cg1.                                 " "Radio button for Presentation server

PARAMETERS : p_file  TYPE localfile MODIF ID cg1 . "rlgrap-filename    " Local file for upload/download
SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN END OF BLOCK b4.
