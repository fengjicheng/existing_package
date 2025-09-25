class ZCL_ZQTC_FUTURE_REN_01_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_FUTURE_REN_01_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods ADDRESSCHECKSET_GET_ENTITYSET
    redefinition .
  methods COUNTRYSET_GET_ENTITYSET
    redefinition .
  methods EXCLUSIONDETAILS_GET_ENTITYSET
    redefinition .
  methods FFAGENTSET_GET_ENTITYSET
    redefinition .
  methods GETLISTSET_GET_ENTITYSET
    redefinition .
  methods GETPRDSET_GET_ENTITYSET
    redefinition .
  methods INCLUDESET_GET_ENTITY
    redefinition .
  methods INCLUDESET_UPDATE_ENTITY
    redefinition .
  methods INCOMPLETESET_GET_ENTITYSET
    redefinition .
  methods PAYMETHODSET_GET_ENTITYSET
    redefinition .
  methods PRICEGRPSET_GET_ENTITYSET
    redefinition .
  methods REASONSSET_GET_ENTITYSET
    redefinition .
  methods REGIONSET_GET_ENTITYSET
    redefinition .
  methods RSTATUSSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods ZSHIPTOSET_GET_ENTITYSET
    redefinition .
  methods TIMESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_FUTURE_REN_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K923857
* REFERENCE NO: ERPM25282/OTCM-47292
* DEVELOPER:Prabhu(PTUFARAM)
* DATE:  6/16/2021
* DESCRIPTION:Renewals App additional UI changes
*----------------------------------------------------------------------*
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

    DATA : BEGIN OF  lt_orders.
    DATA:vbeln   TYPE vbeln,
         message TYPE bapi_msg.
    DATA: np_vbeln TYPE zcl_zqtc_future_ren_01_mpc=>tt_item,
          END OF lt_orders.
    DATA:li_data    TYPE STANDARD TABLE OF ty_data,
         li_veda    TYPE STANDARD TABLE OF ty_veda,
         li_vbkd    TYPE STANDARD TABLE OF ty_vbkd,
         li_kna1    TYPE STANDARD TABLE OF ty_kna1,
         li_adrc    TYPE STANDARD TABLE OF ty_adrc,
         li_renewal TYPE STANDARD TABLE OF ty_renwl.

    DATA: lst_head          TYPE bapisdhd1,
          wa_orders         LIKE lt_orders,
          lst_headx         TYPE bapisdhd1x,
          li_item           TYPE TABLE OF bapisditm,
          lst_item          TYPE bapisditm,
          li_itemx          TYPE TABLE OF bapisditmx,
          lst_itemx         TYPE bapisditmx,
          li_partners       TYPE TABLE OF bapiparnr,
          lst_partner       TYPE bapiparnr,
          li_return         TYPE TABLE OF bapiret2,
          lst_return        TYPE bapiret2,
          lv_salesdoc       TYPE vbeln_va,
          lv_item           TYPE bapisditm-itm_number,
          lv_entity_set     TYPE /iwbep/mgw_tech_name,
          lst_schedules_in  TYPE bapischdl,
          lst_schedules_inx TYPE bapischdlx,
          li_veda_date      TYPE STANDARD TABLE OF bapictr,
          li_veda_datex     TYPE STANDARD TABLE OF bapictrx,
          lst_veda_date     TYPE bapictr,
          lst_veda_datex    TYPE bapictrx,
          li_schedules_in   TYPE STANDARD TABLE OF bapischdl,
          li_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
          li_address        TYPE STANDARD TABLE OF bapiaddr1,
          lst_address       TYPE bapiaddr1,
          li_input          TYPE STANDARD TABLE OF zqtc_s_future_renewal,
          li_item_e         TYPE STANDARD TABLE OF zqtc_s_future_renewal,
          lv_jobname        TYPE btcjob,
          lv_number         TYPE tbtcjob-jobcount, "Job number
          lv_user           TYPE sy-uname,        " User Name
          lv_pre_chk        TYPE btcckstat,
          lst_vbeln         TYPE fip_s_vbeln_range,
          lst_posnr         TYPE ckmcso_posnr,
          lst_augru         TYPE rjksd_augru_range,
          lr_vbeln          TYPE STANDARD TABLE OF fip_s_vbeln_range,
          lr_posnr          TYPE STANDARD TABLE OF ckmcso_posnr,
          lv_cnt            TYPE char5,
          lv_agcnt          TYPE i VALUE '100',
          lv_file_path      TYPE string,
          lv_file           TYPE string,
          lst_bape_vbap     TYPE bape_vbap,
          lst_bape_vbapx    TYPE bape_vbapx,
          lst_extensionin   TYPE bapiparex,
          li_extensionin    TYPE STANDARD TABLE OF bapiparex.
    DATA:lv_days TYPE t5a4a-dlydy,                                 " Days
         lv_year TYPE t5a4a-dlyyr.
    CONSTANTS:lc_days  TYPE t5a4a-dlydy VALUE '00',  " Days
              lc_month TYPE t5a4a-dlymo  VALUE '00', " Month
              lc_year  TYPE t5a4a-dlyyr  VALUE '00'. " Year
    DATA:v_path_in TYPE filepath-pathintern VALUE 'Z_E256_CREATE_IN',
         lv_host   TYPE string,
         lv_port   TYPE string.
    CONSTANTS:lc_va43  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.
    CONSTANTS:lc_i       TYPE char1 VALUE 'I',
              lc_w       TYPE char1 VALUE 'W',
              lc_e       TYPE char1 VALUE 'E',
              lc_s       TYPE char1 VALUE 'S',
              lc_g       TYPE char1 VALUE 'G',
              lc_eq      TYPE char2 VALUE 'EQ',
              lc_en      TYPE char2 VALUE 'EN',
              lc_devid   TYPE zdevid VALUE 'E256',
              lc_ag      TYPE parvw VALUE 'AG',
              lc_we      TYPE parvw VALUE 'WE',
              lc_sp      TYPE parvw VALUE 'SP',
              lc_zrew    TYPE auart VALUE 'ZREW',
              lc_header  TYPE posnr VALUE '000000',
              lc_records TYPE rvari_vnam VALUE 'NO_OF_RECORDS'.

    FREE:lt_orders,
         wa_orders,
         lst_return,
         lv_entity_set,
         li_input ,
         li_item_e,
         lv_jobname,
         lv_number,
         lv_user ,
         lv_file,
         lv_pre_chk,
         lst_vbeln,
         lst_posnr.

    cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
            port = lv_port ).
    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).

    io_data_provider->read_entry_data( IMPORTING es_data  = wa_orders ).
    FREE: lr_vbeln,lr_posnr.
    CASE lv_entity_set.
      WHEN 'HeaderSet'.
        LOOP AT  wa_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<fs_input>).
          lst_vbeln-sign   = lc_i.
          lst_vbeln-option = lc_eq.
          lst_vbeln-low    = <fs_input>-vbeln.
          APPEND lst_vbeln TO lr_vbeln.
          <fs_input>-posnr = <fs_input>-posnr_c.
          lst_posnr-sign   = lc_i.
          lst_posnr-option = lc_eq.
          lst_posnr-low    = <fs_input>-posnr.
          APPEND lst_posnr TO lr_posnr.
          CLEAR : lst_vbeln,lst_posnr.
        ENDLOOP.
    ENDCASE.

    SORT lr_vbeln BY low.
    DELETE ADJACENT DUPLICATES FROM lr_vbeln COMPARING low.

    SELECT SINGLE *
      FROM zcaconstant
      INTO @DATA(lst_const)
      WHERE devid    = @lc_devid
        AND activate = @abap_true
        AND param1   = @lc_records.

    MOVE-CORRESPONDING wa_orders-np_vbeln TO li_item_e.
    DESCRIBE TABLE wa_orders-np_vbeln LINES DATA(lv_lines).

    IF lv_lines > lst_const-low.

      CLEAR :lv_file_path.
      CONCATENATE lv_file_path 'ZREW_' sy-datum sy-uzeit INTO lv_file.
