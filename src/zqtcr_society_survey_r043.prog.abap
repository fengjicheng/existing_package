*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SOCIETY_SURVEY_R043
* PROGRAM DESCRIPTION: Society Survey options Report
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-04-26
* OBJECT ID:       R043
* TRANSPORT NUMBER(S): ED2K904138
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K905728
* REFERENCE NO:  ERP-2854
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-06-19
* DESCRIPTION: Header texts for CSV file has been changed as per the
* requirement.
*-------------------------------------------------------------------
* REVISION NO: ED2K907530
* REFERENCE NO:  ERP-3472
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-26
* DESCRIPTION: Salutation should have the description instead of number.
*              same has been fixed. Member Category Desc was having an
*              issue in reading BINARY search and hence used SORT to work.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_SOCIETY_SURVEY_R043
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_society_survey_r043 LINE-SIZE 165
                                 LINE-COUNT 65
                                 MESSAGE-ID zqtc_r2
                                 NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_society_survey_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtcn_society_survey_sel IF FOUND.

*Include for Subroutines
INCLUDE zqtcn_society_survey_f01 IF FOUND.

*----------------------------------------------------------------------*
*                            INITIALIZATION                            *
*----------------------------------------------------------------------*
INITIALIZATION.
**********************************************************************
* Populating default values in Selection Screen
**********************************************************************

  PERFORM f_populate_defaults CHANGING s_sub[]
                                       s_doc[]
                                       s_erdat[].      " Added by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689



* Clear all global variables .
  PERFORM f_clear_all.
*----------------------------------------------------------------------*
*                     AT-SELECTION SCREEN OPUTPUT                      *
*----------------------------------------------------------------------*
**validate selection screen
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_screen.

*----------------------------------------------------------------------*
*                            AT-SELECTION SCREEN                       *
*----------------------------------------------------------------------*
* Validate Society BP Number
AT SELECTION-SCREEN ON s_bp.
  PERFORM f_val_partner USING s_bp[].

* Validate Relationship Category
AT SELECTION-SCREEN ON s_rel.
  PERFORM f_val_reltyp USING s_rel[].

* Validate Subscription Type
AT SELECTION-SCREEN ON s_sub.
  PERFORM f_val_subtyp USING s_sub[].

* Validate Document Category
AT SELECTION-SCREEN ON s_doc.
  PERFORM f_val_doccat USING s_doc[].

* Validate Purchase Order Type
AT SELECTION-SCREEN ON s_po.
  PERFORM f_val_potype USING s_po[].

*----------------------------------------------------------------------*
*            AT-SELECTION SCREEN  ON VALUE REQUEST                     *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file. "Society Survey file
* Presentation Server Radiobutton is selected
  IF rb_prs IS NOT INITIAL.
    PERFORM f_pres_f4 USING p_file.
  ELSE. " ELSE -> IF rb_prs IS NOT INITIAL
* Application Server Radiobutton is selected
    PERFORM f_app_f4 USING p_file.
  ENDIF. " IF rb_prs IS NOT INITIAL

*----------------------------------------------------------------------*
*                           START-OF-SELECTION                         *
*----------------------------------------------------------------------*
START-OF-SELECTION.
  IF rb_save EQ abap_true.
***Perform to e filepath mandatory
    PERFORM f_chck_file USING p_file.

  ENDIF.

**Perform to fetch all required data
  PERFORM f_fetch_data USING s_bp[]
                             s_rel[]
                             s_sub[]
                             s_doc[]
                             s_erdat[]   " p_date changed to s_erdat[] by Lahiru on 04/17/2020 with ED2K918013 for ERPM-14689
                             s_po[]
                    CHANGING i_tab_final.

*----------------------------------------------------------------------*
*                           END-OF-SELECTION                           *
*----------------------------------------------------------------------*
END-OF-SELECTION.

  IF i_tab_final IS NOT INITIAL.

*Sub routine to prepare the CSV file
    PERFORM f_prepare_csv USING i_tab_final
                        CHANGING i_final_csv.

    IF rb_dis EQ abap_true.
*Sub Routine to display ALV file of the report generated
      PERFORM f_display_output USING i_tab_final[].

    ELSE. " ELSE -> IF rb_dis EQ abap_true
      IF rb_app EQ abap_true.
        PERFORM f_upload_file_app USING i_final_csv[]
                                        p_file.
      ELSE. " ELSE -> IF rb_app EQ abap_true
        PERFORM f_upload_file_pres USING i_final_csv[]
                                         p_file.
      ENDIF. " IF rb_app EQ abap_true
    ENDIF. " IF rb_dis EQ abap_true

  ENDIF. " IF i_tab_final IS NOT INITIAL
