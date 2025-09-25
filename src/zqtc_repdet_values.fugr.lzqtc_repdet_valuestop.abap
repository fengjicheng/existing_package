FUNCTION-POOL zqtc_repdet_values.           "MESSAGE-ID ..

* INCLUDE LZQTC_REPDET_VALUESD...           "Local class definition

TYPES:
  BEGIN OF ty_dt_mem,
    rb_prod	TYPE char1,	                        "Material / Product
    rb_prft	TYPE char1,	                        "Profit Center
    rb_dprd	TYPE char1,	                        "Default (Product)
    rb_bpid	TYPE char1,	                        "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
    p_bsark TYPE bsark,                        "PO Type
    rb_sp   TYPE char1,                        "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
    rb_cgrp	TYPE char1,	                        "Customer Group
    rb_dind	TYPE char1,	                        "Default (Industry)
    rb_pcds	TYPE char1,	                        "Postal Code (Individual)
    rb_pcdr	TYPE char1,	                        "Postal Code (Range)
    rb_regn	TYPE char1,	                        "Region
    rb_land	TYPE char1,	                        "Country
    rb_dgeo	TYPE char1,	                        "Default (Geography)
    cb_allf TYPE char1,                        "Display All Fields
    p_datum	TYPE sydatum,	                      "As-on Date
  END OF ty_dt_mem.

DATA:
  st_dt_mem TYPE ty_dt_mem.
