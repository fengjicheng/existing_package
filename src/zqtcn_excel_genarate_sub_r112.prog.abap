*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_EXCEL_GENARATE_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: Excel file genaration
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/01/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------**
TYPE-POOLS: ixml.

TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

" Data declaration for excel genaration XML DOM objects
DATA: lv_ixml          TYPE REF TO if_ixml,
      lv_streamfactory TYPE REF TO if_ixml_stream_factory,
      lv_ostream       TYPE REF TO if_ixml_ostream,
      lv_renderer      TYPE REF TO if_ixml_renderer,
      lv_document      TYPE REF TO if_ixml_document.

DATA: i_xml_table TYPE TABLE OF xml_line.
FIELD-SYMBOLS : <gfs_xml>   TYPE xml_line.

DATA : v_xml_size TYPE i,
       v_rc       TYPE i.

DATA: lv_element_root       TYPE REF TO if_ixml_element,
      lv_attribute          TYPE REF TO if_ixml_attribute,
      lv_element_properties TYPE REF TO if_ixml_element,
      lv_element            TYPE REF TO if_ixml_element,
      lv_worksheet          TYPE REF TO if_ixml_element,
      lv_table              TYPE REF TO if_ixml_element,
      lv_column             TYPE REF TO if_ixml_element,
      lv_row                TYPE REF TO if_ixml_element,
      lv_row_year           TYPE REF TO if_ixml_element,
      lv_cell               TYPE REF TO if_ixml_element,
      lv_data               TYPE REF TO if_ixml_element,
      lv_styles             TYPE REF TO if_ixml_element,
      lv_style              TYPE REF TO if_ixml_element,
      lv_style1             TYPE REF TO if_ixml_element,
      lv_style2             TYPE REF TO if_ixml_element,
      lv_format             TYPE REF TO if_ixml_element,
      lv_border             TYPE REF TO if_ixml_element,
      lv_num_rows           TYPE i.

*** Begin of Constant declaration for Excel propeties and Values. ***
DATA : lv_workbook     TYPE string,
       lv_xmlns        TYPE string,
       lv_ss           TYPE string,
       lv_urn          TYPE string,
       lv_urn1         TYPE string,
       lv_docname      TYPE string,
       lv_author       TYPE string,
       lv_xlstyles     TYPE string,
       lv_xx           TYPE string,
       lv_xlstyle      TYPE string,
       lv_id           TYPE string,
       lv_header       TYPE string,
       lv_font         TYPE string,
       lv_bold         TYPE string,
       lv_horizontal   TYPE string,
       lv_vertical     TYPE string,
       lv_center       TYPE string,
       lv_alignment    TYPE string,
       lv_xldata       TYPE string,
       lv_xldata_1     TYPE string,
       lv_height       TYPE string,
       lv_xlcell       TYPE string,
       lvv_index       TYPE string,
       lv_xlcolumn     TYPE string,
       lv_xltype       TYPE string,
       lv_width        TYPE string,
       lv_xlworksheet  TYPE string,
       lv_string       TYPE string,
       lv_name         TYPE string,
       lv_xltable      TYPE string,
       lv_interior     TYPE string,
       lv_pattern      TYPE string,
       lv_solid        TYPE string,
       lv_left         TYPE string,
       lv_color        TYPE string,
       lv_styleid      TYPE string,
       lv_fullcolumns  TYPE string,
       lv_fullrows     TYPE string,
       lv_xlrow        TYPE string,
       lv_value        TYPE string,
       lv_sheetname    TYPE string,
       lv_headername1  TYPE string,
       lv_headername2  TYPE string,
       lv_headername3  TYPE string,
       lv_headername4  TYPE string,
       lv_headername5  TYPE string,
       lv_headername6  TYPE string,
       lv_headername7  TYPE string,
       lv_headername8  TYPE string,
       lv_headername9  TYPE string,
       lv_headername10 TYPE string,
       lv_headername11 TYPE string,
       lv_headername12 TYPE string,
       lv_headername13 TYPE string,
       lv_headername14 TYPE string,
       lv_headername15 TYPE string,
       lv_headername16 TYPE string,
       lv_headername17 TYPE string,
       lv_headername18 TYPE string,
       lv_headername19 TYPE string,
       lv_headername20 TYPE string,
       lv_headername21 TYPE string,
       lv_headername22 TYPE string,
       lv_msgtext_i    TYPE string,
       lv_msgtext_e    TYPE string,
       lv_borders      TYPE string,
       lv_border_de    TYPE string,
       lv_position     TYPE string,
       lv_linestyle    TYPE string,
       lv_weight       TYPE string,
       lv_bottom       TYPE string,
       lv_continuous   TYPE string,
       lv_top          TYPE string,
       lv_right        TYPE string,
       lv_headername23 TYPE string,
       lv_headername24 TYPE string,
       lv_headername25 TYPE string,
       lv_headername26 TYPE string,
       lv_headername27 TYPE string,
       lv_headername28 TYPE string,
       lv_headername29 TYPE string,
       lv_headername30 TYPE string,
       lv_numberformat TYPE string,
       lv_xlformat     TYPE string,
       lv_xldata_2     TYPE string.

