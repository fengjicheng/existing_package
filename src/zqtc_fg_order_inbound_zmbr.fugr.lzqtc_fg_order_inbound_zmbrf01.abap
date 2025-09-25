*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_ORDER_INBOUND_ZMBRF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : LZQTC_FG_ORDER_INBOUND_ZMBRF01 (Include)
* PROGRAM DESCRIPTION : This Include is used for subroutines called in FM
* DEVELOPER           : Prabhu Kishore T
* CREATION DATE       : 6/8/2016
* OBJECT ID           :
* TRANSPORT NUMBER(S) : ED2K912203
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CONTRACT_ZSUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_contract_zmbr .
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc header segments data with
*  BAPI Header structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_header.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Item segments data with
*  BAPI Item structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_item.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Partner segments data with
*  BAPI for both Header and Item level structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_partners.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Pricing segments data with
*  BAPI Pricing condition structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_conditions.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Payment cartds segments data
*  with BAPI Payment card structures at heade level
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_cards.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Additional segments data with
*  BAPI Additional structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_contract.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Custom segments data with
*  BAPI Extension In structures
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_extension.
*----------------------------------------------------------------------*
*  This subroutine is used to map the Idoc Text segments data with
*  BAPI structures for text at header and Item level
*----------------------------------------------------------------------*
  PERFORM f_map_bapi_text.
*----------------------------------------------------------------------*
*  This subroutine is used to call BAPI to create Sales contract(ZMBR)
*----------------------------------------------------------------------*
  PERFORM f_call_bapi_contract.
*---------------------------------------------------------------------*
* This Subroutine is used to update relation ship between Idoc and Order
*---------------------------------------------------------------------*

  PERFORM f_update_relation_idoc.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_header.
  DATA : lv_date TYPE char8.
  st_bapi_header-currency = st_header-crcy.      "Currency
  st_bapi_header-pmnttrms = st_header-zterm.     "Payment Terms
  st_bapi_header-dlv_block = st_header-lifsk.    "Delivery block
  st_bapi_header-doc_type = st_header-doctype.   "Sales doc type
  st_bapi_header-collect_no = st_header-submi.   "Collection num
  st_bapi_header-sales_org = st_header-sorg.     "Sales org
  st_bapi_header-distr_chan = st_header-dch.     "Distri channel
  st_bapi_header-division  = st_header-division. "Division
  st_bapi_header-sales_off = st_header-saleoff.  "Sales Office
  st_bapi_header-po_method = st_header-potype.   "PO type

  IF st_header-reqdate NE '00000000' AND st_header-billdate NE '0'..
    st_bapi_header-req_date_h = st_header-reqdate.  "Requested delivery date
    st_bapi_headerx-req_date_h = c_x.
  ENDIF.

  IF st_header-billdate NE '00000000' AND st_header-billdate NE '0'.
    st_bapi_header-bill_date = st_header-billdate.
    st_bapi_headerx-bill_date = c_x.
  ELSE.
    st_bapi_header-bill_date = sy-datum.
    st_bapi_headerx-bill_date = c_x.
  ENDIF.

  IF  st_header-podate NE '00000000' AND st_header-podate NE '0'.
    st_bapi_header-purch_date = st_header-podate.
    st_bapi_headerx-purch_date = c_x.
  ENDIF.
  st_bapi_header-purch_no_c = st_header-po.      "Customer PO
  st_bapi_header-ref_1_s = st_header-ref_1_s.    "Your refrence
  st_bapi_header-name = st_header-name.          "Name

  st_bapi_headerx-currency = c_x.              "Update flag for currency field
  st_bapi_headerx-pmnttrms = c_x.              "Update flag for Payment terms
  st_bapi_headerx-dlv_block = c_x.             "Update flag for delivery block
  st_bapi_headerx-doc_type = c_x.              "Update flag for PO doc type
  st_bapi_headerx-collect_no = c_x.            "Update flag for Collection num
  st_bapi_headerx-sales_org = c_x.             "Update flag for sales org
  st_bapi_headerx-distr_chan = c_x.            "Update flag for distri channel
  st_bapi_headerx-division  = c_x.             "Update flag for Division
  st_bapi_headerx-sales_off = c_x.             "Update flag for Sales office
  st_bapi_headerx-po_method = c_x.             "Update flag PO type

  st_bapi_headerx-purch_no_c = c_x.            "Update flag for po num
  st_bapi_headerx-ref_1_s = c_x.               "Update flag for your ref
  st_bapi_headerx-name = c_x.                  "Update flag for name
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_item .
  LOOP AT i_item INTO st_item.
    READ TABLE i_poitem INTO st_poitem WITH KEY item = st_item-item
                                                BINARY SEARCH.
    IF sy-subrc EQ 0.
      st_bapi_items-poitm_no_s = st_poitem-zeile. "Item number at item level shipto
      st_bapi_itemsx-poitm_no_s = c_x.     "Update flag for PO Item num at shipto
    ENDIF.
