*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVOICE_FORM_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_INVOICE_FORM_F024
* PROGRAM DESCRIPTION: This include program implemented for define all
*                      the subroutine.
* DEVELOPER: Paramita Bose (PBOSE)
* CREATION DATE: 20/03/2017
* OBJECT ID: F024
* TRANSPORT NUMBER(S): ED2K904956
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 1990 / DEFECT 2185
* REFERENCE NO: ED2K905977
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 10-May-2017
* DESCRIPTION: Incorporating changes in date field, Reprint text
*              population and remove negative sign from amount field.
*              Change the mail subject in case of receipt.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2516
* REFERENCE NO: ED2K906421
* DEVELOPER: Paramita Bose (PBOSE)
* DATE: 05-June-2017
* DESCRIPTION: Change logic for credit memo. Decide invoice type based
*              on document category.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 3069
* REFERENCE NO: ED2K907147
* DEVELOPER: Writtick Roy (WROY)
* DATE: 06-July-2017
* DESCRIPTION: Use explicit 'commit work' if not in update task
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: DEFECT 2977
* REFERENCE NO: ED2K907197
* DEVELOPER: Writtick Roy (WROY)
* DATE: 10-July-2017
* DESCRIPTION: Get Address Details from transaction data (Order)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR_518
* REFERENCE NO: ED2K907360
* DEVELOPER:    SRBOSE
* DATE:         21-Jul-2017
* DESCRIPTION: Need to update the item table
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  JIRA# ERP-4276
* REFERENCE NO: ED2K908436
* DEVELOPER:    SRBOSE
* DATE:         12-Sept-2017
* DESCRIPTION: Remove TAX text from seller registration nd add Wiley #
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR#618,CR#666
* REFERENCE NO: ED2K908961,ED2K908934
* DEVELOPER:    MODUTTA
* DATE:         17/10/2017
* DESCRIPTION: Remove BOM components from table and BOM header will
* collate the tax amount,Tax/Vat/GST to be removed only Tax to be there
* in column
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR#743,CR#XXX
* REFERENCE NO: ED2K910115,ED2K910745,ED2K909903
* DEVELOPER:    MODUTTA
* DATE:         30/01/2018
* DESCRIPTION: Add 0 tax percentage line in tax summary etc.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR#744
* REFERENCE NO: ED2K911137
* DEVELOPER:    MODUTTA
* DATE:         17/10/2017
* DESCRIPTION: The Sub-total, Tax and Shipping (if any) Amounts
*(available in the summary section) have to be displayed in Local
*Currency
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7017
* REFERENCE NO: ED2K911320
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         13/03/2018
* DESCRIPTION:  Exchange Rates should only be displayed if Currencies
* are different
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7178 (CR)
* REFERENCE NO: ED2K911548
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         21/03/2018
* DESCRIPTION:  Display Exchange Rates if Document Currency and Local
*               Currency are different
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7143
* REFERENCE NO: ED2K911548
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         23/03/2018
* DESCRIPTION:  Invoice Date should be Billing Date (not Creation Date)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-6960
* REFERENCE NO: ED2K911613
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         25-Mar-2018
* DESCRIPTION:  Improved logic for Exception / Error Handling
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERP-7332
* REFERENCE NO: ED2K911723
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         02-Apr-2018
* DESCRIPTION:  Billtrust Amount (SAP format --> External format)
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_ACC_MNGD
*&---------------------------------------------------------------------*
*
FORM f_processing_acc_mngd.

* Clear data
  PERFORM f_get_clear.

* Subroutine to populate wiley logo.
  PERFORM f_populate_wiley_logo CHANGING v_xstring.

* Perform to populate sales data from NAST table
  PERFORM f_get_data     USING nast
                      CHANGING st_vbco3
                               v_output_typ
                               v_proc_status.

* Subroutine to fetch constant values
  PERFORM f_get_constant  CHANGING v_outputyp_consor
                                   v_outputyp_detail
                                   v_outputyp_summary
                                   r_inv
                                   r_crd
                                   v_country_key
                                   r_dbt
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                                   i_tax_id
                                   r_mtart_med_issue
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                                   r_country.

* Retrieve Billing Document data
  PERFORM f_get_vbrk    USING st_vbco3
                     CHANGING st_vbrk
                              i_tax_data.

* Retrieve Sales Document: Partner data
  PERFORM f_get_vbpa    USING st_vbrk
                     CHANGING i_vbpa.

* Retrieve Item data of Billing Document
  PERFORM f_get_vbrp    USING st_vbrk
                     CHANGING i_vbrp
*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
                              i_veda.
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591

* Retrieve ID codes of material
  PERFORM f_get_jptidcdassign    USING i_vbrp
                              CHANGING i_jptidcdassign.

* Retrieve material data from MARA table.
  PERFORM f_get_mara    USING i_vbrp
                     CHANGING i_mara
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                              i_makt.
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554

* Retrieve Sales Document Flow.
  PERFORM f_get_vbfa    USING st_vbrk
                              i_vbrp
                     CHANGING i_vbfa.

  IF v_output_typ EQ v_outputyp_consor.
    PERFORM f_get_vbpa_consortia    USING i_vbrp
                                 CHANGING i_vbpa_con.
  ENDIF. " IF v_output_typ EQ v_outputyp_consor


* Retrieve Purchase Order Number
  PERFORM f_get_vbkd    USING i_vbfa
                     CHANGING i_vbkd.

* Retrieve Customer VAT
  PERFORM f_get_kna1    USING st_vbrk
                     CHANGING st_kna1
                              v_trig_attr.

* Populate header data
  PERFORM f_populate_detail_inv_header  USING st_vbrk
                                              i_vbrp
                                              i_vbpa
                                              i_vbfa
                                              i_vbkd
                                              st_kna1
                                              v_country_key
                                     CHANGING st_header.

* Retrieve prepaid amount
  PERFORM f_get_prepaid_amount    USING st_vbrk
                               CHANGING v_prepaid_amount
                                        v_paid_amt.

** Fetch Invoice text
*  PERFORM f_fetch_title_text USING    st_vbrk
*                             CHANGING st_header
*                                      v_accmngd_title
*                                      v_reprint " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
*                                      v_tax
*                                      v_remit_to
*                                      v_footer
*                                      v_bank_detail
*                                      v_crdt_card_det
*                                      v_payment_detail
*                                      v_cust_service_det
*                                      v_totaldue
*                                      v_subtotal
*                                      v_prepaidamt
*                                      v_vat
*                                      v_payment_detail_inv.

* Perform to get address and emailID.
  PERFORM f_get_adrc USING i_vbpa
                  CHANGING i_adrc.

*  BOC by MODUTTA on 01/03/18 for CR#744 TR:ED2K911137
  PERFORM f_get_t005_data CHANGING v_waers
                                   v_ind.
*  EOC by MODUTTA on 01/03/18 for CR#744 TR:ED2K911137

*  BOC by MODUTTA on 13/02/18 for zca_enh_ctrl check
  PERFORM f_check_enh_ctrl.
*  EOC by MODUTTA on 13/02/18 for zca_enh_ctrl check

* Subroutine to fetch email address of customer.
  PERFORM f_get_emailid USING st_header
                    CHANGING  i_emailid.

** Retrieve prepaid amount
*  PERFORM f_get_prepaid_amount    USING st_vbrk
*                               CHANGING v_prepaid_amount
*                                        v_paid_amt.

***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  PERFORM f_get_stxh_data CHANGING i_std_text.
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412

*  IF v_output_typ EQ v_outputyp_summary.
*    PERFORM f_populate_layout_summary.

*  ELSEIF v_output_typ EQ v_outputyp_consor.
*    PERFORM f_populate_layout_consortia.
*
*  ELSEIF v_output_typ EQ v_outputyp_detail.
  PERFORM f_populate_layout_detail.
*
*  ENDIF. " IF v_output_typ EQ v_outputyp_summary

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_WILEY_LOGO
*&---------------------------------------------------------------------*
* Populate Wiley logo
*----------------------------------------------------------------------*
*      <--FP_V_XSTRING  Logo value
*------------------------------------o----------------------------------*
FORM f_populate_wiley_logo  CHANGING fp_v_xstring TYPE xstring.

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
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*  Get Invoice number from configuration
*----------------------------------------------------------------------*
*      -->FP_NAST     Message Table
*      <--FP_ST_VBCO3 Sales Doc.Access Methods
*----------------------------------------------------------------------*
FORM f_get_data  USING    fp_nast          TYPE nast      " Message Status
                 CHANGING fp_st_vbco3      TYPE vbco3     " Sales Doc.Access Methods: Key Fields: Document Printing
                          fp_v_outputtyp   TYPE sna_kschl " Message type
                          fp_v_proc_status TYPE na_vstat. " Processing status of message

  CLEAR fp_st_vbco3.
* Populate sales data in local structure.
  fp_st_vbco3-mandt = sy-mandt. " Client
  fp_st_vbco3-spras = 'E'."nast-spras. " Language Key
  fp_st_vbco3-vbeln = p_vbe."p_nast-objky+0(10). " Sales and Distribution Document Number
  fp_st_vbco3-posnr = '330000'."nast-objky+10(6). " Item number of the SD document
  fp_v_proc_status  = nast-vstat. " Process status
  fp_v_outputtyp    = nast-kschl. " output type

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRK
*&---------------------------------------------------------------------*
* Subroutine to fetch billing document Header data
*----------------------------------------------------------------------*
*      -->FP_ST_VBCO3 Sales Doc.Access Methods
*      <--FP_I_VBRK   Billing Document: Header Data
*----------------------------------------------------------------------*
FORM f_get_vbrk  USING    fp_st_vbco3 TYPE vbco3 " Sales Doc.Access Methods: Key Fields: Document Printing
                 CHANGING fp_st_vbrk  TYPE ty_vbrk
                          fp_i_tax_data TYPE tt_tax_data.

* Local constant declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.

