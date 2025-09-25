*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_SEL (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-29655
* REFERENCE NO: ED2K915695
* DEVELOPER: Siva Guda (SGUDA)
* DATE: 12-21-2020
* DESCRIPTION: Auto rejection on release order
* 1) Add order type as VBAK-AUART in Excel file.
* 2) Change Mail Body
* 3) Add reason for rejection for subsequent documents.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORD_RES_REJ_UPD_SEL
*&---------------------------------------------------------------------*
TABLES: vbak,vbap,veda,adr6.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
SELECT-OPTIONS : s_vkorg FOR vbak-vkorg NO INTERVALS NO-EXTENSION.
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
SELECT-OPTIONS : s_vtweg FOR vbak-vtweg.
SELECT-OPTIONS : s_spart FOR vbak-spart.
SELECT-OPTIONS: s_vbeln  FOR vbak-vbeln MODIF ID m1.
SELECT-OPTIONS: s_type   FOR vbak-auart NO INTERVALS.
SELECT-OPTIONS: s_date   FOR vbak-erdat.
SELECT-OPTIONS: s_matnr  FOR vbap-matnr.
SELECT-OPTIONS: s_pro    FOR veda-vkuesch NO INTERVALS.
SELECT-OPTIONS: s_c_date FOR veda-vwundat.
SELECT-OPTIONS :s_mail   FOR adr6-smtp_addr NO INTERVALS.
*--*BOC OTCM-29655 Prabhu ED2K914211 1/27/20201
PARAMETERS :p_test TYPE c AS CHECKBOX DEFAULT 'X'.
*--*EOC OTCM-29655 Prabhu ED2K914211 1/27/20201
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
SELECT-OPTIONS :s_it_cat FOR vbap-pstyv NO-DISPLAY.
SELECT-OPTIONS :s_it_srp FOR vbap-pstyv NO-DISPLAY.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
SELECTION-SCREEN END OF BLOCK b1.