*--*Get the Material info based on PO Item
    READ TABLE i_mat INTO st_mat WITH KEY item = st_item-item
                                          kdmat = ' '.
    IF sy-subrc EQ 0.
      st_bapi_items-material     = st_mat-matnr. "Material
      st_bapi_itemsx-material     = c_x.   "Update flag for Material
    ENDIF.
    READ TABLE i_mat INTO st_mat WITH KEY item = st_item-item
                                          matnr = ' '.
    IF sy-subrc EQ 0.
      st_bapi_items-cust_mat35     = st_mat-kdmat. "Customer Material
      st_bapi_itemsx-cust_mat35   = c_x.   "Update flag for Customer material
    ENDIF.
*--*Get the Additional info based on PO item
*    READ TABLE i_item_add INTO st_item_add WITH KEY item = st_item-item
*                                                    BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      st_bapi_items-prc_group1 = st_item_add-prc_group1. "Price group1
*      st_bapi_items-cstcndgrp5 = st_item_add-cstcndgrp5. "Customer price group5
*    ENDIF.
    LOOP AT i_item_add INTO st_item_add WHERE item = st_item-item.
      IF st_item_add-mvgr1 IS NOT INITIAL.
        st_bapi_items-prc_group1 = st_item_add-mvgr1. "Mat Price group1
        st_bapi_itemsx-prc_group1 = c_x.     "Update flag for Price group1
      ENDIF.
      IF st_item_add-mvgr2 IS NOT INITIAL.
        st_bapi_items-prc_group2 = st_item_add-mvgr2. "Mat Price group2
        st_bapi_itemsx-prc_group2 = c_x.     "Update flag for Price group1
      ENDIF.
      IF st_item_add-mvgr3 IS NOT INITIAL.
        st_bapi_items-prc_group3 = st_item_add-mvgr3. "Mat Price group3
        st_bapi_itemsx-prc_group3 = c_x.     "Update flag for Price group1
      ENDIF.
      IF st_item_add-kdkg4 IS NOT INITIAL.
        st_bapi_items-cstcndgrp4 = st_item_add-kdkg4. "Customer price group4
        st_bapi_itemsx-cstcndgrp4 = c_x.     "Update flag for Customer group4
      ENDIF.
      IF st_item_add-kdkg5 IS NOT INITIAL.
        st_bapi_items-cstcndgrp5 = st_item_add-kdkg5. "Customer price group5
        st_bapi_itemsx-cstcndgrp5 = c_x.     "Update flag for Customer group5
      ENDIF.
    ENDLOOP.
    READ TABLE i_partner INTO st_partner WITH KEY item = st_item-item
                                           BINARY SEARCH.
    IF sy-subrc EQ 0 AND st_partner-ref_1_s IS NOT INITIAL.
      st_bapi_items-ref_1_s = st_partner-ref_1_s.
      st_bapi_itemsx-ref_1_s = c_x.
    ENDIF.
    st_bapi_items-itm_number = st_item-item.   "item
