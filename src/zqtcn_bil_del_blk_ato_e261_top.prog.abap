*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BIL_DEL_BLK_ATO_E261_TOP.
*&---------------------------------------------------------------------*
*& PROGRAM NAME: ZQTCE_BILL_DELV_BLK_AUTO
*& PROGRAM DESCRIPTION: As a CSR, I need the system to automatically
*&                      release DG billing and delivery blocks on
*&                      existing orders/subs when the DG block is
*&                      removed from the customer in order to service
*&                      our customer quicker
*& DEVELOPER: AMOHAMMED
*& CREATION DATE: 11/24/2020
*& OBJECT ID: E261
*& TRANSPORT NUMBER(S): ED2K920450
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:  ED2K926799
*& REFERENCE NO: OTCM-55825
*& DEVELOPER:    Nikhilesh Palla (NPALLA)
*& DATE:         12-Apr-2022
*& DESCRIPTION:  Change "No.of days old order" field from 2 to 3 digits
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:
*& REFERENCE NO:
*& DEVELOPER:
*& DATE:
*& DESCRIPTION:
*&---------------------------------------------------------------------*

*&-------------------------GLOBAL WORKAREAS----------------------------*
TABLES : vbak.

*&----------------------------CONSTANTS--------------------------------*
CONSTANTS : c_90(2)  TYPE n        VALUE '90',     " No.of old days
            c_eq     TYPE ddoption VALUE 'EQ',     " Equal to
            c_i      TYPE ddsign   VALUE 'I',      " Informative message type
            c_header TYPE posnr    VALUE '000000', " Header record
            c_we     TYPE parvw    VALUE 'WE',     " Ship-to party
            c_ag     TYPE parvw    VALUE 'AG',     " Sold-to party
            c_e      TYPE c        VALUE 'E',      " Error message type
            c_s      TYPE c        VALUE 'S'.      " Success message type

*&------------------------------TYPES----------------------------------*
TYPES : BEGIN OF ty_output,
          vbeln       TYPE vbeln_va, " Sales Document
          msg_type(1) TYPE c,        " Message type
          msg(200)    TYPE c,        " Message
        END OF ty_output.

*&------------------------DATA DECLARATIONS----------------------------*
DATA : i_output TYPE TABLE OF ty_output,  " Output internal table
       i_fcat   TYPE slis_t_fieldcat_alv, " Field catalog internal table
       i_lifsk  TYPE TABLE OF bapidlv_range_lifsk, " BAPI Selection Structure: Delivery Document Block Doc.Header
       i_faksk  TYPE TABLE OF bapidlv_range_lifsk. " BAPI Selection Structure: Billing Document Block

*&----------------------------Vaiables--------------------------------*
*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
DATA: v_old_days(3) TYPE n.                  "++ED2K926799
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
