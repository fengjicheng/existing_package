*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHG_MAT_ITEM_TEXT_SEL
*&---------------------------------------------------------------------*
TABLES: vbak,adr6,thead,mara.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-004.
PARAMETERS:rb_input RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 MODIF ID m1 DEFAULT 'X', "radio button for dowload credit memo
           rb_file  RADIOBUTTON GROUP rad1 MODIF ID m2 . "radio button for creating new credit memo
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-003.
SELECT-OPTIONS : p_matnr FOR mara-matnr MODIF ID m4.
SELECTION-SCREEN END OF BLOCK b2." WITH FRAME TITLE text-003.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-002.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID m3. "rlgrap-filename    " Local file for upload
PARAMETERS: p_object TYPE thead-tdobject DEFAULT 'MVKE' MODIF ID m5.
PARAMETERS: p_id TYPE thead-tdid DEFAULT'0001' MODIF ID m6.
PARAMETERS: p_a_file TYPE adr6-smtp_addr DEFAULT '/intf/tib/dev/jfds/I0255_label/in/' MODIF ID m7.
SELECTION-SCREEN SKIP 1.
PARAMETERS: r_b_txt AS CHECKBOX MODIF ID m8.
PARAMETERS: r_s_txt AS CHECKBOX MODIF ID m9.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
