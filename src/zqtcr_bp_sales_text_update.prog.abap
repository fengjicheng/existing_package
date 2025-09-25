**----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_BP_SALES_TEXT_UPDATE                      *
* PROGRAM DESCRIPTION:   Program to update the Customer Sales Text
* DEVELOPER:             ARGADEELA
* CREATION DATE:         02/13/2019
* OBJECT ID:             C105.1
* TRANSPORT NUMBER(S):   ED2K914386
*----------------------------------------------------------------------*
REPORT zqtcr_bp_sales_text_update.

"Include for the Declarations
INCLUDE zqtcn_bp_sales_text_update_top IF FOUND.

"Include for Selection Screen
INCLUDE zqtcn_bp_sales_text_update_scr IF FOUND.

"Include for the Subroutines.
INCLUDE zqtcn_bp_sales_text_update_f01 IF FOUND.

***************************************************************
*         Seletion-Screen Block                               *
***************************************************************
*To get the file from presentation server.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_infl.

  PERFORM f_get_filename CHANGING p_infl.
***************************************************************
*         START-OF-SELECTION                                  *
***************************************************************
START-OF-SELECTION.
*put the file data into internal table to process further.
  PERFORM f_get_data_from_file.

END-OF-SELECTION.

  IF sy-batch EQ space.
    PERFORM f_display_data.
  ELSE.
    PERFORM f_bp_update_cust_sales_text.
  ENDIF.
