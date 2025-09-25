FUNCTION zqtc_arithmetic_operations.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_V_OPERAND1)
*"     REFERENCE(IM_V_OPERAND2)
*"     REFERENCE(IM_V_OPERATION) TYPE  ICL_CMC_CALC_OP
*"  EXPORTING
*"     REFERENCE(EX_V_RESULT)
*"  EXCEPTIONS
*"      EXC_WRONG_OPERAND
*"----------------------------------------------------------------------

  CASE im_v_operation.
    WHEN c_opr_add.
      ex_v_result = im_v_operand1 + im_v_operand2.
    WHEN c_opr_sub.
      ex_v_result = im_v_operand1 - im_v_operand2.
    WHEN c_opr_mul.
      ex_v_result = im_v_operand1 * im_v_operand2.
    WHEN c_opr_div.
      IF im_v_operand2 IS NOT INITIAL.
        ex_v_result = im_v_operand1 / im_v_operand2.
      ENDIF.
*   Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
    WHEN c_opr_prc.
      ex_v_result = im_v_operand1 * im_v_operand2 / 100.
*   End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
    WHEN OTHERS.
      RAISE exc_wrong_operand.
  ENDCASE.

ENDFUNCTION.
