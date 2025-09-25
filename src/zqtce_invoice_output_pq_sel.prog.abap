*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_INVOICE_OUTPUT_PQ_SEL
* PROGRAM DESCRIPTION: Invoice list output for large orders from PQ
* DEVELOPER: Himanshu Patel (HIPATEL)
* CREATION DATE:   12/20/2017
* OBJECT ID: E170
* TRANSPORT NUMBER(S): ED2K910001
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s04.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS:  rb_onli TYPE char1 RADIOBUTTON GROUP rdb1 USER-COMMAND rdb1 DEFAULT 'X'.
PARAMETERS:  rb_batch TYPE char1 RADIOBUTTON GROUP rdb1.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS: s_fkart FOR vbrk-fkart NO INTERVALS OBLIGATORY DEFAULT 'ZF2',
                s_auart FOR vbak-auart NO INTERVALS,
                s_vbeln FOR vbrk-vbeln MODIF ID mi1,
                s_bstnk FOR vbak-bstnk MODIF ID mi1,
                s_erdat FOR vbrk-erdat MODIF ID mi1,
                s_erzet FOR vbrk-erzet MODIF ID mi1.
*SELECTION-SCREEN : SKIP 1.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