*--*Read file path from transaction FILE
      CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
        EXPORTING
          client                     = sy-mandt
          logical_path               = v_path_in
          operating_system           = sy-opsys
          file_name                  = lv_file
          eleminate_blanks           = abap_true
        IMPORTING
          file_name_with_path        = lv_file_path
        EXCEPTIONS
          path_not_found             = 1
          missing_parameter          = 2
          operating_system_not_found = 3
          file_system_not_found      = 4
          OTHERS                     = 5.

      lv_file = lv_file_path.
      CONDENSE  lv_file NO-GAPS.
      CLOSE DATASET lv_file.

      OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc = 0.
        LOOP AT li_item_e  INTO DATA(fp_file_data).
          TRANSFER fp_file_data TO lv_file.
        ENDLOOP.
      ENDIF.
      CLOSE DATASET lv_file.

      CONCATENATE 'ZREW' '_' sy-datum '_' sy-uzeit '_' sy-uname  INTO lv_jobname.
      CALL FUNCTION 'JOB_OPEN'
        EXPORTING
          jobname          = lv_jobname
        IMPORTING
          jobcount         = lv_number
        EXCEPTIONS
          cant_create_job  = 1
          invalid_job_data = 2
          jobname_missing  = 3
          OTHERS           = 4.
      IF sy-subrc = 0.
        SUBMIT zqtcr_zrew_future_renewal  WITH s_vbeln IN lr_vbeln
                                          WITH s_posnr IN lr_posnr
                                          WITH p_file = lv_file
                                          USER  'QTC_BATCH01'
                                          VIA JOB lv_jobname NUMBER lv_number
                                          AND RETURN.
        CALL FUNCTION 'JOB_CLOSE'
          EXPORTING
            jobname              = lv_jobname
            jobcount             = lv_number
            predjob_checkstat    = lv_pre_chk
            sdlstrtdt            = sy-datum
            sdlstrttm            = sy-uzeit
          EXCEPTIONS
            cant_start_immediate = 01
            invalid_startdate    = 02
            jobname_missing      = 03
            job_close_failed     = 04
            job_nosteps          = 05
            job_notex            = 06
            lock_failed          = 07
            OTHERS               = 08.

        CONCATENATE 'Background Job'(003)
                    lv_jobname
                    'has been scheduled'(004)
         INTO  wa_orders-message SEPARATED BY space.

        copy_data_to_ref(
        EXPORTING
          is_data = wa_orders
        CHANGING
          cr_data = er_deep_entity ).
      ENDIF.
    ELSE.

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


      FREE:lst_head,lst_headx,li_item,li_itemx,li_partners,li_schedules_in,
           li_schedules_inx,li_return,li_address,lv_item,lv_cnt,lv_salesdoc,
           lst_bape_vbap,lst_bape_vbapx,lst_extensionin,li_extensionin.

      LOOP AT lr_vbeln INTO lst_vbeln.
        READ TABLE wa_orders-np_vbeln  INTO DATA(lst_input) WITH KEY  vbeln = lst_vbeln-low.
        IF sy-subrc = 0.
          DATA(lv_tabix) = sy-tabix.
          LOOP AT wa_orders-np_vbeln  INTO lst_input FROM lv_tabix.
            IF lst_input-vbeln <> lst_vbeln-low.
              EXIT.
            ELSE. "   IF lst_input-vbeln <> lst_vbeln-low.
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
* If the material changes
                  IF lst_input-matnr NE lst_input-matnr_old.
                    CLEAR:lst_item,lst_itemx.
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
                    lst_schedules_inx-itm_number = lst_item-itm_number..
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
                        im_zzsubtyp   = lst_bape_vbap-zzsubtyp
                        im_zzvyp      = lst_bape_vbap-zzvyp
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
                  ENDIF. "IF lst_input-matnr NE lst_input-matnr_old.

*--if you using same material renewal

                  CLEAR:lst_item.
                  lst_item-itm_number = lv_item.
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

                  lst_item-material   = lst_input-matnr.
                  lst_item-target_qty = lst_input-zmeng.
                  lst_item-ref_doc    = lst_data-vbeln.
                  lst_item-ref_doc_it = lst_data-posnr.
                  lst_item-price_grp  = lst_input-price.
                  lst_item-ref_doc_ca = lc_g.
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

                  CLEAR:lst_schedules_in,lst_schedules_inx.
                  lst_schedules_in-itm_number  = lst_item-itm_number.
                  lst_schedules_inx-itm_number = lst_item-itm_number.
                  lst_schedules_in-req_qty     = lst_input-zmeng.
                  lst_schedules_inx-req_qty    = abap_true.
                  APPEND lst_schedules_in TO li_schedules_in.
                  APPEND lst_schedules_inx TO li_schedules_inx.
*----Contract start dates and end dates

                  CLEAR:lst_veda_date,lst_veda_datex.
                  CALL METHOD zcl_zqtc_future_renewal_e256=>veda_data
                    EXPORTING
                      im_veda       = li_veda
                      im_vbkd       = li_vbkd
                      im_posnr      = lst_item-itm_number
                      im_vbeln      = lst_data-vbeln
                      im_zzsubtyp   = lst_bape_vbap-zzsubtyp
                      im_zzvyp      = lst_bape_vbap-zzvyp
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

* Populate Partners
*    "*  BOC OTCM-47292 by Prabhu 6/16/2021
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

                  IF lst_input-kunff IS NOT INITIAL AND lst_input-del_ff IS INITIAL..
*  EOC OTCM-47292 by Prabhu 6/16/2021
                    CLEAR:lst_partner.
                    lst_partner-partn_numb = lst_input-kunff.
                    lst_partner-itm_number = lc_header."lv_item.
                    lst_partner-partn_role = lc_sp.
                    APPEND lst_partner TO li_partners.
                    CLEAR lst_partner.
                  ENDIF.

*---Address change
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
                    lst_partner-partn_numb = lst_input-kunwe.
                    lst_partner-partn_role = lc_we.
                    "Update Shipto address at header requested during UAT- Prabhu
                    lst_partner-itm_number = lc_header."lst_item-itm_number.
                    READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_input-kunwe.
                    IF sy-subrc = 0.
                      lst_partner-name       = lst_kna1-name1.
                      lst_partner-name_2     = lst_kna1-name2.
                      READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_kna1-adrnr.
                      IF sy-subrc = 0.
                        lst_partner-langu     = lc_en.
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
                          lst_address-langu = lc_en.
                          lst_address-tel1_numbr = lst_adrc-tel_number.
                          lst_address-e_mail     = lst_adrc-smtp_addr.
                          lst_address-time_zone  = lst_adrc-time_zone.
                          lst_address-comm_type  = lst_adrc-deflt_comm.
                        ENDIF.
                      ENDIF.
                      lst_address-addr_no    = lv_cnt.
                      lst_address-postl_cod1 = lst_input-post_code1.
                      lst_address-street     = lst_input-street.
                      lst_address-str_suppl1 = lst_input-str_suppl1.
                      lst_address-str_suppl2 = lst_input-str_suppl2.
                      lst_address-str_suppl3 = lst_input-str_suppl3.
                      lst_address-location   = lst_input-location.
                      lst_address-city       = lst_input-city1.
                      lst_address-country    = lst_input-country.
                      lst_address-region     = lst_input-region.
                      lst_address-langu      = lc_en.
                      APPEND lst_address TO li_address.
                      CLEAR lst_address.
                    ENDIF. " IF lst_input-location IS NOT INITIAL.
                  ENDIF.
                ELSE. "READ TABLE li_renewal INTO DATA(lst_renewal) WITH  KEY vbeln = lst_input-vbeln
                  LOOP AT wa_orders-np_vbeln ASSIGNING FIELD-SYMBOL(<fs_orders>)
                            WHERE vbeln =  lst_data-vbeln AND posnr = lst_data-posnr.
                    <fs_orders>-msg1 = 'Already Contract Renewed'(011) .
                    <fs_orders>-type = 'Error'(008).
                  ENDLOOP.
                ENDIF. "READ TABLE li_renewal INTO DATA(lst_renewal) WITH  KEY vbeln = lst_input-vbeln
              ENDIF. "READ TABLE li_data INTO DATA(lst_data) WITH KEY vbeln = lst_input-vbeln
            ENDIF. "   IF lst_input-vbeln <> lst_vbeln-low.
          ENDLOOP.

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

              wa_orders-vbeln   = lv_salesdoc.
              CONCATENATE 'Renewal Order'(005)
                           lv_salesdoc
                           'Created Successfully'(006)
                           INTO  wa_orders-message SEPARATED BY space.
              LOOP AT wa_orders-np_vbeln ASSIGNING <fs_orders>
                WHERE vbeln =  lst_data-vbeln." AND posnr = lst_data-posnr.
                <fs_orders>-msg1 = wa_orders-message."lv_salesdoc.
                <fs_orders>-future_ord = lv_salesdoc.
                <fs_orders>-type = 'Success'(007).
*  BOC OTCM-47292 by Prabhu 6/16/2021
                CONCATENATE 'http://'(002) lv_host ':'
                        lv_port lc_va43
                        lv_salesdoc
                        INTO <fs_orders>-link.
