*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCN_CONSOLIDATED_NOTICE_F00
* PROGRAM DESCRIPTION:Consolidated Renewal Notice
* DEVELOPER:          SAYANDAS (Sayantan Das)
* CREATION DATE:      08-MAY-2018
* OBJECT ID:          F043
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913033
* REFERENCE NO: ERP-6458
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         20-Aug-2018
* DESCRIPTION:  Pass Society information for retrieving Supplement Docs
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913401
* REFERENCE NO: ERP-7747
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         19-SEP-2018
* DESCRIPTION:  Additional Direct Debit Form is included
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K908565
* REFERENCE NO: RITM0070026
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         26-Sep-2018
* DESCRIPTION:  Fix issues in Application Server Download process
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  RITM0075536
* REFERENCE NO: ED1K908667
* DEVELOPER:    Randheer Kumar (RKUMAR)
* DATE:         09-October-2018
* DESCRIPTION:  Ship-To and Bill-To should have bill-to company codee
*               address standards
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913582
* REFERENCE NO: CR-7730
* DEVELOPER:    Kiran Kumar Ravuri (KKRAVURI)
* DATE:         12-OCTOBER-2018
* DESCRIPTION:  Change label "Subscription Reference" to "Membership Number"
*               if Material Group 5 = Managed (MA)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913775
* REFERENCE NO: ERP-7189 and 7431
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  11/05/2018
* DESCRIPTION: Need to replace MOD10 function module with MOD11
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909899
* REFERENCE NO: INC0236404
* DEVELOPER:    Rajasekhar.T (RBTIRUMALA)
* DATE:         29/03/2019
* DESCRIPTION:  To Change message Email ID is not maintained for Bill to party(556)
*               Message Class ZQTC_R2
*&---------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  CR- 7841
* REFERENCE NO: ED1K910095
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         30-Apr-2019
* DESCRIPTION:  Replace the 'Year' in item section with 'Contract start date'
*               and 'Contract End Date'.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  INC0241931
* REFERENCE NO: ED1K910154
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         21-May-2019
* DESCRIPTION:  Check the Renewal Status is Blank for the Reminders.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-8994
* REFERENCE NO: ED2K917399
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         28-JAN-2020
* DESCRIPTION:  Add Buyer VAT ID
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-2232
* REFERENCE NO: ED2K919082
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         06/29/2020
* DESCRIPTION:  Reflect Fright forwarder on billing documents where Ship-to currently resides.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-24393
* REFERENCE NO: ED2K919425
* DEVELOPER:    Siva Guda (SGUDA)
* DATE:         09/09/2020
* DESCRIPTION:  DD Mandate Enhancement for VCH Renewals and Firm Invoices
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-46664
* REFERENCE NO: ED2K924330
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         08/17/2021
* DESCRIPTION:  Renewal Reminder Numbering should be sppress if Activity
*               type as "RN'.
* 1) If Activity is "RN", we should not print Reminder# text in form.
* 2) Rest of the logic shoils work as is.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-47818
* REFERENCE NO: ED1K913605
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         10/21/2021
* DESCRIPTION:   Indian Agent Processing
* 1) Change email address to indiaagent@wiley.com (Top Left Box on the Form)
* 2) Credit Card Option removed.
* 3) Change Wire Transfer Details as shown as below.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-51284/FMM-5645
* REFERENCE NO:  ED1K913793
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40064
* REFERENCE NO: ED2K924586
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         09/17/2021
* DESCRIPTION:
* 1) if Material group4 (VBRP- MVGR4= BK- eBooks, JU-eJournal, BU-eBundle
*    then print the media type as Digital
* 2) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue then print the media type as Print
* 3) if Material group 4 (i.e. VBRP- MVGR4) = BO-pBooks, JO-pJournal,
*    SI-pSingle_Issue, BK- eBooks, JU-eJournal, BU-eBundle then print
*    the media type as Print & digital.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-40064
* REFERENCE NO: ED1K913942
* DEVELOPER:    Madavoina Rajkumar MRAJKUMAR)
* DATE:         01/05/2022
* DESCRIPTION: Correction on BOM Media changes
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONSOLIDATED_NOTICE_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PROCESSING
*&---------------------------------------------------------------------*
*       Processing of the adobe form output
*----------------------------------------------------------------------*
FORM f_processing_form  CHANGING fp_v_returncode TYPE sysubrc. " Return Code
*  Perform to clear global variables
  PERFORM f_initialize_all.

*  PERFORM to get constants
  PERFORM f_get_constant CHANGING i_constant.

* Perform to populate Wiley Logo
  PERFORM f_get_wiley_logo CHANGING v_xstring.

* Get data from VBAK table
  PERFORM f_get_vbak_data CHANGING st_vbak.

* Get Data from VBAP Table
  PERFORM f_get_vbap_data CHANGING i_vbap.

* Get Data from VBPA Table
  PERFORM f_get_vbpa_data CHANGING i_vbpa.

*   Get language
  PERFORM f_get_language CHANGING st_header.

* Perform to fetch data from VBFA table
  PERFORM f_get_vbfa_data.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  IF r_po_type[] IS NOT   INITIAL.
    CLEAR v_po_type.
    PERFORM f_po_type_frm_vbkd.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
* Perform to fetch data from VEDA and Other tables
  PERFORM f_get_veda_data.

* Perform to fetch data from KONV table
  PERFORM f_get_konv_data.

* Perform to get Seller Registration
  PERFORM f_get_seller_tax.

* Perform to get Default Standard Text
  PERFORM f_get_stxh_data CHANGING i_std_text.

* Perform to populate standard text dynamically on basis of company code and cuurency key
  PERFORM f_populate_std_text  USING st_header.

* Perform to populate line items in form
  PERFORM f_populate_item.

* Perform to populate barcode
  PERFORM f_populate_barcode.

  IF fp_v_returncode = 0.
    IF nast-nacha EQ '1'.
* Perform from where the form has been called and print PDF
      PERFORM f_adobe_print_output CHANGING fp_v_returncode.
    ELSEIF nast-nacha EQ '5'. " ELSE -> IF nast-nacha EQ lc_01
* Perform has been used to send mail with an attachment of PDF
      PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
    ENDIF. " IF nast-nacha EQ '1'
  ENDIF. " IF fp_v_returncode = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZE_ALL
*&---------------------------------------------------------------------*
*       Clear global variables
*----------------------------------------------------------------------*
FORM f_initialize_all.

  CLEAR: v_xstring,
         v_waerk,
         i_final,
         i_vbap,
         i_vbpa,
         i_vbpa2,
         i_order,
         i_mara,
         i_combination,
         i_comb_final,
         i_header,
         i_address,
         st_address,
         v_footer ,
         i_tax_tab,
         v_remit_to_tbt,
         v_credit_tbt,
         v_email_tbt,
         v_banking1_tbt,
         v_banking2_tbt,
         v_cust_serv_tbt,
         i_final,
         i_final_email,
*        Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         r_mtart_multi_bom,
         r_mtart_combo_bom,
         r_idcodetype,
         r_sanc_countries,
         r_vkorg_f044,
         r_zlsch_f044,
*        End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         v_sub_total,
         v_sub_total_c,
         v_total,
         v_taxes,
         v_taxes_c,
         v_total_c,
         v_discount,
         v_discount_c,
         i_input,"added by Randheer (rkumar2) for performance issue
         r_mat_grp5,   " ADD:CR#7730 KKRAVURI20181012
         r_output_typ. " ADD:CR#7730 KKRAVURI20181012

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_WILEY_LOGO
*&---------------------------------------------------------------------*
*       To print Wiley logo
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
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAP_DATA
*&---------------------------------------------------------------------*
*       Get item details
*----------------------------------------------------------------------*
FORM f_get_vbap_data CHANGING fp_i_vbap TYPE tt_vbap.

  DATA: li_vbap_tmp TYPE TABLE OF ty_vbap.

  st_header-vbeln = nast-objky+0(10).

*** Select Data from VBAP Table
  SELECT  vbeln  "Sales Document
          posnr  "Sales Document Item
          matnr  "Material Number
          arktx  "Short text for sales order item
          uepos  "  Higher-level item in bill of material structures
          kwmeng "Cumulative Order Quantity in Sales Units
          kzwi1  "Subtotal 1 from pricing procedure for condition
          kzwi2  "Subtotal 2 from pricing procedure for condition
          kzwi3  " Subtotal 3 from pricing procedure for condition
          kzwi4  "Subtotal 4 from pricing procedure for condition
          kzwi5  "Subtotal 5 from pricing procedure for condition
          kzwi6  "Subtotal 6 from pricing procedure for condition
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
          mvgr4  "Material Group 4
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
          mvgr5  "Material group-5, ADD for CR#7730 KKRAVURI20181012  ED2K913582
     FROM vbap   "Sales Document: Item Data
    INTO TABLE fp_i_vbap
    WHERE vbeln = st_header-vbeln
    AND   abgru = space.
  IF sy-subrc = 0.
    SORT fp_i_vbap BY vbeln posnr.
    li_vbap_tmp[] = fp_i_vbap[].
    SORT li_vbap_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING matnr.
    IF li_vbap_tmp IS NOT INITIAL.
*  Fetch media values from MARA
      SELECT matnr           " Material Number
             mtart           " Material type
             volum           " Volume
             ismhierarchlevl " Hierarchy Level (Media Product Family, Product or Issue)
             ismmediatype    " Media Type
             ismnrinyear     " Issue Number (in Year Number)
             ismyearnr       " Media issue year number
             ismcopynr       " Copy Number of Media Issue
        FROM mara            " General Material Data
        INTO TABLE i_mara
        FOR ALL ENTRIES IN li_vbap_tmp
        WHERE matnr EQ li_vbap_tmp-matnr.
      IF sy-subrc EQ 0.
        SORT i_mara BY matnr.

* Fetch ID codes of material from JPTIDCDASSIGN table
        SELECT matnr         " Material Number
               idcodetype    " Type of Identification Code
               identcode     " Identification Code
          FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
          INTO TABLE i_jptidcdassign
           FOR ALL ENTRIES IN i_mara
         WHERE matnr      EQ i_mara-matnr
           AND idcodetype IN r_idcodetype.
        IF sy-subrc EQ 0.
          SORT i_jptidcdassign BY matnr.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_vbap_tmp IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBPA_DATA
*&---------------------------------------------------------------------*
*       Get address data
*----------------------------------------------------------------------*
FORM f_get_vbpa_data CHANGING fp_i_vbpa TYPE tt_vbpa.
*******Local Constant declaration
  CONSTANTS: lc_bp TYPE parvw VALUE 'BP', " Bill to address
             lc_we TYPE parvw VALUE 'WE', " Ship to address
             lc_re TYPE parvw VALUE 'RE', " Ship to address
             lc_za TYPE parvw VALUE 'ZA', " Partner Function
             lc_sp TYPE vbpa-parvw VALUE 'SP'.  " Forwrding Agent " ADD:ERPM-2232:SGUDA:26-June-2020:D2K918751

********Local Data declaration
  DATA: li_vbpa       TYPE STANDARD TABLE OF ty_vbpa,
        lst_vbpa      TYPE ty_vbpa,
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K919082
        lst_vbeln     TYPE vbak, "Sales Document
        lt_vbpa_ff    TYPE vbpa_tab,       " Frighet Forwarder
        lv_ff_flag(1) TYPE c,
        lv_multiple   TYPE c.
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K919082

*******To populate the Bill to Address need to fetch data from VBPA table
  SELECT vbeln "Sales and Distribution Document Number
         posnr "Item number of the SD document
         parvw "Partner Function
         kunnr "Customer Number
         adrnr "Address
         land1 "Country Key
    FROM vbpa  " Sales Document: Partner
    INTO TABLE i_vbpa
    WHERE vbeln = st_header-vbeln.
  IF sy-subrc IS INITIAL.
    SORT i_vbpa BY vbeln parvw posnr.
*******Read the local internal table to fetch the customer number, address number and country key
*******by passing Partner Function as RE because for Bill-To-Party if we pass BP it has been
*******converted to RE. So RE has been used to populate Bill-To-Party address
    CLEAR: lst_vbpa.
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = st_header-vbeln
                                             parvw = lc_re
                                     BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      st_address-kunnr_bp = lst_vbpa-kunnr. "Customer Number
      st_address-adrnr_bp = lst_vbpa-adrnr. "Address Number
      st_address-land1_bp = lst_vbpa-land1. "Country key
    ENDIF. " IF sy-subrc IS INITIAL
*- Begin of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K919082
    lst_vbeln-vbeln = st_header-vbeln.
    CALL FUNCTION 'ZQTC_FF_DETERMINE'
      EXPORTING
        im_vbak          = lst_vbeln
*       IM_VBAP          =
*       im_flag          = space
      IMPORTING
        ex_ff_flag       = lv_ff_flag
      CHANGING
        ch_vbpa          = lt_vbpa_ff
        ch_multiple_ship = lv_multiple.
    IF lt_vbpa_ff[] IS NOT INITIAL.
      DATA(li_vbpa_temp_ff) = lt_vbpa_ff[].
      DELETE li_vbpa_temp_ff WHERE parvw NE lc_sp.
      DELETE ADJACENT DUPLICATES FROM li_vbpa_temp_ff COMPARING adrnr.
      DATA(lv_count_vbpa_ff) = lines( li_vbpa_temp_ff ).
      IF  lv_count_vbpa_ff > 1.
        st_address-multiple_shipto = abap_true.
      ELSE.
        CLEAR  st_address-multiple_shipto.
        READ TABLE li_vbpa_temp_ff INTO DATA(lst_fright_forwarder)  INDEX 1.
        st_address-kunnr_we = lst_fright_forwarder-kunnr. "Customer Number
        st_address-adrnr_we = lst_fright_forwarder-adrnr. "Address Number
        st_address-land1_we = lst_fright_forwarder-land1. "Country key
      ENDIF. " IF lv_count_vbpa > 1
    ENDIF.
    IF lv_multiple IS NOT INITIAL.
      st_address-multiple_shipto = abap_true.
    ENDIF.
    IF  ( st_address-adrnr_we IS INITIAL
           AND st_address-multiple_shipto IS INITIAL ).
*- End of ADD:ERPM-2232:SGUDA:26-June-2020:ED2K919082
*******Read the local internal table to fetch the customer number, address number and country key
*******by passing Partner Function as WE
      CLEAR: lst_vbpa.
      READ TABLE i_vbpa INTO lst_vbpa WITH KEY vbeln = st_header-vbeln
                                                parvw = lc_we
                                                BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        st_address-kunnr_we = lst_vbpa-kunnr. "Customer Number
        st_address-adrnr_we = lst_vbpa-adrnr. "Address Number
        st_address-land1_we = lst_vbpa-land1. "Country key
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF.  "ADD:ERPM-2232:SGUDA:26-June-2020:ED2K919082
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constant  CHANGING fp_i_constant TYPE tt_constant.

*  Local data and constant declaration
  DATA: lst_constant   TYPE ty_constant.

  CONSTANTS: lc_devid        TYPE zdevid     VALUE 'F037',           " Development ID
             lc_idcodetype1  TYPE rvari_vnam VALUE 'IDCODETYPE1',    " ABAP: Name of Variant Variable
             lc_idcodetype2  TYPE rvari_vnam VALUE 'IDCODETYPE2',    " ABAP: Name of Variant Variable
             lc_mtart_multi  TYPE rvari_vnam VALUE 'MULTI_JRNL_BOM', " ABAP: Name of Variant Variable
             lc_mtart_combo  TYPE rvari_vnam VALUE 'COMBO_BOM',      " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
             lc_vkorg        TYPE rvari_vnam VALUE 'VKORG', " ABAP: Name of Variant Variable
             lc_zlsch        TYPE rvari_vnam VALUE 'ZLSCH', " ABAP: Name of Variant Variable
*            End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
             lc_kvgr1        TYPE rvari_vnam VALUE 'KVGR1', " ABAP: Name of Variant Variable  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
*            Begin of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
             lc_sanctioned_c TYPE rvari_vnam VALUE 'SANCTIONED_COUNTRY', " ABAP: Name of Variant Variable
*            End   of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
* BOC: CR#7730 KKRAVURI20181012  ED2K913582
             lc_mat_grp5     TYPE rvari_vnam VALUE 'MATERIAL_GROUP5',
             lc_output_typ   TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
* EOC: CR#7730 KKRAVURI20181012  ED2K913582
*- Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
             lc_po_type       TYPE rvari_vnam VALUE 'FTP_BSARK',
