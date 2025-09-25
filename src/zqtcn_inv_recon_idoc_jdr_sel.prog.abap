*-------------------------------------------------------------------
* PROGRAM NAME:  ZQTCN_INVENT_RECON_JDR_SEL
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* All Selection parameter has declared in this include.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
* Revision No: ED2K910553
* Reference No: ERP-6110
* Developer: Pavan Bandlapalli(PBANDLAPAL)
* Date:  2018-01-30
* Description: 1. Added Account Assignment (p_acctas) and Item category
*              (p_itmcat) fields in the selection screen to populate
*              during PO creation.
*              2. Added logic to get the delivery address number and
*                 cost center which is being used during PO creation.
*              3. Removed the logic for Goods Receipt as per the design
*                 its not needed any more. Also removed GI movement type
*                 from the selection screen(p_mvt_gi).
*--------------------------------------------------------------------*
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_JDR_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002 .
PARAMETERS :  p_ekorg TYPE ekorg DEFAULT 'JWPO',   " Purchasing Organization
              p_lgort TYPE lgort_d DEFAULT 'J001'. " Storage Location
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS: p_bsart TYPE bsart DEFAULT 'ZNB',     " Purchasing Document Type
            p_po_nb TYPE bsart DEFAULT 'NB',      " Order Type (Purchasing)
            p_ekgrp TYPE ekgrp DEFAULT 'PJ1',     " Purchasing Group
* BOC by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
            p_acctas TYPE knttp DEFAULT 'V',       " Account Assignment
            p_itmcat TYPE pstyp DEFAULT '5',       " Item Category
* EOC by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
            p_unsez TYPE unsez DEFAULT 'OFFLINE'. " Our Reference
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
PARAMETERS : p_mvt_gr TYPE bwart DEFAULT '101'. " Movement Type (Inventory Management)
* BOC by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
*             p_mvt_gi TYPE bwart DEFAULT '251'. " Movement Type (Inventory Management)
* EOC by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-005.
PARAMETERS: p_adjtyp TYPE zadjtyp DEFAULT 'JDR', " Adjustment Type
            p_mv_ind TYPE char1 DEFAULT 'B'.     " Mv_ind of type CHAR1
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN END OF BLOCK b1.
