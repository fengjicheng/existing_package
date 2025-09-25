FUNCTION zqtc_ism_matmas_ob_cp_set.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_T_CPIDENT_MAT) TYPE  ZTQTC_CPIDENT_MAT
*"     REFERENCE(IM_T_CHGPTRS) TYPE  BDCP_TAB
*"----------------------------------------------------------------------

  i_cpident_mat[] = im_t_cpident_mat.
  i_chgptrs[]     = im_t_chgptrs.

  SORT i_cpident_mat BY matnr.
  SORT i_chgptrs     BY cpident tabname.

ENDFUNCTION.
