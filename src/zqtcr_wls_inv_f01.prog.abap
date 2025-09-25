*&---------------------------------------------------------------------*
*&  Include        ZQTCR_WLS_INV_F01
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_WLS_INV_F01
* PROGRAM DESCRIPTION: wls Invoice & Credit Memo Forms
* DEVELOPER: AMOHAMMED
* CREATION DATE: 05/14/2020
* OBJECT ID: F061
* TRANSPORT NUMBER(S): ED1K910387
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_INV_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing_inv_form CHANGING fp_v_returncode TYPE sysubrc.
*- Clear data
  PERFORM f_get_clear.

*- determine print data
  PERFORM f_set_print_data_to_read.

*- select print data
  PERFORM f_get_data.

*- Build header and item structur for Adobe form
  PERFORM f_build_hdr_itm_for_form.

  v_formname = c_form_name.

* Perform has been used to send mail with an attachment of PDF
  IF v_ent_screen  EQ abap_false.
    IF nast-nacha = c_5. " Email Function
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ENDIF.
*- Perform has been used to print preview
  ELSE.
    PERFORM  f_populate_layout USING v_formname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  CONSTANTS : lc_id     TYPE rstxt-tdid     VALUE '0001',       " Material Sales Text
              lc_object TYPE rstxt-tdobject VALUE 'MVKE'.       " Material texts, sales
  DATA : li_tline           TYPE TABLE OF tline,                " Material Sales Text
         lv_sal_mat_text    TYPE string,                        " Material Sales Text
         lv_name            TYPE thead-tdname,                  " Name
         lst_serial_numbers TYPE zstqtc_wls_srl_num_f061.       " Work area

  IF nast-objky+10 NE space.
    nast-objky = nast-objky+16(10).
  ENDIF.
  v_output_typ = nast-kschl.

*- Read print data
  CALL FUNCTION 'LB_BIL_INV_OUTP_READ_PRTDATA'
    EXPORTING
      if_bil_number         = nast-objky
      if_parvw              = nast-parvw
      if_parnr              = nast-parnr
      if_language           = nast-spras
      is_print_data_to_read = li_print_data_to_read
    IMPORTING
      es_bil_invoice        = li_bil_invoice
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
*-  error handling
    v_ent_retco = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF.
  IF li_bil_invoice-it_gen[] IS NOT INITIAL.
*- Material Description
    SELECT matnr maktx
      FROM makt
      INTO TABLE li_makt
      FOR ALL ENTRIES IN li_bil_invoice-it_gen
      WHERE matnr = li_bil_invoice-it_gen-material.
    IF sy-subrc EQ 0.
      SORT li_makt BY matnr.
    ENDIF.
*- Material Description
    SELECT matnr mtpos
      FROM mvke
      INTO TABLE li_mvke
      FOR ALL ENTRIES IN li_bil_invoice-it_gen
      WHERE matnr = li_bil_invoice-it_gen-material.
    IF sy-subrc EQ 0.
      SORT li_mvke BY matnr.
    ENDIF.
  ENDIF.

  v_bill_date = li_bil_invoice-hd_gen-bil_date.
*- Fetch Reference Currency of the Exchange Rate
  SELECT SINGLE bwaer
           FROM tcurv
           INTO v_ref_curr
           WHERE kurst = c_excrate_typ_m.

  IF li_bil_invoice-hd_part_add[] IS NOT INITIAL.
*- Partner Number
    SELECT kunnr adrnr stceg
      FROM kna1
      INTO TABLE li_kna1
      FOR ALL ENTRIES IN li_bil_invoice-hd_part_add
      WHERE kunnr = li_bil_invoice-hd_part_add-partn_numb.
    IF li_kna1[] IS NOT INITIAL.
*- Customer Address detailes
      SELECT addrnumber name1 name_co city1
             post_code1 street region country
        FROM adrc
        INTO TABLE li_adrc_part
        FOR ALL ENTRIES IN li_kna1
        WHERE addrnumber = li_kna1-adrnr.
      IF sy-subrc EQ 0.
        SORT li_adrc_part BY addrnumber.
      ENDIF.
    ENDIF.
  ENDIF.

  IF li_bil_invoice-it_gen[] IS NOT INITIAL.
*- Release order usage ID: Texts
    SELECT spras abrvw bezei
      FROM tvlvt
      INTO TABLE li_tvlvt
      FOR ALL ENTRIES IN li_bil_invoice-it_gen
      WHERE abrvw = li_bil_invoice-it_gen-vkaus.
    IF sy-subrc EQ 0.
      SORT li_tvlvt BY abrvw.
    ENDIF.
  ENDIF.
  IF li_bil_invoice-hd_org-comp_code IS NOT INITIAL.
*- Company Codes
    SELECT bukrs land1 waers adrnr
      FROM t001
      INTO TABLE li_t001
      WHERE bukrs = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc <> 0.
      SELECT bukrs land1 waers adrnr
        FROM t001
        INTO TABLE li_t001
        WHERE bukrs = '1001'.
    ENDIF.
    IF li_t001[] IS NOT INITIAL.
*- Addresses (Business Address Services)
      SELECT addrnumber city1 post_code1
             street house_num1 region country
        FROM adrc
        INTO TABLE li_adrc
        FOR ALL ENTRIES IN li_t001
        WHERE addrnumber = li_t001-adrnr.
      IF sy-subrc EQ 0.
        SORT li_adrc BY addrnumber.
      ENDIF.
    ENDIF.

*- Additional Specifications for Company Code
    SELECT bukrs party paval                            "#EC CI_NOORDER
      FROM t001z
      INTO TABLE li_t001z
      WHERE bukrs = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc EQ 0.
      SORT li_t001z BY bukrs party.
    ENDIF.
  ENDIF.
  IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
*- Billing Document: Header Data
    SELECT vbeln vsbed fkdat
           gjahr zterm bukrs taxk1
      FROM vbrk
      INTO TABLE li_vbrk
      WHERE vbeln = li_bil_invoice-hd_gen-bil_number.
    IF sy-subrc EQ 0.
*- Fetching the Shipping Method
      SELECT vsbed vtext
        FROM tvsbt
        INTO TABLE li_tvsbt
        FOR ALL ENTRIES IN li_vbrk
        WHERE spras EQ c_e
          AND vsbed EQ li_vbrk-vsbed.
      IF sy-subrc EQ 0.
        SORT li_tvsbt BY vsbed.
      ENDIF.
*-  Get Current Fiscal Year
      CALL FUNCTION 'GET_CURRENT_YEAR'
        EXPORTING
          bukrs = li_bil_invoice-hd_org-comp_code
          date  = sy-datum
        IMPORTING
          curry = v_fiscal_yr.
*-  Fetching Billing accounting document details
      SELECT bukrs belnr gjahr augbl koart              "#EC CI_NOORDER
        FROM bseg
        INTO TABLE li_bseg
        FOR ALL ENTRIES IN li_vbrk
        WHERE bukrs EQ li_vbrk-bukrs
          AND belnr EQ li_vbrk-vbeln
          AND gjahr EQ v_fiscal_yr
          AND koart EQ c_d.
      IF sy-subrc EQ 0.
        SORT li_bseg BY bukrs belnr gjahr.
      ENDIF.
    ENDIF.

    IF nast-kschl = c_outtyp.
