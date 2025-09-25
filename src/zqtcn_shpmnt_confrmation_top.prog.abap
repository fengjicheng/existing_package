*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCN_SHPMNT_CONFRMATION_TOP
* PROGRAM DESCRIPTION: Include for global data and types declaration
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2016-12-23
* OBJECT ID: I0256
* TRANSPORT NUMBER(S):ED2K903891(W)/ED2K903977(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K910605
* Reference No: ERP-6331
* Developer: Pavan Bandlapalli(PBANDLAPAL)
* Date:  2018-01-30
* Description: File Name is being updated in the header segment. Initially it
*              was showing as wrong file name.
*------------------------------------------------------------------- *
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Nageswara (NPOLINA)
* Date:  2020-01-06
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED1K912595
* Reference No:  PRB0047015
* Developer: Nikhilesh Palla (NPALLA)
* Date:  2021-01-15
* Description: Capture only Errors in AL11 file
*------------------------------------------------------------------- *

*&---------------------------------------------------------------------*
*&  Include  ZQTCN_SHPMNT_CONFRMATION_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  S T R U C T U R E S                                                *
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_upload_file,
          journal        TYPE char20, "Journal Acronym
          pub_set        TYPE char20, "PUB SET
          matnr          TYPE matnr,  "material
          lodgement_date TYPE char10, "Lodgement date
          issue_vol      TYPE char20, "issue Volume
          issue_to_vol   TYPE char20, "issue To Volume
          issue_num      TYPE char20, "Issue Number
          issue_to_num   TYPE char20, "issue To Number
          issue_part     TYPE char20, "issue Part
          issue_to_part  TYPE char20, "Issue to Part
* BOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
          file_name      TYPE string,   " Input File Name
* EOI by PBANDLAPAL on 30-Jan-2018 for ERP-6331: ED2K910605
        END OF ty_upload_file,

        BEGIN OF ty_upload_char,
          journal        TYPE char20, "Journal Acronym
          pub_set        TYPE char20, "PUB SET
          matnr          TYPE char18,  "material
          lodgement_date TYPE char10, "Lodgement date
          issue_vol      TYPE char20, "issue Volume
          issue_to_vol   TYPE char20, "issue To Volume
          issue_num      TYPE char20, "Issue Number
          issue_to_num   TYPE char20, "issue To Number
          issue_part     TYPE char20, "issue Part
          issue_to_part  TYPE char20, "Issue to Part
        END OF ty_upload_char,

        BEGIN OF ty_output_det,
          idoc_number  TYPE edi_docnum, "Idoc Number
          po_number    TYPE ebeln,
*          delivery     TYPE vbeln_vl, *Commented by MODUTTA on 19/05/2017 for CR# 456
          material_doc TYPE mblnr,
          type         TYPE edi_symsty, "type
          id           TYPE edi_stamid, "id
          number       TYPE edi_stamno, "number
          message      TYPE bapi_msg, "message
        END OF ty_output_det,

        BEGIN OF ty_ekko,
          ebeln TYPE ebeln, "Purchase document number
          aedat TYPE erdat, "Document date
          lifnr TYPE elifn, "vendor
          bedat TYPE ebdat, "Purchase document date
        END OF ty_ekko,

        BEGIN OF ty_ekpo,
          ebeln TYPE ebeln,        " Purchasing Document Number
          ebelp TYPE ebelp,        " Item Number of Purchasing Document
          matnr TYPE matnr,        " Material
          werks TYPE werks_d,      " Plant
          menge TYPE bstmg,        " Quantity
          meins TYPE bstme,        " Unit
        END OF ty_ekpo,

        BEGIN OF ty_ekbe,
          ebeln TYPE ebeln,        " Purchasing Document Number
          ebelp TYPE ebelp,        " Item Number of Purchasing Document
          belnr TYPE mblnr,
          bwart TYPE bwart,
          menge TYPE menge_d,
          shkzg TYPE shkzg,
        END OF ty_ekbe,

        BEGIN OF ty_ekkn,
          ebeln TYPE ebeln,      "Purchasing Document Number
          ebelp TYPE ebelp,      "Line Item
          zekkn TYPE dzekkn,     "Counter
          menge TYPE menge_d,    "Quantity
          vbeln TYPE vbeln_co,   "Sales Document
          vbelp TYPE posnr_co,   "Sales Document Item
        END OF ty_ekkn,

        BEGIN OF ty_likp,
          vbeln TYPE vbeln,    "Delivery
          vstel TYPE vstel,    "Ship Point
          vkorg TYPE vkorg,    "Sales Organization
          lfart TYPE lfart,    "Vendor
          lprio TYPE lprio,    "Delivery Priority
          vsbed TYPE vsbed,    "Shipping Conditions
          tragr TYPE tragr,    "Transportation Group
          podat TYPE podat,    "Date
          potim TYPE potim,    "Confirmation time
        END OF ty_likp,

        BEGIN OF ty_lips,
          vbeln TYPE vbeln_vl,    "Delivery
          posnr TYPE posnr_vl,    "Delivery Item
          pstyv TYPE pstyv_vl,    "Category
          matnr TYPE matnr,       "Material
          werks TYPE werks_d,     "Plant
          lgort TYPE lgort_d,     "Storage Loc
          lfimg TYPE lfimg,       "Actual quantity delivered (in sales units)
          meins TYPE meins,       "Base unit of measure
          vrkme TYPE vrkme,       "Sales unit
          umvkz TYPE umvkz,       "Numerator (factor) for conversion of sales quantity into SKU
          umvkn TYPE umvkn,       "Denominator (Divisor) for Conversion of Sales Qty into SKU
          uebto TYPE uebto,       "Overdelivery Tolerance Limit
          untto TYPE untto,       "Underdelivery Tolerance Limit
          lgmng TYPE lgmng,       "Actual quantity delivered in stockkeeping units
          vgbel TYPE vgbel,       "Document Number in reference Document
          vgpos TYPE vgpos,       "Item number of the reference item
          vtweg TYPE vtweg,       "Distribution Channel
          spart TYPE spart,       "Division
          ormng TYPE ormng,       "Original Quantity of Delivery Item
        END OF ty_lips,

        BEGIN OF ty_delivery,
          po_number TYPE ebeln,
          delivery  TYPE vbeln_vl, "delivery
        END OF ty_delivery,

        BEGIN OF ty_constant,
          devid  TYPE zdevid,              " Development ID
          param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,          " ABAP: Current selection number
          sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
        END OF ty_constant,

        BEGIN OF ty_idoc_number,
          idoc_number TYPE char70,
        END OF ty_idoc_number,


        BEGIN OF ty_mseg,
          mblnr TYPE mblnr,
          zeile TYPE mblpo,
          menge TYPE menge_d,
          meins TYPE meins,
          ebeln TYPE ebeln,
          ebelp TYPE ebelp,
        END OF ty_mseg,

       BEGIN OF ty_xml_line,  " Structure for xml line
         data(255) TYPE x,
       END OF ty_xml_line,

       BEGIN OF ty_filenames,  " Structure for xml line
         data(255) TYPE c,
       END OF ty_filenames,
*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
        tt_upload_file TYPE STANDARD TABLE OF ty_upload_file
                         INITIAL SIZE 0,
        tt_output_det  TYPE STANDARD TABLE OF ty_output_det
                         INITIAL SIZE 0,
        tt_item        TYPE STANDARD TABLE OF e1bp2017_gm_item_create
                         INITIAL SIZE 0,
        tt_edidd       TYPE STANDARD TABLE OF edidd
                         INITIAL SIZE 0,
        tt_ekko        TYPE STANDARD TABLE OF ty_ekko
                         INITIAL SIZE 0,
        tt_ekpo        TYPE STANDARD TABLE OF ty_ekpo
                         INITIAL SIZE 0,
        tt_ekbe        TYPE STANDARD TABLE OF ty_ekbe
                         INITIAL SIZE 0,
        tt_ekkn        TYPE STANDARD TABLE OF ty_ekkn
                         INITIAL SIZE 0,
        tt_likp        TYPE STANDARD TABLE OF ty_likp
                         INITIAL SIZE 0,
        tt_lips        TYPE STANDARD TABLE OF ty_lips
                         INITIAL SIZE 0,
        tt_delivery    TYPE STANDARD TABLE OF ty_delivery
                         INITIAL SIZE 0,
        tt_constant    TYPE STANDARD TABLE OF ty_constant
                 INITIAL SIZE 0 ,
        tt_idoc_number TYPE STANDARD TABLE OF ty_idoc_number INITIAL SIZE 0,
        tt_mseg        TYPE STANDARD TABLE OF ty_mseg INITIAL SIZE 0.
*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA: i_upload_file  TYPE tt_upload_file, "Upload file
      i_output_det   TYPE tt_output_det, "Output details
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      i_output_det_err   TYPE tt_output_det, "Output details  "++ED1K912595
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
      i_ekkn         TYPE tt_ekkn, "ekkn
      i_ekbe         TYPE tt_ekbe, " PO history data.
      i_constant     TYPE tt_constant, "constant table
      i_ekpo         TYPE tt_ekpo, "Item EKPO table
      i_fieldcatalog TYPE slis_t_fieldcat_alv, "fieldcatalog table
      i_filenames    TYPE TABLE OF ty_filenames.   "ERPM2204 NPOLINA
*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS: c_field  TYPE dynfnam VALUE 'P_FILE', " Field name: for Local file
           c_rucomm TYPE syucomm VALUE 'RUCOMM', "Function Code
           c_onli   TYPE syucomm VALUE 'ONLI', " Function Code
           c_inf    TYPE char1   VALUE 'I'.      " NPOLINA ERPM2204 6/Jan/2020 ED2K917189

*&---------------------------------------------------------------------*
*& W O R K A R E A
*&---------------------------------------------------------------------*
DATA: st_edidc_po TYPE edidc, " for control structure of PO goods receipt
      st_edidc_so TYPE edidc, " for control structure of SO goods issue
* SOC by NPOLINA ERPM2204 6/Jan/2020 ED2K917189
      st_adr6     TYPE adr6,
      i_xml_table TYPE TABLE OF ty_xml_line,
      st_xml      TYPE          ty_xml_line.
DATA:obj_ixml          TYPE REF TO   if_ixml,
     obj_streamfactory TYPE REF TO   if_ixml_stream_factory,
     obj_ostream       TYPE REF TO   if_ixml_ostream,
     obj_renderer      TYPE REF TO   if_ixml_renderer,
     obj_document      TYPE REF TO   if_ixml_document,
     obj_element_root  TYPE REF TO   if_ixml_element,
     obj_ns_attribute  TYPE REF TO   if_ixml_attribute,
     obj_element_pro   TYPE REF TO   if_ixml_element,
     obj_worksheet     TYPE REF TO   if_ixml_element,
     obj_table         TYPE REF TO   if_ixml_element,
     obj_column        TYPE REF TO   if_ixml_element,
     obj_row           TYPE REF TO   if_ixml_element,
     obj_cell          TYPE REF TO   if_ixml_element,
     obj_data          TYPE REF TO   if_ixml_element,
     v_value           TYPE          string,
     obj_styles        TYPE REF TO   if_ixml_element,
     obj_style         TYPE REF TO   if_ixml_element,
     obj_style1        TYPE REF TO   if_ixml_element,
     obj_style2        TYPE REF TO   if_ixml_element,
     obj_format        TYPE REF TO   if_ixml_element,
     obj_border        TYPE REF TO   if_ixml_element,
     i_xml_table2       TYPE TABLE OF ty_xml_line,
     st_xml2            TYPE          ty_xml_line,
     gt_fcat           TYPE          lvc_t_fcat,
     gr_credat         TYPE          fkk_rt_chdate,
     st_filenames    TYPE            ty_filenames,   "ERPM2204 NPOLINA
     v_file        TYPE rlgrap-filename,             "ERPM2204 NPOLINA
     c_att             TYPE e070a-attribute VALUE 'SAP_CTS_PROJECT'.
* EOC by NPOLINA ERPM2204 6/Jan/2020 ED2K917189
