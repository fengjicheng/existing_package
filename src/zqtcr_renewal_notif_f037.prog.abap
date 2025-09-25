*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_RENEWAL_NOTIF_F037
* REPORT DESCRIPTION:    Driver Program for renewal notification
*                       (Tcode-VA22) from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Srabanti Bose (SRBOSE)
* CREATION DATE:         15-Dec-2016
* OBJECT ID:             F037
* TRANSPORT NUMBER(S):   ED2K903748
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   Defect 2544
* REFERENCE NO:  ED2K906494
* DEVELOPER:     PBANDLAPAL & SRBOSE
* DATE:          03/06/2017
* DESCRIPTION:   Incorporating changes in the URL link of email part and
* as well correcting some errors in the program to avoid terminations.
*----------------------------------------------------------------------*
* REVISION NO:   Defect ERP-4186
* REFERENCE NO:  ED2K908365
* DEVELOPER:     PBANDLAPAL
* DATE:          09/05/2017
* DESCRIPTION:   Incorporating changes in the URL link of email part
* where quotation number is not being populated correctly.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_RENEWAL_NOTIF_F037
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_renewal_notif_f037 NO STANDARD PAGE HEADING.
**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_renewal_notif_top.

*********Subroutine for this report
INCLUDE zqtcn_renewal_notif_f00.

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
* Begin of change: PBANDLAPAL: 06-JUN-2017: Defect 2544 : ED2K906494
*  v_ent_retco = 0.
  fp_v_ent_retco = v_retcode.
* End of change: PBANDLAPAL: 06-JUN-2017: Defect 2544 : ED2K906494


ENDFORM.
