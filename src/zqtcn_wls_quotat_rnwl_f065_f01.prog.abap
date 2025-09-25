*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_QUOTAT_RNWL_F065_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME    : ZQTCR_WLS_QUOTATION_RNWL_F065
* DESCRIPTION     : This driver program implemented for WLS
*                   Quotation Renewal forms F065
* DEVELOPER       : VDPATABALL
* CREATION DATE   : 06/29/2020
* OBJECT ID       : ERPM-20839/F065
* TRANSPORT NUMBER(S):ED2K918582
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920414
* REFERENCE NO    : OTCM-32214 /F067
* DEVELOPER       : VDPATABALL
* DATE            : 11/23/2020
* DESCRIPTION     : WES DA-New Quotation form changes
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_INV_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_ENT_RETCO  text
*----------------------------------------------------------------------*
FORM f_processing_inv_form  CHANGING fp_v_returncode TYPE sysubrc.
*- clear data
  PERFORM f_get_clear.

*- determine print data
  PERFORM f_set_print_data_to_read.

*- select print data
  PERFORM f_get_data.

*- Perform has been used to send mail with an attachment of PDF
  IF v_ent_screen  EQ abap_false.
    IF nast-nacha = c_5.
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ELSE.
      PERFORM f_form_layout.
    ENDIF.
  ELSE.
*--Get the Form Layout
    PERFORM f_form_layout.
  ENDIF.
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
  FREE:i_const,
       i_hdr_itm,
       i_print_data_to_read,
       st_formoutput,
       i_content_hex,
       v_formname,
       v_send_email,
       v_retcode,
       v_er_name,
       v_persn_adrnr,
       v_logo,
       v_bmp,
       st_vbak,
       st_vbpa.
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
                     i_print_data_to_read TO <fs_print_data_to_read>.
    IF sy-subrc <> 0. EXIT. ENDIF.
    <fs_print_data_to_read> = abap_true.
  ENDDO.
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

*---Get the Quotation Details
  SELECT SINGLE *
    FROM vbak
    INTO st_vbak
    WHERE vbeln = nast-objky.
  IF nast-kschl = c_zwqt. "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
    FREE:i_hdr_itm,i_hdr_itm_f067.
*---get the constant details
    PERFORM f_get_zcaconstant USING c_devid_f065.
*---Get the form Logo
    PERFORM f_get_logo CHANGING v_bmp.
*----Get The company Code address
    PERFORM f_get_sales_org_details USING i_hdr_itm-hdr_gen.
*---get the Bill to address
    PERFORM f_get_bill_ship_to_details USING st_vbak c_re.
*---get the Ship to address
    PERFORM f_get_bill_ship_to_details USING st_vbak c_we.
*---Get  Header Details
    PERFORM f_get_header_details USING c_devid_f065.
*---Get Line Item Details
    PERFORM f_get_line_item_details.
*---Begin of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
  ELSEIF nast-kschl = c_zqda.
    FREE:i_hdr_itm,i_hdr_itm_f067.
*---Get the Constant Details
    PERFORM f_get_zcaconstant USING c_devid_f067.
*----Get The company Code address
    PERFORM f_get_sales_org_details USING i_hdr_itm-hdr_gen.
*---get the Bill to address
    PERFORM f_get_bill_ship_to_details USING st_vbak c_re.
*---get the Ship to address
    PERFORM f_get_bill_ship_to_details USING st_vbak c_we.
*---Get  Header Details
    PERFORM f_get_header_details USING c_devid_f067.
*---Fill the F067 form header values
    PERFORM f_get_header_fill_f047_zqda.
*---Get and fill the F067 Line item Values
    PERFORM f_get_line_item_details_zqda.
  ENDIF.
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_ZCACONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_DEVID  text
*----------------------------------------------------------------------*
FORM f_get_zcaconstant  USING p_c_devid TYPE zdevid.
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/..)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @i_const
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @p_c_devid
      AND activate EQ @abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_BMP  text
*----------------------------------------------------------------------*
FORM f_get_logo  CHANGING fp_v_xstring TYPE xstring.

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
*&      Form  F_GET_SALES_ORG_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_sales_org_details  USING fp_hdr_gen TYPE zstqtc_wls_quotat_hdr_f065.
  SELECT SINGLE vkorg, vtext
            FROM tvkot
            INTO @DATA(ls_tvkot)
            WHERE spras EQ @c_e
              AND vkorg EQ @st_vbak-vkorg.
  IF sy-subrc EQ 0.
    i_hdr_itm-hdr_gen-sales_org_name   = ls_tvkot-vtext.
    SELECT SINGLE vkorg, adrnr
         FROM tvko
         INTO @DATA(ls_tvko)
         WHERE vkorg EQ @st_vbak-vkorg.
    IF sy-subrc EQ 0.
      SELECT SINGLE addrnumber, city1, post_code1,
             street, house_num1, region, country
        FROM adrc
        INTO @DATA(ls_adrc)
        WHERE addrnumber = @ls_tvko-adrnr.
      IF sy-subrc EQ 0.
*---Begin of Comment and Change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
*        i_hdr_itm-hdr_gen-sales_org_adrnr  = ls_adrc-addrnumber.
*        i_hdr_itm-hdr_gen-sales_org_house1 = ls_adrc-house_num1.
*        i_hdr_itm-hdr_gen-sales_org_street = ls_adrc-street.
*        i_hdr_itm-hdr_gen-sales_org_city1  = ls_adrc-city1.
*        i_hdr_itm-hdr_gen-sales_org_reg    = ls_adrc-region.
*        i_hdr_itm-hdr_gen-sales_org_post1  = ls_adrc-post_code1.
*        i_hdr_itm-hdr_gen-sales_org_ctry   = ls_adrc-country.
        fp_hdr_gen-sales_org_adrnr  = ls_adrc-addrnumber.
        fp_hdr_gen-sales_org_house1 = ls_adrc-house_num1.
        fp_hdr_gen-sales_org_street = ls_adrc-street.
        fp_hdr_gen-sales_org_city1  = ls_adrc-city1.
        fp_hdr_gen-sales_org_reg    = ls_adrc-region.
        fp_hdr_gen-sales_org_post1  = ls_adrc-post_code1.
        fp_hdr_gen-sales_org_ctry   = ls_adrc-country.
