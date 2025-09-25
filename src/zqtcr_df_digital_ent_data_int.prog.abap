*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_DF_DIGITAL_ENT_DATA_INT
* PROGRAM DESCRIPTION: Report to upload a text file onto application
*                      layer for Digital Entitlement Data Interface
*                      sent to TIBCO                                   *
* DEVELOPER:          APATNAIK(Alankruta Patnaik)
* CREATION DATE:      12/27/2016
* OBJECT ID:          I0342
* TRANSPORT NUMBER(S):ED2K903899
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K906458
* REFERENCE NO:  ERP-2509
* DEVELOPER:     Pavan Bandlapalli(PBANDLAPAL)
* DATE:          01-Jun-2017
* DESCRIPTION: To change the Initial Shipping Date(isminitshipdate) to
* publication date(ismpubldate) and Item number in the output should be
* just an incremental number.
*&---------------------------------------------------------------------*
REPORT zqtcr_df_digital_ent_data_int
NO STANDARD PAGE HEADING MESSAGE-ID zqtc_r2.
*======================================================================*
*                          INCLUDES
*======================================================================*
***Includes the declaration of all global variables
INCLUDE zqtcn_digi_data_int_top IF FOUND.
***Includes the selection screen
INCLUDE zqtcn_digi_data_int_sel IF FOUND.
***Includes the logic of the report
INCLUDE zqtcn_digi_data_int_sub IF FOUND.

*======================================================================*
* INITIALIZATION
*======================================================================*
INITIALIZATION.

***Perform to clear the variables
  PERFORM f_clear_var_get_const.
***Perform to populate the file path
  PERFORM populate_path CHANGING p_path.
*======================================================================*
* AT SELECTION-SCREEN
*======================================================================*
  PERFORM f_validate_data.
*======================================================================*
* AT SELECTION-SCREEN ON VALUE REQUEST
*======================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
***Perform for the F4 of the application file
  PERFORM f_value_request_for_appl_file  CHANGING p_path.
*======================================================================*
*                     START-OF-SELECTION
*======================================================================*
START-OF-SELECTION.

* Select all necessary Records
  PERFORM f_fetch_data CHANGING i_vbrk
                             i_but0id
                             i_vbak
                             i_vbpa
                             i_vbfa
                             i_vbap
                             i_vbkd
                             i_jptidcdassign
                             i_mara
                             i_but050
                             i_adrc
                             i_adr6 .

* Process Data to final table
  PERFORM f_process_data USING    i_vbrk
                                  i_but0id
                                  i_vbak
                                  i_vbap
                                  i_vbkd
                                  i_mara
                                  i_but050
                                  i_adrc
                                  i_adr6
                         CHANGING i_final
                                  i_jptidcdassign
                                  i_vbpa
                                  i_vbfa
                                          .

*======================================================================*
*                     END-OF-SELECTION
*======================================================================*
END-OF-SELECTION.
  IF i_final IS NOT INITIAL.
****Uploading data
    PERFORM f_upload_data.
  ELSE.
    MESSAGE s006.
  ENDIF.
