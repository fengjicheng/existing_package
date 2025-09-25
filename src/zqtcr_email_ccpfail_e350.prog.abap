*&---------------------------------------------------------------------*
*& Report  /cditech/report
*&---------------------------------------------------------------------*
REPORT  zqtcr_email_ccpfail_e350.
* Report name   : /cditech/report                                      *
* SAP Module    : SD                                                   *
* Title         : Report based on credit card usage                    *
*                                                                      *
* Author        : Muthu Subramanian                                    *
*                 Copyright (c) 2018                                  *
*                 CDI Technology, LLC                                  *
*                                                                      *
*                 This unpublished material is proprietary to          *
*                 CDI Technology,LLC All rights reserved. The methods  *
*                 and techniques described herein are considered trade *
*                 secret and/or confidential. Reproduction or          *
*                 distribution, in whole or in part, is forbidden      *
*                 except by express written permission of              *
*                 CDI Technology, LLC                                  *
* Description   : Report on credit card orders                         *
*----------------------------------------------------------------------*
* Version Change History                                               *
*                                                                      *
* Version 1.00  : 08/16/2016  Muthu Subramanian                        *
*                 Initial version.                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_EMAIL_CCPFAIL (Executable Program)
* PROGRAM DESCRIPTION: Copied from standard program /cditech/report
*                      Added Additional functionality for send email
*                      notification to customer on Payment failure of
*                      Credit Card
* DEVELOPER:           SURYA (SNGUNTUPAL) / Himanshu (HIPATEL)
* CREATION DATE:       11/12/2018
* OBJECT ID:           R080 (ERP-6370)
* TRANSPORT NUMBER(S): ED2K913836 / ED2K913966 / ED2K913974 / ED2K914084
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909522 / ED1K909550 / ED1K909579 / ED1K909691 /
*              ED1K909778 / ED1K909780 / ED1K909840 / ED1K909993
* REFERENCE NO: INC0229621
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  02/07/2019
* DESCRIPTION: Emails are not triggered to the BP's whose payments are
*              failed , even though mail id is maintained for
*              communication. Job log is not having details for
*              both Success/Failed emails.
*              The notification should be triggered along with spool
*              to the DL, only when there are errors
*           -  Print original Order number instead of reference number
*              for ZCSS order
*           -  If no Price Group available in Order then Print
*              First records for Customer's Country
*           -  Preauthorized Card should not display in the list
*           -  DAY1 field from ZQTC_CCP_NOTIF for calculation to
*              send notification for Day 30, Day 60, Day 90, Day 120,
*              Day 150, Day 180.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K925616
* REFERENCE NO:  OTCM-53244
* DEVELOPER: MRAJKUMAR
* DATE:  25/01/2022
* DESCRIPTION:  This is the copy of program ZQTCR_EMAIL_CCPFAIL and as per
*               OTCM-53244 made changes to send emails for CC authorization
*               fails
*----------------------------------------------------------------------*
TYPES:BEGIN OF ty_final,
* Credit card info
        fplnr      TYPE fplnr,
        fpltr      TYPE fpltr,
        ccins      TYPE ccins,
        ccnum      TYPE ccnum,
        audat      TYPE audat_cc,
        autim      TYPE autim,
        expdat     TYPE audat_cc,
        valdty     TYPE verzn,
        ccname     TYPE ccname,
        autwr      TYPE autwr,
        ccwae      TYPE waers,
        aunum      TYPE aunum,
        autra      TYPE autra,
        merch      TYPE merch,
        cctyp      TYPE cctyp,
        ccaua      TYPE ccaua,
        ccall      TYPE ccall,
        react      TYPE react_sd,
        autwv      TYPE autwv,
        rtext      TYPE rtext_cc,
        vbeln      TYPE vbeln_va,  "Sales order
        erdat      TYPE erdat,
        gbstk      TYPE gbstk,
        cmgst      TYPE cmgst, "* Overall Order credit status info.
        status_acc TYPE status_acc,
        kunnr      TYPE kunnr,
        bukrs_vf   TYPE bukrs_vf,
        inco1      TYPE inco1,
        inco2      TYPE inco2,
        payer      TYPE kunrg,
        soldto     TYPE kunag,
        billto     TYPE kunre,
        shipto     TYPE kunwe,
        ernam      TYPE ernam,
        zuonr      TYPE ordnr_v,  "dzuonr,
        xblnr      TYPE xblnr_v1, "Reference Doc
        xblnr2     TYPE vbeln_vf, " Billing from VBRK
        bukrs      TYPE bukrs,
        belnr      TYPE belnr_d,
        gjahr      TYPE gjahr,
        rfzei      TYPE rfzei_cc,
        sgtxt      TYPE sgtxt,
        ccbtc      TYPE ccbtc, "Payment cards: Settlement run
        dmbtr      TYPE dmbtr,
        wrbtr      TYPE wrbtr,
        fdatu      TYPE fdatu_cc,
        ldatu      TYPE ldatu_cc,
        vblnr      TYPE vblnr,
        gjahr_st   TYPE gjahr,
        xsucc      TYPE xsucc_cc,
        xfail      TYPE xfail_cc,
        vkorg      TYPE vkorg,
        vtweg      TYPE vtweg,
        spart      TYPE spart,
        auart      TYPE auart,
        netwr      TYPE netwr_ak,
        usnam      TYPE usnam,
      END OF ty_final,

      BEGIN OF ty_crcard,
        fplnr  TYPE fplnr,
        fpltr  TYPE fpltr,
        ccins  TYPE ccins,
        ccnum  TYPE ccnum,
        audat  TYPE audat_cc,
        autim  TYPE autim,
        ccname TYPE ccname,
        autwr  TYPE autwr,
        ccwae  TYPE waers,
        aunum  TYPE aunum,
        autra  TYPE autra,
        merch  TYPE merch,
        cctyp  TYPE cctyp,
        ccaua  TYPE ccaua,
        ccall  TYPE ccall,
        react  TYPE react_sd,
        autwv  TYPE autwv,
        rtext  TYPE rtext_cc,
      END OF ty_crcard,

      BEGIN OF ty_so,
        vbeln    TYPE vbeln_va,
        erdat    TYPE erdat,
        ernam    TYPE ernam,
        auart    TYPE auart,
        vkorg    TYPE vkorg,
        vtweg    TYPE vtweg,
        spart    TYPE spart,
        rplnr    TYPE rplnr,
        kunnr    TYPE kunnr,
        netwr    TYPE netwr_ak,
        bukrs_vf TYPE bukrs_vf,
        inco1    TYPE inco1,
        inco2    TYPE inco2,
      END OF ty_so,
      BEGIN OF ty_vbuk,
* Header Credit status
        vbeln TYPE vbeln,
        gbstk TYPE gbstk,
        cmgst TYPE cmgst,
      END OF ty_vbuk,
      BEGIN OF ty_bkpf,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        rfzei TYPE rfzei_cc,
        xblnr TYPE xblnr1,
        ccins TYPE ccins,
        ccnum TYPE ccnum,
        aunum TYPE aunum,
        ccbtc TYPE ccbtc,
        dmbtr TYPE dmbtr,
        wrbtr TYPE wrbtr,
      END OF ty_bkpf,
*BOC <ERP-6370> <ED2K913836>
      BEGIN OF ty_kna1,
        kunnr      TYPE kna1-kunnr,
        land1      TYPE kna1-land1,
        name1      TYPE kna1-name1,
        spras      TYPE kna1-spras,
        email      TYPE adr6-smtp_addr,
        deflt_comm TYPE adrc-deflt_comm,      "Communication Method (Key) (Business Address Services)
      END OF   ty_kna1,
      BEGIN OF ty_custser,
        sales_model  TYPE zqtc_ctry_reg-sales_model,
        region       TYPE zqtc_ctry_reg-region,
        land1        TYPE zqtc_ctry_reg-land1,
        konda        TYPE zqtc_reg_ser-konda,
        service_info TYPE zqtc_reg_ser-service_info,
      END OF   ty_custser,
      BEGIN OF ty_vbkd,
        vbeln   TYPE vbeln,     "Sales and Distribution Document Number
        posnr   TYPE posnr,     "Item number of the SD document
        konda   TYPE konda,     "Price group (customer)
        kdgrp   TYPE kdgrp,     "Customer group
        inco1   TYPE inco1,     "Incoterms (Part 1)
        inco2   TYPE inco2,     "Incoterms (Part 2)
*BOC <ERP-6370> <ED2K913974>
        ihrez_e TYPE ihrez_e, "Your reference
*EOC <ERP-6370> <ED2K913974>
      END OF ty_vbkd,

      BEGIN OF ty_vbap,
        vbeln TYPE vbeln_va,       "Sales Document
        posnr TYPE posnr_va,       "Sales Document Item
        mvgr5 TYPE mvgr5,          "Material group 5
      END OF ty_vbap,
*EOC <ERP-6370> <ED2K913836>
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
      BEGIN OF ty_joblog,
        vbeln TYPE vbeln_va,      "Sales Document
        vkorg TYPE vkorg,         "Sales Organization
        vtweg TYPE vtweg,         "Distribution Channel
        spart TYPE spart,         "Division
        kunnr TYPE kunag,         "Sold-to party
        name1 TYPE zzsoldtonm,    "Sold-To party name
        afdat TYPE audat_cc,      "Payment cards: Authorization date
        audat TYPE audat,         "Document Date (Date Received/Sent)
        netwr TYPE bbpvalue,      "Net Value
        waerk TYPE waerk,         "SD Document Currency
        mstyp TYPE char01,        "Message Type Sucess/Error
        mslog TYPE hrpades_sh_msg, "Status message
      END OF ty_joblog,
      tt_joblog TYPE STANDARD TABLE OF ty_joblog INITIAL SIZE 0,

      BEGIN OF ty_fpltc,
        fplnr TYPE fplnr,     "Billing plan number / invoicing plan number
        fpltr TYPE fpltr,     "Item for billing plan/invoice plan/payment cards
        audat TYPE audat_cc,  "Payment cards: Authorization date
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        react TYPE react_sd,   "Payment cards: Response to authorization checks
        rcrsp TYPE rcrsp_cc,   "Payment cards: Result of card check (response code)
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      END OF ty_fpltc,

      tt_list TYPE STANDARD TABLE OF vrm_value,
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
*Type declaration for ZCACONSTANT table
      BEGIN OF ty_const,
        devid  TYPE zdevid,              "Development ID
        param1 TYPE rvari_vnam,          "Parameter1
        param2 TYPE rvari_vnam,          "Parameter2
        srno   TYPE tvarv_numb,          "Serial Number
        sign   TYPE tvarv_sign,          "Sign
        opti   TYPE tvarv_opti,          "Option
        low    TYPE salv_de_selopt_low,  "Low
        high   TYPE salv_de_selopt_high, "High
      END OF ty_const,
      tt_const TYPE STANDARD TABLE OF ty_const,
*EOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      BEGIN OF ty_vbak,
        vbeln TYPE vbeln_va,      "Sales Document
        audat TYPE audat,         "Document date
        rplnr TYPE rplnr,         "Number of payment card plan type
      END OF ty_vbak,
      tt_vbak    TYPE STANDARD TABLE OF ty_vbak,
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      ty_vbeln   TYPE RANGE OF vbeln,
      ty_bsas    TYPE STANDARD TABLE OF bsas,
      ty_final_t TYPE STANDARD TABLE OF ty_final.

TABLES: fpltc,vbak,vbrk,bkpf,vbkd,tcclg,bsad,
        adr6.     "+ <HIPATEL> <INC0229621> <ED1K909522>

CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: wa_crcard         TYPE ty_crcard,
      it_crcard         TYPE TABLE OF ty_crcard,
      wa_so             TYPE ty_so,
      it_so             TYPE TABLE OF ty_so,
      it_final          TYPE STANDARD TABLE OF ty_final,
      lt_final          TYPE STANDARD TABLE OF ty_final,
      lt_final1         TYPE STANDARD TABLE OF ty_final,
*BOC <ERP-6370> <ED2K913836>
      it_kna1           TYPE STANDARD TABLE OF ty_kna1,
      it_kna1x          TYPE STANDARD TABLE OF ty_kna1,
      it_ser            TYPE STANDARD TABLE OF ty_custser,
      it_vbkd           TYPE STANDARD TABLE OF ty_vbkd,
      it_vbap           TYPE STANDARD TABLE OF ty_vbap,
      wa_vbap           TYPE ty_vbap,
      wa_vbkd           TYPE ty_vbkd,
      wa_ser            TYPE ty_custser,
      wa_kna1           TYPE ty_kna1,
*EOC <ERP-6370> <ED2K913836>
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
      i_joblog          TYPE STANDARD TABLE OF ty_joblog,
      st_joblog         TYPE ty_joblog,
      i_fpltc           TYPE STANDARD TABLE OF ty_fpltc,
      st_fpltc          TYPE ty_fpltc,
      i_list            TYPE STANDARD TABLE OF vrm_value,
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      i_vbak            TYPE STANDARD TABLE OF ty_vbak,
      st_vbak           TYPE ty_vbak,
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      wa_final          TYPE ty_final,
      lwa_final         TYPE ty_final,
      lwa_final1        TYPE ty_final,
      it_dummy          TYPE lvc_t_fcat,
      lwa_dummy         TYPE lvc_s_fcat,
      lwa_bkpf          TYPE ty_bkpf,
      lt_bkpf           TYPE STANDARD TABLE OF ty_bkpf,
      lt_vbfa           TYPE STANDARD TABLE OF vbfa,
      lwa_vbfa          TYPE vbfa,
      lt_vbpa           TYPE STANDARD TABLE OF vbpa,
      lwa_vbpa          TYPE vbpa,
      lt_tcclg          TYPE STANDARD TABLE OF tcclg,
      lwa_tcclg         TYPE tcclg,
      lwa_vbuk          TYPE ty_vbuk,
      lt_vbuk           TYPE STANDARD TABLE OF ty_vbuk,
      lwa_vbrk          TYPE vbrk,
      lt_vbrk           TYPE STANDARD TABLE OF vbrk,
      lwa_vbak          TYPE vbak,
      lt_vbak           TYPE STANDARD TABLE OF vbak,
      lt_vbak1          TYPE STANDARD TABLE OF vbak,
      lwa_fpltc         TYPE fpltc,
      lt_fpltc          TYPE STANDARD TABLE OF fpltc,
      lr_vbeln          TYPE RANGE OF vbeln,
      lwa_vbeln         TYPE LINE OF ty_vbeln,
      lt_bsas           TYPE STANDARD TABLE OF bsas,
      lwa_bsas          TYPE bsas,
      lt_bsad           TYPE STANDARD TABLE OF bsad,
      lwa_bsad          TYPE bsad,
      lt_bsis           TYPE STANDARD TABLE OF bsis,
      lwa_bsis          TYPE bsis,
      lt_bsegc          TYPE STANDARD TABLE OF bsegc,
      lwa_bsegc         TYPE bsegc,
      ls_selected_line  TYPE lvc_s_row,
      g_dock_container1 TYPE REF TO cl_gui_docking_container,  "Container
      g_grid1           TYPE REF TO cl_gui_alv_grid,          "CCReport window
      gs_layout         TYPE lvc_s_layo,
      lw_disvariant     TYPE disvariant,
      event_receiver    TYPE REF TO lcl_event_receiver,
      lwa_tvcin         TYPE tvcin,
      lt_tvcin          TYPE STANDARD TABLE OF tvcin,
      lv_count          TYPE i,
      lv_text           TYPE string,
      gs_column_id      TYPE lvc_s_col,
      gv_row_id         TYPE i,
      gv_paramvalue     TYPE /cditech/spay_paramvalue,
      lv_maxcount       TYPE i,
*BOC <ERP-6370> <ED2K913836>
*BOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      i_const           TYPE STANDARD TABLE OF ty_const,
      st_const          TYPE ty_const,
*EOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      lv_vbeln          TYPE text12, "vbak-vbeln, "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      lv_tel            TYPE char50,
      gt_rows           TYPE lvc_t_row,
      gv_cnt            TYPE n,
      gv_sndat          TYPE vbak-erdat,
      gv_rcdat          TYPE vbak-erdat,
      wa_ccp            TYPE zqtc_ccp_notif,
      lt_ccp            TYPE STANDARD TABLE OF zqtc_ccp_notif,
      lt_ccp_a          TYPE STANDARD TABLE OF zqtc_ccp_notif,
      lt_ccp_d          TYPE STANDARD TABLE OF zqtc_ccp_notif,
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
      lv_dup_notif      TYPE char01,
      lt_ccp_notif      TYPE STANDARD TABLE OF zqtc_ccp_notif.
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019

*RANGES: gr_erdat FOR vbak-erdat.
*EOC <ERP-6370> <ED2K913836>
DATA: send_request   TYPE REF TO cl_bcs,
      document       TYPE REF TO cl_document_bcs,
      recipient      TYPE REF TO if_recipient_bcs,
      bcs_exception  TYPE REF TO cx_bcs,
      main_text      TYPE bcsy_text,
      binary_content TYPE solix_tab,
      size           TYPE so_obj_len,
      sent_to_all    TYPE os_boolean,
      gv_string      TYPE string.
DATA: v_send_request   TYPE REF TO cl_bcs VALUE IS INITIAL,
      v_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  "document object
      v_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL,    "sender
      v_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, "recipient
      v_attsubject     TYPE sood-objdes,
      i_binary_content TYPE solix_tab,
      cx_bcs_exception TYPE REF TO cx_bcs,
      v_msg_text       TYPE string.
CONSTANTS: c_tab   TYPE c        VALUE cl_bcs_convert=>gc_tab,
           c_crlf  TYPE c        VALUE cl_bcs_convert=>gc_crlf,
           c_score TYPE char1    VALUE '_',
           c_x     TYPE char1    VALUE 'X',
           c_i     TYPE char1    VALUE 'I',
           c_p     TYPE char1    VALUE 'P',
           c_eq    TYPE char2    VALUE 'EQ'.
*BOC <ERP-6370> <ED2K914084>
**Range type declaration for Response to authorization checks
RANGES: gr_react FOR fpltc-react.

CONSTANTS:
  c_sign_incld TYPE ddsign      VALUE 'I',     "Sign: (I)nclude
  c_opti_equal TYPE ddoption    VALUE 'EQ',    "Option: (EQ)ual
  c_b          TYPE react_sd    VALUE 'B',     "Unsuccessful: authorize later
  c_c          TYPE react_sd    VALUE 'C',     "Unsuccessful: set authorization lock
  c_e          TYPE char01      VALUE 'E',     "Error + <HIPATEL> <INC0229621>
  c_s          TYPE char01      VALUE 'S',     "Sucess + <HIPATEL> <INC0229621>
*BOC <ERP-6370> <ED2K914084>
*BOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
  c_devid_r080 TYPE zdevid       VALUE 'R080',      "Development ID
  c_auart      TYPE rvari_vnam   VALUE 'AUART', "ABAP: Name of Variant Variable
*EOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
  c_pos        TYPE char01       VALUE '1',     "Failure type
  c_neg        TYPE char02       VALUE '-1'.    "Failure Type
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: handle_toolbar         FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object e_interactive,
      handle_user_command    FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      handle_hotspot_click_1 FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id.
ENDCLASS.                    "lcl_event_receiver DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
* append a separator to normal toolbar
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.
* append an icon to show document flow
    CLEAR ls_toolbar.
    MOVE 'DOCFLOW' TO ls_toolbar-function.
    MOVE icon_employee TO ls_toolbar-icon.
    MOVE 'Show Doc Flow'(004) TO ls_toolbar-quickinfo.
    MOVE 'Document Flow'(005) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.
* append an icon to Forward to authorize
    CLEAR ls_toolbar.
    MOVE 'FRWD' TO ls_toolbar-function.
    MOVE icon_column_right TO ls_toolbar-icon.
    MOVE 'Forward to Authorization'(006) TO ls_toolbar-quickinfo.
    MOVE 'Forward to Authorization'(006) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.