*- Fetch order / contract, delivery numbers for Invoice
      " Fetch Order / Contract
      SELECT SINGLE vbelv, vbeln, vbtyp_n, vbtyp_v
               FROM vbfa
               INTO @DATA(lst_order)
              WHERE vbeln = @li_bil_invoice-hd_gen-bil_number.
      IF sy-subrc EQ 0 AND lst_order-vbelv IS NOT INITIAL.
        " Fetch userid who created order or contract
        FREE:st_ktext.
        SELECT SINGLE ernam   " Customer Service Name
                      auart
                      ktext
                 INTO st_ktext
                 FROM vbak
                 WHERE vbeln EQ lst_order-vbelv.
        " Fetch Delivery number of the order / contract
        SELECT SINGLE vbelv, vbeln, vbtyp_n, vbtyp_v
                 FROM vbfa
                 INTO @DATA(lst_delivery)
                 WHERE vbelv = @lst_order-vbelv
                   AND vbtyp_n = @c_doc_type.
        IF sy-subrc EQ 0.
          " Fetch object list number based on delivery number
          SELECT obknr, lief_nr
            FROM ser01
            INTO TABLE @DATA(li_ser01)
            WHERE lief_nr EQ @lst_delivery-vbeln.
          IF sy-subrc EQ 0.
            SORT li_ser01 BY obknr.
            " Fetch serial number and material based on object lis number
            SELECT obknr, sernr, matnr
              FROM objk
              INTO TABLE @DATA(li_objk)
              FOR ALL ENTRIES IN @li_ser01
              WHERE obknr EQ @li_ser01-obknr.
            IF sy-subrc EQ 0.
              " material description
              SELECT matnr, maktx
                FROM makt
                INTO TABLE @DATA(li_makt_srl_no)
                FOR ALL ENTRIES IN @li_objk
                WHERE matnr = @li_objk-matnr.
              IF sy-subrc EQ 0.
                SORT li_makt_srl_no BY matnr.
              ENDIF.
              SORT li_objk BY obknr sernr matnr.
              LOOP AT li_objk INTO DATA(lst_objk).
                CLEAR lv_sal_mat_text.
*- Get Material master sales text
                CONCATENATE lst_objk-matnr
                            li_bil_invoice-hd_org-salesorg
                            li_bil_invoice-hd_org-distrb_channel
                       INTO lv_name.
                CALL FUNCTION 'READ_TEXT'
                  EXPORTING
                    id                      = lc_id
                    language                = li_bil_invoice-hd_org-salesorg_spras
                    name                    = lv_name
                    object                  = lc_object
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
                IF sy-subrc EQ 0 AND li_tline[] IS NOT INITIAL.
                  CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
                    EXPORTING
                      it_tline       = li_tline
                    IMPORTING
                      ev_text_string = lv_sal_mat_text.
                  IF lv_sal_mat_text IS NOT INITIAL.
                    CONDENSE lv_sal_mat_text.
                    lst_serial_numbers-sal_mat_text = lv_sal_mat_text.
                    APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
                  ENDIF. " IF sy-subrc EQ 0
                ENDIF.
                " When no sales text is maintained display material description from makt
                IF lv_sal_mat_text IS INITIAL.
                  READ TABLE li_makt_srl_no INTO DATA(lst_mat_srl_no)
                    WITH KEY matnr = lst_objk-matnr BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lst_serial_numbers-sal_mat_text = lst_mat_srl_no-maktx.
                    APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
                  ENDIF.
                ENDIF.
                lst_serial_numbers-sal_mat_text = lst_objk-sernr.
                APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
                CLEAR lst_serial_numbers.
                " Maintain the gap between two serial numbers in the output
                APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
              ENDLOOP. " LOOP AT li_objk INTO DATA(lst_objk).
            ENDIF. " IF sy-subrc EQ 0.
          ENDIF. " IF sy-subrc EQ 0.
        ENDIF. " IF sy-subrc EQ 0.
      ENDIF. " IF sy-subrc EQ 0.
    ENDIF. " IF nast-kschl = c_outtyp.
  ENDIF. " IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.

**Fetch values from constant table
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/..)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @li_const
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @c_devid
      AND activate EQ @abap_true.
*- Doc Currency
  v_doc_currency = li_bil_invoice-hd_gen-bil_waerk.
*- Customer Currency
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_hd_part)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             bil_item = c_hdr_posnr
             partn_role = c_re.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO DATA(lst_kna1)
      WITH KEY kunnr = lst_hd_part-partn_numb.
    IF sy-subrc EQ 0.
*- Customer VAT
      v_vat = lst_kna1-stceg.
      READ TABLE li_adrc_part INTO DATA(lst_adrc)
        WITH KEY addrnumber = lst_kna1-adrnr BINARY SEARCH.
      IF sy-subrc EQ 0.
*- Retrieve local currency from T005 table
        SELECT SINGLE xegld,
                      waers " Country currency
                 INTO @DATA(lst_t005)
                 FROM t005  " Countries
                 WHERE land1 = @lst_adrc-country.
        IF sy-subrc EQ 0.
          v_euro_ind = lst_t005-xegld.
          v_cust_currency = lst_t005-waers.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ENDIF.
  ENDIF.
  READ TABLE li_t001 INTO DATA(lst_t001) INDEX 1.
  IF sy-subrc EQ 0.
    v_loc_currency = lst_t001-waers.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROTOCOL_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_protocol_update.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb              = syst-msgid
      msg_nr                 = syst-msgno
      msg_ty                 = syst-msgty
      msg_v1                 = syst-msgv1
      msg_v2                 = syst-msgv2
      msg_v3                 = syst-msgv3
      msg_v4                 = syst-msgv4
    EXCEPTIONS
      message_type_not_valid = 1
      no_sy_message          = 2
      OTHERS                 = 3.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_PRINT_DATA_TO_READ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_print_data_to_read.
  FIELD-SYMBOLS: <fs_print_data_to_read> TYPE xfeld.
*- set print data requirements
  DO.
    ASSIGN COMPONENT sy-index OF STRUCTURE
                     li_print_data_to_read TO <fs_print_data_to_read>.
    IF sy-subrc <> 0. EXIT. ENDIF.
    <fs_print_data_to_read> = abap_true.
  ENDDO.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_HDR_ITM_FOR_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_hdr_itm_for_form .

  TYPES : BEGIN OF ty_tax_item,
            subs_type      TYPE ismmediatype,
            media_type     TYPE char255,
            tax_percentage TYPE char16, " Percentage of type CHAR16
            taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
            tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
          END OF ty_tax_item,

          tt_tax_item TYPE STANDARD TABLE OF ty_tax_item.

  DATA : lv_tax_amount      TYPE p DECIMALS 3,            " Subtotal 6 from pricing procedure for condition
         lst_tax_item       TYPE ty_tax_item,             " Tax item
         li_tax_item        TYPE tt_tax_item,             " Tax item
         li_top             TYPE STANDARD TABLE OF vtopis,
         lv_kbetr           TYPE kbetr,                   " Price
         lst_tax_item_final TYPE zstqtc_tax_item_f042,    " Structure for tax components
         i_tax_item         TYPE zttqtc_tax_item_f042,    " Rate (condition amount or percentage)
         li_tline           TYPE TABLE OF tline,          " Material Sales Text
         lv_sal_mat_text    TYPE string,                  " Material Sales Text
         lv_name            TYPE thead-tdname,            " Name
         li_bill_to_addr    TYPE TABLE OF szadr_printform_table_line,
         li_ship_to_addr    TYPE TABLE OF szadr_printform_table_line,
         lst_bill_to_addr   TYPE szadr_printform_table_line,
         lst_ship_to_addr   TYPE szadr_printform_table_line,
         lv_address_number  TYPE adrc-addrnumber,
         lv_lines           TYPE tdline.

  CONSTANTS : lc_percent TYPE char1 VALUE '%',                     " Percent of type CHAR1
              lc_prod    TYPE char4 VALUE 'EP1',                   " For Production system
              lc_vkbur   TYPE vkbur VALUE '0100',                  " Sales Office
              lc_id      TYPE rstxt-tdid VALUE '0001',             " Material Sales Text
              lc_object  TYPE rstxt-tdobject VALUE 'MVKE',         " Material texts, sales
              lc_tax_id  TYPE rvari_vnam VALUE 'TAX_ID'.

