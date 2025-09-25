FUNCTION zscm_litho_tm_r096.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IN_CHANGE_MODE) TYPE  XFELD DEFAULT ' '
*"     VALUE(IN_ISSUE_TAB) TYPE  ISMMATNR_ISSUETAB
*"----------------------------------------------------------------------
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 31-AUG-2020
* DESCRIPTION: LITHO: Table Maintenance for Renewal Prd/BL-Buffer
*--------------------------------------------------------------------*


  " Call Transaction for Vendor Plant Maintenance
  CALL TRANSACTION 'ZSCM_LITHO_TM'.



ENDFUNCTION.