*--* This subroutine is used to check if material is BOM, if yes then
*--* Populates the next item number accordingly
*   PERFORM f_check_bom CHANGING st_item-item.
    st_bapi_items-po_itm_no  = st_item-poitem. "PO item
    st_bapi_items-target_qty = st_item-menge. "Qty
    st_bapi_items-item_categ = st_item-pstyv. "Item category
    APPEND st_bapi_items TO i_bapi_items.
    CLEAR st_bapi_items.
    READ TABLE i_item_date INTO st_item_date WITH KEY item = st_item-item
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF st_item_date-podate NE '00000000' AND st_item_date-podate NE '0'.
        st_bapi_items-purch_date = st_item_date-podate.
        st_bapi_itemsx-purch_date = c_x.
      ENDIF.
      IF st_item_date-billdate NE '00000000' AND st_item_date-billdate NE '0'.
        st_bapi_items-bill_date = st_item_date-billdate.
        st_bapi_itemsx-bill_date = c_x.
      ELSE.
        st_bapi_items-bill_date = sy-datum.
        st_bapi_itemsx-bill_date = c_x.
      ENDIF.
    ENDIF.
    st_bapi_itemsx-itm_number = st_item-item.. "Update flag for Item
    st_bapi_itemsx-po_itm_no  = c_x.     "Update flag for PO Item
    st_bapi_itemsx-target_qty = c_x.     "Update flag for target Qty
    st_bapi_itemsx-item_categ = c_x.     "Update flag for Item category

    APPEND st_bapi_itemsx TO i_bapi_itemsx.
    CLEAR st_bapi_itemsx.
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
FORM f_map_bapi_partners.
  LOOP AT i_partner INTO st_partner.
    st_bapi_partners-itm_number = st_partner-item.            "Item number
    st_bapi_partners-partn_role = st_partner-pf.              "Partner function
    st_bapi_partners-partn_numb = st_partner-partner.         "Partner
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
    IF st_partner-name1 IS NOT INITIAL.
      st_bapi_partners-name       = st_partner-name1.    "Name1
      st_bapi_partners-name_2     = st_partner-name2.    "Name2
      st_bapi_partners-street     = st_partner-street.   "Street
      st_bapi_partners-city       = st_partner-city.     "City
      st_bapi_partners-country    = st_partner-country.  "Country
      st_bapi_partners-region     = st_partner-region.   "Region
      st_bapi_partners-city       = st_partner-city.     "City
      st_bapi_partners-telephone  = st_partner-telephone.  "telephone
      st_bapi_partners-postl_code = st_partner-postl_code. "Postal Code
      st_bapi_partners-addr_link  =  iv_we_cnt + 1.        "Linkage b/w partner and Address
    ENDIF.
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
    APPEND st_bapi_partners TO i_bapi_partners.
    CLEAR st_bapi_partners.
*--BOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
    IF st_partner-str_suppl2 IS NOT INITIAL.
      st_bapi_address-name       = st_partner-name1.      "Name1
      st_bapi_address-name_2     = st_partner-name2.      "Name2
      st_bapi_address-langu      = sy-langu.              "Langu
      st_bapi_address-tel1_numbr = st_partner-telephone.  "telephone
      st_bapi_address-addr_no    = iv_we_cnt + 1.         "Linkage b/w partner and Address
      st_bapi_address-postl_cod1 = st_partner-postl_code. "Postal COde
      st_bapi_address-street     = st_partner-street.     "Street
      st_bapi_address-str_suppl2 = st_partner-str_suppl2. "Street3
      st_bapi_address-city       = st_partner-city.       "City
      st_bapi_address-country    = st_partner-country.    "country
      st_bapi_address-region     = st_partner-region.     "Region
      st_bapi_address-langu      = sy-langu.              "Langu
      APPEND st_bapi_address TO i_bapi_address.
    ENDIF.
    CLEAR:st_bapi_address.
*--EOC VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
*    st_bapi_address
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
FORM f_map_bapi_conditions.
  LOOP AT i_cond INTO st_cond.
    st_bapi_cond-itm_number = st_cond-item.              "Item number
    st_bapi_cond-cond_type = st_cond-kschl.                "condition type
*    st_bapi_cond-cond_value = st_cond-betrg .              "Price
    st_bapi_cond-condvalue = st_cond-betrg .              "Price
    st_bapi_cond-currency_2 = st_header-crcy.
    APPEND st_bapi_cond TO i_bapi_cond.
    CLEAR : st_bapi_cond.
    st_bapi_condx-itm_number = st_cond-item.              "Item number
    st_bapi_condx-cond_type = c_x.                "condition type
    st_bapi_condx-cond_value = c_x.              "Price
    st_bapi_condx-currency = c_x.
    APPEND st_bapi_condx TO i_bapi_condx.
    CLEAR : st_bapi_condx.
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
  DATA : lst_idoc_status  TYPE bdidocstat.     "Local work area