*--------------------------------------------------------------------*
  IF li_bil_invoice-it_kond[] IS NOT INITIAL.
    SORT li_bil_invoice-it_kond BY kposn.
    DELETE li_bil_invoice-it_kond WHERE koaid NE 'D'.
  ENDIF.
*- Sales Org Detailes
  READ TABLE li_t001 INTO DATA(lst_t001)
    WITH KEY bukrs = li_bil_invoice-hd_org-comp_code.
  IF sy-subrc EQ 0.
    v_comp_code_ctry =  lst_t001-land1.
    READ TABLE li_adrc INTO DATA(lst_adrc)
      WITH KEY addrnumber = lst_t001-adrnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-sales_org_name   = li_bil_invoice-hd_org-salesorg.
      li_hdr_itm-hdr_gen-sales_org_adrnr  = lst_adrc-addrnumber.
      li_hdr_itm-hdr_gen-sales_org_house1 = lst_adrc-house_num1.
      li_hdr_itm-hdr_gen-sales_org_street = lst_adrc-street.
      li_hdr_itm-hdr_gen-sales_org_city1  = lst_adrc-city1.
      li_hdr_itm-hdr_gen-sales_org_reg    = lst_adrc-region.
      li_hdr_itm-hdr_gen-sales_org_post1  = lst_adrc-post_code1.
      li_hdr_itm-hdr_gen-sales_org_ctry  = lst_adrc-ctry.
    ENDIF.
  ENDIF.

  IF st_ktext-auart = c_doctyp.
    li_hdr_itm-hdr_gen-ktext = st_ktext-ktext.
  ENDIF.

*- Tax Id
  READ TABLE li_const INTO DATA(lst_const)
    WITH KEY param1 = lc_tax_id
             param2 = li_bil_invoice-hd_org-comp_code.
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-tax_id = lst_const-low.
  ENDIF.

*- Customer Service UserID
  li_hdr_itm-hdr_gen-cust_service = st_ktext-ernam.

*- Invoice Number
  li_hdr_itm-hdr_gen-invoice_numb = li_bil_invoice-hd_gen-bil_number.

*- Client Number
  li_hdr_itm-hdr_gen-client_numb = li_bil_invoice-hd_gen-sold_to_party.

*- VAT Number
  li_hdr_itm-hdr_gen-vat_no    = v_vat.

*- Tax exempt text
  READ TABLE li_vbrk INTO DATA(lst_vbrk)
    WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number.
  IF sy-subrc EQ 0.
    IF lst_vbrk-taxk1 = 0.
      li_hdr_itm-hdr_gen-tax_expt_text = text-007. " Tax Exempt.
    ELSE.
      CLEAR li_hdr_itm-hdr_gen-tax_expt_text .
    ENDIF.

*- Shipping Method
    READ TABLE li_tvsbt INTO DATA(lst_tvsbt)
      WITH KEY vsbed = lst_vbrk-vsbed BINARY SEARCH.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-ship_method = lst_tvsbt-vtext.
    ENDIF.
  ENDIF.

*- Invoice Text basec on the SD Document Category
  IF  li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice
    CONCATENATE text-019 li_bil_invoice-hd_gen-bil_number
           INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
    li_hdr_itm-hdr_gen-cancel_inv_text = text-021. "Ref. Invoice No
    li_hdr_itm-hdr_gen-cancel_coolen = c_colen.
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_o.
    CONCATENATE text-004 li_bil_invoice-hd_gen-bil_number
           INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_p.
    CONCATENATE text-005 li_bil_invoice-hd_gen-bil_number
           INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
  ELSE. " if it is Regular Invoice
    CONCATENATE text-020 li_bil_invoice-hd_gen-bil_number
           INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
  ENDIF.

*- Cancelled Invoice Number
  li_hdr_itm-hdr_gen-cancel_inv_no = li_bil_invoice-hd_gen-sfakn.

*- Billing Date
  li_hdr_itm-hdr_gen-invoice_date = li_bil_invoice-hd_gen-bil_date.

*- Payment term text
  li_hdr_itm-hdr_gen-terms = li_bil_invoice-hd_gen_descript-name_paymterm.

*- Payment term calc date
  CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT'
    EXPORTING
      bldat                        = lst_vbrk-fkdat
      terms_of_payment             = lst_vbrk-zterm
    TABLES
      top_text                     = li_top
    EXCEPTIONS
      terms_of_payment_not_in_t052 = 1
      OTHERS                       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE li_top INTO DATA(lst_top) INDEX 1.
    li_hdr_itm-hdr_gen-due_date =  lst_top-hdatum.
  ENDIF.

*- IF Pay immediately, passing Invoice created date
  IF li_hdr_itm-hdr_gen-due_date IS INITIAL  AND lst_vbrk-zterm = c_0001.
    li_hdr_itm-hdr_gen-due_date = li_hdr_itm-hdr_gen-invoice_date.
  ENDIF.

*- PO Number
  li_hdr_itm-hdr_gen-po_no = li_bil_invoice-hd_ref-purch_no_c.

*- Bill-to Details
  CLEAR lv_lines.
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_part)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             partn_role = c_re.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO DATA(lst_kna1)
      WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO DATA(lst_adrc_part)
        WITH KEY addrnumber = lst_kna1-adrnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-bill_to_name = lst_adrc_part-name1.
        li_hdr_itm-hdr_gen-vat_no = lst_kna1-stceg.
        FREE:lv_address_number.
        lv_address_number = lst_kna1-adrnr.
        IF  lv_address_number IS NOT INITIAL.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = lv_address_number
              sender_country                 = 'US'
              number_of_lines                = '5'
            IMPORTING
              address_printform_table        = li_bill_to_addr
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc EQ 0.
            READ TABLE li_bill_to_addr ASSIGNING FIELD-SYMBOL(<lst_bill_to>)
              WITH KEY line_type = '5'. "C/o Name
            IF sy-subrc EQ 0.
              CONCATENATE text-006 <lst_bill_to>-address_line
                     INTO  <lst_bill_to>-address_line SEPARATED BY space.
            ENDIF.
          ENDIF.

          IF li_bill_to_addr IS NOT INITIAL.
            LOOP AT li_bill_to_addr INTO lst_bill_to_addr.
              lv_lines = lst_bill_to_addr-address_line.
              APPEND lv_lines TO  li_hdr_itm-it_bill_to_addr.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

*- Ship-to Details
  CLEAR: lv_address_number, lv_lines.
  READ TABLE li_bil_invoice-hd_part_add INTO lst_part
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             partn_role = c_we.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO lst_kna1
      WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO lst_adrc_part
        WITH KEY addrnumber = lst_kna1-adrnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-ship_to_name = lst_adrc_part-name1.
        FREE:lv_address_number.
        lv_address_number = lst_kna1-adrnr.
        IF  lv_address_number IS NOT INITIAL.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = lv_address_number
              sender_country                 = 'US'
              number_of_lines                = '5'
            IMPORTING
              address_printform_table        = li_ship_to_addr
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc EQ 0.
            READ TABLE li_ship_to_addr ASSIGNING FIELD-SYMBOL(<lst_ship_to>)
              WITH KEY line_type = '5'. "C/o Namessss
            IF sy-subrc EQ 0.
              CONCATENATE text-006 <lst_ship_to>-address_line
                     INTO <lst_ship_to>-address_line SEPARATED BY space.
            ENDIF.
          ENDIF.

          IF li_ship_to_addr IS NOT INITIAL.
            LOOP AT li_ship_to_addr INTO lst_ship_to_addr.
              lv_lines = lst_ship_to_addr-address_line.
              APPEND lv_lines TO li_hdr_itm-it_ship_to_addr.
              CLEAR lv_lines.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  IF sy-sysid <> lc_prod. "'EP1'.
    CONCATENATE 'TEST PRINT' sy-sysid sy-mandt
           INTO li_hdr_itm-hdr_gen-test_ref_doc SEPARATED BY c_under.
  ENDIF.

