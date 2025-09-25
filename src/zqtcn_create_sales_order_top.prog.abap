*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_CREATE_SALES_ORDER_TOP
* PROGRAM DESCRIPTION: Creating sales order with reference to billing document,
* This Report has been called from report ZQTCE_SALES_REP_CHG in background mode.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2016-12-05
* TRANSPORT NUMBER(S): ED2K903519
* OBJECT ID: E131
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREATE_SALES_ORDER_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_vbrk ,
          vbeln TYPE vbeln_vf,                                    " Billing Document
          vkorg TYPE vkorg,                                       " Sales Organization
          vtweg TYPE vtweg,                                       " Distribution Channel
          kunag TYPE kunag,                                       " Sold-to party
          spart TYPE  spart,                                      " Division
*         Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
          knumv TYPE knumv,                                       " Number of the document condition
*         End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
        END OF ty_vbrk,

        BEGIN OF ty_vbpa,
          vbeln TYPE vbeln,                                       " Sales and Distribution Document Number
          posnr TYPE posnr,                                       " Item number of the SD document
          parvw TYPE parvw,                                       " Partner Function
          kunnr	TYPE kunnr,
          pernr TYPE pernr_d,                                     " Personnel Number
        END OF ty_vbpa,

        BEGIN OF ty_vbfa,
          vbelv	  TYPE vbeln_von,                                 " Preceding sales and distribution document
          posnv	  TYPE posnr_von,                                 " Preceding item of an SD document
          vbeln	  TYPE vbeln_nach,                                " Subsequent sales and distribution document
          posnn	  TYPE posnr_nach,                                " Subsequent item of an SD document
          vbtyp_n TYPE vbtyp_n,                                   " Document category of subsequent document
        END OF ty_vbfa,

*       Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
        BEGIN OF ty_konv,
          knumv TYPE knumv,                                       " Number of the document condition
          kposn TYPE kposn,                                       " Condition item number
          stunr TYPE stunr,                                       " Step number
          zaehk TYPE dzaehk,                                      " Condition counter
          kschl TYPE kscha,                                       " Condition type
          kawrt TYPE kawrt,                                       " Condition base value
          kbetr TYPE kbetr,                                       " Rate (condition amount or percentage)
          waers TYPE waers,                                       " Currency Key
          kpein TYPE kpein,                                       " Condition pricing unit
          kmein TYPE kvmei,                                       " Condition unit in the document
          kwert TYPE kwert,                                       " Condition value
        END OF ty_konv,
*       End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183

        BEGIN OF ty_input,
          vbeln  TYPE vbeln_vf,                                   " Billing Document
          posnr  TYPE posnr,                                      " Item number of the SD document
          nsrep1 TYPE epernr,                                     " Personnel Number
          nsrep2 TYPE epernr,                                     " Personnel Number
        END OF ty_input,

        BEGIN OF ty_alv,
          vbeln   TYPE vbeln_vf,                                  " Billing Document
          posnr   TYPE posnr,                                     " Item number of the SD document
          auart   TYPE auart,                                     " Sales Document Type
          type    TYPE bapi_mtype,
          id      TYPE symsgid,                                   " Message Class
          number  TYPE symsgno,                                   " Message Number
          message TYPE bapi_msg,                                  " Message Text
        END OF ty_alv,

        BEGIN OF ty_constant,
          devid  TYPE zdevid,                                     " Development ID
          param1 TYPE rvari_vnam,                                 " ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                 " ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                 " ABAP: Current selection number
          sign   TYPE tvarv_sign,                                 " ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                 " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                         " Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                        " Upper Value of Selection Condition
        END OF ty_constant,

        tt_webinvoiceitems TYPE STANDARD TABLE OF bapiwebinvitem, " Item Data for Web Billing Documents
        tt_alv             TYPE STANDARD TABLE OF ty_alv,
        tt_return          TYPE STANDARD TABLE OF bapiret2,       " Return Parameter
        tt_order_items_in  TYPE STANDARD TABLE OF bapisditm,      " Communication Fields: Sales and Distribution Document Item
        tt_order_items_inx TYPE STANDARD TABLE OF bapisditmx,     " Communication Fields: Sales and Distribution Document Item
*       Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
        tt_conditions_in   TYPE STANDARD TABLE OF bapicond,
        tt_conditions_inx  TYPE STANDARD TABLE OF bapicondx.
*       End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183

*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA : i_input    TYPE STANDARD TABLE OF ty_input INITIAL SIZE 0,
       i_alv      TYPE STANDARD TABLE OF ty_alv INITIAL SIZE 0,
       i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
       i_fcat     TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
       i_vbpa     TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0,
       i_vbfa     TYPE STANDARD TABLE OF ty_vbfa INITIAL SIZE 0,
*      Begin of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
       i_konv     TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0,
*      End   of ADD:INC0205683:WROY:13-AUG-2018:ED1K908183
       i_vbrk     TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0.

*&--------------------------------------------------------------------*
*& V A R I A B L E
*&-------------------------------------------------------------------
DATA : v_input TYPE char32. " Input of type CHAR30
