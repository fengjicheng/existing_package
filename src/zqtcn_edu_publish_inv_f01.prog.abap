*&---------------------------------------------------------------------*
*&  Include        ZQTCN_EDU_PUBLISH_INV_F01
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDU_PUBLISH_INV_F01
* PROGRAM DESCRIPTION: Knewotn Invoice & Credit Memo Forms (ZINV & ZALB)
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 06/14/2019
* OBJECT ID: F049
* TRANSPORT NUMBER(S): ED1K910387
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: EPRM-5410
* REFERENCE NO:
* DEVELOPER: Sunil Kumar Kairamkonda (SKKAIRAMKO)
* DATE:  11/18/2019
* DESCRIPTION: illustrate the pricing date on the form.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-8349/ERPM-8402
* REFERENCE NO: ED1K911402
* DEVELOPER: VDPATABALL
* DATE:  12/10/2019
* DESCRIPTION: Pick dyanmic standard text for Bank and Remit Payment details
*              and Email subject changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ERPM-8210
* REFERENCE NO: ED1K911493
* DEVELOPER: VDPATABALL
* DATE:  12/31/2019
* DESCRIPTION: Service date on form F049
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917932
* REFERENCE NO: ERPM-15476
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 08/APR/2020
* DESCRIPTION: The correct exchange rate for compliance and
*              customer service
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918223
* REFERENCE NO: F061
* DEVELOPER: AMOHAMMED
* DATE:  06/09/2020
* DESCRIPTION: This INCLUDE is implemented for WLS (Wiley Learning Solutions)
*              Invoice form
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-31644
* REFERENCE NO:  ED2K921084
* DEVELOPER   :  SGUDA
* DATE        :  03/09/2021
* DESCRIPTION :  Exchange Rates Alignment between Batch and Manual Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-45037/OTCM-30892
* REFERENCE NO:  ED2K924068
* DEVELOPER   :  SGUDA
* DATE        :  08/JULY/2021
* DESCRIPTION :  Auto-send email externally with invoices for Standing Orders
* 1) Send BP Email id if Supplementry PO is 'SO'.
* 2) otherwise YBPERRORACK@wiley.com
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42834 INC0333245
* REFERENCE NO:  ED2K924671
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  30/SEP/2021
* DESCRIPTION :  Exchange rate rounding causing JPY amount on invoice to be incorrect
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913795
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION NO :  OTCM-57627 ( EPIC OTCM-59020 )
* REFERENCE NO:  ED2K925924,ED2K926018
* DEVELOPER   :  MURALI
* DATE        :  03/02/2022
* DESCRIPTION :  Mulitple email id receipients changes
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

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
**  v_formname = c_frm_name_f049."c_form_name.
***- Assign the F049 form name when output type is ZINV
**  IF nast-kschl EQ c_outtyp1. " ZW00
**    v_formname = c_frm_name_f061.
**  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

*- Perform has been used to send mail with an attachment of PDF
  IF v_ent_screen  EQ abap_false.

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- When output type is ZW00 and medium is "External send" call the subroutine
    IF v_formname = c_frm_name_f061 AND " ZW00
           nast-nacha = c_5. " Email Function
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ELSE.
*- When output type is not ZW00 call the subroutine
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ENDIF. " by AMOHAMMED - 06/09/2020 - ED2K918223

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
  CONSTANTS : lc_gjahr    TYPE gjahr              VALUE '0000', " Fiscal Year
              lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.
  IF nast-objky+10 NE space.
    nast-objky = nast-objky+16(10).
  ELSE.
    nast-objky = nast-objky.
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

*- BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
  v_bill_date = li_bil_invoice-hd_gen-bil_date.
*- Fetch Reference Currency of the Exchange Rate
  SELECT SINGLE bwaer
           FROM tcurv
           INTO v_ref_curr
           WHERE kurst = c_excrate_typ_m.
*- EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932

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

  IF  li_bil_invoice-it_gen[] IS NOT INITIAL.
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
  IF  li_bil_invoice-hd_org-comp_code IS NOT INITIAL.
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
    SELECT bukrs party  paval
      FROM t001z
      INTO TABLE li_t001z
      WHERE bukrs = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc EQ 0.
      SORT li_t001z BY bukrs party.
    ENDIF.
  ENDIF.
  IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
*- Billing Document: Header Data
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Comment the old code and
*- Fetch shipping method, fiscal year, company code along with other fields
*    SELECT vbeln zterm fkdat taxk1 FROM vbrk
    SELECT vbeln fkart vsbed fkdat
           gjahr zterm bukrs taxk1 mwsbk
      FROM vbrk
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
      INTO TABLE li_vbrk
      WHERE vbeln = li_bil_invoice-hd_gen-bil_number.
    IF sy-subrc <> 0.
*      do nothing
    ELSE.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- When output type is ZW00 get the shipping method and amount paid using subroutines
      IF v_formname = c_frm_name_f061. " (ZW00)
*- Fetching the Shipping Method
        PERFORM f_get_shipping_method.
*- Get Current Fiscal Year and Billing accounting document details for Amount Paid
        PERFORM f_get_amount_paid.
      ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
    ENDIF.
*- Begin of change VDPATABALL ERPM-8210 Knewton Billing Date  31/12/2019
*- When output type is either ZINV OR ZW00
*-  1. Fetch orders from vbfa table
*-  2. Fetch Customer Service Name (this is used when output type is ZW00)
    IF nast-kschl = c_outtyp " ZINV
       OR v_formname = c_frm_name_f061 " (ZW00) by AMOHAMMED - 06/09/2020 - ED2K918223
       OR nast-kschl = c_zsnv. "OTCM-30892
      SELECT SINGLE vbelv, vbeln
        FROM vbfa
        INTO @DATA(lst_vbfa)
        WHERE vbeln = @li_bil_invoice-hd_gen-bil_number.
*-     IF lst_vbfa-vbelv IS NOT INITIAL. " by AMOHAMMED - 06/09/2020 - ED2K918223
      IF sy-subrc EQ 0 AND lst_vbfa-vbelv IS NOT INITIAL.
        FREE:st_ktext.
        SELECT SINGLE
                      ernam " (Customer Service Name) by AMOHAMMED - 06/09/2020 - ED2K918223
                      auart ktext
                 INTO st_ktext
                 FROM vbak
                 WHERE vbeln  = lst_vbfa-vbelv.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- When output type is ZW00 perform the logic for serial numbers
        IF v_formname = c_frm_name_f061. " ZW00
          PERFORM f_serial_numbers USING lst_vbfa-vbelv.
        ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
      ENDIF.
    ENDIF.
*- End of change VDPATABALL ERPM-8210 Knewton Billing Date  31/12/2019
  ENDIF.

*- Fetch values from constant table

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- When output type is ZINV old code will be executed and
*- when output type is ZW00 subroutine will be called to fetch data for F061
  IF v_formname = c_frm_name_f049. " (ZINV)
    PERFORM f_get_zcaconstant USING c_devid.
*    SELECT  devid,     " Development ID
*            param1,    " ABAP: Name of Variant Variable
*            param2,    " ABAP: Name of Variant Variable
*            srno,      " ABAP: Current selection number
*            sign,      " ABAP: ID: I/E (include/exclude values)
*            opti,      " ABAP: Selection option (EQ/BT/CP/..)
*            low,       " Lower Value of Selection Condition
*            high,      " Upper Value of Selection Condition
*            activate   " Activation indicator for constant
*      INTO TABLE @li_const
*      FROM zcaconstant " Wiley Application Constant Table
*      WHERE devid EQ @c_devid
*        AND activate EQ @abap_true.
  ELSEIF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_get_zcaconstant USING c_devid_f061.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
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
         lv_due_date        TYPE bseg-zfbdt,              " Due date
         li_tline           TYPE TABLE OF tline,          " Material Sales Text
         lv_sal_mat_text    TYPE string,                  " Material Sales Text
         lv_name            TYPE thead-tdname,            " Name
         li_bill_to_addr    TYPE TABLE OF szadr_printform_table_line,
         li_ship_to_addr    TYPE TABLE OF szadr_printform_table_line,
         lst_bill_to_addr   TYPE szadr_printform_table_line,
         lst_ship_to_addr   TYPE szadr_printform_table_line,
         lv_address_number  TYPE adrc-addrnumber,
         lv_lines           TYPE tdline.


  CONSTANTS : lc_percent TYPE char1 VALUE '%',             " Percent of type CHAR1
              lc_prod    TYPE char4 VALUE 'EP1',           " For Production system
              lc_vkbur   TYPE vkbur VALUE '0100',          " Sales Office
              lc_id      TYPE rstxt-tdid VALUE '0001',     " Material Sales Text
              lc_object  TYPE rstxt-tdobject VALUE 'MVKE', " Material texts, sales
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
      WITH KEY addrnumber = lst_t001-adrnr.
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
*- Begin of change VDPATABALL ERPM 8210 12/31/2019
  IF st_ktext-auart = c_doctyp.
    li_hdr_itm-hdr_gen-ktext = st_ktext-ktext.
  ENDIF.
