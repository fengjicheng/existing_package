*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_SD_VIEW_1
* PROGRAM DESCRIPTION:Function module for Mass change
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907652
* REFERENCE NO:  JIRA# 3709
* DEVELOPER: Monalisa Dutta
* DATE:  2017-08-01
* DESCRIPTION: addition of new partner function in header and checking
* vendor for the new partner function
*------------------------------------------------------------------- *
* REVISION NO: ED2K909642
* REFERENCE NO: ERP-5360
* DEVELOPER: Pavan Bandlapalli
* DATE:  2017-11-29
* DESCRIPTION: When duplicate items are selected for cancellation its
*              not updating the cancellation details. Fix has been made
*              to update correctly the cancellation details. Duplicate
*              items are shown in the output if the billing documents
*              are different.
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          :  11/03/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45'
*                ***Pop-up Screen Tittle change ***
*------------------------------------------------------------------- *
* REVISION NO   : ED2K924394
* REFERENCE NO  : OTCM-22844/E099/E342
* DEVELOPER     : NPALLA
* DATE          : 2021-08-24
* DESCRIPTION   : Fix made to update the Mass Cancellation of Orders
*                 functionality when updating from transaction VA05.
*------------------------------------------------------------------- *
*----------------------------------------------------------------------*
***INCLUDE LZQTC_SD_VIEWF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SET_STATUS
*&---------------------------------------------------------------------*
*       Setting PF status fordifferent dialogue screen
*----------------------------------------------------------------------*
*      -->FP_SY_DYNNR  Screen number
*----------------------------------------------------------------------*
FORM f_set_status  USING    fp_sy_dynnr TYPE sy-dynnr. " ABAP System Field: Current Dynpro Number
  CONSTANTS: lc_prot      TYPE char20 VALUE 'ZPROT',         " status
             lc_mass      TYPE char20 VALUE 'ZMASS',         " Mass change status
             lc_po_text   TYPE char20 VALUE 'ZPO_TEXT',      " tittle text
             lc_po_chan   TYPE char20 VALUE 'ZPO_CHAN',      " tittle text Po change
             lc_partner   TYPE char20 VALUE 'ZPO_PARTNER',   " tittle text Partner
             lc_condition TYPE char20 VALUE 'ZPO_CONDITION', " tittle text condition
             lc_promocode TYPE char20 VALUE 'ZPO_PROMOCODE', " tittle text promo code
             lc_po_cancel TYPE char20 VALUE 'ZPO_CANCEL',    " tittle text Cancel Order
             lc_po_part   TYPE char20 VALUE 'ZPO_PO_PART',   " Po_part of type CHAR20
*            Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
             lc_po_licgrp TYPE char20 VALUE 'ZPO_LIC_GRP',  " Po_licgrp of type CHAR20
             lc_po_memcat TYPE char20 VALUE 'ZPO_MEM_CAT',  " Po_memcat of type CHAR20
             lc_po_bilblk TYPE char20 VALUE 'ZPO_BILL_BLK', " Po_bilblk of type CHAR20
             lc_po_dlvblk TYPE char20 VALUE 'ZPO_DLV_BLK',  " Po_dlvblk of type CHAR20
*            End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
             lc_sales_blk TYPE char20 VALUE 'ZSALES_BLK'. "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999  Billing Date Button

  CASE fp_sy_dynnr.
    WHEN c_9002.
      SET PF-STATUS lc_prot. "'ZPROT'.
    WHEN OTHERS.
      SET PF-STATUS lc_mass. "'ZMASS'.
      CASE sy-dynnr.
        WHEN c_9001.
          SET TITLEBAR lc_po_chan. "'ZPO_CHAN'.
        WHEN c_9003.
          SET TITLEBAR lc_po_text. " 'ZPO_TEXT'          .
        WHEN
          c_9004.
          SET TITLEBAR lc_partner. "'ZPO_PARTNER'.
        WHEN
          c_9005.
          SET TITLEBAR lc_condition. "'ZPO_CONDITION'.
        WHEN c_9007.
          SET TITLEBAR lc_promocode. "'ZPO_PROMOCODE'.
        WHEN c_9008.

          SET TITLEBAR lc_po_cancel.
        WHEN c_9009.
          SET TITLEBAR lc_po_part.
*       Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
        WHEN c_9010.
          SET TITLEBAR lc_po_bilblk.
        WHEN c_9011.
          SET TITLEBAR lc_po_dlvblk.
        WHEN c_9012.
          SET TITLEBAR lc_po_memcat.
        WHEN c_9013.
          SET TITLEBAR lc_po_licgrp.
*      End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342  ED2K919999 Billing Date Button
        WHEN c_9014.
          SET TITLEBAR lc_sales_blk.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342  ED2K919999 Billing Date Button
      ENDCASE.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXIT_COMMAND
*&---------------------------------------------------------------------*
*       Clearing the reference variables
*----------------------------------------------------------------------*
FORM exit_command .
  CASE sy-dynnr.
    WHEN c_9004.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_grid IS NOT INITIAL.
        CALL METHOD r_grid->free.
        CLEAR r_grid.
      ENDIF. " IF r_grid IS NOT INITIAL
      IF r_cont_cust IS NOT INITIAL.

        CALL METHOD r_cont_cust->free.

      ENDIF. " IF r_cont_cust IS NOT INITIAL
      IF r_docking IS BOUND.
        r_docking->free(  ).

      ENDIF. " IF r_docking IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR: r_grid,
             r_cont_cust,
             r_docking.

    WHEN c_9007.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_promo_grid IS BOUND.
        CALL METHOD r_promo_grid->free.
      ENDIF. " IF r_promo_grid IS BOUND
      IF r_cont_promo IS BOUND.
        CALL METHOD r_cont_promo->free.
      ENDIF. " IF r_cont_promo IS BOUND
      IF r_promo_docking IS BOUND.
        CALL METHOD r_promo_docking->free.
      ENDIF. " IF r_promo_docking IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR: r_promo_grid,
             r_cont_promo,
             r_promo_docking.

    WHEN c_9008.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_can_grid IS BOUND.
        CALL METHOD r_can_grid->free.
      ENDIF. " IF r_can_grid IS BOUND
      IF r_cont_cancel IS BOUND.
        CALL METHOD r_cont_cancel->free.
      ENDIF. " IF r_cont_cancel IS BOUND
      IF r_docking_can IS BOUND.
        CALL METHOD r_docking_can->free.
      ENDIF. " IF r_docking_can IS BOUND
      CLEAR: r_can_grid,
             r_cont_cancel,
              r_docking_can.
      CALL METHOD cl_gui_cfw=>flush.
    WHEN c_9005.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_cond_grid IS BOUND.
        CALL METHOD r_cond_grid->free.
      ENDIF. " IF r_cond_grid IS BOUND
      IF r_cont_cust IS  BOUND.
        CALL METHOD r_cont_cust->free.
      ENDIF. " IF r_cont_cust IS BOUND

      IF r_docking_condition IS BOUND.
        CALL METHOD r_docking_condition->free.

      ENDIF. " IF r_docking_condition IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR:  r_cond_grid,
              r_cont_cust,
              r_docking_condition.

* Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
    WHEN c_9010.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_bill_grid IS BOUND.
        CALL METHOD r_bill_grid->free.
      ENDIF. " IF r_bill_grid IS BOUND
      IF r_bill_blk IS BOUND.
        CALL METHOD r_bill_blk->free.
      ENDIF. " IF r_bill_blk IS BOUND
      IF r_docking_bill IS BOUND.
        CALL METHOD r_docking_bill->free.
      ENDIF. " IF r_docking_bill IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR : r_bill_grid,
              r_bill_blk,
              r_docking_bill.

    WHEN c_9011.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_delv_grid IS BOUND.
        CALL METHOD r_delv_grid->free.
      ENDIF. " IF r_delv_grid IS BOUND
      IF r_delv_blk IS BOUND.
        CALL METHOD r_delv_blk->free.
      ENDIF. " IF r_delv_blk IS BOUND
      IF r_docking_delv IS BOUND.
        CALL METHOD r_docking_delv->free.
      ENDIF. " IF r_docking_delv IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR : r_delv_grid,
              r_delv_blk,
              r_docking_delv.

    WHEN c_9012.
*   to react on oi_custom_events:
      CALL METHOD cl_gui_cfw=>dispatch.
      IF r_cust_grid IS BOUND.
        CALL METHOD r_cust_grid->free.
      ENDIF. " IF r_cust_grid IS BOUND
      IF r_cust_grp IS BOUND.
        CALL METHOD r_cust_grp->free.
      ENDIF. " IF r_cust_grp IS BOUND
      IF r_docking_cust IS BOUND.
        CALL METHOD r_docking_cust->free.
      ENDIF. " IF r_docking_cust IS BOUND
      CALL METHOD cl_gui_cfw=>flush.
      CLEAR : r_cust_grid,
              r_cust_grp,
              r_docking_cust.
    WHEN 9013.
      CLEAR v_licn_grp.
* End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
    WHEN OTHERS.

  ENDCASE.
  CASE sy-ucomm.
    WHEN c_abbr.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_PO_NUMBER
*&---------------------------------------------------------------------*
*       Update Purchase Order Number
*----------------------------------------------------------------------*
*      -->FP_V_PO_NUMBER  PO Number
*----------------------------------------------------------------------*
FORM f_change_po_number  USING    fp_v_po_number TYPE vbkd-bstkd. " Customer purchase order number

  DATA: lv_h_tabix TYPE sy-tabix,       " Tabix
        lr_vbkd    TYPE REF TO ty_vbkd, " Reference variable
* BOI for Performance by PBANDLAPAL on 08-Jan-2018: ED2K910123
        lst_vbeln  TYPE /spe/vbeln,
        li_vbeln   TYPE /spe/vbeln_t.
* EOI for Performance by PBANDLAPAL on 08-Jan-2018: ED2K910123
  CONSTANTS lc_yes TYPE char1 VALUE 'Y'. " Yes of type CHAR1
  FIELD-SYMBOLS <lst_result> TYPE any.
  CLEAR: v_flag,v_vbeln.
* BOC for Performance by PBANDLAPAL on 08-Jan-2018: ED2K910123
*  CREATE DATA lr_vbkd.
*  LOOP AT i_sel_rows INTO st_sel_row.
*    READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
*    IF sy-subrc = 0.
*      MOVE st_sel_row TO lv_h_tabix.
*      UNASSIGN <v_vbeln>.
*      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF STRUCTURE <lst_result> TO <v_vbeln>.
*      IF <v_vbeln> IS ASSIGNED.
*        IF v_flag IS INITIAL.
*          v_vbeln = <v_vbeln>.
*          UNASSIGN <v_posnr>.
*          ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF STRUCTURE <lst_result> TO <v_posnr>.
*          IF sy-subrc = 0.
*            READ TABLE i_vbkd    REFERENCE INTO lr_vbkd WITH TABLE KEY bstkd COMPONENTS vbeln = <v_vbeln> .
*            IF sy-subrc  = 0 AND lr_vbkd IS BOUND.
*              IF lr_vbkd->bstkd NE fp_v_po_number.
*                v_flag = abap_true.
*                PERFORM f_change_sales_document_header USING  fp_v_po_number
*                                                              v_vbeln.
*              ENDIF. " IF lr_vbkd->bstkd NE fp_v_po_number
*            ENDIF. " IF sy-subrc = 0 AND lr_vbkd IS BOUND
*
*          ENDIF. " IF sy-subrc = 0
*        ELSE. " ELSE -> IF v_flag IS INITIAL
*          IF <v_vbeln> NE v_vbeln.
*            v_vbeln = <v_vbeln>.
*            IF v_save_flag = lc_yes.
*              PERFORM f_save_sales_document.
*              READ TABLE i_vbkd    REFERENCE INTO lr_vbkd WITH TABLE KEY bstkd COMPONENTS vbeln = <v_vbeln> .
*              IF sy-subrc  = 0 AND lr_vbkd IS BOUND.
*                IF lr_vbkd->vbeln NE <v_vbeln>.
*                  UNASSIGN <v_vstkd>.
*
*                  ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-bstkd OF STRUCTURE <lst_result> TO <v_vstkd>.
*                  IF <v_vstkd> IS ASSIGNED.
*                    <v_vstkd> = fp_v_po_number.
*                  ENDIF. " IF <v_vstkd> IS ASSIGNED
*                ENDIF. " IF lr_vbkd->vbeln NE <v_vbeln>
*              ENDIF. " IF sy-subrc = 0 AND lr_vbkd IS BOUND
*            ENDIF. " IF v_save_flag = lc_yes
*            READ TABLE i_vbkd    REFERENCE INTO lr_vbkd WITH TABLE KEY bstkd COMPONENTS vbeln = <v_vbeln> .
*            IF sy-subrc  = 0 AND lr_vbkd IS BOUND.
*              IF lr_vbkd->bstkd NE fp_v_po_number.
*                v_flag = abap_true.
*                PERFORM f_change_sales_document_header USING  fp_v_po_number
*                                                            v_vbeln.
*              ENDIF. " IF lr_vbkd->bstkd NE fp_v_po_number
*
*            ENDIF. " IF sy-subrc = 0 AND lr_vbkd IS BOUND
*          ELSE. " ELSE -> IF <v_vbeln> NE v_vbeln
*            PERFORM f_change_sales_document_header USING  fp_v_po_number
*                                                            v_vbeln.
*          ENDIF. " IF <v_vbeln> NE v_vbeln
*        ENDIF. " IF v_flag IS INITIAL
*      ENDIF. " IF <v_vbeln> IS ASSIGNED
*    ENDIF. " IF sy-subrc = 0
*
*  ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row
  LOOP AT i_sel_rows INTO st_sel_row.
    READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      UNASSIGN <v_vbeln>.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF STRUCTURE <lst_result> TO <v_vbeln>.
      IF <v_vbeln> IS ASSIGNED.
        lst_vbeln-vbeln = <v_vbeln>.
        APPEND lst_vbeln TO li_vbeln.
        CLEAR lst_vbeln.
      ENDIF.
    ENDIF.
  ENDLOOP.
  SORT li_vbeln BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING vbeln.
  LOOP AT li_vbeln INTO lst_vbeln.
    PERFORM f_change_sales_document_header USING  fp_v_po_number
                                                  lst_vbeln-vbeln.
  ENDLOOP.
* EOC for Performance by PBANDLAPAL on 08-Jan-2018: ED2K910123
  IF v_save_flag = lc_yes.
    PERFORM f_save_sales_document.
  ENDIF. " IF v_save_flag = lc_yes
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_PO_TEXT
*&---------------------------------------------------------------------*
*      Change PO Item/ Header text
*----------------------------------------------------------------------*
*      -->FP_V_TDID     Text ID
*      -->FP_V_RADIO_1   Radio Button
*      -->FP_V_RADIO_2  Radio button
*----------------------------------------------------------------------*
FORM f_change_po_text  USING    fp_v_tdid TYPE tdid      " Text ID
                                fp_v_radio_1 TYPE char1  " V_radio_1 of type CHAR1
                                fp_v_radio_2 TYPE char1. " V_radio_2 of type CHAR1
  DATA: li_tdline  TYPE TABLE OF tdline, " Text Line
        li_tline   TYPE TABLE OF tline,  " Internal table
        lv_vbeln   TYPE vbak-vbeln,      " Order
        lv_posnr   TYPE vbap-posnr,      " Item
        lst_tline  TYPE tline,           " Work area
        lst_tdline TYPE tdline,          "  Work area
        lst_tdhead TYPE thead,           " SAPscript: Text Header
        lv_tdname  TYPE tdobname.        " Name
  CONSTANTS: lc_*    TYPE tdformat VALUE '*',    " Tag column
             lc_vbbk TYPE tdobject VALUE 'VBBK', " Texts: Application Object
             lc_vbbp TYPE tdobject VALUE 'VBBP'. " Texts: Application Object
  FIELD-SYMBOLS <lst_result> TYPE any.
  CLEAR:v_flag,v_vbeln.
  CALL METHOD r_text_edit->get_text_as_r3table
    IMPORTING
      table                  = li_tdline " text as R/3 table
    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      error_dp_create        = 3
      potential_data_loss    = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE. " ELSE -> IF sy-subrc <> 0
    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2
        OTHERS            = 3.
    IF sy-subrc <> 0 .
*&     do nothing

    ENDIF. " IF sy-subrc <> 0

    LOOP AT li_tdline INTO lst_tdline.
      lst_tline-tdformat = lc_*.
      lst_tline-tdline = lst_tdline.
      APPEND lst_tline TO li_tline.
      CLEAR lst_tline-tdline.
    ENDLOOP. " LOOP AT li_tdline INTO lst_tdline
  ENDIF. " IF sy-subrc <> 0
  CLEAR lst_tdhead.
  CLEAR:v_flag,v_vbeln.
  LOOP AT i_sel_rows INTO st_sel_row.
    READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      UNASSIGN <v_vbeln>.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF STRUCTURE <lst_result> TO <v_vbeln>.
      IF <v_vbeln> IS ASSIGNED.
        CLEAR lv_vbeln.
        lv_vbeln = <v_vbeln>.
        UNASSIGN <v_posnr>.
        ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF STRUCTURE <lst_result> TO <v_posnr>.
        CLEAR lv_tdname.
        IF fp_v_radio_1 = abap_true.

          MOVE  <v_vbeln> TO lv_tdname.
          lst_tdhead-tdname = lv_tdname.
          lst_tdhead-tdobject  = lc_vbbk. "'VBBK'.
          lst_tdhead-tdid      = fp_v_tdid.
          lst_tdhead-tdspras   = sy-langu.

        ELSEIF fp_v_radio_2 = abap_true.
          MOVE  <v_vbeln> TO lv_tdname.

          IF <v_posnr> IS ASSIGNED.
            CONCATENATE  lv_tdname <v_posnr> INTO lv_tdname.
            lv_posnr = <v_posnr>.
          ENDIF. " IF <v_posnr> IS ASSIGNED
          lst_tdhead-tdname = lv_tdname.
          lst_tdhead-tdobject  = lc_vbbp. " 'VBBP'.
          lst_tdhead-tdid      = fp_v_tdid.
          lst_tdhead-tdspras   = sy-langu.
        ENDIF. " IF fp_v_radio_1 = abap_true
        IF v_flag IS INITIAL.
          v_vbeln = <v_vbeln>.
          v_flag = abap_true.
          PERFORM f_change_long_text  TABLES  li_tline
                                    USING lst_tdhead
                                          lv_posnr
                                          lv_vbeln.
          PERFORM f_save_text    .
        ELSE. " ELSE -> IF v_flag IS INITIAL
          IF <v_vbeln> NE v_vbeln.
            MOVE <v_vbeln> TO v_vbeln.

            PERFORM f_change_long_text  TABLES  li_tline
                                      USING lst_tdhead
                                            lv_posnr
                                            lv_vbeln.
            PERFORM f_save_text    .
          ELSE. " ELSE -> IF <v_vbeln> NE v_vbeln
            IF fp_v_radio_2 = abap_true.
              PERFORM f_change_long_text  TABLES  li_tline
                                        USING lst_tdhead
                                              lv_posnr
                                              lv_vbeln.
              PERFORM f_save_text    .
            ENDIF. " IF fp_v_radio_2 = abap_true


          ENDIF. " IF <v_vbeln> NE v_vbeln
        ENDIF. " IF v_flag IS INITIAL

      ENDIF. " IF <v_vbeln> IS ASSIGNED
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_SALES_DOCUMENT_HEADER
*&---------------------------------------------------------------------*
*      Update Sales Order Purchase Order nunber
*----------------------------------------------------------------------*
*  -->  fp_v_po_numb        New Purchase Order Number
*  -->  fp_v_vbeln          Sales Order Number
*----------------------------------------------------------------------*
FORM f_change_sales_document_header  USING fp_v_po_numb TYPE vbkd-bstkd " Customer purchase order number
                                           fp_v_vbeln TYPE  vbak-vbeln. " Sales Document
  DATA:
    li_return           TYPE TABLE OF bapiret2,  " Return Parameter
    lv_text             TYPE string,
    lr_return           TYPE REF TO bapiret2,    "  class
    lr_order_header_inx TYPE  REF TO bapisdhd1x, "  class
    lr_order_header_in  TYPE REF TO bapisdhd1.   "  class
  CONSTANTS: lc_yes TYPE char1 VALUE 'Y', " Yes of type CHAR1
             lc_no  TYPE char1 VALUE 'N'. " No of type CHAR1
  CREATE DATA: lr_order_header_in,
               lr_order_header_inx.
  lr_order_header_in->purch_no_c = fp_v_po_numb.
  lr_order_header_inx->updateflag = c_update.
  lr_order_header_inx->purch_no_c = abap_true.
  CLEAR v_save_flag.
  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument     = fp_v_vbeln
      order_header_in   = lr_order_header_in->*
      order_header_inx  = lr_order_header_inx->*
    TABLES
      return            = li_return
    EXCEPTIONS
      incov_not_in_item = 1
      OTHERS            = 2.

  IF sy-subrc = 0.
    v_save_flag = lc_yes.

    CLEAR lv_text.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0.

      MESSAGE s072(zqtc_r2) WITH v_po_number v_vbeln INTO lv_text. " PO Number & added sucesfully to Order: &
      IF lv_text IS NOT INITIAL.
        MOVE sy-msgid TO lr_return->id.
        MOVE sy-msgno TO lr_return->number.
        MOVE sy-msgty TO lr_return->type.
        MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
        MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
        MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
        MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        PERFORM f_populate_message USING fp_v_vbeln
                                         000000
                                         lr_return
                                   CHANGING  i_xvbfs
                                             i_messages.
      ENDIF. " IF lv_text IS NOT INITIAL

    ENDIF. " IF sy-subrc = 0

  ELSE. " ELSE -> IF sy-subrc = 0

    v_save_flag = lc_no.
    LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                         OR type = c_abend. " Or of type


      PERFORM f_populate_message USING fp_v_vbeln
                                       000000
                                       lr_return
                                 CHANGING  i_xvbfs
                                           i_messages.
    ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
