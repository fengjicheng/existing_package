*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_SUMMARY_EMAIL_SUB

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION: ERPM-1825

* Transport NO: ED2K916608
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/28/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*

FORM f_send_mail.

  DATA: li_objpack  TYPE STANDARD TABLE OF sopcklsti1,
        lst_objpack TYPE sopcklsti1.

  DATA: li_objhead  TYPE STANDARD TABLE OF solisti1,
        lst_objhead TYPE solisti1.

  DATA: li_objbin  TYPE STANDARD TABLE OF solix,
        lst_objbin TYPE solix.

  DATA: li_objtxt  TYPE STANDARD TABLE OF solisti1,
        lst_objtxt TYPE solisti1.

  DATA: li_reclist  TYPE STANDARD TABLE OF somlreci1,
        lst_reclist TYPE somlreci1.

  DATA: lv_doc_chng  TYPE sodocchgi1.
  DATA: lv_tab_lines TYPE sy-tabix.

  DATA : lv_date TYPE sy-datum,
         lv_time TYPE sy-uzeit.

  CONSTANTS : lc_x(1)    TYPE c VALUE 'X',
              lc_addtype TYPE soextreci1-adr_typ VALUE 'INT'.

  lv_date = sy-datum.       " System date
  lv_time = sy-uzeit.       " System time

* Mail Subject
  CONCATENATE text-020 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lv_doc_chng-obj_descr.
  CONCATENATE lv_doc_chng-obj_descr '_' lv_time INTO lv_doc_chng-obj_descr.

* Mail Contents
  lst_objtxt = text-021. "'Dear User,'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  " Mail Contents
  lst_objtxt = text-022."'Please find the attached JAPT Summary Report.'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  lst_objtxt = text-023."'This is a system genarated email – please do not reply to it.'.
  APPEND lst_objtxt TO li_objtxt.


  DESCRIBE TABLE li_objtxt LINES lv_tab_lines.
  READ TABLE li_objtxt INTO lst_objtxt INDEX lv_tab_lines.
  lv_doc_chng-doc_size = ( lv_tab_lines - 1 ) * 255 + strlen( lst_objtxt ).

* Packing List For the E-mail Body
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num   = lv_tab_lines.
  lst_objpack-doc_type   = 'RAW'.
  APPEND lst_objpack TO li_objpack.

* Creation of the Document Attachment
  LOOP AT i_xml_table ASSIGNING <gfs_xml>.
    CLEAR lst_objbin.
    lst_objbin-line = <gfs_xml>-data.
    APPEND lst_objbin TO li_objbin.
  ENDLOOP.

  DESCRIBE TABLE li_objbin LINES lv_tab_lines.
  lst_objhead = text-024.
  APPEND lst_objhead TO li_objhead.

* Packing List For the E-mail Attachment
  lst_objpack-transf_bin = lc_x.
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num = lv_tab_lines.
  CONCATENATE text-020 lv_date+4(2) lv_date+6(2)  lv_date+0(4) INTO lst_objpack-obj_descr.
  CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
  lst_objpack-doc_type = 'XLS'.
  lst_objpack-doc_size = lv_tab_lines * 255.
  APPEND lst_objpack TO li_objpack.

* Target Recipent
  CLEAR lst_reclist.
  lst_reclist-receiver = v_receiver. "'lwathudura@wiley.com'.
  lst_reclist-rec_type = 'U'.
  lst_reclist-express = lc_x.
  lst_reclist-com_type = lc_addtype.
  lst_reclist-notif_del = lc_x.
  lst_reclist-notif_ndel = lc_x.
  APPEND lst_reclist TO li_reclist.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lv_doc_chng
      put_in_outbox              = lc_x
      sender_address             = v_sender
      sender_address_type        = lc_addtype
      commit_work                = lc_x
    TABLES
      packing_list               = li_objpack
      object_header              = li_objhead
      contents_txt               = li_objtxt
      contents_hex               = li_objbin
      receivers                  = li_reclist
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc NE 0.
    MESSAGE text-001 TYPE c_errtype.
  ENDIF.

