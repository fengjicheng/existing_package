*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SHIPPING_PLAN_CONV_SEL (Include Program)
* PROGRAM DESCRIPTION: Shipping Plan Conversion
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   01/02/2017
* OBJECT ID:  C075
* TRANSPORT NUMBER(S): ED2K903953
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*** radio  button for server selection
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: rb_pres RADIOBUTTON GROUP rb1 MODIF ID mi1
                        DEFAULT 'X' USER-COMMAND comm1. " pres server
  PARAMETERS: rb_appl RADIOBUTTON GROUP rb1 MODIF ID mi1." appl server
  PARAMETERS: cb_head TYPE char1 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
  PARAMETERS:p_pr_ph TYPE rlgrap-filename MODIF ID mi2.
  PARAMETERS:p_ap_ph TYPE rlgrap-filename MODIF ID mi2.
 SELECTION-SCREEN END OF BLOCK b3.
 SELECTION-SCREEN END OF BLOCK b1.
