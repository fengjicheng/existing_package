*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_ICEDIS_OUTBOUND_FTP                       *
* PROGRAM DESCRIPTION: Report to upload a text file onto application   *
*                      layer for ICEDIS Outbound file - FTP Agents     *
* DEVELOPER:          NMOUNIKA                                         *
* CREATION DATE:      06/27/2017                                       *
* OBJECT ID:          I0352                                            *
* TRANSPORT NUMBER(S):ED2K903899                                       *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:    ED2K912399                                           *
* REFERENCE NO:   CR#6689/6609                                         *
* DEVELOPER:      SCBEZAWADA                                           *
* DATE:           06/22/2018                                           *
* DESCRIPTION:    To handle User Interface and BOM related Changes     *
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:                                                         *
* REFERENCE NO:                                                        *
* DEVELOPER:                                                           *
* DATE:                                                                *
* DESCRIPTION:                                                         *
*&---------------------------------------------------------------------*
REPORT zqtcr_icedis_outbound_ftp NO STANDARD PAGE HEADING MESSAGE-ID
zqtc_r2.
*======================================================================*
*                          INCLUDES
*======================================================================*
***Includes the declaration of all global variables
INCLUDE zqtcn_icedis_top IF FOUND. " Include ZQTCN_ICEDIS_TOP
***Includes the selection screen
INCLUDE zqtcn_icedis_sel IF FOUND. " Include ZQTCN_ICEDIS_SEL
***Includes the logic of the report
INCLUDE zqtcn_icedis_sub IF FOUND. " Include ZQTCN_ICEDIS_SUB

*======================================================================*
* INITIALIZATION
*======================================================================*
INITIALIZATION.
***Perform to clear the variables
  PERFORM f_clear_var_get_const.
***Perform to populate the file path
  PERFORM f_populate_path CHANGING p_path
                                 i_zcaconstant.
*======================================================================*
* AT SELECTION-SCREEN
*======================================================================*
AT SELECTION-SCREEN.
  IF rb_app NE abap_true.
* BOC CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
    clear p_path.
    p_path = v_path.
* EOC CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399

  ELSE. " ELSE -> IF rb_app NE abap_true
*    IF p_path IS INITIAL. " commented by CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
      p_path = v_filepath.
*    ENDIF. " IF p_path IS INITIAL " commented by CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
  ENDIF. " IF rb_app NE abap_true
  PERFORM f_validate_data.

*======================================================================*
* AT SELECTION-SCREEN ON VALUE REQUEST
*======================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
***Perform for the F4 of the application file
  IF rb_app EQ abap_true.
    PERFORM f_value_request_for_appl_file  CHANGING p_path.
  ELSE. " ELSE -> IF rb_app EQ abap_true
    PERFORM f_value_req_pres               CHANGING p_path.
    v_path = p_path." Added to pass path to the variable CR#6689:22 Jun 2018:SCBEZAWADA:ED2K912399
  ENDIF. " IF rb_app EQ abap_true

*======================================================================*
*                     START-OF-SELECTION
*======================================================================*
START-OF-SELECTION.
* Select all necessary Records
  PERFORM f_fetch_data CHANGING i_mara
                                i_vapma
                                i_vbpa
                                i_vbkd
                                i_jptidcdassign
                                i_zcaconstant.

* Process Data to final table
  PERFORM f_process_data USING i_mara
                               i_vapma
                               i_vbpa
                               i_vbkd

                      CHANGING i_final
                        i_jptidcdassign.

*======================================================================*
*                     END-OF-SELECTION
*======================================================================*
END-OF-SELECTION.
  IF i_final IS NOT INITIAL.
****Uploading data
    IF rb_app EQ abap_true.
      PERFORM f_upload_data. "Application server
    ELSE. " ELSE -> IF rb_app EQ abap_true
      PERFORM f_upload_data_ps.
    ENDIF. " IF rb_app EQ abap_true
  ELSE. " ELSE -> IF i_final IS NOT INITIAL
    MESSAGE s006. " No data was found for your request
  ENDIF. " IF i_final IS NOT INITIAL