* append an icon to refresh
    CLEAR ls_toolbar.
    MOVE 'REFR'         TO ls_toolbar-function.
    MOVE icon_refresh   TO ls_toolbar-icon.
    MOVE 'Refresh'(018) TO ls_toolbar-quickinfo.
    MOVE 'Refresh'(018) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.
* append an icon to show settled items for a settlement no
    CLEAR ls_toolbar.
    MOVE 'FCCR1'(041)    TO ls_toolbar-function.
    MOVE icon_overview  TO ls_toolbar-icon.
    MOVE 'Display payment card Transactions'(043) TO ls_toolbar-quickinfo.
    MOVE 'Transactions'(044) TO ls_toolbar-text.
    MOVE ' '            TO ls_toolbar-disabled.
    APPEND ls_toolbar   TO e_object->mt_toolbar.
*BOC <ERP-6370> <ED2K913836>
* append an icon to show settled items for send email
    CLEAR ls_toolbar.
    MOVE 'SEML'(055)    TO ls_toolbar-function.
    MOVE icon_mail  TO ls_toolbar-icon.
    MOVE 'Send Email'(054) TO ls_toolbar-quickinfo.
    MOVE 'Send Email'(054) TO ls_toolbar-text.
    MOVE ' '            TO ls_toolbar-disabled.
    APPEND ls_toolbar   TO e_object->mt_toolbar.
*EOC <ERP-6370> <ED2K913836>
* append an icon to show settled items for a settlement no
    CLEAR ls_toolbar.
    MOVE 'FCCR2'(046)                     TO ls_toolbar-function.
    MOVE icon_overview                    TO ls_toolbar-icon.
    MOVE 'G/L account items'(047)         TO ls_toolbar-quickinfo.
    MOVE 'Display G/L account items'(048) TO ls_toolbar-text.
    MOVE ' '            TO ls_toolbar-disabled.
    APPEND ls_toolbar   TO e_object->mt_toolbar.
* append an icon to show settled items for a settlement no
    CLEAR ls_toolbar.
    MOVE 'FCCR3'(049)                     TO ls_toolbar-function.
    MOVE icon_protocol                    TO ls_toolbar-icon.
    MOVE 'Display settlement log'(050)    TO ls_toolbar-quickinfo.
    MOVE 'Display settlement log'(050)    TO ls_toolbar-text.
    MOVE ' '            TO ls_toolbar-disabled.
    APPEND ls_toolbar   TO e_object->mt_toolbar.
    IF sy-uname = 'MUTSUBRAMA'.
* append an icon to rerun settlement for a settlement no
      CLEAR ls_toolbar.
      MOVE 'FCC2'(030)         TO ls_toolbar-function.
      MOVE 'FCC2'(030)         TO ls_toolbar-text.
      MOVE icon_execute_object TO ls_toolbar-icon.
      MOVE ' '                 TO ls_toolbar-disabled.
      APPEND ls_toolbar        TO e_object->mt_toolbar.
    ENDIF.
  ENDMETHOD.                    "handle_toolbar
*-------------------------------------------------------------------
  METHOD handle_user_command.

    DATA: lt_rows TYPE lvc_t_row.

    CASE e_ucomm.
      WHEN 'DOCFLOW'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        PERFORM show_document TABLES lt_rows.
      WHEN 'FRWD'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        IF lt_rows IS INITIAL.
          MESSAGE i208(00) WITH text-027. "Select a record to perform this function.
        ELSE.
          PERFORM forw_auth TABLES lt_rows.
        ENDIF.
      WHEN 'REFR'.
        REFRESH it_final[].
        PERFORM get_data.
        DESCRIBE TABLE it_final LINES lv_count.
        lv_text = lv_count.
        CONCATENATE text-014 lv_text INTO lv_text.
        CLEAR lv_count.
        CALL METHOD g_grid1->refresh_table_display.
      WHEN 'FCCR1'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        PERFORM show_tran TABLES lt_rows.
      WHEN 'FCCR2'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        PERFORM show_items TABLES lt_rows.
      WHEN 'FCCR3'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        PERFORM show_header TABLES lt_rows.
      WHEN 'FCC2'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        IF lt_rows IS INITIAL.
          MESSAGE i208(00) WITH text-045.
        ELSE.
          PERFORM rerun_settlement TABLES lt_rows.
        ENDIF.
*BOC <ERP-6370> <ED2K913836>
      WHEN 'SEML'.
        CALL METHOD g_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        CALL METHOD cl_gui_cfw=>flush.
        IF lt_rows IS INITIAL.
          MESSAGE i208(00) WITH text-027. "Select a record to perform this function.
        ELSE.
          PERFORM send_email TABLES lt_rows.
        ENDIF.
*EOC <ERP-6370> <ED2K913836>
    ENDCASE.
  ENDMETHOD.                           "handle_user_command
  METHOD handle_hotspot_click_1.
    gv_row_id                   = e_row_id-index.
    IF gv_row_id NE 0.
      gs_column_id              = e_column_id.
      READ TABLE it_final INDEX gv_row_id INTO lwa_final.
      PERFORM process_events_grid1.
    ENDIF.
  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK_1
*-----------------------------------------------------------------
ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-002.
SELECT-OPTIONS ccins FOR fpltc-ccins.
SELECT-OPTIONS ccnum FOR fpltc-ccnum.
SELECT-OPTIONS ccname FOR fpltc-ccname.
SELECT-OPTIONS autwr FOR fpltc-autwr.
*Begin of Change MRAJKUMAR OTCM-53244   ED2K925616 25-JAN-2022
SELECT-OPTIONS audat FOR fpltc-audat.
*End of Change MRAJKUMAR OTCM-53244   ED2K925616 25-JAN-2022
SELECT-OPTIONS autim FOR fpltc-autim.
SELECT-OPTIONS ccwae FOR fpltc-ccwae.
SELECT-OPTIONS merch FOR fpltc-merch.
SELECT-OPTIONS ccaua FOR fpltc-ccaua.
SELECT-OPTIONS ccall FOR fpltc-ccall.
SELECT-OPTIONS react FOR fpltc-react.
SELECT-OPTIONS aunum FOR fpltc-aunum.
SELECT-OPTIONS autra FOR fpltc-autra.
SELECT-OPTIONS rtext FOR fpltc-rtext.
PARAMETER p_noauth AS CHECKBOX DEFAULT ''.
SELECTION-SCREEN END OF BLOCK a1.

*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
SELECTION-SCREEN BEGIN OF BLOCK a4 WITH FRAME TITLE text-061.
SELECTION-SCREEN BEGIN OF LINE.
*PARAMETERS: p_email TYPE ad_smtpadr VISIBLE LENGTH 35.
SELECTION-SCREEN COMMENT 01(31) text-t03 FOR FIELD p_ddwn1.
PARAMETERS: p_ddwn1  AS LISTBOX VISIBLE LENGTH 10 DEFAULT 'E'.
SELECTION-SCREEN POSITION POS_LOW.
SELECTION-SCREEN COMMENT 48(06) text-t02 FOR FIELD s_email.
SELECT-OPTIONS: s_email FOR adr6-smtp_addr NO INTERVALS. " VISIBLE LENGTH 45.
SELECTION-SCREEN POSITION POS_HIGH.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK a4.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-008.
SELECT-OPTIONS ccbtc FOR fpltc-ccbtc.
SELECT-OPTIONS fdatu FOR tcclg-fdatu.
SELECT-OPTIONS dmbtr FOR bsad-dmbtr.
SELECTION-SCREEN END OF BLOCK a2.

SELECTION-SCREEN BEGIN OF BLOCK a3 WITH FRAME TITLE text-003.
SELECT-OPTIONS kunnr FOR vbak-kunnr.
SELECT-OPTIONS payer FOR vbak-kunnr.
SELECT-OPTIONS auart FOR vbak-auart.
SELECT-OPTIONS vkorg FOR vbak-vkorg.
SELECT-OPTIONS vbeln FOR vbak-vbeln.
SELECT-OPTIONS inco1 FOR vbkd-inco1.
SELECT-OPTIONS cr_by FOR vbak-ernam.
SELECT-OPTIONS xblnr FOR bkpf-xblnr.
SELECT-OPTIONS zuonr FOR vbrk-zuonr.
SELECT-OPTIONS xblnr2 FOR vbrk-vbeln.
SELECT-OPTIONS bukrs FOR bkpf-bukrs.
SELECT-OPTIONS belnr FOR bkpf-belnr.
SELECT-OPTIONS gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF BLOCK a3.

SELECTION-SCREEN BEGIN OF BLOCK disp_var WITH FRAME TITLE text-017.
PARAMETERS: p_vari  TYPE disvariant-variant.         "ALV Display Variant
SELECTION-SCREEN END OF BLOCK disp_var.

* When user request a list of available variants for this report.
* F4 vlaues for ALV variant
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM list_of_disp_var  CHANGING p_vari.

INITIALIZATION.

  AUTHORITY-CHECK OBJECT 'ZSNAPPAY' ID 'ACTVT' FIELD '33'.
  IF sy-subrc <> 0.
    MESSAGE e208(00) WITH text-012. "'You are not authorized'.
    RETURN.
  ENDIF.
  IF sy-subrc <> 0.
    MESSAGE i208(00) WITH text-011. "'No data found'.
  ENDIF.

*BOC <ERP-6370> <ED2K913966>
*  autwr-sign   = 'E'.
*  autwr-option = 'EQ'.
*  autwr-low    = '0'.
*  APPEND autwr.

*  react-sign   = 'I'.
*  react-option = 'EQ'.
*  react-low    = 'A'.
*  APPEND react.
*EOC <ERP-6370> <ED2K913966>

*BOC <ERP-6370> <ED2K914084>
* To build the Response to authorization checks range
  REFRESH gr_react.
  gr_react-sign = c_sign_incld.
  gr_react-option = c_opti_equal.
  gr_react-low = c_b.        "Unsuccessful: authorize later
  APPEND gr_react TO gr_react.

  gr_react-low = c_c.        "Unsuccessful: set authorization lock
  APPEND gr_react TO gr_react.
*EOC <ERP-6370> <ED2K914084>

  ccins-sign   = 'I'.
  ccins-option = 'EQ'.
  ccins-low    = 'VISA'.
  APPEND ccins.
  ccins-low    = 'MC'.
  APPEND ccins.
  ccins-low    = 'AMEX'.
  APPEND ccins.
  ccins-low    = 'DISC'.
  APPEND ccins.
*BOC <ERP-6370> <ED2K913966>
*  audat-sign   = 'I'.
*  audat-option = 'BT'.
*  audat-low    = sy-datum - 60.
*  audat-high   = sy-datum.
*  APPEND audat.
*EOC <ERP-6370> <ED2K913966>

*BOC <ERP-6370> <ED2K913966>
  autim-sign   = 'I'.
  autim-option = 'BT'.
  autim-low    = '000000'.
  autim-high   = '235959'.
  APPEND autim.

  ccall-sign   = 'I'.
  ccall-option = 'EQ'.
  ccall-low    = 'C'.
  APPEND ccall.
*EOC <ERP-6370> <ED2K913966>
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*  Populate list fields
  PERFORM f_populate_list CHANGING i_list.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>


START-OF-SELECTION.

  SET PF-STATUS 'SNAPPAY REPORT'.
  SET TITLEBAR 'SNAPPAY REPORT'.

*BOC <ERP-6370> <ED2K913836>
*  CLEAR: gr_erdat, gr_erdat[], gt_rows[].
*  IF sy-batch IS NOT INITIAL.
*    gr_erdat-sign   = 'I'.
*    gr_erdat-option = 'EQ'.
*    gr_erdat-low    = sy-datum.
*    APPEND gr_erdat.
*  ENDIF.
*EOC <ERP-6370> <ED2K913836>

  IF p_noauth = 'X'.
* If this flag is checked, collect only records that doesnt have any auth data
* and return
    PERFORM collect_noauth_items.
    IF it_final[] IS INITIAL.
      MESSAGE i208(00) WITH text-013. "'No data found'.
    ELSE.
      IF sy-batch <> 'X'.
        CALL SCREEN 100.
      ELSE.
        PERFORM background_display.
      ENDIF.
    ENDIF.
    RETURN.
  ENDIF.

* Get the configuration for authorization validity
  IF lt_tvcin[] IS INITIAL.
    SELECT * FROM tvcin INTO TABLE lt_tvcin.
    IF sy-subrc <> 0.
      MESSAGE i208(00) WITH text-010. "'No data found in TVCIN'.
    ELSE.
      SORT lt_tvcin[] BY ccins.
    ENDIF.
  ENDIF.

  PERFORM get_data.
  IF it_final[] IS NOT INITIAL.
    IF sy-batch <> 'X'.
      CALL SCREEN 100.
    ELSE.
*BOC <ERP-6370> <ED2K913836>
*Begin of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
*      PERFORM send_email TABLES gt_rows.
      IF s_email[] IS NOT INITIAL.
        PERFORM f_create_email_content.
        PERFORM f_send_outout_email.
      ENDIF.
      PERFORM background_display.
*End of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
*EOC <ERP-6370> <ED2K913836>
    ENDIF.
*BOC <ERP-6370> <ED2K913836>
  ELSE.
    MESSAGE i208(00) WITH text-013. "'No data found'.
    LEAVE LIST-PROCESSING.
*EOC <ERP-6370> <ED2K913836>
  ENDIF.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS '0100'.
  SET TITLEBAR 'CREDITCARDREPORT'.

  CREATE OBJECT g_dock_container1
    EXPORTING
      repid     = sy-repid
      extension = 2000
      ratio     = '95'.
  CREATE OBJECT g_grid1
    EXPORTING
      i_parent = g_dock_container1.

  DESCRIBE TABLE it_final LINES lv_count.
  lv_text = lv_count.
  CONCATENATE text-014 lv_text INTO lv_text.
  CLEAR lv_count.

  lw_disvariant-report   = sy-repid.
  lw_disvariant-variant  = p_vari.
  lw_disvariant-username = sy-uname.

  gs_layout-grid_title = lv_text.
  gs_layout-sel_mode   = 'A'.
  gs_layout-info_fname = 'I_COLOR'.

  CALL METHOD g_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = '/CDITECH/CRCARD_RPT'
      is_layout        = gs_layout
      is_variant       = lw_disvariant
      i_save           = 'A' "'U' "c_x
    CHANGING
      it_outtab        = it_final.

  " Get the existing field catalog.
  " -------------------------------
  CALL METHOD g_grid1->get_frontend_fieldcatalog
    IMPORTING
      et_fieldcatalog = it_dummy[].

* Hide Columns
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'FPLNR'.
  IF sy-subrc = 0.
    IF lwa_dummy-no_out = 'X'.
    ELSE.
      lwa_dummy-no_out = 'X'.
    ENDIF.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'FPLTR'.
  IF sy-subrc = 0.
    IF lwa_dummy-no_out = 'X'.
    ELSE.
      lwa_dummy-no_out = 'X'.
    ENDIF.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'ZUONR'.
  IF sy-subrc = 0.
    IF lwa_dummy-no_out = 'X'.
    ELSE.
      lwa_dummy-no_out = 'X'.
    ENDIF.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'WRBTR'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-019. "'Settled Amount'.
    lwa_dummy-scrtext_m = text-019. "'Settled Amount'.
    lwa_dummy-scrtext_l = text-019. "'Settled Amount'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'VALDTY'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-021. "'DaystoExpire'.
    lwa_dummy-scrtext_m = text-021. "'DaystoExpire'.
    lwa_dummy-scrtext_l = text-021. "'DaystoExpire'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'BELNR'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-022. "'Acc.Document No'.
    lwa_dummy-scrtext_m = text-022. "'Acc.Document No'.
    lwa_dummy-scrtext_l = text-023. "'Accounting Document No.'.
    lwa_dummy-hotspot    = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'FDATU'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-024. "Settlement First Run Date
    lwa_dummy-scrtext_m = text-024. "Settlement First Run Date
    lwa_dummy-scrtext_l = text-024. "Settlement First Run Date
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'LDATU'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-025. "Settlement Last Run Date
    lwa_dummy-scrtext_m = text-025. "Settlement Last Run Date
    lwa_dummy-scrtext_l = text-025. "Settlement Last Run Date
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'SGTXT'.
  IF sy-subrc = 0.
    lwa_dummy-scrtext_s = text-028. "Item Text
    lwa_dummy-scrtext_m = text-028. "Item Text
    lwa_dummy-scrtext_l = text-028. "Item Text
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
* Set hotspot
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'XBLNR2'.
  IF sy-subrc = 0.
    lwa_dummy-hotspot    = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
* Set hotspot
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'KUNNR'.
  IF sy-subrc = 0.
    lwa_dummy-hotspot    = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
* Set position for fields, freeze columns, set color for the frozen columns
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'VBELN'.
  IF sy-subrc = 0.
    lwa_dummy-col_pos    = 1.
    lwa_dummy-style      = 2.
    lwa_dummy-fix_column = 'X'.
    lwa_dummy-hotspot    = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'CCBTC'.
  IF sy-subrc = 0.
    lwa_dummy-col_pos    = 2.
    lwa_dummy-style      = 2.
    lwa_dummy-fix_column = 'X'.
    lwa_dummy-hotspot    = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'FDATU'.
  IF sy-subrc = 0.
    lwa_dummy-col_pos    = 3.
    lwa_dummy-style      = 2.
    lwa_dummy-fix_column = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'CCINS'.
  IF sy-subrc = 0.
    lwa_dummy-col_pos    = 4.
    lwa_dummy-style      = 2.
    lwa_dummy-fix_column = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.
  READ TABLE it_dummy INTO lwa_dummy WITH KEY fieldname = 'CCNUM'.
  IF sy-subrc = 0.
    lwa_dummy-col_pos = 5.
    lwa_dummy-style = 2.
    lwa_dummy-fix_column = 'X'.
    MODIFY it_dummy FROM lwa_dummy INDEX sy-tabix.
  ENDIF.

  " Set the modified fieldcatalog and call refresh
  " ----------------------------------------------
  CALL METHOD g_grid1->set_frontend_fieldcatalog
    EXPORTING
      it_fieldcatalog = it_dummy[].

  CALL METHOD g_grid1->refresh_table_display.

  CREATE OBJECT event_receiver.
  SET HANDLER event_receiver->handle_user_command    FOR g_grid1.
  SET HANDLER event_receiver->handle_toolbar         FOR g_grid1.
  SET HANDLER event_receiver->handle_hotspot_click_1 FOR g_grid1.

  CALL METHOD g_grid1->set_toolbar_interactive.

  CALL METHOD cl_gui_control=>set_focus
    EXPORTING
      control = g_grid1.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  SHOW_DOCUMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM show_document  TABLES   p_et_index_rows TYPE lvc_t_row.

  DATA: ls_selected_line TYPE lvc_s_row,
        lv_vbco6         TYPE vbco6.

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF wa_final-vbeln IS NOT INITIAL
    AND wa_final-vbeln <> lv_vbco6-vbeln.

      MOVE-CORRESPONDING wa_final TO lv_vbco6.
      lv_vbco6-mandt = sy-mandt.

      CALL DIALOG 'RV_DOCUMENT_FLOW'
        EXPORTING
          vbco6      FROM lv_vbco6
          makt-maktx FROM space
          kna1-kunnr FROM wa_final-kunnr
          kna1-name1 FROM wa_final-ccname
          makt-matnr FROM space.
      CLEAR: ls_selected_line.
    ELSE.
      MESSAGE i208(00) WITH text-001.
    ENDIF.
  ENDLOOP.
  CLEAR: lv_vbco6, wa_final.
