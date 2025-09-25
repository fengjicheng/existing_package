*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_BP_CHANGE_POINTERS_PROC                   *
* PROGRAM DESCRIPTION:  Function module to get the BDCP2 unprocessed   *
*                       Change Pointer details against the Message Type*
*                       and return the Customer and Object class detail*
* DEVELOPER:            Cheenangshuk Das                               *
* CREATION DATE:        12/09/2016                                     *
* OBJECT ID:            I0202                                          *
* TRANSPORT NUMBER(S):  ED2K903293                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_bp_change_pointers_proc.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MESSAGE_TYPE) LIKE  TBDME-MESTYP
*"     VALUE(CREATION_DATE_HIGH) LIKE  SY-DATUM DEFAULT SY-DATUM
*"     VALUE(CREATION_TIME_HIGH) LIKE  SY-UZEIT DEFAULT SY-UZEIT
*"  EXCEPTIONS
*"      NO_UNPROCESSED_POINTERS
*"      WRONG_INPUT_IN_MESTYP
*"----------------------------------------------------------------------
*Clearing Global variables
  PERFORM f_clear_all_global .

*Validating the Input
  PERFORM f_validating_input  USING message_type
                              CHANGING v_raise.
  IF v_raise IS NOT INITIAL.
    RAISE wrong_input_in_mestyp.
  ENDIF. " IF v_raise IS NOT INITIAL

*Fetch from BDCP2
  PERFORM f_get_bdcp2         USING    message_type
                              CHANGING i_bdcp2
                                       i_kna1
                                       i_but000
                                       i_but020.

*Filtering Inputs
  PERFORM f_filter_bdcp2_on_partner USING i_bdcp2
                                          i_kna1
                                          i_but020
                                    CHANGING
                                          i_bdcp2_final.

*Submit BD12
  PERFORM f_submit_bd12 USING i_bdcp2_final.

ENDFUNCTION.
