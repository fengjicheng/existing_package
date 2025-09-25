
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EDI_DOC_ENTITLE_SAP_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDI_DOC_ENTITLE_SAP_SEL ( Selection Screen Program)
* PROGRAM DESCRIPTION: Generate EDI Document for Entitlement from SAP
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   11/18/2016
* OBJECT ID:  I0296
* TRANSPORT NUMBER(S):   ED2K903359
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS: s_auart FOR gv_auart OBLIGATORY,
                s_jcode  FOR gv_idct OBLIGATORY.
PARAMETERS:     p_file TYPE localfile OBLIGATORY DEFAULT '/intf/tib/dev/eis/in/'.
SELECTION-SCREEN END OF BLOCK b1.
