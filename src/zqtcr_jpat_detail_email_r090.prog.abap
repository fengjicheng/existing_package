*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_JPAT_REPORT (Main Program)
* PROGRAM DESCRIPTION: Email JPAT Detail Report Email
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/17/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:
*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

REPORT zqtcr_jpat_detail_email_r090.

INCLUDE zqtcn_jpat_detail_email_top.       " Data Declaration

INCLUDE zqtcn_jpat_detail_email_sub.       " Subroutines.

INITIALIZATION.

  "Import data from memory ID to internal table to run the background job
  IMPORT i_view_podetail FROM DATABASE indx(co) ID 'PODATA'.
  FREE MEMORY ID 'PODATA'.

  IMPORT i_view_biosdetail FROM DATABASE indx(co) ID 'BIOS'.
  FREE MEMORY ID 'BIOS'.

  IMPORT i_view_jdrdetail FROM DATABASE indx(co) ID 'JDR'.
  FREE MEMORY ID 'JDR'.

  IMPORT i_view_salesdetail FROM DATABASE indx(co) ID 'SALES'.
  FREE MEMORY ID 'SALES'.

  IMPORT i_view_sohdetail FROM DATABASE indx(co) ID 'SOH'.
  FREE MEMORY ID 'SOH'.

*** Begin of Changes for ED2K916403 ***
  IMPORT i_view_isohdetail FROM DATABASE indx(co) ID 'ISOH'.
  FREE MEMORY ID 'ISOH'.

  IMPORT i_view_jrrdetail FROM DATABASE indx(co) ID 'JRR'.
  FREE MEMORY ID 'JRR'.

  IMPORT i_view_printedis FROM DATABASE indx(co) ID 'PRDISPATCH'.
  FREE MEMORY ID 'PRDISPATCH'.
*** End of Changes for ED2K916403 ***

  IMPORT v_recname FROM DATABASE indx(co) ID 'DSNAME'.
  FREE MEMORY ID 'DSNAME'.

  PERFORM f_get_zcaconstants.
  PERFORM f_set_text_elements.


START-OF-SELECTION.

  PERFORM f_process_xml_data.            " Prepare Excel file
  PERFORM f_get_email.                   " Fetch Sender/receiver Email address
  PERFORM f_send_mail.                   " Send Email.
