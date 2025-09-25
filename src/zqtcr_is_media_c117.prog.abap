 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_IS_MEDIA_C117
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_IS_MEDIA_C117
*& PROGRAM DESCRIPTION:   IS-Media Products & Classification Mass upload interface
*                         based on file Input
*& DEVELOPER:
*& CREATION DATE:         05/05/2022
*& OBJECT ID:             C117
*& TRANSPORT NUMBER(S):
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_is_media_c117 NO STANDARD PAGE HEADING MESSAGE-ID zqtc_r2.

*---Top include
 INCLUDE zqtcr_is_media_c117_top.

*---Include for Selection Screen
 INCLUDE zqtcr_is_media_c117_scr.

*--Form inlude
 INCLUDE zqtcr_is_media_c117_f01.

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
*   ELSEIF r_clf IS NOT INITIAL.
*     IF sy-batch = space.
**--foreground exeution
*       PERFORM f_clf_display_data.
*     ELSE.
**---background exection
*       PERFORM f_material_clf_create.
*       PERFORM f_clf_display_data.
*     ENDIF.
   ENDIF.
