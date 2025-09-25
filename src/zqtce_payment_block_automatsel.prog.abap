*&---------------------------------------------------------------------*
*&  Include           ZQTCR_PAYMENT_BLOCK_AUTOMATSEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_PAYMENT_BLOCK_AUTOMATSEL
* PROGRAM DESCRIPTION: Selection screen include for ZQTCE_PAYMENT_BLOCK_AUTO_E247
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE: 6/22/2020
* OBJECT ID: E247
* TRANSPORT NUMBER(S): ED2K918595
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS : s_augdt FOR bsad-augdt OBLIGATORY,
                 s_blart FOR bsad-blart NO INTERVALS OBLIGATORY,
                 s_auart FOR vbak-auart NO INTERVALS,
                 s_auart2 FOR vbak-auart NO INTERVALS,
                 s_lifsk FOR vbak-lifsk NO INTERVALS OBLIGATORY,
                 s_augru FOR vbak-augru NO INTERVALS.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
SELECT-OPTIONS s_email FOR adr6-smtp_addr NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b2.