*---End of Comment and Change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_BILL_SHIP_TO_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBAK  text
*      -->P_0075   text
*----------------------------------------------------------------------*
FORM f_get_bill_ship_to_details USING  fp_vbak  TYPE vbak
                                       fp_lv_bp TYPE parvw.

  DATA: lv_address_number TYPE adrc-addrnumber,
        li_bill_to_addr   TYPE TABLE OF szadr_printform_table_line,
        lv_lines          TYPE tdline.

  FREE:li_bill_to_addr,lv_address_number,lv_lines.

  SELECT SINGLE vbeln, parvw, adrnr
           FROM vbpa
           INTO @DATA(ls_vbpa)
           WHERE vbeln EQ @fp_vbak-vbeln
             AND parvw EQ @fp_lv_bp.
  IF sy-subrc EQ 0.
    SELECT SINGLE addrnumber, name1, city1, post_code1,
             street, house_num1, region, country
        FROM adrc
        INTO @DATA(ls_adrc)
        WHERE addrnumber = @ls_vbpa-adrnr.
    IF sy-subrc EQ 0.
      lv_address_number  = ls_adrc-addrnumber.
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
            CONCATENATE 'Attn:'(001) <lst_bill_to>-address_line
                   INTO <lst_bill_to>-address_line SEPARATED BY space.
          ENDIF.
        ENDIF.

        IF li_bill_to_addr IS NOT INITIAL.
          IF fp_lv_bp = c_re.
            LOOP AT li_bill_to_addr INTO DATA(lst_bill_to_addr).
              lv_lines = lst_bill_to_addr-address_line.
              APPEND lv_lines TO  i_hdr_itm-it_bill_to_addr.
            ENDLOOP.
            i_hdr_itm-hdr_gen-bill_to_name = ls_adrc-name1.
          ELSEIF fp_lv_bp = c_we.
            CLEAR lst_bill_to_addr.
            LOOP AT li_bill_to_addr INTO lst_bill_to_addr.
              lv_lines = lst_bill_to_addr-address_line.
              APPEND lv_lines TO  i_hdr_itm-it_ship_to_addr.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_HEADER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_header_details USING fp_devid TYPE zdevid  .
  DATA :li_top TYPE STANDARD TABLE OF vtopis.
  CONSTANTS : lc_tax_id TYPE rvari_vnam VALUE 'TAX_ID',
              lc_zwgpid TYPE bu_id_type VALUE 'ZWGPID'.

  FREE:li_top.
*- Quotation Number
  i_hdr_itm-hdr_gen-quotation_numb = st_vbak-vbeln.

*---Quotation Complete Text
  CONCATENATE 'Quotation Number:'(002) i_hdr_itm-hdr_gen-quotation_numb
             INTO i_hdr_itm-hdr_gen-quotation_text SEPARATED BY space.

  SELECT SINGLE idnumber FROM but0id INTO @DATA(lv_number) WHERE partner = @st_vbak-kunnr AND type = @lc_zwgpid .
  IF sy-subrc = 0.
    i_hdr_itm-hdr_gen-client_numb = lv_number.
  ELSE.
*- Client Number
    i_hdr_itm-hdr_gen-client_numb = st_vbak-kunnr.
  ENDIF.
*---Tax Exempt Display
  IF st_vbak-kunnr IS NOT INITIAL.
    SELECT SINGLE *
      FROM knvi
      INTO @DATA(lst_knvi)
      WHERE kunnr = @st_vbak-kunnr.

    IF lst_knvi-taxkd = c_zero.
      i_hdr_itm-hdr_gen-tax_expt_text = 'Tax Exempt'(003).
    ELSE.
      CLEAR i_hdr_itm-hdr_gen-tax_expt_text.
    ENDIF.
  ENDIF.

*---Create date
  i_hdr_itm-hdr_gen-quotation_date = st_vbak-erdat.

*---Shipment methid

  SELECT SINGLE vtext
    FROM tvsbt
    INTO i_hdr_itm-hdr_gen-ship_method
    WHERE spras = c_e
      AND vsbed = st_vbak-vsbed.

*---ZTERM description
  SELECT SINGLE zterm
    FROM vbkd
    INTO @DATA(lv_zterm)
    WHERE vbeln = @st_vbak-vbeln.
  IF sy-subrc = 0 AND lv_zterm IS NOT INITIAL.
    SELECT SINGLE vtext
      FROM tvzbt
      INTO i_hdr_itm-hdr_gen-terms
      WHERE spras = c_e
        AND zterm = lv_zterm.
  ENDIF.

*---due date calc on Payment term
  CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT'
    EXPORTING
      bldat                        = st_vbak-erdat
      terms_of_payment             = lv_zterm
    TABLES
      top_text                     = li_top
    EXCEPTIONS
      terms_of_payment_not_in_t052 = 1
      OTHERS                       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE li_top INTO DATA(lst_top) INDEX 1.
    i_hdr_itm-hdr_gen-due_date =  lst_top-hdatum.
  ENDIF.

*-Tax ID Number
  SELECT SINGLE paval
    FROM t001z
    INTO i_hdr_itm-hdr_gen-tax_id
    WHERE bukrs = st_vbak-bukrs_vf.
