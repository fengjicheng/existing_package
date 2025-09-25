 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_CMIR_MASS_LOAD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_CMIR_MASS_LOAD
*& PROGRAM DESCRIPTION:   Program to Maintain Customer-Material Info
*&                        from file
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         02/14/2019
*& OBJECT ID:             C107
*& TRANSPORT NUMBER(S):    ED2K914818
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_cmir_mass_load_02.

INCLUDE ZQTCN_CMIR_MASS_LOAD_02_TOP.
* INCLUDE zqtcn_cmir_mass_load_top IF FOUND.

 "Include for Selection Screen
INCLUDE ZQTCN_CMIR_MASS_LOAD_02_SCR.
* INCLUDE zqtcn_cmir_mass_load_scr IF FOUND.

INCLUDE ZQTCN_CMIR_MASS_LOAD_02_F01.
* INCLUDE zqtcn_cmir_mass_load_f01 IF FOUND.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_infl.

   PERFORM f_get_filename CHANGING p_infl.

 START-OF-SELECTION.

   PERFORM f_get_data_from_file.

 END-OF-SELECTION.
   IF sy-batch = space.
     PERFORM f_display_data.
   ELSE.
     PERFORM f_cm_create.
     PERFORM f_display_data.
   ENDIF.
