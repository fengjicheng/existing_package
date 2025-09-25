*&---------------------------------------------------------------------*
*& Report  ZQTCR_KIARA_INTEGRATE_EMAIL
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_KIARA_INTEGRATE_EMAIL                            *
* PROGRAM DESCRIPTION: This program will trigger an Email when update  *
*                      from KIARA to Acceptance Date in Sales          *
*                      document fails                                  *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 06/05/2021                                          *
* OBJECT ID      :                                                     *
* TRANSPORT NUMBER(S): ED2K923295                                      *
*----------------------------------------------------------------------*
REPORT ZQTCR_KIARA_ADATE_ALERT_I0396.
*----------------------------------------------------------------------*
* Includes  -----------------------------------------------------*
* ---------------------------------------------------------------------*
INCLUDE zqtcn_kiara_integrate_emailtop.
INCLUDE zqtcn_kiara_integrate_emailsel.
INCLUDE zqtcn_kiara_integrate_emailf01.
*----------------------------------------------------------------------*
* Initialization-*
* ---------------------------------------------------------------------*
*INITIALIZATION.
*--*Initialize global variables and selection screen elements
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN.
* ---------------------------------------------------------------------*
*AT SELECTION-SCREEN.
*--*Validate selection screen variables
*----------------------------------------------------------------------*
* START-OF-SELECTION..
* ---------------------------------------------------------------------*
START-OF-SELECTION.
*--*fetch the credit memos with rejected reasons
  PERFORM f_fetch_application_db_logs.
*
  PERFORM f_trigger_email.


*----------------------------------------------------------------------*
* END-OF-SELECTION.
* ---------------------------------------------------------------------*
*END-OF-SELECTION.
*--*Display ALV data

*   PERFORM f_display_output.
