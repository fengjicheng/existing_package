*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_SERIAL_E248_SEL
*&---------------------------------------------------------------------*
DATA:gv_ERDAT TYPE ERDAT,
     gv_vbeln TYPE VBELN_VF.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS:s_erdat FOR gv_erdat,
               s_vbeln FOR gv_vbeln.
PARAMETERS:p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-016.
PARAMETERS:p_nacha TYPE na_nacha DEFAULT 5.
SELECTION-SCREEN END OF BLOCK b2.
