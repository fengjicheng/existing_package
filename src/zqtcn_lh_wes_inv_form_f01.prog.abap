*&---------------------------------------------------------------------*
*&  Include           ZQTCN_LH_WES_OPM_INV_FORM_F01
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_LH_WES_INV_FORM_F01
* PROGRAM DESCRIPTION: This driver program implemented for OPM , SG/AC invoice forms
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 02/26/2018
* OBJECT ID: F046.01
* TRANSPORT NUMBER(S): ED2K914566
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910591
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:SPARIMI
* DATE:  07/15/2019
* DESCRIPTION:OPM UK Invoice and Credit Memo Changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910678
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:SPARIMI
* DATE:  07/19/2019
* DESCRIPTION:Tax Issue changes for the Credit Memos
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K911402
* REFERENCE NO: ERPM-8672
* DEVELOPER :VDPATABALL
* DATE:  12/11/2019
* DESCRIPTION:Email subject and Email body changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917384
* REFERENCE NO: ERPM-10414
* DEVELOPER :VDPATABALL
* DATE:  22/01/2020
* DESCRIPTION:If the Transmission Type 5 then trigger the email only
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917923
* REFERENCE NO: ERPM-15475
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 07/APR/2020
* DESCRIPTION: The correct exchange rate for compliance and
*              customer service
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920368
* REFERENCE NO    : OTCM-32214 & OTCM-32330(F046)
* DEVELOPER       : VDPATABALL
* DATE            : 11/23/2020
* DESCRIPTION     : WES DA-Invoice,Debit and Credit form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920979,ED2K922181,ED2K922420
* REFERENCE NO    : OTCM 30816,OTCM-42939(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 12/23/2020
* DESCRIPTION     : OTCM 30816:Mthree Invoice,Debit and Credit form changes.
* Changing the customer service email id
* OTCM-42939:for Handling the decimal change for Hungary
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-30892
* REFERENCE NO:  ED2K921723
* DEVELOPER   :  SGUDA
* DATE        :  02/08/2021
* DESCRIPTION :  Standing Orders
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42109
* REFERENCE NO:  ED2K921982
* DEVELOPER   :  MIMMADISET
* DATE        : 02/17/2021
* DESCRIPTION : Read the sales org address based on zcaconstant entry
*              for 1030.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-31644
* REFERENCE NO:  ED2K92108
* DEVELOPER   :  SGUDA
* DATE        :  03/09/2021
* DESCRIPTION :  Exchange Rates Alignment between Batch and Manual Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-45037/OTCM-30892
* REFERENCE NO:  ED2K924064/ED2K924442
* DEVELOPER   :  SGUDA
* DATE        :  08/JULY/2021 and 30/SEP/2021
* DESCRIPTION :  Auto-send email externally with invoices for Standing Orders
* 1) Send BP Email id if Supplementry PO is 'SO'.
* 2) otherwise YBPERRORACK@wiley.com
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924206,ED2K924265,ED2K924356
* REFERENCE NO    : OTCM-49815(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 07/28/2021
* DESCRIPTION     : Mthree changes for displaying the title based on sales org
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924322
* REFERENCE NO    : OTCM-50424(f046.2)
* DEVELOPER       : mimmadiset
* DATE            : 08/19/2021
* DESCRIPTION     : Due Date logic change for mthree sales org (Early Settlement Discount)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924442
* REFERENCE NO    : OTCM-44643(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 08/31/2021
* DESCRIPTION     : Mthree changes for 3501 sales org to display cancel notes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42834 INC0333245
* REFERENCE NO:  ED2K924665
* DEVELOPER   :  Sivareddy Guda (SGUDA)
* DATE        :  30/SEP/2021
* DESCRIPTION :  Exchange rate rounding causing JPY amount on invoice to be incorrect
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924913
* REFERENCE NO    : OTCM-53499
* DEVELOPER       : mimmadiset
* DATE            : 11/18/2021
* DESCRIPTION     : Mthree title changes for bill type ZHCR
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K924913
* REFERENCE NO    : OTCM-44643(F046.2)/OTCM-42633
* DEVELOPER       : mimmadiset
* DATE            : 08/31/2021
* DESCRIPTION     : Mthree changes for 3501 sales org to display cancel notes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925092
* REFERENCE NO    : OTCM-55113
* DEVELOPER       : mimmadiset
* DATE            : 12/03/2021
* DESCRIPTION     : Rush changes for 1030 sales org and output type ZXYI
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925263
* REFERENCE NO    : OTCM-55639
* DEVELOPER       : mimmadiset
* DATE            : 12/14/2021
* DESCRIPTION     : Rush changes for 1030 sales org and output type ZXYI
* 1.Sort the items based on posnr
* 2.Populate the tax id
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED1K913660
* REFERENCE NO    : INC0404683
* DEVELOPER       : ARGADEELA
* DATE            : 10/29/2021
* DESCRIPTION     : Remit to details on Email body for 1030CC is changed
*                    for ZSGA output
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925315
* REFERENCE NO    : OTCM-55093
* DEVELOPER       : mimmadiset
* DATE            : 12/20/2021
* DESCRIPTION     : Multiple email-id s functioanlity for all sales org in F046
*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925664
* REFERENCE NO    : OTCM-58367
* DEVELOPER       : mimmadiset
* DATE            : 02/01/2022
* DESCRIPTION     : Email logic for Austraila
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925763
* REFERENCE NO    : OTCM-59059
* DEVELOPER       : mimmadiset
* DATE            : 02/11/2022
* DESCRIPTION     : Adding the invoice changes for Mthree Austraila
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925928
* REFERENCE NO    : OTCM-57535
* DEVELOPER       : Sivareddy Guda (SGUDA)
* DATE            : 03/02/2022
* DESCRIPTION     : Email verbiage changes for RUSH Project
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K926874
* REFERENCE NO    : OTCM-62551
* DEVELOPER       : Murali (immadiset)
* DATE            : 04/19/2022
* DESCRIPTION     : Label change for M3 Australia
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K927166,ED2K927388
* REFERENCE NO    : OTCM-61946
* DEVELOPER       : Murali (mimmadiset)
* DATE            : 05/06/2022
* DESCRIPTION     : Contract start date and end date in mthree output types
*&---------------------------------------------------------------------*
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
*
*- determine print data
  PERFORM f_set_print_data_to_read.
*
*- select print data
  PERFORM f_get_data.
*
*- Build header and item structur for Adobe form
  PERFORM f_build_hdr_itm_for_form.
*- OPM form
  IF   v_output_typ = c_zopm           "ZOPM

    OR v_output_typ = c_zcda.       "CDA "++VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
    v_formname = c_zopm_form_name.
*- SG/AC form
  ELSEIF v_output_typ = c_zsga.       "ZSGA
    v_formname = c_zsga_form_name.
*- Debit/Credit form
  ELSEIF v_output_typ = c_zdcm       "ZDCM
    OR   v_output_typ = c_zdam      "ZDAM "++VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
* Begin of ADD:OTCM-30892:SGUDA:08-FEB-2021:ED2K921723
    OR   v_output_typ = c_zscm.
* End of ADD:OTCM-30892:SGUDA:08-FEB-2021:ED2K921723
    v_formname = c_zdcm_form_name.
  ELSEIF v_output_typ = c_zm3c OR   "++mimmadiset:OTCM 30816:12/23/2020:ED2K920979
       v_output_typ = c_zxyi.   "++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
    v_formname = c_zm3c_form_name.
  ENDIF.
* Perform has been used to send mail with an attachment of PDF
  IF v_ent_screen  EQ abap_false.
    PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
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
*--> BOC: SPARIMI - 07/15/19 ED1K910591
  CONSTANTS : lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
              lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
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
    IF sy-subrc <> 0.
*        do nothing
    ENDIF.
*- Material Description
    SELECT matnr mtpos FROM mvke
             INTO TABLE li_mvke
             FOR ALL ENTRIES IN li_bil_invoice-it_gen
             WHERE matnr = li_bil_invoice-it_gen-material.
    IF sy-subrc <> 0.
*        do nothing
    ENDIF.
  ENDIF.

*--> BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
  v_bill_date = li_bil_invoice-hd_gen-bil_date.
  " Fetch Reference Currency of the Exchange Rate
  SELECT SINGLE bwaer FROM tcurv INTO v_ref_curr
                      WHERE kurst = c_excrate_typ_m.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.
*--> EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923

  IF li_bil_invoice-hd_part_add[] IS NOT INITIAL.
*- Partner Number
    SELECT kunnr adrnr stceg FROM kna1
             INTO TABLE li_kna1
             FOR ALL ENTRIES IN li_bil_invoice-hd_part_add
             WHERE kunnr = li_bil_invoice-hd_part_add-partn_numb.
    IF sy-subrc <> 0.
*        do nothings
    ENDIF.
    IF li_kna1[] IS NOT INITIAL.
*- Customer Address detailes
      SELECT addrnumber name1 name_co  city1  post_code1 street region country
               FROM adrc
               INTO TABLE li_adrc_part
               FOR ALL ENTRIES IN li_kna1
               WHERE addrnumber = li_kna1-adrnr.
      IF sy-subrc <> 0.
*          do nothing
      ENDIF.
    ENDIF.
  ENDIF.

  IF  li_bil_invoice-it_gen[] IS NOT INITIAL.
*- Release order usage ID: Texts
    SELECT spras abrvw bezei FROM tvlvt
             INTO TABLE li_tvlvt
             FOR ALL ENTRIES IN li_bil_invoice-it_gen
             WHERE abrvw = li_bil_invoice-it_gen-vkaus.
    IF sy-subrc <> 0.
*        do nothing
    ENDIF.
  ENDIF.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
*  IF  li_bil_invoice-hd_org-salesorg IS NOT INITIAL.
  IF  li_bil_invoice-hd_org-comp_code IS NOT INITIAL.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*- Company Codes
    SELECT bukrs adrnr waers stceg FROM t001
             INTO TABLE li_t001
*--> BOC: SPARIMI - 07/15/19 ED1K910591
*             WHERE bukrs = li_bil_invoice-hd_org-salesorg.
             WHERE bukrs = li_bil_invoice-hd_org-comp_code.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
    IF sy-subrc <> 0.
*         do nothing
    ENDIF.
    IF li_t001[] IS NOT INITIAL.
*- Addresses (Business Address Services)
      SELECT addrnumber city1 post_code1 street house_num1 region country
             FROM adrc
             INTO TABLE li_adrc
             FOR ALL ENTRIES IN li_t001
             WHERE addrnumber = li_t001-adrnr."'0000067895'."li_bil_invoice-hd_org-salesorg_adr.
      IF sy-subrc <> 0.
*          do nothing
      ENDIF.
    ENDIF.
*- Additional Specifications for Company Code
    SELECT bukrs party  paval
           FROM t001z
           INTO TABLE li_t001z
           WHERE bukrs = li_bil_invoice-hd_org-salesorg.
    IF sy-subrc <> 0.
*          do nothing
    ENDIF.
  ENDIF.
  IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
*- Billing Document: Header Data
    SELECT vbeln zterm fkdat bukrs taxk1
             knumv  "++VDPATABALL
             FROM vbrk
             INTO TABLE li_vbrk
             WHERE vbeln = li_bil_invoice-hd_gen-bil_number.
    IF sy-subrc <> 0.
*      do nothing
    ENDIF.
  ENDIF.

*--> BOC: SPARIMI - 07/15/19 ED1K910591
*--*Doc Currency
  v_doc_currency = li_bil_invoice-hd_gen-bil_waerk.
*--*Customer Currency
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_hd_part) WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
                                                                 bil_item = c_hdr_posnr
                                                                 partn_role = c_re.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_hd_part-partn_numb.
    IF sy-subrc EQ 0.
*--*Customer VAT
      v_vat = lst_kna1-stceg.
      READ TABLE li_adrc_part INTO DATA(lst_adrc) WITH KEY addrnumber = lst_kna1-adrnr.
      IF sy-subrc EQ 0.
*Retrieve local currency from T005 table
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

*--*Tax data
  SELECT document,
             doc_line_number,
             buyer_reg,
             seller_reg,     " Seller VAT Registration Number
             invoice_desc    " Invoice Description
        FROM /idt/d_tax_data " Tax Data
        INTO TABLE @i_tax_data
        WHERE company_code = @li_bil_invoice-hd_org-comp_code
        AND   fiscal_year = @lc_gjahr
        AND   document_type = @lc_doc_type
        AND   document = @li_bil_invoice-hd_gen-bil_number.
  IF sy-subrc EQ 0.
    SORT i_tax_data BY document doc_line_number.
  ENDIF. " IF sy-subrc

*--> EOC: SPARIMI - 07/15/19 ED1K910591
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROTOCOL_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_protocol_update .

*  CHECK v_ent_screen = space.
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
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_PRINT_DATA_TO_READ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_print_data_to_read .
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
         lv_kbetr           TYPE kbetr,                   " Price
         lst_tax_item_final TYPE zstqtc_tax_item_f042,    " Structure for tax components
         i_tax_item         TYPE zttqtc_tax_item_f042,    " Rate (condition amount or percentage)
         lv_due_date        TYPE bseg-zfbdt,              " Due date
         li_tline           TYPE TABLE OF tline,          " Material Sales Text
         lv_sal_mat_text    TYPE string,                  " Material Sales Text
         lv_name            TYPE thead-tdname,            " Name
*--> BOC: SPARIMI - 07/15/19 ED1K910591
         lv_address_number  TYPE adrc-addrnumber,
         li_bill_to_addr    TYPE TABLE OF szadr_printform_table_line,
         li_ship_to_addr    TYPE TABLE OF szadr_printform_table_line,
         lst_bill_to_addr   TYPE szadr_printform_table_line,
         lst_ship_to_addr   TYPE szadr_printform_table_line,
         lv_lines           TYPE tdline,
         i_month_names      TYPE ftps_web_month_t, " Month name and short text ++ OTCM-61946:ED2K927166:mimmadiset:05/06/2022
         li_top             TYPE STANDARD TABLE OF vtopis. "++skkairamko
*--> EOC: SPARIMI - 07/15/19 ED1K910591

  CONSTANTS : lc_percent TYPE char1 VALUE '%',                     " Percent of type CHAR1
              lc_prod    TYPE char4 VALUE 'EP1',                   " For Production system
              lc_vkbur   TYPE vkbur VALUE '0100',                  " Sales Office
              lc_id      TYPE rstxt-tdid VALUE '0001',             " Material Sales Text
              lc_kschl   TYPE rvari_vnam VALUE 'ADD_KSCHL',        " Condition type
              lc_object  TYPE rstxt-tdobject VALUE 'MVKE',         " Material texts, sales
              lc_posnr   TYPE posnr      VALUE '000000'. "++ OTCM-61946:ED2K927166:mimmadiset:05/06/2022

*--------------------------------------------------------------------*
  IF li_bil_invoice-it_kond[] IS NOT INITIAL.
    SORT li_bil_invoice-it_kond BY kposn.
    DELETE li_bil_invoice-it_kond WHERE koaid NE 'D'.
  ENDIF.
*- Sales Org Detailes
*--> BOC: SPARIMI - 07/15/19 ED1K910591
*  READ TABLE li_t001 INTO DATA(lst_t001) WITH KEY bukrs = li_bil_invoice-hd_org-salesorg.
  READ TABLE li_t001 INTO DATA(lst_t001) WITH KEY bukrs = li_bil_invoice-hd_org-comp_code.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-tax_id = lst_t001-stceg.
    READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_t001-adrnr.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-sales_org_name   = li_bil_invoice-hd_org-salesorg.
      li_hdr_itm-hdr_gen-sales_org_adrnr  = lst_adrc-addrnumber.
      li_hdr_itm-hdr_gen-sales_org_house1 = lst_adrc-house_num1.
      li_hdr_itm-hdr_gen-sales_org_street = lst_adrc-street.
      li_hdr_itm-hdr_gen-sales_org_city1  = lst_adrc-city1.
      li_hdr_itm-hdr_gen-sales_org_reg    = lst_adrc-region.
      li_hdr_itm-hdr_gen-sales_org_post1  = lst_adrc-post_code1.
    ENDIF.
  ENDIF.
*- Tax Id
  READ TABLE li_t001z INTO DATA(lst_t001z) WITH KEY bukrs = li_bil_invoice-hd_org-salesorg.
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-tax_id = lst_t001z-paval.
  ENDIF.
*- Customer Sevice mail ID
  IF li_bil_invoice-hd_org-division = c_20.
    li_hdr_itm-hdr_gen-cust_service = c_cust_mail_20.
  ELSE.
    li_hdr_itm-hdr_gen-cust_service = c_cust_mail.
  ENDIF.
*- Invoice Number
  li_hdr_itm-hdr_gen-invoice_numb =  li_bil_invoice-hd_gen-bil_number.
*- Client Number
  li_hdr_itm-hdr_gen-client_numb = li_bil_invoice-hd_gen-sold_to_party.
*- Tax exempt text
  READ TABLE li_vbrk INTO DATA(lst_vbrk) WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number.
  IF lst_vbrk-taxk1 = 0.
    li_hdr_itm-hdr_gen-tax_expt_text = text-007. " Tax Exempt.
  ELSE.
    CLEAR li_hdr_itm-hdr_gen-tax_expt_text .
  ENDIF.
*- Invoice Text basec on the SD Document Category
  IF  li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice
    CONCATENATE text-019 li_bil_invoice-hd_gen-bil_number INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
    li_hdr_itm-hdr_gen-cancel_inv_text = text-021. "Ref. Invoice No
    li_hdr_itm-hdr_gen-cancel_coolen = c_colen.
  ELSE. " if it is Regular Invoice
    CONCATENATE text-020 li_bil_invoice-hd_gen-bil_number INTO li_hdr_itm-hdr_gen-invoice_text SEPARATED BY space.
  ENDIF.
*- Cancelled Invoice Number
  li_hdr_itm-hdr_gen-cancel_inv_no = li_bil_invoice-hd_gen-sfakn.
*- Billing Date
  li_hdr_itm-hdr_gen-invoice_date =  li_bil_invoice-hd_gen-bil_date.
*- Payment term text
  li_hdr_itm-hdr_gen-terms = li_bil_invoice-hd_gen_descript-name_paymterm.
*- Payment term calc date
*--BOC: SKKAIRAMKO - 07/18/2019
*  CALL FUNCTION 'J_1A_SD_CI_DUEDATE_GET'
*    EXPORTING
*      iv_vbeln                 = lst_vbrk-vbeln
*      iv_zterm                 = lst_vbrk-zterm
*      iv_ratnr                 = 1
*    IMPORTING
*      ev_netdate               = lv_due_date
*    EXCEPTIONS
*      fi_document_not_found    = 1
*      payment_terms_incomplete = 2
*      invoice_not_found        = 3
*      OTHERS                   = 4.
*
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ELSE.
*    li_hdr_itm-hdr_gen-due_date =   lv_due_date.
*  ENDIF.
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
    li_hdr_itm-hdr_gen-due_date =  lst_top-hdatum."lv_due_date."
**BOC mimmadiset:OTCM-50424:08/19/2021:ED2K924322
    IF v_output_typ = c_zm3c OR
      v_output_typ = c_zxyi."++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
      DESCRIBE TABLE li_top LINES DATA(lv_due).
      READ TABLE li_top INTO lst_top INDEX lv_due..
      IF sy-subrc = 0.
        li_hdr_itm-hdr_gen-due_date =  lst_top-hdatum."lv_due_date."
      ENDIF.
    ENDIF.
**EOC mimmadiset:OTCM-50424:08/19/2021:ED2K924322
  ENDIF.
*--EOC: SKKAIRAMKO - 07/18/2019

*- IF Pay immediately, passing Invoice created date
  IF li_hdr_itm-hdr_gen-due_date IS INITIAL  AND lst_vbrk-zterm = c_0001.
    li_hdr_itm-hdr_gen-due_date = li_hdr_itm-hdr_gen-invoice_date.
  ENDIF.
*- PO Number
  li_hdr_itm-hdr_gen-po_no = li_bil_invoice-hd_ref-purch_no_c."purch_no.
*- Bill-to Details
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_part) WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
                                                                     partn_role = c_re.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO DATA(lst_adrc_part) WITH KEY addrnumber = lst_kna1-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-bill_to_name = lst_adrc_part-name1.