*- Invoice Description
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.
    li_hdr_itm-hdr_gen-invoice_desc  = text-004. " Credit Memo
    v_flg_cr = abap_true.
  ELSEIF  li_bil_invoice-hd_gen-bil_vbtype = c_debit.
    li_hdr_itm-hdr_gen-invoice_desc  = text-005. " Debit Memo
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_cancel.
    li_hdr_itm-hdr_gen-invoice_desc  = text-024. " CanceL Invoice
  ELSE.
    li_hdr_itm-hdr_gen-invoice_desc  = text-003. " Invoice
  ENDIF.

*- Invoice Note
  li_hdr_itm-hdr_gen-invoice_text_name = li_bil_invoice-hd_gen-bil_number.

*- Text object for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_object = c_vbbk.

*- Text ID for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_id = c_0007.

*- Language for Invoice Note
  li_hdr_itm-hdr_gen-invoice_lang = li_bil_invoice-hd_org-salesorg_spras.

*- Currency
  li_hdr_itm-hdr_gen-sub_tot_curr = li_bil_invoice-hd_gen-bil_waerk.

*- Freight
  READ TABLE li_bil_invoice-it_gen INTO DATA(lst_it_gen)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             item_categ = c_pstyv.
  IF sy-subrc EQ 0.
    READ TABLE li_bil_invoice-it_price INTO DATA(lst_it_price)
      WITH KEY bil_number = lst_it_gen-bil_number
               itm_number = lst_it_gen-itm_number.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-freight = lst_it_price-netwr.
    ENDIF.
  ENDIF.

*- Sub Total
  li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr - li_hdr_itm-hdr_gen-freight.
  IF v_flg_cr IS NOT INITIAL.
    li_hdr_itm-hdr_gen-sub_total = ( li_bil_invoice-hd_gen-bil_netwr - li_hdr_itm-hdr_gen-freight ) * ( -1 ).
  ENDIF.

*- Tax
  li_hdr_itm-hdr_gen-tax =  li_bil_invoice-hd_gen-bil_tax.
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-tax GT 0.
    li_hdr_itm-hdr_gen-tax = li_hdr_itm-hdr_gen-tax * ( -1 ).
  ENDIF.

*- Amount Paid
  CLEAR lst_vbrk.
  SORT li_vbrk BY vbeln.
  READ TABLE li_vbrk INTO lst_vbrk
    WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number
    BINARY SEARCH.
  IF sy-subrc EQ 0.
    READ TABLE li_bseg INTO DATA(lst_bseg)
      WITH KEY bukrs = lst_vbrk-bukrs
               belnr = lst_vbrk-vbeln
               gjahr = v_fiscal_yr BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF lst_bseg-augbl NE space. " IF the document is cleared
        li_hdr_itm-hdr_gen-amount_paid = li_hdr_itm-hdr_gen-sub_total +
                                         li_hdr_itm-hdr_gen-freight +
                                         li_hdr_itm-hdr_gen-tax.
      ELSE. " IF the document is not cleared
        li_hdr_itm-hdr_gen-amount_paid = 0.
      ENDIF.
    ENDIF.
  ENDIF.

*- Total Due
  li_hdr_itm-hdr_gen-total_due = ( li_hdr_itm-hdr_gen-sub_total +
                                   li_hdr_itm-hdr_gen-freight +
                                   li_hdr_itm-hdr_gen-tax ) -
                                 ( li_hdr_itm-hdr_gen-amount_paid ).
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-total_due GT 0.
    li_hdr_itm-hdr_gen-total_due =  li_hdr_itm-hdr_gen-total_due * ( -1 ).
  ENDIF.

*- get the dynamic bank and remit details.
  CLEAR:lst_const.
  READ TABLE li_const INTO lst_const
    WITH KEY param1 = c_bank
             param2 = li_bil_invoice-hd_org-comp_code
             high   = li_bil_invoice-hd_gen-bil_waerk.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-bank = lst_const-low.
  ENDIF.
  CLEAR:lst_const.
  READ TABLE li_const INTO lst_const
    WITH KEY param1 = c_remit
             param2 = li_bil_invoice-hd_org-comp_code
             high   = li_bil_invoice-hd_gen-bil_waerk.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-remit_payment_to = lst_const-low.
  ENDIF.

  CLEAR:lst_const.
  READ TABLE li_const INTO lst_const
    WITH KEY param1 = c_portal
             param2 = li_bil_invoice-hd_org-comp_code
             high   = li_bil_invoice-hd_gen-bil_waerk.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-payment_portal = lst_const-low.
  ENDIF.

*- Item Section

  " Fetch Old Material Number
  SELECT matnr, bismt
    FROM mara
    INTO TABLE @DATA(li_mara)
    FOR ALL ENTRIES IN @li_bil_invoice-it_gen
    WHERE matnr EQ @li_bil_invoice-it_gen-material.
  IF sy-subrc EQ 0.
    SORT li_mara BY matnr.
  ENDIF.

  LOOP AT li_bil_invoice-it_gen INTO DATA(lst_item_gen).
    IF sy-tabix EQ 1.
      v_sales_office = lst_item_gen-sales_off.  "Sales office
      v_price_date   = lst_item_gen-pric_date.
      li_hdr_itm-hdr_gen-price_date = lst_item_gen-pric_date.
    ENDIF.
    lst_count-vbeln = lst_item_gen-bil_number.
    lst_count-posnr = lst_item_gen-itm_number.

*- Add Old Material Number
    READ TABLE li_mara INTO DATA(lst_mara)
      WITH KEY matnr = lst_item_gen-material BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_count-bismt = lst_mara-bismt.
    ENDIF.

    lst_count-kdmat = lst_item_gen-cust_mat.
    lst_count-vkaus = lst_item_gen-vkaus.
    READ TABLE li_mvke INTO DATA(lst_mvke)
      WITH KEY matnr = lst_item_gen-material BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_count-pstyv = lst_mvke-mtpos.
    ENDIF.
    lst_count-vkbur = lst_item_gen-sales_off.
    lst_count-spart = li_bil_invoice-hd_org-division.

*- Get Material master sales text
    CONCATENATE lst_item_gen-material
                li_bil_invoice-hd_org-salesorg
                li_bil_invoice-hd_org-distrb_channel INTO lv_name.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = lc_id
        language                = li_bil_invoice-hd_org-salesorg_spras
        name                    = lv_name
        object                  = lc_object
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
    IF sy-subrc EQ 0 AND li_tline[] IS NOT INITIAL.
* Implement suitable error handling here
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_tline
        IMPORTING
          ev_text_string = lv_sal_mat_text.
      IF lv_sal_mat_text IS NOT INITIAL.
        CONDENSE lv_sal_mat_text.
        lst_count-maktx = lv_sal_mat_text.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.