ENDFORM.                    " SEND_MAIL

FORM f_process_xml_data .

  DATA : lv_header TYPE string.

  CLEAR lv_header.
  lv_header = v_headername.

* Creating a ixml Factory
  v_ixml = cl_ixml=>create( ).

* Creating the DOM Object Model
  v_document = v_ixml->create_document( ).

* Create Root Node 'Workbook'
  v_element_root  = v_document->create_simple_element( name = v_workbook  parent = v_document ). " 'Workbook'
  v_element_root->set_attribute( name = v_xmlns  value = v_urn ). "'xmlns' "urn:schemas-microsoft-com:office:spreadsheet

  v_attribute = v_document->create_namespace_decl( name = v_ss  prefix = v_xmlns  uri = v_urn ). "urn:schemas-microsoft-com:office:spreadsheet
  v_element_root->set_attribute_node( v_attribute ).

  v_attribute = v_document->create_namespace_decl( name = v_xx  prefix = v_xmlns  uri = v_urn1 ). "'urn:schemas-microsoft-com:office:excel'
  v_element_root->set_attribute_node( v_attribute ).

* Create node for document properties.
  v_element_properties = v_document->create_simple_element( name = v_docname  parent = v_element_root )."'JPAT_SUMMARY_REPORT'
  v_value = sy-uname.
  v_document->create_simple_element( name = v_author  value = v_value  parent = v_element_properties  ). "Author

* Styles
  v_styles = v_document->create_simple_element( name = v_xlstyles  parent = v_element_root  ). "Styles

** Build Seperate Styles for item
  PERFORM f_style_for_report_heading.
  PERFORM f_style_for_header.                 " Style for Header Data
  PERFORM f_style_for_year.                   " Style for 2nd header line (Line)
  PERFORM f_style_for_lineitem.               " Style for detail Data
  PERFORM f_style_for_item_summary.           " Style for line item qty summary
  PERFORM f_style_for_minus_item.             " Style for Line item Minus qty
  PERFORM f_style_for_item_summary_minus.     " Style for line item minus qty summary
*** Begin of Changes with ED2K916403 ***
  PERFORM f_style_for_item_percentage.        " Style for detail Data percentage
  PERFORM f_style_for_item_min_percen.        " Style for detail minus data percentage
*** End of Changes with ED2K916403 ***

  " Worksheet
  v_worksheet = v_document->create_simple_element( name = v_xlworksheet  parent = v_element_root ).
  v_worksheet->set_attribute_ns( name = v_name  prefix = v_ss  value = v_sumreport ).

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  " Column Formatting
  PERFORM f_column_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Add report Header (Dash Board Report)
  PERFORM f_add_report_heading.

  " Add Blank row after Report header
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '40' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  " Note : Change all header names with ED2K916403
  PERFORM f_build_header_names USING '1' text-003. "Subs Copies (SAP)
  PERFORM f_build_header_names USING '1' text-004. "'Society Offline Member - Main Labels (JFDS)'.
  PERFORM f_build_header_names USING '1' text-005. "'Society Offline Member - Back Labels (JFDS)'.
  PERFORM f_build_header_names USING '1' text-006. "'Conference Copies'.
  PERFORM f_build_header_names USING '1' text-007. "'Author copies - Main Labels (SAP)'.
  PERFORM f_build_header_names USING '1' text-008. "'Author copies - Back Labels (SAP)'.
  PERFORM f_build_header_names USING '1' text-009. " Bulk orders(including EMLOs)'.
  PERFORM f_build_header_names USING '1' text-010. "'Bulk orders(including EBLOs)'.
  PERFORM f_build_header_names USING '1' text-011. "'Back Labels (SAP)'.
*** Begin of changes for ED2K916403 ***
  PERFORM f_build_header_names USING '1' text-012. "'Printer Dispatch(JRR)'. " Change as a 'Receipt Qty(JRR)' with ED2K916608
  PERFORM f_build_header_names USING '1' text-013. "'Total Sales (Main Labels)'.
  PERFORM f_build_header_names USING '1' text-014. "'PO (Print Run) Quantity'.
