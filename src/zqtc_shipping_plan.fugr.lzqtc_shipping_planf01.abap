*----------------------------------------------------------------------*
***INCLUDE LZQTC_SHIPPING_PLANF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_MED_ISSUE
*&---------------------------------------------------------------------*
*       Get the Media Issue
*----------------------------------------------------------------------*
*      -->FP_IM_MED_ISSUE    Media Issue (I/P)
*      -->FP_IM_MED_PRODUCT  Media Product
*      <--FP_LV_MED_ISSUE    Media Issue (O/P)
*----------------------------------------------------------------------*
FORM f_get_med_issue  USING    fp_im_med_issue   TYPE matnr
                               fp_im_med_product TYPE matnr
                      CHANGING fp_lv_med_issue   TYPE matnr.

  IF fp_im_med_issue IS INITIAL.
*   Determine Issue Template (Level-3)
    CALL FUNCTION 'ZQTC_DETERMINE_ISSUE_TEMPLATE'
      EXPORTING
        im_med_product         = fp_im_med_product
      IMPORTING
        ex_issue_template      = fp_lv_med_issue
      EXCEPTIONS
        exc_temp_issue_missing = 1
        OTHERS                 = 2.
    IF sy-subrc NE 0.
      CLEAR: fp_lv_med_issue.
    ENDIF.
  ELSE.
    fp_lv_med_issue = fp_im_med_issue.
  ENDIF.

  IF fp_lv_med_issue IS INITIAL.
*   Message: Media issue cannot be determined from entries (check your entries)
    MESSAGE e733(jksdorder)
    RAISING exc_med_issue_missing.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_SEL_FIELDS
*&---------------------------------------------------------------------*
*       Populate Selection Fields
*----------------------------------------------------------------------*
*      -->FP_LV_MED_ISSUE    Media Issue
*      -->FP_IM_MED_PRODUCT  Media Product
*----------------------------------------------------------------------*
FORM f_pop_sel_fields  USING    fp_lv_med_issue   TYPE matnr
                                fp_im_med_product TYPE matnr.

  DATA:
    lv_sf_product TYPE char30 VALUE '(SAPMJKSE01)PRODUCT[]',
    lv_sf_issue   TYPE char30 VALUE '(SAPMJKSE01)ISSUE[]',
    lv_sf_shipdat TYPE char30 VALUE '(SAPMJKSE01)SHIPDAT[]'.

  FIELD-SYMBOLS:
    <lir_product> TYPE rjksd_issue_range_tab,
    <lir_issue>   TYPE rjksd_issue_range_tab,
    <lir_shipdat> TYPE trgr_date.

* Media Product
  ASSIGN (lv_sf_product) TO <lir_product>.
  IF sy-subrc EQ 0.
    CLEAR: <lir_product>.
    PERFORM material_to_range IN PROGRAM sapmjkse01 IF FOUND
      USING fp_im_med_product
   CHANGING <lir_product>.
  ENDIF.

* Media Issue
  ASSIGN (lv_sf_issue) TO <lir_issue>.
  IF sy-subrc EQ 0.
    CLEAR: <lir_issue>.
    PERFORM material_to_range IN PROGRAM sapmjkse01 IF FOUND
      USING fp_lv_med_issue
   CHANGING <lir_issue>.
  ENDIF.

* Delivery Date
  ASSIGN (lv_sf_shipdat) TO <lir_shipdat>.
  IF sy-subrc EQ 0.
    CLEAR: <lir_shipdat>.
  ENDIF.

* Transaction Code (JKSE01)
  sy-tcode = con_edit_mode.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SHIP_SCH
*&---------------------------------------------------------------------*
*       Populate Shipping Schedule of the Media Issue
*----------------------------------------------------------------------*
*      -->FP_LI_MAINT_TAB       Maintenance data
*      -->FP_IM_SHIPPING_DATE   Delivery Date
*      -->FP_IM_BILLING_DATE    Billing Date
*      -->FP_IM_STATUS          Status of Shipping Planning
*      -->FP_IM_XSEPARATE_ORDER Mark Separate Order
*      -->FP_IM_SUB_VALID_FROM  Subscription Valid From
*      -->FP_IM_SUB_VALID_UNTIL Subscription Valid To
*      -->FP_IM_GEN_START_DATE  Start Date for Order Generation
*      -->FP_IM_GEN_START_TIME  Start Time for Order Generation
*      -->FP_IM_GEN_END_DATE    End Date for Order Generation
*----------------------------------------------------------------------*
FORM f_pop_ship_sch  USING    fp_li_maint_tab       TYPE t_line_tab
                              fp_im_shipping_date   TYPE jshipping_date
                              fp_im_billing_date    TYPE jbilling_date
                              fp_im_status          TYPE jnipstatus
                              fp_im_xseparate_order TYPE jseparate_order
                              fp_im_sub_valid_from  TYPE jsub_valid_from
                              fp_im_sub_valid_until TYPE jsub_valid_until
                              fp_im_gen_start_date  TYPE jgen_start_date
                              fp_im_gen_start_time  TYPE jgen_start_time
                              fp_im_gen_end_date    TYPE jgen_end_date.

  DATA:
    lv_maint_tab   TYPE char30 VALUE '(SAPMJKSE01)MAINTENANCE_TAB[]',
    lv_st_jksenip  TYPE char30 VALUE '(SAPMJKSE01)JKSEVNIPTYP',
    lv_st_*jksenip TYPE char30 VALUE '(SAPMJKSE01)*JKSEVNIPTYP',
    lv_vr_gs_rowid TYPE char30 VALUE '(SAPMJKSE01)GS_ROWID'.

  FIELD-SYMBOLS:
    <li_maint_tab> TYPE t_line_tab,
    <lst_jksenip>  TYPE jksevniptyp,
    <lst_*jksenip> TYPE jksevniptyp,
    <lv_rowid>     TYPE lvc_s_roid-row_id.

  READ TABLE fp_li_maint_tab ASSIGNING FIELD-SYMBOL(<lst_maint>) INDEX 1.
  IF sy-subrc NE 0.