*- End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_tax_id       TYPE rvari_vnam VALUE 'TAX_ID',
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE',
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
             lc_print        TYPE rvari_vnam VALUE 'PRINT_MEDIA_PRODUCT',
             lc_digital      TYPE rvari_vnam VALUE 'DIGITAL_MEDIA_PRODUCT'.
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
  SELECT
       devid            " Development ID
       param1           " ABAP: Name of Variant Variable
       param2           " ABAP: Name of Variant Variable
       srno             " ABAP: Current selection number
       sign             " ABAP: ID: I/E (include/exclude values)
       opti             " ABAP: Selection option (EQ/BT/CP/...)
       low              " Lower Value of Selection Condition
       high             " Upper Value of Selection Condition
       FROM zcaconstant " Wiley Application Constant Table
       INTO TABLE fp_i_constant
       WHERE  devid EQ lc_devid.

  IF sy-subrc IS INITIAL.
    SORT fp_i_constant BY param1.
    LOOP AT fp_i_constant INTO lst_constant.
      CASE lst_constant-param1.
        WHEN lc_idcodetype1.
          v_idcodetype_1 = lst_constant-low.
          APPEND INITIAL LINE TO r_idcodetype ASSIGNING FIELD-SYMBOL(<lst_idcodetype>).
          <lst_idcodetype>-sign   = lst_constant-sign.
          <lst_idcodetype>-option = lst_constant-opti.
          <lst_idcodetype>-low    = lst_constant-low.
          <lst_idcodetype>-high   = lst_constant-high.
        WHEN lc_idcodetype2.
          v_idcodetype_2 = lst_constant-low.
          APPEND INITIAL LINE TO r_idcodetype ASSIGNING FIELD-SYMBOL(<lst_idcodetype1>).
          <lst_idcodetype1>-sign   = lst_constant-sign.
          <lst_idcodetype1>-option = lst_constant-opti.
          <lst_idcodetype1>-low    = lst_constant-low.
          <lst_idcodetype1>-high   = lst_constant-high.
        WHEN lc_mtart_multi.
          APPEND INITIAL LINE TO r_mtart_multi_bom ASSIGNING FIELD-SYMBOL(<lst_mtart_multi>).
          <lst_mtart_multi>-sign   = lst_constant-sign.
          <lst_mtart_multi>-option = lst_constant-opti.
          <lst_mtart_multi>-low    = lst_constant-low.
          <lst_mtart_multi>-high   = lst_constant-high.
        WHEN lc_mtart_combo.
          APPEND INITIAL LINE TO r_mtart_combo_bom ASSIGNING FIELD-SYMBOL(<lst_mtart_combo>).
          <lst_mtart_combo>-sign   = lst_constant-sign.
          <lst_mtart_combo>-option = lst_constant-opti.
          <lst_mtart_combo>-low    = lst_constant-low.
          <lst_mtart_combo>-high   = lst_constant-high.
*       Begin of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
        WHEN lc_sanctioned_c.
          APPEND INITIAL LINE TO r_sanc_countries ASSIGNING FIELD-SYMBOL(<lst_sanc_country>).
          <lst_sanc_country>-sign   = lst_constant-sign.
          <lst_sanc_country>-option = lst_constant-opti.
          <lst_sanc_country>-low    = lst_constant-low.
          <lst_sanc_country>-high   = lst_constant-high.
*       End   of ADD:ERP-6599:SRBOSE:03-Apr-2018:ED2K911805
*       Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
        WHEN lc_vkorg.
          APPEND INITIAL LINE TO r_vkorg_f044 ASSIGNING FIELD-SYMBOL(<lst_vkorg_f044>).
          <lst_vkorg_f044>-sign   = lst_constant-sign.
          <lst_vkorg_f044>-option = lst_constant-opti.
          <lst_vkorg_f044>-low    = lst_constant-low.
          <lst_vkorg_f044>-high   = lst_constant-high.

        WHEN lc_zlsch.
          APPEND INITIAL LINE TO r_zlsch_f044 ASSIGNING FIELD-SYMBOL(<lst_zlsch_f044>).
          <lst_zlsch_f044>-sign   = lst_constant-sign.
          <lst_zlsch_f044>-option = lst_constant-opti.
          <lst_zlsch_f044>-low    = lst_constant-low.
          <lst_zlsch_f044>-high   = lst_constant-high.
*       End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
*       Begin of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
        WHEN lc_kvgr1.
          APPEND INITIAL LINE TO r_kvgr1_f044 ASSIGNING FIELD-SYMBOL(<lst_kvgr1_f044>).
          <lst_kvgr1_f044>-sign   = lst_constant-sign.
          <lst_kvgr1_f044>-option = lst_constant-opti.
          <lst_kvgr1_f044>-low    = lst_constant-low.
          <lst_kvgr1_f044>-high   = lst_constant-high.
*       End of ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
* BOC: CR#7730 KKRAVURI20181012  ED2K913582
        WHEN lc_mat_grp5.
          APPEND INITIAL LINE TO r_mat_grp5 ASSIGNING FIELD-SYMBOL(<lst_mat_grp5>).
          <lst_mat_grp5>-sign   = lst_constant-sign.
          <lst_mat_grp5>-option = lst_constant-opti.
          <lst_mat_grp5>-low    = lst_constant-low.
          <lst_mat_grp5>-high   = lst_constant-high.

        WHEN lc_output_typ.
          APPEND INITIAL LINE TO r_output_typ ASSIGNING FIELD-SYMBOL(<lst_output_typ>).
          <lst_output_typ>-sign   = lst_constant-sign.
          <lst_output_typ>-option = lst_constant-opti.
          <lst_output_typ>-low    = lst_constant-low.
          <lst_output_typ>-high   = lst_constant-high.
* EOC: CR#7730 KKRAVURI20181012  ED2K913582
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        WHEN lc_tax_id.
          v_tax_id    = lst_constant-low.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
        WHEN lc_po_type.
          APPEND INITIAL LINE TO r_po_type  ASSIGNING FIELD-SYMBOL(<lst_po_type>).
          <lst_po_type>-sign   = lst_constant-sign.
          <lst_po_type>-option = lst_constant-opti.
          <lst_po_type>-low    = lst_constant-low.
          <lst_po_type>-high   = lst_constant-high.
*- nd of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
        WHEN  lc_comp_code.
          APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
          <lst_comp_code>-sign   = lst_constant-sign.
          <lst_comp_code>-option = lst_constant-opti.
          <lst_comp_code>-low    = lst_constant-low.
          <lst_comp_code>-high   = lst_constant-high.
        WHEN  lc_docu_currency.
          APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
          <lst_docu_currency>-sign   = lst_constant-sign.
          <lst_docu_currency>-option = lst_constant-opti.
          <lst_docu_currency>-low    = lst_constant-low.
          <lst_docu_currency>-high   = lst_constant-high.
        WHEN  lc_sales_office.
          APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
          <lst_sales_office>-sign   = lst_constant-sign.
          <lst_sales_office>-option = lst_constant-opti.
          <lst_sales_office>-low    = lst_constant-low.
          <lst_sales_office>-high   = lst_constant-high.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
        WHEN lc_print.
          APPEND INITIAL LINE TO r_print_product ASSIGNING FIELD-SYMBOL(<lst_print_product>).
          <lst_print_product>-sign   = lst_constant-sign.
          <lst_print_product>-option = lst_constant-opti.
          <lst_print_product>-low    = lst_constant-low.
          <lst_print_product>-high   = lst_constant-high.
        WHEN lc_digital.
          APPEND INITIAL LINE TO r_digital_product ASSIGNING FIELD-SYMBOL(<lst_digital_product>).
          <lst_digital_product>-sign   = lst_constant-sign.
          <lst_digital_product>-option = lst_constant-opti.
          <lst_digital_product>-low    = lst_constant-low.
          <lst_digital_product>-high   = lst_constant-high.
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
        WHEN OTHERS.
          " No need of OTHERS in this case
      ENDCASE.
      CLEAR lst_constant.
    ENDLOOP. " LOOP AT fp_i_constant INTO lst_constant
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBFA_DATA
*&---------------------------------------------------------------------*
*       Get VBFA records
*----------------------------------------------------------------------*
FORM f_get_vbfa_data .
*  Local structure declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,   " Type of SIGN component in row type of a Ranges type
           option TYPE ddoption, " Type of OPTION component in row type of a Ranges type
           low    TYPE char2,    " Low of type CHAR2
           high   TYPE char2,    " High of type CHAR2
         END OF lty_range.

******Local table type declaration of type range
  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number

*****Local data declaration
  DATA: lst_vbfa         TYPE ty_vbfa,                         " Local workarea for vbfa table
        li_vbkd          TYPE TABLE OF ty_vbkd,
        lir_vbeln        TYPE ltt_vbeln_r,                     " local range table of of vbeln
        lst_header       TYPE zstqtc_header_f043,              " Header structure for Consolidated Renewal Notification
        lst_vbeln        TYPE LINE OF ltt_vbeln_r,             " Local workarea of range table
        lst_renwl_plan   TYPE ty_renwl_plan,                   " Local workarea of type ty_renwl_plan
        lv_day           TYPE char2,                           " Date of type CHAR2
        lv_month_c2      TYPE char2,                           " Mnthc2 of type CHAR2
        lv_month_c3      TYPE char3,                           " Mnthc3 of type CHAR3
        lv_month         TYPE t247-ltx,                        " Month long text
        lv_year          TYPE char4,                           " Year of type CHAR4
        lv_land1         TYPE land1,                           " Country Key
        lv_soc_text      TYPE string,
        lv_datum_renewal TYPE char15,                          " renewal date of char 15
        lv_datum_angdt   TYPE angdt_v,                         " variable of date type angdt_v
        lv_datum_pay_due TYPE char15,                          " Pay due date of char15
        lv_activity      TYPE zactivity_sub,                   " activity
        lv_angdt         TYPE angdt_v,                         " Quotation/Inquiry is valid from
        lv_text_name     TYPE tdobname,                        " Name of text to be read
        li_renwl_plan    TYPE STANDARD TABLE OF ty_renwl_plan, " Local workarea of type ty_renwl_plan
        lst_range        TYPE lty_range,
        li_range         TYPE STANDARD TABLE OF lty_range,
        li_lines         TYPE STANDARD TABLE OF tline,         " Lines of text read
        lst_lines        TYPE tline.                           " Lines of text read


******Local constant declaration
  CONSTANTS: lc_g          TYPE vbtyp          VALUE 'G',    "Local constant for vbtyp field of vbak table when it is 'G'
             lc_i          TYPE tvarv_sign     VALUE 'I',    "ABAP: ID: I/E (include/exclude values)
             lc_eq         TYPE tvarv_opti     VALUE 'EQ',   "ABAP: Selection option (EQ/BT/CP/...)
             lc_hyphen     TYPE char01         VALUE '-',    "Constant for hyphen
             lc_id         TYPE thead-tdid     VALUE '0001', "Text ID of text to be read
             lc_object     TYPE thead-tdobject VALUE 'VBBP', "Object of text to be read
             lc_langu      TYPE thead-tdspras  VALUE 'E',    "Language of text to be read
             lc_sign       TYPE ddsign         VALUE 'I',    " Type of SIGN component in row type of a Ranges type
             lc_option     TYPE ddoption       VALUE 'CP',   " Type of OPTION component in row type of a Ranges type
             lc_r          TYPE char2          VALUE 'R*',   " R of type CHAR2
             lc_sign_ex    TYPE ddsign         VALUE 'E',    " Type of SIGN component in row type of a Ranges type
             lc_option_eq  TYPE ddoption       VALUE 'EQ',   " Type of OPTION component in row type of a Ranges type
             lc_actvity_rn TYPE char2          VALUE 'RN',   " Actvity_rn of type CHAR2
             lc_status     TYPE zact_status    VALUE 'X',    "Activity Status
* BOC by ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
             lc_00         TYPE num2           VALUE '00'.   "Level of the document flow record
* BOC by ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
* Begin of Change:INC0241931:NPALLA:21-May-2019:ED1K910154
  CONSTANTS: lc_ren_status TYPE zren_status    VALUE ' '.    "Renewal Status
* End of Change:INC0241931:NPALLA:21-May-2019:ED1K910154
*****Fetch Data from VBFA table:Sales Document Flow
  SELECT vbelv   "Preceding sales and distribution document
         posnv   "Preceding item of an SD document
         vbeln   "Subsequent sales and distribution document
         posnn   "Subsequent item of an SD document
         vbtyp_n "Document category of subsequent document
         vbtyp_v "Document category of preceding SD document
    FROM vbfa    "Sales Document Flow
    INTO TABLE i_vbfa
    WHERE vbeln = st_header-vbeln
    AND   posnv NE space
    AND   vbtyp_v = lc_g
* BOC by ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
    AND    stufe   = lc_00.
* EOC by ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
  IF sy-subrc IS INITIAL.
    READ TABLE i_vbfa INTO lst_vbfa INDEX 1.
    IF sy-subrc NE 0.
      CLEAR lst_vbfa.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF sy-subrc IS INITIAL

**** fetch Data from VBKD table
  SELECT vbeln "Sales and Distribution Document Number
         posnr "Item number of the SD document
         bstkd "Customer purchase order number
         ihrez " Your Reference
         kdkg2 "Customer Group
*        Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         zlsch "Payment Method
*        End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
         bsark "Customer purchase order type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    FROM vbkd "Sales Document: Business Data
    INTO TABLE i_vbkd
    WHERE vbeln = st_header-vbeln.
  IF sy-subrc = 0.
    SORT i_vbkd BY vbeln posnr.
  ENDIF. " IF sy-subrc = 0
  lv_angdt = sy-datum.

******FM to change the date format to DD_MMM_YYYY
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

    CONCATENATE lv_day
                lv_month_c3
                lv_year
                INTO lv_datum_renewal
                SEPARATED BY lc_hyphen.
  ENDIF. " IF sy-subrc = 0
*******Populate renewal date
  st_header-renewal_date = lv_datum_renewal.
  st_header-year_val = lv_year.

*** Populate local range table
  lst_range-sign   = lc_sign.
  lst_range-option = lc_option.
  lst_range-low    = lc_r.
  APPEND lst_range TO li_range.
* Need to exclude the RN activity as Reminder is not needed for this.
  CLEAR lst_range.
  lst_range-sign   = lc_sign_ex.
  lst_range-option = lc_option_eq.
  lst_range-low    = lc_actvity_rn.
  APPEND lst_range TO li_range.
*******Fetch Data from ZQTC_RENWL_PLAN table
  SELECT vbeln           " Sales Document
         posnr           " Sales Document Item
         activity        " E095: Activity
         eadat           " Activity Date
         renwl_prof      " Renewal Profile
         promo_code      " Promo code
         act_status      " Activity Status
         ren_status      " Renewal Status
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE li_renwl_plan
    WHERE vbeln = lst_vbfa-vbelv
    AND   posnr = lst_vbfa-posnv
    AND   activity IN li_range
    AND   eadat LE sy-datum
* Begin of Change:INC0241931:NPALLA:21-May-2019:ED1K910154
*    AND   act_status = lc_status.
    AND   act_status = lc_status
    AND   ren_status = lc_ren_status.
* End of Change:INC0241931:NPALLA:21-May-2019:ED1K910154
  IF sy-subrc IS INITIAL.
    SORT li_renwl_plan BY eadat DESCENDING.
  ENDIF. " IF sy-subrc IS INITIAL
********Populate reminder number
  READ TABLE li_renwl_plan INTO lst_renwl_plan INDEX 1.
  IF sy-subrc IS INITIAL.
    st_header-notif = lst_renwl_plan-activity+1(2).
  ENDIF. " IF sy-subrc IS INITIAL
*Begin of ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
* if Activity type is "RN", we should not print Reminder as text
*  IF st_header-notif IS INITIAL.
*    st_header-notif = 1.
*  ENDIF. " IF st_header-notif IS INITIAL
* End of ADD:OTCM-46664:SGUDA:17-AUG-2021:ED2K924330
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KONV_DATA
*&---------------------------------------------------------------------*
*       Get KONV details
*----------------------------------------------------------------------*
FORM f_get_konv_data .

******Local Data declaration
  DATA: lst_konv       TYPE ty_konv,                                  "Local workarea for konv structure
        lst_konv_tmp   TYPE ty_konv,                                  "Local workarea for konv structure
        lv_kwert       TYPE kwert,                                    " Condition value
        lv_kbetr       TYPE kbetr,                                    " Rate (condition amount or percentage)
        lv_kwert_tax   TYPE kwert,                                    " Condition value
        lv_kbetr_tax   TYPE kbetr,                                    " Rate (condition amount or percentage)
        lv_kwert_total TYPE kwert,                                    " Condition value
        lv_total_char  TYPE char20,                                   " Total_char of type CHAR20
        lv_tax_amt     TYPE char15,                                   " Tax_amt of type CHAR15
        li_konv        TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0, "Local interna table
        li_konv_tmp    TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0, "Local interna table
        li_konv_temp   TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0. "Local interna table


*******Local constant declaration
  CONSTANTS: lc_a          TYPE koaid VALUE 'A', " Condition class
             lc_d          TYPE koaid VALUE 'D', " Condition class
             lc_char_blank TYPE kinak VALUE '',  " Condition is inactive
             lc_percentage TYPE char1 VALUE '%'. " Percentage of type CHAR1

  IF st_vbak-knumv IS NOT INITIAL.
*******Fetch DATA from KONV table:Conditions (Transaction Data)
    SELECT knumv "Number of the document condition
           kposn "Condition item number
           stunr "Step number
           zaehk "Condition counter
           kappl " Application
           kawrt "Condition base value
           kbetr "Rate (condition amount or percentage)
           kwert "Condition value
           kinak "Condition is inactive
           koaid "Condition class
      FROM konv  "Conditions (Transaction Data)
      INTO TABLE i_konv
      WHERE knumv = st_vbak-knumv
        AND kinak = lc_char_blank.
    IF sy-subrc IS INITIAL.
      SORT i_konv BY knumv kposn.
      DELETE i_konv WHERE koaid NE 'D'.
      DELETE i_konv WHERE kawrt IS INITIAL.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF st_vbak-knumv IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SELLER_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_seller_tax.

*Local data declaration
  DATA: lv_doc_line  TYPE /idt/doc_line_number, " Document Line Number
        lv_buyer_reg TYPE char255.              " Buyer_reg of type CHAR255
