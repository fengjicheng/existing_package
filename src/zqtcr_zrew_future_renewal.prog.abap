*&---------------------------------------------------------------------*
*& Report  ZQTCR_ZREW_FUTURE_RENEWAL
*&
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCR_ZREW_FUTURE_RENEWAL
* PROGRAM DESCRIPTION:Renewal creation for UI5 application
* DEVELOPER: Venkat Pataballa
* CREATION DATE:   2020-10-10
* OBJECT ID:E256
* TRANSPORT NUMBER(S) ED2K920096
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K923857
* REFERENCE NO: ERPM25282/OTCM-47292
* DEVELOPER:Prabhu(PTUFARAM)
* DATE:  6/16/2021
* DESCRIPTION:Renewals App additional UI changes
*----------------------------------------------------------------------*
REPORT zqtcr_zrew_future_renewal.
TYPES:BEGIN OF ty_tmp,
        sign   TYPE char1,
        option TYPE char2,
        low    TYPE vbeln,
        high   TYPE vbeln,
      END OF ty_tmp,

      BEGIN OF ty_data,
        vbeln    TYPE vbeln,
        vkorg    TYPE vkorg,
        vtweg    TYPE vtweg,
        spart    TYPE spart,
        vkbur    TYPE vkbur,
        augru    TYPE augru,
        waerk    TYPE waerk,
        kunnr    TYPE kunnr,
        kvgr1    TYPE kvgr1,
        kvgr2    TYPE kvgr2,
        kvgr3    TYPE kvgr3,
        kvgr4    TYPE kvgr4,
        kvgr5    TYPE kvgr5,
        posnr    TYPE posnr,
        matnr    TYPE matnr,
        zmeng    TYPE dzmeng,
        vgbel    TYPE vgbel,
        vgpos    TYPE vgpos,
        zzsubtyp TYPE zsubtyp,
        zzvyp    TYPE zvyp,
        mvgr1    TYPE mvgr1,
        mvgr2    TYPE mvgr2,
        mvgr3    TYPE mvgr3,
        mvgr4    TYPE mvgr4,
        mvgr5    TYPE mvgr5,
      END OF ty_data ,

      BEGIN OF ty_vbkd,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
        zlsch TYPE schzw_bseg,
        zterm TYPE dzterm,
        ihrez TYPE ihrez,
        bsark TYPE bsark,
        kdkg1 TYPE kdkg1,
        kdkg2 TYPE kdkg2,
        kdkg3 TYPE kdkg3,
        kdkg4 TYPE kdkg4,
        kdkg5 TYPE kdkg5,
      END OF ty_vbkd ,

      BEGIN OF ty_veda,
        vbeln   TYPE vbeln,
        vposn   TYPE posnr_va,
        vlaufz  TYPE vlauf_veda,
        vlauez  TYPE vlaue_veda,
        vlaufk  TYPE vlauk_veda,
        vbegdat TYPE vbdat_veda,
        venddat TYPE vndat_veda,
        vaktsch TYPE vasch_veda,
        vasdr   TYPE vasdr,
        vendreg TYPE rgvte,
      END OF ty_veda ,

      BEGIN OF ty_kna1,
        kunnr TYPE kunnr,
        name1 TYPE name1_gp,
        name2 TYPE name2_gp,
        adrnr TYPE adrnr,
      END OF ty_kna1 ,

      BEGIN OF ty_adrc,
        addrnumber TYPE adrc-addrnumber,
        deflt_comm TYPE adrc-deflt_comm,
        tel_number TYPE adrc-tel_number,
        time_zone  TYPE adrc-time_zone,
        flgdefault TYPE adr6-flgdefault,
        home_flag  TYPE adr6-home_flag,
        smtp_addr  TYPE adr6-smtp_addr,
        smtp_srch  TYPE adr6-smtp_srch,
      END OF ty_adrc ,
      BEGIN OF ty_renwl,
        vbeln      TYPE vbeln,
        posnr      TYPE posnr,
        activity   TYPE zactivity_sub,
        act_status TYPE zact_status,
        ren_status TYPE zren_status,
      END OF ty_renwl .

