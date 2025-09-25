*&---------------------------------------------------------------------*
* Program Name : ZQTCN_ORD_CONFIRM_SPUR_SUB                            *
* REVISION NO:  ED2K925398                                             *
* REFERENCE NO: OTCM-51319                                             *
* DEVELOPER :   Lahiru Wathudura (LWATHUDURA)                          *
* DATE:  01/06/2022                                                    *
* DESCRIPTION: Indian Agents Order confirmation to SPUR team using     *
*              ZIAC Output type                                        *
*----------------------------------------------------------------------*

FORM f_processing .

  " Perform to Fetch constant values
  PERFORM f_get_constant_values.

  " Get Document number from nast table entry for further process
  p_docume = nast-objky+0(10).

  " Perform to get sales header data
  PERFORM f_get_sales_header_data USING  p_docume
                                  CHANGING st_vbak.

  " Perform to get sales item data
  PERFORM f_get_sales_item_data USING p_docume
                                CHANGING i_vbap.

  " Perform to get Sales business data
  PERFORM f_get_business_data USING i_vbap
                                    CHANGING i_vbkd.

  " Perform to get sales partner details
  PERFORM f_get_partner_data USING p_docume
                             CHANGING i_partner.

  " Generate Excel file for email attachment
  PERFORM f_generate_bg_file.

  " Get User Email address
  PERFORM f_get_email.

  " Prepare email body value
  PERFORM f_build_email_body CHANGING v_date
                                      v_date_rel
                                      v_endcustomer
                                      v_name1
                                      v_name2
                                      v_pstlz
                                      v_stras
                                      v_agent_name
                                      v_country
                                      v_vgbel.
  " Prepare email sending
  PERFORM f_send_mail.


ENDFORM.

FORM f_get_constant_values .

  REFRESH : i_constant[],
            ir_parvw[].

  SELECT devid,                      " Development ID
         param1,                     " ABAP: Name of Variant Variable
         param2,                     " ABAP: Name of Variant Variable
         srno,                       " Current selection number
         sign,                       " ABAP: ID: I/E (include/exclude values)
         opti,                       " ABAP: Selection option (EQ/BT/CP/...)
         low,                        " Lower Value of Selection Condition
         high,                       " Upper Value of Selection Condition
         activate                    " Activation indicator for constant
         FROM zcaconstant            " Wiley Application Constant Table
         INTO TABLE @i_constant
         WHERE devid    = @c_devid
         AND   activate = @abap_true.       "Only active record
  IF sy-subrc IS INITIAL.

    SORT i_constant BY param1.
    LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
      CASE <lfs_constant>-param1.
        WHEN c_partner.     " Partner   " AG & WE Sold to Party and Ship to party
          APPEND INITIAL LINE TO ir_parvw ASSIGNING FIELD-SYMBOL(<lfs_parvw>).
          <lfs_parvw>-sign   = <lfs_constant>-sign.
          <lfs_parvw>-option = <lfs_constant>-opti.
          <lfs_parvw>-high   = <lfs_constant>-high.
          <lfs_parvw>-low    = <lfs_constant>-low.
      ENDCASE.
    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_get_sales_header_data USING fp_docume TYPE vbeln
                             CHANGING fp_st_vbak TYPE ty_vbak.

  CLEAR fp_st_vbak.
  SELECT SINGLE vbeln,erdat,bstnk,bsark,ihrez
    FROM vbak
    INTO @fp_st_vbak
    WHERE vbeln = @fp_docume.
  IF sy-subrc IS NOT INITIAL.
    EXIT.
  ENDIF.

ENDFORM.

FORM f_get_sales_item_data USING fp_docume TYPE vbeln
                           CHANGING fp_i_vbap TYPE tt_vbap.

  REFRESH fp_i_vbap[].
  SELECT a~vbeln,
         a~posnr,
         a~matnr,
         a~zmeng,
         a~vgbel,
         b~maktx
    FROM vbap AS a INNER JOIN makt AS b
    ON b~matnr = a~matnr
    INTO TABLE @fp_i_vbap
    WHERE a~vbeln = @fp_docume AND
          b~spras = @sy-langu.
  IF sy-subrc IS INITIAL.
    SORT fp_i_vbap BY vbeln posnr.
  ENDIF.

