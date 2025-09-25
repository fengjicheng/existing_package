*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_JPAT_REPORT_EXTEND_SUB (Main Subroutine file)
* PROGRAM DESCRIPTION: Entrire Logic build on here
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916608
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/14/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

FORM f_dynamic_screen.

  IF rb_det EQ abap_true.       " Populate the screnn fields based on the selection
    LOOP AT SCREEN.
      IF screen-group1 EQ 'SG1'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'SG3'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'SG2' .
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  LOOP AT SCREEN.                   " Disable screen input
    IF screen-name = 'S_AUART-LOW' .
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
    IF screen-name = 'S_VKAUS-LOW' .  " Disable screen input
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_screen_validate .

  IF rb_det EQ abap_true.       " Detail report
    IF s_year IS INITIAL.       " year is Null
      MESSAGE s000(zjpat) DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
    IF s_month IS INITIAL.     " Month is null
      MESSAGE s001(zjpat) DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.                         " Summary report
    IF p_year IS INITIAL .      " year is null
      MESSAGE s000(zjpat) DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

  FIND REGEX '[[:punct:]]' IN s_month.  " Alphanumeric validation
  IF sy-subrc = 0.
    MESSAGE s002(zjpat) DISPLAY LIKE c_errtype.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF rb_sum EQ abap_true.       " Summary report
    IF p_year LE v_year.       " year less than constant table year
      MESSAGE s006(zjpat) DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    IF v_selection_year LE v_year.        " year less than constant table year
      IF v_selection_month LT v_month.    " Month less than constant table month
        MESSAGE s003(zjpat) DISPLAY LIKE c_errtype.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_value_on_request CHANGING fp_s_matnr TYPE mara-matnr.

  DATA : li_return  TYPE STANDARD TABLE OF ddshretval,
         lst_return TYPE ddshretval.

  REFRESH i_view.

  SELECT media_issue FROM zcds_jpat_marcm
    INTO TABLE @i_view
    WHERE act_pub_date NE @c_pubdate.

  IF sy-subrc EQ 0.
    SORT i_view BY media_issue.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'MEDIA_ISSUE'
        value_org       = 'S'
      TABLES
        value_tab       = i_view
        return_tab      = li_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      "Suitable error Handler
    ENDIF.

    IF li_return IS NOT INITIAL.
      READ TABLE li_return INTO lst_return INDEX 1.
      IF sy-subrc EQ 0.
        fp_s_matnr = lst_return-fieldval.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_populate_defaults .

  DATA : lst_auart  TYPE ty_auart,
         lst_vkaus  TYPE ty_vkaus,
         lst_potype TYPE ty_potype,
         lst_acccat TYPE ty_acccat,
         lst_bstyp  TYPE ty_bstyp.

  CONSTANTS : lc_auart  TYPE rvari_vnam VALUE 'AUART',
              lc_vkaus  TYPE rvari_vnam VALUE 'VKAUS',
              lc_year   TYPE rvari_vnam VALUE 'ZYEAR',
              lc_month  TYPE rvari_vnam VALUE 'ZMONTH',
              lc_potype TYPE rvari_vnam VALUE 'BSART',
              lc_acccat TYPE rvari_vnam VALUE 'KNTTP',
              lc_bstyp  TYPE rvari_vnam VALUE 'BSTYP'.

  FREE : v_month,v_year.

  SELECT param1 ,param2,srno,sign,opti,low,high,flag        " Fetch data from Constant table
    FROM zqtc_mnt_r090
    INTO TABLE @i_const
    WHERE flag EQ @space.

  IF sy-subrc IS INITIAL.
    SORT i_const BY param1.                                  " Sort itab according to the param1.
    IF i_const IS NOT INITIAL.
      LOOP AT i_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
        CASE <lfs_const>-param1.
          WHEN lc_auart.                                      " Set default Order types
            lst_auart-sign   = <lfs_const>-sign.
            lst_auart-opti   = <lfs_const>-opti.
            lst_auart-low    = <lfs_const>-low.
            lst_auart-high   = <lfs_const>-high.
            APPEND lst_auart TO s_auart.
            CLEAR lst_auart.
          WHEN lc_vkaus.                                      " Set default Usage types
            lst_vkaus-sign   = <lfs_const>-sign.
            lst_vkaus-opti   = <lfs_const>-opti.
            lst_vkaus-low    = <lfs_const>-low.
            lst_vkaus-high   = <lfs_const>-high.
            APPEND lst_vkaus TO s_vkaus.
            CLEAR lst_vkaus.
          WHEN lc_potype.                                     " Set default PO type
            lst_potype-sign   = <lfs_const>-sign.
            lst_potype-opti   = <lfs_const>-opti.
            lst_potype-low    = <lfs_const>-low.
            lst_potype-high   = <lfs_const>-high.
            APPEND lst_potype TO ir_potype.
            CLEAR lst_potype.
          WHEN lc_acccat.                                     " Set default Acc. Ass. Cat
            lst_acccat-sign   = <lfs_const>-sign.
            lst_acccat-opti   = <lfs_const>-opti.
            lst_acccat-low    = <lfs_const>-low.
            lst_acccat-high   = <lfs_const>-high.
            APPEND lst_acccat TO ir_acccat.
            CLEAR lst_acccat.
          WHEN lc_bstyp.                                      " Set default Document category
            lst_bstyp-sign   = <lfs_const>-sign.
            lst_bstyp-opti   = <lfs_const>-opti.
            lst_bstyp-low    = <lfs_const>-low.
            lst_bstyp-high   = <lfs_const>-high.
            APPEND lst_bstyp TO ir_bstyp.
            CLEAR lst_bstyp.
        ENDCASE.
      ENDLOOP.
      " Fetch restricted year
      READ TABLE i_const ASSIGNING <lfs_const> WITH KEY param1 = lc_year BINARY SEARCH.
      IF sy-subrc = 0.
        v_year = <lfs_const>-low.
      ENDIF.
      " Fetch restricted month
      READ TABLE i_const ASSIGNING <lfs_const> WITH KEY param1 = lc_month BINARY SEARCH.
      IF sy-subrc = 0.
        v_month = <lfs_const>-low.
      ENDIF.
    ENDIF.

  ENDIF.
  p_year = sy-datum+0(4).                                   " Set Current year as default

  REFRESH s_year[].
  s_year-low = sy-datum+0(4).                              " Set Current year as default for detail report
  APPEND s_year.