*---Begin of change and comments VDPATABALL  ERPM-8672
*        IF lst_adrc_part-name_co IS NOT INITIAL.
*          CONCATENATE text-006 lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-bill_to_attin SEPARATED BY c_colen.
*        ENDIF.
*        li_hdr_itm-hdr_gen-bill_to_street   = lst_adrc_part-street.
*        li_hdr_itm-hdr_gen-bill_to_city1    = lst_adrc_part-city1.
*        li_hdr_itm-hdr_gen-bill_to_region   = lst_adrc_part-region.
*        li_hdr_itm-hdr_gen-bill_to_post     = lst_adrc_part-post_code1.
*        li_hdr_itm-hdr_gen-bill_to_address  = lst_kna1-adrnr.
        li_hdr_itm-hdr_gen-vat_no = lst_kna1-stceg.
        FREE:lv_address_number.
        lv_address_number = lst_kna1-adrnr.
        IF lv_address_number IS NOT INITIAL.
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
            READ TABLE li_bill_to_addr ASSIGNING FIELD-SYMBOL(<lst_bill_to>) WITH KEY line_type = '5'. "C/o Name
            IF sy-subrc EQ 0.
              CONCATENATE text-006 <lst_bill_to>-address_line INTO  <lst_bill_to>-address_line SEPARATED BY space.
            ENDIF.
          ENDIF.

          IF li_bill_to_addr IS NOT INITIAL.
            LOOP AT li_bill_to_addr INTO lst_bill_to_addr.
              lv_lines = lst_bill_to_addr-address_line.
              APPEND lv_lines TO  li_hdr_itm-it_bill_to_addr.

            ENDLOOP.
          ENDIF.
        ENDIF.
*---End of change and comments VDPATABALL   ERPM-8672
      ENDIF.
    ENDIF.
  ENDIF.
*- Ship-to Details
  READ TABLE li_bil_invoice-hd_part_add INTO lst_part WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
                                                                     partn_role = c_we.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO lst_kna1 WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO lst_adrc_part WITH KEY addrnumber = lst_kna1-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-ship_to_name = lst_adrc_part-name1.
*---Begin of change and comments VDPATABALL   ERPM-8672
*        IF lst_adrc_part-name_co IS NOT INITIAL.
*          CONCATENATE text-006 lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-ship_to_attin SEPARATED BY  c_colen. "Attn
*        ENDIF.
*        li_hdr_itm-hdr_gen-ship_to_street   = lst_adrc_part-street.
*        li_hdr_itm-hdr_gen-ship_to_city1    = lst_adrc_part-city1.
*        li_hdr_itm-hdr_gen-ship_to_region   = lst_adrc_part-region.
*        li_hdr_itm-hdr_gen-ship_to_post     = lst_adrc_part-post_code1.
*        li_hdr_itm-hdr_gen-ship_to_address  = lst_kna1-adrnr.
        FREE:lv_address_number.
        lv_address_number = lst_kna1-adrnr.
        IF lv_address_number IS NOT INITIAL.
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
            READ TABLE li_ship_to_addr ASSIGNING FIELD-SYMBOL(<lst_ship_to>) WITH KEY line_type = '5'. "C/o Namessss
            IF sy-subrc EQ 0.
              CONCATENATE text-006 <lst_ship_to>-address_line INTO  <lst_ship_to>-address_line SEPARATED BY space.
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
*---End of change and comments VDPATABALL   ERPM-8672
      ENDIF.
    ENDIF.
  ENDIF.

  IF sy-sysid <> lc_prod. "'EP1'.
    CONCATENATE 'TEST PRINT' sy-sysid sy-mandt INTO li_hdr_itm-hdr_gen-test_ref_doc SEPARATED BY c_under.
  ENDIF.

*- Invoice Description
  IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.  " 'O'
    li_hdr_itm-hdr_gen-invoice_desc  = text-004."Credit Memo
*--> BOC: SPARIMI - 07/15/19 ED1K910591
    v_flg_cr = abap_true. ""++SPARIMI
*--> EOC: SPARIMI - 07/15/19 ED1K910591
  ELSEIF  li_bil_invoice-hd_gen-bil_vbtype = c_debit. " 'P'
    li_hdr_itm-hdr_gen-invoice_desc  = text-005. "Debit Memo
  ELSE.
    li_hdr_itm-hdr_gen-invoice_desc  = text-003. "Invoice
  ENDIF.
**BOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
  IF v_output_typ = c_zm3c OR
     v_output_typ = c_zxyi. "mimmadiset:OTCM-55113:12/06/2021: ED2K925092
*- Invoice Description
    IF li_bil_invoice-hd_gen-bil_type = c_zcr.  " 'ZCR'
      CONCATENATE text-004 li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Credit Memo
      v_flg_cr = abap_true. ""++SPARIMI
    ELSEIF  li_bil_invoice-hd_gen-bil_type = c_zdr. " 'ZDR'
      CONCATENATE text-005 li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space.  "Debit Memo
    ELSE.
      li_hdr_itm-hdr_gen-invoice_desc  = text-020.
      CONCATENATE text-020 li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Invoice
    ENDIF.
  ENDIF.
**EOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*- Invoice Note
  li_hdr_itm-hdr_gen-invoice_text_name = li_bil_invoice-hd_gen-bil_number.
*- Text object for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_object = c_vbbk.
*- Text ID for Invoice note
  li_hdr_itm-hdr_gen-invoice_text_id = c_0007.
*- Language for Invoice Note
  li_hdr_itm-hdr_gen-invoice_lang = li_bil_invoice-hd_org-salesorg_spras.
*- Sub Total
  li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
  IF v_flg_cr IS NOT INITIAL.
    li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr * ( -1 ).
  ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*- Currency
  li_hdr_itm-hdr_gen-sub_tot_curr = li_bil_invoice-hd_gen-bil_waerk.
*- Tax
  li_hdr_itm-hdr_gen-tax =  li_bil_invoice-hd_gen-bil_tax.

