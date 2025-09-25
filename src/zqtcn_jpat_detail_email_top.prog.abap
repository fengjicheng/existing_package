*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_DETAIL_EMAIL_TOP
* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/20/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*

TYPE-POOLS: ixml.

TYPES : BEGIN OF ty_podetail,
          material             TYPE zcds_jpat_po_dt-material,
          act_publication_date TYPE zcds_jpat_po_dt-act_publication_date,
          po_type              TYPE zcds_jpat_po_dt-po_type,
          tracking_no          TYPE zcds_jpat_po_dt-tracking_no,
          po_qty               TYPE zcds_jpat_po_dt-po_qty,
          po_number            TYPE zcds_jpat_po_dt-po_number,
          item                 TYPE zcds_jpat_po_dt-item,
          company_code         TYPE zcds_jpat_po_dt-company_code,
          created_date         TYPE zcds_jpat_po_dt-created_date,
          document_date        TYPE zcds_jpat_po_dt-document_date,
          vendor               TYPE zcds_jpat_po_dt-vendor,
          plant                TYPE zcds_jpat_po_dt-plant,
          account_assignment   TYPE zcds_jpat_po_dt-account_assignment,
          created_by           TYPE zcds_jpat_po_dt-created_by,
          deletion_indicator   TYPE zcds_jpat_po_dt-deletion_indicator,
        END OF ty_podetail.

TYPES : BEGIN OF ty_biosdetail,
          media_issue          TYPE zcds_jpat_bios-media_issue,
          adustment_type       TYPE zcds_jpat_bios-adustment_type,
          bios_quantity        TYPE zcds_jpat_bios-bios_quantity,
          act_publication_date TYPE zcds_jpat_bios-act_publication_date,
        END OF ty_biosdetail.

TYPES : BEGIN OF ty_jdrdetail,
          media_issue          TYPE zcds_jpat_jdr-media_issue,
          jdr_quantity         TYPE zcds_jpat_jdr-jdr_quantity,
          act_publication_date TYPE zcds_jpat_jdr-act_publication_date,
          adustment_type       TYPE zcds_jpat_jdr-adustment_type,          " New Adding with TR :ED2K916403
        END OF ty_jdrdetail.

TYPES : BEGIN OF ty_salesdetail,
          media_issue             TYPE zcds_jpat_saldt-media_issue,
          document_type           TYPE zcds_jpat_saldt-document_type,
          document_type_desc      TYPE zcds_jpat_saldt-document_type_desc,
          item_category           TYPE zcds_jpat_saldt-item_category,
          target_qty              TYPE zcds_jpat_saldt-target_qty,
          document_number         TYPE zcds_jpat_saldt-document_number,
          act_pub_date            TYPE zcds_jpat_saldt-act_pub_date,
          item                    TYPE zcds_jpat_saldt-item,
          su                      TYPE zcds_jpat_saldt-su,
          reference_document      TYPE zcds_jpat_saldt-reference_document,
          reference_document_type TYPE zcds_jpat_saldt-reference_document_type,
          subs_sales_order        TYPE zcds_jpat_saldt-subs_sales_order,
          refitm                  TYPE zcds_jpat_saldt-refitm,
          condition_group_4       TYPE zcds_jpat_saldt-condition_group_4,
          free_not_free           TYPE zcds_jpat_saldt-free_not_free,
          created_date            TYPE zcds_jpat_saldt-created_date,
          created_by              TYPE zcds_jpat_saldt-created_by,
          sales_organization      TYPE zcds_jpat_saldt-sales_organization,
          material_grp_5          TYPE zcds_jpat_saldt-material_grp_5,
          rejection_reason        TYPE zcds_jpat_saldt-rejection_reason,
          schedule_line_type      TYPE zcds_jpat_saldt-schedule_line_type,
        END OF ty_salesdetail.

TYPES : BEGIN OF ty_sohdetail,
          media_issue          TYPE zcds_jpat_soh-media_issue,
          soh_qty              TYPE zcds_jpat_soh-soh_qty,
          act_publication_date TYPE zcds_jpat_soh-act_publication_date,
        END OF ty_sohdetail.

TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

TYPES: BEGIN OF ty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const.

*** Begin of changes for ED2K916403 ***
TYPES : BEGIN OF ty_isohdetail,
          media_issue          TYPE zcds_jpat_isoh-media_issue,
          inital_soh_quantity  TYPE zcds_jpat_isoh-inital_soh_quantity,
          act_publication_date TYPE zcds_jpat_isoh-act_publication_date,
        END OF ty_isohdetail.

TYPES : BEGIN OF ty_jrrdetail,
          media_issue          TYPE zcds_jpat_jrr-media_issue,
          adustment_type       TYPE zcds_jpat_jrr-adustment_type,
          jrr_quantity         TYPE zcds_jpat_jrr-jrr_quantity,
          act_publication_date TYPE zcds_jpat_jrr-act_publication_date,
          ordered_print_run    TYPE zcds_jpat_jrr-ordered_print_run,
        END OF ty_jrrdetail.

TYPES  : BEGIN OF ty_printerdis,
           media_issue  TYPE zcds_po_jrr_dt-media_issue,
           act_pub_date TYPE zcds_po_jrr_dt-act_pub_date,
           po_qty       TYPE zcds_po_jrr_dt-po_qty,
           jrr_qty      TYPE zcds_po_jrr_dt-jrr_qty,
           po_dispatch  TYPE zcds_po_jrr_dt-po_dispatch,
         END OF ty_printerdis.
*** End of Changes for ED2K916403/ED2K916608 ***

