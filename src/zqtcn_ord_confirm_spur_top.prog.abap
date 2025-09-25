*&---------------------------------------------------------------------*
* Program Name : ZQTCN_ORD_CONFIRM_SPUR_TOP                            *
* REVISION NO:  ED2K925398                                             *
* REFERENCE NO: OTCM-51319                                             *
* DEVELOPER :   Lahiru Wathudura (LWATHUDURA)                          *
* DATE:  01/06/2022                                                    *
* DESCRIPTION: Indian Agents Order confirmation to SPUR team using     *
*              ZIAC Output type                                        *
*----------------------------------------------------------------------*

TABLES: nast,     " Message Status
        tnapr.    " Processing programs for output

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

TYPES : BEGIN OF ty_vbak,                   " Structure declaration for sales header data
          vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          bstnk TYPE bstnk,
          bsark TYPE bsark,
          ihrez TYPE ihrez,
        END OF ty_vbak.

TYPES : BEGIN OF ty_vbap,                   " Structure declaration for sales item data
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          matnr TYPE matnr,
          zmeng TYPE dzmeng,
          vgbel TYPE vgbel,
          maktx TYPE maktx,
        END OF ty_vbap,
        tt_vbap TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0.

TYPES : BEGIN OF ty_partner_details,        " Structure for Patner details
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          parvw TYPE parvw,
          kunnr TYPE kunnr,
          adrnr TYPE adrnr,
          land1 TYPE land1_gp,
          name1 TYPE name1_gp,
          name2 TYPE name2_gp,
          pstlz TYPE pstlz,
          stras TYPE stras_gp,
        END OF ty_partner_details,
        tt_partner TYPE STANDARD TABLE OF ty_partner_details INITIAL SIZE 0.

TYPES : BEGIN OF ty_vbkd,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          IHREZ TYPE IHREZ,
        END OF ty_vbkd,
        tt_vbkd TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0.

TYPES : BEGIN OF ty_excel_output,
          matnr TYPE matnr,
          maktx TYPE maktx,
          zmeng TYPE dzmeng,
          ihrez TYPE ihrez,
        END OF ty_excel_output.


TYPES: BEGIN OF xml_line,
         data(255) TYPE x,
       END OF xml_line.

DATA: i_constant     TYPE STANDARD TABLE OF ty_constant,                      " Itab declaration for constant table
      v_retcode      TYPE sy-subrc,                                           " Returncode
      v_xscreen(1)   TYPE c,                                                  " Output on printer or screen
      v_sales_doc    TYPE vbeln_va,                                           " Sales Document No
      st_vbco3       TYPE vbco3,                                              " Sales Doc.Access Methods: Key Fields: Document Printing
      st_vbak        TYPE ty_vbak,                                            " Struture for sales header data
      i_vbap         TYPE tt_vbap,                                            " ITAB Declaration for sales item details
      i_partner      TYPE tt_partner,                                         " Itab declaration for Partner details
      i_excel_output TYPE STANDARD TABLE OF ty_excel_output INITIAL SIZE 0,   " Itab declaration for Partner details
      v_date         TYPE char10,
      v_date_rel     TYPE char10,
      v_endcustomer  TYPE kunnr,
      v_name1        TYPE name1_gp,
      v_name2        TYPE name2_gp,
      v_pstlz        TYPE pstlz,
      v_stras        TYPE stras_gp,
      v_country      TYPE land1_gp,
      v_agent_name   TYPE char70,
      v_vgbel        TYPE vgbel,
      i_vbkd         TYPE tt_vbkd.                                            " Itab declaration for sales document business data.

DATA : ir_parvw  TYPE wtysc_parvw_range_tab.             " Range table declaration for partner function

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
      v_renderer           TYPE REF TO if_ixml_renderer,
      v_border             TYPE REF TO if_ixml_element.

DATA : v_workbook     TYPE string,                       " Excel property declaration
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
       v_xlformat     TYPE string,
       v_borders      TYPE string,
       v_xlborder     TYPE string,
       v_position     TYPE string,
       v_bottom       TYPE string,
       v_linestyle    TYPE string,
       v_continuous   TYPE string,
       v_weight       TYPE string,
       v_top          TYPE string,
       v_right        TYPE string.

DATA : v_sender   TYPE soextreci1-receiver,       " email sender address
       v_recname  TYPE bapibname-bapibname,       " email receiver address
       v_receiver TYPE soextreci1-receiver,       " email receiver address
       i_objtxt   TYPE STANDARD TABLE OF solisti1,
       st_objtxt  TYPE solisti1.

FIELD-SYMBOLS : <gfs_xml>   TYPE xml_line.

CONSTANTS : c_devid    TYPE zdevid     VALUE 'R146',       " DEV ID
            c_partner  TYPE rvari_vnam VALUE 'PARTNER',    " Partner
            c_type_sp  TYPE parvw      VALUE 'AG',         " Sold to party
            c_type_sh  TYPE parvw      VALUE 'WE',         " Ship to party
            c_output   TYPE rvari_vnam VALUE 'OUTPUT',     " Output type
            c_medium   TYPE na_nacha   VALUE '5',          " Output type
            c_potype   TYPE rvari_vnam VALUE 'PO_TYPE',       " PO type
            c_posnr    TYPE posnr_va   VALUE '000000',     " LIne Item No
            c_errtype  TYPE char1      VALUE 'E',          " Error messege
            c_infotype TYPE char1      VALUE 'I'.          " Information messegae
