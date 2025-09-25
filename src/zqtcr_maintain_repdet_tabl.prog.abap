REPORT zqtcr_maintain_repdet_tabl.

INCLUDE zqtcn_maintain_repdet_tabl_top IF FOUND.
INCLUDE zqtcn_maintain_repdet_tabl_sel IF FOUND.
INCLUDE zqtcn_maintain_repdet_tabl_sub IF FOUND.

*----------------------------------------------------------------------*
*                     I N I T I A L I Z A T I O N                      *
*----------------------------------------------------------------------*
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
INITIALIZATION.
*  Populate list fields
  PERFORM f_populate_dd_list.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

AT SELECTION-SCREEN OUTPUT.
* Modify Selection Screen Display
  PERFORM f_modify_screen USING    cb_allf
                                   rb_bpid
                                   rb_sp
                          CHANGING rb_pcds
                                   rb_pcdr
                                   rb_regn
                                   rb_land
                                   rb_dgeo.

AT SELECTION-SCREEN ON p_vkorg.
* Validate Sales Organization
  PERFORM f_validate_sales_org  USING p_vkorg.

AT SELECTION-SCREEN ON p_vtweg.
* Validate Distribution Channel
  PERFORM f_validate_distr_chnl USING p_vtweg.

AT SELECTION-SCREEN ON p_spart.
* Validate Sales Divisions
  PERFORM f_validate_division   USING p_spart.

START-OF-SELECTION.
* Call Table Maintenance Generator
  PERFORM f_call_tmg USING p_vkorg
                           p_vtweg
                           p_spart
                           p_bsark  " ADD:CR#7764 KKRAVURI20181025  ED2K913679
                           p_datum
                           cb_allf
                           rb_prod
                           rb_prft
                           rb_dprd
                           rb_bpid
                           rb_sp    " ADD:CR#7764 KKRAVURI20181025  ED2K913679
                           rb_cgrp
                           rb_dind
                           rb_pcds
                           rb_pcdr
                           rb_regn
                           rb_land
                           rb_dgeo.
