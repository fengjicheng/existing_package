*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_TAX_LINE_DETAILS_DP (Include)
* [Called from Standard Subroutine SUBST_XNEGP(LFACIF10)]
* PROGRAM DESCRIPTION: Populate additional details for Tax Lines
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       08/12/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907915
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  li_non_dp_tx_itm TYPE accit_fi_tab.                      "FI: Interface to Accounting: Item Information

DATA:
  lv_dwn_paymnt_tx TYPE flag.                              "Indicator: Down Payment Specific Tax Items

LOOP AT accit_fi ASSIGNING FIELD-SYMBOL(<lst_accit_fi>)
     WHERE posnr GE '2000000000'                           "Down Payment Specific Items
       AND taxit EQ abap_true.                             "Indicator: Tax Item
  IF lv_dwn_paymnt_tx IS INITIAL.
    lv_dwn_paymnt_tx = abap_true.                          "Indicator: Down Payment Specific Tax Items

*   Identify Non-Down Payment Specific Tax Items
*   Delete Down Payment Specific Items and Non-Tax Items
    li_non_dp_tx_itm[] = accit_fi[].
    DELETE li_non_dp_tx_itm WHERE posnr GE '2000000000'    "Down Payment Specific Items
                               OR taxit EQ abap_false.     "Non-Tax Item
  ENDIF.

* Get details of Non-Down Payment Specific Tax Item
  READ TABLE li_non_dp_tx_itm ASSIGNING FIELD-SYMBOL(<lst_non_dp_tx_itm>) INDEX 1.
  IF sy-subrc EQ 0.
    <lst_accit_fi>-ktosl = <lst_non_dp_tx_itm>-ktosl.      "Transaction Key
    <lst_accit_fi>-kokrs = <lst_non_dp_tx_itm>-kokrs.      "Controlling Area

*   Get Accounting Interface: Currency Information
    READ TABLE acccr_fi ASSIGNING FIELD-SYMBOL(<lst_acccr_fi>)
         WITH KEY awtyp = <lst_accit_fi>-awtyp             "Reference Transaction
                  awref = <lst_accit_fi>-awref             "Reference Document Number
                  aworg = <lst_accit_fi>-aworg             "Reference Organizational Units
                  posnr = <lst_accit_fi>-posnr.            "Accounting Document Line Item Number
    IF sy-subrc EQ 0 AND
       <lst_acccr_fi>-wrbtr NE 0.
      <lst_accit_fi>-kbetr = '100.00'.                     "Rate (condition amount or percentage)
    ENDIF.
  ENDIF.
ENDLOOP.
