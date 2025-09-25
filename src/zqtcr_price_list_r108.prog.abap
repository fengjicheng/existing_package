*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_PRICE_LIST_R108 (Main Program)
* PROGRAM DESCRIPTION: Price list extracts-AGU/EMBO price list report
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   05/27/2020
* OBJECT ID:  ERPM-6946/R108
* TRANSPORT NUMBER(S):ED2K918317
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description: .
*&---------------------------------------------------------------------*
REPORT zqtcr_price_list_r108 NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtcr_price_list_r108_top.

*- For Selection screen
INCLUDE zqtcr_price_list_r108_sel.

*- For subroutines
INCLUDE zqtcr_price_list_r108_sub.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
* Clar the Varibles and Tables
  PERFORM f_clear_data.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
* To change selection screen dynamics.
  PERFORM f_screen_dynamics.
* Screen fields disable
  PERFORM f_screen_disable.

AT SELECTION-SCREEN ON s_matnr.

  IF sy-ucomm NE '%008'.
    IF s_matnr[] IS INITIAL.
      MESSAGE e000(zqtc_r2) WITH 'Please enter Material Number for further processing'(042).
      LEAVE  LIST-PROCESSING.
    ENDIF.
  ENDIF.


START-OF-SELECTION.
* Get data
  PERFORM f_get_data.
* Display Report
  PERFORM f_display_alv_report.
