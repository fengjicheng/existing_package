*&---------------------------------------------------------------------*
*& Include           ZQTCN_TEMPLATE_DOWNLOAD_SEL
* PROGRAM DESCRIPTION: File layout Download selection screen
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS : p_prname TYPE zca_templates-program_name OBLIGATORY,       " Program Name
             p_tmname TYPE zca_templates-template_name OBLIGATORY,      " Template Name
             p_versio TYPE zversion OBLIGATORY,                         " Version
             p_fpath  TYPE ibipparms-path OBLIGATORY.                   " File Path

SELECTION-SCREEN END OF BLOCK b1.
