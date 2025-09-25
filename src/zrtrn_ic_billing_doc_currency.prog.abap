*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_IC_BILLING_DOC_CURRENCY [Include Program]
* PROGRAM DESCRIPTION: Create IC Billing in Document Currency
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       09/18/2017
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K908588
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
  lst_ref_ord_h TYPE vbak.                            "Sales Document: Header Data

IF vbrp-aubel IS NOT INITIAL.
  CALL FUNCTION 'SD_VBAK_SINGLE_READ'
    EXPORTING
      i_vbeln          = vbrp-aubel                   "Reference Sales Document
    IMPORTING
      e_vbak           = lst_ref_ord_h                "Sales Document: Header Data
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc EQ 0.
    vbrk-waerk = kuagv-waerk = lst_ref_ord_h-waerk.   "SD Document Currency
  ENDIF.
ENDIF.
