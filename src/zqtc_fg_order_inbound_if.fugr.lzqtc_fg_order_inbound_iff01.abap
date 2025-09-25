**----------------------------------------------------------------------*
*INCLUDE LZQTC_FG_ORDER_INBOUND_IFF01.
**----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CONTRACT_ZSUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_contract_zsub .
  PERFORM f_map_bapi_header USING gst_header.

  PERFORM f_map_bapi_item TABLES gi_item.

  PERFORM f_map_bapi_partners TABLES gi_partner.

  PERFORM f_map_bapi_conditions TABLES gi_cond.

  PERFORM f_map_bapi_cards.

  PERFORM f_map_bapi_contract TABLES gi_item_cust.

  PERFORM f_map_bapi_extension TABLES gi_item_cust.

  PERFORM f_map_bapi_text TABLES gi_item_cust.

  PERFORM f_call_bapi_contract.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_header USING fp_header TYPE ty_header.
  gst_bapi_header-currency = fp_header-crcy.
  gst_bapi_header-pmnttrms = fp_header-zterm.
  gst_bapi_header-dlv_block = fp_header-lifsk.
  gst_bapi_header-doc_type = fp_header-doctype.
  gst_bapi_header-collect_no = fp_header-submi.
  gst_bapi_header-sales_org = fp_header-sorg.
  gst_bapi_header-distr_chan = fp_header-dch.
  gst_bapi_header-division  = fp_header-division.
  gst_bapi_header-sales_off = fp_header-saleoff.
  gst_bapi_header-po_method = fp_header-potype.
  IF gst_header-date  IS NOT INITIAL.
    gst_bapi_header-req_date_h = fp_header-date.
  ENDIF.
  gst_bapi_header-purch_no_c = fp_header-po.
  gst_bapi_header-ref_1_s = fp_header-ref_1_s.
  gst_bapi_header-name = fp_header-name.

  gst_bapi_headerx-currency = c_x.
  gst_bapi_headerx-pmnttrms = c_x.
  gst_bapi_headerx-dlv_block = c_x.
  gst_bapi_headerx-doc_type = c_x.
  gst_bapi_headerx-collect_no = c_x.
  gst_bapi_headerx-sales_org = c_x.
  gst_bapi_headerx-distr_chan = c_x.
  gst_bapi_headerx-division  = c_x.
  gst_bapi_headerx-sales_off = c_x.
  gst_bapi_headerx-po_method = c_x.
  IF gst_header-date  IS NOT INITIAL.
    gst_bapi_headerx-req_date_h = c_x.
  ENDIF.
  gst_bapi_headerx-purch_no_c = c_x.
  gst_bapi_headerx-ref_1_s = c_x.
  gst_bapi_headerx-name = c_x.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_item TABLES fp_gi_item.
  DATA: lv_item TYPE i.
  LOOP AT fp_gi_item INTO gst_item.
    ADD 10 TO lv_item.
    gst_bapi_items-itm_number = lv_item.
    PERFORM f_check_bom CHANGING lv_item.
    gst_bapi_items-po_itm_no  = gst_item-item.
    gst_bapi_items-target_qty = gst_item-menge.
    gst_bapi_items-item_categ = gst_item-pstyv.
*            = gst_item-belnr.
    READ TABLE gi_poitem INTO gst_poitem WITH KEY item = gst_item-item.
    IF sy-subrc EQ 0.
      gst_bapi_items-poitm_no_s = gst_poitem-zeile.
    ENDIF.
*            = gst_item-date.
    READ TABLE gi_mat INTO gst_mat WITH KEY item = gst_item-item.
    IF sy-subrc EQ 0.
      gst_bapi_items-material     = gst_mat-matnr.
      gst_bapi_items-cust_mat35   = gst_mat-kdmat.
    ENDIF.
    READ TABLE gi_item_add INTO gst_item_add WITH KEY item = gst_item-item.
    IF sy-subrc EQ 0.
      gst_bapi_items-prc_group1 = gst_item_add-prc_group1.
      gst_bapi_items-cstcndgrp5 = gst_item_add-cstcndgrp5.
    ENDIF.

    APPEND gst_bapi_items TO gi_bapi_items.
    CLEAR gst_bapi_items.
    gst_bapi_itemsx-itm_number = lv_item.
    gst_bapi_itemsx-po_itm_no  = c_x.
    gst_bapi_itemsx-target_qty = c_x.
    gst_bapi_itemsx-item_categ = c_x.
