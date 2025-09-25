*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_AUTO_RES_REJ_BATCH_E505
* PROGRAM DESCRIPTION : This program implemented for to apply Reason
*                      for Rejection To Customers Back orders
* REFERENCE NO        : EAM-1661
* DEVELOPER           : Vishnuvardhan Reddy (VCHITTIBAL)
* CREATION DATE       : 06/04/2022
* OBJECT ID           : E505
* TRANSPORT NUMBER(S) : ED2K926559
*----------------------------------------------------------------------*
REPORT zqtcr_auto_res_rej_batch_e505.
TABLES:adr6, vbak,vbap.
* Type Declaration
TYPES : BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      " ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE  salv_de_selopt_low,              " Lower Value of Selection Condition
          high TYPE  salv_de_selopt_high,             " Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.

************************************************************************
*                 SELECTION SCREEN                                     *
************************************************************************
SELECT-OPTIONS : s_sorg   FOR vbak-vkorg NO INTERVALS NO-DISPLAY,
                 s_auart  FOR vbak-auart NO INTERVALS NO-DISPLAY,
                 s_doc    FOR vbak-vbeln NO-DISPLAY,
                 s_sld_to FOR vbak-kunnr NO-DISPLAY,
                 s_shp_to FOR vbak-kunnr NO-DISPLAY,
                 s_mat    FOR vbap-matnr NO-DISPLAY,
                 s_erdat  FOR vbak-erdat NO-DISPLAY.
PARAMETERS     : p_abgru  TYPE abgru NO-DISPLAY.
SELECT-OPTIONS : s_email   FOR adr6-smtp_addr NO-DISPLAY.
PARAMETERS:     p_job  TYPE tbtcjob-jobname NO-DISPLAY.
************************************************************************
*                      START-OF-SELECTION                              *
************************************************************************
START-OF-SELECTION.
  IF sy-batch = abap_true.
    MESSAGE i000(zqtc_r2) WITH 'Batch job Started'(001).
  ENDIF.

  PERFORM f_order_upd.
************************************************************************
*                      FORM ROUTINES                                   *
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  F_ORDER_UPD
*----------------------------------------------------------------------*
FORM f_order_upd.
  DATA : lv_lines TYPE i,
         li_mail   TYPE STANDARD TABLE OF ty_mail,
         li_vbeln  TYPE STANDARD TABLE OF ty_mail,
         li_type   TYPE STANDARD TABLE OF ty_mail,
         li_date   TYPE STANDARD TABLE OF ty_mail,
         li_matnr  TYPE STANDARD TABLE OF ty_mail,
         li_sld_to TYPE STANDARD TABLE OF ty_mail,
         li_shp_to TYPE STANDARD TABLE OF ty_mail.

  li_mail[]   = s_email[].
  li_vbeln[]  = s_doc[].
  li_type[]   = s_auart[].
  li_date[]   = s_erdat[].
  li_matnr[]  = s_mat[].
  li_sld_to[] = s_sld_to[].
  li_shp_to[] = s_shp_to[].
  PERFORM f_bapi_update_new_value_apl  IN PROGRAM zqtcr_ord_res_rej_upd_e186 TABLES s_sorg[]
                                                                             USING  li_vbeln[]
                                                                                    li_type[]
                                                                                    li_date[]
                                                                                    li_matnr[]
                                                                                    li_sld_to[]
                                                                                    li_shp_to[]
                                                                                    p_abgru
                                                                                    s_email
                                                                                    p_job
                                                                           CHANGING li_mail
                                                                                    lv_lines.

ENDFORM.
