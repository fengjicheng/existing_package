*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* The Purpose of this Report is to enable JRR Report(Printer Reconcillia
* tion) and JDR Report (Distributor Reconcilliation).
* This report will provide summarized as well as detailed report
* Inside this include all the subroutine has been defined.
* DEVELOPER: Lucky Kodwani/Mounika Nallapaneni
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K907465
* REFERENCE NO: ERP-3413
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 26-Jul-2017
* DESCRIPTION: Screen Valdiation errors has been corrected.
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCNR_INVENT_RECON_TOP
*&---------------------------------------------------------------------*

* Global Type Declaration
TYPES:    BEGIN OF ty_mara,
            matnr     TYPE matnr,             " Material Number
            labor     TYPE labor,             " Laboratory/design office
            ismyearnr TYPE ismjahrgang,       " Media issue year number
          END OF ty_mara,

          BEGIN OF ty_zqtc_inven_recon,
            matnr        TYPE     matnr,      " Material Number
            werks        TYPE     dwerk_ext,  " Delivering Plant (Own or External)
            zadjtyp      TYPE     zadjtyp,    " Adjustment Type
            zevent       TYPE     zevent,     " Event
            zdate	       TYPE     ztdate,     " Transactional date
            zseqno       TYPE     pkr_seq,    " Sequence Num
            zsupplm	     TYPE   zsupplm,      " Supplement
            zmaildt	     TYPE   zmaildt,      " Mail Date
            zsohqty	     TYPE   zsohqty,      " Stock On Hand
            zadjqty      TYPE   zadjqty,      " Adjustment Qty
            zprntrn	     TYPE   zprntrn,      " Ordered Print Run
            zrcpt	       TYPE   zrcpt,        " Receipt Qty
            zmainlbl     TYPE   zmainlbl,     " Main Label Qty
            zoffline     TYPE   zoffline,     " Offline Member Qty
            zconqty	     TYPE   zconqty,      " Contributor Qty
            zebo         TYPE   zebo,         " EBO Qty
            zsource	     TYPE   ztsource,     " Source file Name
            zsysdate     TYPE   zsysdate,     " System Date
            ismrefmdprod TYPE   ismrefmdprod, " Higher-Level Media Product
            ismyearnr	   TYPE   ismjahrgang,  " Media issue year number
            zfgrdat	     TYPE   zfgrdat,      " First GR date
            zlgrdat      TYPE   zlgrdat,      " Last GR date
            ebeln        TYPE   ebeln,        " Purchasing Document Number
            mblnr        TYPE   mblnr,        " Number of Material Document
            xblnr        TYPE   xblnr,        " Reference Document Number
* BOI on 18-DEC-2017 by PBANDLAPAL for CR#590 : ED2K909595
            zgi_docnum   TYPE zgi_docnum,     " Goods Issue Idoc number.
            zgi_mblnr    TYPE zgi_mblnr,      " Goods Issue Material Document Number
