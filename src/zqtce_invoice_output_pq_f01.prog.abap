*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_INVOICE_OUTPUT_PQ_F01
* PROGRAM DESCRIPTION: Invoice list output for large orders from PQ
* DEVELOPER: Himanshu Patel (HIPATEL)
* CREATION DATE:   12/20/2017
* OBJECT ID: E170
* TRANSPORT NUMBER(S): ED2K910001
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RB_ONLI  Radio Button: Manual Run
*      -->P_RB_BATCH  Radio Button: Batch Run
*----------------------------------------------------------------------*
FORM f_modify_screen  USING    p_rb_onli TYPE char1
                               p_rb_batch TYPE char1.
  CONSTANTS:
    lc_modif_grp TYPE char3 VALUE 'MI1'.

  LOOP AT SCREEN.
    IF p_rb_batch IS NOT INITIAL.
      IF screen-group1 EQ lc_modif_grp.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FKART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_FKART  Billing Type
*----------------------------------------------------------------------*
FORM f_validate_fkart USING fp_fkart TYPE tdt_rg_fkart.
  SELECT fkart              "Billing Type
    INTO TABLE @DATA(li_fkart)
    FROM tvfk               "Billing: Document Types
*    FOR ALL ENTRIES IN @fp_fkart
    WHERE fkart IN @fp_fkart.  "-low.
  IF sy-subrc NE 0.
    MESSAGE e007(vf)."Billing type & is not defined
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_AUART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_auart USING fp_auart TYPE fssc_dp_t_rg_auart.
  SELECT auart              "Sales Document Type
    INTO TABLE @DATA(li_auart)
    FROM tvak               "Sales Document Types
    WHERE auart IN @fp_auart.
  IF sy-subrc NE 0.
    MESSAGE e312(v1). "Billing type & is not defined
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_INVOICE_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_invoice_details .
  DATA: lv_tabix        TYPE sy-tabix,
        lv_cnt          TYPE i,
        lv_lines        TYPE i,
        lv_number_range TYPE i VALUE '90000000'.

  DATA: li_inv_tmp TYPE STANDARD TABLE OF ty_inv_data.

  CONSTANTS:
    lc_attr1 TYPE katr6 VALUE '001', " Summary Invoice
    lc_attr2 TYPE katr6 VALUE '002', " Consortium Invoice
    lc_attr3 TYPE katr6 VALUE '003'. " Detail Invoice

  IF NOT rb_batch IS INITIAL.
*Get last run date of program
    PERFORM f_get_last_run_date CHANGING s_erdat[]
                                         s_erzet[].
  ENDIF.


* Retrieve Billing Document data
  PERFORM f_get_vbrk    USING s_fkart[]
                              s_erdat[]
                              s_erzet[]
                              s_vbeln[]
                              s_bstnk[]
                     CHANGING i_vbrk
                              i_tax_data.
  IF NOT i_vbrk[] IS INITIAL.
* Retrieve Item data of Billing Document
    PERFORM f_get_vbrp    USING i_vbrk
                       CHANGING i_vbrp
                                i_veda.

    IF NOT i_vbrp[] IS INITIAL.
      DATA(li_vbrp_tmp) = i_vbrp[].
      SORT li_vbrp_tmp BY aubel.
      DELETE ADJACENT DUPLICATES FROM li_vbrp_tmp COMPARING aubel.
      IF NOT li_vbrp_tmp[] IS  INITIAL.
*Retrieve Sales/Contract order data
        PERFORM f_get_sales_ord_dta USING li_vbrp_tmp
                                    CHANGING i_vbak
                                             i_vbpa
                                             i_vbpa_py
                                             i_vbfa.
        IF NOT i_vbfa[] IS INITIAL.
          DATA(li_vbfa) = i_vbfa[].
          DELETE ADJACENT DUPLICATES FROM li_vbfa COMPARING vbelv vbeln.
        ENDIF.  "IF NOT i_vbfa[] IS INITIAL.
      ENDIF.  "IF NOT li_vbrp_tmp[] IS  INITIAL.
    ENDIF.  "IF NOT i_vbrp[] IS INITIAL.
  ENDIF.  "IF NOT i_vbrk[] IS INITIAL.
**********
**********
* Logic to get the Invoices created before the date range
* and which are not processed

***Collect Header data
  SORT: li_vbfa BY vbeln,
        i_vbrk  BY bstnk_vf.
  LOOP AT i_vbrk INTO DATA(lst_vbrk).
    AT NEW bstnk_vf.
      CLEAR: lv_cnt, li_inv_tmp, i_po_data.
      lv_number_range = lv_number_range + 1.
    ENDAT.

    READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY vbeln = lst_vbrk-vbeln
                                                   BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE i_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lst_vbfa-vbelv
                                            BINARY SEARCH.
      IF sy-subrc = 0 AND lst_vbak-bstnk EQ lst_vbrk-bstnk_vf.
        READ TABLE i_vbpa_py INTO DATA(lst_vbpa) WITH KEY vbeln = lst_vbak-vbeln
                                              BINARY SEARCH.
        IF sy-subrc = 0.
          lv_cnt = lv_cnt + 1.
          MOVE-CORRESPONDING lst_vbrk TO st_inv_hdr.
          st_inv_hdr-inv_no  = lv_number_range.
          st_inv_hdr-vbelv   = lst_vbak-vbeln.
          st_inv_hdr-vsnmr_v = lst_vbak-vsnmr_v.
          st_inv_hdr-kunnr   = lst_vbpa-kunnr.
          APPEND st_inv_hdr TO li_inv_tmp.
          CLEAR st_inv_hdr.
*Collect Customer PO details for further varification
          st_po_data-bstnk_vf = lst_vbrk-bstnk_vf.
          st_po_data-kunnr    = lst_vbpa-kunnr.
          st_po_data-vsnmr_v  = lst_vbak-vsnmr_v.
          COLLECT st_po_data INTO i_po_data.
          CLEAR st_po_data.
        ENDIF.
      ENDIF.
    ENDIF.

    AT END OF bstnk_vf.
      IF lv_cnt EQ lst_vbak-vsnmr_v.
        DESCRIBE TABLE i_po_data LINES lv_lines.
        IF lv_lines EQ 1.
** Add Records which are valid
          APPEND LINES OF li_inv_tmp TO i_inv_hdr.
        ELSE.
** Delete records from internal table which are not valid
          CLEAR: li_inv_tmp , i_po_data.
        ENDIF.
      ELSEIF lv_cnt NE lst_vbak-vsnmr_v.
** Delete records from internal table which are not valid
        CLEAR: li_inv_tmp , i_po_data.
      ENDIF.
    ENDAT.
  ENDLOOP.

  IF NOT i_inv_hdr[] IS INITIAL.
    SORT i_inv_hdr BY vbeln.
* Clear data
    PERFORM f_get_clear IN PROGRAM zqtcr_invoice_form_f024 IF FOUND.

* Subroutine to populate wiley logo.
    PERFORM f_populate_wiley_logo IN PROGRAM zqtcr_invoice_form_f024 CHANGING v_xstring.

* Subroutine to fetch constant values
    PERFORM f_get_constant IN PROGRAM zqtcr_invoice_form_f024
                             CHANGING v_outputyp_consor
                                      v_outputyp_detail
                                      v_outputyp_summary
                                      r_inv
                                      r_crd
                                      v_country_key
                                      r_dbt
                                      i_tax_id
                                      r_mtart_med_issue
                                      r_country.

* Retrieve ID codes of material
    PERFORM f_get_jptidcdassign IN PROGRAM zqtcr_invoice_form_f024
                                     USING i_vbrp
                                  CHANGING i_jptidcdassign.

* Retrieve material data from MARA table.
    PERFORM f_get_mara IN PROGRAM zqtcr_invoice_form_f024
                            USING i_vbrp
                         CHANGING i_mara
                                  i_makt.
********
******** need to maintain logic for below conditon
*    IF v_output_typ EQ v_outputyp_consor.
    PERFORM f_get_vbpa_consortia IN PROGRAM zqtcr_invoice_form_f024
                                      USING i_vbrp
                                   CHANGING i_vbpa_con.
*    ENDIF.

* Retrieve Purchase Order Number & Reference
    PERFORM f_get_vbkd USING i_vbfa
                    CHANGING i_vbkd.

********
******** Need to maintin logic for V_TRIG_ATTR for each ouput
* Retrieve Customer VAT
    PERFORM f_get_kna1 USING i_vbrk
                    CHANGING i_kna1
                             i_pterms.


* Retrieve data to calculate prepaid amount
    PERFORM f_get_prepaid_amount_data USING i_vbrk
                                   CHANGING i_dwn_pmnt
                                            i_konv
                                            i_fpltc
                                            i_tkomv.

* Perform to get address and emailID.
    PERFORM f_get_adrc IN PROGRAM zqtcr_invoice_form_f024
                            USING i_vbpa
                         CHANGING i_adrc.

* Subroutine to fetch email address of customer.
    PERFORM f_get_emailid USING i_vbpa
                       CHANGING i_email.

**Process Item data
    DATA(li_vbrp) = i_vbrp.
    REFRESH : i_vbrp,
              i_vbrp_cal.

    SORT i_inv_hdr BY bstnk_vf kunnr.
    SORT li_vbrp BY vbeln posnr.

    LOOP AT i_inv_hdr INTO st_inv_hdr.
* Update Invoice header ST_VBRK
*      IF st_vbrk IS INITIAL.
      DATA(lst_inv_hdr) = st_inv_hdr.
      AT NEW inv_no.
        MOVE-CORRESPONDING lst_inv_hdr TO st_vbrk.
        st_vbrk-vbeln = lst_inv_hdr-inv_no.
      ENDAT.
*      ENDIF.
* Update Invoice items

      LOOP AT li_vbrp INTO DATA(lst_vbrp) WHERE vbeln = st_inv_hdr-vbeln.
        APPEND lst_vbrp TO i_vbrp_cal.
        CLEAR : lst_vbrp-vbeln.
        lst_vbrp-vbeln = st_inv_hdr-inv_no.
        APPEND lst_vbrp TO i_vbrp.
      ENDLOOP.
      DATA(lv_kunnr) = st_inv_hdr-kunnr.
      AT END OF inv_no.
        DATA(lv_gnrt_pdf) = abap_true.
      ENDAT.
      IF lv_gnrt_pdf EQ abap_true.
***Update new custom Consolidated Invoice number
*in to VBRK-XBLNR for each Billing document
*          PERFORM f_xblnr_update USING lst_vbrp-vbeln
*                                       st_inv_hdr-inv_no.

***Transfer Combined Invoice details to Output
        READ TABLE i_kna1 INTO st_kna1 WITH KEY kunnr = lv_kunnr.
        IF sy-subrc EQ 0.
          IF st_kna1-katr6 = lc_attr1.
            PERFORM f_populate_layout_summary." IN PROGRAM zqtcr_invoice_form_f024.
          ELSEIF st_kna1-katr6 = lc_attr2.
            PERFORM f_populate_layout_consortia." IN PROGRAM zqtcr_invoice_form_f024.
          ELSEIF st_kna1-katr6 = lc_attr3.
            PERFORM f_populate_layout_detail." IN PROGRAM zqtcr_invoice_form_f024.
          ENDIF.
        ENDIF.
        CLEAR : lv_gnrt_pdf.
        PERFORM clear_data.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LAST_RUN_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_last_run_date CHANGING fp_s_erdat TYPE farric_rt_erdat
                                  fp_s_erzet TYPE fip_t_erzet_range.

  DATA: lst_erdat TYPE farric_rs_erdat,
        lst_erzet TYPE fip_s_erzet_range.

  CONSTANTS: lc_devid  TYPE zdevid VALUE 'E170', " Development ID
             lc_param1 TYPE rvari_vnam VALUE 'RUNDATE'.  "ABAP: Name of Variant Variable

*Selecting data from ZCAINTERFACE table
  SELECT SINGLE
         devid,        " Development ID
         param1,       " ABAP: Name of Variant Variable
         param2,       " ABAP: Name of Variant Variable
         lrdat,        " Last run date
         lrtime        " Last run time
    FROM zcainterface  " Interface run details
    INTO @DATA(lst_interface)
    WHERE devid EQ @lc_devid AND
          param1 EQ @lc_param1.
  IF sy-subrc EQ 0.
    lst_erdat-sign = 'I'.
    lst_erdat-option = 'EQ'.
    lst_erdat-low = lst_interface-lrdat.
    lst_erdat-high = sy-datum.
    APPEND lst_erdat TO fp_s_erdat.

    lst_erzet-sign = 'I'.
    lst_erzet-option = 'EQ'.
    lst_erzet-low = lst_interface-lrtime.
    lst_erzet-high = sy-uzeit.
    APPEND lst_erzet TO fp_s_erzet.
  ENDIF. " IF sy-subrc IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ENH_CONTROL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_enh_control .
  CONSTANTS:
    lc_wricef_id_e170 TYPE zdevid VALUE 'E170'.        "Constant value for WRICEF (E170)

  DATA:
    lv_var_key_e170   TYPE zvar_key,                    "Variable Key
    lv_actv_flag_e170 TYPE zactive_flag.                "Active / Inactive flag