*      AND party = c_wt_tax . "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
  IF sy-subrc NE 0 AND i_hdr_itm-hdr_gen-tax_id IS INITIAL.
    READ TABLE i_const INTO DATA(lst_const) WITH KEY devid = fp_devid
                                                     param1 = lc_tax_id
                                                     param2 = st_vbak-bukrs_vf.
    IF sy-subrc EQ 0.
      i_hdr_itm-hdr_gen-tax_id = lst_const-low.
    ENDIF.
  ENDIF.
*---Customer service
  i_hdr_itm-hdr_gen-cust_srvc_usrid = st_vbak-ernam.

*---Remit details
  CLEAR lst_const.
  READ TABLE i_const INTO lst_const WITH KEY    devid = fp_devid
                                                param1 = c_remit
                                                param2 = st_vbak-bukrs_vf
                                                high   = st_vbak-waerk.

  IF sy-subrc = 0.
    i_hdr_itm-hdr_gen-remit_payment_to = lst_const-low.
  ENDIF.

*---Bank details
  CLEAR lst_const.
  READ TABLE i_const INTO lst_const WITH KEY    devid = fp_devid
                                                param1 = c_bank
                                                param2 = st_vbak-bukrs_vf
                                                high   = st_vbak-waerk.

  IF sy-subrc = 0.
    i_hdr_itm-hdr_gen-bank = lst_const-low.
  ENDIF.

*---Portal details
  CLEAR lst_const.
  READ TABLE i_const INTO lst_const WITH KEY    devid = fp_devid
                                                param1 = c_portal
                                                param2 = st_vbak-bukrs_vf
                                                high   = st_vbak-waerk.

  IF sy-subrc = 0.
    i_hdr_itm-hdr_gen-payment_portal = lst_const-low.
  ENDIF.

*---Ref document details
  IF sy-sysid <> c_prod.
    CONCATENATE 'TEST PRINT' sy-sysid sy-mandt
           INTO i_hdr_itm-hdr_gen-test_ref_doc SEPARATED BY c_under.
  ENDIF.

*---Get Form based on the output type
  READ TABLE i_const INTO lst_const WITH KEY  devid = fp_devid
*                                              devid = c_devid_f065
                                              param1 = nast-kschl.
  IF sy-subrc = 0.
    v_formname = lst_const-low.
  ENDIF.
*---Header Text display in the note
  i_hdr_itm-hdr_gen-quotation_text_object = c_vbbk.
  i_hdr_itm-hdr_gen-quotation_text_name   = st_vbak-vbeln.
  i_hdr_itm-hdr_gen-quotation_text_id     = c_0007.
  i_hdr_itm-hdr_gen-quotation_lang        = c_e.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LINE_ITEM_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_line_item_details.

  DATA: lst_items  TYPE zstqtc_wls_quotati_itm_f065,
        li_items   TYPE STANDARD TABLE OF zstqtc_wls_quotati_itm_f065,
        li_tax     TYPE zttqtc_tax_item_f065,
        li_tax_tmp TYPE zttqtc_tax_item_f065,
        lst_tax    TYPE zstqtc_tax_item_f065,
        lst_tax1   TYPE zstqtc_tax_item_f065,
        lv_taxamt  TYPE kzwi6,
        lv_taxper  TYPE kzwi6,
        lv_amt     TYPE kzwi6,
        lv_total   TYPE kzwi6,
        lv_umrez   TYPE char8,
        lv_qty     TYPE char18,
        lv_dec     TYPE char10,
        lv_zmeng   TYPE char18.


  FREE:lst_items,lv_taxper,li_items,li_tax,li_tax_tmp,lst_tax,lv_taxamt,lst_tax1,lv_amt,lv_total.

  SELECT posnr,   "lineitem
         matnr,   "Material
         arktx,   "Description
         kwmeng,  "Quantity
         vrkme,
         meins,   "Units
         pstyv,   "Category
         kzwi1,   "Amount
         kzwi5,   "Discount
         kzwi6,   "Tax
         netwr,   "net price
         waerk,    "Currency Units
         uepos     "Higher-level item
    FROM vbap
    INTO TABLE @DATA(li_vbap)
    WHERE vbeln = @st_vbak-vbeln.
  IF li_vbap IS NOT INITIAL.
    SELECT matnr,
           bismt,
           meins
      FROM mara
      INTO TABLE @DATA(li_mara)
      FOR ALL ENTRIES IN @li_vbap
      WHERE matnr = @li_vbap-matnr.
*--fethc the units of measure for material
    SELECT matnr, meinh, umrez
       FROM marm
       INTO TABLE @DATA(li_marm)
       FOR ALL ENTRIES IN @li_mara
       WHERE matnr EQ @li_mara-matnr.
    IF sy-subrc EQ 0.
      SORT li_marm BY matnr.
    ENDIF.
  ENDIF.
  SELECT *
    FROM konv
    INTO TABLE @DATA(li_konv)
    WHERE  knumv = @st_vbak-knumv
      AND ( kschl = @c_zwpr OR kschl = @c_zitr ).

  i_hdr_itm-hdr_gen-sub_tot_curr = st_vbak-waerk.

  FREE :lst_items,lst_tax,li_tax,li_items.
  SORT li_vbap BY posnr.
  LOOP AT li_vbap INTO DATA(lst_vbap).
    READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap-matnr.
    IF sy-subrc = 0.
      lst_items-item = lst_mara-bismt.
