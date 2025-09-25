*----------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_PRO_F00
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_ORDER_PROFORMA_F501
* REPORT DESCRIPTION:    Driver Program for order proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Jagadeeswara Rao M (JMADAKA)
* CREATION DATE:         02-May-2022
* OBJECT ID:             F501
* TRANSPORT NUMBER(S):   ED2K927138
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing.
*******Local Constant Declaration
  CONSTANTS: lc_05 TYPE na_nacha VALUE '5', "Message transmission medium
             lc_07 TYPE na_nacha VALUE '7'. "Message transmission medium

  CONSTANTS: lc_zapi TYPE sna_kschl VALUE 'ZAPI'. " Message type

  PERFORM f_clear_variable.

* Perform to populate Wiley Logo
  PERFORM f_get_wiley_logo     CHANGING  v_xstring.

* Perform to populate sales data from NAST table
**  nast-spras = 'E'.
  PERFORM f_get_bill_data           USING     nast
                                    CHANGING  st_vbco3.

  PERFORM f_get_constants  CHANGING i_constant
                                    r_mtart_med_issue
                                    i_tax_id.

  PERFORM f_get_stxh_data USING    v_langu
                          CHANGING i_std_text.

*  Perform to fetch data
  PERFORM f_get_data      USING               st_vbco3
                               CHANGING            i_vbpa
                                                   lst_vbrk
                                                   li_vbrp
                                                   st_header
                                                   st_address
                                                   st_calc
                                                   i_final
                                                   i_jptidcdassign
                                                   li_bill_to_address
                                                   li_ship_to_address.

  DELETE i_final WHERE identcode = space.
**IF v_comm_meth EQ c_comm_method. "LET
  IF nast-kschl EQ lc_zapi.
*     Print Preview
    PERFORM f_adobe_prnt_zapi.
  ENDIF.
**  ENDIF. " IF v_comm_meth EQ c_comm_method
  v_output_typ = nast-kschl.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_WILEY_LOGO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_XSTRING  text
*----------------------------------------------------------------------*
FORM f_get_wiley_logo  CHANGING fp_v_xstring TYPE xstring.
*******Local constant declaration
  CONSTANTS : lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
              lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
              lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
              lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

******To Get a BDS Graphic in BMP Format (Using a Cache)
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
  IF sy-subrc = 0.
* No need to raise the messages, Form will be printed
* without the logo
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_BAPI_VIEW  text
*----------------------------------------------------------------------*
FORM f_get_bill_data       USING    fp_nast     TYPE nast   " Message Status
                           CHANGING fp_st_vbco3 TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing

  fp_st_vbco3-mandt = sy-mandt.
  fp_st_vbco3-spras = fp_nast-spras.
  fp_st_vbco3-vbeln = fp_nast-objky+0(10).
  fp_st_vbco3-posnr = fp_nast-objky+10(6).
  fp_st_vbco3-kunde = fp_nast-parnr.
  fp_st_vbco3-parvw = fp_nast-parvw.
  v_langu = fp_nast-spras.

  TABLES: vbrp, " Billing Document: Item Data
          mara. " General Material Data
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBCO3  text
*      <--P_ST_VBAP  text
*----------------------------------------------------------------------*
FORM f_get_data  USING    fp_st_vbco3       TYPE vbco3              " Sales Doc.Access Methods: Key Fields: Document Printing
                      CHANGING fp_i_vbpa         TYPE tt_vbpa
                               fp_lst_vbrk TYPE ty_vbrk
                               fp_li_vbrp TYPE tt_vbrp
                               fp_st_header      TYPE zstqtc_header_f501 " Header Structure for Quotation
                               fp_st_address     TYPE zstqtc_add_f027    " Structure for address node
                               fp_st_calc        TYPE zstqtc_calc_f501        " Structure for Calculation
                               fp_i_final        TYPE zttqtc_item_f501
                               fp_i_jptidcdassign        TYPE tt_jptidcdassign
                               fp_li_bill_to_address TYPE zttqtc_address_line_f501
                               fp_li_ship_to_address TYPE zttqtc_address_line_f501.

******Local Data declaration
  DATA: lst_final     TYPE zstqtc_item_f501,        " Structure for item data
        lv_disc       TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
        lv_total_pf   TYPE kwert,                   " Condition value
        lv_disc_char  TYPE char20,                  " Disc_char of type CHAR20
        lv_day        TYPE char2,                   " Date of type CHAR2
        lv_month_c2   TYPE char2,                   " Mnthc2 of type CHAR2
        lv_month_c3   TYPE char3,                   " Mnthc3 of type CHAR3
        lv_month      TYPE t247-ltx,                " Month long text
        lv_year       TYPE char4,                   " Year of type CHAR4
        lv_datum      TYPE char15,                  " renewal date of char 15
        li_lines      TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines     TYPE tline,                   " Lines of text read
        lv_unit_price TYPE kzwi1.                   " Subtotal 1 from pricing procedure for condition

