*&----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_SALES_REP_UPDATE
*& PROGRAM DESCRIPTION:   Program to update original sales order
*&
*& DEVELOPER:             LRRAMIREDD
*& CREATION DATE:         03/07/2019
*& OBJECT ID:             DM-1787
*& TRANSPORT NUMBER(S):   ED2K914627,ED2K914867
*&----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E199_SALES_REP_UPD_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  S T R U C T U R E S
*&---------------------------------------------------------------------*
TABLES:vbak.
TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbeln_va,             " Sales Document
          erdat TYPE erdat,                " DAte on which record was created
          auart TYPE auart,                " Sales doc tye
          vkorg TYPE vkorg,                " Sales Organization
          kunnr TYPE kunag,                "Sold to party
        END OF ty_vbak,

        BEGIN OF ty_vbap,
          vbeln TYPE vbeln_va,             "Sales Document
          posnr TYPE posnr_va,             "Sales Document Item
          matnr TYPE matnr,                "Material number
        END OF ty_vbap,

        BEGIN OF ty_vbpa,
          vbeln TYPE vbeln,                " Sales and Distribution Document Number
          posnr TYPE posnr,                " Item number of the SD document
          parvw TYPE parvw,                " Partner Function
          pernr TYPE pernr_d,              " Personnel Number
          adrnr	TYPE adrnr,
        END OF ty_vbpa,

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
        BEGIN OF ty_stat,
          auart TYPE auart,
        END OF ty_stat,
        BEGIN OF ty_final,
          sel     TYPE char1,
          vbeln   TYPE vbeln_va,           " Sales Document
          auart   TYPE auart,              "Document tyope
          posnr   TYPE posnr_va,            " Item number of the SD document
          matnr   TYPE matnr,              " Material Number
          srep1   TYPE pernr_d,            " Standard Selections for HR Master Data Reporting
          sname1  TYPE string,
          srep2   TYPE pernr_d,            " Standard Selections for HR Master Data Reporting
          sname2  TYPE string,
          nsrep1  TYPE zz_persno,          " Standard Selections for HR Master Data Reporting
          nsname1 TYPE string,
          nsrep2  TYPE zz_persno,          " Standard Selections for HR Master Data Reporting
          nsname2 TYPE string,
          flag    TYPE char1,                  "Header flag
          jobname TYPE char70,             " Jobname of type CHAR70
        END OF ty_final,
        BEGIN OF ty_detail,
          vbeln TYPE vbeln_va,           " Sales Document
          erdat TYPE erdat,                " DAte on which record was created
          auart TYPE auart,                " Sales doc tye
          vkorg TYPE vkorg,                " Sales Organization
          kunnr TYPE kunag,
          matnr TYPE matnr,              " Material Number
          posnr TYPE posnr_va,            " Item number of the SD document
          parvw TYPE parvw,                " Partner Function
          pernr TYPE pernr_d,              " Personnel Number
        END OF ty_detail,
        BEGIN OF ty_pa002,
          pernr TYPE pernr_d,           "Personnel Number
          nachn TYPE pad_nachn,         "Last Name
          vorna TYPE pad_vorna,         "First Name
        END OF ty_pa002,


*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
* Declaration of Range
        tt_range_r TYPE RANGE OF char35,   " Range_r type range of type CHAR30
        tt_parvw_r TYPE RANGE OF parvw,     " Partner Function
        tt_pernr_r TYPE RANGE OF zz_persno. " Personnel Number


*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA : i_constant   TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
       i_vbak       TYPE STANDARD TABLE OF ty_vbak     INITIAL SIZE 0,
       i_vbap       TYPE STANDARD TABLE OF ty_vbap     INITIAL SIZE 0,
       i_vbpa       TYPE STANDARD TABLE OF ty_vbpa     INITIAL SIZE 0,
       i_fcat       TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
       i_process    TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0,
       i_pa002      TYPE STANDARD TABLE OF ty_pa002    INITIAL SIZE 0,
       i_pa002_temp TYPE STANDARD TABLE OF ty_pa002    INITIAL SIZE 0,
       i_final      TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0,
       i_detail     TYPE STANDARD TABLE OF ty_detail    INITIAL SIZE 0,
       i_selines    TYPE STANDARD TABLE OF ty_final    INITIAL SIZE 0,
       i_det        TYPE STANDARD TABLE OF ty_stat      INITIAL SIZE 0.
*&--------------------------------------------------------------------*
*& V A R I A B L E
*&-------------------------------------------------------------------
DATA :      v_vkorg TYPE vkorg ,      " Sales Organization
            v_kunnr TYPE kunnr,       " Customer Number
            v_auart TYPE tvak-auart,  " Sales Document Type
            v_erdat TYPE erdat.       "Creation date

*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS : c_i        TYPE tvarv_sign  VALUE 'I',       " I of type CHAR1
            c_eq       TYPE tvarv_opti  VALUE 'EQ',      " Eq of type CHAR2
            c_true     TYPE sap_bool    VALUE 'X',
            c_parvw_ve TYPE parvw       VALUE 'VE',      " Partner Function
            c_parvw_ze TYPE parvw       VALUE 'ZE',      " Partner Function
            c_parvw_ag TYPE parvw       VALUE 'AG',      " Partner Function
            c_devid    TYPE zdevid      VALUE 'E199',  " Development ID
            c_doc      TYPE rvari_vnam  VALUE 'DOC_TYP',  " Document type
            c_auart    TYPE fieldname   VALUE 'AUART',  " Document type
            c_auart1   TYPE dynfnam     VALUE 'S_AUART',  " Document type
            c_s        TYPE ddbool_d    VALUE 'S',  " Document type
            c_uepos    TYPE uepos       VALUE '000000'. "Higher-level item
