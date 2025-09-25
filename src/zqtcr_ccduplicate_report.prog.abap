*&---------------------------------------------------------------------*
*& Report  ZQTCR_CCDUPLICATE_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_ccduplicate_report NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2..

INCLUDE zqtcn_ccdup_top  IF FOUND. "constants declaration

INCLUDE zqtcn_ccdup_sel IF FOUND. "selection screen

INCLUDE zqtcn_ccdup_sub IF FOUND. "subroutines


*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

AT SELECTION-SCREEN OUTPUT.
  IF rb_cel IS NOT INITIAL OR rb_amx IS NOT INITIAL OR rb_wrk IS NOT INITIAL.
    CLEAR:p_file.
  ENDIF.

START-OF-SELECTION.
  IF p_file IS NOT INITIAL.

*    Upload Excel data
    PERFORM f_convert_excel  USING    p_file  .   "File path


    IF rb_cel IS NOT INITIAL.   " Cleintline
*            Process uploaded data
      PERFORM sub_check_clientline.

    ELSEIF rb_amx IS NOT INITIAL. " Amex Pay
*            Process uploaded AMEX data
      PERFORM sub_check_amex.
    ELSEIF rb_wrk IS NOT INITIAL.  " Worldpay
*            Process uploaded data
      PERFORM sub_check_worldpay.
    ENDIF.

  ENDIF.

END-OF-SELECTION.

  PERFORM f_list_display.