*  EOC OTCM-47292 by Prabhu 6/16/2021
              ENDLOOP.

            ELSE. "IF lv_salesdoc IS NOT INITIAL.

              SORT li_return BY type.
              DELETE li_return WHERE type EQ lc_s.
              LOOP AT wa_orders-np_vbeln ASSIGNING <fs_orders>
                WHERE vbeln =  lst_data-vbeln." AND posnr = lst_data-posnr.
                READ TABLE li_return INTO lst_return INDEX 1.
                IF sy-subrc = 0.
                  <fs_orders>-msg1 = lst_return-message.
                ENDIF.
                READ TABLE li_return INTO lst_return INDEX 2.
                IF sy-subrc = 0.
                  <fs_orders>-msg2 = lst_return-message.
                ENDIF.
                READ TABLE li_return INTO lst_return INDEX 3.
                IF sy-subrc = 0.
                  <fs_orders>-msg3 = lst_return-message.
                ENDIF.
                IF lst_return-type = lc_e.
                  <fs_orders>-type = 'Error'(008).
                ELSEIF lst_return-type = lc_w.
                  <fs_orders>-type = 'Warning'(009).
                ELSEIF lst_return-type = lc_i.
                  <fs_orders>-type = 'Information'(010).
                ENDIF.

              ENDLOOP.
              FREE:li_return.
            ENDIF. " IF lv_salesdoc IS NOT INITIAL.
          ENDIF. "  IF  lst_head IS NOT INITIAL
        ENDIF. "READ TABLE wa_orders-np_vbeln  INTO DATA(lst_input)
        FREE:lst_head,lst_headx,li_item,li_itemx,li_partners,li_schedules_in,
             li_schedules_inx,li_return,li_address,lv_item,lv_cnt,lv_salesdoc,
             lst_bape_vbap,lst_bape_vbapx,lst_extensionin,li_extensionin.
      ENDLOOP.

      copy_data_to_ref(
          EXPORTING
            is_data = wa_orders
          CHANGING
            cr_data = er_deep_entity ).

    ENDIF.
  ENDMETHOD.


  METHOD addresscheckset_get_entityset.

    DATA:lst_input2  TYPE  addr2_data,
         lst_addrdat TYPE bapibus1006_addr_search,
         lst_centdat TYPE bapibus1006_central_search.
    DATA:lt_partner TYPE STANDARD TABLE OF bapibus1006_bp_addr,
         lt_return  TYPE STANDARD TABLE OF bapiret2,
         lst_final  TYPE zcl_zqtc_future_ren_01_mpc=>ts_addresscheck.

* Local constants declarations for partner categories
    CONSTANTS: lc_per TYPE bu_type VALUE '1',  " Person
               lc_org TYPE bu_type VALUE '2'.  " Organization

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'City'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-city1 = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'PostalCode'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-post_code1 = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'Street'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-street = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'Country'.
            IF <ls_filter_opt>-low  NE 'nul'.
              lst_input2-country = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'StrSuppl1'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-str_suppl1 = <ls_filter_opt>-low.
            ENDIF.

          WHEN 'Region'.
            IF <ls_filter_opt>-low  NE 'nul'.
              lst_input2-region = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'FirstName'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-name_first = <ls_filter_opt>-low.
            ENDIF.
          WHEN 'LastName'.
            IF <ls_filter_opt>-low  NE 'null'.
              lst_input2-name_last = <ls_filter_opt>-low.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    lst_input2-date_from = '00010101'.
    lst_input2-date_to   = '99991231'.

    IF  lst_input2 IS NOT INITIAL.

*** Populating central data
* Last Name
      IF lst_input2-name_last IS NOT INITIAL .
        lst_centdat-mc_name1 = '*' && lst_input2-name_last && '*'.
      ENDIF.

* First Name
      IF lst_input2-name_first IS NOT INITIAL .
        lst_centdat-mc_name2 = '*' && lst_input2-name_first && '*'.
      ENDIF.

* Partner Category for person
      lst_centdat-partnercategory = lc_per.

*** Populating Address Data
* City
      lst_addrdat-city1      = lst_input2-city1.

* Postal code
      CONCATENATE lst_input2-post_code1+0(5) '*' INTO lst_addrdat-postl_cod1.

* Country
      lst_addrdat-country    = lst_input2-country.

* Street
      IF lst_input2-street IS NOT INITIAL.
* To fetch all the records which contain the street or part of it
        CONCATENATE '*' lst_input2-street '*' INTO lst_addrdat-street.
      ENDIF.

* House Number
      lst_addrdat-house_no   = lst_input2-house_num1.

* Region
      lst_addrdat-region     = lst_input2-region.

* Call BAPI for the partner search with the above data
      CALL FUNCTION 'BAPI_BUPA_SEARCH'
        EXPORTING
          addressdata  = lst_addrdat
          centraldata  = lst_centdat
        TABLES
          searchresult = lt_partner
          return       = lt_return.

****** Fetch data from BUT000, BUT020, BUT0ID and ADRC
* for all the partners returned from BAPI    ******
      IF lt_partner IS NOT INITIAL.
*** Fetch address numbers of the partners from BUT020

* For Person
        SELECT b~partner,         " Partner Number
               c~addrnumber,      " Address Number
               b~name_first,      " First Name
               b~name_last       " Last Name
         INTO TABLE @DATA(lt_addrnr)
         FROM but000 AS b        " Partner Table
         INNER JOIN but020 AS c  " Partner Addess Data
         ON c~partner = b~partner
         FOR ALL ENTRIES IN @lt_partner
         WHERE b~partner =  @lt_partner-partner.


*** Fetch the address fields from ADRC table
        IF lt_addrnr IS NOT INITIAL.
          SORT lt_addrnr BY partner addrnumber.
          DELETE ADJACENT DUPLICATES FROM lt_addrnr
                 COMPARING partner addrnumber.
          SELECT   addrnumber,       " Address Number
                   city1,            " City
                   post_code1,       " Postal Code
                   street,           " Street
                   str_suppl1,       " Street 1
                   str_suppl2,       " Street 2
                   str_suppl3,       " Street 4
                   location,         " Street 5
                   house_num1,       " House Number
                   country,          " Country
                   region           " Region / State
              INTO TABLE @DATA(lt_addr)
              FROM adrc             " Address (Business Address Services)
              FOR ALL ENTRIES IN @lt_addrnr
              WHERE addrnumber = @lt_addrnr-addrnumber.

* Sorting the tables
          SORT lt_addr    BY addrnumber.

* Prepare the final data

* Prepare the data for final output
          LOOP AT lt_addrnr INTO DATA(lst_addrnr).
* Partner number and name fields
            lst_final-partner      = lst_addrnr-partner.    " Partner Number
            lst_final-first_name   = lst_addrnr-name_first. " First Name
            lst_final-last_name    = lst_addrnr-name_last.  " Last Name