*** End of Constant declaration for Excel propeties and Values. ***

DATA : lv_date TYPE sy-datum,
       lv_time TYPE sy-uzeit.

CONSTANTS : lc_msgtype_s TYPE char1  VALUE 'S',
            lc_msgtype_e TYPE char1  VALUE 'E',
            lc_msgtype_i TYPE char1  VALUE 'I',
            lc_item      TYPE jcontractitem VALUE '000000'.


* Begin of assign  Excel properties to the variables.
lv_workbook = text-906.    "'Workbook'.
lv_xmlns    = text-907.    "'xmlns'.
lv_ss       = text-908.    "'ss'.
lv_urn      = text-909.    "'urn:schemas-microsoft-com:office:spreadsheet'.
lv_urn1     = text-910.    "'urn:schemas-microsoft-com:office:excel'.
lv_docname  = text-911.    "'Release_Order_Job_Run_Report'.
lv_author   = text-912.    "'Author'.
lv_xlstyles = text-913.    "'Styles'.
lv_xx       = text-914.    "'x'.
lv_xlstyle  = text-915.    "'Style'.
lv_id       = text-916.    "'ID'.
lv_header   = text-917.    "'Header'.
lv_font     = text-918.    "'Font'.
lv_bold     = text-919.    "'Bold'.
lv_horizontal = text-920.    "'Horizontal'.
lv_vertical = text-921.    "'Vertical'.
lv_center   = text-922.    "'Center'.
lv_alignment = text-923.    "'Alignment'.
lv_xldata   = text-924.    "'Data'
lv_height   = text-925.    "'Height'.
lv_xlcell   = text-926.    "'Cell'.
lvv_index    = text-927.    "'Index'.
lv_xlcolumn = text-928..   "'Column'.
lv_xltype   = text-929.    "'Type'.
lv_width    = text-930.    "'Width'.
lv_xlworksheet = text-931.   "'Worksheet'.
lv_string   = text-932.    "'String'.
lv_name     = text-933.    "'Name'.
lv_xltable  = text-934.    "'Table'.
lv_interior = text-935.    "'Interior'.
lv_pattern  = text-936.    "'Pattern'.
lv_solid    = text-937.    "'Solid'.
lv_left     = text-938.    "'Left'.
lv_color    = text-939.    "'Color'.
lv_styleid     = text-940.   "'StyleID'.
lv_fullcolumns = text-941.   "'FullColumns'.
lv_fullrows    = text-942.   "'FullRows'.
lv_xlrow     = text-943.    "'Row'.
lv_value     = sy-uname.
lv_sheetname = text-944.    "'Release Order Job Run Report'.
lv_headername1 = text-945.   " 'Potential Value of Release Order'.
lv_headername2 = text-946.   " 'Document Currency'.
lv_headername3 = text-947.   " 'Media Product'.
lv_headername4 = text-948.   " 'Media Issue'.
lv_headername5 = text-949.   " 'Journal code'.
lv_headername6 = text-950.   " 'Sales Organization'.
lv_headername7 = text-951.   " 'Distribution Channel'.
lv_headername8 = text-952.   " 'Division'.
lv_headername9 = text-953.   " 'Sales Office'.
lv_headername10 = text-954.  "  'Contract'.
lv_headername11 = text-955.  "  'Contract Item Number'.
lv_headername12 = text-956.  "  'Sold-to Party'.
lv_headername13 = text-957.  "  'Sold-to Party Name and Address'.
lv_headername14 = text-958.  "  'Ship-to Party'.
lv_headername15 = text-959.  "  'Name and Address of Ship-to Party'.
lv_headername16 = text-960.  "  'Country'.
lv_headername17 = text-961.  "  'Postal Code'.
lv_headername18 = text-962.  "  'Distributor'.
lv_headername19 = text-963.  "  'Plant'.
lv_headername20 = text-964.  "  'Ship Method'.
lv_headername21 = text-965.  "  'Error Message'.
lv_headername22 = text-966.  "  'Message Type'.
lv_msgtext_i  = text-978.    "  'Information
lv_msgtext_e  = text-979.    "  'error
lv_borders   = text-985.     " Borders
lv_border_de = text-986.     " Border
lv_position  = text-987.     " Position
lv_linestyle = text-988.     " Line Style
lv_weight    = text-989.     " Weight
lv_bottom    = text-990.     " Bottom
lv_continuous = text-991.    " Countinuous
lv_top    = text-992.        " Top
lv_right  = text-993.        " Right
lv_xldata_1 = text-994.    "'total'.
lv_headername23 = text-801.  " Message Class
lv_headername24 = text-802.  " Message Number
lv_headername25 = text-803.  " Phase Model
lv_headername26 = text-804.  " Phase Number
lv_headername27 = text-805.  " Problem Processed
lv_xldata_2  =  text-806.  " Normal
lv_xlformat   =  text-807.  " Excel format
lv_numberformat = text-808.  " number format
* End of assign  Excel properties to the variables.