* Local constant declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBAK',
*** BOC BY SAYANDAS
             lc_undscr   TYPE char1      VALUE '_',          " Undscr of type CHAR1
             lc_vat      TYPE char3      VALUE 'VAT',        " Vat of type CHAR3
             lc_tax      TYPE char3      VALUE 'TAX',        " Tax of type CHAR3
             lc_gst      TYPE char3      VALUE 'GST',        " Gst of type CHAR3
             lc_class    TYPE char5      VALUE 'ZQTC_',      " Class of type CHAR5
             lc_devid    TYPE char5      VALUE '_F037',      " Devid of type CHAR5
             lc_st       TYPE thead-tdid       VALUE 'ST',   " Text ID of text to be read
             lc_object   TYPE thead-tdobject   VALUE 'TEXT', " Texts: Application Object
             lc_colon    TYPE char1      VALUE ':',          " Colon of type CHAR1
             lc_comma    TYPE char1      VALUE ',',   "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
             lc_1001     TYPE bukrs_vf   VALUE '1001'. "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745

  DATA: li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
        lv_text   TYPE string,
        lv_tax    TYPE tdobname,                " Name
        lv_ind    TYPE xegld,                   " Indicator: European Union Member
        lvv_index TYPE sy-index.             " Index Value "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745

*** Fetch Data from /idt/d_tax_data Table
  IF st_vbak IS NOT INITIAL.
    SELECT  document,
            doc_line_number,
            buyer_reg,
            seller_reg      " Seller VAT Registration Number
       FROM /idt/d_tax_data " Tax Data
      INTO TABLE @i_tax_data
      WHERE company_code = @st_vbak-bukrs_vf
      AND fiscal_year = @lc_gjahr
      AND document_type = @lc_doc_type
      AND document = @st_vbak-vbeln.

  ENDIF. " IF st_vbak IS NOT INITIAL
  IF sy-subrc IS INITIAL.
    CLEAR st_header-seller_reg. "ERPM-8994:SGUDA:28-01-2020: ED2K917399
    DATA(i_tax_data_buyer) = i_tax_data[]. "ERPM-8994:SGUDA:28-01-2020: ED2K917399
    SORT i_tax_data BY seller_reg.
    DELETE i_tax_data WHERE seller_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM i_tax_data COMPARING seller_reg.
    LOOP AT i_tax_data INTO DATA(lst_tax_data).
      IF lst_tax_data-seller_reg IS NOT INITIAL.
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
        lvv_index = sy-tabix.
        IF lvv_index = 1.
          st_header-seller_reg = lst_tax_data-seller_reg.
        ELSE.
          CONCATENATE lst_tax_data-seller_reg lc_comma st_header-seller_reg  INTO st_header-seller_reg.
        ENDIF.
*        CONCATENATE lst_tax_data-seller_reg st_header-seller_reg INTO st_header-seller_reg SEPARATED BY space.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
      ENDIF. " IF lst_tax_data-seller_reg IS NOT INITIAL
    ENDLOOP. " LOOP AT i_tax_data INTO DATA(lst_tax_data)
*- Begin of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
    IF st_header-seller_reg IS INITIAL AND st_vbak-bukrs_vf = lc_1001.
      st_header-seller_reg = v_tax_id.
    ENDIF.
*- End of ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913745
*- Begin of ERPM-8994:SGUDA:28-01-2020: ED2K917399
    CLEAR st_header-buyer_reg.
    SORT i_tax_data_buyer BY buyer_reg.
    DELETE i_tax_data_buyer WHERE buyer_reg IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM i_tax_data_buyer COMPARING buyer_reg.
    CLEAR lvv_index.
    LOOP AT i_tax_data_buyer INTO DATA(lst_tax_data1).
      IF lst_tax_data1-buyer_reg IS NOT INITIAL.
        lvv_index = sy-tabix.
        IF lvv_index = 1.
          st_header-buyer_reg = lst_tax_data1-buyer_reg.
        ELSE.
          CONCATENATE lst_tax_data1-buyer_reg lc_comma st_header-buyer_reg  INTO st_header-buyer_reg.
        ENDIF.
      ENDIF. " IF lst_tax_data-seller_reg IS NOT INITIAL
    ENDLOOP. " LOOP AT i_tax_data INTO DATA(lst_tax_data)
*- End of ERPM-8994:SGUDA:28-01-2020: ED2K917399
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STXH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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
  CONSTANTS: lc_r      TYPE char10         VALUE 'ZQTC*F037*', " R of type CHAR10
             lc_sign   TYPE ddsign         VALUE 'I',          " Type of SIGN component in row type of a Ranges type
             lc_option TYPE ddoption       VALUE 'CP'.         " Type of OPTION component in row type of a Ranges type

***Populate local range table
  CLEAR: lst_range.
  lst_range-sign = lc_sign.
  lst_range-option = lc_option.
  lst_range-low = lc_r.
  APPEND lst_range TO lir_range.

*** Fetch data from STXH table
  SELECT tdname  " Name
         tdspras " Language Key
    FROM stxh    " STXD SAPscript text file header
    INTO TABLE fp_i_std_text
    WHERE tdobject = c_object
    AND tdname IN lir_range
    AND tdid = c_st.
  IF sy-subrc IS INITIAL.
    SORT fp_i_std_text BY tdname tdspras.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM read_text  USING    fp_name    TYPE tdobname      " Name
                         st_header-language TYPE spras " Language Key
                CHANGING fp_lines   TYPE tttext
                         fp_text    TYPE string.
  DATA:  li_lines     TYPE STANDARD TABLE OF tline. "Lines of text read


  CLEAR: fp_text,
         li_lines.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_st
      language                = st_header-language
      name                    = fp_name
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
    fp_lines[] = li_lines[].
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = fp_text.
    IF sy-subrc EQ 0.
      CONDENSE fp_text.
    ENDIF. " IF sy-subrc EQ 0
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ISSUE_SEQ
*&---------------------------------------------------------------------*
*       Get issue sequence in form
*----------------------------------------------------------------------*
FORM f_fetch_issue_seq  USING    fp_i_vbap      TYPE tt_vbap
                        CHANGING fp_li_issue_sq TYPE tt_issue_sq.
  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number

  DATA:
    lst_vbap          TYPE ty_vbap,
    lt_vbap           TYPE TABLE OF ty_vbap,
    lir_vbeln         TYPE ltt_vbeln_r,         " local range table of of vbeln
    lst_vbeln         TYPE LINE OF ltt_vbeln_r, " Local workarea of range table
    lst_mara_vol      TYPE ty_mara_vol,
    lst_vbap_bom      TYPE ty_vbap,
    lv_matnr          TYPE matnr,               " Material Number
    lv_day            TYPE char2,               " Date of type CHAR2
    lv_month_c2       TYPE char2,               " Mnthc2 of type CHAR2
    lv_month_c3       TYPE char3,               " Mnthc3 of type CHAR3
    lv_year           TYPE char4,               " Year of type CHAR4
    lv_month          TYPE fcltx,               " Monthth
    lv_vbegdat        TYPE vbdat_veda,          " Contract start date
    lv_venddat        TYPE vbdat_veda,          " Contract start date
    lv_venddat_subs   TYPE vbdat_veda,          " Contract start date
    lst_veda_subs     TYPE ty_veda_qt,
    lst_veda_quote    TYPE ty_veda_qt,
    lst_veda_qtemp    TYPE ty_veda_qt,
    lst_iss_vol2      TYPE ty_iss_vol2,
    lst_veda          LIKE LINE OF i_veda,
    lst_cntrct_dat_qt TYPE ty_cntrct_dat_qt,
    lir_cntrct_dat_qt TYPE RANGE OF vbdat_veda, " Contract start date
    lv_issues         TYPE i,                   " No. of Issues.
    lv_vol_count      TYPE syst_tabix,          " ABAP System Field: Row Index of Internal Tables
    lv_volume_st      TYPE ismheftnummer,       " Volume Start
    lv_volume         TYPE string.              "Volume

  CONSTANTS: lc_hier2  TYPE ismhierarchlvl VALUE '2', " Hierarchy Level (Media Product Family, Product or Issue)
             lc_hier3  TYPE ismhierarchlvl VALUE '3', " Hierarchy Level (Media Product Family, Product or Issue)
             lc_hyphen TYPE char01        VALUE '-',  " Constant for hyphen
             lc_posnr  TYPE posnr VALUE '000000'.     " Item number of the SD document

  IF fp_i_vbap IS INITIAL.
    RETURN.
  ENDIF. " IF fp_i_vbap IS INITIAL

  DATA(li_vbap) = fp_i_vbap.
  READ TABLE li_vbap INTO lst_vbap INDEX 1.

  READ TABLE li_vbap INTO lst_vbap_bom WITH KEY uepos = lst_vbap-posnr.
  IF sy-subrc EQ 0.
    lv_matnr = lst_vbap_bom-matnr.
  ELSE. " ELSE -> IF sy-subrc EQ 0
    lv_matnr = lst_vbap-matnr.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE i_vbfa INTO DATA(lst_vbfa) WITH KEY vbeln  = lst_vbap-vbeln
                                                 posnn  = lst_vbap-posnr.
  IF sy-subrc EQ 0.
***Contract start date & end date
    READ TABLE i_veda  INTO lst_veda_subs WITH KEY vbeln = lst_vbfa-vbelv
                                                   vposn = lst_vbfa-posnv.
    IF sy-subrc EQ 0.
      lv_vbegdat = lst_veda_subs-vbegdat.
      lv_venddat = lst_veda_subs-venddat.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE i_veda  INTO lst_veda_subs WITH KEY  vbeln = lst_vbfa-vbelv
                                                      vposn = lc_posnr.
      lv_vbegdat = lst_veda_subs-vbegdat.
      lv_venddat = lst_veda_subs-venddat.
    ENDIF. " IF sy-subrc EQ 0
    IF lv_venddat IS NOT INITIAL.
      CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
        EXPORTING
          idate                         = lv_venddat
        IMPORTING
          day                           = lv_day
          month                         = lv_month_c2
          year                          = lv_year
          ltext                         = lv_month
        EXCEPTIONS
          input_date_is_initial         = 1
          text_for_month_not_maintained = 2
          OTHERS                        = 3.
      IF sy-subrc EQ 0.
        lv_month_c3 = lv_month(3).
        CONCATENATE lv_day
                    lv_month_c3
                    lv_year
                    INTO v_mbexp_date
                    SEPARATED BY lc_hyphen.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_venddat IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

  CLEAR: lv_vbegdat,
         lv_venddat.
  IF lst_vbap_bom IS NOT INITIAL.
    READ TABLE i_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                    vposn = lst_vbap_bom-posnr.
    IF sy-subrc EQ 0.
      lv_vbegdat = lst_veda_quote-vbegdat.
      lv_venddat = lst_veda_quote-venddat.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE i_veda  INTO lst_veda_quote WITH KEY  vbeln = lst_vbap-vbeln
                                                        vposn = lc_posnr.
      lv_vbegdat = lst_veda_quote-vbegdat.
      lv_venddat = lst_veda_quote-venddat.
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF lst_vbap_bom IS NOT INITIAL
    READ TABLE i_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                     vposn = lst_vbap-posnr.
    IF sy-subrc EQ 0.
      lv_vbegdat = lst_veda_quote-vbegdat.
      lv_venddat = lst_veda_quote-venddat.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE i_veda  INTO lst_veda_quote WITH KEY vbeln = lst_vbap-vbeln
                                                       vposn = lc_posnr.
      lv_vbegdat = lst_veda_quote-vbegdat.
      lv_venddat = lst_veda_quote-venddat.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lst_vbap_bom IS NOT INITIAL
  IF lv_vbegdat IS NOT INITIAL OR lv_venddat IS NOT INITIAL.
    lst_cntrct_dat_qt-sign  = c_sign_i.
    lst_cntrct_dat_qt-option = c_option_bt.
    lst_cntrct_dat_qt-low    = lv_vbegdat.
    lst_cntrct_dat_qt-high   = lv_venddat.
    APPEND lst_cntrct_dat_qt TO lir_cntrct_dat_qt.
  ENDIF. " IF lv_vbegdat IS NOT INITIAL OR lv_venddat IS NOT INITIAL

  READ TABLE i_jksenip TRANSPORTING NO FIELDS
  WITH KEY product = lst_vbap-matnr
  BINARY SEARCH.
  IF sy-subrc = 0.
    LOOP AT i_jksenip ASSIGNING FIELD-SYMBOL(<lst_jksenip>) FROM sy-tabix.
      IF <lst_jksenip>-product NE lst_vbap-matnr.
        EXIT.
      ENDIF. " IF <lst_jksenip>-product NE lst_vbap-matnr
      IF <lst_jksenip>-sub_valid_from IN lir_cntrct_dat_qt
       OR <lst_jksenip>-sub_valid_until IN lir_cntrct_dat_qt.
        IF lst_iss_vol2-stvol IS INITIAL OR
            lst_iss_vol2-stiss IS INITIAL.
          READ TABLE i_mara_vol ASSIGNING FIELD-SYMBOL(<lst_mara_vol>)
          WITH KEY matnr = <lst_jksenip>-issue
          BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_iss_vol2-stvol IS INITIAL.
***               Start Volume
              lst_iss_vol2-stvol = <lst_mara_vol>-ismcopynr.
            ENDIF. " IF lst_iss_vol2-stvol IS INITIAL
            IF lst_iss_vol2-stiss IS INITIAL.
***               Start Issue
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = <lst_mara_vol>-ismnrinyear
                IMPORTING
                  output = lst_iss_vol2-stiss.
            ENDIF. " IF lst_iss_vol2-stiss IS INITIAL
            lst_iss_vol2-noi = lst_iss_vol2-noi + 1.
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF lst_iss_vol2-stvol IS INITIAL OR
      ENDIF. " IF <lst_jksenip>-sub_valid_from IN lir_cntrct_dat_qt
    ENDLOOP. " LOOP AT i_jksenip ASSIGNING FIELD-SYMBOL(<lst_jksenip>) FROM sy-tabix
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_MATDESC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBAP_TEMP_MATNR  text
*      <--P_LST_FINAL_PROD_DES  text
*----------------------------------------------------------------------*
FORM read_text_matdesc  USING    fp_matnr
                                 st_header-language  TYPE spras " Language Key
                        CHANGING fp_prod_des.

  DATA: lv_text      TYPE string,
        li_lines     TYPE STANDARD TABLE OF tline, " SAPscript: Text Lines
        lv_text_name TYPE tdobname.                " Name

  lv_text_name  = fp_matnr.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_txtid_grun
      language                = st_header-language
      name                    = lv_text_name
      object                  = c_txtobj_material
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
    DELETE li_lines WHERE tdline IS INITIAL.
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_lines
      IMPORTING
        ev_text_string = lv_text.
    IF sy-subrc EQ 0.
      CONDENSE lv_text.
      fp_prod_des = lv_text.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_MODULE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_MED_TYPE_DIGI_TM  text
*      <--P_LV_TXT_MED_TYPE  text
*----------------------------------------------------------------------*
FORM read_text_module  USING    fp_txtmod_name  TYPE tdsfname     " Smart Forms: Form Name
                                st_header-language     TYPE spras " Language Key
                       CHANGING fp_txtmodule_data_c   TYPE string.

  DATA:
    lst_language_tm TYPE ssfrlang,                " Smart Forms: Languages at Runtime
    lst_lines       TYPE tline,                   " SAPscript: Text Lines
    li_lines        TYPE STANDARD TABLE OF tline. " SAPscript: Text Lines.

  lst_language_tm-langu1  = st_header-language.

  CALL FUNCTION 'SSFRT_READ_TEXTMODULE'
    EXPORTING
      i_textmodule       = fp_txtmod_name
      i_languages        = lst_language_tm
    IMPORTING
*     O_LANGU            =
      o_text             = li_lines
    EXCEPTIONS
      error              = 1
      language_not_found = 2
      OTHERS             = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE. " ELSE -> IF sy-subrc <> 0
    READ TABLE li_lines INTO lst_lines INDEX 1.
    IF sy-subrc EQ 0.
      fp_txtmodule_data_c = lst_lines-tdline.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VEDA_DATA
*&---------------------------------------------------------------------*
*       Fetch data from VEDA table
*----------------------------------------------------------------------*
FORM f_get_veda_data .

  TYPES: ltt_vbeln_r TYPE RANGE OF vbeln. " Sales and Distribution Document Number

  DATA:lir_vbeln TYPE ltt_vbeln_r,         " local range table of of vbeln
       lst_vbeln TYPE LINE OF ltt_vbeln_r. " Local workarea of range table

  LOOP AT i_vbfa INTO DATA(lst_vbfa).
    lst_vbeln-sign   =  c_sign_i.
    lst_vbeln-option =  c_option_eq.
* To pass quotation number
    lst_vbeln-low = lst_vbfa-vbeln.

    APPEND lst_vbeln TO lir_vbeln.

    CLEAR lst_vbeln.

    lst_vbeln-sign   =  c_sign_i.
    lst_vbeln-option =  c_option_eq.
