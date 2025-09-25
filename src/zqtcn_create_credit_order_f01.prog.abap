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
* REVISION NO: ED1K908183, ED1K908218
* REFERENCE NO: INC0205683
* DEVELOPER: Writtick Roy (WROY)
* DATE: 16-Aug-2018
* DESCRIPTION: Copy Manual Prices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909092
* REFERENCE NO: AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
* DEVELOPER:PRABHU
* DATE:12/6/2018
* DESCRIPTION:Create CMR/DMR
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914088
* REFERENCE NO: AMS_R2_QTC_SD INC0207762 ZCSS Ref Inovice& Sales rep change
* DEVELOPER:KIRAN JAGANA
* DATE:12/19/2018
* DESCRIPTION:Create CMR/DMR
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914989
* REFERENCE NO: INC0241755 To update salerep if item number is available
* DEVELOPER:LRAMIREDD
* DATE:05/03/2019
* DESCRIPTION:Create CMR/DMR
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
          lst_alv                TYPE ty_alv,
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
          lst_webinvoiceitems    TYPE bapiwebinvitem, " Item Data for Web Billing Documents
          lst_order_items_in     TYPE bapisditm,
          lst_order_items_inx    TYPE bapisditmx.

  DATA : li_webinvoiceitems    TYPE STANDARD TABLE OF bapiwebinvitem INITIAL SIZE 0, " Item Data for Web Billing Documents
         li_vbfa1              TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,
         li_selected_items     TYPE STANDARD TABLE OF bapiwebinvitem INITIAL SIZE 0, " Item Data for Web Billing Documents
         li_webinvoicepartners TYPE STANDARD TABLE OF bapiwebinvpart INITIAL SIZE 0, " Partner Data for Web Billing Documents
         li_return             TYPE STANDARD TABLE OF bapiret2  INITIAL SIZE 0,  " Return Parameter
         li_order_items_in     TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Communication Fields: Sales and Distribution Document Item
         li_order_items_inx    TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
*        Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
         li_schedules_in       TYPE STANDARD TABLE OF bapischdl INITIAL SIZE 0,  " Communication Fields for Maintaining SD Doc. Schedule Lines
         li_schedules_inx      TYPE STANDARD TABLE OF bapischdlx INITIAL SIZE 0,
         li_conditions_in      TYPE STANDARD TABLE OF bapicond INITIAL SIZE 0,   " Communication Fields for Maintaining Conditions in the Order
         li_conditions_inx     TYPE STANDARD TABLE OF bapicondx INITIAL SIZE 0,  " Communication Fields for Maintaining Conditions in the Order
*        End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
         li_order_partners     TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Communications Fields: SD Document Partner: WWW
         li_input_tmp          TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0.


  DATA: lv_salesdocument TYPE bapivbeln-vbeln, " Sales Document
        lv_doc_ty        TYPE auart,
        lv_index         TYPE syst_tabix.      " ABAP System Field: Row Index of Internal Tables

  FIELD-SYMBOLS : <lst_order_partner> TYPE bapiparnrc. " Communications Fields: SD Document Partner: WWW

  CONSTANTS :
*             Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
    lc_ctg_newcp   TYPE kntyp VALUE 'L',                " Generally new when copying
    lc_org_auto    TYPE kherk VALUE 'A',                " Automatic pricing
    lc_cls_price   TYPE koaid VALUE 'B',                " Price
    lc_cls_taxes   TYPE koaid VALUE 'D',                " Taxes
