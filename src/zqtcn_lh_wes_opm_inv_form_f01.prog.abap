*&---------------------------------------------------------------------*
*&  Include           ZQTCN_LH_WES_OPM_INV_FORM_F01
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
  IF v_output_typ = c_zopm.
* Build header and item structur for Adobe form
    PERFORM f_build_hdr_itm_for_form.
* Subroutine to populate layout.
    v_formname = c_zopm_form_name.
    IF nast-nacha EQ '1'.
      PERFORM  f_populate_layout USING v_formname.
    ELSEIF nast-nacha EQ '5'.
* Perform has been used to send mail with an attachment of PDF
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ENDIF.
  ELSEIF v_output_typ = c_zsga.
    v_formname = c_zsga_form_name.
* Build header and item structur for Adobe form
    PERFORM f_build_hdr_itm_for_form.
* Subroutine to populate layout.
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
  IF nast-objky+10 NE space.
    nast-objky = nast-objky+16(10).
  ELSE.
    nast-objky = nast-objky.
  ENDIF.
  v_output_typ = nast-kschl.
* read print data
  CALL FUNCTION 'LB_BIL_INV_OUTP_READ_PRTDATA'
    EXPORTING
      if_bil_number         = nast-objky
      if_parvw              = nast-parvw
      if_parnr              = nast-parnr
      if_language           = nast-spras
      is_print_data_to_read = li_print_data_to_read "is_print_data_to_read
    IMPORTING
      es_bil_invoice        = li_bil_invoice
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
*  error handling
    v_ent_retco = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF.
  IF li_bil_invoice-it_gen[] IS NOT INITIAL.
    SELECT * FROM makt
             INTO TABLE li_makt
             FOR ALL ENTRIES IN li_bil_invoice-it_gen
             WHERE matnr = li_bil_invoice-it_gen-material.
  ENDIF.

  IF li_bil_invoice-hd_part_add[] IS NOT INITIAL.
    SELECT * FROM kna1
             INTO TABLE li_kna1
             FOR ALL ENTRIES IN li_bil_invoice-hd_part_add
             WHERE kunnr = li_bil_invoice-hd_part_add-partn_numb.
    IF li_kna1[] IS NOT INITIAL.
      SELECT * FROM adrc
               INTO TABLE li_adrc_part
               FOR ALL ENTRIES IN li_kna1
               WHERE addrnumber = li_kna1-adrnr.
    ENDIF.
  ENDIF.
  IF  li_bil_invoice-it_gen[] IS NOT INITIAL.
    SELECT * FROM tvlvt
             INTO TABLE li_tvlvt
             FOR ALL ENTRIES IN li_bil_invoice-it_gen
             WHERE abrvw = li_bil_invoice-it_gen-vkaus.
  ENDIF.
  IF  li_bil_invoice-hd_org-salesorg IS NOT INITIAL.
    SELECT * FROM t001
             INTO TABLE li_t001
             WHERE bukrs = li_bil_invoice-hd_org-salesorg.
    IF li_t001[] IS NOT INITIAL.
      SELECT * FROM adrc
               INTO TABLE li_adrc
               FOR ALL ENTRIES IN li_t001
               WHERE addrnumber = li_t001-adrnr."'0000067895'."li_bil_invoice-hd_org-salesorg_adr.
    ENDIF.
    SELECT * FROM t001z
             INTO TABLE li_t001z
             WHERE bukrs = li_bil_invoice-hd_org-salesorg.
  ENDIF.
  IF li_bil_invoice-hd_gen-bil_number IS NOT INITIAL.
    SELECT * FROM vbrk
             INTO TABLE li_vbrk
             WHERE vbeln = li_bil_invoice-hd_gen-bil_number.
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
FORM f_protocol_update .

  CHECK v_ent_screen = space.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb = syst-msgid
      msg_nr    = syst-msgno
      msg_ty    = syst-msgty
      msg_v1    = syst-msgv1
      msg_v2    = syst-msgv2
      msg_v3    = syst-msgv3
      msg_v4    = syst-msgv4
    EXCEPTIONS
      OTHERS    = 1.
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
*  DATA: LT_FIELDLIST TYPE TSFFIELDS.

