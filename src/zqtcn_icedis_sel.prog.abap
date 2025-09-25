*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ICEDIS_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCR_ICEDIS_OUTBOUND_FTP                        *
* PROGRAM DESCRIPTION:Report to upload a text file onto application    *
*                     layer for ICEDIS Outbound file - FTP Agents      *
* DEVELOPER:          NMOUNIKA                                         *
* CREATION DATE:      06/27/2017                                       *
* OBJECT ID:          I0352                                            *
* TRANSPORT NUMBER(S):ED2K903899                                       *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918160
* REFERENCE NO: ERPM-6517
* DEVELOPER: Lahiru Wathudura(LWATHUDURA)
* DATE: 05/08/2020
* DESCRIPTION: Add acquisition order to the flat file with given validity period
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-s01.

*SELECT-OPTIONS: s_kunnr FOR v_kunnr NO INTERVALS.
PARAMETERS p_kunnr TYPE kunnr OBLIGATORY.
*** Begin of Changes by Lahiru on 05/08/2020 for ERPM-6517 with ED2K918160 ***
SELECT-OPTIONS : s_valdat FOR sy-datum OBLIGATORY DEFAULT sy-datum. " Validity date range
*** End of Changes by Lahiru on 05/08/2020 for ERPM-6517 with ED2K918160 ***

SELECTION-SCREEN SKIP.

PARAMETER: p_path TYPE localfile. " Local file for upload/download

PARAMETERS: rb_app RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 DEFAULT 'X',  "Radio button for Application server
            rb_prs RADIOBUTTON GROUP rad1.                                "Radio button for Presentation Server

SELECTION-SCREEN END OF BLOCK a1.
