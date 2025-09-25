*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_RENEWAL_NOTICE_F035
* REPORT DESCRIPTION:    Driver Program for renewal notification
*                       (Tcode-VA22) from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Srabanti Bose (SRBOSE)
* CREATION DATE:         11-Jan-2017
* OBJECT ID:             F035
* TRANSPORT NUMBER(S):   ED2K904080
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904800
* REFERENCE NO:  ED2K905714
* DEVELOPER: Monalisa Dutta
* DATE:  04/24/2017
* DESCRIPTION: Addition of E098 FM to send multiple attachment in an email
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_RENEWAL_NOTIF_F035
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_renewal_notice_f035 NO STANDARD PAGE HEADING.
**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_renewal_notice_top.
*INCLUDE zqtcn_renewal_notif_top.

*********Subroutine for this report
INCLUDE zqtcn_renewal_notice_f00.
*INCLUDE zqtcn_renewal_notif_f00.

**************************************************************
*                   Form Routine                             *
**************************************************************
*******This form routine has been done where all processing are done
FORM f_entry_adobe_form USING fp_v_ent_retco  LIKE sy-subrc
                              fp_v_ent_screen TYPE c.

*--------------------------------------------------------------------*
* Local Data Declaration
*--------------------------------------------------------------------*
  DATA: lv_xdruvo TYPE c,
        lv_xfz    TYPE c.

*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1',   "Neudruck
             lc_prntev_chg TYPE c VALUE '2'.   "Änderungsdruck

  v_retcode = 0.
  v_ent_screen = fp_v_ent_screen.
  IF nast-aende EQ space.
*********Perform where all the processing can be done
    PERFORM f_processing.
    lv_xdruvo = lc_prntev_new.
  ELSE.
    lv_xdruvo = lc_prntev_chg.
  ENDIF.
* Begin of change: SRBOSE: 06-JUL-2017:  ED2K907341
*  v_ent_retco = 0.
  fp_v_ent_retco =  v_retcode.
* End of change: SRBOSE: 06-JUL-2017:  ED2K907341
ENDFORM.
