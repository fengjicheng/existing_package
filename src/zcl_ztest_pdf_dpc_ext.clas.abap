class ZCL_ZTEST_PDF_DPC_EXT definition
  public
  inheriting from ZCL_ZTEST_PDF_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~READ_ENTITYSET
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZTEST_PDF_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_core_srv_runtime~read_entityset.
*    TABLES: tnapr,    " Processing programs for output
*            nast,     " Message Status
*            toa_dara. " SAP ArchiveLink structure of a DARA line

*- Fimal table
    TYPES: BEGIN OF ty_vbpa,
             vbeln TYPE vbpa-vbeln,
             parvw TYPE vbpa-parvw,
             kunnr TYPE vbpa-kunnr,
             pernr TYPE vbpa-pernr,
             adrnr TYPE vbpa-adrnr,
           END OF ty_vbpa,

           BEGIN OF ty_const,
             devid    TYPE zdevid,
             param1   TYPE rvari_vnam,
             param2   TYPE rvari_vnam,
             srno     TYPE tvarv_numb,
             sign     TYPE tvarv_sign,
             opti     TYPE tvarv_opti,
             low      TYPE salv_de_selopt_low,
             high     TYPE salv_de_selopt_high,
             activate TYPE zconstactive,
           END OF ty_const,
           BEGIN OF ty_send_email,
             send_email TYPE ad_smtpadr, " E-Mail Address
           END OF ty_send_email,
           tt_send_email TYPE STANDARD TABLE OF ty_send_email.

    DATA:i_const              TYPE STANDARD TABLE OF ty_const,
         i_hdr_itm            TYPE zstqtc_wls_quotat_renwal_f065 ##NEEDED, " Structure for F065 Header and Item Data
         i_print_data_to_read TYPE lbbil_print_data_to_read ##NEEDED,       " Select. of Tables to be Compl. for Printing RD00;SmartForms
         st_formoutput        TYPE fpformoutput ##NEEDED,                   " Form Output (PDF, PDL)
         i_content_hex        TYPE solix_tab ##NEEDED,                      " Content table
         v_formname           TYPE fpname ##NEEDED,                         " Formname.
         v_ent_retco          TYPE sy-subrc ##NEEDED,                       " ABAP System Field: Return Code of ABAP Statements
         v_ent_screen         TYPE c ##NEEDED,                              " Screen of type Character
         v_send_email         TYPE ad_smtpadr ##NEEDED,                     " E-Mail Address
         v_retcode            TYPE sy-subrc,                                " Return code
         v_er_name            TYPE char50 ##NEEDED,                         " E-Mail Address
         v_persn_adrnr        TYPE knvk-prsnr ##NEEDED,                     " E-Mail Address
         v_logo               TYPE salv_de_selopt_low VALUE 'ZJWILEY_LOGO', " Logo
         v_bmp                TYPE xstring ##NEEDED,                        " Bitmap
         st_vbak              TYPE vbak,
         st_vbpa              TYPE ty_vbpa,
         i_send_email         TYPE TABLE OF ty_send_email.

    CONSTANTS: c_0          TYPE char4      VALUE '0.00',                          " Sales Office
               c_re         TYPE parvw      VALUE 'RE',                            " Partner Function
               c_1          TYPE na_nacha   VALUE '1',                             " Print Function
               c_5          TYPE na_nacha   VALUE '5',                             " Email Function
               c_zero       TYPE char1      VALUE '0',                             " Email Function
               c_pdf        TYPE toadv-doc_type VALUE 'PDF',                       " for PDF
               c_tax        TYPE char3      VALUE 'Tax',                           " Tax text
               c_vbbk       TYPE tdobject   VALUE 'VBBK',                          " Text object
               c_0007       TYPE tdid       VALUE '0007',                          " Text id
               c_eq         TYPE char1      VALUE '=',                             " Equal
               c_at         TYPE char1      VALUE '@',                             " At the rate
               c_pert       TYPE char1      VALUE '%',                             " At the rate
               c_we         TYPE parvw      VALUE 'WE',                            " Partner Function
               c_er         TYPE char02     VALUE 'ZM',                            " Employee responsible
               c_z1         TYPE knvk-pafkt VALUE 'Z1',                            " Contact person function
               c_e          TYPE char1      VALUE 'E',                             " Error Message
               c_zqtc_r2    TYPE syst-msgid VALUE 'ZQTC_R2',                       " Message ID
               c_msg_no     TYPE syst-msgno VALUE '000',                           " Message Number
               c_x          TYPE char1      VALUE 'X',                             " for x
               c_w          TYPE char1      VALUE 'W',                             " for Web
               c_under      TYPE char1      VALUE '-',                             " Underscore
               c_prod       TYPE char4      VALUE 'EP1',                           " For Production system
               c_cp         TYPE parvw      VALUE 'AP',                            " Partner Function Contact Person
               c_wt_tax     TYPE party      VALUE 'WT_TAX',                        " Wat tax id
               c_zwpr       TYPE kscha      VALUE 'ZWPR',                          " Pricing Condition
               c_zfrt       TYPE pstyv      VALUE 'ZFRT',                          "Sales document item category
               c_zpan       TYPE pstyv      VALUE 'ZPAN',                          "Sales document item category
               c_higherline TYPE uepos      VALUE '000000',                          "Sales document item category
               c_devid_f065 TYPE zdevid     VALUE 'F065',
               c_bank       TYPE zcaconstant-param1 VALUE 'BANK',
               c_portal     TYPE zcaconstant-param1 VALUE 'PORTAL',
               c_remit      TYPE zcaconstant-param1 VALUE 'REMIT'.