*************************************************************
***** Begin of create work book & properties ****

"Creating a ixml Factory
lv_ixml = cl_ixml=>create( ).

"Creating the DOM Object Model
lv_document = lv_ixml->create_document( ).

"Create Root Node 'Workbook'
lv_element_root  = lv_document->create_simple_element( name = lv_workbook  parent = lv_document ).
lv_element_root->set_attribute( name = lv_xmlns  value = lv_urn ).

lv_attribute = lv_document->create_namespace_decl( name = lv_ss  prefix = lv_xmlns  uri = lv_urn ).
lv_element_root->set_attribute_node( lv_attribute ).

lv_attribute = lv_document->create_namespace_decl( name = lv_xx  prefix = lv_xmlns  uri = lv_urn1 ).
lv_element_root->set_attribute_node( lv_attribute ).

"Create node for document properties.
lv_element_properties = lv_document->create_simple_element( name = lv_docname  parent = lv_element_root ).
lv_value = sy-uname.
lv_document->create_simple_element( name = lv_author  value = lv_value  parent = lv_element_properties  ).

***** end of create work book & properties ****
*************************************************************

lv_styles = lv_document->create_simple_element( name = lv_xlstyles  parent = lv_element_root  ).
***********************************************************
*** Begin of Style for header ****
"Styles

lv_style  = lv_document->create_simple_element( name = lv_xlstyle   parent = lv_styles  ).
lv_style->set_attribute_ns( name = lv_id  prefix = lv_ss  value = lv_header ).

lv_format  = lv_document->create_simple_element( name = lv_font  parent = lv_style  ).
lv_format->set_attribute_ns( name = lv_bold  prefix = lv_ss  value = '0' ).
lv_format->set_attribute_ns( name = lv_color  prefix = lv_ss  value = '#000000' ).

lv_format  = lv_document->create_simple_element( name = lv_interior parent = lv_style  ).
lv_format->set_attribute_ns( name = lv_color   prefix = lv_ss  value = '#C0C0C0' ).
lv_format->set_attribute_ns( name = lv_pattern prefix = lv_ss  value = lv_solid ).

lv_format  = lv_document->create_simple_element( name = lv_alignment  parent = lv_style  ).
lv_format->set_attribute_ns( name = lv_vertical  prefix = lv_ss  value = lv_center ).
lv_format->set_attribute_ns( name = lv_horizontal  prefix = lv_ss  value = lv_left ).

lv_border  = lv_document->create_simple_element( name = lv_borders  parent = lv_style ).
lv_format  = lv_document->create_simple_element( name = lv_border_de   parent = lv_border  ).
lv_format->set_attribute_ns( name = lv_position  prefix = lv_ss  value = lv_bottom ).
lv_format->set_attribute_ns( name = lv_linestyle  prefix = lv_ss  value = lv_continuous ).
lv_format->set_attribute_ns( name = lv_weight  prefix = lv_ss  value = '1' ).