DATA: lst_head          TYPE bapisdhd1,
      lst_headx         TYPE bapisdhd1x,
      li_item           TYPE TABLE OF bapisditm,
      lst_item          TYPE bapisditm,
      li_itemx          TYPE TABLE OF bapisditmx,
      lst_itemx         TYPE bapisditmx,
      li_partners       TYPE TABLE OF bapiparnr,
      lst_partner       TYPE bapiparnr,
      li_return         TYPE TABLE OF bapiret2,
      lv_salesdoc       TYPE vbeln_va,
      lv_item           TYPE bapisditm-itm_number,
      li_address        TYPE STANDARD TABLE OF bapiaddr1,
      lst_address       TYPE bapiaddr1,
      lst_schedules_in  TYPE bapischdl,
      lst_schedules_inx TYPE bapischdlx,
      li_veda_date      TYPE STANDARD TABLE OF bapictr,
      li_veda_datex     TYPE STANDARD TABLE OF bapictrx,
      lst_veda_date     TYPE bapictr,
      lst_veda_datex    TYPE bapictrx,
      li_schedules_in   TYPE STANDARD TABLE OF bapischdl,
      li_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
      li_item_e         TYPE STANDARD TABLE OF zqtc_s_future_renewal,
      lst_file          TYPE zqtc_s_future_renewal,
      li_renewal        TYPE STANDARD TABLE OF ty_renwl,
      lv_cnt            TYPE char5,
      lv_agcnt          TYPE i VALUE '100',
      lv_file           TYPE string,
      lv_msg1           TYPE string.
DATA:li_data         TYPE STANDARD TABLE OF ty_data,
     li_veda         TYPE STANDARD TABLE OF ty_veda,
     li_vbkd         TYPE STANDARD TABLE OF ty_vbkd,
     li_kna1         TYPE STANDARD TABLE OF ty_kna1,
     li_adrc         TYPE STANDARD TABLE OF ty_adrc,
     lr_vbeln        TYPE STANDARD TABLE OF fip_s_vbeln_range,
     lr_posnr        TYPE STANDARD TABLE OF ckmcso_posnr,
     lst_bape_vbap   TYPE bape_vbap,
     lst_bape_vbapx  TYPE bape_vbapx,
     lst_extensionin TYPE bapiparex,
     li_extensionin  TYPE STANDARD TABLE OF bapiparex.

CONSTANTS:lc_i      TYPE char1 VALUE 'I',
          lc_g      TYPE char1 VALUE 'G',
          lc_ag     TYPE parvw VALUE 'AG',
          lc_we     TYPE parvw VALUE 'WE',
          lc_sp     TYPE parvw VALUE 'SP',
          lc_zrew   TYPE auart VALUE 'ZREW',
          lc_header TYPE posnr VALUE '000000',
          lc_en     TYPE char2 VALUE 'EN'.

TABLES:vbap,vbak.
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY DEFAULT 'Test.XLS'.
SELECT-OPTIONS:s_vbeln FOR vbak-vbeln,
               s_posnr FOR vbap-posnr.



START-OF-SELECTION.
  LOOP AT s_vbeln INTO DATA(lst_vbeln).
    APPEND lst_vbeln TO lr_vbeln.
  ENDLOOP.
  LOOP AT s_posnr INTO DATA(lst_posnr).
    APPEND lst_posnr TO lr_posnr.
  ENDLOOP.
  FREE:li_item_e.
  OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    DO.
      READ DATASET p_file INTO lst_file.
      IF sy-subrc = 0.
        APPEND lst_file TO li_item_e.
        CLEAR lst_file .
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  ELSE.
    MESSAGE i256(zqtc_r2) WITH p_file.
  ENDIF.
  FREE:li_data,
       li_vbkd,
       li_veda,
       li_kna1,
       li_adrc,
       li_renewal.
  CALL METHOD zcl_zqtc_future_renewal_e256=>get_data
    EXPORTING
      im_lineitem = li_item_e
      im_vbeln    = lr_vbeln
      im_posnr    = lr_posnr
    IMPORTING
      ex_data     = li_data
      ex_vbkd     = li_vbkd
      ex_veda     = li_veda
      ex_kna1     = li_kna1
      ex_adrc     = li_adrc
      ex_renewal  = li_renewal.

  FREE:lst_head,lst_headx,li_item,li_itemx,li_partners,li_address,lv_item,
           li_schedules_in,li_schedules_inx,li_return,lv_salesdoc,lv_cnt,
           lst_bape_vbap,lst_bape_vbapx,lst_extensionin,li_extensionin.

  LOOP AT s_vbeln INTO lst_vbeln.
    READ TABLE li_item_e INTO DATA(lst_input) WITH KEY  vbeln = lst_vbeln-low.
    IF sy-subrc = 0.
      DATA(lv_tabix) = sy-tabix.
      LOOP AT li_item_e   INTO lst_input FROM lv_tabix.
        IF lst_input-vbeln <> lst_vbeln-low.
          EXIT.
        ELSE.
          READ TABLE li_data INTO DATA(lst_data) WITH KEY vbeln = lst_input-vbeln
                                                          posnr = lst_input-posnr.
          IF sy-subrc = 0.
