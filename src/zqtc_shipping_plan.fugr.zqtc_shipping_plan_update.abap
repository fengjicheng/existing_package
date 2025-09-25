*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SHIPPING_PLAN_UPDATE
* PROGRAM DESCRIPTION: Edit Shipping Schedule
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/29/2016
* OBJECT ID: C075
* TRANSPORT NUMBER(S): ED2K903942
*----------------------------------------------------------------------*
FUNCTION zqtc_shipping_plan_update.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MED_ISSUE) TYPE  JKSENIP-ISSUE OPTIONAL
*"     REFERENCE(IM_MED_PRODUCT) TYPE  JKSENIP-PRODUCT
*"     REFERENCE(IM_SHIPPING_DATE) TYPE  JKSENIP-SHIPPING_DATE OPTIONAL
*"     REFERENCE(IM_BILLING_DATE) TYPE  JKSENIP-BILLING_DATE OPTIONAL
*"     REFERENCE(IM_STATUS) TYPE  JKSENIP-STATUS OPTIONAL
*"     REFERENCE(IM_XSEPARATE_ORDER) TYPE  JKSENIP-XSEPARATE_ORDER
*"       OPTIONAL
*"     REFERENCE(IM_SUB_VALID_FROM) TYPE  JKSENIP-SUB_VALID_FROM
*"       OPTIONAL
*"     REFERENCE(IM_SUB_VALID_UNTIL) TYPE  JKSENIP-SUB_VALID_UNTIL
*"       OPTIONAL
*"     REFERENCE(IM_GEN_START_DATE) TYPE  JKSENIP-GEN_START_DATE
*"       OPTIONAL
*"     REFERENCE(IM_GEN_START_TIME) TYPE  JKSENIP-GEN_START_TIME
*"       OPTIONAL
*"     REFERENCE(IM_GEN_END_DATE) TYPE  JKSENIP-GEN_END_DATE OPTIONAL
*"  EXCEPTIONS
*"      EXC_MED_ISSUE_MISSING
*"      EXC_SHP_SCH_MISSING
*"      EXC_SHP_SCH_LOCKED
*"----------------------------------------------------------------------

  DATA:
    lv_med_issue TYPE matnr.

  DATA:
    li_maint_tab TYPE t_line_tab.

* Get the Media Issue
  PERFORM f_get_med_issue  USING    im_med_issue
                                    im_med_product
                           CHANGING lv_med_issue.

* Initialize the screen / transaction (Standard Logic)
  PERFORM init_0100        IN PROGRAM sapmjkse01 IF FOUND.

* Populate Selection Fields (Custom Logic)
  PERFORM f_pop_sel_fields USING    lv_med_issue
                                    im_med_product.

* Execute selection (Standard Logic)
  PERFORM selection        IN PROGRAM sapmjkse01 IF FOUND
                           CHANGING li_maint_tab.

* Populate Shipping Schedule of the Media Issue (Custom Logic)
  PERFORM f_pop_ship_sch   USING li_maint_tab
                                 im_shipping_date
                                 im_billing_date
                                 im_status
                                 im_xseparate_order
                                 im_sub_valid_from
                                 im_sub_valid_until
                                 im_gen_start_date
                                 im_gen_start_time
                                 im_gen_end_date.

* Validate Input data (Standard Logic)
  PERFORM check_data       IN PROGRAM sapmjkse01 IF FOUND.

* Transfer data (Standard Logic)
  PERFORM modify_data      IN PROGRAM sapmjkse01 IF FOUND.

* Save changes to the database (Standard Logic)
  PERFORM save             IN PROGRAM sapmjkse01 IF FOUND.

* Initialize all internal fields of shipping planning (Standard Logic)
  PERFORM clear_all_fields IN PROGRAM sapmjkse01 IF FOUND.

* Initialize Transaction (Custom Logic)
  PERFORM f_init_tran.

ENDFUNCTION.