ENDFORM.

FORM f_get_partner_data USING fp_docume TYPE vbeln
                        CHANGING fp_i_partner TYPE tt_partner.

  REFRESH fp_i_partner[].
  SELECT a~vbeln,
         a~posnr,
         a~parvw,
         a~kunnr,
         a~adrnr,
         b~land1,
         b~name1,
         b~name2,
         b~pstlz,
         b~stras
      FROM vbpa AS a INNER JOIN kna1 AS b
      ON b~kunnr = a~kunnr AND
         b~adrnr = a~adrnr
    INTO TABLE @fp_i_partner
    WHERE vbeln = @fp_docume AND
          posnr = @c_posnr         AND
          parvw IN @ir_parvw.
  IF sy-subrc IS INITIAL.
    SORT fp_i_partner BY vbeln posnr parvw.
  ENDIF.

ENDFORM.

FORM f_generate_bg_file .

  " Build final internal table for excel processing
  PERFORM f_prepare_excel_data.

  PERFORM f_set_text_elements.              " Set excel properties
  PERFORM f_create_workbook.                " Create Workbook and Porperties

  " Style
  v_styles = v_document->create_simple_element( name = v_xlstyles  parent = v_element_root  ).

  " Build styles
  PERFORM f_style_for_header.               " Style for header Columns
  PERFORM f_style_for_lineitem.             " Style for detail Data
  PERFORM f_style_for_numbers.              " Style for numbers

  PERFORM f_create_sheet USING v_docname.    " Create excel worksheet.
  PERFORM f_build_table.                     " Build a Table
  PERFORM f_column_formatting.               " Format excel columns
  PERFORM f_header_row_format.               " Header Column formatting
  PERFORM f_header_columns.                  " Build header Columns names
  PERFORM f_fill_data.                       " Fill data to the excel
  PERFORM f_generate_xml_file.               " Generate XML file

ENDFORM.

FORM f_set_text_elements .

  v_workbook = text-e04.  "'Workbook'
  v_xmlns    = text-e05.  "'xmlns'
  v_urn      = text-e06.  "'urn:schemas-microsoft-com:office:spreadsheet'.
  v_ss       = text-e07.  " ss
  v_xx       = text-e08.  " X
  v_urn1     = text-e09.  " urn:schemas-microsoft-com:office:excel
  v_docname  = text-e10.  " Indian agent Order confirmation
  v_author   = text-e11.  " Author
  v_xlstyles = text-e12.  " Styles
  v_xlstyle  = text-e13.  " Style
  v_id       = text-e14.  " ID
  v_header   = text-e15.  " Header
  v_font     = text-e16.  " Font
  v_bold     = text-e17.  " Bold
  v_color    = text-e18.  " Color
  v_interior = text-e19.  " Interior
  v_pattern  = text-e20.  " Pattern
  v_solid    = text-e21.  " Solid
  v_alignment = text-e22. " Alignment
  v_horizontal = text-e23." Horizontal
  v_vertical  = text-e24. " Vertical
  v_center    = text-e25. " Center
  v_left      = text-e26. " Left
  v_xldata    = text-e27. " Data
  v_xlworksheet    = text-e28.  " Worksheet
  v_name      = text-e29. " Name
  v_xltable  = text-e30.  "Table
  v_fullcolumns = text-e31. " FullColumns
  v_fullrows    = text-e32. " FullRows
  v_xlcolumn    = text-e33. " Column
  v_width       = text-e34. " Width
  v_xlrow       = text-e35. " Row
  v_height      = text-e36. " Height
  v_xlcell      = text-e37. " Cell
  v_styleid     = text-e38. " StyleID
  v_xltype      = text-e39. " Type
  v_string      = text-e40. " String
  v_xldata1     = text-e41. " Normal
  v_numberformat = text-e42." NumberFormat
  v_xlformat     = text-e43." Format
  v_borders     = text-e44. " Borders
  v_xlborder    = text-e45. " Border
  v_position    = text-e46. " Position
  v_bottom      = text-e47. " Bottom
  v_linestyle   = text-e48. " LineStyle
  v_continuous  = text-e49. " Continuous
  v_weight      = text-e50. " Weight
  v_top         = text-e51. " Top
  v_right       = text-e52. " Right

