*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_INVENT_RECON_SOH_TOP
* PROGRAM DESCRIPTION: Inventory Reconcilliation top include
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-03
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_SOH_TOP
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_stock,
*         blank TYPE string,
*         plant TYPE werks_d,
*         matnr TYPE matnr,
*         fdate TYPE string,
*         tdate TYPE string,
*         obal  TYPE string,
*         rcpt  TYPE string,
*         issu  TYPE string,
*         cbal  TYPE string,
*         unit  TYPE string,
*       END OF ty_stock,
*
*       BEGIN OF ty_mat_det,
*         matnr TYPE matnr,
*         meins TYPE meins,
*         werks TYPE ewerk,
*         vdatu TYPE ordab,
*         bdatu TYPE ordbi,
*         lifnr TYPE elifn,
*         flifn TYPE flifn,
*         ebeln TYPE ebeln,
*         knttp TYPE knttp,
*         bwkey TYPE bwkey,
*       END OF ty_mat_det,
*
*       BEGIN OF ty_output,
*         status       TYPE char1,
*         number       TYPE edi_stamno, "number
*         id           TYPE edi_stamid, "id
*         idoc_number  TYPE edi_docnum, "Idoc Number
*         zadjtyp      TYPE zadjtyp,
*         matnr        TYPE matnr,
*         plant        TYPE ewerks,
*         po_number    TYPE ebeln,
*         item_no      TYPE ebelp,
*         material_doc TYPE mblnr,
*         source_file  TYPE char50,
*         message      TYPE bapi_msg, "message
*       END OF ty_output,
*
*       tt_mat_det     TYPE STANDARD TABLE OF ty_mat_det INITIAL SIZE 0,
*       tt_stock       TYPE STANDARD TABLE OF ty_stock INITIAL SIZE 0,
*       tt_edidd       TYPE STANDARD TABLE OF edidd INITIAL SIZE 0,
*       tt_output      TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0,
*       tt_inven_recon TYPE STANDARD TABLE OF zqtc_inven_recon INITIAL SIZE 0.
*
**Internal table declaration
*DATA: i_output      TYPE tt_output,
*      i_stock       TYPE tt_stock,
*      i_mat_detail  TYPE tt_mat_det,
*      i_inven       TYPE tt_inven_recon,
*      i_recon_table TYPE tt_inven_recon,
*      i_inven_recon TYPE tt_inven_recon,
*      i_inven_whstk TYPE tt_inven_recon.
*
**Constant Declaration
*CONSTANTS: c_kind            TYPE rsscr_kind VALUE 'S',
*           c_sign            TYPE ddsign VALUE 'I',
*           c_option          TYPE ddoption VALUE 'EQ',
*           c_adjtyp          TYPE zadjtyp VALUE 'WHSTK',
*           c_selname_datum   TYPE rsscr_name VALUE 'DATUM',
*           c_selname_matnr   TYPE rsscr_name VALUE 'MATNR',
*           c_error           TYPE char1 VALUE 'E',
*           c_success         TYPE char1 VALUE 'S',
*           c_bsart           TYPE bsart VALUE 'ZNB',
*           c_ekorg           TYPE ekorg VALUE 'JWPO',
*           c_ekgrp           TYPE ekgrp VALUE 'PJ1',
*           c_knttp           TYPE knttp VALUE 'P',
*           c_lgort           TYPE lgort_d VALUE 'J001',
*           c_bwart           TYPE bwart VALUE '101',
*           c_mvt_ind         TYPE char1 VALUE 'B',
*           c_status_suc      TYPE char1 VALUE '3',   "Status: Green/Success
*           c_status_err      TYPE char1 VALUE '1',   "Status: Red/Error
*           c_adjustment_type TYPE zadjtyp VALUE 'SOH'.
* Global Type Declaration
TYPE-POOLS: slis.

TYPES :

  BEGIN OF ty_alv,
    light   TYPE char4,      " Light of type CHAR4
    msg_id  TYPE symsgid,    " Message Class
    msg_no  TYPE symsgno,    " Message Number
    idoc_no	TYPE edi_docnum, " Reference Document Number
    zadjtyp TYPE zadjtyp,    " Adjustment Type
    matnr	  TYPE matnr,      " Material Number
    werks	  TYPE dwerk_ext,  " Delivering Plant (Own or External)
    ebeln   TYPE ebeln,      " Purchasing Document Number
    ebelp   TYPE ebelp,      " Item Number of Purchasing Document
    mblnr  	TYPE mblnr,      " Number of Material Document
    zsource	TYPE ztsource,
    message TYPE bapi_msg,   " Message Text
  END OF ty_alv,
* Global Table type declaration
  tt_alv         TYPE STANDARD TABLE OF ty_alv,
  tt_inven_recon TYPE STANDARD TABLE OF zqtc_inven_recon,     " Table for Inventory Reconciliation Data
  tt_edidd       TYPE STANDARD TABLE OF edidd INITIAL SIZE 0. " Data record (IDoc)

* Global Internal Table Declaration
DATA : i_inven_recon     TYPE tt_inven_recon,
       i_inven_recon_all TYPE tt_inven_recon,
       i_alv             TYPE tt_alv,
       i_fcat            TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0.

* Constant Declaration
CONSTANTS : c_inven_recon TYPE tabname VALUE 'ZQTC_INVEN_RECON', " Table Name
            c_bednr_whstk TYPE rvari_vnam VALUE 'WHSTK'.

* Global Varible
DATA : v_lock TYPE flag. " General Flag