*   Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e170                "Constant value for WRICEF (E170)
*     im_ser_num     = lc_ser_num_e170_2                "Serial Number (001)
*     im_var_key     = lv_var_key_e170                  "Variable Key (Credit Segment)
    IMPORTING
      ex_active_flag = lv_actv_flag_e170.               "Active / Inactive flag
  IF lv_actv_flag_e170 NE abap_true.
    MESSAGE i398(00) WITH text-e01. "Enhancement E170 is not active
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_DATE_VAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_CUR_RUNDATE  text
*      -->P_V_CUR_RUNTIME  text
*----------------------------------------------------------------------*
FORM f_set_date_val  USING    p_v_cur_rundate
                              p_v_cur_runtime.
  DATA: lst_interface TYPE zcainterface.   "Interface run details

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true            " Lock mode
      mandt             = sy-mandt             " 01th enqueue argument (Client)
      devid             = c_devid_e170         " 02th enqueue argument (Development ID)
      param1            = space                " 03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = space                " 04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.

  IF sy-subrc EQ 0.
    lst_interface-mandt  = sy-mandt.           " Client
    lst_interface-devid  = c_devid_e170.       " Development ID
    lst_interface-param1 = syst-slset.         " ABAP: Name of Variant Variable
    lst_interface-param2 = space.              " ABAP: Name of Variant Variable
    lst_interface-lrdat  = p_v_cur_rundate.   " Last run date
    lst_interface-lrtime = p_v_cur_runtime.   " Last run time

* Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_interface.

* Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
  ELSE.
*   Error Message
    MESSAGE ID sy-msgid                        " Message Class
          TYPE c_msgty_info                    " Message Type: Information
        NUMBER sy-msgno                        " Message Number
          WITH sy-msgv1                        " Message Variable-1
               sy-msgv2                        " Message Variable-2
               sy-msgv3                        " Message Variable-3
               sy-msgv4.                       " Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_INVOICE_DETA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_invoice_deta .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_XBLNR_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBRP_VBELN  text
*      -->P_ST_INV_HDR_INV_NO  text
*----------------------------------------------------------------------*
FORM f_xblnr_update  USING    fp_vbrp_vbeln TYPE vbeln_vf
                              fp_hdr_inv_no TYPE vbeln_vf.
  DATA: lv_xblnr TYPE xblnr.


  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = fp_hdr_inv_no
    IMPORTING
      output = fp_hdr_inv_no.


  CALL FUNCTION 'UPDATE_XBLNR_IN_VBRK'
    EXPORTING
      i_vbeln           = fp_vbrp_vbeln
      i_xblnr           = fp_hdr_inv_no
*     I_XBLNR_CHECK     =
    IMPORTING
      e_xblnr           = lv_xblnr
    EXCEPTIONS
      document_blocked  = 1
      update_no_success = 2
      OTHERS            = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_FKART[]  text
*      -->P_S_ERDAT[]  text
*      -->P_S_ERZET[]  text
*      <--P_I_VBRK  text
*----------------------------------------------------------------------*
FORM f_get_vbrk  USING    fp_s_fkart TYPE tdt_rg_fkart
                          fp_s_erdat TYPE farric_rt_erdat
                          fp_s_erzet TYPE fip_t_erzet_range
                          fp_s_vbeln TYPE tdt_rg_vbeln
                          fp_s_bstnk TYPE fagl_r_t_bstnk_range
                 CHANGING fp_i_vbrk TYPE tt_vbrk
                          fp_i_tax_data TYPE tt_tax_data.

* Local constant declaration
  CONSTANTS: lc_gjahr    TYPE gjahr VALUE '0000', " Fiscal Year
             lc_doc_type TYPE /idt/document_type VALUE 'VBRK'.

* Retrieve billing document data from VBRK table
  IF fp_s_bstnk[] IS INITIAL.
    SELECT bstnk_vf   "Po number
           vbeln      " Billing Document
           fkart      " Billing Type
           vbtyp      " SD document category
           waerk      " SD Document Currency
           vkorg      " Sales Organization
           knumv      " Number of the document condition
*         fkdat     " Billing date for billing index and printout
           zterm      " Terms of Payment Key
           zlsch      " Payment Method
           land1      " Country of Destination
           bukrs      " Company Code
           netwr      " Net Value in Document Currency
           erdat      " Date on Which Record Was Created
           kunrg      " Payer
           kunag      " Sold-to party
           zuonr      " Assignment number
           rplnr      " Number of payment card plan type
      INTO TABLE fp_i_vbrk
      FROM vbrk  " Billing Document: Header Data
      WHERE vbeln IN fp_s_vbeln AND
            fkart IN fp_s_fkart AND
            erdat IN fp_s_erdat AND
            erzet IN fp_s_erzet AND
            bstnk_vf NE space.
  ELSE.
    SELECT bstnk_vf   "Po number
         vbeln      " Billing Document
         fkart      " Billing Type
         vbtyp      " SD document category
         waerk      " SD Document Currency
         vkorg      " Sales Organization
         knumv      " Number of the document condition
*         fkdat     " Billing date for billing index and printout
         zterm      " Terms of Payment Key
         zlsch      " Payment Method
         land1      " Country of Destination
         bukrs      " Company Code
         netwr      " Net Value in Document Currency
         erdat      " Date on Which Record Was Created
         kunrg      " Payer
         kunag      " Sold-to party
         zuonr      " Assignment number
         rplnr      " Number of payment card plan type
    INTO TABLE fp_i_vbrk
    FROM vbrk  " Billing Document: Header Data
    WHERE vbeln IN fp_s_vbeln AND
          fkart IN fp_s_fkart AND
          erdat IN fp_s_erdat AND
          erzet IN fp_s_erzet AND
          bstnk_vf IN fp_s_bstnk.
  ENDIF.

  IF sy-subrc = 0.
    SORT fp_i_vbrk BY vbeln.

    SELECT document,
           doc_line_number,
           buyer_reg,
           seller_reg,     " Seller VAT Registration Number
           invoice_desc    " Invoice Description
      FROM /idt/d_tax_data " Tax Data
      INTO TABLE @fp_i_tax_data
      FOR ALL ENTRIES IN @fp_i_vbrk
      WHERE company_code = @fp_i_vbrk-bukrs
      AND   fiscal_year = @lc_gjahr
      AND   document_type = @lc_doc_type
      AND   document = @fp_i_vbrk-vbeln.
    IF sy-subrc EQ 0.
*      DATA(li_tax_data) = fp_i_tax_data.
*      SORT li_tax_data BY document doc_line_number.
*      DELETE li_tax_data WHERE buyer_reg IS INITIAL.
*      DATA(lv_lines) = lines( li_tax_data ).
*            LOOP AT li_tax_data INTO DATA(lst_tax_data).
*        IF lv_lines = 1.
*          st_header-buyer_reg = lst_tax_data-buyer_reg.
*        ENDIF. " IF lv_lines = 1
*        IF lst_tax_data-invoice_desc CS v_inv_desc
*          AND v_invoice_desc IS INITIAL.
*          v_invoice_desc = lst_tax_data-invoice_desc.
*        ENDIF. " IF lst_tax_data-invoice_desc CS v_inv_desc
*      ENDLOOP. " LOOP AT li_tax_data INTO DATA(lst_tax_data)

    ENDIF. " IF sy-subrc EQ 0

*    READ TABLE fp_i_vbrk INTO DATA(lst_vbrk) INDEX 1.
*    IF sy-subrc eq 0.
*
*    SELECT SINGLE land1                               "Country Key
*      FROM t001
*      INTO @st_header-comp_code_country
*     WHERE bukrs EQ @lst_vbrk-bukrs.
*    IF sy-subrc NE 0.
*      CLEAR: st_header-comp_code_country.
*    ENDIF.
*    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBRK  text
*      <--P_I_VBRP  text
*----------------------------------------------------------------------*
FORM f_get_vbrp  USING    fp_i_vbrk TYPE tt_vbrk
                 CHANGING fp_i_vbrp TYPE tt_vbrp
                          fp_i_veda TYPE tt_veda.
* Fetch Item data from VBRP table.
  SELECT vbeln      " Billing Document
         posnr      " Billing item
         uepos      " Higher-level item in bill of material structures
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
         kowrr      " Statistical values
         fareg       " Rule in billing plan/invoice plan
    INTO TABLE fp_i_vbrp
    FROM vbrp " Billing Document: Item Data
    FOR ALL ENTRIES IN fp_i_vbrk
    WHERE vbeln EQ fp_i_vbrk-vbeln.
  IF sy-subrc = 0.
    SORT fp_i_vbrp BY vbeln posnr.

    DATA(li_vbrp) = fp_i_vbrp[].
    DATA(li_vbrk_01) = fp_i_vbrk[].
    DELETE li_vbrk_01 WHERE vbtyp NOT IN r_crd.
    IF li_vbrk_01 IS NOT INITIAL.
      DELETE li_vbrp WHERE aubel IS INITIAL.
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

          READ TABLE li_vbrp INTO DATA(lst_vbrp) INDEX 1.
          IF sy-subrc IS INITIAL.
            DATA(lv_aubel) = lst_vbrp-aubel.
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

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
      SORT fp_i_veda BY vbeln vposn.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SALES_ORD_DTA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_VBRP_TMP  text
*      <--P_I_VBAK  text
*      <--P_I_VBPA  text
*      <--P_I_VBFA  text
*----------------------------------------------------------------------*
FORM f_get_sales_ord_dta  USING    fp_li_vbrp_tmp TYPE tt_vbrp
                          CHANGING fp_i_vbak      TYPE tt_vbak
                                   fp_i_vbpa      TYPE tt_vbpa
                                   fp_i_vbpa_py   TYPE tt_vbpa
                                   fp_i_vbfa      TYPE tt_vbfa.
*Contract Header data
  SELECT vbeln    "Sales document
         auart    "Document Type
         vkbur    "Sales Office
         bstnk    "Customer Purchase no
         vsnmr_v  "Split Number
    INTO TABLE fp_i_vbak
    FROM vbak
    FOR ALL ENTRIES IN fp_li_vbrp_tmp
    WHERE vbeln EQ fp_li_vbrp_tmp-aubel AND
          bstnk NE space AND
          vsnmr_v NE space.
  IF sy-subrc = 0 AND NOT fp_i_vbak[] IS INITIAL.
    SORT fp_i_vbak BY vbeln.

* Retrieve data from VBPA table
    SELECT vbeln   " Sales and Distribution Document Number
           posnr   " Item number of the SD document
           parvw   " Partner Function
           kunnr   " Customer Number
           adrnr   " Address
           land1   " Country Key
*        land1 " Country Key
      INTO TABLE fp_i_vbpa
      FROM vbpa "INNER JOIN adrc " Sales Document: Partner
*        ON vbpa~adrnr EQ adrc~addrnumber
      FOR ALL ENTRIES IN fp_i_vbak
      WHERE vbeln EQ fp_i_vbak-vbeln.

*    SELECT vbeln  " Sales and Distribution Document Number
*           posnr  " Item number of the SD document
*           parvw  " Partner Function
*           kunnr  " Customer Number
*           adrnr  " Address
*           land1  " Country Key
*    INTO TABLE fp_i_vbpa
*    FROM vbpa
*    FOR ALL ENTRIES IN fp_i_vbak
*    WHERE vbeln EQ fp_i_vbak-vbeln AND
*          parvw EQ c_py.
    IF sy-subrc = 0.
      SORT fp_i_vbpa BY vbeln.
      fp_i_vbpa_py = fp_i_vbpa.
      DELETE fp_i_vbpa_py WHERE parvw NE c_py.
    ENDIF.
    SELECT vbelv     "sales and distribution document
           posnv     "Preceding item of an SD document
           vbeln     "Billing Invoice
           posnn      "Subsequent item of an SD document
     INTO TABLE fp_i_vbfa
     FROM vbfa
     FOR ALL ENTRIES IN fp_i_vbak
     WHERE vbelv EQ fp_i_vbak-vbeln AND
           vbtyp_n EQ c_m  AND     "Invoice only
           vbtyp_v EQ c_c.         "Order Only
    IF sy-subrc = 0.
      SORT fp_i_vbfa BY vbelv vbeln.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KNA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBRK  text
*      <--P_I_KNA1  text
*      <--P_V_TRIG_ATTR  text
*----------------------------------------------------------------------*
FORM f_get_kna1  USING  fp_i_vbrk   TYPE tt_vbrk
              CHANGING  fp_i_kna1   TYPE tt_kna1
                        fp_i_pterms TYPE tt_pterms.