* Populate Header Info
            READ TABLE li_renewal INTO DATA(lst_renewal) WITH  KEY vbeln = lst_input-vbeln
                                                                        posnr = lst_input-posnr.
            IF sy-subrc = 0
              AND lst_renewal-act_status = abap_false
              AND lst_renewal-ren_status = abap_false.
              CLEAR:lst_head,lst_headx.
              lst_head-doc_type   = lc_zrew.
              lst_head-sales_org  = lst_data-vkorg.
              lst_head-division   = lst_data-spart.
              lst_head-distr_chan = lst_data-vtweg.
              lst_head-sales_off  = lst_data-vkbur.
              lst_head-ref_1      = lst_data-vbeln.
              lst_head-ref_doc    = lst_data-vbeln.
              lst_head-ref_doc    = lst_data-vbeln.
              lst_head-ref_doc_l  = lst_data-vbeln.
              lst_head-currency   = lst_data-waerk.
              lst_head-refdoc_cat = lc_g.
              lst_head-refdoctype = lc_g.
              lst_head-sd_doc_cat = lc_g.
              lst_head-cust_grp1  = lst_data-kvgr1.
              lst_head-cust_grp2  = lst_data-kvgr2.
              lst_head-cust_grp3  = lst_data-kvgr3.
              lst_head-cust_grp4  = lst_data-kvgr4.
              lst_head-cust_grp5  = lst_data-kvgr5.
              IF lst_head-cust_grp1 IS NOT INITIAL.
                lst_headx-cust_grp1 = abap_true.
              ENDIF.
              IF lst_head-cust_grp2 IS NOT INITIAL.
                lst_headx-cust_grp2 = abap_true.
              ENDIF.
              IF lst_head-cust_grp3 IS NOT INITIAL.
                lst_headx-cust_grp3 = abap_true.
              ENDIF.
              IF lst_head-cust_grp4 IS NOT INITIAL.
                lst_headx-cust_grp4 = abap_true.
              ENDIF.
              IF lst_head-cust_grp5 IS NOT INITIAL.
                lst_headx-cust_grp5 = abap_true.
              ENDIF.

* Populate Header update structure
              lst_headx-updateflag  = lc_i.
              lst_headx-doc_type    = abap_true.
              lst_headx-sales_org   = abap_true.
              lst_headx-division    = abap_true.
              lst_headx-distr_chan  = abap_true.
              lst_headx-sales_off   = abap_true.
              lst_headx-ref_1       = abap_true.
              lst_headx-ref_doc     = abap_true.
              lst_headx-refdoc_cat  = abap_true.
              lst_headx-sd_doc_cat  = abap_true.
              lst_headx-ref_doc_l   = abap_true.
              lst_head-currency     = abap_true.
              lv_item = lv_item + 10.

              lst_head-pymt_meth  = lst_input-zlsch.
              lst_headx-pymt_meth = abap_true.
              READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_data-vbeln
                                                              posnr = lc_header.
              IF sy-subrc = 0.
                lst_head-ref_1            = lst_vbkd-ihrez.
                lst_head-pmnttrms         = lst_vbkd-zterm.
                IF lst_head-ref_1 IS NOT INITIAL.
                  lst_headx-ref_1           = abap_true.
                ENDIF.
                IF lst_head-pmnttrms  IS NOT INITIAL.
                  lst_headx-pmnttrms        = abap_true.
                ENDIF.
                lst_head-po_method        = lst_vbkd-bsark.
                IF lst_head-po_method IS NOT INITIAL.
                  lst_headx-po_method       = abap_true.
                ENDIF.
              ENDIF.


              CLEAR:lst_veda_date,lst_veda_datex.
              CALL METHOD zcl_zqtc_future_renewal_e256=>veda_data
                EXPORTING
                  im_veda       = li_veda
                  im_vbkd       = li_vbkd
                  im_posnr      = lc_header
                  im_vbeln      = lst_data-vbeln
                IMPORTING
                  ex_veda_date  = lst_veda_date
                  ex_veda_datex = lst_veda_datex.
              APPEND lst_veda_date TO li_veda_date.
              APPEND lst_veda_datex TO li_veda_datex.
