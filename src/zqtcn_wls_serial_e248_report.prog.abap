*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_WLS_SERIAL_E248_REPORT (Report)
* PROGRAM DESCRIPTION:Billing Serial Number Report
*re-trigger the invoice outputs that were blocked
*due to the serial number missing
* DEVELOPER: MIMMADISET
* CREATION DATE: 09/03/2020
* OBJECT ID: E248
* TRANSPORT NUMBER(S):ED2K919358
*----------------------------------------------------------------------*
REPORT zqtcn_wls_serial_e248_report.

*----------------------------------------------------------------------*
*                           I N C L U D E S                            *
*----------------------------------------------------------------------*
* Include for global data declaration
INCLUDE zqtcn_wls_serial_e248_top IF FOUND.
* Include for selection screen
INCLUDE zqtcn_wls_serial_e248_sel IF FOUND.
* Include for perform logic details
INCLUDE zqtcn_wls_serial_e248_sub IF FOUND.
*----------------------------------------------------------------------*
*                         START-OF-SELECTION                           *
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_update_run_date.
  IF i_output[] IS NOT INITIAL.
    PERFORM f_display_output.
  ENDIF.