ENDFORM.

FORM f_create_workbook .

  DATA : lv_user TYPE string.
  lv_user = p_userid.         " GUI User ID

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
  v_value = lv_user.
  v_document->create_simple_element( name = v_author  value = v_value  parent = v_element_properties  ).

ENDFORM.

FORM f_style_for_header .

  v_style  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles ).
  v_style->set_attribute_ns( name = v_id  prefix = v_ss  value = v_header ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '1' ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#000000' ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_left ).

  " Border
  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

ENDFORM.

FORM f_style_for_lineitem .

  v_style1  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '0' ).

  " Border
  v_border  = v_document->create_simple_element( name = v_borders  parent = v_style1 ).
  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_bottom ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_left ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_top ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

  v_format  = v_document->create_simple_element( name = v_xlborder   parent = v_border  ).
  v_format->set_attribute_ns( name = v_position  prefix = v_ss  value = v_right ).
  v_format->set_attribute_ns( name = v_linestyle  prefix = v_ss  value = v_continuous ).
  v_format->set_attribute_ns( name = v_weight  prefix = v_ss  value = '1' ).

ENDFORM.

FORM f_style_for_numbers .

  v_style1  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata1 ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '###0' ).

ENDFORM.

FORM f_create_sheet USING fp_docname.

  " Worksheet
  v_worksheet = v_document->create_simple_element( name = v_xlworksheet  parent = v_element_root ).
  v_worksheet->set_attribute_ns( name = v_name  prefix = v_ss  value = fp_docname ).

ENDFORM.

FORM f_build_table .

  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

ENDFORM.

FORM f_column_formatting .

  " Product
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Product Description
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Sub reference No
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

ENDFORM.

FORM f_header_row_format .

  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

ENDFORM.

FORM f_header_columns .

  " Build Column Header Text
  PERFORM f_build_header_names USING text-f01.  " Product
  PERFORM f_build_header_names USING text-f02.  " Product Description
  PERFORM f_build_header_names USING text-f03.  " Quantity
  PERFORM f_build_header_names USING text-h03.  " Sub reference No

ENDFORM.

FORM f_build_header_names USING fp_text TYPE string.

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header ).
  v_data = v_document->create_simple_element( name = v_xldata  value = fp_text  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).

ENDFORM.

FORM f_fill_data .

  DATA  : lv_quantity TYPE char16.

  LOOP AT i_excel_output ASSIGNING FIELD-SYMBOL(<lfs_fill_data>).

    v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

    " Product
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-matnr.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Product Description
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-maktx.
    CONDENSE v_value.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Quantity
    CLEAR lv_quantity.
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    WRITE <lfs_fill_data>-zmeng TO lv_quantity DECIMALS 0.
    v_value = lv_quantity.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Sub reference No
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-ihrez.
    CONDENSE v_value.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

  ENDLOOP.

ENDFORM.

FORM f_prepare_excel_data .

  REFRESH i_excel_output[].

  IF i_vbap[] IS NOT INITIAL.
    LOOP AT i_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).

      APPEND INITIAL LINE TO i_excel_output ASSIGNING FIELD-SYMBOL(<lfs_excel_output>).
      <lfs_excel_output>-matnr = <lfs_vbap>-matnr.      " Prodcut
      <lfs_excel_output>-zmeng = <lfs_vbap>-zmeng.      " Quantity
      <lfs_excel_output>-maktx = <lfs_vbap>-maktx.      " Product desciption

      IF i_vbkd[] IS NOT INITIAL.
        READ TABLE i_vbkd ASSIGNING FIELD-SYMBOL(<lfs_vbkd>) WITH KEY vbeln = <lfs_vbap>-vbeln  posnr = <lfs_vbap>-posnr BINARY SEARCH.
        IF <lfs_vbkd> IS ASSIGNED.
          <lfs_excel_output>-ihrez = <lfs_vbkd>-ihrez.    " Sub ref. ID
          UNASSIGN <lfs_vbkd>.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.