*---get the quotation details
    SELECT SINGLE *
    FROM vbak
    INTO @DATA(lst_vbak).
*where vbeln = nast-objky.
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
      WHERE devid EQ @c_devid_f065
        AND activate EQ @abap_true.


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
        p_bmp          = v_bmp " Image Data
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc NE 0.
      CLEAR v_bmp.
    ENDIF. " IF sy-subrc NE 0.


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
          i_hdr_itm-hdr_gen-sales_org_adrnr  = ls_adrc-addrnumber.
          i_hdr_itm-hdr_gen-sales_org_house1 = ls_adrc-house_num1.
          i_hdr_itm-hdr_gen-sales_org_street = ls_adrc-street.
          i_hdr_itm-hdr_gen-sales_org_city1  = ls_adrc-city1.
          i_hdr_itm-hdr_gen-sales_org_reg    = ls_adrc-region.
          i_hdr_itm-hdr_gen-sales_org_post1  = ls_adrc-post_code1.
          i_hdr_itm-hdr_gen-sales_org_ctry   = ls_adrc-country.
        ENDIF.
      ENDIF.
    ENDIF.


    DATA: lv_address_number TYPE adrc-addrnumber,
          li_bill_to_addr   TYPE TABLE OF szadr_printform_table_line,
          lv_lines          TYPE tdline.

    FREE:li_bill_to_addr,lv_address_number,lv_lines.

    SELECT SINGLE vbeln, parvw, adrnr
             FROM vbpa
             INTO @DATA(ls_vbpa)
             WHERE vbeln EQ @lst_vbak-vbeln
               AND parvw EQ 'RE'.
    IF sy-subrc EQ 0.
      SELECT SINGLE addrnumber name1 city1 post_code1
               street house_num1 region country
          FROM adrc
          INTO ls_adrc
          WHERE addrnumber = ls_vbpa-adrnr.
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
*            IF fp_lv_bp = c_re.
*              LOOP AT li_bill_to_addr INTO DATA(lst_bill_to_addr).
*                lv_lines = lst_bill_to_addr-address_line.
*                APPEND lv_lines TO  i_hdr_itm-it_bill_to_addr.
*              ENDLOOP.
*              i_hdr_itm-hdr_gen-bill_to_name = ls_adrc-name1.
*            ELSEIF fp_lv_bp = c_we.
*              CLEAR lst_bill_to_addr.
*              LOOP AT li_bill_to_addr INTO lst_bill_to_addr.
*                lv_lines = lst_bill_to_addr-address_line.
*                APPEND lv_lines TO  i_hdr_itm-it_ship_to_addr.
*              ENDLOOP.
*            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    DATA :li_top TYPE STANDARD TABLE OF vtopis.
    CONSTANTS : lc_tax_id TYPE rvari_vnam VALUE 'TAX_ID',
                lc_zwgpid TYPE bu_id_type VALUE 'ZWGPID'.

    FREE:li_top.
