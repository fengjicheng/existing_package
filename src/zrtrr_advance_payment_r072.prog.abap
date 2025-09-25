*----------------------------------------------------------------------*
* PROGRAM NAME        : ZRTRR_ADVANCE_PAYMENT
* PROGRAM DESCRIPTION : This program is used to ddisplay Payment details
*                       of Proforma with Invoice and without invoice and both.
* DEVELOPER           : Prabhu Kishore T (PTUFARAM)
* CREATION DATE       : 06/22/2018
* OBJECT ID           : R072 - Advance Payment Report
* TRANSPORT NUMBER(S) : ED2K912402
*----------------------------------------------------------------------*
REPORT zrtrr_advance_payment_r072.
*----------------------------------------------------------------------*
*--Below Include is used to declare All the Global Variables
*----------------------------------------------------------------------*
INCLUDE zrtrr_advance_payment_top.
*----------------------------------------------------------------------*
*---------Initialization
*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
*--Below Subrotine is used clear the global Variables.
*----------------------------------------------------------------------*
  PERFORM f_initialize.
*----------------------------------------------------------------------*
*---------At Selection-Screen Output event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
*----Below Subroutine is used to modify the selection screen elements
*----------------------------------------------------------------------*
  PERFORM modify_selection.
*----------------------------------------------------------------------*
*----At Selection screen event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
*----Below sub routine is used to Validate selection screen elements
*----------------------------------------------------------------------*
  PERFORM f_validate_selection.
*----------------------------------------------------------------------*
*----Start-Of-selection Event
*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
*---Below Subroutine is used to Fetch the data from database tables/views
*----------------------------------------------------------------------*
  PERFORM f_get_data.
*----------------------------------------------------------------------*
*----Below Subroutine is used to build final Internal table
*----------------------------------------------------------------------*
  PERFORM f_build_output.
*----------------------------------------------------------------------*
*----END-OF-SELECTION Event
*----------------------------------------------------------------------*
END-OF-SELECTION.
*----------------------------------------------------------------------*
*---Below Subroutine is used to build field catalog for ALV
*----------------------------------------------------------------------*
  PERFORM f_build_fcat.
*----------------------------------------------------------------------*
*---Below Subroutine is used to display the output with ALV
*----------------------------------------------------------------------*
  PERFORM f_display_output.

*----------------------------------------------------------------------*
*--Below Include is used to keep all the form routines logic
*----------------------------------------------------------------------*
INCLUDE zrtrr_advance_payment_forms.
