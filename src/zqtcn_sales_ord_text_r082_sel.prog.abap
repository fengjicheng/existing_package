*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_ORD_TEXT_R082_SEL
*&---------------------------------------------------------------------*
DATA: lv_ord      TYPE vbeln,
      lv_item     TYPE posnr,
      lv_sorg     TYPE vkorg,
      lv_date     TYPE erdat.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s01.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS:s_ord  FOR lv_ord,
               s_itm  FOR lv_item,
               s_sorg FOR lv_sorg NO INTERVALS NO-EXTENSION,
               s_date FOR lv_date.
SELECTION-SCREEN END OF BLOCK b1.
SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_lang   TYPE char1     OBLIGATORY  DEFAULT 'E',
            p_object TYPE tdobject  OBLIGATORY  DEFAULT 'VBBP',
            p_id     TYPE tdid      OBLIGATORY  DEFAULT '0012'.

SELECTION-SCREEN END OF BLOCK b2.
SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
PARAMETERS:rb_alv  RADIOBUTTON GROUP rb1  USER-COMMAND rucomm DEFAULT 'X',
           rb_pre  RADIOBUTTON GROUP rb1,
           rb_appl RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b4.
SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-005.
PARAMETERS: p_file   TYPE string MODIF ID pat LOWER CASE .
SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN END OF BLOCK b3.
