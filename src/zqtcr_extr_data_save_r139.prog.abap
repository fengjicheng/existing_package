*&---------------------------------------------------------------------*
*& Report  ZQTCR_EXTR_DATA_SAVE
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:        ZQTCR_EXTR_DATA_SAVE
*& PROGRAM DESCRIPTION: Program to update Custom table from extractor data
*& DEVELOPER:           Krishna & Rajkumar Madavoina
*& CREATION DATE:       04/20/2021
*& OBJECT ID:
*& TRANSPORT NUMBER(S): ED2K923107
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_extr_data_save MESSAGE-ID zqtc_r2
                                   NO STANDARD PAGE HEADING
                                   LINE-SIZE  132.

INCLUDE zqtcn_extr_data_save_top.
INCLUDE zqtcn_extr_data_save_sel.
INCLUDE zqtcn_extr_data_save_f01.


*----------------------------------------------------------------------*
* A T  S E L E C T I O N - S C R E E N  O U T P U T                    *
*----------------------------------------------------------------------*
*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name CP '*P_LAYOUT*'.
*      IF p_dl IS INITIAL.
*        screen-active = 0.     " File Parameter Invisible
*      ELSE.
*        screen-active = 1.     " File Parameter Visible
*      ENDIF.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
*----------------------------------------------------------------------*
* A T  S E L E C T I O N - S C R E E N  O N  V A L U E   R  E Q U E S T*
*----------------------------------------------------------------------*
** validation
AT SELECTION-SCREEN ON s_date.
  IF s_date-high IS INITIAL.
    MESSAGE text-s02 TYPE 'E'.
  ENDIF.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
*  PERFORM f_save_layout.

*--------------------------------------------------------------------*
*--                    START-OF-SELECTIONNS                        --*
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_fetch_data. "CI_NO_TRANSFORM
*--------------------------------------------------------------------*
*--                    END-OF-SELECTION                            --*
*--------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM f_process_data.
  PERFORM f_display_data.