ENDFORM.

FORM f_get_data .

  IF rb_sum EQ abap_true.     " Summary report data selection

    SELECT act_pub_year,act_pub_month,document_type_desc,subs_sales_order,back_main_orders,free_not_free,
      document_type,item_category,usage_type,target_qty
      FROM zcds_jpat_salsum
      INTO TABLE @i_view_salsum
      WHERE act_pub_year IN @ir_year  AND
            media_issue IN @s_matnr   AND                     " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT * FROM zcds_jpat_jdrsum
      INTO TABLE @i_view_jdrsum
      WHERE publication_year IN @ir_year AND
            media_issue IN @s_matnr      AND                  " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT * FROM zcds_jpat_biossm
      INTO TABLE @i_view_biossum
      WHERE publication_year IN @ir_year AND
            media_issue IN @s_matnr      AND                  " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT publication_year,publication_month,printer_po_conference
      FROM zcds_jpat_po_sum
      INTO TABLE @i_view_posum
      WHERE publication_year IN @ir_year AND
            material IN @s_matnr         AND                  " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT * FROM zcds_jpat_isohsm
      INTO TABLE @i_view_isohsm
      WHERE publication_year IN @ir_year AND
            media_issue IN @s_matnr      AND                  " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT * FROM zcds_jpat_sohsum
      INTO TABLE @i_view_sohsum
      WHERE publication_year IN @ir_year AND
            media_issue IN @s_matnr      AND                  " Add Media Issue and Media product with ED2K916403
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

    SELECT po_qty,publication_year,publication_month
       FROM zcds_jpat_po_dt
       INTO TABLE @i_nbpodetail
       WHERE material IN @s_matnr         AND                 " Add Media Issue and Media product with ED2K916403
             po_type IN @ir_potype        AND
             tracking_no EQ @space        AND
             account_assignment IN @ir_acccat  AND
             publication_year IN @ir_year AND
             doc_category IN @ir_bstyp    AND
             media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.

*** Begin of Change with ED2K916403 ***
    SELECT publication_year,publication_month,jrr_quantity
      FROM zcds_jpat_jrrsm
      INTO TABLE @i_view_jrrsum
      WHERE publication_year IN @ir_year AND
            media_issue IN @s_matnr      AND
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.
*** End of Change with ED2K916403 ***

*** Begin of Changes with ED2K916608 ***
    SELECT publication_month,publication_year,po_dispatch
      FROM zcds_po_jrr_lf
      INTO TABLE @i_view_prdissum
      WHERE media_issue IN @s_matnr      AND
            media_product IN @s_isprod   AND
            publication_year IN @ir_year.
    IF sy-subrc IS INITIAL.
      " Nothing to do.
    ENDIF.
