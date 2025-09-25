*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_PRINT_RUN_REPT_R064
* PROGRAM DESCRIPTION: Print Run Report
* The Purpose of this Report is to show number of current
* open subscriptions, the estimated number of offline subscriptions
* un-renewed quantity of a perticular issue.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO:  ED2K907692
* REFERENCE NO:  ERP-3749
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-08-04
* DESCRIPTION: To add the Distributot Purchase order number in the output
*              of the report and to fix selection screen validation errors.
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PRINT_RUN_REPT_R064_TOP
*&---------------------------------------------------------------------*

* &---------------------------------------------------------------------*
*&            Type Declaration
*&---------------------------------------------------------------------*

TYPES:  BEGIN OF ty_mara,
          matnr           TYPE matnr,          " Material number
          mtart           TYPE mtart,          "Material type
          ismhierarchlevl TYPE ismhierarchlvl, " Hierarchy Level
          ismrefmdprod    TYPE ismrefmdprod,   " Higher-Level Media Product
          ismmediatype    TYPE ismmediatype,   " Media Type
          ismpubldate     TYPE ismpubldate,    " Publication Date
          ismyearnr       TYPE ismjahrgang,    " Media issue year number
          isminitshipdate TYPE ismerstverdat,
          idcodetype      TYPE ismidcodetype,
          identcode	      TYPE ismidentcode,   " Identification
          pspnr           TYPE  ps_posnr,      " WBS Element
          posid           TYPE ps_posid,       " Work Breakdown Structure Element (WBS Element)
          objnr           TYPE j_objnr,        " Object number
          pkokr           TYPE ps_pkokr,       " Controlling area for WBS element
          kostl	          TYPE ps_kostl  ,     " Cost center to which costs are actually posted
        END OF ty_mara,

        BEGIN OF ty_cosp,
          lednr	 TYPE lednr,                   " Ledger for Controlling objects
          objnr  TYPE j_objnr,                 " Object number
          gjahr	 TYPE gjahr,                   " Fiscal Year
          wrttp	 TYPE co_wrttp,                " Value Type
          versn	 TYPE versn,                   " Version
          kstar	 TYPE kstar,                   " Cost Element
          hrkft	 TYPE co_subkey,               " CO key subnumber
          vrgng	 TYPE co_vorgang,              " CO Business Transaction
          vbund	 TYPE rassc,                   " Company ID of Trading Partner
          pargb	 TYPE pargb,                   " Trading Partner's Business Area
          beknz	 TYPE beknz,                   " Debit/credit indicator
          twaer	 TYPE twaer,                   " Transaction Currency
          perbl	 TYPE perbl,                   " Period block
          wtg001 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg002 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg003 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg004 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg005 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg006 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg007 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg008 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg009 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg010 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg011 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg012 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg013 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg014 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg015 TYPE wtgxxx,                  " Total Value in Transaction Currency
          wtg016 TYPE wtgxxx,                  " Total Value in Transaction Currency
        END OF ty_cosp,

        BEGIN OF ty_vbap,
          vbeln	 TYPE vbeln_va,              " Sales Document
          posnr	 TYPE posnr_va,              " Sales Document Item
          matnr  TYPE matnr,                 " Material Number
          pstyv	 TYPE pstyv,                 " Sales document item category
          abgru	 TYPE abgru_va,              " Reason for rejection of quotations and sales orders
          kwmeng TYPE kwmeng,                " Cumulative Order Quantity in Sales Units
          vgbel	 TYPE vgbel,                 " Document number of the reference document
          vgpos	 TYPE vgpos,                 " Item number of the reference item
          auart	 TYPE auart,                 " Sales Document Type
        END OF ty_vbap,

        BEGIN OF ty_jksesched,
          vbeln    TYPE vbeln,            " Sales and Distribution Document Number
          posnr    TYPE posnr,            " Item number of the SD document
          issue    TYPE ismmatnr_issue,   " Media Issue
          product  TYPE ismmatnr_product, " Media Product
          sequence TYPE jmsequence,       " IS-M: Sequence
          quantity TYPE jmquantity,       " Target quantity in sales units
        END OF ty_jksesched,

        BEGIN OF ty_vbap_sub,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          abgru TYPE abgru_va,
        END OF ty_vbap_sub,

        BEGIN OF ty_veda_sub,
          vbeln   TYPE vbeln,
          vposn   TYPE posnr_va,
          vkuegru TYPE vkgru_veda,       " Reason for Cancellation of Contract
        END OF ty_veda_sub,

        BEGIN OF ty_mseg,
          mblnr TYPE mblnr,
          mjahr TYPE mjahr,
          zeile TYPE mblpo,
          bwart TYPE bwart,                    " Movement Type (Inventory Management)
          matnr TYPE matnr,                    " Material Number
          shkzg TYPE shkzg,                    " Debit/Credit Indicator
          menge TYPE menge_d,                  " Quantity
        END OF ty_mseg,

        BEGIN OF ty_prnt_golive,
          zperiod   TYPE zzperiod,
          media_prd TYPE matnr,
          menge     TYPE zzmenge,
        END OF ty_prnt_golive,

        BEGIN OF ty_inven_recon,
          zadjtyp      TYPE zadjtyp,           " Adjustment Type
          matnr        TYPE matnr,             " Material Number
          zevent       TYPE zevent,            " Event
          zdate        TYPE ztdate,            " Transactional date
          zseqno       TYPE pkr_seq,           " Sequence Num
          zoffline     TYPE zoffline,          " Offline Member Qty
          ismrefmdprod TYPE ismrefmdprod,      " Higher-Level Media Product
          zfgrdat      TYPE zfgrdat,           " First GR date
          zlgrdat      TYPE zlgrdat,           " Last GR date
        END OF ty_inven_recon,

        BEGIN OF ty_ekpo,
          ebeln TYPE ebeln,                    " Purchasing Document Number
          ebelp TYPE ebelp,                    " Item Number of Purchasing Document
          matnr TYPE matnr,                    " Material Number
          bednr TYPE bednr,                    " Requirement Tracking Number
          menge TYPE bstmg,                    " Purchase Order Quantity
          pstyp TYPE pstyp,                    " Item Category in Purchasing Document
          knttp TYPE knttp,                    " Account Assignment Category
          banfn TYPE banfn,                    " Purchase Requisition Number
          bnfpo TYPE bnfpo,                    " Item Number of Purchase Requisition
          bsart TYPE esart,                    " Purchasing Document Type
        END OF ty_ekpo,

        BEGIN OF ty_constant,
          devid	 TYPE zdevid,                  "Development ID
          param1 TYPE rvari_vnam,              "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,              "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,              "ABAP: Current selection number
          sign   TYPE tvarv_sign,              "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,              "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,      "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,     "Upper Value of Selection Condition
        END OF ty_constant,

        BEGIN OF ty_eban,
          banfn TYPE banfn,                    " Purchase Requisition Number
          bnfpo TYPE bnfpo,                    " Item Number of Purchase Requisition
          bsart TYPE bbsrt,                    " Purchase Requisition Document Type
          matnr TYPE matnr,                    " Material Number
          menge TYPE bamng,                    " Purchase Requisition Quantity
          meins TYPE bamei,                    " Purchase Requisition Unit of Measure
        END OF ty_eban,

        BEGIN OF ty_final,
          matnr           TYPE matnr,              " Material Number
          identcode	      TYPE ismidentcode,       " Identification Code
          ismpubldate     TYPE ismpubldate,        " Publication Date
          isminitshipdate TYPE ismerstverdat,    " Initial Shipping Date
          budget          TYPE wtgxxx,             " Total Value in Transaction Currency
          bud_curr        TYPE twaer,              " Transaction Currency
          sub_qty         TYPE jmquantity,         " Target quantity in sales units
          sal_qty         TYPE kwmeng,             " Cumulative Order Quantity in Sales Units
          off_qty         TYPE bstmg,              " Offline Quantity
          preyr_qty       TYPE bstmg,              " Previous Year Quantity
          print_qty       TYPE bstmg,              " Print Quantity
          conf_qty        TYPE bstmg,              " Conference Quantity
          distr_qty       TYPE bstmg,              " Distributor Quantity
          unrenew_qty     TYPE bstmg,              " Unrenewed Quantity
* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
          ebeln           TYPE ebeln,              " Purchase Order
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
          ref_mat         TYPE matnr,              " Reference Material
        END OF ty_final.

TYPES: tt_eban        TYPE STANDARD TABLE OF ty_eban     INITIAL SIZE 0,
       tt_ekpo        TYPE STANDARD TABLE OF ty_ekpo     INITIAL SIZE 0,
       tt_inven_recon TYPE STANDARD TABLE OF ty_inven_recon INITIAL SIZE 0,
       tt_prnt_golive TYPE STANDARD TABLE OF ty_prnt_golive INITIAL SIZE 0,
       tt_jksesched   TYPE STANDARD TABLE OF ty_jksesched INITIAL SIZE 0,
       tt_vbap_sub    TYPE STANDARD TABLE OF ty_vbap_sub INITIAL SIZE 0,
       tt_veda_sub    TYPE STANDARD TABLE OF ty_veda_sub  INITIAL SIZE 0,
       tt_mseg        TYPE STANDARD TABLE OF ty_mseg        INITIAL SIZE 0,
       tt_vbap        TYPE STANDARD TABLE OF ty_vbap        INITIAL SIZE 0,
       tt_mara        TYPE STANDARD TABLE OF ty_mara  INITIAL SIZE 0,
       tt_final       TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
       tt_cosp        TYPE STANDARD TABLE OF ty_cosp INITIAL SIZE 0.

