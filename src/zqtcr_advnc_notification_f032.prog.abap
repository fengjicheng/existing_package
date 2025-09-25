*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_ADVNC_NOTIFICATION_F032
* REPORT DESCRIPTION:    Driver Program for renewal notification
*                       (Tcode-VA23) from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Aratrika Banerjee (ARABANERJE)
* CREATION DATE:         26-Dec-2016
* OBJECT ID:             F032
* TRANSPORT NUMBER(S):   ED2K903799
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905635
* REFERENCE NO:  ED2K905635 for E098
* DEVELOPER: Monalisa Dutta
* DATE:  04/25/2017
* DESCRIPTION: Addition of E098 FM's for mail sending and saving in
* application server
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906742
* REFERENCE NO:  CR 439
* DEVELOPER: Aratrika Banerjee
* DATE:  08/09/2017
* DESCRIPTION: Addition of BarCode
*----------------------------------------------------------------------*
* REVISION NO: ED2K908563
* REFERENCE NO: ERP-3402
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  09/11/2017
* DESCRIPTION: Material description should be taken from READ_TEXT for the
*              digital and print materials. Adjusted the code to display
*              country in the bill to address when company code country
*              and bill to customer country are different.
*----------------------------------------------------------------------*
* REVISION NO:  ED2K913178
* REFERENCE NO: ERP-7119
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  09/12/2018
* DESCRIPTION: Need to make the following change on text change on the form.
*              Add in Subscription Term (as we have on F037)
*----------------------------------------------------------------------*
* REVISION NO:  ED2K913739
* REFERENCE NO: ERP-7189 and 7431
* DEVELOPER: Siva Guda(SGUDA)
* DATE:  11/05/2018
* DESCRIPTION: Need to replace MOD10 function module with MOD11
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO:  ED2K919534
* REFERENCE NO: OTCM-26071
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE:  17/09/2020 (DD/MM/YYYY)
* DESCRIPTION: Greman Translation Changes
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_ADVNC_NOTIFICATION_F032
*&
*&---------------------------------------------------------------------*

REPORT zqtcr_advnc_notification_f032 NO STANDARD PAGE HEADING.

**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA

INCLUDE zqtcn_advnc_notif_top IF FOUND.

*********Subroutine
INCLUDE zqtcn_advnc_notif_f00 IF FOUND.

**************************************************************
*                   Form Routine                             *
**************************************************************
*This form routine has been done where all processing are done

FORM f_entry_adobe_f032 USING fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                              fp_v_ent_screen TYPE c.     " Ent_screen of type Character

*--------------------------------------------------------------------*
* Local Data Declaration
*--------------------------------------------------------------------*
  DATA: lv_xdruvo TYPE c. " Xdruvo of type Character

*--------------------------------------------------------------------*
* Local Constant Declaration
*--------------------------------------------------------------------*

  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

  v_retcode = 0.
  v_ent_screen = fp_v_ent_screen.
  IF nast-aende EQ space.
* Subroutine where all the processing can be done
    PERFORM f_processing.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space

  fp_v_ent_retco = v_retcode.

ENDFORM.