* Address Fields
            READ TABLE lt_addr INTO DATA(lst_addr)
                       WITH KEY addrnumber = lst_addrnr-addrnumber
                       BINARY SEARCH.
            IF sy-subrc = 0.
              lst_final-city         = lst_addr-city1.         " City
              lst_final-postal_code  = lst_addr-post_code1.    " Postal Code
              lst_final-street       = lst_addr-street.        " Street
              lst_final-str_suppl3   = lst_addr-str_suppl3.    " Street 4
              lst_final-str_suppl1   = lst_addr-str_suppl1.    " Street 4
              lst_final-str_suppl2   = lst_addr-str_suppl2.    " Street 4
              lst_final-location     = lst_addr-location.      " Street 5
              lst_final-house_num1   = lst_addr-house_num1.    " House Number
              lst_final-country      = lst_addr-country.       " Country Code
              lst_final-region       = lst_addr-region.        " Region
              APPEND lst_final  TO et_entityset.
              CLEAR lst_final.
            ENDIF.   " IF sy-subrc = 0.
          ENDLOOP.
        ENDIF. " IF gt_addrnr IS NOT INITIAL.
      ENDIF. " IF gt_partner IS NOT INITIAL.
    ENDIF.

  ENDMETHOD.


  METHOD countryset_get_entityset.
    TYPES:BEGIN OF ty_landx,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE landx,
            high   TYPE landx,
          END OF ty_landx.
    DATA:lir_landx TYPE RANGE OF landx,
         lst_landx TYPE ty_landx,
         lir_land1 TYPE shp_land1_range_t,
         lst_land1 TYPE shp_land1_range,
         lv_landx  TYPE char15.

    CONSTANTS:lc_i  TYPE char1 VALUE 'I',
              lc_cp TYPE char2 VALUE 'CP',
              lc_eq TYPE char2 VALUE 'EQ'.

    FREE:lir_landx,lst_landx,lir_land1,lst_land1,lv_landx.
    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Landx'.
            lst_landx-low = <ls_filter_opt>-low.
            lst_land1-low = <ls_filter_opt>-low.
            IF lst_landx-low NE 'nul'.
              IF  lst_landx-low IS NOT INITIAL.
                lst_landx-option = lc_cp.
                lst_land1-option = lc_eq.
                lst_land1-sign   = lc_i.
                lst_landx-sign   = lc_i.
                APPEND lst_land1 TO lir_land1.
                CLEAR lv_landx.
                CONCATENATE lst_landx-low '*' INTO lv_landx.
                lst_landx-low = lv_landx.
                APPEND lst_landx TO lir_landx.
                CLEAR lv_landx.
                TRANSLATE lst_land1-low TO UPPER CASE.
                APPEND lst_land1 TO lir_land1.
                CLEAR lv_landx.
                CONCATENATE lst_landx-low '*' INTO lv_landx.
                TRANSLATE lv_landx+0(1) TO UPPER CASE.
                lst_landx-low = lv_landx.
                APPEND lst_landx TO lir_landx.
              ENDIF.
            ENDIF.

        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    SELECT land1
           landx
           natio
      FROM t005t
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE spras = sy-langu
         AND ( land1 IN lir_land1
         OR landx IN lir_landx
         OR natio IN lir_landx ).
  ENDMETHOD.


  METHOD exclusiondetails_get_entityset.
    DATA:lir_vbeln TYPE STANDARD TABLE OF edm_vbeln_range,
         lst_vbeln TYPE edm_vbeln_range,
         lir_posnr TYPE STANDARD TABLE OF sdsls_posnr_range,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_exclusiondetails,
         lst_posnr TYPE sdsls_posnr_range,
         lv_posnr  TYPE char6.

    CONSTANTS:lc_i  TYPE char1 VALUE 'I',
              lc_eq TYPE char2 VALUE 'EQ'.


    FREE:lir_vbeln,
         lst_vbeln,
         lir_posnr,
         lv_posnr,
         lst_posnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.  " Contract
            lst_vbeln-low = <ls_filter_opt>-low.
            IF lst_vbeln-low NE 'null'.
              lst_vbeln-sign    = lc_i.
              lst_vbeln-option  = lc_eq.
              APPEND lst_vbeln TO lir_vbeln.
            ENDIF.

          WHEN 'Posnr'.  "Line item
            lst_posnr-low = <ls_filter_opt>-low.
            lst_posnr-sign    = lc_i.
            lst_posnr-option  = lc_eq.
            APPEND lst_posnr TO lir_posnr.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_vbeln IS NOT INITIAL
      AND lir_posnr IS NOT INITIAL.
      SELECT vbeln,
             posnr,
             excl_resn,
             excl_date,
             excl_resn2,
             excl_date2,
             other_cmnts
        FROM zqtc_renwl_plan
        INTO TABLE @DATA(li_renwl_plan)
        WHERE vbeln IN @lir_vbeln
          AND posnr IN @lir_posnr.

      SELECT excl_resn, excl_resn_d
        FROM zqtct_excl_resn
        INTO TABLE @DATA(li_excl_resn)
        WHERE spras = @sy-langu.
    ENDIF.

    LOOP AT li_renwl_plan INTO DATA(lst_renwl_plan).
      lst_final-vbeln       =   lst_renwl_plan-vbeln.
      CLEAR lv_posnr.
      lv_posnr       =   lst_renwl_plan-posnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_posnr
        IMPORTING
          output = lv_posnr.
      lst_final-posnr       =   lv_posnr.
      lst_final-excl_resn   =   lst_renwl_plan-excl_resn.
      lst_final-excl_date   =   lst_renwl_plan-excl_date.  "Exclusive date
      lst_final-excl_resn2  =   lst_renwl_plan-excl_resn2.
      lst_final-excl_date2  =   lst_renwl_plan-excl_date2.""Exclusive date 2
      lst_final-other_cmnts  =   lst_renwl_plan-other_cmnts.
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_final-excl_date
        IMPORTING
          output = lst_final-excl_date.
*
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_final-excl_date2
        IMPORTING
          output = lst_final-excl_date2.
      READ TABLE li_excl_resn INTO DATA(lst_excl_resn) WITH KEY excl_resn = lst_final-excl_resn.
      IF sy-subrc = 0.
        lst_final-excl_resn_d = lst_excl_resn-excl_resn_d.
      ENDIF.
      READ TABLE li_excl_resn INTO lst_excl_resn WITH KEY excl_resn = lst_final-excl_resn2.
      IF sy-subrc = 0.
        lst_final-excl_resn_d2 = lst_excl_resn-excl_resn_d.
      ENDIF.
      APPEND lst_final TO et_entityset.
      CLEAR :lst_final,lst_renwl_plan.
    ENDLOOP.

  ENDMETHOD.


  METHOD ffagentset_get_entityset.
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_maxrow TYPE bapi_epm_max_rows.
    DATA:lst_lifnr TYPE shp_kunnr_range,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lir_lifnr TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS:lc_i    TYPE char1 VALUE 'I',
              lc_cp   TYPE char2 VALUE 'CP',
              lc_zfrt TYPE ktokk VALUE 'ZFRT'.

    FREE:lst_lifnr,
          lst_name,
          lir_name,
         lir_lifnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Name1'.
            lst_lifnr-low = <ls_filter_opt>-low.
            IF lst_lifnr-low NE 'null'.
              IF  lst_lifnr-low IS NOT INITIAL.
                lst_lifnr-option = lc_cp.
                lst_name-option = lc_cp.
                lst_lifnr-sign = lc_i.
                lst_name-sign = lc_i.
                CONCATENATE <ls_filter_opt>-low '*' INTO DATA(lv_name).
                lst_lifnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_lifnr TO lir_lifnr.
                APPEND lst_name TO lir_name.
                CLEAR lv_name.
                CONCATENATE '*' <ls_filter_opt>-low '*' INTO lv_name.
                lst_lifnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_lifnr TO lir_lifnr.
                APPEND lst_name TO lir_name.
                DATA(lv_length) = strlen( lv_name ).
                IF lv_length GT 3.
                  lv_length = lv_length - 3.
                  DATA(lv_letter) = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter lv_name+2(lv_length) '*'
                  INTO lv_name.
                  lst_lifnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_lifnr TO lir_lifnr.
                  APPEND lst_name TO lir_name.
                ELSEIF lv_length EQ 3.
                  lv_length = lv_length - 3.
                  lv_letter = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter '*'
                  INTO lv_name.
                  lst_lifnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_lifnr TO lir_lifnr.
                  APPEND lst_name TO lir_name.
                ENDIF.

                TRANSLATE lv_name TO UPPER CASE.
                lst_lifnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_lifnr TO lir_lifnr.
                APPEND lst_name TO lir_name.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SELECT lifnr
           name1
           name2
           ort01
           land1
           sortl
           mcod1
      FROM lfa1
      INTO CORRESPONDING FIELDS OF TABLE et_entityset UP TO 25 ROWS
      WHERE ktokk = lc_zfrt
      AND ( lifnr IN lir_lifnr
       OR   name1 IN lir_name
       OR   name2 IN lir_name ).
  ENDMETHOD.


  METHOD getlistset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  OTCM-OTCM-47292/ERPM-25282