* Retrieve billing document data from VBRK table
  SELECT SINGLE
         vbeln " Billing Document
         fkart " Billing Type
         vbtyp " SD document category  " (++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
         waerk " SD Document Currency
         vkorg " Sales Organization
         knumv " Number of the document condition
         fkdat " Billing date for billing index and printout  " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         zterm " Terms of Payment Key
         zlsch " Payment Method
         land1 " Country of Destination
         bukrs " Company Code
         netwr " Net Value in Document Currency
         erdat " Date on Which Record Was Created  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
         kunrg " Payer
         kunag " Sold-to party
         zuonr " Assignment number
         rplnr " Number of payment card plan type
    INTO fp_st_vbrk
    FROM vbrk  " Billing Document: Header Data
    WHERE vbeln EQ fp_st_vbco3-vbeln.
  IF sy-subrc EQ 0.
*Begin of change by MODUTTA on 08-Aug-2017 CR_408 #TR: ED2K907591
    SELECT document,
           doc_line_number,
           buyer_reg,
           seller_reg,     " Seller VAT Registration Number
           invoice_desc    " Invoice Description
      FROM /idt/d_tax_data " Tax Data
      INTO TABLE @fp_i_tax_data
      WHERE company_code = @fp_st_vbrk-bukrs
      AND   fiscal_year = @lc_gjahr
      AND   document_type = @lc_doc_type
      AND   document = @fp_st_vbrk-vbeln.
    IF sy-subrc EQ 0.
      DATA(li_tax_data) = fp_i_tax_data.
      LOOP AT li_tax_data INTO DATA(lst_tax_data).
        IF lst_tax_data-invoice_desc CS v_inv_desc
          AND v_invoice_desc IS INITIAL.
          v_invoice_desc = lst_tax_data-invoice_desc.
        ENDIF. " IF lst_tax_data-invoice_desc CS v_inv_desc
      ENDLOOP. " LOOP AT li_tax_data INTO DATA(lst_tax_data)
    ENDIF. " IF sy-subrc EQ 0
*End of change by MODUTTA on 08-Aug-2017 CR_408 #TR: ED2K907591
*   Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
*   Fetch Company Code Details
    SELECT SINGLE land1 "Country Key
*                 Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                  waers "Currency Key
*                 End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
      FROM t001 " Company Codes
*     Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
      INTO ( st_header-comp_code_country,
             v_local_curr )
*     End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
*     Begin of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
*     INTO st_header-comp_code_country
*     End   of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
     WHERE bukrs EQ fp_st_vbrk-bukrs.
    IF sy-subrc NE 0.
      CLEAR: st_header-comp_code_country.
*     Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
      CLEAR: v_local_curr.
*     End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
    ENDIF. " IF sy-subrc NE 0
*   End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBPA
*&---------------------------------------------------------------------*
* Subroutine to Fetch all Sales document related to partner
*----------------------------------------------------------------------*
*      -->FP_I_VBRK  Billing Document: Header Data
*      <--FP_I_VBPA  Sales Document: Partner
*----------------------------------------------------------------------*
FORM f_get_vbpa  USING    fp_st_vbrk TYPE ty_vbrk
                 CHANGING fp_i_vbpa  TYPE tt_vbpa.

* Retrieve data from VBPA table
  SELECT vbeln   " Sales and Distribution Document Number
         posnr   " Item number of the SD document
         parvw   " Partner Function
         kunnr   " Customer Number
         adrnr   " Address
         country " Country Key
*        land1 " Country Key
    INTO TABLE fp_i_vbpa
*   FROM vbpa  " Sales Document: Partner
    FROM vbpa INNER JOIN adrc " Sales Document: Partner
      ON vbpa~adrnr EQ adrc~addrnumber
    WHERE vbeln EQ fp_st_vbrk-vbeln.
  IF sy-subrc EQ 0.
*   SORT fp_i_vbpa BY vbeln parvw.
    SORT fp_i_vbpa BY vbeln parvw posnr.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRP
*&---------------------------------------------------------------------*
* Fetch Item data for billing document
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK Billing Document: Header Data
*      <--FP_I_VBRP  Billing Document: Item Data
*----------------------------------------------------------------------*
FORM f_get_vbrp  USING    fp_st_vbrk TYPE ty_vbrk
                 CHANGING fp_i_vbrp  TYPE tt_vbrp
*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
                          fp_i_veda TYPE tt_veda.
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591

* Fetch Item data from VBRP table.
  SELECT vbeln " Billing Document
         posnr " Billing item
*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR:ED2K907362
         uepos
*End of change by SRBOSE on 07-Aug-2017 CR_374 #TR:ED2K907362
         vbelv      " Originating document
         posnv      " Originating item
         aubel      " Sales Document
         aupos      " Sales Document Item (++) SRBOSE
         matnr      " Material Number
         arktx      " Short text for sales order item
         pstyv      " Sales document item category
         vkbur      " Sales Office
         kzwi1      " Subtotal 1 from pricing procedure for condition
         kzwi2      " Subtotal 2 from pricing procedure for condition
         kzwi3      " Subtotal 3 from pricing procedure for condition
         kzwi5      " Subtotal 5 from pricing procedure for condition
         kzwi6      " Subtotal 6 from pricing procedure for condition
         aland      " Departure country (country from which the goods are sent)
         lland_auft " Country of destination of sales order
*        Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
         kowrr " Statistical values
         fareg " Rule in billing plan/invoice plan
         netwr
*        End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
    INTO TABLE fp_i_vbrp
    FROM vbrp " Billing Document: Item Data
    WHERE vbeln EQ fp_st_vbrk-vbeln.
  IF  sy-subrc EQ 0.
    SORT fp_i_vbrp BY vbeln posnr.

    READ TABLE fp_i_vbrp INTO DATA(lst_vbrp) INDEX 1.
    IF sy-subrc IS INITIAL.
      DATA(lv_aubel) = lst_vbrp-aubel.
    ENDIF. " IF sy-subrc IS INITIAL

****BOC by MODUTTA for CR#666 on 25/10/2017
    DATA(li_vbrp) = fp_i_vbrp[].

    IF fp_st_vbrk-vbtyp IN r_crd.
      SELECT vgbel,
             vgpos " Item number of the reference item
        FROM vbap  " Sales Document: Item Data
        INTO TABLE @DATA(li_vbap)
        FOR ALL ENTRIES IN @li_vbrp
        WHERE vbeln = @li_vbrp-aubel.
      IF sy-subrc EQ 0.
        SORT li_vbap BY vgbel.
        DELETE ADJACENT DUPLICATES FROM li_vbap COMPARING vgbel.
        SELECT vbeln,
               posnr,
               uepos,
               vbelv,
               posnv,
               aubel,
               aupos " Sales Document Item
          FROM vbrp  " Billing Document: Item Data
          INTO TABLE @DATA(li_vbrp_temp)
          FOR ALL ENTRIES IN @li_vbap
          WHERE vbeln = @li_vbap-vgbel.
        IF sy-subrc EQ 0.
          SORT li_vbrp_temp BY aubel.
          DELETE ADJACENT DUPLICATES FROM li_vbrp_temp COMPARING aubel.
          li_vbrp[] = li_vbrp_temp[].

          READ TABLE li_vbrp INTO lst_vbrp INDEX 1.
          IF sy-subrc IS INITIAL.
            lv_aubel = lst_vbrp-aubel.
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
****BOC by MODUTTA for CR#666 on 25/10/2017

*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
*    Fetch data from veda
    SELECT vbeln   "Sales Document
           vposn   "Sales Document Item
           vbegdat "Contract start date
      FROM veda    " Contract Data
      INTO TABLE fp_i_veda
      FOR ALL ENTRIES IN li_vbrp
      WHERE vbeln = li_vbrp-aubel.
*        AND vposn = li_vbrp-posnr.
    IF sy-subrc IS INITIAL.
*     Begin of DEL:ERP-5002:WROY:07-NOV-2017:ED2K909354
*     SORT fp_i_veda BY vbeln.
*
*      *****************************YEAR*************************************
*Begin of change by SRBOSE on 02-Aug-2017 CR_518 #TR:  ED2K907362
*     READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln = lv_aubel
**                                                    vposn = lst_vbrp-aupos
*                                                    BINARY SEARCH.
*     End   of DEL:ERP-5002:WROY:07-NOV-2017:ED2K909354
*     Begin of ADD:ERP-5002:WROY:07-NOV-2017:ED2K909354
      SORT fp_i_veda BY vbeln vposn.

      CLEAR: lst_vbrp.
      READ TABLE li_vbrp INTO lst_vbrp INDEX 1.
      IF sy-subrc EQ 0.
        READ TABLE i_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_vbrp-aubel
                                                       vposn = lst_vbrp-aupos
                                                       BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE i_veda INTO lst_veda     WITH KEY vbeln = lst_vbrp-aubel
                                                       vposn = '000000'
                                                       BINARY SEARCH.
        ENDIF. " IF sy-subrc NE 0
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:ERP-5002:WROY:07-NOV-2017:ED2K909354
      IF sy-subrc EQ 0.
        DATA(lv_year) = lst_veda-vbegdat+0(4).
        CONCATENATE text-001
                          lv_year
               INTO v_year SEPARATED BY space.
      ENDIF. " IF sy-subrc EQ 0
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR:  ED2K907362

    ENDIF. " IF sy-subrc IS INITIAL
*End of change by SRBOSE on 02-Aug-2017 CR_518 #TR: ED2K907591
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_JPTIDCDASSIGN
*&---------------------------------------------------------------------*
* Fetch ID codes of material
*----------------------------------------------------------------------*
*      -->FP_I_VBRP           Billing Document: Item data
*      <--FP_I_JPTIDCDASSIGN  IS-M: Assignment of ID Codes to Material
*----------------------------------------------------------------------*
FORM f_get_jptidcdassign  USING    fp_i_vbrp          TYPE tt_vbrp
                          CHANGING fp_i_jptidcdassign TYPE tt_jptidcdassign.

  IF fp_i_vbrp[] IS NOT INITIAL.
    DATA(li_vbrp) = fp_i_vbrp[].
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
        AND idcodetype IN r_idcodetype.
    IF sy-subrc EQ 0.
      SORT fp_i_jptidcdassign BY matnr.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_vbrp.
  ENDIF. " IF fp_i_vbrp[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA
*&---------------------------------------------------------------------*
* Fetch old material number
*----------------------------------------------------------------------*
*      -->FP_I_VBRP  Billing Document: Item Data
*      <--FP_I_MARA  General Material Data
*      <--FP_I_MAKT  Material Descriptions Data
*----------------------------------------------------------------------*
FORM f_get_mara  USING    fp_i_vbrp TYPE tt_vbrp
                 CHANGING fp_i_mara TYPE tt_mara
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                          fp_i_makt TYPE tt_makt.                   "
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554

  IF fp_i_vbrp[] IS NOT INITIAL.
    DATA(li_vbrp) = fp_i_vbrp[].
    SORT li_vbrp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING matnr.

* Fetch old material number from MARA table
    SELECT matnr " Material Number
           bismt " Old material number
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
           mtart " Material Type
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
*Begin of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
           ismmediatype "Media Type
           ismsubtitle1 "Subtitle 1
           ismsubtitle2 "Subtitle 2
           ismsubtitle3 "Subtitle 3
           ismyearnr    "Media issue year number
*End of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
      FROM mara " General Material Data
      INTO TABLE fp_i_mara
      FOR ALL ENTRIES IN li_vbrp
      WHERE matnr EQ li_vbrp-matnr.
    IF sy-subrc EQ 0.
      SORT fp_i_mara BY matnr.

*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
*     Material Descriptions
      SELECT matnr "Material Number
             spras "Language Key
             maktx "Material Description (Short Text)
        FROM makt  " Material Descriptions
        INTO TABLE fp_i_makt
        FOR ALL ENTRIES IN fp_i_mara
        WHERE matnr EQ fp_i_mara-matnr.
      IF sy-subrc EQ 0.
        SORT fp_i_makt BY matnr spras.
      ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_vbrp.
  ENDIF. " IF fp_i_vbrp[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBFA
*&---------------------------------------------------------------------*
* Subroutine for Retrieve Sales Document Flow
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  Billing Document: Header Data
*      <--FP_I_VBFA   Sales Document Flow
*----------------------------------------------------------------------*
FORM f_get_vbfa  USING    fp_st_vbrk TYPE ty_vbrk
                          fp_i_vbrp  TYPE tt_vbrp
                 CHANGING fp_i_vbfa  TYPE tt_vbfa.

  IF fp_i_vbrp[] IS NOT INITIAL.

* Fetch Sales Document Flow from VBFA table
    SELECT vbelv " Preceding sales and distribution document
           posnv " Preceding item of an SD document
           vbeln " Subsequent sales and distribution document
           posnn " Subsequent item of an SD document
      FROM vbfa  " Sales Document Flow
      INTO TABLE fp_i_vbfa
      FOR ALL ENTRIES IN fp_i_vbrp
*      WHERE vbeln EQ fp_st_vbrk-vbeln
      WHERE vbeln EQ fp_i_vbrp-vbeln
*        AND posnv EQ fp_i_vbrp-posnr.
        AND posnn EQ fp_i_vbrp-posnr.
    IF sy-subrc EQ 0.
      SORT fp_i_vbfa BY vbelv posnv.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_i_vbrp[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBKD
*&---------------------------------------------------------------------*
* Subroutine to fetch Purchase Order Number
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK    Billing Document: Header data
*      -->FP_I_VBRP     Billing Document: Item data
*      <--FP_V_PONUMBER Purchase Ordr Number
*----------------------------------------------------------------------*
FORM f_get_vbkd  USING    fp_i_vbfa TYPE tt_vbfa
                 CHANGING fp_i_vbkd TYPE tt_vbkd.

  IF i_vbrp[] IS NOT INITIAL.
    DATA(li_vbrp) = i_vbrp[].
* Retrieve PO Number from VBKD table
    SELECT vbeln " Sales and Distribution Document Number
           posnr "
           bstkd " Customer purchase order number
           ihrez " Your Reference
      INTO TABLE fp_i_vbkd
      FROM vbkd  " Sales Document: Business Data
*    FOR ALL ENTRIES IN fp_i_vbfa
      FOR ALL ENTRIES IN li_vbrp
*    WHERE vbeln EQ fp_i_vbfa-vbelv
      WHERE vbeln EQ li_vbrp-aubel.
*Begin of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
*Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
*       AND posnr EQ li_vbrp-aupos.
*Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
*End of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
    IF sy-subrc EQ 0.
      SORT fp_i_vbkd BY vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_vbrp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KNA1
*&---------------------------------------------------------------------*
* Retrieve customer VAT
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  text
*      <--FP_I_KNA1  text
*----------------------------------------------------------------------*
FORM f_get_kna1  USING    fp_st_vbrk TYPE ty_vbrk
                 CHANGING fp_st_kna1 TYPE ty_kna1
                          fp_v_trig_attr TYPE katr6. " Attribute 6

* Retrieve Customer VAT from KNA1 table
  SELECT SINGLE kunnr " Customer Number
         spras        " Language Key
         stceg        " VAT Registration Number
         katr6        " Attribute 6
    FROM kna1         " General Data in Customer Master
    INTO fp_st_kna1
    WHERE kunnr EQ fp_st_vbrk-kunrg.
  IF sy-subrc EQ 0.
    fp_v_trig_attr = fp_st_kna1-katr6.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ACC_MNGD
*&---------------------------------------------------------------------*
* Final Item table population
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK     Billing Document: Header data
*      -->FP_I_VBRP  text
*      -->FP_I_VBFA  text
*      -->FP_I_VBPA  text
*      -->FP_I_JPTIDCDASSIGN  text
*      -->FP_I_MARA  text
*      -->FP_I_KNA1  text
*      <--FP_I_FINAL     Final item table
*----------------------------------------------------------------------*
FORM f_populate_detail_inv_item USING fp_st_vbrk          TYPE ty_vbrk
                                      fp_i_vbrp           TYPE tt_vbrp
                                      fp_i_jptidcdassign  TYPE tt_jptidcdassign
                                      fp_i_mara           TYPE tt_mara
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                                      fp_i_makt           TYPE tt_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                                      fp_i_vbkd           TYPE tt_vbkd
                                      fp_i_vbfa           TYPE tt_vbfa
                                      fp_v_paid_amt       TYPE autwr  " Payment cards: Authorized amount
                             CHANGING fp_i_final          TYPE ztqtc_item_detail_f024
                                      fp_v_prepaid_amount TYPE char20 " V_prepaid_amount of type CHAR20
                                      fp_i_subtotal       TYPE ztqtc_subtotal_f024.

* Data Declaration
  DATA : li_final     TYPE ztqtc_item_detail_f024,
         lst_final    TYPE zstqtc_item_detail_f024, " Structure for Item table
         lv_amount    TYPE char14,                  " Amount of type CHAR14
         lv_tax       TYPE kzwi6,                   " Tax
         lv_fees      TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_disc      TYPE kzwi5,                   " Discount
         lv_due       TYPE kzwi2,                   " Subtotal 2 from pricing procedure for condition
         lv_amnt1     TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_subtot    TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_amnt      TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_posnr     TYPE posnr,                   " Subtotal 2 from pricing procedure for condition
         lv_doc_line  TYPE /idt/doc_line_number,    " Document Line Number
         lv_buyer_reg TYPE char255,                 " Buyer_reg of type CHAR255
         lv_tabix_bom TYPE sy-tabix.                " ABAP System Field: Row Index of Internal Tables

* Constant declaration
  CONSTANTS : lc_percent TYPE char1 VALUE '%', " Percent of type CHAR1
              lc_minus   TYPE char1 VALUE '-'. " Minus of type CHAR1

* BOC by SRBOSE
  DATA : li_lines        TYPE STANDARD TABLE OF tline, "Lines of text read
         li_vbrp         TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
         lv_text         TYPE string,
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
         lv_mat_text     TYPE string,
         lv_tdname       TYPE thead-tdname, " Name
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
         lv_ind          TYPE xegld,                   " Indicator: European Union Member?
         lst_line        TYPE tline,                   " SAPscript: Text Lines
         lst_lines       TYPE tline,                   " SAPscript: Text Lines
         li_lines_agent  TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
         lv_text_agent   TYPE string,
         lv_text_tax     TYPE string,                  "Added by MODUTTA on 22/01/2018 for CR# TBD
         lst_subtotal    LIKE LINE OF i_subtotal,
         lst_final_space TYPE zstqtc_item_detail_f024. " Structure for Item table.

  CONSTANTS:      lc_undscr     TYPE char1      VALUE '_',                                 " Undscr of type CHAR1
                  lc_vat        TYPE char3      VALUE 'VAT',                               " Vat of type CHAR3
                  lc_tax        TYPE char3      VALUE 'TAX',                               " Tax of type CHAR3
                  lc_gst        TYPE char3      VALUE 'GST',                               " Gst of type CHAR3
                  lc_class      TYPE char5      VALUE 'ZQTC_',                             " Class of type CHAR5
                  lc_devid      TYPE char5      VALUE '_F024',                             " Devid of type CHAR5
                  lc_colon      TYPE char1      VALUE ':',                                 " Colon of type CHAR1
                  lc_tax_text   TYPE tdobname VALUE 'ZQTC_TAX_F024',                       " Name
                  lc_digital    TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',                   " Name
                  lc_print      TYPE tdobname VALUE 'ZQTC_F024_PRINT',                     " Name
                  lc_mixed      TYPE tdobname VALUE 'ZQTC_F024_MIXED',                     " Name
                  lc_shipping   TYPE tdobname VALUE 'ZQTC_F024_SHIPPING',                  " Name
                  lc_text_id    TYPE tdid     VALUE 'ST',                                  " Text ID
                  lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',            " Name
                  lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
                  lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
                  lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
                  lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',          " Name
                  lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042',         " Name
                  lc_agent_dis  TYPE thead-tdname VALUE 'ZQTC_F024_AGENT_DISCOUNT'.        " Name

  li_vbrp     = fp_i_vbrp.
* Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
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
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* EOC by SRBOSE

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
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
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD

  CLEAR : v_totaldue_val,
          v_subtotal_val,
          v_sales_tax.

* Populate first line od description
  lst_final-prod_id = space.
  lst_final-description = |ENHANCED ACCESS LICENSE| && | | && v_year.
  lst_final-fees = space.
  lst_final-discount = space.
  lst_final-sub_total = space.
  lst_final-tax_amount = space.
  lst_final-total = space.
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

** Append a blank space
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

*Begin of change by SRBOSE on 07-Aug-2017 CR_374 #TR:  ED2K907362
  DATA:  lv_kbetr_desc      TYPE p DECIMALS 3,         " Rate (condition amount or percentage)
         lv_kbetr_char      TYPE char15,               " Kbetr_char of type CHAR15
         lv_year_char       TYPE char10,               " Year_char of type CHAR10
         lst_komp           TYPE komp,                 " Communication Item for Pricing
         lv_text_id         TYPE tdid,                 " Text ID
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         lst_tax_item_final TYPE zstqtc_tax_item_f024, " Structure for tax components
         lv_taxable_amt     TYPE kzwi1,                " Subtotal 1 from pricing procedure for condition
         lv_tax_amount      TYPE p DECIMALS 3,         " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                " Rate (condition amount or percentage)
         lv_kwert           TYPE kwert,                " Condition value
         lv_kwert_text      TYPE char50,               " Kwert_text of type CHAR50
         lv_issn            TYPE tdobname.             " Name

*  Constant Declaration
  CONSTANTS: lc_percentage TYPE char1 VALUE '%'. " Percentage of type CHAR1

*  lst_komk-belnr = fp_st_vbrk-vbeln.
*  lst_komk-knumv = fp_st_vbrk-knumv.
*****TAX Description for BOM
*  CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
*    EXPORTING
*      comm_head_i = lst_komk
*      comm_item_i = lst_komp
*    TABLES
*      tkomv       = li_tkomv
*      tkomvd      = li_tkomvd.

***BOC by MODUTTA on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kschl,
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
*      AND   kposn = fp_st_vbap-posnr.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
    DATA(li_konv) = li_tkomv[].
    SORT li_konv BY kposn kschl.
    DELETE li_konv WHERE kschl NE v_cond_type.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    DELETE li_tkomv WHERE kawrt IS INITIAL.
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*    DELETE li_tkomv WHERE kbetr IS INITIAL. "CR# 743
  ENDIF. " IF sy-subrc IS INITIAL
***EOC by MODUTTA on 17/10/2017 for CR#666

*  IF li_tkomv IS NOT INITIAL.
*    DELETE li_tkomv WHERE koaid NE 'D'.
*  ENDIF. " IF li_tkomv IS NOT INITIAL
*End of change by SRBOSE on 07-Aug-2017 CR_374 #TR:  ED2K907362

  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING buyer_reg.
  DATA(lv_tax_line) = lines( li_tax_buyer ).
  IF lv_tax_line EQ 1.
    READ TABLE li_tax_buyer INTO DATA(lst_tax_temp) INDEX 1.
    IF sy-subrc EQ 0.
      st_header-buyer_reg = lst_tax_temp-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lv_tax_line EQ 1

** Populate Agent Discount Text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_agent_dis
      object                  = c_object
    TABLES
      lines                   = li_lines_agent
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
        it_tline       = li_lines_agent
      IMPORTING
        ev_text_string = lv_text_agent.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_agent.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* Populate final table
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp) WHERE vbeln = fp_st_vbrk-vbeln.
**          BOC by MODUTTA on 15/01/2018 for CR# TBD
    READ TABLE li_konv INTO DATA(lst_konv) WITH KEY kposn = lst_vbrp-posnr
                                                    kschl = v_cond_type
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_kwert = lv_kwert + lst_konv-kwert.
    ENDIF. " IF sy-subrc EQ 0
**          EOC by MODUTTA on 15/01/2018 for CR# TBD

**    BOC by MODUTTA on 17/10/2017 for CR# 666
    DATA(lv_tabix_space) = sy-tabix.

*   For Digital,Print,Combined and Shipping
    READ TABLE fp_i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.

        v_txt_name = lc_digt_subsc.
        PERFORM f_read_sub_type USING v_txt_name
                                      lv_text_id
                               CHANGING v_subs_type.

      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.

        v_txt_name = lc_prnt_subsc.
        PERFORM f_read_sub_type USING v_txt_name
                                      lv_text_id
                               CHANGING v_subs_type.

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.

        v_txt_name = lc_comb_subsc.
        PERFORM f_read_sub_type USING v_txt_name
                                      lv_text_id
                               CHANGING v_subs_type.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        PERFORM f_read_sub_type USING v_txt_name
                                      lv_text_id
                               CHANGING v_subs_type.
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
    ENDIF. " IF sy-subrc EQ 0

***for bom component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911366
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911366
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS NOT INITIAL.
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lst_tax_item-taxable_amt IS NOT INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
***EOC by MODUTTA for CR_743

    IF lst_vbrp-uepos IS INITIAL. "BOM header or Non BOM but no BOM components
***      BOC by MODUTTA on 11/01/2018 for CR_TBD
*      IF lv_tabix_space GT 1.
*        APPEND lst_final_space TO fp_i_final.
*      ENDIF. " IF lv_tabix_space GT 1
***      EOC by MODUTTA on 11/01/2018 for CR_TBD
      CLEAR lst_mara.
      READ TABLE fp_i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr
                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF lst_mara-mtart IN r_mtart_med_issue. "Media Issues
          READ TABLE fp_i_makt ASSIGNING FIELD-SYMBOL(<lst_makt>)
               WITH KEY matnr = lst_vbrp-matnr
                        spras = st_header-language "Customer Language
               BINARY SEARCH.
          IF sy-subrc NE 0.
            READ TABLE fp_i_makt ASSIGNING <lst_makt>
                 WITH KEY matnr = lst_vbrp-matnr
                          spras = c_deflt_langu "Default Language
                 BINARY SEARCH.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            lst_final-description = <lst_makt>-maktx. "Material Description
          ENDIF. " IF sy-subrc EQ 0
        ELSE. " ELSE -> IF lst_mara-mtart IN r_mtart_med_issue
*         Fetch Material Basic Text
          CLEAR: li_lines,
                 lv_mat_text.
          lv_tdname = lst_mara-matnr.
*         Using Customer Language
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = c_id_grun          "Text ID: GRUN
              language                = st_header-language "Language Key
              name                    = lv_tdname          "Text Name: Material Number
              object                  = c_obj_mat          "Text Object: MATERIAL
            TABLES
              lines                   = li_lines           "Text Lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc NE 0.
*           Using Default Language (English)
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                      = c_id_grun     "Text ID: GRUN
                language                = c_deflt_langu "Language Key
                name                    = lv_tdname     "Text Name: Material Number
                object                  = c_obj_mat     "Text Object: MATERIAL
              TABLES
                lines                   = li_lines      "Text Lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            DELETE li_lines WHERE tdline IS INITIAL.
*           Convert ITF text into a string
            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
              EXPORTING
                it_tline       = li_lines
              IMPORTING
                ev_text_string = lv_mat_text.
            IF sy-subrc EQ 0.
              lst_final-description = lv_mat_text. "Material Basic Text
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_mara-mtart IN r_mtart_med_issue
      ENDIF. " IF sy-subrc EQ 0

**      Commented by MODUTTA on 11/01/2018 for CR# TBD
****   Reference Number
*      READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
*                                                        posnr = lst_vbrp-aupos
*                                               BINARY SEARCH.
*      IF sy-subrc EQ 0 .
*        lst_final-prod_id = lst_vbkd-ihrez.
*      ENDIF. " IF sy-subrc EQ 0
**      Commented by MODUTTA on 11/01/2018 for CR# TBD

***          BOC by MODUTTA on 11/01/2018 for CR# TBD
      IF lst_vbrp-uepos IS INITIAL.
        CLEAR lst_mara.
        READ TABLE fp_i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT fp_i_jptidcdassign INTO DATA(lst_jptidcdassign) WHERE matnr = lst_mara-matnr.
            IF lst_mara-ismmediatype = c_print.
              lv_issn = lc_pntissn.
            ELSEIF lst_mara-ismmediatype = c_digital.
              lv_issn = lc_digissn.
            ELSEIF lst_mara-ismmediatype = c_mixed.
              lv_issn = lc_combissn.
            ENDIF. " IF lst_mara-ismmediatype = c_print
            IF lst_jptidcdassign-identcode IS NOT INITIAL.
              PERFORM f_read_text    USING lv_issn
                                  CHANGING v_text_line.
              IF v_text_line IS NOT INITIAL.
                CONCATENATE v_text_line lst_jptidcdassign-identcode INTO lst_final-prod_id SEPARATED BY ':'.
*                APPEND lst_final TO fp_i_final.
*                CLEAR lst_final.
              ENDIF. " IF v_text_line IS NOT INITIAL
            ENDIF. " IF lst_jptidcdassign-identcode IS NOT INITIAL
          ENDLOOP. " LOOP AT fp_i_jptidcdassign INTO DATA(lst_jptidcdassign) WHERE matnr = lst_mara-matnr
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_vbrp-uepos IS INITIAL
***          EOC by MODUTTA on 11/01/2018 for CR# TBD

****   Fees
      SET COUNTRY st_header-bill_country.
      lv_fees =  lst_vbrp-kzwi1.
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_fees GT 0.
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
        CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_fees LT 0.
          WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-fees.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-fees.
        ELSE. " ELSE -> IF lv_fees LT 0
          WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-fees.
        ENDIF. " IF lv_fees LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

****  Discount
      CLEAR :lv_disc.
* If discount value is 0, then show the value in braces to indicate
* negative value
      lv_disc = lst_vbrp-kzwi5.
      IF fp_st_vbrk-vbtyp IN r_crd.
        lv_disc = lv_disc * -1.
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_disc LT 0.
          WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-discount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-discount.
          CONDENSE lst_final-discount.
        ELSE. " ELSE -> IF lv_disc LT 0
          WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-discount.
        ENDIF. " IF lv_disc LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

**** Sub Total
      lv_subtot = lst_vbrp-kzwi3 + lv_subtot.

      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_subtot GT 0.
        WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
        CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_subtot LT 0.
          WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-sub_total.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-sub_total.
        ELSE. " ELSE -> IF lv_subtot LT 0
          WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-sub_total.
        ENDIF. " IF lv_subtot LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

******     Item Number
      lst_final-item = lst_vbrp-posnr.

*******      Tax Amount
      IF lst_final-tax_amount IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF fp_st_vbrk-vbtyp IN r_crd
           AND lv_tax GT 0.
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
          CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
        ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
          IF lv_tax LT 0.
            WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
            CONDENSE lst_final-tax_amount.
            CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
              CHANGING
                value = lst_final-tax_amount.
            CONDENSE lst_final-tax_amount.
          ELSE. " ELSE -> IF lv_tax LT 0
*          WRITE lst_vbrp-kzwi6 TO lst_final-tax_amount.
            WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
            CONDENSE lst_final-tax_amount.
          ENDIF. " IF lv_tax LT 0
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      ENDIF. " IF lst_final-tax_amount IS INITIAL

******       Final Amount
      lv_amnt = lst_vbrp-kzwi3 + lv_tax + lv_amnt.

      IF fp_st_vbrk-vbtyp IN r_crd " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
        AND lv_amnt GT 0.
        WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
        CONCATENATE lc_minus lst_final-total INTO lst_final-total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_amnt LT 0.
          WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-total.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-total.
        ELSE. " ELSE -> IF lv_amnt LT 0
          WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-total.
        ENDIF. " IF lv_amnt LT 0
**    EOC by MODUTTA on 17/10/2017 for CR# 666
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

******  Total Tax
    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.

    IF lst_final IS NOT INITIAL.
*    IF lst_final-description IS NOT INITIAL.
      APPEND lst_final TO fp_i_final.
      CLEAR lst_final.
    ENDIF. " IF lst_final IS NOT INITIAL

***BOC by MODUTTA on 18/10/2017 for CR#666
    lst_final-description = v_subs_type.
    IF lst_final IS NOT INITIAL
*    IF lst_final-description IS NOT INITIAL
      AND lst_vbrp-uepos IS INITIAL.
      APPEND lst_final TO fp_i_final.
      CLEAR lst_final.
    ENDIF. " IF lst_final IS NOT INITIAL
***EOC by MODUTTA on 18/10/2017 for CR#666

*************BOC by MODUTTA on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                            doc_line_number = lv_doc_line
                                                            BINARY SEARCH.
    IF sy-subrc EQ 0
      AND lst_tax_data-seller_reg IS NOT INITIAL.
      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
      v_seller_reg = lst_tax_data-seller_reg+0(20).
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
      IF st_header-comp_code_country EQ lst_vbrp-lland.
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space.
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
    ENDIF. " IF sy-subrc EQ 0
*************EOC by MODUTTA on 08/08/2017 for CR# 408****************

*  BOC by MODUTTA on 08/08/2017 for CR#408
    IF st_header-buyer_reg IS INITIAL.
      READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                            doc_line_number = lv_doc_line
                                                            BINARY SEARCH.
      IF sy-subrc EQ 0
        AND lst_vbrp-uepos IS INITIAL.
        CLEAR lst_final.
        lst_final-description = lst_tax_buyer-buyer_reg.
        CONCATENATE lv_text lst_final-description INTO lst_final-description SEPARATED BY space.
        CONDENSE lst_final-description.
        IF lst_final IS NOT INITIAL.
          APPEND lst_final TO fp_i_final.
        ENDIF. " IF lst_final IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF st_header-buyer_reg IS INITIAL

    CLEAR : lst_final,
            lst_vbrp,
            lv_tax,
            lv_amnt,
            lv_subtot,
            lv_fees,
            lv_tax_amount.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp) WHERE vbeln = fp_st_vbrk-vbeln

***BOC by MODUTTA on 15/01/2018 for CR_TBD
  IF lv_kwert IS NOT INITIAL.
    MOVE lv_kwert TO lv_kwert_text.
    REPLACE ALL OCCURRENCES OF '-' IN lv_kwert_text WITH space.
    CONDENSE lv_kwert_text.
    CONCATENATE lv_text_agent lv_kwert_text st_vbrk-waerk INTO v_kwert SEPARATED BY space.
  ENDIF. " IF lv_kwert IS NOT INITIAL
***EOC by MODUTTA on 15/01/2018 for CR_TBD

*  BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
    CONDENSE v_seller_reg.
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_seller_reg IS NOT INITIAL
* EOC by SRBOSE
  APPEND LINES OF li_final TO fp_i_final.

  v_subtotal_val = st_vbrk-netwr.
  IF st_vbrk-zlsch EQ 'J'.
    v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

* Begin of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977
  IF v_subtotal_val EQ 0.
    CLEAR v_paid_amt.
  ENDIF. " IF v_subtotal_val EQ 0
  WRITE v_paid_amt TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
  CONDENSE fp_v_prepaid_amount.
* End of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977

* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.

***BOC by MODUTTA for CR#666 on 18/10/2017
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR#666 on 18/10/2017
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_INV_HEADER
*&---------------------------------------------------------------------*
*  Populate Header data
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  Billing document:Header Data
*      -->FP_I_VBKD
*      -->FP_ST_KNA1
*      <--FP_ST_HEADER  Header data of layout
*----------------------------------------------------------------------*
FORM f_populate_detail_inv_header  USING    fp_st_vbrk   TYPE ty_vbrk
                                            fp_i_vbrp    TYPE tt_vbrp
                                            fp_i_vbpa    TYPE tt_vbpa
                                            fp_i_vbfa    TYPE tt_vbfa
                                            fp_i_vbkd    TYPE tt_vbkd
                                            fp_st_kna1   TYPE ty_kna1
                                            fp_v_country_key TYPE land1                  " Country Key
                                   CHANGING fp_st_header TYPE zstqtc_header_detail_f024. " Structure for Header detail of invoice form

* Data declaration
* Begin of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908961
* DATA : lv_pay_term TYPE char30. " Description of terms of payment
  DATA : lv_pay_term TYPE char50. " Description of terms of payment
* End   of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908961

* Constant Declaration
  CONSTANTS : lc_payer   TYPE parvw VALUE 'RG', " Partner Function
              lc_bp      TYPE parvw VALUE 'RE', " Partner Function
              lc_contact TYPE parvw VALUE 'ZC'. " Partner Function

* Populate Header detail
  fp_st_header-invoice_number = fp_st_vbrk-vbeln. " Invoice Number
* Begin of DEL:ERP-7143:WROY:23-Mar-2018:ED2K911548
* fp_st_header-inv_date       = fp_st_vbrk-erdat. " Invoice Date
* End   of DEL:ERP-7143:WROY:23-Mar-2018:ED2K911548
* Begin of ADD:ERP-7143:WROY:23-Mar-2018:ED2K911548
  fp_st_header-inv_date       = fp_st_vbrk-fkdat. " Invoice Date
* End   of ADD:ERP-7143:WROY:23-Mar-2018:ED2K911548
  fp_st_header-terms          = fp_st_vbrk-zterm. " Payment terms
  fp_st_header-comp_code      = fp_st_vbrk-bukrs. " Company code
  fp_st_header-doc_currency   = fp_st_vbrk-waerk. " Document Currency
  fp_st_header-language       = fp_st_kna1-spras. " Language
  fp_st_header-cust_vat       = fp_st_kna1-stceg. " Customer VAT


  READ TABLE fp_i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = fp_st_vbrk-vbeln
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
*   Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
                                                      posnr = lst_vbrp-aupos
*                                                     posnr = lst_vbrp-posnr
*   End   of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
                                                   BINARY SEARCH.

    IF sy-subrc EQ 0.
*Begin of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
*      fp_st_header-po_number = lst_vbkd-bstkd. " Purchase Order Number
      DATA(lv_flag) = abap_true.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLEAR:lst_vbkd.
      READ TABLE fp_i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbrp-aubel
*     Begin of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
                                          posnr = '000000'
*                                         posnr = '0000'
*     End   of CHANGE:ERP-4930:WROY:01-Nov-2017:ED2K909229
                                          BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_flag = abap_true.
      ENDIF. " IF sy-subrc IS INITIAL
*End of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
    ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

*Begin of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518
  IF lv_flag IS NOT INITIAL.
    fp_st_header-po_number = lst_vbkd-bstkd. " Purchase Order Number
  ENDIF. " IF lv_flag IS NOT INITIAL
*End of Change By SRBOSE on 21-Jul-2017: TR: ED2K907360 #CR_518

  fp_st_header-bill_trust = fp_v_country_key. " Contact country key

***BOC by MODUTTA on 22/01/2018 for CR_TBD
  DATA(li_vbpa) = fp_i_vbpa[].
  DELETE li_vbpa WHERE parvw NE c_we.
  DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr.
  DATA(lv_count_vbpa) = lines( li_vbpa ).
  IF lv_count_vbpa > 1.
    fp_st_header-multiple_shipto = abap_true.
  ENDIF. " IF lv_count_vbpa > 1
***EOC by MODUTTA on 22/01/2018 for CR_TBD

  READ TABLE fp_i_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                    parvw = lc_bp
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-bill_country     = lst_vbpa-land1. " Payer country key
    fp_st_header-bill_cust_number = lst_vbpa-kunnr. " Payer customer number
    fp_st_header-bill_addr_number = lst_vbpa-adrnr. " Payer address number
  ENDIF. " IF sy-subrc EQ 0

  IF fp_st_header-multiple_shipto IS INITIAL. "Added by MODUTTA on 22/01/2018 for CR# 743
    READ TABLE fp_i_vbpa INTO DATA(lst_vbpa1) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                       parvw = c_we
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_st_header-ship_country     = lst_vbpa1-land1. " Contact country key
      fp_st_header-ship_cust_number = lst_vbpa1-kunnr. " Contact customer number
      fp_st_header-ship_addr_number = lst_vbpa1-adrnr. " Contact address number

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_st_header-multiple_shipto IS INITIAL
  READ TABLE fp_i_vbpa INTO DATA(lst_vbpa2) WITH KEY vbeln = fp_st_vbrk-vbeln
                                                     parvw = lc_payer
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-acc_number = lst_vbpa2-kunnr. " Account Number
  ENDIF. " IF sy-subrc EQ 0

* Fetch payment term description
  SELECT SINGLE vtext " Description of terms of payment
       INTO lv_pay_term
   FROM tvzbt         " Customers: Terms of Payment Texts
* Begin of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908961
*  SELECT SINGLE text1 " Own Explanation of Term of Payment
*       INTO lv_pay_term
*   FROM t052u         " Own Explanations for Terms of Payment
* End   of CHANGE:ERP-4426:WROY:24-Oct-2017:ED2K908961
   WHERE spras EQ st_header-language
     AND zterm EQ fp_st_vbrk-zterm.
  IF sy-subrc EQ 0.
    fp_st_header-terms  = lv_pay_term. " Payment terms
  ENDIF. " IF sy-subrc EQ 0

  IF fp_st_vbrk-vbtyp IN r_crd.
    CLEAR fp_st_header-terms.
    fp_st_header-credit_flag = abap_true.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

  SET COUNTRY st_header-bill_country.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_DETAIL
*&---------------------------------------------------------------------*
*  Subroutine to print detail invoice layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_print_layout_detail.

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_upd_tsk          TYPE i,                           " Upd_tsk of type Integers
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name      TYPE fpname  VALUE 'ZQTC_FRM_INV_MNGD_DETAIL_F024', " Name of Form Object
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.                           " Communication Method (Key) (Business Address Services)
  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

**********BOC by MODUTTA on 20/07/2017 for archive****************************
  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf  = abap_true.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
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
**********EOC by MODUTTA on 20/07/2017 for archive****************************

* FM to open job for layout printing
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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
* FM to get adobe form FM name
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
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

