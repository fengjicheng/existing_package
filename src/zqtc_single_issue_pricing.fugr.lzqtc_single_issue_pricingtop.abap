*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_SINGLE_ISSUE_PRICINGTOP(Global Data Declarations)
* PROGRAM DESCRIPTION: Identify scenario for Single Issue Pricing
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   05/11/2017
* OBJECT ID: E087
* TRANSPORT NUMBER(S): ED2K906020
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_single_issue_pricing.    "MESSAGE-ID ..

* INCLUDE LZQTC_SINGLE_ISSUE_PRICINGD...     " Local class definition

* Type declaration
TYPES:
  BEGIN OF ty_const,
    devid  TYPE zdevid,                                    "Development ID
    param1 TYPE rvari_vnam,                                "Parameter1
    param2 TYPE rvari_vnam,                                "Parameter2
    srno   TYPE tvarv_numb,                                "Serial Number
    sign   TYPE tvarv_sign,                                "Sign
    opti   TYPE tvarv_opti,                                "Option
    low    TYPE salv_de_selopt_low,                        "Low
    high   TYPE salv_de_selopt_high,                       "High
    active TYPE zconstactive,                              "Active/Inactive Indicator
  END OF ty_const,
  tt_const TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0.

DATA:
  i_consts TYPE tt_const.                                  "Internal table for Constant Table
