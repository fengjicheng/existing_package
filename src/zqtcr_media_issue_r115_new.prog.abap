*&---------------------------------------------------------------------*
*& Report  ZQTCR_MEDIA_ISSUE_R115_NEW
* PROGRAM DESCRIPTION: Media Issue Cockpit
* DEVELOPER: Krishna Srikanth J (KSRIKANTH)
* CREATION DATE:   12 July, 2021
* OBJECT ID:  R115
* REFERENCE NO: OTCM-45437
* TRANSPORT NUMBER(S):ED2K924056
* DESCRIPTION : Media Issue cockpit dashboard selection-screen field changes
       "        and copied from Old cockpit program*
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO :
* REFERENCE NO:
* DEVELOPER   :
* DATE        :
* DESCRIPTION :
*----------------------------------------------------------------------*

REPORT zqtcr_media_issue_r115_new.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcr_med_iss_r115_new_top.

*Include for Selection Screen
INCLUDE zqtcr_med_iss_r115_new_sel.

*Include for Subroutines
INCLUDE zqtcr_med_iss_r115_new_sub.

*&---------------------------------------------------------------------*
*&    initialization
*&---------------------------------------------------------------------*
INITIALIZATION.
*
** Populate the Contract Validity From date
*  s_vdat-sign = 'I'.
*  s_vdat-option = 'BT'.
*  s_vdat-low = sy-datum.
*  s_vdat-high = sy-datum.
*  APPEND s_vdat TO s_vdat.

  PERFORM f_get_constant_values.            " Fetch constant values
  PERFORM f_populate_defaults.              " Set default values.

*************************************************************************************
***AT SELECTION-SCREEN.
***  IF c_exbb IS INITIAL AND c_exdb IS INITIAL AND c_excb IS INITIAL AND c_excc IS INITIAL AND c_exro IS INITIAL AND c_irel IS INITIAL AND c_rbg IS INITIAL.
***    MESSAGE 'Select Atleast One Processing Option'(s03) TYPE 'E'.
***  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_alv_vr.
  PERFORM f_alv_variant_value_request CHANGING p_alv_vr.


*&---------------------------------------------------------------------*
*&    start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

* Validation to check if either of Media Issue or Product or Pub Date is selected
  IF s_prod[] IS INITIAL AND s_issu[] IS INITIAL AND s_pbdt[] IS INITIAL AND s_indt[] IS INITIAL AND s_dldt IS INITIAL.
    MESSAGE s023(zren) WITH lc_msg1 lc_msg3 lc_msg4 lc_msg5 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  PERFORM f_validate_alv_variant USING p_alv_vr.
  PERFORM f_check_row_count.                        " Check the row count
  IF sy-batch = abap_false AND rb_bgr = abap_true.
    PERFORM f_create_bg_process.
  ENDIF.

  IF sy-batch = abap_true AND rb_bgr = abap_true.   " Skip the data fetch from foreground once submitted to the background
    PERFORM f_get_data.
  ELSEIF rb_fgr = abap_true.
    PERFORM f_get_data.
  ENDIF.

*&---------------------------------------------------------------------*
*&    end-of-selection.
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  IF rb_fgr = abap_true.                                 " Foreground process
    PERFORM f_build_fieldcatalog.
    PERFORM f_build_layout.
    PERFORM f_list_display.
  ELSEIF sy-batch = abap_true AND rb_bgr = abap_true.    " Background process
    PERFORM f_generate_bg_file.
    PERFORM f_get_email.
    PERFORM f_send_mail.
  ELSE.
    MESSAGE s589(zqtc_r2) WITH text-014 .
  ENDIF.
