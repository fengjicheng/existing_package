*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JPAT_DETAIL_EMAIL_SUB

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

FORM f_process_xml_data .

  "Create Workbook and Porperties
  PERFORM f_create_workbook.

* Styles
  v_styles = v_document->create_simple_element( name = v_xlstyles  parent = v_element_root  ).

* Build Seperate Styles for item
  PERFORM f_style_for_header.                 " Style for Header Data
  PERFORM f_style_for_lineitem.               " Style for detail Data

* Genarate Excel file sheets
  PERFORM f_genarate_po_data.
  PERFORM f_genarate_bios_data.
  PERFORM f_genarate_jdr_data.
  PERFORM f_genarate_sales_data.
  PERFORM f_genarate_soh_data.
*** Begin of Changes for ED2K916403 ***
  PERFORM f_genarate_isoh_data.
  PERFORM f_genarate_jrr_data.
  PERFORM f_genarate_prdis_data.
*** End of Changes for ED2K916403 ***
  PERFORM f_genarate_xml_file.      " Genarate XML File

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
  IF sy-subrc IS INITIAL.
    SORT i_const BY param1.
  ENDIF.

ENDFORM.

FORM f_send_mail .

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
  CONCATENATE text-043 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lv_doc_chng-obj_descr. "JAPT Detail Report_
  CONCATENATE lv_doc_chng-obj_descr '_' lv_time INTO lv_doc_chng-obj_descr.

* Mail Contents
  lst_objtxt = text-044."'Dear User,'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  " Mail Contents
  lst_objtxt = text-045."'Please find the attached JAPT Detail Report.'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  lst_objtxt = text-046."'This is a system genarated email – please do not reply to it.'.
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
  lst_objhead = text-047."'JPAT_Detail_Report'.
  APPEND lst_objhead TO li_objhead.

* Packing List For the E-mail Attachment
  lst_objpack-transf_bin = lc_x.
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num = lv_tab_lines.
  CONCATENATE text-043 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lst_objpack-obj_descr.   "JPAT Detail Report_
  CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
  lst_objpack-doc_type = 'XLS'.
  lst_objpack-doc_size = lv_tab_lines * 255.
  APPEND lst_objpack TO li_objpack.

* Target Recipent
  CLEAR lst_reclist.
  lst_reclist-receiver = v_receiver.  "'lwathudura@wiley.com'.
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

ENDFORM.

FORM f_create_workbook .

* Creating a ixml Factory
  v_ixml = cl_ixml=>create( ).

* Creating the DOM Object Model
  v_document = v_ixml->create_document( ).

* Create Root Node 'Workbook'
  v_element_root  = v_document->create_simple_element( name = v_workbook  parent = v_document ).
  v_element_root->set_attribute( name = v_xmlns  value = v_urn ).

  v_attribute = v_document->create_namespace_decl( name = v_ss  prefix = v_xmlns  uri = v_urn ).
  v_element_root->set_attribute_node( v_attribute ).

  v_attribute = v_document->create_namespace_decl( name = v_xx  prefix = v_xmlns  uri = v_urn1 ).
  v_element_root->set_attribute_node( v_attribute ).

* Create node for document properties.
  v_element_properties = v_document->create_simple_element( name = v_docname  parent = v_element_root ).
  v_value = sy-uname.
  v_document->create_simple_element( name = v_author  value = v_value  parent = v_element_properties  ).

ENDFORM.

FORM f_style_for_header .

  v_style  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style->set_attribute_ns( name = v_id  prefix = v_ss  value = v_header ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#FFFFFF' ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#003366' ).
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style  ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_left ).

ENDFORM.

FORM f_style_for_lineitem .

  v_style1  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '0' ).

  v_format  = v_document->create_simple_element( name = v_interior parent = v_style1  ).
  v_format->set_attribute_ns( name = v_color   prefix = v_ss  value = '#99CCFF' ).
  v_format->set_attribute_ns( name = v_pattern prefix = v_ss  value = v_solid ).

ENDFORM.

FORM f_create_sheet USING fp_sheetname TYPE string.

  " Worksheet
  v_worksheet = v_document->create_simple_element( name = v_xlworksheet  parent = v_element_root ).
  v_worksheet->set_attribute_ns( name = v_name  prefix = v_ss  value = fp_sheetname ).