*--> BOC: SPARIMI - 07/19/19 ED1K910678
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-tax GT 0.
    li_hdr_itm-hdr_gen-tax =  li_hdr_itm-hdr_gen-tax * ( -1 ).
  ENDIF.
*--> EOC: SPARIMI - 07/19/19 ED1K910678
*- Total Due
  li_hdr_itm-hdr_gen-total_due = li_bil_invoice-hd_gen-bil_netwr + li_bil_invoice-hd_gen-bil_tax.
*---Begin of change VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
  IF v_output_typ = c_zcda    "ZCDA
   OR v_output_typ = c_zdam.  "ZDAM
    PERFORM f_set_amount_paid.
    PERFORM f_set_total_due.
  ENDIF.
*---End of change VDPATABALL 11/23/2020  ED2K920368 OTCM-32214 & OTCM-32330
*--> BOC: SPARIMI - 07/15/19 ED1K910591
  IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-total_due GT 0.
    li_hdr_itm-hdr_gen-total_due =  li_hdr_itm-hdr_gen-total_due * ( -1 ).
  ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591

*--> BOC: SPARIMI - 07/15/19 ED1K910591
  REFRESH:lt_const.
  SELECT devid
         param1
         param2
         srno
         sign
         opti
         low
         high
         activate FROM zcaconstant
         INTO TABLE lt_const
         WHERE devid = c_devid
         AND activate = abap_true.

  READ TABLE lt_const INTO lst_const WITH KEY param1 = c_bank
                                              param2 = li_bil_invoice-hd_org-comp_code
                                              high   = li_bil_invoice-hd_gen-bil_waerk.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-bank = lst_const-low.
  ENDIF.

  READ TABLE lt_const INTO lst_const WITH KEY param1 = c_remit
                                              param2 = li_bil_invoice-hd_org-comp_code
                                              high   = li_bil_invoice-hd_gen-bil_waerk.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-remit_payment_to = lst_const-low.
  ENDIF.

  READ TABLE lt_const INTO lst_const WITH KEY param1 = c_portal
                                              param2 = li_bil_invoice-hd_org-comp_code.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-payment_portal = lst_const-low.
  ENDIF.


  READ TABLE lt_const INTO lst_const WITH KEY param1 = c_taxdes
                                              param2 = li_bil_invoice-hd_org-comp_code.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-tax_des = lst_const-low.
  ENDIF.
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
  LOOP AT lt_const INTO lst_const.
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
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924665
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
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924665
  ENDLOOP.
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
**  ++mimmadiset:OTCM 30816:12/23/2020:ED2K922420
  IF v_output_typ = c_zm3c OR
    v_output_typ = c_zxyi. "++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_cust
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-cust_service = lst_const-low.
    ENDIF.
**boc mimmadiset:OTCM-55113:12/06/2021: ED2K925092
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_cust_srv
                                               param2 = li_bil_invoice-hd_org-comp_code
                                               high = v_output_typ.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-cust_srv_txt = lst_const-low.
    ENDIF.
    IF v_output_typ = c_zxyi.
      li_hdr_itm-hdr_gen-col_name1 = 'Product'(030).
      li_hdr_itm-hdr_gen-col_name2 = 'Quantity'(033).
    ELSE.
      li_hdr_itm-hdr_gen-col_name1 = 'Resource'(034).
      li_hdr_itm-hdr_gen-col_name2 = 'Units'(035).
    ENDIF.
**eoc mimmadiset:OTCM-55113:12/06/2021: ED2K925092
  ENDIF.
*++mimmadiset:OTCM 30816:12/23/2020:ED2K922420
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*----BOC VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
  IF v_output_typ = c_zcda       "CDA .
    OR  v_output_typ = c_zdam.      "ZDAM
    IF li_bil_invoice-it_gen IS NOT INITIAL.
      SELECT matnr,
                bismt,
                meins
           FROM mara
           INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_bil_invoice-it_gen
        WHERE matnr = @li_bil_invoice-it_gen-material.
      IF li_mara IS NOT INITIAL.
        SORT li_mara BY matnr.
      ENDIF.
    ENDIF.
  ENDIF.
**BOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
  IF v_output_typ = c_zm3c OR
    v_output_typ = c_zxyi. ""++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
*    * fetch item data from vbrp table.
    SELECT  vbeln " Billing Document
            posnr " Billing item
            vgbel
            vgpos
            lland_auft
           FROM vbrp
           INTO TABLE li_vbrp
           FOR ALL ENTRIES IN li_bil_invoice-it_gen
           WHERE vbeln = li_bil_invoice-it_gen-bil_number.
    IF li_vbrp[] IS NOT INITIAL.
      SORT li_vbrp BY vgbel vgpos.
      DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING vgbel vgpos.
      SELECT  vbeln,
              posnr,
              kdmat,
              netpr,
              vgbel,
              vgpos  " Item number of the reference item
          FROM vbap  " Sales Document: Item Data
          INTO TABLE @DATA(li_vbap)
          FOR ALL ENTRIES IN @li_vbrp
          WHERE vbeln = @li_vbrp-vgbel AND
                posnr = @li_vbrp-vgpos.
    ENDIF.
**Boc:OTCM-61946:ED2K927166:mimmadiset:05/06/2022
    IF li_vbap[] IS NOT INITIAL.
      SELECT vbeln,vposn,vbegdat,venddat
          FROM veda INTO TABLE @DATA(li_veda)
          FOR ALL ENTRIES IN @li_vbap
          WHERE vbeln = @li_vbap-vbeln AND
          ( vposn = @li_vbap-posnr OR vposn = @lc_posnr ).
    ENDIF.
**Eoc:OTCM-61946:ED2K927166:mimmadiset:05/06/2022
  ENDIF.
**EOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*----EOC VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
*- Item Section
  LOOP AT li_bil_invoice-it_gen INTO DATA(lst_item_gen).

    IF sy-tabix EQ 1.
      v_sales_office = lst_item_gen-sales_off.  "Sales office
    ENDIF.


    lst_count-vbeln = lst_item_gen-bil_number.
    lst_count-posnr = lst_item_gen-itm_number.
    lst_count-arktx = lst_item_gen-short_text.
    lst_count-kdmat = lst_item_gen-cust_mat.
    lst_count-vkaus = lst_item_gen-vkaus.
    READ TABLE li_mvke INTO DATA(lst_mvke) WITH KEY matnr = lst_item_gen-material.
    IF sy-subrc EQ 0.
      lst_count-pstyv = lst_mvke-mtpos.
    ENDIF.
    lst_count-vkbur = lst_item_gen-sales_off.
    lst_count-spart = li_bil_invoice-hd_org-division.
*- Get Material master sales text
    CONCATENATE lst_item_gen-material li_bil_invoice-hd_org-salesorg li_bil_invoice-hd_org-distrb_channel INTO lv_name.
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
      IF sy-subrc EQ 0.
        CONDENSE lv_sal_mat_text.
        lst_count-maktx = lv_sal_mat_text.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.
*- Material Description field value to pick from the Material master sales text. If not found then from MAKTX (Material Description).
    IF lst_count-maktx IS INITIAL .
      READ TABLE li_makt INTO DATA(lst_mat) WITH KEY matnr = lst_item_gen-material.
      IF sy-subrc EQ 0.
        lst_count-maktx = lst_mat-maktx.
      ENDIF.
    ENDIF.
    lst_count-matnr = lst_item_gen-material.
    APPEND lst_count TO li_count.
    CLEAR: lst_count,lst_item_gen.
  ENDLOOP.
  SORT li_count BY maktx kdmat vkaus pstyv .
**Boc OTCM-55639 mimmadiset 12/14/2021 ED2K925263
  IF v_output_typ EQ c_zxyi.
    SORT li_count BY posnr.
  ENDIF.
**Eoc OTCM-55639 mimmadiset 12/14/2021 ED2K925263
*- Item Section
  LOOP AT li_count ASSIGNING FIELD-SYMBOL(<lst_count1>).
** Item ***
*- Usage Indicator
    READ TABLE li_tvlvt INTO DATA(lst_tvlvt) WITH KEY abrvw = <lst_count1>-vkaus.
*- IF Sales document item category eq 'ZPRG' and division eq '10' and sales office NE 100, then
*  need to print MAKT-MAKTX and TVLVT-BEZEI
    IF  <lst_count1>-pstyv = c_zprg
        AND <lst_count1>-spart = c_10
        AND <lst_count1>-vkbur NE c_100 .
      CONCATENATE <lst_count1>-maktx lst_tvlvt-bezei INTO lst_itm_gen-item SEPARATED BY c_under.
*- IF Sales document item category eq 'ZPRG' and division eq '30', then need to
*  print VBRP-ARKTX and TVLVT-BEZEI
    ELSEIF <lst_count1>-spart = c_30 AND <lst_count1>-pstyv = c_zprg.
      CONCATENATE <lst_count1>-arktx  lst_tvlvt-bezei INTO lst_itm_gen-item SEPARATED BY c_under.
    ELSE.
*- If Sales document item category is other then 'ZPRG' or Division eq '20', then it should print
*    VBRP-ARKTX
      lst_itm_gen-item = <lst_count1>-arktx.
    ENDIF.
** Description ***
*- IF Sales document item category eq 'ZPRG' and division eq '10' and sales office NE 100,
*  then it should print customer mat and sales
    IF  <lst_count1>-pstyv = c_zprg AND <lst_count1>-spart = c_10
                                    AND <lst_count1>-vkbur NE c_100.
      IF <lst_count1>-kdmat IS NOT INITIAL.
        CONCATENATE  <lst_count1>-kdmat <lst_count1>-arktx INTO lst_itm_gen-description SEPARATED BY c_under.
      ELSE.
        lst_itm_gen-description  = <lst_count1>-arktx.
      ENDIF.
*- IF Sales document item category eq 'ZPRG' and ( division eq '20' or division eq '30' )
*  then it should print sales item short text
    ELSEIF ( <lst_count1>-spart = c_30 OR <lst_count1>-spart = c_20 ) AND <lst_count1>-pstyv = c_zprg.
      lst_itm_gen-description = <lst_count1>-arktx.
    ELSE.
*- Then above conditions are not satisfied, clear the value
      CLEAR lst_itm_gen-description.
    ENDIF.
*----BOC VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
    IF v_output_typ = c_zcda       "CDA .
      OR  v_output_typ = c_zdam.      "ZDAM
      READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = <lst_count1>-matnr
                                                      BINARY SEARCH.
      IF sy-subrc = 0.
        lst_itm_gen-item = lst_mara-bismt.
        lst_itm_gen-description = <lst_count1>-arktx.
      ENDIF.
    ENDIF.
*----EOC VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
** Students ***
*- IF Sales document item category eq 'ZPRG' and ( division eq '10' or division eq '20' or division eq '30' )
*  and Sales office NE '100' then clubb the line items , if not get the item quantity.
    IF  <lst_count1>-pstyv = c_zprg AND
         <lst_count1>-vkbur NE c_100 AND
         ( <lst_count1>-spart = c_10 OR <lst_count1>-spart = c_20 OR <lst_count1>-spart = c_30 ).
      lst_itm_gen-students = lst_itm_gen-students + 1.
*- For Item Quantity
    ELSE.
      READ TABLE li_bil_invoice-it_gen INTO DATA(lst_itm_gen_t) WITH KEY bil_number = <lst_count1>-vbeln
                                                                         itm_number = <lst_count1>-posnr.
      IF sy-subrc EQ 0.
        v_fkimg = lst_itm_gen_t-fkimg.
        CONDENSE v_fkimg.
        SPLIT v_fkimg AT '.' INTO v_fkimg_fr v_fkimg_bk.
        CONDENSE v_fkimg_fr.
        lst_itm_gen-students = v_fkimg_fr.
*Boc mimmadiset ED2K925763 2/11/2022 OTCM_59059
        DATA(lv_sales_area) = li_bil_invoice-hd_org-comp_code &&
                              li_bil_invoice-hd_org-distrb_channel &&
                              li_bil_invoice-hd_org-division.
        READ TABLE lt_const INTO lst_const WITH KEY param1 = c_decimal
                                                    param2 = lv_sales_area.
        IF sy-subrc = 0.
          IF v_fkimg_bk = '000' OR v_fkimg_bk = '00'.
          ELSE.
            lst_itm_gen-students = v_fkimg_fr  && '.' && v_fkimg_bk+0(2).
            CONDENSE lst_itm_gen-students NO-GAPS.
          ENDIF.
        ENDIF.
*EOC mimmadiset ED2K925763 2/11/2022 OTCM_59059
      ENDIF.
    ENDIF.
** Total, Tax, amount and Discount ***
    READ TABLE li_bil_invoice-it_price INTO DATA(lst_itm_price) WITH KEY bil_number = <lst_count1>-vbeln
                                                                         itm_number = <lst_count1>-posnr.
    IF sy-subrc EQ 0.
*- Amount
      lst_itm_gen-amount      = lst_itm_gen-amount + lst_itm_price-kzwi1.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
      IF v_flg_cr EQ abap_true AND   lst_itm_gen-amount GT 0 . "++SPARIMI
        lst_itm_gen-amount =   lst_itm_gen-amount * ( -1 ).
      ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*- Convert Tax value to positive value
      lst_itm_price-kzwi5     = lst_itm_price-kzwi5 * -1.