* Calling FM to generate detailed invoice
    CALL FUNCTION lv_funcname                "/1BCDWB/SM00000089
      EXPORTING
        /1bcdwb/docparams       = lst_sfpdocparams
        im_header               = st_header
        im_item                 = i_final
        im_xstring              = v_xstring
        im_footer               = v_footer
        im_remit_to             = v_remit_to
        im_v_tax                = v_tax
        im_v_accmngd_title      = v_accmngd_title
        im_v_bank_detail        = v_bank_detail
        im_v_crdt_card_det      = v_crdt_card_det
        im_v_payment_detail     = v_payment_detail
        im_cust_service_det     = v_cust_service_det
        im_v_totaldue           = v_totaldue
        im_v_subtotal           = v_subtotal
        im_v_vat                = v_vat
        im_v_prepaidamt         = v_prepaidamt
        im_v_subtotal_val       = v_subtotal_val
        im_v_sales_tax          = v_sales_tax
        im_v_totaldue_val       = v_totaldue_val
        im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
        im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
        im_v_title              = v_title
        im_v_seller_reg         = v_seller_reg
        im_v_year               = v_year
        im_subtotal_table       = i_subtotal
        im_country_uk           = v_country_uk
        im_v_credit_text        = v_credit_text
        im_v_invoice_desc       = v_invoice_desc
        im_v_payment_detail_inv = v_payment_detail_inv
        im_tax_item             = i_tax_item
        im_text_item            = i_text_item
        im_v_terms_cond         = v_terms_cond
        im_v_kwert              = v_kwert
        im_exc_tab              = i_exc_tab
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
      v_ent_retco = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
    ELSE. " ELSE -> IF sy-subrc <> 0
*     FM to close layout after printing
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

*******************LKODWANI******************
  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                 BINARY SEARCH.

  IF sy-subrc EQ 0.
    IF lst_adrc-deflt_comm = lc_deflt_comm_let
*  Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
   AND v_ent_screen        IS INITIAL.
*  End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
*      AND st_header-bill_country = 'US'.
      PERFORM f_save_pdf_applictn_server.
    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
  ENDIF. " IF sy-subrc EQ 0

**********BOC by MODUTTA on 20/07/2017 for archive****************************
*  post form processing
* Begin of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
  IF lst_sfpoutputparams-arcmode <> '1' AND "Uncomment by MODUTTA on 02/04/2018 ERP-7340
     v_ent_screen IS INITIAL.
*  IF lst_sfpoutputparams-arcmode <> '1' AND                  "Comment by MODUTTA on 02/04/2018 ERP-7340
*     nast-nacha NE '1' AND                     "Print output "Comment by MODUTTA on 02/04/2018 ERP-7340
*     lst_adrc-deflt_comm NE lc_deflt_comm_let. "Letter       "Comment by MODUTTA on 02/04/2018 ERP-7340
* End   of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
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
**********EOC by MODUTTA on 20/07/2017 for archive****************************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_TITLE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_V_ACCMNGD_TITLE  text
*----------------------------------------------------------------------*
FORM f_fetch_title_text USING    fp_st_vbrk             TYPE ty_vbrk
                        CHANGING fp_st_header           TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
                                 fp_v_accmngd_title     TYPE char255                   " V_accmngd_title of type CHAR255
                                 fp_v_reprint           TYPE char255                   " Reprint   " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
                                 fp_v_tax               TYPE thead-tdname              " Name
                                 fp_v_remit_to          TYPE thead-tdname              " Name
                                 fp_v_footer            TYPE thead-tdname              " Name
                                 fp_v_bank_detail       TYPE thead-tdname              " Bank Detail
                                 fp_v_crdt_card_det     TYPE thead-tdname              " Bank Detail
                                 fp_v_payment_detail    TYPE thead-tdname              " Bank Detail
                                 fp_v_cust_service_det  TYPE thead-tdname              " Bank Detail
                                 fp_v_totaldue          TYPE char140                   " V_totaldue of type CHAR140
                                 fp_v_subtotal          TYPE char140                   " V_subtotal of type CHAR140
                                 fp_v_prepaidamt        TYPE char140                   " V_prepaidamt of type CHAR140
                                 fp_v_vat               TYPE char140                   " V_vat of type CHAR140
                                 fp_v_payment_detail_inv   TYPE thead-tdname.          " Name

* Data declaration
  DATA : li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
         li_line   TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text   TYPE string,
         lv_ind    TYPE xegld,                   " Indicator: European Union Member?
         lst_lines TYPE tline,                   " SAPscript: Text Lines
         lst_line  TYPE tline.                   " SAPscript: Text Lines

* Constant Declaration
  CONSTANTS : lc_remit_to     TYPE char20           VALUE 'ZQTC_F024_REMIT_TO_',      " Remit_to of type CHAR20
              lc_crd_card_det TYPE char25           VALUE 'ZQTC_F024_CREDIT_CARD_',   " Crd_card_det of type CHAR22
              lc_paymnt_det   TYPE char25           VALUE 'ZQTC_F024_PAYMNT_DETAIL_', " Paymnt_det of type CHAR20
              lc_cust_service TYPE char25           VALUE 'ZQTC_F024_CUST_SERVICE_',  " Cust_service of type CHAR20
              lc_bank_det     TYPE char25           VALUE 'ZQTC_F024_BANK_DETAIL_',   " Bank details
              lc_footer       TYPE char25           VALUE 'ZQTC_F024_FOOTER_',        " Footer of type CHAR20
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
              lc_remto        TYPE char10         VALUE 'REMIT_TO_',   " Remto of type CHAR10
              lc_xxx          TYPE char3          VALUE 'XXX',         " Xxx of type CHAR3
              lc_crdcd        TYPE char11         VALUE 'CREDIT_CARD', " Crdcd of type CHAR11
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
              lc_undscr       TYPE char1            VALUE '_',                        " Undscr of type CHAR1
              lc_vat          TYPE char3            VALUE 'VAT',                      " Vat of type CHAR3
              lc_tax          TYPE char3            VALUE 'TAX',                      " Tax of type CHAR3
              lc_gst          TYPE char3            VALUE 'GST',                      " Gst of type CHAR3
              lc_class        TYPE char5            VALUE 'ZQTC_',                    " Class of type CHAR5
              lc_devid        TYPE char5            VALUE '_F024',                    " Devid of type CHAR5
              lc_name         TYPE thead-tdname     VALUE 'ZQTC_CREDIT_CARD_PAYMENT', " Name
              lc_st           TYPE thead-tdid       VALUE 'ST',                       "Text ID of text to be read
              lc_object       TYPE thead-tdobject   VALUE 'TEXT'.                     "Object of text to be read


***********************************************************************************
* Subroutine to populate title text
  PERFORM f_populate_title_text USING st_header
                                      st_vbrk
                                      r_country
                             CHANGING fp_v_accmngd_title
                                      fp_v_reprint. "(++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977

*******************************************************************************
* Retrieve all the standard text names

* Fetch Remit to text
  CONCATENATE lc_remit_to
              st_vbrk-bukrs
              lc_undscr
              st_vbrk-waerk
         INTO fp_v_remit_to.
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = fp_v_remit_to
                                                        BINARY SEARCH.
  IF sy-subrc NE 0
*   Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
    OR st_header-bill_country IN r_sanc_countries.
*   End   of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
    CLEAR : fp_v_remit_to.
    CONCATENATE lc_class
                lc_remto
                lc_xxx
                INTO fp_v_remit_to.
  ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
* Populate Bank Details
  CONCATENATE lc_bank_det
              st_vbrk-bukrs
              lc_undscr
              st_vbrk-waerk
         INTO fp_v_bank_detail.
* Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
  IF fp_v_remit_to CS lc_xxx
  OR st_header-bill_country IN r_sanc_countries.
    CLEAR: fp_v_bank_detail.
  ENDIF.
* End   of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793

* Populate Customer Service details
  CONCATENATE lc_cust_service
              st_vbrk-bukrs
              lc_undscr
              st_vbrk-waerk
         INTO fp_v_cust_service_det.
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_cust_service_det
                                                        BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR fp_v_cust_service_det.

* Populate Customer Service details
    CONCATENATE lc_cust_service
                st_vbrk-bukrs
                lc_undscr
                lc_xxx
         INTO   fp_v_cust_service_det.
  ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
******************************************************************
  IF v_invoice_desc IS NOT INITIAL. "Added by MODUTTA on 27/10/2017
    CONCATENATE v_invoice_desc v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .

* Populate Payment detail
    CONCATENATE lc_paymnt_det
                st_vbrk-bukrs
                lc_undscr
                st_vbrk-waerk
           INTO fp_v_payment_detail.
    CLEAR li_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = lc_st
        language                = st_header-language
        name                    = fp_v_payment_detail
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
        CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        CLEAR lv_text.
        CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF v_invoice_desc IS NOT INITIAL
* Populate Payment detail
    CONCATENATE lc_paymnt_det
                st_vbrk-bukrs
                lc_undscr
                st_vbrk-waerk
           INTO fp_v_payment_detail.
    CLEAR li_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = lc_st
        language                = st_header-language
        name                    = fp_v_payment_detail
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
        CONCATENATE lv_text v_terms_cond INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_invoice_desc IS NOT INITIAL
******BOC by SRBOSE for CR# 558 on 08/31/2017***********************
  IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL.
    CLEAR: li_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = lc_st
        language                = st_header-language
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
      READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX 1.
      IF sy-subrc IS INITIAL.
        REPLACE '&V_CREDIT&' WITH v_ccnum INTO <lst_lines>-tdline.
      ENDIF. " IF sy-subrc IS INITIAL
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_lines
        IMPORTING
          ev_text_string = lv_text.
      IF sy-subrc EQ 0.
        CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ELSEIF fp_st_vbrk-vbtyp NOT IN r_crd. " ELSE -> IF v_paid_amt GT 0
******EOC by SRBOSE for CR# 558 on 08/08/2017***********************
    IF v_totaldue_val > 0.
* Populate Credit card detail
      CONCATENATE lc_crd_card_det
                  st_vbrk-bukrs
                  lc_undscr
                  st_vbrk-waerk
             INTO fp_v_crdt_card_det.
***BOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
      READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = fp_v_crdt_card_det
                                                            BINARY SEARCH.
      IF sy-subrc NE 0
*     Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
      OR st_header-bill_country IN r_sanc_countries.
*     End   of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
        CLEAR : fp_v_crdt_card_det.
*       CONCATENATE lc_class
*                   lc_crdcd
*                   lc_undscr
*                   lc_xxx
*                   INTO fp_v_crdt_card_det.
        CONCATENATE lc_crd_card_det
                    lc_xxx
                    INTO fp_v_crdt_card_det.
      ENDIF. " IF sy-subrc NE 0
***EOC SAYANDAS on 16-Mar-2018 for ERP_6599 TR  ED2K911412
      CLEAR: li_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_st
          language                = st_header-language
          name                    = fp_v_crdt_card_det
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
          CONCATENATE v_terms_cond lv_text INTO v_terms_cond SEPARATED BY cl_abap_char_utilities=>cr_lf .
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF v_totaldue_val > 0
  ENDIF. " IF v_paid_amt GT 0 AND fp_st_vbrk-vbtyp IN r_crd AND v_ccnum IS NOT INITIAL
******************************************************************

* Fetch Footer text
  CONCATENATE lc_footer
              st_vbrk-bukrs
         INTO fp_v_footer.
  CONDENSE fp_v_footer.
**********************************************************************
* Begin of change: PBOSE: 10-May-2017: Defect 1990 : ED2K905977
** Populate country name if bill to country and ship to country same
*  IF st_header-bill_country EQ st_header-ship_country.
**   Retrieve Bill to country name(text)
*    SELECT SINGLE landx " Country Name
*           FROM   t005t " Country Names
*           INTO fp_v_country_key
*           WHERE spras = st_header-language
*             AND land1 = st_header-bill_country.
*    IF sy-subrc NE 0.
*      CLEAR fp_v_country_key.
*    ENDIF. " IF sy-subrc NE 0
*
*  ENDIF. " IF st_header-bill_country EQ st_header-ship_country
* End of change: PBOSE: 10-May-2017: Defect 1990 : ED2K905977
**********************************************************************

**********************************************************************
* Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO fp_v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO fp_v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO fp_v_tax.

*  ENDIF. " IF v_ind EQ abap_true

**********************************************************************
* Populate order header text
  PERFORM f_populate_header_text USING    st_header
                                 CHANGING fp_st_header.
**********************************************************************
  CLEAR : li_lines,
          lv_text.
* Retrieve Tax/VAT values and add with document currency value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_v_tax
      object                  = c_object
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
      CONCATENATE lv_text st_header-doc_currency INTO fp_v_vat SEPARATED BY space.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF sy-subrc EQ 0

**********************************************************************
* Retrieve text module values and add with document currency value

  CLEAR : i_txtmodule,
          lst_line.
* Fetch sub-total text from text module
  PERFORM f_get_text      USING c_subtotal
                                st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
    CONCATENATE lst_line-tdline st_header-doc_currency INTO v_subtotal SEPARATED BY space.
    CONDENSE v_subtotal.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line


  CLEAR : i_txtmodule,
          lst_line.
* Fetch Total due text from text module
  PERFORM f_get_text      USING c_totaldue
                                st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
    CONCATENATE lst_line-tdline st_header-doc_currency INTO v_totaldue SEPARATED BY space.
    CONDENSE v_totaldue.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line

  CLEAR : i_txtmodule,
          lst_line.
* Fetch prepaid amount text from text module
  PERFORM f_get_text      USING c_prepaidamt
                                st_header
                       CHANGING i_txtmodule.

  LOOP AT i_txtmodule INTO lst_line.
    CONCATENATE lst_line-tdline st_header-doc_currency INTO v_prepaidamt SEPARATED BY space.
    CONDENSE v_prepaidamt.
  ENDLOOP. " LOOP AT i_txtmodule INTO lst_line

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*  Send mail and email attachment to the customer
*----------------------------------------------------------------------*
FORM f_send_mail_attach_summary.

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_msgv_formnm      TYPE syst_msgv,       " Message Variable
        lv_form_name        TYPE fpname,          " Name of Form Object
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: "lc_form_name TYPE fpname   VALUE 'ZQTC_FRM_INV_SUMMARY_MNGD_F024', " Name of Form Object
    lc_form_name_hd TYPE fpname VALUE 'ZQTC_FRM_INV_MN_DETAIL_F024_HD', " Name of Form Object
    lc_form_name_li TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_LT',
    lc_form_name_fr TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_IT',
    lc_msgnr_165    TYPE sy-msgno VALUE '165',                            " ABAP System Field: Message Number
    lc_msgnr_166    TYPE sy-msgno VALUE '166',                            " ABAP System Field: Message Number
    lc_msgid        TYPE sy-msgid VALUE 'ZQTC_R2',                        " ABAP System Field: Message ID
    lc_err          TYPE sy-msgty VALUE 'E'.                              " ABAP System Field: Message Type

  IF v_ent_retco IS NOT INITIAL.
    RETURN.
  ENDIF.
  IF st_formoutput-pdf IS INITIAL.
    lv_form_name = tnapr-sform.
    lv_msgv_formnm = tnapr-sform. " Added by PBANDLAPAL
    lst_sfpoutputparams-getpdf = abap_true.
    lst_sfpoutputparams-nodialog = abap_true.
    lst_sfpoutputparams-preview = abap_false.

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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
            .
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF lr_text IS NOT INITIAL
      ENDTRY.

*   Call function module to generate Summary invoice
      CALL FUNCTION lv_funcname                " /1BCDWB/SM00000091
        EXPORTING
          /1bcdwb/docparams       = lst_sfpdocparams
          im_header               = st_header
          im_item                 = i_final
          im_xstring              = v_xstring
          im_footer               = v_footer
          im_remit_to             = v_remit_to
          im_v_tax                = v_tax
          im_v_accmngd_title      = v_accmngd_title
          im_v_bank_detail        = v_bank_detail
          im_v_crdt_card_det      = v_crdt_card_det
          im_v_payment_detail     = v_payment_detail
          im_cust_service_det     = v_cust_service_det
          im_v_totaldue           = v_totaldue
          im_v_subtotal           = v_subtotal
          im_v_vat                = v_vat
          im_v_prepaidamt         = v_prepaidamt
          im_v_subtotal_val       = v_subtotal_val
          im_v_sales_tax          = v_sales_tax
          im_v_totaldue_val       = v_totaldue_val
          im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
          im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
          im_v_title              = v_title
          im_v_seller_reg         = v_seller_reg
          im_v_year               = v_year
          im_subtotal_table       = i_subtotal
          im_country_uk           = v_country_uk
          im_v_credit_text        = v_credit_text
          im_v_invoice_desc       = v_invoice_desc
          im_v_payment_detail_inv = v_payment_detail_inv
          im_tax_item             = i_tax_item
          im_text_item            = i_text_item
          im_v_terms_cond         = v_terms_cond
          im_v_kwert              = v_kwert
          im_exc_tab              = i_exc_tab
        IMPORTING
          /1bcdwb/formoutput      = st_formoutput
        EXCEPTIONS
          usage_error             = 1
          system_error            = 2
          internal_error          = 3
          OTHERS                  = 4.

      IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
        v_ent_retco = 900.
        RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0

    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF.

* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  IF st_formoutput-pdf IS INITIAL.
*   Message: Error occurred generating PDF file
    MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
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
  ENDIF. " IF st_formoutput-pdf IS INITIAL
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.

* Subroutine to send mail attachment
  PERFORM f_mail_attachment.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_SUMMARY
*&---------------------------------------------------------------------*
* Layout for Summary invoice
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_print_layout_summary .
* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_upd_tsk          TYPE i,                           " Upd_tsk of type Integers
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name_hd   TYPE fpname VALUE 'ZQTC_FRM_INV_MN_DETAIL_F024_HD', " Name of Form Object
             lc_form_name_li   TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_LT',
             lc_form_name_fr   TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_IT',
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.                           " Communication Method (Key) (Business Address Services)
  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf  = abap_true.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
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

**   Call function module to generate Summary invoice
    CALL FUNCTION lv_funcname                " /1BCDWB/SM00000091
      EXPORTING
        /1bcdwb/docparams       = lst_sfpdocparams
        im_header               = st_header
        im_item                 = i_final
        im_xstring              = v_xstring
        im_footer               = v_footer
        im_remit_to             = v_remit_to
        im_v_tax                = v_tax
        im_v_accmngd_title      = v_accmngd_title
        im_v_bank_detail        = v_bank_detail
        im_v_crdt_card_det      = v_crdt_card_det
        im_v_payment_detail     = v_payment_detail
        im_cust_service_det     = v_cust_service_det
        im_v_totaldue           = v_totaldue
        im_v_subtotal           = v_subtotal
        im_v_vat                = v_vat
        im_v_prepaidamt         = v_prepaidamt
        im_v_subtotal_val       = v_subtotal_val
        im_v_sales_tax          = v_sales_tax
        im_v_totaldue_val       = v_totaldue_val
        im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
        im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
        im_v_title              = v_title
        im_v_seller_reg         = v_seller_reg
        im_subtotal_table       = i_subtotal
        im_country_uk           = v_country_uk
        im_v_credit_text        = v_credit_text
        im_v_invoice_desc       = v_invoice_desc
        im_v_payment_detail_inv = v_payment_detail_inv
        im_tax_item             = i_tax_item
        im_text_item            = i_text_item
        im_v_terms_cond         = v_terms_cond
        im_v_kwert              = v_kwert
        im_exc_tab              = i_exc_tab
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

*******************LKODWANI******************
  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                 BINARY SEARCH.

  IF sy-subrc EQ 0.
    IF lst_adrc-deflt_comm = lc_deflt_comm_let
*  Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
   AND v_ent_screen        IS INITIAL.
*  End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
*      AND st_header-bill_country = 'US'.
      PERFORM f_save_pdf_applictn_server.
    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
  ENDIF. " IF sy-subrc EQ 0

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
*  post form processing
* Begin of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
  IF lst_sfpoutputparams-arcmode <> '1' AND "Unomment by MODUTTA on 02/04/2018 ERP-7340
     v_ent_screen IS INITIAL.
*  IF lst_sfpoutputparams-arcmode <> '1' AND                  "Comment by MODUTTA on 02/04/2018 ERP-7340
*     nast-nacha NE '1' AND                     "Print output "Comment by MODUTTA on 02/04/2018 ERP-7340
*     lst_adrc-deflt_comm NE lc_deflt_comm_let. "Letter       "Comment by MODUTTA on 02/04/2018 ERP-7340
* End   of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_CONSORTIA
*&---------------------------------------------------------------------*
* Layout for Consortia form
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
FORM f_adobe_print_layout_consortia .
* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_upd_tsk          TYPE i,                           " Upd_tsk of type Integers
        lv_funcname         TYPE funcname,                    " Function name
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name      TYPE fpname VALUE 'ZQTC_FRM_INV_CONSOTIA_MGD_F024', " Name of Form Object
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.                           " Communication Method (Key) (Business Address Services)
  lv_form_name = tnapr-sform.
  lst_sfpoutputparams-preview = abap_true.

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
* Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_sfpoutputparams-getpdf  = abap_true.
* End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************

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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  ELSE. " ELSE -> IF sy-subrc <> 0
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_form_name "lc_form_name
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

*   Call FM to generate Consortia invoice
    CALL FUNCTION lv_funcname                " /1BCDWB/SM00000090
      EXPORTING
        /1bcdwb/docparams       = lst_sfpdocparams
        im_header               = st_header
        im_item                 = i_final
        im_xstring              = v_xstring
        im_footer               = v_footer
        im_remit_to             = v_remit_to
        im_v_tax                = v_tax
        im_v_accmngd_title      = v_accmngd_title
        im_v_bank_detail        = v_bank_detail
        im_v_crdt_card_det      = v_crdt_card_det
        im_v_payment_detail     = v_payment_detail
        im_cust_service_det     = v_cust_service_det
        im_v_totaldue           = v_totaldue
        im_v_subtotal           = v_subtotal
        im_v_vat                = v_vat
        im_v_prepaidamt         = v_prepaidamt
        im_v_subtotal_val       = v_subtotal_val
        im_v_sales_tax          = v_sales_tax
        im_v_totaldue_val       = v_totaldue_val
        im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
        im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
        im_v_title              = v_title
        im_v_seller_reg         = v_seller_reg
        im_subtotal_table       = i_subtotal
        im_country_uk           = v_country_uk
        im_v_credit_text        = v_credit_text
        im_v_invoice_desc       = v_invoice_desc
        im_v_payment_detail_inv = v_payment_detail_inv
        im_tax_item             = i_tax_item
        im_text_item            = i_text_item
        im_v_terms_cond         = v_terms_cond
        im_v_kwert              = v_kwert
        im_exc_tab              = i_exc_tab
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
      v_ent_retco = 900.
      RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
    ELSE. " ELSE -> IF sy-subrc <> 0
*     fm to close layout after printing
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

*******************LKODWANI******************
  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                 BINARY SEARCH.

  IF sy-subrc EQ 0.
    IF lst_adrc-deflt_comm = lc_deflt_comm_let
*  Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
   AND v_ent_screen        IS INITIAL.
*  End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
*      AND st_header-bill_country = 'US'.
      PERFORM f_save_pdf_applictn_server.
    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
  ENDIF. " IF sy-subrc EQ 0

************BOC by MODUTTA on 18.07.2017 for print & archive****************************
*  post form processing
* Begin of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
  IF lst_sfpoutputparams-arcmode <> '1' AND "Uncomment by MODUTTA on 02/04/2018 ERP-7340
     v_ent_screen        IS INITIAL.
*  IF lst_sfpoutputparams-arcmode <> '1' AND                  "Comment by MODUTTA on 02/04/2018 ERP-7340
*     nast-nacha NE '1' AND                     "Print output "Comment by MODUTTA on 02/04/2018 ERP-7340
*     lst_adrc-deflt_comm NE lc_deflt_comm_let. "Letter       "Comment by MODUTTA on 02/04/2018 ERP-7340
* End   of ADD:ERP-4981:WROY:12-Dec-2017:ED2K909761
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
************EOC by MODUTTA on 18.07.2017 for print & archive****************************
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*   Retrieve Constant values
*----------------------------------------------------------------------*
*      <--FP_V_CONSORTIA  Value of consortium invoice
*      <--FP_V_DETAIL     Value of detail invoice
*      <--FP_V_SUMMARY    Value of summary invoice
*      <--FP_LR_INV        Value of invoice type
*      <--FP_LR_CRD        Value of credit memo type
*      <--FP_LR_DBT        Value of debit memo type
*----------------------------------------------------------------------*
FORM f_get_constant  CHANGING fp_v_outputyp_consor  TYPE sna_kschl   " Attribute 6
                              fp_v_outputyp_detail  TYPE sna_kschl   " Attribute 6
                              fp_v_outputyp_summary TYPE sna_kschl   " Attribute 6
                              fp_r_inv              TYPE tt_billtype " Invoice type
                              fp_r_crd              TYPE tt_billtype " Credit memo type
                              fp_v_country_key      TYPE land1       " Country code
                              fp_r_dbt              TYPE tt_billtype " Debit Memo Type
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                              fp_i_tax_id           TYPE tt_tax_id         " Tax IDs
                              fp_r_mtart_med_issue  TYPE fip_t_mtart_range " Material Types: Media Issues
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
                              fp_r_country          TYPE tt_country. " Country values

* Constant Declaration
  CONSTANTS : lc_summary       TYPE rvari_vnam VALUE 'SUMMARY',       " ABAP: Name of Variant Variable
              lc_consortia     TYPE rvari_vnam VALUE 'CONSORTIA',     " ABAP: Name of Variant Variable
              lc_detail        TYPE rvari_vnam VALUE 'DETAIL',        " ABAP: Name of Variant Variable
              lc_bill_type_inv TYPE rvari_vnam VALUE 'BILL_TYPE_INV', " ABAP: Name of Variant Variable
              lc_bill_type_zcr TYPE rvari_vnam VALUE 'BILL_TYPE_ZCR', " ABAP: Name of Variant Variable
              lc_bill_type_zdr TYPE rvari_vnam VALUE 'BILL_TYPE_ZDR', " ABAP: Name of Variant Variable
              lc_country       TYPE rvari_vnam VALUE 'COUNTRY',       " Country Code
              lc_country_title TYPE rvari_vnam VALUE 'COUNTRY_TITLE', " Country name
              lc_devid         TYPE zdevid VALUE 'F024',              " Development ID
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
              lc_tax_id        TYPE rvari_vnam VALUE 'TAX_ID',          " TAX IDs
              lc_mtart_med_iss TYPE rvari_vnam VALUE 'MTART_MED_ISSUE', " Material Type: Media Issue
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
              lc_country_uk    TYPE rvari_vnam VALUE 'COUNTRY_UK',    " Country Code ++ srbose
              lc_faz           TYPE rvari_vnam VALUE 'BILL_TYPE_FAZ', " ABAP: Name of Variant Variable
              lc_vkorg         TYPE rvari_vnam VALUE 'VKORG',         " ABAP: Name of Variant Variable
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362