*******Local constant declaration
  CONSTANTS: lc_we     TYPE parvw          VALUE 'WE',         " Ship to address
             lc_re     TYPE parvw          VALUE 'RE',         " Ship to address
             lc_hyphen TYPE char01         VALUE '-',          "Constant for hyphen
             lc_id     TYPE thead-tdid     VALUE '0001',       "Text ID of text to be read
             lc_object TYPE thead-tdobject VALUE 'VBBP',       "Object of text to be read
             lc_sign   TYPE tvarv_sign     VALUE 'I',          " ABAP: ID: I/E (include/exclude values)
             lc_op     TYPE tvarv_opti     VALUE 'EQ',         " ABAP: Selection option (EQ/BT/CP/...)
             lc_b      TYPE char1          VALUE '(',          " B of type CHAR1
             lc_bb     TYPE char1          VALUE ')',          " Bb of type CHAR1
             lc_st     TYPE thead-tdid     VALUE 'ST',    "Text ID of text to be read
             lc_text   TYPE thead-tdobject VALUE 'TEXT',  "Object of text to be read
             lc_zean   TYPE ismidcodetype VALUE 'ZEAN'. " Type of Identification Code

  TYPES : BEGIN OF ty_tkomv,
            knumv TYPE konv-knumv, " Number of the document condition
            kposn TYPE konv-kposn, " Condition item number
            kschl TYPE konv-kschl,
            stunr TYPE konv-stunr, " Step number
            zaehk TYPE konv-zaehk, " Condition counter
            kappl TYPE konv-kappl, " Application
            kawrt TYPE kawrt,      " Condition base value
            kbetr TYPE konv-kbetr, " Rate (condition amount or percentage)
            waers TYPE konv-waers, " Currency Key
            kwert TYPE konv-kwert,
            koaid TYPE konv-koaid, " Condition class
          END OF ty_tkomv.



  DATA: li_tkomv            TYPE STANDARD TABLE OF ty_tkomv, " Pricing Communications-Condition Record
        li_tkomvd           TYPE STANDARD TABLE OF komvd,    " Price Determination Communication-Cond.Record for Printing
        li_vbap_tmp         TYPE tt_vbap,
        li_vbap_tmp1        TYPE tt_vbap,
        li_vbap_tmp2        TYPE tt_vbap,
        lst_komk            TYPE komk,         " Communication Header for Pricing
        lst_komp            TYPE komp,         " Communication Item for Pricing
        lv_kbetr_desc       TYPE p DECIMALS 3, "kbetr,                      " Rate (condition amount or percentage)
*        lv_kbetr_3dec       TYPE p DECIMALS 3,
        lv_kbetr_char       TYPE char25,       " Kbetr_char of type CHAR15
        lv_year_1           TYPE char30,       " Year
        lv_year_2           TYPE char30,       " Year_2 of type CHAR30
        lv_cntr_end         TYPE char30,       " Year_2 of type CHAR30
        lv_cntr_month       TYPE char30,       " Year_2 of type CHAR30
        lv_cntr             TYPE char30,       " Year_2 of type CHAR30
        lv_day1(2)          TYPE c,            " Year_2 of type CHAR30
        lv_month1(2)        TYPE c,            " Year_2 of type CHAR30
        lv_year2(4)         TYPE c,            " Year_2 of type CHAR30
        lv_stext            TYPE t247-ktx,     " Year_2 of type CHAR30
        lv_ltext            TYPE t247-ltx,     " Year_2 of type CHAR30
        lv_volum            TYPE char30,       " Volume
        lv_vol              TYPE char8,        " Volume
        lv_flag_di          TYPE char1,        " Flag_di of type CHAR1
        lv_flag_ph          TYPE char1,        " Flag_ph of type CHAR1
        lv_issue            TYPE char30,       " Issue
        lv_name             TYPE thead-tdname, " Name
        lv_bhf              TYPE char1,        " Bhf of type CHAR1
        lv_lcf              TYPE char1,        " Lcf of type CHAR1
        lv_noiv             TYPE char3,        " Noiv of type CHAR3
        lv_noit             TYPE char30,       " Noit of type CHAR30
        lv_name_issn        TYPE thead-tdname, " Name
        lv_all_des          TYPE char255,      " All_des of type CHAR255
        lv_noi_des          TYPE char255,      " Noi_des of type CHAR255
        lv_year_des         TYPE char255,      " Year_des of type CHAR255
        lv_vol_des          TYPE char255,      " Vol_des of type CHAR255
        lv_issue_des        TYPE char255,      " Issue_des of type CHAR255
        lst_jptidcdassign1  TYPE ty_jptidcdassign,
        lv_identcode_zjcd   TYPE char20,       " Identcode of type CHAR20
        lv_line             TYPE sytabix,      " Row Index of Internal Tables
        lv_pay_term         TYPE dzterm_bez,   " Description of terms of payment
        lv_iss              TYPE ismnrimjahr,  " Issue Number (in Year Number)
        lv_mlsub            TYPE char30,       " Issue
        lv_identcode        TYPE char20, " Identcode of type CHAR20
        lv_pnt_issn         TYPE char30, "char10," Print ISSN ++ SAYANDAS
        lv_subscription_typ TYPE char100, " Subscription_typ of type CHAR100
        lv_sub_ref_id       TYPE char100, " Sub Ref ID
        lv_mat_text         TYPE string,
        lv_tdname           TYPE thead-tdname, " Name
        lv_posnr            TYPE posnr,        " Subtotal 2 from pricing procedure for condition
        lv_issue_desc       TYPE tdline,               " Text Line
        lst_tax_item        TYPE ty_tax_item,
        li_tax_item         TYPE tt_tax_item,
        lv_kbetr            TYPE kbetr,                " Rate (condition amount or percentage)
        lv_tax_amount       TYPE p DECIMALS 3,         " Subtotal 6 from pricing procedure for condition
        lv_tax              TYPE kzwi6,                " Tax
        lv_tax_bom          TYPE kzwi6,                " Subtotal 6 from pricing procedure for condition
        lv_amnt             TYPE kzwi1,                " Subtotal 1 from pricing procedure for condition
        lst_tax_item_final  TYPE zstqtc_sub_item_f027, " Structure for tax components
        lst_vbeln           TYPE vbak, "Sales Document
        lt_vbpa_ff          TYPE vbpa_tab,       " Frighet Forwarder
        lv_ff_flag(1)       TYPE c,
        lv_multiple         TYPE c,
        lv_total_val        TYPE kzwi6,
        lv_freight          TYPE kwert.
*  Constant Declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000',                        " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.

  DATA: lst_vbap    TYPE ty_vbap,
        lst_vbpa    TYPE ty_vbpa,
        lv_kunnr_za TYPE kunnr. " Customer Number

  TYPES: BEGIN OF lty_printform_table_line,
           line_type    TYPE ad_line_tp,
           address_line LIKE adrs-line0,
         END OF lty_printform_table_line,
         tt_printform_table_line TYPE TABLE OF lty_printform_table_line.
  DATA: li_bill_to_address_print TYPE TABLE OF lty_printform_table_line,
        li_ship_to_address_print TYPE TABLE OF lty_printform_table_line.
  CLEAR: lst_final,
         fp_i_final.
  CONDENSE: v_tax.

  IF st_address-adrnr_bp IS NOT INITIAL.
    SELECT deflt_comm " Communication Method (Key) (Business Address Services)
      FROM adrc       " Addresses (Business Address Services)
      INTO @DATA(lv_comm_method)
      UP TO 1 ROWS
      WHERE  addrnumber EQ @st_address-adrnr_bp.
    ENDSELECT.
    IF sy-subrc EQ 0.
      v_comm_meth = lv_comm_method.
    ENDIF.
  ENDIF.