*             End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
    lc_posnr_zeros TYPE posnr_nach VALUE '000000',      " Subsequent item of an SD document
    lc_ord_typ     TYPE rvari_vnam VALUE 'ORDER_TYPE',  " ABAP: Name of Variant Variable
    lc_ord_reason  TYPE augru   VALUE 'C82',            " Order reason (reason for the business transaction)
    lc_ass_number  TYPE ordnr_v VALUE 'SALESREPCHANGE', " Assignment number
    lc_po_type     TYPE bsark VALUE '0130'.

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
      SELECT vbeln
             posnr
             matnr
             fkimg
             prsdt
             konda_auft INTO TABLE i_vbrp
             FROM vbrp
             FOR ALL ENTRIES IN i_vbrk
             WHERE vbeln = i_vbrk-vbeln.
      IF sy-subrc EQ 0.
        SORT i_vbrp BY vbeln posnr.
      ENDIF.
*     Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
      SELECT knumv " Number of the document condition
             kposn " Condition item number
             stunr " Step number
             zaehk " Condition counter
             kschl " Condition type
             krech " Calculation type for condition
             kawrt " Condition base value
             kbetr " Rate (condition amount or percentage)
             waers " Currency Key
             kpein " Condition pricing unit
             kmein " Condition unit in the document
             kwert " Condition value
             koaid " Condition class
             kherk " Origin of the condition
        FROM konv
        INTO TABLE i_konv
        FOR ALL ENTRIES IN i_vbrk
        WHERE knumv = i_vbrk-knumv
        AND   kstat = space
        AND   kinak = space
        AND   kntyp <> lc_ctg_newcp
        AND   koaid <> lc_cls_taxes. " Taxes
      IF sy-subrc EQ 0.
        DELETE i_konv WHERE koaid EQ lc_cls_price   "Prices
                        AND kherk EQ lc_org_auto. "Automatic pricing
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
  DELETE ADJACENT DUPLICATES FROM li_input_tmp COMPARING vbeln posnr.

  LOOP AT li_input_tmp INTO lst_input_tmp.
    PERFORM f_simulate_order.
    lv_doctype = lc_credit.
    IF lv_error IS INITIAL.
      PERFORM f_create_cmr_dmr USING lv_doctype.

      IF lv_credit IS NOT INITIAL.
        lv_doctype = lc_debit.
        PERFORM f_create_cmr_dmr USING lv_doctype.
        IF lv_debit IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_debit
            IMPORTING
              output = lv_debit.
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
            ENDLOOP. " LOOP AT li
          ENDIF.
          LOOP AT li_selected_items INTO lst_webinvoiceitems WHERE billingdoc = lst_input_tmp-vbeln
                                                               AND item_number = lst_input_tmp-posnr.
            READ TABLE i_input INTO lst_input WITH KEY vbeln = lst_webinvoiceitems-billingdoc
                                                       posnr = lst_webinvoiceitems-item_number
                                                      BINARY SEARCH.
            IF sy-subrc EQ 0.
              IF lst_input-nsrep1 IS NOT INITIAL.
*             Table will not have many records so no binary serach required.
                READ TABLE li_part_change ASSIGNING <lst_order_partner>
                                             WITH KEY partn_role = lc_parvw_ve
                                                      itm_number = lst_webinvoiceitems-item_number.
                IF sy-subrc NE 0.
                  lst_part_change-document = lv_debit.
                  lst_part_change-itm_number = lst_webinvoiceitems-item_number.
                  lst_part_change-p_numb_new = lst_input-nsrep1.
                  lst_part_change-partn_role = lc_parvw_ve.
                  lst_part_change-updateflag = 'U'.
                  lst_partners-partn_role  =  lc_parvw_ve.
                  lst_partners-partn_numb =  lst_input-nsrep1.
                  lst_partners-itm_number  = lst_webinvoiceitems-item_number.
                  APPEND lst_part_change TO li_part_change.
                  CLEAR lst_order_partner.
                  APPEND lst_partners TO li_partners.
                  CLEAR lst_partners.
                  IF lst_webinvoiceitems-item_number IS NOT INITIAL.
                    lst_orders_in-itm_number = lst_webinvoiceitems-item_number.
                    APPEND lst_orders_in TO li_orders_in.
                    CLEAR lst_orders_in.
                    lst_orders_inx-itm_number = lst_webinvoiceitems-item_number..
                    lst_orders_inx-updateflag = 'U'.
                    APPEND lst_orders_inx TO li_orders_inx.
                    CLEAR lst_orders_inx.
                  ENDIF.
                ELSE. " ELSE -> IF sy-subrc NE 0
                  <lst_order_partner>-p_numb_new = lst_input-nsrep1.
                  UNASSIGN <lst_order_partner>.
                ENDIF. " IF sy-subrc NE 0
              ENDIF. " IF lst_input-nsrep1 IS NOT INITIAL
              CLEAR lst_vbfa.
              READ TABLE i_vbfa INTO lst_vbfa WITH KEY vbeln = lst_input_tmp-vbeln
                                                       posnn = lst_input_tmp-posnr
                                                       BINARY SEARCH.
              IF sy-subrc EQ 0.
                READ TABLE li_vbak INTO DATA(lst_vbak)
                      WITH KEY vbeln = lst_vbfa-vbelv
                      BINARY SEARCH.
                IF sy-subrc EQ 0.