*- Discounts
      lst_itm_gen-discounts   = lst_itm_gen-discounts + lst_itm_price-kzwi5.
*- Pass converted Tax value
      lst_itm_gen-tax         = lst_itm_gen-tax + lst_itm_price-kzwi6.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
      IF v_flg_cr IS NOT INITIAL AND lst_itm_gen-tax GT 0. "++SPARIMI
        lst_itm_gen-tax =   lst_itm_gen-tax * ( -1 ).
      ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*- Currency
      lst_itm_gen-currency    = li_bil_invoice-hd_gen-bil_waerk.
*- Checking SD document category eq 'ZPRG'
      IF <lst_count1>-pstyv = c_zprg.
        lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.
      ELSE.
*- other then SD document category  eq 'ZPRG'
        lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.
      ENDIF.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
      IF v_flg_cr IS NOT INITIAL AND  lst_itm_gen-total  GT 0. "++SPARIMI
        lst_itm_gen-total =  lst_itm_gen-total * ( -1 ).
      ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
    ENDIF.
**Boc mimmadiset:OTCM 30816:12/23/2020:ED2K920979
    IF v_output_typ = c_zm3c OR
      v_output_typ = c_zxyi. ""++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
      lst_itm_gen-description = <lst_count1>-arktx.
      lst_itm_gen-tax_char = lst_itm_gen-tax.
      PERFORM f_put_sign_in_front CHANGING lst_itm_gen-tax_char.
      lst_itm_gen-total_char  = lst_itm_gen-total.
      PERFORM f_put_sign_in_front CHANGING lst_itm_gen-total_char.
      READ TABLE li_vbrp INTO DATA(ls_vbrp)  WITH KEY vbeln = <lst_count1>-vbeln
                                                      posnr = <lst_count1>-posnr.
      IF sy-subrc = 0.
        READ TABLE li_vbap INTO DATA(ls_vbap) WITH KEY vbeln = ls_vbrp-vgbel
                                                       posnr = ls_vbrp-vgpos.
        IF sy-subrc = 0.
**--> Resource
          lst_itm_gen-item = ls_vbap-kdmat.
**-->Rate
          lst_itm_gen-amount = ls_vbap-netpr.
*          IF v_flg_cr EQ abap_true AND   lst_itm_gen-amount GT 0 .
*            lst_itm_gen-amount =   lst_itm_gen-amount * ( -1 ).
*          ENDIF.
*          BOC mimmadiset:OTCM-55113:12/06/2021: ED2K925092
          IF v_output_typ = c_zxyi. ""++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
            lst_itm_gen-description = lst_itm_gen-item. " Customer Material Info Record
**--->Product
            lst_itm_gen-item = <lst_count1>-arktx."should have the Material Description
          ENDIF.
*          EOC mimmadiset:OTCM-55113:12/06/2021: ED2K925092
**Boc:OTCM-61946:ED2K927166:mimmadiset:05/06/2022
          IF v_output_typ = c_zm3c.
            READ TABLE li_veda INTO DATA(ls_veda) WITH KEY vbeln = ls_vbap-vbeln
             vposn = ls_vbap-posnr.
            IF sy-subrc NE 0.
              READ TABLE li_veda INTO ls_veda WITH KEY vbeln = ls_vbap-vbeln vposn = lc_posnr.
            ENDIF.
            IF ls_veda IS NOT INITIAL.
* get month name and year
              IF i_month_names IS INITIAL AND nast-spras IS NOT INITIAL.
                CALL FUNCTION 'MONTH_NAMES_GET'
                  EXPORTING
                    language              = nast-spras
                  TABLES
                    month_names           = i_month_names
                  EXCEPTIONS
                    month_names_not_found = 1
                    OTHERS                = 2.
                IF sy-subrc = 0.
*            Start month and year
                ENDIF.
              ENDIF.
              READ TABLE i_month_names INTO DATA(lst_month_name) WITH KEY mnr = ls_veda-vbegdat+4(2).
              IF sy-subrc = 0.
                lst_itm_gen-contract_dates = lst_month_name-ltx+0(3) && '-' && ls_veda-vbegdat+6(2) && '-'
                && ls_veda-vbegdat+0(4).
                READ TABLE i_month_names INTO lst_month_name WITH KEY mnr = ls_veda-venddat+4(2).
                IF sy-subrc = 0.
                  lst_itm_gen-contract_dates = lst_itm_gen-contract_dates && | | && 'to' && | |
                  && lst_month_name-ltx+0(3) && '-'
                  && ls_veda-venddat+6(2) && '-'
                  && ls_veda-venddat+0(4).
                  lst_itm_gen-item = lst_itm_gen-item && CL_ABAP_CHAR_UTILITIES=>NEWLINE && lst_itm_gen-contract_dates.
                ENDIF.
              ENDIF.
            ENDIF.
            CLEAR:ls_veda.
          ENDIF.
**Eoc:OTCM-61946:ED2K927166:mimmadiset:05/06/2022
        ENDIF.
      ENDIF.
    ENDIF.
** EOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*- Count of each combination “Club the line item rows based on the Program,
*  Usage Type, Course if the Item Category is ZPRG
    AT END OF pstyv.
      APPEND lst_itm_gen TO li_itm_gen.
      CLEAR lst_itm_gen.
    ENDAT.
    IF lst_itm_gen-total NE c_0 AND <lst_count1>-pstyv NE c_zprg.
      APPEND lst_itm_gen TO li_itm_gen.
      CLEAR lst_itm_gen.
    ENDIF.
    CLEAR lst_count.
  ENDLOOP.
  li_hdr_itm-itm_gen[] = li_itm_gen[].

** Tax item ***
  LOOP AT li_bil_invoice-it_price  INTO DATA(lst_inv_it).
    READ TABLE li_bil_invoice-it_kond INTO DATA(lst_komv) WITH KEY kposn = lst_inv_it-itm_number.
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
*--> BOC: SPARIMI - 07/15/19 ED1K910591
*    IF v_flg_cr IS NOT INITIAL AND lst_tax_item-tax_amount GT 0."++SPARIMI
*      lst_tax_item-tax_amount = lst_tax_item-tax_amount * ( -1 ).
*    ENDIF.
*
*    IF v_flg_cr IS NOT INITIAL AND   lst_tax_item-taxable_amt GT 0.
*      lst_tax_item-taxable_amt =   lst_tax_item-taxable_amt * ( -1 ).
*    ENDIF.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
    IF lst_inv_it-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL
    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.
    COLLECT lst_tax_item INTO li_tax_item.
  ENDLOOP.

  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = c_tax."lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage c_eq INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
*--> BOC: SPARIMI - 07/15/19 ED1K910591
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_tax_item_final-taxabl_amt.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
    CONCATENATE lst_tax_item_final-taxabl_amt c_at INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-tax_amount.

*--> BOC: SPARIMI - 07/15/19 ED1K910591
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_tax_item_final-tax_amount.
*--> BOC: SPARIMI - 07/15/19 ED1K910591

    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
  li_hdr_itm-itm_exc_tab[] =  i_tax_item[].
** LH/LHI Logo *****
  v_division = li_bil_invoice-hd_org-division.

*--> BOC: SPARIMI - 07/15/19 ED1K910591
  IF li_bil_invoice-hd_org-comp_code NE c_1030.
    DATA:lv_lname TYPE tdobname,
         lv_btype TYPE tdbtype.
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_logo
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      CLEAR:lv_lname,lv_btype.
      lv_lname = lst_const-low.
      lv_btype = lst_const-high.

* To Get a BDS Graphic in BMP Format
      CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
        EXPORTING
          p_object       = c_object
          p_name         = lv_lname
          p_id           = c_bmap
          p_btype        = lv_btype
        RECEIVING
          p_bmp          = v_bmp        " Image Data
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc NE 0.
        CLEAR v_bmp.
      ENDIF. " IF sy-subrc NE 0
    ENDIF.
  ELSE.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
    IF v_sales_office EQ lc_vkbur. "0100
      v_param1 = v_sales_office.
    ELSE.
      v_param1 = space.
    ENDIF.

    CONDENSE v_division.
    CALL METHOD zcacl_abap_gbl_utilities=>meth_get_pdf_logo
      EXPORTING
        im_devid                = c_devid
        im_param1               = v_param1
        im_param2               = v_division "'10'
      IMPORTING
        ex_logo                 = v_logo
        ex_bmp                  = v_bmp
      EXCEPTIONS
        no_entry_found          = 1
        required_fields_missing = 2
        OTHERS                  = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDIF.
*-->BOC by MIMMADISET:OTCM-32214:18/11/2020:ED2K920368
  IF v_output_typ = c_zcda
    OR v_output_typ = c_zdam.
    CLEAR:v_logo,v_bmp.
  ENDIF.
*-->EOC by MIMMADISET:OTCM-32214:18/11/2020:ED2K920368
*--> BOC: SPARIMI - 07/15/19 ED1K910591
*--*Tax ID
  PERFORM f_build_tax_info.


*--*Currency Conevrsion
  PERFORM f_convert_amount.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
****BOC MIMMADISET OTCM-42109 ED2K921982
** Read the sales org address if entry exist zcaconstant.
  READ TABLE lt_const INTO DATA(ls_kschl)
                           WITH KEY param1 = lc_kschl
                                    param2 = v_output_typ
                                    low = li_bil_invoice-hd_org-salesorg.
  IF sy-subrc = 0.
    PERFORM f_get_sales_org_details.
  ENDIF.
****EOC MIMMADISET OTCM 42109
***BOC MIMMADISET OTCM-42939 ED2K922181
  IF v_output_typ = c_zm3c OR v_output_typ = c_zxyi.
    PERFORM  f_remove_decimal.
    "BOC:OTCM-49815 ED2K924206,ED2K924265:07.28.2021: MIMMADISET
    PERFORM  f_read_inv_notes.
    "EOC:OTCM-49815 ED2K924206,ED2K924265:07.28.2021: MIMMADISET
  ENDIF.
***EOC MIMMADISET OTCM-42939 ED2K922181
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_FORMNAME  text
*----------------------------------------------------------------------*
FORM f_populate_layout  USING    fp_v_formname.
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
*     Nothing to do
      ENDIF. " IF sy-subrc NE 0
*    v_ent_retco = 900.

*    RETURN.
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = fp_v_formname "lc_form_name
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
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
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
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
        ELSE.
*        PERFORM f_protocol_update. "update log
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
FORM f_adobe_prnt_snd_mail  CHANGING p_fp_v_returncode.
  DATA: st_outputparams  TYPE sfpdocparams ##NEEDED,      " Form Processing Output Parameter
        lv_form          TYPE tdsfname,                   " Smart Forms: Form Name
        lv_fm_name       TYPE funcname,                   " Name of Function Module
        lv_upd_tsk       TYPE i,                          " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,            " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams,               " Form Parameters for Form Processing
        lv_person_numb   TYPE prelp-pernr,                " Person Number
        lv_text          TYPE char255.                    " For text message


*--------------------------------------------------------------------*


  CLEAR lv_text.
  CASE li_bil_invoice-hd_org-division.
    WHEN c_10 .
**BOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
      PERFORM f_read_email_10.