* Retrieve Customer VAT from KNA1 table
  SELECT kunnr        " Customer Number
         spras        " Language Key
         stceg        " VAT Registration Number
         katr6        " Attribute 6
    FROM kna1         " General Data in Customer Master
    INTO TABLE fp_i_kna1
    FOR ALL ENTRIES IN fp_i_vbrk
    WHERE kunnr EQ fp_i_vbrk-kunrg.
  IF sy-subrc EQ 0.

  ENDIF. " IF sy-subrc EQ 0

* Fetch payment term description
  SELECT spras
         zterm
         text1 " Own Explanation of Term of Payment
       INTO TABLE fp_i_pterms
   FROM t052u         " Own Explanations for Terms of Payment
   FOR ALL ENTRIES IN fp_i_vbrk
  WHERE zterm EQ fp_i_vbrk-zterm.
  IF sy-subrc EQ 0.
    SORT fp_i_pterms BY spras zterm text1.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PREPAID_AMOUNT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBRK  text
*      -->P_I_DWN_PMNT  text
*      -->P_I_KONV  text
*      -->P_I_FPLTC  text
*----------------------------------------------------------------------*
FORM f_get_prepaid_amount_data  USING  fp_i_vbrk     TYPE tt_vbrk
                             CHANGING  fp_i_dwn_pmnt TYPE tt_dwn_pmnt
                                       fp_i_konv     TYPE tt_konv
                                       fp_i_fpltc    TYPE tt_fpltc
                                       fp_i_tkomv    TYPE tt_tkomv.


* Constant declaration
  CONSTANTS : lc_zpay  TYPE kschl VALUE 'ZPAY', " Condition Type
              lc_stats TYPE kowrr VALUE 'Y',  " No cumulation - Values can be used statistically
              lc_dpmnt TYPE char2 VALUE '45', " Down payment in milestone billing on percentage / value basis
              lc_dcinv TYPE vbtyp VALUE 'M',  " Document Category: Invoice
              lc_bcdpr TYPE fktyp VALUE 'P',  " Billing Category: Down payment request
              lc_comma TYPE char01 VALUE ','. " Comma of type CHAR01
* Data Declaration
  DATA : lv_kwert TYPE kwert. " Condition value

  DATA(li_vbrp) = i_vbrp.
  DELETE li_vbrp WHERE kowrr EQ lc_stats
                  AND fareg CA lc_dpmnt.
  IF sy-subrc EQ 0 AND
     li_vbrp IS NOT INITIAL.

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
      INTO TABLE @i_dwn_pmnt
       FOR ALL ENTRIES IN @li_vbrp
     WHERE f~vbelv   EQ @li_vbrp-aubel
       AND f~posnv   EQ @li_vbrp-aupos
       AND f~vbtyp_n EQ @lc_dcinv
       AND f~fktyp   EQ @lc_bcdpr.
    IF sy-subrc EQ 0.

    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

  DATA(li_vbrk) = fp_i_vbrk.
  SORT li_vbrk BY knumv.
  DELETE ADJACENT DUPLICATES FROM li_vbrk COMPARING knumv.
  DELETE li_vbrk WHERE knumv IS INITIAL.
  IF li_vbrk IS NOT INITIAL.
    SELECT knumv  "Number of the document condition
           kposn  "Condition item number
           stunr  "Step number
           zaehk  "Condition counter
           kappl  " Application
           kawrt  "Condition base value
           kbetr  "Rate (condition amount or percentage)
           kwert "Condition value
           kinak  "Condition is inactive
           koaid  "Condition class
      FROM konv   "Conditions (Transaction Data)
      INTO TABLE fp_i_tkomv
      FOR ALL ENTRIES IN li_vbrk
      WHERE knumv = li_vbrk-knumv
        AND kinak = ''.
*      AND   kposn = fp_st_vbap-posnr.
* retrieve condition amount

    SELECT knumv " Number of the document condition
           kposn " Condition item number
           stunr " Step number
           zaehk " Condition counter
           kschl " Condition type
           kwert " Condition value
      FROM konv  " Conditions (Transaction Data)
      INTO TABLE i_konv
      FOR ALL ENTRIES IN li_vbrk
      WHERE knumv EQ li_vbrk-knumv
        AND kschl EQ lc_zpay.
  ENDIF.
  IF i_vbrp IS NOT INITIAL.
    REFRESH li_vbrp.
    li_vbrp = i_vbrp.
    SORT li_vbrp BY aubel.
    DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING aubel.
    DELETE li_vbrp WHERE aubel IS INITIAL.
  ENDIF. " IF i_vbrp IS NOT INITIAL

  SELECT fplnr,
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
      INTO TABLE @fp_i_fpltc
      FROM fpltc " Payment cards: Transaction data - SD
      FOR ALL ENTRIES IN @li_fpla
      WHERE fplnr = @li_fpla-fplnr.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_CONSORTIA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_consortia .

* Populate Header table
* populate header data
  PERFORM f_populate_detail_inv_header USING st_inv_hdr
                                             i_vbrp
                                             i_vbpa
                                             i_vbfa
                                             i_vbkd
                                             st_kna1
                                             i_pterms
                                             v_country_key
                                    CHANGING st_header.
* Populate Final item table
  PERFORM f_populate_detail_con_item USING st_inv_hdr
                                           i_vbrp
                                           i_vbpa_con
                                           i_adrc
                                           v_paid_amt
                                  CHANGING i_final
                                           v_prepaid_amount
                                           i_subtotal.

* Fetch Invoice text
  PERFORM f_fetch_title_text USING st_inv_hdr
                          CHANGING st_header
                                   v_accmngd_title
                                   v_reprint
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

  IF v_totaldue_val LE 0.
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
      PERFORM f_read_text IN PROGRAM zqtcr_invoice_form_f024
                               USING c_name_receipt
                            CHANGING v_accmngd_title.
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
    CLEAR v_totaldue_val.
    CLEAR: v_crdt_card_det.
    CLEAR: st_header-terms.
  ENDIF. " IF v_totaldue_val LE 0

* Get Email IDs
  PERFORM f_get_email USING st_header
                            i_email
                   CHANGING i_emailid.

*  Subroutine to print layout of consortia invoice.
  PERFORM f_adobe_print_layout_consortia.

* If email id is maintained, then send PDF as attachment to the mail address
  IF i_emailid[] IS NOT INITIAL.
    PERFORM f_send_mail_attach_consortia.
  ENDIF. " IF i_emailid[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_CONSORTIA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
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

* Get Form Name
  PERFORM get_formname USING v_outputyp_consor
                    CHANGING lv_form_name.

  lst_sfpoutputparams-preview = abap_true.

  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = 'LP01'.
  lst_sfpoutputparams-copies    = 1.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = 'BBANDYOPAD'."nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = '1'."nast-tdarmod.
  lst_sfpoutputparams-reqimm    = abap_true."nast-dimme.
  lst_sfpoutputparams-reqdel    = abap_true."nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
  lst_sfpdocparams-langu     = 'E'."nast-spras.

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
        im_v_reprint            = v_reprint
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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.

    ELSE. " ELSE -> IF sy-subrc <> 0
*     fm to close layout after printing
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                 BINARY SEARCH.

  IF sy-subrc EQ 0.
    IF lst_adrc-deflt_comm = lc_deflt_comm_let.
*      AND st_header-bill_country = 'US'.
*      PERFORM f_save_pdf_applictn_server.
    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
  ENDIF. " IF sy-subrc EQ 0


  IF lst_sfpoutputparams-arcmode <> '1' AND
     nast-nacha NE '1' AND                                "Print output
     lst_adrc-deflt_comm NE lc_deflt_comm_let.            "Letter
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
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_INV_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_INV_HDR  text
*      -->P_I_VBRP  text
*      -->P_I_VBPA  text
*      -->P_I_VBFA  text
*      -->P_I_VBKD  text
*      -->P_ST_KNA1  text
*      -->P_V_COUNTRY_KEY  text
*      <--P_ST_HEADER  text
*----------------------------------------------------------------------*
FORM f_populate_detail_inv_header  USING fp_st_inv_hdr TYPE ty_inv_data
                                         fp_i_vbrp     TYPE tt_vbrp
                                         fp_i_vbpa     TYPE tt_vbpa
                                         fp_i_vbfa     TYPE tt_vbfa
                                         fp_i_vbkd     TYPE tt_vbkd
                                         fp_st_kna1    TYPE ty_kna1
                                         fp_i_pterms   TYPE tt_pterms
                                         fp_v_country_key TYPE land1                  " Country Key
                                CHANGING fp_st_header  TYPE zstqtc_header_detail_f024 .

  DATA : lv_pay_term TYPE char50. " Description of terms of payment

* Constant Declaration
  CONSTANTS : lc_payer   TYPE parvw VALUE 'RG', " Partner Function
              lc_bp      TYPE parvw VALUE 'RE', " Partner Function
              lc_contact TYPE parvw VALUE 'ZC'. " Partner Function

  SORT fp_i_vbpa BY vbeln parvw.

* Populate Header detail
  fp_st_header-invoice_number = fp_st_inv_hdr-inv_no. " Invoice Number
  fp_st_header-inv_date       = fp_st_inv_hdr-erdat. " Invoice Date
  fp_st_header-terms          = fp_st_inv_hdr-zterm. " Payment terms
  fp_st_header-comp_code      = fp_st_inv_hdr-bukrs. " Company code
  fp_st_header-doc_currency   = fp_st_inv_hdr-waerk. " Document Currency
  fp_st_header-language       = fp_st_kna1-spras. " Language
  fp_st_header-cust_vat       = fp_st_kna1-stceg. " Customer VAT


  READ TABLE fp_i_vbrp INTO DATA(lst_vbrp) WITH KEY vbeln = fp_st_inv_hdr-inv_no
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.

    READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                      posnr = lst_vbrp-aupos
                                             BINARY SEARCH.

    IF sy-subrc EQ 0.
      DATA(lv_flag) = abap_true.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLEAR:lst_vbkd.
      READ TABLE fp_i_vbkd INTO lst_vbkd WITH KEY vbeln = lst_vbrp-aubel
                                                  posnr = '000000'
                                         BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_flag = abap_true.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

  IF lv_flag IS NOT INITIAL.
    fp_st_header-po_number = lst_vbkd-bstkd. " Purchase Order Number
  ENDIF. " IF lv_flag IS NOT INITIAL

  fp_st_header-bill_trust = fp_v_country_key. " Contact country key

  READ TABLE fp_i_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_vbrp-aubel
                                                    parvw = lc_bp
                                           BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-bill_country     = lst_vbpa-land1. " Payer country key
    fp_st_header-bill_cust_number = lst_vbpa-kunnr. " Payer customer number
    fp_st_header-bill_addr_number = lst_vbpa-adrnr. " Payer address number
    IF fp_st_header-bill_addr_number IS NOT INITIAL.
      fp_st_header-addr_number_billto = fp_st_header-bill_addr_number.
      fp_st_header-add_billto         = 1.
    ENDIF.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE fp_i_vbpa INTO DATA(lst_vbpa1) WITH KEY vbeln = lst_vbrp-aubel
                                                     parvw = c_we
                                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-ship_country     = lst_vbpa1-land1. " Contact country key
    fp_st_header-ship_cust_number = lst_vbpa1-kunnr. " Contact customer number
    fp_st_header-ship_addr_number = lst_vbpa1-adrnr. " Contact address number
    IF fp_st_header-ship_addr_number IS NOT INITIAL.
      fp_st_header-addr_number_shipto = fp_st_header-ship_addr_number.
      fp_st_header-add_shipto         = 1.
    ENDIF.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE fp_i_vbpa INTO DATA(lst_vbpa2) WITH KEY vbeln = lst_vbrp-aubel
                                                     parvw = lc_payer
                                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-acc_number = lst_vbpa2-kunnr. " Account Number
  ENDIF. " IF sy-subrc EQ 0

** Fetch payment term description
*  SELECT SINGLE text1 " Own Explanation of Term of Payment
*       INTO lv_pay_term
*   FROM t052u         " Own Explanations for Terms of Payment
*  WHERE spras EQ st_header-language
*    AND zterm EQ fp_st_inv_hdr-zterm.
  READ TABLE fp_i_pterms INTO st_pterms WITH KEY spras = st_header-language
                                                 zterm = fp_st_inv_hdr-zterm
                                        BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_st_header-terms  = st_pterms-text1. " Payment terms
  ENDIF. " IF sy-subrc EQ 0

  IF fp_st_inv_hdr-vbtyp IN r_crd.
    CLEAR fp_st_header-terms.
    fp_st_header-credit_flag = abap_true.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

  SET COUNTRY st_header-bill_country.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_CON_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBRK  text
