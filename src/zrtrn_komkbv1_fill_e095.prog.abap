*&---------------------------------------------------------------------*
*&  Include           ZRTRN_KOMKBV1_FILL_E095
*&---------------------------------------------------------------------*

DATA : lst_vbpa      TYPE vbpavb,
       lv_adrnr      TYPE adrnr,
       lv_deflt_comm TYPE ad_comm.

READ TABLE com_vbpa[] INTO lst_vbpa WITH KEY parvw = 'WE'.
IF sy-subrc = 0.
  lv_adrnr = lst_vbpa-adrnr.
  SELECT SINGLE deflt_comm FROM adrc INTO lv_deflt_comm WHERE addrnumber = lv_adrnr.
  IF NOT lv_deflt_comm IS INITIAL.
    com_kbv1-zzdeflt_comm = lv_deflt_comm.
  ENDIF.
ENDIF.
