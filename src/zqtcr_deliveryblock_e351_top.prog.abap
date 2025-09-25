*&---------------------------------------------------------------------*
*&  Include           ZQTCR_DELIVERYBLOCK_E351_TOP
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_SALES_E351                         *
* PROGRAM DESCRIPTION: The functionality of the program is to confirm  *
*       if the payment confirmation has been successfully received from*
*       bank or not. If there is some issue with the payment clearance *
*       then for the ZSUB/ZREW order, the delivery block will be       *
*       updated to 66-Return Direct Debit from DD -Direct Debits Order.*
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 02/09/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S):  ED2K925720                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  TYPES DECLARATION
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_display,
         invoice     TYPE vbrk-vbeln,
         invcreate   TYPE vbrk-erdat,
         document    TYPE vbak-vbeln,
         doctype     TYPE vbak-auart,
         devblock    TYPE vbak-lifsk,
         paymethod   TYPE vbkd-zlsch,
         status      TYPE char100,
       END OF ty_display.
*&---------------------------------------------------------------------*
*&  RANGE TABLES DECLARATION
*&---------------------------------------------------------------------*
DATA: ir_bukrs TYPE RANGE OF bukrs,
      ir_auart TYPE RANGE OF auart,
      ir_vkorg TYPE RANGE OF vkorg,
      ir_zlsch TYPE RANGE OF vbkd-zlsch,
      ir_agzei TYPE RANGE OF agzei,
      ir_vbtyp TYPE RANGE OF vbtyp,
      ir_tcode TYPE RANGE OF tcode.
*&---------------------------------------------------------------------*
*  Work Area & Variable Declaration
*&---------------------------------------------------------------------*
DATA: v_bukrs LIKE LINE OF ir_bukrs,
      v_auart LIKE LINE OF ir_auart,
      v_vkorg LIKE LINE OF ir_vkorg,
      v_zlsch LIKE LINE OF ir_zlsch,
      v_tcode LIKE LINE OF ir_tcode,
      v_vbtyp LIKE LINE OF ir_vbtyp,
      v_agzei LIKE LINE OF ir_agzei,
      v_checkdays TYPE char2,
      v_ddupdate  TYPE vbak-lifsk,
      v_lastrundate  TYPE zcainterface-lrdat,
      v_datediff  TYPE p,
      v_date1     TYPE d,
      v_date2     TYPE d,
      v_time      TYPE t,
      v_lifsk     TYPE vbak-lifsk.
*&---------------------------------------------------------------------*
*& CONSTANTS DECLARATION
*&---------------------------------------------------------------------*
CONSTANTS:  c_update    TYPE c LENGTH 1 VALUE 'U',
            c_agzei     TYPE c LENGTH 5 VALUE 'AGZEI',
            c_auart     TYPE c LENGTH 5 VALUE 'AUART',
            c_bukrs     TYPE c LENGTH 5 VALUE 'BUKRS',
            c_checkdays TYPE c LENGTH 9 VALUE 'CHECKDAYS',
            c_tcode     TYPE c LENGTH 5 VALUE 'TCODE',
            c_vbtyp     TYPE c LENGTH 5 VALUE 'VBTYP',
            c_vkorg     TYPE c LENGTH 5 VALUE 'VKORG',
            c_zlsch     TYPE c LENGTH 5 VALUE 'ZLSCH',
            c_lifsk     TYPE c LENGTH 5 VALUE 'LIFSK',
            c_ddupdate  TYPE c LENGTH 8 VALUE 'DDUPDATE',
            c_devid     TYPE c LENGTH 4 VALUE 'E351',
            c_runtime   TYPE rvari_vnam VALUE 'LAST RUNDATE'.

*&---------------------------------------------------------------------*
*& Internal table DECLARATION
*&---------------------------------------------------------------------*
DATA: i_display TYPE STANDARD TABLE OF ty_display,
      st_display TYPE ty_display,
      st_zcainterface TYPE zcainterface,
      v_alv     TYPE REF TO cl_salv_table,
      v_func    TYPE REF TO cl_salv_functions.


*&---------------------------------------------------------------------*
*& Free Internal tables and Clear variables.
*&---------------------------------------------------------------------*
FREE: ir_bukrs,
      ir_auart,
      ir_vkorg,
      ir_zlsch,
      ir_agzei,
      ir_vbtyp,
      ir_tcode.

CLEAR: v_bukrs,
       v_auart,
       v_vkorg,
       v_zlsch,
       v_tcode,
       v_vbtyp,
       v_checkdays.
