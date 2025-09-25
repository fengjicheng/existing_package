*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_TAX_CTRL_UPD_R238_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : so_user  FOR cdhdr-username NO INTERVALS, " Login User
                 so_bp    FOR but000-partner,              " Business Partner
                 so_udat  FOR cdhdr-udate OBLIGATORY,      " Updation date
                 so_utim  FOR cdhdr-utime OBLIGATORY,      " Updation time
                 so_email FOR st_adr6-smtp_addr NO INTERVALS MODIF ID pat LOWER CASE.
SELECTION-SCREEN END OF BLOCK b1.
