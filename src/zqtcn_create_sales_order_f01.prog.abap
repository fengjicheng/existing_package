*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_CREATE_SALES_ORDER_F01
* PROGRAM DESCRIPTION: Creating sales order with reference to billing document,
* This Report has been called from report ZQTCE_SALES_REP_CHG in background mode.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911696
* REFERENCE NO: ERP-6876
* DEVELOPER: Writtick Roy (WROY)
* DATE: 29-Mar-2018
* DESCRIPTION: Populate Additional fields (Sales Office, Cust PO Type)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCE_CREATE_SALES_ORDER_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       * Clear Variable.
*----------------------------------------------------------------------*
FORM f_clear_all.

* Clear Internal Table.
  CLEAR : i_input[],
         i_vbrk[],
         i_fcat[],
         i_vbrk[].

* Clear Global Variable.
  CLEAR : v_input.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SALES_ORDER
*&---------------------------------------------------------------------*
*       Create sales order
*----------------------------------------------------------------------*

FORM f_create_sales_order .

  TYPES : BEGIN OF lty_input_sel,
            sign   TYPE char1,  " Sign of type CHAR1
            option TYPE char2,  " Option of type CHAR2
            low    TYPE char32, " Low of type CHAR30
            high   TYPE char32, " High of type CHAR30
          END OF lty_input_sel.

  DATA :  lst_input              TYPE ty_input,
          lst_input_tmp          TYPE ty_input,
          lst_invoicehead        TYPE bapiwebinvhead, " Header Data for Web Billing Documents
          lst_constant           TYPE ty_constant,
          lst_return_bill        TYPE bapiret2,       " Return Parameter
          lst_webinvoicepartners TYPE bapiwebinvpart, " Partner Data for Web Billing Documents
          lst_vbrk               TYPE ty_vbrk,
          lst_vbfa               TYPE ty_vbfa,
          lst_vbfa1              TYPE ty_vbfa,
          lst_input_sel          TYPE lty_input_sel,
          lst_vbpa               TYPE ty_vbpa,
          lst_order_partner      TYPE bapiparnr,      " Communications Fields: SD Document Partner: WWW
          lst_order_header_in    TYPE bapisdhd1,      " Communication Fields: Sales and Distribution Document Header
          lst_order_header_inx   TYPE bapisdhd1x,     " Communication Fields: Sales and Distribution Document Header
          lst_order_partners     TYPE bapiparnr,      " Communications Fields: SD Document Partner: WWW
          lst_webinvoiceitems    TYPE bapiwebinvitem. " Item Data for Web Billing Documents

  DATA : li_webinvoiceitems    TYPE STANDARD TABLE OF bapiwebinvitem INITIAL SIZE 0, " Item Data for Web Billing Documents
         li_vbfa1              TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,
         li_selected_items     TYPE STANDARD TABLE OF bapiwebinvitem INITIAL SIZE 0, " Item Data for Web Billing Documents
         li_webinvoicepartners TYPE STANDARD TABLE OF bapiwebinvpart INITIAL SIZE 0, " Partner Data for Web Billing Documents
         li_return             TYPE STANDARD TABLE OF bapiret2  INITIAL SIZE 0,  " Return Parameter
         li_order_items_in     TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Communication Fields: Sales and Distribution Document Item
         li_order_items_inx    TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
*        Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
         li_conditions_in      TYPE STANDARD TABLE OF bapicond INITIAL SIZE 0,   " Communication Fields for Maintaining Conditions in the Order
         li_conditions_inx     TYPE STANDARD TABLE OF bapicondx INITIAL SIZE 0,  " Communication Fields for Maintaining Conditions in the Order
*        End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
         li_order_partners     TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Communications Fields: SD Document Partner: WWW
         li_input_tmp          TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0.


  DATA: lv_salesdocument TYPE bapivbeln-vbeln, " Sales Document
        lv_index         TYPE syst_tabix.      " ABAP System Field: Row Index of Internal Tables

  FIELD-SYMBOLS : <lst_order_partner> TYPE bapiparnr. " Communications Fields: SD Document Partner: WWW

  CONSTANTS : lc_parvw_ag    TYPE parvw VALUE 'AG',               " Partner Function
              lc_parvw_ze    TYPE parvw VALUE 'ZE',               " Partner Function
              lc_parvw_ve    TYPE parvw VALUE 'VE',               " Partner Function