* To pass subscription order number
    lst_vbeln-low = lst_vbfa-vbelv.

    APPEND lst_vbeln TO lir_vbeln.
    CLEAR   lst_vbeln.
  ENDLOOP. " LOOP AT i_vbfa INTO DATA(lst_vbfa)

  SELECT vbeln     " Sales Document
         vposn     " Sales Document Item
         vlaufk    " Validity period category of contract
         vbegdat   " Contract start date
         venddat   " Contract end date
         INTO TABLE i_veda
         FROM veda " Contract Data
         WHERE vbeln IN lir_vbeln.
  IF sy-subrc = 0.
    SORT i_veda BY vbeln vposn.

    SELECT spras  " Language Key
           vlaufk " Validity period category of contract
           bezei  " Description
      FROM tvlzt  " Validity Period Category: Texts
      INTO TABLE i_tvlzt
      FOR ALL ENTRIES IN i_veda
      WHERE vlaufk = i_veda-vlaufk.
    IF sy-subrc = 0.
      SORT i_tvlzt BY vlaufk.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0

*** Fetch Data from jksenip table
  IF i_mara IS NOT INITIAL.
    SELECT product         " Media Product
           issue           " Media Issue
           shipping_date   " IS-M: Delivery Date
           sub_valid_from  " IS-M: Subscription Valid From
           sub_valid_until " IS-M: Subscription Valid To
           status          " IS-M: Status of Shipping Planning
           INTO TABLE i_jksenip
             FROM jksenip  " IS-M: Shipping Schedule
             FOR ALL ENTRIES IN i_mara
             WHERE product = i_mara-matnr.

    IF sy-subrc = 0 AND i_jksenip[] IS NOT INITIAL.
      DELETE i_jksenip WHERE status EQ c_stats_04 OR
                                status EQ c_stats_10.
      SORT i_jksenip BY product issue.
    ENDIF. " IF sy-subrc = 0 AND i_jksenip[] IS NOT INITIAL
  ENDIF. " IF i_mara IS NOT INITIAL

  IF i_jksenip IS NOT INITIAL.
    SELECT matnr       " Material Number
           ismnrinyear " Issue Number (in Year Number)matnr
           ismcopynr   " Volume
           INTO TABLE i_mara_vol
           FROM mara   " General Material Data
           FOR ALL ENTRIES IN i_jksenip
          WHERE matnr = i_jksenip-issue.
    IF sy-subrc EQ 0.
      SORT i_mara_vol BY matnr ismnrinyear ismcopynr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_jksenip IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_FM_OUTPUT_SUPP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_call_fm_output_supp CHANGING fp_li_output TYPE ztqtc_output_supp_retrieval.
  TYPES : BEGIN OF lty_constant,
            sign TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
            opti TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE  salv_de_selopt_low, "Lower Value of Selection Condition
            high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          END OF lty_constant.

  DATA : li_constant         TYPE STANDARD TABLE OF lty_constant,
*        Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         lv_ihrez_f044       TYPE ihrez,        " Your Reference
         lv_scenario_f044    TYPE char3,        " Scenario_f044 of type CHAR3
         lst_formoutput_f044 TYPE fpformoutput, " Form Output (PDF, PDL)
*        End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         lst_output          TYPE zstqtc_output_supp_retrieval. " Output structure for E098-Output Supplement Retrieval

  CONSTANTS: lc_devid TYPE zdevid         VALUE 'E098',  " Development ID
             lc_kschl TYPE rvari_vnam     VALUE 'KSCHL'. " ABAP: Name of Variant Variable

*** Fetch data from ZCACONSTANT
  SELECT sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_constant
    WHERE devid EQ lc_devid
    AND param1 EQ lc_kschl.
  IF sy-subrc IS INITIAL.
    SORT li_constant BY low.
  ENDIF. " IF sy-subrc IS INITIAL

  IF nast-kschl IN li_constant.
*Call FM to get the list of PDF attachments for the particular material
*and attachment name ending with KDKG1
    CALL FUNCTION 'ZQTC_OUTPUT_SUPP_RETRIEVAL'
      EXPORTING
        im_input  = i_input
        im_auart  = st_vbak-auart
      IMPORTING
        ex_output = fp_li_output.
  ENDIF. " IF nast-kschl IN li_constant
*** EOC BY SAYANDAS
  CLEAR lst_output.
  lst_output-attachment_name = 'Consolidated Notice'(005).
  lst_output-pdf_stream = st_formoutput-pdf.
  INSERT lst_output INTO fp_li_output INDEX 1.

* Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
  READ TABLE i_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>) INDEX 1.
  IF sy-subrc EQ 0.
    DATA(lv_zlsch_f044) = <lst_vbkd>-zlsch.
  ENDIF.

  IF st_vbak-vkorg IN r_vkorg_f044 AND
     lv_zlsch_f044 NOT IN r_zlsch_f044
  AND st_vbak-kvgr1 NOT IN r_kvgr1_f044.  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
    lv_ihrez_f044    = st_vbak-vbeln.
    lv_scenario_f044 = 'TBT'.

    CLEAR: lst_formoutput_f044.
    CALL FUNCTION 'ZQTC_DIR_DEBIT_MANDT_F044'
      EXPORTING
        im_vkorg      = st_vbak-vkorg
        im_waerk      = st_vbak-waerk
        im_scenario   = lv_scenario_f044
        im_ihrez      = lv_ihrez_f044
        im_adrnr      = st_address-adrnr_bp
        im_kunnr      = st_address-kunnr_bp
        im_langu      = st_header-language
        im_xstring    = v_xstring
      IMPORTING
        ex_formoutput = lst_formoutput_f044.
    IF lst_formoutput_f044-pdf IS NOT INITIAL.
      CLEAR lst_output.
      lst_output-attachment_name = 'Direct Debit Mandate'(002).
      lst_output-pdf_stream = lst_formoutput_f044-pdf.
      IF fp_li_output IS INITIAL.
        INSERT lst_output INTO fp_li_output INDEX 1.
      ELSE. " ELSE -> IF fp_li_output IS INITIAL
        INSERT lst_output INTO fp_li_output INDEX 2.
      ENDIF. " IF fp_li_output IS INITIAL
    ENDIF. " IF lst_formoutput_f044-pdf IS NOT INITIAL
  ENDIF. " IF st_vbak-vkorg IN r_vkorg_f044 AND
* End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LANGUAGE
*&---------------------------------------------------------------------*
*       To get bill to party language
*----------------------------------------------------------------------*
FORM f_get_language CHANGING fp_st_header TYPE zstqtc_header_f043. " Header structure for Consolidated Renewal Notification
*  Local type declaration
  TYPES: BEGIN OF lty_kna1,
           kunnr TYPE kunnr,     "Customer Number
           land1 TYPE  land1_gp, "Country Key
           spras TYPE spras,     "Language Key
         END OF lty_kna1.

* Local data declaration
  DATA : lst_kna1 TYPE lty_kna1.
  IF st_vbak IS NOT INITIAL.
    SELECT SINGLE
      kunnr     "Customer Number
      land1     "Country Key
      spras     "Language Key
      FROM kna1 " General Data in Customer Master
      INTO lst_kna1
      WHERE kunnr = st_vbak-kunnr.
    IF sy-subrc IS INITIAL.
      fp_st_header-language = lst_kna1-spras.
      fp_st_header-land1 = lst_kna1-land1.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF st_vbak IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAK_DATA
*&---------------------------------------------------------------------*
*       Get header data
*----------------------------------------------------------------------*
FORM f_get_vbak_data  CHANGING fp_st_vbak TYPE ty_vbak.
*******Fetch data from VBAK table:Sales Document: Header Data
  st_header-vbeln = nast-objky+0(10).
  SELECT SINGLE
         vbeln    "Sales Document
         angdt    "Quotation/Inquiry is valid from
         vbtyp    "SD document category
         auart    "SD Document type
         waerk    "SD Document Currency
*        Begin of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         vkorg "Sales Org
*        End   of ADD:ERP-7747:WROY:19-SEP-2018:ED2K913401
         knumv    "Number of the document condition
         kunnr    " Sold-to party
         kvgr1    " Customer Group1  " ADD:ERPM-24393:SGUDA:09-SEP-2020:ED2K919425
         vkbur    "OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913787
         bukrs_vf "Company code to be billed
    FROM vbak "Sales Document: Header Data
    INTO fp_st_vbak
    WHERE vbeln EQ st_header-vbeln.
  IF sy-subrc IS INITIAL.
    "Begin of ADD:RITM0075536:rkumar2:09-OCT-2018: ED1K908667
    SELECT SINGLE land1 " Country Key
             INTO @DATA(lv_land1)
             FROM t001  " Company Codes
            WHERE bukrs = @fp_st_vbak-bukrs_vf.
    IF sy-subrc EQ 0.
      st_header-land1_bukrs  = lv_land1.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_BARCODE
*&---------------------------------------------------------------------*
*       Populate Barcode
*----------------------------------------------------------------------*
FORM f_populate_barcode .
  DATA: lv_amount   TYPE char11, " Amount of type CHAR11
*        lv_order    TYPE char10, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
        lv_order    TYPE char16, " Invoice of type CHAR10 "ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
        lv_inv_chk  TYPE char1,  " Inv_chk of type CHAR1
        lv_amnt_chk TYPE char1,  " Amnt_chk of type CHAR1
*        lv_bar      TYPE char30, " Bar of type CHAR30 ""ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
        lv_bar      TYPE char100, " Bar of type CHAR100 ""ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
        lv_bar_chk  TYPE char1.  " Bar_chk of type CHAR1

* Order Number
  MOVE st_header-vbeln TO lv_order.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_order
    IMPORTING
      output = lv_order.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_order
*    IMPORTING
*      check_digit = lv_inv_chk.
  CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
    EXPORTING
      number_part = lv_order
    IMPORTING
      check_digit = lv_inv_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
  IF v_total GT 0.
    WRITE v_total TO lv_amount CURRENCY v_waerk.
    REPLACE ALL OCCURRENCES OF '.' IN lv_amount WITH space.
    REPLACE ALL OCCURRENCES OF ',' IN lv_amount WITH space.
    CONDENSE lv_amount.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_amount
      IMPORTING
        output = lv_amount.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_amount
*      IMPORTING
*        check_digit = lv_amnt_chk.
    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_amount
      IMPORTING
        check_digit = lv_amnt_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
    CONCATENATE lv_order
              lv_inv_chk
              lv_amount
              lv_amnt_chk
              INTO lv_bar.
*   Begin of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
*    CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*      EXPORTING
*        number_part = lv_bar
*      IMPORTING
*        check_digit = lv_bar_chk.
    CALL FUNCTION 'ZCALCULATE_CHECK_DIGIT_MOD11'
      EXPORTING
        number_part = lv_bar
      IMPORTING
        check_digit = lv_bar_chk.
*   End of ADD:ERP-7189 and 7431:SGUDA:05-NOV-2018:ED2K913775
    CONCATENATE lv_order
                lv_inv_chk
                lv_amount
                lv_amnt_chk
                lv_bar_chk
                INTO st_header-barcode
                SEPARATED BY space.
  ENDIF. " IF v_total GT 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ITEM
*&---------------------------------------------------------------------*
*       Subroutine to populate the line items
*----------------------------------------------------------------------*
FORM f_populate_item .

  TYPES: BEGIN OF lty_vbap,
           hl_itm TYPE  posnr_va, " Sales Document Item
           vbeln  TYPE  vbeln_va, "Sales Document
           posnr  TYPE  posnr_va, "Sales Document Item
           matnr  TYPE  matnr,    "Material Number
           arktx  TYPE  arktx,    "Short text for sales order item
           uepos  TYPE  uepos,    "  Higher-level item in bill of material structures
           kwmeng TYPE  kwmeng,   "Cumulative Order Quantity in Sales Units
           kzwi1  TYPE  kzwi1,    "Subtotal 1 from pricing procedure for condition
           kzwi2  TYPE  kzwi2,    "Subtotal 2 from pricing procedure for condition
           kzwi3  TYPE  kzwi3,    " Subtotal 3 from pricing procedure for condition
           kzwi4  TYPE  kzwi4,    "Subtotal 4 from pricing procedure for condition
           kzwi5  TYPE  kzwi5,    "Subtotal 5 from pricing procedure for condition
           kzwi6  TYPE  kzwi6,    "Subtotal 6 from pricing procedure for condition
         END OF lty_vbap.
********Local data declaration
  DATA: lv_kzwi5           TYPE kzwi5,            " Subtotal 5 from pricing procedure for condition
        lv_discount        TYPE kzwi5,            " Subtotal 5 from pricing procedure for condition
        lv_discount_tmp    TYPE char2,            " Discount_tmp of type CHAR2
        lv_kzwi1           TYPE kzwi1,            " Subtotal 1 from pricing procedure for condition
        lv_kwmeng          TYPE char18,           " Kwmeng of type CHAR18
        lv_tax_amt         TYPE char15,           " Tax_amt of type CHAR15
        lv_waerk1          TYPE waerk,            " SD Document Currency
        lv_kwmeng_qty      TYPE char15,           " Kwmeng_qty of type CHAR15
        lv_kwmeng_dec      TYPE char3,            " Kwmeng_dec of type CHAR3
        lv_unit_price      TYPE p DECIMALS 2,     " Unit_price of type Packed Number
        lst_vbak           TYPE ty_vbak,
        lv_disc_char       TYPE char20,           " Disc_char of type CHAR20
        lv_disc            TYPE kzwi5,            " Subtotal 5 from pricing procedure for condition
        lst_final          TYPE zstqtc_item_f037, " Structure for item data
        lv_tabix           TYPE syst_tabix,       " ABAP System Field: Row Index of Internal Tables
        lv_dis_amt         TYPE char15,           " Dis_amt of type CHAR15
* WR
        lst_cntrct_dat_qt  TYPE ty_cntrct_dat_qt,
        lir_cntrct_dat_qt  TYPE RANGE OF vbdat_veda, " Contract start date
        lst_iss_vol2       TYPE ty_iss_vol2,
* WR
*** BOC BY SAYANDAS on 22-Feb-2018 for Volume Issue Fix
        lv_year_1          TYPE char30,                  " Year
        lv_year            TYPE char4,                   " Year of type CHAR4
        lv_year_1_str      TYPE string,
        lv_year_1_end      TYPE string,                  "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_cntr_month      TYPE t247-ktx,                  " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_month_l         TYPE t247-ltx,
        lv_cntr            TYPE char30,                  " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_day(2)          TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_month(2)        TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_year2(4)        TYPE c,            " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_stext           TYPE t247-ktx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_ltext           TYPE t247-ltx,     " Year_2 of type CHAR30 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
        lv_year_2          TYPE char30,                  " Year_2 of type CHAR30
        lv_issue_desc      TYPE tdline,                  " Text Line
        lv_volume_str      TYPE string,
        lv_volume          TYPE string,                  " Volume of type CHAR30
        lv_vol             TYPE char8,                   " Vol of type CHAR8
        lv_issue_str       TYPE string,
        lv_issue           TYPE string,                  " Issue of type CHAR30
        li_tkomv           TYPE STANDARD TABLE OF komv,  " Pricing Communications-Condition Record
        li_tkomvd          TYPE STANDARD TABLE OF komvd, " Price Determination Communication-Cond.Record for Printing
        lst_komk           TYPE komk,                    " Communication Header for Pricing
        lv_kbetr_desc      TYPE p DECIMALS 3,            " Rate (condition amount or percentage)
        lv_kbetr_char      TYPE char15,                  " Kbetr_char of type CHAR15
        li_lines           TYPE STANDARD TABLE OF tline, "Lines of text read
        lv_text            TYPE string,
        lst_line           TYPE tline,                   " SAPscript: Text Lines
        lst_lines          TYPE tline,                   " SAPscript: Text Lines
        li_vbap            TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
        lv_tax             TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lst_konv           TYPE ty_konv,
        lst_mara           TYPE ty_mara,
        lst_vbap           TYPE ty_vbap,
        lv_tax_text        TYPE string,
        lv_comp_tax        TYPE string,
        lst_tax_dtls       TYPE ty_tax_dtls,
        lst_vbap_tmp       TYPE ty_vbap,
        li_vbap_hcomp      TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
        lv_konv_index      TYPE syst_tabix,              " ABAP System Field: Row Index of Internal Tables
        lv_itmcomp_indx    TYPE syst_tabix,              " ABAP System Field: Row Index of Internal Tables
        lst_vbap_itmcmp    TYPE ty_vbap,
        lst_bom_comp_tax   TYPE zstqtc_item_f037,        " Structure for item data
        lv_txtmodule_data  TYPE string,
        lv_txt_med_type    TYPE string,
        lv_vol_issues_txt  TYPE string,
        lv_pnt_issn        TYPE string,
        lv_name_issn       TYPE tdobname,                " Name
        lv_name            TYPE tdobname,                " Name
        li_final           TYPE zttqtc_item,
        lst_komp           TYPE komp,                    " Communication Item for Pricing
        lv_desc_prev       TYPE arktx,                   " Short text for sales order item
        lv_tax_prev        TYPE kzwi6,                   " Subtotal 6 from pricing procedure for condition
        lv_taxable_amt     TYPE kzwi1,                   " Subtotal 1 from pricing procedure for condition
        lv_tax_amount      TYPE p DECIMALS 3,            " Subtotal 6 from pricing procedure for condition
        lv_kbetr           TYPE kbetr,                   " Rate (condition amount or percentage)
        lst_tax_item       TYPE ty_tax_dtls,
        li_tax_item        TYPE STANDARD TABLE OF ty_tax_dtls,
        lst_tax_tab        TYPE zstqtc_tax_f037,         " Amount and Tax Details display in F032
        lv_taxable_char    TYPE char100,                 " Taxable_char of type CHAR100
        lv_tax_amount_char TYPE char100,                 " Tax_amount_char of type CHAR100
        lv_multi_bom_flg   TYPE xfeld,                   " Checkbox
        lv_combo_bom_flg   TYPE xfeld,                   " Checkbox
        lv_normal_flg      TYPE xfeld,                   " Checkbox
        lv_subs_term       TYPE string,                  "Added by MODUTTA on 04-Jun-2018 for CR# 6301 TR# ED2K912500
        lv_med_type        TYPE string,                  " Mlsub of type CHAR30
        lv_identcode_zjcd  TYPE char4,                   " Identcode_zjcd of type CHAR4
        lv_tabix_hcomp     TYPE i,                       " Tabix_hcomp of type Integers
        lv_ponum           TYPE string,
        lv_subref          TYPE string,
        lv_zero_amt        TYPE netwr    VALUE '0.00',   " Net Value in Document Currency
        li_vbap_final      TYPE STANDARD TABLE OF lty_vbap INITIAL SIZE 0,
        lst_vbap_final     TYPE lty_vbap,
        lst_input          TYPE zstqtc_supplement_ret_input. " Input Paramter for E098 Supplement retrieval

  CONSTANTS:
    lc_year       TYPE thead-tdname VALUE 'ZQTC_YEAR_F035',          " Name
    lc_volume     TYPE thead-tdname VALUE 'ZQTC_VOLUME_F035',        " Name
    lc_issue      TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',         " Name
    lc_stiss      TYPE thead-tdname VALUE 'ZQTC_START_ISSUE_F037',   " Name
    lc_comma      TYPE char1        VALUE ',',                       " Comma of type CHAR1
    lc_hash       TYPE char1        VALUE '#',                       " Hash of type CHAR1
    lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',    " Name
    lc_digissn    TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
    lc_combissn   TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042', " Name
    lc_b          TYPE char1      VALUE '(',                         " B of type CHAR1
    lc_bb         TYPE char1      VALUE ')',                         " Bb of type CHAR1
    lc_undscr     TYPE char1      VALUE '_',                         " Undscr of type CHAR1
    lc_vat        TYPE char3      VALUE 'VAT',                       " Vat of type CHAR3
    lc_tax        TYPE char3      VALUE 'TAX',                       " Tax of type CHAR3
    lc_gst        TYPE char3      VALUE 'GST',                       " Gst of type CHAR3
    lc_class      TYPE char5      VALUE 'ZQTC_',                     " Class of type CHAR5
    lc_devid      TYPE char5      VALUE '_F037',                     " Devid of type CHAR5
    lc_colon      TYPE char1      VALUE ':',                         " Colon of type CHAR1
    lc_under      TYPE char1      VALUE '-',                         " Under of type char1 "CR-7841:SGUDA:30-Apr-2019:ED1K910095
    lc_combo      TYPE thead-tdname VALUE 'ZQTC_F037_COMBO_PRODUCT', " Name
    lc_idcodetype TYPE char4      VALUE 'ZJCD',
    lc_percentage TYPE char1  VALUE '%',                             " Percentage of type CHAR1