* EOI on 18-DEC-2017 by PBANDLAPAL for CR#590 : ED2K909595
          END OF ty_zqtc_inven_recon,

          BEGIN OF ty_ekpo,
            ebeln TYPE ebeln,                 " Purchasing Document Number
            ebelp TYPE ebelp,                 " Item Number of Purchasing Document
            loekz TYPE eloek,                 " Deletion Indicator in Purchasing Document
            matnr TYPE matnr,                 " Material Number
            werks TYPE ewerks,                " Plant for individual capacity
            bednr TYPE bednr,                 " Requirement Tracking Number
            menge TYPE bstmg,                 " Purchase Order Quantity
            meins TYPE bstme,                 " Purchase Order Unit of Measure
            netwr TYPE bwert,                 " Net Order Value in PO Currency
            pstyp TYPE pstyp,                 " Item Category in Purchasing Document
            knttp TYPE knttp,                 " Account Assignment Category
            emlif TYPE emlif,                 " Vendor to be supplied/who is to receive delivery
            elikz TYPE elikz,                 " "Delivery Completed" Indicator
            banfn TYPE banfn,                 " Purchase Requisition Number
            bnfpo TYPE bnfpo,                 " Item Number of Purchase Requisition
            bsart TYPE bsart,                 " Order Type (Purchasing)
            lifnr TYPE elifn,                 " Currency Key
            waers TYPE waers,                 " Plant for individual capacity
          END OF ty_ekpo,

          BEGIN OF ty_ekbe,
            ebeln TYPE  ebeln,                " Purchasing Document Number
            ebelp TYPE  ebelp,                " Item Number of Purchasing Document
            zekkn TYPE  dzekkn,               " Sequential Number of Account Assignment
            vgabe TYPE  vgabe,                " Transaction/event type, purchase order history
            gjahr TYPE  mjahr,                " Material Document Year
            belnr TYPE  mblnr,                " Number of Material Document
            buzei TYPE  mblpo,                " Item in Material Document
            bewtp TYPE  bewtp,                " Purchase Order History Category
            bwart TYPE  bwart,                " Movement Type (Inventory Management)
            menge TYPE  menge_d,              " Quantity
            dmbtr TYPE  dmbtr,                " Amount in Local Currency
            waers TYPE waers,                 " Currency Key
            shkzg TYPE shkzg,                 " Debit/Credit indicator
            matnr	TYPE matnr,
            werks TYPE werks_d,               " Plant
          END OF ty_ekbe,

          BEGIN OF ty_marc,
            matnr TYPE matnr,                 " Material Number
            werks TYPE werks_d,               " Plant
            dispo TYPE dispo,                 " MRP Controller (Materials Planner)
          END OF ty_marc,

          BEGIN OF ty_lfa1,
            lifnr TYPE lifnr,                 " Account Number of Vendor or Creditor
            name1 TYPE name1_gp,              " Name 1
            name2 TYPE name2_gp,              " Name 2
          END OF ty_lfa1,

          BEGIN OF ty_final,
            sl_no     TYPE char3,             " Numc3, internal use
            matnr     TYPE matnr,             " Material Number
            labor     TYPE labor,             " Laboratory/design office
            dispo     TYPE dispo,             " MRP Controller (Materials Planner)
            werks     TYPE ewerks,            " Plant for individual capacity
            lifnr     TYPE elifn,             " Vendor Account Number
            name1     TYPE name1_gp,          " Name 1
            emlif     TYPE emlif,             " Vendor to be supplied/who is to receive delivery
            name2     TYPE name1_gp,          " Name 1
            menge     TYPE bstmg,             " Purchase Order Quantity
            meins     TYPE bstme,             " Purchase Order Unit of Measure
            netwr     TYPE bwert,             " Net Order Value in PO Currency
            waers_po  TYPE waers,             " Currency Key
            menge_gr  TYPE bstmg,             " Purchase Order Quantity
            mat_uom   TYPE bstme,             " Purchase Order Unit of Measure
            menge_in  TYPE bstmg,             " Purchase Order Quantity
            inv_uom   TYPE bstme,             " Purchase Order Unit of Measure
            dmbtr     TYPE dmbtr,             " Amount in Local Currency
            waers_inv TYPE waers,             " Currency Key
            confirmed TYPE zrcpt,             " Confirmed Quantity
            i0315_uom TYPE bstme,             " Purchase Order Unit of Measure
            derived   TYPE zrcpt,             " Derived Quantity
            message   TYPE char50,            " Message
          END OF ty_final,

          BEGIN OF ty_final1,
            sl_no      TYPE char3,            " Numc3, internal use
            matnr      TYPE matnr,            " Material Number
            labor      TYPE labor,            " Laboratory/design office
            dispo      TYPE dispo,            " MRP Controller (Materials Planner)
            werks      TYPE ewerks,           " Plant for individual capacity
            lifnr      TYPE elifn,            " Vendor Account Number
            name1      TYPE name1_gp,         " Name 1
            emlif      TYPE emlif,            " Vendor to be supplied/who is to receive delivery
            name2      TYPE name1_gp,         " Name 1
            ebeln      TYPE ebeln,            " Purchasing Document Number
            ebelp      TYPE ebelp,            " Item Number of Purchasing Document
            po_sub_itm TYPE char3,            " PO Sub Item
            menge      TYPE bstmg,            " Purchase Order Quantity
            meins      TYPE bstme,            " Purchase Order Unit of Measure
            netwr      TYPE bwert,            " Net Order Value in PO Currency
            waers_po   TYPE waers,            " Currency Key
            bwart      TYPE  bwart,           " Movement Type (Inventory Management)
            belnr      TYPE mblnr,            " Number of Material Document
            buzei      TYPE mblpo,            " Item in Material Document
            menge_gr   TYPE bstmg,            " Purchase Order Quantity
            mat_uom    TYPE bstme,            " Purchase Order Unit of Measure
            menge_in   TYPE bstmg,            " Purchase Order Quantity
            inv_uom    TYPE bstme,            " Purchase Order Unit of Measure
            dmbtr      TYPE dmbtr,            " Amount in Local Currency
            waers_inv  TYPE waers,            " Currency Key
            confirmed  TYPE zrcpt,            " Confirmed Quantity
            i0315_uom  TYPE bstme,            " Purchase Order Unit of Measure
            derived    TYPE zrcpt,            " Derived Quantity
            message    TYPE char50,           " Message
          END OF ty_final1,

          BEGIN OF ty_lifnr,
            sign   TYPE ddsign,               " Type of SIGN component in row type of a Ranges type
            option TYPE ddoption,             " Type of OPTION component in row type of a Ranges type
            low    TYPE elifn,                " Vendor Account Number
            high   TYPE elifn,                " Vendor Account Number
          END OF ty_lifnr,

          BEGIN OF ty_jdr_summ ,