*& If error occurs then roll back any change and refresh the buffer
    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANG_CONDITION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->fp_i_item  : Item details
*      <--fp_i_messages  : Messages
*      <---fp_i_vbfs  " VBFS
*----------------------------------------------------------------------*
FORM f_chang_condition  USING   fp_i_item TYPE   tt_t_item
                                CHANGING fp_i_messages TYPE tdt_sdoc_msg
                                         fp_i_vbfs     TYPE tt_t_vbfs.



  DATA : lst_headerx      TYPE bapisdhd1x,                 " Checkbox Fields for Sales and Distribution Document Header
         li_konv          TYPE tt_t_konv,                  " condition table
         li_vbak          TYPE tt_vbak ,                   " Sales Order type
         li_t683s         TYPE tt_t683s,                   " Internal table for Pricing Procedure: Data
         lr_t683s         TYPE REF TO ty_t683s,            " Pricing Procedure: Data
         lr_vbak          TYPE REF TO ty_vbak,             " Ref Variaable
         lr_konv          TYPE REF TO ty_konv,             " Refernce varaile for konv
         lr_item          TYPE REF TO ty_item,             " Reference variable for item
         li_return        TYPE TABLE OF bapiret2,          " internal table  return
         lr_return        TYPE  REF TO bapiret2,           "  class
         lr_t685a         TYPE REF TO ty_t685a,            " Condition type
         li_condition     TYPE STANDARD TABLE OF bapicond, " Communication Fields for Maintaining Conditions in the Order
         lr_condition     TYPE REF TO bapicond,            " reference bariable
         li_conditionx    TYPE STANDARD TABLE
                            OF bapicondx,                  " Communication Fields for Maintaining Conditions in the Order
         lr_conditionx    TYPE REF TO bapicondx,           "  class
         lst_logic_switch TYPE bapisdls.                   " SD Checkbox for the Logic Switch
  CONSTANTS lc_null TYPE vbap-posnr VALUE '000000'. " Sales Document Item
  CLEAR:v_flag,v_vbeln.
  CLEAR:v_flag,v_vbeln.
  CREATE DATA: lr_condition,
               lr_conditionx.
  CREATE DATA: lr_vbak,
               lr_konv.
  IF fp_i_item IS NOT INITIAL .
    DELETE ADJACENT DUPLICATES FROM fp_i_item COMPARING ALL FIELDS.
    SELECT  vbeln " Sales Order
            knumv " Number of the document condition
            kalsm " Sales and Distribution: Pricing Procedure in Pricing
      FROM vbak   " sales Order table
      INTO TABLE li_vbak
      FOR ALL ENTRIES IN fp_i_item
      WHERE
      vbeln = fp_i_item-vblen.
    IF sy-subrc = 0.
*& Fetch pricing procedure
      SELECT  kvewe " Usage of the condition table
              kappl " Application
              kalsm " Procedure (Pricing, Output Control, Acct. Det., Costing,...)
              stunr " Step number
              zaehk " Condition counter
              kschl " Condition Type
        FROM t683s  " Pricing Procedure: Data
        INTO TABLE li_t683s
        FOR ALL ENTRIES IN li_vbak
        WHERE
        kalsm = li_vbak-kalsm.
      IF sy-subrc = 0.
        SELECT  knumv " Number of the document condition
                kposn " Condition item number
                stunr " Step number
                zaehk " consition Counter
                kappl " Application
                kschl " Condition type
                kdatu " Condition pricing date
                krech " Condition type
                kbetr " Price
                waers " currency
          FROM konv   " Conditions (Transaction Data)
          INTO TABLE li_konv
          FOR ALL ENTRIES IN li_vbak
          WHERE
          knumv = li_vbak-knumv.
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0


  ENDIF. " IF fp_i_item IS NOT INITIAL


*  i_item_final[] = fp_i_item[].
  LOOP AT fp_i_item  REFERENCE INTO lr_item.
    READ TABLE i_item_final INTO DATA(lst_item_final) INDEX 1.
    IF sy-subrc EQ 0.
      DATA(lv_kschl) = lst_item_final-kschl+0(4).
      DATA(lv_price) = lst_item_final-price.
    ENDIF. " IF sy-subrc EQ 0
    v_vbeln = lr_item->vblen.
    ASSIGN v_vbeln TO <v_vbeln>.
    ASSIGN lr_item->posnr TO <v_posnr>.
    IF <v_posnr> IS ASSIGNED.
      READ TABLE li_vbak REFERENCE INTO lr_vbak WITH TABLE KEY   vbeln COMPONENTS vbeln = lr_item->vblen.
      IF sy-subrc = 0.
        READ TABLE li_konv REFERENCE INTO lr_konv WITH TABLE KEY cond_key
        COMPONENTS knumv = lr_vbak->knumv
                   kposn = lr_item->posnr
                   kschl = lv_kschl.
        IF sy-subrc = 0.
          READ TABLE li_t683s REFERENCE INTO lr_t683s WITH TABLE KEY kalsm COMPONENTS
                                                                           kalsm = lr_vbak->kalsm
                                                                           kschl = lr_konv->kschl.
          IF sy-subrc = 0.
            MOVE:   c_update TO lr_conditionx->updateflag,
            lr_t683s->stunr  TO lr_conditionx->cond_st_no ,
            lr_t683s->stunr  TO lr_condition->cond_st_no,
            lr_item->posnr   TO lr_condition->itm_number,
            lr_item->posnr   TO lr_conditionx->itm_number,
            lr_konv->zaehk   TO lr_condition->cond_count,
            lr_konv->zaehk   TO lr_conditionx->cond_count.
          ENDIF. " IF sy-subrc = 0

        ELSE. " ELSE -> IF sy-subrc = 0
          MOVE            c_i TO lr_conditionx->updateflag.
        ENDIF. " IF sy-subrc = 0
        lst_headerx-updateflag = c_update.
        MOVE:lr_item->posnr TO lr_condition->itm_number,
*        lr_item->kschl+0(4) TO lr_condition->cond_type,
        lv_kschl TO lr_condition->cond_type,
*        lr_item->price TO lr_condition->cond_value.
        lv_price TO lr_condition->cond_value.
        READ TABLE i_t685a  REFERENCE INTO lr_t685a WITH TABLE KEY kschl COMPONENTS kschl = lv_kschl. "lr_item->kschl+0(4).
        IF sy-subrc = 0 .
*& check if the condition  is percentage or amount
          IF lr_t685a->krech <> c_a AND
             lr_t685a->krech <> c_h AND
             lr_t685a->krech <> c_i.
            MOVE  lr_item->waerk TO lr_condition->currency.
          ENDIF. " IF lr_t685a->krech <> c_a AND
*& We also need to check for header condition
          IF lr_t685a->kkopf EQ abap_true.
            lr_condition->itm_number = lc_null.

          ENDIF. " IF lr_t685a->kkopf EQ abap_true
        ENDIF. " IF sy-subrc = 0
        APPEND lr_condition->* TO li_condition.
        CLEAR lr_condition->*.
        MOVE:
        lr_item->posnr TO lr_conditionx->itm_number.

*        MOVE lv_kschl lr_item->kschl+0(4) TO lr_conditionx->cond_type.
        MOVE lv_kschl TO lr_conditionx->cond_type.

        MOVE :abap_true TO lr_conditionx->cond_value.
        READ TABLE i_t685a  REFERENCE INTO lr_t685a WITH TABLE KEY kschl COMPONENTS kschl = lv_kschl. "lr_item->kschl+0(4).
        IF sy-subrc = 0 .
          IF lr_t685a->krech <> c_a AND
             lr_t685a->krech <> c_h AND
             lr_t685a->krech <> c_i.
            MOVE      abap_true TO lr_conditionx->currency.
          ENDIF. " IF lr_t685a->krech <> c_a AND
*& We also need to check for header condition
          IF lr_t685a->kkopf EQ abap_true.
            lr_conditionx->itm_number = lc_null.

          ENDIF. " IF lr_t685a->kkopf EQ abap_true
        ENDIF. " IF sy-subrc = 0


        APPEND lr_conditionx->* TO li_conditionx.
        CLEAR lr_conditionx->*.
        lst_logic_switch-cond_handl = abap_true.
      ENDIF. " IF sy-subrc = 0


    ENDIF. " IF <v_posnr> IS ASSIGNED
    AT END OF vblen.
      IF li_condition[] IS NOT INITIAL .
        DELETE ADJACENT DUPLICATES FROM li_condition COMPARING itm_number.
        CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
          EXPORTING
            salesdocument    = lr_item->vblen
            order_header_inx = lst_headerx
            logic_switch     = lst_logic_switch
          TABLES
            return           = li_return
            conditions_in    = li_condition
            conditions_inx   = li_conditionx.
        LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                             OR type = c_abend. " Or of type

          PERFORM f_populate_message USING lr_item->vblen
                                           lr_item->posnr
                                           lr_return
                                     CHANGING  fp_i_vbfs
                                               fp_i_messages.
        ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
        IF sy-subrc <> 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
          LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_success.
            PERFORM f_populate_message USING lr_item->vblen
                                             lr_item->posnr
                                             lr_return
                                       CHANGING  fp_i_vbfs
                                                 fp_i_messages.

          ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_success
        ELSE. " ELSE -> IF sy-subrc <> 0
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF li_condition[] IS NOT INITIAL
      CLEAR :li_return,
      li_condition,
       li_conditionx.
    ENDAT.



  ENDLOOP. " LOOP AT fp_i_item REFERENCE INTO lr_item

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_LONG_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_TLINE  text
*      -->P_LST_TDHEAD  text
*      -->P_LV_POSNR  text
*      -->P_LV_VBELN  text
*----------------------------------------------------------------------*
FORM f_change_long_text TABLES    fp_li_tline  TYPE bbpt_tline  "tline " SAPscript: Text Lines
                          USING     fp_lst_tdhead TYPE thead    " SAPscript: Text Header
                                    fp_v_posnr TYPE vbap-posnr  " Sales Document Item
                                    fp_v_vbeln TYPE vbak-vbeln. " Sales Document: Header Data.

  DATA: lst_message TYPE tds_sdoc_msg,   " Sales Document Selection: Messages
        lv_text     TYPE string,
        lst_xvbfs   TYPE vbfs,           " Error Log for Collective Processing
        li_tline    TYPE TABLE OF tline. " SAPscript: Text Lines
*& Read Text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = fp_lst_tdhead-tdid
      language                = fp_lst_tdhead-tdspras
      name                    = fp_lst_tdhead-tdname
      object                  = fp_lst_tdhead-tdobject
    TABLES
      lines                   = li_tline
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.

*
*& Do Nothing
  ENDIF. " IF sy-subrc <> 0
  IF li_tline[] IS NOT INITIAL.
*& Delete OLD text
    CALL FUNCTION 'DELETE_TEXT'
      EXPORTING
*       CLIENT          = SY-MANDT
        id              = fp_lst_tdhead-tdid
        language        = fp_lst_tdhead-tdspras
        name            = fp_lst_tdhead-tdname
        object          = fp_lst_tdhead-tdobject
        savemode_direct = 'X'
      EXCEPTIONS
        not_found       = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* No Need to throw message
    ENDIF. " IF sy-subrc <> 0


  ENDIF. " IF li_tline[] IS NOT INITIAL
  CALL FUNCTION 'SAVE_TEXT'
    EXPORTING
      header          = fp_lst_tdhead
      savemode_direct = abap_true
      insert          = abap_true "Note 329360
    TABLES
      lines           = fp_li_tline
    EXCEPTIONS
      OTHERS          = 4.
  IF sy-subrc <> 0.
    "Position
    MOVE fp_v_vbeln TO lst_xvbfs-vbeln. "Belegnummer
    CLEAR lst_xvbfs-posnr.
    IF v_radio_2 = abap_true.
      MOVE fp_v_posnr TO lst_xvbfs-posnr. "Positionsnummer
    ENDIF. " IF v_radio_2 = abap_true

    MOVE sy-msgid      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
    MOVE sy-msgno      TO lst_xvbfs-msgno. "Nachrichtennummer
    MOVE sy-msgty      TO lst_xvbfs-msgty. "Messageart
    MOVE sy-msgv1      TO lst_xvbfs-msgv1. "Messagevariable 1
    MOVE sy-msgv2      TO lst_xvbfs-msgv2. "Messagevariable 2
    MOVE sy-msgv3      TO lst_xvbfs-msgv3. "Messagevariable 3
    MOVE sy-msgv4      TO lst_xvbfs-msgv4. "Messagevariable 4
    APPEND lst_xvbfs   TO i_xvbfs.
    MOVE sy-msgid      TO lst_message-msgid. "Nachrichtenidentifikation
    MOVE sy-msgno      TO lst_message-msgno. "Nachrichtennummer
    MOVE sy-msgty      TO lst_message-msgty. "Messageart
    MOVE sy-msgv1      TO lst_message-msgv1. "Messagevariable 1
    MOVE sy-msgv2      TO lst_message-msgv2. "Messagevariable 2
    MOVE sy-msgv3      TO lst_message-msgv3. "Messagevariable 3
    MOVE sy-msgv4      TO lst_message-msgv4. "Messagevariable 4
    APPEND lst_message TO i_messages.
  ELSE. " ELSE -> IF sy-subrc <> 0
    "Position
    MOVE fp_v_vbeln TO lst_xvbfs-vbeln. "Belegnummer
    CLEAR lst_xvbfs-posnr.
    IF v_radio_2 = abap_true.
      MOVE fp_v_posnr TO lst_xvbfs-posnr. "Positionsnummer

      MESSAGE s073(zqtc_r2) WITH fp_v_vbeln fp_v_posnr INTO lv_text. " Text save for Order:& and Item :&
    ELSE. " ELSE -> IF v_radio_2 = abap_true
      MESSAGE s055(zqtc_r2) WITH fp_v_vbeln INTO lv_text. " Save text sucessfull for Order &
    ENDIF. " IF v_radio_2 = abap_true
    IF lv_text IS NOT INITIAL.
      MOVE sy-msgid        TO lst_message-msgid. "
      MOVE sy-msgno       TO lst_message-msgno. "Nachrichtennummer
      MOVE sy-msgno         TO lst_message-msgty. "Messageart
      MOVE sy-msgv1   TO lst_message-msgv1. "Messagevariable 1
      MOVE sy-msgv2   TO  lst_message-msgv2. "Messagevariable 2
      MOVE sy-msgv3      TO lst_message-msgv3. "Messagevariable 3
      MOVE sy-msgv4      TO lst_message-msgv4. "Messagevariable 4
      APPEND lst_message TO i_messages.
      CLEAR lst_message.
    ENDIF. " IF lv_text IS NOT INITIAL

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_TEXT
*&---------------------------------------------------------------------*
*      Commit text

*----------------------------------------------------------------------*
FORM f_save_text .
  CALL FUNCTION 'COMMIT_TEXT'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROTOCOL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_protocol .
  DATA: lv_variable_size TYPE char2,            "Variable Dynprogröße
        lv_dynpro_max    TYPE char2 VALUE '25'. "Maximale Dynprogröße

  CLEAR lv_variable_size.
* Protokoll wird nur ausgegeben, wenn die Tabelle gefüllt ist
  DESCRIBE TABLE i_xvbfs LINES sy-tfill.
  IF sy-tfill IS INITIAL.
*& Do nothing
  ELSE. " ELSE -> IF sy-tfill IS INITIAL
    IF sy-tfill <= 20.
      lv_variable_size = sy-tfill + 12.
    ELSE. " ELSE -> IF sy-tfill <= 20
      lv_variable_size = lv_dynpro_max.
    ENDIF. " IF sy-tfill <= 20
    CALL SCREEN 9002 STARTING AT 1 8 ENDING AT 106 lv_variable_size.
  ENDIF. " IF sy-tfill IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_LIST_BOX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->fp_v_screen   Screen number
*      -->fp_v_name     Field Name
*----------------------------------------------------------------------*
FORM f_init_list_box  USING   fp_v_screen TYPE sy-dynnr " ABAP System Field: Current Dynpro Number
                              fp_v_name   TYPE vrm_id.

* Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
* Structure declaration for TVLS
  TYPES : BEGIN OF lty_tvls,
            lifsp TYPE lifsp, " Default delivery block
          END OF lty_tvls,

*       Structure declaration for TVFS
          BEGIN OF lty_tvfs,
            faksp TYPE faksp, " Block
          END OF lty_tvfs,

*       Structure declaration for TVKGG
          BEGIN OF lty_tvkgg,
            kdkgr TYPE kdkgr, " Customer Attribute for Condition Groups
          END OF lty_tvkgg.

  DATA : li_tvls  TYPE STANDARD TABLE OF lty_tvls INITIAL SIZE 0,
         li_tvfs  TYPE STANDARD TABLE OF lty_tvfs INITIAL SIZE 0,
         li_tvkgg TYPE STANDARD TABLE OF lty_tvkgg INITIAL SIZE 0.

* End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030

  DATA: st_values       TYPE vrm_value,
        lst_const       TYPE ty_const,
        lc_param1_text  TYPE rvari_vnam  VALUE 'TEXTID',    "tEXT ID
        lc_param1_h     TYPE rvari_vnam  VALUE 'H',         " Header ID
        lc_param1_i     TYPE rvari_vnam  VALUE 'I',         " Item ID
        lc_param1_kunnr TYPE rvari_vnam  VALUE 'KUNNR',     "Order type
        lc_kunnr_hdr    TYPE rvari_vnam  VALUE 'KUNNR_HDR', "Header partner "Added by MODUTTA for JIRA 3709
        lc_devid_e099   TYPE zdevid      VALUE 'E099'.      "Development ID
  CONSTANTS lc_ucomm TYPE sy-ucomm VALUE 'CUSTFUNC6'. " ABAP System Field: PAI-Triggering Function Code
  CLEAR i_list.
