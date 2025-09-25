*----------------------------------------------------------------------*
* Program name : ZQTCR_MED_ISS_R115_TOP (Inclde program)               *
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-29592                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 02/16/2021 , 03/24/2021                                *
* DESCRIPTION : Media Issue cockpit dashboard additional fields enhancement
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K925006                                             *
* REFERENCE NO: OTCM-45347                                             *
* DEVELOPER   : Thilina Dimantha (TDIMANTHA)                           *
* DATE        : 11/12/2021                                             *
* DESCRIPTION : Media Issue cockpit Performence improvement
*----------------------------------------------------------------------*
TABLES: zcds_mip_005, vbak, vbrk, vbap, mara, marc, jksesched, lfa1, jkseflow, jksenip,
        zcds_mip_004.

*&---------------------------------------------------------------------*
* ALV Declarations
*----------------------------------------------------------------------*
* Types Pools
TYPE-POOLS:
   slis.
* Types
TYPES:
  t_fieldcat TYPE slis_fieldcat_alv,
  t_layout   TYPE slis_layout_alv,
  BEGIN OF t_issue,
    contract       TYPE zcds_mip_006-contract,
    item           TYPE zcds_mip_006-item,
    media_issue    TYPE zcds_mip_006-media_issue,
    journal        TYPE zcds_mip_006-journal,
    rar_relevant   TYPE zcds_mip_006-rar_relevant,
    price_grp      TYPE zcds_mip_006-price_grp,
    price_grp_desc TYPE zcds_mip_006-price_grp_desc,
  END OF t_issue,

  BEGIN OF t_contract,
    contract               TYPE zcds_mip_005-contract,
    item                   TYPE zcds_mip_005-item,
    media_issue            TYPE zcds_mip_005-media_issue,
    journal                TYPE zcds_mip_005-journal,
    contract_start_date    TYPE zcds_mip_005-contract_start_date,
    contract_end_date      TYPE zcds_mip_005-contract_end_date,
    acceptance_date        TYPE zcds_mip_005-acceptance_date,
    req_cancellation_date  TYPE zcds_mip_005-req_cancellation_date,
    item_category          TYPE zcds_mip_005-item_category,
    cancel_reason          TYPE zcds_mip_005-cancel_reason,
    cancel_reason_desc     TYPE zcds_mip_005-cancel_reason_desc,
    reason_for_cancel      TYPE zcds_mip_005-reason_for_cancel,
    cancelled_orders       TYPE zcds_mip_005-cancelled_orders,
    overall_doc_status     TYPE zcds_mip_005-overall_doc_status,
    overall_status_desc    TYPE zcds_mip_005-overall_status_desc,
    credit_status          TYPE zcds_mip_005-credit_status,
    credit_status_desc     TYPE zcds_mip_005-credit_status_desc,
    contract_qty           TYPE zcds_mip_005-contract_qty,
    plant                  TYPE zcds_mip_005-plant,
    mat_grp_5_code         TYPE zcds_mip_005-mat_grp_5_code,
    mat_grp_5              TYPE zcds_mip_005-mat_grp_5,
    mat_grp_3_code         TYPE zcds_mip_005-mat_grp_3_code,
    mat_grp_3              TYPE zcds_mip_005-mat_grp_3,
    net_value_item         TYPE zcds_mip_005-net_value_item,
    currency               TYPE zcds_mip_005-currency,
    credit_block_flag      TYPE zcds_mip_005-credit_block_flag,
    cancel_res_flag        TYPE zcds_mip_005-cancel_res_flag,
    reason_for_cancel_desc TYPE zcds_mip_005-reason_for_cancel_desc,
    cancelled_orders_desc  TYPE zcds_mip_005-cancelled_orders_desc,
    cancel_ord_flag        TYPE zcds_mip_005-cancel_ord_flag,
  END OF t_contract,

  BEGIN OF t_podata,
    contract                  TYPE zcds_mip_004-contract,
    item                      TYPE zcds_mip_004-item,
    media_issue               TYPE zcds_mip_004-media_issue,
    journal                   TYPE zcds_mip_004-journal,
    assignment                TYPE zcds_mip_004-assignment,
    publication_date          TYPE zcds_mip_004-publication_date,
    actual_gi_date            TYPE zcds_mip_004-actual_gi_date,
    profit_center             TYPE zcds_mip_004-profit_center,
    material_status           TYPE zcds_mip_004-material_status,
    distr_chain_status        TYPE zcds_mip_004-distr_chain_status,
    issue_number              TYPE zcds_mip_004-issue_number,
    vol_copy_no               TYPE zcds_mip_004-vol_copy_no,
    year_number               TYPE zcds_mip_004-year_number,
    publication_type          TYPE zcds_mip_004-publication_type,
    release_order_created     TYPE zcds_mip_004-release_order_created,
    status                    TYPE zcds_mip_004-status,
    plan_status_desc          TYPE zcds_mip_004-plan_status_desc,
    planned_ro_from           TYPE zcds_mip_004-planned_ro_from,
    planned_ro_to             TYPE zcds_mip_004-planned_ro_to,
    release_order             TYPE zcds_mip_004-release_order,
    release_order_item        TYPE zcds_mip_004-release_order_item,
    po_number                 TYPE zcds_mip_004-po_number,
    po_item                   TYPE zcds_mip_004-po_item,
    po_type                   TYPE zcds_mip_004-po_type,
    po_del_ind                TYPE zcds_mip_004-po_del_ind,
    po_info_rec               TYPE zcds_mip_004-po_info_rec,
    po_qty                    TYPE zcds_mip_004-po_qty,
    delivery_number           TYPE zcds_mip_004-delivery_number,
    delivery_item             TYPE zcds_mip_004-delivery_item,
    purchase_requisition      TYPE zcds_mip_004-purchase_requisition,
    purchase_requisition_item TYPE zcds_mip_004-purchase_requisition_item,
    mat_doc                   TYPE zcds_mip_004-mat_doc,
    mat_doc_item              TYPE zcds_mip_004-mat_doc_item,
    mat_doc_type              TYPE zcds_mip_004-mat_doc_type,
    mat_doc_year              TYPE zcds_mip_004-mat_doc_year,
    mat_doc_date              TYPE zcds_mip_004-mat_doc_date,
    billing_block             TYPE zcds_mip_004-billing_block,
    billing_block_desc        TYPE zcds_mip_004-billing_block_desc,
    delivery_block            TYPE zcds_mip_004-delivery_block,
    delivery_block_desc       TYPE zcds_mip_004-delivery_block_desc,
    sales_org                 TYPE zcds_mip_004-sales_org,
    dist_channel              TYPE zcds_mip_004-dist_channel,
    division                  TYPE zcds_mip_004-division,
    doc_type                  TYPE zcds_mip_004-doc_type,
    sales_office              TYPE zcds_mip_004-sales_office,
    earned_amount             TYPE zcds_mip_004-earned_amount,
    billed_amount             TYPE zcds_mip_004-billed_amount,
    balance                   TYPE zcds_mip_004-balance,
    document_currency         TYPE zcds_mip_004-document_currency,
    contract_reason           TYPE zcds_mip_004-contract_reason,
    del_plant                 TYPE zcds_mip_004-del_plant,
    bill_block_flag           TYPE zcds_mip_004-bill_block_flag,
    del_block_flag            TYPE zcds_mip_004-del_block_flag,
    rel_ord_flag              TYPE zcds_mip_004-rel_ord_flag,
    unearned_flag             TYPE zcds_mip_004-unearned_flag,
    vendor                    TYPE zcds_mip_004-vendor,
    vendor_name               TYPE zcds_mip_004-vendor_name,
    delivery_date             TYPE zcds_mip_004-delivery_date,
    init_ship_date            TYPE zcds_mip_004-init_ship_date,
    dist_chain_status         TYPE zcds_mip_004-dist_chain_status,
    mi_ic_group               TYPE zcds_mip_004-mi_ic_group,
  END OF t_podata,

  BEGIN OF t_count,
    vbeln           TYPE zcds_mi_r115_2-vbeln,
    posnr           TYPE zcds_mi_r115_2-posnr,
    issue_count     TYPE zcds_mi_r115_2-issue_count,
    net_value       TYPE zcds_mi_r115_2-net_value,
    value_per_issue TYPE zcds_mi_r115_2-value_per_issue,
  END OF t_count.

