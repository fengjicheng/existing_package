*&---------------------------------------------------------------------*
*&  Include  ZQTC_SALES_ORD_CHG_NEW_FLD_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_SALES_ORDER_UPDATE_SEL
*&---------------------------------------------------------------------*
TABLES : adr6.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_file        TYPE rlgrap-filename MODIF ID m2. "rlgrap-filename    " Local file for upload
SELECT-OPTIONS :p_mail    FOR adr6-smtp_addr NO INTERVALS MODIF ID m10 OBLIGATORY.
PARAMETERS: p_user        TYPE sy-uname OBLIGATORY DEFAULT 'BC_RDWD' MODIF ID m11. " Job ID
PARAMETERS: p_a_file      TYPE adr6-smtp_addr MODIF ID m12." DEFAULT '/intf/zapp/ED2/C102/in' MODIF ID m12.
PARAMETERS :p_job TYPE tbtcjob-jobname NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.
