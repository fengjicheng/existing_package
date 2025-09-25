*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCR_STAGING_E225
* PROGRAM DESCRIPTION:program for populating ZE225_STAGING table data
* DEVELOPER: GKAMMILI(Gopalakrishna K)
* CREATION DATE:   2019-12-04
* OBJECT ID:
* TRANSPORT NUMBER(S) ED2K916990
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:  ED2K924398
* REFERENCE NO: OTCM-47267
* DEVELOPER:    Nikhilesh Palla(NPALLA)
* DATE:         12/17/2021
* DESCRIPTION:  Staging Changes - Add additional filterning by File Type
*               and capture File type in output.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_STAGING_E225
*&---------------------------------------------------------------------*
REPORT zqtcr_staging_e225 MESSAGE-ID zqtc_r2
                          NO STANDARD PAGE HEADING.

*-- Top include for data declarations
INCLUDE zqtcn_ze225_staging_top.

*-- Include for selection screen
INCLUDE zqtcn_ze225_staging_sel_screen.

*-- Include for sub routines
INCLUDE zqtcn_ze225_staging_forms.

INITIALIZATION.
  s_ztim-high = '235900'.
  APPEND s_ztim.
  CLEAR : s_ztim.

*-- AT SELECTION SCREENN VALUE REQUEST
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_zstat-low.
*--Providing F4 for status field low value
  PERFORM f_get_possible_values USING s_zstat-low.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_zstat-high.
*--Providing F4 for status field high value
  PERFORM f_get_possible_values USING s_zstat-high.

*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
AT SELECTION-SCREEN.
  PERFORM f_validate_file_options.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_validate_mandatory_feilds.
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267

START-OF-SELECTION.
*-- get data
  PERFORM f_get_data.
  PERFORM f_process_data.

END-OF-SELECTION.
  IF i_final[] IS NOT INITIAL.
*-- Displaying the data
    PERFORM f_display_data.
  ENDIF.
