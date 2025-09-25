*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONTIN_SALES_E501_SEL
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_CONTINUATION_SALES_E501                  *
* PROGRAM DESCRIPTION : Creating Child(Continuous)Sales Order Automatically
* DEVELOPER           : SRAMASUBRA (Sankarram R)                       *
* CREATION DATE       : 2022-04-07                                     *
* OBJECT ID           : E501/EAM-8355                                  *
* TRANSPORT NUMBER(S) : ED2K926637                                     *
*&---------------------------------------------------------------------*

TABLES:jptidcdassign.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

SELECT-OPTIONS:

    s_sotyp  FOR vbak-auart OBLIGATORY DEFAULT c_sd_ord_typ
             NO INTERVALS NO-EXTENSION,                         "Sales Doc. Type
    s_sercd  FOR jptidcdassign-identcode NO INTERVALS NO-EXTENSION,          "Series Code
    s_kunnr  FOR vbak-kunnr NO INTERVALS NO-EXTENSION,          "Customer
    s_vbeln  FOR vbak-vbeln NO INTERVALS NO-EXTENSION.          "Contract No

PARAMETERS:
    p_pdate  TYPE sy-datum OBLIGATORY MODIF ID m1.              "Publication Date

SELECT-OPTIONS:
  s_status FOR mara-mstae MODIF ID m1 NO INTERVALS NO-EXTENSION."X Plant Status

SELECTION-SCREEN BEGIN OF LINE.

SELECTION-SCREEN COMMENT (15) text-001.                       "Previous Title
SELECTION-SCREEN POSITION 33.
PARAMETERS: rb_pre_y RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 .
SELECTION-SCREEN COMMENT 35(5) text-002.                      "Yes

SELECTION-SCREEN POSITION 42.
PARAMETERS: rb_pre_n RADIOBUTTON GROUP rad1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 45(5) text-003.                      "No

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b1.