*             Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
              lc_org_manual  TYPE KHERK VALUE 'C',                " Manually entered
              lc_cls_prices  TYPE koaid VALUE 'B',                " Prices
*             End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
              lc_posnr_zeros TYPE posnr_nach VALUE '000000',      " Subsequent item of an SD document
              lc_ord_typ     TYPE rvari_vnam VALUE 'ORDER_TYPE',  " ABAP: Name of Variant Variable
              lc_ord_reason  TYPE augru   VALUE 'C82',            " Order reason (reason for the business transaction)
              lc_ass_number  TYPE ordnr_v VALUE 'SALESREPCHANGE'. " Assignment number

* Get the value of Billing document , New Sales Rep 1 and New sales Rep 2.
  LOOP AT s_input INTO lst_input_sel.
    lst_input-vbeln   =  lst_input_sel-low+0(10).
    lst_input-posnr   =  lst_input_sel-low+10(6).
    lst_input-nsrep1  =  lst_input_sel-low+16(8).
    lst_input-nsrep2  =  lst_input_sel-low+24(8).
    APPEND lst_input TO i_input.
    CLEAR: lst_input_sel,
           lst_input.
  ENDLOOP. " LOOP AT s_input INTO lst_input_sel


  IF i_input IS NOT INITIAL.
* Get  Sales Org , Distribution Channel , Divisin and Sold to from table VBRK.
    SELECT vbeln " Billing Document
           vkorg " Sales Organization
           vtweg " Distribution Channel
           kunag " Sold-to party
           spart " Division
*          Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
           knumv " Number of the document condition
*          End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
      FROM vbrk  " Billing Document: Header Data
      INTO TABLE i_vbrk
      FOR ALL ENTRIES IN i_input
      WHERE vbeln = i_input-vbeln.
    IF sy-subrc EQ 0.
      SORT i_vbrk BY vbeln.
*     Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
      SELECT knumv " Number of the document condition
             kposn " Condition item number
             stunr " Step number
             zaehk " Condition counter
             kschl " Condition type
             kawrt " Condition base value
             kbetr " Rate (condition amount or percentage)
             waers " Currency Key
             kpein " Condition pricing unit
             kmein " Condition unit in the document
             kwert " Condition value
        FROM konv
        INTO TABLE i_konv
        FOR ALL ENTRIES IN i_vbrk
        WHERE knumv = i_vbrk-knumv
        AND   kherk = lc_org_manual  " Manually entered
        AND   kinak = space
        AND   koaid = lc_cls_prices. " Prices
      IF sy-subrc EQ 0.
        SORT i_konv BY knumv kposn.
      ENDIF.
*     End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
    ENDIF. " IF sy-subrc EQ 0

* Get the data from VBFA table
    SELECT vbelv  " Preceding sales and distribution document
          posnv   " Preceding item of an SD document
          vbeln   " Sales and Distribution Document Number
          posnn   " Subsequent item of an SD document
          vbtyp_n " Document category of subsequent document
      FROM vbfa   " Sales Document Flow
      INTO TABLE i_vbfa
      FOR ALL ENTRIES IN i_input
      WHERE vbeln = i_input-vbeln
      AND posnn = i_input-posnr.
    IF sy-subrc EQ 0.
      SORT i_vbfa BY vbeln posnn.

      li_vbfa1[] = i_vbfa[].
      SORT li_vbfa1 BY vbelv posnv.
*     Begin of ADD:ERP-6876:WROY:29-Mar-2018:ED2K911696
*     Fetch Sales Document: Header Data
      SELECT vbeln, " Sales Document
             vkbur, " Sales Office
             bsark  " Customer purchase order type
        FROM vbak
        INTO TABLE @DATA(li_vbak)
         FOR ALL ENTRIES IN @li_vbfa1
       WHERE vbeln EQ @li_vbfa1-vbelv.
      IF sy-subrc EQ 0.
        SORT li_vbak BY vbeln.
      ENDIF.
