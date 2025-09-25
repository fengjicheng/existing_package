*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_PRICE_LIST_R108_TOP (Include)
* PROGRAM DESCRIPTION: This program implemented for to display the
*                      Price List Report
* DEVELOPER:           Siva Guda (SGUDA)
* CREATION DATE:       05/27/2020
* OBJECT ID:           ERPM-6946/R108
* TRANSPORT NUMBER(S): :ED2K918317
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description: .
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZQTCR_PRICE_LIST_R108_TOP
*&---------------------------------------------------------------------*
TABLES: konh,a927,konp,mara,tvak.
*- For Final internal table structure
TYPES : BEGIN OF ty_final,
          kschl       TYPE konh-kschl,        "Consition Type
          kotabnr     TYPE konh-kotabnr,      "Condition table
          kunwe       TYPE a927-kunwe,        "Ship-to
          ship_name   TYPE kna1-name1,        "Ship-to Name
          kunnr       TYPE kna1-kunnr,        "Sold-to
          sold_name   TYPE kna1-name1,        "Sold-to Name
          matnr       TYPE a927-matnr,        "Material Number
          maktx       TYPE makt-maktx,        "Journal Title
          kbetr       TYPE konp-kbetr,        "Amount
          konwa       TYPE konp-konwa,        "Currency
          datab       TYPE a927-datab,        "Valid From
          datbi       TYPE a927-datbi,        "Valid To
          erdat       TYPE konh-erdat,        "Created On
          ernam       TYPE konh-ernam,        "Created by
          extwg       TYPE mara-extwg,        "External Material Group
          ismpubltype TYPE mara-ismpubltype,  "Publication Type
          vbeln       TYPE vbak-vbeln,        "Contract Number
          audat       TYPE vbak-audat,        "Document Date
          auart       TYPE vbak-auart,        "Contract Type
          bezei       TYPE tvakt-bezei,        "Contract Type Desc
          vkorg       TYPE vbak-vkorg,        "Sales Org
          vtext       TYPE tvkot-vtext,       "Sales Org Desc
          netwr       TYPE vbak-netwr,        "Header Net Total
          mwsbp       TYPE vbap-mwsbp,        "Header Tax Total
          bstkd       TYPE vbkd-bstkd,        "Customer purchase order number
          ihrez       TYPE vbkd-ihrez,        "Sold-to Your Reference
          bstkd_e     TYPE vbkd-bstkd_e,      "Ship-to PO Number
          ihrez_e     TYPE vbkd-ihrez_e,      "Ship-to Your Reference
          katr8       TYPE kna1-katr8,        "Attribute 8
        END OF ty_final,
*- For Sales Data
        BEGIN OF ty_vbkd,
          vbeln   TYPE vbak-vbeln,            "Sales Document
          posnr   TYPE vbap-posnr,
          bstkd   TYPE vbkd-bstkd,            "Customer purchase order number
          ihrez   TYPE vbkd-ihrez,            "Your Reference
          bstkd_e TYPE vbkd-bstkd_e,          "Ship-to Party's Purchase Order Number
          ihrez_e TYPE vbkd-ihrez_e,          "Ship-to party character
        END OF ty_vbkd,
*- For Partners data
        BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,              "Sales Document
          posnr TYPE vbpa-posnr,              "Sales Document Item
          parvw TYPE vbpa-parvw,              "Partner Function
          kunnr TYPE vbpa-kunnr,              "Customer Number
          audat TYPE vbak-audat,
          vbtyp TYPE vbak-vbtyp,
          auart TYPE vbak-auart,
          netwr TYPE vbak-netwr,
          vkorg TYPE vbak-vkorg,
        END OF ty_vbpa,
*- For Customer Name and Attribute 8
        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,              "Customer Number
          name1 TYPE kna1-name1,              "Name 1
          katr8 TYPE kna1-katr8,              "Attribute 8
        END OF ty_kna1,
*- For Sales Document type description
        BEGIN OF ty_tvakt,
          spras TYPE tvakt-spras,             "Language Key
          auart TYPE tvakt-auart,             "Sales Document Type
          bezei TYPE tvakt-bezei,             "Description
        END OF ty_tvakt,
