FUNCTION zscm_run_mrp_e244 .
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
  DATA: lv_attyp       TYPE attyp,
        li_outtab_gf   TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]',
        lv_wophase     TYPE string VALUE '(RJKSDWORKLIST)V_WOPHASE',
        li_bdcdata_tab TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0.

  FIELD-SYMBOLS:
    <lfi_outtab>     TYPE lty_rjksdworklist_alv.

  " Get the Selected date
  ASSIGN (lv_wophase) TO FIELD-SYMBOL(<lv_preq_date>).
  IF <lv_preq_date> IS ASSIGNED AND
     <lv_preq_date> = abap_true.
    " Get the Selected Media Issue
    ASSIGN (li_outtab_gf) TO <lfi_outtab>.
    IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.
      DESCRIBE TABLE <lfi_outtab> LINES DATA(lv_lines).
      IF lv_lines > 1.
        MESSAGE 'Media Issue selection should be 1'(001) TYPE 'I'.
        EXIT.
      ENDIF.
      " Read the selected record
      READ TABLE <lfi_outtab> INTO DATA(lst_outtab) INDEX 1.
      IF sy-subrc = 0 AND lst_outtab-status IS NOT INITIAL.
        FIND '@5C@' IN lst_outtab-status.
        IF sy-subrc = 0.
          MESSAGE 'Media Issue must not have error status for "PR-Purchase Requisition"' TYPE 'I'.
          EXIT.
        ENDIF.
      ENDIF.
      IF lst_outtab-matnr IS INITIAL.
        lst_outtab-matnr = lst_outtab-matnr_save.
      ENDIF.
      " Material validation against Mat. Category
      SELECT SINGLE attyp FROM mara INTO lv_attyp  " attyp --> Material Category
             WHERE matnr = lst_outtab-matnr.
      IF sy-subrc <> 0.
        CONCATENATE 'No Material Category for#' lst_outtab-matnr INTO DATA(lv_msgtxt)
                    SEPARATED BY space.
        MESSAGE lv_msgtxt TYPE 'S'.
        EXIT.
      ENDIF.
      " Call transaction to run the MRP
*      SET PARAMETER ID: 'MAT' FIELD lst_outtab-matnr,
*                        'WRK' FIELD lst_outtab-marc_werks.
*      CALL TRANSACTION 'MD02'.

      li_bdcdata_tab = VALUE #(
               ( program  = 'SAPMM61X' dynpro = '0150' dynbegin = 'X' )
               ( fnam = 'BDC_CURSOR' fval = 'RM61X-MATNR' )
               ( fnam = 'RM61X-MATNR' fval = lst_outtab-matnr )
               ( fnam = 'RM61X-WERKS' fval = lst_outtab-marc_werks )
               ( fnam = 'RM61X-BANER' fval = '1' ) ).

      TRY.
          CALL TRANSACTION 'MD02' USING li_bdcdata_tab.
        CATCH cx_sy_authorization_error ##NO_HANDLER.
      ENDTRY.

    ELSEIF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS INITIAL.
      " Nothing to do
    ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  ELSE.
    MESSAGE '"PR-Purchase Requisition" is only applicable for Purchase Req. Date'(006) TYPE 'I'.
    EXIT.
  ENDIF.

ENDFUNCTION.
