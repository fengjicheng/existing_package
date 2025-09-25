FUNCTION zscm_update_print_method_r096.
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
* DATE: 26-AUG-2020
* DESCRIPTION: LITHO: 'Print Method' update of Media Issues
*--------------------------------------------------------------------*

* Local Data
  DATA: li_outtab_gf   TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]',
        lv_gv_filter   TYPE string VALUE '(RJKSDWORKLIST)GV_FILT',
        lst_header     TYPE bapimathead,
        lst_plantdata  TYPE bapi_marc,
        lst_plantdatax TYPE bapi_marcx,
        li_return      TYPE STANDARD TABLE OF bapi_matreturn2 INITIAL SIZE 0.

  FIELD-SYMBOLS:
    <lfi_outtab>     TYPE lty_rjksdworklist_alv.

  " Get the Selected Filter value
  ASSIGN (lv_gv_filter) TO FIELD-SYMBOL(<lv_gv_filter>).
  IF <lv_gv_filter> IS ASSIGNED AND
     ( <lv_gv_filter> = c_zl OR <lv_gv_filter> = c_zd ).
    " Get the Selected Media Issue(s)
    ASSIGN (li_outtab_gf) TO <lfi_outtab>.
    IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.
      LOOP AT <lfi_outtab> INTO DATA(lst_outtab).

        " Release lock on object EMMARAE
        CALL FUNCTION 'DEQUEUE_EMMARAE'
          EXPORTING
            matnr  = lst_outtab-matnr
            _scope = '2'.
        IF sy-subrc = 0.

          lst_header-material = lst_outtab-matnr.
          lst_header-ind_sector = c_n.

          " Set Print Method
          lst_plantdata-plant = lst_outtab-marc_werks.
          lst_plantdata-handlg_grp = lst_outtab-print_method.

          " Update X Structure
          lst_plantdatax-plant = lst_outtab-marc_werks.
          lst_plantdatax-handlg_grp = abap_true.

          CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
            EXPORTING
              headdata       = lst_header
              plantdata      = lst_plantdata
              plantdatax     = lst_plantdatax
            TABLES
              returnmessages = li_return.
          IF sy-subrc = 0.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
          ELSE.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  INTO DATA(lv_mtext)
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            EXIT.
          ENDIF.

        ELSE.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  INTO lv_mtext
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          EXIT.
        ENDIF.

        CLEAR: lst_outtab, lst_header, lst_plantdata, lst_plantdatax.
      ENDLOOP.

    ELSEIF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS INITIAL.
      MESSAGE 'Please select atleast one Media Issue to update "Print Method"'(009) TYPE 'I'.
      EXIT.
    ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  ELSE.
    MESSAGE 'Update "Print Method" is applicable only for LITHO/DIGITAL Report'(008) TYPE 'I'.
    EXIT.
  ENDIF.


ENDFUNCTION.
