*&---------------------------------------------------------------------*
*& Report  ZQTC_REL_ORDER_CREATE
*&
*&---------------------------------------------------------------------*
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923488
* REFERENCE NO:  OTCM-42840
* DEVELOPER: Prabhu
* DATE: 5/19/2021
* DESCRIPTION: Add Stock Availability
*----------------------------------------------------------------------*
REPORT zqtc_rel_order_create.
TYPES:BEGIN OF ty_tmp,
        sign   TYPE char1,
        option TYPE char2,
        low    TYPE vbeln,
        high   TYPE posnr,
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
      lst_schedules_in  TYPE bapischdl,
      lst_schedules_inx TYPE bapischdlx,
      li_schedules_in   TYPE STANDARD TABLE OF bapischdl,
      li_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
      lt_selected       TYPE STANDARD TABLE OF ty_tmp,
      lst_selected      TYPE ty_tmp,
      li_wmdvsx         TYPE STANDARD TABLE OF  bapiwmdvs,
      li_wmdvex         TYPE STANDARD TABLE OF  bapiwmdve,
      lv_av_qty_plt     TYPE bapicm61v-wkbst,
      lv_return         TYPE  bapireturn,
      lv_item           TYPE bapisditm-itm_number.
DATA:
  lv_actv_flag_e252 TYPE zactive_flag. "Active / Inactive Flag

CONSTANTS:
  lc_wricef_id_e252 TYPE zdevid VALUE 'E252',         "Development ID
  lc_ser_num_e252   TYPE zsno   VALUE '001'.           "Serial Number
CONSTANTS: lc_we   TYPE parvw VALUE 'WE',
           lc_ag   TYPE parvw VALUE 'AG',
           lc_i    TYPE char1 VALUE 'I',
           lc_zclm TYPE auart VALUE 'ZCLM'.

TABLES:vbap,vbak.
SELECT-OPTIONS:s_vbeln FOR  vbak-vbeln,
               s_posnr FOR vbap-posnr,
               s_auart FOR vbak-auart,
               s_augru FOR vbak-augru,
               lr_sel  FOR vbak-vbeln NO-DISPLAY.

START-OF-SELECTION.
*---To fill the joural codes and descrition for for ATP quantity check
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e252
      im_ser_num     = lc_ser_num_e252
    IMPORTING
      ex_active_flag = lv_actv_flag_e252.

  LOOP AT lr_sel INTO DATA(lst_sel).
    lst_selected-low   = lst_sel-low.
    lst_selected-high  = lst_sel-high.
    APPEND lst_selected TO lt_selected.
  ENDLOOP.
  FREE:lt_partners[].
  FREE:lt_item[].
  FREE:lt_itemx[].
  CLEAR:lv_item.
  SELECT vk~vbeln,
         vk~vkorg,
         vk~vtweg,
         vk~spart,
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
     INNER JOIN vbap AS vb ON vb~vbeln = vk~vbeln
     INTO TABLE @DATA(li_data)
     WHERE vb~vbeln IN @s_vbeln
       AND vb~posnr IN @s_posnr.
  IF lv_actv_flag_e252 IS NOT INITIAL.
    IF li_data IS NOT INITIAL.
      SORT li_data BY vbeln.
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

  SELECT vbeln,
         posnr,
         parvw,
         kunnr
    FROM vbpa
    INTO TABLE @DATA(li_vbpa)
  WHERE vbeln IN @s_vbeln
    AND ( posnr IN @s_posnr OR posnr = '000000' )
    AND parvw = @lc_we.




  SORT li_data BY vbeln.
  LOOP AT s_vbeln INTO DATA(lst_vbeln).
    FREE:lst_head,lst_headx,lt_item,lt_itemx,lt_partners,lt_return,lv_item,
    li_schedules_in,li_schedules_inx,lt_partners.
    READ TABLE li_data INTO DATA(lst_data) WITH KEY vbeln = lst_vbeln-low.
    IF sy-subrc = 0.
      DATA(lv_tabix) = sy-tabix.
      LOOP AT li_data INTO lst_data FROM lv_tabix.
        IF lst_data-vbeln <> lst_vbeln-low.
          EXIT.
        ELSE.
          READ TABLE lt_selected INTO lst_selected WITH KEY low = lst_vbeln-low
                                                            high = lst_data-posnr.
          IF sy-subrc = 0.
            IF lv_actv_flag_e252 EQ abap_true.
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
            IF lv_actv_flag_e252 EQ abap_false.
              lv_av_qty_plt = lv_qty_t.
            ENDIF.

            IF lv_av_qty_plt GE lv_qty_t.
