*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CREDIT_LIMIT_REP_R091
* PROGRAM DESCRIPTION: Customer Credit Limits Report.
* DEVELOPER:           Nageswara
* CREATION DATE:       09/03/2019
* OBJECT ID:           R091
* TRANSPORT NUMBER(S): ED2K916008
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
REPORT zqtcr_credit_limit_rep_r091 NO STANDARD PAGE HEADING
                                LINE-SIZE 132
                                LINE-COUNT 65
                                MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
* INCLUDES
*----------------------------------------------------------------------*
" Data declaration
INCLUDE zqtcn_credit_limit_top.

"  Selection screen
INCLUDE zqtcn_credit_limit_scr.

" Perform for routines
INCLUDE zqtcn_credit_limit_f01.


*----------------------------------------------------------------------*
*                      PROGRAM INITIALIZATIONS
*----------------------------------------------------------------------*
INITIALIZATION.
  FREE:i_list[].
  CLEAR:st_list.
  st_list-key = c_y.
  st_list-text = 'Yes'(032).
  APPEND st_list TO i_list.

  CLEAR:st_list.
  st_list-key = c_n.
  st_list-text = 'No'(033).
  APPEND st_list TO i_list.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_BLOCK'
      values          = i_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  ##FM_SUBRC_OK IF sy-subrc EQ 0.
* Nothing to do
  ENDIF.
*-------------------------------------------------------------------*
*                       At selection-screen                         *
*-------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_bukrs.
  PERFORM f_validate_compcode.

AT SELECTION-SCREEN ON s_kunnr.
  PERFORM f_validate_customer.

*-------------------------------------------------------------------*
*                         Start of selection                        *
*-------------------------------------------------------------------*
START-OF-SELECTION.

* Fetch Material data
  PERFORM f_get_credit_data.

* Build Report with Data
  PERFORM f_build_report.

*-------------------------------------------------------------------*
*                         End of selection                        *
*-------------------------------------------------------------------*
END-OF-SELECTION.
* Display Alv/ Place in data in AL11
  PERFORM f_display_alv.
