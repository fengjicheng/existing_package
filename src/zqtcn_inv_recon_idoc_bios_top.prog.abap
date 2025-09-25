*------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_INVENT_RECON_BIOS_TOP
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* Declaring all the Global Varible in this include .
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908477
* REFERENCE NO:  CR#590
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  04-Sep-2017
* DESCRIPTION: For Adjustment Type BIOS similar logic to SOH has been
*              implemented. All the necessary code cleaning is done
*              and hence no tags are avaialble. As this was kind of
*              complete new design from scratch.
*---------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K911689
* REFERENCE NO: ERP-7308
* DEVELOPER: Writtick Roy (WROY)
* DATE:  29-Mar-2018
* DESCRIPTION: Logic to populate Cost Center
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_BIOS_TOP
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

* Begin of ADD:ERP-7308:WROY:29-Mar-2018:ED2K911689
  BEGIN OF ty_ccode_mat,
    bukrs TYPE ps_pbukr,
    matnr TYPE zzmpmissu,
  END OF ty_ccode_mat,
* End   of ADD:ERP-7308:WROY:29-Mar-2018:ED2K911689

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

** Global Type Declaration
*TYPES : BEGIN OF ty_inven_recon,
*          zadjtyp TYPE zadjtyp,   " Adjustment Type
*          matnr    TYPE matnr,     " Material Number
*          zevent  TYPE zevent,    " Time at which the RW interface is called up
*          zdate    TYPE ztdate,    " Transactional date
*          zseqno  TYPE pkr_seq,   " Sequence Num
*          werks    TYPE dwerk_ext, " Delivering Plant (Own or External)
*          zsohqty  TYPE zsohqty,   " Stock On Hand
*          zadjqty TYPE zadjqty,   " Adjustment Qty
*          zsource TYPE zsource,   " text for source code
*          zfgrdat  TYPE zfgrdat,   " First GR date
*          zlgrdat  TYPE zlgrdat,   " Last GR date
*          mblnr    TYPE mblnr,     " Number of Material Document
*          xblnr    TYPE xblnr,     " Reference Document Number
*        END OF ty_inven_recon,
*
*        BEGIN OF ty_alv,
*          light   TYPE char4,      " Light of type CHAR4
*          msg_id  TYPE symsgid,    " Message Class
*          msg_no  TYPE symsgno,    " Message Number
*          idoc_no  TYPE edi_docnum, " Reference Document Number
*          zadjtyp TYPE zadjtyp,    " Adjustment Type
*          matnr    TYPE matnr,      " Material Number
*          werks    TYPE dwerk_ext,  " Delivering Plant (Own or External)
**          ebeln   TYPE ebeln,      " Purchasing Document Number
**          ebelp   TYPE ebelp,      " Item Number of Purchasing Document
*          mblnr    TYPE mblnr,      " Number of Material Document
*          zsource  TYPE ztsource,
*          message TYPE bapi_msg,   " Message Text
*        END OF ty_alv,
*
** Global Table type declaration
*         tt_alv         TYPE STANDARD TABLE OF ty_alv,
*        tt_inven_recon TYPE STANDARD TABLE OF ty_inven_recon,
*        tt_edidd       TYPE STANDARD TABLE OF edidd INITIAL SIZE 0. " Data record (IDoc)
*
** Global Internal Table Declaration
*DATA : i_inven_recon TYPE tt_inven_recon,
*       i_fcat        TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
*       i_alv         TYPE tt_alv.
