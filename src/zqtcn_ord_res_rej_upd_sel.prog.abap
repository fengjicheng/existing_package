*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_RES_REJ_UPD_SEL (Include)
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-43362 / OTCM-29655                                            *
* DEVELOPER   : Prabhu (PTUFARAM)                          *
* DATE        : 03/25/2021                               *
* DESCRIPTION : Adding sales org and Item category exclusion
*              OTCM-43362 is replaced with OTCM-29655
*----------------------------------------------------------------------*
* REVISION NO : ED2K926559
* REFERENCE NO: EAM-1661
* DEVELOPER   : Vishnu (VCHITTIBAL)
* DATE        : 06/04/2022
* OBJECT ID   : E505
* DESCRIPTION : Adding new functionality to update reason for rejection
*               for Back orders
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORD_RES_REJ_UPD_SEL
*&---------------------------------------------------------------------*
TABLES: vbak,vbap,veda,adr6.
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:rb_1 RADIOBUTTON GROUP r1 USER-COMMAND uc1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(60) text-040 FOR FIELD rb_1.
SELECTION-SCREEN END OF LINE.
*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
** Added Modif ID M1 for the exixtsing selection screen fields  - EAM-1661 Vishnu ED2K926559 06/04/2022
*--*BOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECT-OPTIONS : s_vkorg FOR vbak-vkorg NO INTERVALS MODIF ID m1.
*--*BOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECT-OPTIONS: s_vbeln  FOR vbak-vbeln MODIF ID m1.
SELECT-OPTIONS: s_type   FOR vbak-auart NO INTERVALS MODIF ID m1.
SELECT-OPTIONS: s_date   FOR vbak-erdat MODIF ID m1.
SELECT-OPTIONS: s_matnr  FOR vbap-matnr MODIF ID m1.
SELECT-OPTIONS: s_pro    FOR veda-vkuesch NO INTERVALS MODIF ID m1.
SELECT-OPTIONS: s_c_date FOR veda-vwundat MODIF ID m1.
SELECT-OPTIONS :s_mail   FOR adr6-smtp_addr NO INTERVALS MODIF ID m1.
SELECT-OPTIONS :s_it_cat FOR vbap-pstyv NO-DISPLAY MODIF ID m1.
*--*BOC OTCM-43362 Prabhu ED2K922320 3/08/2021
PARAMETERS p_excl AS CHECKBOX MODIF ID m1.
*--*EOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECTION-SCREEN END OF BLOCK b1.
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:rb_2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN COMMENT 3(50) text-041 FOR FIELD rb_2.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-057.
SELECT-OPTIONS : s_sorg   FOR vbak-vkorg NO INTERVALS MODIF ID m2,
                 s_auart  FOR vbak-auart NO INTERVALS MODIF ID m2,
                 s_doc    FOR vbak-vbeln MODIF ID m2,
                 s_sld_to FOR vbak-kunnr MODIF ID m2,
                 s_shp_to FOR vbak-kunnr MODIF ID m2,
                 s_mat    FOR vbap-matnr MODIF ID m2,
                 s_erdat  FOR vbak-erdat MODIF ID m2.
PARAMETERS     : p_abgru  TYPE abgru MODIF ID m2.
SELECT-OPTIONS : s_email   FOR adr6-smtp_addr NO INTERVALS MODIF ID m2.
SELECTION-SCREEN END OF BLOCK b2.
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