*** End of Changes with ED2K916608 ***

    "Prepare Summarized Order data
    PERFORM f_summarized_order_data TABLES i_view_salsum
                                           i_nbpodetail
                            "*** Begin of Changes for ED2K916403 ***
                                           i_view_jdrsum
                                           i_view_biossum
                                           i_view_posum
                                           i_view_isohsm
                                           i_view_sohsum
                                           i_view_jrrsum
                                           i_view_prdissum.    " Changes for ED2K916608
    "*** End of Changes for ED2K916403 ***


    "Sort data acording to the Year and month
    SORT i_view_isohsm  BY publication_year publication_month.
    SORT i_view_sohsum  BY publication_year publication_month.

  ELSE.                 " Detail report data selection

    SELECT material,act_publication_date,po_type,tracking_no,po_qty,po_number,item,company_code,    " Fetch PO detail data
      created_date,document_date,vendor,plant,account_assignment,created_by,deletion_indicator
      FROM zcds_jpat_po_dt
      INTO TABLE @i_view_podetail
      WHERE material IN @s_matnr           AND
            publication_year IN @s_year    AND                " Year Change as a range parametr with ED2K916608
            publication_month IN @s_month  AND
            media_product IN @s_isprod.                       " Add media product with ED2K916403
    IF sy-subrc = 0.
      SORT i_view_podetail BY material.
    ENDIF.

    SELECT media_issue,adustment_type,bios_quantity,act_publication_date            " Fetch BIOS Detail data
      FROM zcds_jpat_bios
      INTO TABLE  @i_view_biosdetail
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_biosdetail BY media_issue.
    ENDIF.

    SELECT media_issue,jdr_quantity,act_publication_date,adustment_type              " Fetch JDR detail data
      FROM zcds_jpat_jdr                                                             " Add adustment_type column with ED2K916403
      INTO TABLE @i_view_jdrdetail
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_jdrdetail BY media_issue.
    ENDIF.

    SELECT media_issue,document_type,document_type_desc,item_category,        " Fetch sales detail data
           target_qty,document_number,act_pub_date,item,su,reference_document,
           reference_document_type,subs_sales_order,refitm,condition_group_4,
           free_not_free,created_date,created_by,sales_organization,material_grp_5,rejection_reason,schedule_line_type
      FROM zcds_jpat_saldt
      INTO TABLE @i_view_salesdetail
      WHERE media_issue IN @s_matnr       AND
            act_pub_year IN @s_year       AND                   " Year Change as a range parametr with ED2K916608
            act_pub_month IN @s_month     AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_salesdetail BY media_issue.
    ENDIF.

    SELECT media_issue,soh_qty,act_publication_date                                             " Fetch SOH detail data
      FROM zcds_jpat_soh
      INTO TABLE @i_view_sohdetail
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_sohdetail BY media_issue.
    ENDIF.

*** Begin of changes for ED2K916403 ***
    SELECT media_issue,inital_soh_quantity,act_publication_date                         " Fecth initial SOH detail
      FROM zcds_jpat_isoh
      INTO TABLE @i_view_isohdetail
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_isohdetail BY media_issue.
    ENDIF.

    SELECT media_issue,adustment_type,jrr_quantity,act_publication_date,ordered_print_run
      FROM zcds_jpat_jrr
      INTO TABLE @i_view_jrrdetail
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr,"Order_print_run Qty" with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.                         " Add media product with ED2K916403
    IF sy-subrc IS INITIAL.
      SORT i_view_jrrdetail BY media_issue.
    ENDIF.


    SELECT media_issue,act_pub_date,po_qty,jrr_qty,po_dispatch
      FROM zcds_po_jrr_dt
      INTO TABLE @i_view_printedis
      WHERE media_issue IN @s_matnr       AND
            publication_year IN @s_year   AND                   " Year Change as a range parametr,"Order_print_run Qty" with ED2K916608
            publication_month IN @s_month AND
            media_product IN @s_isprod.
    IF sy-subrc IS INITIAL.
      SORT i_view_printedis BY media_issue.
    ENDIF.

*** End of Changes for ED2K916403 ***

    " Convert data to character format to copy data to clipboard
    PERFORM f_podetail_convert.
    PERFORM f_biosdetail_convert.
    PERFORM f_jdrdetail_convert.
    PERFORM f_salesdetail_convert.
    PERFORM f_sohdetail_convert.
*** Begin of changes for ED2K916403 ***
    PERFORM f_isohdetail_convert.
    PERFORM f_jrrdetail_convert.
    PERFORM f_printerdis_convert.
*** End of changes for ED2K916403 ***

  ENDIF.

ENDFORM.

FORM f_call_screen.

  IF rb_sum = abap_true.
    CALL SCREEN 2000.   " Call Summary Screen
  ELSE.
    CALL SCREEN 3000.   " Call detail screen
  ENDIF.