* Retrieve billing document data from VBRK table
  SELECT SINGLE
         vbeln " Billing Document
         fkart " Billing Type
         vbtyp " SD document category
         waerk " SD Document Currency
         vkorg " Sales Organization
         knumv " Number of the document condition
         fkdat " Billing date for billing index and printout
         zterm " Terms of Payment Key
         zlsch " Payment Method
         land1 " Country of Destination
         bukrs " Company Code
         netwr " Net Value in Document Currency
         erdat " Date on Which Record Was Created
         kunrg " Payer
         kunag " Sold-to party
         zuonr " Assignment number
         rplnr " Number of payment card plan type
         sfakn " Cancelled billing document number
         bstnk_vf "PO NUmber
    INTO fp_lst_vbrk
    FROM vbrk  " Billing Document: Header Data
    WHERE vbeln EQ fp_st_vbco3-vbeln.
  IF sy-subrc = 0.

***Fetch data from VBKD and VBFA
    SELECT   p~vbeln             " Sales and Distribution Document Number
             p~posnr             " Item number of the SD document
             p~parvw             " Partner Function
             p~kunnr             " Customer Number
             p~adrnr             " Address
             p~land1             " Country Key
             h~vbelv             " Preceding sales and distribution document
             h~posnv             " Preceding item of an SD document
             h~posnn             " Subsequent item of an SD document
             h~vbtyp_n           " Document category of subsequent document
             h~vbtyp_v           " Document category of preceding SD document
             m~posnr AS line_num "Line item of VBKD table
             m~zterm
             m~zlsch
             m~bstkd " Customer purchase order number
             m~bsark "Customer purchase order type
             m~ihrez " Your Reference
        FROM vbpa AS p
        LEFT OUTER JOIN vbfa AS h ON
        p~vbeln EQ h~vbeln
       LEFT OUTER JOIN vbkd AS m ON
        p~vbeln EQ m~vbeln
        INTO TABLE fp_i_vbpa
    WHERE p~vbeln = fp_st_vbco3-vbeln.
    IF sy-subrc IS INITIAL.
      SORT fp_i_vbpa BY vbeln parvw.
    ENDIF.
* Fetch Item data from VBRP table.
    SELECT  vbeln " Billing Document
            posnr " Billing item
            uepos
            fkimg " Actual Invoiced Quantity
            meins " Base Unit of Measure
            vgbel
            vgpos
            aubel      " Sales Document
            aupos      " Sales Document Item
            matnr      " Material Number
            arktx      " Short text for sales order item
            pstyv      " Sales document item category
            werks      " Plant
            vkgrp      " Sales Group
            vkbur      " Sales Office
            kzwi1      " Subtotal 1 from pricing procedure for condition
            kzwi2      " Subtotal 2 from pricing procedure for condition
            kzwi3      " Subtotal 3 from pricing procedure for condition
            kzwi4      " Subtotal 4 from pricing procedure for condition
            kzwi5      " Subtotal 5 from pricing procedure for condition
            kzwi6      " Subtotal 6 from pricing procedure for condition
            kvgr1      " Customer group 1er group 1
            aland      " Departure country (country from which the goods are sent)
            lland_auft " Country of destination of sales order
            kowrr " Statistical values
            fareg " Rule in billing plan/invoice plan
             kdkg2 " Customer condition group 2
            netwr " Net value of the billing item in document currency
             mvgr4
            mvgr5
            vkorg_auft " Sales Org
            abrbg  "settlement period
      INTO TABLE fp_li_vbrp
      FROM vbrp " Billing Document: Item Data
      WHERE vbeln EQ fp_lst_vbrk-vbeln.
    IF sy-subrc = 0.
      SORT fp_li_vbrp BY vgbel vgpos.
      DATA(li_vbrp_tmp) = fp_li_vbrp[].
      DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp COMPARING vgbel vgpos.

      IF li_vbrp_tmp[] IS NOT INITIAL.
        DATA(li_vbrp) = li_vbrp_tmp[].
        SORT li_vbrp BY matnr.
        DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING matnr.
* Fetch ID codes of material from JPTIDCDASSIGN table
        SELECT matnr         " Material Number
               idcodetype    " Type of Identification Code
               identcode     " Identification Code
          FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
          INTO TABLE fp_i_jptidcdassign
          FOR ALL ENTRIES IN li_vbrp
          WHERE matnr      EQ li_vbrp-matnr
            AND idcodetype EQ lc_zean.
        IF sy-subrc EQ 0.
          SORT fp_i_jptidcdassign BY matnr.
        ENDIF. " IF sy-subrc EQ 0
        CLEAR li_vbrp[].

*******Fetch DATA from KONV table:Conditions (Transaction Data)
        SELECT knumv "Number of the document condition
               kposn "Condition item number
               kschl
               stunr "Step number
               zaehk "Condition counter
               kappl" Application
               kawrt "Condition base value
               kbetr "Rate (condition amount or percentage)
               waers
               kwert "Condition value
               koaid  "Condition class
          FROM konv   "Conditions (Transaction Data)
          INTO TABLE li_tkomv
          WHERE knumv = fp_lst_vbrk-knumv
            AND kinak = ''
          ORDER BY knumv kposn.
        IF sy-subrc IS INITIAL.
          SORT li_tkomv BY knumv kposn.
        ENDIF.


*** Populate Header data
        CLEAR fp_st_header.
        SELECT SINGLE vtext " Description of terms of payment
                INTO lv_pay_term
                FROM tvzbt        " Customers: Terms of Payment Texts
                WHERE spras EQ v_langu
                AND zterm EQ fp_lst_vbrk-zterm.
        IF sy-subrc = 0.
          fp_st_header-pay_terms = lv_pay_term.
        ENDIF.