DATA : i_view_podetail    TYPE STANDARD TABLE OF ty_podetail INITIAL SIZE 0,           " Itab for PO detail data
       i_view_biosdetail  TYPE STANDARD TABLE OF ty_biosdetail INITIAL SIZE 0,         " Itab for BIOS detail data.
       i_view_jdrdetail   TYPE STANDARD TABLE OF ty_jdrdetail INITIAL SIZE 0,          " Itab for JDR Detail
       i_view_salesdetail TYPE STANDARD TABLE OF ty_salesdetail INITIAL SIZE 0,        " Itab for Sales Detail
       i_view_sohdetail   TYPE STANDARD TABLE OF ty_sohdetail INITIAL SIZE 0,          " Itab for SOH data
*** Begin of changes for ED2K916403 ***
       i_view_isohdetail  TYPE STANDARD TABLE OF ty_isohdetail INITIAL SIZE 0,         " Itab for Initial SOH data
       i_view_jrrdetail   TYPE STANDARD TABLE OF ty_jrrdetail INITIAL SIZE 0,          " Itab for JRR detail data
       i_view_printedis   TYPE STANDARD TABLE OF ty_printerdis INITIAL SIZE 0.
*** End of changes for ED2K916403 ***

FIELD-SYMBOLS : <gfs_podetail>    TYPE ty_podetail,                               " Field symbols for PO detail data
                <gfs_biosdetail>  TYPE ty_biosdetail,                             " Field symbols for BIOS detail data
                <gfs_jdrdetail>   TYPE ty_jdrdetail,                              " Field symbols for JDR detail data
                <gfs_salesdetail> TYPE ty_salesdetail,                            " Field symbols for sales detail data
                <gfs_sohdetail>   TYPE ty_sohdetail,                              " Field symbols for SOH detail data
*** Begin of changes for ED2K916403 ***
                <gfs_isohdetail>  TYPE ty_isohdetail,                             " Field symbols for Intial SOH detail data
                <gfs_jrrdetail>   TYPE ty_jrrdetail,                              " Field symbols for JRR detail data
                <gfs_prdisdetail> TYPE ty_printerdis.
*** End of changes for ED2K916403 ***

DATA: i_xml_table TYPE TABLE OF xml_line.
FIELD-SYMBOLS : <gfs_xml>   TYPE xml_line.

DATA : i_const TYPE STANDARD TABLE OF ty_const.

DATA : v_xml_size TYPE i,
       v_rc       TYPE i.

DATA: lv_date TYPE d.
DATA: lv_filename TYPE string.

DATA: v_ixml          TYPE REF TO if_ixml,
      v_streamfactory TYPE REF TO if_ixml_stream_factory,
      v_ostream       TYPE REF TO if_ixml_ostream,
      v_renderer      TYPE REF TO if_ixml_renderer,
      v_document      TYPE REF TO if_ixml_document.

DATA: v_element_root       TYPE REF TO if_ixml_element,
      v_attribute          TYPE REF TO if_ixml_attribute,
      v_element_properties TYPE REF TO if_ixml_element,
      v_element            TYPE REF TO if_ixml_element,
      v_worksheet          TYPE REF TO if_ixml_element,
      v_table              TYPE REF TO if_ixml_element,
      v_column             TYPE REF TO if_ixml_element,
      v_row                TYPE REF TO if_ixml_element,
      v_row_year           TYPE REF TO if_ixml_element,
      v_cell               TYPE REF TO if_ixml_element,
      v_data               TYPE REF TO if_ixml_element,
      v_styles             TYPE REF TO if_ixml_element,
      v_style              TYPE REF TO if_ixml_element,
      v_style1             TYPE REF TO if_ixml_element,
      v_format             TYPE REF TO if_ixml_element,
      v_border             TYPE REF TO if_ixml_element,
      v_num_rows           TYPE i.

DATA : v_value     TYPE string,
       v_month     TYPE string,
       v_type      TYPE string,
       v_text      TYPE char100,
       v_sheetname TYPE string,
       v_num      TYPE p.

DATA : v_sender   TYPE soextreci1-receiver,
       v_receiver TYPE soextreci1-receiver,
       v_recname  TYPE bapibname-bapibname.

CONSTANTS : c_devid   TYPE zdevid   VALUE 'R090',
            c_x       TYPE char1    VALUE 'X',        "Active records
            c_errtype TYPE char1    VALUE 'E'.

*** Begin of Constant declaration for Excel propeties and Values. ***
DATA : v_workbook    TYPE string,
       v_xmlns       TYPE string,
       v_ss          TYPE string,
       v_urn         TYPE string,
       v_urn1        TYPE string,
       v_docname     TYPE string,
       v_author      TYPE string,
       v_xlstyles    TYPE string,
       v_xx          TYPE string,
       v_xlstyle     TYPE string,
       v_id          TYPE string,
       v_header      TYPE string,
       v_font        TYPE string,
       v_bold        TYPE string,
       v_horizontal  TYPE string,
       v_vertical    TYPE string,
       v_center      TYPE string,
       v_alignment   TYPE string,
       v_xldata      TYPE string,
       v_height      TYPE string,
       v_xlcell      TYPE string,
       v_index       TYPE string,
       v_xlcolumn    TYPE string,
       v_xltype      TYPE string,
       v_width       TYPE string,
       v_xlworksheet TYPE string,
       v_string      TYPE string,
       v_name        TYPE string,
       v_xltable     TYPE string,
       v_interior    TYPE string,
       v_pattern     TYPE string,
       v_solid       TYPE string,
       v_left        TYPE string,
       v_color       TYPE string,
       v_styleid     TYPE string,
       v_fullcolumns TYPE string,
       v_fullrows    TYPE string,
       v_xlrow       TYPE string.

*** End of Constant declaration for Excel propeties and Values. ***