*     End   of ADD:ERP-6876:WROY:29-Mar-2018:ED2K911696
    ENDIF. " IF sy-subrc EQ 0

    IF i_vbfa IS NOT INITIAL .
      SELECT vbeln " Sales and Distribution Document Number
             posnr " Item number of the SD document
             parvw " Partner Function
             kunnr " Customer Number
             pernr " Personnel Number
        FROM vbpa  " Sales Document: Partner
        INTO TABLE i_vbpa
        FOR ALL ENTRIES IN i_vbfa
        WHERE vbeln = i_vbfa-vbelv
        AND ( posnr = i_vbfa-posnv
        OR   posnr = lc_posnr_zeros ).
      IF sy-subrc EQ 0.
        SORT i_vbpa BY vbeln posnr.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF i_vbfa IS NOT INITIAL
  ENDIF. " IF i_input IS NOT INITIAL


  SORT i_input BY vbeln posnr.
  li_input_tmp[] = i_input[].
  DELETE ADJACENT DUPLICATES FROM li_input_tmp COMPARING vbeln.

  LOOP AT li_input_tmp INTO lst_input_tmp.
* Fill partner data from VBRK Table
    CLEAR lst_vbrk.
    READ TABLE i_vbrk INTO lst_vbrk WITH KEY vbeln = lst_input_tmp-vbeln
                                              BINARY SEARCH.
    IF sy-subrc = 0.
* Get the Item Details of billing documents
      CALL FUNCTION 'BAPI_WEBINVOICE_GETDETAIL'
        EXPORTING
          partner_number     = lst_vbrk-kunag
          partner_role       = lc_parvw_ag
          billingdoc         = lst_input_tmp-vbeln
        IMPORTING
          webinvoicedocument = lst_invoicehead
          return             = lst_return_bill
        TABLES
          webinvoiceitems    = li_webinvoiceitems
          webinvoicepartners = li_webinvoicepartners.

      LOOP AT li_webinvoiceitems ASSIGNING FIELD-SYMBOL(<lst_webinvoiceitems>).
        READ TABLE i_input TRANSPORTING NO FIELDS WITH KEY vbeln = <lst_webinvoiceitems>-billingdoc
                                                           posnr = <lst_webinvoiceitems>-item_number
                                                            BINARY SEARCH.
        IF sy-subrc EQ 0.
          APPEND <lst_webinvoiceitems> TO li_selected_items.
        ENDIF. " IF sy-subrc EQ 0
      ENDLOOP. " LOOP AT li_webinvoiceitems ASSIGNING FIELD-SYMBOL(<lst_webinvoiceitems>)

* Populate partner table.
      CLEAR lst_vbfa.
      READ TABLE i_vbfa INTO lst_vbfa WITH KEY vbeln = lst_input_tmp-vbeln
                                               posnn = lst_input_tmp-posnr
                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR lst_vbpa.
        READ TABLE i_vbpa TRANSPORTING NO FIELDS WITH KEY vbeln = lst_vbfa-vbelv
                                                  BINARY SEARCH.
        IF sy-subrc = 0. "Does not enter the inner loop
          lv_index = sy-tabix.

          LOOP AT i_vbpa INTO lst_vbpa FROM lv_index. "Avoiding Where clause

            IF lst_vbpa-vbeln <>  lst_vbfa-vbelv. "This checks whether to exit out of loop
              EXIT.
            ENDIF. " IF lst_vbpa-vbeln <> lst_vbfa-vbelv
            lst_order_partners-partn_role  = lst_vbpa-parvw.

            CLEAR lst_vbfa1.
            READ TABLE li_vbfa1  INTO lst_vbfa1 WITH KEY  vbelv = lst_vbpa-vbeln
                                                          posnv = lst_vbpa-posnr
                                                          BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_order_partners-itm_number  = lst_vbfa1-posnn.
            ELSE. " ELSE -> IF sy-subrc EQ 0
              lst_order_partners-itm_number  = lst_vbpa-posnr.
            ENDIF. " IF sy-subrc EQ 0

            IF lst_vbpa-kunnr IS NOT INITIAL.
              lst_order_partners-partn_numb  = lst_vbpa-kunnr.
            ELSE. " ELSE -> IF lst_vbpa-kunnr IS NOT INITIAL
              lst_order_partners-partn_numb  = lst_vbpa-pernr.
            ENDIF. " IF lst_vbpa-kunnr IS NOT INITIAL

            APPEND lst_order_partners TO li_order_partners.
            CLEAR lst_order_partners.

          ENDLOOP. " LOOP AT i_vbpa INTO lst_vbpa FROM lv_index
        ENDIF. " IF sy-subrc = 0
