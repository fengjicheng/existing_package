*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_JPAT_REPORT (Main Program)
* PROGRAM DESCRIPTION: Email JPAT Sumary report Email
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156
*----------------------------------------------------------------------*

REPORT zqtcr_jpat_summary_email_r090.

INCLUDE zqtcn_jpat_summary_email_top.       " Data Declaration

INCLUDE zqtcn_jpat_summary_email_sub.       " Subroutines.

INITIALIZATION.

  "Import data from memory ID to internal table to run the background job
  IMPORT i_year FROM DATABASE indx(co) ID 'YEAR'.
  FREE MEMORY ID 'YEAR'.

  IMPORT i_summary_data FROM DATABASE indx(co) ID 'SDATA'.
  FREE MEMORY ID 'SDATA'.

  IMPORT v_headername FROM DATABASE indx(co) ID 'HEADER'.
  FREE MEMORY ID 'HEADER'.

  IMPORT v_recname FROM DATABASE indx(co) ID 'SNAME'.
  FREE MEMORY ID 'SNAME'.

  PERFORM f_get_zcaconstants.
  PERFORM f_set_text_elements.


START-OF-SELECTION.

  PERFORM f_process_xml_data.            " Prepare Excel file
  PERFORM f_get_email.                   " Fetch sender/receiver email address
  PERFORM f_send_mail.                   " Send Email.
