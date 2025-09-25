*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_PRINT_RUN_REPT_R064
* PROGRAM DESCRIPTION: Print Run Report
* The Purpose of this Report is to show number of current
* open subscriptions, the estimated number of offline subscriptions
* un-renewed quantity of a perticular issue.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO:  ED2K908417
* REFERENCE NO: ERP-4058
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-09-06
* DESCRIPTION: Publication date check for Printer Quantity has been
* corrected. It was taking for less than todays date where as ideally
* it should have been for greter than todays date.
* code changes are in include zqtcn_print_run_rept_r064_sub.
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Report  ZQTCE_PRINT_RUN_REPT_R064
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_print_run_rept_r064  NO STANDARD PAGE HEADING
                                  LINE-SIZE 132
                                  LINE-COUNT 65
                                  MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_print_run_rept_r064_top. " Include ZQTCN_PRINT_RUN_REPT_R064_TOP
*INCLUDE zqtcn_print_run_rept_r064_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtcn_print_run_rept_r064_sel. " " Include ZQTCN_PRINT_RUN_REPT_R064_SEL
*INCLUDE  zqtcn_print_run_rept_r064_sel IF FOUND.

*Include for Subroutines
INCLUDE zqtcn_print_run_rept_r064_sub. " " Include ZQTCN_PRINT_RUN_REPT_R064_SUB
*INCLUDE zqtcn_print_run_rept_r064_sel IF FOUND.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                          *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_matnr.
  IF s_matnr IS NOT INITIAL.
* Validate Media Issue
    PERFORM f_validate_matnr.
  ENDIF. " IF s_matnr IS NOT INITIAL

AT SELECTION-SCREEN ON s_medprd.
* Validate Media Product
  IF s_medprd[] IS NOT INITIAL.
*   PERFORM f_validate_matnr USING s_medprd[].
  ENDIF. " IF s_medprd[] IS NOT INITIAL

AT SELECTION-SCREEN ON p_mtart.
  IF p_mtart IS NOT INITIAL.
* Validate Material Type
    PERFORM f_validate_mattyp USING p_mtart.
  ENDIF. " IF p_mtart IS NOT INITIAL


AT SELECTION-SCREEN ON s_pubyr.
*  IF s_pubyr IS NOT INITIAL.
** Validate Media Issue year
*    PERFORM f_validate_publ.
*  ENDIF. " IF s_pubyr IS NOT INITIAL

AT SELECTION-SCREEN ON p_month.
  IF p_month IS NOT INITIAL.
* Validete the unrenewed Subscription base period month.
    PERFORM f_validate_period.
  ENDIF.

AT SELECTION-SCREEN ON s_doctyp.
  IF s_doctyp[] IS NOT INITIAL.
* Validate Sales Document type
    PERFORM f_validate_auart USING s_doctyp[].
  ENDIF. " IF s_doctyp[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_contyp.
  IF s_contyp[] IS NOT INITIAL.
* Validate Contract Document type
    PERFORM f_validate_auart USING s_contyp[].
  ENDIF. " IF s_contyp[] IS NOT INITIAL

AT SELECTION-SCREEN ON p_itype.
  IF p_itype IS NOT INITIAL.
* Validate Identification Code Types
    PERFORM f_validate_id_type.
  ENDIF. " IF p_itype IS NOT INITIAL

AT SELECTION-SCREEN.
  PERFORM f_validate_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_month.
  PERFORM f_populate_month_year.
*----------------------------------------------------------------------*
*                Initialization                               *
*----------------------------------------------------------------------*
INITIALIZATION.

* Clear all global variables
  PERFORM f_clear_global_variables.

* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_bwart[].

* Fetch data from ZCACONSTANT TABLE
  PERFORM f_fetch_constant.

*----------------------------------------------------------------------*
*              Start-of-selection                                       *
*----------------------------------------------------------------------*
START-OF-SELECTION.
* Fetch and procress records
  PERFORM f_fetch_n_process.

**----------------------------------------------------------------------*
**             END-OF-SELECTION Event
**----------------------------------------------------------------------*
END-OF-SELECTION.
* To display ALV
  IF i_final IS NOT INITIAL.
* Display ALV
    PERFORM f_display_alv.
  ELSE. " ELSE -> IF i_final IS NOT INITIAL
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
    LEAVE LIST-PROCESSING .
  ENDIF. " IF i_final IS NOT INITIAL
