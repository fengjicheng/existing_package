*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_PRICE_LIST_R108_SEL (Include)
* PROGRAM DESCRIPTION: This program implemented for to display the
*                      Price List Report
* DEVELOPER:           Siva Guda (SGUDA)
* CREATION DATE:       05/27/2020
* OBJECT ID:           ERPM-6946/R108
* TRANSPORT NUMBER(S): :ED2K918317
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description: .
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZQTCR_PRICE_LIST_R108_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1
                        WITH FRAME TITLE text-s02.
PARAMETERS p_kschl TYPE konh-kschl.                     "Condition type
PARAMETERS p_kotabn TYPE konh-kotabnr.                  "Condition table
SELECT-OPTIONS s_ernam  FOR  konh-ernam.                "Name of Person who Created the Object
SELECT-OPTIONS s_erdat  FOR  konh-erdat.                "Date on Which Record Was Created
SELECT-OPTIONS s_datbi  FOR  a927-datbi.                "Validity end date of the condition record
SELECT-OPTIONS s_datab  FOR  a927-datab.                "Validity start date of the condition record
SELECT-OPTIONS s_kunwe  FOR  a927-kunwe.                "Ship-to party
SELECT-OPTIONS s_matnr  FOR  a927-matnr.                " OBLIGATORY.     "Material Number
SELECT-OPTIONS s_kbetr  FOR  konp-kbetr.                "Rate (condition amount or percentage) where no scale exists
SELECT-OPTIONS s_konwa  FOR  konp-konwa.                "Rate unit (currency or percentage)
SELECT-OPTIONS s_extwg  FOR  mara-extwg.                "External Material Group
SELECT-OPTIONS s_ismpub FOR  mara-ismpubltype.          "Publication Type
SELECT-OPTIONS s_auart  FOR  tvak-auart.                "Sales Document Type
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2
                          WITH FRAME TITLE text-s03.
PARAMETERS p_hits TYPE rseumod-tbmaxsel DEFAULT 500.                "Sales Document Type
SELECTION-SCREEN END OF BLOCK b2.