*- End of change VDPATABALL ERPM 8210 12/31/2019

*- Tax Id
  READ TABLE li_const INTO DATA(lst_const)
    WITH KEY param1 = lc_tax_id
             param2 = li_bil_invoice-hd_org-comp_code.
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-tax_id = lst_const-low.
  ENDIF.

*- Customer Sevice mail ID
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Removed constant c_cust_mail and maitained the e-mail id in text-029
*  li_hdr_itm-hdr_gen-cust_service = c_cust_mail.
  li_hdr_itm-hdr_gen-cust_service = 'knewtonsupport@wiley.com'(029) .
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

*- Invoice Number
  li_hdr_itm-hdr_gen-invoice_numb =  li_bil_invoice-hd_gen-bil_number.

*- Client Number
  li_hdr_itm-hdr_gen-client_numb = li_bil_invoice-hd_gen-sold_to_party.

*- VAT Number
  li_hdr_itm-hdr_gen-vat_no    = v_vat.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Customer Service UserID when output type is ZW00
  IF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_set_customer_service_userid.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
*- Tax exempt text
  READ TABLE li_vbrk INTO DATA(lst_vbrk)
    WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number.
  IF sy-subrc EQ 0. " by AMOHAMMED - 06/09/2020 - ED2K918223
    IF lst_vbrk-taxk1 = 0.
      li_hdr_itm-hdr_gen-tax_expt_text = text-007. " Tax Exempt.
    ELSE.
      CLEAR li_hdr_itm-hdr_gen-tax_expt_text .
    ENDIF.

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Shipping Method when output type is ZW00
    IF v_formname = c_frm_name_f061. " ZW00
      PERFORM f_set_shipping_method USING lst_vbrk-vsbed.
    ENDIF.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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
  IF v_formname = c_frm_name_f061. " ZW00
    CONCATENATE text-030 li_bil_invoice-hd_gen-bil_number
           INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
  ENDIF.
*- Cancelled Invoice Number
  li_hdr_itm-hdr_gen-cancel_inv_no = li_bil_invoice-hd_gen-sfakn.

*- Billing Date
  li_hdr_itm-hdr_gen-invoice_date =  li_bil_invoice-hd_gen-bil_date.

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
  li_hdr_itm-hdr_gen-po_no = li_bil_invoice-hd_ref-purch_no_c."purch_no.

*- Bill-to Details
  CLEAR lv_lines.
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_part)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             partn_role = c_re.
  IF sy-subrc EQ 0.
*- BOC: SKKAIRAMKON - 06/24/2019 -
    READ TABLE li_kna1 INTO DATA(lst_kna1)
      WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO DATA(lst_adrc_part)
        WITH KEY addrnumber = lst_kna1-adrnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-bill_to_name = lst_adrc_part-name1.
*- Begin of change and comments VDPATABALL  ERPM-8349/ERPM-8402
*        IF lst_adrc_part-name_co IS NOT INITIAL.
*          CONCATENATE text-006 lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-bill_to_attin SEPARATED BY c_colen.
*        ENDIF.
*        li_hdr_itm-hdr_gen-bill_to_street   = lst_adrc_part-street.
*        li_hdr_itm-hdr_gen-bill_to_city1    = lst_adrc_part-city1.
*        li_hdr_itm-hdr_gen-bill_to_region   = lst_adrc_part-region.
*        li_hdr_itm-hdr_gen-bill_to_post     = lst_adrc_part-post_code1.
*        li_hdr_itm-hdr_gen-bill_to_address  = lst_kna1-adrnr.
*- EOC: SKKAIRAMKON - 06/24/2019 -
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
                     INTO <lst_bill_to>-address_line SEPARATED BY space.
            ENDIF.
          ENDIF.

          IF li_bill_to_addr IS NOT INITIAL.
            LOOP AT li_bill_to_addr INTO lst_bill_to_addr.
              lv_lines = lst_bill_to_addr-address_line.
              APPEND lv_lines TO  li_hdr_itm-it_bill_to_addr.
            ENDLOOP.
          ENDIF.
        ENDIF.
*- End of change and comments VDPATABALL   ERPM-8349/ERPM-8402
      ENDIF.
    ENDIF.
  ENDIF.

*- Ship-to Details
  CLEAR: lv_address_number, lv_lines.
  READ TABLE li_bil_invoice-hd_part_add INTO lst_part
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             partn_role = c_we.
  IF sy-subrc EQ 0.
*- BOC: SKKAIRAMKON - 06/24/2019 -
    READ TABLE li_kna1 INTO lst_kna1
      WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO lst_adrc_part
        WITH KEY addrnumber = lst_kna1-adrnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-ship_to_name = lst_adrc_part-name1.
*- Begin of change and comments VDPATABALL   ERPM-8349/ERPM-8402
*        IF lst_adrc_part-name_co IS NOT INITIAL.
*          CONCATENATE text-006 lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-ship_to_attin SEPARATED BY  c_colen. "Attn
*        ENDIF.
*        li_hdr_itm-hdr_gen-ship_to_street   = lst_adrc_part-street.
*        li_hdr_itm-hdr_gen-ship_to_city1    = lst_adrc_part-city1.
*        li_hdr_itm-hdr_gen-ship_to_region   = lst_adrc_part-region.
*        li_hdr_itm-hdr_gen-ship_to_post     = lst_adrc_part-post_code1.
*        li_hdr_itm-hdr_gen-ship_to_address  = lst_kna1-adrnr.
*- EOC: SKKAIRAMKON - 06/24/2019 -
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
*- End of change and comments VDPATABALL   ERPM-8349/ERPM-8402
      ENDIF.
    ENDIF.
  ENDIF.

  IF sy-sysid <> lc_prod. "'EP1'.
    CONCATENATE 'TEST PRINT' sy-sysid sy-mandt
           INTO li_hdr_itm-hdr_gen-test_ref_doc SEPARATED BY c_under.
  ENDIF.

*- Invoice Description
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.     " 'O'
    li_hdr_itm-hdr_gen-invoice_desc  = text-004.      " Credit Memo
    v_flg_cr = abap_true.                             " ++SKKAIRAMKO
  ELSEIF  li_bil_invoice-hd_gen-bil_vbtype = c_debit. " 'P'
    li_hdr_itm-hdr_gen-invoice_desc  = text-005.      " Debit Memo
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_cancel. " 'P'
    li_hdr_itm-hdr_gen-invoice_desc  = text-024.      " Cancel Invoice
  ELSE.
    li_hdr_itm-hdr_gen-invoice_desc  = text-003.      " Invoice
  ENDIF.

*- Invoice Note
  li_hdr_itm-hdr_gen-invoice_text_name = li_bil_invoice-hd_gen-bil_number.

*- Text object for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_object = c_vbbk.

*- Text ID for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_id = c_0007.

*- Language for Invoice Note
  li_hdr_itm-hdr_gen-invoice_lang = li_bil_invoice-hd_org-salesorg_spras.

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Set Freight when output type is ZW00
  IF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_set_freight.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

*- Sub Total
* Old code is executed when output type is ZINV
  IF v_formname = c_frm_name_f049. " (ZINV) by AMOHAMMED - 06/09/2020 - ED2K918223
    li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr.
    IF v_flg_cr IS NOT INITIAL.
      li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr * ( -1 ).
    ENDIF.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Set Sub Total excluding Freight amount when output type is ZW00
  ELSEIF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_set_sub_total.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

*- Currency
  li_hdr_itm-hdr_gen-sub_tot_curr = li_bil_invoice-hd_gen-bil_waerk.

*- Tax
  li_hdr_itm-hdr_gen-tax =  li_bil_invoice-hd_gen-bil_tax.
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-tax GT 0.
    li_hdr_itm-hdr_gen-tax = li_hdr_itm-hdr_gen-tax * ( -1 ).
  ENDIF.

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Amount Paid is set when output type is ZW00
  IF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_set_amount_paid.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223


*- Total Due
*- Old code is executed when output type is ZINV
  IF v_formname = c_frm_name_f049. " (ZINV) by AMOHAMMED - 06/09/2020 - ED2K918223
    li_hdr_itm-hdr_gen-total_due = li_bil_invoice-hd_gen-bil_netwr +
                                   li_bil_invoice-hd_gen-bil_tax.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Set Total Due using subrouting when output type is ZW00
  ELSEIF v_formname = c_frm_name_f061. " ZW00
    PERFORM f_set_total_due.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-total_due GT 0.
    li_hdr_itm-hdr_gen-total_due =  li_hdr_itm-hdr_gen-total_due * ( -1 ).
  ENDIF.

