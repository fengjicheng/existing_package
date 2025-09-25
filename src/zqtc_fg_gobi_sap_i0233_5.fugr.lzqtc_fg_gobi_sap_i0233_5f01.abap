*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_IB_GOBI_ORDER_I0233_5                             *
* PROGRAM DESCRIPTION: This RFC will receive the request from GOBI     *
*          through     TIBCO, Once the request received in SAP it will *
*                      validate the data and send the overall response *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 20/12/2021                                          *
* OBJECT ID      : I0233.5                                             *
* TRANSPORT NUMBER(S): ED2K925270                                      *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v .

  FREE: ir_type,
        ir_idcodetype,
        ir_currencycode,
        ir_mstae,
        i_response,
        i_itemdetails,
        ir_header_priority,
        ir_item_priority.
  CLEAR: v_conditions_ex,
         v_buyerid,
         v_currencycode,
         v_doctype,
         v_salesorg,
         v_distchanl,
         v_division,
         v_pomethod,
         v_conditiontype,
         v_doccatog,
         v_errorcode,
         v_successcode,
         v_pricecode,
         v_itemcode,
         v_custcode,
         v_custholdcode,
         v_curencyercode,
         v_duplicode,
         v_geogracode,
         v_productcode,
         v_quantitycode,
         v_publishcode,
         v_purchasecode,
         v_slglogdays,
         v_header_priority,
         v_item_priority,
         v_allerrors.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  "Fetching Entries from Constant Table
  SELECT mandt
         devid
         param1
         param2
         srno
         sign
         opti
         low
         high
         activate
         description
         aenam
         aedat
    FROM zcaconstant
    INTO TABLE i_constant
   WHERE devid    EQ c_devid
     AND activate EQ abap_true.
  IF  sy-subrc     IS INITIAL
  AND i_constant   IS NOT INITIAL.
    LOOP AT i_constant
      INTO DATA(wa_constant).
      CASE: wa_constant-param1.
        WHEN: c_buyerid.
          v_buyerid   = wa_constant-low.
        WHEN: c_partnertype.
          v_type-sign   = c_i.
          v_type-option = c_eq.
          v_type-low    = wa_constant-low.
          APPEND v_type TO ir_type.
          CLEAR v_type.
        WHEN: c_idcodetype.
          v_idcodetype-sign   = c_i.
          v_idcodetype-option = c_eq.
          v_idcodetype-low    = wa_constant-low.
          APPEND v_idcodetype TO ir_idcodetype.
          CLEAR v_idcodetype.
        WHEN: c_currencycode.
          v_currencycode-sign   = c_i.
          v_currencycode-option = c_eq.
          v_currencycode-low    = wa_constant-low.
          APPEND v_currencycode TO ir_currencycode.
          CLEAR v_currencycode.
        WHEN: c_purchseoption.
          v_purchaseoption-sign   = c_i.
          v_purchaseoption-option = c_eq.
          v_purchaseoption-low    = wa_constant-low.
          APPEND v_purchaseoption TO ir_purchaseoption.
          CLEAR v_purchaseoption.
        WHEN c_mstae.
          v_mstae-sign   = c_i.
          v_mstae-option = c_eq.
          v_mstae-low    = wa_constant-low.
          APPEND v_mstae TO ir_mstae.
          CLEAR v_mstae.
        WHEN: c_headerpriority.
          v_header_priority-sign   = c_i.
          v_header_priority-option = c_eq.
          v_header_priority-low    = wa_constant-low.
          APPEND v_header_priority TO ir_header_priority.
          CLEAR v_header_priority.
        WHEN: c_itempriority.
          v_item_priority-sign   = c_i.
          v_item_priority-option = c_eq.
          v_item_priority-low    = wa_constant-low.
          APPEND v_item_priority TO ir_item_priority.
          CLEAR v_item_priority.
        WHEN: c_allerrors.
          v_allerrors = wa_constant-low.
        WHEN: c_conditiontype.
          v_conditiontype = wa_constant-low.
        WHEN: c_doctype.
          v_doctype = wa_constant-low.
        WHEN: c_salesorg.
          v_salesorg = wa_constant-low.
        WHEN: c_distchanl.
          v_distchanl = wa_constant-low.
        WHEN: c_division.
          v_division  = wa_constant-low.
        WHEN: c_pomethod.
          v_pomethod = wa_constant-low.
        WHEN: c_doccatog.
          v_doccatog = wa_constant-low.
        WHEN: c_errorcode.
          v_errorcode = wa_constant-low.
        WHEN: c_successcode.
          v_successcode = wa_constant-low.
        WHEN: c_successcode1.
          v_successcode1 = wa_constant-low.
        WHEN: c_pricecode.
          v_pricecode     = wa_constant-low.
        WHEN: c_itemcode.
          v_itemcode      = wa_constant-low.
        WHEN: c_custcode.
          v_custcode      = wa_constant-low.
        WHEN: c_custholdcode.
          v_custholdcode  = wa_constant-low.
        WHEN: c_currencyercode.
          v_curencyercode   = wa_constant-low.
        WHEN: c_duplicode.
          v_duplicode     = wa_constant-low.
        WHEN: c_geogracode.
          v_geogracode    = wa_constant-low.
        WHEN: c_productcode.
          v_productcode   = wa_constant-low.
        WHEN: c_quantitycode.
          v_quantitycode  = wa_constant-low.
        WHEN: c_publishcode.
          v_publishcode   = wa_constant-low.
        WHEN: c_purchasecode.
          v_purchasecode  = wa_constant-low.
        WHEN: c_obsletecode.
          v_obsletecode = wa_constant-low.
        WHEN: c_slglogdays.
          v_slglogdays  = wa_constant-low.
        WHEN: OTHERS.
          "Do Nothing
      ENDCASE.
    ENDLOOP.
  ENDIF.
  SORT ir_currencycode
    BY low.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_SOLD_TO_SHIP_VALI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_sold_to_ship_vali USING im_buyerid
                                     im_customerid
                               CHANGING i_respone.
  FREE i_respone.
  " Fetching Sold To Partner
  CONCATENATE c_01
              v_buyerid
         INTO DATA(lv_buyerid).
  " Validation of Customer  ID from GOBI Request."
  " Customer ID will be validated from BUT0ID table based on TYPE and Partner
  " fields, if entry not present then RFC will through an error as response to GOBI
  CONCATENATE c_01
              im_customerid
         INTO DATA(lv_customer).
  SELECT partner,
         type,
         idnumber
    FROM but0id
    INTO TABLE @DATA(li_customer_buyer)
   WHERE type     IN @ir_type
     AND ( idnumber EQ @lv_customer
      OR   idnumber EQ @im_customerid
      OR   idnumber EQ @lv_buyerid ).
  IF  sy-subrc IS INITIAL
  AND li_customer_buyer IS NOT INITIAL.
    SORT li_customer_buyer
      BY partner.
    CLEAR: v_shipto,
           v_soldto.
    LOOP AT li_customer_buyer
      ASSIGNING FIELD-SYMBOL(<fs_cus_buyer>).
      CASE: <fs_cus_buyer>-idnumber.
        WHEN: lv_customer.
          v_shipto = <fs_cus_buyer>-partner.
        WHEN: lv_buyerid.
          v_soldto = <fs_cus_buyer>-partner.
        WHEN: im_customerid.
          v_shipto = <fs_cus_buyer>-partner.
        WHEN: OTHERS.
          "Do Nothing.
      ENDCASE.
      IF  v_shipto IS NOT INITIAL
      AND v_soldto  IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
    "Validation of Customer blocks from table KNA1
    SELECT SINGLE
           kunnr,
           faksd,
           lifsd
      FROM kna1
      INTO @DATA(lv_cust_blocks)
     WHERE kunnr = @v_shipto.
    IF  sy-subrc IS INITIAL
    AND ( lv_cust_blocks-faksd IS NOT INITIAL
     OR   lv_cust_blocks-lifsd IS NOT INITIAL ).
      LOOP AT i_itemdetails
        ASSIGNING FIELD-SYMBOL(<lfs_itemdetails>).
        CLEAR v_response.
        v_response-lineid          = <lfs_itemdetails>-lineid.
        v_response-productid       = <lfs_itemdetails>-productid.
        v_response-quantity        = <lfs_itemdetails>-quantity.
        v_response-listprice       = <lfs_itemdetails>-listprice.
        v_response-currencycode    = <lfs_itemdetails>-currencycode.
        v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
        v_response-status          = v_errorcode.
        v_response-statuscode      = v_custholdcode.
        APPEND v_response TO i_response.
        CLEAR v_response.
      ENDLOOP.
    ENDIF.
  ENDIF.
  "If ship to does not exist
  IF v_shipto  IS INITIAL.
    CLEAR v_response.
    UNASSIGN <lfs_itemdetails>.
    LOOP AT i_itemdetails
      ASSIGNING <lfs_itemdetails>.
      CLEAR v_response.
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_custcode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PURCHASE_DOCU
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_purchase_docu USING im_purchaseordernumber.
  "Validating Purchase order Numbers from VBKD, if entry presents in VBKD
  "then it's duplicate PO
  SELECT SINGLE                                         "#EC CI_NOFIELD
         vbeln,
         posnr,
         bstkd
    FROM vbkd
    INTO @DATA(lv_vbkd)
   WHERE vbeln IS NOT NULL
     AND bstkd EQ @im_purchaseordernumber.
  IF  sy-subrc  IS INITIAL
  AND lv_vbkd   IS NOT INITIAL.
    LOOP AT i_itemdetails
      ASSIGNING FIELD-SYMBOL(<lfs_itemdetails>).
      CLEAR v_response.
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_duplicode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_HEADER_ITEM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepare_header_item_data .
  IF i_itemdetails[] IS NOT INITIAL.
    SELECT a~matnr,
           a~idcodetype,
           a~identcode,
           b~mstae,
           b~ismpubldate
      FROM jptidcdassign AS a
      INNER JOIN mara AS b
         ON a~matnr = b~matnr
      INTO TABLE @DATA(li_product)
       FOR ALL ENTRIES IN @i_itemdetails
      WHERE a~idcodetype  IN @ir_idcodetype
        AND a~identcode EQ @i_itemdetails-productid.
    IF  sy-subrc    IS INITIAL
    AND li_product IS NOT INITIAL.
      SORT li_product
        BY matnr.
    ENDIF.
  ENDIF.
  "Filling HEader Data.
  CLEAR v_header_in.
  v_header_in-doc_type    = v_doctype.
  v_header_in-sales_org   = v_salesorg.
  v_header_in-distr_chan  = v_distchanl.
  v_header_in-division    = v_division.
  v_header_in-po_method   = v_pomethod.
  v_header_in-sd_doc_cat  = v_doccatog.
  "Validating  Header Data.
  "Filling Items Details
  FREE i_items_in.
  LOOP AT i_itemdetails
    ASSIGNING FIELD-SYMBOL(<lfs_itemdetails>).
    v_items_in-itm_number = <lfs_itemdetails>-lineid.
    v_items_in-target_qty   = <lfs_itemdetails>-quantity.
    v_items_in-curr_iso = <lfs_itemdetails>-currencycode.
    DATA(lv_quantity) = <lfs_itemdetails>-quantity.
    <lfs_itemdetails>-quantity =  |{ <lfs_itemdetails>-quantity ALPHA = IN }|.
    IF <lfs_itemdetails>-quantity CO '0123456789'.
      DATA(lv_check) = 'X'.
    ENDIF.
    IF ( <lfs_itemdetails>-quantity IS INITIAL
    OR  <lfs_itemdetails>-quantity EQ '000' ).
      CLEAR lv_check.
    ENDIF.
    <lfs_itemdetails>-quantity = lv_quantity.
    CLEAR lv_quantity.
    IF lv_check IS INITIAL
    OR <lfs_itemdetails>-quantity GT '1'.
      CLEAR v_response.
      "Validating quantity is Nuemric or not
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_quantitycode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDIF.
    "IF purchase option NOT in scope
    IF <lfs_itemdetails>-purchaseoption NOT IN ir_purchaseoption.
      CLEAR v_response.
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_purchasecode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDIF.
    "Checking if product has publication date or not
    READ TABLE li_product
        ASSIGNING FIELD-SYMBOL(<lfs_product>)
        WITH KEY identcode = <lfs_itemdetails>-productid
        BINARY SEARCH.
    IF  sy-subrc IS  INITIAL
    AND <lfs_product> IS ASSIGNED.
      IF  <lfs_product>-ismpubldate IS INITIAL.
        CLEAR v_response.
        v_response-lineid          = <lfs_itemdetails>-lineid.
        v_response-productid       = <lfs_itemdetails>-productid.
        v_response-quantity        = <lfs_itemdetails>-quantity.
        v_response-listprice       = <lfs_itemdetails>-listprice.
        v_response-currencycode    = <lfs_itemdetails>-currencycode.
        v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
        v_response-status          = v_errorcode.
        v_response-statuscode      = v_publishcode.
        APPEND v_response TO i_response.
        CLEAR v_response.
      ELSEIF <lfs_product>-ismpubldate IS NOT INITIAL.
        v_items_in-material = <lfs_product>-matnr.
      ENDIF.
      "Checking whether material is obslete or not
      IF <lfs_product>-mstae IN ir_mstae.
        CLEAR v_response.
        v_response-lineid          = <lfs_itemdetails>-lineid.
        v_response-productid       = <lfs_itemdetails>-productid.
        v_response-quantity        = <lfs_itemdetails>-quantity.
        v_response-listprice       = <lfs_itemdetails>-listprice.
        v_response-currencycode    = <lfs_itemdetails>-currencycode.
        v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
        v_response-status          = v_errorcode.
        v_response-statuscode      = v_obsletecode.
        APPEND v_response TO i_response.
        CLEAR v_response.
      ENDIF.
    ELSEIF sy-subrc IS NOT INITIAL
    AND    <lfs_product> IS NOT ASSIGNED.
      "Validating each item details.
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_productcode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDIF.
    "Checking Currency validation
    UNASSIGN <lfs_product>.
    READ TABLE ir_currencycode
      ASSIGNING FIELD-SYMBOL(<lfs_currency>)
      WITH KEY low = <lfs_itemdetails>-currencycode
      BINARY SEARCH.
    IF  sy-subrc           IS NOT INITIAL
    AND <lfs_currency>-low IS NOT ASSIGNED.
      CLEAR v_response.
      "Validating each item details.
      v_response-lineid          = <lfs_itemdetails>-lineid.
      v_response-productid       = <lfs_itemdetails>-productid.
      v_response-quantity        = <lfs_itemdetails>-quantity.
      v_response-listprice       = <lfs_itemdetails>-listprice.
      v_response-currencycode    = <lfs_itemdetails>-currencycode.
      v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
      v_response-status          = v_errorcode.
      v_response-statuscode      = v_curencyercode.
      APPEND v_response TO i_response.
      CLEAR v_response.
    ENDIF.
    APPEND v_items_in TO i_items_in.
    CLEAR: v_items_in,
           lv_check.
    UNASSIGN <lfs_currency>.
  ENDLOOP.
  FREE i_partner.
  v_partner-partn_role = c_ag.
  v_partner-partn_numb = v_soldto.
  APPEND v_partner TO i_partner.
  CLEAR v_partner.
  " Passing Partners.
  v_partner-partn_role = c_we.
  v_partner-partn_numb = v_shipto.
  APPEND v_partner TO i_partner.
  CLEAR v_partner.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BAPI_SIMULATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bapi_simulate .
  CLEAR: v_partner,
         v_sold,
         v_ship,
         v_bill,
         v_return.
  FREE i_conditions_ex.
  "Before passing to BAPI checking whether any line item as any error.
  LOOP AT i_response
    ASSIGNING FIELD-SYMBOL(<fs_response>)
    WHERE status     EQ v_errorcode
      AND statuscode IS NOT INITIAL.
    DELETE i_items_in
      WHERE itm_number EQ <fs_response>-lineid.
    IF sy-subrc IS INITIAL.
      "Do Nothing
    ENDIF.
  ENDLOOP.
  IF i_items_in[] IS NOT INITIAL.
    "Passing all values to BAPI Simulate order to validate further
    CALL FUNCTION 'BAPI_SALESORDER_SIMULATE'
      EXPORTING
        order_header_in    = v_header_in
      IMPORTING
        sold_to_party      = v_sold
        ship_to_party      = v_ship
        billing_party      = v_bill
        return             = v_return
      TABLES
        order_items_in     = i_items_in
        order_partners     = i_partner
        order_condition_ex = i_conditions_ex
      EXCEPTIONS
        system_failure     = 1000
        OTHERS             = 1002.
    IF  sy-subrc IS INITIAL
    AND i_conditions_ex[] IS NOT INITIAL.
      "Calculating Discount percentage and Discount amount
      SORT i_conditions_ex
        BY itm_number
           cond_type.
      SORT i_response
        BY lineid
           status.
      LOOP AT i_itemdetails
        ASSIGNING FIELD-SYMBOL(<lfs_itemdetails>).
        READ TABLE i_conditions_ex
          ASSIGNING FIELD-SYMBOL(<lfs_conditions>)
          WITH KEY itm_number = <lfs_itemdetails>-lineid
                   cond_type  = v_conditiontype
                   BINARY SEARCH.
        IF  sy-subrc IS INITIAL
        AND <lfs_conditions> IS  ASSIGNED.
          v_response-discountpercent = <lfs_conditions>-cond_value.
          v_response-discountamount = <lfs_itemdetails>-listprice * ( v_response-discountpercent / 100 ).
          v_response-cost = <lfs_itemdetails>-listprice + v_response-discountamount.
        ELSEIF sy-subrc IS NOT INITIAL
        AND    <lfs_conditions> IS NOT ASSIGNED.
          "Do Nothing
        ENDIF.
        "Validating each item details.
        v_response-lineid          = <lfs_itemdetails>-lineid.
        v_response-productid       = <lfs_itemdetails>-productid.
        v_response-quantity        = <lfs_itemdetails>-quantity.
        v_response-listprice       = <lfs_itemdetails>-listprice.
        v_response-currencycode    = <lfs_itemdetails>-currencycode.
        v_response-purchaseoption  = <lfs_itemdetails>-purchaseoption.
        UNASSIGN <fs_response>.
        READ TABLE i_response
          ASSIGNING <fs_response>
          WITH KEY lineid = <lfs_itemdetails>-lineid
                   status = v_errorcode BINARY SEARCH.
        IF  sy-subrc IS NOT INITIAL
        AND <fs_response> IS  NOT ASSIGNED.
          v_response-status          = v_successcode.
          v_response-statuscode      = v_successcode1.
          APPEND v_response TO i_response.
          CLEAR v_response.
        ELSEIF  sy-subrc IS INITIAL
        AND <fs_response> IS ASSIGNED.
          "Do Nothing
        ENDIF.
      ENDLOOP.
    ELSEIF i_conditions_ex[] IS INITIAL.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_INPUT_LOGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_input_logs USING im_guid im_buyerid
                               im_ordertype im_customerid
                               im_purchaseordernumber
                                im_source.
  "External Number
  CONCATENATE im_guid
              '/'
              im_purchaseordernumber
         INTO DATA(lv_externalnumber)
       SEPARATED BY space.
  "Creating the logs
  v_days = v_slglogdays.
  v_date = sy-datum + v_days.