*            sel     type char1,
            sl_no    TYPE char10,             " Numc3, internal use
            matnr    TYPE matnr,              " Material Number
            labor    TYPE labor,              " Laboratory/design office
            dispo    TYPE dispo,              " MRP Controller (Materials Planner)
            werks    TYPE ewerks,             " Plant for individual capacity
            lifnr    TYPE elifn,              " Vendor Account Number
            name1    TYPE name1_gp,           " Name 1
            emlif    TYPE emlif,              " Vendor to be supplied/who is to receive delivery
            name2    TYPE name1_gp,           " Name 1
            po_qty   TYPE bstmg,              " Purchase Order Quantity
            po_uom   TYPE bstme,              " Purchase Order Unit of Measure
            mat_qty  TYPE menge_d,            " Material Quantity
            mat_uom  TYPE bstme,              " Purchase Order Unit of Measure
            jfds_qty TYPE menge_d,            " Purchase Order Quantity
            jfds_uom TYPE bstme,              " Purchase Order Unit of Measure
            zevent   TYPE zevent,             " Event
            variance TYPE menge_d,            " Quantity
            message  TYPE char50,             " Message of type CHAR50
          END OF ty_jdr_summ,

          BEGIN OF ty_jdr_detl,
*            sel    type char1,
            sl_no    TYPE char10,             " Numc3, internal use
            matnr    TYPE matnr,              " Material Number
            labor    TYPE labor,              " Laboratory/design office
            dispo    TYPE dispo,              " MRP Controller (Materials Planner)
            werks    TYPE ewerks,             " Plant for individual capacity
            lifnr    TYPE elifn,              " Vendor Account Number
            name1    TYPE name1_gp,           " Name 1
            emlif    TYPE emlif,              " Vendor to be supplied/who is to receive delivery
            name2    TYPE name1_gp,           " Name 1
            ebeln    TYPE ebeln,              " Purchasing Document Number
            ebelp    TYPE ebelp,              " Item Number of Purchasing Document
            sub_item TYPE ebelp,              " PO Sub Item Number
            po_qty   TYPE bstmg,              " Purchase Order Quantity
            po_uom   TYPE bstme,              " Purchase Order Unit of Measure
            bwart    TYPE bwart,              " Movement Type (Inventory Management)
            belnr	   TYPE mblnr,              " Number of Material Document
            buzei    TYPE mblpo,              " Item in Material Document
            mat_qty  TYPE menge_d,            " Material Quantity
            mat_uom  TYPE bstme,              " Purchase Order Unit of Measure
            jfds_qty TYPE menge_d,            " Purchase Order Quantity
            jfds_uom TYPE bstme,              " Purchase Order Unit of Measure
            zevent   TYPE zevent,             " Event
            variance TYPE menge_d,            " Quantity
            message  TYPE char50,             " Exception Message
          END OF ty_jdr_detl,

          BEGIN OF ty_eord,
            matnr TYPE  matnr,                " Material Number
            werks TYPE ewerk,                 " Plant
            lifnr TYPE elifn,                 " Vendor Account Number
            flifn	TYPE flifn,
            autet	TYPE autet,
          END OF ty_eord,

          BEGIN OF ty_constant,
            devid	 TYPE zdevid,               "Development ID
            param1 TYPE rvari_vnam,           "ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,           "ABAP: Name of Variant Variable
            srno   TYPE tvarv_numb,           "ABAP: Current selection number
            sign   TYPE tvarv_sign,           "ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,           "ABAP: Selection option (EQ/BT/CP/...)
            low    TYPE salv_de_selopt_low,   "Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high,  "Upper Value of Selection Condition
          END OF ty_constant ,

          BEGIN OF ty_repro,
            sl_no        TYPE char10,         " No of type CHAR10
            matnr        TYPE matnr,          " Material Number
            werks        TYPE dwerk_ext,      " Delivering Plant (Own or External)
            zadjtyp      TYPE zadjtyp,        " Adjustment Type
            zevent       TYPE zevent,         " Event
            zdate	       TYPE ztdate,         " Transactional date
            zseqno       TYPE pkr_seq,        " Sequence Num
            zsupplm	     TYPE zsupplm,        " Supplement
            zmaildt	     TYPE zmaildt,        " Mail Date
            zsohqty	     TYPE zsohqty,        " Stock On Hand
            zadjqty      TYPE zadjqty,        " Adjustment Qty
            zprntrn	     TYPE zprntrn,        " Ordered Print Run
            zrcpt	       TYPE zrcpt,          " Receipt Qty
            zmainlbl     TYPE zmainlbl,       " Main Label Qty
            zoffline     TYPE zoffline,       " Offline Member Qty
            zconqty	     TYPE zconqty,        " Contributor Qty
            zebo         TYPE zebo,           " EBO Qty
            zsource	     TYPE ztsource,       " Source file Name
            zsysdate     TYPE zsysdate,       " System Date
            ismrefmdprod TYPE ismrefmdprod,   " Higher-Level Media Product
            ismyearnr	   TYPE ismjahrgang,    " Media issue year number
            zfgrdat	     TYPE zfgrdat,        " First GR date
            zlgrdat      TYPE zlgrdat,        " Last GR date
            ebeln        TYPE ebeln,          " Purchasing Document Number
            mblnr        TYPE mblnr,          " Number of Material Document
            xblnr	       TYPE xblnr,          " Reference Document Number
            message      TYPE char100,         " Message of type CHAR100