*- Begin of change VDPATABALL ERPM-8349 12/10/2019- get the dynamic bank and remit details.
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
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE li_bil_invoice-it_gen INTO DATA(lst_item_gen1) INDEX 1.
  IF li_bil_invoice-hd_org-comp_code IN r_comp_code AND li_bil_invoice-hd_gen-bil_waerk IN  r_docu_currency
    AND lst_item_gen1-sales_off IN r_sales_office.
    li_hdr_itm-hdr_gen-remit_payment_to  = c_remit1.
    li_hdr_itm-hdr_gen-bank  = c_bank1.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785

*- End of change VDPATABALL ERPM-8349 12/10/2019
*- Tax ID
**  PERFORM f_build_tax_info.

*- Item Section
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Fetch Old Material Number when output type is ZW00
  IF v_formname = c_frm_name_f061. " ZW00
    READ TABLE li_const INTO lst_const
    WITH KEY param1 = c_ship
             param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      li_hdr_itm-hdr_gen-ship_terms = lst_const-low.
    ENDIF.
    PERFORM f_get_old_material_num.
*    *----Get The sales org address
    PERFORM f_get_sales_org_details.
**** Ship to address details for output type is ZW00
    PERFORM f_get_ship_to_address.
  ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

  LOOP AT li_bil_invoice-it_gen INTO DATA(lst_item_gen).
    IF sy-tabix EQ 1.
      v_sales_office = lst_item_gen-sales_off.                " Sales office
      v_price_date   = lst_item_gen-pric_date.                " ERPM-4140  SKKAIRAMKO - 10/23/19
      li_hdr_itm-hdr_gen-price_date = lst_item_gen-pric_date. " ++ERPM-5410 - SKKAIRAMKO - 11/18/2019
    ENDIF.
    lst_count-vbeln = lst_item_gen-bil_number.
    lst_count-posnr = lst_item_gen-itm_number.

    " Short text is assigend when output type is ZINV
    IF v_formname = c_frm_name_f049. " (ZINV) by AMOHAMMED - 06/09/2020 - ED2K918223
      lst_count-arktx = lst_item_gen-short_text.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Set Old Material Number when output type is ZW00
    ELSEIF v_formname = c_frm_name_f061. " ZW00
      PERFORM f_set_old_material_num USING lst_item_gen-material.
      PERFORM f_set_uom USING lst_item_gen-material lst_item_gen-sales_unit.
    ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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
*      IF sy-subrc EQ 0.                 " by AMOHAMMED - 06/09/2020 - ED2K918223
      IF lv_sal_mat_text IS NOT INITIAL. " by AMOHAMMED - 06/09/2020 - ED2K918223
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
*  SORT li_count BY maktx kdmat vkaus pstyv .

*- Item Section
  LOOP AT li_count ASSIGNING FIELD-SYMBOL(<lst_count1>).
** Item ***
    IF v_formname = c_frm_name_f049. " (ZINV) by AMOHAMMED - 06/09/2020 - ED2K918223
      lst_itm_gen-item = <lst_count1>-arktx.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Add Old Material Number to the ITM_GEN internal table when output type is ZW00
    ELSEIF v_formname = c_frm_name_f061. " ZW00
      lst_itm_gen-uom = <lst_count1>-vrkme.
      lst_itm_gen-item = <lst_count1>-bismt.
    ENDIF.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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
*    ENDIF.

** Total, Tax, amount and Discount ***
    READ TABLE li_bil_invoice-it_price INTO DATA(lst_itm_price)
      WITH KEY bil_number = <lst_count1>-vbeln
               itm_number = <lst_count1>-posnr.
    IF sy-subrc EQ 0.

*- Amount
      lst_itm_gen-amount = lst_itm_gen-amount + lst_itm_price-kzwi1.

      IF v_flg_cr EQ abap_true AND lst_itm_gen-amount GT 0 . " ++SKKAIRAMKO
        lst_itm_gen-amount = lst_itm_gen-amount * ( -1 ).
      ENDIF.

*- Convert Tax value to positive value
      lst_itm_price-kzwi5 = lst_itm_price-kzwi5 * -1.

*- Discounts
      lst_itm_gen-discounts = lst_itm_gen-discounts + lst_itm_price-kzwi5.

*- Pass converted Tax value
      lst_itm_gen-tax = lst_itm_gen-tax + lst_itm_price-kzwi6.
      IF v_flg_cr IS NOT INITIAL AND lst_itm_gen-tax GT 0. " ++SKKAIRAMKO
        lst_itm_gen-tax = lst_itm_gen-tax * ( -1 ).
      ENDIF.

*- Currency
      lst_itm_gen-currency = li_bil_invoice-hd_gen-bil_waerk.
*- Checking SD document category eq 'ZPRG'
*      IF <lst_count1>-pstyv = c_zprg.
*        lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.
*      ELSE.
*- other then SD document category  eq 'ZPRG'

      lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.

      IF v_flg_cr IS NOT INITIAL AND  lst_itm_gen-total  GT 0. " ++SKKAIRAMKO
        lst_itm_gen-total =  lst_itm_gen-total * ( -1 ).
      ENDIF.
*      ENDIF.
    ENDIF.
***BOC MIMMADISET ERPM-25818
    IF v_formname = c_frm_name_f061. " ZW00.

      READ TABLE li_bil_invoice-it_gen INTO lst_itm_gen_t
        WITH KEY bil_number = <lst_count1>-vbeln
                 itm_number = <lst_count1>-posnr.
      IF sy-subrc EQ 0.
        IF lst_itm_gen_t-uepos NE c_higherline     "Higher Line Item
           OR lst_itm_gen_t-item_categ = c_zpan.
*1.	Do not show any values in the columns AMOUNT, DISCOUNT, TAX, and TOTAL
          CLEAR:lst_itm_gen-tax,lst_itm_gen-total,
          lst_itm_gen-amount,lst_itm_gen-discounts.
        ENDIF.
        IF lst_itm_gen_t-item_categ = c_zkt1 OR
          lst_itm_gen_t-item_categ = c_zckt.
          READ TABLE li_vbrk INTO DATA(ls_vbrk) WITH KEY vbeln = <lst_count1>-vbeln.
          IF sy-subrc = 0.
            lst_itm_gen-total = lst_itm_gen-amount - lst_itm_gen-discounts
                + ls_vbrk-mwsbk.
            lst_itm_gen-tax = ls_vbrk-mwsbk.
          ENDIF.
          IF v_flg_cr IS NOT INITIAL AND  lst_itm_gen-total  GT 0.
            lst_itm_gen-total =  lst_itm_gen-total * ( -1 ).
          ENDIF.
          CLEAR:ls_vbrk.
        ENDIF.
      ENDIF.
      "BOC OTCM-29847
      lst_itm_gen_f061-item = lst_itm_gen-item.
      lst_itm_gen_f061-description = lst_itm_gen-description.
      lst_itm_gen_f061-currency = lst_itm_gen-currency.
      lst_itm_gen_f061-students = lst_itm_gen-students.
      lst_itm_gen_f061-uom = lst_itm_gen-uom.
      WRITE lst_itm_gen-tax TO lst_itm_gen_f061-tax.
      WRITE lst_itm_gen-total TO lst_itm_gen_f061-total.
      WRITE lst_itm_gen-amount TO lst_itm_gen_f061-amount.
      WRITE lst_itm_gen-discounts TO lst_itm_gen_f061-discounts.
      CONDENSE:lst_itm_gen_f061-tax,lst_itm_gen_f061-total,
       lst_itm_gen_f061-amount, lst_itm_gen_f061-discounts NO-GAPS.
      IF lst_itm_gen_t-uepos NE c_higherline     "Higher Line Item
        OR lst_itm_gen_t-item_categ = c_zpan.
*1.	Do not show any values in the columns AMOUNT, DISCOUNT, TAX, and TOTAL
        CLEAR:lst_itm_gen_f061-tax,lst_itm_gen_f061-total,
        lst_itm_gen_f061-amount,lst_itm_gen_f061-discounts.
      ENDIF.
      APPEND lst_itm_gen_f061 TO li_itm_gen_f061.
      CLEAR:lst_itm_gen_f061,lst_count.
      "EOC OTCM-29847
    ENDIF.
***EOC MIMMADISET ERPM-25818
    APPEND lst_itm_gen TO li_itm_gen.
    CLEAR lst_itm_gen.
    CLEAR lst_count.
  ENDLOOP.
  li_hdr_itm-itm_gen[] = li_itm_gen[].
  IF v_formname = c_frm_name_f061. " ZW00."BOC OTCM-29847
    li_hdr_itm-it_gen_f061[] = li_itm_gen_f061[].
    REFRESH:li_itm_gen_f061.
  ENDIF."EOC OTCM-29847

