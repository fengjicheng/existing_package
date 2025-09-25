*----------------------------------------------------------------------*
* Program name : ZQTCR_MED_ISS_R115_TOP_New (Inclde program)               *
* PROGRAM DESCRIPTION: Media Issue Cockpit
* DEVELOPER: Krishna Srikanth J (KSRIKANTH)
* CREATION DATE:   12 July, 2021
* OBJECT ID:  R115
* REFERENCE NO: OTCM-45437
* TRANSPORT NUMBER(S):ED2K924056
* DESCRIPTION : Media Issue cockpit dashboard selection-screen field changes
"        and copied from Old cockpit program*
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO :
* REFERENCE NO:
* DEVELOPER   :
* DATE        :
* DESCRIPTION :
*----------------------------------------------------------------------*
TABLES: zcds_mi_r115_rpt, vbak, vbrk, vbap, mara, marc, jksesched, lfa1, jkseflow, jksenip.

*&---------------------------------------------------------------------*
* ALV Declarations
*----------------------------------------------------------------------*
* Types Pools
TYPE-POOLS:
   slis.
* Types
TYPES:
  t_fieldcat TYPE slis_fieldcat_alv,
  t_layout   TYPE slis_layout_alv.

*Field Symbols
FIELD-SYMBOLS:
* BOC by Lahiru on 07/16/2021 with ED2K924056 *
*  <fs_view> TYPE zcds_mi_r115_rpt.
<fs_view> TYPE zstqtc_mainvew_output_r115_new.
* EOC by Lahiru on 07/16/2021 with ED2K924056 *

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
* BOC by Lahiru on 07/16/2021 with ED2K924056 *
*  i_view     TYPE STANDARD TABLE OF zcds_mi_r115_rpt,
  i_view     TYPE STANDARD TABLE OF zstqtc_mainvew_output_r115_new INITIAL SIZE 0,
* EOC by Lahiru on 07/16/2021 with ED2K924056 *
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
       END OF ty_constant,
       BEGIN OF ty_contract,
         contract             TYPE   zcds_con_r115-contract,
         item                 TYPE   zcds_con_r115-item,
         media_issue          TYPE   zcds_con_r115-media_issue,
         journal              TYPE   zcds_con_r115-journal,
         contract_created     TYPE   zcds_con_r115-contract_created,
         rejection_user       TYPE   zcds_con_r115-rejection_user,
         contract_soldto      TYPE   zcds_con_r115-contract_soldto,
         contract_soldto_name TYPE   zcds_con_r115-contract_soldto_name,
         contract_shipto      TYPE   zcds_con_r115-contract_shipto,
         contract_shipto_name TYPE   zcds_con_r115-contract_shipto_name,
         contract_shipto_ctry TYPE   zcds_con_r115-contract_shipto_ctry,
         invoice_number       TYPE   zcds_con_r115-invoice_number,
         invoice_item         TYPE   zcds_con_r115-invoice_item,
       END OF ty_contract.

TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

DATA : i_constant TYPE STANDARD TABLE OF ty_constant.

DATA : i_header  TYPE STANDARD TABLE OF ty_header INITIAL SIZE 0,
       st_header TYPE ty_header.

DATA: st_variant TYPE disvariant. " Layout

DATA : i_alv_output    TYPE STANDARD TABLE OF zstqtc_alvoutput_r115 INITIAL SIZE 0,        " Data declaration for ALV output structure
       i_contract_data TYPE STANDARD TABLE OF ty_contract INITIAL SIZE 0,                " Data declaration for Contract data.
***       i_contract_data TYPE STANDARD TABLE OF zcds_con_r115 INITIAL SIZE 0,                " Data declaration for Contract data.
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
            c_rowcount_bg     TYPE rvari_vnam  VALUE 'ROW_COUNT_BG',
            lc_yes            TYPE land1     VALUE 'YES',
            lc_no             TYPE land1     VALUE 'NO'.
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
DATA:ls_exbb TYPE shp_land1_range,
     s_exbb  TYPE shp_land1_range_t,
     ls_exdb TYPE shp_land1_range,
     s_exdb  TYPE shp_land1_range_t,
     ls_excb TYPE shp_land1_range,
     s_excb  TYPE shp_land1_range_t,
     ls_excc TYPE shp_land1_range,
     s_excc  TYPE shp_land1_range_t,
     ls_exro TYPE shp_land1_range,
     s_exro  TYPE shp_land1_range_t,
     ls_irel TYPE shp_land1_range,
     s_irel  TYPE shp_land1_range_t,
     ls_iamt TYPE shp_land1_range,
     s_iamt  TYPE shp_land1_range_t.
DATA: lv_exbb TYPE kna1-land1,
      lv_exdb TYPE kna1-land1,
      lv_excb TYPE kna1-land1,
      lv_excc TYPE kna1-land1,
      lv_exro TYPE kna1-land1,
      lv_irel TYPE kna1-land1,
      lv_iamt TYPE kna1-land1.
