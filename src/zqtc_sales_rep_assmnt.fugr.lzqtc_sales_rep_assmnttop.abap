FUNCTION-POOL zqtc_sales_rep_assmnt.        "MESSAGE-ID ..

* INCLUDE LZQTC_SALES_REP_ASSMNTD...         " Local class definition

TYPES:
  BEGIN OF ty_zqtc_repdet,
    vkorg   TYPE vkorg,        "Sales Organization
    vtweg   TYPE vtweg,        "Distribution Channel
    spart   TYPE spart,        "Division
    datab   TYPE datab,        "Valid-From Date
    datbi   TYPE datbi,        "Valid To Date
    matnr   TYPE matnr,        "Material Number
    prctr   TYPE prctr,        "Profit Center
    kunnr   TYPE kunnr,        "Customer Number
    kvgr1   TYPE kvgr1,        "Customer group 1
    pstlz_f TYPE zzpstlz_f,    "Postal Code (From)
    pstlz_t TYPE zzpstlz_t,    "Postal Code (To)
    regio   TYPE regio,        "Region (State, Province, County)
    land1   TYPE land1,        "Country Key
    srep1   TYPE zzsrep1,      "Sales Rep-1
    srep2   TYPE zzsrep2,      "Sales Rep-2
  END OF ty_zqtc_repdet,
  tt_zqtc_repdet TYPE STANDARD TABLE OF ty_zqtc_repdet,
*** BOC: CR#7763  KKRAVURI20181119  ED2K913891
  BEGIN OF ty_slsrep_det,
    vkorg    TYPE vkorg,        "Sales Organization
    vtweg    TYPE vtweg,        "Distribution Channel
    spart    TYPE spart,        "Division
    bsark    TYPE bsark,        "Customer purchase order type
    matnr    TYPE matnr,        "Material Number
    prctr    TYPE prctr,        "Profit Center
    kunnr    TYPE kunnr,        "Customer Number
    kvgr1    TYPE kvgr1,        "Customer group 1
    pstlz_f  TYPE zzpstlz_f,    "Postal Code (From)
    pstlz_t  TYPE zzpstlz_t,    "Postal Code (To)
    regio    TYPE regio,        "Region (State, Province, County)
    land1    TYPE land1,        "Country Key
    datab    TYPE datab,        "Valid-From Date
    zship_to TYPE zship_to,     "Ship-to party
    datbi    TYPE datbi,        "Valid To Date
    srep1    TYPE zzsrep1,      "Sales Rep-1
    srep2    TYPE zzsrep2,      "Sales Rep-2
  END OF ty_slsrep_det,
  tt_slsrep_det TYPE STANDARD TABLE OF ty_slsrep_det INITIAL SIZE 0,
*** EOC: CR#7763  KKRAVURI20181119  ED2K913891
  BEGIN OF ty_adrc,
    post_code1 TYPE ad_pstcd1, "City postal code
    post_code2 TYPE ad_pstcd2, "PO Box Postal Code
    country    TYPE land1,     "Country Key
    region     TYPE regio,     "Region (State, Province, County)
  END OF ty_adrc.

DATA:
  i_repdet_int TYPE STANDARD TABLE OF ty_zqtc_repdet,
*** BOC: CR#7763  KKRAVURI20181119  ED2K913891
  i_slsrep_int TYPE tt_slsrep_det,
  st_adrc      TYPE ty_adrc.
*** EOC: CR#7763  KKRAVURI20181119  ED2K913891