** Tax item ***
  LOOP AT li_bil_invoice-it_price  INTO DATA(lst_inv_it).
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

    IF v_flg_cr IS NOT INITIAL AND lst_tax_item-tax_amount GT 0."++SKKAIRAMKO
      lst_tax_item-tax_amount = lst_tax_item-tax_amount * ( -1 ).
    ENDIF.

    IF v_flg_cr IS NOT INITIAL AND   lst_tax_item-taxable_amt GT 0.
      lst_tax_item-taxable_amt =   lst_tax_item-taxable_amt * ( -1 ).
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
    lst_tax_item_final-media_type = c_tax."lst_tax_item-media_type.
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

*- BOC : SKKAIRAMKO
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_tax_item_final-tax_amount.

    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
  li_hdr_itm-itm_exc_tab[] =  i_tax_item[].

  v_division = li_bil_invoice-hd_org-division.

  IF v_sales_office EQ lc_vkbur. "0100
    v_param1 = v_sales_office.
  ELSE.
    v_param1 = space.
  ENDIF.

*- Logo
  PERFORM f_get_logo CHANGING v_bmp.

*- Currency Conevrsion
  PERFORM f_convert_amount.
**BOC mimmadiset
  IF v_formname = c_frm_name_f061. " ZW00
**if the customer has a currency other than USD in the BP Master
    IF v_cust_currency NE c_usd AND v_cust_currency IS NOT INITIAL.
      CLEAR:li_hdr_itm-hdr_gen-price_date.
    ENDIF.
  ENDIF.
**EOC mimmadiset
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_FORMNAME  text
*----------------------------------------------------------------------*
FORM f_populate_layout USING fp_v_formname TYPE fpname.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- To remove the Extended program check message
*- 900 is declared as constant instead of literal
* Local constants
  CONSTANTS lc_900 TYPE i VALUE 900.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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

*--- Set language and default language
  lst_sfpdocparams-langu     = nast-spras.

* Archiving
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
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- To avoid Extended program check message
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
      ENDIF. " IF sy-subrc NE 0
*    v_ent_retco = 900.

*    RETURN.
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


* Call function module to generate OPM detail
      CALL FUNCTION lv_funcname "'/1BCDWB/SM00000093'
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_hdr_itm         = li_hdr_itm "st_header
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
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- To avoid Extended program check message
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
        ENDIF. " IF sy-subrc NE 0
*        v_ent_retco = 900. " by AMOHAMMED - 06/09/2020 - ED2K918223
        v_ent_retco = lc_900. " by AMOHAMMED - 06/09/2020 - ED2K918223
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
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- To avoid Extended program check message
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
          ENDIF. " IF sy-subrc NE 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDIF.
*- For Archiving
  IF lst_sfpoutputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.

    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = c_pdf "  class
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
*           Check if the subroutine is called in update task.
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
FORM f_adobe_prnt_snd_mail CHANGING p_fp_v_returncode TYPE sysubrc.
  DATA: st_outputparams  TYPE sfpdocparams ##NEEDED,      " Form Processing Output Parameter
        lv_form          TYPE tdsfname,                   " Smart Forms: Form Name
        lv_fm_name       TYPE funcname,                   " Name of Function Module
        lv_upd_tsk       TYPE i,                          " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,            " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams,               " Form Parameters for Form Processing
        lv_person_numb   TYPE prelp-pernr,                " Person Number
        lv_text          TYPE char255.                    " For text message

  CLEAR lv_text.
***boc mimmadiset 3/2/2022 OTCM-57627 ED2K925924
  CONSTANTS:lc_email_m TYPE rvari_vnam VALUE 'EMAIL_MULTI'.
  DATA(lv_sales_area) = li_bil_invoice-hd_org-salesorg
             && li_bil_invoice-hd_org-distrb_channel
             && li_bil_invoice-hd_org-division.
  READ TABLE li_const INTO DATA(ls_con) WITH KEY
  param1 = lc_email_m
  param2 = lv_sales_area
  low = v_output_typ.
  IF sy-subrc = 0.
    DATA(lv_multi_mail) = ls_con-low.
  ENDIF.
  IF v_formname = c_frm_name_f049 AND v_output_typ = lv_multi_mail
    AND lv_multi_mail IS NOT INITIAL.
    PERFORM f_get_email_ids_multi CHANGING li_send_email.
***eoc mimmadiset 3/2/2022 OTCM-57627 ED2K925924
*- When output type is ZINV execute the old code
  ELSEIF v_formname = c_frm_name_f049. " (ZINV) by AMOHAMMED - 06/09/2020 - ED2K918223
    IF nast-parvw = c_re.
      SELECT SINGLE vbeln parvw kunnr pernr adrnr
               FROM vbpa
               INTO st_vbpa
               WHERE vbeln = li_bil_invoice-hd_ref-order_numb
        AND  parvw = c_re.  "
      IF sy-subrc EQ 0.
        SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
          FROM adr6      "E-Mail Addresses (Business Address Services)
          INTO v_send_email
          WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
        ENDSELECT.
        IF sy-subrc NE 0 AND v_send_email IS INITIAL .
          SELECT SINGLE prsnr "E-Mail Address
                   FROM knvk      "E-Mail Addresses (Business Address Services)
                   INTO v_persn_adrnr
                   WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
                     AND   pafkt = c_z1 ##WARN_OK.
          IF sy-subrc EQ 0.
            SELECT SINGLE smtp_addr "E-Mail Address
                     FROM adr6      "E-Mail Addresses (Business Address Services)
                     INTO v_send_email
                     WHERE persnumber EQ v_persn_adrnr.
            IF v_send_email IS INITIAL.
              syst-msgid = c_zqtc_r2.
              syst-msgno = c_msg_no.
              syst-msgty = c_e.
              syst-msgv1 = text-018.
              CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
              PERFORM f_protocol_update.
              v_ent_retco = 4.
            ENDIF.
          ELSE.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-018.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ENDIF.
      ELSE.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = text-017.
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ELSE. "check for ER
      SELECT SINGLE vbeln parvw kunnr pernr adrnr
               FROM vbpa
               INTO st_vbpa
               WHERE vbeln = li_bil_invoice-hd_ref-order_numb
                 AND  parvw = c_er. "ER - Employee responsible
      IF sy-subrc EQ 0.
        SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
          FROM adr6      "E-Mail Addresses (Business Address Services)
          INTO v_send_email
          WHERE addrnumber EQ st_vbpa-adrnr. ##WARN_OK
        ENDSELECT.
        IF sy-subrc NE 0 AND v_send_email IS INITIAL.
          lv_person_numb = st_vbpa-pernr.
          CALL FUNCTION 'HR_READ_INFOTYPE'
            EXPORTING
*             TCLAS           = 'A'
              pernr           = lv_person_numb
              infty           = c_105
              begda           = c_start
              endda           = c_end
            TABLES
              infty_tab       = li_person_mail_id
            EXCEPTIONS
              infty_not_found = 1
              OTHERS          = 2.
          IF sy-subrc EQ 0.
* Implement suitable error handling here
            READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id)
              WITH KEY pernr =  lv_person_numb
                       usrty = c_0010.
            IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
              v_send_email = lst_person_mail_id-usrid_long.
            ELSE.
              syst-msgid = c_zqtc_r2.
              syst-msgno = c_msg_no.
              syst-msgty = c_e.
              syst-msgv1 = text-016.
              CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
              PERFORM f_protocol_update.
              v_ent_retco = 4.
            ENDIF.
          ELSE.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-016.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ENDIF. " IF sy-subrc NE 0
      ELSE.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = text-015.
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ENDIF.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- When output type is ZINV only one e-mail id is fetched in v_send_email
*- appending it in li_send_email makes no difference if li_send_email internal
*- table is used instead of v_send_email
    IF v_send_email IS NOT INITIAL.
      APPEND v_send_email TO li_send_email.
    ENDIF.
