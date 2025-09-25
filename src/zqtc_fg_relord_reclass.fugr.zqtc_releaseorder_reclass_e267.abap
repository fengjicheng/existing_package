FUNCTION zqtc_releaseorder_reclass_e267.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_FISCALYEAR) TYPE  GJAHR
*"     REFERENCE(IM_POSTING_PERIOD) TYPE  POPER
*"     REFERENCE(IM_POSTING_DATE) TYPE  BUDAT DEFAULT SY-DATUM
*"     REFERENCE(IM_POBTYPE) TYPE  ZTQTC_POBTYPE
*"     REFERENCE(IM_SALESDOCUMENT) TYPE  TDT_RG_VBELN
*"     REFERENCE(IM_ZERO_VALUES) TYPE  CHAR01
*"----------------------------------------------------------------------



  v_gjahr = im_fiscalyear.
  v_poper = im_posting_period.

  TRY.
      DATA(lv_c_period) = i_customizing[ param1 = c_prm_gjahr ]-low && i_customizing[ param1 = c_prm_poper ]-low.
    CATCH cx_sy_itab_line_not_found.
      MESSAGE 'Please maintain ZCACONSTANT customizing for PERIOD/GJAHR values!'(001) TYPE 'E'.
  ENDTRY.

  DATA(lv_p_period) = v_gjahr && v_poper.

  IF lv_p_period < lv_c_period.
    v_msg = | You can only reclass items in Fiscal year: { lv_c_period(4) }, Period: { lv_c_period+4(3) } |.
    MESSAGE v_msg TYPE 'E'.
  ENDIF.


  PERFORM f_retrieve_customizing.



ENDFUNCTION.
