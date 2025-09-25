*----------------------------------------------------------------------*
***INCLUDE LZQTC_GET_FORM_LOGO_NAMEF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RANGE_PARVW
*&---------------------------------------------------------------------*
*   Populate Partner function details
*----------------------------------------------------------------------*
*      -->fp_LC_SP       Partner function
*      <--fp_LIR_PARVW   Partner function table
*----------------------------------------------------------------------*
FORM f_populate_range_parvw  USING    fp_lc_parvw TYPE   parvw " Partner Function
                             CHANGING fp_lir_parvw TYPE tt_parvw_r.

  DATA : lst_parvw TYPE LINE OF tt_parvw_r.

  lst_parvw-sign   = c_i.
  lst_parvw-option = c_eq.
  lst_parvw-low    = fp_lc_parvw.
  APPEND lst_parvw TO fp_lir_parvw.
  CLEAR lst_parvw.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RANGE_KUNNR
*&---------------------------------------------------------------------*
*      Populate range table for customer
*----------------------------------------------------------------------*
*      -->fp_LV_SOLD_TO   Sold to party
*      <--fp_LIR_KUNNR    Customer
*----------------------------------------------------------------------*
FORM f_populate_range_kunnr  USING    fp_kunnr     TYPE kunnr " Customer Number
                             CHANGING fp_lir_kunnr TYPE tt_kunnr_r.

  DATA : lst_kunnr TYPE LINE OF tt_kunnr_r.

  lst_kunnr-sign   = c_i.
  lst_kunnr-option = c_eq.
  lst_kunnr-low    = fp_kunnr.
  APPEND lst_kunnr TO fp_lir_kunnr.
  CLEAR lst_kunnr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_VALIDATION
*&---------------------------------------------------------------------*
*    Validate Sales Document in sales Organization
*----------------------------------------------------------------------*
*  -->  p1        Document number
*  -->  p2        Document type
*  -->  p3        Sales organization
*----------------------------------------------------------------------*
FORM f_data_validation USING fp_doc_no   TYPE vbeln  " Sales and Distribution Document Number
                             fp_doc_type TYPE char10 " Doc_no of type CHAR10
                             fp_vkorg    TYPE vkorg. " Sales Organization

  DATA : lv_vbeln TYPE vbeln . " Sales and Distribution Document Number

  IF fp_doc_type = c_order.

    SELECT SINGLE vbeln " Sales Document
           vkorg        " Sales Org
      FROM vbak         " Sales Document: Header Data
      INTO (lv_vbeln , fp_vkorg)
      WHERE vbeln = fp_doc_no.
    IF sy-subrc IS NOT INITIAL.
      RAISE invalid_document_number.
    ENDIF. " IF sy-subrc IS NOT INITIAL

  ELSEIF fp_doc_type = c_invoice.

    SELECT SINGLE vbeln " Billing Document
           vkorg        " Sales Org
      FROM vbrk         " Billing Document: Header Data
      INTO (lv_vbeln , fp_vkorg)
      WHERE vbeln = fp_doc_no.
    IF sy-subrc IS NOT INITIAL.
      RAISE invalid_document_number.
    ENDIF. " IF sy-subrc IS NOT INITIAL

  ENDIF. " IF fp_doc_type = c_order

ENDFORM.