*   Message: No shipping schedule records found for these entries
    MESSAGE e149(jseor)
    RAISING exc_shp_sch_missing.
  ELSE.
    IF <lst_maint>-editmode IS INITIAL.
*     Nessage: Shipping schedule records could not be locked!
      MESSAGE e087(zqtc_r2)
      RAISING exc_shp_sch_locked.
    ENDIF.

*   Maintenance Table
    ASSIGN (lv_maint_tab) TO <li_maint_tab>.
    IF sy-subrc EQ 0.
      <li_maint_tab> = fp_li_maint_tab[].
      UNASSIGN: <li_maint_tab>.
    ENDIF.

*   Line ID
    ASSIGN (lv_vr_gs_rowid) TO <lv_rowid>.
    IF sy-subrc EQ 0.
      <lv_rowid> = 1.
      UNASSIGN: <lv_rowid>.
    ENDIF.

*   Shipping Schedule and Type (Old Value)
    ASSIGN (lv_st_*jksenip) TO <lst_*jksenip>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <lst_maint> TO <lst_*jksenip>.
      UNASSIGN: <lst_*jksenip>.
    ENDIF.

*   Shipping Schedule and Type (New Value)
    ASSIGN (lv_st_jksenip) TO <lst_jksenip>.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING <lst_maint> TO <lst_jksenip>.

*     Delivery Date
      IF fp_im_shipping_date IS NOT INITIAL.
        <lst_jksenip>-shipping_date   = fp_im_shipping_date.
      ENDIF.
*     Billing Date
      IF fp_im_billing_date IS NOT INITIAL.
        <lst_jksenip>-billing_date    = fp_im_billing_date.
      ENDIF.
*     Status of Shipping Planning
      IF fp_im_status IS NOT INITIAL.
        <lst_jksenip>-status          = fp_im_status.
      ENDIF.
*     Mark Separate Order
      IF fp_im_xseparate_order IS NOT INITIAL.
        <lst_jksenip>-xseparate_order = fp_im_xseparate_order.
      ENDIF.
*     Subscription Valid From
      IF fp_im_sub_valid_from IS NOT INITIAL.
        <lst_jksenip>-sub_valid_from  = fp_im_sub_valid_from.
      ENDIF.
*     Subscription Valid To
      IF fp_im_sub_valid_until IS NOT INITIAL.
        <lst_jksenip>-sub_valid_until = fp_im_sub_valid_until.
      ENDIF.
*     Start Date for Order Generation
      IF fp_im_gen_start_date IS NOT INITIAL.
        <lst_jksenip>-gen_start_date  = fp_im_gen_start_date.
      ENDIF.
*     Start Time for Order Generation
      IF fp_im_gen_start_time IS NOT INITIAL.
        <lst_jksenip>-gen_start_time  = fp_im_gen_start_time.
      ENDIF.
*     End Date for Order Generation
      IF fp_im_gen_end_date IS NOT INITIAL.
        <lst_jksenip>-gen_end_date    = fp_im_gen_end_date.
      ENDIF.

      UNASSIGN: <lst_jksenip>.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_TRAN
*&---------------------------------------------------------------------*
*       Initialize Transaction
*----------------------------------------------------------------------*
*  -->  No Parameter
*  <--  No Parameter
*----------------------------------------------------------------------*
FORM f_init_tran .

  DATA:
    lv_obj_ref_maint TYPE char30 VALUE '(SAPMJKSE01)MAINTENANCE'.

  FIELD-SYMBOLS:
    <lo_maintenance> TYPE REF TO cl_gui_alv_grid.

* Admin object (ALV Grid) for the maintenance of Shipping Schedule
  ASSIGN (lv_obj_ref_maint) TO <lo_maintenance>.
  IF sy-subrc EQ 0 AND
     <lo_maintenance> IS BOUND.
*   Call Destructor method
    CALL METHOD <lo_maintenance>->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc EQ 0.
      CLEAR: <lo_maintenance>.
    ENDIF.
  ENDIF.

ENDFORM.
