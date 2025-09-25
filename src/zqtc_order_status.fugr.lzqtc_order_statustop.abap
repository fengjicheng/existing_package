*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K907542
* REFERENCE NO: ERP-3630
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 27-Jul-2017
* DESCRIPTION: Cancellation procedure logic validation has been changed
*              to validate the Canc. Proc maintained in ZCACONSTANT table.
*-----------------------------------------------------------------------*
FUNCTION-POOL zqtc_order_status.            "MESSAGE-ID ..

CONSTANTS: c_canc_proc   TYPE rvari_vnam VALUE 'CANC_PROC', " Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630
           c_devid_i0229 TYPE zdevid VALUE 'I0229'.         " Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630

DATA: i_status           TYPE ztqtc_ord_status,
      i_tvagt            TYPE ztqtc_tvagt,
      i_hdr_status       TYPE ztqtc_ord_hdr_status,
      i_item_vbup_status TYPE ztqtc_ord_item_status,
      i_hdr_cond         TYPE ztqtc_hdr_cond,
      i_itm_cond         TYPE ztqtc_itm_cond,
      i_zcaconst_ent     TYPE zcat_constants.  " Insert by PBANDLAPAL on 27-Jul-2017 for ERP-3630


DATA: gv_valid_date_flag   TYPE char1 VALUE abap_false,
      gv_content_date_flag TYPE char1 VALUE abap_false,
      gv_license_date_flag TYPE char1 VALUE abap_false,
      gv_sales_rep_flag    TYPE char1 VALUE abap_false.

* INCLUDE LZQTC_ORDER_STATUSD...             " Local class definition
