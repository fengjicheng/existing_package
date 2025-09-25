*&---------------------------------------------------------------------*
*& Report  ZQTCR_ORDER_PROFORMA_F501
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCR_ORDER_PROFORMA_F501
* REPORT DESCRIPTION:    Driver Program for order proforma
*                        from where the adobe form
*                        has been called and all the logic
*                        are written here.
* DEVELOPER:             Jagadeeswara Rao M (JMADAKA)
* CREATION DATE:         02-May-2022
* OBJECT ID:             F501
* TRANSPORT NUMBER(S):   ED2K927138
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_order_proforma_f501 NO STANDARD PAGE HEADING
                                     MESSAGE-ID zqtc_r2 .
**************************************************************
*                    INCLUDES                                *
**************************************************************
*********To Declare Global DATA
INCLUDE zqtcn_order_pro_top.


*********Subroutine for this report
INCLUDE zqtcn_order_pro_f00.


************************************************************************
*                   Form Routine                                       *
************************************************************************
*** Form routine where all the processings would be done
FORM f_entry_adobe_form USING fp_v_retcode  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                              fp_v_ent_screen TYPE c.       " Ent_screen of type Character

*--------------------------------------------------------------------*
* Local Data Declaration
*--------------------------------------------------------------------*
  DATA: lv_xdruvo TYPE c, " Xdruvo of type Character
        lv_xfz    TYPE c. " Xfz of type Character

*********Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck


  fp_v_retcode = 0.
  v_ent_screen = fp_v_ent_screen.
  IF nast-aende EQ space.
*********Perform where all the processing can be done
    PERFORM f_processing.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space

  fp_v_retcode = v_retcode.

ENDFORM.
