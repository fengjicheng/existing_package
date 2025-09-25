*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CUST_ACC_GRP_CONV_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CUST_ACC_GRP_CONV_TOP (Include)
* PROGRAM DESCRIPTION: Global Data Declaration
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08/30/2016
* OBJECT ID: C061
* TRANSPORT NUMBER(S): ED2K902790
*----------------------------------------------------------------------*
TABLES:
  kna1.                                                    "General Data in Customer Master


TYPES:
  BEGIN OF ty_customer,
    kunnr     TYPE kunnr,                                  "Customer Number
    stats_ind TYPE char1,                                  "Status Indicator
    stats_msg TYPE char200,                                "Status Message
  END OF ty_customer,
  tt_customer TYPE STANDARD TABLE OF ty_customer INITIAL SIZE 0,

  BEGIN OF ty_bp_roles,
    bus_prtnr TYPE bu_partner,                             "Business Partner Number
    rltyp	    TYPE bu_partnerrole,                         "BP Role
    dfval	    TYPE bu_dfval,                               "BP: Differentiation type value
  END OF ty_bp_roles,
  tt_bp_roles TYPE STANDARD TABLE OF ty_bp_roles INITIAL SIZE 0.

DATA:
  i_customers TYPE tt_customer.                   "Customer Numbers

CONSTANTS:
  c_stats_suc TYPE char1       VALUE '3',                  "Status Indicator-Success
  c_stats_err TYPE char1       VALUE '1',                  "Status Indicator-Error
  c_msgty_a   TYPE symsgty     VALUE 'A',                  "Message Type: A
  c_msgty_e   TYPE symsgty     VALUE 'E'.                  "Message Type: E
