**----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_UPDATE                       *
* PROGRAM DESCRIPTION:   Program to update the Address details in Business
*                        partners from file
* DEVELOPER:             KJAGANA
* CREATION DATE:         02/13/2019
* OBJECT ID:             C105
* TRANSPORT NUMBER(S):   ED2K914456
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914563
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER: SKKAIRAMKO
* DATE:  02/25/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_bp_contact_update.

"Include for the Declarations
INCLUDE zqtcn_bp_contact_update_top.

"Include for Selection Screen
INCLUDE zqtcn_bp_contact_update_scr.

"Include for the Subroutines.
INCLUDE zqtcn_bp_contact_update_f01.

***************************************************************
*         Seletion-Screen Block                               *
***************************************************************
*To get the file from presentation server.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_infl.
*Get the file from presentation server
  PERFORM f_get_filename CHANGING p_infl.
***************************************************************
*         START-OF-SELECTION                               *
***************************************************************
START-OF-SELECTION.
  PERFORM f_clear_global_variable.
*put the file data into internal table to process further.
  PERFORM f_get_data_from_file.

END-OF-SELECTION.

  IF sy-batch = space.
*  *create contract person and relation ship in T-code:BP,
*   based on flat file data
    PERFORM f_display_data_to_create.
  ELSE.
*  *create contract person and relation ship in T-code:BP,
*   based on flat file data in background process
    PERFORM f_bp_update.

  ENDIF.
