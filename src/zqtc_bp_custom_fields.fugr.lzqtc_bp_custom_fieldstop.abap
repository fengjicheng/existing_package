*----------------------------------------------------------------------*
* PROGRAM NAME: MZQTC_BP_CUSTOM_FIELDS_TOP (Global data declarations)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_bp_custom_fields.        "MESSAGE-ID ..

* INCLUDE LZQTC_BP_CUSTOM_FIELDSD...         " Local class definition

TABLES:
  knvv.                                         "Customer Master Sales Data

DATA:
  st_kna1    TYPE kna1,                         "General Data in Customer Master

  st_tspat   TYPE tspat,                        "Organizational Unit: Sales Divisions: Texts
  st_tvkot   TYPE tvkot,                        "Organizational Unit: Sales Organizations: Texts
  st_tvtwt   TYPE tvtwt,                        "Organizational Unit: Distribution Channels: Texts

  v_activity TYPE aktyp,                        "Activity category in SAP transaction
  v_cntrl_bp TYPE flag.                         "Flag: COntrol from BP Transaction

CONSTANTS:
  c_display  TYPE aktyp           VALUE 'A',    "Activity category: Display
  c_tab_knvv TYPE fsbp_table_name VALUE 'KNVV', "Table Name: KNVV

  c_fgr_0601 TYPE bu_fldgr        VALUE '601',
  c_fst_opti TYPE bu_fldstat      VALUE '.',
  c_fst_disp TYPE bu_fldstat      VALUE '*',
  c_fst_supp TYPE bu_fldstat      VALUE '-'.
