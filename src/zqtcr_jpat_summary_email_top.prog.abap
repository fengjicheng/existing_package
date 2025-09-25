*&---------------------------------------------------------------------*
*&  Include           ZQTCR_JPAT_SUMMARY_EMAIL_TOP
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
       END OF ty_summary_data.

TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

DATA : i_year  TYPE STANDARD TABLE OF ty_summary_data INITIAL SIZE 0,
       st_year TYPE ty_summary_data.

DATA : i_summary_data  TYPE STANDARD TABLE OF ty_summary_data.
FIELD-SYMBOLS :  <gfs_summary_data> TYPE ty_summary_data.


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

DATA : v_value     TYPE string,
       v_month     TYPE string,
       v_type      TYPE string,
       v_text(100) TYPE c.