* Populate Item info
              IF lst_input-matnr NE lst_input-matnr_old.
                CLEAR:lst_item.
                lst_item-itm_number = lv_item .
                lst_item-material   = lst_input-matnr_old.
                lst_item-target_qty = lst_data-zmeng.
                lst_item-ref_doc    = lst_data-vbeln.
                lst_item-ref_doc_it = lst_data-posnr.
                lst_item-reason_rej = lst_input-abgru.
                lst_item-price_grp  = lst_input-price.
                lst_item-ref_doc_ca = lc_g.
                READ TABLE li_vbkd INTO lst_vbkd WITH KEY vbeln = lst_data-vbeln
                                                          posnr = lv_item.
                IF sy-subrc = 0.
                  lst_item-ref_1        = lst_vbkd-ihrez.
                  IF lst_item-ref_1  IS NOT INITIAL.
                    lst_itemx-ref_1     = abap_true.
                  ENDIF.
                  lst_item-po_method    = lst_vbkd-bsark.
                  IF lst_vbkd-bsark IS NOT INITIAL.
                    lst_itemx-po_method    = abap_true.
                  ENDIF.
                  lst_item-cstcndgrp1 = lst_vbkd-kdkg1.
                  lst_item-cstcndgrp2 = lst_vbkd-kdkg2.
                  lst_item-cstcndgrp3 = lst_vbkd-kdkg3.
                  lst_item-cstcndgrp4 = lst_vbkd-kdkg4.
                  lst_item-cstcndgrp5 = lst_vbkd-kdkg5.
                  IF lst_item-cstcndgrp1 IS NOT INITIAL.
                    lst_itemx-cstcndgrp1 = abap_true.
                  ENDIF.
                  IF lst_item-cstcndgrp2 IS NOT INITIAL.
                    lst_itemx-cstcndgrp2 = abap_true.
                  ENDIF.
                  IF lst_item-cstcndgrp3 IS NOT INITIAL.
                    lst_itemx-cstcndgrp3 = abap_true.
                  ENDIF.
                  IF lst_item-cstcndgrp4 IS NOT INITIAL.
                    lst_itemx-cstcndgrp4 = abap_true.
                  ENDIF.
                  IF lst_item-cstcndgrp5 IS NOT INITIAL.
                    lst_itemx-cstcndgrp5 = abap_true.
                  ENDIF.
                ENDIF.
                lst_item-pymt_meth  = lst_input-zlsch.
                IF lst_item-pymt_meth IS NOT INITIAL.
                  lst_itemx-pymt_meth   = abap_true.
                ENDIF.
                lst_item-prc_group1 = lst_data-mvgr1.
                lst_item-prc_group2 = lst_data-mvgr2.
                lst_item-prc_group3 = lst_data-mvgr3.
                lst_item-prc_group4 = lst_data-mvgr4.
                lst_item-prc_group5 = lst_data-mvgr5.
                IF lst_item-prc_group1 IS NOT INITIAL.
                  lst_itemx-prc_group1 = abap_true.
                ENDIF.
                IF lst_item-prc_group2 IS NOT INITIAL.
                  lst_itemx-prc_group2 = abap_true.
                ENDIF.
                IF lst_item-prc_group4 IS NOT INITIAL.
                  lst_itemx-prc_group4 = abap_true.
                ENDIF.
                IF lst_item-prc_group3 IS NOT INITIAL.
                  lst_itemx-prc_group3 = abap_true.
                ENDIF.
                IF lst_item-prc_group5 IS NOT INITIAL.
                  lst_itemx-prc_group5 = abap_true.
                ENDIF.
                APPEND lst_item TO li_item.

                lst_itemx-itm_number  = lst_item-itm_number.
                lst_itemx-material    = abap_true.
                lst_itemx-target_qty  = abap_true.
                lst_itemx-ref_doc     = abap_true.
                lst_itemx-ref_doc_it  = abap_true.
                lst_itemx-reason_rej  = abap_true.
                lst_itemx-ref_doc_ca = abap_true.
                IF lst_item-price_grp IS NOT INITIAL.
                  lst_itemx-price_grp = abap_true.
                ENDIF.
                APPEND lst_itemx TO li_itemx.
                CLEAR:lst_itemx.

                CLEAR:lst_schedules_in,lst_schedules_inx.
                lst_schedules_in-itm_number  = lst_item-itm_number.
                lst_schedules_inx-itm_number = abap_true.
                lst_schedules_in-req_qty     = lst_data-zmeng.
                lst_schedules_inx-req_qty    = abap_true.
                APPEND lst_schedules_in TO li_schedules_in.
                APPEND lst_schedules_inx TO li_schedules_inx.
                lst_extensionin-structure = 'BAPE_VBAP'.
                lst_bape_vbap-posnr    = lst_item-itm_number.
                lst_bape_vbap-zzsubtyp = lst_data-zzsubtyp.
                IF lst_data-zzvyp IS NOT INITIAL.
                  lst_bape_vbap-zzvyp    = lst_data-zzvyp + 1.
                ENDIF.
                lst_extensionin+30(960)   = lst_bape_vbap.
                APPEND lst_extensionin TO li_extensionin.
                CLEAR lst_extensionin.

                lst_extensionin-structure = 'BAPE_VBAPX'.
                lst_bape_vbapx-posnr      = lst_item-itm_number.
                IF lst_bape_vbap-zzsubtyp IS NOT INITIAL.
                  lst_bape_vbapx-zzsubtyp   = abap_true.
                ENDIF.
                IF lst_bape_vbap-zzvyp IS NOT INITIAL.
                  lst_bape_vbapx-zzvyp      = abap_true.
                ENDIF.
                lst_extensionin+30(960)   = lst_bape_vbapx.
                APPEND lst_extensionin TO li_extensionin.
                CLEAR  lst_extensionin.
