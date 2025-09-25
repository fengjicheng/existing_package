*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_AUTO_RES_REJ_BATCH_E186
* PROGRAM DESCRIPTION: This program implemented for to apply Reason
*                      for Rejection To Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA)
* CREATION DATE:       01/10/2018
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
REPORT zqtcr_auto_res_rej_batch_e186.
TABLES:adr6, vbak,vbap,veda.
* Type Declaration
TYPES : BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      " ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE  salv_de_selopt_low,              " Lower Value of Selection Condition
          high TYPE  salv_de_selopt_high,             " Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.
DATA :    i_mail     TYPE STANDARD TABLE OF ty_mail,
          i_vbeln    TYPE STANDARD TABLE OF ty_mail,
          i_type     TYPE STANDARD TABLE OF ty_mail,
          i_date     TYPE STANDARD TABLE OF ty_mail,
          i_matnr    TYPE STANDARD TABLE OF ty_mail,
          i_pro      TYPE STANDARD TABLE OF ty_mail,
          i_c_date   TYPE STANDARD TABLE OF ty_mail,

          g_job_name TYPE tbtcjob-jobname.  " Job Name

************************************************************************
*                 SELECTION SCREEN                                     *
************************************************************************
*--*BOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECT-OPTIONS: s_vkorg FOR vbak-vkorg    NO-EXTENSION NO-DISPLAY.
*--*EOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln    NO-DISPLAY.
SELECT-OPTIONS: s_type  FOR vbak-auart    NO INTERVALS NO-DISPLAY.
SELECT-OPTIONS: s_date  FOR vbak-erdat    NO-DISPLAY.
SELECT-OPTIONS: s_matnr FOR vbap-matnr    NO-DISPLAY.
SELECT-OPTIONS: s_pro   FOR veda-vkuesch  NO INTERVALS NO-DISPLAY." DEFAULT 'EN' MODIF ID m2.
SELECT-OPTIONS: s_c_date FOR veda-vwundat NO-DISPLAY." DEFAULT 'EN' MODIF ID m2.
SELECT-OPTIONS: s_mail   FOR adr6-smtp_addr NO INTERVALS NO-DISPLAY." MODIF ID m3.
*--*BOC OTCM-43362 Prabhu ED2K922320 3/08/2021
SELECT-OPTIONS :s_it_cat FOR vbap-pstyv NO-DISPLAY.
PARAMETERS P_EXCL AS CHECKBOX .
*--*EOC OTCM-43362 Prabhu ED2K922320 3/08/2021
PARAMETERS:     p_job  TYPE tbtcjob-jobname NO-DISPLAY.

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
  PERFORM f_bapi_update_with_new_value IN PROGRAM zqtcr_ord_res_rej_upd_e186 TABLES s_vkorg[]
                                                                                    s_it_cat
                                                                             USING i_vbeln[]
                                                                                    i_type[]
                                                                                    i_date[]
                                                                                    i_matnr[]
                                                                                    i_pro[]
                                                                                    i_c_date[]
                                                                                    s_mail
                                                                                    p_job
                                                                                    p_excl
                                                                           CHANGING i_mail
                                                                                    lv_lines.

  IF sy-batch = c_x.
    IF lv_lines > 0.
      "MESSAGE i000(zqtc_r2) WITH 'Total'(002) lv_lines 'Subscription order are updating with new value'(003).
    ENDIF.
  ENDIF.
ENDFORM.
