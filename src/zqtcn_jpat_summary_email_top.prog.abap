*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_SUMMARY_EMAIL_TOP

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:
*
* Transport NO: ED2K916608
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/29/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
TYPE-POOLS: ixml.

TYPES: BEGIN OF ty_summary_data,
         field01(10),
         field02(61),
         field03(61),
         field04(61),
         field05(61),
         field06(61),
         field07(61),
         field08(61),
         field09(61),
         field10(61),
         field11(61),
         field12(61),
         field13(61),
         field14(61),
         field15(61),
         field16(61),
         field17(61),
         field18(61),
         field19(61),
         field20(61),
         field21(61),
         field22(61),
         field23(61),
         field24(61),
         field25(61),
         field26(61),
         field27(61),
         field28(61),
         field29(61),
         field30(61),
         field31(61),
         field32(61),
*** Begin of Change for  ED2K916403 ***
         field33(61),
         field34(61),
         field35(61),
         field36(61),
         field37(61),
         field38(61),
         field39(61),
*** End of Change for  ED2K916403 ***
       END OF ty_summary_data.

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

DATA : i_year  TYPE STANDARD TABLE OF ty_summary_data INITIAL SIZE 0,
       st_year TYPE ty_summary_data.

DATA : i_summary_data  TYPE STANDARD TABLE OF ty_summary_data.
FIELD-SYMBOLS :  <gfs_summary_data> TYPE ty_summary_data.

DATA : i_const TYPE STANDARD TABLE OF ty_const.

DATA : v_headername TYPE char61.

DATA: i_xml_table TYPE TABLE OF xml_line.
FIELD-SYMBOLS : <gfs_xml>   TYPE xml_line.

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

DATA : v_value TYPE string,
       v_month TYPE string,
       v_type  TYPE string,
       v_text  TYPE char100.

DATA : v_sender   TYPE soextreci1-receiver,
       v_receiver TYPE soextreci1-receiver,
       v_recname  TYPE bapibname-bapibname.

CONSTANTS : c_devid   TYPE zdevid   VALUE 'R090',
            c_x       TYPE char1    VALUE 'X',        "Active records
            c_errtype TYPE char1 VALUE 'E'.

*** Begin of Constant declaration for Excel propeties and Values. ***
DATA : v_workbook              TYPE string,
       v_xmlns                 TYPE string,
       v_ss                    TYPE string,
       v_urn                   TYPE string,
       v_urn1                  TYPE string,
       v_docname               TYPE string,
       v_author                TYPE string,
       v_xlstyles              TYPE string,
       v_xx                    TYPE string,
       v_xlstyle               TYPE string,
       v_id                    TYPE string,
       v_report_header         TYPE string,
       v_font                  TYPE string,
       v_bold                  TYPE string,
       v_size                  TYPE string,
       v_horizontal            TYPE string,
       v_vertical              TYPE string,
       v_center                TYPE string,
       v_alignment             TYPE string,
       v_xldata                TYPE string,
       v_height                TYPE string,
       v_xlcell                TYPE string,
       v_header                TYPE string,
       v_index                 TYPE string,
       v_xlcolumn              TYPE string,
       v_xltype                TYPE string,
       v_width                 TYPE string,
       v_number                TYPE string,
       v_weight                TYPE string,
       v_continuous            TYPE string,
       v_right                 TYPE string,
       v_position              TYPE string,
       v_xlborder              TYPE string,
       v_borders               TYPE string,
       v_xlworksheet           TYPE string,
       v_string                TYPE string,
       v_name                  TYPE string,
       v_sumreport             TYPE string,
       v_xltable               TYPE string,
       v_vstyle                TYPE string,
       v_interior              TYPE string,
       v_pattern               TYPE string,
       v_solid                 TYPE string,
       v_bottom                TYPE string,
       v_left                  TYPE string,
       v_xlformat              TYPE string,
       v_xlmonth               TYPE string,
       v_color                 TYPE string,
       v_dashboard_report      TYPE string,
       v_styleid               TYPE string,
       v_linestyle             TYPE string,
       v_mergeacross           TYPE string,
       v_numberformat          TYPE string,
       v_wraptext              TYPE string,
       v_fullcolumns           TYPE string,
       v_fullrows              TYPE string,
       v_header_year           TYPE string,
       v_data_sum              TYPE string,
       v_data_minus            TYPE string,
       v_data_sum_minus        TYPE string,
       v_data_minus_percentage TYPE string,
       v_data_percentage       TYPE string,
       v_xlrow                 TYPE string,
       v_top                   TYPE string.

*** End of Constant declaration for Excel propeties and Values. ***
