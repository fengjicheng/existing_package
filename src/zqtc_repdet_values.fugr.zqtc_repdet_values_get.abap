FUNCTION zqtc_repdet_values_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_RB_PROD) TYPE  CHAR1
*"     REFERENCE(EX_RB_PRFT) TYPE  CHAR1
*"     REFERENCE(EX_RB_DPRD) TYPE  CHAR1
*"     REFERENCE(EX_RB_BPID) TYPE  CHAR1
*"     REFERENCE(EX_P_BSARK) TYPE  BSARK
*"     REFERENCE(EX_RB_SP) TYPE  CHAR1
*"     REFERENCE(EX_RB_CGRP) TYPE  CHAR1
*"     REFERENCE(EX_RB_DIND) TYPE  CHAR1
*"     REFERENCE(EX_RB_PCDS) TYPE  CHAR1
*"     REFERENCE(EX_RB_PCDR) TYPE  CHAR1
*"     REFERENCE(EX_RB_REGN) TYPE  CHAR1
*"     REFERENCE(EX_RB_LAND) TYPE  CHAR1
*"     REFERENCE(EX_RB_DGEO) TYPE  CHAR1
*"     REFERENCE(EX_CB_ALLF) TYPE  CHAR1
*"     REFERENCE(EX_P_DATUM) TYPE  SYDATUM
*"----------------------------------------------------------------------

  ex_rb_prod = st_dt_mem-rb_prod.                "Material / Product
  ex_rb_prft = st_dt_mem-rb_prft.                "Profit Center
  ex_rb_dprd = st_dt_mem-rb_dprd.                "Default (Product)
  ex_rb_bpid = st_dt_mem-rb_bpid.                "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  ex_p_bsark = st_dt_mem-p_bsark.                "PO Type
  ex_rb_sp   = st_dt_mem-rb_sp.                  "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
  ex_rb_cgrp = st_dt_mem-rb_cgrp.                "Customer Group
  ex_rb_dind = st_dt_mem-rb_dind.                "Default (Industry)
  ex_rb_pcds = st_dt_mem-rb_pcds.                "Postal Code (Individual)
  ex_rb_pcdr = st_dt_mem-rb_pcdr.                "Postal Code (Range)
  ex_rb_regn = st_dt_mem-rb_regn.                "Region
  ex_rb_land = st_dt_mem-rb_land.                "Country
  ex_rb_dgeo = st_dt_mem-rb_dgeo.                "Default (Geography)
  ex_cb_allf = st_dt_mem-cb_allf.                "Display All Fields
  ex_p_datum = st_dt_mem-p_datum.                "As-on Date

ENDFUNCTION.