* Get data from constant table
  IF i_const[] IS INITIAL.
    SELECT devid                        "Development ID
           param1                       "ABAP: Name of Variant Variable
           param2                       "ABAP: Name of Variant Variable
           srno                         "Current selection number
           sign                         "ABAP: ID: I/E (include/exclude values)
           opti                         "ABAP: Selection option (EQ/BT/CP/...)
           low                          "Lower Value of Selection Condition
           high                         "Upper Value of Selection Condition
           activate                     "Activation indicator for constant
           description                  " Description of constant
           FROM zcaconstant             " Wiley Application Constant Table
           INTO TABLE i_const
           WHERE devid    = lc_devid_e099
           AND   activate = abap_true . "Only active record
    IF sy-subrc  = 0 .
      SORT i_const BY   devid param1 low.

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF i_const[] IS INITIAL
  CASE fp_v_screen.
    WHEN 9003.
      LOOP AT i_const INTO lst_const . " WHERE param1 = lc_param1_kunnr.
        IF lst_const-param1 EQ lc_param1_text AND lst_const-param2 = lc_param1_h
           AND v_radio_1 = abap_true.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_list.
          CLEAR st_values.
        ELSEIF lst_const-param1 EQ lc_param1_text AND lst_const-param2 = lc_param1_i
          AND v_radio_2 = abap_true.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_list.
          CLEAR st_values.
        ELSEIF lst_const-param1 EQ lc_param1_text AND lst_const-param2 = lc_param1_h
          AND sy-ucomm = lc_ucomm. " 'CUSTFUNC6'.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_list.
          CLEAR st_values.
        ENDIF. " IF lst_const-param1 EQ lc_param1_text AND lst_const-param2 = lc_param1_h
      ENDLOOP. " LOOP AT i_const INTO lst_const


    WHEN 9004 OR 9006.
      LOOP AT i_const INTO lst_const .
        IF v_hd_partner IS NOT INITIAL
          AND lst_const-param1 EQ lc_kunnr_hdr.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_list.
        ENDIF. " IF v_hd_partner IS NOT INITIAL
        IF lst_const-param1 EQ lc_param1_kunnr.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_list.
        ELSEIF lst_const-param1 = c_kschl.
          st_values-key = lst_const-low.
          st_values-text = lst_const-description.
          APPEND st_values TO i_cond.
        ENDIF. " IF lst_const-param1 EQ lc_param1_kunnr
      ENDLOOP. " LOOP AT i_const INTO lst_const
      IF NOT i_cond IS INITIAL.
        SELECT  kappl " application
                kschl " Constion tyoe
                krech " Calculation type for condition
                kkopf " Condition applies to header
          FROM t685a  " Conditions: Types: Additional Price Element Data
          INTO TABLE i_t685a
          FOR ALL ENTRIES IN i_cond
          WHERE
          kschl = i_cond-key+0(4).
      ENDIF. " IF NOT i_cond IS INITIAL

* Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030

*   In case of screen 9010(Billing Block)
*    WHEN 9010.
**     Select all the values of delivery block from value table TVLS
*      SELECT faksp " Block
*      FROM tvfs    " Billing: Reasons for Blocking
*      INTO TABLE li_tvfs.
*      IF sy-subrc EQ 0.
*        LOOP AT li_tvfs INTO DATA(lst_tvfs).
*          st_values-key = lst_tvfs-faksp.
*          APPEND st_values TO i_list.
*        ENDLOOP. " LOOP AT li_tvfs INTO DATA(lst_tvfs)
*      ENDIF. " IF sy-subrc EQ 0

*   In case of screen 9011(Delivery Block)
    WHEN 9011.
*     Select all the values of delivery block from value table TVLS
      SELECT lifsp " Default delivery block
      FROM tvls    " Deliveries: Blocking Reasons/Criteria
      INTO TABLE li_tvls.
      IF sy-subrc EQ 0.
        LOOP AT li_tvls INTO DATA(lst_tvls).
          st_values-key = lst_tvls-lifsp.
          APPEND st_values TO i_list.
        ENDLOOP. " LOOP AT li_tvls INTO DATA(lst_tvls)
      ENDIF. " IF sy-subrc EQ 0

*   In case of screen 9012(Cutomer Group)
    WHEN 9012.
*     Select all the values of Customer Group from value table
      SELECT kdkgr " Customer Attribute for Condition Groups
      FROM tvkgg   " Customer Condition Groups (Customer Master)
      INTO TABLE li_tvkgg.
      IF sy-subrc EQ 0.
        LOOP AT li_tvkgg INTO DATA(lst_tvkgg).
          st_values-key = lst_tvkgg-kdkgr.
          APPEND st_values TO i_list.
        ENDLOOP. " LOOP AT li_tvkgg INTO DATA(lst_tvkgg)
      ENDIF. " IF sy-subrc EQ 0
* End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030

    WHEN OTHERS.
  ENDCASE.

  IF fp_v_name IS  NOT INITIAL.
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = fp_v_name
        values = i_list.
  ENDIF. " IF fp_v_name IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_TEXT_EDITOR
*&---------------------------------------------------------------------*
*       Form for Text editor initialization
*----------------------------------------------------------------------*
FORM f_init_text_editor .
  DATA lc_cust_control TYPE  char20 VALUE 'CUST_CONTROL'. " Cust_control of type CHAR20
  IF r_editor_cont IS NOT BOUND.
    CREATE OBJECT r_editor_cont
      EXPORTING
        container_name              = lc_cust_control " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE. " ELSE -> IF sy-subrc <> 0
      CREATE OBJECT r_text_edit
        EXPORTING
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position "WORDWRAP_AT_WINDOWBORDER    " 0: OFF; 1: wrap a window border; 2: wrap at fixed position
          wordwrap_position          = v_line_length                               " position of wordwrap, only makes sense with wordwrap_mode=2
          wordwrap_to_linebreak_mode = cl_gui_textedit=>true                       "FALSE    " eq 1: change wordwrap to linebreak; 0: preserve wordwraps
          parent                     = r_editor_cont                               " Parent Container
        EXCEPTIONS
          error_cntl_create          = 1
          error_cntl_init            = 2
          error_cntl_link            = 3
          error_dp_create            = 4
          gui_type_not_supported     = 5
          OTHERS                     = 6.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF. " IF sy-subrc <> 0

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF r_editor_cont IS NOT BOUND
  IF r_text_edit IS BOUND.
    CALL METHOD r_text_edit->set_toolbar_mode
      EXPORTING
        toolbar_mode           = cl_gui_textedit=>false " visibility of toolbar; eq 0: OFF ; ne 0: ON
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0
    CALL METHOD r_text_edit->set_statusbar_mode
      EXPORTING
        statusbar_mode         = cl_gui_textedit=>false " visibility of statusbar; eq 0: OFF ; ne 0: ON
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF r_text_edit IS BOUND
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CHANGE_SALES_PARTNER_CHN
*&---------------------------------------------------------------------*
*      Change Partner details
*----------------------------------------------------------------------*
*      -->fp_lr_par_fun  : reference Vriable for partner
*      -->fp_li_vbpa     : VBPA table entry
*     <--fp_i_xvps      : VBFS table
*     <--fp_i_message   : Message
*----------------------------------------------------------------------*
FORM change_sales_partner_chn  USING    fp_lr_par_fun   TYPE REF TO ty_partner " Partner class
                                        fp_li_vbpa      TYPE tt_t_vbpa
                                        fp_v_hd_partn   TYPE char1             " V_hd_partn of type CHAR1
                                        fp_v_item_partn TYPE char1             " V_item_partn of type CHAR1
                                CHANGING fp_i_xvps      TYPE  tt_t_vbfs
                                         fp_i_message   TYPE  tdt_sdoc_msg
.

  DATA :
    li_partnerchanges  TYPE TABLE OF bapiparnrc, " Partner changes
    lst_partnerchanges TYPE bapiparnrc,          " Work area
    li_return          TYPE TABLE OF bapiret2,   " BAPI Return table
    lr_return          TYPE REF TO bapiret2,     " reference Varibale
    lr_vbpa            TYPE REF TO ty_vbpa,      " reference variable for vbpa
    lv_part_func       TYPE  parvw,              " Variable for partner function
    lst_header_inx     TYPE bapisdhd1x,          " Checkbox Fields for Sales and Distribution Document Header
    lst_message        TYPE tds_sdoc_msg,        " Sales Document Selection: Messages
    lv_text            TYPE string,              " Text
    lst_xvbfs          TYPE vbfs.                " Error Log for Collective Processing

  CONSTANTS: lc_posnr   TYPE posnr VALUE '000000'. " Item number of the SD document
  CLEAR : li_partnerchanges, lst_partnerchanges.

  READ TABLE i_partner_final INTO DATA(lst_partner_final) INDEX 1.
  IF sy-subrc EQ 0.
    lv_part_func = lst_partner_final-part_fun+0(2).
    DATA(lv_partner) = lst_partner_final-partner.
  ENDIF. " IF sy-subrc EQ 0
*  lv_part_func = fp_lr_par_fun->part_fun+0(2).

  lst_partnerchanges-document = fp_lr_par_fun->vbeln.
  IF fp_v_hd_partn = abap_true.
    lst_partnerchanges-itm_number =  lc_posnr.
  ELSEIF fp_v_item_partn = abap_true.
    lst_partnerchanges-itm_number =  fp_lr_par_fun->posnr.
  ENDIF. " IF fp_v_hd_partn = abap_true



  lst_partnerchanges-updateflag = c_update.

  lst_partnerchanges-partn_role = lv_part_func.
  IF fp_v_item_partn = abap_true.
    READ TABLE fp_li_vbpa REFERENCE INTO lr_vbpa WITH TABLE KEY part_func
                        COMPONENTS                              vbeln = fp_lr_par_fun->vbeln
                                                                posnr = fp_lr_par_fun->posnr
                                                                parvw = lv_part_func.
    IF sy-subrc = 0.
      lst_partnerchanges-p_numb_old = lr_vbpa->kunnr.
    ELSE. " ELSE -> IF sy-subrc = 0
      READ TABLE fp_li_vbpa REFERENCE INTO lr_vbpa WITH TABLE KEY part_func
      COMPONENTS                                                  vbeln = fp_lr_par_fun->vbeln
                                                                  posnr = lc_posnr
                                                                  parvw = lv_part_func.
      IF sy-subrc = 0.
        lst_partnerchanges-p_numb_old = lr_vbpa->kunnr.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF sy-subrc = 0
  ELSEIF fp_v_hd_partn = abap_true.
    READ TABLE fp_li_vbpa REFERENCE INTO lr_vbpa WITH TABLE KEY part_func
    COMPONENTS                                                  vbeln = fp_lr_par_fun->vbeln
                                                                posnr = lc_posnr
                                                                parvw = lv_part_func.
    IF sy-subrc = 0.
      IF lr_vbpa->kunnr IS NOT INITIAL.
        lst_partnerchanges-p_numb_old = lr_vbpa->kunnr.
      ELSEIF lr_vbpa->lifnr IS NOT INITIAL.
        lst_partnerchanges-p_numb_old = lr_vbpa->lifnr.
      ENDIF. " IF lr_vbpa->kunnr IS NOT INITIAL
    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF fp_v_item_partn = abap_true
  CLEAR lv_text.
  IF lst_partnerchanges-p_numb_old IS INITIAL   .
    MESSAGE e047(zqtc_r2) WITH lv_part_func "fp_lr_par_fun->part_fun " Partner Function & Not found in Order & Item &
                              fp_lr_par_fun->vbeln
                              lst_partnerchanges-itm_number INTO lv_text.
    IF lv_text IS NOT INITIAL.
      "Position
      MOVE fp_lr_par_fun->vbeln TO lst_xvbfs-vbeln. "Belegnummer
      CLEAR lst_xvbfs-posnr.

      MOVE lst_partnerchanges-itm_number TO lst_xvbfs-posnr. "Positionsnummer


      MOVE sy-msgid      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
      MOVE sy-msgno      TO lst_xvbfs-msgno. "Nachrichtennummer
      MOVE sy-msgty      TO lst_xvbfs-msgty. "Messageart
      MOVE sy-msgv1      TO lst_xvbfs-msgv1. "Messagevariable 1
      MOVE sy-msgv2      TO lst_xvbfs-msgv2. "Messagevariable 2
      MOVE sy-msgv3      TO lst_xvbfs-msgv3. "Messagevariable 3
      MOVE sy-msgv4      TO lst_xvbfs-msgv4. "Messagevariable 4
      APPEND lst_xvbfs TO fp_i_xvps.
      MOVE sy-msgid      TO lst_message-msgid. "Nachrichtenidentifikation
      MOVE sy-msgno      TO lst_message-msgno. "Nachrichtennummer
      MOVE sy-msgty      TO lst_message-msgty. "Messageart
      MOVE sy-msgv1      TO lst_message-msgv1. "Messagevariable 1
      MOVE sy-msgv2      TO lst_message-msgv2. "Messagevariable 2
      MOVE sy-msgv3      TO lst_message-msgv3. "Messagevariable 3
      MOVE sy-msgv4      TO lst_message-msgv4. "Messagevariable 4
      APPEND lst_message TO fp_i_message.
    ENDIF. " IF lv_text IS NOT INITIAL

  ENDIF. " IF lst_partnerchanges-p_numb_old IS INITIAL

  lst_partnerchanges-p_numb_new = lv_partner. "fp_lr_par_fun->partner.


  APPEND lst_partnerchanges TO li_partnerchanges.
  lst_header_inx-updateflag = c_update.

  IF li_partnerchanges IS NOT INITIAL.
    SORT li_partnerchanges BY document itm_number.
    DELETE ADJACENT DUPLICATES FROM li_partnerchanges COMPARING document itm_number.
  ENDIF. " IF li_partnerchanges IS NOT INITIAL

  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument    = fp_lr_par_fun->vbeln
*order_header_in = s_header_in
      order_header_inx = lst_header_inx
*simulation = p_test
      business_object  = 'BUS2035'
    TABLES
      return           = li_return
*     partners         = t_partners
      partnerchanges   = li_partnerchanges.
*      partneraddresses = li_partneraddresses.

  READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_error.
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0 AND lr_return IS BOUND .
      CLEAR lv_text.
      IF fp_v_hd_partn = abap_true.
        MESSAGE s083(zqtc_r2) WITH   lv_partner " Partner & has been saved for Order & and Item &
                                      fp_lr_par_fun->vbeln
                                      lc_posnr INTO lv_text.
      ELSEIF fp_v_item_partn = abap_true.
        MESSAGE s083(zqtc_r2) WITH   lv_partner " Partner & has been saved for Order & and Item &
                                      fp_lr_par_fun->vbeln
                                      lst_partnerchanges-itm_number INTO lv_text.
*                                      fp_lr_par_fun->posnr INTO lv_text.
      ENDIF. " IF fp_v_hd_partn = abap_true

      IF lv_text IS NOT INITIAL.
        "Position
        MOVE fp_lr_par_fun->vbeln TO lst_xvbfs-vbeln. "Belegnummer
        CLEAR lst_xvbfs-posnr.

        MOVE lst_partnerchanges-itm_number TO lst_xvbfs-posnr. "Positionsnummer


        MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
        MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
        MOVE sy-msgty      TO lr_return->type. "Messageart
        MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
        MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
        MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
        MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        PERFORM f_populate_message USING fp_lr_par_fun->vbeln
                                        lst_partnerchanges-itm_number " fp_lr_par_fun->posnr
                                         lr_return
                                   CHANGING  fp_i_xvps
                                             fp_i_message.
      ENDIF. " IF lv_text IS NOT INITIAL



    ENDIF. " IF sy-subrc = 0 AND lr_return IS BOUND
  ELSE. " ELSE -> IF sy-subrc <> 0
    PERFORM f_populate_message USING fp_lr_par_fun->vbeln
                                     lst_partnerchanges-itm_number " fp_lr_par_fun->posnr
                                     lr_return
                               CHANGING  fp_i_xvps
                                         fp_i_message.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Populate Partner details for ALV display
*----------------------------------------------------------------------*
*      -->P_I_PARTNER  Internal table for Partner
*----------------------------------------------------------------------*
FORM f_display_alv  USING fp_v_hd_partner TYPE char1 " Display_alv using fp_v_ of type CHAR1
                    CHANGING   fp_i_partner TYPE tt_t_partner .

  PERFORM f_fetch_data_partner USING i_sel_rows
                                      <i_result>
                              CHANGING fp_i_partner           .
  IF fp_v_hd_partner = abap_true.
    DELETE ADJACENT DUPLICATES FROM fp_i_partner COMPARING vbeln.
  ENDIF. " IF fp_v_hd_partner = abap_true

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_SEL_ROWS  : selection rows
*      -->FP_I_RESULT    : result table
*----------------------------------------------------------------------*
FORM f_fetch_data_partner  USING    fp_i_sel_rows TYPE  salv_t_row
                                    fp_i_result TYPE STANDARD TABLE
                           CHANGING fp_i_partn  TYPE tt_t_partner.
  DATA lr_partner TYPE REF TO ty_partner. " Partner class

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_posnr>   TYPE vbap-posnr, " Sales Document Item
                  <lst_result> TYPE any.

  CREATE DATA lr_partner.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_partner->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
      IF <lv_posnr> IS ASSIGNED.
        lr_partner->posnr = <lv_posnr>.
        UNASSIGN <lv_posnr>.
      ENDIF. " IF <lv_posnr> IS ASSIGNED
      APPEND lr_partner->* TO fp_i_partn.
      CLEAR lr_partner->*.

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*      Build fieldcatalogue
*----------------------------------------------------------------------*
*      ---> fp_dynnr   Screen number
*      <--fP_I_FIELCAT  text
*----------------------------------------------------------------------*
FORM f_build_fieldcat  USING fp_dynnr TYPE sy-dynnr " ABAP System Field: Current Dynpro Number
                    CHANGING fp_i_fielcat TYPE lvc_t_fcat.
  CONSTANTS: lc_vblen    TYPE lvc_fname VALUE 'VBLEN',    "  Constants for Sales Order
             lc_order    TYPE lvc_fname VALUE 'VBELN',    " SALES ORDER
             lc_posnr    TYPE lvc_fname VALUE 'POSNR',    " Constants for Item
             lc_part_fun TYPE lvc_fname VALUE 'PART_FUN', " Constants for Partner function
             lc_promo_o  TYPE lvc_fname VALUE 'PROMO_O',  " Old Promo code
             lc_promo_n  TYPE lvc_fname VALUE 'PROMO_N',  " new promo code
             lc_kschl    TYPE lvc_fname VALUE 'KSCHL',    " new promo code
             lc_knuma    TYPE lvc_fname VALUE 'KNUMA',    " Promo code
             lc_kona     TYPE lvc_rtname VALUE 'KONA',    " agreemen table
             lc_kunnr    TYPE lvc_fname VALUE 'KUNNR',    " customer
             lc_kna1     TYPE lvc_rtname VALUE 'KNA1',    " customer table
             lc_partner  TYPE lvc_fname VALUE 'PARTNER',  " Partner
*            Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
             lc_lifsk    TYPE lvc_fname VALUE 'LIFSK',    " ALV control: Field name of internal table field
             lc_faksk    TYPE lvc_fname VALUE 'FAKSK',    " ALV control: Field name of internal table field
             lc_kdkg2    TYPE lvc_fname VALUE 'KDKG2',    " ALV control: Field name of internal table field
             lc_zzlicgrp TYPE lvc_fname VALUE 'ZZLICGRP'. " ALV control: Field name of internal table field
*            End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030

  CASE fp_dynnr.
    WHEN c_9004 .
*      PERFORM f_build_field_cat   USING lc_order
*                                     c_i_partner
*                                     1
*                                    'Order No'(t01)
*                                    10
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat .
*      IF v_itm_partner = abap_true.
*        PERFORM f_build_field_cat   USING lc_posnr
*                                     c_i_partner
*                                       2
*                                      'Order Item'(t03)
*                                      6
*                                      space
*                                      space
*                                      space
*                                     CHANGING fp_i_fielcat  .
*      ENDIF.

      PERFORM f_build_field_cat   USING lc_part_fun
                                  c_i_partner
                                     1
                                    'Partner function'(t04)
                                    30
                                    abap_true
                                    space
                                    space
                                   CHANGING fp_i_fielcat  .
      PERFORM f_build_field_cat   USING lc_partner
                                  c_i_partner
                                     2
                                    'New Partner no'(t05)
                                    15
                                    abap_true
                                     space "lc_kunnr
                                     space "lc_kna1
                                   CHANGING fp_i_fielcat  .
    WHEN c_9007.