*         Sales Office
                  lst_order_header_in-sales_off   = lst_vbak-vkbur.
                  lst_order_header_inx-sales_off  = abap_true.
                  lst_order_header_in-ord_reason  = lc_ord_reason. "'C82'"Sales Rep Change
                  lst_order_header_inx-ord_reason = abap_true. "'C82'"Sales Rep Change
                  lst_order_header_inx-updateflag = 'U'.
                  lst_order_header_in-ass_number = lc_ass_number.
                  lst_order_header_inx-ass_number = abap_true.
*         PO type
                  lst_order_header_in-po_method = lst_vbak-bsark.
                  lst_order_header_inx-po_method = abap_true.
                  IF lst_order_header_in-po_method IS INITIAL.
                    lst_order_header_in-po_method = lc_po_type.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF. " IF sy-subrc EQ 0
            IF lst_input-nsrep2 IS NOT INITIAL.
              READ TABLE li_part_change ASSIGNING FIELD-SYMBOL(<lst_order_partner2>)
                                            WITH KEY partn_role = lc_parvw_ze
                                                     itm_number = lst_webinvoiceitems-item_number.
              IF sy-subrc NE 0.
                lst_part_change-document = lv_debit.
                lst_part_change-itm_number = lst_webinvoiceitems-item_number.
                lst_part_change-p_numb_new = lst_input-nsrep2.
                lst_part_change-partn_role = lc_parvw_ze.
*                 Update the partner functions value
*                lst_part_change-updateflag = 'I'.
                lst_part_change-updateflag = 'U'.
                lst_partners-partn_role  =  lc_parvw_ze.
                lst_partners-partn_numb =  lst_input-nsrep2.
                lst_partners-itm_number  = lst_webinvoiceitems-item_number.
                IF lst_webinvoiceitems-item_number IS NOT INITIAL.
                  lst_orders_in-itm_number = lst_webinvoiceitems-item_number.
                  APPEND lst_orders_in TO li_orders_in.
                  CLEAR lst_orders_in.
                  lst_orders_inx-itm_number = lst_webinvoiceitems-item_number.
                  lst_orders_inx-updateflag = 'U'.
                  APPEND lst_orders_inx TO li_orders_inx.
                  CLEAR lst_orders_inx.
                ENDIF.
                APPEND lst_part_change TO li_part_change.
                CLEAR lst_order_partner.
                APPEND lst_partners TO li_partners.
                CLEAR lst_partners.