*Population of Date field.
*-------FM to change the date format to DD_MMM_YYYY------------------*
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = sy-datum
          IMPORTING
            day                           = lv_day
            month                         = lv_month_c2
            year                          = lv_year
            ltext                         = lv_month
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.
        IF sy-subrc = 0.
          lv_month_c3 = lv_month(3).
          CONCATENATE lv_day lv_month_c3 lv_year INTO lv_datum SEPARATED BY lc_hyphen.
          fp_st_header-date_rec = lv_datum.
        ENDIF.

*Populate PO Number
        fp_st_header-po_num = lst_vbrk-bstnk_vf.
* Populate Our Tax ID
        SELECT SINGLE seller_reg
                      FROM /idt/d_tax_data
                      INTO fp_st_header-seller_reg
                      WHERE company_code = fp_lst_vbrk-bukrs
                      AND fiscal_year = lc_gjahr
                      AND   document_type = lc_doc_type
                      AND document = fp_lst_vbrk-vbeln
                      AND doc_line_number IS NOT NULL
                      AND doc_tax_number IS NOT NULL
                      AND inv_count IS NOT NULL
                      AND statistical IS NOT NULL.
        IF sy-subrc <> 0.
          CLEAR fp_st_header-seller_reg.
        ENDIF.

* Populate Your Tax ID
        SELECT SINGLE buyer_reg
                      FROM /idt/d_tax_data
                      INTO fp_st_header-buyer_reg
                      WHERE company_code = fp_lst_vbrk-bukrs
                      AND fiscal_year = lc_gjahr
                      AND   document_type = lc_doc_type
                      AND document = fp_lst_vbrk-vbeln
                      AND doc_line_number IS NOT NULL
                      AND doc_tax_number IS NOT NULL
                      AND inv_count IS NOT NULL
                      AND statistical IS NOT NULL.
        IF sy-subrc <> 0.
          CLEAR fp_st_header-buyer_reg.
        ENDIF.

*Read the local internal table to fetch the customer number,
*address number and country key by passing Partner Function
*as RE because for Bill-To-Party if we pass BP it has been
*converted to RE. So RE has been used to populate Bill-To-Party address
*------------------------------------------------------------------------*
        CLEAR lst_vbpa.
        READ TABLE fp_i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                                      parvw = lc_re
                                             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
*Populate address table
          fp_st_address-kunnr_bp = lst_vbpa-kunnr. "Customer Number
          fp_st_address-adrnr_bp = lst_vbpa-adrnr. "Address Number
          fp_st_address-land1_bp = lst_vbpa-land1. "Country key

*** Populate address
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = fp_st_address-adrnr_bp
              number_of_lines                = 6
            IMPORTING
              address_printform_table        = li_bill_to_address_print
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc = 0.
            DELETE li_bill_to_address_print WHERE line_type = '5'.
            IF li_bill_to_address_print[] IS NOT INITIAL.
              LOOP AT li_bill_to_address_print INTO DATA(lst_bill_to_address).
                APPEND INITIAL LINE TO fp_li_bill_to_address ASSIGNING FIELD-SYMBOL(<fs_bill_to_address>).
                IF <fs_bill_to_address> IS ASSIGNED.
                  <fs_bill_to_address>-address_line = lst_bill_to_address-address_line.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.


        ENDIF.

        CLEAR: lst_vbpa.
        READ TABLE fp_i_vbpa INTO lst_vbpa WITH KEY vbeln = fp_st_vbco3-vbeln
                                                  parvw = lc_we
                                                  BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          fp_st_address-kunnr_we = lst_vbpa-kunnr. "Customer Number
          fp_st_address-adrnr_we = lst_vbpa-adrnr. "Address Number
          fp_st_address-land1_we = lst_vbpa-land1. "Country key

*** Populate address
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = fp_st_address-adrnr_we
              number_of_lines                = 6
            IMPORTING
              address_printform_table        = li_ship_to_address_print
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc = 0.
            DELETE li_ship_to_address_print WHERE line_type = '5'.
            IF li_ship_to_address_print[] IS NOT INITIAL.
              LOOP AT li_ship_to_address_print INTO DATA(lst_ship_to_address).
                APPEND INITIAL LINE TO fp_li_ship_to_address ASSIGNING FIELD-SYMBOL(<fs_ship_to_address>).
                IF <fs_ship_to_address> IS ASSIGNED.
                  <fs_ship_to_address>-address_line = lst_ship_to_address-address_line.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.

        ENDIF.

        SET COUNTRY fp_st_address-land1_bp.


*** Populate Item details
        LOOP AT fp_li_vbrp INTO DATA(lst_vbrp).

          APPEND INITIAL LINE TO fp_i_final ASSIGNING FIELD-SYMBOL(<fs_final>).
          IF <fs_final> IS ASSIGNED.

*** ISBN
            <fs_final>-identcode = VALUE #( fp_i_jptidcdassign[ matnr = lst_vbrp-matnr ]-identcode OPTIONAL ).

*** Quantity
            <fs_final>-qty = lst_vbrp-fkimg.
            CONDENSE <fs_final>-qty.

*** Unit price
            lv_unit_price = lst_vbrp-kzwi1 / lst_vbrp-fkimg.
            WRITE lv_unit_price TO <fs_final>-unit_price CURRENCY fp_lst_vbrk-waerk.
            CONDENSE <fs_final>-qty.

*** Discount
            CLEAR: lv_disc_char,lv_disc.
            lv_disc = lst_vbrp-kzwi5.
            WRITE lv_disc TO lv_disc_char.
            IF lst_vbrp-kzwi5 LT 0.
              CONDENSE lv_disc_char.
              <fs_final>-discount = lv_disc_char.

              CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
                CHANGING
                  value = <fs_final>-discount.
              CONDENSE <fs_final>-discount.
            ELSEIF lst_vbrp-kzwi5 EQ 0.
              <fs_final>-discount = lv_disc_char.
              CONDENSE <fs_final>-discount.
            ENDIF.

*** Tax
            lv_tax = lst_vbrp-kzwi6 + lv_tax.
            IF lv_tax LT 0.
              WRITE lst_vbrp-kzwi6 TO <fs_final>-tax_amount CURRENCY fp_lst_vbrk-waerk.

              CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
                CHANGING
                  value = <fs_final>-tax_amount.
              CONDENSE <fs_final>-tax_amount.
            ELSE.
              WRITE lst_vbrp-kzwi6 TO <fs_final>-tax_amount CURRENCY fp_lst_vbrk-waerk.
              CONDENSE <fs_final>-tax_amount.
            ENDIF.