FORM f_generate_xml_file .

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

FORM f_get_email .

  " Data declaration for Receiver Email address and BAPI
  DATA : ls_addr TYPE bapiaddr3.
  DATA : li_return TYPE TABLE OF bapiret2.

  FIELD-SYMBOLS : <lfs_const> TYPE ty_constant.

  CONSTANTS : lc_email    TYPE rvari_vnam VALUE 'E_MAIL',
              lc_receiver TYPE rvari_vnam VALUE 'RECEIVER'.

  FREE : v_sender , v_receiver.
  " Get Sender email adress
  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant ASSIGNING <lfs_const> WITH KEY param1 = lc_email BINARY SEARCH.
    IF sy-subrc = 0.
      v_sender = <lfs_const>-low.      " Set Sender email address
    ENDIF.

    " Get Sender email adress
    READ TABLE i_constant ASSIGNING <lfs_const> WITH KEY param1 = lc_receiver BINARY SEARCH.
    IF sy-subrc = 0.
      v_receiver = <lfs_const>-low.      " Set receiver email address
    ENDIF.
  ENDIF.

  IF v_receiver IS INITIAL.   " Distribution list email is blank will be used the GUI user email address
    v_recname = sy-uname." p_userid.         " GUI username

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
      READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WITH KEY type = c_errtype BINARY SEARCH..
      IF sy-subrc = 0.
        MESSAGE <lfs_return>-message TYPE c_errtype.
        UNASSIGN <lfs_return>.
      ENDIF.
    ENDIF.

    " Set receiver email address
    v_receiver = ls_addr-e_mail.
    FREE ls_addr.
  ENDIF.

ENDFORM.

FORM f_send_mail .

  DATA: li_objpack  TYPE STANDARD TABLE OF sopcklsti1,
        lst_objpack TYPE sopcklsti1.

  DATA: li_objhead  TYPE STANDARD TABLE OF solisti1,
        lst_objhead TYPE solisti1.

  DATA: li_objbin  TYPE STANDARD TABLE OF solix,
        lst_objbin TYPE solix.

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
  CONCATENATE st_vbak-vbeln text-b01 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lv_doc_chng-obj_descr. " _Order confirmation to SPUR_
  CONCATENATE lv_doc_chng-obj_descr '_' lv_time INTO lv_doc_chng-obj_descr.

*Set the Body background colour
  st_objtxt-line = '<body bgcolor = "#FFFFFF">'.
  APPEND st_objtxt TO i_objtxt.
  CLEAR st_objtxt.

*Set font color and its type
  CONCATENATE '<FONT COLOR = "#000000">' '' INTO st_objtxt-line.
  APPEND st_objtxt TO i_objtxt.
  CLEAR st_objtxt.

*Prepare mail body
  CONCATENATE '<p>' 'Dear SPUR Team: ' '</p>'
              INTO st_objtxt-line.
  APPEND st_objtxt TO i_objtxt.
  CLEAR st_objtxt.

  st_objtxt-line = space.
  APPEND st_objtxt TO i_objtxt.
  CLEAR st_objtxt.

  CONCATENATE '<p>'
              'Subscription for' '<font color = "RED"> Agent' '<font color = "#000000"> is created with renewal with below details.'(004)
              '</p>'
              INTO st_objtxt-line SEPARATED BY space.

  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

* Data format to dispay in Mail body
  st_objtxt-line = '<TABLE  width= "65%" border="0">'.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

  DATA(v_name) = |{ v_name1 }  { v_name2 }|.
  " 1st row
  PERFORM f_build_header_data USING text-h01      " Quote Number | End cistomer name
                                    v_vgbel
                                    text-h02.
  "  text-h13.
  " 2nd row
  PERFORM f_build_header_data USING text-h05       " text-h03       PO Number
                                    st_vbak-bstnk  " st_vbak-ihrez
                                   " text-h04
                                    v_name.
  " 3rd row
  PERFORM f_build_header_data USING text-h07       " text-h05       Order creation date
                                    v_date         " st_vbak-bstnk
                                   " text-h06
                                    v_stras.
  "4th Row
  PERFORM f_build_header_data USING text-h14       " text-h05       order released date
                                  v_date_rel         " st_vbak-bstnk
                                 " text-h06
                                  v_pstlz.

  " 5th row
  PERFORM f_build_header_data USING text-h09       " text-h07       End customer Number
                                    v_endcustomer  " v_date
                                   " text-h08
                                    v_country.
  CLEAR:v_country.
  " 6th row
  PERFORM f_build_header_data USING text-h11
                                    v_agent_name   " text-h09       Agent Name
                                    "text-h10      " v_endcustomer
                                    v_country.