*- Material Description field value to pick from the Material master sales text. If not found then from MAKTX (Material Description).
    IF lst_count-maktx IS INITIAL .
      READ TABLE li_makt INTO DATA(lst_mat)
        WITH KEY matnr = lst_item_gen-material BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_count-maktx = lst_mat-maktx.
      ENDIF.
    ENDIF.
    APPEND lst_count TO li_count.
    CLEAR: lst_count,lst_item_gen.
  ENDLOOP.

*- Item Section
  LOOP AT li_count ASSIGNING FIELD-SYMBOL(<lst_count1>).
** Item ***
    " Add Old Material Number
    lst_itm_gen-item = <lst_count1>-bismt.

** Description ***
    lst_itm_gen-description = <lst_count1>-maktx.

    READ TABLE li_bil_invoice-it_gen INTO DATA(lst_itm_gen_t)
      WITH KEY bil_number = <lst_count1>-vbeln
               itm_number = <lst_count1>-posnr.
    IF sy-subrc EQ 0.
      v_fkimg = lst_itm_gen_t-fkimg.
      CONDENSE v_fkimg.
      SPLIT v_fkimg AT '.' INTO v_fkimg_fr v_fkimg_bk.
      CONDENSE v_fkimg_fr.
      lst_itm_gen-students = v_fkimg_fr.
    ENDIF.

** Total, Tax, amount and Discount ***
    READ TABLE li_bil_invoice-it_price INTO DATA(lst_itm_price)
      WITH KEY bil_number = <lst_count1>-vbeln
               itm_number = <lst_count1>-posnr.
    IF sy-subrc EQ 0.

*- Amount
      lst_itm_gen-amount = lst_itm_gen-amount + lst_itm_price-kzwi1.

      IF v_flg_cr EQ abap_true AND lst_itm_gen-amount GT 0.
        lst_itm_gen-amount = lst_itm_gen-amount * ( -1 ).
      ENDIF.

*- Convert Tax value to positive value
      lst_itm_price-kzwi5 = lst_itm_price-kzwi5 * -1.

*- Discounts
      lst_itm_gen-discounts = lst_itm_gen-discounts + lst_itm_price-kzwi5.

*- Pass converted Tax value
      lst_itm_gen-tax = lst_itm_gen-tax + lst_itm_price-kzwi6.
      IF v_flg_cr IS NOT INITIAL AND lst_itm_gen-tax GT 0.
        lst_itm_gen-tax = lst_itm_gen-tax * ( -1 ).
      ENDIF.

*- Currency
      lst_itm_gen-currency = li_bil_invoice-hd_gen-bil_waerk.
      lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.

      IF v_flg_cr IS NOT INITIAL AND lst_itm_gen-total  GT 0.
        lst_itm_gen-total =  lst_itm_gen-total * ( -1 ).
      ENDIF.
    ENDIF.

    APPEND lst_itm_gen TO li_itm_gen.
    CLEAR lst_itm_gen.
    CLEAR lst_count.
  ENDLOOP.
  li_hdr_itm-itm_gen[] = li_itm_gen[].

** Tax item ***
  LOOP AT li_bil_invoice-it_price INTO DATA(lst_inv_it).
    READ TABLE li_bil_invoice-it_kond INTO DATA(lst_komv)
      WITH KEY kposn = lst_inv_it-itm_number.
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
      DATA(lv_index) = sy-tabix.
      LOOP AT li_bil_invoice-it_kond INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_inv_it-itm_number.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0

    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_inv_it-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
**      Populate tax amount
    lst_tax_item-tax_amount = lst_inv_it-kzwi6.

    IF v_flg_cr IS NOT INITIAL AND lst_tax_item-tax_amount GT 0.
      lst_tax_item-tax_amount = lst_tax_item-tax_amount * ( -1 ).
    ENDIF.

    IF v_flg_cr IS NOT INITIAL AND lst_tax_item-taxable_amt GT 0.
      lst_tax_item-taxable_amt = lst_tax_item-taxable_amt * ( -1 ).
    ENDIF.

    IF lst_inv_it-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL
    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent
           INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.
    COLLECT lst_tax_item INTO li_tax_item.
  ENDLOOP.

  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = c_tax.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage c_eq
           INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt
       TO lst_tax_item_final-taxabl_amt
       CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_tax_item_final-taxabl_amt.

    CONCATENATE lst_tax_item_final-taxabl_amt c_at
           INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount
       TO lst_tax_item_final-tax_amount
       CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-tax_amount.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_tax_item_final-tax_amount.

    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item

  li_hdr_itm-itm_exc_tab[] =  i_tax_item[].

  v_division = li_bil_invoice-hd_org-division.

  IF v_sales_office EQ lc_vkbur.
    v_param1 = v_sales_office.
  ELSE.
    v_param1 = space.
  ENDIF.

*- Logo
  PERFORM f_get_logo CHANGING v_bmp.

*- Currency Conevrsion
  PERFORM f_convert_amount.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_FORMNAME  text
*----------------------------------------------------------------------*
FORM f_populate_layout  USING    fp_v_formname TYPE fpname.
* Local constants
  CONSTANTS lc_900 TYPE i VALUE 900.

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string ##NEEDED,             " String value
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        st_formoutput       TYPE fpformoutput,                " Formoutput
        lv_upd_tsk          TYPE i.                           " Added by MODUTTA
*--------------------------------------------------------------------*

  lst_sfpoutputparams-nopributt = abap_true.
  lst_sfpoutputparams-noarchive = abap_true.
  IF v_ent_screen     = c_x.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = c_w. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
    lst_sfpoutputparams-preview = abap_false.
  ELSEIF v_ent_screen = abap_false.
    lst_sfpoutputparams-preview = abap_false.
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'

  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = nast-ldest.
  lst_sfpoutputparams-copies    = nast-anzal.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = nast-tdarmod.
  lst_sfpoutputparams-reqimm    = nast-dimme.
  lst_sfpoutputparams-reqdel    = nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*- Set language and default language
  lst_sfpdocparams-langu     = nast-spras.

*- Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.
  IF v_ent_retco = 0.
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_sfpoutputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = sy-msgid
          msg_nr                 = sy-msgno
          msg_ty                 = sy-msgty
          msg_v1                 = sy-msgv1
          msg_v2                 = sy-msgv2
          msg_v3                 = sy-msgv3
          msg_v4                 = sy-msgv4
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF. " IF sy-subrc NE 0
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = fp_v_formname
            IMPORTING
              e_funcname = lv_funcname.
        CATCH cx_fp_api_usage INTO lr_err_usg ##NO_HANDLER.
          lr_text = lr_err_usg->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_repository INTO lr_err_rep ##NO_HANDLER.
          lr_text = lr_err_rep->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_internal INTO lr_err_int ##NO_HANDLER.
          lr_text = lr_err_int->get_text( ).
          LEAVE LIST-PROCESSING.
      ENDTRY.

*- Call function module to generate OPM detail
      CALL FUNCTION lv_funcname
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_hdr_itm         = li_hdr_itm
          im_logo            = v_logo
          im_bmp             = v_bmp
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = lc_900.
        RETURN.
      ELSE. " ELSE -> IF sy-subrc <> 0
        PERFORM f_protocol_update. "update sucess log
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc NE 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDIF.

*- For Archiving
  IF lst_sfpoutputparams-arcmode <> c_1 AND v_ent_screen IS INITIAL.
    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = c_pdf
        document                 = st_formoutput-pdf
      TABLES
        arc_i_tab                = lst_sfpdocparams-daratab
      EXCEPTIONS
        error_archiv             = 1
        error_communicationtable = 2
        error_connectiontable    = 3
        error_kernel             = 4
        error_parameter          = 5
        error_format             = 6
        OTHERS                   = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              RAISING system_error.
    ELSE. " ELSE -> IF sy-subrc <> 0
*- Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_v_returncode = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail  CHANGING p_fp_v_returncode TYPE sysubrc.
  DATA: st_outputparams  TYPE sfpdocparams ##NEEDED, " Form Processing Output Parameter
        lv_form          TYPE tdsfname,              " Smart Forms: Form Name
        lv_fm_name       TYPE funcname,              " Name of Function Module
        lv_upd_tsk       TYPE i,                     " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,       " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams,          " Form Parameters for Form Processing
        lv_person_numb   TYPE prelp-pernr.           " Person Number

*  IF nast-parvw = c_re.
*
*    SELECT SINGLE vbeln parvw kunnr pernr adrnr
*             FROM vbpa
*             INTO st_vbpa
*             WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*               AND parvw = c_re.  "
*    IF sy-subrc EQ 0.
*      SELECT smtp_addr UP TO 1 ROWS        " E-Mail Address
*        FROM adr6                          " E-Mail Addresses (Business Address Services)
*        INTO v_send_email
*        WHERE addrnumber EQ st_vbpa-adrnr.
*      ENDSELECT.
*      IF sy-subrc NE 0 AND v_send_email IS INITIAL .
*        SELECT SINGLE prsnr                   " E-Mail Address
*                 FROM knvk                    " E-Mail Addresses (Business Address Services)
*                 INTO v_persn_adrnr
*                 WHERE kunnr EQ st_vbpa-kunnr " bil_number
*                   AND pafkt = c_z1           ##WARN_OK.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE smtp_addr             "#EC CI_NOFIRST " E-Mail Address
*            FROM adr6                         " E-Mail Addresses (Business Address Services)
*            INTO v_send_email
*            WHERE persnumber EQ v_persn_adrnr.
*          IF v_send_email IS INITIAL.
*            syst-msgid = c_zqtc_r2.
*            syst-msgno = c_msg_no.
*            syst-msgty = c_e.
*            syst-msgv1 = text-018.
*            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*            PERFORM f_protocol_update.
*            v_ent_retco = 4.
*          ENDIF.
*        ELSE.
*          syst-msgid = c_zqtc_r2.
*          syst-msgno = c_msg_no.
*          syst-msgty = c_e.
*          syst-msgv1 = text-018.
*          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*          PERFORM f_protocol_update.
*          v_ent_retco = 4.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-017.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*
*  ELSE. "check for ER
*    SELECT SINGLE vbeln parvw kunnr pernr adrnr
*             FROM vbpa
*             INTO st_vbpa
*             WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*               AND parvw = c_er. " ER - Employee responsible
*    IF sy-subrc EQ 0.
*      SELECT smtp_addr UP TO 1 ROWS        " E-Mail Address
*        FROM adr6                          " E-Mail Addresses (Business Address Services)
*        INTO v_send_email
*        WHERE addrnumber EQ st_vbpa-adrnr.
*      ENDSELECT.
*      IF sy-subrc NE 0 AND v_send_email IS INITIAL.
*        lv_person_numb = st_vbpa-pernr.
*        CALL FUNCTION 'HR_READ_INFOTYPE'
*          EXPORTING
*            pernr           = lv_person_numb
*            infty           = c_105
*            begda           = c_start
*            endda           = c_end
*          TABLES
*            infty_tab       = li_person_mail_id
*          EXCEPTIONS
*            infty_not_found = 1
*            OTHERS          = 2.
*        IF sy-subrc EQ 0.
** Implement suitable error handling here
*          READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id)
*            WITH KEY pernr =  lv_person_numb
*                     usrty = c_0010.
*          IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
*            v_send_email = lst_person_mail_id-usrid_long.
*          ELSE.
*            syst-msgid = c_zqtc_r2.
*            syst-msgno = c_msg_no.
*            syst-msgty = c_e.
*            syst-msgv1 = text-016.
*            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*            PERFORM f_protocol_update.
*            v_ent_retco = 4.
*          ENDIF.
*        ELSE.
*          syst-msgid = c_zqtc_r2.
*          syst-msgno = c_msg_no.
*          syst-msgty = c_e.
*          syst-msgv1 = text-016.
*          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*          PERFORM f_protocol_update.
*          v_ent_retco = 4.
*        ENDIF.
*      ENDIF. " IF sy-subrc NE 0
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-015.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*  ENDIF.

*- Fetch the Number of contact person for the Business Partner
  SELECT SINGLE kunnr, vkorg, vtweg, spart, parvw, parza , parnr
    FROM knvp
    INTO @DATA(lst_knvp)
    WHERE kunnr EQ @li_bil_invoice-hd_gen-sold_to_party
      AND vkorg EQ @li_bil_invoice-hd_org-salesorg
      AND vtweg EQ @li_bil_invoice-hd_org-distrb_channel
      AND spart EQ @li_bil_invoice-hd_org-division
      AND parvw EQ @c_cp.
  IF sy-subrc EQ 0.
*- Fetch the Person number for the contact person number
    SELECT SINGLE parnr, prsnr
      FROM knvk
      INTO @DATA(lst_knvk)
      WHERE parnr EQ @lst_knvp-parnr.
    IF sy-subrc EQ 0.
*- Fetch the E-mail address for the person number
      SELECT smtp_addr                     " E-Mail Address
        FROM adr6                          " E-Mail Addresses (Business Address Services)
        INTO TABLE li_send_email
        WHERE persnumber EQ lst_knvk-prsnr.
      IF sy-subrc NE 0.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = text-026.             " Email ID is not maintained for contact person
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-027.               " Person number is not maintained
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE.
    syst-msgid = c_zqtc_r2.
    syst-msgno = c_msg_no.
    syst-msgty = c_e.
    syst-msgv1 = text-028.                 " CP partner function is not maintained
    CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
    PERFORM f_protocol_update.
    v_ent_retco = 4.
  ENDIF.

  IF li_send_email IS NOT INITIAL.
    IF v_ent_retco = 0 .
      lv_form = tnapr-sform.
      lst_outputparams-getpdf = abap_true.
      lst_outputparams-preview = abap_false.
    ENDIF. " IF v_ent_retco = 0

*- Set output parameters
    lst_outputparams-nopributt = abap_true. " no print buttons in the preview
    lst_outputparams-noarchive = abap_true. " no archiving in the preview

    lst_outputparams-nodialog  = abap_true. " suppress printer dialog popup
    lst_outputparams-dest      = nast-ldest.
    lst_outputparams-copies    = nast-anzal.
    lst_outputparams-dataset   = nast-dsnam.
    lst_outputparams-suffix1   = nast-dsuf1.
    lst_outputparams-suffix2   = nast-dsuf2.
    lst_outputparams-cover     = nast-tdocover.
    lst_outputparams-covtitle  = nast-tdcovtitle.
    lst_outputparams-authority = nast-tdautority.
    lst_outputparams-receiver  = nast-tdreceiver.
    lst_outputparams-division  = nast-tddivision.
    lst_outputparams-arcmode   = nast-tdarmod.
    lst_outputparams-reqimm    = nast-dimme.
    lst_outputparams-reqdel    = nast-delet.
    lst_outputparams-senddate  = nast-vsdat.
    lst_outputparams-sendtime  = nast-vsura.

*- Set language and default language
    st_outputparams-langu    = nast-spras.

*- Archiving
    APPEND toa_dara TO  lst_sfpdocparams-daratab.

*- Open the spool job
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc.
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

*- Get the name of the generated function module
    IF v_ent_retco  = 0.
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_form
            IMPORTING
              e_funcname = lv_fm_name.

        CATCH cx_fp_api_repository
              cx_fp_api_usage
              cx_fp_api_internal ##NO_HANDLER.
          v_ent_retco = sy-subrc.
          PERFORM f_protocol_update.
      ENDTRY.
    ENDIF.

    IF v_ent_retco = 0.