*      -->P_I_VBRP  text
*      -->P_I_VBPA_CON  text
*      -->P_I_ADRC  text
*      -->P_V_PAID_AMT  text
*      <--P_I_FINAL  text
*      <--P_V_PREPAID_AMOUNT  text
*      <--P_I_SUBTOTAL  text
*----------------------------------------------------------------------*
FORM f_populate_detail_con_item  USING fp_st_vbrk          TYPE ty_inv_data
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
  DATA : li_lines  TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text   TYPE string,
         lv_ind    TYPE xegld,                   " Indicator: European Union Member?
         lst_line  TYPE tline,                   " SAPscript: Text Lines
         lst_lines TYPE tline.                   " SAPscript: Text Lines

  CONSTANTS:lc_undscr     TYPE char1      VALUE '_',                                 " Undscr of type CHAR1
            lc_vat        TYPE char3      VALUE 'VAT',                               " Vat of type CHAR3
            lc_tax        TYPE char3      VALUE 'TAX',                               " Tax of type CHAR3
            lc_gst        TYPE char3      VALUE 'GST',                               " Gst of type CHAR3
            lc_class      TYPE char5      VALUE 'ZQTC_',                             " Class of type CHAR5
            lc_devid      TYPE char5      VALUE '_F024',                             " Devid of type CHAR5
            lc_percent    TYPE char1 VALUE '%',                                      " Percent of type CHAR1
            lc_colon      TYPE char1      VALUE ':',                                 " Colon of type CHAR1
            lc_digital    TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',                   " Name
            lc_print      TYPE tdobname VALUE 'ZQTC_F024_PRINT',                     " Name
            lc_mixed      TYPE tdobname VALUE 'ZQTC_F024_MIXED',                     " Name
            lc_shipping   TYPE tdobname VALUE 'ZQTC_F024_SHIPPING',                  " Name
            lc_text_id    TYPE tdid     VALUE 'ST',                                  " Text ID
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042'. " Name

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
         lv_flag_se         TYPE xfeld.                " Checkbox

***BOC by MODUTTA on 17/10/2017 for CR#666
*******Fetch DATA from KONV table:Conditions (Transaction Data)
*  SELECT knumv, "Number of the document condition
*         kposn, "Condition item number
*         stunr, "Step number
*         zaehk, "Condition counter
*         kappl, " Application
*         kawrt, "Condition base value
*         kbetr, "Rate (condition amount or percentage)
*         kwert, "Condition value
*         kinak, "Condition is inactive
*         koaid  "Condition class
*    FROM konv   "Conditions (Transaction Data)
*    INTO TABLE @DATA(li_tkomv)
*    WHERE knumv = @fp_st_vbrk-knumv
*      AND kinak = ''.
**      AND   kposn = fp_st_vbap-posnr.

*  IF sy-subrc IS INITIAL.
  DATA(li_tkomv) = i_tkomv.
  DELETE li_tkomv WHERE knumv NE fp_st_vbrk-knumv.
  SORT li_tkomv BY kposn.
  DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
  DELETE li_tkomv WHERE kbetr IS INITIAL.
*  ENDIF. " IF sy-subrc IS INITIAL
***EOC by MODUTTA on 17/10/2017 for CR#666


  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

  IF v_ind EQ abap_true.
    CONCATENATE lc_class
                lc_vat
                lc_devid
           INTO v_tax.

  ELSEIF st_header-bill_country EQ 'US'.
    CONCATENATE lc_class
                lc_tax
                lc_devid
           INTO v_tax.
  ELSE. " ELSE -> IF v_ind EQ abap_true
    CONCATENATE lc_class
                lc_gst
                lc_devid
           INTO v_tax.

  ENDIF. " IF v_ind EQ abap_true
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

* Populate first line od description
  lst_final-description = 'ENHANCED ACCESS LICENSE'.
  CONCATENATE lst_final-description v_year INTO lst_final-description SEPARATED BY space.
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

*** Adding space after text
  lst_final-prod_id = space.
  lst_final-description = space.
  lst_final-fees = space.
  lst_final-discount = space.
  lst_final-sub_total = space.
  lst_final-tax_amount = space.
  lst_final-total = space.
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
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY uepos = lst_vbrp_vbpa-posnr.
    IF sy-subrc NE 0.

****     Populate Subscription Type
      lst_tax_item-subs_type = lst_mara-ismmediatype.

****      Populate media type text
      lst_tax_item-media_type = v_text_line.

****      Populate taxable amount for NON BOM item
      lst_tax_item-taxable_amt = lst_vbrp_vbpa-kzwi3.

****      Populate tax amount for Non BOM items
      lst_tax_item-tax_amount = lst_vbrp_vbpa-kzwi6.

      READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY kposn = lst_vbrp_vbpa-posnr.
      IF sy-subrc IS INITIAL.
        DATA(lv_index) = sy-tabix.
        LOOP AT li_tkomv INTO lst_komv FROM lv_index.
          IF lst_komv-kposn NE lst_vbrp_vbpa-posnr.
            EXIT.
          ENDIF. " IF lst_komv-kposn NE lst_vbrp_vbpa-posnr
          lv_kbetr = lv_kbetr + lst_komv-kbetr .
        ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
        lv_kbetr_desc = ( lv_kbetr / 10 ).
        WRITE lv_kbetr_desc TO lst_tax_item-tax_percentage.
        CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
        CONDENSE lst_tax_item-tax_percentage.
        CLEAR: lv_kbetr,lv_kbetr_desc.
        COLLECT lst_tax_item INTO li_tax_item.
        CLEAR lst_tax_item.
      ENDIF. " IF sy-subrc IS INITIAL
    ELSE. " ELSE -> IF sy-subrc NE 0
      IF sy-subrc EQ 0.
        DATA(lv_tabix_tmp) = sy-tabix.
        LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp.
          IF lst_vbrp_temp-uepos NE lst_vbrp_vbpa-posnr.
            EXIT.
          ENDIF. " IF lst_vbrp_temp-uepos NE lst_vbrp_vbpa-posnr
          lv_tax = lv_tax + lst_vbrp_temp-kzwi6.
        ENDLOOP. " LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc NE 0
****EOC by MODUTTA for CR# 666 on 18/10/12017

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
      ENDIF. " IF lst_vbrp_vbpa-aland EQ lst_vbrp_vbpa-lland
    ENDIF. " IF sy-subrc EQ 0
*************EOC by MODUTTA on 08/08/2017 for CR# 408****************

*   When ever one particular customer number end, put the values in final structure
    AT END OF kunnr.
      SET COUNTRY st_header-bill_country.
      IF lv_tabix > 1.
        APPEND lst_final1 TO fp_i_final.
      ENDIF. " IF lv_tabix > 1
**** FEES
      IF fp_st_vbrk-vbtyp IN r_crd " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
           AND lv_fees NE 0.

        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
*** BOC BY SAYANDAS
*        CONCATENATE lc_first lst_final-fees lc_second INTO lst_final-fees.
        CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.
*** EOC BY SAYANDAS
      ELSEIF lv_fees LT 0.
*** BOC BY SAYANDAS
*        lv_fees = lv_fees * -1.
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-fees.

*        CONCATENATE lc_first lst_final-fees lc_second INTO lst_final-fees.
*** EOC BY SAYNDAS
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

****Discount
* If discount value is 0, then show the value in braces to indicate
* negative value

      IF fp_st_vbrk-vbtyp IN r_crd.
        lv_disc = lv_disc * -1.
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.

      ELSEIF lv_disc LT 0.
*** BOC BY SAYANDAS
*        lv_disc = lv_disc * -1 .
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-discount.
        CONDENSE lst_final-discount.
*        CONCATENATE lc_first lst_final-discount lc_second INTO lst_final-discount.
*** EOC BY SAYANDAS
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      CLEAR lv_amount.

* Calculate Total Due
      v_subtotal_val = lv_subtotal +  v_subtotal_val.

*     Calculate sales tax
      v_sales_tax    = lv_tax + v_sales_tax.


**** Subtotal
      IF fp_st_vbrk-vbtyp IN r_crd
              AND lv_subtotal NE 0.
        WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
*** BOC BY SAYANDAS
*        CONCATENATE lc_first lst_final-sub_total lc_second INTO lst_final-sub_total.
        CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
*** EOC BY SAYANDAS
      ELSEIF lv_tax LT 0.
*** BOC BY SAYANDAS
*        lv_subtotal = lv_subtotal * -1.
        WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-sub_total.

*        CONCATENATE lc_first lst_final-sub_total lc_second INTO lst_final-sub_total.
*** EOC BY SAYANDAS
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

**** Tax Amount
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_tax NE 0.
        WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-tax_amount.
*** BOC BY SAYANDAS
*        CONCATENATE lc_first lst_final-tax_amount lc_second INTO lst_final-tax_amount.
        CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
*** EOC BY SAYANDAS
      ELSEIF lv_tax LT 0.
*** BOC BY SAYANDAS
*        lv_tax = lv_tax * -1.
        WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-tax_amount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-tax_amount.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-tax_amount.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      CLEAR lv_amount.


*     Total Amount
      IF fp_st_vbrk-vbtyp IN r_crd
        AND lv_total NE 0.
        WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
*** BOC BY SAYANDAS
*        CONCATENATE lc_first lst_final-total lc_second INTO lst_final-total.
        CONCATENATE lc_minus lst_final-total INTO lst_final-total.
*** EOC BY SAYANDAS
      ELSEIF lv_total LT 0.
*** BOC BY SAYANDAS
*        lv_total = lv_total * -1.
        WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-total.

*        CONCATENATE lc_first lst_final-total lc_second INTO lst_final-total.
*** EOC BY SAYANDAS
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_total TO  lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
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
        CLEAR lst_final.
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
              lst_vbrp_vbpa,
              lv_flag_di,
              lv_flag_ph,
              lv_flag_se.

    ENDAT.

  ENDLOOP. " LOOP AT li_vbrp_vbpa INTO DATA(lst_vbrp_dummy)
*  BOC by SRBOSE
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

***BOC by MODUTTA for CR#666 on 18/10/2017
  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type     = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-tax_amount.
    IF lst_tax_item-tax_amount IS NOT INITIAL.
      APPEND lst_tax_item_final TO i_tax_item.
      CLEAR lst_tax_item_final.
    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item
***EOC by MODUTTA for CR#666 on 18/10/2017
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_SUB_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_TXT_NAME  text
*      -->P_LV_TEXT_ID  text
*      <--P_V_TEXT_LINE  text
*----------------------------------------------------------------------*
FORM f_read_sub_type  USING fp_v_txt_name  TYPE tdobname " Name
                            fp_text_id     TYPE tdid     " Text ID
                   CHANGING fp_v_text_line TYPE char255. " V_text_line of type CHAR100

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
*&      Form  F_GET_VBKD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBFA  text
*      <--P_I_VBKD  text
*----------------------------------------------------------------------*
FORM f_get_vbkd  USING fp_i_vbfa TYPE tt_vbfa
              CHANGING fp_i_vbkd TYPE tt_vbkd.


  DATA(li_vbrp) = i_vbrp[].
  SORT li_vbrp BY aubel.
  DELETE ADJACENT DUPLICATES FROM li_vbrp COMPARING aubel.
  DELETE li_vbrp WHERE aubel IS INITIAL.
  IF li_vbrp[] IS NOT INITIAL.
