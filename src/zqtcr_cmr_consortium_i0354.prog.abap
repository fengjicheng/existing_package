*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_CMR_UPLD_CONSORTIUM
* PROGRAM DESCRIPTION : Credit Memo Request Upload Consortium
* DEVELOPER           : Siva Guda (SGUDA)
* CREATION DATE       : 05/21/2018
* OBJECT ID           : I0354
* TRANSPORT NUMBER(S) : ED2K912156
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K913528                                              *
* REFERENCE NO: ERP7774                                               *
* DEVELOPER: Prabhu (PTUFARAM)                                *
* DATE:  15-Oct-2018                                                   *
* DESCRIPTION: Incorporated BOM changes *
*----------------------------------------------------------------------*
REPORT zqtcr_cmr_upld_consortium NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*-*Below Include is used to declare all the variables
INCLUDE zqtc_cmr_upld_consortium_top IF FOUND.
*--*Below Include is used to declare Selection screen
INCLUDE zqtc_cmr_upld_consortium_sel IF FOUND.
*--* Below Include is used For  allsubroutines
INCLUDE zqtc_cmr_upld_consortium_sub IF FOUND.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
*--*The Below Subroutine is used to alter Customer PO input
  PERFORM f_po_dynamics .
*--*Below Subroutine is used to initialize selection screen varaibles
*--*And refresh global varaibles
  PERFORM f_initialization.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
*-* The below Subroutine is used to change selection screen dynamics.
  PERFORM f_screen_dynamics_01.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*--*Below subroutine is used to provide F4 help to file input parameter
  PERFORM f_f4_file_name   CHANGING p_file . "File Path
*====================================================================*
* A T  S E L E C T I O N  S C R E E N
*====================================================================*
AT SELECTION-SCREEN.
*--*Below Subroutine is used to validate input billing document number
  PERFORM f_validate_inv.
*--*Below Subroutine is used to validate input contract document number
  PERFORM f_validate_so.
*--*Below Subroutine is used to validate input customer number
  PERFORM f_validate_sp.

*====================================================================*
* S T A R T - O F - S E L E C T I O N.
*====================================================================*
START-OF-SELECTION.
*--*If User selects Download radio button
  IF rb_ucmr IS INITIAL AND rb_dcmr IS NOT INITIAL.
*--*Below Subroutine is used to fetch all the required data of input selection.
    PERFORM f_get_data.
    IF rb_upd_m = space.
*--*Below Subroutine is used to display data when user selects Download/forground
      PERFORM f_disp_alv_rpt.
    ELSE.
*--*Check whether email entered or not
      PERFORM f_check_email_entered.
*--*Below Subroutine is used to send data via Email when user selects Download/Background
      PERFORM f_send_email_with_excel.
      MESSAGE s000(zqtc_r2) WITH text-100.
    ENDIF.
  ELSE.
*--*Data upload for CMR creation
*--*Below Subroutine is used to upload file from Presentation server
    PERFORM f_convert_crme_crt_excel USING p_file.
*--* If User selects Background radio button in Upload process
    IF rb_bg_m = c_x.
*--*Check whether email enterd or not
      PERFORM f_check_email_entered.
*--*Below Subroutine is used to place the file into application server
      PERFORM f_file_place_into_app.
*--*Below subroutine is used to schedule JOB in background of second
*--*Consortium Program which is used to create Credit memo requests
      PERFORM f_batch_job.
    ELSEIF rb_fg_m = c_x.
*--*Below Subroutine is used to Create Credit memo requests.
      PERFORM f_fill_cmr TABLES i_final_crme_crt p_mail.
    ENDIF.
  ENDIF.