lv_format  = lv_document->create_simple_element( name = lv_border_de   parent = lv_border  ).
lv_format->set_attribute_ns( name = lv_position  prefix = lv_ss  value = lv_left ).
lv_format->set_attribute_ns( name = lv_linestyle  prefix = lv_ss  value = lv_continuous ).
lv_format->set_attribute_ns( name = lv_weight  prefix = lv_ss  value = '1' ).

lv_format  = lv_document->create_simple_element( name = lv_border_de   parent = lv_border  ).
lv_format->set_attribute_ns( name = lv_position  prefix = lv_ss  value = lv_top ).
lv_format->set_attribute_ns( name = lv_linestyle  prefix = lv_ss  value = lv_continuous ).
lv_format->set_attribute_ns( name = lv_weight  prefix = lv_ss  value = '1' ).

lv_format  = lv_document->create_simple_element( name = lv_border_de   parent = lv_border  ).
lv_format->set_attribute_ns( name = lv_position  prefix = lv_ss  value = lv_right ).
lv_format->set_attribute_ns( name = lv_linestyle  prefix = lv_ss  value = lv_continuous ).
lv_format->set_attribute_ns( name = lv_weight  prefix = lv_ss  value = '1' ).
*** End of Style for header ****
***********************************************************

***********************************************************
* Begin of Style for total ****
lv_style1  = lv_document->create_simple_element( name = lv_xlstyle   parent = lv_styles  ).
lv_style1->set_attribute_ns( name = lv_id  prefix = lv_ss  value = lv_xldata ).

lv_format  = lv_document->create_simple_element( name = lv_font  parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_bold  prefix = lv_ss  value = '1' ).

lv_format  = lv_document->create_simple_element( name = lv_numberformat   parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_xlformat   prefix = lv_ss  value = '#,##0' ).

lv_format  = lv_document->create_simple_element( name = lv_interior parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_color   prefix = lv_ss  value = '#FFFF00' ).
lv_format->set_attribute_ns( name = lv_pattern prefix = lv_ss  value = lv_solid ).
* End of Style for Total ****

* Begin of Style for information & Error sub total ****
lv_style1  = lv_document->create_simple_element( name = lv_xlstyle   parent = lv_styles  ).
lv_style1->set_attribute_ns( name = lv_id  prefix = lv_ss  value = lv_xldata_1 ).

lv_format  = lv_document->create_simple_element( name = lv_font  parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_bold  prefix = lv_ss  value = '1' ).

lv_format  = lv_document->create_simple_element( name = lv_numberformat   parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_xlformat   prefix = lv_ss  value = '#,##0' ).

lv_format  = lv_document->create_simple_element( name = lv_interior parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_color   prefix = lv_ss  value = '#FFFF99' ).
lv_format->set_attribute_ns( name = lv_pattern prefix = lv_ss  value = lv_solid ).
*** End of Style information & Error sub total ****

* Begin of Style for details ****
lv_style1  = lv_document->create_simple_element( name = lv_xlstyle   parent = lv_styles  ).
lv_style1->set_attribute_ns( name = lv_id  prefix = lv_ss  value = lv_xldata_2 ).

lv_format  = lv_document->create_simple_element( name = lv_numberformat   parent = lv_style1  ).
lv_format->set_attribute_ns( name = lv_xlformat   prefix = lv_ss  value = '#,##0' ).
*** End of Style information & Error sub total ****
***********************************************************

*************************************************************
***** Begin of create Worksheet ****
lv_worksheet = lv_document->create_simple_element( name = lv_xlworksheet  parent = lv_element_root ).
lv_worksheet->set_attribute_ns( name = lv_name  prefix = lv_ss  value = lv_sheetname ).
***** End of create Worksheet ****
*************************************************************


*************************************************************
***** Begin of Build Table****
" Table
lv_table = lv_document->create_simple_element( name = lv_xltable  parent = lv_worksheet ).
lv_table->set_attribute_ns( name = lv_fullcolumns  prefix = lv_xx  value = '1' ).
lv_table->set_attribute_ns( name = lv_fullrows     prefix = lv_xx  value = '1' ).
***** End of Build Table ****
*************************************************************


*************************************************************
***** Begin of Column Formatting ****

" Contract
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Contract Item Number
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Media Issue
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Error Message
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Sales Organization
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Distribution Channel
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Division
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Sales Office
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Sold-to Party
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Sold-to Party Name and Address
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Ship-to Party
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Name and Address of Ship-to Party
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Potential Value of Release Order
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Document Currency
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Media Product
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Journal code
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Country
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Postal Code
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Distributor
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Plant
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Ship Method
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).

