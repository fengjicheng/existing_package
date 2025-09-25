*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_PRODUCT_LANG_REP_R089
* PROGRAM DESCRIPTION: This report used to display Product text from
*                      Material Master.
* DEVELOPER:           Nageswara
* CREATION DATE:       08/19/2019
* OBJECT ID:           R089
* TRANSPORT NUMBER(S): ED2K915908
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
REPORT zqtcr_product_lang_rep_r089 NO STANDARD PAGE HEADING
                                LINE-SIZE 132
                                LINE-COUNT 65
                                MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
* INCLUDES
*----------------------------------------------------------------------*
" Data declaration
INCLUDE zqtcn_prod_lang_top.

"  Selection screen
INCLUDE zqtcn_prod_lang_scr.

" Perform for routines
INCLUDE zqtcn_prod_lang_f01.

*----------------------------------------------------------------------*
*                      PROGRAM INITIALIZATIONS
*----------------------------------------------------------------------*
INITIALIZATION.

*-------------------------------------------------------------------*
*                       At selection-screen                         *
*-------------------------------------------------------------------*
AT SELECTION-SCREEN.

AT SELECTION-SCREEN ON s_matnr.
* Validate Product number
  PERFORM f_validate_matnr.

AT SELECTION-SCREEN ON s_werks.
* Validate Plant
  PERFORM f_validate_werks.

*-------------------------------------------------------------------*
*                         Start of selection                        *
*-------------------------------------------------------------------*
START-OF-SELECTION.

* Fetch Material data
  PERFORM f_get_material_data.

*Create Dynamic internal Table
*  CHECK  sy-subrc EQ 0.
  PERFORM f_dynamic_table_create.

* Build Report with Data
  PERFORM f_build_report.

*-------------------------------------------------------------------*
*                         End of selection                        *
*-------------------------------------------------------------------*
END-OF-SELECTION.
* Display Alv
  PERFORM f_display_alv.