*---line item units check
      IF lst_vbap-vrkme  NE lst_mara-meins.
        READ TABLE li_marm INTO DATA(lst_marm) WITH KEY matnr = lst_vbap-matnr
                                                        meinh = lst_vbap-vrkme .
        IF sy-subrc = 0.
          lv_umrez = lst_marm-umrez.
          CONDENSE lv_umrez NO-GAPS.
          CONCATENATE lst_vbap-vrkme  lv_umrez INTO lst_items-meins.
          CONDENSE lst_items-meins NO-GAPS.
        ELSE.
          lst_items-meins       = lst_vbap-vrkme .
        ENDIF.
      ELSE.
        lst_items-meins       = lst_vbap-vrkme .
      ENDIF.
    ENDIF.
    lst_items-description = lst_vbap-arktx.
    FREE:lv_zmeng ,lv_qty, lv_dec.
    lv_zmeng              = lst_vbap-kwmeng.
    SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
    lst_items-kwmeng      = lv_qty.
    CONDENSE lst_items-kwmeng .

    lst_items-currency    = lst_vbap-waerk.
    IF lst_vbap-uepos = c_higherline.    "Higher Line Item
      "##UOM_IN_MES
      WRITE:lst_vbap-kzwi1 TO lst_items-amount , ##UOM_IN_MES
            lst_vbap-kzwi5 TO lst_items-discounts, ##UOM_IN_MES
            lst_vbap-kzwi6 TO lst_items-tax. ##UOM_IN_MES

      lst_items-discounts = lst_items-discounts * ( - 1 ).

*      lst_items-amount      = lst_vbap-kzwi1.
*      lst_items-discounts   = lst_vbap-kzwi5 * ( - 1 ).
*      lst_items-tax         = lst_vbap-kzwi6.

      IF lst_vbap-pstyv =  c_zfrt.
        READ TABLE li_konv INTO DATA(lst_konv) WITH KEY kposn = lst_vbap-posnr
                                                        kschl = c_zwpr.
        IF sy-subrc = 0.
          i_hdr_itm-hdr_gen-freight =  i_hdr_itm-hdr_gen-freight + lst_konv-kbetr.
        ENDIF.
      ENDIF.
      lv_total = lst_vbap-kzwi1 +  lst_vbap-kzwi5 + lst_vbap-kzwi6.
      ##UOM_IN_MES
      WRITE lv_total TO lst_items-total. "##UOM_IN_MES
    ENDIF.
    APPEND lst_items TO li_items.

    i_hdr_itm-hdr_gen-sub_total       = i_hdr_itm-hdr_gen-sub_total   + lv_total." lst_items-amount.
    i_hdr_itm-hdr_gen-tax             = i_hdr_itm-hdr_gen-tax         + lst_vbap-kzwi6." lst_items-tax.
    i_hdr_itm-hdr_gen-amount_paid     = c_0.
    i_hdr_itm-hdr_gen-total_due       = i_hdr_itm-hdr_gen-total_due   + lv_total - i_hdr_itm-hdr_gen-freight.
*     lst_items-total


    lst_tax-media_type     = c_tax.
    lst_tax-taxabl_amt     = lst_vbap-kzwi1. "lst_items-amount.
    CLEAR: lst_konv,lst_tax-tax_percentage.
    LOOP AT li_konv INTO lst_konv WHERE kposn = lst_vbap-posnr
                                    AND kschl = c_zitr.
      lst_tax-tax_percentage = ( lst_konv-kbetr / 10 ) + lst_tax-tax_percentage .
    ENDLOOP.

    lst_tax-tax_amount     = lst_vbap-kzwi6.
    CONDENSE:lst_tax-taxabl_amt,lst_tax-tax_percentage,lst_tax-tax_amount.
    APPEND lst_tax TO li_tax.
    CLEAR:lst_tax, lst_items.
  ENDLOOP.
  IF li_tax IS NOT INITIAL.
    DATA(li_tax_t) = li_tax.
    SORT li_tax_t BY tax_percentage.
    SORT li_tax BY tax_percentage.
    DELETE ADJACENT DUPLICATES FROM li_tax COMPARING tax_percentage.
    LOOP AT li_tax INTO DATA(lst_tax_t).
      READ TABLE li_tax_t INTO lst_tax WITH KEY tax_percentage = lst_tax_t-tax_percentage BINARY SEARCH.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT li_tax_t INTO lst_tax FROM lv_tabix.
          IF lst_tax-tax_percentage <> lst_tax_t-tax_percentage.
            EXIT.
          ELSE.
            lv_taxamt               = lv_taxamt + lst_tax-taxabl_amt.
            lst_tax1-taxabl_amt     = lv_taxamt.
            lv_taxper               = lst_tax-tax_percentage.
            lst_tax1-tax_percentage = lv_taxper.
            lv_amt                  = lv_amt  + lst_tax-tax_amount.
            lst_tax1-tax_amount     = lv_amt .
          ENDIF.
        ENDLOOP.
        CONCATENATE lst_tax1-tax_percentage c_pert INTO lst_tax1-tax_percentage.
        CONCATENATE lst_tax1-taxabl_amt  c_at INTO lst_tax1-taxabl_amt .
        CONCATENATE c_eq lst_tax1-tax_amount INTO lst_tax1-tax_amount.
        CONDENSE: lst_tax1-tax_amount,lst_tax1-tax_percentage,lst_tax1-taxabl_amt.
        APPEND lst_tax1 TO li_tax_tmp.
        CLEAR:lst_tax1,lst_tax,lst_tax_t,lv_taxamt,lv_amt,lv_taxper.
      ENDIF.
    ENDLOOP.
  ENDIF.
  FREE:li_tax_t,li_tax.
*---Line items and tax items
  i_hdr_itm-itm_gen     = li_items.
  i_hdr_itm-itm_exc_tab = li_tax_tmp.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FORM_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_form_layout .

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
*- To avoid Extended program check message
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF. " IF sy-subrc NE 0
    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = v_formname
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

      IF nast-kschl = c_zwqt.  "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