*   Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913033
    lc_parvw_za   TYPE parvw         VALUE 'ZA',     " Partner Function
    lc_parvw_ag   TYPE parvw         VALUE 'AG',     " Partner Function
    lc_posnr_h    TYPE posnr         VALUE '000000', " Item number of the SD document
*   End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913033
    lc_subs_term  TYPE thead-tdname VALUE 'ZQTC_F037_SUBS_TERM', " Name    lc_ponum         TYPE thead-tdname VALUE 'ZQTC_PONUM_F043',         " Name
    lc_subref     TYPE thead-tdname VALUE 'ZQTC_SUBREF_F043',    " Name
    lc_ponum      TYPE thead-tdname VALUE 'ZQTC_PONUM_F043',     " Name
    lc_cntr_start TYPE thead-tdname VALUE 'ZQTC_F042_CNT_STRT_DATE',  " Contract Start Date "CR-7841:SGUDA:30-Apr-2019:ED1K910095
    lc_cntr_end   TYPE thead-tdname VALUE 'ZQTC_F042_CNT_END_DATE'.   " Contract End Date "CR-7841:SGUDA:30-Apr-2019:ED1K910095

  v_waerk    = st_vbak-waerk.

  lst_komk-belnr = st_vbak-vbeln.
  lst_komk-knumv = st_vbak-knumv.

  li_vbap = i_vbap.
  DELETE li_vbap WHERE uepos IS INITIAL.

* As per the latest design irrespective of the country we are showing as Tax
* Hence removed all the irrelevant code.

  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.

  CLEAR: li_lines,
         lv_text.
  PERFORM read_text USING v_tax
                          st_header-language
                  CHANGING li_lines
                           lv_text.
  IF lv_text IS NOT INITIAL.
    CONDENSE lv_text.
  ENDIF. " IF lv_text IS NOT INITIAL

  CLEAR: li_vbap_hcomp[],
         i_bom_comp_tax[].

  li_vbap_hcomp[] = i_vbap[].
  DELETE li_vbap_hcomp WHERE uepos IS NOT INITIAL.

  PERFORM f_fetch_issue_seq  USING i_vbap
                             CHANGING i_issue_seq.

  LOOP AT i_konv INTO DATA(lst_komv_tmp).
    DATA(lst_komv) = lst_komv_tmp.
*   Check to identify if the Line is already "Rejected"
    READ TABLE i_vbap INTO lst_vbap
         WITH KEY posnr = lst_komv-kposn
         BINARY SEARCH.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF. " IF sy-subrc NE 0

*** Populate percentage
    lv_kbetr = lv_kbetr + lst_komv-kbetr.
*** Populate tax amount
    lst_tax_item-tax_amount = lst_tax_item-tax_amount + lst_komv-kwert.

    AT END OF kposn.
      IF lv_kbetr IS NOT INITIAL.
        lv_tax_amount = ( lv_kbetr / 10 ).
      ENDIF. " IF lv_kbetr IS NOT INITIAL
      WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
      CONCATENATE lst_tax_item-tax_percentage lc_percentage INTO lst_tax_item-tax_percentage.
      CONDENSE lst_tax_item-tax_percentage.

***** Populate text TAX
      lst_tax_item-media_type = lv_text.

***** Populate taxable amount
      lst_tax_item-taxable_amt = lst_komv-kawrt.

      READ TABLE i_mara INTO lst_mara
           WITH KEY matnr = lst_vbap-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_tax_item-ismmediatype = lst_mara-ismmediatype.
      ENDIF. " IF sy-subrc EQ 0

      COLLECT lst_tax_item INTO li_tax_item.
      CLEAR: lst_tax_item,lv_kbetr,lv_tax_amount.
    ENDAT.
  ENDLOOP. " LOOP AT i_konv INTO DATA(lst_komv_tmp)

  LOOP AT i_vbap INTO DATA(lst_vbap_itm).
    MOVE-CORRESPONDING lst_vbap_itm TO lst_vbap_final.
    IF lst_vbap_itm-uepos IS NOT INITIAL.
      lst_vbap_final-hl_itm = lst_vbap_itm-uepos.
    ELSE. " ELSE -> IF lst_vbap_itm-uepos IS NOT INITIAL
      lst_vbap_final-hl_itm = lst_vbap_itm-posnr.
    ENDIF. " IF lst_vbap_itm-uepos IS NOT INITIAL
    APPEND lst_vbap_final TO li_vbap_final.
    CLEAR: lst_vbap_final,lst_vbap_itm.
  ENDLOOP. " LOOP AT i_vbap INTO DATA(lst_vbap_itm)
  SORT li_vbap_final BY hl_itm posnr.

  LOOP AT li_vbap_final INTO DATA(lst_vbap_temp).
    DATA(lv_tabix_tmp) = sy-tabix.

    lv_tabix_hcomp = lv_tabix_hcomp + 1.

    lv_tax = lv_tax + lst_vbap_temp-kzwi6.

**To Populate Quantity amount unit price and discount
    READ TABLE li_vbap_hcomp INTO lst_vbap WITH KEY vbeln = lst_vbap_temp-vbeln
                                                    posnr = lst_vbap_temp-posnr
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
*    Quantity
      lv_kwmeng = lst_vbap-kwmeng.
      lv_kwmeng_qty = trunc( lv_kwmeng ).
      lst_final-qty = lv_kwmeng_qty.
      CONDENSE lst_final-qty.

*    Amount
*    WRITE lst_vbap-kzwi1 TO lst_final-amount CURRENCY v_waerk.
      WRITE lst_vbap-kzwi2 TO lst_final-amount CURRENCY v_waerk.

      CONDENSE lst_final-amount.
      IF lst_vbap-kzwi2 LT 0.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-amount.
      ENDIF. " IF lst_vbap-kzwi2 LT 0

*    Unit Price
      IF lv_kwmeng_qty NE 0.
        lv_unit_price = lst_vbap-kzwi1 / lv_kwmeng_qty.
        WRITE lv_unit_price TO lst_final-unit_price CURRENCY v_waerk.
        CONDENSE lst_final-unit_price.
        IF lv_unit_price LT 0.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-unit_price.
        ENDIF. " IF lv_unit_price LT 0
      ENDIF. " IF lv_kwmeng_qty NE 0

*    Discount
      WRITE lst_vbap-kzwi5 TO lst_final-discount CURRENCY v_waerk.
      CONDENSE lst_final-discount.
      IF lst_vbap-kzwi5 LT 0.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-discount.
      ENDIF. " IF lst_vbap-kzwi5 LT 0

*    Populate Sub Total
      v_sub_total = v_sub_total + lst_vbap-kzwi1.

**    Tax
*      v_taxes     =  v_taxes + lv_tax.

*  Discount in Subtotal footer
      v_discount = v_discount + lst_vbap-kzwi5.

      READ TABLE i_mara INTO DATA(lst_mara_tmp) WITH KEY matnr = lst_vbap_temp-matnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Multi Journal BOM
        IF lst_mara_tmp-mtart IN r_mtart_multi_bom. "Added by MODUTTA
          lv_multi_bom_flg = abap_true.
*       Combination BOM
        ELSEIF lst_mara_tmp-mtart IN r_mtart_combo_bom.
          lv_combo_bom_flg = abap_true.
*       Single Journal
        ELSE. " ELSE -> IF lst_mara_tmp-mtart IN r_mtart_multi_bom
          lv_normal_flg = abap_true.
        ENDIF. " IF lst_mara_tmp-mtart IN r_mtart_multi_bom
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

    PERFORM read_text_matdesc  USING lst_vbap_temp-matnr
                                     st_header-language
                               CHANGING lst_final-prod_des.
    IF lv_tabix_hcomp = 1.
      v_mat_desc    = lst_final-prod_des.
*      st_header-title_desc = v_mat_desc. "Added by MODUTTA on 04-Jun-2018 for CR# 6301 TR# ED2K912500
    ENDIF. " IF lv_tabix_hcomp = 1

    IF lst_final-prod_des IS NOT INITIAL.
      IF lv_multi_bom_flg IS NOT INITIAL
        AND lst_vbap_temp-uepos IS INITIAL. "If multi journal BOM header Journal code not reqd
        CONDENSE lst_final-prod_des.
      ELSE. " ELSE -> IF lv_multi_bom_flg IS NOT INITIAL
        IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
          OR lst_vbap_temp-uepos IS INITIAL.
          READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign1) WITH KEY  matnr = lst_vbap_temp-matnr
                                                                       idcodetype = v_idcodetype_1
                                                                       BINARY SEARCH.
          IF sy-subrc = 0.
            lv_identcode_zjcd = lst_jptidcdassign1-identcode.
            CONCATENATE lv_identcode_zjcd lst_final-prod_des INTO lst_final-prod_des SEPARATED BY c_char_hyphen.
            CONDENSE lst_final-prod_des.
            CLEAR: lv_identcode_zjcd,lst_jptidcdassign1.
          ELSE. " ELSE -> IF sy-subrc = 0
            CONDENSE lst_final-prod_des.
          ENDIF. " IF sy-subrc = 0
        ELSE. " ELSE -> IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
          CLEAR lst_final-prod_des.
        ENDIF. " IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
      ENDIF. " IF lv_multi_bom_flg IS NOT INITIAL
    ENDIF. " IF lst_final-prod_des IS NOT INITIAL

    IF lst_final IS NOT INITIAL.
      APPEND lst_final TO i_final.
      CLEAR lst_final.
    ENDIF. " IF lst_final IS NOT INITIAL

*    Media Type
    READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap_temp-matnr.
    IF sy-subrc EQ 0.
      CLEAR: lv_name_issn,
             lv_pnt_issn,
             lv_txt_med_type,
             li_lines[].
      CASE lst_mara-ismmediatype.
        WHEN c_mediatyp_dgtl.
          lv_name_issn = lc_digissn.
          PERFORM read_text   USING lv_name_issn
                                    st_header-language
                              CHANGING  li_lines
                                           lv_pnt_issn.
          CLEAR lv_txtmodule_data.
          PERFORM read_text_module USING c_med_type_digi_tm
                                         st_header-language
                                   CHANGING lv_txt_med_type.
        WHEN c_mediatyp_prnt.
          lv_name_issn = lc_pntissn.
          PERFORM read_text   USING lv_name_issn
                                    st_header-language
                              CHANGING  li_lines
                                           lv_pnt_issn.
          CLEAR lv_txtmodule_data.
          PERFORM read_text_module USING c_med_type_print_tm
                                         st_header-language
                                   CHANGING lv_txt_med_type.
        WHEN c_mediatyp_combo.
          lv_name_issn = lc_combissn.
          PERFORM read_text   USING lv_name_issn
                                    st_header-language
                              CHANGING  li_lines
                                           lv_pnt_issn.
          CLEAR lv_txtmodule_data.
          PERFORM read_text_module USING c_med_type_combo_tm
                                         st_header-language
                                   CHANGING lv_txt_med_type.
        WHEN OTHERS.
      ENDCASE.
    ENDIF. " IF sy-subrc EQ 0
*- Begin of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
*- Begin of OTCM-40086:MRAJKUMAR:05-JAN-2022:ED1K913942
*    IF lst_vbap_tmp-uepos IS INITIAL.
    IF lst_vbap_temp-uepos IS INITIAL.
*- End of OTCM-40086:MRAJKUMAR:05-JAN-2022:ED1K913942
      DATA(li_all_media_product) =  i_vbap[].
      CLEAR: lst_digital,lst_print,li_print_media_product[],li_digital_media_product[].
*      LOOP AT li_all_media_product INTO DATA(lst_all_media) WHERE uepos = lst_vbap_tmp-posnr.
      LOOP AT li_all_media_product INTO DATA(lst_all_media) WHERE uepos = lst_vbap_temp-posnr.
*- End of OTCM-40086:MRAJKUMAR:05-JAN-2022:ED1K913942
        IF lst_all_media-mvgr4 IN r_print_product.
          MOVE-CORRESPONDING lst_all_media TO lst_print.
          APPEND lst_print TO li_print_media_product.
          CLEAR lst_print.
        ENDIF.
        IF lst_all_media-mvgr4 IN r_digital_product.
          MOVE-CORRESPONDING lst_all_media TO lst_digital.
          APPEND lst_digital TO li_digital_media_product.
          CLEAR lst_digital.
        ENDIF.
        CLEAR lst_all_media.
      ENDLOOP.
      IF li_print_media_product[] IS INITIAL AND li_digital_media_product[] IS NOT INITIAL.
        lv_name_issn = lc_digissn.
        PERFORM read_text   USING lv_name_issn
                                  st_header-language
                            CHANGING  li_lines
                                         lv_pnt_issn.
        CLEAR lv_txtmodule_data.
        PERFORM read_text_module USING c_med_type_digi_tm
                                       st_header-language
                                 CHANGING lv_txt_med_type.
      ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS INITIAL.
        lv_name_issn = lc_pntissn.
        PERFORM read_text   USING lv_name_issn
                                  st_header-language
                            CHANGING  li_lines
                                         lv_pnt_issn.
        CLEAR lv_txtmodule_data.
        PERFORM read_text_module USING c_med_type_print_tm
                                       st_header-language
                                 CHANGING lv_txt_med_type.
      ELSEIF li_print_media_product[] IS NOT INITIAL AND li_digital_media_product[] IS NOT INITIAL.
        lv_name_issn = lc_combissn.
        PERFORM read_text   USING lv_name_issn
                                  st_header-language
                            CHANGING  li_lines
                                         lv_pnt_issn.
        CLEAR lv_txtmodule_data.
        PERFORM read_text_module USING c_med_type_combo_tm
                                       st_header-language
                                 CHANGING lv_txt_med_type.
      ENDIF.
    ENDIF.
*- End of OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
    IF lv_multi_bom_flg IS NOT INITIAL
        AND lst_vbap_temp-uepos IS INITIAL. "If Multi Journal header print only
      CLEAR: lv_med_type.
      PERFORM read_text_module USING c_med_type_combo_tm
                                     st_header-language
                                   CHANGING lv_med_type.
      lst_final-prod_des = lv_txt_med_type. "lv_med_type. "OTCM-40086:SGUDA:17-SEP-2021:ED2K924586
      APPEND lst_final TO i_final.
      CLEAR: lst_final.
    ELSE. " ELSE -> IF lv_multi_bom_flg IS NOT INITIAL
      IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
           OR lst_vbap_temp-uepos IS INITIAL.
        IF lv_txt_med_type IS NOT INITIAL.
          lst_final-prod_des = lv_txt_med_type.
          APPEND lst_final TO i_final.
          CLEAR: lst_final.
        ENDIF. " IF lv_txt_med_type IS NOT INITIAL
      ENDIF. " IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
    ENDIF. " IF lv_multi_bom_flg IS NOT INITIAL