* Begin of Change on 16-oct-2017 by PBANDLAPAL for CR#590
            zgi_docnum   TYPE zgi_docnum,     " Goods Issue Idoc Number
            zgi_mblnr    TYPE zgi_mblnr,      " Goods Issue Reference Doc Number
            message_gi   TYPE char100,         " Message of type CHAR100
* End of Change on 16-oct-2017 by PBANDLAPAL for CR#590
          END OF ty_repro,

          BEGIN OF ty_idoc,
            idoc_no TYPE zgi_docnum,          " Goods Issue Idoc Number
          END OF ty_idoc,

* Global Table Type Declaration
          tt_idoc        TYPE STANDARD TABLE OF ty_idoc INITIAL SIZE 0,
          tt_repro       TYPE STANDARD TABLE OF ty_repro INITIAL SIZE 0,
          tt_mara        TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
          tt_constant    TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
          tt_ekpo        TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
          tt_ekbe        TYPE STANDARD TABLE OF ty_ekbe INITIAL SIZE 0,
          tt_inven_recon TYPE STANDARD TABLE OF ty_zqtc_inven_recon INITIAL SIZE 0, " Table for Inventory Reconciliation Data
          tt_marc        TYPE STANDARD TABLE OF ty_marc INITIAL SIZE 0,
          tt_lfa1        TYPE STANDARD TABLE OF ty_lfa1 INITIAL SIZE 0,
          tt_lifnr       TYPE STANDARD TABLE OF ty_lifnr INITIAL SIZE 0,
          tt_final       TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
          tt_final1      TYPE STANDARD TABLE OF ty_final1 INITIAL SIZE 0,
          tt_jdr_summ    TYPE STANDARD TABLE OF ty_jdr_summ INITIAL SIZE 0,
          tt_jdr_detl    TYPE STANDARD TABLE OF ty_jdr_detl INITIAL SIZE 0.