*       Begin of ADD:ERP-6876:WROY:29-Mar-2018:ED2K911696
*       Retrieve Sales Document: Header Data
        READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak>)
             WITH KEY vbeln = lst_vbfa-vbelv
             BINARY SEARCH.
        IF sy-subrc EQ 0.
*         Sales Office
          lst_order_header_in-sales_off = <lst_vbak>-vkbur.
          lst_order_header_inx-sales_off = abap_true.
*         Customer purchase order type
          lst_order_header_in-po_method = <lst_vbak>-bsark.
          lst_order_header_inx-po_method = abap_true.
        ENDIF.
*       End   of ADD:ERP-6876:WROY:29-Mar-2018:ED2K911696
      ENDIF. " IF sy-subrc EQ 0

* Populate Ref Doc type
      lst_order_header_in-refdoctype = lst_invoicehead-sd_doc_cat.

* Populate Document Type
* Get the Destination Value from i_constant Table.
      CLEAR lst_constant.
      READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_ord_typ
                                                       param2 = lst_invoicehead-bill_type.
      IF sy-subrc EQ 0.
        lst_order_header_in-doc_type = lst_constant-low.
        lst_order_header_inx-doc_type = abap_true.

* Populate Sales Org
        lst_order_header_in-sales_org = lst_vbrk-vkorg.
        lst_order_header_inx-sales_org = abap_true.

* Populate distribution Channel
        lst_order_header_in-distr_chan = lst_vbrk-vtweg.
        IF lst_vbrk-vtweg IS NOT INITIAL.
          lst_order_header_inx-distr_chan = abap_true.
        ENDIF. " IF lst_vbrk-vtweg IS NOT INITIAL
* Populate Division
        IF lst_vbrk-spart IS NOT INITIAL.
          lst_order_header_in-division = lst_vbrk-spart.
          lst_order_header_inx-division = abap_true.
        ENDIF. " IF lst_vbrk-spart IS NOT INITIAL
* Populate ref Document
        IF lst_input_tmp-vbeln IS NOT INITIAL.
          lst_order_header_in-ref_1 = lst_input_tmp-vbeln.
          lst_order_header_inx-ref_1 = abap_true.
        ENDIF. " IF lst_input_tmp-vbeln IS NOT INITIAL
* Order Change reson
        lst_order_header_in-ord_reason = lc_ord_reason. "'C82'"Sales Rep Change
        lst_order_header_inx-ord_reason = abap_true. "'C82'"Sales Rep Change
        lst_order_header_in-ass_number = lc_ass_number.
        lst_order_header_inx-ass_number = abap_true.

* Add Items in sales order.
        PERFORM add_items USING    li_selected_items
                                   lst_input_tmp-vbeln
*                                  Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
                                   lst_vbrk-knumv
*                                  End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
                          CHANGING li_order_items_in
                                   li_order_items_inx
*                                  Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
                                   li_conditions_in
                                   li_conditions_inx.
*                                  End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183

* Create Sales Document with Referenece to Billing .
        CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
          EXPORTING
            sales_header_in      = lst_order_header_in
            sales_header_inx     = lst_order_header_inx
          IMPORTING
            salesdocument_ex     = lv_salesdocument
          TABLES
            return               = li_return
            sales_items_in       = li_order_items_in
            sales_items_inx      = li_order_items_inx
