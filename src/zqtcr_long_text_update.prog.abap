**----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_LONG_TEXT_UPDATE                      *
* PROGRAM DESCRIPTION:   Program to update the order's long text
* DEVELOPER:             ARGADEELA
* CREATION DATE:         21/01/2022
* OBJECT ID:             E070
* TRANSPORT NUMBER(S):   ED1K913976
*----------------------------------------------------------------------*
REPORT zqtcr_long_text_update.

"Include for the Declarations
INCLUDE ZQTCN_LONG_TEXT_UPD_TOP.

"Include for Selection Screen
INCLUDE ZQTCN_LONG_TEXT_UPD_SCR.

"Include for the Subroutines.
INCLUDE ZQTCN_LONG_TEXT_UPD_F01.

***************************************************************
*         Seletion-Screen Block                               *
***************************************************************
*To get the file from presentation server.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_infl.

  PERFORM f_get_filename CHANGING p_infl.
***************************************************************
*     START-OF-SELECTION                                      *
***************************************************************
START-OF-SELECTION.
*put the file data into internal table to process further.
  PERFORM f_get_data_from_file.

END-OF-SELECTION.

  IF sy-batch EQ space.
    PERFORM f_display_data.
  ELSE.
    PERFORM f_order_long_text_update.
  ENDIF.