* set print data requirements
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

  TYPES :        BEGIN OF ty_tax_item,
                   subs_type      TYPE ismmediatype,
                   media_type     TYPE char255,
                   tax_percentage TYPE char16, " Percentage of type CHAR16
                   taxable_amt    TYPE kzwi1,  " Subtotal 1 from pricing procedure for condition
                   tax_amount     TYPE kzwi6,  " Subtotal 6 from pricing procedure for condition
                 END OF ty_tax_item,

                 tt_tax_item TYPE STANDARD TABLE OF ty_tax_item.

  DATA :          lv_taxable_amt     TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
                  lv_tax_amount      TYPE p DECIMALS 3,            " Subtotal 6 from pricing procedure for condition
                  lst_tax_item       TYPE ty_tax_item,
                  li_tax_item        TYPE tt_tax_item,
                  lv_kbetr           TYPE kbetr,
                  lst_tax_item_final TYPE zstqtc_tax_item_f042,    " Structure for tax components
                  i_tax_item         TYPE zttqtc_tax_item_f042.                 " Rate (condition amount or percentage)

  CONSTANTS : lc_percent TYPE char1 VALUE '%', " Percent of type CHAR1
              lc_prod    TYPE char4 VALUE 'EP1'.

*--------------------------------------------------------------------*
  IF li_bil_invoice-hd_gen-kond_numb IS NOT INITIAL.
    SELECT knumv, "Number of the document condition
           kposn, "Condition item number
           stunr, "Step number
           zaehk, "Condition counter
           kappl, " Application
           kawrt, "Condition base value
           kbetr, "Rate (condition amount or percentage)
           kwert, "Condition value
           kinak, "Condition is inactive
           koaid  "Condition class
      FROM konv   "Conditions (Transaction Data)
      INTO TABLE @DATA(li_tkomv)
      WHERE knumv = @li_bil_invoice-hd_gen-kond_numb
        AND kinak = ''.

    IF sy-subrc IS INITIAL.
      SORT li_tkomv BY kposn.
      DELETE li_tkomv WHERE koaid NE 'D'.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF.

*- Sales Org Detailes
  READ TABLE li_t001 INTO DATA(lst_t001) WITH KEY bukrs = li_bil_invoice-hd_org-salesorg.
  IF sy-subrc EQ 0.
    READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_t001-adrnr."'0000067895'."li_bil_invoice-hd_org-salesorg_adr.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-sales_org_name   = li_bil_invoice-hd_org-salesorg."lst_adrc-name1.
      li_hdr_itm-hdr_gen-sales_org_adrnr  = lst_adrc-addrnumber."'0000067895'."li_bil_invoice-hd_org-salesorg."lst_adrc-name1.
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
    li_hdr_itm-hdr_gen-tax_id = lst_t001z-paval."'37-1523117'."li_bil_invoice-hd_gen-t001z_vat.
  ENDIF.
*- Customer Sevice mail ID
  li_hdr_itm-hdr_gen-cust_service = c_cust_mail.
*- Invoice Number
  li_hdr_itm-hdr_gen-invoice_numb =  li_bil_invoice-hd_gen-bil_number.
*- Client Number
  li_hdr_itm-hdr_gen-client_numb = li_bil_invoice-hd_gen-sold_to_party.
*- Tax exempt text
  READ TABLE li_vbrk INTO DATA(lst_vbrk) WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number.
  IF lst_vbrk-taxk1 = 0.
    li_hdr_itm-hdr_gen-tax_expt_text = c_tax_text."'Tax Exempt'.
  ELSE.
    CLEAR li_hdr_itm-hdr_gen-tax_expt_text .
  ENDIF.
*- Billing Date
  li_hdr_itm-hdr_gen-invoice_date =  li_bil_invoice-hd_gen-bil_date.
*- Payment term text
  li_hdr_itm-hdr_gen-terms = li_bil_invoice-hd_gen_descript-name_paymterm.
*- Payment term calc date
  li_hdr_itm-hdr_gen-due_date = li_bil_invoice-hd_gen_descript-name_pterms1+6(10).
*- Bill-to Name

  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_part) WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
                                                                     partn_role = c_re.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO DATA(lst_adrc_part) WITH KEY addrnumber = lst_kna1-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-bill_to_name = lst_adrc_part-name1.
        IF lst_adrc_part-name_co IS NOT INITIAL.
          CONCATENATE c_attn lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-bill_to_attin SEPARATED BY c_colen.
        ENDIF.
        li_hdr_itm-hdr_gen-bill_to_street   = lst_adrc_part-street.
        li_hdr_itm-hdr_gen-bill_to_city1    = lst_adrc_part-city1.
        li_hdr_itm-hdr_gen-bill_to_region   = lst_adrc_part-region.
        li_hdr_itm-hdr_gen-bill_to_post     = lst_adrc_part-post_code1.
        li_hdr_itm-hdr_gen-bill_to_address  = lst_kna1-adrnr.
      ENDIF.
    ENDIF.
  ENDIF.
