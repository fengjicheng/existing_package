*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ICEDIS_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCR_ICEDIS_OUTBOUND_FTP                        *
* PROGRAM DESCRIPTION:Report to upload a text file onto application    *
*                     layer for ICEDIS Outbound file - FTP Agents      *
* DEVELOPER:          NMOUNIKA                                         *
* CREATION DATE:      06/27/2017                                       *
* OBJECT ID:          I0352                                            *
* TRANSPORT NUMBER(S):ED2K903899                                       *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:     ED2K912399                                          *
* REFERENCE NO:    CR#6689/6609                                        *
* DEVELOPER:       SCBEZAWADA                                          *
* DATE:            06/22/2018                                          *
* DESCRIPTION:     To handle User interface and BOM related Changes    *
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:                                                         *
* REFERENCE NO:                                                        *
* DEVELOPER:                                                           *
* DATE:                                                                *
* DESCRIPTION:                                                         *
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S                                                *
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_final,
         matnr     TYPE matnr,        " Material Number
         ismtitle  TYPE ismtitle,     " Title
         identcode TYPE ismidentcode, " Identification Code
         bstkd     TYPE bstkd,        " Customer purchase order number
         ihrez     TYPE ihrez,        " Your Reference
         kunnr     TYPE c LENGTH 315, " Customer Number
*         kunnr     TYPE kunnr,            " Customer Number
       END OF ty_final,

       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln,                "Sales Document Number
         posnr TYPE posnr,                " Item number of the SD document
         parvw TYPE parvw,                "Line item Number
         kunnr TYPE kunnr,                "Customer Number
         adrnr TYPE adrnr,                "Address
       END OF ty_vbpa,

       BEGIN OF ty_veda,
         vbeln   TYPE vbeln,              " Sales and Distribution Document Number
         vposn   TYPE posnr,              " Item number of the SD document
         vbegdat TYPE vbdat_veda,         " Contract start date
         venddat TYPE vbdat_veda,         " Contract start date
       END OF ty_veda,

       BEGIN OF ty_vbkd,
         vbeln TYPE vbeln,                " Sales and Distribution Document Number
         posnr TYPE posnr,                " Item number of the SD document
         bstkd TYPE bstkd,                " Customer purchase order number
         ihrez TYPE ihrez,                " Your Reference
       END OF ty_vbkd,

       BEGIN OF ty_vapma,
         matnr TYPE matnr,                " Material Number
         kunnr TYPE kunnr,                " Cross-Plant Material Status
         vbeln TYPE vbeln,                " Title
         posnr TYPE posnr,                " Title
       END OF ty_vapma,

       BEGIN OF ty_mara,
         matnr    TYPE matnr,             " Material Number
         mstae    TYPE mstae,             " Cross-Plant Material Status
         ismtitle TYPE ismtitle,          " Title
       END OF ty_mara,

       BEGIN OF ty_jptidcassign,
         matnr      TYPE matnr,           " Material Number
         identcode  TYPE ismidentcode,    " Identification Code
         idcodetype TYPE ismidcodetype,   " Type of Identification Code
       END OF ty_jptidcassign,

       BEGIN OF ty_const,
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno   TYPE tvarv_numb,          " ABAP: Current selection number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_const,

*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*

       tt_vbpa          TYPE STANDARD TABLE OF ty_vbpa           INITIAL SIZE 0,
       tt_veda          TYPE STANDARD TABLE OF ty_veda           INITIAL SIZE 0,
       tt_vapma         TYPE STANDARD TABLE OF ty_vapma          INITIAL SIZE 0,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcassign   INITIAL SIZE 0,
       tt_const         TYPE STANDARD TABLE OF ty_const          INITIAL SIZE 0,
       tt_vbkd          TYPE STANDARD TABLE OF ty_vbkd           INITIAL SIZE 0,
       tt_mara          TYPE STANDARD TABLE OF ty_mara           INITIAL SIZE 0,
       tt_final         TYPE STANDARD TABLE OF ty_final          INITIAL SIZE 0.

*&---------------------------------------------------------------------*
*& I N T E R N A L    T A B L E S
*&---------------------------------------------------------------------*

DATA: i_vbkd            TYPE STANDARD TABLE OF ty_vbkd           INITIAL SIZE 0,
      i_vbpa            TYPE STANDARD TABLE OF ty_vbpa           INITIAL SIZE 0,
      i_vapma           TYPE STANDARD TABLE OF ty_vapma          INITIAL SIZE 0,
      i_mara            TYPE STANDARD TABLE OF ty_mara           INITIAL SIZE 0,
      i_jptidcdassign   TYPE STANDARD TABLE OF ty_jptidcassign   INITIAL SIZE 0,
      i_zcaconstant     TYPE STANDARD TABLE OF ty_const          INITIAL SIZE 0,
      i_final           TYPE STANDARD TABLE OF ty_final          INITIAL SIZE 0,
      i_printform_table TYPE STANDARD TABLE OF  szadr_printform_table_line INITIAL SIZE 0.
*&--------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*& V A R I A B L E
*&--------------------------------------------------------------------*

DATA :          v_filepath  TYPE string,
                v_filenm    TYPE string,    " Filenm of type CHAR13
                v_kunnr     TYPE kunnr,     " Customer Number
                v_localfile TYPE localfile, " Local file for upload/download
                v_path      TYPE string.    " local variable to hold path "CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore TYPE char1      VALUE '_',    " Underscore of type CHAR1
           c_extn       TYPE char4      VALUE '.TXT', " Extn of type CHAR4
           c_devid      TYPE zdevid     VALUE 'I0352',  " Development ID
           c_parvw_sp   TYPE parvw      VALUE 'WE',     " Partner Function
           c_e          TYPE char1      VALUE 'E',      " E of type CHAR1
           c_s          TYPE char1      VALUE 'S',      " S of type CHAR1
           c_x          TYPE char1      VALUE 'X',      " X of type CHAR1
           c_posnr_hdr  TYPE posnr_va   VALUE '000000', " Item Number for Header
           c_1          TYPE char1      VALUE '1',      " 1 of type CHAR1
           c_2          TYPE char1      VALUE '2'.      " 2 of type CHAR1