* Retrieve PO Number from VBKD table
    SELECT vbeln " Sales and Distribution Document Number
           posnr "
           bstkd " Customer purchase order number
           ihrez " Your Reference
      INTO TABLE fp_i_vbkd
      FROM vbkd  " Sales Document: Business Data
      FOR ALL ENTRIES IN li_vbrp
      WHERE vbeln EQ li_vbrp-aubel.

    IF sy-subrc EQ 0.
      SORT fp_i_vbkd BY vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_vbrp[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data .

  CLEAR :  i_vbrp            ,
*           i_vbpa            ,
*           i_vbpa_con        ,
*           i_vbfa            ,
*           i_konv            ,
*           i_txtmodule       ,
*           i_adrc            ,
*           i_jptidcdassign   ,
*           i_mara            ,
*           i_vbkd            ,
*           r_country         ,
*           r_inv             ,
*           r_crd             ,
*           r_dbt             ,
*           i_content_hex     ,
*           i_emailid         ,
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
           v_ent_screen      ,
           v_faz             ,
           v_vkorg           ,
           v_title           ,
*           i_veda            ,
*           i_tax_data        ,
           v_txt_name        ,
           v_text_line       ,
           v_ind             ,
           v_year            ,
           i_subtotal        ,
           i_tax_item,
           i_text_item,
           i_terms_text,
           v_ccnum,
           v_seller_reg  ,
           v_invoice_desc,
           v_terms_cond,
           v_payment_detail_inv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_TITLE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBRK  text
*      <--P_ST_HEADER  text
*      <--P_V_ACCMNGD_TITLE  text
*      <--P_V_REPRINT  text
*      <--P_V_TAX  text
*      <--P_V_REMIT_TO  text
*      <--P_V_FOOTER  text
*      <--P_V_BANK_DETAIL  text
*      <--P_V_CRDT_CARD_DET  text
*      <--P_V_PAYMENT_DETAIL  text
*      <--P_V_CUST_SERVICE_DET  text
*      <--P_V_TOTALDUE  text
*      <--P_V_SUBTOTAL  text
*      <--P_V_PREPAIDAMT  text
*      <--P_V_VAT  text
*      <--P_V_PAYMENT_DETAIL_INV  text
*----------------------------------------------------------------------*
FORM f_fetch_title_text  USING fp_st_vbrk             TYPE ty_inv_data
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

* Populate Bank Details
  CONCATENATE lc_bank_det
              st_vbrk-bukrs
              lc_undscr
              st_vbrk-waerk
         INTO fp_v_bank_detail.

* Populate Customer Service details
  CONCATENATE lc_cust_service
              st_vbrk-bukrs
              lc_undscr
              st_vbrk-waerk
         INTO fp_v_cust_service_det.

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
* Retrieve European member indicator from T005 table
  SELECT SINGLE xegld " Indicator: European Union Member?
           INTO v_ind
           FROM t005  " Countries
           WHERE land1 = st_header-bill_country.

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
*&      Form  F_GET_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_SUBTOTAL  text
*      -->P_ST_HEADER  text
*      <--P_I_TXTMODULE  text
*----------------------------------------------------------------------*
FORM f_get_text  USING fp_c_subtotal    TYPE tdsfname                  " Smart Forms: Form Name
                       fp_st_header     TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
              CHANGING fp_i_txtmodule   TYPE tsftext..

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
*&      Form  F_POPULATE_HEADER_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_HEADER  text
*      <--P_FP_ST_HEADER  text
*----------------------------------------------------------------------*
FORM f_populate_header_text USING fp_st_header       TYPE zstqtc_header_detail_f024  " Structure for Header detail of invoice form
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
*&      Form  F_POPULATE_TITLE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_HEADER  text
*      -->P_ST_VBRK  text
*      -->P_R_COUNTRY  text
*      <--P_FP_V_ACCMNGD_TITLE  text
*      <--P_FP_V_REPRINT  text
*----------------------------------------------------------------------*
FORM f_populate_title_text  USING fp_st_header        TYPE zstqtc_header_detail_f024 " Structure for Header detail of invoice form
                                  fp_st_vbrk          TYPE ty_vbrk_01
                                  fp_r_country        TYPE tt_country
                         CHANGING fp_v_accmngd_title  TYPE char255                   " V_accmngd_title of type CHAR255
                                  fp_v_reprint        TYPE char255.
* Data declaration
  DATA : li_lines TYPE STANDARD TABLE OF tline, "Lines of text read
         lv_text  TYPE string.

* clear local variables
  CLEAR : li_lines,
          lv_text.

  IF fp_st_vbrk-vkorg NOT IN fp_r_country. "Added by MODUTTA for JIRA# 4713 on 31/10/2017
    IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz.
      PERFORM f_read_text    USING c_name_vkorg
                           CHANGING v_title.

    ENDIF. " IF fp_st_vbrk-vkorg NE v_vkorg AND fp_st_vbrk-fkart EQ v_faz
  ENDIF. " IF fp_st_vbrk-vkorg NOT IN fp_r_country


  IF fp_st_vbrk-vbtyp IN r_inv. " (++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421

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

  ELSEIF fp_st_vbrk-vbtyp IN r_crd. " (++) PBOSE: 05-June-2017: DEFECT 2276: ED2K906421

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

    PERFORM f_read_text    USING c_name_dbt
                        CHANGING fp_v_accmngd_title.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_inv


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_NAME_VKORG  text
*      <--P_V_TITLE  text
*----------------------------------------------------------------------*
FORM f_read_text  USING fp_c_name  TYPE thead-tdname " Name
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
*&      Form  F_POPULATE_LAYOUT_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_detail .

* Populate Header table
  PERFORM f_populate_detail_inv_header USING st_inv_hdr
                                             i_vbrp
                                             i_vbpa
                                             i_vbfa
                                             i_vbkd
                                             st_kna1
                                             i_pterms
                                             v_country_key
                                    CHANGING st_header.

* Populate Final item table
  PERFORM f_populate_detail_inv_item USING i_inv_hdr
                                           st_inv_hdr
                                           i_vbrp_cal
                                           i_jptidcdassign
                                           i_mara
                                           i_makt
                                           i_vbkd
                                           i_vbfa
                                           v_paid_amt
                                  CHANGING i_final
                                           v_prepaid_amount
                                           i_subtotal.

* Fetch Invoice text
  PERFORM f_fetch_title_text USING st_inv_hdr
                          CHANGING st_header
                                   v_accmngd_title
                                   v_reprint
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

  IF v_totaldue_val LE 0.
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
* If Due amount is 0, then title of the layout will be RECEIPT
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
    CLEAR v_totaldue_val.
*    CLEAR: v_payment_detail, v_crdt_card_det.
    CLEAR: v_crdt_card_det.
    CLEAR: st_header-terms.
  ENDIF. " IF v_totaldue_val LE 0

* Get Email IDs
  PERFORM f_get_email USING st_header
                            i_email
                   CHANGING i_emailid.

*  Subroutine to print layout of detail invoice.
  PERFORM f_adobe_print_layout_detail.

* If email id is maintained, then send PDF as attachment to the mail address
  IF i_emailid IS NOT INITIAL.
    PERFORM f_send_mail_attach_detail.
  ENDIF. " IF i_emailid IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_INV_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_INV_HDR  text
*      -->P_I_VBRP  text
*      -->P_I_JPTIDCDASSIGN  text
*      -->P_I_MARA  text
*      -->P_I_MAKT  text
*      -->P_I_VBKD  text
*      -->P_I_VBFA  text
*      -->P_V_PAID_AMT  text
*      <--P_I_FINAL  text
*      <--P_V_PREPAID_AMOUNT  text
*      <--P_I_SUBTOTAL  text
*----------------------------------------------------------------------*
FORM f_populate_detail_inv_item  USING fp_i_inv_hdr        TYPE tt_inv_data
                                       fp_st_inv_hdr       TYPE ty_inv_data
                                       fp_i_vbrp           TYPE tt_vbrp
                                       fp_i_jptidcdassign  TYPE tt_jptidcdassign
                                       fp_i_mara           TYPE tt_mara
                                       fp_i_makt           TYPE tt_makt
                                       fp_i_vbkd           TYPE tt_vbkd
                                       fp_i_vbfa           TYPE tt_vbfa
                                       fp_v_paid_amt       TYPE autwr  " Payment cards: Authorized amount
                              CHANGING fp_i_final          TYPE ztqtc_item_detail_f024
                                       fp_v_prepaid_amount TYPE char20 " V_prepaid_amount of type CHAR20
                                       fp_i_subtotal       TYPE ztqtc_subtotal_f024.

* Data Declaration
  DATA : li_final     TYPE ztqtc_item_detail_f024,
         lst_final    TYPE zstqtc_item_detail_f024, " Structure for Item table
         lst_knumv    TYPE ty_knumv,
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

  DATA : li_lines        TYPE STANDARD TABLE OF tline, "Lines of text read
         li_vbrp         TYPE STANDARD TABLE OF ty_vbrp INITIAL SIZE 0,
         lv_text         TYPE string,
         lv_mat_text     TYPE string,
         lv_tdname       TYPE thead-tdname, " Name
         lv_ind          TYPE xegld,                   " Indicator: European Union Member?
         lst_line        TYPE tline,                   " SAPscript: Text Lines
         lst_lines       TYPE tline,                   " SAPscript: Text Lines
         lst_subtotal    LIKE LINE OF i_subtotal,
         lst_final_space TYPE zstqtc_item_detail_f024. " Structure for Item table.

  CONSTANTS:      lc_undscr     TYPE char1      VALUE '_',                                 " Undscr of type CHAR1
                  lc_vat        TYPE char3      VALUE 'VAT',                               " Vat of type CHAR3
                  lc_tax        TYPE char3      VALUE 'TAX',                               " Tax of type CHAR3
                  lc_gst        TYPE char3      VALUE 'GST',                               " Gst of type CHAR3
                  lc_class      TYPE char5      VALUE 'ZQTC_',                             " Class of type CHAR5
                  lc_devid      TYPE char5      VALUE '_F024',                             " Devid of type CHAR5
                  lc_colon      TYPE char1      VALUE ':',                                 " Colon of type CHAR1
                  lc_digital    TYPE tdobname VALUE 'ZQTC_F024_DIGITAL',                   " Name
                  lc_print      TYPE tdobname VALUE 'ZQTC_F024_PRINT',                     " Name
                  lc_mixed      TYPE tdobname VALUE 'ZQTC_F024_MIXED',                     " Name
                  lc_shipping   TYPE tdobname VALUE 'ZQTC_F024_SHIPPING',                  " Name
                  lc_text_id    TYPE tdid     VALUE 'ST',                                  " Text ID
                  lc_pntissn    TYPE thead-tdname VALUE 'ZQTC_PRINT_ISSN_F042',            " Name
                  lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
                  lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
                  lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042'. " Name

  li_vbrp     = fp_i_vbrp.
* Fetch VAT/TAX/GST based on condition
  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.

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

  CLEAR : v_totaldue_val,
          v_subtotal_val,
          v_sales_tax.

* Populate first line od description
  lst_final-prod_id = v_year.
  lst_final-description = 'ENHANCED ACCESS LICENSE'.
  lst_final-fees = space.
  lst_final-discount = space.
  lst_final-sub_total = space.
  lst_final-tax_amount = space.
  lst_final-total = space.
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

  lst_final-prod_id = space.
  lst_final-description = space.
  lst_final-fees = space.
  lst_final-discount = space.
  lst_final-sub_total = space.
  lst_final-tax_amount = space.
  lst_final-total = space.
  APPEND lst_final TO fp_i_final.
  CLEAR lst_final.

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
         lv_kbetr           TYPE kbetr.                " Rate (condition amount or percentage)

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

*******Fetch DATA from KONV table:Conditions (Transaction Data)
*  SELECT knumv, "Number of the document condition
*         kposn, "Condition item number
*         stunr, "Step number
*         zaehk, "Condition counter
*         kappl, " Application
*         kawrt, "Condition base value
*         kbetr, "Rate (condition amount or percentage)
*         kwert, "Condition value
*         kinak, "Condition is inactive
*         koaid  "Condition class
*    FROM konv   "Conditions (Transaction Data)
*    INTO TABLE @DATA(li_tkomv)
*    WHERE knumv = @fp_st_vbrk-knumv
*      AND kinak = ''.
*  IF sy-subrc IS INITIAL.
  DATA(li_inv_hdr) = fp_i_inv_hdr.
  DELETE li_inv_hdr WHERE inv_no NE fp_st_inv_hdr-inv_no.
  lst_knumv-sign   = 'I'.
  lst_knumv-option = 'EQ'.
  LOOP AT li_inv_hdr INTO DATA(lst_inv_hdr).
    lst_knumv-low = lst_inv_hdr-knumv.
    APPEND lst_knumv TO r_knumv.
    CLEAR : lst_knumv-low.
  ENDLOOP.
  DATA(li_tkomv) = i_tkomv.
  DELETE li_tkomv WHERE knumv NOT IN r_knumv[].
  SORT li_tkomv BY knumv kposn.
  DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
  DELETE li_tkomv WHERE kbetr IS INITIAL.
*  ENDIF. " IF sy-subrc IS INITIAL

  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

*-------------Header BUYER_REG---------------------------------------*
*  DATA(li_tax_temp) = i_tax_data.
*  DELETE li_tax_temp WHERE buyer_reg IS INITIAL.
*  SORT li_tax_temp BY buyer_reg.
*  DELETE ADJACENT DUPLICATES FROM li_tax_temp COMPARING buyer_reg.
*  DESCRIBE TABLE li_tax_temp LINES DATA(lv_tax_line).
**  DATA(lv_tax_line) = lines ( )
*  IF lv_tax_line EQ 1.
*    READ TABLE li_tax_temp INTO DATA(lst_tax_temp) INDEX 1.
*    IF sy-subrc EQ 0.
*      st_header-buyer_reg = lst_tax_temp-buyer_reg.
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF lv_tax_line EQ 1
*--------------------------------------------------------------------*

* Populate final table
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)." WHERE vbeln = fp_st_inv_hdr-vbeln.

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
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY vbeln = lst_vbrp-vbeln
                                                         posnr = lst_vbrp-posnr
                                                         uepos = lst_vbrp-posnr.
    IF sy-subrc NE 0.

****     Populate Subscription Type
      lst_tax_item-subs_type = lst_mara-ismmediatype.

****      Populate media type text
      lst_tax_item-media_type = v_text_line.

****      Populate taxable amount for NON BOM item
      lst_tax_item-taxable_amt = lst_vbrp-kzwi3.

