 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MAT_CLASSIFI_MASS_UPLD
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MAT_CLASSIFI_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Classication Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/20/2019
*& OBJECT ID:             C110.2
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_mat_classifi_mass_upld NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.
*---Top include
 INCLUDE zqtcn_mat_classifi_upld_top IF FOUND.

*---Include for Selection Screen
 INCLUDE zqtcn_mat_classifi_upld_scr IF FOUND.

*--form inlude
 INCLUDE zqtcn_mat_classifi_upld_f01 IF FOUND.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*---FIle selction Popup screen
   PERFORM f_get_filename CHANGING p_file.

 START-OF-SELECTION.
*---Get the file and get the data into internal table
   PERFORM f_get_data_from_file.

 END-OF-SELECTION.
   IF sy-batch = space.
*--foreground exeution
     PERFORM f_display_data.
   ELSE.
*---background exection
     PERFORM f_material_create.
     PERFORM f_display_data.
   ENDIF.
