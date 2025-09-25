*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_JRNL_DSPTCH_SCHDLE
* PROGRAM DESCRIPTION: Journal Dispatch Schedule Report
* DEVELOPER:Shivani Upadhyaya
* CREATION DATE:2017-01-13
* OBJECT ID:I0268
* TRANSPORT NUMBER(S):ED2K904120
*-------------------------------------------------------------------*

* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907393
* REFERENCE NO: ERP-7478
* DEVELOPER: SRREDDY
* DATE:  2018-05-20
* DESCRIPTION: Remove 'No. of Shipping days' population in sel. screen
*              for WMS (Warehouse) File
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
*** REVISION NO : ED2K920229
*** REFERENCE NO: OTCM-25581
*** DEVELOPER   : MIMMADISET
*** DATE        : 11-Nov-2020
*** DESCRIPTION:For all the Media Issues (Physical) a Win-shuttle script*
*** will be used to update the Gross Weight, Net Weight and Weight Unit *
** in the Product Master based on the data provided by Business for the *
** year Media issues of 2020 and 2021.*
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JRNL_DSPTCH_SCHDLE_TOP
*&---------------------------------------------------------------------*

TABLES: mara. " General Material Data

*Strucuture of mara
TYPES: BEGIN OF ty_mara,
         matnr           TYPE matnr,           " Material Number
         mtart           TYPE mtart,           " Material Type
         labor           TYPE labor,           " Laboratory/design office
*BOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
         ntgew           TYPE ntgew,           " Net Weight
*EOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
         ismtitle        TYPE ismtitle,        " Title
         ismrefmdprod    TYPE ismrefmdprod,    " Media Product
         ismpubltype     TYPE ismpubltype,     " Publication Type
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*         ismpubldate    TYPE ismpubldate,     " Publication Date
         isminitshipdate TYPE ismerstverdat,   " Initial Shipping Date
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
         ismcopynr       TYPE ismheftnummer,   " Copy Number of Media Issue
         ismyearnr       TYPE ismjahrgang,     " Media issue year number
         ismissuetypest  TYPE ismausgvartyppl, " Issue Variant Type - Standard (Planned)
       END OF ty_mara,

       BEGIN OF ty_marc,
         matnr TYPE matnr,                    " Material Number
         werks TYPE werks_d,                  " Plant
         perkz TYPE perkz,
         prctr TYPE prctr,                    " Profit Center
         vrbmt TYPE vrbmt,                    " Reference material for consumption
       END OF ty_marc,

       BEGIN OF ty_eord,
         matnr TYPE matnr,                    " Material Number
         werks TYPE ewerk,                    " Plant
         lifnr TYPE elifn,                    " Vendor Account Number
         flifn TYPE flifn,                    " Indicator: Fixed vendor
         autet TYPE autet,                    " Source List Usage in Materials Planning
       END OF ty_eord,

       BEGIN OF ty_lfa1,
         lifnr TYPE lifnr,                    " Account Number of Vendor or Creditor
         name1 TYPE name1_gp,                 " Name 1
       END OF ty_lfa1,

*Structure of jptidcdassign
       BEGIN OF ty_jptidcdassign,
         matnr      TYPE matnr,         " Material Number
         idcodetype TYPE ismidcodetype, "Type of Identification Code
         identcode  TYPE ismidentcode,  " Identification Code
       END OF ty_jptidcdassign,
*Structure of ZQTC_INVEN_RECON
       BEGIN OF ty_zqtc_inven_recon,
         zadjtyp      TYPE zadjtyp,      " Adjustment Type
         matnr        TYPE matnr,        " Material Number
         zevent       TYPE zevent,       " Event
         zdate        TYPE ztdate,       " Transactional date
         zseqno       TYPE pkr_seq,      " Sequence Num
         zoffline     TYPE zoffline,     " Offline Member Qty
         ismrefmdprod TYPE ismrefmdprod, " Higher-Level Media Product
         zfgrdat      TYPE zfgrdat,      " First GR date
         zlgrdat      TYPE zlgrdat,      " Last GR date
       END OF ty_zqtc_inven_recon,
*Structure of CEPCT
       BEGIN OF ty_cepct,
         spras TYPE spras, " Language Key
         prctr TYPE prctr, " Profit Center
         datbi TYPE datbi, " Valid To Date
         kokrs TYPE kokrs, " Controlling Area
         ktext TYPE ktext, " General Name
       END OF ty_cepct,