*           Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
            sales_conditions_in  = li_conditions_in
            sales_conditions_inx = li_conditions_inx
*           End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
            sales_partners       = li_order_partners.

*  Populate ALV
        PERFORM f_populate_alv USING lst_input_tmp-vbeln
                                     lst_order_header_in-doc_type
                                     li_return
                               CHANGING i_alv.

        CLEAR li_return[].
        IF NOT lv_salesdocument IS INITIAL.
          PERFORM f_bapi_commit USING lst_input_tmp-vbeln
                                      lst_order_header_in-doc_type
                             CHANGING i_alv.

          CLEAR lv_salesdocument.


* Creating new order with Updated sales Rep
          lst_order_header_in-doc_type = lst_constant-high.

* fill partner data
* Table li_webinvoicepartners will be having less then 40 records
* so no binary search has been used .
          LOOP AT li_selected_items INTO lst_webinvoiceitems.
            READ TABLE i_input INTO lst_input WITH KEY vbeln = lst_webinvoiceitems-billingdoc
                                                       posnr = lst_webinvoiceitems-item_number
                                                      BINARY SEARCH.
            IF sy-subrc EQ 0.
              IF lst_input-nsrep1 IS NOT INITIAL.
*             Table will not have many records so no binary serach required.
                READ TABLE li_order_partners ASSIGNING <lst_order_partner>
                                             WITH KEY partn_role = lc_parvw_ve
                                                      itm_number = lst_webinvoiceitems-item_number.
                IF sy-subrc NE 0.
                  lst_order_partner-itm_number = lst_webinvoiceitems-item_number.
                  lst_order_partner-partn_numb = lst_input-nsrep1.
                  lst_order_partner-partn_role = lc_parvw_ve.
                  APPEND lst_order_partner TO li_order_partners.
                  CLEAR lst_order_partner.
                ELSE. " ELSE -> IF sy-subrc NE 0
                  <lst_order_partner>-partn_numb = lst_input-nsrep1.
                  UNASSIGN <lst_order_partner>.
                ENDIF. " IF sy-subrc NE 0
              ENDIF. " IF lst_input-nsrep1 IS NOT INITIAL
            ENDIF. " IF sy-subrc EQ 0

            IF lst_input-nsrep2 IS NOT INITIAL.
              READ TABLE li_order_partners ASSIGNING FIELD-SYMBOL(<lst_order_partner2>)
                                            WITH KEY partn_role = lc_parvw_ze
                                                     itm_number = lst_webinvoiceitems-item_number.
              IF sy-subrc NE 0.
                lst_order_partner-itm_number = lst_webinvoiceitems-item_number.
                lst_order_partner-partn_numb = lst_input-nsrep2.
                lst_order_partner-partn_role = lc_parvw_ze.
                APPEND lst_order_partner TO li_order_partners.
                CLEAR lst_order_partner.
*                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF sy-subrc NE 0
                <lst_order_partner2>-partn_numb = lst_input-nsrep2.
                UNASSIGN <lst_order_partner2>.
              ENDIF. " IF sy-subrc NE 0
            ENDIF. " IF lst_input-nsrep2 IS NOT INITIAL
          ENDLOOP. " LOOP AT li_selected_items INTO lst_webinvoiceitems

          CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
            EXPORTING
              sales_header_in      = lst_order_header_in
              sales_header_inx     = lst_order_header_inx
            IMPORTING
              salesdocument_ex     = lv_salesdocument
            TABLES
              return               = li_return
              sales_items_in       = li_order_items_in
              sales_items_inx      = li_order_items_inx
*             Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
              sales_conditions_in  = li_conditions_in
              sales_conditions_inx = li_conditions_inx