ENDFORM.

FORM f_salesdetail_convert .

  DATA : lv_qty        TYPE char16,
         lv_createdate TYPE char10,
         lv_pubdate    TYPE char10.

  CLEAR : lv_qty,
          lv_createdate,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-025 text-026 text-027 text-028 text-029 text-030 text-031 text-032 text-033 text-034 text-035
              text-036 text-037 text-038 text-039 text-040 text-041 text-042 text-043 text-044 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_salesdetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_salesdetail IS NOT INITIAL.
    LOOP AT i_view_salesdetail ASSIGNING <gfs_salesdetail>.
      WRITE <gfs_salesdetail>-target_qty TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_salesdetail>-created_date TO lv_createdate MM/DD/YYYY.
      WRITE <gfs_salesdetail>-act_pub_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_salesdetail>-media_issue
      <gfs_salesdetail>-document_type
      <gfs_salesdetail>-document_type_desc
      <gfs_salesdetail>-item_category
      lv_qty
      <gfs_salesdetail>-document_number
      lv_pubdate
      <gfs_salesdetail>-item
      <gfs_salesdetail>-su
      <gfs_salesdetail>-reference_document
      <gfs_salesdetail>-reference_document_type
      <gfs_salesdetail>-subs_sales_order
      <gfs_salesdetail>-refitm
      <gfs_salesdetail>-condition_group_4
      <gfs_salesdetail>-free_not_free
      lv_createdate
      <gfs_salesdetail>-created_by
      <gfs_salesdetail>-sales_organization
      <gfs_salesdetail>-material_grp_5
      <gfs_salesdetail>-rejection_reason
      <gfs_salesdetail>-schedule_line_type

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_salesdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_podetail_convert.

  DATA : lv_qty        TYPE char16,
         lv_createdate TYPE char10,
         lv_pubdate    TYPE char10,
         lv_docdate    TYPE char10.

  CLEAR : lv_qty,
          lv_createdate,
          lv_pubdate,
          lv_docdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-007 text-008 text-009 text-010 text-011 text-012 text-013 text-014 text-015 text-016 text-017
              text-018 text-019 text-020 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_podetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_podetail IS NOT INITIAL.
    LOOP AT i_view_podetail ASSIGNING <gfs_podetail>.
      WRITE <gfs_podetail>-po_qty TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_podetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.
      WRITE <gfs_podetail>-created_date TO lv_createdate MM/DD/YYYY.
      WRITE <gfs_podetail>-document_date TO lv_docdate MM/DD/YYYY.

      CONCATENATE <gfs_podetail>-material
      lv_pubdate
      <gfs_podetail>-po_type
      <gfs_podetail>-tracking_no
      lv_qty
      <gfs_podetail>-po_number
      <gfs_podetail>-item
      <gfs_podetail>-company_code
      lv_createdate
      lv_docdate
      <gfs_podetail>-vendor
      <gfs_podetail>-plant
      <gfs_podetail>-account_assignment
      <gfs_podetail>-created_by
      <gfs_podetail>-deletion_indicator

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_podetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_biosdetail_convert .

  DATA : lv_qty     TYPE char16,
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE  text-006 text-021 text-022 text-007 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_biosdetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_biosdetail IS NOT INITIAL.
    LOOP AT i_view_biosdetail ASSIGNING <gfs_biosdetail>.
      WRITE <gfs_biosdetail>-bios_quantity TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_biosdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_biosdetail>-media_issue
      <gfs_biosdetail>-adustment_type
      lv_qty
      lv_pubdate

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_biosdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_jdrdetail_convert .

  DATA : lv_qty     TYPE char16,
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-021 text-023 text-024 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.     " Add text-021 with ED2K916403
  APPEND stconvertdata_excel-convertdata TO i_jdrdetail_excel.
  CLEAR stconvertdata_excel-convertdata.

  IF i_view_jdrdetail IS NOT INITIAL.
    LOOP AT i_view_jdrdetail ASSIGNING <gfs_jdrdetail>.
      WRITE <gfs_jdrdetail>-jdr_quantity TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_jdrdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_jdrdetail>-media_issue
      <gfs_jdrdetail>-adustment_type                            " Add <gfs_jdrdetail>-adustment_type with ED2K916403
      lv_qty
      lv_pubdate

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_jdrdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_sohdetail_convert .

  DATA : lv_qty     TYPE char16,
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-045 text-046 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_sohdetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_sohdetail IS NOT INITIAL.
    LOOP AT i_view_sohdetail ASSIGNING <gfs_sohdetail>.
      WRITE <gfs_sohdetail>-soh_qty TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_sohdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_sohdetail>-media_issue
      lv_qty
      lv_pubdate

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_sohdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_calculate_year .

  v_previousyear = p_year - 1.
  REFRESH ir_year.

  APPEND INITIAL LINE TO ir_year ASSIGNING FIELD-SYMBOL(<lfs_year>).
  <lfs_year>-sign = 'I'.
  <lfs_year>-option = 'EQ'.
  <lfs_year>-low = v_previousyear.
  <lfs_year>-high = space.

  APPEND INITIAL LINE TO ir_year ASSIGNING <lfs_year>.
  <lfs_year>-sign = 'I'.
  <lfs_year>-option = 'EQ'.
  <lfs_year>-low = p_year.
  <lfs_year>-high = space.