ENDFORM.                    " SHOW_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  FORW_AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM forw_auth  TABLES   p_et_index_rows TYPE lvc_t_row.

  DATA: lt_sel  TYPE STANDARD TABLE OF rsparams,
        lwa_sel TYPE rsparams.

  REFRESH lt_final[].

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF wa_final-vbeln IS NOT INITIAL.
      APPEND wa_final TO lt_final1.
      CLEAR: ls_selected_line, wa_final.
    ENDIF.
  ENDLOOP.

  SELECT vbeln gbstk cmgst FROM vbuk INTO TABLE lt_vbuk
  FOR ALL ENTRIES IN lt_final1
  WHERE vbeln = lt_final1-vbeln
  AND gbstk <> 'C'
  AND cmgst = 'B'
  AND vbobj = 'A'. "Order
  IF sy-subrc = 0.

    SORT: lt_final1 BY vbeln,
          lt_vbuk  BY vbeln.

    DELETE ADJACENT DUPLICATES FROM lt_final1 COMPARING vbeln.
    DESCRIBE TABLE lt_final LINES lv_count.

    lwa_sel-selname = 'VBELN'.
    lwa_sel-sign    = 'I'.
    lwa_sel-option  = 'EQ'.

    LOOP AT lt_final1 INTO wa_final.
      READ TABLE lt_vbuk INTO lwa_vbuk WITH KEY vbeln = wa_final-vbeln
      BINARY SEARCH.
      IF sy-subrc = 0.
        lwa_sel-low = wa_final-vbeln.
        APPEND lwa_sel TO lt_sel.
      ELSE.
        MESSAGE i368(00) WITH wa_final-vbeln text-016.
      ENDIF.
    ENDLOOP.
    IF lt_sel[] IS INITIAL.
      MESSAGE i368(00) WITH wa_final-vbeln text-016.
    ELSE.
      SUBMIT rv21a001 WITH SELECTION-TABLE lt_sel AND RETURN.
      REFRESH lt_sel[].
    ENDIF.
    CLEAR wa_final.
  ELSE.
    MESSAGE i208(00) WITH text-015. "'Order not eligible to be forwarded for authorization.'." at the moment'.
  ENDIF.
ENDFORM.                    " FORW_AUTH
*&---------------------------------------------------------------------*
*&      Form  LIST_OF_DISP_VAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM list_of_disp_var  CHANGING pv_varid TYPE disvariant-variant.

  DATA : lv_variant_in  TYPE disvariant,
         lv_variant_out TYPE disvariant,
         lv_save        TYPE c,
         lv_exit(1)     TYPE c.
  CONSTANTS: c_a        TYPE c VALUE 'A'.

  lv_save = c_a.
  MOVE sy-repid TO lv_variant_in-report.
* F4 help on ALV Layout variant
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant    = lv_variant_in
      i_save        = lv_save
    IMPORTING
      e_exit        = lv_exit
      es_variant    = lv_variant_out
    EXCEPTIONS
      not_found     = 1
      program_error = 2
      OTHERS        = 3.
  IF sy-subrc = 2.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF lv_exit = space.
      pv_varid = lv_variant_out-variant.
    ENDIF.
  ENDIF.

ENDFORM.                    " LIST_OF_DISP_VAR
FORM collect_data.

  LOOP AT it_so INTO wa_so.
* All FPLTC lines should be added to the final table
    LOOP AT it_crcard INTO wa_crcard WHERE fplnr = wa_so-rplnr.
      READ TABLE lt_tvcin INTO lwa_tvcin WITH KEY ccins = wa_crcard-ccins
      BINARY SEARCH.
      IF sy-subrc = 0 AND wa_crcard-audat IS NOT INITIAL.
        wa_final-expdat = wa_crcard-audat + lwa_tvcin-tgval.
        wa_final-valdty = wa_final-expdat - sy-datum.
        CLEAR lwa_tvcin.
      ENDIF.
      IF wa_crcard-audat IS NOT INITIAL.
        MOVE-CORRESPONDING wa_crcard TO wa_final.
        MOVE-CORRESPONDING wa_so     TO wa_final.
* Reporting Return Order amount as negative
        IF wa_final-aunum = 'RO'.
          wa_final-autwr = -1 * wa_final-autwr.
          wa_final-autwv = -1 * wa_final-autwv.
        ENDIF.
        READ TABLE lt_vbuk INTO lwa_vbuk WITH KEY vbeln = wa_so-vbeln.
        IF sy-subrc = 0.
          wa_final-cmgst = lwa_vbuk-cmgst.
          wa_final-gbstk = lwa_vbuk-gbstk.
          CLEAR lwa_vbuk.
        ENDIF.
        LOOP AT lt_vbfa INTO lwa_vbfa WHERE vbelv = wa_so-vbeln
                                      AND  ( vbtyp_n = 'M' OR
                                             vbtyp_n = 'N' OR
                                             vbtyp_n = 'O' OR
                                             vbtyp_n = 'P' OR
                                             vbtyp_n = 'S' ).
          "Invoice types that are allowed
* update bill doc only if the billing is not cancelled
          READ TABLE lt_vbrk INTO lwa_vbrk WITH KEY vbeln = lwa_vbfa-vbeln.
          IF sy-subrc = 0.
            "Blank-Error in Accounting Interface
            "A-Billing document blocked for forwarding to FI
            "B-Posting document not created (account determ.error)
            "C-Posting document has been created
            "D-Billing document is not relevant for accounting
            "E-Billing Document Canceled
            "F-Posting document not created (pricing error)
            "G-Posting document not created (export data missing)
            "H-Posted via invoice list
            "I-Posted via invoice list (account determination error)
            "K-Accounting document not created (no authorization)
            "L-Billing doc. blocked for transfer to manager (only IS-OIL)
            CASE lwa_vbrk-rfbsk.
              WHEN 'C' OR 'K'.
                wa_final-xblnr2 = lwa_vbrk-vbeln.
            ENDCASE.
            APPEND wa_final TO it_final.
            CLEAR: lwa_vbrk.
          ENDIF.
          CLEAR: lwa_vbfa.
        ENDLOOP.
* Add the records even if there are no invoices
* only if settlement data is not selected
        IF sy-subrc <> 0.
          IF fdatu IS INITIAL AND ccbtc IS INITIAL.
            APPEND wa_final TO it_final.
            CLEAR: wa_crcard, wa_final.
          ENDIF.
        ENDIF.
      ELSE.
        CLEAR: wa_crcard,wa_final.
        CONTINUE.
      ENDIF.
    ENDLOOP. "Multiple Credit cards loop
    CLEAR: wa_final,wa_crcard,wa_so.
  ENDLOOP.

  SORT it_final[] BY xblnr2 ccins ccnum aunum.
  SORT lt_bkpf[]  BY belnr ccins ccnum aunum.

  LOOP AT it_final INTO wa_final.

    LOOP AT lt_vbpa INTO lwa_vbpa WHERE vbeln = wa_final-vbeln.
      CASE lwa_vbpa-parvw.
        WHEN 'RG'.
          wa_final-payer = lwa_vbpa-kunnr.
        WHEN 'WE'.
          wa_final-shipto = lwa_vbpa-kunnr.
        WHEN 'AG'.
          wa_final-soldto = lwa_vbpa-kunnr.
        WHEN 'RE'.
          wa_final-billto = lwa_vbpa-kunnr.
      ENDCASE.
      CLEAR lwa_vbpa.
    ENDLOOP.

    READ TABLE lt_bkpf INTO lwa_bkpf
    WITH KEY belnr = wa_final-xblnr2
             ccins = wa_final-ccins
             ccnum = wa_final-ccnum
             aunum = wa_final-aunum
    BINARY SEARCH.
    IF sy-subrc = 0.
      wa_final-bukrs = lwa_bkpf-bukrs.
      wa_final-belnr = lwa_bkpf-belnr.
      wa_final-gjahr = lwa_bkpf-gjahr.
      wa_final-ccbtc = lwa_bkpf-ccbtc.
      wa_final-rfzei = lwa_bkpf-rfzei.
      wa_final-xblnr = lwa_bkpf-xblnr.
* Get settled amount from BSAS only if there is a settlement number
      READ TABLE lt_tcclg INTO lwa_tcclg WITH KEY ccbtc = wa_final-ccbtc.
      IF sy-subrc = 0.
        wa_final-fdatu    = lwa_tcclg-fdatu.
        wa_final-ldatu    = lwa_tcclg-ldatu.
        wa_final-vblnr    = lwa_tcclg-vblnr.
        wa_final-gjahr_st = lwa_tcclg-gjahr.
        wa_final-xsucc    = lwa_tcclg-xsucc.
        wa_final-xfail    = lwa_tcclg-xfail.
      ENDIF.
* Get settlement amount from BSAS
      PERFORM get_bsas_data USING    wa_final
                                     lt_bsas
                            CHANGING lt_final.
    ENDIF.
*If Acc doc not generated that record still has to be added
    APPEND wa_final TO lt_final.
    CLEAR: lwa_bkpf, wa_final,lwa_bsas.
  ENDLOOP.
* Clear up used internal tables
  REFRESH: it_final[],lt_bkpf[],lt_bsas[],lt_tcclg[],
           lt_vbfa[],lt_bsis[],lt_vbpa[],
           lt_vbuk[],lt_vbrk[],lt_vbfa[].
  it_final[] = lt_final[].
  REFRESH: lt_final[].

  DELETE ADJACENT DUPLICATES FROM it_final COMPARING ALL FIELDS.
*BOC <ERP-6370> <ED2K914084>
*Required only Un-sucessfull payment data
  CLEAR react[].
  APPEND LINES OF gr_react TO react.
*EOC <ERP-6370> <ED2K914084>
* Filter Response 'A' when asked for B and C of the same order
  IF react[] IS NOT INITIAL.
    PERFORM react_filter.
  ENDIF.
  PERFORM apply_filter.
  SORT it_final BY vbeln  DESCENDING
                   expdat DESCENDING.
ENDFORM.                    " COLLECT_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data.
* If Settlement date is selected
  IF fdatu IS NOT INITIAL
  OR ccbtc IS NOT INITIAL.
    SELECT * FROM tcclg INTO TABLE lt_tcclg
    WHERE ccbtc IN ccbtc
    AND ( fdatu IN fdatu
    OR    ldatu IN fdatu ).
    IF lt_tcclg[] IS INITIAL.
* CCBTC and FDATU combination did not work
      IF fdatu IS NOT INITIAL.
        SELECT * FROM tcclg INTO TABLE lt_tcclg
        WHERE fdatu IN fdatu
        OR    ldatu IN fdatu.
        IF lt_tcclg[] IS INITIAL.
* FDATU is filled
          PERFORM collect_ardata.
          RETURN.
        ENDIF.
      ELSEIF ccbtc IS NOT INITIAL.
        SELECT * FROM tcclg INTO TABLE lt_tcclg
        WHERE ccbtc IN ccbtc.
        IF lt_tcclg[] IS INITIAL.
          READ TABLE ccbtc WITH KEY low = space.
          IF sy-subrc = 0.
* CCBTC is populated with "not empty" or "empty", No CCBTC records
* and FDATU is not filled, fetch all orders that are unsettled
* and open AR transactions with credit card
            PERFORM order_data.
            PERFORM collect_ardata.
            SORT it_final BY fdatu ccbtc DESCENDING.
            RETURN.
          ELSE.
* CCBTC is populated with "not empty" or "empty", No CCBTC records
* and FDATU is not filled
            MESSAGE i208(00) WITH text-013. "'No data found'.
          ENDIF.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
    PERFORM get_settlementdata.
    PERFORM collect_settlementdata.
* Collect AR data based on settlement date
    IF ccbtc[] IS INITIAL.
      PERFORM collect_ardata.
    ELSEIF it_final[] IS INITIAL.
      MESSAGE i208(00) WITH text-013. "'No data found'.
    ENDIF.

    SORT it_final BY fdatu ccbtc DESCENDING.
    RETURN.
  ENDIF.
* At this point, no settlement data selected so full fetch from orders
  PERFORM order_data.
  PERFORM collect_ardata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLLECT_ARDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM collect_ardata.
  IF  fdatu  IS INITIAL
  AND ccbtc  IS INITIAL
  AND dmbtr  IS INITIAL
  AND ccins  IS INITIAL
  AND ccnum  IS INITIAL
  AND ccname IS INITIAL
  AND audat  IS INITIAL
  AND autim  IS INITIAL
  AND autra  IS INITIAL
  AND autwr  IS INITIAL
  AND ccwae  IS INITIAL
  AND merch  IS INITIAL
  AND ccaua  IS INITIAL
  AND ccall  IS INITIAL
  AND react  IS INITIAL
  AND aunum  IS INITIAL
  AND rtext  IS INITIAL
  AND it_final IS INITIAL.
    MESSAGE i208(00) WITH text-031. "Please enter atleast one selection criteria.
    RETURN.
  ENDIF.
* if an order number is selected, open AR transactions need not be collected
  IF vbeln IS NOT INITIAL.
    RETURN.
  ENDIF.
* Add records from BSEGC table for open invoice payment items with credit card
  SELECT * FROM bkpf AS a INNER JOIN  bsegc AS b
  ON  a~bukrs = b~bukrs
  AND a~belnr = b~belnr
  AND a~gjahr = b~gjahr
  INTO CORRESPONDING FIELDS OF TABLE lt_final
  WHERE a~bukrs  IN bukrs
  AND   a~belnr  IN belnr
  AND   a~belnr  IN xblnr2
  AND   a~gjahr  IN gjahr
  AND   a~blart  = 'DZ'
  AND   b~ccins  IN ccins
  AND   b~ccnum  IN ccnum
  AND   b~ccname IN ccname
  AND   b~autwr  IN autwr
  AND   b~audat  IN audat
  AND   b~audat  IN fdatu
  AND   b~autim  IN autim
  AND   b~ccwae  IN ccwae
  AND   b~merch  IN merch
*BOC <ERP-6370> <ED2K914084>
*Required only Un-sucessfull payment data
  AND   b~react  IN gr_react  "react
*EOC <ERP-6370> <ED2K914084>
  AND   b~aunum  IN aunum
  AND   b~autra  IN autra
  AND   b~rtext  IN rtext
  AND   b~ccbtc = space.
  IF sy-subrc = 0.
    SORT it_final BY bukrs belnr gjahr.
    SORT lt_final BY bukrs belnr gjahr.
  ENDIF.
  IF lt_final[] IS NOT INITIAL.
    SELECT * FROM bsad INTO TABLE lt_bsad
    FOR ALL ENTRIES IN lt_final
    WHERE bukrs = lt_final-bukrs
    AND   belnr = lt_final-belnr
    AND   gjahr = lt_final-gjahr.
    IF sy-subrc = 0.
      SORT lt_bsad BY bukrs belnr gjahr.
    ENDIF.
    SELECT * FROM bsis INTO TABLE lt_bsis
    FOR ALL ENTRIES IN lt_final
    WHERE bukrs = lt_final-bukrs
    AND   belnr = lt_final-belnr
    AND   gjahr = lt_final-gjahr
    AND   bschl = '40'
    AND   dmbtr <> 0. "Ignore currency conv transactions
    IF sy-subrc = 0.
      SORT lt_bsis[] BY bukrs belnr gjahr.
    ENDIF.
  ENDIF.
* Collect BSEGC to be later used for partial refunds
  SELECT * FROM bsegc INTO TABLE lt_bsegc
  WHERE bukrs IN bukrs
  AND   belnr IN belnr
  AND   gjahr IN gjahr
  AND   ccins IN ccins
  AND   ccnum IN ccnum
  AND   ccname IN ccname
  AND   autwr IN autwr
  AND   ccwae IN ccwae
  AND   aunum IN aunum
  AND   autra IN autra
  AND   audat IN fdatu
  AND   audat IN audat
  AND   autim IN autim
  AND   merch IN merch
  AND   ccbtc = space
  AND   rtext IN rtext
*BOC <ERP-6370> <ED2K914084>
*Required only Un-sucessfull payment data
  AND   react IN gr_react. "react.
*EOC <ERP-6370> <ED2K914084>
  IF sy-subrc = 0.
    SORT lt_bsegc[] BY bukrs belnr gjahr.
  ENDIF.

  CLEAR lwa_final.
  LOOP AT lt_final INTO lwa_final.
    READ TABLE it_final INTO lwa_final1
    WITH KEY bukrs = lwa_final-bukrs
             belnr = lwa_final-belnr
             gjahr = lwa_final-gjahr
*                    autwr = lwa_final-autwr
    BINARY SEARCH.
    IF sy-subrc <> 0.
      lwa_final-ernam = lwa_final-usnam. " Collect Open AR user
      READ TABLE lt_bsis INTO lwa_bsis
      WITH KEY bukrs = lwa_final-bukrs
               belnr = lwa_final-belnr
               gjahr = lwa_final-gjahr
      BINARY SEARCH.
      IF sy-subrc = 0.
        lwa_final-zuonr = lwa_bsis-zuonr.
* Open AR refunds has to be shown as negative too
        IF lwa_final-autwr < 0.
          lwa_final-dmbtr = lwa_bsis-dmbtr * -1.
          lwa_final-wrbtr = lwa_bsis-wrbtr * -1.
        ELSE.
          lwa_final-dmbtr = lwa_bsis-dmbtr.
          lwa_final-wrbtr = lwa_bsis-wrbtr.
        ENDIF.
        lwa_final-fdatu = lwa_final-audat.
        lwa_final-payer = lwa_final-kunnr.
        READ TABLE lt_bsad INTO lwa_bsad
        WITH KEY bukrs = lwa_final-bukrs
                 belnr = lwa_final-belnr
                 gjahr = lwa_final-gjahr
                 buzei = lwa_final-rfzei
        BINARY SEARCH.
        IF sy-subrc = 0 AND lwa_bsad-sgtxt IS NOT INITIAL.
          lwa_final-sgtxt = lwa_bsad-sgtxt.
        ENDIF.
        APPEND lwa_final TO lt_final1.
      ELSE.
        READ TABLE lt_bsad INTO lwa_bsad
        WITH KEY bukrs = lwa_final-bukrs
                 belnr = lwa_final-belnr
                 gjahr = lwa_final-gjahr
                 buzei = lwa_final-rfzei
        BINARY SEARCH.
        IF sy-subrc = 0.
          lwa_final-zuonr = lwa_bsad-zuonr.
          lwa_final-payer = lwa_bsad-kunnr.
* Roll up BSAD to single line so that the refund amounts
* when refunded together will show up properly
          LOOP AT lt_bsad INTO lwa_bsad WHERE bukrs = lwa_final-bukrs
                                        AND belnr = lwa_final-belnr
                                        AND gjahr = lwa_final-gjahr
                                        AND shkzg = 'S'.
            lwa_final-dmbtr = lwa_final-dmbtr + lwa_bsad-dmbtr.
            lwa_final-wrbtr = lwa_final-wrbtr + lwa_bsad-wrbtr.
            IF lwa_bsad-sgtxt IS NOT INITIAL.
              lwa_final-sgtxt = lwa_bsad-sgtxt.
            ENDIF.
            CLEAR lwa_bsad.
          ENDLOOP.
* Open AR refunds has to be shown as negative too
          IF lwa_final-autwr < 0.
            lwa_final-dmbtr = -1 * lwa_final-dmbtr.
            lwa_final-wrbtr = -1 * lwa_final-wrbtr.
          ENDIF.
          lwa_final-fdatu = lwa_final-audat.
          APPEND lwa_final TO lt_final1.
        ELSE.
