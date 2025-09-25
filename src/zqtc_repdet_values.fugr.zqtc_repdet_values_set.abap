FUNCTION zqtc_repdet_values_set.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_RB_PROD) TYPE  CHAR1
*"     REFERENCE(IM_RB_PRFT) TYPE  CHAR1
*"     REFERENCE(IM_RB_DPRD) TYPE  CHAR1
*"     REFERENCE(IM_RB_BPID) TYPE  CHAR1
*"     REFERENCE(IM_BSARK) TYPE  BSARK
*"     REFERENCE(IM_RB_SP) TYPE  CHAR1
*"     REFERENCE(IM_RB_CGRP) TYPE  CHAR1
*"     REFERENCE(IM_RB_DIND) TYPE  CHAR1
*"     REFERENCE(IM_RB_PCDS) TYPE  CHAR1
*"     REFERENCE(IM_RB_PCDR) TYPE  CHAR1
*"     REFERENCE(IM_RB_REGN) TYPE  CHAR1
*"     REFERENCE(IM_RB_LAND) TYPE  CHAR1
*"     REFERENCE(IM_RB_DGEO) TYPE  CHAR1
*"     REFERENCE(IM_CB_ALLF) TYPE  CHAR1
*"     REFERENCE(IM_P_DATUM) TYPE  SYDATUM
*"----------------------------------------------------------------------

  st_dt_mem-rb_prod = im_rb_prod.                "Material / Product
  st_dt_mem-rb_prft = im_rb_prft.                "Profit Center
  st_dt_mem-rb_dprd = im_rb_dprd.                "Default (Product)
  st_dt_mem-rb_bpid = im_rb_bpid.                "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  st_dt_mem-p_bsark = im_bsark.                  "PO Type
  st_dt_mem-rb_sp   = im_rb_sp.                  "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
  st_dt_mem-rb_cgrp = im_rb_cgrp.                "Customer Group
  st_dt_mem-rb_dind = im_rb_dind.                "Default (Industry)
  st_dt_mem-rb_pcds = im_rb_pcds.                "Postal Code (Individual)
  st_dt_mem-rb_pcdr = im_rb_pcdr.                "Postal Code (Range)
  st_dt_mem-rb_regn = im_rb_regn.                "Region
  st_dt_mem-rb_land = im_rb_land.                "Country
  st_dt_mem-rb_dgeo = im_rb_dgeo.                "Default (Geography)
  st_dt_mem-cb_allf = im_cb_allf.                "Display All Fields
  st_dt_mem-p_datum = im_p_datum.                "As-on Date

ENDFUNCTION.