* Call function module to generate Details
        CALL FUNCTION lv_funcname
          EXPORTING
            /1bcdwb/docparams  = lst_sfpdocparams
            im_hdr_itm         = i_hdr_itm
            im_logo            = v_logo
            im_bmp             = v_bmp
          IMPORTING
            /1bcdwb/formoutput = st_formoutput
          EXCEPTIONS
            usage_error        = 1
            system_error       = 2
            internal_error     = 3
            OTHERS             = 4.
*---begin of change vdpataball 11/23/2020 f067 ed2k920414 otcm-32214
      ELSEIF nast-kschl = c_zqda.

        CALL FUNCTION lv_funcname
          EXPORTING
            /1bcdwb/docparams  = lst_sfpdocparams
            im_hdr_itm         = i_hdr_itm_f067
            im_logo            = v_logo
            im_bmp             = v_bmp
          IMPORTING
            /1bcdwb/formoutput = st_formoutput
          EXCEPTIONS
            usage_error        = 1
            system_error       = 2
            internal_error     = 3
            OTHERS             = 4.
      ENDIF.
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
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
*- To avoid Extended program check message
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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
*- To avoid Extended program check message
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail  CHANGING  p_fp_v_returncode TYPE sysubrc.

  DATA: st_outputparams  TYPE sfpdocparams ##NEEDED,      " Form Processing Output Parameter
        lv_fm_name       TYPE funcname,                   " Name of Function Module
        lv_upd_tsk       TYPE i,                          " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,            " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams.               " Form Parameters for Form Processing
  DATA: li_person_mail_id TYPE TABLE OF p0105,            " HR Master Record: Infotype 0001 (Org. Assignment)
        lst_send_email    TYPE ty_send_email.         "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
  CONSTANTS:lc_105   TYPE prelp-infty  VALUE '0105',                         " Infotype
            lc_end   TYPE prelp-endda  VALUE '99991231',                     " End Date
            lc_start TYPE prelp-begda  VALUE '18000101',                     " Start Date
            lc_0010  TYPE pa0105-usrty VALUE '0010',                        " Communication Type
            lc_er    TYPE parvw        VALUE 'ZM'.                            " Employee responsible

  FREE:i_send_email.
*---Begin of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
  CONSTANTS:lc_header TYPE posnr VALUE '000000'.
  DATA: lv_person_numb TYPE prelp-pernr,                " Person Number
        lv_text        TYPE char255.                    " For text message

  CASE st_vbak-spart.
    WHEN c_40 .
      SELECT SINGLE vbeln
                    parvw
                    kunnr
                    pernr
                    adrnr
             FROM vbpa
             INTO st_vbpa
             WHERE vbeln = st_vbak-vbeln
               AND posnr = lc_header
               AND parvw = lc_er. "ER - Employee responsible
      IF sy-subrc EQ 0.
        lv_person_numb = st_vbpa-pernr.
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
            pernr           = lv_person_numb
            infty           = lc_105
            begda           = lc_start
            endda           = lc_end
          TABLES
            infty_tab       = li_person_mail_id
          EXCEPTIONS
            infty_not_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0.
* Implement suitable error handling here
          READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id) WITH KEY pernr =  lv_person_numb
                                                                              usrty = lc_0010.
          IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
            lst_send_email-send_email = lst_person_mail_id-usrid_long.
            APPEND lst_send_email TO i_send_email.
            CLEAR lst_send_email.
          ELSE.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = 'Email ID is not maintained for ER Partner'(013).
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = 'Email ID is not maintained for ER Partner'(013).
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ELSE.
        SELECT SINGLE vbeln parvw kunnr pernr adrnr
          FROM vbpa INTO st_vbpa
          WHERE vbeln = st_vbak-vbeln
            AND posnr = lc_header
            AND parvw = c_re.
        IF sy-subrc EQ 0.
          SELECT  smtp_addr UP TO 1 ROWS "E-Mail Address
           FROM adr6      "E-Mail Addresses (Business Address Services)
           INTO TABLE i_send_email
           WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
          IF sy-subrc NE 0 AND i_send_email IS INITIAL .
            SELECT SINGLE prsnr "E-Mail Address
              FROM knvk      "E-Mail Addresses (Business Address Services)
              INTO v_persn_adrnr
              WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
              AND   pafkt = c_z1 ##WARN_OK.
            IF sy-subrc EQ 0.
              SELECT smtp_addr "E-Mail Address
                FROM adr6      "E-Mail Addresses (Business Address Services)
                INTO TABLE i_send_email
                WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
              IF v_send_email IS INITIAL.
                syst-msgid = c_zqtc_r2.
                syst-msgno = c_msg_no.
                syst-msgty = c_e.
                syst-msgv1 = 'Email ID is not maintained for Bill to Customer'(004).
                CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
                PERFORM f_protocol_update.
                v_ent_retco = 4.
              ENDIF.
            ELSE.
              syst-msgid = c_zqtc_r2.
              syst-msgno = c_msg_no.
              syst-msgty = c_e.
              syst-msgv1 = 'Email ID is not maintained for Bill to Customer'(004).
              CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
              PERFORM f_protocol_update.
              v_ent_retco = 4.
            ENDIF.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = 'BP partner function is not maintained'(005).
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF.
    WHEN OTHERS.
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
*- fetch the number of contact person for the business partner
      SELECT SINGLE kunnr, vkorg, vtweg, spart, parvw, parza , parnr
        FROM knvp
        INTO @DATA(lst_knvp)
        WHERE kunnr EQ @st_vbak-kunnr
          AND vkorg EQ @st_vbak-vkorg
          AND vtweg EQ @st_vbak-vtweg
          AND spart EQ @st_vbak-spart
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
            INTO TABLE i_send_email
            WHERE persnumber EQ lst_knvk-prsnr.
          IF sy-subrc NE 0.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = 'Email ID is not maintained for contact person'(012).             " Email ID is not maintained for contact person
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = 'Person number is not maintained'(011).               " Person number is not maintained
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ELSE.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = 'CP partner function is not maintained'(010).                 " CP partner function is not maintained
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
  ENDCASE. "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214

  IF i_send_email IS NOT INITIAL.
    lst_outputparams-getpdf = abap_true.
    lst_outputparams-preview = abap_false.
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
              i_name     = v_formname
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
      IF nast-kschl = c_zwqt.  "++VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
