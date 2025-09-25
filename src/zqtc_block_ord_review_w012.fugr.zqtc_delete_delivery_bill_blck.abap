**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTC_DELETE_DELIVERY_BILL_BLCK                 *
** PROGRAM DESCRIPTION:  Function Module implemented to delete delivery *
**                       block and billing block when WF triggered for  *
**                       successful order processing.
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        08/03/2017                                     *
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
FUNCTION zqtc_delete_delivery_bill_blck.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"  EXCEPTIONS
*"      EXC_LOCK
*"      EXC_FAIL
*"----------------------------------------------------------------------

* Data declaration
  DATA : li_return    TYPE bapiret2_t," Return value table
         ls_bapisdh1  TYPE bapisdh1,  " Communication Fields: SD Order Header
         ls_bapisdh1x TYPE bapisdh1x. " Checkbox List: SD Order Header

* Populating value in structures
  ls_bapisdh1-dlv_block   = ''. " Delivery block remove
  ls_bapisdh1-bill_block  = ''. " Billing block remove
  ls_bapisdh1x-updateflag = c_update. " update flag on
  ls_bapisdh1x-dlv_block  = abap_true. " update flag on for delivery block
  ls_bapisdh1x-bill_block = abap_true. " update flag on for billing block

* Calling FM to remove billing block and delivery block
* after WF is triggered to process the order.
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = im_vbeln     " Sales Document
      order_header_in  = ls_bapisdh1  " Order Header
      order_header_inx = ls_bapisdh1x " SD Header Check
    TABLES
      return           = li_return.

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
