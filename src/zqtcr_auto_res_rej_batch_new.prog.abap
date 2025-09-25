*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_AUTO_RES_REJ_BATCH_E186
* PROGRAM DESCRIPTION: This program implemented for to apply Reason
*                      for Rejection To Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA)
* CREATION DATE:       01/10/2018
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
REPORT zqtcr_auto_res_rej_batch_new.
TABLES:adr6, vbak,vbap,veda.
* Type Declaration
TYPES : BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      " ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE  salv_de_selopt_low,              " Lower Value of Selection Condition
          high TYPE  salv_de_selopt_high,             " Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.
DATA : i_mail     TYPE STANDARD TABLE OF ty_mail,
       i_vbeln    TYPE STANDARD TABLE OF ty_mail,
       i_type     TYPE STANDARD TABLE OF ty_mail,
       i_date     TYPE STANDARD TABLE OF ty_mail,
       i_matnr    TYPE STANDARD TABLE OF ty_mail,
       i_pro      TYPE STANDARD TABLE OF ty_mail,
       i_c_date   TYPE STANDARD TABLE OF ty_mail,
       i_item_cat TYPE STANDARD TABLE OF ty_mail, "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
       i_item_srp TYPE STANDARD TABLE OF ty_mail, "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
       g_job_name TYPE tbtcjob-jobname.  " Job Name

************************************************************************
*                 SELECTION SCREEN                                     *
************************************************************************
SELECT-OPTIONS : s_vkorg FOR vbak-vkorg NO INTERVALS NO-EXTENSION NO-DISPLAY.
SELECT-OPTIONS : s_vtweg FOR vbak-vtweg NO-DISPLAY.
SELECT-OPTIONS : s_spart FOR vbak-spart NO-DISPLAY.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln    NO-DISPLAY.
SELECT-OPTIONS: s_type  FOR vbak-auart    NO INTERVALS NO-DISPLAY.
SELECT-OPTIONS: s_date  FOR vbak-erdat    NO-DISPLAY.
SELECT-OPTIONS: s_matnr FOR vbap-matnr    NO-DISPLAY.
SELECT-OPTIONS: s_pro   FOR veda-vkuesch  NO INTERVALS NO-DISPLAY." DEFAULT 'EN' MODIF ID m2.
SELECT-OPTIONS: s_c_date FOR veda-vwundat NO-DISPLAY." DEFAULT 'EN' MODIF ID m2.
SELECT-OPTIONS: s_mail   FOR adr6-smtp_addr NO INTERVALS NO-DISPLAY." MODIF ID m3.
PARAMETERS:     p_job  TYPE tbtcjob-jobname NO-DISPLAY.
PARAMETERS : p_test TYPE c AS CHECKBOX DEFAULT 'X'.
*- Begin of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
SELECT-OPTIONS :s_it_cat FOR vbap-pstyv NO-DISPLAY.
SELECT-OPTIONS :s_it_srp FOR vbap-pstyv NO-DISPLAY.
*- End of ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695

************************************************************************
*               Local Constants Declaration
************************************************************************
CONSTANTS :     c_x    TYPE c VALUE 'X'.

************************************************************************
*                      START-OF-SELECTION                              *
************************************************************************
START-OF-SELECTION.
  IF sy-batch = c_x.
    MESSAGE i000(zqtc_r2) WITH 'Batch job Started'(001).
  ENDIF.

  PERFORM order_upd.

END-OF-SELECTION.
************************************************************************
*                      FORM ROUTINES                                   *
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  ORDER_UPD
*----------------------------------------------------------------------*
FORM order_upd.
  DATA : lv_lines TYPE i.
  i_mail[] = s_mail[].
  i_vbeln[] = s_vbeln[].
  i_type[]  = s_type[].
  i_date[] = s_date[].
  i_matnr[] = s_matnr[].
  i_pro[] = s_pro[].
  i_c_date[] = s_c_date[].
  i_item_cat[] = s_it_cat[].  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  i_item_srp[] = s_it_srp[].  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
  PERFORM f_bapi_update_with_new_value IN PROGRAM zqtcr_ord_res_rej_upd_e186_new  TABLES
                                                                                    s_vkorg[] "Prabhu
                                                                                    s_vtweg[]
                                                                                    s_spart[]
                                                                           USING    p_test
                                                                                    i_vbeln[]
                                                                                    i_type[]
                                                                                    i_date[]
                                                                                    i_matnr[]
                                                                                    i_pro[]
                                                                                    i_c_date[]
                                                                                    s_mail
                                                                                    p_job
                                                                                    i_item_cat[]  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                                                                                    i_item_srp[]  "ADD:OTCM-29655:SGUDA:21-Dec-2020:ED2K915695
                                                                           CHANGING i_mail
                                                                                    lv_lines.

  IF sy-batch = c_x.
    IF lv_lines > 0.
      MESSAGE i000(zqtc_r2) WITH 'Total' lv_lines 'Subscription order are updated with new value'(003).
    ENDIF.
  ENDIF.
ENDFORM.
