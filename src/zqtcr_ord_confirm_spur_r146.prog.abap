*----------------------------------------------------------------------*
* Program Name : ZQTCR_ORD_CONFIRM_SPUR_R146                           *
* REVISION NO:  ED2K925398                                             *
* REFERENCE NO: OTCM-51319                                             *
* DEVELOPER :  Prabhu / Lahiru Wathudura (LWATHUDURA)                          *
* DATE:  01/06/2022                                                    *
* DESCRIPTION: Indian Agents Order confirmation to SPUR team using     *
*              ZIAC Output type                                        *
*----------------------------------------------------------------------*
REPORT zqtcr_ord_confirm_spur_r146.


INCLUDE zqtcn_ord_confirm_spur_top IF FOUND.      " Data Declaration

INCLUDE zqtcn_ord_confirm_spur_ss IF FOUND.       " Selection Screen define

INCLUDE zqtcn_ord_confirm_spur_sub IF FOUND.      " Subroutines


START-OF-SELECTION.

FORM f_send_ac_notif USING return_code us_screen.

  DATA: lf_retcode TYPE sy-subrc.
  CLEAR v_retcode.
  v_xscreen = us_screen.

  PERFORM f_processing.

  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.
