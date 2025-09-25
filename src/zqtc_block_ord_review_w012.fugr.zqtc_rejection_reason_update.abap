FUNCTION zqtc_rejection_reason_update.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"  EXCEPTIONS
*"      EXC_LOCK
*"      EXC_FAIL
*"----------------------------------------------------------------------
**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTC_REJECTION_REASON_UPDATE                   *
** PROGRAM DESCRIPTION:  Function Module implemented retrieve rejection *
**                       reason if credit memo rejected through WF in   *
**                       item level irrespective of item number.        *
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
* Data declaration
  DATA : li_return      TYPE bapiret2_t,                                  " Return table
         li_bapisditmx  TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
         li_bapisditm   TYPE STANDARD TABLE OF bapisditm  INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
         lst_bapisdh1x  TYPE bapisdh1x,                                   " Checkbox List: SD Order Header
         lst_bapisditm  TYPE bapisditm,                                   " Communication Fields: Sales and Distribution Document Item
         lst_bapisditmx TYPE bapisditmx.                                  " Communication Fields: Sales and Distribution Document Item

* Constant Declaration
  CONSTANTS : lc_rej_rsn TYPE rvari_vnam VALUE 'ABGRU'. " Promotion code for variant variable

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
      AND param1   = @lc_rej_rsn
      AND activate = @abap_true.
  ENDSELECT.
  IF sy-subrc IS INITIAL.

*  Fetch sales document and item number from VBAP table
    SELECT vbeln, " Sales Document
           posnr  " Sales Document Item
      FROM vbap   " Sales Document: Item Data
      INTO TABLE @DATA(li_vbap)
      WHERE vbeln EQ @im_vbeln.

    LOOP AT li_vbap INTO DATA(lst_vbap).

*   Populate value in order Item
      lst_bapisditm-itm_number = lst_vbap-posnr.
      lst_bapisditm-reason_rej = lst_constant-low.
      APPEND lst_bapisditm TO li_bapisditm.
      CLEAR lst_bapisditm.

*   Populate value in order Item Index
      lst_bapisditmx-updateflag = c_update.
      lst_bapisditmx-itm_number = lst_vbap-posnr.
      lst_bapisditmx-reason_rej = abap_true.
      APPEND lst_bapisditmx TO li_bapisditmx.
      CLEAR lst_bapisditmx.

*   Populate value in order header
      lst_bapisdh1x-updateflag = c_update.

*     Update rejection reason for credit memo request when rejected
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = im_vbeln
          order_header_inx = lst_bapisdh1x
        TABLES
          return           = li_return
          order_item_in    = li_bapisditm
          order_item_inx   = li_bapisditmx.

    ENDLOOP. " LOOP AT li_vbap INTO DATA(lst_vbap)
  ENDIF. " IF sy-subrc IS INITIAL
* Raise exception in case of error.
  LOOP AT li_return INTO DATA(lst_return) WHERE type = c_err  "  of type = E
                                             OR type = c_abr. " Or of type = A
    IF lst_return-id EQ c_id
      AND lst_return-number EQ c_num.
      RAISE exc_lock.
    ELSE. " ELSE -> IF lst_return-id EQ c_id
      RAISE exc_fail.
    ENDIF. " IF lst_return-id EQ c_id
  ENDLOOP. " LOOP AT li_return INTO DATA(lst_return) WHERE type = c_err

ENDFUNCTION.
