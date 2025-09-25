FUNCTION zqtc_calculate_waiting_date.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_WAIT_DATE) TYPE  DATS
*"     REFERENCE(EX_DAYS) TYPE  CHAR2
*"----------------------------------------------------------------------
**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTC_CALCULATE_WAITING_DATE                    *
** PROGRAM DESCRIPTION:  Function Module implemented to retrieve date   *
**                       after waiting for first level approver         *
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        09/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*

* Constant Declaration
  CONSTANTS : lc_tolerance TYPE rvari_vnam VALUE 'TOLERANCE'. " Promotion code for variant variable

* Fetch rejection reason from constant table.
  SELECT devid,      " Development ID
         param1,     " ABAP: Name of Variant Variable
         param2,     " ABAP: Name of Variant Variable
         sign,       " ABAP: ID: I/E (include/exclude values)
         opti,       " ABAP: Selection option (EQ/BT/CP/...)
         low,        " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO @DATA(lst_constant)
    UP TO 1 ROWS
    WHERE devid    = @c_devid
      AND param1   = @lc_tolerance
      AND activate = @abap_true.
  ENDSELECT.
  IF sy-subrc IS INITIAL.
* Populate number of days
    ex_days = lst_constant-low.
*   Add waiting day with WF triggering date
    ex_wait_date = sy-datum + lst_constant-low + 1.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFUNCTION.