*- When output type is ZW00 and medium is "External send"
*- then only fetch the email ids of contact person
  ELSEIF v_formname = c_frm_name_f061 AND " ZW00
         nast-nacha = c_5. " Email Function
    PERFORM f_get_email_ids CHANGING li_send_email.
  ENDIF.
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
  LOOP AT li_const INTO DATA(lst_const).
    IF lst_const-param1 = c_sales_team_email.
      APPEND INITIAL LINE TO r_sales_team_email ASSIGNING FIELD-SYMBOL(<lfs_sales_team_email>).
      <lfs_sales_team_email>-sign = lst_const-sign.
      <lfs_sales_team_email>-option = lst_const-opti.
      <lfs_sales_team_email>-low  = lst_const-low.
      <lfs_sales_team_email>-high = lst_const-high.
    ENDIF.
    IF lst_const-param1 = c_supplement_po.
      APPEND INITIAL LINE TO r_supplement_po ASSIGNING FIELD-SYMBOL(<lfs_supplement_po>).
      <lfs_supplement_po>-sign = lst_const-sign.
      <lfs_supplement_po>-option = lst_const-opti.
      <lfs_supplement_po>-low  = lst_const-low.
      <lfs_supplement_po>-high = lst_const-high.
    ENDIF.
    IF lst_const-param1 = c_supplement_po_output.
      APPEND INITIAL LINE TO r_supplement_po_output ASSIGNING FIELD-SYMBOL(<lfs_supplement_po_output>).
      <lfs_supplement_po_output>-sign = lst_const-sign.
      <lfs_supplement_po_output>-option = lst_const-opti.
      <lfs_supplement_po_output>-low  = lst_const-low.
      <lfs_supplement_po_output>-high = lst_const-high.
    ENDIF.
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
    IF lst_const-param1 EQ lc_currency_from.
      APPEND INITIAL LINE TO r_currency_from ASSIGNING FIELD-SYMBOL(<lst_currency_from>).
      <lst_currency_from>-sign   = lst_const-sign.
      <lst_currency_from>-option = lst_const-opti.
      <lst_currency_from>-low    = lst_const-low.
      <lst_currency_from>-high   = lst_const-high.
    ENDIF.
    IF lst_const-param1 EQ lc_currency_to.
      APPEND INITIAL LINE TO r_currency_to ASSIGNING FIELD-SYMBOL(<lst_currency_to>).
      <lst_currency_to>-sign   = lst_const-sign.
      <lst_currency_to>-option = lst_const-opti.
      <lst_currency_to>-low    = lst_const-low.
      <lst_currency_to>-high   = lst_const-high.
    ENDIF.
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
    CLEAR lst_const.
  ENDLOOP.
  IF v_output_typ IN r_supplement_po_output AND li_bil_invoice-hd_ref-po_supplem IN r_supplement_po.
* Begin of ADD:OTCM-30892/45037:SGUDA:30-SEP-2021:ED2K924647
    PERFORM get_ar_text_for_emailid USING li_bil_invoice-hd_ref-order_numb
                                    CHANGING v_send_email.
*    IF nast-parvw = c_re.
*      SELECT SINGLE vbeln parvw kunnr pernr adrnr
*               FROM vbpa
*               INTO st_vbpa
*               WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*        AND  parvw = c_re.  "
*      IF sy-subrc EQ 0.
*        SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
*          FROM adr6      "E-Mail Addresses (Business Address Services)
*          INTO v_send_email
*          WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
*        ENDSELECT.
*      ENDIF.
*    ENDIF.
* End of ADD:OTCM-30892/45037:SGUDA:30-SEP-2021:ED2K924647
    IF v_send_email IS INITIAL.
      READ TABLE r_sales_team_email INTO DATA(lst_sales_team_email) INDEX 1.
      IF sy-subrc EQ 0.
        v_send_email = lst_sales_team_email-low.
      ENDIF.
    ENDIF.
  ENDIF.
  IF v_send_email IS NOT INITIAL.
    CLEAR : li_send_email.
    APPEND v_send_email TO li_send_email.
  ENDIF.
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068

*- Using li_send_email internal table instead of v_send_email
*  IF v_send_email IS NOT INITIAL. by AMOHAMMED - 06/09/2020 - ED2K918223
  IF li_send_email IS NOT INITIAL.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

    IF v_ent_retco = 0 .
      lv_form = tnapr-sform.
      lst_outputparams-getpdf = abap_true.
      lst_outputparams-preview = abap_false.
    ENDIF. " IF fp_v_returncode = 0

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
          /1bcdwb/docparams  = lst_sfpdocparams "lst_outputparams
          im_hdr_itm         = li_hdr_itm "st_header
          im_logo            = v_logo
          im_bmp             = v_bmp
        IMPORTING
          /1bcdwb/formoutput = st_formoutput "lst_sfpdocparams "lst_docparams "st_formoutput
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

    IF lst_outputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.

      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = c_pdf "  class
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
*           Check if the subroutine is called in update task.
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF fp_v_returncode = 0
  ENDIF.
********Perform is used to call E098 FM  & convert PDF in to Binary

*  IF p_fp_v_returncode = 0.
  IF v_ent_retco = 0.
******CONVERT_PDF_BINARY
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = st_formoutput-pdf
      TABLES
        binary_tab = i_content_hex.
********Perform is used to create mail attachment with a creation of mail body
*- Using li_send_email internal table instead of v_send_email
*    IF v_send_email IS NOT INITIAL. by AMOHAMMED - 06/09/2020 - ED2K918223
    IF li_send_email IS NOT INITIAL. " by amohammed - 06/09/2020 - ed2k918223
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
FORM f_mail_attachment CHANGING p_fp_v_returncode TYPE sysubrc.

*- Declaration
  DATA: lr_sender     TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        li_lines      TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines     TYPE tline,                   " SAPscript: Text Lines
*- This variable was being created in the middel of the code now shifted here
        lv_flag_remit TYPE char1. " by AMOHAMMED - 06/09/2020 - ED2K918223

*- Local Constant Declaration
  CONSTANTS:
    lc_raw                    TYPE so_obj_tp      VALUE 'RAW',                   "Code for document class
    lc_parvw_zm               TYPE char02         VALUE 'ZM',
    lc_pdf                    TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
    lc_s                      TYPE bapi_mtype     VALUE 'S',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
    lc_st                     TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
    lc_object                 TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
    lc_kn_email_inv           TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_INV_F049',
    lc_kn_email_canc_inv      TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_CANC_INV_F049',
    lc_kn_email_cr            TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_CR_F049',
    lc_kn_email_dr            TYPE thead-tdname   VALUE 'ZQTC_KN_EMAIL_BODY_DR_F049',

*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- SO10 texts name for F061 form
    lc_kn_email_inv_f061      TYPE thead-tdname VALUE 'ZQTC_KN_EMAIL_BODY_INV_F061',
    lc_kn_email_canc_inv_f061 TYPE thead-tdname VALUE 'ZQTC_KN_EMAIL_BODY_CANC_INV_F061',
    lc_kn_email_cr_f061       TYPE thead-tdname VALUE 'ZQTC_KN_EMAIL_BODY_CR_F061',
    lc_kn_email_dr_f061       TYPE thead-tdname VALUE 'ZQTC_KN_EMAIL_BODY_DR_F061'.
*- End by AMOHAMMED - 06/09/2020 - ED2K918223

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
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- No data type is present for lv_type which lead to Extended program check message
*        lv_type.
        lv_type           TYPE bu_type.
*- ENd by by AMOHAMMED - 06/09/2020 - ED2K918223



* For SG Invoice the URL link https://paymentsqa.wiley.com to be provided to the payment portal.
  IF st_vbpa-parvw =  lc_parvw_zm."EQ 0.
    SELECT SINGLE name1 FROM adrc
                  INTO  v_er_name
                  WHERE addrnumber = st_vbpa-adrnr."lst_hd_adr_er-addr_no.
    IF v_er_name IS INITIAL.
      SELECT SINGLE ename FROM pa0001 INTO v_er_name WHERE pernr = st_vbpa-pernr.
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

*-Fetch the Contact person name from Bill-to
          SELECT SINGLE namev,
                        name1
          INTO @DATA(lst_knvk)
          FROM knvk
          WHERE kunnr EQ @st_vbpa-kunnr
          AND   pafkt EQ @c_z1.

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
    lv_doc_cat = text-004."Credit Memo
  ELSEIF  li_bil_invoice-hd_gen-bil_vbtype = c_debit. " 'P'
    lv_doc_cat  = text-005. "Debit Memo
  ELSE.
    IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
      lv_doc_cat = 'Canceled Invoice'(022).
    ELSE.
      lv_doc_cat = text-008. "Invoice
    ENDIF.
  ENDIF.

* Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*- Old logic is commented
*  IF li_bil_invoice-hd_org-division = c_10.   "OPM invoice email Content
*  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.
*    lv_name = lc_kn_email_cr.
*  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_debit.
*    lv_name = lc_kn_email_dr.
*  ELSE.
*    IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
*      lv_name = lc_kn_email_canc_inv.
*    ELSE.
*      lv_name = lc_kn_email_inv.
*      DATA(lv_flag_remit) = abap_true.
*    ENDIF.
*  ENDIF.
*- When output type is ZINV passing F049 SO10 texts to the subroutine
*- to fill the lv_name and lv_flag_remit
  CLEAR lv_flag_remit.
  IF v_formname = c_frm_name_f049. " ZINV
    PERFORM f_fill_object_name USING lc_kn_email_cr
                                     lc_kn_email_dr
                                     lc_kn_email_canc_inv
                                     lc_kn_email_inv
                               CHANGING lv_name
                                        lv_flag_remit.
  ELSEIF v_formname = c_frm_name_f061. " ZW00
