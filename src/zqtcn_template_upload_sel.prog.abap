*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TEMPLATE_UPLOAD_SEL
* PROGRAM DESCRIPTION: File layout Upload program selection screen
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS : p_prname TYPE zca_templates-program_name OBLIGATORY,   " Program Name
             p_tmname TYPE zca_templates-template_name OBLIGATORY,  " Template Name
             p_fname  TYPE ibipparms-path OBLIGATORY,               " File Path                                       " Active/Inactive
             p_wricef TYPE zca_templates-wricef_id OBLIGATORY,      " WRICEF ID
             p_comme  TYPE zca_templates-comments.
SELECTION-SCREEN BEGIN OF LINE .
SELECTION-SCREEN COMMENT (31) FOR FIELD cb_activ.           " Active/Inactive
PARAMETERS: cb_activ AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.
