*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTC_PARTNERS_UPDATE
* PROGRAM DESCRIPTION: Update ZY (Master License Owner) Partners in
*                      Order / Contract Headers
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2018-08-13
* OBJECT ID: ERP-6593
* TRANSPORT NUMBER(S): ED2K913026
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*& Report  ZQTC_PARTNERS_UPDATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_partners_update NO STANDARD PAGE HEADING
                            MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_partners_update_top. " For top declaration

**Include for Selection Screen
INCLUDE zqtcn_partners_update_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_partners_update_f01. " For subroutines
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.

* Populate constants from ZCACONSTANT table
*  PERFORM f_get_constants CHANGING i_constant.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON VALUE REQUEST                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_p_file.
*  Get file from presentation server
  PERFORM f_f4_presentation USING   syst-cprog
                                    c_field
                           CHANGING p_p_file.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_a_file.
*  Get application server path where file to be saved
  PERFORM f_f4_application CHANGING p_a_file.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                                   *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
*  Validate presentation server path
  PERFORM f_validate_presentation USING p_p_file.
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
*   Get file from presentation server to internal table
  PERFORM  f_read_file_frm_pres_server USING    p_p_file
                                       CHANGING i_upload_file.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-004. "Reading data from file

  IF i_upload_file IS NOT INITIAL.
*   Save the file to application server
    PERFORM f_save_file_app_server USING i_upload_file
                                   CHANGING p_a_file.

    PERFORM f_batch_job.
    i_mail[] = p_mail[].
    PERFORM f_partnr_update_with_new_value USING   p_recon
                                                   p_user
                                                   p_job
                                         CHANGING  i_excel_file
                                                   i_mail.
  ENDIF. " IF i_upload_file IS NOT INITIAL