* DEVELOPER:Prabhu(PTUFARAM)
* DATE:  6/18/2021
* DESCRIPTION: Additional fields
*----------------------------------------------------------------------*
    DATA:ir_status   TYPE RANGE OF char1,
         ir_status1  TYPE RANGE OF char1,
         lst_view    TYPE order_view,
         lst_order   TYPE sales_key,
         lv_date     TYPE char10,
         lv_start    TYPE char10,
         lv_end      TYPE char10,
         li_order    TYPE STANDARD TABLE OF sales_key,
         li_header   TYPE STANDARD TABLE OF bapisdhd,
         li_item     TYPE STANDARD TABLE OF bapisdit,
         li_business TYPE STANDARD TABLE OF bapisdbusi,
         li_partner  TYPE STANDARD TABLE OF bapisdpart,
         li_address  TYPE STANDARD TABLE OF bapisdcoad,
         lst_final   TYPE zcl_zqtc_future_ren_01_mpc=>ts_getlist,
         lst_kunnr   TYPE shp_kunnr_range,
         lv_price    TYPE p DECIMALS 2,
         li_status_t TYPE STANDARD TABLE OF dd07v,
         ir_kunnr    TYPE STANDARD TABLE OF shp_kunnr_range,
         lv_host     TYPE string,
         lv_port     TYPE string,
         lv_qty      TYPE char18,
         lv_dec      TYPE char10,
         lv_zmeng    TYPE char18.
    CONSTANTS:lc_va43  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA43%20VBAK-VBELN='.
    CONSTANTS: lc_eq     TYPE char2 VALUE 'EQ',
               lc_cp     TYPE char2 VALUE 'CP',
               lc_i      TYPE char1 VALUE 'I',
               lc_ag     TYPE parvw VALUE 'AG',
               lc_we     TYPE parvw VALUE 'WE',
               lc_sp     TYPE parvw VALUE 'SP',
               lc_cs     TYPE zactivity_sub VALUE 'CS',
               lc_r      TYPE char1 VALUE 'R',
               lc_g      TYPE char1 VALUE 'G',
               lc_zrew   TYPE auart VALUE 'ZREW',
               lc_zsub   TYPE auart VALUE 'ZSUB',
               lc_zwoa   TYPE pstyv VALUE 'ZWOA',
               lc_header TYPE posnr VALUE '000000'.

    cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
             port = lv_port ).


    FREE:ir_status,
         lst_view,
         lst_order,
         lv_date,
         lv_start,
         lv_end,
         li_order,
         li_header,
         li_item ,
         li_business,
         li_partner,
         li_address,
         lst_final,
         lst_kunnr,
         lv_price ,
         li_status_t,
         ir_kunnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Vbegdat'.  " Contract Start date
            CLEAR lv_date.
            lv_date = <ls_filter_opt>-low.
            IF lv_date NE 'null'.
              CONCATENATE lv_date+0(4)
                          lv_date+5(2)
                          lv_date+8(2)
                          INTO lv_start.
            ENDIF.

          WHEN 'Venddat'.  "Contract end date
            CLEAR lv_date.
            lv_date = <ls_filter_opt>-low.
            IF lv_date NE 'null'.
              CONCATENATE lv_date+0(4)
                          lv_date+5(2)
                          lv_date+8(2)
                          INTO lv_end.
            ENDIF.
          WHEN 'Kunag'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_eq.
                lst_kunnr-sign = lc_i.
                APPEND lst_kunnr TO ir_kunnr.
              ENDIF.
            ENDIF.
          WHEN 'RenStatus'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'n'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_eq.
                lst_kunnr-sign = lc_i.
                IF lst_kunnr-low NE lc_r.
                  APPEND lst_kunnr TO ir_status.
                ELSE.
                  DATA(lv_status) = lst_kunnr-low.
                ENDIF.

              ENDIF.
            ENDIF.

        ENDCASE.
      ENDLOOP.
    ENDLOOP.



    IF lv_start IS NOT INITIAL
      OR lv_end IS NOT INITIAL.
      SELECT vbak~vbeln,
             veda~vposn,
             veda~vbegdat,
             veda~venddat,
             zqtc_renwl_plan~posnr,
             zqtc_renwl_plan~renwl_prof,
             zqtc_renwl_plan~act_status,
             zqtc_renwl_plan~ren_status,
             zqtc_renwl_plan~excl_resn,
             zqtc_renwl_plan~excl_date,
             zqtc_renwl_plan~excl_resn2,
             zqtc_renwl_plan~excl_date2,
             zqtc_renwl_plan~other_cmnts
        INTO TABLE @DATA(li_veda)
        FROM vbak
        INNER JOIN veda ON vbak~vbeln = veda~vbeln
        INNER JOIN vbap ON vbap~vbeln = veda~vbeln
        INNER JOIN zqtc_renwl_plan ON  zqtc_renwl_plan~vbeln = veda~vbeln
        WHERE ( veda~vbegdat GE @lv_start
          AND veda~venddat LE @lv_end )
          AND vbak~kunnr IN @ir_kunnr
          AND vbap~pstyv NE @lc_zwoa
          AND ( vbak~auart = @lc_zsub
           OR vbak~auart = @lc_zrew )
          AND zqtc_renwl_plan~ren_status IN @ir_status
          AND zqtc_renwl_plan~activity = @lc_cs.
    ENDIF.

    IF lv_status = lc_r.
      SORT li_veda BY ren_status.
      DELETE li_veda WHERE ren_status NE space.
    ENDIF.

    SORT li_veda BY vbeln.
    LOOP AT li_veda INTO DATA(lst_veda).
      lst_order-vbeln = lst_veda-vbeln.
      APPEND lst_order TO li_order.
    ENDLOOP.

    lst_view-header   = abap_true.
    lst_view-item     = abap_true.
    lst_view-business = abap_true.
    lst_view-partner  = abap_true.
    lst_view-address  = abap_true.

    IF li_order IS NOT INITIAL.

      CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
        EXPORTING
          i_bapi_view        = lst_view
        TABLES
          sales_documents    = li_order
          order_headers_out  = li_header
          order_items_out    = li_item
          order_business_out = li_business
          order_partners_out = li_partner
          order_address_out  = li_address.

      SELECT konda,
              vtext
             FROM t188t
             INTO TABLE @DATA(li_t188t)
             WHERE spras = @sy-langu.

      SELECT *
        FROM t042zt
        INTO TABLE @DATA(li_t042zt)
        WHERE spras = @sy-langu.


      SELECT *
        FROM zqtct_renwl_prof
        INTO TABLE @DATA(li_renwl_prf)
        WHERE spras = @sy-langu.
      IF li_address IS NOT INITIAL.
        SELECT addrnumber,
               str_suppl1,
               str_suppl2,
               str_suppl3,
               location
          FROM adrc
          INTO TABLE @DATA(li_adrc)
          FOR ALL ENTRIES IN @li_address
          WHERE addrnumber = @li_address-address.
      ENDIF.
      CALL FUNCTION 'DD_DOMVALUES_GET'
        EXPORTING
          domname        = 'ZREN_STATUS'
          text           = abap_true
          langu          = sy-langu
        TABLES
          dd07v_tab      = li_status_t
        EXCEPTIONS
          wrong_textflag = 1
          OTHERS         = 2.


      IF li_item IS NOT INITIAL.
        SELECT vbelv,
               posnv,
               vbeln,
               posnn
          FROM vbfa
          INTO TABLE @DATA(li_vbfa)
          FOR ALL ENTRIES IN @li_item
          WHERE vbelv = @li_item-doc_number
            AND posnv = @li_item-itm_number
            AND vbtyp_n = @lc_g.
        IF li_vbfa IS NOT INITIAL.
          SELECT vbeln,
                 posnr,
                 tbnam,
                 fdnam
            FROM vbuv
            INTO TABLE @DATA(li_vbuv)
            FOR ALL ENTRIES IN @li_vbfa
           WHERE vbeln = @li_vbfa-vbeln.
        ENDIF.
      ENDIF.
      LOOP AT li_header INTO DATA(lst_header).
        READ TABLE li_item INTO DATA(lst_item) WITH KEY doc_number = lst_header-doc_number.
        IF sy-subrc = 0.
          DATA(lv_tabix) = sy-tabix.
          LOOP AT li_item INTO lst_item FROM lv_tabix.
            IF lst_item-doc_number <> lst_header-doc_number.
              EXIT.
            ELSE.
              IF lst_item-rea_for_re IS INITIAL.  "Reason for rejection lines avoiding
                READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_header-doc_number
                                                          posnr = lst_item-itm_number.
                IF sy-subrc = 0.
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_header-doc_number
                                                            vposn = lst_item-itm_number.
                  IF sy-subrc = 0.
                    lst_final-vbegdat = lst_veda-vbegdat.
                    lst_final-venddat = lst_veda-venddat.
                  ELSE.
                    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_header-doc_number.
                    IF sy-subrc = 0.
                      lst_final-vbegdat = lst_veda-vbegdat.
                      lst_final-venddat = lst_veda-venddat.
                    ENDIF.
                  ENDIF.

                  lst_final-vbeln   = lst_header-doc_number.
                  lst_final-posnr   = lst_item-itm_number.
                  lst_final-posnr_c = lst_item-itm_number.

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = lst_final-posnr_c
                    IMPORTING
                      output = lst_final-posnr_c.

                  lst_final-matnr       = lst_item-material.
                  lst_final-matnr_old   = lst_item-material.
                  lst_final-maktx       = lst_item-short_text.
                  CLEAR: lv_price.
                  lv_zmeng       = lst_item-target_qty.
                  SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
                  CONDENSE lv_qty.
                  lst_final-zmeng        = lv_qty.
                  lst_final-zmeng_old   = lv_qty.
                  lst_final-zieme       = lst_item-target_qu.
                  lv_price              = lst_item-net_value.
                  lst_final-netwr       = lv_price.
                  lst_final-waerk       = lst_item-currency.
                  CONDENSE:lst_final-zmeng,lst_final-netwr.


                  CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                    EXPORTING
                      input  = lst_final-vbegdat
                    IMPORTING
                      output = lst_final-vbegdat.

                  CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                    EXPORTING
                      input  = lst_final-venddat
                    IMPORTING
                      output = lst_final-venddat.

                  READ TABLE li_partner INTO DATA(lst_partner) WITH KEY sd_doc      = lst_header-doc_number
                                                                        itm_number  = lst_item-itm_number
                                                                         partn_role = lc_ag.
                  IF sy-subrc = 0.
                    lst_final-kunag     = lst_partner-customer.
                    lst_final-kunag_old = lst_partner-customer.
                  ELSE.
                    READ TABLE li_partner INTO lst_partner WITH KEY sd_doc     = lst_header-doc_number
                                                                    itm_number  = lc_header
                                                                    partn_role = lc_ag.
                    IF sy-subrc = 0.
                      lst_final-kunag     = lst_partner-customer.
                      lst_final-kunag_old = lst_partner-customer.
                    ENDIF.
                  ENDIF.
                  READ TABLE li_address INTO DATA(lst_address) WITH KEY doc_number = lst_header-doc_number
                                                                        address = lst_partner-address.
                  IF sy-subrc = 0.
                    lst_final-name_ag = lst_address-name.
                    lst_final-ag_street = lst_address-street.
                    lst_final-ag_city1 = lst_address-city.
                    lst_final-ag_region = lst_address-region.
                    lst_final-ag_district = lst_address-district.
                    lst_final-ag_country = lst_address-country.
                    lst_final-ag_post_code1 = lst_address-postl_code.
                  ENDIF.
                  READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_partner-address.
                  IF sy-subrc = 0.
                    lst_final-ag_str_suppl1 = lst_adrc-str_suppl1.
                    lst_final-ag_str_suppl2 = lst_adrc-str_suppl2.
                    lst_final-ag_str_suppl3 = lst_adrc-str_suppl3.
                    lst_final-ag_location = lst_adrc-location.
                  ENDIF.
                  CLEAR : lst_partner,lst_address.
                  READ TABLE li_partner INTO lst_partner WITH KEY sd_doc = lst_header-doc_number
                                                                  itm_number = lst_item-itm_number
                                                                  partn_role = lc_we.
                  IF sy-subrc = 0.
                    lst_final-kunwe = lst_partner-customer.
                  ELSE.
                    READ TABLE li_partner INTO lst_partner WITH KEY sd_doc = lst_header-doc_number
                                                                    itm_number = lc_header
                                                                    partn_role = lc_we.
                    IF sy-subrc = 0.
                      lst_final-kunwe = lst_partner-customer.
                      lst_final-kunwe_old = lst_partner-customer.
                    ENDIF.
                  ENDIF.

                  READ TABLE li_address INTO lst_address WITH KEY doc_number = lst_header-doc_number
                                                                  address = lst_partner-address.
                  IF sy-subrc = 0.
                    lst_final-name_we     = lst_address-name.
                    lst_final-street      = lst_address-street.
                    lst_final-city1       = lst_address-city.
                    lst_final-country     = lst_address-country.
                    lst_final-district    = lst_address-district.
                    lst_final-region      = lst_address-region.
                    lst_final-post_code1  = lst_address-postl_code.
                  ENDIF.
                  CLEAR : lst_adrc.
                  READ TABLE li_adrc INTO lst_adrc WITH KEY addrnumber = lst_partner-address.
                  IF sy-subrc = 0.
                    lst_final-str_suppl1  = lst_adrc-str_suppl1.
                    lst_final-str_suppl2  = lst_adrc-str_suppl2.
                    lst_final-str_suppl3  = lst_adrc-str_suppl3.
                    lst_final-location    = lst_adrc-location.
                  ENDIF.
                  READ TABLE li_partner INTO lst_partner WITH KEY sd_doc = lst_header-doc_number
                                                                  itm_number = lst_item-itm_number
                                                                  partn_role = lc_sp.
                  IF sy-subrc = 0.
                    lst_final-kunff     = lst_partner-vendor_no.
                    lst_final-kunff_old = lst_partner-vendor_no.
                  ELSE.
                    READ TABLE li_partner INTO lst_partner WITH KEY sd_doc = lst_header-doc_number
                                                                    partn_role = lc_sp.
                    IF sy-subrc = 0.
                      lst_final-kunff     = lst_partner-vendor_no.
                      lst_final-kunff_old = lst_partner-vendor_no.
                    ENDIF.
                  ENDIF.
                  READ TABLE li_address INTO lst_address WITH KEY doc_number = lst_header-doc_number
                                                                   address = lst_partner-address.
                  IF sy-subrc = 0.
                    lst_final-name_ff = lst_address-name.
                  ENDIF.

                  READ TABLE li_business INTO DATA(lst_business) WITH KEY sd_doc = lst_header-doc_number
                                                                           itm_number = lst_item-itm_number.
                  IF sy-subrc = 0.
                    lst_final-price   = lst_business-price_grp.
                    lst_final-price_old   = lst_business-price_grp.
                    READ TABLE li_t188t  INTO DATA(lst_t188t) WITH KEY konda = lst_final-price.
                    IF sy-subrc = 0.
                      lst_final-price_desc  = lst_t188t-vtext.
                    ENDIF.
                    READ TABLE li_t042zt INTO DATA(lst_t042zt) WITH KEY zlsch = lst_business-paymethode.
                    IF sy-subrc = 0.
                      lst_final-text1 = lst_t042zt-text2.
                    ENDIF.
                    lst_final-zlsch      = lst_business-paymethode.
                    lst_final-zlsch_old  = lst_business-paymethode.
                  ENDIF.
                  READ TABLE li_veda INTO DATA(lst_renwlplan) WITH KEY vbeln = lst_header-doc_number
                                                                       posnr = lst_item-itm_number.
                  IF sy-subrc = 0.
                    lst_final-renwl_prof = lst_renwlplan-renwl_prof.
                    IF lst_renwlplan-excl_date IS NOT INITIAL.
                      lst_final-excl_status = abap_true.
                    ELSE.
                      lst_final-excl_status = abap_false.
                    ENDIF.
                    READ TABLE li_renwl_prf INTO DATA(lst_renwl_prf) WITH KEY renwl_prof = lst_renwlplan-renwl_prof.
                    IF sy-subrc = 0.
                      lst_final-renwl_prof_text = lst_renwl_prf-renwl_prof_d.
                    ENDIF.
                    lst_final-ren_status = lst_renwlplan-ren_status.
                    READ TABLE li_status_t INTO DATA(lst_status_t) WITH KEY domvalue_l =  lst_renwlplan-ren_status.
                    IF sy-subrc = 0.
                      lst_final-status_text   = lst_status_t-ddtext.
                    ENDIF.
                  ENDIF.
                  READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lst_header-doc_number
                                                                  posnv = lst_item-itm_number.
                  IF sy-subrc = 0.
                    lst_final-future_ord = lst_vbfa-vbeln.
                    READ TABLE li_vbuv INTO DATA(lst_vbuv) WITH KEY vbeln = lst_vbfa-vbeln.
                    IF sy-subrc = 0.
                      lst_final-incomplete = 'Incomplete'(001).
                    ENDIF.
                  ENDIF.
                  CONCATENATE 'http://'(002) lv_host ':'
                        lv_port lc_va43
                        lst_final-future_ord
                        INTO lst_final-link.

                  APPEND lst_final TO et_entityset.
                  CLEAR lst_final.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

      cl_http_server=>if_http_server~get_location(
                  IMPORTING host = lv_host
                         port = lv_port ).


    ENDIF.
  ENDMETHOD.


  METHOD getprdset_get_entityset.
    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_maxrow TYPE bapi_epm_max_rows.

    DATA:lst_matnr TYPE curto_matnr_range,
         lst_maktx TYPE fip_s_maktx_range,
         lir_maktx TYPE fip_t_maktx_range,
         lir_mtart TYPE fip_t_mtart_range,
         lst_mtart TYPE fip_s_mtart_range,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_getprd,
         lir_matnr TYPE STANDARD TABLE OF curto_matnr_range.

    CONSTANTS: lc_eq   TYPE char2 VALUE 'EQ',
               lc_cp   TYPE char2 VALUE 'CP',
               lc_i    TYPE char1 VALUE 'I',
               lc_zsbe TYPE mtart VALUE 'ZSBE',
               lc_zmjl TYPE mtart VALUE 'ZMJL',
               lc_zmmj TYPE mtart VALUE 'ZMMJ'.


    FREE:lst_final,
         lst_matnr,
         lst_mtart,
         lir_mtart,
         lst_maktx,
         lir_maktx,
         lst_final,
         lir_matnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Maktx '.
            CLEAR lst_matnr.
            lst_maktx-low = <ls_filter_opt>-low.
            IF lst_maktx-low NE 'null'.
              lst_maktx-option = lc_cp.
              lst_maktx-sign = lc_i.
              CONCATENATE '*' <ls_filter_opt>-low '*' INTO DATA(lv_value).
              lst_maktx-sign = lc_i.
              lst_maktx-low  = lv_value.
              lst_maktx-high = <ls_filter_opt>-high.
              APPEND lst_maktx TO lir_matnr.

              lst_maktx-option = lc_cp.
              lst_maktx-sign = lc_i.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
              TRANSLATE lv_value TO UPPER CASE.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_matnr.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    lst_mtart-sign   = lc_i.
    lst_mtart-option = lc_eq.
    lst_mtart-low    = lc_zsbe.
    APPEND lst_mtart TO lir_mtart.
    lst_mtart-low    = lc_zmjl.
    APPEND lst_mtart TO lir_mtart.
    lst_mtart-low    = lc_zmmj.
    APPEND lst_mtart TO lir_mtart.
    IF lir_maktx IS NOT INITIAL
      OR lir_matnr IS NOT INITIAL.
      SELECT mara~matnr,
             makt~maktx
        FROM mara
        INNER JOIN makt ON makt~matnr = mara~matnr
        INTO TABLE @DATA(li_code) UP TO 100 ROWS
        WHERE mara~matnr IN @lir_matnr
          OR makt~maktx IN @lir_maktx
          AND makt~spras = @sy-langu
          AND mara~mtart IN @lir_mtart.

    ELSE.

      SELECT mara~matnr,
            makt~maktx
       FROM mara
       INNER JOIN makt ON makt~matnr = mara~matnr
       INTO TABLE @li_code UP TO 100 ROWS
       WHERE mara~matnr IN @lir_matnr
         OR makt~maktx IN @lir_maktx
        AND makt~spras = @sy-langu
         AND mara~mtart IN @lir_mtart.
    ENDIF.

    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.

    IF lv_total > 0.
      LOOP AT li_code INTO DATA(lst_code)  FROM lv_skip TO lv_total.
        lst_final-matnr = lst_code-matnr.
        lst_final-maktx = lst_code-maktx.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ELSE.
      LOOP AT li_code INTO lst_code .
        lst_final-matnr = lst_code-matnr.
        lst_final-maktx = lst_code-maktx.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ENDIF.


    SORT et_entityset BY matnr.
  ENDMETHOD.


  METHOD includeset_get_entity.
    READ TABLE it_key_tab INTO DATA(lst_key_tab) INDEX 1.
    IF  sy-subrc = 0.
      SELECT SINGLE * FROM zqtc_renwl_plan
                INTO @DATA(lst_renwl) WHERE vbeln = @lst_key_tab-value.
         MOVE-CORRESPONDING lst_renwl TO er_entity.
    ENDIF.

  ENDMETHOD.


  METHOD includeset_update_entity.
    DATA : lst_input TYPE zcl_zqtc_future_ren_01_mpc=>ts_include.

    io_data_provider->read_entry_data( IMPORTING es_data  = lst_input ).

    DATA :lv_posnr TYPE posnr_va.

    IF  lst_input-posnr IS NOT INITIAL.
      lv_posnr = lst_input-posnr.
    ENDIF.

    SELECT *
      FROM zqtc_renwl_plan
      INTO  TABLE @DATA(li_renewal_plan)
      WHERE vbeln = @lst_input-vbeln
        AND posnr = @lv_posnr
        AND activity = 'CS'.

    IF li_renewal_plan IS NOT INITIAL AND lst_input-excl_resn IS NOT INITIAL.
      LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
        CLEAR: <lst_renewal_plan>-excl_resn, "Exclusion Reason
               <lst_renewal_plan>-excl_date. "Exclusion date
        <lst_renewal_plan>-aedat = sy-datum. "Changed On
        <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
        <lst_renewal_plan>-aenam = sy-uname. "Changed By
      ENDLOOP.