*            = gst_item-belnr.
    gst_bapi_itemsx-poitm_no_s = c_x.
*            = gst_item-date.
    gst_bapi_itemsx-material     = c_x.
    gst_bapi_itemsx-cust_mat35   = c_x.
    gst_bapi_itemsx-prc_group1 = c_x.
    gst_bapi_itemsx-cstcndgrp5 = c_x.
    APPEND gst_bapi_itemsx TO gi_bapi_itemsx.
    CLEAR gst_bapi_itemsx.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_PARTNERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_partners TABLES fp_gi_partner.
  LOOP AT fp_gi_partner INTO gst_partner.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gst_partner-item
      IMPORTING
        output = gst_partner-item.

    READ TABLE gi_bapi_items INTO gst_bapi_items WITH KEY po_itm_no = gst_partner-item.
    IF sy-subrc EQ 0.
      gst_bapi_partners-itm_number = gst_bapi_items-itm_number.
    ENDIF.
    gst_bapi_partners-partn_role = gst_partner-pf.
    gst_bapi_partners-partn_numb = gst_partner-partner.
    APPEND gst_bapi_partners TO gi_bapi_partners.
    CLEAR gst_bapi_partners.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_CONDITIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_conditions TABLES fp_gi_cond.
  LOOP AT fp_gi_cond INTO gst_cond.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gst_cond-item
      IMPORTING
        output = gst_cond-item.
    READ TABLE gi_bapi_items INTO gst_bapi_items WITH KEY po_itm_no = gst_cond-item.
    IF sy-subrc EQ 0.
      gst_bapi_cond-itm_number = gst_bapi_items-itm_number.
    ENDIF.
    gst_bapi_cond-cond_type = gst_cond-kschl.
    gst_bapi_cond-cond_value = gst_cond-betrg .
    APPEND gst_bapi_cond TO gi_bapi_cond.
    CLEAR : gst_bapi_cond.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CALL_BAPI_ZSUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bapi_contract .
  DATA : lst_idoc_status  TYPE bdidocstat.

  CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
    EXPORTING
      sales_header_in      = gst_bapi_header
      sales_header_inx     = gst_bapi_headerx
      business_object      = c_bus2034
    IMPORTING
      salesdocument_ex     = gv_doc
    TABLES
      return               = gi_return
      sales_items_in       = gi_bapi_items
      sales_items_inx      = gi_bapi_itemsx
      sales_partners       = gi_bapi_partners
      sales_conditions_in  = gi_bapi_cond
      sales_conditions_inx = gi_bapi_condx
      sales_ccard          = gi_bapi_card
      sales_text           = gi_bapi_text
      sales_contract_in    = gi_bapi_contract
      sales_contract_inx   = gi_bapi_contractx
      extensionin          = gi_bapi_ext.

  READ TABLE gi_return INTO gst_return WITH KEY type = c_e.
  IF sy-subrc NE 0.
    READ TABLE gi_return INTO gst_return WITH KEY type = c_a.
  ENDIF.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    CLEAR lst_idoc_status.
    lst_idoc_status-docnum   = gv_idoc.
    lst_idoc_status-msgty    = gst_return-type.
    lst_idoc_status-msgid    = gst_return-id.
    lst_idoc_status-msgno    = gst_return-number.
    lst_idoc_status-status   = c_status_51.
*        lst_idoc_status-status   = '68'.
    lst_idoc_status-repid    = sy-repid.
    APPEND lst_idoc_status TO idoc_status.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = c_x.
    READ TABLE gi_return INTO gst_return WITH KEY type = c_s
                                         message_v2 = gv_doc.
    IF sy-subrc EQ 0.
      lst_idoc_status-docnum   = gv_idoc.
      lst_idoc_status-msgty    = gst_return-type.
      lst_idoc_status-msgid    = gst_return-id.
      lst_idoc_status-msgno    = gst_return-number.
