*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Include contains the fields of selection
*                      screen
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-03-27
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_IDOC_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-001 .
  PARAMETERS: p_sloc  TYPE lgort_d DEFAULT c_sloc,   "Storage Location
              p_uom   TYPE meins   DEFAULT c_uom,    "Unit Of Measurement
              p_gm_c  TYPE gm_code DEFAULT c_gmc.    "GM Code
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-002.
  PARAMETERS: p_doc   TYPE bsart   DEFAULT c_doc.    "Document type

SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-003.
  PARAMETERS: p_mov   TYPE bwart   DEFAULT c_mov.    "Movement Type


SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-004.
  PARAMETERS: p_adj   TYPE zadjtyp DEFAULT c_adj,    "Adjustment Type
              p_po_h  TYPE BEWTP   default c_po,     "PO History
              p_acc   TYPE knttp   DEFAULT c_acc,    "Account Assignment Category
              p_mov_i TYPE ablad   DEFAULT c_mov_i.  "Movement Indicator
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN END OF BLOCK b1.
