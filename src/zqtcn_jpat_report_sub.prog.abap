*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_REPORT_SUB
*&---------------------------------------------------------------------*

FORM f_dynamic_screen.

  IF rb_det EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'SG1'.
        screen-active = 1.
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

  IF rb_det EQ 'X'.
    IF p_year IS INITIAL.
      MESSAGE 'Publication Year is Mandatory' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
    IF  p_month IS INITIAL..
      MESSAGE 'Month is Mandatory' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    IF p_year IS INITIAL .
      MESSAGE 'Publication Year is Mandatory' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

  FIND REGEX '[[:punct:]]' IN p_month.
  IF sy-subrc = 0.
    MESSAGE 'Alpha Numeric characters are not allowed for the selection input.' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF rb_sum EQ 'X'.
    IF p_year LE v_year.
      MESSAGE 'No Data for Current Selection' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    IF p_year LE v_year.
      IF p_month LT v_month.
        MESSAGE 'No Data for Current Selection' TYPE 'S' DISPLAY LIKE 'E'.
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

  DATA : lv_yyyy TYPE sy-datum.

  SELECT param1 ,param2,srno,sign,opti,low,high,flag        " Fetch data from Constant table
    FROM zqtc_mnt_r090
    INTO TABLE @i_const
    WHERE flag EQ @space.

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

  p_year = sy-datum+0(4).                                   " Set Current year as default

ENDFORM.

FORM f_get_data .

  IF rb_sum EQ 'X'.     " Summary report data selection

    SELECT act_pub_year,act_pub_month,document_type_desc,subs_sales_order,back_main_orders,free_not_free,
      document_type,item_category,usage_type,target_qty
      FROM zcds_jpat_salsum
      INTO TABLE @i_view_salsum
      WHERE act_pub_year IN @ir_year.

    SELECT * FROM zcds_jpat_jdrsum
      INTO TABLE @i_view_jdrsum
      WHERE publication_year IN @ir_year.

    SELECT * FROM zcds_jpat_biossm
      INTO TABLE @i_view_biossum
      WHERE publication_year IN @ir_year.

    SELECT publication_year,publication_month,printer_po_conference
      FROM zcds_jpat_po_sum
      INTO TABLE @i_view_posum
      WHERE publication_year IN @ir_year.

    SELECT * FROM zcds_jpat_isohsm
      INTO TABLE @i_view_isohsm
      WHERE publication_year IN @ir_year.

    SELECT * FROM zcds_jpat_sohsum
      INTO TABLE @i_view_sohsum
      WHERE publication_year IN @ir_year.

    SELECT po_qty,publication_year,publication_month
       FROM zcds_jpat_po_dt
       INTO TABLE @i_nbpodetail
       WHERE publication_year IN @ir_year AND
             po_type IN @ir_potype        AND
             tracking_no EQ @space        AND
             account_assignment IN @ir_acccat  AND
             doc_category IN @ir_bstyp.

    "Prepare Summarized Order data
    PERFORM f_summarized_order_data TABLES i_view_salsum i_nbpodetail .

    "Sort data acording to the Year and month
    SORT i_view_jdrsum  BY publication_year publication_month.
    SORT i_view_biossum BY publication_year publication_month.
    SORT i_view_posum   BY publication_year publication_month.
    SORT i_view_isohsm  BY publication_year publication_month.
    SORT i_view_sohsum  BY publication_year publication_month.

  ELSE.                 " Detail report data selection

    SELECT material,act_publication_date,po_type,tracking_no,po_qty,po_number,item,company_code,    " Fetch PO detail data
      created_date,document_date,vendor,plant,account_assignment,created_by,deletion_indicator
      FROM zcds_jpat_po_dt
      INTO TABLE @i_view_podetail
      WHERE material IN @s_matnr AND
            publication_year EQ @p_year AND
            publication_month EQ @p_month.

    SELECT media_issue,adustment_type,bios_quantity,act_publication_date            " Fetch BIOS Detail data
      FROM zcds_jpat_bios
      INTO TABLE  @i_view_biosdetail
      WHERE media_issue IN @s_matnr AND
            publication_year EQ @p_year AND
            publication_month EQ @p_month.

    SELECT media_issue,jdr_quantity,act_publication_date                            " Fetch JDR detail data
      FROM zcds_jpat_jdr
      INTO TABLE @i_view_jdrdetail
      WHERE media_issue IN @s_matnr AND
            publication_year EQ @p_year AND
            publication_month EQ @p_month.

    SELECT media_issue,document_type,document_type_desc,item_category,        " Fetch sales detail data
           target_qty,document_number,act_pub_date,item,su,reference_document,
           reference_document_type,subs_sales_order,refitm,condition_group_4,
           free_not_free,created_date,created_by,sales_organization,material_grp_5,rejection_reason,schedule_line_type
      FROM zcds_jpat_saldt
      INTO TABLE @i_view_salesdetail
      WHERE media_issue IN @s_matnr AND
            act_pub_year EQ @p_year AND
            act_pub_month EQ @p_month.

    SELECT media_issue,soh_qty,act_publication_date                                             " Fetch SOH detail data
      FROM zcds_jpat_soh
      INTO TABLE @i_view_sohdetail
      WHERE media_issue IN @s_matnr AND
            publication_year EQ @p_year AND
            publication_month EQ @p_month.

    " Convert data to character format to copy data to clipboard
    PERFORM f_podetail_convert.
    PERFORM f_biosdetail_convert.
    PERFORM f_jdrdetail_convert.
    PERFORM f_salesdetail_convert.
    PERFORM f_sohdetail_convert.

  ENDIF.