* Structure of T024X
       BEGIN OF ty_t024x,
         spras TYPE spras, " Language Key
         labor TYPE labor, " Laboratory/design office
         lbtxt TYPE lbtxt, " Description of the laboratory/engineering office
       END OF ty_t024x,

*Structure of MVER
       BEGIN OF ty_mver,
         matnr TYPE matnr,   " Material Number
         werks TYPE werks_d, " Plant
         gjahr TYPE gjahr,   " Fiscal Year
         perkz TYPE perkz,   " Period Indicator
         zahlr TYPE dzahlr,  " Number of follow-on records in Table MVER
         mgv01 TYPE mgvbr,   " Manually corrected total consumption
         mgv02 TYPE mgvbr,   " Manually corrected total consumption
         mgv03 TYPE mgvbr,   " Manually corrected total consumption
         mgv04 TYPE mgvbr,   " Manually corrected total consumption
         mgv05 TYPE mgvbr,   " Manually corrected total consumption
         mgv06 TYPE mgvbr,   " Manually corrected total consumption
         mgv07 TYPE mgvbr,   " Manually corrected total consumption
         mgv08 TYPE mgvbr,   " Manually corrected total consumption
         mgv09 TYPE mgvbr,   " Manually corrected total consumption
         mgv10 TYPE mgvbr,   " Manually corrected total consumption
         mgv11 TYPE mgvbr,   " Manually corrected total consumption
         mgv12 TYPE mgvbr,   " Manually corrected total consumption
       END OF ty_mver,

*Structure of MVKE
       BEGIN OF ty_mvke,
         matnr TYPE matnr,     " Material Number
         vkorg TYPE vkorg,     " Sales Organization
         vtweg TYPE vtweg,     " Distribution Channel
         dwerk TYPE dwerk_ext, " Delivering Plant (Own or External)
       END OF ty_mvke,

*Structure of MAKT
       BEGIN OF ty_makt,
         matnr TYPE matnr, " Material Number
         spras TYPE spras, " Language Key
         maktx TYPE maktx, " Material Description (Short Text)
       END OF ty_makt,

*Structure of MAPR
       BEGIN OF ty_mapr,
         werks TYPE werks_d, " Plant
         matnr TYPE matnr,   " Material Number
         pnum1 TYPE pnum1,   " Pointer: forecast parameters
       END OF ty_mapr,

*Structure of PROP
       BEGIN OF ty_prop,
         pnum1 TYPE pnum1, " Pointer: forecast parameters
         hsnum TYPE hsnum, " Number for history
         versp TYPE versp, " Version number of forecast parameters
         pnum2 TYPE pnum2, " Pointer for forecast results
       END OF ty_prop,

*Structure of PROW
       BEGIN OF ty_prow,
         pnum2 TYPE pnum2, " Pointer for forecast results
         ertag TYPE ertag, " First day of the period to which the values refer
         prwrt TYPE prwrt, " Forecast value
         koprw TYPE koprw, " Corrected value for forecast
       END OF ty_prow,

*Structure of PROW Sum
       BEGIN OF ty_prow_sum,
         pnum2 TYPE pnum2, " Pointer for forecast results
         koprw TYPE koprw, " Corrected value for forecast
       END OF ty_prow_sum,

*Structure of PLAF
       BEGIN OF ty_plaf,
         plnum TYPE plnum, " Planned order number
         matnr TYPE matnr, " Material Number
         plwrk TYPE plwrk, " Planning Plant
         gsmng TYPE gsmng, " Total planned order quantity
         psttr TYPE psttr, " Order start date in planned order
       END OF ty_plaf,

*Structure of EBAN
       BEGIN OF ty_eban,
         banfn TYPE banfn, " Purchase Requisition Number
         bnfpo TYPE bnfpo, " Item Number of Purchase Requisition
         bsart TYPE bbsrt, " Purchase Requisition Document Type
         loekz TYPE eloek, " Deletion Indicator in Purchasing Document
         estkz TYPE estkz, " Creation Indicator (Purchase Requisition/Schedule Lines)
         frgzu TYPE frgzu, " Release status
         frgst TYPE frgst, " Release Strategy in Purchase Requisition  " Defect ERP-1976
         matnr TYPE matnr, " Material Number
         menge TYPE bamng, " Purchase Requisition Quantity
         knttp TYPE knttp, " Account Assignment Category
         flief TYPE flief, " Fixed Vendor
         dispo TYPE dispo, " MRP Controller (Materials Planner)
       END OF ty_eban,

