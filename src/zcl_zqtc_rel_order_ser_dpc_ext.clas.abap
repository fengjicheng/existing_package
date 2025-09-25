class ZCL_ZQTC_REL_ORDER_SER_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_REL_ORDER_SER_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods CLAIMREPORTSET_GET_ENTITYSET
    redefinition .
  methods HT005LANDSET_GET_ENTITYSET
    redefinition .
  methods ISMCODESET_GET_ENTITYSET
    redefinition .
  methods ODR_REASONSET_GET_ENTITYSET
    redefinition .
  methods REASONSSET_GET_ENTITYSET
    redefinition .
  methods SOLDTOSET_GET_ENTITYSET
    redefinition .
  methods TIMESET_GET_ENTITY
    redefinition .
  methods TIMESET_GET_ENTITYSET
    redefinition .
  methods ZCLM_DETAILSSET_GET_ENTITYSET
    redefinition .
  methods ZREL_ORDERSET_GET_ENTITYSET
    redefinition .
  methods ZSHIPTONAMSET_GET_ENTITYSET
    redefinition .
  methods ZSHIPTOSET_GET_ENTITYSET
    redefinition .
  methods ZSOLDTONAMSET_GET_ENTITYSET
    redefinition .
  methods ZSROSET_GET_ENTITYSET
    redefinition .
  methods CLAIMAUTHSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_REL_ORDER_SER_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923488
* REFERENCE NO:  OTCM-42840
* DEVELOPER: Prabhu
* DATE: 5/19/2021
* DESCRIPTION: Add Stock Availability
*----------------------------------------------------------------------*
    TYPES:BEGIN OF ty_tmp,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE vbeln,
            high   TYPE vbeln,
          END OF ty_tmp.
    DATA: lst_head          TYPE bapisdhd1,
          lst_headx         TYPE bapisdhd1x,
          lt_item           TYPE TABLE OF bapisditm,
          lst_item          TYPE bapisditm,
          lt_itemx          TYPE TABLE OF bapisditmx,
          lst_itemx         TYPE bapisditmx,
          lt_partners       TYPE TABLE OF bapiparnr,
          lst_partner       TYPE bapiparnr,
          lt_return         TYPE TABLE OF bapiret2,
          lst_return        TYPE bapiret2,
          lv_salesdoc       TYPE vbeln_va,
          lv_item           TYPE bapisditm-itm_number,
          lv_entity_set     TYPE /iwbep/mgw_tech_name,
          lt_selected       TYPE STANDARD TABLE OF ty_tmp,
          lst_schedules_in  TYPE bapischdl,
          lst_schedules_inx TYPE bapischdlx,
          li_schedules_in   TYPE STANDARD TABLE OF bapischdl,
          li_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
          lst_selected      TYPE ty_tmp,
          lv_jobname        TYPE btcjob,
          lv_number         TYPE tbtcjob-jobcount,    "Job number
          lv_user           TYPE sy-uname,            " User Name
          lv_pre_chk        TYPE btcckstat,
          lst_vbeln         TYPE fip_s_vbeln_range,
          lst_posnr         TYPE ckmcso_posnr,
          lst_augru         TYPE rjksd_augru_range,
          lr_vbeln          TYPE STANDARD TABLE OF fip_s_vbeln_range,
          lr_posnr          TYPE STANDARD TABLE OF ckmcso_posnr,
          lr_augru          TYPE STANDARD TABLE OF rjksd_augru_range.

    DATA : BEGIN OF  li_orders.
    DATA:vbeln   TYPE vbeln,
         message TYPE bapi_msg.
    DATA: np_vbeln TYPE zcl_zqtc_rel_order_ser_mpc=>tt_claimord,
          END OF li_orders.

    DATA:lst_order_ret LIKE li_orders,
         lst_orders    LIKE li_orders,
         lst_input1    TYPE zsd_rel_orders,
         lt_input      TYPE STANDARD TABLE OF zsd_rel_orders,
         li_wmdvsx     TYPE STANDARD TABLE OF  bapiwmdvs,
         li_wmdvex     TYPE STANDARD TABLE OF  bapiwmdve,
         lv_av_qty_plt TYPE bapicm61v-wkbst,
         lv_return     TYPE  bapireturn.
    DATA:
      lv_actv_flag_e252 TYPE zactive_flag. "Active / Inactive Flag
    CONSTANTS:lc_va03  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA03%20VBAK-VBELN='.
    CONSTANTS:
      lc_wricef_id_e252 TYPE zdevid VALUE 'E252',         "Development ID
      lc_ser_num_e252   TYPE zsno   VALUE '001'.           "Serial Number
    CONSTANTS: lc_devid   TYPE zdevid VALUE 'E252',
               lc_records TYPE rvari_vnam VALUE 'NO_OF_RECORDS',
               lc_eq      TYPE char2 VALUE 'EQ',
               lc_i       TYPE char1 VALUE 'I',
               lc_w       TYPE char1 VALUE 'W',
               lc_e       TYPE char1 VALUE 'E',
               lc_s       TYPE char1 VALUE 'S',
               lc_c       TYPE char1 VALUE 'C',
               lc_ag      TYPE parvw VALUE 'AG',
               lc_we      TYPE parvw VALUE 'WE',
               lc_zclm    TYPE auart VALUE 'ZCLM'.

    cl_http_server=>if_http_server~get_location(
          IMPORTING host = DATA(lv_host)
                 port = DATA(lv_port) ).
*----Fecth the constant entries
    SELECT SINGLE *
      FROM zcaconstant
      INTO @DATA(lst_const)
      WHERE devid = @lc_devid
        AND activate = @abap_true
        AND param1   = @lc_records.

    " Get the EntitySet name
    lv_entity_set = io_tech_request_context->get_entity_set_name( ).
*---get the OData detail from frontend to back end
    io_data_provider->read_entry_data( IMPORTING es_data  = lst_orders ).

    CLEAR : lst_augru, lst_vbeln,lst_posnr.
    FREE:lr_augru, lr_vbeln,lr_posnr,lst_selected,lt_selected.
*---Prepare the select-options,Range tables and varaiables
    CASE lv_entity_set.
      WHEN 'CLAIMHEADSet'.
        LOOP AT  lst_orders-np_vbeln  INTO DATA(lst_input).
          MOVE-CORRESPONDING lst_input TO lst_input1.
          lst_input1-posnr = lst_input-posnr.
          APPEND lst_input1   TO  lt_input.
          lst_vbeln-sign   =  lc_i.
          lst_vbeln-option = lc_eq .
          lst_vbeln-low    = lst_input-vbeln.
          APPEND lst_vbeln TO lr_vbeln. "Orders select-options

          lst_selected-sign   =  lc_i.
          lst_selected-option = lc_eq .
          lst_selected-low    = lst_input-vbeln.
          lst_selected-high   = lst_input-posnr.
          APPEND lst_selected TO lt_selected."combination with order and Line item

          lst_posnr-sign   =  lc_i.
          lst_posnr-option = lc_eq .
          lst_posnr-low    = lst_input-posnr.
          APPEND lst_posnr TO lr_posnr. "Line item select-options
          lst_augru-sign   =  lc_i.
          lst_augru-option = lc_eq .
          lst_augru-low    =  lst_input1-augru.
          APPEND lst_augru TO lr_augru. "Order reason
          CLEAR : lst_augru, lst_vbeln,lst_posnr,lst_selected.
        ENDLOOP.
*---Delete the duplicate Orders
        SORT lr_vbeln BY low.
        DELETE ADJACENT DUPLICATES FROM lr_vbeln COMPARING low.
*---Check the no.of entries
        IF lt_input IS NOT INITIAL.
          DESCRIBE TABLE lt_input LINES DATA(lv_lines).
          IF lv_lines > lst_const-low.
            CONCATENATE 'CLAIM' '_' sy-datum '_' sy-uzeit '_' sy-uname  INTO lv_jobname.
*---Job open
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

              FREE:lst_vbeln,
                   lst_posnr,
                   lst_augru.
*---Submitted the select values (rangevalues).
              SUBMIT zqtc_rel_order_create  WITH lr_sel IN lt_selected
                                            WITH s_vbeln IN lr_vbeln
                                            WITH s_posnr IN lr_posnr
                                            WITH s_augru IN lr_augru
                                            USER  'QTC_BATCH01'
                                            VIA JOB lv_jobname NUMBER lv_number
                                            AND RETURN.
*---Job closed
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
              IF sy-subrc = 0.

              ENDIF. " IF sy-subrc = 0
*----Batch job message prepartion
              CONCATENATE 'Background Job'(003)
                          lv_jobname
                          'has been scheduled'(004)
               INTO  lst_order_ret-message SEPARATED BY space.
*---Pass the response data to frontend
              copy_data_to_ref(
              EXPORTING
                is_data = lst_order_ret
              CHANGING
                cr_data = er_deep_entity ).

            ENDIF.

          ELSE.
*----Front end process
            FREE:lt_partners[],li_schedules_in,li_schedules_inx,
                 lt_item[],lt_itemx[],lv_item.

*---to fill the joural codes and descrition for ATP quantity check
* To check enhancement is active or not
            CALL FUNCTION 'ZCA_ENH_CONTROL'
              EXPORTING
                im_wricef_id   = lc_wricef_id_e252
                im_ser_num     = lc_ser_num_e252
              IMPORTING
                ex_active_flag = lv_actv_flag_e252.
*---fecth data from master table for basic information
            SELECT vk~vbeln,
                   vk~vkorg,
                   vk~vtweg,
                   vk~spart,
                   vk~vkbur,
                   vk~augru,
                   vb~posnr,
                   vb~matnr,
                   vb~kwmeng,
                   vb~zmeng,
                   vb~meins,
                   vb~vgbel,
                   vb~vgpos,
                   vk~kunnr
               FROM vbak AS vk
              INNER JOIN vbap AS vb
              ON vb~vbeln = vk~vbeln
              INTO TABLE @DATA(li_data)
              FOR ALL ENTRIES IN @lt_input
              WHERE vb~vbeln = @lt_input-vbeln
                AND vb~posnr = @lt_input-posnr.
            IF sy-subrc EQ 0.
              SORT li_data BY vbeln.
            ENDIF.
            SELECT vbeln,
                   posnr,
                   parvw,
                   kunnr
              FROM vbpa
              INTO TABLE @DATA(li_vbpa)
              FOR ALL ENTRIES IN @lt_input
            WHERE vbeln = @lt_input-vbeln
              AND ( posnr = @lt_input-posnr OR posnr = '000000' )
              AND parvw = @lc_we.
*----Material and plant combination data from MVKE table
*----Enhancement control flag check
            IF lv_actv_flag_e252 IS NOT INITIAL.
              IF li_data IS NOT INITIAL.
                SELECT matnr,
                       vkorg,
                       vtweg,
                       dwerk
                  FROM mvke
                  INTO TABLE @DATA(li_mvke)
                  FOR ALL ENTRIES IN @li_data
                  WHERE matnr = @li_data-matnr
                    AND vkorg = @li_data-vkorg
                    AND vtweg = @li_data-vtweg.
                IF li_mvke IS NOT INITIAL.
                  SORT li_mvke BY matnr vkorg vtweg.
                ENDIF.
              ENDIF.
            ENDIF.
*---Processing logic to create the calims orders
            LOOP AT lr_vbeln INTO lst_vbeln.
              FREE:lst_head,lst_headx,lt_item,lt_itemx,li_schedules_in,li_schedules_inx,
                   lt_partners,lt_return,lv_item,lv_av_qty_plt,lv_return.
              READ TABLE li_data INTO DATA(lst_data) WITH KEY vbeln = lst_vbeln-low.
              IF sy-subrc = 0.
                DATA(lv_tabix) = sy-tabix.
                LOOP AT li_data INTO lst_data FROM lv_tabix.
                  IF lst_data-vbeln <> lst_vbeln-low.
                    EXIT.
                  ELSE.
*----selected records from front end systemm
                    READ TABLE lt_selected INTO lst_selected WITH KEY low  = lst_vbeln-low
                                                                      high = lst_data-posnr.
                    IF sy-subrc = 0.
*---Enahancement control check for Material availablity check
                      IF lv_actv_flag_e252 IS NOT INITIAL.
                        READ TABLE li_mvke INTO DATA(lst_mvke) WITH KEY matnr = lst_data-matnr
                                                                        vkorg = lst_data-vkorg
                                                                        vtweg = lst_data-vtweg
                                                                        BINARY SEARCH.
                        IF sy-subrc = 0.
                          CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
                            EXPORTING
                              plant      = lst_mvke-dwerk
                              material   = lst_mvke-matnr
                              unit       = lst_data-meins
                            IMPORTING
                              av_qty_plt = lv_av_qty_plt
                              return     = lv_return
                            TABLES
                              wmdvsx     = li_wmdvsx
                              wmdvex     = li_wmdvex.
                        ENDIF.
                      ENDIF.
                      IF lst_data-kwmeng IS NOT INITIAL.
                        DATA(lv_qty_t) = lst_data-kwmeng.
                      ELSEIF lst_data-zmeng IS NOT INITIAL.
                        lv_qty_t = lst_data-zmeng.
                      ENDIF.
*----If material Available Qty check (enhancement control)
*-----deactivated then processing below code
                      IF lv_actv_flag_e252 EQ abap_false.
                        lv_av_qty_plt = lv_qty_t.
                      ENDIF.
*-----Check the available qty check then process teh Calim Order creation
                      IF lv_av_qty_plt GE lv_qty_t.
* Populate Header Info
                        CLEAR:lst_head.
                        lst_head-doc_type   = lc_zclm.
                        lst_head-sales_org  = lst_data-vkorg.
                        lst_head-division   = lst_data-spart.
                        lst_head-distr_chan = lst_data-vtweg.
                        lst_head-sales_off  = lst_data-vkbur.
                        lst_head-ref_doc    = lst_data-vbeln.
                        lst_head-ord_reason = lst_input1-augru.
                        lst_head-refdoc_cat = lc_c.