*----------------------------------------------------------------------*
*This FM is used to create Sales contracts
*----------------------------------------------------------------------*
  SORT i_bapi_items BY itm_number.
  CLEAR : v_doc.
  CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
    EXPORTING
      sales_header_in      = st_bapi_header   "Header structure
      sales_header_inx     = st_bapi_headerx  "Header Update flags
      business_object      = c_bus2034         "Business object
    IMPORTING
      salesdocument_ex     = v_doc            "return sales document
    TABLES
      return               = i_return         "return messages
      sales_items_in       = i_bapi_items     "Items
      sales_items_inx      = i_bapi_itemsx    "Update flags for Items
      sales_partners       = i_bapi_partners  "Partners
      sales_conditions_in  = i_bapi_cond      "Consitions
      sales_conditions_inx = i_bapi_condx     "Update flags for conditions
      sales_ccard          = i_bapi_card      "Credit card details
      sales_text           = i_bapi_text      "text
      sales_contract_in    = i_bapi_contract  "Additional info
      sales_contract_inx   = i_bapi_contractx "Update flags for Additional info
      partneraddresses     = i_bapi_address    "additonal Address details ++ VDPATABALL ED2K926316 OTCM-18549/44844 - Ship to address data fields
      extensionin          = i_bapi_ext.      "Custom fields
*----------------------------------------------------------------------*
* Build Log
*----------------------------------------------------------------------*
*--*Read the error message if any
  READ TABLE i_return INTO st_return WITH KEY type = c_e.
  IF sy-subrc NE 0.
*--*Read Abort message if any
    READ TABLE i_return INTO st_return WITH KEY type = c_a.
  ENDIF.
  IF sy-subrc EQ 0.
*--*If BAPI returns error or abort Rollback Transaction
*--* And build the Idoc status record with status 51
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    CLEAR lst_idoc_status.
    lst_idoc_status-docnum   = v_idoc.            "Idoc number
    lst_idoc_status-msgty    = st_return-type.    "Message type
    lst_idoc_status-msgid    = st_return-id.      "Message Id
    lst_idoc_status-msgv1 = st_return-message_v1.
    lst_idoc_status-msgv2 = st_return-message_v2.
    lst_idoc_status-msgv3 = st_return-message_v3.
    lst_idoc_status-msgv4 = st_return-message_v4.
    lst_idoc_status-msgno    = st_return-number.  "Message return num
    lst_idoc_status-status   = c_status_51.        "Status 51
    lst_idoc_status-repid    = sy-repid.           "Current Program name
    APPEND lst_idoc_status TO idoc_status.
  ELSE.
*--*If BAPI return no error then commit the transaction
*--* and build the Idoc status record with status 53.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = c_x.
    READ TABLE i_return INTO st_return WITH KEY type = c_s
                                         message_v2 = v_doc.
    IF sy-subrc EQ 0.
      lst_idoc_status-docnum   = v_idoc.             "Idoc num
      lst_idoc_status-msgty    = st_return-type.     "Return msg type
      lst_idoc_status-msgid    = st_return-id.       "Msg ID
      lst_idoc_status-msgno    = st_return-number.   "Msg num
      lst_idoc_status-msgv2  = st_return-message_v2. "Message variable 2
      lst_idoc_status-status   = c_status_53.         "Status 53
      lst_idoc_status-repid    = sy-repid.            "Current program name
      APPEND lst_idoc_status TO idoc_status.
    ENDIF.
  ENDIF.
*----------------------------------------------------------------------*
*Refresh and clear global variables passed to BAPI
*----------------------------------------------------------------------*
  REFRESH : i_return,i_bapi_items,i_bapi_itemsx,i_bapi_partners,i_bapi_cond,i_bapi_condx,
            i_bapi_card,i_bapi_text,i_bapi_contract,i_bapi_contractx,i_bapi_ext.
  CLEAR : st_bapi_header,st_bapi_headerx.

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
  IF st_header-cardnum IS NOT INITIAL.
    st_bapi_card-cc_type = st_header-cardtype.    "credit card type
    st_bapi_card-cc_number = st_header-cardnum.   "credit card number
    st_bapi_card-cc_name = st_header-cardname.    "credit card name
    st_bapi_card-cc_valid_t = st_header-expdate.  "expiry date
    APPEND st_bapi_card TO i_bapi_card.
    CLEAR st_bapi_card.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_text.
*--*Pass text data to BAPI structures
  LOOP AT i_text INTO st_text.
    IF st_text-item IS INITIAL.
      st_bapi_text-text_id = st_text-tdid.   "Text id
      st_bapi_text-langu = sy-langu.          "Language
      st_bapi_text-text_line = st_text-text. "Text
    ELSE.