****      Populate tax amount for Non BOM items
      lst_tax_item-tax_amount = lst_vbrp-kzwi6.
      READ TABLE li_inv_hdr INTO lst_inv_hdr WITH KEY vbeln = lst_vbrp-vbeln.
      IF sy-subrc EQ 0.
        READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY knumv = lst_inv_hdr-knumv
                                                         kposn = lst_vbrp-posnr
                                                BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          DATA(lv_index) = sy-tabix.
          LOOP AT li_tkomv INTO lst_komv FROM lv_index.
            IF lst_komv-knumv NE lst_inv_hdr-knumv AND
               lst_komv-kposn NE lst_vbrp-posnr.
              EXIT.
            ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
            lv_kbetr = lv_kbetr + lst_komv-kbetr .
          ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
          lv_tax_amount = ( lv_kbetr / 10 ).
          WRITE lv_tax_amount TO lst_tax_item-tax_percentage.
          CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
          CONDENSE lst_tax_item-tax_percentage.
          CLEAR: lv_kbetr,lv_tax_amount.
          COLLECT lst_tax_item INTO li_tax_item.
          CLEAR lst_tax_item.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF.
    ELSE. " ELSE -> IF sy-subrc NE 0
      DATA(lv_tabix_tmp) = sy-tabix.
      LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp.
        IF lst_vbrp_temp-vbeln NE lst_vbrp-vbeln AND
           lst_vbrp_temp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_temp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp_temp-kzwi6.
      ENDLOOP. " LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp
      lst_tax_item-tax_amount = lv_tax.
    ENDIF. " IF sy-subrc NE 0

    IF lst_vbrp-uepos IS INITIAL. "BOM header or Non BOM but no BOM components
      IF lv_tabix_space GT 1.
        APPEND lst_final_space TO fp_i_final.
      ENDIF. " IF lv_tabix_space GT 1
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
***   Reference Number
      READ TABLE fp_i_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_vbrp-aubel
                                                        posnr = lst_vbrp-aupos
                                               BINARY SEARCH.
      IF sy-subrc EQ 0 .
        lst_final-prod_id = lst_vbkd-ihrez.
      ENDIF. " IF sy-subrc EQ 0

****   Fees
      SET COUNTRY st_header-bill_country.
      lv_fees =  lst_vbrp-kzwi1.
      IF fp_st_inv_hdr-vbtyp IN r_crd
        AND lv_fees NE 0.
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
        CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.
      ELSEIF lv_fees LT 0.
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-fees.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-fees.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd


****  Discount
      CLEAR :lv_disc.
* If discount value is 0, then show the value in braces to indicate
* negative value
      lv_disc = lst_vbrp-kzwi5.
      IF fp_st_inv_hdr-vbtyp IN r_crd.
        lv_disc = lv_disc * -1.
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.

      ELSEIF lv_disc LT 0.
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-discount.
        CONDENSE lst_final-discount.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_disc TO lst_final-discount CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-discount.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

      lv_subtot = lst_vbrp-kzwi3 + lv_subtot.

      IF fp_st_inv_hdr-vbtyp IN r_crd
        AND lv_subtot NE 0.
        WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
        CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
      ELSEIF lv_subtot LT 0.
        WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-sub_total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_subtot TO lst_final-sub_total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-sub_total.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

******     Item Number
      lst_final-item = lst_vbrp-posnr.

*******      Tax Amount
      IF lst_final-tax_amount IS INITIAL.
        lv_tax = lst_vbrp-kzwi6 + lv_tax.
        IF fp_st_inv_hdr-vbtyp IN r_crd
           AND lv_tax NE 0.
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
          CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
        ELSEIF lv_tax LT 0.
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst_final-tax_amount.
          CONDENSE lst_final-tax_amount.
        ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
          WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
          CONDENSE lst_final-tax_amount.
        ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
      ENDIF. " IF lst_final-tax_amount IS INITIAL

******       Final Amount
      lv_amnt = lst_vbrp-kzwi3 + lv_tax + lv_amnt.

      IF fp_st_inv_hdr-vbtyp IN r_crd "
        AND lv_amnt NE 0.
        WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
        CONCATENATE lc_minus lst_final-total INTO lst_final-total.
      ELSEIF lv_amnt LT 0.
        WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            value = lst_final-total.
      ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
        WRITE lv_amnt TO lst_final-total CURRENCY st_vbrk-waerk.
        CONDENSE lst_final-total.
      ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

******  Total Tax
    v_sales_tax    = lst_vbrp-kzwi6 + v_sales_tax.

    IF lst_final IS NOT INITIAL.
      APPEND lst_final TO fp_i_final.
      CLEAR lst_final.
    ENDIF. " IF lst_final IS NOT INITIAL

    lst_final-description = v_subs_type.
    IF lst_final IS NOT INITIAL
      AND lst_vbrp-uepos IS INITIAL.
      APPEND lst_final TO fp_i_final.
      CLEAR lst_final.
    ENDIF. " IF lst_final IS NOT INITIAL

    IF lst_vbrp-uepos IS INITIAL.
      CLEAR lst_mara.
      READ TABLE fp_i_mara INTO lst_mara WITH KEY matnr = lst_vbrp-matnr BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT fp_i_jptidcdassign INTO DATA(lst_jptidcdassign) WHERE matnr = lst_mara-matnr.
          IF lst_jptidcdassign-identcode IS NOT INITIAL.
            PERFORM f_read_text    USING lc_pntissn
                                CHANGING v_text_line.
            IF v_text_line IS NOT INITIAL.
              CONCATENATE v_text_line lst_jptidcdassign-identcode INTO lst_final-description SEPARATED BY space.
              APPEND lst_final TO fp_i_final.
              CLEAR lst_final.
            ENDIF. " IF v_text_line IS NOT INITIAL
          ENDIF. " IF lst_jptidcdassign-identcode IS NOT INITIAL
        ENDLOOP. " LOOP AT fp_i_jptidcdassign INTO DATA(lst_jptidcdassign) WHERE matnr = lst_mara-matnr
      ENDIF. " IF sy-subrc EQ 0

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
        ENDIF. " IF lst_vbrp-aland EQ lst_vbrp-lland
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lst_vbrp-uepos IS INITIAL

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
        APPEND lst_final TO fp_i_final.
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
  APPEND LINES OF li_final TO fp_i_final.

  LOOP AT li_inv_hdr INTO lst_inv_hdr.
    v_subtotal_val = v_subtotal_val + lst_inv_hdr-netwr.
  ENDLOOP.

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_inv_hdr-zlsch EQ 'J'.
    v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

  IF v_subtotal_val EQ 0.
    CLEAR v_paid_amt.
  ENDIF. " IF v_subtotal_val EQ 0
  WRITE v_paid_amt TO fp_v_prepaid_amount.
  CONDENSE fp_v_prepaid_amount.

* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.

  LOOP AT li_tax_item INTO lst_tax_item.

    lst_tax_item_final-media_type     = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.

    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.
    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_inv_hdr-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.

    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_inv_hdr-waerk.
    CONDENSE lst_tax_item_final-tax_amount.

    IF lst_tax_item-tax_amount IS NOT INITIAL.
      APPEND lst_tax_item_final TO i_tax_item.
      CLEAR lst_tax_item_final.
    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_adobe_print_layout_detail .

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

* Get Form Name
  PERFORM get_formname USING v_outputyp_detail
                    CHANGING lv_form_name.

  lst_sfpoutputparams-preview = abap_true.

  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = 'LP01'.
  lst_sfpoutputparams-copies    = 1.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = 'BBANDYOPAD'."nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = '1'."nast-tdarmod.
  lst_sfpoutputparams-reqimm    = abap_true."nast-dimme.
  lst_sfpoutputparams-reqdel    = abap_true."nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
  lst_sfpdocparams-langu     = 'E'."nast-spras.

* Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.

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
        im_v_reprint            = v_reprint
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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.

    ELSE. " ELSE -> IF sy-subrc <> 0
*     FM to close layout after printing
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

*******************LKODWANI******************
  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                 BINARY SEARCH.

  IF sy-subrc EQ 0.
    IF lst_adrc-deflt_comm = lc_deflt_comm_let.
*      AND st_header-bill_country = 'US'.
*      PERFORM f_save_pdf_applictn_server.
    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
  ENDIF. " IF sy-subrc EQ 0

*  post form processing
* IF lst_sfpoutputparams-arcmode <> '1'.
  IF lst_sfpoutputparams-arcmode <> '1' AND
     nast-nacha NE '1' AND                                "Print output
     lst_adrc-deflt_comm NE lc_deflt_comm_let.            "Letter
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
  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT_SUMMARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_layout_summary .

* Populate Header table
  PERFORM f_populate_detail_inv_header USING st_inv_hdr
                                             i_vbrp
                                             i_vbpa
                                             i_vbfa
                                             i_vbkd
                                             st_kna1
                                             i_pterms
                                             v_country_key
                                    CHANGING st_header.

* Populate Final item table
  PERFORM f_populate_detail_summ_item USING i_inv_hdr
                                            st_inv_hdr
                                            i_vbrp_cal
                                            v_paid_amt
                                   CHANGING i_final
                                            v_prepaid_amount
                                            i_subtotal.

* Fetch Invoice text
  PERFORM f_fetch_title_text USING st_inv_hdr
                          CHANGING st_header
                                   v_accmngd_title
                                   v_reprint
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

* For total due amount less than equal 0, title will be receipt
  IF v_totaldue_val LE 0.
    IF st_header-credit_flag IS INITIAL AND
       st_header-comp_code   NOT IN r_country.
*     Subroutine to fetch text value of receipt
      PERFORM f_read_text    USING c_name_receipt
                          CHANGING v_accmngd_title.
    ENDIF. " IF st_header-credit_flag IS INITIAL AND
*   Always dispaly 0 as total due for less than equal 0 amount
    CLEAR v_totaldue_val.
*    CLEAR: v_payment_detail, v_crdt_card_det.
    CLEAR: v_crdt_card_det.
    CLEAR: st_header-terms.
  ENDIF. " IF v_totaldue_val LE 0

* Get Email IDs
  PERFORM f_get_email USING st_header
                            i_email
                   CHANGING i_emailid.
*  Subroutine to print layout of summary invoice.
  PERFORM f_adobe_print_layout_summary.

* If email id is maintained, then send PDF as attachment to the mail address
  IF i_emailid[] IS NOT INITIAL.
    PERFORM f_send_mail_attach_summary.
  ENDIF. " IF i_emailid[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DETAIL_SUMM_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_INV_HDR  text
*      -->P_I_VBRP  text
*      -->P_V_PAID_AMT  text
*      <--P_I_FINAL  text
*      <--P_V_PREPAID_AMOUNT  text
*      <--P_I_SUBTOTAL  text
*----------------------------------------------------------------------*
FORM f_populate_detail_summ_item  USING fp_i_inv_hdr        TYPE tt_inv_data
                                        fp_st_inv_hdr       TYPE ty_inv_data
                                        fp_i_vbrp           TYPE tt_vbrp
                                        fp_v_paid_amt       TYPE autwr  " Payment cards: Authorized amount
                               CHANGING fp_i_final          TYPE ztqtc_item_detail_f024
                                        fp_v_prepaid_amount TYPE char20 " V_prepaid_amount of type CHAR20
                                        fp_i_subtotal       TYPE ztqtc_subtotal_f024.


* Data Declaration
  DATA : li_final     TYPE ztqtc_item_detail_f024,
         lst_knumv    TYPE ty_knumv,
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
            lc_digt_subsc TYPE thead-tdname VALUE 'ZQTC_DIGITAL_SUBSCRIPTION_F042',  " Name
            lc_prnt_subsc TYPE thead-tdname VALUE 'ZQTC_PRINT_SUBSCRIPTION_F042',    " Name
            lc_comb_subsc TYPE thead-tdname VALUE 'ZQTC_COMBINED_SUBSCRIPTION_F042'. " Name

  DATA(li_tax_data) = i_tax_data.
  SORT li_tax_data BY document doc_line_number.
  DELETE li_tax_data WHERE seller_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING seller_reg.

  DATA(li_tax_buyer) = i_tax_data.
  SORT li_tax_buyer BY document doc_line_number.
  DELETE li_tax_buyer WHERE buyer_reg IS INITIAL.
  DELETE ADJACENT DUPLICATES FROM li_tax_buyer COMPARING document doc_line_number buyer_reg.

  CONCATENATE lc_class
              lc_tax
              lc_devid
         INTO v_tax.

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