* Populate Header update structure
                        CLEAR:lst_headx.
                        lst_headx-updateflag = lc_i.
                        lst_headx-doc_type   = abap_true.
                        lst_headx-sales_org  = abap_true.
                        lst_headx-division   = abap_true.
                        lst_headx-distr_chan = abap_true.
                        lst_headx-sales_off  = abap_true.
                        lst_headx-ref_doc    = abap_true.
                        lst_headx-refdoc_cat = abap_true.
                        lst_headx-ord_reason = abap_true.


                        lv_item = lv_item + 10.
* Populate Item info
                        CLEAR:lst_item.
                        lst_item-itm_number = lv_item.
                        lst_item-material   = lst_data-matnr.
                        lst_item-target_qty = lst_data-kwmeng.
                        IF lst_item-target_qty IS INITIAL.
                          lst_item-target_qty = lst_data-zmeng.
                        ENDIF.
                        lst_item-ref_doc    = lst_data-vbeln.
                        lst_item-ref_doc_it = lst_data-posnr.
                        APPEND lst_item TO lt_item.

                        CLEAR:lst_itemx.
                        lst_itemx-itm_number  = lst_item-itm_number.
                        lst_itemx-material    = abap_true.
                        lst_itemx-target_qty  = abap_true.
                        lst_itemx-ref_doc     = abap_true.
                        lst_itemx-ref_doc_it  = abap_true.
                        APPEND lst_itemx TO lt_itemx.
                        CLEAR:lst_schedules_in,lst_schedules_inx.
                        lst_schedules_in-itm_number  = lst_item-itm_number.
                        lst_schedules_inx-itm_number = abap_true.
                        lst_schedules_in-req_qty     = lst_data-kwmeng.
                        IF lst_schedules_in-req_qty IS INITIAL.
                          lst_schedules_in-req_qty     = lst_data-zmeng.
                        ENDIF.
                        lst_schedules_inx-req_qty    = abap_true.
                        APPEND lst_schedules_in TO li_schedules_in.
                        APPEND lst_schedules_inx TO li_schedules_inx.
* Populate Partners
                        CLEAR:lst_partner.
                        lst_partner-partn_numb = lst_data-kunnr.
                        lst_partner-partn_role = lc_ag .
                        APPEND lst_partner TO lt_partners.
                        READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_data-vbeln
                                                                        posnr = lst_data-posnr.

                        IF sy-subrc NE 0.
                          READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_data-vbeln
                                                                      posnr = '000000'.
                        ENDIF.
                        IF sy-subrc EQ 0.
                          CLEAR:lst_partner.
                          lst_partner-partn_numb = lst_vbpa-kunnr.
                          " lst_partner-itm_number = lv_item.
                          lst_partner-partn_role = lc_we.
                          APPEND lst_partner TO lt_partners.
                        ENDIF.
*                          READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_data-vbeln
*                                                                       posnr = '000000'.
*                          IF sy-subrc EQ 0.
*                            CLEAR:lst_partner.
*                            lst_partner-partn_numb = lst_vbpa-kunnr.
*                            lst_partner-partn_role = lc_we.
*                            APPEND lst_partner TO lt_partners.
*                          ENDIF.
                        " ENDIF.
                      ELSE.
**----Material Qty is not available then passing error message
                        LOOP AT lst_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<fs_data3>)
                                                                    WHERE vbeln = lst_data-vbeln
                                                                      AND posnr = lst_data-posnr.
                          <fs_data3>-type = 'Error'(010).
                          <fs_data3>-msg1 = 'Available quantity is not available for material:'(011).
                          <fs_data3>-msg2 =  lst_data-matnr.
                          CLEAR:lst_order_ret-message.
                        ENDLOOP.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
                CLEAR:lv_salesdoc.
                FREE:lt_return[].
                IF lt_item IS NOT INITIAL.
* Create Claim Order (ZCLM)
                  CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
                    EXPORTING
                      order_header_in     = lst_head
                      order_header_inx    = lst_headx
                    IMPORTING
                      salesdocument       = lv_salesdoc
                    TABLES
                      return              = lt_return
                      order_items_in      = lt_item
                      order_items_inx     = lt_itemx
                      order_schedules_in  = li_schedules_in
                      order_schedules_inx = li_schedules_inx
                      order_partners      = lt_partners.
                  FREE:lst_head,lst_headx,lt_itemx,lt_partners.
                  FIELD-SYMBOLS:   <lt_data>  TYPE table.

                  IF lv_salesdoc IS NOT INITIAL.
                    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                      EXPORTING
                        wait = abap_true.
*----For single recorde message
                    CONCATENATE 'Claim Order'(008)
                                lv_salesdoc
                                'Created Successfully'(009)
                                INTO  lst_order_ret-message SEPARATED BY space.
                    lst_order_ret-vbeln   = lv_salesdoc.

*-----Multiple recordes message
                    LOOP AT lst_orders-np_vbeln  ASSIGNING FIELD-SYMBOL(<fs_data>)
                                                      WHERE vbeln = lst_selected-low.
*                                                        AND posnr = lst_selected-high.
                      CONCATENATE 'Claim Order'(008)
                                 lv_salesdoc
                                 'Created Successfully.'(009)
                                 INTO  lst_order_ret-message SEPARATED BY space.
                      lst_order_ret-vbeln   = lv_salesdoc.
                      <fs_data>-type = 'Success'(012).
                      <fs_data>-msg1 = lst_order_ret-message.
*                      <fs_data>-msg2 = lv_salesdoc.
                      <fs_data>-new_rel_order = lv_salesdoc.
                      READ TABLE lt_item INTO DATA(lst_item_new) WITH KEY
                                                            ref_doc = <fs_data>-vbeln
                                                            ref_doc_it = <fs_data>-posnr.
                      IF sy-subrc EQ 0.
                        SELECT SINGLE vbeln,posnr FROM vbuv INTO @DATA(lst_vbuv)
                                          WHERE vbeln = @lv_salesdoc
                                                 AND posnr = @lst_item_new-itm_number.
                        IF sy-subrc = 0.
                          <fs_data>-status = 'Incomplete'(005).
                        ELSE.
                          <fs_data>-status = 'Complete'(006).
                        ENDIF.
                        "for Qty Confirmation
                        SELECT SINGLE vbeln,posnr,etenr FROM vbep INTO @DATA(lst_vbep)
                               WHERE vbeln = @lv_salesdoc
                                  AND posnr = @lst_item_new-itm_number
                                  AND bmeng NE @space.
                        IF sy-subrc NE 0.
                          CONCATENATE 'Claim Item not confirmed for' lv_salesdoc '-' lst_item_new-itm_number
                                          INTO <fs_data>-msg3 SEPARATED BY space.
                        ELSE.
                          CONCATENATE 'Claim Item confirmed for' lv_salesdoc '-' lst_item_new-itm_number
                                         INTO <fs_data>-msg3 SEPARATED BY space.
                        ENDIF.
                      ENDIF.

                      IF <fs_data>-knkli IS ASSIGNED.
                        TRY.
                            ADD 1 TO <fs_data>-knkli.
                            CONDENSE <fs_data>-knkli.
                          CATCH cx_sy_arithmetic_error.
                        ENDTRY.
                      ENDIF.
                      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                        EXPORTING
                          input  = sy-datum
                        IMPORTING
                          output = <fs_data>-bedat.

                      CONCATENATE 'http://' lv_host ':'
                      lv_port lc_va03
                      lv_salesdoc
                      INTO <fs_data>-link.
                    ENDLOOP.
*Multiple Orders with same order number with different line item then filling below code
*                    LOOP AT lst_orders-np_vbeln  ASSIGNING <fs_data> WHERE vbeln = lst_vbeln-low
*                                                                      AND  type IS INITIAL.
*                      <fs_data>-type = 'Success'(012).
*                      <fs_data>-msg1 = lst_order_ret-message.
*                      <fs_data>-msg2 = lv_salesdoc.
*                      <fs_data>-new_rel_order = lv_salesdoc.
*                      READ TABLE lt_item INTO DATA(lst_item_new2) WITH KEY
*                                                                   ref_doc = <fs_data>-vbeln
*                                                                   ref_doc_it = <fs_data>-posnr.
*                      IF sy-subrc EQ 0.
*                        SELECT SINGLE vbeln,posnr FROM vbuv INTO @DATA(lst_vbuv2)
*                                          WHERE vbeln = @lv_salesdoc
*                                                 AND posnr = @lst_item_new2-itm_number.
*                        IF sy-subrc = 0.
*                          <fs_data>-status = 'Incomplete'(005).
*                        ELSE.
*                          <fs_data>-status = 'Complete'(006).
*                        ENDIF.
*                      ENDIF.
*                      IF <fs_data>-msg3 IS ASSIGNED AND <fs_data>-msg3 = abap_true.
*
*                        CONCATENATE 'Claim Item not confirmed for' lv_salesdoc '-' lst_item_new2-itm_number
*                                     INTO <fs_data>-msg3 SEPARATED BY space.
*                      ENDIF.
*                      IF <fs_data>-knkli IS ASSIGNED.
*                        TRY.
*                            ADD 1 TO <fs_data>-knkli.
*                            CONDENSE <fs_data>-knkli.
*                          CATCH cx_sy_arithmetic_error.
*                        ENDTRY.
*                      ENDIF.
*                    ENDLOOP.

                  ELSE.
*----if the order creation failed then filling return message
                    IF lt_return IS NOT INITIAL.
                      SORT lt_return BY type.
                      DELETE lt_return WHERE type EQ lc_s.
                      LOOP AT lst_orders-np_vbeln  ASSIGNING <fs_data>
                                                    WHERE vbeln = lst_selected-low.
                        "AND posnr = lst_data-posnr.
                        READ TABLE lt_return INTO lst_return INDEX 1.
                        IF sy-subrc = 0.
                          <fs_data>-msg1 = lst_return-message.
                        ENDIF.
                        READ TABLE lt_return INTO lst_return INDEX 2.
                        IF sy-subrc = 0.
                          <fs_data>-msg2 = lst_return-message.
                        ENDIF.
                        READ TABLE lt_return INTO lst_return INDEX 3.
                        IF sy-subrc = 0.
                          <fs_data>-msg3 = lst_return-message.
                        ELSEIF <fs_data>-msg3 IS ASSIGNED.
                          CLEAR : <fs_data>-msg3.
                        ENDIF.
                        IF lst_return-type = lc_e.
                          <fs_data>-type = 'Error'(010).
                        ELSEIF lst_return-type = lc_w.
                          <fs_data>-type = 'Warning'(013).
                        ELSEIF lst_return-type = lc_i.
                          <fs_data>-type = 'Information'(014).
                        ENDIF.
                      ENDLOOP.
                      CLEAR:lst_order_ret-message.
                    ENDIF.
                  ENDIF.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
                  FREE  : lt_item.
                  DESCRIBE TABLE lr_vbeln LINES DATA(lv_cnt).
                  IF lv_cnt GT 1.
                    CLEAR : lst_order_ret-message.
                  ENDIF.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
                ENDIF.
*----After complete all process then pass the all message to front end system using below method
                lst_order_ret-np_vbeln = lst_orders-np_vbeln.
                copy_data_to_ref(
                    EXPORTING
                      is_data = lst_order_ret
                    CHANGING
                      cr_data = er_deep_entity ).
                FREE:lt_return.
              ENDIF.
              FREE:lst_head,lst_headx,lt_item,lt_itemx,li_schedules_in,li_schedules_inx,
                   lt_partners,lt_return,lv_item.
              CLEAR:lst_data.
            ENDLOOP.
          ENDIF.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD claimauthset_get_entityset.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923262
* REFERENCE NO:  OTCM-42752
* DEVELOPER: Prabhu
* DATE: 6/22/2021
* DESCRIPTION: RCM - Claims report
*----------------------------------------------------------------------*
    DATA : lv_auth_object1 TYPE ust12-objct VALUE 'ZCLAIM_CRT',
           lv_field1       TYPE ust12-field VALUE 'ZCLAIM_CRT',
           lv_auth_object2 TYPE ust12-objct VALUE 'ZCLAIM_RPT',
           lv_field2       TYPE ust12-field VALUE 'ZCLAIM_RPT',
           lst_claimauth   TYPE zcl_zqtc_rel_order_ser_mpc=>ts_claimauth.
    CLEAR : lst_claimauth.
*    CALL FUNCTION 'AUTHORITY_CHECK'
*      EXPORTING
*        user                = sy-uname
*        object              = lv_auth_object1
*        field1              = lv_field1
*      EXCEPTIONS
*        user_dont_exist     = 1
*        user_is_authorized  = 2
*        user_not_authorized = 3
*        user_is_locked      = 4
*        OTHERS              = 5.
*    IF sy-subrc = 2.
    "Authority check for Create claims
    AUTHORITY-CHECK OBJECT 'ZCLAIM_CRT' FOR USER sy-uname ID 'ZCLAIM_CRT' FIELD lv_field1.
    IF sy-subrc EQ 0.
      lst_claimauth-claim_all = abap_true.
    ELSE.
      ""Authority check for claims report
      AUTHORITY-CHECK OBJECT 'ZCLAIM_RPT' FOR USER sy-uname ID 'ZCLAIM_RPT' FIELD  lv_field2 .
      IF sy-subrc EQ 0.
        lst_claimauth-claim_report = abap_true.
      ENDIF.
    ENDIF.
    APPEND lst_claimauth TO et_entityset.
    CLEAR lst_claimauth.
  ENDMETHOD.


  METHOD claimreportset_get_entityset.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923262
