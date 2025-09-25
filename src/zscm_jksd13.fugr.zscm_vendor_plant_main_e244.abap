FUNCTION zscm_vendor_plant_main_e244 .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IN_CHANGE_MODE) TYPE  XFELD DEFAULT ' '
*"     VALUE(IN_ISSUE_TAB) TYPE  ISMMATNR_ISSUETAB
*"--------------------------------------------------------------------
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-05-28
* DESCRIPTION: Journal First Print Optimization
*--------------------------------------------------------------------*

* Local Data
  DATA: lv_wophase     TYPE string VALUE '(RJKSDWORKLIST)V_WOPHASE'.

  " Get the Selected date
  ASSIGN (lv_wophase) TO FIELD-SYMBOL(<lv_preq_date>).
  IF <lv_preq_date> IS ASSIGNED AND
     <lv_preq_date> = abap_true.

    " Call Transaction for Vendor Plant Maintenance
    CALL TRANSACTION 'ZSCM_VENDOR_PLANT'.

  ELSE.
    MESSAGE '"Vendor Plant Maintenance" is only applicable for Purchase Req. Date'(007) TYPE 'I'.
    EXIT.
  ENDIF.

ENDFUNCTION.
