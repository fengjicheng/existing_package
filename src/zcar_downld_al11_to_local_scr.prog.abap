*----------------------------------------------------------------------*
* PROGRAM NAME: ZCAR_DOWNLOAD_AL11_FILE
* PROGRAM DESCRIPTION: This report used to download AL11 file to desktop
* DEVELOPER:           Nageswara
* CREATION DATE:       08/23/2019
* OBJECT ID:           Utility
* TRANSPORT NUMBER(S): ED2K915945
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZCAN_DOWNLOADFILE_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-b01.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS : rb_256ld RADIOBUTTON GROUP rb1 MODIF ID m1  " I0256 Lodgement Error logs
                      DEFAULT 'X' USER-COMMAND uc1,
             rb_315bi RADIOBUTTON GROUP rb1 MODIF ID m1, " I0315 bios Error logs
             rb_315jd RADIOBUTTON GROUP rb1 MODIF ID m1, " I0315 jdr Error logs
             rb_315jr RADIOBUTTON GROUP rb1 MODIF ID m1, " I0315 jrr Error logs
             rb_315so RADIOBUTTON GROUP rb1 MODIF ID m1. " I0315 soh Error logs
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME.
PARAMETERS : p_as_fn TYPE rlgrap-filename,               " Input Application Server file path
             p_cl_fn TYPE rlgrap-filename.               " Input Presentation Server file path
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.