" Message Type
lv_column = lv_document->create_simple_element( name =  lv_xlcolumn  parent = lv_table ).
lv_column->set_attribute_ns( name = lv_width  prefix = lv_ss  value = '100' ).
***** End of Column Formatting ****
*************************************************************


*************************************************************
***** Begin of header Column formatting****
lv_row = lv_document->create_simple_element( name = lv_xlrow  parent = lv_table ).
lv_row->set_attribute_ns( name = lv_height  prefix = lv_ss  value = '20' ).
***** End of header Column formatting ****
*************************************************************


*************************************************************
***** Begin of Build header name****

" Contract
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername10  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Contract Item Number
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername11  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Media Issue
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername4  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Error Message
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername21  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Sales Organization
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername6  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Distribution Channel
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername7  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Division
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername8  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Sales Office
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername9  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Sold-to Party
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername12  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Sold-to Party Name and Address
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername13  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Ship-to Party
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername14  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Name and Address of Ship-to Party
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername15  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Potential Value of Release Order
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername1  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Document Currency
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername2  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Media Product
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername3  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Journal code
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername5  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Country
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername16  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Postal Code
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername17  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Distributor
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername18  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Plant
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername19  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Ship Method
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername20  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

" Message Type
lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_header ).
lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_headername22  parent = lv_cell ).
lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss value = lv_string ).

***** End of Build header name ****
*************************************************************


" Fill data to the excel
LOOP AT li_bg_detail ASSIGNING FIELD-SYMBOL(<lfs_fill_data>).

  lv_row = lv_document->create_simple_element( name = lv_xlrow  parent = lv_table ).

  " Contract
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-contract.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Contract Item
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-item.
  CONDENSE lv_value.
  " Clear default value '000000'
  IF lv_value = lc_item.
    CLEAR lv_value.
  ENDIF.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Media Issue
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-issue.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Error Message
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-msg.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Sales Organization
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-vkorg.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Distribution Channel
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-vtweg.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Division
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-spart.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Sales Office
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-vkbur.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Sold-to Party
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-ag.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Sold-to Party Name and Address
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-name_ag.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Ship-to Party
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-we.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Name and Address of Ship-to Party
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-name_we.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Potential Value of Release Order
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_2 ).
  ENDIF.
  lv_value = <lfs_fill_data>-netwr.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Document currency
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-waerk.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Media Product
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-matnr.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Journal code
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-identcode.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Country
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-country.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Postal Code
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-postal_code.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Distributor
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-vendor.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Plant
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-plant.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Ship Method
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  lv_value = <lfs_fill_data>-ship_method.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

  " Message Type
  lv_cell = lv_document->create_simple_element( name = lv_xlcell  parent = lv_row ).
  IF sy-tabix EQ 1.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_i.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSEIF <lfs_fill_data>-msg IS INITIAL AND <lfs_fill_data>-msgty = lc_msgtype_e.
    lv_cell->set_attribute_ns( name = lv_styleid  prefix = lv_ss  value = lv_xldata_1 ).
  ELSE.
    " without applying any style and continue
  ENDIF.
  IF <lfs_fill_data>-msgty = lc_msgtype_i.      " Messege type eq to I, then assign the decription
    lv_value = lv_msgtext_i.
  ELSEIF <lfs_fill_data>-msgty = lc_msgtype_e.  " Messege type eq to E, then assign the description
    lv_value = lv_msgtext_e.
  ENDIF.
  CONDENSE lv_value.
  lv_data = lv_document->create_simple_element( name = lv_xldata  value = lv_value   parent = lv_cell ).
  lv_data->set_attribute_ns( name = lv_xltype  prefix = lv_ss  value = lv_string ).

ENDLOOP.

*************************************************************
***** Begin of genarate XML file****

* Creating a Stream Factory
lv_streamfactory = lv_ixml->create_stream_factory( ).

* Connect Internal XML Table to Stream Factory
lv_ostream = lv_streamfactory->create_ostream_itable( table = i_xml_table ).

* Rendering the Document
lv_renderer = lv_ixml->create_renderer( ostream  = lv_ostream  document = lv_document ).
v_rc = lv_renderer->render( ).

* Saving the XML Document
v_xml_size = lv_ostream->get_num_written_raw( ).

***** End of genarate XML file ****
*************************************************************