*  "6th row
*  PERFORM f_build_header_data USING text-h11
*                                    v_agent_name
*                                   " text-h12
*                                    text-h10.

  st_objtxt-line = '</TABLE>'.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

  CONCATENATE '<p>' ' This is an auto generated Email - Please do not reply' '</p>'
                 INTO st_objtxt-line SEPARATED BY space.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

  st_objtxt-line = '</FONT></body>'.
  APPEND st_objtxt TO i_objtxt.
  CLEAR st_objtxt.

  DESCRIBE TABLE i_objtxt LINES lv_tab_lines.
  READ TABLE i_objtxt INTO st_objtxt INDEX lv_tab_lines.
  lv_doc_chng-doc_size = ( lv_tab_lines - 1 ) * 255 + strlen( st_objtxt ).

* Packing List For the E-mail Body
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num   = lv_tab_lines.
  lst_objpack-doc_type   = 'HTM'.  "'RAW'.
  APPEND lst_objpack TO li_objpack.

* Creation of the Document Attachment
  LOOP AT i_xml_table ASSIGNING <gfs_xml>.
    CLEAR lst_objbin.
    lst_objbin-line = <gfs_xml>-data.
    APPEND lst_objbin TO li_objbin.
  ENDLOOP.

  DESCRIBE TABLE li_objbin LINES lv_tab_lines.
  lst_objhead = text-b05.
  APPEND lst_objhead TO li_objhead.

* Packing List For the E-mail Attachment
  lst_objpack-transf_bin = lc_x.
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num = lv_tab_lines.
  CONCATENATE st_vbak-vbeln text-b01 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lst_objpack-obj_descr.
  CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
  lst_objpack-doc_type = 'XLS'.
  lst_objpack-doc_size = lv_tab_lines * 255.
  APPEND lst_objpack TO li_objpack.

* Target Recipent
  CLEAR lst_reclist.
  lst_reclist-receiver = v_receiver.  " GUI User Email address or Distribution list email
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
      sender_address             = v_sender       " noreply@wiley.com
      sender_address_type        = lc_addtype
*     commit_work                = lc_x
    TABLES
      packing_list               = li_objpack
      object_header              = li_objhead
      contents_txt               = i_objtxt
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

  IF sy-subrc EQ 0.
    MESSAGE s590(zqtc_r2).      " email sent succesfully
  ENDIF.
  CLEAR : i_objtxt[],v_receiver,v_recname.

ENDFORM.

FORM f_build_email_body  CHANGING fp_v_date        TYPE char10
                                  fp_v_date_rel    TYPE char10
                                  fp_v_endcustomer TYPE kunnr
                                  fp_v_name1       TYPE name1_gp
                                  fp_v_name2       TYPE name2_gp
                                  fp_v_pstlz       TYPE pstlz
                                  fp_v_stras       TYPE stras_gp
                                  fp_v_agent_name  TYPE char70
                                  fp_v_country     TYPE land1_gp
                                  fp_v_vgbel       TYPE vgbel.

  CONSTANTS : lc_separator TYPE char01 VALUE '/'.

  CLEAR : fp_v_date,
          fp_v_date_rel,
          fp_v_endcustomer,
          fp_v_name1 ,
          fp_v_name2,
          fp_v_pstlz,
          fp_v_stras,
          fp_v_agent_name,
          fp_v_vgbel.

  DATA(lv_date) = st_vbak-erdat.
  CONCATENATE lv_date+4(2) lc_separator lv_date+6(2) lc_separator lv_date+0(4) INTO fp_v_date.