*                ENDIF. " IF sy-subrc EQ 0
              ELSE. " ELSE -> IF sy-subrc NE 0
                <lst_order_partner2>-p_numb_new = lst_input-nsrep2.
                UNASSIGN <lst_order_partner2>.
              ENDIF. " IF sy-subrc NE 0
            ENDIF. " IF lst_input-nsrep2 IS NOT INITIAL
          ENDLOOP. " LOOP AT li_selected_items INTO lst_webinvoiceitems

          DELETE ADJACENT DUPLICATES FROM  li_orders_in COMPARING itm_number.
          DELETE ADJACENT DUPLICATES FROM  li_orders_inx COMPARING itm_number.


          IF li_partners IS NOT INITIAL.
            CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
              EXPORTING
                salesdocument     = lv_debit
                order_header_in   = lst_order_header_in
                order_header_inx  = lst_order_header_inx
*          IMPORTING
*               sales_header_out  =
*               sales_header_status =
              TABLES
                return            = li_return
                item_in           = li_orders_in
                item_inx          = li_orders_inx
*               SCHEDULE_IN       =
*               SCHEDULE_INX      =
                partners          = li_partners
                partnerchanges    = li_part_change
              EXCEPTIONS
                incov_not_in_item = 1
                OTHERS            = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ELSE.
              PERFORM f_bapi_commit USING lst_input_tmp-vbeln
                                               lst_order_header_in-doc_type
                                      CHANGING i_alv.
*              BOC BY KJAGANA INC0207762
*               Display the error log,if bapi encoutered any errors
              READ TABLE li_return INTO DATA(lst_return) WITH KEY type = lc_e.
              IF sy-subrc EQ 0.
                lst_alv-vbeln =  lst_input_tmp-vbeln.
                lst_alv-posnr =  lst_input_tmp-posnr.
                lst_alv-auart =  lc_debit.
                lst_alv-type  =  lst_return-type.
                lst_alv-document = lv_debit .                        " CMR/DMR
                lst_alv-message  = lst_return-message.
                APPEND lst_alv TO i_alv.
                CLEAR lst_alv.
              ENDIF."sy-subrc EQ 0.
*              EOC BY KJAGANA INC0207762
            ENDIF.
            CLEAR lv_salesdocument.
            CLEAR : li_return[],li_orders_in[],li_orders_inx[],li_partners[],li_part_change[].
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
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
             lc_fld_number  TYPE slis_fieldname VALUE 'DOCUMENT',
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

* Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_number  lc_tabname   lv_col_pos  'Document Number'(005)
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
      wait   = lc_wait
    IMPORTING
      return = lst_return.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CMR_DMR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_cmr_dmr USING fp_lv_doc_type TYPE auart.
  DATA : lv_price_group TYPE konda_auft.
  CONSTANTS: lc_devid  TYPE zdevid VALUE 'E131'. " Development ID
  CLEAR : lv_price_group.
*--*Get the price group from refernce
  READ TABLE i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = lst_input_tmp-vbeln
                                                   posnr = lst_input_tmp-posnr
                                                   BINARY SEARCH.
  IF sy-subrc EQ 0 AND lst_vbrp-konda_auft IS INITIAL.
*--* when there is no price group at ref.document then get it from constant table
    READ TABLE i_constant INTO DATA(lst_constant) WITH KEY devid = lc_devid
                                                           param1 = 'PRICE_GROUP'.
    IF sy-subrc EQ 0.
      lv_price_group = lst_constant-low.
    ENDIF.
  ENDIF.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '0101'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VBAK-AUART'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=COPY'.
  PERFORM bdc_field       USING 'VBAK-AUART'
                                fp_lv_doc_type.
  PERFORM bdc_dynpro      USING 'SAPLV45C' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=RUEF'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VBRK-VBELN'.
  PERFORM bdc_field       USING 'VBRK-VBELN'
                                lst_input_tmp-vbeln.
  PERFORM bdc_dynpro      USING 'SAPLV60P' '4413'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VDICS-VBELN'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=MKLO'.
  PERFORM bdc_dynpro      USING 'SAPLV60P' '4413'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VDICS-VBELN'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=POPO'.
  PERFORM bdc_dynpro      USING 'SAPLV60P' '0251'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RV45A-POSNR'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=POSI'.
  PERFORM bdc_field       USING 'RV45A-POSNR'
                                lst_input_tmp-posnr.
  PERFORM bdc_dynpro      USING 'SAPLV60P' '4413'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VDICS-POSNR(01)'.

  PERFORM bdc_dynpro      USING 'SAPLV60P' '4413'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VDICS-VBELN'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=RUEB'.

  PERFORM bdc_dynpro      USING 'SAPLV60P' '4413'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'VDICS-VBELN'.

  PERFORM bdc_field       USING 'RV60A-SELKZ(01)'
                                'X'.

  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=RUEB'.
  PERFORM bdc_dynpro      USING 'SAPMV45A' '4001'.
