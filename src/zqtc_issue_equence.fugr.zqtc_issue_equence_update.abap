*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_EDIT_ISSUE_EQUENCE
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
FUNCTION ZQTC_ISSUE_EQUENCE_UPDATE.
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
*"----------------------------------------------------------------------
  DATA:
    li_media_issues TYPE ism_mdissue_tab.                              "IS-M: Media Issues

* Check if the Media Product is locked
  PERFORM f_check_if_locked  USING    im_med_prod.

* Fetch All Issues of the Media Product
  PERFORM f_fetch_med_issues USING    im_med_prod
                                      im_x_plant_status
                                      im_issue_var_type
                                      im_shp_pln_status
                             CHANGING li_media_issues.

* Create / Update Issue Sequence
  PERFORM f_edit_issue_seq   USING    im_med_prod
                                      li_media_issues.

* Unlock entries (Media Product)
  PERFORM f_unlock_entries.

ENDFUNCTION.