ENDFORM.

FORM f_summarized_order_data TABLES fp_i_view_salsum
                                    fp_i_nbpodetail
*** Begin of Changes for ED2K916403 ***
                                    fp_i_view_jdrsum
                                    fp_i_view_biossum
                                    fp_i_view_posum
                                    fp_i_view_isohsum
                                    fp_i_view_sohsum
                                    fp_i_view_jrrsum
                                    fp_i_view_prdissum.       " Changes for ED2K916608
*** End of Changes for ED2K916403 ***

  FIELD-SYMBOLS : <lfs_view_salsum>   TYPE ty_salsum,
                  <lfs_nbpodetail>    TYPE ty_nbpodetail,
*** Begin of Changes for ED2K916403 ***
                  <lfs_view_jdrsum>   TYPE zcds_jpat_jdrsum,
                  <lfs_view_biossum>  TYPE zcds_jpat_biossm,
                  <lfs_view_posum>    TYPE ty_posum,
                  <lfs_view_ishosum>  TYPE zcds_jpat_isohsm,
                  <lfs_view_shosum>   TYPE zcds_jpat_sohsum,
                  <lfs_view_jrrsum>   TYPE ty_jrrsum,
*** End of Changes for ED2K916403 ***
*** Begin of Changes for ED2K916608 ***
                  <lfs_view_prdissum> TYPE ty_prdissum.
*** End of Changes for ED2K916608 ***


  DATA : lst_subs_total TYPE ty_sales_total,
         lst_nbposum    TYPE ty_nbposum,
*** Begin of Changes for ED2K916403 ***
         lst_jdrsum     TYPE ty_jdr_total,
         lst_biossum    TYPE ty_bios_total,
         lst_posum      TYPE ty_po_total,
         lst_isohsum    TYPE ty_isoh_total,
         lst_sohsum     TYPE ty_soh_total,
         lst_jrrsum     TYPE ty_jrr_total,
*** End of Changes for ED2K916403 ***
*** Begin of Changes for ED2K916608 ***
         lst_pdsisum    TYPE ty_pdis_total.