*- Quotation Number
    i_hdr_itm-hdr_gen-quotation_numb = st_vbak-vbeln.

*---Quotation Complete Text
    CONCATENATE 'Quotation Number :'(002) i_hdr_itm-hdr_gen-quotation_numb
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
      WHERE bukrs = st_vbak-bukrs_vf
        AND party = c_wt_tax .
    IF sy-subrc NE 0 AND i_hdr_itm-hdr_gen-tax_id IS INITIAL.
      READ TABLE i_const INTO DATA(lst_const) WITH KEY param1 = lc_tax_id
                                                       param2 = st_vbak-bukrs_vf.
      IF sy-subrc EQ 0.
        i_hdr_itm-hdr_gen-tax_id = lst_const-low.
      ENDIF.
    ENDIF.
*---Customer service
    i_hdr_itm-hdr_gen-cust_srvc_usrid = st_vbak-ernam.

*---Remit details
    CLEAR lst_const.
    READ TABLE i_const INTO lst_const WITH KEY   param1 = c_remit
                                                  param2 = st_vbak-bukrs_vf
                                                  high   = st_vbak-waerk.

    IF sy-subrc = 0.
      i_hdr_itm-hdr_gen-remit_payment_to = lst_const-low.
    ENDIF.

*---Bank details
    CLEAR lst_const.
    READ TABLE i_const INTO lst_const WITH KEY   param1 = c_bank
                                                  param2 = st_vbak-bukrs_vf
                                                  high   = st_vbak-waerk.

    IF sy-subrc = 0.
      i_hdr_itm-hdr_gen-bank = lst_const-low.
    ENDIF.

*---Portal details
    CLEAR lst_const.
    READ TABLE i_const INTO lst_const WITH KEY   param1 = c_portal
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
    READ TABLE i_const INTO lst_const WITH KEY  devid = c_devid_f065
                                                param1 = 'ZWQT'.
    IF sy-subrc = 0.
      v_formname = lst_const-low.
    ENDIF.