***BOC by MODUTTA for CR#666 on 18/10/2017
              lc_inv_desc      TYPE rvari_vnam VALUE 'INV_DESC',    " ABAP: Name of Variant Variable
              lc_sub_typ_di    TYPE rvari_vnam VALUE 'SUB_TYPE_DI', " ABAP: Name of Variant Variable
              lc_sub_typ_ph    TYPE rvari_vnam VALUE 'SUB_TYPE_PH', " ABAP: Name of Variant Variable
              lc_sub_typ_mm    TYPE rvari_vnam VALUE 'SUB_TYPE_MM', " ABAP: Name of Variant Variable
              lc_sub_typ_se    TYPE rvari_vnam VALUE 'SUB_TYPE_SE', " ABAP: Name of Variant Variable
***BOC by MODUTTA for CR#666 on 18/10/2017
              lc_idcodetype    TYPE rvari_vnam VALUE 'IDCODETYPE',
***     BOC by MODUTTA on 14/01/2018 for CR# TBD
              lc_cond_type     TYPE rvari_vnam VALUE 'COND_TYPE',
*             Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
              lc_sanctioned_c  TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*             End   of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
              lc_email_id      TYPE rvari_vnam VALUE 'EMAIL_ID'.           " ABAP: Name of Variant Variable
***     EOC by MODUTTA on 14/01/2018 for CR# TBD

* Data Declaration
  DATA :           lst_country TYPE ty_country,  " Country key
                   lst_inv     TYPE ty_billtype, " WA for invoice
                   lst_crd     TYPE ty_billtype, " WA for credit memo
                   lst_dbt     TYPE ty_billtype. " WA for debit memo

* Fetch values from constant table
  SELECT  devid,     " Development ID
          param1,    " ABAP: Name of Variant Variable
          param2,    " ABAP: Name of Variant Variable
          srno,      " ABAP: Current selection number
          sign,      " ABAP: ID: I/E (include/exclude values)
          opti,      " ABAP: Selection option (EQ/BT/CP/..)
          low,       " Lower Value of Selection Condition
          high,      " Upper Value of Selection Condition
          activate   " Activation indicator for constant
    INTO TABLE @DATA(li_constant)
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid EQ @lc_devid
      AND activate EQ @abap_true.

  IF sy-subrc EQ 0.
    SORT li_constant BY devid param1.
*   Loop through constant table to retrieve constant values
    LOOP AT li_constant INTO DATA(lst_constant).
      IF lst_constant-param1 EQ lc_summary.
        fp_v_outputyp_summary = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_summary
      IF lst_constant-param1 EQ lc_detail.
        fp_v_outputyp_detail = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_detail
      IF lst_constant-param1 EQ lc_consortia.
        fp_v_outputyp_consor = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_consortia
      IF lst_constant-param1 EQ lc_bill_type_inv.
        lst_inv-sign = lst_constant-sign.
        lst_inv-opti = lst_constant-opti.
        lst_inv-low  = lst_constant-low.
        APPEND lst_inv TO fp_r_inv.
        CLEAR lst_inv.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_inv
      IF lst_constant-param1 EQ lc_bill_type_zcr.
        lst_crd-sign = lst_constant-sign.
        lst_crd-opti = lst_constant-opti.
        lst_crd-low  = lst_constant-low.
        APPEND lst_crd TO fp_r_crd.
        CLEAR lst_crd.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_zcr
      IF lst_constant-param1 EQ lc_bill_type_zdr.
        lst_dbt-sign = lst_constant-sign.
        lst_dbt-opti = lst_constant-opti.
        lst_dbt-low  = lst_constant-low.
        APPEND lst_dbt TO fp_r_dbt.
        CLEAR lst_dbt.
      ENDIF. " IF lst_constant-param1 EQ lc_bill_type_zdr
      IF lst_constant-param1 EQ lc_country.
        fp_v_country_key = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_country
      IF lst_constant-param1 EQ lc_country_title.
        lst_country-sign  = lst_constant-sign.
        lst_country-opti  = lst_constant-opti.
        lst_country-low   = lst_constant-low.
        APPEND lst_country TO fp_r_country.
        CLEAR lst_country.
      ENDIF. " IF lst_constant-param1 EQ lc_country_title
* Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
      IF lst_constant-param1 EQ lc_faz.
        v_faz = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_faz
      IF lst_constant-param1 EQ lc_vkorg.
        v_vkorg = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_vkorg
      IF lst_constant-param1 EQ lc_country_uk.
        v_country_uk = lst_constant-low+0(3).
      ENDIF. " IF lst_constant-param1 EQ lc_country_uk
* End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
      IF lst_constant-param1 EQ lc_tax_id. " TAX IDs
        APPEND INITIAL LINE TO fp_i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>).
        <lst_tax_id>-land1 = lst_constant-param2.
        <lst_tax_id>-stceg = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_tax_id
      IF lst_constant-param1 EQ lc_mtart_med_iss. " Material Types: Media Issues
        APPEND INITIAL LINE TO fp_r_mtart_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
        <lst_med_issue>-sign   = lst_constant-sign.
        <lst_med_issue>-option = lst_constant-opti.
        <lst_med_issue>-low    = lst_constant-low.
        <lst_med_issue>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_mtart_med_iss
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
      IF lst_constant-param1 EQ lc_inv_desc.
        v_inv_desc = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_inv_desc
***     BOC by MODUTTA on 18/10/2017 for CR# 666
      IF lst_constant-param1 EQ lc_sub_typ_di.
        v_sub_type_di = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_di
      IF lst_constant-param1 EQ lc_sub_typ_ph.
        v_sub_type_ph = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_ph
      IF lst_constant-param1 EQ lc_sub_typ_mm.
        v_sub_type_mm = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_mm
      IF lst_constant-param1 EQ lc_sub_typ_se.
        v_sub_type_se = lst_constant-low.
      ENDIF. " IF lst_constant-param1 EQ lc_sub_typ_se
***     EOC by MODUTTA on 18/10/2017 for CR# 666
      IF lst_constant-param1 EQ lc_idcodetype. " Type of identification code
        APPEND INITIAL LINE TO r_idcodetype ASSIGNING FIELD-SYMBOL(<lst_idcodetype>).
        <lst_idcodetype>-sign   = lst_constant-sign.
        <lst_idcodetype>-option = lst_constant-opti.
        <lst_idcodetype>-low    = lst_constant-low.
        <lst_idcodetype>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_idcodetype
***     BOC by MODUTTA on 14/01/2018 for CR# TBD
      IF lst_constant-param1 EQ lc_cond_type.
        v_cond_type = lst_constant-low. "Agent discount type
      ENDIF. " IF lst_constant-param1 EQ lc_cond_type

      IF lst_constant-param1 EQ lc_email_id.
        APPEND INITIAL LINE TO r_email ASSIGNING FIELD-SYMBOL(<lst_email>).
        <lst_email>-sign   = lst_constant-sign.
        <lst_email>-option = lst_constant-opti.
        <lst_email>-low    = lst_constant-low.
        <lst_email>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_email_id
***     EOC by MODUTTA on 14/01/2018 for CR# TBD

*     Begin of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
      IF lst_constant-param1 EQ lc_sanctioned_c.
        APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
        <lst_sanc_country>-sign   = lst_constant-sign.
        <lst_sanc_country>-option = lst_constant-opti.
        <lst_sanc_country>-low    = lst_constant-low.
        <lst_sanc_country>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 EQ lc_sanctioned_c
*     End of ADD:ERP-6599:MODUTTA:04-Apr-2018:ED2K911793
    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc EQ 0

*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
  SORT fp_i_tax_id BY land1.
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_SUMM_ITEM
*&---------------------------------------------------------------------*
*  Populate Final table for summary invoice
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK  VBRK structure
*      -->FP_I_VBRP   VBRP table
*      <--P_I_FINAL   Final table
*----------------------------------------------------------------------*
FORM f_populate_detail_summ_item  USING    fp_st_vbrk          TYPE ty_vbrk
                                           fp_i_vbrp           TYPE tt_vbrp
                                           fp_v_paid_amt       TYPE autwr  " Payment cards: Authorized amount
                                  CHANGING fp_i_final          TYPE ztqtc_item_detail_f024
                                           fp_v_prepaid_amount TYPE char20 " V_prepaid_amount of type CHAR20
                                           fp_i_subtotal         TYPE ztqtc_subtotal_f024.

* Data Declaration
  DATA : li_final     TYPE ztqtc_item_detail_f024,
         v_journal    TYPE char255,                 " Journal of type CHAR255
         lv_fees      TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_due       TYPE kzwi2,                   " Subtotal 2 from pricing procedure for condition
         lv_discount  TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
         lv_discount1 TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
         lv_amount    TYPE char14,                  " Amount of type CHAR14
         lv_subtotal  TYPE kzwi3,                   " Subtotal 3 from pricing procedure for condition
         lv_tax       TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
         lv_tax1      TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
         lv_total     TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
         lst_final    TYPE zstqtc_item_detail_f024, " Structure for Item table
         lv_text_id   TYPE tdid,                    " Text ID
         lv_doc_line  TYPE /idt/doc_line_number,    "(++)MODUTTA on 08/08/2017 for CR#408
         lv_buyer_reg TYPE char255.                 "(++)MODUTTA on 08/08/2017 for CR#408

* Constant declaration
  CONSTANTS : lc_first  TYPE char1 VALUE '(', " First of type CHAR1
              lc_second TYPE char1 VALUE ')', " Second of type CHAR1
*** BOC BY SAYANDAS
              lc_minus  TYPE char1 VALUE '-'. " Minus of type CHAR1
*** EOC BY SAYANDAS

*  BOC by SRBOSE
  DATA : li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text   TYPE string,
         lv_ind    TYPE xegld,                   " Indicator: European Union Member?
         lst_line  TYPE tline,                   " SAPscript: Text Lines
         lst_lines TYPE tline.                   " SAPscript: Text Lines

  DATA:  lv_kbetr_desc      TYPE p DECIMALS 3,         " Rate (condition amount or percentage)
         lv_kbetr_char      TYPE char15,               " Kbetr_char of type CHAR15
         lst_komp           TYPE komp,                 " Communication Item for Pricing
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         lst_tax_item_final TYPE zstqtc_tax_item_f024, " Structure for tax components
         lv_taxable_amt     TYPE kzwi1,                " Subtotal 1 from pricing procedure for condition
         lv_tax_amount      TYPE kzwi6,                " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE p DECIMALS 3,         " Rate (condition amount or percentage)
         lv_mat_text        TYPE string,               " Material Text
         lv_tdname          TYPE thead-tdname,         " Name
         lv_kbetr           TYPE kbetr,                " Rate (condition amount or percentage)
         lv_text_tax        TYPE string,               "Added by MODUTTA on 22/01/2018 for CR# TBD
         lv_text_agent      TYPE string,               "Added by MODUTTA on 22/01/2018 for CR# TBD
         lv_kwert           TYPE kwert,                " Condition value "Added by MODUTTA on 22/01/2018 for CR# TBD
         lv_kwert_text      TYPE char50,               " Kwert_text of type CHAR50 "Added by MODUTTA on 22/01/2018 for CR# TBD
         lv_flag_di         TYPE xfeld,                " Checkbox
         lv_flag_ph         TYPE xfeld,                " Checkbox
         lv_flag_se         TYPE xfeld.                " Checkbox

  CONSTANTS:lc_undscr     TYPE char1      VALUE '_',                                 " Undscr of type CHAR1
            lc_vat        TYPE char3      VALUE 'VAT',                               " Vat of type CHAR3
            lc_tax        TYPE char3      VALUE 'TAX',                               " Tax of type CHAR3
            lc_gst        TYPE char3      VALUE 'GST',                               " Gst of type CHAR3
            lc_class      TYPE char5      VALUE 'ZQTC_',                             " Class of type CHAR5
            lc_devid      TYPE char5      VALUE '_F024',                             " Devid of type CHAR5
            lc_colon      TYPE char1      VALUE ':',                                 " Colon of type CHAR1
            lc_percent    TYPE char1 VALUE '%',                                      " Percent of type CHAR1               " Text ID
            lc_digital    TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',                   " Name
            lc_print      TYPE tdobname VALUE 'ZQTC_F024_PRINT',                     " Name
            lc_mixed      TYPE tdobname VALUE 'ZQTC_F024_MIXED',                     " Name
            lc_shipping   TYPE tdobname VALUE 'ZQTC_F024_SHIPPING',                  " Name
            lc_text_id    TYPE tdid     VALUE 'ST',                                  " Text ID
            lc_tax_text   TYPE tdobname VALUE 'ZQTC_TAX_F024',                       " Name
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
            lc_agent_dis  TYPE thead-tdname VALUE 'ZQTC_F024_AGENT_DISCOUNT'.        " Name

  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

*  * Fetch VAT/TAX/GST based on condition
*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
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
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
*  EOC by SRBOSE

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CLEAR: li_lines[].
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
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
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0


** Populate Agent Discount Text
  CLEAR li_lines[].
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_agent_dis
      object                  = c_object
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
        ev_text_string = lv_text_agent.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_agent.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD

***BOC by MODUTTA on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kschl,
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
*      AND   kposn = fp_st_vbap-posnr.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
    DATA(li_konv) = li_tkomv[].
    SORT li_konv BY kposn kschl.
    DELETE li_konv WHERE kschl NE v_cond_type.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    DELETE li_tkomv WHERE kawrt IS INITIAL.
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
***EOC by MODUTTA on 17/10/2017 for CR#666

* Populate final table
  DATA(li_vbrp) = fp_i_vbrp[].
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp) WHERE vbeln = fp_st_vbrk-vbeln.

*Begin of ADD:ERP-4743:WROY:09-OCT-2017:ED2K908785
*   Consider Gross / Net Value for BOM Header Only
    IF lst_vbrp-uepos IS NOT INITIAL.
      CLEAR: lst_vbrp-kzwi1,
             lst_vbrp-kzwi2,
             lst_vbrp-kzwi3.
    ENDIF. " IF lst_vbrp-uepos IS NOT INITIAL
*   Do Not consider Gross / Net Value for BOM Header
*   READ TABLE fp_i_vbrp TRANSPORTING NO FIELDS
*        WITH KEY uepos = lst_vbrp-posnr.
*   IF sy-subrc EQ 0.
*     CLEAR: lst_vbrp-kzwi1,
*            lst_vbrp-kzwi2,
*            lst_vbrp-kzwi3.
*   ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4743:WROY:09-OCT-2017:ED2K908785

**          BOC by MODUTTA on 15/01/2018 for CR# TBD
    READ TABLE li_konv INTO DATA(lst_konv) WITH KEY kposn = lst_vbrp-posnr
                                                    kschl = v_cond_type
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_kwert = lv_kwert + lst_konv-kwert.
    ENDIF. " IF sy-subrc EQ 0
**          EOC by MODUTTA on 15/01/2018 for CR# TBD

****BOC by MODUTTA for CR# 666 on 18/10/12017
*   For Digital,Print,Combined and Shipping
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp-matnr
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_di IS INITIAL.
          lv_flag_di = abap_true.
        ENDIF. " IF lv_flag_di IS INITIAL
      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_ph IS INITIAL.
          lv_flag_ph = abap_true.
        ENDIF. " IF lv_flag_ph IS INITIAL

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_se IS INITIAL.
          lv_flag_se = abap_true.
        ENDIF. " IF lv_flag_se IS INITIAL
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*   Begin of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911366
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911366
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp-kzwi6.

    IF lst_vbrp-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS NOT INITIAL.
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lst_tax_item-taxable_amt IS NOT INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
***EOC by MODUTTA for CR_743

********************************FEES*********************************
    lv_fees = lst_vbrp-kzwi1 + lv_fees.
********************************FEES*********************************
*******************************DISCOUNT******************************
* If discount value is 0, then show the value in braces to indicate
* negative value
    lv_discount = lst_vbrp-kzwi5 + lv_discount.

*******************************DISCOUNT******************************
***************************TAX-AMOUNT********************************
    lv_tax = lv_tax + lst_vbrp-kzwi6.
***************************TAX-AMOUNT********************************

*************BOC by MODUTTA on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
*   lv_doc_line = lst_vbrp-posnr+2(4).
    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0
       AND lst_tax_data-seller_reg IS NOT INITIAL.
      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
    ELSEIF lst_vbrp-kzwi6 IS NOT INITIAL.
*     Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
*     IF lst_vbrp-aland EQ lst_vbrp-lland.
*     End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
*     Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
      IF st_header-comp_code_country EQ lst_vbrp-lland.
*     End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space.
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp-lland
*   Buyer Reg
*      lv_buyer_reg = lst_tax_data-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0

*************EOC by MODUTTA on 08/08/2017 for CR# 408****************
    CLEAR lst_vbrp.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp) WHERE vbeln = fp_st_vbrk-vbeln

* BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
*   BOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908436
*   CONCATENATE lv_text v_seller_reg INTO v_seller_reg SEPARATED BY lc_colon.
*   EOC by MODUTTA on 12/09/2017 for JIRA#:ERP-4276 TR# ED2K908436
    CONDENSE v_seller_reg.
*Begin of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
* Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
* ELSEIF st_header-bill_country EQ st_header-ship_country.
* End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
* Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
* End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4093:WROY:14-SEP-2017:ED2K908554
  ENDIF. " IF v_seller_reg IS NOT INITIAL
* EOC by SRBOSE

***Subtotal
  lv_subtotal = lv_fees + lv_discount.

***Total
  lv_total = lv_subtotal + lv_tax.

  SET COUNTRY st_header-bill_country.
* Fees Value
  IF fp_st_vbrk-vbtyp IN r_crd
     AND lv_fees GT 0.
    WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk. " Fees
    CONDENSE lst_final-fees.
    CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    IF lv_fees LT 0.
      WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk. " Fees
      CONDENSE lst_final-fees.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst_final-fees.
    ELSE. " ELSE -> IF lv_fees LT 0
      WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk. " Fees
      CONDENSE lst_final-fees.
    ENDIF. " IF lv_fees LT 0
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Discount Value
  IF fp_st_vbrk-vbtyp IN r_crd
    AND lv_discount GT 0.
    lv_discount = lv_discount * -1.
    WRITE lv_discount TO lst_final-discount CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-discount.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    IF lv_discount LT 0.
      WRITE lv_discount TO lst_final-discount CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-discount.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst_final-discount.
    ELSE. " ELSE -> IF lv_discount LT 0
      WRITE lv_discount TO lst_final-discount CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-discount.
    ENDIF. " IF lv_discount LT 0
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Subtotal
  v_subtotal_val = st_vbrk-netwr.
* Tax
  v_sales_tax    = lv_tax.

* Tax Value
  IF fp_st_vbrk-vbtyp IN r_crd
       AND lv_tax GT 0.
    WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-tax_amount.
    CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    IF lv_tax LT 0.
      WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-tax_amount.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst_final-tax_amount.
    ELSE. " ELSE -> IF lv_tax LT 0
      WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-tax_amount.
    ENDIF. " IF lv_tax LT 0
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Total Value
  IF fp_st_vbrk-vbtyp IN r_crd " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
   AND lv_total GT 0.
    WRITE lv_total TO lst_final-total CURRENCY st_vbrk-waerk. " Total
    CONDENSE lst_final-total.
    CONCATENATE lc_minus lst_final-total INTO lst_final-total.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    IF lv_total LT 0.
      WRITE lv_total TO lst_final-total CURRENCY st_vbrk-waerk. " Total
      CONDENSE lst_final-total.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst_final-total.
    ELSE. " ELSE -> IF lv_total LT 0
      WRITE lv_total TO lst_final-total CURRENCY st_vbrk-waerk. " Total
      CONDENSE lst_final-total.
    ENDIF. " IF lv_total LT 0
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* SubTotal Value
  IF fp_st_vbrk-vbtyp IN r_crd
      AND lv_subtotal GT 0.
    WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-sub_total.
    CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    IF lv_subtotal LT 0.
      WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-sub_total.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst_final-sub_total.
    ELSE. " ELSE -> IF lv_subtotal LT 0
      WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
      CONDENSE lst_final-sub_total.
    ENDIF. " IF lv_subtotal LT 0
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

*****BOC by MODUTTA for CR#66 on 23/10/2017
* Populate first line od description
  lst_final-description = 'ENHANCED ACCESS LICENSE'.
  CONCATENATE lst_final-description v_year INTO lst_final-description SEPARATED BY space.

  IF lst_final IS NOT INITIAL.
    APPEND lst_final TO fp_i_final.
    CLEAR lst_final.
  ENDIF. " IF lst_final IS NOT INITIAL

*Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
  CONCATENATE lst_vbrp-aubel lst_vbrp-posnr INTO v_txt_name.
*
  lv_text_id = '0043'.
  PERFORM f_get_item_text_lin USING v_txt_name
                                    lv_text_id
                            CHANGING v_text_line.
  IF v_text_line IS NOT INITIAL.
    lst_final-description = v_text_line.
    APPEND lst_final TO fp_i_final.
    CLEAR lst_final.
  ENDIF. " IF v_text_line IS NOT INITIAL

  PERFORM f_read_text    USING c_journal
                      CHANGING v_text_line.
  IF v_text_line IS NOT INITIAL.
    lst_final-description = v_text_line.
    APPEND lst_final TO fp_i_final.
    CLEAR lst_final.
  ENDIF. " IF v_text_line IS NOT INITIAL
*End of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591

*BOC by MODUTTA for CR#666 on 23/10/2017
  IF ( lv_flag_di IS NOT INITIAL
    AND lv_flag_ph IS NOT INITIAL )
    OR lv_flag_se IS NOT INITIAL.

***  For Print & Digital Subscription
    v_txt_name = lc_comb_subsc.
    lv_text_id = lc_text_id.
    PERFORM f_read_sub_type USING v_txt_name
                                   lv_text_id
                            CHANGING v_subs_type.
    IF v_subs_type IS NOT INITIAL.
      lst_final-description = v_subs_type.
    ENDIF. " IF v_subs_type IS NOT INITIAL

  ELSEIF lv_flag_ph IS NOT INITIAL.
***  For Print Subscription
    v_txt_name = lc_prnt_subsc.
    lv_text_id = lc_text_id.
    PERFORM f_read_sub_type USING v_txt_name
                                   lv_text_id
                            CHANGING v_subs_type.
    IF v_subs_type IS NOT INITIAL.
      lst_final-description = v_subs_type.
    ENDIF. " IF v_subs_type IS NOT INITIAL

  ELSEIF lv_flag_di IS NOT INITIAL.
***  For Digital Subscription
    v_txt_name = lc_digt_subsc.
    lv_text_id = lc_text_id.
    PERFORM f_read_sub_type USING v_txt_name
                                   lv_text_id
                            CHANGING v_subs_type.
    IF v_subs_type IS NOT INITIAL.
      lst_final-description = v_subs_type.
    ENDIF. " IF v_subs_type IS NOT INITIAL
  ENDIF. " IF ( lv_flag_di IS NOT INITIAL

  IF lst_final-description IS NOT INITIAL.
    APPEND lst_final TO fp_i_final.
    CLEAR lst_final.
  ENDIF. " IF lst_final-description IS NOT INITIAL
*EOC by MODUTTA for CR#666 on 23/10/2017

*****EOC by MODUTTA for CR#66 on 23/10/2017
*****Populate Year for CR#666 Refer email of BIPLAB on 19/10/2017 change by MODUTTA
  IF lst_mara-ismyearnr NE 0.
*          CONCATENATE lv_year lst_mara-ismyearnr INTO lst_final_tbt-issue_year SEPARATED BY space.
    CONCATENATE text-001 lst_mara-ismyearnr INTO lst_final-description SEPARATED BY space.
*          CONDENSE lst_final_tbt-issue_year.
    CONDENSE lst_final-description.
    APPEND lst_final TO fp_i_final.
  ENDIF. " IF lst_mara-ismyearnr NE 0

*BOC by MODUTTA on 08/08/2017 fo CR#408
  IF st_header-buyer_reg IS INITIAL.
    READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      CLEAR lst_final.
      IF lst_tax_buyer-buyer_reg IS NOT INITIAL.
        CONCATENATE lst_tax_buyer-buyer_reg lst_final-description INTO lst_final-description SEPARATED BY space.
        CONDENSE lst_final-description.
        APPEND lst_final TO fp_i_final.
        CLEAR lst_final.
      ENDIF. " IF lst_tax_buyer-buyer_reg IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF st_header-buyer_reg IS INITIAL
*EOC by MODUTTA on 08/08/2017 fo CR#408

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_vbrk-zlsch EQ 'J'.
    v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

* Begin of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977
  IF v_subtotal_val EQ 0.
    CLEAR v_paid_amt.
  ENDIF. " IF v_subtotal_val EQ 0
  WRITE v_paid_amt TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
  CONDENSE fp_v_prepaid_amount.
* End of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977

*  IF fp_st_vbrk-fkart IN r_crd.  (--) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
*  IF fp_st_vbrk-vbtyp IN r_crd. "(++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
* Total due amount
*    v_totaldue_val = ( v_subtotal_val + v_sales_tax ) + fp_v_paid_amt.

*  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.
*  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

***BOC by MODUTTA on 15/01/2018 for CR_TBD
  IF lv_kwert IS NOT INITIAL.
    MOVE lv_kwert TO lv_kwert_text.
    REPLACE ALL OCCURRENCES OF '-' IN lv_kwert_text WITH space.
    CONDENSE lv_kwert_text.
    CONCATENATE lv_text_agent lv_kwert_text st_vbrk-waerk INTO v_kwert SEPARATED BY space.
  ENDIF. " IF lv_kwert IS NOT INITIAL
***EOC by MODUTTA on 15/01/2018 for CR_TBD

***BOC by MODUTTA for CR#666 on 18/10/2017
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-tax_amount.
*    IF lst_tax_item-tax_amount IS NOT INITIAL.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
*    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR#666 on 18/10/2017


* Clear local variable
  CLEAR : lst_final,
          lv_due,
          lv_tax,
          lv_discount,
          lv_subtotal,
          lv_total.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_CON_ITEM