*----Contract start dates and end dates
                CLEAR:lst_veda_date,lst_veda_datex.
                CALL METHOD zcl_zqtc_future_renewal_e256=>veda_data
                  EXPORTING
                    im_veda       = li_veda
                    im_vbkd       = li_vbkd
                    im_posnr      = lst_item-itm_number
                    im_vbeln      = lst_data-vbeln
                  IMPORTING
                    ex_veda_date  = lst_veda_date
                    ex_veda_datex = lst_veda_datex.
*----Pricing Date
                lst_head-price_date = lst_veda_date-con_st_dat.
                IF lst_head-price_date IS NOT INITIAL .
                  lst_headx-price_date = abap_true.
                ENDIF.
                APPEND lst_veda_date TO li_veda_date.
                APPEND lst_veda_datex TO li_veda_datex.
                DATA(lv_flag) = abap_true.
                DATA(lv_item_t) = lv_item.
                SELECT COUNT( DISTINCT matnr ) FROM vbap
                  INTO  @DATA(lv_line_cnt) WHERE vbeln = @lst_data-vbeln
                                             AND  uepos = @lst_data-posnr.
                IF lv_line_cnt IS NOT INITIAL.
                  lv_item = lv_item * ( lv_line_cnt + 1 ).
                ENDIF.
                lv_item = lv_item + 10.
              ENDIF.

              CLEAR:lst_item.
              lst_item-material   = lst_input-matnr.
              lst_item-target_qty = lst_input-zmeng.
              lst_item-ref_doc    = lst_data-vbeln.
              lst_item-ref_doc_it = lst_data-posnr.
              lst_item-price_grp  = lst_input-price.
              lst_item-ref_doc_ca = lc_g.
              READ TABLE li_vbkd INTO lst_vbkd WITH KEY vbeln = lst_data-vbeln
                                                              posnr = lv_item.
              IF sy-subrc = 0.
                lst_item-ref_1        = lst_vbkd-ihrez.
                IF lst_item-ref_1  IS NOT INITIAL.
                  lst_itemx-ref_1     = abap_true.
                ENDIF.
                lst_item-po_method    = lst_vbkd-bsark.
                IF lst_vbkd-bsark IS NOT INITIAL.
                  lst_itemx-po_method    = abap_true.
                ENDIF.
                lst_item-pymt_meth  = lst_input-zlsch.
                IF lst_item-pymt_meth IS NOT INITIAL.
                  lst_itemx-pymt_meth   = abap_true.
                ENDIF.
                lst_item-cstcndgrp1 = lst_vbkd-kdkg1.
                lst_item-cstcndgrp2 = lst_vbkd-kdkg2.
                lst_item-cstcndgrp3 = lst_vbkd-kdkg3.
                lst_item-cstcndgrp4 = lst_vbkd-kdkg4.
                lst_item-cstcndgrp5 = lst_vbkd-kdkg5.
                IF lst_item-cstcndgrp1 IS NOT INITIAL.
                  lst_itemx-cstcndgrp1 = abap_true.
                ENDIF.
                IF lst_item-cstcndgrp2 IS NOT INITIAL.
                  lst_itemx-cstcndgrp2 = abap_true.
                ENDIF.
                IF lst_item-cstcndgrp3 IS NOT INITIAL.
                  lst_itemx-cstcndgrp3 = abap_true.
                ENDIF.
                IF lst_item-cstcndgrp4 IS NOT INITIAL.
                  lst_itemx-cstcndgrp4 = abap_true.
                ENDIF.
                IF lst_item-cstcndgrp5 IS NOT INITIAL.
                  lst_itemx-cstcndgrp5 = abap_true.
                ENDIF.
              ENDIF.

              lst_item-prc_group1 = lst_data-mvgr1.
              lst_item-prc_group2 = lst_data-mvgr2.
              lst_item-prc_group3 = lst_data-mvgr3.
              lst_item-prc_group4 = lst_data-mvgr4.
              lst_item-prc_group5 = lst_data-mvgr5.
              IF lst_item-prc_group1 IS NOT INITIAL.
                lst_itemx-prc_group1 = abap_true.
              ENDIF.
              IF lst_item-prc_group2 IS NOT INITIAL.
                lst_itemx-prc_group2 = abap_true.
              ENDIF.
              IF lst_item-prc_group4 IS NOT INITIAL.
                lst_itemx-prc_group4 = abap_true.
              ENDIF.
              IF lst_item-prc_group3 IS NOT INITIAL.
                lst_itemx-prc_group3 = abap_true.
              ENDIF.
              IF lst_item-prc_group5 IS NOT INITIAL.
                lst_itemx-prc_group5 = abap_true.
              ENDIF.
              APPEND lst_item TO li_item.
              lst_itemx-itm_number  = lst_item-itm_number.
              lst_itemx-material    = abap_true.
              lst_itemx-target_qty  = abap_true.
              lst_itemx-ref_doc     = abap_true.
              lst_itemx-ref_doc_it  = abap_true.
              lst_itemx-ref_doc_ca = abap_true.
              IF lst_item-price_grp IS NOT INITIAL.
                lst_itemx-price_grp   = abap_true.
              ENDIF.

              APPEND lst_itemx TO li_itemx.
              CLEAR:lst_itemx.

              CLEAR:lst_schedules_in,lst_schedules_inx.
              lst_schedules_in-itm_number  = lst_item-itm_number.
              lst_schedules_inx-itm_number = abap_true.
              lst_schedules_in-req_qty     = lst_input-zmeng.
              lst_schedules_inx-req_qty    = abap_true.
              APPEND lst_schedules_in TO li_schedules_in.
              APPEND lst_schedules_inx TO li_schedules_inx.

              lst_extensionin-structure = 'BAPE_VBAP'.
              lst_bape_vbap-posnr    = lst_item-itm_number.
              lst_bape_vbap-zzsubtyp = lst_data-zzsubtyp.
              lst_bape_vbap-zzvyp    = lst_data-zzvyp + 1.
              lst_extensionin+30(960)   = lst_bape_vbap.
              APPEND lst_extensionin TO li_extensionin.
              CLEAR lst_extensionin.

              lst_extensionin-structure = 'BAPE_VBAPX'.
              lst_bape_vbapx-posnr      = lst_item-itm_number.
              IF lst_bape_vbap-zzsubtyp IS NOT INITIAL.
                lst_bape_vbapx-zzsubtyp   = abap_true.
              ENDIF.
              IF lst_bape_vbap-zzvyp IS NOT INITIAL.
                lst_bape_vbapx-zzvyp      = abap_true.
              ENDIF.
              lst_extensionin+30(960)   = lst_bape_vbapx.
              APPEND lst_extensionin TO li_extensionin.
              CLEAR  lst_extensionin.