**      IF nast-parvw = c_re.
**
**        SELECT SINGLE vbeln parvw kunnr pernr adrnr
**          FROM vbpa INTO st_vbpa
**          WHERE vbeln = li_bil_invoice-hd_ref-order_numb
**          AND  parvw = c_re.  "
**        IF sy-subrc EQ 0.
**          SELECT  smtp_addr UP TO 1 ROWS "E-Mail Address
**           FROM adr6      "E-Mail Addresses (Business Address Services)
**           INTO v_send_email
**           WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
**          ENDSELECT.
**          IF sy-subrc NE 0 AND v_send_email IS INITIAL .
**            SELECT SINGLE prsnr "E-Mail Address
**              FROM knvk      "E-Mail Addresses (Business Address Services)
**              INTO v_persn_adrnr
**              WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
**              AND   pafkt = c_z1 ##WARN_OK.
**            IF sy-subrc EQ 0.
**              SELECT SINGLE smtp_addr "E-Mail Address
**                FROM adr6      "E-Mail Addresses (Business Address Services)
**                INTO v_send_email
**                WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
**              IF v_send_email IS INITIAL.
**                syst-msgid = c_zqtc_r2.
**                syst-msgno = c_msg_no.
**                syst-msgty = c_e.
**                syst-msgv1 = text-018.
**                CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**                PERFORM f_protocol_update.
**                v_ent_retco = 4.
**              ENDIF.
**            ELSE.
**              syst-msgid = c_zqtc_r2.
**              syst-msgno = c_msg_no.
**              syst-msgty = c_e.
**              syst-msgv1 = text-018.
**              CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**              PERFORM f_protocol_update.
**              v_ent_retco = 4.
**            ENDIF.
**          ENDIF.
**        ELSE.
**          syst-msgid = c_zqtc_r2.
**          syst-msgno = c_msg_no.
**          syst-msgty = c_e.
**          syst-msgv1 = text-017.
**          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**          PERFORM f_protocol_update.
**          v_ent_retco = 4.
**        ENDIF.
**
**
**
**      ELSE. "check for ER
**        SELECT SINGLE vbeln parvw kunnr pernr adrnr FROM vbpa INTO st_vbpa WHERE vbeln = li_bil_invoice-hd_ref-order_numb
**                                                                            AND  parvw = c_er. "ER - Employee responsible
**
**        IF sy-subrc EQ 0.
**          SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
**            FROM adr6      "E-Mail Addresses (Business Address Services)
**            INTO v_send_email
**            WHERE addrnumber EQ st_vbpa-adrnr. ##WARN_OK.
**          ENDSELECT.
**          IF sy-subrc NE 0 AND v_send_email IS INITIAL.
**            lv_person_numb = st_vbpa-pernr.
**            CALL FUNCTION 'HR_READ_INFOTYPE'
**              EXPORTING
***               TCLAS           = 'A'
**                pernr           = lv_person_numb
**                infty           = c_105
**                begda           = c_start
**                endda           = c_end
**              TABLES
**                infty_tab       = li_person_mail_id
**              EXCEPTIONS
**                infty_not_found = 1
**                OTHERS          = 2.
**            IF sy-subrc EQ 0.
*** Implement suitable error handling here
**              READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id) WITH KEY pernr =  lv_person_numb
**                                                                                  usrty = c_0010.
**              IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
**                v_send_email = lst_person_mail_id-usrid_long.
**              ELSE.
**                syst-msgid = c_zqtc_r2.
**                syst-msgno = c_msg_no.
**                syst-msgty = c_e.
**                syst-msgv1 = text-016.
**                CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**                PERFORM f_protocol_update.
**                v_ent_retco = 4.
**              ENDIF.
**            ELSE.
**              syst-msgid = c_zqtc_r2.
**              syst-msgno = c_msg_no.
**              syst-msgty = c_e.
**              syst-msgv1 = text-016.
**              CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**              PERFORM f_protocol_update.
**              v_ent_retco = 4.
**            ENDIF.
**          ENDIF. " IF sy-subrc NE 0
**        ELSE.
**          syst-msgid = c_zqtc_r2.
**          syst-msgno = c_msg_no.
**          syst-msgty = c_e.
**          syst-msgv1 = text-015.
**          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
**          PERFORM f_protocol_update.
**          v_ent_retco = 4.
**        ENDIF.
**
**      ENDIF.
**EOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
    WHEN c_20 OR c_30.

      SELECT SINGLE vbeln parvw kunnr pernr adrnr FROM vbpa INTO st_vbpa WHERE vbeln = li_bil_invoice-hd_ref-order_numb
                                                                          AND  parvw = c_re.  " BP Partner
      IF sy-subrc EQ 0.
**BOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
*        SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
*          FROM adr6      "E-Mail Addresses (Business Address Services)
*          INTO v_send_email
*          WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
*        ENDSELECT.
*      *   Fetch email ID from ADR6.
        PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                    CHANGING i_emailid.
**EOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
        IF i_emailid IS INITIAL . " v_send_email IS INITIAL.
          SELECT SINGLE prsnr "E-Mail Address
            FROM knvk      "E-Mail Addresses (Business Address Services)
            INTO v_persn_adrnr
            WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
            AND   pafkt = c_z1 ##WARN_OK.
          IF sy-subrc EQ 0.
**BOC mimmadiset OTCM-55093 ED2K925315 12/20/2021
*            SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
*              FROM adr6      "E-Mail Addresses (Business Address Services)
*              INTO v_send_email
*              WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
*            ENDSELECT.
            SELECT smtp_addr "E-Mail Address
             FROM adr6      "E-Mail Addresses (Business Address Services)
             INTO TABLE i_emailid
             WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
**EOC mimmadiset OTCM-55093 ED2K925315 12/20/2021
            IF i_emailid IS INITIAL ."v_send_email IS INITIAL.
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
*---Begin of change VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
    WHEN c_40.
      PERFORM f_read_email.
*---End of change VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
**BOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
    WHEN c_00 OR c_70 "++mimmadiset:OTCM-55113:12/06/2021: ED2K925092
      OR c_80.   "mimmadiset:OTCM-58367:02/01/2022: ED2K925664
      PERFORM f_read_email_zm3c.
**EOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
    WHEN OTHERS.
  ENDCASE.
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
  IF v_output_typ IN r_supplement_po_output AND li_bil_invoice-hd_ref-po_supplem IN r_supplement_po.
* Begin of ADD:OTCM-30892/45037:SGUDA:30-SEP-2021:ED2K924442
* Checking AR text having email ID or not
    PERFORM get_ar_text_for_emailid USING li_bil_invoice-hd_ref-order_numb
                                    CHANGING i_emailid. "++ mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*    READ TABLE li_bil_invoice-hd_adr INTO DATA(lst_sold_add) WITH KEY partn_role = c_re.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE smtp_addr FROM adr6
*             INTO v_send_email
*             WHERE addrnumber EQ lst_sold_add-addr_no.
* End of ADD:OTCM-30892/45037:SGUDA:30-SEP-2021:ED2K924442
    IF i_emailid IS INITIAL.   "IF v_send_email IS INITIAL. ++ mimmadiset:OTCM 30816:12/23/2020:ED2K920979
      READ TABLE r_sales_team_email INTO DATA(lstt_sales_team_email) INDEX 1.
      IF sy-subrc EQ 0.
**boc mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*        v_send_email = lstt_sales_team_email-low.
        ls_emailid-smtp_addr = lstt_sales_team_email-low.
        APPEND ls_emailid TO i_emailid.
        CLEAR:ls_emailid.
**eoc mimmadiset:OTCM 30816:12/23/2020:ED2K920979
      ENDIF.
    ENDIF.
  ENDIF.
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
  IF i_emailid IS NOT INITIAL. "IF v_send_email IS NOT INITIAL. ++mimmadiset OTCM-55093 ED2K925315 12/20/2021
    IF v_ent_retco = 0 .
      lv_form = tnapr-sform.
      lst_outputparams-getpdf = abap_true.
      lst_outputparams-preview = abap_false.
    ENDIF. " IF fp_v_returncode = 0

*--- Set output parameters
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
*--- Set language and default language
    st_outputparams-langu    = nast-spras.

* Archiving
    APPEND toa_dara TO  lst_sfpdocparams-daratab.

*--- Open the spool job
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

*--- Get the name of the generated function module
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
*--- Call the generated function module
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

*--- Close the spool job
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
    IF i_emailid IS NOT INITIAL. "IF v_send_email IS NOT INITIAL. ++mimmadiset OTCM-55093 ED2K925315 12/20/2021
      IF nast-nacha = c_5. "++ VDPATABALL  ERPM-10414 22/01/2020
        PERFORM f_mail_attachment
                CHANGING v_ent_retco.
      ENDIF. ""++ VDPATABALL  ERPM-10414 22/01/2020
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
FORM f_mail_attachment  CHANGING p_fp_v_returncode ##NEEDED.

*Declaration
  DATA: lr_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines TYPE tline.                   " SAPscript: Text Lines


*Local Constant Declaration
  CONSTANTS:
    lc_raw                     TYPE so_obj_tp      VALUE 'RAW',                   "Code for document class
    lc_parvw_zm                TYPE char02         VALUE 'ZM',
    lc_pdf                     TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
    lc_s                       TYPE bapi_mtype     VALUE 'S',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
    lc_st                      TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
    lc_object                  TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
    lc_name                    TYPE thead-tdname   VALUE 'ZQTC_EMAIL_F032',       " Name
    lc_name_47                 TYPE thead-tdname   VALUE 'ZQTC_EMAIL_F047',       " Name
    lc_name_opm_lhi            TYPE thead-tdname   VALUE 'ZQTC_OPM_LHI_EMAIL_TEMPLATE_F046',
    lc_name_ac                 TYPE thead-tdname   VALUE 'ZQTC_AC_EMAIL_TEMPLATE_F046',
    lc_name_tsg_reg            TYPE thead-tdname   VALUE 'ZQTC_TSG_REG_EMAIL_TEMPLATE_F046',
    lc_name_tsg_tut            TYPE thead-tdname   VALUE 'ZQTC_TSG_TUT_EMAIL_TEMPLATE_F046',
    lc_name_opm_lhi_can        TYPE thead-tdname   VALUE 'ZQTC_OPM_EMAIL_CAN_TEMPLATE_F046',
    lc_name_ac_can             TYPE thead-tdname   VALUE 'ZQTC_AC_CANCEL_EMAIL_TEMPLATE_F046',
    lc_name_tsg_tut_can        TYPE thead-tdname   VALUE 'ZQTC_CANCEL_TUT_EMAIL_TEMPLATE_F046',
    lc_name_tsg_reg_can        TYPE thead-tdname   VALUE 'ZQTC_TSG_REG_CAN_EMAIL_TEMPLATE_F046',
    lc_name_opm_lhi_dr         TYPE tdobname       VALUE 'ZQTC_OPM_LHI_EMAIL_TEMP_DR_F046',
    lc_name_opm_lhi_cr         TYPE tdobname       VALUE 'ZQTC_OPM_LHI_EMAIL_TEMP_CR_F046',
    lc_name_tsg_reg_cr         TYPE tdobname       VALUE 'ZQTC_TSG_REG_EMAIL_TEMP_CR_F046',
    lc_name_tsg_reg_dr         TYPE tdobname       VALUE 'ZQTC_TSG_REG_EMAIL_TEMP_DR_F046',
    lc_name_tsg_tut_cr         TYPE thead-tdname   VALUE 'ZQTC_TSG_TUT_EMAIL_TEMP_CR_F046',
    lc_name_tsg_tut_dr         TYPE thead-tdname   VALUE 'ZQTC_TSG_TUT_EMAIL_TEMP_DR_F046',
    lc_name_ac_dr              TYPE thead-tdname   VALUE 'ZQTC_AC_EMAIL_TEMP_CR_F046',
    lc_name_ac_cr              TYPE thead-tdname   VALUE 'ZQTC_AC_EMAIL_TEMP_DR_F046',
    lc_name_da_inv             TYPE thead-tdname   VALUE 'ZQTC_OPM_DA_EMAIL_TEMPLATE_F046', "++VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
    lc_name_da_cr              TYPE thead-tdname   VALUE 'ZQTC_OPM_DA_EMAIL_TEMP_CR_F046', "++VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
    lc_name_da_dr              TYPE thead-tdname   VALUE 'ZQTC_OPM_DA_EMAIL_TEMP_DR_F046', "++VDPATABALL:OTCM-32214 & OTCM-32330:11/23/2020:ED2K920368
    lc_supp_email_body         TYPE thead-tdname   VALUE 'ZQTC_EMAIL_BODY_STANDING_ORD', "ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
* Begin of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
    lc_name_ac_email_body      TYPE thead-tdname VALUE 'ZQTC_AC_EMAIL_TEMPLATE_F046_',
    lc_name_tsg_reg_email_body TYPE thead-tdname VALUE 'ZQTC_TSG_REG_EMAIL_TEMPLATE_F046_',
    lc_name_tsg_tut_email_body TYPE thead-tdname VALUE 'ZQTC_TSG_TUT_EMAIL_TEMPLATE_F046_',
    lc_comp_code_1030          TYPE bukrs        VALUE '1030',
* End of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
* Begin of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
    lc_email_body_text         TYPE thead-tdname VALUE 'ZQTC_EMAILBODY_OUTPUT_F046_',
    lc_cr                      TYPE char4        VALUE '_CR',
    lc_inv                     TYPE char4        VALUE '_INV',
    lc_email_body              TYPE char10       VALUE 'EMAILBODY'.
* End of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service
  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL ##NEEDED, " BCS: Document Exceptions
        lv_subject      TYPE so_obj_des.                              " Short description of contents
*--------------------------------------------------------------------*
  TRY .
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.

* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
        lv_sub            TYPE string,
        lv_name           TYPE thead-tdname,
        lv_doc_cat        TYPE char30,
        lv_type.



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

  IF li_bil_invoice-hd_org-division = c_10   "OPM invoice email Content
    OR li_bil_invoice-hd_org-division = c_40 "++VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
    OR li_bil_invoice-hd_org-division = c_00 "++ mimmadiset:OTCM 30816:12/23/2020:ED2K920979
    OR li_bil_invoice-hd_org-division = c_70 "++ mimmadiset:OTCM-55113:12/06/2021: ED2K925092
    OR li_bil_invoice-hd_org-division = c_80.   "++mimmadiset:OTCM-58367:02/01/2022: ED2K925664
    IF li_bil_invoice-hd_gen-bil_vbtype = c_credit.
      lv_name = lc_name_opm_lhi_cr.
    ELSEIF li_bil_invoice-hd_gen-bil_vbtype = c_debit.
      lv_name = lc_name_opm_lhi_dr.
    ELSE.
      IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
        lv_name = lc_name_opm_lhi_can.
      ELSE.
        lv_name = lc_name_opm_lhi.
      ENDIF.
    ENDIF.
*--BOC VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
    IF v_output_typ = c_zcda      "CDA
      OR  v_output_typ = c_zdam.
      CONCATENATE lv_doc_cat
                  li_hdr_itm-hdr_gen-invoice_numb
      INTO lv_sub SEPARATED BY space.
    ELSE.
