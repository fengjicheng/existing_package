*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_AUTOMATED_LOCKBOX_E097
* REPORT DESCRIPTION:    Include for subroutines
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         31/07/2017
* OBJECT ID:             E097(CR# 436)
* TRANSPORT NUMBER(S):   ED2K907624(W)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910314
* REFERENCE NO: ERP-5249
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:      15/01/2018
* DESCRIPTION: Updating the VKDFS-FKDAT along with FPLT-FKDAT to update
*              billing Plan in order correctly.
*----------------------------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_AUTOMATED_LOCKBOX_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate default values in selection screen
*----------------------------------------------------------------------*
*      <--FP_S_AUGDT[]  Selection screen range for clearing date
*      <--FP_S_UMSKZ[]  Selection screen range for G/L indicator
*      <--FP_S_BLART[]  Selection screen range for document type
*      <--FP_S_FKART[]  Selection screen range for billing type
*----------------------------------------------------------------------*
FORM f_populate_defaults  USING fp_i_constant TYPE tt_constant
                          CHANGING fp_s_augdt TYPE tt_augdt
                                   fp_s_umskz TYPE fiappt_t_gl_range
                                   fp_s_blart TYPE hrpp_sel_blart
                                   fp_s_fkart TYPE j_3rs_so_invoice_sd.

*  Local constant declaration
  CONSTANTS: lc_umskz TYPE rvari_vnam VALUE 'UMSKZ', " ABAP: Name of Variant Variable
             lc_fkart TYPE rvari_vnam VALUE 'FKART', " ABAP: Name of Variant Variable
             lc_blart TYPE rvari_vnam VALUE 'BLART'. " ABAP: Name of Variant Variable

* Local data declaration
  DATA: lst_umskz TYPE fiappt_s_gl_range, " Structure for Special G/L
        lst_augdt TYPE ty_augdt,          " Structure for clearing date
        lst_blart TYPE hrpp_sel_st_blart, " Select-Option for "Document Typeelegart" (Structure)
        lst_fkart TYPE j_3rsoinvoice_sd.  " Select-options for J_3RSINVOICE

* Populate selection screen range for Clearing date
  lst_augdt-sign   = c_sign_incld. "Sign: (I)nclude
  lst_augdt-option = c_opti_equal. "Option: (EQ)ual
  DATA(lv_prev_date) = sy-datum - 7.
  lst_augdt-low = lv_prev_date.
  lst_augdt-high = sy-datum.
  APPEND lst_augdt TO fp_s_augdt.
  CLEAR lst_augdt.

* Populate selection screen fields
  LOOP AT fp_i_constant INTO DATA(lst_constant).
    CASE lst_constant-param1.
      WHEN lc_umskz.
        lst_umskz-sign = lst_constant-sign.
        lst_umskz-option = lst_constant-opti.
        lst_umskz-low = lst_constant-low.
        APPEND lst_umskz TO fp_s_umskz.
        CLEAR lst_umskz.
      WHEN lc_fkart.
        lst_fkart-sign = lst_constant-sign.
        lst_fkart-option = lst_constant-opti.
        lst_fkart-low = lst_constant-low.
        APPEND lst_fkart TO fp_s_fkart.
        CLEAR lst_fkart.
      WHEN lc_blart.
        lst_blart-sign = lst_constant-sign.
        lst_blart-option = lst_constant-opti.
        lst_blart-low = lst_constant-low.
        APPEND lst_blart TO fp_s_blart.
        CLEAR lst_blart.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP. " LOOP AT fp_i_constant INTO DATA(lst_constant)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       Fetch constant table records
*----------------------------------------------------------------------*
*      <--FP_I_CONSTANT  internal table for ZCACONSTANT
*----------------------------------------------------------------------*
FORM f_get_constants  CHANGING fp_i_constant TYPE tt_constant.
  CONSTANTS:  lc_devid  TYPE zdevid VALUE 'E097'. " Development ID

  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constant
    WHERE devid = lc_devid.
  IF sy-subrc EQ 0.
    SORT fp_i_constant BY param1.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_AUGDT
*&---------------------------------------------------------------------*
*      Validation of special G/L indicator
*----------------------------------------------------------------------*
*      -->FP_S_UMSKZ  Selection screen field for G/L indicator
*----------------------------------------------------------------------*
FORM f_validate_umskz  USING  fp_s_umskz TYPE fiappt_t_gl_range.
  SELECT umskz " Special G/L Indicator
    FROM t074u " Special G/L Indicator Properties
    UP TO 1 ROWS
    INTO @DATA(lv_umskz)
    WHERE umskz IN @fp_s_umskz.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e229(zqtc_r2). " Invalid special G/L indicator
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BUKRS
*&---------------------------------------------------------------------*
*       Validate company code
*----------------------------------------------------------------------*
*      -->FP_S_BUKRS[]  Selection screen field for company code
*----------------------------------------------------------------------*
FORM f_validate_bukrs  USING    fp_s_bukrs TYPE  wrf_pbas_bukrs_rtty.
  SELECT bukrs " Company Code
    FROM t001  " Company Codes
    UP TO 1 ROWS
    INTO @DATA(lv_bukrs)
    WHERE bukrs IN @fp_s_bukrs.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e041(zqtc_r2). " Invalid Company Code
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BLART
*&---------------------------------------------------------------------*
*       Validate document type
*----------------------------------------------------------------------*
*      -->FP_S_BLART[]  Selection screen for docmuent type
*----------------------------------------------------------------------*
FORM f_validate_blart  USING    fp_s_blart TYPE hrpp_sel_blart.
  SELECT blart " Document Type
    FROM t003  " Document Types
    UP TO 1 ROWS
    INTO @DATA(lv_blart)
    WHERE blart IN @fp_s_blart.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e212(zqtc_r2). " Invalid Document Type
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FKART
*&---------------------------------------------------------------------*
*       Validate billing type
*----------------------------------------------------------------------*
*      -->FP_S_FKART[]  Selection screen field for billing type
*----------------------------------------------------------------------*
FORM f_validate_fkart  USING    fp_s_fkart TYPE j_3rs_so_invoice_sd.
  SELECT fkart " Billing Type
    FROM tvfk  " Billing: Document Types
    UP TO 1 ROWS
    INTO @DATA(lv_fkart)
    WHERE fkart IN @fp_s_fkart.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e022(zqtc_r2). " Sales Rep-1 is a mandatory field!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL_TAB
*&---------------------------------------------------------------------*
*       Populate final table
*----------------------------------------------------------------------*
*      -->FP_I_FINAL_TAB  Final table
*----------------------------------------------------------------------*
FORM f_populate_final_tab  USING    fp_i_final_tab TYPE tt_final.

*  Local constant declaration
  CONSTANTS: lc_fksaa TYPE rvari_vnam VALUE 'FKSAA'. " ABAP: Name of Variant Variable

*   Local data declaration
  DATA: li_vbak_keys  TYPE shp_sales_key_t, "Document numbers to be selected
        li_xfplt      TYPE va_fpltvb_t,     "Billing Plan: Dates
        li_xfpla      TYPE va_fplavb_t,     "Billing Plan
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
        li_sales_doc  TYPE range_vbeln_va_tab,
        li_delv_doc   TYPE msr_t_insp_vbeln_vl_range,
        li_bill_doc   TYPE range_vbeln_va_tab,
        lv_err_bldat  TYPE char1,           " Error flag for Bill Plan date
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
        lst_final_tab TYPE ty_final,
        lv_document   TYPE xref1,           " Business Partner Reference Key
        lst_sls_view  TYPE order_view.      "View for Mass Selection of Sales Orders

  SELECT bukrs, " Company Code
         augdt, " Clearing Document
         augbl, " Docuent Number
         gjahr, " Fiscal Year
         belnr, " Accounting Doc Number
         xref1  " Business Partner Reference Key
    FROM bsad   " Accounting: Secondary Index for Customers (Cleared Items)
    INTO TABLE @DATA(li_bsad)
    WHERE bukrs IN @s_bukrs
    AND   umskz IN @s_umskz
    AND   augdt IN @s_augdt
    AND   blart IN @s_blart.
  IF sy-subrc EQ 0.
    SORT li_bsad BY xref1.
    DELETE ADJACENT DUPLICATES FROM li_bsad COMPARING xref1.

*    Get FKSAA value from ZCACONSTANT
    READ TABLE i_constant INTO DATA(lst_constant) WITH KEY param1 = lc_fksaa
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_fksaa) = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

    SELECT c~vbeln, " Billing document
           c~posnr, " Billing item
           a~vbeln AS document,
           a~aubel, " Sales Document
           a~aupos  " Sales Document Item
      FROM vbrp AS a
      INNER JOIN vbrk AS b ON a~vbeln = b~vbeln
      INNER JOIN vbup AS c ON ( a~aubel = c~vbeln AND a~aupos = c~posnr )
      INTO TABLE @DATA(li_vbrp_vbrk)
      FOR ALL ENTRIES IN @li_bsad
      WHERE a~vbeln = @li_bsad-xref1+0(10)
      AND   b~fkart IN @s_fkart
      AND   c~fksaa <> @lv_fksaa.
    IF sy-subrc EQ 0.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