*----Contract start dates and end dates

              CLEAR:lst_veda_date,lst_veda_datex.
              CALL METHOD zcl_zqtc_future_renewal_e256=>veda_data
                EXPORTING
                  im_veda       = li_veda
                  im_vbkd       = li_vbkd
                  im_posnr      = lst_item-itm_number
                  im_vbeln      = lst_data-vbeln
                IMPORTING
                  ex_veda_date  = lst_veda_date
                  ex_veda_datex = lst_veda_datex.
              IF lv_flag = abap_true.
                READ TABLE li_veda_date INTO DATA(lst_veda_tmp)
                                            WITH KEY itm_number = lv_item_t.
                IF sy-subrc = 0.
                  lst_veda_date-con_st_dat = lst_veda_tmp-con_st_dat.
                  lst_veda_date-con_en_dat = lst_veda_tmp-con_en_dat.
                ENDIF.
              ENDIF.
              APPEND lst_veda_date TO li_veda_date.
*----pricing date
              lst_head-price_date = lst_veda_date-con_st_dat.
              IF lst_head-price_date IS NOT INITIAL .
                lst_headx-price_date = abap_true.
              ENDIF.
              APPEND lst_veda_datex TO li_veda_datex.

* Populate Partner
*    BOC 6/22/2021      OTCM-47292 Renewals FioriApp additionalChanges
              CLEAR:lst_partner.
              IF lst_input-ag_addrchg IS INITIAL.
                lst_partner-partn_numb = lst_input-kunag.
                lst_partner-partn_role = lc_ag.
                IF lst_input-ag_location IS NOT INITIAL.
                  lv_agcnt = lv_agcnt + 1.
                ENDIF.
                APPEND lst_partner TO li_partners.
              ENDIF.
              IF lst_input-address_chg IS INITIAL.
                lst_partner-partn_numb = lst_input-kunwe.
                lst_partner-partn_role = lc_we.
                IF lst_input-location IS NOT INITIAL
                  AND lst_input-address_chg = abap_true.
                  lv_cnt = lv_cnt + 1.
                ENDIF.
                APPEND lst_partner TO li_partners.
              ENDIF.

              IF lst_input-kunff IS NOT INITIAL AND lst_input-del_ff IS INITIAL.
                CLEAR:lst_partner.
                lst_partner-partn_numb = lst_input-kunff.
                lst_partner-itm_number = lc_header."lv_item.
                lst_partner-partn_role = lc_sp.
                APPEND lst_partner TO li_partners.
                CLEAR lst_partner.
              ENDIF.
              IF lst_input-ag_addrchg = abap_true.
                CLEAR:lst_partner.
                lst_partner-partn_numb = lst_input-kunag.
                lst_partner-itm_number =  lc_header.
                lst_partner-partn_role = lc_ag.
                "Update Soldto address at header when there is a change
                "     lst_partner-itm_number = lc_header."lst_item-itm_number.
                READ TABLE li_kna1 INTO DATA(lst_kna1_ag) WITH KEY kunnr = lst_input-kunag.
                IF sy-subrc = 0.
                  lst_partner-name       = lst_kna1_ag-name1.
                  lst_partner-name_2     = lst_kna1_ag-name2.
                  READ TABLE li_adrc INTO DATA(lst_adrc_ag) WITH KEY addrnumber = lst_kna1_ag-adrnr.
                  IF sy-subrc = 0.
                    lst_partner-langu     = lc_en.
                    lst_partner-telephone = lst_adrc_ag-tel_number.
                  ENDIF.
                ENDIF.
                lst_partner-street     = lst_input-ag_street.
                lst_partner-country    = lst_input-ag_country.
                lst_partner-postl_code = lst_input-ag_post_code1.
                lst_partner-city       = lst_input-ag_city1.
                lst_partner-region     = lst_input-ag_region.
                IF lst_input-ag_location IS NOT INITIAL.
                  lst_partner-addr_link =  lv_agcnt + 1.
                  CLEAR:lst_address.
                  lst_address-name       = lst_kna1_ag-name1.
                  lst_address-name_2     = lst_kna1_ag-name2.
                  lst_address-langu = lc_en.
                  lst_address-tel1_numbr = lst_adrc_ag-tel_number.
                  lst_address-e_mail     = lst_adrc_ag-smtp_addr.
                  lst_address-time_zone  = lst_adrc_ag-time_zone.
                  lst_address-comm_type  = lst_adrc_ag-deflt_comm.
                  lst_address-addr_no    = lv_agcnt + 1.
                  lst_address-postl_cod1 = lst_input-ag_post_code1.
                  lst_address-street     = lst_input-ag_street.
                  lst_address-str_suppl1 = lst_input-ag_str_suppl1.
                  lst_address-str_suppl2 = lst_input-ag_str_suppl2.
                  lst_address-str_suppl3 = lst_input-ag_str_suppl3.
                  lst_address-location   = lst_input-ag_location.
                  lst_address-city       = lst_input-ag_city1.
                  lst_address-country    = lst_input-ag_country.
                  lst_address-region     = lst_input-ag_region.
                  lst_address-langu      = lc_en.
                  APPEND lst_address TO li_address.
                  CLEAR lst_address.
                ENDIF. " IF lst_input-location IS NOT INITIAL.
                APPEND lst_partner TO li_partners.
              ENDIF.
              IF lst_input-address_chg = abap_true.
