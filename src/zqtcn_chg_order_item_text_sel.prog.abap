*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHG_ORDER_ITEM_TEXT_SEL
*&---------------------------------------------------------------------*
TABLES: vbak,adr6,thead.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-004.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID m1. "rlgrap-filename    " Local file for upload
PARAMETERS: p_lang TYPE char2 DEFAULT 'EN' MODIF ID m2.
PARAMETERS: p_object TYPE thead-tdobject DEFAULT 'VBBP'.
PARAMETERS: p_id TYPE thead-tdid DEFAULT'0012'.
SELECT-OPTIONS :p_mail    FOR adr6-smtp_addr NO INTERVALS MODIF ID m3.
PARAMETERS: p_user TYPE sy-uname OBLIGATORY DEFAULT 'BC_RDWD' MODIF ID m4. " Job ID
PARAMETERS: p_a_file TYPE adr6-smtp_addr DEFAULT '/intf/tib/dev/jfds/I0255_label/in/' MODIF ID m5.
SELECTION-SCREEN END OF BLOCK b1.