* Populate Header Info
              CLEAR:lst_head.
              lst_head-doc_type = lc_zclm.
              lst_head-sales_org = lst_data-vkorg.
              lst_head-division = lst_data-spart.
              lst_head-distr_chan = lst_data-vtweg.
              lst_head-ref_doc = lst_data-vbeln.
              lst_head-ord_reason = s_augru-low.
              lst_head-refdoc_cat = 'C'.

* Populate Header update structure
              CLEAR:lst_headx.
              lst_headx-updateflag = lc_i.
              lst_headx-doc_type = abap_true.
              lst_headx-sales_org = abap_true.
              lst_headx-division = abap_true.
              lst_headx-distr_chan = abap_true.
              lst_headx-ref_doc = abap_true.
              lst_headx-refdoc_cat = abap_true.
              lst_headx-ord_reason = abap_true.


              lv_item = lv_item + 10.
* Populate Item info
              CLEAR:lst_item.
              lst_item-itm_number = lv_item.
              lst_item-material = lst_data-matnr.
              lst_item-target_qty = lst_data-kwmeng.
              IF lst_item-target_qty IS INITIAL.
                lst_item-target_qty = lst_data-zmeng.
              ENDIF.
              lst_item-ref_doc = lst_data-vbeln.
              lst_item-ref_doc_it = lst_data-posnr.
              APPEND lst_item TO lt_item.

              CLEAR:lst_itemx.
              lst_itemx-itm_number = lst_item-itm_number.
              lst_itemx-material = abap_true.
              lst_itemx-target_qty = abap_true.
              lst_itemx-ref_doc = abap_true.
              lst_itemx-ref_doc_it = abap_true.
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
              lst_partner-partn_role = lc_ag.
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
                lst_partner-partn_role = lc_we.
                APPEND lst_partner TO lt_partners.
              ENDIF.

            ELSE.
**----Material Qty is not available then passing error message
*            IF lv_av_qty_plt LE lv_qty_t.
              CONCATENATE 'Information'(003)
                      '-No Available quantity for material:'(002)
                       lst_data-matnr
                      INTO DATA(lv_msg1).
              WRITE lv_msg1.
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
*           SALESDOCUMENTIN     =
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

        FIELD-SYMBOLS:   <lt_data>  TYPE table.

        IF lv_salesdoc IS NOT INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

          WRITE: 'Claim Num :', lv_salesdoc.
*--*BOC OTCM-42840 TR ED2K923488 5/19/2020
          LOOP AT lt_item INTO DATA(lst_item_new).
            SELECT SINGLE vbeln,posnr,etenr FROM vbep INTO @DATA(lst_vbep)
                                WHERE vbeln = @lv_salesdoc
                                   AND posnr = @lst_item_new-itm_number
                                   AND bmeng NE @space.
            IF sy-subrc NE 0.
              WRITE :  / 'Claim Item Not Confirmed', lv_salesdoc, lst_item_new-itm_number.
            ELSE.
              WRITE :  / 'Claim Item Confirmed', lv_salesdoc, lst_item_new-itm_number.
            ENDIF.
          ENDLOOP.
*--*EOC OTCM-42840 TR ED2K923488 5/19/2020
        ELSE.
          LOOP AT lt_return INTO DATA(lst_return1).
            CONCATENATE lst_return1-message
                        lst_return1-message_v1
                        lst_return1-message_v2
                        lst_return1-message_v3
                        lst_return1-message_v4 INTO DATA(lv_msg).
            WRITE lv_msg.
          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.
    FREE:lst_head,lst_headx,lt_item,lt_itemx,lt_partners,li_schedules_in,li_schedules_inx,
         lt_return,lv_item.
  ENDLOOP.