*&---------------------------------------------------------------------*
*  Populate Item table for consortia Invoice
*----------------------------------------------------------------------*
*      -->P_ST_VBRK  text
*      -->P_I_VBRP  text
*      -->P_I_VBFA  text
*      -->P_I_VBPA  text
*      -->P_I_JPTIDCDASSIGN  text
*      -->P_I_MARA  text
*      -->P_I_KNA1  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_populate_detail_con_item  USING    fp_st_vbrk          TYPE ty_vbrk
                                          fp_i_vbrp           TYPE tt_vbrp
                                          fp_i_vbpa_con       TYPE tt_vbpa
                                          fp_i_adrc           TYPE tt_adrc
                                          fp_v_paid_amt       TYPE autwr  " Payment cards: Authorized amount
                                 CHANGING fp_i_final          TYPE ztqtc_item_detail_f024
                                          fp_v_prepaid_amount TYPE char20 " V_prepaid_amount of type CHAR20
                                          fp_i_subtotal       TYPE ztqtc_subtotal_f024.

* Local type declaration
  TYPES: BEGIN OF lty_vbrp_vbpa,
           parvw TYPE parvw,      " Partner Function
           kunnr TYPE kunnr,      " Customer Number
           vbeln TYPE vbeln,      " Sales and Distribution Document Number
           posnr TYPE posnr,      " Item number of the SD document
           uepos TYPE uepos,      " Higher-level item in bill of material structures
           matnr TYPE matnr,      " Material
           name1 TYPE name1,      " Name
           aland TYPE aland,      " Departure country (country from which the goods are sent)
           lland TYPE lland_auft, " Country of destination of sales order
           netwr TYPE netwr,      " Net Value in Document Currency
           kzwi1 TYPE kzwi1,      " Subtotal 1 from pricing procedure for condition
           kzwi2 TYPE kzwi2,      " Subtotal 2 from pricing procedure for condition
           kzwi3 TYPE kzwi3,      " Subtotal 3 from pricing procedure for condition
           kzwi5 TYPE kzwi5,      " Subtotal 5 from pricing procedure for condition
           kzwi6 TYPE kzwi6,      " Subtotal 6 from pricing procedure for condition
*           buyer_reg TYPE
         END OF lty_vbrp_vbpa.

* Data Declaration
  DATA : li_vbrp_vbpa  TYPE STANDARD TABLE OF lty_vbrp_vbpa INITIAL SIZE 0,
         lst_vbrp_vbpa TYPE lty_vbrp_vbpa,
         lst_final     TYPE zstqtc_item_detail_f024, " Structure for Item table
         lv_amount     TYPE char16,                  " Amount value
         lv_due        TYPE kzwi2,                   " Subtotal 2 from pricing procedure for condition
         lv_total      TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_tax1       TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
         lv_tax        TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
         lv_fees       TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lst_final1    TYPE zstqtc_item_detail_f024, " Structure for Item table
         lv_subtotal   TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_amnt       TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
         lv_disc1      TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
         lv_disc       TYPE kzwi5,                   " Subtotal 5 from pricing procedure for condition
*         Added by MODUTTA
         lv_doc_line   TYPE /idt/doc_line_number, " Document Line Number
         lv_buyer_reg  TYPE char255.              " Buyer_reg of type CHAR255 " Structure for Item table

* Constant declaration
  CONSTANTS : lc_we     TYPE parvw VALUE 'WE', " Partner Function
              lc_first  TYPE char1 VALUE '(',  " First of type CHAR1
              lc_second TYPE char1 VALUE ')',  " Second of type CHAR1
*** BOC BY SAYANDAS
              lc_minus  TYPE char1 VALUE '-'. " Minus of type CHAR1
*** EOC BY SAYANDAS

* BOC by SRBOSE
  DATA : li_lines       TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text        TYPE string,
         lv_ind         TYPE xegld,                   " Indicator: European Union Member?
         lst_line       TYPE tline,                   " SAPscript: Text Lines
         lst_lines      TYPE tline,                   " SAPscript: Text Lines
         li_lines_agent TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
         lv_text_agent  TYPE string,
         lv_text_tax    TYPE string.                  "Added by MODUTTA on 22/01/2018 for CR# TBD

  CONSTANTS:lc_undscr     TYPE char1      VALUE '_',                                 " Undscr of type CHAR1
            lc_vat        TYPE char3      VALUE 'VAT',                               " Vat of type CHAR3
            lc_tax        TYPE char3      VALUE 'TAX',                               " Tax of type CHAR3
            lc_gst        TYPE char3      VALUE 'GST',                               " Gst of type CHAR3
            lc_class      TYPE char5      VALUE 'ZQTC_',                             " Class of type CHAR5
            lc_devid      TYPE char5      VALUE '_F024',                             " Devid of type CHAR5
            lc_percent    TYPE char1 VALUE '%',                                      " Percent of type CHAR1
            lc_colon      TYPE char1      VALUE ':',                                 " Colon of type CHAR1
            lc_tax_text   TYPE tdobname VALUE 'ZQTC_TAX_F024',                       " Name
            lc_digital    TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',                   " Name
            lc_print      TYPE tdobname VALUE 'ZQTC_F024_PRINT',                     " Name
            lc_mixed      TYPE tdobname VALUE 'ZQTC_F024_MIXED',                     " Name
            lc_shipping   TYPE tdobname VALUE 'ZQTC_F024_SHIPPING',                  " Name
            lc_text_id    TYPE tdid     VALUE 'ST',                                  " Text ID
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042', " Name
            lc_agent_dis  TYPE thead-tdname VALUE 'ZQTC_F024_AGENT_DISCOUNT'.        " Name

  DATA:  lv_kbetr_desc      TYPE p DECIMALS 3,         " Rate (condition amount or percentage)
         lv_kbetr_char      TYPE char15,               " Kbetr_char of type CHAR15
         lst_komp           TYPE komp,                 " Communication Item for Pricing
         lst_tax_item       TYPE ty_tax_item,
         li_tax_item        TYPE tt_tax_item,
         lst_tax_item_final TYPE zstqtc_tax_item_f024, " Structure for tax components
         lv_text_id         TYPE tdid,                 " Text ID
         lv_taxable_amt     TYPE kzwi1,                " Subtotal 1 from pricing procedure for condition
         lv_tax_amount      TYPE p DECIMALS 3,         " Subtotal 6 from pricing procedure for condition
         lv_kbetr_new       TYPE kbetr,                " Rate (condition amount or percentage)
         lv_kbetr           TYPE kbetr,                " Rate (condition amount or percentage)
         lv_flag_di         TYPE xfeld,                " Checkbox
         lv_flag_ph         TYPE xfeld,                " Checkbox
         lv_flag_mm         TYPE xfeld,                " Checkbox
         lv_flag_se         TYPE xfeld,                " Checkbox
         lv_kwert           TYPE kwert,                " Condition value
         lv_kwert_text      TYPE char50.               " Kwert_text of type CHAR50

***BOC by MODUTTA on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
  SELECT knumv, "Number of the document condition
         kposn, "Condition item number
         stunr, "Step number
         zaehk, "Condition counter
         kappl, " Application
         kschl,
         kawrt, "Condition base value
         kbetr, "Rate (condition amount or percentage)
         kwert, "Condition value
         kinak, "Condition is inactive
         koaid  "Condition class
    FROM konv   "Conditions (Transaction Data)
    INTO TABLE @DATA(li_tkomv)
    WHERE knumv = @fp_st_vbrk-knumv
      AND kinak = ''.
*      AND   kposn = fp_st_vbap-posnr.
  IF sy-subrc IS INITIAL.
    SORT li_tkomv BY kposn.
    DATA(li_konv) = li_tkomv[].
    SORT li_konv BY kposn kschl.
    DELETE li_konv WHERE kschl NE v_cond_type.
*   DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
    DELETE li_tkomv WHERE koaid NE 'D'.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    DELETE li_tkomv WHERE kawrt IS INITIAL.
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*    DELETE li_tkomv WHERE kbetr IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL
***EOC by MODUTTA on 17/10/2017 for CR#666


  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

*  IF v_ind EQ abap_true.
*    CONCATENATE lc_class
*                lc_vat
*                lc_devid
*           INTO v_tax.
*
*  ELSEIF st_header-bill_country EQ 'US'.
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.
*  ELSE. " ELSE -> IF v_ind EQ abap_true
*    CONCATENATE lc_class
*                lc_gst
*                lc_devid
*           INTO v_tax.
*
*  ENDIF. " IF v_ind EQ abap_true
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = v_tax
      object                  = c_object
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
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* EOC by SRBOSE

**  BOC by MODUTTA on 22/01/18 on CR# TBD
  CLEAR li_lines[].
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_tax_text
      object                  = c_object
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
        ev_text_string = lv_text_tax.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_tax.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

** Populate Agent Discount Text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_agent_dis
      object                  = c_object
    TABLES
      lines                   = li_lines_agent
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
        it_tline       = li_lines_agent
      IMPORTING
        ev_text_string = lv_text_agent.
    IF sy-subrc EQ 0.
      CONDENSE lv_text_agent.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
**  EOC by MODUTTA on 22/01/18 on CR# TBD

* Populate first line od description
  lst_final-description = 'ENHANCED ACCESS LICENSE'.
  CONCATENATE lst_final-description v_year INTO lst_final-description SEPARATED BY space.
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

*** Adding space after text
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

***Adding the values of final table in temporary table
  DATA(li_vbrp) = fp_i_vbrp[].

  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp1).
    READ TABLE fp_i_vbpa_con INTO DATA(lst_vbpa1) WITH KEY vbeln = lst_vbrp1-aubel
                                                           posnr = lst_vbrp1-aupos
                                                           parvw = lc_we.
    IF sy-subrc NE 0.
      READ TABLE fp_i_vbpa_con INTO lst_vbpa1     WITH KEY vbeln = lst_vbrp1-aubel
                                                           posnr = c_posnr_hdr
                                                           parvw = lc_we.
    ENDIF. " IF sy-subrc NE 0
    IF sy-subrc EQ 0.
      lst_vbrp_vbpa-parvw = lst_vbpa1-parvw.
      lst_vbrp_vbpa-kunnr = lst_vbpa1-kunnr.

      READ TABLE fp_i_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa1-adrnr
                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_vbrp_vbpa-name1 = lst_adrc-name1.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF sy-subrc EQ 0

    lst_vbrp_vbpa-vbeln = lst_vbrp1-vbeln.
    lst_vbrp_vbpa-posnr = lst_vbrp1-posnr.
    lst_vbrp_vbpa-uepos = lst_vbrp1-uepos.
    lst_vbrp_vbpa-matnr = lst_vbrp1-matnr.
    lst_vbrp_vbpa-aland = lst_vbrp1-aland.
    lst_vbrp_vbpa-lland = lst_vbrp1-lland.
    lst_vbrp_vbpa-netwr = lst_vbrp1-netwr.
    lst_vbrp_vbpa-kzwi1 = lst_vbrp1-kzwi1.
    lst_vbrp_vbpa-kzwi2 = lst_vbrp1-kzwi2.
    lst_vbrp_vbpa-kzwi3 = lst_vbrp1-kzwi3.
    lst_vbrp_vbpa-kzwi5 = lst_vbrp1-kzwi5.
    lst_vbrp_vbpa-kzwi6 = lst_vbrp1-kzwi6.

    APPEND lst_vbrp_vbpa TO li_vbrp_vbpa.
    CLEAR lst_vbrp_vbpa.
*    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp1)

* Begin of DEL:ERP-5069:WROY:14-Nov-2017:ED2K909404
*  CLEAR: v_subtotal_val,
*         v_sales_tax,
*         v_totaldue_val,
*         v_paid_amt.
* End   of DEL:ERP-5069:WROY:14-Nov-2017:ED2K909404
  SORT li_vbrp_vbpa BY parvw kunnr.
  LOOP AT li_vbrp_vbpa INTO DATA(lst_vbrp_dummy).
    DATA(lv_tabix) = sy-tabix.
    lst_vbrp_vbpa = lst_vbrp_dummy.
    AT NEW kunnr.
*     When ever new custimer number trigger, clear all the local variables.
      CLEAR : lv_fees,
              lv_disc1,
              lv_disc,
              lv_amnt,
              lv_total,
              lv_tax,
              lv_tax1,
              lv_subtotal.
    ENDAT.

**          BOC by MODUTTA on 15/01/2018 for CR# TBD
    READ TABLE li_konv INTO DATA(lst_konv) WITH KEY kposn = lst_vbrp_vbpa-posnr
                                                    kschl = v_cond_type
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_kwert = lv_kwert + lst_konv-kwert.
    ENDIF. " IF sy-subrc EQ 0
**          EOC by MODUTTA on 15/01/2018 for CR# TBD

****BOC by MODUTTA for CR# 666 on 18/10/12017
*   For Digital,Print,Combined and Shipping
    READ TABLE i_mara INTO DATA(lst_mara) WITH KEY matnr = lst_vbrp_vbpa-matnr
                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
***      Populate media type text
      IF lst_mara-ismmediatype = v_sub_type_di.
        v_txt_name = lc_digital.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_di IS INITIAL.
          lv_flag_di = abap_true.
        ENDIF. " IF lv_flag_di IS INITIAL
      ELSEIF lst_mara-ismmediatype = v_sub_type_ph.
        v_txt_name = lc_print.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_ph IS INITIAL.
          lv_flag_ph = abap_true.
        ENDIF. " IF lv_flag_ph IS INITIAL

      ELSEIF lst_mara-ismmediatype = v_sub_type_mm.
        v_txt_name = lc_mixed.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.

      ELSEIF lst_mara-ismmediatype = v_sub_type_se.
        v_txt_name = lc_shipping.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                          lv_text_id
                                 CHANGING v_text_line.
        IF lv_flag_se IS INITIAL.
          lv_flag_se = abap_true.
        ENDIF. " IF lv_flag_se IS INITIAL
      ENDIF. " IF lst_mara-ismmediatype = v_sub_type_di
*     Begin of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
      lst_tax_item-subs_type = lst_mara-ismmediatype.
*     End   of ADD:CR#743:WROY:13-Mar-2018:ED2K911320
    ENDIF. " IF sy-subrc EQ 0

***for bom component tax calculation
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp_vbpa-posnr.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_tmp) = sy-tabix.
      LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp.
        IF lst_vbrp_tmp-uepos NE lst_vbrp_vbpa-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_tmp-uepos NE lst_vbrp_vbpa-posnr
        lv_tax = lv_tax + lst_vbrp_tmp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO DATA(lst_vbrp_tmp) FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc EQ 0

***BOC by MODUTTA for CR_743
**    populate text TAX
    lst_tax_item-media_type = lv_text_tax.

***   Populate percentage
    READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp_vbpa-posnr.
*   Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
    IF sy-subrc NE 0.
      CLEAR: lst_komv.
    ELSE. " ELSE -> IF sy-subrc NE 0
*   End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
*****     Populate taxable amount
*   lst_tax_item-taxable_amt = lst_komv-kawrt.
*   IF sy-subrc IS INITIAL.
*   End   of DEL:ERP-6894:WROY:14-Mar-2018:ED2K911366
      DATA(lv_index) = sy-tabix.
      LOOP AT li_tkomv INTO lst_komv FROM lv_index.
        IF lst_komv-kposn NE lst_vbrp_vbpa-posnr.
          EXIT.
        ENDIF. " IF lst_komv-kposn NE lst_vbrp_vbpa-posnr
        lv_kbetr = lv_kbetr + lst_komv-kbetr.
*       Begin of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
****    Populate taxable amount
        lst_tax_item-taxable_amt = lst_komv-kawrt.
*       End   of ADD:ERP-6894:WROY:14-Mar-2018:ED2K911366
      ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
      lv_tax_amount = ( lv_kbetr / 10 ).
      CLEAR: lv_kbetr.
    ENDIF. " IF sy-subrc NE 0
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS INITIAL.
      lst_tax_item-taxable_amt = lst_vbrp_vbpa-netwr. " Net value of the billing item in document currency
    ENDIF. " IF lst_tax_item-taxable_amt IS INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
**      Populate tax amount
    lst_tax_item-tax_amount = lst_vbrp_vbpa-kzwi6.

    IF lst_vbrp_vbpa-kzwi6 IS INITIAL.
      CLEAR lv_tax_amount.
    ENDIF. " IF lst_vbrp_vbpa-kzwi6 IS INITIAL

    WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
    CONDENSE lst_tax_item-tax_percentage.
    CLEAR lv_tax_amount.

*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    IF lst_tax_item-taxable_amt IS NOT INITIAL.
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
      COLLECT lst_tax_item INTO li_tax_item.
*   Begin of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    ENDIF. " IF lst_tax_item-taxable_amt IS NOT INITIAL
*   End   of ADD:ERP-6660:WROY:15-Feb-2018:ED2K910930
    CLEAR: lst_tax_item.
***EOC by MODUTTA for CR_743

    IF lst_vbrp_vbpa-uepos IS INITIAL.
*******************************Description****************************
* Concatenate Ship-to party and name
*      Commented by MODUTTA on 26/10/2017 Refer email from WROY
*      CONCATENATE  lst_vbrp_vbpa-kunnr lst_vbrp_vbpa-name1 INTO lst_final-description SEPARATED BY space.
      lst_final-description = lst_vbrp_vbpa-name1.
***Fees
* Sum up fees vallues for same ship to party
      lv_fees = lv_fees + lst_vbrp_vbpa-kzwi1.

***Discount
* Sum up discount vallues for same ship to party
      lv_disc = lv_disc + lst_vbrp_vbpa-kzwi5.

***Sub Total
* Sum up subtotal vallues for same ship to party
      lv_amnt = lst_vbrp_vbpa-kzwi1 + lst_vbrp_vbpa-kzwi5.
      lv_subtotal = lv_subtotal + lv_amnt.

***Tax Amount
* Sum up tax amount vallues for same ship to party
      lv_tax   = lv_tax + lst_vbrp_vbpa-kzwi6.

***Total
* Sum up tax amount vallues for same ship to party
      lv_total = lv_tax + lv_subtotal.
    ENDIF. " IF lst_vbrp_vbpa-uepos IS INITIAL

*************BOC by MODUTTA on 08/08/2017 for CR# 408****************
*  TAX ID/VAT ID
    lv_doc_line = lst_vbrp_vbpa-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp_vbpa-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0
      AND lst_tax_data-seller_reg IS NOT INITIAL.
      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
      v_seller_reg = lst_tax_data-seller_reg+0(20).
    ELSEIF lst_vbrp_vbpa-kzwi6 IS NOT INITIAL.
*     Begin of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
*     IF lst_vbrp_vbpa-aland EQ lst_vbrp_vbpa-lland.
*     End   of DEL:ERP-5055:WROY:13-Dec-2017:ED2K909647
*     Begin of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
      IF st_header-comp_code_country EQ lst_vbrp_vbpa-lland.
*     End   of ADD:ERP-5055:WROY:13-Dec-2017:ED2K909647
        READ TABLE i_tax_id ASSIGNING FIELD-SYMBOL(<lst_tax_id>)
             WITH KEY land1 = lst_vbrp_vbpa-lland
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF v_seller_reg IS INITIAL.
            v_seller_reg = <lst_tax_id>-stceg.
          ELSEIF v_seller_reg NS <lst_tax_id>-stceg.
            CONCATENATE <lst_tax_id>-stceg v_seller_reg INTO v_seller_reg SEPARATED BY space.
          ENDIF. " IF v_seller_reg IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-comp_code_country EQ lst_vbrp_vbpa-lland
    ENDIF. " IF sy-subrc EQ 0
*************EOC by MODUTTA on 08/08/2017 for CR# 408****************

*   When ever one particular customer number end, put the values in final structure
    AT END OF kunnr.
      SET COUNTRY st_header-bill_country.
**** FEES
      IF fp_st_vbrk-vbtyp IN r_crd " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
           AND lv_fees GT 0.
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
        CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_fees LT 0.
          WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-fees.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-fees.
        ELSE. " ELSE -> IF lv_fees LT 0
          WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-fees.
        ENDIF. " IF lv_fees LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

****Discount
* If discount value is 0, then show the value in braces to indicate
* negative value
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_disc GT 0.
        lv_disc = lv_disc * -1.
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_disc LT 0.
          WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-discount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-discount.
          CONDENSE lst_final-discount.
        ELSE. " ELSE -> IF lv_disc LT 0
          WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-discount.
        ENDIF. " IF lv_disc LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      CLEAR lv_amount.

* Calculate Total Due
      v_subtotal_val = lv_subtotal +  v_subtotal_val.

*     Calculate sales tax
      v_sales_tax    = lv_tax + v_sales_tax.


**** Subtotal
      IF fp_st_vbrk-vbtyp IN r_crd
              AND lv_subtotal GT 0.
        WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
        CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_tax LT 0.
          WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-sub_total.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-sub_total.
        ELSE. " ELSE -> IF lv_tax LT 0
          WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-sub_total.
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

**** Tax Amount
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_tax GT 0.
        WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-tax_amount.
        CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_tax LT 0.
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-tax_amount.
        ELSE. " ELSE -> IF lv_tax LT 0
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
        ENDIF. " IF lv_tax LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      CLEAR lv_amount.

*     Total Amount
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_total GT 0.
        WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
        CONCATENATE lc_minus lst_final-total INTO lst_final-total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        IF lv_total LT 0.
          WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-total.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-total.
        ELSE. " ELSE -> IF lv_total LT 0
          WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-total.
        ENDIF. " IF lv_total LT 0
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

      IF lst_final IS NOT INITIAL.
        APPEND lst_final TO fp_i_final.
        CLEAR lst_final.
      ENDIF. " IF lst_final IS NOT INITIAL

***Subscription type
*BOC by MODUTTA for CR#666 on 23/10/2017
      IF ( lv_flag_di IS NOT INITIAL
        AND lv_flag_ph IS NOT INITIAL )
        OR lv_flag_se IS NOT INITIAL.

***  For Print & Digital Subscription
        v_txt_name = lc_comb_subsc.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                       lv_text_id
                                CHANGING v_subs_type.
        IF v_subs_type IS NOT INITIAL.
          lst_final-description = v_subs_type.
        ENDIF. " IF v_subs_type IS NOT INITIAL

      ELSEIF lv_flag_ph IS NOT INITIAL.
***  For Print Subscription
        v_txt_name = lc_prnt_subsc.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                       lv_text_id
                                CHANGING v_subs_type.
        IF v_subs_type IS NOT INITIAL.
          lst_final-description = v_subs_type.
        ENDIF. " IF v_subs_type IS NOT INITIAL

      ELSEIF lv_flag_di IS NOT INITIAL.
***  For Digital Subscription
        v_txt_name = lc_digt_subsc.
        lv_text_id = lc_text_id.
        PERFORM f_read_sub_type USING v_txt_name
                                       lv_text_id
                                CHANGING v_subs_type.
        IF v_subs_type IS NOT INITIAL.
          lst_final-description = v_subs_type.
        ENDIF. " IF v_subs_type IS NOT INITIAL
      ENDIF. " IF ( lv_flag_di IS NOT INITIAL
      IF lst_final-description IS NOT INITIAL.
        APPEND lst_final TO fp_i_final.
        CLEAR: lst_final,lv_flag_di,lv_flag_ph,lv_flag_se.
      ENDIF. " IF lst_final-description IS NOT INITIAL

*****Populate Year for CR#666 Refer email of BIPLAB on 19/10/2017 change by MODUTTA
      IF lst_mara-ismyearnr NE 0.
*          CONCATENATE lv_year lst_mara-ismyearnr INTO lst_final_tbt-issue_year SEPARATED BY space.
        CONCATENATE text-001 lst_mara-ismyearnr INTO lst_final-description SEPARATED BY space.
*          CONDENSE lst_final_tbt-issue_year.
        CONDENSE lst_final-description.
        APPEND lst_final TO fp_i_final.
      ENDIF. " IF lst_mara-ismyearnr NE 0

**BOC by MODUTTA on 08/08/2017 for CR# 408
      IF st_header-buyer_reg IS INITIAL.
        READ TABLE li_tax_buyer INTO DATA(lst_tax_buyer) WITH KEY document = lst_vbrp_vbpa-vbeln
                                                             doc_line_number = lv_doc_line
                                                             BINARY SEARCH.
        IF sy-subrc EQ 0.
          CLEAR lst_final.
          IF lst_tax_buyer-buyer_reg IS NOT INITIAL.
            CONCATENATE lst_tax_buyer-buyer_reg lst_final-description INTO lst_final-description SEPARATED BY space.
            CONDENSE lst_final-description.
            APPEND lst_final TO fp_i_final.
            CLEAR lst_final.
          ENDIF. " IF lst_tax_buyer-buyer_reg IS NOT INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF st_header-buyer_reg IS INITIAL
**EOC by MODUTTA on 08/08/2017 for CR# 408

      CLEAR : lst_final,
              lst_vbrp_vbpa.
    ENDAT.
  ENDLOOP. " LOOP AT li_vbrp_vbpa INTO DATA(lst_vbrp_dummy)

***BOC by MODUTTA on 15/01/2018 for CR_TBD
  IF lv_kwert IS NOT INITIAL.
    MOVE lv_kwert TO lv_kwert_text.
    REPLACE ALL OCCURRENCES OF '-' IN lv_kwert_text WITH space.
    CONDENSE lv_kwert_text.
    CONCATENATE lv_text_agent lv_kwert_text st_vbrk-waerk INTO v_kwert SEPARATED BY space.
  ENDIF. " IF lv_kwert IS NOT INITIAL
***EOC by MODUTTA on 15/01/2018 for CR_TBD

*  BOC by SRBOSE
  IF v_seller_reg IS NOT INITIAL.
    CONDENSE v_seller_reg.
  ELSEIF st_header-comp_code_country EQ st_header-ship_country.
    READ TABLE i_tax_id ASSIGNING <lst_tax_id>
         WITH KEY land1 = st_header-ship_country
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      v_seller_reg = <lst_tax_id>-stceg.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_seller_reg IS NOT INITIAL
* EOC by SRBOSE

  v_subtotal_val = st_vbrk-netwr.
  IF st_vbrk-zlsch EQ 'J'.
    v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

