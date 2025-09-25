*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_INVENTORY_RECON_DATA (Main Program)
* PROGRAM DESCRIPTION: Inventory Reconciliation Data
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   12/22/2016
* OBJECT ID:  I0315
* TRANSPORT NUMBER(S): ED2K903838
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K905592
* Reference No:  CR#378
* Developer: Pavan Reddy
* Date:  2017-04-06
* Description: Added new fields for media product(ISMREFMDPROD), Media Issue
* Year(ISMYEARNR), First GR date(ZFGRDAT), Latest GR date(ZLGRDAT),
* Purchasing Doc Number(EBELN), Material Document(MBLNR), Idoc Number(XBLNR),
* Goods Issue Idoc Number(ZGI_DOCNUM) in table ZQTC_INVEN_RECON. Also the
* necessary logic to populate the data for these fields.
* Also cleared the code related to presentation server as it was not needed.
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED1K908833
* Reference No: RITM0079465
* Developer: Rajasekhar.T (RBTIRUMALA)
* Date: 26/10/2018
* Description: Populate the Mail date = System Date and  Transaction Date =
* MM/DD/YYYY only based on Application Server File Data
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED1K908833
* Reference No: INC0223402
* Developer: Rajasekhar.T (RBTIRUMALA)
* Date: 31/01/2018
* Description: To Transfer files from ERR To PRC folder, if the File has
* NO data found
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED1K909811
* Reference No: INC0236567
* Developer: Rajasekhar.T (RBTIRUMALA)
* Date: 28/03/2019
* Description: Corrected BIOS Date based on File Data
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Gopalakrishna (GKAMMILI)
* Date:  2020-01-13
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
REPORT zqtci_inventory_recon_data NO STANDARD PAGE HEADING
                                  MESSAGE-ID zqtc_r2.
** INCLUDES-------------------------------------------------------------*
INCLUDE zqtcn_inventory_recon_data_top IF FOUND.
INCLUDE zqtcn_inventory_recon_data_sel IF FOUND.
INCLUDE zqtcn_inventory_recon_data_sub IF FOUND.

*====================================================================*
* Initialization
*====================================================================*
INITIALIZATION.
  PERFORM f_clear_all_global.

*====================================================================*
* At Selection Screen on Value Request
*====================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_drctry.

*F4 validation for application server
  PERFORM f_serverfile_f4 USING p_drctry.

*====================================================================*
* Start of Selection
*====================================================================*
START-OF-SELECTION.
  IF rb_soh EQ abap_true.
    PERFORM f_chk_asfile_exists USING    p_drctry
                                CHANGING v_ap_path
                                         v_drctry.

    PERFORM f_upload_appl_data_soh.

  ENDIF. " IF rb_soh EQ abap_true

  IF rb_bios EQ abap_true.
    PERFORM f_chk_asfile_exists USING    p_drctry
                                  CHANGING v_ap_path
                                           v_drctry.

    PERFORM f_upload_appl_data_bios.
  ENDIF. " IF rb_bios EQ abap_true

  IF rb_jdr EQ abap_true.
    PERFORM f_chk_asfile_exists USING   p_drctry
                               CHANGING v_ap_path
                                        v_drctry.
    PERFORM f_upload_appl_data_jdr.

  ENDIF. " IF rb_jdr EQ abap_true

  IF rb_jrr EQ abap_true.
    PERFORM f_chk_asfile_exists USING    p_drctry
                                CHANGING v_ap_path
                                         v_drctry.

    PERFORM f_upload_appl_data_jrr.

  ENDIF. " IF rb_jrr EQ abap_true

*====================================================================*
* End of Selection
*====================================================================*
END-OF-SELECTION.

  IF i_inv_rcon[] IS NOT INITIAL.
    PERFORM f_validation_fields.
  ENDIF. " IF i_inv_rcon IS NOT INITIAL

  IF i_errlog_msgs[] IS NOT INITIAL.
* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
    CLEAR i_inv_rcon[].
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
    PERFORM f_mv_to_err_folder. " perform to move files to error folder
*SOC by GKAMMILI ERPM2204 13-Jan-2020 ED2K917189
    IF s_email IS NOT INITIAL.
      PERFORM f_send_email.
    ENDIF.
*EOC by GKAMMILI ERPM2204 13-Jan-2020 ED2K917189
    PERFORM del_err_records_frm_itab.
  ENDIF. " IF v_flag = abap_false

  IF i_inv_rcon[] IS NOT INITIAL.
    PERFORM f_update_cust_tabl.
  ENDIF.
