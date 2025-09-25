FUNCTION-POOL zqtc_access_mech.             "MESSAGE-ID ..

* INCLUDE LZQTC_ACCESS_MECHD...              " Local class definition

TYPES:
  BEGIN OF ty_but0id,
    partner  TYPE bu_partner,               "Business Partner Number
    type     TYPE bu_id_type,
    idnumber TYPE	bu_id_number,
  END OF ty_but0id,

  BEGIN OF ty_const,
    devid    TYPE zdevid,                   "Development ID
    param1   TYPE rvari_vnam,               "Parameter1
    param2   TYPE rvari_vnam,               "Parameter2
    srno     TYPE tvarv_numb,               "Serial Number
    sign     TYPE tvarv_sign,               "Sign
    opti     TYPE tvarv_opti,               "Option
    low      TYPE salv_de_selopt_low,       "Low
    high     TYPE salv_de_selopt_high,      "High
    activate TYPE zconstactive,             "Active/Inactive Indicator
  END OF ty_const.

DATA:
  i_constant TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,
  i_acs_mech TYPE ztqtc_access_mech.

CONSTANTS:
  c_devid    TYPE zdevid       VALUE 'E152',        "Development ID
  c_param_am TYPE rvari_vnam   VALUE 'ACCESS_MECH'. "ABAP: Name of Variant Variable