*----EOC VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
      CONCATENATE li_hdr_itm-hdr_gen-bill_to_name
                  lv_doc_cat
                  li_hdr_itm-hdr_gen-invoice_numb
*---Begin of change VDPATABALL   12/11/2019 ERPM-8672
*   INTO lv_subject SEPARATED BY space. "--VDPATABLL 12/11/2019 ERPM-8672
      INTO lv_sub SEPARATED BY space.
    ENDIF. "++VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
    CONCATENATE lv_doc_cat
                li_hdr_itm-hdr_gen-invoice_numb
                INTO lv_subject SEPARATED BY space.
*---End of change VDPATABALL   12/11/2019 ERPM-8672
  ELSEIF li_bil_invoice-hd_org-division = c_20.  "Software Guild Email content

*    READ TABLE li_bil_invoice-it_gen INTO DATA(lst_item_categ) WITH KEY item_categ = c_zffs.
    READ TABLE li_bil_invoice-it_gen INTO DATA(lst_item_categ) WITH KEY item_categ = c_zreg. "++ERPP-125 - SKKAIRAMKO
    IF sy-subrc EQ 0.


      CASE li_bil_invoice-hd_gen-bil_vbtype.

        WHEN c_credit.
          lv_name = lc_name_tsg_reg_dr.  "Credit Memo
        WHEN c_debit.
          lv_name = lc_name_tsg_reg_cr.    "Debit Memo
        WHEN OTHERS .
          IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
            lv_name = lc_name_tsg_reg_can.
          ELSE.
* Begin of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
            IF li_bil_invoice-hd_org-comp_code = lc_comp_code_1030.
              CONCATENATE lc_name_tsg_reg_email_body li_bil_invoice-hd_org-comp_code INTO lv_name.
            ELSE.
              lv_name = lc_name_tsg_reg.
            ENDIF.
*            lv_name = lc_name_tsg_reg.      "Invoice
* End of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
          ENDIF.
      ENDCASE.

    ELSE.   "Tuition


      CASE li_bil_invoice-hd_gen-bil_vbtype.

        WHEN c_credit.
          lv_name = lc_name_tsg_tut_dr.
        WHEN c_debit.
          lv_name = lc_name_tsg_tut_cr.
        WHEN OTHERS .
          IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
            lv_name = lc_name_tsg_tut_can.
          ELSE.
* Begin of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
            IF li_bil_invoice-hd_org-comp_code = lc_comp_code_1030.
              CONCATENATE lc_name_tsg_tut_email_body li_bil_invoice-hd_org-comp_code INTO lv_name.
            ELSE.
              lv_name = lc_name_tsg_tut.
            ENDIF.
*              lv_name = lc_name_tsg_tut.
* End of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
          ENDIF.
      ENDCASE.
    ENDIF.
    CONCATENATE 'The Software Guild'(009)
                lv_doc_cat
                li_hdr_itm-hdr_gen-invoice_numb
*    *   INTO lv_subject SEPARATED BY space."--VDPATABLL 12/11/2019 ERPM-8672
   INTO lv_sub SEPARATED BY space.   "++VDPATABLL 12/11/2019 ERPM-8672
    lv_subject = lv_sub.  "++VDPATABLL 12/11/2019 ERPM-8672

  ELSEIF li_bil_invoice-hd_org-division = c_30.   "Advancement Courses Email content

    CASE li_bil_invoice-hd_gen-bil_vbtype.
      WHEN c_credit.
        lv_name = lc_name_ac_cr.
        lv_subject = text-012.
      WHEN c_debit.
        lv_name = lc_name_ac_dr.
        lv_subject = text-013.
      WHEN OTHERS .
        IF li_bil_invoice-hd_gen-bil_vbtype = c_n. " if it is Cancelled Invoice.
          lv_name = lc_name_ac_can.
          lv_subject = 'Canceled Invoice from Advancement Courses'(023).
        ELSE.
* Begin of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
          IF li_bil_invoice-hd_org-comp_code = lc_comp_code_1030.
            CONCATENATE lc_name_ac_email_body li_bil_invoice-hd_org-comp_code INTO lv_name.
          ELSE.
            lv_name = lc_name_ac.
          ENDIF.
*         lv_name = lc_name_ac.
* End of Change by ARGADEELA on 10:29:2021/INC0404683/ED1K913660
          lv_subject = text-010.
        ENDIF.
        lv_sub = lv_subject. "++VDPATABLL 12/11/2019 ERPM-8672
    ENDCASE.
  ENDIF.
*--BOC VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
  IF v_output_typ = c_zcda      "CDA
      OR  v_output_typ = c_zdam.
    CASE li_bil_invoice-hd_gen-bil_vbtype.
      WHEN c_credit.
        lv_name = lc_name_da_cr.
      WHEN c_debit.
        lv_name =  lc_name_da_dr.
      WHEN OTHERS.
        lv_name = lc_name_da_inv.
    ENDCASE.
  ENDIF.
*--EOC VDPATABALL 11/23/2020 ED2K920368 OTCM-32214 & OTCM-32330
* Begin of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
  CLEAR lst_const.
  READ TABLE lt_const INTO lst_const WITH KEY param1 = lc_email_body
                                              low    = v_output_typ.
  IF sy-subrc EQ 0.
    CASE li_bil_invoice-hd_gen-bil_vbtype.
      WHEN c_credit.
        CLEAR lv_name.
        CONCATENATE lc_email_body_text  v_output_typ lc_cr INTO lv_name.
      WHEN c_debit.

      WHEN OTHERS.
        CLEAR lv_name.
        CONCATENATE lc_email_body_text  v_output_typ lc_inv INTO lv_name.
    ENDCASE.
  ENDIF.
* End of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
**  lv_sub = lv_subject.  "--VDPATABLL 12/11/2019 ERPM-8672
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
* Begin of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
  IF v_output_typ IN r_supplement_po_output AND li_bil_invoice-hd_ref-po_supplem IN r_supplement_po.
    CLEAR: li_lines[],li_message_body[],li_message_body.
    lv_name  = lc_supp_email_body.
    CONCATENATE 'Your Invoice'(025) li_bil_invoice-hd_gen-bil_number 'With John Wiley & Sons'(026)
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
* End of ADD:OTCM-30892/45037:SGUDA:08-JUL-2021:ED2K924064
* Begin of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
  IF v_output_typ = c_zxyi.
    CASE li_bil_invoice-hd_gen-bil_vbtype.
      WHEN c_credit.
        CONCATENATE text-036 li_bil_invoice-hd_gen-bil_number INTO lv_subject. "Wiley Credit Number:
        lv_sub = lv_subject.
      WHEN c_debit.

      WHEN OTHERS.
        CONCATENATE text-037 li_bil_invoice-hd_gen-bil_number INTO lv_subject. "Wiley Invoice Number
        lv_sub = lv_subject.
    ENDCASE.
  ENDIF.
* End of ADD:OTCM-57535:SGUDA:02-MAR-2022:ED2K925928
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
      i_att_content_hex = i_content_hex
 ).
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

  IF i_emailid IS NOT INITIAL. "IF v_send_email IS NOT INITIAL. ++mimmadiset OTCM-55093 ED2K925315 12/20/2021
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
    TRY.
        LOOP AT i_emailid INTO DATA(lst_emailid). "++mimmadiset OTCM-55093 ED2K925315 12/20/2021
          lr_recipient = cl_cam_address_bcs=>create_internet_address( lst_emailid-smtp_addr )."v_send_email ).
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        ENDLOOP. " LOOP AT i_emailid INTO DATA(lst_emailid)
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs. ##NO_HANDLER
    ENDTRY.
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
  ENDIF. " IF v_send_email IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_clear.

  REFRESH: li_makt,li_adrc,li_t001z,li_vbrk,li_adrc_part,li_kna1,
           li_tvlvt,li_t001,li_count,li_itm_gen.

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
*         v_send_email, "++mimmadiset OTCM-55093 ED2K925315 12/20/2021
         v_output_typ,
         v_logo,
         v_bmp,
         " BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
         v_ref_curr,       " Reference currency for currency translation
         v_to_curr,        " To-currency
         v_bill_date,      " Billing date
         " EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
         li_bil_invoice,
         li_hdr_itm,li_print_data_to_read,
         i_emailid."++mimmadiset OTCM-55093 ED2K925315 12/20/2021

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_AMOUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*--> BOC: SPARIMI - 07/15/19 ED1K910591
FORM f_convert_amount.

  DATA: lv_exc_rate TYPE ukurs_curr,      " Exchange rate
        lv_loc_amt  TYPE ukm_credit_limit,
*--> BOC: SPARIMI - 07/19/19 ED1K910678
        lv_amt      TYPE kzwi6.
*--> EOC: SPARIMI - 07/19/19 ED1K910678

  IF v_doc_currency NE v_cust_currency.
    " BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
    v_to_curr = v_cust_currency.
    " EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
*--> BOC: SPARIMI - 07/19/19 ED1K910678
      IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-sub_total LT 0.
        CLEAR lv_amt.
        lv_amt = li_hdr_itm-hdr_gen-sub_total * ( -1 ).
      ELSEIF v_flg_cr IS  INITIAL AND li_hdr_itm-hdr_gen-sub_total GT 0.
        CLEAR lv_amt.
        lv_amt = li_hdr_itm-hdr_gen-sub_total.
      ENDIF.
*--> EOC: SPARIMI - 07/19/19 ED1K910678
      PERFORM f_get_exc_rate  USING lv_amt " li_hdr_itm-hdr_gen-sub_total
                                    v_cust_currency
                                    v_to_curr      " ++CR#ERPM-15475
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
*--> BOC: SPARIMI - 07/19/19 ED1K910678
      IF v_flg_cr IS NOT INITIAL AND li_hdr_itm-hdr_gen-tax LT 0.
        CLEAR:lv_amt.
        lv_amt = li_hdr_itm-hdr_gen-tax * ( -1 ).
      ELSEIF v_flg_cr IS  INITIAL AND li_hdr_itm-hdr_gen-tax GT 0.
        CLEAR:lv_amt.
        lv_amt = li_hdr_itm-hdr_gen-tax .
      ENDIF.
*--> EOC: SPARIMI - 07/19/19 ED1K910678
      PERFORM f_get_exc_rate  USING lv_amt " li_hdr_itm-hdr_gen-tax
                                    v_cust_currency
                                    v_to_curr      " ++CR#ERPM-15475
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.
  ENDIF.
  IF v_doc_currency NE v_loc_currency AND v_cust_currency NE v_loc_currency.
    " BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
    v_to_curr = v_loc_currency.
    " EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-sub_total
                                    v_loc_currency
                                    v_to_curr      " ++CR#ERPM-15475
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.

    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      PERFORM f_get_exc_rate  USING li_hdr_itm-hdr_gen-tax
                                    v_loc_currency
                                    v_to_curr      " ++CR#ERPM-15475
                           CHANGING lv_exc_rate
                                    lv_loc_amt.
    ENDIF.
  ENDIF.
  IF li_hdr_itm-itm_amounts[] IS INITIAL.
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
FORM f_get_exc_rate USING  fp_lv_forgn_amt TYPE any
                           fp_v_waers      TYPE waers      " Currency Key
                           fp_v_to_curr    TYPE tcurr_curr " ++CR#ERPM-15475
                 CHANGING  fp_lv_exc_rate  TYPE ukurs_curr        " Subtotal 6 from pricing procedure for condition
                           fp_lv_loc_amt   TYPE ukm_credit_limit. " Credit Limit

  DATA: li_exc_tab     TYPE zttqtc_exchange_tab_invoice,
        " BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
        lst_exch_rate  TYPE bapi1093_0,  " Struc: Exchange Rate
        lst_return_msg TYPE bapiret1,    " Struc: Return Msg
        " EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
        lst_exc_tab    TYPE ztqtc_exchange_tab_invoice, " Exchange Rate table structure for invoice forms
        v_bill_date_ex TYPE fkdat, "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
        v_inv_date_ex  TYPE fkdat. "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
* ------------------------------------------------------------------------ *

* Translate foreign currency amount to local currency

*--> BOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923
  " Before CR#ERPM-15475 changes, there is no IF v_doc_currency = v_ref_curr.
  " check to get the Exchange Rate using FM: BAPI_EXCHANGERATE_GETDETAIL
* Begin of ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
  CLEAR:v_bill_date_ex,v_inv_date_ex.
  v_bill_date_ex = v_bill_date - 1.
  v_inv_date_ex = li_hdr_itm-hdr_gen-invoice_date - 1.
* End of ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
  IF v_doc_currency = v_ref_curr.
    CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
      EXPORTING
        rate_type  = c_excrate_typ_m      " Exchange Rate type
        from_curr  = v_doc_currency       " Document Currency
        to_currncy = fp_v_to_curr         " Payer/Company Code Currency
*       date       = v_bill_date          " Billing Date "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
        date       = v_bill_date_ex       "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
      IMPORTING
        exch_rate  = lst_exch_rate
        return     = lst_return_msg.
    IF sy-subrc = 0.
      fp_lv_exc_rate = lst_exch_rate-exch_rate.
      fp_lv_loc_amt = fp_lv_forgn_amt * fp_lv_exc_rate.
      CLEAR lst_exch_rate.
    ELSE.
      CLEAR: fp_lv_exc_rate,
             fp_lv_loc_amt.
    ENDIF.

  ELSE.  " ELSE -> v_doc_currency = v_ref_curr.
