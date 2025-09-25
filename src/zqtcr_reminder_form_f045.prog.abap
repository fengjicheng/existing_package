*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_REMINDER_FORM_F045
* PROGRAM DESCRIPTION:   Program to send advance proforma reminders
* DEVELOPER:             GKINTALI
* CREATION DATE:         25/10/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

REPORT zqtcr_reminder_form_f045 MESSAGE-ID zqtc_r2.

**Include for Global Data Declaration
INCLUDE zqtcn_reminder_form_f045_top.

**Include for Selection Screen
INCLUDE zqtcn_reminder_form_f045_sel.

*Include for Subroutines
INCLUDE zqtcn_reminder_form_f045_f01.

*----------------------------------------------------------------------*
*                 INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
* Fetch constants from ZCACONSTANT table
  PERFORM f_get_constant USING    gc_devid  " F045
                         CHANGING gt_const. " Constants data for F045

*----------------------------------------------------------------------*
*                 AT SELECTION-SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
* Validate proforma
  PERFORM f_val_salesorg.

* Validate Date input
  PERFORM f_val_fkdat.

* Validate Payer Number
  PERFORM f_val_kunrg.

* Validate Document Type
  PERFORM f_val_doctype.

* Validate proforma
  PERFORM f_val_proforma.

*----------------------------------------------------------------------*
*                 START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
* Get the data
  PERFORM f_get_data.
* Process Data
  PERFORM f_process_data.

END-OF-SELECTION.
