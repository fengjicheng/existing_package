FUNCTION zqtc_order_process.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_HEADER) TYPE  ZQTCS_HEAD_APL
*"  TABLES
*"      I_ITEM TYPE  ZQTCT_ITEM_APL
*"  CHANGING
*"     VALUE(OUTPUT) TYPE  ZQTCS_OUTPUT_APL
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_out,
           row       TYPE i,
           matnr     TYPE matnr,
           kunnr     TYPE kunnr,
           auart     TYPE auart,
           vkorg     TYPE vkorg,
           vtweg     TYPE vtweg,
           spart     TYPE spart,
           menge     TYPE kwmeng,
           so        TYPE vbeln_va,
           delv      TYPE vbeln_vl,
           inv       TYPE vbeln_vf,
           comment   TYPE string,
           status(7) TYPE c,

         END OF ty_out.

  DATA ctumode LIKE ctu_params-dismode VALUE 'N'.
  DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
        wa_fieldcat TYPE slis_fieldcat_alv.

  DATA:i_so TYPE STANDARD TABLE OF bapidlvreftosalesorder,
       w_so TYPE bapidlvreftosalesorder.
  DATA:lv_delv  TYPE vbeln_vl,
       lv_num   TYPE vbnum,
       lv_price TYPE price,
       lv_posnr TYPE posnr.

  DATA: w_out TYPE zqtcs_output_apl.
  DATA: v_vbeln LIKE vbak-vbeln.

  DATA: header LIKE bapisdhd1.

  DATA: headerx LIKE bapisdhd1x.

  DATA: item LIKE bapisditm OCCURS 0 WITH HEADER LINE.

  DATA: itemx LIKE bapisditmx OCCURS 0 WITH HEADER LINE.

  DATA: partner LIKE bapiparnr OCCURS 0 WITH HEADER LINE.

  DATA: return LIKE bapiret2 OCCURS 0 WITH HEADER LINE.

  DATA: lt_schedules_inx TYPE STANDARD TABLE OF bapischdlx

  WITH HEADER LINE.
  DATA:lv_vbnum TYPE vbnum.
  DATA:lt_ditems TYPE TABLE OF bapidlvreftosalesorder.
  DATA:lw_ditems TYPE  bapidlvreftosalesorder.
  DATA: lt_schedules_in TYPE STANDARD TABLE OF bapischdl
  WITH HEADER LINE.

  DATA:lt_cond  TYPE STANDARD TABLE OF  bapicond.
  DATA:ls_cond  TYPE bapicond.

  DATA:lt_condx  TYPE STANDARD TABLE OF  bapicondx.
  DATA:ls_condx  TYPE bapicondx.

  DATA:lt_ccard TYPE TABLE OF bapiccard.
  DATA:ls_ccard TYPE  bapiccard.
  DATA: lv_noobd  TYPE flag.

  DATA:lv_error TYPE string.
  DATA:t_billdata TYPE TABLE OF bapivbrk,
       w_billdata TYPE bapivbrk,
       t_error    TYPE TABLE OF bapivbrkerrors,
       t_ret      TYPE TABLE OF bapiret1,
       t_success  TYPE TABLE OF bapivbrksuccess.

  DATA: p_auart TYPE auart .

  DATA: p_vkorg TYPE vkorg .

  DATA: p_vtweg TYPE vtweg .

  DATA: p_spart TYPE spart .
  DATA: p_sold TYPE kunnr .

  DATA: p_ship TYPE kunnr .

*header data
*    FREE:t_out[].
  FREE:lt_ccard[],partner[].
  CLEAR:header,lv_posnr.

  FREE:item[],
       itemx[],
       lt_schedules_in[],
       lt_schedules_inx[],
       lt_cond[],lt_condx[],
       partner[],
       lt_ccard[].

   SELECT SINGLE vbtyp FROM tvak INTO @DATA(lv_vbtyp) WHERE auart = @im_header-doc_type.
  LOOP AT i_item INTO DATA(ls_items).
    CLEAR:w_out,lv_noobd.
    lv_posnr = lv_posnr + 10.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = ls_items-product
      IMPORTING
        output       = ls_items-product
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_header-soldto
      IMPORTING
        output = w_out-soldto.

    w_out-doc_type     = im_header-doc_type    .
    w_out-sales_org    = im_header-sales_org   .
    w_out-dist_channel = im_header-dist_channel.
    w_out-division     = im_header-division    .


    header-doc_type = im_header-doc_type.

    headerx-doc_type = 'X'.

    header-sales_org = im_header-sales_org.

    headerx-sales_org = 'X'.

    header-distr_chan = im_header-dist_channel.

    headerx-distr_chan = 'X'.

    header-division = im_header-division.

    headerx-division = 'X'.

    headerx-updateflag = 'I'.

    IF im_header-ref_order IS NOT INITIAL.
      header-ref_doc = im_header-ref_order.
      header-ref_1 = im_header-ref_order.
      w_out-ref_order = im_header-ref_order.
      headerx-ref_doc = 'X'.
      headerx-ref_1 = 'X'.
      header-refdoc_cat = 'G'.
      headerx-refdoc_cat = 'X'.
    ENDIF.

    IF im_header-po_type IS NOT INITIAL.
      header-po_method = im_header-po_type.
      headerx-po_method = abap_true.
    ENDIF.
    IF im_header-subscr_type IS NOT INITIAL.
      header-po_supplem = im_header-subscr_type.
      headerx-po_supplem = abap_true.
    ENDIF.

    IF im_header-po_num IS NOT INITIAL.
      header-purch_no_c = im_header-po_num.
      headerx-purch_no_c = abap_true.
    ENDIF.

    IF im_header-payment_terms IS NOT INITIAL.
      header-pmnttrms = im_header-payment_terms.
      headerx-pmnttrms = abap_true.
    ENDIF.