* REFERENCE NO:  OTCM-42752
* DEVELOPER: Prabhu
* DATE: 5/19/2021
* DESCRIPTION: RCM - Claims report
*----------------------------------------------------------------------*
    DATA:lst_final                TYPE zstqtc_claims_rpt_flds,
         lst_entityset            LIKE LINE OF et_entityset,
         lst_order                TYPE fip_s_vbeln_range,
         lir_order                TYPE STANDARD TABLE OF fip_s_vbeln_range,
         lst_auart                TYPE fip_s_auart_range,
         lir_auart                TYPE STANDARD TABLE OF fip_s_auart_range,
         lst_posnr                TYPE rdb_posnr_sel,
         lir_posnr                TYPE STANDARD TABLE OF rdb_posnr_sel,
         lir_kunnr                TYPE STANDARD TABLE OF shp_kunnr_range,
         lir_kunwe                TYPE STANDARD TABLE OF shp_kunnr_range,
         lir_country              TYPE STANDARD TABLE OF shp_land1_range,
         lir_user                 TYPE STANDARD TABLE OF range_ernam,
         lir_parvw                TYPE STANDARD TABLE OF rjksd_parvw_range,
         lir_matnr                TYPE STANDARD TABLE OF ism_matnr_range,
         lir_erdat                TYPE STANDARD TABLE OF tds_rg_erdat,
         lir_wadat                TYPE STANDARD TABLE OF tds_rg_erdat,
         lst_matnr                TYPE ism_matnr_range,
         lv_sprint                TYPE string,
         lt_filter_string         TYPE TABLE OF string,
         lt_sptint                TYPE TABLE OF string,
         lv_qty                   TYPE char18,
         lv_dec                   TYPE char10,
         lv_zmeng                 TYPE char18,
         lv_host                  TYPE string,
         lv_port                  TYPE string,
         lv_date                  TYPE char10,
         lv_start                 TYPE char10,
         lv_end                   TYPE char10,
         lst_kunnr                TYPE shp_kunnr_range,
         lst_kunwe                TYPE shp_kunnr_range,
         lst_country              TYPE shp_land1_range,
         lst_user                 TYPE range_ernam,
         lst_parvw                TYPE rjksd_parvw_range,
         lv_input                 TYPE string,
         lv_name                  TYPE string,
         lv_value                 TYPE string,
         lv_sign                  TYPE string,
         lv_index                 TYPE sy-tabix,
         lst_erdat                TYPE tds_rg_erdat,
         lst_wadat                TYPE tds_rg_erdat,
         lt_key_value             TYPE /iwbep/t_mgw_name_value_pair,
         ls_filter_select_options TYPE /iwbep/s_mgw_select_option,
         lt_select_options        TYPE /iwbep/t_cod_select_options,
         ls_select_options        TYPE /iwbep/s_cod_select_option.

    CONSTANTS:lc_va03  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA03%20VBAK-VBELN='.
    CONSTANTS: lc_eq     TYPE char2 VALUE 'EQ',
               lc_i      TYPE char1 VALUE 'I',
               lc_zclm   TYPE auart VALUE 'ZCLM',
               lc_we     TYPE parvw VALUE 'WE',
               lc_ag     TYPE parvw  VALUE 'AG',
               lc_sp     TYPE parvw  VALUE 'SP',
               lc_loekz  TYPE loekz VALUE 'L',
               lc_bt     TYPE char2 VALUE 'BT',
               lc_ge     TYPE char2 VALUE 'ge',
               lc_le     TYPE char2 VALUE 'le',
               lc_header TYPE posnr VALUE '000000'.



    cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
             port = lv_port ).
    FREE:lst_final,
         lst_entityset,
         lst_order,
         lir_order,
         lst_auart,
         lir_auart,
         lst_posnr,
         lir_posnr,
         lir_kunnr,
         lir_kunwe,
         lir_country,
         lir_user,
         lir_parvw,
         lir_matnr,
         lir_erdat,
         lir_wadat,
         lst_matnr,
         lv_sprint,
         lt_filter_string,
         lt_sptint,
         lv_qty,
         lv_dec,
         lv_zmeng ,
         lv_host,
         lv_port,
         lv_date,
         lv_start,
         lv_end,
         lst_kunnr,
         lst_kunwe ,
         lst_country,
         lst_user ,
         lst_parvw,
         lv_input,
         lv_name ,
         lv_value,
         lv_sign,
         lst_erdat,
         lst_wadat,
         lt_key_value,
         ls_filter_select_options,
         lt_select_options ,
         lv_index,
         ls_select_options.
*--*Build input
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.
* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING FIELD-SYMBOL(<fs_key_value>).
        CONDENSE ls_filter_string.
        " Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_value NE 'null'.
          DATA(lv_length) = strlen( lv_value ).
          FREE:lv_length,lv_sprint,lt_sptint.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          CASE lv_name.
            WHEN 'Erdat'.
              CLEAR : lv_start.
              CONCATENATE lv_value+1(4)
                          lv_value+6(2)
                          lv_value+9(2)
                          INTO lv_start.
              IF lv_sign = lc_ge.
                lst_erdat-low = lv_start.
                lst_erdat-sign = lc_i.
                lst_erdat-option = lc_eq.
                APPEND lst_erdat TO lir_erdat.
                CLEAR lst_erdat.
              ELSEIF lv_sign = lc_le.
                READ TABLE lir_erdat ASSIGNING FIELD-SYMBOL(<fs_crtdate>) INDEX 1.
                IF sy-subrc EQ 0.
                  <fs_crtdate>-high = lv_start.
                  <fs_crtdate>-sign = lc_i.
                  <fs_crtdate>-option = lc_bt.
                ENDIF.
              ENDIF.

            WHEN 'WadatIst'.
              CLEAR : lv_start.
              CONCATENATE lv_value+1(4)
                           lv_value+6(2)
                           lv_value+9(2)
                           INTO lv_start.
              IF lv_sign = lc_ge.
                lst_wadat-low = lv_start.
                lst_wadat-sign = lc_i.
                lst_wadat-option = lc_eq.
                APPEND lst_wadat TO lir_wadat.
                CLEAR lst_wadat.
              ELSEIF lv_sign = lc_le.
                READ TABLE lir_wadat ASSIGNING FIELD-SYMBOL(<fs_deldate>) INDEX 1.
                IF sy-subrc EQ 0.
                  <fs_deldate>-high = lv_start.
                  <fs_deldate>-sign = lc_i.
                  <fs_deldate>-option = lc_bt.
                ENDIF.
              ENDIF.

            WHEN 'Kunnr'.
              LOOP AT lt_sptint INTO DATA(lst_sprint).
                lst_kunnr-sign = lc_i.
                lst_kunnr-option = lc_eq.
                lst_kunnr-low = lst_sprint.
                APPEND lst_kunnr TO lir_kunnr.
                CLEAR lst_kunnr.
              ENDLOOP.

            WHEN 'Kunwe'.
              LOOP AT lt_sptint INTO lst_sprint.
                lst_kunwe-sign = lc_i.
                lst_kunwe-option = lc_eq.
                lst_kunwe-low = lst_sprint.
                APPEND lst_kunwe TO lir_kunwe.
                CLEAR lst_kunwe.
              ENDLOOP.

            WHEN 'Land1'.
              LOOP AT lt_sptint INTO lst_sprint.
                lst_country-sign = lc_i.
                lst_country-option = lc_eq.
                lst_country-low = lst_sprint.
                APPEND lst_country TO lir_country.
                CLEAR lst_country.
              ENDLOOP.

            WHEN 'Ernam'.
              LOOP AT lt_sptint INTO lst_sprint.
                lst_user-sign = lc_i.
                lst_user-option = lc_eq.
                lst_user-low = lst_sprint.
                TRANSLATE lst_user-low TO UPPER CASE.
                APPEND lst_user TO lir_user.
                CLEAR lst_user.
              ENDLOOP.
          ENDCASE.
        ENDIF.
      ENDLOOP.
    ENDIF.
*--*Build Partner functions
    lst_parvw-low = lc_we.
    lst_parvw-option = lc_eq.
    lst_parvw-sign = lc_i.
    APPEND lst_parvw TO lir_parvw.
    CLEAR lst_parvw.
    lst_parvw-low = lc_ag.
    lst_parvw-option = lc_eq.
    lst_parvw-sign = lc_i.
    APPEND lst_parvw TO lir_parvw.
    CLEAR lst_parvw.
    lst_parvw-low = lc_sp.
    lst_parvw-option = lc_eq.
    lst_parvw-sign = lc_i.
    APPEND lst_parvw TO lir_parvw.
    CLEAR lst_parvw.
    " Orders based on Shipto
    IF lir_kunwe IS NOT INITIAL OR lir_country IS NOT INITIAL.
      SELECT vbpa~vbeln,
             vbpa~land1
          FROM vbpa
          INNER JOIN vbak ON vbak~vbeln = vbpa~vbeln
          INTO TABLE @DATA(li_vbpa)
          WHERE vbpa~kunnr IN @lir_kunwe
            AND vbak~auart = @lc_zclm
            AND vbpa~parvw = @lc_we
             AND vbpa~land1 IN @lir_country.

      IF li_vbpa IS NOT INITIAL.
        SORT li_vbpa BY vbeln .
        DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING vbeln.
        LOOP AT  li_vbpa INTO DATA(lst_vbpa).
          lst_order-low    = lst_vbpa-vbeln.
          lst_order-option = lc_eq.
          lst_order-sign   = lc_i.
          APPEND lst_order TO lir_order.
        ENDLOOP.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.
    IF lir_wadat IS NOT INITIAL.
      " Get Sales order data when input provided Claim Processed date
      SELECT vbak~vbeln,
             vbak~erdat,
             vbak~ernam,
             vbak~auart,
             vbak~augru,
             vbak~kunnr,
             vbak~kvgr1,
             vbap~posnr,
             vbap~matnr,
             vbap~arktx,
             vbap~abgru,
             vbap~kwmeng,
             vbap~zmeng,
             vbap~pstyv,
             vbap~vgbel,
             vbap~vgpos,
           "  likp~wadat,
             likp~wadat_ist,
             likp~vstel,
             likp~lfdat,
             lips~vbeln AS del,
             lips~posnr AS del_item
        INTO TABLE @DATA(li_vbak)
        FROM lips
        INNER JOIN likp ON lips~vbeln = likp~vbeln
        INNER JOIN vbap ON  lips~vgbel = vbap~vbeln
                         AND lips~posnr = vbap~posnr
        INNER JOIN vbak  ON vbap~vbeln = vbak~vbeln
        WHERE vbak~vbeln IN @lir_order
          AND vbak~auart = @lc_zclm
          AND vbak~erdat IN @lir_erdat
          AND vbak~ernam IN @lir_user
           AND vbak~kunnr IN @lir_kunnr
           AND likp~wadat_ist IN @lir_wadat .
      "Claim Processed date data  at PO level
      SELECT vbak~vbeln,
          vbak~erdat,
          vbak~ernam,
          vbak~auart,
          vbak~augru,
          vbak~kunnr,
          vbak~kvgr1,
          vbap~posnr,
          vbap~matnr,
          vbap~arktx,
          vbap~abgru,
          vbap~kwmeng,
          vbap~zmeng,
          vbap~pstyv,
          vbap~vgbel,
          vbap~vgpos,
          mseg~mblnr,
          mseg~gjahr,
          mseg~zeile,
          mseg~budat_mkpf
     INTO TABLE @DATA(li_vbak_po)
     FROM vbap
     INNER JOIN vbak  ON vbap~vbeln = vbak~vbeln
     INNER JOIN mseg ON vbap~vbeln = mseg~kdauf
                      AND vbap~posnr = mseg~kdpos
     WHERE vbak~vbeln IN @lir_order
       AND vbak~auart = @lc_zclm
       AND vbak~erdat IN @lir_erdat
       AND vbak~ernam IN @lir_user
        AND vbak~kunnr IN @lir_kunnr
        AND  mseg~budat_mkpf IN @lir_wadat.
      IF li_vbak_po IS NOT INITIAL.
        DATA : lst_po LIKE LINE OF li_vbak.
        LOOP AT li_vbak_po INTO DATA(lst_vbak_po).
          MOVE-CORRESPONDING lst_vbak_po TO lst_po.
          APPEND lst_po TO li_vbak.
          CLEAR lst_po.
        ENDLOOP.
      ENDIF.

    ELSE.
      " Get Sales order data when input is without Claim processed date
      SELECT vbak~vbeln,
             vbak~erdat,
             vbak~ernam,
             vbak~auart,
             vbak~augru,
             vbak~kunnr,
             vbak~kvgr1,
             vbap~posnr,
             vbap~matnr,
             vbap~arktx,
             vbap~abgru,
             vbap~kwmeng,
             vbap~zmeng,
             vbap~pstyv,
             vbap~vgbel,
             vbap~vgpos
        INTO TABLE @li_vbak
        FROM vbak
        INNER JOIN vbap  ON vbak~vbeln = vbap~vbeln
        WHERE vbak~vbeln IN @lir_order
          AND vbak~auart = @lc_zclm
          AND vbak~erdat IN @lir_erdat
          AND vbak~ernam IN @lir_user
          AND vbak~kunnr IN @lir_kunnr.
    ENDIF.

    IF li_vbak IS NOT INITIAL.
      SORT li_vbak BY vbeln posnr.
      "Order status data
      SELECT vbeln,
             posnr,
             gbsta FROM vbup INTO TABLE @DATA(li_vbup)
             FOR ALL ENTRIES IN @li_vbak
               WHERE vbeln = @li_vbak-vbeln
                  AND posnr = @li_vbak-posnr.
      IF sy-subrc EQ 0.
        SORT li_vbup BY vbeln posnr.
      ENDIF.
      "Material data
      SELECT matnr,
             extwg,
             ismcopynr FROM mara INTO TABLE @DATA(li_mara)
              FOR ALL ENTRIES IN @li_vbak
              WHERE matnr = @li_vbak-matnr.
      IF sy-subrc EQ 0.
        SORT li_mara BY matnr.
      ENDIF.
      "Delivery Info
      IF lir_wadat IS INITIAL.
        SELECT "likp~wadat,
               likp~wadat_ist,
               likp~vstel,
               likp~lfdat,
               lips~vbeln,
               lips~posnr,
               lips~erdat,
               lips~vgbel,
               lips~vgpos
          FROM likp INNER JOIN lips
          ON likp~vbeln = lips~vbeln
          INTO TABLE @DATA(li_lips)
          FOR ALL ENTRIES IN @li_vbak
          WHERE vgbel = @li_vbak-vbeln
            AND vgpos = @li_vbak-posnr.
        IF li_lips IS NOT INITIAL.
          "for Material doc on delivery
          SELECT mblnr,mjahr,zeile,vbeln_im
                FROM mseg INTO TABLE @DATA(li_mseg_del)
                          FOR ALL ENTRIES IN @li_lips
                          WHERE vbeln_im = @li_lips-vbeln
                            AND vbeln_im NE ' '.
          IF sy-subrc EQ 0.
            SORT li_mseg_del BY vbeln_im DESCENDING.
          ENDIF.
          SORT li_lips BY vgbel vgpos.
        ENDIF.
      ELSE.
        "for Material doc on delivery
        SELECT mblnr,mjahr,zeile,vbeln_im
              FROM mseg INTO TABLE @li_mseg_del
                        FOR ALL ENTRIES IN @li_vbak
                        WHERE vbeln_im = @li_vbak-del
                          AND vbeln_im NE ' '.
        IF sy-subrc EQ 0.
          SORT li_mseg_del BY vbeln_im DESCENDING.
        ENDIF.
      ENDIF.
      " for Material document on PO
      SELECT mblnr,mjahr,zeile,kdauf,kdpos,
             budat_mkpf
             FROM mseg INTO TABLE @DATA(li_mseg_po)
                       FOR ALL ENTRIES IN @li_vbak
                       WHERE kdauf = @li_vbak-vbeln
                         AND kdpos = @li_vbak-posnr
                         AND budat_mkpf IN @lir_wadat.
      IF sy-subrc EQ 0.
        SORT li_mseg_po BY kdauf kdpos .
      ENDIF.
      "Get Purchase Requisition
      SELECT  vbeln,
              posnr,
              banfn FROM vbep INTO TABLE @DATA(li_vbep)
                               FOR ALL ENTRIES IN @li_vbak
                              WHERE vbeln = @li_vbak-vbeln
                               AND posnr = @li_vbak-posnr
                               AND banfn NE ' '.
      IF sy-subrc EQ 0.
        SORT li_vbep BY vbeln posnr.
        "Get PO info