*- Ship-to Name
  READ TABLE li_bil_invoice-hd_part_add INTO lst_part WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
                                                                     partn_role = c_we.
  IF sy-subrc EQ 0.
    READ TABLE li_kna1 INTO lst_kna1 WITH KEY kunnr = lst_part-partn_numb.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc_part INTO lst_adrc_part WITH KEY addrnumber = lst_kna1-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-ship_to_name = lst_adrc_part-name1.
        IF lst_adrc_part-name_co IS NOT INITIAL.
          CONCATENATE c_attn lst_adrc_part-name_co INTO  li_hdr_itm-hdr_gen-ship_to_attin SEPARATED BY  c_colen.
        ENDIF.
        li_hdr_itm-hdr_gen-ship_to_street   = lst_adrc_part-street.
        li_hdr_itm-hdr_gen-ship_to_city1    = lst_adrc_part-city1.
        li_hdr_itm-hdr_gen-ship_to_region   = lst_adrc_part-region.
        li_hdr_itm-hdr_gen-ship_to_post     = lst_adrc_part-post_code1.
        li_hdr_itm-hdr_gen-ship_to_address  = lst_kna1-adrnr.
      ENDIF.
    ENDIF.
  ENDIF.
  IF sy-sysid <> lc_prod. "'EP1'.
    CONCATENATE 'TEST PRINT' sy-sysid sy-mandt INTO li_hdr_itm-hdr_gen-test_ref_doc SEPARATED BY '-'.
  ENDIF.
*- Invoice Note
  li_hdr_itm-hdr_gen-invoice_text_name = li_bil_invoice-hd_gen-bil_number.
  li_hdr_itm-hdr_gen-invoice_text_object = c_vbbk.
  li_hdr_itm-hdr_gen-invoice_text_id = c_0007.
  li_hdr_itm-hdr_gen-invoice_lang = li_bil_invoice-hd_org-salesorg_spras.
*- Sub Total
  li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr.
*- Currency
  li_hdr_itm-hdr_gen-sub_tot_curr = li_bil_invoice-hd_gen-bil_waerk.
*- Tax
  li_hdr_itm-hdr_gen-tax =  li_bil_invoice-hd_gen-bil_tax.
*- Total Due
  li_hdr_itm-hdr_gen-total_due = li_bil_invoice-hd_gen-bil_netwr + li_bil_invoice-hd_gen-bil_tax.
  LOOP AT li_bil_invoice-it_gen INTO DATA(lst_item_gen).
    lst_count-vbeln = lst_item_gen-bil_number.
    lst_count-posnr = lst_item_gen-itm_number.
    lst_count-arktx = lst_item_gen-short_text.
    lst_count-kdmat = lst_item_gen-cust_mat.
    lst_count-vkaus = lst_item_gen-vkaus.
    lst_count-pstyv = lst_item_gen-item_categ.
    READ TABLE li_makt INTO DATA(lst_mat) WITH KEY matnr = lst_item_gen-material.
    IF sy-subrc EQ 0.
      lst_count-maktx = lst_mat-maktx.
    ENDIF.
    APPEND lst_count TO li_count.
    CLEAR: lst_count,lst_item_gen.
  ENDLOOP.
  SORT li_count BY maktx kdmat vkaus pstyv.
