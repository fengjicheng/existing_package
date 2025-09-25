FUNCTION zqtc_bp_custom_fields_zvic01_s.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(FLDGR) TYPE  TBZ3W-FLDGR
*"     REFERENCE(IN_STATUS) TYPE  BUS000FLDS-FLDSTAT
*"  EXPORTING
*"     REFERENCE(OUT_STATUS) TYPE  BUS000FLDS-FLDSTAT
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_BP_CUSTOM_FIELDSF01 (Sub-routines)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
* Set OUT_STATUS to
*   optional:        '.'
*   required:        '+'
*   display:         '*'
*   suppressed:      '-'
*
* IN_STATUS = SPACE means not specified
*
* FLDGR is the fieldgroup in BDT-Customizing
*----------------------------------------------------------------------*

  DATA:
    lcl_ka_bp_customer TYPE REF TO cvi_ka_bp_customer.

  DATA:
    lst_sales_area TYPE cvis_sales_area,
    lst_error      TYPE cvis_message.

  DATA:
    lv_activity TYPE bu_aktyp,
    lv_status   TYPE cvi_optional_status.

* check if strategy is active, if not -> set all customer fields to display mode
  lcl_ka_bp_customer = cvi_ka_bp_customer=>get_instance( ).
  IF lcl_ka_bp_customer->is_strategy_active(
       i_source_object = lcl_ka_bp_customer->ukm_object_partner
       i_target_object = lcl_ka_bp_customer->ukm_object_customer
      ) IS INITIAL.
    IF in_status <> c_fst_supp.
      out_status = c_fst_disp.
    ELSE.
      out_status = in_status.
    ENDIF.
    RETURN.
  ENDIF.

  IF cvi_bdt_adapter=>get_current_bp( ) IS NOT INITIAL.
    lv_status = cvi_bdt_adapter=>get_opt_customer_status( ).
    lst_sales_area = cvi_bdt_adapter=>get_current_sales_area( ).
    IF lst_sales_area IS NOT INITIAL AND cvi_bdt_adapter=>get_activity( ) <> cvi_bdt_adapter=>activity_display.

      IF cvi_bdt_adapter=>is_sales_area_new( lst_sales_area ) = abap_true.
        lv_activity = cvi_bdt_adapter=>activity_create.
      ELSE.
        lv_activity = cvi_bdt_adapter=>activity_change.
      ENDIF.

      cvi_bdt_adapter=>authority_check_cust_sales_org(
        EXPORTING
          iv_actvt        = lv_activity
          iv_sales_org    = lst_sales_area-sales_org
          iv_dist_channel = lst_sales_area-dist_channel
          iv_division     = lst_sales_area-division
        IMPORTING
          es_error = lst_error
      ).

    ENDIF.
  ELSE.
    out_status = in_status.
    RETURN.
  ENDIF.

  IF lv_status = cvi_bdt_adapter=>cv_status_created OR
     lv_status = cvi_bdt_adapter=>cv_status_optional_and_set OR
     lv_status = cvi_bdt_adapter=>cv_status_not_optional.

    CASE fldgr.

      WHEN c_fgr_0601.
        IF cvi_bdt_adapter=>get_current_sales_area( ) IS INITIAL.
          out_status = c_fst_opti.
        ELSE.
          IF in_status IS NOT INITIAL.
            out_status = in_status.
          ELSE.
            IF cvi_bdt_adapter=>get_activity( ) <> cvi_bdt_adapter=>activity_display.
              out_status = c_fst_opti.
            ELSE.
              out_status = c_fst_disp.
            ENDIF.
          ENDIF.
        ENDIF.

      WHEN OTHERS.
        IF cvi_bdt_adapter=>get_current_sales_area( ) IS INITIAL.
          IF in_status = c_fst_supp.
            out_status = in_status.
          ELSE.
            out_status = c_fst_disp.
          ENDIF.
        ELSEIF lst_error-is_error IS NOT INITIAL.
          IF in_status = c_fst_supp.
            out_status = in_status.
          ELSE.
            out_status = c_fst_disp.
          ENDIF.
        ELSE.
          out_status = in_status.
        ENDIF.

    ENDCASE.

  ELSEIF lv_status = cvi_bdt_adapter=>cv_status_optional.
    IF in_status = c_fst_supp.
      out_status = in_status.
    ELSE.
      out_status = c_fst_disp.
    ENDIF.
  ELSE.
    out_status = c_fst_supp.
  ENDIF.

ENDFUNCTION.