*** Begin of changes for ED2K916608 ***
  PERFORM f_build_header_names USING '0' lv_header.
  PERFORM f_build_header_names USING '1' text-092. "'Printer dispatch (SAP PO qty-receipt from JFDS) Issue Level'.
  PERFORM f_build_header_names USING '1' text-016. "Total Print Run (C&E plus PO)'.
  PERFORM f_build_header_names USING '1' text-017. "'Difference (PO minus Despatched)'.
  PERFORM f_build_header_names USING '1' text-018. "'Difference (PO minus Despatched) %'.
*** End of changes for ED2K916608 ***
*** End of changes for ED2K916403 ***

  " Build Blank Cell
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss  value = '36' ).        " Change 29 as a 36 with ED2K916403
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING '3' text-019."'SOH'.

  " 2nd Header Row
  v_row_year = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row_year->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  PERFORM f_fill_comparing_year.    " Filiing Year comparision data
  PERFORM f_fill_data.              " Fill Line item data

  PERFORM f_genarate_xml_file.      " Genarate XML File

ENDFORM.                    " process_xml_data

FORM f_column_header_formatting.

  " Blank Column
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Month
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '50' ).

  " Subscription Total (Sales)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Offline Society members total (JDR) (From JDR Feed into SAP)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " BIOS members total  (from JDR feed into SAP)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Conferences & exhibitions total (From PO)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Author copies (Main Lables) (Includes Subs and Sales Orders)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Author copies (Back Orders) (Includes Subs and Sales Orders)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Bulk orders (Main Lables Sales Orders) (EMLOs)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Bulk orders (Back Orders Sales) (EBLOs)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Back orders (Sales Data)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Printer Dispatch(JRR)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Total Sales (Main Lables)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "PO (Print Run) Quantity
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "PO (Print Run) - Difference
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  "Printer dispatch (SAP PO qty-receipt from JFDS) Issue Level
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Total Print Run (C&E plus PO)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Difference (PO minus Despatched)
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Difference (PO minus Despatched) %
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  "Blank Column
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '50' ).

  " SOH
  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  v_column = v_document->create_simple_element( name = v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

ENDFORM.

FORM f_build_header_names  USING fp_merge TYPE string      " Number of columns to be Merge
                                 fp_text TYPE string.      " Header text

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header ).
  v_cell->set_attribute_ns( name = v_mergeacross prefix = v_ss value = fp_merge ).
  v_data = v_document->create_simple_element( name = v_xldata  value = fp_text  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

ENDFORM.

FORM f_style_for_report_heading.

  v_style  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style->set_attribute_ns( name = v_id   prefix = v_ss  value = v_report_header ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).
  v_format->set_attribute_ns( name = v_size  prefix = v_ss  value = '15' ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style  ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).

ENDFORM.

FORM f_style_for_header .

  v_style  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style->set_attribute_ns( name = v_id  prefix = v_ss  value = v_header ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#FFCC00' ).
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style  ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_wraptext  prefix = v_ss  value = '1' ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_style_for_lineitem .

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '#,##0' ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_fill_comparing_year .

  DATA : lv_value   TYPE string,
         lv_colindx TYPE i.

  FIELD-SYMBOLS : <lfs> TYPE c.
  DATA : lv_loopcount TYPE i.

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row_year ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header_year ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
  v_data = v_document->create_simple_element( name = v_xldata  value = v_xlmonth  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  lv_loopcount = 0.
  LOOP AT i_year INTO st_year.
    CLEAR lv_colindx.
    WHILE lv_loopcount =< 40.   " Change 32 as a 40 with ED2K916403
      ASSIGN COMPONENT sy-index OF STRUCTURE st_year TO <lfs>.
      v_value = <lfs>.
      CONDENSE v_value NO-GAPS.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      lv_loopcount = lv_loopcount + 1.
      IF sy-index = 1.
        CONTINUE.
      ENDIF.
      lv_colindx = sy-index + 1.
      IF lv_colindx EQ 36 .     " instead of 29 chnages the Skipping 36 column without any interior with ED2K916403
        v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row_year ).
        v_data = v_document->create_simple_element( name = v_xldata  value = v_value  parent = v_cell ).
        v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).
      ELSE.
        v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row_year ).
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header_year ).
        v_data = v_document->create_simple_element( name = v_xldata  value = v_value  parent = v_cell ).
        v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).
      ENDIF.
    ENDWHILE.
  ENDLOOP.