*- Call the generated function module
      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_hdr_itm         = li_hdr_itm
          im_logo            = v_logo
          im_bmp             = v_bmp
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        v_ent_retco = sy-subrc .
        PERFORM f_protocol_update.
      ELSE.
        v_ent_retco = sy-subrc .
        PERFORM f_protocol_update.  "Update processing log when sucess
      ENDIF. " IF sy-subrc <> 0
    ENDIF.

*- Close the spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc .
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

    IF lst_outputparams-arcmode <> c_1 AND v_ent_screen IS INITIAL.
      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = c_pdf
          document                 = st_formoutput-pdf
        TABLES
          arc_i_tab                = lst_sfpdocparams-daratab
        EXCEPTIONS
          error_archiv             = 1
          error_communicationtable = 2
          error_connectiontable    = 3
          error_kernel             = 4
          error_parameter          = 5
          error_format             = 6
          OTHERS                   = 7.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE c_e NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                RAISING system_error.
      ELSE. " ELSE -> IF sy-subrc <> 0
*- Check if the subroutine is called in update task.
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF fp_v_returncode = 0
  ENDIF.

*- Perform is used to call E098 FM  & convert PDF in to Binary
  IF v_ent_retco = 0.
*- CONVERT_PDF_BINARY
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = st_formoutput-pdf
      TABLES
        binary_tab = i_content_hex.

*- Perform is used to create mail attachment with a creation of mail body
    IF li_send_email IS NOT INITIAL.
      PERFORM f_mail_attachment
      CHANGING v_ent_retco.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_OUTPUT  text
*      <--P_FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_mail_attachment  CHANGING p_fp_v_returncode TYPE sysubrc.

*- Declaration
  DATA: lr_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL, " Interface of Sender Object in BCS
        li_lines  TYPE STANDARD TABLE OF tline,               " Lines of text read
        lst_lines TYPE tline.                                 " SAPscript: Text Lines


*- Local Constant Declaration
  CONSTANTS:
    lc_raw               TYPE so_obj_tp      VALUE 'RAW',                   "Code for document class
    lc_parvw_zm          TYPE char02         VALUE 'ZM',
    lc_pdf               TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
    lc_s                 TYPE bapi_mtype     VALUE 'S',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
    lc_st                TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
    lc_object            TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
    lc_kn_email_inv      TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_INV_F061',
    lc_kn_email_canc_inv TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_CANC_INV_F061',
    lc_kn_email_cr       TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_CR_F061',
    lc_kn_email_dr       TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_DR_F061'.

  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service
  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL ##NEEDED, " BCS: Document Exceptions
        lv_subject      TYPE so_obj_des.                              " Short description of contents
*--------------------------------------------------------------------*
  TRY .
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.

*- Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
        lv_sub            TYPE string,
        lv_name           TYPE thead-tdname,
        lv_doc_cat        TYPE char30,
        lv_type           TYPE bu_type.

*- For SG Invoice the URL link https://paymentsqa.wiley.com to be provided to the payment portal.
  IF st_vbpa-parvw =  lc_parvw_zm."EQ 0.
    SELECT SINGLE name1
             FROM adrc
             INTO  v_er_name
             WHERE addrnumber = st_vbpa-adrnr.
    IF v_er_name IS INITIAL.
      SELECT SINGLE ename
        FROM pa0001
        INTO v_er_name
        WHERE pernr = st_vbpa-pernr.
    ENDIF.
  ELSE.  "If Bill-to
    SELECT SINGLE type
             FROM but000
             INTO @lv_type
             WHERE partner EQ @st_vbpa-kunnr.
    IF sy-subrc EQ 0.
      CASE lv_type.
        WHEN '1'.  " Person
          v_er_name = li_hdr_itm-hdr_gen-bill_to_name.
        WHEN '2'.  "Organization
*- Fetch the Contact person name from Bill-to
          SELECT SINGLE namev, name1
                   INTO @DATA(lst_knvk)
                   FROM knvk
                   WHERE kunnr EQ @st_vbpa-kunnr
                     AND pafkt EQ @c_z1.
          IF sy-subrc EQ 0.
            CONCATENATE lst_knvk-namev
                        lst_knvk-name1
                   INTO v_er_name SEPARATED BY space.
            IF v_er_name IS INITIAL.
              v_er_name = li_hdr_itm-hdr_gen-bill_to_name.
            ENDIF.
          ELSE.
            v_er_name = li_hdr_itm-hdr_gen-bill_to_name.
          ENDIF.
      ENDCASE.
    ENDIF.
  ENDIF.
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.  " 'O'
    lv_doc_cat = text-004. " Credit Memo
  ELSEIF  li_bil_invoice-hd_gen-bil_vbtype = c_debit. " 'P'
    lv_doc_cat  = text-005. " Debit Memo
  ELSE.
    IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
      lv_doc_cat = 'Canceled Invoice'(022).
    ELSE.
      lv_doc_cat = text-008. "Invoice
    ENDIF.
  ENDIF.

*- IF li_bil_invoice-hd_org-division = c_10.   "OPM invoice email Content
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.
    lv_name = lc_kn_email_cr.
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_debit.
    lv_name = lc_kn_email_dr.
  ELSE.
    IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
      lv_name = lc_kn_email_canc_inv.
    ELSE.
      lv_name = lc_kn_email_inv.
      DATA(lv_flag_remit) = abap_true.
    ENDIF.
  ENDIF.

  CONCATENATE text-014
              lv_doc_cat
              li_hdr_itm-hdr_gen-invoice_numb
         INTO lv_sub SEPARATED BY space.
  lv_subject = lv_sub.
*- FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = c_e
      name                    = lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lst_message_body-line = lst_lines-tdline.
      REPLACE ALL OCCURRENCES OF '&G_INVOICE&'
        IN lst_message_body-line WITH li_hdr_itm-hdr_gen-invoice_numb.
      REPLACE ALL OCCURRENCES OF '&G_ES&'
        IN lst_message_body-line WITH v_er_name.
      REPLACE ALL OCCURRENCES OF '&G_BP&'
        IN lst_message_body-line WITH li_hdr_itm-hdr_gen-bill_to_name.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0
*- Getting standard text based on the company code/sale org.
  IF lv_flag_remit = abap_true.
    FREE :lv_name,li_lines.
    READ TABLE li_const INTO DATA(lst_const)
      WITH KEY param1 = c_remit
               param2 = li_bil_invoice-hd_org-comp_code
               high   = li_bil_invoice-hd_gen-bil_waerk.
    IF sy-subrc = 0.
      lv_name = lst_const-low.
    ENDIF.
*- FM is used to SAPscript: Read text
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = lc_st
        language                = c_e
        name                    = lv_name
        object                  = lc_object
      TABLES
        lines                   = li_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc EQ 0.
      CLEAR lst_message_body.
      lst_message_body-line = space.
      APPEND lst_message_body-line TO li_message_body.
      CLEAR lst_lines.
      LOOP AT li_lines INTO lst_lines.
        lst_message_body-line = lst_lines-tdline.
        APPEND lst_message_body-line TO li_message_body.
        CLEAR:lst_lines,lst_message_body.
      ENDLOOP.
      CLEAR lst_message_body.
      lst_message_body-line = space.
      APPEND lst_message_body-line TO li_message_body.
      CLEAR lst_message_body.
      lst_message_body-line = text-025.
      APPEND lst_message_body-line TO li_message_body.
    ENDIF.
  ENDIF.
  CLEAR:lv_flag_remit.
  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw
      i_text = li_message_body
      i_subject = lv_subject ).
    CATCH cx_document_bcs ##NO_HANDLER.
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.
*- Send email with the attachments we are getting from FM
  TRY.
      lr_document->add_attachment(
      EXPORTING
      i_attachment_type = lc_pdf        " 'PDF'
      i_attachment_subject = lv_subject " 'Wiley WLS Invoice Form - OPM'
      i_att_content_hex = i_content_hex ).
    CATCH cx_document_bcs INTO lx_document_bcs ##NO_HANDLER.
