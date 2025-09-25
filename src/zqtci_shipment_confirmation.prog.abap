*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCI_SHIPMENT_CONFIRMATION
* PROGRAM DESCRIPTION: Interface to post goods reciept in reference
*  to PO using inbound deliverables and post goods issue for outbound
*  delivery
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2016-12-23
* OBJECT ID: I0256
* TRANSPORT NUMBER(S):ED2K903891(W)/ED2K903977(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K906177
* Reference No:  CR# 456
* Developer: Monalisa Dutta
* Date:  2017-05-19
* Description: To comment the code related to Goods Issue as we will be
*              doing only GR in this wricef.
*              To ensure multiple files are selected directly from the
*              folder instead of a single file.
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Nageswara (NPOLINA)
* Date:  2020-01-06
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
* Revision History-----------------------------------------------------*
* Revision No: ED1K912595
* Reference No:  PRB0047015
* Developer: Nikhilesh Palla (NPALLA)
* Date:  2021-01-15
* Description: Capture only Errors in AL11 file
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*& Report  ZQTCI_SHIPMENT_CONFIRMATION
*&
*&---------------------------------------------------------------------*
REPORT zqtci_shipment_confirmation  NO STANDARD PAGE HEADING
                                    LINE-SIZE  132
                                    LINE-COUNT 65
                                    MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_shpmnt_confrmation_top. " For top declaration

*Include for Selection Screen
INCLUDE zqtcn_shpmnt_confrmation_sel. " For selection screen

*Include for Subroutines
INCLUDE zqtcn_shpmnt_confrmation_f01. " For subroutines
*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate constants from ZCACONSTANT table
  PERFORM f_get_constants CHANGING i_constant.
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON VALUE REQUEST                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  IF rb_appl IS INITIAL. "Presentation Server
    PERFORM f_f4_presentation USING   syst-cprog
                                      c_field
                             CHANGING p_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM f_f4_application CHANGING p_file.
  ENDIF. " IF rb_appl IS INITIAL

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                                   *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF sy-ucomm = c_rucomm. "'RUCOMM'.
    CLEAR p_file.
  ELSEIF sy-ucomm = c_onli. "'ONLI'.
    IF rb_appl IS INITIAL. "Presentation Server
      PERFORM f_validate_presentation USING p_file.
    ELSE. " ELSE -> IF rb_appl IS INITIAL
      PERFORM f_validate_application  USING p_file.
    ENDIF. " IF rb_appl IS INITIAL
  ENDIF. " IF sy-ucomm = c_rucomm
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
  IF rb_appl IS INITIAL.
    PERFORM  f_read_file_frm_pres_server USING    p_file
                                         CHANGING i_upload_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM  f_read_file_frm_app_server  USING    p_file
                                         CHANGING i_upload_file.
  ENDIF. " IF rb_appl IS INITIAL

*  Remove the header line
  IF cb_hdr IS NOT INITIAL.
    DELETE i_upload_file WHERE lodgement_date CA sy-abcde
                           OR  pub_set CA sy-abcde.
  ENDIF. " IF cb_hdr IS NOT INITIAL

*  Set IDOC control structure
  PERFORM f_set_edidc_po CHANGING st_edidc_po.

* Build IDOC for posting GR
  PERFORM f_build_idoc_gr USING st_edidc_po
                          CHANGING i_upload_file
                                   i_output_det.
****---Code Comment by Pavan************
*  READ TABLE i_output_det WITH KEY type = c_error TRANSPORTING NO FIELDS.
*  IF sy-subrc NE 0.
*<<<<<<<<<<<<<<<<Begin of comment by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>
*  Set idoc control structure for SO
*  PERFORM f_set_edidc_so CHANGING st_edidc_so.
*
** Build IDOC for creating outbound delivery and posting GI
*  PERFORM f_build_idoc_gi USING i_ekkn
*                                st_edidc_so
**                                i_upload_file
*                          CHANGING i_output_det.
**<<<<<<<<<<<<<<<<<End of comment by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>
*****************************************************************************

*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
  IF i_output_det IS NOT INITIAL.
*    Perform to get MSEG details
    PERFORM f_get_mseg_det CHANGING i_output_det.
  ENDIF.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 19/05/2017 for CR# 456>>>>>>>>>>>>>>>>>>>>>>>>>>>
  IF i_output_det IS INITIAL.
    MESSAGE i015(zqtc_r2). "No data found to display
    LEAVE LIST-PROCESSING.
  ELSE.
* Upload file in application server
*BOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
*    PERFORM f_write_to_app_server USING i_output_det.  "--ED1K912595
    IF i_output_det_err[] IS NOT INITIAL.               "++ED1K912595
      PERFORM f_write_to_app_server USING i_output_det_err. "++ED1K912595
    ENDIF.                                              "++ED1K912595
*EOC by NPALLA PRB0047015 15-Jan-2021 ED1K912595
*SOC by NPOLINA ERPM2204 06-Jan-2020 ED2K917189
   IF s_email IS NOT INITIAL.
    PERFORM f_send_email USING i_output_det.
   ENDIF.
*EOC by NPOLINA ERPM2204 06-Jan-2020 ED2K917189
*  Display output
    PERFORM f_display_output USING i_output_det.
  ENDIF.
