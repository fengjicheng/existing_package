*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCN_CONVENTION_DEMAND_TOP
* PROGRAM DESCRIPTION: Top include
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-03-01
* OBJECT ID: E151
* TRANSPORT NUMBER(S): ED2K904707(W),ED2K904827(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K905904
* Reference No:  JIRA Defect# ERP-1947
* Developer: Monalisa Dutta
* Date:  2017-05-05
* Description: Conference  Po already exists for the issue to be displayed
* in output
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONVENTION_DEMAND_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Structure
*&---------------------------------------------------------------------*
 TYPES: BEGIN OF ty_upload_file,
          matnr         TYPE matnr, "Material
          quantity      TYPE bamng,  "Quantity
          requisitioner TYPE afnam,  "Requisitioner
          tracking_no   TYPE bednr,  "Tracking No
          text          TYPE tdline, "Line Item text
        END OF ty_upload_file,

        tt_upload_file TYPE STANDARD TABLE OF ty_upload_file
                       INITIAL SIZE 0,

        BEGIN OF ty_knttp,
          sign   TYPE ddsign, "Sign
          option TYPE ddoption, "option
          low    TYPE knttp, "low
          high   TYPE knttp, "high
        END OF ty_knttp,

        tt_knttp TYPE STANDARD TABLE OF ty_knttp
                 INITIAL SIZE 0,

        BEGIN OF ty_matnr,
          matnr TYPE matnr, "Material Number
        END OF ty_matnr,

        tt_matnr TYPE STANDARD TABLE OF ty_matnr
            INITIAL SIZE 0,

        BEGIN OF ty_output,
          purchase_req   TYPE banfn,  "Purchase requisition
*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
          purchase_order TYPE ebeln, "Purchase Order
          line_item      TYPE ebelp, "Purchase Order Line Items
          material       TYPE matnr, "Material Number
*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
          type           TYPE edi_symsty, "type
          id             TYPE edi_stamid, "id
          number         TYPE edi_stamno, "number
          message        TYPE bapi_msg, "message
          status         TYPE char1,
        END OF ty_output,

        tt_output TYPE STANDARD TABLE OF ty_output
             INITIAL SIZE 0,

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

        tt_constant TYPE STANDARD TABLE OF ty_constant
                    INITIAL SIZE 0,

        BEGIN OF ty_mvke,
          matnr TYPE matnr, "Material Number
          vkorg TYPE vkorg, "Sales Org
          vtweg TYPE vtweg,  "Distribution Channel
          dwerk TYPE dwerk_ext, "Delivery Plant
        END OF ty_mvke,

        tt_mvke TYPE STANDARD TABLE OF ty_mvke INITIAL SIZE 0,

        BEGIN OF ty_mara,
          matnr TYPE matnr, "Material
          meins TYPE meins, "UOM
        END OF ty_mara,

        tt_mara TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,

        BEGIN OF ty_records,
          matnr    TYPE matnr,   "Material
          plant    TYPE werks_d, "Plant
          werks    TYPE ewerk,   "Plant
          lifnr    TYPE elifn,   "Vendor
          flifn    TYPE flifn,   "Supplying Vendor
          ekorg    TYPE ekorg,   "Purchasing Org
          autet    TYPE autet,   "Usage in automatic MRP
          ebeln    TYPE ebeln,   "Purchase Order
*<<<<<<<<<<<<BOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
          ebelp    TYPE ebelp,   "Line items of PO
          loekz    TYPE eloek, "Deletion Indicator in Purchasing Document
          po_werks TYPE werks_d, "Plant
*<<<<<<<<<<<<EOC by MODUTTA on 05/05/2017 for JIRA Defect# ERP-1947>>>>>>>>>>
          knttp    TYPE knttp,   "Account Assignment category
          bsart    TYPE esart,   "Document Category
          maktx    TYPE maktx,   "Material Description
        END OF ty_records,

        tt_records TYPE STANDARD TABLE OF ty_records INITIAL SIZE 0.
*&---------------------------------------------------------------------*
*&  Internal Table
*&---------------------------------------------------------------------*
 DATA:  i_upload_file TYPE tt_upload_file, " File format
        i_constant    TYPE tt_constant, " Constant table
        i_output      TYPE tt_output. "Output Structure
*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
 CONSTANTS:  c_field      TYPE dynfnam VALUE 'P_FILE',
             " Field name: for Local file
             c_status_suc TYPE char1 VALUE '3',   "Status: Green/Success
             c_status_err TYPE char1 VALUE '1',   "Status: Red/Error
             c_status_war TYPE char1 VALUE '2',   "Status: Yellow/Warnings
             c_rucomm     TYPE syucomm VALUE 'RUCOMM', "Function Code
             c_error      TYPE char1 VALUE 'E', "For error type
             c_success    TYPE char1 VALUE 'S' , "for success
             c_onli       TYPE syucomm VALUE 'ONLI', " Function Code
             c_char_blank TYPE char1 VALUE '',
             c_sign_incld TYPE ddsign  VALUE 'I',  "Sign: (I)nclude
             c_opti_equal TYPE ddoption  VALUE 'EQ'. "Option: (EQ)ual
*&---------------------------------------------------------------------*
*& Global Variables
*&---------------------------------------------------------------------*
 DATA: v_bsart TYPE ekko-bsart,  "Purchasing Document Type
       v_knttp TYPE ekpo-knttp.  "Account Assignment Type
