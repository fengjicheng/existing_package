*&---------------------------------------------------------------------*
*&  Include           ZQTCC_CREATE_INVOICE_VF04_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_fkdat FOR vkdfs-fkdat ," no-EXTENSION,
                 s_vbeln FOR vbak-vbeln,
                 s_kunnr FOR vkdfs-kunnr,
                 s_fkart FOR vbrk-fkart  NO INTERVALS OBLIGATORY DEFAULT c_ZF5,
                 s_vkbur for vbak-vkbur  NO INTERVALS  DEFAULT c_0050,
                 s_bsark for vbkd-bsark  NO INTERVALS  DEFAULT c_0230.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
