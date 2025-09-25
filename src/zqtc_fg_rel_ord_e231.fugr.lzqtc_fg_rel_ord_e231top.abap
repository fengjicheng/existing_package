FUNCTION-POOL ZQTC_FG_REL_ORD_E231.      "MESSAGE-ID ..
*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_FG_REL_ORD_E231TOP
* PROGRAM DESCRIPTION: TOP include for decleration
*
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 02/21/2020
* OBJECT ID:     E231/ERPM-12582
* TRANSPORT NUMBER(S): ED2K917590
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*

DATA: jksecontrindex TYPE jksecontrindex.
DATA : i_vbpa_addr TYPE STANDARD TABLE OF sadrvb,
       i_vbpa      TYPE STANDARD TABLE OF vbpavb,
       st_mvke TYPE mvke,
       st_knvv TYPE knvv,
       v_lifnr TYPE lifnr,
       v_vendor_maintained TYPE char1,
       v_first_print TYPE char1,
       v_distr_warehouse TYPE char1,
       v_prerequisite_fail TYPE char1,
       v_msg TYPE char200.
DATA : li_constants_e231 TYPE zcat_constants,
       lir_item_cat_grp_fp  TYPE RANGE OF salv_de_selopt_low,
       lir_item_cat_grp_wh  TYPE RANGE OF salv_de_selopt_low,
       lir_country       TYPE STANDARD TABLE OF shp_land1_range,
       lir_plant         TYPE STANDARD TABLE OF tds_rg_werks,
       lir_post_code     TYPE RANGE OF salv_de_selopt_low,
       lir_ship_cond     TYPE STANDARD TABLE OF shp_vsbed_range,
       lir_vendor        TYPE STANDARD TABLE OF fip_s_lifnr_range,
       lir_contract_type    TYPE STANDARD TABLE OF EDM_AUART_RANGE.