* Begin of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977
  IF v_subtotal_val EQ 0.
    CLEAR v_paid_amt.
  ENDIF. " IF v_subtotal_val EQ 0
  WRITE v_paid_amt TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
  CONDENSE fp_v_prepaid_amount.
* End of change:  PBOSE: 10-May-2017: Defect 1990 : ED2K905977

* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.

***BOC by MODUTTA for CR#666 on 18/10/2017
  LOOP AT li_tax_item INTO lst_tax_item.
*    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-media_type = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-tax_amount.
    APPEND lst_tax_item_final TO i_tax_item.
    CLEAR lst_tax_item_final.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR#666 on 18/10/2017
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TEXT
*&---------------------------------------------------------------------*
*  Get text module values
*----------------------------------------------------------------------*
*      -->FP_C_SUBTOTAL  text
*      -->FP_ST_HEADER  text
*      <--FP_LI_TXTMODULE  text
*----------------------------------------------------------------------*
FORM f_get_text  USING    fp_c_subtotal     TYPE tdsfname                  " Smart Forms: Form Name
                          fp_st_header      TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
                 CHANGING fp_i_txtmodule   TYPE tsftext.

* Data declaration
  DATA : lst_langu TYPE ssfrlang. " Language Key

* Put language key in the FM structure
  lst_langu-langu1 = fp_st_header-language.

* Function Module to fetch text value
  CALL FUNCTION 'SSFRT_READ_TEXTMODULE' "
    EXPORTING
      i_textmodule       = fp_c_subtotal " tdsfname
      i_languages        = lst_langu     " ssfrlang
    IMPORTING
      o_text             = i_txtmodule   " tsftext
    EXCEPTIONS
      error              = 1                   "
      language_not_found = 2.      "

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_TITLE_TEXT
*&---------------------------------------------------------------------*
*  Populate main title text
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER  Header Detail
*      -->FP_ST_VBRK    VBRK straucture
*      <--FP_V_ACCMNGD_TITLE  Title text
*----------------------------------------------------------------------*
FORM f_populate_title_text  USING    fp_st_header        TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
                                     fp_st_vbrk          TYPE ty_vbrk
                                     fp_r_country        TYPE tt_country
                            CHANGING fp_v_accmngd_title  TYPE char255                   " V_accmngd_title of type CHAR255
                                     fp_v_reprint        TYPE char255.                  " Reprint (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

* clear local variables
  CLEAR : li_lines,
          lv_text.

  IF fp_st_vbrk-vkorg NOT IN fp_r_country. "Added by MODUTTA for JIRA# 4713 on 31/10/2017
*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
    IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz.
      PERFORM f_read_text    USING c_name_vkorg
                           CHANGING v_title.

    ENDIF. " IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz
*End of change by SRBOSE on 31-July-2017 CR_463 #TR:ED2K907362
  ENDIF. " IF fp_st_vbrk-vkorg NOT IN fp_r_country


*  IF fp_st_vbrk-fkart IN r_inv.  ""(--) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
  IF fp_st_vbrk-vbtyp IN r_inv. " (++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
*    AND v_proc_status NE '1'.  " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977

    IF st_header-comp_code IN fp_r_country.

      IF st_header-bill_country EQ st_header-ship_country.

        PERFORM f_read_text    USING c_name_tax_inv
                            CHANGING fp_v_accmngd_title.

      ELSE. " ELSE -> IF st_header-bill_country EQ st_header-ship_country
*       Fetch title text for invoice
        PERFORM f_read_text    USING c_name_inv
                            CHANGING fp_v_accmngd_title.

      ENDIF. " IF st_header-bill_country EQ st_header-ship_country

    ELSE. " ELSE -> IF st_header-comp_code IN fp_r_country
*     Fetch title text for invoice
      PERFORM f_read_text    USING c_name_inv
                          CHANGING fp_v_accmngd_title.

    ENDIF. " IF st_header-comp_code IN fp_r_country

*Begin of change by SRBOSE on 31-July-2017 CR_463 #TR: ED2K907362
*    IF fp_st_vbrk-fkart EQ v_faz.
*      PERFORM f_read_text    USING             "c_name_faz  "(--SRBOSE on 10-Oct-2017 for CR_618: TR:ED2K908961)
*                                    c_name_inv "(++SRBOSE on 10-Oct-2017 for CR_618: TR:ED2K908961)
*                           CHANGING fp_v_accmngd_title.
*
*    ENDIF. " IF fp_st_vbrk-fkart EQ v_faz
*End of change by SRBOSE on 31-July-2017 CR_463 #TR: ED2K907362

*  ELSEIF fp_st_vbrk-fkart IN r_crd.  (--) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
  ELSEIF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
*      AND v_proc_status NE '1'.  " (--) PBOSE: 10-May-2017: Defect 1990 : ED2K905977

    IF st_header-comp_code IN fp_r_country.

      IF st_header-bill_country EQ st_header-ship_country.

        PERFORM f_read_text    USING c_name_tax_crd
                            CHANGING fp_v_accmngd_title.

      ELSE. " ELSE -> IF st_header-bill_country EQ st_header-ship_country
*   Fetch title text for credit memo

        PERFORM f_read_text    USING c_name_crd
                            CHANGING fp_v_accmngd_title.

      ENDIF. " IF st_header-bill_country EQ st_header-ship_country

    ELSE. " ELSE -> IF st_header-comp_code IN fp_r_country
**   Fetch title text for invoice
      PERFORM f_read_text    USING c_name_crd
                          CHANGING fp_v_accmngd_title.

    ENDIF. " IF st_header-comp_code IN fp_r_country

  ELSEIF fp_st_vbrk-vbtyp IN r_dbt. "(++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421
    IF st_header-comp_code IN fp_r_country.

      IF st_header-bill_country EQ st_header-ship_country.

        PERFORM f_read_text    USING c_name_tax_dbt
                            CHANGING fp_v_accmngd_title.

      ELSE. " ELSE -> IF st_header-bill_country EQ st_header-ship_country
*   Fetch title text for debit memo

        PERFORM f_read_text    USING c_name_dbt
                    CHANGING fp_v_accmngd_title.
      ENDIF. " IF st_header-bill_country EQ st_header-ship_country

    ELSE. " ELSE -> IF st_header-comp_code IN fp_r_country
**   Fetch title text for debit memo
      PERFORM f_read_text    USING c_name_dbt
                    CHANGING fp_v_accmngd_title.

    ENDIF. " IF st_header-comp_code IN fp_r_country
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_inv
*  IF v_proc_status EQ '1'.
*    PERFORM f_read_text    USING c_name_reprnt
*                        CHANGING fp_v_reprint.
*  ENDIF. " IF v_proc_status EQ '1'
* End of change: PBOSE: 10-May-2017: Defect 1990 : ED2K905977
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_HEADER_TEXT
*&---------------------------------------------------------------------*
* Populate header text
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER       Header Structure
*      <--FP_ST_HEADER_TEXT  Header Text
*----------------------------------------------------------------------*
FORM f_populate_header_text  USING    fp_st_header       TYPE zstqtc_header_detail_f024  " Structure for Header detail of invoice form
                             CHANGING fp_st_header_text  TYPE zstqtc_header_detail_f024. " Structure for Header detail of invoice form

* Constant declaration
  CONSTANTS : lc_object         TYPE tdobject VALUE 'VBBK',              " Texts: Application Object
              lc_id             TYPE tdid     VALUE '0007',              " Text ID
              lc_object_comment TYPE tdobject VALUE 'TEXT',              " Texts: Application Object
              lc_name_comment   TYPE tdobname VALUE 'ZQTC_COMMENT_F024', " TDIC text name
              lc_id_comment     TYPE tdid VALUE 'ST'.                    " Text ID

* Data declaration
  DATA : li_lines       TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
         lv_text        TYPE string,
         lv_wrdwrp      TYPE char300,                 " Wrdwrp of type CHAR300
         lv_name        TYPE tdobname,                " Name
         lv_first_text  TYPE char100,                 " First_text of type Character
         lv_second_text TYPE char100,                 " Second_text of type Character
         lv_third_text  TYPE char100,                 " Third_text of type Character
         lst_tax_item   TYPE zstqtc_tax_item_f024.    " Structure for tax components

* Get Text name
  lv_name = fp_st_header-invoice_number.

  CLEAR : li_lines,
          lv_text.

* Use FM to retrieve header text value
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_id
      language                = st_header-language
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
*   Get the Text value into string
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.

    IF sy-subrc EQ 0.
      lv_wrdwrp = lv_text.
*     Divide the text value in 100 words
      CALL FUNCTION 'RKD_WORD_WRAP'
        EXPORTING
          textline            = lv_wrdwrp
          delimiter           = space
          outputlen           = 100
        IMPORTING
          out_line1           = lv_first_text
          out_line2           = lv_second_text
          out_line3           = lv_third_text
        EXCEPTIONS
          outputlen_too_large = 1
          OTHERS              = 2.
      IF sy-subrc EQ 0.
***        BOC by MODUTTA on 18/10/2017 for CR# 666
*        fp_st_header-first_text_line  = lv_first_text. " First line of 100 words
*        fp_st_header-second_text_line = lv_second_text. " Second line of 100 words
*        fp_st_header-third_text_line  = lv_third_text. " Third line of 100 words
        CLEAR li_lines.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = lc_id_comment
            language                = st_header-language
            name                    = lc_name_comment
            object                  = lc_object_comment
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
          READ TABLE li_lines INTO DATA(lst_lines) INDEX 1.
          IF sy-subrc EQ 0.
            DATA(lv_comment) = lst_lines-tdline.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
        IF lv_first_text IS NOT INITIAL.
          CONCATENATE lv_comment lv_first_text INTO lst_tax_item SEPARATED BY space.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_first_text IS NOT INITIAL

        IF lv_second_text IS NOT INITIAL.
          lst_tax_item-media_type = lv_second_text.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_second_text IS NOT INITIAL

        IF lv_third_text IS NOT INITIAL.
          lst_tax_item-media_type = lv_third_text.
          APPEND lst_tax_item TO i_text_item.
        ENDIF. " IF lv_third_text IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
***        EOC by MODUTTA on 18/10/2017 for CR# 666
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_TO_BINARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_convert_pdf_to_binary.

******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = st_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
* Perform for send mail with the PDF attachment
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_mail_attachment.

* Data declaration
  DATA : lr_sender  TYPE REF TO if_sender_bcs VALUE IS INITIAL, " Interface of Sender Object in BCS
         lv_send    TYPE adr6-smtp_addr,                        " E-Mail Address
         lv_sub     TYPE char30,                                " Sub of type CHAR15
         lv_subject TYPE so_obj_des,                            " Short description of contents
         li_lines   TYPE STANDARD TABLE OF tline,               " SAPscript: Text Lines
         t_hex      TYPE solix_tab,
         lst_lines  TYPE tline,                                 " SAPscript: Text Lines
*        Begin of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907147
         lv_upd_tsk TYPE i, " Upd_tsk of type Integers
*        End   of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907147
* Begin of change: PBOSE: 19-May-2017: Defect 2185 : ED2K905977
         lv_title   TYPE char255. " Title of type CHAR255
* End of change: PBOSE: 19-May-2017: Defect 2185 : ED2K905977

* Constant Declaration
  CONSTANTS : lc_raw  TYPE so_obj_tp      VALUE 'RAW',                        " Code for document class
              lc_pdf  TYPE so_obj_tp      VALUE 'PDF',                        " Code for document class
              lc_i    TYPE bapi_mtype     VALUE 'I',                          " Message type: S Success, E Error, W Warning, I Info, A Abort
              lc_name TYPE thead-tdname   VALUE 'ZQTC_EMAILBODY_OUTPUT_F024'. " Name

  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service

  DATA lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL. " Business Communication Service
* Message body and subject
  DATA: li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body  TYPE soli,                                     " SAPoffice: line, length 255
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,                       " Sent_to_all(1) of type Character
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL. " Interface of Recipient Object in BCS

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

********FM is used to SAPscript: Read text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = lc_name
      object                  = c_object
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
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
  ENDIF. " IF sy-subrc EQ 0

  lv_sub = v_accmngd_title.
* Begin of ADD:ERP-5271:WROY:22-Nov-2017:ED2K909549
  CONCATENATE 'Wiley'(s01) lv_sub INTO lv_sub SEPARATED BY space.
* End   of ADD:ERP-5271:WROY:22-Nov-2017:ED2K909549
* End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229

  CONCATENATE lv_sub st_header-invoice_number INTO lv_subject SEPARATED BY space.

  TRY .
      lr_document = cl_document_bcs=>create_document(
      i_type = lc_raw " RAW
        i_text = li_message_body
        i_hex = t_hex
      i_subject = lv_subject ).
    CATCH cx_document_bcs.
    CATCH cx_send_req_bcs.
  ENDTRY.
  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions


  IF i_emailid[] IS NOT INITIAL.
    TRY.
        lr_document->add_attachment(
        EXPORTING
        i_attachment_type = lc_pdf "PDF
        i_attachment_subject = lv_subject
        i_att_content_hex = i_content_hex ).
      CATCH cx_document_bcs INTO lx_document_bcs.
    ENDTRY.

* Add attachment
    TRY.
        CALL METHOD lr_send_request->set_document( lr_document ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
* Pass the document to send request
        lr_send_request->set_document( lr_document ).

* Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
        lr_send_request->set_sender(
        EXPORTING
        i_sender = lr_sender ).

      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
* Create recipient
        LOOP AT i_emailid INTO DATA(lst_emailid).
          lr_recipient = cl_cam_address_bcs=>create_internet_address( lst_emailid-smtp_addr ).
** Set recipient
          lr_send_request->add_recipient(
          EXPORTING
          i_recipient = lr_recipient
          i_express = abap_true ).
        ENDLOOP. " LOOP AT i_emailid INTO DATA(lst_emailid)
      CATCH cx_address_bcs.
*Exception handling not required
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.

    TRY.
* Send email
        lr_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true " 'X'
        RECEIVING
        result = lv_sent_to_all ).
      CATCH cx_send_req_bcs.
*Exception handling not required
    ENDTRY.
*   Begin of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907147
*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0
*   End   of ADD:ERP-3069:WROY:06-JUL_2017:ED2K907147
  ENDIF. " IF i_emailid[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ADRC
*&---------------------------------------------------------------------*
*  Retrieve title and name from ADRC table
*----------------------------------------------------------------------*
*      -->fP_I_VBPA  Sales Document: Partner
*      <--fP_I_ADRC  Addresses
*----------------------------------------------------------------------*
FORM f_get_adrc  USING    fp_i_vbpa  TYPE tt_vbpa
                 CHANGING fp_i_adrc  TYPE tt_adrc.

  IF fp_i_vbpa[] IS NOT INITIAL .
    DATA(li_vbpa) = fp_i_vbpa[].
    SORT li_vbpa BY adrnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr.

* Fetch title and name
    SELECT addrnumber " Address number
           title      " Form-of-Address Key
           name1      " Name 1
* BOC by LKODWANI on 21-Jul-2016 TR#ED2K906301
           deflt_comm
* EOC by LKODWANI on 21-Jul-2016 TR#ED2K906301
      INTO TABLE fp_i_adrc
      FROM adrc " Addresses (Business Address Services)
      FOR ALL ENTRIES IN li_vbpa
      WHERE addrnumber EQ li_vbpa-adrnr.
    IF sy-subrc EQ 0.
      SORT fp_i_adrc  BY addrnumber.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_vbpa.
  ENDIF. " IF fp_i_vbpa[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAILID
*&---------------------------------------------------------------------*
* Fetch email ID
*----------------------------------------------------------------------*
*      -->FP_ST_HEADER     Header structure
*      <--FP_V_EMAILADDRS  Email ID
*----------------------------------------------------------------------*
FORM f_get_emailid  USING    fp_st_header TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
                    CHANGING fp_i_emailid TYPE tt_emailid.               " E-Mail Address

* Data Declaration
  DATA : li_email                TYPE STANDARD TABLE OF ty_email INITIAL SIZE 0,
         lst_email               TYPE ty_email,
         lv_current_date         TYPE ad_valfrom, " Communication Data: Valid From (YYYYMMDDHHMMSS)
         lst_emailid             TYPE ty_emailid,
         lv_cust_number          TYPE char10,     " Cust_number of type CHAR10
         lv_person_number_billto TYPE ad_persnum, " Person number
         lv_add_billto           TYPE char1,      " Add_billto of type CHAR1
         lv_person_number_shipto TYPE ad_persnum, " Person number
         lv_add_shipto           TYPE char1.      " Add_shipto of type CHAR1

* Begin of change: PBOSE: 06-June-2017: DEFECT 2285: ED2K906208
  CONSTANTS : lc_timstmp    TYPE char6      VALUE '000000',         " Timstmp of type CHAR6
              lc_validfrm   TYPE ad_valfrom VALUE '19000101000000', " Communication Data: Valid From (YYYYMMDDHHMMSS)
              lc_validto    TYPE ad_valto   VALUE '99991231235959', " Communication Data: Valid To (YYYYMMDDHHMMSS)
              lc_deflt_comm TYPE ad_comm VALUE 'LET'.               " Communication Method (Key) (Business Address Services)

* Begin of ADD:ERP-2977:WROY:10-JUL-2017:ED2K907197
*  IF fp_st_header-bill_addr_number IS NOT INITIAL.
**   Fetch email ID from ADR6.
*    SELECT addrnumber " Address number
*           persnumber " Person number
*           smtp_addr  " E-Mail Address
*           valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
*           valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
*      FROM adr6       " E-Mail Addresses (Business Address Services)
*      INTO TABLE li_email
*     WHERE addrnumber EQ fp_st_header-bill_addr_number.
*
*    IF sy-subrc EQ 0.
*      SORT li_email BY addrnumber.
*    ENDIF. " IF sy-subrc EQ 0
*
*    fp_st_header-addr_number_billto = fp_st_header-bill_addr_number.
*    fp_st_header-add_billto         = 1.
*  ENDIF. " IF fp_st_header-bill_addr_number IS NOT INITIAL
*
*  IF fp_st_header-ship_addr_number IS NOT INITIAL.
*    fp_st_header-addr_number_shipto = fp_st_header-ship_addr_number.
*    fp_st_header-add_shipto         = 1.
*  ENDIF. " IF fp_st_header-ship_addr_number IS NOT INITIAL
** End   of ADD:ERP-2977:WROY:10-JUL-2017:ED2K907197
*
*
*  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
*                                                 BINARY SEARCH.
*  IF sy-subrc EQ 0.
*    DATA(lv_comm_meth) = lst_adrc-deflt_comm.
*  ENDIF. " IF sy-subrc EQ 0
*
****BOC by MODUTTA on 13/02/18 for default email id temporarily
*  IF v_actv_flag_f024 IS INITIAL.
*    IF lv_comm_meth NE lc_deflt_comm
*      AND li_email IS NOT INITIAL. "Added by MODUTTA since we are checking communication method first and then populating email
*
*      lst_email-valid_from = lc_validfrm.
*      MODIFY li_email FROM lst_email TRANSPORTING valid_from
*       WHERE valid_from IS INITIAL.
*
*      lst_email-valid_to   = lc_validto.
*      MODIFY li_email FROM lst_email TRANSPORTING valid_to
*       WHERE valid_to IS INITIAL.
*
*      CONCATENATE sy-datum
*                  lc_timstmp
*             INTO lv_current_date.
*      DELETE li_email WHERE valid_from GT lv_current_date
*                         OR valid_to   LT lv_current_date.
*
** Get email address in table
*      LOOP AT li_email INTO lst_email.
  lst_emailid-smtp_addr = p_mail."'sguda@wiley.ccom'.
  APPEND lst_emailid TO fp_i_emailid.
  CLEAR lst_emailid.
*      ENDLOOP. " LOOP AT li_email INTO lst_email
*    ENDIF. " IF lv_comm_meth NE lc_deflt_comm
*  ELSE. " ELSE -> IF v_actv_flag_f024 IS INITIAL
*    LOOP AT r_email INTO DATA(lst_email_id).
*      lst_emailid-smtp_addr = lst_email_id-low.
*      APPEND lst_emailid TO fp_i_emailid.
*      CLEAR: lst_emailid,lst_email_id.
*    ENDLOOP. " LOOP AT r_email INTO DATA(lst_email_id)
*  ENDIF. " IF v_actv_flag_f024 IS INITIAL
****BOC by MODUTTA on 13/02/18 for default email id temporarily
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH_CONSORTIA
*&---------------------------------------------------------------------*
* Send mail attachment of consortia form
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_send_mail_attach_consortia .

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_msgv_formnm      TYPE syst_msgv,       " Message Variable
        lv_form_name        TYPE fpname,          " Name of Form Object
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname   VALUE 'ZQTC_FRM_INV_CONSOTIA_MGD_F024', " Name of Form Object
             lc_msgnr_165 TYPE sy-msgno VALUE '165',                            " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',                            " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2',                        " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.                              " ABAP System Field: Message Type

  IF v_ent_retco IS NOT INITIAL.
    RETURN.
  ENDIF.
  IF st_formoutput-pdf IS INITIAL.
    lv_form_name = tnapr-sform.
    lv_msgv_formnm = tnapr-sform. " Added by PBANDLAPAL
    lst_sfpoutputparams-getpdf = abap_true.
    lst_sfpoutputparams-nodialog = abap_true.
    lst_sfpoutputparams-preview = abap_false.

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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
            .
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF. " IF sy-subrc <> 0
          ENDIF. " IF lr_text IS NOT INITIAL
      ENDTRY.

*   Call function module to generate Summary invoice
      CALL FUNCTION lv_funcname                " /1BCDWB/SM00000090
        EXPORTING
          /1bcdwb/docparams       = lst_sfpdocparams
          im_header               = st_header
          im_item                 = i_final
          im_xstring              = v_xstring
          im_footer               = v_footer
          im_remit_to             = v_remit_to
          im_v_tax                = v_tax
          im_v_accmngd_title      = v_accmngd_title
          im_v_bank_detail        = v_bank_detail
          im_v_crdt_card_det      = v_crdt_card_det
          im_v_payment_detail     = v_payment_detail
          im_cust_service_det     = v_cust_service_det
          im_v_totaldue           = v_totaldue
          im_v_subtotal           = v_subtotal
          im_v_vat                = v_vat
          im_v_prepaidamt         = v_prepaidamt
          im_v_subtotal_val       = v_subtotal_val
          im_v_sales_tax          = v_sales_tax
          im_v_totaldue_val       = v_totaldue_val
          im_v_prepaid_amount     = v_paid_amt "v_prepaid_amount
          im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
          im_v_seller_reg         = v_seller_reg
          im_country_uk           = v_country_uk
          im_v_credit_text        = v_credit_text
          im_v_invoice_desc       = v_invoice_desc
          im_v_payment_detail_inv = v_payment_detail_inv
          im_tax_item             = i_tax_item
          im_text_item            = i_text_item
          im_v_terms_cond         = v_terms_cond
          im_v_kwert              = v_kwert
          im_exc_tab              = i_exc_tab
        IMPORTING
          /1bcdwb/formoutput      = st_formoutput
        EXCEPTIONS
          usage_error             = 1
          system_error            = 2
          internal_error          = 3
          OTHERS                  = 4.

      IF sy-subrc <> 0.
*     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
        v_ent_retco = 900.
        RETURN.
*     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF.
* Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
  IF st_formoutput-pdf IS INITIAL.
*   Message: Error occurred generating PDF file
    MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
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
  ENDIF. " IF st_formoutput-pdf IS INITIAL
* End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.
* Subroutine to send mail attachment
  PERFORM f_mail_attachment.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH_DETAIL
*&---------------------------------------------------------------------*
* Send mail attachment of detail form
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_mail_attach_detail .

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,        " Function name
        lv_msgv_formnm      TYPE syst_msgv,       " Message Variable
        lv_form_name        TYPE fpname,          " Name of Form Object
        gs_joboutput        TYPE sfpjoboutput,
        lv_form_name_hd     TYPE fpname,          " Name of Form Object
        lv_form_name_lt     TYPE fpname,          " Name of Form Object
        lv_form_name_it     TYPE fpname,          " Name of Form Object
*       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lv_msg_txt          TYPE bapi_msg, " Message Text
*       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: "lc_form_name TYPE fpname VALUE 'ZQTC_FRM_INV_MNGD_DETAIL_F024', " Name of Form Object
    lc_form_name_hd TYPE fpname VALUE 'ZQTC_FRM_INV_MN_DETAIL_F024_HD', " Name of Form Object
    lc_form_name_lt TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_LT',
    lc_form_name_it TYPE fpname VALUE 'ZQTC_FRM_INV_MD_DETAIL_F024_IT',
    lc_msgnr_165    TYPE sy-msgno VALUE '165',                         " ABAP System Field: Message Number
    lc_msgnr_166    TYPE sy-msgno VALUE '166',                         " ABAP System Field: Message Number
    lc_msgid        TYPE sy-msgid VALUE 'ZQTC_R2',                     " ABAP System Field: Message ID
    lc_err          TYPE sy-msgty VALUE 'E'.                           " ABAP System Field: Message Type

  IF v_ent_retco IS NOT INITIAL.
    RETURN.
  ENDIF.
  IF st_formoutput-pdf IS INITIAL.
*    lv_form_name = tnapr-sform.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lc_form_name_hd
      IMPORTING
        e_funcname = lv_form_name_hd.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lc_form_name_lt
      IMPORTING
        e_funcname = lv_form_name_lt.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lc_form_name_it
      IMPORTING
        e_funcname = lv_form_name_it.
    lv_msgv_formnm = tnapr-sform. " PBANDLAPAL
    lst_sfpoutputparams-getpdf = 'M'."abap_true.
    lst_sfpoutputparams-nodialog = abap_true.
    lst_sfpoutputparams-preview = abap_false.
    lst_sfpoutputparams-nodialog   = abap_true.
*  gs_outputparams-getpdf     = 'M'.
*  gs_outputparams-connection = p_conn.
*  gs_outputparams-bumode     = p_bum.
    DATA : p_conn   TYPE rfcdest,
           p_bum    TYPE fpbumode,
           p_stitch TYPE fpboolean.
    p_conn = 'ADS'.
    p_bum = 'M'.
    lst_sfpoutputparams-connection = p_conn.
    lst_sfpoutputparams-bumode     = p_bum.