* Partial refunds are added here from BSEGC
          lwa_final-ernam = lwa_final-usnam. " Collect Open AR user
          READ TABLE lt_bsegc INTO lwa_bsegc
          WITH KEY bukrs = lwa_final-bukrs
                   belnr = lwa_final-belnr
                   gjahr = lwa_final-gjahr
          BINARY SEARCH.
          IF sy-subrc = 0.
            lwa_final-dmbtr = lwa_bsegc-autwr.
            lwa_final-wrbtr = lwa_bsegc-autwr.
            lwa_final-fdatu = lwa_final-audat.
            lwa_final-payer = lwa_final-kunnr.
            READ TABLE lt_bsad INTO lwa_bsad
            WITH KEY bukrs = lwa_final-bukrs
                     belnr = lwa_final-belnr
                     gjahr = lwa_final-gjahr
                     buzei = lwa_final-rfzei
            BINARY SEARCH.
            IF sy-subrc = 0 AND lwa_bsad-sgtxt IS NOT INITIAL.
              lwa_final-sgtxt = lwa_bsad-sgtxt.
            ENDIF.
            APPEND lwa_final TO lt_final1.
            CLEAR: lwa_bsegc.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: lwa_final,wa_final,lwa_bsad,lwa_bsis.
  ENDLOOP.
  IF lt_final1 IS NOT INITIAL.
    APPEND LINES OF lt_final1 TO it_final.
    REFRESH: lt_bkpf[],lt_bsad[],lt_final1,lt_final.
    PERFORM apply_filter.
  ENDIF.
  IF it_final[] IS NOT INITIAL.
  ELSE.
    MESSAGE i208(00) WITH text-013. "'No data found'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RERUN_SETTLEMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM rerun_settlement TABLES   p_et_index_rows TYPE lvc_t_row.

  DATA: lt_sel  TYPE STANDARD TABLE OF rsparams,
        lwa_sel TYPE rsparams.

  REFRESH lt_final[].

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF wa_final-ccbtc IS NOT INITIAL.
      IF wa_final-xsucc <> 'X'.
        APPEND wa_final TO lt_final1.
        CLEAR: ls_selected_line, wa_final.
      ELSE.
        MESSAGE i368(00) WITH text-029 wa_final-ccbtc.
      ENDIF.
    ELSE.
      MESSAGE i208(00) WITH text-045. "This item is not settled.
    ENDIF.
  ENDLOOP.

  SORT: lt_final1 BY ccbtc.

  DELETE ADJACENT DUPLICATES FROM lt_final1 COMPARING ccbtc.

  lwa_sel-selname = 'PR_CCBTC'.
  lwa_sel-sign    = 'I'.
  lwa_sel-option  = 'EQ'.

  LOOP AT lt_final1 INTO wa_final.
    lwa_sel-low = wa_final-ccbtc.
    APPEND lwa_sel TO lt_sel.
    SUBMIT rfccrstt WITH SELECTION-TABLE lt_sel AND RETURN.
    CLEAR: lwa_sel-low, wa_final.
    REFRESH lt_sel[].
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM order_data .
  IF vbeln[] IS NOT INITIAL
  OR kunnr[] IS NOT INITIAL
  OR auart[] IS NOT INITIAL.
*Begin of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
    SELECT a~fplnr
           a~fpltr
           a~ccins
           a~ccnum
           a~audat
           a~autim
           a~ccname
           a~autwr
           a~ccwae
           a~aunum
           a~autra
           a~merch
           a~cctyp
           a~ccaua
           a~ccall
           c~aust3 AS react
           a~autwv
           a~rtext
      FROM fpltc AS a
      INNER JOIN vbak AS b ON a~fplnr = b~rplnr
      INNER JOIN fpla AS c ON a~fplnr = c~fplnr
*End of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
    INTO TABLE it_crcard
    WHERE a~ccins IN ccins
    AND   a~ccnum IN ccnum
    AND   a~ccname IN ccname
    AND   a~audat IN audat
    AND   a~audat <> '00000000'
    AND   a~autim IN autim
    AND   a~ccwae IN ccwae
    AND   a~merch IN merch
    AND   a~ccaua IN ccaua
    AND   a~ccall IN ccall
*  BOC <ERP-6370> <ED2K913966>/<ED2K914084>
*  Required only Un-sucessfull payment data
*      AND   a~react IN gr_react    "react "Filter later considering B and C
*  EOC <ERP-6370> <ED2K913966>/<ED2K914084>
*  Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
    AND   a~ccpre <> abap_true  "Ignore Preauthorized card
*  End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
    AND   a~aunum IN aunum
    AND   a~autra IN autra
    AND   a~rtext IN rtext
    AND   b~vbeln IN vbeln[]
    AND   b~kunnr IN kunnr[]
    AND   b~auart IN auart[]
    AND   b~bukrs_vf IN bukrs[]
    AND   c~aust3 IN gr_react.
*   ENDIF.
*BOC <ERP-6370> <ED2K913836>
*    AND   b~erdat IN gr_erdat[].
*EOC <ERP-6370> <ED2K913836>
  ELSEIF ccins  IS NOT INITIAL
      OR ccnum  IS NOT INITIAL
      OR ccname IS NOT INITIAL
      OR audat  IS NOT INITIAL
      OR autim  IS NOT INITIAL
      OR autra  IS NOT INITIAL
      OR autwr  IS NOT INITIAL
      OR ccwae  IS NOT INITIAL
      OR merch  IS NOT INITIAL
      OR ccaua  IS NOT INITIAL
      OR ccall  IS NOT INITIAL
      OR react  IS NOT INITIAL
      OR aunum  IS NOT INITIAL
      OR rtext  IS NOT INITIAL.

    IF xblnr2 IS NOT INITIAL
    OR belnr IS NOT INITIAL.
* Check if accounting document exist in BKPF with credit
* card information and not settled
      SELECT * FROM bkpf AS a INNER JOIN bsegc AS b
      ON  a~bukrs = b~bukrs
      AND a~belnr = b~belnr
      AND a~gjahr = b~gjahr
      INTO CORRESPONDING FIELDS OF TABLE lt_bkpf
      WHERE a~bukrs IN bukrs
      AND   a~belnr IN belnr
      AND   a~belnr IN xblnr2  "Wiley - as BillDoc No and AccDoc same
      AND   a~gjahr IN gjahr
      AND   a~ccins IS NOT NULL
      AND   a~ccnum IS NOT NULL
      AND   a~xblnr IN xblnr[]
      AND   b~autwr IN autwr[]
      AND   b~ccbtc IN ccbtc[]
      AND   b~audat IN audat[]
      AND   b~autra IN autra[]
      AND   b~aunum IN aunum[]
      AND   b~rtext IN rtext[].
      IF sy-subrc = 0.
        SELECT * FROM vbfa INTO TABLE lt_vbfa
        FOR ALL ENTRIES IN lt_bkpf
        WHERE vbeln   = lt_bkpf-belnr.
        IF sy-subrc = 0.
          SELECT * FROM fpltc AS a INNER JOIN vbak AS b
          ON a~fplnr = b~rplnr
          INTO CORRESPONDING FIELDS OF TABLE it_crcard
          FOR ALL ENTRIES IN lt_vbfa
          WHERE b~vbeln = lt_vbfa-vbelv
*BOC <ERP-6370> <ED2K913836>
*          AND   b~erdat IN gr_erdat
*EOC <ERP-6370> <ED2K913836>
          AND   a~audat <> '00000000'.
        ENDIF.
      ENDIF.
    ELSE. "If No Ref.Doc or Bill Doc is selected
      SELECT * FROM fpltc
      INTO CORRESPONDING FIELDS OF TABLE it_crcard
      WHERE ccins IN ccins
      AND   ccnum IN ccnum
      AND   ccname IN ccname
      AND   audat IN audat
      AND   audat <> '00000000'
      AND   autim IN autim
      AND   autwr IN autwr[]
      AND   ccwae IN ccwae
      AND   merch IN merch
      AND   ccaua IN ccaua
      AND   ccall IN ccall
*BOC <ERP-6370> <ED2K913966>/<ED2K914084>
*Required only Un-sucessfull payment data
      AND   react IN gr_react  "react "Filter later considering B and C
*BOC <ERP-6370> <ED2K913966>/<ED2K914084>
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
      AND   ccpre <> abap_true  "Ignore Preauthorized card
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
      AND   aunum IN aunum
      AND   autra IN autra
      AND   rtext IN rtext.
    ENDIF.
  ELSEIF xblnr2 IS NOT INITIAL
      OR belnr IS NOT INITIAL.
* Check if accounting document exist in BKPF with credit
* card information and not settled
    SELECT * FROM bkpf AS a INNER JOIN bsegc AS b
    ON  a~bukrs = b~bukrs
    AND a~belnr = b~belnr
    AND a~gjahr = b~gjahr
    INTO CORRESPONDING FIELDS OF TABLE lt_bkpf
    WHERE a~bukrs IN bukrs
    AND   a~belnr IN belnr
    AND   a~belnr IN xblnr2  "Wiley - as BillDoc No and AccDoc same
    AND   a~gjahr IN gjahr
    AND   a~ccins IS NOT NULL
    AND   a~ccnum IS NOT NULL
    AND   a~xblnr IN xblnr[]
    AND   b~autwr IN autwr[]
    AND   b~ccbtc IN ccbtc[]
    AND   b~audat IN audat[].
    IF sy-subrc = 0.
      SELECT * FROM vbfa INTO TABLE lt_vbfa
      FOR ALL ENTRIES IN lt_bkpf
      WHERE vbeln = lt_bkpf-belnr.
      IF sy-subrc = 0.
        SELECT * FROM fpltc AS a INNER JOIN vbak AS b
        ON a~fplnr = b~rplnr
        INTO CORRESPONDING FIELDS OF TABLE it_crcard
        FOR ALL ENTRIES IN lt_vbfa
        WHERE b~vbeln = lt_vbfa-vbelv
*BOC <ERP-6370> <ED2K913836>
*        AND   b~erdat IN gr_erdat
*EOC <ERP-6370> <ED2K913836>
        AND   a~audat <> '00000000'.
      ENDIF.
    ENDIF.
  ENDIF.

  IF it_crcard[] IS NOT INITIAL.

    SORT it_crcard BY fplnr DESCENDING
                      fpltr DESCENDING.

    SELECT a~vbeln a~erdat a~ernam a~auart a~vkorg a~vtweg a~spart
           a~rplnr a~kunnr
           a~netwr a~bukrs_vf
           b~inco1 b~inco2
    INTO TABLE it_so
    FROM ( vbak AS a INNER JOIN vbkd AS b
    ON a~vbeln = b~vbeln )
    FOR ALL ENTRIES IN it_crcard
    WHERE a~rplnr = it_crcard-fplnr
    AND  ( a~vbeln IN vbeln[]
    AND    a~kunnr IN kunnr[]
    AND    a~auart IN auart[]
    AND    a~vkorg IN vkorg[]
    AND    a~bukrs_vf IN bukrs[]
*BOC <ERP-6370> <ED2K913836>
*    AND    a~erdat IN gr_erdat
*EOC <ERP-6370> <ED2K913836>
    AND    b~inco1 IN inco1[] ).

    IF sy-subrc = 0.

* Get Order status information from VBUK table
      SELECT vbeln gbstk cmgst INTO TABLE lt_vbuk
      FROM vbuk
      FOR ALL ENTRIES IN it_so
      WHERE vbeln = it_so-vbeln.

* Sales order found, prepare credit card and SO internal table
      SORT it_crcard[] BY fplnr ASCENDING.
      SORT it_so[]     BY rplnr ASCENDING.

      IF lt_vbfa IS INITIAL.
        IF  it_so IS NOT INITIAL.
          SELECT * FROM vbfa INTO TABLE lt_vbfa
          FOR ALL ENTRIES IN it_so
          WHERE vbelv   = it_so-vbeln
          AND   ( vbtyp_n = 'M'   "Invoice
          OR      vbtyp_n = 'N'
          OR      vbtyp_n = 'O'
          OR      vbtyp_n = 'P'
          OR      vbtyp_n = 'S' ) "Credit memo cancellation
          AND     vbeln   IN xblnr2[].
          IF lt_vbfa IS NOT INITIAL.
            SELECT * FROM vbrk INTO TABLE lt_vbrk
            FOR ALL ENTRIES IN lt_vbfa
            WHERE vbeln = lt_vbfa-vbeln.
          ENDIF.
          SELECT * FROM vbpa INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN it_so
          WHERE vbeln = it_so-vbeln.
        ENDIF.
      ELSE.
        IF lt_vbrk IS NOT INITIAL.
          SELECT * FROM vbfa INTO TABLE lt_vbfa
          FOR ALL ENTRIES IN lt_vbrk
          WHERE vbelv     = lt_vbrk-vbeln
          AND   ( vbtyp_n = 'M' "Invoice
          OR      vbtyp_n = 'N' "Invoice cancellation
          OR      vbtyp_n = 'O' "Credit memo
          OR      vbtyp_n = 'P' "Debit memo
          OR      vbtyp_n = 'S' ) "Credit memo cancellation
          AND     vbeln   IN xblnr2[].
        ELSE.
          SELECT * FROM vbrk INTO TABLE lt_vbrk
          FOR ALL ENTRIES IN lt_vbfa
          WHERE vbeln = lt_vbfa-vbeln.
          SELECT * FROM vbpa INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN lt_vbfa
          WHERE vbeln = lt_vbfa-vbelv.
        ENDIF.
      ENDIF.

      IF lt_vbfa IS NOT INITIAL.
        SORT lt_vbfa[] BY vbelv vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbelv vbeln.
        SORT lt_vbfa BY vbelv vbtyp_n.
      ENDIF.
      IF  lt_bkpf IS INITIAL AND lt_vbfa IS NOT INITIAL.
        SELECT * FROM bkpf AS a INNER JOIN bsegc AS b
        ON  a~bukrs = b~bukrs
        AND a~belnr = b~belnr
        AND a~gjahr = b~gjahr
        INTO CORRESPONDING FIELDS OF TABLE lt_bkpf
        FOR ALL ENTRIES IN lt_vbfa
        WHERE a~bukrs IN bukrs
        AND   a~belnr IN belnr
        AND   a~gjahr IN gjahr
        AND   a~ccins IN ccins
        AND   a~ccnum IN ccnum
        AND   a~xblnr IN xblnr
        AND   a~belnr IN xblnr
        AND   a~belnr = lt_vbfa-vbeln
        AND   b~autwr IN autwr
        AND   b~ccbtc IN ccbtc
        AND   b~audat IN audat.
*        AND   b~kunnr IN payer[]. "OnAccount trns will be missed
      ENDIF.
      IF lt_bkpf IS NOT INITIAL.
        SELECT * FROM bsas INTO TABLE lt_bsas
        FOR ALL ENTRIES IN lt_bkpf
        WHERE bukrs = lt_bkpf-bukrs
        AND   belnr = lt_bkpf-belnr
        AND   gjahr = lt_bkpf-gjahr.
        IF sy-subrc = 0.
          SORT lt_bsas BY bukrs belnr gjahr rfzei.
        ENDIF.

        SELECT * FROM tcclg INTO TABLE lt_tcclg
        FOR ALL ENTRIES IN lt_bkpf
        WHERE ccbtc = lt_bkpf-ccbtc
        AND   ( fdatu IN fdatu
        OR      ldatu IN fdatu ).
        IF lt_tcclg IS NOT INITIAL.
          SORT lt_tcclg BY ccbtc.
        ENDIF.
      ENDIF.
* Even if no BKPF data exist we have to collect sales data
      PERFORM collect_data.
    ELSE.
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*To avoid job cancel, change as I
*      MESSAGE e208(00) WITH text-013. "'No data found'.
      MESSAGE i208(00) WITH text-013. "'No data found'.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SETTLEMENTDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_settlementdata .
  IF lt_tcclg[] IS NOT INITIAL.
    SORT lt_tcclg BY ccbtc.
    SELECT * FROM bsas INTO TABLE lt_bsas
    FOR ALL ENTRIES IN lt_tcclg
    WHERE bukrs IN bukrs[]
    AND   belnr IN belnr[]
    AND   gjahr IN gjahr[]
    AND   ccbtc = lt_tcclg-ccbtc.
    IF sy-subrc = 0.
      SORT lt_bsas BY bukrs belnr gjahr rfzei.
      SELECT * FROM bsegc INTO TABLE lt_bsegc
      FOR ALL ENTRIES IN lt_bsas
      WHERE bukrs  = lt_bsas-bukrs
      AND   belnr  = lt_bsas-belnr
      AND   gjahr  = lt_bsas-gjahr
      AND   ccins  IN ccins
      AND   ccnum  IN ccnum
      AND   ccname IN ccname
      AND   autwr  IN autwr
      AND   ccwae  IN ccwae
      AND   aunum  IN aunum
      AND   autra  IN autra
      AND   audat  IN audat
      AND   autim  IN autim
      AND   merch  IN merch
      AND   rtext  IN rtext
*BOC <ERP-6370> <ED2K914084>
*Required only Un-sucessfull payment data
      AND   react  IN gr_react.  "react.
*EOC <ERP-6370> <ED2K914084>
    ENDIF.
  ENDIF.
  IF lt_bsegc[] IS NOT INITIAL.
* Collect VBFA - orders
    SELECT * FROM vbfa INTO TABLE lt_vbfa
    FOR ALL ENTRIES IN lt_bsegc
    WHERE vbeln   = lt_bsegc-belnr
    AND   vbeln   IN xblnr2[]
    AND      (  vbtyp_v = 'C'    "Order
    OR          vbtyp_v = 'G'    "Contract
    OR          vbtyp_v = 'H' )  "Returns
    AND       ( vbtyp_n = 'M'    "Invoice
    OR          vbtyp_n = 'N'    "Invoice cancellation
    OR          vbtyp_n = 'O'    "Credit memo
    OR          vbtyp_n = 'P'    "Debit memo
    OR          vbtyp_n = 'S' ). "Credit memo cancellation
    DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbelv vbeln.
  ENDIF. "BKPF empty check
  IF lt_vbfa IS NOT INITIAL.
    SELECT * FROM fpltc AS a INNER JOIN vbak AS b
    ON a~fplnr = b~rplnr
    INTO CORRESPONDING FIELDS OF TABLE it_crcard
    FOR ALL ENTRIES IN lt_vbfa
    WHERE a~fpltr    >= '900001'   "<> '000001' "Ignore token record
    AND   a~ccins    IN ccins
    AND   a~ccnum    IN ccnum
    AND   a~ccname   IN ccname
    AND   a~autwr    IN autwr
    AND   a~autwr    <> 0
    AND   a~audat    IN audat
    AND   a~autim    IN autim
    AND   a~ccwae    IN ccwae
    AND   a~merch    IN merch
    AND   a~ccaua    IN ccaua
    AND   a~ccall    IN ccall
*BOC <ERP-6370> <ED2K914084>
*Required only Un-sucessfull payment data
    AND   a~react    IN gr_react  "react
*EOC <ERP-6370> <ED2K914084>
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
    AND   a~ccpre    <> abap_true  "Ignore Preauthorized card
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
    AND   a~aunum    IN aunum
    AND   a~autra    IN autra
    AND   a~rtext    IN rtext
    AND   b~vbeln    IN vbeln
    AND   b~vbeln    = lt_vbfa-vbelv
    AND   b~kunnr    IN kunnr
    AND   b~auart    IN auart
    AND   b~bukrs_vf IN bukrs.
*BOC <ERP-6370> <ED2K913836>
*    AND   b~erdat    IN gr_erdat.
*EOC <ERP-6370> <ED2K913836>
  ENDIF.
  IF it_crcard[] IS NOT INITIAL.
    SELECT a~vbeln a~erdat a~ernam a~auart a~vkorg a~vtweg a~spart
           a~rplnr a~kunnr
           a~netwr a~bukrs_vf
           b~inco1 b~inco2
    INTO TABLE it_so
    FROM ( vbak AS a INNER JOIN vbkd AS b
    ON a~vbeln = b~vbeln )
    FOR ALL ENTRIES IN it_crcard
    WHERE a~rplnr    = it_crcard-fplnr
    AND  ( a~vbeln   IN vbeln[]
    AND   a~kunnr    IN kunnr[]
    AND   a~auart    IN auart[]
    AND   a~vkorg    IN vkorg[]
    AND   a~bukrs_vf IN bukrs[]
*BOC <ERP-6370> <ED2K913836>
*    AND   a~erdat    IN gr_erdat
*EOC <ERP-6370> <ED2K913836>
    AND   b~inco1    IN inco1[] ).
  ENDIF.
  IF it_so[] IS NOT INITIAL.
    SELECT vbeln gbstk cmgst INTO TABLE lt_vbuk
    FROM vbuk
    FOR ALL ENTRIES IN it_so
    WHERE vbeln = it_so-vbeln.

    SORT it_crcard[] BY fplnr ASCENDING.
    SORT it_so[]     BY vbeln ASCENDING.
    SORT lt_vbuk     BY vbeln.

    SELECT * FROM vbpa INTO TABLE lt_vbpa
    FOR ALL ENTRIES IN it_so
    WHERE vbeln = it_so-vbeln
    AND ( parvw = 'AG'
    OR    parvw = 'WE'
    OR    parvw = 'RG'
    OR    parvw = 'RE' ).
    IF sy-subrc = 0.
      SORT lt_vbpa BY vbeln.
    ENDIF.
  ENDIF.
  IF lt_vbfa[] IS NOT INITIAL.
    SORT lt_vbfa[] BY vbeln.
    SELECT * FROM vbrk INTO TABLE lt_vbrk
    FOR ALL ENTRIES IN lt_vbfa
    WHERE vbeln = lt_vbfa-vbeln.
    SORT lt_vbrk[] BY vbeln.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLLECT_NOAUTH_ITEMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM collect_noauth_items .
