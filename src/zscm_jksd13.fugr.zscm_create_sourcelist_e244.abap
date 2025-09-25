FUNCTION zscm_create_sourcelist_e244.
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
  DATA: lv_attyp     TYPE attyp,
        li_outtab_gf TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]',
        lv_wophase   TYPE string VALUE '(RJKSDWORKLIST)V_WOPHASE'.

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
      " Call transaction for Source List creation
      SET PARAMETER ID: 'MAT' FIELD lst_outtab-matnr,
                        'WRK' FIELD lst_outtab-marc_werks.
      CALL TRANSACTION 'ME01'.

    ELSEIF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS INITIAL.
      " Nothing to do
    ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  ELSE.
    MESSAGE '"PR-Source List" is only applicable for Purchase Req. Date'(002) TYPE 'I'.
    EXIT.
  ENDIF.


ENDFUNCTION.