*             End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
              sales_partners       = li_order_partners.

          PERFORM f_populate_alv USING lst_input_tmp-vbeln
                                        lst_order_header_in-doc_type
                                        li_return
                                  CHANGING i_alv.
          CLEAR li_return[].
          IF NOT lv_salesdocument IS INITIAL.
            PERFORM f_bapi_commit USING lst_input_tmp-vbeln
                                        lst_order_header_in-doc_type
                                  CHANGING i_alv.
          ELSE. " ELSE -> IF NOT lv_salesdocument IS INITIAL
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ENDIF. " IF NOT lv_salesdocument IS INITIAL
        ELSE. " ELSE -> IF NOT lv_salesdocument IS INITIAL
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ENDIF. " IF NOT lv_salesdocument IS INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc = 0

    CLEAR : lv_salesdocument,
            lst_order_header_in,
            lst_order_header_inx,
            lst_invoicehead,
            lst_return_bill,
            lst_order_header_in,
            li_webinvoiceitems[],
            li_selected_items[],
            li_webinvoicepartners[],
            li_return[],
            li_order_items_in[],
            li_order_items_inx[],
*           Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
            li_conditions_in[],
            li_conditions_inx[],
*           End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
            li_order_partners[].
  ENDLOOP. " LOOP AT li_input_tmp INTO lst_input_tmp
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  add_items
*&---------------------------------------------------------------------*
*&    Using     Fp_li_webinvoiceitems TYPE tt_webinvoiceitems
*&    Changing  Fp_li_order_items_in  TYPE tt_order_items_in
*&---------------------------------------------------------------------*

FORM add_items   USING  fp_li_webinvoiceitems TYPE tt_webinvoiceitems
                        fp_input_vbeln  TYPE vbeln_vf " Billing Document
*                       Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
                        fp_lst_vbrk_knumv TYPE knumv
*                       End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
               CHANGING fp_li_order_items_in  TYPE tt_order_items_in
                        fp_li_order_items_inx  TYPE tt_order_items_inx
*                       Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
                        fp_li_conditions_in   TYPE tt_conditions_in
                        fp_li_conditions_inx   TYPE tt_conditions_inx.
*                       End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183

  DATA : lst_webinvoiceitems TYPE bapiwebinvitem, " Item Data for Web Billing Documents
         lst_order_items_in  TYPE bapisditm,      " Communication Fields: Sales and Distribution Document Item
         lst_order_items_inx TYPE bapisditmx.     " Communication Fields: Sales and Distribution Document Item

  CONSTANTS : lc_doc_ca TYPE vbtyp_v VALUE 'M'. " Document category of preceding SD document

  LOOP AT fp_li_webinvoiceitems INTO lst_webinvoiceitems.

    IF lst_webinvoiceitems-item_number IS NOT INITIAL.
      lst_order_items_in-itm_number = lst_webinvoiceitems-item_number.
      lst_order_items_inx-itm_number = abap_true.
    ENDIF. " IF lst_webinvoiceitems-item_number IS NOT INITIAL

    IF lst_webinvoiceitems-item_number IS NOT INITIAL.
      lst_order_items_in-material   =  lst_webinvoiceitems-material.
      lst_order_items_inx-material   =  abap_true.
    ENDIF. " IF lst_webinvoiceitems-item_number IS NOT INITIAL

    IF lst_webinvoiceitems-item_number IS NOT INITIAL.
      lst_order_items_in-target_qty =  lst_webinvoiceitems-inv_qty.
      lst_order_items_inx-target_qty =  abap_true.
    ENDIF. " IF lst_webinvoiceitems-item_number IS NOT INITIAL

*    lst_order_items_in-material   =   lst_webinvoiceitems-material.
    IF fp_input_vbeln IS NOT INITIAL.
      lst_order_items_in-ref_doc    =   fp_input_vbeln.
      lst_order_items_inx-ref_doc    =  abap_true.
    ENDIF. " IF fp_input_vbeln IS NOT INITIAL

    IF lst_webinvoiceitems-item_number IS NOT INITIAL.
      lst_order_items_in-ref_doc_it = lst_webinvoiceitems-item_number.
      lst_order_items_inx-ref_doc_it = abap_true.
    ENDIF. " IF lst_webinvoiceitems-item_number IS NOT INITIAL

    lst_order_items_in-ref_doc_ca = lc_doc_ca.
    lst_order_items_inx-ref_doc_ca = abap_true.

    APPEND lst_order_items_in TO fp_li_order_items_in.
    APPEND lst_order_items_inx TO fp_li_order_items_inx.