*---Header Text display in the note
    i_hdr_itm-hdr_gen-quotation_text_object = c_vbbk.
    i_hdr_itm-hdr_gen-quotation_text_name   = st_vbak-vbeln.
    i_hdr_itm-hdr_gen-quotation_text_id     = c_0007.
    i_hdr_itm-hdr_gen-quotation_lang        = c_e.


    DATA: lst_items  TYPE zstqtc_wls_quotati_itm_f065,
          li_items   TYPE STANDARD TABLE OF zstqtc_wls_quotati_itm_f065,
          li_tax     TYPE zttqtc_tax_item_f065,
          li_tax_tmp TYPE zttqtc_tax_item_f065,
          lst_tax    TYPE zstqtc_tax_item_f065,
          lst_tax1   TYPE zstqtc_tax_item_f065,
          lv_taxamt  TYPE kzwi6,
          lv_taxper  TYPE kzwi6,
          lv_amt     TYPE kzwi6.

    FREE:lst_items,lv_taxper,li_items,li_tax,li_tax_tmp,lst_tax,lv_taxamt,lst_tax1,lv_amt.

    SELECT posnr,   "lineitem
           matnr,   "Material
           arktx,   "Description
           kwmeng,  "Quantity
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
             bismt
        FROM mara
        INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_vbap
        WHERE matnr = @li_vbap-matnr.
    ENDIF.
    SELECT *
      FROM konv
      INTO TABLE @DATA(li_konv)
      WHERE knumv = @st_vbak-knumv
        AND kschl = @c_zwpr.

    i_hdr_itm-hdr_gen-sub_tot_curr = st_vbak-waerk.

    FREE :lst_items,lst_tax,li_tax,li_items.

    LOOP AT li_vbap INTO DATA(lst_vbap).
      READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbap-matnr.
      IF sy-subrc = 0.
        lst_items-item = lst_mara-bismt.
      ENDIF.
      lst_items-description = lst_vbap-arktx.

      IF lst_vbap-uepos = c_higherline     "Higher Line Item
        OR lst_vbap-pstyv NE c_zpan.
        lst_items-kwmeng      = lst_vbap-kwmeng.
        lst_items-meins       = lst_vbap-meins.
        lst_items-currency    = lst_vbap-waerk.
        lst_items-amount      = lst_vbap-kzwi1.
        lst_items-discounts   = lst_vbap-kzwi5 * ( - 1 ).
        lst_items-tax         = lst_vbap-kzwi6.
        IF lst_vbap-pstyv =  c_zfrt.
          READ TABLE li_konv INTO DATA(lst_konv) WITH KEY kposn = lst_vbap-posnr.
          IF sy-subrc = 0.
            i_hdr_itm-hdr_gen-freight =  i_hdr_itm-hdr_gen-freight + lst_konv-kbetr.
          ENDIF.
        ENDIF.
        lst_items-total       = lst_items-amount +
                                lst_items-tax -
                                lst_items-discounts.
        APPEND lst_items TO li_items.

        i_hdr_itm-hdr_gen-sub_total       = i_hdr_itm-hdr_gen-sub_total   +  lst_items-amount.
        i_hdr_itm-hdr_gen-tax             = i_hdr_itm-hdr_gen-tax         +  lst_items-tax.
        i_hdr_itm-hdr_gen-amount_paid     = c_0.
        i_hdr_itm-hdr_gen-total_due       = i_hdr_itm-hdr_gen-total_due   +  lst_items-total - i_hdr_itm-hdr_gen-freight.


        lst_tax-media_type     = c_tax.
        lst_tax-taxabl_amt     = lst_items-amount.
        lst_tax-tax_percentage = ( lst_vbap-kzwi6 / lst_vbap-netwr ) * 100.
        lst_tax-tax_amount     = lst_vbap-kzwi6.
        CONDENSE:lst_tax-taxabl_amt,lst_tax-tax_percentage,lst_tax-tax_amount.
        APPEND lst_tax TO li_tax.
        CLEAR:lst_tax, lst_items.
      ENDIF.
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



* Local data declaration
    DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
          lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
          lv_funcname         TYPE funcname,                    " Function name
          lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
          lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
          lr_text             TYPE string ##NEEDED,             " String value
          lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
*          st_formoutput       TYPE fpformoutput,                " Formoutput
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
*    lst_sfpoutputparams-dest      = nast-ldest.
*    lst_sfpoutputparams-copies    = nast-anzal.
*    lst_sfpoutputparams-dataset   = nast-dsnam.
*    lst_sfpoutputparams-suffix1   = nast-dsuf1.
*    lst_sfpoutputparams-suffix2   = nast-dsuf2.
*    lst_sfpoutputparams-cover     = nast-tdocover.
*    lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
*    lst_sfpoutputparams-authority = nast-tdautority.
*    lst_sfpoutputparams-receiver  = nast-tdreceiver.
*    lst_sfpoutputparams-division  = nast-tddivision.
*    lst_sfpoutputparams-arcmode   = nast-tdarmod.
*    lst_sfpoutputparams-reqimm    = nast-dimme.
*    lst_sfpoutputparams-reqdel    = nast-delet.
*    lst_sfpoutputparams-senddate  = nast-vsdat.
*    lst_sfpoutputparams-sendtime  = nast-vsura.
*
**--- Set language and default language
*    lst_sfpdocparams-langu     = nast-spras.

* Archiving
*    APPEND toa_dara TO lst_sfpdocparams-daratab.

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