*- When output type is ZW00 passing F061 SO10 texts to the subroutine
*- to fill the lv_name and lv_flag_remit
    PERFORM f_fill_object_name USING lc_kn_email_cr_f061
                                     lc_kn_email_dr_f061
                                     lc_kn_email_canc_inv_f061
                                     lc_kn_email_inv_f061
                               CHANGING lv_name
                                        lv_flag_remit.
  ENDIF.
* End by AMOHAMMED - 06/09/2020 - ED2K918223

  CONCATENATE text-014
              lv_doc_cat
              li_hdr_itm-hdr_gen-invoice_numb
*         INTO lv_subject SEPARATED BY space. "--VDPATABALL  ERPM-8349 12/10/2019
         INTO lv_sub SEPARATED BY space. "++VDPATABALL  ERPM-8349 12/10/2019


*  lv_sub = lv_subject. "--VDPATABALL  ERPM-8349 12/10/2019
  lv_subject = lv_sub. "++VDPATABALL  ERPM-8349 12/10/2019
********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = c_e "st_header-language
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
      REPLACE ALL OCCURRENCES OF '&G_INVOICE&' IN lst_message_body-line WITH li_hdr_itm-hdr_gen-invoice_numb.
      REPLACE ALL OCCURRENCES OF '&G_ES&'      IN lst_message_body-line WITH v_er_name.
      REPLACE ALL OCCURRENCES OF '&G_BP&'      IN lst_message_body-line WITH li_hdr_itm-hdr_gen-bill_to_name.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines

  ENDIF. " IF sy-subrc EQ 0
*---Begin of change VDPATABALL ERPM-8349 12/10/2019-getting standard text based on the company code/sale org.
  IF lv_flag_remit = abap_true.
    FREE :lv_name,li_lines.
    READ TABLE li_const INTO DATA(lst_const) WITH KEY param1 = c_remit
                                                      param2 = li_bil_invoice-hd_org-comp_code
                                                      high   = li_bil_invoice-hd_gen-bil_waerk.
    IF sy-subrc = 0.
      lv_name = lst_const-low.
    ENDIF.
********FM is used to SAPscript: Read text
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
*---End of change VDPATABALL  ERPM-8349 12/10/2019
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
  IF v_output_typ IN r_supplement_po_output AND li_bil_invoice-hd_ref-po_supplem IN r_supplement_po.
    CLEAR: li_lines[],li_message_body[].
    lv_name  = c_supp_email_body.
    CONCATENATE 'Your Invoice'(031) li_bil_invoice-hd_gen-bil_number 'With John Wiley & Sons'(032)
     INTO lv_subject SEPARATED BY space.
    lv_sub = lv_subject.
    PERFORM f_read_text USING lc_st c_e lv_name lc_object.
    IF sy-subrc EQ 0.
      LOOP AT li_lines_po INTO lst_lines.
        lst_message_body-line = lst_lines-tdline.
        APPEND lst_message_body-line TO li_message_body.
      ENDLOOP. " LOOP AT li_lines INTO lst_lines
    ENDIF.
  ENDIF.
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924068
  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw "'RAW'
      i_text = li_message_body
      i_subject = lv_subject ).
    CATCH cx_document_bcs ##NO_HANDLER.
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.
*        Send email with the attachments we are getting from FM
  TRY.
      lr_document->add_attachment(
      EXPORTING
      i_attachment_type = lc_pdf "'PDF'
      i_attachment_subject = lv_subject "'Wiley Edu Invoice Form - OPM' "lst_output-attachment_name+0(50)
      i_att_content_hex = i_content_hex ).
    CATCH cx_document_bcs INTO lx_document_bcs ##NO_HANDLER.
*Exception handling not required
  ENDTRY.

  TRY.
      CALL METHOD lr_send_request->set_message_subject
        EXPORTING
          ip_subject = lv_sub.
    CATCH cx_send_req_bcs.
  ENDTRY.
* Add attachment
  TRY.
      CALL METHOD lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
*Exception handling not required
  ENDTRY.

*- Using li_send_email internal table instead of v_send_email
*  IF v_send_email IS NOT INITIAL. by AMOHAMMED - 06/09/2020 - ED2K918223
  IF li_send_email IS NOT INITIAL. " by AMOHAMMED - 06/09/2020 - ED2K918223
* Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).
* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
* Create recipient
*- Using li_send_email internal table instead of v_send_email
    LOOP AT li_send_email ASSIGNING FIELD-SYMBOL(<ls_send_email>). " by AMOHAMMED - 06/09/2020 - ED2K918223
      TRY.
*- Begin by AMOHAMMED - 06/09/2020 - ED2K918223
*        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_send_email ).
          lr_recipient = cl_cam_address_bcs=>create_internet_address( <ls_send_email>-send_email ).
*- End by AMOHAMMED - 06/09/2020 - ED2K918223
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        CATCH cx_address_bcs ##NO_HANDLER.
        CATCH cx_send_req_bcs. ##NO_HANDLER
      ENDTRY.
    ENDLOOP. " by AMOHAMMED - 06/09/2020 - ED2K918223
* Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
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
          li_tvlvt,li_t001,li_count,li_itm_gen,
          " Referesh the e-mail addresses internal table
          li_send_email. " by AMOHAMMED - 06/09/2020 - ED2K918223

  CLEAR: st_address,
         st_formoutput,
         i_content_hex,
         repeat,
         nast_anzal,
         nast_tdarmod,
         v_division,
         v_sales_office,
         v_param1,
         v_fkimg,
         lst_itm_gen,
         lst_count,
         v_kzwi5,
*         v_formname,
         v_ent_retco,
         v_send_email,
         v_output_typ,
         v_logo,
         v_bmp,
         " BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
         v_ref_curr,       " Reference currency for currency translation
         v_to_curr,        " To-currency
         v_bill_date,      " Billing date
         " EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
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

* Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

* To Get a BDS Graphic in BMP Format
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
    " BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
    v_to_curr = v_cust_currency.
    " EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-sub_total
                                    v_cust_currency
                                    v_to_curr      " ++CR#ERPM-15476
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-tax
                                    v_cust_currency
                                    v_to_curr      " ++CR#ERPM-15476
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.
  ENDIF.

  IF v_doc_currency NE v_loc_currency AND v_cust_currency NE v_loc_currency.
    " BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
    v_to_curr = v_loc_currency.
    " EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-sub_total
                                    v_loc_currency
                                    v_to_curr      " ++CR#ERPM-15476
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-tax
                                    v_loc_currency
                                    v_to_curr      " ++CR#ERPM-15476
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
                           fp_v_waers      TYPE waers      " Currency Key
                           fp_v_to_curr    TYPE tcurr_curr " ++CR#ERPM-15476
                  CHANGING fp_lv_exc_rate  TYPE ukurs_curr        " Subtotal 6 from pricing procedure for condition
                           fp_lv_loc_amt   TYPE ukm_credit_limit. " Credit Limit

* Local data declaration
  DATA: li_exc_tab      TYPE zttqtc_exchange_tab_invoice,
        " BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
        lst_exch_rate   TYPE bapi1093_0,  " Struc: Exchange Rate
        lst_return_msg  TYPE bapiret1,    " Struc: Return Msg
        " EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
        lst_exc_tab     TYPE ztqtc_exchange_tab_invoice, " Exchange Rate table structure for invoice forms
        v_bill_date_ex  TYPE fkdat, "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
        v_price_date_ex TYPE fkdat. "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084

* --------------------------------------------------------------------------------- *

* Translate foreign currency amount to local currency

*--> BOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932
  " Before CR#ERPM-15476 changes, there is no IF v_doc_currency = v_ref_curr.
  " cond. check to get the Exchange Rate using FM: BAPI_EXCHANGERATE_GETDETAIL.
  " We have only one FM call 'CONVERT_TO_LOCAL_CURRENCY' to get the Exchange rate,
  " and conversion amount.
* Begin of ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
  CLEAR :v_bill_date_ex,v_price_date_ex.
  v_bill_date_ex = v_bill_date - 1.
  v_price_date_ex = v_price_date - 1.
* End of ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
  IF v_doc_currency = v_ref_curr.
    CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
      EXPORTING
        rate_type  = c_excrate_typ_m      " Exchange Rate type
        from_curr  = v_doc_currency       " Document Currency
        to_currncy = fp_v_to_curr         " Payer/Company Code Currency