*   Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
*   Conditions (Manual Entries)
    READ TABLE i_konv TRANSPORTING NO FIELDS
         WITH KEY knumv = fp_lst_vbrk_knumv
                  kposn = lst_webinvoiceitems-item_number
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT i_konv ASSIGNING FIELD-SYMBOL(<lst_konv>) FROM sy-tabix.
        IF <lst_konv>-knumv NE fp_lst_vbrk_knumv OR
           <lst_konv>-kposn NE lst_webinvoiceitems-item_number.
          EXIT.
        ENDIF.
        APPEND INITIAL LINE TO fp_li_conditions_in  ASSIGNING FIELD-SYMBOL(<lst_cond_in>).
        APPEND INITIAL LINE TO fp_li_conditions_inx ASSIGNING FIELD-SYMBOL(<lst_cond_inx>).
*       Condition item number
        <lst_cond_in>-itm_number  = <lst_konv>-kposn.
        <lst_cond_inx>-itm_number = <lst_konv>-kposn.
*       Step number
        <lst_cond_in>-cond_st_no  = <lst_konv>-stunr.
        <lst_cond_inx>-cond_st_no = <lst_konv>-stunr.
*       Sequential number of the condition
        <lst_cond_in>-cond_count  = <lst_konv>-zaehk.
        <lst_cond_inx>-cond_count = <lst_konv>-zaehk.
*       Condition type
        <lst_cond_in>-cond_type   = <lst_konv>-kschl.
        <lst_cond_inx>-cond_type  = <lst_konv>-kschl.
*       Condition rate
        CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERN_9'
          EXPORTING
            currency        = <lst_konv>-waers
            amount_internal = <lst_konv>-kbetr
          IMPORTING
            amount_external = <lst_cond_in>-cond_value.
        <lst_cond_inx>-cond_value = abap_true.
*       Currency Key
        <lst_cond_in>-currency    = <lst_konv>-waers.
        <lst_cond_inx>-currency   = abap_true.
*       Condition unit
        <lst_cond_in>-cond_unit   = <lst_konv>-kmein.
        <lst_cond_inx>-cond_unit  = abap_true.
*       Condition pricing unit
        <lst_cond_in>-cond_p_unt  = <lst_konv>-kpein.
        <lst_cond_inx>-cond_p_unt = abap_true.
      ENDLOOP.
    ENDIF.
*   End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183

    CLEAR lst_order_items_in.
    CLEAR lst_order_items_inx.

  ENDLOOP. " LOOP AT fp_li_webinvoiceitems INTO lst_webinvoiceitems

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_RECORDS_ALV
*&---------------------------------------------------------------------*
*       Display ALV Reports
*----------------------------------------------------------------------*
FORM f_display_records_alv .

  DATA: lst_layout   TYPE slis_layout_alv.

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_catalog .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat
      i_save             = abap_true
    TABLES
      t_outtab           = i_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
  ENDIF. " IF sy-subrc <> 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ALV
*&---------------------------------------------------------------------*
*       Populate ALV Table
*----------------------------------------------------------------------*
*       USING    fp_vbeln     " Billing Document
*                fp_doc_type  " Document Type
*                fp_li_return " Return Table
*      CHANGING  fp_i_alv     " Change ALV Table
*----------------------------------------------------------------------*
FORM f_populate_alv  USING    fp_vbeln TYPE vbeln_vf " Billing Document
                              fp_doc_type TYPE auart
                              fp_li_return TYPE tt_return
                     CHANGING fp_i_alv TYPE tt_alv.

* Local Work Area Declaration
  DATA :lst_alv    TYPE ty_alv,
        lst_input  TYPE ty_input,
        lst_return TYPE bapiret2. " Return Parameter

