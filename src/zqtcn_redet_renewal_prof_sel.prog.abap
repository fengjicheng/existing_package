*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_REDET_RENEWAL_PROF_SEL
* PROGRAM DESCRIPTION: Include contains program selection screen details
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-21
* OBJECT ID:E095 (CR# ERP-6293)
* TRANSPORT NUMBER(S): ED2K912365
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-027.


SELECT-OPTIONS : s_vkorg  FOR v_vkorg OBLIGATORY,
                 s_erdat  FOR v_erdat NO-EXTENSION OBLIGATORY,
                 s_vbeln  FOR v_vbeln,
                 s_auart  FOR v_auart,
                 s_shipto FOR v_ship_to_cust,
                 s_soldto FOR v_sold_to_cust,
                 s_kdgrp  FOR v_kdgrp,
                 s_konda  FOR v_konda,
                 s_paytyp FOR v_pay_type,
                 s_socoun FOR v_sold_to_country,
                 s_shcoun FOR v_ship_to_country,
                 s_licgrp FOR v_license_grp NO INTERVALS NO-EXTENSION,
                 s_office FOR v_sales_office,
                 s_subtyp FOR v_subs_type,
                 s_kdkg2  FOR v_kdkg2,
                 s_bsark  FOR v_bsark,
                 s_mvgr5  FOR v_mvgr5,
                 s_werks  FOR v_werks,
                 s_matnr  FOR v_matnr, " Generated Table for View
                 s_action FOR v_zzaction,
                 s_prof   FOR v_renwl_prof.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-028.
PARAMETERS :     p_test   TYPE char01 AS CHECKBOX DEFAULT abap_true. " Test of type CHAR01
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN END OF BLOCK b1.
