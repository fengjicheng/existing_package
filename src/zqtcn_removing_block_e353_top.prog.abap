*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DELIVERYBLOCK_MANUAL_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_MANUAL                             *
* PROGRAM DESCRIPTION: The orders which are Blocked Manually after 3   *
*                     or more dunning letters sent to customers using  *
*                     T-code ZQTC_UNPAID_ORDERS, for these blocked     *
*                     orders, once the customer paid fully system      *
*                     should remove the block automatically without    *
*                     manual intervention                              *
* DEVELOPER      : VDPATABALL                                          *
* CREATION DATE  : 03/10/2022                                          *
* OBJECT ID      : OTCM-57357 / E353                                                    *
* TRANSPORT NUMBER(S):ED2K926054                                       *
*----------------------------------------------------------------------*
TYPES:BEGIN OF ty_final,
        vbelv TYPE vbeln_von,   "Order Number
        vbeln TYPE vbeln_nach,  "Invoice Number
        augbl TYPE augbl,       "Document Number of the Clearing Document
        type  TYPE bapi_mtype,  "Message type: S Success, E Error, W Warning, I Info, A Abort
        msg   TYPE bapi_msg,    "Message Text
      END OF ty_final.

DATA:i_final TYPE STANDARD TABLE OF ty_final.

CONSTANTS:c_i  TYPE char1 VALUE 'I',  " I Info
          c_s  TYPE char1 VALUE 'S',  " S Success
          c_e  TYPE char1 VALUE 'E',  "E Error
          c_d  TYPE koart VALUE 'D',  "Account Type - Customers
          c_u  TYPE char1 VALUE 'U',  "Update Action
          c_a  TYPE char1 VALUE 'A',  "A Abort
          c_m  TYPE char1 VALUE 'M',  " Invoice Type
          c_01 TYPE bschl VALUE '01'. "Posting Key - Invoice