*                CLEAR:lst_partner.
*                lst_partner-partn_numb = lst_input-kunag.
*                lst_partner-itm_number = lst_item-itm_number.
*                lst_partner-partn_role = lc_ag.
*                APPEND lst_partner TO li_partners.

                CLEAR:lst_partner.
                lst_partner-partn_numb = lst_input-kunwe.
                lst_partner-partn_role = lc_we.
                lst_partner-itm_number = lc_header."lst_item-itm_number.
                READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_input-kunwe.
                IF sy-subrc = 0.
                  lst_partner-name       = lst_kna1-name1.
                  lst_partner-name_2     = lst_kna1-name2.
                  READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_kna1-adrnr.
                  IF sy-subrc = 0.
                    lst_partner-langu = lc_en.
                    lst_partner-telephone = lst_adrc-tel_number.
                  ENDIF.
                ENDIF.
                lst_partner-street     = lst_input-street.
                lst_partner-country    = lst_input-country.
                lst_partner-postl_code = lst_input-post_code1.
                lst_partner-city       = lst_input-city1.
                lst_partner-region     = lst_input-region.
                IF lst_input-location IS NOT INITIAL
                   AND lst_input-address_chg = abap_true.
                  lst_partner-addr_link = lv_cnt.
                ENDIF.
                APPEND lst_partner TO li_partners.
                IF lst_input-location IS NOT INITIAL
                 AND lst_input-address_chg = abap_true.
                  CLEAR:lst_address.
                  READ TABLE li_kna1 INTO lst_kna1 WITH KEY kunnr = lst_input-kunwe.
                  IF sy-subrc = 0.
                    lst_address-name       = lst_kna1-name1.
                    lst_address-name_2     = lst_kna1-name2.
                    READ TABLE li_adrc INTO lst_adrc WITH KEY addrnumber = lst_kna1-adrnr.
                    IF sy-subrc = 0.
                      lst_address-langu      = lc_en.
                      lst_address-tel1_numbr = lst_adrc-tel_number.
                      lst_address-e_mail     = lst_adrc-smtp_addr.
                      lst_address-time_zone  = lst_adrc-time_zone.
                      lst_address-comm_type  = lst_adrc-deflt_comm.
                    ENDIF.
                  ENDIF.
                  lst_address-addr_no    = lv_cnt.
                  lst_address-postl_cod1 = lst_input-post_code1.
                  lst_address-street     = lst_input-street.
                  lst_address-str_suppl1 = lst_input-location.
                  lst_address-city       = lst_input-city1.
                  lst_address-country    = lst_input-country.
                  lst_address-region     = lst_input-region.
                  lst_address-langu      = lc_en.
                  APPEND lst_address TO li_address.
                  CLEAR lst_address.
                ENDIF. " IF lst_input-location IS NOT INITIAL.
              ENDIF.
            ELSE. "READ TABLE li_renewal INTO DATA(lst_renewal) WITH  KEY vbeln = lst_input-vbeln
              WRITE:/ 'Error - Already Contract Renewed'.
            ENDIF. "READ TABLE li_renewal INTO DATA(lst_renewal) WITH  KEY vbeln = lst_input-vbeln
          ENDIF. "READ TABLE li_data INTO DATA(lst_data) WITH KEY vbeln = lst_input-vbeln
        ENDIF. "   IF lst_input-vbeln <> lst_vbeln-low.
      ENDLOOP.
      CLEAR:lv_salesdoc.
      FREE:li_return[].