*      PERFORM f_build_field_cat   USING lc_order "'VBELN'
*                                     c_i_promo
*                                     1
*                                    'Order No'(t01)
*                                    10
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat .
*      PERFORM f_build_field_cat   USING lc_posnr
*                                   c_i_promo
*                                     2
*                                    'Order Item'(t03)
*                                    6
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat  .
*      PERFORM f_build_field_cat   USING lc_promo_o
*                                   c_i_promo
*                                     3
*                                    'Old Promo Code'(p01)
*                                    15
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat  .
      PERFORM f_build_field_cat   USING lc_promo_n
                                  c_i_promo
                                     1
                                    'New Promo Code'(p02)
                                    15
                                    abap_true
                                     lc_knuma
                                     lc_kona
                                   CHANGING fp_i_fielcat  .
    WHEN c_9008.
*      PERFORM f_build_field_cat   USING lc_order
*                                     c_i_cancel
*                                     1
*                                    'Order No'(t01)
*                                    10
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat .
*      PERFORM f_build_field_cat   USING lc_posnr
*                                   c_i_cancel
*                                     2
*                                    'Order Item'(t03)
*                                    6
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat  .
      PERFORM f_build_field_cat   USING c_vkuegru
                                  c_i_cancel
                                     1
                                    'Cancellation Reason'(R01)
                                    40
                                    abap_true
                                    space
                                    space
                                   CHANGING fp_i_fielcat  .
      IF v_appliction =  if_sdoc_select=>co_application_id-va45nn.
        PERFORM f_build_field_cat   USING c_vkuesch
                                    c_i_cancel
                                       2
                                      'Cancellation Procedure'(007)
                                      30
                                      abap_true
                                      space
                                      space
                                     CHANGING fp_i_fielcat  .
        PERFORM f_build_field_cat   USING c_can_date
                                    c_i_cancel
                                       5
                                      'Cancellation Date'(R03)
                                      15
                                      abap_true
                                      c_can_date
                                      c_veda
                                     CHANGING fp_i_fielcat  .
        PERFORM f_build_field_cat   USING c_veindat
                                    c_i_cancel
                                       6
                                  'Receipt of canc'(R04)
                                      15
                                      abap_true
                                      c_veindat
                                      c_veda
                                     CHANGING fp_i_fielcat  .
        PERFORM f_build_field_cat   USING c_vwundat
                                    c_i_cancel
                                       7
                                      'Req.cancellation date'(R05)
                                      18
                                      abap_true
                                      c_vwundat
                                     c_veda
                                     CHANGING fp_i_fielcat  .

      ENDIF. " IF v_appliction = if_sdoc_select=>co_application_id-va45nn
    WHEN c_9005.
*      PERFORM f_build_field_cat:   USING lc_vblen
*                                     c_i_item
*                                     1
*                                    'Order No'(t01)
*                                    10
*                                    space
*                                    space
*                                    space
*                                   CHANGING fp_i_fielcat .
*      IF v_item_cond = abap_true.
*        PERFORM f_build_field_cat      USING lc_posnr
*                                       c_i_item
*                                         2
*                                        'Order Item'(t03)
*                                        6
*                                        space
*                                        space
*                                        space
*                                       CHANGING fp_i_fielcat  .
*      ENDIF.
      PERFORM f_build_field_cat     USING lc_kschl
                                    c_i_item
                1
               'Condition Type'(c02)
               15
               abap_true
               space
               space
              CHANGING fp_i_fielcat.
      PERFORM f_build_field_cat       USING 'PRICE'
                                     c_i_item
                                       2
                                      'Condition Value'(C03)
                                      15
                                      abap_true
                                      space
                                      space
                                     CHANGING fp_i_fielcat  .
    WHEN c_9010.
      PERFORM f_build_field_cat   USING lc_faksk
                                  c_i_faksk
                                     1
                                    'Enter New Billing Block'(T06)
                                    60
                                    abap_true
                                    space
                                    space
                                   CHANGING fp_i_fielcat.

    WHEN c_9011.
      PERFORM f_build_field_cat  USING lc_lifsk
                                       c_i_lifsk
                                       1
                                       'Enter New Delivery Block'(T07)
                                       40
                                       abap_true
                                       space
                                       space
                                 CHANGING fp_i_fielcat.


    WHEN c_9012.
      PERFORM f_build_field_cat   USING lc_kdkg2
                                  c_i_kdkg2
                                     1
                                    'Enter New Customer Group'(T08)
                                    60
                                    abap_true
                                    space
                                    space
                                   CHANGING fp_i_fielcat.

    WHEN c_9013.
      PERFORM f_build_field_cat   USING lc_zzlicgrp
                                  c_i_licgrp
                                     1
                                    'Enter New Licence Group'(T09)
                                    60
                                    abap_true
                                    space
                                    space
                                   CHANGING fp_i_fielcat.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELD_CAT
*&---------------------------------------------------------------------*
*   Building field catalogue
*----------------------------------------------------------------------*
*      -->fp_name   text
*      -->fp_col      text
*      -->fp_text   text
*      -->fp_length     text
*      <--fp_i_fldcat  text
*----------------------------------------------------------------------*
FORM f_build_field_cat  USING: fp_name TYPE lvc_fname    " ALV control: Field name of internal table field
                               fp_tabname TYPE lvc_tname " LVC tab name
                               fp_col TYPE lvc_colpos    " ALV control: Output column
                               fp_text TYPE lvc_txt      " ALV control: Column identifier for dialog functions
                               fp_length TYPE lvc_outlen " ALV control: Column width in characters
                               fp_edit TYPE lvc_edit     " ALV control: Ready for input
                               fp_rfname TYPE lvc_rfname " ALV control: Reference field name for internal table field
                               fp_rtname TYPE lvc_rtname " ALV control: Reference table name for internal table field
                              CHANGING fp_i_fldcat TYPE  lvc_t_fcat.

  DATA: lr_t_fcat TYPE REF TO lvc_s_fcat. " S_fcat class
  CONSTANTS lc_decimals TYPE char10 VALUE 'DECIMALS'. " Decimals of type CHAR10
  CREATE DATA lr_t_fcat.
  lr_t_fcat->fieldname = fp_name.
  lr_t_fcat->col_pos = fp_col.
  lr_t_fcat->scrtext_s = fp_text.
  lr_t_fcat->scrtext_m = fp_text.
  lr_t_fcat->scrtext_l = fp_text.
  lr_t_fcat->outputlen = fp_length.
  lr_t_fcat->edit = fp_edit.
  lr_t_fcat->tabname = fp_tabname.
  lr_t_fcat->ref_field = fp_rfname.
  lr_t_fcat->ref_table = fp_rtname.

  CASE fp_name.
    WHEN c_price.
      lr_t_fcat->checktable = space.
      lr_t_fcat->datatype = lc_decimals. "'DECIMALS'.
    WHEN c_partner OR c_promo_n OR
         c_veindat OR c_vwundat OR
         c_can_date
         OR c_mchanbb OR c_mchandb
         OR c_mchanmemcat OR c_mchanliccat.
      lr_t_fcat->f4availabl = abap_true.
  ENDCASE.


  APPEND lr_t_fcat->* TO fp_i_fldcat.
  CLEAR lr_t_fcat->*.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXCLUDE_FUNCTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_I_EXCL_FUNC  text
*----------------------------------------------------------------------*
FORM f_exclude_function  CHANGING fp_i_excl_func TYPE ui_functions. " Function Code
*    Get excluding functions for the alv editable tool bar

  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_sort TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_subtot TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_sum TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_graph TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_info TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_print TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_filter TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_views TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_mb_export TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_mb_sum TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_mb_sum TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_mb_paste TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_find TO fp_i_excl_func.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy  TO fp_i_excl_func.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DROPDOWN
*&---------------------------------------------------------------------*
*       Build Drop Down
*----------------------------------------------------------------------*
*      --->FP_I_CONS
*      --->FP_I_TVKGT    : Internal table for Order Cance Reason code
*      --->FP_I_TVKST    : Internal table for Order cancel procedure
*      <--FP_R_GRID      : ALV grid reference variable
*      <--FP_I_FIELDCAT  : Field Catalogue
*----------------------------------------------------------------------*
FORM f_dropdown  USING fp_i_const TYPE vrm_values
                       fp_i_tvkgt TYPE tt_tvkgt
                       fp_i_tvkst TYPE tt_tvkst
                       fp_i_tvagt TYPE tt_tvagt
                       fp_dynnr TYPE sy-dynnr         " ABAP System Field: Current Dynpro Number
                       fp_v_application TYPE string
  CHANGING fp_r_grid      TYPE REF TO cl_gui_alv_grid " ALV List Viewer
           fp_i_fieldcat  TYPE lvc_t_fcat.

  TYPES : BEGIN OF ty_tpart,
            spras TYPE spras,       " Language Key
            parvw TYPE parvw,       " Partner Function
            vtext TYPE vtxtk,       " Name
          END OF ty_tpart,
          BEGIN OF ty_t685t,
            spras TYPE 	spras,
            kvewe	TYPE kvewe,
            kappl	TYPE kappl,
            kschl	TYPE kschl,
            vtext	TYPE vtxtk,
          END OF ty_t685t,
          BEGIN OF lty_tvlst,
            spras TYPE spras,       " Language Key
            lifsp TYPE lifsp,       " Default delivery block
            vtext TYPE bezei_lifsp, " Description
          END OF lty_tvlst.


  DATA :
    lr_fieldcat TYPE REF TO lvc_s_fcat, " S_fcat class
    li_taprt    TYPE STANDARD TABLE OF ty_tpart
                  WITH NON-UNIQUE SORTED KEY parvw COMPONENTS parvw,
    li_t685t    TYPE STANDARD TABLE OF ty_t685t
                  WITH NON-UNIQUE SORTED KEY kschl COMPONENTS kschl,
    li_tvlst    TYPE STANDARD TABLE OF lty_tvlst
                  WITH NON-UNIQUE SORTED KEY lifsp COMPONENTS lifsp,
    lr_tvkgt    TYPE REF TO ty_tvkgt,   " Cancellation reason
    lr_tvlst    TYPE REF TO lty_tvlst,  " Tvlst class
    lr_tvkst    TYPE REF TO ty_tvkst,   " Cancellation Procedures for Agreements; Texts
    lr_tvagt    TYPE REF TO ty_tvagt,   " Cancellation Reason
    lr_taprt    TYPE REF TO ty_tpart,   " Tpart class
    li_dropdown TYPE lvc_t_drop,
    ls_dropdown TYPE lvc_s_drop,        " ALV Control: Dropdown List Boxes
    lt_dral     TYPE lvc_t_dral.                            "#EC NEEDED

  DATA: lr_t685t TYPE REF TO ty_t685t. " T685t class

  CASE fp_dynnr.
    WHEN c_9004.
      IF NOT fp_i_const[] IS INITIAL.
        SELECT spras " Language
               parvw " Partner function
               vtext " Description
        FROM tpart   " Business Partner Functions: Texts
        INTO TABLE li_taprt
        FOR ALL ENTRIES IN fp_i_const
          WHERE
          spras = sy-langu
          AND parvw =   fp_i_const-key+0(2).
      ENDIF. " IF NOT fp_i_const[] IS INITIAL
      CLEAR: li_dropdown,
             ls_dropdown.
      LOOP AT li_taprt REFERENCE INTO lr_taprt.
        ls_dropdown-handle = 1.
        CONCATENATE lr_taprt->parvw lr_taprt->vtext  INTO ls_dropdown-value
        SEPARATED BY space.
        APPEND ls_dropdown TO li_dropdown.
        CLEAR ls_dropdown.
      ENDLOOP. " LOOP AT li_taprt REFERENCE INTO lr_taprt
    WHEN c_9005.
      IF fp_i_const[] IS NOT INITIAL.
        SELECT      spras  " Language
                    kvewe  " Usage of the condition table
                    kappl  " Application
                    kschl	 " condition type
                    vtext	 " Text
          FROM t685t       " Conditions: Types: Texts
           INTO TABLE li_t685t
          FOR ALL ENTRIES IN fp_i_const
          WHERE
          spras = sy-langu
          AND kschl = fp_i_const-key+0(4).
        LOOP AT li_t685t REFERENCE INTO lr_t685t.
          ls_dropdown-handle = 1.
          CONCATENATE lr_t685t->kschl lr_t685t->vtext  INTO ls_dropdown-value
          SEPARATED BY space.
          APPEND ls_dropdown TO li_dropdown.
          CLEAR ls_dropdown.

        ENDLOOP. " LOOP AT li_t685t REFERENCE INTO lr_t685t
      ENDIF. " IF fp_i_const[] IS NOT INITIAL

*    WHEN c_9010.
*      IF fp_i_const[] IS NOT INITIAL.
*        SELECT spras " Language Key
*               lifsp " Default delivery block
*               vtext " Description
*          INTO TABLE li_tvlst
*          FROM tvlst " Deliveries: Blocking Reasons/Scope: Texts
*          FOR ALL ENTRIES IN fp_i_const
*          WHERE spras = sy-langu
*          AND  lifsp = fp_i_const-key+0(2).
*        LOOP AT li_tvlst REFERENCE INTO lr_tvlst.
*          ls_dropdown-handle = 1.
*          CONCATENATE lr_tvlst->lifsp lr_tvlst->vtext  INTO ls_dropdown-value
*          SEPARATED BY space.
*          APPEND ls_dropdown TO li_dropdown.
*          CLEAR ls_dropdown.
*        ENDLOOP. " LOOP AT li_tvlst REFERENCE INTO lr_tvlst
*
*      ENDIF. " IF fp_i_const[] IS NOT INITIAL
    WHEN c_9008.
*& Populating Cancellation reason for drop down
      CASE fp_v_application.
* BOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021
        WHEN if_sdoc_select=>co_application_id-va05nn.
          LOOP AT fp_i_tvagt REFERENCE INTO lr_tvagt.
            ls_dropdown-handle = 1.
            CONCATENATE lr_tvagt->abgru lr_tvagt->bezei  INTO ls_dropdown-value
            SEPARATED BY space.
            APPEND ls_dropdown TO li_dropdown.
            CLEAR ls_dropdown.
          ENDLOOP. " LOOP AT fp_i_tvagt REFERENCE INTO lr_tvagt
* EOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021
        WHEN if_sdoc_select=>co_application_id-va25nn.
          LOOP AT fp_i_tvagt REFERENCE INTO lr_tvagt.
            ls_dropdown-handle = 1.
            CONCATENATE lr_tvagt->abgru lr_tvagt->bezei  INTO ls_dropdown-value
            SEPARATED BY space.
            APPEND ls_dropdown TO li_dropdown.
            CLEAR ls_dropdown.
          ENDLOOP. " LOOP AT fp_i_tvagt REFERENCE INTO lr_tvagt
        WHEN if_sdoc_select=>co_application_id-va45nn.
          LOOP AT fp_i_tvkgt REFERENCE INTO lr_tvkgt.
            ls_dropdown-handle = 1.
            CONCATENATE lr_tvkgt->kuegru lr_tvkgt->bezei  INTO ls_dropdown-value
            SEPARATED BY space.
            APPEND ls_dropdown TO li_dropdown.
            CLEAR ls_dropdown.
          ENDLOOP. " LOOP AT fp_i_tvkgt REFERENCE INTO lr_tvkgt
          LOOP AT fp_i_tvkst REFERENCE INTO lr_tvkst.
            ls_dropdown-handle = 2.
            CONCATENATE lr_tvkst->vkuesch lr_tvkst->vbezei  INTO ls_dropdown-value
            SEPARATED BY space.
            APPEND ls_dropdown TO li_dropdown.
            CLEAR ls_dropdown.
          ENDLOOP. " LOOP AT fp_i_tvkst REFERENCE INTO lr_tvkst
        WHEN OTHERS.
      ENDCASE.


    WHEN OTHERS.
  ENDCASE.

  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_kschl.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_kschl.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 30.
  ENDIF. " IF sy-subrc = 0
  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_part_fun.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_part_fun.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 30.
  ENDIF. " IF sy-subrc = 0
*  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_lifsk.
*  IF sy-subrc = 0.
*    lr_fieldcat->drdn_field = c_lifsk.
*    lr_fieldcat->drdn_hndl = 1.
*    lr_fieldcat->outputlen = 30.
*  ENDIF. " IF sy-subrc = 0

  IF fp_v_application = if_sdoc_select=>co_application_id-va45nn.
    READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_vkuesch.
    IF sy-subrc = 0.
      lr_fieldcat->drdn_field = c_vkuesch.
      lr_fieldcat->drdn_hndl = 2.
      lr_fieldcat->outputlen = 40.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF fp_v_application = if_sdoc_select=>co_application_id-va45nn

  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_vkuegru.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_vkuegru.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 40.
  ENDIF. " IF sy-subrc = 0
  IF li_dropdown IS NOT INITIAL.
    CALL METHOD fp_r_grid->set_drop_down_table
      EXPORTING
        it_drop_down = li_dropdown. " Dropdown Table
    " it_drop_down_alias = lt_dral.  " ALV Control: Dropdown List Boxes
  ENDIF. " IF li_dropdown IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_PARTNER
*&---------------------------------------------------------------------*
*       Patrtner
*----------------------------------------------------------------------*
*      -->FP_I_PARTNER  text
*----------------------------------------------------------------------*
FORM f_change_partner  USING    fp_i_partner TYPE tt_t_partner
                                fp_v_hd_partner TYPE char1    " V_hd_partner of type CHAR1
                                fp_v_item_partner TYPE char1. " V_item_partner of type CHAR1
  DATA: lr_partner TYPE  REF TO ty_partner, " Partner class
        li_vbpa    TYPE tt_t_vbpa.

  SELECT vbeln " Sales and Distribution Document Number
         posnr " Item number of the SD document
         parvw " Partner Function
         kunnr " Customer Number
         lifnr " Vendor
    FROM vbpa  " Sales Document: Partner
    INTO TABLE li_vbpa
    FOR ALL ENTRIES IN fp_i_partner
    WHERE
    vbeln EQ fp_i_partner-vbeln.

  LOOP AT fp_i_partner REFERENCE INTO lr_partner.
    PERFORM change_sales_partner_chn USING lr_partner
                                           li_vbpa
                                           fp_v_hd_partner
                                           fp_v_item_partner
                                    CHANGING i_xvbfs
                                             i_messages
                                       .

  ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner

ENDFORM.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_LR_PAR_FUN  text
*      <--P_FP_I_XVPS  text
*      <--P_FP_I_MESSAGE  text
*----------------------------------------------------------------------*
FORM f_populate_message  USING    fp_lv_vblen TYPE vbap-vbeln       " Sales Document
                                  fp_lv_posnr TYPE vbap-posnr       " Sales Document Item
                                  fp_lr_return TYPE REF TO bapiret2 "  class
                         CHANGING fp_i_xvps TYPE tt_t_vbfs
                                  fp_i_message TYPE tdt_sdoc_msg.


  DATA: lst_message TYPE tds_sdoc_msg, " Sales Document Selection: Messages
        lst_xvbfs   TYPE vbfs.         " Error Log for Collective Processing
  IF fp_lr_return->type = c_error OR
     fp_lr_return->type = c_abend.
    "Position
    MOVE fp_lv_vblen TO lst_xvbfs-vbeln. "Belegnummer
    CLEAR lst_xvbfs-posnr.
    MOVE fp_lv_posnr TO lst_xvbfs-posnr. "Positionsnummer
    MOVE fp_lr_return->id      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
    MOVE fp_lr_return->number  TO lst_xvbfs-msgno. "Nachrichtennummer
    MOVE fp_lr_return->type      TO lst_xvbfs-msgty. "Messageart
    MOVE fp_lr_return->message_v1      TO lst_xvbfs-msgv1. "Messagevariable 1
    MOVE fp_lr_return->message_v2      TO lst_xvbfs-msgv2. "Messagevariable 2
    MOVE fp_lr_return->message_v3      TO lst_xvbfs-msgv3. "Messagevariable 3
    MOVE fp_lr_return->message_v4      TO lst_xvbfs-msgv4. "Messagevariable 4
    APPEND lst_xvbfs TO fp_i_xvps.


  ENDIF. " IF fp_lr_return->type = c_error OR

  MOVE fp_lr_return->id      TO lst_message-msgid. "Nachrichtenidentifikation
  MOVE fp_lr_return->number      TO lst_message-msgno. "Nachrichtennummer
  MOVE fp_lr_return->type      TO lst_message-msgty. "Messageart
  MOVE fp_lr_return->message_v1      TO lst_message-msgv1. "Messagevariable 1
  MOVE fp_lr_return->message_v2      TO lst_message-msgv2. "Messagevariable 2
  MOVE fp_lr_return->message_v3      TO lst_message-msgv3. "Messagevariable 3
  MOVE fp_lr_return->message_v4      TO lst_message-msgv4. "Messagevariable 4
  MOVE fp_lr_return->message         TO lst_message-msgtxt.  "++VDAPTABALL 10/21/2020
  APPEND lst_message TO fp_i_message.
  CLEAR lst_message.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROMOO_CODE
*&---------------------------------------------------------------------*
*     Fetch Old promo code per Item
*----------------------------------------------------------------------*
*      -->FP_I_SEL_ROWS  text
*      -->FP_<I_RESULT>  text
*      <--FP_I_PROMO  text
*----------------------------------------------------------------------*
FORM f_promo_code  USING    fp_i_sel_rows TYPE  salv_t_row
                                    fp_i_result TYPE STANDARD TABLE
                           CHANGING fp_i_promo  TYPE tt_promo.
  DATA: li_promo_code TYPE tt_promo_code,
        lr_promo      TYPE REF TO ty_promo,      " reference Variable for Promo code
        lr_promo_code TYPE REF TO ty_promo_code. " Referencce variable

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_posnr>   TYPE vbap-posnr, " Sales Document Item
                  <lst_result> TYPE any.
  CREATE DATA lr_promo.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_promo->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
      IF <lv_posnr> IS ASSIGNED.
        lr_promo->posnr = <lv_posnr>.
        UNASSIGN <lv_posnr>.
      ENDIF. " IF <lv_posnr> IS ASSIGNED
      APPEND lr_promo->* TO fp_i_promo.
      CLEAR lr_promo->*.

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row
  IF NOT fp_i_promo[] IS INITIAL.
    SELECT vbeln     " Sales Order
           posnr     " Item
           zzpromo   " Promo Code
           FROM vbap " Sales Document: Item Data
      INTO TABLE li_promo_code
      FOR ALL ENTRIES IN fp_i_promo
      WHERE
      vbeln = fp_i_promo-vbeln
      AND posnr = fp_i_promo-posnr.

    IF sy-subrc = 0.
*& Do nothing as table is already sorted
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF NOT fp_i_promo[] IS INITIAL
*& Populate the Existing Promo in PROMO_O field
  LOOP AT fp_i_promo REFERENCE INTO lr_promo.
    READ TABLE li_promo_code REFERENCE INTO lr_promo_code
    WITH TABLE KEY promo_code COMPONENTS vbeln = lr_promo->vbeln
                                          posnr = lr_promo->posnr.
    IF sy-subrc = 0 .
      lr_promo->promo_o = lr_promo_code->zzpromo.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_promo REFERENCE INTO lr_promo
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_PROMO_CODE
*&---------------------------------------------------------------------*
*      Update New Promo code
*----------------------------------------------------------------------*
*      -->P_I_PROMO  : Promo Code
*----------------------------------------------------------------------*
FORM f_update_promo_code  USING    fp_i_promo TYPE tt_promo.

*Local data declaration
  DATA lr_promo TYPE REF TO ty_promo. " Promo class
*  LOOP AT fp_i_promo REFERENCE INTO lr_promo WHERE promo_n IS NOT INITIAL.
  LOOP AT fp_i_promo REFERENCE INTO lr_promo.
    READ TABLE i_promo_final INTO DATA(lst_promo_final) INDEX 1.
    IF sy-subrc EQ 0.
      IF lst_promo_final-promo_n IS NOT INITIAL.
        PERFORM f_update_promo USING lr_promo
                               CHANGING i_xvbfs
                                        i_messages.
      ENDIF. " IF lst_promo_final-promo_n IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT fp_i_promo REFERENCE INTO lr_promo
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_PROMO
*&---------------------------------------------------------------------*
*       Update Promo Code
*----------------------------------------------------------------------*
*      -->FP_LR_PROMO  : Reference variable for Promo code
*      <--FP_I_XVBFS   : Message
*      <--FP_I_MESSAGES  : Message
*----------------------------------------------------------------------*
FORM f_update_promo  USING    fp_lr_promo TYPE REF TO ty_promo " Promo class
                     CHANGING fp_i_xvbfs TYPE tt_t_vbfs
                              fp_i_messages TYPE tdt_sdoc_msg.
  DATA:
    lst_header_inx  TYPE bapisdh1x,                     " Checkbox List: SD Order Header
    li_return       TYPE TABLE OF bapiret2,             " Return Messages
    lr_return       TYPE REF TO bapiret2,               " BAPI Return Messages
    lst_bape_vbap   TYPE bape_vbap,                     " BAPI Interface for Customer Enhancements to Table VBAP
    lst_bape_vbapx  TYPE bape_vbapx,                    " BAPI Checkbox for Customer Enhancments to Table VBAP
    lst_item_in     TYPE  bapisditm,                    " Communication Fields: Sales and Distribution Document Item
    li_item_in      TYPE STANDARD TABLE OF bapisditm,   " Communication Fields: Sales and Distribution Document Item
    lst_item_inx    TYPE  bapisditmx,                   " Communication Fields: Sales and Distribution Document Item
    li_item_inx     TYPE STANDARD TABLE OF bapisditmx,  " Communication Fields: Sales and Distribution Document Item
    lst_extensionin TYPE  bapiparex,                    " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
    li_extensionin  TYPE   STANDARD TABLE OF bapiparex. " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut

  CONSTANTS:lc_bape_vbap  TYPE te_struc VALUE 'BAPE_VBAP',  " constant table name  for extension
            lc_bape_vbapx TYPE te_struc VALUE 'BAPE_VBAPX'. " constant table name for Extension
  lst_header_inx-updateflag = c_update.
  lst_item_in-itm_number = fp_lr_promo->posnr.

  APPEND lst_item_in TO li_item_in.
  CLEAR lst_item_in.
*   Populate the itemx table
  lst_item_inx-itm_number = fp_lr_promo->posnr.
  lst_item_inx-updateflag = c_update.
  APPEND lst_item_inx TO li_item_inx.
  CLEAR lst_item_inx.
*   Populate the extension table
*   Populate the value
  lst_extensionin-structure      = lc_bape_vbap.
  lst_bape_vbap-vbeln            = fp_lr_promo->vbeln.
  lst_bape_vbap-posnr            = fp_lr_promo->posnr.

  READ TABLE i_promo_final INTO DATA(lst_promo_final) INDEX 1.
  IF sy-subrc EQ 0.
    lst_bape_vbap-zzpromo       =  lst_promo_final-promo_n. "  fp_lr_promo->promo_n.
  ENDIF. " IF sy-subrc EQ 0

  CALL METHOD cl_abap_container_utilities=>fill_container_c
    EXPORTING
      im_value     = lst_bape_vbap
    IMPORTING
      ex_container = lst_extensionin-valuepart1.
  APPEND lst_extensionin TO li_extensionin.
  CLEAR lst_extensionin.
*   Populate the Check box
  lst_extensionin-structure       = lc_bape_vbapx.
  lst_bape_vbapx-vbeln            = fp_lr_promo->vbeln.
  lst_bape_vbapx-posnr            = fp_lr_promo->posnr.
  lst_bape_vbapx-zzpromo           = abap_true.
  CALL METHOD cl_abap_container_utilities=>fill_container_c
    EXPORTING
      im_value     = lst_bape_vbapx
    IMPORTING
      ex_container = lst_extensionin-valuepart1.

  APPEND lst_extensionin TO li_extensionin.
  CLEAR  lst_extensionin.


  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = fp_lr_promo->vbeln
      order_header_inx = lst_header_inx
    TABLES
      return           = li_return
      order_item_in    = li_item_in
      order_item_inx   = li_item_inx
      extensionin      = li_extensionin.

  LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                                 OR type = c_abend. " Or of type

    PERFORM f_populate_message USING fp_lr_promo->vbeln
                                     fp_lr_promo->posnr
                                     lr_return
                               CHANGING  fp_i_xvbfs
                                         fp_i_messages.
  ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
*& If no Error / Abend happens
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0.
      PERFORM f_populate_message USING fp_lr_promo->vbeln
                                       fp_lr_promo->posnr
                                       lr_return
                                 CHANGING  fp_i_xvbfs
                                           fp_i_messages.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CANCEL_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_CANCEL : Internal table for Cancel Order
*      <--P_FP_I_MESSAGE  text
*      <--P_FP_I_XVBFS  text
*----------------------------------------------------------------------*
FORM f_cancel_order  USING    fp_i_cancel TYPE tt_t_cancel
                              fp_v_appl   TYPE string
                     CHANGING fp_i_message TYPE tdt_sdoc_msg
                              fp_i_xvbfs TYPE tt_t_vbfs.


  DATA: li_return             TYPE TABLE OF bapiret2,            " Return Parameter
        li_item_in            TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        lv_text               TYPE string,
        lv_item               TYPE string,
        li_item_inx           TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
        lr_return             TYPE REF TO bapiret2,              " reference variable for Return Parameter
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,   " Internal  table for cond
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx , " Communication fields: SD Contract Data Checkbox
        lst_header_inx        TYPE bapisdhd1x,                   " Checkbox Fields for Sales and Distribution Document Header
        lr_cancel             TYPE REF TO ty_cancel,             " Cancel class
        li_cancel             TYPE tt_t_cancel,                  " temporary table
        lr_veda               TYPE REF TO ty_veda,               " Veda class
        li_veda               TYPE tt_veda.
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
  CONSTANTS : lc_posnr TYPE vbap-posnr VALUE '000000'.
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
  CONSTANTS lc_separator TYPE char1 VALUE '/'. " Separator of type CHAR1
  IF NOT fp_i_cancel IS INITIAL.
    SELECT  vbeln " Sales Document
            vposn " Sales Document Item
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
            vbegdat " Contract start date
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
            vkuesch " Assignment cancellation procedure/cancellation rule
            veindat " Date on which cancellation request was received
            vwundat " Requested cancellation date
            vkuegru " Reason for Cancellation of Contract
            vbedkue " Date of cancellation document from contract partner
      FROM veda     " Contract Data
      INTO TABLE li_veda
      FOR ALL ENTRIES IN fp_i_cancel
      WHERE
         vbeln  = fp_i_cancel-vbeln
      AND ( vposn = fp_i_cancel-posnr
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
         OR vposn = lc_posnr ).
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
  ENDIF. " IF NOT fp_i_cancel IS INITIAL
  CREATE DATA lr_veda.
  li_cancel = fp_i_cancel.
*  DELETE li_cancel WHERE vkuegru IS INITIAL.

* BOC by PBANDLAPAL on 29-Nov-2017 for ERP-5360 : TR#ED2K909642
*  SORT li_cancel BY vbeln.
  SORT li_cancel BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_cancel COMPARING vbeln posnr.
* EOC by PBANDLAPAL on 29-Nov-2017 for ERP-5360 : TR# ED2K909642

  LOOP AT li_cancel REFERENCE INTO lr_cancel . "WHERE vkuegru IS NOT INITIAL .
    CASE fp_v_appl.
      WHEN if_sdoc_select=>co_application_id-va45nn.
        IF lv_item IS INITIAL.
          CONCATENATE  lr_cancel->posnr lv_item INTO lv_item SEPARATED BY space.
        ELSE. " ELSE -> IF lv_item IS INITIAL
          CONCATENATE lv_item lc_separator lr_cancel->posnr INTO lv_item SEPARATED BY space.
        ENDIF. " IF lv_item IS INITIAL

* BOC by PBANDLAPAL on 29-Nov-2017 for ERP-5360 : TR#ED2K909642
*        CLEAR lr_veda->*.
* EOC by PBANDLAPAL on 29-Nov-2017 for ERP-5360 : TR#ED2K909642
        READ TABLE li_veda REFERENCE INTO lr_veda WITH TABLE KEY veda COMPONENTS
                                                                 vbeln = lr_cancel->vbeln
                                                                 vposn = lr_cancel->posnr.
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
        IF sy-subrc NE 0.
          READ TABLE li_veda REFERENCE INTO lr_veda WITH TABLE KEY veda COMPONENTS
                                                                   vbeln = lr_cancel->vbeln
                                                                   vposn = lc_posnr.
        ENDIF.
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017


        PERFORM f_cancel_order_item USING lr_cancel
                                          lr_veda
                               CHANGING li_item_in
                                        li_item_inx
                                        li_sales_contract_in
                                        li_sales_contract_inx
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
                                        fp_i_xvbfs
                                        fp_i_message.
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017


      WHEN if_sdoc_select=>co_application_id-va25nn.
        PERFORM f_update_rejection_reason USING lr_cancel
                                   CHANGING fp_i_message
                                            fp_i_xvbfs.

* BOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021
      WHEN if_sdoc_select=>co_application_id-va05nn.
        PERFORM f_update_rejection_reason USING lr_cancel
                                   CHANGING fp_i_message
                                            fp_i_xvbfs.
* EOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021

      WHEN OTHERS.
    ENDCASE.

    AT END OF vbeln.
      IF NOT li_sales_contract_in IS INITIAL.
        lst_header_inx-updateflag = c_update.
        CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
          EXPORTING
            salesdocument      = lr_cancel->vbeln
            order_header_inx   = lst_header_inx
*           business_object    = 'BUS2034'
          TABLES
            return             = li_return
            item_in            = li_item_in
            item_inx           = li_item_inx
            sales_contract_in  = li_sales_contract_in
            sales_contract_inx = li_sales_contract_inx.


        LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                                     OR type = c_abend. " Or of type

          PERFORM f_populate_message USING lr_cancel->vbeln
                                           lr_cancel->posnr
                                           lr_return
                                     CHANGING  fp_i_xvbfs
                                               fp_i_message.
        ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
*& If no Error / Abend happens
        IF sy-subrc <> 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
          READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
          IF sy-subrc = 0.
            MESSAGE s127(zqtc_r2) WITH lr_cancel->vbeln lv_item INTO lv_text. " Canellation Procedure updated for Order & and Items: &
            IF lv_text IS NOT INITIAL.
              MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
              MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
              MOVE sy-msgty      TO lr_return->type. "Messageart
              MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
              MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
              MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
              MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
              PERFORM f_populate_message USING  lr_cancel->vbeln
                                               lr_cancel->posnr
                                               lr_return
                                         CHANGING  fp_i_xvbfs
                                                   fp_i_message.
            ENDIF. " IF lv_text IS NOT INITIAL

          ENDIF. " IF sy-subrc = 0
        ELSE. " ELSE -> IF sy-subrc <> 0
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF NOT li_sales_contract_in IS INITIAL
      CLEAR: li_sales_contract_in,
             li_sales_contract_inx,
             li_item_in,
             li_item_inx,
             li_return,
             lv_item,
             lv_text.
    ENDAT.

  ENDLOOP. " LOOP AT li_cancel REFERENCE INTO lr_cancel

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CANCEL_ORD_DATA
*&---------------------------------------------------------------------*
*       Populating Cancel Intrnal table
*----------------------------------------------------------------------*
*      -->FP_I_SEL_ROWS  : ALV Selected rows
*      -->FP_<I_RESULT>  : ALV Result table
*      <--FP_I_CANCEL    : Cancel Internal Table
*----------------------------------------------------------------------*
FORM f_cancel_ord_data  USING       fp_i_sel_rows TYPE  salv_t_row
                                    fp_i_result TYPE STANDARD TABLE
                           CHANGING fp_i_cancel  TYPE tt_t_cancel.
  DATA:
          lr_cancel TYPE REF TO ty_cancel. " reference Variable for Promo code

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_posnr>   TYPE vbap-posnr, " Sales Document Item
                  <lst_result> TYPE any.
  CREATE DATA lr_cancel.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_cancel->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
      IF <lv_posnr> IS ASSIGNED.
        lr_cancel->posnr = <lv_posnr>.
        UNASSIGN <lv_posnr>.
      ENDIF. " IF <lv_posnr> IS ASSIGNED
      lr_cancel->vbedkue = sy-datum.
      lr_cancel->veindat = sy-datum.
      lr_cancel->vwundat = sy-datum.
*      READ TABLE fp_i_const REFERENCE INTO lr_const WITH KEY param1 = lc_param1.
*      IF sy-subrc = 0.
*        CLEAR lv_vkuesch.
*        lv_vkuesch = lr_const->low.
*        READ TABLE fp_i_tvkst REFERENCE INTO lr_tvkst WITH TABLE KEY vkuesch
*        COMPONENTS spras = sy-langu vkuesch = lv_vkuesch.
*        IF sy-subrc = 0.
*          CONCATENATE lr_tvkst->vkuesch lr_tvkst->vbezei INTO lr_cancel->vkuegru
*          SEPARATED BY space.
*        ENDIF.
*      ENDIF.
      APPEND lr_cancel->* TO fp_i_cancel.

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ORD_REASON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_I_TVKGT  text
*      <--FP_I_TVKST  text

*----------------------------------------------------------------------*
FORM f_fetch_ord_reason  USING   fp_v_application TYPE string
                         CHANGING fp_i_tvkgt  TYPE tt_tvkgt
                                  fp_i_tvkst  TYPE tt_tvkst
                                  fp_i_tvagt  TYPE tt_tvagt.
  CASE fp_v_application.
* BOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021
    WHEN  if_sdoc_select=>co_application_id-va05nn.
      SELECT  spras " Language
              abgru " Reason for rejection of quotations and sales orders
              bezei " Reason text
        FROM tvagt  " Rejection Reasons for Sales Documents: Texts
        INTO TABLE fp_i_tvagt
        WHERE
        spras = sy-langu.
      IF sy-subrc = 0.
*& do nothing
      ENDIF. " IF sy-subrc = 0
* EOC - OTCM-22844 - ED2K924394 - NPALLA - 24 Aug 2021
    WHEN  if_sdoc_select=>co_application_id-va25nn.
      SELECT  spras " Language
              abgru " Reason for rejection of quotations and sales orders
              bezei " Reason text
        FROM tvagt  " Rejection Reasons for Sales Documents: Texts
        INTO TABLE fp_i_tvagt
        WHERE
        spras = sy-langu.
      IF sy-subrc = 0.
*& do nothing
      ENDIF. " IF sy-subrc = 0

    WHEN if_sdoc_select=>co_application_id-va45nn.
      IF fp_i_tvkgt IS INITIAL.
        SELECT spras  " Language Key
               kuegru " Reason for Cancellation of Contract
               bezei  " Description
          FROM tvkgt  " Sales Documents: Reasons for Cancellation: Texts
          INTO TABLE fp_i_tvkgt
          WHERE spras = sy-langu.
        IF sy-subrc = 0.
*& Do Nothing
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF fp_i_tvkgt IS INITIAL

      IF fp_i_tvkst IS INITIAL.
        SELECT spras   "  Language Key
               vkuesch " Assignment cancellation procedure/cancellation rule
               vbezei  " Description
          FROM tvkst   " Cancellation Procedures for Agreements; Texts
          INTO TABLE fp_i_tvkst
          WHERE
          spras = sy-langu.

        IF sy-subrc = 0.
