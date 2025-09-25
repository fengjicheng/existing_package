*&---------------------------------------------------------------------*
*&  Include           ZQTC_DIGI_DATA_INT_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_DF_DIGITAL_ENT_DATA_INT
* PROGRAM DESCRIPTION: Report to upload a text file onto application
*                      layer for Digital Entitlement Data Interface
*                      sent to TIBCO                                   *
* DEVELOPER:          APATNAIK(Alankruta Patnaik)
* CREATION DATE:      12/27/2016
* OBJECT ID:          I0342
* TRANSPORT NUMBER(S):ED2K903899
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   NA
* REFERENCE NO:  NA
* DEVELOPER:     NA
* DATE:          NA
* TRANSPORT NUMBER(S): NA
* DESCRIPTION: NA
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-s01.

SELECT-OPTIONS: s_vbeln FOR  v_vbeln NO INTERVALS,
                s_fkdat FOR  v_fkdat DEFAULT sy-datum,
                s_fkart FOR  v_fkart NO INTERVALS OBLIGATORY,
                s_kunnr FOR  v_kunnr NO INTERVALS,
                s_matnr FOR  v_matnr NO INTERVALS. " Generated Table for View

SELECTION-SCREEN SKIP.

PARAMETER: p_path TYPE localfile. " Local file for upload/download

SELECTION-SCREEN END OF BLOCK a1.