* Collect range maximum
  SELECT SINGLE paramvalue FROM /cditech/spcfg INTO gv_paramvalue
  WHERE paramname = 'RANGE_MAX'.
  IF sy-subrc = 0.
    lv_maxcount = gv_paramvalue.
  ENDIF.

* Collect all credit card transactions
  SELECT * FROM vbak INTO TABLE lt_vbak
  WHERE rplnr <> space.
*BOC <ERP-6370> <ED2K913836>
*  AND   erdat IN gr_erdat.
*EOC <ERP-6370> <ED2K913836>
  IF lt_vbak[] IS NOT INITIAL.
* Collect all order numbers
    lwa_vbeln-sign   = 'I'.
    lwa_vbeln-option = 'EQ'.
    LOOP AT lt_vbak INTO lwa_vbak.
      lwa_vbeln-low = lwa_vbak-vbeln.
      APPEND lwa_vbeln TO lr_vbeln.
      CLEAR: lwa_vbak, lwa_vbeln-low.
    ENDLOOP.
    IF lr_vbeln IS NOT INITIAL.
      DESCRIBE TABLE lr_vbeln LINES lv_count.
      IF lv_count < lv_maxcount.
*Collect all RPLNRs of those orders
        SELECT * FROM vbak INTO TABLE lt_vbak
        WHERE vbeln IN lr_vbeln.
      ELSE.
        SELECT * FROM vbak INTO TABLE lt_vbak1
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln.
        IF sy-subrc = 0.
          REFRESH lt_vbak.
          lt_vbak[] = lt_vbak1[].
          REFRESH lt_vbak1[].
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  IF lt_vbak[] IS NOT INITIAL.
* Check for the ones that have responses
    SELECT * FROM fpltc INTO TABLE lt_fpltc
    FOR ALL ENTRIES IN lt_vbak
    WHERE fplnr = lt_vbak-rplnr.

    SORT: lt_vbak  BY rplnr,
          lt_fpltc BY fplnr ASCENDING
                      fpltr DESCENDING.
  ENDIF.
  REFRESH lr_vbeln[].
  IF lt_fpltc IS NOT INITIAL.
    lwa_vbeln-sign   = 'I'.
    lwa_vbeln-option = 'EQ'.
* Collect all the orders that have response which needs to be excluded
    LOOP AT lt_vbak INTO lwa_vbak.
      READ TABLE lt_fpltc INTO lwa_fpltc WITH KEY fplnr = lwa_vbak-rplnr
                                         BINARY SEARCH.
      IF sy-subrc = 0 AND lwa_fpltc-fpltr > 1.
        lwa_vbeln-low = lwa_vbak-vbeln.
        APPEND lwa_vbeln TO lr_vbeln.
        CLEAR: lwa_vbak, lwa_fpltc.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lr_vbeln IS NOT INITIAL.
    DELETE ADJACENT DUPLICATES FROM lr_vbeln COMPARING ALL FIELDS.
    SORT: lt_vbak  BY vbeln,
          lr_vbeln BY low.
    DELETE lt_vbak WHERE vbeln IN lr_vbeln.
  ENDIF.

  IF lt_vbak[] IS NOT INITIAL.
* Collect records from FPLTC
    SELECT * FROM fpltc
    INTO CORRESPONDING FIELDS OF TABLE it_crcard
    FOR ALL ENTRIES IN lt_vbak
    WHERE fplnr = lt_vbak-rplnr.
  ENDIF.
  IF it_crcard[] IS NOT INITIAL.

    SELECT a~vbeln a~erdat a~ernam a~auart a~vkorg a~vtweg a~spart
           a~rplnr a~kunnr
           a~netwr a~bukrs_vf
           b~inco1 b~inco2
    INTO TABLE it_so
    FROM ( vbak AS a INNER JOIN vbkd AS b
    ON a~vbeln = b~vbeln )
    FOR ALL ENTRIES IN it_crcard
    WHERE a~rplnr = it_crcard-fplnr
    AND  ( a~vbeln    IN vbeln[]
    AND    a~kunnr    IN kunnr[]
    AND    a~auart    IN auart[]
    AND    a~vkorg    IN vkorg[]
    AND    a~bukrs_vf IN bukrs[]
*BOC <ERP-6370> <ED2K913836>
*    AND    a~erdat    IN gr_erdat
*EOC <ERP-6370> <ED2K913836>
    AND    b~inco1    IN inco1[] ).
  ENDIF.
  IF it_so IS NOT INITIAL.
* Get Order status information from VBUK table
    SELECT vbeln gbstk cmgst INTO TABLE lt_vbuk
    FROM vbuk
    FOR ALL ENTRIES IN it_so
    WHERE vbeln = it_so-vbeln.

* Sales order found, prepare credit card and SO internal table
    SORT it_crcard[] BY fplnr ASCENDING.
    SORT it_so[]     BY rplnr ASCENDING.

    SELECT * FROM vbfa INTO TABLE lt_vbfa
    FOR ALL ENTRIES IN it_so
    WHERE vbelv   = it_so-vbeln
    AND   ( vbtyp_n = 'M'   "Invoice
    OR      vbtyp_n = 'N'
    OR      vbtyp_n = 'O'
    OR      vbtyp_n = 'P'
    OR      vbtyp_n = 'S' ) "Credit memo cancellation
    AND     vbeln   IN xblnr2[].
    IF lt_vbfa IS NOT INITIAL.
      SELECT * FROM vbrk INTO TABLE lt_vbrk
      FOR ALL ENTRIES IN lt_vbfa
      WHERE vbeln = lt_vbfa-vbeln.
    ENDIF.
    SELECT * FROM vbpa INTO TABLE lt_vbpa
    FOR ALL ENTRIES IN it_so
    WHERE vbeln = it_so-vbeln.
  ENDIF.

  IF lt_vbfa IS NOT INITIAL.
    SORT lt_vbfa[] BY vbelv vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbelv vbeln.
    SORT lt_vbfa BY vbelv vbtyp_n.
  ENDIF.

  LOOP AT it_crcard INTO wa_crcard.
    LOOP AT it_so INTO wa_so WHERE rplnr = wa_crcard-fplnr.
      MOVE-CORRESPONDING wa_crcard TO wa_final.
      MOVE-CORRESPONDING wa_so     TO wa_final.
      READ TABLE lt_vbuk INTO lwa_vbuk WITH KEY vbeln = wa_so-vbeln.
      IF sy-subrc = 0.
        wa_final-cmgst = lwa_vbuk-cmgst.
        wa_final-gbstk = lwa_vbuk-gbstk.
        CLEAR lwa_vbuk.
      ENDIF.
      LOOP AT lt_vbfa INTO lwa_vbfa WHERE vbelv = wa_so-vbeln
                                    AND  ( vbtyp_n = 'M' OR
                                           vbtyp_n = 'N' OR
                                           vbtyp_n = 'O' OR
                                           vbtyp_n = 'P' OR
                                           vbtyp_n = 'S' ).
        "Invoice types that are allowed
* add only if the billing is not cancelled
        READ TABLE lt_vbrk INTO lwa_vbrk WITH KEY vbeln = lwa_vbfa-vbeln.
        IF sy-subrc = 0.
          CASE lwa_vbrk-rfbsk.
            WHEN 'C' OR 'K'."Posting document has been created - E-Cancelled
              wa_final-xblnr2 = lwa_vbrk-vbeln.
              APPEND wa_final TO it_final.
              CLEAR: lwa_vbrk.
          ENDCASE.
        ENDIF.
        CLEAR: lwa_vbfa.
      ENDLOOP.
      IF sy-subrc <> 0.
        APPEND wa_final TO it_final.
        CLEAR: wa_crcard, wa_final.
      ENDIF.
    ENDLOOP. "Multiple Credit cards loop
    CLEAR: wa_final,wa_crcard,wa_so.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_TRAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM show_tran  TABLES   p_et_index_rows TYPE lvc_t_row.
  DATA: ls_selected_line TYPE lvc_s_row.

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF sy-subrc = 0 AND wa_final-ccbtc IS NOT INITIAL.
      CALL FUNCTION 'CCARD_SETTLEMENT_SHOW_TRANSACT'
        EXPORTING
          i_ccbtc               = wa_final-ccbtc
        EXCEPTIONS
          no_protocol_found     = 1
          no_transactions_found = 2
          control_error         = 3
          OTHERS                = 4.
* clear cache here
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR: wa_final,ls_selected_line.
    ELSE.
      IF wa_final-vbeln IS INITIAL.
        MESSAGE i208(00) WITH text-053. "Open AR transaction dont have settlement log.
      ELSE.
        MESSAGE i208(00) WITH text-045. "This item is not settled.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SHOW_TRAN
*&---------------------------------------------------------------------*
*&      Form  SHOW_ITEMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM show_items  TABLES   p_et_index_rows TYPE lvc_t_row.
  DATA: ls_selected_line TYPE lvc_s_row.

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF sy-subrc = 0 AND wa_final-ccbtc IS NOT INITIAL.
      CALL FUNCTION 'CCARD_SETTLEMENT_SHOW_ITEMS'
        EXPORTING
          i_ccbtc           = wa_final-ccbtc
          i_koart           = 'S'
        EXCEPTIONS
          index_not_active  = 1
          no_protocol_found = 2
          no_items_found    = 3
          OTHERS            = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR: wa_final,ls_selected_line.
    ELSE.
      IF wa_final-vbeln IS INITIAL.
        MESSAGE i208(00) WITH text-053. "Open AR transaction dont have settlement log.
      ELSE.
        MESSAGE i208(00) WITH text-045. "This item is not settled.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SHOW_ITEMS
*&---------------------------------------------------------------------*
*&      Form  SHOW_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM show_header  TABLES    p_et_index_rows TYPE lvc_t_row.
  DATA: ls_selected_line TYPE lvc_s_row.

  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF sy-subrc = 0 AND wa_final-ccbtc IS NOT INITIAL.
      CALL FUNCTION 'CCARD_SETTLEMENT_SHOW_HEADER'
        EXPORTING
          i_ccbtc       = wa_final-ccbtc
        EXCEPTIONS
          no_data_found = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR: wa_final,ls_selected_line.
    ELSE.
      IF wa_final-vbeln IS INITIAL.
        MESSAGE i208(00) WITH text-053. "Open AR transaction dont have settlement log.
      ELSE.
        MESSAGE i208(00) WITH text-045. "This item is not settled.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SHOW_HEADER
*&---------------------------------------------------------------------*
*&      Form  PROCESS_EVENTS_GRID1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_events_grid1 .
  CASE gs_column_id.
    WHEN 'BELNR'.
      IF NOT lwa_final-belnr IS INITIAL.
        SET PARAMETER ID 'BLN'   FIELD lwa_final-belnr.
        SET PARAMETER ID 'BUK'   FIELD lwa_final-bukrs.
        SET PARAMETER ID 'GJR'   FIELD lwa_final-gjahr.
        CALL TRANSACTION 'FB03'  AND SKIP FIRST SCREEN.
      ENDIF.
    WHEN 'VBELN'.
      IF NOT lwa_final-vbeln IS INITIAL.
        SET PARAMETER ID 'AUN'   FIELD lwa_final-vbeln.
        CALL TRANSACTION 'VA03'  AND SKIP FIRST SCREEN.
      ENDIF.
    WHEN 'XBLNR2'.
      IF NOT lwa_final-xblnr2 IS INITIAL.
        SET PARAMETER ID 'VF'   FIELD lwa_final-xblnr2.
        CALL TRANSACTION 'VF03'  AND SKIP FIRST SCREEN.
      ENDIF.
    WHEN 'KUNNR'.
*Display Customer (centrally) :
      SET PARAMETER ID 'KUN' FIELD lwa_final-kunnr. " customer number
      SET PARAMETER ID 'BUK' FIELD lwa_final-bukrs.  "company code
      SET PARAMETER ID 'VKO' FIELD lwa_final-vkorg.  "sales organization
      SET PARAMETER ID 'VTW' FIELD lwa_final-vtweg.  "distribution channel
      SET PARAMETER ID 'WRK' FIELD lwa_final-spart.  "division
      CALL TRANSACTION 'XD03' AND SKIP FIRST SCREEN.
    WHEN 'CCBTC'.
      IF NOT lwa_final-ccbtc IS INITIAL.
        CALL FUNCTION 'CCARD_SETTLEMENT_SHOW_ITEMS'
          EXPORTING
            i_ccbtc           = lwa_final-ccbtc
            i_koart           = 'S'
          EXCEPTIONS
            index_not_active  = 1
            no_protocol_found = 2
            no_items_found    = 3
            OTHERS            = 4.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLLECT_SETTLEMENTDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM collect_settlementdata .
  SORT: lt_bsegc BY ccbtc.
  LOOP AT lt_bsegc INTO lwa_bsegc.
    MOVE-CORRESPONDING lwa_bsegc TO lwa_final.
* Collect settlement log information
    READ TABLE lt_tcclg INTO lwa_tcclg WITH KEY ccbtc = lwa_final-ccbtc.
    IF sy-subrc = 0.
      lwa_final-fdatu    = lwa_tcclg-fdatu.
      lwa_final-ldatu    = lwa_tcclg-ldatu.
      lwa_final-vblnr    = lwa_tcclg-vblnr.
      lwa_final-gjahr_st = lwa_tcclg-gjahr.
      lwa_final-xsucc    = lwa_tcclg-xsucc.
      lwa_final-xfail    = lwa_tcclg-xfail.
      CLEAR lwa_tcclg.
    ENDIF.
* Collect bill doc
    READ TABLE lt_vbrk INTO lwa_vbrk WITH KEY vbeln = lwa_final-belnr
                                     BINARY SEARCH.
    IF sy-subrc = 0.
      lwa_final-xblnr2 = lwa_vbrk-vbeln.
      PERFORM get_status_acc.
      CLEAR lwa_vbrk.
    ENDIF.
* Collect order number
    READ TABLE lt_vbfa INTO lwa_vbfa WITH KEY vbeln = lwa_final-belnr
                                     BINARY SEARCH.
    IF sy-subrc = 0.
      lwa_final-vbeln = lwa_vbfa-vbelv.
      CLEAR lwa_vbfa.
    ENDIF.
* Collect order status
    READ TABLE lt_vbuk INTO lwa_vbuk WITH KEY vbeln = lwa_final-vbeln
                                     BINARY SEARCH.
    IF sy-subrc = 0.
      lwa_final-cmgst = lwa_vbuk-cmgst.
      lwa_final-gbstk = lwa_vbuk-gbstk.
      CLEAR lwa_vbuk.
    ENDIF.
* Collect order information
    READ TABLE it_so INTO wa_so WITH KEY vbeln = lwa_final-vbeln
                                BINARY SEARCH.
    IF sy-subrc = 0.
      lwa_final-erdat    = wa_so-erdat.
      lwa_final-ernam    = wa_so-ernam.
      lwa_final-auart    = wa_so-auart.
      lwa_final-vkorg    = wa_so-vkorg.
      lwa_final-vtweg    = wa_so-vtweg.
      lwa_final-spart    = wa_so-spart.
      lwa_final-kunnr    = wa_so-kunnr.
      lwa_final-netwr    = wa_so-netwr.
      lwa_final-bukrs_vf = wa_so-bukrs_vf.
      lwa_final-inco1    = wa_so-inco1.
      lwa_final-inco2    = wa_so-inco2.
* Collect FPLTC information
      READ TABLE it_crcard INTO wa_crcard WITH KEY fplnr = wa_so-rplnr
                                          BINARY SEARCH.
      IF sy-subrc = 0.
        lwa_final-fplnr = wa_crcard-fplnr.
        lwa_final-fpltr = wa_crcard-fpltr.
        lwa_final-merch = wa_crcard-merch.
        lwa_final-ccaua = wa_crcard-ccaua.
        lwa_final-ccall = wa_crcard-ccall.
        lwa_final-react = wa_crcard-react.
* Auth amount conversion
* Reporting Return Order amount as negative
        IF lwa_final-aunum = 'RO'.
          lwa_final-autwr = -1 * wa_crcard-autwr.
          lwa_final-autwv = -1 * wa_crcard-autwv.
        ELSE.
          lwa_final-autwr =  wa_crcard-autwr.
          lwa_final-autwv =  wa_crcard-autwv.
        ENDIF.
        lwa_final-rtext = wa_crcard-rtext.
        CLEAR wa_crcard.
      ENDIF.
      CLEAR wa_so.
    ENDIF.
*Collect partner information
    LOOP AT lt_vbpa INTO lwa_vbpa WHERE vbeln = lwa_final-vbeln.
      CASE lwa_vbpa-parvw.
        WHEN 'RG'.
          lwa_final-payer = lwa_vbpa-kunnr.
        WHEN 'WE'.
          lwa_final-shipto = lwa_vbpa-kunnr.
        WHEN 'AG'.
          lwa_final-soldto = lwa_vbpa-kunnr.
        WHEN 'RE'.
          lwa_final-billto = lwa_vbpa-kunnr.
      ENDCASE.
      CLEAR lwa_vbpa.
    ENDLOOP.
* Get settled amount from BSAS
    PERFORM get_bsas_data USING    lwa_final
                                   lt_bsas
                          CHANGING it_final.
    APPEND lwa_final TO it_final.
    CLEAR: lwa_final,lwa_bsegc.
  ENDLOOP.
  REFRESH: lt_bsas,lt_bsegc,lt_bsad,lt_bsis,it_so,
           it_crcard,lt_vbuk,lt_vbrk,lt_vbfa,lt_vbpa.
  PERFORM apply_filter.
ENDFORM. "COLLECT_SETTLEMENTDATA
*&---------------------------------------------------------------------*
*&      Form  GET_STATUS_ACC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_status_acc .
  DATA: BEGIN OF xbkpf OCCURS 1.
          INCLUDE STRUCTURE bkpf.
        DATA: END OF xbkpf.
  DATA: BEGIN OF xbseg OCCURS 1.
          INCLUDE STRUCTURE bseg.
        DATA: END   OF xbseg.
  DATA: da_gjahr LIKE t009y-gjahr,
        da_poper LIKE t009-anzbp.
  DATA: BEGIN OF lt_bkpf_temp OCCURS 1.
  DATA:   belnr LIKE bkpf-belnr.
  DATA: END OF lt_bkpf_temp.

  REFRESH xbkpf.
  CALL FUNCTION 'FI_DOCUMENT_READ'
    EXPORTING
      i_awtyp     = 'VBRK'
      i_awref     = lwa_final-xblnr2
      i_awsys     = lwa_vbrk-logsys
      i_bukrs     = lwa_vbrk-bukrs
      i_gjahr     = lwa_vbrk-gjahr
    TABLES
      t_bkpf      = xbkpf
      t_bseg      = xbseg
    EXCEPTIONS
      wrong_input = 1
      not_found   = 2.
  DESCRIBE TABLE xbkpf LINES sy-tabix.
  IF sy-tabix NE 0.
