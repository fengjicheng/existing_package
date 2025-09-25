*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZSCM_LITHO_TM_R096
* DESCRIPTION:         Table Maintenance for Renewal Period/BL Buffer
*                      in Litho Report
* DEVELOPER:           Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE:       28-AUG-2020
* OBJECT ID:           ERPM-837 (R096)
* TRANSPORT NUMBER(S): ED2K919143
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&----------------------------------------------------------------------*
REPORT zscm_litho_tm_r096 NO STANDARD PAGE HEADING
                          LINE-SIZE 132
                          LINE-COUNT 65
                          MESSAGE-ID zqtc_r2.

INCLUDE zscmn_litho_tm_r096_top.   " Global Data Declarations

INCLUDE zscmn_litho_tm_r096_sscrn. " Selection Screen

INCLUDE zscmn_litho_tm_r096_s01.   " Subroutines


INITIALIZATION.
  PERFORM f_set_defaults.

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_screen_control.

START-OF-SELECTION.
  " Clear data
  PERFORM f_clear_data.
  " Get data
  PERFORM f_get_data.


END-OF-SELECTION.
  " Display Report
  PERFORM f_display_alv_report.