*- Item Section
  LOOP AT li_count ASSIGNING FIELD-SYMBOL(<lst_count1>).
    READ TABLE li_tvlvt INTO DATA(lst_tvlvt) WITH KEY abrvw = <lst_count1>-vkaus.
    IF sy-subrc EQ 0 AND <lst_count1>-pstyv = c_zprg.
      CONCATENATE <lst_count1>-maktx lst_tvlvt-bezei INTO lst_itm_gen-item SEPARATED BY '-'.
    ELSE.
      lst_itm_gen-item = <lst_count1>-arktx.
    ENDIF.
    IF <lst_count1>-pstyv = c_zprg.
      CONCATENATE  <lst_count1>-kdmat <lst_count1>-arktx INTO lst_itm_gen-description SEPARATED BY '-'.
    ELSE.
      CLEAR lst_itm_gen-description.
    ENDIF.

    IF <lst_count1>-pstyv = c_zprg.
      lst_itm_gen-students = lst_itm_gen-students + 1. "lst_item_gen-fkimg.
    ELSE.
      READ TABLE li_bil_invoice-it_gen INTO DATA(lst_itm_gen_t) WITH KEY bil_number = <lst_count1>-vbeln
                                                                       itm_number = <lst_count1>-posnr.
      IF sy-subrc EQ 0.
        v_fkimg = lst_itm_gen_t-fkimg.
        CONDENSE v_fkimg.
        lst_itm_gen-students = v_fkimg+0(13).
      ENDIF.
    ENDIF.

    READ TABLE li_bil_invoice-it_price INTO DATA(lst_itm_price) WITH KEY bil_number = <lst_count1>-vbeln
                                                                         itm_number = <lst_count1>-posnr.
    IF sy-subrc EQ 0.
      lst_itm_gen-amount      = lst_itm_gen-amount + lst_itm_price-kzwi1.
      lst_itm_price-kzwi5     = lst_itm_price-kzwi5 * -1.
      lst_itm_gen-discounts   = lst_itm_gen-discounts + lst_itm_price-kzwi5.
      lst_itm_gen-tax         = lst_itm_gen-tax + lst_itm_price-kzwi6.
      lst_itm_gen-currency    = li_bil_invoice-hd_gen-bil_waerk.
      IF <lst_count1>-pstyv = c_zprg.
        lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.
      ELSE.
        lst_itm_gen-total = lst_itm_gen-total + lst_itm_price-netwr + lst_itm_price-kzwi6.
      ENDIF.
    ENDIF.
    AT END OF pstyv.
*      lst_itm_gen-total = lst_itm_gen-total + lst_itm_gen-amount + lst_itm_gen-tax - lst_itm_gen-discounts.

      APPEND lst_itm_gen TO li_itm_gen.
      CLEAR lst_itm_gen.
    ENDAT.
    CLEAR lst_count.
  ENDLOOP.
  li_hdr_itm-itm_gen[] = li_itm_gen[].


  LOOP AT li_bil_invoice-it_price  INTO DATA(lst_inv_it).
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_inv_it-itm_number.
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
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

    IF lst_inv_it-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL
    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*    IF lv_bom_hdr_flg IS INITIAL.
    COLLECT lst_tax_item INTO li_tax_item.
*    ENDIF. " IF lv_bom_hdr_flg IS INITIAL
  ENDLOOP.
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = 'Tax'."lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY li_bil_invoice-hd_gen-bil_waerk.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
  li_hdr_itm-itm_exc_tab[] =  i_tax_item[].

  v_division = li_bil_invoice-hd_org-division.
  CONDENSE v_division.
  CALL METHOD zcacl_abap_gbl_utilities=>meth_get_pdf_logo
    EXPORTING
      im_devid                = c_devid
      im_param1               = ''
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
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        st_formoutput       TYPE fpformoutput,
        lv_upd_tsk          TYPE i.                           "Added by MODUTTA

  lst_sfpoutputparams-preview = abap_true.
  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
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
    v_ent_retco = 900.
    RETURN.
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = fp_v_formname "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        LEAVE LIST-PROCESSING.
    ENDTRY.
    IF fp_v_formname EQ c_zopm_form_name.
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
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*         Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
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
          v_ent_retco = 900.
          RETURN.
*         End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911645
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDIF.



  IF lst_sfpoutputparams-arcmode <> '1' AND  v_ent_screen IS INITIAL.

    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = 'PDF' "  class
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
*    ENDIF. " IF v_screen_display IS INITIAL
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
  DATA: st_outputparams  TYPE sfpdocparams, "sfpoutputparams, " Form Processing Output Parameter
*        lst_sfpdocparams  TYPE fpformoutput,    " Form Parameters for Form Processing
        lv_form          TYPE tdsfname,        " Smart Forms: Form Name
        lv_fm_name       TYPE funcname, "rs38l_fnam,      " Name of Function Module
        li_output        TYPE ztqtc_output_supp_retrieval,
        lv_upd_tsk       TYPE i,               " Upd_tsk of type Integers
*lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
*        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
*        lv_funcname         TYPE funcname,                    " Function name
        lst_outputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams.                " Form Parameters for Form Processing
