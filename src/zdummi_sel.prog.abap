*&---------------------------------------------------------------------*
*&  Include           ZDUMMI_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04 .
PARAMETERS: p_kappl TYPE kappl     OBLIGATORY DEFAULT 'V',                         " Application
            p_kschl TYPE kscha     OBLIGATORY MATCHCODE OBJECT f4_kschl_for_table, " Condition type
            p_tname TYPE tabname16 OBLIGATORY.                                     " Table name, 16 characters
SELECTION-SCREEN END OF BLOCK b4.

SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02 .
PARAMETERS: rb_pre  RADIOBUTTON GROUP rb1 USER-COMMAND rucomm DEFAULT 'X', "radiobutton for Presentation server
            rb_appl RADIOBUTTON GROUP rb1 .         "radiobutton for application server.
SELECTION-SCREEN END OF BLOCK b2.

SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
PARAMETERS: p_file   TYPE localfile MODIF ID fl1, " Local file for upload/download
            p_hdr_ln TYPE numc2 DEFAULT '03',           " Two digit number
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
*           p_sls_dl TYPE char1 AS CHECKBOX.      " Include Column for Sales Deal
            p_s_term TYPE char1 AS CHECKBOX.      " Include Column for Search Term
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN END OF BLOCK b1.