*       date       = v_bill_date          " Billing Date "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
        date       = v_bill_date_ex        "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
      IMPORTING
        exch_rate  = lst_exch_rate
        return     = lst_return_msg.
*    IF sy-subrc = 0.                " by AMOHAMMED - 06/09/2020 - ED2K918223
    IF lst_exch_rate IS NOT INITIAL. " by AMOHAMMED - 06/09/2020 - ED2K918223
      fp_lv_exc_rate = lst_exch_rate-exch_rate.
      fp_lv_loc_amt = fp_lv_forgn_amt * fp_lv_exc_rate.
      CLEAR lst_exch_rate.
    ELSE.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ENDIF.

  ELSE.  " ELSE -> IF v_doc_currency = v_ref_curr.
*--> EOC: CR#ERPM-15476  KKRAVURI 08-APR-2020  ED2K917932

    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING
*--BOC: ERPM-4140 - SKKAIRAMKO 10/23/2019
*       date             = li_hdr_itm-hdr_gen-invoice_date "Currency translation date
*       date             = v_price_date  ""ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
        date             = v_price_date_ex   "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921084
*--EOC: ERPM-4140 - SKKAIRAMKO 10/23/2019
        foreign_amount   = fp_lv_forgn_amt        "Amount in foreign currency
        foreign_currency = v_doc_currency "Currency key for foreign currency
        local_currency   = fp_v_waers "Currency key for local currency
      IMPORTING
        exchange_rate    = fp_lv_exc_rate "Exchange rate
        local_amount     = fp_lv_loc_amt  "Amount in local currency
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
*  ELSE. " ELSE -> IF sy-subrc NE 0  " ++CR#ERPM-15476
      " Befor CR#ERPM-15476 changes, all the below Amount logic
      " is inside this ELSE block.
    ENDIF.

  ENDIF. " IF v_doc_currency = v_ref_curr.

* Amount
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
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
  IF v_doc_currency IN r_currency_from AND  v_cust_currency IN r_currency_to.
    DATA: lv_deci3 TYPE p DECIMALS 5,
          lv_deci4 TYPE char5,
          lv_deci2 TYPE p. "DECIMALS 2.
    lv_deci3 = fp_lv_loc_amt.
    lv_deci2 = ( floor( lv_deci3 * 100 ) ) / 100. "always rounded down
    lst_exc_tab-conv_amt = lv_deci2.
    WRITE lv_deci2 TO lst_exc_tab-conv_amt.
    SPLIT lst_exc_tab-conv_amt AT '.' INTO lst_exc_tab-conv_amt lv_deci4.
    CONDENSE lst_exc_tab-conv_amt.
  ELSE.
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
    WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY fp_v_waers.
    CONDENSE lst_exc_tab-conv_amt.
  ENDIF. "ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924671
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-conv_amt.


  APPEND lst_exc_tab TO li_exc_tab.
  CLEAR: lst_exc_tab,
         fp_lv_exc_rate,
         fp_lv_loc_amt.
  APPEND LINES OF li_exc_tab TO li_hdr_itm-itm_amounts.
*  ENDIF.  " CR#ERPM-15476

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_TAX_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
**FORM f_build_tax_info .
**  DATA : lst_tax_id TYPE ty_tax_id.
**  CONSTANTS : lc_tax_id   TYPE rvari_vnam VALUE 'TAX_ID',
**              lc_inv_desc TYPE rvari_vnam VALUE 'INVOICE_DESC'.
**  CLEAR : li_hdr_itm-hdr_gen-invoice_description,
**          li_hdr_itm-hdr_gen-seller_reg,
**          li_hdr_itm-hdr_gen-buyer_reg,v_seller_reg.
***- Tax Id
**  LOOP AT li_const INTO DATA(lst_const) WHERE param1 = lc_tax_id   .
**    lst_tax_id-land1 = lst_const-param2.
**    lst_tax_id-stceg = lst_const-low.
**    APPEND lst_tax_id TO i_tax_id.
**    CLEAR lst_tax_id.
**  ENDLOOP.
**
**  READ TABLE li_const INTO DATA(lst_const2) WITH KEY param1 = lc_inv_desc.
**  IF sy-subrc EQ 0.
**    v_inv_desc = lst_const2-low.
**  ENDIF.
***--*Customer VAT
**  IF i_tax_data IS NOT INITIAL.
**    DATA(li_tax_data) = i_tax_data.
**    SORT li_tax_data BY document doc_line_number.
**    DELETE li_tax_data WHERE buyer_reg IS INITIAL.
**    DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING document doc_line_number.
**    DATA(lv_lines) = lines( li_tax_data ).
**    LOOP AT li_tax_data INTO DATA(lst_tax_data1).
**      IF lv_lines = 1.
**        li_hdr_itm-hdr_gen-buyer_reg = lst_tax_data1-buyer_reg.
**      ENDIF. " IF lv_lines = 1
**      IF lst_tax_data1-invoice_desc CS v_inv_desc
**        AND v_invoice_desc IS INITIAL.
**        v_invoice_desc = lst_tax_data1-invoice_desc.
**      ENDIF. " IF lst_tax_data-invoice_desc CS v_inv_desc
**    ENDLOOP. " LOOP AT li_tax_data INTO DATA(lst_tax_data)
***--*Tax ID
**    DATA(li_tax_seller) = i_tax_data.
**    SORT li_tax_seller BY seller_reg.
**    DELETE li_tax_seller WHERE seller_reg IS INITIAL.
**    DELETE ADJACENT DUPLICATES FROM li_tax_seller COMPARING seller_reg.
**    SORT li_tax_seller BY document doc_line_number.
**
**    DATA(li_tax_buyer) = i_tax_data.
**    SORT li_tax_buyer BY document doc_line_number.
**    DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
**    DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.
**
**    DATA(li_tax_temp) = i_tax_data.
**    DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
**    SORT li_tax_temp BY buyer_reg.
**    DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
**    DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
**    IF lv_tax_line EQ 1.
**      READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
**      IF sy-subrc EQ 0.
**        li_hdr_itm-hdr_gen-buyer_reg = lst_tax_temp-buyer_reg.
**      ENDIF. " IF sy-subrc EQ 0
**    ENDIF.
***--BOC: SKKAIRAMKO
**
**        READ TABLE i_tax_id INTO lst_tax_id
**               WITH KEY land1 = v_comp_code_ctry.
**          IF sy-subrc EQ 0.
**            IF v_seller_reg IS INITIAL.
**              v_seller_reg = lst_tax_id-stceg.
**            ELSEIF v_seller_reg NS lst_tax_id-stceg.
**              CONCATENATE lst_tax_id-stceg v_seller_reg INTO v_seller_reg SEPARATED BY ','.
**            ENDIF. " IF v_seller_reg IS INITIAL
**          ENDIF. " IF sy-subrc EQ 0
**
***-- EOC: SKKAIRAMKO
**    LOOP AT li_bil_invoice-it_price  INTO DATA(lst_inv_it).
**      READ TABLE li_tax_seller INTO DATA(lst_tax_seller) WITH KEY document = lst_inv_it-bil_number
**                                                              doc_line_number = lst_inv_it-itm_number
**                                                             BINARY SEARCH.
**      IF sy-subrc EQ 0.
**        IF v_seller_reg IS INITIAL.
**          v_seller_reg = lst_tax_seller-seller_reg.
**        ELSE.
**          CONCATENATE v_seller_reg lst_tax_seller-seller_reg  INTO v_seller_reg SEPARATED BY ', '.
**        ENDIF.
***      ELSEIF lst_inv_it-kzwi6 IS NOT INITIAL.
***        IF v_comp_code_ctry EQ li_bil_invoice-hd_gen-dlv_land.
***          READ TABLE i_tax_id INTO lst_tax_id
***               WITH KEY land1 = li_bil_invoice-hd_gen-dlv_land.
***          IF sy-subrc EQ 0.
***            IF v_seller_reg IS INITIAL.
***              v_seller_reg = lst_tax_id-stceg.
***            ELSEIF v_seller_reg NS lst_tax_id-stceg.
***              CONCATENATE lst_tax_id-stceg v_seller_reg INTO v_seller_reg SEPARATED BY ','.
***            ENDIF. " IF v_seller_reg IS INITIAL
***          ENDIF. " IF sy-subrc EQ 0
***        ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
**      ENDIF. " IF sy-subrc EQ 0
**    ENDLOOP.
**
**    IF v_seller_reg IS NOT INITIAL.
**      CONDENSE v_seller_reg.
**      li_hdr_itm-hdr_gen-seller_reg = v_seller_reg.
***    ELSEIF v_comp_code_ctry EQ li_bil_invoice-hd_gen-dlv_land.
***      READ TABLE i_tax_id INTO lst_tax_id
***           WITH KEY land1 = li_bil_invoice-hd_gen-dlv_land.
***      IF sy-subrc EQ 0.
***        li_hdr_itm-hdr_gen-seller_reg = lst_tax_id-stceg.
***      ENDIF.
**    ENDIF.
**
**
**    li_hdr_itm-hdr_gen-invoice_description =  v_invoice_desc.
**  ENDIF.
**ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ZCACONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_DEVID  text
*----------------------------------------------------------------------*
FORM f_get_zcaconstant USING p_c_devid TYPE zdevid.
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  CONSTANTS: lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE'.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
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
    WHERE devid EQ @p_c_devid
      AND activate EQ @abap_true.
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  LOOP AT li_const INTO DATA(lst_constant).
    IF lst_constant-param1 EQ lc_comp_code.
      APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
      <lst_comp_code>-sign   = lst_constant-sign.
      <lst_comp_code>-option = lst_constant-opti.
      <lst_comp_code>-low    = lst_constant-low.
      <lst_comp_code>-high   = lst_constant-high.
    ENDIF.
    IF lst_constant-param1 EQ lc_docu_currency.
      APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
      <lst_docu_currency>-sign   = lst_constant-sign.
      <lst_docu_currency>-option = lst_constant-opti.
      <lst_docu_currency>-low    = lst_constant-low.
      <lst_docu_currency>-high   = lst_constant-high.
    ENDIF.
    IF lst_constant-param1 EQ lc_sales_office.
      APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
      <lst_sales_office>-sign   = lst_constant-sign.
      <lst_sales_office>-option = lst_constant-opti.
      <lst_sales_office>-low    = lst_constant-low.
      <lst_sales_office>-high   = lst_constant-high.
    ENDIF.
  ENDLOOP.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_OBJECT_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_KN_EMAIL_CR  text