ENDFORM.

FORM f_build_header_names  USING fp_text TYPE string.      " Header text

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header ).
  v_data = v_document->create_simple_element( name = v_xldata  value = fp_text  parent = v_cell ).
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

FORM f_po_column_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Act. Goods Arrival Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " PO Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " TrackingNo
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " PO Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Purch.Doc.
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Co Cd
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Created Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Document Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Vendor
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Plnt
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Account Assignment
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Created By
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Deletion Indicator
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_po_data .

  DATA : lv_qty TYPE char16.

  IF i_view_podetail IS NOT INITIAL.

    LOOP AT i_view_podetail ASSIGNING <gfs_podetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_podetail>-material.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_podetail>-act_publication_date+4(2) '/' <gfs_podetail>-act_publication_date+6(2) '/' <gfs_podetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "PO Type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-po_type.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " TrackingNo
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-tracking_no.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "PO Quantity
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_podetail>-po_qty TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Purch.Doc.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-po_number.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Item
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      SHIFT <gfs_podetail>-item LEFT DELETING LEADING '0'.
      v_value = <gfs_podetail>-item.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Co Cd
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-company_code.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Created Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_podetail>-created_date+4(2) '/' <gfs_podetail>-created_date+6(2) '/' <gfs_podetail>-created_date+0(4)
            INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Document Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-document_date.
      CONCATENATE <gfs_podetail>-document_date+4(2) '/' <gfs_podetail>-document_date+6(2) '/' <gfs_podetail>-document_date+0(4)
            INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Vendor
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-vendor.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Plnt
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-plant.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Account Assignment
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-account_assignment.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Created By
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-created_by.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Deletion Indicator
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_podetail>-deletion_indicator.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_genarate_po_data .

  v_sheetname = text-048."'Detailed PO Data'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "PO Column Formatting
  PERFORM f_po_column_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-004. "'Act. Goods Arrival Date'.
  PERFORM f_build_header_names USING text-005. "'PO Type'.
  PERFORM f_build_header_names USING text-006. "'TrackingNo'.
  PERFORM f_build_header_names USING text-007. "'PO Quantity'.
  PERFORM f_build_header_names USING text-008. "'Purch.Doc.'.
  PERFORM f_build_header_names USING text-009. "'Item'.
  PERFORM f_build_header_names USING text-010. "'Co Cd'.
  PERFORM f_build_header_names USING text-011. "'Created Date'.
  PERFORM f_build_header_names USING text-012. "'Document Date'.
  PERFORM f_build_header_names USING text-013. "'Vendor'.
  PERFORM f_build_header_names USING text-014. "'Plnt'.
  PERFORM f_build_header_names USING text-015. "'Account Assignment'.
  PERFORM f_build_header_names USING text-016. "'Created By'.
  PERFORM f_build_header_names USING text-017. "'Deletion Indicator'.

  PERFORM f_fill_po_data.              " Fill PO Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_genarate_bios_data .

  v_sheetname = text-049."'Detailed BIOS Data'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "BIOS Column Formatting
  PERFORM f_bios_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-018. "'Adjustment Type'.
  PERFORM f_build_header_names USING text-019. "'BIOS Qty'.
  PERFORM f_build_header_names USING text-004. "'Act. Goods Arrival Date'.

  PERFORM f_fill_bios_data.              " Fill BIOS Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_bios_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Adjustment Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " BIOS Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " TrackingNo
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_bios_data .

  DATA : lv_qty TYPE char16.

  IF i_view_biosdetail IS NOT INITIAL.

    LOOP AT i_view_biosdetail ASSIGNING <gfs_biosdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_biosdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Adjustment Type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_biosdetail>-adustment_type.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "BIOS Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_biosdetail>-bios_quantity TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_biosdetail>-act_publication_date+4(2) '/' <gfs_biosdetail>-act_publication_date+6(2) '/' <gfs_biosdetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_genarate_jdr_data .

  v_sheetname = text-050."'Detailed JDR Data'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "JDR Column Formatting
  PERFORM f_jdr_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-018. "'Adjustment Type'.           " Add 'Adjustment type' with ED2K916403
  PERFORM f_build_header_names USING text-020. "'JDR Qty'.
  PERFORM f_build_header_names USING text-021. "'Act. Gds. Arvl Dt'.

  PERFORM f_fill_jdr_data.              " Fill JDR Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_jdr_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