*   define some header data of this log
  v_log-object     = c_object.
  v_log-subobject  = c_subobj.
  v_log-aldate     = sy-datum.
  v_log-altime     = sy-uzeit.
  v_log-aluser     = sy-uname.
  v_log-alprog     = sy-repid.
  v_log-aldate_del = v_date.
  v_log-extnumber  = lv_externalnumber.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = v_log
    IMPORTING
      e_log_handle            = v_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
  " Adding the logs.
  " Message logs
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  v_msg-msgv1 =  text-001.
  PERFORM f_add_msg_log.
  "Input paramter Buyer ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-002
              im_buyerid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Input paramter Order Type
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-003
              im_ordertype
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Input paramter Customer ID
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-004
              im_customerid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Input paramter Purchase Order Number
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-005
              im_purchaseordernumber
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Input paramter SOurce ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-006
              im_source
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Input paramter GUI ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-007
              im_guid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Item Detail    CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  v_msg-msgv1 = text-008.
  PERFORM f_add_msg_log.

  LOOP AT i_itemdetails
    ASSIGNING FIELD-SYMBOL(<lfs_itemdetails>).
    "Line ID
    CLEAR v_msg.
    v_msg-msgty     = c_msgtyp.
    v_msg-msgid     = c_msgid.
    v_msg-msgno     = c_msgno.
    CONCATENATE text-009
                <lfs_itemdetails>-lineid
           INTO DATA(v_intext1).
    "Product ID
    CONCATENATE text-010
                <lfs_itemdetails>-productid
           INTO DATA(v_intext2).
    "Quantity
    CONCATENATE text-011
                <lfs_itemdetails>-quantity
                  INTO DATA(v_intext3).
    "List Price
    v_price = <lfs_itemdetails>-listprice.
    CONDENSE v_price.
    CONCATENATE text-012
                v_price
                    INTO DATA(v_intext4).
    "Currency Code
    CONCATENATE text-013
                <lfs_itemdetails>-currencycode
           INTO DATA(v_intext5).
    "Purchase Option
    CONCATENATE text-014
                <lfs_itemdetails>-purchaseoption
                  INTO DATA(v_intext6).
    CONCATENATE v_intext1
                v_intext2
           INTO v_msg-msgv1
        SEPARATED BY c_sep.
    CONCATENATE v_intext3
                v_intext4
           INTO v_msg-msgv2
        SEPARATED BY c_sep.
    CLEAR v_input_text.
    CONCATENATE v_intext1
                v_intext2
                v_intext3
                v_intext4
                v_intext5
                v_intext6
            INTO v_input_text
        SEPARATED BY c_sep.
    DATA(lv_fval) = strlen( v_input_text ).
    IF lv_fval LE 50.
      v_msg-msgv1 = v_input_text.
    ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
      v_msg-msgv1 = v_input_text+0(50).
      v_msg-msgv2 = v_input_text+50(50).
    ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
      v_msg-msgv1 = v_input_text+0(50).
      v_msg-msgv2 = v_input_text+50(50).
      v_msg-msgv3 = v_input_text+100(50).
    ELSE. " ELSE -> IF lv_fval LE 50
      v_msg-msgv1 = v_input_text+0(50).
      v_msg-msgv2 = v_input_text+50(50).
      v_msg-msgv3 = v_input_text+100(50).
      v_msg-msgv4 = v_input_text+150(50).
    ENDIF. " IF lv_fval LE 50
    PERFORM f_add_msg_log.
    CLEAR v_msg.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_OUTPUT_LOGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_output_logs USING im_guid im_buyerid
                               im_ordertype im_customerid
                               im_purchaseordernumber
                                im_source
                          CHANGING ex_status.
  DATA lv_fval TYPE i.
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  v_msg-msgv1 = text-015.
  PERFORM f_add_msg_log.
  "Output paramter Buyer ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-002
              im_buyerid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Output paramter Order Type
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-003
              im_ordertype
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Output paramter Customer ID
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-004
              im_customerid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Output paramter Purchase Order Number
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-005
              im_purchaseordernumber
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Output paramter SOurce ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-006
              im_source
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Output paramter GUI ID
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-007
              im_guid
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  "Response from SAP, After validation    CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  v_msg-msgv1 = text-016.
  PERFORM f_add_msg_log.

  LOOP AT i_response
    ASSIGNING FIELD-SYMBOL(<lfs_response>).
    "Line ID
    CLEAR v_msg.
    v_msg-msgty     = c_msgtyp.
    v_msg-msgid     = c_msgid.
    v_msg-msgno     = c_msgno.
    CONCATENATE text-009
                <lfs_response>-lineid
           INTO DATA(v_outtext1).
    "Status.
    CONCATENATE text-017
                <lfs_response>-status
           INTO DATA(v_outtext2).
    "Status Code
    CONCATENATE text-018
                <lfs_response>-statuscode
           INTO DATA(v_outtext3).
    CLEAR v_constant.
    READ TABLE i_constant
      INTO v_constant
      WITH KEY low = <lfs_response>-statuscode.
    IF  sy-subrc    IS INITIAL
    AND v_constant IS NOT INITIAL.
      CONCATENATE text-025
         v_constant-description
         INTO DATA(v_outtext4).
    ENDIF.
    "Discount Percentage
    CONDENSE v_price.
    CONCATENATE text-019
                v_price
                  INTO DATA(v_outtext9).
    CLEAR v_price.
    v_price = <lfs_response>-discountamount.
    "Discount Amount
    CONDENSE v_price.
    CONCATENATE text-020
                 v_price
                  INTO DATA(v_outtext10).
    CLEAR v_price.
    "Cost
    v_price = <lfs_response>-cost.
    CONDENSE v_price.
    CONCATENATE text-021
                v_price
                  INTO DATA(v_outtext11).
    CLEAR v_price.
    CONCATENATE v_outtext1
                v_outtext2
                v_outtext3
                v_outtext4
                v_outtext9
                v_outtext10
                v_outtext11
           INTO v_output_text
        SEPARATED BY c_sep.
    CLEAR lv_fval.
    lv_fval = strlen( v_output_text ).
    IF lv_fval LE 50.
      v_msg-msgv1 = v_output_text.
    ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
      v_msg-msgv1 = v_output_text+0(50).
      v_msg-msgv2 = v_output_text+50(50).
    ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
      v_msg-msgv1 = v_output_text+0(50).
      v_msg-msgv2 = v_output_text+50(50).
      v_msg-msgv3 = v_output_text+100(50).
    ELSE. " ELSE -> IF lv_fval LE 50
      v_msg-msgv1 = v_output_text+0(50).
      v_msg-msgv2 = v_output_text+50(50).
      v_msg-msgv3 = v_output_text+100(50).
      v_msg-msgv4 = v_output_text+150(50).
    ENDIF. " IF lv_fval LE 50
    PERFORM f_add_msg_log.
    CLEAR v_msg.
  ENDLOOP.
  " Overall status
  UNASSIGN <lfs_response>.
  READ TABLE i_response
    ASSIGNING <lfs_response>
    WITH KEY   status = v_errorcode.
  IF  sy-subrc IS INITIAL
  AND <lfs_response> IS ASSIGNED.
    ex_status = text-023.
  ELSEIF sy-subrc IS NOT INITIAL
  AND <lfs_response> IS NOT ASSIGNED.
    ex_status = text-022.
  ENDIF.
  "Over all Statu Log
  CLEAR v_msg.
  v_msg-msgty     = c_msgtyp.
  v_msg-msgid     = c_msgid.
  v_msg-msgno     = c_msgno.
  CONCATENATE text-024
              ex_status
         INTO v_msg-msgv1.
  PERFORM f_add_msg_log.
  CLEAR v_msg.
