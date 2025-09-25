*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_UPLOAD_TABLE_SALES_REP (Main Program)
* PROGRAM DESCRIPTION: Maintain Sales Rep PIGS Table Lookup
* DEVELOPER: Mintu Naskar (MNASKAR)
* CREATION DATE:   11/04/2016
* OBJECT ID:  E129
* TRANSPORT NUMBER(S):  ED2K903251
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903282
* REFERENCE NO:  E129
* DEVELOPER:  Sarada Mukherjee (SARMUKHERJ)
* DATE:  2016-12-20
* DESCRIPTION: Validation of uploaded data based on Valid-To-Date
* Change Tag :
* BOC by SARMUKHERJ on 19-12-2016 TR#ED2K903282*
* EOC by SARMUKHERJ on 19-12-2016 TR#ED2K903282*
*-----------------------------------------------------------------------*

REPORT zqtcr_upload_table_sales_rep NO STANDARD PAGE HEADING
                                    MESSAGE-ID zqtc_r2.


** INCLUDES-------------------------------------------------------------*

INCLUDE zqtcn_upld_table_sls_rep_top IF FOUND.      "Top Include
INCLUDE zqtcn_upld_table_sls_rep_sel IF FOUND.      "Selection Screen
INCLUDE zqtcn_upld_table_sls_rep_sub IF FOUND.      "Subroutine


*-------------------------------------------------------*
*             AT SELECTION SCREEN                       *
*-------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF rb_upl = c_x AND screen-group1 = c_z1.
      screen-invisible = 0.
      screen-active = 1.
      MODIFY SCREEN.
    ELSEIF rb_dwnl EQ c_x AND screen-group1 = c_z1.
      screen-invisible = 1.
      screen-active = 0.
      MODIFY SCREEN.

    ENDIF. " IF rb_dwnl = c_x AND screen-group1 = 'Z1'
  ENDLOOP. " LOOP AT SCREEN


* AT SELECTION-SCREEN ON VALUE-REQUEST---------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
* F4 Help for File Name (Presentation Server)
  PERFORM f_f4_file_name   CHANGING p_file.                "File Path

* START OF SELECTION---------------------------------------------------*
START-OF-SELECTION.
* Get Excel data in internal table
  IF rb_dwnl NE c_x.
    PERFORM f_convert_excel  USING    p_file                  "File path
                             CHANGING i_final[].              "Input Data (table)
* Data validation
    PERFORM f_validate_data.
* Data processing
    PERFORM f_data_process.
  ENDIF.

END-OF-SELECTION.
  IF rb_dwnl NE c_x.

* Display Data
    PERFORM f_display_data.
  ELSE.
* Download data
    PERFORM f_download_data.
  ENDIF.
