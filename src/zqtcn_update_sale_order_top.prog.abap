*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_UPDATE_SALE_ORDER
*& PROGRAM DESCRIPTION:   Program to update  sales order
*&                        Rep value
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627
*&----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREATE_SALES_ORDER_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S
*&---------------------------------------------------------------------*
 TYPES :   BEGIN OF ty_vbak,
             vbeln TYPE vbeln_va,             " Sales Document
             erdat TYPE erdat,                " DAte on which record was created
             auart TYPE auart,                " Sales doc tye
             vkorg TYPE vkorg,
             vkbur TYPE vkbur,
             knumv TYPE knumv,
             bsark TYPE bsark,
             kunnr TYPE kunag,
           END OF ty_vbak,

           BEGIN OF ty_input,
             vbeln  TYPE vbeln_va,                                   " Sales Document
             posnr  TYPE posnr,                                      " Item number of the SD document
             nsrep1 TYPE epernr,                                     " Personnel Number
             nsrep2 TYPE epernr,                                     " Personnel Number
             flag   TYPE char1,
           END OF ty_input,

           BEGIN OF ty_alv,
             vbeln    TYPE vbeln_va,                                  " Sales Document
             posnr    TYPE posnr,                                     " Item number of the SD document
             auart    TYPE auart,                                     " Sales Document Type
             type     TYPE bdc_mart,
             document TYPE vbeln,
             message  TYPE bapi_msg,                                  " Message Text
           END OF ty_alv,

           BEGIN OF ty_constant,
             devid  TYPE zdevid,                                     " Development ID
             param1 TYPE rvari_vnam,                                 " ABAP: Name of Variant Variable
             param2 TYPE rvari_vnam,                                 " ABAP: Name of Variant Variable
             srno   TYPE tvarv_numb,                                 " ABAP: Current selection number
             sign   TYPE tvarv_sign,                                 " ABAP: ID: I/E (include/exclude values)
             opti   TYPE tvarv_opti,                                 " ABAP: Selection option (EQ/BT/CP/...)
             low    TYPE salv_de_selopt_low,                         " Lower Value of Selection Condition
             high   TYPE salv_de_selopt_high,                        " Upper Value of Selection Condition
           END OF ty_constant,
           tt_alv TYPE STANDARD TABLE OF ty_alv.


*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
 DATA : i_input    TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0,
        i_alv      TYPE STANDARD TABLE OF ty_alv INITIAL SIZE 0,
        i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
        i_fcat     TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
        i_vbak     TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0.


*&--------------------------------------------------------------------*
*& V A R I A B L E
*&-------------------------------------------------------------------
 DATA : v_input TYPE char2000,
        v_vbeln TYPE bapivbeln-vbeln.
*&--------------------------------------------------------------------*
*& CONSTANTS
*&-------------------------------------------------------------------

 CONSTANTS : c_doctype   TYPE bapisdhd1-doc_type VALUE 'ZSUB',
             c_e         TYPE char1 VALUE 'E',
             c_parvw_ag  TYPE parvw VALUE 'AG',               " Partner Function
             c_parvw_ze  TYPE parvw VALUE 'ZE',               " Partner Function
             c_parvw_ve  TYPE parvw VALUE 'VE',               " Partner Function.
             c_x         TYPE char1 VALUE 'X',
             c_s         TYPE char1 VALUE 'S',
             c_posnr_hdr TYPE posnr   VALUE '000000' .       " Item number of the SD document
