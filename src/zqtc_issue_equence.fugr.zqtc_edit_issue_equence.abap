*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_EDIT_ISSUE_EQUENCE
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
FUNCTION zqtc_edit_issue_equence.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MED_PROD) TYPE  ISMMATNR_PRODUCT
*"     REFERENCE(IM_X_PLANT_STATUS) TYPE  RJKSD_MSTAE_RANGE_TAB
*"     REFERENCE(IM_ISSUE_VAR_TYPE) TYPE  ZTQTC_VAVARTYP_RANGE
*"     REFERENCE(IM_SHP_PLN_STATUS) TYPE  RJKSE_NIPSTATUS_RANGE_TAB
*"  EXCEPTIONS
*"      EXC_NO_ISSUE
*"      EXC_LOCK_ISSUE_SEQ
*"      EXC_ERROR_IN_ISS_SEQ
*"      EXC_MISCELLANEOUS
*"----------------------------------------------------------------------

* Update Issue Sequence for Journals
  CALL FUNCTION 'ZQTC_ISSUE_EQUENCE_UPDATE'
    EXPORTING
      im_med_prod          = im_med_prod                   "Media Product
      im_x_plant_status    = im_x_plant_status             "Cross-Plant Status
      im_issue_var_type    = im_issue_var_type             "Issue Variant Type
      im_shp_pln_status    = im_shp_pln_status             "Status of Shipping Planning
    EXCEPTIONS
      exc_no_issue         = 1                             "Media Product doesn't have any Media Issue
      exc_lock_issue_seq   = 2                             "Exclusive Lock for Issue Sequence
      exc_error_in_iss_seq = 3                             "Error while creating Issue Sequence
      error_message        = 4                             "Other Miscellaneous Errors
      OTHERS               = 5.
  IF sy-subrc NE 0.
    CASE sy-subrc.
      WHEN 1.
        RAISE exc_no_issue.
      WHEN 2.
        RAISE exc_lock_issue_seq.
      WHEN 3.
        RAISE exc_error_in_iss_seq.
      WHEN 4.
        RAISE exc_miscellaneous.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDIF.

ENDFUNCTION.
