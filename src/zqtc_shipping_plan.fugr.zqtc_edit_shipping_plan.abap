*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_EDIT_SHIPPING_PLAN
* PROGRAM DESCRIPTION: Edit Shipping Schedule
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/29/2016
* OBJECT ID: C075
* TRANSPORT NUMBER(S): ED2K903942
*----------------------------------------------------------------------*
FUNCTION zqtc_edit_shipping_plan.
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
*"      EXC_MISCELLANEOUS
*"----------------------------------------------------------------------

* Update Shipping Plan
  CALL FUNCTION 'ZQTC_SHIPPING_PLAN_UPDATE'
    EXPORTING
      im_med_issue          = im_med_issue            "Media Issue
      im_med_product        = im_med_product          "Media Product
      im_shipping_date      = im_shipping_date        "Delivery Date
      im_billing_date       = im_billing_date         "Billing Date
      im_status             = im_status               "Status of Shipping Planning
      im_xseparate_order    = im_xseparate_order      "Mark Separate Order
      im_sub_valid_from     = im_sub_valid_from       "Subscription Valid From
      im_sub_valid_until    = im_sub_valid_until      "Subscription Valid To
      im_gen_start_date     = im_gen_start_date       "Start Date for Order Generation
      im_gen_start_time     = im_gen_start_time       "Start Time for Order Generation
      im_gen_end_date       = im_gen_end_date         "End Date for Order Generation
    EXCEPTIONS
      exc_med_issue_missing = 1                       "Media Issue can not be determined
      exc_shp_sch_missing   = 2                       "Shipping Schedule is missing for the Media Issue
      exc_shp_sch_locked    = 3                       "Shipping Schedule is already locked
      error_message         = 4                       "Other Miscellaneous Errors
      OTHERS                = 5.
  IF sy-subrc NE 0.
    CASE sy-subrc.
      WHEN 1.
        RAISE exc_med_issue_missing.
      WHEN 2.
        RAISE exc_shp_sch_missing.
      WHEN 3.
        RAISE exc_shp_sch_locked.
      WHEN 4.
        RAISE exc_miscellaneous.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDIF.

ENDFUNCTION.