*        lv_funcname         TYPE funcname,                    " Function name
  IF v_ent_screen = abap_true.
    SELECT SINGLE b~smtp_addr
           INTO v_send_email
           FROM usr21 AS a INNER JOIN adr6 AS b ON
           a~addrnumber = b~addrnumber AND
           a~persnumber = b~persnumber
           WHERE bname = sy-uname.
    IF sy-subrc NE 0.
      p_fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
      RETURN.
* Email ID is not maintained in the user profile
      MESSAGE e244(zqtc_r2). " Email ID is not maintained in the user profile
    ENDIF. " IF sy-subrc NE 0
  ELSE. " ELSE -> IF v_screen_display = abap_true
*******Get email id from ADR6 table
    SELECT smtp_addr "E-Mail Address
      FROM adr6      "E-Mail Addresses (Business Address Services)
      INTO v_send_email
      UP TO 1 ROWS
      WHERE addrnumber EQ st_address-adrnr_bp.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE i243(zqtc_r2). " Email ID is not maintained for Ship to Customer
      p_fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
      RETURN.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF v_screen_display = abap_true

  IF p_fp_v_returncode = 0.
    lv_form = tnapr-sform.
    lst_outputparams-getpdf = abap_true.
    lst_outputparams-preview = abap_false.
  ENDIF. " IF fp_v_returncode = 0

*--- Set output parameters
*  lst_outputparams-preview   = v_screen_display. " launch print preview
  IF v_ent_screen EQ abap_true.
    lst_outputparams-nopributt = abap_true. " no print buttons in the preview
    lst_outputparams-noarchive = abap_true. " no archiving in the preview
  ENDIF. " IF v_screen_display EQ abap_true
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
    p_fp_v_returncode = sy-subrc.
    PERFORM f_protocol_update.
    RETURN.
  ENDIF. " IF sy-subrc <> 0

*--- Get the name of the generated function module
  TRY.
      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = lv_form
        IMPORTING
          e_funcname = lv_fm_name.

    CATCH cx_fp_api_repository
          cx_fp_api_usage
          cx_fp_api_internal.
      p_fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
      RETURN.
  ENDTRY.

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
    p_fp_v_returncode = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF. " IF sy-subrc <> 0

*--- Close the spool job
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    p_fp_v_returncode = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF. " IF sy-subrc <> 0

*  IF p_fp_v_returncode = 0.,

  IF lst_outputparams-arcmode <> '1' AND  v_ent_screen IS INITIAL.

    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = 'PDF' "  class
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
*    ENDIF. " IF v_screen_display IS INITIAL
  ENDIF. " IF fp_v_returncode = 0
********Perform is used to call E098 FM  & convert PDF in to Binary
  IF p_fp_v_returncode = 0.
    PERFORM f_call_fm_output_supp CHANGING li_output.

********Perform is used to create mail attachment with a creation of mail body
    PERFORM f_mail_attachment USING li_output
                              CHANGING p_fp_v_returncode.
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
FORM f_mail_attachment  USING    p_li_output
                        CHANGING p_fp_v_returncode.

******Local Constant Declaration
  DATA: lr_sender      TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
*        lv_send        TYPE adr6-smtp_addr,                        "variable to store email id
        li_lines       TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines      TYPE tline,                   " SAPscript: Text Lines
        li_email_data  TYPE solix_tab,
        lv_document_no TYPE saeobjid.                " SAP ArchiveLink: Object ID (object identifier)


********Local Constant Declaration
  CONSTANTS: lc_raw     TYPE so_obj_tp      VALUE 'RAW',                   "Code for document class
             lc_pdf     TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
             lc_i       TYPE bapi_mtype     VALUE 'I',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_s       TYPE bapi_mtype     VALUE 'S',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_st      TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
             lc_object  TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
             lc_name    TYPE thead-tdname   VALUE 'ZQTC_EMAIL_F032',       " Name
             lc_subject TYPE thead-tdname   VALUE 'ZQTC_EMAIL_SUBJECT_F043'. " Name


  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service
  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL, " BCS: Document Exceptions
        lv_subject      TYPE so_obj_des.                              " Short description of contents

  TRY .
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lv_flag           TYPE xfeld,                                    " Checkbox
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk        TYPE i,                                        " Upd_tsk of type Integers
        lv_sub            TYPE string.
