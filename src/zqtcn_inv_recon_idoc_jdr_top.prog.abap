*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_INVENT_RECON_JDR_TOP
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* Declaring all the Global Varible in this include .
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
* Revision No: ED2K910553
* Reference No: ERP-6110
* Developer: Pavan Bandlapalli(PBANDLAPAL)
* Date:  2018-01-30
* Description: 1. Added Account Assignment (p_acctas) and Item category
*              (p_itmcat) fields in the selection screen to populate
*              during PO creation.
*              2. Added logic to get the delivery address number and
*                 cost center which is being used during PO creation.
*              3. Removed the logic for Goods Receipt as per the design
*                 its not needed any more. Also removed GI movement type
*                 from the selection screen(p_mvt_gi).
*--------------------------------------------------------------------*
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_JDR_TOP
*&---------------------------------------------------------------------*


* Global Type Declaration
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
* BOI by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
  BEGIN OF ty_ccode_mat,
    bukrs TYPE ps_pbukr,
    matnr TYPE zzmpmissu,
  END OF ty_ccode_mat,
* EOI by PBANDLAPAL on 26-Jan-2018 for ERP-6110: ED2K910553
* Global Table type declaration
  tt_alv         TYPE STANDARD TABLE OF ty_alv,
  tt_inven_recon TYPE STANDARD TABLE OF zqtc_inven_recon,     " Table for Inventory Reconciliation Data
  tt_edidd       TYPE STANDARD TABLE OF edidd INITIAL SIZE 0. " Data record (IDoc)

TYPE-POOLS: slis.

* Global Internal Table Declaration
DATA : i_inven_recon     TYPE tt_inven_recon,
       i_inven_recon_all TYPE tt_inven_recon,
       i_alv             TYPE tt_alv,
       i_fcat            TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0.

* Constant Declaration
CONSTANTS : c_inven_recon TYPE tabname VALUE 'ZQTC_INVEN_RECON'. " Table Name

* Global Varible
DATA : v_lock TYPE flag. " General Flag
