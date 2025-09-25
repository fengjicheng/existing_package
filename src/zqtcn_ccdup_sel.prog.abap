*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CCDUP_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS:s_bukrs FOR  bsegc-bukrs OBLIGATORY.
SELECT-OPTIONS:s_gjahr FOR bsegc-gjahr OBLIGATORY.
SELECT-OPTIONS:s_date FOR syst-datum.
SELECT-OPTIONS:s_aunum FOR bsegc-aunum.
SELECT-OPTIONS:s_ccnum FOR bsegc-ccnum.
SKIP 2.
SELECTION-SCREEN BEGIN OF BLOCK b2.
PARAMETERS: rb_cel RADIOBUTTON GROUP grp1  USER-COMMAND clc.
PARAMETERS: rb_amx RADIOBUTTON GROUP grp1  .

PARAMETERS: rb_wrk RADIOBUTTON GROUP grp1  .



PARAMETERS: p_file   TYPE rlgrap-filename .   " Local file for upload
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
