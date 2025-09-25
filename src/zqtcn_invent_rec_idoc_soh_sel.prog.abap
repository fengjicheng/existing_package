*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_INVENT_RECON_SOH_SEL
* PROGRAM DESCRIPTION: Inventory Reconcilliation selection screen
* include
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-03
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
*&  Include           ZQTCN_INVENT_RECON_SOH_SEL
*&---------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-p01 .
*
*SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-p02.
*PARAMETERS: p_adjust TYPE zadjtyp DEFAULT c_adjustment_type, " Adjustment Type
*            p_mvt TYPE char1 DEFAULT c_mvt_ind.     " Mv_ind of type CHAR1
*SELECTION-SCREEN END OF BLOCK b2.
*
*SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-p03 .
*PARAMETERS :  p_ekorg TYPE ekorg DEFAULT c_ekorg,   " Purchasing Organization
*              p_lgort TYPE lgort_d DEFAULT c_lgort, " Storage Location
*              p_knttp TYPE knttp DEFAULT c_knttp.
*SELECTION-SCREEN END OF BLOCK b3.
*
*SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-p05.
*PARAMETERS : p_bwart TYPE bwart DEFAULT c_bwart. " Movement Type (Inventory Management)
*SELECTION-SCREEN END OF BLOCK b4.
*
*SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-p04.
*PARAMETERS: p_bsart TYPE bsart DEFAULT c_bsart,     " Purchasing Document Type
*            p_ekgrp TYPE ekgrp DEFAULT c_ekgrp.     " Purchasing Group
*SELECTION-SCREEN END OF BLOCK b5.
*SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-p01 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-p02.
  PARAMETERS :  p_ekorg TYPE ekorg DEFAULT 'JWPO',   " Purchasing Organization
              p_lgort TYPE lgort_d DEFAULT 'J001'. " Storage Location
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS: p_bsart TYPE bsart DEFAULT 'ZNB',     " Purchasing Document Type
            p_po_nb TYPE bsart DEFAULT 'NB',      " Order Type (Purchasing)
            p_ekgrp TYPE ekgrp DEFAULT 'PJ1',     " Purchasing Group
            p_unsez TYPE unsez DEFAULT 'WHSTK'. " Our Reference
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
PARAMETERS : p_mvt_gr TYPE bwart DEFAULT '101'. " Movement Type (Inventory Management)
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-005.
PARAMETERS: p_adjtyp TYPE zadjtyp DEFAULT 'SOH', " Adjustment Type
            p_mv_ind TYPE char1 DEFAULT 'B'.     " Mv_ind of type CHAR1
SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN END OF BLOCK b1.