*** Begin of adding Adjustment type Column with ED2K916403 ***
  " Adjustment type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).
*** End of adding Adjustment type Column with ED2K916403 ***

  " JDR Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Act. Gds. Arvl Dt
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_jdr_data .

  DATA : lv_qty TYPE char16.

  IF i_view_jdrdetail IS NOT INITIAL.

    LOOP AT i_view_jdrdetail ASSIGNING <gfs_jdrdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_jdrdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

*** Begin of adding Adjustment type Column with ED2K916403 ***
      " Adjustment type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_jdrdetail>-adustment_type.
      CONDENSE v_value.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).
*** End of adding Adjustment type Column with ED2K916403 ***

      "JDR Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_jdrdetail>-jdr_quantity TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_jdrdetail>-act_publication_date+4(2) '/' <gfs_jdrdetail>-act_publication_date+6(2) '/' <gfs_jdrdetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_genarate_sales_data .

  v_sheetname = text-051."'Detailed Sales Data'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "Sales Column Formatting
  PERFORM f_sales_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-022. "'Sales Doc Type'.
  PERFORM f_build_header_names USING text-023. "'SaTy'.
  PERFORM f_build_header_names USING text-024. "'ItCa'.
  PERFORM f_build_header_names USING text-025. "'Order Quantity'.
  PERFORM f_build_header_names USING text-026. "'Sales Doc.'.
  PERFORM f_build_header_names USING text-027. "'Act. Gd. Arrval Dat'.
  PERFORM f_build_header_names USING text-009. "'Item'.
  PERFORM f_build_header_names USING text-028. "'SU'.
  PERFORM f_build_header_names USING text-029. "'Ref.doc.'.
  PERFORM f_build_header_names USING text-030. "'Preceding Doc Category'.
  PERFORM f_build_header_names USING text-031. "'Subs/Sales Order'.
  PERFORM f_build_header_names USING text-032. "'RefItm'.
  PERFORM f_build_header_names USING text-033. "'CGr4'.
  PERFORM f_build_header_names USING text-034. "'CGr4 Generic Desc'.
  PERFORM f_build_header_names USING text-035. "'Created on'.
  PERFORM f_build_header_names USING text-016. "'Created By'.
  PERFORM f_build_header_names USING text-036. "'Sales Org'.
  PERFORM f_build_header_names USING text-037. "'Material Group 5'.
  PERFORM f_build_header_names USING text-038. "'Reason for Rejection'.
  PERFORM f_build_header_names USING text-039. "'Schedule Line Type'.

  PERFORM f_fill_sales_data.              " Fill Sales line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_sales_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Sales Doc Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " SaTy
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " ItCa
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Order Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Sales Doc.
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Act. Gd. Arrval Dat
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " SU
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Ref.doc.
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Preceding Doc Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Subs/Sales Order
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " RefItm
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " CGr4
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  "CGr4 Generic Desc
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Created on
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Created By
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  "Sales Org
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Material Group 5
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Reason for Rejection
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Schedule Line Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_sales_data .

  DATA : lv_qty TYPE char16.

  IF i_view_salesdetail IS NOT INITIAL.

    LOOP AT i_view_salesdetail ASSIGNING <gfs_salesdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_salesdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Sales Doc type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-document_type.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "SaTy
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-document_type_desc.
      CONDENSE v_value.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Item Cat
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-item_category.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_salesdetail>-target_qty TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Sales Doc Number
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-document_number.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Act. pub date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_salesdetail>-act_pub_date+4(2) '/' <gfs_salesdetail>-act_pub_date+6(2) '/' <gfs_salesdetail>-act_pub_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Item
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-item.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " SU
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-su.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Ref.doc.
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-reference_document.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Preceding Doc Category
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-reference_document_type.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Subs/Sales Order
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-subs_sales_order.
      CONDENSE v_value.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "RefItm
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-refitm.
      IF <gfs_salesdetail>-refitm IS INITIAL.
        v_value = ''.
      ENDIF.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "CGr4
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-condition_group_4.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "CGr4 Generic Desc
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-free_not_free.
      CONDENSE v_value.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Created on
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_salesdetail>-created_date+4(2) '/' <gfs_salesdetail>-created_date+6(2) '/' <gfs_salesdetail>-created_date+0(4)
            INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Created by
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-created_by.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Sales Org
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-sales_organization.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Material Group 5
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-material_grp_5.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Reason for rejection
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-rejection_reason.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      " Schdule Line type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_salesdetail>-schedule_line_type.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_genarate_soh_data .

  v_sheetname = text-052."'Detailed WHS'.             " Change SOH data to detailed WHS with ED2K916403
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "SOH Column Formatting
  PERFORM f_soh_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-040. "'WHS Quantity'.          " Change SOH qty to WHS Quantity with ED2K916403
  PERFORM f_build_header_names USING text-021. "'Act. Gds. Arvl Dt'.

  PERFORM f_fill_soh_data.              " Fill SOH Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_fill_soh_data .

  DATA : lv_qty TYPE char16.

  IF i_view_sohdetail IS NOT INITIAL.

    LOOP AT i_view_sohdetail ASSIGNING <gfs_sohdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_sohdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "SOH Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_sohdetail>-soh_qty TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_sohdetail>-act_publication_date+4(2) '/' <gfs_sohdetail>-act_publication_date+6(2) '/' <gfs_sohdetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_get_email .

  " Data declaration for Receiver Email address and BAPI
  DATA : ls_addr TYPE bapiaddr3.
  DATA : li_return TYPE TABLE OF bapiret2.

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