*p_stitch = '
*  IF p_assemb = abap_true.
    IF p_stitch = abap_true
        AND cl_fp_feature_test=>is_available(
                iv_connection = p_conn
                iv_feature    = cl_fp_feature_test=>gc_assemble_stitch )
            = abap_true.
      lst_sfpoutputparams-assemble = 'S'.
    ELSE.
      lst_sfpoutputparams-assemble = abap_true.
    ENDIF.
    lst_sfpoutputparams-assemble = 'S'.
*  ENDIF.
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
*   Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
*   End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
*      TRY .
*          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*            EXPORTING
*              i_name     = lv_form_name "lc_form_name
*            IMPORTING
*              e_funcname = lv_funcname.

*        CATCH cx_fp_api_usage INTO lr_err_usg.
*          lr_text = lr_err_usg->get_text( ).
*        CATCH cx_fp_api_repository INTO lr_err_rep.
*          lr_text = lr_err_rep->get_text( ).
*        CATCH cx_fp_api_internal INTO lr_err_int.
*          lr_text = lr_err_int->get_text( ).
*          IF lr_text IS NOT INITIAL.
*            CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*              EXPORTING
*                msg_arbgb              = lc_msgid
*                msg_nr                 = lc_msgnr_166
*                msg_ty                 = lc_err
*              EXCEPTIONS
*                message_type_not_valid = 1
*                no_sy_message          = 2
*                OTHERS                 = 3.
*            .
*            IF sy-subrc <> 0.
*              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*            ENDIF. " IF sy-subrc <> 0
*          ENDIF. " IF lr_text IS NOT INITIAL
*      ENDTRY.

*   Call function module to generate Summary invoice
      DATA : lv_lines_start TYPE vbrp-posnr,
             lv_lines_end   TYPE vbrp-posnr,
             lv_item        LIKE LINE OF i_final.
*  DATA(idx_f) = line_index( i_final[ item = '000001' ] ).
*  DATA(idx_t) = line_index( i_final[ item = '000999' ] ).
      DATA :i_final_1 TYPE ztqtc_item_detail_f024,
            i_wa_1    LIKE LINE OF i_final_1.
*  break sguda.
      DATA : lv_lines TYPE i,
             lv_tot   TYPE i.
      lv_lines_start = 1.
      lv_lines_end   = 999.
*        ENDIF.
      CLEAR:i_final_1[],i_wa_1.
      LOOP AT i_final INTO lv_item FROM lv_lines_start TO lv_lines_end.
        MOVE-CORRESPONDING lv_item TO i_wa_1.
        APPEND i_wa_1 TO i_final_1.
        CLEAR: i_wa_1,lv_item.
      ENDLOOP.
      DATA v_value(255) type c.
      v_value = 'testing'.
*      endDo.
*      CALL FUNCTION lv_funcname
      CALL FUNCTION lv_form_name_hd
        EXPORTING
          /1bcdwb/docparams       = lst_sfpdocparams
          im_header               = st_header
          im_item                 = i_final_1 "i_final
          im_xstring              = v_xstring
          im_footer               = v_footer
          im_remit_to             = v_remit_to
          im_v_tax                = v_tax
          im_v_accmngd_title      = v_accmngd_title
          im_v_bank_detail        = v_bank_detail
          im_v_crdt_card_det      = v_crdt_card_det
          im_v_payment_detail     = v_payment_detail
          im_cust_service_det     = v_cust_service_det
          im_v_totaldue           = v_totaldue
          im_v_subtotal           = v_subtotal
          im_v_vat                = v_vat
          im_v_prepaidamt         = v_prepaidamt
          im_v_subtotal_val       = v_subtotal_val
          im_v_sales_tax          = v_sales_tax
          im_v_totaldue_val       = v_totaldue_val
          im_v_prepaid_amount     = v_paid_amt " v_prepaid_amount
          im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
          IM_V_TITLE              = v_value
          im_v_seller_reg         = v_seller_reg
          im_v_year               = v_year
          im_country_uk           = v_country_uk
          im_v_credit_text        = v_credit_text
          im_v_invoice_desc       = v_invoice_desc
          im_v_payment_detail_inv = v_payment_detail_inv
          im_tax_item             = i_tax_item
          im_text_item            = i_text_item
          im_v_terms_cond         = v_terms_cond
          im_v_kwert              = v_kwert
          im_exc_tab              = i_exc_tab
        IMPORTING
          /1bcdwb/formoutput      = st_formoutput
        EXCEPTIONS
          usage_error             = 1
          system_error            = 2
          internal_error          = 3
          OTHERS                  = 4.
      IF sy-subrc EQ 0.
        PERFORM retrieve_pdf_table USING    gv_index st_formoutput-pages
                                   CHANGING gt_result.
      ENDIF.
*      enddo.
      DESCRIBE TABLE i_final LINES lv_lines.
      lv_lines = lv_lines - 999.
      lv_tot = lv_lines / 1000.
*      lv_lines_start = lv_lines.
*      lv_lines_end  = '999'.
      DO lv_tot TIMES.
*        IF lv_tot = 1.
        lv_lines_start = lv_lines_end + 1.
        lv_lines_end   = lv_lines_end + 1000.
*        ELSE.
*          lv_lines_start = lv_lines_end + 1.
*          lv_lines_end   = lv_lines_end + 1000.
*        ENDIF.
        CLEAR: i_final_1,i_wa_1.
        LOOP AT i_final INTO lv_item FROM lv_lines_start TO lv_lines_end.
          MOVE-CORRESPONDING lv_item TO i_wa_1.
          APPEND i_wa_1 TO i_final_1.
          CLEAR: i_wa_1,lv_item.
        ENDLOOP.
*      ENDDO.
*        lv_lines_start = '1000'.
*        lv_lines_end   = '1999'.
*        CLEAR : i_final_1[],i_wa_1.
*        LOOP AT i_final INTO lv_item FROM lv_lines_start TO lv_lines_end.
*          MOVE-CORRESPONDING lv_item TO i_wa_1.
*          APPEND i_wa_1 TO i_final_1.
*          CLEAR: i_wa_1,lv_item.
*        ENDLOOP.
        CALL FUNCTION lv_form_name_lt
          EXPORTING
            /1bcdwb/docparams       = lst_sfpdocparams
            im_header               = st_header
            im_item                 = i_final_1
            im_xstring              = v_xstring
            im_footer               = v_footer
            im_remit_to             = v_remit_to
            im_v_tax                = v_tax
            im_v_accmngd_title      = v_accmngd_title
            im_v_bank_detail        = v_bank_detail
            im_v_crdt_card_det      = v_crdt_card_det
            im_v_payment_detail     = v_payment_detail
            im_cust_service_det     = v_cust_service_det
            im_v_totaldue           = v_totaldue
            im_v_subtotal           = v_subtotal
            im_v_vat                = v_vat
            im_v_prepaidamt         = v_prepaidamt
            im_v_subtotal_val       = v_subtotal_val
            im_v_sales_tax          = v_sales_tax
            im_v_totaldue_val       = v_totaldue_val
            im_v_prepaid_amount     = v_paid_amt " v_prepaid_amount
            im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
            im_v_seller_reg         = v_seller_reg
            im_v_year               = v_year
            im_country_uk           = v_country_uk
            im_v_credit_text        = v_credit_text
            im_v_invoice_desc       = v_invoice_desc
            im_v_payment_detail_inv = v_payment_detail_inv
            im_tax_item             = i_tax_item
            im_text_item            = i_text_item
            im_v_terms_cond         = v_terms_cond
            im_v_kwert              = v_kwert
            im_exc_tab              = i_exc_tab
          IMPORTING
            /1bcdwb/formoutput      = st_formoutput
          EXCEPTIONS
            usage_error             = 1
            system_error            = 2
            internal_error          = 3
            OTHERS                  = 4.
        IF sy-subrc EQ 0.
          PERFORM retrieve_pdf_table USING    gv_index st_formoutput-pages
                                     CHANGING gt_result.
        ENDIF.
      ENDDO.
*          lv_lines_start = '2000'.
*          lv_lines_end   = '2999'.
*          CLEAR : i_final_1[],i_wa_1.
*          LOOP AT i_final INTO lv_item FROM lv_lines_start TO lv_lines_end.
*            MOVE-CORRESPONDING lv_item TO i_wa_1.
*            APPEND i_wa_1 TO i_final_1.
*            CLEAR: i_wa_1,lv_item.
*          ENDLOOP.
*          CALL FUNCTION lv_form_name_it
*            EXPORTING
*              /1bcdwb/docparams       = lst_sfpdocparams
*              im_header               = st_header
*              im_item                 = i_final_1
*              im_xstring              = v_xstring
*              im_footer               = v_footer
*              im_remit_to             = v_remit_to
*              im_v_tax                = v_tax
*              im_v_accmngd_title      = v_accmngd_title
*              im_v_bank_detail        = v_bank_detail
*              im_v_crdt_card_det      = v_crdt_card_det
*              im_v_payment_detail     = v_payment_detail
*              im_cust_service_det     = v_cust_service_det
*              im_v_totaldue           = v_totaldue
*              im_v_subtotal           = v_subtotal
*              im_v_vat                = v_vat
*              im_v_prepaidamt         = v_prepaidamt
*              im_v_subtotal_val       = v_subtotal_val
*              im_v_sales_tax          = v_sales_tax
*              im_v_totaldue_val       = v_totaldue_val
*              im_v_prepaid_amount     = v_paid_amt " v_prepaid_amount
*              im_v_reprint            = v_reprint  " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
*              im_v_seller_reg         = v_seller_reg
*              im_v_year               = v_year
*              im_country_uk           = v_country_uk
*              im_v_credit_text        = v_credit_text
*              im_v_invoice_desc       = v_invoice_desc
*              im_v_payment_detail_inv = v_payment_detail_inv
*              im_tax_item             = i_tax_item
*              im_text_item            = i_text_item
*              im_v_terms_cond         = v_terms_cond
*              im_v_kwert              = v_kwert
*              im_exc_tab              = i_exc_tab
*            IMPORTING
*              /1bcdwb/formoutput      = st_formoutput
*            EXCEPTIONS
*              usage_error             = 1
*              system_error            = 2
*              internal_error          = 3
*              OTHERS                  = 4.
*          IF sy-subrc EQ 0.
*            PERFORM retrieve_pdf_table USING    gv_index st_formoutput-pages
*                                       CHANGING gt_result.
*          ENDIF.
*        ENDIF.
*      ENDIF.

*      IF sy-subrc <> 0.
**     Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
**       Nothing to do
*        ENDIF. " IF sy-subrc NE 0
*        v_ent_retco = 900.
*        RETURN.
**     End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
*      ELSE. " ELSE -> IF sy-subrc <> 0
*        CALL FUNCTION 'FP_JOB_CLOSE'
      CALL FUNCTION 'FP_JOB_CLOSE'
        IMPORTING
          e_result       = gs_joboutput
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc EQ 0.
        PERFORM retrieve_pdf_table USING    gv_index
                                            gs_joboutput-remaining_pages
                                   CHANGING gt_result.
      ENDIF.
    ENDIF.
  ENDIF.
*        IF sy-subrc <> 0.
**       Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
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
**         Nothing to do
*          ENDIF. " IF sy-subrc NE 0
*          v_ent_retco = 900.
*          RETURN.
**       End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
*        ENDIF. " IF sy-subrc <> 0
*      ENDIF. " IF sy-subrc <> 0
*    ENDIF. " IF sy-subrc IS NOT INITIAL
*  ENDIF.
** Begin of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613
*  IF st_formoutput-pdf IS INITIAL.
**   Message: Error occurred generating PDF file
*    MESSAGE e725(nc) INTO lv_msg_txt. " Error occurred generating PDF file
*    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*      EXPORTING
*        msg_arbgb              = sy-msgid
*        msg_nr                 = sy-msgno
*        msg_ty                 = sy-msgty
*        msg_v1                 = sy-msgv1
*        msg_v2                 = sy-msgv2
*        msg_v3                 = sy-msgv3
*        msg_v4                 = sy-msgv4
*      EXCEPTIONS
*        message_type_not_valid = 1
*        no_sy_message          = 2
*        OTHERS                 = 3.
*    IF sy-subrc NE 0.
**     Nothing to do
*    ENDIF. " IF sy-subrc NE 0
*    v_ent_retco = 900.
*    RETURN.
*  ENDIF. " IF st_formoutput-pdf IS INITIAL
** End   of ADD:ERP-6960:WROY:25-Mar-2018:ED2K911613



*&---------------------------------------------------------------------*
*
  DATA lv_result LIKE LINE OF gt_result.
  READ TABLE gt_result INTO lv_result INDEX 1.
  st_formoutput-pdf = lv_result-content.
*st_formoutput- = lv_result-content.
* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.
* Subroutine to send layout in mail attachment
  PERFORM f_mail_attachment.

**  MODIFY TABLE gt_result FROM lv_result TRANSPORTING invoice item_no mail send
*                                      where time = lv_result-time.
  PERFORM display_result_table USING gt_result.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_TEXT
*&---------------------------------------------------------------------*
*  Subroutine for Read text
*----------------------------------------------------------------------*
*      -->FP_C_NAME_TAX_INV  text
*      <--FP_FP_V_ACCMNGD_TITLE  text
*----------------------------------------------------------------------*
FORM f_read_text  USING    fp_c_name  TYPE thead-tdname " Name
                  CHANGING fp_v_value TYPE char255.     " V_accmngd_title of type CHAR255

* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : li_lines,
          lv_text.
*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_c_name
      object                  = c_object
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
    DATA(lv_lines) = lines( li_lines ).
    READ TABLE li_lines ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX lv_lines.
    IF sy-subrc EQ 0.
      IF <lst_lines>-tdline IS INITIAL.
        CLEAR <lst_lines>-tdformat.
        DELETE li_lines WHERE tdformat IS INITIAL
                          AND tdline IS INITIAL.
      ENDIF. " IF <lst_lines>-tdline IS INITIAL
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_lines
        IMPORTING
          ev_text_string = lv_text.
      IF sy-subrc EQ 0.
        fp_v_value = lv_text.
        CONDENSE fp_v_value.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PREPAID_AMOUNT
*&---------------------------------------------------------------------*
* Retrieve prepaid amount
*----------------------------------------------------------------------*
*      -->FP_ST_VBRK
*      <--FP_V_PREPAID_AMOUNT  text
*----------------------------------------------------------------------*
FORM f_get_prepaid_amount  USING    fp_st_vbrk          TYPE ty_vbrk " Structure for Header detail of invoice form
                           CHANGING fp_v_prepaid_amount TYPE char20  " V_prepaid_amount of type CHAR16
                                    fp_v_paid_amt       TYPE autwr.  " Payment cards: Authorized amount

* Constant declaration
  CONSTANTS : lc_zpay  TYPE kschl VALUE 'ZPAY', " Condition Type
* Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
              lc_stats TYPE kowrr VALUE 'Y',  " No cumulation - Values can be used statistically
              lc_dpmnt TYPE char2 VALUE '45', " Down payment in milestone billing on percentage / value basis
              lc_dcinv TYPE vbtyp VALUE 'M',  " Document Category: Invoice
              lc_bcdpr TYPE fktyp VALUE 'P',  " Billing Category: Down payment request
* End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
              lc_comma TYPE char01 VALUE ','. " Comma of type CHAR01
* Data Declaration
  DATA : lv_kwert TYPE kwert. " Condition value

* Begin of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961
  DELETE i_vbrp WHERE kowrr EQ lc_stats
                  AND fareg CA lc_dpmnt.
  IF sy-subrc EQ 0.
    SELECT f~vbelv,	  "Preceding sales and distribution document
           f~posnv,	  "Preceding item of an SD document
           f~vbeln,	  "Subsequent sales and distribution document
           f~posnn,	  "Subsequent item of an SD document
           f~vbtyp_n, "Document category of subsequent document
           f~fktyp,   "Billing category
           p~netwr,   "Net value of the billing item in document currency
           p~mwsbp    "Tax amount in document currency
      FROM vbfa AS f
     INNER JOIN vbrp AS p
        ON p~vbeln EQ f~vbeln
       AND p~posnr EQ f~posnn
      INTO TABLE @DATA(li_dwn_pmnt)
       FOR ALL ENTRIES IN @i_vbrp
     WHERE f~vbelv   EQ @i_vbrp-aubel
       AND f~posnv   EQ @i_vbrp-aupos
       AND f~vbtyp_n EQ @lc_dcinv
       AND f~fktyp   EQ @lc_bcdpr.
    IF sy-subrc EQ 0.
      LOOP AT li_dwn_pmnt ASSIGNING FIELD-SYMBOL(<lst_dwn_pmnt>).
        fp_v_paid_amt = fp_v_paid_amt +
                        <lst_dwn_pmnt>-netwr +
                        <lst_dwn_pmnt>-mwsbp.
      ENDLOOP. " LOOP AT li_dwn_pmnt ASSIGNING FIELD-SYMBOL(<lst_dwn_pmnt>)
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0
* End   of CHANGE:CR#666:WROY:25-Oct-2017:ED2K908961

  IF i_vbrp IS NOT INITIAL.
    DATA(li_vbrp) = i_vbrp.
    SORT li_vbrp BY aubel.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING aubel.
  ENDIF. " IF i_vbrp IS NOT INITIAL

  IF fp_st_vbrk-zlsch EQ '2'.

* Retrieve condition amount
    SELECT knumv " Number of the document condition
           kposn " Condition item number
           stunr " Step number
           zaehk " Condition counter
           kschl " Condition type
           kwert " Condition value
      FROM konv  " Conditions (Transaction Data)
      INTO TABLE i_konv
      WHERE knumv EQ fp_st_vbrk-knumv
        AND kschl EQ lc_zpay.

    IF sy-subrc EQ 0.
      LOOP AT i_konv INTO DATA(lst_konv).
        lv_kwert = lst_konv-kwert + lv_kwert.
      ENDLOOP. " LOOP AT i_konv INTO DATA(lst_konv)

      WRITE lv_kwert TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
      fp_v_paid_amt = lv_kwert.
    ENDIF. " IF sy-subrc EQ 0

  ELSEIF fp_st_vbrk-zlsch EQ '1'.
*    SELECT SINGLE autwr " Payment cards: Authorized amount
*        INTO @DATA(lv_autwr)
*      FROM fpltc        " Payment cards: Transaction data - SD
*      WHERE fplnr EQ @fp_st_vbrk-rplnr.
*    IF sy-subrc EQ 0.
*      WRITE lv_autwr TO fp_v_prepaid_amount.
*      fp_v_paid_amt = lv_autwr.
*    ENDIF. " IF sy-subrc EQ 0
    SELECT fplnr, "++SRBOSE Cr_558: TR#  ED2K908298
           vbeln  " Sales and Distribution Document Number
      INTO TABLE @DATA(li_fpla)
      FROM fpla   " Billing Plan
      FOR ALL ENTRIES IN @li_vbrp
      WHERE vbeln = @li_vbrp-aubel.
    IF sy-subrc IS INITIAL.
      SELECT fplnr,
             fpltr,
             ccnum,
             autwr " Payment cards: Authorized amount
        INTO TABLE @i_fpltc
        FROM fpltc " Payment cards: Transaction data - SD
        FOR ALL ENTRIES IN @li_fpla
*      WHERE fplnr = @fp_st_vbrk-rplnr.
        WHERE fplnr = @li_fpla-fplnr.
      IF sy-subrc IS INITIAL.
        DATA(li_fpltc) = i_fpltc.
        SORT li_fpltc BY ccnum.
        DELETE ADJACENT DUPLICATES FROM li_fpltc COMPARING ccnum.
        LOOP AT i_fpltc INTO DATA(lst_fpltc).
          IF lst_fpltc-autwr IS NOT INITIAL
            AND fp_v_paid_amt IS INITIAL.
            WRITE lst_fpltc-autwr TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
            fp_v_paid_amt =  lst_fpltc-autwr.
          ENDIF. " IF lst_fpltc-autwr IS NOT INITIAL
          READ TABLE li_fpltc INTO DATA(lst_fpltc1) WITH KEY fplnr = lst_fpltc-fplnr
                                                             fpltr = lst_fpltc-fpltr
                                                             BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF lst_fpltc1-ccnum IS NOT INITIAL.
              DATA(lv_length) = strlen( lst_fpltc1-ccnum ).
              lv_length = lv_length - 4.
              IF v_ccnum IS INITIAL.
                CONCATENATE lst_fpltc1-ccnum+lv_length(4) v_ccnum INTO v_ccnum.
              ELSE. " ELSE -> IF v_ccnum IS INITIAL
                CONCATENATE lst_fpltc1-ccnum+lv_length(4) v_ccnum INTO v_ccnum SEPARATED BY lc_comma.
              ENDIF. " IF v_ccnum IS INITIAL
            ENDIF. " IF lst_fpltc1-ccnum IS NOT INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
        ENDLOOP. " LOOP AT i_fpltc INTO DATA(lst_fpltc)
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc IS INITIAL
  ELSE. " ELSE -> IF fp_st_vbrk-zlsch EQ '2'
*    WRITE lv_autwr TO fp_v_prepaid_amount.
    CONDENSE fp_v_prepaid_amount.
  ENDIF. " IF fp_st_vbrk-zlsch EQ '2'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_SUMMARY
*&---------------------------------------------------------------------*
*  Subroutine for summary print out
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_summary.

* Populate Final item table
  PERFORM f_populate_detail_summ_item USING st_vbrk
                                            i_vbrp
                                            v_paid_amt
                                   CHANGING i_final
                                            v_prepaid_amount
                                            i_subtotal.
****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch Invoice text
  PERFORM f_fetch_title_text USING    st_vbrk
                             CHANGING st_header
                                      v_accmngd_title
                                      v_reprint " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
                                      v_tax
                                      v_remit_to
                                      v_footer
                                      v_bank_detail
                                      v_crdt_card_det
                                      v_payment_detail
                                      v_cust_service_det
                                      v_totaldue
                                      v_subtotal
                                      v_prepaidamt
                                      v_vat
                                      v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069

**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD

* For total due amount less than equal 0, title will be receipt
  IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
*     Subroutine to fetch text value of receipt
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
*   Always dispaly 0 as total due for less than equal 0 amount
    CLEAR v_totaldue_val.
*    CLEAR: v_payment_detail, v_crdt_card_det.
    CLEAR: v_crdt_card_det.
*   Begin of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
    CLEAR: st_header-terms.
*   End   of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
  ENDIF. " IF v_totaldue_val LE 0

**BOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137
  PERFORM f_populate_exc_tab.
**EOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137

*  Subroutine to print layout of summary invoice.
*  PERFORM f_adobe_print_layout_summary.

* If email id is maintained, then send PDF as attachment to the mail address
*  IF i_emailid[] IS NOT INITIAL
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
* AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  PERFORM f_send_mail_attach_summary.
*  ENDIF. " IF i_emailid[] IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_CONSORTIA
*&---------------------------------------------------------------------*
*  Subroutine for consortia invoice print out
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_consortia .
* Populate Final item table
  PERFORM f_populate_detail_con_item USING st_vbrk
                                     i_vbrp
                                     i_vbpa_con
                                     i_adrc
                                     v_paid_amt
                            CHANGING i_final
                                     v_prepaid_amount
                                     i_subtotal.

****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch Invoice text
  PERFORM f_fetch_title_text USING    st_vbrk
                             CHANGING st_header
                                      v_accmngd_title
                                      v_reprint " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
                                      v_tax
                                      v_remit_to
                                      v_footer
                                      v_bank_detail
                                      v_crdt_card_det
                                      v_payment_detail
                                      v_cust_service_det
                                      v_totaldue
                                      v_subtotal
                                      v_prepaidamt
                                      v_vat
                                      v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069

**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD

  IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    CLEAR v_totaldue_val.
*    CLEAR: v_payment_detail, v_crdt_card_det.
    CLEAR: v_crdt_card_det.
*   Begin of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
    CLEAR: st_header-terms.
*   End   of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
  ENDIF. " IF v_totaldue_val LE 0

**BOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137
  PERFORM f_populate_exc_tab.
**EOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137

*  Subroutine to print layout of consortia invoice.
*  PERFORM f_adobe_print_layout_consortia.
*
** If email id is maintained, then send PDF as attachment to the mail address
*  IF i_emailid[] IS NOT INITIAL
** Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
* AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  PERFORM f_send_mail_attach_consortia.
*  ENDIF. " IF i_emailid[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_DETAIL
*&---------------------------------------------------------------------*
*  Subroutine for detail invoice print out
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_detail.

* Populate Final item table
  PERFORM f_populate_detail_inv_item USING st_vbrk
                                     i_vbrp
                                     i_jptidcdassign
                                     i_mara
*Begin of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                                     i_makt
*End   of ADD:ERP-4131:WROY:14-SEP-2017:ED2K908554
                                     i_vbkd
                                     i_vbfa
                                     v_paid_amt
                            CHANGING i_final
                                     v_prepaid_amount
                                     i_subtotal.
****BOC by MODUTTA on 13/11/2017 for JIRA# 5069
* Fetch Invoice text
  PERFORM f_fetch_title_text USING    st_vbrk
                             CHANGING st_header
                                      v_accmngd_title
                                      v_reprint " (++) PBOSE: 10-May-2017: Defect 1990 : ED2K905977
                                      v_tax
                                      v_remit_to
                                      v_footer
                                      v_bank_detail
                                      v_crdt_card_det
                                      v_payment_detail
                                      v_cust_service_det
                                      v_totaldue
                                      v_subtotal
                                      v_prepaidamt
                                      v_vat
                                      v_payment_detail_inv.
****EOC by MODUTTA on 13/11/2017 for JIRA# 5069

**  BOC by MODUTTA on 22/01/2018 for CR# TBD
  DATA(lv_paid_amt) = v_paid_amt.
  DATA(lv_totaldue) = v_totaldue_val.
  IF st_header-credit_flag IS NOT INITIAL
    AND v_ccnum IS NOT INITIAL.
    v_paid_amt = lv_totaldue.
    v_totaldue_val = lv_paid_amt.
  ENDIF. " IF st_header-credit_flag IS NOT INITIAL