*Field Symbols
FIELD-SYMBOLS:
  <fs_view>  TYPE zcds_mi_r115_rpt,
  <fs_issue> TYPE t_issue,
  <fs_contract> TYPE t_contract,
  <fs_podata> TYPE t_podata.

*DATA BEGIN OF it_sel_opt OCCURS 0.
*        INCLUDE STRUCTURE rsparams.
*DATA END   OF it_sel_opt.

* Workareas
DATA:
  w_fieldcat TYPE t_fieldcat,
  w_layout   TYPE t_layout,
  w_view     TYPE zcds_mi_r115_rpt.

* Internal Tables
DATA:
  i_fieldcat TYPE STANDARD TABLE OF t_fieldcat,
  i_view     TYPE STANDARD TABLE OF zcds_mi_r115_rpt,
  i_issue    TYPE STANDARD TABLE OF t_issue,
  i_podata   TYPE STANDARD TABLE OF t_podata,
  i_contract TYPE STANDARD TABLE OF t_contract,
  i_count    TYPE STANDARD TABLE OF t_count,
  i_tline    TYPE STANDARD TABLE OF tline.


*DATA: v_month    TYPE fcmnr,
*      v_year     TYPE gjahr,
*      v_date     TYPE sy-datum,
*      v_fdate    TYPE sy-datum,
*      v_tdate    TYPE sy-datum,
*      v_tax      TYPE zcds_stax_final-tax_amount,
*      v_othertax TYPE zcds_stax_final-other_taxes.

