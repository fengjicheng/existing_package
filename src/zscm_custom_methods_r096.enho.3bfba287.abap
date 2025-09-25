"Name: \PR:RJKSDWORKLIST\TY:ISM_WORKLIST_LIST\ME:HANDLE_CHANGED_CELL\SE:END\EI
ENHANCEMENT 0 ZSCM_CUSTOM_METHODS_R096.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919405
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 16-SEP-2020
* DESCRIPTION: Enhancement to add the ADJUSTMENT field value to
* TOTAL PO QTY upon hit ENTER in LITHO Report
*-----------------------------------------------------------------------*
    " Local data declaration
    DATA: lv_adj_qty  TYPE int4,
          lv_adjqty_n TYPE numc13.

    " Check for Tcode
    IF sy-tcode = 'ZSCM_JKSD13_01' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*       sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
      sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
     " Check for Filter value
     IF gv_filt = c_zl.

      LOOP AT ER_DATA_CHANGED->MT_GOOD_CELLS INTO ls_good.
        CASE LS_GOOD-FIELDNAME.
          WHEN 'ADJUSTMENT'.
            READ TABLE gt_outtab INDEX ls_good-row_id ASSIGNING FIELD-SYMBOL(<lst_outtab>).
            IF sy-subrc = 0.
              FIND REGEX '[A-Za-z]' IN ls_good-value.
              IF sy-subrc <> 0.
               CONDENSE ls_good-value NO-GAPS.
               DATA(lv_minus) = ls_good-value(1).
               lv_adjqty_n = ls_good-value.
               ls_good-value = lv_adjqty_n.
               CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                 EXPORTING
                   input         = ls_good-value
                 IMPORTING
                   OUTPUT        = ls_good-value.
               IF lv_minus = '-'.
                 ls_good-value = |{ lv_minus }{ ls_good-value }|.
               ENDIF.
               lv_adj_qty = ls_good-value.
               <lst_outtab>-total_po_qty = <lst_outtab>-sub_total + <lst_outtab>-c_and_e + <lst_outtab>-author_copies +
                                           <lst_outtab>-emlo_copies + lv_adj_qty.

               <lst_outtab>-estimated_soh = <lst_outtab>-total_po_qty - <lst_outtab>-ml_cyear - <lst_outtab>-om_actual -
                                            <lst_outtab>-c_and_e - <lst_outtab>-author_copies - <lst_outtab>-emlo_copies.
              ENDIF. " IF sy-subrc <> 0.
            ENDIF. " IF sy-subrc = 0.
          WHEN OTHERS.
            " Nothing to do
        ENDCASE.
        CLEAR ls_good.
      ENDLOOP.

      " Refresh the ALV Grid
      CALL METHOD ME->REGISTER_REFRESH.
      CALL METHOD GV_LIST->EXECUTE_REFRESH.

     ENDIF. " IF gv_filt = c_zl.
    ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01'

ENDENHANCEMENT.
