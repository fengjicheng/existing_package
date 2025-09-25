*&---------------------------------------------------------------------*
*& Report  ZQTCR_ORDER_EMAIL_NOTIF_F057
*&
*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_ORDER_EMAIL_NOTIF_F057
* PROGRAM DESCRIPTION:   Program to send advance course welcome email
* DEVELOPER:             VDPATABALL
* CREATION DATE:         11/06/2019
* OBJECT ID:             F057(ERPM-4157)
* TRANSPORT NUMBER(S):   ED2K916730
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_order_email_notif_f057 NO STANDARD PAGE HEADING MESSAGE-ID zqtc_r2.

**************************************************************
*                    INCLUDES                                *
**************************************************************
**Include for Global Data Declaration
INCLUDE zqtcn_order_email_notif_f057_t.

*********Subroutine for this report
INCLUDE zqtcn_order_email_notif_f057_f.




START-OF-SELECTION.

*** Form routine where all the processings would be done
FORM f_send_email USING fp_v_retcode    LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                        fp_v_ent_screen TYPE c.       " Ent_screen of type Character

*--------------------------------------------------------------------*
* Local Data Declaration
*--------------------------------------------------------------------*
  DATA: lv_xdruvo TYPE c, " Xdruvo of type Character
        lv_xfz    TYPE c. " Xfz of type Character

*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck
  FREE:lv_xdruvo,lv_xfz.

  fp_v_retcode = 0.
  v_ent_screen = fp_v_ent_screen.
  IF nast-aende EQ space.
*-----Perform where all the processing can be done
    PERFORM f_processing.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space

  fp_v_retcode = v_retcode.

ENDFORM.