* Global Internal Table Declaration
DATA: i_mara        TYPE tt_mara,
      i_idoc        TYPE tt_idoc,
      i_repro       TYPE tt_repro,
      i_ekpo        TYPE tt_ekpo,
      i_ekbe        TYPE tt_ekbe,
      i_inven_recon TYPE tt_inven_recon,
      i_marc        TYPE tt_marc,
      i_lfa1        TYPE tt_lfa1,
      i_lifnr       TYPE tt_lifnr,
      i_final       TYPE tt_final,
      i_final1      TYPE tt_final1,
      i_jdr_summ    TYPE tt_jdr_summ,
      i_jdr_detl    TYPE tt_jdr_detl,
      i_constant    TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
      i_eord        TYPE STANDARD TABLE OF ty_eord INITIAL SIZE 0,
      i_eord_print  TYPE STANDARD TABLE OF ty_eord INITIAL SIZE 0,
      i_fcat        TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
      i_fcat_repro  TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
      i_fcat_detl   TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0.

* Global Range Declaration
TYPES :  tt_labor TYPE RANGE OF labor, " Laboratory/design office
         tt_dispo TYPE RANGE OF dispo. " MRP Controller (Materials Planner)

****** Global Variable Declaration
DATA:v_matnr  TYPE matnr,        " Material Number
     v_werks  TYPE werks_d,      " Plant
     v_medprd TYPE ismrefmdprod, " Higher-Level Media Product
     v_mattyp TYPE mtart,        " Material Type
     v_print  TYPE lifnr,        " Account Number of Vendor or Creditor
     v_distr  TYPE emlif,        " Vendor to be supplied/who is to receive delivery
     v_matofc TYPE labor,        " Laboratory/design office
     v_medpro TYPE dispo.        " MRP Controller (Materials Planner)

**** Constant Declaration
DATA : c_scrgroup1  TYPE char3   VALUE 'JDR', " Scrgroup1 of type CHAR3
       c_scrgroup2  TYPE char3   VALUE 'RPR', " Scrgroup1 of type CHAR3
       c_jrr        TYPE zadjtyp VALUE 'JRR', " Adjustment Type
       c_nb         TYPE bsart   VALUE 'NB',  " Order Type (Purchasing)
       c_znb        TYPE bsart   VALUE 'ZNB', " Order Type (Purchasing)
       c_bewtp_e    TYPE bewtp   VALUE 'E',   " Purchase Order History Category
       c_shkzg_s    TYPE shkzg   VALUE 'S',   " Debit/Credit Indicator
       c_shkzg_h    TYPE shkzg   VALUE 'H',   " Debit/Credit Indicator
       c_bewtp_q    TYPE bewtp   VALUE 'Q',   " Purchase Order History Category
* Begin of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3413.
       c_ucomm_onli TYPE syst_ucomm VALUE 'ONLI',   " User command for Execute
       c_ucomm_prin TYPE syst_ucomm VALUE 'PRIN',   " User command for Execute and Print
       c_ucomm_sjob TYPE syst_ucomm VALUE 'SJOB'.   " User command for Execute in background.
* End of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3413.