*Structure of EKPO
       BEGIN OF ty_ekpo,
         bsart TYPE esart, " Purchasing Document Type
         ebeln TYPE ebeln, " Purchasing Document Number
         ebelp TYPE ebelp, " Item Number of Purchasing Document
         matnr TYPE matnr, " Material Number
         menge TYPE bstmg, " Material Master View: Alternative Quantity of Material
         knttp TYPE knttp, " Account Assignment Category
         banfn TYPE banfn, " Purchase Requisition Number
       END OF ty_ekpo,

*Structure of VBAP
       BEGIN OF ty_vbap,
         vbeln  TYPE vbeln_va, " Sales Document
         posnr  TYPE posnr_va, " Sales Document Item
         matnr  TYPE matnr,    " Material Number
         kwmeng TYPE kwmeng,   " Order Quantity
         vgbel  TYPE vgbel,    " Ref Doc Number
         vgpos  TYPE vgpos,    " Ref Item Number
         vgtyp  TYPE vbtyp_v,  " Document Category
       END OF ty_vbap,

*Structure of VBEP
       BEGIN OF ty_vbep,
         vbeln TYPE vbeln_va, " Sales Document
         posnr TYPE posnr_va, " Sales Document Item
         wmeng TYPE wmeng,    " Order quantity in sales units
         bmeng TYPE bmeng,    " Confirmed Quantity
       END OF ty_vbep,

*Structure of VBAK
       BEGIN OF ty_vbak,
         vbeln TYPE vbeln_va, " Sales Document
         auart TYPE auart,    " Sales Document Type
       END OF ty_vbak,

*Structure of jksesched
       BEGIN OF ty_jksesched,
         vbeln          TYPE vbeln,            " Sales and Distribution Document Number
         posnr          TYPE posnr,            " Item number of the SD document
         issue          TYPE ismmatnr_issue,   " Media Issue
         product        TYPE ismmatnr_product, " Media Product
         sequence       TYPE jmsequence,       " IS-M: Sequence
         quantity       TYPE jmquantity,       " Target quantity in sales units
         xorder_created TYPE jmorder_created,  " IS-M: Indicator Denoting that Order Was Generated
       END OF ty_jksesched,

       BEGIN OF ty_issue,
         issue    TYPE ismmatnr_issue,         " Media Issue
         quantity TYPE jmquantity,             " Target quantity in sales units
       END OF ty_issue,

       BEGIN OF ty_vbap_orders,
         matnr  TYPE matnr,                    " Material Number
         vbeln  TYPE vbeln,                    " Sales and Distribution Document Number
         posnr  TYPE posnr,                    " Item number of the SD document
         kwmeng TYPE kwmeng,                   " Cumulative Order Quantity in Sales Units
       END OF ty_vbap_orders,

*Structure of Calculation Field
       BEGIN OF ty_calc_tab,
*         matnr    TYPE matnr,   " Material Number
*         zmenge1  TYPE bamng,   " Purchase Requisition Quantity
*         zmenge2  TYPE bmeng,   " Confirmed Quantity
*         zmenge3  TYPE bmeng,   " Confirmed Quantity
*         eblstock TYPE bmeng,   " Confirmed Quantity
*         zmenge4  TYPE bmeng,   " Confirmed Quantity
         matnr    TYPE matnr,   " Material Number
         zmenge1  TYPE p,   " Purchase Requisition Quantity
         zmenge2  TYPE p,   " Confirmed Quantity
         zmenge3  TYPE p,   " Confirmed Quantity
         eblstock TYPE p,   " Confirmed Quantity
         zmenge4  TYPE p,   " Confirmed Quantity
         werks    TYPE werks_d, " Plant
       END OF ty_calc_tab,

