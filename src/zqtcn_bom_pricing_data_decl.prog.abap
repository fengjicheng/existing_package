*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_DATA_DECL (Include)
* PROGRAM DESCRIPTION: Recalculate Price for BOM
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08-AUG-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K905792
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910130
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08-JAN-2018
* DESCRIPTION: Avoid multiple calls for Pricing fields determination
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
* Business Partner 2 or Society number / BP Relationship Category (Buffer)
TYPES:
  BEGIN OF ty_pr_rel,
    posnr   TYPE posnr_va,                  "Sales Document Item
    pr_zlpr TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_zlpr TYPE bu_reltyp,                 "Business Partner Relationship Category
    pr_zlps TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_zlps TYPE bu_reltyp,                 "Business Partner Relationship Category
    pr_zsd1 TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_zsd1 TYPE bu_reltyp,                 "Business Partner Relationship Category
    pr_zsd2 TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_zsd2 TYPE bu_reltyp,                 "Business Partner Relationship Category
    pr_znd1 TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_znd1 TYPE bu_reltyp,                 "Business Partner Relationship Category
    pr_zmys TYPE zzpartner2,                "Business Partner 2 or Society number
    rt_zmys TYPE bu_reltyp,                 "Business Partner Relationship Category
    rt_orgn TYPE bu_reltyp,                 "Business Partner Relationship Category
  END   OF ty_pr_rel,
  tt_pr_rel TYPE SORTED TABLE OF ty_pr_rel INITIAL SIZE 0
            WITH UNIQUE KEY posnr.

DATA:
  i_prt_rel TYPE tt_pr_rel.                 "Business Partner 2 or Society number / BP Relationship Category (Buffer)
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130

DATA:
  st_tvcpa  TYPE tvcpa.                     "Sales Documents: Copying Control
