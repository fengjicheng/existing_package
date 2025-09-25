*&---------------------------------------------------------------------*
*& Report  ZQTCR_SEND_AC_NOTIFCATION_R095
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916407
* REFERENCE NO:  R095
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-10-09
* DESCRIPTION:   Advancement Courses needs to send out emails to the
*    students who have purchased their courses to remind them of the
*    upcoming end date or to inform them that their course has ended
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916407
* REFERENCE NO:  R095
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-01-11
* DESCRIPTION:   1.	When header entry and no items in VEDA with orders,
*                   in such case consider all items of that contract
*                   need to be send notification.
*                2.	Set the VSTAT value to zero and update in NAST.
*                3.	Product name use the sales text, use the logic below.
*                   a. Use the READ_TEXT to get the sales text where
*                      i.	TEXTNAME = Material + sales office + distribution
*                      ii.  Lang = sy-langu
*                      iii.	Text id = ‘0001’
*                      iv.  Text object = ‘MVKE’.
*----------------------------------------------------------------------*
* REVISION NO:   ED2K916969
* REFERENCE NO:  JIRA_8127-R095
* DEVELOPER:     Mohammed Aslam (AMOHAMMED)
* DATE:          2019-02-12
* DESCRIPTION:   Material 'Sales text' is missing in removal
*                notification email
*----------------------------------------------------------------------*
REPORT zqtcr_send_ac_notifcation_r095.
*&---------------------------------------------------------------------*
*---------------------------- INCLUDES USED----------------------------*
*
* INCLUDE ZQTCN_SEND_AC_NOTIF_R095_TOP             "Declarations
*
*----------------------------------------------------------------------*
INCLUDE zqtcn_send_ac_notif_r095_top.
*
* INCLUDE ZQTCN_SEND_AC_NOTIF_R095_SCR             "Selection Screen
*
*----------------------------------------------------------------------*
INCLUDE zqtcn_send_ac_notif_r095_scr.
*
* INCLUDE ZQTCN_SEND_AC_NOTIF_R095_F01             "Subroutines
*
*----------------------------------------------------------------------*
INCLUDE zqtcn_send_ac_notif_r095_f01.

*-------------------------------INITIALIZATION-------------------------*
INITIALIZATION.
  PERFORM f_grade_range_restrict.

*----------------AT SELECTION SCREEN ON P_MAILTY------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_mailty.
  PERFORM f_p_mailty.

START-OF-SELECTION.
  IF p_mailty EQ c_rem AND so_grade-low IS NOT INITIAL. " Please leave grade value blank for reminder emails
    IF sy-batch EQ c_x.
      MESSAGE text-020 TYPE c_i.
    ELSE.
      MESSAGE text-020 TYPE c_w.
    ENDIF.
  ELSEIF p_mailty EQ c_une AND so_grade-low IS INITIAL. " Please select the grade for unenrollment emails
    IF sy-batch EQ c_x.
      MESSAGE text-021 TYPE c_i.
    ELSE.
      MESSAGE text-021 TYPE c_w.
    ENDIF.
  ELSE.
    PERFORM f_processing_logic.
  ENDIF.

*---------------------------- INCLUDES USED----------------------------*
*
* INCLUDE ZQTCN_SEND_AC_NOTIF_R095_F02             "Subroutines
*
*----------------------------------------------------------------------*
  INCLUDE zqtcn_send_ac_notif_r095_f02.

*---------------------------------------------------------------------*
*       FORM F_SEND_AC_NOTIF
*---------------------------------------------------------------------*
FORM f_send_ac_notif USING return_code us_screen.
  DATA: lf_retcode TYPE sy-subrc.
  CLEAR retcode.
  xscreen = us_screen.
  DATA lo_notif TYPE REF TO lcl_send_ac_notif. " Report Object reference
  CREATE OBJECT lo_notif.
  CALL METHOD lo_notif->meth_send_mail
    EXPORTING
      im_nast    = nast
      im_screen  = us_screen
    CHANGING
      ch_retcode = lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.
ENDFORM.                    "F_SEND_AC_NOTIF
