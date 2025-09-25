*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCE_REDET_RENEWAL_PROFILE
* PROGRAM DESCRIPTION: Program to re-determine Renewal Profile
* for selected Orders
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-21
* OBJECT ID:E095 (CR# ERP-6293)
* TRANSPORT NUMBER(S): ED2K912365
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
REPORT zqtce_redet_renewal_profile NO STANDARD PAGE HEADING
       LINE-COUNT 1023 MESSAGE-ID zqtc_r2.

INCLUDE zqtcn_redet_renewal_prof_top. " " Include ZQTCN_REDET_RENEWAL_PROF_TOP
INCLUDE zqtcn_redet_renewal_prof_sel. " " Include ZQTCN_REDET_RENEWAL_PROF_SEL
INCLUDE zqtcn_redet_renewal_prof_form. " " Include ZQTCN_REDET_RENEWAL_PROF_FORM


INITIALIZATION.

* Initialize all global variables
  PERFORM f_initialize_variables.

*iniitialize the selection screen date
  PERFORM f_default_date_range.

*fetch the constant data from ZCACONSTANT table
PERFORM f_get_constant_data CHANGING i_constant.

**Validate selection screen sales org.
AT SELECTION-SCREEN ON s_vkorg.
  PERFORM f_validate_sales_org.

AT SELECTION-SCREEN .
* validate Order
  PERFORM f_validate_order.

START-OF-SELECTION.

*Fetch order Header / Item and partner details
  PERFORM f_fetch_hdr_itm_details USING i_constant
                                  CHANGING i_hdr_itm_data
                                           i_renewal_plan
                                           i_vbpa_data
                                           i_veda_data
                                           i_vbkd_data.

* fetch Renewal determination paramters, notification paramters
* other renewal determination details
  PERFORM f_fetch_renewal_det_details CHANGING i_renewal_det
                                               i_pay_key_typ
                                               i_renwl_p_det
                                               i_notif_p_det.

**Populate the final table for processing
  PERFORM f_populate_final_table USING i_hdr_itm_data
                                       i_renewal_plan
                                       i_vbpa_data
                                       i_pay_key_typ
                                       i_veda_data
                                       i_vbkd_data
                               CHANGING i_final.

END-OF-SELECTION.

*Build Field catelouge for ALV display
  PERFORM f_build_field_catalog CHANGING i_fcat.

* Display ALV Report
  PERFORM f_display_alv USING i_fcat
                              i_final.
