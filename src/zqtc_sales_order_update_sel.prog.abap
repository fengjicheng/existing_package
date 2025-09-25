*&---------------------------------------------------------------------*
*&  Include           ZQTC_SALES_ORDER_UPDATE_SEL
*&---------------------------------------------------------------------*
TABLES: vbak,vbkd.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:rb_input RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 MODIF ID m1 DEFAULT 'X', "radio button for dowload credit memo
           rb_file  RADIOBUTTON GROUP rad1 MODIF ID m2 . "radio button for creating new credit memo
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-003.
SELECT-OPTIONS : s_vbeln FOR vbak-vbeln MODIF ID m4,
                 s_ihrez FOR vbkd-ihrez MODIF ID m5,
                 s_erdat FOR vbak-erdat MODIF ID m6.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-004.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID m3. "rlgrap-filename    " Local file for upload
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS: p_ind AS CHECKBOX DEFAULT 'X' MODIF ID m7.
SELECTION-SCREEN: COMMENT 3(20) text MODIF ID m8.
SELECTION-SCREEN : END OF LINE.
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_recon TYPE char10 DEFAULT '50000' MODIF ID m9.
SELECT-OPTIONS :p_mail    FOR adr6-smtp_addr NO INTERVALS MODIF ID m10.
PARAMETERS: p_user TYPE sy-uname OBLIGATORY DEFAULT 'BC_RDWD' MODIF ID m11. " Job ID
PARAMETERS: p_a_file TYPE adr6-smtp_addr DEFAULT '/intf/tib/dev/jfds/I0255_label/in/' MODIF ID m12.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