*& Do Nothing
        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF fp_i_tvkst IS INITIAL
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CANCEL_ORDER_ITEM
*&---------------------------------------------------------------------*
*       Update Cancellation Reason and Cancellation procedure
*----------------------------------------------------------------------*
*      -->FP_LR_CANCEL    : Items to be cancelled
*      <--FP_I_MESSAGES  : Message
*      <--FP_I_VBFS      : Error Log for Collective Processing
*----------------------------------------------------------------------*
FORM f_cancel_order_item  USING    fp_lr_cancel          TYPE REF TO ty_cancel " Cancel class
                                   fp_lr_veda            TYPE REF TO ty_veda   " Veda class
                          CHANGING fp_i_item             TYPE  bapisditm_tt
                                   fp_i_itemx            TYPE  bapisditmx_tt
                                   fp_sales_contract_in  TYPE  jbapictr_tab
                                   fp_sales_contract_inx TYPE  jbapictrx_tab
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
                                   fp_i_xvps             TYPE tt_t_vbfs
                                   fp_i_message          TYPE tdt_sdoc_msg.
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017

  DATA: lst_item_in           TYPE  bapisditm,        " Communication Fields: Sales and Distribution Document Item
        lst_item_inx          TYPE  bapisditmx,       " Communication Fields: Sales and Distribution Document Item
        lr_sales_contract_in  TYPE  REF TO bapictr ,  " contract data
        lr_sales_contract_inx TYPE REF TO  bapictrx . " Communication fields: SD Contract Data Checkbox
  CREATE DATA: lr_sales_contract_in,
               lr_sales_contract_inx.

*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
  DATA: lv_text   TYPE string,
        lr_return TYPE REF TO bapiret2. "  class
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017

  READ TABLE i_cancel_final INTO DATA(lst_cancel_final) INDEX 1.
  IF sy-subrc EQ 0.
    DATA(lv_vkuesch) = lst_cancel_final-vkuesch+0(4).
    DATA(lv_vkuegru) = lst_cancel_final-vkuegru+0(2).
    DATA(lv_vbedkue) = lst_cancel_final-vbedkue.
    DATA(lv_veindat) = lst_cancel_final-veindat.
    DATA(lv_vwundat) = lst_cancel_final-vwundat.
  ENDIF. " IF sy-subrc EQ 0

*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
  IF fp_lr_veda->vbegdat GT lv_vwundat.
    MESSAGE e238(zqtc_r2) WITH lv_vwundat INTO lv_text. " Canellation Procedure updated for Order & and Items: &
    IF lv_text IS NOT INITIAL.
      IF lr_return IS NOT BOUND.
        CREATE DATA lr_return.
      ENDIF. " IF lr_return IS NOT BOUND

      MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
      MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
      MOVE sy-msgty      TO lr_return->type. "Messageart
      MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
      MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
      MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
      MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4

      PERFORM f_populate_message USING fp_lr_cancel->vbeln
                                       fp_lr_cancel->posnr
                                       lr_return
                                 CHANGING  fp_i_xvps
                                           fp_i_message.
      RETURN.
    ENDIF. " IF lv_text IS NOT INITIAL
  ENDIF. " IF fp_lr_veda->vbegdat GT lv_vwundat
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017

*  IF fp_lr_cancel->vkuesch+0(4) NE fp_lr_veda->vkuesch.
  IF lv_vkuesch NE fp_lr_veda->vkuesch.
    lr_sales_contract_in->canc_proc = lv_vkuesch. "fp_lr_cancel->vkuesch+0(4). " Cancellation Procedure
    lr_sales_contract_inx->canc_proc = abap_true. " Cancellation Procedure
  ENDIF. " IF lv_vkuesch NE fp_lr_veda->vkuesch
*  IF fp_lr_cancel->vkuegru+0(2) NE fp_lr_veda->vkuegru.
  IF lv_vkuegru NE fp_lr_veda->vkuegru.
    lr_sales_contract_in->cancreason = lv_vkuegru. "fp_lr_cancel->vkuegru+0(2). " Cancellation reason code
    lr_sales_contract_inx->cancreason = abap_true. " Cancellation reason code
  ENDIF. " IF lv_vkuegru NE fp_lr_veda->vkuegru
*  IF fp_lr_cancel->vbedkue NE fp_lr_veda->vbedkue.
  IF lv_vbedkue NE fp_lr_veda->vbedkue.
    lr_sales_contract_in->cancdocdat = lv_vbedkue. "fp_lr_cancel->vbedkue.
    lr_sales_contract_inx->cancdocdat = abap_true.
  ENDIF. " IF lv_vbedkue NE fp_lr_veda->vbedkue
*  IF fp_lr_cancel->veindat NE fp_lr_veda->veindat.
  IF lv_veindat NE fp_lr_veda->veindat.
    lr_sales_contract_in->canc_r_dat = lv_veindat. "fp_lr_cancel->veindat.
    lr_sales_contract_inx->canc_r_dat = abap_true.
  ENDIF. " IF lv_veindat NE fp_lr_veda->veindat
*  IF fp_lr_cancel->vwundat NE fp_lr_veda->vwundat.
  IF lv_vwundat NE fp_lr_veda->vwundat.
    lr_sales_contract_in->r_canc_dat = lv_vwundat. "fp_lr_cancel->vwundat.
    lr_sales_contract_inx->r_canc_dat = abap_true.
  ENDIF. " IF lv_vwundat NE fp_lr_veda->vwundat
  IF lr_sales_contract_in->* IS NOT INITIAL.
    lr_sales_contract_in->itm_number = fp_lr_cancel->posnr. " Iteme number
    APPEND lr_sales_contract_in->* TO fp_sales_contract_in.
    CLEAR lr_sales_contract_in->*.
    " Error Log for Collective Processing
    lst_item_in-itm_number = fp_lr_cancel->posnr.
    APPEND lst_item_in TO fp_i_item.
    CLEAR lst_item_in.
  ENDIF. " IF lr_sales_contract_in->* IS NOT INITIAL

  IF lr_sales_contract_inx->* IS NOT INITIAL.
    lr_sales_contract_inx->itm_number = fp_lr_cancel->posnr. " Iteme number
    lr_sales_contract_inx->updateflag = c_update.
    APPEND lr_sales_contract_inx->* TO fp_sales_contract_inx.
    CLEAR lr_sales_contract_inx->*.
*   Populate the itemx table
    lst_item_inx-itm_number = fp_lr_cancel->posnr.
    lst_item_inx-updateflag = c_update.
    APPEND lst_item_inx TO fp_i_itemx.
    CLEAR lst_item_inx.
  ENDIF. " IF lr_sales_contract_inx->* IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_ALV
*&---------------------------------------------------------------------*
*       Create ALV for displayng records
*----------------------------------------------------------------------*


FORM f_create_alv .
  CLEAR i_fielcat_con.
  IF r_docking_condition IS  INITIAL.
*create a docking container and dock the control at the botton
    CREATE OBJECT r_docking_condition
      EXPORTING
        dynnr     = c_9005
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.
*create the alv grid for display the table
    CREATE OBJECT r_cond_grid
      EXPORTING
        i_parent = r_docking_condition.
*create custome container for alv
    CREATE OBJECT r_cont_cust
      EXPORTING
        container_name = c_part_cont.
*create alv editable grid
    CREATE OBJECT r_cont_editalvgd
      EXPORTING
        i_parent = r_cont_cust.