*** End of Changes for ED2K916608 ***


  DATA : lv_subscription  TYPE char12,
         lv_main_lables   TYPE char11,
         lv_paid          TYPE char4,
         lv_author_copies TYPE char13,
         lv_back_orders   TYPE char11,
         lv_not_free      TYPE char11.

  CONSTANTS : lc_subscription  TYPE rvari_vnam VALUE 'SUBS',
              lc_main_lables   TYPE rvari_vnam VALUE 'BACK',
              lc_paid          TYPE rvari_vnam VALUE 'FNF',
              lc_author_copies TYPE rvari_vnam VALUE 'AUTHOR',
              lc_back_orders   TYPE rvari_vnam VALUE 'BCK_ORD',
              lc_not_free      TYPE rvari_vnam VALUE 'OTHER'.

  " Assign data to local variable from ABAP constant table
  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_subscription.
        lv_subscription = <lfs_constant>-low.
      WHEN lc_main_lables.
        lv_main_lables = <lfs_constant>-low.
      WHEN lc_paid.
        lv_paid = <lfs_constant>-low.
      WHEN lc_author_copies.
        lv_author_copies = <lfs_constant>-low.
      WHEN lc_back_orders.
        lv_back_orders = <lfs_constant>-low.
      WHEN lc_not_free.
        lv_not_free = <lfs_constant>-low.
    ENDCASE.
  ENDLOOP.

  IF i_view_salsum IS NOT INITIAL.
    LOOP AT fp_i_view_salsum ASSIGNING <lfs_view_salsum>.
      "Subscription Total (Sales)
      IF <lfs_view_salsum>-subs_sales_order = lv_subscription AND <lfs_view_salsum>-back_main_orders = lv_main_lables
                                                              AND <lfs_view_salsum>-free_not_free = lv_paid.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_subs_total.
        CLEAR lst_subs_total.
      ENDIF.

      "Author copies (Main Lables) (Includes Subs and Sales Orders)
      IF <lfs_view_salsum>-free_not_free = lv_author_copies AND <lfs_view_salsum>-back_main_orders = lv_main_lables.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_author_copies_main.
        CLEAR lst_subs_total.
      ENDIF.

      "Author copies (Back Orders) (Includes Subs and Sales Orders)
      IF <lfs_view_salsum>-free_not_free = lv_author_copies AND <lfs_view_salsum>-back_main_orders = lv_back_orders.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_author_copies_back.
        CLEAR lst_subs_total.
      ENDIF.

      " Bulk orders (Main Lables Sales Orders) (EMLOs)
      IF <lfs_view_salsum>-free_not_free = lv_not_free AND <lfs_view_salsum>-back_main_orders = lv_main_lables.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_bulk_orders_main.
        CLEAR lst_subs_total.
      ENDIF.

      " Bulk orders (Back Orders Sales) (EBLOs)
      IF <lfs_view_salsum>-free_not_free = lv_not_free AND <lfs_view_salsum>-back_main_orders = lv_back_orders.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_bulk_orders_back.
        CLEAR lst_subs_total.
      ENDIF.

      " Back orders (Sales Data)
      IF <lfs_view_salsum>-back_main_orders = lv_back_orders AND <lfs_view_salsum>-free_not_free = lv_paid.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_back_orders.
        CLEAR lst_subs_total.
      ENDIF.
      CLEAR lst_subs_total.
    ENDLOOP.
  ENDIF.

  IF i_nbpodetail IS NOT INITIAL.
    " Summarized NB Potype quantity
    LOOP AT fp_i_nbpodetail ASSIGNING <lfs_nbpodetail>.
      lst_nbposum-publication_year = <lfs_nbpodetail>-publication_year.
      lst_nbposum-publication_month = <lfs_nbpodetail>-publication_month.
      lst_nbposum-po_qty  = <lfs_nbpodetail>-po_qty.

      COLLECT lst_nbposum INTO is_nbposumary.
      CLEAR lst_nbposum.
    ENDLOOP.
  ENDIF.

*** Begin of Changes for ED2K916403 ***
  IF i_view_jdrsum IS NOT INITIAL.
    " Summarized JDR quantity
    LOOP AT fp_i_view_jdrsum ASSIGNING <lfs_view_jdrsum>.
      lst_jdrsum-publication_year = <lfs_view_jdrsum>-publication_year.
      lst_jdrsum-publication_month = <lfs_view_jdrsum>-publication_month.
      lst_jdrsum-jdr_quantity   = <lfs_view_jdrsum>-jdr_quantity.

      COLLECT lst_jdrsum INTO is_jdrsum.
      CLEAR lst_jdrsum.
    ENDLOOP.
  ENDIF.

  IF i_view_biossum IS NOT INITIAL.
    " Summarized BIOS quantity
    LOOP AT fp_i_view_biossum ASSIGNING <lfs_view_biossum>.
      lst_biossum-publication_year = <lfs_view_biossum>-publication_year.
      lst_biossum-publication_month = <lfs_view_biossum>-publication_month.
      lst_biossum-bios_quantity   = <lfs_view_biossum>-bios_quantity.

      COLLECT lst_biossum INTO is_biossum.
      CLEAR lst_biossum.
    ENDLOOP.
  ENDIF.

  IF i_view_posum IS NOT INITIAL.
    " Summarized PO quantity
    LOOP AT fp_i_view_posum ASSIGNING <lfs_view_posum>.
      lst_posum-publication_year = <lfs_view_posum>-publication_year.
      lst_posum-publication_month = <lfs_view_posum>-publication_month.
      lst_posum-printer_po_conference   = <lfs_view_posum>-printer_po_conference.

      COLLECT lst_posum INTO is_posum.
      CLEAR lst_posum.
    ENDLOOP.
  ENDIF.

  IF i_view_isohsm IS NOT INITIAL.
    " Summarized Intial SOH quantity
    LOOP AT fp_i_view_isohsum ASSIGNING <lfs_view_ishosum>.
      lst_isohsum-publication_year = <lfs_view_ishosum>-publication_year.
      lst_isohsum-publication_month = <lfs_view_ishosum>-publication_month.
      lst_isohsum-inital_soh_quantity  = <lfs_view_ishosum>-inital_soh_quantity.

      COLLECT lst_isohsum INTO is_ishosum.
      CLEAR lst_isohsum.
    ENDLOOP.
  ENDIF.

  IF i_view_sohsum IS NOT INITIAL.
    " Summarized SOH quantity
    LOOP AT fp_i_view_sohsum ASSIGNING <lfs_view_shosum>.
      lst_sohsum-publication_year = <lfs_view_shosum>-publication_year.
      lst_sohsum-publication_month = <lfs_view_shosum>-publication_month.
      lst_sohsum-soh_qty  = <lfs_view_shosum>-soh_qty.

      COLLECT lst_sohsum INTO is_shosum.
      CLEAR lst_sohsum.
    ENDLOOP.
  ENDIF.

  IF i_view_jrrsum IS NOT INITIAL.
    " Summarized JRR quantity
    LOOP AT fp_i_view_jrrsum ASSIGNING <lfs_view_jrrsum>.
      lst_jrrsum-publication_year = <lfs_view_jrrsum>-publication_year.
      lst_jrrsum-publication_month = <lfs_view_jrrsum>-publication_month.
      lst_jrrsum-jrr_quantity  = <lfs_view_jrrsum>-jrr_quantity.

      COLLECT lst_jrrsum INTO is_jrrsum.
      CLEAR lst_jrrsum.
    ENDLOOP.
  ENDIF.