* Delete documents from other fiscal year
    IF sy-tabix > 1.
      CALL FUNCTION 'FI_PERIOD_DETERMINE'
        EXPORTING
          i_budat        = lwa_vbrk-fkdat
          i_bukrs        = lwa_vbrk-bukrs
        IMPORTING
          e_gjahr        = da_gjahr
          e_poper        = da_poper
        EXCEPTIONS
          fiscal_year    = 1
          period         = 2
          period_version = 3
          posting_period = 4
          special_period = 5
          version        = 6
          posting_date   = 7
          OTHERS         = 8.
      IF sy-subrc = 0.
        CONCATENATE da_gjahr da_poper INTO vbrk-gjahr.
        LOOP AT xbkpf WHERE gjahr EQ vbrk-gjahr.
          lwa_bkpf-belnr = xbkpf-belnr.
          APPEND lwa_bkpf TO lt_bkpf_temp.
        ENDLOOP.
        LOOP AT lt_bkpf_temp.
          DELETE xbkpf WHERE belnr EQ lt_bkpf_temp-belnr AND
                             gjahr NE lwa_vbrk-gjahr.
        ENDLOOP.
      ENDIF.
    ENDIF.
    LOOP AT xbkpf.
      LOOP AT xbseg WHERE bukrs EQ xbkpf-bukrs
                    AND   belnr EQ xbkpf-belnr
                    AND   gjahr EQ xbkpf-gjahr
                    AND   ( koart EQ 'D' OR koart EQ 'K' ).
      ENDLOOP.
      IF sy-subrc NE 0.
        lwa_final-status_acc = 'C'.
      ELSE.
        LOOP AT xbseg WHERE NOT augbl IS INITIAL
                      AND   ( koart EQ 'D' OR koart EQ 'K' ).
        ENDLOOP.
        IF NOT sy-subrc IS INITIAL.
*   SET STATUS TO 'No items are cleared'
          lwa_final-status_acc = 'A'.
        ELSE.
          LOOP AT xbseg WHERE augbl IS INITIAL
                        AND   umskz NE 'A'
                        AND   vorgn NE 'AZUM'
                        AND   ( koart EQ 'D' OR koart EQ 'K' ).
          ENDLOOP.
          IF NOT sy-subrc IS INITIAL.
*   Set status to 'All items are cleared'
            lwa_final-status_acc = 'C'.
          ENDIF.
        ENDIF.
* Otherwise: If there are customer/vendor positions where AUGBL is
* filled and some other ones where AUGBL is blank then set status
* to 'Partially cleared'
        IF wa_final-status_acc IS INITIAL.
          lwa_final-status_acc = 'B'.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILTER_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM apply_filter.
  IF kunnr[] IS NOT INITIAL.
    DELETE it_final WHERE soldto NOT IN kunnr[].
  ENDIF.
  IF payer[] IS NOT INITIAL.
    DELETE it_final WHERE payer NOT IN payer[].
  ENDIF.
  IF auart[] IS NOT INITIAL.
    DELETE it_final WHERE auart NOT IN auart[].
  ENDIF.
  IF vkorg[] IS NOT INITIAL.
    DELETE it_final WHERE vkorg NOT IN vkorg.
  ENDIF.
  IF vbeln[] IS NOT INITIAL.
    DELETE it_final WHERE vbeln NOT IN vbeln[].
  ENDIF.
  IF inco1[] IS NOT INITIAL.
    DELETE it_final WHERE inco1 NOT IN inco1[].
  ENDIF.
  IF xblnr[] IS NOT INITIAL.
    DELETE it_final WHERE xblnr NOT IN xblnr[].
  ENDIF.
  IF xblnr2[] IS NOT INITIAL.
    DELETE it_final WHERE xblnr2 NOT IN xblnr2[].
  ENDIF.
  IF zuonr[] IS NOT INITIAL.
    DELETE it_final WHERE zuonr NOT IN zuonr[].
  ENDIF.
  IF belnr[] IS NOT INITIAL.
    DELETE it_final WHERE belnr NOT IN belnr[].
  ENDIF.
  IF ccbtc[] IS NOT INITIAL.
    DELETE it_final WHERE ccbtc NOT IN ccbtc[].
  ENDIF.
  IF autwr[] IS NOT INITIAL.
    DELETE it_final WHERE autwr NOT IN autwr[].
  ENDIF.
  IF fdatu[] IS NOT INITIAL.
    DELETE it_final WHERE fdatu NOT IN fdatu[].
  ENDIF.
  IF bukrs[] IS NOT INITIAL.
    DELETE it_final WHERE bukrs NOT IN bukrs[].
  ENDIF.
  IF dmbtr[] IS NOT INITIAL.
    DELETE it_final WHERE dmbtr NOT IN dmbtr[].
  ENDIF.
  IF cr_by IS NOT INITIAL.
    DELETE it_final WHERE status_acc NOT IN cr_by[].
  ENDIF.
*  IF gbstk[] IS NOT INITIAL.
*    DELETE it_final WHERE gbstk NOT IN gbstk[].
*  ENDIF.
*  IF cmgst[] IS NOT INITIAL.
*    DELETE it_final WHERE cmgst NOT IN cmgst[].
*  ENDIF.
*  IF valdty[] IS NOT INITIAL.
*    DELETE it_final WHERE valdty NOT IN valdty[].
*  ENDIF.
*  IF acstatus[] IS NOT INITIAL.
*    DELETE it_final WHERE status_acc NOT IN acstatus[].
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REACT_FILTER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM react_filter .
  SORT: it_crcard BY fplnr DESCENDING
                     fpltr DESCENDING.
  SORT: it_so     BY vbeln
                     rplnr DESCENDING.
  SORT: it_final  BY vbeln
                     fplnr DESCENDING
                     fpltr DESCENDING.

  LOOP AT react WHERE low  = 'B' OR low  = 'C'
                   OR high = 'B' OR high = 'C'.
* If B and C are requested, order number with latest B only should be removed
    LOOP AT it_final INTO lwa_final.
      READ TABLE it_so INTO wa_so WITH KEY vbeln = lwa_final-vbeln
                                  BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE it_crcard INTO wa_crcard WITH KEY fplnr = lwa_final-fplnr.
*                                            BINARY SEARCH.
        IF sy-subrc = 0.
          IF lwa_final-react = 'B' OR lwa_final-react = 'C'.
* Keep the record if the latest status ia a failure
* Adding One condition considering 0000000327   900003(ED2)
* Auth. same time but there is a successful authorization
*            but on screen failure shows up second
            READ TABLE it_final TRANSPORTING NO FIELDS
            WITH KEY fplnr = wa_crcard-fplnr
                     audat = wa_crcard-audat
                     autim = wa_crcard-autim
                     react = 'A'.
            IF sy-subrc <> 0.
              DELETE it_final WHERE vbeln = wa_so-vbeln
                              AND   fplnr = wa_crcard-fplnr
                              AND   fpltr <> wa_crcard-fpltr.
            ENDIF.
          ELSE.
* Delete the order as well if latest status is success 'A'
            DELETE it_final WHERE vbeln = wa_so-vbeln.
          ENDIF.
          CLEAR wa_crcard.
        ENDIF.
        CLEAR: lwa_final,wa_so.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  REFRESH: it_crcard[],it_so[].
* Show only latest failure 06132018 Joe Requirement
  SORT: it_final BY vbeln ccins ccnum ASCENDING
                    audat             DESCENDING.
  DELETE ADJACENT DUPLICATES FROM it_final COMPARING vbeln ccins ccnum.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BACKGROUND_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM background_display .
  DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
        gt_events   TYPE slis_t_event,
        gs_variant  LIKE disvariant,
        g_repid     LIKE sy-repid.

  g_repid           = sy-repid.
  gs_variant-report = g_repid.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = '/CDITECH/CRCARD_RPT'
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = gt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = g_repid
      it_fieldcat        = gt_fieldcat
      i_save             = 'X'
      is_variant         = gs_variant
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BSAS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LWA_FINAL  text
*      -->P_LT_BSAS  text
*      -->P_IT_FINAL  text
*----------------------------------------------------------------------*
FORM get_bsas_data  USING    lwa_final TYPE ty_final
                             lt_bsas   TYPE ty_bsas
                    CHANGING it_final  TYPE ty_final_t.

  READ TABLE lt_bsas INTO lwa_bsas
  WITH KEY bukrs = lwa_final-bukrs
           belnr = lwa_final-belnr
           gjahr = lwa_final-gjahr
           rfzei = lwa_final-rfzei
  BINARY SEARCH.
  IF sy-subrc = 0.
*TBSL - PostngKey Credit/DIndr AccntType   LText
*       11        H-Credit     D(Customer) Credit memo
*       50        H-Credit     S(GLAccnt)  Credit entry
    IF lwa_bsas-shkzg = 'H'. "Credit
      lwa_final-dmbtr = -1 * lwa_bsas-dmbtr.
      lwa_final-wrbtr = -1 * lwa_bsas-wrbtr.
      lwa_final-xblnr = lwa_bsas-xblnr.
      lwa_final-zuonr = lwa_bsas-zuonr.
      lwa_final-sgtxt = lwa_bsas-sgtxt.
*Credit Memo for Refund/Return Orders, show auth as credit as well
      IF lwa_bsas-bschl = '50'.
        lwa_final-autwr = -1 * lwa_final-autwr.
        lwa_final-autwv = -1 * lwa_final-autwv.
      ELSE.
* For Invoice Cancellations, add positive item as well 08-Posting Key-PaymentClearing
        READ TABLE lt_bsas INTO lwa_bsas
        WITH KEY bukrs = lwa_final-bukrs
                 belnr = lwa_final-belnr
                 gjahr = lwa_final-gjahr
                 rfzei = lwa_final-rfzei
                 shkzg = 'S'. "11-Posting Key-CreditMemo
*        BINARY SEARCH.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING lwa_final TO wa_final.
          wa_final-dmbtr = lwa_bsas-dmbtr.
          wa_final-wrbtr = lwa_bsas-wrbtr.
          wa_final-zuonr = lwa_bsas-zuonr.
          wa_final-sgtxt = lwa_bsas-sgtxt.
          APPEND wa_final TO it_final.
          CLEAR: wa_final,lwa_bsas.
        ENDIF.
      ENDIF.
    ELSE.
      lwa_final-dmbtr = lwa_bsas-dmbtr.
      lwa_final-wrbtr = lwa_bsas-wrbtr.
      lwa_final-xblnr = lwa_bsas-xblnr.
      lwa_final-zuonr = lwa_bsas-zuonr.
      lwa_final-sgtxt = lwa_bsas-sgtxt.
      CLEAR lwa_bsas.
    ENDIF.
  ENDIF.
ENDFORM.
*BOC <ERP-6370> <ED2K913836>
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ROWS  text
*----------------------------------------------------------------------*
FORM send_email TABLES   p_et_index_rows TYPE lvc_t_row.

  CLEAR: lt_final1[], it_kna1[], gv_cnt, it_ser[], wa_ser,
         i_joblog[], st_joblog.    "+ <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
  LOOP AT p_et_index_rows INTO ls_selected_line.
    READ TABLE it_final INDEX ls_selected_line-index INTO wa_final.
    IF wa_final-ccall = 'C'.
      APPEND wa_final TO lt_final1.
      CLEAR: wa_final.
    ENDIF.
  ENDLOOP.

  IF sy-batch IS NOT INITIAL.
    lt_final1[] = it_final[].
    PERFORM get_ccp_notif_data.
  ENDIF.

  SELECT a~sales_model a~region a~land1 b~konda b~service_info FROM zqtc_ctry_reg AS a
           LEFT OUTER JOIN zqtc_reg_ser AS b
           ON a~sales_model = b~sales_model
           AND a~region = b~region
           INTO TABLE it_ser.
  IF sy-subrc = 0.
    SORT it_ser BY land1 konda.
  ENDIF.

*BOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
** Get data from ZCACONSTANTS table
  CLEAR i_const[].
  SELECT devid            "Development ID
         param1           "ABAP: Name of Variant Variable
         param2           "ABAP: Name of Variant Variable
         srno             "Current selection number
         sign             "ABAP: ID: I/E (include/exclude values)
         opti             "ABAP: Selection option (EQ/BT/CP/...)
         low              "Lower Value of Selection Condition
         high             "Upper Value of Selection Condition
         FROM zcaconstant " Wiley Application Constant Table
         INTO TABLE i_const
         WHERE devid = c_devid_r080
           AND activate = abap_true.
  IF sy-subrc IS INITIAL.
    SORT i_const BY devid param1 low.
  ENDIF. " IF sy-subrc IS INITIAL
*EOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>

  IF lt_final1[] IS INITIAL.
    MESSAGE i208(00) WITH text-056.
  ELSE.
    CLEAR: it_kna1[].
    SELECT a~kunnr a~land1 a~name1 a~spras b~smtp_addr c~deflt_comm FROM kna1 AS a
           LEFT OUTER JOIN adr6 AS b ON a~adrnr = b~addrnumber
           INNER JOIN adrc AS c ON a~adrnr = c~addrnumber
           INTO TABLE it_kna1
           FOR ALL ENTRIES IN lt_final1
           WHERE a~kunnr = lt_final1-kunnr.
    IF sy-subrc = 0.
      SORT it_kna1 BY kunnr.
    ENDIF.
*Get Price group (customer)
    CLEAR it_vbkd[].
    SELECT vbeln
           posnr
           konda
           kdgrp
           inco1
           inco2
*BOC <ERP-6370> <ED2K913974>
           ihrez_e
*EOC <ERP-6370> <ED2K913974>
      INTO TABLE it_vbkd
      FROM vbkd
      FOR ALL ENTRIES IN lt_final1
      WHERE vbeln EQ lt_final1-vbeln
        AND posnr NE space.
    IF sy-subrc = 0.
      SORT it_vbkd BY vbeln.
    ENDIF.

*BOC <ERP-6370> <ED2K913983>
    CLEAR it_vbap[].
    SELECT vbeln
           posnr
           mvgr5
      INTO TABLE it_vbap
      FROM vbap
      FOR ALL ENTRIES IN lt_final1
      WHERE vbeln EQ lt_final1-vbeln.
    IF sy-subrc = 0.
      SORT it_vbap BY vbeln posnr.
    ENDIF.
*EOC <ERP-6370> <ED2K913983>

*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*Fetch Authorization failed date
    CLEAR i_fpltc[].
    SELECT fplnr
           fpltr
           audat
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
           react
           rcrsp
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      INTO TABLE i_fpltc
      FROM fpltc
      FOR ALL ENTRIES IN lt_final1
      WHERE fplnr EQ lt_final1-fplnr
*      AND fpltr EQ lt_final1-fpltr.  "- <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        AND audat IN audat.             "+ <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
    IF sy-subrc = 0.
      SORT i_fpltc BY fplnr fpltr DESCENDING.
    ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Get Order details
    CLEAR i_vbak[].
    SELECT vbeln
           audat
           rplnr
      INTO TABLE i_vbak
      FROM vbak
      FOR ALL ENTRIES IN lt_final1
      WHERE vbeln EQ lt_final1-vbeln.
    IF sy-subrc = 0.
      SORT i_vbak BY vbeln.
    ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
*Avoid Duplicate Email notifications
    CLEAR: lt_ccp_notif[].
    SELECT * FROM zqtc_ccp_notif
      INTO TABLE lt_ccp_notif
      FOR ALL ENTRIES IN lt_final1
      WHERE vbeln EQ lt_final1-vbeln AND
            vkorg EQ lt_final1-vkorg AND
            vtweg EQ lt_final1-vtweg AND
            spart EQ lt_final1-spart AND
            fplnr EQ lt_final1-fplnr.
    IF sy-subrc = 0.
      SORT lt_ccp_notif BY vbeln vkorg vtweg spart fplnr.
    ENDIF.
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019


    LOOP AT lt_final1 INTO wa_final.
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
*Check Duplicate Email Notifications
      CLEAR lv_dup_notif.
      PERFORM f_duplicate_notif USING    wa_final
                                CHANGING lv_dup_notif.
      IF lv_dup_notif EQ abap_true.
        CONTINUE.
      ENDIF.
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_final-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c ).
*Begin of Change MRAJKUMAR OTCM-53244   ED2K925616 25-JAN-2022
*                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*End of Change MRAJKUMAR OTCM-53244   ED2K925616 25-JAN-2022
        wa_final-audat = st_fpltc-audat.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_final-vbeln wa_final-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_final-vkorg wa_final-vtweg
                                     wa_final-spart wa_final-fplnr
*                                   wa_final-fpltr   "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_final-audat
                                     wa_final-netwr wa_final-ccwae
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_final-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
    ENDLOOP.
  ENDIF.

  IF sy-batch IS NOT INITIAL AND lt_ccp_a[] IS NOT INITIAL.
    CLEAR: it_kna1[].
    SELECT a~kunnr a~land1 a~name1 a~spras b~smtp_addr c~deflt_comm FROM kna1 AS a
           LEFT OUTER JOIN adr6 AS b ON a~adrnr = b~addrnumber
           INNER JOIN adrc AS c ON a~adrnr = c~addrnumber
           INTO TABLE it_kna1
           FOR ALL ENTRIES IN lt_ccp_a
           WHERE a~kunnr = lt_ccp_a-kunnr.
    IF sy-subrc = 0.
      SORT it_kna1 BY kunnr.
    ENDIF.

*Get Price group (customer)
    CLEAR it_vbkd[].
    SELECT vbeln
           posnr
           konda
           kdgrp
           inco1
           inco2
           ihrez_e
      INTO TABLE it_vbkd
      FROM vbkd
      FOR ALL ENTRIES IN lt_ccp_a
      WHERE vbeln EQ lt_ccp_a-vbeln
        AND posnr NE space.
    IF sy-subrc = 0.
      SORT it_vbkd BY vbeln.
    ENDIF.

*BOC <ERP-6370> <ED2K913983>
    CLEAR it_vbap[].
    SELECT vbeln
           posnr
           mvgr5
      INTO TABLE it_vbap
      FROM vbap
      FOR ALL ENTRIES IN lt_ccp_a
      WHERE vbeln EQ lt_ccp_a-vbeln.
    IF sy-subrc = 0.
      SORT it_vbap BY vbeln posnr.
    ENDIF.
*EOC <ERP-6370> <ED2K913983>

*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*Fetch Authorization failed date
    CLEAR i_fpltc[].
    SELECT fplnr
           fpltr
           audat
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
           react
           rcrsp
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      INTO TABLE i_fpltc
      FROM fpltc
      FOR ALL ENTRIES IN lt_ccp_a
      WHERE fplnr EQ lt_ccp_a-fplnr
*      AND fpltr EQ lt_final1-fpltr.  "- <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        AND audat IN audat.             "+ <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
    IF sy-subrc = 0.
      SORT i_fpltc BY fplnr fpltr DESCENDING.
    ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
    CLEAR i_vbak[].
    SELECT vbeln
           audat
           rplnr
      INTO TABLE i_vbak
      FROM vbak
      FOR ALL ENTRIES IN lt_ccp_a
      WHERE vbeln EQ lt_ccp_a-vbeln.
    IF sy-subrc = 0.
      SORT i_vbak BY vbeln.
    ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>


*** Send notification after 30 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 30.
    gv_rcdat = sy-datum - 59.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat "Audat -Change:INC0229621:HIPATEL:ED1K909993
                      OR   day30 IS NOT INITIAL.
    gv_cnt = 1.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr             "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.

*** Send notification after 60 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 60.
    gv_rcdat = sy-datum - 89.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat "Audat -Change:INC0229621:HIPATEL:ED1K909993
                         OR day60 IS NOT INITIAL.
    gv_cnt = 2.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.

*** Send notification after 90 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 90.
    gv_rcdat = sy-datum - 119.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat  "Audat -Change:INC0229621:HIPATEL:ED1K909993
                         OR day90 IS NOT INITIAL.
    gv_cnt = 3.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.

*** Send notification after 120 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 120.
    gv_rcdat = sy-datum - 149.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat  "Audat -Change:INC0229621:HIPATEL:ED1K909993
                         OR day120 IS NOT INITIAL.
    gv_cnt = 4.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.

*** Send notification after 150 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 150.
    gv_rcdat = sy-datum - 179.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat  "Audat -Change:INC0229621:HIPATEL:ED1K909993
                         OR day150 IS NOT INITIAL.
    gv_cnt = 5.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.