*--> EOC: CR#ERPM-15475  KKRAVURI 07-APR-2020  ED2K917923

    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING
*       date             = li_hdr_itm-hdr_gen-invoice_date " Currency translation date "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
        date             = v_inv_date_ex                     "ADD:OTCM-31644:SGUDA:09-MAR-2021:ED2K921086
        foreign_amount   = fp_lv_forgn_amt                 " Amount in foreign currency
        foreign_currency = v_doc_currency                  " Currency key for foreign currency
        local_currency   = fp_v_waers                      " Currency key for local currency
      IMPORTING
        exchange_rate    = fp_lv_exc_rate                  " Exchange rate
        local_amount     = fp_lv_loc_amt                   " Amount in local currency
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
*    ELSE. " ELSE -> IF sy-subrc NE 0  " ++CR#ERPM-15475
      " Befor CR#ERPM-15475 changes, all the below Amount logic
      " is inside this ELSE block.
    ENDIF.

  ENDIF. " IF v_doc_currency = v_ref_curr.

* Amount
  IF fp_lv_exc_rate LT 0.
    fp_lv_exc_rate = 1 / ( -1 * fp_lv_exc_rate ).
  ENDIF. " IF fp_lv_exc_rate LT 0
  WRITE fp_lv_forgn_amt TO lst_exc_tab-amount CURRENCY v_doc_currency.
  CONDENSE lst_exc_tab-amount.
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-amount.
  CONCATENATE lst_exc_tab-amount '@' INTO lst_exc_tab-amount.
  WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate.
  CONDENSE lst_exc_tab-exc_rate.

  lst_exc_tab-loc_curr = fp_v_waers.

  CONCATENATE lst_exc_tab-loc_curr '=' INTO lst_exc_tab-loc_curr.
*- Begin of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
  IF v_doc_currency IN r_currency_from AND  v_cust_currency IN r_currency_to.
    DATA: lv_deci3 TYPE p DECIMALS 5,
          lv_deci4 TYPE char5,
          lv_deci2 TYPE p. "DECIMALS 2.
    lv_deci3 = fp_lv_loc_amt.
    lv_deci2 = ( floor( lv_deci3 * 100 ) ) / 100. "always rounded down
    WRITE lv_deci2 TO lst_exc_tab-conv_amt.
    SPLIT lst_exc_tab-conv_amt AT '.' INTO lst_exc_tab-conv_amt lv_deci4.
    CONDENSE lst_exc_tab-conv_amt.
  ELSE.
*- End of ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
    WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY fp_v_waers.
    CONDENSE lst_exc_tab-conv_amt.
  ENDIF. "ADD:OTCM-42834 INC0333245:SGUDA:30-SEP-2021:ED2K924649
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = lst_exc_tab-conv_amt.

  APPEND lst_exc_tab TO li_exc_tab.
  CLEAR: lst_exc_tab,
         fp_lv_exc_rate,
         fp_lv_loc_amt.
  APPEND LINES OF li_exc_tab TO li_hdr_itm-itm_amounts.
*  ENDIF.  " ++CR#ERPM-15475

ENDFORM.
*--> EOC: SPARIMI - 07/15/19 ED1K910591
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_TAX_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*--> BOC: SPARIMI - 07/15/19 ED1K910591
FORM f_build_tax_info.
  DATA : lst_tax_id TYPE ty_tax_id.
  CONSTANTS : lc_tax_id   TYPE rvari_vnam VALUE 'TAX_ID',
              lc_inv_desc TYPE rvari_vnam VALUE 'INVOICE_DESC'.
  CLEAR : li_hdr_itm-hdr_gen-invoice_description,
          li_hdr_itm-hdr_gen-seller_reg,
          li_hdr_itm-hdr_gen-buyer_reg,v_seller_reg.
*- Tax Id
  LOOP AT lt_const INTO DATA(lst_const) WHERE param1 = lc_tax_id   .
    lst_tax_id-land1 = lst_const-param2.
    lst_tax_id-stceg = lst_const-low.
    APPEND lst_tax_id TO i_tax_id.
    CLEAR lst_tax_id.
  ENDLOOP.

  READ TABLE lt_const INTO DATA(lst_const2) WITH KEY param1 = lc_inv_desc.
  IF sy-subrc EQ 0.
    v_inv_desc = lst_const2-low.
  ENDIF.
*--*Customer VAT
  IF i_tax_data IS NOT INITIAL.
    DATA(li_tax_data) = i_tax_data.
    SORT li_tax_data BY document doc_line_number.
    DELETE li_tax_data WHERE buyer_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING document doc_line_number.
    DATA(lv_lines) = lines( li_tax_data ).
    LOOP AT li_tax_data INTO DATA(lst_tax_data1).
      IF lv_lines = 1.
        li_hdr_itm-hdr_gen-buyer_reg = lst_tax_data1-buyer_reg.
      ENDIF. " IF lv_lines = 1
      IF lst_tax_data1-invoice_desc CS v_inv_desc
        AND v_invoice_desc IS INITIAL.
        v_invoice_desc = lst_tax_data1-invoice_desc.
      ENDIF. " IF lst_tax_data-invoice_desc CS v_inv_desc
    ENDLOOP. " LOOP AT li_tax_data INTO DATA(lst_tax_data)
*--*Tax ID
    DATA(li_tax_seller) = i_tax_data.
    SORT li_tax_seller BY seller_reg.
    DELETE li_tax_seller WHERE seller_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_tax_seller COMPARING seller_reg.
    SORT li_tax_seller BY document doc_line_number.

    DATA(li_tax_buyer) = i_tax_data.
    SORT li_tax_buyer BY document doc_line_number.
    DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

    DATA(li_tax_temp) = i_tax_data.
    DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
    SORT li_tax_temp BY buyer_reg.
    DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
    DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
    IF lv_tax_line EQ 1.
      READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-buyer_reg = lst_tax_temp-buyer_reg.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.
**--BOC: SKKAIRAMKO
*
*        READ TABLE i_tax_id INTO lst_tax_id
*               WITH KEY land1 = v_comp_code_ctry.
*          IF sy-subrc EQ 0.
*            IF v_seller_reg IS INITIAL.
*              v_seller_reg = lst_tax_id-stceg.
*            ELSEIF v_seller_reg NS lst_tax_id-stceg.
*              CONCATENATE lst_tax_id-stceg v_seller_reg INTO v_seller_reg SEPARATED BY ','.
*            ENDIF. " IF v_seller_reg IS INITIAL
*          ENDIF. " IF sy-subrc EQ 0
*
**-- EOC: SKKAIRAMKO
    LOOP AT li_bil_invoice-it_price  INTO DATA(lst_inv_it).
      READ TABLE li_tax_seller INTO DATA(lst_tax_seller) WITH KEY document = lst_inv_it-bil_number
                                                              doc_line_number = lst_inv_it-itm_number
                                                             BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF v_seller_reg IS INITIAL.
          v_seller_reg = lst_tax_seller-seller_reg.
          "BOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
          IF v_output_typ = c_zm3c.
            LOOP AT li_tax_seller INTO lst_tax_seller.
              IF sy-tabix = 1.
                v_seller_reg = lst_tax_seller-seller_reg.
              ENDIF.
              IF sy-tabix = 2.
                CONCATENATE lst_tax_seller-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY c_comma.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.""++ mimmadiset:OTCM 30816:12/23/2020:ED2K920979
        ELSE.
          CONCATENATE v_seller_reg lst_tax_seller-seller_reg  INTO v_seller_reg SEPARATED BY ', '.
        ENDIF.
      ELSEIF lst_inv_it-kzwi6 IS NOT INITIAL.
        IF v_comp_code_ctry EQ li_bil_invoice-hd_gen-dlv_land.
          READ TABLE i_tax_id INTO lst_tax_id
               WITH KEY land1 = li_bil_invoice-hd_gen-dlv_land.
          IF sy-subrc EQ 0.
            IF v_seller_reg IS INITIAL.
              v_seller_reg = lst_tax_id-stceg.
            ELSEIF v_seller_reg NS lst_tax_id-stceg.
              CONCATENATE lst_tax_id-stceg v_seller_reg INTO v_seller_reg SEPARATED BY ','.
            ENDIF. " IF v_seller_reg IS INITIAL
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP.

    IF v_seller_reg IS NOT INITIAL.
      CONDENSE v_seller_reg.
      li_hdr_itm-hdr_gen-seller_reg = v_seller_reg.
    ELSEIF v_comp_code_ctry EQ li_bil_invoice-hd_gen-dlv_land.
      READ TABLE i_tax_id INTO lst_tax_id
           WITH KEY land1 = li_bil_invoice-hd_gen-dlv_land.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-seller_reg = lst_tax_id-stceg.
      ENDIF.
    ENDIF.
    li_hdr_itm-hdr_gen-invoice_description =  v_invoice_desc.
  ENDIF.
**Boc OTCM-55639 mimmadiset 12/14/2021 ED2K925263
  IF  v_output_typ = c_zxyi.
    li_hdr_itm-hdr_gen-seller_reg = li_hdr_itm-hdr_gen-tax_id.
    CLEAR:li_hdr_itm-hdr_gen-tax_id.
  ENDIF.
**Eoc OTCM-55639 mimmadiset 12/14/2021 ED2K925263
  "BOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
  IF v_output_typ = c_zm3c.
    CLEAR:li_hdr_itm-hdr_gen-tax_id.
    IF v_seller_reg IS NOT INITIAL.
      SPLIT v_seller_reg AT c_comma INTO v_seller_reg
      li_hdr_itm-hdr_gen-tax_id.
      IF li_hdr_itm-hdr_gen-tax_id IS NOT INITIAL.
        CONCATENATE v_seller_reg c_comma INTO v_seller_reg.
        li_hdr_itm-hdr_gen-seller_reg = v_seller_reg.
      ENDIF.
    ENDIF.
*- Tax Id for us
**    READ TABLE li_vbrp INTO DATA(lst_vbrp)
**    WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number
**    lland_auft = c_us.
**    IF sy-subrc = 0.
**      READ TABLE li_t001z INTO DATA(lst_t001z) WITH KEY bukrs = li_bil_invoice-hd_org-salesorg.
**      IF sy-subrc EQ 0.
**        li_hdr_itm-hdr_gen-seller_reg = lst_t001z-paval.
**      ENDIF.
**    ENDIF.
    "BOC:OTCM-49815: ED2K924206,ED2K924265:07.28.2021: MIMMADISET
**    IF  li_hdr_itm-hdr_gen-seller_reg IS INITIAL.
**      READ TABLE lt_const INTO lst_const WITH KEY param1 = c_tax_code
**                                           param2 = li_bil_invoice-hd_org-salesorg.
**      IF sy-subrc NE 0.
**        READ TABLE li_t001z INTO lst_t001z WITH KEY bukrs = li_bil_invoice-hd_org-salesorg.
**        IF sy-subrc EQ 0.
**          li_hdr_itm-hdr_gen-seller_reg = lst_t001z-paval.
**        ENDIF.
**      ENDIF.
**    ENDIF.
** If IDT table is empty read the buyer reg number from dfkkbptaxnum
***    IF li_hdr_itm-hdr_gen-buyer_reg IS INITIAL AND
***       li_bil_invoice-hd_ref-order_numb IS NOT INITIAL.
***      SELECT SINGLE vbeln, parvw, kunnr
***     FROM vbpa INTO @DATA(ls_vbpa_dfk)
***     WHERE vbeln = @li_bil_invoice-hd_ref-order_numb
***     AND posnr = @c_header1
***     AND  parvw = @c_ag.  "Sold to party
***      IF sy-subrc EQ 0.
***        SELECT * FROM dfkkbptaxnum
***             INTO TABLE @DATA(li_dfkkbptaxnum)
***             WHERE partner = @ls_vbpa_dfk-kunnr.
****             AND   taxtype = ''.
***        IF li_dfkkbptaxnum[] IS NOT INITIAL.
***          READ TABLE li_dfkkbptaxnum INTO DATA(lst_dfkkbptaxnum) INDEX 1.
***          IF lst_dfkkbptaxnum IS NOT INITIAL.
***            li_hdr_itm-hdr_gen-buyer_reg  = lst_dfkkbptaxnum-taxnum.
***          ENDIF.
***        ENDIF.
***        REFRESH:li_dfkkbptaxnum.
***        CLEAR:ls_vbpa_dfk.
***      ENDIF.
***
***    ENDIF.
    "EOC:OTCM-49815:ED2K924206:07.28.2021: MIMMADISET
  ENDIF.
  "EOC mimmadiset:OTCM 30816:12/23/2020:ED2K920979
ENDFORM.
*--> EOC: SPARIMI - 07/15/19 ED1K910591