*** Total
            lv_total_val = lst_vbrp-kzwi3 + lst_vbrp-kzwi6.
            WRITE lv_total_val TO <fs_final>-total CURRENCY fp_lst_vbrk-waerk.
            CONDENSE <fs_final>-total.
*** Freight
            lv_freight = lv_freight + VALUE #( li_tkomv[ kposn = lst_vbrp-posnr kschl = 'ZF01' ]-kwert OPTIONAL ).

          ENDIF.


        ENDLOOP.


        fp_st_calc-waerk = fp_lst_vbrk-waerk.
        fp_st_calc-sub_total  = fp_lst_vbrk-netwr.
        fp_st_calc-taxable = lv_tax.
        lv_total_pf = fp_st_calc-sub_total + lv_tax.
        fp_st_calc-total_due = lv_total_pf.
        fp_st_calc-freight = lv_freight.


      ENDIF.

    ENDIF.
  ENDIF.



*** Populate company address standard text value
  lv_comp_address = VALUE #( i_std_text[ tdname = lc_comp_address ]-tdname OPTIONAL ).
  lv_credit_card = VALUE #( i_std_text[ tdname = lc_credit_card ]-tdname OPTIONAL ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail USING fp_st_vbco3       TYPE vbco3. " Sales Doc.Access Methods: Key Fields: Document Printing
******Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_INV'. " Name of Form Object

  CONSTANTS: lc_zapi           TYPE sna_kschl VALUE 'ZAPI', " Message type
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.    " Communication Method (Key) (Business Address Services)

  IF nast-kschl EQ lc_zapi.
    PERFORM f_adobe_prnt_zapi.
    "JMADAKA
**  ELSEIF nast-kschl EQ lc_zsqs.
**    PERFORM f_adobe_prnt_zsoc.
    "JMADAKA
  ENDIF. " IF nast-kschl EQ lc_zsqt

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_convert_pdf_binary.
*******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = st_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tt_constant
                               fp_r_mtart_med_issue  TYPE fip_t_mtart_range " Material Types: Media Issues
                               fp_i_tax_id   TYPE tt_tax_id.
  CONSTANTS: lc_devid         TYPE zdevid         VALUE 'F501', " Development ID
             lc_sanctioned_c  TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
             lc_vkorg         TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variable
             lc_zlsch         TYPE rvari_vnam VALUE 'ZLSCH', " ABAP: Name of Variant Variable
             lc_cust_group    TYPE rvari_vnam VALUE 'CUST_GROUP',
             lc_mat_grp5      TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
             lc_output_typ    TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
             lc_tax_id        TYPE rvari_vnam VALUE 'TAX_ID',
             lc_document_type TYPE rvari_vnam VALUE 'DOCUMENT_TYPE',
             lc_po_type       TYPE rvari_vnam VALUE 'FTP_BSARK',
             lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE',
             lc_print         TYPE rvari_vnam VALUE 'PRINT_MEDIA_PRODUCT',
             lc_digital       TYPE rvari_vnam VALUE 'DIGITAL_MEDIA_PRODUCT'.

***Fetch from ZCACONSTANT to create a range table for the company code
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         srno        " ABAP: Current selection number
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = lc_devid.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
**    LOOP AT fp_i_constant INTO DATA(lst_constant).
**      IF lst_constant-param1 EQ c_mtart_med_iss. " Material Types: Media Issues
**        APPEND INITIAL LINE TO fp_r_mtart_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
**        <lst_med_issue>-sign   = lst_constant-sign.
**        <lst_med_issue>-option = lst_constant-opti.
**        <lst_med_issue>-low    = lst_constant-low.
**        <lst_med_issue>-high   = lst_constant-high.
**      ENDIF. " IF lst_constant-param1 EQ c_mtart_med_iss