* Local Variable Declaration
  DATA:  lv_index         TYPE syst_tabix. " ABAP System Field: Row Index of Internal Tables

  LOOP AT fp_li_return INTO lst_return.
    lst_alv-vbeln = fp_vbeln.
    READ TABLE i_input TRANSPORTING NO FIELDS WITH KEY vbeln = fp_vbeln
                                                       BINARY SEARCH .
    IF sy-subrc = 0. "Does not enter the inner loop
      lv_index = sy-tabix.
      LOOP AT i_input INTO lst_input FROM lv_index. "Avoiding Where clause
        IF lst_input-vbeln <> fp_vbeln. "This checks whether to exit out of loop
          EXIT.
        ENDIF. " IF lst_input-vbeln <> fp_vbeln
        lst_alv-posnr = lst_input-posnr.
        lst_alv-auart = fp_doc_type.
        lst_alv-type  =  lst_return-type.
        lst_alv-id    =  lst_return-id.
        lst_alv-number = lst_return-number.
        lst_alv-message = lst_return-message.
        APPEND lst_alv TO fp_i_alv.
      ENDLOOP. " LOOP AT i_input INTO lst_input FROM lv_index
    ENDIF. " IF sy-subrc = 0
    CLEAR lst_alv.

  ENDLOOP. " LOOP AT fp_li_return INTO lst_return

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*      Populate Field Catalog
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname     TYPE slis_tabname VALUE 'I_ALV', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln   TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_posnr   TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_fkart   TYPE slis_fieldname VALUE 'AUART',
             lc_fld_type    TYPE slis_fieldname VALUE 'TYPE',
             lc_fld_id      TYPE slis_fieldname VALUE 'ID',
             lc_fld_number  TYPE slis_fieldname VALUE 'NUMBER',
             lc_fld_message TYPE slis_fieldname VALUE 'MESSAGE'.

* Populate field catalog

* Invoice Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Invoice number'(001)
                       CHANGING i_fcat.

* Invoice Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Invoice Item Number'(007)
                       CHANGING i_fcat.

* Invoice Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_fkart  lc_tabname   lv_col_pos  'Invoice Type'(002)
                       CHANGING i_fcat.

* Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_type  lc_tabname   lv_col_pos  'Message Type'(003)
                     CHANGING i_fcat.

* ID
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_id  lc_tabname   lv_col_pos  'Message ID'(004)
                     CHANGING i_fcat.

* Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_number  lc_tabname   lv_col_pos  'Message Number'(005)
                     CHANGING i_fcat.

* Message
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_message lc_tabname   lv_col_pos  'Message'(006)
                     CHANGING i_fcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field catalog
*----------------------------------------------------------------------*
*                   USING      fp_field        " Field Name
*                              fp_tabname      " Table Name
*                              fp_col_pos      " Col_pos of type Integers
*                              fp_text         " Text of type CHAR50
*                     CHANGING fp_i_fcat       " Build field catalog
*----------------------------------------------------------------------*
FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*      Get The constant value from ZCACONSTANT table
*----------------------------------------------------------------------*
FORM f_get_constants .

  CONSTANTS: lc_devid  TYPE zdevid VALUE 'E131'. " Development ID
* Get the constant value from table Zcaconstant
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE i_constant
    WHERE devid = lc_devid.
  IF sy-subrc IS INITIAL.
* Suitable error handling will done later .
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BAPI_COMMIT
*&---------------------------------------------------------------------*
*       Commit Work and Refreash the buffer.
*----------------------------------------------------------------------*
*  Using    FP_VBELN " billing docuemnt
*           FP_DOC_TYPE  " Docuemnt Type
*  Changing FP_I_ALV " ALV Report
*----------------------------------------------------------------------*
FORM f_bapi_commit    USING   fp_vbeln TYPE vbeln_vf " Billing Document
                              fp_doc_type TYPE auart
                     CHANGING fp_i_alv TYPE tt_alv.

  CONSTANTS : lc_wait       TYPE bapiwait VALUE 'X'. " Use the command `COMMIT AND WAIT`

  DATA :  lst_return TYPE bapiret2, " Return Parameter
          lst_alv    TYPE ty_alv.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait   = space " lc_wait
    IMPORTING
      return = lst_return.

ENDFORM.
