FUNCTION zqtc_ism_matmas_ob_cp_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_V_MATNR) TYPE  MATNR
*"     REFERENCE(IM_V_TABNAME) TYPE  TABNAME
*"  EXPORTING
*"     REFERENCE(EX_T_CHGPTRS) TYPE  BDCP_TAB
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917822
* REFERENCE NO:  ERPM-1974
* DEVELOPER:     Gopalakrishna K(GKAMMILI)
* DATE:          03/20/2016
* DESCRIPTION:   Adding Subtitle1 field in Change pointers
*----------------------------------------------------------------------*
  READ TABLE i_cpident_mat TRANSPORTING NO FIELDS
       WITH KEY matnr = im_v_matnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    LOOP AT i_cpident_mat ASSIGNING FIELD-SYMBOL(<lst_cpident_mat>) FROM sy-tabix.
      IF <lst_cpident_mat>-matnr NE im_v_matnr.
        EXIT.
      ENDIF.

      READ TABLE i_chgptrs ASSIGNING FIELD-SYMBOL(<lst_chgptrs>)
           WITH KEY cpident = <lst_cpident_mat>-cpident
                    tabname = im_v_tabname
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        APPEND <lst_chgptrs> TO ex_t_chgptrs.
        UNASSIGN: <lst_chgptrs>.
      ENDIF.
    ENDLOOP.
  ENDIF.

  CASE im_v_tabname.
    WHEN c_table_mara.
*     Add Messing (Required) fields
      PERFORM f_add_missing_field:
        USING c_table_mara c_field_matnr abap_false
     CHANGING ex_t_chgptrs,
        USING c_table_mara c_field_mtart abap_false
     CHANGING ex_t_chgptrs,
*--BOC:ERPM-1974: GKAMMILI ED2K917822
       USING c_table_mara c_field_subtitle abap_false
     CHANGING ex_t_chgptrs.
*--EOC:ERPM-1974: GKAMMILI ED2K917822

    WHEN c_table_marc.
*     Add Messing (Required) fields
      PERFORM f_add_missing_field:
        USING c_table_marc c_field_werks  abap_true
     CHANGING ex_t_chgptrs.
  ENDCASE.

  SORT ex_t_chgptrs BY tabname fldname.

ENDFUNCTION.