**      IF lst_constant-param1 EQ lc_sanctioned_c.
**        APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
**        <lst_sanc_country>-sign   = lst_constant-sign.
**        <lst_sanc_country>-option = lst_constant-opti.
**        <lst_sanc_country>-low    = lst_constant-low.
**        <lst_sanc_country>-high   = lst_constant-high.
**      ENDIF. " IF lst_constant-param1 EQ lc_sanctioned_c
*** EOC BY SAYANDAS for ERP-6599 on 04-APR-2018 in ED2K911795
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
**      IF lst_constant-param1 EQ lc_vkorg.
**        APPEND INITIAL LINE TO r_vkorg_f044 ASSIGNING FIELD-SYMBOL(<lst_vkorg_f044>).
**        <lst_vkorg_f044>-sign   = lst_constant-sign.
**        <lst_vkorg_f044>-option = lst_constant-opti.
**        <lst_vkorg_f044>-low    = lst_constant-low.
**        <lst_vkorg_f044>-high   = lst_constant-high.
**      ENDIF. " IF lst_constant-param1 EQ lc_vkorg
**      IF lst_constant-param1 EQ lc_zlsch.
**        APPEND INITIAL LINE TO r_zlsch_f044 ASSIGNING FIELD-SYMBOL(<lst_zlsch_f044>).
**        <lst_zlsch_f044>-sign   = lst_constant-sign.
**        <lst_zlsch_f044>-option = lst_constant-opti.
**        <lst_zlsch_f044>-low    = lst_constant-low.
**        <lst_zlsch_f044>-high   = lst_constant-high.
**      ENDIF. " IF lst_constant-param1 EQ lc_zlsch
*** EOC for F044 BY SAYANDAS on 26-JUN-2018
*   Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
**      IF lst_constant-param1 EQ lc_cust_group.
**        APPEND INITIAL LINE TO r_kvgr1_f044 ASSIGNING FIELD-SYMBOL(<lst_kvgr1_f044>).
**        <lst_kvgr1_f044>-sign   = lst_constant-sign.
**        <lst_kvgr1_f044>-option = lst_constant-opti.
**        <lst_kvgr1_f044>-low    = lst_constant-low.
**        <lst_kvgr1_f044>-high   = lst_constant-high.
**      ENDIF. " IF lst_constant-param1 EQ lc_cust_group
*    End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919421
* BOC: CR#7730 KKRAVURI20181012  ED2K913588
**      IF lst_constant-param1 EQ lc_mat_grp5.
**        APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
**        <lst_mat_grp5>-sign   = lst_constant-sign.
**        <lst_mat_grp5>-option = lst_constant-opti.
**        <lst_mat_grp5>-low    = lst_constant-low.
**        <lst_mat_grp5>-high   = lst_constant-high.
**      ENDIF.
**      IF lst_constant-param1 EQ lc_output_typ.
**        APPEND INITIAL LINE TO r_output_typ ASSIGNING FIELD-SYMBOL(<lst_output_typ>).
**        <lst_output_typ>-sign   = lst_constant-sign.
**        <lst_output_typ>-option = lst_constant-opti.
**        <lst_output_typ>-low    = lst_constant-low.
**        <lst_output_typ>-high   = lst_constant-high.
**      ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913588
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*      IF lst_constant-param1 EQ lc_tax_id.
*        v_tax_id    = lst_constant-low.
*      ENDIF.
**      IF lst_constant-param1 EQ lc_tax_id. " TAX IDs
**        APPEND INITIAL LINE TO fp_i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>).
**        <lst_tax_id>-land1 = lst_constant-param2.
**        <lst_tax_id>-stceg = lst_constant-low.
**      ENDIF. " IF lst_constant-param1 EQ lc_tax_id
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
**      IF lst_constant-param1 EQ lc_document_type.
**        APPEND INITIAL LINE TO r_document_type ASSIGNING FIELD-SYMBOL(<lst_document_type>).
**        <lst_document_type>-sign   = lst_constant-sign.
**        <lst_document_type>-option = lst_constant-opti.
**        <lst_document_type>-low    = lst_constant-low.
**        <lst_document_type>-high   = lst_constant-high.
**      ENDIF.
*- End of ERPM-17190:SGUDA:17-JUNE-2020:ED2K918549
*- Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
**      IF lst_constant-param1 EQ lc_po_type.
**        APPEND INITIAL LINE TO r_po_type ASSIGNING FIELD-SYMBOL(<lst_po_type>).
**        <lst_po_type>-sign   = lst_constant-sign.
**        <lst_po_type>-option = lst_constant-opti.
**        <lst_po_type>-low    = lst_constant-low.
**        <lst_po_type>-high   = lst_constant-high.
**      ENDIF.
*- End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913618
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
**      IF lst_constant-param1 EQ lc_comp_code.
**        APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
**        <lst_comp_code>-sign   = lst_constant-sign.
**        <lst_comp_code>-option = lst_constant-opti.
**        <lst_comp_code>-low    = lst_constant-low.
**        <lst_comp_code>-high   = lst_constant-high.
**      ENDIF.
**      IF lst_constant-param1 EQ lc_docu_currency.
**        APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
**        <lst_docu_currency>-sign   = lst_constant-sign.
**        <lst_docu_currency>-option = lst_constant-opti.
**        <lst_docu_currency>-low    = lst_constant-low.
**        <lst_docu_currency>-high   = lst_constant-high.
**      ENDIF.
**      IF lst_constant-param1 EQ lc_sales_office.
**        APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
**        <lst_sales_office>-sign   = lst_constant-sign.
**        <lst_sales_office>-option = lst_constant-opti.
**        <lst_sales_office>-low    = lst_constant-low.
**        <lst_sales_office>-high   = lst_constant-high.
**      ENDIF.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
**      IF lst_constant-param1 EQ lc_print.
**        APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lst_print_product>).
**        <lst_print_product>-sign   = lst_constant-sign.
**        <lst_print_product>-option = lst_constant-opti.
**        <lst_print_product>-low    = lst_constant-low.
**        <lst_print_product>-high   = lst_constant-high.
**      ENDIF.
**      IF lst_constant-param1 EQ lc_digital.
**        APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lst_digital_product>).
**        <lst_digital_product>-sign   = lst_constant-sign.
**        <lst_digital_product>-option = lst_constant-opti.
**        <lst_digital_product>-low    = lst_constant-low.
**        <lst_digital_product>-high   = lst_constant-high.
**      ENDIF.
*- End of OTCM-40086:SGUDA:15-SEP-2021:ED2K924580
*    ENDLOOP. " LOOP AT fp_i_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_SUBSCRPTION_TYPE
*&---------------------------------------------------------------------*
* Subroutine to populate subscription type
*----------------------------------------------------------------------*
*      -->FP_LV_NAME  text
*      -->FP_ST_HEADER  text
*      <--FP_V_SUBSCRIPTION_TYP  text
*----------------------------------------------------------------------*
FORM f_get_subscrption_type  USING    fp_lv_name             TYPE thead-tdname
                                      fp_st_header           TYPE zstqtc_header_f501 " Structure for Header detail of invoice form
                             CHANGING fp_v_subscription_typ  TYPE char100.           " V_subscription_typ of type CHAR100

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.

  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
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
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_v_subscription_typ = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
* Get standard text values
*----------------------------------------------------------------------*
*      -->P_LV_NAME  text
*      -->P_ST_HEADER  text
*      <--P_LV_YEAR  text
*----------------------------------------------------------------------*
FORM f_get_text_val  USING    fp_lv_name   TYPE thead-tdname       " Name
                              fp_st_header TYPE zstqtc_header_f501 " Structure for Header detail of invoice form
                     CHANGING fp_lv_value  TYPE char30.            "char10. " Lv_value of type CHAR10 ++SAYANDAS

  CONSTANTS: lc_object TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_st     TYPE thead-tdid       VALUE 'ST'.   " Text ID of text to be read

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = nast-spras
      name                    = fp_lv_name
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
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_lv_value = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_variable .

  CLEAR: v_retcode          ,
*        v_ent_screen       ,
         v_xstring          ,
         v_msg_txt          ,
**         v_remit_to_uk      ,
**         v_remit_to_usa     ,
**         v_footer1          ,
**         v_footer,
**         v_footer2          ,
         st_vbco3           ,
