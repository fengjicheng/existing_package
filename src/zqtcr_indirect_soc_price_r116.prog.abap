*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_INDIRECT_SOC_PRICE_R116
* PROGRAM DESCRIPTION : Indirect Society Member Price Report
* DEVELOPER           : NPOLINA
* CREATION DATE       : 29/June/2020
* OBJECT ID           : R116
* TRANSPORT NUMBER(S) : ED2K917365.
*----------------------------------------------------------------------*
REPORT ZQTCR_INDIRECT_SOC_PRICE_R116.

* Top Include contains Variable and Declrations.
INCLUDE ZQTCR_INDIRECT_SOC_top IF FOUND..

* Selection Screen
INCLUDE ZQTCR_INDIRECT_SOC_sel IF FOUND..

* Subroutne declaration.
INCLUDE ZQTCR_INDIRECT_SOC_form IF FOUND..


INITIALIZATION.

** Populate Selection Screen Default Values
  PERFORM f_screen_handling .

AT SELECTION-SCREEN OUTPUT.
  comm1 = 'Discount Table A950 (By Society, Membership,Contract Length & Material)'(003).
START-OF-SELECTION.
* Clear Global Variable + Internal Table.
  PERFORM f_clear_all.

* Fetch and Process Records
  PERFORM f_fetch_n_process   .

END-OF-SELECTION.
* Display Alv Grid as log
  PERFORM f_display_alv_grid .