*- Call the generated function module
        CALL FUNCTION lv_fm_name
          EXPORTING
            /1bcdwb/docparams  = lst_sfpdocparams
            im_hdr_itm         = i_hdr_itm
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
*---Begin of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
      ELSEIF nast-kschl = c_zqda.

        CALL FUNCTION lv_fm_name
          EXPORTING
            /1bcdwb/docparams  = lst_sfpdocparams
            im_hdr_itm         = i_hdr_itm_f067
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
*---End of change VDPATABALL 11/23/2020 F067 ED2K920414 OTCM-32214
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
  IF v_ent_retco = 0.
******CONVERT_PDF_BINARY
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = st_formoutput-pdf
      TABLES
        binary_tab = i_content_hex.
********Perform is used to create mail attachment with a creation of mail body
*- Using li_send_email internal table instead of v_send_email

    IF i_send_email IS NOT INITIAL.
      PERFORM f_mail_attachment   CHANGING v_ent_retco.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_ENT_RETCO  text
*----------------------------------------------------------------------*
FORM f_mail_attachment  CHANGING  p_fp_v_returncode TYPE sysubrc.

*- Declaration
  DATA: lr_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL, "Interface of Sender Object in BCS
        li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
        lst_lines TYPE tline.                   " SAPscript: Text Lines

*- Local Constant Declaration
  CONSTANTS:
    lc_raw                 TYPE so_obj_tp      VALUE 'RAW',                   "Code for document class
    lc_parvw_zm            TYPE char02         VALUE 'ZM',
    lc_pdf                 TYPE so_obj_tp      VALUE 'PDF',                   "Document Class for Attachment
    lc_s                   TYPE bapi_mtype     VALUE 'S',                     "Message type: S Success, E Error, W Warning, I Info, A Abort
    lc_st                  TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
    lc_object              TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
    lc_wls_email_body_f065 TYPE thead-tdname   VALUE 'ZQTC_WLS_EMAIL_BODY_QUOTAT_F065'.


  CLASS cl_bcs DEFINITION LOAD.                                       " Business Communication Service
  DATA: lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL, " BCS: Document Exceptions
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


* For SG Invoice the URL link https://paymentsqa.wiley.com to be provided to the payment portal.

  SELECT SINGLE type
      FROM but000
      INTO @lv_type
      WHERE partner EQ @st_vbak-kunnr.
  IF sy-subrc EQ 0.

    CASE lv_type.

      WHEN '1'.  " Person
        v_er_name = i_hdr_itm-hdr_gen-bill_to_name.
      WHEN '2'.  "Organization

*-Fetch the Contact person name from Bill-to
        SELECT SINGLE namev,
                      name1
        INTO @DATA(lst_knvk)
        FROM knvk
        WHERE kunnr EQ @st_vbpa-kunnr
          AND pafkt EQ @c_z1.

        IF sy-subrc EQ 0.

          CONCATENATE lst_knvk-namev
                      lst_knvk-name1
                INTO v_er_name SEPARATED BY space.

          IF v_er_name IS INITIAL.
            v_er_name = i_hdr_itm-hdr_gen-bill_to_name.
          ENDIF.

        ELSE.

          v_er_name = i_hdr_itm-hdr_gen-bill_to_name.

        ENDIF.
    ENDCASE.
  ENDIF.


  lv_doc_cat = 'Quotation Number:'(006).


  lv_name = lc_wls_email_body_f065.
  CONCATENATE 'Wiley'(007)
              lv_doc_cat
              i_hdr_itm-hdr_gen-quotation_numb
         INTO lv_sub SEPARATED BY space.

  lv_subject = lv_sub.