*partner data

* Soldto
    partner-partn_role = 'AG'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_header-soldto
      IMPORTING
        output = partner-partn_numb.
    APPEND partner.

* Shipto
    partner-partn_role = 'WE'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_header-shipto
      IMPORTING
        output = partner-partn_numb.

    IF partner-partn_numb IS INITIAL OR im_header-doc_type = 'ZUNI' OR im_header-doc_type = 'ZSTU'.
      partner-partn_numb = im_header-soldto.
    ENDIF.
    APPEND partner.

* Billto
    IF im_header-billto IS NOT INITIAL.
      partner-partn_role = 'RE'.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = im_header-billto
        IMPORTING
          output = partner-partn_numb.

      APPEND partner.
    ELSE.
      IF im_header-doc_type = 'ZZOR' OR im_header-doc_type = 'ZZST'.
        partner-partn_role = 'RE'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = im_header-shipto
          IMPORTING
            output = partner-partn_numb.

        APPEND partner.
      ENDIF.
    ENDIF.

* Payer
    IF im_header-payer IS NOT INITIAL.
      partner-partn_role = 'RG'.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = im_header-payer
        IMPORTING
          output = partner-partn_numb.

      APPEND partner.
    ELSE.
      IF im_header-doc_type = 'ZZOR' OR im_header-doc_type = 'ZZST'.
        partner-partn_role = 'RG'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = im_header-shipto
          IMPORTING
            output = partner-partn_numb.

        APPEND partner.
      ENDIF.
    ENDIF.

*item data

    itemx-updateflag = 'I'.

    item-itm_number = lv_posnr.


    itemx-itm_number = lv_posnr.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = ls_items-product
      IMPORTING
        output       = item-material
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    itemx-material = 'X'.

    IF lv_vbtyp = 'G'.
      item-target_qty = ls_items-quantity.

      itemx-target_qty = 'X'.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = ls_items-uom
          language       = sy-langu
        IMPORTING
          output         = item-target_qu
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF item-target_qu IS INITIAL.
        item-target_qu = ls_items-uom.
      ENDIF.

      itemx-target_qu = 'X'.
    ENDIF.

    APPEND item.
    APPEND itemx.

*fill schedule lines

    lt_schedules_in-itm_number = lv_posnr.

    lt_schedules_in-sched_line = '0001'.

    lt_schedules_in-req_qty = ls_items-quantity.

    APPEND lt_schedules_in.

*fill schedule line flags

    lt_schedules_inx-itm_number = lv_posnr.

    lt_schedules_inx-sched_line = '0001'.

    lt_schedules_inx-req_qty = 'X'.

    APPEND lt_schedules_inx.

* Condition 1
    CLEAR:ls_cond.
    IF ls_items-cond_type IS NOT INITIAL.
      ls_cond-itm_number = lv_posnr.
      ls_cond-cond_type = ls_items-cond_type.
      IF ls_items-cond_type = 'ZSD1'.

        ls_cond-cond_value = ls_items-net_price .
      ELSE.
        ls_cond-cond_value = ls_items-net_price / 10.
      ENDIF.
      APPEND ls_cond TO lt_cond.
      CLEAR:ls_cond.

      CLEAR:ls_condx.
      ls_condx-itm_number = lv_posnr.
      ls_condx-cond_type = ls_items-cond_type.
      ls_condx-updateflag = abap_true.
      ls_condx-currency = abap_true.
      ls_condx-cond_value = abap_true.
      APPEND ls_condx TO lt_condx.
      CLEAR:ls_condx.
    ENDIF.

    IF ls_items-cond_type1 IS NOT INITIAL.
