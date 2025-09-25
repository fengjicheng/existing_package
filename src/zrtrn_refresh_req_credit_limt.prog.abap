*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  Rel 2
* REFERENCE NO: ED1K910707(Workbench) ;
* DEVELOPER:    AKHADIR (Khadir)
* DATE:         25-Jul-2019
* DESCRIPTION:  DM-2082 INC0244597 -- Credit Case Issue
*               Void/Delete case should reset the CL requested amount
*               and keep the existing Credit limit,
*               even if the WF as been initiated/triggered.
*               Issue/bug reported on requested credit limit
*               does not refresh properly and user has
*               to put 0.00 to reset the CL requested amount.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZRTRN_REFRESH_REQ_CREDIT_LIMT
*&---------------------------------------------------------------------*

DATA: lr_case1           TYPE REF TO cl_scmg_case,
      lv_srmadid_2       TYPE  srmadid,                   " Attribute Description - ID
      lv_value_get       TYPE  string,
      lv_case_id_get     TYPE  scmg_ext_key,              " Case ID
      lv_case_status_get TYPE  char2,                     " Case Status
      ls_case_attr_get   TYPE  scmg_t_case_attr,          " Case Attributes
      lv_cr_partner_get  TYPE  bu_partner,                " BP
      lv_cr_seg_get      TYPE  ukm_credit_sgmnt,          " Segment
      lv_void_case       TYPE  char3,                     " Void value
      lt_work_list       TYPE  swrtwihdr,                 " Table Type for Work Item Header
      ls_work_list       TYPE  swr_wihdr,                 " WA for Work Item Header
      lv_object_key1     TYPE  swotobjid-objkey,          " Object key
      lv_retn_code       TYPE  sy-subrc,                  " Return Code of ABAP Statements
      lt_ret_mesg        TYPE STANDARD TABLE OF bapiret2,
      ls_ret_mesg        TYPE bapiret2.

CONSTANTS: lc_case_stats  TYPE char2 VALUE  '25',           " Request for approval
           lc_stat_ordrno TYPE scmgstatusonr VALUE '20',    " In-process
           lc_void_value  TYPE char3  VALUE '009',          " Voided/Deleted/Canceled
           lc_void_case   TYPE char10 VALUE 'STAT_PARA',    " To get the void action fcode
           lc_ext_key     TYPE char10 VALUE 'EXT_KEY',      " to get the case id
           lc_stat_ord    TYPE char20 VALUE 'STAT_ORDERNO', " to get the case status
           lc_fcr_partner TYPE char20 VALUE 'FCR_PARTNER',  " to get the partner
           lc_fcr_segment TYPE char20 VALUE 'FCR_SEGMENT'.  " To get the Segment like US00 or UK00

*DATA: lv_exit_flag TYPE c.
*DO.
*  IF lv_exit_flag IS NOT INITIAL.
*    EXIT.
*  ENDIF.
*ENDDO.

lr_case1 ?= im_case.

*-- Get Void Value 009
lv_srmadid_2 = lc_void_case. "'STAT_PARA'.  " Get Void Value 009
TRY.
    lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
  CATCH cx_scmg_case_attribute .
  CATCH cx_srm_framework .
ENDTRY.
lv_void_case = lv_value_get.  " Get Void Value 009

IF lv_void_case = lc_void_value. "'009'.

*-- Get CASE ID
  lv_srmadid_2 = lc_ext_key. "'EXT_KEY'.  " Case ID
  TRY.
      lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
    CATCH cx_scmg_case_attribute .
    CATCH cx_srm_framework .
  ENDTRY.
  lv_case_id_get = lv_value_get.  " Get Case ID

*-- Get CASE status
  CLEAR: lv_srmadid_2, lv_value_get.
  lv_srmadid_2 = lc_stat_ord. "'STAT_ORDERNO'.  "Status
  TRY.
      lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
    CATCH cx_scmg_case_attribute .
    CATCH cx_srm_framework .
  ENDTRY.
  lv_case_status_get = lv_value_get. " Status

*-- Get CASE BP / Partner
  CLEAR: lv_srmadid_2, lv_value_get.
  lv_srmadid_2 = lc_fcr_partner. "'FCR_PARTNER'.  "  BP / Partner
  TRY.
      lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
    CATCH cx_scmg_case_attribute .
    CATCH cx_srm_framework .
  ENDTRY.
  lv_cr_partner_get = lv_value_get. "  BP / Partner

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_cr_partner_get
    IMPORTING
      output = lv_cr_partner_get.

*-- Begin to give error message if the BP is locked
  CLEAR: lt_ret_mesg[].
  CALL FUNCTION 'BUPA_ENQUEUE'
    EXPORTING
      iv_partner      = lv_cr_partner_get
*     IV_PARTNER_GUID =
*     IV_CHECK_NOT_NUMBER       =
*     IV_REQ_BLK_MSG  =
    TABLES
      et_return       = lt_ret_mesg
    EXCEPTIONS
      blocked_partner = 1
      OTHERS          = 2.
  READ TABLE lt_ret_mesg INTO ls_ret_mesg
  WITH KEY type = 'E'.
  IF sy-subrc = 0.
    MESSAGE ls_ret_mesg-message TYPE 'E'.
  ELSE.
    REFRESH: lt_ret_mesg.
    CALL FUNCTION 'BUPA_DEQUEUE'
      EXPORTING
        iv_partner = lv_cr_partner_get
*       IV_PARTNER_GUID           =
*       IV_CHECK_NOT_NUMBER       =
      TABLES
        et_return  = lt_ret_mesg.
  ENDIF.
*-- Begin to give error message if the BP is locked

*-- Get Segment
  CLEAR: lv_srmadid_2, lv_value_get.
  lv_srmadid_2 = lc_fcr_segment. "'FCR_SEGMENT'.  "  Segment
  TRY.
      lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
    CATCH cx_scmg_case_attribute .
    CATCH cx_srm_framework .
  ENDTRY.
  lv_cr_seg_get = lv_value_get. "  Segment

*IF lv_case_status_get  = lc_case_stats.                       "Request for Approval
  SELECT * INTO ls_case_attr_get
           FROM scmg_t_case_attr UP TO 1 ROWS
           WHERE ext_key = lv_case_id_get.
  ENDSELECT.
  IF sy-subrc = 0.
    lv_object_key1 = ls_case_attr_get-case_guid.
*--Check active instance of workflow
    CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'
      EXPORTING
        objtype                  = 'SCASE'
        objkey                   = lv_object_key1
        top_level_items          = abap_true
        selection_status_variant = 0001                "Active Instance
      IMPORTING
        return_code              = lv_retn_code
      TABLES
        worklist                 = lt_work_list.

    IF NOT lt_work_list[] IS INITIAL.
      "Kill work flow by using FM SWW_WI_ADMIN_CANCEL in update task
    ENDIF.
  ENDIF.
*ENDIF.

*--  Calling below FM in update task to update or refresh
**  CL(Credit Limit) requested in BP and terminate existing active workflow
  CALL FUNCTION 'ZRTRN_MODIF_CR_VALUE_UPDATE' IN UPDATE TASK
    EXPORTING
      i_case_id    = lv_case_id_get
      i_bp         = lv_cr_partner_get
      i_segment    = lv_cr_seg_get
      it_work_item = lt_work_list.

ENDIF.  " IF lv_void_case = '009'.
