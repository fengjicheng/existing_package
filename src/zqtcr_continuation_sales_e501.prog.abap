*&---------------------------------------------------------------------*
*& Report  ZQTCR_CONTINUATION_SALES_E501
*&
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_CONTINUATION_SALES_E501                  *
* PROGRAM DESCRIPTION : Creating Child(Continuous)Sales Order Automatically
* DEVELOPER           : SRAMASUBRA (Sankarram R)                       *
* CREATION DATE       : 2022-04-07                                     *
* OBJECT ID           : E501/EAM-8355                                  *
* TRANSPORT NUMBER(S) : ED2K926637                                     *
*&---------------------------------------------------------------------*
REPORT zqtcr_continuation_sales_e501.

INCLUDE zqtcn_contin_sales_e501_top.    "Top For Global Variables
INCLUDE zqtcn_contin_sales_e501_sel.    "Selection Screen
INCLUDE zqtcn_contin_sales_e501_sub.    "Subroutines


INITIALIZATION.
  "Clear Global Variables
  PERFORM f_clear.
  "Get Constant Values for this Dev Id
  PERFORM f_get_constants.
  "Change Screen Values
  PERFORM f_screen_dyn.


AT SELECTION-SCREEN.
  "Validation Check for Sel. Screen Params
  PERFORM f_check_params.
  "Enable/Disable Mandatory Fields in Screen
  PERFORM f_enable_params.

 START-OF-SELECTION.
  "Fetch Data
  PERFORM f_fetch_data.
  "Data Processing
  PERFORM f_data_processing.