**         v_society_logo     ,
**         v_detach           ,
**         v_order            ,
**         v_comm_meth          ,
**         v_cust             ,
**         v_com_uk           ,
**         v_com_usa          ,
         st_address         ,
         st_header          ,
**         i_vbpa             ,
**         i_vbap             ,
**         i_content_hex      ,
         i_final            ,
**         i_credit           ,
         st_formoutput      ,
         st_calc            ,
         i_constant         ,
**         v_remit_to_tbt_uk  ,
**         v_credit_tbt_uk    ,
**         v_email_tbt_uk     ,
**         v_banking1_tbt_uk  ,
**         v_cust_serv_tbt_uk ,
**         v_remit_to_scc  ,
**         v_credit_scc    ,
**         v_email_scc     ,
**         v_banking1_scc  ,
**         v_cust_serv_scc ,
**         v_remit_to_scm  ,
**         v_credit_scm    ,
**         v_email_scm     ,
**         v_banking1_scm  ,
**         v_cust_serv_scm ,
**         v_footer_tbt       ,
**         v_footer_scc    ,
**         v_footer_scm,
**         v_remit_to_tbt_usa ,
**         v_credit_tbt_usa  ,
**         v_email_tbt_usa  ,
**         v_banking1_tbt_usa   ,
**          v_cust_serv_tbt_usa  ,
**          v_remit_to_scc   ,
**          v_credit_scc     ,
**          v_email_scc      ,
**          v_banking1_scc   ,
**          v_cust_serv_scc  ,
**          v_footer_scc     ,
**          v_barcode            ,
**          v_seller_reg         ,
**          i_tax_data           ,
**          i_mara               ,
**          i_sub_final          ,
          i_jptidcdassign      ,
          v_langu              .
**          v_email_id           ,
**          v_tax                ,
**          v_scc,
**          v_scm,
**          v_partner_za,
**          v_mis_msg,
**          v_credit_crd,
**          v_payment_scc,
**          v_payment_scm,
*** BOC for F044 BY SAYANDAS on 26-JUN-2018
*         Begin of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
**          st_formoutput_f044,
**          v_zlsch_f044,
*         End   of ADD:INC0211562:WROY:20-SEP-2018:ED1K908507
*         Begin of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913493
**          i_formoutput,
***         End   of ADD:ERP-7747:WROY:27-SEP-2018:ED2K913493
**          v_vkorg_f044,
**          v_waerk_f044,
**          v_ihrez_f044,
***** EOC for F044 BY SAYANDAS on 26-JUN-2018
**          r_mat_grp5,      " ADD:CR#7730 KKRAVURI20181012
**          r_output_typ.    " ADD:CR#7730 KKRAVURI20181012
  .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHAR_TO_NUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_SUB_FINAL_TEMP_UNIT_PRICE  text
*      <--P_LV_TAX_SUM_TEMP  text
*----------------------------------------------------------------------*
FORM f_char_to_num  USING    fp_char TYPE char25 " Char_to_num using fp_ch of type CHAR25
                    CHANGING fp_num  LIKE v_num.

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      chr             = fp_char
    IMPORTING
      num             = fp_num
    EXCEPTIONS
      convt_no_number = 1
      convt_overflow  = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SAVE_PDF_APPLICTN_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_pdf_applictn_server .

  CONSTANTS : lc_iden          TYPE char10 VALUE 'VF', " Iden of type CHAR10
              lc_bus_prcs_bill TYPE zbus_prcocess VALUE 'B',  " Business Process - Billing
              lc_prnt_vend_qi  TYPE zprint_vendor VALUE 'Q',  " Third Party System (Print Vendor) - QuickIssue
              lc_prnt_vend_bt  TYPE zprint_vendor VALUE 'B',  " Third Party System (Print Vendor) - BillTrust
              lc_parvw_re      TYPE parvw         VALUE 'RE'. " Partner Function: Bill-To Party

  DATA: li_output   TYPE ztqtc_output_supp_retrieval.

  DATA: lst_output  TYPE zstqtc_output_supp_retrieval. " Output structure for E098-Output Supplement Retrieval

  DATA: lv_filename     TYPE localfile, " BCOM: Text That Is to Be Converted into MIME
        lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region, " Print Region
        lv_country_sort TYPE zcountry_sort, " Country Sorting Key
        lv_file_loc     TYPE file_no,       " Application Server File Path
        lv_datum        TYPE sydatum, " System Date
        lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
        lv_amount       TYPE char24. " Amount of type CHAR24

  CLEAR lst_output.
  lst_output-attachment_name = 'SAP Proforma'(012).
  lst_output-pdf_stream = st_formoutput-pdf.
  INSERT lst_output INTO li_output INDEX 1.

  IF st_formoutput_f044 IS NOT INITIAL.
    CLEAR lst_output.
    lst_output-attachment_name = 'Direct Debit Mandate'(013).
    lst_output-pdf_stream = st_formoutput_f044-pdf.
    INSERT lst_output INTO li_output INDEX 2.
  ENDIF.

* Identify Bill-to Party Details
  READ TABLE i_vbpa INTO DATA(lst_vbpa)
       WITH KEY vbeln = st_vbco3-vbeln
                parvw = lc_parvw_re
       BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR: lst_vbpa.
  ENDIF. " IF sy-subrc NE 0

* Determine Print Vendor
  CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
    EXPORTING
      im_bus_prcocess     = lc_bus_prcs_bill " Business Process (Billing)
      im_country          = lst_vbpa-land1   " Bill-to Party Country
      im_output_type      = nast-kschl       " Output Type
    IMPORTING
      ex_print_vendor     = lv_print_vendor  " Third Party System (Print Vendor)
      ex_print_region     = lv_print_region  " Print Region
      ex_country_sort     = lv_country_sort  " Country Sorting Key
      ex_file_loc         = lv_file_loc      " Application Server File Path
    EXCEPTIONS
      exc_invalid_bus_prc = 1
      exc_no_entry_found  = 2
      OTHERS              = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_print_vendor.
  ENDIF. " IF sy-subrc NE 0

