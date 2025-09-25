*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ISM_MATMAS_SEGMENTS_03
*&---------------------------------------------------------------------*
CALL FUNCTION 'ZQTC_ISM_MATMAS_OB_CP_SET'
  EXPORTING
    im_t_cpident_mat = t_cpident_mat[]
    im_t_chgptrs     = t_chgptrs[].