*        SELECT ebeln,
*               ebelp,
*               banfn
*                     INTO TABLE @DATA(li_po) FROM ekpo
*                        FOR ALL ENTRIES IN @li_vbep
*                       WHERE ekpo~banfn = @li_vbep-banfn.
*        IF sy-subrc EQ 0.
*          SELECT mblnr,mjahr,zeile,ebeln FROM mseg INTO TABLE @DATA(li_mseg)
*                            FOR ALL ENTRIES IN @li_po
*                           WHERE ebeln = @li_po-ebeln.
*          IF sy-subrc EQ 0.
*            SORT li_mseg BY ebeln.
*          ENDIF.
*        ENDIF.
*        SORT li_po BY banfn.
      ENDIF.
      "for PO
      SELECT ebeln,ebelp,zekkn,vbeln,vbelp FROM ekkn INTO TABLE @DATA(li_ekkn)
                          FOR ALL ENTRIES IN @li_vbak
                             WHERE vbeln = @li_vbak-vbeln
                               AND vbelp = @li_vbak-posnr.
      IF sy-subrc EQ 0 AND li_ekkn IS NOT INITIAL.
        SORT li_ekkn BY vbeln vbelp.
      ENDIF.
      "for Item cat text
      SELECT pstyv,
             vtext FROM tvapt INTO TABLE @DATA(li_pstyv_txt)
              FOR ALL ENTRIES IN @li_vbak
              WHERE pstyv = @li_vbak-pstyv
                AND spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_pstyv_txt BY pstyv.
      ENDIF.
      "Customer Grp1 Text
      SELECT kvgr1,
             bezei FROM tvv1t INTO TABLE @DATA(li_kvgr1_text)
                       FOR ALL ENTRIES IN @li_vbak
                       WHERE kvgr1 = @li_vbak-kvgr1
                        AND  spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_kvgr1_text BY kvgr1.
      ENDIF.
      "Partners Data
      SELECT vbeln,
             posnr,
             parvw,
             kunnr,
             lifnr,
             adrnr,
             land1 FROM vbpa INTO TABLE @DATA(li_vbpa2)
             FOR ALL ENTRIES IN @li_vbak
                             WHERE vbeln = @li_vbak-vbeln
                               AND ( posnr = @li_vbak-posnr OR posnr = '000000')
                                AND parvw IN @lir_parvw.
      IF sy-subrc EQ 0.
        SORT li_vbpa2 BY vbeln posnr.
        "Partners Address
        SELECT addrnumber,
               name1,
               name2,
               country,
               tel_number,
               region
               FROM adrc  INTO TABLE @DATA(li_adrc)
                            FOR ALL ENTRIES IN @li_vbpa2
                               WHERE adrc~addrnumber = @li_vbpa2-adrnr.
        IF sy-subrc EQ 0 AND li_adrc IS NOT INITIAL.
          SORT li_adrc BY addrnumber.
          SELECT addrnumber,smtp_addr FROM adr6 INTO TABLE @DATA(li_adr6)
                                    FOR ALL ENTRIES IN @li_adrc
                                       WHERE addrnumber = @li_adrc-addrnumber.
          IF sy-subrc EQ 0.
            SORT li_adr6 BY addrnumber.
          ENDIF.
        ENDIF.

      ENDIF.
      "for reason for rejection
      SELECT abgru, bezei FROM tvagt INTO TABLE @DATA(li_tvagt)
                                   WHERE spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_tvagt BY abgru.
      ENDIF.
      "for Order reason text
      SELECT augru,
             bezei FROM tvaut INTO TABLE @DATA(li_tvaut)
                FOR ALL ENTRIES IN @li_vbak
                WHERE augru = @li_vbak-augru
                AND spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_tvaut BY augru.
      ENDIF.
      "Subscribers Count
      LOOP AT li_vbak INTO DATA(lst_matnr_qty).
        lst_matnr-low = lst_matnr_qty-matnr.
        lst_matnr-sign = lc_i.
        lst_matnr-option = lc_eq.
        APPEND lst_matnr TO lir_matnr.
        CLEAR lst_matnr.
      ENDLOOP.
      SORT   lir_matnr BY low.
      DELETE ADJACENT DUPLICATES FROM lir_matnr COMPARING low.
      SELECT matnr, SUM( menge ) AS menge FROM ekpo INTO TABLE @DATA(li_qty)
                              WHERE matnr IN @lir_matnr
                                 AND loekz NE @lc_loekz
                                   GROUP BY matnr.
    ENDIF.
    " SORT li_vbak BY vbeln DESCENDING posnr ASCENDING.
    LOOP AT li_vbak INTO DATA(lst_vbak).
      "Build sales info
      lst_final-vbeln     = lst_vbak-vbeln.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_vbak-posnr
        IMPORTING
          output = lst_final-posnr.
      lst_final-matnr = lst_vbak-matnr.
      lst_final-arktx  = lst_vbak-arktx.
      lst_final-kvgr1     = lst_vbak-kvgr1.
      lst_final-kunnr     = lst_vbak-kunnr.
      lst_final-augru     = lst_vbak-augru.
      lst_final-ernam     = lst_vbak-ernam.
      lst_final-pstyv     = lst_vbak-pstyv.
      lst_final-vgbel     = lst_vbak-vgbel.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_vbak-vgpos
        IMPORTING
          output = lst_final-vgpos.
      lv_zmeng      = lst_vbak-kwmeng.
      IF lv_zmeng IS INITIAL.
        lv_zmeng = lst_vbak-zmeng.
      ENDIF.
      SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
      CONDENSE lv_qty.
      lst_final-kwmeng       = lv_qty.
      "Delivery info
      READ TABLE li_lips INTO DATA(lst_lips) WITH KEY vgbel = lst_vbak-vbeln
                                                      vgpos = lst_vbak-posnr
                                                      BINARY SEARCH.
      IF sy-subrc = 0.
*        IF lst_lips-wadat_ist IS INITIAL.
*          lst_lips-wadat_ist = lst_lips-wadat.
*        ENDIF.
        IF lst_lips-wadat_ist IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_lips-wadat_ist
            IMPORTING
              output = lst_final-wadat_ist.
        ENDIF.
        lst_final-vbeln_vl  = lst_lips-vbeln.
        "Material doc on Del
        READ TABLE li_mseg_del INTO DATA(lst_mseg_del) WITH KEY vbeln_im = lst_lips-vbeln.
        IF sy-subrc EQ 0.
          lst_final-mblnr = lst_mseg_del-mblnr.
        ENDIF.
        lst_final-vstel = lst_lips-vstel.
        IF lst_lips-lfdat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_lips-lfdat
            IMPORTING
              output = lst_final-lfdat.
        ENDIF.
      ELSE.
*        IF lst_vbak-wadat_ist IS INITIAL.
*          lst_vbak-wadat_ist = lst_vbak-wadat.
*        ENDIF.
        IF lst_vbak-wadat_ist IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_vbak-wadat_ist
            IMPORTING
              output = lst_final-wadat_ist.
        ENDIF.
        IF lst_vbak-lfdat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_vbak-lfdat
            IMPORTING
              output = lst_final-lfdat.
        ENDIF.
        lst_final-vstel = lst_vbak-vstel.
        lst_final-vbeln_vl  = lst_vbak-del.
        "Material doc on Del
        READ TABLE li_mseg_del INTO lst_mseg_del WITH KEY vbeln_im = lst_vbak-del.
        IF sy-subrc EQ 0.
          lst_final-mblnr = lst_mseg_del-mblnr.
        ENDIF.
      ENDIF.
      "Material doc on PO
      READ TABLE li_mseg_po INTO DATA(lst_mseg_po)  WITH KEY kdauf = lst_vbak-vbeln
                                                            kdpos = lst_vbak-posnr
                                                            BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-mblnr = lst_mseg_po-mblnr.
        IF lst_mseg_po-budat_mkpf IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_mseg_po-budat_mkpf
            IMPORTING
              output = lst_final-wadat_ist.
        ENDIF.
      ENDIF.
      "Get Partners Address
      "Parallel Cursor
      READ TABLE li_vbpa2 TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbak-vbeln
                                                      posnr = lc_header
                                                       BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE li_vbpa2 TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbak-vbeln
                                                          posnr = lst_vbak-posnr
                                                        BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        lv_index = sy-tabix.
        "Parallel Cursor
        LOOP AT li_vbpa2 INTO DATA(lst_vbpa2) FROM lv_index.
          IF  lst_vbpa2-vbeln EQ lst_vbak-vbeln.
            IF lst_vbpa2-posnr EQ lst_vbak-posnr OR lst_vbpa2-posnr EQ lc_header.
              READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa2-adrnr
                                                            BINARY SEARCH.
              IF sy-subrc EQ 0.
                READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_adrc-addrnumber
                                                            BINARY SEARCH.
                CASE lst_vbpa2-parvw.
                  WHEN lc_ag.
                    lst_final-ag_land1  = lst_vbpa2-land1.
                    lst_final-ag_name1 = lst_adrc-name1.
                    lst_final-ag_name2 = lst_adrc-name2.
                    lst_final-ag_email = lst_adr6-smtp_addr.
                    lst_final-ag_tel = lst_adrc-tel_number.
                  WHEN lc_we.
                    lst_final-kunwe = lst_vbpa2-kunnr.
                    lst_final-we_land1  = lst_vbpa2-land1.
                    lst_final-we_name1 = lst_adrc-name1.
                    lst_final-we_name2 = lst_adrc-name2.
                    lst_final-we_tel = lst_adrc-tel_number.
                    lst_final-we_email = lst_adr6-smtp_addr.
                    lst_final-we_region = lst_adrc-region.
                  WHEN lc_sp.
                    lst_final-lifnr = lst_vbpa2-lifnr.
                    lst_final-sp_land1  = lst_vbpa2-land1.
                    lst_final-sp_name1 = lst_adrc-name1.
                    lst_final-sp_name2 = lst_adrc-name2.
                  WHEN OTHERS.
                ENDCASE.
                CLEAR : lst_adr6.
              ENDIF.
            ENDIF.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      "Order Status
      READ TABLE li_vbup INTO DATA(lst_vbup) WITH KEY vbeln = lst_vbak-vbeln
                                                      posnr = lst_vbak-posnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        CASE lst_vbup-gbsta.
          WHEN 'A'.
            lst_final-status =  'Not yet processed'."'should be approved'.
          WHEN 'B'.
            lst_final-status =  'Partially processed'."'in-progress'.
          WHEN 'C'.
            lst_final-status =  'Completely processed'."'approved'.
          WHEN OTHERS.
            lst_final-status =  'Not Relevant'."'denied'.
        ENDCASE.
      ENDIF.
      "Item Category Text
      READ TABLE li_pstyv_txt INTO DATA(lst_pstyv) WITH KEY pstyv = lst_vbak-pstyv
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-vtext = lst_pstyv-vtext.
      ENDIF.
      READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbak-matnr
                                                    BINARY SEARCH.
      IF  sy-subrc EQ 0.
        lst_final-extwg  = lst_mara-extwg.
        lst_final-ismcopynr = lst_mara-ismcopynr.
      ENDIF.
      "Subscribers Count
      READ TABLE li_qty INTO DATA(lst_qty) WITH KEY matnr = lst_vbak-matnr.
      IF sy-subrc EQ 0.
        CLEAR : lv_zmeng,lv_qty.
        lv_zmeng = lst_qty-menge.
        SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
        CONDENSE lv_qty.
        lst_final-sub_count = lv_qty.
      ENDIF.
      "Purchase Req.
      READ TABLE li_vbep INTO DATA(lst_vbep) WITH KEY vbeln = lst_vbak-vbeln
                                                       posnr = lst_vbak-posnr
                                                       BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-banfn  = lst_vbep-banfn.
      ENDIF.
      "PO
      READ TABLE li_ekkn INTO DATA(lst_ekkn) WITH KEY vbeln = lst_vbak-vbeln
                                                      vbelp = lst_vbak-posnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-ebeln = lst_ekkn-ebeln.
      ENDIF.
      "Order reason text
      READ TABLE li_tvaut INTO DATA(lst_tvaut) WITH KEY augru = lst_vbak-augru
                                                       BINARY SEARCH.
      IF  sy-subrc EQ 0.
        lst_final-bezei = lst_tvaut-bezei.
      ENDIF.
      "Reason for rejection
      READ TABLE li_tvagt INTO DATA(lst_tvagt) WITH KEY abgru = lst_vbak-abgru
                                                        BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-abgru = lst_tvagt-abgru.
        lst_final-reason_rej = lst_tvagt-bezei.
      ENDIF.
      "Customer Group1 text
      READ TABLE li_kvgr1_text INTO DATA(lst_kvgr1_txt) WITH KEY kvgr1 = lst_vbak-kvgr1
                                                       BINARY SEARCH.
      IF sy-subrc EQ 0..
        lst_final-kvgr1_text = lst_kvgr1_txt-bezei.
      ENDIF.
      "Order Creation Date
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_vbak-erdat
        IMPORTING
          output = lst_final-erdat.

      MOVE-CORRESPONDING lst_final TO  lst_entityset.