FORM f_soh_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " WHS Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Act. Gds. Arvl Dt
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

*** Begin of Changes for ED2K916403 ***
FORM f_genarate_isoh_data .

  v_sheetname = text-053."'Initial SOH'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "Initial SOH Column Formatting
  PERFORM f_isoh_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-041. "'Initial SOH Qty'.
  PERFORM f_build_header_names USING text-021. "'Act. Gds. Arvl Dt'.

  PERFORM f_fill_isoh_data.              " Fill Initial SOH Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_isoh_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Initial SOH Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Act. Gds. Arvl Dt
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_isoh_data .

  DATA : lv_qty TYPE char16.

  IF i_view_isohdetail IS NOT INITIAL.

    LOOP AT i_view_isohdetail ASSIGNING <gfs_isohdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_isohdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Initial SOH Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_isohdetail>-inital_soh_quantity TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_isohdetail>-act_publication_date+4(2) '/' <gfs_isohdetail>-act_publication_date+6(2) '/' <gfs_isohdetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_genarate_jrr_data .

  v_sheetname = text-054."'Detailed JRR Data'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "JRR Column Formatting
  PERFORM f_jrr_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-018. "'Adjustment type'.
  PERFORM f_build_header_names USING text-042. "'Receipt Quantity'.
  PERFORM f_build_header_names USING text-112. "'Ordered Print Run'.    Add with ED2K916608
  PERFORM f_build_header_names USING text-021. "'Act. Gds. Arvl Dt'.

  PERFORM f_fill_jrr_data.              " Fill JRR Line item data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_jrr_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

*** Begin of changes for ED2K916608 ***
  " Adjustment type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).
*** End of changes for ED2K916608 ***

  " JRR Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

*** Begin of changes for ED2K916608 ***
  " Ordered print run
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).
*** End of changes for ED2K916608 ***

  " Act. Gds. Arvl Dt
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_jrr_data .

  DATA : lv_qty TYPE char16.

  IF i_view_jrrdetail IS NOT INITIAL.

    LOOP AT i_view_jrrdetail ASSIGNING <gfs_jrrdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_jrrdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

*** Begin of changes for ED2K916608 ***
      "Adjustment type
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_value = <gfs_jrrdetail>-adustment_type.
      CONDENSE v_value.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).
*** End of changes for ED2K916608 ***

      "JRR Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_jrrdetail>-jrr_quantity TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