** Multi Year Sub
    IF lst_vbap_temp-uepos IS INITIAL.
      CLEAR: li_lines,lv_subs_term.
      PERFORM read_text USING lc_subs_term
                              st_header-language
                     CHANGING li_lines
                              lv_subs_term.
      CONDENSE lv_subs_term.
      READ TABLE i_veda INTO DATA(lst_veda1) WITH KEY vbeln = lst_vbap-vbeln
                                              vposn = lst_vbap-posnr
                                              BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE i_tvlzt INTO DATA(lst_tvlzt1) WITH KEY spras = st_header-language
                                                          vlaufk = lst_veda1-vlaufk
                                                          BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lst_tvlzt1-bezei IS NOT INITIAL.
          CONCATENATE lv_subs_term lst_tvlzt1-bezei INTO lst_final-prod_des SEPARATED BY space.
          CONDENSE lst_final-prod_des.
          APPEND lst_final TO i_final.
          IF lv_tabix_hcomp = 1.
            APPEND lst_final TO i_final_email.
          ENDIF. " IF lv_tabix_hcomp = 1
          CLEAR lst_final.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF lst_vbap_temp-uepos IS INITIAL

    IF lv_multi_bom_flg IS NOT INITIAL    "for multi journal bom header only prod des
      AND lst_vbap_temp-uepos IS INITIAL. "media type and multi year subscription
      CLEAR: lst_vbap_temp,lst_final.
      CONTINUE. "will be printed
    ENDIF. " IF lv_multi_bom_flg IS NOT INITIAL

*** YEAR
    IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
             OR lst_vbap_temp-uepos IS INITIAL.
      CLEAR lst_veda1.
*     READ TABLE i_veda INTO lst_veda1 INDEX 1.
      READ TABLE i_veda INTO lst_veda1 WITH KEY vbeln = lst_vbap-vbeln
                                                vposn = lst_vbap-posnr
                                                BINARY SEARCH.
      IF lst_veda1-vbegdat IS INITIAL."sy-subrc NE 0. ""CR-7841:SGUDA:30-Apr-2019:ED1K910095
        READ TABLE i_veda INTO lst_veda1 WITH KEY vbeln = lst_vbap-vbeln
                                                  vposn = lc_posnr_h
                                                  BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        lv_year = lst_veda1-vbegdat+0(4).
      ENDIF. " IF sy-subrc EQ 0
      CLEAR lst_final.
      CLEAR li_lines.
      PERFORM read_text USING lc_cntr_start "lc_year "CR-7841:SGUDA:30-Apr-2019:ED1K910095
                               st_header-language
                         CHANGING li_lines
                                  lv_year_1_str.
* Begin of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910095
      PERFORM read_text USING lc_cntr_end
                              st_header-language
                        CHANGING li_lines
                                 lv_year_1_end.

      lv_year_1 = lv_year_1_str.
*      IF lv_year IS NOT INITIAL.
*        CONCATENATE lv_year_1 lv_year INTO lst_final-prod_des SEPARATED BY space.
*        CONDENSE lst_final-prod_des.
*        APPEND lst_final TO i_final.
*        CLEAR: lst_final,lv_year,lv_year_1.
*      ENDIF. " IF lv_year IS NOT INITIAL
      IF lst_veda1-vbegdat IS NOT INITIAL.
        CLEAR: lv_year_1,lv_cntr_month,lv_cntr,lv_day,lv_month,lv_year2,lv_stext,lv_ltext.
        CONCATENATE lv_year_1_str lc_colon INTO lv_year_1.
        CONDENSE lv_year_1.
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = lst_veda1-vbegdat
          IMPORTING
            day                           = lv_day
            month                         = lv_month
            year                          = lv_year2
            stext                         = lv_stext
            ltext                         = lv_ltext
*           userdate                      =
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        CONCATENATE lv_day lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_under.
        CONDENSE lv_cntr.
        CONCATENATE lv_year_1 lv_cntr INTO lst_final-prod_des SEPARATED BY space.
        CONDENSE lst_final-prod_des.
        APPEND lst_final TO i_final.
        CLEAR: lst_final,lv_year,lv_year_1.
      ENDIF.
      IF lst_veda1-venddat IS NOT INITIAL.
        CLEAR: lv_year_1,lv_cntr_month,lv_cntr,lv_day,lv_month,lv_year2,lv_stext,lv_ltext.
        CONCATENATE lv_year_1_end lc_colon INTO lv_year_1.
        CONDENSE lv_year_1.
        CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
          EXPORTING
            idate                         = lst_veda1-venddat
          IMPORTING
            day                           = lv_day
            month                         = lv_month
            year                          = lv_year2
            stext                         = lv_stext
            ltext                         = lv_ltext
*           userdate                      =
          EXCEPTIONS
            input_date_is_initial         = 1
            text_for_month_not_maintained = 2
            OTHERS                        = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        CONCATENATE lv_day lv_stext lv_year2 INTO  lv_cntr SEPARATED BY lc_under.
        CONDENSE lv_cntr.
        CONCATENATE lv_year_1 lv_cntr INTO lst_final-prod_des SEPARATED BY space.
        CONDENSE lst_final-prod_des.
        APPEND lst_final TO i_final.
        CLEAR: lst_final,lv_year,lv_year_1.
      ENDIF.
* End of Change:CR-7841:SGUDA:30-Apr-2019:ED1K910095
    ENDIF. " IF ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
*Only for single journal print the volume and issue and for combination and multi journal take components
*issue and volume
    IF lv_normal_flg IS NOT INITIAL
      OR ( lv_multi_bom_flg IS NOT INITIAL AND lst_vbap_temp-uepos IS NOT INITIAL )
       OR ( lv_combo_bom_flg IS NOT INITIAL AND lv_tabix_hcomp = 2 ).
** Total of Issues, Start Volume, Start Issue
      CLEAR lst_mara.
      READ TABLE i_mara INTO lst_mara WITH KEY matnr = lst_vbap_temp-matnr.
      IF sy-subrc EQ 0.
        IF lst_mara-ismhierarchlevl EQ '2'.
* WR
          DATA(li_jksenip) = i_jksenip.
          DELETE li_jksenip WHERE product NE lst_vbap_temp-matnr.
          IF li_jksenip[] IS NOT INITIAL.
            CLEAR: lir_cntrct_dat_qt.
            READ TABLE i_veda  ASSIGNING FIELD-SYMBOL(<lst_veda_quote>)
                 WITH KEY vbeln = lst_vbap_temp-vbeln
                          vposn = lst_vbap_temp-posnr
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE i_veda  ASSIGNING <lst_veda_quote>
                   WITH KEY vbeln = lst_vbap_temp-vbeln
                            vposn = lc_posnr_h
                   BINARY SEARCH.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc EQ 0.
              lst_cntrct_dat_qt-sign   = c_sign_i.
              lst_cntrct_dat_qt-option = c_option_bt.
              lst_cntrct_dat_qt-low    = <lst_veda_quote>-vbegdat.
              lst_cntrct_dat_qt-high   = <lst_veda_quote>-venddat.
              APPEND lst_cntrct_dat_qt TO lir_cntrct_dat_qt.
              CLEAR: lst_cntrct_dat_qt.
            ENDIF. " IF sy-subrc EQ 0
            DELETE li_jksenip WHERE sub_valid_from  NOT IN lir_cntrct_dat_qt
                                AND sub_valid_until NOT IN lir_cntrct_dat_qt.
          ENDIF. " IF li_jksenip[] IS NOT INITIAL
          CLEAR: lst_iss_vol2.
          LOOP AT li_jksenip ASSIGNING FIELD-SYMBOL(<lst_jksenip>).
            AT FIRST.
**            Material
              lst_iss_vol2-matnr = <lst_jksenip>-product.

              READ TABLE i_mara_vol ASSIGNING FIELD-SYMBOL(<lst_mara_vol>)
                   WITH KEY matnr = <lst_jksenip>-issue
                   BINARY SEARCH.
              IF sy-subrc EQ 0.
**              Start Volume
                lst_iss_vol2-stvol = <lst_mara_vol>-ismcopynr.

**              Start Issue
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = <lst_mara_vol>-ismnrinyear
                  IMPORTING
                    output = lst_iss_vol2-stiss.
              ENDIF. " IF sy-subrc EQ 0
            ENDAT.

            lst_iss_vol2-noi = lst_iss_vol2-noi + 1.

            AT LAST.
              READ TABLE i_mara_vol ASSIGNING <lst_mara_vol>
                           WITH KEY matnr = <lst_jksenip>-issue
                           BINARY SEARCH.
              IF sy-subrc EQ 0
**              End Volume
                AND <lst_mara_vol>-ismcopynr IS NOT INITIAL.
                IF lst_iss_vol2-stvol NE <lst_mara_vol>-ismcopynr.
                  CONCATENATE lst_iss_vol2-stvol
                              <lst_mara_vol>-ismcopynr
                         INTO lst_iss_vol2-stvol
                    SEPARATED BY c_char_hyphen.
                ENDIF. " IF lst_iss_vol2-stvol NE <lst_mara_vol>-ismcopynr
              ENDIF. " IF sy-subrc EQ 0
            ENDAT.
          ENDLOOP. " LOOP AT li_jksenip ASSIGNING FIELD-SYMBOL(<lst_jksenip>)

          IF lst_iss_vol2 IS NOT INITIAL.
            DATA(lst_issue_vol) = lst_iss_vol2.
          ELSE. " ELSE -> IF lst_iss_vol2 IS NOT INITIAL
            CLEAR: lst_issue_vol.
          ENDIF. " IF lst_iss_vol2 IS NOT INITIAL
*         READ TABLE i_iss_vol2 INTO DATA(lst_issue_vol2) WITH KEY matnr = lst_mara-matnr.
*         IF sy-subrc EQ 0.
*           DATA(lst_issue_vol) = lst_issue_vol2.
*         ENDIF. " IF sy-subrc EQ 0
* WR
        ELSEIF lst_mara-ismhierarchlevl EQ '3'.
          READ TABLE i_mara_vol INTO DATA(lst_mara_vol) WITH KEY matnr = lst_mara-matnr. "Added by MODUTTA on 23/03/18
          IF sy-subrc EQ 0.
            lst_issue_vol-stvol = lst_mara_vol-ismcopynr.
            lst_issue_vol-noi = lst_mara_vol-ismnrinyear.
            lst_issue_vol-stiss = '1'.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_mara-ismhierarchlevl EQ '2'
      ENDIF. " IF sy-subrc EQ 0

***Start Volume
      CLEAR: li_lines[],
             lv_volume,
             lv_name.
*      IF lst_issue_vol IS NOT INITIAL.
*         Start Volume
      lv_name = lc_volume.
      PERFORM read_text USING lv_name
                              st_header-language
                        CHANGING li_lines
                                 lv_volume.

*        IF lst_issue_vol-stvol IS NOT INITIAL.
      CONCATENATE lv_volume lst_issue_vol-stvol INTO lv_issue_desc SEPARATED BY space.
      IF lst_final-prod_des IS NOT INITIAL.
        CONCATENATE lst_final-prod_des lc_comma lv_issue_desc INTO lst_final-prod_des.
      ELSE. " ELSE -> IF lst_final-prod_des IS NOT INITIAL
        lst_final-prod_des = lv_issue_desc.
      ENDIF. " IF lst_final-prod_des IS NOT INITIAL
      CONDENSE lst_final-prod_des.
*        ENDIF. " IF lst_issue_vol-stvol IS NOT INITIAL

* Total Issues
      lv_name = lc_issue.
      CLEAR: lv_issue,lv_issue_desc,li_lines[].
      PERFORM read_text USING lv_name
                              st_header-language
                        CHANGING li_lines
                                 lv_issue.
      IF lst_issue_vol-noi IS NOT INITIAL.
        MOVE lst_issue_vol-noi TO lv_vol.
        CONCATENATE lv_vol lv_issue INTO lv_issue_desc SEPARATED BY space.
        IF lst_final-prod_des IS NOT INITIAL.
          CONCATENATE lst_final-prod_des lc_comma lv_issue_desc INTO lst_final-prod_des.
        ELSE. " ELSE -> IF lst_final-prod_des IS NOT INITIAL
          lst_final-prod_des = lv_issue_desc.
        ENDIF. " IF lst_final-prod_des IS NOT INITIAL
        CONDENSE lst_final-prod_des.
      ENDIF. " IF lst_issue_vol-noi IS NOT INITIAL
*      ENDIF. " IF lst_issue_vol IS NOT INITIAL

      IF lst_final-prod_des IS NOT INITIAL.
        CONDENSE lst_final-prod_des.
        APPEND lst_final TO i_final.
        CLEAR lst_final.
      ENDIF. " IF lst_final-prod_des IS NOT INITIAL

*****Start Issue Number
*      IF lst_issue_vol IS NOT INITIAL.
* To Get "Start Issue" text module
      CLEAR lv_issue_str.
      PERFORM read_text_module USING c_start_issue_tm
                                     st_header-language
                               CHANGING lv_issue_str.
      lv_issue = lv_issue_str.
*        IF lst_issue_vol-stiss IS NOT INITIAL.
      CONCATENATE lv_issue lst_issue_vol-stiss INTO lst_final-prod_des SEPARATED BY space.
      CONDENSE lst_final-prod_des.
      APPEND lst_final TO i_final.
      CLEAR lst_final.
*        ENDIF. " IF lst_issue_vol-stiss IS NOT INITIAL
*      ENDIF. " IF lst_issue_vol IS NOT INITIAL
    ENDIF. " IF lv_normal_flg IS NOT INITIAL

    IF lv_normal_flg IS NOT INITIAL
          OR lst_vbap_temp-uepos IS NOT INITIAL.
** ISSN
      CLEAR lst_final.
      READ TABLE i_jptidcdassign INTO DATA(lst_jptidcdassign2) WITH KEY matnr = lst_vbap_temp-matnr
                                                                        idcodetype = v_idcodetype_2
                                                                        BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF lv_pnt_issn IS NOT INITIAL.
          CONCATENATE lv_pnt_issn lc_colon INTO lv_pnt_issn.
          CONDENSE lv_pnt_issn.
        ENDIF. " IF lv_pnt_issn IS NOT INITIAL
        IF lst_jptidcdassign2-identcode IS NOT INITIAL.
          CONCATENATE lv_pnt_issn lst_jptidcdassign2-identcode INTO lst_final-prod_des SEPARATED BY space.
          CONDENSE lst_final-prod_des.
          APPEND lst_final TO i_final.
          CLEAR: lst_final.
        ENDIF. " IF lst_jptidcdassign2-identcode IS NOT INITIAL
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_normal_flg IS NOT INITIAL

*   Begin of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913033
*   Populate li_input
    IF lst_vbap_temp-uepos IS INITIAL. "BOM Components should not be considered
      lst_input-product_no = lst_vbap_temp-matnr.
      READ TABLE i_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
           WITH KEY vbeln = lst_vbap_temp-vbeln
                    posnr = lst_vbap_temp-posnr
           BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE i_vbkd ASSIGNING <lst_vbkd>
             WITH KEY vbeln = lst_vbap_temp-vbeln
                      posnr = lc_posnr_h
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        lst_input-cust_grp = <lst_vbkd>-kdkg2.
      ENDIF. " IF sy-subrc EQ 0
      READ TABLE i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
           WITH KEY vbeln = lst_vbap_temp-vbeln
                    parvw = lc_parvw_za
                    posnr = lst_vbap_temp-posnr
           BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbap_temp-vbeln
                      parvw = lc_parvw_za
                      posnr = lc_posnr_h
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc NE 0.
        READ TABLE i_vbpa ASSIGNING <lst_vbpa>
             WITH KEY vbeln = lst_vbap_temp-vbeln
                      parvw = lc_parvw_ag
                      posnr = lc_posnr_h
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        lst_input-society = <lst_vbpa>-kunnr.
      ENDIF. " IF sy-subrc EQ 0
      APPEND lst_input TO i_input.
      CLEAR lst_input.
    ENDIF. " IF lst_vbap_temp-uepos IS INITIAL
*   End   of ADD:ERP-6458:WROY:20-AUG-2018:ED2K913033

** PO Number
    AT END OF hl_itm.
      CLEAR li_lines.
      PERFORM read_text USING lc_ponum
                              st_header-language
                           CHANGING li_lines
                               lv_ponum.
      CLEAR lst_final.
      READ TABLE i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbap-vbeln
                                                     posnr = lst_vbap-posnr.
      IF sy-subrc NE 0.
        READ TABLE i_vbkd  INTO lst_vbkd WITH  KEY vbeln = lst_vbap-vbeln
                                                   posnr = '000000'.
      ENDIF. " IF sy-subrc NE 0
      IF lst_vbkd-bstkd IS NOT INITIAL.
        CONCATENATE lv_ponum lc_colon lst_vbkd-bstkd INTO lst_final-prod_des.
        CONDENSE lst_final-prod_des.
        APPEND lst_final TO i_final.
        CLEAR  lst_final.
      ENDIF. " IF lst_vbkd-bstkd IS NOT INITIAL

** Subscription Reference
      CLEAR li_lines.
