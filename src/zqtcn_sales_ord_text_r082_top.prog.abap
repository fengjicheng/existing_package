*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_ORD_TEXT_R082_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ity_final,
         vbeln  TYPE vbeln,
         posnr  TYPE posnr,
         matnr  TYPE matnr,
         tdline TYPE tdline,
       END OF ity_final.

##NEEDED
DATA: i_final TYPE STANDARD TABLE OF ity_final.