*      CONCATENATE 'http://' lv_host ':'
*                    lv_port lc_va03
*                    lst_final-vgbel
*                    INTO lst_final-link.
      APPEND lst_entityset TO et_entityset.
      CLEAR: lst_entityset,lst_final, lv_zmeng ,lv_qty.
    ENDLOOP.
    SORT et_entityset BY vbeln DESCENDING posnr ASCENDING.
    cl_http_server=>if_http_server~get_location(
             IMPORTING host = lv_host
                    port = lv_port ).

  ENDMETHOD.


METHOD ht005landset_get_entityset.
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


  METHOD ismcodeset_get_entityset.

    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_ismcode,
         ls_maxrow TYPE bapi_epm_max_rows.

    DATA:lst_kunnr  TYPE shp_kunnr_range,
         lst_matnr  TYPE curto_matnr_range,
         lst_maktx  TYPE fip_s_maktx_range,
         lir_maktx  TYPE fip_t_maktx_range,
         lst_order  TYPE farric_rs_vbeln,
         lir_relord TYPE STANDARD TABLE OF farric_rs_vbeln,
         lst_final  TYPE zcl_zqtc_rel_order_ser_mpc=>ts_ismcode,
         lir_matnr  TYPE STANDARD TABLE OF curto_matnr_range,
         lir_kunnr  TYPE STANDARD TABLE OF shp_kunnr_range,
         lir_shipto TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS: lc_cp   TYPE char2 VALUE 'CP',
               lc_eq   TYPE char2 VALUE 'EQ',
               lc_we   TYPE parvw VALUE 'WE',
               lc_i    TYPE char1 VALUE 'I',
               lc_zjip TYPE mtart VALUE 'ZJIP',
               lc_zsro TYPE auart VALUE 'ZSRO'.

    FREE:lst_kunnr,
         lst_final,
         lst_kunnr,
         lst_matnr,
         lst_maktx,
         lir_maktx,
         lst_final,
         lir_matnr,
         lir_relord,
         lst_order,
         lir_kunnr,
         lir_shipto,
         lir_kunnr,
         lir_shipto.


    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Ismidentcode'.
            CLEAR lst_matnr.
            lst_matnr-low = <ls_filter_opt>-low.
            IF lst_matnr-low NE 'null'.
              lst_matnr-option = lc_cp.
              CONCATENATE '*' <ls_filter_opt>-low '*' INTO DATA(lv_value).
              lst_matnr-sign = lc_i.
              lst_matnr-low  = lv_value.
              lst_matnr-high = <ls_filter_opt>-high.
              APPEND lst_matnr TO lir_matnr.

              lst_maktx-option = lc_cp.
              lst_maktx-sign = lc_i.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
              TRANSLATE lv_value TO UPPER CASE.
              lst_matnr-low  = lv_value.
              APPEND lst_matnr TO lir_matnr.
              lst_maktx-low  = lv_value.
              APPEND lst_maktx TO lir_maktx.
            ENDIF.
          WHEN 'Soldto'.
            CLEAR lst_kunnr.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              lst_kunnr-option = lc_eq.
              lst_kunnr-sign = lc_i.
              lst_kunnr-high = <ls_filter_opt>-high.
              APPEND lst_kunnr TO lir_kunnr.
            ENDIF.
          WHEN 'Shipto'.
            CLEAR lst_kunnr.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              lst_kunnr-option = lc_eq.
              lst_kunnr-sign = lc_i.
              lst_kunnr-high = <ls_filter_opt>-high.
              APPEND lst_kunnr TO lir_shipto.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lir_shipto IS NOT INITIAL.
      SELECT vbpa~vbeln
        FROM vbpa
        INNER JOIN vbak ON vbak~vbeln = vbpa~vbeln
        INTO TABLE @DATA(li_vbeln) UP TO 100 ROWS
        WHERE vbpa~kunnr IN @lir_shipto
          AND vbak~auart = @lc_zsro
          AND vbpa~parvw = @lc_we.

      IF li_vbeln IS NOT INITIAL.
        SORT li_vbeln BY vbeln .
        DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING vbeln.
        LOOP AT  li_vbeln INTO DATA(lst_vbeln).
          lst_order-low = lst_vbeln-vbeln.
          lst_order-option = lc_eq.
          lst_order-sign = lc_i.
          APPEND lst_order TO lir_relord.
        ENDLOOP.
      ENDIF.
    ENDIF. "IF lir_shipto IS NOT INITIAL.
    IF lir_shipto IS NOT INITIAL
      OR lir_kunnr IS NOT INITIAL.
      SELECT vbap~matnr,
             mara~mtart,
             mara~ismtitle,
             mara~ismyearnr,
             mara~ismcopynr,
             makt~maktg
        FROM vbap
        INNER JOIN vbak ON vbak~vbeln = vbap~vbeln
        INNER JOIN mara ON mara~matnr = vbap~matnr
        INNER JOIN makt ON makt~matnr = mara~matnr
        INTO TABLE @DATA(li_code) UP TO 100 ROWS
        WHERE vbap~matnr IN @lir_matnr
          AND vbap~arktx IN @lir_maktx
          AND vbak~auart = @lc_zsro.

    ELSE.

      SELECT mara~matnr,
             mara~mtart,
             mara~ismtitle,
             mara~ismyearnr,
             mara~ismcopynr,
             makt~maktg
        FROM mara
        INNER JOIN makt ON makt~matnr = mara~matnr
        INTO TABLE @li_code  UP TO 100 ROWS
        WHERE ( mara~mtart = @lc_zjip )
          AND (  mara~matnr IN @lir_matnr
           OR  mara~ismtitle IN @lir_maktx
           OR  makt~maktg IN @lir_maktx ) .
    ENDIF.

    ls_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
    lv_skip = is_paging-skip + 1.
    lv_total = is_paging-top + is_paging-skip.

    IF lv_total > 0.
      LOOP AT li_code INTO DATA(lst_code)  FROM lv_skip TO lv_total.
        lst_final-ismidentcode = lst_code-matnr.
        lst_final-arktx        = lst_code-ismtitle.
        lst_final-mtart        = lst_code-mtart.
        lst_final-ismcopynr    = lst_code-ismcopynr.
        lst_final-ismyearnr    = lst_code-ismyearnr.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ELSE.
      LOOP AT li_code INTO lst_code .
        lst_final-ismidentcode = lst_code-matnr.
        lst_final-arktx        = lst_code-ismtitle.
        lst_final-mtart        = lst_code-mtart.
        lst_final-ismcopynr    = lst_code-ismcopynr.
        lst_final-ismyearnr    = lst_code-ismyearnr.
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ENDIF.


    SORT et_entityset BY ismidentcode.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING ismidentcode.
  ENDMETHOD.


  METHOD odr_reasonset_get_entityset.
    TYPES:BEGIN OF ty_bezei,
            sign   TYPE char1,
            option TYPE char2,
            low    TYPE bezei40,
            high   TYPE bezei40,
          END OF ty_bezei.
    DATA: lir_augru TYPE RANGE OF augru,
          lst_augru TYPE rjksd_augru_range,
          lir_vkorg TYPE STANDARD TABLE OF range_vkorg,
          lst_vkorg TYPE range_vkorg,
          lst_bezei TYPE ty_bezei,
          lir_bezei TYPE RANGE OF bezei40,
          lv_bezei  TYPE bezei40.
    CONSTANTS:lc_i  TYPE char1 VALUE 'I',
              lc_cp TYPE char2 VALUE 'CP',
              lc_eq TYPE char2 VALUE 'EQ'.
    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Bezei'.
            lst_augru-low = <ls_filter_opt>-low+1(3).
            lst_bezei-low = <ls_filter_opt>-low.
            IF  <ls_filter_opt>-low IS NOT INITIAL.
              lst_augru-option = lc_cp.
              lst_bezei-option = lc_cp.
              lst_augru-sign   = lc_i.
              lst_bezei-sign   = lc_i.
              APPEND lst_augru TO lir_augru.
              " CONCATENATE lst_bezei-low '*' INTO lv_bezei.
              lv_bezei = lst_bezei-low.
              TRANSLATE lst_bezei-low TO UPPER CASE.
              " lst_bezei-low = lv_bezei.
              APPEND lst_bezei TO lir_bezei.
              TRANSLATE lst_augru-low TO UPPER CASE.
              APPEND lst_augru TO lir_augru.
              TRANSLATE lv_bezei+1(1) TO UPPER CASE.
              lst_bezei-low = lv_bezei.
              APPEND lst_bezei TO lir_bezei.
            ENDIF.
          WHEN 'Vkorg'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lst_vkorg-low = <ls_filter_opt>-low..
              lst_vkorg-option = lc_eq.
              lst_vkorg-sign = lc_i.
              APPEND lst_vkorg TO lir_vkorg.
              CLEAR lst_vkorg.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    IF lir_vkorg IS NOT INITIAL.
      SELECT auart,
             vkorg,
             augru FROM tvau_auart_vko INTO TABLE @DATA(li_tvau_auart_vko)
                     WHERE auart = 'ZCLM'
                      AND  vkorg IN @lir_vkorg.
      IF li_tvau_auart_vko IS NOT INITIAL.
        SELECT augru, bezei
          FROM tvaut
          INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          FOR ALL ENTRIES IN @li_tvau_auart_vko
          WHERE augru = @li_tvau_auart_vko-augru
            AND spras = @sy-langu.
      ENDIF.
      IF lir_bezei IS NOT INITIAL.
        SELECT augru, bezei
        FROM tvaut
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        WHERE ( augru IN @lir_augru OR bezei IN @lir_bezei )
          AND spras = @sy-langu.
      ENDIF.
    ELSE.
      SELECT augru, bezei
        FROM tvaut
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        WHERE ( augru IN @lir_augru OR bezei IN @lir_bezei )
          AND spras = @sy-langu.
    ENDIF.
  ENDMETHOD.


  METHOD reasonsset_get_entityset.
    DATA:lst_kunnr TYPE shp_kunnr_range,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range,
         lst_final TYPE zqtc_s_kunnr_reasons,
         lst_augru TYPE rjksd_augru_range,
         lir_augru TYPE rjksd_augru_range_tab.
    DATA: li_date   TYPE TABLE OF rsdsselopt,
          ir_date   TYPE TABLE OF rsdsselopt,
          lv_date   TYPE sy-datum,
          lv_start  TYPE sy-datum,
          lst_date  TYPE rsdsselopt,
          lv_date1  TYPE d,
          lv_begin  TYPE d,
          lv_end    TYPE d,
          li_months TYPE STANDARD TABLE OF t247.

    CONSTANTS:lc_devid TYPE zdevid     VALUE 'E252',
              lc_param TYPE rvari_vnam VALUE 'AUGRU',
              lc_one   TYPE tvarv_numb VALUE '0001',
              lc_two   TYPE tvarv_numb VALUE '0002',
              lc_three TYPE tvarv_numb VALUE '0003',
              lc_forth TYPE tvarv_numb VALUE '0004',
              lc_eq    TYPE char2 VALUE 'EQ',
              lc_bt    TYPE char2 VALUE 'BT',
              lc_i     TYPE char1 VALUE 'I',
              lc_zclm  TYPE auart VALUE 'ZCLM'.


    FREE:lst_kunnr,lir_kunnr,lst_final,li_date,lv_date,lst_augru,lir_augru,
         lv_start,lst_date,lv_date1,lv_begin,lv_end,li_months..

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Kunnr'.
            lst_kunnr-low = <ls_filter_opt>-low.
            IF lst_kunnr-low NE 'null'.
              lst_kunnr-option = lc_eq.
              lst_kunnr-sign = lc_i.
              DATA(lv_kunnr) = lst_kunnr-low.
              lst_kunnr-high = <ls_filter_opt>-high.
              APPEND lst_kunnr TO lir_kunnr.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.


    IF lir_kunnr IS NOT INITIAL.


      SELECT *
        FROM zcaconstant
        INTO TABLE @DATA(li_constant)
        WHERE devid = @lc_devid
          AND param1 = @lc_param.
      IF sy-subrc = 0.
        LOOP AT li_constant INTO DATA(lst_constant).
          IF lst_constant-srno = lc_one.
            DATA(lv_augru) = lst_constant-low.
          ELSEIF lst_constant-srno = lc_two.
            DATA(lv_augru1) = lst_constant-low.
          ELSEIF lst_constant-srno = lc_three.
            DATA(lv_augru2) = lst_constant-low.
          ELSEIF lst_constant-srno = lc_forth.
            DATA(lv_augru3) = lst_constant-low.
          ENDIF.
          CLEAR lst_constant.
        ENDLOOP.
      ENDIF.

      FREE:li_date,lst_date,lv_date.
      lst_date-sign   = lc_i.
      lst_date-option = lc_bt.
      lv_start = sy-datum.
      IF  lv_start+6(2) LE 30.
        lst_date-low    = lv_start .
        lst_date-high   = lv_start.
        APPEND lst_date TO li_date.
      ENDIF.
      DO 12 TIMES.
        CALL FUNCTION 'BKK_ADD_WORKINGDAY'
          EXPORTING
            i_date = lv_start
            i_days = '-30'
          IMPORTING
            e_date = lv_date.
        lst_date-low    =  lv_date .
        lst_date-high   = lv_start.
        APPEND lst_date TO li_date.
        lv_start = lv_date.
      ENDDO.


      CALL FUNCTION 'MONTH_NAMES_GET'
        EXPORTING
          language              = sy-langu
        TABLES
          month_names           = li_months
        EXCEPTIONS
          month_names_not_found = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      SELECT augru, bezei
            FROM tvaut
            INTO  TABLE @DATA(li_tvaut)
            WHERE spras = @sy-langu.


      LOOP AT li_date INTO lst_date.
        FREE:ir_date.
        lst_date-sign   = lc_i.
        lst_date-option = lc_bt.
        lv_date1 = lst_date-low.
        CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
          EXPORTING
            iv_date             = lv_date1
          IMPORTING
            ev_month_begin_date = lv_begin
            ev_month_end_date   = lv_end.
        lst_date-low   = lv_begin.
        lst_date-high  = lv_end.
        APPEND lst_date TO ir_date.

        SELECT COUNT( DISTINCT vbeln )
          INTO @DATA(lv_count)
          FROM vbak
          WHERE kunnr IN @lir_kunnr
            AND auart = @lc_zclm "'ZCLM'
            AND augru = @lv_augru
            AND erdat IN @ir_date.

        SELECT COUNT( DISTINCT vbeln )
          INTO @DATA(lv_count1)
          FROM vbak
          WHERE kunnr IN @lir_kunnr
            AND auart = @lc_zclm" 'ZCLM'
            AND augru = @lv_augru1
            AND erdat IN @ir_date.

        SELECT COUNT( DISTINCT vbeln )
          INTO @DATA(lv_count2)
          FROM vbak
          WHERE kunnr IN @lir_kunnr
            AND auart = @lc_zclm"'ZCLM'
            AND augru = @lv_augru2
            AND erdat IN @ir_date.
        SELECT COUNT( DISTINCT vbeln )
          INTO @DATA(lv_count3)
          FROM vbak
          WHERE kunnr IN @lir_kunnr
            AND auart = @lc_zclm "'ZCLM'
            AND augru = @lv_augru3
            AND erdat IN @ir_date.
        lst_final-count  = lv_count.
        lst_final-count1 = lv_count1.
        lst_final-count2 = lv_count2.
        lst_final-count3 = lv_count3.
        lst_final-augru  = lv_augru.
        lst_final-augru1 = lv_augru1.
        lst_final-augru2 = lv_augru2.
        lst_final-augru3 = lv_augru3.
        lst_final-kunnr = lv_kunnr.
        READ TABLE li_months INTO DATA(lst_months) WITH KEY mnr = lv_begin+4(2).
        IF sy-subrc = 0.
          lst_final-month = lst_months-ltx.
          CONCATENATE lst_final-month  lv_begin+0(4) INTO lst_final-month SEPARATED BY space.
        ENDIF.
        APPEND lst_final TO et_entityset.
        FREE:lst_final,lv_count,lv_count1,lv_count2.
      ENDLOOP.
    ENDIF.

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
         ls_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_soldto,
         ls_maxrow TYPE bapi_epm_max_rows.
    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lst_final TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshipto,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS: lc_cp      TYPE char2 VALUE 'CP',
               lc_i       TYPE char1 VALUE 'I'.



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
           AND but000~bu_group = '0001'
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
            AND but000~bu_group = '0001'
            AND but000~xblck = @abap_false.
      ENDIF.
    ELSE.
      SELECT kna1~kunnr,
               kna1~name1,
               kna1~name2
          INTO TABLE @li_soldto  UP TO 100 ROWS
          FROM kna1
           INNER JOIN but000 ON but000~partner = kna1~kunnr
           WHERE but000~bu_group = '0001'
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


  METHOD timeset_get_entity.

  ENDMETHOD.


  METHOD timeset_get_entityset.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E252',
               lc_time  TYPE rvari_vnam VALUE 'TIME'.
    SELECT
         low
         FROM zcaconstant
         INTO TABLE et_entityset
         WHERE devid  = lc_devid
           AND param1 = lc_time.


  ENDMETHOD.


  METHOD zclm_detailsset_get_entityset.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923488
