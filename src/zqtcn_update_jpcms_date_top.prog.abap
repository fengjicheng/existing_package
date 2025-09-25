*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCR_UPDATE_JPCMS_DATE_MATMAS (Report)
* PROGRAM DESCRIPTION: Report to update JPCMS date in material master
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE: 22/12/2016
* OBJECT ID: E145
* TRANSPORT NUMBER(S): ED2K903846
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906306
* REFERENCE NO: ERP-2217
* DEVELOPER: Writtick Roy
* DATE:  2017-05-22
* DESCRIPTION: Swap the population logic of Material Availability Date
*              (MARC-ISMAVAILDATE) and Planned Goods Arrival Date
*              (MARC-ISMARRIVALDATEPL)
*              Add Z01 as Default Movement Type (along with 101)
*----------------------------------------------------------------------*
* REVISION NO: ED2K910759
* REFERENCE NO: ERP-6470
* DEVELOPER: Writtick ROY (WROY)
* DATE:  2018-02-08
* DESCRIPTION: Add Manual Execution Option with checkboxes to choose
*              individual Date fields.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_UPDATE_JPCMS_DATE_TOP
*&---------------------------------------------------------------------*
TABLES:
  nast,
  ekko,
  ekpo,
  ekbe.

* Global type declaration
TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ebeln,      " Purchasing Document Number
         bsart TYPE esart,      " Purchasing Document Type
       END OF ty_ekko,
       tt_ekko TYPE STANDARD TABLE OF ty_ekko,

       BEGIN OF ty_nast,
         objky     TYPE na_objkey,  " Object key
         kschl     TYPE sna_kschl,  " Message type
         erdat     TYPE na_erdat,   " Date on which status record was created
         eruhr     TYPE na_eruhr,   " Time at which status record was created
         vstat     TYPE na_vstat,   " Processing status of message
         objky_tmp TYPE char10,      " Object key temp
       END OF ty_nast,
       tt_nast TYPE STANDARD TABLE OF ty_nast,

       BEGIN OF ty_ekpo,
         ebeln TYPE ebeln,      " Purchasing Document Number
         ebelp TYPE ebelp,      " Item Number of Purchasing Document
         matnr TYPE matnr,      " Material Number
         werks TYPE ewerk,      " Plant
         menge TYPE bstmg,      " Purchase Order Quantity
       END OF ty_ekpo,
       tt_ekpo TYPE STANDARD TABLE OF ty_ekpo,

       BEGIN OF ty_ekpo_dis,
         ebeln TYPE ebeln,      " Purchasing Document Number
         ebelp TYPE ebelp,      " Item Number of Purchasing Document
         matnr TYPE matnr,      " Material Number
         werks TYPE ewerk,      " Plant
       END OF ty_ekpo_dis,
       tt_ekpo_dis TYPE STANDARD TABLE OF ty_ekpo_dis,

       BEGIN OF ty_marc,
         matnr            TYPE matnr,       " Material Number
         werks            TYPE werks_d,      " Plant
         basmg            TYPE basmg,       " Base quantity
         vbamg            TYPE vbamg,       " Base quantity for capacity planning in shipping
         ismavaildate     TYPE mbdat,       " Material Staging/Availability Date
         ismarrivaldatepl TYPE ismanlftags, " Planned Goods Arrival Date " Planned Goods Arrival Date
         ismarrivaldateac TYPE ismanlftagi, " Actual Goods Arrival Date " Actual Goods Arrival Date
       END OF ty_marc,
       tt_marc TYPE STANDARD TABLE OF ty_marc,

       BEGIN OF ty_final_tab,
         ebeln TYPE ebeln,      " Purchasing Document Number
         ebelp TYPE ebelp,      " Item Number of Purchasing Document
         matnr TYPE matnr,      " Material Number
         werks TYPE ewerk,      " Plant
         menge TYPE bstmg,      " Purchase Order Quantity
         cpudt TYPE cpudt,      " Day On Which Accounting Document Was Entered
       END OF ty_final_tab,

       BEGIN OF ty_ekbe,
         ebeln TYPE ebeln,                  " Purchasing Document Number
         ebelp TYPE ebelp,                  " Item Number of Purchasing Document
         cpudt TYPE cpudt,                  " Day On Which Accounting Document Was Entered
         cputm TYPE cputm,                  " Time of Entry
         matnr TYPE matnr,                  " Material Number
         werks TYPE werks_d,                " Plant
       END OF ty_ekbe,
       tt_ekbe TYPE STANDARD TABLE OF ty_ekbe,

       BEGIN OF ty_display,
*        Begin of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
*        ebeln   TYPE ebeln,                " Purchasing Document Number
*        ebelp   TYPE ebelp,                " Item Number of Purchasing Document
*        End   of DEL:ERP-6470:WROY:07-Feb-2018:ED2K910759
         matnr   TYPE matnr,                " Material Number
         werks   TYPE werks_d,              " Plant
         message TYPE char120,              " Log Message
         avldt   TYPE char1,
         arvdtpl TYPE char1,
         arvdtac TYPE char1,
       END OF ty_display,

       BEGIN OF ty_retmsg,
         material TYPE matnr,              " Material Number
*        Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
         plant    TYPE werks_d,            " Plant
*        End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
         message  TYPE bapi_msg,           " Return Message
         avldt    TYPE char1,              " Available date
         arvdtpl  TYPE char1,              " Planned Arrival Date
         arvdtac  TYPE char1,              " Actual Arrival Date
       END OF ty_retmsg.

*Global internal table declaration
DATA: i_ekko      TYPE STANDARD TABLE OF ty_ekko      INITIAL SIZE 0,
      i_nast      TYPE STANDARD TABLE OF ty_nast      INITIAL SIZE 0,
      i_ekpo      TYPE STANDARD TABLE OF ty_ekpo      INITIAL SIZE 0,
      i_ekpo_dis  TYPE STANDARD TABLE OF ty_ekpo_dis  INITIAL SIZE 0,
      i_marc      TYPE STANDARD TABLE OF ty_marc      INITIAL SIZE 0,
      i_ekbe      TYPE STANDARD TABLE OF ty_ekbe      INITIAL SIZE 0,
      i_final_tab TYPE STANDARD TABLE OF ty_final_tab INITIAL SIZE 0,
      i_display   TYPE STANDARD TABLE OF ty_display   INITIAL SIZE 0,
      i_retdata   TYPE STANDARD TABLE OF bapiret2     INITIAL SIZE 0,
      i_retmsg    TYPE STANDARD TABLE OF ty_retmsg    INITIAL SIZE 0.

*Global variables declaration
DATA: v_curr_date TYPE sydatum,           "Current/To Date
      v_curr_time TYPE syuzeit,           "Current/To Time
      v_from_date TYPE sydatum,           "From Date
      v_from_time TYPE syuzeit.           "From Time

*Global constants declaration
CONSTANTS: c_devid_e145 TYPE zdevid    VALUE 'E145',     "Development ID: E145
*          Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
           c_sign_incld TYPE ddsign    VALUE 'I',        "Sign: (I)nclude
           c_opti_equal TYPE ddoption  VALUE 'EQ',       "Option: (EQ)ual
*          End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
           c_msgty_info TYPE symsgty   VALUE 'I'.        "Message Type: Information