*Structure of final table
       BEGIN OF ty_final,
         matnr           TYPE matnr,          " Material Number
         labor           TYPE labor,          " Laboratory/design office
         ismtitle        TYPE ismtitle,       " Title
         ismpubltype     TYPE ismpubltype,    " Publication Type
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*         ismpubldate TYPE char10,         " Publication Date
*         isminitshipdate TYPE char10, "-- GKINTALI:ERP-7445:02.05.2018:ED2K911988
         isminitshipdate TYPE char11,  "++ GKINTALI:ERP-7445:02.05.2018:ED2K911988
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
         ismcopynr       TYPE ismheftnummer,  " Copy Number of Media Issue
         ismyearnr       TYPE ismjahrgang,    " Media issue year number
         jrnltype        TYPE char04,         " Journal Type
         maktx           TYPE maktx,          " Material Description (Short Text)
         identcode       TYPE ismidentcode,   " Identification Code
         printr          TYPE name1_gp,       " Vendor Account Number
         oflflag         TYPE char1,          " Offflag of type CHAR1
         expcode         TYPE elifn,          " Vendor Account Number
         zmenge1         TYPE string,         " Purchase Requisition Quantity
         zmenge2         TYPE string,         " Confirmed Quantity
         zmenge3         TYPE string,         " Confirmed Quantity
         eblstock        TYPE string,         " Confirmed Quantity
         zmenge4         TYPE string,         " Confirmed Quantity
         mat_txt         TYPE string,         " Purchase order Text
         werks           TYPE werks_d,        " Plant
         issueno         TYPE char7,          " Issue Number
         suplimentno     TYPE char7,          " Supplement Number
         office          TYPE lbtxt,          " Office
         productline     TYPE ktext,          " Product Line
         issn            TYPE ismidentcode,   " Identification Code
*BOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
         ntgew           TYPE string,          " Net Weight
*EOC : MIMMADISET : 11-Nov-2020 : ED2K920229: CR#OTCM-25581
       END OF ty_final,

       BEGIN OF ty_ord_qty,
         matnr  TYPE matnr,               " Material Number
         kwmeng TYPE kwmeng,              " Cumulative Order Quantity in Sales Units
       END OF ty_ord_qty,

       BEGIN OF ty_ismidcodetype,
         sign   TYPE char1,               " Sign of type CHAR1
         option TYPE char2,               " Option of type CHAR2
         low    TYPE ismidcodetype,       " Identification Code
         high   TYPE ismidcodetype,       " Identification Code
       END OF ty_ismidcodetype,

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

*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*

       tty_mara             TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
       tty_marc             TYPE STANDARD TABLE OF ty_marc INITIAL SIZE 0,
       tty_eord             TYPE STANDARD TABLE OF ty_eord INITIAL SIZE 0,
       tty_lfa1             TYPE STANDARD TABLE OF ty_lfa1 INITIAL SIZE 0,
       tty_plaf             TYPE STANDARD TABLE OF ty_plaf INITIAL SIZE 0,
       tty_jptidcdassign    TYPE STANDARD TABLE OF ty_jptidcdassign INITIAL SIZE 0,
       tty_zqtc_inven_recon TYPE STANDARD TABLE OF ty_zqtc_inven_recon INITIAL SIZE 0,
       tty_cepct            TYPE STANDARD TABLE OF ty_cepct INITIAL SIZE 0,
       tty_t024x            TYPE STANDARD TABLE OF ty_t024x INITIAL SIZE 0,
       tty_mver             TYPE STANDARD TABLE OF ty_mver INITIAL SIZE 0,
       tty_mvke             TYPE STANDARD TABLE OF ty_mvke INITIAL SIZE 0,
       tty_makt             TYPE STANDARD TABLE OF ty_makt INITIAL SIZE 0,
       tty_mapr             TYPE STANDARD TABLE OF ty_mapr INITIAL SIZE 0,
       tty_prop             TYPE STANDARD TABLE OF ty_prop INITIAL SIZE 0,
       tty_eban             TYPE STANDARD TABLE OF ty_eban INITIAL SIZE 0,
       tty_ekpo             TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
       tty_vbap             TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
       tty_vbep             TYPE STANDARD TABLE OF ty_vbep INITIAL SIZE 0,
       tty_prow_sum         TYPE STANDARD TABLE OF ty_prow_sum INITIAL SIZE 0,
       tty_ord_qty          TYPE STANDARD TABLE OF ty_ord_qty INITIAL SIZE 0,
       tty_vbak             TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0,
       tty_jksesched        TYPE STANDARD TABLE OF ty_jksesched INITIAL SIZE 0,
       tty_issue            TYPE STANDARD TABLE OF ty_issue INITIAL SIZE 0,
       tty_calc_tab         TYPE STANDARD TABLE OF ty_calc_tab INITIAL SIZE 0,
       tty_final            TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
       tty_vbap_orders      TYPE STANDARD TABLE OF ty_vbap_orders INITIAL SIZE 0.

