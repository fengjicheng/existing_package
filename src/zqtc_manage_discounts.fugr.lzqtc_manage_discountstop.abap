*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_MANAGE_DISCOUNTSTOP (Global Data Declarations)
* PROGRAM DESCRIPTION: Determine most suitable Soceity
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07-FEB-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905792
* REFERENCE NO:  CR#490
* DEVELOPER: Writtick Roy (WROY)
* DATE:  22-MAY-2017
* DESCRIPTION: Whenever Relationship Category = ZPR003, ZPR004, ZPR005,
*              ZPR006 or ZPR010, look for condition records with
*              Relationship Category = ZPR008
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907861
* REFERENCE NO: ERP-4105
* DEVELOPER: Writtick Roy (WROY)
* DATE:  10-AUG-2017
* DESCRIPTION: Implement SAP's recommendations
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909707
* REFERENCE NO: ERP-5406
* DEVELOPER: Writtick Roy (WROY)
* DATE:  04-DEC-2017
* DESCRIPTION: Fix the logic to identify the last BOM Item
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_manage_discounts.             "MESSAGE-ID ..

* INCLUDE LZQTC_MANAGE_DISCOUNTSD...                  "Local class definition

INCLUDE zqtcn_arithmetic_operators IF FOUND.

TYPES:
  BEGIN OF ty_soc_nprc,
    partner2  TYPE bu_partner,                        "Business Partner Number
    reltyp    TYPE bu_reltyp,                         "Business Partner Relationship Category
    net_price TYPE kbetr,                             "Net Price
*   Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
    reltyp_o  TYPE bu_reltyp,                         "Business Partner Relationship Category
*   End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
  END OF ty_soc_nprc,
  tt_soc_nprc TYPE STANDARD TABLE OF ty_soc_nprc INITIAL SIZE 0,

* Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  BEGIN OF ty_cond_str,
    kvewe     TYPE kvewe,                             "Usage of the condition table
    kotabnr   TYPE kotabnr,                           "Condition table
    kappl     TYPE kappl,                             "Application
    kotab     TYPE kotab,                             "Condition table
    setyp     TYPE setyp,                             "Fast entry type for condition tables
    fsetyp    TYPE fsetyp,                            "Type of field in fast entry
    fselnr    TYPE fselnr,                            "Sequential number of the fast entry field
    sefeld    TYPE sefeld,                            "Fast entry field (internal field name)
    del_recrd TYPE flag,                              "Flag: Deletion
  END OF ty_cond_str,
  tt_cond_str TYPE STANDARD TABLE OF ty_cond_str INITIAL SIZE 0,
* End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861

* Begin of ADD:ERP-5406:WROY:04-DEC-2017:ED2K909707
  BEGIN OF ty_stpo_det.
        INCLUDE STRUCTURE stpo.
TYPES:
  stlal	TYPE stalt,                                   "Alternative BOM
  END OF ty_stpo_det,
  tt_stpo_det TYPE STANDARD TABLE OF ty_stpo_det INITIAL SIZE 0,
* End   of ADD:ERP-5406:WROY:04-DEC-2017:ED2K909707

* Begin of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
  tt_t682ia   TYPE STANDARD TABLE OF t682ia      INITIAL SIZE 0,  "Conditions: Access Sequences (Generated Form)
* End   of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134

  BEGIN OF ty_sp_relat,
    kunwe     TYPE kunwe,                             "Ship-to party
    relations TYPE but050_tty,                        "BP relationships/role definitions: General data
  END OF ty_sp_relat,
  tt_sp_relat TYPE SORTED TABLE OF ty_sp_relat   INITIAL SIZE 0
              WITH UNIQUE KEY kunwe.

DATA:
  i_constants TYPE zcat_constants,
* Begin of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
* i_stpo_detl TYPE stpo_tab,
* End   of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  i_stpo_detl TYPE tt_stpo_det,
  i_stpo_sort TYPE tt_stpo_det,
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
  i_t681e     TYPE tt_cond_str,
* End   of ADD:SAP's Recommendations:WROY:10-AUG-2017:ED2K907861
* Begin of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
  i_t682ia    TYPE tt_t682ia,                         "Conditions: Access Sequences (Generated Form)
* End   of ADD:SAP's Recommendations:WROY:23-OCT-2017:ED2K909134
  i_sp_relats TYPE tt_sp_relat,
* Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
  i_tkomp     TYPE va_komp_t.                         "Communication Item for Pricing
* End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494

CONSTANTS:
  c_app_sales TYPE kappl      VALUE 'V',              "Application: Sales
  c_kvewe_a   TYPE kvewe      VALUE 'A',              "Usage of the condition table
  c_fld_rltyp TYPE sefeld     VALUE 'ZZRELTYP*',      "Fieldname: Business Partner Relationship Category
  c_fld_prtnr TYPE sefeld     VALUE 'ZZPARTNER2*',    "Fieldname: Business Partner 2 or Society number
  c_devid_075 TYPE zdevid     VALUE 'E075',           "Development ID
  c_param_prc TYPE rvari_vnam VALUE 'PRICE',          "ABAP: Name of Variant Variable
  c_param_dsc TYPE rvari_vnam VALUE 'DISCOUNT',       "ABAP: Name of Variant Variable
* Begin of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
  c_param_rlc TYPE rvari_vnam VALUE 'REL_CATEGORY',   "ABAP: Name of Variant Variable
* End   of ADD:CR 490:WROY:22-MAY-2017:ED2K905792
  c_sign_i    TYPE ddsign     VALUE 'I',              "Sign: (I)nclude
  c_opti_cp   TYPE ddoption   VALUE 'CP',             "OIption: (C)ontans (P)attern
  c_krech_prc TYPE krech      VALUE 'A',              "Calculation type for condition: Percentage
  c_krech_qty TYPE krech      VALUE 'C',              "Calculation type for condition: Quantity
  c_calc_per  TYPE char1      VALUE 'P',              "Calculation Type: Percentage
  c_calc_amt  TYPE char1      VALUE 'A'.              "Calculation Type: Amount
