*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_CMR_UPLD_CONSORTIUM_SEL
* PROGRAM DESCRIPTION  : Credit Memo Request Upload Consortium
* DEVELOPER            : Prabhu
* CREATION DATE        :   05/21/2018
* OBJECT ID            :  QTC_E101
* TRANSPORT NUMBER(S)  :  ED2K912156
*----------------------------------------------------------------------*
TABLES :vbak,vbrk,vbpa,adr6,vbkd.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:rb_dcmr RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 MODIF ID m3 DEFAULT 'X', "radio button for dowload credit memo
           rb_ucmr RADIOBUTTON GROUP rad1 MODIF ID m1 . "radio button for creating new credit memo

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.
PARAMETERS: rb_bg_m RADIOBUTTON GROUP rad6 USER-COMMAND ucom6 MODIF ID m12 DEFAULT 'X',
            rb_fg_m RADIOBUTTON GROUP rad6 MODIF ID m13.
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID m2.    " Local file for upload
SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS: rb_sel_m RADIOBUTTON GROUP rad5 USER-COMMAND ucom3 MODIF ID m4 DEFAULT 'X',
            rb_upd_m RADIOBUTTON GROUP rad5 MODIF ID m5.
SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS: s_po      FOR vbkd-bstkd    NO INTERVALS MODIF ID m7. "Customer PO
SELECT-OPTIONS: s_inv_dt  FOR vbrk-erdat    MODIF ID m8.              "Invoice date
SELECT-OPTIONS: s_rf_inv  FOR vbrk-vbeln    MODIF ID m9.              "Invoice
SELECT-OPTIONS: s_cnt_no  FOR vbak-vbeln    MODIF ID m10.             "Contract
SELECT-OPTIONS: s_shp_to  FOR vbpa-kunnr    MODIF ID m11.             "Shipto
SELECT-OPTIONS: s_auart   FOR vbak-auart NO-DISPLAY.                  "Sales doc type
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
SELECT-OPTIONS :p_mail    FOR adr6-smtp_addr NO INTERVALS MODIF ID m6.
SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN END OF BLOCK b1.
