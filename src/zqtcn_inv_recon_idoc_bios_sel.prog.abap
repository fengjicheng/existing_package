*-------------------------------------------------------------------
* PROGRAM NAME:  ZQTCN_INVENT_RECON_BIOS_SEL
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* All Selection parameter has declared in this include.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-04-09
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908477
* REFERENCE NO:  CR#590
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  04-Sep-2017
* DESCRIPTION: For Adjustment Type BIOS similar logic to SOH has been
*              implemented. All the necessary code cleaning is done
*              and hence no tags are avaialble. As this was kind of
*              complete new design from scratch.
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_JDR_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002 .
PARAMETERS :  p_lgort TYPE lgort_d DEFAULT 'J001'. " Storage Location
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-003.
PARAMETERS :   p_mvt_gi TYPE bwart DEFAULT '251'. " Movement Type (Inventory Management)
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-004.
PARAMETERS: p_adjtyp TYPE zadjtyp DEFAULT 'BIOS', " Adjustment Type
            p_gmcode TYPE gm_code DEFAULT '03'.   " GM Code

SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN END OF BLOCK b1.