*  Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE' ##FM_SUBRC_OK
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.

  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MSG_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_add_msg_log .
  " Adding messages.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = v_log_handle
      i_s_msg          = v_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ERROR_PRIORITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_error_priority .
  IF v_allerrors IS NOT INITIAL.
    SORT i_response
      BY lineid.
  ELSEIF v_allerrors IS INITIAL.
    "Arranging the header errors as per priority
    LOOP AT ir_header_priority
      ASSIGNING FIELD-SYMBOL(<fs_head>).
      READ TABLE i_response
        ASSIGNING FIELD-SYMBOL(<fs_response>)
        WITH KEY statuscode = <fs_head>-low
        BINARY SEARCH.
      IF  sy-subrc IS INITIAL
      AND <fs_response> IS ASSIGNED.
        DELETE i_response
          WHERE statuscode NE <fs_response>-statuscode.
        IF sy-subrc IS INITIAL.
          "Do Nothing
        ENDIF.
      ELSEIF sy-subrc IS NOT INITIAL
      AND  <fs_response> IS NOT ASSIGNED.
        "Do Nothing
      ENDIF.
      UNASSIGN <fs_response>.
    ENDLOOP.
    "Arranging the item errors as per priority
    LOOP AT ir_item_priority
      ASSIGNING FIELD-SYMBOL(<fs_item>).
      UNASSIGN <fs_response>.
      LOOP AT i_response   "#EC CI_NESTED
        ASSIGNING <fs_response>
        WHERE statuscode EQ <fs_item>-low.
        "Deleting other non priority errors
        DELETE i_response
          WHERE lineid EQ <fs_response>-lineid
            AND statuscode NE <fs_response>-statuscode.
        IF sy-subrc IS INITIAL.
          "Do Nothing
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDIF.
ENDFORM.