* Condition 2
      CLEAR:ls_cond.
      ls_cond-itm_number = lv_posnr.
      ls_cond-cond_type = ls_items-cond_type1.
      IF ls_items-cond_type1 = 'ZSD1'.

        ls_cond-cond_value = ls_items-net_price1 .
      ELSE.
        ls_cond-cond_value = ls_items-net_price1 / 10.
      ENDIF.
      APPEND ls_cond TO lt_cond.
      CLEAR:ls_cond.

      CLEAR:ls_condx.
      ls_condx-itm_number = lv_posnr.
      ls_condx-cond_type = ls_items-cond_type1.
      ls_condx-updateflag = abap_true.
      ls_condx-currency = abap_true.
      ls_condx-cond_value = abap_true.
      APPEND ls_condx TO lt_condx.
      CLEAR:ls_condx.
    ENDIF.

    IF ls_items-cond_type2 IS NOT INITIAL.
* Condition 3
      CLEAR:ls_cond.
      ls_cond-itm_number = lv_posnr.
      ls_cond-cond_type = ls_items-cond_type2.
      IF ls_items-cond_type2 = 'ZSD1'.

        ls_cond-cond_value = ls_items-net_price2 .
      ELSE.
        ls_cond-cond_value = ls_items-net_price2 / 10.
      ENDIF.
      APPEND ls_cond TO lt_cond.
      CLEAR:ls_cond.

      CLEAR:ls_condx.
      ls_condx-itm_number = lv_posnr.
      ls_condx-cond_type = ls_items-cond_type2.
      ls_condx-updateflag = abap_true.
      ls_condx-currency = abap_true.
      ls_condx-cond_value = abap_true.
      APPEND ls_condx TO lt_condx.
      CLEAR:ls_condx.
    ENDIF.
  ENDLOOP.

*CALL the bapi
  CLEAR:v_vbeln.
  FREE:return[].


  IF lv_vbtyp = 'G'.
    CALL FUNCTION 'BAPI_CONTRACT_CREATEFROMDATA'
      EXPORTING
*       SALESDOCUMENTIN         =
        contract_header_in      = header
        contract_header_inx     = headerx
*       SENDER                  =
*       BINARY_RELATIONSHIPTYPE = ' '
*       INT_NUMBER_ASSIGNMENT   = ' '
*       BEHAVE_WHEN_ERROR       = ' '
*       LOGIC_SWITCH            =
*       TESTRUN                 =
*       CONVERT                 = ' '
      IMPORTING
        salesdocument           = v_vbeln
      TABLES
        return                  = return
        contract_items_in       = item
        contract_items_inx      = itemx
        contract_partners       = partner
        contract_conditions_in  = lt_cond
        contract_conditions_inx = lt_condx.

  ELSE.
    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
*       SALESDOCUMENTIN      =
        order_header_in      = header
        order_header_inx     = headerx
      IMPORTING
        salesdocument        = v_vbeln
      TABLES
        return               = return
        order_items_in       = item
        order_items_inx      = itemx
        order_partners       = partner
        order_schedules_in   = lt_schedules_in
        order_schedules_inx  = lt_schedules_inx
        order_conditions_in  = lt_cond
        order_conditions_inx = lt_condx.
  ENDIF.
*CHECK the RETURN TABLE.
  CLEAR:lv_error.
  DATA:lv_row TYPE i.
  DATA:lv_tbx TYPE i.
  CLEAR:lv_row,lv_tbx.
  DATA:lv_pos TYPE posnr .

  LOOP AT return WHERE type = 'E' OR type = 'A'.
    lv_error = 'X'.
    w_out-status = 'Error'.

    IF w_out-message1 IS INITIAL.
      w_out-message1 = return-message.
    ELSEIF w_out-message2 IS INITIAL.
      w_out-message2 = return-message.
    ENDIF.

  ENDLOOP.

  IF v_vbeln IS INITIAL AND lv_error IS NOT INITIAL.
    FREE:item[],itemx[],lt_schedules_inx[],lt_schedules_in[],partner[],return[].

  ELSE.


    w_out-status = 'Success'.
    w_out-new_order = v_vbeln.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = w_out-new_order
      IMPORTING
        output = w_out-new_order.
    w_out-message1 = 'Sales Order Created Successfully'.

  ENDIF.
  w_out-new_order = v_vbeln.
  COMMIT WORK AND WAIT.


  FREE:item[],itemx[],lt_schedules_inx[],lt_schedules_in[],partner[],return[].
  CLEAR:header,headerx.

  CLEAR:output.
  output = w_out.
  CLEAR:w_out.
ENDFUNCTION.