*      SORT li_vbrp_vbrk BY aubel aupos.
      SORT li_vbrp_vbrk BY vbeln posnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

*  Update FPLT-AFDAT
  IF li_vbrp_vbrk IS NOT INITIAL.
* View for Mass Selection of Sales Orders
    lst_sls_view-billplan   = abap_true.

    LOOP AT li_vbrp_vbrk ASSIGNING FIELD-SYMBOL(<lst_vbrp_vbrk>).
      lv_document = <lst_vbrp_vbrk>-document.
      READ TABLE li_bsad ASSIGNING FIELD-SYMBOL(<lst_bsad>) WITH KEY xref1 = lv_document
                                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_final_tab-bukrs  = <lst_bsad>-bukrs.
        lst_final_tab-augdt  = <lst_bsad>-augdt.
        lst_final_tab-augbl  = <lst_bsad>-augbl.
        lst_final_tab-gjahr  = <lst_bsad>-gjahr.
        lst_final_tab-belnr  = <lst_bsad>-belnr.
        lst_final_tab-xref1  = <lst_bsad>-xref1.
      ENDIF. " IF sy-subrc EQ 0
      lst_final_tab-aubel  = <lst_vbrp_vbrk>-aubel.
      lst_final_tab-aupos  = <lst_vbrp_vbrk>-aupos.

* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
      READ TABLE li_vbak_keys TRANSPORTING NO FIELDS WITH KEY vbeln = <lst_vbrp_vbrk>-vbeln
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
*     Document numbers to be selected
        APPEND INITIAL LINE TO li_vbak_keys ASSIGNING FIELD-SYMBOL(<lst_vbak_key>).
        <lst_vbak_key>-vbeln   = <lst_vbrp_vbrk>-vbeln.

        APPEND INITIAL LINE TO li_sales_doc ASSIGNING FIELD-SYMBOL(<lst_sales_doc>).
        <lst_sales_doc>-sign   = c_sign_incld.
        <lst_sales_doc>-option = c_opti_equal.
        <lst_sales_doc>-low    = <lst_vbrp_vbrk>-vbeln.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
      ENDIF.
      AT END OF vbeln.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
*     Prefetch Sales Document Details
        CALL FUNCTION 'SD_SALES_DOCUMENT_PREFETCH'
          EXPORTING
            i_sales_view  = lst_sls_view "View for Mass Selection of Sales Orders
          TABLES
            i_vbak_keytab = li_vbak_keys "Document numbers to be selected
            fxfpla        = li_xfpla
            fxfplt        = li_xfplt.    "Billing Plan: Dates

        IF li_xfplt IS NOT INITIAL.
          DATA(li_xfplt_old) = li_xfplt[].
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
          DELETE li_xfplt WHERE fkarv IN s_fkart.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
          LOOP AT li_xfplt ASSIGNING FIELD-SYMBOL(<lst_xfplt>).

            IF <lst_xfplt>-afdat = lst_final_tab-augdt.
              MESSAGE e231(zqtc_r2) INTO lst_final_tab-message. " Order Item Billing Plan Date not updated
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
              lv_err_bldat  = abap_true.
              EXIT.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
            ELSE.
              <lst_xfplt>-afdat = lst_final_tab-augdt.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
              <lst_xfplt>-fkdat = lst_final_tab-augdt.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
              <lst_xfplt>-updkz = 'U'. "Update
              MESSAGE s230(zqtc_r2) INTO lst_final_tab-message. " Order Item Billing Plan Date updated successfully
            ENDIF.
          ENDLOOP. " LOOP AT li_xfplt ASSIGNING FIELD-SYMBOL(<lst_xfplt>)

* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
          IF lv_err_bldat IS INITIAL.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
            CALL FUNCTION 'BILLING_SCHEDULE_SAVE'
              TABLES
                fpla_new = li_xfpla
                fpla_old = li_xfpla
                fplt_new = li_xfplt
                fplt_old = li_xfplt_old.

*          Save the billing plan date
            CALL FUNCTION 'SD_SALES_DOCUMENT_SAVE'
              EXPORTING
                i_no_messages = ' '.
*          Commit
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
            IF sy-subrc EQ 0.
              MODIFY fp_i_final_tab FROM lst_final_tab TRANSPORTING message
                                                       WHERE aubel = lst_final_tab-aubel.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
              CALL FUNCTION 'RV_INDEX_REORG'
                EXPORTING
                  vkdfs_correct = abap_true
                TABLES
                  i_a           = li_sales_doc
                  i_l           = li_delv_doc
                  i_f           = li_bill_doc.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
            ENDIF.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
          ELSE.
            MODIFY fp_i_final_tab FROM lst_final_tab TRANSPORTING message
                                                     WHERE aubel = lst_final_tab-aubel.
            CLEAR lv_err_bldat.
          ENDIF.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
        ENDIF. " IF li_xfplt IS NOT INITIAL
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
        CLEAR: li_sales_doc,
               li_vbak_keys,
               li_xfpla,
               li_xfplt,
               li_xfplt_old.
      ENDAT.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5249: ED2K910314
      APPEND lst_final_tab TO fp_i_final_tab.
      CLEAR lst_final_tab.

    ENDLOOP. " LOOP AT li_vbrp_vbrk ASSIGNING FIELD-SYMBOL(<lst_vbrp_vbrk>)
  ENDIF. " IF li_vbrp_vbrk IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       Display ALV
*----------------------------------------------------------------------*
*      -->FP_I_FINAL_TAB  Final table
*----------------------------------------------------------------------*
FORM f_display_output  USING  fp_i_final_tab TYPE tt_final.
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lst_layout       TYPE slis_layout_alv,
        li_fieldcatalog  TYPE slis_t_fieldcat_alv.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'BUKRS'.
  lst_fieldcatalog-seltext_l  = 'Company Code'(t01).
  lst_fieldcatalog-col_pos     = 0.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'GJAHR'.
  lst_fieldcatalog-seltext_l  = 'Fiscal Year'(t02).
  lst_fieldcatalog-col_pos     = 1.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'BELNR'.
  lst_fieldcatalog-seltext_l   = 'Accounting Document Number'(t03).
  lst_fieldcatalog-col_pos     = 2.
  lst_fieldcatalog-outputlen = 14.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'AUGBL'.
  lst_fieldcatalog-seltext_l   = 'Document Number of the Clearing Document'(t04).
  lst_fieldcatalog-col_pos     = 3.
  lst_fieldcatalog-outputlen = 14.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'AUGDT'.
  lst_fieldcatalog-seltext_l   = 'Clearing Date'(t05).
  lst_fieldcatalog-col_pos     = 4.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'XREF1'.
  lst_fieldcatalog-seltext_l   = 'Billing Document'(t06).
  lst_fieldcatalog-col_pos     = 5.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'AUBEL'.
  lst_fieldcatalog-seltext_l   = 'Sales Document'(t07).
  lst_fieldcatalog-col_pos     = 7.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'AUPOS'.
  lst_fieldcatalog-seltext_l  = 'Sales Document Item'(t08).
  lst_fieldcatalog-col_pos     = 8.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_l   = 'Message'(t09).
  lst_fieldcatalog-col_pos     = 9.
  lst_fieldcatalog-outputlen = 100.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = li_fieldcatalog
    TABLES
      t_outtab           = fp_i_final_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR li_fieldcatalog[].
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