* Variables
DATA:
  v_count(10) TYPE n,
  v_vbeln     TYPE vbak-vbeln.

TYPES: BEGIN OF ty_status,
         status TYPE zcds_mi_r115_rpt-bill_block_flag,
       END OF ty_status.
*--------------------------------------------------------------*
*Data Declaration
*--------------------------------------------------------------*
DATA: wa_stat TYPE ty_status,
      it_stat TYPE TABLE OF ty_status.
DATA: it_return TYPE TABLE OF ddshretval,
      wa_return TYPE ddshretval.

CONSTANTS:
  lc_msg1 TYPE string VALUE 'Media Product or Media Issue or ',
*  lc_msg2 TYPE string VALUE 'Media Issue or ',
  lc_msg3 TYPE string VALUE 'Publishing Date or ',
  lc_msg4 TYPE string VALUE 'Initial Shipping Date or ',
  lc_msg5 TYPE string VALUE 'Delivery Date (JKSENIP)'.
*  lc_spr  TYPE thead-tdspras VALUE 'E',
*  lc_obj  TYPE thead-tdobject VALUE 'VBBP',
*  lc_ced  TYPE sy-datum VALUE '99991231',
*  lc_id2  TYPE thead-tdid VALUE '0001',
*  lc_obj2 TYPE thead-tdobject VALUE 'MVKE',
*  lc_dist TYPE vtweg VALUE '00'.


* BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
*

TYPES : BEGIN OF ty_header ,
          v_head(150) TYPE c, " Line(150) of type Character
        END OF ty_header.

TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_constant.

TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

DATA : i_constant TYPE STANDARD TABLE OF ty_constant.

DATA : i_header  TYPE STANDARD TABLE OF ty_header INITIAL SIZE 0,
       st_header TYPE ty_header.

DATA: st_variant TYPE disvariant. " Layout

DATA : i_alv_output    TYPE STANDARD TABLE OF zstqtc_alvoutput_r115 INITIAL SIZE 0,        " Data declaration for ALV output structure
       i_contract_data TYPE STANDARD TABLE OF zcds_con_r115 INITIAL SIZE 0,                " Data declaration for Contract data.
       i_claim_orders  TYPE STANDARD TABLE OF zcds_claim_r115 INITIAL SIZE 0,              " Data declaratin for claim order details
       i_dup_orders    TYPE STANDARD TABLE OF zcds_clm_dup INITIAL SIZE 0,                 " Data declaration for duplicate orders
       i_excel_output  TYPE STANDARD TABLE OF zstqtc_excel_output_r115 INITIAL SIZE 0.     " Data declaration for excel output

FIELD-SYMBOLS : <gfs_claim_orders> TYPE zcds_claim_r115.