*   Update Renewal Plan Table
      CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
        TABLES
          t_renwl_plan = li_renewal_plan.
      COMMIT WORK AND WAIT.
    ELSEIF li_renewal_plan IS NOT INITIAL AND lst_input-excl_resn2 IS NOT INITIAL.
      LOOP AT li_renewal_plan ASSIGNING <lst_renewal_plan>.
        CLEAR: <lst_renewal_plan>-excl_resn2, "Exclusion Reason2
               <lst_renewal_plan>-excl_date2. "Exclusion date
        <lst_renewal_plan>-aedat = sy-datum. "Changed On
        <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
        <lst_renewal_plan>-aenam = sy-uname. "Changed By
      ENDLOOP.
*   Update Renewal Plan Table
      CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
        TABLES
          t_renwl_plan = li_renewal_plan.
      COMMIT WORK AND WAIT.
    ENDIF.


  ENDMETHOD.


  METHOD incompleteset_get_entityset.
    DATA:lir_vbeln TYPE STANDARD TABLE OF edm_vbeln_range,
         lst_vbeln TYPE edm_vbeln_range,
         lir_posnr TYPE STANDARD TABLE OF sdsls_posnr_range,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_incomplete,
         lst_posnr TYPE sdsls_posnr_range,
         lv_label  TYPE  string,
         lv_posnr  TYPE char6.

    CONSTANTS: lc_eq TYPE char2 VALUE 'EQ',
               lc_i  TYPE char1 VALUE 'I'.

    FREE:lir_vbeln,
         lv_label,
         lst_final,
         lst_vbeln,
         lir_posnr,
         lv_posnr,
         lst_posnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Vbeln'.  " Contract
            lst_vbeln-low = <ls_filter_opt>-low.
            IF lst_vbeln-low NE 'null'.
              lst_vbeln-sign    = lc_i.
              lst_vbeln-option  = lc_eq.
              APPEND lst_vbeln TO lir_vbeln.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_vbeln IS NOT INITIAL.
      SELECT vbeln,
             posnr,
             tbnam,
             fdnam
        FROM vbuv
        INTO TABLE @DATA(li_vbuv)
       WHERE vbeln IN @lir_vbeln.
    ENDIF.

    LOOP AT li_vbuv INTO DATA(lst_vbuv).
      CLEAR:lv_posnr,lv_label.
      lst_final-vbeln = lst_vbuv-vbeln.
      lv_posnr = lst_vbuv-posnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_posnr
        IMPORTING
          output = lv_posnr.

      lst_final-posnr_c = lv_posnr.
      CALL FUNCTION 'DDIF_FIELDLABEL_GET'
        EXPORTING
          tabname        = lst_vbuv-tbnam
          fieldname      = lst_vbuv-fdnam
          langu          = sy-langu
        IMPORTING
          label          = lv_label
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.

      lst_final-description = lv_label .
      APPEND lst_final TO et_entityset.
      CLEAR lst_final.
    ENDLOOP.

  ENDMETHOD.


  METHOD paymethodset_get_entityset.
    DATA:lir_land1  TYPE RANGE OF land1,
         lst_land1  TYPE shp_land1_range,
         lst_entity TYPE zcl_zqtc_future_ren_01_mpc=>ts_paymethod.

    CONSTANTS: lc_eq TYPE char2 VALUE 'EQ',
               lc_i  TYPE char1 VALUE 'I'.

    FREE:lir_land1,lst_land1.