*---Order Release Date

  SELECT SINGLE erdat FROM nast INTO @DATA(lv_erdat) WHERE objky = @nast-objky AND kschl = @nast-kschl.
  IF sy-subrc = 0.
    CONCATENATE lv_erdat+4(2) lc_separator lv_erdat+6(2) lc_separator lv_erdat+0(4) INTO fp_v_date_rel.
  ENDIF.

  IF i_partner[] IS NOT INITIAL.
    " End Customer Number(Ship to Party)
    READ TABLE i_partner ASSIGNING FIELD-SYMBOL(<lfs_partner>) WITH KEY vbeln = st_vbak-vbeln parvw = c_type_sh BINARY SEARCH.
    IF sy-subrc = 0.
      fp_v_endcustomer = <lfs_partner>-kunnr.
      fp_v_name1       = <lfs_partner>-name1.
      fp_v_name2       = <lfs_partner>-name2.
      fp_v_pstlz       = <lfs_partner>-pstlz.
      fp_v_stras       = <lfs_partner>-stras.
      fp_v_country     = <lfs_partner>-land1.
    ENDIF.

    " Agent Name(Sold to Party)
    READ TABLE i_partner ASSIGNING <lfs_partner> WITH KEY vbeln = st_vbak-vbeln parvw = c_type_sp BINARY SEARCH.
    IF sy-subrc = 0.
      CONCATENATE <lfs_partner>-name1 <lfs_partner>-name2 INTO fp_v_agent_name SEPARATED BY space.
      CONDENSE fp_v_agent_name.
    ENDIF.
  ENDIF.

  " Quote Number
  IF i_vbap[] IS NOT INITIAL.
    READ TABLE i_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>) WITH KEY vbeln = st_vbak-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      fp_v_vgbel = <lfs_vbap>-vgbel.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_build_header_data USING fp_param1
                               fp_param2
                               fp_param3.
  "fp_param4.

  CONCATENATE '<TR ><td align = "LEFT" BGCOLOR = "#FFFFFF">'
                '<FONT COLOR = "#000000">' fp_param1 '</FONT>'
                  '</td>'  INTO st_objtxt-line.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.
  IF fp_param1 = text-h11.
    CONCATENATE '<td align = "LEFT"  BGCOLOR = "#FFFFFF">'
                  '<FONT COLOR = "RED">' fp_param2 '</FONT>'
                  '</td>'  INTO st_objtxt-line.
    APPEND st_objtxt TO i_objtxt.
    CLEAR  st_objtxt.
  ELSE.
    CONCATENATE '<td align = "LEFT"  BGCOLOR = "#FFFFFF">'
                  '<FONT COLOR = "#000000">' fp_param2 '</FONT>'
                  '</td>'  INTO st_objtxt-line.
    APPEND st_objtxt TO i_objtxt.
    CLEAR  st_objtxt.
  ENDIF.
  CONCATENATE '<td align = "LEFT"  BGCOLOR = "#FFFFFF">'
              '<FONT COLOR = "#000000">' fp_param3 '</FONT>'
              '</td>'  INTO st_objtxt-line.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

*  CONCATENATE '<td align = "LEFT"  BGCOLOR = "#FFFFFF">'
*            '<FONT COLOR = "#000000">' fp_param4  '</FONT>'
*            '</td>'  INTO st_objtxt-line.
  APPEND st_objtxt TO i_objtxt.
  CLEAR  st_objtxt.

ENDFORM.

FORM f_get_business_data  USING    fp_i_vbap TYPE tt_vbap
                          CHANGING fp_i_vbkd TYPE tt_vbkd.

  REFRESH fp_i_vbkd[].
  IF fp_i_vbap[] IS NOT INITIAL.
    SELECT vbeln,posnr,ihrez
      FROM vbkd
      INTO TABLE @fp_i_vbkd
      FOR ALL ENTRIES IN @fp_i_vbap
      WHERE vbeln = @fp_i_vbap-vbeln    AND
            posnr = @fp_i_vbap-posnr.
    IF sy-subrc IS INITIAL.
      SORT fp_i_vbkd BY vbeln posnr.
    ENDIF.
  ENDIF.

ENDFORM.