*** Send notification after 180 days.
    CLEAR: lt_ccp_d[], wa_ccp.
    lt_ccp_d[] = lt_ccp_a[].
    gv_sndat = sy-datum - 180.
    gv_rcdat = sy-datum - 210.
    DELETE lt_ccp_d[] WHERE day1 NOT BETWEEN gv_rcdat AND gv_sndat  "Audat -Change:INC0229621:HIPATEL:ED1K909993
                         OR day180 IS NOT INITIAL.
    gv_cnt = 6.
    LOOP AT lt_ccp_d INTO wa_ccp.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*Check Latest FPLTR record for current status of CC Payment
      CLEAR st_fpltc.
      READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = wa_ccp-fplnr.
      IF sy-subrc = 0 AND ( st_fpltc-react EQ c_b OR st_fpltc-react EQ c_c )
                      AND ( st_fpltc-rcrsp EQ c_pos OR st_fpltc-rcrsp EQ c_neg ).
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
        PERFORM send_mail_user USING wa_ccp-vbeln wa_ccp-kunnr
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-vkorg wa_ccp-vtweg
                                     wa_ccp-spart wa_ccp-fplnr
*                                   wa_ccp-fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                     wa_ccp-audat
                                     wa_ccp-netwr wa_ccp-waerk
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                                     wa_ccp-auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      ENDIF.  "+<HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      CLEAR: wa_ccp.
    ENDLOOP.
  ENDIF.
  IF lt_ccp[] IS NOT INITIAL.
    MODIFY zqtc_ccp_notif FROM TABLE lt_ccp[].
  ENDIF.
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
  IF i_joblog[] IS NOT INITIAL.
    SORT i_joblog BY vbeln.
*Send Error log to Email ID on Selection Screen
    IF s_email[] IS NOT INITIAL.
      DATA(li_joblog) = i_joblog[].
      IF p_ddwn1 NE c_sign_incld.
        DELETE li_joblog WHERE mstyp NE p_ddwn1.
      ENDIF.
      IF li_joblog[] IS NOT INITIAL.
        PERFORM f_send_log USING  s_email[]
                                  li_joblog.
      ENDIF.
    ENDIF.
*Display Log on the screen
    PERFORM f_display_message USING i_joblog.
  ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL_USER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_mail_user USING p_gv_ord p_gv_cust
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                          p_vkorg p_vtweg
                          p_spart p_fplnr
*                          p_fpltr     "-<HIPATEL> <INC0229621> <ED1K909840>
                          p_audat
                          p_netwr p_ccwae
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
                          p_auart.  "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>

* Data Declarations
  DATA: lst_mailtxt    TYPE soli,                     "SAPoffice: line, length 255
        li_mailtxt     TYPE bcsy_text,                "Table for body, " SAPoffice: line, length 255
        li_lines       TYPE idmx_di_t_tline,          "Table for read text
        lst_lines      TYPE tline,                    "Workarea for line
        lv_lin         TYPE sy-index,                 "Line index
        lv_title       TYPE so_obj_des,               "Title for SAP inbox
        lv_receiver    TYPE ad_smtpadr,               "Email recipient
        lv_sub         TYPE string,                   "Email Subject length 255
        lv_eml_title   TYPE thead-tdname,             "Email Title
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
        lv_partner     TYPE bu_partner,           "Business Partner
        lst_bp_address TYPE bapibus1006_address,  "BP Address details
        li_bapismtp    TYPE bapiadsmtp_t,         "BP Email Address details
        lst_bapismtp   TYPE bapiadsmtp,           "BP Email Address details
        lv_message     TYPE string,               "Message Text
        lv_mstyp       TYPE char01.               "Message Type
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>

*Prepare Mail Object
  DATA: lo_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,           "Sender Class
        lo_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL,  "document object
        lo_sender       TYPE REF TO if_sender_bcs VALUE IS INITIAL,    "sender
        lo_recipient    TYPE REF TO if_recipient_bcs VALUE IS INITIAL. "recipient

  CONSTANTS: lc_int        TYPE ad_comm    VALUE 'INT',
             lc_de         TYPE spras      VALUE 'DE',
             lc_en         TYPE spras      VALUE 'EN',
             lc_param1     TYPE rvari_vnam VALUE 'MVGR5',    " ABAP: Name of Variant Variable.
             lc_title_memb TYPE tdobname VALUE 'ZQTC_CCP_FAIL_TITLE_',
             lc_title_cust TYPE tdobname VALUE 'ZQTC_CCP_FAIL_TITLE_CUST'.

* Populate the recipient list
  CLEAR: wa_kna1, wa_ser, lv_receiver.
*BOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
*  READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = p_gv_cust BINARY SEARCH.
*  IF sy-subrc = 0 AND wa_kna1-email IS NOT INITIAL.
*    lv_receiver = wa_kna1-email.
*  ELSE.
*EOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*Fetching Required Email and other details from BP
  CLEAR lv_partner.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = p_gv_cust
    IMPORTING
      output = lv_partner.

  CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
    EXPORTING
      businesspartner = lv_partner
      valid_date      = sy-datlo
    IMPORTING
      addressdata     = lst_bp_address
    TABLES
      bapiadsmtp      = li_bapismtp.
  IF sy-subrc = 0.
    wa_kna1-kunnr       = p_gv_cust.
    wa_kna1-land1       = lst_bp_address-country.
    wa_kna1-spras       = lst_bp_address-langu.
    wa_kna1-deflt_comm  = lst_bp_address-comm_type.
    CLEAR lst_bapismtp.
    READ TABLE li_bapismtp INTO lst_bapismtp INDEX 1.
    IF sy-subrc = 0.
      wa_kna1-email     = lst_bapismtp-e_mail.
    ENDIF.
  ENDIF.
  IF wa_kna1-email IS NOT INITIAL.
    lv_receiver = wa_kna1-email.
  ELSE.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
    IF sy-batch IS NOT INITIAL AND wa_kna1-deflt_comm EQ lc_int.
      MESSAGE i368(00) WITH text-058 p_gv_cust.
    ENDIF.
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*Job log for error message
    CLEAR: lv_message, lv_mstyp.
    MESSAGE i368(00) WITH text-058 p_gv_cust INTO lv_message.  "Email address not maintained for BP
*BOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = p_gv_cust BINARY SEARCH.
    IF sy-subrc = 0.
*Name1 required from KNA1 table
    ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
    lv_mstyp = c_e.
    PERFORM f_create_job_log USING lv_message
                                   p_gv_ord p_gv_cust
                                   p_vkorg  p_vtweg
                                   p_spart  wa_kna1-name1
                                   p_fplnr
*                                        p_fpltr              "-<HIPATEL> <INC0229621> <ED1K909840>
                                   p_audat  p_netwr
                                   p_ccwae  lv_mstyp
                          CHANGING i_joblog.
  ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*  ENDIF.  "- <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>

  IF NOT lv_receiver IS INITIAL.

* Populate Email Title.
    CLEAR lv_title.
    lv_title = text-057.          "Title

*BOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = p_gv_cust BINARY SEARCH.
    IF sy-subrc = 0.
*EOC by <HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>
*Default language = English
      IF wa_kna1-spras NE lc_de.
        wa_kna1-spras = lc_en.
      ENDIF.
    ENDIF.    "+<HIPATEL> <INC0229621> <ED1K909691> <02/26/2019>

* Read Email Subject with language.
    CLEAR: li_lines[].
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = wa_kna1-spras
        name                    = 'ZQTC_CCP_FAIL_SUBJECT'
        object                  = 'TEXT'
      TABLES
        lines                   = li_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7.
    IF sy-subrc = 0.

    ENDIF.
* Populate Email Subject.
    LOOP AT li_lines INTO lst_lines.
      CONCATENATE lv_sub  lst_lines-tdline INTO lv_sub.
    ENDLOOP.


*Read Price Group
    CLEAR wa_vbkd.
    READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = p_gv_ord
                                    BINARY SEARCH.
    IF sy-subrc = 0.
*Read Customer service number
      CLEAR: wa_ser, lv_tel.  "+<HIPATEL> <INC0229621> <ED1K909840>
      READ TABLE it_ser INTO wa_ser WITH KEY land1 = wa_kna1-land1
                                             konda = wa_vbkd-konda
                                             BINARY SEARCH.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*If no Price Group available in Order then Print First records for Customer's Country
      IF sy-subrc NE 0.
        CLEAR: wa_ser, lv_tel.
        READ TABLE it_ser INTO wa_ser WITH KEY land1 = wa_kna1-land1.
      ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
      IF sy-subrc = 0.
        lv_tel = wa_ser-service_info.
      ENDIF.
    ENDIF.

*BOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
    CLEAR st_const.
    READ TABLE i_const INTO st_const WITH KEY devid  = c_devid_r080
                                              param1 = c_auart
                                              low    = p_auart
                                              BINARY SEARCH.
*EOC by <HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
*BOC <ERP-6370> <ED2K913974>
*Document Number
    IF NOT wa_vbkd-ihrez_e IS INITIAL
       AND ( sy-subrc NE 0 AND wa_vbkd-ihrez_e+0(1) NE c_s ).             "+<HIPATEL> <INC0229621> <ED1K909778> <03/08/2019>
      lv_vbeln = wa_vbkd-ihrez_e.
    ELSE.
      lv_vbeln = p_gv_ord.
    ENDIF.
*EOC <ERP-6370> <ED2K913974>

*BOC <ERP-6370> <ED2K913983>
    CLEAR: li_mailtxt[], lst_mailtxt, lv_eml_title, wa_vbap.
    READ TABLE it_vbap INTO wa_vbap WITH KEY vbeln = p_gv_ord.
    IF sy-subrc = 0.
      CONCATENATE lc_title_memb wa_vbap-mvgr5 INTO lv_eml_title.
    ENDIF.

* Read Email body title.
    CLEAR: li_lines[].
    IF NOT lv_eml_title IS INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'ST'
          language                = wa_kna1-spras
          name                    = lv_eml_title
          object                  = 'TEXT'
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7.
    ENDIF.
    IF sy-subrc NE 0.
      lv_eml_title = lc_title_cust.
* Read Email body title.
      CLEAR: li_lines[].
      IF NOT lv_eml_title IS INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = 'ST'
            language                = wa_kna1-spras
            name                    = lv_eml_title
            object                  = 'TEXT'
          TABLES
            lines                   = li_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7.
      ENDIF.
    ENDIF.
    IF sy-subrc = 0.
      READ TABLE li_lines INTO lst_lines INDEX 1.
      IF sy-subrc = 0.
        lst_mailtxt = lst_lines-tdline.       "Email body message
        APPEND lst_mailtxt TO li_mailtxt.     "Internal table of mail content
        CLEAR lst_mailtxt.
      ENDIF.
    ENDIF.
*EOC <ERP-6370> <ED2K913983>

*Read Email Body
    CLEAR: li_lines[].
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = wa_kna1-spras
        name                    = 'ZQTC_CCP_FAIL_TEXT'
        object                  = 'TEXT'
      TABLES
        lines                   = li_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7.
    IF sy-subrc = 0 AND li_lines[] IS NOT INITIAL.
      DESCRIBE TABLE li_lines LINES lv_lin.
      CALL FUNCTION 'REPLACE_TEXTSYMBOL'
        EXPORTING
          endline          = lv_lin
          language         = sy-langu
          linewidth        = 132
          option_dialog    = ' '
          replace_program  = 'X'
          replace_standard = 'X'
          replace_system   = 'X'
          replace_text     = 'X'
          startline        = 1
        TABLES
          lines            = li_lines.

    ENDIF.

*    CLEAR: li_mailtxt[], lst_mailtxt.  "- ERP-6370> <ED2K913983>

* Mail Contents
    LOOP AT li_lines INTO lst_lines.
      lst_mailtxt = lst_lines-tdline.       "Email body message
      APPEND lst_mailtxt TO li_mailtxt.     "Internal table of mail content
      CLEAR lst_mailtxt.
    ENDLOOP.


**Start Send Email
    TRY .
        lo_send_request = cl_bcs=>create_persistent( ).
      CATCH cx_send_req_bcs.
    ENDTRY.

    TRY .
        lo_document = cl_document_bcs=>create_document( "create document
        i_type = 'RAW' "Type of document HTM, TXT etc
        i_text =  li_mailtxt "email body internal table
        i_subject = lv_title ). "email subject here p_sub input parameter
      CATCH cx_document_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.

*Email Subject length 255
    CALL METHOD lo_send_request->set_message_subject
      EXPORTING
        ip_subject = lv_sub. "Email Subject length 255

* Pass the document to send request
    TRY.
        lo_send_request->set_document( lo_document ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
        lo_sender = cl_sapuser_bcs=>create( sy-uname ). "sender is the logged in user
* Set sender to send request
        lo_send_request->set_sender(
        EXPORTING
        i_sender = lo_sender ).
*    CATCH CX_ADDRESS_BCS.
****Catch exception here
    ENDTRY.

* Create recipient
    TRY.
        lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_receiver ). "Here Recipient is email input p_email
** Set recipient
        lo_send_request->add_recipient(
            EXPORTING
            i_recipient = lo_recipient
            i_express = 'X' ).
*  CATCH CX_SEND_REQ_BCS INTO BCS_EXCEPTION .
**Catch exception here
    ENDTRY.

*  TRY.
*    CALL METHOD LO_SEND_REQUEST->SET_SEND_IMMEDIATELY
*      EXPORTING
*        I_SEND_IMMEDIATELY = P_SEND. "here selection screen input p_send
**    CATCH CX_SEND_REQ_BCS INTO BCS_EXCEPTION .
***Catch exception here
*  ENDTRY.

    TRY.
** Send email
        lo_send_request->send(
        EXPORTING
        i_with_error_screen = 'X' ).

        IF sy-subrc = 0. "mail sent successfully
          COMMIT WORK.
*BOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
*Job log for sucess message
          IF sy-batch IS NOT INITIAL.
            MESSAGE i368(00) WITH text-059 p_gv_cust.  "Email sucessfully sent to BP
          ENDIF.
          CLEAR: lv_message, lv_mstyp.
          MESSAGE i368(00) WITH text-059 p_gv_cust INTO lv_message.
          lv_mstyp = c_s.
          PERFORM f_create_job_log USING lv_message
                                         p_gv_ord p_gv_cust
                                         p_vkorg  p_vtweg
                                         p_spart  wa_kna1-name1
                                         p_fplnr
*                                         p_fpltr                 "-<HIPATEL> <INC0229621> <ED1K909840>
                                         p_audat  p_netwr
                                         p_ccwae  lv_mstyp
                                CHANGING i_joblog.
*EOC by <HIPATEL> <INC0229621> <ED1K909522> <02/07/2019>
        ENDIF.
*    CATCH CX_SEND_REQ_BCS INTO BCS_EXCEPTION .
*catch exception here
    ENDTRY.
**End Send Email

*Update Notification table for Batchjob only
    IF sy-subrc EQ 0 AND sy-batch IS NOT INITIAL.
      PERFORM update_table.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CCP_NOTIF_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ccp_notif_data.

  CLEAR: lt_ccp_a[].
  SELECT a~* FROM zqtc_ccp_notif AS a
           INNER JOIN fpltc AS b ON  a~fplnr = b~fplnr
*                                 AND a~fpltr = b~fpltr   "- <HIPATEL> <INC0229621> <ED1K909840>
           INTO TABLE @lt_ccp_a
           WHERE b~ccall = 'C'
*           AND   b~react IN ('B', 'C')   "- <HIPATEL> <INC0229621> <ED1K909840>
*           AND   b~rcrsp IN ('1', '-1')  "- <HIPATEL> <INC0229621> <ED1K909840>
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
           AND   b~audat IN @audat.
  IF sy-subrc = 0.
    SORT lt_ccp_a BY vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_ccp_a COMPARING ALL FIELDS.
  ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_table.

  IF gv_cnt IS INITIAL.
    CLEAR: wa_ccp.
    wa_ccp-vbeln = wa_final-vbeln.
    wa_ccp-vkorg = wa_final-vkorg.
    wa_ccp-vtweg = wa_final-vtweg.
    wa_ccp-spart = wa_final-spart.
    wa_ccp-auart = wa_final-auart.
    wa_ccp-kunnr = wa_final-kunnr.
    wa_ccp-fplnr = wa_final-fplnr.
*    wa_ccp-fpltr = wa_final-fpltr.     "-<HIPATEL> <INC0229621> <ED1K909840>
*    wa_ccp-ccal = wa_final-ccall.
    wa_ccp-name1 = wa_kna1-name1.
    wa_ccp-audat = wa_final-audat.
    wa_ccp-netwr = wa_final-netwr.
    wa_ccp-waerk = wa_final-ccwae.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day1  = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 1.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day30 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 2.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day60 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 3.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day90 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 4.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day120 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 5.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day150 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ELSEIF gv_cnt = 6.
*    wa_ccp-aedat = sy-datum.
    wa_ccp-day180 = sy-datum.
    APPEND wa_ccp TO lt_ccp.
  ENDIF.

ENDFORM.
*EOC <ERP-6370> <ED2K913836>
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_JOB_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_FINAL  text
*      <--P_I_JOBLOG  text
*----------------------------------------------------------------------*
FORM f_create_job_log  USING    fp_message TYPE string
                                fp_gv_ord fp_gv_cust
                                fp_vkorg fp_vtweg
                                fp_spart fp_name1
                                fp_fplnr
*                                fp_fpltr         "-<HIPATEL> <INC0229621> <ED1K909840>
                                fp_audat fp_netwr
                                fp_ccwae fp_mstyp
                       CHANGING i_joblog   TYPE tt_joblog.

  st_joblog-vbeln = fp_gv_ord.
  st_joblog-vkorg = fp_vkorg.
  st_joblog-vtweg = fp_vtweg.
  st_joblog-spart = fp_spart.
  st_joblog-kunnr = fp_gv_cust.
  st_joblog-name1 = fp_name1.
  CLEAR st_fpltc.
  READ TABLE i_fpltc INTO st_fpltc WITH KEY fplnr = fp_fplnr.
*                                            fpltr = fp_fpltr  "-<HIPATEL> <INC0229621> <ED1K909840>
*                                            BINARY SEARCH.    "-<HIPATEL> <INC0229621> <ED1K909840>
  IF sy-subrc = 0.
    st_joblog-afdat = st_fpltc-audat.
  ENDIF.
*BOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
*  st_joblog-audat = fp_audat.
*Get Order document date
  CLEAR st_vbak.
  READ TABLE i_vbak INTO st_vbak WITH KEY vbeln = fp_gv_ord
                                          BINARY SEARCH.
  IF sy-subrc = 0.
    st_joblog-audat = st_vbak-audat.
  ENDIF.
*EOC by <HIPATEL> <INC0229621> <ED1K909840> <03/20/2019>
  st_joblog-netwr = fp_netwr.
  st_joblog-waerk = fp_ccwae.
  st_joblog-mstyp = fp_mstyp.
  st_joblog-mslog = fp_message.
  APPEND st_joblog TO i_joblog.
  CLEAR st_joblog.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_JOBLOG  text
*----------------------------------------------------------------------*
FORM f_display_message  USING i_joblog   TYPE tt_joblog.
  TYPE-POOLS : slis.

  DATA : li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lst_print  TYPE slis_print_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.

*Sales Doc Number
  CLEAR: lv_val.
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'VBELN'(F01).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Sales Document Number'(H01).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Sales Organization
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'VKORG'(F02).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Sales Organization'(H02).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Distribution Channel
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'VTWEG'(F03).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Distribution Channel'(H03).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Division
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'SPART'(F04).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Division'(H04).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Sold-to party
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'KUNNR'(F08).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Sold-to party'(H08).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Sold-To party name
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'NAME1'(F09).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Sold-To party name'(H09).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Payment cards: Authorization Failed date
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'AFDAT'(F14).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_l      = 'Authorization failed date'(H14).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Document Date (Date Received/Sent)
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'AUDAT'(F10).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Document Date'(H10).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Net Value
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'NETWR'(F11).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Net Value'(H11).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.


*SD Document Currency
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'WAERK'(F12).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Currency'(H12).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

