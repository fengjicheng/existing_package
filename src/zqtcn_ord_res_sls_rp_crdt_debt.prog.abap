*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ORD_RES_SLS_REP_CRDT_DEBT (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: Populate Order Reason for Credit / Debit Memo
*                      Requests, generated for Sales Rep Change
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/13/2018
* OBJECT ID:       E131 (INC0205683)
* TRANSPORT NUMBER(S): ED1K908183
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_dev_id_e131 TYPE zdevid     VALUE 'E131',           "Development ID
    lc_ordr_reason TYPE rvari_vnam VALUE 'ORDER_REASON'.   "ABAP: Name of Variant Variable

  DATA:
    li_constants   TYPE zcat_constants.    "Constant Values

  IF t180-trtyp EQ charh AND                               "Create Mode
     vbak-augru IS INITIAL.                                "Order Reason is not populated
*   Get Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dev_id_e131
      IMPORTING
        ex_constants = li_constants.
    IF li_constants IS NOT INITIAL.
      SORT li_constants BY param1 param2 low.
*     Identify Order Reason based on SD Document Type
      READ TABLE li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
           WITH KEY param1 = lc_ordr_reason
                    param2 = space
                    low    = vbak-auart                    "SD DOcument Type
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        vbak-augru = <lst_constant>-high.                  "Order Reason
      ENDIF.
    ENDIF.
  ENDIF.
