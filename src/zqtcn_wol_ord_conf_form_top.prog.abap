*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WOL_ORD_CONF_FORM_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WOL_ORD_CONF_FORM_TOP
* PROGRAM DESCRIPTION: This driver program is implemented for WOL
*                      Order Confirmation Email Form
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 17/03/2020
* OBJECT ID: F059
* TRANSPORT NUMBER(S): ED2K917812
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <........>
* REFERENCE NO: <........>
* DEVELOPER: <........>
* DATE: <........>
* DESCRIPTION: <........>
*----------------------------------------------------------------------*

TABLES: tnapr,    " Processing programs for output
        nast,     " Message Status
        toa_dara. " SAP ArchiveLink structure of a DARA line

* Global Types
TYPES:
  " Constant entries
  BEGIN OF ty_constant,
    devid  TYPE  zdevid,                      " Development Id
    param1 TYPE  rvari_vnam,                  " Parameter-1
    param2 TYPE  rvari_vnam,                  " Parameter-2
    srno   TYPE  tvarv_numb,                  " Serial number
    sign   TYPE  tvarv_sign,                  " Sign
    opti   TYPE  tvarv_opti,                  " Option
    low    TYPE  salv_de_selopt_low,          " Low
    high   TYPE  salv_de_selopt_high,         " High
  END OF ty_constant,
  tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,  " Table Type: tt_constant
  " Sales Document Item details
  BEGIN OF ty_vbap,
    vbeln TYPE vbeln_va,          " Sales Document
    posnr TYPE posnr_va,          " Sales Document Item
    matnr TYPE matnr,             " Material Number
    zmeng TYPE dzmeng,            " Target quantity
    netwr TYPE netwr_ap,          " Net value of the order item
    kzwi5 TYPE kzwi5,             " Discount
    kzwi6 TYPE kzwi6,             " Tax
  END OF ty_vbap,
  " ISBN Number
  BEGIN OF ty_identcode,
    matnr     TYPE matnr,         " Material Number
    identcode TYPE ismidentcode,  " Identification Code
  END OF ty_identcode,
  " Material Description
  BEGIN OF ty_makt,
    matnr    TYPE matnr,         " Material Number
    ismtitle TYPE ismtitle,      " Title
  END OF ty_makt,
  " Partner Functions
  BEGIN OF ty_vbpa,
    parvw TYPE parvw,         " Partner Function
    kunnr TYPE kunnr,         " Customer Number
    adrnr TYPE adrnr,         " Address Number
  END OF ty_vbpa,
  " Billing Address
  BEGIN OF ty_bill_adrc,
    name1 TYPE name1_gp,      " Name 1
    stras TYPE stras_gp,      " House number and street
    ort01 TYPE ort01_gp,      " City
    pstlz TYPE pstlz,         " Postal Code
    land1 TYPE landx,         " Country
  END OF ty_bill_adrc.

* Global Data declaration
DATA: i_constants    TYPE tt_constant,                  " Itab: Constant
      i_content_hex  TYPE solix_tab,                    " Content table
      i_vbpa         TYPE STANDARD TABLE OF ty_vbpa,    " Itab: Sales Document Item details
      i_item_data    TYPE STANDARD TABLE OF ty_vbap,    " Item Details
      st_wol_ord_inf TYPE zstqtc_wol_ord_conf_inf_f059, " Interface structure
      st_formoutput  TYPE fpformoutput,                 " Form Output (PDF, PDL)
      v_xstr_logo    TYPE xstring,                      " Logo Variable
      v_formname     TYPE fpname,                       " Formname
      v_ent_retco    TYPE sy-subrc,                     " ABAP System Field: Return Code of ABAP Statements
      v_ent_screen   TYPE char1,                        " Screen of type Character
      v_send_email   TYPE ad_smtpadr,                   " E-Mail Address
      v_persn_adrnr  TYPE knvk-prsnr.                   " E-Mail Address

" Global Constants
CONSTANTS:
  c_ag             TYPE parvw      VALUE 'AG',                            " Partner Function: Sold-to-party
  c_re             TYPE parvw      VALUE 'RE',                            " Partner Function: Bill-to-party
  c_z1             TYPE pafkt      VALUE 'Z1',                            " Contact person function knvk-pafkt
  c_e              TYPE char1      VALUE 'E',                             " Error Message
  c_msg_no         TYPE syst_msgno VALUE '000',                           " Message Number  syst-msgno
  c_devid_f059     TYPE zdevid     VALUE 'F059',                          " Developement Id
  c_zqtc_r2        TYPE syst_msgid VALUE 'ZQTC_R2',                       " Message ID  syst-msgid
  c_pdf            TYPE saedoktyp  VALUE 'PDF',                           " for PDF   toadv-doc_type
  c_1              TYPE na_nacha VALUE '1',                               " Print Function
  c_5              TYPE na_nacha VALUE '5',                               " Email Function
  c_x              TYPE char1    VALUE 'X',                               " for x
  c_w              TYPE char1    VALUE 'W',                               " for Web
  c_zwol_form_name TYPE fpname   VALUE 'ZQTC_FRM_WOL_ORD_CONF_F059',      " WOL Form
  c_comma          TYPE char1    VALUE ',',                               " Comma
  c_hdr_posnr      TYPE posnr    VALUE '000000'.                          " Header position