*Status message
  lv_val = lv_val + 1.
  lst_fcat-fieldname      = 'MSLOG'(F13).
  lst_fcat-tabname        = 'I_JOBLOG'(T01).
  lst_fcat-seltext_m      = 'Status message'(H13).
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-060
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
      is_print           = lst_print
    TABLES
      t_outtab           = i_joblog
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    " Nothing to do here
  ENDIF.
*  CLEAR: li_fcat, i_joblog[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_LIST  text
*----------------------------------------------------------------------*
FORM f_populate_list  CHANGING fp_i_list TYPE tt_list.
*Local data declaration
  DATA: lst_list    TYPE vrm_value.

  lst_list-key = c_s.  "'S'.
  lst_list-text = 'Sucess'(062).
  APPEND lst_list TO fp_i_list.
  CLEAR lst_list.

  lst_list-key = c_e.  "'E'.
  lst_list-text = 'Error'(063).
  APPEND lst_list TO fp_i_list.
  CLEAR lst_list.

  lst_list-key = c_sign_incld.  "'I'.
  lst_list-text = 'Sucess & Error'(064).
  APPEND lst_list TO fp_i_list.
  CLEAR lst_list.

* Add Values to Dropdown list
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_DDWN1'
      values          = fp_i_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_JOBLOG  text
*----------------------------------------------------------------------*
FORM f_send_log  USING p_s_mailid
                       p_i_joblog TYPE tt_joblog.

  DATA: lv_netwr  TYPE char12,
        li_lines  TYPE idmx_di_t_tline,          "Table for read text
        lst_lines TYPE tline.                    "Workarea for line

  DATA: lv_xls_string TYPE string,
        lv_xls_data   TYPE string.

* Data Declarations
  DATA: lst_mailtxt TYPE soli,                     "SAPoffice: line, length 255
        li_mailtxt  TYPE bcsy_text.                "Table for body, " SAPoffice: line, length 255

  DATA li_binary_content TYPE solix_tab.
  DATA lv_file_size      TYPE so_obj_len.

  CONSTANTS: lc_err_email_txt TYPE tdobname VALUE 'ZQTC_CCP_FAIL_ERRLOG',
             lc_file_name     TYPE tdobname VALUE 'CC_PAYMENT_LOG_',
             lc_en            TYPE thead-tdspras   VALUE 'EN'.  "+<HIPATEL> <INC0229621> <ED1K909840>



*Error Log conver to String
  CLEAR: lv_xls_string, lv_xls_data.
  LOOP AT p_i_joblog INTO DATA(lst_joblog).
    lv_netwr = lst_joblog-netwr.
    IF sy-tabix EQ 1.
      CONCATENATE text-h01
                      text-h02
                      text-h03
                      text-h04
                      text-h08
                      text-h09
                      text-h14
                      text-h10
                      text-h11
                      text-h12
                      text-h13
         INTO lv_xls_string SEPARATED BY cl_bcs_convert=>gc_tab.

      CONCATENATE lv_xls_string
                  cl_bcs_convert=>gc_crlf
             INTO lv_xls_string.
    ENDIF.
    CLEAR lv_xls_data.
    CONCATENATE lst_joblog-vbeln
        lst_joblog-vkorg
        lst_joblog-vtweg
        lst_joblog-spart
        lst_joblog-kunnr
        lst_joblog-name1
        lst_joblog-afdat
        lst_joblog-audat
        lv_netwr
        lst_joblog-waerk
*            lst_joblog-mstyp
        lst_joblog-mslog
   INTO lv_xls_data SEPARATED BY cl_bcs_convert=>gc_tab.
    CONCATENATE lv_xls_data
            cl_bcs_convert=>gc_crlf
       INTO lv_xls_data.
    IF lv_xls_string IS INITIAL.
      lv_xls_string = lv_xls_data.
    ELSE.
      CONCATENATE lv_xls_string lv_xls_data INTO lv_xls_string.
    ENDIF.
  ENDLOOP.


* --------------------------------------------------------------
* convert the text string into UTF-16LE binary data including
* byte-order-mark. Mircosoft Excel prefers these settings
* all this is done by new class cl_bcs_convert (see note 1151257)
  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string   = lv_xls_string  "xls_file     "lv_string
          iv_codepage = '4103'  "suitable for MS Excel, leave empty
          iv_add_bom  = 'X'     "for other doc types
        IMPORTING
          et_solix  = li_binary_content
          ev_size   = lv_file_size ).
    CATCH cx_bcs.
      MESSAGE e445(so).
  ENDTRY.



*Read Email Body
  CLEAR: li_lines[].
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = 'ST'
      language                = lc_en    "wa_kna1-spras "+<HIPATEL> <INC0229621> <ED1K909840>
      name                    = lc_err_email_txt
      object                  = 'TEXT'
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7.

* Add Mail Body Contents
  CLEAR: li_mailtxt[].
  LOOP AT li_lines INTO lst_lines.
    lst_mailtxt = lst_lines-tdline.       "Email body message
    APPEND lst_mailtxt TO li_mailtxt.     "Internal table of mail content
    CLEAR lst_mailtxt.
  ENDLOOP.



*Prepare Mail Object
  DATA:  lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL.
  CLASS cl_bcs DEFINITION LOAD.

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Message body and subject
  DATA: lr_document TYPE REF TO cl_document_bcs VALUE IS INITIAL. "document object

  TRY.
*Create Email document
      lr_document = cl_document_bcs=>create_document( "create document
                                     i_type = 'RAW'  "'TXT'                      "Type of document HTM, TXT etc
                                     i_text =  li_mailtxt                        "email body internal table
                                     i_subject = text-065 ). "'SnapPay Credit Card Payment Failure Log'(065) ).
*Exception handling not required
    CATCH cx_document_bcs.
*Exception handling not required
    CATCH cx_send_req_bcs.
  ENDTRY.

  TRY.
* Pass the document to send request
      lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs.
  ENDTRY.


  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL,
        lv_attsubject   TYPE sood-objdes.

**Add attachment name
  CLEAR lv_attsubject .
  CONCATENATE lc_file_name sy-datum INTO lv_attsubject.

* Create Attachment
  TRY.
      lr_document->add_attachment( EXPORTING
                                   i_attachment_type = 'CSV' "'XLS' "lc_txt
                                   i_attachment_subject = lv_attsubject
                                   i_attachment_size    = lv_file_size
                                   i_att_content_hex    = li_binary_content ).  "li_binary_email ).
    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

*Set Sender
  DATA: lr_sender  TYPE REF TO if_sender_bcs VALUE IS INITIAL.

  TRY.
      lr_sender = cl_sapuser_bcs=>create( sy-uname ). "sender is the logged in user
* Set sender to send request
      lr_send_request->set_sender(
            EXPORTING
                i_sender = lr_sender ).
    CATCH cx_address_bcs.
    CATCH cx_send_req_bcs.
****Catch exception here
  ENDTRY.

**Set recipient
  DATA: lr_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL.
  DATA: lv_times     TYPE i.

**Set recipient
  DESCRIBE TABLE s_email LINES lv_times.
  DO lv_times TIMES.
    READ TABLE s_email INDEX sy-index.
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( s_email-low ). "Here Recipient is email input p_email

        lr_send_request->add_recipient(
            EXPORTING
            i_recipient = lr_recipient
            i_express = abap_true ).
      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.
  ENDDO.

**Set immediate sending
*  TRY.
*      CALL METHOD lr_send_request->set_send_immediately
*        EXPORTING
*          i_send_immediately = abap_true.
***Catch exception here
*    CATCH cx_send_req_bcs.
*  ENDTRY.

  TRY.
** Send email
      lr_send_request->send(
      EXPORTING
      i_with_error_screen = abap_true ).
    CATCH cx_send_req_bcs.
*catch exception here
  ENDTRY.
  COMMIT WORK.
ENDFORM.
*Begin of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
*&---------------------------------------------------------------------*
*&      Form  F_DUPLICATE_NOTIF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_FINAL  text
*      <--P_LV_DUP_NOTIF  text
*----------------------------------------------------------------------*
FORM f_duplicate_notif  USING    fp_wa_final TYPE ty_final
                        CHANGING fp_lv_dup_notif TYPE char01.
  DATA: lv_date     TYPE datum,
        lv_message  TYPE string,               "Message Text
        lv_msg_text TYPE string,               "Message Text
        lv_mstyp    TYPE char01.               "Message Type

  READ TABLE lt_ccp_notif INTO DATA(lst_ccp_notif) WITH KEY vbeln = fp_wa_final-vbeln
                                                            vkorg = fp_wa_final-vkorg
                                                            vtweg = fp_wa_final-vtweg
                                                            spart = fp_wa_final-spart
                                                            fplnr = fp_wa_final-fplnr
                                                            BINARY SEARCH.
  IF sy-subrc = 0.
*Set Flag as True for Duplicate Notification
    fp_lv_dup_notif = abap_true.

*Read date when last sent notification
    CLEAR: lv_date, gv_sndat, gv_rcdat.
    IF lst_ccp_notif-day180 IS NOT INITIAL.
      lv_date = lst_ccp_notif-day180.
    ELSEIF lst_ccp_notif-day150 IS NOT INITIAL.
      gv_sndat = sy-datum - 180.
      gv_rcdat = sy-datum - 210.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day150.
      ENDIF.
    ELSEIF lst_ccp_notif-day120 IS NOT INITIAL.
      gv_sndat = sy-datum - 150.
      gv_rcdat = sy-datum - 179.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day120.
      ENDIF.
    ELSEIF lst_ccp_notif-day90 IS NOT INITIAL.
      gv_sndat = sy-datum - 120.
      gv_rcdat = sy-datum - 149.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day90.
      ENDIF.
    ELSEIF lst_ccp_notif-day60 IS NOT INITIAL.
      gv_sndat = sy-datum - 90.
      gv_rcdat = sy-datum - 119.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day60.
      ENDIF.
    ELSEIF lst_ccp_notif-day30 IS NOT INITIAL.
      gv_sndat = sy-datum - 60.
      gv_rcdat = sy-datum - 89.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day30.
      ENDIF.
    ELSEIF lst_ccp_notif-day1 IS NOT INITIAL.
      gv_sndat = sy-datum - 30.
      gv_rcdat = sy-datum - 59.
      IF lst_ccp_notif-day1 BETWEEN gv_rcdat AND gv_sndat.
        EXIT.
      ELSE.
        lv_date = lst_ccp_notif-day1.
      ENDIF.
    ENDIF.

*Add Message in the log for Duplicate Notification
    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = fp_wa_final-kunnr BINARY SEARCH.
    IF sy-subrc = 0.
*       Name1 required from KNA1 table
    ENDIF.

    CLEAR: lv_message, lv_mstyp.
    CONCATENATE text-066 fp_wa_final-kunnr text-067 INTO lv_msg_text SEPARATED BY space.

    IF sy-batch IS NOT INITIAL.
      MESSAGE i368(00) WITH lv_msg_text lv_date.  "Email already sent to BP XYZ on 01.01.9999
    ENDIF.

    MESSAGE i368(00) WITH lv_msg_text lv_date INTO lv_message.
    lv_mstyp = c_s.
    PERFORM f_create_job_log USING lv_message
                                   fp_wa_final-vbeln fp_wa_final-kunnr
                                   fp_wa_final-vkorg fp_wa_final-vtweg
                                   fp_wa_final-spart wa_kna1-name1
                                   fp_wa_final-fplnr
                                   fp_wa_final-audat fp_wa_final-netwr
                                   fp_wa_final-ccwae lv_mstyp
                          CHANGING i_joblog.
  ENDIF.
ENDFORM.
*End of ADD:INC0229621:HIPATEL:ED1K909993: 10-Apr-2019
*Begin of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_EMAIL_CONTENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_email_content .
* convert the text string into UTF-16LE binary data including
* byte-order-mark. Mircosoft Excel prefers these settings
* all this is done by new class cl_bcs_convert (see note 1151257)
DATA:    BEGIN OF i_nametab OCCURS 10.
           INCLUDE STRUCTURE DNTAB.
DATA:    END OF i_nametab.
  FREE i_nametab.
  CLEAR gv_string.
  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      LANGU          = SY-LANGU
      TABNAME        = '/CDITECH/CRCARD_RPT'
    TABLES
      NAMETAB        = i_nametab
    EXCEPTIONS
      NO_TEXTS_FOUND = 1.
  IF  sy-subrc IS INITIAL
  AND i_nametab IS NOT INITIAL.
    CLEAR gv_string.
    LOOP AT i_nametab
      INTO DATA(lst_nametab).
      IF sy-tabix GE 2.
        CONCATENATE gv_string
         lst_nametab-fieldtext c_tab
         INTO gv_string.
      ENDIF.
      DATA(lv_text) = lst_nametab-fieldtext.
      AT LAST.
        CONCATENATE gv_string
         lv_text c_crlf
         INTO gv_string.
      ENDAT.
    ENDLOOP.
  ENDIF.
  DATA: lv_valdty TYPE char10,
        lv_autwr  TYPE char20,
        lv_autwv  TYPE char20,
        lv_netwr  TYPE char20,
        lv_dmbtr  TYPE char20,
        lv_wrbtr  TYPE char20.
  CLEAR: lv_valdty,
         lv_autwr,
         lv_autwv,
         lv_netwr,
         lv_dmbtr,
         lv_wrbtr.
  LOOP AT it_final
    INTO DATA(lst_final).
    lv_valdty  =  lst_final-valdty.
    lv_autwr   =  lst_final-autwr.
    lv_autwv   =  lst_final-autwv.
    lv_netwr   =  lst_final-netwr.
    lv_dmbtr   =  lst_final-dmbtr.
    lv_wrbtr   =  lst_final-wrbtr.

    CONCATENATE gv_string
                lst_final-fplnr       c_tab
                lst_final-fpltr       c_tab
                lst_final-ccins       c_tab
                lst_final-ccnum       c_tab
                lst_final-audat       c_tab
                lst_final-autim       c_tab
                lst_final-expdat      c_tab
                lv_valdty             c_tab
                lst_final-ccname      c_tab
                lv_autwr              c_tab
                lst_final-ccwae       c_tab
                lst_final-aunum       c_tab
                lst_final-autra       c_tab
                lst_final-merch       c_tab
                lst_final-cctyp       c_tab
                lst_final-ccaua       c_tab
                lst_final-ccall       c_tab
                lst_final-react       c_tab
                lv_autwv              c_tab
                lst_final-rtext       c_tab
                lst_final-vbeln       c_tab
                lst_final-erdat       c_tab
                lst_final-gbstk       c_tab
                lst_final-cmgst       c_tab
                lst_final-status_acc  c_tab
                lst_final-kunnr       c_tab
                lst_final-bukrs_vf    c_tab
                lst_final-inco1       c_tab
                lst_final-inco2       c_tab
                lst_final-payer       c_tab
                lst_final-soldto      c_tab
                lst_final-billto      c_tab
                lst_final-shipto      c_tab
                lst_final-ernam       c_tab
                lst_final-zuonr       c_tab
                lst_final-xblnr       c_tab
                lst_final-xblnr2      c_tab
                lst_final-bukrs       c_tab
                lst_final-belnr       c_tab
                lst_final-gjahr       c_tab
                lst_final-rfzei       c_tab
                lst_final-sgtxt       c_tab
                lst_final-ccbtc       c_tab
                lv_dmbtr              c_tab
                lv_wrbtr              c_tab
                lst_final-fdatu       c_tab
                lst_final-ldatu       c_tab
                lst_final-vblnr       c_tab
                lst_final-gjahr_st    c_tab
                lst_final-xsucc       c_tab
                lst_final-xfail       c_crlf
          INTO  gv_string.
    CLEAR: lv_valdty,
           lv_autwr,
           lv_autwv,
           lv_netwr,
           lv_dmbtr,
           lv_wrbtr.
  ENDLOOP.
  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string   = gv_string
          iv_codepage = '4103'  "suitable for MS Excel, leave empty
          iv_add_bom  = 'X'     "for other doc types
        IMPORTING
          et_solix  = binary_content
          ev_size   = size ).
    CATCH cx_bcs.
      MESSAGE e445(so).
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_OUTOUT_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_outout_email .
  TRY.
      v_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.
  DATA: lst_text   TYPE so_text255,
        li_text    TYPE bcsy_text,
        lv_subject TYPE sood-objdes.
  CLEAR:lst_text.
  CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
               text-069
                '</p>'
               INTO lst_text SEPARATED BY space.
  APPEND lst_text TO li_text.
  CLEAR lst_text.

  lst_text = '<body>'(141).
  APPEND lst_text TO li_text.
  CLEAR lst_text.

  CONCATENATE '<p style="font-family:arial;font-size:90%;">'(142)
               text-068
                '</p>'
               INTO lst_text SEPARATED BY space.
  APPEND lst_text TO li_text.
  CLEAR lst_text.

*---Body of the EMAIL
  CONCATENATE '<font color = "BLACK" style="font-family:arial;font-size:95%;">'(146) 'Thank you,'(080) '<br/>'(147)
  INTO lst_text.
  APPEND lst_text TO li_text.
  CLEAR lst_text.

  lst_text = '</body>'(148).
  APPEND lst_text TO li_text.
  CLEAR lst_text.
  CLEAR lv_subject.
*Email Subject.
  lv_subject = text-074.
*     -------- create and set document with attachment ---------------
*     create document object from internal table with text
  TRY.
      document = cl_document_bcs=>create_document(          "#EC NOTEXT
        i_type    = 'HTM'                                   "#EC NOTEXT
        i_text    = li_text
        i_subject = lv_subject ).
    CATCH cx_document_bcs.
  ENDTRY.
*     add the spread sheet as attachment to document object
  TRY.
      document->add_attachment(                             "#EC NOTEXT
    i_attachment_type    = 'xls'                            "#EC NOTEXT
    i_attachment_subject = lv_subject                       "#EC NOTEXT
    i_attachment_size    = size
    i_att_content_hex    = binary_content ).
    CATCH cx_document_bcs.
  ENDTRY.
*     add document object to send request
  TRY.
      v_send_request->set_document( document ).
    CATCH cx_send_req_bcs.
  ENDTRY.
**Set recipient
  DESCRIBE TABLE s_email LINES DATA(lv_times).
  DO lv_times TIMES.
    READ TABLE s_email INDEX sy-index.
    IF sy-subrc = 0.
      TRY.
          v_recipient = cl_cam_address_bcs=>create_internet_address( s_email-low ). "Here Recipient is email input s_email
*    *Catch exception here
        CATCH cx_address_bcs INTO cx_bcs_exception.
          v_msg_text = cx_bcs_exception->get_text( ).
          MESSAGE v_msg_text TYPE c_i.
      ENDTRY.

      TRY.
          v_send_request->add_recipient(
          EXPORTING
          i_recipient = v_recipient
          i_express = c_x ).
*    *Catch exception here
        CATCH cx_send_req_bcs INTO cx_bcs_exception.
          v_msg_text = cx_bcs_exception->get_text( ).
          MESSAGE v_msg_text TYPE c_i.
      ENDTRY.
    ENDIF."if sy-subrc = 0.
  ENDDO.

  TRY.
      CALL METHOD v_send_request->set_send_immediately
        EXPORTING
          i_send_immediately = abap_false. "here selection screen input p_send
*    *Catch exception here
    CATCH cx_send_req_bcs INTO cx_bcs_exception.
      v_msg_text = cx_bcs_exception->get_text( ).
      MESSAGE v_msg_text TYPE c_i.
  ENDTRY.

  TRY.
*    * Send email
      v_send_request->send(
      EXPORTING
      i_with_error_screen = c_x ).
      COMMIT WORK.
      IF sy-subrc = 0. "mail sent successfully
        WRITE :/ text-016.
        LOOP AT s_email.
          WRITE:/ text-017,
                   s_email-low+0(50).
        ENDLOOP.
      ENDIF.
*    *catch exception here
    CATCH cx_send_req_bcs INTO cx_bcs_exception.
      v_msg_text = cx_bcs_exception->get_text( ).
      MESSAGE v_msg_text TYPE c_i.
  ENDTRY.
ENDFORM.
*End of Change MRAJKUMAR OTCM-53244    ED2K925671 14-FEB-2022