*        v_ent_retco = sy-subrc.
*
*        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*          EXPORTING
*            msg_arbgb              = sy-msgid
*            msg_nr                 = sy-msgno
*            msg_ty                 = sy-msgty
*            msg_v1                 = sy-msgv1
*            msg_v2                 = sy-msgv2
*            msg_v3                 = sy-msgv3
*            msg_v4                 = sy-msgv4
*          EXCEPTIONS
*            message_type_not_valid = 1
*            no_sy_message          = 2
*            OTHERS                 = 3.
*        IF sy-subrc NE 0.
**- To avoid Extended program check message
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*        ENDIF. " IF sy-subrc NE 0
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
        IF sy-subrc <> 0.

*          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*            EXPORTING
*              msg_arbgb              = sy-msgid
*              msg_nr                 = sy-msgno
*              msg_ty                 = sy-msgty
*              msg_v1                 = sy-msgv1
*              msg_v2                 = sy-msgv2
*              msg_v3                 = sy-msgv3
*              msg_v4                 = sy-msgv4
*            EXCEPTIONS
*              message_type_not_valid = 1
*              no_sy_message          = 2
*              OTHERS                 = 3.
*          IF sy-subrc NE 0.
**- To avoid Extended program check message
*            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF. " IF sy-subrc NE 0
*          v_ent_retco = 900.
*          RETURN.
        ELSE. " ELSE -> IF sy-subrc <> 0

*          PERFORM f_protocol_update. "update sucess log

          CALL FUNCTION 'FP_JOB_CLOSE'
            EXCEPTIONS
              usage_error    = 1
              system_error   = 2
              internal_error = 3
              OTHERS         = 4.
*          IF sy-subrc <> 0.
*
*            CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*              EXPORTING
*                msg_arbgb              = sy-msgid
*                msg_nr                 = sy-msgno
*                msg_ty                 = sy-msgty
*                msg_v1                 = sy-msgv1
*                msg_v2                 = sy-msgv2
*                msg_v3                 = sy-msgv3
*                msg_v4                 = sy-msgv4
*              EXCEPTIONS
*                message_type_not_valid = 1
*                no_sy_message          = 2
*                OTHERS                 = 3.
*            IF sy-subrc NE 0.
**- To avoid Extended program check message
*              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*            ENDIF. " IF sy-subrc NE 0
*          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF sy-subrc <> 0
      ENDIF.
    ENDIF.
*- For Archiving
*    IF lst_sfpoutputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.
*
*      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
*        EXPORTING
*          documentclass            = c_pdf "  class
*          document                 = st_formoutput-pdf
*        TABLES
*          arc_i_tab                = lst_sfpdocparams-daratab
*        EXCEPTIONS
*          error_archiv             = 1
*          error_communicationtable = 2
*          error_connectiontable    = 3
*          error_kernel             = 4
*          error_parameter          = 5
*          error_format             = 6
*          OTHERS                   = 7.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE c_e NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
*                RAISING system_error.
*      ELSE. " ELSE -> IF sy-subrc <> 0
**           Check if the subroutine is called in update task.
*        CALL METHOD cl_system_transaction_state=>get_in_update_task
*          RECEIVING
*            in_update_task = lv_upd_tsk.
*        IF lv_upd_tsk EQ 0.
*          COMMIT WORK.
*        ENDIF. " IF lv_upd_tsk EQ 0
*      ENDIF. " IF sy-subrc <> 0
*    ENDIF. " IF fp_v_returncode = 0
    DATA: ls_stream TYPE ty_s_media_resource,
          ls_header TYPE ihttpnvp,
          ls_key    TYPE /iwbep/s_mgw_tech_pair,
          gv_image  TYPE xstring,
          lv_doc    TYPE vbeln.

    ls_stream-value = gv_image.
    ls_stream-mime_type = 'application/pdf'.
    IF ls_stream IS NOT INITIAL .
      CLEAR ls_header.
      ls_header-name = 'Content-Disposition'.               "#EC NOTEXT
      CONCATENATE 'inline; filename=' lv_doc INTO ls_header-value.
      me->set_header( is_header = ls_header ).
    ENDIF.
    " ************ Read the item attachment file data

    copy_data_to_ref( EXPORTING is_data = ls_stream CHANGING  cr_data = cr_entityset ).


  ENDMETHOD.
ENDCLASS.