*******Fetch DATA from KONV table:Conditions (Transaction Data)
*  SELECT knumv, "Number of the document condition
*         kposn, "Condition item number
*         stunr, "Step number
*         zaehk, "Condition counter
*         kappl, " Application
*         kawrt, "Condition base value
*         kbetr, "Rate (condition amount or percentage)
*         kwert, "Condition value
*         kinak, "Condition is inactive
*         koaid  "Condition class
*    FROM konv   "Conditions (Transaction Data)
*    INTO TABLE @DATA(li_tkomv)
*    WHERE knumv = @fp_st_vbrk-knumv
*      AND kinak = ''.
**      AND   kposn = fp_st_vbap-posnr.
*      IF sy-subrc IS INITIAL.
*          SORT li_tkomv BY kposn.
*          DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
*          DELETE li_tkomv WHERE kbetr IS INITIAL.
*        ENDIF. " IF sy-subrc IS INITIAL
  DATA(li_inv_hdr) = fp_i_inv_hdr.
  DELETE li_inv_hdr WHERE inv_no NE fp_st_inv_hdr-inv_no.
  REFRESH r_knumv[].
  lst_knumv-sign   = 'I'.
  lst_knumv-option = 'EQ'.
  LOOP AT li_inv_hdr INTO DATA(lst_inv_hdr).
    lst_knumv-low = lst_inv_hdr-knumv.
    APPEND lst_knumv TO r_knumv.
    CLEAR : lst_knumv-low.
  ENDLOOP.
  DATA(li_tkomv) = i_tkomv.
  DELETE li_tkomv WHERE knumv NOT IN r_knumv[].
  SORT li_tkomv BY knumv kposn.
  DELETE li_tkomv WHERE koaid NE 'D' OR kappl NE 'TX'.
  DELETE li_tkomv WHERE kbetr IS INITIAL.


****************************DESCRIPTION********************************
***Begin of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
*** Subroutine used to get Journal text
**
***  PERFORM f_read_text    USING c_journal
***                      CHANGING v_journal.
**
**
***End of change by SRBOSE on 07-Aug-2017 CR_402 #TR: ED2K907591
****************************DESCRIPTION********************************
* Populate final table
  DATA(li_vbrp) = fp_i_vbrp[].
  LOOP AT fp_i_vbrp INTO DATA(lst_vbrp)." WHERE vbeln = fp_st_vbrk-vbeln.

*Begin of ADD:ERP-4743:WROY:09-OCT-2017:ED2K908785
*   Do Not consider Gross / Net Value for BOM Header
    READ TABLE fp_i_vbrp TRANSPORTING NO FIELDS
         WITH KEY vbeln = lst_vbrp-vbeln
                  uepos = lst_vbrp-posnr.
    IF sy-subrc EQ 0.
      CLEAR: lst_vbrp-kzwi1,
             lst_vbrp-kzwi2,
             lst_vbrp-kzwi3.
    ENDIF. " IF sy-subrc EQ 0

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
    ENDIF. " IF sy-subrc EQ 0
    READ TABLE li_vbrp INTO DATA(lst_vbrp_temp) WITH KEY vbeln = lst_vbrp-vbeln
                                                         posnr = lst_vbrp-posnr
                                                         uepos = lst_vbrp-posnr.
    IF sy-subrc NE 0.

****     Populate Subscription Type
      lst_tax_item-subs_type = lst_mara-ismmediatype.

****      Populate media type text
      lst_tax_item-media_type = v_text_line.

****      Populate taxable amount for NON BOM item
      lst_tax_item-taxable_amt = lst_vbrp-kzwi3.

****      Populate tax amount for Non BOM items
      lst_tax_item-tax_amount = lst_vbrp-kzwi6.
      READ TABLE li_inv_hdr INTO lst_inv_hdr WITH KEY vbeln = lst_vbrp-vbeln.
      IF sy-subrc EQ 0.
        READ TABLE li_tkomv INTO DATA(lst_komv) WITH KEY knumv = lst_inv_hdr-knumv
                                                         kposn = lst_vbrp-posnr
                                                BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          DATA(lv_index) = sy-tabix.
          LOOP AT li_tkomv INTO lst_komv FROM lv_index.
            IF lst_komv-knumv NE lst_inv_hdr-knumv AND
               lst_komv-kposn NE lst_vbrp-posnr.
              EXIT.
            ENDIF. " IF lst_komv-kposn NE lst_vbrp-posnr
            lv_kbetr = lv_kbetr + lst_komv-kbetr .
          ENDLOOP. " LOOP AT li_tkomv INTO lst_komv FROM lv_index
          lv_kbetr_new = ( lv_kbetr / 10 ).
          WRITE lv_kbetr_new TO lst_tax_item-tax_percentage.
          CONCATENATE lst_tax_item-tax_percentage lc_percent INTO lst_tax_item-tax_percentage.
          CONDENSE lst_tax_item-tax_percentage.
          CLEAR: lv_kbetr,lv_kbetr_new.
          COLLECT lst_tax_item INTO li_tax_item.
          CLEAR lst_tax_item.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF.
    ELSE. " ELSE -> IF sy-subrc NE 0
      DATA(lv_tabix_tmp) = sy-tabix.
      LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp.
        IF lst_vbrp_temp-vbeln NE lst_vbrp-vbeln AND
           lst_vbrp_temp-uepos NE lst_vbrp-posnr.
          EXIT.
        ENDIF. " IF lst_vbrp_temp-uepos NE lst_vbrp-posnr
        lv_tax = lv_tax + lst_vbrp-kzwi6.
        WRITE lv_tax TO lst_final-tax_amount.
        lst_tax_item-tax_amount = lv_tax.
      ENDLOOP. " LOOP AT li_vbrp INTO lst_vbrp_temp FROM lv_tabix_tmp
    ENDIF. " IF sy-subrc NE 0
****EOC by MODUTTA for CR# 666 on 18/10/12017

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

    lv_doc_line = lst_vbrp-posnr.
    READ TABLE li_tax_data INTO DATA(lst_tax_data) WITH KEY document = lst_vbrp-vbeln
                                                           doc_line_number = lv_doc_line
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0
       AND lst_tax_data-seller_reg IS NOT INITIAL.
      CONCATENATE lst_tax_data-seller_reg v_seller_reg INTO v_seller_reg SEPARATED BY space.
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
      ENDIF. " IF lst_vbrp-aland EQ lst_vbrp-lland
*   Buyer Reg
*      lv_buyer_reg = lst_tax_data-buyer_reg.
    ENDIF. " IF sy-subrc EQ 0

    CLEAR lst_vbrp.
  ENDLOOP. " LOOP AT fp_i_vbrp INTO DATA(lst_vbrp) WHERE vbeln = fp_st_vbrk-vbeln

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

***Subtotal
  lv_subtotal = lv_fees + lv_discount.

***Total
  lv_total = lv_subtotal + lv_tax.

  SET COUNTRY st_header-bill_country.
* Fees Value
  IF fp_st_inv_hdr-vbtyp IN r_crd
     AND lv_fees NE 0.
    WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk. " Fees
    CONDENSE lst_final-fees.

*    CONCATENATE lc_first lst_final-fees lc_second INTO lst_final-fees.
    CONCATENATE lc_minus lst_final-fees INTO lst_final-fees.

  ELSEIF lv_fees LT 0.

*    lv_fees = lv_fees * -1.
    WRITE lv_fees TO lst_final-fees CURRENCY st_vbrk-waerk. " Fees
    CONDENSE lst_final-fees.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_final-fees.
*    CONCATENATE lc_first lst_final-fees lc_second INTO lst_final-fees.
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    WRITE lv_fees TO lst_final-fees CURRENCY fp_st_inv_hdr-waerk. " Fees
    CONDENSE lst_final-fees.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Discount Value
  IF fp_st_inv_hdr-vbtyp IN r_crd.
    lv_discount = lv_discount * -1.
    WRITE lv_discount TO lst_final-discount CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-discount.

  ELSEIF lv_discount LT 0.
*** BOC BY SAYANDAS
*    lv_discount = lv_discount * -1.
    WRITE lv_discount TO lst_final-discount CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-discount.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_final-discount.
*    CONCATENATE lc_first lst_final-discount lc_second INTO lst_final-discount.
*** EOC BY SAYANDAS
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    WRITE lv_discount TO lst_final-discount CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-discount.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Subtotal
  LOOP AT li_inv_hdr INTO lst_inv_hdr.
    v_subtotal_val = v_subtotal_val + lst_inv_hdr-netwr.
  ENDLOOP.
* Tax
  v_sales_tax    = lv_tax.

* Tax Value
  IF fp_st_inv_hdr-vbtyp IN r_crd
       AND lv_tax NE 0.
    WRITE lv_tax TO lst_final-tax_amount CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-tax_amount.
*** BOC BY SAYANDAS
*    CONCATENATE lc_first lst_final-tax_amount lc_second INTO lst_final-tax_amount.
    CONCATENATE lc_minus lst_final-tax_amount INTO lst_final-tax_amount.
*** EOC BY SAYANDAS
  ELSEIF lv_tax LT 0.
*** BOC BY SAYANDAS
*    lv_tax = lv_tax * -1.
    WRITE lv_tax TO lst_final-tax_amount CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-tax_amount.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_final-tax_amount.

*    CONCATENATE lc_first lst_final-tax_amount lc_second INTO lst_final-tax_amount.
*** EOC BY SAYANDAS
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    WRITE lv_tax TO lst_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-tax_amount.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* Total Value
  IF fp_st_inv_hdr-vbtyp IN r_crd " (++) PBOSE: 05-June-2017: DEFECT 2516: ED2K906208
   AND lv_total NE 0.
    WRITE lv_total TO lst_final-total CURRENCY fp_st_inv_hdr-waerk. " Total
    CONDENSE lst_final-total.
*** BOC BY SAYANDAS
*    CONCATENATE lc_first lst_final-total lc_second INTO lst_final-total.
    CONCATENATE lc_minus lst_final-total INTO lst_final-total.
*** EOC BY SAYANDAS
  ELSEIF lv_total LT 0.
*** BOC BY SAYNDAS
*    lv_total = lv_total * -1.
    WRITE lv_total TO lst_final-total CURRENCY fp_st_inv_hdr-waerk. " Total
    CONDENSE lst_final-total.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_final-total.

*    CONCATENATE lc_first lst_final-total lc_second INTO lst_final-total.
*** EOC BY SAYANDAS
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    WRITE lv_total TO lst_final-total CURRENCY st_vbrk-waerk. " Total
    CONDENSE lst_final-total.
  ENDIF. " IF fp_st_vbrk-vbtyp IN r_crd

* SubTotal Value
  IF fp_st_inv_hdr-vbtyp IN r_crd
      AND lv_subtotal NE 0.
    WRITE lv_subtotal TO lst_final-sub_total CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-sub_total.
*** BOC BY SAYANDAS
*    CONCATENATE lc_first lst_final-sub_total lc_second INTO lst_final-sub_total.
    CONCATENATE lc_minus lst_final-sub_total INTO lst_final-sub_total.
*** EOC BY SAYANDAS
  ELSEIF lv_subtotal LT 0.
*** BOC BY SAYANDAS
*    lv_subtotal = lv_subtotal * -1.
    WRITE lv_subtotal TO lst_final-sub_total CURRENCY fp_st_inv_hdr-waerk.
    CONDENSE lst_final-sub_total.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = lst_final-sub_total.

*    CONCATENATE lc_first lst_final-sub_total lc_second INTO lst_final-sub_total.
*** EOC BY SAYANDAS
  ELSE. " ELSE -> IF fp_st_vbrk-vbtyp IN r_crd
    WRITE lv_subtotal TO lst_final-sub_total CURRENCY st_vbrk-waerk.
    CONDENSE lst_final-sub_total.
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

*****Populate Year for CR#666
  IF lst_mara-ismyearnr NE 0.
*          CONCATENATE lv_year lst_mara-ismyearnr INTO lst_final_tbt-issue_year SEPARATED BY space.
    CONCATENATE text-001 lst_mara-ismyearnr INTO lst_final-description SEPARATED BY space.
*          CONDENSE lst_final_tbt-issue_year.
    CONDENSE lst_final-description.
    APPEND lst_final TO fp_i_final.
  ENDIF. " IF lst_mara-ismyearnr NE 0

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

* If Payment method is J (DE, UK), then prepaid amount is total invoice amount
  IF st_vbrk-zlsch EQ 'J'.
    v_paid_amt = v_subtotal_val + v_sales_tax.
  ENDIF. " IF st_vbrk-zlsch EQ 'J'

  IF v_subtotal_val EQ 0.
    CLEAR v_paid_amt.
  ENDIF. " IF v_subtotal_val EQ 0
  WRITE v_paid_amt TO fp_v_prepaid_amount CURRENCY st_vbrk-waerk.
  CONDENSE fp_v_prepaid_amount.

* Total due amount
  v_totaldue_val = ( v_subtotal_val + v_sales_tax ) - fp_v_paid_amt.

  LOOP AT li_tax_item INTO lst_tax_item.
    lst_tax_item_final-media_type     = lst_tax_item-media_type.
    lst_tax_item_final-tax_percentage = lst_tax_item-tax_percentage.
    CONCATENATE lst_tax_item_final-tax_percentage '=' INTO lst_tax_item_final-tax_percentage.

    WRITE lst_tax_item-taxable_amt TO lst_tax_item_final-taxabl_amt CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-taxabl_amt.
    CONCATENATE lst_tax_item_final-taxabl_amt '@' INTO lst_tax_item_final-taxabl_amt.
    WRITE lst_tax_item-tax_amount TO lst_tax_item_final-tax_amount CURRENCY st_vbrk-waerk.
    CONDENSE lst_tax_item_final-tax_amount.
    IF lst_tax_item-tax_amount IS NOT INITIAL.
      APPEND lst_tax_item_final TO i_tax_item.
      CLEAR lst_tax_item_final.
    ENDIF. " IF lst_tax_item-tax_amount IS NOT INITIAL
  ENDLOOP. " LOOP AT li_tax_item INTO lst_tax_item

