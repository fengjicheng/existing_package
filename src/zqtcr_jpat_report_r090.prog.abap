*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_JPAT_REPORT (Main Program)
* PROGRAM DESCRIPTION:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   08/29/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S): ED2K916002
*----------------------------------------------------------------------*


REPORT zqtcr_jpat_report.


INCLUDE zqtcn_jpat_report_top IF FOUND.     " Define global data

INCLUDE zqtcn_jpat_report_sel IF FOUND.     " Define selection screen

INCLUDE zqtcn_jpat_report_sub IF FOUND.     " Subroutines.

INITIALIZATION.
  PERFORM f_populate_defaults.              " Constant values and selection

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic_screen.                 " Selection Screen fileds control

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_matnr-low.     " Custom Value request routine
  PERFORM f_value_on_request CHANGING s_matnr-low.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_matnr-high.
  PERFORM f_value_on_request CHANGING s_matnr-high.

AT SELECTION-SCREEN.


START-OF-SELECTION.
  PERFORM f_screen_validate.                  " Selection screen
  PERFORM f_calculate_year.

  PERFORM f_get_data.                         " Fetch data.
  PERFORM f_call_screen.                      " Select Screens based on selection

END-OF-SELECTION.

  INCLUDE fzqtc_deatilreport_onn.             " JPAT detail report PBO Include
  INCLUDE fzqtc_deatilreport_inn.             " JPAT detail report PAI Include

  INCLUDE fzqtc_summaryreport_onn.            " JPAT Summary report PBO Include
  INCLUDE fzqtc_summaryreport_inn.            " JPAT Summary report PAI Include