*- For Sales Organization name
        BEGIN OF ty_tvkot,
          spras TYPE tvkot-spras,             "Language Key
          vkorg TYPE tvkot-vkorg,             "Sales Organization
          vtext TYPE tvkot-vtext,             "Name
        END OF ty_tvkot,
        BEGIN OF ty_price_data,
          kschl       TYPE konh-kschl,
          kotabnr     TYPE konh-kotabnr,
          erdat       TYPE  konh-erdat,
          ernam       TYPE  konh-ernam,
          konwa       TYPE  konp-konwa,
          kbetr       TYPE  konp-kbetr,
          knumh       TYPE  konp-knumh,
          kunwe       TYPE  a927-kunwe,
          matnr       TYPE  a927-matnr,
          datab       TYPE  a927-datab,
          datbi       TYPE  a927-datbi,
          kappl       TYPE  a927-kappl,
          extwg       TYPE  mara-extwg,
          ismpubltype TYPE  mara-ismpubltype,
          maktx       TYPE  makt-maktx,
        END OF ty_price_data,
        BEGIN OF ty_vbap,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
          mwsbp TYPE vbap-mwsbp,
        END OF ty_vbap,
        BEGIN OF ty_ship_mat,
          vbeln   TYPE vbpa-vbeln,
          posnr   TYPE vbap-posnr,
          matnr   TYPE vbap-matnr,
          kunnr   TYPE vbpa-kunnr,
          vbegdat TYPE veda-vbegdat,          "Contract start date
        END OF ty_ship_mat,
        BEGIN OF ty_veda,
          vbeln   TYPE veda-vbeln,
          vposn   TYPE veda-vposn,
          vbegdat TYPE veda-vbegdat,
        END OF ty_veda.

DATA :
*-    Interanl Tables
  gi_final_out   TYPE TABLE OF ty_final,      "Final Internal Table
  gi_vbkd        TYPE TABLE OF ty_vbkd, "Sales Data
  gi_vbpa        TYPE TABLE OF ty_vbpa,       "Partners Data
  gi_vbpa_tmp    TYPE TABLE OF ty_vbpa,       "Partners Data
  gi_kna1        TYPE TABLE OF ty_kna1,       "Customer Name
  gi_tvakt       TYPE TABLE OF ty_tvakt,      "Sales Document type description
  gi_tvkot       TYPE TABLE OF ty_tvkot,      "Sales Organization
  gi_price_data  TYPE TABLE OF ty_price_data, "Price Data
  gi_ship_mat    TYPE TABLE OF ty_ship_mat,   "Ship-to and Material
  gi_vbap        TYPE TABLE OF ty_vbap,       "Partners and Sales item data
  gi_veda        TYPE TABLE OF ty_veda,       " Contract Dates
  gi_fcat_out    TYPE slis_t_fieldcat_alv,    "ALVFieldcat

*-    Work Areas
  gst_final_out  TYPE ty_final,               "Final Work Area
  gst_vbkd       TYPE ty_vbkd,          "Sales Data
  gst_price_data TYPE  ty_price_data,         "Price Data
  gst_vbpa       TYPE ty_vbpa,                "Partners Data
  gst_vbpa_tmp   TYPE ty_vbpa,                "Partners Data
  gst_kna1       TYPE ty_kna1,                "Customer Name
  gst_tvakt      TYPE ty_tvakt,               "Sales Document type description
  gst_tvkot      TYPE ty_tvkot,               "Sales Organization
  gst_vbap       TYPE ty_vbap,                "Partners and Sales item data
  gst_ship_mat   TYPE ty_ship_mat,            "Ship-to and Material
  gst_veda       TYPE ty_veda,                "Contract Dates
  gst_fcat_out   TYPE slis_fieldcat_alv.      "ALV specific tables and structures
*-    Global Varibles

CONSTANTS:
  lc_pf_status     TYPE slis_formname  VALUE 'F_SET_PF_STATUS',  "PF Status
  lc_user_comm     TYPE slis_formname  VALUE 'F_USER_COMMAND',   "User Command
  lc_top_of_page   TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',    "Top of Page
  lc_sold_to       TYPE vbpa-parvw     VALUE 'AG',               "Sold-to
  lc_ship_to       TYPE vbpa-parvw     VALUE 'WE',               "Ship-to
  lc_document_catg TYPE vbak-vbtyp     VALUE 'G',                "Document Catg
  lc_typ_h         TYPE char1          VALUE 'H',                "Header
  lc_typ_s         TYPE char1          VALUE 'S',                "Selection
  lc_fla_x         TYPE char1          VALUE 'X',                "Fag x
  lc_vposn         TYPE veda-vposn     VALUE '000000',
  lv_right         TYPE char1          VALUE 'R'.                "Right Justified