*** Begin of changes for ED2K916608 ***
      "Ordered Print Run
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_jrrdetail>-ordered_print_run TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).
*** End of changes for ED2K916608 ***

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_jrrdetail>-act_publication_date+4(2) '/' <gfs_jrrdetail>-act_publication_date+6(2) '/' <gfs_jrrdetail>-act_publication_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_set_text_elements .

  v_workbook = text-055.   "'Workbook'
  v_xmlns    = text-056.   "'xmlns',
  v_ss       = text-057.   "v_ss,
  v_urn      = text-058.   "'urn:schemas-microsoft-com:office:spreadsheet',
  v_urn1     = text-059.   "'urn:schemas-microsoft-com:office:excel',
  v_docname  = text-060.   "'JPAT_DETAIL_REPORT',
  v_author   = text-061.   "'Author',
  v_xlstyles = text-062.   "'Styles',
  v_xx       = text-063.   "'x'.
  v_xlstyle  = text-064.   "'Style
  v_id       = text-065.   "'ID
  v_header   = text-066.   "Header
  v_font     = text-067.   "Font
  v_bold     = text-068.   "Bold
  v_horizontal = text-070. "Horizontal
  v_vertical = text-071.   "Vertical
  v_center   = text-072.   "Center
  v_alignment = text-073.  "Alignment
  v_xldata   = text-074.   "Data
  v_height   = text-075.   "Height
  v_xlcell   = text-076.   "Cell
  v_index    = text-078.   "Index
  v_xlcolumn = text-079.   "Column
  v_xltype   = text-080.   "type
  v_width    = text-081.   "Width
  v_xlworksheet = text-089. "Worksheet
  v_string   = text-090.    "String
  v_name     = text-091.    "Name
  v_xltable  = text-093.    "Table
  v_interior = text-095.    "Interior
  v_pattern  = text-096.    "Pattern
  v_solid    = text-097.    "Solid
  v_left     = text-099.    "Left
  v_color    = text-102.    "Color
  v_styleid     = text-104. "StyleID
  v_fullcolumns = text-109. "FullColumns
  v_fullrows    = text-110. "Fullrows
  v_xlrow     = text-111.   "Row

ENDFORM.

*** End of Changes for ED2K916403 ***

FORM f_genarate_prdis_data .

  v_sheetname = text-113."'Printer Dispatch'.
  PERFORM f_create_sheet USING v_sheetname.

  " Table
  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

  "Printer Dispatch Column Formatting
  PERFORM f_prd_col_header_formatting.

  " Add Blank Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

  " Column Headers Row
  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

  " Build Blank cell as a blank
  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '1').
  v_data = v_document->create_simple_element( name = v_xldata  value = ''  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

  " Build Header Text
  PERFORM f_build_header_names USING text-003. "'Material'.
  PERFORM f_build_header_names USING text-114. "'Actual Goods arrival date'.
  PERFORM f_build_header_names USING text-115. "'PO Quantity'.
  PERFORM f_build_header_names USING text-116. "'Receipt Quantity'.
  PERFORM f_build_header_names USING text-117. "'Dispatch Quantity'.

  PERFORM f_fill_prdispatch_data.       " Fill Printer Dispatch data

  FREE : v_sheetname ,v_table.

ENDFORM.

FORM f_prd_col_header_formatting .

  " Blank Column
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '70' ).

  " Material
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Actual Publication date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Po Qty
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " JRR Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

  " Po Dispatch
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '100' ).

ENDFORM.

FORM f_fill_prdispatch_data .

  DATA : lv_qty TYPE char16.

  IF i_view_printedis IS NOT INITIAL.

    LOOP AT i_view_printedis ASSIGNING <gfs_prdisdetail>.

      v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

      " Material
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      v_cell->set_attribute_ns( name = v_index prefix = v_ss value = '2').
      v_value = <gfs_prdisdetail>-media_issue.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Act. Goods Arrival Date
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      CONCATENATE <gfs_prdisdetail>-act_pub_date+4(2) '/' <gfs_prdisdetail>-act_pub_date+6(2) '/' <gfs_prdisdetail>-act_pub_date+0(4)
                  INTO v_value.
      CONDENSE v_value NO-GAPS.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "PO Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_prdisdetail>-po_qty TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Receipt Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_prdisdetail>-jrr_qty TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

      "Dispatch Qty
      v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
      v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
      WRITE <gfs_prdisdetail>-po_dispatch TO lv_qty DECIMALS 0.
      v_value = lv_qty.
      CLEAR lv_qty.
      CONDENSE v_value NO-GAPS.
      REPLACE ALL OCCURRENCES OF '.' IN v_value WITH ','.
      v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
      v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    ENDLOOP.

  ENDIF.

ENDFORM.