* BOC: CR#7730 KKRAVURI20181012  ED2K913582
      IF ( r_mat_grp5[] IS NOT INITIAL AND r_output_typ[] IS NOT INITIAL ) AND
         ( lst_vbap-mvgr5 IN r_mat_grp5 AND nast-kschl IN r_output_typ ).
        PERFORM read_text  USING c_membership_number
                                 st_header-language
                        CHANGING li_lines
                                 lv_subref.
        REPLACE lc_colon IN lv_subref WITH space.
      ELSE.
        PERFORM read_text  USING lc_subref
                                 st_header-language
                        CHANGING li_lines
                                 lv_subref.
      ENDIF.
* EOC: CR#7730 KKRAVURI20181012  ED2K913582
      IF lst_vbkd-ihrez IS NOT INITIAL.
        CONCATENATE lv_subref lc_colon INTO DATA(lvi_subref).
        CONCATENATE lvi_subref lst_vbkd-ihrez INTO lst_final-prod_des SEPARATED BY space.
        CONDENSE lst_final-prod_des.
        APPEND lst_final TO i_final.
        CLEAR:  lst_final, lst_vbkd.
      ENDIF. " IF lst_vbkd-ihrez IS NOT INITIAL

*     Append blank line after end of a higher level line item
      APPEND lst_final TO i_final.
      CLEAR: lst_final,
             lv_tabix_hcomp,
             lv_multi_bom_flg,
             lv_combo_bom_flg,
             lv_normal_flg.
    ENDAT.
  ENDLOOP. " LOOP AT li_vbap_final INTO DATA(lst_vbap_temp)

*    Tax
  v_taxes     =  v_taxes + lv_tax.

**  Total
  v_total = v_sub_total + v_discount + lv_tax.

  CLEAR lst_tax_item.
  LOOP AT li_tax_item INTO lst_tax_item.

*    lst_tax_tab-zzdesc = lst_tax_item-media_type.
    CONCATENATE lst_tax_item-media_type c_semicoln_char INTO lst_tax_tab-zzdesc. " Added by PBANDLAPAL

    WRITE lst_tax_item-taxable_amt TO lv_taxable_char CURRENCY v_waerk.
    CONCATENATE lv_taxable_char '@' INTO lv_taxable_char.
    CONDENSE lv_taxable_char.

    WRITE lst_tax_item-tax_amount TO lv_tax_amount_char CURRENCY v_waerk.
    CONDENSE lv_tax_amount_char.

    CONCATENATE lst_tax_item-tax_percentage  '=' INTO lst_tax_item-tax_percentage .
    CONDENSE lst_tax_item-tax_percentage.

    CONCATENATE lv_taxable_char ' ' lst_tax_item-tax_percentage ' ' lv_tax_amount_char INTO lst_tax_tab-zztax_dtls SEPARATED BY space.
    APPEND lst_tax_tab TO i_tax_tab.
    CLEAR lst_tax_tab.
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
  IF i_tax_tab IS INITIAL.
    CONCATENATE lv_text c_semicoln_char INTO lst_tax_tab-zzdesc.
    WRITE lv_zero_amt TO lst_tax_tab-zztax_dtls CURRENCY v_waerk.
    CONDENSE lst_tax_tab-zztax_dtls.
    APPEND lst_tax_tab TO i_tax_tab.
    CLEAR lst_tax_tab.
  ENDIF. " IF i_tax_tab IS INITIAL

* To convert the values to negative.
* To convert sub total values based on the currency and display accordingly
  WRITE v_sub_total  TO v_sub_total_c CURRENCY v_waerk.
  CONDENSE  v_sub_total_c.
  IF v_sub_total LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_sub_total_c.
  ENDIF. " IF v_sub_total LT 0

* To convert total values based on the currency and display accordingly
  WRITE v_total  TO v_total_c CURRENCY v_waerk.
  CONDENSE  v_total_c.
  IF v_total LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_total_c.
  ENDIF. " IF v_total LT 0

* To convert sub total values based on the currency and display accordingly
  WRITE v_taxes  TO v_taxes_c CURRENCY v_waerk.
  CONDENSE  v_taxes_c.
  IF v_taxes LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_taxes_c.
  ENDIF. " IF v_taxes LT 0

* To convert sub total values based on the currency and display accordingly
  WRITE v_discount  TO v_discount_c CURRENCY v_waerk.
  CONDENSE  v_discount_c.
  IF v_discount LT 0.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = v_discount_c.
  ENDIF. " IF v_discount LT 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_OUTPUT
*&---------------------------------------------------------------------*
*       Subroutine to print layout
*----------------------------------------------------------------------*
FORM f_adobe_print_output CHANGING fp_v_returncode   TYPE sysubrc. " Return Code
  DATA: lst_outputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_docparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_form          TYPE tdsfname,        " Smart Forms: Form Name
        lv_fm_name       TYPE rs38l_fnam,      " Name of Function Module
        li_output        TYPE ztqtc_output_supp_retrieval,
        lv_upd_tsk       TYPE i.               " Upd_tsk of type Integers

  lv_form = tnapr-sform.
  IF tnapr-formtype NE c_pdf.
    fp_v_returncode = 1.
    PERFORM f_protocol_update.
    RETURN.
  ENDIF. " IF tnapr-formtype NE c_pdf

*--- Set output parameters
  lst_outputparams-preview   = v_screen_display. " launch print preview
* Begin of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
* IF v_screen_display EQ abap_true.
*   lst_outputparams-noprint   = abap_true. " no printing in the preview
* End   of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
* Begin of ADD:RITM0070026:WROY:26-SEP-2018:ED1K908565
  IF NOT v_screen_display IS INITIAL.
    lst_outputparams-getpdf    = abap_false.
* End   of ADD:RITM0070026:WROY:26-SEP-2018:ED1K908565
    lst_outputparams-nopributt = abap_true. " no print buttons in the preview
    lst_outputparams-noarchive = abap_true. " no archiving in the preview
* Begin of ADD:RITM0070026:WROY:26-SEP-2018:ED1K908565
  ELSE. " ELSE -> IF NOT v_ent_screen IS INITIAL
    lst_outputparams-getpdf    = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_screen_display = 'W'. "Web dynpro
    lst_outputparams-getpdf  = abap_true.
* End   of ADD:RITM0070026:WROY:26-SEP-2018:ED1K908565
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
  lst_docparams-langu    = nast-spras.

* Archiving
  APPEND toa_dara TO lst_docparams-daratab.

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
    fp_v_returncode = sy-subrc.
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
      fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
      RETURN.
  ENDTRY.

*--- Call the generated function module
  CALL FUNCTION lv_fm_name
    EXPORTING
      /1bcdwb/docparams  = lst_docparams
      im_header          = st_header
      im_xstring         = v_xstring
      im_address         = st_address
      im_footer          = v_footer
      im_remit_to_tbt    = v_remit_to_tbt
      im_credit_tbt      = v_credit_tbt
      im_email_tbt       = v_email_tbt
      im_banking1_tbt    = v_banking1_tbt
      im_banking2_tbt    = v_banking2_tbt
      im_cust_serv_tbt   = v_cust_serv_tbt
      im_company_name    = v_compname
      im_table           = i_final
      im_v_sub_total     = v_sub_total_c
      im_total           = v_total_c
      im_tax             = v_taxes_c
      im_discount        = v_discount_c
      im_waerk           = v_waerk
      im_tax_tab         = i_tax_tab
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
      im_po_type         = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    IMPORTING
      /1bcdwb/formoutput = st_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.

  IF sy-subrc <> 0.
    fp_v_returncode = sy-subrc.
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
    fp_v_returncode = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF. " IF sy-subrc <> 0

  IF fp_v_returncode = 0
     AND v_screen_display IS INITIAL.
    IF lst_outputparams-arcmode <> '1'.
      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = 'PDF' "  class
          document                 = st_formoutput-pdf
        TABLES
          arc_i_tab                = lst_docparams-daratab
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
*           COMMINT only if the subroutine is not called in update task
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF lst_outputparams-arcmode <> '1'

********Perform is used to call E098 FM  & convert PDF in to Binary
    PERFORM f_call_fm_output_supp CHANGING li_output.

    PERFORM send_pdf_to_app_serv USING li_output
                                 CHANGING fp_v_returncode.
  ENDIF. " IF fp_v_returncode = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_protocol_update
*&---------------------------------------------------------------------*
FORM f_protocol_update .
*  IF v_screen_display = space.
* Begin of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
*      EXPORTING
*        msg_arbgb = sy-msgid
*        msg_nr    = sy-msgno
*        msg_ty    = sy-msgty
*        msg_v1    = sy-msgv1
*        msg_v2    = sy-msgv2
*        msg_v3    = sy-msgv3
*        msg_v4    = sy-msgv4
*      EXCEPTIONS
*        OTHERS    = 1.
* End of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb = syst-msgid
      msg_nr    = syst-msgno
      msg_ty    = c_msgtyp_err
      msg_v1    = syst-msgv1
      msg_v2    = syst-msgv2
    EXCEPTIONS
      OTHERS    = 0.
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*  ENDIF. " IF v_screen_display = space
ENDFORM. " protocol_update
*&---------------------------------------------------------------------*
*&      Form  SEND_PDF_TO_APP_SERV
*&---------------------------------------------------------------------*
*       Subroutine to send pdf in application server
*----------------------------------------------------------------------*
FORM send_pdf_to_app_serv  USING    fp_li_output    TYPE ztqtc_output_supp_retrieval
                           CHANGING v_returncode TYPE sysubrc. " Return Code

  CONSTANTS: lc_sl             TYPE char2   VALUE 'SL',       " Rn of type CHAR2
             lc_sap            TYPE char3   VALUE 'SAP',      " Sap of type CHAR3
             lc_bus_prcs_renwl TYPE zbus_prcocess VALUE 'R',  " Business Process - Renewal
             lc_prnt_vend_qi   TYPE zprint_vendor VALUE 'Q',  " Third Party System (Print Vendor) - QuickIssue
             lc_prnt_vend_bt   TYPE zprint_vendor VALUE 'B',  " Third Party System (Print Vendor) - BillTrust
             lc_parvw_re       TYPE parvw         VALUE 'RE', " Partner Function: Bill-To Party
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.      " Communication Method (Key) (Business Address Services)

  DATA: lv_flag         TYPE char1,                                   " Flag of type CHAR1
        lst_vbak        TYPE ty_vbak,
        lv_string       TYPE string,
        lv_waerk        TYPE waerk,                                   " SD Document Currency
        lv_bapi_amount  TYPE bapicurr_d,                              " Currency amount in BAPI interfaces
        lv_bukrs        TYPE bukrs,                                   " Company Code
        lv_count        TYPE numc4,                                   " Count of type Integers
        lv_sl_count     TYPE numc4,                                   " Count of type Integers
        lv_iden         TYPE char10,                                  " Id of type CHAR6
        lv_acnt_num     TYPE char10,                                  " Account number to remove leading zeros
        lv_file_name    TYPE localfile,                               " Local file for upload/download
        lv_print_vendor TYPE zprint_vendor,                           " Third Party System (Print Vendor)
        lv_print_region TYPE zprint_region,                           " Print Region
        lv_country_sort TYPE zcountry_sort,                           " Country Sorting Key
        lv_file_loc     TYPE file_no,                                 " Application Server File Path
        lst_pdf_file    TYPE fpformoutput,                            " Form Output (PDF, PDL)
        lv_date         TYPE syst_datum,                              " ABAP System Field: Current Date of Application Server
        lv_amount       TYPE char24,                                  " Amount of type CHAR24
        li_email_data   TYPE solix_tab,
        lv_deflt_comm   TYPE ad_comm,                                 " Communication Method (Key) (Business Address Services)
        lv_document_no  TYPE  saeobjid,                               " SAP ArchiveLink: Object ID (object identifier)
        lr_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL, " Wrapper Class for Office Documents
        lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL. " BCS: Document Exceptions

*****************
  IF fp_li_output IS NOT INITIAL.
* Begin of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
**Fetch details from Addresses (Business Address Services)
*   SELECT deflt_comm    "Communication Method (Key) (Business Address Services)
*     FROM adrc          " Addresses (Business Address Services)
*     INTO lv_deflt_comm "Businees address
*    UP TO 1 ROWS
*    WHERE addrnumber = st_address-adrnr_we.
*   ENDSELECT.
*   IF sy-subrc IS INITIAL.
**  do nonthing
*   ENDIF. " IF sy-subrc IS INITIAL
*
*   IF lv_deflt_comm EQ lc_deflt_comm_let.
* End   of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
*   Identify Bill-to Party Details
    READ TABLE i_vbpa INTO DATA(lst_vbpa)
         WITH KEY vbeln = st_header-vbeln
                  parvw = lc_parvw_re
         BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR: lst_vbpa.
    ENDIF. " IF sy-subrc NE 0

    CALL FUNCTION 'ZQTC_PRINT_VEND_DETERMINE'
      EXPORTING
        im_bus_prcocess     = lc_bus_prcs_renwl "Business Process (Renewal)
        im_country          = lst_vbpa-land1    "Bill-to Party Country
        im_output_type      = nast-kschl        "Output Type
      IMPORTING
        ex_print_vendor     = lv_print_vendor   "Third Party System (Print Vendor)
        ex_print_region     = lv_print_region   "Print Region
        ex_country_sort     = lv_country_sort   "Country Sorting Key
        ex_file_loc         = lv_file_loc       "Application Server File Path
      EXCEPTIONS
        exc_invalid_bus_prc = 1
        exc_no_entry_found  = 2
        OTHERS              = 3.
    IF sy-subrc NE 0.
      CLEAR: lv_print_vendor.
    ENDIF. " IF sy-subrc NE 0

    READ TABLE i_vbfa INTO DATA(lst_vbfa) INDEX 1.
    IF sy-subrc EQ 0.
      "Do Nothing
    ENDIF. " IF sy-subrc EQ 0

*   Trigger different logic based on Third Party System (Print Vendor)
    CASE lv_print_vendor.
      WHEN lc_prnt_vend_qi. "Third Party System (Print Vendor) - QuickIssue
        CALL FUNCTION 'ZQTC_QUICK_ISSUE_DOWNLOAD'
          EXPORTING
            im_outputs           = fp_li_output      "PDF Contents
            im_bus_prcocess      = lc_bus_prcs_renwl "Business Process (Renewal)
            im_print_region      = lv_print_region   "Print Region
            im_country_sort      = lv_country_sort   "Country Sorting Key
            im_file_loc          = lv_file_loc       "Application Server File Path
            im_country           = lst_vbpa-land1    "Bill-to Party Country
            im_customer          = lst_vbpa-kunnr    "Bill-to Party Customer
            im_doc_number        = st_header-vbeln   "SD Document Number
            im_ref_contract      = lst_vbfa-vbelv    "SD Document Number (For Renewal Profile Determination)
          EXCEPTIONS
            exc_missing_dir_path = 1
            exc_err_opening_file = 2
            OTHERS               = 3.
        IF sy-subrc NE 0.
          v_returncode = sy-subrc.
          PERFORM f_protocol_update.
          RETURN.
        ENDIF. " IF sy-subrc NE 0

      WHEN lc_prnt_vend_bt. "Third Party System (Print Vendor) - BillTrust
        LOOP AT fp_li_output INTO DATA(lst_output).

          lv_count = lv_count + 1.
          IF sy-subrc IS INITIAL.
            lv_waerk    = st_vbak-waerk.
            lv_bukrs    = st_vbak-bukrs_vf.
            lv_date     = st_vbak-angdt.
          ENDIF. " IF sy-subrc IS INITIAL
          lv_bapi_amount = v_total.
*         Converts a currency amount from SAP format to External format
          CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_BAPI'
            EXPORTING
              currency    = lv_waerk        " Currency
              sap_amount  = lv_bapi_amount  " SAP format
            IMPORTING
              bapi_amount = lv_bapi_amount. " External format
          MOVE lv_bapi_amount TO lv_amount.
          CONDENSE lv_amount.

          IF lv_count <> 1.
            lv_sl_count = lv_sl_count + 1.
            CONCATENATE lc_sl
                        lv_sl_count
                    INTO lv_iden.
          ELSE. " ELSE -> IF lv_count <> 1
            lv_iden = lc_sap.
          ENDIF. " IF lv_count <> 1
          lst_pdf_file-pdf = lst_output-pdf_stream.
          CALL FUNCTION 'ZRTR_AR_PDF_TO_3RD_PARTY'
            EXPORTING
              im_fpformoutput    = lst_pdf_file
              im_customer        = lst_vbpa-kunnr
              im_invoice         = st_header-vbeln
              im_amount          = lv_amount
              im_currency        = lv_waerk
              im_date            = lv_date
              im_form_identifier = lv_iden
              im_ccode           = lv_bukrs
              im_file_loc        = lv_file_loc
            IMPORTING
              ex_file_name       = lv_file_name.
          IF lv_file_name IS NOT INITIAL.
            "No Action
          ENDIF. " IF lv_file_name IS NOT INITIAL
        ENDLOOP. " LOOP AT fp_li_output INTO DATA(lst_output)
      WHEN OTHERS.
*       Nothing to Do
    ENDCASE.
