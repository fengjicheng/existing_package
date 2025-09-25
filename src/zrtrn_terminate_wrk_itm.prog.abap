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
*&  Include           ZRTRN_TERMINATE_WRK_ITM
*&---------------------------------------------------------------------*


DATA: lr_case1          TYPE REF TO cl_scmg_case,
      lv_srmadid_2      TYPE  srmadid,                   " Attribute Description - ID
      lv_value_get      TYPE  string,
      lv_case_id_get    TYPE  scmg_ext_key,              " Case ID
      ls_case_attr_get  TYPE  scmg_t_case_attr,          " Case Attributes
      lv_cr_partner_get TYPE  bu_partner,                " BP
      lv_cr_seg_get     TYPE  ukm_credit_sgmnt,          " Segment
      lt_work_list      TYPE  swrtwihdr,                 " Table Type for Work Item Header
      ls_work_list      TYPE  swr_wihdr,                 " WA for Work Item Header
      lv_object_key1    TYPE  swotobjid-objkey,          " Object key
      lv_retn_code      TYPE  sy-subrc,                  " Return Code of ABAP Statements
      lt_ret_mesg       TYPE STANDARD TABLE OF bapiret2,
      ls_ret_mesg       TYPE bapiret2,
      lv_case_guid      TYPE scmg_case_guid.

CONSTANTS:
  lc_ext_key     TYPE char10 VALUE 'EXT_KEY',      " to get the case id
  lc_fcr_partner TYPE char20 VALUE 'FCR_PARTNER',  " to get the partner
  lc_fcr_segment TYPE char20 VALUE 'FCR_SEGMENT'.  " To get the Segment like US00 or UK00

lr_case1 ?= im_case.
*-- Get CASE ID
lv_srmadid_2 = lc_ext_key. "'EXT_KEY'.  " Case ID
TRY.
    lv_value_get = lr_case1->if_scmg_case_read~get_single_attribute_value( lv_srmadid_2 ).
  CATCH cx_scmg_case_attribute .
  CATCH cx_srm_framework .
ENDTRY.
lv_case_id_get = lv_value_get.  " Get Case ID

*-- Get case GUID
CLEAR: lv_case_guid.
SELECT * INTO ls_case_attr_get
         FROM scmg_t_case_attr UP TO 1 ROWS
         WHERE ext_key = lv_case_id_get.
ENDSELECT.
IF sy-subrc = 0.
  lv_case_guid = ls_case_attr_get-case_guid.
ENDIF.

*-- Get case GUID if still it is initial
IF lv_case_guid IS INITIAL.
  lv_case_guid = lr_case1->if_scmg_case_read~get_guid( ).
ENDIF.

IF lv_case_guid IS NOT INITIAL.
  lv_object_key1 = lv_case_guid.
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
    "Kill work flow by using FM SWW_WI_ADMIN_CANCEL in new task
    READ TABLE lt_work_list INTO ls_work_list INDEX 1.
    IF sy-subrc = 0.
      CALL FUNCTION 'ZRTRN_KILL_WORK_ITEM_FM' STARTING NEW TASK 'UPDATE' DESTINATION 'NONE'
        EXPORTING
          i_wi_id = ls_work_list-wi_id.
    ENDIF.
  ENDIF.
ENDIF.
