*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_REJCT_SUB_TOT
* PROGRAM DESCRIPTION: Rejection rule for Sales order
* DEVELOPER: Srabanti Bose (SRBOSE)
* CREATION DATE:   2017-06-22
* OBJECT ID:E104 (CR 449)
* TRANSPORT NUMBER(S)ED2K906852
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* Line Item Pricing - Subtotals
PERFORM zz_line_item_subtotals IN PROGRAM sapmv45a IF FOUND
  USING komp-kposn                               " Condition item number
        xworke                                   " Condition Value - Subtotal E
        xworkg.                                  " Condition Value - Subtotal G