ENDFORM.

FORM f_call_screen.

  IF rb_sum = 'X'.
    CALL SCREEN 2000.   " Call Summary Screen
  ELSE.
    CALL SCREEN 3000.   " Call detail screen
  ENDIF.

ENDFORM.

FORM f_salesdetail_convert .

  DATA : lv_qty(16)        TYPE c,
         lv_createdate(10) TYPE c,
         lv_pubdate(10)    TYPE c.

  CLEAR : lv_qty,lv_createdate,lv_pubdate.

  CONCATENATE 'Material' 'Sales Doc Type' 'SaTy' 'ItCa' 'Order Quantity' 'Sales Doc.'
              'Act. Gd. Arrval Dat' 'Item' 'SU' 'Ref.doc.' 'Preceding Doc Category' 'Subs/Sales Order' 'RefItm' 'CGr4'
              'CGr4 Generic Desc' 'Created on' 'Created By' 'Sales Org' 'Material Group 5' 'Reason for Rejection' 'Schedule Line Type' INTO i_salesdetail_excel SEPARATED BY v_deli.
  APPEND i_salesdetail_excel.
  CLEAR i_salesdetail_excel.

  IF i_view_salesdetail IS NOT INITIAL.
    LOOP AT i_view_salesdetail ASSIGNING <gfs_salesdetail>.
      WRITE <gfs_salesdetail>-target_qty TO lv_qty.      " qty convert to char
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

      INTO i_salesdetail_excel SEPARATED BY v_deli.
      CONDENSE i_salesdetail_excel.
      APPEND i_salesdetail_excel.
      CLEAR i_salesdetail_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_podetail_convert.

  DATA : lv_qty(16)        TYPE c,
         lv_createdate(10) TYPE c,
         lv_pubdate(10)    TYPE c,
         lv_docdate(10)    TYPE c.

  CLEAR : lv_qty,lv_createdate,lv_pubdate,lv_docdate.

  CONCATENATE 'Material' 'Act. Goods Arrival Date' 'PO Type' 'TrackingNo' 'PO Quantity' 'Purch.Doc.' 'Item'
              'Co Cd' 'Created Date' 'Document Date' 'Vendor' 'Plnt' 'Account Assignment' 'Created By' 'Deletion Indicator'
               INTO i_podetail_excel SEPARATED BY v_deli.
  APPEND i_podetail_excel.
  CLEAR i_podetail_excel.

  IF i_view_podetail IS NOT INITIAL.
    LOOP AT i_view_podetail ASSIGNING <gfs_podetail>.
      WRITE <gfs_podetail>-po_qty TO lv_qty.      " qty convert to char
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

      INTO i_podetail_excel SEPARATED BY v_deli.
      CONDENSE i_podetail_excel.
      APPEND i_podetail_excel.
      CLEAR i_podetail_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_biosdetail_convert .

  DATA : lv_qty(16)     TYPE c,
         lv_pubdate(10) TYPE c.

  CLEAR : lv_qty,lv_pubdate.

  CONCATENATE 'Material' 'Adjustment Type' 'BIOS Qty' 'Act. Goods Arrival Date' INTO i_biosdetail_excel SEPARATED BY v_deli.
  APPEND i_biosdetail_excel.
  CLEAR i_biosdetail_excel.

  IF i_view_biosdetail IS NOT INITIAL.
    LOOP AT i_view_biosdetail ASSIGNING <gfs_biosdetail>.
      WRITE <gfs_biosdetail>-bios_quantity TO lv_qty.      " qty convert to char
      WRITE <gfs_biosdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_biosdetail>-media_issue
      <gfs_biosdetail>-adustment_type
      lv_qty
      lv_pubdate

      INTO i_biosdetail_excel SEPARATED BY v_deli.
      CONDENSE i_biosdetail_excel.
      APPEND i_biosdetail_excel.
      CLEAR i_biosdetail_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_jdrdetail_convert .

  DATA : lv_qty(16)     TYPE c,
         lv_pubdate(10) TYPE c.

  CLEAR : lv_qty,lv_pubdate.

  CONCATENATE 'Material' 'JDR Qty' 'Act. Gds. Arvl Dt' INTO i_jdrdetail_excel SEPARATED BY v_deli.
  APPEND i_jdrdetail_excel.
  CLEAR i_jdrdetail_excel.

  IF i_view_jdrdetail IS NOT INITIAL.
    LOOP AT i_view_jdrdetail ASSIGNING <gfs_jdrdetail>.
      WRITE <gfs_jdrdetail>-jdr_quantity TO lv_qty.      " qty convert to char
      WRITE <gfs_jdrdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_jdrdetail>-media_issue
      lv_qty
      lv_pubdate

      INTO i_jdrdetail_excel SEPARATED BY v_deli.
      CONDENSE i_jdrdetail_excel.
      APPEND i_jdrdetail_excel.
      CLEAR i_jdrdetail_excel.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_sohdetail_convert .

  DATA : lv_qty(16)     TYPE c,
         lv_pubdate(10) TYPE c.

  CLEAR : lv_qty,lv_pubdate.

  CONCATENATE 'Material' 'SOH Qty' 'Act. Gds. Arvl Dt' INTO i_sohdetail_excel SEPARATED BY v_deli.
  APPEND i_sohdetail_excel.
  CLEAR i_sohdetail_excel.

  IF i_view_sohdetail IS NOT INITIAL.
    LOOP AT i_view_sohdetail ASSIGNING <gfs_sohdetail>.
      WRITE <gfs_sohdetail>-soh_qty TO lv_qty.      " qty convert to char
      WRITE <gfs_sohdetail>-act_publication_date TO lv_pubdate MM/DD/YYYY.

      CONCATENATE <gfs_sohdetail>-media_issue
      lv_qty
      lv_pubdate

      INTO i_sohdetail_excel SEPARATED BY v_deli.
      CONDENSE i_sohdetail_excel.
      APPEND i_sohdetail_excel.
      CLEAR i_sohdetail_excel.
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