*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA: i_mara               TYPE tty_mara,
      i_eord               TYPE tty_eord,
      i_lfa1               TYPE tty_lfa1,
      i_jptidcdassign      TYPE tty_jptidcdassign,
      i_jptidcdassign_wms  TYPE tty_jptidcdassign,
      i_zqtc_inven_recon   TYPE tty_zqtc_inven_recon,
      i_marc               TYPE tty_marc,
      i_t024x              TYPE tty_t024x,
      i_cepct              TYPE tty_cepct,
      i_mver               TYPE tty_mver,
      i_mvke               TYPE tty_mvke,
      i_makt               TYPE tty_makt,
      i_mapr               TYPE tty_mapr,
      i_prop               TYPE tty_prop,
      i_plaf               TYPE tty_plaf,
      i_eban               TYPE tty_eban,
      i_eban_zmenge1       TYPE tty_eban,
      i_ekpo               TYPE tty_ekpo,
      i_vbap               TYPE tty_vbap,
      i_vbak               TYPE tty_vbak,
      i_prow_sum           TYPE tty_prow_sum,
      i_ord_qty            TYPE tty_ord_qty,
      i_jksesched          TYPE tty_jksesched,
      i_jksesched_x        TYPE tty_jksesched,
      i_final              TYPE tty_final,
      i_vbap_orders        TYPE tty_vbap_orders,
      i_calc_tab           TYPE tty_calc_tab,
      i_issue              TYPE tty_issue,
      ir_ident_type        TYPE TABLE OF ty_ismidcodetype INITIAL SIZE 0,
      ir_ident_type_wms    TYPE TABLE OF ty_ismidcodetype INITIAL SIZE 0,
      ir_ident_type_wo_wms TYPE TABLE OF ty_ismidcodetype INITIAL SIZE 0,
      i_constant           TYPE STANDARD TABLE OF ty_constant       INITIAL SIZE 0.

DATA: v_year       TYPE char4, " Year of type CHAR4
      v_month      TYPE char2, " Month of type CHAR4
      v_date       TYPE char2, " Date of type CHAR4
      v_hour       TYPE char2, " Hour of type CHAR4
      v_min        TYPE char2, " Min of type CHAR4
      v_sec        TYPE char2, " Sec of type CHAR4
      v_adjtyp_jdr TYPE zadjtyp. " Adj. Type JDR

*&---------------------------------------------------------------------*
*&C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS: c_slash          TYPE char1      VALUE '/',                    " Slash of type CHAR1
           c_dash           TYPE char1      VALUE '-',
           c_extn_txt       TYPE char4      VALUE '.TXT',                 " Extn of type CHAR4
           c_flnm_wms       TYPE char3      VALUE 'WMS',                  " Part of Output File Name
           c_flnm_jdsr      TYPE char4      VALUE 'JDSR',                 " Part of Output File Name
           c_extn_dat       TYPE char4      VALUE '.dat',                 " Extn of type CHAR4 for DAT
           c_e              TYPE char1      VALUE 'E',                    " E of type CHAR1
           c_jtyp_iss       TYPE char3      VALUE 'ISS',                  " Supplement
           c_jtyp_supp      TYPE char4      VALUE 'SUPP',                 " Supplement
           c_char_blank     TYPE char1      VALUE '',                     " Blank Character
           c_char_dquote    TYPE char1      VALUE '"',                    " Quotes Character
           c_ident_code_wms TYPE rvari_vnam VALUE 'WMS',                  " ABAP: Name of Variant Variable
           c_ident_code     TYPE rvari_vnam VALUE 'INDENTIFICATION_CODE', " ABAP: Name of Variant Variable
* BOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
*           c_pbdate         TYPE i          VALUE '90'.                   " Pbdate of type Integers
           c_char_s         TYPE char1     VALUE 'S'.
*           c_shpdate        TYPE i         VALUE '90'.                   " Ship. date of type Integers "ED1K907394-
* EOC : PBANDLAPAL : 16-Aug-2017 : ED2K907999: CR#619
