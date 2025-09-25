*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDIT_ISSUE_SEQUENCE_TOP
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
TABLES:
  mara,
  jksenip.

TYPES:
  BEGIN OF ty_med_issue,
    media_prod TYPE ismrefmdprod,                     "Higher-Level Media Product
    objectid   TYPE cdobjectv,                        "Object value
    change_ind TYPE cdchngind,                        "Change Type (U, I, S, D)
    message    TYPE char100,                          "Message Text
    status     TYPE char1,                            "Status: '1' = red/error, '3' = green/success
    del_flag   TYPE flag,                             "Flag: to delete record
  END OF ty_med_issue,
  tt_med_issue TYPE STANDARD TABLE OF ty_med_issue INITIAL SIZE 0.

CONSTANTS:
  c_sign_incld TYPE ddsign          VALUE 'I',        "Sign: (I)nclude
  c_opti_equal TYPE ddoption        VALUE 'EQ',       "Option: (EQ)ual
  c_opti_betwn TYPE ddoption        VALUE 'BT',       "Option: (B)e(T)ween

  c_mtart_zjip TYPE mtart           VALUE 'ZJIP',     "Material Type: ZJIP
  c_mtart_zjid TYPE mtart           VALUE 'ZJID',     "Material Type: ZJID

  c_mstae_p    TYPE mstae           VALUE 'P',        "X-Plant Status: P (Current Publication)
  c_mstae_n    TYPE mstae           VALUE 'N',        "X-Plant Status: N (Not yet published)

  c_iv_typ_02  TYPE ismausgvartyppl VALUE '02',       "Issue Variant Type - Standard (Exclude)

  c_shp_st_00  TYPE jnipstatus      VALUE '00',       "Status of Shipping Schedule Record (Initial)
  c_shp_st_01  TYPE jnipstatus      VALUE '01',       "Status of Shipping Schedule Record (Planned)

  c_status_suc TYPE char1           VALUE '3',        "Status: Green/Success
  c_status_err TYPE char1           VALUE '1',        "Status: Red/Error

  c_msgty_info TYPE symsgty         VALUE 'I',        "Message Type: Information

  c_fn_mat_key TYPE fieldname       VALUE 'KEY',      "Field Name: KEY
  c_fn_xp_stat TYPE fieldname       VALUE 'MSTAE',    "Field Name: MSTAE
  c_objcl_mat  TYPE cdobjectcl      VALUE 'MATERIAL', "Object class: MATERIAL
  c_table_mara TYPE tabname         VALUE 'MARA',     "Table Name: MARA

  c_devid_c039 TYPE zdevid          VALUE 'C039'.     "Development ID: C039