*      -->P_LC_KN_EMAIL_DR  text
*      -->P_LC_KN_EMAIL_CANC_INV  text
*      -->P_LC_KN_EMAIL_INV  text
*      <--P_LV_FLAG_REMIT  text
*----------------------------------------------------------------------*
FORM f_fill_object_name USING    p_lc_kn_email_cr       TYPE tdobname
                                 p_lc_kn_email_dr       TYPE tdobname
                                 p_lc_kn_email_canc_inv TYPE tdobname
                                 p_lc_kn_email_inv      TYPE tdobname
                        CHANGING p_lv_name              TYPE tdobname
                                 p_lv_flag_remit        TYPE char1.
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.
    p_lv_name = p_lc_kn_email_cr.
  ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_debit.
    p_lv_name = p_lc_kn_email_dr.
  ELSE.
    IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
      p_lv_name = p_lc_kn_email_canc_inv.
    ELSE.
      p_lv_name = p_lc_kn_email_inv.
      p_lv_flag_remit = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_ST  text
*      -->P_C_E  text
*      -->P_LV_NAME  text
*      -->P_LC_OBJECT  text
*----------------------------------------------------------------------*
FORM f_read_text  USING    p_lc_st
                           p_c_e
                           p_lv_name
                           p_lc_object.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = p_lc_st
      language                = p_c_e
      name                    = p_lv_name
      object                  = p_lc_object
    TABLES
      lines                   = li_lines_po
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_AR_TEXT_FOR_EMAILID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_BIL_INVOICE_HD_REF_ORDER_NU  text
*      <--P_V_SEND_EMAIL  text
*----------------------------------------------------------------------*
FORM get_ar_text_for_emailid  USING    p_li_bil_invoice_hd_ref_ord_nu
                              CHANGING p_v_send_email.
  TYPES: sx_addr_type TYPE sx_addrtyp, "R/3 Addresstype
         sx_addr      TYPE so_rec_ext . "Address in plain string
  TYPES: BEGIN OF sx_address,           "SAPconnect general addr
           type    TYPE sx_addr_type,
           address TYPE sx_addr,
         END OF sx_address.
  CONSTANTS: lc_object TYPE thead-tdobject VALUE 'VBBK',         " AR Internal Notes Text
             lc_id     TYPE thead-tdid  VALUE '0005',
             lc_int    TYPE sx_addr_type VALUE 'INT'.  "SMTP address
  DATA : li_tline          TYPE TABLE OF tline,
         lst_tline         TYPE tline,
*         lsst_email        TYPE ty_email,
         lst_tdname        TYPE thead-tdname,
         ls_addr_unst      TYPE sx_address,
         ls_addr           TYPE sx_address,
         lv_address_normal TYPE sx_address,
         lv_local          TYPE sx_addr,
         lv_domain         TYPE sx_addr,
         lv_comment        TYPE sx_addr.
* Get Sales Document
  lst_tdname = p_li_bil_invoice_hd_ref_ord_nu.
* Get AR internal text for standing Order email ID
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_id
      language                = c_e
      name                    = lst_tdname
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
  IF sy-subrc EQ 0.
* Get Email ID
    DESCRIBE TABLE li_tline LINES DATA(lst_lines).
    READ TABLE li_tline INTO lst_tline INDEX lst_lines.
    IF  sy-subrc EQ 0.
      ls_addr_unst-type    = lc_int.
      ls_addr_unst-address = lst_tline-tdline.
* Validation for Email ID
      CALL FUNCTION 'SX_INTERNET_ADDRESS_TO_NORMAL'
        EXPORTING
          address_unstruct     = ls_addr_unst
        IMPORTING
          address_normal       = lv_address_normal
          local                = lv_local
          domain               = lv_domain
          comment              = lv_comment
          addr_normal_no_upper = ls_addr
        EXCEPTIONS
          error_address_type   = 1
          error_address        = 2
          error_group_address  = 3
          OTHERS               = 4.
      IF sy-subrc EQ 0.
        p_v_send_email = lst_tline-tdline.
        CONDENSE p_v_send_email.
      ENDIF.
    ENDIF.
  ELSE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAIL_IDS_MULTI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_SEND_EMAIL  text
*----------------------------------------------------------------------*
FORM f_get_email_ids_multi CHANGING p_li_send_email TYPE tt_send_email.
  DATA:lv_person_numb   TYPE prelp-pernr.                " Person Number
  IF nast-parvw = c_re.
    SELECT SINGLE vbeln parvw kunnr pernr adrnr
             FROM vbpa
             INTO st_vbpa
             WHERE vbeln = li_bil_invoice-hd_ref-order_numb
      AND  parvw = c_re.  "
    IF sy-subrc EQ 0.
      SELECT smtp_addr  "E-Mail Address
        FROM adr6      "E-Mail Addresses (Business Address Services)
        INTO TABLE p_li_send_email
        WHERE addrnumber EQ st_vbpa-adrnr "st_hd_adr-addr_no ##WARN_OK.
          AND persnumber EQ space.  "++ mimmadiset 3/10/2022OTCM-59020 ED2K926018 "Read the partner related email id's only
      IF sy-subrc NE 0 AND p_li_send_email[] IS INITIAL .
        SELECT SINGLE prsnr "E-Mail Address
                 FROM knvk      "E-Mail Addresses (Business Address Services)
                 INTO v_persn_adrnr
                 WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
                   AND   pafkt = c_z1 ##WARN_OK.
        IF sy-subrc EQ 0.
          SELECT  smtp_addr "E-Mail Address
                   FROM adr6      "E-Mail Addresses (Business Address Services)
                   INTO TABLE p_li_send_email
                   WHERE persnumber EQ v_persn_adrnr.
          IF p_li_send_email[] IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-018.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-018.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-017.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE. "check for ER
    SELECT SINGLE vbeln parvw kunnr pernr adrnr
             FROM vbpa
             INTO st_vbpa
             WHERE vbeln = li_bil_invoice-hd_ref-order_numb
               AND  parvw = c_er. "ER - Employee responsible
    IF sy-subrc EQ 0.
      SELECT smtp_addr  "E-Mail Address
        FROM adr6      "E-Mail Addresses (Business Address Services)
        INTO TABLE p_li_send_email
        WHERE addrnumber EQ st_vbpa-adrnr. ##WARN_OK
      IF sy-subrc NE 0 AND p_li_send_email[] IS INITIAL.
        lv_person_numb = st_vbpa-pernr.
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
*           TCLAS           = 'A'
            pernr           = lv_person_numb
            infty           = c_105
            begda           = c_start
            endda           = c_end
          TABLES
            infty_tab       = li_person_mail_id
          EXCEPTIONS
            infty_not_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0.
* Implement suitable error handling here
          READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id)
            WITH KEY pernr =  lv_person_numb
                     usrty = c_0010.
          IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
            v_send_email = lst_person_mail_id-usrid_long.
            APPEND v_send_email TO p_li_send_email.
          ELSE.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-016.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-016.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF. " IF sy-subrc NE 0
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-015.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ENDIF.
ENDFORM.
