 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IF_MATERIAL_MASS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_WLS_MATERIAL_MASS_UPLD
*& PROGRAM DESCRIPTION:   Material & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         03/04/2020
*& OBJECT ID:             C113
*& TRANSPORT NUMBER(S):   ED2K917656
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_wls_material_mass_upld NO STANDARD PAGE HEADING MESSAGE-ID zqtc_r2.

*---Top include
 INCLUDE zqtcn_wls_mat_mass_upld_top.

*---Include for Selection Screen
 INCLUDE zqtcn_wls_mat_mass_upld_scr.

*--Form inlude
 INCLUDE zqtcn_wls_mat_mass_upld_f01.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*---FIle selction Popup screen
   PERFORM f_get_filename CHANGING p_file.

 START-OF-SELECTION.
   IF r_mat IS NOT INITIAL.
*---Get the file and get the data into internal table
     PERFORM f_get_data_from_file TABLES i_file_data.
   ELSEIF r_clf IS NOT INITIAL.
      PERFORM f_get_data_from_file_clf TABLES i_file_data_clf.
   ENDIF.

 END-OF-SELECTION.
   IF r_mat IS NOT INITIAL.
     IF sy-batch = space.
*--Foreground exeution
       PERFORM f_display_data.
     ELSE.
*---Background exection
       PERFORM f_material_create.
       PERFORM f_display_data.
     ENDIF.
   ELSEIF r_clf IS NOT INITIAL.
     IF sy-batch = space.
*--foreground exeution
       PERFORM f_clf_display_data.
     ELSE.
*---background exection
       PERFORM f_material_clf_create.
       PERFORM f_clf_display_data.
     ENDIF.
   ENDIF.