*----fm is used to sapscript: read text
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
      REPLACE ALL OCCURRENCES OF '&VBELN&' IN lst_message_body-line WITH i_hdr_itm-hdr_gen-quotation_numb.
      REPLACE ALL OCCURRENCES OF '&G_ES&'      IN lst_message_body-line WITH v_er_name.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP.

  ENDIF. " IF sy-subrc EQ 0

  CLEAR lst_message_body.
  lst_message_body-line = space.
  APPEND lst_message_body-line TO li_message_body.
  CLEAR lst_message_body.
  lst_message_body-line = '**Please do not reply to this email, as we are unable to respond from this address.'(008).
  APPEND lst_message_body-line TO li_message_body.


  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw
      i_text = li_message_body
      i_subject = lv_subject ).
    CATCH cx_document_bcs ##NO_HANDLER.
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.
*        Send email with the attachments we are getting from FM
  TRY.
      lr_document->add_attachment(
      EXPORTING
      i_attachment_type = lc_pdf
      i_attachment_subject = lv_subject
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
  IF i_send_email IS NOT INITIAL.
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
    LOOP AT i_send_email INTO DATA(lst_send_email).
      TRY.
          lr_recipient = cl_cam_address_bcs=>create_internet_address( lst_send_email-send_email ).
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        CATCH cx_address_bcs ##NO_HANDLER.
        CATCH cx_send_req_bcs. ##NO_HANDLER
      ENDTRY.
    ENDLOOP.
* Send email
    TRY.
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true
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
      MESSAGE 'Email sent successfully'(009) TYPE lc_s . "Email sent successfully
    ENDIF. " IF lv_upd_tsk EQ 0

    IF lv_sent_to_all = abap_true.
      MESSAGE 'Email sent successfully'(009) TYPE lc_s .
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF li_send_email IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LINE_ITEM_DETAILS_ZQDA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_line_item_details_zqda .
  DATA: lst_items  TYPE zstqtc_lh_opm_itm_f046,
        li_items   TYPE STANDARD TABLE OF zstqtc_lh_opm_itm_f046,
        li_tax     TYPE zttqtc_tax_item_f042,
        li_tax_tmp TYPE zttqtc_tax_item_f042,
        lst_tax    TYPE zstqtc_tax_item_f042,
        lst_tax1   TYPE zstqtc_tax_item_f042,
        lv_taxamt  TYPE kzwi6,
        lv_taxper  TYPE kzwi6,
        lv_amt     TYPE kzwi6,
        lv_total   TYPE kzwi6,
        lv_umrez   TYPE char8,
        lv_qty     TYPE char20,
        lv_dec     TYPE char10,
        lv_zmeng   TYPE char18.


  FREE:lst_items,lv_taxper,li_items,li_tax,li_tax_tmp,lst_tax,lv_taxamt,lst_tax1,lv_amt,lv_total.

  SELECT posnr,   "lineitem
         matnr,   "Material
         arktx,   "Description
         kwmeng,  "Quantity
         vrkme,
         meins,   "Units
         pstyv,   "Category
         kzwi1,   "Amount
         kzwi5,   "Discount
         kzwi6,   "Tax
         netwr,   "net price
         waerk,    "Currency Units
         uepos     "Higher-level item
    FROM vbap
    INTO TABLE @DATA(li_vbap)
    WHERE vbeln = @st_vbak-vbeln.
  IF li_vbap IS NOT INITIAL.
    SELECT matnr,
               bismt,
               meins
          FROM mara
          INTO TABLE @DATA(li_mara)
          FOR ALL ENTRIES IN @li_vbap
          WHERE matnr = @li_vbap-matnr.
    IF li_mara IS NOT INITIAL.
      SORT li_mara BY matnr.
    ENDIF.

    SELECT matnr,
           maktx
      FROM makt
      INTO TABLE @DATA(li_makt)
      FOR ALL ENTRIES IN @li_vbap
      WHERE matnr = @li_vbap-matnr
        AND spras = @sy-langu.
    IF li_makt IS NOT INITIAL.
      SORT li_makt BY matnr.
    ENDIF.
  ENDIF.
  SELECT *
    FROM konv
    INTO TABLE @DATA(li_konv)
    WHERE  knumv = @st_vbak-knumv
      AND ( kschl = @c_zwpr OR kschl = @c_zitr ).

  i_hdr_itm_f067-hdr_gen-sub_tot_curr = st_vbak-waerk.

  FREE :lst_items,lst_tax,li_tax,li_items.
  SORT li_vbap BY posnr.
  LOOP AT li_vbap INTO DATA(lst_vbap).
    READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap-matnr
                                                    BINARY SEARCH.
    IF sy-subrc = 0.
      lst_items-item = lst_mara-bismt .       "Material number
    ENDIF.
    READ TABLE li_makt INTO DATA(lst_makt) WITH KEY matnr = lst_vbap-matnr
                                                    BINARY SEARCH.
    IF sy-subrc = 0.
      lst_items-description = lst_makt-maktx. "material Description
    ENDIF.

    lst_items-currency    = lst_vbap-waerk.
    IF lst_vbap-uepos = c_higherline.    "Higher Line Item
      lst_items-amount    =  lst_vbap-kzwi1.
      lst_items-discounts =  lst_vbap-kzwi5.
      lst_items-tax       =  lst_vbap-kzwi6.
      FREE:lv_zmeng ,lv_qty, lv_dec.
      lv_zmeng              = lst_vbap-kwmeng.
      SPLIT  lv_zmeng  AT '.' INTO lv_qty lv_dec.
      CONDENSE lv_qty.
      lst_items-students  = lv_qty.
      lst_items-discounts = lst_items-discounts * ( - 1 ).

      lst_items-total       = lst_items-amount +
                              lst_items-tax -
                              lst_items-discounts.
    ENDIF.
    APPEND lst_items TO li_items.

    i_hdr_itm_f067-hdr_gen-sub_total       = i_hdr_itm_f067-hdr_gen-sub_total   + lst_items-amount.
    i_hdr_itm_f067-hdr_gen-tax             = i_hdr_itm_f067-hdr_gen-tax         + lst_items-tax.
    i_hdr_itm_f067-hdr_gen-amount_paid     = c_0.
    i_hdr_itm_f067-hdr_gen-total_due       = i_hdr_itm_f067-hdr_gen-total_due
                                           + lst_items-amount
                                           + lst_items-tax.

    lst_tax-media_type     = c_tax.
    lst_tax-taxabl_amt     = lst_vbap-kzwi1. "lst_items-amount.
    CLEAR: lst_tax-tax_percentage.
    LOOP AT li_konv INTO DATA(lst_konv) WHERE kposn = lst_vbap-posnr
                                          AND kschl = c_zitr.
      lst_tax-tax_percentage = ( lst_konv-kbetr / 10 ) + lst_tax-tax_percentage .
    ENDLOOP.

    lst_tax-tax_amount     = lst_vbap-kzwi6.
    CONDENSE:lst_tax-taxabl_amt,lst_tax-tax_percentage,lst_tax-tax_amount.
    APPEND lst_tax TO li_tax.
    CLEAR:lst_tax,lst_items.
  ENDLOOP.
  IF li_tax IS NOT INITIAL.
    DATA(li_tax_t) = li_tax.
    SORT li_tax_t BY tax_percentage.
    SORT li_tax BY tax_percentage.
    DELETE ADJACENT DUPLICATES FROM li_tax COMPARING tax_percentage.
    LOOP AT li_tax INTO DATA(lst_tax_t).
      READ TABLE li_tax_t INTO lst_tax WITH KEY tax_percentage = lst_tax_t-tax_percentage BINARY SEARCH.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT li_tax_t INTO lst_tax FROM lv_tabix.
          IF lst_tax-tax_percentage <> lst_tax_t-tax_percentage.
            EXIT.
          ELSE.
            lv_taxamt               = lv_taxamt + lst_tax-taxabl_amt.
            lst_tax1-taxabl_amt     = lv_taxamt.
            lv_taxper               = lst_tax-tax_percentage.
            lst_tax1-tax_percentage = lv_taxper.
            lv_amt                  = lv_amt  + lst_tax-tax_amount.
            lst_tax1-tax_amount     = lv_amt .
          ENDIF.
        ENDLOOP.
        CONCATENATE lst_tax1-tax_percentage c_pert INTO lst_tax1-tax_percentage.
        CONCATENATE lst_tax1-taxabl_amt  c_at INTO lst_tax1-taxabl_amt .
        CONCATENATE c_eq lst_tax1-tax_amount INTO lst_tax1-tax_amount.
        CONDENSE: lst_tax1-tax_amount,lst_tax1-tax_percentage,lst_tax1-taxabl_amt.
        APPEND lst_tax1 TO li_tax_tmp.
        CLEAR:lst_tax1,lst_tax,lst_tax_t,lv_taxamt,lv_amt,lv_taxper.
      ENDIF.
    ENDLOOP.
  ENDIF.
  FREE:li_tax_t,li_tax.
*---Line items and tax items
  i_hdr_itm_f067-itm_gen     = li_items.
  i_hdr_itm_f067-itm_exc_tab = li_tax_tmp.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_HEADER_FILL_F047_ZQDA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_header_fill_f047_zqda .
  APPEND LINES OF i_hdr_itm-it_bill_to_addr TO i_hdr_itm_f067-it_bill_to_addr.
  APPEND LINES OF i_hdr_itm-it_ship_to_addr TO i_hdr_itm_f067-it_ship_to_addr.

  i_hdr_itm_f067-hdr_gen-sales_org_adrnr   = i_hdr_itm-hdr_gen-sales_org_adrnr.
  i_hdr_itm_f067-hdr_gen-sales_org_house1  = i_hdr_itm-hdr_gen-sales_org_house1.
  i_hdr_itm_f067-hdr_gen-sales_org_street  = i_hdr_itm-hdr_gen-sales_org_street.
  i_hdr_itm_f067-hdr_gen-sales_org_city1   = i_hdr_itm-hdr_gen-sales_org_city1.
  i_hdr_itm_f067-hdr_gen-sales_org_reg     = i_hdr_itm-hdr_gen-sales_org_reg.
  i_hdr_itm_f067-hdr_gen-sales_org_post1   = i_hdr_itm-hdr_gen-sales_org_post1.

  i_hdr_itm_f067-hdr_gen-invoice_numb      =  i_hdr_itm-hdr_gen-quotation_numb.
  i_hdr_itm_f067-hdr_gen-invoice_text      =  i_hdr_itm-hdr_gen-quotation_text.
  i_hdr_itm_f067-hdr_gen-client_numb       =  i_hdr_itm-hdr_gen-client_numb.
  i_hdr_itm_f067-hdr_gen-tax_expt_text     =  i_hdr_itm-hdr_gen-tax_expt_text.
  i_hdr_itm_f067-hdr_gen-invoice_date      =  i_hdr_itm-hdr_gen-quotation_date.
  i_hdr_itm_f067-hdr_gen-terms             =  i_hdr_itm-hdr_gen-terms.
  i_hdr_itm_f067-hdr_gen-due_date          =  i_hdr_itm-hdr_gen-due_date.
  i_hdr_itm_f067-hdr_gen-tax_id            =  i_hdr_itm-hdr_gen-tax_id.
  i_hdr_itm_f067-hdr_gen-remit_payment_to  =  i_hdr_itm-hdr_gen-remit_payment_to.
  i_hdr_itm_f067-hdr_gen-bank              =  i_hdr_itm-hdr_gen-bank.
  i_hdr_itm_f067-hdr_gen-payment_portal    =  i_hdr_itm-hdr_gen-payment_portal.
  i_hdr_itm_f067-hdr_gen-test_ref_doc      =  i_hdr_itm-hdr_gen-test_ref_doc.
  i_hdr_itm_f067-hdr_gen-invoice_text_name =  i_hdr_itm-hdr_gen-quotation_text_name.
  i_hdr_itm_f067-hdr_gen-invoice_text_id   =  i_hdr_itm-hdr_gen-quotation_text_id.
  i_hdr_itm_f067-hdr_gen-invoice_lang      =  i_hdr_itm-hdr_gen-quotation_lang .
  READ TABLE i_const INTO DATA(lst_const) WITH KEY devid = c_devid_f067
                                                   param1 = c_tax_des
                                                   param2 = st_vbak-bukrs_vf.
  IF sy-subrc = 0.
    i_hdr_itm_f067-hdr_gen-tax_des = lst_const-low.
  ENDIF.
  READ TABLE i_const INTO lst_const WITH KEY devid  = c_devid_f067
                                             param1 = c_cust_id.
  IF sy-subrc = 0.
    i_hdr_itm_f067-hdr_gen-cust_service = lst_const-low.
  ENDIF.


ENDFORM.
