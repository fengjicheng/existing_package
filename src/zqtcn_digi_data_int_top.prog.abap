*&---------------------------------------------------------------------*
*&  Include           ZQTC_DIGI_DATA_INT_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_DF_DIGITAL_ENT_DATA_INT
* PROGRAM DESCRIPTION: Report to upload a text file onto application
*                      layer for Digital Entitlement Data Interface
*                      sent to TIBCO                                   *
* DEVELOPER:          APATNAIK(Alankruta Patnaik)
* CREATION DATE:      12/27/2016
* OBJECT ID:          I0342
* TRANSPORT NUMBER(S):ED2K903899
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K906458
* REFERENCE NO:  ERP-2509
* DEVELOPER:     Pavan Bandlapalli(PBANDLAPAL)
* DATE:          01-Jun-2017
* DESCRIPTION: To change the Initial Shipping Date(isminitshipdate) to
* publication date(ismpubldate) and Item number in the output should be
* just an incremental number.
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S                                                *
*&---------------------------------------------------------------------*


TYPES: BEGIN OF ty_final,
         idnumber     TYPE bu_id_number,  " Identification Number
         name1        TYPE bu_name1tx,    " Name 1
         street       TYPE ad_street,     " Street
         city1        TYPE ad_city1,      " City
         region       TYPE regio,         " Region (State, Province, County)
         post_code1   TYPE ad_pstcd1,     " City postal code
         cntct_p_name TYPE bu_name1tx,    " Full Name
         smtp_addr    TYPE ad_smtpadr,    " E-Mail Address
         vbeln        TYPE vbeln_vf,      " Billing Document
         fkdat        TYPE fkdat,         " Billing date for billing index and printout
         bstkd        TYPE bstkd,         " Customer purchase order number
         audat        TYPE audat,         " Document Date (Date Received/Sent)
         posnr        TYPE posnr_va,      " Sales Document Item
         vbau         TYPE string,        " Sales Document and Date
         identcode    TYPE ismidentcode,  " Identification Code
         matnr        TYPE matnr,         " Old material number
         ismtitle     TYPE ismtitle,      " Title
         ismsubtitle1 TYPE  ismsubtitle1, " Subtitle 1
         ismpubldate  TYPE  ismpubldate,  " Publication Date
       END OF ty_final,


       BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_vf,             "Billing Document
         fkart TYPE fkart,                "Billing Type
         fkdat TYPE fkdat,                "Billing Date
         netwr TYPE netwr,                "Net Value
       END OF ty_vbrk,


       BEGIN OF ty_but0id,
         partner  TYPE   bu_partner,      " Business Partner Number
         type     TYPE bu_id_type,        "Identification type
         idnumber TYPE bu_id_number,      "Identification Number
       END OF ty_but0id,

       BEGIN OF ty_but050,
         relnr      TYPE bu_relnr,        "BP Relationship Number
         partner1   TYPE bu_partner,      "Business Partner Number
         partner2   TYPE bu_partner,      "Business Partner Number
         name1_text TYPE bu_name1tx,      "Full Name
       END OF ty_but050,

       BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va,             "Sales Document Number
         audat TYPE audat,                "Sales Document Date
         kunnr TYPE kunag,                "Sold-to party
       END OF ty_vbak,

       BEGIN OF ty_vbpa,
         vbeln TYPE vbeln,                "Sales Document Number
         posnr TYPE posnr,                " Item number of the SD document
         parvw TYPE parvw,                "Line item Number
         kunnr TYPE kunnr,                "Customer Number
         adrnr TYPE  adrnr,               "Address
       END OF ty_vbpa,

       BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum,      "Adress
         name1      TYPE ad_name1,        "Name
         name2      TYPE ad_name2,        "Name 2
         city1      TYPE ad_city1,        "City
         postcode   TYPE ad_pstcd1,       "Postal Code
         street     TYPE ad_street,       " Street
         region     TYPE regio,           " Region (State, Province, County)
       END OF ty_adrc,

       BEGIN OF ty_vbfa,
         vbelv   TYPE  vbeln_von,         " Preceding sales and distribution document
         posnv   TYPE posnr_von,          " Preceding item of an SD document
         vbeln   TYPE vbeln_nach,         " Subsequent sales and distribution document
         posnn   TYPE posnr_nach,         " Subsequent item of an SD document
         vbtyp_n TYPE vbtyp_n,            " Document category of subsequent document
         vbtyp_v TYPE  vbtyp_v,           " Document category of preceding SD document
       END OF ty_vbfa,

       BEGIN OF ty_vbap,
         vbeln TYPE vbeln_va,             " Sales Document
         posnr TYPE posnr_va,             " Sales Document Item
         matnr TYPE matnr,                " Material Number
       END OF ty_vbap,

       BEGIN OF ty_adr6,
         addrnumber TYPE  ad_addrnum,     " Address number
         smtp_addr  TYPE  ad_smtpadr,     " E-Mail Address
       END OF ty_adr6,

       BEGIN OF ty_vbkd,
         vbeln TYPE  vbeln,               " Sales and Distribution Document Number
         bstkd TYPE bstkd,                " Customer purchase order number
       END OF ty_vbkd,

       BEGIN OF ty_mara,
         matnr        TYPE  matnr,        " Material Number
         bismt        TYPE  bismt,        " Old material number
         ismtitle     TYPE ismtitle,      " Title
         ismsubtitle1 TYPE ismsubtitle1, " Subtitle 1
