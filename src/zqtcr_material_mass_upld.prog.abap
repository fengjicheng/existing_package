 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material Mass upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         09/17/2019
*& OBJECT ID:             C110.1
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_material_mass_upld NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.

*---Top include
 INCLUDE zqtcn_material_mass_upld_top.

*---Include for Selection Screen
 INCLUDE zqtcn_material_mass_upld_scr.

*--Form inlude
 INCLUDE zqtcn_material_mass_upld_f01.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*---FIle selction Popup screen
   PERFORM f_get_filename CHANGING p_file.

 START-OF-SELECTION.
*---Get the file and get the data into internal table
   IF p_chk IS NOT INITIAL.
     PERFORM f_get_data_from_file TABLES i_file_data_p.
   ELSE.
     PERFORM f_get_data_from_file TABLES i_file_data.
   ENDIF.


 END-OF-SELECTION.
   IF sy-batch = space.
*--Foreground exeution
     PERFORM f_display_data.
   ELSE.
*---Background exection
     PERFORM f_material_create.
     PERFORM f_display_data.
   ENDIF.