*building the fieldcatalogue for the initial display
    IF i_fielcat_con[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fielcat_con.
    ENDIF. " IF i_fielcat_con[] IS INITIAL
    IF i_excl_func[] IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.

    ENDIF. " IF i_excl_func[] IS INITIAL
*fetch data from the table
    IF i_item[] IS INITIAL.
      PERFORM f_fetch_data USING i_sel_rows
                                 <i_result>
                           CHANGING i_item.
    ENDIF. " IF i_item[] IS INITIAL


    PERFORM f_dropdown_cond USING i_fielcat_con
                                  i_cond
                                  i_t685a
                                  v_head_cond
                        CHANGING r_cond_grid.
    CALL METHOD r_cond_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fielcat_con. " Field Catalog
    CALL METHOD cl_gui_cfw=>flush.
*Alv display for the T006 table at the bottom
    i_item_final[] = i_item[].
    DATA(lv_count) = lines( i_item_final ).
    IF lv_count > 1.
      DELETE i_item_final FROM 2 TO lv_count.
    ENDIF. " IF lv_count > 1
    CALL METHOD r_cond_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
*       is_layout            = i_layout
      CHANGING
        it_outtab            = i_item_final[]
        it_fieldcatalog      = i_fielcat_con[].
* set editable cells to ready for input
    CALL METHOD r_cond_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_cond_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.
** register events for the editable alv
*    CREATE OBJECT r_event_receiver.
*    SET HANDLER r_event_receiver->meth_handle_data_changed FOR r_cond_grid.

  ENDIF. " IF r_docking_condition IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       Preapare data
*----------------------------------------------------------------------*
*      -->FP_I_SEL_ROWS  : Rows
*      -->FP_I_RESULT>   : type any Table
*      <--FP_I_ITEM      : Items
*----------------------------------------------------------------------*
FORM f_fetch_data  USING    fp_i_sel_rows TYPE salv_t_row
                            fp_i_result TYPE STANDARD TABLE
                   CHANGING fp_i_item TYPE tt_t_item.
  DATA lr_item TYPE REF TO ty_item. " Item class

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_posnr>   TYPE vbap-posnr, " Sales Document Item
                  <lv_waerk>   TYPE vbak-waerk, " SD Document Currency
                  <lst_result> TYPE any.

  CREATE DATA lr_item.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_item->vblen = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
      IF <lv_posnr> IS ASSIGNED.
        lr_item->posnr = <lv_posnr>.
        UNASSIGN <lv_posnr>.
      ENDIF. " IF <lv_posnr> IS ASSIGNED
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-waerk OF   STRUCTURE <lst_result> TO <lv_waerk>.
      IF <lv_waerk> IS ASSIGNED.
        lr_item->waerk = <lv_waerk>.
        UNASSIGN <lv_waerk>.
      ENDIF. " IF <lv_waerk> IS ASSIGNED
      APPEND lr_item->* TO fp_i_item.
      CLEAR lr_item->*.

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DROPDOWN_COND
*&---------------------------------------------------------------------*
*       Dropdown for Pricing condition
*----------------------------------------------------------------------*
*      -->fp_i_fieldcat
*      <--FP_R_COND_GRID  text
*----------------------------------------------------------------------*
FORM f_dropdown_cond  USING fp_i_fieldcat TYPE lvc_t_fcat
                            fp_i_cond     TYPE vrm_values
                            fp_i_t685a    TYPE tt_t685a
                            fp_hd_cond    TYPE char1                       " Hd_cond of type CHAR1
                      CHANGING fp_r_cond_grid TYPE REF TO cl_gui_alv_grid. " ALV List Viewer

  DATA: li_dropdown  TYPE lvc_t_drop,
        lst_dropdown TYPE lvc_s_drop,                                   " ALV Control: Dropdown List Boxes
        lr_t685a     TYPE REF TO ty_t685a,                              " T685a class
        li_t685a     TYPE tt_t685a,
        li_t685t     TYPE TABLE OF t685t WITH NON-UNIQUE SORTED KEY key " Conditions: Types: Texts
            COMPONENTS spras kschl,
        lr_t685t     TYPE REF TO t685t,                                 "  class
        lr_fcat      TYPE  REF TO lvc_s_fcat.                           " S_fcat class
  li_t685a = fp_i_t685a.
  IF fp_hd_cond EQ abap_true.
*& Incase of header condition delete Item condition
    DELETE li_t685a WHERE kkopf <> abap_true.
  ELSE. " ELSE -> IF fp_hd_cond EQ abap_true
*& Incase of Item condition delete header condition
    DELETE li_t685a WHERE kkopf EQ abap_true.
  ENDIF. " IF fp_hd_cond EQ abap_true

  IF NOT fp_i_cond[] IS INITIAL.
    SELECT * FROM t685t " Conditions: Types: Texts
      INTO TABLE li_t685t
      FOR ALL ENTRIES IN fp_i_cond
      WHERE
      spras = sy-langu
      AND kschl EQ fp_i_cond-key+0(4).
  ENDIF. " IF NOT fp_i_cond[] IS INITIAL

  LOOP AT fp_i_fieldcat REFERENCE INTO lr_fcat.
    IF lr_fcat->fieldname EQ c_kschl.
      lr_fcat->drdn_field = c_kschl.
      lr_fcat->drdn_hndl = 1.
      lr_fcat->outputlen = 30.
      lr_fcat->drdn_alias = abap_true.
    ENDIF. " IF lr_fcat->fieldname EQ c_kschl

  ENDLOOP. " LOOP AT fp_i_fieldcat REFERENCE INTO lr_fcat
  CREATE DATA:
               lr_t685a.
  LOOP AT li_t685t REFERENCE INTO lr_t685t.
    READ TABLE li_t685a REFERENCE INTO lr_t685a WITH TABLE KEY kschl COMPONENTS kschl = lr_t685t->kschl.
    IF sy-subrc = 0.
      lst_dropdown-handle = 1.
      CONCATENATE lr_t685a->kschl lr_t685t->vtext  INTO lst_dropdown-value
      SEPARATED BY space.
      APPEND lst_dropdown TO li_dropdown.
      CLEAR lst_dropdown.
    ENDIF. " IF sy-subrc = 0

  ENDLOOP. " LOOP AT li_t685t REFERENCE INTO lr_t685t
  IF li_dropdown IS NOT INITIAL.
    CALL METHOD fp_r_cond_grid->set_drop_down_table
      EXPORTING
        it_drop_down = li_dropdown. " ALV Control: Dropdown List Boxes

  ENDIF. " IF li_dropdown IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_SALES_DOCUMENT
*&---------------------------------------------------------------------*
*       Save Sales Document
*----------------------------------------------------------------------*
FORM f_save_sales_document .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_REJECTION_REASON
*&---------------------------------------------------------------------*
*       Update rejection reason
*----------------------------------------------------------------------*
*      -->FP_LR_CANCEL  text
*      <--FP_I_MESSAGE  text
*      <--FP_I_XVBFS  text
*----------------------------------------------------------------------*
FORM f_update_rejection_reason  USING    fp_lr_cancel  TYPE REF TO ty_cancel " Cancel class
                               CHANGING  fp_i_messages TYPE tdt_sdoc_msg
                                         fp_i_vbfs     TYPE tt_t_vbfs.
  DATA: li_return      TYPE TABLE OF bapiret2,            " Return Parameter
        lv_text        TYPE string,
        li_item_in     TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        lst_item_in    TYPE  bapisditm,                   " Communication Fields: Sales and Distribution Document Item
        lst_item_inx   TYPE  bapisditmx,                  " Communication Fields: Sales and Distribution Document Item
        li_item_inx    TYPE STANDARD TABLE OF bapisditmx, " Item details
        lr_return      TYPE REF TO bapiret2,              " reference variable for Retrun message
        lst_header_inx TYPE bapisdhd1x.                   " Checkbox Fields for Sales and Distribution Document Header

  READ TABLE i_cancel_final INTO DATA(lst_cancel_final) INDEX 1.
  IF sy-subrc EQ 0.
    DATA(lv_rej_reason) = lst_cancel_final-vkuegru+0(2).
  ENDIF. " IF sy-subrc EQ 0
  lst_item_in-itm_number = fp_lr_cancel->posnr.
*  lst_item_in-reason_rej = fp_lr_cancel->vkuegru+0(2).
  lst_item_in-reason_rej = lv_rej_reason.
  APPEND lst_item_in TO li_item_in.

  CLEAR lst_item_in.
*   Populate the itemx table
  lst_item_inx-itm_number = fp_lr_cancel->posnr.
  lst_item_inx-reason_rej = abap_true.
  lst_item_inx-updateflag = c_update.
  APPEND lst_item_inx TO li_item_inx.
  CLEAR lst_item_inx.
  lst_header_inx-updateflag = c_update.
  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument    = fp_lr_cancel->vbeln
      order_header_inx = lst_header_inx
    TABLES
      return           = li_return
      item_in          = li_item_in
      item_inx         = li_item_inx.
  LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                        OR type = c_abend. " Or of type

    PERFORM f_populate_message USING fp_lr_cancel->vbeln
                                     fp_lr_cancel->posnr
                                     lr_return
                               CHANGING  fp_i_vbfs
                                         fp_i_messages.
  ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0.
      CLEAR lv_text.
      MESSAGE s097(zqtc_r2) WITH fp_lr_cancel->vbeln fp_lr_cancel->posnr " Rejection Reason updated for Order & Item &
      INTO lv_text.
      IF NOT lv_text IS INITIAL.
        MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
        MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
        MOVE sy-msgty      TO lr_return->type. "Messageart
        MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
        MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
        MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
        MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        PERFORM f_populate_message USING fp_lr_cancel->vbeln
                                         fp_lr_cancel->posnr
                                         lr_return
                                   CHANGING  fp_i_vbfs
                                             fp_i_messages.
      ENDIF. " IF NOT lv_text IS INITIAL

    ENDIF. " IF sy-subrc = 0
  ELSE. " ELSE -> IF sy-subrc <> 0
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_ALV_BILBLK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_alv_bilblk.

  CLEAR i_fieldcat_bilblk.
  IF r_docking_bill IS INITIAL.
*create a docking container and dock the control at the botton
    CREATE OBJECT r_docking_bill
      EXPORTING
        dynnr     = c_9010
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.

*create the alv grid for display the table
    CREATE OBJECT r_bill_grid
      EXPORTING
        i_parent = r_docking_bill.

*create custome container for alv
    CREATE OBJECT r_bill_blk
      EXPORTING
        container_name = c_bill_cont.
**create alv editable grid
*    CREATE OBJECT r_bill_editalvgd
*      EXPORTING
*        i_parent = r_bill_blk.

* Building the fieldcatalogue for the initial display
    IF i_fieldcat_bilblk[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fieldcat_bilblk.
    ENDIF. " IF i_fieldcat_bilblk[] IS INITIAL

    IF i_excl_func[] IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.
    ENDIF. " IF i_excl_func[] IS INITIAL

    PERFORM f_get_data_faksk CHANGING i_tvfs.

    PERFORM f_fetch_data_faksk USING i_sel_rows
                                     <i_result>
                               CHANGING i_faksk.

    PERFORM f_dropdown_bill USING i_tvfs
                         CHANGING r_bill_grid
                                  i_fieldcat_bilblk.

* optimize column width of grid displaying fieldcatalog
    i_layout_par-cwidth_opt = 'X'.
    CALL METHOD r_bill_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fieldcat_bilblk. " Field Catalog

*Alv display for the T006 table at the bottom
    i_faksk_final = i_faksk[].
    DATA(lv_count) = lines( i_faksk_final ).
    IF lv_count > 1.
      DELETE i_faksk_final FROM 2 TO lv_count.
    ENDIF. " IF lv_count > 1
    CALL METHOD r_bill_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
        is_layout            = i_layout_par
      CHANGING
        it_outtab            = i_faksk_final
        it_fieldcatalog      = i_fieldcat_bilblk[].
* set editable cells to ready for input
    CALL METHOD r_bill_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_bill_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.
  ENDIF. " IF r_docking_bill IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DROPDOWN_BILL
*&---------------------------------------------------------------------*
*       Dropdown populate for billing block
*----------------------------------------------------------------------*
FORM f_dropdown_bill  USING    fp_i_tvfs      TYPE tt_tvfs
                      CHANGING fp_r_grid TYPE REF TO cl_gui_alv_grid " ALV List Viewer
                               fp_i_fieldcat  TYPE lvc_t_fcat.

* Type declaration
  TYPES : BEGIN OF lty_tvfst,
            spras TYPE spras,       " Language Key
            faksp TYPE faksp,       " Block
            vtext TYPE bezei_faksp, " Description
          END OF lty_tvfst.

  DATA : lr_fieldcat TYPE REF TO lvc_s_fcat, " S_fcat class
         li_tvfst    TYPE STANDARD TABLE OF lty_tvfst
                       WITH NON-UNIQUE SORTED KEY faksp COMPONENTS faksp,
         lr_tvfst    TYPE REF TO lty_tvfst,  " Tvlst class
         li_dropdown TYPE lvc_t_drop,
         ls_dropdown TYPE lvc_s_drop.        " ALV Control: Dropdown List Boxes

  IF fp_i_tvfs[] IS NOT INITIAL.
    SELECT spras " Language Key
           faksp " Default delivery block
           vtext " Description
      INTO TABLE li_tvfst
      FROM tvfst " Deliveries: Blocking Reasons/Scope: Texts
      FOR ALL ENTRIES IN fp_i_tvfs
      WHERE spras = sy-langu
      AND  faksp = fp_i_tvfs-faksp.
    IF sy-subrc EQ 0.
      LOOP AT li_tvfst REFERENCE INTO lr_tvfst.
        ls_dropdown-handle = 1.
        CONCATENATE lr_tvfst->faksp lr_tvfst->vtext  INTO ls_dropdown-value
        SEPARATED BY space.
        APPEND ls_dropdown TO li_dropdown.
        CLEAR ls_dropdown.
      ENDLOOP. " LOOP AT li_tvfst REFERENCE INTO lr_tvfst

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_tvfs[] IS NOT INITIAL

  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_faksk.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_faksk.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 40.
  ENDIF. " IF sy-subrc = 0

  IF li_dropdown[] IS NOT INITIAL.
    CALL METHOD fp_r_grid->set_drop_down_table
      EXPORTING
        it_drop_down = li_dropdown. " Dropdown Table
  ENDIF. " IF li_dropdown[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_DELV_BLOCK
*&---------------------------------------------------------------------*
*      Update delivery block
*----------------------------------------------------------------------*
FORM f_update_delv_block  USING    fp_i_lifsk_final TYPE tt_lifsk
                          CHANGING fp_i_message TYPE tdt_sdoc_msg
                                   fp_i_xvbfs TYPE tt_t_vbfs
                                   fp_i_lifsk TYPE tt_lifsk.

  DATA : li_return     TYPE bapiret2_t,      " Return value table
         lst_lifsk     TYPE ty_lifsk,
         lr_return     TYPE REF TO bapiret2, " BAPI Return Messages
         lst_bapisdh1  TYPE bapisdh1,        " Communication Fields: SD Order Header
         lst_bapisdh1x TYPE bapisdh1x,       " Checkbox List: SD Order Header
         lst_message   TYPE tds_sdoc_msg,    " Sales Document Selection: Messages
         lst_xvbfs     TYPE vbfs,            " Error Log for Collective Processing
         lv_text       TYPE string.          " Text

  DELETE ADJACENT DUPLICATES FROM fp_i_lifsk COMPARING vbeln.
  LOOP AT fp_i_lifsk INTO lst_lifsk.
    READ TABLE fp_i_lifsk_final INTO DATA(lst_lifsk_final) INDEX 1.
    IF sy-subrc EQ 0.
* Populating value in structures
      lst_bapisdh1-dlv_block  = lst_lifsk_final-lifsk+0(2). " Billing block remove
      lst_bapisdh1x-updateflag = c_update. " update flag on
      lst_bapisdh1x-dlv_block = abap_true. " update flag on for billing block

* Calling FM to update billing block according to user input
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lst_lifsk-vbeln " Sales Document
          order_header_in  = lst_bapisdh1    " Order Header
          order_header_inx = lst_bapisdh1x   " SD Header Check
        TABLES
          return           = li_return.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_error.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
      IF sy-subrc = 0 AND lr_return IS BOUND .
        CLEAR lv_text.
        MESSAGE s215(zqtc_r2) WITH lst_lifsk-vbeln INTO lv_text. " Delivery Block updated for Order &
        IF lv_text IS NOT INITIAL.
          MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
          MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
          MOVE sy-msgty      TO lr_return->type. "Messageart
          MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
          MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
          MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
          MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        ENDIF. " IF lv_text IS NOT INITIAL
        IF lr_return->type = c_error OR
           lr_return->type = c_abend.
          "Position
          MOVE lst_lifsk-vbeln TO lst_xvbfs-vbeln. "Belegnummer
          MOVE lr_return->id      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
          MOVE lr_return->number  TO lst_xvbfs-msgno. "Nachrichtennummer
          MOVE lr_return->type      TO lst_xvbfs-msgty. "Messageart
          MOVE lr_return->message_v1      TO lst_xvbfs-msgv1. "Messagevariable 1
          MOVE lr_return->message_v2      TO lst_xvbfs-msgv2. "Messagevariable 2
          MOVE lr_return->message_v3      TO lst_xvbfs-msgv3. "Messagevariable 3
          MOVE lr_return->message_v4      TO lst_xvbfs-msgv4. "Messagevariable 4
          APPEND lst_xvbfs TO fp_i_xvbfs.

        ENDIF. " IF lr_return->type = c_error OR

        MOVE lr_return->id      TO lst_message-msgid. "Nachrichtenidentifikation
        MOVE lr_return->number      TO lst_message-msgno. "Nachrichtennummer
        MOVE lr_return->type      TO lst_message-msgty. "Messageart
        MOVE lr_return->message_v1      TO lst_message-msgv1. "Messagevariable 1
        MOVE lr_return->message_v2      TO lst_message-msgv2. "Messagevariable 2
        MOVE lr_return->message_v3      TO lst_message-msgv3. "Messagevariable 3
        MOVE lr_return->message_v4      TO lst_message-msgv4. "Messagevariable 4
        APPEND lst_message TO fp_i_message.
        CLEAR lst_message.

      ENDIF. " IF sy-subrc = 0 AND lr_return IS BOUND

    ENDIF. " IF sy-subrc <> 0
  ENDLOOP. " LOOP AT fp_i_lifsk INTO lst_lifsk
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_BILL_BLOCK
*&---------------------------------------------------------------------*
*       Update Billing block
*----------------------------------------------------------------------*
FORM f_update_bill_block  USING    fp_i_faksk_final   TYPE tt_faksk
                          CHANGING fp_i_message TYPE tdt_sdoc_msg
                                   fp_i_faksk TYPE tt_faksk
                                   fp_i_xvbfs TYPE tt_t_vbfs.

  DATA : li_return     TYPE bapiret2_t,      " Return value table
         lst_faksk     TYPE ty_faksk,
         lr_return     TYPE REF TO bapiret2, " BAPI Return Messages
         lst_bapisdh1  TYPE bapisdh1,        " Communication Fields: SD Order Header
         lst_bapisdh1x TYPE bapisdh1x,       " Checkbox List: SD Order Header
         lst_message   TYPE tds_sdoc_msg,    " Sales Document Selection: Messages
         lst_xvbfs     TYPE vbfs,            " Error Log for Collective Processing
         lv_text       TYPE string.          " Text

  DELETE ADJACENT DUPLICATES FROM fp_i_faksk COMPARING vbeln.
  LOOP AT fp_i_faksk INTO lst_faksk.
    READ TABLE fp_i_faksk_final INTO DATA(lst_faksk_final) INDEX 1.
    IF sy-subrc EQ 0.
* Populating value in structures
      lst_bapisdh1-bill_block  = lst_faksk_final-faksk+0(2). " Billing block remove
      lst_bapisdh1x-updateflag = c_update. " update flag on
      lst_bapisdh1x-bill_block = abap_true. " update flag on for billing block

* Calling FM to update billing block according to user input
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lst_faksk-vbeln " Sales Document
          order_header_in  = lst_bapisdh1    " Order Header
          order_header_inx = lst_bapisdh1x   " SD Header Check
        TABLES
          return           = li_return.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_error.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
      IF sy-subrc = 0 AND lr_return IS BOUND .
        CLEAR lv_text.
        MESSAGE s214(zqtc_r2) WITH lst_faksk-vbeln INTO lv_text. " Billing Block updated for Order &
        IF lv_text IS NOT INITIAL.
          MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
          MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
          MOVE sy-msgty      TO lr_return->type. "Messageart
          MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
          MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
          MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
          MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        ENDIF. " IF lv_text IS NOT INITIAL
        IF lr_return->type = c_error OR
           lr_return->type = c_abend.
          "Position
          MOVE lst_faksk-vbeln TO lst_xvbfs-vbeln. "Belegnummer
          MOVE lr_return->id      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
          MOVE lr_return->number  TO lst_xvbfs-msgno. "Nachrichtennummer
          MOVE lr_return->type      TO lst_xvbfs-msgty. "Messageart
          MOVE lr_return->message_v1      TO lst_xvbfs-msgv1. "Messagevariable 1
          MOVE lr_return->message_v2      TO lst_xvbfs-msgv2. "Messagevariable 2
          MOVE lr_return->message_v3      TO lst_xvbfs-msgv3. "Messagevariable 3
          MOVE lr_return->message_v4      TO lst_xvbfs-msgv4. "Messagevariable 4
          APPEND lst_xvbfs TO fp_i_xvbfs.

        ENDIF. " IF lr_return->type = c_error OR

        MOVE lr_return->id      TO lst_message-msgid. "Nachrichtenidentifikation
        MOVE lr_return->number      TO lst_message-msgno. "Nachrichtennummer
        MOVE lr_return->type      TO lst_message-msgty. "Messageart
        MOVE lr_return->message_v1      TO lst_message-msgv1. "Messagevariable 1
        MOVE lr_return->message_v2      TO lst_message-msgv2. "Messagevariable 2
        MOVE lr_return->message_v3      TO lst_message-msgv3. "Messagevariable 3
        MOVE lr_return->message_v4      TO lst_message-msgv4. "Messagevariable 4
        APPEND lst_message TO fp_i_message.
        CLEAR lst_message.

      ENDIF. " IF sy-subrc = 0 AND lr_return IS BOUND
    ENDIF. " IF sy-subrc <> 0
  ENDLOOP. " LOOP AT fp_i_faksk INTO lst_faksk

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_LIFSK
*&---------------------------------------------------------------------*
*       Get data for LIFSK
*----------------------------------------------------------------------*
FORM f_fetch_data_faksk  USING    fp_i_sel_rows TYPE salv_t_row
                                  fp_i_result TYPE STANDARD TABLE
                         CHANGING fp_i_faksk TYPE tt_faksk.
  DATA lr_faksk TYPE REF TO ty_faksk. " Partner class

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_faksk>   TYPE vbak-faksk, " Sales Document Item
                  <lst_result> TYPE any.

  CREATE DATA lr_faksk.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_faksk->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
*      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-faksk OF   STRUCTURE <lst_result> TO <lv_faksk>.
*      IF <lv_faksk> IS ASSIGNED.
*        lr_faksk->faksk =  <lv_faksk>.
*        UNASSIGN <lv_faksk>.
*      ENDIF. " IF <lv_faksk> IS ASSIGNED
      APPEND lr_faksk->* TO fp_i_faksk.
      CLEAR lr_faksk->*.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_ALV_DELVBLK
*&---------------------------------------------------------------------*
* Processing Fieldcatalog and dispaly dropdown
*----------------------------------------------------------------------*
FORM f_create_alv_delvblk.

  CLEAR i_fieldcat_dlvblk.
  IF r_docking_delv IS INITIAL.
*create a docking container and dock the control at the botton
    CREATE OBJECT r_docking_delv
      EXPORTING
        dynnr     = c_9011
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.

*create the alv grid for display the table
    CREATE OBJECT r_delv_grid
      EXPORTING
        i_parent = r_docking_delv.

*create custome container for alv
    CREATE OBJECT r_delv_blk
      EXPORTING
        container_name = c_delv_cont.
*create alv editable grid
    CREATE OBJECT r_delv_editalvgd
      EXPORTING
        i_parent = r_delv_blk.

* Building the fieldcatalogue for the initial display
    IF i_fieldcat_dlvblk[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fieldcat_dlvblk.
    ENDIF. " IF i_fieldcat_dlvblk[] IS INITIAL

    IF i_excl_func[] IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.
    ENDIF. " IF i_excl_func[] IS INITIAL


    PERFORM f_fetch_data_lifsk USING i_sel_rows
                                         <i_result>
                                   CHANGING i_lifsk.

    PERFORM f_dropdown_delv USING i_list
                         CHANGING r_delv_grid
                                  i_fieldcat_dlvblk.

* optimize column width of grid displaying fieldcatalog
    i_layout_par-cwidth_opt = 'X'.
    CALL METHOD r_delv_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fieldcat_dlvblk. " Field Catalog

*Alv display for the T006 table at the bottom
    i_lifsk_final[] = i_lifsk[].
    DATA(lv_count) = lines( i_lifsk_final ).
    IF lv_count > 1.
      DELETE i_lifsk_final FROM 2 TO lv_count.
    ENDIF. " IF lv_count > 1
    CALL METHOD r_delv_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
        is_layout            = i_layout_par
      CHANGING
        it_outtab            = i_lifsk_final
        it_fieldcatalog      = i_fieldcat_dlvblk[].
* set editable cells to ready for input
    CALL METHOD r_delv_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_delv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  ENDIF. " IF r_docking_delv IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_LIFSK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEL_ROWS  text
*      -->P_<I_RESULT>  text
*      <--P_I_LIFSK  text
*----------------------------------------------------------------------*
FORM f_fetch_data_lifsk  USING    fp_i_sel_rows TYPE salv_t_row
                                  fp_i_result TYPE STANDARD TABLE
                         CHANGING fp_i_lifsk TYPE tt_lifsk.

  DATA lr_lifsk TYPE REF TO ty_lifsk. " Partner class

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbak-vbeln, " Sales Document
                  <lv_lifsk>   TYPE vbak-lifsk, " Sales Document Item
                  <lst_result> TYPE any.

  CREATE DATA lr_lifsk.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_lifsk->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED
      APPEND lr_lifsk->* TO fp_i_lifsk.
      CLEAR lr_lifsk->*.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DROPDOWN_DELV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_LIST  text
*      <--P_R_DELV_GRID  text
*      <--P_I_FIELDCAT_DLVBLK  text
*----------------------------------------------------------------------*
FORM f_dropdown_delv  USING    fp_i_list      TYPE vrm_values
                      CHANGING fp_r_grid TYPE REF TO cl_gui_alv_grid " ALV List Viewer
                               fp_i_fieldcat  TYPE lvc_t_fcat.

* Type declaration
  TYPES : BEGIN OF lty_tvlst,
            spras TYPE spras,       " Language Key
            lifsp TYPE lifsp,       " Default delivery block
            vtext TYPE bezei_lifsp, " Description
          END OF lty_tvlst.

  DATA : lr_fieldcat TYPE REF TO lvc_s_fcat, " S_fcat class
         li_tvlst    TYPE STANDARD TABLE OF lty_tvlst
                       WITH NON-UNIQUE SORTED KEY lifsp COMPONENTS lifsp,
         lr_tvlst    TYPE REF TO lty_tvlst,  " Tvlst class
         li_dropdown TYPE lvc_t_drop,
         ls_dropdown TYPE lvc_s_drop.        " ALV Control: Dropdown List Boxes

  IF fp_i_list[] IS NOT INITIAL.
    SELECT spras " Language Key
           lifsp " Default delivery block
           vtext " Description
      INTO TABLE li_tvlst
      FROM tvlst " Deliveries: Blocking Reasons/Scope: Texts
      FOR ALL ENTRIES IN fp_i_list
      WHERE spras = sy-langu
      AND  lifsp = fp_i_list-key+0(2).
    IF sy-subrc EQ 0.
      LOOP AT li_tvlst REFERENCE INTO lr_tvlst.
        ls_dropdown-handle = 1.
        CONCATENATE lr_tvlst->lifsp lr_tvlst->vtext  INTO ls_dropdown-value
        SEPARATED BY space.
        APPEND ls_dropdown TO li_dropdown.
        CLEAR ls_dropdown.
      ENDLOOP. " LOOP AT li_tvlst REFERENCE INTO lr_tvlst

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_list[] IS NOT INITIAL

  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_lifsk.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_lifsk.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 40.
  ENDIF. " IF sy-subrc = 0

  IF li_dropdown[] IS NOT INITIAL.
    CALL METHOD fp_r_grid->set_drop_down_table
      EXPORTING
        it_drop_down = li_dropdown. " Dropdown Table
  ENDIF. " IF li_dropdown[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_ALV_CUSTGRP
*&---------------------------------------------------------------------*
*  Customer group
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_alv_custgrp.
  CLEAR r_docking_cust.
  IF r_docking_cust IS INITIAL.
*create a docking container and dock the control at the botton
    CREATE OBJECT r_docking_cust
      EXPORTING
        dynnr     = c_9012
        extension = 1000
        side      = cl_gui_docking_container=>dock_at_left.

*create the alv grid for display the table
    CREATE OBJECT r_cust_grid
      EXPORTING
        i_parent = r_docking_cust.

*create custome container for alv
    CREATE OBJECT r_cust_grp
      EXPORTING
        container_name = c_memb_cont.
*create alv editable grid
    CREATE OBJECT r_cust_editalvgd
      EXPORTING
        i_parent = r_cust_grp.

* Building the fieldcatalogue for the initial display
    IF i_fieldcat_cstgrp[] IS  INITIAL.
      PERFORM f_build_fieldcat  USING sy-dynnr
                                CHANGING i_fieldcat_cstgrp.
    ENDIF. " IF i_fieldcat_cstgrp[] IS INITIAL

    IF i_excl_func[] IS INITIAL.
      PERFORM f_exclude_function CHANGING i_excl_func.
    ENDIF. " IF i_excl_func[] IS INITIAL

    PERFORM f_fetch_data_kdkg2 USING i_sel_rows
                                     <i_result>
                            CHANGING i_kdkg2.

    PERFORM f_dropdown_custgrp USING i_list
                            CHANGING r_cust_grid
                                     i_fieldcat_cstgrp.


* optimize column width of grid displaying fieldcatalog
    i_layout_par-cwidth_opt = 'X'.
    CALL METHOD r_cust_grid->set_frontend_fieldcatalog
      EXPORTING
        it_fieldcatalog = i_fieldcat_cstgrp. " Field Catalog

*Alv display for the T006 table at the bottom
    i_kdkg2_final[] = i_kdkg2[].
    DATA(lv_count) = lines( i_kdkg2_final ).
    IF lv_count > 1.
      DELETE i_kdkg2_final FROM 2 TO lv_count.
    ENDIF. " IF lv_count > 1

    CALL METHOD r_cust_grid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = i_excl_func
        is_layout            = i_layout_par
      CHANGING
        it_outtab            = i_kdkg2_final
        it_fieldcatalog      = i_fieldcat_cstgrp[].

* set editable cells to ready for input
    CALL METHOD r_cust_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
    CALL METHOD r_cust_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  ENDIF. " IF r_docking_cust IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DROPDOWN_CUSTGRP
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
*      -->P_I_LIST  text
*      <--P_R_CUST_GRID  text
*      <--P_I_FIELDCAT_CSTGRP  text
*----------------------------------------------------------------------*
FORM f_dropdown_custgrp  USING    fp_i_list       TYPE vrm_values
                         CHANGING fp_r_cust_grid  TYPE REF TO cl_gui_alv_grid " ALV List Viewer
                                  fp_i_fieldcat    TYPE lvc_t_fcat.

* Type declaration
  TYPES : BEGIN OF lty_tvkgg,
            spras TYPE spras, " Language Key
            kdkgr TYPE kdkgr, " Default delivery block
            vtext TYPE vtext, " Description
          END OF lty_tvkgg.

* Data declaration
  DATA : lr_fieldcat TYPE REF TO lvc_s_fcat, " S_fcat class
         li_tvkgg    TYPE STANDARD TABLE OF lty_tvkgg
                       WITH NON-UNIQUE SORTED KEY kdkgr COMPONENTS kdkgr,
         lr_tvkgg    TYPE REF TO lty_tvkgg,  " Tvlst class
         li_dropdown TYPE lvc_t_drop,
         ls_dropdown TYPE lvc_s_drop.        " ALV Control: Dropdown List Boxes

  IF fp_i_list[] IS NOT INITIAL.
    SELECT spras  " Language Key
           kdkgr  " Default delivery block
           vtext  " Description
      INTO TABLE li_tvkgg
      FROM tvkggt " Deliveries: Blocking Reasons/Scope: Texts
      FOR ALL ENTRIES IN fp_i_list
      WHERE spras = sy-langu
      AND  kdkgr  = fp_i_list-key+0(2).

    IF sy-subrc EQ 0.
      LOOP AT li_tvkgg REFERENCE INTO lr_tvkgg.
        ls_dropdown-handle = 1.
        CONCATENATE lr_tvkgg->kdkgr lr_tvkgg->vtext  INTO ls_dropdown-value
        SEPARATED BY space.
        APPEND ls_dropdown TO li_dropdown.
        CLEAR ls_dropdown.
      ENDLOOP. " LOOP AT li_tvkgg REFERENCE INTO lr_tvkgg

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_list[] IS NOT INITIAL

  READ TABLE fp_i_fieldcat REFERENCE INTO  lr_fieldcat WITH KEY fieldname = c_kdkg2.
  IF sy-subrc = 0.
    lr_fieldcat->drdn_field = c_kdkg2.
    lr_fieldcat->drdn_hndl = 1.
    lr_fieldcat->outputlen = 30.
  ENDIF. " IF sy-subrc = 0

  IF li_dropdown[] IS NOT INITIAL.
    CALL METHOD fp_r_cust_grid->set_drop_down_table
      EXPORTING
        it_drop_down = li_dropdown. " Dropdown Table
  ENDIF. " IF li_dropdown[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA_KDKG2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEL_ROWS  text
*      -->P_<I_RESULT>  text
*      <--P_I_KDKG2  text
*----------------------------------------------------------------------*
FORM f_fetch_data_kdkg2  USING    fp_i_sel_rows TYPE salv_t_row
                                  fp_i_result TYPE STANDARD TABLE
                         CHANGING fp_i_kdkg2 TYPE tt_kdkg2.

  DATA lr_kdkg2 TYPE REF TO ty_kdkg2. " Kdkg2 class

  FIELD-SYMBOLS : <lv_vbeln>   TYPE vbkd-vbeln, " Sales Document
                  <lv_posnr>   TYPE vbkd-posnr, " Item Number
                  <lv_kdkg2>   TYPE vbkd-kdkg2, " Sales Document Item
                  <lst_result> TYPE any.

  CREATE DATA lr_kdkg2.
  LOOP AT fp_i_sel_rows INTO st_sel_row.
    READ TABLE fp_i_result ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF   STRUCTURE <lst_result> TO <lv_vbeln>.
      IF <lv_vbeln> IS ASSIGNED.
        lr_kdkg2->vbeln = <lv_vbeln>.
        UNASSIGN <lv_vbeln>.
      ENDIF. " IF <lv_vbeln> IS ASSIGNED

      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF   STRUCTURE <lst_result> TO <lv_posnr>.
      IF <lv_posnr> IS ASSIGNED.
        lr_kdkg2->posnr = <lv_posnr>.
        UNASSIGN <lv_posnr>.
      ENDIF. " IF <lv_posnr> IS ASSIGNED
      APPEND lr_kdkg2->* TO fp_i_kdkg2.
      CLEAR lr_kdkg2->*.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_i_sel_rows INTO st_sel_row
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_FAKSK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_APPLICATION  text
*      <--P_I_TVFS  text
*----------------------------------------------------------------------*
FORM f_get_data_faksk CHANGING fp_i_tvfs TYPE tt_tvfs.
*   In case of screen 9010(Billing Block)
*     Select all the values of delivery block from value table TVLS
  SELECT faksp " Block
  FROM tvfs    " Billing: Reasons for Blocking
  INTO TABLE i_tvfs.
  IF sy-subrc EQ 0.
*        Do nothing
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LICN_GRP
*&---------------------------------------------------------------------*
*   Update licence group
*----------------------------------------------------------------------*
*      -->P_V_LICN_GRP  text
*----------------------------------------------------------------------*
FORM f_update_licn_grp  USING fp_v_licn_grp TYPE vbak-zzlicgrp. " License Group

  FIELD-SYMBOLS <lst_result> TYPE any.
  LOOP AT i_sel_rows INTO st_sel_row.
    READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc EQ 0.
      UNASSIGN <v_vbeln>.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF STRUCTURE <lst_result> TO <v_vbeln>.
      IF <v_vbeln> IS ASSIGNED.
        v_vbeln = <v_vbeln>.
        PERFORM f_change_lic_grp USING fp_v_licn_grp
                                       v_vbeln
                              CHANGING i_xvbfs
                                       i_messages.

      ENDIF. " IF <v_vbeln> IS ASSIGNED
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT i_sel_rows INTO st_sel_row

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_LIC_GRP
*&---------------------------------------------------------------------*
*  Update sales order with Licence group
*----------------------------------------------------------------------*
*      -->P_FP_V_LICN_GRP  text
*      -->P_V_VBELN  text
*----------------------------------------------------------------------*
FORM f_change_lic_grp  USING fp_v_licn_grp  TYPE vbak-zzlicgrp " License Group
                             fp_v_vbeln     TYPE vbak-vbeln    " Sales Document
                     CHANGING fp_i_xvbfs    TYPE tt_t_vbfs
                              fp_i_messages TYPE tdt_sdoc_msg.

  CONSTANTS : lc_bape_vbak  TYPE te_struc VALUE 'BAPE_VBAK',  " Structure name of  BAPI table extension
              lc_bape_vbakx TYPE te_struc VALUE 'BAPE_VBAKX'. " constant table name for Extension

  DATA:
    lst_header_inx  TYPE bapisdh1x,                     " Checkbox List: SD Order Header
    li_return       TYPE TABLE OF bapiret2,             " Return Messages
    lr_return       TYPE REF TO bapiret2,               " BAPI Return Messages
    lst_bape_vbak   TYPE bape_vbak,                     " BAPI Interface for Customer Enhancements to Table VBAP
    lst_bape_vbakx  TYPE bape_vbakx,                    " BAPI Checkbox for Customer Enhancments to Table VBAP
    lst_extensionin TYPE  bapiparex,                    " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
    li_extensionin  TYPE   STANDARD TABLE OF bapiparex, " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
    lst_message     TYPE tds_sdoc_msg,                  " Sales Document Selection: Messages
    lst_xvbfs       TYPE vbfs,                          " Error Log for Collective Processing
    lv_text         TYPE string.                        " Text

  lst_header_inx-updateflag = c_update.
*   Populate the extension table populate the value
  lst_extensionin-structure   = lc_bape_vbak.
  lst_bape_vbak-vbeln         = fp_v_vbeln.
  lst_bape_vbak-zzlicgrp      = fp_v_licn_grp.

  CALL METHOD cl_abap_container_utilities=>fill_container_c
    EXPORTING
      im_value     = lst_bape_vbak
    IMPORTING
      ex_container = lst_extensionin-valuepart1.
  APPEND lst_extensionin TO li_extensionin.
  CLEAR lst_extensionin.

*   Populate the Check box
  lst_extensionin-structure       = lc_bape_vbakx.
  lst_bape_vbakx-vbeln            = fp_v_vbeln.
  lst_bape_vbakx-zzlicgrp         = abap_true.
  CALL METHOD cl_abap_container_utilities=>fill_container_c
    EXPORTING
      im_value     = lst_bape_vbakx
    IMPORTING
      ex_container = lst_extensionin-valuepart1.

  APPEND lst_extensionin TO li_extensionin.
  CLEAR  lst_extensionin.

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = fp_v_vbeln
      order_header_inx = lst_header_inx
    TABLES
      return           = li_return
      extensionin      = li_extensionin.

  READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_error.
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0 AND lr_return IS BOUND .
      CLEAR lv_text.
      MESSAGE s224(zqtc_r2) WITH fp_v_vbeln INTO lv_text. " Licence Group updated for Order &
      IF lv_text IS NOT INITIAL.
        MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
        MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
        MOVE sy-msgty      TO lr_return->type. "Messageart
        MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
        MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
        MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
        MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
      ENDIF. " IF lv_text IS NOT INITIAL
      IF lr_return->type = c_error OR
         lr_return->type = c_abend.
        "Position
        MOVE fp_v_vbeln TO lst_xvbfs-vbeln. "Belegnummer
        MOVE lr_return->id      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
        MOVE lr_return->number  TO lst_xvbfs-msgno. "Nachrichtennummer
        MOVE lr_return->type      TO lst_xvbfs-msgty. "Messageart
        MOVE lr_return->message_v1      TO lst_xvbfs-msgv1. "Messagevariable 1
        MOVE lr_return->message_v2      TO lst_xvbfs-msgv2. "Messagevariable 2
        MOVE lr_return->message_v3      TO lst_xvbfs-msgv3. "Messagevariable 3
        MOVE lr_return->message_v4      TO lst_xvbfs-msgv4. "Messagevariable 4
        APPEND lst_xvbfs TO fp_i_xvbfs.

      ENDIF. " IF lr_return->type = c_error OR

      MOVE lr_return->id      TO lst_message-msgid. "Nachrichtenidentifikation
      MOVE lr_return->number      TO lst_message-msgno. "Nachrichtennummer
      MOVE lr_return->type      TO lst_message-msgty. "Messageart
      MOVE lr_return->message_v1      TO lst_message-msgv1. "Messagevariable 1
      MOVE lr_return->message_v2      TO lst_message-msgv2. "Messagevariable 2
      MOVE lr_return->message_v3      TO lst_message-msgv3. "Messagevariable 3
      MOVE lr_return->message_v4      TO lst_message-msgv4. "Messagevariable 4
      APPEND lst_message TO fp_i_messages.
      CLEAR lst_message.

    ENDIF. " IF sy-subrc = 0 AND lr_return IS BOUND

  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_CUST_BLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_update_cust_block  USING    fp_i_kdkg2       TYPE tt_kdkg2
                                   fp_i_kdkg2_final TYPE tt_kdkg2
                          CHANGING fp_i_xvbfs      TYPE tt_t_vbfs
                                   fp_i_message    TYPE tdt_sdoc_msg.

  DATA : li_return     TYPE bapiret2_t,                   " Return value table
         lr_return     TYPE REF TO bapiret2,              " BAPI Return Messages
         lst_bapisdh1x TYPE bapisdh1x,                    " Checkbox List: SD Order Header
         lst_message   TYPE tds_sdoc_msg,                 " Sales Document Selection: Messages
         lst_xvbfs     TYPE vbfs,                         " Error Log for Collective Processing
         lst_item_in   TYPE  bapisditm,                   " Communication Fields: Sales and Distribution Document Item
         li_item_in    TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
         lst_item_inx  TYPE  bapisditmx,                  " Communication Fields: Sales and Distribution Document Item
         li_item_inx   TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
         lv_text       TYPE string.                       "text

  LOOP AT fp_i_kdkg2 INTO DATA(lst_kdkg2).
    READ TABLE fp_i_kdkg2_final INTO DATA(lst_kdkg2_final) INDEX 1.
    IF sy-subrc EQ 0.
* Populating value in structures
      lst_bapisdh1x-updateflag = c_update. " update flag on

*   Populating value in item structure
      lst_item_in-itm_number = lst_kdkg2-posnr.
      lst_item_in-cstcndgrp2 = lst_kdkg2_final-kdkg2+0(2).
      APPEND lst_item_in TO li_item_in.
      CLEAR lst_item_in.

      lst_item_inx-itm_number = lst_kdkg2-posnr.
      lst_item_inx-updateflag = c_update.
      lst_item_inx-cstcndgrp2 = abap_true.
      APPEND lst_item_inx TO li_item_inx.
      CLEAR lst_item_inx.

* Calling FM to update billing block according to user input
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lst_kdkg2-vbeln " Sales Document
          order_header_inx = lst_bapisdh1x   " SD Header Check
        TABLES
          return           = li_return
          order_item_in    = li_item_in
          order_item_inx   = li_item_inx.
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_error.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
      IF sy-subrc = 0 AND lr_return IS BOUND .
        CLEAR lv_text.
        MESSAGE s227(zqtc_r2) WITH lst_kdkg2-vbeln INTO lv_text. " Customer Condition Group 2 updated for order &
        IF lv_text IS NOT INITIAL.
          MOVE sy-msgid      TO lr_return->id. "Nachrichtenidentifikation
          MOVE sy-msgno      TO lr_return->number. "Nachrichtennummer
          MOVE sy-msgty      TO lr_return->type. "Messageart
          MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
          MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
          MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
          MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        ENDIF. " IF lv_text IS NOT INITIAL
        IF lr_return->type = c_error OR
           lr_return->type = c_abend.
          "Position
          MOVE lst_kdkg2-vbeln TO lst_xvbfs-vbeln. "Belegnummer
          MOVE lr_return->id      TO lst_xvbfs-msgid. "Nachrichtenidentifikation
          MOVE lr_return->number  TO lst_xvbfs-msgno. "Nachrichtennummer
          MOVE lr_return->type      TO lst_xvbfs-msgty. "Messageart
          MOVE lr_return->message_v1      TO lst_xvbfs-msgv1. "Messagevariable 1
          MOVE lr_return->message_v2      TO lst_xvbfs-msgv2. "Messagevariable 2
          MOVE lr_return->message_v3      TO lst_xvbfs-msgv3. "Messagevariable 3
          MOVE lr_return->message_v4      TO lst_xvbfs-msgv4. "Messagevariable 4
          APPEND lst_xvbfs TO fp_i_xvbfs.

        ENDIF. " IF lr_return->type = c_error OR

        MOVE lr_return->id      TO lst_message-msgid. "Nachrichtenidentifikation
        MOVE lr_return->number      TO lst_message-msgno. "Nachrichtennummer
        MOVE lr_return->type      TO lst_message-msgty. "Messageart
        MOVE lr_return->message_v1      TO lst_message-msgv1. "Messagevariable 1
        MOVE lr_return->message_v2      TO lst_message-msgv2. "Messagevariable 2
        MOVE lr_return->message_v3      TO lst_message-msgv3. "Messagevariable 3
        MOVE lr_return->message_v4      TO lst_message-msgv4. "Messagevariable 4
        APPEND lst_message TO fp_i_message.
        CLEAR lst_message.

      ENDIF. " IF sy-subrc = 0 AND lr_return IS BOUND
    ENDIF. " IF sy-subrc <> 0
  ENDLOOP. " LOOP AT fp_i_kdkg2 INTO DATA(lst_kdkg2)
ENDFORM.


FORM f_update_billing_date USING    fp_v_billing_date TYPE vbkd-fkdat. " Customer purchase order number

  DATA: lv_h_tabix TYPE sy-tabix,       " Tabix
        lr_vbkd    TYPE REF TO ty_vbkd, " Reference variable
        lst_vbeln  TYPE ty_vbkd1, "/spe/vbeln,
        li_vbeln   TYPE STANDARD TABLE OF ty_vbkd1. "/spe/vbeln_t.

  CONSTANTS lc_yes TYPE char1 VALUE 'Y'. " Yes of type CHAR1
  FIELD-SYMBOLS <lst_result> TYPE any.
  CLEAR: v_flag,v_vbeln.
*
  LOOP AT i_sel_rows INTO st_sel_row.
    READ TABLE <i_result> ASSIGNING <lst_result> INDEX st_sel_row.
    IF sy-subrc = 0.
      UNASSIGN <v_vbeln>.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-vbeln OF STRUCTURE <lst_result> TO <v_vbeln>.
      IF <v_vbeln> IS ASSIGNED.
        lst_vbeln-vbeln = <v_vbeln>.
      ENDIF.
      UNASSIGN <v_posnr>.
      ASSIGN COMPONENT if_sdoc_adapter=>co_fieldname-posnr OF STRUCTURE <lst_result> TO <v_posnr>.
      IF <v_posnr> IS ASSIGNED.
        lst_vbeln-posnr = <v_posnr>.
      ENDIF.
      IF lst_vbeln IS NOT INITIAL.
        APPEND lst_vbeln TO li_vbeln.
        CLEAR lst_vbeln.
      ENDIF.
    ENDIF.
  ENDLOOP.
  SORT li_vbeln BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING vbeln.
  LOOP AT li_vbeln INTO lst_vbeln.

    PERFORM f_change_sales_doc_header_bill  USING  fp_v_billing_date
                                                   lst_vbeln-vbeln
                                                   lst_vbeln-posnr.
  ENDLOOP.


ENDFORM.

FORM f_change_sales_doc_header_bill  USING fp_v_billing_date TYPE vbkd-fkdat " Customer purchase order number
                                           fp_v_vbeln        TYPE vbak-vbeln " Sales Document
                                           fp_v_posnr        TYPE posnr.
  DATA:
    li_return           TYPE TABLE OF bapiret2,  " Return Parameter
    lv_text             TYPE string,
    lr_return           TYPE REF TO bapiret2,    "  class
    lr_order_header_inx TYPE  REF TO bapisdhd1x, "  class
    lr_order_header_in  TYPE REF TO bapisdhd1.   "  class
  CONSTANTS: lc_yes TYPE char1 VALUE 'Y', " Yes of type CHAR1
             lc_no  TYPE char1 VALUE 'N'. " No of type CHAR1
  CREATE DATA: lr_order_header_in,
               lr_order_header_inx.
  lr_order_header_in->bill_date   = fp_v_billing_date.
  lr_order_header_inx->updateflag = c_update.
  lr_order_header_inx->bill_date  = abap_true.
  CLEAR v_save_flag.

  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument     = fp_v_vbeln
      order_header_in   = lr_order_header_in->*
      order_header_inx  = lr_order_header_inx->*
    TABLES
      return            = li_return
    EXCEPTIONS
      incov_not_in_item = 1
      OTHERS            = 2.

  IF sy-subrc = 0.
    v_save_flag = lc_yes.
    CLEAR lv_text.
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = c_success.
    IF sy-subrc = 0.

*      MESSAGE s072(zqtc_r2) WITH fp_v_billing_date v_vbeln INTO lv_text. " PO Number & added sucesfully to Order: &
      CONCATENATE 'Billing Date :'fp_v_billing_date 'added to:' fp_v_vbeln INTO DATA(lv_msg) SEPARATED BY space.
      MESSAGE lv_msg TYPE 'S'.
      IF lv_msg IS NOT INITIAL.
        MOVE sy-msgid TO lr_return->id.
        MOVE sy-msgno TO lr_return->number.
        MOVE sy-msgty TO lr_return->type.
        MOVE sy-msgv1      TO lr_return->message_v1. "Messagevariable 1
        MOVE sy-msgv2      TO lr_return->message_v2. "Messagevariable 2
        MOVE sy-msgv3      TO lr_return->message_v3. "Messagevariable 3
        MOVE sy-msgv4      TO lr_return->message_v4. "Messagevariable 4
        MOVE lv_msg        TO lr_return->message.
        PERFORM f_populate_message USING fp_v_vbeln
                                         000000
                                         lr_return
                                   CHANGING  i_xvbfs
                                             i_messages.
      ENDIF. " IF lv_text IS NOT INITIAL

*    ENDIF. " IF sy-subrc = 0

    ELSE. " ELSE -> IF sy-subrc = 0

      v_save_flag = lc_no.
      LOOP AT li_return REFERENCE INTO lr_return  WHERE type = c_error
                                           OR type = c_abend. " Or of type
*----Begin of change VDAPTABALL OTCM-27113/ E342 10/02/2020 ED2K919999 adding message
        IF lr_return->id = 'V4' AND lr_return->number = '219'.
          CONCATENATE lr_return->message '– Billing status Complete' INTO lr_return->message.
        ENDIF.
*----End of change VDAPTABALL OTCM-27113/ E342 11/02/2020 ED2K919999

        PERFORM f_populate_message USING fp_v_vbeln
                                         000000
                                         lr_return
                                   CHANGING  i_xvbfs
                                             i_messages.
      ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = c_error
*& If error occurs then roll back any change and refresh the buffer
      IF sy-subrc = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
  IF v_save_flag = lc_yes.
    PERFORM f_save_sales_document.
  ENDIF.

ENDFORM.