* REFERENCE NO:  OTCM-42840
* DEVELOPER: Prabhu
* DATE: 5/19/2021
* DESCRIPTION: Add Stock Availability
*----------------------------------------------------------------------*
    DATA:lst_final TYPE zqtc_s_contract_details,
         lst_order TYPE fip_s_vbeln_range,
         lir_order TYPE STANDARD TABLE OF fip_s_vbeln_range,
         lst_auart TYPE fip_s_auart_range,
         lir_auart TYPE STANDARD TABLE OF fip_s_auart_range,
         lst_posnr TYPE rdb_posnr_sel,
         lir_posnr TYPE STANDARD TABLE OF rdb_posnr_sel,
         lv_qty    TYPE char18,
         lv_dec    TYPE char10,
         lv_zmeng  TYPE char18,
         lv_host   TYPE string,
         lv_port   TYPE string.

    CONSTANTS:lc_va03  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA03%20VBAK-VBELN='.
    CONSTANTS: lc_eq   TYPE char2 VALUE 'EQ',
               lc_i    TYPE char1 VALUE 'I',
               lc_zclm TYPE auart VALUE 'ZCLM'.



    cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
             port = lv_port ).

    FREE:lst_final,
         lst_order,
         lir_order,
         lst_auart,
         lir_auart,
         lst_posnr,
         lir_posnr.


    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'RelOrder'.  " Rel_order
            lst_order-low = <ls_filter_opt>-low.
            IF lst_order-low NE 'null'.
              lst_order-option = lc_eq.
              lst_order-sign = lc_i.
              lst_order-high = <ls_filter_opt>-high.
              APPEND lst_order TO lir_order.
            ENDIF.

          WHEN 'RelItem'.  " Rel_order
            lst_posnr-low = <ls_filter_opt>-low.
            IF lst_posnr-low NE '000000'.
              lst_posnr-option = lc_eq.
              lst_posnr-sign = lc_i.
              lst_posnr-high = <ls_filter_opt>-high.
              APPEND lst_posnr TO lir_posnr.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SELECT vbak~vbeln,
           vbak~erdat,
           vbak~ernam,
           vbak~auart,
           vbak~augru,
           vbap~posnr,
           vbap~matnr,
           vbap~arktx,
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
           vbap~abgru,
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
           vbap~kwmeng,
           vbap~zmeng,
           vbap~vgbel,
           vbap~vgpos,
           tvaut~bezei
      INTO TABLE @DATA(li_vbak)
      FROM vbak
      INNER JOIN vbap  ON vbak~vbeln = vbap~vbeln
      INNER JOIN tvaut ON vbak~augru = tvaut~augru
      WHERE vbak~auart = @lc_zclm
        AND vbap~vgbel IN @lir_order
        AND vbap~vgpos IN @lir_posnr
        AND tvaut~spras = @sy-langu.
    IF li_vbak IS NOT INITIAL.
      SELECT vbeln,
             posnr,
             erdat,
             vgbel,
             vgpos
        FROM lips
        INTO TABLE @DATA(li_lips)
        FOR ALL ENTRIES IN @li_vbak
        WHERE vgbel = @li_vbak-vbeln
          AND vgpos = @li_vbak-posnr.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
      IF li_lips IS NOT INITIAL.
        "for Material doc on delivery
        SELECT mblnr,mjahr,zeile,vbeln_im
              FROM mseg INTO TABLE @DATA(li_mseg_del)
                        FOR ALL ENTRIES IN @li_lips
                        WHERE vbeln_im = @li_lips-vbeln.
        IF sy-subrc EQ 0.
          SORT li_mseg_del BY vbeln_im DESCENDING.
        ENDIF.
      ENDIF.
      " for Material document on PO
      SELECT mblnr,mjahr,zeile,kdauf,kdpos
             FROM mseg INTO TABLE @DATA(li_mseg_po)
                       FOR ALL ENTRIES IN @li_vbak
                       WHERE kdauf = @li_vbak-vbeln
                         AND kdpos = @li_vbak-posnr.
      IF sy-subrc EQ 0.
        SORT li_mseg_po BY kdauf kdpos .
      ENDIF.
      "for Qty Confirmation
      SELECT vbeln,posnr,etenr,bmeng
               FROM vbep INTO TABLE @DATA(li_vbep)
              FOR ALL ENTRIES IN @li_vbak
                WHERE vbeln = @li_vbak-vbeln
                  AND posnr = @li_vbak-posnr
                  AND bmeng NE @space.
      IF sy-subrc EQ 0.
        SORT li_vbep BY vbeln posnr.
      ENDIF.
      "for reason for rejection
      SELECT abgru, bezei FROM tvagt INTO TABLE @DATA(li_tvagt)
                                   WHERE spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_tvagt BY abgru.
      ENDIF.
      "for PO
      SELECT ebeln,ebelp,zekkn,vbeln,vbelp FROM ekkn INTO TABLE @DATA(li_ekkn)
                          FOR ALL ENTRIES IN @li_vbak
                             WHERE vbeln = @li_vbak-vbeln
                               AND vbelp = @li_vbak-posnr.
      IF sy-subrc EQ 0 AND li_ekkn IS NOT INITIAL.

        SORT li_ekkn BY vbeln vbelp.
      ENDIF.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
    ENDIF.
    SORT li_vbak by vbeln DESCENDING.
    LOOP AT li_vbak INTO DATA(lst_vbak).
      lst_final-vgbel     = lst_vbak-vbeln.
      lst_final-rel_order = lst_vbak-vgbel.
      lst_final-rel_item  = lst_vbak-vgpos.
      lst_final-vgpos     = lst_vbak-posnr.
      lst_final-auart     = lst_vbak-auart.
      lst_final-augru     = lst_vbak-augru.
      lst_final-bezei     = lst_vbak-bezei.
      lst_final-matnr     = lst_vbak-matnr.
      lst_final-arktx     = lst_vbak-arktx.
      lv_zmeng      = lst_vbak-kwmeng.
      IF lv_zmeng IS INITIAL.
        lv_zmeng = lst_vbak-zmeng.
      ENDIF.
      SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
      CONDENSE lv_qty.
      lst_final-qty       = lv_qty.
      lst_final-created   = lst_vbak-ernam.
      READ TABLE li_lips INTO DATA(lst_lips) WITH KEY vgbel = lst_vbak-vbeln
                                                      vgpos = lst_vbak-posnr.
      IF sy-subrc = 0.
        lst_final-del_date  = lst_lips-erdat.
        lst_final-delivery  = lst_lips-vbeln.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
        READ TABLE li_mseg_del INTO DATA(lst_mseg_del) WITH KEY vbeln_im = lst_lips-vbeln.
        IF sy-subrc EQ 0.
          lst_final-mblnr = lst_mseg_del-mblnr.
        ENDIF.
      ENDIF.
      READ TABLE li_vbep INTO DATA(lst_vbep) WITH KEY vbeln = lst_vbak-vbeln
                                                      posnr = lst_vbak-posnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-confirmed = 'Confirmed'.
      ELSE.
        lst_final-confirmed = 'Not-Confirmed'.
      ENDIF.
      READ TABLE li_tvagt INTO DATA(lst_tvagt) WITH KEY abgru = lst_vbak-abgru
                                                       BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-abgru = lst_vbak-abgru.
        lst_final-reason_rej = lst_tvagt-bezei.
      ENDIF.
      READ TABLE li_ekkn INTO DATA(lst_ekkn) WITH KEY vbeln = lst_vbak-vbeln
                                                      vbelp = lst_vbak-posnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-po = lst_ekkn-ebeln.
      ENDIF.
      READ TABLE li_mseg_po INTO DATA(lst_mseg_po)  WITH KEY kdauf = lst_vbak-vbeln
                                                             kdpos = lst_vbak-posnr
                                                             BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final-mblnr = lst_mseg_po-mblnr.
      ENDIF.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_vbak-erdat
        IMPORTING
          output = lst_final-date.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_final-del_date
        IMPORTING
          output = lst_final-del_date.

      CONCATENATE 'http://' lv_host ':'
                    lv_port lc_va03
                    lst_final-vgbel
                    INTO lst_final-link.
      APPEND lst_final TO et_entityset.
      CLEAR: lst_final, lv_zmeng ,lv_qty.
    ENDLOOP.

    cl_http_server=>if_http_server~get_location(
             IMPORTING host = lv_host
                    port = lv_port ).


  ENDMETHOD.


  METHOD zrel_orderset_get_entityset.
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923488
* REFERENCE NO:  OTCM-42840
* DEVELOPER: Prabhu
* DATE: 5/19/2021
* DESCRIPTION: Add Stock Availability
*----------------------------------------------------------------------*
    DATA:lv_top     TYPE i,
         lv_skip    TYPE i,
         lv_total   TYPE i,
         lst_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zrel_order,
         lst_maxrow TYPE bapi_epm_max_rows.

    DATA:lst_rel_order TYPE zqtc_s_rel_orders,
         li_rel_order  TYPE STANDARD TABLE OF zqtc_s_rel_orders,
         lst_order     TYPE fip_s_vbeln_range,
         lir_order     TYPE STANDARD TABLE OF fip_s_vbeln_range,
         lir_contract  TYPE STANDARD TABLE OF fip_s_vbeln_range,
         lst_matnr     TYPE range_s_matnr,
         lir_matnr     TYPE STANDARD TABLE OF range_s_matnr,
         lst_kunnr     TYPE shp_kunnr_range,
         lst_auart     TYPE fip_s_auart_range,
         li_date       TYPE TABLE OF rsdsselopt,
         lv_date       TYPE sy-datum,
         lv_days       TYPE i,
         lst_date      TYPE rsdsselopt,
         lir_auart     TYPE STANDARD TABLE OF fip_s_auart_range,
         lir_kunnr     TYPE STANDARD TABLE OF shp_kunnr_range,
         lir_shipto    TYPE STANDARD TABLE OF shp_kunnr_range,
         lv_host       TYPE string,
         lv_port       TYPE string.

    DATA: lv_input                 TYPE string,
          lv_name                  TYPE string,
          lv_value                 TYPE string,
          lv_sign                  TYPE string,
          lv_sprint                TYPE string,
          lt_filter_string         TYPE TABLE OF string,
          lt_sptint                TYPE TABLE OF string,
          lt_key_value             TYPE /iwbep/t_mgw_name_value_pair,
          ls_filter_select_options TYPE /iwbep/s_mgw_select_option,
          lt_select_options        TYPE /iwbep/t_cod_select_options,
          ls_select_options        TYPE /iwbep/s_cod_select_option.

    FIELD-SYMBOLS: <fs_key_value>     LIKE LINE OF lt_key_value.

    CONSTANTS:lc_va03  TYPE string VALUE '/sap/bc/gui/sap/its/webgui?~Transaction=VA03%20VBAK-VBELN='.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E252',
               lc_days  TYPE rvari_vnam VALUE 'DAYS',
               lc_eq    TYPE char2 VALUE 'EQ',
               lc_bt    TYPE char2 VALUE 'BT',
               lc_i     TYPE char1 VALUE 'I',
               lc_we    TYPE parvw VALUE 'WE',
               lc_zclm  TYPE auart VALUE 'ZCLM',
               lc_zsro  TYPE auart VALUE 'ZSRO'.


    cl_http_server=>if_http_server~get_location(
      IMPORTING host = lv_host
             port = lv_port ).

    FREE:lst_rel_order,
          lir_contract,
         lst_order,
         lir_order,
         lst_matnr,
         lir_matnr,
         lst_kunnr,
         lir_shipto,
         lst_auart,
         lir_auart,
         lir_kunnr.

    lst_auart-sign   = lc_i.
    lst_auart-option = lc_eq.
    lst_auart-low    = lc_zsro.
    APPEND lst_auart TO lir_auart.

    SELECT SINGLE *
         FROM zcaconstant
         INTO @DATA(lst_const)
         WHERE devid = @lc_devid
           AND activate = @abap_true
           AND param1   = @lc_days.

    FREE:li_date,lst_date,lv_date.
    lst_date-sign   = lc_i.
    lst_date-option = lc_bt.
    lv_days = lst_const-low.
    CALL FUNCTION 'BKK_ADD_WORKINGDAY'
      EXPORTING
        i_date = sy-datum
        i_days = lv_days
      IMPORTING
        e_date = lv_date.
    lst_date-low    =  lv_date .
    lst_date-high   = sy-datum.
    APPEND lst_date TO li_date.


    IF   iv_filter_string IS NOT INITIAL.

      lv_input = iv_filter_string.