* Create Renewal Contract with Reference Contract
      IF  lst_head IS NOT INITIAL
                 AND li_item IS NOT INITIAL.
        CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
          EXPORTING
            salesdocument         = lv_salesdoc
            sales_header_in       = lst_head
            sales_header_inx      = lst_headx
            status_buffer_refresh = abap_true
          IMPORTING
            salesdocument_ex      = lv_salesdoc
          TABLES
            return                = li_return
            sales_items_in        = li_item
            sales_items_inx       = li_itemx
            sales_partners        = li_partners
            sales_schedules_in    = li_schedules_in
            sales_schedules_inx   = li_schedules_inx
            sales_contract_in     = li_veda_date
            sales_contract_inx    = li_veda_datex
            partneraddresses      = li_address
            extensionin           = li_extensionin.

        IF lv_salesdoc IS NOT INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
          CONCATENATE 'Renewal Order'(001)
                          lv_salesdoc
                          'Created Successfully'(002)
                          INTO  DATA(lv_message) SEPARATED BY space.
          WRITE: / lv_message.
        ELSE. "IF lv_salesdoc IS NOT INITIAL.
          LOOP AT li_return INTO DATA(lst_return).
            CONCATENATE lst_return-message
                        lst_return-message_v1
                        lst_return-message_v2
                        lst_return-message_v3
                        lst_return-message_v4 INTO DATA(lv_msg).
            WRITE: / lv_msg.
          ENDLOOP.
        ENDIF. " IF lv_salesdoc IS NOT INITIAL.
      ENDIF. "  IF  lst_head IS NOT INITIAL
    ENDIF. "READ TABLE wa_orders-np_vbeln  INTO DATA(lst_input)
    FREE:lst_head,lst_headx,li_item,li_itemx,li_partners,li_address,lv_salesdoc,
          li_schedules_in,li_schedules_inx,li_return,lv_item,lv_cnt,li_return,
          lst_bape_vbap,lst_bape_vbapx,lst_extensionin,li_extensionin.
  ENDLOOP.
*---Application layer File Path
  IF p_file IS NOT INITIAL.
    FREE:lv_msg1.
    CONCATENATE 'File:'(003) p_file  INTO lv_msg1 SEPARATED BY space.
    WRITE:lv_msg1.
  ENDIF.