*- Exception handling not required
  ENDTRY.

  TRY.
      CALL METHOD lr_send_request->set_message_subject
        EXPORTING
          ip_subject = lv_sub.
    CATCH cx_send_req_bcs.
  ENDTRY.
*- Add attachment
  TRY.
      CALL METHOD lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
*- Exception handling not required
  ENDTRY.

  IF li_send_email IS NOT INITIAL.
*- Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).
*- Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
*- Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
*- Create recipient
    LOOP AT li_send_email ASSIGNING FIELD-SYMBOL(<ls_send_email>).
      TRY.
          lr_recipient = cl_cam_address_bcs=>create_internet_address( <ls_send_email>-send_email ).
*- Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        CATCH cx_address_bcs ##NO_HANDLER.
        CATCH cx_send_req_bcs. ##NO_HANDLER
      ENDTRY.
    ENDLOOP.
*- Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
*- Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*- COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
      MESSAGE text-002 TYPE lc_s . "Email sent successfully
    ENDIF. " IF lv_upd_tsk EQ 0

    IF lv_sent_to_all = abap_true.
      MESSAGE text-002 TYPE lc_s . "Email sent successfully
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF li_send_email IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_clear .
  REFRESH:li_makt,li_adrc,li_t001z,li_vbrk,li_adrc_part,li_kna1,
          li_tvlvt,li_t001,li_count,li_itm_gen,li_send_email.

  CLEAR: st_address,
         st_formoutput,
         i_content_hex,
         repeat,
         nast_anzal,
         nast_tdarmod,
         v_division,
         v_sales_office ,
         v_param1,
         v_fkimg,
         lst_itm_gen,
         lst_count,
         v_kzwi5,
         v_formname,
         v_ent_retco,
         v_output_typ,
         v_logo,
         v_bmp,
         v_ref_curr,       " Reference currency for currency translation
         v_to_curr,        " To-currency
         v_bill_date,      " Billing date
         li_bil_invoice,
         li_hdr_itm,li_print_data_to_read.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_logo CHANGING fp_v_xstring TYPE xstring.

*- Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

*- To Get a BDS Graphic in BMP Format
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object    " GRAPHICS
      p_name         = lc_logo_name " ZJWILEY_LOGO
      p_id           = lc_id        " BMAP
      p_btype        = lc_btype     " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc NE 0.
    CLEAR fp_v_xstring.
  ENDIF. " IF sy-subrc NE 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_AMOUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_convert_amount.

  DATA: lv_exc_rate TYPE ukurs_curr,      " Exchange rate
        lv_loc_amt  TYPE ukm_credit_limit.

  IF v_doc_currency NE v_cust_currency.
    v_to_curr = v_cust_currency.
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-sub_total
                                    v_cust_currency
                                    v_to_curr
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-tax
                                    v_cust_currency
                                    v_to_curr
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.
  ENDIF.

  IF v_doc_currency NE v_loc_currency AND
     v_cust_currency NE v_loc_currency.
    v_to_curr = v_loc_currency.
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-sub_total
                                    v_loc_currency
                                    v_to_curr
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-tax
                                    v_loc_currency
                                    v_to_curr
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.
  ENDIF.
  IF li_hdr_itm-itm_amounts[] IS INITIAL .
    li_hdr_itm-hdr_gen-local_val = abap_false.
  ELSE.
    li_hdr_itm-hdr_gen-local_val = abap_true.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXC_RATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_SUBTOTAL_VAL  text
*      -->P_V_WAERS  text
*      <--P_LV_EXC_RATE  text
*      <--P_LV_LOC_AMT  text
*----------------------------------------------------------------------*
FORM f_get_exc_rate  USING fp_lv_forgn_amt TYPE any
                           fp_v_waers      TYPE waers             " Currency Key
                           fp_v_to_curr    TYPE tcurr_curr
                  CHANGING fp_lv_exc_rate  TYPE ukurs_curr        " Subtotal 6 from pricing procedure for condition
                           fp_lv_loc_amt   TYPE ukm_credit_limit. " Credit Limit

*- Local data declaration
  DATA: li_exc_tab     TYPE zttqtc_exchange_tab_invoice,
        lst_exch_rate  TYPE bapi1093_0,                 " Struc: Exchange Rate
        lst_return_msg TYPE bapiret1,                   " Struc: Return Msg
        lst_exc_tab    TYPE ztqtc_exchange_tab_invoice. " Exchange Rate table structure for invoice forms

  IF v_doc_currency = v_ref_curr.
    CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
      EXPORTING
        rate_type  = c_excrate_typ_m      " Exchange Rate type
        from_curr  = v_doc_currency       " Document Currency
        to_currncy = fp_v_to_curr         " Payer/Company Code Currency
        date       = v_bill_date          " Billing Date
      IMPORTING
        exch_rate  = lst_exch_rate
        return     = lst_return_msg.
    IF lst_exch_rate IS NOT INITIAL.
      fp_lv_exc_rate = lst_exch_rate-exch_rate.
      fp_lv_loc_amt = fp_lv_forgn_amt * fp_lv_exc_rate.
      CLEAR lst_exch_rate.
    ELSE.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ENDIF.

  ELSE.  " ELSE -> IF v_doc_currency = v_ref_curr.
    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING
        date             = v_price_date
        foreign_amount   = fp_lv_forgn_amt " Amount in foreign currency
        foreign_currency = v_doc_currency  " Currency key for foreign currency
        local_currency   = fp_v_waers      " Currency key for local currency
      IMPORTING
        exchange_rate    = fp_lv_exc_rate  " Exchange rate
        local_amount     = fp_lv_loc_amt   " Amount in local currency
      EXCEPTIONS
        no_rate_found    = 1
        overflow         = 2
        no_factors_found = 3
        no_spread_found  = 4
        derived_2_times  = 5
        OTHERS           = 6.
    IF sy-subrc NE 0.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ENDIF.
  ENDIF. " IF v_doc_currency = v_ref_curr.

*- Amount
  IF fp_lv_exc_rate LT 0.
    fp_lv_exc_rate = 1 / ( -1 * fp_lv_exc_rate ).
  ENDIF. " IF fp_lv_exc_rate LT 0
  WRITE fp_lv_forgn_amt TO lst_exc_tab-amount CURRENCY v_doc_currency.
  CONDENSE lst_exc_tab-amount.
  CONCATENATE lst_exc_tab-amount '@' INTO lst_exc_tab-amount.

  WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate.
  CONDENSE lst_exc_tab-exc_rate.
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-exc_rate.

  lst_exc_tab-loc_curr = fp_v_waers.

  CONCATENATE lst_exc_tab-loc_curr '=' INTO lst_exc_tab-loc_curr.

  WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY fp_v_waers.
  CONDENSE lst_exc_tab-conv_amt.

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-conv_amt.

  APPEND lst_exc_tab TO li_exc_tab.
  CLEAR: lst_exc_tab,
         fp_lv_exc_rate,
         fp_lv_loc_amt.
  APPEND LINES OF li_exc_tab TO li_hdr_itm-itm_amounts.
ENDFORM.