* Trigger different logic based on Third Party System (Print Vendor)
  CASE lv_print_vendor.
    WHEN lc_prnt_vend_qi. " Third Party System (Print Vendor) - QuickIssue
      CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
        EXPORTING
          im_outputs           = li_output        " PDF Contents
          im_bus_prcocess      = lc_bus_prcs_bill " Business Process (Renewal)
          im_print_region      = lv_print_region  " Print Region
          im_country_sort      = lv_country_sort  " Country Sorting Key
          im_file_loc          = lv_file_loc      " Application Server File Path
          im_country           = lst_vbpa-land1   " Bill-to Party Country
          im_customer          = lst_vbpa-kunnr   " Bill-to Party Customer
          im_doc_number        = st_vbco3-vbeln   " SD Document Number (Quotation)
        EXCEPTIONS
          exc_missing_dir_path = 1
          exc_err_opening_file = 2
          OTHERS               = 3.
      IF sy-subrc NE 0.
*       Update Processing Log
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb = syst-msgid
            msg_nr    = syst-msgno
            msg_ty    = syst-msgty
            msg_v1    = syst-msgv1
            msg_v2    = syst-msgv2
          EXCEPTIONS
            OTHERS    = 0.
        IF sy-subrc EQ 0.
          v_retcode = 900.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc NE 0

    WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
      lv_bapi_amount = st_calc-total_due.
*     Converts a currency amount from SAP format to External format
      CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
        EXPORTING
          currency    = st_calc-waerk   " Currency
          sap_amount  = lv_bapi_amount  " SAP format
        IMPORTING
          bapi_amount = lv_bapi_amount. " External format
      MOVE lv_bapi_amount TO lv_amount.
      CONDENSE lv_amount.

*     MOVE st_header-date_rec TO lv_datum.
      MOVE sy-datum TO lv_datum.

      CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
        EXPORTING
          im_fpformoutput    = st_formoutput
          im_customer        = st_vbco3-kunde
          im_invoice         = st_vbco3-vbeln
          im_amount          = lv_amount
          im_currency        = st_calc-waerk
          im_date            = lv_datum
          im_form_identifier = lc_iden
          im_ccode           = st_header-company_code
          im_file_loc        = lv_file_loc
        IMPORTING
          ex_file_name       = lv_filename.

      IF lv_filename IS NOT INITIAL.
        CLEAR: lv_amount , lv_datum.
      ENDIF. " IF lv_filename IS NOT INITIAL
    WHEN OTHERS.
*     Nothing to Do
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_ZAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_zapi.

*  * ****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_upd_tsk          TYPE i.                           " Upd_tsk of type Integers

****Local Constant declaration
  CONSTANTS: lc_form_name      TYPE fpname VALUE 'ZQTC_FRM_PROFORMA_INV_F501', " Name of Form Object
             lc_msgnr_165      TYPE sy-msgno VALUE '165',                 " ABAP System Field: Message Number
             lc_msgnr_166      TYPE sy-msgno VALUE '166',                 " ABAP System Field: Message Number
             lc_msgid          TYPE sy-msgid VALUE 'ZQTC_R2',             " ABAP System Field: Message ID
             lc_err            TYPE sy-msgty VALUE 'E',                   " ABAP System Field: Message Type
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.                  " Communication Method (Key) (Business Address Services)

  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

************print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
*    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf    = abap_true.
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
  IF sy-subrc IS NOT INITIAL.
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
    v_retcode = 900.
    RETURN.
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        IF lr_text IS NOT INITIAL.
          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = lc_msgid
              msg_nr                 = lc_msgnr_166
              msg_ty                 = lc_err
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF. " IF sy-subrc <> 0
        ENDIF. " IF lr_text IS NOT INITIAL
    ENDTRY.

    CALL FUNCTION lv_funcname
      EXPORTING
        /1bcdwb/docparams  = lst_sfpdocparams
        im_header          = st_header
        im_xstring         = v_xstring
        im_comp_address    = lv_comp_address
        im_langu           = v_langu
        im_vbco3           = st_vbco3
        im_address         = st_address
        im_final           = i_final
        im_calc            = st_calc
        im_credit_crd      = lv_credit_card
        im_bill_to_address = li_bill_to_address
        im_ship_to_address = li_ship_to_address
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
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
      v_retcode = 900.
      RETURN.
    ELSE. " ELSE -> IF sy-subrc <> 0
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
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_retcode = 900.
        RETURN.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL
*** Save PDF in application server

  IF v_comm_meth = lc_deflt_comm_let
 AND v_ent_screen        IS INITIAL.

    PERFORM f_save_pdf_applictn_server.
  ENDIF. " IF v_comm_meth = lc_deflt_comm_let

*** Save PDF in application server
************Print & archive****************************
*  post form processing
  IF lst_sfpoutputparams-arcmode <> '1' AND
     v_ent_screen        IS INITIAL.
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
*     Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
*     COMMINT only if the subroutine is not called in update task
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1' AND
*  ENDIF. " IF lv_trtyp NE lc_a

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LANGU  text
*      <--P_I_STD_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_stxh_data  USING    fp_v_langu TYPE syst_langu " ABAP System Field: Language Key of Text Environment
                      CHANGING fp_i_std_text TYPE tt_std_text.

*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char10,   " Low of type CHAR2
           high   TYPE char10,   " High of type CHAR2
         END OF lty_range.

***Local Variable Declaration
  DATA: lst_range TYPE lty_range,
        lir_range TYPE STANDARD TABLE OF lty_range.

***Local constant declaration
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F501*', " R of type CHAR10
             lc_sign   TYPE ddsign         VALUE 'I',          " Type of SIGN component in row type of a Ranges type
             lc_option TYPE ddoption       VALUE 'CP'.         " Type of OPTION component in row type of a Ranges type

***Populate local range table
  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_r.
  APPEND lst_range TO lir_range.

*** Fetch data from STXH table
  SELECT
  tdname      " Name
    FROM stxh " STXD SAPscript text file lines
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st
    AND tdspras = v_langu.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY_F044
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_FORMOUTPUT  text
*----------------------------------------------------------------------*
FORM f_convert_pdf_binary_f044 USING fp_lst_formoutput TYPE fpformoutput. " Form Output (PDF, PDL)
*******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = fp_lst_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.