*--* This subroutine is used to check if material is BOM, if yes then
*--* Populates the next item number accordingly
*      PERFORM f_check_bom CHANGING st_text-item.
      st_bapi_text-itm_number = st_text-item.           "Item number
      st_bapi_text-text_id = st_text-tdid.              "Text Id
      st_bapi_text-langu = sy-langu.                    "Language
      st_bapi_text-text_line = st_text-text.            "Text
    ENDIF.
    APPEND st_bapi_text TO i_bapi_text.
    CLEAR st_bapi_text.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BAPI_EXTENSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_bapi_extension.
  CONSTANTS:lc_bape_vbak  TYPE char9  VALUE 'BAPE_VBAK',  " Bape_vbak of type CHAR9
            lc_bape_vbap  TYPE char9  VALUE 'BAPE_VBAP',  " Bape_vbak of type CHAR9
            lc_posnr      TYPE posnr  VALUE '000000',     " Item number of the SD document
            lc_bape_vbakx TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
            lc_bape_vbapx TYPE char10 VALUE 'BAPE_VBAPX'. " Bape_vbak of type CHAR9
  DATA : lst_bape_vbak  TYPE bape_vbak,  " BAPI Interface for Customer Enhancements to Table VBAK
         lst_bape_vbap  TYPE bape_vbap,  " BAPI Interface for Customer Enhancements to Table VBAK
         lst_bape_vbapx TYPE bape_vbapx, " BAPI Interface for Customer Enhancements to Table VBAK
         lst_bape_vbakx TYPE bape_vbakx. " BAPI Interface for Customer Enhancements to Tab
*--*Pass Additional data B(custom fields_ to BAPI) Header
  lst_bape_vbak-zzlicyr = st_header-zzlicyr.
  st_bapi_ext-structure = lc_bape_vbak.
  st_bapi_ext+30(960)   = lst_bape_vbak.
  APPEND st_bapi_ext TO i_bapi_ext.
  CLEAR st_bapi_ext.
  lst_bape_vbakx-zzlicyr = c_x.
  st_bapi_ext-structure = lc_bape_vbakx.
  st_bapi_ext+30(960)   = lst_bape_vbakx.
  APPEND st_bapi_ext TO i_bapi_ext.
  CLEAR st_bapi_ext.
*--*Pass Additional data B(custom fields_ to BAPI) Item
  LOOP AT i_item_cust INTO st_item_cust.
    lst_bape_vbap-posnr = st_item_cust-vposn.              "Item number
    lst_bape_vbap-zzconstart  = st_item_cust-zzcontent_start_d.  "Content start date
    lst_bape_vbap-zzconend   = st_item_cust-zzcontent_end_d.     "Content end date
    lst_bape_vbap-zzlicstart = st_item_cust-zzlicense_start_d.   "License start date
    lst_bape_vbap-zzlicend = st_item_cust-zzlicense_end_d.       "License end date
    lst_bape_vbap-zzdealtyp = st_item_cust-zzdealtyp.            "Deal Type
    lst_bape_vbap-zzclustyp = st_item_cust-zzclustyp.            "Cluster Type
    st_bapi_ext-structure = lc_bape_vbap.   "BAPE_VBAP structure where custom fields are added
    st_bapi_ext+30(960)   = lst_bape_vbap.
    APPEND st_bapi_ext TO i_bapi_ext.
    CLEAR st_bapi_ext.
*
    lst_bape_vbapx-posnr = st_item_cust-vposn.            "Update flag for  Item
    lst_bape_vbapx-zzconstart  = c_x.                    "Update flag for Content start date
    lst_bape_vbapx-zzconend   = c_x.                     "Update flag for Content end date
    lst_bape_vbapx-zzlicstart = c_x.                     "Update flag License start date
    lst_bape_vbapx-zzlicend = c_x.                       "Update flag for License end date
    lst_bape_vbap-zzdealtyp = c_x.                       "Deal type
    lst_bape_vbap-zzclustyp = c_x.                       "Cluster type
    st_bapi_ext-structure = lc_bape_vbapx. "BAPE_VBAPX structure where custom fields are added
    st_bapi_ext+30(960)   = lst_bape_vbapx.
    APPEND st_bapi_ext TO i_bapi_ext.
    CLEAR st_bapi_ext.
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
FORM f_map_bapi_contract.
*--*Pass additional data to BAPAI
  LOOP AT i_item_cust INTO st_item_cust.
    st_bapi_contract-itm_number = st_item_cust-vposn.      "Item number
    st_bapi_contract-con_st_dat = st_item_cust-vbegdat.     "Contract start date
    st_bapi_contract-con_en_dat = st_item_cust-venddat.     "Contract end date
    APPEND st_bapi_contract TO i_bapi_contract.
    CLEAR st_bapi_contract.
    st_bapi_contractx-itm_number = st_item_cust-vposn."Update flag for Item
    st_bapi_contractx-con_st_dat = c_x.           "Update flag for contract start date
    st_bapi_contractx-con_en_dat = c_x.           "Update flag for contract  end date
    APPEND st_bapi_contractx TO i_bapi_contractx.
    CLEAR st_bapi_contractx.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_ITEM  text
