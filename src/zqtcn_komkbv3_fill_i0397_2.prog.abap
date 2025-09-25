*&---------------------------------------------------------------------*
*&  Include           ZQTCN_KOMKBV3_FILL_I0397_2
*&---------------------------------------------------------------------*
LOOP AT com_vbpa INTO DATA(lst_vbpa) WHERE vbeln = com_vbrk-vbeln
                                      AND parvw = 'RE'.
  com_kbv3-zzland1 = lst_vbpa-land1. "Personnel Number
  EXIT.
ENDLOOP.