* Begin of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
*         initshipdate TYPE ismerstverdat,   " Initial Shipping Date
         ismpubldate  TYPE ismpubldate,      " Publication Date
* End of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
         ismoridcode  TYPE ismoridcode,   "Identification Code
       END OF ty_mara,


       BEGIN OF ty_jptidcassign,
         matnr      TYPE matnr,           " Material Number
         idcodetype TYPE ismidcodetype,   " Type of Identification Code
         identcode  TYPE ismidentcode,    " Identification Code
       END OF ty_jptidcassign,

*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*

       tt_vbap          TYPE STANDARD TABLE OF ty_vbap           INITIAL SIZE 0,
       tt_vbpa          TYPE STANDARD TABLE OF ty_vbpa           INITIAL SIZE 0,
       tt_vbfa          TYPE STANDARD TABLE OF ty_vbfa           INITIAL SIZE 0,
       tt_adrc          TYPE STANDARD TABLE OF ty_adrc           INITIAL SIZE 0,
       tt_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcassign   INITIAL SIZE 0,
       tt_vbrk          TYPE STANDARD TABLE OF ty_vbrk           INITIAL SIZE 0,
       tt_vbak          TYPE STANDARD TABLE OF ty_vbak           INITIAL SIZE 0,
       tt_vbkd          TYPE STANDARD TABLE OF ty_vbkd           INITIAL SIZE 0,
       tt_but0id        TYPE STANDARD TABLE OF ty_but0id         INITIAL SIZE 0,
       tt_but050        TYPE STANDARD TABLE OF ty_but050         INITIAL SIZE 0,
       tt_adr6          TYPE STANDARD TABLE OF ty_adr6           INITIAL SIZE 0,
       tt_mara          TYPE STANDARD TABLE OF ty_mara           INITIAL SIZE 0,
       tt_final         TYPE STANDARD TABLE OF ty_final          INITIAL SIZE 0.

*&---------------------------------------------------------------------*
*& I N T E R N A L    T A B L E S
*&---------------------------------------------------------------------*

DATA: i_vbrk          TYPE STANDARD TABLE OF ty_vbrk         INITIAL SIZE 0,
      i_vbak          TYPE STANDARD TABLE OF ty_vbak         INITIAL SIZE 0,
      i_vbkd          TYPE STANDARD TABLE OF ty_vbkd         INITIAL SIZE 0,
      i_but0id        TYPE STANDARD TABLE OF ty_but0id       INITIAL SIZE 0,
      i_but050        TYPE STANDARD TABLE OF ty_but050       INITIAL SIZE 0,
      i_vbpa          TYPE STANDARD TABLE OF ty_vbpa         INITIAL SIZE 0,
      i_vbfa          TYPE STANDARD TABLE OF ty_vbfa         INITIAL SIZE 0,
      i_vbap          TYPE STANDARD TABLE OF ty_vbap         INITIAL SIZE 0,
      i_adrc          TYPE STANDARD TABLE OF ty_adrc         INITIAL SIZE 0,
      i_adr6          TYPE STANDARD TABLE OF ty_adr6         INITIAL SIZE 0,
      i_mara          TYPE STANDARD TABLE OF ty_mara         INITIAL SIZE 0,
      i_jptidcdassign TYPE STANDARD TABLE OF ty_jptidcassign INITIAL SIZE 0,
      i_final         TYPE STANDARD TABLE OF ty_final        INITIAL SIZE 0.
*&--------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*& V A R I A B L E
*&--------------------------------------------------------------------*

DATA :          v_vbeln     TYPE vbuk-vbeln, " Billing Document
                v_fkdat     TYPE fkdat,    " Billing date for billing index and printout
                v_fkart     TYPE tvfk-fkart,    " Billing Type
                v_filepath  TYPE string,
                v_filenm    TYPE string,   " Filenm of type CHAR13
                v_kunnr     TYPE kunnr,    " Customer Number
                v_matnr     TYPE matnr,    " Material Number
                v_localfile TYPE localfile. " Local file for upload/download

*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore TYPE char1      VALUE '_',    " Underscore of type CHAR1
           c_extn       TYPE char4      VALUE '.TXT', " Extn of type CHAR4
           c_devid      TYPE zdevid     VALUE 'I0342', " Development ID
           c_vbtyp_c    TYPE vbtyp_v    VALUE 'C',     " Document category of preceding SD document
           c_vbtyp_g    TYPE vbtyp_v    VALUE 'G',     " Document category of preceding SD document
           c_parvw_sh   TYPE parvw      VALUE 'WE',    " Partner Function
           c_type       TYPE bu_id_type VALUE 'ZOCLC',
           c_reltyp_cnt TYPE bu_reltyp  VALUE 'BUR001', " Relationship Type: Contact
           c_e          TYPE char1      VALUE 'E',     " E of type CHAR1
           c_s          TYPE char1      VALUE 'S',     " S of type CHAR1
           c_posnr_hdr  TYPE posnr_va   VALUE '000000', " Item Number for Header
           c_oclc       TYPE char4      VALUE 'OCLC',  " Oclc of type CHAR4
           c_wisp       TYPE char4      VALUE 'WISP'.  " Wisp of type CHAR4
