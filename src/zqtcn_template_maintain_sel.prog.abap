*&---------------------------------------------------------------------*
*Include ZQTCN_TEMPLATE_MAINTAIN_SEL
* PROGRAM DESCRIPTION: File layout maintain Selection Screen
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*


" Select the operation
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS: rb_view RADIOBUTTON GROUP grp1 DEFAULT 'X' USER-COMMAND uc1.      " View data radio button
PARAMETERS: rb_upd RADIOBUTTON GROUP grp1.                                    " Update data radio button

SELECTION-SCREEN END OF BLOCK b1.

" Input Operation
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-004.

PARAMETERS : p_prname TYPE zca_templates-program_name MODIF ID sg1,   " Program Name
             p_tmname TYPE zca_templates-template_name MODIF ID sg1.  " Template Name

SELECTION-SCREEN END OF BLOCK b2.