FORM f_summarized_order_data TABLES fp_i_view_salsum fp_i_nbpodetail.

  FIELD-SYMBOLS : <lfs_view_salsum> TYPE ty_salsum,
                  <lfs_nbpodetail>  TYPE ty_nbpodetail.

  DATA : lst_subs_total TYPE ty_sales_total,
         lst_nbposum    TYPE ty_nbposum.

  CONSTANTS : lc_subscription(12)  TYPE c VALUE 'Subscription',
              lc_author_copies(13) TYPE c VALUE 'Author Copies',
              lc_main_lables(11)   TYPE c VALUE 'Main Labels',
              lc_back_orders(11)   TYPE c VALUE 'Back Orders',
              lc_not_free(11)      TYPE c VALUE 'Others Free',
              lc_sales_order(11)   TYPE c VALUE 'Sales Order',
              lc_paid(4)           TYPE c VALUE 'Paid'.

  IF i_view_salsum IS NOT INITIAL.
    LOOP AT fp_i_view_salsum ASSIGNING <lfs_view_salsum>.

      "Subscription Total (Sales)
      IF <lfs_view_salsum>-subs_sales_order = lc_subscription AND <lfs_view_salsum>-back_main_orders = lc_main_lables
                                                              AND <lfs_view_salsum>-free_not_free = lc_paid.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_subs_total.
        CLEAR lst_subs_total.
      ENDIF.

      "Author copies (Main Lables) (Includes Subs and Sales Orders)
      IF <lfs_view_salsum>-free_not_free = lc_author_copies AND <lfs_view_salsum>-back_main_orders = lc_main_lables.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_author_copies_main.
        CLEAR lst_subs_total.
      ENDIF.

      "Author copies (Back Orders) (Includes Subs and Sales Orders)
      IF <lfs_view_salsum>-free_not_free = lc_author_copies AND <lfs_view_salsum>-back_main_orders = lc_back_orders.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_author_copies_back.
        CLEAR lst_subs_total.
      ENDIF.

      " Bulk orders (Main Lables Sales Orders) (EMLOs)
      IF <lfs_view_salsum>-free_not_free = lc_not_free AND <lfs_view_salsum>-back_main_orders = lc_main_lables.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_bulk_orders_main.
        CLEAR lst_subs_total.
      ENDIF.

      " Bulk orders (Back Orders Sales) (EBLOs)
      IF <lfs_view_salsum>-free_not_free = lc_not_free AND <lfs_view_salsum>-back_main_orders = lc_back_orders.
        lst_subs_total-act_pub_year   = <lfs_view_salsum>-act_pub_year.
        lst_subs_total-act_pub_month  = <lfs_view_salsum>-act_pub_month.
        lst_subs_total-target_qty     = <lfs_view_salsum>-target_qty.
        COLLECT lst_subs_total INTO is_bulk_orders_back.
        CLEAR lst_subs_total.
      ENDIF.

      " Back orders (Sales Data)
      IF <lfs_view_salsum>-back_main_orders = lc_back_orders AND <lfs_view_salsum>-free_not_free = lc_paid.
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

ENDFORM.