CONSTANTS : c_errtype         TYPE char1   VALUE 'E',        "Error messege
            c_infotype        TYPE char1   VALUE 'I',        " Information messegae
            c_release_order   TYPE rvari_vnam VALUE 'RELEASE_ORDER',
            c_media_issue     TYPE rvari_vnam VALUE 'MEDIA_ISSUE',
            c_claims_order    TYPE rvari_vnam VALUE 'CLAIMS_ORDER',
            c_duplicate_count TYPE rvari_vnam VALUE 'DUPLICATE_COUNT',
            c_download        TYPE rvari_vnam VALUE '&DOWNLOAD',
            c_devid           TYPE zdevid   VALUE 'R115',
            c_layout          TYPE rvari_vnam VALUE 'LAYOUT',
            c_rowcount        TYPE rvari_vnam  VALUE 'ROW_COUNT',
* BOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *
            c_rowcount_bg     TYPE rvari_vnam  VALUE 'ROW_COUNT_BG'.
* EOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *
* EOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *

* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
DATA: v_ixml               TYPE REF TO if_ixml,                 " XML File generation related declaration
      v_document           TYPE REF TO if_ixml_document,
      v_element_root       TYPE REF TO if_ixml_element,
      v_attribute          TYPE REF TO if_ixml_attribute,
      v_element_properties TYPE REF TO if_ixml_element,
      v_styles             TYPE REF TO if_ixml_element,
      v_style              TYPE REF TO if_ixml_element,
      v_format             TYPE REF TO if_ixml_element,
      v_style1             TYPE REF TO if_ixml_element,
      v_worksheet          TYPE REF TO if_ixml_element,
      v_table              TYPE REF TO if_ixml_element,
      v_column             TYPE REF TO if_ixml_element,
      v_row                TYPE REF TO if_ixml_element,
      v_cell               TYPE REF TO if_ixml_element,
      v_data               TYPE REF TO if_ixml_element,
      v_streamfactory      TYPE REF TO if_ixml_stream_factory,
      v_ostream            TYPE REF TO if_ixml_ostream,
      v_renderer           TYPE REF TO if_ixml_renderer.

DATA : v_workbook     TYPE string,                            " Excel property declaration
       v_xmlns        TYPE string,
       v_urn          TYPE string,
       v_ss           TYPE string,
       v_xx           TYPE string,
       v_urn1         TYPE string,
       v_docname      TYPE string,
       v_value        TYPE string,
       v_author       TYPE string,
       v_xlstyles     TYPE string,
       v_xlstyle      TYPE string,
       v_id           TYPE string,
       v_header       TYPE string,
       v_font         TYPE string,
       v_bold         TYPE string,
       v_color        TYPE string,
       v_interior     TYPE string,
       v_pattern      TYPE string,
       v_solid        TYPE string,
       v_alignment    TYPE string,
       v_horizontal   TYPE string,
       v_vertical     TYPE string,
       v_center       TYPE string,
       v_left         TYPE string,
       v_xldata       TYPE string,
       v_xlworksheet  TYPE string,
       v_name         TYPE string,
       v_xltable      TYPE string,
       v_fullcolumns  TYPE string,
       v_fullrows     TYPE string,
       v_xlcolumn     TYPE string,
       v_width        TYPE string,
       v_xlrow        TYPE string,
       v_height       TYPE string,
       v_xlcell       TYPE string,
       v_styleid      TYPE string,
       v_xltype       TYPE string,
       v_string       TYPE string,
       i_xml_table    TYPE TABLE OF xml_line,
       v_rc           TYPE i,
       v_xml_size     TYPE i,
       v_xldata1      TYPE string,
       v_numberformat TYPE string,
       v_xlformat     TYPE string.

DATA : v_sender      TYPE soextreci1-receiver,       " email sender address
       v_receiver    TYPE soextreci1-receiver,       " email receiver address
       v_recname     TYPE bapibname-bapibname,       " email receiver address
* BOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *
       v_rowcount    TYPE i,                         " foreground row count
       v_extractrows TYPE i,                         " exact row count
       v_rowcount_bg TYPE i.                         " background row count
* EOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *

FIELD-SYMBOLS : <gfs_xml>   TYPE xml_line.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