*  PERFORM bdc_field       USING 'VBAK-FAKSK'
*                                 '01'.
  IF lv_price_group IS NOT INITIAL.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                   '=ITEM'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RV45A-MABNR(01)'.
    PERFORM bdc_dynpro      USING 'SAPMV45A' '4003'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=T\02'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                              'VBAP-ZMENG'.
    PERFORM bdc_dynpro      USING 'SAPMV45A' '4003'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                   'VBKD-KONDA'.
    PERFORM bdc_field       USING 'VBKD-KONDA'
                                  lv_price_group.
  ENDIF.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=SICH'.
  PERFORM bdc_transaction USING 'VA01' fp_lv_doc_type.
  REFRESH bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1826   text
*      -->P_1827   text
*----------------------------------------------------------------------*
FORM bdc_dynpro  USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1831   text
*      -->P_1832   text
*----------------------------------------------------------------------*
FORM bdc_field  USING  fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1971   text
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode fp_lv_doc_type TYPE auart.
  DATA : li_messtab  TYPE STANDARD TABLE OF bdcmsgcoll,
         lst_messtab TYPE bdcmsgcoll,
         lv_mode     TYPE ctu_mode VALUE 'N',
         lv_update   TYPE ctu_update VALUE 'S',
         lst_alv     TYPE ty_alv.

  REFRESH li_messtab.
  CALL FUNCTION 'ENQUEUE_EVVBRKE'
    EXPORTING
      mode_vbrk      = 'E'
      mandt          = sy-mandt
      vbeln          = lst_input_tmp-vbeln
      x_vbeln        = ' '
      _scope         = '2'
      _wait          = 'X'
      _collect       = ' '
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : li_messtab[].
  CALL TRANSACTION tcode USING bdcdata
                   MODE   lv_mode
                   UPDATE lv_update
                   MESSAGES INTO li_messtab.

  CALL FUNCTION 'DEQUEUE_EVVBRKE'
    EXPORTING
      mode_vbrk = 'E'
      mandt     = sy-mandt
      vbeln     = lst_input_tmp-vbeln
      x_vbeln   = ' '
      _scope    = '3'
      _synchron = ' '
      _collect  = ' '.

  LOOP AT li_messtab INTO lst_messtab.
    IF lst_messtab-msgtyp NE 'I'.
      IF lst_messtab-msgnr = 205 AND lst_messtab-msgtyp = 'S'.
        CONTINUE.
      ENDIF.
      lst_alv-vbeln = lst_input_tmp-vbeln.
      lst_alv-posnr =  lst_input_tmp-posnr.
      lst_alv-auart =  fp_lv_doc_type.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = lst_messtab-msgid
          lang      = '-D'
          no        = lst_messtab-msgnr
          v1        = lst_messtab-msgv1
          v2        = lst_messtab-msgv2
          v3        = lst_messtab-msgv3
          v4        = lst_messtab-msgv4
        IMPORTING
          msg       = lst_alv-message
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      lst_alv-type  =  lst_messtab-msgtyp.
      IF lst_messtab-msgtyp = 'S' AND lst_messtab-msgnr = 311.
        lst_alv-document = lst_messtab-msgv2.
        IF fp_lv_doc_type = lc_debit.
          lv_debit = lst_messtab-msgv2.
        ELSE.
          lv_credit = lst_messtab-msgv2.
        ENDIF.
      ENDIF.
      APPEND lst_alv TO i_alv.
      CLEAR lst_alv.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SIMULATE_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_simulate_order .
  DATA : lv_credit_memo    TYPE bapivbeln-vbeln, " Sales Document
         lst_sales_hdr_in  TYPE bapisdhd1,  " Communication Fields: Sales and Distribution Document Header
         lst_sales_hdr_inx TYPE bapisdhd1x, " Checkbox Fields for Sales and Distribution Document Header
         lst_sales_itm     TYPE bapisditm,  " Communication Fields: Sales and Distribution Document Item
         lst_sales_itmx    TYPE bapisditmx, " Communication Fields: Sales and Distribution Document Item
         lst_alv           TYPE ty_alv,
         lv_pstyn          TYPE pstyv_nach,
         li_vbap           TYPE STANDARD TABLE OF vbap,
         lst_sales_partn   TYPE bapiparnr,  " Communications Fields: SD Document Partner: WWW
         li_sales_itm      TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
         li_sales_partn    TYPE STANDARD TABLE OF bapiparnr,  " Communications Fields: SD Document Partner: WWW
         li_sales_itmx     TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
         li_return         TYPE STANDARD TABLE OF bapiret2. " Return Parameter

  CLEAR lv_error.

  READ TABLE i_vbrk INTO DATA(lst_vbrk) WITH KEY vbeln = lst_input_tmp-vbeln
                                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_sales_hdr_in-doc_type = lc_credit.
    lst_sales_hdr_in-sales_org = lst_vbrk-vkorg.
    lst_sales_hdr_in-distr_chan = lst_vbrk-vtweg.
    lst_sales_hdr_in-division = lst_vbrk-spart.

    lst_sales_hdr_inx-doc_type = abap_true.
    lst_sales_hdr_inx-sales_org = abap_true.
    lst_sales_hdr_inx-distr_chan = abap_true.
    lst_sales_hdr_inx-division = abap_true.
    READ TABLE i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = lst_input_tmp-vbeln
                                                   posnr = lst_input_tmp-posnr
                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      SELECT SINGLE pstyn FROM tvcpa INTO lv_pstyn WHERE auarn = lc_credit
                                                     AND fkarv = 'ZF2'
                                                     AND pstyv = lst_vbrp-pstyv.
      IF sy-subrc EQ 0.
        lst_sales_itm-item_categ = lv_pstyn.
        lst_sales_itmx-item_categ = abap_true.
      ENDIF.
      lst_sales_itm-itm_number = lst_vbrp-posnr.
      lst_sales_itm-material = lst_vbrp-matnr.
      lst_sales_itm-target_qty = lst_vbrp-fkimg.