*      lst_idoc_status-MSGV1  = gst_return-msgv1.
      lst_idoc_status-msgv2  = gst_return-message_v2.
      lst_idoc_status-status   = c_status_53.
*        lst_idoc_status-status   = '68'.
      lst_idoc_status-repid    = sy-repid.
      APPEND lst_idoc_status TO idoc_status.
    ENDIF.
  ENDIF.
  REFRESH : gi_return,gi_bapi_items,gi_bapi_itemsx,gi_bapi_partners,gi_bapi_cond,gi_bapi_condx,
            gi_bapi_card,gi_bapi_text,gi_bapi_contract,gi_bapi_contractx,gi_bapi_ext.
  CLEAR : gst_bapi_header,gst_bapi_headerx.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_CARDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_cards .
  IF gst_header-cardnum IS NOT INITIAL.
    gst_bapi_card-cc_type = gst_header-cardtype.
    gst_bapi_card-cc_number = gst_header-cardnum.
    gst_bapi_card-cc_name = gst_header-cardname.
    gst_bapi_card-cc_valid_t = gst_header-expdate.
    APPEND gst_bapi_card TO gi_bapi_card.
    CLEAR gst_bapi_card.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZE_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialize_variables .
  REFRESH : gi_partner,gi_text,gi_item,gi_cond,gi_return,gi_bapi_items,
            gi_bapi_itemsx,gi_bapi_partners,gi_bapi_cond,gi_bapi_card.
  CLEAR  : gst_header,gst_partner,gst_text, gst_item,gst_cond,
           gst_bapi_header,gst_bapi_headerx,gv_doc,gst_return,
           gst_bapi_items,gst_bapi_itemsx,gst_bapi_partners,
           gst_bapi_cond,gst_bapi_card,gst_bapi_text.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_text TABLES fp_gi_text.
  DATA:li_lines1  TYPE STANDARD TABLE OF tline,
       lst_lines1 TYPE tline.
  CONSTANTS : lc_vbbp TYPE char4 VALUE 'VBBP',
              lc_vbbk TYPE char4 VALUE 'VBBK'.
  IF fp_gi_text IS NOT INITIAL.
    LOOP AT fp_gi_text INTO gst_text.
      IF gst_text-item IS INITIAL.
        gst_bapi_text-text_id = gst_text-tdid.
        gst_bapi_text-langu = sy-langu.
*        gst_bapi_text-tdobject  = lc_vbbk.
        gst_bapi_text-text_line = gst_text-text.
      ELSE.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = gst_text-item
          IMPORTING
            output = gst_text-item.
        READ TABLE gi_bapi_items INTO gst_bapi_items WITH KEY po_itm_no = gst_text-item.
        IF sy-subrc EQ 0.