ENDFORM.

FORM f_fill_data .

  DATA : lv_index TYPE i.
  DATA : lv_value TYPE string.

  "" Note : Check lv_index = 13 to apply summary line style
  "         Using CLOI_PUT_SIGN_IN_FRONT FM change the minus symbols
  " Data_Minus_Percentage and Data_Percentage added with ED2K916403

  IF i_summary_data IS NOT INITIAL.
    CLEAR lv_index.
    LOOP AT i_summary_data ASSIGNING <gfs_summary_data>.
      lv_index = lv_index + 1.    " Calculate index number to apply Summary row style
      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Month
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_month = <gfs_summary_data>-field01.
      CONDENSE v_month NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_month   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).


      "Subscription Total (Sales)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field02.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field03.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Offline Society members total (JDR) (From JDR Feed into SAP)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field04.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field05.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " BIOS members total  (from JDR feed into SAP)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field06.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field07.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Conferences & exhibitions total (From PO)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field08.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field09.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Author copies (Main Lables) (Includes Subs and Sales Orders)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field10.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field11.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Author copies (Back Orders) (Includes Subs and Sales Orders)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field12.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field13.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Bulk orders (Main Lables Sales Orders) (EMLOs)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field14.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field15.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Bulk orders (Back Orders Sales) (EBLOs)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field16.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field17.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Back orders (Sales Data)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field18.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field19.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Printer Dispatch(JRR)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field20.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field21.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Total Sales (Main Lables)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field22.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field23.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " PO (Print Run) Quantity
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field24.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field25.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

