REPORT zrarr_subscr_recl.

INCLUDE ZRARR_SUBSCR_TOP.

INCLUDE ZRARR_SUBSCR_SCR.

INCLUDE ZRARR_SUBSCR_CODE.


AT SELECTION-SCREEN.

  PERFORM retrieve_customizing.

  TRY.
      DATA(lv_c_period) = gt_customizing[ param1 = lc_prm_gjahr ]-low && gt_customizing[ param1 = lc_prm_poper ]-low.
    CATCH cx_sy_itab_line_not_found.
      MESSAGE 'Please maintain ZCACONSTANT customizing for PERIOD/GJAHR values!' TYPE 'E'.
  ENDTRY.

  DATA(lv_p_period) = p_gjahr && p_poper.

  IF lv_p_period < lv_c_period.
    lv_msg = | You can only reclass items in Fiscal year: { lv_c_period(4) }, Period: { lv_c_period+4(3) } |.
    MESSAGE lv_msg TYPE 'E'.
  ENDIF.

START-OF-SELECTION.

  PERFORM select_data.

  IF p_disp EQ abap_true.
    PERFORM display_data.
  ELSE.
    PERFORM prepare_post TABLES lt_output.
  ENDIF.
