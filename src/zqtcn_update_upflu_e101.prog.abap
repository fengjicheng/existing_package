*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPDATE_UPFLU_E101
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: When debit memo is created with BOM material using
*                      "ZQTCR_SUBSCRIP_ORDER_UPLOAD" program,
*                      1. UPFLU field of VBAP is set to '2' for all line
*                         items VBFA table is filled with respective records
* DEVELOPER: AMOHAMMED
* CREATION DATE:   09/12/2020
* OBJECT ID: E101 - ERPM-27580, 26293
* TRANSPORT NUMBER(S):ED2K920727
*----------------------------------------------------------------------*
DATA: li_abap_stack TYPE  abap_callstack,
      li_sys_stack  TYPE  sys_callst.
CONSTANTS : lc_calling_program    TYPE syrepid VALUE 'ZQTCR_SUBSCRIP_ORDER_UPLOAD',
            lc_calling_subroutine TYPE string VALUE 'F_CREATE_DEBIT_MEMO',
            lc_two                TYPE i       VALUE 2.
" FM To get the Call Stack information when running the program
" ABAP Callstack would give you the Program names
" SYS callstack would give you system programs in callstack
CALL FUNCTION 'SYSTEM_CALLSTACK'
  IMPORTING
    callstack    = li_abap_stack
    et_callstack = li_sys_stack.
IF li_abap_stack IS NOT INITIAL.
  READ TABLE li_abap_stack TRANSPORTING NO FIELDS
    WITH KEY mainprogram = lc_calling_program
             blockname   = lc_calling_subroutine.
  IF sy-subrc NE 0.
    "Not found, go away
    EXIT.
  ELSE.
    " At every line item se the UPFLU field value to '2'
    vbap-upflu = lc_two." Create doc. flow records except for dely/goods issue/billdoc
  ENDIF.
ENDIF.