*** End of Changes for ED2K916403 ***

*** Begin of Changes for ED2K916608 ***
  IF i_view_prdissum IS NOT INITIAL.
    " Summarized the PO dispatch
    LOOP AT fp_i_view_prdissum ASSIGNING <lfs_view_prdissum>.
      lst_pdsisum-publication_year = <lfs_view_prdissum>-publication_year.
      lst_pdsisum-publication_month = <lfs_view_prdissum>-publication_month.
      lst_pdsisum-po_dispatch = <lfs_view_prdissum>-po_dispatch.

      COLLECT lst_pdsisum  INTO is_pdissum.
      CLEAR lst_pdsisum.
    ENDLOOP.
  ENDIF.
*** End of Changes for ED2K916608 ***

ENDFORM.

FORM f_get_zcaconstants .

  SELECT devid                      "Development ID
         param1                     "ABAP: Name of Variant Variable
         param2                     "ABAP: Name of Variant Variable
         srno                       "Current selection number
         sign                       "ABAP: ID: I/E (include/exclude values)
         opti                       "ABAP: Selection option (EQ/BT/CP/...)
         low                        "Lower Value of Selection Condition
         high                       "Upper Value of Selection Condition
         activate                   "Activation indicator for constant
         FROM zcaconstant           " Wiley Application Constant Table
         INTO TABLE i_constant
         WHERE devid    = c_devid
         AND   activate = c_x.       "Only active record
  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1.
  ENDIF.

ENDFORM.

*** Begin of changes for ED2K916403 ***
FORM f_isohdetail_convert .

  DATA : lv_qty     TYPE char16,
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-086 text-046 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_isohdetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_isohdetail IS NOT INITIAL.
    LOOP AT i_view_isohdetail ASSIGNING <gfs_isohdetail>.
      WRITE <gfs_isohdetail>-inital_soh_quantity TO lv_qty UNIT ''.      " qty convert to char
      WRITE <gfs_isohdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_isohdetail>-media_issue
      lv_qty
      lv_pubdate

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_isohdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_jrrdetail_convert .

  DATA : lv_qty     TYPE char16,
         lv_qty2    TYPE char16,      " Added with ED2K916608
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-021 text-088 text-099 text-046 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_jrrdetail_excel.
  CLEAR stconvertdata_excel.

  IF i_view_jrrdetail IS NOT INITIAL.
    LOOP AT i_view_jrrdetail ASSIGNING <gfs_jrrdetail>.
      WRITE <gfs_jrrdetail>-jrr_quantity TO lv_qty  DECIMALS 0.           " qty convert to char
      WRITE <gfs_jrrdetail>-ordered_print_run TO lv_qty2  DECIMALS 0.     " Order print run qty convert to char
      WRITE <gfs_jrrdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_jrrdetail>-media_issue
      <gfs_jrrdetail>-adustment_type
      lv_qty
      lv_qty2         " Added with ED2K916608
      lv_pubdate

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_jrrdetail_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.
*** End of changes for ED2K916403 ***