*&---------------------------------------------------------------------*
*&      Form  F_REMOVE_DECIMAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_WAERK_LOW  text
*----------------------------------------------------------------------*
FORM f_remove_decimal.
  CONSTANTS:lc_waerk   TYPE rvari_vnam VALUE 'WAERK'.        " Currency
  DATA:lv_conv_curr TYPE char18,
       lv_kbetr     TYPE bapicurr_d.
  READ TABLE lt_const INTO DATA(ls_waerk)
                          WITH KEY param1 = lc_waerk
                                   param2 = li_bil_invoice-hd_org-salesorg
                                   low = li_hdr_itm-hdr_gen-sub_tot_curr.
  IF sy-subrc = 0.
*** Display the amount as integer
***This flag is used to disply the amount integer or decimal based on the currency
    li_hdr_itm-hdr_gen-int_flag = abap_true.
    IF li_hdr_itm-hdr_gen-sub_total IS NOT INITIAL.
      lv_kbetr = li_hdr_itm-hdr_gen-sub_total.
      PERFORM curreny_con_to_external USING:ls_waerk-low
                                            lv_kbetr
                                       CHANGING lv_conv_curr.
      li_hdr_itm-hdr_gen-sub_total_char = lv_conv_curr.
    ELSE.
      li_hdr_itm-hdr_gen-sub_total_char = li_hdr_itm-hdr_gen-sub_total.
    ENDIF.
    IF li_hdr_itm-hdr_gen-tax IS NOT INITIAL.
      lv_kbetr = li_hdr_itm-hdr_gen-tax.
      PERFORM curreny_con_to_external USING:ls_waerk-low
                                            lv_kbetr
                                       CHANGING lv_conv_curr.
      li_hdr_itm-hdr_gen-tax_char = lv_conv_curr.
    ELSE.
      li_hdr_itm-hdr_gen-tax_char = li_hdr_itm-hdr_gen-tax.
    ENDIF.
    IF li_hdr_itm-hdr_gen-total_due IS NOT INITIAL.
      lv_kbetr = li_hdr_itm-hdr_gen-total_due.
      PERFORM curreny_con_to_external USING:ls_waerk-low
                                            lv_kbetr
                                       CHANGING lv_conv_curr.
      li_hdr_itm-hdr_gen-total_due_char = lv_conv_curr.
    ELSE.
      li_hdr_itm-hdr_gen-total_due_char = li_hdr_itm-hdr_gen-total_due.
    ENDIF.
*******Logic tax and total display as internal format.
    LOOP AT li_hdr_itm-itm_gen ASSIGNING FIELD-SYMBOL(<fs_gen>).
      IF <fs_gen>-tax IS NOT INITIAL.
        lv_kbetr = <fs_gen>-tax.
        PERFORM curreny_con_to_external USING:ls_waerk-low
                                              lv_kbetr
                                         CHANGING lv_conv_curr.
        <fs_gen>-tax_char = lv_conv_curr.
      ENDIF.
      IF <fs_gen>-total IS NOT INITIAL.
        lv_kbetr = <fs_gen>-total.
        PERFORM curreny_con_to_external USING:ls_waerk-low
                                              lv_kbetr
                                         CHANGING lv_conv_curr.
        <fs_gen>-total_char = lv_conv_curr.
      ENDIF.
****BOC MIMMADISET ED2K924913 OTCM-42633
      IF li_bil_invoice-hd_gen-bil_type = c_zcr.  " 'ZCR'
        IF <fs_gen>-students IS NOT INITIAL."Add negative value
          <fs_gen>-students = c_under && <fs_gen>-students.
        ENDIF.
      ENDIF.
****EOC MIMMADISET ED2K924913 OTCM-42633
    ENDLOOP.
****BOC MIMMADISET ED2K924913 OTCM-42633
********Get the service rendered date from VBRP table
    SELECT  vbeln,    " Billing Document
               posnr, " Billing item
               fbuda  "Date on which services rendered
              FROM vbrp
              INTO TABLE @DATA(li_vbrp_ren)
              FOR ALL ENTRIES IN @li_bil_invoice-it_gen
              WHERE vbeln = @li_bil_invoice-it_gen-bil_number
              AND fbuda IS NOT NULL.
    IF sy-subrc = 0.
*read the Service Rendered Date “VBRP-FBUDA” from first item
*with data and display as “Serv. rendered Dt: ”
      READ TABLE li_vbrp_ren INTO DATA(ls_vbrp) INDEX 1.
      IF sy-subrc = 0.
        li_hdr_itm-hdr_gen-ser_rend_date = ls_vbrp-fbuda.
        li_hdr_itm-hdr_gen-ser_rend_text = text-032. "Serv. rendered Dt:
      ENDIF.
    ENDIF.
**EOC MIMMADISET ED2K924913 OTCM-42633
  ELSE.
*** Display the amount as decimal
    li_hdr_itm-hdr_gen-sub_total_char = li_hdr_itm-hdr_gen-sub_total.
    PERFORM f_put_sign_in_front CHANGING li_hdr_itm-hdr_gen-sub_total_char.
    li_hdr_itm-hdr_gen-tax_char = li_hdr_itm-hdr_gen-tax.
    PERFORM f_put_sign_in_front CHANGING li_hdr_itm-hdr_gen-tax_char.
    li_hdr_itm-hdr_gen-total_due_char = li_hdr_itm-hdr_gen-total_due.
    PERFORM f_put_sign_in_front CHANGING li_hdr_itm-hdr_gen-total_due_char.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CURRENY_CON_TO_INTERNAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_WAERK  text
*      <--P_LV_KBETR  text
*----------------------------------------------------------------------*
FORM curreny_con_to_external  USING fp_waerk  TYPE salv_de_selopt_low
                                    fp_lv_kbetr TYPE bapicurr_d
                              CHANGING fp_conv_cur TYPE char18.
  DATA: lv_amt_external TYPE bapicurr-bapicurr,
        lv_currency     TYPE tcurc-waers.
  CLEAR:lv_amt_external.
  lv_currency = fp_waerk.
  " Conver the price value to internal format based on currency
  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
    EXPORTING
      currency        = lv_currency
      amount_internal = fp_lv_kbetr
    IMPORTING
      amount_external = lv_amt_external.
  fp_conv_cur = lv_amt_external.
  PERFORM f_put_sign_in_front CHANGING fp_conv_cur.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PUT_SIGN_IN_FRONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_HDR_ITM_HDR_GEN_SUB_TOTAL_C  text
*----------------------------------------------------------------------*
FORM f_put_sign_in_front  CHANGING fp_sign TYPE char18.
  CONDENSE fp_sign.
  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = fp_sign.
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
*      <--P_LI_LINES  text
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
*&      Form  F_READ_INV_NOTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_inv_notes .
*Boc mimmadiset ED2K925763 2/11/2022 OTCM_59059
  DATA(lv_sales_area) = li_bil_invoice-hd_org-comp_code &&
                        li_bil_invoice-hd_org-distrb_channel &&
                        li_bil_invoice-hd_org-division.
*Eoc mimmadiset ED2K925763 2/11/2022 OTCM_59059
*- Invoice Description
  IF li_bil_invoice-hd_gen-bil_type = c_zcr.  " 'ZCR'
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_cr_note
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      CONCATENATE  lst_const-low li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Credit memo
    ENDIF.
*Boc mimmadiset ED2K925763 2/11/2022 OTCM_59059
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_cr_note
                                               param2 = lv_sales_area.
    IF sy-subrc = 0.
      CONCATENATE  lst_const-low li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Credit memo
    ENDIF.
*Eoc mimmadiset ED2K925763 2/11/2022 OTCM_59059
*++BOC OTCM-44643 ED2K924913."Logic to read the reference invoice number
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_ref_inv
                                              param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0."Ref. Invoice No
      IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
        SELECT SINGLE * FROM vbrk
                   INTO @DATA(ls1_vbrk_org1)
                   WHERE vbeln = @li_bil_invoice-hd_gen-bil_number.
        IF sy-subrc = 0.
          SELECT SINGLE * FROM vbrk
                  INTO @DATA(ls_vbrk_org1)
                  WHERE vbeln = @ls1_vbrk_org1-xblnr.
        ENDIF.
      ENDIF.
      li_hdr_itm-hdr_gen-cancel_inv_text = text-021.
      li_hdr_itm-hdr_gen-cancel_coolen = c_colen.
      li_hdr_itm-hdr_gen-cancel_inv_no = ls_vbrk_org1-vbeln.
    ENDIF.
*++EOC OTCM-44643 ED2K924913
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_tax_crnote
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
        SELECT SINGLE * FROM vbrk
                   INTO @DATA(ls1_vbrk_org)
                   WHERE vbeln = @li_bil_invoice-hd_gen-bil_number.
        IF sy-subrc = 0.
          SELECT SINGLE * FROM vbrk
                  INTO @DATA(ls_vbrk_org)
                  WHERE vbeln = @ls1_vbrk_org-xblnr.
          IF sy-subrc = 0.
            li_hdr_itm-hdr_gen-cr_invoice_date = ls_vbrk_org-fkdat.
            li_hdr_itm-hdr_gen-cancel_inv_no = ls_vbrk_org-vbeln.
            li_hdr_itm-hdr_gen-cancel_inv_text = text-027. "Original Tax Invoice
            li_hdr_itm-hdr_gen-cancel_coolen = c_colen.
            li_hdr_itm-hdr_gen-cr_invoice_text = text-028. "Original Tax Invoice date
          ENDIF.
        ENDIF.
      ENDIF.
      IF li_bil_invoice-hd_ref-order_numb IS NOT INITIAL.
        SELECT SINGLE * FROM vbak INTO @DATA(ls_vbak)
          WHERE vbeln = @li_bil_invoice-hd_ref-order_numb.
        IF sy-subrc = 0.
          SELECT SINGLE bezei FROM tvaut
                 INTO @DATA(lv_bezei)
                 WHERE spras = @sy-langu
                 AND augru = @ls_vbak-augru.
          IF sy-subrc = 0.
            li_hdr_itm-hdr_gen-cr_notes = lv_bezei.
            li_hdr_itm-hdr_gen-cr_coolen_note = c_colen.
            li_hdr_itm-hdr_gen-cr_note_des = text-029.  "Reason for the credit
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*Boc mimmadiset ED2K925763 2/11/2022 OTCM_59059
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_tax_crnote
                                                 param2 = lv_sales_area.
    IF sy-subrc = 0.
      IF li_bil_invoice-hd_ref-order_numb IS NOT INITIAL.
        SELECT SINGLE * FROM vbak INTO @DATA(ls1_vbak)
          WHERE vbeln = @li_bil_invoice-hd_ref-order_numb.
        IF sy-subrc = 0.
          SELECT SINGLE bezei FROM tvaut
                 INTO @DATA(lv1_bezei)
                 WHERE spras = @sy-langu
                 AND augru = @ls1_vbak-augru.
          IF sy-subrc = 0.
            li_hdr_itm-hdr_gen-cr_notes = lv1_bezei.
            li_hdr_itm-hdr_gen-cr_coolen_note = c_colen.
            li_hdr_itm-hdr_gen-cr_note_des = text-038.  "Reason for the credit ++BOC ED2K926874 MIMMADISET OTCM 62551
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*Eoc mimmadiset ED2K925763 2/11/2022 OTCM_59059
  ELSEIF li_bil_invoice-hd_gen-bil_type = c_zdr.  " 'ZDR'
*++BOC OTCM-53499 ED2K924913
  ELSEIF li_bil_invoice-hd_gen-bil_type = c_zhcr.  " 'ZHCR'
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_cr_note_zhcr
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      CONCATENATE  lst_const-low li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space.
    ENDIF.
*++EOC OTCM-53499 ED2K924913
  ELSEIF li_bil_invoice-hd_gen-bil_type = c_zs1.  " 'zs1
*++BOC OTCM-44643 ED2K924913
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_can_note
                                               param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      CONCATENATE text-031 li_bil_invoice-hd_gen-bil_number
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space.
    ENDIF.
*++EOC OTCM-44643 ED2K924913
  ELSE.
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_inv_note
                                                param2 = li_bil_invoice-hd_org-comp_code.
    IF sy-subrc = 0.
      CONCATENATE  lst_const-low li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Invoice
    ENDIF.
*Boc mimmadiset ED2K925763 2/11/2022 OTCM_59059
    READ TABLE lt_const INTO lst_const WITH KEY param1 = c_inv_note
                                               param2 = lv_sales_area.
    IF sy-subrc = 0.
      CONCATENATE  lst_const-low li_hdr_itm-hdr_gen-invoice_numb
      INTO li_hdr_itm-hdr_gen-invoice_desc SEPARATED BY space."Invoice
    ENDIF.
*Eoc mimmadiset ED2K925763 2/11/2022 OTCM_59059
  ENDIF.

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
                              CHANGING fi_emailid TYPE tt_emailid. "p_v_send_email.
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
**boc mimmadiset:OTCM 30816:12/23/2020:ED2K920979
*        p_v_send_email = lst_tline-tdline.
*        CONDENSE p_v_send_email.
        CONDENSE lst_tline-tdline.
        ls_emailid-smtp_addr = lst_tline-tdline.
        APPEND ls_emailid TO fi_emailid.
**eoc mimmadiset:OTCM 30816:12/23/2020:ED2K920979
      ENDIF.
    ENDIF.
  ELSE.
  ENDIF.
ENDFORM.