*** Begin of Chnages for ED2K916608 ***
      " PO (Print Run) - Difference
      " Convert minus mark from back to front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field26.
      v_value = <gfs_summary_data>-field26.
      CONDENSE v_value NO-GAPS.
      lv_value = v_value.
      """ Removing the ',' symbols from value filtration
      REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH space.
      CONDENSE lv_value NO-GAPS.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
        ENDIF.
      ELSE.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
        ENDIF.
      ENDIF.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Printer dispatch (SAP PO qty-receipt from JFDS) Issue Level
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field27.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field28.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Total Print Run (C&E plus PO)
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field29.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field30.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Difference (PO minus Despatched)
      " Convert minus mark from back to front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field31.
      v_value = <gfs_summary_data>-field31.
      CONDENSE v_value NO-GAPS.
      lv_value = v_value.
      """ Removing the ',' symbols from value filtration
      REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH space.
      CONDENSE lv_value NO-GAPS.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
        ENDIF.
      ELSE.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
        ENDIF.
      ENDIF.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      " Convert minus mark from back to front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field32.
      v_value = <gfs_summary_data>-field32.
      CONDENSE v_value NO-GAPS.
      lv_value = v_value.
      """ Removing the ',' symbols from value filtration
      REPLACE ALL OCCURRENCES OF ',' IN lv_value WITH space.
      CONDENSE lv_value NO-GAPS.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
        ENDIF.
      ELSE.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
        ENDIF.
      ENDIF.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).


      " Difference (PO minus Despatched) %
      " Convert minus mark from back to front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field33.
      v_value = <gfs_summary_data>-field33.
      CONDENSE v_value NO-GAPS.
      lv_value = v_value.
      """ Removing the % symbols from value filtration
      REPLACE ALL OCCURRENCES OF '%' IN lv_value WITH space.
      CONDENSE lv_value NO-GAPS.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_minus_percentage ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_percentage ).
        ENDIF.
      ELSE.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
        ENDIF.
      ENDIF.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).


      " Convert minus mark from back to front
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <gfs_summary_data>-field34.
      v_value = <gfs_summary_data>-field34.
      CONDENSE v_value NO-GAPS.
      lv_value = v_value.
      """ Removing the % symbols from value filtration
      REPLACE ALL OCCURRENCES OF '%' IN lv_value WITH space.
      CONDENSE lv_value NO-GAPS.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_minus_percentage ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_percentage ).
        ENDIF.
      ELSE.
        IF lv_value LT 0.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum_minus ).
        ELSE.
          v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
        ENDIF.
      ENDIF.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).
******

      " SOH - Column 1
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '37').
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field36.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      " SOH - Column 2
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field37.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      " SOH - Column 3
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field38.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).

      " SOH - Column 4
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      IF lv_index NE 13.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      ELSE.
        v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_data_sum ).
      ENDIF.
      v_value = <gfs_summary_data>-field39.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_number ).
*** End of Chnages for ED2K916608 ***

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_style_for_year .

  v_style  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style->set_attribute_ns( name = v_id  prefix = v_ss  value = v_header_year ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#FFCC00' )."
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style  ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_wraptext  prefix = v_ss  value = '1' ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_style_for_item_summary .

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_data_sum ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '#,##0' ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style1  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#C0C0C0' ).
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_style_for_minus_item.

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_data_minus ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '#,##0' ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1 ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#FF0000' ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_style_for_item_summary_minus .

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_data_sum_minus ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '#,##0' ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#FF0000' ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style1  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#C0C0C0' ).
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_add_report_heading .

  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '30' ).

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '5').
  v_cell->set_attribute_ns( name = v_mergeacross prefix = v_ss value = '2').
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_report_header ).
  v_data = v_document->create_simple_element( name = v_xldata  value = v_dashboard_report  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

ENDFORM.

FORM f_genarate_xml_file .

* Creating a Stream Factory
  v_streamfactory = v_ixml->create_stream_factory( ).

* Connect Internal XML Table to Stream Factory
  v_ostream = v_streamfactory->create_ostream_itable( table = i_xml_table ).

* Rendering the Document
  v_renderer = v_ixml->create_renderer( ostream  = v_ostream  document = v_document ).
  v_rc = v_renderer->render( ).

* Saving the XML Document
  v_xml_size = v_ostream->get_num_written_raw( ).

ENDFORM.

FORM f_get_zcaconstants .

  SELECT devid                      "Development ID
        param1                     "ABAP: Name of Variant Variable
        param2                     "ABAP: Name of Variant Variable
        srno                       "Current selection number
        sign                       "ABAP: ID: I/E (include/exclude values)
        opti                       "ABAP: Selection option (EQ/BT/CP/...)
        low                        "Lower Value of Selection Condition
        high                       "Upper Value of Selection Condition
        activate                   "Activation indicator for constant
        FROM zcaconstant           " Wiley Application Constant Table
        INTO TABLE i_const
        WHERE devid    = c_devid
        AND   activate = c_x.       "Only active record
  IF sy-subrc IS  INITIAL.
    SORT i_const BY param1.
  ENDIF.

ENDFORM.

FORM f_get_email .

  " Data declaration for Receiver Email address and BAPI
  DATA : ls_addr TYPE bapiaddr3.
  DATA : li_return   TYPE TABLE OF bapiret2.

  FIELD-SYMBOLS : <lfs_const> TYPE ty_const.

  CONSTANTS : lc_email   TYPE rvari_vnam VALUE 'E_MAIL',
              lc_msgtype TYPE bapiret2-type VALUE 'E'.

  FREE : v_sender , v_receiver.
  " Get Sender email adress
  IF i_const IS NOT INITIAL.
    READ TABLE i_const ASSIGNING <lfs_const> WITH KEY param1 = lc_email BINARY SEARCH.
    IF sy-subrc = 0.
      v_sender = <lfs_const>-low.      " Set Sender email address
    ENDIF.
  ENDIF.

  "Get recevier email adress.
  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username = v_recname
    IMPORTING
      address  = ls_addr
    TABLES
      return   = li_return.

  "Check return table values
  IF li_return IS NOT INITIAL.
    SORT li_return BY type.
    READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WITH KEY type = lc_msgtype BINARY SEARCH..
    IF sy-subrc = 0.
      MESSAGE <lfs_return>-message TYPE c_errtype.
      UNASSIGN <lfs_return>.
    ENDIF.
  ENDIF.

  v_receiver = ls_addr-e_mail.
  FREE ls_addr.

ENDFORM.

*** Begin of Changes with ED2K916403 ***
FORM f_style_for_item_percentage .

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_data_percentage ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_right ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_style_for_item_min_percen .

  v_style1  = v_document->create_simple_element( name = v_vstyle   parent = v_styles ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_data_minus_percentage ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_right ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1 ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#FF0000' ).

  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '2' ).

ENDFORM.

FORM f_set_text_elements .

  v_workbook = text-025.  "'Workbook'
  v_xmlns    = text-026.  "'xmlns'
  v_ss       = text-027.  "v_ss
  v_urn      = text-028.  "'urn:schemas-microsoft-com:office:spreadsheet'
  v_urn1     = text-029.  "'urn:schemas-microsoft-com:office:excel'
  v_docname  = text-030.  "'JPAT_SUMMARY_REPORT'
  v_author   = text-031.  "'Author'
  v_xlstyles = text-032.  "'Styles'
  v_xx       = text-033.  "'x'
  v_xlstyle  = text-034.  "'Style
  v_id       = text-035.  "'ID
  v_report_header = text-036. "Report_Header
  v_font     = text-037.      "Font
  v_bold     = text-038.      "Bold
  v_size     = text-039.      "Size
  v_horizontal = text-040.    "Horizontal
  v_vertical = text-041.      "Vertical
  v_center   = text-042.      "Center
  v_alignment = text-043.     "Alignment
  v_xldata   = text-044.      "Data
  v_height   = text-045.      "Height
  v_xlcell   = text-046.      "Cell
  v_header   = text-047.      "Header
  v_index    = text-048.      "Index
  v_xlcolumn = text-049.      "Column
  v_xltype   = text-050.      "Type
  v_width    = text-051.      "Width
  v_number   = text-052.      "Number
  v_weight   = text-053.      "Weight
  v_continuous  = text-054.   "continuous
  v_right    = text-055.      "Right
  v_position = text-056.      "Position
  v_xlborder = text-057.      "Border
  v_borders  = text-058.      "Borders
  v_xlworksheet = text-059.   "Worksheet
  v_string   = text-060.      "Sheet
  v_name     = text-061.      "Name
  v_sumreport = text-062.     "Summary Report
  v_xltable  = text-063.      "Table
  v_vstyle   = text-064.      "Style
  v_interior = text-065.      "Interior
  v_pattern  = text-066.      "Pattern
  v_solid    = text-067.      "Solid
  v_bottom   = text-068.      "Bottom
  v_left     = text-069.      "Left
  v_xlformat = text-070.      "Format
  v_xlmonth  = text-071.      "Month
  v_color    = text-072.      "Color
  v_dashboard_report = text-073.  "Dashborad Report
  v_styleid     = text-074.    "Style ID
  v_linestyle   = text-075.    "LineStyle
  v_mergeacross  = text-076.   "MergeAcross
  v_numberformat = text-077.   "NumberFormat
  v_wraptext     = text-078.   "Wraptext
  v_fullcolumns  = text-079.   "FullColumns
  v_fullrows    = text-080.    "FullRows
  v_header_year = text-081.    "Header_Year
  v_data_sum    = text-082.    "Data_Sum
  v_data_minus  = text-083.    "Data_Minus
  v_data_sum_minus = text-084. " Data_sum_minus
  v_data_minus_percentage = text-085.  " Data_minus_percentage
  v_data_percentage = text-086.  " Data_Percentage
  v_xlrow     = text-087.        "Row
  v_top       = text-088.        "Top

ENDFORM.

*** End of Changes with ED2K916403 ***