*** Begin of changes for ED2K916608 ***
FORM f_month_and_year_validation .

  REFRESH : i_sel_month[] , i_sel_year[].
  CLEAR : v_selection_month , v_selection_year.

  IF s_year IS NOT INITIAL.       " Check Detail report selection year
    i_sel_year[] = s_year[].      " Copying selection parameter to Itab
    SORT i_sel_year BY low.
    READ TABLE i_sel_year ASSIGNING FIELD-SYMBOL(<lfs_year>) INDEX 1.
    IF sy-subrc EQ 0.
      v_selection_year = <lfs_year>-low.  " Assign lowest Year for validation
    ENDIF.
  ENDIF.

  IF s_month IS NOT INITIAL.        " Check Detail report selection month
    i_sel_month[] = s_month[].
    SORT i_sel_month BY low.        " Copying selection parameter to Itab
    READ TABLE i_sel_month ASSIGNING FIELD-SYMBOL(<lfs_month>) INDEX 1.
    IF sy-subrc EQ 0.
      v_selection_month = <lfs_month>-low.    " Assign lowest month for validation
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_hide_range_selection .

  DATA : lv_drmonth   TYPE char7,
         lv_dryear    TYPE char6,
         lv_drinclude TYPE char1,
         lv_droption  TYPE char8,
         lv_drselect  TYPE char1,
         lv_com       TYPE char11.

  CONSTANTS : lc_drmonth   TYPE rvari_vnam VALUE 'BLOCK_MONTH',
              lc_dryear    TYPE rvari_vnam VALUE 'BLOCK_YEAR',
              lc_drinclude TYPE rvari_vnam VALUE 'INCLUDE',
              lc_droption  TYPE rvari_vnam VALUE 'OPTION',
              lc_drselect  TYPE rvari_vnam VALUE 'SELECT'.

  " Assign data to local variable from ABAP constant table
  LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_drmonth.
        lv_drmonth = <lfs_constant>-low.
      WHEN lc_dryear.
        lv_dryear = <lfs_constant>-low.
      WHEN lc_drinclude.
        lv_drinclude = <lfs_constant>-low.
      WHEN lc_droption.
        lv_droption = <lfs_constant>-low.
      WHEN lc_drselect.
        lv_drselect = <lfs_constant>-low.
    ENDCASE.
  ENDLOOP.

  " Hide detail report year select options
  PERFORM f_hide_year USING lv_droption
                            lv_drselect
                            lv_dryear
                            lv_drinclude
                            lv_drmonth.

ENDFORM.

FORM f_hide_year  USING fp_droption
                        fp_drselect
                        fp_dryear
                        fp_drinclude
                        fp_drmonth.

*** Begin of disabling Year Range selection ***
  v_opt_list-name = fp_droption.
  v_opt_list-options-bt = space.
  v_opt_list-options-eq = abap_true.
  APPEND v_opt_list TO v_restrict-opt_list_tab.

  v_ass-kind = fp_drselect.
  v_ass-name = fp_dryear.
  v_ass-sg_main = fp_drinclude.
  v_ass-op_main = fp_droption.
  APPEND v_ass TO v_restrict-ass_tab.
*** End of disabling Year Range selection ***

*** Begin of disabling Month Range selection ***
  v_opt_list-name = fp_droption.
  v_opt_list-options-bt = space.
  v_opt_list-options-eq = abap_true.
  APPEND v_opt_list TO v_restrict-opt_list_tab.

  v_ass-kind = fp_drselect.
  v_ass-name = fp_drmonth.
  v_ass-sg_main = fp_drinclude.
  v_ass-op_main = fp_droption.
  APPEND v_ass TO v_restrict-ass_tab.
*** End of disabling month Range selection ***

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = v_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc = 0.
    " NOTHING TO DO
  ENDIF.

ENDFORM.
*** End of changes for ED2K916608 ***

FORM f_printerdis_convert .

  DATA : lv_qty     TYPE char16,
         lv_qty2    TYPE char16,      " Added with ED2K916608
         lv_qty3    TYPE char16,
         lv_pubdate TYPE char10.

  CLEAR : lv_qty,
          lv_qty2,
          lv_qty3,
          lv_pubdate,
          stconvertdata_excel.

  CONCATENATE text-006 text-101 text-102 text-103 text-104 INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
  APPEND stconvertdata_excel TO i_prnterdis_excel.
  CLEAR stconvertdata_excel.

  IF i_view_printedis IS NOT INITIAL.
    LOOP AT i_view_printedis ASSIGNING <gfs_prdisdetail>.
      WRITE <gfs_prdisdetail>-po_qty TO lv_qty  DECIMALS 0.           " qty convert to char
      WRITE <gfs_prdisdetail>-jrr_qty TO lv_qty2  DECIMALS 0.         " qty convert to char
      WRITE <gfs_prdisdetail>-po_dispatch TO lv_qty3  DECIMALS 0.
      WRITE <gfs_prdisdetail>-act_pub_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_prdisdetail>-media_issue
      lv_pubdate
      lv_qty
      lv_qty2
      lv_qty3

      INTO stconvertdata_excel-convertdata SEPARATED BY v_deli.
      CONDENSE stconvertdata_excel.
      APPEND stconvertdata_excel TO i_prnterdis_excel.
      CLEAR stconvertdata_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.