**** concatenating contract number with line item number
*          CONCATENATE gv_doc gst_bapi_items-itm_number INTO gst_bapi_text-tdname.
          gst_bapi_text-itm_number = gst_bapi_items-itm_number.
          gst_bapi_text-text_id = gst_text-tdid.
          gst_bapi_text-langu = sy-langu.
          gst_bapi_text-text_line = gst_text-text.
        ENDIF.
      ENDIF.
      APPEND gst_bapi_text TO gi_bapi_text.
      CLEAR gst_bapi_text.
    ENDLOOP. " LOOP AT li_text1 INTO lst_text1

  ENDIF. " IF li_text1 IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_EXTENSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_extension TABLES fp_gi_item_cust.
  CONSTANTS:lc_bape_vbak  TYPE char9  VALUE 'BAPE_VBAK',  " Bape_vbak of type CHAR9
            lc_bape_vbap  TYPE char9  VALUE 'BAPE_VBAP',  " Bape_vbak of type CHAR9
            lc_posnr      TYPE posnr  VALUE '000000',     " Item number of the SD document
            lc_bape_vbakx TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
            lc_bape_vbapx TYPE char10 VALUE 'BAPE_VBAPX'. " Bape_vbak of type CHAR9
  DATA :  lst_bape_vbak  TYPE bape_vbak,  " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbap  TYPE bape_vbap,  " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbapx TYPE bape_vbapx, " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbakx TYPE bape_vbakx. " BAPI Interface for Customer Enhancements to Tab

  LOOP AT fp_gi_item_cust INTO gst_item_cust.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gst_item_cust-vposn
      IMPORTING
        output = gst_item_cust-vposn.
    READ TABLE gi_bapi_items INTO gst_bapi_items WITH KEY po_itm_no = gst_item_cust-vposn.
    IF sy-subrc EQ 0.
      lst_bape_vbap-posnr = gst_bapi_items-itm_number.
      lst_bape_vbap-zzconstart  = gst_item_cust-zzcontent_start_d.
      lst_bape_vbap-zzconend   = gst_item_cust-zzcontent_end_d.
      lst_bape_vbap-zzlicstart = gst_item_cust-zzlicense_start_d.
      lst_bape_vbap-zzlicend = gst_item_cust-zzlicense_end_d.
      gst_bapi_ext-structure = lc_bape_vbap.
      gst_bapi_ext+30(960)   = lst_bape_vbap.
      APPEND gst_bapi_ext TO gi_bapi_ext.
      CLEAR gst_bapi_ext.
*
      lst_bape_vbapx-posnr = gst_bapi_items-itm_number.
      lst_bape_vbapx-zzconstart  = c_x.
      lst_bape_vbapx-zzconend   = c_x.
      lst_bape_vbapx-zzlicstart = c_x.
      lst_bape_vbapx-zzlicend = c_x.
      gst_bapi_ext-structure = lc_bape_vbapx.
      gst_bapi_ext+30(960)   = lst_bape_vbapx.
      APPEND gst_bapi_ext TO gi_bapi_ext.
      CLEAR gst_bapi_ext.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_CONTRACT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_contract TABLES fp_gi_item_cust.
  LOOP AT fp_gi_item_cust INTO gst_item_cust.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gst_item_cust-vposn
      IMPORTING
        output = gst_item_cust-vposn.

    READ TABLE gi_bapi_items INTO gst_bapi_items WITH KEY po_itm_no = gst_item_cust-vposn.
    IF sy-subrc EQ 0.
      gst_bapi_contract-itm_number = gst_bapi_items-itm_number.
      gst_bapi_contract-con_st_dat = gst_item_cust-vbegdat.
      gst_bapi_contract-con_en_dat = gst_item_cust-venddat.
      APPEND gst_bapi_contract TO gi_bapi_contract.
      CLEAR gst_bapi_contract.
      gst_bapi_contractx-itm_number = gst_bapi_items-itm_number.
      gst_bapi_contractx-con_st_dat = c_x.
      gst_bapi_contractx-con_en_dat = c_x.
      APPEND gst_bapi_contractx TO gi_bapi_contractx.
      CLEAR gst_bapi_contractx.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_ITEM  text