* *— get rid of )( & ‘ and make AND’s uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      REPLACE ALL OCCURRENCES OF ' - ' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' and '.
      SPLIT lv_input AT ' and ' INTO TABLE lt_filter_string.

*--— build a table of key value pairs based on filter string
      LOOP AT lt_filter_string INTO DATA(ls_filter_string).
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.
        CONDENSE ls_filter_string.
*       Split at space, then split into 3 parts
        SPLIT ls_filter_string AT ' ' INTO lv_name lv_sign lv_value.
        IF lv_name = 'SoldTo'.
          FREE:lv_sprint.
          IF lir_kunnr[] IS INITIAL.
            DATA(lv_length) = strlen( lv_value ).
            lv_length  = lv_length - 2.
            lv_sprint = lv_value+1(lv_length).
            IF lv_value NE 'null'.
              lst_kunnr-sign   = lc_i.
              lst_kunnr-option = lc_eq.
              lst_kunnr-low    = lv_sprint.
              APPEND lst_kunnr TO  lir_kunnr[].
            ENDIF.
          ENDIF.
        ELSEIF lv_name = 'ShipTo' .
          FREE:lst_kunnr,lv_length,lv_sprint.

          IF lir_shipto[] IS INITIAL.
            lv_length = strlen( lv_value ).
            lv_length  = lv_length - 2.
            lv_sprint = lv_value+1(lv_length).
            IF lv_value NE 'null'.
              lst_kunnr-sign   = lc_i.
              lst_kunnr-option = lc_eq.
              lst_kunnr-low    = lv_sprint.
              APPEND lst_kunnr TO  lir_shipto[].
            ENDIF.
          ENDIF.
        ELSEIF lv_name = 'Ismidentcode'.
          FREE:lv_length,lv_sprint,lt_sptint.
          lv_length = strlen( lv_value ).
          lv_length  = lv_length - 2.
          lv_sprint = lv_value+1(lv_length).
          SPLIT lv_sprint AT ',' INTO TABLE lt_sptint.
          LOOP AT lt_sptint INTO DATA(lst_sprint).
            lst_matnr-sign = lc_i.
            lst_matnr-option = lc_eq.
            lst_matnr-low = lst_sprint.
            APPEND lst_matnr TO lir_matnr.
          ENDLOOP.
        ENDIF.
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    IF lir_shipto IS NOT INITIAL.
      SELECT vbpa~vbeln
          FROM vbpa
          INNER JOIN vbak ON vbak~vbeln = vbpa~vbeln
          INTO TABLE @DATA(li_vbeln)
          WHERE vbpa~kunnr IN @lir_shipto
            AND vbak~auart = @lc_zsro
            AND vbpa~parvw = @lc_we.

      IF li_vbeln IS NOT INITIAL.
        SORT li_vbeln BY vbeln .
        DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING vbeln.
        LOOP AT  li_vbeln INTO DATA(lst_vbeln).
          lst_order-low    = lst_vbeln-vbeln.
          lst_order-option = lc_eq.
          lst_order-sign   = lc_i.
          APPEND lst_order TO lir_order.
        ENDLOOP.
      ENDIF.
    ENDIF.

*    SELECT *
*      FROM zsd_rel_orders
*      INTO TABLE @DATA(li_rel_orders)
*      WHERE auart = @lc_zsro
*        AND vbeln IN @lir_order
*        AND erdat IN @li_date
*        AND vgbel IN @lir_contract
*        AND matnr IN @lir_matnr
*        AND kunnr IN @lir_kunnr.
*    IF li_rel_orders IS NOT INITIAL.
    SELECT vbak~vbeln,
           vbak~erdat,
           vbak~vkorg,
           vbak~vtweg,
           vbak~auart,"""""
           vbak~augru,"""""
           vbak~kunnr,""""
           vbak~knkli,"""""
           vbak~vgbel,
           vbap~vgpos,
           vbap~posnr,
           vbap~erzet,
           vbap~matnr,
           kna1~name1,
           kna1~name2
*             vbap~vgbel """"
      FROM vbak
      INNER JOIN vbap ON vbak~vbeln = vbap~vbeln
      INNER JOIN kna1 ON vbak~kunnr = kna1~kunnr
      INTO TABLE @DATA(li_vbak)
       WHERE ( vbak~auart =  @lc_zsro OR vbak~auart =  @lc_zclm )
      AND vbak~vbeln IN @lir_order
      AND vbak~erdat IN @li_date
      AND vbak~vgbel IN @lir_contract
      AND vbap~matnr IN @lir_matnr
      AND vbak~kunnr IN @lir_kunnr.
**        FOR ALL ENTRIES IN @li_rel_orders
**        WHERE vbak~vgbel  = @li_rel_orders-vbeln
**           AND vbak~auart = @lc_zclm.
*      SORT  li_vbak BY erdat DESCENDING erzet DESCENDING.
    DATA(li_vbak_t) = li_vbak.
    SORT li_vbak BY auart.
    DELETE li_vbak WHERE auart = lc_zclm.
    SORT li_vbak_t BY auart.
    DELETE li_vbak_t WHERE auart = lc_zsro.
    SORT:li_vbak BY vbeln posnr,
         li_vbak_t BY erdat DESCENDING erzet DESCENDING.
    IF li_vbak IS NOT INITIAL.""""
*      SELECT ebeln,
*             ebelp,
*             vbeln,
*             vbelp,
*             kostl
*        FROM ekkn
*        INTO TABLE @DATA(li_ekkn)
*        FOR ALL ENTRIES IN @li_vbak
*        WHERE vbeln = @li_vbak-vbeln AND vbelp = @li_vbak-posnr.
*      IF li_ekkn IS NOT INITIAL.""""
*        SELECT banfn,
*               bnfpo,
*               ebeln,
*               ebelp,
*               bedat
*          FROM eban
*          INTO TABLE @DATA(li_eban)
*          FOR ALL ENTRIES IN @li_ekkn
*          WHERE ebeln = @li_ekkn-ebeln AND ebelp = @li_ekkn-ebelp.
*      ENDIF.
      SELECT banfn,
             bnfpo,
             zebkn,
             vbeln,
             vbelp
             FROM ebkn INTO TABLE @DATA(li_ebkn)
         FOR ALL ENTRIES IN @li_vbak
        WHERE vbeln = @li_vbak-vbeln AND vbelp = @li_vbak-posnr.
      IF sy-subrc EQ 0 AND li_ebkn IS NOT INITIAL.
        SELECT banfn,
               bnfpo,
               ebeln,
               ebelp,
               bedat FROM eban INTO TABLE @DATA(li_eban)
          FOR ALL ENTRIES IN @li_ebkn
          WHERE banfn = @li_ebkn-banfn
            AND bnfpo = @li_ebkn-bnfpo.
        SORT li_ebkn BY vbeln vbelp.
        SORT li_eban BY banfn bnfpo.
      ENDIF.

      SELECT vbeln,
             posnr,
             kunnr
        FROM vbpa
        INTO TABLE @DATA(li_vbpa)
        FOR ALL ENTRIES IN @li_vbak"li_rel_orders
        WHERE vbeln = @li_vbak-vbeln"li_rel_orders-vbeln
          AND kunnr IN @lir_shipto
          AND parvw = @lc_we.
      IF li_vbpa IS NOT INITIAL.
        SELECT kunnr, name1
          FROM kna1
          INTO TABLE @DATA(li_kna1)
          FOR ALL ENTRIES IN @li_vbpa
          WHERE kunnr = @li_vbpa-kunnr.
      ENDIF.
      SELECT vbelv,
             posnv,
             vbeln,
             posnn,
             vbtyp_n,
             stufe
        FROM vbfa
        INTO TABLE @DATA(li_vbfa)
        FOR ALL ENTRIES IN @li_vbak"li_rel_orders
        WHERE vbelv = @li_vbak-vbeln "li_rel_orders-vbeln
          AND posnv = @li_vbak-posnr "li_rel_orders-posnr.
          AND ( vbtyp_n = 'V' OR vbtyp_n = 'J' ) "PO/Del
          AND stufe = '00'.
      IF li_vbak IS NOT INITIAL.
        SELECT vbeln,
               posnr
          FROM vbuv
          INTO TABLE @DATA(li_vbuv)
          FOR ALL ENTRIES IN @li_vbak
          WHERE vbeln = @li_vbak-vbeln
            AND posnr = @li_vbak-posnr.
      ENDIF.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020 Add Stock Availability
      "For the delivering plant
      SELECT matnr,
             vkorg,
             vtweg,
             dwerk FROM mvke INTO TABLE @DATA(li_mvke)
                      FOR ALL ENTRIES IN @li_vbak
                     WHERE matnr = @li_vbak-matnr
                       AND vkorg = @li_vbak-vkorg
                       AND vtweg = @li_vbak-vtweg.
      IF sy-subrc EQ 0 AND li_mvke IS NOT INITIAL.
        "For the Unrestricted Qty
        SELECT matnr,
               werks,
               lgort,
               labst FROM mard INTO TABLE @DATA(li_mard)
           FOR ALL ENTRIES IN @li_mvke
            WHERE matnr = @li_mvke-matnr
              AND werks = @li_mvke-dwerk.
        IF sy-subrc EQ 0.
          SORT li_mard BY matnr werks.
          SORT li_mvke BY matnr vkorg vtweg.
        ENDIF.
      ENDIF.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
    ENDIF.

    SORT:li_kna1 BY kunnr,
         li_vbpa BY vbeln posnr,
       "  li_ekkn BY vbeln vbelp,
        " li_eban BY ebeln ebelp,
         li_vbfa BY vbelv posnv.
*    LOOP AT li_rel_orders INTO DATA(lst_rel_orders).
    LOOP AT li_vbak INTO DATA(lst_rel_orders).
      lst_rel_order-auart         = lst_rel_orders-auart.
      lst_rel_order-rel_order     = lst_rel_orders-vbeln.
      lst_rel_order-rel_item      = lst_rel_orders-posnr.
      lst_rel_order-ismidentcode  = lst_rel_orders-matnr.
      lst_rel_order-contract_num  = lst_rel_orders-vgbel.
      IF lst_rel_orders-vgpos IS NOT INITIAL.
        lst_rel_order-contract_item = lst_rel_orders-vgpos.
      ENDIF.
      lst_rel_order-sold_to       = lst_rel_orders-kunnr.
      lst_rel_order-sold_to_name  = lst_rel_orders-name1.
      lst_rel_order-vkorg = lst_rel_orders-vkorg.
      READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_rel_orders-vbeln
                                                      posnr = lst_rel_orders-posnr
                                                             BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_rel_orders-vbeln
                                                        posnr = '000000'
                                                            BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        lst_rel_order-ship_to       = lst_vbpa-kunnr.
        READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_vbpa-kunnr
                                                        BINARY SEARCH.
        IF sy-subrc = 0.
          lst_rel_order-ship_to_name  = lst_kna1-name1.
        ENDIF.
      ENDIF.
*        READ TABLE li_ekkn INTO DATA(lst_ekkn) WITH KEY vbeln = lst_rel_orders-vbeln
*                                                        vbelp = lst_rel_orders-posnr
*                                                        BINARY SEARCH.
*        IF sy-subrc = 0.
**        lst_rel_order-pur_order     = lst_rel_orders-ebeln.
*          lst_rel_order-pur_order     = lst_ekkn-ebeln.
*          lst_rel_order-pur_item      = lst_ekkn-ebelp.
**        lst_rel_order-pur_item      = lst_rel_orders-ebelp.
*        ENDIF.
      READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbelv = lst_rel_orders-vbeln
                                                      posnv = lst_rel_orders-posnr
                                                       BINARY SEARCH .
      IF sy-subrc EQ 0.
        IF lst_vbfa-vbtyp_n = 'V' AND lst_vbfa-stufe = '00'.
          lst_rel_order-pur_order_des = 'Purchase Order'(001).
        ELSEIF lst_vbfa-vbtyp_n = 'J' AND lst_vbfa-stufe = '00'.
          lst_rel_order-pur_order_des =  'Delivery'(002).
          lst_rel_order-pur_order     = lst_vbfa-vbeln .
          lst_rel_order-pur_item      = lst_vbfa-posnn .
        ENDIF.
      ENDIF.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
      READ TABLE li_mvke INTO DATA(lst_mvke) WITH KEY matnr = lst_rel_orders-matnr
                                                      vkorg = lst_rel_orders-vkorg
                                                      vtweg = lst_rel_orders-vtweg
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE li_mard INTO DATA(lst_mard) WITH KEY matnr = lst_mvke-matnr
                                                        werks = lst_mvke-dwerk
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_rel_order-avl_stock = lst_mard-labst.
          SPLIT  lst_rel_order-avl_stock  AT '.' INTO lst_rel_order-avl_stock DATA(lv_zero).
          CONDENSE lst_rel_order-avl_stock.
        ENDIF.
      ENDIF.
      READ TABLE li_ebkn INTO DATA(lst_ebkn) WITH KEY vbeln = lst_rel_orders-vbeln
                                                      vbelp = lst_rel_orders-posnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_rel_order-pur_requisition  = lst_ebkn-banfn.
        lst_rel_order-pur_req_ietm     = lst_ebkn-bnfpo.
        READ TABLE li_eban INTO DATA(lst_eban) WITH KEY banfn = lst_ebkn-banfn
                                                     bnfpo = lst_ebkn-bnfpo
                                                     BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF lst_eban-bedat IS NOT INITIAL.
            lst_rel_order-pur_date       = lst_eban-bedat.
          ENDIF.
          IF lst_eban-ebeln IS NOT INITIAL.
            lst_rel_order-pur_order     = lst_eban-ebeln.
          ENDIF.
          IF lst_eban-ebelp IS NOT INITIAL.
            lst_rel_order-pur_item      = lst_eban-ebelp.
          ENDIF.
        ENDIF.
      ENDIF.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
*        READ TABLE li_eban INTO DATA(lst_eban) WITH KEY ebeln = lst_ekkn-ebeln
*                                                         ebelp = lst_ekkn-ebelp
*                                                         BINARY SEARCH.
*        IF sy-subrc = 0.
**        lst_rel_order-pur_date         = lst_rel_orders-bedat.
*          lst_rel_order-pur_date         = lst_eban-bedat.
*          lst_rel_order-pur_requisition  = lst_eban-banfn.
**        lst_rel_order-pur_requisition  = lst_rel_orders-banfn.
*          lst_rel_order-pur_req_ietm     = lst_eban-bnfpo.
**        lst_rel_order-pur_req_ietm     = lst_rel_orders-bnfpo.
*        ENDIF.
      SELECT COUNT( DISTINCT vbeln )
        INTO @DATA(lv_count)
        FROM vbap
        WHERE vgbel = @lst_rel_orders-vbeln
          AND vgpos = @lst_rel_orders-posnr.
      lst_rel_order-count_claim = lv_count.
      CONCATENATE 'http://' lv_host ':'
                    lv_port lc_va03
                    lst_rel_order-count_claim
                    INTO lst_rel_order-link1.

      READ TABLE li_vbak_t INTO DATA(lst_vbak) WITH KEY vgbel = lst_rel_orders-vbeln
                                                      vgpos = lst_rel_orders-posnr.
      IF sy-subrc = 0.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lst_vbak-erdat
          IMPORTING
            output = lst_rel_order-rec_claim.

        lst_rel_order-new_claim = lst_vbak-vbeln.
        SELECT SINGLE vbeln,  posnr
               FROM vbuv
               INTO  @DATA(lst_vbuv)
               WHERE vbeln = @lst_rel_order-new_claim
                 AND posnr = @lst_vbak-posnr.
        IF sy-subrc = 0.
          lst_rel_order-status = 'Incomplete'(005).
        ELSE.
          lst_rel_order-status = 'Complete'(006).
        ENDIF.
        CONCATENATE 'http://'(007) lv_host ':'
                    lv_port lc_va03
                    lst_rel_order-new_claim
                    INTO lst_rel_order-link.

      ENDIF.
      APPEND lst_rel_order TO li_rel_order.
*    ENDIF.
    CLEAR lst_rel_order.
  ENDLOOP.

  lst_maxrow-bapimaxrow = is_paging-top + is_paging-skip.
  lv_skip = is_paging-skip + 1.
  lv_total = is_paging-top + is_paging-skip.

  IF lv_total > 0.
    CLEAR lst_rel_order.
    LOOP AT li_rel_order INTO lst_rel_order FROM lv_skip TO lv_total.

      lst_entity = CORRESPONDING #( lst_rel_order ).
      APPEND lst_entity TO et_entityset.
      CLEAR:lst_rel_order,lst_entity.
    ENDLOOP.
  ELSE.
    MOVE-CORRESPONDING li_rel_order TO et_entityset.
  ENDIF.

  cl_http_server=>if_http_server~get_location(
        IMPORTING host = lv_host
               port = lv_port ).


ENDMETHOD.


  METHOD zshiptonamset_get_entityset.
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_final TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshiptoname,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.
    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshiptoname,
         ls_maxrow TYPE bapi_epm_max_rows.

    CONSTANTS: lc_cp   TYPE char2 VALUE 'CP',
               lc_i    TYPE char1 VALUE 'I',
               lc_we   TYPE parvw VALUE 'WE',
               lc_zsro TYPE auart VALUE 'ZSRO'.


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
      SELECT vbpa~kunnr,
             kna1~name1,
             kna1~name2
         FROM vbpa
        INNER JOIN kna1 ON kna1~kunnr = vbpa~kunnr
        INNER JOIN vbak ON vbak~vbeln = vbpa~vbeln
        INTO TABLE @DATA(li_shipto) UP TO 10 ROWS
        WHERE vbpa~kunnr IN @lir_kunnr
          OR kna1~name1 IN @lir_name
          OR kna1~name2 IN @lir_name
          AND vbpa~parvw = @lc_we
          AND vbak~auart = @lc_zsro.

      SORT li_shipto BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_shipto COMPARING kunnr.
      LOOP AT li_shipto INTO DATA(lst_shipto).
        lst_final-kunnr = lst_shipto-kunnr. "ship to
        lst_final-name1 = lst_shipto-name1. "ship to
        lst_final-name2 = lst_shipto-name2. "ship to
        APPEND lst_final TO et_entityset.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.


  METHOD zshiptoset_get_entityset.
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_final TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshipto,
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


  METHOD zsoldtonamset_get_entityset.
    TYPES: BEGIN OF ty_name1,
             sign   TYPE char1,
             option TYPE char2,
             low    TYPE char35,
             high   TYPE char35,
           END OF ty_name1.

    DATA:lv_top    TYPE i,
         lv_skip   TYPE i,
         lv_total  TYPE i,
         ls_entity TYPE zcl_zqtc_rel_order_ser_mpc=>ts_soldto,
         ls_maxrow TYPE bapi_epm_max_rows.
    DATA:lst_kunnr TYPE shp_kunnr_range,
         lst_name  TYPE ty_name1,
         lir_name  TYPE STANDARD TABLE OF ty_name1,
         lst_final TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zshipto,
         lir_kunnr TYPE STANDARD TABLE OF shp_kunnr_range.

    CONSTANTS: lc_cp   TYPE char2 VALUE 'CP',
               lc_i    TYPE char1 VALUE 'I',
               lc_zsro TYPE auart VALUE 'ZSRO'.

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
      SELECT vbak~kunnr,
             kna1~name1,
             kna1~name2
        FROM vbak
        INNER JOIN kna1 ON kna1~kunnr = vbak~kunnr
        INTO TABLE @DATA(li_soldto)  UP TO 10 ROWS
        WHERE vbak~auart = @lc_zsro
           OR kna1~kunnr IN @lir_kunnr
           OR kna1~name1 IN @lir_name
           OR kna1~name1 IN @lir_name.
      SORT  li_soldto BY kunnr.
      DELETE ADJACENT DUPLICATES FROM li_soldto COMPARING kunnr.

      MOVE-CORRESPONDING li_soldto TO et_entityset.
    ENDIF.


  ENDMETHOD.


  METHOD zsroset_get_entityset.
    DATA:lst_data TYPE zcl_zqtc_rel_order_ser_mpc=>ts_zsro,
         li_date  TYPE TABLE OF rsdsselopt,
         lv_date  TYPE sy-datum,
         lst_date TYPE rsdsselopt,
         lv_days  TYPE i.

    CONSTANTS: lc_devid TYPE zdevid VALUE 'E252',
               lc_days  TYPE rvari_vnam VALUE 'DAYS',
               lc_bt    TYPE char2 VALUE 'BT',
               lc_i     TYPE char1 VALUE 'I',
               lc_zclm  TYPE auart VALUE 'ZCLM',
               lc_zsof  TYPE auart VALUE 'ZSOF',
               lc_zsro  TYPE auart VALUE 'ZSRO'.

    SELECT SINGLE *
        FROM zcaconstant
        INTO @DATA(lst_const)
        WHERE devid = @lc_devid
          AND activate = @abap_true
          AND param1   = @lc_days.


    FREE:li_date,lst_date,lv_date.
    lst_date-sign   = lc_i.
    lst_date-option = lc_bt.
    lv_days = lst_const-low.
    CALL FUNCTION 'BKK_ADD_WORKINGDAY'
      EXPORTING
        i_date = sy-datum
        i_days = lv_days
      IMPORTING
        e_date = lv_date.
    lst_date-low    =  lv_date .
    lst_date-high   = sy-datum.
    APPEND lst_date TO li_date.
    SELECT *
      FROM tvakt
      INTO TABLE @DATA(li_tvakt) WHERE spras = @sy-langu.

    SELECT COUNT( DISTINCT vbeln )
      FROM vbak
      INTO @DATA(lv_count)
      WHERE auart = @lc_zsro
        AND erdat IN @li_date.
    CLEAR: lst_data.
    lst_data-auart = lc_zsro.
    lst_data-count = lv_count.
    READ TABLE li_tvakt INTO DATA(lst_tvakt) WITH KEY auart = lst_data-auart.
    IF sy-subrc = 0.
      CONCATENATE lc_zsro  '-'
                  lst_tvakt-bezei
                  INTO lst_data-bezei SEPARATED BY space.
    ENDIF.
    APPEND lst_data TO et_entityset.
    FREE:lv_count.
    SELECT COUNT( DISTINCT vbeln )
          FROM vbak
          INTO lv_count
          WHERE auart = 'ZSOF'
            AND erdat IN li_date.
    CLEAR: lst_data.
    lst_data-auart = lc_zsof.
    lst_data-count = lv_count.
    READ TABLE li_tvakt INTO lst_tvakt WITH KEY auart = lst_data-auart.
    IF sy-subrc = 0.
      CONCATENATE lc_zsof  '-'
                   lst_tvakt-bezei
                   INTO lst_data-bezei SEPARATED BY space.
    ENDIF.
    APPEND lst_data TO et_entityset.
    FREE:lv_count.
    SELECT COUNT( DISTINCT vbeln )
      FROM vbak
      INTO lv_count
      WHERE auart = lc_zclm
        AND erdat IN li_date.
    CLEAR: lst_data.
    lst_data-auart = lc_zclm.
    lst_data-count = lv_count.
    READ TABLE li_tvakt INTO lst_tvakt WITH KEY auart = lst_data-auart.
    IF sy-subrc = 0.
      CONCATENATE lc_zclm  '-'
                   lst_tvakt-bezei
                   INTO lst_data-bezei SEPARATED BY space.
    ENDIF.
    APPEND lst_data TO et_entityset.

  ENDMETHOD.
ENDCLASS.