**  EOC by MODUTTA on 22/01/2018 for CR# TBD

  IF v_totaldue_val LE 0.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
* If Due amount is 0, then title of the layout will be RECEIPT
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
*   Begin of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   End   of CHANGE:ERP-4930/ERP-5069:WROY:01-Nov-2017:ED2K909229
    CLEAR v_totaldue_val.
*    CLEAR: v_payment_detail, v_crdt_card_det.
    CLEAR: v_crdt_card_det.
*   Begin of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
    CLEAR: st_header-terms.
*   End   of ADD:ERP-5490:WROY:07-Dec-2017:ED2K909761
  ENDIF. " IF v_totaldue_val LE 0

**BOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137
  PERFORM f_populate_exc_tab.
**EOC by MODUTTA on 01/03/2018 for CR# 744 TR:ED2K911137

*  Subroutine to print layout of detail invoice.
*  PERFORM f_adobe_print_layout_detail.

* If email id is maintained, then send PDF as attachment to the mail address
*  IF i_emailid IS NOT INITIAL
* Begin of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
* AND v_ent_screen IS INITIAL.
* End   of ADD:ERP-6712:WROY:23-Feb-2018:ED2K910115
  PERFORM f_send_mail_attach_detail.
*  ENDIF. " IF i_emailid IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*  Subroutine to clear all the global variables
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_clear.

** Refresh global variable
*  CLEAR : v_xstring,
*          st_vbrk,
*          i_vbrp,
*          i_vbpa,
*          st_vbco3,
*          v_output_typ,
*          v_proc_status,
*          v_outputyp_consor,
*          v_outputyp_detail,
*          v_outputyp_summary,
*          v_sales_ofc,
*          r_inv,
*          r_crd,
*          r_dbt,
*          r_country,
*          i_jptidcdassign,
*          i_mara,
*          i_vbfa,
*          i_vbkd,
*          st_kna1,
*          v_trig_attr,
*          st_header,
*          i_adrc,
*          i_emailid,
*          v_accmngd_title,
*          v_tax,
*          v_remit_to,
*          v_footer,
*          v_country_key,
*          v_bank_detail,
*          v_crdt_card_det,
*          v_payment_detail,
*          v_cust_service_det,
*          v_totaldue,
*          v_subtotal,
*          v_prepaidamt,
*          v_paid_amt,
*          v_vat,
*          v_prepaid_amount,
*          i_final.

  CLEAR :  i_vbrp            ,
           i_vbpa            ,
           i_vbpa_con        ,
           i_vbfa            ,
           i_konv            ,
           i_txtmodule       ,
           i_adrc            ,
           i_jptidcdassign   ,
           i_mara            ,
           i_vbkd            ,
           r_country         ,
           r_inv             ,
           r_crd             ,
           r_dbt             ,
           i_content_hex     ,
           i_emailid         ,
           i_final           ,
           st_header_text    ,
           st_kna1           ,
           st_header         ,
           st_but000         ,
           st_but020         ,
           st_item           ,
           st_formoutput     ,
           st_vbrk           ,
           st_vbco3          ,
           v_xstring         ,
           v_accmngd_title   ,
           v_reprint         ,
           v_trig_attr       ,
           v_sales_ofc       ,
           v_country_key     ,
           v_remit_to        ,
           v_footer          ,
           v_tax             ,
           v_bank_detail     ,
           v_output_typ      ,
           v_outputyp_summary,
           v_outputyp_consor ,
           v_outputyp_detail ,
           v_totaldue        ,
           v_subtotal        ,
           v_prepaidamt      ,
           v_vat             ,
           v_proc_status     ,
            v_country_key    ,
           v_crdt_card_det   ,
           v_payment_detail  ,
           v_cust_service_det,
           v_subtotal_val    ,
           v_sales_tax       ,
           v_totaldue_val    ,
           v_prepaid_amount  ,
           v_paid_amt        ,
           v_ent_retco       ,
*          Begin of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
*          v_ent_screen      ,
*          End   of DEL:ERP-6712:WROY:23-Feb-2018:ED2K910115
           v_faz             ,
           v_vkorg           ,
           v_title           ,
           i_veda            ,
           i_tax_data        ,
           v_txt_name        ,
           v_text_line       ,
           v_ind             ,
           v_year            ,
           i_subtotal        ,
           i_tax_item,
           i_text_item,
           i_terms_text,
           i_exc_tab,
           r_email,
           v_ccnum,
           v_seller_reg  ,
           v_invoice_desc,
           v_terms_cond,
           v_payment_detail_inv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBPA_CONSORTIA
*&---------------------------------------------------------------------*
* Get customer number values from VBPA table
*----------------------------------------------------------------------*
*      -->FP_I_VBRP  text
*      <--FP_I_VBPA_CON  text
*----------------------------------------------------------------------*
FORM f_get_vbpa_consortia  USING    fp_i_vbrp     TYPE tt_vbrp
                           CHANGING fp_i_vbpa_con TYPE tt_vbpa.

* Retrieve data from VBPA table
  SELECT vbeln " Sales and Distribution Document Number
         posnr " Item number of the SD document
         parvw " Partner Function
         kunnr " Customer Number
         adrnr " Address
         land1 " Country Key
    INTO TABLE fp_i_vbpa_con
    FROM vbpa  " Sales Document: Partner
    FOR ALL ENTRIES IN fp_i_vbrp
*    WHERE vbeln EQ fp_i_vbrp-vbelv
*      AND posnr EQ fp_i_vbrp-posnv.
    WHERE vbeln EQ fp_i_vbrp-aubel
    AND ( posnr EQ fp_i_vbrp-aupos
     OR   posnr EQ c_posnr_hdr ).
  IF sy-subrc EQ 0.
    SORT fp_i_vbpa_con BY vbeln posnr parvw.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_CUST_NUMBER  text
*      <--P_LV_PERSON_NUMBER_SHIPTO  text
*      <--P_LV_ADD_SHIPTO  text
*      <--P_ST_BUT020  text
*----------------------------------------------------------------------*
FORM f_get_address  USING    fp_lv_cust_number   TYPE char10     " Get_address using fp_lv of type CHAR10
                    CHANGING fp_v_person_number  TYPE ad_persnum " Person number
                             fp_v_addr_type      TYPE char1      " V_add_billto of type CHAR1
                             fp_st_but020        TYPE ty_but020.

* Fetch values from BUT000 table
  SELECT SINGLE partner    " Business Partner Number
                type       " Business partner category
                persnumber " Person number
    FROM but000            " BP: General data I
    INTO st_but000
    WHERE partner EQ fp_lv_cust_number.

  IF sy-subrc EQ 0.
* Fetch address number from BUT020 table
    SELECT SINGLE partner    " Business Partner Number
                  addrnumber " Address number
      INTO fp_st_but020
      FROM but020            " BP: Addresses
      WHERE partner EQ st_but000-partner.
    IF sy-subrc EQ 0.
*
      IF st_but000-type EQ 1.
        CLEAR: fp_v_addr_type,
               fp_v_person_number.
        fp_v_addr_type = 2.
        fp_v_person_number = st_but000-persnumber.
      ELSEIF st_but000-type EQ 2.
        CLEAR: fp_v_addr_type,
               fp_v_person_number.
        fp_v_addr_type = 1.
        fp_v_person_number = st_but000-persnumber.
      ENDIF. " IF st_but000-type EQ 1
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_PDF_APPLICTN_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_pdf_applictn_server.

  IF v_actv_flag_f024 IS INITIAL.
    CONSTANTS : lc_iden          TYPE char10 VALUE 'VF', " Iden of type CHAR10
*   Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
                lc_bus_prcs_bill TYPE zbus_prcocess VALUE 'B', " Business Process - Billing
                lc_prnt_vend_qi  TYPE zprint_vendor VALUE 'Q', " Third Party System (Print Vendor) - QuickIssue
                lc_prnt_vend_bt  TYPE zprint_vendor VALUE 'B'. " Third Party System (Print Vendor) - BillTrust

    DATA: li_output   TYPE ztqtc_output_supp_retrieval.

    DATA: lst_output  TYPE zstqtc_output_supp_retrieval. " Output structure for E098-Output Supplement Retrieval
*   End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585

    DATA: lv_filename     TYPE localfile, " BCOM: Text That Is to Be Converted into MIME
*         Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
          lv_print_vendor TYPE zprint_vendor, " Third Party System (Print Vendor)
          lv_print_region TYPE zprint_region, " Print Region
          lv_country_sort TYPE zcountry_sort, " Country Sorting Key
          lv_file_loc     TYPE file_no,       " Application Server File Path
*         End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
*         Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911723
          lv_bapi_amount  TYPE bapicurr_d, " Currency amount in BAPI interfaces
*         End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911723
          lv_amount       TYPE char24. " Amount of type CHAR24

*   Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
    CLEAR lst_output.
    lst_output-attachment_name = 'SAP Invoice'(004).
    lst_output-pdf_stream = st_formoutput-pdf.
    INSERT lst_output INTO li_output INDEX 1.

*   Determine Print Vendor
    CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
      EXPORTING
        im_bus_prcocess     = lc_bus_prcs_bill       " Business Process (Billing)
        im_country          = st_header-bill_country " Bill-to Party Country
        im_output_type      = v_output_typ           " Output Type
      IMPORTING
        ex_print_vendor     = lv_print_vendor        " Third Party System (Print Vendor)
        ex_print_region     = lv_print_region        " Print Region
        ex_country_sort     = lv_country_sort        " Country Sorting Key
        ex_file_loc         = lv_file_loc            " Application Server File Path
      EXCEPTIONS
        exc_invalid_bus_prc = 1
        exc_no_entry_found  = 2
        OTHERS              = 3.
    IF sy-subrc NE 0.
      CLEAR: lv_print_vendor.
    ENDIF. " IF sy-subrc NE 0

*   Trigger different logic based on Third Party System (Print Vendor)
    CASE lv_print_vendor.
      WHEN lc_prnt_vend_qi. " Third Party System (Print Vendor) - QuickIssue
        CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
          EXPORTING
            im_outputs           = li_output                  " PDF Contents
            im_bus_prcocess      = lc_bus_prcs_bill           " Business Process (Renewal)
            im_print_region      = lv_print_region            " Print Region
            im_country_sort      = lv_country_sort            " Country Sorting Key
            im_file_loc          = lv_file_loc                " Application Server File Path
            im_country           = st_header-bill_country     " Bill-to Party Country
            im_customer          = st_header-bill_cust_number " Bill-to Party Customer
            im_doc_number        = st_header-invoice_number   " SD Document Number (Invoice)
          EXCEPTIONS
            exc_missing_dir_path = 1
            exc_err_opening_file = 2
            OTHERS               = 3.
        IF sy-subrc NE 0.
*         Update Processing Log
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
            v_ent_retco = 900.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc NE 0

      WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
*   End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
*       Begin of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911723
*       MOVE v_totaldue_val TO lv_amount.
*       End   of DEL:ERP-7332:WROY:02-Apr-2018:ED2K911723
*       Begin of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911723
        lv_bapi_amount = v_totaldue_val.
*       Converts a currency amount from SAP format to External format
        CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
          EXPORTING
            currency    = st_header-doc_currency " Currency
            sap_amount  = lv_bapi_amount         " SAP format
          IMPORTING
            bapi_amount = lv_bapi_amount.        " External format
        MOVE lv_bapi_amount TO lv_amount.
*       End   of ADD:ERP-7332:WROY:02-Apr-2018:ED2K911723
        CONDENSE lv_amount.

        CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
          EXPORTING
            im_fpformoutput    = st_formoutput
            im_customer        = st_header-acc_number
            im_invoice         = st_header-invoice_number
            im_amount          = lv_amount
            im_currency        = st_header-doc_currency
            im_date            = st_header-inv_date
            im_form_identifier = lc_iden
            im_ccode           = st_header-comp_code
*           Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
            im_file_loc        = lv_file_loc
*           End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
          IMPORTING
            ex_file_name       = lv_filename.

        IF lv_filename IS NOT INITIAL.
          CLEAR lv_amount.
        ENDIF. " IF lv_filename IS NOT INITIAL
*   Begin of ADD:I0231:WROY:25-Mar-2018:ED2K911585
      WHEN OTHERS.
*       Nothing to Do
    ENDCASE.
*   End   of ADD:I0231:WROY:25-Mar-2018:ED2K911585
  ENDIF. " IF v_actv_flag_f024 IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ITEM_TEXT_LIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_TXT_NAME  text
*      -->P_LV_TEXT_ID  text
*      <--P_V_TEXT_LINE  text
*----------------------------------------------------------------------*
FORM f_get_item_text_lin  USING    fp_v_txt_name   TYPE tdobname " Name
                                   fp_text_id   TYPE tdid        " Text ID
                          CHANGING fp_v_text_line TYPE char255.  " V_text_line of type CHAR100

*   Data declaration
  DATA : li_lines_1 TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text    TYPE string.

  CLEAR : lv_text,
          fp_v_text_line.

*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_text_id
      language                = st_header-language
      name                    = fp_v_txt_name
      object                  = c_obj_vbbp
    TABLES
      lines                   = li_lines_1
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
    DATA(lv_lines) = lines( li_lines_1 ).
    READ TABLE li_lines_1 ASSIGNING FIELD-SYMBOL(<lst_lines>) INDEX lv_lines.
    IF sy-subrc EQ 0.
      IF <lst_lines>-tdline IS INITIAL.
        CLEAR <lst_lines>-tdformat.
        DELETE li_lines_1 WHERE tdformat IS INITIAL
                            AND tdline IS INITIAL.
      ENDIF. " IF <lst_lines>-tdline IS INITIAL
      CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
        EXPORTING
          it_tline       = li_lines_1
        IMPORTING
          ev_text_string = lv_text.
      IF sy-subrc EQ 0.
        fp_v_text_line = lv_text.
        CONDENSE fp_v_text_line.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
FORM f_read_sub_type  USING  fp_v_txt_name   TYPE tdobname " Name
                             fp_text_id   TYPE tdid        " Text ID
                    CHANGING fp_v_text_line TYPE char255.  " V_text_line of type CHAR100

  CONSTANTS: lc_object TYPE tdobject VALUE 'TEXT'. " Texts: Application Object

*   Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

  CLEAR : lv_text,
          fp_v_text_line.

*   Fetch title text for invoice
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = fp_text_id
      language                = st_header-language
      name                    = fp_v_txt_name
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
      fp_v_text_line = lv_text.
      CONDENSE fp_v_text_line.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_ENH_CTRL
*&---------------------------------------------------------------------*
*       Check if ZCA_ENH_CTRL has F024 email id checked
*----------------------------------------------------------------------*
FORM f_check_enh_ctrl .
  CONSTANTS:
    lc_wricef_id_f024 TYPE zdevid   VALUE 'F024_EMAIL', " Development ID
    lc_ser_num_1_f024 TYPE zsno     VALUE '001'.        " Serial Number

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_f024
      im_ser_num     = lc_ser_num_1_f024
    IMPORTING
      ex_active_flag = v_actv_flag_f024.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_T005_DATA
*&---------------------------------------------------------------------*
*       Get details from T005 table with bill to country
*----------------------------------------------------------------------*
FORM f_get_t005_data CHANGING fp_v_waers TYPE waers_005 " Country currency
                              fp_v_ind TYPE xegld.      " Indicator: European Union Member?
* Retrieve local currency from T005 table
  SELECT SINGLE xegld,
                waers " Country currency
           INTO @DATA(lst_t005)
           FROM t005  " Countries
           WHERE land1 = @st_header-bill_country.

  IF sy-subrc EQ 0.
    fp_v_ind = lst_t005-xegld.
    fp_v_waers = lst_t005-waers.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_EXC_TAB
*&---------------------------------------------------------------------*
*       To populate exchange table in output
*----------------------------------------------------------------------*
FORM f_populate_exc_tab.

  DATA: lv_exc_rate TYPE ukurs_curr,       "kzwi6, "kursf,                      " Exchange rate
        lv_loc_amt  TYPE ukm_credit_limit. " Credit Limit

* Begin of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911320
  IF st_header-doc_currency NE v_waers.
* End   of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911320
    IF v_subtotal_val IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_subtotal_val
* Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                                      v_waers
* End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_subtotal_val IS NOT INITIAL

    IF v_sales_tax IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_sales_tax
* Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                                      v_waers
* End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_sales_tax IS NOT INITIAL
* Begin of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911320
  ENDIF. " IF st_header-doc_currency NE v_waers
* End   of ADD:ERP-7017:WROY:13-Mar-2018:ED2K911320

* Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
  IF st_header-doc_currency NE v_local_curr AND
     v_waers                NE v_local_curr.
    IF v_subtotal_val IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_subtotal_val
                                      v_local_curr
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_subtotal_val IS NOT INITIAL

    IF v_sales_tax IS NOT INITIAL.
      PERFORM f_get_exc_rate USING    v_sales_tax
                                      v_local_curr
                             CHANGING lv_exc_rate
                                      lv_loc_amt.
    ENDIF. " IF v_sales_tax IS NOT INITIAL
  ENDIF. " IF st_header-doc_currency NE v_local_curr AND
* End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXC_RATE
*&---------------------------------------------------------------------*
*       Get exchange rate
*----------------------------------------------------------------------*
FORM f_get_exc_rate  USING    fp_lv_forgn_amt TYPE any
* Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                              fp_v_waers      TYPE waers " Currency Key
* End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
                     CHANGING fp_lv_exc_rate TYPE ukurs_curr       "kzwi6 "kursf
                              fp_lv_loc_amt TYPE ukm_credit_limit. " Credit Limit
  DATA:lst_exc_tab TYPE ztqtc_exchange_tab_invoice. " Exchange Rate table structure for invoice forms

*         Translate foreign currency amount to local currency
  CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
    EXPORTING
      date             = st_vbrk-fkdat          "Currency translation date
      foreign_amount   = fp_lv_forgn_amt        "Amount in foreign currency
      foreign_currency = st_header-doc_currency "Currency key for foreign currency
*     Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
      local_currency   = fp_v_waers "Currency key for local currency
*     End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
*     Begin of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
*     local_currency   = v_waers                "Currency key for local currency
*     End   of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
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
  ELSE. " ELSE -> IF sy-subrc NE 0
*            Amount
    IF fp_lv_exc_rate LT 0.
      fp_lv_exc_rate = 1 / ( -1 * fp_lv_exc_rate ).
    ENDIF. " IF fp_lv_exc_rate LT 0
    WRITE fp_lv_forgn_amt TO lst_exc_tab-amount CURRENCY st_header-doc_currency.
    CONDENSE lst_exc_tab-amount.
    CONCATENATE lst_exc_tab-amount '@' INTO lst_exc_tab-amount.

*            Exchange rate
*   Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
    WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate.
*   End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   Begin of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   WRITE fp_lv_exc_rate TO lst_exc_tab-exc_rate CURRENCY v_waers. "st_header-doc_currency.
*   End   of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
    CONDENSE lst_exc_tab-exc_rate.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_exc_tab-exc_rate.

*            Local Currency
*   Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
    lst_exc_tab-loc_curr = fp_v_waers.
*   End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   Begin of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   lst_exc_tab-loc_curr = v_waers.
*   End   of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
    CONCATENATE lst_exc_tab-loc_curr '=' INTO lst_exc_tab-loc_curr.

*            Converted Amount
*   Begin of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
    WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY fp_v_waers.
*   End   of ADD:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   Begin of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
*   WRITE fp_lv_loc_amt TO lst_exc_tab-conv_amt CURRENCY v_waers.
*   End   of DEL:ERP-7178:WROY:21-Mar-2018:ED2K911548
    CONDENSE lst_exc_tab-conv_amt.

    APPEND lst_exc_tab TO i_exc_tab.
    CLEAR: lst_exc_tab,
           fp_lv_exc_rate,
           fp_lv_loc_amt.
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LANGU  text
*      <--P_I_STD_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_stxh_data  CHANGING fp_i_std_text TYPE tt_std_text.

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
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F024*', " R of type CHAR10
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
    AND tdspras = st_header-language.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RETRIEVE_PDF_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_INDEX  text
*      -->P_ST_FORMOUTPUT_PAGES  text
*      <--P_GT_RESULT  text
*----------------------------------------------------------------------*
FORM retrieve_pdf_table  USING VALUE(p_index) TYPE syindex
                               VALUE(p_pages)  TYPE fppagecount
                         CHANGING    p_pdf_tab TYPE gty_result_tab.
  DATA lt_pdf_table TYPE tfpcontent.
  DATA ls_result    TYPE gty_result.

  CALL FUNCTION 'FP_GET_PDF_TABLE'
    IMPORTING
      e_pdf_table = lt_pdf_table.
  DATA lv_l TYPE i.
  LOOP AT lt_pdf_table INTO ls_result-content.
    MOVE p_index TO ls_result-index.
    GET TIME.
    MOVE sy-uzeit TO ls_result-time.
    ls_result-size = xstrlen( ls_result-content ).
    IF sy-tabix = lines( lt_pdf_table ).
      ls_result-pages = p_pages.
    ENDIF.

    DESCRIBE TABLE i_vbpa LINES lv_l.
    ls_result-invoice = p_vbe.
    ls_result-item_no = lv_l.
    ls_result-mail    = p_mail.
    ls_result-send    = sy-uname.
    INSERT ls_result INTO TABLE p_pdf_tab.
  ENDLOOP.
ENDFORM.
*&      Form  display_result_table
*&---------------------------------------------------------------------*
FORM display_result_table USING p_pdf_tab TYPE gty_result_tab.
  DATA ls_layout   TYPE slis_layout_alv.
  DATA ls_field    TYPE slis_fieldcat_alv.
  DATA lt_fieldcat TYPE slis_t_fieldcat_alv.

  ls_layout-numc_sum          = abap_true.
  ls_layout-colwidth_optimize = abap_true.

  ls_field-fieldname = 'INDEX'.
  ls_field-key       = abap_true.
  ls_field-rollname  = 'SYINDEX'.
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'TIME'.
  ls_field-key       = abap_false.
  ls_field-rollname  = 'SYUZEIT'.
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'PAGES'.
  ls_field-no_zero   = abap_true.
  ls_field-do_sum    = abap_true.
  ls_field-rollname  = 'FPPAGECOUNT'.
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'SIZE'.
  ls_field-no_zero   = abap_false.
  ls_field-rollname  = 'FILESIZE'.
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'INVOICE'.
  ls_field-no_zero   = abap_true.
*  ls_field-do_sum    = abap_true.
  ls_field-seltext_m  = 'Invoice Number'.
  ls_field-outputlen  = 15.
*  ls_field-rollname  = .
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'ITEM_NO'.
  ls_field-no_zero   = abap_true.
*  ls_field-do_sum    = abap_true.
  ls_field-seltext_m  = 'Invoice Total Line Item'.
  ls_field-outputlen  = 30.
*  ls_field-rollname  = .
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'MAIL'.
*  ls_field-no_zero   = abap_true.
*  ls_field-do_sum    = abap_true.
  ls_field-seltext_m  = 'Receiver Mail'.
  ls_field-outputlen  = 30.
*  ls_field-rollname  = .
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  ls_field-fieldname = 'SEND'.
*  ls_field-no_zero   = abap_true.
*  ls_field-do_sum    = abap_true.
  ls_field-seltext_m  = 'Sender User ID'.
  ls_field-outputlen  = 15.
*  ls_field-rollname  = 'Sender User ID'.
  APPEND ls_field TO lt_fieldcat.
  CLEAR ls_field.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'LIST_CALLBACK'
      is_layout               = ls_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = p_pdf_tab.
ENDFORM.                    "display_result_table
*&---------------------------------------------------------------------*
*&      Form  list_callback
*&---------------------------------------------------------------------*
FORM list_callback USING p_ucomm TYPE syucomm               "#EC CALLED
                         p_field TYPE slis_selfield.
  INCLUDE fp_spool_constants.                              "#EC INCL_OK
  DATA ls_result TYPE gty_result.
  DATA lv_file   TYPE fpfile.
  DATA lv_sep    TYPE c.
  DATA lt_data   TYPE tsfixml.
  DATA lv_rc     TYPE sysubrc.

  IF p_ucomm = '&IC1'.
    READ TABLE gt_result INDEX p_field-tabindex INTO ls_result.

    CALL METHOD cl_gui_frontend_services=>get_temp_directory
      CHANGING
        temp_dir             = lv_file
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'E' NUMBER '256'.
    ENDIF.
    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2
        OTHERS            = 3.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'E' NUMBER '256'.
    ENDIF.

    CALL METHOD cl_gui_frontend_services=>get_file_separator
      CHANGING
        file_separator       = lv_sep
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'E' NUMBER '256'.
    ENDIF.
    CONCATENATE lv_file lv_sep sy-repid c_file_ext_pdf INTO lv_file.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = ls_result-content
      TABLES
        binary_tab = lt_data.
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        bin_filesize            = xstrlen( ls_result-content )
        filename                = lv_file
        filetype                = 'BIN'
      CHANGING
        data_tab                = lt_data
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'E' NUMBER '256'.
    ENDIF.

    CALL METHOD cl_gui_frontend_services=>execute
      EXPORTING
        document               = lv_file
        synchronous            = 'X'
      EXCEPTIONS
        cntl_error             = 1
        error_no_gui           = 2
        bad_parameter          = 3
        file_not_found         = 4
        path_not_found         = 5
        file_extension_unknown = 6
        error_execute_failed   = 7
        synchronous_failed     = 8
        not_supported_by_gui   = 9
        OTHERS                 = 10.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'I' NUMBER '256'.
    ENDIF.

    CALL METHOD cl_gui_frontend_services=>file_delete
      EXPORTING
        filename             = lv_file
      CHANGING
        rc                   = lv_rc
      EXCEPTIONS
        file_delete_failed   = 1
        cntl_error           = 2
        error_no_gui         = 3
        file_not_found       = 4
        access_denied        = 5
        unknown_error        = 6
        not_supported_by_gui = 7
        wrong_parameter      = 8
        OTHERS               = 9.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID 'ED' TYPE 'E' NUMBER '256'.
    ENDIF.
  ENDIF.
ENDFORM.                    "list_callback