* Clear local variable
  CLEAR : lst_final,
          lv_due,
          lv_tax,
          lv_discount,
          lv_subtotal,
          lv_total.

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
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRINT_LAYOUT_SUMMARY
*&---------------------------------------------------------------------*
*       text
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
  CONSTANTS: lc_form_name      TYPE fpname VALUE 'ZQTC_FRM_INV_SUMMARY_MNGD_F024', " Name of Form Object
             lc_deflt_comm_let TYPE ad_comm VALUE 'LET'.
  " Communication Method (Key) (Business Address Services)
* Get Form Name
  PERFORM get_formname USING v_outputyp_summary
                    CHANGING lv_form_name.

  lst_sfpoutputparams-preview = abap_true.

  IF NOT v_ent_screen IS INITIAL.
    lst_sfpoutputparams-noprint   = abap_true.
    lst_sfpoutputparams-nopributt = abap_true.
    lst_sfpoutputparams-noarchive = abap_true.
  ENDIF. " IF NOT v_ent_screen IS INITIAL
  IF v_ent_screen     = 'X'.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = 'W'. "Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'
  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = 'LP01'.
  lst_sfpoutputparams-copies    = 1.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = 'BBANDYOPAD'."nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = '1'."nast-tdarmod.
  lst_sfpoutputparams-reqimm    = abap_true."nast-dimme.
  lst_sfpoutputparams-reqdel    = abap_true."nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

*--- Set language and default language
  lst_sfpdocparams-langu     = sy-langu."nast-spras.

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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0

*  READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
*                                                 BINARY SEARCH.
*
*  IF sy-subrc EQ 0.
*    IF lst_adrc-deflt_comm = lc_deflt_comm_let.
**      AND st_header-bill_country = 'US'.
*      PERFORM f_save_pdf_applictn_server.
*    ENDIF. " IF lst_adrc-deflt_comm = lc_deflt_comm_let
*  ENDIF. " IF sy-subrc EQ 0

**  post form processing
*  IF lst_sfpoutputparams-arcmode <> '1' AND
*     nast-nacha NE '1' AND                                "Print output
*     lst_adrc-deflt_comm NE lc_deflt_comm_let.            "Letter
*    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
*      EXPORTING
*        documentclass            = 'PDF' "  class
*        document                 = st_formoutput-pdf
*      TABLES
*        arc_i_tab                = lst_sfpdocparams-daratab
*      EXCEPTIONS
*        error_archiv             = 1
*        error_communicationtable = 2
*        error_connectiontable    = 3
*        error_kernel             = 4
*        error_parameter          = 5
*        error_format             = 6
*        OTHERS                   = 7.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
*              RAISING system_error.
*    ELSE. " ELSE -> IF sy-subrc <> 0
**     Check if the subroutine is called in update task.
*      CALL METHOD cl_system_transaction_state=>get_in_update_task
*        RECEIVING
*          in_update_task = lv_upd_tsk.
**     COMMINT only if the subroutine is not called in update task
*      IF lv_upd_tsk EQ 0.
*        COMMIT WORK.
*      ENDIF. " IF lv_upd_tsk EQ 0
*    ENDIF. " IF sy-subrc <> 0
*  ENDIF. " IF lst_sfpoutputparams-arcmode <> '1'

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FORMNAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_OUTPUTYP_SUMMARY  text
*      <--P_LV_FORM_NAME  text
*----------------------------------------------------------------------*
FORM get_formname  USING fp_v_outputyp   TYPE sna_kschl
                CHANGING fp_lv_form_name TYPE fpname.
  CONSTANTS : lc_med  TYPE na_nacha VALUE '1',
              lc_appl TYPE kappl    VALUE 'V3'.

  SELECT SINGLE sform
           INTO fp_lv_form_name
           FROM tnapr
          WHERE kschl = fp_v_outputyp.
*            AND nacha = lc_med
*            AND kappl = lc_appl.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAILID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_VBPA  text
*      <--P_I_EMAILID  text
*----------------------------------------------------------------------*
FORM f_get_emailid  USING fp_i_vbpa    TYPE tt_vbpa
                 CHANGING fp_i_email TYPE tt_email.

  CONSTANTS : lc_bp      TYPE parvw VALUE 'RE'. " Partner Function

  DATA(li_vbpa) = fp_i_vbpa.

  DELETE li_vbpa WHERE parvw NE lc_bp.

  SORT li_vbpa BY adrnr.
  DELETE ADJACENT DUPLICATES FROM li_vbpa COMPARING adrnr.
  DELETE li_vbpa WHERE adrnr IS INITIAL  .
  IF li_vbpa IS NOT INITIAL.
*   fetch email id from adr6.
    SELECT addrnumber " Address number
           persnumber " Person number
           smtp_addr  " E-Mail Address
           valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
           valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
      FROM adr6       " E-Mail Addresses (Business Address Services)
      INTO TABLE fp_i_email
      FOR ALL ENTRIES IN li_vbpa
     WHERE addrnumber EQ li_vbpa-adrnr.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_HEADER  text
*      -->P_I_EMAIL  text
*      <--P_I_EMAILID  text
*----------------------------------------------------------------------*
FORM f_get_email  USING fp_st_header TYPE zstqtc_header_detail_f024
                        fp_i_email   TYPE tt_email
               CHANGING fp_i_emailid TYPE tt_emailid.

  DATA : lv_current_date         TYPE ad_valfrom.

  CONSTANTS : lc_timstmp    TYPE char6      VALUE '000000',         " Timstmp of type CHAR6
              lc_validfrm   TYPE ad_valfrom VALUE '19000101000000', " Communication Data: Valid From (YYYYMMDDHHMMSS)
              lc_validto    TYPE ad_valto   VALUE '99991231235959', " Communication Data: Valid To (YYYYMMDDHHMMSS)
              lc_deflt_comm TYPE ad_comm VALUE 'LET'.               " Communication Method (Key) (Business Address Services)

  SORT fp_i_email  BY addrnumber.

  READ TABLE fp_i_email INTO st_email WITH KEY addrnumber = fp_st_header-bill_addr_number
                                      BINARY SEARCH.
  IF sy-subrc EQ 0.
    READ TABLE i_adrc INTO DATA(lst_adrc) WITH KEY  addrnumber = st_header-bill_addr_number
                                                     BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_comm_meth) = lst_adrc-deflt_comm.
    ENDIF. " IF sy-subrc EQ 0

    IF lv_comm_meth NE lc_deflt_comm
      AND fp_i_email IS NOT INITIAL.

      st_email-valid_from = lc_validfrm.
      MODIFY fp_i_email FROM st_email TRANSPORTING valid_from
       WHERE valid_from IS INITIAL.

      st_email-valid_to   = lc_validto.
      MODIFY fp_i_email FROM st_email TRANSPORTING valid_to
       WHERE valid_to IS INITIAL.

      CONCATENATE sy-datum
                  lc_timstmp
             INTO lv_current_date.
      DELETE fp_i_email WHERE valid_from GT lv_current_date
                         OR valid_to   LT lv_current_date.

* Get email address in table
      REFRESH fp_i_emailid.
      LOOP AT fp_i_email INTO st_email.
        st_emailid-smtp_addr = st_email-smtp_addr.
        APPEND st_emailid TO fp_i_emailid.
        CLEAR st_emailid.
      ENDLOOP. " LOOP AT li_email INTO lst_email
    ENDIF. " IF lv_comm_meth NE lc_deflt_comm
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH_SUMMARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_mail_attach_summary .


* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname   VALUE 'ZQTC_FRM_INV_SUMMARY_MNGD_F024', " Name of Form Object
             lc_msgnr_165 TYPE sy-msgno VALUE '165',                            " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',                            " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2',                        " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.                              " ABAP System Field: Message Type

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
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb              = lc_msgid
        msg_nr                 = lc_msgnr_165
        msg_ty                 = lc_err
        msg_v1                 = lv_msgv_formnm
      EXCEPTIONS
        message_type_not_valid = 1
        no_sy_message          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = lc_msgid
          msg_nr                 = lc_msgnr_165
          msg_ty                 = lc_err
          msg_v1                 = lv_msgv_formnm
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.

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
            msg_arbgb              = lc_msgid
            msg_nr                 = lc_msgnr_165
            msg_ty                 = lc_err
            msg_v1                 = lv_msgv_formnm
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.

      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF sy-subrc IS NOT INITIAL

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.

* Subroutine to send mail attachment
  PERFORM f_mail_attachment.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_TO_BINARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_convert_pdf_to_binary .

**CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = st_formoutput-pdf
    TABLES
      binary_tab = i_content_hex.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mail_attachment .

* Data declaration
  DATA : lr_sender  TYPE REF TO if_sender_bcs VALUE IS INITIAL, " Interface of Sender Object in BCS
         lv_send    TYPE adr6-smtp_addr,                        " E-Mail Address
         lv_sub     TYPE char30,                                " Sub of type CHAR15
         lv_subject TYPE so_obj_des,                            " Short description of contents
         li_lines   TYPE STANDARD TABLE OF tline,               " SAPscript: Text Lines
         t_hex      TYPE solix_tab,
         lst_lines  TYPE tline,                                 " SAPscript: Text Lines
         lv_upd_tsk TYPE i, " Upd_tsk of type Integers
         lv_title   TYPE char255. " Title of type CHAR255

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
  CONCATENATE 'Wiley'(s01) lv_sub INTO lv_sub SEPARATED BY space.

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

*   Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
*   COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0
  ENDIF. " IF i_emailid[] IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH_CONSORTIA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_mail_attach_consortia .

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lv_form_name        TYPE fpname,                      " Name of Form Object
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
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb              = lc_msgid
        msg_nr                 = lc_msgnr_165
        msg_ty                 = lc_err
        msg_v1                 = lv_msgv_formnm
      EXCEPTIONS
        message_type_not_valid = 1
        no_sy_message          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = lc_msgid
          msg_nr                 = lc_msgnr_165
          msg_ty                 = lc_err
          msg_v1                 = lv_msgv_formnm
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.

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
            msg_arbgb              = lc_msgid
            msg_nr                 = lc_msgnr_165
            msg_ty                 = lc_err
            msg_v1                 = lv_msgv_formnm
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.

      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.
* Subroutine to send mail attachment
  PERFORM f_mail_attachment.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_MAIL_ATTACH_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_mail_attach_detail .

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lv_msgv_formnm      TYPE syst_msgv,                   " Message Variable
        lv_form_name        TYPE fpname,                      " Name of Form Object
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lr_err_usg          TYPE REF TO cx_fp_api_usage.      " Exception API (Use)

****Local Constant declaration
  CONSTANTS: lc_form_name TYPE fpname VALUE 'ZQTC_FRM_INV_MNGD_DETAIL_F024', " Name of Form Object
             lc_msgnr_165 TYPE sy-msgno VALUE '165',                         " ABAP System Field: Message Number
             lc_msgnr_166 TYPE sy-msgno VALUE '166',                         " ABAP System Field: Message Number
             lc_msgid     TYPE sy-msgid VALUE 'ZQTC_R2',                     " ABAP System Field: Message ID
             lc_err       TYPE sy-msgty VALUE 'E'.                           " ABAP System Field: Message Type

  lv_form_name = tnapr-sform.
  lv_msgv_formnm = tnapr-sform. " PBANDLAPAL
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
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb              = lc_msgid
        msg_nr                 = lc_msgnr_165
        msg_ty                 = lc_err
        msg_v1                 = lv_msgv_formnm
      EXCEPTIONS
        message_type_not_valid = 1
        no_sy_message          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

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
    CALL FUNCTION lv_funcname
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
      IMPORTING
        /1bcdwb/formoutput      = st_formoutput
      EXCEPTIONS
        usage_error             = 1
        system_error            = 2
        internal_error          = 3
        OTHERS                  = 4.

    IF sy-subrc <> 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = lc_msgid
          msg_nr                 = lc_msgnr_165
          msg_ty                 = lc_err
          msg_v1                 = lv_msgv_formnm
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.

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
            msg_arbgb              = lc_msgid
            msg_nr                 = lc_msgnr_165
            msg_ty                 = lc_err
            msg_v1                 = lv_msgv_formnm
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.

      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc IS NOT INITIAL

* Subroutine to convert PDF to binary
  PERFORM f_convert_pdf_to_binary.
* Subroutine to send layout in mail attachment
  PERFORM f_mail_attachment.


ENDFORM.
