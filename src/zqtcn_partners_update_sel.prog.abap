*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PARTNERS_UPDATE_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
PARAMETERS: p_p_file TYPE localfile OBLIGATORY, " Local file for upload/download
            p_a_file TYPE localfile OBLIGATORY. " Local file for upload/download
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: p_recon  TYPE char10 DEFAULT '50000',
            p_user TYPE sy-uname OBLIGATORY DEFAULT 'BC_RDWD',
            cb_hdr   TYPE xfeld.                " Checkbox
PARAMETERS :p_job TYPE tbtcjob-jobname NO-DISPLAY.
SELECT-OPTIONS : p_mail FOR v_email NO INTERVALS OBLIGATORY. " E-Mail Address
SELECTION-SCREEN END OF BLOCK b2.
