*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_INIT_SHP_DATE_CHG
* PROGRAM DESCRIPTION: Include for global types and data declaration
* DEVELOPER: Writtick Roy/Monalisa Dutta
* CREATION DATE:   2017-01-11
* OBJECT ID: E147
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INIT_SHP_DATE_CHG_TOP
*&---------------------------------------------------------------------*

*Global Table declaration
TABLES:
  mara.

*Global Types declaration
TYPES:
  BEGIN OF ty_med_issue,
    objectid      TYPE cdobjectv,                        "Object value
    issue_status  TYPE mstae,                            "Media Issue Status
    media_prod    TYPE ismrefmdprod,                     "Higher-Level Media Product
    ship_date     TYPE ismerstverdat,                    "Initial Shipping Date
    media_issue   TYPE ismmatnr_issue,                   "Media Issue
    order_date    TYPE jgen_start_date,                  "Order Creation date from
    delivery_date TYPE jshipping_date,                   "Delivery Date
    latest_po     TYPE ismpurchase_date_pl,              "Latest PO date
    message       TYPE char200,                          "Message Text
    status        TYPE char1,                            "Status: '1' = red/error, '3' = green/success
    del_flag      TYPE flag,                             "Flag: to delete record
  END OF ty_med_issue,
  tt_med_issue TYPE STANDARD TABLE OF ty_med_issue INITIAL SIZE 0.

*Global constant declaration
CONSTANTS:
  c_sign_incld TYPE ddsign         VALUE 'I',               "Sign: (I)nclude
  c_opti_equal TYPE ddoption       VALUE 'EQ',              "Option: (EQ)ual
  c_opti_betwn TYPE ddoption       VALUE 'BT',

  c_mtart_zjip TYPE mtart          VALUE 'ZJIP',            "Material Type: ZJIP
  c_mtart_zjid TYPE mtart          VALUE 'ZJID',            "Material Type: ZJID

  c_mstae_n    TYPE mstae          VALUE 'N',               "X-Plant Status: N (Not Yet Published)
  c_mstae_p    TYPE mstae          VALUE 'P',               "X-Plant Status: P (Current Issue)

  c_chngind_u  TYPE cdchngind      VALUE 'U',               "Change Type - Update
  c_objcl_mat  TYPE cdobjectcl     VALUE 'MATERIAL',        "Object class: MATERIAL
  c_table_mara TYPE tabname        VALUE 'MARA',            "Table Name: MARA
  c_fn_shp_dt  TYPE fieldname      VALUE 'ISMINITSHIPDATE', "Field Name: ISMINITSHIPDATE

  c_devid_e147 TYPE zdevid         VALUE 'E147',            "Development ID: E147
  c_issue_temp TYPE matnr          VALUE '%_TEMP%',         "Pattern: Issue Template
  c_lvl_med_i  TYPE ismhierarchlvl VALUE '3',               "Hierarchy Level (Media Issue)

  c_status_suc TYPE char1          VALUE '3',               "Status: Green/Success
  c_status_err TYPE char1          VALUE '1',               "Status: Red/Error

  c_semi_colon TYPE char1          VALUE ';',               "Separator: Semi Colon

  c_msgty_info TYPE symsgty        VALUE 'I'.               "Message Type: Information