*----------------------------------------------------------------------*
FORM f_check_bom  CHANGING  fp_lv_item TYPE posnr.
  DATA : li_stpo  TYPE STANDARD TABLE OF stpo_api02,  " Local Itab for BOM Items
         lv_plant TYPE csap_mbom-werks,               " Local Variable for Plant
         lv_count TYPE i.                             "Local Variable for Item count

  CONSTANTS :lc_usage TYPE csap_mbom-stlan VALUE '5'. "Local constant for BOM Usage
*--*Get Item data
  READ TABLE i_mat INTO st_mat WITH KEY item = fp_lv_item
                                        kdmat = ' '.
  IF sy-subrc EQ 0 AND st_mat-matnr IS NOT INITIAL.
*--*Fetch the plant associated with material in Material/Sales org/d.channel combination
    SELECT SINGLE dwerk FROM mvke INTO lv_plant WHERE matnr = st_mat-matnr
                                                 AND  vkorg = st_bapi_header-sales_org
                                                 AND  vtweg = st_bapi_header-distr_chan.
*--*Call FM to check whether the material is BOM associated or not
    IF sy-subrc EQ 0.
      CALL FUNCTION 'CSAP_MAT_BOM_READ'
        EXPORTING
          material  = st_mat-matnr
          plant     = lv_plant
          bom_usage = lc_usage
        TABLES
          t_stpo    = li_stpo
        EXCEPTIONS
          error     = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.
*--*If material is BOM then get the count of number of Items
*--*and populate next item number for BAPI
        DESCRIBE TABLE li_stpo LINES lv_count.
        lv_count = lv_count * 10.
        fp_lv_item = fp_lv_item + lv_count.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RELATION_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_relation_idoc .
  DATA : lst_obj_rola TYPE borident,
         lst_obj_rolb TYPE borident,
         lv_relation  TYPE breltyp-reltype VALUE 'IDC1',
         lv_logsys    TYPE tbdls-logsys.
  CONSTANTS : lc_idoc TYPE swo_objtyp VALUE 'IDOC',
              lc_obj  TYPE  swo_objtyp VALUE 'BUS2034'..
  IF v_doc IS NOT INITIAL. "Check if slaes document generated
*Getting the name of the current logical system we are working in:
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system = lv_logsys.
    IF sy-subrc EQ 0.
*Map Required data
      lst_obj_rola-objkey = v_idoc.
      lst_obj_rola-objtype = lc_idoc.
      lst_obj_rola-logsys = lv_logsys.
      lst_obj_rolb-objkey = v_doc.
      lst_obj_rolb-objtype = lc_obj.
      lst_obj_rolb-logsys = lv_logsys.
*Maintain Relation
      CALL FUNCTION 'BINARY_RELATION_CREATE'
        EXPORTING
          obj_rolea      = lst_obj_rola
          obj_roleb      = lst_obj_rolb
          relationtype   = lv_relation
        EXCEPTIONS
          no_model       = 1
          internal_error = 2
          unknown        = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ELSE.
        COMMIT WORK.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SHIPTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_shipto CHANGING fp_lv_error TYPE c.
  DATA : lst_idoc_status  TYPE bdidocstat. ""To build Idoc status
  SELECT SINGLE kunnr FROM knvv INTO @DATA(lv_ship_to)
                                 WHERE kunnr = @st_partner-partner
                                   AND vkorg = @st_header-sorg
                                   AND vtweg = @st_header-dch
                                   AND spart = @st_header-division.
  IF sy-subrc IS NOT INITIAL.
    "ship-to doesn't exist
    fp_lv_error = c_x.
    lst_idoc_status-docnum   = v_idoc.
    lst_idoc_status-msgty    = c_e.    "Message type
    lst_idoc_status-msgid    = 'ZQTC_R2'.      "Message Id
    lst_idoc_status-msgv1 = st_partner-partner.
    lst_idoc_status-msgv2 = st_header-sorg.
    lst_idoc_status-msgno    = '242'.  "Message return num
    lst_idoc_status-status   = c_status_51.        "Status 51
    lst_idoc_status-repid    = sy-repid.           "Current Program name
    APPEND lst_idoc_status TO idoc_status.
    CLEAR lst_idoc_status.
  ENDIF.
ENDFORM.