*----------------------------------------------------------------------*
FORM f_check_bom  CHANGING  fp_lv_item TYPE i.
  DATA : li_stpo  TYPE STANDARD TABLE OF stpo_api02,
         lv_plant TYPE csap_mbom-werks,
         lv_count TYPE i.

  CONSTANTS :lc_usage TYPE csap_mbom-stlan VALUE '5'.

  READ TABLE gi_mat INTO gst_mat WITH KEY item = gst_item-item.
  IF sy-subrc EQ 0 AND gst_mat-matnr IS NOT INITIAL.

    SELECT SINGLE dwerk FROM mvke INTO lv_plant WHERE matnr = gst_mat-matnr
                                                 AND  vkorg = gst_bapi_header-sales_org
                                                 AND  vtweg = gst_bapi_header-distr_chan.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'CSAP_MAT_BOM_READ'
        EXPORTING
          material  = gst_mat-matnr
          plant     = lv_plant
          bom_usage = lc_usage
        TABLES
          t_stpo    = li_stpo
        EXCEPTIONS
          error     = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.
        DESCRIBE TABLE li_stpo LINES lv_count.
        lv_count = lv_count * 10.
        fp_lv_item = fp_lv_item + lv_count.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CONTRACT_ZMBR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_contract_zmbr.


  DATA :  lst_header       TYPE ty_header,
          li_partner_dummy TYPE STANDARD TABLE OF ty_partner,
          li_partner       TYPE STANDARD TABLE OF ty_partner,
          lst_partner      TYPE ty_partner,
          li_item          TYPE STANDARD TABLE OF ty_item,
          lst_item         TYPE ty_item,
          li_cond          TYPE STANDARD TABLE OF ty_cond,
          lst_cond         TYPE ty_cond,
          li_text          TYPE STANDARD TABLE OF ty_text,
          li_item_cust     TYPE STANDARD TABLE OF ty_item_cust,
          lst_item_cust    TYPE ty_item_cust,
          lst_idoc_status  TYPE bdidocstat..


  LOOP AT gi_partner INTO lst_partner WHERE pf = c_pf_we.
    IF lst_partner-item IS NOT INITIAL.
      APPEND lst_partner TO li_partner_dummy.
      CLEAR lst_partner.
    ENDIF.
  ENDLOOP.

  SORT li_partner_dummy.

  LOOP AT li_partner_dummy INTO lst_partner.

    READ TABLE gi_cond INTO gst_cond WITH KEY item = lst_partner-item.
    IF sy-subrc EQ 0.
      lst_cond = gst_cond.
      APPEND lst_cond TO li_cond.
      CLEAR lst_cond.
    ENDIF.

    READ TABLE gi_item_cust INTO gst_item_cust WITH KEY vposn = lst_partner-item.
    IF sy-subrc EQ 0.
      lst_item_cust = gst_item_cust.
      APPEND lst_item_cust TO li_item_cust.
      CLEAR lst_item_cust.
    ENDIF.
    LOOP AT gi_text INTO gst_text WHERE item = lst_partner-item.
      APPEND gst_text TO li_text.
      CLEAR gst_text.
    ENDLOOP.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lst_partner-item
      IMPORTING
        output = lst_partner-item.

    READ TABLE gi_item INTO gst_item WITH KEY item = lst_partner-item.
    IF sy-subrc EQ 0.
      lst_item = gst_item.
      APPEND lst_item TO li_item.
      CLEAR lst_item.
    ENDIF.

    APPEND lst_partner TO li_partner.
    CLEAR lst_partner.

    AT END OF partner.
      lst_header = gst_header.
      lst_header-doctype = c_zmbr.
      READ TABLE gi_partner INTO lst_partner WITH KEY pf = c_pf_ag
                                                      item = c_header_item.
      IF sy-subrc EQ 0.
        APPEND lst_partner TO li_partner.
        CLEAR lst_partner.
      ENDIF.
      READ TABLE gi_partner INTO lst_partner WITH KEY pf = c_pf_we
                                                   item = c_header_item.
      IF sy-subrc EQ 0.
        APPEND lst_partner TO li_partner.
        CLEAR lst_partner.
      ENDIF.
      PERFORM f_map_bapi_header USING lst_header.

      PERFORM f_map_bapi_item TABLES li_item.

      PERFORM f_map_bapi_partners TABLES li_partner.

      PERFORM f_map_bapi_conditions TABLES li_cond.

      PERFORM f_map_bapi_cards.

      PERFORM f_map_bapi_contract TABLES li_item_cust.

      PERFORM f_map_bapi_extension TABLES li_item_cust.

      PERFORM f_map_bapi_text TABLES li_text.

      PERFORM f_call_bapi_contract.
      CLEAR :   lst_header, lst_item_cust, lst_partner, lst_item,lst_cond.
      REFRESH : li_partner,
                li_item,
                li_cond,
                li_item_cust.
    ENDAT.
  ENDLOOP.

  READ TABLE idoc_status INTO lst_idoc_status WITH KEY status = c_status_51.
  IF sy-subrc EQ 0.
    APPEND lst_idoc_status TO idoc_status.
    CLEAR lst_idoc_status.
  ENDIF.
ENDFORM.