*      LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
*      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
*        CASE <ls_filter>-property.
*          WHEN 'Land1'.
*            lst_land1-low = <ls_filter_opt>-low.
*            IF lst_land1-low NE 'nul'.
*              IF  lst_land1-low IS NOT INITIAL.
*                lst_land1-option = lc_eq.
*                lst_land1-sign   = lc_i.
*                APPEND lst_land1 TO lir_land1.
*              ENDIF.
*            ENDIF.
*
*        ENDCASE.
*      ENDLOOP.
*    ENDLOOP.

    lst_land1-low = 'GB'."<ls_filter_opt>-low.
    lst_land1-option = lc_eq.
    lst_land1-sign   = lc_i.
    APPEND lst_land1 TO lir_land1.


    SELECT land1,
           zlsch,
           text1
      FROM t042z
      INTO TABLE @DATA(li_t042z)"et_entityset
      WHERE land1 IN @lir_land1.
    LOOP AT li_t042z INTO DATA(lst_t042z).
      lst_entity-land1 = lst_t042z-land1.
      lst_entity-zlsch = lst_t042z-zlsch.
      lst_entity-text2 = lst_t042z-text1.
      APPEND lst_entity TO et_entityset.
      CLEAR lst_entity.
    ENDLOOP.
    lst_entity-text2 = 'Blank'.
    APPEND lst_entity TO et_entityset.

  ENDMETHOD.


  METHOD pricegrpset_get_entityset.
    SELECT konda
               vtext
              FROM t188t
              INTO CORRESPONDING FIELDS OF TABLE et_entityset
              WHERE spras = sy-langu.
  ENDMETHOD.


  METHOD reasonsset_get_entityset.
    SELECT abgru bezei
              FROM tvagt
              INTO CORRESPONDING FIELDS OF TABLE et_entityset
              WHERE spras = sy-langu.
  ENDMETHOD.


  METHOD regionset_get_entityset.
    TYPES:BEGIN OF ty_bezei,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE bezei20,
            high   TYPE bezei20,
          END OF ty_bezei.
    DATA:lir_bezei TYPE STANDARD TABLE OF ty_bezei,
         lst_bezei TYPE ty_bezei,
         lir_bland TYPE RANGE OF regio,
         lir_land1 TYPE shp_land1_range_t,
         lst_land1 TYPE shp_land1_range,
         lv_landx  TYPE char20.

    CONSTANTS: lc_eq TYPE char2 VALUE 'EQ',
               lc_i  TYPE char1 VALUE 'I'.

    FREE:lir_bezei,lst_bezei,lir_land1,lst_land1,lv_landx.
    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Land1'.
            lst_land1-low = <ls_filter_opt>-low.
            IF lst_land1-low NE 'nul'.
              IF  lst_land1-low IS NOT INITIAL.
                lst_land1-option = lc_eq.
                lst_land1-sign   = lc_i.
                APPEND lst_land1 TO lir_land1.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    SELECT land1
           bland
           bezei
      FROM t005u
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE spras = sy-langu
        AND   land1 IN lir_land1.
  ENDMETHOD.


  METHOD rstatusset_get_entityset.
    DATA:li_data   TYPE STANDARD TABLE OF dd07v,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_rstatus.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = 'ZREN_STATUS'
        text           = abap_true
        langu          = sy-langu
      TABLES
        dd07v_tab      = li_data
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

    LOOP AT li_data INTO DATA(lst_data).
      lst_final-ren_status = lst_data-domvalue_l.
      lst_final-btcjob     = lst_data-ddtext.
      APPEND lst_final TO et_entityset.
    ENDLOOP.
  ENDMETHOD.


  METHOD soldtoset_get_entityset.
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zqtc_future_ren_01_mpc=>ts_soldto,
         ls_maxrow TYPE bapi_epm_max_rows.
    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_soldto,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS: lc_eq   TYPE char2 VALUE 'EQ',
               lc_cp   TYPE char2 VALUE 'CP',
               lc_i    TYPE char1 VALUE 'I',
               lc_0001 TYPE bu_group VALUE '0001'.

    FREE:lst_kunnr,
          lst_name,
          lir_name,
         lst_final,
         lir_kunnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Name1'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_cp.
                lst_name-option = lc_cp.
                lst_kunnr-sign = lc_i.
                lst_name-sign = lc_i.
                CONCATENATE <ls_filter_opt>-low '*' INTO DATA(lv_name).
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                CLEAR lv_name.
                CONCATENATE '*' <ls_filter_opt>-low '*' INTO lv_name.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                DATA(lv_length) = strlen( lv_name ).
                IF lv_length GT 3.
                  lv_length = lv_length - 3.
                  DATA(lv_letter) = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter lv_name+2(lv_length) '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ELSEIF lv_length EQ 3.
                  lv_length = lv_length - 3.
                  lv_letter = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ENDIF.

                TRANSLATE lv_name TO UPPER CASE.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_kunnr IS NOT INITIAL.

      DATA : li_return   TYPE STANDARD TABLE OF bapiret2,
             li_result   TYPE STANDARD TABLE OF bus020_search_result,
             lv_email    TYPE ad_smtpadr,
             lst_address TYPE bupa_addr_search,
             lv_name1    TYPE bu_mcname1,
             lv_name2    TYPE bu_mcname2.
