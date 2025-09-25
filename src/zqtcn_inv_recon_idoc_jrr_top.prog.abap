*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Include for all the declarations of global data
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-03-27
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION  NO:   <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_IDOC_TOP
*&---------------------------------------------------------------------*
TYPES:
       BEGIN OF ty_output_det,
         idoc_number  TYPE edi_docnum, "Idoc Number
         po_number    TYPE ebeln,
         matnr        TYPE matnr,
         delivery     TYPE vbeln_vl,
         material_doc TYPE mblnr,
         type         TYPE edi_symsty, "type
         id           TYPE edi_stamid, "id
         number       TYPE edi_stamno, "number
         message      TYPE bapi_msg, "message
       END OF ty_output_det,

       BEGIN OF ty_output,
         status       TYPE char1,
         number       TYPE edi_stamno, "number
         id           TYPE edi_stamid, "id
         idoc_number  TYPE edi_docnum, "Idoc Number
         zadjtyp      TYPE zadjtyp,
         matnr        TYPE matnr,
         plant        TYPE ewerks,
         po_number    TYPE ebeln,
         item_no      TYPE ebelp,
         material_doc TYPE mblnr,
         source_file  TYPE char50,
         message      TYPE bapi_msg, "message
       END OF ty_output,

       BEGIN OF ty_ekpo,
         matnr TYPE matnr,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         loekz TYPE eloek,
         werks TYPE ewerk,
         lgort TYPE lgort_d,
         menge TYPE bstmg,
         meins TYPE bstme,
         knttp TYPE knttp,
         elikz TYPE elikz,
         uebto TYPE uebto,
         banfn TYPE banfn,
         bsart TYPE esart,
         lifnr TYPE lifnr,
       END OF ty_ekpo,

       BEGIN OF ty_ekbe,
         ebeln TYPE ebeln,        " Purchasing Document Number
         ebelp TYPE ebelp,        " Item Number of Purchasing Document
         zekkn TYPE dzekkn,
         vgabe TYPE vgabe,
         gjahr TYPE mjahr,
         belnr TYPE mblnr,
         buzei TYPE mblpo,
         bwart TYPE bwart,
         menge TYPE menge_d,
         waers TYPE waers,
         shkzg TYPE shkzg,
       END OF ty_ekbe,

       BEGIN OF ty_idocnumber,
         idocnumber TYPE char70,
       END OF ty_idocnumber,


*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
       tt_edidd       TYPE STANDARD TABLE OF edidd
                  INITIAL SIZE 0,
       tt_ekpo        TYPE STANDARD TABLE OF ty_ekpo,
       tt_ekbe        TYPE STANDARD TABLE OF ty_ekbe
                   INITIAL SIZE 0,
       tt_custom      TYPE STANDARD TABLE OF zqtc_inven_recon
                   INITIAL SIZE 0,
       tt_final       TYPE STANDARD TABLE OF e1bp2017_gm_item_create
                   INITIAL SIZE 0,
       tt_output      TYPE STANDARD TABLE OF ty_output INITIAL SIZE 0.



*&---------------------------------------------------------------------*
*& W O R K A R E A
*&---------------------------------------------------------------------*
DATA: st_edidc_po   TYPE edidc, " for control structure of PO goods receipt
      st_idocnumber TYPE ty_idocnumber.

*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*

DATA:  "i_output_det  TYPE tt_output_det, " Output details
  i_output      TYPE tt_output,     "Output Message
  i_ekpo        TYPE tt_ekpo,       " Item EKPO table
  i_ekpo_tol    TYPE tt_ekpo,       " Item EKPO table
  i_ekbe        TYPE tt_ekbe,       " PO history data
  i_custom      TYPE tt_custom,     " ZQTC_INVEN_RECON
  i_custom_tmp  TYPE tt_custom,     " ZQTC_INVEN_RECON
  i_custom_idoc TYPE tt_custom,     " ZQTC_INVEN_RECON
  i_custom_fail TYPE tt_custom,     " ZQTC_INVEN_RECON
  i_idoc        TYPE tt_custom,     " IDOC control record data
  i_date        TYPE fieu_t_date_range,
  i_idocnumber  TYPE STANDARD TABLE OF ty_idocnumber
                INITIAL SIZE 0.

CONSTANTS: c_adj   TYPE zadjtyp VALUE 'JRR',
           c_sloc  TYPE lgort_d VALUE 'J001',
           c_mov   TYPE bwart   VALUE '101',
           c_gmc   TYPE gm_code VALUE '01',
           c_uom   TYPE meins   VALUE 'EA',
           c_mov_i TYPE ablad   VALUE 'B',
           c_po    TYPE bewtp   VALUE 'E',
           c_acc   TYPE knttp   VALUE 'P',
           c_doc   TYPE bsart   VALUE 'NB',
           c_succ  TYPE char1   VALUE '3',   "Green
           c_st    TYPE char2   VALUE '53',
           c_err   TYPE char1   VALUE '1',  "Red
           c_dash TYPE char1    VALUE '-'.
