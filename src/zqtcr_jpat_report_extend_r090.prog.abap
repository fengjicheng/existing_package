*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_JPAT_REPORT (Main Program)
* PROGRAM DESCRIPTION:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156
*
* Transport NO: ED2K916608/ED2K916983
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/14/2019 & 12/03/2019
* DESCRIPTION:
*----------------------------------------------------------------------*


REPORT zqtcr_jpat_report NO STANDARD PAGE HEADING
                                   MESSAGE-ID zjpat.


INCLUDE zqtcn_jpat_report_extend_top IF FOUND.        " Define global data

INCLUDE zqtcn_jpat_report_extend_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_jpat_report_extend_sub IF FOUND.        " Subroutines.

INITIALIZATION.
  PERFORM f_populate_defaults.              " Constant values and selection
  PERFORM f_get_zcaconstants.               " ABAP Constant value table
  PERFORM f_hide_range_selection.           " Hide range selection for Year and Month  " changes for ED2K916608

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic_screen.                 " Selection Screen fileds control

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_matnr-low.     " Custom Value request routine
  PERFORM f_value_on_request CHANGING s_matnr-low.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_matnr-high.
  PERFORM f_value_on_request CHANGING s_matnr-high.

AT SELECTION-SCREEN.


START-OF-SELECTION.
  PERFORM f_month_and_year_validation.        " Multiple month and year validation with ED2K916609
  PERFORM f_screen_validate.                  " Selection screen
  PERFORM f_calculate_year.

  PERFORM f_get_data.                         " Fetch data.
  PERFORM f_call_screen.                      " Select Screens based on selection

END-OF-SELECTION.

  INCLUDE fzqtc_deatilreport_extend_onn IF FOUND.      " JPAT detail report PBO Include
  INCLUDE fzqtc_deatilreport_extend_inn IF FOUND.      " JPAT detail report PAI Include

  INCLUDE fzqtc_summaryreport_extend_onn IF FOUND.     " JPAT Summary report PBO Include
  INCLUDE fzqtc_summaryreport_extend_inn IF FOUND.     " JPAT Summary report PAI Include
