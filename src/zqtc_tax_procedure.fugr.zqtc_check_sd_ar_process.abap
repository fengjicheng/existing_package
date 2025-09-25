*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_CHECK_SD_AR_PROCESS (Function Module)
* PROGRAM DESCRIPTION: Sabrix Tax Integration
* Check if it is a SD / AR transaction
* [Wiley has specific requirement to use different Tax Procedures for
* AP and AR/SD scenarios, so that AP uses SAP's Tax configurations;
* whereas AR/SD uses Sabrix (OneSource) for Tax calculations]
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02/01/2017
* OBJECT ID: E038
* TRANSPORT NUMBER(S):  ED2K904223
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909720
* REFERENCE NO: INC0185390
* DEVELOPER: Writtick Roy (WROY)
* DATE: 18-Apr-2018
* DESCRIPTION: No need to consider AR (FI) process
*----------------------------------------------------------------------*
FUNCTION zqtc_check_sd_ar_process.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_SD_AR_PROCESS) TYPE  FLAG
*"----------------------------------------------------------------------

  DATA:
    li_call_stack TYPE sys_callst.                              "System Callstack

  FIELD-SYMBOLS:
    <lv_acc_type> TYPE koart,                                   "Account Type
    <li_xbseg>    TYPE bseg_t.                                  "Accounting Document Segment

  DATA:
    lc_acc_type_1 TYPE char40 VALUE '(SAPLFDCB)KOART',          "Account Type
    lc_acc_type_2 TYPE char40 VALUE '(SAPLFSKB)G_BSEG_KK-KOART', "Account Type
    lc_acc_type_3 TYPE char40 VALUE '(SAPMF05A)T020-KOART',     "Account Type
    lc_acc_type_4 TYPE char40 VALUE '(SAPMF05A)BSEG-KOART',     "Account Type
    lc_docu_items TYPE char40 VALUE '(SAPMF05A)XBSEG[]'.        "Accounting Document Segment

* ABAP Call Stack
  CALL FUNCTION 'SYSTEM_CALLSTACK'
    IMPORTING
      et_callstack = li_call_stack.
  SORT li_call_stack BY progname.

* >>>>> Check SD process
* Check if control is coming from Billing Program
* Begin of ADD:INC0185390:WROY:18-Apr-2018:ED2K909720
  IF i_caconst IS INITIAL.
*   Fetch details from Wiley Application Constant Table
    SELECT devid                    " Development ID
           param1                   " ABAP: Name of Variant Variable
           param2                   " ABAP: Name of Variant Variable
           low                      " Lower Value of Selection Condition
      FROM zcaconstant              " Wiley Application Constant Table
      INTO TABLE i_caconst
     WHERE devid    EQ c_devid_e038 "Development ID
       AND activate EQ abap_true.   "Activation indicator for constant
    IF sy-subrc EQ 0.
      SORT i_caconst BY devid param1 param2.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_caconst IS INITIAL

  READ TABLE i_caconst TRANSPORTING NO FIELDS
       WITH KEY devid  = c_devid_e038
                param1 = c_prog_name
                param2 = c_ar_sd_prc
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    LOOP AT i_caconst ASSIGNING FIELD-SYMBOL(<lst_caconst>) FROM sy-tabix.
      IF <lst_caconst>-devid  NE c_devid_e038 OR
         <lst_caconst>-param1 NE c_prog_name  OR
         <lst_caconst>-param2 NE c_ar_sd_prc.
        EXIT.
      ENDIF.
      READ TABLE li_call_stack TRANSPORTING NO FIELDS
           WITH KEY progname = <lst_caconst>-low                "Program: SD-FI Interface
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        ex_sd_ar_process = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ex_sd_ar_process EQ abap_true.
    RETURN.
  ENDIF.
* End   of ADD:INC0185390:WROY:18-Apr-2018:ED2K909720
* Begin of DEL:INC0185390:WROY:18-Apr-2018:ED2K909720
*  READ TABLE li_call_stack TRANSPORTING NO FIELDS
*       WITH KEY progname = c_prg_inv_a                          "Program: SD-FI Interface
*       BINARY SEARCH.
*  IF sy-subrc NE 0.
*    READ TABLE li_call_stack TRANSPORTING NO FIELDS
*         WITH KEY progname = c_prg_inv_b                        "Program: SD-FI Interface
*         BINARY SEARCH.
*  ENDIF.
*  IF sy-subrc EQ 0.
*    ex_sd_ar_process = abap_true.
*    RETURN.
*  ENDIF.

* >>>>> Check AR Process
** Check if control is coming from Subledger Accounting Program
*  READ TABLE li_call_stack TRANSPORTING NO FIELDS
*       WITH KEY progname = c_prg_acc_n                          "Program: Subledger Accounting
*       BINARY SEARCH.
*  IF sy-subrc EQ 0.
**   Check Account Type
*    ASSIGN (lc_acc_type_1) TO <lv_acc_type>.
*    IF sy-subrc      EQ 0.
*      IF <lv_acc_type> EQ c_koart_cust.                         "Account Type: Customer
*        ex_sd_ar_process = abap_true.
*        RETURN.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*
** Check if control is coming from G/L Account Entry Program
*  READ TABLE li_call_stack TRANSPORTING NO FIELDS
*       WITH KEY progname = c_prg_gl_acc                         "Program: G/L Account Entry
*       BINARY SEARCH.
*  IF sy-subrc EQ 0.
**   Check Account Type
*    ASSIGN (lc_acc_type_2) TO <lv_acc_type>.
*    IF sy-subrc      EQ 0.
*      IF <lv_acc_type> EQ c_koart_cust.                         "Account Type: Customer
*        ex_sd_ar_process = abap_true.
*        RETURN.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*
** Check if control is coming from Post Accounting Program
*  READ TABLE li_call_stack TRANSPORTING NO FIELDS
*       WITH KEY progname = c_prg_acc_o                          "Program: Post Accounting
*       BINARY SEARCH.
*  IF sy-subrc EQ 0.
**   Check Account Type (Transaction Code)
*    ASSIGN (lc_acc_type_3) TO <lv_acc_type>.
*    IF sy-subrc      EQ 0.
*      IF <lv_acc_type> EQ c_koart_cust.                         "Account Type: Customer
*        ex_sd_ar_process = abap_true.
*        RETURN.
*      ENDIF.
*    ENDIF.
**   Check Account Type (AR/AP Item)
*    ASSIGN (lc_acc_type_4) TO <lv_acc_type>.
*    IF sy-subrc      EQ 0.
*      IF <lv_acc_type> EQ c_koart_cust.                         "Account Type: Customer
*        ex_sd_ar_process = abap_true.
*        RETURN.
*      ENDIF.
*    ENDIF.
*
**   Check Account Type from Acc Doc Items
*    ASSIGN (lc_docu_items) TO <li_xbseg>.
*    IF sy-subrc      EQ 0.
*      READ TABLE <li_xbseg> TRANSPORTING NO FIELDS
*           WITH KEY koart = c_koart_cust.                       "Account Type: Customer
*      IF sy-subrc EQ 0.
*        ex_sd_ar_process = abap_true.
*        RETURN.
*      ENDIF.
*    ENDIF.
*  ENDIF.
* End   of DEL:INC0185390:WROY:18-Apr-2018:ED2K909720

ENDFUNCTION.
