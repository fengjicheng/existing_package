FUNCTION zscm_change_pir_e244.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IN_CHANGE_MODE) TYPE  XFELD DEFAULT ' '
*"     VALUE(IN_ISSUE_TAB) TYPE  ISMMATNR_ISSUETAB
*"----------------------------------------------------------------------
* REVISION HISTORY------------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-05-28
* DESCRIPTION: Journal First Print Optimization
*-----------------------------------------------------------------------*

* Local Data
  DATA: lv_attyp       TYPE attyp,
        li_outtab_gf   TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]',
        lv_wophase     TYPE string VALUE '(RJKSDWORKLIST)V_WOPHASE',
        lv_bedae       TYPE bedae  VALUE 'LSF',
        li_bdcdata_tab TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0,
        lst_opt        TYPE ctu_params.

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
      " Call transaction to change the PIR
*      SET PARAMETER ID: 'MAT' FIELD lst_outtab-matnr,
*                        'WRK' FIELD lst_outtab-marc_werks,
*                        'BDA' FIELD lv_bedae,
*                        'VES' FIELD '00'.
*
*      CALL TRANSACTION 'MD62'.

      li_bdcdata_tab = VALUE #(
               ( program  = 'SAPMM60X' dynpro = '0106' dynbegin = 'X' )
               ( fnam = 'BDC_CURSOR' fval = 'AM60X-MATNR' )
               ( fnam = 'AM60X-MATNR' fval = lst_outtab-matnr )
               ( fnam = 'AM60X-WERKS' fval = lst_outtab-marc_werks )
               ( fnam = 'RM60X-BEDAE' fval = lv_bedae )
               ( fnam = 'RM60X-VERSB' fval = '00' ) ).

*      lst_opt-dismode = 'A'.
*      lst_opt-defsize = abap_true.

      TRY.
          CALL TRANSACTION 'MD62' USING li_bdcdata_tab. " OPTIONS FROM lst_opt.
        CATCH cx_sy_authorization_error ##NO_HANDLER.
      ENDTRY.

    ELSEIF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS INITIAL.
      " Nothing to do
    ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  ELSE.
    MESSAGE '"PR-Plnd Ind Requirements" is only applicable for Purchase Req. Date'(004) TYPE 'I'.
    EXIT.
  ENDIF.

ENDFUNCTION.