*      lst_sales_itm-serv_date = lst_vbrp-prsdt.
      lst_sales_itm-ref_doc = lst_vbrp-vbeln.
      lst_sales_itm-ref_doc_it = lst_vbrp-posnr.
      APPEND lst_sales_itm TO li_sales_itm.
      CLEAR : lst_sales_itm.
      lst_sales_itmx-itm_number = lst_vbrp-posnr.
      lst_sales_itmx-material = abap_true.
      lst_sales_itmx-target_qty = abap_true.
*      lst_sales_itmx-serv_date = abap_true.
      lst_sales_itmx-ref_doc = abap_true.
      lst_sales_itmx-ref_doc_it = abap_true.
      APPEND lst_sales_itmx TO li_sales_itmx.
      CLEAR : lst_sales_itmx.

      READ TABLE i_vbfa INTO DATA(lst_vbfa) WITH KEY vbeln = lst_input_tmp-vbeln
                                                     posnn = lst_input_tmp-posnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT i_vbpa INTO DATA(lst_vbpa) WHERE vbeln = lst_vbfa-vbelv
                                            AND  ( posnr = lst_vbfa-posnv OR posnr = '000000')
                                            .
          IF lst_vbpa-kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lst_vbpa-parvw.
            lst_sales_partn-partn_numb = lst_vbpa-kunnr.
            lst_sales_partn-itm_number = lst_vbpa-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.


  CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
    EXPORTING
      sales_header_in  = lst_sales_hdr_in
      sales_header_inx = lst_sales_hdr_inx
      testrun          = abap_true
    IMPORTING
      salesdocument_ex = lv_credit_memo
    TABLES
      return           = li_return
      sales_items_in   = li_sales_itm
      sales_items_inx  = li_sales_itmx
      sales_partners   = li_sales_partn.

  LOOP AT li_return INTO DATA(lst_return) WHERE type = 'E' OR type = 'A'.
    lst_alv-vbeln = lst_input_tmp-vbeln.
    lst_alv-posnr =  lst_input_tmp-posnr.
    lst_alv-auart = lc_credit.
    lst_alv-type = lst_return-type.
    lst_alv-message = lst_return-message.
    APPEND lst_alv TO i_alv.
    CLEAR lst_alv.
    lv_error = abap_true.
  ENDLOOP.
  IF lv_error IS INITIAL.
    lst_sales_hdr_in-doc_type = lc_debit.
    SELECT SINGLE pstyn FROM tvcpa INTO lv_pstyn WHERE auarn = lc_debit
                                                      AND fkarv = 'ZF2'
                                                      AND pstyv = lst_vbrp-pstyv.
    IF sy-subrc EQ 0.
      lst_sales_itm-item_categ = lv_pstyn.
      lst_sales_itmx-item_categ = abap_true.
      MODIFY li_sales_itm FROM lst_sales_itm INDEX 1 TRANSPORTING item_categ .
      MODIFY li_sales_itmx FROM lst_sales_itmx INDEX 1 TRANSPORTING item_categ .
    ENDIF.
    IF lst_input_tmp-nsrep1 IS  NOT INITIAL.
      lst_sales_partn-partn_role = lc_parvw_ve.
      lst_sales_partn-partn_numb = lst_input_tmp-nsrep1.
      lst_sales_partn-itm_number = lst_input_tmp-posnr.
      APPEND lst_sales_partn TO li_sales_partn.
      CLEAR lst_sales_partn.
    ENDIF.
    IF lst_input_tmp-nsrep2 IS  NOT INITIAL.
      lst_sales_partn-partn_role = lc_parvw_ze.
      lst_sales_partn-partn_numb = lst_input_tmp-nsrep2.
      lst_sales_partn-itm_number = lst_input_tmp-posnr.
      APPEND lst_sales_partn TO li_sales_partn.
      CLEAR lst_sales_partn.
    ENDIF.
    CLEAR : li_return.
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in  = lst_sales_hdr_in
        sales_header_inx = lst_sales_hdr_inx
        testrun          = abap_true
      IMPORTING
        salesdocument_ex = lv_credit_memo
      TABLES
        return           = li_return
        sales_items_in   = li_sales_itm
        sales_items_inx  = li_sales_itmx
        sales_partners   = li_sales_partn.

    LOOP AT li_return INTO DATA(lst_return2) WHERE type = 'E' OR type = 'A'.
      lst_alv-vbeln = lst_input_tmp-vbeln.
      lst_alv-posnr =  lst_input_tmp-posnr.
      lst_alv-auart = lc_debit.
      lst_alv-type = lst_return2-type.
      lst_alv-message = lst_return2-message.
      APPEND lst_alv TO i_alv.
      CLEAR lst_alv.
      lv_error = abap_true.
    ENDLOOP.
  ENDIF.
ENDFORM.