*   Begin of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
*   ENDIF. " IF lv_deflt_comm EQ lc_deflt_comm_let
*   End   of DEL:RITM0070026:WROY:26-SEP-2018:ED1K908565
  ENDIF. " IF fp_li_output IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       send adobe form as email
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode TYPE sysubrc. " Return Code
  DATA: lst_outputparams TYPE sfpoutputparams, " Form Processing Output Parameter
        lst_docparams    TYPE sfpdocparams,    " Form Parameters for Form Processing
        lv_form          TYPE tdsfname,        " Smart Forms: Form Name
        lv_fm_name       TYPE rs38l_fnam,      " Name of Function Module
        li_output        TYPE ztqtc_output_supp_retrieval,
        lv_upd_tsk       TYPE i.               " Upd_tsk of type Integers

  IF v_screen_display = abap_true.
    SELECT SINGLE b~smtp_addr
           INTO v_send_email
           FROM usr21 AS a INNER JOIN adr6 AS b ON
           a~addrnumber = b~addrnumber AND
           a~persnumber = b~persnumber
           WHERE bname = sy-uname.
    IF sy-subrc NE 0.
      fp_v_returncode = sy-subrc.
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
*      WHERE addrnumber EQ st_address-adrnr_we. "commented as part of RITM0075120, rkumar2
      WHERE addrnumber EQ st_address-adrnr_bp. "logic added as part of RITM0075120, rkumar2
    ENDSELECT.
    IF sy-subrc NE 0.
* Begin of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*      MESSAGE i243(zqtc_r2). " Email ID is not maintained for Ship to Customer
* End of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
      MESSAGE i556(zqtc_r2). " Email ID is not maintained for Bill to party
* End of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
      fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
* Begin of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
      IF sy-subrc EQ 0.
        fp_v_returncode = 900. RETURN.
      ENDIF. " IF sy-subrc EQ 0
* End of Change:ADD:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
* Begin of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
*      RETURN.
* End of Change:DEL:INC0236404:RBTIRUMALA:29/03/2019:ED1K909899
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF v_screen_display = abap_true

  IF fp_v_returncode = 0.
    lv_form = tnapr-sform.
    lst_outputparams-getpdf = abap_true.
    lst_outputparams-preview = abap_false.
  ENDIF. " IF fp_v_returncode = 0

*--- Set output parameters
*  lst_outputparams-preview   = v_screen_display. " launch print preview
  IF v_screen_display EQ abap_true.
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
  lst_docparams-langu    = nast-spras.

* Archiving
  APPEND toa_dara TO lst_docparams-daratab.

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
    fp_v_returncode = sy-subrc.
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
      fp_v_returncode = sy-subrc.
      PERFORM f_protocol_update.
      RETURN.
  ENDTRY.

*--- Call the generated function module
  CALL FUNCTION lv_fm_name
    EXPORTING
      /1bcdwb/docparams  = lst_docparams
      im_header          = st_header
      im_xstring         = v_xstring
      im_address         = st_address
      im_footer          = v_footer
      im_remit_to_tbt    = v_remit_to_tbt
      im_credit_tbt      = v_credit_tbt
      im_email_tbt       = v_email_tbt
      im_banking1_tbt    = v_banking1_tbt
      im_banking2_tbt    = v_banking2_tbt
      im_cust_serv_tbt   = v_cust_serv_tbt
      im_company_name    = v_compname
      im_table           = i_final
      im_v_sub_total     = v_sub_total_c
      im_total           = v_total_c
      im_tax             = v_taxes_c
      im_discount        = v_discount_c
      im_waerk           = v_waerk
      im_tax_tab         = i_tax_tab
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
      im_po_type         = v_po_type
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    IMPORTING
      /1bcdwb/formoutput = st_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.

  IF sy-subrc <> 0.
    fp_v_returncode = sy-subrc.
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
    fp_v_returncode = sy-subrc.
    PERFORM f_protocol_update.
  ENDIF. " IF sy-subrc <> 0

  IF fp_v_returncode = 0.
    IF v_screen_display IS INITIAL
      AND lst_outputparams-arcmode <> '1'.
      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = 'PDF' "  class
          document                 = st_formoutput-pdf
        TABLES
          arc_i_tab                = lst_docparams-daratab
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
*           COMMINT only if the subroutine is not called in update task
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF v_screen_display IS INITIAL

********Perform is used to call E098 FM  & convert PDF in to Binary
    PERFORM f_call_fm_output_supp CHANGING li_output.

********Perform is used to create mail attachment with a creation of mail body
    PERFORM f_mail_attachment USING li_output
                              CHANGING fp_v_returncode.
  ENDIF. " IF fp_v_returncode = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       Send Email
*----------------------------------------------------------------------*
FORM f_mail_attachment USING fp_li_output TYPE ztqtc_output_supp_retrieval
                       CHANGING v_returncode TYPE sysubrc. " Return Code

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
      language                = st_header-language
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

  IF fp_li_output IS NOT INITIAL.
    LOOP AT fp_li_output INTO DATA(lst_output).
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
          i_attachment_subject = 'Consolidated Notices'(005)
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
      MESSAGE text-006 TYPE lc_s . "'I'.
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF v_send_email IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_STD_TEXT
*&---------------------------------------------------------------------*
*       Populating standard text
*----------------------------------------------------------------------*
FORM f_populate_std_text  USING   fp_st_header TYPE zstqtc_header_f043. " Header structure for Consolidated Renewal Notification
  CONSTANTS:
    lc_year          TYPE thead-tdname VALUE 'ZQTC_YEAR_F035',          " Name
    lc_volume        TYPE thead-tdname VALUE 'ZQTC_VOLUME_F035',        " Name
    lc_issue         TYPE thead-tdname VALUE 'ZQTC_ISSUE_F042',         " Name
    lc_stiss         TYPE thead-tdname VALUE 'ZQTC_START_ISSUE_F037',   " Name
    lc_comma         TYPE char1        VALUE ',',                       " Comma of type CHAR1
    lc_hash          TYPE char1        VALUE '#',                       " Hash of type CHAR1
    lc_pntissn       TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',    " Name
    lc_digissn       TYPE thead-tdname VALUE 'ZQTC_DIGITAL_ISSN_F042',  " Name
    lc_combissn      TYPE thead-tdname VALUE 'ZQTC_COMBINED_ISSN_F042', " Name
    lc_ponum         TYPE thead-tdname VALUE 'ZQTC_PONUM_F043',         " Name
    lc_subref        TYPE thead-tdname VALUE 'ZQTC_SUBREF_F043',        " Name
    lc_b             TYPE char1      VALUE '(',                         " B of type CHAR1
    lc_bb            TYPE char1      VALUE ')',                         " Bb of type CHAR1
    lc_undscr        TYPE char1      VALUE '_',                         " Undscr of type CHAR1
    lc_class         TYPE char5      VALUE 'ZQTC_',                     " Class of type CHAR5
    lc_devid         TYPE char5      VALUE '_F037',                     " Devid of type CHAR5
    lc_colon         TYPE char1      VALUE ':',                         " Colon of type CHAR1
    lc_mlsub         TYPE thead-tdname VALUE 'ZQTC_F037_SUBS_TERM',     " Name
    lc_combo         TYPE thead-tdname VALUE 'ZQTC_F037_COMBO_PRODUCT', " Name
    lc_idcodetype    TYPE char4      VALUE 'ZJCD',
    lc_re            TYPE parvw  VALUE 'RE',                            " Partner Function
    lc_underscore    TYPE char1  VALUE '_',                             " Underscore
    lc_txtname_part1 TYPE char10 VALUE 'ZQTC_F037_',                    " Txtname_part1 of type CHAR20
    lc_remit_to      TYPE char10 VALUE 'REMIT_TO_',                     " Txtname_part2 of type CHAR6
    lc_ftp           TYPE char3  VALUE 'FTP',                           " ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    lc_0161          TYPE char4  VALUE '0161',                          " ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    lc_banking1      TYPE char9  VALUE 'BANKING1_',                     " Banking1 of type CHAR9
    lc_banking2      TYPE char9  VALUE 'BANKING2_',                     " Banking2 of type CHAR9
    lc_cust          TYPE char13 VALUE 'CUST_SERVICE_',                 " Cust of type CHAR13
    lc_email         TYPE char6  VALUE 'EMAIL_',                        " Email of type CHAR6
    lc_credit        TYPE char7  VALUE 'CREDIT_',                       " Credit of type CHAR7
    lc_tbt           TYPE char3  VALUE 'TBT',                           " Tbt of type CHAR3
    lc_scc           TYPE char3  VALUE 'SCC',                           " Scc of type CHAR3
    lc_scm           TYPE char3  VALUE 'SCM',                           " Scm of type CHAR3
    lc_sp            TYPE parvw  VALUE 'AG',                            " Partner Function
    lc_za            TYPE parvw  VALUE 'ZA',                            " Partner Function
    lc_st            TYPE thead-tdid     VALUE 'ST',                    "Text ID of text to be read
    lc_object        TYPE thead-tdobject VALUE 'TEXT',                  "Object of text to be read
    lc_txtname_part2 TYPE char15 VALUE 'ZQTC_F032_',                    " Txtname_part2 of type CHAR20
    lc_comp_name     TYPE char10 VALUE 'COMP_NAME_',                    " Txtname for company name.
    lc_footer        TYPE char10 VALUE 'FOOTER_',                       " Txtname_part2 of type CHAR6
    lc_remit         TYPE char20 VALUE 'ZQTC_REMIT_TO',                 " Remit of type CHAR20
    lc_cust_service  TYPE char20 VALUE 'ZQTC_CUST_SERVICE_',            " Cust_service of type CHAR20
    lc_email_id      TYPE char20 VALUE 'ZQTC_EMAIL_',                   " Email_id of type CHAR20
    lc_footer_dflt   TYPE char16 VALUE 'ZQTC_FOOTER_',                  " Footer_dflt of type CHAR16
    lc_xxx           TYPE char3  VALUE 'XXX',                           " Xxx of type CHAR3
    lc_bank          TYPE thead-tdname   VALUE 'ZQTC_F043_BANK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
    lc_remit1        TYPE thead-tdname   VALUE 'ZQTC_F043_CHECK_DETAILS_1001_USD'. "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
**** Populate Standard Text
*** Read table to get LAND1
  READ TABLE i_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = fp_st_header-vbeln
                                                 parvw = lc_re
                                                 BINARY SEARCH.
  IF sy-subrc = 0.
    DATA(lv_land1) = lst_vbpa-land1.
  ENDIF. " IF sy-subrc = 0


  IF st_vbak-bukrs_vf IS NOT INITIAL.
    DATA(lv_bukrs_vf) = st_vbak-bukrs_vf.
  ENDIF. " IF st_vbak-bukrs_vf IS NOT INITIAL

  IF st_vbak-waerk IS NOT INITIAL.
    DATA(lv_waerk) = st_vbak-waerk.
  ENDIF. " IF st_vbak-waerk IS NOT INITIAL
********Populate remit to address
  CONCATENATE lc_txtname_part1
              lc_remit_to
              lv_bukrs_vf
              lc_underscore
              lv_waerk
              lc_underscore
              lc_tbt
         INTO v_remit_to_tbt.
  CONDENSE v_remit_to_tbt NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  IF v_po_type = abap_true.
    CLEAR v_remit_to_tbt.
    CONCATENATE lc_txtname_part1
            lc_remit_to
            lc_ftp
            lc_underscore
            lc_0161
       INTO v_remit_to_tbt.
    CONDENSE v_remit_to_tbt NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  READ TABLE i_std_text INTO DATA(lst_std_text) WITH KEY tdname = v_remit_to_tbt
                                                        BINARY SEARCH.
  IF sy-subrc NE 0

  OR lv_land1 IN r_sanc_countries.

    CLEAR : v_remit_to_tbt.
    CONCATENATE lc_remit
                lc_underscore
                lc_xxx
                INTO v_remit_to_tbt.
  ENDIF. " IF sy-subrc NE 0
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785

  IF lv_bukrs_vf IN r_comp_code AND lv_waerk IN  r_docu_currency  AND st_vbak-vkbur IN r_sales_office.
    CLEAR v_remit_to_tbt.
    v_remit_to_tbt  = lc_remit1.
    CONDENSE v_remit_to_tbt NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
**********Populate banking1
  CONCATENATE lc_txtname_part1
              lc_banking1
              lv_bukrs_vf
              lc_underscore
              lv_waerk
              lc_underscore
              lc_tbt
         INTO v_banking1_tbt.
  CONDENSE v_banking1_tbt NO-GAPS.

**********Populate banking2
  CONCATENATE lc_txtname_part1
          lc_banking2
          lv_bukrs_vf
          lc_underscore
          lv_waerk
          lc_underscore
          lc_tbt
     INTO v_banking2_tbt.
  CONDENSE v_banking2_tbt NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  IF v_po_type = abap_true.
    CLEAR v_banking2_tbt.
    CONCATENATE lc_txtname_part1
            lc_banking2
            lc_xxx
            lc_underscore
            lc_ftp
            lc_underscore
            lc_xxx
       INTO v_banking2_tbt.
    CONDENSE v_banking2_tbt NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  IF lv_bukrs_vf IN r_comp_code AND lv_waerk IN  r_docu_currency  AND st_vbak-vkbur IN r_sales_office.
    CLEAR v_banking2_tbt.
    v_banking2_tbt  = lc_bank.
    CONDENSE v_banking2_tbt NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  IF v_remit_to_tbt CS lc_xxx OR
     lv_land1 IN r_sanc_countries.
    CLEAR: v_banking1_tbt,
           v_banking2_tbt.
  ENDIF. " IF v_remit_to_tbt CS lc_xxx OR

**********Populate customer service
  CONCATENATE lc_txtname_part1
      lc_cust
      lv_bukrs_vf
      lc_underscore
      lv_waerk
      lc_underscore
      lc_tbt
 INTO v_cust_serv_tbt.
  CONDENSE v_cust_serv_tbt NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  IF v_po_type IS NOT INITIAL.
    CONCATENATE lc_txtname_part1
        lc_cust
        lv_bukrs_vf
        lc_underscore
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
        lc_ftp
        lc_underscore
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
        lv_waerk
        lc_underscore
        lc_tbt
   INTO v_cust_serv_tbt.
    CONDENSE v_cust_serv_tbt NO-GAPS.
  ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_cust_serv_tbt
                                                        BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR : v_cust_serv_tbt.
    CONCATENATE lc_cust_service
                lc_tbt
                lc_underscore
                lv_bukrs_vf
                lc_underscore
                lc_xxx
                INTO v_cust_serv_tbt.
    CONDENSE v_cust_serv_tbt NO-GAPS.
* Begin of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
    IF v_po_type IS NOT INITIAL.
      CLEAR : v_cust_serv_tbt.
      CONCATENATE lc_cust_service
                  lc_tbt
                  lc_underscore
                  lc_ftp
                  lc_underscore
                  lv_bukrs_vf
                  lc_underscore
                  lc_xxx
                  INTO v_cust_serv_tbt.
      CONDENSE v_cust_serv_tbt NO-GAPS.
    ENDIF.
* End of ADD:OTCM-47818:SGUDA:21-OCT-2021:ED1K913605
  ENDIF. " IF sy-subrc NE 0


**********Populate email
  CONCATENATE lc_txtname_part1
  lc_email
  lv_bukrs_vf
  lc_underscore
  lv_waerk
  lc_underscore
  lc_tbt
INTO v_email_tbt.
  CONDENSE v_email_tbt NO-GAPS.

  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_email_tbt
                                                        BINARY SEARCH.
  IF sy-subrc NE 0

  OR lv_land1 IN r_sanc_countries.

    CLEAR : v_email_tbt.
    CONCATENATE lc_email_id
                lc_xxx
                INTO v_email_tbt.
    CONDENSE v_email_tbt NO-GAPS.
  ENDIF. " IF sy-subrc NE 0


**********Populate credit card details
  CONCATENATE lc_txtname_part1
  lc_credit
  lv_bukrs_vf
  lc_underscore
  lv_waerk
  lc_underscore
  lc_tbt
INTO v_credit_tbt.
  CONDENSE v_credit_tbt NO-GAPS.

  IF lv_land1 IN r_sanc_countries.
    CLEAR: v_credit_tbt.
  ENDIF. " IF lv_land1 IN r_sanc_countries


**********Populate footer
  CONCATENATE lc_txtname_part1
  lc_footer
  lv_bukrs_vf
  lc_underscore
  lv_waerk
  lc_underscore
  lc_tbt
INTO v_footer.
  CONDENSE v_footer NO-GAPS.

  READ TABLE i_std_text INTO lst_std_text WITH KEY tdname = v_footer
                                                        BINARY SEARCH.
  IF sy-subrc NE 0.
    CLEAR : v_footer.
    CONCATENATE lc_footer_dflt
                lv_bukrs_vf
                lc_underscore
                lc_tbt
                INTO v_footer.
    CONDENSE v_footer NO-GAPS.
  ENDIF. " IF sy-subrc NE 0

****** To populate the company name under wiley logo.
* we are using the F032 company name standard text as it is common to all
* renewal forms and to avoid unnecessary creation of standard texts.
  CONCATENATE lc_txtname_part2
              lc_comp_name
              lv_bukrs_vf
              lc_underscore
              lv_waerk
         INTO v_compname.
  CONDENSE v_compname NO-GAPS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PO_TYPE_FRM_VBKD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_po_type_frm_vbkd .
  READ TABLE i_vbkd INTO DATA(lst_vbkd) INDEX 1.
  IF sy-subrc EQ 0 AND lst_vbkd-bsark IN r_po_type.
    v_po_type = abap_true.
  ELSE.
    CLEAR v_po_type.
  ENDIF.
ENDFORM.