********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = 'E' "st_header-language
      name                    = lc_name
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
      lst_message_body-line = lst_lines-tdline.
      lst_message_body-line = lst_lines-tdline.
      lst_message_body-line = lst_lines-tdline.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0

*  Populate email subject & body
  CLEAR li_lines[].
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = 'E' "st_header-language
      name                    = lc_subject
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
    CLEAR lst_lines.
    READ TABLE li_lines INTO lst_lines INDEX 1.
    IF sy-subrc EQ 0.
      lv_sub = lst_lines-tdline.
      lv_subject = lst_lines-tdline.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw "'RAW'
      i_text = li_message_body
      i_subject = lv_subject ).
    CATCH cx_document_bcs.
    CATCH cx_send_req_bcs.
  ENDTRY.

  IF li_output IS NOT INITIAL.
    LOOP AT li_output INTO DATA(lst_output).
*    For passing in document number
      lv_document_no = lv_document_no.
      CALL FUNCTION 'ZQTC_OUTPUT_SUPP_SAVE_OR_SEND'
        EXPORTING
*         IM_SAVE_FILE       =
          im_send_email      = abap_true
          im_doc_number      = lv_document_no
          im_pdf_stream      = lst_output-pdf_stream
          im_attachment_name = lst_output-attachment_name
          im_order           = abap_true
          im_attach_doc      = lv_flag
        IMPORTING
          ex_email_data      = li_email_data
        EXCEPTIONS
          file_not_found     = 1
          OTHERS             = 2.
      IF sy-subrc <> 0.
        RAISE file_not_found.
      ENDIF. " IF sy-subrc <> 0

      IF li_email_data IS NOT INITIAL.
        IF v_send_email IS NOT INITIAL.

*        Send email with the attachments we are getting from FM
          TRY.
              lr_document->add_attachment(
              EXPORTING
              i_attachment_type = lc_pdf "'PDF'
              i_attachment_subject = lst_output-attachment_name+0(50)
              i_att_content_hex = li_email_data ).
            CATCH cx_document_bcs INTO lx_document_bcs.
*Exception handling not required
          ENDTRY.

          CALL METHOD lr_send_request->set_message_subject
            EXPORTING
              ip_subject = lv_sub.
* Add attachment
          TRY.
              CALL METHOD lr_send_request->set_document( lr_document ).
            CATCH cx_send_req_bcs.
*Exception handling not required
          ENDTRY.
          CLEAR: lst_output,li_email_data.
        ENDIF. " IF v_send_email IS NOT INITIAL
      ENDIF. " IF li_email_data IS NOT INITIAL
    ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
  ENDIF. " IF fp_li_output IS NOT INITIAL


  IF li_email_data IS NOT INITIAL.
    IF v_send_email IS NOT INITIAL.
*        Send email with the attachments we are getting from FM
      TRY.
          lr_document->add_attachment(
          EXPORTING
          i_attachment_type = lc_pdf "'PDF'
          i_attachment_subject = 'Wiley Edu Invoice Form - OPM'
          i_att_content_hex = li_email_data ).
        CATCH cx_document_bcs INTO lx_document_bcs.
*Exception handling not required
      ENDTRY.

* Add attachment
      TRY.
          CALL METHOD lr_send_request->set_document( lr_document ).
        CATCH cx_send_req_bcs.
*Exception handling not required
      ENDTRY.
      CLEAR: li_email_data.
    ENDIF. " IF v_send_email IS NOT INITIAL
  ENDIF. " IF li_email_data IS NOT INITIAL

  IF v_send_email IS NOT INITIAL.

* Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).

* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).
      CATCH cx_address_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.

* Create recipient
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_send_email ).
** Set recipient
        lr_send_request->add_recipient(
        EXPORTING
        i_recipient = lr_recipient
        i_express = abap_true ).
      CATCH cx_address_bcs.
      CATCH cx_send_req_bcs.
    ENDTRY.

* Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
        MESSAGE text-006 TYPE lc_s . "'I'.
      CATCH cx_send_req_bcs.
    ENDTRY.

*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0

    IF lv_sent_to_all = abap_true.
      MESSAGE 'Email sent successfully' TYPE lc_s . "'I'.
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF v_send_email IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_FM_OUTPUT_SUPP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_OUTPUT  text
*----------------------------------------------------------------------*
FORM f_call_fm_output_supp  CHANGING p_li_output.

ENDFORM.