DATA : i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
       i_final    TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
       i_fcat     TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0.


DATA : v_matnr       TYPE matnr,        " Material Number
       v_pbyear      TYPE ismjahrgang,  " Media issue year number
       v_bwart       TYPE bwart,        " Movement Type (Inventory Management)
       v_medprd      TYPE ismrefmdprod, " Higher-Level Media Product
       v_ismpubldate TYPE ismpubldate,  " Publication Date
       v_auart       TYPE auart.        " Sales Document Type

CONSTANTS: c_sign_incld TYPE ddsign     VALUE 'I',    "Sign: (I)nclude
           c_opti_equal TYPE ddoption   VALUE 'EQ',   "Option: (EQ)ual
           c_movtyp_251 TYPE bwart      VALUE '251',  " Movement Type (Inventory Management)
           c_movtyp_252 TYPE bwart      VALUE '252',  " Movement Type (Inventory Management)
           c_devid      TYPE zdevid     VALUE 'R064', " Development ID
           c_knttp_p    TYPE knttp      VALUE 'P',    " Account Assignment Category
           c_knttp_x    TYPE knttp      VALUE 'X',    " Account Assignment Category
           c_vbtyp_c    TYPE vbtyp      VALUE 'C',    " SD Document Category(Sales Order)
           c_vbtyp_g    TYPE vbtyp      VALUE 'G',    " SD Document Category(Subscription)
           c_vbtyp_i    TYPE vbtyp      VALUE 'I',    " SD Document Category(Claims)
           c_bsart_nb   TYPE bsart      VALUE 'NB',   " Order Type (Purchasing)
           c_bsart_znb  TYPE bsart      VALUE 'ZNB',  " Order Type (Purchasing)
           c_bsart_zcf  TYPE bsart      VALUE 'ZCF',  " Order Type (Purchasing)
           c_loekz_del  TYPE eloek      VALUE 'L',    " Deletion Indicator in PO Doc(L)
* BOI: 04-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
           c_ucomm_onli TYPE syst_ucomm VALUE 'ONLI',   " User command for Execute
           c_ucomm_prin TYPE syst_ucomm VALUE 'PRIN',   " User command for Execute and Print
           c_ucomm_sjob TYPE syst_ucomm VALUE 'SJOB',   " User command for Execute in background.
* EOI: 04-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
           c_pstyp_5    TYPE pstyp      VALUE '5'.    " Item Category in Purchasing Document
