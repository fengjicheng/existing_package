*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CNTRCT_WITHOUT_JKSE_R102 (Main Program)
* PROGRAM DESCRIPTION:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   02/13/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917550
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CNTRCT_WITHOUT_JKSE_R102 (Main Program)
* PROGRAM DESCRIPTION:
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:   02/20/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917617
*&---------------------------------------------------------------------*


REPORT zqtcr_cntrct_without_jkse_r102 NO STANDARD PAGE HEADING
                                      MESSAGE-ID zqtc_r2.

INCLUDE zqtcn_cntrct_without_jkse_top IF FOUND.        " Define global data

INCLUDE zqtcn_cntrct_without_jkse_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_cntrct_without_jkse_sub IF FOUND.        " Subroutines.

INITIALIZATION.
  PERFORM f_get_zcaconstants.                          " ABAP Constant value table
  PERFORM f_populate_defaults.                         " Constant values and selection

START-OF-SELECTION.
  PERFORM f_fetch_data.                                " Fetch data
  PERFORM f_dispaly_data.                              " Display alv output
