*&---------------------------------------------------------------------*
*&  Include           ZQTCR_INDIRECT_SOC_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01. "Selection Criteria
SELECT-OPTIONS:
  s_partnr   FOR wa_a985-zzpartner2          ,
  s_member    FOR wa_a985-zzreltyp,
  s_matnr     FOR wa_a985-matnr,
  s_prlist FOR wa_a985-pltyp,
  s_date      FOR wa_a985-datab.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: rb_a950 RADIOBUTTON GROUP b1 .
SELECTION-SCREEN COMMENT 3(72) comm1.
SELECTION-SCREEN end OF LINE.
PARAMETERS: rb_r2 RADIOBUTTON GROUP b1 .

SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