*--*First search Email + First name + Last name +Street
      lv_name1 = lv_name.
      lv_name2 = lv_name.
      CALL FUNCTION 'BUPA_SEARCH_2'
        EXPORTING
          iv_email         = lv_email
          is_address       = lst_address
          iv_mc_name1      = lv_name1
          iv_mc_name2      = lv_name2
          iv_req_mask      = abap_true
        TABLES
          et_search_result = li_result
          et_return        = li_return.

      IF li_result IS NOT  INITIAL.
        SELECT kna1~kunnr,
              kna1~name1,
              kna1~name2
         INTO TABLE @DATA(li_soldto)  UP TO 100 ROWS
         FROM kna1
         INNER JOIN but000 ON but000~partner = kna1~kunnr
         FOR ALL ENTRIES IN @li_result
         WHERE ( kna1~kunnr = @li_result-partner
           OR kna1~name1 IN @lir_name
           OR kna1~name2  IN @lir_name )
           AND but000~bu_group = @lc_0001
           AND but000~xblck = @abap_false.
      ELSE.
        SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE ( kna1~kunnr IN @lir_kunnr
            OR kna1~name1 IN @lir_name
            OR kna1~name2  IN @lir_name )
            AND but000~bu_group = @lc_0001
            AND but000~xblck = @abap_false.
      ENDIF.
    ELSE.
      SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE but000~bu_group = @lc_0001
            AND but000~xblck = @abap_false.
    ENDIF.
    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.

    IF lv_total > 0.
      LOOP AT li_soldto INTO DATA(lst_soldto) FROM lv_skip TO lv_total.

        ls_entity = CORRESPONDING #( lst_soldto ).
        APPEND ls_entity TO et_entityset.

      ENDLOOP.
    ELSE.
      MOVE-CORRESPONDING li_soldto TO et_entityset.
    ENDIF.
  ENDMETHOD.


  method TIMESET_GET_ENTITYSET.
 CONSTANTS: lc_devid TYPE zdevid VALUE 'E252',
               lc_time  TYPE rvari_vnam VALUE 'TIME'.
    SELECT
         low
         FROM zcaconstant
         INTO TABLE et_entityset
         WHERE devid  = lc_devid
           AND param1 = lc_time.
  endmethod.


  METHOD zshiptoset_get_entityset.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  OTCM-OTCM-47292/ERPM-25282
* DEVELOPER:Prabhu(PTUFARAM)
* DATE:  6/18/2021
* DESCRIPTION: Additional fields
*----------------------------------------------------------------------*
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_final TYPE zcl_zqtc_future_ren_01_mpc=>ts_zshipto,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.
    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshipto,
         ls_maxrow TYPE bapi_epm_max_rows.

    CONSTANTS: lc_cp   TYPE char2 VALUE 'CP',
               lc_i    TYPE char1 VALUE 'I',
               lc_0001 TYPE bu_group VALUE '0001'.

    FREE:lst_kunnr,
         lst_final,
         lir_kunnr.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Name1'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              IF  lst_kunnr-low IS NOT INITIAL.
                lst_kunnr-option = lc_cp.
                lst_name-option  = lc_cp.
                lst_kunnr-sign   = lc_i.
                lst_name-sign    = lc_i.
                CONCATENATE <ls_filter_opt>-low '*' INTO DATA(lv_name).
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                CLEAR lv_name.
                CONCATENATE '*' <ls_filter_opt>-low '*' INTO lv_name.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
                DATA(lv_length) = strlen( lv_name ).
                IF lv_length GT 3.
                  lv_length = lv_length - 3.
                  DATA(lv_letter) = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter lv_name+2(lv_length) '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ELSEIF lv_length EQ 3.
                  lv_length = lv_length - 3.
                  lv_letter = lv_name+1(1).
                  TRANSLATE lv_letter TO UPPER CASE.
                  CONCATENATE '*' lv_letter '*'
                  INTO lv_name.
                  lst_kunnr-low = lv_name.
                  lst_name-low = lv_name.
                  APPEND lst_kunnr TO lir_kunnr.
                  APPEND lst_name TO lir_name.
                ENDIF.

                TRANSLATE lv_name TO UPPER CASE.
                lst_kunnr-low = lv_name.
                lst_name-low = lv_name.
                APPEND lst_kunnr TO lir_kunnr.
                APPEND lst_name TO lir_name.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    IF lir_kunnr IS NOT INITIAL.

      DATA : li_return   TYPE STANDARD TABLE OF bapiret2,
             li_result   TYPE STANDARD TABLE OF bus020_search_result,
             lv_email    TYPE ad_smtpadr,
             lst_address TYPE bupa_addr_search,
             lv_name1    TYPE bu_mcname1,
             lv_name2    TYPE bu_mcname2.
*--*First search Email + First name + Last name +Street

      lv_name1 = lv_name.
      lv_name2 = lv_name.
      CALL FUNCTION 'BUPA_SEARCH_2'
        EXPORTING
          iv_email         = lv_email
          is_address       = lst_address
          iv_mc_name1      = lv_name1
          iv_mc_name2      = lv_name2
          iv_req_mask      = abap_true
        TABLES
          et_search_result = li_result
          et_return        = li_return.

      IF li_result IS NOT  INITIAL.

        SELECT kna1~kunnr,
              kna1~name1,
              kna1~name2
         INTO TABLE @DATA(li_shipto)  UP TO 100 ROWS
         FROM kna1
         INNER JOIN but000 ON but000~partner = kna1~kunnr
         FOR ALL ENTRIES IN @li_result
         WHERE ( kna1~kunnr = @li_result-partner
           OR kna1~name1 IN @lir_name
           OR kna1~name2  IN @lir_name )
           AND but000~bu_group = @lc_0001
           AND but000~xblck = @abap_false.
      ELSE.
        SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_shipto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE ( kna1~kunnr IN @lir_kunnr
            OR kna1~name1 IN @lir_name
            OR kna1~name2  IN @lir_name )
            AND but000~bu_group = @lc_0001
            AND but000~xblck = @abap_false.
      ENDIF.
    ELSE.
      SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_shipto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE but000~bu_group = @lc_0001
            AND but000~xblck = @abap_false.

    ENDIF.

    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.



    IF lv_total > 0.

      LOOP AT li_shipto INTO DATA(lst_shipto) FROM lv_skip TO lv_total.
        lst_final-shipto = lst_shipto-kunnr.
        lst_final-name1 = lst_shipto-name1.
        lst_final-name2 = lst_shipto-name2.
        APPEND lst_final TO et_entityset.
      ENDLOOP.

    ELSE.

      LOOP AT li_shipto INTO lst_shipto.
        lst_final-shipto = lst_shipto-kunnr.
        lst_final-name1 = lst_shipto-name1.
        lst_final-name2 = lst_shipto-name2.
        APPEND lst_final TO et_entityset.
        CLEAR :lst_shipto,lst_final.
      ENDLOOP.

    ENDIF.


    SORT et_entityset BY shipto.
  ENDMETHOD.
ENDCLASS.
